{*** 2D Shape object indexing using S-tree implementation by A. Shaposhnikov 2002 ***}
{

Indexes arbitrary 2D objects in 2-D space and performs web queries. 
The following shape queries are active now: (data from www.census.gov)
Command		Description
bg		2000 Census Block Groups 
tracts          2000 Census Tracts 
incorp          2000 Incorporated Places/Census Designated Places
subcounty       2000 County Subdivisions
congress        107th Congressional Districts (Jan. 2001 - Jan. 2003) 
counties        2000 County and County Equivalent Areas
metro           1999 Metropolitan Areas 
state           2000 States

syntax:

<Command>?x1=number&y1=number[&x2=number&y2=number][&resx=number&resy=number][&limit=number][&center=0/1][&bbox=0/1][&stat=0/1][&dir=0/1][&census=0/1]

x1, y1 - the point coordinates or the rectangle corner.
x2, y2 - the opposite rectangle corner, optional for rectangle queries.
limit  - limits the number of results to the specified number. 
	 The default is 100. If the limit is exceeded, no results is returned. 
         An error message is returned instead: ERROR: LIMIT EXCEEDED. FOUND:number

bbox=1 or 0 - output the shape bounding box
stat=1 or 0 - output the census statistics provided by M. Baranovsky
dir=1 or 0 - optionally append the distance and the direction to each object's center from x1 y1
census=1 or 0 - optionally append the word 'census' to each record in the output

resx=integer&resy=integer will return the intersection of the shape polygon contour with the 
		specified rectangle scaled into integer bitmap coordinates. 
		When scaling, it is assumed the bitmap point (0,0) corresponds to 
		the earth point with coordinates (x1, y2) and the bitmap point
		(resx, resy) corresponds to the earth point with coordinates 
		(x2,y1) - this is the standard for bitmaps. The polygon is appended 
		in brackets to the normal program output. Each polygon consists
		of 1 or more contours. Contours can be the area contours or hole
		contours. (Holes do not belong to the area). Area contours start with 0,
		hole contours start with 1. The bitmap integer x and y coordinates of
		the vertices of the intersection contour follow the hole indicator in a
		clockwise order. The plotting program is supposed to plot a line starting
		from the first vertex to the next and so on, finishing at the first vertex
		at the end.

In the example below, the zip code 33009 consists of two non-hole contours:

http://n158.cs.fiu.edu/zip?x1=-80.125&y1=25.95&x2=-80&y2=26&resx=800&resy=600

0
29 268
33 299
16 300
24 166
34 164


and

0
31 34
20 116
7 300
5 308
0 308
0 0
33 0

center=1 will output the center of the zip code as specified in the census files scaled to the bitmap coordinates. Note that the center may lie outside of the bitmap boundaries. In that case the scaled center coordinates will be either less than zero or greater than the specified bitmap resolution
}


unit shapeobject;
interface

uses
  SysUtils, Stree, GPC1, IdTCPServer, IdCustomHTTPServer,
  IdHTTPServer, webobject, syncobjs, InovaGIS_TLB, dbtables;

type TShapeRec = record
       X1 : single;
       X2 : single;
       Y1 : single;
       Y2 : single;
       CX : single;
       CY : single;
       LX1 : single;
       LX2 : single;
       LY1 : single;
       LY2 : single;
       ID : integer;
       Info : pchar;
       Info2 : pchar;
       index : integer;
//       found : boolean;
       Area : TPolygon;
end;

type TStreeVertex = record
     X, Y : single;
     Shape : integer;
end;

type TShapeEntry = record
       Shape : integer;
       ResultNext : integer;
       HashNext : integer;
end;

type

TShapeObject = class;

TShapeResult = class
    Vertexes : array[0..4] of TVertex;
    Contour : TContour;
    Hole : integer;
    Polygon : TPolygon;
    X1, Y1, X2, Y2 : single;
    Hash : array[0..127] of integer;
    NumShapes : integer;
    Shapes : array of TShapeEntry;
    NextFree : TShapeResult;
    Interf : TShapeObject;
    NumFound : integer;
    ShapeOffset : integer;
    Res : integer;
    PreciseFind : boolean;
    constructor Create(I : TShapeObject);
    procedure Init(Precise : boolean);
    function Add(Shape : integer) : boolean;
    function  GetNextShape : integer;
    function GetPolygon(ResX, ResY, Z : integer; center : boolean) : String;
    procedure Recycle;
end;

TShapeObject = class(TWebObject)
  private
    memory : pchar;
    Memsize : integer;
    Mempos : integer;
    FirstFreeResult : TShapeResult;
    procedure AllocateInit(S : integer);
    function  Allocate(S : integer) : pointer;
    function  AllocateStr(Var S : String) : pchar;
    function  AllocateStr1(Var S : String) : pchar;
    { Private declarations }
  public
    header, sourceformat : string;
    NumInfoLines : integer;
    ShapeOffset : integer;
    NumVertexes : integer;
    Vertexes : array of TVertex; // 0..NumVertexes - 1
    ShapeOfVertex : array of Integer; // 0..NumVertexes - 1 of pointers to ShapeRecs
    NumContours : integer;
    Contours : array of TContour;
    NumCodes : integer;
    NumShapeRecs : integer;
    ShapeRecs : array of TShapeRec;

    NumStreeVertexes : integer;
    STreeVertexes : array of TStreeVertex;

    MaxShapeWidth : single;
    MaxShapeHeight : single;
    MinShapeWidth : single;
    MinShapeHeight : single;
    MaxShape : integer;
    DeltaX : single;
    DeltaY : single;
    Stree : TStree;

// persistent data
    MinX, MaxX : single;
    MinY, MaxY : single;
    AvShapeHeight : single;
    AvShapeWidth : single;
    CSWork : TCriticalSection;
    Keylength : integer;
    Keystart : integer;
    IDIndex : integer;
    Key : string;
    expectedlength : integer;
    expectedfield : integer;
    Map: iVectorial;
    ShpName : String;

//    procedure Save(Name : string);
//    procedure Load(Name : string);
    procedure MainTableInit;
    destructor Free; override;
    procedure Init(Oldobject: TWebObject = nil); override;
    procedure TestClick; override;
    procedure HandleCommand(UnparsedParams : String;
    Var ResponseInfo: String; Var ContentType : String); override;
    procedure AddFile(Name : String);
    procedure Calibrate;
    procedure BuildStree;
    procedure InsertVertex(lon, lat : single; Shape : integer);
    procedure ObjCoor(ObjID : integer; Var X, Y : single);
    procedure AddStreeVertex(X, Y : single; Shape : integer);
    function  Intersects(Shape : integer; Var R : TShapeResult) : boolean;
    function  IntersectArea(Shape : integer; Var Polygon : TPolygon) : boolean;
    procedure InitContours;
    function  Shapesearch(X1, Y1, X2, Y2 : single; limit : integer; precise : boolean = false) : TShapeResult;
    procedure LoadAllFiles;
    procedure LoadBase;
    procedure SaveBase(Mem : integer = 0);
    procedure SearchClick;
    function  ProcessQuery(Request: String; AppendEOL : boolean; Var ContentType : String; AppendCommand : boolean; commstr : string = '') : String; override;
    procedure DumpRecords(Var c : integer); override;
    procedure GetInfo2;
    procedure CalcBBox;
    function  ExtractKey(S : String) : String;
    procedure LoadAllDBFFiles;
    procedure AddDBFFile(Name : String);
    procedure MainThreadInit;
    function  FindNearest(Xc, Yc : single; Var MilDist : double) : string;
    function FindCountryAbbrev(CountryName, CityName : String) : String;
    { Public declarations }
  end;

type TStringHash = record
    pos : integer;
    next : integer;
end;

const KeyHashMax = 1024*512;
type TKeyBase = class
    records : string;
    Hash : array of TStringHash;
    hashlen : integer;
    HashTable : array[0..KeyHashMax] of integer;
    procedure Load(Name : String);
    procedure MakeHash;
    function FindRecord(Var Key : String) : String;
    function HashFun(var Key : string) : integer;
end;

Var KeyBase : TKeyBase;

implementation
uses FileIO, parser, wintypes, winprocs, cityobject, requestobject,  threadpool;



function TKeyBase.HashFun(var Key : string) : integer;
Var i : integer;
begin
  result := length(key);
  for i := 1 to length(Key) do
     result := result + ord(key[i]) shl (i*2 mod 10);
  result := result mod KeyHashMax;
end;

procedure TKeyBase.Load(Name : String);
begin
   ReadStringFile(Name, Records);
end;

procedure TKeyBase.MakeHash;
Var p, pp, h, i : integer;
    Line, key : String;
begin
   Hash := nil;
   hashlen := 0;
   P := 1;
   for i := 0 to KeyHashMax do
      HashTable[i] := -1;
   while p < length(records) do
     begin
        pp := p;
        ScanLine1(records, p, Line);
        extractfieldbynum(line, 1, key);
        inc(Hashlen);
        if hashlen > length(Hash) then
          setlength(Hash, round(hashlen * 1.2) + 10);
        h := hashfun(key);
        Hash[hashlen-1].pos := pp;
        Hash[hashlen-1].next := HashTable[h];
        HashTable[h] := hashlen-1;
     end;
end;

function TKeyBase.FindRecord(Var Key : String) : String;
Var h, p : integer;
    K, line : string;
begin
  h := HashTable[hashfun(key)];
  while h >= 0 do
    begin
       P := Hash[h].Pos;
       scanline1(records, P, line);
       extractfieldbynum(line, 1, K);
       if K = Key then
         begin
           Result := line;
           exit;
         end;
       h := Hash[h].Next;
    end;
  result := '';
end;

const maxHash = 1024*256;
function HashStr(F : String) : integer;
Var i : integer;
begin
   result := 0;
   for i := 1 to length(F) do
     result := result + ord(F[i]) shl (i*2 mod 10);
   if result < 0 then
      result := -result;
   result := result mod maxHash;
end;

function TShapeObject.ExtractKey(S : String) : String;
Var j : integer;
    K, F : String;
begin
   for j := 1 to Keylength do
      begin
        ExtractFieldByNum(S, KeyStart + j - 1, F);
        if expectedfield = j then
          while length(F) < expectedlength do
            F := F + '0';
        K := K + F;
      end;
   result := K;
end;

procedure FindPointWithinArea(Area : TPolygon; X1, X2, Y1, Y2 : single; Var X, Y : single);
Var Res, P : TPolygon;
    V : array [0..3] of TVertex;
    C : TContour;
    R, H, N, TR, retr : integer;
    CX, CY, DDX, DDY, DX, DY : single;
procedure SetVertex(X, Y : single);
begin
   V[0].X := X - DDX;
   V[0].Y := Y - DDY;
   V[1].X := X + DDX;
   V[1].Y := Y - DDY;
   V[2].X := X + DDX;
   V[2].Y := Y + DDY;
   V[3].X := X - DDX;
   V[3].Y := Y + DDY;
end;
begin
   DDX := MileX(Y) / 1000;
   DDY := MIleY / 1000;
   Setvertex((X1 + X2) / 2, (Y1 + Y2) / 2);
   DX := (X2 - X1) / 128;
   DY := (Y2 - Y1) / 128;
   C.Vertexes := @V;
   C.NumVertexes := 4;
   P.Contours := @C;
   P.NumContours := 1;
   H := 0;
   N := 0;
   TR := 0;
   retr := 0;
   P.Holes := @H;
   CX := (X1 + X2) / 2;
   CY := (Y1 + Y2) / 2;
   repeat
      gpc_polygon_clip1(GPC_INT,  Area, P, Res);
      if Res.NumContours > 0 then
        begin
           X := Res.Contours[0].Vertexes[0].X;
           Y := Res.Contours[0].Vertexes[0].Y;
           gpc_free_polygon1(Res);
           break;
        end;
      gpc_free_polygon1(Res);
      SetVertex(CX + DX*(random(10) - 10), CY + DY*(random(10) - 10));
      inc(N);
      if N > 10 then
         begin
            N := 0;
            DX := DX * 2;
            DY := DY * 2;
            inc(TR);
            if TR > 8 then
               begin
                  DX := (X2 - X1) / 128;
                  DY := (Y2 - Y1) / 128;
                  TR := 0;
                  R := random(Area.Contours[0].numvertexes);
                  if retr > 5 then
                     begin
                       CX := Area.Contours[0].Vertexes[R].X;
                       CY := Area.Contours[0].Vertexes[R].Y;
                     end;
                  inc(retr);
                  if retr > 20 then
                    begin
                     R := random(Area.Contours[0].numvertexes);
                     X := Area.Contours[0].Vertexes[R].X;
                     Y := Area.Contours[0].Vertexes[R].Y;
                     exit;
                     setvertex(Area.Contours[0].Vertexes[R].X, Area.Contours[0].Vertexes[R].Y);
                    end;
               end;
         end;
   until false;
end;


procedure TShapeObject.CalcBBox;
Var i, H, First : integer;
    HashPrev : array of integer;
    Hash : array[0..MaxHash] of integer;
    F, FF: string;
begin
   setlength(HashPrev, MaxShape+1);
   for i := 0 to MaxHash do
     Hash[i] := -1;
   for i := 0 to Maxshape do
      begin
          F := ExtractKey(ShapeRecs[i].Info);
          ShapeRecs[i].LX1 := ShapeRecs[i].X1;
          ShapeRecs[i].LY1 := ShapeRecs[i].Y1;
          ShapeRecs[i].LX2 := ShapeRecs[i].X2;
          ShapeRecs[i].LY2 := ShapeRecs[i].Y2;
          FindPointWithinArea(ShapeRecs[i].Area, ShapeRecs[i].X1, ShapeRecs[i].X2,
             ShapeRecs[i].Y1, ShapeRecs[i].Y2, ShapeRecs[i].CX, ShapeRecs[i].CY);
          H := HashStr(F);
          HashPrev[i] := Hash[H];
          Hash[H] := i;
          H := HashPrev[i];
          First := -1;
          while H >= 0 do
             begin
                FF := ExtractKey(ShapeRecs[H].Info);
                if FF = F then
                   First := H;
                H := HashPrev[H];
             end;
          if First >= 0 then
             begin
                if ShapeRecs[First].LX1 > Shaperecs[i].X1 then
                   ShapeRecs[First].LX1 := Shaperecs[i].X1;
                if ShapeRecs[First].LX2 < Shaperecs[i].X2 then
                   ShapeRecs[First].LX2 := Shaperecs[i].X2;
                if ShapeRecs[First].LY1 > Shaperecs[i].Y1 then
                   ShapeRecs[First].LY1 := Shaperecs[i].Y1;
                if ShapeRecs[First].LY2 < Shaperecs[i].Y2 then
                   ShapeRecs[First].LY2 := Shaperecs[i].Y2;
                H := i;
                while H >= 0 do
                   begin
                      FF := ExtractKey(ShapeRecs[H].Info);
                      if FF = F then
                        begin
                           ShapeRecs[H].LX1 := Shaperecs[First].LX1;
                           ShapeRecs[H].LY1 := Shaperecs[First].LY1;
                           ShapeRecs[H].LX2 := Shaperecs[First].LX2;
                           ShapeRecs[H].LY2 := Shaperecs[First].LY2;
                        end;
                      H := HashPrev[H];
                   end;
             end;
      end;
end;

procedure TShapeObject.GetInfo2;
Var CType, F, K, KK, Street : String;
    i, j : integer;
begin
   CType := '';
   for i := 0 to MaxShape do
      with ShapeRecs[i] do
         begin
            K := Key;
            for j := 1 to Keylength do
              begin
                ExtractFieldByNum(ShapeRecs[i].Info, KeyStart + j - 1, F);
                if expectedfield = j then
                  while length(F) < expectedlength do
                    F := F + '0';
                K := K + F;
              end;
            KK := KeyBase.FindRecord(K);
            Street := rstreetobject.ProcessQuery('x1=' + CoorStr(ShapeRecs[i].CX) + '&y1=' + CoorStr(ShapeRecs[i].CY), false, CType, false);
            Street := copy(Street, 1, pos(#$A, Street)-1);
            appendfile(GetHardRootDir1 + 'centralpoints.txt', K + TAB + CoorStr(ShapeRecs[i].CX) + TAB + CoorStr(ShapeRecs[i].CY) + TAB + Street);
            sleep(50);
            if KK = '' then
              begin
                appendfile(GetHardRootDir1 + command + '_missing.txt', K + TAB + ShapeRecs[i].Info);
                Info2 := nil
              end
            else
              Info2 := AllocateStr1(KK);
         end;
end;


procedure TShapeObject.DumpRecords(Var c : integer);
Var i : integer;
    S : String;
    F : TextFile;
begin
   AssignFile(F, GethardRootDir1 + Command + '.CSV');
   Rewrite(F);
   for i := 0 to MaxShape do
     begin
       S := ShapeRecs[i].Info;
       while pos(TAB, S) <> 0 do
         S[Pos(TAB,S)] := ',';
       if S[length(S)] <> ',' then
         S := S + ',';
       S := S + inttostr(c);
       writeln(F, S);
       inc(c);
     end;
   CloseFile(F);
end;

procedure TShapeObject.Init;
begin
   NumVertexes := 0;
   Vertexes := nil;
   ShapeOfVertex := nil;
   NumCodes := 0;
   NumShapeRecs := 0;
   memory := nil;
   ShapeRecs := nil;
   MaxShape := 0;
   FirstFreeResult := nil;
   CSWork := TCriticalSection.Create;
   if FileExists(Dir1+'Shape.co2') then
     LoadBase
   else
     begin
       if sourceformat = 'dbfshp' then
         LoadAllDBFFiles
       else
         LoadAllFiles;
       Calibrate;
       InitContours;
       CalcBbox;
       SaveBase;
     end;
end;

destructor TShapeObject.Free;
Var F : TShapeResult;
begin
  CSWork.Free;
  Stree.Free;
  if memory <> nil then
    freemem(memory);
  while FirstFreeResult <> nil do
     begin
       F := FirstFreeResult.NextFree;
       FirstFreeResult.Free;
       FirstFreeResult := F;
     end;
end;

procedure TShapeObject.LoadAllFiles;
Var SR : TSearchRec;
begin
   ShapeOffset := 0;
   if FindFirst(Dir1 + '*.dat', faAnyFile, SR) <> 0 then
      exit;
   try
   while true do
     begin
       if pos('a.dat', SR.Name) = 0 then
          AddFile(Dir1 + SR.Name);
       if FindNext(SR) <> 0 then
         break;
     end;
   finally
     Sysutils.FindClose(SR);
   end;
end;

procedure TShapeObject.LoadAllDBFFiles;
Var SR : TSearchRec;
begin
   ShapeOffset := 0;
   if FindFirst(Dir1 + '*.DBF', faAnyFile, SR) <> 0 then
      exit;
   try
   while true do
     begin
       AddDBFFile(Dir1 + SR.Name);
       if FindNext(SR) <> 0 then
         break;
     end;
   finally
     Sysutils.FindClose(SR);
   end;
end;


procedure TShapeObject.Calibrate;
Var OldShape, i, CShape : integer;
    MaxXShape, MinXShape, MaxYShape, MinYShape : single;
begin
   Interf.SetStatus('Calibrating ...');
   InsertVertex(0, 0, -1);
   MinY := 1e10;
   MinX := 1e10;
   MaxY := -1e10;
   MaxX := -1e10;
   MaxXShape := -1.e10;
   MinXShape := 1.e10;
   MaxYShape := MaxXShape;
   minYShape := MinXShape;
   OldShape := -1;
   CShape := -1;
   NumCodes := 0;
   NumContours := 0;
   for i := 0 to NumVertexes - 1 do
   begin
     if ShapeOfVertex[i] <> CShape then
       begin
         inc(NumContours);
         CShape := ShapeOfVertex[i];
         if CShape > MaxShape then
           MaxShape := CShape;
       end;
     if ShapeOfVertex[i] >= -1 then
      with Vertexes[i] do
       begin
           if ShapeOfVertex[i] <> OldShape then
            begin
               if OldShape <> -1 then
                 begin
                   if (MaxXShape - MinXShape) > MaxShapeWidth then
                     begin
                       MaxShapeWidth := MaxXShape - MinXShape;
                     end;
                   if (MaxXShape - MinXShape) < MinShapeWidth then
                     MinShapeWidth := MaxXShape - MinXShape;
                   if (MaxYShape - MinYShape) > MaxShapeHeight then
                     MaxShapeHeight := MaxYShape - MinYShape;
                   if (MaxYShape - MinYShape) < MinShapeHeight then
                     MinShapeHeight := MaxYShape - MinYShape;
                   if ShapeRecs[OldShape].X1 = 0 then
                      begin
                         ShapeRecs[OldShape].X1 := MinXShape;
                         ShapeRecs[OldShape].X2 := MaxXShape;
                         ShapeRecs[OldShape].Y1 := MinYShape;
                         ShapeRecs[OldShape].Y2 := MaxYShape;
                      end
                   else
                      begin
                         if ShapeRecs[OldShape].X1 > MinXShape then
                           ShapeRecs[OldShape].X1 := MinXShape;
                         if ShapeRecs[OldShape].X2 < MaxXShape then
                           ShapeRecs[OldShape].X2 := MaxXShape;
                         if ShapeRecs[OldShape].Y1 > MinYShape then
                           ShapeRecs[OldShape].Y1 := MinYShape;
                         if ShapeRecs[OldShape].Y2 < MaxYShape then
                           ShapeRecs[OldShape].Y2 := MaxYShape;
                      end;
                   inc(NumCodes);
                   AvShapeWidth := AvShapeWidth + MaxXShape - MinXShape;
                   AvShapeHeight := AvShapeHeight + MaxYShape - MinYShape;
                 end;
               MaxXShape := -1.e10;
               MinXShape := 1.e10;
               MaxYShape := MaxXShape;
               minYShape := MinXShape;
               OldShape := ShapeOfVertex[i];
             end;
          if X < MinXShape then
            MinXShape := X;
          if X > MaxXShape then
            MaxXShape := X;
          if Y < MinYShape then
            MinYShape := Y;
          if Y > MaxYShape then
            MaxYShape := Y;
          if X > maxX then
            maxX := X;
          if X < minX then
            minX := X;
          if Y > maxY then
            maxY := Y;
          if Y < minY then
            minY := Y;
       end; //if
   end; // for
   if NumCodes = 0 then
     begin
        Interf.SetStatus('Shape CODE FILES NOT FOUND!!!');
        exit;
     end;
   AvShapeWidth := AvShapeWidth / NumCodes;
   AvShapeHeight := AvShapeHeight / NumCodes;
   BuildStree;
end;

procedure TShapeObject.ObjCoor(ObjID : integer; Var X, Y : single);
begin
  X := StreeVertexes[ObjId].X;
  Y := StreeVertexes[ObjId].Y;
end;

procedure TShapeObject.AddStreeVertex(X, Y : single; Shape : integer);
begin
  if NumStreeVertexes >= length(StreeVertexes) then
     setlength(StreeVertexes, round(NumStreeVertexes * 1.2) + 10);
  if NumStreeVertexes >= 3192934 then
     NumStreeVertexes := NumStreeVertexes;
  StreeVertexes[NumStreeVertexes].X := X;
  StreeVertexes[NumStreeVertexes].Y := Y;
  StreeVertexes[NumStreeVertexes].Shape := Shape;
  Stree.AddObject(NumStreeVertexes, X, Y, ObjCoor);
  inc(NumStreeVertexes);
end;

procedure TShapeObject.BuildStree;
Var i : integer;
    X, Y : single;
begin
   Interf.SetStatus('Building Shape S-tree ...');
   DeltaX := AvShapeWidth;
   DeltaY := AvShapeHeight;
   Stree := TStree.Create(MinX-2*DeltaX, MinY-2*DeltaX, MaxX+2*DeltaX, MaxY+2*DeltaX, 8, 4, NumCodes * 4);
   NumStreeVertexes := 0;
   for i := 0 to MaxShape do
     if ShapeRecs[i].X1 <> 0 then
        begin
          X := ShapeRecs[i].X1;
          Y := ShapeRecs[i].Y1;
          while Y <= ShapeRecs[i].Y2 do
            begin
              AddStreeVertex(X + DeltaX, Y + DeltaY, i);
              inc(TotalVertixes);
              X := X + DeltaX;
              if X > ShapeRecs[i].X2 then
                begin
                  X := ShapeRecs[i].X1;
                  Y := Y + DeltaY;
                end;
            end;
        end;
   TotalObjects := MaxShape;
end;

function TShapeObject.Shapesearch(X1, Y1, X2, Y2 : single; limit : integer; precise : boolean = false) : TShapeResult;
Var SI : TStreeIterator;
    Obj : dword;
    cnt : integer;
begin
  Result := FirstFreeResult;
  if Result = nil then
    Result := TShapeResult.Create(self)
  else
    FirstFreeResult := Result.NextFree;
  if X2 > MaxX then
    X2 := MaxX;
  if X1 < MinX then
    X1 := MinX;
  if Y2 > MaxY then
    Y2 := MaxY;
  if Y1 < MinY then
    Y1 := MinY;
  Result.X1 := X1;
  Result.X2 := X2;
  Result.y1 := Y1;
  Result.y2 := Y2;
  Result.Init(Precise);
  Stree.FindObjects(X1-DeltaX, X2+DeltaX, Y1-DeltaY, Y2+DeltaY, ObjCoor, SI);
  cnt := 0;
  while true do
     begin
       Obj := Stree.FindNextObject(SI);
       if Obj = iNull then
           break;
       if Intersects(StreeVertexes[Obj].Shape, Result) then
          if Result.Add(StreeVertexes[Obj].Shape) then
            begin
               inc(cnt);
{               if cnt >= limit then
                  break;}
            end;
    end;
end;

{const TotalInt : integer = 0;
const FalseInt : integer = 0;}

function TShapeObject.IntersectArea(Shape : integer; Var Polygon : TPolygon) : boolean;
Var Res : TPolygon;
begin
   gpc_polygon_clip1(GPC_INT,  ShapeRecs[Shape].Area, Polygon, Res);
//   inc(TotalInt);
   if Res.NumContours > 0 then
     Result := true
   else
     begin
//       inc(FalseInt);
       Result := false;
     end;
   gpc_free_polygon1(Res);
end;

function TShapeObject.Intersects(Shape : integer; Var R : TShapeResult) : boolean;
begin
   with ShapeRecs[Shape] do
       Result :=  (((X1 >= R.X1) and (X1 <= R.X2)) or
                  ((X2 >= R.X1) and (X2 <= R.X2)) or
                  ((X1 <= R.X1) and (X2 >= R.X2))) and
                  (((Y1 >= R.Y1) and (Y1 <= R.Y2)) or
                  ((Y2 >= R.Y1) and (Y2 <= R.Y2)) or
                  ((Y1 <= R.Y1) and (Y2 >= R.Y2)));
end;

procedure TShapeObject.AllocateInit(S : integer);
begin
  Getmem(memory, S);
  Memsize := S;
  Mempos := 0;
end;

function TShapeObject.Allocate(S : integer) : pointer;
begin
  Result := @(Memory[mempos]);
  inc(Mempos, S);
  if MemPos > memSize then
    raise exception.create('TShapeObject.Allocate Out of memory');
end;

function  TShapeObject.AllocateStr(Var S : String) : pchar;
begin
   result := Allocate(Length(S) + 1);
   strpcopy(result, S);
end;

function  TShapeObject.AllocateStr1(Var S : String) : pchar;
begin
   getmem(result, Length(S) + 1);
   strpcopy(result, S);
end;

const _debug : integer = 0;
procedure TShapeObject.LoadBase;
Var _deb, Mem, i, j, k, Ver : integer;
    F : TFileIO;
    S, FileName : String;
    dbl : boolean;
begin
   _deb := 0;
   dbl := true;
   if FileExists(Dir1 + 'Shape.CO2') then
      begin
        FileName := Dir1 + 'Shape.CO2';
        dbl := false;
      end
   else  if FileExists(Dir1 + 'Shape.CO1') then
      FileName := Dir1 + 'Shape.CO1'
   else
      FileName := Dir1 + 'Shape.COD';
   Interf.SetStatus('Loading Shape database from ' + Dir1);
   F := TFileIO.Create(FileName, false, true);
   try
   Mem := F.ReadInt;
   if Mem = -1 then
     begin
       Ver := F.ReadInt; // version
       Mem := F.ReadInt;
     end
   else
     Ver := 0;
   if Mem = 0 then
     AllocateInit(F.GetSize+1000)
   else
     AllocateInit(Mem);
   MaxShape := F.ReadInt;
   if dbl then
     begin
       MinX := F.ReadDouble;
       MaxX := F.ReadDouble;
       MinY := F.ReadDouble;
       MaxY := F.ReadDouble;
       AvShapeHeight := F.ReadDouble;
       AvShapeWidth := F.ReadDouble;
     end
   else
     begin
       MinX := F.ReadSingle;
       MaxX := F.ReadSingle;
       MinY := F.ReadSingle;
       MaxY := F.ReadSingle;
       AvShapeHeight := F.ReadSingle;
       AvShapeWidth := F.ReadSingle;
     end;
   setlength(ShapeRecs, MaxShape +1);
   for i := 0 to MaxShape do
     with ShapeRecs[i] do
       begin
         inc(NumCodes);
         if dbl then
           begin
             X1 := F.ReadDouble;
             Y1 := F.ReadDouble;
             X2 := F.ReadDouble;
             Y2 := F.ReadDouble;
             if Ver >= 2 then
               begin
                 LX1 := F.ReadDouble;
                 LY1 := F.ReadDouble;
                 LX2 := F.ReadDouble;
                 LY2 := F.ReadDouble;
               end;
             CX := F.ReadDouble;
             CY := F.ReadDouble;
           end
         else
           begin
             X1 := F.ReadSingle;
             Y1 := F.ReadSingle;
             X2 := F.ReadSingle;
             Y2 := F.ReadSingle;
             if Ver >= 2 then
               begin
                 LX1 := F.ReadSingle;
                 LY1 := F.ReadSingle;
                 LX2 := F.ReadSingle;
                 LY2 := F.ReadSingle;
               end;
             CX := F.ReadSingle;
             CY := F.ReadSingle;
           end;
         F.ReadString(S);
         Info := AllocateStr(S);
         if Ver >= 1 then
           begin
             F.ReadString(S);
             Info2 := AllocateStr(S);
           end;
         inc(_debug);
         inc(_deb);
         if _debug = 351650 then
            _debug := 351650;
         Area.NumContours := F.ReadInt;
         Area.Holes := PHoles(Allocate(SizeOf(THole)*Area.NumContours));
         Area.ConTours := PContours(Allocate(SizeOf(TContour)*Area.NumContours));
         for j := 0 to Area.NumContours - 1 do
           begin
             Area.Holes[j] := F.ReadInt;
             Area.Contours[j].NumVertexes := F.ReadInt;
             inc(_debug);
             if _debug = 703616 then
               _debug := 703616;
             Area.Contours[j].Vertexes := PVertexes(Allocate(SizeOf(TVertex)*Area.Contours[j].NumVertexes));
             for k := 0 to Area.Contours[j].NumVertexes-1 do
               begin
                 if dbl then
                    begin
                       Area.Contours[j].Vertexes[k].X := F.ReadDouble;
                       Area.Contours[j].Vertexes[k].Y := F.ReadDouble;
                    end
                 else
                    begin
                       Area.Contours[j].Vertexes[k].X := F.ReadSingle;
                       Area.Contours[j].Vertexes[k].Y := F.ReadSingle;
                    end;
                 inc(TotalPoints);
               end;
           end;
       end;
   finally
     F.Free;
   end;
   if (MemSIze-Mempos) > 0 then
      SaveBase(Mempos);
   BuildStree;
//   DumpEmpty;
end;

{procedure TShapeObject.SaveBase(Mem : integer);
Var i, j, k : integer;
    F : TFileIO;
    S : String;
begin
   if Numcodes = 0 then
     exit;
   F := TFileIO.Create(Dir1 + 'Shape.COD', true, false);
   F.WriteInt(-1);
   F.WriteInt(2); // version
   F.WriteInt(Mem);
   F.WriteInt(MaxShape);
   F.WriteDouble(MinX);
   F.WriteDouble(MaxX);
   F.WriteDouble(MinY);
   F.WriteDouble(MaxY);
   F.WriteDouble(AvShapeHeight);
   F.WriteDouble(AvShapeWidth);
   for i := 0 to MaxShape do
      with ShapeRecs[i] do
        begin
           F.WriteDouble(X1);
           F.WriteDouble(Y1);
           F.WriteDouble(X2);
           F.WriteDouble(Y2);
           F.WriteDouble(LX1);
           F.WriteDouble(LY1);
           F.WriteDouble(LX2);
           F.WriteDouble(LY2);
           F.WriteDouble(CX);
           F.WriteDouble(CY);
           if Info = nil then
             S := ''
           else
             S := Info;
           F.WriteString(S);
           if Info2 = nil then
             S := ''
           else
             S := Info2;
           F.WriteString(S);
           F.WriteInt(Area.NumContours);
           for j := 0 to Area.NumContours - 1 do
             begin
               F.WriteInt(Area.Holes[j]);
               F.WriteInt(Area.Contours[j].NumVertexes);
               for k := 0 to Area.Contours[j].NumVertexes-1 do
                 begin
                   F.WriteDouble(Area.Contours[j].Vertexes[k].X);
                   F.WriteDouble(Area.Contours[j].Vertexes[k].Y);
                 end;
             end;
        end;
   F.WriteInt(0);
   F.Free;
end;}

procedure TShapeObject.SaveBase(Mem : integer);
Var _deb, i, j, k : integer;
    F : TFileIO;
    S : String;
begin
   if Numcodes = 0 then
     exit;
   F := TFileIO.Create(Dir1 + 'Shape.CO2', true, false);
   F.WriteInt(-1);
   F.WriteInt(2); // version
   F.WriteInt(Mem);
   F.WriteInt(MaxShape);
   F.WriteSingle(MinX);
   F.WriteSingle(MaxX);
   F.WriteSingle(MinY);
   F.WriteSingle(MaxY);
   F.WriteSingle(AvShapeHeight);
   F.WriteSingle(AvShapeWidth);
   for i := 0 to MaxShape do
      with ShapeRecs[i] do
        begin
           F.WriteSingle(X1);
           F.WriteSingle(Y1);
           F.WriteSingle(X2);
           F.WriteSingle(Y2);
           F.WriteSingle(LX1);
           F.WriteSingle(LY1);
           F.WriteSingle(LX2);
           F.WriteSingle(LY2);
           F.WriteSingle(CX);
           F.WriteSingle(CY);
           if Info = nil then
             S := ''
           else
             S := Info;
           F.WriteString(S);
           if Info2 = nil then
             S := ''
           else
             S := Info2;
           F.WriteString(S);
           inc(_deb);
           if _Deb = 11 then
              _deb := 11;
           F.WriteInt(Area.NumContours);
           for j := 0 to Area.NumContours - 1 do
             begin
               F.WriteInt(Area.Holes[j]);
               F.WriteInt(Area.Contours[j].NumVertexes);
               for k := 0 to Area.Contours[j].NumVertexes-1 do
                 begin
                   F.WriteSingle(Area.Contours[j].Vertexes[k].X);
                   F.WriteSingle(Area.Contours[j].Vertexes[k].Y);
                 end;
             end;
        end;
   F.WriteInt(0);
   F.Flush;
   F.Free;
end;

procedure AddContour(Var P : TPolygon; Var Contour : TContour);
Var NewContours : PContours;
    NewHoles : PHoles;
begin
   inc(P.NumContours);
   getmem(NewHoles, P.NumContours * sizeof(integer));
   move(P.Holes^, NewHoles^, (P.NumContours - 1) * sizeof(integer));
   getmem(NewContours, P.NumContours * sizeof(TContour));
   move(P.Contours^, NewContours^, (P.NumContours - 1) * sizeof(TContour));
   NewContours^[P.NumContours - 1] := Contour;
   NewHoles^[P.NumContours - 1] := 0;
   if P.Contours <> nil then
     freemem(P.Contours);
   if P.Holes <> nil then
     freemem(P.Holes);
   P.Contours := NewContours;
   P.Holes := NewHoles;
end;

procedure TShapeObject.InitContours;
Var PrevShape, OldShape, FirstVertex, i : integer;
    PTemp, PTemp1 : TPolygon;
    Holes : array[1..2] of integer;
    Contour : TContour;
begin
   PTemp.Holes := @Holes[1];
   PTemp.Contours := @Contour;
   PTemp.NumContours := 1;
   PTemp.Holes[0] := 0;
   OldShape := -1;
   PrevShape := -1;
   FirstVertex := 0;
   for i := 0 to NumVertexes - 1 do
     begin
        if (i mod 10000) = 0 then
           Interf.SetStatus('Processing Shape contours : ' + inttostr(i) + ' processed');
        if OldShape <> ShapeOfVertex[i] then
          begin
            if OldShape <> - 1 then
               begin
                  Contour.NumVertexes := i - FirstVertex;
                  Contour.Vertexes := @Vertexes[FirstVertex];
                  if OldShape >=0 then
                     AddContour(ShapeRecs[OldShape].Area, Contour)
                  else
                     AddContour(ShapeRecs[PrevShape].Area, Contour);
               end;
            FirstVertex := i;
            if OldShape >= 0 then
              PrevShape := OldShape;
            OldShape := ShapeOfVertex[i];
          end;
     end;
end;

procedure TShapeObject.InsertVertex(lon, lat : single; Shape : integer);
begin
   if Shape = 3518 then
     Shape := 3518;
   if Lon > 365 then
     Lon := Lon;
   inc(NumVertexes);
   if NumVertexes > length(Vertexes) then
     begin
       setlength(Vertexes, round(NumVertexes * 1.3) + 100);
       setlength(ShapeOfVertex, length(Vertexes));
     end;
   ShapeOfVertex[NumVertexes-1] := Shape;
   Vertexes[NumVertexes-1].X := lon;
   Vertexes[NumVertexes-1].Y := lat;
end;

const _loaded : integer = 0;

{procedure TShapeObject.AddFile(Name : String);
Var
    Name1, S  : String;
    NewOffset, OldShape, Idx, p, pp, index : integer;
    Info, D,  line, center : String;
    lon, lat : single;
    skip : array of boolean;
begin
   Interf.SetStatus(inttostr(_loaded) + ' census files loaded');
   inc(_loaded);
   Name1 := TheFullFileName(Name) + 'a.dat';
   ReadStringFile(Name1, S);
   P := 1;
   Idx := 0;
   while P < length(S) do
     begin
       ScanLine(S, P, line);
       pp := 1;
       index := Scanint(line, pp);
       if index >= 0 then
         begin
           Info := '';
           while true do
             begin
               ReadQuote(S, P, D);
               if D <> ' ' then
                 if Info = '' then
                    Info := D
                 else
                    Info := Info + TAB + D;
               if D = '' then
                 break;
               MoveToEol1(S, P); Nextline(S, P);
             end;
           if (Idx+ShapeOffset) >= length(ShapeRecs) then
             setlength(ShapeRecs, round((ShapeOffset+Idx) * 1.2) +10);
           if (Idx > 0) and (Info <> '') then
             begin
               ShapeRecs[ShapeOffset+Idx - 1].Info := AllocateStr1(Info);
               ShapeRecs[ShapeOffset+Idx - 1].index := index;
               inc(idx);
             end;
           if idx = 0 then
             idx := 1;
         end;
     end;
   NewOffset := ShapeOffset + Idx - 1;
   NumShapeRecs := ShapeOffset + Idx - 1;
   ReadStringFile(Name, S);
   OldShape := -1;
   P := 1;
   idx := 0;
   while P < length(S) do
     begin
        scanline(S, P, center);
        if center = 'END' then
          break;
        pp := 1;
        index := scanint(center, pp);
        if index > 0 then
          if Shaperecs[ShapeOffset+idx].index <> index then
            inc(_debug)
          else
            begin
                if index >= 0 then
                  begin
                    if OldShape = Idx then
                       insertvertex(0,0,-1);
                    Shaperecs[ShapeOffset+idx].CX := scandouble(center, pp);
                    Shaperecs[ShapeOffset+idx].CY := scandouble(center, pp);
                  end;
                scanline(S, p, line);
                while line <> 'END' do
                   begin
                     pp := 1;
                     lon := scandouble(line, pp);
                     lat := scandouble(line, pp);
                     if (OldShape > -1) and (index = -99999) then
                        insertvertex(lon, lat, -99999)
                     else if (idx >= 0) and (Shaperecs[ShapeOffset+idx].info <> '') then
                        insertvertex(lon, lat, ShapeOffset+idx);
                     scanline(S, p, line);
                   end;
                if index >= 0 then
                  begin
                    if Shaperecs[ShapeOffset+idx].info = '' then
                      OldShape := -1
                    else
                      OldShape := Idx;
                    inc(idx);
                  end;
            end;
//              raise Exception.create('invalid line at position ' + inttostr(Idx));
     end;
     ShapeOffset := NewOffset;
//   Calibrate;
end;}

procedure TShapeObject.AddFile(Name : String);
Var
    Name1, S  : String;
    NewOffset, OldShape, Idx, p, pp, index : integer;
    Info, D,  line, center : String;
    lon, lat : single;
begin
   Interf.SetStatus(inttostr(_loaded) + ' census files loaded');
   inc(_loaded);
   Name1 := TheFullFileName(Name) + 'a.dat';
   ReadStringFile(Name1, S);
   P := 1;
   Idx := 0;
   while P < length(S) do
     begin
       ScanLine(S, P, line);
       pp := 1;
       index := Scanint(line, pp);
       if index >= 0 then
         begin
{           if index <> Idx then
              raise Exception.create('invalid line at position ' + inttostr(Idx));}
           Info := '';
           while true do
             begin
               inc(_debug);
               if (_debug = 85308) then
                  _debug := 85308;
               ReadQuote(S, P, D);
               if D <> ' ' then
                 if Info = '' then
                    Info := D
                 else
                    Info := Info + TAB + D;
               if D = '' then
                 break;
               MoveToEol1(S, P); Nextline(S, P);
             end;
           if (Idx+ShapeOffset) >= length(ShapeRecs) then
             setlength(ShapeRecs, round((ShapeOffset+Idx) * 1.2) +10);
           if Idx > 0 then
             begin
               ShapeRecs[ShapeOffset+Idx - 1].Info := AllocateStr1(Info);
               ShapeRecs[ShapeOffset+Idx - 1].index := index;
               ShapeRecs[ShapeOffset+Idx - 1].Area.NumContours := 0;
               ShapeRecs[ShapeOffset+Idx - 1].Area.Contours := nil;
               ShapeRecs[ShapeOffset+Idx - 1].Area.Holes := nil;
             end;
           if Info <> '' then
             inc(idx)
           else if idx = 0 then
             idx := 1;
         end;
     end;
   NewOffset := ShapeOffset + Idx - 1;
   NumShapeRecs := ShapeOffset + Idx - 1;
   ReadStringFile(Name, S);
   OldShape := -1;
   P := 1;
   idx := 0;
   while P < length(S) do
     begin
        inc(_debug);
        if (_debug = 85308) then
                _debug := 85308;
        scanline(S, P, center);
        if center = 'END' then
          break;
        pp := 1;
        index := scanint(center, pp);
        if index >= 0 then
          begin
            if OldShape = Idx then
               insertvertex(0,0,-1);
            Shaperecs[ShapeOffset+idx].CX := scandouble(center, pp);
            Shaperecs[ShapeOffset+idx].CY := scandouble(center, pp);
          end;
        scanline(S, p, line);
{        if index > 0 then
          if Shaperecs[ShapeOffset+idx].index <> index then
           raise Exception.create('invalid line at position ' + inttostr(Idx));}
        while line <> 'END' do
           begin
             inc(_debug);
             if (_debug = 85308) then
                  _debug := 85308;
             pp := 1;
             lon := scandouble(line, pp);
             lat := scandouble(line, pp);
             if Shaperecs[ShapeOffset+idx].index = index then
             if (OldShape > -1) and (index = -99999) then
                insertvertex(lon, lat, -99999)
             else if (idx >= 0) and (Shaperecs[ShapeOffset+idx].info <> '') then
                insertvertex(lon, lat, ShapeOffset+idx);
             scanline(S, p, line);
           end;
        if index >= 0 then
          begin
            if Shaperecs[ShapeOffset+idx].info = '' then
              OldShape := -1
            else
              OldShape := Idx;
            if Shaperecs[ShapeOffset+idx].index = index then
               inc(idx);
          end;
     end;
     ShapeOffset := NewOffset;
//   Calibrate;
end;

procedure TShapeObject.MainThreadInit;
begin
   Map:=coiShp.Create;
   Map.Document.Name:= ShpName;
   Map.CheckStatus:=5;
   if not Map.Open then
      ShpName := '';
end;

type TCountryName = record
         Name : String;
         Abb : String;
end;

const CountryNames : array of TCountryName = nil;
const CityNames : array of TCountryName = nil;
function TShapeObject.FindCountryAbbrev(CountryName, CityName : String) : String;
Var F : textfile;
    i, p : integer;
    S, line, Name, Abb : String;
begin
   if CountryNames = nil then
      begin
         ReadStringFile(Dir1+'Country.abb', S);
         P := 1;
         while P < length(S) do
           begin
              ScanLine(S, p, line);
              ExtractFieldByNum(line, 1, Abb);
              ExtractFieldByNum(line, 2, Name);
              Abb := UpStr(Abb);
              Name := UpStr(Name);
              setlength(CountryNames, length(CountryNames) + 1);
              CountryNames[length(CountryNames) - 1].Name := Name;
              CountryNames[length(CountryNames) - 1].Abb := Abb;
           end;
         CloseFile(F);
      end;
   if CityNames = nil then
      begin
         ReadStringFile(Dir1+'all.cities', S);
         P := 1;
         while P < length(S) do
           begin
              ScanLine(S, p, line);
              ExtractFieldByNum(line, 2, Name);
              ExtractFieldByNum(line, 4, Abb);
              Abb := UpStr(Abb);
              Name := UpStr(Name);
              setlength(CityNames, length(CityNames) + 1);
              CityNames[length(CityNames) - 1].Name := Name;
              CityNames[length(CityNames) - 1].Abb := Abb;
           end;
         CloseFile(F);
      end;
   CountryName := UpStr(CountryName);
   Result := '';
   for i := 0 to length(CountryNames) -1 do
     if CountryNames[i].Name = CountryName then
        begin
           Result := CountryNames[i].Abb;
           exit;
        end;
   CityName := UpStr(CityName);
   if Result = '' then
      begin
       for i := 0 to length(CityNames) -1 do
         if CityNames[i].Name = CityName then
            begin
               Result := CityNames[i].Abb;
               exit;
            end;
      end;
   if CountryName = 'UNITED STATES' then
      Result := 'US'
   else if CountryName = 'RUSSIA' then
      Result := 'RU'
   else if CountryName = 'BRUNEI' then
      Result := 'BN'
   else if CountryName = 'MOLDOVA' then
      Result := 'MD'
   else if CountryName = 'TAJIKISTAN' then
      Result := 'TJ'
   else if CountryName = 'BURMA' then
      Result := 'MM'
   else
      Result := '';
end;

procedure TShapeObject.MainTableInit;
begin
   GTable.Active := true;
end;

procedure TShapeObject.AddDBFFile(Name : String);
Var
    CityName, CountryName, Abb, Name1, S  : String;
    High, Low, NP,  i, NumParts, part, NewOffset, OldShape, Idx, p, pp, index : integer;
    Info, D,  line, center, Header : String;
    CX, CY, X, Y : double;
    RecPoints:OleVariant;
    F : TextFile;
    recordnum : integer;
begin
   Map := nil;
   if TheFileExt(Upstr(Name)) <> 'DBF' then
     exit;
   Interf.SetStatus('Loading ' + Name);
   GTable.TableName := Name;
   GTable.Active := true;
//   GTable.Active := true;
//   MainThreadExec(MainTableInit);
   Header := 'REPORT: ' + Name;
   Header := Header + #13+#10 + 'FIELD DEFINITIONS:' + #13+#10;
   S := '';
   for i := 0 to GTable.FieldCount - 1 do
     begin
        Header := Header + 'FIELD-' + inttostr(i+1) + TAB + GTable.Fields[i].FieldName + #13+#10;
        if S = '' then
          S := GTable.Fields[i].FieldName
        else
          S := S + TAB + GTable.Fields[i].FieldName;
     end;
   Header := Header + #13+#10 + '=' + #13+#10 + S + #13+#10 + '==' + #13+#10;
   AssignFile(F, Dir1 + 'Header.ttt');
   rewrite(F);
   writeln(F, Header);
   closefile(F);

   recordnum := 1;
   GTable.First;
   ShpName:=TheFullFileName(Name) + '.SHP';
   MainThreadExec(MainThreadInit);
try
   Idx := 0;
   while not GTable.EOF do
     begin
       Line := GTable.Fields[0].AsString;
       for i := 1 to GTable.FieldCount - 1 do
          Line := Line + TAB + GTable.Fields[i].AsString;
       if command = 'country' then
          begin
            ExtractFieldByNum(Line, 1, CountryName);
            ExtractFieldByNum(Line, 6, CityName);
            Abb := FindCountryAbbrev(CountryName, CityName);
            Line := Line + TAB + Abb;
          end;
       if (Idx+ShapeOffset) >= length(ShapeRecs) then
          setlength(ShapeRecs, round((ShapeOffset+Idx) * 1.2) +10);
       ShapeRecs[ShapeOffset+Idx].Info := AllocateStr1(LIne);
       ShapeRecs[ShapeOffset+Idx].index := ShapeOffset+Idx;
       ShapeRecs[ShapeOffset+Idx].Area.NumContours := 0;
       ShapeRecs[ShapeOffset+Idx].Area.Contours := nil;
       ShapeRecs[ShapeOffset+Idx].Area.Holes := nil;
       NumParts := Map.Parts[recordnum, 0];
       High := -1;
       RecPoints:=Map.GetRecordPoints(recordnum);
       cx := 0;
       CY := 0;
       NP := 0;
       for Part := 1 to NumParts do
          begin
             Low := High + 1;
             if Part = NumParts then
                High := Map.RecordPointCount[recordnum] -1
             else
                High := Map.Parts[recordnum, Part+1] - 1;
             for i:= low to high do
               begin
                  X := RecPoints[i,0];
                  Y := RecPoints[i,1];
                  CX := CX + X;
                  CY := CY + Y;
                  inc(NP);
                  if Part = 1 then
                    insertvertex(X, Y, ShapeOffset+Idx)
                  else
                    insertvertex(X, Y,-99999);
               end;
             insertvertex(0,0,-1);
          end;
       ShapeRecs[ShapeOffset+Idx].CX := 0;//CX /NP;
       ShapeRecs[ShapeOffset+Idx].CY := 0;//CY /NP;
       inc(recordNum);
       inc(Idx);
       GTable.Next;
     end;
     ShapeOffset := ShapeOffset+Idx;
 finally
     GTable.Active := false;
   if Map <> nil then
     Map.Terminate;
   Map := nil;
 end;
end;


function ReadDouble(S : String) : single;
Var C : integer;
begin
  Val(S, Result, C);
end;

function NanoTime : int64;
var Res : TLargeInteger;
begin
  if QueryPerformanceCounter(Res) then
    Result := res
  else
    Result := 0;
end;

function NanoFrequency : int64;
Var Res : int64;
begin
  if QueryPerformanceFrequency(res) then
    Result := res
  else
    Result := 1;
end;

procedure TShapeObject.SearchClick;
Var Zr : TShapeResult;
    Z, i : integer;
    T : int64;
    X1, Y1, X2, Y2 : single;
    TT : single;
    S : String;
begin
{   for i := MinShape to MaxShape do
      ShapeRecs[i].Found := false;}
{   with Interf do
     begin
       Interf.Memo1.Lines.Clear;
       X1 := ReadDouble(X1Edit.Text);
       X2 := ReadDouble(X2Edit.Text);
       Y1 := ReadDouble(Y1Edit.Text);
       Y2 := ReadDouble(Y2Edit.Text);
       T := nanotime;
       Zr := Shapesearch(X1, Y1, X2, Y2, 1000);
       TT := (Nanotime - T)/Nanofrequency;
       Str(TT : 10 : 8, S);
       Interf.Label5.Caption := 'Execution time = ' + S;
       for i := 0 to Zr.NumFound - 1 do
         begin
           z := Zr.GetNextShape;}
    //       ShapeRecs[z].Found := true;
{           Interf.Memo1.Lines.Add(IntToStr(z));
         end;}
    {   for i := minShape to maxShape do
         if (ShapeRecs[i].X1 <> 0) and (not ShapeRecs[i].found) then
            z := i;}
{   end;}
end;


constructor TShapeResult.Create(I : TShapeObject);
begin
   Contour.NumVertexes := 5;
   Contour.Vertexes := @Vertexes[0];
   Hole := 0;
   Polygon.NumContours := 1;
   Polygon.Holes := @Hole;
   Polygon.Contours := @Contour;
   Interf := I;
end;

procedure TShapeResult.Init(Precise : boolean);
begin
   PreciseFind := Precise;
   fillchar(Hash, sizeof(Hash), 0);
   NumShapes := 1;
   Vertexes[0].X := X1;
   Vertexes[0].Y := Y1;
   Vertexes[1].X := X2;
   Vertexes[1].Y := Y1;
   Vertexes[2].X := X2;
   Vertexes[2].Y := Y2;
   Vertexes[3].X := X1;
   Vertexes[3].Y := Y2;
   Vertexes[4].X := X1;
   Vertexes[4].Y := Y1;
   NumFound := 0;
   res :=  -1;
end;

procedure TShapeResult.Recycle;
begin
   NextFree := Interf.FirstFreeResult;
   Interf.FirstFreeResult := self;
end;

function TShapeResult.GetNextShape : integer;
begin
  if Res >= 0 then
    Result := Shapes[Res].Shape
  else
    Result := 0;
  Res := Shapes[Res].ResultNext;
  if Res < 0 then
    Recycle;
end;

function TShapeResult.Add(Shape : integer) : boolean;
Var H, i : integer;
begin
   Result := false;
   H := Shape mod length(Hash);
   i := Hash[H];
   while i > 0 do
     begin
       if Shapes[i].Shape = Shape then
          exit;
       i := Shapes[i].HashNext;
     end;
   if NumShapes >= length(Shapes) then
     setlength(Shapes, round(NumShapes*1.2) + 10);
   Shapes[NumShapes].Shape := Shape;
   Shapes[NumShapes].HashNext := Hash[H];
   with Interf.ShapeRecs[Shape] do
      if (not PreciseFind) or (
                  ((X2 <= self.X2) and (X1 >= self.X1)) or
                  ((Y2 <= self.Y2) and (Y1 >= self.Y1)) or
                  Interf.IntersectArea(Shape, Polygon)) then
     begin
       inc(NumFound);
       Shapes[NumShapes].ResultNext := res;
       Res := NumShapes;
       Result := true;
     end;
   Hash[H] := NumShapes;
   inc(NumShapes);
end;


function TShapeResult.GetPolygon(ResX, ResY, Z : integer; center : boolean) : String;
Var Area : TPolygon;
    S : String;
    j, k, P, X, Y, PX, PY : integer;
    W, H : single;
begin
   gpc_polygon_clip1(GPC_INT,  Interf.ShapeRecs[Z].Area, Polygon, Area);
   P := 1;
   PX := -2;
   PY := -2;
//   W := X2 - X1;
//   H := Y2 - Y1;
   W := EarthDistMil(X1,Y1, X2, Y1);
   H := EarthDistMil(X1,Y1, X1, Y2);
   if center then
     begin
       X := round(ResX*EarthDistMil(Interf.ShapeRecs[Z].CX, Y1, X1, Y1)/W);
       Y := round(ResY*EarthDistMil(x1, Interf.ShapeRecs[Z].CY, X1, Y1)/H);
       writeout(S, P, '['+inttostr(X) + TAB + inttostr(resy-Y) + ']'+#10);
     end;
   writeout(S, P, '{'+#10);
   for j := 0 to Area.NumContours - 1 do
       begin
         if Area.Holes[j] = 0 then
            writeout(S, P, '0'+#10)
         else
            writeout(S, P, '1'+#10);
         for k := 0 to Area.Contours[j].NumVertexes-1 do
           begin
             X := round(ResX*EarthDistMil(Area.Contours[j].Vertexes[k].X, Y1, X1, Y1)/W);
             Y := round(ResY*EarthDistMil(X1, Area.Contours[j].Vertexes[k].Y, X1, Y1)/H);
             if (abs(Y - PY) >= 1) or (abs(X - PX) >= 1) then
               begin
                 PX := X;
                 PY := Y;
                 writeout(S, P, inttostr(X) + TAB + inttostr(resy-Y) + #10);
               end;
           end;
       end;
   writeout(S, P, '}'+#10);
   gpc_free_polygon1(Area);
   setlength(S, P-1);
   Result := S;
end;

const MaxTest = 1000;
procedure TShapeObject.TestClick;
Var Zr : TShapeResult;
    i : integer;
    T : int64;
    X1, Y1, X2, Y2 : single;
    TT : single;
    S : String;
begin
   T := nanotime;
//   Total := 0;
   for i := 0 to MaxTest do
      begin
         X1 := -80.5 + (-73.25 + 80.5) * Random(100000000)/100000000;
         Y1 := 39.68 + (41.92 - 39.68) * Random(100000000)/100000000;
         X2 := X1 + DeltaX/20;
         Y2 := Y1 + DeltaY/20;
//         Zr := Shapesearch(X1, Y1, X2, Y2, 1000, Interf.Precise.Checked);
//         Total := Total + Zr.NumFound;
         Zr.Recycle;
      end;
   TT := MaxTest/((Nanotime - T)/Nanofrequency);
   Str(TT : 10 : 8, S);
//   Interf.Label5.Caption := 'Searches per second : ' + S;
end;

function  TShapeObject.FindNearest(Xc, Yc : single; Var MilDist : double) : string;
Var  Zr : TShapeResult;
     dx, dy, x1, x2, y1, y2, m : double;
     precise : boolean;
     limit, i, Z : integer;
begin
 CSWork.Enter;
 precise := true;
 limit := 10;
 dx := MileX(YC)/10;
 dy := MileY/10;
 Result := '';
 m := 1;
 try
   while true do
     begin
       x1 := xc - dx;
       x2 := xc + dx;
       y1 := yc - dy;
       y2 := yc + dy;
       Zr := Shapesearch(x1, y1, x2, y2, limit, precise);
       try
       if Zr.NumFound > limit then
          begin
             m := m / 1.05;
             dx := m*MileX(yc);
             dy := m*MileY;
          end
       else if Zr.Numfound = 0 then
         begin
           Zr.Recycle;
           m := m * 1.5;
           dx := m*MileX(yc);
           dy := m*MileY;
           if (m > 100) then
             begin
               MilDist := m;
               break;
             end;
         end
       else
         begin
           for i := 0 to Zr.NumFound - 1 do
             begin
               Z := Zr.GetNextShape;
               MilDist := m;
               result := ShapeRecs[Z].Info;
             end;
           break;
         end;
       finally
//         zr.free;
       end;
     end;
  finally
     CSWork.Leave;
  end;
end;

function TShapeObject.ProcessQuery(Request: String; AppendEOL : boolean; Var ContentType : String; AppendCommand : boolean; commstr : string = '') : String;
Var
  S, SS : String;
  Zr : TShapeResult;
  Z, i,  p : integer;
  resx, resy, limit : integer;
  T : int64;
  X1, Y1, X2, Y2, xc, yc : single;
  TT, D : double;
  state,printdist,standard, bheader, lbbox, bbox, center, precise, stat, dir, census : boolean;
  sstate, V, VarName : String;
  Info : String;
  bboxdelim : char;
begin
   try
       S := Request;
       p := 1;
       Precise := true;
       x1 := 1e90;
       x2 := 1e90;
       y1 := 1e90;
       y2 := 1e90;
       resx := -1;
       resy := -1;
       limit := 100;
       center := false;
       bbox := false;
       stat := false;
       dir := false;
       census := false;
       lbbox := true;
       bheader := false;
       standard := false;
       printdist := false;
       state := false;
       while P < length(S) do
         begin
           ParseDoubleVar(S, VarName, D, V, p);
           if VarName = 'x1' then
             X1 := D
           else if VarName = 'x2' then
             X2 := D
           else if VarName = 'y1' then
             y1 := D
           else if VarName = 'y2' then
             y2 := D
           else if (VarName = 'precise') and (V = '0') then
              Precise := false
           else if (VarName = 'resx') then
              Resx := valstr(V)
           else if (VarName = 'resy') then
              Resy := valstr(V)
           else if VarName = 'limit' then
             limit := ValStr(V)
           else if VarName = 'center' then
             center := V = '1'
           else if VarName = 'bbox' then
             bbox := V = '1'
           else if VarName = 'header' then
             bheader := V = '1'
           else if VarName = 'stat' then
             Stat := V = '1'
           else if VarName = 'standard' then
             standard := V = '1'
           else if VarName = 'state' then
             state := V = '1'
           else if VarName = 'printdist' then
             printdist := V = '1'
           else if VarName = 'dir' then
             dir := V = '1'
           else if VarName = 'census' then
             census := V = '1'
           else if VarName = 'smallbox' then
              begin
                lbbox := V <> '1';
                bbox := V = '1';
              end;
         end;
       bboxdelim := #10;
       if census then
          bboxdelim := tab;
       if (x1 > 1e89) or (y1 > 1e89) then
         begin
           S := '';
           TT := 0;
         end
       else
         begin
           if y2 > 1e89 then
              y2 := y1 + 0.00001;
           if x2 > 1e89 then
              x2 := x1 + 0.00001;
           if x2 < x1 then
              begin
                d := x1;
                x1 := x2;
                x2 := d;
              end;
           if y2 < y1 then
              begin
                d := y1;
                y1 := y2;
                y2 := d;
              end;
           CSWork.Enter;
           try
           d := 0.02;
           xc := x1;
           yc := y1;
           repeat
               Zr := Shapesearch(x1, y1, x2, y2, limit, precise);
               if (Zr.Numfound = 0) and (Census) then
                 begin
                    if d > 1 then
                      break;
                    x1 := xc - d * MileX(yc);
                    x2 := xc + d * MileX(yc);
                    y1 := yc - d * MileY;
                    y2 := yc + d * MileY;
                    d := d * 1.5;
                    zr.recycle;
                 end
               else
                 break;
             until false;
             if bheader then
                result := header
             else
                Result := '';
             if Zr.NumFound > limit then
                Result := format('#LIMIT EXCEEDED. FOUND:%d', [Zr.NumFound])+#10
             else if Zr.Numfound = 0 then
               Zr.Recycle
             else for i := 0 to Zr.NumFound - 1 do
                   begin
                     Z := Zr.GetNextShape;
                     if Stat then
                       begin
                          if state then
                            begin
                               extractfieldbynum(ShapeRecs[Z].Info, 1, sstate);
                               info := sstate + TAB + ShapeRecs[Z].Info2;
                            end
                          else
                            Info := ShapeRecs[Z].Info2
                       end
                     else
                       Info := ShapeRecs[Z].Info;
                     if length(Info) > 0 then
                        begin
                           if (Resx >= 0) and (Resy >= 0) then
                              Info := Info + #10 + Zr.GetPolygon(ResX, ResY, Z, center);
                           if (not census) and bbox then
                              Info := Info + TAB + computebox(ShapeRecs[Z].LX1, ShapeRecs[Z].LX2, ShapeRecs[Z].LY1, ShapeRecs[Z].LY2);
                           if printdist then
                              begin
                                if census then
                                  begin
                                    info := info + TAB + Command + TAB + AddDir(x1,y1, ShapeRecs[Z].cx, ShapeRecs[Z].cy);
                                    if bbox then
                                      info := info + TAB + computebox(ShapeRecs[Z].LX1, ShapeRecs[Z].LX2, ShapeRecs[Z].LY1, ShapeRecs[Z].LY2) + TAB + CoorStr(ShapeRecs[Z].cy) + TAB + CoorStr(ShapeRecs[Z].cx);
                                  end
                                else
                                  info := info + TAB + CoorStr(ShapeRecs[Z].cy) + TAB + CoorStr(ShapeRecs[Z].cx) + TAB + AddDir(x1,y1, ShapeRecs[Z].cx, ShapeRecs[Z].cy);
                              end
                           else
                              begin
                               if Dir then
                                  info := Info + TAB + AddDir(x1,y1, ShapeRecs[Z].cx, ShapeRecs[Z].cy);
                               if center and (ResX = -1) then
                                  info := info + TAB + CoorStr(ShapeRecs[Z].cy) + TAB + CoorStr(ShapeRecs[Z].cx);
                              end;
                           if bbox and (not census) then
                            if lbbox then
                              info := Info + bboxdelim + 'BBOX:' + TAB + coorstr(ShapeRecs[Z].LX1) + TAB +
                                                 Coorstr(ShapeRecs[Z].LX2) + TAB + Coorstr(ShapeRecs[Z].LY1) +
                                                 TAB + Coorstr(ShapeRecs[Z].LY2)
                              else
                                info := Info + bboxdelim + 'BBOX:' + TAB + coorstr(ShapeRecs[Z].X1) + TAB +
                                                 Coorstr(ShapeRecs[Z].X2) + TAB + Coorstr(ShapeRecs[Z].Y1) +
                                                 TAB + Coorstr(ShapeRecs[Z].Y2);
                           if Census then
                              info := info + TAB + 'census'
                           else  if AppendCommand then
                              info := info + TAB + Command;
                           if (Result <> '') and (not appendeol) then
                              Result := Result + #10;
                           Result := Result + Info;
                           if AppendEol then
                              Result := Result + #10;
                        end;
                   end;
             if not bheader then
               begin
{                 if not appendcommand then
                    Result := Result + #10}
               end
             else
                Result := Result + '===' + #10;
           finally
             CSWork.Leave;

           end;
         end;
   except on E: exception do
      begin
//         Interf.EnableLog;
         Interf.AddLog('Request: ' + Request + ' Exception: ' + E.Message);
         AppendFile(GetHardRootDir1+'Error.LOG', GetTimeText+Dir1+' Shape Request: ' + Request + ' Exception: ' + E.Message);
         Result := 'END. Internal Error. Please report to shaposhn@cs.fiu.edu';
      end;
   end;
end;

procedure TShapeObject.HandleCommand(UnparsedParams : String;
            Var ResponseInfo: String; Var ContentType : String);
Var CType : String;
begin
   ResponseInfo := ProcessQuery(UnparsedParams, true, CType, false);
   ContentType := 'text/plain';
end;

end.
