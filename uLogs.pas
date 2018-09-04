unit uLogs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfLogs = class(TForm)
    TorLogs: TMemo;
    BypasserLogs: TMemo;
    Splitter1: TSplitter;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fLogs: TfLogs;

implementation

{$R *.dfm}

uses
  uSettings;

function AttachConsole(dwProcessId: DWORD): BOOL; stdcall; external 'kernel32.dll' name
  'AttachConsole';

function ReadConsole(PID: Cardinal): TStringList;
var
  BufferInfo: _CONSOLE_SCREEN_BUFFER_INFO;
  BufferSize, BufferCoord: _COORD;
  ReadRegion: _SMALL_RECT;
  Buffer: array of _CHAR_INFO;
  I, J: Integer;
  Line: AnsiString;
  ConsoleHandle: DWORD;
begin
  if AttachConsole(PID) then
    ConsoleHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  Result := TStringList.Create;

  ZeroMemory(@BufferInfo, SizeOf(BufferInfo));
  if not GetConsoleScreenBufferInfo(ConsoleHandle, BufferInfo) then
    raise Exception.Create('GetConsoleScreenBufferInfo error: ' + IntToStr(GetLastError));

  SetLength(Buffer, BufferInfo.dwSize.X * BufferInfo.dwSize.Y);

  BufferSize.X := BufferInfo.dwSize.X;
  BufferSize.Y := BufferInfo.dwSize.Y;
  BufferCoord.X := 0;
  BufferCoord.Y := 0;
  ReadRegion.Left := 0;
  ReadRegion.Top := 0;
  ReadRegion.Right := BufferInfo.dwSize.X;
  ReadRegion.Bottom := BufferInfo.dwSize.Y;

  if ReadConsoleOutput(ConsoleHandle, Pointer(Buffer), BufferSize, BufferCoord, ReadRegion) then
  begin
    for I := 0 to BufferInfo.dwSize.Y - 1 do
    begin
      Line := '';
      for J := 0 to BufferInfo.dwSize.X - 1 do
        Line := Line + Buffer[I * BufferInfo.dwSize.X + J].AsciiChar;
      if Trim(Line) <> '' then
        Result.Add(Trim(Line));
    end
  end
  else
    raise Exception.Create('ReadConsoleOutput error: ' + IntToStr(GetLastError));
  FreeConsole;
end;

procedure TfLogs.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F5 then
  begin
    TorLogs.Text := ReadConsole(dwTorPID).Text;
    SendMessage(TorLogs.Handle, WM_VSCROLL, SB_BOTTOM, 0);
    BypasserLogs.Text := ReadConsole(dwRKNPID).Text;
    SendMessage(BypasserLogs.Handle, WM_VSCROLL, SB_BOTTOM, 0);
  end;
end;

procedure TfLogs.FormShow(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
  CenteringWindow(Handle, GetDesktopWindow);
  TorLogs.Text := ReadConsole(dwTorPID).Text;
  SendMessage(TorLogs.Handle, WM_VSCROLL, SB_BOTTOM, 0);
  BypasserLogs.Text := ReadConsole(dwRKNPID).Text;
  SendMessage(BypasserLogs.Handle, WM_VSCROLL, SB_BOTTOM, 0);
end;

end.

