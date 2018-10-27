{
Implements the hotel explorer command:

explore - Interactive hotel browser interface that allows you to search for hotels by zip code, city name, and location coordinates.

Example:

http://n158.cs.fiu.edu/explore

}

unit exploreobject;
interface

uses
  SysUtils, Stree,  IdHTTPServer, Syncobjs, webobject, IdCustomHTTPServer,
  ZipObject, CityObject, StripObject;


type TExploreObject = class(TWebObject)
  public
// persistent data
    CSWork : TCriticalSection;
    ZipObject : TZipObject;
    CityObject : TCityObject;
    HotelObject : TStripObject;
    destructor Free; override;
    procedure Init(Oldobject: TWebObject = nil); override;
    procedure HandleCommand(UnparsedParams : String;
                            Var ResponseInfo: String; Var ContentType : String); override;
    function MakeHTML(Zip : integer; Miles : double; Var City : String; x, y : double; limit : integer) : String;
    function Hotelformat(Var S : String; CX, CY, Miles : double; test : boolean) : String;
  end;

implementation
uses parser, math, streetobject;

procedure TExploreObject.Init;
begin
   ZipObject := TZipObject(Interf.Webobjects[ZipObj]);
   CityObject := TCityObject(Interf.Webobjects[CityObj]);
   HotelObject := TStripObject(Interf.Webobjects[HotelObj]);
   CSWork := TCriticalSection.Create;
end;

destructor TExploreObject.Free;
begin
   CSWork.Free;
end;

function TExploreObject.MakeHTML(Zip : integer; Miles : double; Var City : String; x, y : double; limit : integer) : String;
begin
    Result :=
'<html><head><META HTTP-EQUIV="content-type" CONTENT="text/html; charset=ISO-8859-1">'+
'<title>Worldwide Hotel Explorer</title></head>'+
'<body bgcolor=#ffffff text=#000000 link=#0000cc vlink=#551a8b alink=#ff0000>'+
'<form action="/explore">'+
'<center><b><font size="5">Worldwide Hotel Explorer</font></b></center><p><b>Search hotels '+
'within </b><input size=5 name=miles value="'+ format('%.1f', [Miles]) + '"> <b>miles of:</b> </p>'+
'<p><b>- center of a ZIP code:</b> <input size=6 name=zip value="'+ inttostr(zip) + '">&nbsp;'+
'<input type=submit value="Search" name=zipsrch> </p>'+
'<p><b>- center of a city:</b>&nbsp; <input size=15 name=city value="'+City +
'"> <input type=submit value="Search" name=citysrch> </p>'+
'<p><b>- the point with </b><b>l</b><b>ongitude:</b><input size=8 name=x1 value="' + format('%.6f', [x]) + '">' +
'<b>and</b> <b>latitude:</b><input size=8 name=y1 value="' + format('%.6f', [y]) + '">&nbsp;<input type=submit value="Search" name=coorsrch> </p>'+
'<p><b>Limit the result size by:</b><input size=5 name=limit value="' + inttostr(limit) + '">&nbsp;<b>records</b></p>'+
'<p><font size="1">powered by S-tree</font></p></body></html>';



{    '<html><head><META HTTP-EQUIV="content-type" CONTENT="text/html; charset=ISO-8859-1">'+
    '<title>Hotel Explorer</title></head>'+
    '<body bgcolor=#ffffff text=#000000 link=#0000cc vlink=#551a8b alink=#ff0000>'+
    '<form action="/explore">'+
    '<center><b><font size="5">Hotel Explorer</font></b></center><p><b>Search by ZIP code:</b> <input size=6 name=zip value="' + inttostr(zip) +
    '">&nbsp;<input type=submit value="Search" name=zipsrch> </p>'+
    '<p><b>or within </b><input size=5 name=miles value="' + format('%.1f', [Miles]) +'"> <b>miles of:</b> </p>'+
    '<p><b>the city:</b>&nbsp; <input size=15 name=city value="' + City + '"> <input type=submit value="Search" name=citysrch> </p>'+
    '<p><b>or coordinates:</b>&nbsp;<b>Longitude:</b><input size=8 name=x1 value="'+ format('%.6f', [x])+
    '"><b>Latitude:</b><input size=8 name=y1 value="'+ format('%.6f', [y]) + '">&nbsp;<input type=submit value="Search" name=coorsrch> </p>'+
    '<p><b>Limit the result size by:</b><input size=5 name=limit value="' + inttostr(limit) + '">&nbsp;<b>records</b></p>'+
    '<p><font size="1">powered by S-tree</font></p> </body></html>';}
end;


const _Deb : integer = 0;
function TExploreObject.Hotelformat(Var S : String; CX, CY, Miles : double; test : boolean) : String;
Var P : integer;
        HotelName: String;
        HotelChain: String;
        ReserveURL: String;
        InfoURL: String;
        Stars: String;
        Street, street1: String;
        Debug : TDebug;
        City: String;
        State: String;
        Country: String;
        Zip: String;
        Phone: String;
        PhotoURL: String;
        Source: String;
        PropertyID: String;
        Latitude: String;
        Longitude: String;
        Distance: String;
        Compass: String;
        CompassOffset: String;
        Facilities: String;
        Policy: String;
        BestRate: String;
        Currency: String;
        Suuplier: String;
        Long2: String;
        Lat2: String;
        DayRate: String;
        RateType: String;
        Accomodation: String;
        Error : String;
        Photo : String;
        xx, yy, X, Y, Dist : double;
        found : boolean;
        disterror : boolean;
        Processed : integer;
        NumFound : integer;
        TT : int64;
        TotalTime : int64;
        Approx : integer;
begin
  P := 1;
  Processed := 0;
  NumFound := 0;
  TotalTime := 0;
  if S = '' then
    begin
      Result := '<p><b> No hotels found in selected area</b><p>';
      exit;
    end;
  Result :=
//                    '<p><b>S-tree Search Done. Execution time =' + TimeS +' Seconds</b></p>'+
'<table border="1" width="100%">'+
'<tr>'+
    '<td width="12%"><b>Hotel Name</b></td>'+
    '<td width="4%"><b>Distance from the selected point</b></td>'+
    '<td width="7%"><b>Other hotels nearby</b></td>'+
    '<td width="10%"><b>Street/Zip</b></td>'+
    '<td width="2%"><b>Stars</b></td>'+
    '<td width="3%"><b>Picture</b></td>'+
    '<td width="6%"><b>Phone</b></td>'+
'</tr>';
  while p < length(S) do
    begin
      ExtractField(S, HotelName, P);
      if HotelName = '===' then
         break;
      ExtractField(S, HotelChain, P);
      ExtractField(S, ReserveURL, P);
      ExtractField(S, InfoURL, P);
      ExtractField(S, Stars, P);
      ExtractField(S, Street, P);
      ExtractField(S, City, P);
      ExtractField(S, State, P);
      ExtractField(S, Country, P);
      ExtractField(S, Zip, P);
      ExtractField(S, Phone, P);
      ExtractField(S, PhotoURL, P);
      ExtractField(S, Source, P);
      ExtractField(S, PropertyID, P);
      ExtractField(S, Latitude, P);
      ExtractField(S, Longitude, P);
      X := strtodouble(Longitude);
      Y := strtodouble(Latitude);
      ExtractField(S, Distance, P);
      ExtractField(S, Compass, P);
      ExtractField(S, CompassOffset, P);
      ExtractField(S, Facilities, P);
      ExtractField(S, Policy, P);
      ExtractField(S, BestRate, P);
      ExtractField(S, Currency, P);
      ExtractField(S, Suuplier, P);
      ExtractField(S, Long2, P);
      ExtractField(S, Lat2, P);
      ExtractField(S, DayRate, P);
      ExtractField(S, RateType, P);
      ExtractField(S, Accomodation, P);
      movetoeol1(S, P); Nextline(S, P);
      if Zip = '' then
        Zip := '&nbsp;';
      if Stars = '' then
        Stars := '&nbsp;';
      if Phone = '' then
        Phone := '&nbsp;';
      if PhotoUrl = '' then
        Photo := '<td width="2%">&nbsp;</td>'
      else
        Photo := '<td width="3%">'+'<a href="' + PhotoURL +'"><img border="0" src="'+ PhotoUrl+'" width="84" height="63"></a></td>';
      Dist := EarthDistMil(cX, cY, X, Y);
//      if Dist <= Miles then
      if test then
         begin
           UPString(City);
           UpString(State);
           found := true;
           DistError := false;
           Dist := 0;
           if true then
             begin
               inc(Processed);
               Street1 := street;
               inc(_Deb);
               TT := NanoTime;
               xx := 0;
               yy := 0;
               Debug.Debug := false;
{               if Street1 = '21485 NW 27th Ave.' then
                 Street1 := '21485 NW 27th Ave.';}
               istreetobject.FindHouseByZip(street1, zip, city, state, Xx, Yy, Approx, Debug, Error, false);
               if Approx <= 2 then
                 begin
                  Dist := EarthDistMil(x,y,xx,yy);
                  if Dist > 0.5 then
                     DistError := true;
                  inc(NumFound);
                 end
               else
                 begin
                    Found := false;
                    Dist := 0;
                 end;
               TT := NanoTime - TT;
               inc(TotalTime, TT);
             end;
           if DistError or (not found) then
             Result := Result +
             '<tr>'+
             '<td width="12%">' +
             //'<a href="http://www.mapblast.com/myblast/map.mb?CMD=LFILL&CT=' +
//                 CoorStr1(yY) + '%3A' +CoorStr1(xX)+'%3A20000">LAT='+  CoorStr1(yY) +' Lon='+CoorStr1(xX) +
            '<a href="' + InfoURL +'">'+HotelName + '</a>'+
            '</td>'+
             '<td width="4%">' + format('%.2f miles', [Dist]) +'</td>'+
             '<td width="7%"> Find House: <a href="/street?debug=1&city=' + city+ '&state=' + state + '&zip=' + ZIP + '&street=' + street1+'">' + street1 + '</a> &nbsp;</td>'+
             '<td width="10%">' + MapUrl1(Street +' '+City + ' ' + State +' '+ Zip, Longitude, Latitude)+'</td>'+
             '<td width="2%">'+ Stars+'</td>'+
             Photo+
             '<td width="6%">' + Phone + '</td>'+
             '</tr>';
         end
      else
         begin
              Result := Result +
          '<tr>'+
            '<td width="12%"><a href="' + InfoURL +'">'+HotelName + '</a></td>'+
            '<td width="4%">' + format('%.2f miles', [Dist]) +'</td>'+
            '<td width="7%"> Nearby within: '+
            '<a href="/explore?x1='+longitude +'&y1='+latitude +'&miles=0.5&coorsrch=Search">0.5</a> &nbsp;'+
            '<a href="/explore?x1='+longitude +'&y1='+latitude +'&miles=1.0&coorsrch=Search">1</a> &nbsp;'+
            '<a href="/explore?x1='+longitude +'&y1='+latitude +'&miles=2.0&coorsrch=Search">2</a> &nbsp;'+
            '<a href="/explore?x1='+longitude +'&y1='+latitude +'&miles=4.0&coorsrch=Search">4</a> &nbsp;'+
            '<a href="/explore?x1='+longitude +'&y1='+latitude + '&zip='+zip +'&miles=1.0' + '&city='+city +'"> Custom</a> miles</td>'+
            '<td width="10%">' + MapUrl1(Street +' '+City + ' ' + State +' '+ Zip, Longitude, Latitude)+'</td>'+
            '<td width="2%">'+ Stars+'</td>'+
            Photo+
            '<td width="6%">' + Phone + '</td>'+
          '</tr>';
         end;
    end;
    TotalTime := (TotalTime * 1000000) div Nanofrequency;
    Result := Result + '</table>';
    if Test then
      Result := Result + '<p><b> Processed: ' + inttostr(Processed) + ' Found:' + inttostr(NumFound) +' Time = ' + inttoStr(TotalTime)+ ' Microseconds </b><p>';
end;


procedure TExploreObject.HandleCommand(
      UnparsedParams : String;
      Var ResponseInfo: String; Var ContentType : String);
Var  S : String;
  P, H,  ZIp, limit, SearchOption, CityID : integer;
  X1, Y1, X2, Y2, Miles, Dist, cx, cy : double;
  DX, DY, D : double;
  V, VarName : String;
  T : int64;
  test : boolean;
  ct, TT, Hotels, CityRec : String;
  SelPoint, CityName, CN : String;
  Exp : TExpression;
begin
   try
       Exp.NumExp := 0;
       S := UnparsedParams;
       p := 1;
       Zip := 0;
       CityName := '';
       x1 := -80.193573;
       y1 := 25.773941;
       limit := 1000;
       Miles := 2;
       SearchOption := 10;
       test := false;
       while p < length(S) do
         begin
           ParseDoubleVar(S, VarName, D, V, p);
           if VarName = 'x1' then
             X1 := D
           else if VarName = 'y1' then
             y1 := D
           else if VarName = 'zip' then
             Zip := ValStr(V)
           else if VarName = 'limit' then
             limit := ValStr(V)
           else if VarName = 'coorsrch' then
             SearchOption := 1
           else if VarName = 'zipsrch' then
             SearchOption := 2
           else if VarName = 'citysrch' then
             SearchOption := 3
           else if VarName = 'city' then
             CityName := V
           else if VarName = 'miles' then
             miles := D
           else if VarName = 'test' then
             test := true;
         end;
       p :=  Pos('%20', CityName);
       while P <> 0 do
         begin
           delete(CityName, P, 2);
           CityName[P] := ' ';
           p :=  Pos('%20', CityName);
         end;
       p :=  Pos('%2C', CityName);
       while P <> 0 do
         begin
           delete(CityName, P, 2);
           CityName[P] := ' ';
           p :=  Pos('%2C', CityName);
         end;
       p :=  Pos('+', CityName);
       while P <> 0 do
         begin
           CityName[P] := ' ';
           p :=  Pos('+', CityName);
         end;
       StartTime(T);
       if SearchOption < 10 then
         begin
           if SearchOption = 2 then
             if (Zip > MinZip) and (Zip < MaxZip) then
                 begin
                   if ZipObject.ZipCodes[Zip].X1 = 0 then
                      begin
                        responseInfo := HtmlHead + '<b> Zip code not found </b>' + HtmlTail;
                        exit;
                      end;
                   X1 := (ZipObject.ZipCodes[Zip].X1 + ZipObject.ZipCodes[Zip].X2) / 2;
                   Y1 := (ZipObject.ZipCodes[Zip].Y1 + ZipObject.ZipCodes[Zip].Y2) / 2;
                 end
             else
                begin
                  responseInfo := HtmlHead + '<b> Zip code not found </b>' + HtmlTail;
                  exit;
                end;
           if SearchOption = 3 then
             begin
               P := 1;
               responseInfo := '';
               H := -1;
               CityID := -1;
               while P > 0 do
                 begin
                   CityID := CityObject.FindCity(CityName, H, P, CN);
                   if CityID < 0 then
                      begin
                        responseInfo := HtmlHead + '<b> City not found </b>' + HtmlTail;
                        exit;
                      end
                   else
                     begin
                       CityRec := CityObject.GetCityRec(CityID);
                       responseInfo := responseInfo + '<p><b>'+
                       '<a href="/explore?x1='+format('%.6f', [CityObject.Cities[CityID].X])+
                       format('&y1=%.6f', [CityObject.Cities[CityID].Y])+format('&miles=%.2f', [miles]) +
                       format('&limit=%d', [limit]) + '&coorsrch=Search">'+  CityObject.GetCityName(CityRec)+'</b><p></a>';
                     end;
                 end;
               if responseInfo <> '' then
                 begin
                   responseInfo := HTMLHead + responseInfo + HTMLTail;
                   exit;
                 end;
               if CityID < 0 then
                  begin
                    responseInfo := HtmlHead + '<b> City not found </b>' + HtmlTail;
                    exit;
                  end;
               X1 := CityObject.Cities[CityID].X;
               Y1 := CityObject.Cities[CityID].Y;
               CityRec := CityObject.GetCityRec(CityID);
               Dist := 0;
             end
           else
             CityObject.FindCity(X1, Y1, CityRec, Dist);
           cx := x1;
           cy := y1;
           DX := MileX(Y1) * Miles;
           DY := MileY * Miles;
           X1 := cx - DX;
           X2 := cx + DX;
           Y1 := cy - DY;
           Y2 := cy + DY;
           HotelObject.FindStrips(Exp, X1, Y1, X2, Y2, limit, Hotels, ct);
           TT := HtmlTime(T);
           SelPoint := format('<p><b><a href="/explore?x1=%.6f&y1=%.6f&miles=%.2f&limit=%d&zip=%d&city=%s"> Selected point: Longtitude: %.6f Latitude: %.6f </a></b>&nbsp;' + MapURL('View on map', cx, cy)+ '</p>',
           [cx,cy,miles,limit,zip, cx,cy,CityName]);
           if SearchOption = 3 then
              ResponseInfo := HTMLHead + SelPoint + '<b>'+CityObject.GetCityName(CityRec)+'</b>'+ HotelFormat(Hotels, cx, cy, miles, test) + TT + HtmlTail
           else
              ResponseInfo := HTMLHead + SelPoint + CityObject.HtmlFormat(CityRec, round(Dist)) + HotelFormat(Hotels, cx, cy, miles, test) + TT + HtmlTail;
        end // searchoption <=3
       else
         ResponseInfo := MakeHtml(Zip, Miles, CityName, x1, y1, limit);
   except on E: exception do
      begin
//         Interf.EnableLog;
         Interf.AddLog('Request: ' + UnparsedParams + ' Exception: ' + E.Message);
         AppendFile(Dir1+'Error.LOG', GetTimeText+'Request: ' + UnparsedParams + ' Exception: ' + E.Message);
         ResponseInfo := 'END. Internal Error. Please report to shaposhn@cs.fiu.edu';
      end;
   end;
end;

end.
