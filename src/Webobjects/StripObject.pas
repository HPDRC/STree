{*** Strip object point indexing using S-tree implementation by A. Shaposhnikov 2002 ***}
{

Indexes arbitrary objects in 2-D space and performs strip object queries. 

The following strip objects commands are active now:
Command		Description
hotels  	US hotels
gnis  		GNIS data
USchools	US schools
real            Real estate
folio		Miami Date folios
modis		Modis fires
hms		HMS fires
fimma		Fimma Fires
abba		ABBA fires
raws		RAWS weather stations

each command has the following syntax:

<command>?x1=number&y1=number[&x2=number&y2=number][&limit=number][&d=number][&header=1/0][&numfind=number]

Examples:

Find 10 nearest properties and sort by distance:
http://n158.cs.fiu.edu/folio?x1=-80.129138&y1=25.790404&numfind=10&printdist=1&header=1

Find all properties within 0.5 miles from the point and sort by distance:
http://n158.cs.fiu.edu/folio?x1=-80.129138&y1=25.790404&d=0.5&limit=1000&printdist=1&header=1

Options description:
x1, y1 - the point coordinates or the rectangle corner.
x2, y2 - the opposite rectangle corner, optional for rectangle queries.
limit  - limits the number of results to the specified number.
	 The default is 100. If the limit is exceeded, no results is returned.
         An error message is returned instead: ERROR: LIMIT EXCEEDED. FOUND:number
numfind - valid for point (where x2 and y2 is not specified) queries only.
          Specifies the number of objects to find that are closesest to
	  the specified point in x1 and y1.
printdist - print the distance in meters, direction and offset fields by
	  appending them to the strip record
header - pre-pend the strip header.



}
unit stripobject;
interface

uses
  SysUtils, Stree,  IdHTTPServer, Syncobjs, webobject, IdCustomHTTPServer, IDUri,RegExpr;

type TOldStripRec = record
       X, Y : double;
       DataStart : integer;
       Datalen : word;
end;

type TStripRec = record
       X, Y : single;
       DataStart : int64;
       Datalen : word;
end;


type TObjRec = record
       ID : integer;
       Dist : double;
end;

type tfieldtype = (cstring, cnumber);
type TField = record
//         Number : integer;
         SrcNum : integer;
         RepNum : integer;
         Name : String;
         dtype : tfieldtype;
end;

const TheDateField = 10000;
const OpEq = 1;
const OpGr = 2;
const OpLe = 3;
const OpSearch = 4;
const OpNe = 5;
const OpOr = 6;
type TExp = record
               Field : integer;
               Value : string;
               Value1 : int64;
               dtype : tfieldtype;
               Oper : integer;
               OrSat : boolean;
            end;

type TDictionary = record
          Field : integer;
          Table : Array of string;
end;

type TExpression = record
    Exp : array [0..30] of TExp;
    NumExp : integer;
    NumEval : integer;
    MaxEval : integer;
end;

const HashMax = 16*1024-1;

type TKeyHashRec = record
          ID : integer;
          Key : String;
          Next : integer;
     end;


function GetField1(SrcNum, RepNum : integer; Var S : String; Var p : integer) : string;
function GetField(SrcNum : integer; Var S : String; RepNum : integer = 0) : string;

type TConvertProc =  procedure (Var Line : String) of object;
type TFileProc = procedure (Name : String) of object;
TStripObject = class(TWebObject)
  public
// persistentdata
    LoadError : string;
    BadAddress, GoodAddress : integer;
    KeyHash : array of TKeyHashRec;
    HashTable : array[0..HashMax] of integer;
    KeyHashLen, ArcF : integer;
    KeyField : integer;
    KeyField1 : integer;
    UseFolio : boolean;
    AppendLevel : boolean;
    CalcAddress, CompAddress : integer;

    Dictionaries : array of TDictionary;
    MinY, MinX, MaxY, MaxX : double;
    NumStrip : integer;
    Strips : array of TStripRec; // 0..NumVertexes - 1
    StripDataSize : int64;
    StripData : string;

    StripF : Integer;
//    StripF : File;
    BackupDir1 : String;
    MoveSource : string;
    FieldLine : String;
    FileExt : String;
    RequestParameters : String;
    DBExists : boolean;
    Stree : TStree;
    CSWork : TCriticalSection;
    Header : String;
    HeaderDist : string;
    UseRam : boolean;
    SkipFirstLine : boolean;
    LongMultiplier : integer;
    FilUrlPos : integer;
    FieldNames, ServerCommand : String;
    SkipLon : integer;
    SkipLat : integer;
    YearPos, HourPos : integer;
    SkipZip : integer;
    SkipAddress : integer;
    SkipCity : integer;
    SkipState : integer;
    PriceField, EnterDateField : integer;
    ExpireDays : integer;
    DBName : String;
    BackupName : STring;
    MainDBName : String;
    Fields : array of TField;
//    Exp : array [0..30] of TExp;
//    NumExp : integer;
    fileformat : string;
    TranslateCoor : boolean;
    ParseNameDate : boolean;
    RemoveFile : boolean;
    MergeObj : TStripObject;
    LastMerge : TStripObject;
    latitudestart, longitudestart, coorlength : integer;
    MinApprox : integer;
    coorformat : string;
    extractfrom, extractlength : integer;
    SectionNum : integer;
    ConvertToregular : TConvertProc;
    PostUrl : string;
    Files : array of String;

    //numfind_regexp : TRegExpr;
    //dist_regexp : TRegExpr;

    destructor Free; override;
    procedure Init(Oldobject: TWebObject = nil);  override;
    procedure HandleCommand(UnparsedParams : String;
                            Var ResponseInfo: String; Var ContentType : String); override;

    procedure AddFile(Name : String); virtual;
    procedure AddField(FieldName : String; SourceNum : integer; RepNo : integer = 0; dtype : tfieldtype = cstring);
    function  FindField(FieldName : String) : integer;
    procedure BuildStree;
    procedure ObjCoor(ObjID : integer; Var X, Y : single);
    procedure LoadAllFiles; virtual;
    procedure LoadBase; virtual;
    procedure SaveBase; virtual;
    procedure Calibrate;
    procedure AddStrip(Var Lat, Lon : String; Line : String); virtual;
    procedure FetchStrip(idx : integer; Var V); virtual;
    procedure FindStrips(Var Exp : TExpression; Var X1, Y1, X2, Y2 : double; limit : integer; Var S : String; Var ContentType : String; print : boolean = false; Dist : double = 1e90; NumFind : integer = 0; AppendCommand : boolean = false; commstr : string = ''; Convert : boolean = false);
    procedure ScanDir(D1 : String; P : TFileProc);
    function  ProcessQuery(Request : String; AppendEOL : boolean; Var ContentType : String; AppendCommand : boolean; commstr : string = '') : String; override;
    procedure SortDist(Var Entries : Array of TObjRec; Length : integer);
    procedure TranslateFields(Var S : String);
    function  FetchField(F : integer; Var S : String) : string;
    function  GetField(FieldIdx : integer; Var S : String) : string; overload;
    function  Satisfies(Obj : integer; Var Exp : TExpression; Var S : String) : boolean;
    function  ProduceList(F : integer) : String;
    procedure AddFields(FieldNames : String);
    function  MapFields(Src : String; SrcObj : TStripObject) : String;
    procedure AddDictionary(F : integer; name : String);
    procedure MakeDictionary(Dict : String);
    procedure Backup; override;
    procedure Rename; virtual;
    Function CheckUpdate : boolean;
    function  CompleteUpdate : boolean; virtual;
    procedure MakeCopy;
    procedure AddFieldsFromHeader;
    function  HashFind(Var Key : String) : integer;
    function  FindByKey(Var Key : String) : String; virtual;
    function  CheckDate(Obj, Date, Oper : integer) : boolean; virtual;
    procedure AddToHash(Var Key : String; ID : integer);
    procedure DeleteFromHash(Key : String);
    procedure SaveHash;
    procedure LoadHash;
    procedure VerifyFolio;
    function  UpdateFromUrl(Url : String; header_url : string; var reason : string) : string;
    procedure SetRequestParameters(rParams : String);
    procedure IndexStreets;
    procedure SortFiles(ByDate : boolean = true);
    procedure AddFile1(Name : String);
    procedure DeleteDupFiles;

    //procedure numfind_Compile;
    function dist_Compile(S : String) : boolean;

    { Public declarations }
  end;

  function  HashFun(Var S  : String) : integer;
  const InitialStripNum : integer = 1000;

implementation
uses FileIO, parser, cityobject, streetobject, geodist, Directory, stripreal, windows, myutil1, classes, inifiles;


function  TStripObject.FindByKey(Var Key : String) : String;
Var ID : integer;
begin
  ID := HashFind(Key);
  if ID >= 0 then
    begin
       setlength(Result, Strips[ID].DataLen);
       FetchStrip(ID, (@(result[1]))^);
    end
  else
    Result := '';
end;

function  TStripObject.HashFind(Var Key : String) : integer;
Var H : integer;
begin
   H := HashTable[HashFun(Key)];
   while H >= 0 do
     if KeyHash[H].Key = Key then
      begin
         Result := KeyHash[H].ID;
         exit;
      end
     else
        H := KeyHash[H].Next;
   Result := -1;
end;

Function TStripObject.CheckUpdate : boolean;
begin
  result := FileExists(Dir1 + 'update.ttt');
end;

procedure TStripObject.MakeCopy;
Var res, oldname, HFile, Updateurl : String;
    F : TMemIniFile;
begin
    OldName := Dir1+DBName;
    if BackupName <> '' then
       if not CopyFile(PChar(Oldname), PChar(BackupName), false) then
          begin
             Interf.SetStatus('Unable to copy the file :' + Dir1 + MainDbName);
          end;
    Sysutils.DeleteFile(Dir1 + 'update.ttt');
    if (PostUrl <> '') and (Webobject.webinterf.rooturl <> '') then
      begin
         F := TMemIniFile.Create(GetHardRootDir1 + IniFile);
         HFile := F.ReadString('strip' + inttostr(SectionNum), 'header', '');
         F.Free;
         UpdateUrl := PostUrl + '/' + Command +'?update=' + webinterf.rooturl + '/file?' + SavDir + '\'+DBName + '&header_url=' + webinterf.rooturl + '/file?' + SavDir + '\'+ HFile;
         res := ReadUrl(UpdateUrl);
      end;
end;

const LastRename : String = '';
function TStripObject.CompleteUpdate : boolean;
begin
    CSWork.Enter;
    try
      FileClose(StripF);
      if FileExists(Dir1 + MainDbName) then
       if (not Sysutils.DeleteFile(Dir1 + MainDbName)) or (FileExists(Dir1 + MainDbName)) then
        begin
          Interf.SetStatus('Unable to delete the file :' + Dir1 + MainDbName);
          result := false;
          exit;
        end;
      Sysutils.DeleteFile(Dir1 + TheFileName(MainDBNAME) + '.htb');
      RenameFile(Dir1 + TheFileName(DBName) + '.htb', Dir1+TheFileName(MainDBNAME) + '.htb');
      
      Sysutils.DeleteFile(Dir1 + TheFileName(MainDBNAME) + '.idx');
      RenameFile(Dir1 + DBName, Dir1+MainDBName);
      RenameFile(Dir1 + TheFileName(DBNAME) + '.idx', Dir1+TheFileName(MainDBNAME) + '.idx');
      DBName := MainDBName;
      result := true;
      StripF := FileOpen(Dir1+DBName, fmOpenRead or FmShareDenyNone);
      if StripF < 0 then
         raise exception.create('Could not open file ' + Dir1 + DBName);
    finally
      CSWork.Leave;
    end;
end;

procedure TStripObject.AddDictionary(F : integer; name : String);
Var P, Num, i, L, k : integer;
    S, Line : String;
begin
   setlength(Dictionaries, length(Dictionaries) + 1);
   with Dictionaries[length(Dictionaries)-1] do
     begin
       Field := F;
       ReadStringFile(Dir1 + Name, S);
       P := 1;
       while P < length(S) do
         begin
           ScanLine(S, P, Line);
           i := 1;
           while (i <= length(Line)) and (Line[i] in ['0'..'9']) do
             inc(i);
           Num := ValStr1(Copy(Line, 1, i-1));
           if Num >= 0 then
             if length(Table) <= Num then
               begin
                 L := length(Table);
                 setlength(Table, Num+1);
                 for k := L to Num - 1 do
                   Table[k] := '';
                 Table[Num] := Copy(Line, i + 1, length(Line) - i);
                 DeleteEndSpaces(Table[Num]);
               end;
         end;
     end;
end;

procedure TStripObject.MakeDictionary(Dict : String);
Var p, pp, F : integer;
    name, number : string;
begin
  p := 1;
  pp := p;
  while p < length(Dict) do
    begin
      if Dict[p] = ':' then
        begin
          name := copy(Dict, pp, p - pp);
          pp := p+1;
          while (pp <= length(Dict)) and (Dict[pp] <> ',') do
            inc(pp);
          number := copy(Dict, p+1, pp - p - 1);
          parser.deletespaces(name);
          parser.deletespaces(number);
          F := FindField(Number);
          if F > 0 then
            F := Fields[F].SrcNum
          else
            raise exception.Create('Dictionary field not found ' + Number);
          if F > 0 then
             AddDictionary(F, name);
          p := pp+1;
          pp := p;
        end
      else
        inc(p);
    end;
end;

procedure TStripObject.AddFieldsFromHeader;
Var RepNo, p, pp, sp, pn, Num, InsPos : integer;
    HDist, Line, FName, S : String;
    dtype : tfieldtype;
begin
  CalcAddress := -1;
  CompAddress := -1;
  P := 1;
  HDist := '';
  InsPos := 0;
  while P < length(Header) do
    begin
       ScanLine(Header, P, Line);
       if pos('FIELD-', Line) = 1 then
          begin
            pp := 7;
            while (Line[pp] <> TAB) and (line[pp] <> '.') do
               inc(pp);
            Num := ValStr(copy(Line, 7, pp - 7));
            if Line[pp] = '.' then
              begin
               inc(pp);
               sp := pp;
               while (Line[pp] <> TAB) do
                 inc(pp);
               RepNo := ValStr(copy(Line, sp, pp - sp));
              end
            else
              RepNo := 0;
            inc(pp);
            sp := pp;
            while (pp <= length(LIne)) and (Line[pp] <> TAB) do
               inc(pp);
            FName := copy(Line, sp, pp - sp);
            while pos('#', FName) <> 0 do
               begin
                 pn := pos('#', FName);
                 delete(Fname, pn, 1);
                 insert('n', fname, pn);
               end;
            dtype := cstring;
            while pp < length(LIne) do
              begin
                inc(pp);
                sp := pp;
                while (pp <= length(Line)) and (Line[pp] <> TAB) do
                   inc(pp);
                S := UpStr(copy(Line, sp, pp - sp));
                if pos('T:', s) = 1 then
                   begin
                     if s = 'T:STRING' then
                        dtype := cstring
                     else if UpStr(s) = 'T:NUMBER' then
                         dtype := cnumber;
                     break;
                   end;
              end;
            Addfield(Fname, Num, RepNo, dtype);
          end;
       if InsPos <> 0 then
         begin
           Line := Line + TAB + 'lat' + TAb + 'lon' + TAB +'distance' + TAB + 'compass_direction' + TAB +'offset';
           InsPos := 0;
         end;
       if (Line = '=') then
         begin
           InsPos := length(HDist);
           HDist :=
                   HDist +
                   'FIELD-' + inttostr(Num+1) +TAB+'lat	latitude	F:10+4	T:number	A:n' + #13+#10+
                   'FIELD-' + inttostr(Num+2) +TAB+'lon	longitude	F:10+4	T:number	A:n' + #13+#10+
                   'FIELD-' + inttostr(Num+3) +TAB+'distance	Distance	F:10+4	T:number	A:n' + #13+#10+
                   'FIELD-' + inttostr(Num+4) +TAB+'compass_direction	Compass direction:  N S W E NW SW SE NE ' +#13+#10+
                   'FIELD-' + inttostr(Num+5) +TAB+'offset	Degree that is added clockwise to the compass direction, prefixed with sign' + #13+#10;
         end;
       HDist := HDist + Line + #13 + #10;
    end;
    HeaderDist := HDist;
end;

{function TStripObject.MakeHeader(prices : boolean; distance: boolean) : String;
Var i : integer;
    Names : String;
begin
   Result := HeaderHat;
   Names := '';
   for i := 0 to length(Fields) - 1 do
     begin
       result :+ result + 'FIELD-' + inttostr(Files[i].SrcNo) + TAB + Files[i].Name + TAB + Fields[i].Comment + #13+#10;
       names := Names + Files[i].Name + TAB;
     end;
   Result := Result + #13+#10 + '=' + #13+#10 + Names + #13+#10 + '==';
end;}

procedure TStripObject.AddFields(FieldNames : String);
Var p, pp, F : integer;
    name, number : string;
begin
  AddFieldsFromHeader;
  if FieldNames <> '' then
     Fields := nil;
  p := 1;
  pp := p;
  F := 0;
  while p <= length(FieldNames) do
    begin
      if (p= length(FieldNames)) or (fieldnames[p] in [':', ',']) then
        begin
          if p= length(FieldNames) then
            inc(p);
          name := copy(FieldNames, pp, p - pp);
          if (p < length(FieldNames)) and (fieldnames[p] = ':') then
            begin
              pp := p+1;
              while (pp <= length(FieldNames)) and (FieldNames[pp] in ['0'..'9']) do
                inc(pp);
              number := copy(FieldNames, p+1, pp - p - 1);
              parser.deletespaces(name);
              F := ValStr(number);
              Addfield(name, F);
              p := pp+1;
              pp := p;
            end
          else
            begin
              inc(F);
              Addfield(name, F);
              P := P + 1;
              pp := p;
            end;
        end
      else
        inc(p);
    end;
end;

function TStripObject.findfield(FieldName : string) : integer;
Var i : integer;
begin
   for i := 0 to length(Fields) - 1 do
     if Upstr(Fields[i].Name) = Upstr(FieldName) then
       begin
         result := i;
         exit;
       end;
   result := -1;
end;

procedure TStripObject.AddField(FieldName : String; SourceNum : integer; RepNo : integer; dtype : tfieldtype);
begin
  setlength(Fields, length(Fields) + 1);
  Fields[length(Fields) - 1].Name := FieldName;
  if Upstr(FieldName) = 'CALC_ADDRESS' then
     CalcAddress := SourceNum;
  if Upstr(FieldName) = 'COMP_ADDRESS' then
     CompAddress := SourceNum;
//  Fields[length(Fields) - 1].Number := FieldNum;
  Fields[length(Fields) - 1].SrcNum := SourceNum;
  Fields[length(Fields) - 1].RepNum := RepNo;
  Fields[length(Fields) - 1].dtype := dtype;
  if FieldName = 'latitude' then
    SkipLat := SourceNum -1;
  if FieldName = 'longitude' then
    SkipLon := SourceNum - 1;
end;

function TStripObject.MapFields(Src : String; SrcObj : TStripObject) : String;
Var Field : String;
    N, i : integer;
begin
   for i := 0 to length(Fields) - 1 do
     begin
        N := SrcObj.FindField(Fields[i].Name);
        if N >= 0 then
           ExtractFieldByNum(Src, SrcObj.Fields[N].SrcNum, Field)
        else
           Field := '';
        if i = 0 then
          Result := Field
        else
          Result := Result + TAB + Field;
     end;
end;

function TStripobject.ProduceList(F : integer) : String;
Var D : TDIR;
    SS : String;
    S : String;
    i : integer;
begin
  D := TDir.Create(Dir1 + Fields[f].Name + '.lst');
  if FileExists(Dir1 + Fields[f].Name + '.lst') then
     D.Load
  else
    begin
      for i := 0 to NumStrip - 1 do
         begin
            setlength(S, Strips[i].DataLen);
            FetchStrip(i, (@(S[1]))^);
            SS := FetchField(F, S);
            D.Add(SS);
         end;
      D.Save(true);
    end;
  Result := '';
  for i := 0 to length(D.Table) - 1 do
     Result := Result + D.Table[i].Name + #13 + #10;
  D.Free;
end;

procedure TStripObject.Init;
Var i : integer;
begin
   for i := 0 to HashMax do
     HashTable[i] := -1;
//   Fields := nil;
   KeyHashLen := 0;

   //numfind_regexp := TRegExpr.Create;      //creates regexp
   //dist_regexp := TRegExpr.Create;      //creates regexp
   //numfind_Compile;
   //dist_Compile;

   ConvertToregular := nil;
   StripF := -1;
   Stree := nil;
   CSWork := nil;
   FieldLine := '';
   NumStrip := 0;
   Setlength(Strips, round(InitialStripNum * 1.1));
   if KeyField >= 0 then
      setlength(KeyHash, round(InitialStripNum * 1.1));
   StripDataSize := 0;
   StripData := '';
   FilUrlPos := pos('FILLED FORM URL:', Header);
   if FilUrlPos <> 0 then
     inc(FilUrlPos, length('FILLED FORM URL:'));
   ServerCommand := '';
   if MergeObj = nil then
     CSWork := TCriticalSection.Create
   else
     begin
        if not MergeObj.DBExists then // step1: load the part of the merged objects
          begin
            LoadAllFiles;
            if MergeObj.LastMerge = self then // if it is the last part of the merge then build db
              begin
                MergeObj.Calibrate;
                MergeObj.SaveBase;
              end;
          end;
        exit;
     end;
   Interf.SetStatus(Format('Loading %s database ...', [DBName]));
   if FileExists(Dir1 + DBName) then
     begin
       DBExists := true;
       LoadBase;
     end
   else
     begin
       DBExists := false;
       if LastMerge <> nil then // exit if the object is composed of several subobjects that need to be merged in step 1
          exit;
       LoadAllFiles;
       SaveBase;
       Calibrate;
       Interf.SetStatus('Done.');
     end;
   if ioresult <> 0 then
      Interf.SetStatus(Format('ERROR Loading %s database ...', [DBName]));
end;

destructor TStripObject.Free;
begin
   if CSWork <> nil then
     begin
       CSWork.Enter;
       CSWork.Leave;
       CSWork.Free;
     end;
   if STree <> nil then
     Stree.Free;
   if StripF >= 0 then
     FileClose(StripF);
//   CloseFile(StripF);
   StripF := -1;
end;

procedure TStripObject.LoadAllFiles;
Var i : integer;
begin
   LoadError := '';
   BadAddress := 0;
   GoodAddress := 0;
   KeyHash := nil;
   for i := 0 to HashMax do
      HashTable[i] := -1;
   Interf.SetStatus(Format('Building %s database ...', [DBName]));
   Files := nil;
   ScanDir(Dir1, AddFile1);
   SortFiles;
   DeleteDupFiles;
   ScanDir(Dir1, AddFile);
   if NumStrip = 0 then
      LoadError := 'Load error: No records were valid'
   else
      LoadError := 'OK. ' + 'Statistics: Bad=' + inttostr(BadAddress) + ' Good=' + inttostr(GoodAddress);
end;


function  HashFun(Var S  : String) : integer;
VAr i : integer;
begin
   Result := 0;
   for i := 1 to length(S) do
      Result := Result + ord(S[i]) shl (i mod 8);
   if Result < 0 then
      Result := -Result;
   Result := Result Mod HashMax;
end;

procedure TStripObject.AddToHash(Var Key : String; ID : integer);
Var H : integer;
begin
   H := HashFun(Key);
   inc(KeyHashLen);
   if KeyHashLen >= length(KeyHash) then
      setlength(KeyHash, round(length(KeyHash) *1.3) + 10);
   KeyHash[KeyHashLen-1].Key := Key;
   KeyHash[KeyHashLen-1].ID := ID;
   KeyHash[KeyHashLen-1].Next := HashTable[H];
   HashTable[H] := KeyHashLen-1;
end;

procedure TStripObject.DeleteFromHash(Key : String);
Var PH, H : integer;
begin
   H := HashTable[HashFun(Key)];
   PH := H;
   while H >= 0 do
     if KeyHash[H].Key = Key then
      begin
         if PH = H then
           HashTable[HashFun(Key)] := KeyHash[H].Next
         else
           KeyHash[PH].Next := KeyHash[H].Next;
         exit;
      end
     else
        begin
          PH := H;
          H := KeyHash[H].Next;
        end;
end;

procedure TStripObject.SaveHash;
Var i : integer;
    F : TFileIO;
begin
   F := TFileIo.CReate(Dir1 + TheFileName(DBName) + '.HTB', true, false);
   F.WriteInt(KeyHashLen);
   for i := 0 to KeyHashLen - 1 do
       begin
          F.WriteString(KeyHash[i].Key);
          F.WriteInt(KeyHash[i].ID);
       end;
   F.Free;
end;

procedure TStripObject.LoadHash;
Var Max, i, ID : integer;
    S, Key, Key2 : String;
    F : TFileIO;
begin
   if KeyField < 0 then
      exit;
   if not FileExists(Dir1 + TheFileName(DBName) + '.HTB') then
      begin
        for i := 0 to HashMax do
          HashTable[i] := -1;
        for i := 0 to NumStrip - 1 do
         begin
            setlength(S, Strips[i].DataLen);
            FetchStrip(i, (@(S[1]))^);
            ExtractFieldByNum(S, KeyField, Key);
            if KeyField1 > 0 then
              begin
                ExtractFieldByNum(S, KeyField1, Key2);
                Key := Key + Key2;
              end;
            parser.DeleteSpaces(Key);
            AddToHash(Key, i);
          end;
        SaveHash;
        exit;
      end;
   F := TFileIo.CReate(Dir1 + TheFileName(DBName) + '.HTB');
   for i := 0 to HashMax do
     HashTable[i] := -1;
   Max := F.REadInt;
   setlength(KeyHash, Max);
   for i := 0 to Max - 1 do
       begin
          F.ReadString(Key);
          ID := F.ReadInt;
          if Key <> '' then
            AddToHash(Key, ID)
          else
            Key := '';
       end;
   F.Free;
end;


procedure TStripObject.ScanDir(D1 : String; P : TFileProc);
Var SR : TSearchRec;
begin
   if FindFirst(D1 + '*.*', faAnyFile, SR) <> 0 then
      exit;
   try
   while true do
     begin
       if (SR.Name[1] <> '.') and (SR.Name <> DBName)
         and (SR.Name <> 'Stree.db') then
          begin
             if (SR.Attr and FaDirectory) <> 0 then
               ScanDir(D1 + SR.Name + '\', P)
             else
               P(D1 + SR.Name );
          end;
       if FindNext(SR) <> 0 then
         break;
     end;
   finally
     Sysutils.findClose(SR);
   end;
end;

procedure TStripObject.Calibrate;
Var i : integer;
begin
   Interf.SetStatus('Calibrating ...');
   MinY := 1e10;
   MinX := 1e10;
   MaxY := -1e10;
   MaxX := -1e10;
   for i := 0 to NumStrip - 1 do
     with Strips[i] do
     begin
      if X > maxX then
        maxX := X;
      if X < minX then
        minX := X;
      if Y > maxY then
        maxY := Y;
      if Y < minY then
        minY := Y;
     end; // for
   BuildStree;
end;

procedure TStripObject.ObjCoor(ObjID : integer; Var X, Y : single);
begin
  X := Strips[ObjId].X;
  Y := Strips[ObjId].Y;
end;

procedure TStripObject.BuildStree;
Var i : integer;
begin
   Interf.SetStatus('Building S-tree ...');
   Stree := TStree.Create(MinX-2, MinY-2, MaxX+2, MaxY+2, 8, 4, NumStrip);
   for i := 0 to NumStrip-1 do
     if Strips[i].X <> 0 then
       Stree.AddObject(i, Strips[i].X, Strips[i].Y, ObjCoor);
   TotalObjects := NumStrip;
   TotalVertixes := NumStrip;
end;

procedure TStripObject.Rename;
Var NewName : String;
begin
    CSGlobal.Enter;
    try
      FileClose(StripF);
      NewName := Dir1 + formatdatetime('yyyymmddhhnn_', now) + DBName;
      LastRename := NewName;
      RenameFile(Dir1 + DBName, NewName);
      StripF := FileOpen(NewName, fmOpenRead or FmShareDenyNone);
{      StripF := FileOpen(NewName, fmOpenRead + fmShareDenyNone);
      if StripF < 0 then
         raise exception.create('Could not open file ' + Dir1 + DBName);}
    finally
      CSGlobal.Leave;
    end;
end;


procedure TStripObject.LoadBase;
Var S, nw, nr, i : integer;
    F : File;
    d, dmax : double;
    OldStrips : array of TOldStripRec; // 0..NumVertexes - 1
begin
   Interf.SetStatus('Loading database ' + DBName);
   if UseRam and (MemAvail > 300000000) then
     begin
       Interf.SetStatus('Using RAM memory for ' + DBName);
       ReadStringFile(Dir1+DBName, StripData)
     end
   else
     begin
       Interf.SetStatus('Using DISK storage for ' + DBName);
       StripData := '';
       StripF := FileOpen(Dir1+DBName, fmOpenRead + fmShareDenyNone);
       if StripF < 0 then
          raise exception.create('Could not open file ' + Dir1 + DBName);
{       FileMode := 0;
       AssignFile(StripF, Dir1+DBName);
       reset(StripF, 1);}
     end;
   if not FileExists(Dir1 + TheFileName(DBNAME) + '.idx') then
      begin
        assignfile(F, Dir1+'Stree.db');
        reset(F, 1);
        S := FileSize(F);
        NumStrip := S div sizeof(TOldStripRec);
        setlength(OldStrips, NumStrip);
        setlength(Strips, NumStrip);
        blockread(F, (@OldStrips[0])^, NumStrip * sizeof(TOldStripRec), nr);
        closefile(F);
        for i := 0 to NumStrip - 1 do
          begin
             Strips[i].X := OldStrips[i].X;
             Strips[i].Y := OldStrips[i].Y;
             d := abs(OldStrips[i].X - Strips[i].X)/MileX(Strips[i].Y);
             if d > dmax then
               dmax := d;
             d := abs(OldStrips[i].Y - Strips[i].Y)/MileY;
             if d > dmax then
               dmax := d;
             Strips[i].DataStart := OldStrips[i].DataStart;
             Strips[i].DataLen := OldStrips[i].DataLen;
          end;
        assignfile(F, Dir1 + TheFileName(DBNAME) + '.idx');
        rewrite(F, 1);
        blockwrite(F, (@Strips[0])^, NumStrip * sizeof(TStripRec), nw);
        closefile(F);
      end
   else
      begin
        assignfile(F, Dir1 + TheFileName(DBNAME) + '.idx');
        reset(F, 1);
        S := FileSize(F);
        NumStrip := S div sizeof(TStripRec);
        setlength(Strips, NumStrip);
        blockread(F, (@Strips[0])^, NumStrip * sizeof(TStripRec), nr);
        closefile(F);
      end;
   LoadHash;
   Calibrate;
end;

procedure TStripObject.SaveBase;
Var nw : integer;
    F : File;
begin
   Interf.SetStatus('Saving database ...');
   if UseRam then
     begin
       assignfile(F, Dir1+DBName);
       rewrite(F, 1);
       blockwrite(F, (@StripData[1])^, StripDataSize, nw);
       closefile(F);
     end
   else
     if NumStrip > 0 then
       begin
         FileClose(StripF);
//         CloseFile(StripF);
         StripData := '';
         StripF := FileOpen(Dir1+DBName, fmOpenRead + fmShareDenyNone);
{         AssignFile(StripF, Dir1+DBName);
         reset(StripF, 1);}
       end;
   assignfile(F, Dir1 + TheFileName(DBNAME) + '.idx');
   rewrite(F, 1);
   blockwrite(F, (@Strips[0])^, NumStrip * sizeof(TStripRec), nw);
   closefile(F);
   SaveHash;
end;

procedure TStripObject.AddStrip(Var Lat, Lon: String; Line : String);
Var Start : int64; nw : integer;
    Key, Key2 : String;
    pp, P : integer;
    CType, PAddr, CalcAddr : String;
begin
  if MergeObj <> nil then
    begin
       MergeObj.AddStrip(Lat, Lon, MergeObj.MapFields(Line, self));
       exit;
    end;
  if CalcAddress >= 0 then
     begin
         P := 1;
         SkipFields(Line, CalcAddress-1, P);
         pp := p;
         ExtractField(Line, PAddr, P);
         if PAddr = '' then
            begin
              if (istreetobject <> nil) and istreetobject.loaded then
                 CalcAddr := istreetobject.Find2Streets(ReadDouble(Lon), ReadDouble(Lat), true)
              else
                 begin
                  CType := '';
                  CalcAddr := rstreetobject.ProcessQuery('x1='+Lon + '&y1=' + Lat + '&friendly=1',false, CType, false);
                 end;
             if length(Calcaddr) > 0 then
             if calcaddr[length(Calcaddr)] = #$A then
               setlength(calcaddr, length(Calcaddr) - 1);
             Insert(CalcAddr, Line, PP);
            end;
     end;
  Line := Line + #10;
  if NumStrip >= LENGTH(STRIPS) then
    setlength(Strips, round(NumStrip * 1.3) + 100);
  Start := StripDataSize+1;
  StripDataSize := StripDataSize + length(Line);
  if KeyField >= 0 then
    begin
      ExtractFieldByNum(LIne, KeyField, Key);
      if KeyField1 > 0 then
        begin
          ExtractFieldByNum(Line, KeyField1, Key2);
          Key := Key + Key2;
        end;
      parser.DeleteSpaces(Key);
      AddToHash(Key, NumStrip);
    end;
  Strips[NumStrip].X := ReadDouble(Lon);
  Strips[NumStrip].Y := ReadDouble(Lat);
  Strips[NumStrip].DataStart := Start;
  Strips[NumStrip].DataLen := length(Line)-1;
  if  UseRam then
    begin
      if StripDataSize > length(StripData) then
        setlength(StripData, round(StripDataSize * 1.3) + 10);
      move((@Line[1])^, (@StripData[Start])^, length(line));
    end
  else
    begin
      if NumStrip = 0 then
         begin
           StripF := FileCreate(Dir1+DBName);
{           AssignFile(StripF, Dir1+DBName);
           rewrite(StripF, 1);}
         end;
      nw := FileWrite(StripF, (@Line[1])^, length(line))
//      BlockWrite(StripF, (@Line[1])^, length(line), nw);
    end;
  inc(NumStrip);
end;

procedure TStripObject.Backup;
Var F, i, L, nw : integer;
    S : String;
begin
   if BackupDir1 = '' then
      exit;
   if Backupdir1[length(Backupdir1)] <> '\' then
     Backupdir1 := Backupdir1 + '\';
   F := FileCreate(BackupDir1 + formatdatetime('yyyymmdd_hhnnss_', now) + DBName);
   for i := 0 to Numstrip - 1 do
      begin
         L := Strips[i].DataLen;
         if length(S) < (L + 1) then
           setlength(S, L + 1);
         FetchStrip(i, (@(S[1]))^);
         S[L+1] := #10;
         nw := FileWrite(F, (@S[1])^, L+1)
     end;
   FileClose(F);
end;

procedure TStripObject.TranslateFields(Var S : String);
Var R : String;
    i, P : integer;
    SS : String;
begin
   for i := 0 to length(Fields) - 1 do
      begin
        P := 1;
        SkipFields(S, Fields[i].SrcNum-1, P);
        ExtractField(S, SS, P);
        if i = 0 then
          R := SS
        else
          R := R + TAB + SS;
      end;
   S := R;
end;

procedure translatedms(Var lat : string; Mult : integer);
Var p, pp, deg, min, sec : integer;
begin
  p := 1;
  while (p <= length(lat)) and (lat[p] <> ':') do
    inc(p);
  if (p > length(lat)) or (p = 1) then
     begin
       lat := '0';
       exit;
     end;
  deg := ValStr(Copy(lat, 1, p-1));
  inc(p);
  min := valstr(Copy(lat, p, 2));
  sec := valstr(Copy(lat, p+3, 2));
  lat := CoorStr(Mult*(deg + (min + sec/60)/60));
end;

function extractword(Var Line : string; p : integer) : string;
Var pp : integer;
begin
   pp := p;
   while (p <= length(LIne)) and (Line[p] <> ' ') and (Line[p] <> TAB) do
      inc(p);
   result := copy(Line, pp, p - pp);
end;

const _loaded : integer = 0;
      _LoadedSize : integer = 0;
      _NextL : integer = 0;
      coorCorrected : integer = 0;
      coorAdded : integer = 0;

procedure TStripObject.VerifyFolio;
Var Acc, MinAcc, BestLeftRight, BestD0, BestOffset : double;
    i, j : integer;

function CalculateAccuracy : double;
Var MeanPerim, TPer, Area, Perim, X, Y, XX, YY, D, TotalD : double;
    Approx, C, i, NumD : integer;
    sArea, sPerim, SType2, Error, S, SS, Lon, Lat, House, SHouse, PDir, SName, SType, DDir, Zip : String;
    Debug : TDebug;
begin
  TotalD := 0;
  NumD := 0;
  TPer := 0;
  Debug.Debug := false;
  for i := 0 to NumStrip - 1 do
     begin
        setlength(S, Strips[i].DataLen);
        FetchStrip(i, (@(S[1]))^);
        ExtractFieldByNum(S, 1, sArea);
        ExtractFieldByNum(S, 2, sPerim);
        Val(Sarea, area, C);
        Val(SPerim, Perim, C);
        if i = 0 then
           MeanPerim := 1000
        else
           MeanPerim := TPer / i;
        TPer := TPer + Perim;
        if (Perim <= MeanPerim*2) then
           begin
              ExtractFieldByNum(S, 12, House);
              ExtractFieldByNum(S, 13, SHouse);
              ExtractFieldByNum(S, 14, PDir);
              ExtractFieldByNum(S, 15, Sname);
              ExtractFieldByNum(S, 16, SType);
              ExtractFieldByNum(S, 17, SType2);
              ExtractFieldByNum(S, 18, DDir);
              ExtractFieldByNum(S, 19, Zip);
              ExtractFieldByNum(S, SkipLat+1, Lat);
              ExtractFieldByNum(S, SkipLon+1, Lon);
              Val(Lon, xx, C);
              Val(Lat, yy, C);
              SS := House;
              if SHouse <> '' then
                SS := SS + '-' + SHouse;
              SS := SS + ' ' + PDir + ' ' + Sname + ' ' + Stype + ' ';
              if SType2 <> '' then
                SS := SS + SType2 + ' ';
              SS := SS + DDir;
              istreetobject.FindHouseByZip(Ss, zip, '', '', X, Y, Approx, Debug, error, false);
              if (Approx = A_Exact)  then
                 begin
                    D := EarthDistMet(X, Y, xx, yy);
                    if D < 1000 then
                       begin
                         TotalD := TotalD + D;
                         inc(NumD);
                       end
                    else
                      begin
                         AppendFile(Dir1 + 'WrongCoor.html',
                         '<p><a href="http://localhost:' + WebObject.WebInterf.Port.Text + '/street?debug=1&zip=' + ZIP + '&street=' + SS+'">' + SS + ' ' + Zip + '</a>&nbsp; --'+
                         MapUrl('Correct at ' + format('%.2f', [D]), xx, yy) + '<p>');
                      end;
                 end;
           end;
     end;
   if TotalD > 0 then
      Interf.SetStatus('Mean miscalculated distance = ' + format('%.5f', [TotalD/NumD]));
   result := TotalD/Numd;
end;

begin
   MinAcc := 100000;
   for i := 0 to 5 do
      for j := 0 to 5 do
         begin
           Acc := CalculateAccuracy;
           if Acc < MinAcc then
              begin
                 MinAcc := Acc;
                 BestLeftRight := LeftRightFactor;
                 BestD0 := D0Factor;
//                 BestOffset := OffsetFactor;
                 Interf.SetStatus('Best Factors: '+format('LeftRight: %.5f  Offset: %.5f', [LeftRightFactor, D0Factor]));
              end;
           LeftRightFactor := 60 + 2*i;
//           OffsetFactor := 0.1 + 0.02*i;
           D0Factor := 15 + 2*j;
        end;
    Interf.SetStatus('Best Factors: '+format('LeftRight: %.5f  Offset: %.5f', [BestLeftRight, BestD0]));
end;

const _debug : integer = 0;
procedure TStripObject.AddFile(Name : String);
Var Line  : String;
    LL, p, pp, ps, Start, C, i : integer;
    Year, Month, Day, Hour, Min : word;
    Error, Lon, Lat: String;
    S, Prefix, SS, SStreet, SZip, SCity, SState : String;
    X, y, xx, yy, D, ld : double;
    NumD, fol, Approx, L : integer;
    Debug : TDebug;
    TotalD : double;
    F : TFileIO;
    OK : boolean;
    SID, Key, SUrl : String;
    CType, streetcoor : String;
    FolioFound : boolean;
begin
   fol := -1;
   NumD := 0;
   TotalD := 0;
   if TheFileExt(Upstr(Name)) = 'ZIP' then
     exit;
   if FileExt <> '' then
     if TheFileExt(Upstr(Name)) <> Upstr(FileExt) then
       exit;
   if _LoadedSize > _NextL then
     begin
       Interf.SetStatus(inttostr(_LoadedSize div (1024*1024)) +' MB loaded ' + inttostr(_loaded) +
         ' files loaded, ' + inttostr(NumStrip) +' objects loaded into ' + DBName);
       _NextL := _LoadedSize + 10*1024*1024;
     end;
   inc(_loaded);
//   Interf.SetStatus('Loading ' + Name + ' into ' +  DBName);
   F := TFileIO.Create(Name);
   OK := true;
   try
   if fileformat = 'strip' then
     begin
       while true do
         begin
          if not F.ReadLine(Line) then
             begin
               LoadError := 'Error loading ' + Name + ' missing = in the header';
               Interf.SetStatus('Error loading ' + Name + ' missing = in the header');
               AppendFile(GetHardRootDir1 + 'LoadError.log', GetTimeText + 'Error loading ' + Name + ' missing = in the header');
               exit;
             end;
          if Line = '=' then
             break;
         end;
       F.ReadLine(Line);
       if FieldLine = '' then
         FieldLine := Line
       else if FieldLine <> Line then
         begin
           Interf.SetStatus('Header mismatch: ' + Name);
           LoadError := 'Header mismatch: ' + Name;
           AppendFile(GetHardRootDir1 + 'LoadError.log', GetTimeText + 'Header mismatch: ' + Name);
//           exit;
         end;
       while true do
         begin
          if not F.ReadLine(Line) then
             begin
               LoadError := 'Error loading ' + Name + ' Malformed file header, missing ==';
               Interf.SetStatus('Error loading ' + Name + ' Malformed file header, missing ==');
               AppendFile(GetHardRootDir1 + 'LoadError.log', GetTimeText + 'Error loading ' + Name + ' Malformed file header, missing ==');
               exit;
             end;
          if Line = '==' then
             break;
         end;
       OK := true;
     end
   else
     begin
  {        if UpStr(TheFileExt(Name)) <> 'CSV' then
          exit;}
         Pp := 1;  OK := true;
         if SkipFirstLine then
           OK := F.ReadLine(Line);
     end;
  if ParseNameDate then
     begin
       if YearPos > 0 then
         begin
           Name := TheFileName(Name);
           Year := ValStr(Copy(Name, YearPos, 4));
           Day := ValStr(Copy(Name, YearPos + 4, 3));
           Hour := ValStr(Copy(Name, HourPos, 2));
           Min := ValStr(Copy(Name, HourPos+2, 2));
           try
             D := EncodeDate(Year, 1, 1) + Day - 1 + EncodeTime(Hour, Min, 0, 0);
           except on E : Exception do
             D := 0;
           end;
         end
       else
         begin
           D := parsename(TheFileName(Name), prefix, Year, Month, Day );
         end;
       if D <= 0 then
         exit;
     end;
   LL := 0;
   while OK do
     begin
       OK := F.ReadLine(Line);
{       if pos('Food and Dining:', Line) <> 0 then
          AppendFile(Dir1+'dining.txt', Line);}
       inc(LL);
       if Line = '=' then
         break;
       if fileformat = 'txt' then
         begin
           lat := extractword(Line, latitudestart);
           lon := extractword(Line, longitudestart);
           if coorformat = 'dms' then
             begin
               translatedms(lat, 1);
               translatedms(lon, -1);
             end;
           Line := copy(Line, extractfrom, extractlength);
           DeleteEndSpaces(Line);
           for ps := 1 to length(LIne) do
             if Line[ps] = ' ' then
               Line[ps] := '_';
           Line := Line + TAB + lat + TAB + lon;
         end
       else
         begin
           if fileformat = 'csv' then
             begin
               CSVToTab(Line);
               if ParseNameDate then
                   begin
                     if YearPos > 0 then
                        Line := command + TAB + FormatDateTime('yyyy/mm/dd', D) + TAB + FormatDateTime('hh:nn', D) + TAB + Line
                     else
                        Line := Prefix + TAB + FormatDateTime('yyyy/mm/dd', D) + TAB + TAB + Line;
                   end;
               TranslateFields(Line);
             end;
           if SkipLat >= 0 then
             begin
               P := 1;
               SkipFields(Line, SkipLat, P);
               ExtractField(Line, Lat, P);
               Val(Lat, lD, C);
               if ((lD > 90) or (lD < -90)) then
                 begin
                   AppendFile(Dir1 + 'loaderror.log', 'Lat =' + Lat + ' ---- FILE: ' + Name + ' ----LINE#' + inttostr(LL) + ' ---- DATA: ' + Line);
                   Lat := '';
                 end;
               P := 1;
               SkipFields(Line, SkipLon, P);
               ExtractField(Line, Lon, P);
               Val(Lon, lD, C);
               if ((lD > 180) or (lD < -180)) then
                 begin
                   AppendFile(Dir1 + 'loaderror.log', 'Lon =' + Lon + ' ---- FILE: ' + Name + ' ----LINE#' + inttostr(LL) + ' ---- DATA: ' + Line);
                   Lon := '';
                 end;
             end
           else
             Lat := '';
           FolioFound := false;
           if UseFolio then
              begin // diabled temporarily because the folio object is deleted
{                 if fol <= 0 then
                    fol := FindField('folio_number');
                 if fol < 0 then
                    raise exception.create('folio folio_number field not found');
                 Key := GetField(fol, Line);
                 if Key <> '' then
                   begin
                     while pos('-', key) <> 0 do
                        delete(key, pos('-', key), 1);
                     if Key = '0232110070211' then
                        Key := '0232110070211';
                     if Key = '0000000000000' then
                       Key := '';
                     if Key = '9999999999999' then
                       Key := '';
                     if Key <> '' then
                       begin
                           S := TStripObject(Interf.Webobjects[FolioObj]).FindByKey(key);
                           if (S = '') and (command = 're2') then
                              begin
                                 delete(key, length(key) - 3, 4);
                                 key := key + '0001';
                                 S := TStripObject(Interf.Webobjects[FolioObj]).FindByKey(key);
                              end;
                           if S <> '' then
                              begin
                                ExtractFieldByNum(S, TStripObject(Interf.Webobjects[FolioObj]).SkipLat+1, Lat);
                                ExtractFieldByNum(S, TStripObject(Interf.Webobjects[FolioObj]).SkipLon+1, Lon);
                                FolioFound := true;
                                ReplaceFieldByNum(Line, SkipLat, Lat);
                                ReplaceFieldByNum(Line, SkipLon, Lon);
                              end;
                       end;
                   end;}
              end;
           Approx := 0;
           if (SkipAddress >= 0) and (MinApprox > 0) and (Lat = '') then
             begin
               P := 1;
               if SkipZip >= 0 then
                 begin
                   SkipFields(Line, SkipZip, P);
                   ExtractField(Line, SZip, P);
                 end
               else
                 Szip := '';
               P := 1;
               SkipFields(Line, SkipAddress, P);
               ExtractField(Line, SStreet, P);
{               P := 1;
               ExtractField(Line, SURL, P);
               if SUrl = 'http://n150.cs.fiu.edu/wde/images/sef/COM/M859677_101_12.jpg' then
                  SUrl := '';
               if SUrl = 'http://n150.cs.fiu.edu/wde/images/sef/COM/M882041_101_12.jpg' then
                  SUrl := '';}
               P := 1;
               SkipFields(Line, SkipCity, P);
               ExtractField(Line, SCity, P);
               P := 1;
               SkipFields(Line, SkipState, P);
               ExtractField(Line, SState, P);
               P := 1;
{               SkipFields(Line, 8, P);
               ExtractField(Line, SID, P);
               if SID = 'SCAA890837' then
                 SID := '';}
               Debug.Debug := false;
               if true then
                  begin
                    SS := SStreet;
    // FindHouseByZip(Var street, zip, City, State : String; Var X, Y : double; Var Approx : integer; Var Debug : TDebug; Var Error : String) : boolean;
                    if (istreetobject <> nil) and istreetobject.loaded then
                       istreetobject.FindHouseByZip(Ss, Szip, Scity, SState, X, Y, Approx, Debug, error, false)
                    else
                       begin
                        CType := '';
                        inc(_debug);
                        if _debug = 10960 then
                          _debug := 10960;
                        streetcoor := rstreetobject.ProcessQuery('street=' + SS + '&zip=' + SZip + '&city=' + SCity + '&state=' + SState, false, CType, false);
                        x := extractnumber('X=', streetcoor);
                        y := extractnumber('Y=', streetcoor);
                        Approx := round(extractnumber('Level=', streetcoor));
                       end;
                    if (Approx >= A_ZipCenter) and (not FolioFound) then
                      begin
                         AppendFile(Dir1 + 'bad_' + command + '_.txt', Line);
                         inc(BadAddress);
{                         if Approx = A_ZipCenter then
                           AppendFile(Dir1 + 'AddressError.txt', 'Using the zip center for' + TAB + Line + TAB + '***')
                         else if Approx = A_CityCenter then
                           AppendFile(Dir1 + 'AddressError.txt', 'Using the city center for' + TAB + Line + TAB + '***')
                         else if Approx >= A_CityCenter then
                           AppendFile(Dir1 + 'AddressError.txt', '!!!Address not found!!!' + TAB + Line+ '***');
                         AppendFile(Dir1 + 'NotFound.html',
                           '<p><a href="http://localhost/street?debug=1&zip='+SZIP+'&street='+Sstreet+'&city='+SCity+'&state='+SState+'">' + SStreet + ' ' + SCity + ' ' + SZip + '</a>&nbsp; --'+
                           '<a href="http://www.mapblast.com/myblast/map.mb?CMD=LFILL&CT='+ Lat + '%3A' +Lon+'%3A20000"> original</a><p>');}
                      end
                    else
                       inc(GoodAddress);
                    if Approx <= A_CityCenter then
                      begin
                         if Lat = '' then
                           begin
                             Lat := CoorStr(Y);
                             Lon := CoorStr(X);
                             if SkipLat < 0 then
                               Line := Line + TAB + LAT + TAB + LON
                             else
                                begin
                                  ReplaceFieldByNum(Line, SkipLat, Lat);
                                  ReplaceFieldByNum(Line, SkipLon, Lon);
                                end;
                             inc(CoorAdded);
                           end
                         else
                           begin
                              Val(Lon, xx, C);
                              Val(Lat, yy, C);
                              D := EarthDistMil(X, Y, xx, yy);
                              if (approx = A_exact) and (xx <> 0) then
                                 begin
                                   TotalD := TotalD + D;
                                   inc(NumD);
                                 end;
                              if (D > 1) and (approx = A_exact) then
                                begin
                                   AppendFile(Dir1 + 'WrongCoor.html',
                                   '<p><a href="http://localhost:' + WebObject.WebInterf.Port.Text + '/street?debug=1&zip=' + SZIP + '&street=' + Sstreet+'">' + SStreet + ' ' + SCity + ' ' + SZip + '</a>&nbsp; --'+
                                   MapUrl('Correct', xx, yy) + '<p>');
                                  if (approx = A_exact) and ((Not UseFolio) or (xx = 0)) then
                                    begin
                                       inc(CoorCorrected);
{                                       AppendFile(Dir1 + 'Corrected.html',
                                   '<p><a href="http://localhost:' + WebObject.WebInterf.Port.Text + '/street?debug=1&zip=' + SZIP + '&street=' + Sstreet+'">' + SStreet + ' ' + SCity + ' ' + SZip + '</a>&nbsp; --'+
                                   MapUrl('Correct', xx, yy) + '<p>');}
                                       Lat := CoorStr(Y);
                                       Lon := CoorStr(X);
                                       ReplaceFieldByNum(Line, SkipLat, Lat);
                                       ReplaceFieldByNum(Line, SkipLon, Lon);
                                    end;
                                end;
                           end;
                      end
                  end;
             end;
         end;
       if AppendLevel then
          Line := Line + TAB + inttostr(Approx);
       if command = 'blocks' then
          begin
               P := 1;
               ExtractField(Line, SID, P);


          end;
       if (Approx <= MinApprox) or (FolioFound) then
       if (Lat <> '') and (Lon <> '') then
          AddStrip(Lat, Lon, Line);
     end;
   finally
      if RemoveFile then
         RenameFile(Name, 'OLD\'+ Name + '.done');
      F.free;
      if (BadAddress + GoodAddress) <> 0 then
        Interf.SetStatus('Statistics: Bad=' + inttostr(BadAddress) + ' Good=' + inttostr(GoodAddress));
      if TotalD > 0 then
        Interf.SetStatus('Mean miscalculated distance = ' + format('%.5f', [TotalD/NumD]));
   end;

//     Interf.SetStatus('Coordinates Added: ' + inttostr(CoorAdded) + ' Corrected: ' + inttostr(CoorCorrected));
end;

procedure TStripObject.FetchStrip(idx : integer; Var V);
Var nr : integer;
begin
    if StripData <> '' then
       move((@StripData[Strips[idx].DataStart])^, V, Strips[idx].DataLen)
    else
      begin
        FileSeek(StripF, Strips[idx].DataStart-1, 0);
        FileRead(StripF, V, Strips[idx].DataLen);
{        seek(StripF, Strips[idx].DataStart-1);
        blockread(StripF, V, Strips[idx].DataLen, nr);}
      end;
end;


procedure TStripObject.SortDist(Var Entries : Array of TObjRec; Length : integer);
  procedure QuickSort(L, R: Integer);
  var
    I, J : Integer;
    T, X : TObjRec;
  begin
    I := L;
    J := R;
    X := Entries[(L + R) div 2];
    repeat
      while Entries[i].Dist < X.Dist do Inc(I);
      while X.Dist < Entries[J].Dist do Dec(J);
      if I <= J then
      begin
        T := Entries[I];
        Entries[I] := Entries[J];
        Entries[J] := T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J);
    if I < R then QuickSort(I, R);
  end;
begin
   QuickSort(0, Length - 1);
end;

function TStripObject.FetchField(F : integer; Var S : String) : string;
Var p, pp, ff : integer;
begin
   if Length(S) = 0 then
     begin
        Result := '';
        exit;
     end;
   P := 1;
   pp := p;
   ff := 0;
   while true do
     begin
        pp := p;
        while (p <= length(s)) and (S[p] <> TAB) do
          inc(p);
        inc(ff);
        if ff > f then
          break;
        if (p <= length(s)) and (S[p] = TAB) then
          inc(p);
     end;
   if (pp > length(S)) or (pp = p) then
     result := ''
   else
     result := copy(S, pp, p - pp);
end;

function GetField(SrcNum : integer; Var S : String; RepNum : integer) : string;
var p : integer;
begin
   p :=  0;
   result := getfield1(SrcNum, RepNum, S, p);
end;

function GetField1(SrcNum, RepNum : integer; Var S : String; Var p : integer) : string;
Var pp, f : integer;
begin
   if Length(S) = 0 then
     begin
        Result := '';
        exit;
     end;
   P := 1;
   pp := p;
   f := 0;
   while true do
     begin
        inc(f);
        if f >= SrcNum then
          break;
        if S[p] = '{' then
         begin
           while (p <= length(s)) and (S[p] <> '}') do
             inc(p);
           inc(p);
         end;
        pp := p;
        while (p <= length(s)) and (S[p] <> TAB) do
          inc(p);
        if (p <= length(s)) and (S[p] = TAB) then
          inc(p);
     end;
   if RepNum <> 0 then
      begin
         f := 0;
         while (p <= length(s)) and (S[p] <> '{') do
            inc(p);
         inc(p);
         while true do
           begin
              inc(f);
              if f >= RepNum then
                break;
              pp := p;
              while (p <= length(s)) and (S[p] <> TAB) and (S[p] <> '}') do
                inc(p);
              if (p <= length(s)) and ((S[p] = TAB) or (S[p] = '}')) then
                inc(p);
           end;
      end;
   pp := p;
   while (p <= length(s)) and (S[p] <> TAB) and (S[p] <> '}') do
     inc(p);
   if (pp > length(S)) or (pp = p) then
     result := ''
   else
     result := copy(S, pp, p - pp);
end;

function TStripObject.GetField(FieldIdx : integer; Var S : String) : string;
Var p : integer;
begin
  p := 1;
  Result := GetField1(fields[FieldIdx].SrcNum, fields[FieldIdx].RepNum, S, p);
end;

function TStripObject.CheckDate(Obj, Date, Oper : integer) : boolean;
begin
   result := true;
end;

function ValField(field : string) : int64;
Var d : double;
    c : integer;
begin
  d := 0;
  val(field, d, c);
  if (c <> 0) or (D > 1e14) then
    result := 0
  else
    result := round(d*1000);
end;

function ValField2(field : string; var err : boolean) : int64;
Var d : double;
    c : integer;
begin
  d := 0;
  val(field, d, c);
  Err := c <> 0;
  if not Err then
    if D > 1e14 then
      begin
       Err := true;
       result := 0;
      end;
  result := round(d*1000);
end;

const __DBG : integer = 0;
function TStripObject.Satisfies(Obj : integer; Var Exp : TExpression; Var S : String) : boolean;
Var j, i : integer;
    OrSat : boolean;
begin
   Result := false;
   OrSat := false;
   if Strips[Obj].DataLen = 0 then
      exit;
   inc(Exp.NumEval);
   for i := 0 to Exp.NumExp - 1 do
     begin
        Exp.Exp[i].OrSat := false;
        if Exp.Exp[i].Field = TheDateField then
          begin
           if not CheckDate(Obj, Exp.Exp[i].Value1, Exp.Exp[i].Oper) then
              begin
                 result := false;
                 exit;
              end
          end
        else
          begin
            if S = '' then
              begin
               setlength(S, Strips[Obj].DataLen);
               FetchStrip(Obj, (@(S[1]))^);
               if S = '' then
                 begin
                   Result := false;
                   exit;
                 end;
              end;
           if (Exp.Exp[i].Oper = OpEq) or  (Exp.Exp[i].Oper = OpOr) then
             begin
               if Exp.Exp[i].dtype = cnumber then
                  begin
                     inc(__DBG);
                     if (__DBG = 100) then
                        __DBG := 100;
                     if Exp.exp[i].Value1 <> ValField(GetField(Exp.Exp[i].Field, S)) then
                        begin
                           Result := false;
                           if Exp.Exp[i].Oper <> OpOr then
                             exit
                           else
                             OrSat := true;
                        end
                     else if Exp.Exp[i].Oper = OpOr then
                        Exp.Exp[i].OrSat := True;
                  end
               else if ((Exp.Exp[i].Field < 0) and (pos(Exp.Exp[i].Value, Upstr(S)) = 0)) or
                  ( (Exp.Exp[i].Field >= 0) and (pos(Exp.Exp[i].Value, UpStr(GetField(Exp.Exp[i].Field, S))) = 0)) then
                 begin
                   Result := false;
                   if Exp.Exp[i].Oper <> OpOr then
                      exit
                   else
                      OrSat := true;
                 end
               else if Exp.Exp[i].Oper = OpOr then
                  Exp.Exp[i].OrSat := True;
             end
           else if Exp.Exp[i].Oper = OpNe then
             begin
               if Exp.Exp[i].dtype = cnumber then
                  begin
                     if Exp.exp[i].Value1 = ValField(GetField(Exp.Exp[i].Field, S)) then
                        begin
                           Result := false;
                           exit;
                        end;
                  end
               else if ((Exp.Exp[i].Field < 0) and (pos(Exp.Exp[i].Value, Upstr(S)) <> 0)) or
                  ( (Exp.Exp[i].Field >= 0) and (pos(Exp.Exp[i].Value, UpStr(GetField(Exp.Exp[i].Field, S))) <> 0)) then
                 begin
                   Result := false;
                   exit;
                 end
             end
            else if Exp.Exp[i].Oper = OpGr then
             begin
               if Exp.Exp[i].dtype = cnumber then
                  begin
                     if Exp.exp[i].Value1 > ValField(GetField(Exp.Exp[i].Field, S)) then
                        begin
                           Result := false;
                           exit;
                        end;
                  end
               else if Exp.Exp[i].Value > UpStr(GetField(Exp.Exp[i].Field, S)) then
                 begin
                   Result := false;
                   exit;
                 end
             end
            else if Exp.Exp[i].Oper = OpLe then
               if Exp.Exp[i].dtype = cnumber then
                  begin
                     if Exp.exp[i].Value1 < ValField(GetField(Exp.Exp[i].Field, S)) then
                        begin
                           Result := false;
                           exit;
                        end;
                  end
             else if Exp.Exp[i].Value < UpStr(GetField(Exp.Exp[i].Field, S)) then
               begin
                 Result := false;
                 exit;
               end;
          end;
     end;
   if OrSat then
   for i := 0 to Exp.NumExp - 1 do
     if (Exp.Exp[i].Oper = OpOr) then
        begin
           OrSat := Exp.Exp[i].OrSat;
           for j := i + 1 to Exp.NumExp - 1 do
             if Exp.Exp[i].Field = Exp.Exp[j].field then
               OrSat := OrSat or Exp.Exp[i].OrSat;
           if not OrSat then
             begin
               Result := false;
               exit;
             end;
           for j := i + 1 to Exp.NumExp - 1 do
             if Exp.Exp[i].Field = Exp.Exp[j].field then
                Exp.Exp[j].OrSat := true;
        end;
   Result := true;
end;


//const mh : double = 0;
procedure TStripObject.FindStrips(Var Exp : TExpression; Var X1, Y1, X2, Y2 : double;
    limit : integer; Var S : String; Var ContentType : String; print : boolean;
    Dist : double; NumFind : integer; AppendCommand : boolean; commstr : String;
    Convert : boolean);
Var  Obj : dword;
     SI : TStreeIterator;
     P, Numfound, oldlen, i, k, V, ResLen, {NewLen,} Total : integer;
     Found : array of TObjRec;
     SS, RR, Dir : String;
     H, Heading, D, yc, xc, dd: double;
     xx, yy : single;
     RDist, Offset : double;
     RestrictDist : boolean;
     CType, CalcAddr, Line, NumField : string;
begin
   ResLen := 0;
   if commstr = '' then
     CommStr := Command;
   if NumFind > 0 then
     begin
      if Dist < 1e80 then
        begin
           RestrictDist := true;
           RDist := Dist;
        end
      else
        begin
          RDist := 0;
          RestrictDist := false;
        end;
      Dist := 0.5;
      if (RestrictDist) and (Dist > RDist) then
            Dist := RDist+0.00001;
      if Limit < NumFind then
        Limit := NumFind;
     end;
   if Dist < 1e80 then
      begin
        xc := x1;
        yc := y1;
        x1 := xc - Dist*MileX(yc);
        x2 := xc + Dist*MileX(yc);
        y1 := yc - Dist*MileY;
        y2 := yc + Dist*MileY;
      end
   else
      begin
        xc := (x1 + x2) / 2;
        yc := (y1 + y2) / 2;
      end;
   Dist := Dist * MetersPerMile;
   RDist := RDist * MetersPerMile;
   setlength(Found, limit);
   Total := 0;
   if Stree <> nil then
   repeat
       Stree.FindObjects(X1, X2, Y1, Y2, ObjCoor, Si);
       Obj := Stree.FindNextObject(SI);
       Total := 0;
       if (Obj = inull) and (NumFind <= 0) then
         begin
           S := '';//'===' + #10;
           exit;
         end;
       while Obj <> iNull do
         begin
           if true then
             begin
               inc(Total);
               Found[Total-1].ID := Obj;
               if Dist < 1e80 then
                 begin
                  ObjCoor(Obj, xx, yy);
//                  dd :=
                  Found[Total-1].Dist := EarthDistMet(xx,yy, xc, yc); //
//                  Found[Total-1].Heading := Heading;
                  if Found[Total-1].Dist > Dist then
                    dec(Total);
                 end;
               if (obj <> inull) and (Total >= limit) then
                 begin
                   if NumFind = 0 then
                     begin
                       while obj <> inull do
                         begin
                            Obj := Stree.FindNextObject(SI);
                            inc(Total);
                         end;
                       Dec(Total);
                       S := '==='+#10+format('ERROR: LIMIT EXCEEDED. FOUND:%d', [Total]) + #10 + '====';
                       exit;
                     end
                   else
                     begin
                       limit := limit * 2;
                       setlength(Found, limit);
                     end;
                 end;
             end;
           Obj := Stree.FindNextObject(SI);
          end;
{       if Exp.NumEval > Exp.MaxEval then
          break;}
       if (Total < NumFind) or ((exp.numexp > 0) and (total < Exp.maxeval)) then
          begin
            Dist := Dist * 2;
            if (RestrictDist) and (Dist > RDist) then
              Dist := RDist+0.1;
            D := Dist / MetersPerMile;
            x1 := xc - D*MileX(yc);
            x2 := xc + D*MileX(yc);
            y1 := yc - D*MileY;
            y2 := yc + D*MileY;
          end;
    until (NumFind = 0) or
     (not ((Total < NumFind) or ((exp.numexp > 0) and (total < Exp.maxeval)))) or
     (RestrictDist and (Dist >= RDist)) or (DIst > 18756200); // JAB Incremented radius to the diameter of the earth 7 926.3352 miles plus some miles to have more coverage
     //(RestrictDist and (Dist >= RDist)) or (DIst > 12756200); // JAB Incremented radius to the diameter of the earth 7 926.3352 miles
     //(RestrictDist and (Dist >= RDist)) or (DIst > 1000000);
    if (Dist < 1e80) and (Total > 0) then
      SortDist(Found, Total);
    SS := '';
    if (Exp.numexp > 0) and (exp.Maxeval > numfind)  then
      begin
        if (Total > exp.Maxeval) then
          Total := Exp.maxeval
      end
    else if (NumFind >0) and (Total > NumFind) then
      Total := NumFind;
//    NewLen := ResLen;
    Numfound := 0;
    for i := 0 to Total - 1 do
      begin
//       NewLen := ResLen + Strips[Found[i].ID].DataLen + 1;
       if print then
          begin
            ss := inttostr(round(Found[i].Dist));
            ObjCoor(Found[i].ID, xx, yy);
            Dir := calculateDirAndOffset(-calcheading(xc,yc, xx, yy), Offset);
            while(length(SS) > 0) and (SS[1] = ' ') do
              delete(SS, 1, 1);
            SS := TAB + coorstr(yy) + TAB + coorstr(xx) + TAB + SS +
                  TAB + Dir + TAB + inttostr(round(Offset));
            if AppendCommand then
              SS := SS + TAB + commstr;
//            inc(NewLen, length(SS) + 1);
          end;
       setlength(Line, Strips[Found[i].ID].DataLen);
       fetchStrip(Found[i].ID, (@(Line[1]))^);
       if CompAddress >= 0 then
           begin
              ObjCoor(Found[i].ID, xx, yy);
              if (istreetobject <> nil) and istreetobject.loaded then
                 CalcAddr := istreetobject.Find2Streets(xx, yy, true)
              else
                 begin
                  CType := '';
                  CalcAddr := rstreetobject.ProcessQuery('x1='+CoorStr(xx) + '&y1=' + CoorStr(yy) + '&friendly=1',false, CType, false);
                 end;
              if length(Calcaddr) > 0 then
               if calcaddr[length(Calcaddr)] = #$A then
                 setlength(calcaddr, length(Calcaddr) - 1);
             P := 1;
             SkipFields(Line, CompAddress-1, P);
             Insert(CalcAddr, Line, P);
           end;
       if length(Dictionaries) = 0 then
         begin
           if (Assigned(ConvertToregular)) and Convert then
             ConvertToregular(Line);
         end
       else
         begin
            for k := 0 to length(Dictionaries) - 1 do
              with Dictionaries[k] do
                 begin
                   ExtractFieldByNum(Line, Field, NumField);
                   V := ValStr1(NumField);
                   if (V >=0) and (V < length(Table)) and (Table[V] <> '') then
                       ReplaceFieldByNum(Line, Field-1, Table[V]);
                 end;
         end;
       if (Exp.NumExp = 0) or Satisfies(Found[i].ID, Exp, Line) then
         begin
             if Print then
               Line := Line + SS + #10
             else
               Line := Line + #10;
             if (reslen+length(Line)) > length(S) then
               setlength(S, reslen + length(Line) * 100);
             move((@Line[1])^, (@S[reslen+1])^, length(Line));
             inc(reslen, length(Line));
             inc(Numfound);
             if (Numfound >= Numfind) and (NumFind >= 0) then
                break;
         end;
      end;
     if not AppendCommand then
       if ContentType = 'standard' then
         SS := '==='+#10+'STATS:' + TAB + inttostr(Numfound) + ' records,' + TAB + inttostr(Reslen) + ' characters'
       else
         SS := '==='+#10+'STATS:' + TAB + inttostr(Numfound) + ' records,' + TAB + inttostr(Reslen) + ' characters' + #10
     else
       SS := '';
     inc(ResLen, length(SS));
     if length(S) < ResLen then
       setlength(S, ResLen);
     move((@SS[1])^, (@S[ResLen+1-Length(SS)])^, length(SS));
     SetLength(S, ResLen);
end;

procedure TStripObject.HandleCommand(UnparsedParams : String;
      Var ResponseInfo: String; Var ContentType : String);
Var CType : String;
begin
  ResponseInfo := ProcessQuery(UnparsedParams, false, CType, false);
  ContentType := 'text/plain';
end;

procedure TStripObject.SetRequestParameters(rParams : String);
Var F : TMemIniFile;
begin
   CSGlobal.Enter;
   try
   if IniFile = '' then
     IniFile := 'autoweb.ini';
   F := TMemIniFile.Create(GetHardRootDir1 + IniFile);
   requestparameters := '&' + rParams + '&printdist=1';
   try
      F.WriteString('strip' + inttostr(SectionNum), 'requestparams', rparams);
      F.UpdateFile;
   finally
      F.Free;
   end;
   finally
     CSGlobal.Leave;
   end;
end;

function TStripObject.UpdateFromUrl(Url : String; header_url : string; var Reason : string) : string;
Var Error, S, SH : String;
    FS : TFileStream;
    F : TMemIniFile;
    HFile : String;
begin
   Webobject.CSGlobal.Enter;
   try
   if Url = '' then
     FS := nil;
   MkDirEx(Dir1);
   if header_url <> '' then
     begin
      SH := ReadUrl(header_url);
      result := 'Error';
      if (SH <> Header) and (SH <> '') then
         begin
           F := TMemIniFile.Create(GetHardRootDir1 + IniFile);
           try
              HFile := F.ReadString('strip' + inttostr(SectionNum), 'header', '');
              if HFile = '' then
                 begin
                   HFile := Command + '.header';
                   F.WriteString('strip' + inttostr(SectionNum), 'header', HFile);
                   F.UpdateFile;
                 end;
           finally
              F.Free;
           end;
           WriteStringFile(Dir1+HFile, SH);
           if URL = '' then
              begin
                 Fields := nil;
                 CalcAddress     := -1;
                 Header := SH;
                 AddFieldsFromHeader;
                 Result := 'OK';
              end;
        end;
     end
   else
     SH := header;
   if URL = '' then
     exit;
   if FileExists(Dir1 + 'webupdate.' + FileExt) then
     FS := TFileStream.Create(Dir1 + 'webupdate.' + FileExt, fmOpenWrite)
   else
     FS := TFileStream.Create(Dir1 + 'webupdate.' + FileExt, fmCreate);
   if FS <> nil then
      begin
        FS.Write((@SH[1])^, length(SH));
        WebObject.WebInterf.idhttp1.Get(Url, FS);
        FS.free;
      end;
   FS := nil;
   WebObject.Webinterf.BuildStrip(WebIndex, Error);
   if Error <> '' then
      result := Error
   else
      Result := 'OK';
{   if S <> '' then
      begin
        WriteStringToFile(Header + S, Dir1 + 'webupdate.' + FileExt);
        WebObject.Webinterf.BuildStrip(WebIndex);
        result := true;
        exit;
      end;
   result := false;}
   finally
     Webobject.CSGlobal.Leave;
     if FS <> nil then
       FS.Free;
   end;
end;

function ReplacePlusWithSpace(S : String) : String;
Var p : integer;
begin
   repeat
      p := pos('+', S);
      if P > 0 then
         S[p] := ' ';
   until p = 0;
   result := S;
end;

procedure TStripObject.IndexStreets;
Var Buffer, CType, Street, S, K : String;
    i : integer;
begin
  CType := '';
  Buffer := '';
  for i := 0 to NumStrip - 1 do
  if Strips[i].DataLen <> 0 then
   begin
    setlength(S, Strips[i].DataLen);
    FetchStrip(i, (@(S[1]))^);
    K := FetchField(0, S);
    Street := rstreetobject.ProcessQuery('x1=' + CoorStr(Strips[i].X) + '&y1=' + CoorStr(Strips[i].Y), false, CType, false);
    Street := copy(Street, 1, pos(#$A, Street)-1);
    Buffer := Buffer + K + TAB + CoorStr(Strips[i].X) + TAB + CoorStr(Strips[i].Y) + TAB + Street + #$A;
//    sleep(2);
    if i mod 5000 = 0 then
       begin
          setlength(Buffer, length(Buffer) - 1);
          appendfile(GetHardRootDir1 + 'blockstreets.txt', Buffer);
          Buffer := '';
       end;
   end;
   setlength(Buffer, length(Buffer) - 1);
   appendfile(GetHardRootDir1 + 'blockstreets.txt', Buffer);
end;

function  TStripObject.ProcessQuery(Request : String; AppendEOL : boolean; Var ContentType : String; AppendCommand : boolean; commstr : string = '') : String;
Var  S : String;
  T : int64;
  Op, P, limit, numfind, f, pp : integer;
  X1, Y1, X2, Y2 : double;
  D, dist : double;
  V, VarName, H, key, updateurl, rparams, headerurl : String;
  error, update, prices, ListAll, hdr, print, DateEntered : boolean;
  Exp : TExpression;
  reason : string;
  res_re : boolean;
begin
// CSWork.Enter;
 try
   try
       Result := '';
       S := TIdURI.URLDecode(Request);
       p := 1;
       x1 := 1e90;
       x2 := 1e90;
       y1 := 1e90;
       y2 := 1e90;
       dist := 1e90;
       print := false;
       limit := 100;
       Exp.NumExp := 0;
       Exp.MaxEval := 1000;
       NumFind := -1;
       ListAll := false;
       Hdr := false;
       prices := false;
       DateEntered := false;
       update := false;
       headerurl := '';
       updateurl := '';
       rparams := '';

       if (WebObject.WebInterf.Port.Text = '9797') or (WebObject.WebInterf.Port.Text = '88') or (WebObject.WebInterf.Port.Text = '9090')then
        begin
                //res_re := dist_regexp.Exec (S);
                res_re := dist_Compile(S);
                if not res_re then // r.e. NOT found
                 begin
                        S := S + requestparameters;
                 end;
         end;


       while p < length(S) do
         begin
           ParseDoubleVar(S, VarName, D, V, p);
           if VarName = 'x1' then
             X1 := D
           else if VarName = 'category' then
             VarName := ''
           else if VarName = 'x2' then
             X2 := D
           else if VarName = 'y1' then
             y1 := D
           else if VarName = 'y2' then
             y2 := D
           else if (VarName = 'limit') then
             limit := ValStr(V)
           else if (VarName = 'printdist') then
             print := V = '1'
           else if (VarName = 'appendcommand') then
             appendcommand := V = '1'
           else if (VarName = 'appendeol') then
             appendeol := V = '1'
           else if (VarName = 'd') then
             dist := D
           else if VarName = 'key' then
             key := V
           else if (VarName = 'header') then
             hdr := V = '1'
           else if (VarName = 'update') then
             begin
                update := true;
                updateurl := V;
             end
           else if (VarName = 'set_request_parameters') then
             begin
                SetRequestParameters(V);
                Result := 'Request parameters are: ' + requestparameters;
                exit;
             end
           else if (VarName = 'header_url') then
             begin
                update := true;
                headerurl := V;
             end
           else if (VarName = 'numfind') then
             NumFind := ValStr(V)
           else if (VarName = 'maxeval') then
             Exp.MaxEval := ValStr(V)
           else if (VarName = 'prices') then
             prices := V = '1'
           else
             begin
               if VarName[length(VarName)] = '>' then
                  begin
                     Op := OpGr;
                     setlength(VarName, length(VarName)-1);
                  end
               else if VarName[length(VarName)] = '<' then
                  begin
                     Op := OpLe;
                     setlength(VarName, length(VarName)-1);
                  end
               else if VarName[length(VarName)] = '!' then
                  begin
                     Op := OpNe;
                     setlength(VarName, length(VarName)-1);
                  end
               else if VarName[length(VarName)] = '|' then
                  begin
                     Op := OpOr;
                     setlength(VarName, length(VarName)-1);
                  end
               else
                  Op := OpEq;
               if VarName = 'the_date' then
                 begin
                    DateEntered := true;
                    inc(Exp.NumExp);
                    Exp.Exp[Exp.NumExp-1].Field := TheDateField;
                    Exp.Exp[Exp.NumExp-1].Value1 := ValDate(V);
                    Exp.Exp[Exp.NumExp-1].Oper := Op;
                    Exp.NumEval := 0;
                 end
               else if VarName = 'anyfield' then
               if V <> '' then
                 begin
                    inc(Exp.NumExp);
                    Exp.Exp[Exp.NumExp-1].Field := -1;
                    Exp.Exp[Exp.NumExp-1].dtype := cstring;
                    Exp.Exp[Exp.NumExp-1].Value := ReplacePlusWithSpace(UpStr(V));
                    Exp.Exp[Exp.NumExp-1].Oper := OpEq;
                    Exp.NumEval := 0;
                 end;
               F := FindField(VarName);
               if F >= 0 then
                  begin
                    if V = 'LISTALL' then
                       ListAll := true;
                   if ListAll then
                      begin
                        Result := ProduceList(F);
                        exit;
                      end;
                    inc(Exp.NumExp);
                    Exp.Exp[Exp.NumExp-1].Field := F;
                    Exp.Exp[Exp.NumExp-1].value1 := ValField2(V, error);
                    if not error then
                      begin
                        Exp.Exp[Exp.NumExp-1].dtype := cnumber;
                      end
                    else
                       Exp.Exp[Exp.NumExp-1].dtype := cstring;
                    pp := pos('+', V);
                    while PP <> 0 do
                      begin
                         V[pp] := ' ';
                         pp := pos('+', V);
                      end;
                    Exp.Exp[Exp.NumExp-1].Value := UpStr(V);
                    Exp.Exp[Exp.NumExp-1].Oper := Op;
                    Exp.NumEval := 0;
                  end;
             end;
         end;
       if (not DateEntered) and (self is TStripReal) then
          begin
            inc(Exp.NumExp);
            Exp.Exp[Exp.NumExp-1].Field := TheDateField;
            Exp.Exp[Exp.NumExp-1].Value1 := 0;
            Exp.Exp[Exp.NumExp-1].Oper := OpGr;
            Exp.NumEval := 0;
          end;
       if update then
          begin
             Result := Result + UpdateFromUrl(UpdateUrl, headerurl, reason);
             exit;
          end;
       if (Dist < 1e80) or (NumFind > 0) then
          begin
             x2 := x1;
             y2 := y1;
          end;
       if y2 > 1e89 then
          y2 := y1 + 0.00001;
       if x2 > 1e89 then
          x2 := x1 + 0.00001;
       if Key <> '' then
          begin
           StartTime(T);
           S := FindByKey(Key) + #10 + '===' + #10 + '===='+#10
          end
       else if (x1 > 1e89) or (x2 > 1e89) or (y1 > 1e89) or (y2 > 1e89) then
           S := 'Invalid request format'
       else if limit > 10000 then
           S := 'the limit= option is too high'
       else
         begin
             StartTime(T);
             FindStrips(Exp, X1, Y1, X2, Y2, limit, S, COntentType, print, dist, NumFind,  AppendCommand, Commstr, not prices);
         end;
      if Hdr then
        begin
          if Print then
             H := HeaderDist
          else
             H := Header;
          if not prices then
             begin
             end;
          if (FilUrlPos <> 0) and (ServerCommand = '') then
            begin
              if Interf.HttpServer.DefaultPort <> 80  then
                ServerCommand := TAB + 'http://'+Interf.HttpServer.LocalName +':' +inttostr(Interf.HttpServer.DefaultPort) + '/' + command +'?'
              else
                ServerCommand := TAB + 'http://'+Interf.HttpServer.LocalName +'/' + command +'?';
            end;
          if FilUrlPos <> 0 then
             insert(ServerCommand + Request, H, FilUrlPos);
          if AppendCommand then
            Result := H + S + #10
          else
            Result := H + S + TextTime(T, UseRam)+#10
        end
      else
          if AppendCommand then
            Result := S
          else
            Result := S+ TextTime(T, UseRam)+#10;
   except on E: exception do
      begin
//         Interf.EnableLog;
         Interf.AddLog(Dir1+' Request: ' + Request + ' Exception: ' + E.Message);
         AppendFile(GetHardRootDir1+'Error.LOG', GetTimeText+ ' ' + Dir1+' Request: ' + Request + ' Exception: ' + E.Message);
         Result := 'END. Internal Error. Please report to shaposhn@cs.fiu.edu';
      end;
   end;
 finally
//   CSWork.Leave;
 end;
end;

procedure TStripObject.DeleteDupFiles;
Var i : integer;
    F1, F2, NewName : string;
begin
   SortFiles(false);
   exit; // comment this to disable rebuild of historical data
   for i := 0 to length(Files)-2 do
     begin
        F1 := TheFileName(Files[i]);
        F2 := TheFileName(Files[i+1]);
        if ((F1[1]=F2[1]) and (F1[2]=F2[2])) then
          begin
            NewName := BackupDir1+GetFileName(Files[i]);
            CopyFile(Pchar(Files[i]), Pchar(NewName), true);
            DeleteFile(Pchar(Files[i]));
          end;
    end;
end;

procedure TStripObject.SortFiles(ByDate : boolean = true);
  function Less(X,Y : String) : boolean;
  begin
     if ByDate then
        begin
          delete(X, 1, pos('_', X));
          delete(Y, 1, pos('_', y));
        end;
     result := X < Y;
  end;
  procedure QuickSort(L, R: Integer);
  var
    I, J : Integer;
    T, X : String;
  begin
    I := L;
    J := R;
    X := Files[(L + R) div 2];
    repeat
      while Less(Files[i],  X) do Inc(I);
      while Less(X, Files[J]) do Dec(J);
      if I <= J then
      begin
        T := Files[I];
        Files[I] := Files[J];
        Files[J] := T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J);
    if I < R then QuickSort(I, R);
  end;
begin
   if length(Files) > 0 then
     QuickSort(0, length(Files) - 1);
end;

procedure TStripObject.AddFile1(Name : String);
begin
   if FileExt <> '' then
     if TheFileExt(Upstr(Name)) <> Upstr(FileExt) then
       exit;
   setlength(Files, length(Files) + 1);
   Files[length(Files) - 1] := name;
end;

function TStripObject.dist_Compile(S : String) : boolean;
Var regexp : TRegExpr;
    tt : boolean;

 begin
  try

    regexp := TRegExpr.Create;
    regexp.Expression := '&d=';


    tt := regexp.Exec(S);
    regexp.Free;
    result := tt;
    
    except on E:Exception do begin // exception during r.e. compilation or execution
      if E is ERegExpr then
       if (E as ERegExpr).CompilerErrorPos > 0 then begin

         //interf.SetStatus('WARNING: Regular Expression is invalid');
        end;
      raise Exception.Create (E.Message); // continue exception processing
     end;
   end;
 end;
{
procedure TStripObject.numfind_Compile;
 begin
  try

    numfind_regexp.Expression := '&numfind=';

    except on E:Exception do begin // exception during r.e. compilation or execution
      if E is ERegExpr then
       if (E as ERegExpr).CompilerErrorPos > 0 then begin

         interf.SetStatus('WARNING: Regular Expression is invalid');
        end;
      raise Exception.Create (E.Message); // continue exception processing
     end;
   end;
 end;
}


end.
