object Form1: TForm1
  Left = 1330
  Top = 454
  Width = 408
  Height = 377
  Caption = 'Chat'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 128
    Top = 24
    Width = 150
    Height = 35
    Caption = 'Chat Room '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -29
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 128
    Top = 104
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
    Left = 248
    Top = 272
    Width = 105
    Height = 25
    Caption = 'Send'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 88
    Top = 72
    Width = 217
    Height = 25
    Caption = 'Connect'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 32
    Top = 128
    Width = 321
    Height = 145
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object Edit1: TEdit
    Left = 32
    Top = 272
    Width = 217
    Height = 21
    TabOrder = 3
    Text = 'Message ... '
    OnClick = OneClickedE
    OnKeyPress = OnEnterKey
  end
  object Button3: TButton
    Left = 128
    Top = 312
    Width = 145
    Height = 17
    Caption = 'Disconnect'
    TabOrder = 4
    OnClick = Button3Click
  end
  object ClientSocket1: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnDisconnect = OnDisconnect
    OnRead = OnRead
    OnError = OnError
    Left = 40
    Top = 32
  end
  object ADOQuery1: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\Users\norbertoli' +
      'ni\Desktop\A level proj sockets\ChatRoomDelphi\LoginData.mdb;Per' +
      'sist Security Info=False'
    Parameters = <>
    Left = 40
    Top = 8
  end
end
