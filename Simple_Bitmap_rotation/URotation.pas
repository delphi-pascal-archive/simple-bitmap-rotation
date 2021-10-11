unit URotation;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtDlgs, ComCtrls, ExtCtrls;

type
  TfrmMain = class(TForm)
    pb_Display: TPaintBox;
    Panel1: TPanel;
    TrackBar1: TTrackBar;
    btn_LoadBitmap: TButton;
    OPD: TOpenPictureDialog;
    cb_Center: TCheckBox;
    lbl_Angle: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pb_DisplayPaint(Sender: TObject);
    procedure btn_LoadBitmapClick(Sender: TObject);
    procedure cb_CenterClick(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private
    { Déclarations privées }
    Procedure SetOrgPnt;
  public
    { Déclarations publiques }
  end;

var
  frmMain: TfrmMain;

implementation
Uses  Math;
{$R *.dfm}

Type
  T2DFace = Array[0..2] Of TPoint;

//**********************************************************************
//                 Partie de code de F0xi
//**********************************************************************
  TSinCosElements = (mSin, mCos);
  TSinCosArray360 = array[TSinCosElements, 0..359] of extended; // 7200 octets

const
  cDegToRad : Extended = PI/180; // l'utilisation de constante fait partis de l'optimisation

procedure PrecalcSCA(var SCA: TSinCosArray360);
// on appel ça au debut du programme et plus de soucis.
var n : integer;
    S,C: extended;
begin
  for N := 0 to 359 do
  begin
    SinCos(N * cDegToRad, S, C);
    SCA[mSin, N] := S;
    SCA[mCos, N] := C;
  end;
end;
//**********************************************************************
//**********************************************************************

Var
    BMP : TBitmap;
    SinCosArray : TSinCosArray360;
    CenterX : Integer = 0;
    CenterY : Integer = 0;
    AnglePos : Integer = 0;
    PntArray, // servant à l'affichage avec PlgBlt
    OrgPntArray : T2DFace; //Memorise les origines de l'image
                           //Voir procedure SetOrgPnt

{Permet de charger vos images}
procedure TfrmMain.btn_LoadBitmapClick(Sender: TObject);
begin
  If OPD.Execute Then Begin
    BMP.LoadFromFile(OPD.FileName);
    SetOrgPnt;
    cb_CenterClick(Self);
    Invalidate;
  End;
end;

{Determine le centre d'affichage}
procedure TfrmMain.cb_CenterClick(Sender: TObject);
begin
  If cb_Center.Checked Then Begin
  {Centre du Display (PaintBox)}
    CenterX := pb_Display.ClientWidth Div 2;
    CenterY := pb_Display.ClientHeight Div 2;
  End
  Else Begin
  {Ou centre de l'image}
    CenterX := BMP.Width Div 2;
    CenterY := BMP.Height Div 2;
  End;
  Invalidate;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  BMP.Free;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  BMP := TBitmap.Create;
  BMP.LoadFromFile(ExtractFilePath(Application.ExeName)+'Cube.bmp');
  {Evite les scintillements}
  DoubleBuffered := True;
  {On calcule une fois pour toute les valeurs Sin & Cos
  pour les angles allant de 0 à 359 et on les places dans un tableu}
  PrecalcSCA(SinCosArray);
  {Determine les origines}
  SetOrgPnt;
  {Determine le centre}
  cb_CenterClick(Self);
end;

procedure TfrmMain.pb_DisplayPaint(Sender: TObject);
Var Value, I : Integer;
begin
  Value := TrackBar1.Position Mod 360;
  For I := 0 to 2 Do Begin
    {Calcule des positions en fonction de l'angle et des origines}
    PntArray[I].X := CenterX + Round(OrgPntArray[I].X * SinCosArray[mCos][Value] + OrgPntArray[I].Y * SinCosArray[mSin][Value]);
    PntArray[I].Y := CenterY + Round(-OrgPntArray[I].X * SinCosArray[mSin][Value] + OrgPntArray[I].Y * SinCosArray[mCos][Value]);
  End;
  {Et on affiche le résultat}
  PlgBlt(pb_Display.Canvas.Handle, PntArray, BMP.Canvas.Handle, 0, 0, BMP.Width, BMP.Height, 0, 0, 0);
end;

{Determine les origines de l'image en partant de son centre}
procedure TfrmMain.SetOrgPnt;
Var HalfWidth, HalfHeight : Integer;
begin
  HalfWidth := BMP.Width Div 2;
  HalfHeight := BMP.Height Div 2;
  OrgPntArray[0] := Point(-HalfWidth, -HalfHeight);
  OrgPntArray[1] := Point(HalfWidth, -HalfHeight);
  OrgPntArray[2] := Point(-HalfWidth, HalfHeight);
end;

procedure TfrmMain.TrackBar1Change(Sender: TObject);
Begin
  lbl_Angle.Caption := Format('Angle: %d°', [TrackBar1.Position]);
  Invalidate;
end;

end.
