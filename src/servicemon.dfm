object WebInterf: TWebInterf
  Left = 393
  Top = 168
  Width = 770
  Height = 438
  Caption = 'Stree Service Monitor 1.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF009999
    99999999999999999999999999999FFFFFFFFFFFFF88888888888FFFFFF997FF
    FFFFFFFF888888888888888FFFF9977FFFFFFFF8444C444888888888FFF99777
    FFFFFF4444444444488888888FF997777FFF44444C4C4C4C4C48888888F99777
    77F44444443444444444888888F99777774C444C433C4C4C4C4C488888899777
    74444444C334C444C444C48888899777744C4C4C433C4C4C4C4C4C8888899777
    444444C43334CCC4C4C4C44888899777444C4C43333C4C4C4C4C4C3888899774
    4444C4433333CCCCC4CCC433888997744C4C4C4333333C4C4C4C4C3388899774
    4444C43333333CCCCCCCC43388899774444C4C333333CC4CCC4C4C3388899774
    4444C433333CCCCCCCC33333888997744C4C4C334C4C4CCCCCC3333388899774
    44444433CCCC3CCCCCC3333388F99777444C4C433C433C4CCC4C333888F99777
    4444343333333CCCCCCCC4C88FF99777744C333333333C4C4C433C88FFF99777
    7444333333333CCCCCC3348FFFF99777774C333333333C4C3C433FFFFFF99777
    7774333333C333CC3433FFFFFFF9977777774333334C333C4C377FFFFFF99777
    77777744433444C4477777FFFFF99777777777774C4C4C477777777FFFF99777
    777777777777777777777777FFF997777777777777777777777777777FF99777
    77777777777777777777777777F9999999999999999999999999999999990000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 81
    Top = 118
    Width = 681
    Height = 293
    Align = alClient
    Color = clNavy
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clYellow
    Font.Height = -8
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Lines.Strings = (
      'Initializing....')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 762
    Height = 118
    Align = alTop
    TabOrder = 1
    object Status1: TLabel
      Left = 13
      Top = 12
      Width = 204
      Height = 20
      Caption = 'Stree Service Monitor 1.0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object StripObjects: TListBox
    Left = 0
    Top = 118
    Width = 81
    Height = 293
    Align = alLeft
    ItemHeight = 13
    TabOrder = 2
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 48
    Top = 240
  end
  object HTTPServer: TIdHTTPServer
    Bindings = <>
    CommandHandlers = <>
    Greeting.NumericCode = -1
    ListenQueue = 120
    MaxConnectionReply.NumericCode = 0
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    ThreadMgr = IdThreadMgrPool1
    ParseParams = False
    SessionTimeOut = 120000
    Left = 48
    Top = 200
  end
  object IdThreadMgrPool1: TIdThreadMgrPool
    PoolSize = 100
    Left = 92
    Top = 200
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = Timer2Timer
    Left = 96
    Top = 240
  end
  object IdHTTP1: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 48
    Top = 160
  end
end
