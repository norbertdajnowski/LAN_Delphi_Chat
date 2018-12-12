unit Unit2;

interface

uses
    Windows,DateUtils , Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StrUtils, DB, ADODB, Grids, DBGrids, winsock, ScktComp;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    ADOQuery1: TADOQuery;
    procedure Button1Click(Sender: TObject);

  private
    { Private declarations }
  public
   Nickname : string;
    { Public declarations }
  end;

  Thash = cardinal;

var
  Form2: TForm2;
   myDate : TFormatSettings;
  formattedDateTime ,StrStaffID, IPAddress  : string;

implementation

uses ChatClient;

{$R *.dfm}


function getIPs: Tstrings;                 //fetches IP address
type 
  TaPInAddr = array[0..10] of PInAddr; 
  PaPInAddr = ^TaPInAddr; 
var 
  phe: PHostEnt; 
  pptr: PaPInAddr; 
  Buffer: array[0..63] of Char; 
  I: Integer; 
  GInitData: TWSAData; 
begin 
  WSAStartup($101, GInitData); 
  Result := TstringList.Create; 
  Result.Clear; 
  GetHostName(Buffer, SizeOf(Buffer)); 
  phe := GetHostByName(buffer); 
  if phe = nil then Exit; 
  pPtr := PaPInAddr(phe^.h_addr_list); 
  I    := 0; 
  while pPtr^[I] <> nil do 
  begin
    Result.Add(inet_ntoa(pptr^[I]^));
    Inc(I); 
  end;
  WSACleanup;
end;

function RandomID(PLen: Integer): string;           //generates random ID
 var
   str: string;
   x : integer;

begin
   Randomize;                       //randomizes values in delphi
   str    := '123456789';
   Result := '';
   repeat
     Result := Result + str[Random(Length(str)) + 1];   //adds on random digits until result is 8 digits long
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


procedure TForm2.Button1Click(Sender: TObject);     //login button
begin
  If (length(Edit1.Text) > 0) and (length(Edit1.Text) < 26) then begin
  ADOQuery1.Close;
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('select *from Users where Username=' +QuotedStr(Edit1.Text));   //searches for usernames equal to edit1 in the database
  ADOQuery1.Open;
  If (ADOQuery1.RecordCount = 0) then begin
   sleep (1000);                           //program frozen for 1 second if no usernames are found
   ShowMessage('Username not found');
  end
  else begin
  If (ADOQuery1.FieldByName('myPassword').AsString = IntToHex(Hash(edit2.text),8)) then begin
   StrStaffID := ADOQuery1.FieldByName('UserID').AsString;     //Password is compared
   IPAddress := getIPs.Text;
   Delete(IPAddress, 1, 15);            //IP and userID are read
   Repeat
    Form2.Nickname := InputBox ('Nickname Set', 'Enter your nickname', '');  //Nickname read
   until (Form2.Nickname <> '');
   ADOQuery1.SQL.Clear;
   ADOQuery1.SQL.Add('Insert into LoginEvent(LogID,ComputerIP,User_ID,DateOfActive,Nickname) Values('+RandomID(8)+','+QuotedStr(IPaddress)+','+StrStaffID+','+DateToStr(now)+',' +QuotedStr(Form2.Nickname)+')');
   ADOQuery1.ExecSql;                          //Information on user saved into logs
   Form2.Hide;
   Form1.Show;
   end
    else begin
     sleep(1000);                       //if password does not exist then program freezes for 1 second
     showmessage('password not found');
    end;
   end;
  end
  else (showmessage('Enter a username in valid boundaries'));
end;





end.
