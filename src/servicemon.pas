unit servicemon;
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ExtCtrls, IdBaseComponent,
  IdComponent, IdTCPServer, IdCustomHTTPServer, IdHTTPServer, Syncobjs,
  IdIOHandlerSocket, IdThreadMgr, IdThreadMgrPool, stringqueue, IdIOHandler,
  IdIOHandlerThrottle, IniFiles, Mask, DB, IdTCPConnection,
  IdTCPClient, IdHTTP, parser;

type
TWebInterf = class(TForm)
    Memo1: TMemo;
    Timer1: TTimer;
    HTTPServer: TIdHTTPServer;
    IdThreadMgrPool1: TIdThreadMgrPool;
    Panel1: TPanel;
    Status1: TLabel;
    StripObjects: TListBox;
    Timer2: TTimer;
    IdHTTP1: TIdHTTP;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);

  public
    Queue : TStrQueue;
    URLS, Hosts : TStringList;
    HostActive : array[0..10] of boolean;
    HostFailed : array[0..10] of boolean;
    LogFile : String;
    procedure SetStatus(Status : String);
    procedure AddLog(S : String);
    procedure EnableLog1;
    procedure ReadIniFile;
    function  RunClusterCommand(Peer, Command : string) : boolean;
    function  CheckHost(host : integer) : boolean;
    procedure ActivateHost(i : integer; active : boolean);
    procedure  CheckCluster;
    { Public declarations }
  end;


var
  WebInterf: TWebInterf;

implementation
uses threadpool, myutil1, shellapi;
{$R *.DFM}


procedure TWebInterf.ReadIniFile;
var f : tmeminifile;
   i : integer;
   host, Url : string;
begin
   F := TMeminiFile.create(GetHardRootdir1 + 'servmon.ini');
   URLS := TStringList.Create;
   HOSTS := TStringList.Create;
   try
      i := 1;
      while true do
        begin
          URL := F.ReadString('URL'+inttostr(i), 'URL', '');
          if URL = '' then
             break;
          URLS.Add(URL);
          inc(i);
        end;
      i := 1;
      while true do
        begin
          HOST := F.ReadString('HOST'+inttostr(i), 'HOST', '');
          if HOST = '' then
             break;
          HOSTS.Add(HOST);
          inc(i);
        end;
   finally
     F.free;
   end;
end;



procedure TWebInterf.FormCreate(Sender: TObject);
Var DummyAr : array of byte;
    F :TMeminiFile;
    i : integer;
begin
//   setlength(DummyAr, integer(65536)*32767 div 2);
//   DummyAr := nil;
//   LogFile := GetHardRootDir1 + 'LogFile.log';
//   LogToFile := true;
   LogFile := GetHardRootDir1 + 'LogFile.log';
   ReadInifile;
   Queue := TStrQueue.Create;
   timer1.enabled := true;
   timer2.enabled := true;
   SetStatus('Running');
   for i := 0 to HOSTS.Count - 1 do
      HostFailed[i] := false;
   ithreadpool.Enqueue(CheckCluster);
end;

procedure TWebInterf.SetStatus(Status : String);
Var e : boolean;
begin
   e := Queue.Enabled;
   Queue.Enabled := true;
   AddLog(Status);
   Queue.Enabled := E;
end;

procedure TWebInterf.AddLog(S : String);
begin
   Queue.Append(FormatDateTime('yyyy/mm/dd hh:nn:ss.zzz> ', now) + S + '  Nanostamp:' + inttostr(NanoTime));
end;

procedure TWebInterf.EnableLog1;
begin
   Queue.Enabled := true;
end;


procedure TWebInterf.Timer1Timer(Sender: TObject);
Var S : String;
begin
   while Queue.Fetch(S) do
     begin
        memo1.Lines.Add(S);
//        AppendFile(GetHardRootDir1+'Error.LOG', S);
     end;
end;

function  TWebInterf.CheckHost(host : integer) : boolean;
Var i : integer;
    LogStr, Res : string;
begin
    for i := 0 to URLS.count - 1 do
      begin
        Res := ReadUrl('http://' + Hosts.Strings[host] + URLS.Strings[i], 5000);
        if Res = '' then
           begin
              result := false;
              if not HostFailed[Host] then
                begin
                   LogStr := 'Host failed: ' + Hosts.Strings[host] + ' ' + 'http://' + Hosts.Strings[host] + URLS.Strings[i];
                   SetStatus(LogStr);
                   //SendEmail('jball008@cs.fiu.edu', 'jball008@cs.fiu.edu', 'smtp.cs.fiu.edu', Hosts.Strings[host] + ' failed', 'http://' + Hosts.Strings[host] + URLS.Strings[i]);
                   SendEmail('wanghuibo100120@gmail.com', 'wanghuibo100120@gmail.com', 'smtp.cs.fiu.edu', Hosts.Strings[host] + ' failed', 'http://' + Hosts.Strings[host] + URLS.Strings[i]);
                   AppendFile(LogFile, FormatDateTime('yyyy/mm/dd hh:nn:ss.zzz> ', now) + LogStr);
                end;
              HostFailed[Host] := true;
              exit;
           end;
      end;
    result := true;
    if HostFailed[Host] then
      begin
         HostFailed[Host] := false;
         LogStr := 'Host OK: ' + Hosts.Strings[host];
         SetStatus(LogStr);
         //SendEmail('jball008@cs.fiu.edu', 'jball008@cs.fiu.edu', 'smtp.cs.fiu.edu', Hosts.Strings[host] + ' OK', '');
         SendEmail('wanghuibo100120@gmail.com', 'wanghuibo100120@gmail.com', 'smtp.cs.fiu.edu', Hosts.Strings[host] + ' OK', '');

         AppendFile(LogFile, FormatDateTime('yyyy/mm/dd hh:nn:ss.zzz> ', now) + LogStr);
      end;
end;

procedure TWebInterf.ActivateHost(i : integer; active : boolean);
begin
   if active then
     HostActive[i] := RunClusterCommand(Hosts.Strings[i], 'start')
   else
     HostActive[i] := RunClusterCommand(Hosts.Strings[i], 'stop');
end;

const checkDelay : integer = 1;
const firstRun : boolean = true;
const inCheck : boolean = false;
const CSGlobal : TCriticalSection = nil;

procedure TWebInterf.CheckCluster;
Var i : integer;
begin
   if InCheck then
      exit;
   CsGlobal.Enter;
   try
   InCheck := true;
   dec(CheckDelay);
   if (CheckDelay <= 0) then
   begin
      for i := 0 to HOSTS.Count - 1 do
         HostActive[i] := RunClusterCommand(Hosts.Strings[i], 'query');
      CheckDelay := 10;
      firstRun := false;
   end;

   for i := 0 to HOSTS.Count - 1 do
     if CheckHost(i) then
       begin
         if not HostActive[i] then
            ActivateHost(i, true);
       end
     else
       if HostActive[i] then
          ActivateHost(i, false);
     finally
       InCheck := false;
       CsGlobal.Leave;
     end;
end;

procedure TWebInterf.Timer2Timer(Sender: TObject);
Var I : integer;
    PrevPeerState, Res : String;
begin
  ithreadpool.Enqueue(CheckCluster);
end;

function  TWebInterf.RunClusterCommand(Peer, Command : string) : boolean;
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
       result := true
    else if pos('started', S) <> 0 then
       result := true
    else if pos('stopped', S) <> 0 then
       result := false
    else
       result := false;
    if (Command <> 'query') or firstRun then
       SetStatus(S);
    closefile(f);
    filemode := fm;
end;

begin
  CSGlobal := TCriticalSection.Create;
end.
