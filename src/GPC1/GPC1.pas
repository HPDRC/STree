unit GPC1;
interface

const  GPC_DIFF = 0;
const  GPC_INT = 1;
const  GPC_XOR = 2;
const  GPC_UNION = 3;              

type TVertex = record
        X : single;
        Y : single;
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

procedure gpc_polygon_clip(gpc_op : integer; Var Subject : TPolygon;
Var Clip : TPolygon; Var Result : TPolygon); cdecl;

procedure gpc_free_polygon(Var P :TPolygon); cdecl;

implementation

procedure gpc_polygon_clip(gpc_op : integer; Var Subject : TPolygon;
                           Var Clip : TPolygon; Var Result : TPolygon); cdecl; external 'gpc1.dll';

procedure gpc_free_polygon(Var P :TPolygon); cdecl; external 'gpc1.dll';

end.
