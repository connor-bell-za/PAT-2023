unit dmDB_Code;

interface

uses
  System.SysUtils, System.Classes, DB, ADODB;

type
  TdmData_Code = class(TDataModule)
    ADOConnection1: TADOConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    conMain : TADOConnection;
    tblPlaces : TADOTable;
    tblClimates : TADOTable;
    tblTemperature : TADOTable;
    tblRainfall : TADOTable;
    tblNews : TADOTable;
    dsPlaces : TDataSource;
    dsClimates : TDataSource;
    dsTemperature : TDataSource;
    dsRainfall : TDataSource;
    dsNews : TDataSource;

    sFileName : string;
    sConString : string;
    procedure DatabaseSetup;
    procedure DatabaseDisconnect;
  end;

var
  dmData_Code: TdmData_Code;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses Main, Settings, Temperature, Climate_Frame;

{$R *.dfm}

procedure TdmData_Code.DatabaseDisconnect;
begin
  // DISCONNECT
  conMain.Close;
  tblPlaces.Close;
  tblClimates.Close;
  tblTemperature.Close;
  tblRainfall.Close;
  tblNews.Close;
end;

procedure TdmData_Code.DatabaseSetup;
begin
  // DATABASE SETUP CONNECTION
  // Create Objects
  conMain := TADOConnection.Create(dmData_Code);
  tblPlaces := TADOTable.Create(dmData_Code);
  tblClimates := TADOTable.Create(dmData_Code);
  tblTemperature := TADOTable.Create(dmData_Code);
  tblRainfall := TADOTable.Create(dmData_Code);
  tblNews := TADOTable.Create(dmData_Code);
  dsPlaces := TDataSource.Create(dmData_Code);
  dsClimates := TDataSource.Create(dmData_Code);
  dsTemperature := TDataSource.Create(dmData_Code);
  dsRainfall := TDataSource.Create(dmData_Code);
  dsNews := TDataSource.Create(dmData_Code);

  // Connection Settings
  sFileName := frmMain.fraSettings1.edtLocation.Text;
  sConString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' + 'PATDB.mdb' + ';Mode=ReadWrite;Persist Security Info=False';
  conMain.ConnectionString := sConString;
  conMain.LoginPrompt := False;
  conMain.Open;

  // Tables
  tblPlaces.Connection := conMain;
  tblPlaces.TableName := 'tblPlaces';
  tblPlaces.Open;

  tblClimates.Connection := conMain;
  tblClimates.TableName := 'tblClimates';
  tblClimates.Open;

  tblTemperature.Connection := conMain;
  tblTemperature.TableName := 'tblTemperature';
  tblTemperature.Open;

  tblRainfall.Connection := conMain;
  tblRainfall.TableName := 'tblRainfall';
  tblRainfall.Open;

  tblNews.Connection := conMain;
  tblNews.TableName := 'tblNews';
  tblNews.Open;

  frmMain.fraClimate1.fraClimateData1.dsTemperature.DataSet := tblTemperature;
end;

procedure TdmData_Code.DataModuleCreate(Sender: TObject);
begin
  DatabaseSetup;
end;

end.
