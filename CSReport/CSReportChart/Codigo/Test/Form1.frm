VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3090
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3090
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   495
      Left            =   1740
      TabIndex        =   0
      Top             =   1320
      Width           =   1215
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Function ShowTypeGraphic(rs, ReportType, FieldToSumGraphic, AGroups)
  Dim ChartDir, ipos
  Dim chart, i, FileName
  
  If ReportType = "pie" Then
    ReportType = 0
  Else
    ReportType = 1
  End If
  
  FileName = "chart-" & 1 & "-" & Replace(Replace(Replace(Now, "/", ""), ":", ""), " ", "") & ".png"
  FileName = "D:\proyectos\CSHtml\CrowSoft\Site\temp\" & FileName
  
  Set chart = CreateObject("CSReportWebChart.cReportChart")
  
  For i = 1 To UBound(AGroups, 2)
    If GetChart(chart, FileName, pGetRsResumido(rs, _
                                                pGetFieldIndex(rs, AGroups(0, i)), _
                                                pGetFieldIndex(rs, FieldToSumGraphic)), _
                                                ReportType) Then
    
      Debug.Print "<table border='0'>"
      Debug.Print "<tr><td align=center><img src='" + FileName + "' alt='grafico'></td>"
      Debug.Print "</tr></table>"
    End If
  Next
End Function

Private Function pGetRsResumido(rs, IndexSerie, IndexValue)
  Dim rs2
  
  Set rs2 = CreateObject("ADODB.Recordset")
  rs2.Fields.Append "Serie", 200, 244
  rs2.Fields.Append "Value", 5
  rs2.Open
  
  Dim lastSerie
  Dim sumary
  lastSerie = ""
  sumary = 0
  
  While Not rs.EOF
    
    If rs.Fields.Item(IndexSerie).Value <> lastSerie Then
    
      If lastSerie <> "" Then
        rs2.AddNew
        rs2.Fields(0).Value = lastSerie
        rs2.Fields(1).Value = sumary
        rs2.Update
      End If
      
      lastSerie = rs.Fields.Item(IndexSerie).Value
      sumary = 0
    End If
    
    sumary = sumary + rs.Fields.Item(IndexValue).Value
    
    rs.MoveNext
  Wend

  If lastSerie <> "" Then
    rs2.AddNew
    rs2.Fields(0).Value = lastSerie
    rs2.Fields(1).Value = sumary
    rs2.Update
  End If
  
  rs2.MoveFirst
  
  Set pGetRsResumido = rs2

End Function


Function GetChart(chart, FileName, rs, ReportType)
  GetChart = False
  
  GetChartFile chart, FileName, rs, ReportType, _
               "Serie", _
               0, _
               "Value", _
               1
End Function

Function pGetFieldIndex(rs, fieldName)
  pGetFieldIndex = -1

  If rs Is Nothing Then Exit Function
  If rs.State <> 1 Then Exit Function

  Dim f
  Dim i
  
  For Each f In rs.Fields
    If LCase(fieldName) = LCase(f.Name) Then
      pGetFieldIndex = i
      Exit Function
    End If
    i = i + 1
  Next

End Function

Function GetChartFile(chart, FileName, rs, ReportType, _
                      LabelFieldName, LabelIndex, _
                      ValueFieldName, ValueIndex)

  chart.ChartTitle = ""
  chart.ChartType = ReportType
  chart.Diameter = 200 ' Medium
  chart.Thickness = 8  ' Medium
  chart.ShowValues = True
  chart.OutlineBars = 3
  chart.Sort = False
  chart.Top = 10
  
  chart.GroupFieldName = ""
  chart.GroupFieldIndex = -1
  chart.GroupValue = -1
  
  chart.Series.Add Nothing
  chart.Series(1).LabelFieldName = LabelFieldName
  chart.Series(1).LabelIndex = LabelIndex
  chart.Series(1).ValueFieldName = ValueFieldName
  chart.Series(1).ValueIndex = ValueIndex

  On Error Resume Next
    
  chart.MakeChartFromRsVariant rs, Trim(FileName)
  
  Debug.Print "<p>err2: " & Err.Description
  
  Debug.Print "<p>LabelFieldName " & LabelFieldName
  Debug.Print "<p>LabelIndex " & LabelIndex
  Debug.Print "<p>ValueFieldName " & ValueFieldName
  Debug.Print "<p>ValueIndex " & ValueIndex
  Debug.Print "<p>FileName " & FileName
  
  GetChartFile = True
End Function


Private Sub Command1_Click()
  Dim rs
  Dim sqlstmt
  sqlstmt = "DC_CSC_TSR_0015 1,'20070101','20080414','0','0','0','0','0','0','0'"
  
  Set rs = RunSqlReturnRs(sqlstmt)
  
  Dim AGroups
  ReDim AGroups(1, 1)
  AGroups(0, 0) = ""
  AGroups(0, 1) = "Cliente"
  
  ShowTypeGraphic rs, "pie", "total", AGroups
End Sub

Function RunSqlReturnRs(strSP)
  Dim dbhelper
  Set dbhelper = CreateObject("CSWebDataBase.cDBHelper")
  
  'on error resume next
  
  'err.Clear
  
  Set RunSqlReturnRs = dbhelper.RunSqlReturnRs(strSP, Empty)
  
  'if err.number then
  
  ' set RunSqlReturnRs = dbhelper.RunSQLReturnRS(strSP,empty)
  
  ' if err.number then
    
  '   report_error_msg = err.Description
    
  ' end if
  
  'end if
End Function

'Function GetChartFile(chart, FileName, rs, ReportType, _
'                      LabelFieldName, LabelIndex, _
'                      ValueFieldName, ValueIndex)
'
'  chart.ChartTitle = ""
'  chart.ChartType = ReportType
'  chart.Diameter = 200 ' Medium
'  chart.Thickness = 8  ' Medium
'  chart.ShowValues = True
'  chart.OutlineBars = 3
'  chart.Sort = False
'  chart.Top = 10
'
'  chart.GroupFieldName = ""
'  chart.GroupFieldIndex = 0
'  chart.GroupValue = 0
'
'  chart.Series.Add Nothing
'  chart.Series(1).LabelFieldName = LabelFieldName
'  chart.Series(1).LabelIndex = LabelIndex
'  chart.Series(1).ValueFieldName = ValueFieldName
'  chart.Series(1).ValueIndex = ValueIndex
'
'  On Error Resume Next
'    Dim Rows 'As Variant
'    Rows = rs.GetRows()
'
'    Response.Write "<p>err1: " & Err.Description
'
'  chart.MakeChartFromRs rs, FileName
'
'  Response.Write "<p>err2: " & Err.Description
'
'  Response.Write "<p>LabelFieldName " & LabelFieldName
'  Response.Write "<p>LabelIndex " & LabelIndex
'  Response.Write "<p>ValueFieldName " & ValueFieldName
'  Response.Write "<p>ValueIndex " & ValueIndex
'  Response.Write "<p>FileName " & FileName
'
'  GetChartFile = True
'End Function

