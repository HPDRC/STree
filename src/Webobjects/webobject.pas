{*** Parent class for all web objects. Implements common functionality and the service initialization. ***}


{

Indexes arbitrary 2D objects in 2-D space and performs web queries.

}
unit webobject;
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Stree, GPC, Menus, StdCtrls, ExtCtrls, IdBaseComponent,
  IdComponent, IdTCPServer, IdCustomHTTPServer, IdHTTPServer, Syncobjs,
  IdIOHandlerSocket,
  IdThreadMgr, IdThreadMgrPool, stringqueue, IdIOHandler,
  IdIOHandlerThrottle, IniFiles, Mask, DB, Dbf, IdTCPConnection,
  IdTCPClient, IdHTTP, RegExpr;

const HTMLHead = '<html> <head> <meta http-equiv="Content-Language" content="en-us"><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><title>Hotel Explorer Result</title> </head> <body>';
const HTMLTail = '</body> </html>';
const CityObj = 0;
const ZipObj = 1;
const CategoryObj = 2;
const HelpObj = 3;
const RequestObj = 4;
const StreetObj = 5;
const HotelObj : integer = -1;
const FolioObj : integer = -1;
const ExploreObj : integer = -1;
const defaultRemote : integer = -1;


type TWebInterf = class;

TWebObject = class
public
    Command : String;
    WebIndex : integer;
//    WebInterf : TWebInterf;
    Dir1, SavDir : String;
    Interf : TWebInterf;
    TotalObjects : integer;
    TotalVertixes : integer;
    TotalPoints : integer;
    Query : boolean;
    IniFile : String;

    destructor Free; virtual; abstract;
    constructor Create(Command: String; SaveDir : String; WebInterf : TWebInterf; QueryInclude : boolean);
    procedure Init(Oldobject: TWebObject = nil); virtual; abstract;
    procedure TestClick; virtual;
    procedure HandleCommand(UnparsedParams : String;
            Var ResponseInfo: String; Var ContentType : String); virtual; abstract;
    function  ProcessQuery(Request : String; AppendEOL : boolean; Var ContentType : String; AppendCommand : boolean = false; commstr : string = '') : String; virtual; abstract;
    procedure DumpRecords(Var c : integer); virtual;
    procedure Backup; virtual;
end;



TWebInterf = class(TForm)
    Memo1: TMemo;
    Timer1: TTimer;
    HTTPServer: TIdHTTPServer;
    IdThreadMgrPool1: TIdThreadMgrPool;
    Panel1: TPanel;
    BkpBtn: TButton;
    Logging: TCheckBox;
    Start: TButton;
    Label6: TLabel;
    Status1: TLabel;
    NObjects: TLabel;
    Label7: TLabel;
    Requests: TLabel;
    MergeKeys: TButton;
    StripObjects: TListBox;
    Rebuild: TButton;
    Timer2: TTimer;
    Dump: TButton;
    Port: TMaskEdit;
    Log2: TCheckBox;
    Playlog: TButton;
    OpenDialog1: TOpenDialog;
    VerifyBtn: TButton;
    GTable: TDbf;
    Memchk: TButton;
    Memsort: TButton;
    IdHTTP1: TIdHTTP;
    StreetIdx: TButton;
    Label1: TLabel;
    PeerName: TMaskEdit;
    StartCluster: TButton;
    StopCluster: TButton;
    PeerStatus: TLabel;
    HostName: TMaskEdit;
    Hostlab: TLabel;
    NVertixes: TLabel;
    NPoint: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure HTTPServerCommandGet(AThread: TIdPeerThread;
      ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);
    procedure LoggingClick(Sender: TObject);
    procedure SearchClick(Sender: TObject);
    procedure BkpBtnClick(Sender: TObject);
    procedure StartClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure IdIOHandlerThrottle1Status(ASender: TObject;
      const AStatus: TIdStatus; const AStatusText: String);
    procedure MergeKeysClick(Sender: TObject);
    procedure RebuildClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure DumpClick(Sender: TObject);
    procedure Log2Click(Sender: TObject);
    procedure PlaylogClick(Sender: TObject);
    procedure VerifyBtnClick(Sender: TObject);
    procedure MemchkClick(Sender: TObject);
    procedure MemsortClick(Sender: TObject);
    procedure StreetIdxClick(Sender: TObject);
    procedure StartClusterClick(Sender: TObject);
    procedure StopClusterClick(Sender: TObject);

  public
    NumHandled : int64;
    Queue : TStrQueue;
    LogEnabled : boolean;
    WebObjects : array of TWebObject;
    Strips : array[0..100] of integer;
    ObjectToRebuild : integer;
    NewCaption : STring;
    LogToFile : boolean;
    LogFile : String;
    LoadCity, LoadZip, LoadStreet : boolean;
    rooturl : string;
    Autostart : boolean;
    PeerState : String;
    Started : boolean;




    procedure TestClick(Sender: TObject);
    procedure SetStatus(Status : String);
    procedure AddLog(S : String);
//    procedure LogNow(S : String);
    procedure EnableLog1;
    procedure ReadIniFile;
    procedure WMUser (var msg: TMessage); message wm_User;
    procedure KillOtherInstance;
    function  ProcessQuery(cmd : string; UnparsedParams : String; standard : boolean) : String;
    function  LoadStrip(Var F : TMemIniFile; S : integer; raiseerrors : boolean; Var PostUrlAddress : string) : TWebObject;
    function  LoadShape(Var F : TMemIniFile; S : integer) : TWebObject;
    function  LoadRemote(Var F : TMemIniFile; S : integer) : TWebObject;
    procedure RebuildStrip(I : integer; Force : boolean);
    procedure RebuildStrip1;
    procedure Initialize;
    procedure ProcessGet(IP, Document, UnparsedParams : String; Var ResponseInfo: String; Var ContentType : String; AResponseInfo: TIdHTTPResponseInfo);
    function  FindObject( command : string) : TWebObject;
    procedure BuildStrip(ObjIndex : integer; Var Error : String);
    function CreateDataSet(DataSetName : string) : string;
    procedure  RunClusterCommand(Peer, Command : string);
    procedure UpdateClusterStatus;
    procedure BatchGeocoding(UnparsedParams : String; Var ResponseInfo: String);
    //function process_filegeo(Parameter : Pointer) :integer;
    //procedure BatchGeocoding(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo:TIdHTTPResponseInfo);
    //procedure regexp_Compile;
    //procedure regexp_pound_Compile;
    { Public declarations }
  end;


function AddDir(x1,y1,x2,y2 : double) : String;

var
  WebInterf: TWebInterf;
const UserClose : boolean = false;
const servcount : integer = 0;
const istateobject : TWebObject = nil;
const icountryobject : TWebObject = nil;
const rstreetobject : TWebObject = nil;
const rFLPropertiesObject : TWebObject = nil;
const rnfolioobject : TWebObject = nil;
const rownershipobject : TWebObject = nil;

const first_americanobject : TWebObject = nil;
const zip_americanobject : TWebObject = nil;

function GTable : TDBF;

const CSGlobal : TCriticalSection = nil;

type
  TMsgRecord = record
    fileinp : string;
    fileoutp  : string;
    confirmation : string;
  end;


implementation
uses zipobject, cityobject, StreetObject, parser, exploreobject,
Stripobject, StripReal, stripdbf,  categoryobject, helpobject, RequestObject, geodist,
threadpool, myutil1, remoteobject, realreport, Shapeobject, memorychecker, shellapi,IDUri;
{$R *.DFM}




function GTable : TDBF;
begin
   result := WebInterf.GTable;
end;

function AddDir(x1,y1,x2,y2 : double) : String;
Var Offset : double;
begin
  Result := inttostr(round(EarthDistMet(x1,y1, x2, y2))) + TAB + calculateDirAndOffset(-calcheading(x1,y1, x2, y2), Offset) + TAB + inttostr(round(Offset));;
end;

procedure Split
   (const Delimiter: Char;
    Input: string;
    Strings: TStringList) ;
var accumm : String;
i : integer;
begin
   {Assert(Assigned(Strings)) ;
   Strings.Clear;
   Strings.Delimiter := Delimiter;
   Strings.DelimitedText := Input;}
   Strings.Clear;
   accumm := '';
   for i:= 1 to Length(Input) do
   begin
        if Input[i] = Delimiter then
        begin
                Strings.add(accumm);
                accumm := '';
        end
        else
                accumm := accumm + Input[i];
   end;
   Strings.add(accumm);
end;

{ThreadVar         // We must allow each thread its own instances
                  // of the passed record variable
  msgPtr : ^TMsgRecord;
}

var CriticalSection : TRTLCriticalSection;  //Critical section protects the filelist
    fileinp : string;
    fileoutp  : string;
    confirmation : string;
    error_url : string;
 // EXAMPLE EXECUTION http://stree1.cis.fiu.edu/batchgeocoding?file_name=test.txt&callback=http:\\geoimage2.cs.fiu.edu\geocoder\test\jobdone.ashx?file=outtest.txt&file_out=outest.txt&error_url=http:\\geoimage2.cs.fiu.edu\geocoder\test\jobdone.ashx?file=test.txt#result=error
function process_filegeo(Parameter : Pointer) :integer;
Var ContentType,commstr,request,data,text,tab_s,after,filein,fileout,volume :String;
myFile : TextFile;
outfile: TextFile;
A : TStringList;
res, confirmurl, erurl : String;
kk : string;
begin
     Try  // Global Error
        EnterCriticalSection(CriticalSection);   //Try to catch the critical section
        filein := fileinp;                  //Access the shared variables
        fileout := fileoutp;
        confirmurl := confirmation;
        erurl := error_url;
        LeaveCriticalSection(CriticalSection);

        volume := 'W:\\';
        ContentType := '';
        commstr := '';
        tab_s := ' ';
        SetLength(tab_S,1);
        tab_s[1] := TAB;
        // Map the pointer to the passed data
        // Note that each thread has a separate copy of msgPtr
        //msgPtr := Parameter;



        //filein := msgPtr.fileinp;
        //fileout := msgPtr.fileoutp;

        //request := 'street=8131 sw 35 ter&city=miami&state=fl&zip=33155&matchprop=2&showcleansedaddress=1';
        /// reads input
        if FileExists(volume+filein) then
        begin         /// Critical part, this should be very fast, enough to keep feasible times. Assuming stored sequentially
                  /// so that disk scheduler retrieve the whole sector.
         AssignFile(outfile, volume+fileout);
         ReWrite(outfile);

         AssignFile(myFile, volume+filein);
         Reset(myFile);
         A := TStringList.Create;

         while not Eof(myFile) do
         begin

                ReadLn(myFile, text);

                Split(TAB, text, A) ;
                //A.Delimiter := TAB;
                //A.DelimitedText := text;
                request := 'street='+a[0]+'&city='+a[1]+'&state='+a[2]+'&zip='+a[3]+'&matchprop=2&showcleansedaddress=1';
                data := WebInterf.webobjects[streetobj].ProcessQuery(request, true, ContentType, true, commstr);
                after  := StringReplace(data, #10, '$',[rfReplaceAll, rfIgnoreCase]);
                WriteLn(outfile, after);
                //kk[100] := 'r';  Induced error for testing
         end;
         A.free;
         CloseFile(myFile);
         CloseFile(outfile);
        end;




        result := 1;
        Res := ReadUrl(confirmurl, 5000);
     except
     
     begin
        Res := ReadUrl(erurl, 5000);
        WriteLn(outfile,'GLOBAL ERROR');
        CloseFile(myFile);
        CloseFile(outfile);
     end;
     end;
     EndThread(0);
     
end;

procedure TWebObject.Backup;
begin
end;

function  TWebInterf.FindObject( command : string) : TWebObject;
Var i : integer;
begin
   for i := 0 to length(Webobjects) -1 do
     if Webobjects[i].Command = command then
        begin
           Result := Webobjects[i];
           exit;
        end;
   result := nil;
end;


constructor TWebObject.Create(Command: String; SaveDir : String; WebInterf : TWebInterf; QueryInclude : boolean);
begin
  Self.Command := Command;
  Dir1 := GetHardRootDir1 + SaveDir + '\';
  SavDir := SaveDir;
  Interf := WebInterf;
  TotalObjects := 0;
  TotalVertixes := 0;
  TotalPoints := 0;
  Query := QueryInclude;
end;

procedure TWebInterf.ReadIniFile;
var f : tmeminifile;
   Dir, Command, Section : String;
   S, I, Idx, Fi, k : integer;
   Merge, fFormat, FieldName : String;
   SourceNumber : integer;
   St, Sh, Rm : TWebObject;
   PostUrl : string;
begin
   F := TMeminiFile.create(GetHardRootdir1 + 'streeweb.ini');
   Port.Text := F.ReadString('INIT', 'PORT', '80');
   PeerName.Text := F.ReadString('INIT', 'PEER', '');
   HostName.Text := F.ReadString('INIT', 'HOST', '');
   Autostart := F.ReadString('INIT', 'Autostart', '0') = '1';
   LoadCity := F.ReadBool('INIT', 'LoadCity', true);
   LoadZip := F.ReadBool('INIT', 'LoadZip', true);
   LoadStreet := F.ReadBool('street', 'LoadStreet', true);
   rooturl := F.ReadString('INIT', 'rooturl', '');
   try
   S := 1;
   I := length(WebObjects);
   while true do
     begin
      PostUrl := '';
      St := LoadStrip(F, S, false, PostUrl);
      if St <> nil then
        begin
          setlength(WebObjects, i+1);
          WebObjects[i] := St;
          WebObjects[i].WebIndex := i;
          Webobjects[i].IniFile := 'streeweb.ini';
          if TStripObject(St).MergeObj = nil then
            begin
              Idx := StripObjects.Items.Add(WebObjects[i].Command);
              Strips[Idx] := I;
            end;
          inc(I);
          inc(S);
        end
      else
         break;
      if ST.Command = 're1' then
         begin
            setlength(WebObjects, i+1);
            WebObjects[i] := TRealRep.Create('report', 'report', WebInterf, false);
            inc(i);
         end;
     end;
   S := 1;
   while true do
      begin
        Sh := LoadShape(F, S);
        if Sh <> nil then
           begin
             setlength(WebObjects, i+1);
             WebObjects[i] := Sh;
             Webobjects[i].IniFile := 'streeweb.ini';
             WebObjects[i].WebIndex := i;
             inc(I);
             inc(S);
           end
        else
          break;
      end;
   S := 1;
   while true do
      begin
        Rm := LoadRemote(F, S);
        if Rm <> nil then
           begin
             setlength(WebObjects, i+1);
             WebObjects[i] := Rm;
             WebObjects[i].WebIndex := i;
             Webobjects[i].IniFile := 'streeweb.ini';
             if Rm.Command = 'default' then
                defaultRemote := i;
             inc(I);
             inc(S);
           end
        else
          break;
      end;
   finally
     F.free;
   end;

   F := TMeminiFile.create(GetHardRootdir1 + 'autoweb.ini');
   try
   S := 1;
   I := length(WebObjects);
   PostUrl := '';
   while true do
     begin
      St := LoadStrip(F, S, false, PostUrl);
      if St <> nil then
        begin
          setlength(WebObjects, i+1);
          WebObjects[i] := St;
          WebObjects[i].WebIndex := i;
          Webobjects[i].IniFile := 'autoweb.ini';
          if TStripObject(St).MergeObj = nil then
            begin
              Idx := StripObjects.Items.Add(WebObjects[i].Command);
              Strips[Idx] := I;
            end;
          inc(I);
          inc(S);
        end
      else
         break;
     end;
   S := 1;
   while true do
      begin
        Rm := LoadRemote(F, S);
        if Rm <> nil then
           begin
             setlength(WebObjects, i+1);
             WebObjects[i] := Rm;
             Webobjects[i].IniFile := 'autoweb.ini';
             WebObjects[i].WebIndex := i;
             if Rm.Command = 'default' then
                defaultRemote := i;
             inc(I);
             inc(S);
           end
        else
          break;
      end;
   finally
     F.free;
   end;
end;


function TWebInterf.LoadStrip(Var F : TMemIniFile; S : integer; raiseerrors : boolean; Var PostUrlAddress : string) : TWebObject;
Var   Dir, Command, Section : String;
   Fi, k : integer;
   Merge, fFormat, FieldName : String;
   SourceNumber : integer;
   StripObject : TStripObject;
function ReadAttr(Attr : String; defaultname : string) : integer;
Var i : integer;
    name : string;
begin
     result := F.ReadInteger(Section, Attr, -1);
     if result < 0 then
        begin
          name := F.ReadString(Section, Attr, '');
          if name = '' then
            name := defaultname;
          i := StripObject.FindField(name);
          if i >= 0 then
             result := StripObject.Fields[i].SrcNum;
        end;
end;
begin
    Result := nil;
    Section := 'Strip' + inttostr(S);
    Dir := F.ReadString(Section, 'Dir', '');
    Command := F.ReadString(Section, 'Command', '');
    if Command = 'hotels' then
      HotelObj := length(WebObjects);
    if Command = 'flproperties' then
      FolioObj := length(WebObjects);
    if Dir <> '' then
      begin
         fFormat := F.ReadString(Section, 'Format', 'strip');
         if fFormat = 'dbfshp' then
           Result := TStripDBF.Create(Command, Dir, self, true)
         else if fFormat = 'real' then
           Result := TStripReal.Create(Command, Dir, self, true)
         else
           Result := TStripObject.Create(Command, Dir, self, true);
         StripObject := TStripObject(result);
         with TSTripObject(Result) do
           begin
             SectionNum := S;
             Header := F.ReadString(Section, 'Header', '');
             if Header <> '' then
               REadStringFile(Dir1+Header, Header);
             HeaderDist := F.ReadString(Section, 'HeaderDist', '');
             if HeaderDist <> '' then
               REadStringFile(Dir1+HeaderDist, HeaderDist);
             Fi := 1;
             Fields := nil;
             FieldNames := F.ReadString(Section, 'FieldNames', '');
             PostUrl := F.ReadString(Section, 'PostUrl', PostUrlAddress);
             PostUrlAddress := PostUrl;
             AddFields(FieldNames);
             repeat
                FieldName := F.ReadString(Section, 'FieldName' + inttostr(Fi), '');
//                      FieldNumber := F.ReadInteger('Section', 'FieldNumber' + inttostr(F), 0);
                SourceNumber := F.ReadInteger(Section, 'FieldSource' + inttostr(Fi), 0);
                if FieldName <> '' then
                   AddField(FieldName, SourceNumber);
                inc(Fi);
             until FieldName = '';
             DBName := TheFileName(Dir, true) + '.db';
             MainDbName := DBName;
             MakeDictionary(F.ReadString(Section, 'Dictionary', ''));
{             if HeaderDist = '' then
               HeaderDist := Header;}
             RemoveFile := F.ReadBool(Section, 'DeleteFile', false);
             UseRam := F.ReadBool(Section, 'UseRam', false);;
             fileFormat := F.ReadString(Section, 'Format', 'strip');
             SkipLon := ReadAttr('LongitudeCol', 'longitude') - 1;
             if SkipLon < 0 then
               if raiseerrors and (fileFormat = 'strip') then
                raise exception.create('Attribue longitude not found!');
             SkipLat := ReadAttr('LatitudeCol', 'latitude') - 1;
             if raiseerrors and (SkipLat < 0) then
               if fileFormat = 'strip' then
                raise exception.create('Attribue latitude not found!');
             YearPos := F.ReadInteger(Section, 'YearPos', -1);
             HourPos := F.ReadInteger(Section, 'HourPos', -1);
             SkipAddress := ReadAttr('AddressCol', 'street_address') - 1;
             SkipZip := ReadAttr('ZipCol', 'zip_code') - 1;
             SkipCity := ReadAttr('CityCol', 'city_name') -1;
             SkipState := ReadAttr('StateCol', 'state') -1;
             MinApprox := F.ReadInteger(Section, 'MinApprox', A_ZipCenter);
             AppendLevel := F.ReadBool(Section, 'AppendLevel', false);
             KeyField := ReadAttr('KeyField', 'mls');
             KeyField1 := ReadAttr('KeyField1', 'mls');
             if KeyField < 0 then
               KeyField := ReadAttr('MLSField', 'mls');
             InitialStripNum := F.ReadInteger(Section, 'InitStrip', 1000);
             UseFolio := F.ReadBool(Section, 'UseFolio', false);
             ExpireDays := F.ReadInteger(Section, 'ExpireDays', 0);
             PriceField := ReadAttr('PriceField', 'list_price');
             EnterDateField := ReadAttr('EnterDateField', 'enterdate');
             if EnterDateField < 0 then
               EnterDateField := SkipLon + 2;
             latitudestart := F.ReadInteger(Section, 'latitudestart', -1);
             longitudestart := F.ReadInteger(Section, 'longitudestart', -1);
             coorlength := F.ReadInteger(Section, 'longitudestart', -1);
             coorformat := F.ReadString(Section, 'coorformat', 'double');
             extractfrom := F.ReadInteger(Section, 'extractfrom', 1);
             extractlength := F.ReadInteger(Section, 'extractlength', 0);
             BackupDir1 := F.ReadString(Section, 'backup', '');
             BackupName := F.ReadString(Section, 'backupname', '');
             MoveSource := F.ReadString(Section, 'movesource', '');
             if length(BAckupDir1) > 0 then
              if BackupDir1[length(BackupDir1)] <> '\' then
                BackupDir1 := BackupDir1 + '\';
             FileExt := F.ReadString(Section, 'FileEXT', '');
             RequestParameters := F.ReadString(Section, 'requestparams', '');
             if RequestParameters <> '' then
                RequestParameters :='&' + RequestParameters + '&printdist=1';
             TranslateCoor := F.ReadBool(Section, 'Translate', false);
             ParseNameDate := F.ReadBool(Section, 'ParseDate', false);
             SkipFirstLine := F.ReadBool(Section, 'SkipFirstLine', false);
             LongMultiplier := F.ReadInteger(Section, 'LongMultiplier', 1);
             Merge := F.ReadString(Section, 'Merge', '');
             MergeObj := nil;
             LastMerge := nil;
             if Merge <> '' then
               begin
                 Query := false; // do not include in query??
                 for k := 0 to length(WebObjects)-1 do
                    if webobjects[k].Command = Merge then
                       begin
                         MergeObj := TStripObject(webobjects[k]);
                         MergeObj.LastMerge := TStripObject(Result);
                         break;
                       end;
               end;
           end;
      end;
end;

function TWebInterf.LoadShape(Var F : TMemIniFile; S : integer) : TWebObject;
Var   Dir, Command, sformat, Section : String;
begin
    Section := 'Shape' + inttostr(S);
    Dir := F.ReadString(Section, 'Dir', '');
    Command := F.ReadString(Section, 'Command', '');
    sformat := F.ReadString(Section, 'format', '');
    result := nil;
    if Dir <> '' then
      begin
         Result := TShapeObject.Create(Command, Dir, self, true);
         if Command = 'state' then
            istateobject := result;
         if Command = 'country' then
            icountryobject := result;
         with TShapeObject(Result) do
           begin
             Header := F.ReadString(Section, 'Header', '');
             if Header <> '' then
               REadStringFile(Dir1+Header, Header);
             NumInfoLines := F.ReadInteger(Section, 'Rows', 3);
             Keylength := F.ReadInteger(Section, 'KeyLength', 1);
             expectedlength := F.ReadInteger(Section, 'ExpectedLength', 0);
             expectedfield := F.ReadInteger(Section, 'ExpectedField', 0);
             Keystart := F.ReadInteger(Section, 'Keystart', 1);
             Key := F.ReadString(Section, 'Key', '');
             IDIndex := F.ReadInteger(Section, 'IDIndex', 1);
             sourceformat := sformat;
           end;
      end;
end;

function TWebInterf.LoadRemote(Var F : TMemIniFile; S : integer) : TWebObject;
Var Header, Dir, Root, Command, Section : String;
begin
    Section := 'Remote' + inttostr(S);
    Command := F.ReadString(Section, 'Command', '');
    Dir := F.ReadString(Section, 'Host', '');
    Root := F.ReadString(Section, 'Dir', '');
    Root := GetHardRootDir1 + Root + '\';
    Header := F.ReadString(Section, 'Header', 'header.txt');
    ReadStringFile(Root+Header, Header);
    result := nil;
    if Command <> '' then
      begin
         Result := TRemoteObject.Create(Command, Dir, self, true);
         if Command = 'street' then
            rstreetobject := result;
         if Command = 'flproperties' then
            rFLPropertiesObject := result;
         if Command = 'nfolio' then
            rnfolioobject := result;
         if Command = 'ownership' then
            rownershipobject := result;
         if Command = 'sks/query' then  // for rooftop geocoding
            first_americanobject := result;
         if Command = 'zip' then
            zip_americanobject := result;
         Result.Dir1 := Dir;
         TRemoteObject(Result).Header := Header;
         TRemoteObject(Result).AddFieldsFromHeader;
      end;
end;

procedure TWebInterf.FormCreate(Sender: TObject);
Var DummyAr : array of byte;
    F :TMeminiFile;
begin
//   setlength(DummyAr, integer(65536)*32767 div 2);
//   DummyAr := nil;

   {regexp := TRegExpr.Create;      //creates regexp
   regexp_Compile;                 // compiles it based on pattern (hard-coded) see procedure

   regexp_pound := TRegExpr.Create;  //For the pound sign that matches incorrectly
   regexp_pound_Compile;
   }

   Started := false;
   LogFile := GetHardRootDir1 + 'LogFile.log';
   LogToFile := false;
   setlength(WebObjects, 6);
   WebObjects[CityObj] := TCityObject.Create('city', 'cities', self, true);
   ICityObject := TCityObject(WebObjects[CityObj]);
   WebObjects[RequestObj] := TRequestObject.Create('request', '', self, false);
   WebObjects[ZipObj] := TZipObject.Create('zip', 'zipcodes', self, true);
   IZipObject := TZipObject(WebObjects[ZipObj]);
   WebObjects[CategoryObj] := TCategoryObject.Create('query', '', self, false);
   WebObjects[HelpObj] := THelpObject.Create('help', '', self, false);
   F := TMeminiFile.create(GetHardRootdir1 + 'streeweb.ini');
   LoadStreet := F.ReadBool('Street', 'LoadStreet', true);
   F.Free;
   if LoadStreet then
     begin
       WebObjects[StreetObj] := TStreetObject.Create('street', 'streets', self, false);
       istreetobject := TStreetObject(WebObjects[StreetObj]);
     end
   else
     begin
        setlength(WebObjects, 5);
        istreetobject := nil;
     end;
{   WebObjects[HotelObj] := THotelObject.Create('hotel', 'hotels', self);
   WebObjects[ExploreObj] := TExploreObject.Create('explore', '', self);}
   ReadInifile;
   if HotelObj >= 0 then
      begin
        ExploreObj := length(WebObjects);
        setlength(WebObjects, ExploreObj + 1);
        WebObjects[ExploreObj] := TExploreObject.Create('explore', '', self, false);
      end;
   Queue := TStrQueue.Create;
//   WebObjects[2] := TCitiObject.Create('city', 'city', self);
   NumHandled := 0;
   timer1.enabled := true;
   LogEnabled := Logging.Checked;
end;

procedure TWebInterf.SetStatus(Status : String);
Var e : boolean;
begin
   e := Queue.Enabled;
   Queue.Enabled := true;
   AddLog(Status);
   Queue.Enabled := E;
{   Status1.Caption := Status;
   Memo1.Lines.Add(FormatDateTime('hh:mm:ss> ', now) + Status);
   Application.Processmessages;}
end;

{procedure TWebInterf.LogNow(S : String);
begin
   Memo1.Lines.Add(FormatDateTime('hh:mm:ss> ', now) + S);
   Application.Processmessages;
end;}

procedure TWebInterf.AddLog(S : String);
begin
   Queue.Append(FormatDateTime('yyyy/mm/dd hh:nn:ss.zzz> ', now) + S + '  Nanostamp:' + inttostr(NanoTime));
end;

procedure TWebInterf.EnableLog1;
begin
   LogEnabled := true;
   Queue.Enabled := true;
end;

procedure TWebInterf.WMUser (var msg: TMessage);
begin
   UserClose := true;
   AppendFile(GetHardRootDir1+'ShutDown.LOG', GetTimeText + ' Received shutdown message');
   while servcount <> 0 do
     Application.Processmessages;
   Application.Terminate;
end;

function GetExeBuild: Integer;
var
  FileName: string;
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
  ComCtlVersion : integer;
begin
    ComCtlVersion := 0;
    FileName := ParamStr(0) + #0;
    InfoSize := GetFileVersionInfoSize(@FileName[1], Wnd);
    if InfoSize <> 0 then
    begin
      GetMem(VerBuf, InfoSize);
      try
        if GetFileVersionInfo(@FileName[1], Wnd, InfoSize, VerBuf) then
          if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
            ComCtlVersion := FI.dwProductVersionLS and 65535;
      finally
        FreeMem(VerBuf);
      end;
    end;
  Result := ComCtlVersion;
end;

procedure TWebInterf.KillOtherInstance;
Var OtherInstanceWnd : HWnd;
    t1 : int64;
begin
  OtherInstanceWnd := FindWindow ('TWebInterf', Pchar(NewCaption));
  if OtherInstanceWnd <> 0 then
     PostMessage(OtherInstanceWnd, wm_User, 0, 0)
  else
     exit;
  t1 := NanoTime + 60*NanoFrequency;
  while (OtherInstanceWnd <> 0) and (NanoTime < t1) do
    begin
      Application.processmessages;
      OtherInstanceWnd := FindWindow ('TWebInterf', PChar(NewCaption));
    end;
  t1 := NanoTime + 1*NanoFrequency;
  while NanoTime < t1 do
      Application.processmessages;
end;

const Initialized : boolean = false;
const UPdateBusy : boolean = true;
procedure TWebInterf.Initialize;
Var i, Tobj, TVert, Tpoints : integer;
    S : String;
begin
       try
       Queue.Enabled := true;
       initialized := true;
       Timer1.Interval := 100;
       TObj := 0;
       TVert := 0;
       Tpoints := 0;
       for i := 0 to length(WebObjects) -1 do
         if Webobjects[i] <> nil then
         begin
           if not (
                     ((WebObjects[i] is TZipObject) and (not LoadZip))
                  or ((WebObjects[i] is TStreetObject) and (not LoadStreet))
                  or ((WebObjects[i] is TCityObject) and (not LoadCity))
                  ) then
             begin
               Webobjects[i].Init;
               inc(Tobj, Webobjects[i].TotalObjects);
               inc(Tvert, Webobjects[i].TotalVertixes);
               inc(TPoints, Webobjects[i].TotalPoints);
               NObjects.Caption := 'Objects: ' + inttostr(Tobj);
               NVertixes.Caption := 'Vertixes: ' + inttostr(Tvert);
               NPoint.Caption := 'Pts: ' + inttostr(TPoints);
              end;
         end;
       SetStatus('Ready. Press Start to activate');
       UPdateBusy := false;
       Start.Enabled := true;
       Timer2.Enabled := true;
       Queue.Enabled := Logging.Checked;
       if Autostart then
          StartClick(Application);
       except on E: Exception do
          begin
             AddLog('Initialize Exception: ' + E.Message);
             AppendFile(GetHardRootDir1+'Error.LOG', 'Initialize Exception: ' + E.Message);
          end;
       end;
       SetStatus('Ready ... ');
       InitializeCriticalSection(CriticalSection);
end;

procedure TWebInterf.Timer1Timer(Sender: TObject);
Var S : String;
begin
   if not initialized then
     begin
       initialized := true;
//       initialize;
       ithreadpool.Enqueue(Initialize);
       Caption := 'Initializing... Program version: ' + inttostr(GetExeBuild);
     end;
   Requests.Caption := inttostr(NumHandled);
   if Logging.Checked <> LogEnabled then
     Logging.Checked := LogEnabled;
   while Queue.Fetch(S) do
     begin
        memo1.Lines.Add(S);
//        AppendFile(GetHardRootDir1+'Error.LOG', S);
     end;
end;

const MaxTest = 1000;
procedure TWebInterf.TestClick(Sender: TObject);
begin
//  WebObjects[0].TestClick;
{   T := nanotime;
   for i := 0 to MaxTest do
      begin
         X1 := -80.5 + (-73.25 + 80.5) * Random(100000000)/100000000;
         Y1 := 39.68 + (41.92 - 39.68) * Random(100000000)/100000000;
         X2 := X1 + 0.1;
         Y2 := Y1 + 0.1;
      end;
   TT := MaxTest/((Nanotime - T)/Nanofrequency);
   Str(TT : 10 : 8, S);
   Label5.Caption := 'Searches per second : ' + S;}
end;

function TWebInterf.CreateDataSet(DataSetName : string) : string;
Var  F : TmemIniFile;
     i, s, Idx : integer;
     Dir, Section, PostURL : String;
     St : TWebObject;
begin
   if DataSetName = '' then
        begin
           result := 'error: dataset name is empty';
           exit;
        end;
   for i := 0 to length(Webobjects) - 1 do
     if pos(webobjects[i].Command, DataSetName) = 1 then
        begin
           result := 'error: dataset with that name already exists: ' + webobjects[i].Command;
           exit;
        end;
   F := TMeminiFile.create(GetHardRootdir1 + 'autoweb.ini');
   try
       S := 1;
       i := length(WebObjects);
       while true do
         begin
           Section := 'Strip' + inttostr(S);
           Dir := F.ReadString(Section, 'Dir', '');
           if Dir = '' then
              break;
           inc(S);
         end;
        Section := 'Strip' + inttostr(S);
        F.WriteString(Section, 'Dir', DataSetName);
        F.WriteString(Section, 'Command', DataSetName);
        F.WriteString(Section, 'Format', 'strip');
        F.WriteString(Section, 'Header', DataSetName + '.header');
        F.WriteString(Section, 'FileEXT', 'ascii');
    //    F.WriteString(Section, 'requestparams', 'd=10&numfind=10');
        F.UpdateFile;
        PostUrl := '';
        St := LoadStrip(F, S, false, PostUrl);
        if St <> nil then
          begin
            setlength(WebObjects, i+1);
            WebObjects[i] := St;
            Webobjects[i].IniFile := 'autoweb.ini';
            WebObjects[i].WebIndex := i;
            if TStripObject(St).MergeObj = nil then
              begin
                Idx := StripObjects.Items.Add(WebObjects[i].Command);
                Strips[Idx] := I;
              end;
          end;
         St.Init;
    finally
      F.Free;
    end;
    result := 'the dataset created';
end;

//procedure TWebInterf.BatchGeocoding(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo:TIdHTTPResponseInfo);
procedure TWebInterf.BatchGeocoding(UnparsedParams : String; Var ResponseInfo: String);
Var S, VarName, V ,records, filename: string;
    p : integer;
    D : double;
    id1 : LongWord;
    thread1 : Integer;
    msg1 : TMsgRecord;
begin
    /// parameters: file_name=a.tab&callback=http:\\geoimage2.cs.fiu.edu\geocoder\test\jobdone.ashx?file=b.tab&file_out=b.tab
        S := TIdURI.URLDecode(UnparsedParams);
        p := 1;
        EnterCriticalSection(CriticalSection);
        while p < length(S) do
        begin
                ParseDoubleVar(S, VarName, D, V, p);
                if (VarName = 'file_name') and (V <> '') then
                begin
                        //SetLength(msg1.fileinp,Length(V));
                        //msg1.fileinp := V;
                        fileinp := V;
                end;
                if(VarName = 'callback') and (V = '') then
                begin
                        exit;
                end;
                if(VarName = 'callback') and (V <> '') then
                begin
                        //SetLength(msg1.confirmation,Length(V));
                        //msg1.confirmation := V;
                        confirmation := V;
                end;
                if(VarName = 'file_out') and (V <> '') then
                begin
                        //SetLength(msg1.fileoutp,Length(V));
                        //msg1.fileoutp := V;
                        fileoutp := V
                end;
                if(VarName = 'error_url') and (V <> '') then
                begin
                        error_url := V
                end;



        end;  // end while parsing params
        LeaveCriticalSection(CriticalSection);
        thread1 := BeginThread(nil,
                                   0,
                                   Addr(process_filegeo),
                                   Addr(msg1),
                                   0,
                                   id1);        // thread starts
        ResponseInfo := 'Done!!';
end;

procedure TWebInterf.ProcessGet(IP, Document, UnparsedParams : String; Var ResponseInfo: String; Var ContentType : String; AResponseInfo: TIdHTTPResponseInfo);
Var i, j : integer;
    fname : String;
    c : char;
    handled : boolean;
  procedure AuthFailed;
  begin
     ResponseInfo := '<html><head><title>Error</title></head><body><h1>Authentication failed</h1>'#13 +
      'Check the demo source code to discover the password:<br><ul><li>Search for <b>AuthUsername</b> in <b>Main.pas</b>!</ul></body></html>';
  end;

  procedure AccessDenied;
  begin
    ResponseInfo := '<html><head><title>Error</title></head><body><h1>Access denied or the requested command does not exist</h1>'#13 +
      'You do not have sufficient priviligies to access this document.</body></html>';
  end;
begin
  if LogToFile then
     AppendFile(LogFile, Document + TAB + UnparsedParams + TAB + 'Nanostamp:' + inttostr(NanoTime) + TAB + FormatDateTime('yyyy/mm/dd hh:nn:ss.zzz> ', now));
  inc(NumHandled);
  handled := true;
  try
  if (pos('192.168.', IP) = 1) or (pos('131.94.', IP) = 1) or (pos('127.0.0.1', IP) = 1) or
     (pos('67.17.', IP) = 1) or (pos('67.34.36.', IP) = 1) or (pos('209.42.', IP) = 1) or
     (pos('63.251.', IP) = 1) or (pos('144.47.160.', IP) = 1) or (pos('68.219.16.', IP) = 1) or
     (pos('144.47.161.', IP) = 1) or (pos('72.32.12.17', IP) = 1) or
     (pos('166.108.253.11', IP) = 1) or (pos('74.208.47.226', IP) = 1) or
     (pos('50.19.78.163',IP) = 1) // Martha's request
     //(pos('216.74.147.188', IP) = 1) or (pos('16.74.134.206', IP) = 1) or (pos('216.74.147.185', IP) = 1)
     or (pos('66.29.255.88', IP) = 1) or (pos('66.29.255.89', IP) = 1) or (pos('66.29.255.90', IP) = 1)
     or (pos('66.29.255.91', IP) = 1) or (pos('66.29.255.92', IP) = 1) or (pos('66.29.255.93', IP) = 1)
     or (pos('66.29.255.94', IP) = 1) or (pos('66.29.255.95', IP) = 1) or (pos('173.12.113.21', IP) = 1)
     or (pos('207.224.213.179',IP) = 1)
     then
    begin
        if pos('/yz', Document) = 1 then
          begin
             Delete(Document, 2, 2);
             while true do
               begin
                 c := Document[length(Document)];
                 if (c <='9') and (c >= '0') then
                    delete(Document, length(Document), 1)
                 else
                    break;
               end;
          end;
        if pos('batchgeocoding',Document) = 2 then
          begin
             BatchGeocoding(UnparsedParams,ResponseInfo);
             exit;  // JAB exit this procedure so that we can process this outside and take advantage of TIdHTTPRequestInfo to read streams
          end;
        if pos('file', Document) = 2 then
          begin
             fname := GetHardRootDir1+UnparsedParams;
             if fileexists(fname) then
               begin
                 AResponseInfo.ContentStream := TFileStream.Create(fname, FmOpenRead+fmShareCompat+fmShareDenyNone);
                 ContentType := 'text/plain';
                 exit;
               end
             else
               ResponseInfo := 'file ' + fname + ' not found';
          end
        else
        for i := 0 to length(WebObjects) - 1 do
          if (WebObjects[i] <> nil) and (Webobjects[i].Command <> '') then
           begin
             j := 1;
             handled := false;
             while true do
                begin
                  if (j+1) > length(Document) then
                    break;
                  if Document[j+1] <> Webobjects[i].Command[j] then
                    break;
                  inc(j);
                  if j > length(Webobjects[i].Command) then
                    begin
                       handled := true;
                       Webobjects[i].HandleCommand(UnparsedParams, ResponseInfo, ContentType);
                       if pos('68.219.16.', IP) = 1 then
                          begin
                             SetStatus('Monitored Request:  from ' + IP + ' ' + Document + '?' + UnparsedParams);
                             AppendFile(GetHardRootDir1+'Monitored.LOG', GetTimeText+'Request from: ' + IP + ' ' + Document + '?' + UnparsedParams);
                          end;
                       if (pos('144.47.160.', IP) = 1) or (pos('144.47.161.', IP) = 1) then
                          begin
                             SetStatus('Monitored Request:  from ' + IP + ' ' + Document + '?' + UnparsedParams);
                             AppendFile(GetHardRootDir1+'Monitored.LOG', GetTimeText+'Request from: ' + IP + ' ' + Document + '?' + UnparsedParams);
                          end;
                       //if (pos('131.94.130.65', IP) = 1)then  //do not need this
                         // begin
                         //    SetStatus('Monitored Request:  from ' + IP + ' ' + Document + '?' + UnparsedParams);
                         //    AppendFile(GetHardRootDir1+'Monitored.LOG', GetTimeText+'Request from: ' + IP + ' ' + Document + '?' + UnparsedParams);
                         // end;
                       // Requested by Martha: keep track of these IPs
                       //if (pos('216.74.147.188', IP) = 1) or (pos('216.74.134.206', IP) = 1) or (pos('216.74.134.206', IP) = 1) then
                         if (pos('50.19.78.163',IP) = 1) then
                          begin
                             //SetStatus('Monitored Request:  from ' + IP + ' ' + Document + '?' + UnparsedParams);
                             AppendFile(GetHardRootDir1+'Monitored.LOG', GetTimeText+' IP: ' + IP + ' ' + Document + '?' + UnparsedParams);
                          end;
                       exit;
                    end;
                end;
           end;
    end;
   if not handled then
     if defaultRemote >= 0 then
      begin
         webobjects[defaultRemote].Command := copy(Document, 2, length(Document) - 1);
         Webobjects[defaultRemote].HandleCommand(UnparsedParams, ResponseInfo, ContentType);
         exit;
      end;
   except on E: exception do
      begin
//         EnableLog;
         AddLog('Request: ' + Document + ' --- ' + UnparsedParams + ' Exception: ' + E.Message);
         AppendFile(GetHardRootDir1+'Error.LOG', GetTimeText+'Request: ' + UnparsedParams + ' Exception: ' + E.Message);
      end;
   end;
   AccessDenied;
end;

procedure TWebInterf.HTTPServerCommandGet(AThread: TIdPeerThread;
      ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);
Var    ResponseInfo, ContentType : String;
       T : int64;
       TT : double;
       e : boolean;

begin
  if LogEnabled then
    AddLog(Format( '%s from %s:%d',
        [ARequestInfo.RawHttpCommand,
        TIdIOHandlerSocket(AThread.Connection.IOHandler).Binding.PeerIP,
        TIdIOHandlerSocket(AThread.Connection.IOHandler).Binding.PeerPort]));
  if userclose then
     exit;
  try
    inc(servcount);
    ContentType := AResponseInfo.ContentType;
    T := nanotime;
  try
    ProcessGet(TIdIOHandlerSocket(AThread.Connection.IOHandler).Binding.PeerIP, ArequestInfo.Document, ARequestInfo.UnparsedParams, ResponseInfo, ContentType, AResponseInfo);
    //if batchgeocoding = 1 then
         //BatchGeocoding(ARequestInfo,AResponseInfo);
 finally
   begin
       TT := (Nanotime - T)/Nanofrequency;
       if TT > 30 then
          begin
             e := Queue.Enabled;
             Queue.Enabled := true;
             AddLog('LONG REQUEST of ' + Format( '%f seconds: %s from %s:%d',
               [TT, ARequestInfo.RawHttpCommand,
               TIdIOHandlerSocket(AThread.Connection.IOHandler).Binding.PeerIP,
               TIdIOHandlerSocket(AThread.Connection.IOHandler).Binding.PeerPort]));
             Queue.Enabled := E;
          end;
   end;
 end;
    AresponseInfo.ContentText := ResponseInfo;
    AresponseInfo.ContentType := ContentType;
  finally
     dec(servcount);
  end;
end;

procedure TWebInterf.LoggingClick(Sender: TObject);
begin
   LogEnabled := Logging.Checked;
   Queue.Enabled := Logging.Checked;
end;

procedure TWebObject.TestClick;
begin
end;

procedure TWebInterf.SearchClick(Sender: TObject);
begin
    TZipObject(WebObjects[ZipObj]).DumpCities;
end;

function  TWebInterf.ProcessQuery(cmd : string; UnparsedParams : String; standard : boolean) : String;
Var i, j : integer;
    CType : String;
    E : boolean;
    handled : boolean;
begin
 Result := '';
{ if cmd = 'all' then
    begin
      result := '';
      for i := 0 to length(WebObjects) - 1 do
       if WebObjects[i] <> nil then
        if WebObjects[i].Query then
          result :=  result + ':' + Webobjects[i].Command + #10 + Webobjects[i].ProcessQuery(UnparsedParams, true, CType);
    end
 else}
  for i := 0 to length(WebObjects) - 1 do
  if i <> defaultRemote then
   if WebObjects[i] <> nil then
     begin
       j := 1;
       while true do
          begin
            if j > length(cmd) then
              break;
            if cmd[j] <> Webobjects[i].Command[j] then
              break;
            inc(j);
            if j > length(Webobjects[i].Command) then
              begin
                 if standard then
                   begin
                     CType := 'standard';
                     result := {'SUBREPORT:' + TAB + Webobjects[i].Command + #10 +}
                     Webobjects[i].ProcessQuery(UnparsedParams, true, CType) + #10+#10+#10+#10+#10;
                   end
                 else
                   begin
                     result := ':' + Webobjects[i].Command + #10 + Webobjects[i].ProcessQuery(UnparsedParams, true, CType);
                   end;
                 exit;
              end;
          end;
     end;
   if defaultRemote >= 0 then
    begin
       webobjects[defaultRemote].Command := Cmd;
       if standard then
         begin
           CType := 'standard';
           result := Webobjects[defaultRemote].ProcessQuery(UnparsedParams, true, CType)+ #10+#10+#10+#10+#10;;
         end
       else
         begin
             result := ':' + Webobjects[defaultRemote].Command + #10 + Webobjects[defaultRemote].ProcessQuery(UnparsedParams, true, CType);
         end;
       exit;
    end;
end;

procedure TWebObject.DumpRecords(Var c : integer);
begin
end;

procedure TWebInterf.BkpBtnClick(Sender: TObject);
Var i, c : integer;
    F : TextFile;
begin
   for i := 0 to length(WebObjects) - 1 do
      WebObjects[i].Backup;
{   for i := 0 to length(WebObjects) - 1 do
    if WebObjects[i] <> nil then
     begin
       C := i * 10000000;
       WebObjects[i].DumpRecords(c);
     end;}
{    Memo1.Lines.SaveToFile(GetHardRootDir1 + FormatDateTime('DMPyyyy-mm-dd-hh-nn.LOG', now));
    Memo1.Lines.Clear;}
{    AssignFile(F, GetHardRootDir1 + 'MissingZip.txt');
    rewrite(f);
    for i := MinZip to MaxZip do
      if Length(IStreetObject.ZipCity[i]) > 0 then
        if IZipObject.ZipCodes[i].CX = 0 then
           begin
             writeln(f, ZipStr(i));
           end;
    closeFile(F);}
end;


 {
 procedure TWebInterf.regexp_pound_Compile;
 begin
  try
    // r.e. precompilation (then you assign Expression property,
    // TRegExpr automatically compiles the r.e.).
    // Note:
    //   if there are errors in r.e. TRegExpr will raise
    //   exception.

    regexp_pound.Expression := '# [^ ]*|#[^ ]*';

    except on E:Exception do begin // exception during r.e. compilation or execution
      if E is ERegExpr then
       if (E as ERegExpr).CompilerErrorPos > 0 then begin
         SetStatus('WARNING: Regular Expression is invalid');
        end;
      raise Exception.Create (E.Message); // continue exception processing
     end;
   end;
 end;
}

procedure TWebInterf.StartClick(Sender: TObject);
begin
   if HttpServer.Active then
     begin
       SetStatus('Press start to activate');
       Caption := 'Program version: ' + inttostr(GetExeBuild);
       HttpServer.Active := false;
       Start.Caption := 'START';
     end
   else
     begin
       NewCaption := 'HPDRC Spatial Web Service Port ' + Port.Text;
       KillOtherInstance;
       HttpServer.DefaultPort := ValStr(Port.Text);
//           HttpServer2.DefaultPort := 8080;
//           HttpServer2.Active := true;
       HttpServer.Active := true;
       SetStatus('Ready ... Listening on port = '+ inttostr(HttpServer.DefaultPort));
       Caption := NewCaption;
       Start.Caption := 'RUNNING';
       Start.Enabled := false;
     end;
end;

procedure TWebInterf.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
Var i : integer;
begin
   AppendFile(GetHardRootDir1+'Shutdown.LOG', GetTimeText+' CloseQuery ');
   if not UserClose then
     CanClose := Dialogs.MessageDlg('Sure to close?', mtConfirmation, [mbYes, mbNo], 0) = mrYes
   else
     Sleep(500);
   if CanClose then
    for i := 0 to length(WebObjects) -1 do
     begin
       if webobjects[i] <> nil then
         WebObjects[i].Free;
       WebObjects[i] := nil;
     end;
end;

const bb : integer = 0;
procedure TWebInterf.IdIOHandlerThrottle1Status(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
  inc(bb);
end;

procedure TWebInterf.MergeKeysClick(Sender: TObject);
Var i : integer;
begin
   KeyBase := TKeyBase.Create;
   KeyBase.Load(GetHardRootDir1 + 'geosum\geosumm.txt');
   KeyBase.MakeHash;
   for i := 0 to length(WebObjects) - 1 do
     if WebObjects[i] is TShapeObject then
       begin
         TShapeObject(WebObjects[i]).GetInfo2;
         TShapeObject(WebObjects[i]).SaveBase;
       end;
   IZipObject.GetInfo2;
   IZipObject.SaveBase;
   KeyBase.Free;
end;

procedure TWebInterf.RebuildClick(Sender: TObject);
Var I,S, j : Integer;
    F : TMemIniFile;
    Tmp, St : TWebObject;
begin
  I := StripObjects.itemindex;
  if I < 0 then
    exit;
  I := Strips[I];
  RebuildStrip(I, true);
end;

procedure TWebInterf.StreetIdxClick(Sender: TObject);
begin
   if StripObjects.itemindex >= 0 then
     TStripObject(WebObjects[Strips[StripObjects.itemindex]]).IndexStreets;
end;

const UpdateReported : boolean = false;

procedure TWebInterf.RebuildStrip(I : integer; Force : boolean);
begin
  if UPdateBusy then
    begin
       if (not UpdateReported) and Force then
         begin
            UpdateReported := true;
            Myutil1.MessageDlg('Please wait for another rebuild to complete');
         end;
       exit;
    end;
  if not (TStripObject(WebObjects[i]).CheckUpdate or Force) then
    exit;
  InitialStripNum := TStripObject(WebObjects[i]).NumStrip;  
  ObjectToRebuild := i;
  UPdateBusy := true;
  iThreadPool.Enqueue(RebuildStrip1);
end;

procedure TWebInterf.ReBuildStrip1;
Var Err : String;
begin
   try
   BuildStrip(ObjectToRebuild, Err);
   finally
    UPdateBusy := false;
    UpdateReported := false;
   end;
end;

procedure TWebInterf.BuildStrip(ObjIndex : integer; Var Error : String);
Var S, j : Integer;
    F : TMemIniFile;
    Tmp, St : TWebObject;
    PostUrl : string;
begin
try
  F := TMeminiFile.create(GetHardRootdir1 + WebObjects[ObjIndex].Inifile);
  Error := '';
  try
   CSGlobal.Enter;
//   TStripObject(WebObjects[ObjectToRebuild]).Rename;
   S := TStripObject(WebObjects[ObjIndex]).SectionNum;
   PostUrl := '';
   St := LoadStrip(F, S, true, PostUrl);
   St.IniFile := WebObjects[ObjIndex].IniFile;
   St.WebIndex := WebObjects[ObjIndex].WebIndex;
   if TStripObject(WebObjects[ObjIndex]).LastMerge <> nil then
     begin
       for j := 0 to length(WebObjects) -1 do
         if (WebObjects[j] is TStripObject) and (TStripObject(WebObjects[j]).MergeObj = WebObjects[ObjIndex]) then
           begin
             TStripObject(WebObjects[j]).MergeObj := TStripObject(St);
             TStripObject(St).LastMerge := TStripObject(WebObjects[j]);
           end;
     end;
   TStripObject(St).DBName := formatdatetime('yyyymmddhhnn_', now) + TStripObject(St).DBName;
   St.Init(WebObjects[ObjIndex]);
   Error := TStripObject(St).LoadError;
   if TStripObject(WebObjects[ObjIndex]).LastMerge <> nil then
     begin
       for j := 0 to length(WebObjects) -1 do
         if (WebObjects[j] is TStripObject) and (TStripObject(WebObjects[j]).MergeObj = TStripObject(St)) then
           TStripObject(WebObjects[j]).Init;
     end;
   if not fileexists(TStripObject(St).Dir1 + TStripObject(St).DBName) then
      begin
         deletefile(TStripObject(St).Dir1 + 'update.ttt');
         AppendFile(TStripObject(St).Dir1 + 'LoadError.log', GetTimeText + 'Error loading ');
         St.Free;
         exit;
      end
   else
      begin
         Tmp := WebObjects[ObjIndex];
         WebObjects[ObjIndex] := St;
         Tmp.Free;
         TStripObject(WebObjects[ObjIndex]).CompleteUpdate;
         TStripObject(WebObjects[ObjIndex]).MakeCopy;
      end;
  finally
    CSGlobal.Leave;
    F.Free;
  end;
except on E : Exception do
   begin
     Error := E.Message;
     AddLog('Exception in rebuild strip: ' + E.Message);
     AppendFile(GetHardRootDir1+'Error.LOG', GetTimeText+' Exception: ' + E.Message);
   end
end;
end;

procedure TWebInterf.Timer2Timer(Sender: TObject);
Var I : integer;
    PrevPeerState, Res : String;
begin
  for i := 0 to length(WebObjects)-1 do
   if WebObjects[i] is TStripObject then
     RebuildStrip(I, false);
  if not started then
  if PeerName.text <> '' then
     begin
       started := true;
       RunClusterCommand(HostName.Text, 'start');
     end;
  if PeerName.text <> '' then
     begin
        Res := ReadUrl('http://'+PeerName.Text+'/street?street=100 bayview DR Miami FL 33160', 5000);
        PrevPeerState := PeerState;
        UpdateClusterStatus;
        if pos('X=', Res) = 0 then
           begin
             if PrevPeerState= 'CLUSTER OK' then
                begin
                  //SendEmail('jball008@cs.fiu.edu', 'jball008@cs.fiu.edu', 'smtp.cs.fiu.edu', PeerName.Text + ' failed', '');
                  SendEmail('wanghuibo100120@gmail.com', 'wanghuibo100120@gmail.com', 'smtp.cs.fiu.edu', PeerName.Text + ' failed', '');
                  StopClusterClick(nil)
                end;
           end
        else if PeerState = 'CLUSTER OFF' then
           StartClusterClick(nil);
        if (PrevPeerState = 'CLUSTER OFF') and (PeerState = 'CLUSTER OK') then
             SendEmail('shaposhn@cs.fiu.edu', 'shaposhn@cs.fiu.edu', 'smtp.cs.fiu.edu', PeerName.Text + ' OK', '');
     end;
end;

procedure TWebInterf.UpdateClusterStatus;
begin
    RunClusterCommand(PeerName.Text, 'query');
end;

procedure TWebInterf.StartClusterClick(Sender: TObject);
begin
    RunClusterCommand(PeerName.Text, 'start');
end;

procedure TWebInterf.StopClusterClick(Sender: TObject);
begin
    RunClusterCommand(PeerName.Text, 'stop');
end;

procedure  TWebInterf.RunClusterCommand(Peer, Command : string);
Var status : string;
    F : textfile;
    Indicator, Param, S : String;
    fm : integer;
begin
    status := gethardrootdir1 + 'cluster.bat';
    Indicator := gethardrootdir1 + 'done.txt';
    Param := Command + ' stree:' + Peer;
    deletefile(PChar(Indicator));
    if ShellExecute(0, 'open', PChar(status), Pchar(Param), PChar(gethardrootdir1), SW_HIDE) < 32 then
       AddLog('could not execute cluster.bat');
    while not fileexists(Indicator) do // wait until the compilation is done
       Sleep(300);
    fm := filemode;
    filemode := 0;
    assignfile(F, gethardrootdir1 + 'status.txt');
    reset(f);
    readln(F, s);
    readln(F, s);
    if pos('converged', S) <> 0 then
       PeerState := 'CLUSTER OK'
    else if pos('started', S) <> 0 then
       PeerState := 'CLUSTER OK'
    else if pos('stopped', S) <> 0 then
       PeerState := 'CLUSTER OFF'
    else
       PeerState := 'CLUSTER FAILED';
    PeerStatus.Caption := PeerState;
    closefile(f);
    filemode := fm;
end;

procedure TWebInterf.DumpClick(Sender: TObject);
begin
   IstreetObject.DumpBadZips;
end;

procedure TWebInterf.Log2Click(Sender: TObject);
begin
   LogToFile := Log2.Checked;
end;

procedure TWebInterf.PlaylogClick(Sender: TObject);
var Document, logline, UnparsedParams, ResponseInfo, ContentType : string;
    f : textfile;
    p, p0 : integer;
begin
  if opendialog1.filename = '*.log' then
     opendialog1.filename := gethardrootdir1+'*.log';
  if not opendialog1.execute then
     exit;
  assignfile(F, opendialog1.FileName);
  reset(f);
  while not eof(f) do
     begin
        readln(f, logline);
        p := 1;
        while (p < length(logline)) and (logline[p] <> tab) do
           inc(p);
        document := copy(logline, 1, p-1);
        inc(p);
        p0 := p;
        while (p < length(logline)) and (logline[p] <> tab) do
           inc(p);
        unparsedparams := copy(logline, p0, p - p0);
        ProcessGet('', Document, UnparsedParams, ResponseInfo, ContentType, nil);
     end;
  closefile(f);
end;

procedure TWebInterf.VerifyBtnClick(Sender: TObject);
begin
   ithreadpool.Enqueue(TStripObject(Webobjects[FolioObj]).VerifyFolio);
end;

procedure TWebInterf.MemchkClick(Sender: TObject);
begin
   InstallMemoryChecker;
end;

procedure TWebInterf.MemsortClick(Sender: TObject);
begin
  SortMemoryCallers;
end;

begin
  CSGlobal := TCriticalSection.Create;

end.
