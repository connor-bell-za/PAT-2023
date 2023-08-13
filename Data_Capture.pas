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
  Data.DB, Data.Win.ADODB, DateUtils, FMX.Objects, Math;

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
    procedure FormActivate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Add_Place;
  end;

var
  frmDataCapture: TfrmDataCapture;
  // Add_Place Procedure Variables
  bExists, bAdded, bValid : Boolean;
  bID, bID2 : Boolean;
  sPlaceName, sPlaceID, sProvince, sClimateName,
  sImage, sMaritime, sDescription, sDate, sPopulation, sClimateID : string;

implementation

{$R *.fmx}

uses Main, Data_Management, dmDB_Code, dmDB, Error_Template;

procedure TfrmDataCapture.Add_Place;
begin
  // ADD PLACE
  // Procedure to add a new place to the tblPlaces table of the database.

  { Validate that all components have data input. Check no data is missing.
    If data is missing, then display a warning message. }
    bValid := True;
  if (edtPlaceName.Text = '') or
     (cmbProvince.Items[cmbProvince.ItemIndex] = 'Select Province') or
     (cmbClimate.Items[cmbClimate.ItemIndex] = 'Select Climate') or
     (nbPopulation.Value = 0) or (mmDescriptionPlace.Text = '') or
     (edtImageLocationPlace.Text = '') then
    begin
      // Show Error Message Form
      frmError.lblErrorHeading.Text := 'Missing Data';
      frmError.lblErrorMessage.Text := 'One or more fields are missing data.' +
          ' Please populate these fields and try again.';
      frmError.Show;
      pnlBacking1.Visible := True;
      bValid := False;
    end
  else
    begin
      with dmData_Code do
        begin
          // All field components have data
          { Validate that the place being added does not already exist in
            the database }

          // Put field component data into string variables (For SQL)
          sPlaceName := edtPlaceName.Text;
          sProvince := cmbProvince.Items[cmbProvince.ItemIndex];
          sClimateName := cmbClimate.Items[cmbClimate.ItemIndex];
          sImage := edtImageLocationPlace.Text;
          sDate := DateToStr(dpDateEstablished.Date);
          sPopulation := FloatToStr(nbPopulation.Value);
          sDescription := mmDescriptionPlace.Text;

          // Add Maritime Status
          if chkMaritime.IsChecked = True then
            begin
              sMaritime := 'True';
            end
          else
            begin
              sMaritime := 'False';
            end;

          // Search through tblPlaces to find if the place exists.
          bExists := False;
          tblPlaces.First;
          while not tblPlaces.Eof do
            begin
              if tblPlaces['Place_Name'] = sPlaceName then
                begin
                  bExists := True;
                  Exit;
                end;
              tblPlaces.Next;
            end;

          if bExists = True then
            begin
              // The place already exists in the database. Show Error
              frmError.lblErrorHeading.Text := 'Place Already Exists';
              frmError.lblErrorMessage.Text := 'The place you tried to add' +
              ' to the database "tblPlaces" already exists as a record.' +
              ' Modify the record in the SQL command line ';
              frmError.Show;
              pnlBacking1.Visible := True;
            end
          else
            begin
              { The place does not already exist. Add the rest of the data to
                the database. }

              { Create a THREE letter, uppercase Place_ID from the place name.
                Check if it already exists. If it does, create a different one }
              bID := False;
              sPlaceID := Uppercase(Copy(sPlaceName, 1, 3));
              tblPlaces.First;
              while not tblPlaces.Eof do
                begin
                  if tblPlaces['Place_ID'] = sPlaceID then
                    begin
                      // The place ID already exists.
                      bID := True;
                    end
                  else
                    begin
                      bID := False;
                    end;
                  tblPlaces.Next;
                end;

              if bID = True then
                begin
                  { The Place_ID already exists, and the one created is not
                    unique. Try last three place name letters }
                    sPlaceID := Uppercase(Copy(sPlaceName, Length(sPlaceName) - 3, 3));
                    // Check this NEW Place_ID to be unique.
                  bID2 := False;
                  tblPlaces.First;
                  while not tblPlaces.Eof do
                    begin
                      if tblPlaces['Place_ID'] = sPlaceID then
                        begin
                          // The place ID already exists.
                          bID2 := True;
                        end
                      else
                        begin
                          bID2 := False;
                          bID := False;
                        end;
                      tblPlaces.Next;
                    end;

                  if bID2 = True then
                    begin
                      // Create a RANDOM 3 Digit Uppercase Number  //65-90
                      sPlaceID :=
                        Chr(RandomRange(65, 90)) + Chr(RandomRange(65, 90)) +
                        Chr(RandomRange(65, 90));
                        bID2 := False;
                        bID := False;
                    end;
                end;

              // If PlaceID is unique then add the record to the database
              if (bID = False) and (bID2 = False) then
              begin
                bAdded := False;
                { Get the Climate_ID from the Climate Name }
                tblClimates.First;
                while not tblClimates.Eof do
                  begin
                    if tblClimates['Koppen_Name'] = sClimateName then
                      begin
                        sClimateID := tblPlaces['Climate_ID'];
                      end;
                    tblClimates.Next;
                  end;

                { Add the Place to the database using SQL! }
                qryMain.SQL.Clear;

                // Add SQL Statement
                qryMain.SQL.Add('INSERT INTO tblPlaces (Place_ID, Place_Name' +
                ', Climate_ID, Province, Maritime, Population, ' +
                'Image_Location, Established) VALUES (' +
                sPlaceID.QuotedString + ', ' + sPlaceName.QuotedString + ', ' +
                sClimateID.QuotedString + ', ' + sProvince.QuotedString
                 + ', ' + sMaritime + ', ' + sPopulation + ', ' +
                 sImage.QuotedString + ', #' + sDate + '#' + ')');

                // Execute the SQL Query.
                qryMain.ExecSQL;
              end;
            end;
        end;
    end;
end;

procedure TfrmDataCapture.btnCancelClick(Sender: TObject);
begin
  // Cancel
  frmDataCapture.Close;
end;

procedure TfrmDataCapture.btnSaveClick(Sender: TObject);
var
  MyClass: TComponent;
begin
  if tblPlaces.IsVisible = True then
    begin
      // Add Place
      try
        // Add Place Using Add_Place procedure.
        Add_Place;
        frmError.lblErrorHeading.Text := 'Success';
        frmError.lblErrorMessage.Text := 'Successfully added ' + sPlaceName +
        ' to "tblPlaces".';
        frmError.Rectangle1.Fill.Color := TAlphaColorRec.Limegreen;
        frmError.Rectangle1.Stroke.Color := TAlphaColorRec.Limegreen;
        frmError.Show;
        pnlBacking1.Visible := True;
      except
        // Error
        frmError.lblErrorHeading.Text := 'Error';
        frmError.lblErrorMessage.Text := 'An error occurred trying to add data '
        + 'to "tblPlaces". Ensure that all data capture fields are populated and '
        + 'that the place does not already exist.';
        frmError.lblErrorMessage.TextSettings.Font.Size := 14;
        frmError.Show;
        frmError.Rectangle1.Fill.Color := TAlphaColorRec.Red;
        frmError.Rectangle1.Stroke.Color := TAlphaColorRec.Red;
        pnlBacking1.Visible := True;
      end;
    end;
end;

procedure TfrmDataCapture.FormActivate(Sender: TObject);
begin
  // Add Climates to Climate Combobox
  with dmData_Code do
    begin
      tblClimates.First;
      while not tblClimates.Eof do
        begin
          cmbClimate.Items.Add(tblClimates['Koppen_Name']);
          tblClimates.Next;
        end;
    end;
end;

end.
