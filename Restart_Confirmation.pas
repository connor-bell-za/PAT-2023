unit Restart_Confirmation;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, Windows, ShellAPI;

type
  TfrmRestart = class(TForm)
    StyleBook1: TStyleBook;
    Label1: TLabel;
    Label2: TLabel;
    btnYes: TButton;
    btnCancel: TButton;
    pnlCover: TPanel;
    procedure btnYesClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRestart: TfrmRestart;

implementation

{$R *.fmx}

uses Main;

procedure TfrmRestart.btnCancelClick(Sender: TObject);
begin
  // CANCEL RESTART
  //frmMain.fraSettings1.pnlCover.Visible := False;
  frmMain.pnlBacking1.Visible := False;
  frmRestart.Close;
end;

procedure TfrmRestart.btnYesClick(Sender: TObject);
begin
  // RESTART APPLICATION

  ShellExecute(HWND_DESKTOP, nil, PChar('PAT2023.exe'), nil, nil, SW_SHOWNORMAL);
  Application.Terminate;
end;

end.
