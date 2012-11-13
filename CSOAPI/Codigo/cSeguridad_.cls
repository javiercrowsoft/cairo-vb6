VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSecurity_"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cSecurity_
' 12-07-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
' estructuras
' Seudo - variables
Private c_ErrorSave       As String

' variables privadas
Private m_vPrestaciones() As Long
Private m_vPermissions()  As Long
Private m_ShowMessages
' Properties publicas
Public Property Get ShowMessages() As Boolean
  ShowMessages = m_ShowMessages
End Property
Public Property Let ShowMessages(ByVal rhs As Boolean)
  m_ShowMessages = rhs
End Property
' Properties privadas
' funciones publicas
Public Function Init() As Boolean
  
  c_ErrorSave = LNGGetText(3451, vbNullString) 'Error al cargar los Permisos
  
  If Not pLoadPrestaciones() Then Exit Function
  Init = pLoadPermissions(gUser.Id)
End Function

Public Function Refresh() As Boolean
  Refresh = pLoadPermissions(gUser.Id)
End Function
' Para un usuario dado, busca en sus permisos la prestacion indicada y determina si
' tiene acceso o no. (si la encuentra accede, sino no se le niega el acceso).
Public Function CanAccess(ByVal PRE_ID As Long) As Boolean
  
  CanAccess = CanAccessSilent(PRE_ID)
  
  If Not CanAccess Then
    If m_ShowMessages Then
      MsgWarning LNGGetText(3449, vbNullString), LNGGetText(3450, vbNullString)
                'Usted no tiene permiso para acceder a esta prestación., Seguridad
    End If
  End If
End Function

Public Function CanAccessSilent(ByVal PRE_ID As Long) As Boolean
  Dim i As Integer
  
  For i = 1 To UBound(m_vPermissions)
    If m_vPermissions(i) = PRE_ID Then
      CanAccessSilent = True
      Exit For
    End If
  Next
End Function

Public Function Add2(ByVal PRE_ID As Long, ByVal Name As String, ByVal Group As String) As Boolean
  Dim Founded As Boolean
  Dim i       As Long
  
  For i = 1 To UBound(m_vPrestaciones)
    If m_vPrestaciones(i) = PRE_ID Then
      Founded = True
      Exit For
    End If
  Next
  
  If Not Founded Then
    pAddPrestacion PRE_ID, Name, Group
  End If
    
  Add2 = True
End Function

' funciones privadas
Private Function pAddPrestacion(ByVal PRE_ID As Long, ByVal Name As String, ByVal Group As String) As Boolean
    Dim register As cRegister
    Set register = New cRegister
  
    register.FieldId = cscPreID
    register.Table = csTPrestacion
    register.Id = PRE_ID
        
    register.Fields.Add2 cscPreNombre, Name, csText
    register.Fields.Add2 cscPreGrupo, Group, csText
        
    If Not gDB.Save(register, True, "Agregar", "cPrestaciones", LNGGetText(3452, vbNullString)) Then Exit Function
                                                                'Error al agregar la Prestación
    ' Ahora lo agrego a la coleccion
    ReDim Preserve m_vPrestaciones(UBound(m_vPrestaciones) + 1)
    m_vPrestaciones(UBound(m_vPrestaciones)) = PRE_ID
    
    pAddPrestacion = True
End Function

Private Function pLoadPrestaciones() As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim i       As Long
  
  sqlstmt = "select pre_id from prestacion where pre_id < 10000000" ' Solo prestaciones de objetos Activex
  
  If Not gDB.OpenRs(sqlstmt, rs, , , , "pLoadPermissions", "cSecurity_", c_ErrorSave) Then Exit Function
  
  If Not (rs.EOF And rs.BOF) Then
    rs.MoveLast
    rs.MoveFirst
    ReDim m_vPrestaciones(rs.RecordCount)
  Else
    ReDim m_vPrestaciones(0)
  End If
  
  While Not rs.EOF
    
    i = i + 1
    m_vPrestaciones(i) = gDB.ValField(rs.Fields, cscPreID)
    
    rs.MoveNext
  Wend
  
  pLoadPrestaciones = True
End Function

Private Function pLoadPermissions(ByVal UsId As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim i       As Long
  
  sqlstmt = "SP_SecGetPermisosXUsuario " & UsId & ", 1"
  
  If Not gDB.OpenRs(sqlstmt, rs, , , , "pLoadPermissions", "cSecurity_", c_ErrorSave) Then Exit Function
  
  If Not (rs.EOF And rs.BOF) Then
    rs.MoveLast
    rs.MoveFirst
    ReDim m_vPermissions(rs.RecordCount)
  Else
    ReDim m_vPermissions(0)
  End If
  
  While Not rs.EOF
    
    i = i + 1
    m_vPermissions(i) = gDB.ValField(rs.Fields, cscPreID)
  
    rs.MoveNext
  Wend
  
  pLoadPermissions = True
End Function

' construccion - destruccion

Private Sub Class_Initialize()
  ReDim m_vPermissions(0)
End Sub

Private Sub Class_Terminate()
  ReDim m_vPermissions(0)
End Sub
