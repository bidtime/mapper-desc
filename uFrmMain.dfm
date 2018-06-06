object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #20027#31383#21475
  ClientHeight = 669
  ClientWidth = 1289
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 377
    Top = 29
    Width = 4
    Height = 621
    ExplicitLeft = 373
    ExplicitTop = 8
  end
  object Splitter2: TSplitter
    Left = 758
    Top = 29
    Width = 4
    Height = 621
    ExplicitLeft = 385
    ExplicitTop = 37
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 1289
    Height = 29
    ButtonHeight = 21
    Caption = 'ToolBar1'
    TabOrder = 0
    object Edit1: TEdit
      Left = 0
      Top = 0
      Width = 945
      Height = 21
      TabOrder = 0
      Text = 
        'C:\tools\working\svn\yuntong\dev\ecarpo-bms\ecarpo-bms-server\ec' +
        'arpo-bms-vs-server\ecarpo-bms-vs-server-provider\src\main\java\c' +
        'om\ecarpo\bms\dvs\server\batch\batchindtl\dao - Copy'
    end
    object ToolButton1: TToolButton
      Left = 945
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      Style = tbsSeparator
    end
    object Edit2: TEdit
      Left = 953
      Top = 0
      Width = 56
      Height = 21
      TabOrder = 2
      Text = '*DAO.java'
    end
    object Button1: TButton
      Left = 1009
      Top = 0
      Width = 75
      Height = 21
      Caption = 'go'
      TabOrder = 1
      OnClick = Button1Click
    end
    object CheckBox1: TCheckBox
      Left = 1084
      Top = 0
      Width = 97
      Height = 21
      Caption = 'CheckBox1'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 650
    Width = 1289
    Height = 19
    Panels = <
      item
        Width = 200
      end
      item
        Width = 200
      end>
  end
  object MemoFiles: TMemo
    Left = 0
    Top = 29
    Width = 377
    Height = 621
    Align = alLeft
    Lines.Strings = (
      'MemoFiles')
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object memoTarget: TMemo
    Left = 762
    Top = 29
    Width = 527
    Height = 621
    Align = alClient
    Lines.Strings = (
      'MemoTarget')
    ScrollBars = ssBoth
    TabOrder = 3
  end
  object MemoSrc: TMemo
    Left = 381
    Top = 29
    Width = 377
    Height = 621
    Align = alLeft
    Lines.Strings = (
      'MemoSrc')
    ScrollBars = ssBoth
    TabOrder = 4
  end
end
