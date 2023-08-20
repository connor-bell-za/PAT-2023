unit Data_Management;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo, FMX.ListBox, FMX.Layouts, System.Rtti, FMX.Grid.Style, FMX.Grid,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.DB, Fmx.Bind.Grid,
  Data.Bind.Grid, Data.Bind.DBScope, Data.Win.ADODB, Vcl.OleAuto, FMX.MultiView,
  FMX.Effects, Winapi.ShellAPI;

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
    Label1: TLabel;
    cmbTable: TComboBox;
    pnlHelp: TPanel;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    btnSQLHelp: TButton;
    Label8: TLabel;
    mmAboutDB: TMemo;
    Label9: TLabel;
    strPlaces: TStringGrid;
    scField: TStringColumn;
    scFieldSize: TStringColumn;
    scDataType: TStringColumn;
    scDescription: TStringColumn;
    Label10: TLabel;
    strClimates: TStringGrid;
    scFieldName1: TStringColumn;
    scFieldSize1: TStringColumn;
    scDataType1: TStringColumn;
    scDescription1: TStringColumn;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    strNews: TStringGrid;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    StringColumn3: TStringColumn;
    StringColumn4: TStringColumn;
    cmbFields: TComboBox;
    cmbKind: TComboBox;
    cmbParams: TComboBox;
    rectHeader: TRectangle;
    ShadowEffect1: TShadowEffect;
    Label16: TLabel;
    btnAddQuery: TButton;
    Line4: TLine;
    Line1: TLine;
    Line2: TLine;
    Line3: TLine;
    Line5: TLine;
    Label17: TLabel;
    Label18: TLabel;
    strData: TStringGrid;
    StringColumn5: TStringColumn;
    StringColumn6: TStringColumn;
    StringColumn7: TStringColumn;
    StringColumn8: TStringColumn;
    procedure btnExecuteClick(Sender: TObject);
    procedure ListBoxItem1Click(Sender: TObject);
    procedure ListBoxItem2Click(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure cmbTableChange(Sender: TObject);
    procedure cmbFieldsChange(Sender: TObject);
    procedure cmbKindChange(Sender: TObject);
    procedure btnAddQueryClick(Sender: TObject);
    procedure cmbParamsChange(Sender: TObject);
    procedure btnSQLHelpClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    // Quick database action variables
    sTable, sField, sQuery, sParam, sSQL : string;
    // Procedure to get the information about the database.
    procedure dbInfo;
  end;

implementation

{$R *.fmx}

uses Main, dmData, dmDB, Temperature, Data_Capture, Error_Template, dmDB_Code;

procedure TfraDataMan.btnExecuteClick(Sender: TObject);
var
  txtFile : TextFile;
begin
  // Climate SQL Query
  // Check the connection of the database
  if lblConStat.Text <> 'Disconnected' then
    begin
      // Database connected, can run SQL
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
      // Database disconnected, display error message
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

procedure TfraDataMan.btnSQLHelpClick(Sender: TObject);
begin
  // Open SQL PDF Document using OpenLink procedure in frmMain
  frmMain.sLink := 'SQL_Help.pdf';
  frmmain.OpenLink;
end;

procedure TfraDataMan.btnAddQueryClick(Sender: TObject);
begin
  // Run the selected quick database action.
  // Check database connection
   if lblConStat.Text <> 'Disconnected' then
    begin
      // Database is connected - execute SQL.
      mmSQL.Lines.Clear;
      mmSQL.Lines.Add(sSQL);
      qryMain.SQL := (mmSQL.Lines);
      qryMain.ExecSQL;

      // Reset the input (all comboboxes).
      cmbTable.ItemIndex := 0;
      cmbFields.ItemIndex := 0;
      cmbFields.Enabled := False;
      cmbKind.ItemIndex := 0;
      cmbKind.Enabled := False;
      cmbParams.ItemIndex := 0;
      cmbParams.Enabled := False;
    end
  else
    begin
      // Database is disconnected show error message .
      frmError.Visible := True;
      frmMain.pnlBacking1.Visible := True;
      frmError.lblErrorMessage.Text :=
      'Database Disconnected. Reconnect in Settings.';
    end;
end;

procedure TfraDataMan.cmbFieldsChange(Sender: TObject);
begin
   // Enable Query Kind Selection combobox
  cmbKind.Enabled := True;

  // Get the field name into a variable
  sField := cmbFields.Items[cmbFields.ItemIndex];

  // tblPlaces
  if sTable = 'tblPlaces' then
    begin
      if (sField = 'Climate_ID') or (sField = 'Maritime') then
        begin
           // Climate_ID or Maritime field was selected.
           cmbKind.Clear;
           cmbKind.Items.Add('Select Query Kind');
           cmbKind.ItemIndex := 0;
           cmbKind.Items.Add('Filter');
        end
      else
      if (sField = 'Place_Name') or (sField = 'Province') then
        begin
          // Place_Name or Province field was selected
          cmbKind.Clear;
          cmbKind.Items.Add('Select Query Kind');
          cmbKind.ItemIndex := 0;
          cmbKind.Items.Add('Sort');
        end
      else
      if (sField = 'Population') then
        begin
          // Population field was selected
          cmbKind.Clear;
          cmbKind.Items.Add('Select Query Kind');
          cmbKind.ItemIndex := 0;
          cmbKind.Items.Add('Sort');
          cmbKind.Items.Add('Aggregate');
        end
      else
      if sField = 'Established' then
        begin
          // Established was selected
          cmbKind.Clear;
          cmbKind.Items.Add('Select Query Kind');
          cmbKind.ItemIndex := 0;
          cmbKind.Items.Add('Sort');
          cmbKind.Items.Add('Aggregate');
        end;
    end
  else
  if (sTable = 'tblTemperature') or (sTable = 'tblRainfall') then
    begin
      cmbKind.Clear;
      cmbKind.Items.Add('Select Query Kind');
      cmbKind.ItemIndex := 0;
      cmbKind.Items.Add('Aggregate');
    end
  else
  if sTable = 'tblNews' then
    begin
      if sField = 'Date_Published' then
        begin
          cmbKind.Clear;
          cmbKind.Items.Add('Select Query Kind');
          cmbKind.ItemIndex := 0;
          cmbKind.Items.Add('Sort');
          cmbKind.Items.Add('Aggregate');
        end
      else
      if (sField = 'Author') or (sField = 'Source_Name') then
        begin
          cmbKind.Clear;
          cmbKind.Items.Add('Select Query Kind');
          cmbKind.ItemIndex := 0;
          cmbKind.Items.Add('Sort');
          cmbKind.Items.Add('Filter');
        end
      else
      if (sField = 'Major_Event') or (sField = 'Place_ID') then
        begin
          cmbKind.Clear;
          cmbKind.Items.Add('Select Query Kind');
          cmbKind.ItemIndex := 0;
          cmbKind.Items.Add('Filter');
        end;
    end
  else
  if sTable = 'tblClimates' then
    begin
       if (sField = 'Rainfall_Season') or (sField = 'Heat_Level') or
      (sField = 'Rainfall_Type') or (sField = 'Climate_Group') then
        begin
          cmbKind.Clear;
          cmbKind.Items.Add('Select Query Kind');
          cmbKind.ItemIndex := 0;
          cmbKind.Items.Add('Filter');
        end
      else
      if (sField = 'Koppen_Name') then
        begin
          cmbKind.Clear;
          cmbKind.Items.Add('Select Query Kind');
          cmbKind.ItemIndex := 0;
          cmbKind.Items.Add('Sort');
        end;
    end;
end;

procedure TfraDataMan.cmbKindChange(Sender: TObject);
var
  I : Integer;
begin
  // Enable query parameters selection combobox
  cmbParams.Enabled := True;
  sQuery := cmbKind.Items[cmbKind.ItemIndex];
  if sQuery = 'Sort' then
    begin
      // Sort Query
      cmbParams.Clear;
      cmbParams.Items.Add('Select Query Parameter');
      cmbParams.ItemIndex := 0;
      cmbParams.Items.Add('Ascending');
      cmbParams.Items.Add('Descending');
    end
  else
  if sQuery = 'Filter' then
    begin
      // Filter Query
      cmbParams.Clear;
      // Reset Combobox
      cmbParams.Items.Add('Select Query Parameter');
      cmbParams.ItemIndex := 0;

      // Add Parameters based on the field selected.
      // Climate_ID field was selected
      if sField = 'Climate_ID' then
        begin
          // Add Climate_ID from tblClimates to the Params combobox
          // Search throught the tblClimate table
          with dmData_Code do
            begin
              tblClimates.First;
              while not tblClimates.Eof do
                begin
                  cmbParams.Items.Add(tblClimates['Climate_ID']);
                  tblClimates.Next;
                end;
            end;
        end
      else
      if (sField = 'Maritime') or (sField = 'Major_Event') then
        begin
          // Add Params
          cmbParams.Items.Add('True');
          cmbParams.Items.Add('False');
        end
      else
      if (sField = 'Author') or (sField = 'Source_Name') then
        begin
          // Add distinct author names to the Params combo box
          with dmData_Code do
            begin
              // Search through tblNews database
              tblNews.First;
              I := 0;
              while not tblNews.Eof do
                begin
                  // Ensure that the author is distinct before adding.
                  if cmbParams.Items[I] <> tblNews[sField] then
                    begin
                      cmbParams.Items.Add(tblNews[sField]);
                      Inc(I);
                    end;
                  tblNews.Next;
                end;
            end;
        end
      else
      if (sField = 'Rainfall_Season') or (sField = 'Heat_Level') or
      (sField = 'Rainfall_Type') or (sField = 'Climate_Group')   then
        begin
          // Filter by distinct climate field
           with dmData_Code do
            begin
              // Search through tblClimates database
              tblClimates.First;
              while not tblClimates.Eof do
                begin
                  // Ensure that the field is distinct before adding.
                  if (cmbParams.Items.IndexOf(tblClimates[sField]) = -1) then
                    begin
                      cmbParams.Items.Add(tblClimates[sField]);
                    end;
                  tblClimates.Next;
                end;
            end;
        end;
    end
  else
  if sQuery = 'Aggregate' then
    begin
      // Aggregate Query
      cmbParams.Clear;
      cmbParams.Items.Add('Select Query Parameter');
      cmbParams.ItemIndex := 0;
      // Aggregates for different fields
      if (sField = 'Date_Published') or (sField = 'Established') then
        begin
          cmbParams.Items.Add('Earliest');
          cmbParams.Items.Add('Latest');
        end
      else
        begin
          cmbParams.Items.Add('Highest');
          cmbParams.Items.Add('Lowest');
          cmbParams.Items.Add('Average');
          cmbParams.Items.Add('Total');
        end;
    end;
end;

procedure TfraDataMan.cmbParamsChange(Sender: TObject);
begin
  // Select Parameters for quick run
  sParam := cmbParams.Items[cmbParams.ItemIndex];
  btnAddQuery.Enabled := True;

  if sQuery = 'Sort' then
    begin
      // Sort Query
      if sParam = 'Ascending' then
      begin
        // Ascending Sort
        sSQL := 'SELECT * FROM ' + sTable + ' ORDER BY ' + sField + ' ASC';
      end
    else
    if sParam = 'Descending' then
      begin
        // Descending Sort
        sSQL := 'SELECT * FROM ' + sTable + ' ORDER BY ' + sField + ' DESC';
      end;
    end
  else
  if sQuery = 'Filter' then
    begin
      // Filter Query - filter by selected parameter
      if (sParam = 'True') or (sParam = 'False') then
        begin
          sSQL := 'SELECT * FROM ' + sTable + ' WHERE ' + sField + ' LIKE '
           + sParam;
        end
      else
        begin
          sSQL := 'SELECT * FROM ' + sTable + ' WHERE ' + sField + ' LIKE '
           + QuotedStr(sParam);
        end;
    end
  else
  if sQuery = 'Aggregate' then
    begin
      // Aggregate Query
      if (sParam = 'Highest') or (sParam = 'Latest') then
        begin
          // Max Query
          if (sTable = 'tblRainfall') or (sTable = 'tblTemperature') then
             begin
              // MULTI TABLE MAX QUERY FOR tblRainfall or tblTemperature
              sSQL := 'SELECT tblPlaces.Place_Name AS [Place], ' + sTable + '.[' + sField +
               '] FROM tblPlaces, ' + sTable + ' WHERE ('+ sTable + '.[' + sField +  '] = '
                +
              '(SELECT ROUND(MAX([' + sTable + '.' + sField + ']), 2) FROM '
               + sTable + ') AND ' +
              sTable + '.Place_ID = tblPlaces.Place_ID)';
             end
          else
            begin
              // Any other normal sub-query
              sSQL := 'SELECT * FROM ' + sTable + ' WHERE [' + sField + '] = ' +
              '(SELECT ROUND(MAX([' + sField + ']), 2) FROM ' + sTable + ')';
            end;
        end
      else
      if (sParam = 'Lowest') or (sParam = 'Earliest') then
        begin
          // Min Query
          if (sTable = 'tblRainfall') or (sTable = 'tblTemperature') then
            begin
              // MIN QUERY MULTI-TABLE for tblRainfall or tblTemperature
              sSQL := 'SELECT tblPlaces.Place_Name AS [Place], ' + sTable + '.[' + sField +
               '] FROM tblPlaces, ' + sTable + ' WHERE ('+ sTable + '.[' + sField +  '] = '
                +
              '(SELECT ROUND(MIN([' + sTable + '.' + sField + ']), 2) FROM '
               + sTable + ') AND ' +
              sTable + '.Place_ID = tblPlaces.Place_ID)';
            end
          else
            begin
              // Any other table MIN Query
              sSQL := 'SELECT * FROM ' + sTable + ' WHERE [' + sField + '] = ' +
              '(SELECT ROUND(MIN([' + sField + ']), 2) FROM ' + sTable + ')';
            end;
        end
      else
      if sParam = 'Average' then
        begin
          // Average Query
          sSQL := 'SELECT ROUND(AVG([' + sField + ']), 2) AS [Average] FROM '
          + sTable;
        end
      else
      if sParam = 'Total' then
        begin
          // Total Query
          sSQL := 'SELECT ROUND(SUM([' + sField + ']), 2) AS [Total] FROM ' +
          sTable;
        end;
    end;
end;

procedure TfraDataMan.cmbTableChange(Sender: TObject);
begin
  // Change Table Selection

  // Enable Field Selection combobox
  cmbFields.Enabled := True;
  cmbFields.Clear;
  cmbFields.Items.Add('Select Table Field');
  cmbFields.ItemIndex := 0;

  sTable :=  cmbTable.Items[cmbTable.ItemIndex];
  if sTable = 'tblPlaces' then
    begin
      // tblPlaces table has been selected.
      // Add some of the fields from tblPlaces into the cmbFields combobox
      cmbFields.Items.Add('Place_Name');
      cmbFields.Items.Add('Climate_ID');
      cmbFields.Items.Add('Province');
      cmbFields.Items.Add('Maritime');
      cmbFields.Items.Add('Population');
      cmbFields.Items.Add('Established');
    end
  else
  if sTable = 'tblNews' then
    begin
      // tblNews table has been selected.
      // Add some of the fields from tblNews into the cmbFields combobox
      cmbFields.Items.Add('Place_ID');
      cmbFields.Items.Add('Source_Name');
      cmbFields.Items.Add('Date_Published');
      cmbFields.Items.Add('Author');
      cmbFields.Items.Add('Major_Event');
    end
  else
  if sTable = 'tblClimates' then
    begin
      // tblClimates table has been selected.
      // Add some of the fields from tblClimates into the cmbFields combobox
      cmbFields.Items.Add('Koppen_Name');
      cmbFields.Items.Add('Rainfall_Season');
      cmbFields.Items.Add('Heat_Level');
      cmbFields.Items.Add('Rainfall_Type');
      cmbFields.Items.Add('Climate_Group');
    end
  else
  if (sTable = 'tblRainfall') or (sTable = 'tblTemperature') then
    begin
      // tblTemperature/tblRainfall table has been selected.
      // Add some of the fields from tblClimates into the cmbFields combobox
      cmbFields.Items.Add('2010');
      cmbFields.Items.Add('2011');
      cmbFields.Items.Add('2012');
      cmbFields.Items.Add('2013');
      cmbFields.Items.Add('2014');
      cmbFields.Items.Add('2015');
      cmbFields.Items.Add('2016');
      cmbFields.Items.Add('2017');
      cmbFields.Items.Add('2018');
      cmbFields.Items.Add('2019');
      cmbFields.Items.Add('2020');
      cmbFields.Items.Add('2021');
      cmbFields.Items.Add('2022');
    end;
end;

procedure TfraDataMan.dbInfo;
begin
  // Add DB Table Information
  // tblPlaces
  with strPlaces do
    begin
      // Add tblPlaces Fields to the string grid
      Cells[0, 0] := 'Place_ID';
      Cells[0, 1] := 'Place_Name';
      Cells[0, 2] := 'Climate_ID';
      Cells[0, 3] := 'Province';
      Cells[0, 4] := 'Maritime';
      Cells[0, 5] := 'Population';
      Cells[0, 6] := 'Image_Location';
      Cells[0, 7] := 'Established';
      Cells[0, 8] := 'Description';

      // Add field size for tblPlaces fields to the string grid
      Cells[1, 0] := '3';
      Cells[1, 1] := '15';
      Cells[1, 2] := '3';
      Cells[1, 3] := '20';
      Cells[1, 4] := ' - ';
      Cells[1, 5] := 'Long Integer';
      Cells[1, 6] := '20';
      Cells[1, 7] := ' - ';
      Cells[1, 8] := 'Long Text';

      // Add data type for tblPlaces fields to the string grid
      Cells[2, 0] := 'Short Text';
      Cells[2, 1] := 'Short Text';
      Cells[2, 2] := 'Short Text';
      Cells[2, 3] := 'Short Text';
      Cells[2, 4] := 'Boolean';
      Cells[2, 5] := 'Integer';
      Cells[2, 6] := 'Short Text';
      Cells[2, 7] := 'Date/Time';
      Cells[2, 8] := 'Long Text';

      // Add description for tblPlaces fields to the string grid
      Cells[3, 0] := 'Primary Key';
      Cells[3, 1] := 'The name of the place.';
      Cells[3, 2] := 'Foreign Key - links to tblClimates.';
      Cells[3, 3] := 'The province in which the place is situated.';
      Cells[3, 4] := 'Is the place situated near the coast or inland?';
      Cells[3, 5] := 'Total population of the place.';
      Cells[3, 6] := 'Image location (in the working folder) for the place.';
      Cells[3, 7] := 'Date when the place was officially established.';
      Cells[3, 8] := 'Description of the place.';
    end;

   with strClimates do
    begin
      RowCount := 8;
      // Add tblClimates Fields to the string grid
      Cells[0, 0] := 'Climate_ID';
      Cells[0, 1] := 'Koppen_Name';
      Cells[0, 2] := 'Short_Description';
      Cells[0, 3] := 'Rainfall_Season';
      Cells[0, 4] := 'Heat_level';
      Cells[0, 5] := 'Rainfall_Type';
      Cells[0, 6] := 'Climate_Group';
      Cells[0, 7] := 'Long Description';

      // Add field size for tblClimates fields to the string grid
      Cells[1, 0] := '3';
      Cells[1, 1] := '50';
      Cells[1, 2] := 'Long Text';
      Cells[1, 3] := '30';
      Cells[1, 4] := '30';
      Cells[1, 5] := '30';
      Cells[1, 6] := '20';
      Cells[1, 7] := 'Long Text';

      // Add data type for tblClimates fields to the string grid
      Cells[2, 0] := 'Short Text';
      Cells[2, 1] := 'Short Text';
      Cells[2, 2] := 'Long Text';
      Cells[2, 3] := 'Short Text';
      Cells[2, 4] := 'Short Text';
      Cells[2, 5] := 'Short Text';
      Cells[2, 6] := 'Short Text';
      Cells[2, 7] := 'Long Text';

      // Add description for tblClimates fields to the string grid
      Cells[3, 0] := 'Primary Key';
      Cells[3, 1] := 'The Koppen name of the climate.';
      Cells[3, 2] := 'Short description about the climate.';
      Cells[3, 3] := 'The season in which rainfall occurs.';
      Cells[3, 4] := 'The heat level of the climate.';
      Cells[3, 5] := 'The type of rainfall for the climate.';
      Cells[3, 6] := 'Koppen Climate Group.';
      Cells[3, 7] := 'Longer description about the climate.';
    end;

   with strNews do
    begin
      RowCount := 10;
      // Add tblNews Fields to the string grid
      Cells[0, 0] := 'Article_ID';
      Cells[0, 1] := 'Place_ID';
      Cells[0, 2] := 'Article_Headline';
      Cells[0, 3] := 'Source';
      Cells[0, 4] := 'Date_Published';
      Cells[0, 5] := 'Author';
      Cells[0, 6] := 'Source_Name';
      Cells[0, 7] := 'Major_Event';
      Cells[0, 8] := 'Article_Body';
      Cells[0, 9] := 'Image_Location';

      // Add field size for tblNews fields to the string grid
      Cells[1, 0] := 'Long Integer';
      Cells[1, 1] := '3';
      Cells[1, 2] := '100';
      Cells[1, 3] := ' - ';
      Cells[1, 4] := ' - ';
      Cells[1, 5] := '30';
      Cells[1, 6] := '50';
      Cells[1, 7] := ' - ';
      Cells[1, 8] := 'Long Text';
      Cells[1, 9] := '30';

      // Add data type for tblNews fields to the string grid
      Cells[2, 0] := 'AutoNumber';
      Cells[2, 1] := 'Short Text';
      Cells[2, 2] := 'Short Text';
      Cells[2, 3] := 'Hyperlink';
      Cells[2, 4] := 'Date/Time';
      Cells[2, 5] := 'Short Text';
      Cells[2, 6] := 'Short Text';
      Cells[2, 7] := 'Boolean';
      Cells[2, 8] := 'Long Text';
      Cells[2, 9] := 'Short Text';

      // Add description for tblNews fields to the string grid
      Cells[3, 0] := 'Primary Key';
      Cells[3, 1] := 'Foreign Key - links to tblPlaces';
      Cells[3, 2] := 'The headline for the article';
      Cells[3, 3] := 'URL source of the article ';
      Cells[3, 4] := 'Date when the article was published.';
      Cells[3, 5] := 'Article author.';
      Cells[3, 6] := 'Name of the article source.';
      Cells[3, 7] := 'Does the article feature a major event?';
      Cells[3, 8] := 'Article body.';
      Cells[3, 9] := 'Image location for the article.';
    end;

  // Add tblTemperature and tblRainfall database information
   with strData do
    begin
      RowCount := 7;
      // Add tblTemperature/Rainfall Fields to the string grid
      Columns[0].Width := 100;
      Cells[0, 0] := 'Rainfall_ID/Temp_ID';
      Cells[0, 1] := 'Place_ID';
      Cells[0, 2] := 'Record_High';
      Cells[0, 3] := 'Record_High_Year';
      Cells[0, 4] := 'Record_Low';
      Cells[0, 5] := 'Record_Low_Year';
      Cells[0, 6] := '2010 - 2022';

      // Add field size for tblTemperature/Rainfall fields to the string grid
      Cells[1, 0] := 'Long Integer';
      Cells[1, 1] := '3';
      Cells[1, 2] := 'Decimal';
      Cells[1, 3] := ' - ';
      Cells[1, 4] := 'Decimal';
      Cells[1, 5] := ' - ';
      Cells[1, 6] := 'Decimal';

      // Add data type for tblTemperature/Rainfall fields to the string grid
      Cells[2, 0] := 'AutoNumber';
      Cells[2, 1] := 'Short Text';
      Cells[2, 2] := 'Fixed Decimal';
      Cells[2, 3] := 'Date/Time';
      Cells[2, 4] := 'Fixed Decimal';
      Cells[2, 5] := 'Date/Time';
      Cells[2, 6] := 'Fixed Decimal';

      // Add description for tblTemperature/Rainfall fields to the string grid
      Columns[3].Width := 400;
      Cells[3, 0] := 'Primary Key';
      Cells[3, 1] := 'Foreign Key - links to tblPlaces';
      Cells[3, 2] := 'The record high temperature/rainfall value.';
      Cells[3, 3] := 'When the record occurred.';
      Cells[3, 4] := 'The record low temperature/rainfall value.';
      Cells[3, 5] := 'When the record occurred.';
      Cells[3, 6] := 'Temperature/Rainfall annual average values, formatted to 2 decimal places.';
    end;
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
