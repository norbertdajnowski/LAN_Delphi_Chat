unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    ListBox1: TListBox;
    Button2: TButton;
    ADOQuery1: TADOQuery;
    CheckBox1: TCheckBox;
    Label4: TLabel;
    Button3: TButton;
    Button4: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure OnChecked(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  GUID1 : TGUID;
  HashedStr : string;

implementation

uses server;

{$R *.dfm}



function RandomID(PLen: Integer): string;
 var
   str: string;
   x : integer;

begin
   Randomize;
   str    := '123456789';
   Result := '';
   repeat
     Result := Result + str[Random(Length(str)) + 1];
   until (Length(Result) = PLen)
end;


procedure TForm3.Button2Click(Sender: TObject);

 begin
  Form1.Show;
  Form3.Hide;
 end;


procedure TForm3.Button1Click(Sender: TObject);
 var
  Error : boolean ;

  begin
   Error := false;
   ADOQuery1.close;
   ADOQuery1.SQL.Clear;
   ADOQuery1.SQL.Add ('Insert into Users(UserID,Username,myPassword) values('+RandomID(8)+','+QuotedStr(Edit1.Text)+','+QuotedStr(edit2.text)+')');   //Password gives error
   try
   ADOQuery1.execsql;
    Except begin
     MessageBox(self.Handle, 'Error registering, try again or press return', 'Error', MB_ICONSTOP);
     Error := True;
    end;
   end;
   If (Error = False) then
    MessageBox(self.Handle, 'Your account has been created', 'Registered', $30);
  end;


procedure TForm3.OnChecked(Sender: TObject);

 begin
  If (Edit2.PasswordChar = '*') then
   Edit2.PasswordChar := #0
  else
   Edit2.PasswordChar := '*';
 end;

procedure TForm3.Button3Click(Sender: TObject);
 begin
  ADOQuery1.SQL.Text := 'SELECT * FROM Users WHERE Username = '+QuotedStr(Edit1.Text)+'';
  ADOQuery1.Open;
  if ADOQuery1.IsEmpty then
   MessageBox(self.Handle, 'User not found', 'User Missing', MB_ICONSTOP)
  else
  begin
   ADOQuery1.Close;
   ADOQuery1.SQL.Text := 'DELETE FROM Users WHERE Username = '+QuotedStr(Edit1.Text)+'';
   ADOQuery1.ExecSQL;
   MessageBox(self.Handle,'Information was Deleted', 'Deleted' , $30);
  end;
   ADOquery1.Free;
  end;

procedure TForm3.Button4Click(Sender: TObject);
 var
  x : integer;

 begin
  Try
   ADOQuery1.Close;
   ADOQuery1.SQL.Text := 'DELETE FROM LoginEvent WHERE User_ID <> 0';
   ADOQuery1.ExecSQL;
  Except
   MessageBox(self.Handle, 'Failed to delete logs', 'ERROR', MB_ICONSTOP);
   x := 1;
  end;
  If (x<>1) then
   MessageBox(self.Handle, 'All login event records have been erased', 'Deleted', $30);
end;

end.
