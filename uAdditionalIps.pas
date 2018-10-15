unit uAdditionalIps;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.ImageList, Vcl.ImgList,
  acAlphaImageList, Vcl.Menus, System.RegularExpressions;

type
  TfAdditionalIps = class(TForm)
    lbIPs: TListBox;
    SaveBtn: TButton;
    pmMenu: TPopupMenu;
    miAdd: TMenuItem;
    miEdit: TMenuItem;
    miDelete: TMenuItem;
    ilMenu: TsAlphaImageList;
    procedure SaveBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pmMenuPopup(Sender: TObject);
    procedure miAddClick(Sender: TObject);
    procedure miEditClick(Sender: TObject);
    procedure miDeleteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fAdditionalIps: TfAdditionalIps;

implementation

{$R *.dfm}

uses
  uSettings;

const
  FileName = {$IFDEF WIN32}'additional-ips'{$ELSE}'additional-ips.yml'{$ENDIF};

procedure TfAdditionalIps.FormCreate(Sender: TObject);
begin
  Constraints.MaxWidth := Width;
  Constraints.MinWidth := Width;
end;

procedure TfAdditionalIps.FormShow(Sender: TObject);
var
  i: Integer;
  s: string;
begin
  ShowWindow(Application.Handle, SW_HIDE);
  CenteringWindow(Handle, GetDesktopWindow);
  lbIPs.Clear;
  with TStringList.Create do
  try
    if not FileExists(ExtractFilePath(ParamStr(0)) + FileName) then
      SaveToFile(ExtractFilePath(ParamStr(0)) + FileName);
    LoadFromFile(ExtractFilePath(ParamStr(0)) + FileName);
    for i := 0 to Pred(Count) do
    begin
      s := Strings[i];
      System.Delete(s, 1, 2);
      lbIPs.Items.Add(s);
    end;
  finally
    Free;
  end;
end;

procedure TfAdditionalIps.miAddClick(Sender: TObject);
var
  s: string;
begin
  if InputQuery('Добавление IP', '', s) and TRegEx.IsMatch(s.Trim,
    '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$') then
    lbIPs.Items.Add(s.Trim);
end;

procedure TfAdditionalIps.miDeleteClick(Sender: TObject);
begin
  if MessageBox(Handle, PChar(Format('Действительно хотите удалить %s?', [lbIPS.Items[lbIPs.ItemIndex]])),
    'Подтверждение', MB_YESNO) = IDYES then
    lbIPs.DeleteSelected;
end;

procedure TfAdditionalIps.miEditClick(Sender: TObject);
var
  s: string;
begin
  s := lbIPs.Items[lbIPs.ItemIndex];
  if InputQuery('Редактирование IP', '', s) and TRegEx.IsMatch(s.Trim,
    '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$') then
    lbIPs.Items[lbIPs.ItemIndex] := s.Trim;
end;

procedure TfAdditionalIps.pmMenuPopup(Sender: TObject);
begin
  miEdit.Enabled := (lbIPs.ItemIndex <> -1);
  miDelete.Enabled := (lbIPs.ItemIndex <> -1);
end;

procedure TfAdditionalIps.SaveBtnClick(Sender: TObject);
var
  i: Integer;
begin
  with TStringList.Create do
  try
    for i := 0 to Pred(lbIPs.Items.Count) do
    begin
      Add('- ' + lbIPs.Items[i])
    end;
    SaveToFile(ExtractFilePath(ParamStr(0)) + FileName);
  finally
    Free;
  end;
  Close;
  fSettings.miRestart.Click;
end;

end.

