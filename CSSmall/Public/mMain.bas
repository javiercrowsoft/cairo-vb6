Attribute VB_Name = "mMain"
Option Explicit

'--------------------------------------------------------------------------------
' mMain
' 05-02-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    Private Const SEM_FAILCRITICALERRORS = &H1
    Private Const SEM_NOGPFAULTERRORBOX = &H2
    Private Const SEM_NOOPENFILEERRORBOX = &H8000
    ' estructuras
    ' funciones
    Private Declare Sub InitCommonControls Lib "comctl32.dll" ()
    Private Declare Function SetErrorMode Lib "kernel32" (ByVal wMode As Long) As Long

    Private m_bInIDE As Boolean
'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mMain"
Public Const APP_NAME = "Cairo"

Private Const c_login = "login"
Private Const c_user = "user"
Private Const c_password = "password"
Private Const c_db_id = "db_id"
Private Const c_emp_id = "emp_id"

' estructuras
' variables privadas
Private m_ClientProcessId               As Long
Private m_Client                        As cTCPIPClient
Private m_InitCSOAPI                    As CSOAPI2.cInitCSOAPI
Private m_InitCSModulo                  As cModules
Private m_InitCSPrintMng                As CSPrintManager2.cInitCSPrintMng

' propiedades publicas
Public Property Get OAPI() As CSOAPI2.cInitCSOAPI
  Set OAPI = m_InitCSOAPI
End Property

Public Function ClientProcessId() As Long
  ClientProcessId = m_ClientProcessId
End Function
' propiedades privadas
' funciones publicas
Public Function LoginToCompany(ByRef ConnectString As String, _
                               ByRef UserName As String, _
                               ByRef Client As cTCPIPClient, _
                               ByRef db_id As Long, _
                               ByRef emp_id As Long, _
                               ByRef Password As String, _
                               ByVal ChangeCompany As Boolean) As Boolean
  Dim Login As cLogin
  Dim rslt  As Boolean
  
  Set Login = New cLogin
  
  rslt = Login.Login(APP_NAME, Client)
    
  If rslt Then
    m_ClientProcessId = Login.ClientProcessId
    
    ConnectString = Login.ConnectString
    UserName = Login.UserName
    Password = Login.Password
    db_id = Login.db_id
    emp_id = Login.emp_id
    
    LoginToCompany = True
  End If
  
  Set Login = Nothing
End Function

Public Function ConnectToCompany() As Boolean
  
  Dim ConnectString As String
  Dim UserName      As String
  Dim emp_id        As Long
  Dim bd_id         As Long
  
  Set m_Client = New cTCPIPClient
  Set fMain.Client = m_Client
  
  DoEvents
  
  If LoginToCompany(ConnectString, UserName, m_Client, bd_id, emp_id, "", False) Then
  
    If InitDlls(ConnectString, UserName, bd_id, emp_id) Then
      ConnectToCompany = True
    Else
      ConnectToCompany = False
    End If
  Else
    'MsgWarning "Ha continuación la aplicación deberá cerrarce ya que no fue posible conectarce con el servidor CrowSoft.;;Contáctese con el administrador del sistema.", "Cairo"
    CloseApp
    Unload fMain
    ConnectToCompany = False
  End If
End Function

Public Function GetStartupLine(ByVal User As String, ByVal Password As String, ByVal db_id As Long, ByVal emp_id) As String
  GetStartupLine = c_login & "=1;" & c_user & "=" & User & ";" & c_password & "=" & Password & ";" & c_db_id & "=" & db_id & ";" & c_emp_id & "=" & emp_id & ";"
End Function

Public Sub CloseApp()
  On Error Resume Next
  
  Set CSKernelClient2.OForms = Forms
  CSKernelClient2.FreeResource
  
  CloseDlls
  
  m_Client.TerminateSession
  
  Set m_Client = Nothing
  Set fMain.Client = Nothing
End Sub

Private Function InitDlls(ByVal ConnectString As String, ByVal UserName As String, _
                         ByVal bd_id As Long, ByVal emp_id As Long) As Boolean
  If Not InitDllsAux(ConnectString, UserName, bd_id, emp_id) Then
    CloseApp
    Unload fMain
    InitDlls = False
  Else
    CSKernelClient2.ShowForm fMain, "MAIN"
    fMain.Caption = APP_NAME & " - " & UserName & " - " & CSOAPI2.EmpNombre & " - " & m_InitCSOAPI.Database.dbName
    InitDlls = True
  End If
End Function

' funciones privadas
Private Function InitDllsAux(ByVal ConnetString As String, ByVal UserName As String, _
                             ByVal bd_id As Long, ByVal emp_id As Long) As Boolean
  '--------------------------------
  ' CSOAPI
  Set m_InitCSOAPI = New CSOAPI2.cInitCSOAPI
  m_InitCSOAPI.AppName = APP_NAME
  CSOAPI2.EmpId = emp_id
  CSOAPI2.BdId = bd_id
  If Not m_InitCSOAPI.Init(ConnetString, UserName, m_Client, m_ClientProcessId) Then Exit Function
  m_InitCSOAPI.ValidateVersion GetExeVersion
  
  ' Inicializo el objeto usuario de csoapi lamentablemente hay que hacerlo aca.
  If Not User.GetUser(m_InitCSOAPI.Database.UserId) Then CloseApp
  
  CSOAPI2.SecurityShowMessages = True
  
  '--------------------------------
  ' CSModulo
  Set m_InitCSModulo = New cModules
  Dim vModules() As String
  ReDim vModules(2)
  vModules(0) = "CSDocumento2.cInitCSDocumento"
  vModules(1) = "CSVenta2.cInitCSVenta"
  vModules(2) = "CSMuresco2.cInitCSMuresco"
  If Not m_InitCSModulo.Init(m_InitCSOAPI.Database, vModules()) Then
    Exit Function
  End If
  
  '--------------------------------
  ' CSPrintManager
  Set m_InitCSPrintMng = New CSPrintManager2.cInitCSPrintMng
  If Not m_InitCSPrintMng.Init(m_InitCSOAPI.Database) Then Exit Function
  
  '--------------------------------
  ' CSABMInterface
  Dim ObjAbm As Object
  Set ObjAbm = CSKernelClient2.CreateObject("CSABMInterface2.cABMInterfaceMain")

  ObjAbm.AppPath = App.Path
  
  Set ObjAbm = Nothing
  
  InitDllsAux = True
End Function

Private Sub CloseDlls()
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  'CSOAPI2.AvisoTerminate
  Set m_InitCSOAPI = Nothing
  
  m_InitCSModulo.Terminate
  Set m_InitCSModulo = Nothing
  Set m_InitCSPrintMng = Nothing
End Sub

' construccion - destruccion
Public Sub Main()
  On Error GoTo ControlError

  InitCommonControls
  
  '--------------------------------
  ' Antes que nada hay que decirle al
  ' Kernel cual es la aplicacion CSKernelClient
  CSKernelClient2.AppName = APP_NAME
  CSKernelClient2.Title = APP_NAME
  
  Load fMain
  fMain.Show
  
  If ConnectToCompany Then
  
    CreateSendKey
    fMain.ShowList
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "Main", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Function GetExeVersion() As String
  GetExeVersion = App.Major & "." & Format(App.Minor, "00") & "." & Format(App.Revision, "00")
End Function

' Auxiliares
Public Sub UnloadApp()
  If Not InIDE() Then
    SetErrorMode SEM_NOGPFAULTERRORBOX
  End If
End Sub

Public Property Get InIDE() As Boolean
  Debug.Assert (IsInIDE())
  InIDE = m_bInIDE
End Property

Private Function IsInIDE() As Boolean
  m_bInIDE = True
  IsInIDE = m_bInIDE
End Function
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



