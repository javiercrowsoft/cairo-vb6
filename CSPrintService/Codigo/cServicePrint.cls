VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cServicePrint"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cServicePrint
' 01-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' Interfaces
Implements cIService

' constantes
Private Const C_Module = "cServicePrint"
' estructuras
' variables privadas
Private m_ServiceID   As Long
Private m_Server      As cIServer

' eventos
' propiedadades publicas
Private Property Let cIService_ServiceID(ByVal RHS As Long)
  m_ServiceID = RHS
End Property

Private Property Get cIService_ServiceID() As Long
  cIService_ServiceID = m_ServiceID
End Property

Private Property Set cIService_Server(RHS As CSIService.cIServer)
  Set m_Server = RHS
End Property

Private Property Get cIService_Server() As CSIService.cIServer
  Set cIService_Server = m_Server
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub cIService_ClientShutDown(ByVal ClientId As Long)

End Sub

Private Sub cIService_WndProc(ByVal ClientId As Long, Message() As Byte, Response() As Byte)
  Response = Message
End Sub

Private Sub pPrintPDF()
  Dim WebReport
  
  Set WebReport = CreateObject("CSReportWeb.cWebReport")
  
  Dim Path          As String
  Dim DeviceName    As String
  Dim DriverName    As String
  Dim Port          As String
  
  Path = "D:\Proyectos\CSHtml\CrowSoft\Reports"
  DeviceName = "MS Publisher Imagesetter"
  DriverName = "winspool"
  Port = "FILE:"
  
  WebReport.Path = Path
  
  If Not WebReport.Init("file name=C:\CrowSoftWeb.UDL", "administrador", 0, 0) Then
    SaveLog "No fue posible inicializar el reporte."
    Exit Sub
  End If

  Dim RptId
  RptId = 51
'  RptId = Request.QueryString("RptId")
'
  If Not WebReport.LoadParams(RptId) Then
    SaveLog "No fue posible cargar los parametros del reporte."
    Exit Sub
  End If

  Dim Param

  For Each Param In WebReport.params
    SetParamValue Param
    Param.Visible = False
  Next

  Dim FileName
  Dim FullFile
'  FileName = "Reporte-" & g_UsuarioID & "-" & Replace(Replace(Replace(Now, "/", ""), ":", ""), " ", "") & ".pdf"
  FileName = "Reporte-1-" & Replace(Replace(Replace(Now, "/", ""), ":", ""), " ", "") & ".pdf"
  FullFile = Path & "\" & FileName
  
  If Not WebReport.Launch(RptId, DeviceName, DriverName, Port, FullFile) Then
    SaveLog "No fue posible generar el reporte."
    Exit Sub
  End If
  
  Set WebReport = Nothing
End Sub

Sub SetParamValue(Param)

  Select Case Param.tipo
    Case 1
      Param.Default = "2006/09/01"
    Case 2
      Param.Default = 0
    Case 7
      Param.Default = 0
  End Select

End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  m_ServiceID = SRV_ID_PRINT

  pPrintPDF

  Set m_Server = gServer
  gServiceCreated = True

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_Server = Nothing
  gServiceCreated = False
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub


'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


