{Implements the composite query command

query?

query?category=name1&category=name2...

This command allows you to retrieve multiple queries 2-12 in a single HTTP request. 

Example:  http://n158.cs.fiu.edu/query?category=zip&category=incorp&category=county&x1=-121.97306&y1=37.79139&x2=-121.98306&y2=38.89139 

If category= is omitted, all available queries will be returned.
}


unit categoryobject;
interface

uses
  SysUtils, Stree,  IdHTTPServer, Syncobjs, webobject, IdCustomHTTPServer,
  ZipObject, CityObject, StripObject;


type TCategoryObject = class(TWebObject)
  public
// persistent data
    CSWork : TCriticalSection;
    destructor Free; override;
    procedure Init(Oldobject: TWebObject = nil); override;
    procedure HandleCommand(UnparsedParams : String;
                            Var ResponseInfo: String; Var ContentType : String); override;
  end;

implementation
uses parser, math;

procedure TCategoryObject.Init;
begin
   CSWork := TCriticalSection.Create;
end;

destructor TCategoryObject.Free;
begin
   CSWork.Free;
end;

procedure TCategoryObject.HandleCommand(
      UnparsedParams : String;
      Var ResponseInfo: String; Var ContentType : String);
Var  S : String;
  P : integer;
  V, VarName : String;
  T : int64;
  D : double;
  DataSetName, HeaderUrl, Res : String;
begin
   try
       S := UnparsedParams;
       p := 1;
       Res := '';
       DatasetName := '';
       HeaderUrl := '';
       while p < length(S) do
         begin
           ParseDoubleVar(S, VarName, D, V, p);
           if VarName = 'category' then
             Res := Res + Interf.ProcessQuery(V, UnparsedParams, false)
           else if VarName = 'cat' then
             Res := Res + Interf.ProcessQuery(V, UnparsedParams, true)
           else if VarName = 'create_new_dataset' then
             DatasetName := V
         end;
{       if Res = '' then
          Res := Interf.ProcessQuery('all', UnparsedParams, true);}
       if DataSetName <> '' then
          ResponseInfo := Interf.CreateDataSet(DataSetName)
       else
          ResponseInfo := Res + '====' + #10 + ':END.';
       ContentType := 'text/plain';
   except on E: exception do
      begin
//         Interf.EnableLog;
         Interf.AddLog('Request: ' + UnparsedParams + ' Exception: ' + E.Message);
         AppendFile(GetHardRootDir1+'Error.LOG', 'Request: ' + UnparsedParams + ' Exception: ' + E.Message);
         ResponseInfo := 'END. Internal Error. Please report to shaposhn@cs.fiu.edu';
      end;
   end;
end;

end.
