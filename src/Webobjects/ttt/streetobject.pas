{*** Tiger street search implementation by A. Shaposhnikov 2002 ***}

{  

Implements the street? web interface:

street?street=<street_address>&zip=<zip>&city=<city>&state=<state>

Example:

http://n158.cs.fiu.edu/street?street=100 lincoln rd&city=Miami fl
Result:
X=-80.129217	Y=25.790115
Level=1	Exact match

Possible result codes are:
1 'Exact match'
2 'Approx match' - the program could not find the exact range, but found the nearest syntactic match or range
3 'Zip center' - the returned coordinate is the zip code center
4 'City Center' - the returned coordinate is the city center
5 'Not Found' - nothing was found


The state can optionally be appended to the city field. 
If the street= field is missing or contains a PO Box,
the program will search for the zip code center or city center.


}

unit streetobject;


interface
uses webobject, IdCustomHTTPServer;

const A_Exact = 1;
const A_Approx = 2;
const A_ZipCenter = 3;
const A_CityCenter = 4;
const A_NotFound = 5;
const Levels : array[1..5] of string = ('Exact match', 'Approx match', 'Zip center', 'City Center', 'Not Found');

{Record type 1}
const
RT1TLID=6;
RT1TLIDL = 10;
RT1FEDIRP=18;  //Feature Direction, Prefix
RT1FEDIRPL=2;
RT1FENAME=20; // Feature Name
RT1FENAMEL=30;
RT1FETYPE=50; // 4 Feature Type
RT1FETYPEL=4;
RT1FEDIRS= 54; //2 Feature Direction, Suffix
RT1FEDIRSL=2;
RT1CFCC=56; // Census Feature Class Code
RT1CFCCL=3;
RT1FRADDL=59; //69 11 Start Address, Left
AddressLength=11;
RT1TOADDL=70; // End Address, Left
RT1FRADDR=81; // Start Address, Right
RT1TOADDR=92;//  End Address, Right
RT1ZIPL=107; //Yes L N 107 111 5 ZIP Code®, Left
RT1ZIPR=112; // Yes L N 112 116 5 ZIP Code®, Right
RT1PLACEL=161; // 165 5 FIPS 55 Code (Place/CDP), 2000 Left
RT1PLACER=166;// 170 5 FIPS 55 Code (Place/CDP), 2000 Right
RT1TRACTL=171;// 176 6 Census Tract Code, 2000 Left
RT1TRACTR=177;// 182 6 Census Tract Code, 2000 Right
RT1BLOCKL=183;// 186 4 Census Block Number, 2000 Left
RT1BLOCKR=187;// 190 4 Census Block Number, 2000 Right
RT1FRLONG=191;// 200 10 Start Longitude
RT1FRLAT=201;// 209 9 Start Latitude
RT1TOLONG=210;// 219 10 End Longitude
RT1TOLAT=220;// 228 9 End Latitude
LONGL=10;
LATL=9;

RT5FILE=2;
RT5FILEL=5;
RT5FEAT=7;// No R N 7 14 8 Line Name Identification Number
RT5FEATL = 8;
RT5FEDIRP=15;// Yes L A 15 16 2 Feature Direction, Prefix
RT5FEDIRPL=2;
RT5FENAME=17;// Yes L A 17 46 30 Feature Name
RT5FENAMEL = 30;
RT5FETYPE=47;// Yes L A 47 50 4 Feature Type
RT5FETYPEL = 4;
RT5FEDIRS=51;// Yes L A 51 52 2 Feature Direction, Suffix
RT5FEDIRSL=2;

RT2TLID=6;// 15 10 TIGER/Line® ID, Permanent Record Number
RT2TLIDL=10;
RT2RTSQ=16;// No R N 16 18 3 Record Sequence Number
RT2RTSQL=3;
RT2LONG1=19;// No R N 19 28 10 Point 1, Longitude
RT2LAT1=29;// No R N 29 37 9 Point 1, Latitude
RT2LONG2=38;// Yes R N 38 47 10 Point 2, Longitude
RT2LAT2=48;// Yes R N 48 56 9 Point 2, Latitude

RT4TLID=6;// No R N 6 15 10 TIGER/Line® ID, Permanent Record Number
RT4RTSQ=16;// No R N 16 18 3 Record Sequence Number
RT4FEAT1=19;// No R N 19 26 8 Line Additional Name Identification
RT4FEATL=8;
{FEAT2 Yes R N 27 34 8 Line Additional Name Identification
Number, Second
FEAT3 Yes R N 35 42 8 Line Additional Name Identification
Number, Third
FEAT4 Yes R N 43 50 8 Line Additional Name Identification
Number, Fourth
FEAT5 Yes R N 51 58 8 Line Additional Name Identification
Number, Fifth}


RT6TLID=6;// No R N 6 15 10 TIGER/Line® ID, Permanent Record Number
RT6RTSQ=16;// No R N 16 18 3 Record Sequence Number
RT6FRADDL=19;// Yes R A 19 29 11 Start Address, Left
RT6TOADDL=30;// Yes R A 30 40 11 End Address, Left
RT6FRADDR=41;// Yes R A 41 51 11 Start Address, Right
RT6TOADDR=52;// Yes R A 52 62 11 End Address, Right
RT6ZIPL=67;// Yes L N 67 71 5 ZIP Code®, Left
RT6ZIPR=72;// Yes L N 72 76 5 ZIP Code®, Right
const CoorDiv = 1000000;


type TDirEntry = record
        ID : byte;
        Count : integer;
        Name : String;
        MainName : String;
        Similar : array of integer;
        HashNext : integer;
end;

type TDir = class
public
     DirName : String;
     entries : array of TDirEntry;
     Hash : array[0..255] of integer;
     Count : integer;
     constructor Create(Dir : String);
     function  find(Name : String) : integer;
     procedure Add(Name : String; ID : integer = -1);
     procedure Save;
     procedure Sort;
     procedure Load;
     procedure AddAbbrev(Name : String; Delimiter : char);
     function  HashFun(Var S : String) : integer;
     function IsSimilar(i1, i2 : integer) : boolean;
     function Getname(ID : integer) : String;
end;

var DirPrefixes : TDir;
var DirSuffixes : TDir;
Var FeatureTypes : TDir;
Var DirStates : TDir;
Var CFCCS : TDir;
const NullPrefix : integer = 0;
const NullSuffix : integer = 0;
const NullType : integer = 0;


type TStreetName = record
             CFCC : byte;
             CombinedDir : byte; // 1 free bit - last name record or not
             Ftype : byte; // 2 free bits - Has range prefix, has avenue number
             NameLen : byte;
             NameStart : byte;
             // next name record
             //NumVert
             //Lat1
             //Lon1
             //Lat2 - 3 byte
             //Lon2 - 3 byte
             //Lat3
             //Lon3
             //...
             //formatflag - byte
             //From - 2
             //To - 1
             //formatflag - byte
             //RightFrom - 2
             //RightTo  - 1
             //format flag
             //lat4
             //lon4

end;

const
       rangelength = 1+2; // 00 - word, 01 - byte, 10 - dword, 11 - word + byte offset
       rangelast = 4;
       rangeleft = 8;


{type TStreetName = record
           CombinedDir : byte;
           Name : pchar;
           Ftype : byte;
           StreetID : integer;
end;}

type TCommonRec = record
             CFCC : byte;
             CombinedDir : byte;
             FType : byte;
end;

type TAddress = record
          CommonRec : TCommonRec;
          ZIp : integer;
          Name : String;
end;

type pinteger = ^integer;
type TIntHash = class
       Hash : array[0..1024*1024-1] of integer;
       HashTail : array[0..1024*1024-1] of pinteger;
       procedure Clear;
       procedure Append(Var HashNext : integer; HashVal : integer; Index : integer);
       function Find(HashVal : integer) : integer;
end;

type TRT1Store = record
        TLID : integer;
        CombinedDir : byte;
        Name : String;
        FType : byte;
        CFCC : byte;
        StreetRecL : integer;
        StreetRecR : integer;
        AlphaPrefixL : String;
        AlphaPrefixR : String;
        AvenueFromR, AvenueToR : integer;
        AvenueFromL, AvenueToL : integer;
        FromL, TOL : integer;
        FromR, TOR : integer;
        ZipL, ZipR : integer;
        FrLat, FrLong : integer;
        ToLat, ToLong : integer;
        HashNextTlid : integer;
        HashL : integer;
        HashR : integer;
        LeftChain : integer;
        RightChain : integer;
        NavtechPrimaryRec : integer;
end;

type TRT6Store = record
        TLID : integer;
        AlphaPrefixL : String;
        AlphaPrefixR : String;
        AvenueFromR, AvenueToR : integer;
        AvenueFromL, AvenueToL : integer;
        FromL, TOL : integer;
        FromR, TOR : integer;
        ZipL : integer;
        ZipR : integer;
        HashNextTlid : integer;
end;

type TRT2Store = record
        TLid : integer;
        RTSQ : integer;
        Long : integer;
        Lat : integer;
        HashNextTlid : integer;
end;

type TRT4Store = record
        TLID : integer;
        Feat : integer;
        RTSQ : integer;
        HashNextTLid : integer;
end;

type TRT5Store = record
        Feat : integer;
        CombinedDir : byte;
        Name : String;
        FType : byte;
        HashNextFeat : integer;
end;

//1. FeatureID+Zip
//2. FeatureID+MainCity+state
//3. Subcity+state --> MainCity+state

type TProcedure = procedure(FileName : String) of object;

const CoorHashSize = 65536;

type TIntVertex = record
       Lat : integer;
       Lon : integer;
end;

type TVertexes = record
       NumVert : integer;
       Vert : Array[0..65536] of TIntVertex;
end;

type PHashEntry = ^THashEntry;
     THashEntry = array of integer;
const MinZip = 1001;
      MaxZip = 99999;
      ZipHashMax = 32;

//const CityHashMax = 32;

type TCityRec = record
        Name : String;
        State : integer;
        NumZips : integer;
        Zip : integer;
        CX : double;
        CY : double;
        Hash : array[0..ZipHashMax-1] of THashEntry;
        HashCityNameNext : integer;
end;

const CityNameHashMax = 100*1024;

type TDebug = record
     debug : boolean;
     S : String;
end;

procedure Addtrace(Var Debug : TDebug; T : String);

type TStreetObject = class(TWebObject)
  public
//    Segments : array of TSegment;
//    NumSegments : integer;
//    Features : array of TFeatureID;
//    NumFeatures : integer;

    Cities : array of TCityRec;
    SaveStates : boolean;
    HashCityName : array[0..CityNameHashMax-1] of integer;
    NumCities : integer;
    ZipCity : array[MinZip..MaxZip] of THashEntry;
    Hash : array[MinZip..MaxZip, 0..ZipHashMax-1] of THashEntry;
    RT1 : array of TRT1Store;
    NumRt1 : integer;
    RT1Hash : TIntHash;
    RT2 : array of TRT2Store;
    NumRt2 : integer;
    RT2Hash : TIntHash;
    RT4 : array of TRT4Store;
    NumRt4 : integer;
    RT4Hash : TIntHash;
    RT5 : array of TRT5Store;
    NumRt5 : integer;
    RT5Hash : TIntHash;
    RT6 : array of TRT6Store;
    NumRt6 : integer;
    RT6Hash : TIntHash;
//    ZipHash : array[0..ZipHashLength-1] of integer;
    CoorHash : array[0..CoorHashSize-1] of integer;
    DataArr : array of byte;
    DataIndex, TotalSize : integer;
    CFCCSet : set of byte;
    AllProcessed : boolean;

    destructor Free; override;
    procedure Init; override;
    procedure HandleCommand(ARequestInfo: TIdHTTPRequestInfo;
                            AResponseInfo: TIdHTTPResponseInfo); override;
    function  ProcessQuery(Request : String; AppendEOL : boolean; Var ContentType : String; AppendCommand : boolean) : String; override;
    procedure scandirs(D : String; Mask : String; P :TProcedure; processdirs : boolean);
    procedure FillPrefixes(FileName : String);
    procedure Read(FileName : String);
    procedure PopulateDirs;
    procedure ReadRt1(FileName : String);
    procedure ReadRt2(FileName : String);
    procedure ReadRt4(FileName : String);
    procedure ReadRt5(FileName : String);
    procedure ReadRT6(FileName : String);
    function  HashNameZip(Name : pchar; NameL : byte; CombinedDir : byte; FType : byte; ZipL : integer) : integer;
//    procedure ScanRT1(FileName : String);
    procedure WriteAddress(R : integer; Left : boolean);
//    function  SameAltAddress(A, f : integer) : boolean;
    function  SameAltAddress(i, j : integer) : boolean;
    function  MoveNext(Var R : integer; Var Left : boolean) : boolean;
    procedure WriteWord(W : integer);
    procedure Writebyte(W : integer);
    procedure Writeshortint(W : integer);
    function  readshortint(Var P : integer) : integer;
    procedure WriteString(S : String);
    procedure WriteVertexes(R : integer; NotLast: boolean; Var FLat, FLon : integer; Left : boolean);
    procedure WriteInt3(W : integer);
    function  ReadInt3(Var P : integer) : integer;
    procedure WriteInteger(W : integer);
    function ReadInteger(Var P : integer) : integer;
    procedure ReadStruct(Var S; Size : integer; Var P : integer);
    procedure ReadString(Var S : String; Var P : integer);
    function  ReadByte(Var P : integer) : byte;
    function  ReadWord(Var P : integer) : word;
    function  ReadNextAddress(Var A : TAddress; Var Next : TAddress; Var P : integer) : boolean;
    procedure SkipVertixes(Var P : integer; Var FLat, FLon : integer; Var PrevLat, PrevLon : integer);
    function  WriteRange(FromL, ToL, FromR, ToR : integer;
          AlphaPrefixL : String; AlphaPrefixR : String;
          AvenueFromR, AvenueToR : integer;
          AvenueFromL, AvenueToL : integer; Zip, LZip, RZip : Integer) : integer;
    function ReadRange(Var P, FromL, ToL, FromR, ToR : integer;
        Var AlphaPrefixL : String; Var AlphaPrefixR : String;
        Var AvenueFromR, AvenueToR : integer;
        Var AvenueFromL, AvenueToL : integer; Var LZip, RZip : Integer) : byte;
    procedure WriteRanges(R : integer; NotLast : boolean; Left : boolean; Z : integer);
    procedure ProcessOneCounty(FileName : String);
    procedure JoinCounty(FileName : String);
    procedure CalcCounty(FileName : String);
    function  ExtendChain(Var R : integer; Var Left : boolean) : boolean;
    function  MatchVertex(Lat, Lon : integer; SR : integer ;Var L: boolean) : boolean;
    function  SameAddress(R, SR : integer) : boolean;
    procedure ExtendData(L : integer);
    procedure ReadAddress(Var A : TAddress; Var P : integer);
    procedure ReadVertixes(Var V : TVertexes; Var P : integer; Var FLat, FLon : integer; Var PrevLat, PrevLon : integer);
    procedure BuildIndex;
    procedure MakeStreet(Var A : TAddress; Var S : String);
    procedure AddToIndex(Var A : TAddress; P : integer);
    function Find(Var A : TAddress) : PHashEntry;
    function findbycity(Var A : TAddress; C : integer) : PHashEntry;
    function Hashfun(Var A : TAddress) : integer;
    procedure ParseStreet(Var S : String; Var A : TAddress; Var AlphaPrefix : String; Var Avenue, House : integer);
    function  FindHouse(Var SA, FoundA : TAddress; Var AlphaPrefix : String; Avenue, House : integer;
                      E : PHashEntry; Var X, Y : double; Relaxed : integer; Var Approx : boolean; Var Debug : TDebug) : boolean;
    procedure FindPoint(Var V : TVertexes; left  : boolean; R : double; Var X, Y : double);
    function  MatchStreet(Var A, B : TAddress; Relaxed : integer) : boolean;
    function  FindHouseByZip(street, zip, City, State : String; Var X, Y : double; Var Approx : integer; Var Debug : TDebug; Var Error : String) : boolean;
    procedure ReadAllCities;
    function  FindCity(Var SCity : String; IState : integer) : integer;
    function  InsertCity(Var SCity: String; IState : integer) : integer;
    function  HashCity(Var SCity : String; IState : integer) : integer;
    procedure SaveCities;
    procedure SortZipCity;
    function  LoadCities : boolean;
    function  AddressToStr(Var A : TAddress) : String;
    function  MatchZipCity(Z, C : integer) : boolean;
    function  SameString(Var S1, S2 : String) : boolean;
    { Public declarations }
  end;

var istreetobject : TStreetobject;

implementation
uses parser, sysutils, forms, cityobject, zipobject, Fileio, IDUri;

procedure Addtrace(Var Debug : TDebug; T : String);
begin
   Debug.S :=  Debug.S + '<p>' + T + '</p>';
end;

function TDir.Hashfun(Var S : String) : integer;
begin
   if length(S) = 0 then
     Result := 0
   else if length(S) <= 1 then
     Result := ord(S[1]) mod length(Hash)
   else
     Result := (ord(S[1]) + ord(S[length(S)]) * 8 + ord(S[length(S) div 2]) * 64) mod length(Hash);
end;

function TDir.IsSimilar(i1, i2 : integer) : boolean;
Var i, j : integer;
begin
   if i1 = i2 then
     begin
       result := true;
       exit;
     end;
   result := false;
   for i := 0 to length(Entries) -1 do
      if Entries[i].ID = i1 then
         begin
           for j := 0 to length(Entries[i].Similar) - 1 do
             if Entries[i].Similar[j] = i2 then
                result := true;
           exit;
         end;
end;

function TDir.Getname(ID : integer) : String;
Var i : integer;
begin
   for i := 0 to length(Entries) -1 do
     if Entries[i].ID = ID then
        begin
          Result := Entries[i].Name;
        end;
end;

function TDir.find(Name : String) : integer;
Var H : integer;
begin
  Name := UpStr(Name);
  TruncateStr(Name);
  H := HashFun(Name);
  H := Hash[H];
  while H >= 0 do
    if entries[H].Name = Name then
       begin
         Result := Entries[H].ID;
         exit;
       end
    else
       H := entries[H].HashNext;
   Result := -1;
//   raise exception.create('error in tdir.find');
end;

constructor TDir.Create(Dir : String);
begin
   DirName := Dir;
   Count := 0;
   fillchar(hash, sizeof(hash), -1);
   Entries := nil;
end;

procedure TDir.Add(Name : String; ID : integer = -1);
Var H : integer;
begin
    Name := UpStr(Name);
    TruncateStr(Name);
    H := Find(Name);
    if H >= 0 then
      begin
       inc(Entries[h].Count);
       exit;
      end;
    H := Hashfun(Name);
    setlength(Entries, length(Entries) + 1);
    if ID < 0 then
       ID := length(entries)-1;
    entries[length(entries)-1].ID := ID;
    entries[length(entries)-1].Name := Name;
    entries[length(entries)-1].HashNext := Hash[H];
    entries[length(entries)-1].Count := 1;
    Hash[H] := length(entries) - 1;
end;

procedure TDir.AddAbbrev(Name : String; Delimiter : char);
Var pp, i,j, c, P, P0, ID : integer;
    W : array[0..100] of String;
    S : String;
    SF : String;
begin
  ReadStringFile(Name, SF);
  PP := 1;
  while PP < length(SF) do
       begin
         scanline(SF, PP, S);
         P := 1;
         P0 := P;
         C := 0;
         while P <= length(S) do
           begin
             if (S[P] = Delimiter) or (P = length(S)) then
               begin
                  if (P = length(S)) then
                    W[C] := copy(S, P0, P-P0 + 1)
                  else
                    W[C] := copy(S, P0, P-P0);
                  TruncateShortStr(W[C]);
                  UPString(W[C]);
                  if W[C] <> '' then
                    inc(C);
                  while (P <= length(S)) and (S[P] = Delimiter) do
                    inc(P);
                  P0 := P;
               end;
             inc(P);
           end;
         for i := 0 to c - 1 do
           begin
             ID := find(W[i]);
             if ID >= 0 then
                begin
                  for j := 0 to C - 1 do
                    if i <> j then
                      if (W[j] <> '-') and (W[j] <> '') then
                        Add(W[j], ID);
                end;
           end;
       end;
end;

procedure TDir.Sort;
  procedure QuickSort(L, R: Integer);
  var
    I, J : Integer;
    T, X : TDirEntry;
  begin
    I := L;
    J := R;
    X := Entries[(L + R) div 2];
    repeat
      while Entries[i].Name < X.Name do Inc(I);
      while X.Name < Entries[J].Name do Dec(J);
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
  QuickSort(0, length(Entries) - 1);
end;


procedure TDir.Save;
Var F : Text;
    i, j : integer;
begin
   AssignFile(f, DirName);
   Rewrite(F);
   writeln(F, length(Entries));
   try
      for i := 0 to length(entries) - 1 do
        with entries[i] do
          begin
            writeln(F, ID);
            writeln(F, Count);
            for j := 0 to length(Similar) -1 do
              writeln(F, Similar[j]);
            writeln(F, Name);
            writeln(F, '---');
          end;
      writeln(F, '.');
   finally
     CloseFile(F);
   end;
end;

procedure TDir.Load;
Var F : Text;
    i, H, Cnt, V, E : integer;
    S : String;
    MainName : String;
begin
   AssignFile(f, DirName);
   Reset(F);
   try
      readln(F, Cnt);
      while true do
        begin
          readln(F, S);
          if S = '.' then
             break;
          i := ValStr(S);
          readln(F, Cnt);
          setlength(Entries, length(Entries) + 1);
          E := length(Entries)-1;
          Entries[E].Similar := nil;
          repeat
            readln(F, S);
            V := ValStr(S);
            if V <> 0 then
               begin
                 setlength(Entries[E].Similar, length(Entries[length(Entries)-1].Similar) + 1);
                 Entries[E].Similar[length(Entries[E].Similar) - 1] := V;
               end;
          until V = 0;
          MainName := S;
          while S <> '---' do
            begin
              Entries[E].ID := i;
              Entries[E].Name := S;
              Entries[E].MainName := MainName;
              Entries[E].Count := Cnt;
              H := Hashfun(S);
              Entries[E].HashNext := Hash[H];
              Hash[H] := E;
              readln(F, S);
              if S <> '---' then
                begin
                  setlength(Entries, length(Entries) + 1);
                  E := length(Entries)-1;
                  Entries[E].Similar := Entries[E-1].Similar;
                end;
            end;
        end;
   finally
     CloseFile(F);
   end;
end;

const FilesProc : integer = 0;
procedure TStreetObject.FillPrefixes(FileName : String);
Var S : String;
    Line : String;
    P : integer;
    RT1 : boolean;
begin
   RT1 := Pos('.RT1', UpStr(FileName)) <> 0;
   if (not RT1) and (Pos('.RT5', UpStr(FileName)) = 0) then
      exit;
   inc(FilesProc);
   if (FilesProc Mod 20) = 0 then
     Interf.SetStatus('Searching street attributes : ' + inttostr(FilesProc) + ' files processed');
   ReadStringFile(FileName, S);
   P := 1;
   while P < length(S) do
     begin
       ScanLine(S, p, Line);
       if RT1 then
         begin
           DirPrefixes.Add(copy(Line, RT1FEDIRP, RT1FEDIRPL));
           DirSuffixes.Add(copy(Line, RT1FEDIRS, RT1FEDIRSL));
           FeatureTypes.Add(copy(Line, RT1FETYPE, RT1FETYPEL));
           CFCCS.Add(copy(Line, RT1CFCC, RT1CFCCL));
         end
       else
         begin
           DirPrefixes.Add(copy(Line, RT5FEDIRP, RT5FEDIRPL));
           DirSuffixes.Add(copy(Line, RT5FEDIRS, RT5FEDIRSL));
           FeatureTypes.Add(copy(Line, RT5FETYPE, RT5FETYPEL));
         end;
     end;
end;

procedure TStreetObject.scandirs(D : String; Mask : String; P :TProcedure; ProcessDirs : boolean);
Var SR : TSearchRec;
    R  : integer;
begin
   R := FindFirst(D + Mask, faAnyFile, SR);
   try
     while R = 0 do
        begin
           if SR.Name[1] <> '.' then
             if (SR.Attr and faDirectory) <> 0 then
               begin
                  if processdirs then
                    P(D + SR.Name)
                  else
                    scandirs(D + SR.NAme + '\', Mask, P, false);
               end
             else if not processdirs then
               P(D + SR.Name);
           R := FindNext(SR);
        end;
   finally
      FindClose(SR);
   end;
end;

procedure TStreetObject.PopulateDirs;
begin
   ScanDirs(Dir1, '*.*', FillPrefixes, false);
   FeatureTypes.AddAbbrev(Dir1 + 'a2kapd.txt', TAB);
   FeatureTypes.AddAbbrev(Dir1 + 'features.dir', ' ');
   DirPrefixes.Sort;
   DirSuffixes.Sort;
   FeatureTypes.Sort;
   CFCCS.Sort;
   DirPrefixes.Save;
   DirSuffixes.Save;
   FeatureTypes.Save;
   CFCCS.Save;
end;


procedure TStreetObject.Read(FileName : String);
begin
   inc(FilesProc);
   if (FilesProc Mod 20) = 0 then
     Interf.SetStatus('Processing Tiger street contours : ' + inttostr(FilesProc) + ' files processed');
   if Pos('.RT1', UpStr(FileName)) <> 0 then
      ReadRt1(FileName)
   else if Pos('.RT2', UpStr(FileName)) <> 0 then
      ReadRt2(FileName)
   else if Pos('.RT4', UpStr(FileName)) <> 0 then
      ReadRt4(FileName)
   else if Pos('.RT5', UpStr(FileName)) <> 0 then
      ReadRt5(FileName)
   else if Pos('.RT6', UpStr(FileName)) <> 0 then
      ReadRt6(FileName);
end;

procedure ProcessAddress(Var AlphaPrefixL : string; Var AvenueFromL, FromL : integer; S : String);
Var i, Pref : integer;
begin
   S := upstr(S);
   while (length(S) > 0) and (S[1] = ' ') do
     delete(S, 1, 1);
   while (length(S) > 0) and (S[length(S)] = ' ') do
     delete(S, length(S), 1);
   if S = '' then
      begin
         AvenueFromL := 0;
         FromL := 0;
         AlphaPrefixL := '';
         exit;
      end;
   i := pos('-', S);
   if i <> 0 then
     AvenueFromL := ValStr(copy(S, 1, i-1));
   if (i = 0) or (AvenueFromL = 0) then
     begin
       Pref := 0;
       AvenueFromL := 0;
       for i := 1 to length(S) do
         if (S[i] > '9') or (S[i] < '0') then
           Pref := i;
       if Pref > 0 then
          begin
            AlphaPrefixL := copy(S, 1, Pref);
            FromL := ValStr(Copy(S, Pref+1, length(S) - Pref));
          end
       else
         FromL := ValStr(S);
      end
   else
      begin
         while (i < length(S)) and ((S[i] > '9') or (S[i] < '0')) do
           inc(i);
         FromL := ValStr(Copy(S, i, length(S) - i + 1));
      end;
end;

function TStreetObject.HashNameZip(Name : pchar; NameL : byte; CombinedDir : byte; FType : byte; ZipL : integer) : integer;
begin
{   Result := ord(Name[0]) shl 4 + ord(Name[NameL - 1]) + ord(Name[NameL div 2]) Shl 8 + FType shl 2 + ZipL + CombinedDir shl 6;
   Result := Result Mod ZipHashLength;}
end;

function NumberEnd(Var S : String) : integer;
Var P : integer;
    Number : boolean;
begin
  P := 1;
  Number := false;
  while P < length(S) do
     begin
        if Number then
          begin
            if not (S[P] in ['0'..'9']) then
               begin
                 result := P;
                 exit;
               end;
          end
        else if S[P] in ['0'..'9'] then
           Number := true;
        inc(P);
     end;
   Result := 0;  
end;

function TruncateNameStr(S : String) : String;
Var ss : string;
    P : integer;
begin
   while (length(S) > 0) and (S[1] = ' ') do
      delete(S, 1, 1);
   while (length(S) > 0) and (S[length(S)] = ' ') do
      delete(S, length(S), 1);
   S := UpStr(S);   
   P := NumberEnd(S);
   if P <> 0 then
      begin
        ss := copy(S, P, 2);
        if (ss = 'ND') or (ss = 'RD') or (ss = 'ST') or (ss = 'TH') then
          delete(S, P, 2);
      end;

   Result := S;
end;

const ddd : integer = 0;
procedure TStreetObject.ReadRT1(FileName : String);
Var S : String;
    Line, SN : String;
    P, H, Z, Pref, Suf : integer;
    CF : byte;
begin
   ReadStringFile(FileName, S);
   P := 1;
   while P < length(S) do
     begin
       ScanLine(S, p, Line);
       CF := CFCCS.Find(copy(Line, RT1CFCC, RT1CFCCL));;
       if CF in CFCCSet then
         begin
{           if NumRT1 = 518 then
             NumRT1 := 518;}
           inc(NumRt1);
           if NumRt1 > length(RT1) then
              setlength(RT1, round(1.3*NumRt1) + 1000);
           with RT1[NumRt1 - 1] do
              begin
                TLID := ValStr(copy(Line, RT1TLID, RT1TLIDL));
                Pref := DirPrefixes.Find(copy(Line, RT1FEDIRP, RT1FEDIRPL));
                Suf := DirSuffixes.Find(copy(Line, RT1FEDIRS, RT1FEDIRSL));
                FType := FeatureTypes.Find(copy(Line, RT1FETYPE, RT1FETYPEL));;
                if CombinedDir > 127 then
                  raise exception.create('CombinedDir > 127');
                SN := copy(Line, RT1FEName, RT1FENameL);
                Standartize(SN);
                replacewords(SN);
                if (Pref = NullPrefix) and (SN <> '') and (DirPrefixes.Find(ExtractFirstWord(SN)) >= 0) then
                   begin
                      Pref := DirPrefixes.Find(ExtractFirstWord(SN));
                      DeleteFirstWord(SN);
                   end;
                if (FType = NullType) and (SN <> '') and (FeatureTypes.Find(ExtractLastWord(SN)) >= 0) then
                   begin
                      FType := FeatureTypes.Find(ExtractLastWord(SN));
                      DeleteLastWord(SN);
                   end;
                if (Suf = NullSuffix) and (FTYPE = NullType) and (SN <> '') and (DirSuffixes.Find(ExtractLastWord(SN)) >= 0) then
                   begin
                      Suf := DirSuffixes.Find(ExtractLastWord(SN));
                      DeleteLastWord(SN);
                   end;
                CombinedDir := Pref*10 + Suf;
                Name := SN;
                CFCC := CF;
                StreetRecL := -1;
                StreetRecR := -1;
                AlphaPrefixL := '';
                AlphaPrefixR := '';
                ZipL := ValStr(copy(Line, RT1ZIPL, 5));;
                ZipR := ValStr(copy(Line, RT1ZIPR, 5));
                ProcessAddress(AlphaPrefixL, AvenueFromL, FromL, copy(Line, RT1FRADDL, AddressLength));
{                inc(DDD);
                if DDD = 2303 then
                  DDD := 2303;}
                ProcessAddress(AlphaPrefixR, AvenueFromR, FromR, copy(Line, RT1FRADDR, AddressLength));
                ProcessAddress(AlphaPrefixL, AvenueToL, ToL, copy(Line, RT1TOADDL, AddressLength));
                ProcessAddress(AlphaPrefixR, AvenueToR, ToR, copy(Line, RT1TOADDR, AddressLength));
{                if Tor < 0 then
                  ToR := ToR;}
                FrLat := ValStr(copy(Line, RT1FRLAT, LATL));
                FrLong := ValStr(copy(Line, RT1FRLONG, LONGL));;
                ToLat := ValStr(copy(Line, RT1TOLAT, LATL));
                ToLong := ValStr(copy(Line, RT1TOLONG, LONGL));;
                if ZipL < MinZip then
                  ZipL := IZipObject.FindZip(FrLat/CoorDiv, FrLong/CoorDiv, false);
                if ZipR < MinZip then
                  ZipR := IZipObject.FindZip(ToLat/CoorDiv, ToLong/CoorDiv, false);
                if ZipL = ZipR then
                  begin
                    Z := IZipObject.FindZip(FrLat/CoorDiv, FrLong/CoorDiv, false);
                    if (Z <> ZipL) and (Z <> 0) then
                      ZipR := Z
                    else
                      begin
                        Z := IZipObject.FindZip(ToLat/CoorDiv, ToLong/CoorDiv, false);
                        if (Z <> ZipL) and (Z <> 0) then
                          ZipR := Z;
                      end;
                  end;
                if (ZipL < Minzip) or (ZipR < MinZip) then
                   ZipL := ZipL;
                H := abs(FRLat + FRLong) Mod CoorHashSize;
                HashL := CoorHash[H];
                CoorHash[H] := NumRT1 - 1;
                H := abs(ToLat + ToLong) Mod CoorHashSize;
                HashR := CoorHash[H];
                CoorHash[H] := NumRT1 - 1;
                LeftChain := -1;
                RightChain := -1;
              end;
         end;
     end;
end;

{procedure TStreetObject.ReadNavState(FileName : String);
Var S : String;
    Line, SN : String;
    P, H, Z, Pref, Suf : integer;
    CF : byte;
    Table : TTable;
begin
   Table := TTable.Create(nil);
   Table.TableName := FileName;
   Table.First;
   P := 1;
   while not Table.Eof do
      begin
      end;
   while P < length(S) do
     begin
       ScanLine(S, p, Line);
       CF := CFCCS.Find(copy(Line, RT1CFCC, RT1CFCCL));;
       if CF in CFCCSet then
         begin
           inc(NumRt1);
           if NumRt1 > length(RT1) then
              setlength(RT1, round(1.3*NumRt1) + 1000);
           with RT1[NumRt1 - 1] do
              begin
                TLID := ValStr(copy(Line, RT1TLID, RT1TLIDL));
                Pref := DirPrefixes.Find(copy(Line, RT1FEDIRP, RT1FEDIRPL));
                Suf := DirSuffixes.Find(copy(Line, RT1FEDIRS, RT1FEDIRSL));
                FType := FeatureTypes.Find(copy(Line, RT1FETYPE, RT1FETYPEL));;
                if CombinedDir > 127 then
                  raise exception.create('CombinedDir > 127');
                SN := copy(Line, RT1FEName, RT1FENameL);
                Standartize(SN);
                replacewords(SN);
                if (Pref = NullPrefix) and (SN <> '') and (DirPrefixes.Find(ExtractFirstWord(SN)) >= 0) then
                   begin
                      Pref := DirPrefixes.Find(ExtractFirstWord(SN));
                      DeleteFirstWord(SN);
                   end;
                if (FType = NullType) and (SN <> '') and (FeatureTypes.Find(ExtractLastWord(SN)) >= 0) then
                   begin
                      FType := FeatureTypes.Find(ExtractLastWord(SN));
                      DeleteLastWord(SN);
                   end;
                if (Suf = NullSuffix) and (FTYPE = NullType) and (SN <> '') and (DirSuffixes.Find(ExtractLastWord(SN)) >= 0) then
                   begin
                      Suf := DirSuffixes.Find(ExtractLastWord(SN));
                      DeleteLastWord(SN);
                   end;
                CombinedDir := Pref*10 + Suf;
                Name := SN;
                CFCC := CF;
                StreetRecL := -1;
                StreetRecR := -1;
                AlphaPrefixL := '';
                AlphaPrefixR := '';
                ZipL := ValStr(copy(Line, RT1ZIPL, 5));;
                ZipR := ValStr(copy(Line, RT1ZIPR, 5));
                ProcessAddress(AlphaPrefixL, AvenueFromL, FromL, copy(Line, RT1FRADDL, AddressLength));
                ProcessAddress(AlphaPrefixR, AvenueFromR, FromR, copy(Line, RT1FRADDR, AddressLength));
                ProcessAddress(AlphaPrefixL, AvenueToL, ToL, copy(Line, RT1TOADDL, AddressLength));
                ProcessAddress(AlphaPrefixR, AvenueToR, ToR, copy(Line, RT1TOADDR, AddressLength));
                FrLat := ValStr(copy(Line, RT1FRLAT, LATL));
                FrLong := ValStr(copy(Line, RT1FRLONG, LONGL));;
                ToLat := ValStr(copy(Line, RT1TOLAT, LATL));
                ToLong := ValStr(copy(Line, RT1TOLONG, LONGL));;
                if ZipL < MinZip then
                  ZipL := IZipObject.FindZip(FrLat/CoorDiv, FrLong/CoorDiv, false);
                if ZipR < MinZip then
                  ZipR := IZipObject.FindZip(ToLat/CoorDiv, ToLong/CoorDiv, false);
                if ZipL = ZipR then
                  begin
                    Z := IZipObject.FindZip(FrLat/CoorDiv, FrLong/CoorDiv, false);
                    if (Z <> ZipL) and (Z <> 0) then
                      ZipR := Z
                    else
                      begin
                        Z := IZipObject.FindZip(ToLat/CoorDiv, ToLong/CoorDiv, false);
                        if (Z <> ZipL) and (Z <> 0) then
                          ZipR := Z;
                      end;
                  end;
                if (ZipL < Minzip) or (ZipR < MinZip) then
                   ZipL := ZipL;
                H := abs(FRLat + FRLong) Mod CoorHashSize;
                HashL := CoorHash[H];
                CoorHash[H] := NumRT1 - 1;
                H := abs(ToLat + ToLong) Mod CoorHashSize;
                HashR := CoorHash[H];
                CoorHash[H] := NumRT1 - 1;
                LeftChain := -1;
                RightChain := -1;
              end;
         end;
     end;
end;}


procedure TStreetObject.ReadRT2(FileName : String);
Var S : String;
    Line : String;
     P, d, q, g, t, Rec : integer;
begin
   ReadStringFile(FileName, S);
   P := 1;
   while P < length(S) do
     begin
       ScanLine(S, p, Line);
       d := ValStr(copy(Line, RT2TLID, RT2TLIDL));
       q := ValStr(copy(Line, RT2RTSQ, RT2RTSQL));
       Rec := 0;
       while (Rec < 10) do
         begin
           g := ValStr(copy(Line, RT2LONG1+Rec*(LongL+LatL), LONGL));
           t := ValStr(copy(Line, RT2LAT1+Rec*(LongL+LatL), LATL));
           if g = 0 then
             break;
           inc(Rec);
           inc(NumRt2);
           if NumRt2 > length(RT2) then
             setlength(RT2, round(1.3*NumRt2) + 1000);
           with RT2[NumRt2 - 1] do
             begin
                Long := g;
                Lat := t;
                Tlid := d;
                rtsq := q;
             end;
         end;
     end;
end;

procedure TStreetObject.ReadRT6(FileName : String);
Var S : String;
    Line : String;
    P, RTSQ : integer;
begin
   ReadStringFile(FileName, S);
   P := 1;
   while P < length(S) do
     begin
       ScanLine(S, p, Line);
       inc(NumRt6);
       if NumRt6 > length(RT6) then
          setlength(RT6, round(1.3*NumRt6) + 1000);
       with RT6[NumRT6-1] do
         begin
           TLID := ValStr(copy(Line, RT6TLID, RT1TLIDL));
           RTSQ := ValStr(copy(Line, RT6RTSQ, RT2RTSQL));
           AlphaPrefixL := '';
           AlphaPrefixR := '';
           ZipL := ValStr(copy(Line, RT6ZIPL, 5));;
           ZipR := ValStr(copy(Line, RT6ZIPR, 5));;
           ProcessAddress(AlphaPrefixL, AvenueFromL, FromL, copy(Line, RT6FRADDL, AddressLength));
           ProcessAddress(AlphaPrefixR, AvenueFromR, FromR, copy(Line, RT6FRADDR, AddressLength));
           ProcessAddress(AlphaPrefixL, AvenueToL, ToL, copy(Line, RT6TOADDL, AddressLength));
           ProcessAddress(AlphaPrefixR, AvenueToR, ToR, copy(Line, RT6TOADDR, AddressLength));
         end;
     end;
end;

function TheFileName(Name: String) : String;
Var S : String;
    i : integer;
begin
  S := '';
  i := length(Name);
  while (Name[i] <> '.') and (i > 0) do
    dec(i);
  if i > 0 then
    dec(i);
  while i > 0 do
    begin
      S := Name[i] + S;
      dec(i);
      if Name[i] in ['\', '/', ':'] then
        break;
    end;
  TheFileName := S;
end;


function ExtractFileNo(Var FName : String) : integer;
Var S : String;
begin
  S := TheFileName(FName);
  delete(S, 1, 3);
  Result := ValStr(S);
end;

procedure TStreetObject.ReadRT4(FileName : String);
Var S : String;
    Line : String;
    P : integer;
    d, q, t, Rec, FNo : integer;
begin
   ReadStringFile(FileName, S);
   Fno := ExtractFileNo(FileName);
   P := 1;
   while P < length(S) do
     begin
       ScanLine(S, p, Line);
       d := ValStr(copy(Line, RT4TLID, RT1TLIDL));
       q := ValStr(copy(Line, RT4RTSQ, RT2RTSQL));
       Rec := 0;
       while (Rec < 10) do
         begin
           t := ValStr(copy(Line, RT4FEAT1+Rec*RT4FEATL, RT4FEATL));
           if t = 0 then
             break;
           inc(Rec);
           inc(NumRt4);
           if NumRt4 > length(RT4) then
             setlength(RT4, round(1.3*NumRt4) + 1000);
           with RT4[NumRt4 - 1] do
             begin
                FEAT := t*Fno;
                RTSQ := q;
                Tlid := d;
             end;                                                                  
         end;
     end;
end;

procedure TStreetObject.ReadRT5(FileName : String);
Var S : String;
    SN, Line : String;
    P, FNo, Pref, Suf : integer;
begin
   ReadStringFile(FileName, S);
   P := 1;
   while P < length(S) do
     begin
       ScanLine(S, p, Line);
       inc(NumRt5);
       if NumRt5 > length(RT5) then
          setlength(RT5, round(1.3*NumRt5) + 1000);
       with RT5[NumRt5 - 1] do
          begin
            FEAT := ValStr(copy(Line, RT5FEAT, RT5FEATL));
            FNO := ValStr(copy(Line, RT5File, RT5FileL));
            Feat := Feat * FNo;
            Pref := DirPrefixes.Find(copy(Line, RT5FEDIRP, RT5FEDIRPL));
            Suf := DirSuffixes.Find(copy(Line, RT5FEDIRS, RT5FEDIRSL));
            FType := FeatureTypes.Find(copy(Line, RT5FETYPE, RT5FETYPEL));;
            SN := copy(Line, RT5FEName, RT5FENameL);
            Standartize(SN);
            replacewords(SN);
            if (Pref = NullPrefix) and (SN <> '') and (DirPrefixes.Find(ExtractFirstWord(SN)) >= 0) then
               begin
                  Pref := DirPrefixes.Find(ExtractFirstWord(SN));
                  DeleteFirstWord(SN);
               end;
            if (FType = NullType) and (SN <> '') and (FeatureTypes.Find(ExtractLastWord(SN)) >= 0) then
               begin
                  FType := FeatureTypes.Find(ExtractLastWord(SN));
                  DeleteLastWord(SN);
               end;
            if (Suf = NullSuffix) and (FTYPE = NullType) and (SN <> '') and (DirSuffixes.Find(ExtractLastWord(SN)) >= 0) then
               begin
                  Suf := DirSuffixes.Find(ExtractLastWord(SN));
                  DeleteLastWord(SN);
               end;
            CombinedDir := Pref * 10 + Suf;
            Name := SN;
          end;
     end;
end;

{procedure TStreetObject.ScanRT1(FileName : String);
Var S : String;
    Line : String;
    P : integer;
begin
   if Pos('.RT1', UpStr(FileName)) = 0 then
      exit;
   ReadStringFile(FileName, S);
   P := 1;
   while P < length(S) do
     begin
       ScanLine(S, p, Line);
       inc(NumSegments);
       if NumSegments >= length(Segments) then
         setlength(Segments, round(Numsegments * 1.2) + 100);
       with Segments[NumSegments-1] do
         begin
            FeatureID := FindFeature(true, ;
            TLID : integer;
            CFCC : byte;
            SLeft, ELeft : integer;
            SRight, ERight : integer;
            ZipLeft, ZipRight : word;
            StartVertex, EndVertex : integer;
           copy(Line, RT1TLID, RT1TLIDL);
           DirPrefixes.Find(copy(Line, RT1FEDIRP, RT1FEDIRPL));
           DirSuffixes.Find(copy(Line, RT1FEDIRS, RT1FEDIRSL));
           FeatureTypes.Find(copy(Line, RT1FETYPE, RT1FETYPEL));
           CFCCS.Find(copy(Line, RT1CFCC, RT1CFCCL));
          end;
     end;
end;}

{function TStreetObject.SameAltAddress(A, f : integer) : boolean;
begin
  Result := A = f;
end;}

const Numwrites : integer = 0;

procedure TStreetObject.WriteAddress(R : integer; Left : boolean);
Var Alt : array[0..100] of integer;
    NumAlt, i, j, jj, f, k : integer;
    Found : boolean;
begin
// Find the alternative addresses
   inc(NumWrites);
   NumAlt := 0;
   j := R;
   while j >= 0 do
     begin
       i := RT4Hash.Find(RT1[j].TLID);
       while (i >= 0) do
         begin
           if RT4[i].TLID = RT1[j].TLID then
              begin
                f := RT5Hash.Find(RT4[i].FEAT);
                while f >= 0 do
                  begin
                    if RT5[f].FEAT = RT4[i].FEAT then
                      begin
                        Found := false;
                        for k := 0 to NumAlt-1 do
                          if SameAltAddress(Alt[k], f) then
                            Found := true;
                        if not Found then
                          begin
                            inc(NumAlt);
                            Alt[NumAlt-1] := f;
                          end;
                      end;
                    f := RT5[f].HashNextFeat;
                  end;
              end;
           i := RT4[i].HashNextTLID;
         end;
       jj := j;
       MoveNext(j, Left);
       if jj = j then
         break;
     end;
// write the main address
   writebyte(RT1[R].CFCC);
   if NumAlt = 0 then
      writebyte(RT1[R].CombinedDir)
   else
      writebyte(RT1[R].CombinedDir+128);
   writebyte(RT1[R].Ftype);
   writeint3(RT1[R].ZIPL);
   if (RT1[R].ZIPL <> 0) and (RT1[R].ZIPL < MinZip) then
     raise exception.create('RT1[R].ZIPL < MinZip');
   writeString(RT1[R].Name);
   for i := 0 to NumAlt - 1 do
     begin
       if i = (NumAlt - 1) then
          writebyte(RT5[Alt[i]].CombinedDir)
       else
          writebyte(RT5[Alt[i]].CombinedDir+128);
       writebyte(RT5[Alt[i]].Ftype);
       writeString(RT5[Alt[i]].Name);
     end;
end;

procedure TStreetObject.ReadStruct(Var S; Size : integer; Var P : integer);
begin
  Move((@DataArr[P])^, S, Size);
  inc(P, Size);
end;

procedure TStreetObject.ReadString(Var S : String; Var P : integer);
begin
   Setlength(S, DataArr[P]);
   Move((@DataArr[P+1])^, (@S[1])^, DataArr[P]);
   inc(P, DataArr[P]+1);
end;

const Numreads : integer = 0;

procedure TStreetObject.ReadAddress(Var A : TAddress; Var P : integer);
begin
   inc(Numreads);
   ReadStruct(A.CommonRec, sizeof(A.Commonrec), P);
   A.Zip := ReadInt3(P);
   ReadString(A.Name, P);
end;

function TStreetObject.ReadByte(Var P : integer) : byte;
begin
  Result := DataArr[P];
  inc(P);
end;

function  TStreetObject.ReadWord(Var P : integer) : word;
begin
   move(DataArr[P], result, 2);
   inc(P, 2);
end;


function TStreetObject.ReadNextAddress(Var A : TAddress; Var Next : TAddress; Var P : integer) : boolean;
begin
   if (A.CommonRec.ComBinedDir and 128) <> 0 then
      begin
         Next.CommonRec.CFCC := A.CommonRec.CFCC;
         Next.Zip := A.Zip;
         Next.CommonRec.CombinedDir := ReadByte(P);
         Next.CommonRec.FType := ReadByte(P);
         ReadString(Next.Name, P);
         Result := true;
      end
   else
      Result := false;
end;

procedure TStreetObject.WriteVertexes(R : integer; NotLast: boolean; Var FLat, FLon : integer; Left : boolean);
Var Vert : array[0..1000] of integer;
    i, NumVert : integer;
begin
   if DataIndex >= 538605 then
      DataIndex := DataIndex;
   NumVert := 0;
   i := RT2Hash.Find(RT1[R].TLID);
   while i <> -1 do
      begin
        if RT2[i].TLID = RT1[R].TLID then
           begin
              inc(NumVert);
              Vert[NumVert-1] := i;
           end;
        i := RT2[i].HashNextTlid;
      end;
   if Numvert >= 255 then
     begin
       writebyte(255);
       writeword(NumVert);
     end
   else
      writebyte(NumVert);
   if Flat = 0 then
     begin
       FLat := Rt1[R].FRLat;
       FLon := RT1[R].FRLong;
       writeinteger(Rt1[R].FRLat);
       writeinteger(RT1[R].FRLong);
       for i := 0 to NumVert - 1 do
          begin
             writeint3(RT2[Vert[i]].Lat-FLat);
             writeint3(RT2[Vert[i]].Long-FLon);
          end;
       writeint3(RT1[R].ToLat-FLat);
       writeint3(RT1[R].ToLong-FLon);
     end
   else
     begin
       if Left then
          begin
             for i := 0 to NumVert - 1 do
                begin
                   writeint3(RT2[Vert[i]].Lat-FLat);
                   writeint3(RT2[Vert[i]].Long-FLon);
                end;
             writeint3(RT1[R].ToLat-FLat);
             writeint3(RT1[R].ToLong-FLon);
          end
       else
          begin
             for i := NumVert - 1 downto 0 do
                begin
                   writeint3(RT2[Vert[i]].Lat-FLat);
                   writeint3(RT2[Vert[i]].Long-FLon);
                end;
             writeint3(RT1[R].FRLAT-FLat);
             writeint3(RT1[R].FRlong-FLon);
          end;
     end;
end;

procedure TStreetObject.SkipVertixes(Var P : integer; Var FLat, FLon : integer; Var PrevLat, PrevLon : integer);
Var NumVert : integer;
begin
   NumVert := readbyte(P);
//   inc(DDD);
   if Numvert = 255 then
      Numvert := readword(P);
   if Flat = 0 then
     begin
       FLat := Readinteger(P);
       FLon := Readinteger(P);
     end;
   P := P + NumVert * 6;
   PrevLat := FLat + Readint3(P);
   PrevLon := FLon + Readint3(P);
end;


procedure TStreetObject.ReadVertixes(Var V : TVertexes; Var P : integer; Var FLat, FLon : integer; Var PrevLat, PrevLon : integer);
Var NumVert, Pos, i : integer;
begin
   NumVert := readbyte(P);
   if Numvert = 255 then
      Numvert := readword(P);
   Pos := V.Numvert;
   if FLat = 0 then
     begin
       FLat := Readinteger(P);
       FLon := Readinteger(P);
       V.Vert[Pos].Lat := FLat;
       V.Vert[Pos].Lon := FLon;
       inc(Pos);
       for i := 0 to NumVert - 1 do
          begin
             V.Vert[Pos].Lat := FLat + readint3(p);
             V.Vert[Pos].Lon := FLon + readint3(p);
             inc(Pos)
          end;
       V.Vert[Pos].Lat := FLAT + readint3(P);
       V.Vert[Pos].Lon := FLON + readint3(P);
       inc(Pos);
       V.Numvert := Pos;
     end
   else
     begin
       if V.NumVert = 0 then
         begin
           V.Vert[Pos].Lat := PrevLat;
           V.Vert[Pos].Lon := PrevLon;
           inc(pos);
         end;
       V.Vert[Pos].Lat := FLat + readint3(p);
       V.Vert[Pos].Lon := FLon + readint3(p);
       inc(pos);
       for i := 0 to NumVert - 1 do
          begin
             V.Vert[Pos].Lat := FLat + readint3(p);
             V.Vert[Pos].Lon := FLon + readint3(p);
             inc(Pos)
          end;
       V.Numvert := Pos;
     end;
   PrevLat := V.Vert[Pos-1].Lat;
   PrevLon := V.Vert[Pos-1].Lon;
end;


const FL_EAvenue = 1;
      FL_EAlphaPrefix = 2;
      Fl_ExtraFlag = 1;
      Fl_End = 2;
      FL_Word = 4;
      FL_L = 8;
      FL_R = 16;
      FL_LZip = 32;
      FL_RZip = 64;
      FL_Last = 128;

procedure TStreetObject.WriteWord(W : integer);
begin
   ExtendData(2);
   if (W >= 256*256) or (W < 0) then
      raise Exception.Create('Error');
   move(w, (@DataArr[DataIndex])^, 2);
   inc(DataIndex, 2);
end;

procedure TStreetObject.Writebyte(W : integer);
begin
   ExtendData(1);
   if (W >= 256) or (W < 0) then
      begin
        W := 0;
        exit;
        raise Exception.Create('Error');
      end;
   DataArr[DataIndex] := W;
   inc(DataIndex);
end;

procedure TStreetObject.Writeshortint(W : integer);
begin
   ExtendData(1);
   if (W >= 128) or (W <= -128) then
      raise Exception.Create('Error');
   DataArr[DataIndex] := byte(shortint(W));
   inc(DataIndex);
end;

function  TStreetObject.readshortint(Var P : integer) : integer;
begin
   result := shortint(DataArr[P]);
   inc(P);
end;

procedure TStreetObject.WriteInteger(W : integer);
begin
   ExtendData(4);
   Move(W, DataArr[DataIndex], 4);
   inc(DataIndex, 4);
end;

function TStreetObject.ReadInteger(Var P : integer) : integer;
begin
   Move(DataArr[P], Result, 4);
   inc(P, 4);
end;

procedure TStreetObject.WriteInt3(W : integer);
begin
   ExtendData(3);
   w := w * 256;
   Move(ptr(integer(@W)+1)^, DataArr[DataIndex], 3);
   inc(DataIndex, 3);
end;

function TStreetObject.ReadInt3(Var P : integer) : integer;
begin
   Move(DataArr[P], ptr(integer(@Result)+1)^, 3);
   Result := Result div 256;
   inc(P, 3);
end;


procedure TStreetObject.WriteString(S : String);
begin
   ExtendData(length(S) + 1);
   DataArr[DataIndex] := length(S);
   move((@S[1])^, (@DataArr[DataIndex+1])^, length(S));
   inc(DataIndex, length(S) + 1);
end;

procedure TStreetObject.ExtendData(L : integer);
begin
  if (DataIndex+L) >= length(DataArr) then
     setlength(DataArr, round((DataIndex + L) * 1.3) + 1000);
end;

function TStreetObject.WriteRange(FromL, ToL, FromR, ToR : integer;
        AlphaPrefixL : String; AlphaPrefixR : String;
        AvenueFromR, AvenueToR : integer;
        AvenueFromL, AvenueToL : integer; Zip, LZip, RZip : Integer) : integer;
Var Flags, Eflags : integer;
begin
{   if NumWrites = 27 then
     NumWrites := 27;
   inc(NumWrites);}
   result := DataIndex;
   if (AvenueFromL <> 0) or (AvenueFromR <> 0) then
      EFlags := Fl_EAvenue
   else
      EFlags := 0;
   if (AlphaPrefixL <> '') or (AlphaPrefixR <> '') then
      EFlags := EFlags or FL_EAlphaPrefix;
   if EFlags = 0 then
     Flags := 0
   else
     Flags := FL_ExtraFlag;
   if  (abs(ToL-FromL) > 127) or (abs(ToR-FromR) > 127) or (FromL >= 65535) or
       (ToL >= 65535) or (FromR >= 65535) or  (ToR >= 65535) then
      Flags := Flags or FL_Word;
   if (FromL <> 0) or (ToL <> 0) then
      Flags := Flags or FL_L;
   if (FromR <> 0) or (ToR <> 0) then
      Flags := Flags or FL_R;
   if (Zip <> LZip) and (LZip >= MinZip) then
      Flags := Flags or Fl_LZip;
   if (Zip <> RZip) and (RZip >= MinZip) then
      Flags := Flags or Fl_RZip;
   writebyte(Flags);
   if (Flags and FL_ExtraFlag) <> 0 then
     writebyte(EFlags);
   if (Flags and Fl_LZip) <> 0 then
      begin
        if (LZip <> 0) and (LZip < Minzip) then
          raise exception.Create('LZip < Minzip');
        WriteInt3(LZip);
      end;
   if (Flags and Fl_RZip) <> 0 then
      begin
        if (RZip <> 0) and (RZip < Minzip) then
          raise exception.Create('RZip < Minzip');
        WriteInt3(RZip);
      end;
   if (EFlags and FL_EAlphaPrefix) <> 0 then
     begin
      writestring(AlphaPrefixL);
      writestring(AlphaPrefixR);
     end;
   if (EFlags and FL_EAvenue) <> 0 then
     begin
       if (AvenueFromL >= 65535) or (AvenueToL >= 65535) or
          (AvenueFromR >= 65535) or (AvenueToR >= 65535) then
            begin
               writeword(65535);
               writeinteger(AvenueFromL);
               writeinteger(AvenueToL);
               writeinteger(AvenueFromR);
               writeinteger(AvenueToR);
            end
       else
         begin
           writeword(AvenueFromL);
           writeword(AvenueToL);
           writeword(AvenueFromR);
           writeword(AvenueToR);
         end;
     end;
   if (Flags and FL_Word) <> 0 then
     begin
       if (FromL >= 65535) or (ToL >= 65535) or
          (FromR >= 65535) or (ToR >= 65535) then
            begin
               writeword(65535);
               writeinteger(FromL);
               writeinteger(ToL);
               writeinteger(FromR);
               writeinteger(ToR);
            end
       else
          begin
             if (Flags and FL_L) <> 0 then
               begin
                 writeword(FromL);
                 writeword(ToL);
               end;
             if (Flags and FL_R) <> 0 then
               begin
                 writeword(FromR);
                 writeword(ToR);
               end;
          end;
     end
   else
     begin
     if (Flags and FL_L) <> 0 then
       begin
         writeword(FromL);
         writeshortint(ToL-FromL);
       end;
     if (Flags and FL_R) <> 0 then
       begin
         writeword(FromR);
         writeshortint(ToR-FromR);
       end;
     end;
end;


function TStreetObject.ReadRange(Var P, FromL, ToL, FromR, ToR : integer;
        Var AlphaPrefixL : String; Var AlphaPrefixR : String;
        Var AvenueFromR, AvenueToR : integer;
        Var AvenueFromL, AvenueToL : integer; Var LZip, RZip : Integer) : byte;
Var Flags, Eflags : integer;
begin
   Flags := readbyte(P);
   if (Flags and FL_ExtraFlag) <> 0 then
     EFlags := readbyte(P)
   else
     EFlags := 0;
   if (Flags and Fl_LZip) <> 0 then
      LZip := ReadInt3(P)
   else
      LZip := 0;
   if (Flags and Fl_RZip) <> 0 then
      RZip := ReadInt3(P)
   else
      RZip := 0;
   if (EFlags and FL_EAlphaPrefix) <> 0 then
     begin
      readstring(AlphaPrefixL, P);
      readstring(AlphaPrefixR, P);
     end
   else
     begin
       AlphaPrefixL := '';
       AlphaPrefixR := '';
     end;
   if (EFlags and FL_EAvenue) <> 0 then
     begin
       AvenueFromL := readword(P);
       if AvenueFromL = 65535 then
          begin
           AvenueFromL := readinteger(P);
           AvenueToL := readinteger(P);
           AvenueFromR := readinteger(P);
           AvenueToR := readinteger(P);
          end
       else
         begin
           AvenueToL := readword(P);
           AvenueFromR := readword(P);
           AvenueToR := readword(P);
         end;
     end
   else
     begin
       AvenueFromL := 0;
       AvenueToL := 0;
       AvenueFromR := 0;
       AvenueToR := 0;
     end;
   FromL := 0;
   FromR := 0;
   ToL := 0;
   ToR := 0;
   if (Flags and FL_Word) <> 0 then
     begin
       FromL := readword(P);
       if FromL = 65535 then
            begin
               FromL := readinteger(P);
               ToL := readinteger(P);
               FromR := readinteger(P);
               ToR := readinteger(P);
            end
       else
          begin
             if (Flags and FL_L) <> 0 then
               begin
                 ToL := readword(P);
                 if (Flags and FL_R) <> 0 then
                   begin
                     FromR := readword(P);
                     ToR := readword(P);
                   end;
               end
             else
                 if (Flags and FL_R) <> 0 then
                   begin
                     FromR := FromL;
                     ToR := readword(P);
                   end;
          end;
     end
   else
     begin
     if (Flags and FL_L) <> 0 then
       begin
         FromL := readword(P);
         ToL := FromL + readshortint(P);
       end;
     if (Flags and FL_R) <> 0 then
       begin
         FromR := readword(P);
         ToR := FromR + readshortint(P);
       end;
     end;
   Result := flags;
end;

procedure TStreetObject.WriteRanges(R : integer; NotLast : boolean; Left : boolean; Z : integer);
Var i, Last : integer;
begin
   with RT1[R] DO
     begin
       if Left then
         begin
           Last := writerange(FromL, ToL, FromR, ToR, AlphaPrefixL, AlphaPrefixR,
              AvenueFromR,      AvenueToR, AvenueFromL, AvenueToL, Z, ZipL, ZipR);
         end
       else
         begin
           Last := writerange(FromR, ToR, FromL, ToL, AlphaPrefixR, AlphaPrefixL,
             AvenueFromL, AvenueToL, AvenueFromR, AvenueToR, Z, ZipR, ZipL);
         end;
     end;
   i := RT6Hash.Find(RT1[R].TLID);
   while i <> -1 do
      begin
        if RT6[i].TLID = RT1[R].TLID then
           with RT6[i] DO
            if Left then
             Last := writerange(FromL, ToL, FromR, ToR, AlphaPrefixL, AlphaPrefixR,
               AvenueFromR, AvenueToR, AvenueFromL, AvenueToL, Z, ZipL, ZipR)
            else
             Last := writerange(FromR, ToR, FromL, ToL, AlphaPrefixR, AlphaPrefixL,
               AvenueFromL, AvenueToL, AvenueFromR, AvenueToR, Z, ZipR, ZipL);
        i := RT6[i].HashNextTlid;
      end;
   if not notlast then
     DataArr[Last] := DataArr[Last] or Fl_LAST;
   DataArr[Last] := DataArr[Last] or Fl_END;
end;

function TStreetObject.MoveNext(Var R : integer; Var Left : boolean) : boolean;
Var Lat, Lon : integer;
begin
   if (Left and (RT1[R].LeftChain = -1)) or ((not Left) and (RT1[R].RightChain = -1)) then
     begin
        Result := false;
        exit;
     end;
   if Left then
     begin
       Lon := RT1[R].FRLong;
       Lat := RT1[R].FrLat;
     end
   else
     begin
       Lon := RT1[R].ToLong;
       Lat := RT1[R].ToLat;
     end;
   if Left then
     R := RT1[R].LeftChain
   else
     R := RT1[R].RightChain;
   if (Lat = RT1[R].FRLat) and (Lon = RT1[R].FRLong) then
      begin
         Result := RT1[R].RightChain <> -1;
         Left := false;
      end
   else if (Lat = RT1[R].TOLat) and (Lon = RT1[R].ToLong) then
      begin
         Result := RT1[R].LeftChain <> -1;
         Left := true;
      end
   else
      raise exception.Create('Error');
end;

const ppp1 = 61238563;
const ppp2 = 61554680;
procedure TStreetObject.JoinCounty(FileName : String);
Var F : File;
    nr : integer;
begin
   if Pos('.MAP', UpStr(FileName)) = 0 then
      exit;
   assignFile(F, FileName);
   reset(F, 1);
   blockread(F, (@DataArr[DataIndex])^, filesize(F), NR);
   if (DataIndex <= ppp1) and ((DataIndex + NR) > ppp1) then
      Interf.SetStatus('Position ' +Inttostr(ppp1) + ' ' +  FileName);
   if (DataIndex <= ppp2) and ((DataIndex + NR) > ppp2) then
      Interf.SetStatus('Position ' +Inttostr(ppp2) + ' ' +  FileName);
   inc(DataIndex, NR);
   if DataIndex > length(DataArr) then
     raise exception.Create('Too small array for join');
   closefile(F);
end;

procedure TStreetObject.CalcCounty(FileName : String);
Var F : File;
    nr : integer;
begin
   if Pos('.RT1', UpStr(FileName)) <> 0 then
      if not FileExists(TheFullFileName(FileName) + '.MAP') then
        AllProcessed := false;
   if Pos('.MAP', UpStr(FileName)) = 0 then
      exit;
   assignFile(F, FileName);
   reset(F, 1);
   inc(TotalSize, filesize(F));
   closefile(F);
end;

procedure TStreetObject.ProcessOneCounty(FileName : String);
Var h : integer;
    r1, R, Prev, i, Flat, Flon : integer;
    NotLast, Left, First, PrevL : boolean;
    F : file;
    Z, nw : integer;
begin
    if Pos('.RT1', UpStr(FileName)) = 0 then
      exit;
    if FileExists(TheFullFileName(FileName) + '.MAP') then
      exit;
    Setlength(DataArr, 0);
    DataIndex := 0;
    Setlength(RT1, 0);
    NumRt1 := 0;
    Setlength(RT2, 0);
    NumRt2 := 0;
    Setlength(RT4, 0);
    NumRt4 := 0;
    Setlength(RT5, 0);
    NumRt5 := 0;
    Setlength(RT6, 0);
    NumRT6 := 0;
    RT1Hash.Clear;
    RT2Hash.Clear;
    RT4Hash.Clear;
    RT5Hash.Clear;
    RT6Hash.Clear;
{    for h := 0 to ZipHashLength-1 do
      ZipHash[H] := -1;}
    for h := 0 to CoorHashSize-1 do
      CoorHash[H] := -1;
   Interf.SetStatus('Processing county ' + FileName);
   ReadRT1(FileName);
   ReadRT2(TheFullFileName(FileName) + '.rt2');
   ReadRT4(TheFullFileName(FileName) + '.rt4');
   ReadRT5(TheFullFileName(FileName) + '.rt5');
   ReadRT6(TheFullFileName(FileName) + '.rt6');
//   ScanDirs(FileName + '\', '*.*', Read, false);
   for i := 0 to NumRT1 - 1 do
     with RT1[i] do
       RT1Hash.Append(HashNextTlid, TLID, i);
   for i := 0 to NumRT2 - 1 do
     with RT2[i] do
        RT2Hash.Append(HashNextTlid, TLID, i);;
   for i := 0 to NumRT6 - 1 do
     with RT6[i] do
       RT6Hash.Append(HashNextTlid, TLID, i);
   for i := 0 to NumRT4 - 1 do
     with RT4[i] do
        RT4Hash.Append(HashNextTlid, tlid, i);;
   for i := 0 to NumRT5 - 1 do
     with RT5[i] do
       RT5Hash.Append(HashNextFEAT, FEAT, i);;
   for r1 := 0 to NumRt1 - 1 do
     with RT1[r1] do
      if (RT1[r1].Name <> '') or (RT1[r1].CombinedDir <> (NullPrefix * 10 + NullSuffix)) or (RT1[r1].Ftype <> NullType) then
       if (LeftChain = -1) and (RightChain = -1) then
         begin
            R := r1;
            Left := true;
            while ExtendChain(R, Left) do;
            R := r1;
            Left := false;
            while ExtendChain(R, Left) do;
            R := r1;
            Left := true;
            while MoveNext(R, Left) do;
            Left := not Left;
            WriteAddress(R, Left);
            Z := RT1[R].ZipL;
            NotLast := true;
            First := true;
            FLat := 0;
            FLon := 0;
            while R <> - 1 do
              begin
                Prev := R;
                PrevL := Left;
                NotLast := MoveNext(R, Left);
                WriteVertexes(Prev, R <> Prev, FLat, FLon, not PrevL);
                WriteRanges(Prev, R <> Prev, not PrevL, Z);
                First := false;
                if R = Prev then
                  break;
              end;
         end;
        inc(TotalSize, DataIndex);
        AssignFile(F, TheFullFileName(FileName) + '.MAP');
        rewrite(F, 1);
        blockwrite(F, (@DataArr[0])^, DataIndex, Nw);
        closefile(F);
end;

function TStreetObject.MatchVertex(Lat, Lon : integer; SR : integer ;Var L: boolean) : boolean;
begin
   if (Lat = RT1[SR].FRLat) and (Lon = RT1[SR].FRLong) then
      begin
         Result := true;
         L := true;
      end
   else if (Lat = RT1[SR].TOLat) and (Lon = RT1[SR].ToLong) then
      begin
         Result := true;
         L := false;
      end
   else
      Result := false;
end;

function TStreetObject.SameAddress(R, SR : integer) : boolean;
begin
   Result := (RT1[R].CFCC = RT1[SR].CFCC) and
             (RT1[R].CombinedDir = RT1[SR].CombinedDir) and
             (RT1[R].ZipL = RT1[SR].ZIPL) and
             (RT1[R].FType = RT1[SR].Ftype) and
             (RT1[R].Name = RT1[SR].Name);
end;

function TStreetObject.SameAltAddress(i, j : integer) : boolean;
begin
   Result := (i=j) or (
                       (RT5[i].CombinedDir = RT5[j].CombinedDir) and
                       (RT5[i].FType = RT5[j].Ftype) and
                       (RT5[i].Name = RT5[j].Name)
                      );
end;


function TStreetObject.ExtendChain(Var R : integer; Var Left : boolean) : boolean;
Var SR, H, Lon, Lat : integer;
    L : boolean;
begin
  if Left then
    begin
      Lon := RT1[R].FRLong;
      Lat := RT1[R].FrLat;
    end
  else
    begin
      Lon := RT1[R].ToLong;
      Lat := RT1[R].ToLat;
    end;
  H := abs(Lat + Lon) Mod CoorHashSize;
  SR := CoorHash[H];
  while SR <> - 1 do
    begin
      if (SR <> R) and SameAddress(R, SR) and MatchVertex(Lat, Lon, SR, L) then
         begin
           if L then
             begin
                if RT1[SR].RightChain <> - 1 then
                  begin
                    Result := false;
                    exit;
                  end;
                RT1[SR].LeftChain := R;
             end
           else
             begin
                if RT1[SR].LeftChain <> - 1 then
                  begin
                    Result := false;
                    exit;
                  end;
               RT1[SR].RightChain := R;
             end;
           if Left then
             begin
               if RT1[R].LeftChain <> -1 then
                 begin
                   Result := false;
                   exit;
                 end;
               RT1[R].LeftChain := SR;
             end
           else
             begin
               if RT1[R].RightChain <> -1 then
                 begin
                   Result := false;
                   exit;
                 end;
               RT1[R].RightChain := SR;
             end;
           Left := not L;
           R := SR;
           Result := true;
           exit;
         end;
      if H = (abs(RT1[SR].FRLat + RT1[SR].FRLong) Mod CoorHashSize) then
        SR := RT1[SR].HashL
      else
        SR := RT1[SR].HashR;
    end;
  result := false;
end;

procedure TStreetObject.Init;
Var F : file;
    i, nr, nw : integer;
begin
//  NumSegments := 0;
//  Segments := nil;
  DirPrefixes := TDir.Create(Dir1 + 'Prefixes.TXT');
  DirSuffixes := TDir.Create(Dir1 + 'Suffixes.TXT');
  FeatureTypes := TDir.Create(Dir1 + 'FeatureTypes.TXT');
  DirStates := TDir.Create(Dir1 + 'States.TXT');
  Cities := nil;
  for i := 0 to CityNameHashMax-1 do
    HashCityName[i] := -1;
  NumCities := 0;
  for i := MinZip to MaxZip do
    ZipCity[i] := nil;
  SaveStates := false;
  if FileExists(Dir1 + 'States.TXT') then
    DirStates.Load;
  if not LoadCities then
    begin
      ReadAllCities;
      SaveCities;
    end;
  if SaveStates then
    begin
      DirStates.AddAbbrev(Dir1 + 'states.dir', TAB);
      DirStates.Sort;
      DirStates.Save;
    end;
  CFCCS := TDir.Create(Dir1 + 'CFCCS.TXT');
  if not fileexists(Dir1 + 'Prefixes.TXT') then
     PopulateDirs
  else
     begin
        DirPrefixes.Load;
        DirSuffixes.Load;
        FeatureTypes.Load;
        FeatureTypes.AddAbbrev(Dir1 + 'a2kapd.txt', TAB);
        FeatureTypes.AddAbbrev(Dir1 + 'features.dir', ' ');
        FeatureTypes.Save;
        CFCCS.Load;
     end;
  NullPrefix := DirPrefixes.Find('');
  NullSuffix := DirSuffixes.Find('');
  NullType := FeatureTypes.Find('');
  if not fileexists(Dir1 + 'AllStates.MAP') then
    begin
        RT1Hash := TIntHash.Create;
        RT2Hash := TIntHash.Create;
        RT4Hash := TIntHash.Create;
        RT5Hash := TIntHash.Create;
        RT6Hash := TIntHash.Create;
        CFCCSet := [];
        CFCCSet := CFCCSet + [CFCCS.Find('A11')];
        CFCCSet := CFCCSet + [CFCCS.Find('A12')];
        CFCCSet := CFCCSet + [CFCCS.Find('A13')];
        CFCCSet := CFCCSet + [CFCCS.Find('A14')];
        CFCCSet := CFCCSet + [CFCCS.Find('A15')];
        CFCCSet := CFCCSet + [CFCCS.Find('A16')];
        CFCCSet := CFCCSet + [CFCCS.Find('A17')];
        CFCCSet := CFCCSet + [CFCCS.Find('A18')];
        CFCCSet := CFCCSet + [CFCCS.Find('A21')];
        CFCCSet := CFCCSet + [CFCCS.Find('A22')];
        CFCCSet := CFCCSet + [CFCCS.Find('A23')];
        CFCCSet := CFCCSet + [CFCCS.Find('A24')];
        CFCCSet := CFCCSet + [CFCCS.Find('A25')];
        CFCCSet := CFCCSet + [CFCCS.Find('A26')];
        CFCCSet := CFCCSet + [CFCCS.Find('A27')];
        CFCCSet := CFCCSet + [CFCCS.Find('A28')];
        CFCCSet := CFCCSet + [CFCCS.Find('A31')];
        CFCCSet := CFCCSet + [CFCCS.Find('A32')];
        CFCCSet := CFCCSet + [CFCCS.Find('A33')];
        CFCCSet := CFCCSet + [CFCCS.Find('A34')];
        CFCCSet := CFCCSet + [CFCCS.Find('A35')];
        CFCCSet := CFCCSet + [CFCCS.Find('A36')];
        CFCCSet := CFCCSet + [CFCCS.Find('A37')];
        CFCCSet := CFCCSet + [CFCCS.Find('A38')];
        CFCCSet := CFCCSet + [CFCCS.Find('A41')];
        CFCCSet := CFCCSet + [CFCCS.Find('A42')];
        CFCCSet := CFCCSet + [CFCCS.Find('A43')];
        CFCCSet := CFCCSet + [CFCCS.Find('A44')];
        CFCCSet := CFCCSet + [CFCCS.Find('A45')];
        CFCCSet := CFCCSet + [CFCCS.Find('A46')];
        CFCCSet := CFCCSet + [CFCCS.Find('A47')];
        CFCCSet := CFCCSet + [CFCCS.Find('A48')];
        TotalSize := 0;
        AllProcessed := true;
        ScanDirs(Dir1, '*.*', CalcCounty, false);
        if not AllProcessed then
          ScanDirs(Dir1, '*.*', ProcessOneCounty, false);
        Setlength(DataArr, TotalSize);
        DataIndex := 0;
        ScanDirs(Dir1, '*.*', JoinCounty, false);
        AssignFile(F, Dir1 + 'AllStates.MAP');
        rewrite(F, 1);
        blockwrite(F, (@DataArr[0])^, DataIndex, Nw);
        closefile(F);
    end
  else
    begin
        Interf.SetStatus('Reading streets');
        AssignFile(F, Dir1+'AllStates.MAP');
        reset(F, 1);
        DataIndex := filesize(F);
        setlength(DataArr, DataIndex);
        blockread(F, (@DataArr[0])^, DataIndex, NR);
        closefile(F);
    end;
  Interf.SetStatus('Building street index');
  BuildIndex;
  Interf.SetStatus('Done');
end;

procedure TStreetObject.MakeStreet(Var A : TAddress; Var S : String);
Var D1, D2 : integer;
begin
   D1 := A.CommonRec.CombinedDir and (not 128);
   D2 := D1 mod 10;
   D1 := D1 div 10;
   S := DirPrefixes.Entries[D1].Name + ' ' + A.Name + ' ' + DirSuffixes.Entries[D2].Name + ' ' +
        FeatureTypes.Entries[A.CommonRec.FType].Name;
   truncateshortstr(S);
end;

function TStreetObject.Hashfun(Var A : TAddress) : integer;
Var P : integer;
begin
   Result := {(A.CommonRec.CombinedDir and (not 128)) +} 0;
   if length(A.Name) > 1 then
      Result := Result + (ord(A.Name[1]) - ORD('0')) shl 2 + (ord(A.Name[2]) - ORD('0')) shl 1
   else if length(A.Name) > 0 then
      Result := Result + (ord(A.Name[1]) - ORD('0')) shl 2;
   Result := Result mod ZipHashMax;
   if result < 0 then
     result := 1;
end;

const NumHashElem : integer = 0;
const DummyRec : integer = 0;
const TotalRec : integer = 0;
procedure TStreetObject.AddToIndex(Var A : TAddress; P : integer);
Var  E : PHashEntry;
     HF, i, j, C : integer;
begin
  if A.Zip < minZip then
    begin
//      Interf.SetStatus('A.Zip = ' + IntTostr(A.Zip) + ' p=' + inttostr(p));
      exit;
    end;
{  if pos('BAYVIEW', A.Name) <> 0 then
    P := P;}
{  if (H < 0) or (H >= ZipHashMax) then
     H := 0;}
  if (A.CommonRec.CombinedDir = (NullPrefix * 10 + NullSuffix)) and
     (A.Name = '') and (A.CommonRec.FType= NullType) then
       inc(DummyRec);
  inc(TotalRec);
  HF := HashFun(A);
  E := @Hash[A.Zip, HF];
  for i := 0 to length(E^) - 1 do
    if E^[i] = P then
      exit;
  setlength(E^, length(E^) + 1);
  E^[Length(E^)-1] := P;
  inc(NumHashElem);
  for j := 0 to length(ZipCity[A.Zip]) - 1 do
    begin
       C := ZipCity[A.Zip][j];
       if Cities[C].NumZips > 1 then
          begin
           E := @Cities[C].Hash[HF];
           for i := 0 to length(E^) - 1 do
             if E^[i] = P then
               exit;
           setlength(E^, length(E^) + 1);
           E^[Length(E^)-1] := P;
           inc(NumHashElem);
          end;
    end;
end;

function TStreetObject.Find(Var A : TAddress) : PHashEntry;
begin
   Result := @(Hash[A.Zip, HashFun(A)]);
end;

function TStreetObject.findbycity(Var A : TAddress; C : integer) : PHashEntry;
begin
   if Cities[C].NumZips > 1 then
     Result := @Cities[C].Hash[HashFun(A)]
   else
     begin
       A.Zip := Cities[C].Zip;
       Result := Find(A);
     end;
end;

procedure TStreetObject.BuildIndex;
Var A,  Next : TAddress;
    P, P0, SP, FLat, FLon : integer;
    PLat, Plon, FromL, ToL, FromR, ToR : integer;
    AlphaPrefixL : String; AlphaPrefixR : String;
    AvenueFromR, AvenueToR : integer;
    AvenueFromL, AvenueToL : integer;
    LZip, RZip : Integer;
    flag : byte;
begin
   P := 0;
   while P < DataIndex do
     begin
       P0 := P;
{       if P >= 10680649 then
         P := P;}
       ReadAddress(A, P);
{       if A.NAME = 'MIAMI LAKEWAY' then
          A.Name := 'MIAMI LAKEWAY';}
       AddToIndex(A, P0);
       while ReadNextAddress(A, Next, P) do
          begin
            AddToIndex(Next, P0);
            A := Next;
          end;
       FLat := 0;
       FLon := 0;
       while true do
         begin
           SkipVertixes(P, FLat, FLon, PLat, Plon);
           while true do
             begin
{               if NumReads = 20 then
                 NumReads := 20;}
               flag := ReadRange(P, FromL, ToL, FromR, ToR,
                                 AlphaPrefixL, AlphaPrefixR, AvenueFromR, AvenueToR,
                                 AvenueFromL, AvenueToL, LZip, RZip);
               if  LZip <> 0 then
                  begin
                    SP := P0;
                    ReadAddress(A, SP);
                    A.Zip := LZip;
                    AddToIndex(A, P0);
                    while ReadNextAddress(A, Next, SP) do
                      begin
                        AddToIndex(Next, P0);
                        A := Next;
                      end;
                  end;
               if  RZip <> 0 then
                  begin
                    SP := P0;
                    ReadAddress(A, SP);
                    A.Zip := RZip;
                    AddToIndex(A, P0);
                    while ReadNextAddress(A, Next, SP) do
                      begin
                        AddToIndex(Next, P0);
                        A := Next;
                      end;
                  end;
               if (flag and FL_End) <> 0 then
                  break;
             end;
           if (flag and FL_Last) <> 0 then
              break;
         end;
     end; // p < dataindex
end;

procedure TStreetObject.HandleCommand(ARequestInfo: TIdHTTPRequestInfo;
                            AResponseInfo: TIdHTTPResponseInfo);
Var CType : String;
begin
   AResponseInfo.ContentText := ProcessQuery(ArequestInfo.UnparsedParams, false, CType, false);
   AResponseInfo.ContentType := CType;
end;

procedure TStreetObject.ParseStreet(Var S : String; Var A : TAddress; Var AlphaPrefix : String; Var Avenue, House : integer);
Var P, P0, PS, PE, PNum, Pref, Suf, Prefix, Suffix, FT : integer;
    Num : boolean;
    SufName : String;
begin
   P := 1;
   while (P < length(S)) and ((S[P] = ' ') or (S[P] = TAB)) do
      inc(P);
   P0 := p;
   Num := false;
   Avenue := 0;
   House := 0;
   AlphaPrefix := '';
   Prefix := NullPrefix;
   Suffix := NullSuffix;
   A.CommonRec.FType := NullType;;
   while (P < length(S)) and (S[P] <> ' ') and (S[P] <> TAB) do
     begin
       if (not num) and ((S[P] >= '0') and (S[P] <= '9')) then
         begin
           if P > P0 then
              begin
                AlphaPrefix := copy(S, P0, P - P0);
                P0 := P;
              end;
           Num := true;
           PNum := P;
         end;
       if Num and (S[P] = '-') then
          begin
            Avenue := ValStr(copy(S, PNum, P - PNum));
            P0 := P + 1;
          end;
       inc(P);
     end;
   if Num then
     begin
       House := Valstr(copy(S, P0, P-P0));
       while (P < length(S)) and (S[P] = ' ') or (S[P] = TAB) do
         inc(P);
       P0 := P;
       if (House = 0) and (Avenue <> 0) then
          begin
            House := Avenue;
            Avenue := 0;
          end;
     end
   else
     begin
        AlphaPrefix := '';
        Avenue := 0;
        House := 0;
        P := P0;
     end;
   while (P < length(S)) and (S[P] <> ' ') and (S[P] <> TAB) do
     inc(P);
   if P > P0 then
     begin
       Pref := DirPrefixes.Find(copy(S, P0, P-P0));
       if Pref >= 0 then
         Prefix := Pref
       else
         P := P0;
     end;
   while (P < length(S)) and ((S[P] = ' ') or (S[P] = TAB)) do
      inc(P);
   P0 := P;
   P := length(S);
   while (P > 0) and ((S[P] = ' ') or (S[P] = TAB) ) do
      dec(P);
   PE := P;
   while (P > 0) and ((S[P] <> ' ') and (S[P] <> TAB) ) do
      dec(P);
   if P < PE then
      begin
         SufName := copy(S, P + 1, PE - P);
         Suf := DirSuffixes.Find(Sufname);
         while (P > 0) and ((S[P] = ' ') or (S[P] = TAB) ) do
            dec(P);
         if Suf >= 0 then
           Suffix := Suf
         else
           P := PE;
      end;
   PS := P;
   while (P > 0) and ((S[P] <> ' ') and (S[P] <> TAB) ) do
      dec(P);
   if P < PS then
      begin
         FT := FeatureTypes.Find(copy(S, P + 1, PS-P));
         while (P > 0) and ((S[P] = ' ') or (S[P] = TAB) ) do
            dec(P);
         if FT >= 0 then
           A.CommonRec.FType := FT
         else
           P := PS;
      end;
   if P >= P0 then
     A.Name := copy(S, P0, P-P0+1)
   else
     A.Name := '';
   A.CommonRec.CombinedDir := Prefix * 10 + Suffix;
end;

procedure  TStreetObject.FindPoint(Var V : TVertexes; left  : boolean; R : double; Var X, Y : double);
Var i : integer;
    D, DD, RR, Dist, x1, x2, y1, y2, DX, DY, ScaleX, ScaleY, Alpha : double;
begin
   if V.Numvert = 2 then
     begin
        x1 := V.Vert[0].Lon/CoorDiv;
        y1 := V.Vert[0].Lat/CoorDiv;
        x2 := V.Vert[1].Lon/CoorDiv;
        y2 := V.Vert[1].Lat/CoorDiv;
        RR := R;
     end
   else
     begin
       Dist := 0;
       for i := 0 to V.Numvert - 2 do
         begin
            x1 := V.Vert[i].Lon/CoorDiv;
            y1 := V.Vert[i].Lat/CoorDiv;
            x2 := V.Vert[i+1].Lon/CoorDiv;
            y2 := V.Vert[i+1].Lat/CoorDiv;
            Dist := Dist + sqrt((x1-x2) * (x1-x2) + (y1-y2) * (y1 - y2));
         end;
       if R = 1 then
         R := 0.99999;
       D := Dist * R;
       Dist := 0;
       for i := 0 to V.Numvert - 2 do
         begin
            x1 := V.Vert[i].Lon/CoorDiv;
            y1 := V.Vert[i].Lat/CoorDiv;
            x2 := V.Vert[i+1].Lon/CoorDiv;
            y2 := V.Vert[i+1].Lat/CoorDiv;
            DD := sqrt((x1-x2) * (x1-x2) + (y1-y2) * (y1 - y2));
            if (Dist + DD) > D then
              begin
                RR := (D - Dist) / DD;
                break;
              end;
            Dist := Dist + DD;
         end;
     end;
   Scaley := MileY/40;
   ScaleX := MileX(Y1)/40;
   if y1 = y2 then
     if x1 > x2 then
       Alpha := Pi
     else
       Alpha := 0
   else if x1 = x2 then
     if y2 > y1 then
       Alpha := Pi/2
     else
       Alpha := -Pi/2
   else
      Alpha := arctan(((y2-y1)/ScaleY)/((x2-x1)/ScaleX));
   if y2 > y1 then
     DX := - ScaleX * abs(sin(Alpha))
   else
     DX := ScaleX * abs(sin(Alpha));
   if x2 > x1 then
     DY := ScaleY * abs(cos(Alpha))
   else
     DY := - ScaleY * abs(cos(Alpha));
   if RR < 0.01 then
     RR := 0.01;
   if not Left then
     begin
       DX := -DX;
       DY := -DY;
     end;
   X := X1 + RR * (X2-X1) + DX;
   Y := Y1 + RR * (Y2-Y1) + DY;
end;

function WordLength(Var S : String; P : integer) : integer;
Var i : integer;
begin
   i := P;
   Result := 0;
   while (i > 0) and (S[i] <> ' ') do
     begin
       inc(Result);
       dec(i);
     end;
   i := P+1;
   while (i <= length(S)) and (S[i] <> ' ') do
     begin
       inc(Result);
       inc(i);
     end;
end;

function TStreetObject.SameString(Var S1, S2 : String) : boolean;
Var P1, p2 : integer;
begin
   p1 := 1;
   p2 := 1;
   while true do
     begin
        if (p1 > length(S1)) or (p2 > length(S2)) then
           begin
             result := (p1 > length(S1)) and (p2 > length(S2));
             exit;
           end;
        if S1[p1] <> S2[p2] then
           begin
             if S1[P1] = ' ' then
               inc(p1)
             else if S2[P2] = ' ' then
               inc(p2)
             else
               begin
                  result := false;
                  exit;
               end
           end
        else
           begin
             inc(p1);
             inc(p2);
           end;
     end;
end;

function TStreetObject.MatchStreet(Var A, B : TAddress; Relaxed : integer) : boolean;
Var CD, CD1, P, PB, SPrefix, SSuffix : integer;
begin
  if Relaxed > 0 then
    begin
      if Relaxed > 1 then
        result := A.CommonRec.FType = B.CommonRec.FType
      else
        result := true;
      CD := B.CommonRec.CombinedDir and (not 128);
      if CD <> (NullPrefix * 10 + NullSuffix) then
         begin
            SPrefix := CD div 10;
            SSuffix := CD mod 10;
            CD1 := A.CommonRec.CombinedDir and (not 128);
            if SPrefix <> NullPrefix then
               if (Not DirPrefixes.IsSimilar(SPrefix, CD1 div 10)) and ((CD1 div 10) <> NullPrefix) then
                  Result := false;
            if SSuffix <> NullSuffix then
               if Not DirSuffixes.IsSimilar(SSuffix, CD1 mod 10) and ((CD1 mod 10) <> NullSuffix) then
                  Result := false;
            if not Result then
               exit;
         end;
      if result then
        begin
           P := 1;
           PB := 1;
           while (P <= length(A.Name)) and (PB <= length(B.Name)) do
             begin
               if (A.Name[P] = ' ') and (P > 8) then
                 exit;
               if (A.Name[P] <> B.Name[PB]) then
                 begin
                   if (WordLength(A.Name, P) <5) or (WordLength(B.Name, PB) < 5) or (not result) then
                     begin
                        Result := false;
                        exit;
                     end
                   else
                      begin
                         Result := false;
                         if (P < length(A.Name)) and (PB < length(B.Name)) and (A.Name[P+1] = B.Name[PB + 1]) then
                            begin
                               inc(P);
                               inc(PB);
                            end
                         else if (P < length(A.Name)) and (A.Name[P+1] = B.Name[PB]) then
                            inc(P)
                         else if (PB < length(B.Name)) and (A.Name[P] = B.Name[PB + 1]) then
                            inc(PB);
                      end;
                 end;
               inc(P);
               inc(PB);
             end;
           result := ((length(A.Name) = length(B.Name)) and result) or ( ((abs(length(A.Name) - length(B.Name)) <= 1) or (P > 8)) and (length(A.Name) > 4) and (length(B.Name) > 4));
        end
    end
  else
    result := ((A.CommonRec.CombinedDir and (not 128)) = (B.CommonRec.CombinedDir and (not 128))) and
            (A.CommonRec.FType = B.CommonRec.FType) and
            SameString(A.Name, B.Name);
end;

function between(i, j, k : integer) : boolean;
begin
   if (j = 0) then
     result := i = k
   else if k = 0 then
     result := i = j
   else if j > k then
     result := (i <= j) and (i >= k)
   else
     result := (i <= k) and (i >= j)
end;

function TStreetObject.FindHouse(Var SA, FoundA : TAddress; Var AlphaPrefix : String; Avenue, House : integer;
                      E : PHashEntry; Var X, Y : double; Relaxed : integer; Var Approx : boolean; Var Debug : TDebug) : boolean;
Var i, PVert, MVert, MLat, Mlon, MinDist, TotalLeft, TotalRight, STL, STR, Offset,
    DL, DR, MPLat, MPLOn : integer;
    A, Next : TAddress;
    P, P0, SP, FLat, FLon, Plat, Plon, PrevLat, PrevLon, PPLat, PPLon : integer;
    FromL, ToL, FromR, ToR : integer;
    AlphaPrefixL : String; AlphaPrefixR : String;
    AvenueFromR, AvenueToR : integer;
    AvenueFromL, AvenueToL : integer;
    LZip, RZip, Z : Integer;
    flag : byte;
    streetmatch : boolean;
    V : TVertexes;
    foundL, foundR, MLeft : boolean;
    R : double;

procedure CheckDist(L, R : integer);
begin
   if L = 0 then
     exit;
   if abs(house-L) < MinDist then
      begin
         MinDist := abs(house-L);
         MLat := PLat;
         MLon := PLon;
         MVert := PVert;
         MPLat := PPLat;
         MPLon := PPLon;
         if Odd(House) then
           if Odd(L) then
              MLeft := true
           else
              MLeft := false
         else if ODD(L) then
           MLeft := false
         else
           MLeft := true;
         if Debug.Debug then
            AddTrace(Debug, 'new best range : ' + inttostr(L) + '-' + inttostr(R));
      end;
   if abs(house-R) < MinDist then
      begin
         MinDist := abs(house-R);
         MVert := PVert;
         MLat := PLat;
         MLon := PLon;
         MPLat := PPLat;
         MPLon := PPLon;
         if Odd(House) then
           if Odd(L) then
              MLeft := true
           else
              MLeft := false
         else if ODD(L) then
           MLeft := false
         else
           MLeft := true;
         if Debug.Debug then
            AddTrace(Debug, 'new best range : ' + inttostr(L) + '-' + inttostr(R));
      end;
end;

begin
   X := 0;
   MinDist := 100000000;
   MVert := 0;
   for i := 0 to length(E^) - 1 do
     begin
       P := E^[i];
       P0 := P;
       streetmatch := false;
       ReadAddress(A, P);
       if MatchStreet(A, SA, relaxed) then
          begin
            streetmatch := true;
            if debug.debug then
              MatchStreet(A, SA, relaxed);
            if Debug.Debug then AddTrace(Debug, 'Matching street ' + AddressToStr(A));
            FoundA := A;
          end;
        while ReadNextAddress(A, Next, P) do
          begin
           if relaxed >= 0 then
            if (not streetmatch) and MatchStreet(Next, SA, relaxed) then
              begin
                streetmatch := true;
                if Debug.Debug then
                  MatchStreet(Next, SA, relaxed);
                FoundA := Next;
                if Debug.Debug then AddTrace(Debug,'Matching street ' + AddressToStr(Next));
              end;
            if not ReadNextAddress(Next, A, P) then
               break;
            if relaxed >= 0 then
             if MatchStreet(A, SA, relaxed) then
              begin
                streetmatch := true;
                if Debug.Debug then
                  MatchStreet(A, SA, relaxed);
                FoundA := A;
                if Debug.Debug then AddTrace(Debug, 'Matching street ' + AddressToStr(A));
              end;
          end;
       if StreetMatch then
         begin
           FLat := 0;
           FLon := 0;
           TotalLeft := 0;
           TotalRight := 0;
           if (House = 0) or (Relaxed > 1) then
              begin
                V.Numvert := 0;
                PVert := P;
                ReadVertixes(V, PVert, FLat, FLon, PrevLat, PrevLon);
                FindPoint(V, true, 0.5, X, Y);
                FLat := 0;
                FLon := 0;
                Approx := true;
                Result := true;
                if House = 0 then
                  begin
                    if Debug.Debug then AddTrace(Debug, 'No house number. Using the first street match');
                    exit;
                  end;
              end;
           while true do
             begin
               PVert := P;
               PLat := FLat;
               PLon := FLon;
               PPLat := PrevLat;
               PPLon := PrevLon;
               SkipVertixes(P, FLat, FLon, PrevLat, PrevLon);
               while true do
                 begin
    {               if NumReads = 69 then
                     NumReads := 69;}
                   flag := ReadRange(P, FromL, ToL, FromR, ToR,
                                     AlphaPrefixL, AlphaPrefixR, AvenueFromR, AvenueToR,
                                     AvenueFromL, AvenueToL, LZip, RZip);
                   STL := TotalLeft;
                   STR := TOtalRight;
                   inc(TotalLeft, abs(ToL-FromL));
                   inc(TotalRight, abs(ToR-FromR));
                   CheckDist(FromL, ToL);
                   CheckDist(FromR, ToR);
                   if odd(House) then
                      begin
                        foundL := odd(FromL) and between(House, ToL, FromL) and (AlphaPrefixL = AlphaPrefix)
                                      and Between(Avenue, AvenueFromL, AvenueToL);
                        foundR := odd(FromR) and between(House, ToR, FromR) and (AlphaPrefixR = AlphaPrefix)
                                     and Between(Avenue, AvenueFromR, AvenueToR);
                       if Debug.Debug then
                         if FounDL then
                             AddTrace(Debug, 'found range: ' + inttostr(FromL) + '-' + inttostr(ToL))
                         else if FoundR then
                             AddTrace(Debug, 'found range: ' + inttostr(FromR) + '-' + inttostr(ToR));
                      end
                   else
                      begin
                        foundL := (not odd(FromL))and between(House, ToL, FromL) and (AlphaPrefixL = AlphaPrefix)
                                      and Between(Avenue, AvenueFromL, AvenueToL);
                        foundR := (not odd(FromR))and between(House, ToR, FromR) and (AlphaPrefixR = AlphaPrefix)
                                      and Between(Avenue, AvenueFromR, AvenueToR);
                       if Debug.Debug then
                         if FounDL then
                             AddTrace(Debug, 'found range: ' + inttostr(FromL) + '-' + inttostr(ToL))
                         else if FoundR then
                             AddTrace(Debug, 'found range: ' + inttostr(FromR) + '-' + inttostr(ToR));
                      end;
                   if foundL or foundR then
                     begin
                       DL := abs(House - FromL);
                       DR := abs(House - FromR);
                       while (flag and FL_End) = 0 do
                             begin
                               flag := ReadRange(P, FromL, ToL, FromR, ToR,
                                         AlphaPrefixL, AlphaPrefixR, AvenueFromR, AvenueToR,
                                         AvenueFromL, AvenueToL, LZip, RZip);
                               inc(TotalLeft, abs(ToL-FromL));
                               inc(TotalRight, abs(ToR-FromR));
                             end;
                       V.NumVert := 0;
                       ReadVertixes(V, PVert, PLat, PLon, PPLat, PPLon);
                       if foundL then
                          begin
                             R := STL/TotalLeft + DL/TotalLeft;
                          end;
                       if foundR then
                          begin
                            R := STR/TotalRight + DR/TotalRight;
                          end;
                       FindPoint(V, FoundL, R, X, Y);
                       Result := true;
                       Approx := false;
                       exit;
                     end;
                   if (flag and FL_End) <> 0 then
                      break;
                 end;
               if (flag and FL_Last) <> 0 then
                  break;
             end;
         end; // if streetmatch
     end; // for i
   Result := X <> 0;
   if (MVert <> 0) and (Relaxed > 1) then
     begin
       Approx := true;
       Result := true;
       V.NumVert := 0;
       ReadVertixes(V, MVert, MLat, MLon, MPLat, MPLon);
       FindPoint(V, MLeft, 0.5, X, Y);
       if Debug.Debug then
          AddTrace(Debug, 'Applying the best approximate range');
     end;
end;


function ValZip(Var S : String) : integer;
Var  P, PB : integer;
begin
  P := 1;
  Result := 0;
  while P <= length(S) do
    begin
       if (S[P] <= '9') and (S[P] >= '0') then
          begin
            PB := P;
            while  (P <= length(S)) and (S[P] <= '9') and (S[P] >= '0') do
              inc(P);
            if (P = length(S)) and (S[P] >= '0') and (S[P] <= '9') then
              inc(P);
            Result := valstr(copy(S, PB, P - PB));
            exit;
          end;
       inc(P);
    end;
end;

function TStreetObject.AddressToStr(Var A : TAddress) : String;
begin
  Result := 'Prefix: ' + DirPrefixes.GetName((A.CommonRec.CombinedDir and (not 128)) div 10) + ' '+
            'Suffix: ' + DirSuffixes.GetName((A.CommonRec.CombinedDir and (not 128)) Mod 10) + ' ' +
            'FeatureType: ' + FeatureTypes.GetName(A.CommonRec.FType) + ' ' +
            'Street: ' + A.Name;
end;

function TStreetObject.MatchZipCity(Z, C : integer) : boolean;
Var i : integer;
begin
   for i := 0 to length(ZipCity[Z]) -1 do
     if ZipCity[Z][i] = C then
       begin
          result := true;
          exit;
       end;
   result := false;
end;


procedure  SplitCityStateZip(Var City : String; Var C, IState, Z : integer);
Var p,pp, pz, zz : integer;
    S : String;
function CheckState(ST : String) : boolean;
begin
   p := pos(ST, City);
   if p <> 0 then
     begin
       IState := DirStates.Find(ST);
       City := copy(City, 1, p - 2);
       PZ := p + length(ST)+1;
       S := copy(City, PZ, length(City) - PZ + 1);
       ZZ := ValZip(S);
       if (ZZ >= Minzip) and (ZZ <= MaxZip) then
         Z := ZZ;
       result := true;
     end;
   result := false;
end;

begin
   P := length(City);
   pp := P;
   while P > 0 do
     begin
       if City[p] = ' ' then
         begin
           IState := DirStates.Find(copy(City, p + 1, pp - p));
           if IState >= 0 then
             begin
               S := copy(City, pp + 2, length(City) - pp-1);
               ZZ := valzip(S);
               if (ZZ >= Minzip) and (ZZ <= MaxZip) then
                  Z := ZZ;
               City := Copy(City, 1, p - 1);
               exit;
             end;
           pp := p - 1;
         end;
       dec(p);
     end;
   if checkstate('DISTRICT OF COLUMBIA') then exit;
   if checkstate('NEW HAMPSHIRE')  then exit;
   if checkstate('NEW JERSEY')  then exit;
   if checkstate('NEW MEXICO')  then exit;
   if checkstate('NEW YORK')  then exit;
   if checkstate('NORTH CAROLINA')  then exit;
   if checkstate('NORTH DAKOTA')  then exit;
   if checkstate('RHODE ISLAND')  then exit;
   if checkstate('SOUTH CAROLINA')  then exit;
   if checkstate('SOUTH DAKOTA')  then exit;
   if checkstate('WEST VIRGINIA')  then exit;
   if Z = 0 then
     begin
       ZZ := ValZip(City);
       if (ZZ >= Minzip) and (ZZ <= MaxZip) then
          Z := ZZ;
     end;
end;

function  TStreetObject.FindHouseByZip(street, zip, City, State : String;
           Var X, Y : double; Var Approx : integer; Var Debug : TDebug; Var Error : String) : boolean;
Var Z, C, k, Avenue, P, House, IState : integer;
    A, FA : TAddress;
    E : PHashEntry;
    AlphaPrefix : String;
    SS, LW : String;
    App, OK, R : boolean;
begin
//   Interf.SetStatus('Street: ' + Street + ' Zip: ' + Zip);
   Error := '';
   X := 0;
   y := 0;
   Result := false;
   try
   Standartize(Street);
   replacewords(Street);
   if Debug.Debug then AddTrace(Debug,'Standartized street ' + Street);
   ParseStreet(Street, A, AlphaPrefix, Avenue, House);
   if Debug.Debug then AddTrace(Debug,AddressToStr(A));
   Standartize(Zip);
   if Debug.Debug then AddTrace(Debug,'Zip: ' + Zip);
   Z := ValZip(zip);
   if (Z < MinZip) or (Z > MaxZip) then
     Z := 0;
   C := -1;
   Standartize(City);
   Standartize(State);
   if State <> '' then
     IState := DirStates.Find(State)
   else
     IState := -1;
   if City <> '' then
     begin
       if IState = -1 then
         SplitCityStateZip(City, C, IState, Z);
       C := FindCity(City, IState);
     end;
   if (Street = '') then
      begin
         if (Z >= MinZip) and (Z <= MaxZip) and (iZipObject.ZipCodes[Z].CX <> 0) then
           begin
             Approx := A_ZipCenter;
             X := iZipObject.ZipCodes[Z].CX;
             Y := iZipObject.ZipCodes[Z].CY;
           end
         else if C >= 0 then
           begin
             Approx := A_CityCenter;
             X :=  Cities[C].CX;
             Y :=  Cities[C].CY;
           end
         else
           begin
             X := 0;
             Y := 0;
             Approx := A_NotFound;
             Result := false;
           end;
         exit;
      end;
   if ((Z < MinZip) or (Z > MaxZip)) and (C = 0) then
     begin
       X := 0;
       Y := 0;
       Approx := A_NotFound;
       Result := false;
       exit;
     end;
   if ((z >= MinZip) and (z <= MaxZip)) or (C >= 0) then
      begin
        A.ZIp := Z;
        if Z >= MinZip then
          E := find(A)
        else
          E := findbyCity(A, C);
        if FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, -1, App, Debug) then
          begin
            if App then
               Approx := A_Approx
            else
               Approx := A_Exact;
            result := true;
            exit;
          end;
        if FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, 0, App, Debug) then
          begin
            if App then
               Approx := A_Approx
            else
               Approx := A_Exact;
            result := true;
            exit;
          end;
        if FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, 1, App, Debug) then
          begin
            if App then
               Approx := A_Approx
            else
               Approx := A_Exact;
            result := true;
            exit;
          end;
{       if A.CommonRec.FType = NullType then
         begin
            A.CommonRec.FType := FeatureTypes.Find('ST');
            if Z >= MinZip then
              E := find(A)
            else
              E := findbyCity(A, C);
            if FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, false, App, Debug) then
              begin
                if App then
                   Approx := A_Approx
                else
                   Approx := A_Exact;
                result := true;
                exit;
              end;
            A.CommonRec.FType := FeatureTypes.Find('AVE');
            if Z >= MinZip then
              E := find(A)
            else
              E := findbyCity(A, C);
            if FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, false, App, Debug) then
              begin
                if App then
                   Approx := A_Approx
                else
                   Approx := A_Exact;
                result := true;
                exit;
              end;
            A.CommonRec.FType := NullType;
         end;}
       if (Z >= MinZip) and (C >= 0) and (not MatchZipCity(Z, C)) then
          begin
          E := findbyCity(A, C);
          if FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, 0, App, Debug) then
            begin
              if App then
                 Approx := A_Approx
              else
                 Approx := A_Exact;
              result := true;
              exit;
            end;
          end;
       if Debug.Debug then AddTrace(Debug,'exact street match not found');
       if (not Result) and (Z >= MinZip) then
       for k := 0 to length(ZipCity[Z]) - 1 do
         if Cities[ZipCity[Z][k]].NumZips > 1 then
            begin
               E := findbycity(A, ZipCity[z][k]);
               if Debug.Debug then AddTrace(Debug,'Looking in the city: ' + Cities[ZipCity[Z][k]].Name);
               result := FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, 0, App, Debug);
               if App then
                  Approx := A_Approx
               else
                  Approx := A_Exact;
               if Debug.Debug then
                 if Result then
                    Addtrace(Debug,'Found matching street')
                 else
                    Addtrace(Debug,'matching street not found');
               if result then
                  exit;
            end;
       if not Result then
          begin
             R := replaceword(Street, 'ONE', '1') or replaceword(Street, 'TWO', '2')
                  or replaceword(Street, 'THREE', '3') or replaceword(Street, 'FOUR', '4')
                  or replaceword(Street, 'FIVE', '5') or replaceword(Street, 'SIX', '6')
                  or replaceword(Street, 'SEVEN', '7') or replaceword(Street, 'EIGHT', '8')
                  or replaceword(Street, 'NINE', '9') or replaceword(Street, 'TEN', '10');
             if not R then
                R := replaceword(Street, '1', 'ONE') or replaceword(Street, '2', 'TWO')
                  or replaceword(Street, '3', 'THREE') or replaceword(Street, '4', 'FOUR')
                  or replaceword(Street, '5', 'FIVE') or replaceword(Street, '6', 'SIX')
                  or replaceword(Street, '7', 'SEVEN') or replaceword(Street, '8', 'EIGHT') 
                  or replaceword(Street, '9', 'NINE') or replaceword(Street, '10', 'TEN');
             ParseStreet(Street, A, AlphaPrefix, Avenue, House);
             if Z >= MinZip then
               E := find(A)
             else
               E := FindByCity(A, C);
             if Avenue <> 0 then
               begin
                 House := Avenue;
                 Avenue := 0;
                 R := true;
               end;
             if Debug.Debug then AddTrace(Debug,'Trying to find an approximate match in he zip code');
             result := FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, 2, App, Debug);
             if Debug.Debug then
                if Result then
                   Addtrace(Debug,'Found matching street')
                else
                   Addtrace(Debug,'matching street not found');
             if Result then
               begin
                 Approx := A_Approx;
                 exit;
               end;
             if A.CommonRec.FType = NullType then
               begin
                  A.CommonRec.FType := FeatureTypes.Find('ST');
                  if Z >= MinZip then
                     E := find(A)
                  else
                     E := FindByCity(A, C);
                  if FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, 2, App, Debug) then
                    begin
                      if App then
                         Approx := A_Approx
                      else
                         Approx := A_Exact;
                      result := true;
                      exit;
                    end;
                  A.CommonRec.FType := NullType;
               end;
             if (Z >= MinZip) and (C >= 0) and (not MatchZipCity(Z, C)) then
                begin
                  E := findbyCity(A, C);
                  if FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, 2, App, Debug) then
                    begin
                      Approx := A_Approx;
                      result := true;
                      exit;
                    end;
                end;
          end;
       if (not Result) and (Z >= MinZip) then
       for k := 0 to length(ZipCity[Z]) - 1 do
         if Cities[ZipCity[Z][k]].NumZips > 1 then
            begin
               E := findbycity(A, ZipCity[z][k]);
               if Debug.Debug then AddTrace(Debug,'Looking approx match in the city: ' + Cities[ZipCity[Z][k]].Name);
               result := FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, 2, App, debug);
               if Debug.Debug then
                 if Result then
                    Addtrace(Debug,'Found matching street')
                 else
                    Addtrace(Debug,'matching street not found');
               if result then
                 begin
                  Approx := A_Approx;
                  exit;
                 end;
            end;
       if not Result then
           SS := Street;
       while (not Result) and (wordcount(Street) >= 3) do
           if deletelastword(Street) then
               begin
                   ParseStreet(Street, A, AlphaPrefix, Avenue, House);
                   if (length(A.Name)  = 0) and (A.CommonRec.FType = NUllType) then
                     break;
                   if Debug.Debug then AddTrace(Debug,'Looking the address: ' + AddressToStr(A));
                   Approx := A_Approx;
                   if Z >= MinZIp then
                     begin
                       E := find(A);
                       result := FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, 0, App, Debug);
                       if result then
                          exit;
                     end;
                   if C >= 0 then
                     begin
                       E := FindByCity(A, C);
                       result := FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, 0, App, Debug);
                       if result then
                          exit;
                     end;
                   if Z >= MinZip then
                     begin
                        E := find(A);
                        result := FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, 0, App, Debug);
                        if Result then
                          exit;
                     end;
                   if C >= 0 then
                     begin
                       E := FindByCity(A, C);
                       result := FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, 2, App, Debug);
                       if result then
                          exit;
                     end;
                   if (Z >= MinZip) and (C >= 0) and (not MatchZipCity(Z, C)) then
                      begin
                        E := findbyCity(A, C);
                        if FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, 0, App, Debug) then
                          begin
                            Approx := A_Approx;
                            result := true;
                            exit;
                          end;
                      end;
               end;
        if not Result then
          begin
            Street := SS;
            OK := false;
            while deletelastwordExt(Street, LW) do
              begin
                if FeatureTypes.Find(LW) >= 0 then
                  begin
                    OK := true;
                    Street := Street + ' ' + LW;
                    break;
                  end;
              end;
            if not OK then
              Street := SS;
            while (not Result) and (wordcount(Street) >= 3) do
               if deletefirstword(Street) then
                   begin
                       ParseStreet(Street, A, AlphaPrefix, Avenue, House);
                       if length(A.Name)  = 0 then
                         break;
                       if Debug.Debug then AddTrace(Debug,'Looking the address: ' + AddressToStr(A));
                       if Z >= MinZip then
                         E := find(A)
                       else
                         E := FindByCity(A, C);
                       if FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, 0, App, Debug) then
                         result := true
                       else
                         result := FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, 2, App, Debug);
                       Approx := A_Approx;
                       if result then
                         exit;
                       if (Z >= Minzip) and (C >= 0) and (not MatchZipCity(Z, C)) then
                          begin
                            E := findbyCity(A, C);
                            if FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, 0, App, Debug) then
                              begin
                                Approx := A_Approx;
                                result := true;
                                exit;
                              end;
                          end;
                   end;
          end;
        if not Result then
          begin
             if (Z >= MinZip) and (Z <= MaxZip) and (iZipObject.ZipCodes[Z].CX <> 0) then
               begin
                 Approx := A_ZipCenter;
                 X := iZipObject.ZipCodes[Z].CX;
                 Y := iZipObject.ZipCodes[Z].CY;
               end
             else if C >= 0 then
               begin
                 Approx := A_CityCenter;
                 X :=  Cities[C].CX;
                 Y :=  Cities[C].CY;
               end
             else
               begin
                 X := 0;
                 Y := 0;
                 Approx := A_NotFound;
                 Result := false;
               end;
          end;
      end
   else
     begin
        X := 0;
        Y := 0;
        Approx := A_NotFound;
        result := false;
     end;
   finally
//     Interf.SetStatus('X: ' + CoorStr(X) + ' Y: ' + CoorStr(Y));
   end;
end;


function  TStreetObject.ProcessQuery(Request : String; AppendEOL : boolean; Var ContentType : String; AppendCommand : boolean) : String;
Var P : integer;
    Street, Zip : String;
    S : String;
    city, VarName, V, State, Error : String;
    D, x, y : double;
    Approx : integer;
    Debug : TDebug;
begin
   try
       S := TIdURI.URLDecode(Request);
       p := 1;
       Zip := '';
       street := '';
       city := '';
       debug.debug := false;
       while p < length(S) do
         begin
           ParseDoubleVar(S, VarName, D, V, p);
           if VarName = 'zip' then
             Zip := V
           else if VarName = 'street' then
             street := UpStr(V)
           else if VarName = 'city' then
             city := V
           else if VarName = 'state' then
             state := V
           else if VarName = 'debug' then
             begin
               debug.debug := true;
               debug.S := '';
             end
         end;
      if debug.debug then
       if FindHouseByZip(street, zip, city, state, X, Y, Approx, debug, error) then
          begin
           if Approx > 1 then
             Result := '<p><a href="http://www.mapblast.com/myblast/map.mb?CMD=LFILL&CT='
                + CoorStr1(Y) + '%3A' +CoorStr1(X)+'%3A20000">Approximate LAT='+  CoorStr1(Y) +' Lon='+CoorStr1(X) + '</a></p>'
           else
             Result := '<p><a href="http://www.mapblast.com/myblast/map.mb?CMD=LFILL&CT='
                + CoorStr1(Y) + '%3A' +CoorStr1(X)+'%3A20000"> LAT='+  CoorStr1(Y) +' Lon='+CoorStr1(X) + '</a></p>';
           Result := Result + '<p>' + Debug.S + '</p>';
           ContentType := 'text/html';
          end
      else
        Result := 'Address not found' + Debug.S
      else
        begin
            FindHouseByZip(street, zip, city, state, X, Y, Approx, debug, error);
            if error <> '' then
               Result := 'ERROR: ' + error
            else
               Result :=  'X=' + CoorStr1(X) + TAB + 'Y=' + CoorStr(Y) + #10 +
                          'Level=' + inttostr(Approx) + TAB + Levels[Approx];
            if Approx > 2 then
               AppendFile(Dir1 + 'AddrError.htm', '<p><a href="http://n158.cs.fiu.edu/street?debug=1&city=' +
               city+ '&state=' + state + '&zip=' + ZIP + '&street=' + street+'">' + FormatDateTime('yy/mm/dd hh:nn:ss> ', Now)+
               Request + '</a></p>');
            ContentType := 'text/plain';
//           Result := 'X=' + CoorStr1(X) + TAB + 'Y=' + CoorStr(Y) + #10 +
        end;
   except on E: exception do
      begin
//         Interf.EnableLog;
         Interf.AddLog('Request: ' + Request + ' Exception: ' + E.Message);
         AppendFile(GetHardRootDir1+'Error.LOG', GetTimeText+'street Request: ' + Request + ' Exception: ' + E.Message);
         Result := 'END. Internal Error. Please report to shaposhn@cs.fiu.edu';
      end;
   end;
end;

destructor TStreetObject.Free;
begin
  DirPrefixes.Free;
  DirSuffixes.Free;
  FeatureTypes.Free;
  DirStates.Free;
  CFCCS.Free;
end;

procedure TIntHash.Clear;
Var i : integer;
begin
   for i := 0 to length(Hash) - 1 do
     begin
       Hash[i] := -1;
       HashTail[i] := nil;
     end;
end;

procedure TIntHash.Append(Var HashNext : integer; HashVal : integer; Index : integer);
Var H : integer;
begin
   H := HashVal mod length(Hash);
   HashNext := -1;
   if hashtail[h] <> nil then
      HashTail[H]^ := Index;
   hashtail[h] := @Hashnext;
   if Hash[H] = -1 then
      Hash[H] := Index;
end;

function TIntHash.Find(HashVal : integer) : integer;
Var H : integer;
begin
   H := HashVal mod length(Hash);
   result := Hash[H];
end;

procedure TStreetObject.ReadAllCities;
Var S : String;
    SCity, SState, SZip, Acceptable, Correct : String;
    IState, P, PP, Zip, C : integer;
    Line : String;
    Start : boolean;
begin
  readstringfile(Dir1 + 'allcity.txt', S);
  P := 1;
  Start := true;
  while P < length(S) do
    begin
      ScanLine1(S, P, Line);
      if Start then
        begin
         if Line = '==' then
           Start := false;
        end
      else
        begin
           PP := 1;
           ExtractField(Line, SZip, PP);
           Zip := ValStr(SZip);
           if Zip <> 0 then
              begin
                repeat
                    ExtractField(Line, SCity, PP);
                    ExtractField(Line, SState, PP);
                    ExtractField(Line, Acceptable, PP);
                    ExtractField(Line, Correct, PP);
                    if SCity <> '' then
                      begin
                        IState := DirStates.Find(SState);
                        if IState < 0 then
                          begin
                            SaveStates := true;
                            DirStates.Add(SState);
                            IState := DirStates.Find(SState);
                          end;
                        C := FindCity(SCity, iState);
                        if C < 0 then
                           C := InsertCity(SCity, iState);
                        if Cities[C].NumZips = 0 then
                          begin
                            Cities[C].Zip := Zip;
                            if not ICityObject.FindCityCoor(SCity, SState, Cities[C].CX, Cities[C].CY) then
                              begin
                                Cities[C].CX := izipObject.ZipCodes[Zip].CX;
                                Cities[C].CY := izipObject.ZipCodes[Zip].CY;
                              end;
                          end;
                        inc(Cities[C].NumZips);
                        setlength(ZipCity[Zip], length(ZipCity[Zip]) + 1);
                        ZipCity[Zip][length(ZipCity[Zip])-1] := C;
                      end;
                until SCity = '';
              end;
        end;
    end;
end;

function TStreetObject.HashCity(Var SCity : String; IState : integer) : integer;
Var i : integer;
begin
   Result := 0;
   for i := 1 to length(Scity) do
      Result := Result + (ord(Scity[i]) - ord('A')) shl (4*((i-1) mod 4));
   if Result < 0 then
     Result := 0;
   Result := (Result + length(SCity)) mod CityNameHashMax;
end;

function TStreetObject.InsertCity(Var SCity: String; IState : integer) : integer;
Var C, i : integer;
begin
   C := HashCity(SCity, IState);
   inc(NumCities);
   if NumCities > length(Cities) then
      Setlength(Cities, round(NumCities*1.2) + 10);
   Cities[NumCities-1].Name := SCity;
   Cities[NumCities-1].State := IState;
   Cities[NumCities-1].NumZips := 0;
   for i := 0 to ZipHashMax - 1 do
     Cities[NumCities-1].Hash[i] := nil;
   Cities[NumCities-1].HashCityNameNext := HashCityName[C];
   HashCityName[C] := NumCities - 1;
   Result := NumCities - 1;
end;

function TStreetObject.FindCity(Var SCity : String; IState : integer) : integer;
Var BestC, ZZ, C : integer;

begin
   C := HashCity(SCity, IState);
   C := HashCityName[C];
   ZZ := 0;
   BestC := -1;
   while C >= 0 do
      begin
        if (Cities[C].Name = SCity) and ((IState = -1) or (Cities[C].State = IState)) then
           begin
             if IState = -1 then
                begin
                   if Cities[C].NumZips > ZZ then
                      begin
                        ZZ := Cities[C].NumZips;
                        BestC := C;
                      end;
                end
             else
                begin
                  result := C;
                  exit;
                end;
           end;
        C := Cities[C].HashCityNameNext;
      end;
   Result := BestC;
end;

procedure TStreetObject.SortZipCity;
Var Z : integer;
    E : PHashEntry;
  procedure QuickSort(L, R: Integer);
  var
    I, J : Integer;
    T, X : Integer;
  begin
    I := L;
    J := R;
    X := E^[(L + R) div 2];
    repeat
      while Cities[E^[i]].NumZips < Cities[X].NumZips do Inc(I);
      while Cities[X].NumZips < Cities[E^[j]].NumZips do Dec(J);
      if I <= J then
      begin
        T := E^[I];
        E^[I] := E^[J];
        E^[J] := T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J);
    if I < R then QuickSort(I, R);
  end;
begin
    for z := MinZip to MaxZip do
      begin
        E := @ZipCity[z];
        if length(E^) > 1 then
          Quicksort(0, length(E^) - 1);
      end;
end;

procedure TStreetObject.SaveCities;
Var F : TFileIO;
    i, j : integer;
begin
   SortZipCity;
   F := TFileIO.Create(Dir1 + 'Cities.dat', true, false);
   F.WriteInt(NumCities);
   for i := 0 to NumCities - 1 do
     begin
        F.WriteLongString(Cities[i].Name);
        F.WriteInt(Cities[i].State);
        F.WriteInt(Cities[i].NumZips);
        F.WriteDouble(Cities[i].CX);
        F.WriteDouble(Cities[i].CY);
        F.WriteInt(Cities[i].Zip);
     end;
   for i := MinZip to MaxZip do
     begin
       F.WriteInt(length(ZipCity[i]));
       for j := 0 to length(ZipCity[i]) - 1 do
         F.WriteInt(ZipCity[i][j]);
     end;
   F.Free;
end;

function TStreetObject.LoadCities : boolean;
Var F : TFileIO;
    i, j, C : integer;
    S : String;
begin
   if not FileExists(Dir1 + 'Cities.dat') then
     begin
       Result := false;
       exit;
     end;
   Result := true;
   F := TFileIO.Create(Dir1 + 'Cities.dat', false, true);
   NumCities := F.ReadInt;
   Setlength(Cities, NumCities);
   for i := 0 to NumCities - 1 do
     begin
        F.ReadString(S);
        Cities[i].Name := S;
        Cities[i].State := F.ReadInt;
        Cities[i].NumZips := F.ReadInt;
        Cities[i].CX := F.ReadDouble;
        Cities[i].CY := F.ReadDouble;
        Cities[i].Zip := F.ReadInt;
        C := HashCity(S, Cities[i].State);
        for j := 0 to ZipHashMax - 1 do
           Cities[i].Hash[j] := nil;
        Cities[i].HashCityNameNext := HashCityName[C];
        HashCityName[C] := i;
     end;
   for i := MinZip to MaxZip do
     begin
       SetLength(ZipCity[i], F.ReadInt);
       for j := 0 to length(ZipCity[i]) - 1 do
         ZipCity[i][j] := F.ReadInt;
     end;
   F.Free;
end;


end.

