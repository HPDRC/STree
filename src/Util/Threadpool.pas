unit ThreadPool;

interface
uses classes, syncobjs, wintypes;

type TThreadProc = procedure of object;

type THolder = class
      _Next : THolder;
      _P : TThreadProc;
end;

Type

TThreadPool = class;

TWorkingThread = class(TThread)
    _Wait : TEvent;
    _P : TThreadProc;
    _Pool : TThreadPool;
    _Next : TWorkingTHread;
    _ID : integer;
    _ThreadID : dword;
    constructor Create(Pool : TThreadpool; P : TTHreadProc; ID : integer);
    destructor DEstroy; override;
    procedure Execute; override;
end;

TThreadPool = class
   _FreeHolder : THolder;
   _QueueLast : THolder;
   _QueueFirst : THolder;
   _Threads : array of TWorkingThread;
   _FirstFreeThread : TWorkingTHread;
   _MaxThreads : integer;
   _NumThreads : integer;
   _Terminated : boolean;
   _TermWait : TEvent;
   _CSAssign : TCriticalSection;
   procedure QueueProc(P : TThreadProc);
   constructor Create(MaxThreads : integer);
   destructor Destroy; override;
   procedure GetQueue(Var Q : TTHreadProc);
   procedure Enqueue(P : TThreadProc);
   function  GetFreeThread(P : TTHreadProc) : TWorkingThread;
   function FindThread : TWorkingThread;
end;

procedure mainthreadexec(P : TThreadProc);

Var IThreadPool : TTHreadPool;

implementation
uses sysutils, winprocs;

constructor TTHreadPool.Create(MaxThreads : integer);
begin
  _FirstFreeThread := nil;
  _MaxThreads := MaxThreads;
  _NumThreads := 0;
  _Terminated := false;
  _FreeHolder := nil;
  setlength(_Threads, MaxThreads);
  _CSAssign := TCriticalSection.Create;
end;

destructor TTHreadPool.Destroy;
Var H : THolder;
    Q : TThreadProc;
begin
   if _NumThreads <> 0 then
     begin // wait until all threads have terminated
       _TermWait := TEvent.Create(nil, true, true, '');
       _TermWait.ResetEvent;
       _Terminated := true;
       _CSAssign.enter;
       repeat
         GetQueue(Q);
       until @Q = nil;
       while _FreeHolder <> nil do
         begin
           H := _FreeHolder;
           _FreeHolder := _FreeHolder._Next;
           H.Free;
         end;
       while _FirstFreeThread <> nil do
          begin
            _FirstFreeThread.Terminate;
            _FirstFreeThread._Wait.SetEvent;
            _FirstFreeThread := _FirstFreeThread._Next;
          end;
       _CSAssign.Leave;
       _TermWait.WaitFor(10000);
       _TermWait.Free;
     end;
   _CSAssign.Free;
   inherited destroy;
end;

function TTHreadPool.GetFreeThread(P : TTHreadProc) : TWorkingThread;
begin
  if _NumThreads >= _MaxThreads then
    begin
      result := nil;
      exit;
    end
  else
    begin
      Result := TWorkingThread.Create(self, P, _NumThreads);
      inc(_NumThreads);
    end;
end;

constructor TWorkingThread.Create(Pool : TThreadPool; P : TTHreadProc; ID : integer);
begin
   _P := P;
   _ID := ID;
   Pool._Threads[ID] := self;
   _Wait := TEvent.Create(nil, false, false, ''{'PoolEvt' + inttostr(Pool._NumThreads)});
//   _Wait.ResetEvent;
   FreeOnTerminate := true;
   _Pool := Pool;
   inherited Create(false);
end;

destructor TWorkingThread.Destroy;
begin
   _Wait.Free;
   inherited Destroy;
end;

const _Execs : integer = 0;
const _NumAssign : integer = 0;
const _NumGets : integer = 0;
procedure TWorkingThread.Execute;
Var r : TWaitResult;
begin
   _ThreadID := GetCurrentThreadID;
   while not terminated do
     begin
       if @_P <> nil then
         begin
           try
             inc(_Execs);
             _P;
           except on E: Exception do
           end;
            _P := nil;
            _Pool.GetQueue(_P);
            if @_P <> nil then
               inc(_NumGets);
         end
       else
         begin
            if _pool._Terminated then
              begin
                Terminate;
                dec(_pool._NumThreads);
                if _pool._NumThreads = 0 then
                  _Pool._TermWait.SetEvent;
                exit;
              end;
           _Pool._CSAssign.Enter;
           _Next := _Pool._FirstFreeThread;
           _Pool._FirstFreeThread := self;
//           _Wait.ResetEvent;
           _Pool._CSAssign.Leave;
           repeat
              r := _Wait.WaitFor(1000000);
           until (r <> wrTimeout) {or (@_P <> nil)};
           inc(_NumAssign);
{           if r = wrTimeout then
             r := wrTimeOut;}
           if r = wrAbandoned then
              begin
                Terminate;
                dec(_pool._NumThreads);
                if _pool._NumThreads = 0 then
                  _Pool._TermWait.SetEvent;
                exit;
              end;
         end
     end;
end;

const   _QueueLength : integer = 0;

procedure TThreadPool.QueueProc(P : TThreadProc);
Var H : THolder;
begin
   inc(_QueueLength);
   H := _FreeHolder;
   if H = nil then
     H := THolder.Create
   else
     _FreeHolder := _FreeHolder._Next;
   H._Next := nil;
   if _QueueLast = nil then
     begin
       _QueueLast := H;
       _QueueFirst := H;
     end
   else
     begin
        _QueueLast._Next := H;
        _QueueLast := H;
     end;
   H._P := P;
end;

procedure TThreadPool.GetQueue(Var Q : TThreadProc);
Var H : THolder;
begin
   _CSAssign.Enter;
   try
     if _QueueFirst <> nil then
       begin
         Q := _QueueFirst._P;
         H := _QueueFirst;
         _QueueFirst := _QueueFirst._Next;
         if _QueueFirst = nil then
           _QueueLast := nil;
         H._Next := _FreeHolder;
         dec(_QueueLength);
         _FreeHolder := H;
       end
     else
       Q := nil;
   finally
     _CSAssign.Leave;
   end;
end;

const _Enq : integer = 0;
procedure TThreadPool.Enqueue(P : TThreadProc);
Var F : TWorkingTHread;
begin
   inc(_Enq);
   if _Terminated then
     exit;
   if (_FirstFreeThread = nil) and (_NumThreads > 10) then
       sleep(0);
   _CSAssign.Enter;
   try
      F := _FirstFreeThread;
      if F = nil then
        begin
          F := GetFreeThread(P);
          if F = nil then
            QueueProc(P);
        end
      else
         begin
            _FirstFreeThread := _FirstFreeThread._Next;
            F._P := P;
            F._Wait.SetEvent;
         end;
   finally
     _CSAssign.Leave;
   end;
end;

function TTHreadPool.FindThread : TWorkingThread;
Var ID : dword;
    i : integer;
begin
   result := nil;
   ID := GetCurrentThreadID;
   for i := 0 to _Numthreads - 1 do
      if _Threads[i]._ThreadID = ID then
         begin
           result := _Threads[i];
           exit;
         end;
end;

procedure mainthreadexec(P : TThreadProc);
Var T : TWorkingThread;
begin
   if GetCurrentThreadID = MainThreadID then
      begin
        P;
        exit;
      end;
   T := IThreadPool.FindThread;
   if T <> nil then
      T.Synchronize(P)
   else
      raise exception.Create('error - thread not found in the pool');
end;

begin
   IThreadPool := TTHreadPool.Create(30);
end.
