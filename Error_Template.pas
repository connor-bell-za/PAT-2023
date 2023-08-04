unit Error_Template;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Effects;

type
  TfrmError = class(TForm)
    lblErrorHeading: TLabel;
    lblErrorMessage: TLabel;
    Rectangle1: TRectangle;
    pnlBase: TPanel;
    btnCancel: TButton;
    StyleBook1: TStyleBook;
    ShadowEffect1: TShadowEffect;
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmError: TfrmError;

implementation

{$R *.fmx}

uses Main, Data_Management, Login, Data_Capture;

procedure TfrmError.btnCancelClick(Sender: TObject);
begin
  frmMain.pnlBacking1.Visible := False;
  frmDataCapture.pnlBacking1.Visible := False;
  frmError.Close;
end;

end.
