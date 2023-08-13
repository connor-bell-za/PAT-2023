unit dmData;

interface

uses
  System.SysUtils, System.Classes, REST.Types, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, WinInet, Data.Win.ADODB, FMX.Colors, Data.Bind.DBScope;

type
  TdmMain = class(TDataModule)
    rclDescription: TRESTClient;
    rqstDescription: TRESTRequest;
    rspDescription: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    fdmDescription: TFDMemTable;
    rclMain: TRESTClient;
    rqstMain: TRESTRequest;
    rspMain: TRESTResponse;
    RESTResponseDataSetAdapter2: TRESTResponseDataSetAdapter;
    fdmMain: TFDMemTable;
    RESTClient1: TRESTClient;
    rqstForcast: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter3: TRESTResponseDataSetAdapter;
    fdmForcast: TFDMemTable;
    RESTClient2: TRESTClient;
    rqstWind: TRESTRequest;
    RESTResponse2: TRESTResponse;
    RESTResponseDataSetAdapter4: TRESTResponseDataSetAdapter;
    fdmWind: TFDMemTable;
    RESTClient3: TRESTClient;
    rqstAQI: TRESTRequest;
    RESTResponse3: TRESTResponse;
    RESTResponseDataSetAdapter5: TRESTResponseDataSetAdapter;
    fdmAQI: TFDMemTable;
    RESTClient4: TRESTClient;
    rqstComps: TRESTRequest;
    RESTResponse4: TRESTResponse;
    RESTResponseDataSetAdapter6: TRESTResponseDataSetAdapter;
    fdmComps: TFDMemTable;
    RESTClient5: TRESTClient;
    rqstClouds: TRESTRequest;
    RESTResponse5: TRESTResponse;
    RESTResponseDataSetAdapter7: TRESTResponseDataSetAdapter;
    fdmClouds: TFDMemTable;
    RESTClient6: TRESTClient;
    rqstVis: TRESTRequest;
    RESTResponse6: TRESTResponse;
    RESTResponseDataSetAdapter8: TRESTResponseDataSetAdapter;
    fdmVis: TFDMemTable;
    RESTClient7: TRESTClient;
    rqstDetails: TRESTRequest;
    RESTResponse7: TRESTResponse;
    RESTResponseDataSetAdapter9: TRESTResponseDataSetAdapter;
    fdmDetails: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
    procedure conMainAfterConnect(Sender: TObject);
    procedure conMainAfterDisconnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmMain: TdmMain;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses Weather_Frame, Main, Settings;

{$R *.dfm}

procedure TdmMain.conMainAfterConnect(Sender: TObject);
begin
  // Connect Database Connection
  with frmMain.fraSettings1 do
    begin
      shpConStat.Fill.Color := 4286578432;
      shpConStat.Stroke.Color := 4286578432;
      lblConStat.FontColor := 4286578432;
      lblConStat.Text := 'Connected'
    end;
end;

procedure TdmMain.conMainAfterDisconnect(Sender: TObject);
begin
  // Disconnect Database Connection
  with frmMain.fraSettings1 do
    begin
      shpConStat.Fill.Color := 4294901760;
      shpConStat.Stroke.Color := 4294901760;
      lblConStat.FontColor := 4294901760;
      lblConStat.Text := 'Disconnected'
    end;
end;

procedure TdmMain.DataModuleCreate(Sender: TObject);
begin
  if InternetGetConnectedState(0, 0) = FALSE then
    begin
      frmMain.fraWeather1.pnlNoInternet.Visible := True;
    end
  else
    begin
      frmMain.tLastUpdated.Enabled := True;
      frmMain.UpdateWeather;
      frmMain.fraWeather1.pnlNoInternet.Visible := False;
    end;
end;

end.

