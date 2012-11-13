VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPermisoManager"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cPermisoManager
' 27-01-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cPermisoManager"
' estructuras
' variables privadas
Private m_Id        As Long

Private m_Permisos   As cPermisos
Private m_UsuarioRoles As cUsuarioRoles
' eventos
' Properties publicas
Public Property Get Permisos() As cPermisos
  Set Permisos = m_Permisos
End Property
Public Property Set Permisos(ByVal rhs As cPermisos)
  Set m_Permisos = rhs
End Property
Public Property Get UsuarioRol() As cUsuarioRoles
  Set UsuarioRol = m_UsuarioRoles
End Property
Public Property Set UsuarioRol(ByVal rhs As cUsuarioRoles)
  Set m_UsuarioRoles = rhs
End Property
' Properties privadas
' funciones publicas
Public Function Load(ByVal Id As Long, ByVal QueEs As csPermissionType) As Boolean
  m_Id = Id
  m_Permisos.IsLoaded = False
  m_UsuarioRoles.IsLoaded = False
  If QueEs = csTPRol Then
      If Not m_UsuarioRoles.Load(, Id) Then Exit Function
      Load = m_Permisos.Load(, Id, False)
  Else
      If Not m_UsuarioRoles.Load(Id) Then Exit Function
      Load = m_Permisos.Load(Id, , False)
  End If
End Function

Public Sub SetBranchChecked(ByRef collBranchs As Collection, _
                            ByVal us_id As Long, _
                            ByVal rol_id As Long, _
                            ByVal arb_id As Long, _
                            ByVal bPermisos As Boolean)
  Dim rs      As ADODB.Recordset
  Dim sqlstmt As String
  Dim Id      As Long
  
  CollClear collBranchs
  
  If bPermisos Then
    sqlstmt = "sp_ArbPermisoGetRamas " & us_id & "," _
                                       & rol_id & "," _
                                       & arb_id
  Else
    sqlstmt = "sp_ArbUsuarioRolGetRamas " & us_id & "," _
                                          & rol_id & "," _
                                          & arb_id
  End If
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  While Not rs.EOF
    Id = rs.Fields.Item(0)
    collBranchs.Add Id, GetKey(Id)
    rs.MoveNext
  Wend
End Sub

Public Sub CreateTree()
  On Error GoTo ControlError
  
  Dim sqlstmt As String
  sqlstmt = "sp_ArbPermisosCrear"
  
  gDB.CommandTimeout = 600
  gDB.Execute sqlstmt
  
  GoTo ExitProc
ControlError:
  MngError Err, "CreateTree", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub
' funciones privadas
' construccion - destruccion

Private Sub Class_Initialize()
  Set m_Permisos = New cPermisos
  Set m_UsuarioRoles = New cUsuarioRoles
End Sub

Private Sub Class_Terminate()
  Set m_Permisos = Nothing
  Set m_UsuarioRoles = Nothing
End Sub
