unit Data_Management;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo, FMX.ListBox, FMX.Layouts, System.Rtti, FMX.Grid.Style, FMX.Grid,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.DB, Fmx.Bind.Grid,
  Data.Bind.Grid, Data.Bind.DBScope, Data.Win.ADODB, Vcl.OleAuto, FMX.MultiView;

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
    pnlQA: TCalloutRectangle;
    Label1: TLabel;
    btnSort: TButton;
    btnCount: TButton;
    btnTotal: TButton;
    btnAverage: TButton;
    btnMax: TButton;
    btnMin: TButton;
    cmbTable: TComboBox;
    procedure btnExecuteClick(Sender: TObject);
    procedure ListBoxItem1Click(Sender: TObject);
    procedure ListBoxItem2Click(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure cmbTableChange(Sender: TObject);
    procedure btnSortClick(Sender: TObject);
    procedure btnMaxClick(Sender: TObject);
    procedure btnMinClick(Sender: TObject);
    procedure btnCountClick(Sender: TObject);
    procedure btnAverageClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
   // sEmplid : string;
  end;

implementation

{$R *.fmx}

uses Main, dmData, dmDB, Temperature, Data_Capture, Error_Template;

procedure TfraDataMan.btnAverageClick(Sender: TObject);
var
  sTable : string;
  sYear : string;
begin
 // AVG
  sTable :=  cmbTable.Items[cmbTable.ItemIndex];
  if sTable = 'tblPlaces' then
    begin
      mmSQL.Lines.Add('SELECT SUM(Population) AS [Total People] FROM tblPlaces');
    end
  else
  if sTable = 'tblRainfall' then
    begin
      sYear := InputBox('Query Wizard', 'Year (2010 - 2022):', '2010');
      mmSQL.Lines.Add('SELECT AVG(' + sYear + ') AS [Average Rainfall for ' + sYear
      + '] FROM tblRainfall');
    end
  else
  if sTable = 'tblTemperature' then
    begin
      sYear := InputBox('Query Wizard', 'Year (2010 - 2022):', '2010');
      mmSQL.Lines.Add('SELECT AVG(' + sYear + ') AS [Average Temperature for ' + sYear
      + '] FROM tblTemperature');
    end;
end;

procedure TfraDataMan.btnCountClick(Sender: TObject);
var
  sTable : string;
begin
  // COUNT
  sTable :=  cmbTable.Items[cmbTable.ItemIndex];
  mmSQL.Lines.Add('SELECT COUNT(*) FROM ' + sTable);

end;

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

procedure TfraDataMan.btnMaxClick(Sender: TObject);
var
  sTable : string;
begin
  // MAXIMUM
  sTable :=  cmbTable.Items[cmbTable.ItemIndex];
  if sTable = 'tblPlaces' then
    begin
      mmSQL.Lines.Add('SELECT Place_Name, MAX(Population) AS [Highest Population] FROM tblPlaces');
    end;
end;

procedure TfraDataMan.btnMinClick(Sender: TObject);
var
  sTable : string;
begin
  // MINUMUM
  sTable :=  cmbTable.Items[cmbTable.ItemIndex];
  if sTable = 'tblPlaces' then
    begin
      mmSQL.Lines.Add('SELECT Place_Name, MIN(Population) AS [Lowest Population] FROM tblPlaces');
    end;
end;

procedure TfraDataMan.btnOpenClick(Sender: TObject);
begin
  // Open Data Capture Form
  frmDataCapture.Show;
end;

procedure TfraDataMan.btnSortClick(Sender: TObject);
var
  sTable : string;
  sField : string;
  sKind : string;
begin
  // SORT QUICK ACTION
  sTable :=  cmbTable.Items[cmbTable.ItemIndex];
  sField := InputBox('Query Wizard', 'Sort Field (Enter Field Name):', '');
  sKind := Uppercase(InputBox('Query Wizard', 'Sort Field By (Ascending or Descending):', 'ASC/DESC'));
  mmSQL.Lines.Add('SELECT * FROM ' + sTable + ' ORDER BY ' + sField + ' ' + sKind);
end;

procedure TfraDataMan.cmbTableChange(Sender: TObject);
var
  sTable : string;
begin
  // Change Table Selection
  // QUICK ACTIONS
  sTable :=  cmbTable.Items[cmbTable.ItemIndex];


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
