unit Data_Capture;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.ListBox;

type
  TfrmDataCapture = class(TForm)
    ToolBar1: TToolBar;
    lblHeading: TLabel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    Panel3: TPanel;
    lblCapture: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtPlaceID: TEdit;
    edtName: TEdit;
    cmbClimate: TComboBox;
    Edit1: TEdit;
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDataCapture: TfrmDataCapture;

implementation

{$R *.fmx}

uses Main, Data_Management;

procedure TfrmDataCapture.btnCancelClick(Sender: TObject);
begin
  // Cancel
  frmDataCapture.Close;
end;

end.
