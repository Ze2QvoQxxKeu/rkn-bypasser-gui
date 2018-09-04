#define MyAppName "RKN bypasser"
#define MyAppVersion "1.0"
#define MyAppPublisher "dimuls@yandex.ru & adm1n1strat1on@list.ru"
#define MyAppURL "https://github.com/someanon/rkn-bypasser"
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
LicenseFile=D:\Soft\rkn-bypasser\v1.0\license.txt
OutputBaseFilename=setup
SetupIconFile=D:\Soft\rkn-bypasser\v1.0\icon.ico
Compression=lzma
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Files]
Source: "D:\Soft\rkn-bypasser\v1.0\Tor\libeay32.dll"; DestDir: "{app}\Tor\"; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.0\Tor\libevent_core-2-0-5.dll"; DestDir: "{app}\Tor\"; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.0\Tor\libevent_extra-2-0-5.dll"; DestDir: "{app}\Tor\"; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.0\Tor\libevent-2-0-5.dll"; DestDir: "{app}\Tor\"; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.0\Tor\libgcc_s_sjlj-1.dll"; DestDir: "{app}\Tor\"; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.0\Tor\libssp-0.dll"; DestDir: "{app}\Tor\"; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.0\Tor\ssleay32.dll"; DestDir: "{app}\Tor\"; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.0\Tor\tor.exe"; DestDir: "{app}\Tor\"; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.0\Tor\tor-gencert.exe"; DestDir: "{app}\Tor\"; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.0\Tor\zlib1.dll"; DestDir: "{app}\Tor\"; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.0\rkn-bypasser-gui.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.0\rkn-bypasser-x64.exe"; DestDir: "{app}"; DestName: "rkn-bypasser.exe"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "D:\Soft\rkn-bypasser\v1.0\rkn-bypasser-x86.exe"; DestDir: "{app}"; DestName: "rkn-bypasser.exe"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "C:\Program Files (x86)\The Road To Delphi\VCL Styles Inno\VclStylesinno.dll"; DestDir: {app}; Flags: dontcopy
Source: "C:\Program Files (x86)\The Road To Delphi\VCL Styles Inno\Styles\Carbon.vsf"; DestDir: {app}; Flags: dontcopy

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

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
