unit Temperature;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMXTee.Engine, FMXTee.Series, FMXTee.Procs, FMXTee.Chart,
  FMX.Controls.Presentation, FMX.ListBox, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo, Math, System.Rtti, FMX.Grid.Style, FMX.Grid, DateUtils,
  Data.Bind.Components, Data.Bind.DBScope, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Grid, Data.DB, FMX.Colors, FMX.Objects,
  FMX.Printer, OpenAI.Chat, OpenAI.API, OpenAI.Chat.Functions,
  OpenAI.Engines, OpenAI.Completions, OpenAI, FMX.Effects, FMX.Filter.Effects;

type
  TfraClimateData = class(TFrame)
    chtMain: TChart;
    srsTemp: TLineSeries;
    srsRainfall: TLineSeries;
    lblHeading: TLabel;
    lblClimateCode: TLabel;
    lblClimateName: TLabel;
    mmClimateDescrip: TMemo;
    lblTypeRainfall: TLabel;
    lblSeasonRainfall: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    lblHeatLevel: TLabel;
    lblClimaticGroup: TLabel;
    srsTempTrend: TLineSeries;
    strAggs: TStringGrid;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    strResults: TStringGrid;
    dsTemperature: TDataSource;
    BindSourceDB1: TBindSourceDB;
    StringColumn3: TStringColumn;
    StringColumn4: TStringColumn;
    StringColumn5: TStringColumn;
    StringColumn6: TStringColumn;
    StringColumn7: TStringColumn;
    StringColumn8: TStringColumn;
    StringColumn9: TStringColumn;
    StringColumn10: TStringColumn;
    StringColumn11: TStringColumn;
    StringColumn12: TStringColumn;
    StringColumn13: TStringColumn;
    StringColumn14: TStringColumn;
    StringColumn15: TStringColumn;
    lblDataUnit: TLabel;
    lblMisc: TLabel;
    gbxPrinting: TGroupBox;
    cmbPrint: TComboBox;
    btnPrint: TButton;
    gbxExport: TGroupBox;
    cmbExport: TComboBox;
    btnExport: TButton;
    gbxGraph: TGroupBox;
    btnSave: TButton;
    cmbColours: TComboColorBox;
    btnDefault: TButton;
    Rectangle1: TRectangle;
    rectClim: TRectangle;
    dlgSave: TSaveDialog;
    dlgPrint: TPrintDialog;
    Label5: TLabel;
    lblAboutCity: TLabel;
    imgCity: TImage;
    Panel3: TPanel;
    lblPopulation: TLabel;
    lblEstablished: TLabel;
    GlowEffect1: TGlowEffect;
    mmCity: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure cmbPrintChange(Sender: TObject);
    procedure cmbExportChange(Sender: TObject);
    procedure cmbColoursChange(Sender: TObject);
    procedure btnDefaultClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure chkDiscussClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    arrTemperature : array[1..13, 1..2] of Real;
    arrRainfall : array[1..13, 1..2] of Real;
    sValues : string;
    procedure Temperature;
    procedure Rainfall;
    procedure OpenAI;

  end;

implementation

{$R *.fmx}

uses Data_Management, Main, dmDB, Climate_Frame, dmDB_Code;

procedure TfraClimateData.btnDefaultClick(Sender: TObject);
var
  txtFile : TextFile;
begin
  // Default Graph Colour
  if lblMisc.Text = 'Rainfall - Misc.' then
    begin
      // Set the default colour for Rainfall Graph
      AssignFile(txtFile, 'Rainfall_Graph_Colour.txt');
      Rewrite(txtFile);
      Writeln(txtFile, '$FF53E888');
      CloseFile(txtFile);
      srsRainfall.Color := $FF53E888;
      cmbColours.Color := $FF53E888;
    end
  else
  if lblMisc.Text = 'Temperature - Misc.' then
    begin
      // Set the default colour for Temperature Graph
      AssignFile(txtFile, 'Temperature_Graph_Colour.txt');
      Rewrite(txtFile);
      Writeln(txtFile, '$FF3571DC');
      CloseFile(txtFile);
      srsTemp.Color := $FF3571DC;
      cmbColours.Color := $FF3571DC;
    end;
end;

procedure TfraClimateData.btnExportClick(Sender: TObject);
begin
  // Export Chart
  if cmbExport.Items[cmbExport.ItemIndex] = 'Graph' then
    begin
      if dlgSave.Execute then
        begin
          chtMain.SaveToBitmapFile(dlgSave.FileName);
        end;
    end;
end;

procedure TfraClimateData.btnPrintClick(Sender: TObject);
begin
  // PRINT
  if dlgPrint.Execute then
    begin
      chtMain.PrintLandscape;
    end;
end;

procedure TfraClimateData.btnSaveClick(Sender: TObject);
var
  txtFile : TextFile;
begin
 // Change Graph Colour
  if lblMisc.Text = 'Rainfall - Misc.' then
    begin
      // Set the colour for Rainfall Graph
      AssignFile(txtFile, 'Rainfall_Graph_Colour.txt');
      Rewrite(txtFile);
      Writeln(txtFile, (cmbColours.Color));
      CloseFile(txtFile);
      srsRainfall.Color := cmbColours.Color;
    end
  else
  if lblMisc.Text = 'Temperature - Misc.' then
    begin
      // Set the colour for Temperature Graph
      AssignFile(txtFile, 'Temperature_Graph_Colour.txt');
      Rewrite(txtFile);
      Writeln(txtFile, (cmbColours.Color));
      CloseFile(txtFile);
      srsTemp.Color := cmbColours.Color;
    end;
end;

procedure TfraClimateData.Button1Click(Sender: TObject);
begin
 Temperature;
end;

procedure TfraClimateData.chkDiscussClick(Sender: TObject);
var
  txtFile : TextFile;
begin
  {if chkDiscuss.IsChecked = True then
    begin
      OpenAI;
    end;

  AssignFile(txtFile, 'Discuss.txt');
  Rewrite(txtFile);
  if chkDiscuss.IsChecked = False then
    begin
      Writeln(txtFile, 'No');
    end
  else
  if chkDiscuss.IsChecked = True then
    begin
      Writeln(txtFile, 'Yes');
    end;
  CloseFile(txtFile);
  Cursor := crHourGlass;   }

end;

procedure TfraClimateData.cmbColoursChange(Sender: TObject);
begin
  btnSave.Enabled := True;
  btnDefault.Enabled := True;
end;

procedure TfraClimateData.cmbExportChange(Sender: TObject);
begin
  btnExport.Enabled := True;
end;

procedure TfraClimateData.cmbPrintChange(Sender: TObject);
begin
  btnPrint.Enabled := True;
end;

procedure TfraClimateData.OpenAI;
var
  I, K : Integer;
begin
  // OpenAI
  sValues := '';
  for I := 0 to 12 do
    begin
      sValues := sValues + '; ' + strResults.Cells[I, 0];
    end;

  var OpenAI := TOpenAI.Create(frmMain.fraSettings1.mmKey.Lines.Text);
  var Completions := OpenAI.Completion.Create(
    procedure(Params : TCompletionParams)
      begin
        with strResults do
          begin
            if lblDataUnit.Text = '�C'  then
              begin
                Params.Prompt(sValues
                + ' are temperature values in �C for 2010 through ' +
                '2022 respectively for ' + frmMain.fraClimate1.lblLocation.Text
                + '. Using the data provided, describe the trend, and the possible future trend.');
              end
            else
              begin
                Params.Prompt(sValues
                + ' are rainfall values in millimetres for 2010 through ' +
                '2022 respectively for ' + frmMain.fraClimate1.lblLocation.Text
                + '. Using the data provided, describe the trend, and the possible future trend.');
              end;

            Params.Model('text-davinci-003');
            Params.MaxTokens(1000);
          end;
      end);

    try
      for var Choice in Completions.Choices do
        begin
          Memo1.Lines.Clear;
          Memo1.Lines.Text := Choice.Text;
           for K := Memo1.Lines.Count - 1 downto 0 do
            begin
              if Memo1.Lines[K] = '' then
                begin
                  Memo1.Lines.Delete(K);
                end;
            end;
          Break;
        end;
    finally
      Completions.Free;
    end;
end;

procedure TfraClimateData.Rainfall;
  var
  // Primary/Foreign Key Variables
  sID : string; // PLACE_ID Primary Key Variable
  sClim : string; // CLIMATE_ID Foreign Key Variable

  // Line of Best Fit Variables
  B, M : Real;

  // Colour TextFile
  txtFile : TextFile;
  sColour : string;
begin
  // UPDATE RAINFALL

  // Graph Settings/Misc. Info
  lblMisc.Text := 'Rainfall - Misc.';

  // Default Colour: $FF53E888 // GRAPH COLOUR
  AssignFile(txtFile, 'Rainfall_Graph_Colour.txt');
  Reset(txtFile);
  while not Eof(txtFile) do
    begin
      Readln(txtFile, sColour);
    end;
  CloseFile(txtFile);
  srsRainfall.Color := StrToInt64(sColour);
  cmbColours.Color := StrToInt64(sColour);

  //dmData_Code.DatabaseSetup;
  with dmData_Code do
    begin
      // Initialise variables.
      sID := '';
      sClim := '';

      // Get the PLACE_ID from the name of the place from tblPlaces.
      tblPlaces.First;
      while not tblPlaces.Eof do
        begin
          if tblPlaces['Place_Name'] = frmMain.fraClimate1.lblLocation.Text then
            begin
              sID := tblPlaces['Place_ID'];
              sClim := tblPlaces['Climate_ID'];
            end;
          tblPlaces.Next;
        end;

      // Clear the graph of existing data before plotting
      srsRainfall.Clear;

      // Find the correct location and plot the correct temperature values
      tblRainfall.First;
      while not tblRainfall.Eof do
        begin
          if tblRainfall['Place_ID'] = sID then
            begin
               with srsRainfall do
                begin
                  // Plot Rainfall Values to srsRainfall Graph for specific Location
                  AddXY(2010, tblRainfall['2010']);
                  AddXY(2011, tblRainfall['2011']);
                  AddXY(2012, tblRainfall['2012']);
                  AddXY(2013, tblRainfall['2013']);
                  AddXY(2014, tblRainfall['2014']);
                  AddXY(2015, tblRainfall['2015']);
                  AddXY(2016, tblRainfall['2016']);
                  AddXY(2017, tblRainfall['2017']);
                  AddXY(2018, tblRainfall['2018']);
                  AddXY(2019, tblRainfall['2019']);
                  AddXY(2020, tblRainfall['2020']);
                  AddXY(2021, tblRainfall['2021']);
                  AddXY(2022, tblRainfall['2022']);
                end;
            end;
            tblRainfall.Next;
        end;

        // Add Climate Data for the Specific Location Selected.
        tblClimates.First;
        while not tblClimates.Eof do
          begin
            if tblClimates['Climate_ID'] = sClim then
              begin
                lblClimateCode.Text := Copy(sClim, 1, 1) + LowerCase(Copy(sClim, 2, 2));
                lblClimateCode.FontColor := StrToInt64(tblClimates['Colour']);
                lblClimateName.Text := tblClimates['Koppen_Name'];
                lblClimateName.FontColor := StrToInt64(tblClimates['Colour']);
                mmClimateDescrip.Lines.Clear;
                mmClimateDescrip.Lines.Add(tblClimates['Long_Description']);
                lblTypeRainfall.Text := 'Rainfall Type: ' + tblClimates['Rainfall_Type'];
                lblSeasonRainfall.Text := 'Rainfall Season: ' + tblClimates['Rainfall_Season'];
                lblHeatLevel.Text := 'Heat Level: ' + tblClimates['Heat_Level'];
                lblClimaticGroup.Text := 'Climatic Group: ' + tblClimates['Climate_Group'];
              end;
            tblClimates.Next;
          end;

        // LINE OF BEST FIT
        { The Line of Best Fit Graph shows the trend of climatic data, like
        temperature or rainfall}

        // Clear Existing Line of Best Fest
        srsTempTrend.Clear;
        M := 0;
        B := 0;
        // Use 2014 and 2018 X; Y values
        M := (srsRainfall.YValue[8] - srsRainfall.YValue[4]) / (2018 - 2014);
        B := -((M) * 2018) + (srsRainfall.YValue[8]);

        // Plot Line of Best Fit on Graph
        srsTempTrend.AddXY(2010, ((M * 2010) + B));
        srsTempTrend.AddXY(2022, ((M * 2022) + B));


        // AGGREGATE FIGURES
         with strAggs do
          begin
            // Maximum Temperature
            Cells[0, 0] := 'Most:';
            Cells[1, 0] := FloatToStr(Ceil(srsRainfall.MaxYValue)) + ' mm';

            // Minimum Temperature
            Cells[0, 1] := 'Least:';
            Cells[1, 1] := FloatToStr(Ceil(srsRainfall.MinYValue)) + ' mm';

            // Average Temperature
            Cells[0, 2] := 'Average:';
            Cells[1, 2] := FloatToStr(Ceil(srsRainfall.YValues.Total / 12)) + ' mm' ;

            // Percentage Increase/Decrease in temperature over 10 years.
            Cells[1, 3] := FloatToStr(Ceil((srsRainfall.YValue[0] / srsRainfall.YValue[10]) * 100)) + '%';
            if Copy(Cells[1, 3], 1, 1) = '-' then
              begin
                // If the percentage is negative, there is a decrease.
                Cells[0, 3] := '10-year Decrease:';
              end
            else
              begin
                // If the percentage is positive, there is an increase.
                Cells[0, 3] := '10-year Increase:';
              end;

              // RECORD HIGH/LOW TEMP
              tblRainfall.First;
              while not tblRainfall.Eof do
                begin
                  if tblRainfall['Place_ID'] = sID then
                    begin
                      Cells[0, 4] := 'Record High:';
                      Cells[1, 4] := FloatToStr(Ceil(tblRainfall['Record_High'])) + ' mm - ' +
                          IntToStr(YearOf(tblRainfall['Record_High_Year']));

                     Cells[0, 5] := 'Record Low: ';
                     Cells[1, 5] := FloatToStr(Ceil(tblRainfall['Record_Low'])) + ' mm - ' +
                        IntToStr(YearOf(tblRainfall['Record_Low_Year']));

                    end;
                  tblRainfall.Next;
                end;
          end;

          // DATABASE RECORDS
          lblDataUnit.Text := 'mm';
          tblRainfall.First;
          while not tblRainfall.Eof do
            begin
              if tblRainfall['Place_ID'] = sID then
                begin
                  with strResults do
                      begin
                      // Add Temperature Values from 2010 to 2022 for specific location
                      Cells[0, 0] := tblRainfall['2010'];
                      Cells[1, 0] := tblRainfall['2011'];
                      Cells[2, 0] := tblRainfall['2012'];
                      Cells[3, 0] := tblRainfall['2013'];
                      Cells[4, 0] := tblRainfall['2014'];
                      Cells[5, 0] := tblRainfall['2015'];
                      Cells[6, 0] := tblRainfall['2016'];
                      Cells[7, 0] := tblRainfall['2017'];
                      Cells[8, 0] := tblRainfall['2018'];
                      Cells[9, 0] := tblRainfall['2019'];
                      Cells[10, 0] := tblRainfall['2020'];
                      Cells[11, 0] := tblRainfall['2021'];
                      Cells[12, 0] := tblRainfall['2022'];
                    end;
                end;
              tblRainfall.Next;
            end;
    end;
end;

procedure TfraClimateData.Temperature;
var
  // Primary/Foreign Key Variables
  sID : string; // PLACE_ID Primary Key Variable
  sClim : string; // CLIMATE_ID Foreign Key Variable

  // Line of Best Fit Variables
  B, M : Real;

  // Colour textfile
  txtFile : TextFile;
  sColour : string;
begin
  // UPDATE TEMPERATURE
  // Graph Settings/Misc. Info
  lblMisc.Text := 'Temperature - Misc.';

  // Default Colour: $FF53E888 // GRAPH COLOUR
  AssignFile(txtFile, 'Temperature_Graph_Colour.txt');
  Reset(txtFile);
  while not Eof(txtFile) do
    begin
      Readln(txtFile, sColour);
    end;
  CloseFile(txtFile);
  srsTemp.Color := StrToInt64(sColour);
  cmbColours.Color := StrToInt64(sColour);

  //dmData_Code.DatabaseSetup;
  with dmData_Code do
    begin
      // Initialise variables.
      sID := '';
      sClim := '';

      // Get the PLACE_ID from the name of the place from tblPlaces.
      tblPlaces.First;
      while not tblPlaces.Eof do
        begin
          if tblPlaces['Place_Name'] = frmMain.fraClimate1.lblLocation.Text then
            begin
              sID := tblPlaces['Place_ID'];
              sClim := tblPlaces['Climate_ID'];

            end;
          tblPlaces.Next;
        end;

      // Clear the graph of existing data before plotting
      srsTemp.Clear;

      // Find the correct location and plot the correct temperature values
      tblTemperature.First;
      while not tblTemperature.Eof do
        begin
          if tblTemperature['Place_ID'] = sID then
            begin
               with srsTemp do
                begin
                  // Plot Temperature Values to srsTemp Graph for specific Location
                  AddXY(2010, tblTemperature['2010']);
                  AddXY(2011, tblTemperature['2011']);
                  AddXY(2012, tblTemperature['2012']);
                  AddXY(2013, tblTemperature['2013']);
                  AddXY(2014, tblTemperature['2014']);
                  AddXY(2015, tblTemperature['2015']);
                  AddXY(2016, tblTemperature['2016']);
                  AddXY(2017, tblTemperature['2017']);
                  AddXY(2018, tblTemperature['2018']);
                  AddXY(2019, tblTemperature['2019']);
                  AddXY(2020, tblTemperature['2020']);
                  AddXY(2021, tblTemperature['2021']);
                  AddXY(2022, tblTemperature['2022']);
                end;
            end;
            tblTemperature.Next;
        end;

        // Add Climate Data for the Specific Location Selected.
        tblClimates.First;
        while not tblClimates.Eof do
          begin
            if tblClimates['Climate_ID'] = sClim then
              begin
                lblClimateCode.Text := Copy(sClim, 1, 1) + LowerCase(Copy(sClim, 2, 2));
                lblClimateName.Text := tblClimates['Koppen_Name'];
                //rectClim.Fill.Color := TAlphaColor($42c284);
                //rectClim.Stroke.Color :=  TAlphaColor($42c284);

                mmClimateDescrip.Lines.Clear;
                mmClimateDescrip.Lines.Add(tblClimates['Long_Description']);
                lblTypeRainfall.Text := 'Rainfall Type: ' + tblClimates['Rainfall_Type'];
                lblSeasonRainfall.Text := 'Rainfall Season: ' + tblClimates['Rainfall_Season'];
                lblHeatLevel.Text := 'Heat Level: ' + tblClimates['Heat_Level'];
                lblClimaticGroup.Text := 'Climatic Group: ' + tblClimates['Climate_Group'];
              end;
            tblClimates.Next;
          end;



        // LINE OF BEST FIT
        { The Line of Best Fit Graph shows the trend of climatic data, like
        temperature or rainfall}

        // Clear Existing Line of Best Fest
        srsTempTrend.Clear;

        // Use 2014 and 2018 X; Y values
        M := (srsTemp.YValue[8] - srsTemp.YValue[4]) / (2018 - 2014);
        B := -((M) * 2018) + (srsTemp.YValue[8]);

        // Plot Line of Best Fit on Graph
        srsTempTrend.AddXY(2010, ((M * 2010) + B));
        srsTempTrend.AddXY(2022, ((M * 2022) + B));

        // AGGREGATE FIGURES

        with strAggs do
          begin
            // Maximum Temperature
            Cells[0, 0] := 'Maximum:';
            Cells[1, 0] := FloatToStr(Ceil(srsTemp.MaxYValue)) + ' �C';

            // Minimum Temperature
            Cells[0, 1] := 'Mimumum:';
            Cells[1, 1] := FloatToStr(Ceil(srsTemp.MinYValue)) + ' �C';

            // Average Temperature
            Cells[0, 2] := 'Average:';
            Cells[1, 2] := FloatToStr(Ceil(srsTemp.YValues.Total / 12)) + ' �C' ;

            // Percentage Increase/Decrease in temperature over 10 years.
            Cells[1, 3] := FloatToStr(Ceil((srsTemp.YValue[0] / srsTemp.YValue[10]) * 100)) + '%';
            if Copy(Cells[1, 3], 1, 1) = '-' then
              begin
                // If the percentage is negative, there is a decrease.
                Cells[0, 3] := '10-year Decrease:';
              end
            else
              begin
                // If the percentage is positive, there is an increase.
                Cells[0, 3] := '10-year Increase:';
              end;

            // RECORD HIGH/LOW TEMP
            tblTemperature.First;
            while not tblTemperature.Eof do
              begin
                if tblTemperature['Place_ID'] = sID then
                  begin
                    Cells[0, 4] := 'Record High:';
                    Cells[1, 4] := FloatToStr(Ceil(tblTemperature['Record_High'])) + ' �C - ' +
                        IntToStr(YearOf(tblTemperature['Record_High_Year']));

                   Cells[0, 5] := 'Record Low: ';
                   Cells[1, 5] := FloatToStr(Ceil(tblTemperature['Record_Low'])) + ' �C - ' +
                      IntToStr(YearOf(tblTemperature['Record_Low_Year']));

                  end;
                tblTemperature.Next;
              end;


              // DATABASE RECORDS
              lblDataUnit.Text := '�C';
              tblTemperature.First;
              while not tblTemperature.Eof do
                begin
                  if tblTemperature['Place_ID'] = sID then
                    begin
                      with strResults do
                          begin
                          // Add Temperature Values from 2010 to 2022 for specific location
                          Cells[0, 0] := tblTemperature['2010'];
                          Cells[1, 0] := tblTemperature['2011'];
                          Cells[2, 0] := tblTemperature['2012'];
                          Cells[3, 0] := tblTemperature['2013'];
                          Cells[4, 0] := tblTemperature['2014'];
                          Cells[5, 0] := tblTemperature['2015'];
                          Cells[6, 0] := tblTemperature['2016'];
                          Cells[7, 0] := tblTemperature['2017'];
                          Cells[8, 0] := tblTemperature['2018'];
                          Cells[9, 0] := tblTemperature['2019'];
                          Cells[10, 0] := tblTemperature['2020'];
                          Cells[11, 0] := tblTemperature['2021'];
                          Cells[12, 0] := tblTemperature['2022'];
                        end;
                    end;
                  tblTemperature.Next;
                end;

              OpenAI
          end;
    end;
end;

end.
