{*** street search implementation by A. Shaposhnikov 2002 ***}

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
uses webobject, IdCustomHTTPServer, dbtables, InovaGIS_TLB, Directory, stree, shapeobject, Windows,RegExpr, Classes;

const A_Prop = 0;  //JAB New level requested by Dr Rishe when there is an actual property 2010 02
const A_Exact = 1;
const A_Approx = 2;
const A_ZipCenter = 3;
const A_CityCenter = 4;
const A_NotFound = 5;
const Levels : array[0..5] of string = ('Exact Parcel match','Exact match', 'Approx match', 'Zip center', 'City Center', 'Not Found'); //JAB new level 0: rooftop
Var StateCodes : array[0..100] of String;

const LeftRightFactor : double = 66;
//const OffsetFactor : double = 0.14;
const D0Factor : double = 19;

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

var DirPrefixes : TDir;
var DirSuffixes : TDir;
Var FeatureTypes : TDir;
Var DirStates : TDir;
Var CFCCS : TDir;

Var DirNavTypesBefore, DirNavTypesAfter, DirNavTypes, DirNavForms : TDir;

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

type TStreetData = record
     Street : string;
     A : TAddress;
     ICity, IState, Zip : integer;
     AlphaPrefix : string;
     Avenue, House : integer;
end;

type pinteger = ^integer;
type TIntHash = class
       Hash : array[0..1024*1024-1] of integer;
       HashTail : array[0..1024*1024-1] of pinteger;
       procedure Clear;
       procedure Append(Var HashNext : integer; HashVal : integer; Index : integer);
       function Find(HashVal : integer) : integer;
end;


type TRange = record
        Name : String;
        AlphaPrefixL, AlphaPrefixR :String;
        AvenueFromL, AvenueToL : integer;
        AvenueFromR, AvenueToR : integer;
        FromL, TOL : integer;
        FromR, TOR : integer;
        ZipL, ZipR : integer;
end;

type TPoint = record
    X : integer;
    Y : integer;
end;

type TAltName = record
    Name : String;
    FullName : String;
    CombinedDir : byte;
    FType : byte;
end;

type TRT1Store = record
        TLID : integer;
        CombinedDir : byte;
        Name : String;
        AltNames : array of TAltName;
        AltRanges : array of TRange;
        Points : array of TPoint;
        FullName, RRange : String;
        FType : byte;
        CFCC : byte;
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
const MinZip = 1;
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

type TByteArray = array of byte;
     PByteArray = ^TByteArray;
procedure Addtrace(Var Debug : TDebug; T : String);

type TInverseRec = record
     X, Y : single;
     P0 : integer;
end;

type XYZ = record
    X, Y : single;
end;

type TStreetRec = record
   A: TAddress;
   House,
   RangeFrom,
   RangeTo,
   Zip : integer;
   Intersection : XYZ;
   StreetDir : double;
   MinD : Single;
end;

type TStreetRecs = array of TStreetRec;


type TStreetObject = class(TWebObject)
  public
//    Segments : array of TSegment;
//    NumSegments : integer;
//    Features : array of TFeatureID;
//    NumFeatures : integer;
    NumInverseRecs : integer;
    InverseRecs : array of TInverseRec;
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
    DataArr : PByteArray;
    NavArr : array of byte;
    TigerArr : array of byte;
    DataArrLen : integer;
    DataIndex, TotalSize : integer;
    CFCCSet : set of byte;
    Loaded, AllProcessed, NewNav : boolean;
    Map : iVectorial;
    ShpName : String;
    MaxDX, MaxDY : single;
    Stree : TStree;
    MinX, MaxX, MinY, MaxY : single;
    MaxNavteq : integer;
    Header : String;
    street_nationw : string;

    //zip_city : array[0..MaxZip] of integer;

    procedure MainThreadInit;
    destructor Free; override;
    procedure Init(Oldobject: TWebObject = nil); override;
    procedure HandleCommand(UnparsedParams : String;
                            Var ResponseInfo: String; Var ContentType : String); override;
    function  ProcessQuery(Request : String; AppendEOL : boolean; Var ContentType : String; AppendCommand : boolean; commstr : string = '') : String; override;
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
    procedure WriteAddress1(R : integer; Left : boolean);
//    function  SameAltAddress(A, f : integer) : boolean;
    function  SameAltAddress(i, j : integer) : boolean;
    function  MoveNext(Var R : integer; Var Left : boolean) : boolean;
    procedure WriteWord(W : integer);
    procedure Writebyte(W : integer);
    procedure Writeshortint(W : integer);
    function  readshortint(Var P : integer) : integer;
    procedure WriteString(S : String);
    procedure WriteVertexes(R : integer; NotLast: boolean; Var FLat, FLon : integer; Left : boolean);
    procedure WriteVertexes1(R : integer; NotLast: boolean; Var FLat, FLon : integer; Left : boolean);
    procedure WriteInt3(W : integer);
    function  ReadInt3(Var P : integer) : integer;
    procedure WriteInteger(W : integer);
    function ReadInteger(Var P : integer) : integer;
    procedure ReadStruct(Var S; Size : integer; Var P : integer);
    procedure ReadString(Var S : String; Var P : integer);
    function  ReadByte(Var P : integer) : byte;
    function  ReadWord(Var P : integer) : word;
    function  ReadNextAddress(Var A : TAddress; Var Next : TAddress; Var P : integer) : boolean;
    procedure SkipVertexes(Var P : integer; Var FLat, FLon : integer; Var PrevLat, PrevLon : integer);
    function  WriteRange(FromL, ToL, FromR, ToR : integer;
          AlphaPrefixL : String; AlphaPrefixR : String;
          AvenueFromR, AvenueToR : integer;
          AvenueFromL, AvenueToL : integer; Zip, LZip, RZip : Integer) : integer;
    function ReadRange(Var P, FromL, ToL, FromR, ToR : integer;
        Var AlphaPrefixL : String; Var AlphaPrefixR : String;
        Var AvenueFromR, AvenueToR : integer;
        Var AvenueFromL, AvenueToL : integer; Var LZip, RZip : Integer) : byte;
    procedure WriteRanges(R : integer; NotLast : boolean; Left : boolean; Z : integer);
    procedure WriteRanges1(R : integer; NotLast : boolean; Left : boolean; Z : integer);
    procedure ProcessOneCounty(FileName : String);
    procedure JoinMaps(FileName : String);
    procedure CalcCounty(FileName : String);
    function  ExtendChain(Var R : integer; Var Left : boolean) : boolean;
    function  MatchVertex(Lat, Lon : integer; SR : integer ;Var L: boolean) : boolean;
    function  SameAddress(R, SR : integer) : boolean;
    procedure ExtendData(L : integer);
    procedure ReadAddress(Var A : TAddress; Var P : integer);
    procedure ReadVertexes(Var V : TVertexes; Var P : integer; Var FLat, FLon : integer; Var PrevLat, PrevLon : integer);
    procedure BuildIndex;
    procedure AddToReverseIndex(Var V : Tvertexes; p0 : integer);
    procedure MakeStreet(Var A : TAddress; Var S : String);
    procedure AddToIndex(Var A : TAddress; P : integer);
    function Find(Var A : TAddress) : PHashEntry;
    function findbycity(Var A : TAddress; C : integer) : PHashEntry;
    function Hashfun(Var A : TAddress) : integer;
    procedure ParseStreetData(Var S : TStreetData);
    procedure ParseStreet(Var S : String; Var A : TAddress; Var AlphaPrefix : String; Var Avenue, House : integer);
    function  FindHouse(Var SA, FoundA : TAddress; Var AlphaPrefix : String; Avenue, House : integer;
                      E : PHashEntry; Var X, Y : double; Relaxed : integer; Var Approx : boolean; Var Debug : TDebug) : boolean;
    procedure FindPoint(Var V : TVertexes; left  : boolean; R : double; Var X, Y : double);
    function  MatchStreet(Var A, B : TAddress; Relaxed : integer) : boolean;
    function  FindHouseByZip(street, zip, City, State : String; Var X, Y : double; Var Approx : integer; Var Debug : TDebug; Var Error : String; ZipPrty : boolean) : boolean;
    procedure locateProperty(Var street : string; Var X, Y : double; Var Approx : integer);
    function  findProperty(AddrField : integer; LatLonField : integer; rObject : TWebObject; Var street : TStreetData; Var X, Y : double; Var Approx : integer; NumFind : integer) : boolean;
    procedure ReadAllCities_old;
    procedure ReadAllCities_new;
    procedure ReadAllCities_business; // new format as of 12/2007
    procedure ParseWtown3;
    function  FindCity(Var SCity : String; IState : integer; parsing : boolean = false) : integer;
    function  InsertCity(Var SCity: String; IState : integer) : integer;
    function  HashCity(Var SCity : String; IState : integer) : integer;
    procedure SaveCities;
    procedure SortZipCity;
    function  LoadCities : boolean;
    function  AddressToStr(Var A : TAddress) : String;
    function  MatchZipCity(Z, C : integer) : boolean;
    function  SameString(Var S1, S2 : String) : boolean;
    procedure DumpBadZips;
    procedure ProcessOneNavState(FileName : String);
    procedure ProcessStateDir(FileName : String);
    procedure CheckMerge(Var SA : TAddress; Var Found, NotFound : integer);
    procedure UseNavData;
    procedure UseTigerData;
    procedure MergeTiger;
    procedure LoadCodes;
    procedure StandardizeCity(Var S : String; delspaces : boolean);
    function  FindInNav(Var SA : TAddress; House : integer) : boolean;
    procedure LoadIndex;
    procedure SaveIndex;
    procedure BuildStree;
    procedure ObjCoor(ObjID : integer; Var X, Y : single);
    procedure AddToInverseIndex(x, y : single; p0 : integer);
//    function  MinDistance(Obj : integer; X, Y : single; Var AA: TAddress; Var House, RangeFrom, RangeTo, Zip : integer; Var Intersection : XYZ) : single;
    function  MinDistance(Obj : integer; X, Y : single; Var List : TStreetRecs) : single;
    function  GetStreetDescription(Var Rec : TStreetRec; x, y : single; friendly : boolean = false) : string;
    function  Find2Streets(x1, y1: double; friendly : boolean) : string;
    function  GetCity(x1, y1 : double) :string;

    procedure locateProperty_nationwide(Var Street : string; Var X, Y : double; Var Approx : integer; zipf :string; Var cleansed_add: string);
    function findProperty_nationwide(AddrField : integer; LatLonField : integer; rObject : TWebObject; Var street : TStreetData; Var X, Y : double; Var Approx : integer; NumFind : integer; Var partition : string; zipf : string; Var cleansed_add: string) : boolean;
    procedure regexp_Compile(Var S: String; mode: Integer);

    function getFileName(s : string ; create: boolean): string;
    function getallprops(X, Y : double; house : string; rObject : TWebObject): string;
    { Public declarations }
  end;

function MapUrl(Header : String; X,Y : double) : STring;
function MapUrl1(Header : String; X,Y : String) : STring;

var istreetobject : TStreetobject;

implementation
uses parser, sysutils, forms, cityobject, zipobject, Fileio, IDUri, threadpool, myutil1, geodist;


procedure Addtrace(Var Debug : TDebug; T : String);
begin
   Debug.S :=  Debug.S + '<p>' + T + '</p>';
end;

procedure TStreetObject.LoadCodes;
Var i, C : integer;
    scode, sname, S, sscode : string;
    F : textfile;
begin
  assign(F, dir1 + 'statecode.txt');
  reset(f);
  while not eof (f) do
     begin
        readln(F, S);
        ExtractFieldByNum(S, 1, SCode);
        ExtractFieldByNum(S, 2, SName);
        ExtractFieldByNum(S, 3, SSCode);
        Val(SCode, i, C);
        StateCodes[i] := SSCode;
     end;
  CloseFile(F);
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

procedure ProcessAddressOld(Var AlphaPrefixL : string; Var AvenueFromL, FromL : integer; S : String);
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

procedure ProcessAddress(Var AlphaPrefix : string; Var AvenueFrom, From : integer; S : String);
Var i,p,p1,  Pref : integer;
    ss : string;
begin
   p := 1;
   while (p <= length(S)) and (S[P] = ' ') do
     inc(p);
   p1 := p;
   while (p <= length(S)) and (not (('0' <= S[p]) and (S[p] <= '9'))) do
     inc(p);
   AlphaPrefix := upstr(Copy(S, p1, p-p1));
   p1 := p;
   if length(AlphaPrefix) > 1 then
     AlphaPrefix := '';
   while (p <= length(S)) and (('0' <= S[p]) and (S[p] <= '9')) do
     inc(p);
   if p > length(S) then
     begin
        From := ValStr(copy(S, p1, p -p1));
        AvenueFrom := 0;
        exit;
     end;
   AvenueFrom := ValStr(copy(S, p1, p-p1));
   p1 := p;
   while (p < length(S)) and (not (('0' <= S[p]) and (S[p] <= '9'))) do
     inc(p);
   ss := upstr(Copy(S, p1, p-p1));
   if (ss = '-') or (ss = 'S') or (ss = 'N') or (ss = 'E') or (ss = 'W') then
      begin
         p1 := p;
         while (p <= length(S)) and (('0' <= S[p]) and (S[p] <= '9')) do
           inc(p);
         if p1 = p then
            begin
              AlphaPrefix := ss;
              From := AvenueFrom;
              AvenueFrom := 0;
              exit;
            end;
         From := ValStr(copy(S, p1, p-p1));
         if ss <> '-' then
           AlphaPrefix := AlphaPrefix + ss;
      end
   else if ss = ' ' then
      begin
        From := AvenueFrom;
        AvenueFrom := 0;
      end
   else // unrecognized address
      begin
        From := 0;
        AvenueFrom := 0;
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
                AlphaPrefixL := '';
                AlphaPrefixR := '';
                ZipL := ValStr(copy(Line, RT1ZIPL, 5));;
                ZipR := ValStr(copy(Line, RT1ZIPR, 5));
{                if (Name = 'BAYVIEW') and (ZIPL = 33160) then
                   ZipL := 33160;}
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
//                if (abs(FrLat - 37892475)< 10) and (abs(FrLong+91865113) < 10) then
//                    FrLat := FrLat;
                ToLat := ValStr(copy(Line, RT1TOLAT, LATL));
                ToLong := ValStr(copy(Line, RT1TOLONG, LONGL));;
//                if (abs(ToLat - 37892475)< 10) and (abs(ToLong+91865113) < 10) then
//                    ToLat := ToLat;
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
                if (ZipL < Minzip) then
                  ZipL := ZipR;
                if (ZipR < Minzip) then
                  ZipR := ZipL;
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
//                if (abs(Lat - 37892475)< 10) and (abs(Long+91865113) < 10) then
//                    Lat := Lat;
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

procedure TStreetObject.WriteAddress1(R : integer; Left : boolean);
Var Alt : array[0..100] of integer;
    NumAlt, i, j, jj, f, k : integer;
    Found : boolean;
begin
// write the main address
   writebyte(RT1[R].CFCC);
   if Length(RT1[R].AltNames) = 0 then
      writebyte(RT1[R].CombinedDir)
   else
      writebyte(RT1[R].CombinedDir+128);
   writebyte(RT1[R].Ftype);
   writeint3(RT1[R].ZIPL);
   if (RT1[R].ZIPL <> 0) and (RT1[R].ZIPL < MinZip) then
     raise exception.create('RT1[R].ZIPL < MinZip');
   writeString(RT1[R].Name);
   for i := 0 to Length(RT1[R].AltNames) - 1 do
     begin
       if i = (Length(RT1[R].AltNames) - 1) then
          writebyte(RT1[R].AltNames[i].CombinedDir)
       else
          writebyte(RT1[R].AltNames[i].CombinedDir+128);
       writebyte(RT1[R].AltNames[i].Ftype);
       writeString(RT1[R].AltNames[i].Name);
     end;
end;


procedure TStreetObject.ReadStruct(Var S; Size : integer; Var P : integer);
begin
  Move((@DataArr^[P])^, S, Size);
  inc(P, Size);
end;

procedure TStreetObject.ReadString(Var S : String; Var P : integer);
begin
   Setlength(S, DataArr^[P]);
   Move((@DataArr^[P+1])^, (@S[1])^, DataArr^[P]);
   inc(P, DataArr^[P]+1);
end;

const Numreads : integer = 0;

procedure TStreetObject.ReadAddress(Var A : TAddress; Var P : integer);
begin
   inc(Numreads);
//   if NumReads = 305613 then
//      NumReads := 305613;
   ReadStruct(A.CommonRec, sizeof(A.Commonrec), P);
   A.Zip := ReadInt3(P);
   if (A.Zip < 0) or (A.Zip > 100000) then
      A.Zip := A.Zip;
   ReadString(A.Name, P);
end;

function TStreetObject.ReadByte(Var P : integer) : byte;
begin
  Result := DataArr^[P];
  inc(P);
end;

function  TStreetObject.ReadWord(Var P : integer) : word;
begin
   move(DataArr^[P], result, 2);
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
  procedure QuickSort1(L, R: Integer);
  var
    I, J: Integer;
    X, T: integer;
  begin
      I := L;
      J := R;
      X := Vert[(L + R) div 2];
      repeat
        while RT2[Vert[I]].RTSQ < RT2[X].RTSQ do
          Inc(I);
        while RT2[Vert[J]].RTSQ > RT2[X].RTSQ do
          Dec(J);
        if I <= J then
        begin
          T := Vert[I];
          Vert[I] := Vert[J];
          Vert[J] := T;
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then
        QuickSort1(L, J);
      if I < R then
        QuickSort1(I, R);
  end;
begin
{   if R = 2974 then
     R := 2974;
   if DataIndex >= 538605 then
      DataIndex := DataIndex;}
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
{   if Numvert > 2 then
     QuickSort1(0, NumVert-1);}
// ERROR! Vert needs to be storted by RTSQ!!!
   if Numvert >= 255 then
     begin
       writebyte(255);
       writeword(NumVert);
     end
   else
      writebyte(NumVert);
   if Flat = 0 then
     begin
       if Left then
         begin
           FLat := Rt1[R].FRLat;
           FLon := RT1[R].FRLong;
//           if (abs(FLat - 37892475)< 10) and (abs(FLon+91865113) < 10) then
//               FLat := FLat;
           writeinteger(FLat);
           writeinteger(FLon);
           for i := 0 to NumVert - 1 do
              begin
                 if i < (NumVert-1) then
                   if RT2[Vert[i]].RTSQ > RT2[Vert[i+1]].RTSQ then
                      RT2[Vert[i]].RTSQ := 0;
                 writeint3(RT2[Vert[i]].Lat-FLat);
                 writeint3(RT2[Vert[i]].Long-FLon);
              end;
//           if (abs(RT1[R].ToLat - 37892475)< 10) and (abs(RT1[R].ToLong+91865113) < 10) then
//               FLat := FLat;
           writeint3(RT1[R].ToLat-FLat);
           writeint3(RT1[R].ToLong-FLon);
         end
       else
         begin
           FLat := Rt1[R].ToLat;
           FLon := RT1[R].ToLong;
           writeinteger(FLat);
           writeinteger(FLon);
           for i := NumVert - 1 downto 0 do
              begin
                 writeint3(RT2[Vert[i]].Lat-FLat);
                 writeint3(RT2[Vert[i]].Long-FLon);
              end;
           writeint3(RT1[R].FrLat-FLat);
           writeint3(RT1[R].FrLong-FLon);
         end;
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

procedure TStreetObject.WriteVertexes1(R : integer; NotLast: boolean; Var FLat, FLon : integer; Left : boolean);
Var Vert : array[0..1000] of integer;
    i, NumVert : integer;
begin
   NumVert := length(Rt1[R].Points) - 2;
   if Numvert >= 255 then
     begin
       writebyte(255);
       writeword(NumVert);
     end
   else
      writebyte(NumVert);
   if Flat = 0 then
     begin
       if Left then
         begin
           FLat := Rt1[R].FRLat;
           FLon := RT1[R].FRLong;
           writeinteger(FLat);
           writeinteger(FLon);
           for i := 0 to NumVert - 1 do
              begin
                 writeint3(Rt1[R].Points[i+1].Y-FLat);
                 writeint3(Rt1[R].Points[i+1].X-FLon);
              end;
           writeint3(RT1[R].ToLat-FLat);
           writeint3(RT1[R].ToLong-FLon);
         end
       else
         begin
           FLat := Rt1[R].ToLat;
           FLon := RT1[R].ToLong;
           writeinteger(FLat);
           writeinteger(FLon);
           for i := NumVert - 1 downto 0 do
              begin
                 writeint3(Rt1[R].Points[i+1].Y-FLat);
                 writeint3(Rt1[R].Points[i+1].X-FLon);
              end;
           writeint3(RT1[R].FrLat-FLat);
           writeint3(RT1[R].FrLong-FLon);
         end;
     end
   else
     begin
       if Left then
          begin
             for i := 0 to NumVert - 1 do
                begin
                   writeint3(Rt1[R].Points[i+1].Y-FLat);
                   writeint3(Rt1[R].Points[i+1].X-FLon);
                end;
             writeint3(RT1[R].ToLat-FLat);
             writeint3(RT1[R].ToLong-FLon);
          end
       else
          begin
             for i := NumVert - 1 downto 0 do
                begin
                   writeint3(Rt1[R].Points[i+1].Y-FLat);
                   writeint3(Rt1[R].Points[i+1].X-FLon);
                end;
             writeint3(RT1[R].FRLAT-FLat);
             writeint3(RT1[R].FRlong-FLon);
          end;
     end;
end;


procedure TStreetObject.SkipVertexes(Var P : integer; Var FLat, FLon : integer; Var PrevLat, PrevLon : integer);
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


procedure TStreetObject.ReadVertexes(Var V : TVertexes; Var P : integer; Var FLat, FLon : integer; Var PrevLat, PrevLon : integer);
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
   move(w, (@DataArr^[DataIndex])^, 2);
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
   DataArr^[DataIndex] := W;
   inc(DataIndex);
end;

procedure TStreetObject.Writeshortint(W : integer);
begin
   ExtendData(1);
   if (W >= 128) or (W <= -128) then
      raise Exception.Create('Error');
   DataArr^[DataIndex] := byte(shortint(W));
   inc(DataIndex);
end;

function  TStreetObject.readshortint(Var P : integer) : integer;
begin
   result := shortint(DataArr^[P]);
   inc(P);
end;

procedure TStreetObject.WriteInteger(W : integer);
begin
   ExtendData(4);
   Move(W, DataArr^[DataIndex], 4);
   inc(DataIndex, 4);
end;

function TStreetObject.ReadInteger(Var P : integer) : integer;
begin
   Move(DataArr^[P], Result, 4);
   inc(P, 4);
end;

procedure TStreetObject.WriteInt3(W : integer);
begin
   ExtendData(3);
   w := w * 256;
   Move(ptr(integer(@W)+1)^, DataArr^[DataIndex], 3);
   inc(DataIndex, 3);
end;

function TStreetObject.ReadInt3(Var P : integer) : integer;
begin
   Move(DataArr^[P], ptr(integer(@Result)+1)^, 3);
   Result := Result div 256;
   inc(P, 3);
end;


procedure TStreetObject.WriteString(S : String);
begin
   ExtendData(length(S) + 1);
   DataArr^[DataIndex] := length(S);
   move((@S[1])^, (@DataArr^[DataIndex+1])^, length(S));
   inc(DataIndex, length(S) + 1);
end;

procedure TStreetObject.ExtendData(L : integer);
begin
  if (DataIndex+L) >= length(DataArr^) then
     setlength(DataArr^, round((DataIndex + L) * 1.3) + 1000);
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
              AvenueFromR,  AvenueToR, AvenueFromL, AvenueToL, Z, ZipL, ZipR);
         end
       else
         begin
           Last := writerange(ToR, FromR,  ToL, FromL,  AlphaPrefixR, AlphaPrefixL,
             AvenueToL, AvenueFromL,  AvenueToR, AvenueFromR,  Z, ZipR, ZipL);
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
             Last := writerange(ToR, FromR, ToL, FromL,  AlphaPrefixR, AlphaPrefixL,
               AvenueToL, AvenueFromL, AvenueToR, AvenueFromR, Z, ZipR, ZipL);
        i := RT6[i].HashNextTlid;
      end;
   if not notlast then
     DataArr^[Last] := DataArr^[Last] or Fl_LAST;
   DataArr^[Last] := DataArr^[Last] or Fl_END;
end;


procedure TStreetObject.WriteRanges1(R : integer; NotLast : boolean; Left : boolean; Z : integer);
Var i, Last : integer;
begin
   with RT1[R] DO
     begin
       if Left then
         begin
           Last := writerange(FromL, ToL, FromR, ToR, AlphaPrefixL, AlphaPrefixR,
              AvenueFromR, AvenueToR, AvenueFromL, AvenueToL, Z, ZipL, ZipR);
         end
       else
         begin
           Last := writerange(ToR, FromR, ToL, FromL,  AlphaPrefixR, AlphaPrefixL,
             AvenueToL, AvenueFromL,  AvenueToR, AvenueFromR,  Z, ZipR, ZipL);
         end;
     end;
   for i := 0 to length(RT1[R].AltRanges) - 1 do
     begin
        with RT1[R].AltRanges[i] do
        if Left then
         Last := writerange(FromL, ToL, FromR, ToR, AlphaPrefixL, AlphaPrefixR,
           AvenueFromR, AvenueToR, AvenueFromL, AvenueToL, Z, ZipL, ZipR)
        else
         Last := writerange(ToR, FromR,  ToL, FromL,  AlphaPrefixR, AlphaPrefixL,
           AvenueToL, AvenueFromL,  AvenueToR, AvenueFromR,  Z, ZipR, ZipL);
     end;
   if not notlast then
     DataArr^[Last] := DataArr^[Last] or Fl_LAST;
   DataArr^[Last] := DataArr^[Last] or Fl_END;
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

{const ppp1 = 61238563;
const ppp2 = 61554680;}
procedure TStreetObject.JoinMaps(FileName : String);
Var F : File;
    nr : integer;
begin
   if (Pos('.MAP', UpStr(FileName)) = 0) and  (Pos('.NAV', UpStr(FileName)) = 0) then
      exit;
   assignFile(F, FileName);
   reset(F, 1);
   blockread(F, (@DataArr^[DataIndex])^, filesize(F), NR);
{   if (DataIndex <= ppp1) and ((DataIndex + NR) > ppp1) then
      Interf.SetStatus('Position ' +Inttostr(ppp1) + ' ' +  FileName);
   if (DataIndex <= ppp2) and ((DataIndex + NR) > ppp2) then
      Interf.SetStatus('Position ' +Inttostr(ppp2) + ' ' +  FileName);}
   inc(DataIndex, NR);
   if DataIndex > length(DataArr^) then
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


procedure splitaddr(var a, s1, s2 : string);
Var i : integer;
begin
   i := length(a);
   while (i > 0) and (a[i] in ['0'..'9']) do
      dec(i);
   s1 := copy(a, 1, i);
   s2 := copy(a, i+1, length(a) - i);
end;

procedure TStreetObject.MainThreadInit;
begin
   Map:=coiShp.Create;
   Map.Document.Name:= ShpName;
   Map.CheckStatus:=5;
   if not Map.Open then
      exit;
end;

function ValZip(S : String) : integer;
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

const PrevSTName : String = '';
procedure TStreetObject.ProcessStateDir(FileName : String);
Var Table : TTable;
    FType, DirPrefix, DirSuffix : String;
begin
   if pos('STREETS.DBF', UpStr(FileName)) = 0  then
      exit;
   Interf.SetStatus('Processing State ' + FileName);
   Table := TTable.Create(nil);
   try
     Table.TableName := FileName;
     Table.Active := true;
     Table.First;
     while not Table.Eof do
       begin
           PrevSTName := Table.FieldByName('ST_NAME').AsString;
           DirPrefix := Table.FieldByName('ST_NM_PREF').AsString; // name prefix
           DirPrefixes.Add(DirPrefix);
           DirSuffix := Table.FieldByName('ST_NM_SUFF').AsString; // name prefix
           DirSuffixes.Add(DirSuffix);
           FType := Table.FieldByName('ST_TYP_AFT').AsString;
           FeatureTypes.Add(FType);
           Table.Next;
       end;
     finally
     Table.Free;
   end;
end;

const HashSize = 1024*1024;
const G_ID : integer = 0;
procedure TStreetObject.ProcessOneNavState(FileName : String);
Var Table : TTable;
    FoundRT, NumShapes, NumNames, LNumZones, RNumZones, NumRanges, LAID, RAID : integer;
    RZip, LZip : String;
    DirPrefix, DirSuffix : String;
    Name, StTypeBefore, StTypeAfter, Attached, AddrType, LeftAddr1, LeftAddr2 : String;
    LeftType : String;
    Range, PrevRange, PrevSTName, SN, LeftFormat, RightAddr1, RightAddr2, RightType, RightFormat : String;
    RecPoints:OleVariant;
    R, r1, H, FTyp, Pref, Suf, PrevID, ID, NumPoints, recordNum, i : integer;
    X, Y, PX, PY : double;
    CombDir : byte;
    Left, NotLast, First, found, PrevL : boolean;
    Zl, Zr, NumAddresses, Z, FLat, FLon, Prev, Nw  : integer;
    F : File;
    Hash : array[0..HashSize] of integer;

procedure ExtractNameDir;
begin
    FTyp := FeatureTypes.Find(Table.FieldByName('ST_TYP_AFT').AsString);
    SN := Table.FieldByName('ST_NM_BASE').AsString;
    Standartize(SN);
    replacewords(SN);
    Pref := DirPrefixes.Find(Table.FieldByName('ST_NM_PREF').AsString);
    Suf := DirSuffixes.Find(Table.FieldByName('ST_NM_SUFF').AsString);
    if (Pref = NullPrefix) and (SN <> '') and (DirPrefixes.Find(ExtractFirstWord(SN)) >= 0) then
       begin
          Pref := DirPrefixes.Find(ExtractFirstWord(SN));
          DeleteFirstWord(SN);
       end;
    if (FTyp = NullType) and (SN <> '') and (FeatureTypes.Find(ExtractLastWord(SN)) >= 0) then
       begin
          FTyp := FeatureTypes.Find(ExtractLastWord(SN));
          DeleteLastWord(SN);
       end;
    if (Suf = NullSuffix) and (FTYP = NullType) and (SN <> '') and (DirSuffixes.Find(ExtractLastWord(SN)) >= 0) then
       begin
          Suf := DirSuffixes.Find(ExtractLastWord(SN));
          DeleteLastWord(SN);
       end;
    CombDir := Pref*10 + Suf;
end;

procedure ResetArr;
Var h, i : integer;
begin
   NewNav := true;
   Setlength(DataArr^, 0);
   DataIndex := 0;
   setlength(RT1, 1024*1024);
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
   for h := 0 to CoorHashSize-1 do
      CoorHash[H] := -1;
   for i := 0 to HashSize-1 do
      Hash[i] := -1;
end;

procedure writeaddresses;
Var r1 : integer;
begin
   for r1 := 0 to NumRt1 - 1 do
     with RT1[r1] do
      if (RT1[r1].Name <> '') or (RT1[r1].CombinedDir <> (NullPrefix * 10 + NullSuffix)) or (RT1[r1].Ftype <> NullType) then
       if (LeftChain = -1) and (RightChain = -1) then
         begin
            if r1 = 219313 then
               R := 219313;
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
            WriteAddress1(R, Left);
            inc(NumAddresses);
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
                if Prev = 219313 then
                   Prev := 219313;
                WriteVertexes1(Prev, R <> Prev, FLat, FLon, not PrevL);
                WriteRanges1(Prev, R <> Prev, not PrevL, Z);
                First := false;
                if R = Prev then
                  break;
              end;
         end;
        inc(TotalSize, DataIndex);
        AssignFile(F, TheFullFileName(FileName) + '.NAV');
        filemode := 2;
        reset(F, 1);
        if ioresult <> 0 then
           rewrite(f, 1);
        seek(F, filesize(F));
        blockwrite(F, (@DataArr^[0])^, DataIndex, Nw);
        closefile(F);
        ResetArr;
end;


begin
   if pos('STREETS.DBF', UpStr(FileName)) = 0  then
      exit;
   if FileExists(TheFullFileName(FileName) + '.NAV') then
     begin
        inc(TotalSize, TheFileSize(TheFullFileName(FileName) + '.NAV'));
        exit;
     end;

   ResetArr;
   Interf.SetStatus('Processing State ' + FileName);
   Table := TTable.Create(nil);
   Table.TableName := FileName;
   Table.Active := true;
   Table.First;
   ShpName := TheFullFileName(FileName) + '.SHP';
   mainthreadexec(MainthreadInit);
   recordNum := 0;
   PrevID := 0;
   while not Table.Eof do
     begin
       inc(recordNum);
       inc(G_ID);
       ID := G_ID;
       NumNames := 1;//Table.FieldByName('NUM_STNMES').AsInteger; // number of street names
       NumRanges := 1;//Table.FieldByName('NUM_AD_RNG').AsInteger;
//       ID := Table.FieldByName('LINK_ID').AsInteger;
       RecPoints:=Map.GetRecordPoints(recordnum);
       NumPoints := Map.RecordPointCount[recordnum];
       LeftAddr1 := Table.FieldByName('L_REFADDR').AsString;
       LeftAddr2 := Table.FieldByName('L_NREFADDR').AsString;
       RightAddr1 := Table.FieldByName('R_REFADDR').AsString;
       RightAddr2 := Table.FieldByName('R_NREFADDR').AsString;
       Range := LeftAddr1 +'-'+ LeftAddr2 +'-'+ RightAddr1 +'-'+ RightAddr2;
       ZL := ValZip(Table.FieldByName('L_POSTCODE').AsString);
       ZR := ValZip(Table.FieldByName('R_POSTCODE').AsString);
       if ZL = 0 then
        ZL := ZR;
       if ZR = 0 then
        ZR := ZL;
       FoundRT := NumRt1 - 1;
{       if ID <> PrevID then
          begin
             H := ID Mod HashSize;
             FoundRT := HASH[H];
             while FoundRT >= 0 do
                if RT1[FoundRT].TLID = ID then
                   break
                else
                   FoundRT := RT1[FoundRT].HashNextTLID;
             if FoundRT >= 0 then
               begin
                PrevID := ID;
                PrevSTName := RT1[FoundRT].FullName;
                PrevRange := RT1[FoundRT].RRange;
               end;
          end;}
       if (Range <> '---') and ((ZL <> 0) or (ZR <> 0)) then
        if ID <> PrevID then
          begin
            inc(NumRt1);
            PrevID := ID;
            PrevRange := Range;
            if NumRt1 > length(RT1) then
              begin
                 writeaddresses;;
                 inc(NUmRt1);
              end;
              with RT1[NumRt1 - 1] do
                  begin
                    H := ID Mod HashSize;
                    HashNextTLID := Hash[H];
                    Hash[H] := NumRT1-1;
                    TLID := ID;
                    RRange := Range;
                    ZipL := Zl;
                    ZipR := Zr;
                    AltNames := nil;
                    AltRanges := nil;
                    TLID := 0;//ID;
                    ExtractNameDir;
                    if (ZipL = 65550) then
                      if SN = 'CR 7380' then
                         ZipL := 65550;
                    CombinedDir := CombDir;
                    FType := Ftyp;
                    if CombinedDir > 127 then
                      break;  //for NAVTEQ purposes when the street record overflows the variable
                      //raise exception.create('CombinedDir > 127');  // comment this when error pops up and uncomment the previous one
                    Name := SN;

//                    if ZL = 33160 then
//                      ZL := 33160;
//                      1099  CSWY 33132  --Correct at 0.42
//                    if (SN = 'MACARTHUR') and ((ZL = 33132) or (ZR=33132)) then
//                      SN := 'MACARTHUR';
                    CFCC := 0; //Table.FieldByName('FUNC_CLASS').AsString;
                    AlphaPrefixL := '';
                    AlphaPrefixR := '';
                    ProcessAddress(AlphaPrefixL, AvenueFromL, FromL, LeftAddr1);
                    ProcessAddress(AlphaPrefixL, AvenueToL, ToL, LeftAddr2);
                    if (LeftType = 'M') and ((FromL mod 2) = (ToL mod 2)) then
                       inc(ToL);
    {                inc(DDD);
                    if DDD = 2303 then
                      DDD := 2303;}
                    RightType := Table.FieldByName('R_ADDRSCH').AsString;
                    ProcessAddress(AlphaPrefixR, AvenueFromR, FromR, RightAddr1);
                    ProcessAddress(AlphaPrefixR, AvenueToR, ToR, RightAddr2);
                    if (RightType = 'M') and ((FromR mod 2) = (ToR mod 2)) then
                       inc(ToR);
                    FullName := Table.FieldByName('ST_NAME').AsString;
                    PrevSTName := FullName;
    {                if Tor < 0 then
                      ToR := ToR;}
                    FrLat := round(RecPoints[0,1] * CoorDiv);
                    FrLong := round(RecPoints[0,0] * CoorDiv);
                    ToLat := round(RecPoints[NumPoints-1,1] * CoorDiv);
                    ToLong := round(RecPoints[NumPoints-1,0] * CoorDiv);
                    if (SN = 'COLLINS') and (Zl = 33140) then
                      zl := 33140;
{                    if (abs(ToLat - 37892475)< 10) and (abs(ToLong+91865113) < 10) then
                       ToLat := ToLat;}
                    H := abs(FRLat + FRLong) Mod CoorHashSize;
                    HashL := CoorHash[H];
                    CoorHash[H] := NumRT1 - 1;
                    H := abs(ToLat + ToLong) Mod CoorHashSize;
                    HashR := CoorHash[H];
                    CoorHash[H] := NumRT1 - 1;
                    LeftChain := -1;
                    RightChain := -1;
                    Setlength(Points, NumPoints);
                    for i:= 0 to NumPoints -1 do
                      begin
                         Points[i].X := Round(RecPoints[i,0] * CoorDiv);
                         Points[i].Y := Round(RecPoints[i,1] * CoorDiv);
                      end;
                  end;
          end
       else // same ID
        with RT1[FoundRT] do
          begin
            if Table.FieldByName('ST_NAME').AsString <> PrevSTName then
               begin
                 PrevSTName := Table.FieldByName('ST_NAME').AsString;
                 found := false;
                 for i := 0 to length(AltNames) - 1 do
                   if Altnames[i].Name = PrevSTName then
                     found := true;
                 if (not found) and (PrevStName <> '') then
                   begin
                     ExtractNameDir;
                     setlength(AltNames, length(AltNames) + 1);
                     AltNames[length(AltNames)-1].FullName := Table.FieldByName('ST_NAME').AsString;
                     AltNames[length(AltNames)-1].FType := FTyp;
                     AltNames[length(AltNames)-1].CombinedDir := CombDir;
                     AltNames[length(AltNames)-1].Name := SN;
                   end;
               end;
            LeftAddr1 := Table.FieldByName('L_REFADDR').AsString;
            LeftAddr2 := Table.FieldByName('L_NREFADDR').AsString;
            RightAddr1 := Table.FieldByName('R_REFADDR').AsString;
            RightAddr2 := Table.FieldByName('R_NREFADDR').AsString;

            If Range <> PrevRange then
              begin
               PrevRange := Range;
               found := false;
               for i := 0 to length(AltRanges) - 1 do
                 if AltRanges[i].Name = PrevRange then
                   found := true;
               if (not found) and (PrevRange <> '---') then
                 begin
                   setlength(AltRanges, length(AltRanges) + 1);
                   AltRanges[length(AltRanges)-1].Name := PrevRange;
                   with AltRanges[length(AltRanges)-1] do
                      begin
                        ProcessAddress(AlphaPrefixL, AvenueFromL, FromL, LeftAddr1);
                        ProcessAddress(AlphaPrefixL, AvenueToL, ToL, LeftAddr2);
                        ProcessAddress(AlphaPrefixR, AvenueFromR, FromR, RightAddr1);
                        ProcessAddress(AlphaPrefixR, AvenueToR, ToR, RightAddr2);
                      end;
                   AltRanges[length(AltRanges)-1].ZipL := ValZip(Table.FieldByName('L_POSTCODE').AsString);
                   AltRanges[length(AltRanges)-1].ZipR := ValZip(Table.FieldByName('R_POSTCODE').AsString);
                 end;
              end;
          end;
       Table.Next;
     end;
   Table.Free;
   writeaddresses;;
   NumAddresses := 0;
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
    Setlength(DataArr^, 0);
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
      if ((RT1[r1].Name <> '') or (RT1[r1].CombinedDir <> (NullPrefix * 10 + NullSuffix)) or (RT1[r1].Ftype <> NullType))
          and ((RT1[r1].ZipL <> 0) or (RT1[r1].ZipR <> 0)) then
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
        blockwrite(F, (@DataArr^[0])^, DataIndex, Nw);
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
   result := (RT1[R].CFCC = RT1[SR].CFCC) and
             (RT1[R].CombinedDir = RT1[SR].CombinedDir) and
             (RT1[R].ZipL = RT1[SR].ZIPL) and
             (RT1[R].FType = RT1[SR].Ftype) and
             (RT1[R].Name = RT1[SR].Name);
{   if not result then
      exit;
   if (RT1[R].FromL <> 0) and (RT1[SR].FromL <> 0) then
      if (RT1[R].FromL mod 2) = (RT1[SR].FromL Mod 2) then
           exit;
   if (RT1[R].FromR <> 0) and (RT1[SR].FromR <> 0) then
      if (RT1[R].FromR mod 2) = (RT1[SR].FromR Mod 2) then
            exit;
   result := false;}
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
      if (SR <> R) and (RT1[SR].RightChain = -1) and (RT1[SR].LeftChain = - 1) and SameAddress(R, SR) and MatchVertex(Lat, Lon, SR, L) then
         begin
           if SR = 198138 then
               SR := 198138;
           if L then
              RT1[SR].LeftChain := R
           else
              RT1[SR].RightChain := R;
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
//  exit;
  MaxDX := MileX(25) / 3;
  MaxDY := MileY / 3;
  Interf.SetStatus('Init streets');
  LoadCodes;
  UseNavData;
  DirPrefixes := TDir.Create(Dir1 + 'Prefixes.DIR');
  Header := '';
  ReadStringFile(Dir1 + 'header.txt', Header);
  DirSuffixes := TDir.Create(Dir1 + 'Suffixes.DIR');
  FeatureTypes := TDir.Create(Dir1 + 'FeatureTypes.DIR');
  DirStates := TDir.Create(Dir1 + 'States.DIR');
  Cities := nil;
  for i := 0 to CityNameHashMax-1 do
    HashCityName[i] := -1;
  NumCities := 0;
  for i := MinZip to MaxZip do
    ZipCity[i] := nil;
  SaveStates := false;
  if FileExists(Dir1 + 'States.DIR') then
    DirStates.Load;
//  ParseWtown3;
  if not LoadCities then
    begin
      ReadAllCities_business;
      SaveCities;
//      ReadAllCities_new;
//      SaveCities;
    end;
  if SaveStates then
    begin
      DirStates.AddAbbrev(Dir1 + 'states.abb', TAB, false);
      DirStates.Save(false);
    end;
  CFCCS := TDir.Create(Dir1 + 'CFCCS.DIR');
  Loaded := false;
  if not fileexists(Dir1 + 'FeatureTypes.DIR') then
    begin
       DirPrefixes.Load;
       DirSuffixes.Load;
       ScanDirs(Dir1 + 'Navstreets\', '*.*', ProcessStateDir, false);
       FeatureTypes.AddAbbrev(Dir1 + 'features.ABB', ' ', false);
       FeatureTypes.AddAbbrev(Dir1 + 'features1.abb', TAB, true);
       ScanDirs(Dir1 + 'tiger\', '*.*', FillPrefixes, false);
       FeatureTypes.AddAbbrev(Dir1 + 'features.abb', ' ', true);
       FeatureTypes.AddAbbrev(Dir1 + 'features1.abb', TAB, true);
       DirPrefixes.Save(true);
       DirSuffixes.Save(true);
       FeatureTypes.Save(true);
       CFCCS.Save(true);
    end
  else
     begin
        DirPrefixes.Load;
        DirSuffixes.Load;
        FeatureTypes.Load;
        CFCCS.Load;
     end;
  NullPrefix := DirPrefixes.Find('');
  NullSuffix := DirSuffixes.Find('');
  NullType := FeatureTypes.Find('');
  RT1Hash := TIntHash.Create;
  NewNav := false;
  TotalSize := 0;
  if not FileExists(Dir1 + 'Allstates.MER') then
    begin
      Interf.SetStatus('Scan streets dir');
      ScanDirs(Dir1 + 'Navstreets\', '*.*', ProcessOneNavState, false);
      if NewNav or (not FileExists(Dir1 + 'AllStates.NAV')) then
         begin
            Setlength(DataArr^, TotalSize);
            DataIndex := 0;
            ScanDirs(Dir1+ 'Navstreets\', '*.*', JoinMaps, false);
            AssignFile(F, Dir1 + 'AllStates.NAV');
            rewrite(F, 1);
            blockwrite(F, (@DataArr^[0])^, DataIndex, Nw);
            closefile(F);
         end;
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
            ScanDirs(Dir1+ 'tiger\', '*.*', CalcCounty, false);
            if not AllProcessed then
              ScanDirs(Dir1+ 'tiger\', '*.*', ProcessOneCounty, false);
            Setlength(DataArr^, TotalSize);
            DataIndex := 0;
            ScanDirs(Dir1+ 'tiger\', '*.*', JoinMaps, false);
            AssignFile(F, Dir1 + 'AllStates.MAP');
            rewrite(F, 1);
            blockwrite(F, (@DataArr^[0])^, DataIndex, Nw);
            closefile(F);
        end;
    Interf.SetStatus('Reading Tiger streets');
    UseTigerData;
    AssignFile(F, Dir1+'AllStates.MAP');
    reset(F, 1);
    DataIndex := filesize(F);
    setlength(DataArr^, DataIndex);
    blockread(F, (@DataArr^[0])^, DataIndex, NR);
    closefile(F);
    UseNavData;
    Interf.SetStatus('Reading NAV streets');
    AssignFile(F, Dir1+'AllStates.NAV');
    reset(F, 1);
    DataIndex := filesize(F);
    setlength(DataArr^, round(DataIndex));
    blockread(F, (@DataArr^[0])^, DataIndex, NR);
    DataIndex := NR;
    closefile(F);
    Interf.SetStatus('Building street index');
    MaxNavteq := 0;
    BuildIndex;
    Interf.SetStatus('Merge Tiger streets');
    MergeTiger;
    NavArr := nil;
    TigerArr := nil;
    deletefile(Dir1 + 'AllStates.idx');
  end;
  Interf.SetStatus('Reading streets');
  AssignFile(F, Dir1+'AllStates.MER');
  reset(F, 1);
  DataIndex := filesize(F);
  Loaded := DataIndex > 0;
  setlength(DataArr^, DataIndex);
  blockread(F, (@DataArr^[0])^, DataIndex, NR);
  closefile(F);
  Interf.SetStatus('Building street index');
  if FileExists(Dir1 + 'AllStates.idx') then
     LoadIndex
  else
     begin
       MaxNavteq := TheFileSize(dir1 + 'AllStates.NAV');
       BuildIndex;
       SaveIndex;
     end;
  BuildStree;
  Interf.SetStatus('Done');
end;

procedure TStreetObject.MakeStreet(Var A : TAddress; Var S : String);
Var D1, D2 : integer;
begin
   D1 := A.CommonRec.CombinedDir and (not 128);
   D2 := D1 mod 10;
   D1 := D1 div 10;
   S := DirPrefixes.GetName(D1)+ ' ' + A.Name + ' ' + DirSuffixes.GetName(D2) + ' ' +
          FeatureTypes.GetName(A.CommonRec.FType);
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
const _debug1 : integer = 0;
procedure TStreetObject.AddToIndex(Var A : TAddress; P : integer);
Var  E : PHashEntry;
     HF, i, j, C : integer;
     found : boolean;
begin
   inc(_debug1);
   if _debug1=321008 then
      _debug1 := 321008;
{  if P = 7562873 then
    P := 7562873;
  inc(_debug1);
  if (A.Zip < 0) or (A.Zip > MaxZip) or (A.Name = #0) then
    _debug1 := _debug1;
  if _debug1>=11144610 then
    _debug1 := _debug1;}
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
           found := false;
           E := @Cities[C].Hash[HF];
           for i := 0 to length(E^) - 1 do
             if E^[i] = P then
               begin
                 found := true;
                 break;
               end;
           if not found then
             begin
               setlength(E^, length(E^) + 1);
               E^[Length(E^)-1] := P;
               inc(NumHashElem);
             end;
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

{
  P0 - 4b
  X, Y 8B

  24B
}


procedure TStreetObject.AddToInverseIndex(x, y : single; p0 : integer);
begin
    inc(NumInverseRecs);
    if NumInverseRecs >= length(InverseRecs) then
        setlength(InverseRecs, round(NumInverseRecs * 1.3));
    InverseRecs[NumInverseRecs-1].X := x;
    InverseRecs[NumInverseRecs-1].Y := y;
    InverseRecs[NumInverseRecs-1].p0 := P0;
end;

procedure TStreetObject.BuildStree;
Var i : integer;
begin
   MinX := 1000;
   MaxX := -1000;
   MinY := 1000;
   MaxY := -1000;
   for i := 0 to NumInverseRecs - 1 do
     begin
        if InverseRecs[i].X < MinX then
           MinX := InverseRecs[i].X;
        if InverseRecs[i].Y < MinY then
           MinY := InverseRecs[i].Y;
        if InverseRecs[i].X > MaxX then
           MaxX := InverseRecs[i].X;
        if InverseRecs[i].Y > MaxY then
           MaxY := InverseRecs[i].Y;
     end;
   Stree := TStree.Create(MinX-2*MaxDX, MinY-2*MaxDX, MaxX+2*MaxDX, MaxY+2*MaxDY, 8, 4, NumInverseRecs);
   for i := 0 to NumInverseRecs - 1 do
      Stree.AddObject(i, Inverserecs[i].X, Inverserecs[i].Y, ObjCoor);
end;

procedure TStreetObject.ObjCoor(ObjID : integer; Var X, Y : single);
begin
  X := Inverserecs[ObjId].X;
  Y := Inverserecs[ObjId].Y;
end;


procedure TStreetObject.BuildIndex;
Var A,  Next : TAddress;
    i, P, P0, SP, FLat, FLon : integer;
    PLat, Plon, FromL, ToL, FromR, ToR : integer;
    AlphaPrefixL : String; AlphaPrefixR : String;
    AvenueFromR, AvenueToR : integer;
    AvenueFromL, AvenueToL : integer;
    LZip, RZip : Integer;
    flag : byte;
    NumRanges : integer;
    V : TVertexes;
    MinY, MaxY, MinX, MaxX : single;
    x, y, x1, y1 : single;
    UX, UY, U : double;
begin
   P := 0;
   NumRanges := 0;
   NumInverseRecs := 0;
   setlength(InverseRecs, 18095022+10000);
   while P < DataIndex do
     begin
       inc(NumRanges);
       P0 := P;
{       if P >= 10680649 then
         P := P;}
       if _debug1 >= 321000 then
         _debug1 := _debug1;
       ReadAddress(A, P);
{       if (A.NAME = 'BAYVIEW') and (A.Zip = 33160) then
          A.Zip := 33160;}
       AddToIndex(A, P0);
       while ReadNextAddress(A, Next, P) do
          begin
            AddToIndex(Next, P0);
            A := Next;
          end;
       FLat := 0;
       FLon := 0;
       V.NumVert := 0;
       while true do
         begin
           ReadVertexes(V, P, FLat, FLon, PLat, Plon);
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
       if P0 < MaxNavteq then
          AddToReverseIndex(V, P0);
     end; // p < dataindex
  Interf.SetStatus('Number of ranges: ' + inttostr(NumRanges));
end;

procedure TStreetObject.AddToReverseIndex(Var V : Tvertexes; p0 : integer);
Var i : integer;
    MinY, MaxY, MinX, MaxX : single;
    x, y, x1, y1 : single;
    UX, UY, U : double;
begin
   MinY := 1000;
   MaxY := -1000;
   MinX := 1000;
   MaxX := -1000;
   for i := 0 to V.Numvert-1 do
      begin
         x := V.Vert[i].Lon/CoorDiv;
         y := V.Vert[i].Lat/CoorDiv;
         if x < MinX then
            MinX := X;
         if X > MaxX then
            MaxX := X;
         if Y < MinY then
            MinY := Y;
         if Y > MaxY then
            MaxY := Y;
      end;
    if ((MaxX - MinX) < MaxDX*2) and ((MaxY - MinY) < MaxDY*2) then
       begin
         x := (MaxX + MinX) / 2;
         y := (MaxY + MinY) / 2;
         AddToInverseIndex(x, y, p0);
       end
    else
       begin
          x := V.Vert[0].Lon/CoorDiv;
          y := V.Vert[0].Lat/CoorDiv;
          for i := 1 to V.Numvert-1 do
             begin
                x1 := V.Vert[i].Lon/CoorDiv;
                y1 := V.Vert[i].Lat/CoorDiv;
                while (abs(x1 - x) > MaxDX) or (abs(y1 - y) > MaxDY) do
                   begin
                      if abs(x1 - x) <> 0 then
                        UX := MaxDX/abs(x1-x)
                      else
                        UX := 1;
                      if abs(y1-y) <> 0 then
                        UY := MaxDY/abs(y1-y)
                      else
                        UY := 1;
                      if UX < UY then
                        U := UX
                      else
                        U := UY;
                      x := x + U*(x1-x);
                      y := y + U*(y1-y);
                      AddToInverseIndex(x, y, p0);
                   end;
             end;
       end;
end;

procedure TStreetObject.SaveIndex;
Var i, z, c, h : integer;
    f : TFileIO;
procedure SaveEntry(Var E : THashEntry);
Var i : integer;
begin
   F.WriteInt(length(E));
   for i := 0 to length(E) - 1 do
     F.WriteInt(E[i]);
end;
begin
    F := TFileIO.Create(Dir1 + 'AllStates.idx', true, false);
    for z := MinZip To MaxZip do
      for h := 0 to ZipHashMax-1 do
            SaveEntry(Hash[z, h]);
    for c := 0 to NumCities-1 do
       for h := 0 to ZipHashMax-1 do
          SaveEntry(Cities[c].Hash[h]);
    F.WriteInt(NumInverseRecs);
    for i := 0 to NumInverseRecs - 1 do
       begin
          F.WriteInt(InverseRecs[i].P0);
          F.WriteInt(round(InverseRecs[i].X*CoorDiv));
          F.WriteInt(round(InverseRecs[i].Y*CoorDiv));
       end;
    F.Free;
end;

procedure TStreetObject.LoadIndex;
Var i, z, c, h : integer;
    f : TFileIO;
procedure ReadEntry(Var E : THashEntry);
Var i : integer;
begin
   setlength(E, F.ReadInt);
   for i := 0 to length(E) - 1 do
     E[i] := F.ReadInt;
end;
begin
    F := TFileIO.Create(Dir1 + 'AllStates.idx', false, true);
    for z := MinZip To MaxZip do
      for h := 0 to ZipHashMax-1 do
            ReadEntry(Hash[z, h]);
    for c := 0 to NumCities-1 do
       for h := 0 to ZipHashMax-1 do
          ReadEntry(Cities[c].Hash[h]);
    NumInverseRecs := F.ReadInt;
    setlength(InverseRecs, NumInverseRecs);
    for i := 0 to NumInverseRecs - 1 do
       begin
          InverseRecs[i].P0 := F.ReadInt;
          InverseRecs[i].X := F.ReadInt/CoorDiv;
          InverseRecs[i].Y := F.ReadInt/CoorDiv;
       end;
    F.Free;
end;

procedure  TStreetObject.UseNavData;
begin
  DataArr := @NavArr;
end;
procedure  TStreetObject.UseTigerData;
begin
  DataArr := @TigerArr;
end;

function  TStreetObject.FindInNav(Var SA : TAddress; House : integer) : boolean;
Var FoundA : TAddress;
    E : PHashEntry;
    X, Y : double;
    Approx  : boolean;
    Debug : TDebug;
    AlphaPrefix : String;
begin
   UseNavData;
   try
      AlphaPrefix := '';
      E := find(SA);
      debug.debug := false;
      if FindHouse(SA, FoundA, AlphaPrefix, 0,  House, E, X, Y, 0, Approx, Debug) then
         begin
            result := not Approx;
         end
      else
         Result := false;
   finally
      UseTigerData;
   end;
end;

procedure  TStreetObject.CheckMerge(Var SA : TAddress; Var Found, NotFound : integer);
Var  E : PHashEntry;
     i, P, P0 : integer;
     A, Next : TAddress;
     relaxed : integer;
begin
   UseNavData;
   relaxed := 0;
   try
   E := find(SA);
   for i := 0 to length(E^) - 1 do
     begin
       P := E^[i];
       P0 := P;
       ReadAddress(A, P);
       if MatchStreet(A, SA, relaxed) then
          begin
            inc(Found);
            exit;
          end;
        while ReadNextAddress(A, Next, P) do
          begin
            if  MatchStreet(Next, SA, relaxed) then
              begin
                inc(Found);
                exit;
              end;
            if not ReadNextAddress(Next, A, P) then
               break;
             if MatchStreet(A, SA, relaxed) then
              begin
                inc(Found);
                exit;
              end;
          end;
     end;
  inc(NotFound);
  finally
     UseTigerData;
  end;
end;


{procedure TStreetObject.MergeTiger;
Var A,  Next : TAddress;
    Found, NotFound, P, P0, SP, MaxP : integer;
    FLat, Flon, PLat, Plon, FromL, ToL, FromR, ToR : integer;
    AlphaPrefixL : String; AlphaPrefixR : String;
    AvenueFromR, AvenueToR : integer;
    AvenueFromL, AvenueToL : integer;
    nw, LZip, RZip : Integer;
    flag : byte;
    F : File;
begin
   P := 0;
   Found := 0;
   NotFound := 0;
//   DataIndex := length(NavArr);
   UseTigerData;
   while P < Length(TigerArr) do
     begin
       if (Found = 0) and (NotFound > 0) then
          AppendNav(P0, P);
       if DataIndex >= 654885996 then
          DataIndex := DataIndex;
       Found :=0;
       NotFound := 0;
       P0 := P;
       ReadAddress(A, P);
       CheckMerge(A, Found, NotFound);
       while ReadNextAddress(A, Next, P) do
          begin
            CheckMerge(A, Found, NotFound);
            A := Next;
          end;
       FLat := 0;
       FLon := 0;
       while true do
         begin
           SkipVertexes(P, FLat, FLon, PLat, Plon);
           while true do
             begin
               flag := ReadRange(P, FromL, ToL, FromR, ToR,
                                 AlphaPrefixL, AlphaPrefixR, AvenueFromR, AvenueToR,
                                 AvenueFromL, AvenueToL, LZip, RZip);
//               if FromL <> 0 then
//                 if not FindInNav(A, FromL) then
//                   inc(NotFound);
//               if ToL <> 0 then
///                 if not FindInNav(A, ToL) then
//                   inc(NotFound);
//               if FromR <> 0 then
//                 if not FindInNav(A, FromR) then
//                   inc(NotFound);
//               if ToR <> 0 then
//                 if not FindInNav(A, ToR) then
//                   inc(NotFound);
               if  LZip <> 0 then
                  begin
                    SP := P0;
                    ReadAddress(A, SP);
                    A.Zip := LZip;
                    CheckMerge(A, Found, NotFound);
                    while ReadNextAddress(A, Next, SP) do
                      begin
                        CheckMerge(A, Found, NotFound);
                        A := Next;
                      end;
                  end;
               if  RZip <> 0 then
                  begin
                    SP := P0;
                    ReadAddress(A, SP);
                    A.Zip := RZip;
                    CheckMerge(A, Found, NotFound);
                    while ReadNextAddress(A, Next, SP) do
                      begin
                        CheckMerge(A, Found, NotFound);
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
  AssignFile(F, Dir1 + 'AllStates.MER');
  rewrite(F, 1);
  blockwrite(F, (@NavArr[0])^, DataIndex, Nw);
  closefile(F);
end;}

procedure TStreetObject.MergeTiger;
Var A,  Next : TAddress;
    Found, NotFound, P, P0, SP, MaxP : integer;
    FLat, Flon, PLat, Plon, FromL, ToL, FromR, ToR : integer;
    AlphaPrefixL : String; AlphaPrefixR : String;
    AvenueFromR, AvenueToR : integer;
    AvenueFromL, AvenueToL : integer;
    nw, LZip, RZip : Integer;
    flag : byte;
    F : File;

procedure AppendNav(P0, P : integer);
begin
   blockwrite(F, (@TigerArr[P0])^, P - P0, Nw);
end;

begin
   P := 0;
   Found := 1;
   NotFound := 0;
   AssignFile(F, Dir1 + 'AllStates.MER');
   rewrite(F, 1);
   blockwrite(F, (@NavArr[0])^, DataIndex, Nw);
//   DataIndex := length(NavArr);
   UseTigerData;
   while P < Length(TigerArr) do
     begin
       if (Found = 0) or (NotFound > 0) then
          AppendNav(P0, P);
       if DataIndex >= 654885996 then
          DataIndex := DataIndex;
       Found :=0;
       NotFound := 0;
       P0 := P;
       ReadAddress(A, P);
       CheckMerge(A, Found, NotFound);
       while ReadNextAddress(A, Next, P) do
          begin
            CheckMerge(A, Found, NotFound);
            A := Next;
          end;
       FLat := 0;
       FLon := 0;
       while true do
         begin
           SkipVertexes(P, FLat, FLon, PLat, Plon);
           while true do
             begin
{               if NumReads = 20 then
                 NumReads := 20;}
               flag := ReadRange(P, FromL, ToL, FromR, ToR,
                                 AlphaPrefixL, AlphaPrefixR, AvenueFromR, AvenueToR,
                                 AvenueFromL, AvenueToL, LZip, RZip);
               if FromL <> 0 then
                 if not FindInNav(A, FromL) then
                   inc(NotFound);
               if ToL <> 0 then
                 if not FindInNav(A, ToL) then
                   inc(NotFound);
               if FromR <> 0 then
                 if not FindInNav(A, FromR) then
                   inc(NotFound);
               if ToR <> 0 then
                 if not FindInNav(A, ToR) then
                   inc(NotFound);
               if  LZip <> 0 then
                  begin
                    SP := P0;
                    ReadAddress(A, SP);
                    A.Zip := LZip;
                    CheckMerge(A, Found, NotFound);
                    while ReadNextAddress(A, Next, SP) do
                      begin
                        CheckMerge(A, Found, NotFound);
                        A := Next;
                      end;
                  end;
               if  RZip <> 0 then
                  begin
                    SP := P0;
                    ReadAddress(A, SP);
                    A.Zip := RZip;
                    CheckMerge(A, Found, NotFound);
                    while ReadNextAddress(A, Next, SP) do
                      begin
                        CheckMerge(A, Found, NotFound);
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
   closefile(F);
end;



procedure TStreetObject.HandleCommand(UnparsedParams : String;
                            Var ResponseInfo: String; Var ContentType : String);
Var CType : String;
begin
   ResponseInfo := ProcessQuery(UnparsedParams, false, CType, false);
   ContentType := CType;
end;

procedure DeleteFractional(Var S : String);
Var P, Pmax, p0 : integer;
begin
    p := pos('/', S);
    if p <> 0 then
       begin
          p0 := p;
          while (p < length(S)) and (S[p] <> TAB) and (S[p] <> ' ') do
            inc(p);
          pmax := p;
          p := p0;
          while (p > 0) and (S[p] <> TAB) and (S[p] <> ' ') do
            dec(p);
          inc(p);
          delete(S, p, pmax - p);
       end;
end;

function numeric(S : string) : boolean;
Var i : integer;
begin
   for i := 1 to length(S) - 1 do
     if (S[i] > '9') or (S[i] < '0') then
        begin
           result := false;
           exit;
        end;
   result := true;
end;

procedure TStreetObject.regexp_Compile(Var S: String; mode: Integer);
 Var regexp : TRegExpr;   // for regular expressions
 begin
  try
    // r.e. precompilation (then you assign Expression property,
    // TRegExpr automatically compiles the r.e.).
    // Note:
    //   if there are errors in r.e. TRegExpr will raise
    //   exception.
    regexp := TRegExpr.Create;
    if mode = 1 then
        regexp.Expression := '#[0-9A-Z ]*| PH[^A-Z].*| STE[^A-Z].*| UNIT [^ ]*| APT [^ ]*| SUITE [^ ]*| [0-9A-Za-z]* FLOOR|-[0-9][0-9]*| BLDG .*| /[^ ]*'
    else
        regexp.Expression := '# [^ ]*|#[^ ]*';
    

    S := regexp.Replace (S, '');

    regexp.Free;

    except on E:Exception do begin // exception during r.e. compilation or execution
      if E is ERegExpr then
       if (E as ERegExpr).CompilerErrorPos > 0 then begin
         // compilation exception - show place of error
         //Application.MessageBox (
         //      PChar ('Regular Expression is not valid'),
         //      PChar ('STREE Error'),
         //      MB_OK);
         //SetStatus('WARNING: Regular Expression is invalid');
        end;
      raise Exception.Create (E.Message); // continue exception processing
     end;

   end;

 end;

procedure TStreetObject.ParseStreet(Var S : String; Var A : TAddress; Var AlphaPrefix : String; Var Avenue, House : integer);
Var P, P0, PS, PE, PNum, Pref, Suf, Prefix, Suffix, FT : integer;
    Num : boolean;
    SufName : String;
begin
   //S := Interf.regexp.Replace (S, '');
   regexp_Compile(S,1);

   if (WordCount(S) >= 3) and Numeric(ExtractLastWord(S)) then
      deletelastword(S);
   DeleteFractional(S);
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
{   if R > (1-OffsetFactor) then
       R := 1-OffsetFactor;
    if R < OffsetFactor then
      R := OffsetFactor;}
   if V.Numvert = 2 then
     begin
        x1 := V.Vert[0].Lon/CoorDiv;
        y1 := V.Vert[0].Lat/CoorDiv;
        x2 := V.Vert[1].Lon/CoorDiv;
        y2 := V.Vert[1].Lat/CoorDiv;
        Dist := EarthDistMet(X1, Y1, X2, Y2);
        RR := R;
        if Dist < 2*D0Factor then
           RR := R
        else
           RR := ((Dist - 2*D0Factor)*R+D0Factor) / Dist;
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
            Dist := Dist + EarthDistMet(X1, Y1, X2, Y2);//sqrt((x1-x2) * (x1-x2) + (y1-y2) * (y1 - y2));
         end;
//       D := Dist * R;
       if Dist < 2*D0Factor then
          D := Dist * R
       else
          D := (Dist - 2*D0Factor)*R + D0Factor;
       Dist := 0;
       RR := R;
       for i := 0 to V.Numvert - 2 do
         begin
            x1 := V.Vert[i].Lon/CoorDiv;
            y1 := V.Vert[i].Lat/CoorDiv;
            x2 := V.Vert[i+1].Lon/CoorDiv;
            y2 := V.Vert[i+1].Lat/CoorDiv;
            DD := EarthDistMet(X1, Y1, X2, Y2);//sqrt((x1-x2) * (x1-x2) + (y1-y2) * (y1 - y2));
            if (Dist + DD) > D then
              begin
                RR := (D - Dist) / DD;
                break;
              end;
            Dist := Dist + DD;
         end;
     end;
   Scaley := MileY/LeftRightFactor;
   ScaleX := MileX(Y1)/LeftRightFactor;
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
//   if RR < OffsetFactor then
//     RR := OffsetFactor;
   if not Left then
     begin
       DX := -DX;
       DY := -DY;
     end;
   X := X1 + RR * (X2-X1) + DX;
   Y := Y1 + RR * (Y2-Y1) + DY;
end;

{procedure  TStreetObject.FindPoint(Var V : TVertexes; left  : boolean; R : double; Var X, Y : double);
Var i : integer;
    D, DD, RR, Dist, x1, x2, y1, y2, DX, DY, ScaleX, ScaleY, Alpha : double;
begin
   if R = 1 then
       R := 0.9;
    if R = 0 then
      R := 0.1;
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
   Scaley := MileY/60;
   ScaleX := MileX(Y1)/60;
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
   if RR < 0.1 then
     RR := 0.1;
   if not Left then
     begin
       DX := -DX;
       DY := -DY;
     end;
   X := X1 + RR * (X2-X1) + DX;
   Y := Y1 + RR * (Y2-Y1) + DY;
end;}


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
{      if Relaxed > 1 then
        result := A.CommonRec.FType = B.CommonRec.FType
      else}
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
Var i, PVert, MR, MVert, MLat, Mlon, MinDist, TotalLeft, TotalRight, STL, STR, Offset,
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

procedure CheckDist(L, R : integer; Left : boolean);
Var Found : boolean;
begin
   if L = 0 then
     exit;
   if R = 0 then
     exit;
   Found := false;
   if abs(house-L) < MinDist then
      begin
         MinDist := abs(house-L);
         MLat := PLat;
         MLon := PLon;
         MVert := PVert;
         MPLat := PPLat;
         MPLon := PPLon;
         MR := 0;
         if Odd(House) = Odd(L) then
            MLeft := Left
         else
            MLeft := not Left;
         Found := true;
      end;
   if abs(house-R) < MinDist then
      begin
         MinDist := abs(house-R);
         MVert := PVert;
         MLat := PLat;
         MLon := PLon;
         MPLat := PPLat;
         MPLon := PPLon;
         MR := 1;
         if Odd(House) = Odd(L) then
            MLeft := Left
         else
            MLeft := not Left;
         Found := true;
      end;
   if found and Debug.Debug then
      AddTrace(Debug, 'new best range : ' + inttostr(L) + '-' + inttostr(R));
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
           TotalLeft := 1;
           TotalRight := 1;
           if (House = 0) or (Relaxed > 1) then
              begin
                V.Numvert := 0;
                PVert := P;
                ReadVertexes(V, PVert, FLat, FLon, PrevLat, PrevLon);
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
               SkipVertexes(P, FLat, FLon, PrevLat, PrevLon);
               TotalLeft := 1;
               TotalRight := 1;
               while true do
                 begin
    {               if NumReads = 69 then
                     NumReads := 69;}
                   flag := ReadRange(P, FromL, ToL, FromR, ToR,
                                     AlphaPrefixL, AlphaPrefixR, AvenueFromR, AvenueToR,
                                     AvenueFromL, AvenueToL, LZip, RZip);
                   STL := TotalLeft-1;
                   STR := TOtalRight-1;
                   inc(TotalLeft, abs(ToL-FromL));
                   inc(TotalRight, abs(ToR-FromR));
                   CheckDist(FromL, ToL, true);
                   CheckDist(FromR, ToR, false);
                   if odd(House) then
                      begin
                        foundL := (odd(FromL) or odd(ToL)) and between(House, ToL, FromL) and (AlphaPrefixL = AlphaPrefix)
                                      and Between(Avenue, AvenueFromL, AvenueToL);
                        foundR := (odd(FromR) or odd(ToR)) and between(House, ToR, FromR) and (AlphaPrefixR = AlphaPrefix)
                                     and Between(Avenue, AvenueFromR, AvenueToR);
                       if Debug.Debug then
                         if FounDL then
                             AddTrace(Debug, 'found range: ' + inttostr(FromL) + '-' + inttostr(ToL))
                         else if FoundR then
                             AddTrace(Debug, 'found range: ' + inttostr(FromR) + '-' + inttostr(ToR));
                      end
                   else
                      begin
                        foundL := ((not odd(FromL)) or (not odd(ToL))) and between(House, ToL, FromL) and (AlphaPrefixL = AlphaPrefix)
                                      and Between(Avenue, AvenueFromL, AvenueToL);
                        foundR := ((not odd(FromR)) or (not odd(ToR))) and between(House, ToR, FromR) and (AlphaPrefixR = AlphaPrefix)
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
//                               inc(TotalLeft, abs(ToL-FromL));
//                               inc(TotalRight, abs(ToR-FromR));
                             end;
                       V.NumVert := 0;
                       ReadVertexes(V, PVert, PLat, PLon, PPLat, PPLon);
                       if foundL then
                          begin
{                             DL := ToL - FromL;
                             if DL = 0 then
                               DL := 1;}
                             R := STL/TotalLeft + DL/TotalLeft;
                          end;
                       if foundR then
                          begin
{                            DR := ToR - FromR;
                            if DR = 0 then
                              DR := 1;}
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
       ReadVertexes(V, MVert, MLat, MLon, MPLat, MPLon);
       FindPoint(V, MLeft, MR, X, Y);
       if Debug.Debug then
          AddTrace(Debug, 'Applying the best approximate range');
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

procedure  SplitCityStateZip(Var City : String; Var C, IState, Z : integer; ZipPrty :boolean);
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
   C := -1;
   P := length(City);
   pp := P;
   if not ZipPrty then
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
   P := length(City);
   pp := P;
   while P > 0 do
     begin
       if City[p] = ' ' then
         begin
           if Z = 0 then
             begin
               ZZ := ValZip(copy(City, p + 1, pp - p));
               if (ZZ >= Minzip) and (ZZ <= MaxZip) then
                  begin
                    City := Copy(City, 1, p - 1);
                    Z := ZZ;
                    exit;
                  end;
             end;
           pp := p - 1;
         end;
       dec(p);
     end;
   if Z = 0 then
      Z := ValZip(City);
end;

procedure deletechar(C : char; Var S : string);
Var P : integer;
begin
  repeat
     P := pos(c, s);
     if P > 0 then
       delete(S, P, 1);
  until P = 0;
end;


function TStreetObject.findProperty(AddrField : integer; LatLonField : integer; rObject : TWebObject; Var street : TStreetData; Var X, Y : double; Var Approx : integer; NumFind : integer) : boolean;
Var Ctype, Prop, Lat, Lon, Line : string;
    P, pp : integer;
    S : TStreetData;
begin
     Result := false;
     if rObject = nil then
        exit;
     CType := '';
     Prop := rObject.ProcessQuery('x1=' + CoorStr1(X) + '&y1=' + CoorStr(Y)  + '&d=0.4&numfind=' + Inttostr(NumFind), false, ctype, false);
     pp := 1;
     while pp < length(Prop) do
       begin
         ScanLine(Prop, pp, Line);
         P := 1;
         SkipFields(Line, AddrField, P);
         ExtractField(Line, S.Street, P);
         Standartize(S.Street);
         replacewords(S.Street);
         //ParseStreetData(S);  JAB, fix error when parameters are specified city=, zip= ...
         ParseStreet(S.Street, S.A, S.AlphaPrefix, S.Avenue, S.House);
         if (S.House = Street.House) and (S.A.CommonRec.CombinedDir = Street.A.CommonRec.CombinedDir)
           and (S.A.CommonRec.FType = Street.A.CommonRec.FType)
           and (S.A.Name = Street.A.Name) then
            begin
               P := 1;
               SkipFields(Line, LatLonField, P);
               ExtractField(Line, Lat, P);
               ExtractField(Line, Lon, P);
               X := ReadDouble(Lon);
               Y := ReadDouble(Lat);
               Approx := A_Exact;
               Result := true;
               exit;
            end;
       end;
end;

procedure TStreetObject.locateProperty(Var Street : string; Var X, Y : double; Var Approx : integer);
Var Ctype, Prop, Addr, Lat, Lon, Line : string;
    P, pp : integer;
    S : TStreetData;
begin
     if Street = '' then
       exit;
     S.Street := Street;
     //ParseStreetData(S);   JAB, fix error when parameters are specified city=, zip= ...
     ParseStreet(S.Street, S.A, S.AlphaPrefix, S.Avenue, S.House);   // Added : JAB, fix error when parameters are specified city=, zip= ...
     if rFLPropertiesObject = nil then
        exit;
     if findProperty(98, 156, rFLPropertiesObject, S, X, Y, Approx, 100) then
        exit;
     if findProperty(99, 156, rFLPropertiesObject, S, X, Y, Approx, 100) then
        exit;
     if findProperty(3, 61, rnfolioObject, S, X, Y, Approx, 100) then
        exit;
     //if findProperty(64, 121, rFLPropertiesObject, S, X, Y, Approx, 100) then
     //   exit;
     //if findProperty(65, 121, rFLPropertiesObject, S, X, Y, Approx, 100) then
     //   exit;

     if findProperty(11, 205, rOwnershipObject, S, X, Y, Approx, 70) then
        exit;
end;

// Routine to find streets for rooftop geocoding

procedure TStreetObject.locateProperty_nationwide(Var Street : string; Var X, Y : double; Var Approx : integer; zipf : string; var cleansed_add : string);
Var Ctype, Prop, Addr, Lat, Lon, Line : string;
    P, pp : integer;
    S : TStreetData;
    partition : string;
begin
     if Street = '' then
       exit;
     S.Street := Street;
     //ParseStreetData(S);
     ParseStreet(S.Street, S.A, S.AlphaPrefix, S.Avenue, S.House);
     if first_americanobject = nil then
        exit;
     partition :=  'firstamerican_points';

     //if findProperty_nationwide(6, 19, first_americanobject, S, X, Y, Approx, 400,partition) then
     //if findProperty_nationwide(7, 18, zip_americanobject, S, X, Y, Approx, 400,partition,zipf) then
     if findProperty_nationwide(0, 3, zip_americanobject, S, X, Y, Approx, 400,partition,zipf,cleansed_add) then
        exit;
     {***  Ariel implemented a solution to unify this thing, not optimal of course but at least is something. Now I have implemented something near optimal  
     partition :=  'firstamerican_points_pt2';
     if findProperty_nationwide(6, 19, first_americanobject, S, X, Y, Approx, 400,partition) then
        exit;
     partition :=  'firstamerican_points_pt3';
     if findProperty_nationwide(6, 19, first_americanobject, S, X, Y, Approx, 400,partition) then
        exit;
     partition :=  'firstamerican_points_pt4';
     if findProperty_nationwide(6, 19, first_americanobject, S, X, Y, Approx, 400,partition) then
        exit;
     ****}
end;
// Routine for finding the corresponding bucket on the external hash JAB
function TStreetObject.getFileName(s : string ; create: boolean): string;
var  res : array of string;
     l, key_length,i : integer;
     s1, base, text : string;
     myFile : TextFile;
begin
     key_length := 2;
     base := 'D:\FAPD\data';
     //l := s.length()/key_length;
     l := Trunc(Length(s) / key_length);
     //l := Round(Length(s) / key_length);
     //if (s.length() - (l*key_length) != 0) l +=1;

     if  (Length(s) - l * key_length) <> 0 then
        l := l + 1;
     SetLength(res, l);
     //String [] res = new String[l];
     s1 := s;
     i := l;

     //while(i>0){
     while i > 0 do
     begin

       //if(s1.length() > key_length) {
       if Length(s1) > key_length then
       begin
         //res[i-1] = s1.substring(s1.length()-key_length);
         res[i-1] := copy(s1,Length(s1)-key_length+1, Length(s1));
         //s1 = s1.substring(0, s1.length()-key_length);
         s1 := copy(s1,0,Length(s1) - key_length);
       end
       //else res[i-1] = s1;
       else
            res[i-1] := s1;
       //i--;
       i := i -1;
     end;
     //s1 = base;
    s1 := base;

    //if(s1.endsWith("\\")) s1 = s1.substring(0, s1.length()-1);

    // while(i < l-2){
    while i < l-2 do
    begin
       //s1 = s1+'\\'+res[i];
       s1 := s1 + '\' + res[i];

       {
       File f = new File(s1);
       if(!f.exists())
         if(create) f.mkdir();
       else return null;
       }
       i := i + 1;
     end;
    if FileExists(s1 + '\' + res[i] + '.dat') then
    begin         /// Critical part, this should be very fast, enough to keep feasible times. Assuming stored sequentially
                  /// so that disk scheduler retrieve the whole sector.
         AssignFile(myFile, s1 + '\' + res[i] + '.dat');
         Reset(myFile);
         while not Eof(myFile) do
         begin
                ReadLn(myFile, text);
                Result := Result + text + #13#10;
         end;
         CloseFile(myFile);
    end
    else Result := '';

end;
//Routine for splitting zip codes. The issue here has 2 solutions: generate a record for each zip code available or
//get the list of possible zip codes and append the records to look for them. The probability of that file to be big enough is
// small.
function TStreetObject.getallprops(X, Y : double; house : string; rObject : TWebObject): string;
var
  SL : TStringList;
  map : TStringList;
  i : integer;
  zipf, StateName, cityname, inf : string;
  prop : string;
  ctype : string;
  keymap : string;
  zipn : integer;
begin
  ctype := '';
  SL := TStringList.Create;
  map := TStringList.Create;

  zipf := rObject.ProcessQuery('x1=' + CoorStr1(X) + '&y1=' + CoorStr(Y), false, ctype, false);

  try
    prop := '';
    SL.Delimiter := ' ';
    //SL.StrictDelimiter := True;
    SL.DelimitedText := zipf;
    if SL.Count > 1 then  //empty zipcodes
    begin
        for i := 0 to SL.Count - 2 do   //skip last one
        begin
        // do whatever with sl[i];
                map.Values[sl[i]] := sl[i];
                //prop := prop + getFileName(sl[i]+house, False);
        end
    end;
    Zipn := IZipObject.FindZip(Y, X, false);




    zipf := SysUtils.Format('%.*d', [5, Zipn]);  // add leading zeros to zip code
    map.Values[zipf] := zipf;

    for i := 0 to map.Count - 1 do   //skip last one
        begin
        // do whatever with sl[i];
                keymap := map.ValueFromIndex[i] + house;
                prop := prop + getFileName(keymap, False);
        end;

    result := prop;
  finally
   SL.Free;
   map.Free;
  end;
end;


//Routine for finding properties nationwide  JAB
function TStreetObject.findProperty_nationwide(AddrField : integer; LatLonField : integer; rObject : TWebObject; Var street : TStreetData; Var X, Y : double; Var Approx : integer; NumFind : integer; Var partition : string; zipf : string; Var cleansed_add : string) : boolean;
Var Ctype, Prop, Lat, Lon, Line , filename: string;
    P, pp, zipn : integer;
    S : TStreetData;
    zips, statename,cityname, inf: string;
begin
     Result := false;
     if rObject = nil then
        exit;
     CType := '';
     {if zipf = '' then
     begin
          //zipf := rObject.ProcessQuery('x1=' + CoorStr1(X) + '&y1=' + CoorStr(Y), false, ctype, false);
          //zipf := copy(zipf,0,5);     NO NEED THIS, there is a zip object :) I just realized.
          Zipn := IZipObject.FindZip(Y, X, false);
          zipf := SysUtils.Format('%.*d', [5, Zipn]);  // add leading zeros to zip code
          //zipf := inttostr(Zipn);
     end;}

     Prop := getallprops(X,Y,inttostr(Street.House),rObject);
     //Prop := getFileName(zipf+inttostr(Street.House), False);

     //Prop := rObject.ProcessQuery('category='+partition+'&x1=' + CoorStr1(X) + '&y1=' + CoorStr(Y)  + '&d=0.4&numfind=' + Inttostr(NumFind), false, ctype, false);
     pp := 1;
     while pp < length(Prop) do
       begin
         ScanLine(Prop, pp, Line);
         P := 1;
         SkipFields(Line, AddrField, P);
         ExtractField(Line, S.Street, P);
         //S.Street := S.Street + ' MIAMI FL';
         //S.Street := UpperCase(S.Street);  // JAB to capital letters
         //ParseStreetData(S);
         Standartize(S.Street);
         replacewords(S.Street);
         ParseStreet(S.Street, S.A, S.AlphaPrefix, S.Avenue, S.House);
         if (S.House = Street.House) and (S.A.CommonRec.CombinedDir = Street.A.CommonRec.CombinedDir)
           and (S.A.CommonRec.FType = Street.A.CommonRec.FType)
           and (S.A.Name = Street.A.Name) then
            begin
               P := 1;
               SkipFields(Line, LatLonField, P);
               ExtractField(Line, Lat, P);
               ExtractField(Line, Lon, P);
               X := ReadDouble(Lon);
               Y := ReadDouble(Lat);
               Approx := A_Prop;

               P := 1;
               SkipFields(Line, AddrField + 2, P);
               ExtractField(Line, cleansed_add, P);

               P:= 1;
               SkipFields(Line, AddrField + 1, P);
               ExtractField(Line, zips, P);
               zipn := strtoint(zips);
               inf := IzipObject.ZipCodes[Zipn].Info;
               ExtractCommaByNum(inf, 2, CityName);
               ExtractCommaByNum(inf, 3, StateName);
               cleansed_add := cleansed_add + TAB + cityname + TAB + statename + TAB + zips;

               Result := true;
               exit;
            end;
         // check for field 12 which might have a better formatted address. Now is field 3
         P := 1;
         //SkipFields(Line, AddrField + 5, P);
         SkipFields(Line, AddrField + 2, P);
         ExtractField(Line, S.Street, P);
         Standartize(S.Street);
         replacewords(S.Street);
         ParseStreet(S.Street, S.A, S.AlphaPrefix, S.Avenue, S.House);
         if (S.House = Street.House) and (S.A.CommonRec.CombinedDir = Street.A.CommonRec.CombinedDir)
           and (S.A.CommonRec.FType = Street.A.CommonRec.FType)
           and (S.A.Name = Street.A.Name) then
            begin
               P := 1;
               SkipFields(Line, LatLonField, P);
               ExtractField(Line, Lat, P);
               ExtractField(Line, Lon, P);
               X := ReadDouble(Lon);
               Y := ReadDouble(Lat);
               Approx := A_Prop;

               P := 1;
               SkipFields(Line, AddrField + 2, P);
               ExtractField(Line, cleansed_add, P);

               P:= 1;
               SkipFields(Line, AddrField + 1, P);
               ExtractField(Line, zips, P);
               zipn := strtoint(zips);
               inf := IzipObject.ZipCodes[Zipn].Info;
               ExtractCommaByNum(inf, 2, CityName);
               ExtractCommaByNum(inf, 3, StateName);
               cleansed_add := cleansed_add + TAB + cityname + TAB + statename;

               Result := true;
               exit;
            end;

       end;
end;


procedure TStreetObject.ParseStreetData(Var S : TStreetData);
Var  P : integer;
     City, State : string;
begin
   Standartize(S.Street);
   replacewords(S.Street);
   SplitCityStateZip(S.Street, S.ICity, S.IState, S.Zip, false);
   P := length(S.Street);
   while P > 0 do
     begin
       while (P > 0) and (S.Street[P] <> ' ') do
          dec(p);
       City := copy(S.Street, P+1, length(S.Street) - P);
       S.ICity := FindCity(City, S.IState, true);
       if S.ICity >= 0 then
         begin
           S.Street := copy(S.Street, 1, P-1);
           //S.Street := Interf.regexp.Replace (S.Street, '');
           regexp_Compile(S.Street,1);
           break;
         end;
       dec(p);
     end;
   ParseStreet(S.street, S.A, S.AlphaPrefix, S.Avenue, S.House);
end;

function  TStreetObject.FindHouseByZip(street, zip, City, State : String;
           Var X, Y : double; Var Approx : integer; Var Debug : TDebug; Var Error : String; ZipPrty : boolean) : boolean;
Var Z, C, FoundCity, k, Avenue, P, House, IState : integer;
    A, FA : TAddress;
    E : PHashEntry;
    AlphaPrefix : String;
    FoundStreet, SaveStreet, SS, LW, sf : String;
    App, OK, R : boolean;
    lsf, cont_c ,fakecity, fakestate, fakezip, Approx_prev: integer;
    X_prev, Y_prev : double;
begin
//   Interf.SetStatus('Street: ' + Street + ' Zip: ' + Zip);
   Error := '';

   if ZipPrty = true then //JAB Begin. we want to keep previous coordinates so that subsequent failing zip lookup do not mess with what I've already found
        begin
                X_prev := X;
                Y_prev := Y;
                Approx_prev := Approx;
        end;   // END. JAB
   X := 0;
   y := 0;
   Result := false;
   try
   Standartize(Street);
   replacewords(Street);
   Z := ValZip(zip);
   if (Z < MinZip) or (Z > MaxZip) then
     Z := 0;
   if (Z=0) and (City='') and (State='') then
      begin

         SplitCityStateZip(Street, C, IState, Z, ZipPrty);
         FoundCity := C;  // JAB no city yet found, C is OK, could be -1 or actual city
         City := Street;
         P := length(Street);
         while P > 0 do
           begin
             while (P > 0) and (Street[P] <> ' ') do
                dec(p);
             if ZipPrty = true then //JAB Begin
                begin
                    sf := iZipObject.ZipCodes[Z].info;
                    lsf := length(sf);
                    cont_c := 2;
                    while (cont_c < lsf) and (sf[cont_c] <> ',') do
                         inc(cont_c);
                    City := copy(sf,2,cont_c-2);
                    IState := DirStates.Find(copy(sf, cont_c+1, 2));
                    C := FindCity(City, IState, true);
                    if C >= 0 then
                        begin
                                fakecity := -1;
                                fakestate := -1;
                                fakezip := 0;
                                SplitCityStateZip(Street, fakecity, fakestate, fakezip, false);  ///get street like this were the first one
                                FoundStreet := Street;  // this one is the very first, incorruptible
                                FoundCity := C;
                                break;
                        end;
                end
             else
                City := copy(Street, P+1, length(Street) - P);      //JAB End. This line was alone

             C := FindCity(City, IState, true);
             if C >= 0 then
               begin
                 FoundStreet := copy(Street, 1, P-1);
                 //FoundStreet := Interf.regexp.Replace (FoundStreet, '');
                 regexp_Compile(FoundStreet,1);
                 FoundCity := C;
//                 break;
               end;
             dec(p);
           end;
         Street := FoundStreet;
         C := FoundCity;

      end
   else
      begin
       if Debug.Debug then AddTrace(Debug,'Standardized street ' + Street);
       Standartize(Zip);
       if Debug.Debug then AddTrace(Debug,'Zip: ' + Zip);
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
             SplitCityStateZip(City, C, IState, Z, ZipPrty);
           C := FindCity(City, IState);
         end;
      end;

   ParseStreet(Street, A, AlphaPrefix, Avenue, House);
   if Street <> '' then  // If the captured street is valid, no need to reassign an empty street when looking for zip
        street_nationw  := Street;  //for nation wide parcels JAB
   if Debug.Debug then AddTrace(Debug,AddressToStr(A));
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
             X := -80.193573;  // JAB. This used to return 0, Dr Rishe changed to miami
             Y := 25.773941;   // JAB. This used to return 0
             Approx := A_NotFound;
             if ZipPrty = true then //JAB Begin. For some reason it could not find zip code BUT previous coord. are still valid
               begin
                   X := X_prev;
                   Y := Y_prev;
                   Approx := Approx_prev;

               end;
             Result := false;
           end;
         exit;
      end;
   if ((Z < MinZip) or (Z > MaxZip)) and (C = 0) then
     begin
       //X := 0;
       //Y := 0;
       X := -80.193573;  // JAB. This used to return 0, Dr Rishe changed to miami
       Y := 25.773941;   // JAB. This used to return 0
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
               Approx := A_Approx;
            result := true;
            exit;
          end;
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
             if not R then
                deletechar('-', Street);
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
             result := FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, 0, App, Debug);
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
                  if FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, 0, App, Debug) then
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
                  if FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, 0, App, Debug) then
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
{                   if C >= 0 then
                     begin
                       E := FindByCity(A, C);
                       result := FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, 2, App, Debug);
                       if result and (not app) then
                          exit;
                     end;}
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
                 if (not Result) and (Z >= MinZip) then
                 for k := 0 to length(ZipCity[Z]) - 1 do
                   if Cities[ZipCity[Z][k]].NumZips > 1 then
                      begin
                         E := findbycity(A, ZipCity[z][k]);
                         if Debug.Debug then AddTrace(Debug,'Looking approx match in the city: ' + Cities[ZipCity[Z][k]].Name);
                         result := FindHouse(A, FA, AlphaPrefix, Avenue, House, E, X, Y, 0, App, debug);
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
       savestreet := street;
       if (not result) then
         begin
            Street := Savestreet + ' AVE';
            ParseStreet(Street, A, AlphaPrefix, Avenue, House);
            if Z >= MinZip then
              E := find(A)
            else
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
            Street := Savestreet + ' ST';
            ParseStreet(Street, A, AlphaPrefix, Avenue, House);
            if Z >= MinZip then
              E := find(A)
            else
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
            if Z >= MinZip then
              E := find(A)
            else
              E := findbyCity(A, C);
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
                 //X := 0;
                 //Y := 0;
                 X := -80.193573;  // JAB. This used to return 0, Dr Rishe changed to miami
                 Y := 25.773941;   // JAB. This used to return 0
                 Approx := A_NotFound;
                 Result := false;
               end;
          end;
      end
   else
     begin
        //X := 0;
        //Y := 0;
        X := -80.193573;  // JAB. This used to return 0, Dr Rishe changed to miami
        Y := 25.773941;   // JAB. This used to return 0
        Approx := A_NotFound;
        result := false;
     end;
   finally
//     Interf.SetStatus('X: ' + CoorStr(X) + ' Y: ' + CoorStr(Y));
   end;

end;

function MapUrl1(Header : String; X,Y : String) : STring;
begin
  result := '<a href="http://maps.yahoo.com/py/maps.py?Ds=n&BFCat=&Pyt=Tmap&state=FL&slt=' + Y +'&sln=' + X +
  '&mag=9&cs=9&BFClient=&BFKey=&poi=&poititle=&map.x=184&map.y=196">' + Header + '</a>';
end;

function MapUrl(Header : String; X,Y : double) : STring;
begin
  result := MapUrl1(Header, Coorstr1(x), CoorStr1(y));
end;


// from the http://astronomy.swin.edu.au/~pbourke/geometry/pointline/
function DistanceToLine(X, Y : single; xx1, yy1, xx2, yy2 : integer; Var U : single; Var Left : boolean; Var Leg : Single; Var Intersection : XYZ) : single;
Var   x1, y1, x2, y2 : single;
    Point,LineStart, LineEnd : XYZ;
    LX, LY, PX, PY : single;
    MX : single;
function Magnitude(Var Point1, Point2 : XYZ) : single;
Var Vector : XYZ;
begin
    Vector.X := (Point2.X - Point1.X)/MX;
    Vector.Y := (Point2.Y - Point1.Y)/MileY;
//    Vector.Z = Point2->Z - Point1->Z;
    result := sqrt( Vector.X * Vector.X + Vector.Y * Vector.Y );
end;
begin
   MX := MileX(Y);
   Point.X := X;
   Point.Y := Y;
   LineStart.x := xx1/Coordiv;
   LineStart.y := yy1/Coordiv;
   LineEnd.x := xx2/Coordiv;
   LineEnd.y := yy2/Coordiv;
   LX := (LineEnd.X - LineStart.X)/MX;
   LY := (LineEnd.Y - LineStart.Y)/MileY;
   PX := (Point.X - LineStart.X)/MX;
   PY := (Point.Y - LineStart.Y)/MileY;
   Left := (LX*PY - LY*PX) > 0;
   Leg := Magnitude(LineEnd, LineStart);
   U := (PX*LX + PY*LY)/(Leg*Leg);
   if U < 0 then
       begin
         result := Magnitude(Point, LineStart);
         Intersection := LineStart;
         U := 0;
         exit;
       end
    else if U > 1 then
      begin
        U := 1;
        result := Magnitude(Point, LineEnd);
        Intersection := LineEnd;
        exit;
      end;
    Intersection.X := LineStart.X + U * ( LineEnd.X - LineStart.X );
    Intersection.Y := LineStart.Y + U * ( LineEnd.Y - LineStart.Y );
//    Intersection.Z = LineStart->Z + U * ( LineEnd->Z - LineStart->Z );
    result := Magnitude(Point, Intersection);
end;


function SameDir(Dir1, Dir2 : double) : boolean;
begin
   if Abs(Dir1 - Dir2) < 22.5 then
      result :=  true
   else if (Abs(Dir1-Dir2) < (180+22.5)) and (Abs(Dir1-Dir2) > (180-22.5)) then
       result := true
   else
      result := false;
end;

procedure AddRec(Var List : TStreetRecs; Var Rec : TStreetRec);
Var i : integer;
begin
   for i := 0 to length(List) - 1 do
      if (List[i].A.CommonRec.Ftype = Rec.A.CommonRec.Ftype) and (List[i].A.Name = Rec.A.Name) and SameDir(List[i].StreetDir, Rec.StreetDir) then
        begin
           if List[i].MinD > Rec.MinD then
              List[i] := Rec;
           exit;
        end;
   Setlength(List, length(List) + 1);
   i := length(list) - 1;
   List[i] := Rec;
end;

function GetDirection(x, y, x1, y1 : single) : double;
Var offset : double;
begin
   result := calcheading(x1, y1, x, y) * 180 / PI;
end;


procedure SortList(Var List : TStreetRecs; x, y : single);
Var i, index : integer;
    Dir : double;
    L : TStreetRec;
  procedure QuickSort1(L, R: Integer);
  var
    I, J: Integer;
    X, T: TStreetRec;
  begin
      I := L;
      J := R;
      X := List[(L + R) div 2];
      repeat
        while List[I].MinD < X.MinD do
          Inc(I);
        while List[j].MinD > X.MinD do
          Dec(J);
        if I <= J then
        begin
          T := List[I];
          List[I] := List[J];
          List[J] := T;
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then
        QuickSort1(L, J);
      if I < R then
        QuickSort1(I, R);
  end;
begin
   if Length(List) > 1 then
      QuickSort1(0, length(List) - 1)
   else
      exit;
   Dir := GetDirection(x,y, List[0].Intersection.X, List[0].Intersection.Y);
{   index := 1;
   i := 1;
   while i < length(List) do
      if Not SameDir(Dir, GetDirection(x,y, List[i].Intersection.X, List[i].Intersection.Y)) then
         begin
            Dir := GetDirection(x,y, List[i].Intersection.X, List[i].Intersection.Y);
            if i > index then
              begin
                L := List[i];
                List[i] := List[index];
                List[index] := L;
              end;
            inc(index);
            i := index;
         end
      else
         inc(i);}
end;

const _deb : integer = 0;
function TStreetObject.MinDistance(Obj : integer; X, Y : single; Var List : TStreetRecs) : single;
Var i, FLat, FLon, PLat, PLon : integer;
    H, Leg, U, Total, D, R, MinU : single;
    V : TVertexes;
    A, Next : TAddress;
    P, P0, T : integer;
    INT : XYZ;
    MinL, Left, IsMin : boolean;
    flag : byte;
    FromL, ToL, FromR, ToR : integer;
    AlphaPrefixL : String; AlphaPrefixR : String;
    AvenueFromR, AvenueToR : integer;
    AvenueFromL, AvenueToL : integer;
    LZip, RZip : integer;
    Rec : TStreetRec;
{    AA: TAddress;
    House, RangeFrom, RangeTo, Zip : integer;
    Intersection : XYZ;}
begin
   P := InverseRecs[Obj].P0;
   ReadAddress(A, P);
   Rec.A := A;
   while ReadNextAddress(A, Next, P) do
        A := Next;
   FLat := 0;
   FLon := 0;
   Rec.MinD := 1e20;
   while true do
     begin
       MinU := 0;
       Total := 0;
       V.NumVert := 0;
       ReadVertexes(V, P, FLat, FLon, PLat, Plon);
       IsMin := false;
       for i := 1 to V.NumVert - 1 do
         begin
             inc(_deb);
             D := DistanceToLine(X, Y, V.Vert[i-1].Lon, V.Vert[i-1].Lat, V.Vert[i].Lon, V.Vert[i].Lat, U, Left, Leg, Int);
             if D < Rec.MinD then
                begin
                  Rec.MinD := D;
                  MinU := Total + Leg * U;
                  MinL := Left;
                  IsMin := true;
                  Rec.Intersection := Int;
                  Rec.StreetDir :=GetDirection(V.Vert[i-1].Lon/CoorDiv, V.Vert[i-1].Lat/CoorDiv, V.Vert[i].Lon/CoorDiv, V.Vert[i].Lat/CoorDiv);
                end;
             Total := Total + Leg;
         end;
       R := MinU/Total;
       P0 := P;
       T := 0;
       while true do
         begin
           flag := ReadRange(P, FromL, ToL, FromR, ToR,
                             AlphaPrefixL, AlphaPrefixR, AvenueFromR, AvenueToR,
                             AvenueFromL, AvenueToL, LZip, RZip);
           if (MinL or (FromR = 0) or (ToR = 0)) and (FromL <> 0) and (Tol <> 0) then
              T := T + abs(FromL - ToL)
           else
              T := T + abs(FromR - ToR);
           if (flag and FL_End) <> 0 then
              break;
         end;
       if IsMin then
         begin
           P := P0;
           D := round(T * R);
           while true do
             begin
               flag := ReadRange(P, FromL, ToL, FromR, ToR,
                                 AlphaPrefixL, AlphaPrefixR, AvenueFromR, AvenueToR,
                                 AvenueFromL, AvenueToL, LZip, RZip);
               if (MinL or (FromR = 0) or (ToR = 0)) and (FromL <> 0) and (Tol <> 0) then
                  D := D - abs(FromL - ToL)
               else
                  D := D - abs(FromR - ToR);
               if D <= 0 then
                  begin
                     if (MinL or (FromR = 0) or (ToR = 0)) and (FromL <> 0) and (Tol <> 0)
                     {(MinL and (FromL <> 0) and (ToL <> 0)) or (FromR = 0)} then
                       begin
                          D := D + abs(FromL - ToL);
                          if FromL <> ToL then
                            H := FromL + (ToL - FromL)*D/abs(FromL - ToL)
                          else
                            H := FromL;
                          if odd(FromL) then
                             if odd(trunc(H)) then
                                Rec.House := TRunc(H)
                             else
                                Rec.House := Trunc(H) + 1
                          else if not odd(trunc(H)) then
                             Rec.House := Trunc(H)
                          else
                             Rec.House := Trunc(H) + 1;
                          Rec.RangeFrom := FromL;
                          Rec.RangeTo := ToL;
                          Rec.Zip := LZip;
                       end
                     else
                       begin
                          D := D + abs(FromR - ToR);
                          if FromR <> ToR then
                            H := FromR + (ToR - FromR)*D/abs(FromR - ToR)
                          else
                            H := FromR;
                          if odd(FromR) then
                             if odd(trunc(H)) then
                                Rec.House := TRunc(H)
                             else
                                Rec.House := Trunc(H) + 1
                          else if not odd(trunc(H)) then
                             Rec.House := Trunc(H)
                          else
                             Rec.House := Trunc(H) + 1;
                          Rec.RangeFrom := FromR;
                          Rec.RangeTo := ToR;
                          Rec.Zip := RZip;
                       end;
                  end;
               if (flag and FL_End) <> 0 then
                  break;
             end;
         end;
       if (flag and FL_Last) <> 0 then
          break;
     end;
   AddRec(List, Rec);
   result := Rec.MinD;
end;

function TStreetObject.GetStreetDescription(Var Rec : TStreetRec; x, y : single; friendly : boolean) : string;
Var State, City, S, Dir : String;
    offset : double;
    m, k, kk : integer;
begin
   MakeStreet(Rec.A, S);
   Dir := calculateDirAndOffset(-calcheading(x, y, Rec.Intersection.x, Rec.Intersection.y), Offset);
   M := 0;
   kk := 0;
   for k := 0 to length(ZipCity[Rec.A.Zip]) - 1 do
     if Cities[ZipCity[Rec.A.Zip][k]].NumZips > M then
        begin
           M := Cities[ZipCity[Rec.A.Zip][k]].NumZips;
           kk := k;
        end;
   if length(ZipCity[Rec.A.Zip]) = 0 then
      begin
        City := '';
        State := '';
      end
   else
      begin
        City := Cities[ZipCity[Rec.A.Zip][kk]].Name;
        State := DirStates.GetName(Cities[ZipCity[Rec.A.Zip][kk]].State);
      end;
   if friendly then
     result := inttostr(Rec.House) + ' ' + S + ', ' + City + ', ' + State + ' ' + inttostr(Rec.A.Zip) + ', US'
   else
     result := inttostr(Rec.House) + ' ' + S + TAB+ inttostr(Rec.House) + TAB + inttostr(Rec.RangeFrom) + TAB + inttostr(Rec.RangeTo) + TAB +
      S + TAB + City + TAB + State + TAB + inttostr(Rec.A.Zip) + TAB +
      coorstr(Rec.Intersection.y) + TAB + coorstr(Rec.Intersection.x) + TAB + inttostr(round(Rec.MinD*MetersPerMile)) + TAB + DIR + TAB + inttostr(round(Offset)) + TAB + 'street';
{   result := inttostr(round(Rec.MinD*MetersPerMile)) + TAB + 'm' + TAB + Dir + TAB + 'of' + TAB +
      inttostr(Rec.House) + TAB + '(' + inttostr(Rec.RangeFrom) + '-' + inttostr(Rec.RangeTo) + ')' +
      TAB + S + TAB + Cities[ZipCity[Rec.A.Zip][kk]].Name + TAB + DirStates.GetName(Cities[ZipCity[Rec.A.Zip][kk]].State) + TAB + inttostr(Rec.A.Zip);
      }
end;


function TStreetObject.GetCity(x1, y1 : double) :string;
var dist : double;
    inf, StateName, StateRec, City, CountryCode, StateCode, CountryName, CityCode, CityName, CountryRec : string;
    M, k, kk, Z : integer;
begin
    CountryRec := TShapeObject(icountryobject).FindNearest(x1, y1, Dist);
    if Dist > 100 then
      begin
//         CountryCode := 'Ocean';
         CountryName := 'Ocean';
//         CityCode := '';
         StateCode := '';
      end
    else
      begin
        ExtractFieldByNum(CountryRec, 8, CountryCode);
        if CountryCOde = '' then
          begin
            ExtractFieldByNum(CountryRec, 3, CountryCode);
          end;
        ExtractFieldByNum(CountryRec, 1, CountryName);
      end;
    iCityObject.FindCity(x1, y1, City, Dist);
    if Dist < 100 then
      begin
        ExtractFieldByNum(City, 1, CityCode);
        ExtractFieldByNum(City, 2, CityName);
      end
   else
      begin
        CityCode := '';
        CityName := '';
      end;
  Z := IZipObject.FindZIp(y1, x1, false);
  if Z <> 0 then
    CountryCode := 'US';
  if CountryCode = 'US' then
   begin
       if Z = 0 then
          Z := IZipObject.FindZIp(y1, x1);
       if EarthDistMil(x1,y1, IzipObject.ZipCodes[Z].cx, IzipObject.ZipCodes[Z].cy) > 100 then
          begin
            StateRec := TShapeObject(istateObject).FindNearest(x1, y1, Dist);
            ExtractFieldByNum(StateRec, 2, StateName);
            ExtractFieldByNum(StateRec, 1, StateCode);
          end
       else
          begin
             if length(ZipCity[Z]) = 0 then
                begin
                   inf := IzipObject.ZipCodes[Z].Info;
                   ExtractCommaByNum(inf, 2, CityName);
                   ExtractCommaByNum(inf, 4, StateName);
                end
             else
                begin
{                   inf := IzipObject.ZipCodes[Z].Info;
                   ExtractCommaByNum(inf, 2, CityName);
                   ExtractCommaByNum(inf, 4, StateName);}
                 kk := 0;
                 M := 0;
                 for k := 0 to length(ZipCity[Z]) - 1 do
                   if Cities[ZipCity[Z][k]].NumZips > M then
                      begin
                         M := Cities[ZipCity[Z][k]].NumZips;
                         kk := k;
                      end;
                  CityName := Cities[ZipCity[Z][kk]].Name;
                  StateName := DirStates.GetName(Cities[ZipCity[Z][kk]].State);
                end;
          end;
   end;
   if CityName <> '' then
      result := CityName;
   if StateName <> '' then
      begin
        if result <> '' then
           result := result + ', ' + StateName
        else
           result := StateName;
      end;
   if Z <> 0 then
      result := result + ' ' + zipstr(Z);
   if CountryName <> '' then
      begin
        if result <> '' then
           result := result + ', ' + CountryName
        else
           result := CountryName;
      end;
end;

function TStreetObject.Find2Streets(x1, y1: double; friendly : boolean) : string;
Var SI : TStreeIterator;
    Obj, Obj1, Obj2 : dword;
    Min2, D, Min : single;
    cnt : integer;
    A, A1, A2: TAddress;
    House, House1, House2 : integer;
    RangeFrom, RangeFrom1, RangeFrom2 : integer;
    Intersection, Intersection1, Intersection2 : XYZ;
    M, RangeTo, RangeTo1, RangeTo2 : integer;
    i, Zip, Zip1, Zip2 : integer;
    List : TStreetRecs;
    xx1, yy1 : double;
begin
  _deb := 0;
  xx1 := x1;
  yy1 := y1;
  {if X1 < MinX then
    X1 := MinX;
  if X1 > MaxX then
    X1 := MaxX;
  if Y1 > MaxY then
    Y1 := MaxY;
  if Y1 < MinY then
    Y1 := MinY;}
  Stree.FindObjects(X1-MaxDX, X1+MaxDX, Y1-MaxDY, Y1+MaxDY, ObjCoor, SI);
  cnt := 0;
  Obj1 := iNull;
  Obj2 := iNull;
  Min := 10000;
  Min2 := 10000;
  List := nil;
  while true do
     begin
       Obj := Stree.FindNextObject(SI);
       if dword(Obj) = iNull then
           break;
       D := MinDistance(Obj, x1, y1, List);
     end;
  SortList(List, x1, y1);
  M := length(List);
  if M > 20 then
     M := 20;
  Result := '';
  if M <> 0 then
   if friendly then
     Result := GetStreetDescription(List[0], x1, y1, true)
   else
    for i := 0 to M - 1 do
     if i <> M - 1 then
       Result := Result + GetStreetDescription(List[i], x1, y1) + #10
     else
       Result := Result + GetStreetDescription(List[i], x1, y1)
  else
    if Friendly then
       Result := GetCity(xx1, yy1)
    else
       Result := 'No streets found';
end;

function  TStreetObject.ProcessQuery(Request : String; AppendEOL : boolean; Var ContentType : String; AppendCommand : boolean; commstr : string = '') : String;
Var P : integer;
    Street, Zip, cleansed_add : String;
    S : String;
    city, VarName, V, State, Error : String;
    D, x, y, x1, y1, x2, y2 : double;
    Approx,level_index : integer;
    Debug : TDebug;
    friendly, matchprop, hdr, matchprop2, showclean : boolean;
begin
   try
       S := TIdURI.URLDecode(Request);
       //S := Interf.regexp_pound.Replace(S,''); // JAB get rid of characters after pound sign. Stops when space is detected. bla bla # miami fl causes deletion of miami: BEWARE!!
       regexp_Compile(S,2);

       p := 1;
       Zip := '';
       street := '';
       city := '';
       debug.debug := false;
       friendly := false;
       hdr := false;
       x1 := 1e10;
       y1 := 1e10;
       matchprop := false;
       showclean := false;

       while p < length(S) do
         begin
           ParseDoubleVar(S, VarName, D, V, p);
           if VarName = 'zip' then
             Zip := V;
           if VarName = 'friendly' then
             friendly := V = '1'
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
           else if VarName = 'matchprop' then
             begin
               matchprop := V = '1';
               matchprop2 := V = '2';
             end
           else if Varname = 'showcleansedaddress' then   // New parameter to show the cleansed address JAB
               showclean := V = '1'
           else if VarName = 'x1' then
              x1 := D
           else if VarName = 'y1' then
              y1 := D
           else if VarName = 'x2' then
              x2 := D
           else if VarName = 'y2' then
              y2 := D
           else if (VarName = 'header') then
             hdr := V = '1';
         end;
      if (x1 < 1e9) and (y1 < 1e9) then
         begin
            if Hdr then
               Result := Header + Find2Streets(x1, y1, false) + #10
            else
               Result := Find2Streets(x1, y1, friendly) + #10;
            if ContentType = 'standard' then
                Result := result + '==='+#10;
            ContentType := 'text/plain';
         end
      else if debug.debug then
       if FindHouseByZip(street, zip, city, state, X, Y, Approx, debug, error, false)  or FindHouseByZip(street, zip, city, state, X, Y, Approx, debug, error, true) then
          begin
           if Approx > 1 then
             Result := MapUrl('Approx Lat = ' + CoorStr1(Y) + ' Lon=' + CoorStr1(X), X,Y)
           else
             Result := MapUrl('Exact Lat = ' + CoorStr1(Y) + ' Lon=' + CoorStr1(X), X, Y);
           Result := '<p>' + Result + '</p><p>' + Debug.S + '</p>';
           ContentType := 'text/html';
          end
      else
        Result := 'Address not found' + Debug.S
      else
        begin
            street_nationw := '';   //ensures valid assignament of streets  JAB
            if not FindHouseByZip(street, zip, city, state, X, Y, Approx, debug, error, false) then
               FindHouseByZip(street, zip, city, state, X, Y, Approx, debug, error, true);
            if matchprop then
               begin
                  street := street_nationw;
                  locateProperty(street, X, Y, Approx);
               end;
            if matchprop2 then
                begin
                  street := street_nationw;
                  //locateProperty_nationwide(street, X, Y, Approx,zip);
                  cleansed_add := '';
                  locateProperty_nationwide(street, X, Y, Approx,zip,cleansed_add);
                end;
            if error <> '' then
               Result := 'ERROR: ' + error
            else
               begin

               if Approx = A_Prop then   // rooftop geocoder found, right now level 0 is not implemented in dependant systems
               begin
                        Approx := A_Exact;  //this should be deleted when level 0 is valid
                        level_index := A_Prop;

               end
               else
                        level_index := Approx;

               if showclean then
                   Result :=  'X=' + CoorStr1(X) + TAB + 'Y=' + CoorStr(Y) + #10 +
                          'Level=' + inttostr(Approx) + TAB + Levels[level_index] + #10 +
                          cleansed_add + #10
               else
                   Result :=  'X=' + CoorStr1(X) + TAB + 'Y=' + CoorStr(Y) + #10 +
                          'Level=' + inttostr(Approx) + TAB + Levels[level_index] + #10;
                          //'Level=' + inttostr(Approx) + TAB + Levels[Approx];

                                                            

               end;
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
         //Result := 'END. Internal Error. Please report to jball008@cs.fiu.edu';
         Result := 'END. Internal Error. Please report to wanghuibo100120@gmail.com';
         
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

procedure TStreetObject.ReadAllCities_old;
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


procedure TStreetObject.ReadAllCities_new; // new format as of 12/2002
Var S : String;
    SCity, SState, SZip, Acceptable, Correct, SStateCode, Country,
       city_code, valid, latitude, longitude: String;
    Long, Lat : double;
    IState, P, PP, Zip, C : integer;
    Line : String;
    Start : boolean;
begin
  readstringfile(Dir1 + 'Zip_City_State.txt', S);
  P := 1;
  Start := true;
  deletefile(IZipObject.Dir1 + 'Zip_City_State.src');
  deletefile(IZipObject.Dir1 + 'zipcenters.src');
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
                    ExtractField(Line, SCity, PP);
                    ExtractField(Line, SStateCode, PP);
                    ExtractField(Line, SState, PP);
                    ExtractField(Line, Country, PP);
                    ExtractField(Line, city_code, PP);
                    ExtractField(Line, valid, PP);
                    ExtractField(Line, latitude, PP);
                    ExtractField(Line, longitude, PP);
                    Long := ReadDouble(longitude);
                    Lat := ReadDouble(latitude);

                    if (Long <> 0) and (Lat <> 0) then
                       begin
                         izipObject.ZipCodes[Zip].CX := long;
                         izipObject.ZipCodes[Zip].CY := lat;
                       end;
                    IState := DirStates.Find(SState);
                    AppendFile(IZipObject.Dir1 + 'Zip_City_State.src', SZip + ',' + SCity + ',' + SStateCode + ',' + SState + ',' + Country + ',' + city_code);
                    if Long <> 0 then
                      AppendFile(IZipObject.Dir1 + 'zipcenters.src', SZip + TAB + Latitude + TAB + Longitude);
                    if ZIp = 33160 then
                      Zip := 33160;
                    while (SCity <> '') and (Scity <> 'FAKEZIP') and (Scity <> 'TESTZIP') do
                      begin
                        IState := DirStates.Find(SStateCode);
                        if IState < 0 then
                          begin
                            SaveStates := true;
                            DirStates.Add(SStateCode);
                            IState := DirStates.Find(SStateCode);
                          end;
                        if (SState <> '') and (DirStates.Find(SState) < 0) then
                            DirStates.Add(SState, IState);
                        SState := Dirstates.GetShortName(IState);
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
                        ExtractField(Line, SCity, PP);
                        ExtractField(Line, SStateCode, PP);
                        ExtractField(Line, Acceptable, PP);
                        ExtractField(Line, Correct, PP);
                      end;
              end;
        end;
    end;
end;

procedure TStreetObject.ParseWtown3;
Var S : String;
    SCity, SState, SZip, Acceptable, Correct, SStateCode, SCountry,
       city_code, SLine, SCode, valid, slat, slon, SPop, SOther, SStateName: String;
    Long, Lat, CX, CY : double;
    IState, P, PP, Zip, C : integer;
    Line : String;
    Start : boolean;
begin
  readstringfile(Dir1 + 'wtown3.ascii', S);
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
           ExtractField(Line, SCity, PP);
           ExtractField(Line, SState, PP);
           ExtractField(Line, SCountry, PP);
           ExtractField(Line, SPop, PP);
           ExtractField(Line, SOther, PP);
           ExtractField(Line, SLat, PP);
           ExtractField(Line, SLon, PP);
           if SCountry = 'US' then
             begin
               SCode := '';
               SStateName := UPStr(SState);
               istate :=DirStates.Find(SStateName);
               if istate>= 0 then
                 SState :=DirStates.GetShortName(istate);
               SCity :=UpStr(SCity);
               SLine := SCode + TAB + SCity + TAB + SState + TAB + SCountry +
                        TAB + SStateName + TAB + SCountry + TAB+ SLat + TAB + SLon + TAB + SOther;
               if not ICityObject.FindCityCoor(SCity, SState, CX, CY) then
                 begin
                   AppendFile('All.cities',SLine);
                 end;
             end;
        end;
    end;
end;

procedure TStreetObject.ReadAllCities_business; // new format as of 12/2007
Var S : String;
    SCity, SState, SZip, Acceptable, Correct, SStateCode, Country,
       elev, SCityType, SCityAlias, SAreaCode, SCityAliasName, city_code, valid, latitude, longitude: String;
    Long, Lat : double;
    IState, P, PP, Zip, C : integer;
    Line : String;
    Start : boolean;
    procedure AddCity(SCity : String);
      begin
        if SCity = '' then
           exit;
        if SCity = 'MIAMI BEACH' then
           c := 1;
        IState := DirStates.Find(SStateCode);
        if IState < 0 then
          begin
            SaveStates := true;
            DirStates.Add(SStateCode);
            IState := DirStates.Find(SStateCode);
          end;
        if (SState <> '') and (DirStates.Find(SState) < 0) then
            DirStates.Add(SState, IState);
        SState := Dirstates.GetShortName(IState);
        C := FindCity(SCity, iState, true);
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

begin
  readstringfile(Dir1 + 'Zip-codes-database-DELUXE-BUSINESS.csv', S);
  P := 1;
  Start := true;
  deletefile(IZipObject.Dir1 + 'Zip_City_State.src');
  deletefile(IZipObject.Dir1 + 'zipcenters.src');
  while P < length(S) do
    begin
      ScanLine1(S, P, Line);
      CSVToTab(Line);
      if Start then
        begin
           Start := false;
        end
      else
        begin
           PP := 1;
           ExtractField(Line, SZip, PP);
           Zip := ValStr(SZip);
           if Zip <> 0 then
              begin
                    PP := 1;
                    SkipFields(Line, 19, PP);
                    ExtractField(Line, latitude, PP);
                    ExtractField(Line, longitude, PP);
                    ExtractField(Line, elev, PP);
                    ExtractField(Line, SStateCode, PP);
                    ExtractField(Line, SState, PP);
                    ExtractField(Line, SCityType, PP);
                    ExtractField(Line, SCityAlias, PP);
                    ExtractField(Line, SAreaCode, PP);
                    ExtractField(Line, SCity, PP);
                    ExtractField(Line, SCityAliasName, PP);
                    Long := ReadDouble(longitude);
                    Lat := ReadDouble(latitude);
                    if Zip = 33109 then
                       Zip := 33109;

                    if (Long <> 0) and (Lat <> 0) then
                       begin
                         izipObject.ZipCodes[Zip].CX := long;
                         izipObject.ZipCodes[Zip].CY := lat;
                       end;
                    IState := DirStates.Find(SState);
                    AppendFile(IZipObject.Dir1 + 'Zip_City_State.src', SZip + ',' + SCity + ',' + SStateCode + ',' + SState + ',' + Country + ',' + city_code);
                    if Long <> 0 then
                      AppendFile(IZipObject.Dir1 + 'zipcenters.src', SZip + TAB + Latitude + TAB + Longitude);
                    if ZIp = 33157 then
                      Zip := 33157;
                    AddCity(SCity);
                    AddCity(SCityAliasName);
                    AddCity(SCityAlias);
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

function TStreetObject.FindCity(Var SCity : String; IState : integer; parsing : boolean = false) : integer;
Var S, SS : String;
    p : integer;

function FindCit(Var SCity : String; IState : integer) : integer;
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
begin
   Result := -1;
   S := SCity;
   Result := FindCit(S, IState);
   if Result >= 0 then
      exit;
   SS := SCity;
   StandardizeCity(SS, true);
   Result := FindCit(SS, IState);
   if Result >= 0 then
      exit;
   if Parsing then
      exit;
   S := SCity;
   DeleteLastWord(S);
   while S <> '' do
      begin
         SS := S;
         StandardizeCity(SS, true);
         Result := FindCit(SS, IState);
         if result >= 0 then
            exit;
         DeleteLastWord(S);
      end;
   S := SCity;
   DeleteFirstWord(S);
   while S <> '' do
      begin
         SS := S;
         StandardizeCity(SS, true);
         Result := FindCit(SS, IState);
         if result >= 0 then
            exit;
         DeleteFirstWord(S);
      end;
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

procedure TStreetObject.DumpBadZips;
Var i : integer;
    F : textfile;
begin
   AssignFile(F, GethardRootdir1 + 'BadZips.txt');
   rewrite(F);
   for i := 0 to NumCities - 1 do
    if iZipObject.ZipCodes[Cities[i].Zip].CX = 0 then
       writeln(F, zipstr(Cities[i].Zip));
   closefile(F);
end;

procedure TStreetObject.StandardizeCity(Var S : String; delspaces : boolean);
Var p : integer;
begin
   replaceword(S, 'FORT', 'FT');
   replaceword(S, 'SAINT', 'ST');
   replaceword(S, 'NORTH', 'N');
   replaceword(S, 'SOUTH', 'S');
   replaceword(S, 'WEST', 'W');
   replaceword(S, 'EAST', 'E');
   replaceword(S, 'SO', 'S');
   replaceword(S, 'NO', 'N');
   replaceword(S, 'MOUNT', 'MT');
   if not delspaces then
      exit;
    p := pos(' ', s);
    while p <> 0 do
      begin
        delete(s, p, 1);
        p := pos(' ', s);
      end;
end;

function TStreetObject.LoadCities : boolean;
Var F : TFileIO;
    i, j, C, ii, p, NumC : integer;
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
   Setlength(Cities, NumCities+21000);
   NumC := NumCities;
   for i := 0 to NumCities - 1 do
     begin
        F.ReadString(S);
        Cities[i].Name := S;
        Cities[i].State := F.ReadInt;
        Cities[i].NumZips := F.ReadInt;
        Cities[i].CX := F.ReadDouble;
        Cities[i].CY := F.ReadDouble;
        Cities[i].Zip := F.ReadInt;

        //if zip_city[Cities[i].Zip] = 0 then
        //  begin
        //        zip_city[Cities[i].Zip] := i;
        //  end;

        C := HashCity(S, Cities[i].State);
        for j := 0 to ZipHashMax - 1 do
           Cities[i].Hash[j] := nil;
        Cities[i].HashCityNameNext := HashCityName[C];
        HashCityName[C] := i;
        if pos(' ', S) <> 0 then
           begin
//              AppendFile(Dir1 + 'cities.abbr', S);
              StandardizeCity(S, true);
              if S = 'STLOUIS' then
                 S := 'STLOUIS';
              ii := NumC;
              inc(NumC);
              if NumC > length(Cities) then
                 setlength(Cities, NumC + 1000);
              Cities[ii] := Cities[i];
              Cities[ii].Name := s;
              C := HashCity(S, Cities[i].State);
              for j := 0 to ZipHashMax - 1 do
                 Cities[ii].Hash[j] := nil;
              Cities[ii].HashCityNameNext := HashCityName[C];
              HashCityName[C] := ii;
           end;
     end;
   NumCities := NumC;
   Setlength(Cities, NumCities);
   for i := MinZip to MaxZip do
     begin
       SetLength(ZipCity[i], F.ReadInt);
       for j := 0 to length(ZipCity[i]) - 1 do
         ZipCity[i][j] := F.ReadInt;
     end;
   F.Free;
end;


end.

