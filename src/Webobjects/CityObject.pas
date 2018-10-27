{ Implements the city? command. A. Shaposhnikov 2002

Interface: 
city?x1=number&y1=number

This command returns the nearest city to the given coordinates record in the strip format. The city records are taken in the strip format from the file root\Cities\all.cities, where the root is the root program directory.

The distance to the city is shown in miles measured as a circle distance on earth surface using the formula:

D=69.115*180*arccos(sin(pi*y1/180)*sin(pi*y2/180)+cos(pi*y1/180)*cos(pi*abs(x1-x2)/180)), where x2 and y2 are the longitude and latitude of the city.

Example: 

http://n158.cs.fiu.edu/city?x1=-84&y1=27   

The record format: the fields are the tab delimited: citycode, cityname, statecode or null, countrycode, statename or null, countryname, lattitude, longitude


}

unit cityobject;
interface

uses
  SysUtils, Stree,  IdHTTPServer, Syncobjs, webobject, IdCustomHTTPServer;

type TCityRec = record
       X, Y : double;
       DataStart : integer;
       Datalen : word;
end;

type TNameHashRec = record
        Start : integer;
        len : integer;
        Next : integer;
        ObjID : integer;
end;

TCityObject = class(TWebObject)
  public
// persistent data
    MinY, MinX, MaxY, MaxX : double;
    NumCities : integer;
    Cities : array of TCityRec; // 0..NumVertexes - 1
    Names : array of TNameHashRec;
    NameHash : array[0..2 shl 12 - 1] of integer;

    CityDataSize : integer;
    CityData : string;

    CitiesF : file;
    Stree : TStree;
    CSWork : TCriticalSection;

    destructor Free; override;
    procedure Init(Oldobject: TWebObject = nil); override;
    procedure HandleCommand(UnparsedParams : String;
                            Var ResponseInfo: String; Var ContentType : String); override;

    procedure AddFile(Name : String);
    procedure BuildStree;
    procedure ObjCoor(ObjID : integer; Var X, Y : single);
    procedure LoadAllFiles;
    procedure LoadBase;
    procedure SaveBase;
    procedure Calibrate;
    procedure AddCity(Var Lat, Lon : String; Line : String);
    procedure FetchCity(idx : integer; Var V);
    function htmlformat(Var S : String; Dist : integer) : String;
    function GetCityName(Var S : String) : String;
    function GetCountryName(Var S : String) : String;
    procedure FindCity(X1, Y1 : double; Var S : String; Var MinDist : double); overload;
    function ComputeHash(Var S : String) : integer;
    function FindCity(CityName : String; Var H, P : integer; Var CN : String) : integer; overload;
    function FindCityCoor(Var CityName, State : String; Var X, Y : double) : boolean;
    function GetCityRec(CityID : integer) : String;
    function GetCityCode(X1, Y1 : double) : String;
    procedure CreateHash;
    function  ProcessQuery(Request : String; AppendEOL : boolean; Var ContentType : String; AppendCommand : boolean; commstr : string = '') : String; override;
    function MatchCity(CID : integer; Var CityName, State : String) : boolean;
    function FindAll(X1, Y1 : double; Dist : double) : string;
    { Public declarations }
  end;

const P180 = Pi/180;
const MetersPerMile = 1609.344;
const MP180 = 111.23*180000/Pi;
const MIP180 = 111.23*180000/Pi/MetersPerMile;
function EarthDistMet(X1, Y1, X2, Y2 : double) : double;
function EarthDistMil(X1, Y1, X2, Y2 : double) : double;
function calcheading(X1, Y1, X2, Y2 : double) : double;
const MileY = 1/69.172;
function MileX(Y : double) : double;

Var ICityObject : TCityObject; 

implementation
uses FileIO, parser, math;

procedure TCityObject.Init;
begin
   NumCities := 0;
   CityDataSize := 0;
   CityData := '';
   CSWork := TCriticalSection.Create;
   if FileExists(Dir1 + 'Cities.tab') then
     LoadBase
   else
     begin
       LoadAllFiles;
       Calibrate;
       SaveBase;
     end;
end;

destructor TCityObject.Free;
begin
   CSWork.Free;
   Stree.Free;
end;

procedure TCityObject.LoadAllFiles;
Var SR : TSearchRec;
begin
   Interf.SetStatus('Building City database ...');
   if FindFirst(Dir1 + '*.cities', faAnyFile, SR) <> 0 then
      exit;
   try
   while true do
     begin
       AddFile(Dir1 + SR.Name);
       if FindNext(SR) <> 0 then
          break;
     end;
   finally
     findClose(SR);
   end;
end;

procedure TCityObject.Calibrate;
Var i : integer;
begin
   Interf.SetStatus('Calibrating Cities...');
   MinY := 1e10;
   MinX := 1e10;
   MaxY := -1e10;
   MaxX := -1e10;
   for i := 0 to NumCities - 1 do
     with Cities[i] do
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

procedure TCityObject.ObjCoor(ObjID : integer; Var X, Y : single);
begin
  X := Cities[ObjId].X;
  Y := Cities[ObjId].Y;
end;

procedure TCityObject.BuildStree;
Var i : integer;
begin
   Interf.SetStatus('Building City S-tree ...');
   Stree := TStree.Create(MinX-2, MinY-2, MaxX+2, MaxY+2, 8, 4, NumCities);
   for i := 0 to NumCities-1 do
      Stree.AddObject(i, Cities[i].X, Cities[i].Y, ObjCoor);
   TotalObjects := NumCities;
   TotalVertixes := NumCities;
end;

function TCityObject.ComputeHash(Var S : String) : integer;
Var H, M, i : integer;
begin
   H := 0;
   if length(S) > 3 then
     M := 3
   else
     M := length(S);
   for i := M downto 1 do
     inc(H, ord(S[i]) shl ((3-i) * 4));
   Result := H mod length(NameHash);
end;

function TCityObject.FindCity(CityName : String; Var H, P : integer; Var CN : String) : integer;
Var HFound, HNextFound, i, Matched, BestMatched, Best : integer;
    found : boolean;
begin
   Best := -1;
   BestMatched := -1;
   Matched := 1;
   CityName := UpperCase(CityName);
   HFound := -1;
   HNextFound := -1;
   while (HNextFound < 0) do
     begin
       if H < 0 then
         begin
           CN := scanstr(CityName, P);
           if CN = '' then
             break;
           H := ComputeHash(CN);
           H := NameHash[H];
         end;
       while (H >= 0) do
          begin
             found := true;
             for i := 0 to length(CN)-1 do
               if (i > Names[H].Len) or (UpCase(CityData[Names[H].Start + i]) <> CN[i+1]) then
                 begin
                   Matched := i-1;
                   found := false;
                   break;
                 end;
             if found then
                begin
                  if HFound > 0 then
                    begin
                      HNextFound := H;
                      break;
                    end
                  else
                    begin
                      HFound := H;
                      BestMatched := length(CN);
                      Best := Names[H].ObjID;
                    end;
//                  exit;
                end;
             if Matched > BestMatched then
               begin
                 Best := Names[H].ObjID;
                 BestMatched := Matched;
               end;
             H := Names[H].Next;
          end;
     end;
    H := HNextFound;
    if (H < 0) and (p >= length(Cityname)) then
      P := -1;
    Result := Best;
end;

function TCityObject.MatchCity(CID : integer; Var CityName, State : String) : boolean;
Var S, ST : String;
    P : integer;
begin
   P := Cities[CID].DataStart;
   ExtractField(CityData, S, P);
   ExtractField(CityData, S, P);
   ExtractField(CityData, St, P);
   UpString(S);
   UpString(St);
   Result := (CityName = S) and (State = ST);
end;

function TCityObject.FindCityCoor(Var CityName, State : String; Var X, Y : double) : boolean;
Var SS : String;
    H, C, PP : integer;
begin
   PP := 1;
   SS := scanstr1(CityName, pp);
   SS := UpperCase(SS);
   H := ComputeHash(SS);
   C := NameHash[H];
   while C >= 0 do
      begin
         if MatchCity(Names[C].ObjID, CityName, State) then
            begin
               X := Cities[Names[C].ObjID].X;
               Y := Cities[Names[C].ObjID].Y;
               Result := true;
               exit;
            end;
         C := Names[C].Next;
      end;
   Result := false;
end;

procedure TCityObject.CreateHash;
Var i, C, St, pp, P, H : integer;
    S : String;
    SS : String;
begin
    setlength(Names, NumCities*4);
    for i := 0 to length(NameHash) - 1 do
      NameHash[i] := -1;
    C := 0;
    for i := 0 to NumCities - 1 do
       begin
        P := Cities[i].DataStart;
        Names[C].Start := P;
        ExtractField(CityData, S, P);
        SS := UpperCase(S);
{        if SS = 'LED' then
          SS := 'LED';}
        H := ComputeHash(SS);
        Names[C].len := length(S);
        Names[C].ObjID := i;
        Names[C].Next := NameHash[H];
        NameHash[H] := C;
        inc(C);

        St := P;
        ExtractField(CityData, S, P);
        pp := 1;
        while pp < length(S) do
           begin
              while (pp < length(S)) and ((S[pp] = ' ') or (S[pp] = TAB))do
                inc(pp);
              Names[C].Start := St + pp - 1;
              SS := scanstr1(S, pp);
              SS := UpperCase(SS);
              H := ComputeHash(SS);
              Names[C].len := length(SS);
              Names[C].ObjID := i;
              Names[C].Next := NameHash[H];
              NameHash[H] := C;
              inc(C);
           end;
       end;
end;

procedure TCityObject.LoadBase;
Var S, nr : integer;
    F : File;
begin
   Interf.SetStatus('Loading City database ...');
{   if MemAvail > 300000000 then
     begin}
       Interf.SetStatus('Using RAM memory for Cities');
       ReadStringFile(Dir1+'Cities.tab', CityData);
{     end
   else
     begin
       Interf.SetStatus('NOT ENOUGH RAM. Using DISK storage for Cities');
       CityData := '';
       AssignFile(CitiesF, Dir1+'Cities.tab');
       reset(CitiesF, 1);
     end;}
   assignfile(F, Dir1+'Cities.PAR');
   reset(F, 1);
   S := FileSize(F);
   NumCities := S div sizeof(TCityRec);
   setlength(Cities, NumCities);
   blockread(F, (@Cities[0])^, NumCities * sizeof(TCityRec), nr);
   closefile(F);
   Calibrate;
   CreateHash;
end;

procedure TCityObject.SaveBase;
Var nw : integer;
    F : File;
begin
   If Numcities = 0 then
     begin
       Interf.SetStatus('all.cities file not found in the cities subdirectory ...');
       exit;
     end;
   Interf.SetStatus('Saving City database ...');
   assignfile(F, Dir1+'Cities.tab');
   rewrite(F, 1);
   blockwrite(F, (@CityData[1])^, CityDataSize, nw);
   closefile(F);
   assignfile(F, Dir1+'Cities.PAR');
   rewrite(F, 1);
   blockwrite(F, (@Cities[0])^, NumCities * sizeof(TCityRec), nw);
   closefile(F);
   CreateHash;
end;

procedure TCityObject.AddCity(Var Lat, Lon: String; Line : String);
Var Start, HS : integer;
begin
  HS := CityDataSize + length(Line);
  if HS > length(CityData) then
    setlength(CityData, 300000000);
  if HS > length(CityData) then
    raise exception.create('TCityObject.AddCity Out of memory');
  Start := CityDataSize+1;
  move((@Line[1])^, (@CityData[Start])^, length(line));
  CityDataSize := HS;
  if NumCities >= length(Cities) then
    setlength(Cities, round(NumCities * 1.2) + 100);
  Cities[NumCities].X := ReadDouble(Lon);
  Cities[NumCities].Y := ReadDouble(Lat);
  Cities[NumCities].DataStart := Start;
  Cities[NumCities].DataLen := length(Line);
  inc(NumCities);
end;

const _loaded : integer = 0;
      _LoadedSize : integer = 0;
procedure TCityObject.AddFile(Name : String);
Var S  : String;
    p, Start : integer;
    Lon, Lat: String;
begin
   inc(_loaded);
   ReadStringFile(Name, S);
   inc(_Loadedsize, length(S));
//   P := pos(#10+'=='+#10, S);
//   MoveToEol(S, P);
//   MoveToEol(S, P);
   P := 1;
   while (P < (length(S)-3)) do
     begin
       if (S[P] = '=') and (S[P+1] = '=') and (S[P+2] = '=') then
          break;
       Start := P;
       SkipFields(S, 6, P);
       ExtractField(S, Lat, P);
       ExtractField(S, Lon, P);
//       SkipFields(S, 8, P);
//       ExtractField(S, Lat1, P);
//       ExtractField(S, Lon1, P);
       MoveToEol1(S, P);
//       if (Lat1 <> '') and (Lon1 <> '') then
//          AddCity(Lat, Lon, Copy(S, Start, P - Start - 2))
//       else
         if (Lat <> '') and (Lon <> '') then
            AddCity(Lat, Lon, Copy(S, Start, P - Start));
       Nextline(S, P);     
     end;
end;

procedure TCityObject.FetchCity(idx : integer; Var V);
Var nr : integer;
begin
    if CityData <> '' then
       move((@CityData[Cities[idx].DataStart])^, V, Cities[idx].DataLen)
    else
      begin
        seek(CitiesF, Cities[idx].DataStart - 1);
        blockread(CitiesF, V, Cities[idx].DataLen, nr);
      end;
end;

function TCityObject.GetCityName(Var S : String) : String;
Var P : integer;
    Res, countryname, statecode : String;
begin
  P := 1;
  SkipFields(S, 1, P);
  ExtractField(S, Res, P);
  ExtractField(S, statecode, P);
  SkipFields(S, 2, P);
  ExtractField(S, countryname, P);
  if statecode <> '' then
    Result := Res + ', ' + statecode + ', ' + countryname
  else
    Result := Res + ', ' + countryname
end;


function TCityObject.GetCountryName(Var S : String) : String;
Var P : integer;
    Res : String;
begin
  P := 1;
  SkipFields(S, 5, P);
  ExtractField(S, Res, P);
  Result := Res;
end;

function TCityObject.htmlformat(Var S : String; Dist : integer) : String;
Var P : integer;
        cityname,
        statecode,
        countrycode,
        statename,
        countryname,
        lattitude,
        longitude : String;
begin
  P := 1;
  ExtractField(S, cityname, P);
  ExtractField(S, statecode, P);
  ExtractField(S, countrycode, P);
  ExtractField(S, statename, P);
  ExtractField(S, countryname, P);
  ExtractField(S, lattitude, P);
  ExtractField(S, longitude, P);;
  if statecode <> '' then
    statecode := ', ' + statecode;
  Result :=         '<p><b>' + inttostr(Dist) + ' miles to the center of '+ Cityname+ statecode +', ' + CountryName+'</b></p>';

{  while p < length(S) do
    begin
        ExtractField(S, citycode, P);
        ExtractField(S, cityname, P);
        ExtractField(S, statecode, P);
        ExtractField(S, countrycode, P);
        ExtractField(S, statename, P);
        ExtractField(S, countryname, P);
        ExtractField(S, lattitude, P);
        ExtractField(S, longitude, P);;
        movetoeol(S, P);
        if statecode = '' then
          statecode := '&nbsp;';
        if Statename = '' then
          Statename := '&nbsp;';
    end;}
end;


{Function atan2(y : extended; x : extended): Extended;
Assembler;
asm
  fld [y]
  fld [x]
  fpatan
end;}


{function atan2 (y, x : real) : real;
begin
  if x > 0       then  atan2 := arctan (y/x)
  else if x < 0  then  atan2 := arctan (y/x) + pi
  else  if y >= 0 then
       atan2 := pi/2
  else
       atan2 := -pi/2;
end;}

function EarthDistMet(X1, Y1, X2, Y2 : double) : double;
Var Arg : double;
begin
   if (abs(x1-x2) > 180) or (abs(y1-y2) > 180) then
      begin
        Result := MP180 * Pi;
        exit;
      end;
   Arg := sin(Y1*P180)*sin(Y2*P180)+cos(Y1*P180)*cos(Y2*P180)*cos(abs(X1-X2)*P180);
   Result := MP180*arccos(Arg);
end;

function EarthDistMil(X1, Y1, X2, Y2 : double) : double;
Var Arg : double;
begin
   if (abs(x1-x2) > 180) or (abs(y1-y2) > 180) then
      begin
        Result := MIP180 * Pi;
        exit;
      end;
   Arg := sin(Y1*P180)*sin(Y2*P180)+cos(Y1*P180)*cos(Y2*P180)*cos(abs(X1-X2)*P180);
   Result := MIP180*arccos(Arg);
end;


function modulus(x, y : double) : double;
begin
   result := x-y*trunc(x/y);
end;

function calcheading(X1, Y1, X2, Y2 : double) : double;
begin
  X1 := P180 * X1;
  X2 := P180 * X2;
  Y1 := P180 *  Y1;
  Y2 := P180 * Y2;
  result :=modulus(arctan2(sin(x1-x2)*cos(y2),
           cos(y1)*sin(y2)-sin(y1)*cos(y2)*cos(x1-x2)), 2*pi)
end;

function MileX(Y : double) : double;
begin
   if cos(Y*P180) = 0 then
     result := 1/69.172
   else
     result := abs(1/(69.172*cos(Y*P180)));
end;

function TCityObject.GetCityCode(X1, Y1 : double) : String;
Var CityCode : String;
    S : String;
    p : integer;
    MinDist : Double;
begin
   FindCity(X1, Y1, S, MinDist);
   P := 1;
   ExtractField(S, citycode, P);
   Result := CityCode;
end;

procedure TCityObject.FindCity(X1, Y1 : double; Var S : String; Var MinDist : double);
Var D, DX, DY, D1, D2 : double;
    SI : TStreeIterator;
    MinObj, Obj : dword;
begin
   DX := MileX(Y1) * 10;
   DY := MileY * 10;
   MinDist := 1e20;
   MinObj := inull;
   while true do
     begin
       Stree.FindObjects(X1 - DX, X1 + DX, Y1 - DY, Y1 + DY, ObjCoor, Si);
       Obj := Stree.FindNextObject(SI);
       if Obj <> iNull then
         begin
           while true do
             begin
                D := EarthDistMil(X1,Y1, Cities[Obj].X, Cities[Obj].Y); //Sqr(X1 - Cities[Obj].X) + Sqr(Y1 - Cities[Obj].Y);
                if D < MinDist then
                   begin
                      MinObj := Obj;
                      MinDist := D;
                   end;
                Obj := Stree.FindNextObject(SI);
                if Obj = iNull then
                   break;
             end;
         end;
       D1 := EarthDistMil(X1,Y1, X1 + DX, Y1);
       D2 := EarthDistMil(X1,Y1,X1,Y1+DY);
       if D2 < D1 then
         D1 := D2;
       if MinDist <= D1 then
          break;
       DX := 2*DX;
       DY := 2*DY;
     end;
   if MinObj = inull then
      exit;
   setlength(S, Cities[MinObj].DataLen);
   fetchCity(MinObj, (@S[1])^);
end;

function TCityObject.FindAll(X1, Y1 : double; Dist : double) : string;
Var D, DX, DY, D1, D2 : double;
    SI : TStreeIterator;
    Obj : dword;
    S : String;
begin
   DX := MileX(Y1) * Dist;
   DY := MileY * Dist;
   result := '';
   Stree.FindObjects(X1 - DX, X1 + DX, Y1 - DY, Y1 + DY, ObjCoor, Si);
   while true do
     begin
       Obj := Stree.FindNextObject(SI);
       if Obj = iNull then
          exit;
       setlength(S, Cities[Obj].DataLen);
       fetchCity(Obj, (@S[1])^);
{       if result = '' then
         result := S + TAB + 'city'
       else}
         result := result + S + TAB + 'city' + #$A;
     end;
end;


function TCityObject.GetCityRec(CityID : integer) : String;
begin
   setlength(Result, Cities[CityID].DataLen + 1);
   fetchCity(CityID, (@Result[1])^);
end;

function  TCityObject.ProcessQuery(Request : String; AppendEOL : boolean; Var ContentType : String; AppendCommand : boolean; commstr : string = '') : String;
Var  S : String;
  T : int64;
  P : integer;
  X1, Y1, D, MinDist, dist : double;
  V, VarName : String;
  all : boolean;
begin
   try
       S := Request;
       p := 1;
       x1 := 1e90;
       y1 := 1e90;
       while p < length(S) do
         begin
           ParseDoubleVar(S, VarName, D, V, p);
           if VarName = 'x1' then
             X1 := D
           else if VarName = 'all' then
             all := V = '1'
           else if VarName = 'd' then
             dist := D
{           else if VarName = 'x2' then
             X2 := D}
           else if VarName = 'y1' then
             y1 := D
{           else if VarName = 'y2' then
             y2 := D}
{           else if (VarName = 'limit') then
             limit := ValStr(V);}
         end;
       StartTime(T);
       if (x1 > 1e89) or (y1 > 1e89) then
           S := 'Invalid request format'
       else
         begin
           CSWork.Enter;
           try
             if all then
               begin
                 Result := FindAll(X1, Y1,Dist);
               end
             else
               begin
                 FindCity(X1, Y1, S, MinDist);
                 Result := S+ '===' + #10 +format(' Distance=%.2f', [MinDist]) + #10;
               end;
           finally
             CSWork.Leave;
           end;
         end;
   except on E: exception do
      begin
//         Interf.EnableLog;
         Interf.AddLog('Request: ' + Request + ' Exception: ' + E.Message);
         AppendFile(GetHardRootDir1+'Error.LOG', GetTimeText+'City Request: ' + Request + ' Exception: ' + E.Message);
         Result := 'END. Internal Error. Please report to shaposhn@cs.fiu.edu';
      end;
   end;
end;

procedure TCityObject.HandleCommand(
      UnparsedParams : String;
      Var ResponseInfo: String; Var ContentType : String);
Var CType : String;
begin
   ResponseInfo := ProcessQuery(Unparsedparams, false, CType, false) + 'END.';
   ContentType := 'text/plain';
end;

end.
