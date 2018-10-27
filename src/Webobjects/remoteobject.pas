unit remoteobject;
interface

uses
  SysUtils, Stree,  IdHTTPServer, Syncobjs, webobject, IdCustomHTTPServer,
  ZipObject, CityObject, StripObject;


type TRemoteObject = class(TStripObject)
  public
// persistent data
    procedure HandleCommand(UnparsedParams : String;
                            Var ResponseInfo: String; Var ContentType : String); override;
    function  ProcessQuery(Request : String; AppendEOL : boolean; Var ContentType : String; AppendCommand : boolean; commstr : string = '') : String; override;
    destructor Free; override;
    procedure Init(Oldobject: TWebObject = nil); override;
  end;

implementation
uses parser, math, IDUri, streetobject, HTTPSEND;

destructor TRemoteObject.Free;
begin
end;

procedure TRemoteObject.Init(Oldobject: TWebObject = nil);
begin
end;

procedure TRemoteObject.HandleCommand(UnparsedParams : String;
      Var ResponseInfo: String; Var ContentType : String);
Var CType : String;
begin
  ResponseInfo := ProcessQuery(UnparsedParams, false, CType, false);
  ContentType := 'text/plain';
end;

function  TRemoteObject.ProcessQuery(Request : String; AppendEOL : boolean; Var ContentType : String; AppendCommand : boolean; commstr : string = '') : String;
Var  HTTP: THTTPSend;
     URL : String;
     OK : boolean;
     tries : integer;
begin
  HTTP := THTTPSend.Create;
  try
    if pos('rrequest', command) = 1 then
      URL := Dir1 + 'request' + '?' + Request
    else
      URL := Dir1 + Command + '?' + Request;
    if AppendCommand then
      URL := URL + '&appendcommand=1';
    if AppendEol then
      URL := URL + '&appendeol=1';
    tries := 0;
    repeat
       OK := HTTP.HTTPMethod('GET', URL);
       inc(tries);
       if not OK then
         sleep(10);
    until OK or (tries > 10);
    if OK then
       begin
         Setlength(Result, HTTP.Document.Size);
         HTTP.Document.Read((@Result[1])^, HTTP.Document.Size);
       end
    else
       Result := 'Error accessing the host: ' + URL +#13+#10;
    ContentType := 'text/plain';
  finally
    HTTP.Free;
  end;
end;

end.
