VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cInitCSOAPI"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cInitCSOAPI
' 10-06-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cInitCSOAPI"
' estructuras
' variables privadas
' Properties publicas
Public Property Let AppName(ByVal rhs As String)
  gAppName = rhs
End Property
Public Property Get DataBase() As cDataBase
  Set DataBase = gDB
End Property
' Properties privadas
' funciones publicas
Public Function Init(ByVal ConnectString As String, ByVal User As String, ByVal Client As cTCPIPClient, ByVal ClientProcessId As Long) As Boolean
  Set gDB = New cDataBase
  Set gUser = New cUsuario
  Set gSecurity = New cSecurity_
  
  Set gTCPClient = Client
  gClientProcessId = ClientProcessId
  
  Dim dbName  As String
  Dim dbServer  As String
  Dim dbUser  As String
  Dim dbPwd   As String
  
  dbName = GetToken("Initial Catalog", ConnectString)
  dbServer = GetToken("Data Source", ConnectString)
  dbUser = GetToken("User ID", ConnectString)
  dbPwd = GetToken("Password", ConnectString)
  
  ' Para soportar login desde la pagina web
  If LCase$(Left$(ConnectString, 10)) <> "file name=" Then ConnectString = ""
  
  ' Abro la base
  If Not gDB.InitDB(dbName, dbServer, dbUser, dbPwd, ConnectString) Then Exit Function
  
  pSetBdVersion
  
  ' Obtengo El usuario
  If Not gUser.GetUser(csNO_ID, User) Then Exit Function
  
  gDB.UserId = gUser.Id
  
  ' Inicializo el manejador de seguridad
  If Not gSecurity.Init() Then Exit Function
  
  Dim Prestaciones As cCSOAPIPrestaciones
  
  Set Prestaciones = New cCSOAPIPrestaciones
  
  Prestaciones.Init
  
  pSetUserPreferences
  
  Init = True
End Function

Public Function ValidateVersion(ByVal ExeVersion As String) As Boolean
  Dim msg As String
  
  If Left$(ExeVersion, 8) <> Left$(gBdVersion, 8) Then
    msg = LNGGetText(3444, vbNullString, gBdVersion, ExeVersion)
          'La versión de la base de datos ( & gBdVersion & ) es distinta a la versión del sistema ( & ExeVersion & ). _
            Comuníquese con el departamento de sistemas o con Atención al Cliente de CrowSoft.
    MsgWarning msg
    Exit Function
  End If
  ValidateVersion = True
End Function

Public Sub Terminate()
  Set gDB = Nothing
  Set gUser = Nothing
  Set gTCPClient = Nothing
End Sub

' funciones privadas
Private Sub pSetBdVersion()
  On Error GoTo ControlError
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_cfg_getvalor 'Base Datos','Version',0,1"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub

  gBdVersion = gDB.ValField(rs.Fields, 0)
  
  gDB.GetData "Empresa", "emp_id", gEmpId, "emp_nombre", gEmpNombre

  GoTo ExitProc
ControlError:
  MngError Err, "pSetBdVersion", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pSetUserPreferences()
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select cfg_valor from Configuracion" & _
            " where cfg_grupo = 'Usuario-Config'" & _
                    " and cfg_aspecto = 'Autoajustar Columnas Gral_" & gUser.Id & "'" & _
                    " and emp_id = " & gEmpId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  If Val(rs.Fields.Item(0).Value) Then
    gAutoSizeCols = True
  End If
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  Terminate
End Sub
