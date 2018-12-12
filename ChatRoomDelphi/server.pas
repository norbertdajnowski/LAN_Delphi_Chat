unit server;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ScktComp, StdCtrls, DB, ADODB;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Button3: TButton;
    Button4: TButton;
    Memo1: TMemo;
    ADOQuery1: TADOQuery;
    Label2: TLabel;
    Button5: TButton;
    Button6: TButton;
    ServerSocket1: TServerSocket;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ConnectionServer(Sender: TObject; Socket: TCustomWinSocket);
    procedure readSRV(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnClicked(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EnterKeyPress(Sender: TObject; var Key: Char);
    procedure Button3Click(Sender: TObject);
    procedure FrmVisTrue(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    str : string;
    { Private declarations }
  public
      x : integer;
      ClientList : array of string;
      ClientCounter:integer;
      ServerConnectedName, ServerDisconnectingName: string;
    { Public declarations }
  end;

var
  Form1: TForm1;
  ListOfUsers, TempList : array of string;
  ALo, AMid , AHi, i: integer;

implementation

uses Unit2, Unit3;

{$R *.dfm}



procedure TForm1.Button1Click(Sender: TObject);       //send message button

 var
  i : integer;

begin
    Str := Edit1.Text;                              //reads and displays text in memo
    Memo1.Lines.Add('me: '+Str+#13#10);
    Str := '11111111 ADMIN :' +  Edit1.Text;
    Edit1.Text:='';                                       //formats message so that user identifies it as admin
    for i:=0 to ServerSocket1.Socket.ActiveConnections - 1 do
     ServerSocket1.Socket.Connections[i].SendText(str);        ///message casted out
end;

function RandomID(PLen: Integer): string;         //random ID generated

 var
   str: string;
   x : integer;

begin
   Randomize;                     //randomizes values in delphi
   str    := '123456789';
   Result := '';
   repeat
     Result := Result + str[Random(Length(str)) + 1];       //adds on random digit until result is 8 digits long
   until (Length(Result) = PLen)
end;

procedure TForm1.Button2Click(Sender: TObject);       //start/stop chat button

var
 Error : boolean;
 ServerStatus : string;

begin
    ServerSocket1.Port := 80;                    //sets socket for this communication to 80
    if(ServerSocket1.Active = False) then begin
      ServerSocket1.Active := True;                 //If not yet connected
      ServerStatus := 'Active';
      Form1.ServerConnectedName := InputBox('Find Chat', 'Enter chat group name', '');
      Memo1.Lines.Add(Form1.ServerConnectedName+' Started'+#13#10);            //connection started
      ADOQuery1.close;
      ADOQuery1.SQL.Clear;
      ADOQuery1.SQL.Add ('Insert into OnChatCreate(ChatGroupName,StaffID,GroupID,Status) values('+QuotedStr(Form1.ServerConnectedName)+','+QuotedStr(Form2.StrStaffID)+','+RandomID(8)+',' +QuotedStr(ServerStatus)+ ')');   //Password gives error
      try                                              //Create new chat group and write it to database
       ADOQuery1.ExecSql;
      Except begin
       MessageBox(self.Handle, 'Error Setting Up Chat', 'Error', MB_ICONSTOP);
       Error := True;                                           //chat group creation validation
      end;
      end;
    If (Error = False) then
     MessageBox(self.Handle, 'Chat is now active', 'Connected', $30);
     Button2.Caption:='Disable chat group';
     Button1.Enabled:=true;
     Edit1.Enabled:=true;
    end
   else
    begin
      ServerStatus := 'Inactive';        //If chat already active
      Form1.ServerDisconnectingName := InputBox('Stop Chat', 'Enter chat group name', '');
      ADOQuery1.Close;
      ADOQuery1.SQL.Clear;
      ADOQuery1.SQL.Text := 'SELECT * FROM OnChatCreate WHERE ChatGroupName = '+QuotedStr(Form1.ServerDisconnectingName)+'';
      ADOQuery1.Open;                                          //looks up for entered chat group
      If (ADOQuery1.RecordCount = 0) then
       showmessage('Chat does not exist')
      else begin
       If (ADOQuery1.FieldByName('Status').AsString = 'Inactive') or (ADOQuery1.FieldByName('Status').AsString = '') then
        showmessage('Chat is already inactive')       //Validation if chat group exists or is active
       else
        showmessage('Chat successfully stopped');
        ADOQuery1.SQL.Clear;
        ADOQuery1.SQL.Text := 'Insert into OnChatCreate(Status) Values('+QuotedStr(ServerStatus)+')';
        ADOQuery1.ExecSQL;                              //If active then database value is changed to inactive
        ClientCounter := 1;
        SetLength ( ClientList , 0);                   //counter of how many clients are connected
        SetLength (ClientList , ClientCounter);
        Form1.ServerConnectedName := '' ;
        Memo1.Lines.Add(Form1.ServerDisconnectingName +' Stopped'+#13#10);
        Button2.Caption:='Start a chat group';
      end;
   end;
end;

procedure Merge(ALo,AMid,AHi:Integer);
  var i,j,k,m:Integer;
  begin
    i:=0;
    for j:=ALo to AMid do
    begin
      TempList[i]:=ListOfUsers[j];
      inc(i);
    end;

    i:=0;j:=AMid + 1;k:=ALo;
    while ((k < j) and (j <= AHi)) do
    if (TempList[i] <= ListOfUsers[j]) then
    begin
      ListOfUsers[k]:=TempList[i];
      inc(i);inc(k);
    end else
    begin
      ListOfUsers[k]:=ListOfUsers[j];
      inc(k);inc(j); 
    end;

 
    for m:=k to j - 1 do 
    begin 
      ListOfUsers[m]:=TempList[i];
      inc(i);
    end;
  end;

procedure PerformMergeSort(ALo,AHi:Integer);
  var AMid:Integer; 
  begin 
    if (ALo < AHi) then 
    begin 
      AMid:=(ALo + AHi) shr 1;
      PerformMergeSort(ALo,AMid);
      PerformMergeSort(AMid + 1,AHi);
      Merge(ALo,AMid,AHi);
    end; 
  end;



procedure TForm1.ConnectionServer(Sender: TObject; Socket: TCustomWinSocket);

begin
  Socket.SendText('Connected');                    //message sent to a newly connected client
  ClientList [ClientCounter - 1] := IntToStr(Socket.SocketHandle);
  ClientCounter := ClientCounter + 1;
  SetLength(ClientList, ClientCounter);          //increment client list counter
  Button1.Enabled:=true;
  Edit1.Enabled:=true;
end;







procedure TForm1.readSRV(Sender: TObject; Socket: TCustomWinSocket);     //Message receiving procedure

 var
  ClientD : integer;
  ClientListD : integer;
  i, counter, StartCharNum, EndCharNum, ValidCheck : integer;
  MsgReceived, GroupCheck, NicknameIdentity : string;
  GroupID, GroupIDClient : string;

begin
  MsgReceived := Socket.ReceiveText;                      //received message read
  str := MsgReceived;
  NicknameIdentity := MsgReceived;
  For counter := 1 to Length(NicknameIdentity) do begin
   If (NicknameIdentity[counter] = '/') then begin         //message is formated to extract different data from it
    StartCharNum := counter;
    ValidCheck := ValidCheck + 1;
   end
   Else If (NicknameIdentity[counter] = '\') then begin
    EndCharNum := counter;
    ValidCheck := ValidCheck + 1;
   end;                           //Like a data packet it contains the nickname, groupID and the middle part which is the message.
  end;
  If (ValidCheck mod 2 <> 0) then begin
   ShowMessage ('*MESSAGE ERROR* :'+ MsgReceived);   //validity of message format checked
   Exit;
  end;
  Delete (NicknameIdentity ,1, StartCharNum);
  Delete (NicknameIdentity ,EndCharNum - 1  , length(MsgReceived)  );
  Delete (MsgReceived , StartCharNum , length(MsgReceived)  );
  For counter := 1 to 8 do begin
   GroupID := GroupID + MsgReceived[counter];           //GroupID extracted from the message
  end;
  Delete (MsgReceived , 1, 8);     //text message itself extracted
  ADOQuery1.Close;
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Text := 'SELECT * FROM OnChatCreate WHERE GroupID = '+GroupID+''; //fetches which chat group user is in
  ADOQuery1.Open;
  If (ADOQuery1.RecordCount = 0) then
   Messagebox (self.Handle, 'Users chat group not found', 'Error', MB_ICONSTOP)
  else begin
   GroupIDClient := ADOQuery1.FieldByName('ChatGroupName').AsString;
   Memo1.Lines.Add('(Group: '+ GroupIDClient +'  Nickname: '+NicknameIdentity);  //message and details displayed in memo
   Memo1.Lines.Add(' Message : ' + MsgReceived + #13#10);
   ClientD := Pos ('Disconnected' , MsgReceived);
   for i:=0 to ServerSocket1.Socket.ActiveConnections-1 do
      ServerSocket1.Socket.Connections[i].SendText(str);
   If (ClientD <> 0) then begin
    For i := 0 to ClientCounter - 2 do begin
     ClientListD := Pos(IntToStr(Socket.SocketHandle), ClientList [i]);
      If (ClientListD <> 0) then begin
       ClientList [i] := '';
      end;
     end;
    end;
   end;
end;



procedure TForm1.OnClicked(Sender: TObject);

begin
 if (x = 0) then begin
  Edit1.Text := '' ;
  x := x + 1
 end;
end;


procedure TForm1.FormCreate(Sender: TObject);

 begin
  x := 0;
  ClientCounter := 1;
  SetLength (ClientList , ClientCounter);
  ADOQuery1.Close;
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Text := ' SELECT * FROM LoginEvent ';
  ADOQuery1.Open;
  ADoQuery1.First;
  While not ADOQuery1.Eof do
   begin
    SetLength (ListOfUsers , i + 1);
    If (ADOQuery1.FieldByName('Nickname').AsString <> '') then begin
     ListOfUsers [i] := ADOQuery1.FieldByName('Nickname').AsString;
     i := i + 1;
    end;
    ADOQuery1.Next;
   end;
   SetLength (TempList, i);
   PerformMergeSort(Low(ListOfUsers), High(ListOfUsers));
 end;



procedure TForm1.EnterKeyPress(Sender: TObject; var Key: Char);  //Sending a message with a key press

 var
  i : integer;

begin
 if (Key = #13) and (Edit1.Text <> '') then begin    //same function as the send message button
  Str := Edit1.Text;
  Memo1.Lines.Add('me: '+Str+#13#10);
  Str := '11111111 ADMIN :' +  Edit1.Text;
  Edit1.Text:='';
  for i:=0 to ServerSocket1.Socket.ActiveConnections - 1 do
   ServerSocket1.Socket.Connections[i].SendText(str);
 end;
end;



procedure TForm1.Button3Click(Sender: TObject);

 var
  i : integer;

begin
 Memo1.Lines.Add('List of clients connected :');
 For i := 0 to ClientCounter - 2 do begin      //displays the list of clients socket numbers using the client side program
  If (ClientList[i] <> '') then
   Memo1.Lines.add ('Client ' + ClientList [i]);
 end;
end;



procedure TForm1.FrmVisTrue(Sender: TObject);  //On form display

begin
 Memo1.Text := ' Welcome to the group chat application ';
end;

procedure TForm1.Button4Click(Sender: TObject);     //button click

begin
Form1.Hide;         //forms switch
Form3.Show;
end;

procedure TForm1.Button5Click(Sender: TObject);     //button click to delete a chat room

var
 DelChat : string;

begin
 DelChat := InputBox ('Delete a chat', 'Enter the chat room name that you would like to delete','');
 ADOQuery1.Close;
 ADOQuery1.SQL.Clear;
 ADOQuery1.SQL.Text := 'DELETE FROM OnChatCreate WHERE ChatGroupName = '+QuotedStr(DelChat)+'';
 ADOQuery1.ExecSQL;                                                   //Read chat is searched through database and deleted
 MessageBox(self.Handle,'If chat existed then it has been deleted', 'Deleted' , $30);
end;

function search (NSearch : string; i : integer):boolean ;
var
 low, high, mid : integer;
begin
  Search := false;
  low := 2;
  high := i;
  while low <= high do begin
   mid :=((high + low) div 2);
   If ListOfUsers[Mid] = NSearch then
    Result := True;
   If (ListOfUsers[mid] < NSearch) then
    Low := Mid + 1
    else High := mid - 1;
   end;
end;

procedure TForm1.Button6Click(Sender: TObject);        //button click to identify a user

var

counter : integer;
Nickname, LogID, DateOfActive, User_ID, ComputerIP, TimeOfActive : string;

begin
 Nickname := InputBox ('Nickname Identity', 'Enter nickname to search', '');
   ADOQuery1.Close;
   ADOQuery1.SQL.Clear;
   ADOQuery1.SQL.Add('select *from LoginEvent where Nickname=' +QuotedStr(Nickname));
   ADOQuery1.Open;
   LogID := ADOQuery1.FieldByName('LogID').AsString;
   DateOfActive := ADOQuery1.FieldByName('DateOfActive').AsString;
   TimeOfActive := ADOQuery1.FieldByName('TimeOfActive').AsString;
   User_ID := ADOQuery1.FieldByName('User_ID').AsString;
   ComputerIP := ADOQuery1.FieldByName('ComputerIP').AsString;
   MessageBox(self.Handle,'User has been identified', 'Deleted' , $30);
   Memo1.lines.add(Nickname + 's most recent log ID is '+ LogID);
   Memo1.lines.add ('Active on ' + DateOfActive);
   Memo1.Lines.add ('Active at ' + TimeOfActive);
   Memo1.Lines.add ('User ID ' + User_ID);
   Memo1.Lines.Add('The computer IP address of the user was '+ ComputerIP);
   showmessage ('Nickname was not found in the logs');
 end;

end.
