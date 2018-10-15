#define MyAppName "RKN Bypasser GUI"
#define MyAppVersion "1.2"
#define MyAppPublisher "dimuls@yandex.ru & adm1n1strat1on@list.ru"
#define MyAppURL "https://github.com/someanon/rkn-bypasser-gui"
#define MyAppExeName "rkn-bypasser-gui.exe"

[Setup]
AppId={{A6EF4A49-C0C4-4F70-AC86-F274E94CC68F}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
LicenseFile=D:\Soft\rkn-bypasser\v1.2\license.txt
OutputBaseFilename=rkn-bypasser-gui-setup
SetupIconFile=D:\Soft\rkn-bypasser\v1.2\icon.ico
Compression=lzma
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64
PrivilegesRequired=admin

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Files]
Source: "D:\Soft\rkn-bypasser\v1.2\Tor-x64\libeay32.dll"; DestDir: "{app}\Tor\"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.2\Tor-x64\libevent_core-2-1-6.dll"; DestDir: "{app}\Tor\"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.2\Tor-x64\libevent_extra-2-1-6.dll"; DestDir: "{app}\Tor\"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.2\Tor-x64\libevent-2-1-6.dll"; DestDir: "{app}\Tor\"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.2\Tor-x64\libssp-0.dll"; DestDir: "{app}\Tor\"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.2\Tor-x64\libwinpthread-1.dll"; DestDir: "{app}\Tor\"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.2\Tor-x64\ssleay32.dll"; DestDir: "{app}\Tor\"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.2\Tor-x64\tor.exe"; DestDir: "{app}\Tor\"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.2\Tor-x64\zlib1.dll"; DestDir: "{app}\Tor\"; Check: Is64BitInstallMode; Flags: ignoreversion

Source: "D:\Soft\rkn-bypasser\v1.2\Tor-x86\libeay32.dll"; DestDir: "{app}\Tor\"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.2\Tor-x86\libevent_core-2-1-6.dll"; DestDir: "{app}\Tor\"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.2\Tor-x86\libevent_extra-2-1-6.dll"; DestDir: "{app}\Tor\"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.2\Tor-x86\libevent-2-1-6.dll"; DestDir: "{app}\Tor\"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.2\Tor-x86\libgcc_s_sjlj-1.dll"; DestDir: "{app}\Tor\"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.2\Tor-x86\libgmp-10.dll"; DestDir: "{app}\Tor\"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.2\Tor-x86\libssp-0.dll"; DestDir: "{app}\Tor\"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.2\Tor-x86\libwinpthread-1.dll"; DestDir: "{app}\Tor\"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.2\Tor-x86\ssleay32.dll"; DestDir: "{app}\Tor\"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.2\Tor-x86\tor.exe"; DestDir: "{app}\Tor\"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.2\Tor-x86\zlib1.dll"; DestDir: "{app}\Tor\"; Check: not Is64BitInstallMode; Flags: ignoreversion

Source: "D:\Soft\rkn-bypasser\v1.2\rkn_bypasser_gui-x64.exe"; DestDir: "{app}"; DestName: "rkn-bypasser-gui.exe"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.2\rkn_bypasser_gui-x86.exe"; DestDir: "{app}"; DestName: "rkn-bypasser-gui.exe"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.2\rkn-bypasser-x64.exe"; DestDir: "{app}"; DestName: "rkn-bypasser.exe"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.2\rkn-bypasser-x86.exe"; DestDir: "{app}"; DestName: "rkn-bypasser.exe"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.2\additional-ips"; DestDir: "{app}"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.2\additional-ips"; DestDir: "{app}"; DestName: "additional-ips.yml"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "C:\Program Files (x86)\The Road To Delphi\VCL Styles Inno\VclStylesinno.dll"; DestDir: {app}; Flags: dontcopy
Source: "C:\Program Files (x86)\The Road To Delphi\VCL Styles Inno\Styles\Carbon.vsf"; DestDir: {app}; Flags: dontcopy

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Registry]
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: {#MyAppName}; ValueData: """{app}\{#MyAppExeName}"""; Flags: uninsdeletekey

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
Type: files; Name: "{app}\Config.ini"

[Code]
procedure LoadVCLStyle(VClStyleFile: String); external 'LoadVCLStyleW@files:VclStylesInno.dll stdcall';
procedure UnLoadVCLStyles; external 'UnLoadVCLStyles@files:VclStylesInno.dll stdcall';
 
function InitializeSetup(): Boolean;
begin
  ExtractTemporaryFile('Carbon.vsf');
  LoadVCLStyle(ExpandConstant('{tmp}\Carbon.vsf'));
  Result := True;
end;
 
procedure DeinitializeSetup();
begin
  UnLoadVCLStyles;
end;
