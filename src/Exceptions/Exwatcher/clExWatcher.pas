unit clExWatcher;

interface

uses
  Windows, SysUtils, Classes, Contnrs, clDbgHelp;

type
  TclExceptionInformation = class;
  TclStackTracer = class;

  TclDelphiExceptionEvent = procedure (Sender: TObject; E: Exception; EI: TclExceptionInformation; StackTracer: TclStackTracer) of object;
  TclSystemExceptionEvent = procedure (Sender: TObject; EI: TclExceptionInformation; StackTracer: TclStackTracer) of object;
  TclDelphiSafeCallExceptionEvent = procedure (Sender: TObject; Target: TObject; E: Exception; EI: TclExceptionInformation; StackTracer: TclStackTracer) of object;
  TclSystemSafeCallExceptionEvent = procedure (Sender: TObject; Target: TObject; EI: TclExceptionInformation; var NotifyTarget: Boolean; StackTracer: TclStackTracer) of object;

  TclExceptionInformation = class
  private
    FExcContext: TContext;
    FExcRecord: TExceptionRecord;
  public
    constructor Create(ExcContext: TContext; ExcRecord: TExceptionRecord);
    property ExceptionContext: TContext read FExcContext;
    property ExceptionRecord: TExceptionRecord read FExcRecord;
  end;

  TclExceptWatcher = class(TComponent)
  private
    FActive: Boolean;
    FLastExceptionInformation: TclExceptionInformation;
    FOnDelphiException: TclDelphiExceptionEvent;
    FOnSystemException: TclSystemExceptionEvent;
    FOnSafeCallException: TclSystemSafeCallExceptionEvent;
    FOnDelphiSafeCallException: TclDelphiSafeCallExceptionEvent;
    FStackTracer: TclStackTracer;
    procedure SetActive(const Value: Boolean);
    procedure NotifyException(ExcContext: PContext; ExcRecord: PExceptionRecord);
    function NotifySafeCallException(Sender: TObject; ExcContext: PContext; ExcRecord: PExceptionRecord): HRESULT;
    procedure SetLastExceptionInfo(ExcContext: PContext; ExcRecord: PExceptionRecord);
    function GetLastDelphiException: Exception;
    procedure SetStackTracer(const Value: TclStackTracer);
    function GetStackTracer: TclStackTracer;
  protected
    procedure DoDelphiException(E: Exception); dynamic;
    procedure DoSystemException(); dynamic;
    procedure DoDelphiSafeCallException(Target: TObject; E: Exception); dynamic;
    function DoSystemSafeCallException(Target: TObject): Boolean; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ClearLastExceptionInformation();
    property LastExceptionInformation: TclExceptionInformation read FLastExceptionInformation;
    property StackTracer: TclStackTracer read GetStackTracer write SetStackTracer;
  published
    property Active: Boolean read FActive write SetActive default True;
    property OnDelphiException: TclDelphiExceptionEvent read FOnDelphiException write FOnDelphiException;
    property OnSystemException: TclSystemExceptionEvent read FOnSystemException write FOnSystemException;
    property OnDelphiSafeCallException: TclDelphiSafeCallExceptionEvent read FOnDelphiSafeCallException write FOnDelphiSafeCallException;
    property OnSystemSafeCallException: TclSystemSafeCallExceptionEvent read FOnSafeCallException write FOnSafeCallException;
  end;

  TclStackFrame = class
  public
    ModuleName: string;
    CallAddress: Pointer;
    FunctionName: string;
    SourceName: string;
    LineNumber: Cardinal;
    procedure Assign(Source: TclStackFrame);
  end;

  TclStackFrames = class
  private
    FFrameList: TObjectList;
    function GetFrames(Index: Integer): TclStackFrame;
    function GetCount: Integer;
  protected
    procedure AddFrame(AFrame: TclStackFrame);
  public
    constructor Create();
    destructor Destroy(); override;
    procedure Clear();
    function Clone(): TclStackFrames;
    property Count: Integer read GetCount;
    property Frames[Index: Integer]: TclStackFrame read GetFrames; default;
  end;

  TclStackTracer = class
  private
    FFrames: TclStackFrames; 
    procedure FillFunctionInfo(AFrame: TclStackFrame);
    procedure InternalGetCallStack(pContext: PContext; Address: Pointer);
  protected
    procedure Prepare(pContext: PContext); virtual; abstract;
    function GetNextStackFrame(pContext: PContext): TclStackFrame; virtual; abstract;
    function GetFunctionName(pFunc: Pointer): string; virtual; abstract;
    function GetSourceInfo(var nLine: Cardinal; pProc: Pointer): string; virtual; abstract;
  public
    constructor Create();
    destructor Destroy(); override;
    function GetCallStack(EI: TclExceptionInformation): TclStackFrames;
    function GetCurrentCallStack(): TclStackFrames;
  end;

  TclDbgHelpStackTracer = class(TclStackTracer)
  private
    FStack: STACKFRAME;
    procedure LoadSym(pProc: Pointer);
    function GetSymbolSearchPath(): string;
    procedure Init();
    procedure Uninit();
  protected
    procedure Prepare(pContext: PContext); override;
    function GetFunctionName(pFunc: Pointer): string; override;
    function GetSourceInfo(var nLine: Cardinal; pProc: Pointer): string; override;
    function GetNextStackFrame(pContext: PContext): TclStackFrame; override;
  public
    constructor Create();
    destructor Destroy(); override;
  end;

procedure Register;
procedure InitExwatcher;

implementation

type
  PExcFrame = ^TExcFrame; //from system.pas
  TExcFrame = record
    next: PExcFrame;
    desc: Pointer;
    hEBP: Pointer;
    case Integer of
    0:  ( );
    1:  ( ConstructedObject: Pointer );
    2:  ( SelfOfMethod: Pointer );
  end;

  PclExcFrame = ^TclExcFrame;
  TclExcFrame = record
    next: PclExcFrame;
    desc: Pointer;
    safe_place: Pointer;
    safe_ebp: DWORD;
  end;

  TclExceptionHooker = class
  public
    class procedure clSetOwnExceptionHandler();
    class procedure clPatchOnExceptionHandler();
    class procedure clPatchHandleAnyExceptionHandler();
    class procedure clPatchMainExceptionHandler();
    class procedure clPatchSafeCallExceptionHandler(); safecall;
    class function clGetExceptionHandler(ExcFrame: TExcFrame): Pointer;
    class function clGetTopExceptionHandler(): Pointer;
    class function clGetFirstDelphiExcepionHandler(): Pointer;
    class procedure clExtractOldHandler(pProc: Pointer; pProcCode: Pointer);
    class procedure clWriteNewHandler(pProc: Pointer; pNewProc: Pointer);
  end;

const
  cUnwinding          = 2;
  cUnwindingForExit   = 4;
  cUnwindInProgress   = cUnwinding or cUnwindingForExit;
  cDelphiException    = $0EEDFADE;
  cDelphiReRaise      = $0EEDFADF;

//threadvar
Var RootWatcher: TclExceptWatcher;

procedure Register;
begin
  RegisterComponents('Clever Components', [TclExceptWatcher]);
end;
  
{ TclExceptionInformation }

constructor TclExceptionInformation.Create(ExcContext: TContext; ExcRecord: TExceptionRecord);
begin
  inherited Create();
  FExcContext := ExcContext;
  FExcRecord := ExcRecord;
end;

{ TclExceptWatcher }

type
  GetExceptionObjectProc = function(P: PExceptionRecord): Exception;

function TclExceptWatcher.NotifySafeCallException(Sender: TObject; ExcContext: PContext; ExcRecord: PExceptionRecord): HRESULT;
var
  E: Exception;
begin
  Result := E_FAIL;
  SetLastExceptionInfo(ExcContext, ExcRecord);
  if (ExcRecord^.ExceptionCode <> cDelphiException) then
  begin
    if (DoSystemSafeCallException(Sender)) then
    begin
      E := GetExceptionObjectProc(ExceptObjProc)(ExcRecord);
      Result := Sender.SafeCallException(E, ExcRecord^.ExceptionAddress);
      E.Free();
    end;
  end else
  begin
    DoDelphiSafeCallException(Sender, GetLastDelphiException());
  end;
end;

function TclExceptWatcher.GetLastDelphiException(): Exception;
begin
  Result := nil;
  if (LastExceptionInformation <> nil) and
    (LastExceptionInformation.ExceptionRecord.ExceptionCode = cDelphiException) and
    (LastExceptionInformation.ExceptionRecord.NumberParameters > 1) then
  begin
    Result := Exception(LastExceptionInformation.ExceptionRecord.ExceptionInformation[1]);
  end;
end;

procedure TclExceptWatcher.NotifyException(ExcContext: PContext; ExcRecord: PExceptionRecord);
begin
  SetLastExceptionInfo(ExcContext, ExcRecord);
  if (ExcRecord^.ExceptionCode <> cDelphiException)
    and (ExcRecord^.ExceptionCode <> cDelphiReRaise) then
  begin
    DoSystemException();
  end else
  begin
    DoDelphiException(GetLastDelphiException());
  end;
end;

procedure TclExceptWatcher.SetLastExceptionInfo(ExcContext: PContext; ExcRecord: PExceptionRecord);
begin
  ClearLastExceptionInformation();
  FLastExceptionInformation := TclExceptionInformation.Create(ExcContext^, ExcRecord^);
end;

procedure TclExceptWatcher.DoDelphiException(E: Exception);
begin
  if Assigned(OnDelphiException) then
  begin
    OnDelphiException(Self, E, LastExceptionInformation, StackTracer);
  end;
end;

procedure TclExceptWatcher.ClearLastExceptionInformation();
begin
  FreeAndNil(FLastExceptionInformation);
end;

destructor TclExceptWatcher.Destroy;
begin
  Active := False;
  ClearLastExceptionInformation();
  FreeAndNil(FStackTracer);
  inherited Destroy();
end;

procedure TclExceptWatcher.SetActive(const Value: Boolean);
begin
  if (FActive <> Value) then
  begin
    if FActive then
    begin
      RootWatcher := nil;
    end;
    FActive := Value;
    if FActive then
    begin
      RootWatcher := Self;
    end;
  end;
end;

procedure TclExceptWatcher.DoSystemException();
begin
  if Assigned(OnSystemException) then
  begin
    OnSystemException(Self, LastExceptionInformation, StackTracer);
  end;
end;

procedure TclExceptWatcher.DoDelphiSafeCallException(Target: TObject; E: Exception);
begin
  if (Assigned(OnDelphiSafeCallException)) then
  begin
    OnDelphiSafeCallException(Self, Target, E, LastExceptionInformation, StackTracer);
  end;
end;

function TclExceptWatcher.DoSystemSafeCallException(Target: TObject): Boolean;
begin
  Result := True;
  if (Assigned(OnSystemSafeCallException)) then
  begin
    OnSystemSafeCallException(Self, Target, LastExceptionInformation, Result, StackTracer);
  end;
end;

constructor TclExceptWatcher.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Active := True;
end;

procedure TclExceptWatcher.SetStackTracer(const Value: TclStackTracer);
begin
  FreeAndNil(FStackTracer);
  FStackTracer := Value;
end;

function TclExceptWatcher.GetStackTracer(): TclStackTracer;
begin
  if (FStackTracer = nil) then
    FStackTracer := TclDbgHelpStackTracer.Create();
  Result := FStackTracer;
end;

{ TclStackFrames }

procedure TclStackFrames.AddFrame(AFrame: TclStackFrame);
begin
  FFrameList.Add(AFrame);
end;

procedure TclStackFrames.Clear();
begin
  FFrameList.Clear();
end;

function TclStackFrames.Clone(): TclStackFrames;
var
  i: Integer;
  Frame: TclStackFrame;
begin
  Result := TclStackFrames.Create();
  for i := 0 to Count - 1 do
  begin
    Frame := TclStackFrame.Create();
    Frame.Assign(Frames[i]);
    Result.AddFrame(Frame);
  end;
end;

constructor TclStackFrames.Create;
begin
  FFrameList := TObjectList.Create();
end;

destructor TclStackFrames.Destroy();
begin
  FFrameList.Free();
  inherited Destroy();
end;

function TclStackFrames.GetCount: Integer;
begin
  Result := FFrameList.Count;
end;

function TclStackFrames.GetFrames(Index: Integer): TclStackFrame;
begin
  Result := TclStackFrame(FFrameList[Index]);
end;

{ TclStackTracer }

function TclStackTracer.GetCallStack(EI: TclExceptionInformation): TclStackFrames;
begin
  InternalGetCallStack(@EI.ExceptionContext, EI.ExceptionRecord.ExceptionAddress);
  Result := FFrames;
end;

function TclStackTracer.GetCurrentCallStack(): TclStackFrames;
var
  Context: TContext;
begin
  Context.ContextFlags := CONTEXT_FULL;
  GetThreadContext(GetCurrentThread(), Context);
  InternalGetCallStack(@Context, nil);
  Result := FFrames;
end;

const
  MaxStackDepth = 99;

procedure TclStackTracer.FillFunctionInfo(AFrame: TclStackFrame);
var
  sName: array[0..$FF] of char;
  mbi: MEMORY_BASIC_INFORMATION;
begin
	if (VirtualQuery(AFrame.CallAddress, mbi, sizeof(mbi)) = 0) or (mbi.State <> MEM_COMMIT) then
		Exit;
	if (GetModuleFileName(HMODULE(mbi.AllocationBase), @sName, 256) = 0) then
		Exit;
  AFrame.ModuleName := PChar(@sName);
  AFrame.FunctionName := GetFunctionName(AFrame.CallAddress);
  AFrame.CallAddress := Pointer(Integer(AFrame.CallAddress) - 5); //sizeof 'call xxx'
  AFrame.SourceName := '';
  AFrame.LineNumber := 0;
end;

procedure TclStackTracer.InternalGetCallStack(pContext: PContext; Address: Pointer);
var
  i: Integer;
  Frame: TclStackFrame;
begin
  FFrames.Clear();
  if (pContext = nil) then
    Exit;
  Prepare(pContext);
  for i := 0 to MaxStackDepth do
  begin
    Frame := GetNextStackFrame(pContext);
    if (Frame = nil) then
      Break;
    FillFunctionInfo(Frame);
    FFrames.AddFrame(Frame);
  end;
  if (Address <> nil) and (FFrames.Count = 0) then
  begin
    Frame := TclStackFrame.Create();
    Frame.CallAddress := Address;
    FillFunctionInfo(Frame);
    FFrames.AddFrame(Frame);
  end;
end;

constructor TclStackTracer.Create();
begin
  inherited Create();
  FFrames := TclStackFrames.Create();
end;

destructor TclStackTracer.Destroy();
begin
  FreeAndNil(FFrames);
  inherited Destroy();
end;

{ TclDbgHelpStackTracer }

const
  SYMBOL_PATH = '_NT_SYMBOL_PATH';
  ALTERNATE_SYMBOL_PATH = '_NT_ALT_SYMBOL_PATH';

function GetEnvironmentVariable1(Name : String) : String;
Var buffer : array[0..1024] of char;
begin
   GetEnvironmentVariable(PChar(Name), Buffer, sizeof(Buffer));
   result := strpas(BUffer);
end;

function TclDbgHelpStackTracer.GetSymbolSearchPath(): string;
var
  sPath: array[0..MAX_PATH] of char;
  mbi: MEMORY_BASIC_INFORMATION;
  pProc: Pointer;
label l1;  
begin
  asm
    mov eax, offset l1
    mov pProc, eax
  end;
l1:
  Result := '';
  if (GetEnvironmentVariable1(SYMBOL_PATH) <> '') then
    Result := GetEnvironmentVariable1(SYMBOL_PATH) + ';';
  if (GetEnvironmentVariable(ALTERNATE_SYMBOL_PATH) <> '') then
    Result := Result + GetEnvironmentVariable1(ALTERNATE_SYMBOL_PATH) + ';';
  if (GetEnvironmentVariable1('SystemRoot') <> '') then
    Result := Result + GetEnvironmentVariable1('SystemRoot') + ';';

	VirtualQuery(pProc, mbi, sizeof(mbi));
	GetModuleFileName(Cardinal(mbi.AllocationBase), sPath, MAX_PATH);
	StrRScan(sPath, '\')^ := #0;
	Result := Result + sPath + ';';

	GetModuleFileName(0, sPath, MAX_PATH);
	StrRScan(sPath, '\')^ := #0;
  Result := Result + sPath;
end;

procedure TclDbgHelpStackTracer.Init();
begin
	SymSetOptions(SYMOPT_UNDNAME or SYMOPT_DEFERRED_LOADS or SYMOPT_LOAD_LINES);
	clSymInitialize(GetCurrentProcess(), GetSymbolSearchPath(), True);
	SymSetOptions(SYMOPT_UNDNAME or SYMOPT_LOAD_LINES);
end;

procedure TclDbgHelpStackTracer.Uninit();
begin
	SymCleanup(GetCurrentProcess());
end;

constructor TclDbgHelpStackTracer.Create();
begin
  inherited Create();
  Init();
end;

destructor TclDbgHelpStackTracer.Destroy();
begin
  Uninit();
  inherited Destroy();
end;

procedure TclDbgHelpStackTracer.LoadSym(pProc: Pointer);
var
  sPath: array[0..4095] of char;
  mbi: MEMORY_BASIC_INFORMATION;
begin
	VirtualQuery(pProc, mbi, sizeof(mbi));
	GetModuleFileName(Cardinal(mbi.AllocationBase), sPath, MAX_PATH);
	SymLoadModule(GetCurrentProcess(), 0, sPath, nil, DWORD(mbi.AllocationBase), 0);
end;

procedure TclDbgHelpStackTracer.Prepare(pContext: PContext);
begin
  ZeroMemory(@FStack, sizeof(STACKFRAME));
  FStack.AddrPC.Offset := pContext.Eip;
  FStack.AddrPC.Mode := DWORD(AddrModeFlat);
  FStack.AddrStack.Offset := pContext.Esp;
  FStack.AddrStack.Mode   := DWORD(AddrModeFlat);
  FStack.AddrFrame.Offset := pContext.Ebp;
  FStack.AddrFrame.Mode   := DWORD(AddrModeFlat);
end;

function TclDbgHelpStackTracer.GetNextStackFrame(pContext: PContext): TclStackFrame;
begin
  Result := nil;
  if (0 = StackWalk(IMAGE_FILE_MACHINE_I386,	GetCurrentProcess(), GetCurrentThread(),
      @FStack, nil{pContext}, nil, SymFunctionTableAccess, SymGetModuleBase, nil)) then
  begin
    Exit;
  end;
  Result := TclStackFrame.Create();
  Result.CallAddress := Pointer(FStack.AddrPC.Offset);
end;

function TclDbgHelpStackTracer.GetFunctionName(pFunc: Pointer): string;
var
  dwDisplacement: DWORD;
  buffer: array[0..$1FF] of BYTE;
  pSymbol: PIMAGEHLP_SYMBOL;
begin
  Result := '';
	pSymbol := PIMAGEHLP_SYMBOL(@buffer);
	pSymbol.SizeOfStruct := sizeof(IMAGEHLP_SYMBOL);
	pSymbol.MaxNameLength := sizeof(buffer) - sizeof(IMAGEHLP_SYMBOL) + 1;
	LoadSym(pFunc);
	if (SymGetSymFromAddr(GetCurrentProcess(), DWORD(pFunc), dwDisplacement, pSymbol)) then
  begin
    Result := PChar(@pSymbol.Name);
	end;
end;

function TclDbgHelpStackTracer.GetSourceInfo(var nLine: Cardinal; pProc: Pointer): string;
var
  dwDisplacement: DWORD;
  buffer: array[0..$1FF] of BYTE;
  pLine: PIMAGEHLP_LINE;
begin
  Result := '';
	pLine := PIMAGEHLP_LINE(@buffer);
	pLine.SizeOfStruct := sizeof(IMAGEHLP_LINE);
  LoadSym(pProc);
	if (SymGetLineFromAddr(GetCurrentProcess(), DWORD(pProc), dwDisplacement, pLine)) then
  begin
		nLine := pLine.LineNumber;
    Result := pLine.FileName;
	end;
end;

{ TclExceptionHooker }

{ system.pas }

procedure clExWatcherProcImpl(ExcContext: PContext; ExcRecord: PExceptionRecord); stdcall;
begin
  if (ExcRecord^.ExceptionFlags and cUnwindInProgress = 0) then
  begin
    if (RootWatcher <> nil) then
    begin
      RootWatcher.NotifyException(ExcContext, ExcRecord);
    end;
  end;
end;

function clHandleAutoProcImpl(Sender: TObject; ExcContext: PContext; ExcRecord: PExceptionRecord): HRESULT; stdcall;
begin
  Result := E_FAIL;
  if (ExcRecord^.ExceptionFlags and cUnwindInProgress = 0) then
  begin
    if (RootWatcher <> nil) then
    begin
      Result := RootWatcher.NotifySafeCallException(Sender, ExcContext, ExcRecord);
    end;
  end;
end;

const
  cHackSize = 11;

var
  pOldExceptionHandlerCode: array[0..20] of Byte;
  pOldHandleAnyExceptionCode: array[0..20] of Byte;
  pOldHandleOnExceptionCode: array[0..20] of Byte;
  pOldHandleAutoExceptionCode: array[0..20] of Byte;

  { ->    [ESP+ 4] excPtr: PExceptionRecord       }
  {       [ESP+ 8] errPtr: PExcFrame              }
  {       [ESP+12] ctxPtr: Pointer                }
  {       [ESP+16] dspPtr: Pointer                }

procedure clDefaultHandler(excPtr: PExceptionRecord; errPtr: Pointer; ctxPtr: PContext; dspPtr: Pointer); stdcall;
asm
  push esi
  push ebx
  mov ebx, excPtr
  test [ebx].TExceptionRecord.ExceptionFlags, 1
  jnz @@l5
  test [ebx].TExceptionRecord.ExceptionFlags, cUnwindInProgress
  jz @@l2
  jmp @@l5
@@l2:
//  push 0
//  push ebx
//  push offset @@un23
//  push errPtr
//  call RtlUnwindProc
@@un23:
  mov esi, ctxPtr
  mov ebx, errPtr
  mov [esi + $C4], ebx {[esi].TContext.Esp}
  mov eax, [ebx].TclExcFrame.safe_place
  mov [esi].TContext.Eip, eax
  mov eax, [ebx].TclExcFrame.safe_ebp
  mov [esi + $B4], eax {[esi].TContext.Ebp}
  xor eax, eax
  jmp @@l6
@@l5:
  mov eax, 1
@@l6:
  pop ebx
  pop esi
end;

procedure clExceptHandler;
asm
  {eax - pOldProcCode}
  push ebp
  mov ebp, esp
  push eax

  push ebp
  push offset @@l1 //safe place
  push offset clDefaultHandler
  push fs:[0]
  mov fs:[0], esp

  push [ebp + 8]
  push [ebp + 16]
  call clExWatcherProcImpl
@@l1:
  pop fs:[0]
  add esp, 12
  pop eax
  mov esp, ebp
  pop ebp
  jmp eax
end;

procedure clHandleAnyException;
asm
  lea eax, pOldHandleAnyExceptionCode
  jmp clExceptHandler
end;

procedure clHandleOnException;
asm
  lea eax, pOldHandleOnExceptionCode
  jmp clExceptHandler
end;

procedure clExceptionHandler;
asm
  lea eax, pOldExceptionHandlerCode
  jmp clExceptHandler
end;

procedure clHandleAutoException;
asm
  push ebp
  mov ebp, esp

  push ebp //safe stack frame
  push offset @@l1 //safe place
  push offset clDefaultHandler
  push fs:[0]
  mov fs:[0], esp

  mov eax, [ebp + 12]
  mov eax, [eax].TExcFrame.SelfOfMethod

  push [ebp + 8]
  push [ebp + 16]
  push eax
  call clHandleAutoProcImpl
  mov ebx, eax //Don't work now
@@l1:
  pop fs:[0]
  add esp, 12
  mov esp, ebp
  pop ebp
  lea eax, pOldHandleAutoExceptionCode
  jmp eax
end;

class function TclExceptionHooker.clGetExceptionHandler(ExcFrame: TExcFrame): Pointer;
asm
  {eax - ExcFrame}
  mov eax, [eax].TExcFrame.desc
  cmp byte ptr [eax], $E9 //jmp
  jne @@exit
  mov ebx, [eax + 1]
  add eax, ebx
  add eax, 5 //sizeof(jmp xxx)
@@exit:
end;

class function TclExceptionHooker.clGetTopExceptionHandler(): Pointer;
asm
  mov eax, fs:[0]
  call clGetExceptionHandler
end;

class function TclExceptionHooker.clGetFirstDelphiExcepionHandler(): Pointer;
asm
  mov eax, fs:[0]
  mov ebx, eax
@@loop:
  cmp [eax].TExcFrame.next, -1
  je @@last_handler
  mov ebx, eax
  mov eax, [eax].TExcFrame.next
  jmp @@loop
@@last_handler:
  mov eax, ebx
  call clGetExceptionHandler
end;

class procedure TclExceptionHooker.clExtractOldHandler(pProc: Pointer; pProcCode: Pointer);
asm
  mov eax, ecx
  xchg eax, edx
  {eax - pProc, edx - pProcCode}
  push esi
  push edi
  mov ecx, cHackSize
  mov esi, eax
  mov edi, edx
  rep movsb
  mov byte ptr [edi], $E9 //jmp
  add eax, cHackSize
  sub eax, edi
  sub eax, 5 //sizeof(jmp xxx)
  mov dword ptr [edi + 1], eax
  pop edi
  pop esi
end;

class procedure TclExceptionHooker.clWriteNewHandler(pProc: Pointer; pNewProc: Pointer);
var
  mbi: TMemoryBasicInformation;
  OldProtect: Cardinal;
begin
  VirtualQuery(pProc, mbi, sizeof(mbi));
  VirtualProtect(mbi.BaseAddress, mbi.RegionSize, PAGE_EXECUTE_READWRITE, OldProtect);
  asm
    mov eax, pProc
    mov ebx, pNewProc
    mov byte ptr [eax], $E9 //jmp
    sub ebx, eax
    sub ebx, 5 //sizeof(jmp xxx)
    mov dword ptr [eax + 1], ebx
  end;
  VirtualProtect(mbi.BaseAddress, mbi.RegionSize, OldProtect, OldProtect);
end;

class procedure TclExceptionHooker.clPatchSafeCallExceptionHandler(); safecall;
var
  pOldHandleAutoException: Pointer;
begin
  pOldHandleAutoException := clGetTopExceptionHandler();
  clExtractOldHandler(pOldHandleAutoException, @pOldHandleAutoExceptionCode[0]);
  clWriteNewHandler(pOldHandleAutoException, @clHandleAutoException);
end;

class procedure TclExceptionHooker.clPatchMainExceptionHandler();
var
  pOldExceptionHandler: Pointer;
begin
  pOldExceptionHandler := clGetFirstDelphiExcepionHandler();
  clExtractOldHandler(pOldExceptionHandler, @pOldExceptionHandlerCode[0]);
  clWriteNewHandler(pOldExceptionHandler, @clExceptionHandler);
end;

class procedure TclExceptionHooker.clPatchHandleAnyExceptionHandler();
var
  pOldHandleAnyException: Pointer;
begin
  try
    pOldHandleAnyException := clGetTopExceptionHandler();
    clExtractOldHandler(pOldHandleAnyException, @pOldHandleAnyExceptionCode[0]);
    clWriteNewHandler(pOldHandleAnyException, @clHandleAnyException);
  except
  end;
end;

class procedure TclExceptionHooker.clPatchOnExceptionHandler();
var
  pOldHandleOnException: Pointer;
begin
  try
    pOldHandleOnException := clGetTopExceptionHandler();
    clExtractOldHandler(pOldHandleOnException, @pOldHandleOnExceptionCode[0]);
    clWriteNewHandler(pOldHandleOnException, @clHandleOnException);
  except
    on E: Exception do ;
  end;
end;

class procedure TclExceptionHooker.clSetOwnExceptionHandler();
begin
  clPatchMainExceptionHandler();
  clPatchHandleAnyExceptionHandler();
  clPatchOnExceptionHandler();
  clPatchSafeCallExceptionHandler();
end;

{ TclStackFrame }

procedure TclStackFrame.Assign(Source: TclStackFrame);
begin
  ModuleName := Source.ModuleName;
  CallAddress := Source.CallAddress;
  FunctionName := Source.FunctionName;
  SourceName := Source.SourceName;
  LineNumber := Source.LineNumber;
end;

procedure InitExwatcher;
begin
  ZeroMemory(@pOldExceptionHandlerCode[0], 21);
  ZeroMemory(@pOldHandleAnyExceptionCode[0], 21);
  ZeroMemory(@pOldHandleOnExceptionCode[0], 21);
  ZeroMemory(@pOldHandleAutoExceptionCode[0], 21);
  TclExceptionHooker.clSetOwnExceptionHandler();
end;

end.
