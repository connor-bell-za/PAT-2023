unit Account_Access;
{ Account Access Class/Object }
interface

uses
  SysUtils;

type
  TAccount_Access = class(TObject)
    Private
      fEmplid : Integer;
      fPassword : string;
    Public
      constructor Create(pEmplid : Integer; pPassword : string);
      function File_Exists : Boolean;
      procedure Read_File;
      function Validate : Boolean;
  end;

implementation

uses Login;

var
  sPassword : string;
  iEmplid : Integer;

{ TAccount_Access }

function TAccount_Access.File_Exists: Boolean;
begin
  // Check if File Exists
  if not FileExists('Account.txt') then
    begin
      Result := False;
    end
  else
    begin
      Result := True;
    end;
end;

procedure TAccount_Access.Read_File;
var
  txtFile : TextFile;
  sLine : string;
begin
  // Read from File
  AssignFile(txtFile, 'Account.txt');
  Reset(txtFile);

  while not Eof(txtFile) do
    begin
      Readln(txtFile, sLine);
      iEmplid := StrToInt(Copy(sLine, 1, Pos('#', sLine) - 1));
      Delete(sLine, 1, Pos('#', sLine));

      sPassword := sLine;
    end;
end;

function TAccount_Access.Validate: Boolean;
begin
  // Validate
  if (fEmplid = iEmplid) and (fPassword = sPassword) then
    begin
      Result := True;
    end
  else
    begin
      Result := False;
    end;
end;

constructor TAccount_Access.Create(pEmplid: Integer; pPassword: string);
begin
  // Create
  fEmplid := pEmplid;
  fPassword := pPassword;
end;

end.

{ (C) 2023 Connor Bell }

