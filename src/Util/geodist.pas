unit geodist;
interface

function calculateDirAndOffset(angle : double; Var Offset : double) : string;
function calculateDirAndOffset8(angle : double; Var Offset : double) : string;
function GeoDistance(long1 : double; lat1 : double; long2: double; lat2 : double; Var heading_from_point_1_to_point_2 : double) : double;

implementation
uses math;
const  m_PolarRadiusInMeters = 6356752.3142451793;
const  m_EquatorialRadiusInMeters = 6378137.0;
const  m_Flattening = 0;

function calculateDirAndOffset8(angle : double; Var Offset : double) : string;
begin
    offset := 0;
    angle := angle * 180.0 / PI;
    if angle < 0 then
       angle := angle + 360.0;
    if (angle>11.25) and (angle<=33.75) then
      begin
         result := 'NNE';
         offset:=angle-22.5;
      end
    else if (angle>33.75 ) and (angle<=56.25) then
      begin
        result := 'NE';
        offset:=angle-45;
      end
    else if (angle>56.25 ) and (angle<=78.75)  then
      begin
        result := 'ENE';
        offset:=angle-67.5;
      end
    else if (angle>78.75 ) and (angle<=101.25)  then
      begin
        result := 'E';
        offset:=angle-90;
      end
    else if (angle >101.25 ) and ( angle<=123.75)  then
      begin
        result := 'ESE';
        offset := angle-112.5;
      end
    else if (angle >123.75 ) and ( angle<=146.25)  then
      begin
        result:='SE';
        offset := angle-135;
      end
    else if (angle > 146.25 ) and ( angle<=168.75)  then
      begin
        result:='SSE';
        offset:=angle-157.5;
      end
    else if (angle>168.75 ) and (angle<=191.25)  then
      begin
        result := 'S';
        offset:=angle-180;
      end
    else if (angle >191.25 ) and ( angle<=213.75)  then
      begin
        result:='SSW';
        offset:=angle-202.5;
      end
    else if (angle>213.75 ) and (angle<=236.25)  then
      begin
       result := 'SW';
       offset:=angle-225;
      end
    else if (angle>236.25 ) and ( angle<=258.75)  then
      begin
        result:='WSW';
        offset:=angle-247.5;
      end
    else if (angle>258.75 ) and (angle<=281.25)  then
       begin
         result := 'W';
         offset:=angle-270;
       end
    else if (angle>281.25 ) and ( angle<=303.75)  then
       begin
         result := 'WNW';
         offset:=angle-292.5;
       end
    else if (angle>303.75 ) and (angle<=326.25)  then
       begin
         result := 'NW';
         offset:=angle-315;
       end
    else if (angle>326.25 ) and (angle<=348.75)  then
       begin
         result := 'NNW';
         offset:=angle-337.5;
       end
    else if ((angle>348.75 ) and ( angle <=360)) or ((angle>=0 ) and ( angle<11.25))  then
       begin
         result:='N';
         if (angle > 348.75 ) and ( angle<=360) then
           offset := angle-360
         else
           offset := angle;
        end;
end;

function calculateDirAndOffset(angle : double; Var Offset : double) : string;
begin
    offset := 0;
    angle := angle * 180.0 / PI;
    if angle < 0 then
       angle := angle + 360.0;
    if (angle>22.5) and (angle<=67.5) then
      begin
         result := 'NE';
         offset:=angle-45;
      end
    else if (angle>67.5 ) and (angle<=112.5) then
      begin
        result := 'E';
        offset:=angle-90;
      end
    else if (angle>112.5 ) and (angle<=157.5)  then
      begin
        result := 'SE';
        offset:=angle-135;
      end
    else if (angle>157.5 ) and (angle<=202.5)  then
      begin
        result := 'S';
        offset:=angle-180;
      end
    else if (angle >202.5 ) and ( angle<=247.5)  then
      begin
        result := 'SW';
        offset := angle-225;
      end
    else if (angle >247.5 ) and ( angle<=292.5)  then
      begin
        result:='W';
        offset := angle-270;
      end
    else if (angle > 292.5 ) and ( angle<=337.5)  then
      begin
        result:='NW';
        offset:=angle-315;
      end
    else if ((angle>337.5 ) and ( angle <=360)) or ((angle>=0 ) and ( angle<=22.5))  then
       begin
         result:='N';
         if (angle > 337.5 ) and ( angle<=360) then
           offset := angle-360
         else
           offset := angle;
        end;
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


function GeoDistance(long1 : double; lat1 : double; long2: double; lat2 : double; Var heading_from_point_1_to_point_2 : double) : double;
Var
    c, c_value_1, c_value_2, c2a, cosine_of_x, cy, cz, d, e, r_value, s, s_value_1, sa, sine_of_x,
    sy, tangent_1, tangent_2, x, y : double;
    {temp_decimal_degrees,} tmp, point_1_latitude_in_radians, point_1_longitude_in_radians, point_2_latitude_in_radians, point_2_longitude_in_radians : double;
    exit_loop : boolean;
    heading_from_point_2_to_point_1, term_1, term_2,term_3,term_4,term_5 : double;

begin
    point_1_latitude_in_radians  := lat1/180*Pi;
    point_1_longitude_in_radians := long1/180*Pi;
    point_2_latitude_in_radians  := lat2/180*Pi;
    point_2_longitude_in_radians := long2/180*Pi;
    r_value := 1.0 - m_Flattening;
    tangent_1 := ( r_value * sin( point_1_latitude_in_radians ) ) / cos( point_1_latitude_in_radians );
    tangent_2 := ( r_value * sin( point_2_latitude_in_radians ) ) / cos( point_2_latitude_in_radians );
    c_value_1 := 1.0 / sqrt( ( tangent_1 * tangent_1 ) + 1.0 );
    s_value_1 := c_value_1 * tangent_1;
    c_value_2 := 1.0 / sqrt( ( tangent_2 * tangent_2 ) + 1.0 );
    s := c_value_1 * c_value_2;
    heading_from_point_2_to_point_1 := s * tangent_2; // backward_azimuth
    heading_from_point_1_to_point_2 := heading_from_point_2_to_point_1 * tangent_1;
    x := point_2_longitude_in_radians - point_1_longitude_in_radians;
    exit_loop := false;
    while not exit_loop do
    begin
      sine_of_x   := sin( x );
      cosine_of_x := cos( x );
      tangent_1 := c_value_2 * sine_of_x;
      tmp := ( s_value_1 * c_value_2 * cosine_of_x );
      tangent_2 := heading_from_point_2_to_point_1 - tmp;
      sy := sqrt((tangent_1 * tangent_1) + (tangent_2 * tangent_2));
      cy := ( s * cosine_of_x ) + heading_from_point_1_to_point_2;
      y := arctan2(sy, cy);

      // Thanks to John Werner (werner@tij.wb.xerox.com) for
      // finding a bug where sy could be zero. Here's his fix:
      if (( s * sine_of_x ) = 0.0) and ( sy = 0.0 ) then
        sa := 1.0
      else
        sa := ( s * sine_of_x ) / sy;
      c2a := ( (-sa) * sa ) + 1.0;
      cz := heading_from_point_1_to_point_2 + heading_from_point_1_to_point_2;
      if c2a > 0  then
        cz := ( (-cz) / c2a ) + cy;
      e := ( cz * cz * 2.0 ) - 1.0;
      c := ( ( ( ( ( -3.0 * c2a ) + 4.0 ) * m_Flattening ) + 4.0 ) * c2a * m_Flattening ) / 16.0;
      d := x;
      x := ( ( ( ( e * cy * c ) + cz ) * sy * c ) + y ) * sa;
      x := ( ( 1.0 - c ) * x * m_Flattening ) + point_2_longitude_in_radians - point_1_longitude_in_radians;
      if abs( d - x ) > 0.00000000000000000000005  then
        exit_loop := false
      else
        exit_loop := true;
    end;
    heading_from_point_1_to_point_2 := arctan2(tangent_1, tangent_2);
{    temp_decimal_degrees := heading_from_point_1_to_point_2 * 180/pi;
    if temp_decimal_degrees < 0.0 then
      temp_decimal_degrees := temp_decimal_degrees + 360.0;}
    heading_from_point_2_to_point_1 := arctan2( c_value_1 * sine_of_x, ( (heading_from_point_2_to_point_1 * cosine_of_x ) - ( s_value_1 * c_value_2 ) ) ) + PI;
{    temp_decimal_degrees := heading_from_point_2_to_point_1 * 180 / Pi;
    if temp_decimal_degrees < 0 then
      temp_decimal_degrees += 360.0;}
    x := sqrt( ( ( ( 1.0 / r_value / r_value ) - 1 ) * c2a ) + 1.0 ) + 1.0;
    x := ( x - 2.0 ) / x;
    c := 1.0 - x;
    c := ( ( ( x * x ) / 4.0 ) + 1.0 ) / c;
    d := ( ( 0.375 * ( x * x ) ) - 1.0 ) * x;
    x := e * cy;
    s := ( 1.0 - e ) - e;

    term_1 := ( sy * sy * 4.0 ) - 3.0;
    term_2 := ( ( s * cz * d ) / 6.0 ) - x;

    term_3 := term_1 * term_2;
    term_4 := ( ( term_3 * d ) / 4.0 ) + cz;
    term_5 := ( term_4 * sy * d ) + y;

    result := term_5 * c * m_EquatorialRadiusInMeters * r_value;
end;

end.
