VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cWebReport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cWebReport
' 06-07-2005

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cWebReport"

Private Const APP_NAME = "WebReport"

Private Const c_RPT_KEY = "RPT-CONFIG"
Private Const c_RPT_PathReportes = "RPT_PATH_REPORTES"
Private Const c_RPT_CommandTimeOut = "RPT_COMMAND_TIMEOUT"
Private Const c_RPT_ConnectionTimeOut = "RPT_CONNECTION_TIMEOUT"

' estructuras
' variables privadas
Private m_InitCSOAPI                    As CSOAPI2.cInitCSOAPI
Private m_InitCSInforme                 As CSInforme2.cInitCSInforme
Private m_Rpt                           As CSInforme2.cReporte
Private m_Path                          As String
' eventos
' propiedades publicas
Property Get Params() As cInformeParametros
  Set Params = m_Rpt.Params
End Property

Public Property Let Path(ByVal rhs As String)
  m_Path = rhs
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Init(ByVal ConnectString As String, _
                     ByVal UserName As String, _
                     ByVal bd_id As Long, _
                     ByVal emp_id As Long) As Boolean
  
  On Error GoTo ControlError
                     
  pSaveLog "ConnectString: " & ConnectString
  pSaveLog "UserName: " & UserName
  pSaveLog "bd_id: " & bd_id
  pSaveLog "emp_id: " & emp_id
                     
  '--------------------------------
  ' Silent
  CSKernelClient2.cWindow.Silent = True
                     
  '--------------------------------
  ' CSOAPI
  
  pSaveLog "Creando objeto CSOAPI2.cInitCSOAPI"
    
    Set m_InitCSOAPI = New CSOAPI2.cInitCSOAPI
    m_InitCSOAPI.AppName = APP_NAME
    CSOAPI2.EmpId = emp_id
    CSOAPI2.BdId = bd_id
    
    pSaveLog "CSOAPI2.cInitCSOAPI creado con exito"
    
  pSaveLog "Inicializando CSOAPI"
  If Not m_InitCSOAPI.Init(ConnectString, UserName, Nothing, 0) Then
    pSaveLog "Fallo al crear CSOAPI. " & CSKernelClient2.LastErrorDescription
    Exit Function
  End If
  m_InitCSOAPI.Database.Silent = True
  pSaveLog "String de Conexión Original: " & m_InitCSOAPI.Database.OriginalStrConnect
  pSaveLog "String de Conexión de cDataBase: " & m_InitCSOAPI.Database.StrConnect
  pSaveLog "CSOAPI inicializada con exito"
  
  ' Inicializo el objeto usuario de csoapi lamentablemente hay que hacerlo aca.
  pSaveLog "Invocando a GetUser"
  If Not User.GetUser(m_InitCSOAPI.Database.UserId) Then
    pSaveLog "GetUser fallo. " & CSKernelClient2.LastErrorDescription
    Exit Function
  End If
  
  CSOAPI2.SecurityShowMessages = False
  
  '--------------------------------
  ' CSInforme
  pSaveLog "Inicializando CSInforme2.cInitCSInforme"
  Set m_InitCSInforme = CSKernelClient2.CreateObject("CSInforme2.cInitCSInforme")
  pSaveLog "CSInforme2.cInitCSInforme Creado con Exito"
  If Not m_InitCSInforme.InitForWeb(m_InitCSOAPI.Database) Then
    pSaveLog "La inicializacion de CSInforme2.cInitCSInforme fallo. " & CSKernelClient2.LastErrorDescription
    Exit Function
  End If
  pSaveLog "CSInforme2.cInitCSInforme inicializada"
  
  '--------------------------------
  ' CSABMInterface
  Dim ObjAbm As Object
  Set ObjAbm = CSKernelClient2.CreateObject("CSABMInterface2.cABMInterfaceMain")

  ObjAbm.AppPath = pGetPath
  Set ObjAbm = Nothing
  
  Init = True

  GoTo ExitProc
ControlError:
  MngError Err, "Init", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function LoadParams(ByVal rpt_id As Long) As Boolean
  On Error GoTo ControlError
  
  pSaveLog "Creando objeto CSInforme2.cReporte"
  Set m_Rpt = CSKernelClient2.CreateObject("CSInforme2.cReporte")
  
  Dim ObjEdit As CSInterfacesABM.cIEditGenericListDoc
  Set ObjEdit = m_Rpt
  Set ObjEdit.ObjAbm = CSKernelClient2.CreateObject("CSABMInterface2.cABMGenericListDoc")
  
  pSaveLog "Ini File en : " & GetFullIniFileName
  
  m_Rpt.Id = rpt_id
  m_Rpt.Path = GetRptPath()
  m_Rpt.CommandTimeout = GetRptCommandTimeOut
  m_Rpt.ConnectionTimeOut = GetRptConnectionTimeOut
  
  pSaveLog "Cargando los parametros"
  If Not m_Rpt.LoadShowParams() Then
    pSaveLog "Cargando los parametros. " & CSKernelClient2.LastErrorDescription
    Exit Function
  End If
  pSaveLog "Los parametros se cargaron con exito"

  LoadParams = True

  GoTo ExitProc
ControlError:
  MngError Err, "LoadParams", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function Launch(ByVal rpt_id As Long, _
                       ByVal DeviceName As String, _
                       ByVal DriverName As String, _
                       ByVal port As String, _
                       ByVal FileName As String) As Boolean
  On Error GoTo ControlError
  
  pDelete pGetPdfFile()

  pSaveLog "Iniciando rpt " & DeviceName & ", " & DriverName & ", " & port
  
  Dim oLaunchInfo As cReportLaunchInfo
  
  Set oLaunchInfo = New cReportLaunchInfo
  
  With oLaunchInfo
    .InitPrinter DeviceName, DriverName, port
    .ShowPrintersDialog = False
  End With
  
  If Not pLaunch(oLaunchInfo) Then Exit Function
  
  pSaveLog "Reporte impreso con éxito"
  
  Launch = pRename(FileName)

  GoTo ExitProc
ControlError:
  MngError Err, "Launch", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' funciones friend
' funciones privadas
Private Function pLaunch(ByRef oLaunchInfo As cReportLaunchInfo) As Boolean
  On Error Resume Next
  
  pSaveLog "Imprimiendo el reporte"
  
  If Not m_Rpt.LaunchEx(csRptLaunchPrinter, oLaunchInfo, True) Then
    
    pSaveLog "Launch devolvio: " & CSKernelClient2.LastErrorDescription _
          & vbCrLf & "Funcion: " & CSKernelClient2.LastErrorFunction _
           & vbCrLf & "Module: " & CSKernelClient2.LastErrorModule _
             & vbCrLf & "Line: " & CSKernelClient2.LastErrorLine
    
    pSaveLog "Connect de rpt: " & m_Rpt.Rpt.Connect.StrConnect
    pSaveLog "Connect de oLaunchInfo: " & oLaunchInfo.StrConnect
    pSaveLog "Error en cDatabase: " & m_InitCSOAPI.Database.LastDBError
    
    Exit Function
  End If
  
  pLaunch = True
End Function

Private Sub pWaitToFileBeCreated(ByVal File As String)
  Dim n As Integer
  Do While Dir(File) = ""
    Sleep 500
    n = n + 1
    If n > 360 Then Exit Sub
  Loop
End Sub

Private Function pRename(ByVal FileName As String) As Boolean
  pWaitToFileBeCreated pGetPdfFile()
  
  pDelete FileName
  
  ' Es probable que se este creando
  ' y aun no puedo copiarlo
  '
  On Error Resume Next
  Sleep 500
  
  Dim n As Integer
  Do While Dir(FileName) = ""
  
    FileCopy pGetPdfFile(), FileName
    
    Sleep 500
    n = n + 1
    If n > 360 Then Exit Function
  Loop
  
  pRename = Dir(FileName) <> ""
  
End Function

Private Function pGetPdfFile() As String
  pGetPdfFile = pGetPath & "Reporte.pdf"
End Function

Private Sub pDelete(ByVal File As String)
  On Error Resume Next
  
  pSaveLog "Borrando " & File
  
  If Dir(File) = "" Then Exit Sub
  Kill File
  
  If Err.Number Then
    Dim errDescription As String
    errDescription = Err.Description
    pSaveLog "Error al borrar el archivo" & File
    pSaveLog "   Error : " & errDescription
  End If
End Sub

Private Function GetRptPath() As String
  GetRptPath = GetValidPath(IniGetEx(c_RPT_KEY, c_RPT_PathReportes, pGetPath))
End Function

Private Function GetRptCommandTimeOut() As Long
  GetRptCommandTimeOut = Val(IniGetEx(c_RPT_KEY, c_RPT_CommandTimeOut, 0))
End Function

Private Function GetRptConnectionTimeOut() As Long
  GetRptConnectionTimeOut = Val(IniGetEx(c_RPT_KEY, c_RPT_ConnectionTimeOut, 0))
End Function

Private Sub pSaveLog(ByVal Msg As String)
  On Error Resume Next
  Dim f As Integer
  f = FreeFile
  Open pGetPath & "webreport.log" For Append As f
  Print #f, Now & " " & Msg
  Close f
End Sub

Private Sub MngError(ByRef ErrObj As Object, ByVal FunctionName As String, ByVal Module As String, ByVal InfoAdd As String)
  CSKernelClient2.MngError ErrObj, FunctionName, Module, InfoAdd
  pSaveLog CSKernelClient2.LastErrorDescription
End Sub

Private Function pGetPath() As String
  pGetPath = CSKernelClient2.GetValidPath(m_Path)
End Function
' construccion - destruccion
Private Sub Class_Terminate()
  On Error GoTo ControlError

  DoEvents: DoEvents: DoEvents: DoEvents

  Set m_InitCSOAPI = Nothing
  Set m_InitCSInforme = Nothing
  Set m_Rpt = Nothing

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

