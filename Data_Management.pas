unit Data_Management;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo, FMX.ListBox, FMX.Layouts, System.Rtti, FMX.Grid.Style, FMX.Grid,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.DB, Fmx.Bind.Grid,
  Data.Bind.Grid, Data.Bind.DBScope, Data.Win.ADODB, Vcl.OleAuto;

type
  TfraDataMan = class(TFrame)
    pnlSQL: TPanel;
    lblHeading: TLabel;
    lblConStat: TLabel;
    shpConStat: TCircle;
    mmSQL: TMemo;
    btnExecute: TButton;
    dsClimates: TDataSource;
    DBLink: TBindSourceDB;
    BindingsList1: TBindingsList;
    tblClimates: TStringGrid;
    LinkGridToDataSourceBindSourceDB12: TLinkGridToDataSource;
    qryMain: TADOQuery;
    dsPlaces: TDataSource;
    Panel3: TPanel;
    lblCapture: TLabel;
    btnOpen: TButton;
    Label3: TLabel;
    Label4: TLabel;
    dsRainfall: TDataSource;
    dsTemperature: TDataSource;
    dsNews: TDataSource;
    btnExport: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    mmLog: TMemo;
    btnUpdate: TButton;
    procedure btnExecuteClick(Sender: TObject);
    procedure ListBoxItem1Click(Sender: TObject);
    procedure ListBoxItem2Click(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
   // sEmplid : string;
  end;

implementation

{$R *.fmx}

uses Main, dmData, dmDB, Temperature, Data_Capture, Error_Template;

procedure TfraDataMan.btnExecuteClick(Sender: TObject);
var
  txtFile : TextFile;
begin
  // Climate SQL Query
  if lblConStat.Text <> 'Disconnected' then
    begin
      if mmSQL.Text <> '' then
        begin
          qryMain.Active := False;
          qryMain.SQL := mmSQL.Lines;
          qryMain.Active := True;
          qryMain.ExecSQL;
        end;

      // Log Activity
      AssignFile(txtFile, 'Log.txt');
      Append(txtFile);
      Writeln(txtFile, '[' + DateToStr(Now) + ' ' + TimeToStr(Now) + ']' +
      ' Emplid: ' + frmMain.fraDataAccess1.sEmplid + ' ' + ' SQL EXECUTION');
      CloseFile(txtFile);
    end
  else
    begin
      frmError.Visible := True;
      frmMain.pnlBacking1.Visible := True;
      frmError.lblErrorMessage.Text :=
      'Database Disconnected. Reconnect in Settings.';
    end;
end;

procedure TfraDataMan.btnExportClick(Sender: TObject);
var
  Xls, Wb, Range : OleVariant;
  arrData : Variant;
  iRowCount, iColCount, I, J : Integer;
begin
  // EXPORT SQL Query Results to Microsoft Excel Spreadsheet

  // Create Variant Array to Copy Data
  iRowCount := tblClimates.RowCount;
  iColCount := tblClimates.ColumnCount;
  arrData := VarArrayCreate([1, iRowCount, 1, iColCount], varVariant);

  // Fill Array
  for I := 1 to iRowCount do
    begin
      for J := 1 to iColCount do
        begin
          arrData[I, J] := tblClimates.Cells[J - 1, I - 1];
        end;
    end;

  // Initialise Instance of Excel
  Xls := CreateOLEObject('Excel.Application');

  // Create Excel Workbook
  Wb := Xls.Workbooks.Add;

  // Retrieve a range where data must be placed
  Range := Wb.WorkSheets[1].Range[Wb.WorkSheets[1].Cells[1, 1],
                                  Wb.WorkSheets[1].Cells[iRowCount, iColCount]];

  // Copy data from allocated variant array
  Range.Value := arrData;

  // Show Excel with data
  Xls.Visible := True;
end;

procedure TfraDataMan.btnOpenClick(Sender: TObject);
begin
  // Open Data Capture Form
  frmDataCapture.Show;
end;

procedure TfraDataMan.btnUpdateClick(Sender: TObject);
var
  sLine : string;
  txtFile : TextFile;
begin
  // Load Activity into Memo
  AssignFile(txtFile, 'Log.txt');
  Reset(txtFile);
  frmMain.fraDataMan1.mmLog.Lines.Clear;
  while not Eof(txtFile) do
    begin
      Readln(txtFile, sLine);
      mmLog.Lines.Add(sLine);
    end;
  CloseFile(txtFile);
end;

procedure TfraDataMan.ListBoxItem1Click(Sender: TObject);
begin
  // tblPlaces Click
  //lblTableNameHead.Text := 'tblPlaces Table View';
  qryMain.DataSource := dsPlaces;
  qryMain.Active := True;
end;

procedure TfraDataMan.ListBoxItem2Click(Sender: TObject);
begin
  // tblPlaces Click
  // lblTableNameHead.Text := 'tblClimates Table View';
  qryMain.DataSource := dsClimates;
  qryMain.Active := True;
end;

end.
