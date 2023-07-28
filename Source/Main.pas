unit Main;

{ - dmMain = dmData.pas = The DataModule that contains the API components.
  - dmData_Code = dmDB_Code.pas = The DataModule that contains the Database
  (DB) components. }

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.MultiView, FMX.Layouts, FMX.ListBox,
  System.ImageList, FMX.ImgList, FMX.TabControl, FMX.Styles.Objects,
  Weather_Frame, Settings, Climate_Frame, DateUtils, Temperature, FMX.Objects,
  WinInet,
  FMX.Styles, About, ShellAPI, Windows, System.Actions, FMX.ActnList,
  Login, Data_Management, Climate_Action;

type
  TfrmMain = class(TForm)
    GridLayout1: TGridLayout;
    MultiView1: TMultiView;
    btnMenu: TSpeedButton;
    btnSettings: TSpeedButton;
    ImageList1: TImageList;
    btnAbout: TSpeedButton;
    ToolBar1: TToolBar;
    btnUpdate: TSpeedButton;
    scrbxWeather: TScrollBox;
    scrlbxSettings: TScrollBox;
    fraSettings1: TfraSettings;
    btnWeather: TSpeedButton;
    btnClimateAnalysis: TSpeedButton;
    btnClimateReduction: TSpeedButton;
    scrlbxClimate: TScrollBox;
    fraClimate1: TfraClimate;
    btnAdmin: TSpeedButton;
    lblUpdateStatus: TLabel;
    lblHeadingMain: TLabel;
    btnBack: TSpeedButton;
    tLastUpdated: TTimer;
    fraWeather1: TfraWeather;
    sbStyles: TStyleBook;
    scrlbxAbout: TScrollBox;
    fraAbout1: TfraAbout;
    btnApply: TSpeedButton;
    btnRestart: TSpeedButton;
    ActionList1: TActionList;
    scrbxLogin: TScrollBox;
    fraDataAccess1: TfraDataAccess;
    scrbxDataMan: TScrollBox;
    fraDataMan1: TfraDataMan;
    scrbxAction: TScrollBox;
    fraAction1: TfraAction;
    pnlBacking: TPanel;
    pnlBacking1: TRectangle;
    procedure btnSettingsClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure MultiView1Click(Sender: TObject);
    procedure btnWeatherClick(Sender: TObject);
    procedure tLastUpdatedTimer(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnClimateAnalysisClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnRestartClick(Sender: TObject);
    procedure btnAdminClick(Sender: TObject);
    procedure btnClimateReductionClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    // Last Updated Var
    tStatus, tUpdated: TTime;

    // Procedures
    procedure UpdateWeather;
    procedure OpenLink;
    procedure UpdateNews;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses dmData, Restart_Confirmation, dmDB,
  dmDB_Code, Error_Template, Data_Capture, About_City;

procedure TfrmMain.btnAdminClick(Sender: TObject);
begin
  // ADMIN LOGIN // DATA MANAGEMENT BUTTON
  // Hide Other Elements
  scrlbxSettings.Visible := False;
  scrbxWeather.Visible := False;
  btnUpdate.Visible := False;
  lblUpdateStatus.Visible := False;
  scrlbxAbout.Visible := False;
  btnRestart.Visible := False;
  btnApply.Visible := False;
  scrlbxClimate.Visible := False;
  scrbxAction.Visible := False;

  // Show Other Elements
  scrbxLogin.Visible := True;
  lblHeadingMain.Text := '    Data Management';

  // Hide Menu
  MultiView1.HideMaster;

  // Database Connection Status
  fraDataMan1.lblConStat.Text := fraSettings1.lblConStat.Text;
  fraDataMan1.lblConStat.TextSettings.FontColor :=
                              fraSettings1.lblConStat.TextSettings.FontColor;
  fraDataMan1.shpConStat.Fill.Color := fraSettings1.shpConStat.Fill.Color;
  fraDataMan1.shpConStat.Stroke.Color := fraSettings1.shpConStat.Stroke.Color;

  // No Login Button Bug Fix
  frmMain.fraDataAccess1.btnLogin.Visible := True;
end;

procedure TfrmMain.btnApplyClick(Sender: TObject);
var
  txtLocation: TextFile;
begin
  // Write to File
  AssignFile(txtLocation, 'Database_Location.txt');
  Rewrite(txtLocation);
  Writeln(txtLocation, fraSettings1.edtLocation.Text);
  CloseFile(txtLocation);
end;

procedure TfrmMain.btnBackClick(Sender: TObject); // BACK CLICK
begin
  // Home/Back Button Click

  // Hide Other Frames
  scrlbxSettings.Visible := False;

  // Show Live Weather Frame
  scrbxWeather.Visible := True;
end;

procedure TfrmMain.btnClimateAnalysisClick(Sender: TObject);
begin
  // CLIMATE ANALYSIS
  if fraSettings1.lblConStat.Text = 'Connection Failed' then
  begin
    frmError.Visible := True;
    pnlBacking1.Visible := True;
    frmError.lblErrorMessage.Text :=
      'A Connection to the Database cannot be Established. Connection Failed';
  end
  else if fraSettings1.lblConStat.Text = 'Disconnected' then
  begin
    frmError.Visible := True;
    pnlBacking1.Visible := True;
    frmError.lblErrorMessage.Text :=
      'Database Disconnected. Reconnect in Settings.';
  end
  else
  begin
    // Hide Other Elements
    scrlbxSettings.Visible := False;
    scrbxWeather.Visible := False;
    btnUpdate.Visible := False;
    lblUpdateStatus.Visible := False;
    scrlbxAbout.Visible := False;
    btnApply.Visible := False;
    btnRestart.Visible := False;
    scrbxDataMan.Visible := False;
    scrbxLogin.Visible := False;
    scrbxAction.Visible := False;

    // Show Other Elements
    scrlbxClimate.Visible := True;
    lblHeadingMain.Text := '    Climate Analysis';

    // Hide Menu
    MultiView1.HideMaster;

    // Climate Information
    // dmData_Code.DatabaseSetup;
    frmMain.fraClimate1.fraClimateData1.dsTemperature.DataSet :=
    dmData_Code.tblTemperature;
    frmMain.fraClimate1.fraClimateData1.Rainfall;
  end;
end;

procedure TfrmMain.btnClimateReductionClick(Sender: TObject);
begin
  // Climate Action Click
  // Hide Other Elements
  scrlbxSettings.Visible := False;
  scrlbxClimate.Visible := False;
  scrlbxAbout.Visible := False;
  btnApply.Visible := False;
  btnRestart.Visible := False;
  scrbxDataMan.Visible := False;
  scrbxWeather.Visible := False;
  scrbxLogin.Visible := False;
  btnUpdate.Visible := False;
  lblUpdateStatus.Visible := False;

  // Show Other Elements
  scrbxAction.Visible := True;
  lblHeadingMain.Text := '    Climate Change Action';

  // Hide Menu
  MultiView1.HideMaster;

  // Update News From Database
  UpdateNews;

end;

procedure TfrmMain.btnRestartClick(Sender: TObject);
var
  iMessage: Integer;
begin
  // RESTART APPLICATION
  // Use ShellExecute
  // ShellExecute(HWND_DESKTOP, nil, PChar('PAT2023.exe'), nil, nil, SW_SHOWNORMAL);
  // Application.Terminate;
  // fraSettings1.pnlCover.Visible := True;
  pnlBacking1.Visible := True;
  frmRestart.Show;
end;

procedure TfrmMain.btnUpdateClick(Sender: TObject);
begin
  // UPDATE ONCLICK
  // Update Weather

  if InternetGetConnectedState(0, 0) = False then
  begin
    fraWeather1.pnlNoInternet.Visible := True;
  end
  else
  begin
    tLastUpdated.Enabled := True;
    UpdateWeather;
    fraWeather1.pnlNoInternet.Visible := False;
  end;

end;

procedure TfrmMain.btnWeatherClick(Sender: TObject); // WEATHER CLICK
begin
  // WEATHER CLICK
  // Hide Other Elements
  scrlbxSettings.Visible := False;
  scrlbxClimate.Visible := False;
  scrlbxAbout.Visible := False;
  btnApply.Visible := False;
  btnRestart.Visible := False;
  scrbxDataMan.Visible := False;
  scrbxLogin.Visible := False;
  scrbxAction.Visible := False;

  // Show Other Elements
  scrbxWeather.Visible := True;
  btnUpdate.Visible := True;
  lblHeadingMain.Text := '    Weather Forcast';
  lblUpdateStatus.Visible := True;

  // Hide Menu
  MultiView1.HideMaster;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  // Resize Form
  if frmMain.WindowState = TWindowState.wsMaximized then
  begin
    // Maximised
    with fraWeather1 do
    begin

    end;
  end;
end;

procedure TfrmMain.MultiView1Click(Sender: TObject);
begin
  MultiView1.HideMaster;
end;

procedure TfrmMain.OpenLink;
begin
  // Open Link for Climate Action
  ShellExecute(HWND_DESKTOP, 'open',
  'https://footprint.wwf.org.uk/' ,nil,nil, SW_SHOWNORMAL) ;
end;

procedure TfrmMain.btnSettingsClick(Sender: TObject);
var
  txtLocation: TextFile;
  sDBLoc: string;
begin
  // Settings Button Click

  // Hide Other Elements
  scrbxWeather.Visible := False;
  scrlbxClimate.Visible := False;
  lblUpdateStatus.Visible := False;
  btnUpdate.Visible := False;
  scrlbxAbout.Visible := False;
  scrbxDataMan.Visible := False;
  scrbxLogin.Visible := False;
  scrbxAction.Visible := False;

  // Show Other Elements
  scrlbxSettings.Visible := True;
  lblHeadingMain.Text := '    Settings';
  btnApply.Visible := True;
  btnRestart.Visible := True;

  // Hide Menu
  MultiView1.HideMaster;


  // Read Settings from File(s)

  try
    AssignFile(txtLocation, 'Database_Location.txt');
    Reset(txtLocation);

    while not Eof(txtLocation) do
    begin
      Readln(txtLocation, sDBLoc);
    end;

    CloseFile(txtLocation);

    fraSettings1.edtLocation.Text := sDBLoc;
  except
    // Database Disk Location File Cannot be Found
  end;

  // Connect to Database
  dmData_Code.DatabaseSetup;

  // Populate Settings (TEXT FILES COMING SOON)
  fraSettings1.mmConString.Lines.Clear;
  fraSettings1.mmConString.Lines.Add(dmData_Code.conMain.ConnectionString);

end;

procedure TfrmMain.SpeedButton3Click(Sender: TObject);
begin
  // Home/Back Button Click

  // Hide Other Frames
  scrlbxSettings.Visible := False;

  // Show Live Weather Frame
  scrbxWeather.Visible := True;
end;

procedure TfrmMain.btnAboutClick(Sender: TObject); // ABOUT CLICK
begin
  // About Click
  // Hide Other Frames
  scrbxWeather.Visible := False;
  scrlbxSettings.Visible := False;
  btnUpdate.Visible := False;
  lblHeadingMain.Text := '    About';
  lblUpdateStatus.Visible := False;
  btnApply.Visible := False;
  btnRestart.Visible := False;
  scrbxDataMan.Visible := False;
  scrbxLogin.Visible := False;
  scrbxAction.Visible := False;

  // Show About Frame
  scrlbxAbout.Visible := True;

  // Hide Menu
  MultiView1.HideMaster;
end;

procedure TfrmMain.tLastUpdatedTimer(Sender: TObject);
begin
  // Last Updated Status
  tStatus := MinuteOf(Now - tUpdated);

  // Show Status
  if tStatus <= 0 then
  begin
    lblUpdateStatus.Text := 'Last Updated Now  ';
  end
  else if (tStatus >= 1) and (tStatus < 60) then
  begin
    if (tStatus = 1) then
    begin
      lblUpdateStatus.Text := 'Last Updated ' + FloatToStr(Trunc(tStatus)) +
        ' minute ago   ';
    end
    else
    begin
      lblUpdateStatus.Text := 'Last Updated ' + FloatToStr(Trunc(tStatus)) +
        ' minutes ago   ';
    end;
  end
  else
  begin
    if (tStatus = 60) then
    begin
      lblUpdateStatus.Text := 'Last Updated ' + FloatToStr(Trunc(tStatus / 60))
        + ' hour ago   ';
    end
    else
    begin
      lblUpdateStatus.Text := 'Last Updated ' + FloatToStr(Trunc(tStatus / 60))
        + ' hours ago   ';
    end;
  end;
end;

procedure TfrmMain.UpdateNews;
var
  arrDates : array[1..6] of TDate;
  I, iOut, iIn, K: Integer;
  dKeep : TDate;
  sPlace, sOriginal, sAfter1, sAfter2 : string;
begin
  // UPDATE NEWS
  I := 1;
  with dmData_Code do
    begin
      // Get Dates into Array
      tblNews.First;
      while not (tblNews.Eof) do
        begin
          arrDates[I] := tblNews['Date_Published'];
          Inc(I);
          tblNews.Next;
        end;

      // Sort Dates
      for iOut := 1 to I - 1 do
        begin
          for iIn := iOut + 1 to I do
            begin
              if arrDates[iIn] > arrDates[iOut] then
                begin
                  dKeep := arrDates[iIn];
                  arrDates[iIn] := arrDates[iOut];
                  arrDates[iOut] := dKeep;
                end;
            end;
        end;

      // Add Dates and Data to Action Frame
      with fraAction1 do
        begin
          // Add Sorted + Formated Dates as Tab Captions
          tbDate1.Text := FormatDateTime('dd mmmm yyyy',arrDates[1]);
          tbDate2.Text := FormatDateTime('dd mmmm yyyy',arrDates[2]);
          tbDate3.Text := FormatDateTime('dd mmmm yyyy',arrDates[3]);
          tbDate4.Text := FormatDateTime('dd mmmm yyyy',arrDates[4]);
          tbDate5.Text := FormatDateTime('dd mmmm yyyy',arrDates[5]);

          // Clear All
          mmArticle1.Lines.Clear;
          lblHeading1.Text := '';
          mmArticle2.Lines.Clear;
          lblHeading2.Text := '';
          mmArticle3.Lines.Clear;
          lblHeading3.Text := '';
          mmArticle4.Lines.Clear;
          lblHeading4.Text := '';
          mmArticle5.Lines.Clear;
          lblHeading5.Text := '';

          // Add Data to the components that corresponds to dates
          // ******************* ADD 1st ARTICLE ****************************
          // Add Heading
          tblNews.First;
          lblHeading1.Text := tblNews['Article_Headline'];

          // Get Place Name
          tblPlaces.First;
          while not tblPlaces.Eof do
            begin
              tblNews.First;
              if tblPlaces['Place_ID'] = tblNews['Place_ID'] then
                begin
                  sPlace := tblPlaces['Place_Name'];
                end;
              tblPlaces.Next;
            end;

          // Add Author and Source
          mmArticle1.Lines.Add(tblNews['Author'] + ' @ ' +
          tblNews['Source_Name']);

          // Add Major/Minor and Place
          if tblNews['Major_Event'] = True then
            begin
              mmArticle1.Lines.Add('Major Event in ' + sPlace + #13);
            end
          else
            begin
              mmArticle1.Lines.Add('Minor Event in ' + sPlace + #13);
            end;

          // Add Body
          mmArticle1.Lines.Add(tblNews['Article_Body']);
          sOriginal := mmArticle1.Lines.Text;
          sAfter1 := (StringReplace(sOriginal, '<div>', '', [rfReplaceAll, rfIgnoreCase]));
          sAfter2 := (StringReplace(sAfter1, '</div>', '', [rfReplaceAll, rfIgnoreCase]));
          mmArticle1.Lines.Clear;
          mmArticle1.Lines.Add(sAfter2);

          // ******************** ADD 2st ARTICLE ***************************
          // Add Heading
          tblNews.RecNo := 2;
          lblHeading2.Text := tblNews['Article_Headline'];

          // Get Place Name
          tblPlaces.First;
          while not tblPlaces.Eof do
            begin
              tblNews.RecNo := 2;
              if tblPlaces['Place_ID'] = tblNews['Place_ID'] then
                begin
                  sPlace := tblPlaces['Place_Name'];
                end;
              tblPlaces.Next;
            end;

          // Add Author and Source Name
          mmArticle2.Lines.Add(tblNews['Author'] + ' @ ' +
          tblNews['Source_Name']);

          // Add Minor/Major Status and Place
          if tblNews['Major_Event'] = True then
            begin
              mmArticle2.Lines.Add('Major Event in ' + sPlace + #13);
            end
          else
            begin
              mmArticle2.Lines.Add('Minor Event in ' + sPlace + #13);
            end;

          // Add Body
          mmArticle2.Lines.Add(tblNews['Article_Body']);
          sOriginal := mmArticle2.Lines.Text;
          sAfter1 := (StringReplace(sOriginal, '<div>', '', [rfReplaceAll, rfIgnoreCase]));
          sAfter2 := (StringReplace(sAfter1, '</div>', '', [rfReplaceAll, rfIgnoreCase]));
          mmArticle2.Lines.Clear;
          mmArticle2.Lines.Add(sAfter2);


          // ********************* ADD 3rd ARTICLE **************************
          // Add Heading
          tblNews.RecNo := 3;
          lblHeading3.Text := tblNews['Article_Headline'];

          // Get Place Name
          tblPlaces.First;
          while not tblPlaces.Eof do
            begin
              tblNews.RecNo := 3;
              if tblPlaces['Place_ID'] = tblNews['Place_ID'] then
                begin
                  sPlace := tblPlaces['Place_Name'];
                end;
              tblPlaces.Next;
            end;

          // Add Author and Source Name
          mmArticle3.Lines.Add(tblNews['Author'] + ' @ ' +
          tblNews['Source_Name']);

          // Add Minor/Major Status and Place
          if tblNews['Major_Event'] = True then
            begin
              mmArticle3.Lines.Add('Major Event in ' + sPlace + #13);
            end
          else
            begin
              mmArticle3.Lines.Add('Minor Event in ' + sPlace + #13 );
            end;

          // Add Body
          mmArticle3.Lines.Add(tblNews['Article_Body']);
          sOriginal := mmArticle3.Lines.Text;
          sAfter1 := (StringReplace(sOriginal, '<div>', '', [rfReplaceAll, rfIgnoreCase]));
          sAfter2 := (StringReplace(sAfter1, '</div>', '', [rfReplaceAll, rfIgnoreCase]));
          mmArticle3.Lines.Clear;
          mmArticle3.Lines.Add(sAfter2);

          // ******************** ADD 4th ARTICLE ****************************
          // Add Heading
          tblNews.RecNo := 4;
          lblHeading4.Text := tblNews['Article_Headline'];

          // Get Place Name
          tblPlaces.First;
          while not tblPlaces.Eof do
            begin
              tblNews.RecNo := 4;
              if tblPlaces['Place_ID'] = tblNews['Place_ID'] then
                begin
                  sPlace := tblPlaces['Place_Name'];
                end;
              tblPlaces.Next;
            end;

          // Add Author and Source Name
          mmArticle4.Lines.Add(tblNews['Author'] + ' @ ' +
          tblNews['Source_Name']);

          // Add Minor/Major Status and Place
          if tblNews['Major_Event'] = True then
            begin
              mmArticle4.Lines.Add('Major Event in ' + sPlace + #13);
            end
          else
            begin
              mmArticle4.Lines.Add('Minor Event in ' + sPlace + #13);
            end;

          // Add Body
          mmArticle4.Lines.Add(tblNews['Article_Body']);
          sOriginal := mmArticle4.Lines.Text;
          sAfter1 := (StringReplace(sOriginal, '<div>', '', [rfReplaceAll, rfIgnoreCase]));
          sAfter2 := (StringReplace(sAfter1, '</div>', '', [rfReplaceAll, rfIgnoreCase]));
          mmArticle4.Lines.Clear;
          mmArticle4.Lines.Add(sAfter2);

          // ********************* Add 5th Article **************************
        end;
    end;
end;

procedure TfrmMain.UpdateWeather; // UPDATE WEATHER
var
  sDTText, sTime, sWeather, sDescrip, sDescription: string;
  I, iPos1, iPos2, iLength: Integer;

  // Arrays for Forecast
  arrTime: array [1..4] of string;
  arrDate: array [1..4] of string;
  arrTemp: array [1..4] of string;
  arrDescrip: array [1 .. 4] of string;
  arrPOP: array [1 .. 4] of string;

  // Sunsrise; Sunset
  tSunrise, tSunset: TDateTime;
  sMain: string;

  // Format
const
  cMyFormatSettings: TFormatSettings = (DecimalSeparator: '.');

begin
  // UPDATE WEATHER
  // Update Weather from OpenWeatherMap API

  // Get Last Updated Time
  tUpdated := Now;

  with dmMain do
  begin
    with fraWeather1 do
    begin
      // WEATHER

      // Weather Description
      rqstDescription.Execute;

      try
        sDescription := fdmDescription['description'];
        sDescription := UpperCase(sDescription[1]) + Copy(sDescription, 2,
          Length(sDescription));
        lblDescription.Text := sDescription;
      except
        lblDescription.Text := '--';
      end;

      // Main Weather Data
      rqstMain.Execute;

      try
        lblTemp.Text := FloatToStr(Round(StrToFloat(fdmMain['temp']))) + '°';
        lblFeelsLike.Text := 'Feels Like: ' +
          FloatToStr(Round(StrToFloat(fdmMain['feels_like']))) + '°';
      except
        lblTemp.Text := '--°';
        lblFeelsLike.Text := '--°';
      end;

      // FORCAST
      rqstForcast.Execute;

      try
        I := 0;
        fdmForcast.First;
        while not(dmMain.fdmForcast.Eof) and (I < 4) do
        begin
          Inc(I);
          // Date
          sDTText := dmMain.fdmForcast['dt_txt'];
          arrDate[I] := Copy(sDTText, 1, Pos(' ', sDTText) - 1);
          Delete(sDTText, 1, Pos(' ', sDTText));

          // Time
          arrTime[I] := FormatDateTime('h AMPM', StrToTime(sDTText));

          // Temperature
          sWeather := dmMain.fdmForcast['main'];
          arrTemp[I] :=
            FloatToStr(Round(StrToFloat(Copy(sWeather, 9, 4)))) + '°';

          // Descriptions
          sDescrip := dmMain.fdmForcast['weather'];
          iPos1 := Pos('main":"', sDescrip);
          iPos2 := Pos('","description', sDescrip);
          iLength := iPos2 - iPos1;
          arrDescrip[I] := Copy(sDescrip, iPos1 + 7, iLength - 7);

          // POP
          arrPOP[I] := FloatToStr((StrToFloat(dmMain.fdmForcast['pop'])) *
            100) + '%';

          fdmForcast.Next;
        end;

        // Add Times
        lblTime1.Text := arrTime[1];
        lblTime2.Text := arrTime[2];
        lblTime3.Text := arrTime[3];
        lblTime4.Text := arrTime[4];

        // Add Temps
        lblTemp1.Text := arrTemp[1];
        lblTemp2.Text := arrTemp[2];
        lblTemp3.Text := arrTemp[3];
        lblTemp4.Text := arrTemp[4];

        // Add Descriptions
        lblDescrip1.Text := arrDescrip[1];
        lblDescrip2.Text := arrDescrip[2];
        lblDescrip3.Text := arrDescrip[3];
        lblDescrip4.Text := arrDescrip[4];

        // Possibility of Precipitation
        lblPOP1.Text := arrPOP[1];
        lblPOP2.Text := arrPOP[2];
        lblPOP3.Text := arrPOP[3];
        lblPOP4.Text := arrPOP[4];

      except
        // Times
        lblTime1.Text := '-- am';
        lblTime2.Text := '-- pm';
        lblTime3.Text := '-- pm';
        lblTime4.Text := '-- pm';

        // Temperatures
        lblTemp1.Text := '--°';
        lblTemp2.Text := '--°';
        lblTemp3.Text := '--°';
        lblTemp4.Text := '--°';

        // Descriptions
        lblDescrip1.Text := '--';
        lblDescrip2.Text := '--';
        lblDescrip3.Text := '--';
        lblDescrip4.Text := '--';

        // Possibility of Precipitation
        lblPOP1.Text := '--%';
        lblPOP2.Text := '--%';
        lblPOP3.Text := '--%';
        lblPOP4.Text := '--%';
      end;

      // WIND DATA
      dmMain.rqstWind.Execute;

      // Wind Speed
      try
        lblSpeed.Text := 'Speed: ' + dmMain.fdmWind['speed'] + ' m/s';
      except
        lblSpeed.Text := 'Speed: -- m/s';
      end;

      // Wind Direction
      try
        lblDirection.Text := 'Direction: ' + dmMain.fdmWind['deg'] + '°';
      except
        lblDirection.Text := 'Direction: -- °';
      end;

      // Wind Gust
      try
        lblGusts.Text := 'Gust: ' + dmMain.fdmWind['gust'] + ' m/s';
      except
        lblGusts.Text := 'Gust: -- m/s';
      end;

      // AIR QUALITY
      dmMain.rqstAQI.Execute;

      // Air Quality Index
      try
        lblAQI.Text := dmMain.fdmAQI['aqi'];

        case StrToInt(lblAQI.Text) of
          1:
            begin
              lblAQIStatus.Text := 'Good';
              lblAQIStatus.FontColor := TAlphaColors.Chartreuse;
              lblAQI.FontColor := TAlphaColors.Chartreuse;
            end;

          2:
            begin
              lblAQIStatus.Text := 'Fair';
              lblAQIStatus.FontColor := TAlphaColors.Yellow;
              lblAQI.FontColor := TAlphaColors.Yellow;
            end;

          3:
            begin
              lblAQIStatus.Text := 'Moderate';
              lblAQIStatus.FontColor := TAlphaColors.Orange;
              lblAQI.FontColor := TAlphaColors.Orange;
            end;

          4:
            begin
              lblAQIStatus.Text := 'Poor';
              lblAQIStatus.FontColor := TAlphaColors.Red;
              lblAQI.FontColor := TAlphaColors.Red;
            end;

          5:
            begin
              lblAQIStatus.Text := 'Very Poor';
              lblAQIStatus.FontColor := TAlphaColors.Darkviolet;
              lblAQI.FontColor := TAlphaColors.Darkviolet;
            end;
        end;
      except
        lblAQI.Text := '--';
        lblAQIStatus.Text := '--';
        lblAQI.FontColor := TAlphaColors.White;
        lblAQIStatus.FontColor := TAlphaColors.White;
      end;

      // Specific Pollutants
      dmMain.rqstComps.Execute;

      try
        lblCO.Text := dmMain.fdmComps['co'] + ' µm';
        lblSO2.Text := dmMain.fdmComps['so2'] + ' µm';
        lblO3.Text := dmMain.fdmComps['o3'] + ' µm';
        lblPM2_5.Text := dmMain.fdmComps['pm2_5'] + ' µm';
      except
        lblCO.Text := '-- µm';
        lblSO2.Text := '-- µm';
        lblO3.Text := '-- µm';
        lblPM2_5.Text := '-- µm';
      end;

      // Visibility
      dmMain.rqstVis.Execute;

      try
        lblVis.Text := 'Visibility: ' + dmMain.fdmVis['visibility'] + ' m';
      except
        lblVis.Text := 'Visibility: -- m';
      end;

      // Cloud Cover
      dmMain.rqstClouds.Execute;

      try
        lblCloudCover.Text := 'Cloud Cover: ' + dmMain.fdmClouds['all'] + '%';
      except
        lblCloudCover.Text := '--%';
      end;

      // Pressure
      dmMain.rqstMain.Execute;

      try
        lblPressure.Text := 'Pressure: ' + dmMain.fdmMain['pressure'] + ' hPa';
      except
        lblPressure.Text := 'Pressure: -- hPa';
      end;

      // Humidity
      dmMain.rqstMain.Execute;

      try
        lblHumidity.Text := 'Humidity: ' + dmMain.fdmMain['humidity'] + '%';
      except
        lblHumidity.Text := 'Humidity: --%';
      end;


      // SUN

      // Sunrise
      dmMain.rqstDetails.Execute;

      try
        tSunrise := UnixToDateTime
          (StrToInt(dmMain.fdmDetails['sunrise'] + 7200));
        lblSunrise.Text := FormatDateTime('h:mm AMPM', tSunrise);
      except
        lblSunrise.Text := '-- am';
      end;

      // Sunset
      dmMain.rqstDetails.Execute;

      try
        tSunset := UnixToDateTime(StrToInt(dmMain.fdmDetails['sunset'] + 7200));
        lblSunset.Text := FormatDateTime('h:mm AMPM', tSunset);
      except
        lblSunset.Text := '-- pm';
      end;

      // CHANGE BACKGROUND AND PANEL COLOURS BASED ON WEATHER
      // Added: 15 July 2023

      sMain := UpperCase(fdmDescription['main']);
      sDescription := UpperCase(sDescription);
      if (sDescription = 'OVERCAST CLOUDS') or (sMain = 'DRIZZLE') or
        (sMain = 'SNOW') then
      begin
        imgBackground.Bitmap.LoadFromFile('Overcast.jpg');
        imgIco.Bitmap.LoadFromFile('Icon-Clouds.png');
      end
      else if sDescription = 'BROKEN CLOUDS' then
      begin
        imgBackground.Bitmap.LoadFromFile('Broken Clouds.jpg');
        imgIco.Bitmap.LoadFromFile('Icon-Cloudy.png');
      end
      else if sDescription = 'SCATTERED CLOUDS' then
      begin
        imgBackground.Bitmap.LoadFromFile('Scattered Clouds.jpg');
        imgIco.Bitmap.LoadFromFile('Icon-Cloudy.png');
      end
      else if sDescription = 'FEW CLOUDS' then
      begin
        imgBackground.Bitmap.LoadFromFile('Few Clouds.jpg');
        imgIco.Bitmap.LoadFromFile('Icon-Cloudy.png');
      end
      else if sMain = 'CLEAR' then
      begin
        imgBackground.Bitmap.LoadFromFile('Clear.jpg');
        imgIco.Bitmap.LoadFromFile('Icon-Sun-Yellow.png');
      end
      else if sMain = 'RAIN' then
      begin
        imgBackground.Bitmap.LoadFromFile('Rain.jpg');
        imgIco.Bitmap.LoadFromFile('Icon-Rain.png');
      end
      else if sMain = 'THUNDERSTORM' then
      begin
        imgBackground.Bitmap.LoadFromFile('Thunderstorm.jpg');
        imgIco.Bitmap.LoadFromFile('Icon-Thunderstorm.png');
      end
      else
      begin
        imgBackground.Bitmap.LoadFromFile('Johannesburg_Dark.jpg');
      end;
    end;
  end;
end;

end.
