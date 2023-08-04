object dmData_Code: TdmData_Code
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=PATDB.mdb;Mode=Read' +
      'Write;Persist Security Info=False'
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 304
    Top = 224
  end
end
