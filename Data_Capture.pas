unit Data_Capture;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.ListBox, FMX.TabControl,
  FMX.DateTimeCtrls, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.ExtCtrls,
  FMX.EditBox, FMX.NumberBox, System.Rtti, FMX.Grid.Style, FMX.Grid,
  Data.Bind.Components, Data.Bind.DBScope, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Grid,
  Data.DB, Data.Win.ADODB, DateUtils, FMX.Objects;

type
  TfrmDataCapture = class(TForm)
    ToolBar1: TToolBar;
    lblHeading: TLabel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    tbcMain: TTabControl;
    tblPlaces: TTabItem;
    tblNews: TTabItem;
    tblClimates: TTabItem;
    tblTemperature: TTabItem;
    tblRainfall: TTabItem;
    Panel3: TPanel;
    lblCapture: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    pnlNews: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    edtSourceName: TEdit;
    cmbPlace: TComboBox;
    edtHeadline: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    edtSourceURL: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    dpDatePublished: TDateEdit;
    edtAuthorName: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    mmArticle: TMemo;
    Label12: TLabel;
    edtImageLocation: TEdit;
    Label13: TLabel;
    cmbProvince: TComboBox;
    Label14: TLabel;
    edtPlaceName: TEdit;
    Label15: TLabel;
    cmbClimate: TComboBox;
    Label16: TLabel;
    nbPopulation: TNumberBox;
    Label17: TLabel;
    dpDateEstablished: TDateEdit;
    Label18: TLabel;
    chkMaritime: TCheckBox;
    mmDescriptionPlace: TMemo;
    Label19: TLabel;
    Label20: TLabel;
    edtImageLocationPlace: TEdit;
    Panel1: TPanel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    cmbClimateGroup: TComboBox;
    Label26: TLabel;
    mmLongDescription: TMemo;
    Label29: TLabel;
    edtKoppenName: TEdit;
    edtKoppenCode: TEdit;
    cmbHeatLevel: TComboBox;
    Label27: TLabel;
    cmbRainfallType: TComboBox;
    Label28: TLabel;
    Label31: TLabel;
    cmbRainfallSeason: TComboBox;
    edtShortDescription: TEdit;
    Label30: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    cmbPlaceTemp: TComboBox;
    Label37: TLabel;
    Label35: TLabel;
    nbTempAvg: TNumberBox;
    Label38: TLabel;
    Label39: TLabel;
    btnAddTemp: TButton;
    GroupBox1: TGroupBox;
    nbTempHigh: TNumberBox;
    Label40: TLabel;
    Label41: TLabel;
    nbTempLow: TNumberBox;
    Label42: TLabel;
    Label43: TLabel;
    dpTempHigh: TDateEdit;
    dpTempLow: TDateEdit;
    BindingsList1: TBindingsList;
    dsTemperature: TDataSource;
    pnlBacking1: TRectangle;
    qryMain: TADOQuery;
    procedure btnCancelClick(Sender: TObject);
    procedure btnAddTempClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDataCapture: TfrmDataCapture;

implementation

{$R *.fmx}

uses Main, Data_Management, dmDB_Code, dmDB, Error_Template;

procedure TfrmDataCapture.btnAddTempClick(Sender: TObject);
var
  bValid : Boolean;
  sYear : string;
  rTemp : Real;
begin
 { // Add New Temperature
  bValid := False;
  if (StrToInt(edtYear.Text) >= 2010) and (StrToInt(edtYear.Text) <= 2022) then
    begin
        frmError.lblErrorMessage.Text := 'Data for ' + edtYear.Text +
        ' already exists. Please modify the data via the SQL terminal.';
        frmError.Show;
        pnlBacking1.Visible := True;
        bValid := False;
    end
  else
    begin
      bValid := True;
    end;

  if StrToInt(edtYear.Text) > CurrentYear then
    begin
      frmError.lblErrorMessage.Text := 'Year should be ' + IntToStr(CurrentYear) +
      ' or earlier. Please choose another year.';
      frmError.Show;
      pnlBacking1.Visible := True;
      bValid := False;
    end
  else
    begin
      bValid := True;
    end;

  if bValid = True then
    begin
      // Add new year + data into database via SQL.
       rTemp := nbTempAvg.Value;
      sYear := edtYear.Text;
      qryMain.Active := False;
      qryMain.SQL := '';
      qryMain.Active := True;
      qryMain.ExecSQL;
    end;                     }


 { qryMain.Active := False;
  qryMain.SQL := mmSQL.Lines;
  qryMain.Active := True;
  qryMain.ExecSQL;  }
end;

procedure TfrmDataCapture.btnCancelClick(Sender: TObject);
begin
  // Cancel
  frmDataCapture.Close;
end;

procedure TfrmDataCapture.btnSaveClick(Sender: TObject);
var
  sPlace_ID : string;
  sClimate_Name : string;
  sClimate_ID : string;
  sMaritime : string;
begin
  // Add to Database
  if tbcMain.ActiveTab = tblPlaces then
    begin
      // Add Data to tblPlaces
      if (edtPlaceName.Text = '') or
      (cmbProvince.Items[cmbProvince.ItemIndex] = 'Select Province') or
      (cmbClimate.Items[cmbClimate.ItemIndex] = 'Select Climate') or
      (nbPopulation.Value = 0) or (mmDescriptionPlace.Text = '') or
      (edtImageLocationPlace.Text = '') then
        begin
          frmError.lblErrorMessage.Text := 'One or more fields are missing data.' +
          ' Please populate these fields and try again.';
          frmError.Show;
          pnlBacking1.Visible := True;
        end
      else
        begin
          // ADD PLACE

          // Get Climate Name
          sClimate_Name := cmbClimate.Items[cmbClimate.ItemIndex];

          // Get Climate_ID from the Climate Name
          with dmData_Code do
            begin
              tblClimates.First;
              while not tblClimates.Eof do
                begin
                  if tblClimates['Koppen_Name'] = sClimate_Name then
                    begin
                      sClimate_ID := tblClimates['Climate_ID'];
                    end;
                  tblClimates.Next;
                end;
            end;

          // Add Place using SQL
        end;

    end;


end;

end.
