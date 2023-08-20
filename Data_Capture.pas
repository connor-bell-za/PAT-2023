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
    gbxRecordsTemp: TGroupBox;
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
    chkEvent: TCheckBox;
    strTempData: TStringGrid;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    btnReset: TButton;
    pnlTemp: TPanel;
    Panel2: TPanel;
    Label36: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    cmbPlaceRain: TComboBox;
    Label44: TLabel;
    Label45: TLabel;
    gbxRecordRain: TGroupBox;
    nbRainMost: TNumberBox;
    Label46: TLabel;
    Label47: TLabel;
    nbRainLeast: TNumberBox;
    Label48: TLabel;
    Label49: TLabel;
    dpRainMost: TDateEdit;
    dpRainLeast: TDateEdit;
    strRainData: TStringGrid;
    StringColumn3: TStringColumn;
    StringColumn4: TStringColumn;
    btnResetRainSheet: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure cmbPlaceTempChange(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnResetRainSheetClick(Sender: TObject);
    procedure cmbPlaceRainChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    arrTemps : array[0..12] of Real;
    arrRainfall : array[0..12] of Real;
    procedure Add_Place;
    procedure Add_News;
    procedure Add_Temp;
    procedure Add_Rain;
    procedure Add_Climate;
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

procedure TfrmDataCapture.Add_Climate;
var
  sHeatLevel, sGroup, sRainfallType, sRainfallSeason : string;
  sCode, sShortDescrip : string;
  sLongDescrip : AnsiString;
  sName : string;
  bExists : Boolean;
begin
  // Add Climate to the database

  // Ensure no data is missing!
  if (edtKoppenName.Text.IsEmpty = True) or (edtKoppenCode.Text.IsEmpty = True)
  or (edtShortDescription.Text.IsEmpty = True) or
  (mmLongDescription.Text.IsEmpty = True) or (cmbClimateGroup.ItemIndex = 0)
  or (cmbHeatLevel.ItemIndex = 0) or (cmbRainfallType.ItemIndex = 0) or
  (cmbRainfallSeason.ItemIndex = 0) then
    begin
      // Information is missing, tell the user to sit in the naughty corner!
      // Display error message
      frmError.lblErrorHeading.Text := 'Missing Data';
      frmError.lblErrorMessage.Text := 'One or more fields are missing data.' +
          ' Please populate these fields and try again.';
      frmError.Show;
      pnlBacking1.Visible := True;
    end
  else
    begin
      // The user is good, all fields are populated!
      bExists := False;
      // Put the populated fields into the variables
      sName := edtKoppenName.Text;
      sCode := Uppercase(edtKoppenCode.Text);
      sShortDescrip := edtShortDescription.Text;
      sLongDescrip := mmLongDescription.Text;
      sHeatLevel := cmbHeatLevel.Items[cmbHeatLevel.ItemIndex];
      sGroup := cmbClimateGroup.Items[cmbClimateGroup.ItemIndex];
      sRainfallType :=  cmbRainfallType.Items[cmbRainfallType.ItemIndex];
      sRainfallSeason := cmbRainfallSeason.Items[cmbRainfallSeason.ItemIndex];

      // Check that there isn't already this type of climate in the database!
      with dmData_Code do
        begin
          tblClimates.First;
          while not tblClimates.Eof do
            begin
              if tblClimates['Climate_ID'] = sCode then
                begin
                  // Oh no! There is already a climate like this one in the database!
                  bExists := True;
                  Exit;
                end;
              tblClimates.Next;
            end;
        end;

      if bExists = True then
        begin
          // Climate already exists, tell the user off.
          frmError.lblErrorHeading.Text := 'Conflicting Data';
          frmError.lblErrorMessage.Text := 'The climate - ' + QuotedStr(sCode) +
          ' already exists. Please add a new climate';
          frmError.Show;
          pnlBacking1.Visible := True;
        end
      else
      if bExists = False then
        begin
          // The climate does not already exist!
          // Lets add it to the database!
          with dmData_Code do
            begin
              tblClimates.Insert;
              tblClimates['Climate_ID'] := sCode;
              tblClimates['Koppen_Name'] := sName;
              tblClimates['Short_Description'] := sShortDescrip;
              tblClimates['Rainfall_Season'] := sRainfallSeason;
              tblClimates['Heat_Level'] := sHeatLevel;
              tblClimates['Rainfall_Type'] := sRainfallType;
              tblClimates['Climate_Group'] := sGroup;
              tblClimates['Long_Description'] := sLongDescrip;
              tblClimates.Post;
            end;

          // Congratulate the user
          // Show success message!
           frmError.lblErrorHeading.Text := 'Success';
           frmError.lblErrorMessage.Text := 'Successfully added the climate ' +
           QuotedStr(sCode) +' to tblClimates.';
           frmError.Rectangle1.Fill.Color := TAlphaColorRec.Limegreen;
           frmError.Rectangle1.Stroke.Color := TAlphaColorRec.Limegreen;
           frmError.Show;
           pnlBacking1.Visible := True;
        end;
    end;

end;

procedure TfrmDataCapture.Add_News;
var
  sArticle : AnsiString;
  sURL, sSourceName, sAuthor, sImageLoc, sPlaceName, sPlace_ID,
  sHeadline, sMajor : string;
  dDatePub : TDate;

  // ARRAY
  arrDates : array[1..6] of TDate;
  I, iVal : Integer;
  iLow: Integer;
  bFind: Boolean;
  iRecNo: Integer;
begin
  // ADD NEWS
  // Procedure to add a new news article to the tblNews table of the database.

  if (edtSourceName.Text.IsEmpty = True) or (edtSourceURL.Text.IsEmpty = True)
  or (edtAuthorName.Text.IsEmpty = True) or (edtHeadline.Text.IsEmpty = True)
  or (edtImageLocation.Text.IsEmpty = True) or (mmArticle.Text.IsEmpty = True)
  or (cmbPlace.Items[cmbPlace.ItemIndex] = 'Select Place Name') then
    begin
      // One or more fields are missing - show an error message
      frmError.lblErrorHeading.Text := 'Missing Data';
      frmError.lblErrorMessage.Text := 'One or more fields are missing data.' +
          ' Please populate these fields and try again.';
      frmError.Show;
      pnlBacking1.Visible := True;
    end
  else
    begin
      // No fields are missing - add fields to variables.
      sURL := edtSourceURL.Text;
      sSourceName := edtSourceName.Text;
      sAuthor := edtAuthorName.Text;
      sHeadline := edtHeadline.Text;
      sImageLoc := edtImageLocation.Text;
      sPlaceName := cmbPlace.Items[cmbPlace.ItemIndex];
      sArticle := mmArticle.Text;
      dDatePub := dpDatePublished.Date;

      // Get event status
      if chkEvent.IsChecked then
        sMajor := 'True'
      else
        sMajor := 'False';

      with dmData_Code do
        begin
          // Get the Place_ID from the place name
          tblPlaces.First;
          while not tblPlaces.Eof do
            begin
              if tblPlaces['Place_Name'] = sPlaceName then
                begin
                  sPlace_ID := tblPlaces['Place_ID'];
                end;
              tblPlaces.Next;
            end;

          // The system only allows for 5 news articles at a time -
          // so delete the oldest one, and tell the user this happened.
          if tblNews.RecordCount = 5 then
            begin
              // Put all the dates into an array, so that we can find the min/max
              tblNews.First;
              I := 1;
              while not (tblNews.Eof) do
                begin
                  arrDates[I] := tblNews['Date_Published'];
                  Inc(I);
                  tblNews.Next;
                end;

              // Get the oldest date - this is the date field we will delete
              iLow := 1;
              for I := 2 to 5 do
                begin
                  if arrDates[I] < arrDates[iLow] then
                    begin
                      iLow := I;
                    end;
                end;


              bFind := False;
              tblNews.First;
              while (not tblNews.Eof) and (bFind <> True) do
                begin
                  if tblNews['Date_Published'] = arrDates[iLow] then
                    begin
                      bFind := True;
                      iRecNo := tblNews.RecNo;
                    end;
                  tblNews.Next;
                end;
              tblNews.RecNo := iRecNo;
              tblNews.Delete;

              // Now add the record that needs to be added!
              tblNews.Insert;
              tblNews['Place_ID'] := sPlace_ID;
              tblNews['Article_Headline'] := sHeadline;
              tblNews['Source'] := sURL;
              tblNews['Date_Published'] := dDatePub;
              tblNews['Author'] := sAuthor;
              tblNews['Source_Name'] := sSourceName;
              tblNews['Major_Event'] := sMajor;
              tblNews['Article_Body'] := sArticle;
              tblNews['Image_Location'] := sImageLoc;
              tblNews.Post;

              // Tell the user that one of the older records was deleted!
              frmError.lblErrorHeading.Text := 'Notice';
              frmError.lblErrorMessage.Font.Size := 14;
              frmError.lblErrorMessage.Text := 'Because the system only holds ' +
              'FIVE news articles at a time, the oldest one was deleted in order ' +
              ' to add this one.';
              frmError.Rectangle1.Fill.Color := TAlphaColors.Orange;
              frmError.Rectangle1.Stroke.Color := TAlphaColors.Orange;
              frmError.Show;
              pnlBacking1.Visible := True;

              // Show success message!
               frmError.lblErrorHeading.Text := 'Success';
               frmError.lblErrorMessage.Text := 'Successfully added ' +
               QuotedStr(sHeadline) +
               ' to tblNews.';
               frmError.Rectangle1.Fill.Color := TAlphaColorRec.Limegreen;
               frmError.Rectangle1.Stroke.Color := TAlphaColorRec.Limegreen;
               frmError.Show;
               pnlBacking1.Visible := True;
            end
          else
            if tblNews.RecordCount < 5 then
              begin
                // If there are less than five records, we can add the article
                // without having to delete other articles.
                tblNews.Insert;
                tblNews['Place_ID'] := sPlace_ID;
                tblNews['Article_Headline'] := sHeadline;
                tblNews['Source'] := sURL;
                tblNews['Date_Published'] := dDatePub;
                tblNews['Author'] := sAuthor;
                tblNews['Source_Name'] := sSourceName;
                tblNews['Major_Event'] := sMajor;
                tblNews['Article_Body'] := sArticle;
                tblNews['Image_Location'] := sImageLoc;
                tblNews.Post;

                // Show Success message!
                 frmError.lblErrorHeading.Text := 'Success';
                frmError.lblErrorMessage.Text := 'Successfully added '
                + QuotedStr(sHeadline)+
                ' to tblNews.';
                frmError.Rectangle1.Fill.Color := TAlphaColorRec.Limegreen;
                frmError.Rectangle1.Stroke.Color := TAlphaColorRec.Limegreen;
                frmError.Show;
                pnlBacking1.Visible := True;
              end;
        end;
    end;
end;

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

                frmError.lblErrorHeading.Text := 'Success';
                frmError.lblErrorMessage.Text := 'Successfully added ' + sPlaceName +
                ' to "tblPlaces".';
                frmError.Rectangle1.Fill.Color := TAlphaColorRec.Limegreen;
                frmError.Rectangle1.Stroke.Color := TAlphaColorRec.Limegreen;
                frmError.Show;
                pnlBacking1.Visible := True;
              end;
            end;
        end;
    end;
end;

procedure TfrmDataCapture.Add_Rain;
var
  I : Integer;
  rMax, rMin : Real;
  dMax, dMin : TDate;
  sPlace, sPlace_ID : string;
  bValid : Boolean;
begin
  // Add rainfall data
    bValid := True;
    // Try add floating point values to array, and if fail, show error
    // *VALIDATION*
    for I := 0 to 12 do
      begin
        try
          arrRainfall[I] := StrToFloat(strRainData.Cells[1, I]);
        except
          bValid := False;
          frmError.lblErrorHeading.Text := 'Error';
          frmError.lblErrorMessage.Font.Size := 18;
          frmError.lblErrorMessage.Text := 'Please only enter floating-point numbers ' +
          ' for rainfall values';
          pnlBacking1.Visible := True;
          frmError.Show;
          Exit;
        end;
      end;

   if bValid = True then
      begin
        // Get rainfall record information
        rMax := nbRainMost.Value;
        rMin := nbRainLeast.Value;
        dMax := dpRainMost.Date;
        dMin := dpRainLeast.Date;

        // First we need to get the Place_ID from the Place_Name
        sPlace := cmbPlaceRain.Items[cmbPlaceRain.ItemIndex];
        with dmData_Code do
          begin
            tblPlaces.First;
            while not tblPlaces.Eof do
              begin
                if sPlace = tblPlaces['Place_Name'] then
                  begin
                    sPlace_ID := tblPlaces['Place_ID'];
                  end;
                tblPlaces.Next;
              end;
          end;

        // Then add data to tblRainfall Database
        with dmData_Code do
          begin
            tblRainfall.Insert;
            tblRainfall['Place_ID'] := sPlace_ID;
            tblRainfall['Record_High'] := rMax;
            tblRainfall['Record_High_Year'] := dMax;
            tblRainfall['Record_Low'] := rMin;
            tblRainfall['Record_Low_Year'] := dMin;
            tblRainfall['2010'] := arrRainfall[0];
            tblRainfall['2011'] := arrRainfall[1];
            tblRainfall['2012'] := arrRainfall[2];
            tblRainfall['2013'] := arrRainfall[3];
            tblRainfall['2014'] := arrRainfall[4];
            tblRainfall['2015'] := arrRainfall[5];
            tblRainfall['2016'] := arrRainfall[6];
            tblRainfall['2017'] := arrRainfall[7];
            tblRainfall['2018'] := arrRainfall[8];
            tblRainfall['2019'] := arrRainfall[9];
            tblRainfall['2020'] := arrRainfall[10];
            tblRainfall['2021'] := arrRainfall[11];
            tblRainfall['2022'] := arrRainfall[12];
            tblRainfall.Post;

            // Show Success Message when record is added
            frmError.lblErrorHeading.Text := 'Success';
            frmError.lblErrorMessage.Text := 'Successfully added rainfall data '
              + 'for ' + QuotedStr(sPlace) + ' to tblRainfall';
            frmError.Rectangle1.Fill.Color := TAlphaColorRec.Limegreen;
            frmError.Rectangle1.Stroke.Color := TAlphaColorRec.Limegreen;
            frmError.Show;
            pnlBacking1.Visible := True;
          end;
      end;
end;

procedure TfrmDataCapture.Add_Temp;
var
  I : Integer;
  rMax, rMin : Real;
  dMax, dMin : TDate;
  sPlace, sPlace_ID : string;
  bValid : Boolean;
begin
  // Add temperature data
    bValid := True;
    // Try add floating point values to array, and if fail, show error
    // *VALIDATION*
    for I := 0 to 12 do
      begin
        try
          arrTemps[I] := StrToFloat(strTempData.Cells[1, I]);
        except
          bValid := False;
          frmError.lblErrorHeading.Text := 'Error';
          frmError.lblErrorMessage.Font.Size := 18;
          frmError.lblErrorMessage.Text := 'Please only enter floating-point numbers ' +
          ' for temperature values';
          pnlBacking1.Visible := True;
          frmError.Show;
          Exit;
        end;
      end;

   if bValid = True then
      begin
        // Get temperature record information
        rMax := nbTempHigh.Value;
        rMin := nbTempLow.Value;
        dMax := dpTempHigh.Date;
        dMin := dpTempLow.Date;

        // First we need to get the Place_ID from the Place_Name
        sPlace := cmbPlaceTemp.Items[cmbPlaceTemp.ItemIndex];
        with dmData_Code do
          begin
            tblPlaces.First;
            while not tblPlaces.Eof do
              begin
                if sPlace = tblPlaces['Place_Name'] then
                  begin
                    sPlace_ID := tblPlaces['Place_ID'];
                  end;
                tblPlaces.Next;
              end;
          end;

        // Then add data to tblTemperature Database
        with dmData_Code do
          begin
            tblTemperature.Insert;
            tblTemperature['Place_ID'] := sPlace_ID;
            tblTemperature['Record_High'] := rMax;
            tblTemperature['Record_High_Year'] := dMax;
            tblTemperature['Record_Low'] := rMin;
            tblTemperature['Record_Low_Year'] := dMin;
            tblTemperature['2010'] := arrTemps[0];
            tblTemperature['2011'] := arrTemps[1];
            tblTemperature['2012'] := arrTemps[2];
            tblTemperature['2013'] := arrTemps[3];
            tblTemperature['2014'] := arrTemps[4];
            tblTemperature['2015'] := arrTemps[5];
            tblTemperature['2016'] := arrTemps[6];
            tblTemperature['2017'] := arrTemps[7];
            tblTemperature['2018'] := arrTemps[8];
            tblTemperature['2019'] := arrTemps[9];
            tblTemperature['2020'] := arrTemps[10];
            tblTemperature['2021'] := arrTemps[11];
            tblTemperature['2022'] := arrTemps[12];
            tblTemperature.Post;

            // Show Success Message when record is added
            frmError.lblErrorHeading.Text := 'Success';
            frmError.lblErrorMessage.Text := 'Successfully added temperature data '
              + 'for ' + QuotedStr(sPlace) + ' to tblTemperature';
            frmError.Rectangle1.Fill.Color := TAlphaColorRec.Limegreen;
            frmError.Rectangle1.Stroke.Color := TAlphaColorRec.Limegreen;
            frmError.Show;
            pnlBacking1.Visible := True;
          end;
      end;
end;

procedure TfrmDataCapture.btnCancelClick(Sender: TObject);
begin
  // Cancel
  frmDataCapture.Close;
end;

procedure TfrmDataCapture.btnResetClick(Sender: TObject);
var
  I : Integer;
begin
  // Reset strTemp with blank values!
  with strTempData do
    begin
      for I := 0 to 12 do
        begin
          Cells[1, I] := '';
        end;
    end;
end;

procedure TfrmDataCapture.btnResetRainSheetClick(Sender: TObject);
var
  I : Integer;
begin
   // Reset strRain with blank values!
  with strRainData do
    begin
      for I := 0 to 12 do
        begin
          Cells[1, I] := '';
        end;
    end;
end;

procedure TfrmDataCapture.btnSaveClick(Sender: TObject);
begin
  if tbcMain.ActiveTab = tblPlaces then
    begin
      // Add Place
      // Add Place Using Add_Place procedure.
      Add_Place;
    end
  else
  if tbcMain.ActiveTab = tblNews then
    begin
      // Add News Article Using Add_News procedure
      Add_News;
    end
  else
  if tbcMain.ActiveTab = tblTemperature then
    begin
      // Add Temperature Data using Add_Temp procedure
      Add_Temp;
    end
  else
  if tbcMain.ActiveTab = tblRainfall then
    begin
      // Add Rainfall Data using Add_Rainfall procedure
      Add_Rain;
    end
  else
  if tbcMain.ActiveTab = tblClimates then
    begin
      // Add Climate Data using Add_Climate procedure
      Add_Climate;
    end;
end;

procedure TfrmDataCapture.cmbPlaceRainChange(Sender: TObject);
var
  sPlace : string;
  sPlace_ID : string;
  bValid : Boolean;
begin
  // Get the place!!
  sPlace := cmbPlaceRain.Items[cmbPlaceRain.ItemIndex];
  bValid := False;
  with dmData_Code do
    begin
      tblPlaces.First;
      while not tblPlaces.Eof do
        begin
          if sPlace = tblPlaces['Place_Name'] then
            begin
              sPlace_ID := tblPlaces['Place_ID'];
            end;
          tblPlaces.Next;
        end;

      // Ensure that the place does not already have data stored in tblRain
      tblRainfall.First;
      while not tblRainfall.Eof do
        begin
          if tblRainfall['Place_ID'] = sPlace_ID then
            begin
              // A place already exists with rainfall data!
              frmError.lblErrorHeading.Text := 'Error';
              frmError.lblErrorMessage.Font.Size := 16;
              frmError.lblErrorMessage.Text := sPlace + ' already has rainfall data.' +
              #13 + 'Please select a different place and try again.';
              pnlBacking1.Visible := True;
              frmError.Show;
              gbxRecordRain.Enabled := False;
              strRainData.Enabled := False;
              btnResetRainSheet.Enabled := False;
              bValid := False;
              Exit;
            end
          else
            begin
               bValid := True;
            end;
          tblRainfall.Next;
        end;

      if bValid = True then
        begin
          // Place does not have existing data
          // Enable components
          gbxRecordRain.Enabled := True;
          strRainData.Enabled := True;
          btnResetRainSheet.Enabled := True;

          // Set up data input grid
          with strRainData do
            begin
              RowCount := 13;
              Cells[0, 0] := '2010';
              Cells[0, 1] := '2011';
              Cells[0, 2] := '2012';
              Cells[0, 3] := '2013';
              Cells[0, 4] := '2014';
              Cells[0, 5] := '2015';
              Cells[0, 6] := '2016';
              Cells[0, 7] := '2017';
              Cells[0, 8] := '2018';
              Cells[0, 9] := '2019';
              Cells[0, 10] := '2020';
              Cells[0, 11] := '2021';
              Cells[0, 12] := '2022';
            end;
        end;
    end;
end;

procedure TfrmDataCapture.cmbPlaceTempChange(Sender: TObject);
var
  sPlace : string;
  sPlace_ID : string;
  bValid : Boolean;
begin
  // Get the place!!
  sPlace := cmbPlaceTemp.Items[cmbPlaceTemp.ItemIndex];
  bValid := False;
  with dmData_Code do
    begin
      tblPlaces.First;
      while not tblPlaces.Eof do
        begin
          if sPlace = tblPlaces['Place_Name'] then
            begin
              sPlace_ID := tblPlaces['Place_ID'];
            end;
          tblPlaces.Next;
        end;

      // Ensure that the place does not already have data stored in tblTemp
      tblTemperature.First;
      while not tblTemperature.Eof do
        begin
          if tblTemperature['Place_ID'] = sPlace_ID then
            begin
              // A place already exists with temperature data!
              frmError.lblErrorHeading.Text := 'Error';
              frmError.lblErrorMessage.Font.Size := 16;
              frmError.lblErrorMessage.Text := sPlace + ' already has temperature data.' +
              #13 + 'Please select a different place and try again.';
              pnlBacking1.Visible := True;
              frmError.Show;
              gbxRecordsTemp.Enabled := False;
              strTempData.Enabled := False;
              btnReset.Enabled := False;
              bValid := False;
              Exit;
            end
          else
            begin
               bValid := True;
            end;
          tblTemperature.Next;
        end;

      if bValid = True then
        begin
          // Place does not have existing data
          // Enable components
          gbxRecordsTemp.Enabled := True;
          strTempData.Enabled := True;
          btnReset.Enabled := True;

          // Temperature Tab Click
          // Set up data input grid
          with strTempData do
            begin
              RowCount := 13;
              Cells[0, 0] := '2010';
              Cells[0, 1] := '2011';
              Cells[0, 2] := '2012';
              Cells[0, 3] := '2013';
              Cells[0, 4] := '2014';
              Cells[0, 5] := '2015';
              Cells[0, 6] := '2016';
              Cells[0, 7] := '2017';
              Cells[0, 8] := '2018';
              Cells[0, 9] := '2019';
              Cells[0, 10] := '2020';
              Cells[0, 11] := '2021';
              Cells[0, 12] := '2022';
            end;
        end
      else
        begin
          // Disable Components
          gbxRecordsTemp.Enabled := False;
          strTempData.Enabled := False;
          btnReset.Enabled := False;
        end;
    end;
end;

procedure TfrmDataCapture.FormActivate(Sender: TObject);
var
  bVal : Boolean;
begin
  // Add Data to combo boxes
  with dmData_Code do
    begin
      tblClimates.First;
      while not tblClimates.Eof do
        begin
          cmbClimate.Items.Add(tblClimates['Koppen_Name']);
          tblClimates.Next;
        end;

      tblPlaces.First;
      while not tblPlaces.Eof do
        begin
          cmbPlace.Items.Add(tblPlaces['Place_Name']);
          tblPlaces.Next;
        end;

      cmbPlaceTemp.Clear;
      cmbPlaceTemp.Items.Add('Select Place Name');
      cmbPlaceTemp.ItemIndex := 0;
      tblPlaces.First;
      while not tblPlaces.Eof do
        begin
          cmbPlaceTemp.Items.Add(tblPlaces['Place_Name']);
          tblPlaces.Next;
        end;

      cmbPlaceRain.Clear;
      cmbPlaceRain.Items.Add('Select Place Name');
      cmbPlaceRain.ItemIndex := 0;
      tblPlaces.First;
      while not tblPlaces.Eof do
        begin
          cmbPlaceRain.Items.Add(tblPlaces['Place_Name']);
          tblPlaces.Next;
        end;

      // Disable components
      gbxRecordsTemp.Enabled := False;
      gbxRecordRain.Enabled := False;
      strRainData.Enabled := False;
      strTempData.Enabled := False;
      btnReset.Enabled := False;
      btnResetRainSheet.Enabled := False;
    end;
end;

end.
