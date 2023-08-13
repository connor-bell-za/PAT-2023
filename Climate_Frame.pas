unit Climate_Frame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ListBox, FMX.Layouts, Rainfall_Frame,
  FMX.ExtCtrls, FMX.Ani, Recent_Climate_Frame, Temperature, FMX.Effects;

type
  TfraClimate = class(TFrame)
    lstType: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    Popup1: TPopup;
    BitmapListAnimation1: TBitmapListAnimation;
    scrlbxData: TScrollBox;
    pnlTop: TPanel;
    cmbLocations: TComboBox;
    lblLocation: TLabel;
    fraClimateData1: TfraClimateData;
    GridLayout1: TGridLayout;
    ShadowEffect1: TShadowEffect;
    procedure cmbLocationsChange(Sender: TObject);
    procedure ListBoxItem1Click(Sender: TObject);
    procedure ListBoxItem2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses dmDB_Code, About_City, Main;

procedure TfraClimate.cmbLocationsChange(Sender: TObject);
begin
  // Change Location
  lblLocation.Text := cmbLocations.Items[cmbLocations.ItemIndex];
  fraClimateData1.chtMain.SubTitle.Text.Text := (cmbLocations.Items[cmbLocations.ItemIndex] + ' (2010 - 2022)');

  // Update About City Information
  with fraClimateData1 do
    begin
      with dmData_Code do
        begin
          lblAboutCity.Text := lblLocation.Text;
          // Search for the city in the database.
          tblPlaces.First;
          while not tblPlaces.Eof do
            begin
              if tblPlaces['Place_Name'] = lblLocation.Text then
                  begin
                  // Populate the field based on the city.
                  lblEstablished.Text := 'Established: ' + FormatDateTime('dd mmmm yyyy',
                  tblPlaces['Established']);
                  lblPopulation.Text := 'Population: ' + IntToStr(tblPlaces['Population']);
                  mmCity.Lines.Clear;
                  mmCity.Lines.Add(tblPlaces['Description']);
                  imgCity.MultiResBitmap.Bitmaps[1].LoadFromFile(tblPlaces['Image_Location']);
                end;
              tblPlaces.Next;
            end;

            // Change the Glow of the City Picture
          if lblLocation.Text = 'Johannesburg' then
            begin
              GlowEffect1.GlowColor := $FF424F6F;
            end
          else
          if lblLocation.Text = 'Cape Town' then
            begin
              GlowEffect1.GlowColor := $FF0C81FF;
            end
          else
          if lblLocation.Text = 'Durban' then
            begin
              GlowEffect1.GlowColor := $FFCB754A;
            end;
        end;
    end;

    // Update Climate Data - Same as clicking on the Temp/Rainfall Tab
    if lstType.ItemIndex = 0 then
      begin
        // Rainfall
        // Rainfall Click
        fraClimateData1.chtMain.Title.Text.Text := 'Annual Rainfall Averages';
        fraClimateData1.chtMain.LeftAxis.Title.Text := 'Average Rainfall (mm)';
        fraClimateData1.srsTemp.Visible := False;
        fraClimateData1.srsRainfall.Visible := True;
        fraClimateData1.Rainfall;
        fraClimateData1.OpenAI;
      end
    else
    if lstType.ItemIndex = 1 then
      begin
        // Temperature
         // Temperature Click
        fraClimateData1.chtMain.Title.Text.Text := 'Annual Temperature Averages';
        fraClimateData1.chtMain.LeftAxis.Title.Text := 'Average Temperature (°C)';
        fraClimateData1.srsTemp.Visible := True;
        fraClimateData1.srsRainfall.Visible := False;
        fraClimateData1.Temperature;
      end;

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
