program rkn_bypasser_gui;

uses
  Winapi.Windows,
  Vcl.Forms,
  uSettings in 'uSettings.pas' {fSettings},
  Vcl.Themes,
  Vcl.Styles,
  uAbout in 'uAbout.pas' {fAbout},
  uLogs in 'uLogs.pas' {fLogs};

{$R *.res}

var
  hMutex: THandle;

function Executed: Boolean;
const
  MUTEX_STR = '{24C8839B-0F77-4E68-B3BD-42E74C051CD6}';
begin
  hMutex := OpenMutex(MUTEX_ALL_ACCESS, False, MUTEX_STR);
  Result := (hMutex <> 0);
  if hMutex = 0 then
    hMutex := CreateMutex(nil, False, MUTEX_STR);
end;

begin
  if Executed then
    Exit;
  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.ShowMainForm := False;
  Application.Title := 'rkn-bypasser-gui';
  TStyleManager.TrySetStyle('Carbon');
  Application.CreateForm(TfSettings, fSettings);
  Application.CreateForm(TfAbout, fAbout);
  Application.CreateForm(TfLogs, fLogs);
  Application.Run;
end.

