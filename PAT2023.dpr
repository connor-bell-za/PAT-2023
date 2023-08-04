program PAT2023;

{$R *.dres}

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {frmMain},
  Weather_Frame in 'Weather_Frame.pas' {fraWeather: TFrame},
  Settings in 'Settings.pas' {fraSettings: TFrame},
  Climate_Frame in 'Climate_Frame.pas' {fraClimate: TFrame},
  dmData in 'dmData.pas' {dmMain: TDataModule},
  About in 'About.pas' {fraAbout: TFrame},
  Restart_Confirmation in 'Restart_Confirmation.pas' {frmRestart},
  Temperature in 'Temperature.pas' {fraClimateData: TFrame},
  Login in 'Login.pas' {fraDataAccess: TFrame},
  Data_Management in 'Data_Management.pas' {fraDataMan: TFrame},
  dmDB in 'dmDB.pas' {dmDatabase: TDataModule},
  Climate_Action in 'Climate_Action.pas' {fraAction: TFrame},
  dmDB_Code in 'dmDB_Code.pas' {dmData_Code: TDataModule},
  Error_Template in 'Error_Template.pas' {frmError},
  Data_Capture in 'Data_Capture.pas' {frmDataCapture},
  Account_Access in 'Account_Access.pas',
  About_City in 'About_City.pas' {frmCity};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmRestart, frmRestart);
  Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TdmDatabase, dmDatabase);
  Application.CreateForm(TdmData_Code, dmData_Code);
  Application.CreateForm(TfrmError, frmError);
  Application.CreateForm(TfrmDataCapture, frmDataCapture);
  Application.CreateForm(TfrmCity, frmCity);
  Application.Run;
end.
