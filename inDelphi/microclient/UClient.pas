// *****************************************************************************
//   File    : UClient.pas
//   Project : MicroServer.dpr
//             Easy example of TCP Client with indy component: TidTCPClient
//
//   see indy doc: http://www.indyproject.org/sockets/docs/index.en.aspx
//
// *****************************************************************************
unit UClient;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
    IdComponent, IdTCPConnection, IdTCPClient, IdThreadComponent;

type
    TFClient = class(TForm)

    Label1        : TLabel;
    Label2        : TLabel;

    messageToSend : TMemo;
    messagesLog   : TMemo;

    btn_connect   : TButton;
    btn_disconnect: TButton;
    btn_send      : TButton;


    procedure FormShow(Sender: TObject);

    procedure btn_connectClick(Sender: TObject);
    procedure btn_disconnectClick(Sender: TObject);
    procedure btn_sendClick(Sender: TObject);

    procedure IdTCPClientConnected(Sender: TObject);
    procedure IdTCPClientDisconnected(Sender: TObject);

    procedure IdThreadComponentRun(Sender: TIdThreadComponent);

    procedure Display(p_sender: String; p_message: string);
    function  GetNow():String;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    private
        { Private declarations }
    public
        { Public declarations }
    end;

    // ... listening port : GUEST CLIENT
    const GUEST_PORT = 20010;


    var
        FClient             : TFClient;

        // ... TIdTCPClient
        idTCPClient         : TIdTCPClient;

        // ... TIdThreadComponent
        idThreadComponent   : TIdThreadComponent;



implementation

{$R *.dfm}

// *****************************************************************************
//   EVENT : onCreate()
//           ON CREATE FORM
// *****************************************************************************
procedure TFClient.FormCreate(Sender: TObject);
begin
    // ... create TIdTCPClient
    idTCPClient                 := TIdTCPClient.Create();

    // ... set properties
    idTCPClient.Host            := 'localhost';
    idTCPClient.Port            := GUEST_PORT;
    // ... etc..

    // ... callback functions
    idTCPClient.OnConnected     := IdTCPClientConnected;
    idTCPClient.OnDisconnected  := IdTCPClientDisconnected;
    // ... etc..

    // ... create TIdThreadComponent
    idThreadComponent           := TIdThreadComponent.Create();

    // ... callback functions
    idThreadComponent.OnRun     := IdThreadComponentRun;
    // ... etc..

end;
// .............................................................................

// *****************************************************************************
//   EVENT : onShow()
//           ON SHOW FORM
// *****************************************************************************
procedure TFClient.FormShow(Sender: TObject);
begin
    // ... INITAILIZE

    // ... message to send
    messageToSend.Clear;
    messageToSend.Enabled     := False;

    // ... clear log
    messagesLog.Clear;

    // ... buttons
    btn_connect.Enabled       := True;
    btn_disconnect.Enabled    := False;
    btn_send.Enabled          := False;
end;
// .............................................................................

// *****************************************************************************
//   EVENT : btn_connectClick()
//           CLICK ON CONNECT BUTTON
// *****************************************************************************
procedure TFClient.btn_connectClick(Sender: TObject);
begin
    // ... disable connect button
    btn_connect.Enabled := False;

    // ... try to connect to Server
    try
        IdTCPClient.Connect;
    except
        on E: Exception do begin
            Display('CLIENT', 'CONNECTION ERROR! ' + E.Message);
            btn_connect.Enabled := True;
        end;
    end;
end;
// .............................................................................

// *****************************************************************************
//   EVENT : btn_disconnectClick()
//           CLICK ON DISCONNECT BUTTON
// *****************************************************************************
procedure TFClient.btn_disconnectClick(Sender: TObject);
begin
    // ... is connected?
    if IdTCPClient.Connected then begin
        // ... disconnect from Server
        IdTCPClient.Disconnect;

        // ... set buttons
        btn_connect.Enabled       := True;
        btn_disconnect.Enabled    := False;
        btn_send.Enabled          := False;
        messageToSend.Enabled     := False;
    end;
end;
// .............................................................................

// *****************************************************************************
//   EVENT : onConnected()
//           OCCURS WHEN A CLIENT IS CONNETED
// *****************************************************************************
procedure TFClient.IdTCPClientConnected(Sender: TObject);
begin
    // ... messages log
    Display('CLIENT', 'CONNECTED!');

    // ... after connection is ok, run the Thread ... waiting messages from server
    IdThreadComponent.Active  := True;

    // ... set buttons
    btn_connect.Enabled       := False;
    btn_disconnect.Enabled    := True;
    btn_send.Enabled          := True;

    // ... enable message to send
    messageToSend.Enabled     := True;
end;
// .............................................................................

// *****************************************************************************
//   EVENT : onDisconnected()
//           OCCURS WHEN CLIENT IS DISCONNECTED
// *****************************************************************************
procedure TFClient.IdTCPClientDisconnected(Sender: TObject);
begin
    // ... message log
    Display('CLIENT', 'DISCONNECTED!');
end;
// .............................................................................

// *****************************************************************************
//   EVENT : btn_sendClick()
//           CLICK ON SEND BUTTON
// *****************************************************************************
procedure TFClient.btn_sendClick(Sender: TObject);
begin
    // ... send message to Server
    IdTCPClient.IOHandler.WriteLn(messageToSend.Text);
end;
// .............................................................................

// *****************************************************************************
//   EVENT : onRun()
//           OCCURS WHEN THE SERVER SEND A MESSAGE TO CLIENT
// *****************************************************************************
procedure TFClient.IdThreadComponentRun(Sender: TIdThreadComponent);
var
    msgFromServer : string;
begin
    // ... read message from server
    msgFromServer := IdTCPClient.IOHandler.ReadLn();

    // ... messages log
    Display('SERVER', msgFromServer);
end;
// .............................................................................

// *****************************************************************************
//   PROCEDURE : Display()
//               DISPLAY MESSAGE UPON SYSOUT
// *****************************************************************************
procedure TFClient.Display(p_sender : String; p_message : string);
begin
  TThread.Queue(nil, procedure
                     begin
                         MessagesLog.Lines.Add('[' + p_sender + '] - '
                         + GetNow() + ': ' + p_message);
                     end
               );
end;
// .............................................................................

// *****************************************************************************
//   FUNCTION : getNow()
//              GET MOW DATE TIME
// *****************************************************************************
function TFClient.getNow() : String;
begin
    Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ': ';
end;
// .............................................................................

// *****************************************************************************
//   EVENT : FormClose()
//           ON FORM CLOSE
// *****************************************************************************
procedure TFClient.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    // ... terminate thread
    if idThreadComponent.active then begin
       idThreadComponent.active := False;
    end;

    // ... free
    FreeAndNil(IdTCPClient);
    FreeAndNil(IdThreadComponent);
end;

end.
