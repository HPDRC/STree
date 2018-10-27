unit StripReal;
interface

uses
  SysUtils, Stree,  IdHTTPServer, Syncobjs, webobject, IdCustomHTTPServer, stripobject;

const FL_Active = 1;
const FL_Archived = 2;


type TStripReal = class(TStripObject)
  public
// persistent data
    ParentObject : TStripReal;
    CurrentDate, CurrentTime : String;
    DCurrentDate : double;
    TimeStamps : Array of integer;
    CSFile : TCriticalSection;
    destructor free; override;
    procedure Init(Oldobject: TWebObject = nil); override;
    function  GetKey(Var S : String) : String;
    function  GetStrip(ID : integer) : String;
    function  AddPricesandStamps(Var Line, OldLine : string; Var LastUpdate : integer) : boolean;
    procedure AddStamp(Var Line : String);
    procedure FetchStrip(idx : integer; Var V); override;
    procedure Archive;
    procedure LoadAllFiles; override;
    procedure AddStrip(Var Lat, Lon: String; Line : String); override;
    procedure LoadBase; override;
    procedure SaveBase; override;
//    procedure AddToHash(Var Key : String; ID : integer);
//    procedure DeleteFromHash(Key : String);
//    procedure SaveHash;
//    procedure LoadHash;
    function  GetFileDate(Var F : String) : String;
    function  GetPrice(Var LIne : String) : String;
    function  TooOld(Var Line : String) : boolean;
    function  CheckDate(Obj, Date, Oper : integer) : boolean; override;
    procedure Convert(Var Line : String);
    function CompleteUpdate : boolean; override;
    { Public declarations }
  end;

implementation
uses FileIO, parser, cityobject, streetobject, dbtables, InovaGIS_TLB,  winprocs, myutil1;

type tbytearray = array[0..7] of byte;
     Ptbytearray = ^tbytearray;

destructor TStripReal.free;
begin
   csfile.free;
   inherited free;
end;

function TStripReal.CompleteUpdate : boolean;
Var OldName : String;
begin
    CSWork.Enter;
    try
      OldName := DBName;
      Result := inherited CompleteUpdate;
      if  result then
         begin
            Sysutils.DeleteFile(Dir1 + TheFileName(MainDBNAME) + '.tim');
//            Sysutils.DeleteFile(Dir1 + TheFileName(MainDBNAME) + '.htb');
            RenameFile(Dir1 + TheFileName(OldName) + '.tim', Dir1+TheFileName(MainDBNAME) + '.tim');
//            RenameFile(Dir1 + TheFileName(OldName) + '.htb', Dir1+TheFileName(MainDBNAME) + '.htb');
         end;
{      StripF := FileOpen(NewName, fmOpenRead + fmShareDenyNone);
      if StripF < 0 then
         raise exception.create('Could not open file ' + Dir1 + DBName);}
    finally
      CSWork.Leave;
    end;
end;

function GetFlags(Var S : TStripRec) : byte;
begin
   result := PtByteArray(@S.DataStart)^[7];
end;

function  TStripReal.CheckDate(Obj, Date, Oper : integer) : boolean;
begin
   if Date = 0 then
      result := (GetFlags(Strips[obj]) and FL_Archived) = 0
   else if Oper = OpGr then
      Result := TimeStamps[Obj] >= Date
   else if Oper = OpLe then
      Result := TimeStamps[Obj] <= Date
   else if Oper = OpEq then
      Result := TimeStamps[Obj] = Date;
end;

procedure SetFlags(Var S : TStripRec; flags : byte);
begin
   PtByteArray(@S.DataStart)^[7] := flags;
end;

function GetStart(Var S : TStripRec) : int64;
begin
  result := S.DataStart and $00ffffffffffffff;
end;

procedure SetStart(Var S : TStripRec; Start : int64);
begin
  S.DataStart := (S.DataStart and $ff00000000000000) + Start;
end;

procedure TStripReal.Init(Oldobject: TWebObject);
begin
   CSFile := TCriticalSection.create;
   ArcF := -1;
   ParentObject := TStripReal(OldObject);
   fileformat := 'strip';
   KeyHashLen := 0;
   inherited init;
   ConvertToRegular := Convert;
end;

// update process
// mark all records in active set as old
// read new files
// change prices, timestamps in the active set, mark as active
// go over the active set and move the old records to the old set


procedure TStripReal.FetchStrip(idx : integer; Var V);
Var nr : integer;
begin
   CSFile.Enter;
   try
   if (GetFlags(Strips[idx]) and FL_Archived) <> 0 then
      begin
         fileseek(ArcF, GetStart(Strips[idx]), 0);
         nr := fileread(ArcF, V, Strips[idx].DataLen);
      end
   else
      begin
         fileseek(StripF, GetStart(Strips[idx]), 0);
         nr := fileread(StripF, V, Strips[idx].DataLen);
      end;
   finally
      CSFile.Leave;
   end;
end;

function TStripReal.TooOld(Var Line : String) : boolean;
Var LastListed : STring;
begin
   ExtractFieldByNum(Line, EnterDateField+2, LastListed);
   result := LastListed < formatDateTime('yyyy/mm/dd', DCurrentDate - ExpireDays);
end;

procedure TStripReal.Archive;
Var ArcF1 : integer;
    EndPos : int64;
    i, nw : integer;
    Line, Key : String;
begin
   ArcF1 := FileOpen(dir1 + 'arc' + maindbname, fmOpenReadWrite + fmShareDenyNone);
   if ArcF1 = -1 then
      ArcF1 := FileCreate(dir1 + 'arc' + maindbname);
   EndPos := fileseek(ArcF1, 0, 2);
   for i := 0 to ParentObject.numstrip - 1 do
     begin
       Line := '';
       if GetFlags(ParentObject.Strips[i]) = 0 then
         begin
           setlength(Line, ParentObject.Strips[i].DataLen+1);
           ParentObject.FetchStrip(i, (@(Line[1]))^);
           Line[ParentObject.Strips[i].DataLen+1] := #10;
           if TooOld(Line) then
              begin
                 DeleteFromHash(GetKey(Line));
                 SetFlags(ParentObject.Strips[i],  FL_Archived);
                 SetStart(ParentObject.Strips[i], EndPos);
                 inc(EndPos, length(Line));
                 nw := FileWrite(ArcF1, (@Line[1])^, length(line));
              end;
         end;
       if (GetFlags(ParentObject.Strips[i]) and FL_Active)  = 0 then
          begin
             if NumStrip >= length(Strips) then
               begin
                 setlength(Strips, round(NumStrip * 1.1) + 100);
                 setlength(TimeStamps, length(Strips));
               end;
             Strips[NumStrip] := ParentObject.Strips[i];
             if (GetFlags(ParentObject.Strips[i]) and FL_Archived)  = 0 then
               begin
                 if Line = '' then
                    begin
                       setlength(Line, ParentObject.Strips[i].DataLen);
                       ParentObject.FetchStrip(i, (@(Line[1]))^);
                    end;
                 fileseek(StripF, StripDataSize, 0);
                 nw := FileWrite(StripF, (@Line[1])^, length(line));
                 SetStart(Strips[NumStrip],  StripDataSize);
                 StripDataSize := StripDataSize + length(Line);
                 if (i < ParentObject.KeyHashLen) and (ParentObject.KeyHash[i].ID = i) then
                    Key := ParentObject.KeyHash[i].Key
                 else
                    begin
                       Key := ParentObject.GetKey(Line);
                    end;
                 AddToHash(Key, NumStrip);
               end;
             TimeStamps[NumStrip] := ParentObject.TimeStamps[i];
             inc(NumStrip);
          end;
     end;
   FileClose(ArcF1);
   SaveBase;
   if ArcF = -1 then
     ArcF := FileOpen(dir1 + 'arc' + maindbname, fmOpenReadWrite + FmShareDenyNone);
end;


function TStripReal.GetFileDate(Var F : String) : String;
Var Year, Month, Day, Hour, Min, Sec : word;
    SYear, SMonth, SDay, SHour, SMin, SSec : String;
    D : double;
    sp, P : integer;
begin
   P := 1;
   while (p <= length(F)) and (F[p] <> '_') do
     inc(p);
   sp := p+1;
   inc(p);
   while (p <= length(F)) and (F[p] <> '_') do
     inc(p);
   dec(p);
   if p <= sp then
      begin
        CurrentDate := formatdatetime('yyyy/mm/dd', now);
        CurrentTime := formatdatetime('hh:nn:ss', now);
      end
   else
     begin
        p := sp;
        syear := copy(F, p, 4);
        smonth := copy(F, p+4, 2);
        sday := copy(F, p+6, 2);
        shour := copy(F, p+8, 2);
        smin := copy(F, p+10, 2);
        ssec := copy(F, p+12, 2);
        year := ValStr(syear);
        month := ValStr(smonth);
        day := ValStr(sday);
        hour := ValStr(shour);
        min := ValStr(smin);
        sec := ValStr(ssec);
        D := EncodeDate(Year, month, Day) + ENcodeTime(Hour, Min, Sec, 0);
        CurrentDate := formatdatetime('yyyy/mm/dd', D);
        DCurrentDate := D;
        CurrentTime := formatdatetime('hh:nn:ss', D);
     end;
end;

procedure TStripReal.LoadAllFiles;
Var i : integer;
    NewName : String;
begin
   if ParentObject <> nil then
     for i := 0 to ParentObject.NumStrip - 1 do
       SetFlags(ParentObject.Strips[i],  GetFlags(ParentObject.Strips[i]) and (not FL_Active));
   KeyHash := nil;
   for i := 0 to HashMax do
      HashTable[i] := -1;
   Files := nil;
   ScanDir(Dir1, AddFile1);
   SortFiles;
   DeleteDupFiles;
   Files := nil;
   ScanDir(Dir1, AddFile1);
   SortFiles;
   if Parentobject <> nil then
     begin
       setlength(Strips, round(ParentObject.NumStrip*1.05));
       setlength(TimeStamps, length(Strips));
       setlength(Keyhash, round(ParentObject.KeyhashLen*1.05));
     end;
   for i := 0 to length(Files)-1 do
      begin
        GetFileDate(Files[i]);
        AddFile(Files[i]);
      end;
   if ParentObject <> nil then
     Archive;
end;


const _deb : integer = 0;

procedure TStripReal.AddStrip(Var Lat, Lon: String; Line : String);
Var  nw : integer;
     Start : int64;
     Key, OldLine : String;
     LastUpdate, ID, IDP : integer;
     StampsAdded : boolean;
begin
   Key := GetKey(Line);
   if Key = 'M905836' then
      Key := 'M905836';
   LastUpdate := ValDate(CurrentDate);
   ID := HashFind(Key);
   StampsAdded := false;
   if ID >= 0 then
      begin
        OldLine := GetStrip(ID);
        StampsAdded := true;
        if not AddPricesandStamps(Line, OldLine, LastUpdate) then
           exit;
      end;
   if ParentObject <> nil then
       IDP := ParentObject.HashFind(Key);
   if (ParentObject <> nil) and (IDP >= 0) then
      begin
        SetFlags(ParentObject.Strips[IDP], GetFlags(ParentObject.Strips[IDP]) or FL_Active);
        OldLine := ParentObject.GetStrip(IDP);
        if not StampsAdded then
          AddPricesandStamps(Line, OldLine, LastUpdate);
      end
   else
      if not StampsAdded then
         AddStamp(Line);
  if MergeObj <> nil then
    begin
       MergeObj.AddStrip(Lat, Lon, MergeObj.MapFields(Line, self));
       exit;
    end;
  Line := Line + #10;
  if ID < 0 then
    begin
      if NumStrip >= length(Strips) then
        begin
          setlength(Strips, round(NumStrip * 1.1) + 100);
          setlength(TimeStamps, length(Strips));
        end;
      ID := NumStrip;
      inc(NumStrip);
      AddToHash(Key, ID);
    end;
  Start := StripDataSize;
  Strips[ID].X := ReadDouble(Lon);
  Strips[ID].Y := ReadDouble(Lat);
  TimeStamps[ID] := LastUpdate;
  SetStart(Strips[ID],  Start);
  Strips[ID].DataLen := length(Line)-1;
  if  UseRam then
    begin
      if StripDataSize > length(StripData) then
        setlength(StripData, round(StripDataSize * 1.5) + 10);
      move((@Line[1])^, (@StripData[Start])^, length(line));
    end
  else
    begin
      if StripDataSize = 0 then
         begin
//           StripF := FileCreate(Dir1+DBName);
           StripF := FileOpen(Dir1+DBName, fmOpenReadWrite or FmShareDenyNone);
           if StripF = -1 then
             StripF := FileCreate(Dir1+DBName);
         end;
//      nw := FileWrite(StripF, (@Line[1])^, length(line))
      fileseek(StripF, StripDataSize, 0);
      nw := FileWrite(StripF, (@Line[1])^, length(line));
    end;
   StripDataSize := StripDataSize + length(Line);
end;



function  TStripReal.GetKey(Var S : String) : String;
Var State, MLS : String;
begin
   ExtractFieldByNum(S, KeyField, MLS);
   ExtractFieldByNum(S, SkipState+1, State);
   Result := MLS + State;
end;

function  TStripReal.GetStrip(ID : integer) : String;
begin
   setlength(Result, Strips[ID].DataLen);
   FetchStrip(ID, (@(Result[1]))^);
end;



procedure TStripReal.LoadBase;
Var S, nr : integer;
    F : File;
begin
   LoadHash;
   Interf.SetStatus('Loading database ' + DBName);
   Interf.SetStatus('Using DISK storage for ' + DBName);
   StripData := '';
   StripF := FileOpen(Dir1+DBName, fmOpenReadWrite + FmShareDenyNone);
   ArcF := FileOpen(dir1 + 'arc' + maindbname, fmOpenReadWrite + FmShareDenyNone);
   assignfile(F, Dir1 + TheFileName(DBNAME) + '.idx');
   reset(F, 1);
   S := FileSize(F);
   NumStrip := S div sizeof(TStripRec);
   setlength(Strips, NumStrip);
   setlength(TimeStamps, NumStrip);
   blockread(F, (@Strips[0])^, NumStrip * sizeof(TStripRec), nr);
   closefile(F);
   assignfile(F, Dir1 + TheFileName(DBNAME) + '.tim');
   reset(F, 1);
   blockread(F, (@TimeStamps[0])^, NumStrip * sizeof(integer), nr);
   closefile(F);
   Calibrate;
end;

procedure TStripReal.SaveBase;
Var nw : integer;
    F : File;
begin
   FileClose(StripF);
   StripF := FileOpen(Dir1+DBName, fmOpenReadWrite + FmShareDenyNone);
   SaveHash;
   assignfile(F, Dir1 + TheFileName(DBNAME) + '.idx');
   rewrite(F, 1);
   blockwrite(F, (@Strips[0])^, NumStrip * sizeof(TStripRec), nw);
   closefile(F);
   assignfile(F, Dir1 + TheFileName(DBNAME) + '.tim');
   rewrite(F, 1);
   blockwrite(F, (@TimeStamps[0])^, NumStrip * sizeof(integer), nw);
   closefile(F);
end;

function ValPrice(V : String) : integer;
Var D : double;
    c : integer;
begin
   D := 0;
   Val(V, D, C);
   result := round(D);
end;

function TStripReal.GetPrice(Var LIne : String) : String;
begin
  ExtractFieldByNum(Line, PriceField, Result);
  Result := inttostr(ValPrice(Result));
end;

procedure TStripReal.Convert(Var Line : String);
Var p : integer;
begin
   P := 1;
   SkipFields(Line, EnterDateField-1, P);
   LIne := copy(Line, 1, P-2);
end;

function TStripReal.AddPricesandStamps(Var Line, OldLine : string; Var LastUpdate : integer) : boolean;
// Line + TAB + ENTER_DATE + TAB + ENTER_TIME + TAB + LASTLISTED_DATE + TAB + {DATE + TAB + PRICE}
Var i, P, PriceCount : integer;
    SPrice, SDate, STime, EnterDate, EnterTime, LastListed : String;
    Prices, Dates : array of String;
begin
   P := 1;
   SkipFields(OldLine, EnterDateField-1, P);
   ExtractField(OldLine, EnterDate, P);
   ExtractField(OldLine, EnterTime, P);
   ExtractField(OldLine, LastListed, P);
   PriceCount := 0;
   Dates := nil;
   Prices := nil;
   while true do
      begin
         ExtractField(OldLine, SDate, P);
         ExtractField(OldLine, SPrice, P);
         if SDate = '' then
            break;
         inc(PriceCount);
         Setlength(Dates, PriceCount);
         Setlength(Prices, PriceCount);
         Dates[PriceCount-1] := SDate;
         Prices[PriceCount-1] := SPrice;
      end;
   LIne := LIne + TAB + EnterDate + TAB + EnterTime + TAB + CurrentDate + TAB + '{';
   SPrice := GetPrice(Line);
   if (PriceCount = 0) or ((Prices[0] <> SPrice) and (SPrice <> '0') and (Dates[0] < CurrentDate)) then
      begin
         Line := Line + CurrentDate + TAB + SPrice + TAB;
         Result := true;
      end
   else
      begin
         LastUpdate := ValDate(Dates[0]);
         Result := false;
      end;
   for i := 0 to PriceCOunt - 1 do
      begin
         Line := Line + Dates[i] + TAB + Prices[i] + TAB;
      end;
   if Line[length(LIne)] = TAB then
     Line[length(Line)] := '}'
   else
     Line := Line + '}';
end;

procedure TStripReal.AddStamp(Var Line : String);
begin
   LIne := LIne + TAB + CurrentDate + TAB + CurrentTime + TAB + CurrentDate + TAB +
     '{' + CurrentDate + TAB + GetPrice(Line) + '}';
end;



end.
