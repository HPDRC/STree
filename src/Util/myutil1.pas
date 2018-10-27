unit myutil1;
interface
uses Forms, {$ifdef BSock} SCktcompA, {$endif} StdCtrls, Controls, Buttons,
Classes, ExtCtrls, wintypes, grids, dbtables, Sysutils, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdMessageClient, IdSMTP;

type
  TMsgDlgWnd = class(TForm)
    OKBtn: TBitBtn;
    Bevel1: TBevel;
    DlgMemo: TMemo;
    YesBtn: TBitBtn;
    NoBtn: TBitBtn;
    IdSMTP1: TIdSMTP;
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure MessageDlg(S: String; Modal : boolean = true);
function  MessageDlgYesNo(S: String) : integer;
procedure fopen(Var f: textfile; S: String);
procedure fcreate(Var f: textfile; S: String);
function  GetFileName(Name: String) : string;
procedure ChangeDirToRoot;
function  GetRootDir : String;
function  GetHardRootDir : String;
function  FileExists(Name: String) : Boolean;
function  FileExists1(Name: String) : Boolean;
function  TheFileName1(Name: String) : String;
function  TheFileDir1(Name: String) : String;
function  TheFullFileName(Name: String) : String;
function  TheFileExt(Name: String) : String;
function  TheFileSize(Name : String) : integer;
function  Allocate(S: String) : pchar;
function  GetHardRootDir1 : String;
procedure FileCopy(Src, Dest: String);
function  GetOconnectVersion : integer;
{$ifndef win32}
procedure SetLength(Var S: String; Length : byte);
{$endif}
function  UPStr(S: String) : String;
procedure writeintstr(Var S : String; i : word);
function  readintstr(Var S : String) : word;
Function  str2(i:integer):string;
Function  str3(i:integer):string;
Function  str4(i:integer):string;
{$ifdef BSock}
function  ReadLine(Var S : String; SocketStream: TWinSocketStream; Var PartialLine : string) : boolean;
function  ReadLine1(Var S : String; SocketStream: TWinSocketStream; Var PartialLine : string; Var TotalRead : integer) : boolean;
{$endif}
function  FindLine(Var F: TextFile; S: String) : String;
function  ValStr(S: String) : Longint;
function  GetStr(T : longint) : String;
function  ValStr64(S: String) : int64;
function  GetStr64(T : int64) : String;
procedure DeleteSpaces(Var S:String);
function  FirstWord(Var S: String):String;
function  GetID(var S: String) : Integer;
function  TheTime : integer;
function  DateTimeToTime(D : TDateTime) : integer;
function  TimeStr(Time : integer) : String;
function  TimeStr3(Time : integer) : String;
function  MakeTime(S : String) : integer;
function  ProfileDir : String;
function  ParseTime(S : ShortString) : integer;
function  GetExeBuild: Integer;
function  GetExeVersion: String;
function  booltostr(b: boolean) : String;
function  GetRegServerAddress(Var Port : integer) : string;
function  FindSwitch(const Switch: string): Boolean;
function  ValHexStr(S: String) : int64;
function  HexStr(C : integer) : String;
function  ReadStringFile1(Name : String) : String;
function  FindCD : string;
procedure GetLocalIPs(Var SL : TStringList; ValidOnly : boolean = false);
function  IsValidIP(Var IP : String) : boolean;
procedure MkDirEx(FilePath : String);
procedure WriteLog(Msg : string; errcode : dword = 0);
function  NanoTime : int64;
function  NanoFrequency : int64;
function  IsIpAddress(s : string) : boolean;
procedure Runhelp(i : integer);
procedure RebootWindows;
function  ResolveNametoIP(Host : String) : string;
//function  GetLastError1 : integer;
//function  GetThreadCount : integer;
function  ScanStr(Var Dest : String; Var Src : String; pos : integer) : integer;
procedure FillGrid(Grid : TStringGrid; List : TStringList);
procedure ExtractGrid(List: TStringList; Grid : TStringGrid);
function MakeComma(S : String) : String;
procedure FatalError(S : String);
function  Memcompare(Var Src; Var Dest; Size : integer) : boolean;
function  CorrectStrToDate(S : String) : Double;
function  ReadCSVFile(Name : string) : TStringList;

function FileTimeToDateTime(Var F : TFileTime) : double;
function DateTimeToFileTime(T : Double) : TFileTime;
procedure OpenUrl(URL : string);
procedure Log(Name : String; const Fmt: string; const Args: array of const);
procedure LogError(const Format: string; const Args: array of const);
procedure LogMessage(const Format: string; const Args: array of const);
procedure DBError(E : Exception; const Fmt: string; const Args: array of const);
function  Substitute(S1, S2 : ShortString; Var Src : String) : String;
function  MakeDateStr : String;
function  MakeTimeStr : String;
function  MakeTimeStampStr : String;
procedure WriteInteger(Table : TTable; ID : String; Value : integer);
procedure WriteString(Table : TTable; ID : String; Value : string); overload;
procedure WriteDateTime(Table : TTable; ID : String; Value : double);
procedure WriteFloat(Table : TTable; ID : String; Value : double);
procedure WriteBool(Table : TTable; ID : String; Value : Boolean);
function ReadInteger(Table : TTable; ID : String; Default : integer) : integer;
function ReadString(Table : TTable; ID : String; Default : String) : string; overload;
function ReadDateTime(Table : TTable; ID : String; Default : double) : double;
function ReadFloat(Table : TTable; ID : String; Default : double) : double;
function ReadBool(Table : TTable; ID : String; Default : boolean) : Boolean;

function ReadInt(S : TStream) : integer;
function ReadString(S : TStream) : String; overload;
procedure WriteInt(S : TStream; i : integer);
procedure WriteString(S : TStream; C : String); overload;
function ReadUrl(URL : String; Timeout : integer = 300000) : String;
procedure WriteStringToFile(S : String; FileName : String);
function sendemail(ETo, EFrom, EServer, ESubject, EMessage : String) : boolean;

VAr MsgDlgWnd : TMsgDlgWnd;
implementation
uses  messages, windows, inifiles, winsock, syncobjs, shellapi, db, httpsend, idmessage;
const OFFSA = ord('A');

function sendemail(ETo, EFrom, EServer, ESubject, EMessage : String) : boolean;
Var IdMsgSend : TIdMessage;
    SMTP : TIDSMTP;
begin
   SMTP := TIDSMTP.Create(nil);
   IdMsgSend := TIdMessage.Create(nil);
   with IdMsgSend do
      begin
         Body.Add(Emessage);
         From.Text := EFrom;
         ReplyTo.EMailAddresses := EFrom;
         Recipients.EMailAddresses := eTo; { To: header }
         Subject := eSubject; { Subject: header }
      end;
   SMTP.AuthenticationType := atNone;
   SMTP.Host := EServer;
   SMTP.Port := 25;
   SMTP.Connect;
   try
      SMTP.Send(IdMsgSend);
   finally
      SMTP.Disconnect;
      SMTP.Free;
      IdMsgSend.Free;
   end;
end;


function ReadURL(URL : String; Timeout : integer) : String;
Var
    OK : boolean;
    HTTP : THTTPSend;
begin
  result := '';
  HTTP := THTTPSend.Create;
  try
    HTTP.TimeOut := TimeOut;
    OK := HTTP.HTTPMethod('GET', URL);
    if OK then
       begin
         Setlength(Result, HTTP.Document.Size);
         HTTP.Document.Read((@Result[1])^, HTTP.Document.Size);
       end
  finally
    HTTP.Free;
  end;
end;

procedure WriteStringToFile(S : String; FileName : String);
Var   F : TextFile;
begin
   assignfile(F, FileName);
   rewrite(F);
   writeln(F, S);
   Closefile(F);
end;
procedure FatalError(S : String);
begin
   MessageDlg('Error: ' + S);
   Forms.Application.Terminate;
end;

const LogName : ShortString = 'C:\Program.log';

function  IsIpAddress(s : string) : boolean;
Var i : integer;
begin
   Result := true;
   for i := 1 to length(S) do
     if not (S[i] in ['0'..'9', '.']) then
        begin
          result := false;
          exit;
        end;
end;

function ResolveNametoIP(Host : String) : string;
Var  HostEnt: PHostEnt;
     InAddr: TInAddr;
begin
  HostEnt := gethostbyname(PChar(Host));
  FillChar(InAddr, SizeOf(InAddr), 0);
  if HostEnt <> nil then
  begin
    with InAddr, HostEnt^ do
    begin
      S_un_b.s_b1 := h_addr^[0];
      S_un_b.s_b2 := h_addr^[1];
      S_un_b.s_b3 := h_addr^[2];
      S_un_b.s_b4 := h_addr^[3];
    end;
  end;
  Result := Strpas(Inet_ntoa(InAddr));
end;

function IsValidIP(Var IP : String) : boolean;
Var i : integer;
begin
   result := false;
   if Pos('10.', IP) = 1 then
     exit;
   if Pos('192.168.', IP) = 1 then
     exit;
   if Pos('127.0.', IP) = 1 then
     exit;
   if Pos('169.254.', IP) = 1 then
     exit;
   for i := 16 to 31 do
     if Pos('172.' + inttostr(i), IP) = 1 then
       exit;
   result := true;
end;

procedure GetLocalIPs(Var SL : TStringList; ValidOnly : boolean = false);
type Taddresslist = array[0..1000] of pchar;
     Paddresslist = ^Taddresslist;
Var he : phostent;
    AList : Paddresslist;
    i : integer;
    hostname : array[0..1000] of char;
    S : String;
    InAddr: TInAddr;
    AddrVal : dword;
begin
   SL.Clear;
{   gethostname(hostname, sizeof(hostname));
   strpcopy(hostname, 'localhost');}
   he := gethostbyname(nil{@hostname[0]});
   Alist := Paddresslist(he^.h_addr_list);
   i := 0;
   while Alist^[i] <> nil do
      begin
        with InAddr, HE^ do
        begin
          S_un_b.s_b1 := Alist^[i][0];
          S_un_b.s_b2 := Alist^[i][1];
          S_un_b.s_b3 := Alist^[i][2];
          S_un_b.s_b4 := Alist^[i][3];
          {AddrVal := (((S_un_b.s_b1*128)+S_un_b.s_b2)*128+S_un_b.s_b3)*128+
                        S_un_b.s_b4;}
        end;
        S := Strpas(Inet_ntoa(InAddr));
        if (not ValidOnly) or IsValidIp(S) then
            SL.add(S);
        inc(i);
      end;
end;

const Wnd : TMsgDlgWnd = nil;

procedure MessageDlg(S: String; Modal : boolean);
Var MsgDlgWnd: TMsgDlgWnd;
begin
  if not Modal then
    begin
       if Wnd = nil then
         Wnd := TMsgDlgWnd.Create(Application);
       MsgDlgWnd := Wnd;
    end
  else
       MsgDlgWnd := TMsgDlgWnd.Create(Application);
  MsgDlgWnd.YesBtn.Visible := false;
  MsgDlgWnd.NoBtn.Visible := false;
  MsgDlgWnd.OKBtn.Visible := true;
  MsgDlgWnd.DlgMemo.Lines.Clear;
  MsgDlgWnd.DlgMemo.Lines.Add(S);
  if Modal then
    begin
      MsgDlgWnd.ShowModal;
      MsgDlgWnd.Free;
    end
  else
    begin
      MsgDlgWnd.Visible := true;
      MsgDlgWnd.Show;
      MsgDlgWnd.BringToFront;
    end;
end;

function MessageDlgYesNo(S: String) : integer;
Var MsgDlgWnd: TMsgDlgWnd;
begin
  MsgDlgWnd := TMsgDlgWnd.Create(Application);
  MsgDlgWnd.YesBtn.Visible := true;
  MsgDlgWnd.NoBtn.Visible := true;
  MsgDlgWnd.OKBtn.Visible := false;
  MsgDlgWnd.DlgMemo.Lines.Clear;
  MsgDlgWnd.DlgMemo.Lines.Add(S);
  MsgDlgWnd.Caption := 'Question';
  MessageDlgYesNo := MsgDlgWnd.ShowModal;
  MsgDlgWnd.Free;
end;

{$R *.DFM}


const CDDrv : string = '';


function ValHexStr(S: String) : int64;
Var H, C, base, Lett : int64;
begin
   C := length(S);
   H := 0;
   Base := 1;
   while C>0 do
     begin
        Lett := ord(Upcase(S[C]));
        if (Lett >= ord('0')) and (Lett <= ord('9')) then
          Lett := Lett - ord('0')
        else
          Lett := 10 + Lett - Ord('A');
        H := H + Lett * base;
        dec(C);
        base := base * 16;
     end;
   Result := H;
end;

function HexStr(C : integer) : String;
const Hexvalues : string = '0123456789ABCDEF';
Var R : string;
    Ch : Char;
begin
   R := '';
   while (C > 0) do
     begin
       Ch := Hexvalues[1+ (C Mod 16)];
       R := Ch + R;
       C := C div 16;
     end;
   Result := R;
end;

function FindSwitch(const Switch: string): Boolean;
begin
  Result := FindCmdLineSwitch(Switch, ['-', '/'], True);
end;

function  GetRegServerAddress(Var Port : integer) : string;
Var F : TiniFile;
begin
  F := Tinifile.Create(GetHardRootDir1 + 'RegSrv.ini');
  Result := F.ReadString('RegSrv', 'Host', 'gameserver.game-club.com');
  Port := F.ReadInteger('RegSrv', 'Port', 2003);
  F.Free;
end;

function booltostr(b: boolean) : String;
begin
  if b then
    Result := 'true'
  else
    Result := 'false';
end;


procedure writeintstr(Var S : String; i : word);
begin
  S := S + chr((i and $f) + OFFSA) + chr(((i shr 4) and $f) + OFFSA) +
       chr(((i shr 8) and $f) + OFFSA) + chr(((i shr 12) and $f) + OFFSA);
end;

function readintstr(Var S : String) : word;
begin
  readintstr := ord(S[1]) - OFFSA + 16*(ord(S[2]) - OFFSA) + 256 * (ord(S[3]) - OFFSA) +
       4096 * (ord(S[4]) - OFFSA);
  delete(S, 1, 4);
end;

function Allocate(S: String) : pchar;
var P : Pchar;
begin
  if length(S) = 0 then
    begin
      Allocate := nil;
      exit;
    end;
  GetMem(P, length(S) + 1);
  StrPCopy(P, S);
  Allocate := P;
end;

procedure FileCopy(Src, Dest: String);
Var FS, FD : File;
    Buff: array[0..1023] of byte;
    nr, nw : integer;
begin
  AssignFile(FS, Src);
  AssignFile(FD, Dest);
  Rewrite(FD, 1);
  Reset(FS, 1);
  repeat
    blockread(FS, buff, sizeof(buff), nr);
    blockwrite(FD, buff, nr, nw);
  until (nr < sizeof(buff));
  closefile(FS);
  Closefile(FD);
end;


{$ifndef win32}
procedure SetLength(Var S: String; Length : byte);
begin
  S[0] := Char(Length);
end;
{$endif}
{$i-}

function GetFileName(Name: String) : string;
var S: String;
    i: integer;
begin
  S := '';
  i := length(Name);
  while (i > 0) and (Name[i] <> '\') and (Name[i] <> ':') do
    begin
      S := Name[i] + S;
      dec(i);
    end;
  GetFileName := S;
end;

function TheFileName1(Name: String) : String;
Var S : String;
    i : integer;
begin
  S := '';
  i := length(Name);
  while (Name[i] <> '.') and (i > 0) do
    dec(i);
  if i > 0 then
    dec(i);
  while i > 0 do
    begin
      S := Name[i] + S;
      dec(i);
      if Name[i] in ['\', '/', ':'] then
        break;
    end;
  TheFileName1 := S;
end;

function TheFileDir1(Name: String) : String;
Var S : String;
    i : integer;
begin
  i := length(Name);
  while (Name[i] <> '.') and (i > 0) do
    dec(i);
  if i > 0 then
    dec(i);
  Result := GetHardRootDir1;
  S := '';
  while i > 0 do
    begin
      dec(i);
      if Name[i] in ['\', '/', ':'] then
        begin
          S := copy(Name, 1, i);
          break;
        end;
    end;
  if length(S) > 0 then
     Result := S;
end;

function TheFullFileName(Name: String) : String;
Var S : String;
    i : integer;
begin
  S := '';
  i := length(Name);
  while (Name[i] <> '.') and (i > 0) do
    dec(i);
  if i > 0 then
    dec(i);
  while i > 0 do
    begin
      S := Name[i] + S;
      dec(i);
    end;
  TheFullFileName := S;
end;


function TheFileExt(Name: String) : String;
Var S : String;
    i : integer;
begin
  S := '';
  if pos('.', Name) = 0 then
    begin
      TheFileExt := '';
      exit;
    end;
  i := length(Name);
  while (i > 0) and (Name[i] <> '.') do
    begin
      S := Name[i] + S;
      dec(i);
    end;
  TheFileExt := Upstr(S);
end;

procedure fopen(Var f: textfile; S: String);
var i: integer;
begin
  {$i-}
  repeat
    assignfile(f, S);
    reset(f);
    i := ioresult;
    if i <> 0 then
       begin
         if MessageDlgYesNo(S + ':File not Found. Retry?') = MrNo then
           halt;
       end;
  until i = 0;
  {$i+}
end;

procedure fcreate(Var f: textfile; S: String);
var i: integer;
begin
  {$i-}
  repeat
    assignfile(f, S);
    rewrite(f);
    i := ioresult;
    if i <> 0 then
      if MessageDlgYesNo(S + ':Can not open File. Retry?') = mrNo then
          halt;
  until i = 0;
  {$i+}
end;

function GetRootDir : String;
Var RootDir : String;
begin
{$ifdef smaster}
  if ParamCount > 0 then
    RootDir := FindCD
{$else}
  if ParamCount > 1 then
    RootDir := ParamStr(2)
{$endif}
  else
    RootDir := GetHardRootDir;
  if RootDir = 'HDD' then
    RootDir := GetHardRootDir;
  GetRootDir := RootDir;
end;

function GetHardRootDir : String;
Var S: String;
begin
  S := paramstr(0);
  while S[length(S)] <> '\' do
    setlength(S, length(S) - 1);
  if (length(S) > 3) then
    setlength(S, length(S) - 1);
  GetHardRootDir := S;
end;

function GetHardRootDir1 : String;
Var S: String;
begin
  S := GetHardRootDir;
  if S[Length(S)] <> '\' then
    S := S + '\';
  GetHardRootDir1 := S;
end;

function ProfileDir : String;
begin
  ProfileDir := GetHardRootDir1 + 'Profiles\';
end;

procedure ChangeDirToRoot;
begin
  chdir(GetRootDir);
end;

function ReadStringFile1(Name : String) : String;
var SearchRec : TSearchRec;
    buffer : pchar;
    F : File;
    nr : integer;
begin
  Result := '';
  if FindFirst(Name, faAnyFile, SearchRec) = 0 then
    begin
      buffer := nil;
      try
        getmem(buffer, SearchRec.Size + 1);
        assign(F, Name);
        reset(F, 1);
        blockread(F, buffer^, SearchRec.Size, nr);
        closefile(F);
        buffer[nr] := #0;
        Result := strpas(buffer);
      finally
        freemem(buffer);
      end;
    end;
  SysUtils.FindClose(SearchRec);
end;

function FileExists(Name: String) : Boolean;
var SearchRec : TSearchRec;
begin
  if FindFirst(Name, faAnyFile, SearchRec) <> 0 then
    FileExists := false
  else
    FileExists := true;
  SysUtils.FindClose(SearchRec);
end;


function TheFileSize(Name: String) : integer;
var SearchRec : TSearchRec;
begin
  if FindFirst(Name, faAnyFile, SearchRec) = 0 then
    Result := SearchRec.Size
  else
    Result := 0;
  SysUtils.FindClose(SearchRec);
end;


function FileExists1(Name: String) : Boolean;
var F: file;
begin
  {$i-}
  assignfile(F, Name);
  reset(f, 1);
  if IOresult <> 0 then
    FileExists1 := false
  else
    begin
      FileExists1 := true;
      closefile(F);
    end;
{$i+}
end;

function UPStr(S: String) : String;
var R: String;
    i : Integer;
begin
  R := '';
  i := 1;
  while i <= length(S) do
    begin
      R := R + upcase(S[i]);
      inc(i);
    end;
  UPstr := R;
end;

function ValStr(S: String) : Longint;
var V : Longint;
    E : Integer;
begin
  if S = '' then
    ValStr := 0
  else
    begin
      Val(S, V, E);
      ValStr := V;
    end;
end;

function  ValStr64(S: String) : int64;
begin
  try
    Result := strtoint64(S);
  except on EConvertError do
    Result := 0;
  end;
end;

function  GetStr64(T : int64) : String;
begin
   Result := inttostr(T);
end;

procedure DeleteSpaces(Var S:String);
Var D: String;
    i: Integer;
begin
  D := '';
  for i := 1 to length(S) do
    if (S[i] <> ' ') and (S[i] <> #9) then
      D := D + UpCase(S[i]);
  S := D;
end;

function  FindLine(Var F: TextFile; S: String) : String;
var S1: String;
    P : Integer;
begin
   S := UpStr(S);
   repeat
     readln(F, S1);
     S1 := UpStr(S1);
     if pos(S, S1) <> 0  then
        begin
          P := Pos('=', S1);
          Delete(S1, 1, P);
          FindLine := S1;
          exit;
        end;
   until eof(f);
   FindLine := '';
end;

function GetStr(T : longint) : String;
var S : String;
begin
  Str(T, S);
  GetStr := S;
end;

function FirstWord(Var S: String):String;
Var P : integer;
begin
  P := pos(',', S);
  if (P = 0) then
    begin
      FirstWord := S;
      S := ''
    end
  else
    begin
      FirstWord := Copy(S, 1, P - 1);
      Delete(S, 1, P);
    end;
end;

function GetID(var S: String) : Integer;
Var ss : string;
    res, err, i : integer;
begin
  ss := '';
  i := 2;
  while S[i] <> ']' do
    begin
      ss := ss + S[i];
      inc(i);
    end;
  val(ss, res, err);
  if err <> 0 then
    GetID := 0
  else
    GetID := res;
end;

function TheTime : integer;
Var ST : TSystemTime;
    T : integer;
begin
   GetLocalTime(ST);
   T := longint(ST.wHour) * 3600000 + longint(ST.wMinute) * 60000 + longint(ST.Wsecond) * 1000 + longint(ST.Wmilliseconds);
   TheTime := T;
end;

function DateTimeToTime(D : TDateTime) : integer;
Var h, m, s, ms : word;
begin
   DecodeTime(D, h, m, s, ms);
   Result := longint(h) * 3600000 + longint(M) * 60000 + longint(s) * 1000 + longint(ms);
end;

Function str2(i:integer):string;
Var s:string;
Begin
  str(i,s);
  if length(s)<2 then
    str2:='0'+s
  else
    str2:=s;
End;

Function str3(i:integer):string;
Var s:string;
Begin
  str(i,s);
  if length(s)<3 then
    str3:='0'+s
  else
    str3:=s;
End;


Function str4(i:integer):string;
Var s:string;
Begin
  str(i,s);
  while length(s)<4 do
    s:='0'+s;
  str4:=s;
End;

function TimeStr(Time : integer) : String;
Var H, M : integer;
begin
  H := Time div 3600000;
  M := (Time - H * 3600000) div 60000;
  TimeStr := Str2(H) + ':' + Str2(M);
end;

function TimeStr3(Time : integer) : String;
Var H, M, Sec : integer;
begin
  H := Time div 3600000;
  M := (Time - H * 3600000) div 60000;
  Sec := (Time - H * 3600000 - M * 60000) div 1000;
  TimeStr3 := Str2(H) + ':' + Str2(M) + ':' + Str2(Sec);
end;

function ParseTime(S : ShortString) : integer;
var HH, MM : String[20];
    H,M : integer;
    Hour : integer;
    Ptr : integer;
begin
  HH := '';
  MM[1] := #0;
  MM[2] := #0;
  MM[3] := #0;
  MM := '';
  Hour := 1;
  Ptr := 1;
  while (Ptr <= length(S)) do
    begin
      if Hour <= 2 then
        HH := HH + S[Ptr];
      if Hour >= 4  then
        MM := MM + S[Ptr];
      if Hour >= 5 then
        break;
      inc(Ptr);
      inc(Hour);
    end;
  try
    H := strtoint(HH);
  except on EConvertError do
    H := 0;
  end;
  try
    M := strtoint(MM);
  except on EConvertError do
    M :=0;
  end;
  ParseTime := H * 60 + M;
end;

function MakeTime(S : String) : integer;
Var Time : integer;
begin
   Time := ParseTime(S) * 60000;
   MakeTime := Time;
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

function GetExeVersion1: String;
var
  FileName: string;
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
begin
    Result := '0';
    FileName := ParamStr(0) + #0;
    InfoSize := GetFileVersionInfoSize(@FileName[1], Wnd);
    if InfoSize <> 0 then
    begin
      GetMem(VerBuf, InfoSize);
      try
        if GetFileVersionInfo(@FileName[1], Wnd, InfoSize, VerBuf) then
          if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
            Result := GetStr((FI.dwProductVersionMS and (65535 shl 16)) shr 16) + '.' +
                      GetStr(FI.dwProductVersionMS and 65535) + '.' +
                      GetStr((FI.dwProductVersionLS and (65535 shl 16)) shr 16) + '.' +
                      GetStr(FI.dwProductVersionLS and 65535);
      finally
        FreeMem(VerBuf);
      end;
    end;
end;

const ExeVersion_ : string = '';
function GetExeVersion: String;
begin
  if ExeVersion_ = '' then
    ExeVersion_ := GetExeVersion1;
  Result := ExeVersion_;
end;

function GetOconnectVersion : integer;
var
  FileName: string;
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
begin
    Result := 0;
    FileName := ParamStr(0) + #0;
    InfoSize := GetFileVersionInfoSize(@FileName[1], Wnd);
    if InfoSize <> 0 then
    begin
      GetMem(VerBuf, InfoSize);
      try
        if GetFileVersionInfo(@FileName[1], Wnd, InfoSize, VerBuf) then
          if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
            Result := (FI.dwProductVersionMS and (65535 shl 16)) shr 16;
      finally
        FreeMem(VerBuf);
      end;
    end;
end;

{$ifdef BSock}
function ReadLine1(Var S : String; SocketStream: TWinSocketStream; Var PartialLine : string; Var TotalRead : integer) : boolean;
Var  RecvText: array[0..2048] of char;
     LineIn, newline : String;
     el, Sizeread, i : integer;
begin
   el := Pos(#13+#10, PartialLine);
   if el<>0 then
     begin
        newline := Copy(PartialLine, 1, el - 1);
        Delete(PartialLine, 1, el + 1);
        inc(TotalRead, el + 1);
        Readline1 := true;
        S := newline;
        exit;
     end;
   SizeRead := SocketStream.Read(RecvText, 2048);
   for i := 1 to SizeRead - 1 do
     if RecvText[i] = #0 then
       RecvText[i] := ' ';
   RecvText[SizeRead] := #0;
   if SizeRead = 0 then
     begin
      // If we didn't get any data after 600 seconds then close the connection
      ReadLine1 := false;
      exit;
     end;
   linein := StrPas(RecvText);
   linein := PartialLine + linein;
   el := Pos(#13+#10, linein);
   if el<>0 then
     begin
        newline:=Copy(linein, 1, el-1);
        Delete(linein, 1, el+1);
        inc(TotalRead, el + 1);
        S := newline;
        Readline1 := true;
        PartialLine := linein;
     end
   else
     begin
       PartialLine := linein;
       Result := ReadLine(S, SocketStream, PartialLine);
     end;
end;

function ReadLine(Var S : String; SocketStream: TWinSocketStream; Var PartialLine : string) : boolean;
Var TotalRead : integer;
begin
  TotalRead := 0;
  Result := ReadLine1(S, SocketStream, PartialLine, TotalRead);
end;

{$endif}

function  FindCD : string;
Var Fname, S, S1, CDVer, CDVer1 : string;
    buffer : array[0..2048] of char;
    i : integer;
    F : TiniFile;
begin
 if CDDrv <> '' then
     begin
       FindCD := CDDrv;
       exit;
     end;
 if (paramcount > 0) and (ParamStr(1) <> '') then
   begin
     CDDrv := ParamStr(1);
     if CDDrv[length(CDDrv)] <> '\' then
        CDDrv := CDDrv + '\';
     FindCD := CDDrv;
     exit;
   end;
 FName := 'SMVER.INI';
 S := GetHardRootDir1 + FName;
 if not FileExists(S) then
    begin
      MessageDlg('File not found ' + S);
      FindCD := '';
      exit;
    end;
 F := TiniFile.Create(S);
 CDVer := Upstr(F.ReadString('StoneMaster', 'SMVersion', '0'));
 F.Free;
 if CDVer = 'HDD' then
   begin
     CDDrv  := GetHardRootDir1;
     FindCD := CDDrv;
     exit;
   end;
 GetLogicalDriveStrings(sizeof(buffer), buffer);
 i := 0;
 while true do
   begin
      if buffer[i] = #0 then
         break;
      S := '';
      while buffer[i] <> #0 do
        begin
          S := S + buffer[i];
          inc(i);
        end;
      inc(i);
      S1 := S + #0;
      if GetDriveType(@S1[1]) = DRIVE_CDROM then
        if FileExists(S + FName) then
          begin
             F := TiniFile.Create(S + FName);
             CDVer1 := Upstr(F.ReadString('StoneMaster', 'SMVersion', '0'));
             F.Free;
             if CDVer1 = CDVer then
               begin
                 FindCD := S;
                 CDDrv := S;
                 exit;
               end;
          end;
   end;
 FindCD := '';
end;

procedure MkDirEx(FilePath : String);
var i : integer;
    Dir : String;
begin
   if FilePath[length(FilePath)] = '\' then
     setlength(FilePath, length(FilePath) -1);
   Dir := '';
   i := 0;
   while Dir <> FilePath do
     begin
       inc(i);
       if FilePath[i] <> '\' then
         Dir := Dir + FilePath[i]
       else
         begin
           if not FileExists(Dir + '\*.*') then
             MkDir(Dir);
           Dir := Dir + '\';
         end;
     end;
   if not FileExists(Dir) then
     MkDir(Dir);
end;

Var CSLog : TCriticalSection;
const Started : boolean = false;
procedure WriteLog(Msg : string; errcode : dword);
Var F : Text;
    P : integer;
begin
{$ifdef logging}
  if not Started then
     begin
        Started := true;
        WriteLog('Application Started ' + DatetimeToStr(now), 0);
     end;
  CSLog.Enter;
  try
  P := pos(#$D, Msg);
  while P <> 0 do
    begin
      Msg[P] := ' ';
      P := pos(#$D, Msg);
    end;
  P := pos(#$A, Msg);
  while P <> 0 do
    begin
      Msg[P] := ' ';
      P := pos(#$A, Msg);
    end;
  assignfile(F, LogName);
  {$i-}
  append(F);
  if ioresult <> 0 then
    rewrite(F);
  {$i+}
  if ErrCode <> 0 then
    writeln(F, datetimetostr(now) + '  ' + Msg + ' Error Code= ' + inttostr(Errcode))
  else
    writeln(F, datetimetostr(now) + '  ' + Msg);
  closefile(F);
  finally
    CSLog.Leave;
  end;
{$endif}
end;

{$o-}
function NanoTime : int64;
var Res : TLargeInteger;
begin
  if QueryPerformanceCounter(Res) then
    Result := res
  else
    Result := 0;
end;

function NanoFrequency : int64;
Var Res : int64;
begin
  if QueryPerformanceFrequency(res) then
    Result := res
  else
    Result := 1;
end;
{$o+}

procedure Runhelp(i : integer);
Var S, T : String;
    F : TInifile;
begin
  S := GetHardRootDir1 + 'help' + '.ini';
  if not FileExists(S) then
    begin
      MessageDlg('File nof found ' + S);
      exit;
    end;
  F := TIniFile.Create(S);
  T := F.ReadString('Help', 'Section' + inttostr(i), '');
  if T = '' then
    begin
      MessageDlg('The Help Section' + inttostr(i) + ' not found in the file ' + S);
      exit;
    end;
  F.Free;
//  T := 'start '+ T;
  ShellExecute(0, 'open', PChar(T), nil, nil, SW_SHOWNORMAL);
end;

function AdjustToken(TokenHandle: THandle; DisableAllPrivileges: BOOL;
                    const NewState: TTokenPrivileges; BufferLength: DWORD;
                    PreviousState: PTokenPrivileges; var ReturnLength: DWORD): BOOL; stdcall;
begin
   AdjustToken := Windows.AdjustTokenPrivileges(TokenHandle, DisableAllPrivileges,
               NewState, BufferLength, PreviousState^, ReturnLength);
end;

procedure RebootWindows;
Var hToken : THandle;
    tkp : TTokenPrivileges;
    PrevST : PTokenPrivileges;
    Ret : DWORD;
    Err : integer;
    Res : boolean;
begin
if not OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken) then
   exit;
LookupPrivilegeValue(nil, 'SeShutdownPrivilege', tkp.Privileges[0].Luid);
tkp.PrivilegeCount := 1;  // one privilege to set
tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
// Get the shutdown privilege for this process.
Ret := 0;
PrevST := nil;
AdjustToken(hToken, FALSE, tkp, 0,  PrevST, Ret);
// Cannot test the return value of AdjustTokenPrivileges.
Err := GetLastError;
if (Err <> ERROR_SUCCESS) then
   exit;
// Shut down the system and force all applications to close.
if (not ExitWindowsEx(EWX_REBOOT or EWX_FORCE{ or $10 - win2000 only}, 0)) then
   exit;
end;

//function GetExtendedErrorCode : integer; external;
//function GetSystemMaxThreadCount : integer; external;

{function  GetLastError1 : integer;
Var S : integer;
begin
  Result := GetExtendedErrorCode;
end;}

{function  GetThreadCount : integer;
begin
  Result := GetSystemMaxThreadCount;
end;}

const TAB = #9;
function ScanStr(Var Dest : String; Var Src : String; pos : integer) : integer;
Var D : ShortString;
begin
  D := '';
  while (pos <= length(Src)) and ((Src[pos] = ' ') or (Src[Pos] = TAB)) do
    inc(pos);
  while (pos <= length(Src)) and ((Src[pos] <> ' ') and (Src[Pos] <> TAB)) do
    begin
      D := D + Src[pos];
      inc(pos);
    end;
  Dest := D;
  result := Pos;
end;

procedure FillGrid(Grid : TStringGrid; List : TStringList);
Var i : integer;
begin
   if Grid.RowCount < List.Count then
     Grid.RowCount := List.Count + 1;
   for i := 0 to List.Count - 1 do
     Grid.Cells[0, i] := List.Strings[i];
   for i := List.Count to Grid.RowCount do
     Grid.Cells[0, i] := ''; 
end;

procedure ExtractGrid(List: TStringList; Grid : TStringGrid);
Var i : integer;
begin
   List.Clear;
   for i := 0 to Grid.RowCount - 1 do
     if Grid.Cells[0, i] <> '' then
       List.Add(Grid.Cells[0, i]);
end;

function MakeComma(S : String) : String;
begin
  if (length(S) > 0) and (S[1] = '"') and (S[length(S)] <> ',') then
    S := S + ',';
  Result := S;
end;

function ParseStr(Var S : String; Var P : integer; Term : char) : string;
Var pp : integer;
begin
  pp := p;
  while (p <= length(S)) and (S[p] <> Term) do
    inc(p);
  Result := copy(S, pp, P-pp);
  inc(P);
end;

function CorrectStrToDate(S : String) : Double;
Var P, Month, Day, Year : integer;
begin
   P := 1;
   Month := ValStr(ParseStr(S, P, '\'));
   Day := ValStr(ParseStr(S, P, '\'));
   Year := ValStr(ParseStr(S, P, #0));
   if Year < 100 then
     Year := Year + 2000;
   Result := EncodeDate(Year, Month, Day);
end;


function ParseCSVStr(Var S : String; Var P : integer) : String;
Var i, ii : integer;
begin
   i := p;
   while (i <= length(S)) and ((S[i] = ' ') or (S[i] = TAB)) do
     inc(i);
   while (i <= length(S)) and (S[i] <> ',') do
     inc(i);
   ii := i;
   while (ii <= length(S)) and ((S[ii] = ' ') or (S[ii] = TAB)) do
     dec(ii);
   if ii > p then
      Result := Copy(S, p, ii-p)
   else
      Result := '';
   P := i + 1;
end;

function ReadCSVFile(Name : string) : TStringList;
Var Res : TStringList;
    F : TextFile;
    S : String;
    P : integer;
begin
   Res := TStringList.Create;
   AssignFile(F, Name);
   Reset(F);
   try
   while not eof(F) do
      begin
        Readln(F, S);
        P := 1;
        while P < length(S) do
          Res.Add(ParseCSVStr(S, P));
      end;
   finally
     CloseFile(F);
   end;
   Result := Res;
end;

function Memcompare(Var Src; Var Dest; Size : integer) : boolean;
asm
{     ->EAX     Pointer to source       }
{       EDX     Pointer to destination  }
{       ECX     Count                   }
        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX
        MOV     EDI,EDX

        MOV     EAX,ECX

        CMP     EDI,ESI
        JA      @@down
        JE      @@exit

        SAR     ECX,2           { copy count DIV 4 dwords       }
        JS      @@exit
        CLD
        CMP     EAX,EAX
        REPE    CMPSD
        JNE     @@not_equal

        MOV     ECX,EAX
        AND     ECX,03H
        CMP     EAX,EAX
        REPE    CMPSB           { copy count MOD 4 bytes        }
        JNE     @@not_equal
        JMP     @@exit

@@down:
        LEA     ESI,[ESI+ECX-4] { point ESI to last dword of source     }
        LEA     EDI,[EDI+ECX-4] { point EDI to last dword of dest       }

        SAR     ECX,2           { copy count DIV 4 dwords       }
        JS      @@exit
        STD
        CMP     EAX,EAX
        REPE     CMPSD
        JNE     @@not_equal1

        MOV     ECX,EAX
        AND     ECX,03H         { copy count MOD 4 bytes        }
        ADD     ESI,4-1         { point to last byte of rest    }
        ADD     EDI,4-1
        CMP     EAX,EAX
        REPE    CMPSB
        JNE     @@not_equal1
        CLD
        JMP     @@exit
@@not_equal1:
        CLD
@@not_equal:
        MOV     EAX, 0
        jmp     @@exit1
@@exit:
        MOV     EAX, 1
@@exit1:
        POP     EDI
        POP     ESI
end;

function FileTimeToDateTime(Var F : TFileTime) : double;
Var S : TSystemTime;
begin
   FileTimeToSystemTime(F, S);
   Result := SystemTimeToDateTime(S);
end;

function DateTimeToFileTime(T : Double) : TFileTime;
Var S : TSystemTime;
begin
   DateTimeToSystemTime(T, S);
   SystemTimeToFileTime(S, Result);
end;

procedure OpenUrl(URL : string);
Var CMD : string;
begin
   CMD := 'start "' + url + '"'+#0;
   ShellExecute(0, 'open', PChar(Url), '', '', SW_SHOWNORMAL);
end;

function MakeLogName(Name : String; Time : double) : String;
begin
   Result := GetHardRootDir1 + Name + formatdatetime('yymmdd', Time) + '.LOG';
end;

const LogPrevday : integer = 0;
procedure Log(Name : String; const Fmt: string; const Args: array of const);
Var F : TextFile;
    i : integer;
    S : String;
begin
  CSLog.Enter;
  try
  if trunc(now) <> Logprevday then
     begin
       for i := 7 to 45 do
          if FileExists(MakeLogName(Name, now-i)) then
              Sysutils.deletefile(MakeLogName(Name, now-i));
     end;
  Logprevday := trunc(now);
  S := formatdatetime('yy/mm/dd hh:nn:ss ', now) + Format(Fmt, Args);
  assignfile(F, MakeLogName(Name, now));
  {$i-}
  append(F);
  if ioresult <> 0 then
    rewrite(F);
  {$i+}
  writeln(F, S);
  closefile(F);
  finally
    CSLog.Leave;
  end;
end;

procedure LogError(const Format: string; const Args: array of const);
begin
  Log('Error', Format, Args);
end;
procedure LogMessage(const Format: string; const Args: array of const);
begin
  Log('Message', Format, Args);
end;
procedure DBError(E : Exception; const Fmt: string; const Args: array of const);
Var i : integer;
    S : String;
begin
   S := Format(Fmt, Args) + ' ' + E.Message;
{   for i := 0 to E.ErrorCount-1 do
     S := S + '; C:' + inttostr(E.Errors[i].ErrorCode) + ' M:' + E.Errors[i].Message;}
   Log('DBError', S, []);
end;

function Substitute(S1, S2 : ShortString; Var Src : String) : String;
Var P : integer;
begin
   Result := Src;
   while true do
     begin
        p := pos(S1, Result);
        if p = 0 then
           break;
        delete(Result, P, length(S1));
        if S2 <> '' then
          Insert(S2, Result, P);
     end;
end;

function MakeDateStr : String;
begin
  Result := formatdatetime('mm/dd/yyyy', now);
end;

function MakeTimeStr : String;
begin
  Result := formatdatetime('hh:nn:ss', now);
end;

function MakeTimeStampStr : String;
begin
  Result := formatdatetime('yyyymmddhhnnss', now);
end;

Var WSData : WSaData;
procedure TMsgDlgWnd.OKBtnClick(Sender: TObject);
begin
  Visible := false;
end;

procedure WriteInteger(Table : TTable; ID : String; Value : integer);
begin
   Table.FieldByName(ID).AsInteger := Value;
end;
procedure WriteString(Table : TTable; ID : String; Value : string);
begin
   Table.FieldByName(ID).AsString := Value;
end;
procedure WriteDateTime(Table : TTable; ID : String; Value : double);
begin
   Table.FieldByName(ID).AsDateTime := Value;
end;
procedure WriteFloat(Table : TTable; ID : String; Value : double);
begin
   Table.FieldByName(ID).AsFloat := Value;
end;
procedure WriteBool(Table : TTable; ID : String; Value : Boolean);
begin
   Table.FieldByName(ID).AsBoolean := Value;
end;
function ReadInteger(Table : TTable; ID : String; Default : integer) : integer;
begin
   try
     Result := Table.FieldByName(ID).AsInteger;
   except on E: EDatabaseError do
     begin
       DBError(E, Table.Name + ' ReadInteger: ' + ID, []);
       Result := Default;
     end
   end;
end;
function ReadString(Table : TTable; ID : String; Default : String) : string;
begin
   try
     Result := Table.FieldByName(ID).AsString ;
   except on E: EDatabaseError do
     begin
       DBError(E, Table.Name + ' ReadString: ' + ID, []);
       Result := Default;
     end
   end;
   if Result = '' then
     Result := Default;
end;
function ReadDateTime(Table : TTable; ID : String; Default : double) : double;
begin
   try
     Result := Table.FieldByName(ID).AsDateTime ;
   except on E: EDatabaseError do
     begin
       DBError(E, Table.Name + ' ReadDateTime: ' + ID, []);
       Result := Default;
     end
   end;
end;
function ReadFloat(Table : TTable; ID : String; Default : double) : double;
begin
   try
     Result := Table.FieldByName(ID).AsFloat ;
   except on E: EDatabaseError do
     begin
       DBError(E, Table.Name + ' ReadDateTime: ' + ID, []);
       Result := Default;
     end
   end;
end;
function ReadBool(Table : TTable; ID : String; Default : boolean) : Boolean;
begin
   try
     Result := Table.FieldByName(ID).AsBoolean;
   except on E: EDatabaseError do
     begin
       DBError(E, Table.Name + ' ReadBool: ' + ID, []);
       Result := Default;
     end
   end;
end;

function ReadInt(S : TStream) : integer;
begin
   S.Read((@Result)^, 4);
end;

function ReadString(S : TStream) : String;
Var P : PChar;
    Len : integer;
begin
   Len := REadInt(S);
   if Len = 0 then
     begin
       Result := '';
       exit;
     end;
   getmem(P, Len+1);
   S.REad(P^, Len);
   P[Len] := #0;
   Result := String(P);
   freemem(P);
end;

procedure WriteInt(S : TStream; i : integer);
begin
   S.Write(i, 4);
end;

procedure WriteString(S : TStream; C : String);
begin
  WriteInt(S, length(C));
  if length(C) > 0 then
     S.Write((@C[1])^, length(C));
end;


initialization
begin
  WSAStartup(2, WSData);
  LogName := GetHardrootdir1 + Application.Title + '_V_' + GetExeVersion + '.log';
  CSLog := TCriticalSection.Create;
end;

finalization
begin
  CSLog.Free;
end;
end.

