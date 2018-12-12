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
    Button3: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure OnDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure OnRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure OneClickedE(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OnEnterKey(Sender: TObject; var Key: Char);
    procedure Button3Click(Sender: TObject);

  private
    str : string;
    { Private declarations }
  public
    x : integer;
    ConnectedChatName: string;
    ActiveGroupID : string;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Unit2;

{$R *.dfm}

procedure TForm1.Button2Click(Sender: TObject);    //connection button
begin
  ClientSocket1.Port := 80;
  ClientSocket1.Address:='127.0.0.1';         //sets network values, loops IP
  ClientSocket1.Active := True;                   //sets connection to active
  Form1.ConnectedChatName := InputBox('Chat Room Name', 'Enter chat room name','');
  ADOQuery1.Close;                       //search for chat room
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('select *from OnChatCreate where ChatGroupName=' +QuotedStr(Form1.ConnectedChatName));
  ADOQuery1.Open;                               //searches for chat room in the database
  If (ADOQuery1.RecordCount = 0) then begin
   sleep(1000);                        //if no chat rooms exist then program freezes for 1 second
   ShowMessage('newchat3 chat room not found');
  end
  else begin
    Form1.ActiveGroupID := ADOQuery1.FieldByName('GroupID').AsString;
    Label3.Caption := 'Chat Room Name : ' + Form1.ConnectedChatName;     //else user connected and groupID set
    end;
 end;


procedure TForm1.Button1Click(Sender: TObject);                    //send message button
 begin
  Str:= Edit1.Text ;                   //Start key '/' End key '\' //reads string from edit
  Memo1.Text:= Memo1.Text+'me: '+str+#13#10;
  Str:= ActiveGroupID + Edit1.Text +'/' +Form2.Nickname+ '\';       //formats message to fit groupID and nickname
  Edit1.Text:='';
  ClientSocket1.Socket.SendText(str);               //message sent to admin
 end;



procedure TForm1.OnDisconnect(Sender: TObject; Socket: TCustomWinSocket);  //disconnect network event
begin
   Memo1.Text:=Memo1.Text+'Disconnect'+#13#10;
   Socket.SendText(str);                          //visual changes to the form plus server informed on disconnection
   Button1.Enabled:=False;
   Edit1.Enabled:=False;
   Button2.Caption:='Connect';
end;



procedure TForm1.OnError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
   ErrorCode:=0;
  ClientSocket1.Active := False;                           //client disconnects on component error
  Memo1.Text:=Memo1.Text+'No connection found'+#13#10;
end;




procedure TForm1.OnRead(Sender: TObject; Socket: TCustomWinSocket);  //message read network procedure
var
 MsgReceived : string;
 counter, ID, ValidCheck, StartCharNum, EndCharNum: integer;
 GroupID, NicknameIdentity : string;

begin
ValidCheck := 0;
   MsgReceived := Socket.ReceiveText;                      //Message read
   NicknameIdentity := MsgReceived;
   For counter := 1 to Length(NicknameIdentity) do begin
   If (NicknameIdentity[counter] = '/') then begin
    StartCharNum := counter;                                //extracting information from message
    ValidCheck := ValidCheck + 1;
   end
   Else If (NicknameIdentity[counter] = '\') then begin
    EndCharNum := counter;                                    //validation check if format is correct
    ValidCheck := ValidCheck + 1;
   end;                                        // // // // MAKE VALIDATION HERE
  end;
  Delete (NicknameIdentity ,1, StartCharNum);
  Delete (NicknameIdentity ,EndCharNum - 1, Length(MsgReceived));
  Delete (MsgReceived , StartCharNum , length(MsgReceived)  );
   For counter := 1 to 8 do begin
    GroupID := GroupID + MsgReceived[counter];            //groupID extracted
   end;
   Delete(MsgReceived , 1, 8);                       //actual text message extracted
   If ('11111111' = GroupID) then
    Memo1.Text:=Memo1.Text + MsgReceived + #13#10          //if admin sent message then display differently
   Else If (form1.ActiveGroupID = GroupID) then
    Memo1.Lines.Add(NicknameIdentity +' says : ' + MsgReceived + #13#10);    //else output message normally
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

procedure TForm1.OnEnterKey(Sender: TObject; var Key: Char);     //send message on key press
begin
    if (Key = #13) and (Edit1.Text <> '') then begin           //send message using the enter key
     Str:=Edit1.Text;
     Memo1.Text:=Memo1.Text+'me: '+str+#13#10;
     Str:= ActiveGroupID + Edit1.Text +'/' +Form2.Nickname+ '\';
     Edit1.Text:='';
     ClientSocket1.Socket.SendText(str);
    end;
end;



procedure TForm1.Button3Click(Sender: TObject);   //disconnect button procedure

begin
      Label3.Caption := 'Chat Room Name : ';   //GroupID is formatted as well as most details
      ActiveGroupID := '';                      //prepares the program for connection with a new chat room
      ConnectedChatName := '';
      Button2.Caption:='Connect';
end;

end.
