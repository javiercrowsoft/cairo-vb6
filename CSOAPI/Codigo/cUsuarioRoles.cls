VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cUsuarioRoles"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements cICheckedList
'--------------------------------------------------------------------------------
' cUsuarioRoles
' 11-07-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cUsuarioRoles"

' pseudo-constantes
Private c_ErrorSave     As String

' estructuras
' variables privadas
Private m_Coll          As Collection
Private m_IsLoaded      As Boolean

Private m_WhoOwnsThis As csPermissionType

Private m_IdClient As Long
' Properties publicas
Public Property Get IsLoaded() As Boolean
  IsLoaded = m_IsLoaded
End Property
Public Property Let IsLoaded(ByVal rhs As Boolean)
  m_IsLoaded = rhs
End Property
' Properties privadas
' funciones publicas
Public Sub Clear()
  CollClear m_Coll
  m_IsLoaded = False
End Sub

' el remove de esta colección es especial ya que tiene que borrar todos los hijos del nodo dentro de la coleccion
Public Sub Remove(ByVal kItem As Variant)
  On Error GoTo ControlError
      
  If IsNumeric(kItem) Then kItem = GetKey(kItem)
 
  m_Coll.Remove kItem
  Exit Sub
ControlError:
End Sub
Public Function Count() As Long
  On Error GoTo ControlError
  Count = m_Coll.Count
  Exit Function
ControlError:
  Count = 0
End Function

Public Function Item(ByVal kItem As Variant) As cUsuarioRol
Attribute Item.VB_UserMemId = 0
  On Error GoTo ControlError
  If VarType(kItem) = vbInteger Then
      ' Nada que hacer, me ha pasado un indice
  ElseIf IsNumeric(kItem) Then
      kItem = GetKey(kItem)
  End If
  Set Item = m_Coll(kItem)
  Exit Function
ControlError:
End Function

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
  Set NewEnum = m_Coll.[_NewEnum]
End Function

Public Function Load(Optional ByVal UsId As Long, Optional ByVal RolId As Long) As Boolean
  Dim sqlstmt      As String
  Dim rsUsuarioRol    As ADODB.Recordset
  Dim UsuarioRol      As cUsuarioRol
  Dim c_strLoad       As String
  
  c_strLoad = LNGGetText(2818, vbNullString)  'Error al cargar los Roles
  If Not m_IsLoaded Then
      Clear
  
      If UsId <> csNO_ID Then
          m_IdClient = UsId
          m_WhoOwnsThis = csTPUser
      
          sqlstmt = "select * from usuarioRol where us_id = " & UsId
      
      ElseIf RolId <> csNO_ID Then
          m_IdClient = RolId
          m_WhoOwnsThis = csTPRol
          
          sqlstmt = "select * from usuarioRol where rol_id = " & RolId
      End If
      
      If sqlstmt = "" Then Exit Function
      
      If Not gDB.OpenRs(sqlstmt, rsUsuarioRol, , , , C_LoadFunction, C_Module, c_strLoad) Then Exit Function
                              
      While Not rsUsuarioRol.EOF
      
          If UsId <> csNO_ID Then
              Set UsuarioRol = Add(UsuarioRol, rsUsuarioRol(cscRolId).Value)
          Else
              Set UsuarioRol = Add(UsuarioRol, rsUsuarioRol(cscUsId).Value)
          End If
          UsuarioRol.RolId = rsUsuarioRol(cscRolId).Value
          UsuarioRol.UsId = rsUsuarioRol(cscUsId).Value
          UsuarioRol.Granted = True
          UsuarioRol.WhoOwnsThis = m_WhoOwnsThis
          Set UsuarioRol = Nothing
          
          rsUsuarioRol.MoveNext
      Wend
  End If
  m_IsLoaded = True
  Load = True
End Function

Public Function Save() As Boolean
  Dim p         As cUsuarioRol
  Dim sDelete   As String
  Dim register  As cRegister
  Dim Asked     As Boolean
  Dim Can       As Boolean
 
  For Each p In m_Coll
      ' Borro todos los que no estan habilitados
      
      If m_WhoOwnsThis = csTPUser Then
          If (Not p.Granted) And p.RolId <> csNO_ID Then
              sDelete = sDelete & p.RolId & ","
          ' Inserto todos los que son nuevos
          ElseIf p.Granted And p.UsId = csNO_ID Then
              If Not Asked Then
                
                ' Administrador
                If CSOAPI2.User.Id = 1 Then
                  Can = True
                Else
                  Can = CSOAPI2.SecurityCanAccess(csPreOAltaPermiso)
                End If
                  Asked = True
              End If
              
              If Can Then
                  Set register = New cRegister
                  
                  register.fieldId = cscRolId
                  register.Table = csTusuarioRol
                  register.UtilizaIdentity = True
                  register.Id = p.RolId
                  register.Fields.Add2 cscUsId, m_IdClient, csId
                  register.Fields.Add2 cscRolId, p.RolId, csId
                  
                  register.Fields.HaveLastUpdate = True
                  register.Fields.HaveWhoModify = True
                  
                  If Not gDB.Save(register, True, "Save", C_Module, c_ErrorSave) Then Exit Function
                  
                  p.UsId = register.Id
              End If
          End If
      
      Else
          If (Not p.Granted) And p.UsId <> csNO_ID Then
              sDelete = sDelete & p.UsId & ","
          ' Inserto todos los que son nuevos
          ElseIf p.Granted And p.RolId = csNO_ID Then
              
              If Not Asked Then
                
                ' Administrador
                If CSOAPI2.User.Id = 1 Then
                  Can = True
                Else
                  Can = CSOAPI2.SecurityCanAccess(csPreOAltaPermiso)
                End If
                Asked = True
              End If
              
              If Can Then
              
                  Set register = New cRegister
                  
                  register.fieldId = cscUsId
                  register.Table = csTusuarioRol
                  register.UtilizaIdentity = True
                  register.Id = p.UsId
                  register.Fields.Add2 cscRolId, m_IdClient, csId
                  register.Fields.Add2 cscUsId, p.UsId, csId
                  
                  register.Fields.HaveLastUpdate = True
                  register.Fields.HaveWhoModify = True
                  
                  If Not gDB.Save(register, True, "Save", C_Module, c_ErrorSave) Then Exit Function
                  
                  p.RolId = register.Id
              End If
          End If
      End If
  Next
  
  If Not ValEmpty(sDelete, csText) Then
      Dim sqlstmt As String
      
      If m_WhoOwnsThis = csTPUser Then
          
          ' Administrador
          If CSOAPI2.User.Id = 1 Then
            Can = True
          Else
            Can = CSOAPI2.SecurityCanAccess(csPreOBorrarPermiso)
          End If
          
          If Can Then
              sDelete = RemoveLastColon(sDelete)
              sqlstmt = "delete usuarioRol where rol_id in (" & sDelete & ") and " & cscUsId & "=" & m_IdClient
              If Not gDB.Execute(sqlstmt, "Save", "cUsuariosRoles") Then Exit Function
          End If
      Else
          ' Administrador
          If CSOAPI2.User.Id = 1 Then
            Can = True
          Else
            Can = CSOAPI2.SecurityCanAccess(csPreOBorrarPermiso)
          End If
          
          If CSOAPI2.SecurityCanAccess(csPreOBorrarPermiso) Then
              sDelete = RemoveLastColon(sDelete)
              sqlstmt = "delete usuarioRol where us_id " & " in (" & sDelete & ") and " & cscRolId & "=" & m_IdClient
              If Not gDB.Execute(sqlstmt, "Save", "cUsuariosRoles") Then Exit Function
          End If
      End If
  End If
  
  Save = True
End Function
' funciones privadas
Private Function Add(ByVal c As cUsuarioRol, Optional Key As Variant) As cUsuarioRol
  On Error GoTo ControlError

  If c Is Nothing Then Set c = New cUsuarioRol

  If IsMissing(Key) Then
      m_Coll.Add c
  Else
      m_Coll.Add c, GetKey(Key)
  End If

  Set Add = c
  Exit Function
ControlError:
  Set Add = Nothing
End Function

' Implementacion de interfaz
Private Function cICheckedList_Add(ByVal o As CSInterfacesChkList.cICheckedListItem, Optional Key As Variant) As CSInterfacesChkList.cICheckedListItem
  Dim c As cUsuarioRol
  Set c = Add(c)
  
  If m_WhoOwnsThis = csTPUser Then
      c.RolId = Key
      c.UsId = csNO_ID
  Else
      c.RolId = csNO_ID
      c.UsId = Key
  End If
  
  c.Granted = True
  Set cICheckedList_Add = c
End Function

Private Sub cICheckedList_Clear()
  Err.Raise csErrorUsoSubClearEnUsuarioRol, "CSOAPI", LNGGetText(2816, vbNullString)
                                                      'El uso del método cICheckedList_Clear en la clase cUsuarioRoles no está permitido
End Sub

Private Function cICheckedList_Count() As Long
  cICheckedList_Count = m_Coll.Count
End Function

Private Property Get cICheckedList_HaveToShowTag() As Boolean
  cICheckedList_HaveToShowTag = False
End Property

Private Function cICheckedList_Item(ByVal kItem As Variant) As CSInterfacesChkList.cICheckedListItem
  cICheckedList_Item = Item(kItem)
End Function

Private Function cICheckedList_NewEnum() As stdole.IUnknown
  Set cICheckedList_NewEnum = m_Coll.[_NewEnum]
End Function

Private Sub cICheckedList_Remove(ByVal kItem As Variant)
  Err.Raise csErrorUsoSubRemoveEnUsuarioRol, C_Module, LNGGetText(2815, vbNullString)
                                                      'El uso del metodo cICheckedList_Remove en la clase cUsuarioRoles no esta permitido
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_Coll = New Collection
  
  c_ErrorSave = LNGGetText(2817, vbNullString)   'Error al grabar Roles para un Usuario
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  CollClear m_Coll
  Set m_Coll = Nothing
End Sub
