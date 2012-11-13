VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cUsuario"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cUsuario
' 13-01-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cUsuario"
' estructuras
' variables privadas
Private m_Id            As Long
Private m_Name          As String
Private m_Clave         As String
Private m_Active        As Boolean
Private m_suc_id        As Long
Private m_Sucursal      As String
Private m_LastUpdate    As Date
Private m_Created       As Date
Private m_Modify        As Long

Private m_DB            As cDataBase

' Properties publicas
Public Property Get Id() As Long
    Id = m_Id
End Property
Public Property Let Id(ByVal rhs As Long)
    m_Id = rhs
End Property
Public Property Get Name() As String
    Name = m_Name
End Property
Public Property Let Name(ByVal rhs As String)
    m_Name = rhs
End Property
Public Property Get Password() As String
    Password = m_Clave
End Property
Public Property Let Password(ByVal rhs As String)
    m_Clave = rhs
End Property
Public Property Get Active() As Boolean
    Active = m_Active
End Property
Public Property Let Active(ByVal rhs As Boolean)
    m_Active = rhs
End Property
Public Property Get LastUpdate() As Date
    LastUpdate = m_LastUpdate
End Property
Public Property Get Modify() As Long
    Modify = m_Modify
End Property
Public Property Get Created() As Date
    Created = m_Created
End Property
Public Property Set DB(ByRef rhs As cDataBase)
  Set m_DB = rhs
End Property
Public Property Get Nombre() As String
  Nombre = m_Name
End Property
Public Property Get Codigo() As String
  Codigo = m_Name
End Property
Public Property Get suc_id() As Long
  suc_id = m_suc_id
End Property
Public Property Get Sucursal() As String
  Sucursal = m_Sucursal
End Property

' Preferencias del usuario
Public Property Get AutoSizeCols() As Boolean
  AutoSizeCols = gAutoSizeCols
End Property

Public Property Let AutoSizeCols(ByVal rhs As Boolean)
  gAutoSizeCols = rhs
End Property

' Properties privadas
' funciones publicas
Public Function ChangePassword(ByVal NewPassword As String) As Boolean
  Dim register As cRegister
  Dim LastId   As Long
  
  Set register = New cRegister
  
  register.FieldId = cscUsId
  register.Table = csTusuario
  
  register.Id = m_Id
  register.Fields.Add2 cscUsClave, pEncrypt(UCase(NewPassword)), csText
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
                                                          'Error al grabar el usuario
  If Not gDB.Save(register, , "ChangePassword", C_Module, LNGGetText(2813, vbNullString)) Then Exit Function

  m_Clave = NewPassword

  ChangePassword = Load(register.Id)
  
  Exit Function
SaveError:
  m_Id = LastId
End Function

Public Function GetUser(ByVal Id As Long, Optional ByVal Name As String = vbNullString) As Boolean
  Dim rs As ADODB.Recordset
  Dim sqlstmt As String

  If Not ValEmpty(Name, csText) Then
    sqlstmt = "select us_id, u.suc_id, suc_nombre" & _
              " from usuario u left join sucursal s on u.suc_id = s.suc_id" & _
                " where us_nombre = " & m_DB.sqlString(Name)
                                                                'Error al cargar el Usuario
    If Not m_DB.OpenRs(sqlstmt, rs, , , , "GetUser", C_Module, LNGGetText(3458, vbNullString), csErrorInformation) Then Exit Function
    
    If Not rs.EOF Then
      Id = gDB.ValField(rs.Fields, cscUsId)
      m_suc_id = gDB.ValField(rs.Fields, cscSucId)
      m_Sucursal = gDB.ValField(rs.Fields, cscSucNombre)
    End If
  End If

  GetUser = Load(Id)
End Function

Public Function ShowUsers(ByRef fListUsers As Object) As Boolean
    If Not gSecurity.CanAccess(csPreOListUser) Then Exit Function
    With fListUsers
        .NameEdit = LNGGetText(1130, vbNullString) 'Usuarios
        .Buttons1 = BUTTON_DELETE + BUTTON_SEARCH + BUTTON_EDIT + BUTTON_PRINTOBJ + BUTTON_NEW + BUTTON_EXIT
        .IconText = .IconPersona
        .Table = csUsuario
        .csTree1.ToolBarVisible = True
    End With
    CSKernelClient2.ShowFormWithInit fListUsers, LNGGetText(1130, vbNullString) 'Usuarios
End Function

' funciones privadas
Private Function Load(ByVal Id As Long) As Boolean
  Dim sqlstmt As String
  Dim Encrypt As cEncrypt
  Set Encrypt = New cEncrypt
    
  sqlstmt = "sp_UsuarioGet " & Id
  
  Dim rs As ADODB.Recordset
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", C_Module) Then Exit Function
  
  If rs.EOF Then
    m_Active = True
    m_Name = vbNullString
    m_Id = csNO_ID
    m_Clave = vbNullString
    m_suc_id = csNO_ID
    m_Sucursal = vbNullString
    m_Created = Date
  Else
    m_Active = gDB.ValField(rs.Fields, cscActivo)
    m_Name = gDB.ValField(rs.Fields, cscUsNombre)
    m_Id = gDB.ValField(rs.Fields, cscUsId)
    m_Clave = Encrypt.Decript(gDB.ValField(rs.Fields, cscUsClave), c_LoginSignature)
    m_suc_id = gDB.ValField(rs.Fields, cscSucId)
    m_Sucursal = gDB.ValField(rs.Fields, cscSucNombre)
    m_Created = gDB.ValField(rs.Fields, cscCreado)
  End If
  Load = True
End Function

Private Function pEncrypt(ByVal Value As String) As String
  Dim Encrypt As cEncrypt
  Set Encrypt = New cEncrypt
  
  pEncrypt = Encrypt.Encript(LCase(Value), c_LoginSignature)
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  Set m_DB = gDB
End Sub

Private Sub Class_Terminate()
  Set m_DB = Nothing
End Sub
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
