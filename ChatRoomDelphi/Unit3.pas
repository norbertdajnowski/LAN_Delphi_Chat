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

  Thash = cardinal;

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
   Randomize;               //randomizes values in delphi
   str    := '123456789';
   Result := '';
   repeat
     Result := Result + str[Random(Length(str)) + 1];    //adds on random digit until result is 8 digits long
   until (Length(Result) = PLen)
end;

function Hash(const aKey: string) : THash;
 var
   G : longint;
   i : integer;
   Hash : longint;
 begin
   Hash := 0;
   for i := 1 to length(aKey) do begin
     Hash := (Hash shl 4) + ord(aKey[i]);
     G := Hash and $F0000000;
     if (G <> 0) then
       Hash := (Hash xor (G shr 24)) xor G;
   end;
   Result := Hash;
 end;



procedure TForm3.Button2Click(Sender: TObject);

 begin
  Form1.Show;
  Form3.Hide;
 end;


procedure TForm3.Button1Click(Sender: TObject); //button to create a new account

  begin
   ADOQuery1.close;
   ADOQuery1.SQL.Clear;
   ADOQuery1.SQL.Add ('select *from Users where username=' + QuotedStr(Edit1.Text));
   ADOQuery1.open;                                                    //checks if an account like this already exists
   If (ADOQuery1.RecordCount <> 0) then begin
    sleep(1000);                                 //if it does then program freezes for one second
    MessageBox(self.Handle, 'An account with the details entered already exists', 'Register Error', MB_ICONSTOP);
   end
   else
   ADOQuery1.close;
   ADOQuery1.SQL.Clear;
   ADOQuery1.SQL.Add ('Insert into Users(UserID,Username,myPassword) values('+RandomID(8)+','+QuotedStr(Edit1.Text)+','+QuotedStr(IntToHex(Hash(edit2.text),8))+')');   //Password gives error
   ADOQuery1.execsql;                    //else a new account is written into the database
   MessageBox(self.Handle, 'Your account has been created', 'Registered', $30);
  end;


procedure TForm3.OnChecked(Sender: TObject);   //checkbox password visibility procedure

 begin
  If (Edit2.PasswordChar = '*') then
   Edit2.PasswordChar := #0
  else
   Edit2.PasswordChar := '*';
 end;

procedure TForm3.Button3Click(Sender: TObject);      //button to delete an account

 begin
  ADOQuery1.SQL.Text := 'SELECT * FROM Users WHERE Username = '+QuotedStr(Edit1.Text)+'';
  ADOQuery1.Open;                              //checks if the account exists
  if ADOQuery1.IsEmpty then begin
   sleep(1000);
   MessageBox(self.Handle, 'User not found', 'User Missing', MB_ICONSTOP);
  end
  else
  begin
   ADOQuery1.Close;                   //If exists then it is deleted from the database
   ADOQuery1.SQL.Text := 'DELETE FROM Users WHERE Username = '+QuotedStr(Edit1.Text)+'';
   ADOQuery1.ExecSQL;
   MessageBox(self.Handle,'Information was Deleted', 'Deleted' , $30);
  end;
   ADOquery1.Free;
  end;

procedure TForm3.Button4Click(Sender: TObject);        //button to delete all logon information

 var
  x : integer;

 begin
  Try
   ADOQuery1.Close;
   ADOQuery1.SQL.Text := 'DELETE FROM LoginEvent WHERE User_ID <> 0'; // Deletes every record in the loginevent table
   ADOQuery1.ExecSQL;
  Except
   MessageBox(self.Handle, 'Failed to delete logs', 'ERROR', MB_ICONSTOP);//On error, message is shown to the user
   x := 1;
  end;
  If (x<>1) then
   MessageBox(self.Handle, 'All login event records have been erased', 'Deleted', $30);
end;

end.
