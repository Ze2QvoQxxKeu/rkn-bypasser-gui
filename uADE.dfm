object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'IP'
  ClientHeight = 65
  ClientWidth = 169
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object eIP: TJvIPAddress
    Left = 8
    Top = 8
    Width = 150
    Height = 21
    Address = 0
    ParentColor = False
    TabOrder = 0
  end
  object OkBtn: TButton
    Left = 8
    Top = 35
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = OkBtnClick
  end
  object Button2: TButton
    Left = 85
    Top = 35
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 2
    OnClick = Button2Click
  end
end
