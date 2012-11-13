VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cListaDescuento"
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
' cListaDescuentoEdit
' 04-12-2004

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cListaDescuentoEdit"

Private Const c_keyProveedores = "Proveedores"
Private Const c_keyClientes = "Clientes"

Private Const c_Descuentos = "Descuentos"
Private Const c_Producto = "pr_id"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHADESDE                     As Integer = 4
Private Const K_FECHAHASTA                     As Integer = 5
Private Const K_ID_PADRE                       As Integer = 7
Private Const K_PORCENTAJE                     As Integer = 8
Private Const K_ACTIVO                         As Integer = 9
Private Const K_DESCUENTOS                     As Integer = 10
Private Const K_CLIENTES                       As Integer = 11
Private Const K_PROVEEDORES                    As Integer = 12
Private Const K_TIPO                           As Integer = 13
Private Const K_MON_ID                         As Integer = 14

Private Const KI_PRODUCTO                 As Integer = 1
Private Const KI_DESCUENTO                As Integer = 2
Private Const KI_PORCENTAJE               As Integer = 3
Private Const KI_LDI_ID                   As Integer = 4

Private Const KI_LDCLI_ID                       As Integer = 1
Private Const KI_CLI_ID                         As Integer = 3

Private Const KI_LDPROV_ID                       As Integer = 1
Private Const KI_PROV_ID                         As Integer = 3

' estructuras
' Seudo - Variables
Private c_ErrorSave                    As String

' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_Descrip                      As String
Private m_FechaDesde                   As Date
Private m_FechaHasta                   As Date
Private m_ListaPadre                   As String
Private m_Id_Padre                     As Long
Private m_Porcentaje                   As Currency
Private m_Activo                       As Boolean
Private m_Tipo                         As csEListaDescuentoTipo
'Private m_Creado                       As Date
'Private m_Modificado                   As Date
'Private m_Modifico                     As Long
Private m_mon_id                       As Long
Private m_Moneda                       As String

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long
 
Private m_ItemsDeleted            As String
Private m_ItemsDeletedClientes    As String
Private m_ItemsDeletedProveedores As String

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

Private m_GeneralConfig     As cGeneralConfig

' Properties publicas

' JMA I
Public Property Get ID() As Long
  ID = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property
' JMA F

' Properties privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscLdCodigo)
    .Value = C_C & .Value
  End With
  
  With m_ObjAbm.Properties(cscLdNombre)
    .Value = C_CopiaDe & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscLdCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscLdNombre)
  
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

  Doc.ClientTable = csTListaDescuento
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, C_ShowDocDigital, C_Module, vbNullString
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
  Dim iProp As cIABMProperty
  
  With m_ObjAbm.Properties
    Select Case Key
      Case K_TIPO
        
        Set iProp = .Item(c_Descuentos)
        
        If .Item(cscLdTipo).ListItemData = csELDT_Compra Then
          .Item(c_keyClientes).Enabled = False
          .Item(c_keyProveedores).Enabled = True
          
          iProp.Grid.Columns(c_Producto).Table = csProductoCompra
        Else
          .Item(c_keyClientes).Enabled = True
          .Item(c_keyProveedores).Enabled = False
          
          iProp.Grid.Columns(c_Producto).Table = csProductoVenta
        End If
        
        m_ObjAbm.ShowValue iProp
        m_ObjAbm.ShowValue .Item(c_keyClientes)
        m_ObjAbm.ShowValue .Item(c_keyProveedores)
        
        pSetFilterLPBase
  
      Case K_ID_PADRE
        Set iProp = .Item(cscLdPorcentaje)
        iProp.Enabled = .Item(cscLdIdPadre).HelpId <> csNO_ID
        m_ObjAbm.ShowValue iProp
    
      Case K_MON_ID
        pSetFilterLPBase
    End Select
  End With
End Function

Private Sub pSetFilterLPBase()
  Dim iProp As cIABMProperty

  With m_ObjAbm.Properties
  
    ' Filtro de lista base
    '
    Set iProp = .Item(cscLdIdPadre)
    
    iProp.HelpFilter = "ld_id <> " & m_Id & " and  mon_id = " & .Item(cscMonId).HelpId
    If .Item(cscLdTipo).ListItemData = csELDT_Compra Then
      iProp.HelpFilter = iProp.HelpFilter & " and ld_tipo = " & csELDT_Compra
    End If
    m_ObjAbm.ShowValue iProp
  End With
End Sub

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Dim fields   As cFields
  Dim Tipo     As csEListaDescuentoTipo
  Dim LastId   As Long
  
  Set register = New cRegister
  
  With register
    Set fields = .fields
    .fieldId = cscLdId
    .Table = csTListaDescuento
  
    If m_Copy Then
      .ID = csNew
    Else
      .ID = m_Id
    End If
  End With
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          fields.Add2 cscLdNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscLdCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscLdDescrip, .Value, csText
        Case K_FECHADESDE
          fields.Add2 cscLdFechadesde, .Value, csDate
        Case K_FECHAHASTA
          fields.Add2 cscLdFechahasta, .Value, csDate
        Case K_ID_PADRE
          fields.Add2 cscLdIdPadre, .HelpId, csId
        Case K_PORCENTAJE
          fields.Add2 cscLdPorcentaje, .Value, csCurrency
        Case K_MON_ID
          fields.Add2 cscMonId, .HelpId, csId
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
        Case K_TIPO
          fields.Add2 cscLdTipo, .ListItemData, csInteger
          Tipo = Val(.ListItemData)
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.SaveEx(register, , _
                    cscLdCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.ID
  
  If Not pSaveItems() Then GoTo SaveError
  If Not pSaveItemsClientes(Tipo) Then GoTo SaveError
  If Not pSaveItemsProveedores(Tipo) Then GoTo SaveError
  
  If Not register.CommitTrans() Then GoTo SaveError
  
  m_Copy = False
  cIABMClient_Save = Load(register.ID)

  Exit Function
SaveError:
  m_Id = LastId
End Function

Private Function pSaveItems() As Boolean
  Dim register   As cRegister
  Dim IProperty  As cIABMProperty
  Dim RowIndex   As Long
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_DESCUENTOS
        
          Dim Row  As cIABMGridRow
          Dim Cell As cIABMGridCellValue
          
          For Each Row In IProperty.Grid.Rows
          
            RowIndex = RowIndex + 1
          
            If Not pValidateRowDescuentos(Row, RowIndex) Then Exit Function
          
            Set register = New cRegister
            
            With register
              .fieldId = cscLdiId
              .Table = csTListaDescuentoItem
              .ID = csNew
              
              For Each Cell In Row
                Select Case Cell.Key
                  Case KI_LDI_ID
                    If Not m_Copy Then
                      .ID = Val(Cell.Value)
                    End If
                  Case KI_PORCENTAJE
                    .fields.Add2 cscLdiPorcentaje, Val(Cell.Value), csDouble
                  Case KI_DESCUENTO
                    .fields.Add2 cscLdiPrecio, Val(Cell.Value), csDouble
                  Case KI_PRODUCTO
                    .fields.Add2 cscPrId, Cell.ID, csId
                End Select
              Next
            
              .fields.Add2 cscLdId, m_Id, csId
            
              .fields.HaveLastUpdate = True
              .fields.HaveWhoModify = True
            End With
            
            If Not gDB.Save(register, , C_pSaveItemsFunc, C_Module, c_ErrorSave) Then Exit Function
          Next
      End Select
    End With
  Next
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeleted) And Not m_Copy Then
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    sqlstmt = "delete ListaDescuentoItem where ldi_id in (" & m_ItemsDeleted & ")"
  
    If Not gDB.Execute(sqlstmt, C_pSaveItemsFunc, C_Module) Then Exit Function
  End If
  
  pSaveItems = True
End Function

Private Function pSaveItemsClientes(ByVal Tipo As csEListaDescuentoTipo) As Boolean
  Dim sqlstmt   As String
  Dim register  As cRegister
  
  Dim IProperty As cIABMProperty
  
  If Tipo = csELDT_Compra Then
  
    sqlstmt = "delete ListaDescuentoCliente where ld_id = " & m_Id
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsClientes", C_Module) Then Exit Function
  
  Else
    For Each IProperty In m_ObjAbm.Properties
      With IProperty
        Select Case .Key
          Case K_CLIENTES
          
            Dim Row  As cIABMGridRow
            Dim Cell As cIABMGridCellValue
            
            For Each Row In IProperty.Grid.Rows
            
              Set register = New cRegister
              
              With register
                .fieldId = cscLdCliId
                .Table = csTListaDescuentoCliente
                .ID = csNew
                
                For Each Cell In Row
                  Select Case Cell.Key
                    
                    Case KI_LDCLI_ID
                      If Not m_Copy Then
                        .ID = Val(Cell.Value)
                      End If
                    
                    Case KI_CLI_ID
                      .fields.Add2 cscCliId, Cell.ID, csId
                  
                  End Select
                Next
                
                .fields.Add2 cscLdId, m_Id, csId
                
                .fields.HaveLastUpdate = True
                .fields.HaveWhoModify = True
                            
              End With
              
              If Not gDB.Save(register, , "pSaveItemsClientes", C_Module, c_ErrorSave) Then Exit Function
            Next
        End Select
      End With
    Next
  
    If LenB(m_ItemsDeletedClientes) And Not m_Copy Then
      m_ItemsDeletedClientes = RemoveLastColon(m_ItemsDeletedClientes)
      sqlstmt = "delete ListaDescuentoCliente where ldcli_id in (" & m_ItemsDeletedClientes & ")"
    
      If Not gDB.Execute(sqlstmt, "pSaveItemsClientes", C_Module) Then Exit Function
    End If
  End If
  
  pSaveItemsClientes = True
End Function

Private Function cIABMClient_Terminate() As Boolean
    m_Editing = False
    
    cIABMClient_Terminate = True
    ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
    ' le doy bola
    On Error GoTo ControlError
    If m_Id = csNO_ID Then Exit Function
    If m_ObjTree Is Nothing Then Exit Function
    
    If m_IsNew Then
        m_ObjTree.AddLeave m_Id, m_BranchId, m_TreeId
    Else
        m_ObjTree.AddEditedId m_Id
        m_ObjTree.RefreshActiveBranch
    End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = LNGGetText(3067, vbNullString) 'Listas de Descuentos
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo C_DebeIndicarNombre
            Exit Function
          End If
'        Case K_CODIGO
'          If ValEmpty(.Value, csText) Then
'            MsgInfo C_DebeIndicarCodigo
'            Exit Function
'          End If
        Case K_FECHADESDE
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(2393, vbNullString) 'Debe indicar una fecha desde
            Exit Function
          End If
        Case K_FECHAHASTA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(2394, vbNullString) 'Debe indicar una fecha hasta
            Exit Function
          End If
        Case K_MON_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1108, vbNullString) 'Debe indicar una moneda
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

' Implementacion de cIABMClientGrid
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
  Dim ID As Long
  
  Select Case Key
  
    Case K_DESCUENTOS
      ID = Val(pCell(Row, KI_LDI_ID).Value)
      If ID <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & ID & C_StrColon
    
    Case K_CLIENTES
      ID = Val(pCell(Row, KI_LDCLI_ID).Value)
      If ID <> csNO_ID Then m_ItemsDeletedClientes = m_ItemsDeletedClientes & ID & C_StrColon
    
    Case K_PROVEEDORES
      ID = Val(pCell(Row, KI_LDPROV_ID).Value)
      If ID <> csNO_ID Then m_ItemsDeletedProveedores = m_ItemsDeletedProveedores & ID & C_StrColon
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_DESCUENTOS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowPrecios(Row, RowIndex)
    Case K_CLIENTES
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowClientes(Row, RowIndex)
    Case K_PROVEEDORES
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowProveedores(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_IsEmptyRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function pValidateRowClientes(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
        Case KI_CLI_ID
          If ValEmpty(Cell.ID, csId) Then
            MsgInfo LNGGetText(1351, vbNullString, strRow) 'Debe indicar un cliente (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowClientes = True
  
End Function

Private Function pValidateRowProveedores(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
        Case KI_PROV_ID
          If ValEmpty(Cell.ID, csId) Then
            MsgInfo LNGGetText(1349, vbNullString, strRow) 'Debe indicar un proveedor (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowProveedores = True
  
End Function

Private Function pValidateRowDescuentos(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                   As cIABMGridCellValue
  Dim EmptyPriceAndPercent  As Boolean
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  EmptyPriceAndPercent = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_PRODUCTO
        If Cell.ID = csNO_ID Then
          MsgWarning LNGGetText(3068, vbNullString, strRow) 'Debe indicar un producto (1)
          Exit Function
        End If
      Case KI_DESCUENTO
        If Val(Cell.Value) <> 0 Then
          EmptyPriceAndPercent = False
        End If
      Case KI_PORCENTAJE
        If Val(Cell.Value) <> 0 Then
          If Abs(Val(Cell.Value)) > 100 Then
            MsgWarning LNGGetText(3069, vbNullString, strRow)
                      'El porcentaje no puede ser mayor a 100.00% (1)
            Exit Function
          End If
          EmptyPriceAndPercent = False
        End If
    End Select
  Next
  
  If EmptyPriceAndPercent Then
    MsgWarning LNGGetText(3070, vbNullString, strRow)
                'Debe indicar un Descuento o un porcentaje (1)
    Exit Function
  End If

  pValidateRowDescuentos = True

End Function

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_DESCUENTOS
      cIABMClientGrid_ValidateRow = pValidateRowDescuentos(Row, RowIndex)
    Case K_CLIENTES
      cIABMClientGrid_ValidateRow = pValidateRowClientes(Row, RowIndex)
    Case K_PROVEEDORES
      cIABMClientGrid_ValidateRow = pValidateRowProveedores(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' Implementacion de cIEditGeneric
Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Function cIEditGeneric_PrintObj(ByVal ID As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal rhs As Long)
    m_TreeId = rhs
End Property

Private Property Get cIEditGeneric_TreeId() As Long
    cIEditGeneric_TreeId = m_TreeId
End Property

Private Function cIEditGeneric_GridAdd(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListListaDescuento)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(ID As Long) As Boolean
    If Not SecurityCanAccess(csPreGDeleteListaDescuento) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "Update cliente set ld_id = null where ld_id = " & ID & vbCrLf
    sqlstmt = sqlstmt & "Update proveedor set ld_id = null where ld_id = " & ID & vbCrLf
    sqlstmt = sqlstmt & "Delete ListaDescuentoItem where ld_id = " & ID & vbCrLf
    sqlstmt = sqlstmt & "Delete ListaDescuentoProveedor where ld_id = " & ID & vbCrLf
    sqlstmt = sqlstmt & "Delete ListaDescuentoCliente where ld_id = " & ID & vbCrLf
    sqlstmt = sqlstmt & "Delete ListaDescuento where ld_id = " & ID
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If ID = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewListaDescuento) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditListaDescuento) Then Exit Function
  End If

' JMA I
  m_ObjAbm.InModalWindow = InModalWindow
' JMA F

  If Not Load(ID) Then Exit Function
  
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
  MngError Err, C_EditGenericEdit, C_Module, vbNullString
End Function

Private Property Set cIEditGeneric_ObjTree(rhs As Object)
    Set m_ObjTree = rhs
End Property

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)
    m_BranchId = rhs
End Property

Private Property Get cIEditGeneric_BranchId() As Long
    cIEditGeneric_BranchId = m_BranchId
End Property

Private Function cIEditGeneric_Preview(ByVal ID As Long) As Boolean

End Function

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
  
  m_Host.Server.AddMenu C_MenuArticulos, csMenuConfigArticulos, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(3071, vbNullString), csPreGListListaDescuento, C_MenuArticulos, 0, True, False, False, False, False, Me
                        '&Listas de Descuentos
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  m_Host.MenuABMClick "CSArticulo.cListaDescuento", Me, LNGGetText(3067, vbNullString), 0, csETablasGeneral.csListaDescuento
                                                        ' Listas de Descuentos
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
    
  With m_ObjAbm.Tabs
  
    .Clear
      
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
    
    With .Add(Nothing)
      .Index = 1
      .Name = c_Descuentos
    End With
    
    With .Add(Nothing)
      .Index = 2
      .Name = LNGGetText(1303, vbNullString) 'Clientes
    End With
  
    With .Add(Nothing)
      .Index = 3
      .Name = LNGGetText(1302, vbNullString) 'Proveedores
    End With
    
  End With
  
  m_ObjAbm.Title2 = m_Nombre
  
  With m_ObjAbm.Properties
    
    .Clear
  
    With .Add(Nothing, cscLdNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
    End With
      
    With .Add(Nothing, cscLdCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 15
      .Key = K_CODIGO
      .Value = m_Codigo
    End With
      
    With .Add(Nothing, cscLdFechadesde)
      .PropertyType = cspDate
      .Name = LNGGetText(1203, vbNullString) 'Fecha desde
      .Key = K_FECHADESDE
      .Value = m_FechaDesde
    End With
      
    With .Add(Nothing, cscLdFechahasta)
      .PropertyType = cspDate
      .Name = LNGGetText(1204, vbNullString) 'Fecha Hasta
      .Key = K_FECHAHASTA
      .Value = m_FechaHasta
    End With
    
    With .Add(Nothing, cscMonId)
      .PropertyType = cspHelp
      .TopFromProperty = cscLdNombre
      .Left = 5500
      .Table = csMoneda
      .Name = LNGGetText(1113, vbNullString) 'Moneda
      .Key = K_MON_ID
      .Value = m_Moneda
      .HelpId = m_mon_id
    End With
    
    With .Add(Nothing, cscLdIdPadre)
      .PropertyType = cspHelp
      .Table = csListaDescuento
      .Name = LNGGetText(3072, vbNullString) 'Lista de Descuentos Base
      .Key = K_ID_PADRE
      .Value = m_ListaPadre
      .HelpFilter = "ld_id <> " & m_Id & " and mon_id = " & m_mon_id & " and ld_tipo = " & m_Tipo
      .HelpId = m_Id_Padre
    End With
    
    With .Add(Nothing, cscLdPorcentaje)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .Name = LNGGetText(3073, vbNullString) 'Porcentaje s/base
      .Key = K_PORCENTAJE
      .Enabled = m_Id_Padre <> csNO_ID
      .Value = m_Porcentaje
    End With
    
    With .Add(Nothing, m_Activo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
      
    Set c = .Add(Nothing, cscLdTipo)
    With c
      .PropertyType = cspList
        With c.List.Add(Nothing)
          .ID = csELDT_Compra
          .Value = LNGGetText(1058, vbNullString)  'Compra
        End With
        With c.List.Add(Nothing)
          .ID = csELDT_Venta
          .Value = LNGGetText(1059, vbNullString)  'Venta
        End With
      .ListWhoSetItem = csListItemData
      .Name = LNGGetText(1223, vbNullString)  'Tipo
      .Key = K_TIPO
      .ListItemData = m_Tipo
    End With
      
    With .Add(Nothing, cscLdDescrip)
      .PropertyType = cspText
      .Name = C_strDescrip
      .Size = 5000
      .TopFromProperty = cscLdFechahasta
      .TopToPrevious = 880
      .Height = 780
      .Width = 6250
      .SubType = cspMemo
      .LeftFromProperty = cscLdNombre
      .Key = K_DESCRIP
      .Value = m_Descrip
    End With
      
    Set c = .Add(Nothing, c_Descuentos)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadDescuentos(c) Then Exit Function
      .Name = "Descuentos"
      .Key = K_DESCUENTOS
      .TabIndex = 1
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
      
    m_ItemsDeleted = ""
      
    Set c = .Add(Nothing, c_keyClientes)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadClientes(c) Then Exit Function
      .Name = "Clientes"
      .Key = K_CLIENTES
      .TabIndex = 2
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
      .Enabled = m_Tipo = csELDT_Venta
    End With
      
    m_ItemsDeletedClientes = ""
    
    Set c = .Add(Nothing, c_keyProveedores)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadProveedores(c) Then Exit Function
      .Name = "Proveedores"
      .Key = K_PROVEEDORES
      .TabIndex = 3
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
      .Enabled = m_Tipo = csELDT_Compra
    End With
    
    m_ItemsDeletedProveedores = vbNullString
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal ID As Long) As Boolean
  Dim sqlstmt As String
  Dim rs As Recordset

  sqlstmt = "sp_ListaDescuentoGet " & ID

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, c_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscLdId)
    m_Nombre = gDB.ValField(rs.fields, cscLdNombre)
    m_Codigo = gDB.ValField(rs.fields, cscLdCodigo)
    m_Descrip = gDB.ValField(rs.fields, cscLdDescrip)
    m_FechaDesde = gDB.ValField(rs.fields, cscLdFechadesde)
    m_FechaHasta = gDB.ValField(rs.fields, cscLdFechahasta)
    m_Id_Padre = gDB.ValField(rs.fields, cscLdIdPadre)
    m_ListaPadre = gDB.ValField(rs.fields, "Padre")
    m_Porcentaje = gDB.ValField(rs.fields, cscLdPorcentaje)
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_Tipo = gDB.ValField(rs.fields, cscLdTipo)
    m_mon_id = gDB.ValField(rs.fields, cscMonId)
    m_Moneda = gDB.ValField(rs.fields, cscMonNombre)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Descrip = vbNullString
    m_FechaDesde = Date
    m_FechaHasta = VDGetDateById(csMonthNext_LastDay)
    m_Id_Padre = csNO_ID
    m_ListaPadre = vbNullString
    m_Porcentaje = 0
    m_Activo = True
    m_Tipo = csELDT_Venta
    m_mon_id = csNO_ID
    m_Moneda = vbNullString
  End If

  Load = True
End Function

Private Function pLoadDescuentos(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select ListaDescuentoItem.*, pr_nombreventa" & _
            " from ListaDescuentoItem, Producto" & _
              " where ld_id = " & m_Id & _
                " and ListaDescuentoItem.pr_id = Producto.pr_id" & _
              " order by pr_nombreventa"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadDescuentos", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "ldi_id"
  o.Visible = False
  o.Key = KI_LDI_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing, c_Producto)
  o.Name = LNGGetText(1367, vbNullString) 'Articulo
  o.PropertyType = cspHelp
  If m_Tipo = csELDT_Compra Then
    o.Table = csProductoCompra
  Else
    o.Table = csProductoVenta
  End If
  o.Width = 3500
  o.Key = KI_PRODUCTO
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1585, vbNullString) 'Descuento
  o.PropertyType = cspNumeric
  o.SubType = cspMoney
  o.Format = m_GeneralConfig.FormatDecImporte
  o.Width = 1200
  o.Key = KI_DESCUENTO
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1105, vbNullString) 'Porcentaje
  o.PropertyType = cspNumeric
  o.SubType = cspPercent
  o.Width = 1200
  o.Key = KI_PORCENTAJE
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscLdiId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = rs(cscLdiId).Value
    fv.Key = KI_LDI_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = rs(cscPrNombreventa).Value
    fv.ID = rs(cscPrId).Value
    fv.Key = KI_PRODUCTO
    
    Set fv = F.Add(Nothing)
    fv.Value = rs(cscLdiPrecio).Value
    fv.Key = KI_DESCUENTO
    
    Set fv = F.Add(Nothing)
    fv.Value = rs(cscLdiPorcentaje).Value
    fv.Key = KI_PORCENTAJE
    
    rs.MoveNext
  Wend
  
  pLoadDescuentos = True
End Function

Private Function pLoadClientes(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select ListaDescuentoCliente.*,cli_nombre" & _
            " from ListaDescuentoCliente, cliente" & _
              " where ListaDescuentoCliente.ld_id = " & m_Id & _
                " and ListaDescuentoCliente.cli_id = cliente.cli_id" & _
              " order by cli_nombre"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadClientes", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "ldcli_id"
  o.Visible = False
  o.Key = KI_LDCLI_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1150, vbNullString) 'Cliente
  o.PropertyType = cspHelp
  o.Table = csCliente
  o.Width = 3500
  o.Key = KI_CLI_ID
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, gDB.ValField(rs.fields, cscLdCliId))
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscLdCliId)
    fv.Key = KI_LDCLI_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscCliNombre)
    fv.ID = gDB.ValField(rs.fields, cscCliId)
    fv.Key = KI_CLI_ID
    
    rs.MoveNext
  Wend
  
  pLoadClientes = True
End Function

Private Function pLoadProveedores(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select ListaDescuentoProveedor.*,prov_nombre" & _
            " from ListaDescuentoProveedor, Proveedor" & _
              " where ListaDescuentoProveedor.ld_id = " & m_Id & _
                " and ListaDescuentoProveedor.prov_id = Proveedor.prov_id" & _
              " order by prov_nombre"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadProveedores", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "ldprov_id"
  o.Visible = False
  o.Key = KI_LDPROV_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1151, vbNullString) 'Proveedor
  o.PropertyType = cspHelp
  o.Table = csProveedor
  o.Width = 3500
  o.Key = KI_PROV_ID
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, gDB.ValField(rs.fields, cscLdProvId))
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscLdProvId)
    fv.Key = KI_LDPROV_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscProvNombre)
    fv.ID = gDB.ValField(rs.fields, cscProvId)
    fv.Key = KI_PROV_ID
    
    rs.MoveNext
  Wend
  
  pLoadProveedores = True
End Function

Private Function pSaveItemsProveedores(ByVal Tipo As csEListaDescuentoTipo) As Boolean
  Dim sqlstmt   As String
  Dim register  As cRegister
  Dim IProperty As cIABMProperty
  
  If Tipo = csELDT_Venta Then
  
    sqlstmt = "delete ListaDescuentoProveedor where ld_id = " & m_Id
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsClientes", C_Module) Then Exit Function
  
  Else
    
    For Each IProperty In m_ObjAbm.Properties
      With IProperty
        Select Case .Key
          Case K_PROVEEDORES
          
            Dim Row  As cIABMGridRow
            Dim Cell As cIABMGridCellValue
            
            For Each Row In IProperty.Grid.Rows
            
              Set register = New cRegister
              
              With register
                .fieldId = cscLdProvId
                .Table = csTListaDescuentoProveedor
                .ID = csNew
                
                For Each Cell In Row
                  Select Case Cell.Key
                    
                    Case KI_LDPROV_ID
                      If Not m_Copy Then
                        .ID = Val(Cell.Value)
                      End If
                    
                    Case KI_PROV_ID
                      .fields.Add2 cscProvId, Cell.ID, csId
                  
                  End Select
                Next
                
                .fields.Add2 cscLdId, m_Id, csId
                
                .fields.HaveLastUpdate = True
                .fields.HaveWhoModify = True
              
              End With
              
              If Not gDB.Save(register, , "pSaveItemsProveedores", "provstaDescuento", c_ErrorSave) Then Exit Function
            Next
        End Select
      End With
    Next
    
    If LenB(m_ItemsDeletedProveedores) And Not m_Copy Then
      m_ItemsDeletedProveedores = RemoveLastColon(m_ItemsDeletedProveedores)
      sqlstmt = "delete ListaDescuentoProveedor where ldprov_id in (" & m_ItemsDeletedProveedores & ")"
    
      If Not gDB.Execute(sqlstmt, "pSaveItemsProveedores", C_Module) Then Exit Function
    End If
  End If
  
  pSaveItemsProveedores = True
End Function

Private Function pIsEmptyRowClientes(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CLI_ID
        If Not ValEmpty(Cell.ID, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowClientes = bRowIsEmpty
End Function

Private Function pIsEmptyRowPrecios(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_PRODUCTO
        If Not ValEmpty(Cell.ID, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_DESCUENTO
        If Val(Cell.Value) <> 0 Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_PORCENTAJE
        If Val(Cell.Value) <> 0 Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowPrecios = bRowIsEmpty
End Function

Private Function pIsEmptyRowProveedores(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_PROV_ID
        If Not ValEmpty(Cell.ID, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowProveedores = bRowIsEmpty
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(3074, vbNullString) 'Error al grabar Lista de Descuento
  
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
  Set m_GeneralConfig = Nothing
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

