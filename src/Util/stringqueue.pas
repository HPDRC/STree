unit stringqueue;

interface
uses SyncObjs;

type TStrQueueItem = record
       Msg : String;
       Next : integer;
end;

type TStrQueue = class
    CSStrQueue : TCriticalSection;
    NumItems : integer;
    Head : integer;
    Tail : integer;
    FirstFree : integer;
    Enabled : boolean;
    Items : array of TStrQueueItem;
    constructor Create;
    destructor Free;
    procedure Append(Status : String);
    function  Fetch(Var S : String) : boolean;
end;

implementation
uses winprocs;

constructor TStrQueue.Create;
begin
   Head := -1;
   Tail := -1;
   FirstFree := -1;
   NumItems := 0;
   Items := nil;
   Enabled := true;
   CSStrQueue := TCriticalSection.Create;
end;

destructor TStrQueue.Free;
begin
  CSStrQueue.Free;
end;

function  TStrQueue.Fetch(Var S : String) : boolean;
Var N : integer;
begin
  Result := false;
  if Head >= 0 then
    begin
      CSStrQueue.Enter;
      try
        S := Items[Head].Msg;
        N := Items[Head].Next;
        Result := true;
        Items[Head].Next := FirstFree;
        FirstFree := Head;
        Head := N;
        if Head < 0 then
          Tail := -1;
      finally
        CSStrQueue.LEave;
      end;
      sleep(0);
    end;
end;

procedure TStrQueue.Append(Status : String);
Var L : integer;
begin
   if Enabled then
      begin
         CSStrQueue.Enter;
         try
           L := FirstFree;
           if L < 0 then
             begin
               L := NumItems;
               inc(NumItems);
               if NumItems >= length(Items) then
                  setlength(Items, NumItems + 10);
             end
           else
             FirstFree := Items[L].Next;
           Items[L].Msg := Status;
           Items[L].Next := -1;
           if Tail >= 0 then
             Items[Tail].Next := L;
           Tail := L;
           if Head < 0 then
             Head := L;
         finally
            CSStrQueue.Leave;
         end;
      end;
end;

end.
