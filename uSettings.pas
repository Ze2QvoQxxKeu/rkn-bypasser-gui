unit uSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, CoolTrayIcon, System.ImageList, Vcl.ImgList,
  acAlphaImageList, System.Win.Registry, Vcl.StdCtrls, Vcl.Samples.Spin, JvExControls,
  JvComCtrls, System.IniFiles, Vcl.Menus, Winapi.WinSock;

type
  TfSettings = class(TForm)
    tiTray: TCoolTrayIcon;
    ilApp: TsAlphaImageList;
    GroupBox1: TGroupBox;
    ipeBindAddr: TJvIPAddress;
    Label1: TLabel;
    Label2: TLabel;
    seBindPort: TSpinEdit;
    GroupBox2: TGroupBox;
    seTorPort: TSpinEdit;
    seTorSysPort: TSpinEdit;
    Label4: TLabel;
    Label3: TLabel;
    SaveBtn: TButton;
    cbAutorun: TCheckBox;
    pmTray: TPopupMenu;
    miReplacePersonality: TMenuItem;
    miRestart: TMenuItem;
    miLogs: TMenuItem;
    miSettings: TMenuItem;
    miAbout: TMenuItem;
    miExit: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    miIPs: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tiTrayMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure miExitClick(Sender: TObject);
    procedure miSettingsClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure miReplacePersonalityClick(Sender: TObject);
    procedure miLogsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miIPsClick(Sender: TObject);
    procedure miRestartClick(Sender: TObject);
  private
  public
    procedure ReloadSettings();
    procedure WMPowerBroadcast(var Msg: TMessage); message WM_POWERBROADCAST;
  end;

resourcestring
  ProgramName = 'RKN Bypasser GUI';
  ConnectedToTor = 'Подключено к Tor';
  ConnectionError = 'Ошибка подключения к Tor';
  DisconnectedToTor = 'Отключено от Tor';
  TorNodeReplaced = 'Выходная нода Tor изменена';
  TorNodeError = 'Ошибка смены выходной ноды Tor';

var
  fSettings: TfSettings;
  dwTorPID: THandle = 0;
  dwRknPID: THandle = 0;

procedure CenteringWindow(Window: HWND; Parent: HWND; const TopMost: BOOL = False);

procedure Stop(const ShowMessage: Boolean = True);

function StartTor(): Boolean;

function StartRknBypasser(): Boolean;

implementation

{$R *.dfm}

uses
  uAbout, uLogs, uAdditionalIps;

const
  AutorunPath = 'Software\Microsoft\Windows\CurrentVersion\Run';
  TorPath = 'Tor\tor.exe';
  BypasserPath = 'rkn-bypasser.exe';
  IniFileName = 'Config.ini';
  IniSectionName = 'Settings';
  IniProxyHost = 'ProxyHost';
  IniProxyPort = 'ProxyPort';
  IniTorPort = 'TorPort';
  IniTorSysPort = 'TorSysPort';

var
  szHost: string = '127.0.0.1';
  szProxyHost: string = '127.0.0.1';
  iProxyPort: Integer = 8000;
  iTorPort: Integer = 9050;
  iTorSysPort: Integer = 9051;

function ReplacePersonality(): Boolean;
const
  WINSOCK_V20: WORD = $0002;
var
  fSocket: integer;
  HostEnt: PHostEnt;
  SockAddrIn: TSockAddrIn;
  WSAData: TWSAData;
  Str: array[0..255] of AnsiChar;

  function Success(): BOOL;
  var
    Bytes: Integer;
    RBuff: array[0..255] of AnsiChar;
  begin
    FillChar(RBuff, Length(RBuff), #0);
    Bytes := recv(fSocket, RBuff, 256, 0);
    RBuff[3] := #0;
    Result := ((Bytes <> 0) and (Bytes <> SOCKET_ERROR) and (lstrcmpA(RBuff, LPCSTR('250')) = 0));
  end;

begin
  Result := False;
  WSAStartup(WINSOCK_V20, WSAData);
  fSocket := socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
  SockAddrIn.sin_family := AF_INET;
  SockAddrIn.sin_port := htons(iTorSysPort);
  SockAddrIn.sin_addr.s_addr := inet_addr(LPCSTR(AnsiString(szHost)));
  if DWORD(SockAddrIn.sin_addr.s_addr) = INADDR_NONE then
  begin
    HostEnt := gethostbyname(LPCSTR(AnsiString(szHost)));
    if HostEnt = nil then
    begin
      CloseSocket(fSocket);
      WSACleanup();
      Exit;
    end;
    SockAddrIn.sin_addr.s_addr := PLongint(HostEnt^.h_addr_list^)^;
  end;
  if Connect(fSocket, SockAddrIn, SizeOf(SockAddrIn)) <> INVALID_SOCKET then
  begin
    FillChar(Str, Length(Str), #0);
    lstrcpyA(Str, LPCSTR('AUTHENTICATE'#13#10#0));
    send(fSocket, Str, lstrlenA(Str), 0);
    if Success then
    begin
      FillChar(Str, Length(Str), #0);
      lstrcpyA(Str, LPCSTR('SIGNAL NEWNYM'#13#10#0));
      send(fSocket, Str, lstrlenA(Str), 0);
      Result := Success;
    end;
  end;
  CloseSocket(fSocket);
  WSACleanup();
end;

function StartTor(): Boolean;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.wShowWindow := SW_HIDE;
  if CreateProcessW(nil, LPWSTR(WideString(ExtractFilePath(ParamStr(0)) + TorPath +
    ' sockslistenaddress ' + szHost + ' socksport ' + IntToStr(iTorPort) + ' controlport '
    + IntToStr(iTorSysPort))), nil, nil, False, CREATE_NO_WINDOW, nil, nil, StartupInfo,
    ProcessInfo) then
    dwTorPID := ProcessInfo.dwProcessId
  else
    dwTorPID := 0;
  Result := (dwTorPID <> 0);
  if Result then
    while not ReplacePersonality() do
    ;
end;

function StartRknBypasser(): Boolean;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  szHost := WideString(szHost);
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.wShowWindow := SW_HIDE;
  if CreateProcessW(nil, LPWSTR(WideString(ExtractFilePath(ParamStr(0)) + BypasserPath +
    ' --bind-addr ' + szProxyHost + ':' + IntToStr(iProxyPort) + ' --tor-addr ' +
    szProxyHost + ':' + IntToStr(iTorPort) + ' --with-additional-ips')), nil, nil, False,
    CREATE_NO_WINDOW, nil, nil, StartupInfo, ProcessInfo) then
    dwRknPID := ProcessInfo.dwProcessId
  else
    dwRknPID := 0;
  Result := (dwRknPID <> 0);
end;

procedure Stop(const ShowMessage: Boolean = True);
begin
  if (dwRknPID <> 0) or (dwTorPID <> 0) then
  begin
    TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0), dwRknPID), 0);
    TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0), dwTorPID), 0);
    if ShowMessage then
      fSettings.tiTray.ShowBalloonHint(ProgramName, DisconnectedToTor, bitError, 10);
  end;
end;

procedure CenteringWindow(Window: HWND; Parent: HWND; const TopMost: BOOL = False);
var
  Params: HWND;
  ScrRect: TRect;
  WndRect: TRect;
  x, y: integer;
begin
  GetWindowRect(Parent, ScrRect);
  GetWindowRect(Window, WndRect);
  x := ScrRect.Left + ((ScrRect.Width div 2) - (WndRect.Width div 2));
  y := ScrRect.Top + ((ScrRect.Height div 2) - (WndRect.Height div 2));
  if TopMost then
    Params := HWND_TOPMOST
  else
    Params := 0;
  SetWindowPos(Window, Params, x, y, 0, 0, SWP_NOSIZE);
end;

procedure TfSettings.FormShow(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
  with TRegistry.Create() do
  try
    OpenKey(AutorunPath, True);
    if not FileExists(ExtractFilePath(ParamStr(0)) + IniFileName) then
    begin
      WriteString(ProgramName, Application.ExeName);
    end;
    if ValueExists(ProgramName) then
    begin
      WriteString(ProgramName, Application.ExeName);
      cbAutoRun.Checked := True;
    end
    else
      cbAutoRun.Checked := False;
  finally
    Free;
  end;
  ReloadSettings;
  ActiveControl := SaveBtn;
  CenteringWindow(Handle, GetDesktopWindow);
end;

procedure TfSettings.miAboutClick(Sender: TObject);
begin
  fAbout.Show;
end;

procedure TfSettings.miExitClick(Sender: TObject);
begin
  if MessageBox(Handle, PChar('После закрытия сайты станут недоступны.'#13#10'Закрыть программу?'),
    'Подтверждение', MB_YESNO or MB_ICONQUESTION) = IDYES then
  begin
    Stop();
    Halt(0);
  end;
end;

procedure TfSettings.miIPsClick(Sender: TObject);
begin
  fAdditionalIps.Show;
end;

procedure TfSettings.miLogsClick(Sender: TObject);
begin
  fLogs.Show;
end;

procedure TfSettings.miReplacePersonalityClick(Sender: TObject);
begin
  if ReplacePersonality() then
    tiTray.ShowBalloonHint(ProgramName, TorNodeReplaced, bitInfo, 10)
  else
    tiTray.ShowBalloonHint(ProgramName, TorNodeError, bitError, 10);
end;

procedure TfSettings.miRestartClick(Sender: TObject);
begin
  Stop();
  if StartTor() then
  begin
    if StartRknBypasser() then
      tiTray.ShowBalloonHint(ProgramName, ConnectedToTor, bitInfo, 10)
    else
    begin
      Stop();
      tiTray.ShowBalloonHint(ProgramName, ConnectionError, bitError, 10);
    end;
  end
  else
    tiTray.ShowBalloonHint(ProgramName, ConnectionError, bitError, 10);
end;

procedure TfSettings.miSettingsClick(Sender: TObject);
begin
  Show;
end;

procedure TfSettings.ReloadSettings;
begin
  with TRegistry.Create() do
  try
    OpenKey(AutorunPath, True);
    cbAutoRun.Checked := ValueExists(ProgramName);
    if ValueExists(ProgramName) then
      WriteString(ProgramName, Application.ExeName)
  finally
    Free;
  end;
  with TIniFile.Create(ExtractFilePath(ParamStr(0)) + IniFileName) do
  try
    szProxyHost := ReadString(IniSectionName, IniProxyHost, '127.0.0.1');
    ipeBindAddr.Text := szProxyHost;
    iProxyPort := ReadInteger(IniSectionName, IniProxyPort, 8000);
    seBindPort.Value := iProxyPort;
    iTorPort := ReadInteger(IniSectionName, IniTorPort, 9050);
    seTorPort.Value := iTorPort;
    iTorSysPort := ReadInteger(IniSectionName, IniTorSysPort, 9051);
    seTorSysPort.Value := iTorSysPort;
  finally
    Free;
  end;
end;

procedure TfSettings.SaveBtnClick(Sender: TObject);
begin
  with TRegistry.Create() do
  try
    OpenKey(AutorunPath, True);
    if cbAutoRun.Checked then
      WriteString(ProgramName, Application.ExeName)
    else if ValueExists(ProgramName) then
      DeleteValue(ProgramName);
  finally
    Free;
  end;
  with TIniFile.Create(ExtractFilePath(ParamStr(0)) + IniFileName) do
  try
    WriteString(IniSectionName, IniProxyHost, ipeBindAddr.Text);
    WriteInteger(IniSectionName, IniProxyPort, seBindPort.Value);
    WriteInteger(IniSectionName, IniTorPort, seTorPort.Value);
    WriteInteger(IniSectionName, IniTorSysPort, seTorSysPort.Value);
  finally
    Free;
  end;
  Hide;
end;

function GetApplicationMessageBoxHandle(): HWND;
type
  PHWND = ^HWND;

  function EnumWindowsProc(hWin: HWND; lParam: lParam): BOOL; stdcall;
  var
    lpBuffer: array[0..1023] of WideChar;
  begin
    Result := True;
    PHWND(lParam)^ := 0;
    FillChar(lpBuffer, Length(lpBuffer) * SizeOf(WideChar), 0);
    if GetClassNameW(hWin, lpBuffer, Length(lpBuffer)) > 0 then
    begin
      if lpBuffer = '#32770' then
      begin
        if GetWindowThreadProcessId(hWin) = GetCurrentThreadId then
        begin
          PHWND(lParam)^ := hWin;
          Result := False;
        end;
      end;
    end;
  end;

begin
  Result := 0;
  {$IFDEF WIN32}EnumWindows(@EnumWindowsProc, Integer(@Result));{$ENDIF}
end;

procedure TfSettings.tiTrayMouseDown(Sender: TObject; Button: TMouseButton; Shift:
  TShiftState; X, Y: Integer);
var
  MsgBox: HWND;
begin
  if Button = mbRight then
    if IsWindowVisible(Handle) then
      SetForegroundWindow(Handle)
    else if IsWindowVisible(fAbout.Handle) then
      SetForegroundWindow(fAbout.Handle)
    else if IsWindowVisible(fLogs.Handle) then
      SetForegroundWindow(fLogs.Handle)
    else if IsWindowVisible(fAdditionalIps.Handle) then
      SetForegroundWindow(fAdditionalIps.Handle)
    else
    begin
      MsgBox := GetApplicationMessageBoxHandle();
      if MsgBox <> 0 then
        SetForegroundWindow(MsgBox)
      else
      begin
        BringToFront;
        with Mouse.CursorPos do
          pmTray.Popup(X, Y);
        PostMessage(Handle, WM_NULL, 0, 0);
      end;
    end;
end;

procedure TfSettings.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  Hide;
end;

procedure TfSettings.FormCreate(Sender: TObject);
begin
  ReloadSettings;
  tiTray.Hint := ProgramName;
  tiTray.Icon.Assign(Application.Icon);
  if StartTor() then
  begin
    if StartRknBypasser() then
      tiTray.ShowBalloonHint(ProgramName, ConnectedToTor, bitInfo, 10)
    else
    begin
      Stop();
      tiTray.ShowBalloonHint(ProgramName, ConnectionError, bitError, 10);
    end;
  end
  else
    tiTray.ShowBalloonHint(ProgramName, ConnectionError, bitError, 10);
end;

procedure TfSettings.FormDestroy(Sender: TObject);
begin
  Stop(False);
end;

procedure TfSettings.WMPowerBroadcast(var Msg: TMessage);
begin
  case Msg.wParam of
    PBT_APMSUSPEND, PBT_APMSTANDBY:
      begin
        Stop();
        Msg.Result := 1;
      end;
    PBT_APMRESUMESUSPEND, PBT_APMRESUMESTANDBY, PBT_APMRESUMEAUTOMATIC:
      begin
        if StartTor() then
        begin
          if StartRknBypasser() then
            tiTray.ShowBalloonHint(ProgramName, ConnectedToTor, bitInfo, 10)
          else
          begin
            Stop();
            tiTray.ShowBalloonHint(ProgramName, ConnectionError, bitError, 10);
          end;
        end
        else
          tiTray.ShowBalloonHint(ProgramName, ConnectionError, bitError, 10);
        Msg.Result := 1;
      end;
  end;
  inherited;
end;

end.

