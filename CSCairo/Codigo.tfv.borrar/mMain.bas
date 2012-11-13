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
    'Private Const SEM_NOGPFAULTERRORBOX = &H2
    ' estructuras
    ' funciones
    Private Declare Sub InitCommonControls Lib "comctl32.dll" ()
    'Private Declare Function SetErrorMode Lib "kernel32" (ByVal wMode As Long) As Long

    'Private m_bInIDE As Boolean
'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mMain"

#If PREPROC_QBPOINT Then

  Public Const APP_NAME = "QBOnix"
  
#Else

  Public Const APP_NAME = "Cairo"
  
#End If

Private Const c_login_emp_emp = "login_to_emp_emp"
Private Const c_login_emp_db = "login_to_emp_db"

Private Const c_login = "login"
Private Const c_user = "user"
Private Const c_password = "password"
Private Const c_db_id = "db_id"
Private Const c_emp_id = "emp_id"
Private Const c_server = "server"
Private Const c_port = "port"

' estructuras
' variables privadas
Private m_ClientProcessId               As Long
Private m_Client                        As cTCPIPClient
Private m_InitCSOAPI                    As CSOAPI2.cInitCSOAPI
Private m_InitCSModulo                  As CSModulo2.cInitCSModulo
Private m_InitCSPrintMng                As CSPrintManager2.cInitCSPrintMng

Private m_server                        As String
Private m_port                          As Long

Private m_bLoginToEmpresa               As Boolean

#If Not PREPROC_SFS2 And Not PREPROC_SMALL And Not PREPROC_NO_EXBAR Then
Private m_InitCSOAPIAvisos              As CSOAPIAvisos.cInitCSOAPIAvisos
#End If

' propiedades publicas
' Maestros
#If Not PREPROC_SMALL Then
Public fPermisosRoles          As fPermisos
Public fPermisosUsuarios       As fPermisos
#End If

#If (Not PREPROC_SFS2) And (Not PREPROC_SMALL2) Then
Public fReportes               As fDesktop
Public fProcesos               As fDesktop
#End If

Public Property Get LoginToEmpresa()
  LoginToEmpresa = m_bLoginToEmpresa
End Property

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
  
  If pLoginFromCommandLine() And Not ChangeCompany Then
  
    UserName = pGetCommandLine(c_user)
    Password = pGetCommandLine(c_password)
    db_id = pGetCommandLine(c_db_id)
    emp_id = pGetCommandLine(c_emp_id)
    m_server = pGetCommandLine(c_server)
    m_port = Val(pGetCommandLine(c_port))
    
    Login.Server = m_server
    Login.Port = m_port
    
    rslt = Login.LoginSilent(APP_NAME, Client, UserName, Password, db_id, emp_id)
  
'  ElseIf pLoaginToEmpresa() Then
'
'    Dim db_id_emp As String
'    Dim emp_nombre As String
'
'    db_id_emp = Val(pGetCommandLine(c_login_emp_db))
'    emp_nombre = pGetCommandLine(c_login_emp_emp)
'
'    rslt = Login.LoginToEmpresa(APP_NAME, Client, db_id_emp, emp_nombre)
  
  Else
    
    m_server = pGetCommandLine(c_server)
    m_port = Val(pGetCommandLine(c_port))
    
    Login.Server = m_server
    Login.Port = m_port
    
    rslt = Login.Login(APP_NAME, Client)
  End If
    
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

#If Not PREPROC_SMALL2 Then
  Set fMain.Client = m_Client
#End If
  
  fMain.RefreshTabs
  DoEvents
  
  If LoginToCompany(ConnectString, UserName, m_Client, bd_id, emp_id, "", False) Then

#If Not PREPROC_SMALL Then
    fSplash.Refresh
#End If

    pSetEmail ConnectString

    If InitDlls(ConnectString, UserName, bd_id, emp_id) Then
      ConnectToCompany = True
    Else
      ConnectToCompany = False
    End If
  Else
    CloseApp
    Unload fMain
    ConnectToCompany = False
  End If
  
#If PREPROC_SMALL2 Then

  m_Client.TerminateSession
  Set m_Client = Nothing
  Set fMain.Client = Nothing
  
#End If

End Function

Public Function GetStartupLine(ByVal User As String, _
                               ByVal Password As String, _
                               ByVal db_id As Long, _
                               ByVal emp_id) As String
  GetStartupLine = c_login & "=1;" & _
                   c_user & "=" & User & ";" & _
                   c_password & "=" & Password & ";" & _
                   c_db_id & "=" & db_id & ";" & _
                   c_emp_id & "=" & emp_id & ";" & _
                   c_server & "=" & m_server & ";" & _
                   c_port & "=" & m_port
End Function

Public Sub CloseApp()
  On Error Resume Next
  
  Set CSKernelClient2.OForms = Forms
  CSKernelClient2.FreeResource
  
  CloseDlls
  
#If Not PREPROC_SMALL2 Then
  
  m_Client.TerminateSession
  Set m_Client = Nothing
  Set fMain.Client = Nothing
  
#End If

End Sub

Private Function InitDlls(ByVal ConnectString As String, ByVal UserName As String, _
                         ByVal bd_id As Long, ByVal emp_id As Long) As Boolean
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  If Not InitDllsAux(ConnectString, UserName, bd_id, emp_id) Then
    CloseApp
    Unload fMain
    InitDlls = False
  Else
    CSKernelClient2.AppPath = App.Path
    
#If PREPROC_QBPOINT Then
    
    CSKernelClient2.DefaultHelpFile = "qbonix.chm"
    
#Else

    CSKernelClient2.DefaultHelpFile = "cairo.chm"
    
#End If

    CSKernelClient2.ShowForm fMain, "MAIN"
#If PREPROC_SMALL Then
    fMain.Caption = "(small) - " & APP_NAME & " - " & UserName & " - " & CSOAPI2.EmpNombre & " - [" & m_InitCSOAPI.Database.dbName & " - " & m_InitCSOAPI.Database.ServerName & "]"
    CSABMInterface2.EmpId = CSOAPI2.EmpId
    CSABMInterface2.EmpNombre = CSOAPI2.EmpNombre
#Else
    fMain.Caption = APP_NAME & " - " & UserName & " - " & CSOAPI2.EmpNombre & " - [" & m_InitCSOAPI.Database.dbName & " - " & m_InitCSOAPI.Database.ServerName & "]"
    CSABMInterface2.EmpId = CSOAPI2.EmpId
    CSABMInterface2.EmpNombre = CSOAPI2.EmpNombre
    fMain.SetLenguage
#End If
    InitDlls = True
  End If
End Function

' funciones privadas
#If Not PREPROC_SMALL Then
Private Sub splash()
  Do While fSplash.Timer1.Enabled
    DoEvents
  Loop
End Sub
#End If

Private Function InitDllsAux(ByVal ConnetString As String, ByVal UserName As String, _
                             ByVal bd_id As Long, ByVal emp_id As Long) As Boolean
  '--------------------------------
  ' CSOAPI
  Set m_InitCSOAPI = New CSOAPI2.cInitCSOAPI
  m_InitCSOAPI.AppName = APP_NAME
  CSOAPI2.EmpId = emp_id
  CSOAPI2.BdId = bd_id
  
#If Not PREPROC_SFS2 And Not PREPROC_SMALL Then
  fMain.ShowInitProgressDialog
  fMain.ShowInitProgress "Init [CSOAPI] ...", 0, 1
#End If
  
#If Not PREPROC_SMALL2 Then
  If Not m_InitCSOAPI.Init(ConnetString, UserName, m_Client, m_ClientProcessId) Then Exit Function
#Else
  If Not m_InitCSOAPI.Init(ConnetString, UserName, Nothing, m_ClientProcessId) Then Exit Function
#End If
  m_InitCSOAPI.ValidateVersion GetExeVersion
'  CSOAPI2.ValidateDate
  
#If Not PREPROC_SFS2 And Not PREPROC_SMALL And Not PREPROC_NO_EXBAR Then
  Set m_InitCSOAPIAvisos = New CSOAPIAvisos.cInitCSOAPIAvisos
  m_InitCSOAPIAvisos.AppName = APP_NAME
  If Not m_InitCSOAPIAvisos.Init(m_InitCSOAPI.Database, m_Client, m_ClientProcessId) Then Exit Function
#End If

#If Not PREPROC_SFS2 And Not PREPROC_SMALL Then
  fMain.ShowInitProgress "Init [CSOAPI] Success", 0, 1
#End If

  pInitExplorerBar
  
  ' Inicializo el objeto usuario de csoapi lamentablemente hay que hacerlo aca.
  If Not User.GetUser(m_InitCSOAPI.Database.UserId) Then
    CloseApp
    Exit Function
  End If
  
  CSOAPI2.SecurityShowMessages = True
  
  '--------------------------------
  ' CSModulo
'  Starting = True
  Set m_InitCSModulo = New CSModulo2.cInitCSModulo
  If Not m_InitCSModulo.Init(m_InitCSOAPI.Database, fMain, fMain) Then
'    Starting = False
    Exit Function
  End If
'  Starting = False
  
#If Not PREPROC_SFS2 And Not PREPROC_SMALL Then
  fMain.HideInitProgressDialog
#End If
  
  fMain.ShowMenu
  fMain.CreateReBar
  
  '--------------------------------
  ' CSPrintManager
  Set m_InitCSPrintMng = New CSPrintManager2.cInitCSPrintMng
  If Not m_InitCSPrintMng.Init(m_InitCSOAPI.Database) Then Exit Function
  
  '--------------------------------
  ' CSABMInterface
  Dim ObjAbm As Object
  Set ObjAbm = CSKernelClient2.CreateObject("CSABMInterface2.cABMInterfaceMain")

  Dim Color As Long
  Color = pGetColorBackground()

  ObjAbm.AppPath = App.Path
  ObjAbm.BackgroundColor = Color
  
  If Color Then
    fMain.BackColor = Color
    fMain.picBar.BackColor = Color
  End If
  
  Set ObjAbm = Nothing
  
  InitDllsAux = True
End Function

Private Function pGetColorBackground() As Long
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim Filter  As String
  Dim db      As cDataBase
  Dim Color   As Long
  
  Set db = OAPI.Database
  
  Filter = "cfg_grupo = 'Usuario-Config'" & _
                    " and cfg_aspecto = 'Color Empresa Gral_" & User.Id & "'" & _
                    " and emp_id = " & EmpId
  
  sqlstmt = "select cfg_valor from configuracion where " & Filter
  
  If Not db.OpenRs(sqlstmt, rs) Then Exit Function
  If Not rs.EOF Then
  
    Color = Val(db.ValField(rs.Fields, 0))
  End If
  
  If Color = 0 Then
    
    Filter = "cfg_grupo = 'General'" & _
                    " and cfg_aspecto = 'Color Empresa'" & _
                    " and emp_id = " & EmpId
    
    sqlstmt = "select cfg_valor from configuracion where " & Filter
    
    If Not db.OpenRs(sqlstmt, rs) Then Exit Function
    If Not rs.EOF Then
    
      Color = Val(db.ValField(rs.Fields, 0))
    End If
    
  End If
  
  pGetColorBackground = Color

End Function

Private Sub CloseDlls()
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
#If Not PREPROC_SFS2 And Not PREPROC_SMALL And Not PREPROC_NO_EXBAR Then
  CSOAPIAvisos.AvisoTerminate
#End If

  m_InitCSOAPI.Terminate
  Set m_InitCSOAPI = Nothing

  m_InitCSModulo.Terminate
  Set m_InitCSModulo = Nothing
  
  Set m_InitCSPrintMng = Nothing
  
  CSReportTPaint.CloseDll
End Sub

Private Sub pInitExplorerBar()
#If Not PREPROC_SFS2 And Not PREPROC_SMALL And Not PREPROC_NO_EXBAR Then
  CSOAPIAvisos.AvisoInit fMain.exbrMain, fMain.ilsIcons, fMain.ilsTitleIcons
  CSOAPIAvisos.AvisoClearBars
  Dim Aviso As CSOAPIAvisos.cAviso
  Set Aviso = New CSOAPIAvisos.cAviso
  Aviso.Refresh
#End If
End Sub

' Responde si el login proviene de la linea de comandos
Private Function pLoginFromCommandLine() As Boolean
  If Command$ = "" Then Exit Function
  pLoginFromCommandLine = Val(GetToken(c_login, Command$))
End Function
Private Function pGetCommandLine(ByVal Token As String)
  pGetCommandLine = GetToken(Token, Command$)
End Function
Private Function pLoaginToEmpresa() As Boolean
  If Command$ = "" Then Exit Function
  pLoaginToEmpresa = LenB(GetToken(c_login_emp_emp, Command$))
End Function
' construccion - destruccion
Public Sub Main()
  On Error GoTo ControlError

  InitCommonControls
  
#If Not PREPROC_SMALL Then
  ' splash
  fSplash.Show vbModeless
  splash
#End If
  
  '--------------------------------
  ' Antes que nada hay que decirle al
  ' Kernel cual es la aplicacion CSKernelClient
  CSKernelClient2.AppName = APP_NAME
  CSKernelClient2.Title = APP_NAME
  
  ' Esto tiene que estar aca para que
  ' se defina el valor de m_bLoginToEmpresa
  ' antes de crear el menu
  '
  m_bLoginToEmpresa = pLoaginToEmpresa()
  
  Load fMain
  
#If Not PREPROC_SMALL Then
  Set fMain.Icon = fSplash.Icon
#End If
  
  fMain.Show


#If Not PREPROC_SMALL Then
  AlwaysOnTop fSplash, False
#End If
  
  If ConnectToCompany Then
  
    CSKernelClient2.EmailErrDescrip = fMain.Caption
  
#If Not PREPROC_SFS2 And Not PREPROC_SMALL Then

    Load fDesktop
    fDesktop.Show
    
#End If

    CreateSendKey
  
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "Main", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next

#If Not PREPROC_SMALL Then
  ' Descargo el splash
  Unload fSplash
#End If
End Sub

Public Function GetExeVersion() As String
  GetExeVersion = App.Major & "." & Format(App.Minor, "00") & "." & Format(App.Revision, "00")
End Function

Private Sub pSetEmail(ByVal ConnectString As String)
  On Error GoTo ControlError
  
  Const c_GrupoGeneral = "General"
  Const c_EmailServer = "Email Server"
  Const c_EmailPort = "Email Port"
  Const c_EmailUser = "Email User"
  Const c_EmailPwd = "Email Pwd"
  Const c_EmailAddress = "Email Address"
  
  Dim sqlstmt As String
  Dim db      As cDataBase
  Dim rs      As ADODB.Recordset

  Set db = New cDataBase
  If Not db.InitDB(, , , , ConnectString) Then Exit Sub
  
  sqlstmt = "select * from configuracion where cfg_grupo = " & db.sqlString(c_GrupoGeneral)
  If Not db.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Sub
  
  Dim EmailServer          As String
  Dim EmailPort            As Long
  Dim EmailUser            As String
  Dim EmailPwd             As String
  Dim EmailAddress         As String

  EmailServer = ""
  EmailPort = 25
  EmailUser = ""
  EmailPwd = ""
  EmailAddress = ""

  While Not rs.EOF
    Select Case db.ValField(rs.Fields, cscCfgAspecto)
      Case c_EmailServer
        EmailServer = db.ValField(rs.Fields, cscCfgValor)
      Case c_EmailPort
        EmailPort = Val(db.ValField(rs.Fields, cscCfgValor))
      Case c_EmailUser
        EmailUser = db.ValField(rs.Fields, cscCfgValor)
      Case c_EmailPwd
        EmailPwd = db.ValField(rs.Fields, cscCfgValor)
      Case c_EmailAddress
        EmailAddress = db.ValField(rs.Fields, cscCfgValor)
    End Select
    
    rs.MoveNext
  Wend
  
  CSKernelClient2.EmailAddress = EmailAddress
  CSKernelClient2.EmailPort = EmailPort
  CSKernelClient2.EmailPwd = EmailPwd
  CSKernelClient2.EmailServer = EmailServer
  CSKernelClient2.EmailUser = EmailUser
  
  CSKernelClient2.EmailErrDescrip = fMain.Caption
  
  GoTo ExitProc
ControlError:
  MngError Err, "pSetEmail", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' Auxiliares
'Public Sub UnloadApp()
'  If Not InIDE() Then
'    SetErrorMode SEM_NOGPFAULTERRORBOX
'  End If
'End Sub
'
'Public Property Get InIDE() As Boolean
'  Debug.Assert (IsInIDE())
'  InIDE = m_bInIDE
'End Property
'
'Private Function IsInIDE() As Boolean
'  m_bInIDE = True
'  IsInIDE = m_bInIDE
'End Function
'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

