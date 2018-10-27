{*** Zip object indexing using S-tree implementation by A. Shaposhnikov 2002 ***}
{
Indexes all US zip codes and performs web queries.
See the shapeobject.pas for the interface details
}

unit zipobject;
interface

uses
  SysUtils, Stree, GPC1, IdTCPServer, IdCustomHTTPServer,
  IdHTTPServer, webobject, syncobjs;

type TZipCode = record
       X1 : single;
       X2 : single;
       Y1 : single;
       Y2 : single;
       LX1 : single;
       LX2 : single;
       LY1 : single;
       LY2 : single;

       CX, CY : single;
       Info : pchar;
       Info2 : pchar;
//       found : boolean;
       ZipArea : TPolygon;
end;

type TStreeVertex = record
     X, Y : single;
     Zip : integer;
end;

type TZipEntry = record
       Zip : integer;
       ResultNext : integer;
       HashNext : integer;
end;

const MinZip = 1;
const MaxZip = 99999;

type

TZipObject = class;

TZipResult = class
    Vertexes : array[0..4] of TVertex;
    Contour : TContour;
    Hole : integer;
    Polygon : TPolygon;
    X1, Y1, X2, Y2 : single;
    Hash : array[0..127] of integer;
    NumZips : integer;
    Zips1 : array of TZipEntry;
    NextFree : TZipResult;
    Interf : TZipObject;
    NumFound : integer;
    Res : integer;
    PreciseFind : boolean;
    constructor Create(I : TZipObject);
    procedure Init(Precise : boolean);
    function Add(Zip : integer) : boolean;
    function  GetNextZip : integer;
    procedure Recycle;
    function  GetPolygon(ResX, ResY, Z : integer; center : boolean) : String;
end;

TZipObject = class(TWebObject)
  private
    memory : pchar;
    Memsize : integer;
    Mempos : integer;
    FirstFreeResult : TZipResult;
    procedure AllocateInit(S : integer);
    function  AllocateStr(Var S : String) : pchar;
    function  AllocateStr1(Var S : String) : pchar;
    function  Allocate(S : integer) : pointer;
    { Private declarations }
  public

    NumVertexes : integer;
    ZipVertexes : array of TVertex; // 0..NumVertexes - 1
    ZipIndex : array of Integer; // 0..NumVertexes - 1 of pointers to ZipCodes
    NumContours : integer;
    Contours : array of TContour;
    NumCodes : integer;
    ZipCodes : array[MinZip..MaxZip] of TZipCode;

    NumStreeVertexes : integer;
    STreeVertexes : array of TStreeVertex;

    MaxZipWidth : single;
    MaxZipHeight : single;
    MinZipWidth : single;
    MinZipHeight : single;
    DeltaX : single;
    DeltaY : single;
    Stree : TStree;

// persistent data    
    MinX, MaxX : single;
    MinY, MaxY : single;
    AvZipHeight : single;
    AvZipWidth : single;
    CSWork : TCriticalSection;
    
//    procedure Save(Name : string);
//    procedure Load(Name : string);
    destructor Free; override;
    procedure Init(Oldobject: TWebObject = nil); override;
    procedure TestClick; override;
    procedure HandleCommand(UnparsedParams : String;
            Var ResponseInfo: String; Var ContentType : String); override;
    procedure AddFile(Name : String);
    procedure Calibrate;
    procedure BuildStree;
    procedure InsertVertex(lon, lat : single; Zip : integer);
    procedure ObjCoor(ObjID : integer; Var X, Y : single);
    procedure AddStreeVertex(X, Y : single; Zip : integer);
    function  Intersects(Zip : integer; Var R : TZipResult) : boolean;
    function  IntersectArea(Zip : integer; Var Polygon : TPolygon) : boolean;
    procedure InitContours;
    function  ZipSearch(X1, Y1, X2, Y2 : single; limit : integer; precise : boolean = false) : TZipResult;
    procedure LoadAllFiles;
    procedure LoadBase;
    procedure SaveBase(Mem : integer = 0);
    procedure SearchClick;
    procedure ParseZips;
    procedure DumpEmpty;
    procedure DumpCities;
    function  ProcessQuery(Request : String; AppendEOL : boolean; Var ContentType : String; AppendCommand : boolean; commstr : string = '') : String; override;
    procedure DumpRecords(Var c : integer); override;
    function  FindZip(Lat, Lon : single; extend : boolean = true) : integer;
    procedure LoadMissingZips;
    procedure GetInfo2;
end;
    { Public declarations }

Var IZipObject : TZipObject;

implementation
uses FileIO, parser, wintypes, winprocs, CityObject, shapeobject;


procedure TZipObject.GetInfo2;
Var F, K, KK, KT : String;
    i, j, p, c : integer;
begin
   for i := MinZIp to MaxZip do
      with ZipCodes[i] do
         begin
            if i = 33160 then
              c := 33160;
            K := 'Z' + zipstr(i);
            KK := KeyBase.FindRecord(K);
            if (KK = '') and (Zipcodes[i].X1 > 0.001) then
              begin
                appendfile(GetHardRootDir1 + command + '_missing.txt', K + TAB);
                Info2 := nil
              end
            else
              begin
{                p := 1;
                c := 0;
                while (p < length(kk)) and (c < 3) do
                  begin
                    if kk[p] = TAB then
                      inc(c);
                    inc(p);
                  end;
                KT := copy(KK, p+1, length(kk) - P);}
                Info2 := AllocateStr1(KK);
              end;
         end;
end;

procedure TZipObject.DumpRecords(Var c : integer);
Var i : integer;
    S : String;
    F : TextFile;
begin
   AssignFile(F, GethardRootDir1 + 'Zip.CSV');
   Rewrite(F);
   for i := MinZip to MaxZip do
     if ZipCodes[i].CX <> 0 then
     begin
       S := inttostr(i) + ',' + inttostr(c);
       writeln(F, S);
       inc(c);
     end;
   CloseFile(F);
end;

procedure TZipObject.Init;
begin
   NumVertexes := 0;
   ZipVertexes := nil;
   ZipIndex := nil;
   NumCodes := 0;
   memory := nil;
   fillchar(ZipCodes, sizeof(ZipCodes), 0);
   FirstFreeResult := nil;
   CSWork := TCriticalSection.Create;
   if FileExists(Dir1+'Zip.co2') then
     LoadBase
   else
     begin
       ParseZips;
       LoadAllFiles;
       Calibrate;
       InitContours;
       SaveBase;
     end;
end;

destructor TZipObject.Free;
Var F : TZipResult;
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

procedure TZipObject.LoadAllFiles;
Var SR : TSearchRec;
begin
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
   LoadMissingZips;
end;

procedure TZipObject.Calibrate;
Var OldZip, i, CZip : integer;
    MaxXZip, MinXZip, MaxYZip, MinYZip : single;
begin
   Interf.SetStatus('Calibrating ...');
   InsertVertex(0, 0, 0);
   MinY := 1e10;
   MinX := 1e10;
   MaxY := -1e10;
   MaxX := -1e10;
   MaxXZip := -1.e10;
   MinXZip := 1.e10;
   MaxYZip := MaxXZip;
   minYZip := MinXZip;
   OldZip := 0;
   CZip := 0;
   NumCodes := 0;
   NumContours := 0;
   for i := 0 to NumVertexes - 1 do
   begin
     if ZipIndex[i] <> CZip then
       begin
         inc(NumContours);
         CZip := ZipIndex[i];
       end;
     if ZipIndex[i] >= MinZip then
      with ZipVertexes[i] do
       begin
           if ZipIndex[i] <> OldZip then
            begin
               if OldZip <> 0 then
                 begin
                   if OldZip < 90000 then
                   if (MaxXZip - MinXZip) > MaxZipWidth then
                     begin
                       MaxZipWidth := MaxXZip - MinXZip;
                     end;
                   if (MaxXZip - MinXZip) < MinZipWidth then
                     MinZipWidth := MaxXZip - MinXZip;
                   if (MaxYZip - MinYZip) > MaxZipHeight then
                     MaxZipHeight := MaxYZip - MinYZip;
                   if (MaxYZip - MinYZip) < MinZipHeight then
                     MinZipHeight := MaxYZip - MinYZip;
                   if ZipCodes[OldZip].X1 = 0 then
                      begin
                         ZipCodes[OldZip].X1 := MinXZip;
                         ZipCodes[OldZip].X2 := MaxXZip;
                         ZipCodes[OldZip].Y1 := MinYZip;
                         ZipCodes[OldZip].Y2 := MaxYZip;
                      end
                   else
                      begin
                         if ZipCodes[OldZip].X1 > MinXZip then
                           ZipCodes[OldZip].X1 := MinXZip;
                         if ZipCodes[OldZip].X2 < MaxXZip then
                           ZipCodes[OldZip].X2 := MaxXZip;
                         if ZipCodes[OldZip].Y1 > MinYZip then
                           ZipCodes[OldZip].Y1 := MinYZip;
                         if ZipCodes[OldZip].Y2 < MaxYZip then
                           ZipCodes[OldZip].Y2 := MaxYZip;
                      end;
                   inc(NumCodes);
                   AvZipWidth := AvZipWidth + MaxXZip - MinXZip;
                   AvZipHeight := AvZipHeight + MaxYZip - MinYZip;
                 end;
               MaxXZip := -1.e10;
               MinXZip := 1.e10;
               MaxYZip := MaxXZip;
               minYZip := MinXZip;
               OldZip := ZipIndex[i];
             end;
          if X < MinXZip then
            MinXZip := X;
          if X > MaxXZip then
            MaxXZip := X;
          if Y < MinYZip then
            MinYZip := Y;
          if Y > MaxYZip then
            MaxYZip := Y;
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
        Interf.SetStatus('ZIP CODE FILES NOT FOUND!!!');
        exit;
     end;
   AvZipWidth := AvZipWidth / NumCodes;
   AvZipHeight := AvZipHeight / NumCodes;
   BuildStree;
end;

procedure TZipObject.ObjCoor(ObjID : integer; Var X, Y : single);
begin
  X := StreeVertexes[ObjId].X;
  Y := StreeVertexes[ObjId].Y;
end;

procedure TZipObject.AddStreeVertex(X, Y : single; Zip : integer);
begin
  if NumStreeVertexes >= length(StreeVertexes) then
     setlength(StreeVertexes, round(NumStreeVertexes * 1.2) + 10);
  StreeVertexes[NumStreeVertexes].X := X;
  StreeVertexes[NumStreeVertexes].Y := Y;
  StreeVertexes[NumStreeVertexes].Zip := Zip;
  Stree.AddObject(NumStreeVertexes, X, Y, ObjCoor);
  inc(NumStreeVertexes);
end;

procedure TZipObject.BuildStree;
Var i : integer;
    X, Y : single;
begin
   Interf.SetStatus('Building Zip S-tree ...');
   DeltaX := AvZipWidth;
   DeltaY := AvZipHeight;
   Stree := TStree.Create(MinX-2*DeltaX, MinY-2*DeltaY, MaxX+2*DeltaX, MaxY+2*DeltaY, 8, 4, NumCodes*4);
   NumStreeVertexes := 0;
   for i := MinZip to MaxZip do
     if ZipCodes[i].X1 <> 0 then
        begin
          X := ZipCodes[i].X1;
          Y := ZipCodes[i].Y1;
          inc(TotalObjects);
          while Y <= ZipCodes[i].Y2 do
            begin
              AddStreeVertex(X + DeltaX, Y + DeltaY, i);
              inc(TotalVertixes);
              X := X + DeltaX;
              if X > ZipCodes[i].X2 then
                begin
                  X := ZipCodes[i].X1;
                  Y := Y + DeltaY;
                end;
            end;
        end;
end;

function TZipObject.ZipSearch(X1, Y1, X2, Y2 : single; limit : integer; precise : boolean = false) : TZipResult;
Var SI : TStreeIterator;
    Obj : dword;
    cnt : integer;
begin
  Result := FirstFreeResult;
  if Result = nil then
    Result := TZipResult.Create(self)
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
       if Intersects(StreeVertexes[Obj].Zip, Result) then
          if Result.Add(StreeVertexes[Obj].Zip) then
            begin
              inc(cnt);
{              if cnt >= limit then
                break;}
            end;
    end;
end;

{const TotalInt : integer = 0;
const FalseInt : integer = 0;}

function TZipObject.IntersectArea(Zip : integer; Var Polygon : TPolygon) : boolean;
Var Res : TPolygon;
begin
   gpc_polygon_clip1(GPC_INT,  ZipCodes[Zip].ZipArea, Polygon, Res);
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

function TZipObject.Intersects(Zip : integer; Var R : TZipResult) : boolean;
begin
   with ZipCodes[Zip] do
     Result :=  (((X1 >= R.X1) and (X1 <= R.X2)) or
                ((X2 >= R.X1) and (X2 <= R.X2)) or
                ((X1 <= R.X1) and (X2 >= R.X2))) and
                (((Y1 >= R.Y1) and (Y1 <= R.Y2)) or
                ((Y2 >= R.Y1) and (Y2 <= R.Y2)) or
                ((Y1 <= R.Y1) and (Y2 >= R.Y2)));
end;

procedure TZipObject.AllocateInit(S : integer);
begin
  Getmem(memory, S);
  Memsize := S;
  Mempos := 0;
end;

function TZipObject.Allocate(S : integer) : pointer;
begin
  Result := @(Memory[mempos]);
  inc(Mempos, S);
  if MemPos > memSize then
    raise exception.create('ZipObject: Out of memory');
end;

function  TZipObject.AllocateStr(Var S : String) : pchar;
begin
   result := Allocate(Length(S) + 1);
   strpcopy(result, S);
end;

function  TZipObject.AllocateStr1(Var S : String) : pchar;
begin
   getmem(result, Length(S) + 1);
   strpcopy(result, S);
end;

procedure TZipObject.LoadMissingZips;
Var S : String;
    P, Code, Z : integer;
    XX, YY, SZip : String;
    X, Y : single;
begin
   ReadStringFile(dir1 + 'zipcenters.txt', S);
   P := 1;
   while P < length(S) do
     begin
       ExtractField(S, SZip, P);
       ExtractField(S, yy, P);
       ExtractField(S, xx, P);

       Z := ValStr(SZip);
       if Z = 0 then
         raise exception.Create('error');
       Val(YY, Y, Code);
       if Code <> 0 then
         raise exception.Create('error');
       Val(XX, X, Code);
       if Code <> 0 then
         raise exception.Create('error');
{       if ZipCodes[Z].CX = 0 then
         begin}
           ZipCodes[Z].CX := X;
           ZipCodes[Z].CY := Y;
{         end;}
       MoveToEol1(S, P); Nextline(S, p);
     end;
end;

procedure TZipObject.LoadBase;
Var Mem, Ver, i, j, k : integer;
    F : TFileIO;
    S, FileName : String;
    dbl : boolean;
begin
   Interf.SetStatus('Loading zip database ...');
   dbl := false;
   FileName := Dir1 + 'Zip.CO2';
   F := TFileIO.Create(FileName, false, true);
   Mem := F.ReadInt;
   if Mem = -1 then
     begin
       Ver := F.ReadInt; // version
       Mem := F.ReadInt;
     end
   else
     Ver := 0;
   if Mem = 0 then
     AllocateInit(F.GetSize)
   else
     AllocateInit(Mem);
   if dbl then
     begin
       MinX := F.ReadDouble;
       MaxX := F.ReadDouble;
       MinY := F.ReadDouble;
       MaxY := F.ReadDouble;
       AvZipHeight := F.ReadDouble;
       AvZipWidth := F.ReadDouble;
     end
   else
     begin
       MinX := F.ReadSingle;
       MaxX := F.ReadSingle;
       MinY := F.ReadSingle;
       MaxY := F.ReadSingle;
       AvZipHeight := F.ReadSingle;
       AvZipWidth := F.ReadSingle;
     end;
   while true do
      begin
         i := F.ReadInt; // zip code
         if i = 0 then
           break;
         with ZipCodes[i] do
           begin
             inc(NumCodes);
             if dbl then
               begin
                 X1 := F.ReadDouble;
                 Y1 := F.ReadDouble;
                 X2 := F.ReadDouble;
                 Y2 := F.ReadDouble;
                 CX := F.ReadDouble;
                 CY := F.ReadDouble;
               end
             else
               begin
                 X1 := F.ReadSingle;
                 Y1 := F.ReadSingle;
                 X2 := F.ReadSingle;
                 Y2 := F.ReadSingle;
                 CX := F.ReadSingle;
                 CY := F.ReadSingle;
               end;
             F.ReadString(S);
             Info := allocatestr(S);
             if Ver >= 1 then
               begin
                 F.ReadString(S);
                 Info2 := allocatestr(S);
               end;
             ZipArea.NumContours := F.ReadInt;
             ZipArea.Holes := PHoles(Allocate(SizeOf(THole)*ZipArea.NumContours));
             ZipArea.ConTours := PContours(Allocate(SizeOf(TContour)*ZipArea.NumContours));
             for j := 0 to ZipArea.NumContours - 1 do
               begin
                 ZipArea.Holes[j] := F.ReadInt;
                 ZipArea.Contours[j].NumVertexes := F.ReadInt;
                 ZipArea.Contours[j].Vertexes := PVertexes(Allocate(SizeOf(TVertex)*ZipArea.Contours[j].NumVertexes));
                 for k := 0 to ZipArea.Contours[j].NumVertexes-1 do
                   begin
                     if dbl then
                       begin
                         ZipArea.Contours[j].Vertexes[k].X := F.ReadDouble;
                         ZipArea.Contours[j].Vertexes[k].Y := F.ReadDouble;
                       end
                     else
                       begin
                         ZipArea.Contours[j].Vertexes[k].X := F.ReadSingle;
                         ZipArea.Contours[j].Vertexes[k].Y := F.ReadSingle;
                       end;
                     inc(TotalPoints);
                   end;
               end;
           end;
      end;
   F.Free;
   if (MemSIze-Mempos) > 0 then
      SaveBase(Mempos);
   BuildStree;
//   DumpEmpty;
end;

procedure TZipObject.SaveBase(Mem : integer);
Var i, j, k : integer;
    F : TFileIO;
    S : String;
begin
   if Numcodes = 0 then
     exit;
   F := TFileIO.Create(Dir1 + 'Zip.CO2', true, false);
   F.WriteInt(-1);
   F.WriteInt(1); // version
   F.WriteInt(Mem);
   F.WriteSingle(MinX);
   F.WriteSingle(MaxX);
   F.WriteSingle(MinY);
   F.WriteSingle(MaxY);
   F.WriteSingle(AvZipHeight);
   F.WriteSingle(AvZipWidth);
   for i := MinZip to MaxZip do
     if (ZipCodes[i].CX + ZipCodes[i].X1) <> 0 then
      with ZipCodes[i] do
        begin
           F.WriteInt(i); // zip code
           F.WriteSingle(X1);
           F.WriteSingle(Y1);
           F.WriteSingle(X2);
           F.WriteSingle(Y2);
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
           F.WriteInt(ZipArea.NumContours);
           for j := 0 to ZipArea.NumContours - 1 do
             begin
               F.WriteInt(ZipArea.Holes[j]);
               F.WriteInt(ZipArea.Contours[j].NumVertexes);
               for k := 0 to ZipArea.Contours[j].NumVertexes-1 do
                 begin
                   F.WriteSingle(ZipArea.Contours[j].Vertexes[k].X);
                   F.WriteSingle(ZipArea.Contours[j].Vertexes[k].Y);
                 end;
             end;
        end;
   F.WriteInt(0);
   F.Free;
end;

procedure TZipObject.InitContours;
Var PrevZip, OldZip, FirstVertex, i : integer;
    PTemp, PTemp1 : TPolygon;
    Holes : array[1..2] of integer;
    Contour : TContour;
begin
   PTemp.Holes := @Holes[1];
   PTemp.Contours := @Contour;
   PTemp.NumContours := 1;
   PTemp.Holes[0] := 0;
   OldZip := 0;
   PrevZip := 0;
   FirstVertex := 0;
   for i := 0 to NumVertexes - 1 do
     begin
        if (i mod 10000) = 0 then
           Interf.SetStatus('Processing Zip contours : ' + inttostr(i) + ' processed');
        if OldZip <> ZipIndex[i] then
          begin
            if OldZip <> 0 then
               begin
                  Contour.NumVertexes := i - FirstVertex;
                  Contour.Vertexes := @ZipVertexes[FirstVertex];
                  if OldZip > 0 then
                    begin
                       gpc_polygon_clip1(GPC_Union, ZipCodes[OldZip].ZipArea, PTemp, Ptemp1);
                       gpc_free_polygon1(ZipCodes[OldZip].ZipArea);
                       ZipCodes[OldZip].ZipArea := PTemp1;
                    end
                  else
                    begin
                       gpc_polygon_clip1(GPC_Diff, ZipCodes[PrevZip].ZipArea, PTemp, PTemp1);
                       gpc_free_polygon1(ZipCodes[PrevZip].ZipArea);
                       ZipCodes[PrevZip].ZipArea := PTemp1;
                    end;
               end;
            FirstVertex := i;
            if OldZip > 0 then
              PrevZip := OldZip;
            OldZip := ZipIndex[i];
          end;
     end;
end;

procedure TZipObject.InsertVertex(lon, lat : single; Zip : integer);
begin
   inc(NumVertexes);
   if NumVertexes > length(ZipVertexes) then
     begin
       setlength(ZipVertexes, round(NumVertexes * 1.3) + 100);
       setlength(ZipIndex, length(ZipVertexes));
     end;
   ZipIndex[NumVertexes-1] := Zip;
   ZipVertexes[NumVertexes-1].X := lon;
   ZipVertexes[NumVertexes-1].Y := lat;
end;


const _loaded : integer = 0;

procedure TZipObject.ParseZips;
Var S : String;
    Zip, D: String;
    P, Z, Start : integer;
begin
   ReadStringFile(Dir1 + 'Zip_City_State.txt', S);
   P := 1;
   Zip := ' ';
   while P <= length(S) do
     begin
       ReadToQuote(S, P, Zip);
       Start := P;
       MoveToEol1(S, P);
       if Zip <> '' then
         begin
           Z := strtoint(Zip);
           D := Copy(S, Start-1, P - Start+1);
           ZipCodes[Z].Info := allocatestr1(D);
         end;
       NextLine(S, P);
     end;
end;

procedure TZipObject.DumpEmpty;
Var F : TextFile;
    i : integer;
begin
   AssignFile(F, GetHardRootDir1+'ZipError.txt');
   rewrite(F);
   for i := minzip to Maxzip do
     if (ZipCodes[i].X1 <> 0) and (ZipCodes[i].Info = '') then
        writeln(F, inttostr(i));
   closefile(F);
end;

procedure TZipObject.DumpCities;
Var F : TextFile;
    i : integer;
begin
   AssignFile(F, GetHardRootDir1+'ZipCity.txt');
   rewrite(F);
   for i := minzip to Maxzip do
     if ZipCodes[i].X1 <> 0 then
        writeln(F, zipstr(i) + ',' + TCityObject(Interf.WebObjects[CityObj]).GetCityCode(Zipcodes[i].CX, ZipCodes[i].CY) + ZipCodes[i].Info);
   closefile(F);
end;


procedure TZipObject.AddFile(Name : String);
Var Zips : array [0..65536] of integer;
    Name1, S  : String;
    OldZip, Idx, p, pp, index : integer;
    Zip, zip1, zip2, ztype, descr, line, center : String;
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
       if index < 0 then
           break;
       if index <> Idx then
          raise Exception.create('invalid line at position ' + inttostr(Idx));
       scanline(S, p, Zip1);
       scanLine(S, p, Zip2);
       scanline(S, p, ZType);
       scanline(S, p, descr);
       MoveToEol1(S, P); Nextline(S, P);
       Zip := copy(zip1, 3, 5);
       Zips[Idx] := ValStr2(Zip);
       if Zips[Idx] = 997 then
          Zips[Idx] := 997;
       inc(idx);
     end;
   ReadStringFile(Name, S);
   OldZip := 0;
   P := 1;
   while P < length(S) do
     begin
        scanline(S, P, center);
        if center = 'END' then
          break;
        pp := 1;
        idx := scanint(center, pp);
        if idx >= 0 then
          begin
            if OldZip = zips[Idx] then
              insertvertex(0,0,0);
            if Zips[idx] >= MinZip then
              begin
                zipcodes[zips[idx]].CX := scandouble(center, pp);
                zipcodes[zips[idx]].CY := scandouble(center, pp);
              end;
          end;
        scanline(S, p, line);
        while line <> 'END' do
           begin
             pp := 1;
             lon := scandouble(line, pp);
             lat := scandouble(line, pp);
             if (OldZip > 0) and (idx = -99999) then
                insertvertex(lon, lat, -99999)
             else if (idx >= 0) and (Zips[idx] >= MinZip) then
                insertvertex(lon, lat, zips[Idx]);
             scanline(S, p, line);
           end;
        if (idx >= 0) and (Zips[Idx] > MinZip) then
          OldZip := Zips[Idx];
     end;
//   Calibrate;
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

procedure TZipObject.SearchClick;
Var Zr : TZipResult;
    Z, i : integer;
    T : int64;
    X1, Y1, X2, Y2 : single;
    TT : single;
    S : String;
begin
{   for i := Minzip to MaxZip do
      ZipCodes[i].Found := false;}
{   with Interf do
     begin
       Interf.Memo1.Lines.Clear;
       X1 := ReadDouble(X1Edit.Text);
       X2 := ReadDouble(X2Edit.Text);
       Y1 := ReadDouble(Y1Edit.Text);
       Y2 := ReadDouble(Y2Edit.Text);
       T := nanotime;
       Zr := ZipSearch(X1, Y1, X2, Y2, 1000);
       TT := (Nanotime - T)/Nanofrequency;
       Str(TT : 10 : 8, S);
       Interf.Label5.Caption := 'Execution time = ' + S;
       for i := 0 to Zr.NumFound - 1 do
         begin
           z := Zr.GetNextZip;
    //       Zipcodes[z].Found := true;
           Interf.Memo1.Lines.Add(IntToStr(z));}
{         end;}
    {   for i := minzip to maxzip do
         if (Zipcodes[i].X1 <> 0) and (not zipcodes[i].found) then
            z := i;}
{   end;}
end;


constructor TZipResult.Create(I : TZipObject);
begin
   Contour.NumVertexes := 5;
   Contour.Vertexes := @Vertexes[0];
   Hole := 0;
   Polygon.NumContours := 1;
   Polygon.Holes := @Hole;
   Polygon.Contours := @Contour;
   Interf := I;
end;

procedure TZipresult.Init(Precise : boolean);
begin
   PreciseFind := Precise;
   fillchar(Hash, sizeof(Hash), 0);
   NumZips := 1;
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

function TZipResult.GetPolygon(ResX, ResY, Z : integer; center : boolean) : String;
Var Area : TPolygon;
    S : String;
    j, k, P, X, Y, PX, PY : integer;
    W, H : single;
begin
   gpc_polygon_clip1(GPC_INT,  Interf.ZipCodes[Z].ZipArea, Polygon, Area);
   P := 1;
   PX := -2;
   PY := -2;
//   W := X2 - X1;
//   H := Y2 - Y1;
   if center then
     begin
//       X := round(ResX*(Interf.ZipCodes[Z].CX - X1)/W);
//       Y := round(ResY*(Interf.ZipCodes[Z].CY - Y1)/H);
       W := EarthDistMil(X1,Interf.ZipCodes[Z].CY, X2, Interf.ZipCodes[Z].CY);
       H := EarthDistMil(Interf.ZipCodes[Z].CX,Y1, Interf.ZipCodes[Z].CX, Y2);
       X := round(ResX*EarthDistMil(Interf.ZipCodes[Z].CX, Y1, X1, Y1)/W);
       Y := round(ResY*EarthDistMil(x1, Interf.ZipCodes[Z].CY, X1, Y1)/H);
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
            W := EarthDistMil(X1,Area.Contours[j].Vertexes[k].Y, X2, Area.Contours[j].Vertexes[k].Y);
            H := EarthDistMil(Area.Contours[j].Vertexes[k].X,Y1, Area.Contours[j].Vertexes[k].X, Y2);
            X := round(ResX*EarthDistMil(Area.Contours[j].Vertexes[k].X, Y1, X1, Y1)/W);
            Y := round(ResY*EarthDistMil(X1, Area.Contours[j].Vertexes[k].Y, X1, Y1)/H);
//            X := round(ResX*(Area.Contours[j].Vertexes[k].X - X1)/W);
//             Y := round(ResY*(Area.Contours[j].Vertexes[k].Y - Y1)/H);
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


procedure TZipResult.Recycle;
begin
   NextFree := Interf.FirstFreeResult;
   Interf.FirstFreeResult := self;
end;

function TZipResult.GetNextZip : integer;
begin
  if Res >= 0 then
    Result := Zips1[Res].Zip
  else
    Result := 0;
  Res := Zips1[Res].ResultNext;
  if Res < 0 then
    Recycle;
end;

function TZipResult.Add(Zip : integer) : boolean;
Var H, i : integer;
begin
   Result := false;
   H := Zip mod length(Hash);
   i := Hash[H];
   while i > 0 do
     begin
       if Zips1[i].Zip = Zip then
          exit;
       i := Zips1[i].HashNext;
     end;
   if NumZips >= length(Zips1) then
     setlength(Zips1, round(NumZips*1.2) + 10);
   Zips1[NumZips].Zip := Zip;
   Zips1[NumZips].HashNext := Hash[H];
   with Interf.ZipCodes[Zip] do
      if (not PreciseFind) or (
                  ((X2 <= self.X2) and (X1 >= self.X1)) or
                  ((Y2 <= self.Y2) and (Y1 >= self.Y1)) or
                  Interf.IntersectArea(Zip, Polygon)) then
     begin
       inc(NumFound);
       Zips1[NumZips].ResultNext := res;
       Res := NumZips;
       Result := true;
     end;
   Hash[H] := NumZips;
   inc(NumZips);
end;

const MaxTest = 1000;
procedure TZipObject.TestClick;
Var Zr : TZipResult;
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
//         Zr := ZipSearch(X1, Y1, X2, Y2, 1000, Interf.Precise.Checked);
//         Total := Total + Zr.NumFound;
         Zr.Recycle;
      end;
   TT := MaxTest/((Nanotime - T)/Nanofrequency);
   Str(TT : 10 : 8, S);
//   Interf.Label5.Caption := 'Searches per second : ' + S;
end;

function TZipObject.FindZip(Lat, Lon : single; extend : boolean) : integer;
Var  Zr : TZipResult;
     D,DMin, DX, DY, X1, Y1, X2, Y2 : single;
     I, Z : integer;
begin
   CSWork.Enter;
   try
   DX := 0.001*MileX(y1);
   DY := 0.001*MileY;
   X1 := Lon - DX;
   X2 := Lon + DX;
   Y1 := Lat - DY;
   Y2 := Lat + DY;
   repeat
      Zr := ZipSearch(x1, y1, x2, y2, 3, true);
      if (Zr.NumFound = 0) then
        begin
           Zr.Recycle;
           if Extend then
            begin
               DX := DX * 2;
               DY := DY * 2;
               X1 := Lon - DX;
               X2 := Lon + DX;
               Y1 := Lat - DY;
               Y2 := Lat + DY;
            end;
        end;
   until (Zr.NumFound <> 0) or (not Extend);
   DMin := 1000000;
   if Zr.NumFound = 0 then
     result := 0
   else
     for i := 0 to Zr.NumFound - 1 do
       begin
         Z := Zr.GetNextZip;
         D := EarthDistMil(lon,lat, IzipObject.ZipCodes[Z].cx, IzipObject.ZipCodes[Z].cy);
         if D < DMin then
            begin
              result := Z;
              DMin := D;
            end;
       end;
   finally
     CSWork.Leave;
   end;
end;

function TZipObject.ProcessQuery(Request : String; AppendEOL : boolean; Var ContentType : String; AppendCommand : boolean; commstr : string = '') : String;
var
  S : String;
  Zr : TZipResult;
  Z, i, j, p : integer;
//  T : int64;
  X1, Y1, X2, Y2 : single;
  D : double;
  center, precise, Town : boolean;
  V, VarName, info : String;
  resx, resy, limit : integer;
  stat, standard, bbox, PointQuery : boolean;
  dx,dy,xc,yc : single;
begin
   try
       S := Request;
       p := 1;
       Precise := false;
       Town := false;
       x1 := 1e80;
       x2 := 1e80;
       y1 := 1e80;
       y2 := 1e80;
       resx := -1;
       resy := -1;
       limit := 100;
       center := false;
       bbox := false;
       stat := false;
       standard := false;
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
           else if (VarName = 'standard') and (V='1') then
             standard := true
           else if (VarName = 'precise') and (V = '1') then
              Precise := true
           else if (VarName = 'town') and (V = '1') then
              Town := true
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
           else if VarName = 'stat' then
             stat := V = '1';
         end;
       if (resx > 0) and (resy > 0) then
          precise := true;
       PointQuery := false;
       if standard then
         appendeol := true;
       if (x1 > 1e20) or (y1 > 1e20) then
         begin
           S := '';
         end
       else
         begin
           if y2 > 1e20 then
              begin
                PointQuery := true;
                yc := y1;
                xc := x1;
                x1 := xc - 0.00001;
                x2 := xc + 0.00001;
                y1 := yc - 0.00001;
                y2 := yc + 0.00001;
              end;
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
             dx := MileX(Y1) / 100;
             dy := MileY / 100;
             repeat
               Zr := ZipSearch(x1, y1, x2, y2, limit, precise);
               if Zr.NumFound = 0 then
                 begin
                    Zr.Recycle;
                    if PointQuery then
                      begin
                          x1 := xc - dx;
                          x2 := xc + dx;
                          y1 := yc - dy;
                          y2 := yc + dy;
                          dx := dx * 1.5;
                          dy := dy * 1.5;
                          if dy > (MileY / 10) then
                             break;
                      end;
                end;
             until (not PointQuery) or (Zr.NumFound > 0);
             if Zr.NumFound > limit then
                S := format('#LIMIT EXCEEDED. FOUND:%d', [Zr.NumFound]) + #10
             else
               begin
                   if (not bbox) and (not standard) and (not town) and (not stat) and ((resx < 0) or (resy < 0)) then
                      begin
                         setlength(S, Zr.NumFound*6);
                         p := 1;
                         for i := 0 to Zr.NumFound-1 do
                           begin
                             Z := Zr.GetNextZip;
                             for j := 0 to 4 do
                               begin
                                 S[p+4-j] := chr(48 + Z mod 10);
                                 z := z div 10;
                               end;
                             s[p+5] := ' ';
                             inc(p, 6);
                           end;
                       end
                   else
                     begin
                       S := '';
                       for i := 0 to Zr.NumFound - 1 do
                         begin
                           if (S <> '') and (not AppendEol) and (S[length(s)] <> #10) then
                              Result := Result + #10;
                           Z := Zr.GetNextZip;
                           if Town then
                             if Stat then
                               Info := ZipCodes[Z].Info + TAB + ZipCodes[Z].Info2
                             else
                               Info := ZipCodes[Z].Info
                           else if Stat then
                              Info := ZipCodes[Z].Info2
                           else
                              Info := '';
                           if Stat then
                             S := S + Info
                           else
                             S := S + zipstr(Z) + Info;
                           if AppendCommand then
                             S := S + TAB + command + #10
                           else
                             S := S + #10;
                           if bbox then
                             S := S + 'BBOX:' + TAB + coorstr(ZipCodes[Z].X1) + TAB +
                                           Coorstr(ZipCodes[Z].X2) + TAB +
                                           Coorstr(ZipCodes[Z].Y1) + TAB +
                                           Coorstr(ZipCodes[Z].Y2) + #10;

                           if (Resx >= 0) and (Resy >= 0) then
                             S := S + Zr.GetPolygon(ResX, ResY, Z, center);
                           if AppendEol and (S[length(s)] <> #10)then
                              Result := Result + #10;
                         end;
                     end;
               end;
           finally
             CSWork.Leave;
           end;
         end;
       if (not appendEOL) or ((length(S) > 0) and (S[length(S)] = #10))  then
         Result := S
       else
         Result := S + #10;
   except on E: exception do
      begin
//         Interf.EnableLog;
         Interf.AddLog('Request: ' + Request + ' Exception: ' + E.Message);
         AppendFile(GetHardRootDir1+'Error.LOG', GetTimeText+'Zip Request: ' + Request + ' Exception: ' + E.Message);
         Result := 'END. Internal Error. Please report to shaposhn@cs.fiu.edu';
      end;
   end;
end;

procedure TZipObject.HandleCommand(UnparsedParams : String;
            Var ResponseInfo: String; Var ContentType : String);
Var CType : String;
begin
   ResponseInfo := ProcessQuery(UnparsedParams, False, CType, false) + 'END.';
   ContentType := 'text/plain';
end;

end.
