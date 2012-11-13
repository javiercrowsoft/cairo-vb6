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

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
Implements CSMenu.cIMenuClient
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
Private Const csPersona = 1019
Private Const csSucursal = 1007
Private Const c_empresas = "Empresas"
Private Const c_cliprov = "CliProv"
Private Const c_roles = "Roles"

Private Const cscEmpNombre  As String = "emp_nombre"
Private Const cscEmpId      As String = "emp_id"

Private Const K_NAME            As Integer = 1
Private Const K_KEY             As Integer = 2
Private Const K_ACTIVE          As Integer = 3
Private Const K_CONFIRME        As Integer = 4
Private Const K_EXTERNO         As Integer = 5
Private Const K_CLIPROV_X_DPTO  As Integer = 6
Private Const K_DESCRIP         As Integer = 7
Private Const K_CLIPROV         As Integer = 8
Private Const K_PRS_ID          As Integer = 9
Private Const K_SUC_ID          As Integer = 10
Private Const K_EMPRESAS        As Integer = 11
Private Const K_EMPRESAEX       As Integer = 12
Private Const K_USDEPOSITO      As Integer = 13
Private Const K_ROLES           As Integer = 14

Private Const KI_USEMP_ID   As Integer = 1
Private Const KI_PROV_ID    As Integer = 2
Private Const KI_CLI_ID     As Integer = 3

Private Const KI_ROL_ID     As Integer = 2

Private Const KI_EMPUS_ID                       As Integer = 1
Private Const KI_EMP_ID                         As Integer = 2

' Seudo - Variables
Private c_ErrorSave     As String

Private m_vRowCliProvUpdated() As Long

Private Const C_Module = "cUsuario"
' estructuras
' variables privadas
Private m_Id            As Long
Private m_Name          As String
Private m_Clave         As String
Private m_Descrip       As String
Private m_Active        As Boolean
Private m_UsDeposito    As Boolean
Private m_Externo       As Boolean
Private m_EmpXDpto      As Boolean
Private m_EmpresaEx     As Boolean
Private m_prs_id        As Long
Private m_Persona       As String
Private m_Suc_id        As Long
Private m_Sucursal      As String
Private m_LastUpdate    As Date
Private m_Created       As Date
Private m_Modify        As Long

Private m_Editing          As Boolean

Private m_ObjAbm           As cIABMGeneric
Private m_ObjTree          As Object

Private m_New              As Boolean

Private m_BranchId         As Long
Private m_TreeId           As Long

Private m_Copy                    As Boolean
Private m_IsNew                   As Boolean

Private m_ItemsDeletedCliProv     As String
Private m_ItemsDeletedRoles       As String

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

  Doc.ClientTable = csTusuario
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

Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscUsNombre)
    .Value = C_CopiaDe & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscUsNombre)
  
  m_Copy = True
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  cIEditGeneric_Edit csNO_ID
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  Select Case Key
    Case K_CLIPROV_X_DPTO
      With m_ObjAbm.Properties
        If Val(.Item(cscUsEmpXDpto).Value) Then
          .Item(cscUsEmpresaEx).Value = False
          m_ObjAbm.ShowValue .Item(cscUsEmpresaEx)
        End If
      End With
      
    Case K_EMPRESAEX
      With m_ObjAbm.Properties
        If Val(.Item(cscUsEmpresaEx).Value) Then
          .Item(cscUsEmpXDpto).Value = False
          m_ObjAbm.ShowValue .Item(cscUsEmpXDpto)
        End If
      End With
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Dim LastId   As Long
  
  Set register = New cRegister
  
  register.fieldId = cscUsId
  register.Table = csTusuario
  
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
          register.fields.Add2 cscUsNombre, .Value, csText
        Case K_KEY
          register.fields.Add2 cscUsClave, pEncrypt(UCase(.Value)), csText
        Case K_ACTIVE
          register.fields.Add2 cscActivo, Val(.Value), csBoolean
        Case K_USDEPOSITO
          register.fields.Add2 cscUsDeposito, Val(.Value), csBoolean
        Case K_DESCRIP
          register.fields.Add2 cscUsDescrip, .Value, csText
        Case K_EXTERNO
          register.fields.Add2 cscUsExterno, Val(.Value), csBoolean
        Case K_CLIPROV_X_DPTO
          register.fields.Add2 cscUsEmpXDpto, Val(.Value), csBoolean
        Case K_EMPRESAEX
          register.fields.Add2 cscUsEmpresaEx, Val(.Value), csBoolean
        Case K_PRS_ID
          register.fields.Add2 cscPrsId, .HelpId, csId
        Case K_SUC_ID
          register.fields.Add2 cscSucId, .HelpId, csId
      End Select
    End With
  Next
  
  register.fields.HaveLastUpdate = True
  register.fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.Id
  
  If Not pSaveItemsCliProv() Then GoTo SaveError
  If Not pSaveItemsRoles() Then GoTo SaveError
  If Not pSaveItemsEmpresa() Then GoTo SaveError
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
        m_ObjTree.AddEditedId m_Id
        m_ObjTree.RefreshActiveBranch
    End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = LNGGetText(1130, vbNullString)  'Usuarios
End Property

Private Function cIABMClient_Validate() As Boolean
    Dim IPropiedad As cIABMProperty
    Dim Key As String
    
    For Each IPropiedad In m_ObjAbm.Properties
        With IPropiedad
            Select Case .Key
                Case K_NAME
                    If ValEmpty(.Value, csText) Then
                        MsgInfo LNGGetText(1007, vbNullString)  'Debe indicar un nombre
                        Exit Function
                    End If
                Case K_KEY
                    Key = .Value
                Case K_CONFIRME
                    If Key <> .Value Then
                        MsgInfo LNGGetText(2804, vbNullString)  'La clave y su confirmación no coinciden
                        Exit Function
                    End If
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
  Select Case Key
    Case K_CLIPROV
      pAddRowToUpdated lRow
  End Select
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
  
    Case K_CLIPROV
      Id = Val(pCell(Row, KI_USEMP_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedCliProv = m_ItemsDeletedCliProv & Id & ","
    Case K_ROLES
      Id = pCell(Row, KI_ROL_ID).Id
      If Id <> csNO_ID Then m_ItemsDeletedRoles = m_ItemsDeletedRoles & Id & ","
    Case K_EMPRESAS
      cIABMClientGrid_DeleteRow = False
      Exit Function
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_CLIPROV
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowCliProv(Row, RowIndex)
      m_ObjAbm.ObjForm.Caption = LNGGetText(2805, vbNullString, RowIndex)
                                  'Validando Filas  & RowIndex
      DoEvents
    Case K_ROLES
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowRoles(Row, RowIndex)
    Case K_EMPRESAS
      cIABMClientGrid_IsEmptyRow = False
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
  Select Case Key
    Case K_CLIPROV
      pAddRowToUpdated Rows
  End Select
End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_CLIPROV
      cIABMClientGrid_ValidateRow = pValidateRowCliProv(Row, RowIndex)
    Case K_ROLES
      cIABMClientGrid_ValidateRow = pValidateRowRoles(Row, RowIndex)
    Case K_EMPRESAS
      cIABMClientGrid_ValidateRow = True
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

'////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
  cIEditGeneric_ShowList = CSOAPI2.SecurityCanAccess(csPreOListUser)
End Function

' Implementacion de cIEditGeneric
Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not CSOAPI2.SecurityCanAccess(csPreOBorrarUser) Then Exit Function
    
    Dim sqlstmt As String
    
    sqlstmt = "SP_UsDelete " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancel As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_New = True
    If Not CSOAPI2.SecurityCanAccess(csPreOAltaUser) Then Exit Function
  Else
    m_New = False
    If Not CSOAPI2.SecurityCanAccess(csPreOEditarUser) Then Exit Function
  End If
  
  ' JMA I
  m_ObjAbm.InModalWindow = InModalWindow
' JMA F
  
  If Not Load(Id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  m_Editing = True
  m_Copy = False
  
  If InModalWindow Then
    cIEditGeneric_Edit = m_Id <> csNO_ID
  Else
    cIEditGeneric_Edit = True
  End If

  Exit Function
ControlError:
  MngError Err, Err, "cIEditGeneric_Edit", C_Module, vbNullString
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
  Dim str_2758  As String
  
  str_2758 = LNGGetText(2758, vbNullString)   '&Usuarios
  
  Set m_Host = Host
  m_Host.Server.AddMenu C_MenuCfgEmpresa, csMenuCfgEmpresa, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu str_2758, csMenuCfgUsuario, C_MenuCfgEmpresa, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(2764, vbNullString), csPreOListUser, str_2758, 0, True, False, False, False, False, Me, 0
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
  m_Host.MenuABMClick "CSOAPIEdit.cUsuario", Me, LNGGetText(1130, vbNullString), 0, csTables.csUsuario
                                                'Usuarios
End Function

' Funciones de grabación
Private Function pValidateRowCliProv(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell          As cIABMGridCellValue
  Dim strRow        As String
  Dim bEmpty        As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_PROV_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bEmpty = False
        End If
      Case KI_CLI_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bEmpty = False
        End If
    End Select
  Next
  
  If bEmpty Then
    MsgInfo "Debe indicar un proveedor o un cliente" & strRow
    Exit Function
  End If
  
  pValidateRowCliProv = True
End Function

Private Function pValidateRowRoles(Row As CSInterfacesABM.cIABMGridRow, _
                                   ByVal RowIndex As Long) As Boolean
                                   
  Dim Cell          As cIABMGridCellValue
  Dim strRow        As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_ROL_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo "Debe indicar un rol" & strRow
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowRoles = True
End Function

Private Function pSaveItemsEmpresa() As Boolean
  Dim register  As cRegister

  Dim sqlstmt As String
  sqlstmt = "delete " & csTEmpresaUsuario & " where us_id = " & m_Id
  If Not gDB.Execute(sqlstmt, "pSaveItemsEmpresa", C_Module) Then Exit Function

  With m_ObjAbm.Properties.Item(c_empresas)
    Dim Row  As cIABMGridRow
    
    For Each Row In .Grid.Rows
    
      If pCell(Row, KI_EMPUS_ID).Id Then
        Set register = New cRegister
        register.fieldId = cscEmpUsId
        register.Table = csTEmpresaUsuario
        register.Id = csNew
        
        register.fields.Add2 cscEmpId, pCell(Row, KI_EMP_ID).Id, csId
        
        register.fields.Add2 cscUsId, m_Id, csId
        
        register.fields.HaveLastUpdate = True
        register.fields.HaveWhoModify = True
        
        If Not gDB.Save(register, , "pSaveItemsEmpresa", C_Module, "Error al grabar percepciones") Then Exit Function
      End If
    Next
  End With
  
  pSaveItemsEmpresa = True
End Function


Private Function pSaveItemsCliProv() As Boolean
  Dim register  As cRegister
  Dim IProperty As cIABMProperty
  Dim lRow      As Long
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  
  With m_ObjAbm.Properties.Item(c_cliprov)
    
    For lRow = 1 To .Grid.Rows.Count
    
      If pRowWasUpdated(lRow) Then
    
        Set Row = .Grid.Rows.Item(lRow)
        
        Set register = New cRegister
        register.fieldId = cscUsEmpId
        register.Table = csTUsuarioEmpresa
        register.Id = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
          
            Case KI_USEMP_ID
              If Not m_Copy Then
                register.Id = Val(Cell.Value)
              End If
            Case KI_CLI_ID
              register.fields.Add2 cscCliId, Cell.Id, csId
            Case KI_PROV_ID
              register.fields.Add2 cscProvId, Cell.Id, csId
          End Select
        Next
        
        register.fields.Add2 cscUsId, m_Id, csId
        
        register.fields.HaveLastUpdate = True
        register.fields.HaveWhoModify = True
        
        If Not gDB.Save(register, , "pSaveItemsCliProv", C_Module, C_ErrorInSave) Then Exit Function
      End If
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedCliProv) And Not m_Copy Then
    m_ItemsDeletedCliProv = RemoveLastColon(m_ItemsDeletedCliProv)
    sqlstmt = "delete UsuarioEmpresa where usemp_id in (" & m_ItemsDeletedCliProv & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsCliProv", C_Module) Then Exit Function
  End If
  
  pSaveItemsCliProv = True
End Function

Private Function pSaveItemsRoles() As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim bExists   As Boolean
  
  For Each Row In m_ObjAbm.Properties.Item(c_roles).Grid.Rows
    
    Set register = New cRegister

    With register
      .Table = csTusuarioRol
      .fields.HaveLastUpdate = True
      .fields.HaveWhoModify = True
      .UtilizaIdentity = True
    
      .Filter = "us_id = " & m_Id & " and " & _
                "rol_id = " & pCell(Row, KI_ROL_ID).Id
      
      If Not .Exists(gDB, bExists) Then Exit Function
      If Not bExists Then
        
        With .fields
          .Add2 cscRolId, pCell(Row, KI_ROL_ID).Id, csId
          .Add2 cscUsId, m_Id, csId
          
          .HaveLastUpdate = True
          .HaveWhoModify = True
      
        End With
        
        If Not gDB.Save(register, True, "pSaveItemsRoles", _
                        C_Module, C_ErrorInSave) Then Exit Function
      End If
      
    End With
  
  Next
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedRoles) And Not m_Copy Then
    m_ItemsDeletedRoles = RemoveLastColon(m_ItemsDeletedRoles)
    sqlstmt = "delete " & csTusuarioRol & _
              " where rol_id in (" & m_ItemsDeletedRoles & _
              ") and us_id = " & m_Id
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsRoles", C_Module) Then Exit Function
  End If
  
  pSaveItemsRoles = True
End Function

Private Function pIsEmptyRowCliProv(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CLI_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_PROV_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowCliProv = bRowIsEmpty
End Function

Private Function pIsEmptyRowRoles(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                  ByVal RowIndex As Long) As Boolean
                               
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_ROL_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowRoles = bRowIsEmpty
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  Dim iTab As cIABMTabItem
  
  Const c_tab_empresas = 2
  Const c_tab_roles = 3
  
  ' Vector con las filas de clientes o proveedores
  ' actualizadas por el usuario
  '
  ReDim m_vRowCliProvUpdated(0)
  
  m_ObjAbm.Properties.Clear
  m_ObjAbm.Tabs.Clear
      
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = 0
  iTab.Name = C_strGeneral
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = 1
  iTab.Name = LNGGetText(2806, vbNullString)  'Cliente/Proveedor
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = c_tab_empresas
  iTab.Name = LNGGetText(1171, vbNullString)  'Empresas
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = c_tab_roles
  iTab.Name = LNGGetText(2613, vbNullString)  'Roles
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscUsNombre)
  c.PropertyType = cspText
  c.Name = C_strNombre
  c.Size = 50
  c.Key = K_NAME
  c.Value = m_Name
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscUsClave)
  c.PropertyType = cspPassword
  c.Name = LNGGetText(2807, vbNullString)  'Clave
  c.Size = 16
  c.Value = m_Clave
  c.Key = K_KEY
  
  Set c = m_ObjAbm.Properties.Add(Nothing, "CONFIRMACION")
  c.PropertyType = cspPassword
  c.Name = "Confirmar"
  c.Size = 16
  c.Value = m_Clave
  c.Key = K_CONFIRME
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscActivo)
  c.PropertyType = cspCheck
  c.Name = C_strActivo
  c.Key = K_ACTIVE
  c.Value = CInt(m_Active)
    
  Set c = m_ObjAbm.Properties.Add(Nothing, cscUsDeposito)
  c.PropertyType = cspCheck
  c.Name = LNGGetText(2808, vbNullString)  'Este usuario NO especifica Depósitos de trabajo
  c.Key = K_USDEPOSITO
  c.Left = 6000
  c.LeftLabel = -3500
  c.TopFromProperty = cscActivo
  c.LeftNotChange = True
  c.Value = CInt(m_UsDeposito)
    
  Set c = m_ObjAbm.Properties.Add(Nothing, cscUsExterno)
  c.PropertyType = cspCheck
  c.Name = LNGGetText(2810, vbNullString)  'Externo
  c.Key = K_EXTERNO
  c.Value = CInt(m_Externo)
    
  Set c = m_ObjAbm.Properties.Add(Nothing, cscUsEmpXDpto)
  c.PropertyType = cspCheck
  c.Name = LNGGetText(2809, vbNullString)  'Clientes/Proveedores por departamento
  c.Key = K_CLIPROV_X_DPTO
  c.Value = CInt(m_EmpXDpto)
  c.LeftNotChange = True
  c.Left = 4950
  c.LeftLabel = -2950
  c.TopFromProperty = cscUsExterno
  c.TopNotChange = True
    
  Set c = m_ObjAbm.Properties.Add(Nothing, cscUsEmpresaEx)
  c.PropertyType = cspCheck
  c.Name = LNGGetText(2811, vbNullString)  'Clientes/Proveedores por Usuario
  c.Key = K_EMPRESAEX
  c.Value = CInt(m_EmpresaEx)
  c.LeftNotChange = True
  c.Left = 8150
  c.TopFromProperty = cscUsExterno
  c.TopNotChange = True
  c.LeftLabel = -2600
    
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPrsId)
  c.TopFromProperty = cscUsNombre
  c.Left = 5500
  c.PropertyType = cspHelp
  c.Table = csPersona
  c.Name = LNGGetText(2812, vbNullString)  'Persona
  c.Key = K_PRS_ID
  c.HelpId = m_prs_id
  c.Value = m_Persona
    
  Set c = m_ObjAbm.Properties.Add(Nothing, cscSucId)
  c.PropertyType = cspHelp
  c.Table = csSucursal
  c.Name = LNGGetText(1281, vbNullString)  'Sucursal
  c.Key = K_SUC_ID
  c.HelpId = m_Suc_id
  c.Value = m_Sucursal
    
  Set c = m_ObjAbm.Properties.Add(Nothing, cscUsDescrip)
  c.PropertyType = cspText
  c.SubType = cspMemo
  c.Name = C_strDescrip
  c.Size = 5000
  c.Key = K_DESCRIP
  c.TopFromProperty = cscUsExterno
  c.TopToPrevious = 440
  c.LeftFromProperty = cscUsNombre
  c.Value = m_Descrip
  c.Width = 7450
  c.Height = 800

  Set c = m_ObjAbm.Properties.Add(Nothing, c_cliprov)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  If Not pLoadCliProv(c) Then Exit Function
  c.Name = "CliProv"
  c.Key = K_CLIPROV
  c.TabIndex = 1
  c.GridAdd = True
  c.GridEdit = True
  c.GridRemove = True
  
  m_ItemsDeletedCliProv = vbNullString

  Set c = m_ObjAbm.Properties.Add(Nothing, c_empresas)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  If Not pLoadEmpresas(c) Then Exit Function
  c.Name = c_empresas
  c.Key = K_EMPRESAS
  c.TabIndex = c_tab_empresas
  c.GridAdd = False
  c.GridEdit = True
  c.GridRemove = False

  Set c = m_ObjAbm.Properties.Add(Nothing, c_roles)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  If Not pLoadRoles(c) Then Exit Function
  c.Name = "Roles"
  c.Key = K_ROLES
  c.TabIndex = c_tab_roles
  c.GridAdd = True
  c.GridEdit = True
  c.GridRemove = True
  
  m_ItemsDeletedRoles = vbNullString

  If Not m_ObjAbm.Show(Me) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  Dim sqlstmt As String
  Dim Encrypt As cEncrypt
  Set Encrypt = New cEncrypt
    
  sqlstmt = "sp_UsuarioGet " & Id
  
  Dim rs As ADODB.Recordset
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", C_Module) Then Exit Function
  
  If rs.EOF Then
    m_Active = True
    m_UsDeposito = False
    m_Name = vbNullString
    m_Id = csNO_ID
    m_Clave = vbNullString
    m_Descrip = vbNullString
    m_Externo = False
    m_EmpXDpto = False
    m_EmpresaEx = False
    m_prs_id = csNO_ID
    m_Persona = vbNullString
    m_Suc_id = csNO_ID
    m_Sucursal = vbNullString
  Else
    m_Active = gDB.ValField(rs.fields, cscActivo)
    m_UsDeposito = gDB.ValField(rs.fields, cscUsDeposito)
    m_Name = gDB.ValField(rs.fields, cscUsNombre)
    m_Id = gDB.ValField(rs.fields, cscUsId)
    m_Clave = Encrypt.Decript(gDB.ValField(rs.fields, cscUsClave), c_LoginSignature)
    m_Descrip = gDB.ValField(rs.fields, cscUsDescrip)
    m_Externo = gDB.ValField(rs.fields, cscUsExterno)
    m_prs_id = gDB.ValField(rs.fields, cscPrsId)
    m_Persona = gDB.ValField(rs.fields, cscPrsNombre)
    m_Suc_id = gDB.ValField(rs.fields, cscSucId)
    m_Sucursal = gDB.ValField(rs.fields, cscSucNombre)
    m_EmpXDpto = gDB.ValField(rs.fields, cscUsEmpXDpto)
    m_EmpresaEx = gDB.ValField(rs.fields, cscUsEmpresaEx)
  End If
  Load = True
End Function

Private Function pLoadCliProv(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  ' Vector con las filas de clientes o proveedores
  ' actualizadas por el usuario
  '
  ReDim m_vRowCliProvUpdated(0)
  
  sqlstmt = "select UsuarioEmpresa.*, prov_nombre, cli_nombre" & _
            " from UsuarioEmpresa, Proveedor, Cliente" & _
              " where UsuarioEmpresa.us_id = " & m_Id & _
                " and UsuarioEmpresa.prov_id *= Proveedor.prov_id" & _
                " and UsuarioEmpresa.cli_id *= Cliente.cli_id" & _
            " order by cli_nombre,prov_nombre"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCliProv", C_Module) Then Exit Function
  
  Const csCliente = 28
  Const csProveedor = 29
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
      With .Add(Nothing)
        .Name = "usemp_id"
        .Visible = False
        .Key = KI_USEMP_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1150, vbNullString)  'Cliente
        .PropertyType = cspHelp
        .Table = csCliente
        .Width = 3000
        .Key = KI_CLI_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1151, vbNullString)  'Proveedor
        .PropertyType = cspHelp
        .Table = csProveedor
        .Width = 3000
        .Key = KI_PROV_ID
      End With
    End With
    
    With .Rows
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscUsEmpId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscUsEmpId).Value
            .Key = KI_USEMP_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCliNombre)
            .Id = gDB.ValField(rs.fields, cscCliId)
            .Key = KI_CLI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscProvNombre)
            .Id = gDB.ValField(rs.fields, cscProvId)
            .Key = KI_PROV_ID
          End With
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadCliProv = True
End Function

Private Function pLoadRoles(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select distinct r.rol_id, rol_nombre" & _
            " from UsuarioRol u inner join Rol r on u.rol_id = r.rol_id" & _
              " where u.us_id = " & m_Id & _
            " order by rol_nombre"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadRoles", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
      With .Add(Nothing) ' Columna auxiliar
        .Visible = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2619, vbNullString)  'Rol
        .PropertyType = cspHelp
        .Table = csRol
        .Width = 3000
        .Key = KI_ROL_ID
      End With
      
    End With
    
    With .Rows
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscRolId).Value)
        
          With .Add(Nothing)
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRolNombre)
            .Id = gDB.ValField(rs.fields, cscRolId)
            .Key = KI_ROL_ID
          End With
          
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadRoles = True
End Function

Private Function pEncrypt(ByVal Value As String) As String
  Dim Encrypt As cEncrypt
  Set Encrypt = New cEncrypt
  
  pEncrypt = Encrypt.Encript(LCase(Value), c_LoginSignature)
End Function

Private Function pLoadEmpresas(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select e.emp_id,emp_nombre,empus_id" & vbCrLf
  sqlstmt = sqlstmt & "from empresa e left join empresausuario eu on e.emp_id = eu.emp_id" & vbCrLf
  sqlstmt = sqlstmt & "and eu.us_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadEmpresas", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Visible = False
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1114, vbNullString) 'Empresa
  o.PropertyType = cspText
  o.Width = 3500
  o.Key = KI_EMP_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = ""
  o.Width = 800
  o.PropertyType = cspCheck
  o.Key = KI_EMPUS_ID
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscEmpId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = rs(cscEmpId).Value
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscEmpNombre)
    fv.Id = rs(cscEmpId).Value
    fv.Key = KI_EMP_ID
    
    Set fv = F.Add(Nothing)
    fv.Id = gDB.ValField(rs.fields, cscEmpUsId)
    fv.Value = fv.Id
    fv.Key = KI_EMPUS_ID
    
    rs.MoveNext
  Wend
  
  pLoadEmpresas = True
End Function

Private Function pUpdatePermisos() As Boolean
  Dim sqlstmt As String

  sqlstmt = "sp_SysModuloGetEx " & m_Id
  pUpdatePermisos = gDB.Execute(sqlstmt)

End Function

Private Sub pSavePermisos(ByVal IdFrom As Long, ByVal IdTo As Long)
  Dim sqlstmt As String

  If m_Copy Then
    If Ask(LNGGetText(3480, vbNullString, m_Name), _
               vbYes) Then
    
      sqlstmt = "sp_UsuarioDuplicarPermisos " & User.Id & "," & IdFrom & "," & IdTo
      gDB.Execute sqlstmt
    
    End If
  End If
End Sub

Private Sub pAddRowToUpdated(ByVal lRow As Long)
  If Not pRowWasUpdated(lRow) Then
    ReDim Preserve m_vRowCliProvUpdated(UBound(m_vRowCliProvUpdated) + 1)
    m_vRowCliProvUpdated(UBound(m_vRowCliProvUpdated)) = lRow
  End If
End Sub

Private Function pRowWasUpdated(ByVal lRow As Long)
  Dim i As Long
  For i = 1 To UBound(m_vRowCliProvUpdated)
    If lRow = m_vRowCliProvUpdated(i) Then
      pRowWasUpdated = True
      Exit Function
    End If
  Next
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  ReDim m_vRowCliProvUpdated(0)
  
  c_ErrorSave = LNGGetText(2813, vbNullString) 'Error al grabar el Usuario
  
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
  ReDim m_vRowCliProvUpdated(0)
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

