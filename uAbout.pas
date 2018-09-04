unit uAbout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, acPNG, Vcl.ExtCtrls, Vcl.StdCtrls, sLabel;

type
  TfAbout = class(TForm)
    Label1: TLabel;
    LogoImg: TImage;
    Label2: TLabel;
    Label3: TLabel;
    sWebLabel1: TsWebLabel;
    sWebLabel2: TsWebLabel;
    sWebLabel3: TsWebLabel;
    License: TMemo;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fAbout: TfAbout;

implementation

{$R *.dfm}

uses
  uSettings;

procedure TfAbout.FormShow(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
  CenteringWindow(Handle, GetDesktopWindow);
  SendMessage(License.Handle, WM_VSCROLL, SB_TOP, 0);
end;

end.

