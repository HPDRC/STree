unit MemoryChecker;

interface

const _GlobalID  : integer = 0;
const StoredCallStackDepth = 16;
type TCallStack = array[0..StoredCallStackDepth-1] of Pointer;

type
   PMemoryCaller = ^TMemoryCaller;
   TMemoryCaller = record
       AllocatedCount : integer;
       Size : integer;
       Rank : integer;
       HashNext : PMemoryCaller;
       Stack : TCallstack;
   end;

const MemoryCallers : array of TMemoryCaller = nil;
const NumCallers : integer = 0;
const SortedMemoryCallers : array of integer = nil;

type PMemoryBlock = ^TMemoryBlock;
     TMemoryBlock = record
       BlockID : integer;
       HashNext : PMemoryBlock;
       MemoryCaller : PMemoryCaller;
       Size : integer;
end;

procedure  InstallMemoryChecker;
procedure  SortMemoryCallers;

implementation
uses SyncObjs, Sysutils, clDbgHelp, Contnrs, classes, windows, myutil1;

Var CSMem : TCriticalSection;

const HashMax = 1024* 256;
Var Hash : array[0..HashMax] of PMemoryBlock;
    GlobalTable : packed array[0..1000000] of boolean;
Var HashTable : array[0..HashMax] of PMemoryBlock;
Var	OldMemoryManager: TMemoryManager;
Var StackHash : array[0..HashMax] of PMemoryCaller;


procedure FillCallStack(var St: TCallStack; const LevelsToExclude: integer);
var
  Context: TContext;
  FStack: STACKFRAME;
  i, c : integer;
  Process, Thread : THandle;
begin
  Context.ContextFlags := CONTEXT_FULL;
  GetThreadContext(GetCurrentThread(), Context);
  ZeroMemory(@FStack, sizeof(STACKFRAME));
  ZeroMemory(@St, sizeof(st));
  FStack.AddrPC.Offset := Context.Eip;
  FStack.AddrPC.Mode := DWORD(AddrModeFlat);
  FStack.AddrStack.Offset := Context.Esp;
  FStack.AddrStack.Mode   := DWORD(AddrModeFlat);
  FStack.AddrFrame.Offset := Context.Ebp;
  FStack.AddrFrame.Mode   := DWORD(AddrModeFlat);
  c := 0;
  Process := GetCurrentProcess();
  Thread := GetCurrentThread();
  for i := 0 to StoredCallStackDepth - 1 do
     begin
       if (0 = StackWalk(IMAGE_FILE_MACHINE_I386,	Process, Thread,
          @FStack, nil{pContext}, nil, SymFunctionTableAccess, SymGetModuleBase, nil)) then
          break;
       if i >= LevelsToExclude then
          begin
             st[c] := Pointer(FStack.AddrPC.Offset);
             inc(c);
          end;
     end;
end;

procedure LoadSym(pProc: Pointer);
var
  sPath: array[0..4095] of char;
  mbi: MEMORY_BASIC_INFORMATION;
begin
	VirtualQuery(pProc, mbi, sizeof(mbi));
	GetModuleFileName(Cardinal(mbi.AllocationBase), sPath, MAX_PATH);
	SymLoadModule(GetCurrentProcess(), 0, sPath, nil, DWORD(mbi.AllocationBase), 0);
end;

function GetFunctionName(pFunc: Pointer): string;
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

const Initialized : boolean = false;
const SymbolSearchPath : String = '';
const
  SYMBOL_PATH = '_NT_SYMBOL_PATH';
  ALTERNATE_SYMBOL_PATH = '_NT_ALT_SYMBOL_PATH';


function GetEnvironmentVariable1(Name : String) : String;
Var buffer : array[0..1024] of char;
begin
   GetEnvironmentVariable(PChar(Name), Buffer, sizeof(Buffer));
   result := strpas(BUffer);
end;

function GetSymbolSearchPath(): string;
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


procedure Init;
begin
	SymSetOptions(SYMOPT_UNDNAME or SYMOPT_DEFERRED_LOADS or SYMOPT_LOAD_LINES);
	clSymInitialize(GetCurrentProcess(), SymbolSearchPath, True);
	SymSetOptions(SYMOPT_UNDNAME or SYMOPT_LOAD_LINES);
end;

function FunctionInfo(CallAddress : pointer) : String;
var
  sName: array[0..$FF] of char;
  mbi: MEMORY_BASIC_INFORMATION;
  dwDisplacement: DWORD;
  buffer: array[0..$1FF] of BYTE;
  pLine: PIMAGEHLP_LINE;
  nLine : integer;
  FunctionName, FileName, ModuleName : String;
begin
  if not Initialized then
     begin
        Initialized := true;
        Init;
     end;
	if (VirtualQuery(CallAddress, mbi, sizeof(mbi)) = 0) or (mbi.State <> MEM_COMMIT) then
		Exit;
	if (GetModuleFileName(HMODULE(mbi.AllocationBase), @sName, 256) = 0) then
		Exit;
  ModuleName := PChar(@sName);
  FunctionName := GetFunctionName(CallAddress);
//  AFrame.CallAddress := Pointer(Integer(AFrame.CallAddress) - 5); //sizeof 'call xxx'
	pLine := PIMAGEHLP_LINE(@buffer);
	pLine.SizeOfStruct := sizeof(IMAGEHLP_LINE);
  LoadSym(CallAddress);
	if (SymGetLineFromAddr(GetCurrentProcess(), DWORD(CallAddress), dwDisplacement, pLine)) then
  begin
		nLine := pLine.LineNumber;
    FileName := pLine.FileName;
	end;
  Result := Format('  %p(%s in %s %s:%d)', [CallAddress, FunctionName, Modulename, FileName, nline]); 
end;

function StackToStr(Var S : TCallStack) : String;
Var i : integer;
begin
   Result := '';
   for i := 0 to StoredCallStackDepth do
      if S[i] = nil then
         break
      else
         Result := Result + format(' %p', [S[i]]);
end;

procedure   SaveCaller(Var F : TextFile; C : TmemoryCaller);
begin
   Writeln(F, 'Allocated=', C.AllocatedCount, '; Size=', C.Size, '; Stack=', StackToStr(C.Stack));
end;

procedure  SortMemoryCallers;
Var T, i : integer;
    F : TextFile;
  function getRank(i : integer) : integer;
  begin
     Result := MemoryCallers[SortedMemoryCallers[i]].AllocatedCount*MemoryCallers[SortedMemoryCallers[i]].Size;
  end;
  procedure QuickSort(L, R: Integer);
  var
    I, J : Integer;
    T, X : integer;
  begin
    I := L;
    J := R;
    X := GetRank((L + R) div 2);
    repeat
      while GetRank(i) > X do Inc(I);
      while X > GetRank(J) do Dec(J);
      if I <= J then
      begin
        T := SortedMemoryCallers[I];
        SortedMemoryCallers[I] := SortedMemoryCallers[J];
        SortedMemoryCallers[J] := T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J);
    if I < R then QuickSort(I, R);
  end;
begin
   for i := 0 to NumCallers -1 do
     SortedMemoryCallers[i] := i;
   QuickSort(0, NumCallers - 1);
   AssignFile(F, gethardRootDir1 + 'Memory.log');
   rewrite(F);
   T := 0;
   for i := 0 to NumCallers - 1 do
      begin
         T := T + MemoryCallers[SortedMemoryCallers[i]].AllocatedCount * MemoryCallers[SortedMemoryCallers[i]].Size;
         MemoryCallers[SortedMemoryCallers[i]].Rank := i;
         if MemoryCallers[SortedMemoryCallers[i]].AllocatedCount > 0 then
           SaveCaller(F, MemoryCallers[SortedMemoryCallers[i]]);
      end;
   writeln(F, format('Total: %d', [T]));
   closefile(F);
end;

function HashFun(H : pointer) : integer;
begin
   result := Abs(integer(H)) mod HashMax;
end;

procedure FillCallStack1(var St: TCallStack; const NbLevelsToExclude: integer);
	{Works only with stack frames - Without, St contains correct info, but is not as deep as it should
	I just don't know a general rule for walking the stack when they are not there}
var
	StackStart: Pointer;
	StackMax: Pointer;	//the stack can never go beyond - http://msdn.microsoft.com/library/periodic/period96/S2CE.htm
	CurrentFrame: Pointer;
	Count, SkipCount: integer;
begin
	FillChar(St, SizeOf(St), 0);
	asm
		mov EAX, FS:[4]
		mov StackMax, EAX
		mov StackStart, EBP
	end;
	CurrentFrame:= StackStart;
	Count:= 0;
	SkipCount:= 0;
	while (longint(CurrentFrame) >= longint(StackStart)) and (longint(CurrentFrame) < longint(StackMax)) and (Count <= StoredCallStackDepth) do
		begin
			if SkipCount >= NbLevelsToExclude then
				begin
					St[Count]:= Pointer(PInteger(longint(CurrentFrame) + 4)^ - 4);
					Count:= Count + 1;
				end;
			CurrentFrame:= Pointer(PInteger(CurrentFrame)^);
			SkipCount:= SkipCount + 1;
		end;
end;

function StackHashFun(Var S : TCallStack) : integer;
Var i : integer;
begin
   for i := 4 to 10 do
      inc(Result, abs(integer(S[i])) mod HashMax shl (i mod 3));
   if result < 0 then
      result := -result;
   Result := Result mod HashMax;
end;

function FindMemoryCaller : PMemoryCaller; forward;

function MyGetMem(Size: Integer): Pointer;
Var Blk : PMemoryBlock;
    H : integer;
begin
  CSMem.Enter;
  try
  Blk := PMemoryBlock(OldMemoryManager.GetMem(Size + (SizeOf(TMemoryBlock))));
  Result := pointer(integer(Blk) + SizeOf(TMemoryBlock));
  inc(_GlobalID);
  if _GlobalID >= sizeof(GlobalTable) then
     _GlobalID := 0;
  if GlobalTable[_GlobalID] then
     GlobalTable[_GlobalID] := false;  // set a breapoint here
  GlobalTable[_GlobalID] := true;
  Blk^.BlockID := _GlobalID;
  Blk^.Size := Size;
  Blk^.MemoryCaller := FindMemoryCaller;
  inc(Blk^.MemoryCaller^.AllocatedCount);
  Blk^.MemoryCaller^.Size := Size;
  H := HashFun(Blk);
  Blk^.HashNext := Hash[H];
  Hash[H] := Blk;
  finally
     CSMem.Leave;
  end;
end;

function MyFreeMem1(P: Pointer; ActualFree : boolean; Var F: PMemoryBlock): Integer;
Var PP, Blk: PMemoryBlock;
    H : integer;
begin
  CSMem.Enter;
  try
   Blk := PMemoryBlock(integer(P) - SizeOf(TMemoryBlock));
   H := HashFun(Blk);
   F := Hash[H];
   PP := F;
   while (F <> Blk) and (F <> nil) do
      begin
        PP := F;
        F := F^.HashNext;
      end;
   if F <> Blk then
      Result := OldMemoryManager.FreeMem(P)
   else
     begin
       if PP = F then
          Hash[H] := F^.HashNext
       else
          PP^.HashNext := F^.HashNext;
       if Blk^.BlockID < sizeof(GlobalTable) then
          GlobalTable[Blk^.BlockID] := false;
       dec(Blk^.MemoryCaller^.AllocatedCount);
       if Blk^.MemoryCaller^.AllocatedCount < 0 then
          Blk^.MemoryCaller^.AllocatedCount := 0;
       if ActualFree then
         Result := OldMemoryManager.FreeMem(F);
     end;
  finally
     CSMem.Leave;
  end;
end;

function MyFreeMem(P: Pointer): Integer;
Var F: PMemoryBlock;
begin
   result := MyFreeMem1(P, true, F);
end;


function MyReallocMem(P: Pointer; Size: Integer): Pointer;
Var F : PMemoryBlock;
begin
  CSMem.Enter;
  try
   MyFreeMem1(P, false, F);
   if F <> nil then
      begin
        Result := MyGetMem(Size);
        if Size > F^.Size then
          Size := F^.Size
        else
          Size := Size;
        Move(P^, Result^, Size);
        OldMemoryManager.Freemem(F);
      end;
  finally
     CSMem.Leave;
  end;
end;

const
	MyMemoryManager: TMemoryManager = (
		GetMem: MyGetMem;
		FreeMem: MyFreeMem;
		ReallocMem: MyReallocMem;
		);

procedure  InstallMemoryChecker;
Var i : integer;
begin
   _GlobalID := 0;
   for i := 0 to HashMax do
      begin
        Hash[i] := nil;
        StackHash[i] := nil;
      end;
   for i := 0 to sizeof(GlobalTable) - 1 do
      GlobalTable[i] := false;
   GetMemoryManager(OldMemoryManager);
   SetMemoryManager(MyMemoryManager);
end;

function Differ(Var S1, S2 : TCallStack) : boolean;
Var i : integer;
begin
   for i := 4 to 10  do
      if S1[i] <> S2[i] then
         begin
            Result := true;
            exit;
         end;
   Result := false;
end;

function FindMemoryCaller : PMemoryCaller;
Var Stack : TCallStack;
    H : integer;
begin
    FillCallStack(Stack, 0);
    H := StackHashFun(Stack);
    Result := StackHash[H];
    while (Result <> nil) and Differ(Result^.Stack, Stack) do
       Result := Result^.HashNext;
    if Result = nil then
       begin
          if NumCallers >= length(MemoryCallers) then
             begin
                raise exception.Create('Too few memory callers allocated');
             end;
          Result := @(MemoryCallers[NumCallers]);
          Result.Stack := Stack;
          Result.HashNext := StackHash[H];
          StackHash[H] := Result;
          Result.Rank := 100000;
          Result.AllocatedCount := 0;
          inc(NumCallers);
       end;
    if Result.Rank < 10 then
       begin
          Result.Rank := Result.Rank + 1;
       end;
end;

initialization
begin
   CSMem := TCriticalSection.Create;
   setlength(MemoryCallers, 100000);
   setlength(SortedMemoryCallers, 100000);
   SymbolSearchPath := GetSymbolSearchPath;
end;

finalization
begin
  if Initialized then
  	SymCleanup(GetCurrentProcess());
end;
end.
