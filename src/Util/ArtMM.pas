unit Artmm;

interface

var
  PrevMemoryManager:TMemoryManager;
  MemoryManager:TMemoryManager;

implementation
uses Syncobjs, winprocs, wintypes, sysutils, windows;

{function malloc(size:integer):pointer;stdcall;external 'memmgr.dll' name 'alp_malloc';
procedure free(blk:pointer);stdcall;external 'memmgr.dll' name 'alp_free';
function realloc(blk:pointer;newsize:integer):pointer;stdcall;external 'memmgr.dll' name 'alp_realloc';}


Var CSLock : TCriticalSection;
const _debug : integer = 0;
procedure debug;
begin
  inc(_debug);
  if _debug >= 309015 then
    _debug := _debug;
end;
function malloc(size:integer):pointer;
begin
   debug;
   CSLock.Enter;
   try
      SetMemoryManager(PrevMemoryManager);
      system.getmem(result, size);
   finally
     SetMemoryManager(MemoryManager);
     CSLock.Leave;
   end;
end;

procedure free(blk:pointer);
begin
   debug;
   CSLock.Enter;
   try
      SetMemoryManager(PrevMemoryManager);
      system.freemem(blk);
   finally
     SetMemoryManager(MemoryManager);
     CSLock.Leave;
   end;
end;

threadvar MemManagerIndex:integer;

const headersize = 16;
const _signature = $12345678abcdef11;
type TMemBlock = record
        Signature : int64;
        NextFree : pointer; //header
        Group : integer; //header
        data : byte;
end;
PMemBlock = ^TMemBlock;

type TMemGroup = record
       FirstFree : pointer;
       Size : integer;
       Lock : TCriticalSection;
end;

const Maxgroup = 11;
Var MemGroups : array[0..Maxgroup] of TMemgroup;
const MaxManagedSize = (256 shl (Maxgroup - 1)) - headersize;

procedure Initialize;
Var i : integer;
begin
   for i := 0 to MaxGroup-1 do
      begin
        Memgroups[i].Size := (256 shl i) - headersize;
        Memgroups[i].FirstFree := nil;
        Memgroups[i].Lock := TCriticalSection.Create;
      end;
end;

function IntLog2(Value: integer ): integer; //Trunc(Log2(SomeInteger))
asm
   BSR EAX, EAX
end;


procedure RaiseLastWin32Error;
begin
   raise exception.create('Win32 error: ' + inttostr(GetLastError));
end;

const NumAlloc : int64 = 0;
const SizeAlloc : int64 = 0;
function GetMem(MinSize:integer):Pointer;
var AllSize, Group:integer;
    B : PMemBlock;
begin
  debug;
  if MinSize < MaxManagedSize then
    begin
      Group := IntLog2(MinSize+headersize) - 7;
      if Group < 0 then
        Group := 0;
      if MemGroups[Group].Size < MinSize then
         raise Exception.Create('error');
      Memgroups[Group].Lock.Enter;
      if Memgroups[Group].FirstFree <> nil then
         begin
            B := PMemblock(Memgroups[Group].FirstFree);
            Memgroups[Group].FirstFree := B^.Nextfree;
            Memgroups[Group].Lock.Leave;
         end
      else
         begin
           Memgroups[Group].Lock.Leave;
           inc(NumAlloc);
           inc(SizeAlloc, Memgroups[Group].Size+headersize);
           B := malloc(Memgroups[Group].Size+headersize);
           if B = nil then
               RaiseLastWin32Error;
           B^.Group := Group;
           B^.Signature := _Signature;
         end;
      result := @B^.Data;
      fillchar(result^, Minsize, 0);
    end
  else
    begin // use windows functions for larger blocks
      inc(NumAlloc);
      inc(SizeAlloc, Minsize+headersize);
      B := malloc(MinSize+headersize);
      if B = nil then
          RaiseLastWin32Error;
      B^.Group := MinSize;
      B^.Signature := _Signature;
      result := @B^.Data;
      fillchar(result^, Minsize, 0);
    end;
end;

function VerifySignature(B : PMemBlock) : boolean;
Var  OldProtect,Protect:DWord;
begin
{  Windows.VirtualProtect(B,5,PAGE_READWRITE,OldProtect);
  result := B^.Signature <> _Signature;
  Windows.VirtualProtect(B,5,OldProtect,Protect);}
  try
    result := B^.Signature <> _Signature;
  except on e: exception do
    result := false;
  end;
end;

function FreeMem(addr:pointer):integer;
Var Group : integer;
    B : PMemBlock;
begin
  debug;
  if addr = nil then
    begin
       result := 0;
       exit;
    end;
  try
  B := PMemBlock(integer(addr) - headersize);
  if VerifySignature(B) then
     result:=PrevMemoryManager.FreeMem(addr)
  else
     begin
       result := 0;
       if B^.Group < Maxgroup then
         begin
            Group := B^.Group;
            Memgroups[Group].Lock.Enter;
            B^.NextFree := Memgroups[Group].FirstFree;
            Memgroups[Group].FirstFree := B;
            Memgroups[Group].Lock.Leave;
         end
       else
         free(B);
     end;
  except on e: exception do
     result := -1;
  end;
end;

function ReAllocMem(addr:pointer; Size:integer):Pointer;
var
  B: PMemBlock;
  NewBuff : pointer;
begin
  debug;
  if addr = nil then
     begin
       result := getmem(Size);
       exit;
     end;
  if Size = 0 then
     begin
       FreeMem(Addr);
       Result := nil;
       exit;
     end;
  B := PMemBlock(integer(addr) - headersize);
  if VerifySignature(B) then
     begin
       if B^.Group < Maxgroup then
         begin
            if Memgroups[B^.Group].Size >= Size then
              begin
                 Result := addr;
                 exit;
              end;
         end;
     end;
  try
  NewBuff := GetMem(Size);
  fillchar(newbuff^, size, 0);
  if B^.Group < MaxGroup then
     Move(Addr^, NewBuff^, MemGroups[B^.Group].Size)
  else
     Move(Addr^, NewBuff^, B^.Group);
  FreeMem(Addr);
  except on e: exception do
     Addr := 0;
  end;
  Result := NewBuff;
end;

initialization
  CSLock := TCriticalSection.Create;
  Initialize;
  MemoryManager.GetMem:=GetMem;
  MemoryManager.ReAllocMem:=ReAllocMem;
  MemoryManager.FreeMem:=FreeMem;
  GetMemoryManager(PrevMemoryManager);
  SetMemoryManager(MemoryManager);
finalization
  CSLock .Free;
  SetMemoryManager(PrevMemoryManager);
end.
