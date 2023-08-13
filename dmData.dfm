object dmMain: TdmMain
  OnCreate = DataModuleCreate
  Height = 529
  Width = 1094
  object rclDescription: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 
      'https://api.openweathermap.org/data/2.5/weather?lat=-26.195246&l' +
      'on=28.034088&appid=220d7fba1d56c5c98555c8d14cbcc20d'
    Params = <>
    SynchronizedEvents = False
    Left = 16
    Top = 8
  end
  object rqstDescription: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = rclDescription
    Params = <
      item
        Name = 'appid'
        Value = '220d7fba1d56c5c98555c8d14cbcc20d'
      end
      item
        Name = 'units'
        Value = 'metric'
      end
      item
        Name = 'lat, lon'
        Value = '-26.195246, 28.034088'
      end>
    Response = rspDescription
    SynchronizedEvents = False
    Left = 56
    Top = 8
  end
  object rspDescription: TRESTResponse
    ContentType = 'application/json'
    RootElement = 'weather'
    Left = 96
    Top = 8
  end
  object RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter
    Active = True
    Dataset = fdmDescription
    FieldDefs = <>
    Response = rspDescription
    Left = 88
    Top = 80
  end
  object fdmDescription: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'id'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'main'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'description'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'icon'
        DataType = ftWideString
        Size = 255
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 40
    Top = 56
  end
  object rclMain: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 
      'https://api.openweathermap.org/data/2.5/weather?lat=-26.195246&l' +
      'on=28.034088&appid=220d7fba1d56c5c98555c8d14cbcc20d'
    Params = <>
    SynchronizedEvents = False
    Left = 216
    Top = 16
  end
  object rqstMain: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = rclMain
    Params = <
      item
        Name = 'appid'
        Value = '220d7fba1d56c5c98555c8d14cbcc20d'
      end
      item
        Name = 'units'
        Value = 'metric'
      end
      item
        Name = 'lat, lon'
        Value = '-26.195246, 28.034088'
      end>
    Response = rspMain
    SynchronizedEvents = False
    Left = 256
    Top = 16
  end
  object rspMain: TRESTResponse
    ContentType = 'application/json'
    RootElement = 'main'
    Left = 288
    Top = 16
  end
  object RESTResponseDataSetAdapter2: TRESTResponseDataSetAdapter
    Active = True
    Dataset = fdmMain
    FieldDefs = <>
    Response = rspMain
    Left = 256
    Top = 64
  end
  object fdmMain: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'temp'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'feels_like'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'temp_min'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'temp_max'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'pressure'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'humidity'
        DataType = ftWideString
        Size = 255
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 312
    Top = 72
  end
  object RESTClient1: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 
      'http://api.openweathermap.org/data/2.5/forecast?lat=-26.195246&l' +
      'on=28.034088&appid=220d7fba1d56c5c98555c8d14cbcc20d'
    Params = <>
    SynchronizedEvents = False
    Left = 296
    Top = 184
  end
  object rqstForcast: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient1
    Params = <
      item
        Name = 'appid'
        Value = '220d7fba1d56c5c98555c8d14cbcc20d'
      end
      item
        Name = 'units'
        Value = 'metric'
      end
      item
        Name = 'lat, lon'
        Value = '-26.195246, 28.034088'
      end>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 256
    Top = 184
  end
  object RESTResponse1: TRESTResponse
    ContentType = 'application/json'
    RootElement = 'list'
    Left = 296
    Top = 224
  end
  object RESTResponseDataSetAdapter3: TRESTResponseDataSetAdapter
    Active = True
    Dataset = fdmForcast
    FieldDefs = <>
    Response = RESTResponse1
    TypesMode = Rich
    Left = 328
    Top = 184
  end
  object fdmForcast: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'dt'
        DataType = ftFloat
      end
      item
        Name = 'main'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'weather'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'clouds'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'wind'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'visibility'
        DataType = ftFloat
      end
      item
        Name = 'pop'
        DataType = ftFloat
      end
      item
        Name = 'rain'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'sys'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'dt_txt'
        DataType = ftWideString
        Size = 19
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 256
    Top = 224
  end
  object RESTClient2: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 
      'https://api.openweathermap.org/data/2.5/weather?lat=-26.195246&l' +
      'on=28.034088&appid=193598b59ced59c9f6e318f4788c8fa4'
    Params = <>
    SynchronizedEvents = False
    Left = 32
    Top = 216
  end
  object rqstWind: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient2
    Params = <
      item
        Name = 'appid'
        Value = '193598b59ced59c9f6e318f4788c8fa4'
      end
      item
        Name = 'units'
        Value = 'metric'
      end
      item
        Name = 'lat, lon'
        Value = '-26.195246, 28.034088'
      end>
    Response = RESTResponse2
    SynchronizedEvents = False
    Left = 88
    Top = 232
  end
  object RESTResponse2: TRESTResponse
    ContentType = 'application/json'
    RootElement = 'wind'
    Left = 48
    Top = 232
  end
  object RESTResponseDataSetAdapter4: TRESTResponseDataSetAdapter
    Active = True
    Dataset = fdmWind
    FieldDefs = <>
    Response = RESTResponse2
    Left = 56
    Top = 240
  end
  object fdmWind: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'speed'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'deg'
        DataType = ftWideString
        Size = 255
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 48
    Top = 280
  end
  object RESTClient3: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 
      'http://api.openweathermap.org/data/2.5/air_pollution?lat=-26.195' +
      '246&lon=28.034088&appid=193598b59ced59c9f6e318f4788c8fa4'
    Params = <>
    SynchronizedEvents = False
    Left = 496
    Top = 120
  end
  object rqstAQI: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient3
    Params = <
      item
        Name = 'appid'
        Value = '193598b59ced59c9f6e318f4788c8fa4'
      end
      item
        Name = 'lat, lon'
        Value = '-26.195246, 28.034088'
      end>
    Response = RESTResponse3
    SynchronizedEvents = False
    Left = 504
    Top = 128
  end
  object RESTResponse3: TRESTResponse
    ContentType = 'application/json'
    RootElement = 'list[0].main'
    Left = 520
    Top = 128
  end
  object RESTResponseDataSetAdapter5: TRESTResponseDataSetAdapter
    Active = True
    Dataset = fdmAQI
    FieldDefs = <>
    Response = RESTResponse3
    TypesMode = Rich
    Left = 520
    Top = 144
  end
  object fdmAQI: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'aqi'
        DataType = ftFloat
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 544
    Top = 128
  end
  object RESTClient4: TRESTClient
    BaseURL = 
      'http://api.openweathermap.org/data/2.5/air_pollution?lat=-26.195' +
      '246&lon=28.034088&appid=193598b59ced59c9f6e318f4788c8fa4'
    Params = <>
    SynchronizedEvents = False
    Left = 752
    Top = 264
  end
  object rqstComps: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient4
    Params = <
      item
        Name = 'appid'
        Value = '193598b59ced59c9f6e318f4788c8fa4'
      end
      item
        Name = 'lat, lon'
        Value = '-26.195246, 28.034088'
      end>
    Response = RESTResponse4
    SynchronizedEvents = False
    Left = 800
    Top = 264
  end
  object RESTResponse4: TRESTResponse
    RootElement = 'list[0].components'
    Left = 792
    Top = 312
  end
  object RESTResponseDataSetAdapter6: TRESTResponseDataSetAdapter
    Dataset = fdmComps
    FieldDefs = <>
    Response = RESTResponse4
    Left = 760
    Top = 304
  end
  object fdmComps: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    Left = 824
    Top = 288
  end
  object RESTClient5: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 
      'https://api.openweathermap.org/data/2.5/weather?lat=-26.195246&l' +
      'on=28.034088&appid=220d7fba1d56c5c98555c8d14cbcc20d'
    Params = <>
    SynchronizedEvents = False
    Left = 232
    Top = 328
  end
  object rqstClouds: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient5
    Params = <
      item
        Name = 'appid'
        Value = '220d7fba1d56c5c98555c8d14cbcc20d'
      end
      item
        Name = 'units'
        Value = 'metric'
      end
      item
        Name = 'lat, lon'
        Value = '-26.195246, 28.034088'
      end>
    Response = RESTResponse5
    SynchronizedEvents = False
    Left = 240
    Top = 336
  end
  object RESTResponse5: TRESTResponse
    ContentType = 'application/json'
    RootElement = 'clouds'
    Left = 280
    Top = 344
  end
  object RESTResponseDataSetAdapter7: TRESTResponseDataSetAdapter
    Active = True
    Dataset = fdmClouds
    FieldDefs = <>
    Response = RESTResponse5
    Left = 256
    Top = 352
  end
  object fdmClouds: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'all'
        DataType = ftWideString
        Size = 255
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 320
    Top = 376
  end
  object RESTClient6: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 
      'https://api.openweathermap.org/data/2.5/weather?lat=-26.195246&l' +
      'on=28.034088&appid=220d7fba1d56c5c98555c8d14cbcc20d'
    Params = <>
    SynchronizedEvents = False
    Left = 552
    Top = 216
  end
  object rqstVis: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient6
    Params = <
      item
        Name = 'appid'
        Value = '220d7fba1d56c5c98555c8d14cbcc20d'
      end
      item
        Name = 'units'
        Value = 'metric'
      end
      item
        Name = 'lat, lon'
        Value = '-26.195246, 28.034088'
      end>
    Response = RESTResponse6
    SynchronizedEvents = False
    Left = 568
    Top = 216
  end
  object RESTResponse6: TRESTResponse
    ContentType = 'application/json'
    RootElement = 'visibility'
    Left = 568
    Top = 232
  end
  object RESTResponseDataSetAdapter8: TRESTResponseDataSetAdapter
    Active = True
    Dataset = fdmVis
    FieldDefs = <>
    Response = RESTResponse6
    Left = 576
    Top = 240
  end
  object fdmVis: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'visibility'
        DataType = ftWideString
        Size = 255
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 584
    Top = 248
  end
  object RESTClient7: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 
      'https://api.openweathermap.org/data/2.5/weather?lat=-26.195246&l' +
      'on=28.034088&appid=220d7fba1d56c5c98555c8d14cbcc20d'
    Params = <>
    SynchronizedEvents = False
    Left = 736
    Top = 80
  end
  object rqstDetails: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient7
    Params = <
      item
        Name = 'appid'
        Value = '220d7fba1d56c5c98555c8d14cbcc20d'
      end
      item
        Name = 'units'
        Value = 'metric'
      end
      item
        Name = 'lat, lon'
        Value = '-26.195246, 28.034088'
      end>
    Response = RESTResponse7
    SynchronizedEvents = False
    Left = 768
    Top = 80
  end
  object RESTResponse7: TRESTResponse
    ContentType = 'application/json'
    RootElement = 'sys'
    Left = 752
    Top = 96
  end
  object RESTResponseDataSetAdapter9: TRESTResponseDataSetAdapter
    Active = True
    Dataset = fdmDetails
    FieldDefs = <>
    Response = RESTResponse7
    Left = 760
    Top = 104
  end
  object fdmDetails: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'type'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'id'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'country'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'sunrise'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'sunset'
        DataType = ftWideString
        Size = 255
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 800
    Top = 120
  end
end
