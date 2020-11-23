program MicroClient;

uses
  Vcl.Forms,
  UClient in 'UClient.pas' {FClient};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFClient, FClient);
  Application.Run;
end.
