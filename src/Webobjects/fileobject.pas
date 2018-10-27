{
Implements the help? command
}

unit fileobject;
interface

uses
  SysUtils, Stree,  IdHTTPServer, Syncobjs, webobject, IdCustomHTTPServer,
  ZipObject, CityObject, StripObject;


type TFileObject = class(TWebObject)
  public
// persistent data
    CSWork : TCriticalSection;
    destructor Free;  override;
    procedure Init(Oldobject: TWebObject = nil); override;
    procedure HandleCommand(UnparsedParams : String;
                            Var ResponseInfo: String; Var ContentType : String); override;
  end;

implementation
uses parser, math;

procedure THelpObject.Init;
begin
   CSWork := TCriticalSection.Create;
end;

destructor THelpObject.Free;
begin
   CSWork.Free;
end;

procedure THelpObject.HandleCommand(
      UnparsedParams : String;
      Var ResponseInfo: String; Var ContentType : String);
Var Res : String;
begin
   try
       ReadStringFile(GetHardRootDir1 + 'Help.htm', Res);
       ResponseInfo := Res;
   except on E: exception do
      begin
//         Interf.EnableLog;
         Interf.AddLog('Request: ' + UnparsedParams + ' Exception: ' + E.Message);
         AppendFile(Dir1+'Error.LOG', 'Request: ' + UnparsedParams + ' Exception: ' + E.Message);
         ResponseInfo := 'END. Internal Error. Please report to shaposhn@cs.fiu.edu';
      end;
   end;
end;

end.
