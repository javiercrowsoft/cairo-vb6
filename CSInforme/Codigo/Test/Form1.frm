VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command1 
      Caption         =   "Ejecutar"
      Height          =   315
      Left            =   240
      TabIndex        =   0
      Top             =   660
      Width           =   1635
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
  Dim WebReport
  
  Set WebReport = CreateObject("CSReportWeb.cWebReport")
  
  WebReport.Path = "D:\Proyectos\CSHtml\CrowSoft\Reports"
  
  If Not WebReport.Init("file name=C:\CrowSoftWeb.UDL", "administrador", 0, 1) Then
    ShowError "No fue posible inicializar el reporte."
    Exit Sub
  End If

  Dim RptId
  RptId = 144
  
  If Not WebReport.LoadParams(RptId) Then
    ShowError "No fue posible cargar los parametros del reporte."
    Exit Sub
  End If
  
  Dim Param As Object
  
  For Each Param In WebReport.params
    Param.Visible = False
  Next

  Dim FileName
  Dim FullFile
  FileName = "Reporte-" & 1 & "-" & Format(Now, "yyy-mm-dd hh.nn.ss") & ".pdf"
  FullFile = "D:\Proyectos\CSHtml\CrowSoft\Reports\" & FileName

  If Not WebReport.Launch(RptId, "MS Publisher Imagesetter", "winspool", "FILE:", FullFile) Then
    ShowError "No fue posible generar el reporte."
    Exit Sub
  End If
  
  Set WebReport = Nothing
End Sub

Private Sub ShowError(ByVal msg As String)
  MsgBox msg
End Sub

