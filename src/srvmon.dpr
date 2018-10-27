program srvmon;

uses
  Forms,
  servicemon in 'servicemon.pas' {WebInterf};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TWebInterf, WebInterf);
  Application.Run;
end.
