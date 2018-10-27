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
function DistancePointLine( Var Point, LineStart, LineEnd : XYZ; Var U : double) : double;
Var LineMag : double;
    Intersection : XYZ;
begin
    LineMag := Magnitude(LineEnd, LineStart);
    U := ( ( ( Point.X - LineStart.X ) * ( LineEnd.X - LineStart.X ) ) +
        ( ( Point.Y - LineStart.Y ) * ( LineEnd.Y - LineStart.Y ) ) +
        {( ( Point->Z - LineStart->Z ) * ( LineEnd->Z - LineStart->Z ) )} ) /
        ( LineMag * LineMag );
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
