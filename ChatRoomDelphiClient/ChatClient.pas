unit ChatClient;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ScktComp, StdCtrls, DB, ADODB;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Edit1: TEdit;
    ClientSocket1: TClientSocket;
    ADOQuery1: TADOQuery;
    Label3: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure OnDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure OnRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure OneClickedE(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OnEnterKey(Sender: TObject; var Key: Char);

  private
    str : string;
    { Private declarations }
  public
    x : integer;
    ConnectedChatName: string;
    ActiveGroupID : string;         //Code label on chat connected, and on send message link groupID. Display only messages with certain groupID.
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Unit2;

{$R *.dfm}

procedure TForm1.Button2Click(Sender: TObject);
begin
  Form1.ConnectedChatName := InputBox('Chat Room Name', 'Enter chat room name','');
  ADOQuery1.Close;
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('select *from OnChatCreate where ChatGroupName=' +QuotedStr(Form1.ConnectedChatName));
  ADOQuery1.Open;
  If (ADOQuery1.RecordCount = 0) then
   ShowMessage('Chat Not found')
  else begin
    Form1.ActiveGroupID := ADOQuery1.FieldByName('GroupID').AsString;
    Label3.Caption := 'Chat Room Name : ' + Form1.ConnectedChatName;
    ClientSocket1.Port := 80;
    ClientSocket1.Address:='127.0.0.1';
    Try
    // ClientSocket1.Active := True;
    Except
    // ClientSocket1.ClientType := ctBlocking;
    // ClientSocket1.Active := True;
    end;
 if(ClientSocket1.Socket.Connected=True)
    then
    begin
      Label3.Caption := 'Chat Room Name : ';
      ActiveGroupID := '';
      ConnectedChatName := '';
      str:='Disconnected';
      ClientSocket1.Active := False;
      Button2.Caption:='Connect';
    end;
   end;
end;


procedure TForm1.Button1Click(Sender: TObject);
 begin
  Str:= Edit1.Text ;                   //Start key '/' End key '\'
  Memo1.Text:= Memo1.Text+'me: '+str+#13#10;
  Str:= ActiveGroupID + Edit1.Text +'/' +Form2.Nickname+ '\';
  Edit1.Text:='';
  ClientSocket1.Socket.SendText(str);
 end;



procedure TForm1.OnDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
   Memo1.Text:=Memo1.Text+'Disconnect'+#13#10;
   Socket.SendText(str);
   Button1.Enabled:=False;
   Edit1.Enabled:=False;
   Button2.Caption:='Connect';
end;



procedure TForm1.OnError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
   ErrorCode:=0;
  ClientSocket1.Active := False;
  Memo1.Text:=Memo1.Text+'No connection found'+#13#10;
end;




procedure TForm1.OnRead(Sender: TObject; Socket: TCustomWinSocket);
var
 MsgReceived : string;
 counter, ID, ValidCheck, StartCharNum, EndCharNum: integer;
 GroupID, NicknameIdentity : string;

begin
ValidCheck := 0;
   MsgReceived := Socket.ReceiveText;
   NicknameIdentity := MsgReceived;
   For counter := 1 to Length(NicknameIdentity) do begin
   If (NicknameIdentity[counter] = '/') then begin
    StartCharNum := counter;
    ValidCheck := ValidCheck + 1;
   end
   Else If (NicknameIdentity[counter] = '\') then begin
    EndCharNum := counter;
    ValidCheck := ValidCheck + 1;
   end;
  end;
  If (ValidCheck mod 2 <> 0) then begin
   ShowMessage ('*MSG ERROR* :'+ MsgReceived);
   Exit;
  end
  else
  Delete (NicknameIdentity ,0 , StartCharNum);
  Delete (NicknameIdentity ,0 , EndCharNum);
   For counter := 1 to 8 do begin
    GroupID := GroupID + MsgReceived[counter];
   end;
   Delete(MsgReceived , 1, 8);
   If (Form1.ActiveGroupID = GroupID) then
   Memo1.Text:=Memo1.Text+'Server: '+MsgReceived+#13#10;
end;


procedure TForm1.OneClickedE(Sender: TObject);
begin
  if (x = 0) then begin
  Edit1.Text := '' ;
  x := x + 1
 end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 x := 0;
end;

procedure TForm1.OnEnterKey(Sender: TObject; var Key: Char);
begin
    if (Key = #13) and (Edit1.Text <> '') then begin
     Str:=Edit1.Text;
     Memo1.Text:=Memo1.Text+'me: '+str+#13#10;
     Str:= ActiveGroupID + Edit1.Text +'/' +Form2.Nickname+ '\';
     Edit1.Text:='';
     ClientSocket1.Socket.SendText(str);
    end;
end;



end.
