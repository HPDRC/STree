unit streetinverse;

interface

implementation

type XYZ = record
    X, Y : single;
end;

function Magnitude(Var Point1, Point2 : XYZ) : single;
Var Vector : XYZ;
begin
    Vector.X = Point2.X - Point1.X;
    Vector.Y = Point2.Y - Point1.Y;
//    Vector.Z = Point2->Z - Point1->Z;
    result := sqrt( Vector.X * Vector.X + Vector.Y * Vector.Y );
end;


// from the http://astronomy.swin.edu.au/~pbourke/geometry/pointline/
function DistancePointLine( Var Point, LineStart, LineEnd : XYZ; Var U : double; Var Left : boolean) : double;
Var LineMag : double;
    Intersection : XYZ;
    LX, LY, PX, PY : boolean;
begin
    LX := LineEnd.X - LineStart.X;
    LY := LineEnd.Y - LineStart.Y;
    PX := Point.X - LineStart.X;
    PY := Point.Y - LineStart.Y;
    Left := (LX*PY - LY*PX) > 0;
    LineMag := Magnitude(LineEnd, LineStart);
    U := (PX*LX + PY*LY)/(LineMag*LineMag);
    if U < 0 then
       begin
         result := Magnitude(Point, LineStart);
         U := 0;
         exit;
       end
    else if U > 1 then
      begin
        U := 1;
        result := Magnitude(Point, LineEnd);
        exit;
      end;
    Intersection.X = LineStart.X + U * ( LineEnd.X - LineStart.X );
    Intersection.Y = LineStart.Y + U * ( LineEnd.Y - LineStart.Y );
//    Intersection.Z = LineStart->Z + U * ( LineEnd->Z - LineStart->Z );
    result := Magnitude(Point, Intersection);
end;

end.
