VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPermisos"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements cICheckedList
'--------------------------------------------------------------------------------
' cPermisos
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
Private Const C_Module = "cPermisos"
' estructuras
' Seudo - Variables
Private c_ErrorSave     As String

' variables privadas
Private m_Coll          As Collection
Private m_IsLoaded      As Boolean

Private m_WhoOwnsThis   As csPermissionType
Private m_IdClient      As Long
' Properties publicas
Public Property Get IsLoaded() As Boolean
  IsLoaded = m_IsLoaded
End Property
Public Property Let IsLoaded(ByVal rhs As Boolean)
  m_IsLoaded = rhs
End Property

Private Property Get cICheckedList_HaveToShowTag() As Boolean
  cICheckedList_HaveToShowTag = True
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

Public Function Item(ByVal kItem As Variant) As cPermiso
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

Public Function Load(Optional ByVal UsId As Long, _
                     Optional ByVal RolId As Long, _
                     Optional ByVal Short As Boolean = True) As Boolean
                     
  Dim sqlstmt    As String
  Dim rsPermisos As ADODB.Recordset
  Dim Permiso    As cPermiso
  
  Dim c_strLoad  As String
  
  c_strLoad = LNGGetText(2763, vbNullString)  'Error al cargar los Permisos
  
  If Not m_IsLoaded Then
    Clear
  
    sqlstmt = "select * from Permiso"
    
    ' pido los permisos Shorts por defecto para un User o un rol
    If UsId <> csNO_ID Then
      m_IdClient = UsId
      m_WhoOwnsThis = csTPUser
      sqlstmt = "SP_SecGetPermisosXUsuario " & UsId & "," & CInt(Short)
    ElseIf RolId <> csNO_ID Then
      m_IdClient = RolId
      m_WhoOwnsThis = csTPRol
      sqlstmt = "SP_SecGetPermisosXRol " & RolId & "," & CInt(Short)
    End If
    
    If Not gDB.OpenRs(sqlstmt, rsPermisos, , , , C_LoadFunction, C_Module, c_strLoad) Then Exit Function
                
    While Not rsPermisos.EOF
    
      Set Permiso = Add(Permiso, rsPermisos(cscPerId).Value)
      Permiso.Id = rsPermisos(cscPerId).Value
      Permiso.PreId = gDB.ValField(rsPermisos.Fields, cscPreID)
      
      If Not Short Then
        
        If m_WhoOwnsThis = csTPUser Then
          Permiso.Modify = gDB.ValField(rsPermisos.Fields, cscModifico)
          Permiso.Created = gDB.ValField(rsPermisos.Fields, cscCreado)
          Permiso.UsId = gDB.ValField(rsPermisos.Fields, cscUsId)
        End If
        
        Permiso.RolId = gDB.ValField(rsPermisos.Fields, cscRolId)

        If m_WhoOwnsThis = csTPUser Then
          Permiso.Enabled = Permiso.UsId <> csNO_ID
          Permiso.Tag = gDB.ValField(rsPermisos.Fields, cscRolNombre)
        Else
          Permiso.Enabled = True
        End If
        
        If Permiso.Enabled Then
          Permiso.Enabled = gDB.ValField(rsPermisos.Fields, cscPerIdPadre) = csNO_ID
          Permiso.Tag = gDB.ValField(rsPermisos.Fields, "padre")
        End If
      Else
        If m_WhoOwnsThis = csTPRol Then
          Permiso.RolId = RolId
          Permiso.Enabled = True
        End If
      End If
      
      ' Los permisos que cargo de la base de datos obviamente estan concedidos
      Permiso.Granted = True
      
      Set Permiso = Nothing
      
      rsPermisos.MoveNext
    Wend
  End If
  m_IsLoaded = True
  Load = True
End Function

' bIsForUser me permite saber que no tengo
' que modificar ningun permisos que no este
' asignado a un usuario.
'
Public Function Save(Optional ByVal Client As cTCPIPClient, _
                     Optional ByVal ClientProcessId As Long, _
                     Optional ByVal bIsForUser As Boolean) As Boolean
  
  Dim p               As cPermiso
  Dim sDelete         As String
  Dim register        As cRegister
  Dim Asked           As Boolean
  Dim Can             As Boolean
  Dim AskDpto         As Boolean
  Dim ApplySubDpto    As Boolean
  Dim sqlstmt         As String

  Dim bChanged    As Boolean
  Dim us_id       As Long
  Dim rol_id      As Long
  
  Dim c_msg       As String
  
  c_msg = LNGGetText(2759, vbNullString)
          'El permiso %1 pertenece a un Departamento.;;¿Desea aplicar este permiso a los Departamentos que dependan de este?
  
  For Each p In m_Coll
  
    If (bIsForUser And p.UsId <> csNO_ID) Or ((Not bIsForUser) And p.RolId <> csNO_ID) Then
    
      ' Borro todos los que no estan habilitados
      If (Not p.Granted) And p.Id <> csNO_ID Then
        sDelete = sDelete & p.Id & ","
      
        If Not bChanged Then
        
          bChanged = True
          us_id = p.UsId
          rol_id = p.RolId
        
        End If
      
      ' Inserto todos los que son nuevos
      ElseIf p.Granted And p.Id = csNO_ID Then
        
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
          
          register.fieldId = cscPerId
          register.Table = csTPermiso
          register.Id = p.Id
          register.Fields.Add2 cscPreID, p.PreId, csId
          register.Fields.Add2 cscRolId, p.RolId, csId
          register.Fields.Add2 cscUsId, p.UsId, csId
        
          register.Fields.HaveLastUpdate = True
          register.Fields.HaveWhoModify = True
          
          If Not gDB.Save(register, , "Save", C_Module, c_ErrorSave) Then Exit Function
          
          p.Id = register.Id
          
          ' Si la prestacion le pertenece a un departamento
          '
          If p.PreId > 15000000 And p.PreId < 15010000 Then
            
            
            ' Si aun no pregunte al usuario
            '
            If Not AskDpto Then
              ApplySubDpto = Ask(Replace(c_msg, "%1", pGetPreNombre(p.PreId)), vbNo)
            End If
            
            If ApplySubDpto Then
              pApllySubDpto p.Id
            End If
          End If
          
          If Not bChanged Then
          
            bChanged = True
            us_id = p.UsId
            rol_id = p.RolId
          
          End If
          
        End If
      End If
    End If
  Next
  
  If Not ValEmpty(sDelete, csText) Then
  
    ' Administrador
    If CSOAPI2.User.Id = 1 Then
      Can = True
    Else
      Can = CSOAPI2.SecurityCanAccess(csPreOBorrarPermiso)
    End If
    
    If Can Then
      sDelete = RemoveLastColon(sDelete)
      Dim vPerId() As String
      Dim i        As Long
      
      vPerId = Split(sDelete, ",")
      For i = 0 To UBound(vPerId)
        sqlstmt = "sp_permisoDelete " & vPerId(i)
        If Not gDB.Execute(sqlstmt, "Save", C_Module) Then Exit Function
      Next
    End If
  End If
  
  If bChanged Then
  
    If bIsForUser Then
      sqlstmt = "sp_SysModuloGetEx " & us_id
    Else
      sqlstmt = "sp_SysModuloRolGetEx " & rol_id
    End If
    If Not gDB.Execute(sqlstmt, "Save", C_Module) Then Exit Function
  End If
  
  pNotifySecurity Client, ClientProcessId
  
  Save = True
End Function

' funciones privadas
Private Function pGetPreNombre(ByVal PRE_ID As Long) As String
  Dim rtn As String
  If Not gDB.GetData(csTPrestacion, cscPreID, PRE_ID, cscPreNombre, rtn) Then Exit Function
  pGetPreNombre = rtn
End Function

Private Sub pApllySubDpto(ByVal per_id As Long)
  Dim sqlstmt As String
  sqlstmt = "sp_DepartamentoApplySecSubDpto " & per_id
  gDB.Execute sqlstmt
End Sub

Private Sub pNotifySecurity(ByRef Client As cTCPIPClient, ByVal ClientProcessId As Long)
  Dim Buffer As String
  
  ' Si no hay conexion me voy
  If Client Is Nothing Then Exit Sub
  
  ' Tengo que tener al menos un permiso
  If m_Coll.Count = 0 Then Exit Sub
  
  Dim RolId As Long
  Dim UsId  As Long
  
  If m_WhoOwnsThis = csTPUser Then
    UsId = m_IdClient
  Else
    RolId = m_IdClient
  End If
  
  Buffer = c_SecRol & Format(RolId, "00000000") & ":" & c_SecUser & Format(UsId, "00000000")
  Buffer = TCPSecurityGetMessage(cTCPSecCommandRefresh, ClientProcessId, Buffer)
  Client.SendText Buffer, SRV_ID_SERVER
End Sub

Private Function Add(ByVal c As cPermiso, Optional Key As Variant) As cPermiso
  On Error GoTo ControlError

  If c Is Nothing Then Set c = New cPermiso

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
  Dim c As cPermiso
  Set c = Add(c)
  If m_WhoOwnsThis = csTPRol Then
    c.RolId = m_IdClient
    c.UsId = csNO_ID
  Else
    c.UsId = m_IdClient
    c.RolId = csNO_ID
  End If
  c.PreId = Key
  c.Id = csNO_ID
  c.Granted = True
  Set cICheckedList_Add = c
End Function

Private Sub cICheckedList_Clear()
  Err.Raise csErrorUsoSubClearEnPermissions, "CSOAPI", LNGGetText(2761, vbNullString)
                                                      'El uso del método cICheckedList_Clear en la clase cPermisos no está permitido
End Sub

Private Function cICheckedList_Count() As Long
  cICheckedList_Count = m_Coll.Count
End Function

Private Function cICheckedList_Item(ByVal kItem As Variant) As CSInterfacesChkList.cICheckedListItem
  cICheckedList_Item = Item(kItem)
End Function

Private Function cICheckedList_NewEnum() As stdole.IUnknown
  Set cICheckedList_NewEnum = m_Coll.[_NewEnum]
End Function

Private Sub cICheckedList_Remove(ByVal kItem As Variant)
  Err.Raise csErrorUsoSubRemoveEnPermissions, "CSOAPI", LNGGetText(2760, vbNullString)
                                                      'El uso del metodo cICheckedList_Remove en la clase cPermisos no esta permitido
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_Coll = New Collection
  
  c_ErrorSave = LNGGetText(2762, vbNullString)  'Error al grabar Permisos
  
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
