object Form3: TForm3
  Left = 1222
  Top = 63
  Width = 484
  Height = 271
  Caption = 'Additional Options'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 128
    Top = 8
    Width = 197
    Height = 29
    Caption = 'Additional Options'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 192
    Top = 48
    Width = 69
    Height = 16
    Caption = 'Username :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 200
    Top = 104
    Width = 52
    Height = 13
    Caption = 'Password :'
  end
  object Label4: TLabel
    Left = 368
    Top = 128
    Width = 76
    Height = 13
    Caption = 'Show Password'
  end
  object Edit1: TEdit
    Left = 128
    Top = 72
    Width = 193
    Height = 21
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 128
    Top = 128
    Width = 193
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object Button1: TButton
    Left = 152
    Top = 160
    Width = 145
    Height = 25
    Caption = 'Save'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 368
    Top = 16
    Width = 89
    Height = 17
    Caption = 'Return'
    TabOrder = 3
    OnClick = Button2Click
  end
  object CheckBox1: TCheckBox
    Left = 345
    Top = 128
    Width = 15
    Height = 17
    Caption = 'CheckBox1'
    TabOrder = 4
    OnClick = OnChecked
  end
  object Button3: TButton
    Left = 168
    Top = 200
    Width = 121
    Height = 17
    Caption = 'Delete This User'
    TabOrder = 5
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 8
    Top = 160
    Width = 113
    Height = 57
    Caption = 'Delete All Logon Logs'
    TabOrder = 6
    OnClick = Button4Click
  end
  object ADOQuery1: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\Users\norbertoli' +
      'ni\Desktop\A level proj sockets\ChatRoomDelphi\LoginData.mdb;Per' +
      'sist Security Info=False'
    CursorType = ctStatic
    Parameters = <>
    Left = 40
    Top = 8
  end
end
