object FClient: TFClient
  Left = 0
  Top = 0
  Caption = 'Client'
  ClientHeight = 366
  ClientWidth = 725
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 9
    Top = 5
    Width = 78
    Height = 33
    Caption = 'Client'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Century Gothic'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 51
    Width = 81
    Height = 22
    Caption = 'Message'
    Color = clBtnShadow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -19
    Font.Name = 'Century Gothic'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object messagesLog: TMemo
    Left = 8
    Top = 176
    Width = 709
    Height = 182
    BorderStyle = bsNone
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -17
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    TabOrder = 0
  end
  object btn_connect: TButton
    Left = 8
    Top = 127
    Width = 137
    Height = 33
    Cursor = crHandPoint
    Caption = 'Connect'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clInactiveCaption
    Font.Height = -17
    Font.Name = 'Century Gothic'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btn_connectClick
  end
  object btn_send: TButton
    Left = 563
    Top = 127
    Width = 154
    Height = 33
    Cursor = crHandPoint
    Caption = 'Send Message'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clInactiveCaption
    Font.Height = -17
    Font.Name = 'Century Gothic'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btn_sendClick
  end
  object messageToSend: TMemo
    Left = 8
    Top = 76
    Width = 709
    Height = 45
    BorderStyle = bsNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -17
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    TabOrder = 3
  end
  object btn_disconnect: TButton
    Left = 151
    Top = 127
    Width = 137
    Height = 33
    Cursor = crHandPoint
    Caption = 'Disconnect'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clInactiveCaption
    Font.Height = -17
    Font.Name = 'Century Gothic'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btn_disconnectClick
  end
end
