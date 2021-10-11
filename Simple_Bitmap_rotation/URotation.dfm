object frmMain: TfrmMain
  Left = 214
  Top = 127
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Simple Bitmap rotation'
  ClientHeight = 419
  ClientWidth = 636
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 17
  object pb_Display: TPaintBox
    Left = 0
    Top = 0
    Width = 636
    Height = 360
    Align = alClient
    OnPaint = pb_DisplayPaint
  end
  object Panel1: TPanel
    Left = 0
    Top = 360
    Width = 636
    Height = 59
    Align = alBottom
    TabOrder = 0
    object lbl_Angle: TLabel
      Left = 240
      Top = 24
      Width = 57
      Height = 17
      Caption = 'Angle: 0'#176
    end
    object TrackBar1: TTrackBar
      Left = 304
      Top = 16
      Width = 329
      Height = 33
      Hint = 'Angle'
      Max = 360
      ParentShowHint = False
      PageSize = 1
      Frequency = 10
      ShowHint = True
      TabOrder = 0
      ThumbLength = 12
      TickMarks = tmBoth
      OnChange = TrackBar1Change
    end
    object btn_LoadBitmap: TButton
      Left = 8
      Top = 16
      Width = 105
      Height = 25
      Caption = 'Load Bitmap'
      TabOrder = 1
      OnClick = btn_LoadBitmapClick
    end
    object cb_Center: TCheckBox
      Left = 120
      Top = 24
      Width = 105
      Height = 17
      Caption = 'Center image'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = cb_CenterClick
    end
  end
  object OPD: TOpenPictureDialog
    Filter = 'Bitmaps (*.bmp)|*.bmp'
    Left = 8
    Top = 8
  end
end
