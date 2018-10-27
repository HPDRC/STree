unit GPC;
interface

const  GPC_DIFF = 0;
const  GPC_INT = 1;
const  GPC_XOR = 2;
const  GPC_UNION = 3;              

type TVertex = record
        X : double;
        Y : double;
end;

type PVertex = ^TVertex;
     TVertexes = array[0..1000000] of TVertex;
     PVertexes = ^TVertexes;

type TContour = record
      NumVertexes : integer;
      Vertexes : PVertexes;
end;

type THole = integer;
     THoles = array[0..1000000] of integer;
     PHoles = ^THoles;
     PContour = ^TContour;
     TContours = array[0..1000000] of TContour;
     PContours = ^TContours; 

type TPolygon = record
      NumContours : integer;
      Holes : PHoles;
      Contours : PContours;
end;

type PPolygon = ^TPolygon;

procedure gpc_polygon_clip1(gpc_op : integer; Var Subject : TPolygon;
Var Clip : TPolygon; Var Result : TPolygon); cdecl;

procedure gpc_free_polygon1(Var P :TPolygon); cdecl;


implementation
uses syncobjs;

var CSWork : TCriticalSection;


procedure gpc_polygon_clip(gpc_op : integer; Var Subject : TPolygon;
                           Var Clip : TPolygon; Var Result : TPolygon); cdecl; external 'gpc.dll';

procedure gpc_free_polygon(Var P :TPolygon); cdecl; external 'gpc.dll';


procedure gpc_polygon_clip1(gpc_op : integer; Var Subject : TPolygon;
Var Clip : TPolygon; Var Result : TPolygon);
begin
  CSWork.Enter;
  try
    gpc_polygon_clip(gpc_op, Subject, Clip, Result);
  finally
    CSWork.Leave;
  end;
end;

procedure gpc_free_polygon1(Var P :TPolygon);
begin
  CSWork.Enter;
  try
    gpc_free_polygon(P);
  finally
    CSWork.Leave;
  end;
end;



initialization
  CSWork := TCriticalSection.Create;
finalization
  CSWork.Free;
end.
