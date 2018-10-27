{Implements a composite query command

request? that returns all data required by N. Rishe's script.

request?TopPlaces=5&Lat=-33.45162&Long=-112.073814&  -- sic., ignore TopPlaces
precise=1&header=0&                -- general

the following parts in whatever syntax you suggest:
ziptown                                -- get location: zip+town+state[+more later?]
geography                               --  records of areas containing the point
folio d=.5 numfind=5
gnis 10 5
hotels 100 10
real 1 20
fires 100 7
raws 300 4

}

unit requestobject;
interface

uses
  SysUtils, Stree,  IdHTTPServer, Syncobjs, webobject, IdCustomHTTPServer,
  ZipObject, CityObject, StripObject;


type TRequestObject = class(TWebObject)
  public
// persistent data
    CSWork : TCriticalSection;
    destructor Free; override;
    procedure Init(Oldobject: TWebObject = nil); override;
    procedure HandleCommand(UnparsedParams : String;
                            Var ResponseInfo: String; Var ContentType : String); override;
  end;
function computebox(x1,x2,y1,y2: double) : String;

implementation
uses parser, math, IDUri, streetobject, shapeobject;

function computebox(x1,x2,y1,y2: double) : String;
Var DX , DY, dx2 : integer;
begin
   DY := round(earthdistmet(x1,y1,x1,y2));
   DX := round(earthdistmet(x1,y1,x2,y1));
   DX2 := round(earthdistmet(x1,y2,x2,y2));
   if dx2 > dx then
     dx := dx2;
   result := 'BBOX:' + TAB + coorstr(X1) + TAB + Coorstr(X2) + TAB +
             Coorstr(Y1) + TAB + Coorstr(Y2) + TAB + inttostr(DX) + TAB + inttostr(DY);
end;

procedure TRequestObject.Init;
begin
   CSWork := TCriticalSection.Create;
end;

destructor TRequestObject.Free;
begin
   CSWork.Free;
end;

procedure AddCensus(Var Res : String; S : String; Obj : TWebObject; xc, yc : double; Var tract : string);
Var ct, R : String;
    x1, y1, x2, y2, m : double;
    P : integer;
    bg, nbg : string;
begin
   R := Obj.ProcessQuery(s, true, ct, true);
{   if pos('I0816000', R) <> 0 then
      R := R;}
   if R <> '' then
     begin
       if Obj.command = 'tract' then
         begin
           extractfieldbynum(R, 2, tract);
           while (length(Tract) > 0) and (not (tract[1] in ['0'..'9'])) do
             delete(tract, 1, 1);
           while (length(Tract) > 0) and (not (tract[length(tract)] in ['0'..'9'])) do
             delete(tract, length(tract), 1);
         end;
       if Obj.command = 'bg' then
         begin
            extractfieldbynum(R, 2, bg);
            P := pos(bg, R);
            delete(R, P, length(bg));
            while (length(bg) > 0) and (not (bg[1] in ['0'..'9'])) do
              delete(bg, 1, 1);
            while (length(bg) > 0) and (not (bg[length(bg)] in ['0'..'9'])) do
              delete(bg, length(bg), 1);
            nbg := 'Block Group ' + tract + '.' + bg;
            insert(nbg, R, P);
         end;
         Res := Res + R;
     end;
{   if (obj.command = 'incorp') or (obj.command = 'metro') then
      begin
        if obj.command = 'incorp' then
          m := 30
        else
          m := 100;
        x1 := xc - MileX(Yc)*300;
        x2 := xc + MileX(Yc)*300;
        y1 := yc - MileY*300;
        y2 := yc + MileY*300;
        S := 'x1='+coorstr(x1) + '&y1='+coorstr(y1) + '&x2='+coorstr(x2) + '&y2='+coorstr(y2) + '&precise=1&stat=1&dir=1&census=1';
        R := Obj.ProcessQuery(s, true, ct, true);
        replaceallwords(R, 'incorp', 'incor');
        replaceallwords(R, 'metro', 'metr');
        if R <> '' then
          Res := Res + R;
      end}
end;

procedure AddShape(Var Res : String; S : String; Obj : TWebObject);
Var ct, R : String;
    x1, y1, x2, y2, m : double;
    P : integer;
    bg, nbg : string;
begin
   R := Obj.ProcessQuery(s, true, ct, true);
   if R <> '' then
     Res := Res + R;
end;


procedure TRequestObject.HandleCommand(
      UnparsedParams : String;
      Var ResponseInfo: String; Var ContentType : String);
Var  S, ct : String;
  P, i, z, Approx, limit, Scode, C : integer;
  V, VarName, Inf, error, tract : String;
  T, TT : int64;
  Dist, D, x1, y1, x2, y2 : double;
  CountryCodeForCity, CountryCode, CityCode, CountryName, CountryRec, LocateIndicator, TimeS,
  Lat, Lon, folio, S1, streetcoor, CType, Res, zip, street, city, state, StateName, StateCode, CityName, StateRec : String;
  debug : tdebug;
  statefound, bbox, center, profile, precise : boolean;
  StreetTable, ZipStr1 : String;
  Zr : TShapeResult;
  firstonly, rrequest : boolean;
begin
   try
      CSWork.Enter;
   try
       T := nanotime;
       S := TIdURI.URLDecode(UnparsedParams);
       p := 1;
       Res := '';
       rrequest := false;
       y1 := 1e80;
       x1 := 1e80;
       profile := false;
       bbox := false;
       firstonly := false;
       folio := '';
       while p < length(S) do
         begin
           ParseDoubleVar(S, VarName, D, V, p);
           if (VarName = 'Lat') and (V <> '') then
             Y1 := D
           else if (VarName = 'Long') and (V <> '') then
             X1 := D
           else if (VarName = 'y1') and (V <> '') then
             Y1 := D
           else if (VarName = 'x1') and (V <> '') then
             X1 := D
           else if VarName = 'zip' then
             Zip := V
           else if VarName = 'street' then
             street := UpStr(V)
           else if VarName = 'folio' then
             folio := UpStr(V)
           else if VarName = 'city' then
             city := V
           else if VarName = 'bbox' then
             bbox := V = '1'
           else if VarName = 'center' then
             center := V = '1'
           else if VarName = 'state' then
             state := V
           else if VarName = 'profile' then
             profile := V = '1'
           else if VarName = 'rrequest' then
             rrequest := V = '1'
           else if VarName = 'firstonly' then
             firstonly := V = '1';
         end;
       ContentType := 'text/plain';
       if not rrequest then
          begin
             Approx := A_Exact;
             if (x1 > 1e70) or (y1 > 1e70) then
                begin
                  Approx := A_NotFound;
                  x1 := -81;
                  y1 := 26;
                  if folio <> '' then
                     begin
                       S := TStripObject(Interf.Webobjects[FolioObj]).FindByKey(folio);
                       if S = '' then
                         begin
                             while pos('-', folio) <> 0 do
                                delete(folio, pos('-', folio), 1);
                             S := TStripObject(Interf.Webobjects[FolioObj]).FindByKey(folio);
                         end;
                       if S = '' then
                         begin
                             delete(folio, length(folio) - 3, 4);
                             folio := folio + '0001';
                             S := TStripObject(Interf.Webobjects[FolioObj]).FindByKey(folio);
                         end;
                       if S <> '' then
                           begin
                              ExtractFieldByNum(S, TStripObject(Interf.Webobjects[FolioObj]).SkipLat+1, Lat);
                              ExtractFieldByNum(S, TStripObject(Interf.Webobjects[FolioObj]).SkipLon+1, Lon);
                              x1 := ReadDouble(Lon);
                              y1 := ReadDouble(Lat);
                              Approx := A_Exact;
                           end
                        else
                              Approx := A_NotFound;
                     end;
                  if Approx = A_NotFound then
                     begin
                        Approx := 0;
                        debug.debug := false;
                        streetcoor := rstreetobject.ProcessQuery(unparsedparams, false, CType, false);
                        x1 := extractnumber('X=', streetcoor);
                        y1 := extractnumber('Y=', streetcoor);
                        Approx := round(extractnumber('Level=', streetcoor));
                     end;
                end;
             if Approx = A_Approx then
                LocateIndicator := 'Approximate Street Match'
             else if Approx = A_ZipCenter then
                LocateIndicator := 'Zip Code Center'
             else if Approx = A_CityCenter then
                LocateIndicator := 'City Center'
                     else
                LocateIndicator := '';
             if Approx = A_NotFound then
                begin
                   ResponseInfo := 'Error:stree:request: invalid address=' + Street;
                   exit;
                end;
             S1 := 'printdist=1&x1='+coorstr(x1) + '&y1='+coorstr(y1) + '&precise=1';
             S := S1 + '&stat=1&census=1&dir=1';
             if bbox then
                s := s + '&bbox=1';
             if center then
                s := s + '&center=1';
             if (x1 < -180) or (x1 > 180) or (y1 < -90) or (y1 > 90) then
               begin
                 ResponseInfo := 'Error:stree:request: invalid coordinates lat=' + CoorStr(y1) +' long=' + Coorstr(x1);
                  exit;
               end;
             CountryRec := TShapeObject(icountryobject).FindNearest(x1, y1, Dist);
             if Dist > 100 then
                begin
                  CountryCode := 'Ocean';
                  CountryName := 'Ocean';
                  CityCode := '';
                  StateName := '';
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
                  ExtractFieldByNum(City, 4, CountryCodeForCity);
                end
             else
                begin
                  CityCode := '';
                  CityName := '';
                end;

             if CountryCOde = 'US' then    // JAB conditional added to handle country codes. When STREE finds objects in streets, it will return them and It will merge them with whatever country... (wrong)
                begin
                        StreetTable := rstreetobject.ProcessQuery(s, true, ct, true);
                        if pos('No streets found', StreetTable) = 1 then
                        StreetTable := '';
                        ExtractFieldByNum(StreetTable, 8, ZipStr1);
                        Z := ValStr(ZipStr1);
                end
             else
                begin
                        Z := 0;
                end;

             if Z = 0 then
                Z := IZipObject.FindZIp(y1, x1, false);
             if Z <> 0 then
                CountryCOde := 'US';
             if CountryCOde = 'US' then
               begin
                   if Z = 0 then
                      Z := IZipObject.FindZIp(y1, x1);
                   if EarthDistMil(x1,y1, IzipObject.ZipCodes[Z].cx, IzipObject.ZipCodes[Z].cy) > 100 then
                      begin
                        StateRec := TShapeObject(istateObject).FindNearest(x1, y1, Dist);
                        ExtractFieldByNum(StateRec, 2, StateName);
                        ExtractFieldByNum(StateRec, 1, StateCode);
                        Val(StateCode, Scode, C);
                        Inf := TAB + CityName + TAB + STATECodes[SCode] + TAB + STATENAME + TAB + CountryCode + TAB + CityCode;
                      end
                   else
                      begin
                         Inf := IzipObject.ZipCodes[Z].Info;
                         for i := 1 to length(Inf) do
                           if Inf[i] = ',' then
                             Inf[i] := TAB;
                      end;
               end
             else
               begin
                  StateCode := '';
                  StateName := '';
                  Inf := TAB + CityName + TAB + TAB + TAB + CountryCode + TAB + CityCode;
               end;
             inf := Inf + TAB + CityCode + TAB + CountryCodeForCity + TAB + coorstr(y1) + TAB + coorstr(x1) + TAB + LocateIndicator + TAB + 'locator';
             TimeS := '';
          end // rrequest
       else
         begin
             S1 := 'printdist=1&x1='+coorstr(x1) + '&y1='+coorstr(y1) + '&precise=1';
             S := S1 + '&stat=1&census=1&dir=1';
             if bbox then
                s := s + '&bbox=1';
             if center then
                s := s + '&center=1';
             if (x1 < -180) or (x1 > 180) or (y1 < -90) or (y1 > 90) then
               begin
                 ResponseInfo := 'Error:stree:request: invalid coordinates lat=' + CoorStr(y1) +' long=' + Coorstr(x1);
                  exit;
               end;
         end;
       if not firstonly then
        for i := length(Interf.WebObjects) - 1 downto 0 do
         begin
             if profile then
               tt := nanotime;
             with Interf.webobjects[i] do
               if (Interf.webobjects[i] is TStripObject) and (TStripObject(Interf.webobjects[i]).RequestParameters <> '') then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + TStripObject(Interf.webobjects[i]).RequestParameters, true, ct, true)
               else if pos('rrequest', command) = 1 then
                  Res := Res + Interf.webobjects[i].ProcessQuery('rrequest=1&'+s, true, ct, true)
               else if command = 'state' then
                  AddCensus(Res, S, Interf.webobjects[i], x1, y1, tract)
               else if command = 'parks' then
                  AddShape(Res, S1 + '&appendcommand=1', Interf.webobjects[i])
               else if command = 'county' then
                  AddCensus(Res, S, Interf.webobjects[i], x1, y1, tract)
               else if command = 'incorp' then
                  AddCensus(Res, S, Interf.webobjects[i], x1, y1, tract)
               else if command = 'tract' then
                  begin
                    if Z <> 0 then
                      begin
                        if length(IzipObject.ZipCodes[Z].Info2) > 0 then
                        begin
                          if bbox then
                          Res := Res + IzipObject.ZipCodes[Z].Info2 + TAB + 'zip' + TAB + AddDir(x1,y1,IzipObject.ZipCodes[Z].cx, IzipObject.ZipCodes[Z].cy) + TAB +
                                   computebox(IzipObject.ZipCodes[Z].X1, IzipObject.ZipCodes[Z].X2,
                                   IzipObject.ZipCodes[Z].Y1, IzipObject.ZipCodes[Z].Y2) + TAB + CoorStr(IzipObject.ZipCodes[Z].cy) + TAB + CoorStr(IzipObject.ZipCodes[Z].cx)
                          else
                            Res := Res + IzipObject.ZipCodes[Z].Info2 + TAB + 'zip' + TAB + {CoorStr(IzipObject.ZipCodes[Z].cy) + TAB + CoorStr(IzipObject.ZipCodes[Z].cx)
                              + TAB +} AddDir(x1,y1,IzipObject.ZipCodes[Z].cx, IzipObject.ZipCodes[Z].cy);
//                            if center then
//                               Res := Res + ;
                            Res := Res + TAB+'census' +#10;
                         end;
                       end;
                    AddCensus(Res, S, Interf.webobjects[i], x1, y1, tract);
                  end
               else if command = 'metro' then
                  AddCensus(Res, S, Interf.webobjects[i], x1, y1, tract)
               else if command = 'subcounty' then
                  AddCensus(Res, S, Interf.webobjects[i], x1, y1, tract)
               else if command = 'congress' then
                  AddCensus(Res, S, Interf.webobjects[i], x1, y1, tract)
               else if command = 'bg' then
                  AddCensus(Res, S, Interf.webobjects[i], x1, y1, tract)
               else if command = 'folio' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=0.5&numfind=5&printdist=1', true, ct, true)
               else if command = 'obfs' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=1000&numfind=10&printdist=1', true, ct, true)
               else if command = 'rtstream' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=50&numfind=5&printdist=1', true, ct, true)
               else if command = 'gnis' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=10&numfind=5&printdist=1', true, ct, true)
               else if command = 'flpark' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=100&numfind=5&printdist=1', true, ct, true)
               else if command = 'floodzon' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=100&numfind=5&printdist=1', true, ct, true)
               else if command = 'hotels' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=100&numfind=10&printdist=1', true, ct, true)
               else if command = 'dos' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=100&numfind=10&printdist=1', true, ct, true)
               else if command = 'town' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=50&numfind=5&printdist=1', true, ct, true)
               else if command = 'anno_dos' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=100&numfind=10&printdist=1', true, ct, true)
               else if command = 'wtown3' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=100&numfind=20&printdist=1', true, ct, true)
               else if command = 'ikonos' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=50&numfind=10&printdist=1', true, ct, true)
               else if command = 'anno_dhs' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=100&numfind=10&printdist=1', true, ct, true)
               else if command = 'anno_gen' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=100&numfind=10&printdist=1', true, ct, true)
               else if command = 'real' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=1&numfind=20&printdist=1&prices=0', true, ct, true)
               else if command = 'ramb' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=1&numfind=20&printdist=1&prices=0', true, ct, true)
               else if command = 'wcity' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&all=1&numfind=10&d=500&printdist=1', true, ct, true)
               else if command = 'fires' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=100&numfind=7&printdist=1', true, ct, true)
               else if command = 'raws' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=300&numfind=4&printdist=1', true, ct, true)
               else if command = 'prism' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s1, true, ct, true)
               else if command = 'ecoregions' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s1, true, ct, true)
               else if command = 'iypages' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s1 ,true, ct, true)
               else if command = 'whitepages' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s1, true, ct,true)
               else if command = 'gnsw' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s1 ,true, ct, true)
               else if command = 'geoeye' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s1 ,true, ct, true)
               else if command = 'wikix' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s1 ,true, ct, true)
               else if command = 'physicians' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s1 ,true, ct, true)
               else if command = 'ypages' then
                 begin
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=1&numfind=20&printdist=1', true, ct, true);
//                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=1&numfind=10&printdist=1&type=Food%20and%20Dining', true, ct, true, 'dining')
                 end
               else if command = 'street' then
                  Res := Res + StreetTable
               else if command = 'dining' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=1&numfind=10&printdist=1', true, ct, true)
               else if command = 'school' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=3&numfind=5&printdist=1', true, ct, true)
               else if command = 'college' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=20&numfind=5&printdist=1', true, ct, true)
               else if command = 'blocks' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=0.5&numfind=5&printdist=1', true, ct, true)
               else if command = 'restaurant' then
                  Res := Res + Interf.webobjects[i].ProcessQuery(s + '&d=5&numfind=20&printdist=1', true, ct, true);
             if profile then
               TimeS := TimeS + Interf.webobjects[i].command + ' ' + format(' %10.7f seconds', [(Nanotime-TT)/Nanofrequency]) + #10;
           end;
       if rrequest then
         ResponseInfo := Res
       else
         begin
          if firstonly then
             ResponseInfo := Zipstr(Z)+ Inf
          else
             ResponseInfo := Zipstr(Z)+ Inf + #10 + Res;
          if profile then
             ResponseInfo := ResponseInfo + #10 + TextTime(T, false) + #10 + TimeS;
         end;
   except on E: exception do
      begin
//         Interf.EnableLog;
         Interf.AddLog('Request: ' + UnparsedParams + ' Exception: ' + E.Message);
         AppendFile(GetHardRootDir1+'Error.LOG', 'Request: ' + UnparsedParams + ' Exception: ' + E.Message);
         Responseinfo := 'END. Internal Error. Please report to shaposhn@cs.fiu.edu';
      end;
   end;
   finally
     CSWork.Leave;
   end;
end;

end.
