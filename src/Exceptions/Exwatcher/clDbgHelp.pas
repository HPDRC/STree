unit clDbgHelp;

interface

uses
  Windows;

{$ALIGN 4}

type
  PIMAGEHLP_SYMBOL = ^IMAGEHLP_SYMBOL;
  IMAGEHLP_SYMBOL = record
    SizeOfStruct: DWORD;           // set to sizeof(IMAGEHLP_SYMBOL)
    Address: DWORD;                // virtual address including dll base address
    Size: DWORD;                   // estimated size of symbol, can be zero
    Flags: DWORD;                  // info about the symbols, see the SYMF defines
    MaxNameLength: DWORD;          // maximum size of symbol name in 'Name'
    Name: array[0..1] of char;                // symbol name (null terminated string)
  end;

  PKDHELP = ^KDHELP;
  KDHELP = record
    //
    // address of kernel thread object, as provided in the
    // WAIT_STATE_CHANGE packet.
    //
    Thread: DWORD;
    //
    // offset in thread object to pointer to the current callback frame
    // in kernel stack.
    //
    ThCallbackStack: DWORD;
    //
    // offsets to values in frame:
    //
    // address of next callback frame
    NextCallback: DWORD;
    // address of saved frame pointer (if applicable)
    FramePointer: DWORD;
    //
    // Address of the kernel function that calls out to user mode
    //
    KiCallUserMode: DWORD;
    //
    // Address of the user mode dispatcher function
    //
    KeUserCallbackDispatcher: DWORD;
    //
    // Lowest kernel mode address
    //
    SystemRangeStart: DWORD;
    //
    // offset in thread object to pointer to the current callback backing
    // store frame in kernel stack.
    //
    ThCallbackBStore: DWORD;
    Reserved: array[0..7] of DWORD;
  end;

  ADDRESS_MODE = (AddrMode1616, AddrMode1632, AddrModeReal, AddrModeFlat);

  LPADDRESS = ^ADDRESS;
  ADDRESS = record
    Offset: DWORD;
    Segment: WORD;
    Mode: DWORD;
  end;

  LPSTACKFRAME = ^STACKFRAME;
  STACKFRAME = record
    AddrPC: ADDRESS;                // program counter
    AddrReturn: ADDRESS;            // return address
    AddrFrame: ADDRESS;             // frame pointer
    AddrStack: ADDRESS;             // stack pointer
    FuncTableEntry: Pointer;        // pointer to pdata/fpo or NULL
    Params: array[0..3] of DWORD;   // possible arguments to the function
    bFar: LONGBOOL;                 // WOW far call
    bVirtual: LONGBOOL;             // is this a virtual frame?
    Reserved: array[0..2] of DWORD;
    KdHelp: KDHELP;
    AddrBStore: ADDRESS;            // backing store pointer
  end;

  PIMAGEHLP_LINE = ^IMAGEHLP_LINE;
  IMAGEHLP_LINE = record
    SizeOfStruct: DWORD;           // set to sizeof(IMAGEHLP_LINE)
    Key: Pointer;                    // internal
    LineNumber: DWORD;             // line number in file
    FileName: PChar;               // full filename
    Address: DWORD;                // first instruction of line
  end;

  PREAD_PROCESS_MEMORY_ROUTINE = function(hProcess: THandle; lpBaseAddress: DWORD;
    lpBuffer: Pointer; nSize: DWORD; var lpNumberOfBytesRead: DWORD): Boolean; stdcall;

  PFUNCTION_TABLE_ACCESS_ROUTINE = function(hProcess: THandle; AddrBase: DWORD): Pointer; stdcall;

  PGET_MODULE_BASE_ROUTINE = function(hProcess: THandle; Address: DWORD): DWORD; stdcall;

  PTRANSLATE_ADDRESS_ROUTINE = function(hProcess, hThread: THandle; lpaddr: LPADDRESS): DWORD; stdcall;

  function SymLoadModule(hProcess, hFile: THandle; ImageName, ModuleName: PChar; BaseOfDll, SizeOfDll :DWORD): DWORD; stdcall;
  function SymGetSymFromAddr(hProcess: THandle; dwAddr: DWORD; var dwDisplacement: DWORD; pSymbol: PIMAGEHLP_SYMBOL): Boolean; stdcall;
  function SymSetOptions(SymOptions: DWORD): DWORD; stdcall;
  function clSymInitialize(hProcess: THandle; UserSearchPath: string; fInvadeProcess: Boolean): Boolean; stdcall;
  function SymCleanup(hProcess: THandle): Boolean; stdcall;
  function StackWalk(MachineType: DWORD; hProcess, hThread: THandle;
    StackFrame: LPSTACKFRAME; ContextRecord: Pointer;
    ReadMemoryRoutine: PREAD_PROCESS_MEMORY_ROUTINE;
    FunctionTableAccessRoutine: PFUNCTION_TABLE_ACCESS_ROUTINE;
    GetModuleBaseRoutine: PGET_MODULE_BASE_ROUTINE;
    TranslateAddress: PTRANSLATE_ADDRESS_ROUTINE): Integer; stdcall;
  function SymFunctionTableAccess(hProcess: THandle; AddrBase: DWORD): Pointer; stdcall;
  function SymGetModuleBase(hProcess: THandle; Address: DWORD): DWORD; stdcall;
  function SymGetLineFromAddr(hProcess: THandle; dwAddr: DWORD; var dwDisplacement: DWORD; Line: PIMAGEHLP_LINE): Boolean; stdcall;

const
//
// options that are set/returned by SymSetOptions() & SymGetOptions()
// these are used as a mask
//
  SYMOPT_CASE_INSENSITIVE  = $00000001;
  SYMOPT_UNDNAME           = $00000002;
  SYMOPT_DEFERRED_LOADS    = $00000004;
  SYMOPT_NO_CPP            = $00000008;
  SYMOPT_LOAD_LINES        = $00000010;
  SYMOPT_OMAP_FIND_NEAREST = $00000020;
  SYMOPT_DEBUG             = $80000000;

  MAX_SYMNAME_SIZE = 1024;

implementation

const
  cDbgHelpDll = 'dbghelp.dll';

  function SymLoadModule(hProcess, hFile: THandle; ImageName, ModuleName: PChar; BaseOfDll, SizeOfDll :DWORD): DWORD; stdcall; external cDbgHelpDll;
  function SymGetSymFromAddr(hProcess: THandle; dwAddr: DWORD; var dwDisplacement: DWORD; pSymbol: PIMAGEHLP_SYMBOL): Boolean; stdcall; external cDbgHelpDll;
  function SymSetOptions(SymOptions: DWORD): DWORD; stdcall; external cDbgHelpDll;
  function SymInitialize(hProcess: THandle; UserSearchPath: PChar; fInvadeProcess: Boolean): Boolean; stdcall; external cDbgHelpDll;
  function SymCleanup(hProcess: THandle): Boolean; stdcall; external cDbgHelpDll;
  function StackWalk(MachineType: DWORD; hProcess, hThread: THandle;
    StackFrame: LPSTACKFRAME; ContextRecord: Pointer;
    ReadMemoryRoutine: PREAD_PROCESS_MEMORY_ROUTINE;
    FunctionTableAccessRoutine: PFUNCTION_TABLE_ACCESS_ROUTINE;
    GetModuleBaseRoutine: PGET_MODULE_BASE_ROUTINE;
    TranslateAddress: PTRANSLATE_ADDRESS_ROUTINE): Integer; stdcall; external cDbgHelpDll;
  function SymFunctionTableAccess(hProcess: THandle; AddrBase: DWORD): Pointer; stdcall; external cDbgHelpDll;
  function SymGetModuleBase(hProcess: THandle; Address: DWORD): DWORD; stdcall; external cDbgHelpDll;
  function SymGetLineFromAddr(hProcess: THandle; dwAddr: DWORD; var dwDisplacement: DWORD; Line: PIMAGEHLP_LINE): Boolean; stdcall; external cDbgHelpDll;

function clSymInitialize(hProcess: THandle; UserSearchPath: string; fInvadeProcess: Boolean): Boolean;
begin
  Result := SymInitialize(hProcess, PChar(UserSearchPath), fInvadeProcess);
end;

end.


