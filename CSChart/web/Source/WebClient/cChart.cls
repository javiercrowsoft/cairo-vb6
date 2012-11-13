VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cChart"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Function GetChart( _
      ByVal chartType As CSChartServer.eChartType, _
      ByVal AlternateColor As GpGDIPlus.colors, _
      ByVal PrimaryColor As GpGDIPlus.colors, _
      ByVal LineStyle As CSChartServer.eLineStyle, _
      ByVal bLinesYes As Boolean, _
      ByVal bValuesYes As Boolean, _
      ByVal ChartThickness As CSChartServer.ePieThickness, _
      ByVal ChartSize As CSChartServer.ePieDiameter, _
      ByVal FormatType As CSChartServer.eChartFormat _
                         ) As Variant
  On Error GoTo ControlError
  Dim chart As cWebChart
  Set chart = New cWebChart
  
  chart.NewChartType chartType, "Chart sample"
  
  pFill chart
  
  chart.ColorAlternate = AlternateColor
  chart.ColorPrimary = PrimaryColor
  
  chart.GridLines = LineStyle
  chart.OutlineBars = bLinesYes
  chart.ShowValues = bValuesYes
  
  chart.Thickness = ChartThickness
  chart.Diameter = ChartSize
  
  chart.Format = FormatType
  chart.SaveTo = SaveToFile
  
  Dim FileName As String
  FileName = GetValidPath(Environ$("TEMP")) & "~ChartImage"
  chart.FileName = FileName
  
  pSaveLog FileName
  
  pKillFile FileName
  
  chart.CopyRight = "© CrowSoft 2005"
  chart.RenderWebChartImage
  
  GetChart = LoadChart(FileName)
  
  pSaveLog "success"
  
  GoTo ExitProc
ControlError:
  If Err.Number Then
    pSaveLog Err.Description
    Resume ExitProc
  End If
ExitProc:
  On Error Resume Next
  chart.Dispose
  Set chart = Nothing
End Function

Private Sub pFill(ByRef chart As cWebChart)
  With chart.WebChartItems.Item(chart.WebChartItems.Add(Nothing))
    .AlternateValue = 10
    .PrimaryValue = 100
  End With

  With chart.WebChartItems.Item(chart.WebChartItems.Add(Nothing))
    .AlternateValue = 20
    .PrimaryValue = 90
  End With

  With chart.WebChartItems.Item(chart.WebChartItems.Add(Nothing))
    .AlternateValue = 30
    .PrimaryValue = 80
    .Explode = True
  End With

  With chart.WebChartItems.Item(chart.WebChartItems.Add(Nothing))
    .AlternateValue = 40
    .PrimaryValue = 70
  End With

  With chart.WebChartItems.Item(chart.WebChartItems.Add(Nothing))
    .AlternateValue = 50
    .PrimaryValue = 60
  End With

  With chart.WebChartItems.Item(chart.WebChartItems.Add(Nothing))
    .AlternateValue = 60
    .PrimaryValue = 50
  End With

  With chart.WebChartItems.Item(chart.WebChartItems.Add(Nothing))
    .AlternateValue = 70
    .PrimaryValue = 40
  End With

  With chart.WebChartItems.Item(chart.WebChartItems.Add(Nothing))
    .AlternateValue = 80
    .PrimaryValue = 30
  End With

  With chart.WebChartItems.Item(chart.WebChartItems.Add(Nothing))
    .AlternateValue = 90
    .PrimaryValue = 110
  End With

  With chart.WebChartItems.Item(chart.WebChartItems.Add(Nothing))
    .AlternateValue = 100
    .PrimaryValue = 10
  End With

End Sub

Private Sub pKillFile(ByVal File As String)
  On Error Resume Next
  Kill File
End Sub

Private Function GetValidPath(ByVal path As String) As String
  If Right(path, 1) <> "\" Then path = path & "\"
  GetValidPath = path
End Function

Private Function LoadChart(ByVal File As String) As Byte()
  Dim f        As Integer
  Dim vBuff()  As Byte
  
  f = FreeFile
  
  Open File For Binary As f
  ReDim vBuff(LOF(f))
  
  Get #f, , vBuff()
  
  Close f
  
  pSaveLog UBound(vBuff)
  
  LoadChart = vBuff
End Function

Private Sub pSaveLog(ByVal Msg As String)
  On Error Resume Next
  Dim f As Integer
  f = FreeFile
  Open GetValidPath(Environ$("TEMP")) & "error.log" For Append As f
  Print #f, Now & " " & Msg
  Close f
End Sub
