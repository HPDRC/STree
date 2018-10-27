program streeweb;

{$SetPEFlags $20}

uses
  FastMM4,
  Windows,
  Forms,
  webobject in 'Webobjects\webobject.pas' {WebInterf},
  Directory in 'Util\Directory.pas',
  MemoryChecker in 'Util\MemoryChecker.pas',
  RegExpr in 'regexpr\RegExpr.pas';

//ImagehlpU in 'ImageHlpU.pas';

{$R *.RES}

//{$IFDEF 4GB}
//	{$SetPEFlags IMAGE_FILE_LARGE_ADDRESS_AWARE}
//{$ENDIF}

begin
  Application.Initialize;
  Application.CreateForm(TWebInterf, WebInterf);
  Application.Run;
end.


