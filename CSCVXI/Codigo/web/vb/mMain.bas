Attribute VB_Name = "mMain"
Option Explicit

'SECURITY_DEBUG = -1 : PREPROC_CSSERVER = -1 : PREPROC_DEBUG = -1 : PREPROC_CSCVXI = -1

'login=1;us_id=84;emp_id=1;strConnect=Provider=MSDASQL.1|Extended Properties="DRIVER=SQL Server|SERVER=192.168.1.1|UID=sa|PWD=CairoOlaen2007Olaen|APP=Visual Basic|WSID=DAIMAKU|DATABASE=cairoOlaen"
'login=1;us_id=1;emp_id=1;strConnect=Provider=MSDASQL.1|Extended Properties="DRIVER=SQL Server|SERVER=daimaku|UID=sa|PWD=14FeDyAr|APP=Visual Basic|WSID=DAIMAKU|DATABASE=cairo"

Private Const c_login = "login"
Private Const c_us_id = "us_id"
Private Const c_emp_id = "emp_id"
Private Const c_strConnect = "strconnect"
Private Const c_autoStart = "autoStart"
Private Const c_cmiLogin = "cmiLogin"
Private Const c_cmiModo = "cmiModo"
Private Const c_cmiNextPage = "nextPage"

Private Const c_pwd_olaen = "INGRTIPZ"

Public Const c_id_mercadolibre     As Long = 1 ' Comunidad MercadoLibre
Public Const c_id_ml_aplicacion    As Long = 1 ' Aplicacion Emial MercadoLibre
Public Const c_id_idioma           As Long = 1 ' Idioma Español

Public Const C_BROWSING_TIMEOUT As Long = 30

Public gDb As cDataBase
Public us_id As Long
Public emp_id As Long
Public us_nombre As String
Public emp_nombre As String
Public gMainCaption As String
Public strConnect As String

Public gCMIUser As String
Public gCMIPwd  As String

Public Enum E_MODO
  OP
  VTA
  MP
  ART
End Enum

Public Sub Main()

  AddToRegistry

  gCMIPwd = IniGet(c_k_ml_password, c_pwd_olaen)

  Dim autoStart As Boolean
  Dim cmiLogin  As String
  Dim cmiModo   As E_MODO
  Dim nextPage  As Long
  
  CSKernelClient2.AppName = App.EXEName

  InitLog
  
  If pLoginFromCommandLine() Then
  
    us_id = pGetCommandLine(c_us_id)
    emp_id = pGetCommandLine(c_emp_id)
    strConnect = Replace(pGetCommandLine(c_strConnect), "|", ";")
    autoStart = Val(pGetCommandLine(c_autoStart))
    cmiLogin = pGetCommandLine(c_cmiLogin)
    cmiModo = Val(pGetCommandLine(c_cmiModo))
    nextPage = Val(pGetCommandLine(c_cmiNextPage))

    Set gDb = New cDataBase
    If Not gDb.InitDB(, , , , strConnect) Then Exit Sub
    
    Load fMain
    
    pGetUserDescrip
    
    If autoStart Then
      gCMIUser = cmiLogin
      fMain.nick = cmiLogin
      fMain.inStarting = True
      fMain.inAutoLogiMode = True
      fMain.nextPage = nextPage
      fMain.startedByAutoLogin = True
      fMain.Show
      fMain.LoginAutomatico cmiModo
      fMain.inStarting = False
      fMain.tmService.interval = 10000
    Else
      fMain.Show
    End If
  Else
    '--lng
    MsgError "Esta aplicación debe ser iniciada por el sistema de gestión.;;Utilice la opción:;; Comunidad Internet > Navegar Pagina Comunidad Internet"
  End If
  
End Sub

Private Function pLoginFromCommandLine() As Boolean
  If Command$ = "" Then Exit Function
  pLoginFromCommandLine = Val(GetToken(c_login, Command$))
End Function

Private Function pGetCommandLine(ByVal Token As String)
  pGetCommandLine = GetToken(Token, Command$)
End Function

Private Sub pGetUserDescrip()
  If Not gDb.GetData("usuario", "us_id", us_id, "us_nombre", us_nombre) Then Exit Sub
  If Not gDb.GetData("empresa", "emp_id", emp_id, "emp_nombre", emp_nombre) Then Exit Sub
  
  gMainCaption = App.ProductName & " - " & us_nombre & " - " & emp_nombre & " - " & gDb.dbName & " - " & App.Major & "." & App.Minor & "." & App.Revision
  
  fMain.Caption = gMainCaption
  
End Sub

Public Function fileGetPath(ByVal Path As String) As String
  If Right(Path, 1) <> "\" Then Path = Path & "\"
  fileGetPath = Path
End Function

