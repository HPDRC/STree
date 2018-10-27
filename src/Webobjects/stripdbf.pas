{
DBF file stripper.
Implements the same interface as the stripobject for data captured from DBF files

}


unit StripDBF;
interface

uses
  SysUtils, Stree,  IdHTTPServer, Syncobjs, webobject, IdCustomHTTPServer, stripobject, InovaGIS_TLB;

type TStripDBF = class(TStripObject)
  public
// persistent data
    Map: iVectorial;
    ShpName : String;
    procedure AddFile(Name : String); override;
    procedure MainThreadInit;
    { Public declarations }
  end;

implementation
uses FileIO, parser, cityobject, streetobject,
dbtables, winprocs, threadpool;


procedure TStripDBF.MainThreadInit;
begin
   Map:=coiShp.Create;
   Map.Document.Name:= ShpName;
   Map.CheckStatus:=5;
   if not Map.Open then
      ShpName := '';
end;

const _loaded : integer = 0;
procedure TStripDBF.AddFile(Name : String);
Var
    x, y, D : double;
    S, Line  : String;
    recordnum, i : integer;
    Lon, Lat: String;
    Prefix : String;
    Year, Month, Day : word;
    nf : integer;
    F : Textfile;
    RecPoints:OleVariant;
begin
try
   Map := nil;
   if TheFileExt(Upstr(Name)) <> 'DBF' then
     exit;
   Interf.SetStatus('Loading ' + DBName);
   GTable.TableName := Name;
   GTable.Active := true;
   Header := 'REPORT: ' + Name;
   Header := Header + #13+#10 + 'FIELD DEFINITIONS:' + #13+#10;
   if ParseNameDate then
      begin
        Header := Header + 'FIELD-1' + TAB + 'Name' + #13+#10;
        Header := Header + 'FIELD-2' + TAB + 'Date' + #13+#10;
      end;
   S := '';
   for i := 0 to GTable.FieldCount - 1 do
     begin
        if ParseNameDate then
          begin
            Header := Header + 'FIELD-' + inttostr(i+3) + TAB + GTable.Fields[i].FieldName + #13+#10;
            nf := i+2;
          end
        else
          begin
            Header := Header + 'FIELD-' + inttostr(i+1) + TAB + GTable.Fields[i].FieldName + #13+#10;
            nf := i;
          end;
        if S = '' then
          S := GTable.Fields[i].FieldName
        else
          S := S + TAB + GTable.Fields[i].FieldName;
     end;
   Header := Header + 'FIELD-' + inttostr(nf + 2) + TAB + 'LATITUDE' + #13+#10;
   Header := Header + 'FIELD-' + inttostr(nf + 3) + TAB + 'LONGITUDE' + #13+#10;
   S := S + TAB + 'LATITUDE' + TAB + 'LONGITUDE';
   if ParseNameDate then
     S := 'Name' + TAB + 'Date' + TAB + S;
   Header := Header + #13+#10 + '=' + #13+#10 + S + #13+#10 + '==' + #13+#10;
   AssignFile(F, Dir1 + 'Header.ttt');
   rewrite(F);
   writeln(F, Header);
   closefile(F);
   recordnum := 0;
   if not fileexists(TheFullFileName(Name)+ '.coor') then
     begin
       ShpName := TheFullFileName(Name) + '.SHP';
       MainThreadExec(MainThreadInit);
{       Map:=coiShp.Create;
       Map.Document.Name:=;
       Map.CheckStatus:=5;
       if not Map.Open then
         exit;}
       AssignFile(F, TheFullFileName(Name) + '.coor1');
       rewrite(f);
       while not GTable.EOF do
         begin
            inc(recordNum);
            GTable.Next;
            RecPoints:=Map.GetRecordPoints(recordnum);
            X := 0;
            Y := 0;
            for i:= 0 to Map.RecordPointCount[recordnum] -1 do
              begin
                X := X + RecPoints[i,0];
                Y := Y + RecPoints[i,1];
              end;
            X := X / Map.RecordPointCount[recordnum];
            X := X;
            Y := Y / Map.RecordPointCount[recordnum];
            writeln(F, CoorStr(x), ' ', CoorStr(y));
         end;
       closefile(F);
       if TranslateCoor then
         begin
           Interf.SetStatus('!!!!ERROR!!!! Use: ' + TheFullFileName(Name) + '.coor1' + ' and perform the coordinate translation first.');
           exit;
         end
       else
         begin
           MOveFile(PChar(TheFullFileName(Name) + '.coor1'), PChar(TheFullFileName(Name) + '.coor'));
           GTable.First;
         end;
     end;
   AssignFile(F, TheFullFileName(Name) + '.coor');
   reset(f);
   while not GTable.EOF do
     begin
        Line := GTable.Fields[0].AsString;
        for i := 1 to GTable.FieldCount - 1 do
          Line := Line + TAB + GTable.Fields[i].AsString;
        readln(F, x, y);
        x := x * LongMultiplier;
        inc(recordNum);
        GTable.Next;
        Lat := CoorStr(Y);
        Lon := CoorStr(X);
        Line := Line + TAB + LAT + TAB + LON;
        if ParseNameDate then
           begin
             D := parsename(TheFileName(Name), prefix, Year, Month, Day );
             Line := Prefix + TAB + FormatDateTime('yyyy/mm/dd', D) + TAB + Line;
           end;
        AddStrip(Lat, Lon, Line);
     end;
   closefile(F);
 finally
   GTable.Active := false;
   if Map <> nil then
     Map.Terminate;
   Map := nil;
 end;
end;


end.
