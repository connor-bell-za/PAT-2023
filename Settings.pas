unit Settings;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ListBox, FMX.Edit, FMX.Styles, FMX.Objects,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.Printer, Vcl.Printers, ShellAPI,
  Windows;

type
  TfraSettings = class(TFrame)
    Button1: TButton;
    pnlLocation: TPanel;
    lblLocationHeading: TLabel;
    edtLocation: TEdit;
    btnLocationLookup: TButton;
    lblConStat: TLabel;
    shpConStat: TCircle;
    pnlConnectionString: TPanel;
    lblConnectionStringHeading: TLabel;
    mmConString: TMemo;
    dlgLocation: TOpenDialog;
    dlgPrint: TPrintDialog;
    dlgSetup: TPrinterSetupDialog;
    pnlConnectionButtons: TPanel;
    lblConnectionHeading: TLabel;
    btnConnect: TButton;
    btnDisconnect: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    mmKey: TMemo;
    btnOpen: TButton;
    procedure btnLocationLookupClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure edtLocationChange(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses Main, Weather_Frame, dmData, dmDB, dmDB_Code;

var
  fnLocation : string;

procedure TfraSettings.btnDisconnectClick(Sender: TObject);
begin
  // DISCONNECT
   try
    dmData_Code.DatabaseDisconnect;
    lblConStat.Text := 'Disconnected';
    lblConStat.FontColor := TAlphaColors.Orange;
    shpConStat.Fill.Color := TAlphaColors.Orange;
    shpConStat.Stroke.Color := TAlphaColors.Orange;
  except

  end;
end;

procedure TfraSettings.btnLocationLookupClick(Sender: TObject);
var
  txtLocation : TextFile;
  txtConString : TextFile;
begin
  // OPEN FILE (Database Location Selector)
  dlgLocation.Create(Self);
  dlgLocation.InitialDir := GetCurrentDir;
  // dlgLocation.Options := [ofFileMustExist];

  dlgLocation.Filter := 'Microsoft Access Database |*.mdb';

  if dlgLocation.Execute then
    begin
      fnLocation := dlgLocation.FileName;
     // Populate Edit and Text File with Database Location
      edtLocation.Text := fnLocation;

      // Write to File
      AssignFile(txtLocation, 'Database_Location.txt');
      Rewrite(txtLocation);
      Writeln(txtLocation, fnLocation);
      CloseFile(txtLocation);

      // Modify the Connection String Location and Save to File
    end;

  dlgLocation.Free;

  mmConString.Lines.Clear;
  mmConString.Lines.Add(dmData_Code.conMain.ConnectionString);
end;

procedure TfraSettings.btnOpenClick(Sender: TObject);
begin
  // Open the OpenAI API Key management site using OpenLink in frmMain
  frmMain.sLink := 'https://openai.com/';
  frmMain.OpenLink;
end;

procedure TfraSettings.edtLocationChange(Sender: TObject);
begin
  mmConString.Lines.Clear;
  mmConString.Lines.Add(dmData_Code.conMain.ConnectionString);
end;

procedure TfraSettings.btnConnectClick(Sender: TObject);
begin
  // Connect to Database
  try
    dmData_Code.DatabaseSetup;
    lblConStat.Text := 'Connected';
    lblConStat.FontColor := TAlphaColors.Chartreuse;
    shpConStat.Fill.Color := TAlphaColors.Chartreuse;
    shpConStat.Stroke.Color := TAlphaColors.Chartreuse;
  except
    lblConStat.Text := 'Connection Failed';
    lblConStat.FontColor := TAlphaColors.Orangered;
    shpConStat.Fill.Color := TAlphaColors.Orangered;
    shpConStat.Stroke.Color := TAlphaColors.Orangered;
  end;

  mmConString.Lines.Clear;
  mmConString.Lines.Add(dmData_Code.conMain.ConnectionString);
end;

end.
