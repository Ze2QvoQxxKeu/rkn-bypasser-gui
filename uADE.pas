unit uADE;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, JvExControls, JvComCtrls;

type
  TForm1 = class(TForm)
    eIP: TJvIPAddress;
    OkBtn: TButton;
    Button2: TButton;
    procedure OkBtnClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

var
  Result: string = '';


procedure TForm1.OkBtnClick(Sender: TObject);
begin
  Result := eIP.Text;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Close;
end;

end.

