object Form1: TForm1
  Left = 1348
  Top = 568
  Width = 460
  Height = 382
  Caption = 'Chat Group Server'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClick = OnClicked
  OnCreate = FormCreate
  OnShow = FrmVisTrue
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 152
    Top = 32
    Width = 147
    Height = 35
    Caption = 'Chat Server'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -29
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 152
    Top = 112
    Width = 4
    Height = 16
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 288
    Top = 272
    Width = 121
    Height = 25
    Caption = 'send'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 80
    Top = 80
    Width = 289
    Height = 41
    Caption = 'start/stop chat'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 40
    Top = 144
    Width = 369
    Height = 129
    Color = clHighlightText
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object Edit1: TEdit
    Left = 40
    Top = 272
    Width = 249
    Height = 21
    Color = clHighlightText
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    Text = 'Message...'
    OnClick = OnClicked
    OnKeyPress = EnterKeyPress
  end
  object Button3: TButton
    Left = 336
    Top = 24
    Width = 105
    Height = 17
    Caption = 'Connections'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 128
    Top = 312
    Width = 201
    Height = 25
    Caption = 'Additional Options'
    TabOrder = 5
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 336
    Top = 8
    Width = 105
    Height = 17
    Caption = 'Delete Chat Record'
    TabOrder = 6
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 336
    Top = 40
    Width = 105
    Height = 17
    Caption = 'Identify Nickname'
    TabOrder = 7
    OnClick = Button6Click
  end
  object ADOQuery1: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\Users\norbertoli' +
      'ni\Desktop\A level proj sockets\ChatRoomDelphi\LoginData.mdb;Per' +
      'sist Security Info=False'
    Parameters = <>
    Left = 56
    Top = 24
  end
  object ServerSocket1: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnClientConnect = ConnectionServer
    OnClientRead = readSRV
    Left = 16
    Top = 24
  end
end
