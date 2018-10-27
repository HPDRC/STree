unit RealReport;

interface
uses webobject, streetobject;
type TRealRep = class(TWebObject)
  public
    Report, TableLineTemplate : STring;
    TableLinePos : integer;
    DetailReport, DetailTableLineTemplate : STring;
    DetailTableLinePos : integer;
    destructor Free; override;
    procedure Init(Oldobject: TWebObject = nil); override;
    procedure  HandleCommand(UnparsedParams : String;
                            Var ResponseInfo: String; Var ContentType : String); override;
    procedure Refresh;
end;

implementation
uses parser, StripObject, sysutils, IdURI;

destructor TRealRep.Free;
begin
end;

function ExtractTemplate(VaR Report : String; Tag1, Tag2 : String; VaR Position : integer) : String;
VaR p1, p2 : integer;
begin
   p1 := pos(Tag1, Report);
   p2 := pos(Tag2, Report);
   result := copy(Report, p1, p2 - p1 + length(Tag2));
   Position := p1;
   delete(Report, p1, length(result));
end;

procedure ReplaceTag(VaR Report: String; Tag : String; Replace : String);
VaR P : integer;
begin
   p := pos(Tag, Report);
   if P <> 0 then
      begin
        delete(Report, P, length(Tag));
        insert(Replace, Report, P);
      end;
end;

procedure TRealRep.Refresh;
begin
   ReadStringFile(Dir1 + 'reporttemplate.htm', Report);
   TableLineTemplate := ExtractTemplate(Report, '<LineBegin>', '<LineEnd>', TableLinePos);
   ReadStringFile(Dir1 + 'detail.htm', DetailReport);
   DetailTableLineTemplate := ExtractTemplate(DetailReport, '<LineBegin>', '<LineEnd>', DetailTableLinePos);
end;

procedure TRealRep.Init(Oldobject: TWebObject);
begin
   Refresh;
end;

type TLine = record
   Value : String;
   SortVal : double;
end;

procedure TRealRep.HandleCommand(
      UnparsedParams : String;
      Var ResponseInfo: String; Var ContentType : String);

Var
  X1, Y1, X2, Y2, Miles, Dist, cx, cy : double;
  fmls, fx1, fy1, fPrice,fdate,fbeds,fbath,ffolio,farea,faddress,funit,fyear,fphone,finfo,fphoto : integer;
  Lines : array of TLine;
  Dataset : TStripObject;
  detailmls, Sortby, Ctype, error, city, State, Zip, Query, Res, V, VarName, S, numfind, address, pricefrom, priceto, DateAfter : String;
  limit, p : integer;
  D : double;
  Approx : integer;
  debug : tdebug;
  fdist : integer;
  fcompass : integer;
  foffset : integer;

procedure SortLines;
  procedure QuickSort(L, R: Integer);
  var
    I, J: Integer;
    X, T: TLine;
  begin
      I := L;
      J := R;
      X := Lines[(L + R) div 2];
      repeat
        while Lines[I].SortVal < X.SortVal do
          Inc(I);
        while Lines[J].SortVal > X.SortVal do
          Dec(J);
        if I <= J then
        begin
          T := Lines[I];
          Lines[I] := Lines[J];
          Lines[J] := T;
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then
        QuickSort(L, J);
      if I < R then
        QuickSort(I, R);
  end;
begin
   if Length(Lines) > 1 then
     QuickSort(0, length(Lines) - 1);
end;

function GetPriceChange(Line : String) : integer;
Var p : integer;
    p0, p1 : double;
begin
    GetField1(fdate, 0, Line, p);
    GetNextField(Line, P);
    p0 := ReadDouble(GetNextField(Line, P));
    if (Line[p-1] = '}') or (p0 = 0) then
      begin
        result := 0;
        exit;
      end;
    GetNextField(Line, P);
    p1 := ReadDouble(GetNextField(Line, P));
    result := round(1000*(p0-p1)/p0);
end;

function ValPrice(V : String) : integer;
Var D : double;
    c : integer;
begin
   D := 0;
   Val(V, D, C);
   result := round(D);
end;

function PriceStr(P : integer) : string;
Var D : double;
begin
   d := p;
   result := format('%.0m', [d]);
end;

function formatdetail(Res : string) : string;
Var Table, S1, Field : String;
    i : integer;
begin
   if pos('===', Res) <= 3 then
      begin
        result := 'The listing is not active';
        exit;
      end;
   for i := 0 to length(TStripObject(dataset).fields) - 1 do
    with TStripObject(dataset).fields[i] do
     begin
         Field := GetField(SrcNum, Res, Repnum);
         if Field <> '' then
            begin
               S := DetailTableLineTemplate;
               ReplaceTag(S, '$Name', name);
               ReplaceTag(S, '$Value', Field);
               Table := Table + S;
            end;
     end;
   Result := DetailReport;
   insert(Table, Result, DetailTableLinePos);
end;

function ValPhone(S : String) : double;
Var D : double;
    i : integer;
begin
   D := 1;
   Result := 0;
   for i := length(S) downto 1 do
     if S[i] in ['0'..'9'] then
       begin
         Result := Result + (ord(S[i]) - Ord('0')) * D;
         D := D * 10;
       end;
end;

procedure deletesymbols(symbol : char; Var S : String);
Var i, p : integer;
begin
   repeat
     p := pos(symbol, S);
     if p <> 0 then
        delete(S, p, 1);
   until p = 0;
end;

procedure HTMLFormat(Res : String);
Var iPrice, Area, DollarPerSqFt, p, p1 : integer;
    i, NumLines : integer;
    sArea, Folio, smls, Info, Price, Photo, Phone, Hist, sdate, sprice, S, Line : String;
    X, TableLines : String;
begin
   p := 1;
   Line := GetNextLine(res, p);
   NumLines := 0;
   while Line <> '' do
      begin
         S := TableLineTemplate;
//         ReplaceTag(S, '$Date', GetField(fdate,  Line, 1));
         ReplaceTag(S, '$Beds', GetField(fbeds,  Line));
         ReplaceTag(S, '$Baths', GetField(fbath, Line));
         Folio := GetField(ffolio, Line);
         deletesymbols('-', Folio);
         ReplaceTag(S, '$Folio', Folio);
         sArea := GetField(farea,  Line);
         ReplaceTag(S, '$Area', sArea);
         ReplaceTag(S, '$Address', GetField(faddress,  Line));
         ReplaceTag(S, '$Unit', GetField(funit,  Line));
         ReplaceTag(S, '$Year', GetField(fyear,  Line));
         sPrice := GetField(fprice,  Line);
         Area := round(ReadDouble(sArea));
         iPrice := round(Readdouble(sPrice));
         if Area <> 0 then
           begin
             DollarPerSqFt := round(iPrice/Area);
             ReplaceTag(S, '$DollarPerSqft', PriceStr(DollarPerSqFt));
           end
         else
           begin
             DollarPerSqFt := 1000000;
             ReplaceTag(S, '$DollarPerSqft', '');
           end;
         SMLS := GetField(fmls,  Line);
         smls := '<a href="report?detail=' + smls + '&dataset=' + dataset.command + '">' + smls + '</a>';
{         if smls = 'M913464' then
           smls := 'M913464';
         if smls = 'M873187' then
           smls := 'M873187';}
         ReplaceTag(S, '$mls', smls);
         Info := GetField(finfo, Line);
         if pos('@', info) <> 0 then
            Info := 'mailto:' + info
         else if (info <> '') and (pos('http', info) = 0) then
            info := 'http://' + info;
//         ReplaceTag(S, '$Info', Info);
         Phone := GetField(fphone, Line);
         if (Phone = '') and (Info <> '') then
            Phone := '<a href="' + Info + '">' + 'Click for Info' + '</a>'
         else if (Phone <> '') and (Info <> '') then
            Phone := '<a href="' + Info + '">' + Phone + '</a>';
         ReplaceTag(S, '$Phone', Phone);
         ReplaceTag(S, '$x1', GetField(fx1, Line));
         ReplaceTag(S, '$y1', GetField(fy1, Line));
         sdate := GetField1(fdate, 1, Line, p1);
         inc(p1);
         Hist := '';
         repeat
            if Hist <> '' then
               Hist := Hist + ', ';
            if sdate = '' then
              sdate := GetNextField(Line, p1);;
            sprice := GetNextField(Line, p1);
            sprice := PriceStr(ValPrice(sprice));
            Hist := Hist + sprice + ' on ' + sdate;
            sdate := '';
         until (p1 >= length(Line)) or (Line[p1-1] = '}');
//         ReplaceTag(S, '$Hist', Hist);
         Photo := GetField(fphoto, Line);
         if Photo <> '' then
            Hist := '<a href="' + Photo + '">' + Hist + '</a>';
         ReplaceTag(S, '$Price', Hist);
         X := GetField(fdist, Line);
         X := X + 'm to ' + GetField(fcompass, Line);
         X := X + ' at ' + GetField(foffset, Line) +'º';
         ReplaceTag(S, '$Distance', X);
         inc(NumLines);
         Setlength(Lines, NumLines);
         Lines[NumLines-1].Value := S;
         if sortby = 'pricechange' then
           Lines[NumLines-1].SortVal := GetPriceChange(Line)
         else if sortby = 'proximity' then
           Lines[NumLines-1].SortVal := 0
         else if sortby = 'area' then
           Lines[NumLines-1].SortVal := -ReadDouble(GetField(farea,  Line))
         else if sortby = 'beds' then
           Lines[NumLines-1].SortVal := -ReadDouble(GetField(fbeds, Line))
         else if sortby = 'date' then
           Lines[NumLines-1].SortVal := -ValDate(GetField(fdate, Line, 1))
         else if sortby = 'price' then
           Lines[NumLines-1].SortVal := ReadDouble(GetField(fprice, Line))
         else if sortby = 'phone' then
           Lines[NumLines-1].SortVal := ValPhone(GetField(fphone, Line))
         else if sortby = 'dollarpersqft' then
           Lines[NumLines-1].SortVal := DollarPerSqFt;
         Line := GetNextLine(res, p);
         if Line = '===' then
            break;
      end;
   if (sortby <> '') and (sortby <> 'proximity') then
     SortLines;
   ResponseInfo := Report;
   for i := 0 to NumLines - 1 do
     TableLines := TableLines + Lines[i].Value;
   insert(TableLines, ResponseInfo, TableLinePos);
   ReplaceTag(ResponseInfo, '$SearchAddress', address);
   ReplaceTag(ResponseInfo, '$PriceFrom', pricefrom);
   ReplaceTag(ResponseInfo, '$PriceTo', priceto);
   ReplaceTag(ResponseInfo, '$UpdatedAfter', DateAfter);
   ReplaceTag(ResponseInfo, '$Numfind', numfind);
   ReplaceTag(ResponseInfo, '<' + Dataset.command + '>', ' checked tabindex="1">');
   ReplaceTag(ResponseInfo, '<' + sortby + '>', ' checked tabindex="1">');
   TableLines := '';
end;

begin
   try
       City := '';
       State := '';
       S := TIdURI.URLDecode(UnparsedParams);
       p := 1;
       x1 := -80.193573;
       y1 := 25.773941;
       limit := 1000;
       pricefrom := '0';
       priceto := '10000000000';
       dataset := nil;
       numfind := '';
       dateafter := '';
       detailmls := '';
       while p < length(S) do
         begin
           ParseDoubleVar(S, VarName, D, V, p);
           if VarName = 'x1' then
             X1 := D
           else if VarName = 'y1' then
             y1 := D
           else if VarName = 'zip' then
             Zip := V
           else if VarName = 'city' then
             city := V
           else if VarName = 'state' then
             state := V
           else if VarName = 'address' then
             address := V
           else if VarName = 'pricefrom' then
             pricefrom := V
           else if VarName = 'priceto' then
             priceto := V
           else if VarName = 'refresh' then
             refresh
           else if VarName = 'detail' then
             detailmls := V
           else if VarName = 'updateafter' then
             DateAfter := V
           else if (VarName = 'sortby') then
             sortby := V
           else if (VarName = 'dataset') then
             dataset := TStripObject(Interf.FindObject(V))
           else if VarName = 'numresults' then
             numfind := V;
         end;
       if dataset = nil then
         begin
           ResponseInfo := Report;
           ReplaceTag(ResponseInfo, '$SearchAddress', '');
           ReplaceTag(ResponseInfo, '$PriceFrom', '');
           ReplaceTag(ResponseInfo, '$PriceTo', '');
           ReplaceTag(ResponseInfo, '$UpdatedAfter', '');
           ReplaceTag(ResponseInfo, '$Numfind', '');
           ReplaceTag(ResponseInfo, '<real>', ' checked tabindex="1">');
           ReplaceTag(ResponseInfo, '<proximity>', ' checked tabindex="1">');
           exit;
         end;
       if detailmls <> '' then
         begin
           Query := 'key=' + detailmls + 'FL';
           Res := dataset.ProcessQuery(Query, false, CType, false);
           ResponseInfo := FormatDetail(res);
           exit;
         end;
       Query := TIdURI.URLDecode(UnparsedParams);
       if address <> '' then
          begin
            istreetobject.FindHouseByZip(address, zip, city, state, X1, Y1, Approx, debug, error, false);
            Query := Query + '&x1='+coorstr(x1) + '&y1='+coorstr(y1);
            if Approx >= 3 then
              begin
                 Responseinfo := 'The address ' + address + ' was not found';
                 exit;
              end;
          end;
       if numfind = '' then
         numfind := '100';
       if dateafter <> '' then
          Query := Query + '&the_date>=' + dateafter;
       Query := Query+'&numfind='+numfind + '&printdist=1';
       if Pricefrom <> '' then
         if dataset.command = 'real' then
           Query := Query + '&price>='+pricefrom + '&price<=' +priceto
         else
           Query := Query + '&list_price>='+pricefrom + '&list_price<=' +priceto;
       CType := '';
       Res := dataset.ProcessQuery(Query, false, CType, false);
       if DataSet.Command = 'real' then
          begin
             fPrice := 2;//dataset.FindField('price');
             fdate := 37;//dataset.FindField('histdate');
             fbeds := 4;//dataset.FindField('bedroom');
             fbath := 5;//dataset.FindField('bathroom');
             farea := 3;//dataset.FindField('area');
             faddress := 10;//dataset.FindField('street_address');
             funit := 11;//dataset.FindField('unit');
             fyear := DataSet.Fields[dataset.FindField('year_built')].SrcNum;
             fphone := 19;//dataset.FindField('contact');
             finfo := 22;// dataset.FindField('info');
             fphoto := 6;//dataset.FindField('photo');
             fdist := 38;
             fcompass := 39;
             foffset := 40;
             fy1:= 24;
             fx1:= 25;
             fmls := 17;
          end
       else
          begin
             fPrice := DataSet.Fields[dataset.FindField('list_price')].SrcNum;
             if dataset.command = 're1' then
               fdate := DataSet.Fields[dataset.FindField('entry_date')].SrcNum
             else
               fdate := DataSet.Fields[dataset.FindField('histdate')].SrcNum;
             fbeds := DataSet.Fields[dataset.FindField('nbeds')].SrcNum;
             fbath := DataSet.Fields[dataset.FindField('nfbaths')].SrcNum;
             ffolio := DataSet.Fields[dataset.FindField('folio_number')].SrcNum;
             fyear := DataSet.Fields[dataset.FindField('year_built')].SrcNum;
{             if dataset.command = 're1' then
               farea := DataSet.Fields[dataset.FindField('approx._sqft_total_area')].SrcNum;
             else}
             farea := DataSet.Fields[dataset.FindField('sqft_liv_area')].SrcNum;
             faddress := DataSet.Fields[dataset.FindField('street_address')].SrcNum;
             if dataset.command = 'rnt' then
               funit := DataSet.Fields[dataset.FindField('apartment_number')].SrcNum
             else
               funit := DataSet.Fields[dataset.FindField('unit_number')].SrcNum;
             fphone := DataSet.Fields[dataset.FindField('agent_phone')].SrcNum;
             finfo := DataSet.Fields[dataset.FindField('office_url')].SrcNum;
             fphoto := DataSet.Fields[dataset.FindField('photo')].SrcNum;
             fmls := DataSet.Fields[dataset.FindField('mls')].SrcNum;
             fdist := length(DataSet.Fields);
             fcompass := fdist + 1;
             foffset := fdist + 2;
             fy1:= DataSet.Fields[dataset.FindField('latitude')].SrcNum;
             fx1:= DataSet.Fields[dataset.FindField('longitude')].SrcNum;
          end;
       HTMLFormat(Res);
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
