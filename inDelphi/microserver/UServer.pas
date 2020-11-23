// *****************************************************************************
//   File    : UServer.pas
//   Project : MicroServer.dpr
//             Easy example of TCP Server with indy component : TidTCPSever
//
//   see indy doc: http://www.indyproject.org/sockets/docs/index.en.aspx
//
//
// *****************************************************************************
unit UServer;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdContext, IdComponent, Vcl.StdCtrls,
    IdBaseComponent, IdCustomTCPServer, IdThreadSafe, IdTCPConnection, IdYarn, IdTCPServer, Vcl.ExtCtrls;


type
    TFServer = class(TForm)

        Title         : TLabel;

        btn_start     : TButton;
        btn_stop      : TButton;
        btn_clear     : TButton;

        clients_connected : TLabel;
        Label1        : TLabel;
        Panel1        : TPanel;
        messagesLog   : TMemo;

        procedure FormCreate(Sender: TObject);
        procedure FormShow(Sender: TObject);

        procedure btn_startClick(Sender: TObject);
        procedure btn_stopClick(Sender: TObject);
        procedure btn_clearClick(Sender: TObject);

        procedure IdTCPServerConnect(AContext: TIdContext);
        procedure IdTCPServerDisconnect(AContext: TIdContext);
        procedure IdTCPServerExecute(AContext: TIdContext);
        procedure IdTCPServerStatus(ASender: TObject; const AStatus: TIdStatus;
                                    const AStatusText: string);

        procedure ShowNumberOfClients(p_disconnected : Boolean=False);

        procedure BroadcastMessage(p_message : string);

        procedure Display(p_sender, p_message : string);
        function  GetNow():String;


        private
            { Private declarations }

        public
            { Public declarations }

    end;
    // ...


    // ... listening port
    const GUEST_CLIENT_PORT = 20010;

    var
        FServer     : TFServer;

        // ... Id TCP Server
        IdTCPServer : TIdTCPServer;

implementation

{$R *.dfm}

// *****************************************************************************
//   EVENT : onCreate()
//           ON FORM CREATE
// *****************************************************************************
procedure TFServer.FormCreate(Sender: TObject);
begin

    // ... create idTCPServer
    IdTCPServer                 := TIdTCPServer.Create(self);
    IdTCPServer.Active          := False;

    // ... set properties
    IdTCPServer.MaxConnections  := 20;

    // ... etc..

    // ... assign a new context class (if you need)
    // IdTCPServer.ContextClass    := TYourContext;

    // ... add some callback functions
    IdTCPServer.OnConnect       := IdTCPServerConnect;
    IdTCPServer.OnDisconnect    := IdTCPServerDisconnect;
    IdTCPServer.OnExecute       := IdTCPServerExecute;
    IdTCPServer.OnStatus        := IdTCPServerStatus;
    // ... etc..

end;
// .............................................................................


// *****************************************************************************
//   EVENT : onShow()
//           ON FORM SHOW
// *****************************************************************************
procedure TFServer.FormShow(Sender: TObject);
begin
    // ... INITIALIZE:

    // ... clear message log
    messagesLog.Lines.Clear;

    // ... zero to clients connected
    clients_connected.Caption   := inttostr(0);

    // ... set buttons
    btn_start.enabled           := True;
    btn_stop.enabled            := False;
end;
// .............................................................................


// *****************************************************************************
//   EVENT : btn_startClick()
//           CLICK ON START BUTTON
// *****************************************************************************
procedure TFServer.btn_startClick(Sender: TObject);
begin
    // ... START SERVER:

    // ... clear the Bindings property ( ... Socket Handles )
    IdTCPServer.Bindings.Clear;
    // ... Bindings is a property of class: TIdSocketHandles;

    // ... add listening ports:

    // ... add a port for connections from guest clients.
    IdTCPServer.Bindings.Add.Port := GUEST_CLIENT_PORT;
    // ... etc..


    // ... ok, Active the Server!
    IdTCPServer.Active   := True;

    // ... disable start button
    btn_start.enabled    := False;

    // ... enable stop button
    btn_stop.enabled     := True;

    // ... message log
    Display('SERVER', 'STARTED!');

end;
// .............................................................................


// *****************************************************************************
//   EVENT : btn_stopClick()
//           CLICK ON STOP BUTTON
// *****************************************************************************
procedure TFServer.btn_stopClick(Sender: TObject);
begin

    // ... before stopping the server ... send 'good bye' to all clients connected
    BroadcastMessage('Goodbye Client ');

    // ... stop server!
    IdTCPServer.Active := False;

    // ... hide stop button
    btn_stop.enabled   := False;

    // ... show start button
    btn_start.enabled  := True;

    // ... message log
    Display('SERVER', 'STOPPED!');

end;
// .............................................................................


// *****************************************************************************
//   EVENT : btn_clearClick()
//           CLICK ON CLEAR BUTTON
// *****************************************************************************
procedure TFServer.btn_clearClick(Sender: TObject);
begin
    //... clear messages log
    MessagesLog.Lines.Clear;
end;
// .............................................................................

// .............................................................................
// .............................................................................
// .............................................................................

// *****************************************************************************
//   EVENT : onConnect()
//           OCCURS ANY TIME A CLIENT IS CONNECTED
// *****************************************************************************
procedure TFServer.IdTCPServerConnect(AContext: TIdContext);
var
    ip          : string;
    port        : Integer;
    peerIP      : string;
    peerPort    : Integer;

    nClients    : Integer;

    msgToClient : string;
    typeClient  : string;

begin
    // ... OnConnect is a TIdServerThreadEvent property that represents the event
    //     handler signalled when a new client connection is connected to the server.

    // ... Use OnConnect to perform actions for the client after it is connected
    //     and prior to execution in the OnExecute event handler.

    // ... see indy doc:
    //     http://www.indyproject.org/sockets/docs/index.en.aspx

    // ... getting IP address and Port of Client that connected
    ip        := AContext.Binding.IP;
    port      := AContext.Binding.Port;
    peerIP    := AContext.Binding.PeerIP;
    peerPort  := AContext.Binding.PeerPort;

    // ... message log
    Display('SERVER', 'Client Connected!');
    Display('SERVER', 'Port=' + IntToStr(Port)
                      + ' '   + '(PeerIP=' + PeerIP
                      + ' - ' + 'PeerPort=' + IntToStr(PeerPort) + ')'
           );

    // ... display the number of clients connected
    ShowNumberOfClients();

    // ... CLIENT CONNECTED:
    case Port of
    GUEST_CLIENT_PORT   : begin
                            // ... GUEST CLIENTS
                            typeClient := 'GUEST';
                          end;
                          // ...
    end;

    // ... send the Welcome message to Client connected
    msgToClient := 'Welcome ' + typeClient + ' ' + 'Client :)';
    AContext.Connection.IOHandler.WriteLn( msgToClient );

end;
// .............................................................................

// *****************************************************************************
//   EVENT : onDisconnect()
//           OCCURS ANY TIME A CLIENT IS DISCONNECTED
// *****************************************************************************
procedure TFServer.IdTCPServerDisconnect(AContext: TIdContext);
var
    ip          : string;
    port        : Integer;
    peerIP      : string;
    peerPort    : Integer;

    nClients    : Integer;
begin

    // ... getting IP address and Port of Client that connected
    ip        := AContext.Binding.IP;
    port      := AContext.Binding.Port;
    peerIP    := AContext.Binding.PeerIP;
    peerPort  := AContext.Binding.PeerPort;

    // ... message log
    Display('SERVER', 'Client Disconnected! Peer=' + PeerIP + ':' + IntToStr(PeerPort));

    // ... display the number of clients connected
    ShowNumberOfClients(true);
end;
// .............................................................................


// *****************************************************************************
//   EVENT : onExecute()
//           ON EXECUTE THREAD CLIENT
// *****************************************************************************
procedure TFServer.IdTCPServerExecute(AContext: TIdContext);
var
    Port          : Integer;
    PeerPort      : Integer;
    PeerIP        : string;

    msgFromClient : string;
    msgToClient   : string;
begin

    // ... OnExecute is a TIdServerThreadEvents event handler used to execute
    //     the task for a client connection to the server.

    // ... here you can check connection status and buffering before reading
    //     messages from client

    // ... see doc:
    // ... AContext.Connection.IOHandler.InputBufferIsEmpty
    // ... AContext.Connection.IOHandler.CheckForDataOnSource(<milliseconds>);
    //     (milliseconds to wait for the connection to become readable)
    // ... AContext.Connection.IOHandler.CheckForDisconnect;

    // ... received a message from the client

    // ... get message from client
    msgFromClient := AContext.Connection.IOHandler.ReadLn;

    // ... getting IP address, Port and PeerPort from Client that connected
    peerIP    := AContext.Binding.PeerIP;
    peerPort  := AContext.Binding.PeerPort;

    // ... message log
    Display('CLIENT', '(Peer=' + PeerIP + ':' + IntToStr(PeerPort) + ') ' + msgFromClient);
    // ...

    // ... process message from Client

    // ...

    // ... send response to Client

    AContext.Connection.IOHandler.WriteLn('... message sent from server :)');

end;
// .............................................................................


// *****************************************************************************
//   EVENT : onStatus()
//           ON STATUS CONNECTION
// *****************************************************************************
procedure TFServer.IdTCPServerStatus(ASender: TObject; const AStatus: TIdStatus;
                                     const AStatusText: string);
begin
    // ... OnStatus is a TIdStatusEvent property that represents the event handler
    //     triggered when the current connection state is changed...

    // ... message log
    Display('SERVER', AStatusText);
end;
// .............................................................................


// *****************************************************************************
//   FUNCTION : getNow()
//              GET MOW DATE TIME
// *****************************************************************************
function TFServer.getNow() : String;
begin
    Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ': ';
end;
// .............................................................................


// *****************************************************************************
//   PROCEDURE : broadcastMessage()
//               BROADCAST A MESSAGE TO ALL CLIENTS CONNECTED
// *****************************************************************************
procedure TFServer.broadcastMessage(p_message : string);
var
    tmpList      : TList;
    contexClient : TidContext;
    nClients     : Integer;
    i            : integer;
begin

    // ... send a message to all clients connected

    // ... get context Locklist
    tmpList  := IdTCPServer.Contexts.LockList;

    try
        i := 0;
        while ( i < tmpList.Count ) do begin
            // ... get context (thread of i-client)
            contexClient := tmpList[i];

            // ... send message to client
            contexClient.Connection.IOHandler.WriteLn(p_message);
            i := i + 1;
        end;

    finally
        // ... unlock list of clients!
        IdTCPServer.Contexts.UnlockList;
    end;
end;
// .............................................................................

// *****************************************************************************
//   PROCEDURE : Display()
//               DISPLAY MESSAGE UPON SYSOUT
// *****************************************************************************
procedure TFServer.Display(p_sender : String; p_message : string);
begin
    // ... DISPLAY MESSAGE
    TThread.Queue(nil, procedure
                       begin
                           MessagesLog.Lines.Add('[' + p_sender + '] - '
                           + getNow() + ': ' + p_message);
                       end
                 );

    // ... see doc..
    // ... TThread.Queue() causes the call specified by AMethod to
    //     be asynchronously executed using the main thread, thereby avoiding
    //     multi-thread conflicts.
end;
// .............................................................................

// *****************************************************************************
//   PROCEDURE : ShowNumberOfClients()
//               NUMBER OF CLIENTS CONNECTD
// *****************************************************************************
procedure TFServer.ShowNumberOfClients(p_disconnected : Boolean=False);
var
    nClients : integer;
begin

    try
        // ... get number of clients connected
        nClients := IdTCPServer.Contexts.LockList.Count;
    finally
        IdTCPServer.Contexts.UnlockList;
    end;

    // ... client disconnected?
    if p_disconnected then dec(nClients);

    // ... display
    TThread.Queue(nil, procedure
                       begin
                          clients_connected.Caption := IntToStr(nClients);
                       end
                 );
end;
// .............................................................................


end.