unit Climate_Frame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ListBox, FMX.Layouts, Rainfall_Frame,
  FMX.ExtCtrls, FMX.Ani, Recent_Climate_Frame, Temperature;

type
  TfraClimate = class(TFrame)
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    Popup1: TPopup;
    BitmapListAnimation1: TBitmapListAnimation;
    Z: TScrollBox;
    pnlTop: TPanel;
    cmbLocations: TComboBox;
    lblLocation: TLabel;
    fraClimateData1: TfraClimateData;
    btnAboutCity: TSpeedButton;
    GridLayout1: TGridLayout;
    procedure cmbLocationsChange(Sender: TObject);
    procedure ListBoxItem1Click(Sender: TObject);
    procedure ListBoxItem2Click(Sender: TObject);
    procedure btnAboutCityClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses dmDB_Code, About_City, Main;

procedure TfraClimate.btnAboutCityClick(Sender: TObject);
begin
  // Show City Information Form
  {with frmCity do
    begin
      lblCity.Text := lblLocation.Text;
    end;
  frmMain.pnlBacking1.Visible := True;      frmCity.Show;    }
  fraClimateData1.OpenAI;
  ShowMessage(frmMain.sKey);
  ShowMessage(fraClimateData1.sValues);
end;

procedure TfraClimate.cmbLocationsChange(Sender: TObject);
begin
  // Change Location
  lblLocation.Text := cmbLocations.Items[cmbLocations.ItemIndex];
  fraClimateData1.chtMain.SubTitle.Text.Text := (cmbLocations.Items[cmbLocations.ItemIndex] + ' (2010 - 2022)');
end;

procedure TfraClimate.ListBoxItem1Click(Sender: TObject);
begin
  // Rainfall Click
  fraClimateData1.chtMain.Title.Text.Text := 'Annual Rainfall Averages';
  fraClimateData1.chtMain.LeftAxis.Title.Text := 'Average Rainfall (mm)';
  fraClimateData1.srsTemp.Visible := False;
  fraClimateData1.srsRainfall.Visible := True;
  fraClimateData1.Rainfall;
  fraClimateData1.OpenAI;
end;

procedure TfraClimate.ListBoxItem2Click(Sender: TObject);
var
  txtFile : TextFile;
  sDiscuss: string;
begin
  // Temperature Click
  fraClimateData1.chtMain.Title.Text.Text := 'Annual Temperature Averages';
  fraClimateData1.chtMain.LeftAxis.Title.Text := 'Average Temperature (°C)';
  fraClimateData1.srsTemp.Visible := True;
  fraClimateData1.srsRainfall.Visible := False;
  fraClimateData1.Temperature;

end;

end.
