unit Login;
{ Login Frame }

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, FMX.EditBox, FMX.NumberBox, FMX.Edit,
  FMX.Filter.Effects, FMX.Objects, Account_Access, Error_Template;

type
  TfraDataAccess = class(TFrame)
    imgBackground: TImage;
    pnlBack: TPanel;
    pnlAggrs: TPanel;
    lblHeading: TLabel;
    pnlID: TPanel;
    edtPassword: TEdit;
    edtID: TEdit;
    btnLogin: TImage;
    lblDate: TLabel;
    lblTime: TLabel;
    tmrDateTime: TTimer;
    effGlow: TGlowEffect;
    procedure btnLoginClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure tmrDateTimeTimer(Sender: TObject);
    procedure btnLoginMouseEnter(Sender: TObject);
    procedure btnLoginMouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sEmplid : string;
    Account_Access : TAccount_Access;
  end;

implementation

{$R *.fmx}

uses Main, Data_Management;

procedure TfraDataAccess.btnLoginClick(Sender: TObject);
begin
  // Login Click
  frmMain.scrbxDataMan.Visible := True;
  frmMain.scrbxLogin.Visible := False;
end;

procedure TfraDataAccess.btnLoginMouseEnter(Sender: TObject);
begin
  // Glow Effect
  effGlow.Enabled := True;
end;

procedure TfraDataAccess.btnLoginMouseLeave(Sender: TObject);
begin
  // Glow Effect
  effGlow.Enabled := False;
end;

procedure TfraDataAccess.Image1Click(Sender: TObject);
var
  txtFile : TextFile;
  sLine, sPassword : string;
  iEmplid, iErrorCode, iNumber : Integer;

begin
  // LOGIN to DATA MANAGEMENT PORTAL
  // Check that the text file exists
  if Account_Access.File_Exists = False then
    begin
      frmMain.pnlBacking1.Visible := True;
      frmError.Show;
      frmError.lblErrorHeading.Text := 'Fatal Error';
      frmError.lblErrorMessage.Text
      := 'The crucial system file "Account.txt" cannot be located. Contact the Developer.';
      edtID.SetFocus;
    end
  else
    begin
      // Digit Check
      { Use the Val procedure to check if only digits are entered }
      Val(edtID.Text, iNumber, iErrorCode);
      if iErrorCode <> 0 then
        begin
          frmMain.pnlBacking1.Visible := True;
          frmError.Show;
          frmError.lblErrorMessage.Text
          := 'Emplid can only contain numbers. Please Try Again';
          edtID.SetFocus;
        end
      else
        begin
        // Presence Check
        if (Length(edtID.Text) > 0) and (Length(edtPassword.Text) > 0) then
          begin
            if Length(edtID.Text) <= 4 then
              begin
                iEmplid := StrToInt(edtID.Text);
                sPassword := edtPassword.Text;
                Account_Access := TAccount_Access.Create(iEmplid, sPassword);
                Account_Access.Read_File;

                // Validate Credentials
                if Account_Access.Validate = True then
                  begin
                    with frmMain do
                      begin
                        // If correct account details where entered.
                        edtID.SetFocus;
                        scrbxLogin.Visible := False;
                        scrbxDataMan.Visible := True;
                        sEmplid := edtID.Text;

                        // Clear Fields for Next Login
                        edtPassword.Text := '';
                        edtID.Text := '';

                        // Update Database Information for Help
                        fraDataMan1.dbInfo;
                      end;
                  end
                else
                if Account_Access.Validate = False then
                  begin
                    // If Incorrect Account Details were entered,
                    // show error message
                    frmMain.pnlBacking1.Visible := True;
                    frmError.Show;
                    frmError.lblErrorMessage.Text
                    := 'Incorrect Emplid or Password. Please Try Again.';
                    edtID.SetFocus;
                  end;
              end
            else
              begin
                // Range Check
                frmMain.pnlBacking1.Visible := True;
                frmError.Show;
                frmError.lblErrorMessage.Text
                  := 'Enter only a 4-Digit Emplid and Try Again.';
                edtID.SetFocus;
              end;
          end
        else
          begin
            frmMain.pnlBacking1.Visible := True;
            frmError.Show;
            frmError.lblErrorMessage.Text
                  := 'No Emplid or Password Entered. Please Try Again.';
            edtID.SetFocus;
          end;
        end;
    end;
end;

procedure TfraDataAccess.tmrDateTimeTimer(Sender: TObject);
begin
  // Set Date Time on Login
  lblDate.Text := FormatDateTime('dddd, d mmmm yyyy', Now);
  lblTime.Text := FormatDateTime('t', Now);
end;

end.

{ (C) 2023 Connor Bell }
