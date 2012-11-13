VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRol"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cRol
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
Private Const C_Module = "cRol"

Private Const c_usuarios = "Usuarios"

Private Const K_NAME      As Integer = 1
Private Const K_ACTIVE    As Integer = 3
Private Const K_DESCRIP   As Integer = 4

Private Const K_USUARIOS    As Integer = 5
Private Const KI_US_ID      As Integer = 2

' estructuras
' Seudo - Variables
Private c_ErrorSave     As String

' variables privadas
Private m_Id            As Long
Private m_Name          As String
Private m_Descrip       As String
Private m_Active        As Boolean
Private m_LastUpdate    As Date
Private m_Created       As Date
Private m_Modify        As Long

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_New               As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Copy              As Boolean
Private m_IsNew             As Boolean

Private m_ItemsDeletedUsuarios       As String

Private m_Host              As CSMenu.cIMenuHost
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

' Para el nuevo desde HELP
'
Public Property Get Nombre() As String
  Nombre = m_Name
End Property
Public Property Get Codigo() As String
  Codigo = m_Name
End Property
' Properties privadas
' funciones publicas
' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean

  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscRolNombre)
    .Value = C_CopiaDe & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscRolNombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  cIEditGeneric_Edit csNO_ID
End Function

Private Property Get cIABMClient_Aplication() As String
  cIABMClient_Aplication = gAppName
End Property
Private Property Get cIABMClient_CanAddDocDigital() As Boolean
  cIABMClient_CanAddDocDigital = m_Id <> csNO_ID
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
  cIABMClient_CanCopy = True
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = True
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
  On Error GoTo ControlError
  
  If m_Id = csNO_ID Then Exit Function
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = csTRol
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Dim LastId   As Long
  
  Set register = New cRegister
  
  register.fieldId = cscRolId
  register.Table = csTRol

  If m_Copy Then
    register.Id = csNew
  Else
    register.Id = m_Id
  End If
  
  Dim IPropiedad As cIABMProperty
  For Each IPropiedad In m_ObjAbm.Properties
    With IPropiedad
      Select Case .Key
        Case K_NAME
          register.Fields.Add2 cscRolNombre, .Value, csText
        Case K_ACTIVE
          register.Fields.Add2 cscActivo, Val(.Value), csBoolean
        Case K_DESCRIP
          register.Fields.Add2 cscRolDescrip, .Value, csText
      End Select
    End With
  Next
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", "cRol", c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.Id
  
  If Not pSaveItemsRoles() Then GoTo SaveError
  If Not pUpdatePermisos() Then GoTo SaveError
  
  If Not register.CommitTrans() Then GoTo SaveError
  
  pSavePermisos LastId, register.Id
  
  m_Copy = False
  cIABMClient_Save = Load(register.Id)

  Exit Function
SaveError:
  m_Id = LastId
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  If m_New Then
    m_ObjTree.AddLeave m_Id, m_BranchId, m_TreeId
  Else
    m_ObjTree.AddIdEdited m_Id
    m_ObjTree.RefreshActiveBranch
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2613, vbNullString)  'Roles
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IPropiedad As cIABMProperty
  
  For Each IPropiedad In m_ObjAbm.Properties
    With IPropiedad
      Select Case .Key
        Case K_NAME
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1007, vbNullString)  'Debe indicar un nombre
            Exit Function
          End If
        Case K_ACTIVE
      End Select
    End With
  Next
  
  cIABMClient_Validate = True
End Function

'////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
' Grid
Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean

End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Select Case Key
  
    Case K_USUARIOS
      Id = pCell(Row, KI_US_ID).Id
      If Id <> csNO_ID Then m_ItemsDeletedUsuarios = m_ItemsDeletedUsuarios & Id & ","
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_USUARIOS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowUsuarios(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_USUARIOS
      cIABMClientGrid_ValidateRow = pValidateRowUsuarios(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' Implementacion de cIEditGeneric
Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Property Let cIEditGeneric_TreeId(ByVal rhs As Long)
    m_TreeId = rhs
End Property

Private Property Get cIEditGeneric_TreeId() As Long
    cIEditGeneric_TreeId = m_TreeId
End Property

Private Function cIEditGeneric_GridAdd(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
    cIEditGeneric_ShowList = CSOAPI2.SecurityCanAccess(csPreOListaRol)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not CSOAPI2.SecurityCanAccess(csPreOBorrarRol) Then Exit Function
 
    Dim sqlstmt As String
    sqlstmt = "Delete usuarioRol where rol_id = " & Id & vbCrLf & _
              "Delete permiso where rol_id = " & Id & vbCrLf & _
              "Delete Rol where rol_id = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", "cRol")
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancel As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_New = True
    If Not CSOAPI2.SecurityCanAccess(csPreOAltaRol) Then Exit Function
  Else
    m_New = False
    If Not CSOAPI2.SecurityCanAccess(csPreOEditarRol) Then Exit Function
  End If
  
' JMA I
  m_ObjAbm.InModalWindow = InModalWindow
' JMA F
  
  If Not Load(Id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  m_Editing = True
  m_Copy = False
  
' JMA I
  If InModalWindow Then
    cIEditGeneric_Edit = m_Id <> csNO_ID
  Else
    cIEditGeneric_Edit = True
  End If
' JMA I

  Exit Function
ControlError:
  MngError Err, "cIEditGeneric_Edit", "cRol", vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal Id As Long) As Boolean

End Function

Private Property Set cIEditGeneric_ObjTree(rhs As Object)
    Set m_ObjTree = rhs
End Property

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)
    m_BranchId = rhs
End Property

Private Property Get cIEditGeneric_BranchId() As Long
    cIEditGeneric_BranchId = m_BranchId
End Property

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Function cIEditGeneric_Preview(ByVal Id As Long) As Boolean

End Function

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_2756  As String
  
  str_2756 = LNGGetText(2756, vbNullString) '&Roles
  Set m_Host = Host

  m_Host.Server.AddMenu C_MenuCfgEmpresa, csMenuCfgEmpresa, C_MenuConfig, 0, True, False, False, False, True, Nothing
  
  m_Host.Server.AddMenu str_2756, csMenuCfgRol, C_MenuCfgEmpresa, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(2764, vbNullString), csPreOListaRol, str_2756, 0, True, False, False, False, False, Me, 1
                        '&Definición
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuABMClick "CSOAPIEdit.cRol", Me, LNGGetText(2613, vbNullString), 0, csTables.csRol
                                            'Roles
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim iTab As cIABMTabItem
  Dim c As cIABMProperty
  
  Const c_tab_usuarios = 1
  
  m_ObjAbm.Properties.Clear
  m_ObjAbm.Tabs.Clear
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = 0
  iTab.Name = C_strGeneral
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = c_tab_usuarios
  iTab.Name = LNGGetText(1137, vbNullString)  'Usuarios
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscRolNombre)
  c.PropertyType = cspText
  c.Name = C_strNombre
  c.Width = 4000
  c.Size = 100
  c.Key = K_NAME
  c.Value = m_Name
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscActivo)
  c.PropertyType = cspCheck
  c.Name = C_strActivo
  c.Key = K_ACTIVE
  c.Value = CInt(m_Active)
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscRolDescrip)
  c.PropertyType = cspText
  c.Name = C_strDescrip
  c.SubType = cspMemo
  c.Width = 5500
  c.Height = 880
  c.Value = m_Descrip
  c.Key = K_DESCRIP
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_usuarios)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  If Not pLoadUsuarios(c) Then Exit Function
  c.Name = "Usuarios"
  c.Key = K_USUARIOS
  c.TabIndex = c_tab_usuarios
  c.GridAdd = True
  c.GridEdit = True
  c.GridRemove = True
  
  m_ItemsDeletedUsuarios = vbNullString
  
  If Not m_ObjAbm.Show(Me) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  Dim sqlstmt As String
  
  sqlstmt = "select * from rol where rol_id = " & Id
  
  Dim rs As ADODB.Recordset
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", "cRol") Then Exit Function
  
  If rs.EOF Then
    m_Active = True
    m_Name = vbNullString
    m_Descrip = vbNullString
    m_Id = csNO_ID
  Else
    m_Active = gDB.ValField(rs.Fields, cscActivo)
    m_Name = gDB.ValField(rs.Fields, cscRolNombre)
    m_Descrip = gDB.ValField(rs.Fields, cscRolDescrip)
    m_Id = gDB.ValField(rs.Fields, cscRolId)
  End If
  Load = True
End Function

Private Function pValidateRowUsuarios(Row As CSInterfacesABM.cIABMGridRow, _
                                      ByVal RowIndex As Long) As Boolean
                                   
  Dim Cell          As cIABMGridCellValue
  Dim strRow        As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_US_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(1153, vbNullString, strRow) 'Debe indicar un usuario (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowUsuarios = True
End Function

Private Function pUpdatePermisos() As Boolean
  Dim sqlstmt As String

  sqlstmt = "sp_SysModuloRolGetEx " & m_Id
  pUpdatePermisos = gDB.Execute(sqlstmt)

End Function

Private Function pSaveItemsRoles() As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim bExists   As Boolean
  
  For Each Row In m_ObjAbm.Properties.Item(c_usuarios).Grid.Rows
    
    Set register = New cRegister

    With register
      .Table = csTusuarioRol
      .Fields.HaveLastUpdate = True
      .Fields.HaveWhoModify = True
      .UtilizaIdentity = True
    
      .Filter = "rol_id = " & m_Id & " and " & _
                "us_id = " & pCell(Row, KI_US_ID).Id
      
      If Not .Exists(gDB, bExists) Then Exit Function
      If Not bExists Then
        
        With .Fields
          .Add2 cscUsId, pCell(Row, KI_US_ID).Id, csId
          .Add2 cscRolId, m_Id, csId
          
          .HaveLastUpdate = True
          .HaveWhoModify = True
      
        End With
        
        If Not gDB.Save(register, True, "pSaveItemsRoles", _
                        C_Module, C_ErrorInSave) Then Exit Function
      End If
      
    End With
  
  Next
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedUsuarios) And Not m_Copy Then
    m_ItemsDeletedUsuarios = RemoveLastColon(m_ItemsDeletedUsuarios)
    sqlstmt = "delete " & csTusuarioRol & _
              " where us_id in (" & m_ItemsDeletedUsuarios & _
              ") and rol_id = " & m_Id
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsRoles", C_Module) Then Exit Function
  End If
  
  pSaveItemsRoles = True
End Function

Private Function pIsEmptyRowUsuarios(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                     ByVal RowIndex As Long) As Boolean
                               
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_US_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowUsuarios = bRowIsEmpty
End Function

Private Function pLoadUsuarios(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select distinct u.us_id, us_nombre" & _
            " from UsuarioRol r inner join Usuario u on r.us_id = u.us_id" & _
              " where r.rol_id = " & m_Id & _
            " order by us_nombre"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadUsuarios", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
      With .Add(Nothing) ' Columna auxiliar
        .Visible = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1137, vbNullString) 'Usuario
        .PropertyType = cspHelp
        .Table = csUsuario
        .Width = 3000
        .Key = KI_US_ID
      End With
      
    End With
    
    With .Rows
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscUsId).Value)
        
          With .Add(Nothing)
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscUsNombre)
            .Id = gDB.ValField(rs.Fields, cscUsId)
            .Key = KI_US_ID
          End With
          
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadUsuarios = True
End Function

Private Sub pSavePermisos(ByVal IdFrom As Long, ByVal IdTo As Long)
  Dim sqlstmt As String

  If m_Copy Then
    If Ask(LNGGetText(3481, vbNullString, m_Name), _
               vbYes) Then
    
      sqlstmt = "sp_RolDuplicarPermisos " & User.Id & "," & IdFrom & "," & IdTo
      gDB.Execute sqlstmt
    
    End If
  End If
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2765, vbNullString) 'Error al grabar Roles
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub
