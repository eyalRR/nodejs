program MicroServer;

uses
  Vcl.Forms,
  UServer in 'UServer.pas' {FServer};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFServer, FServer);
  Application.Run;
end.
