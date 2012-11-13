VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cListaPrecio"
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
' cListaPrecioEdit
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
Private Const C_Module = "cListaPrecioEdit"

Private Const c_keyProveedores = "Proveedores"
Private Const c_keyClientes = "Clientes"

Private Const c_ListasPadre = "Listas Base"
Private Const c_Precios = "Precios"
Private Const c_Producto = "pr_id"
Private Const c_EditPrecio = "EditPrecio"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHADESDE                     As Integer = 4
Private Const K_FECHAHASTA                     As Integer = 5
Private Const K_DEFAULT                        As Integer = 6
Private Const K_ID_PADRE                       As Integer = 7
Private Const K_PORCENTAJE                     As Integer = 8
Private Const K_ACTIVO                         As Integer = 9
Private Const K_PRECIOS                        As Integer = 10
Private Const K_CLIENTES                       As Integer = 11
Private Const K_PROVEEDORES                    As Integer = 12
Private Const K_TIPO                           As Integer = 13
Private Const K_MON_ID                         As Integer = 14
Private Const K_EDIT_PRECIO                    As Integer = 15
Private Const K_LISTAS_PADRE                   As Integer = 16
Private Const K_PR_ID_FILTER                   As Integer = 17
Private Const K_CMD_PR_FILTER                  As Integer = 18
Private Const K_CLI_ID_FILTER                  As Integer = 19
Private Const K_CMD_CLI_FILTER                 As Integer = 20
Private Const K_AUTOXCOMPRA                    As Integer = 21
Private Const K_NOFILTRARPR                    As Integer = 22
Private Const K_ENCACHE                        As Integer = 23

Private Const KI_PRODUCTO                      As Integer = 1
Private Const KI_PRECIO                        As Integer = 2
Private Const KI_PORCENTAJE                    As Integer = 3
Private Const KI_LPI_ID                        As Integer = 4
Private Const KI_LPM_ID                        As Integer = 500 ' Se usa en dos grillas
Private Const KI_FECHA                         As Integer = 5
Private Const KI_PRECIOH1                      As Integer = 6
Private Const KI_FECHAH1                       As Integer = 7
Private Const KI_PRECIOH2                      As Integer = 8
Private Const KI_FECHAH2                       As Integer = 9
Private Const KI_PRECIOH3                      As Integer = 10
Private Const KI_FECHAH3                       As Integer = 11
Private Const KI_PRECIOH4                      As Integer = 12
Private Const KI_FECHAH4                       As Integer = 13
Private Const KI_PRECIOH5                      As Integer = 14
Private Const KI_FECHAH5                       As Integer = 15

Private Const KI_LPCLI_ID                      As Integer = 1
Private Const KI_CLI_ID                        As Integer = 3

Private Const KI_LPPROV_ID                     As Integer = 1
Private Const KI_PROV_ID                       As Integer = 3

Private Const KI_LPL_ID                        As Integer = 1
Private Const KI_LP_ID_PADRE                   As Integer = 2
Private Const KI_LPL_PORCENTAJE                As Integer = 3

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
Private m_Default                      As Integer
Private m_EnCache                      As Integer
Private m_AutoXCompra                  As Integer
Private m_NoFiltrarPr                  As Integer
Private m_ListaPadre                   As String
Private m_Id_Padre                     As Long
Private m_Porcentaje                   As Currency
Private m_Activo                       As Boolean
Private m_Tipo                         As csEListaPrecioTipo
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
Private m_ItemsDeletedListasPadre As String

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean
Private m_WasChanged        As Boolean
Private m_WasChangedCli     As Boolean

Private m_GeneralConfig     As cGeneralConfig
Private m_VentaConfig       As cVentaConfig

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
  
  With m_ObjAbm.Properties(cscLpCodigo)
    .Value = C_C & .Value
  End With
  
  With m_ObjAbm.Properties(cscLpNombre)
    .Value = C_CopiaDe & .Value
  End With
  
  With m_ObjAbm.Properties(c_EditPrecio)
    .Enabled = False
  End With
  
  With m_ObjAbm
    .ShowValue .Properties.Item(cscLpCodigo)
    .ShowValue .Properties.Item(cscLpNombre)
    .ShowValue .Properties.Item(c_EditPrecio)
  End With
  
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

  Doc.ClientTable = csTListaPrecio
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
  Dim Tipo  As csEListaPrecioTipo

  With m_ObjAbm.Properties
    Select Case Key
      Case K_TIPO
      
        Set iProp = .Item(c_Precios)
        
        Tipo = .Item(cscLpTipo).ListItemData
      
        If Tipo = csELPT_Compra Then
          .Item(c_keyClientes).Enabled = False
          .Item(c_keyProveedores).Enabled = True
          .Item(cscLpAutoXCompra).Enabled = True
          
          iProp.Grid.Columns(c_Producto).Table = csProductoCompra
        
        ElseIf Tipo = csELPT_Costo Then
          .Item(c_keyClientes).Enabled = False
          .Item(c_keyProveedores).Enabled = False
          .Item(cscLpAutoXCompra).Enabled = True
          
          iProp.Grid.Columns(c_Producto).Table = csProducto
        
        Else
          .Item(c_keyClientes).Enabled = True
          .Item(c_keyProveedores).Enabled = False
          .Item(cscLpAutoXCompra).Enabled = False
          
          iProp.Grid.Columns(c_Producto).Table = csProductoVenta
        End If
        
        m_ObjAbm.ShowValue iProp
        m_ObjAbm.ShowValue .Item(c_keyClientes)
        m_ObjAbm.ShowValue .Item(c_keyProveedores)
        m_ObjAbm.ShowValue .Item(cscLpAutoXCompra)
        
        pSetFilterLPBase
        
      Case K_EDIT_PRECIO
        pEditPrecio
        
      Case K_ID_PADRE
        Set iProp = .Item(cscLpPorcentaje)
        iProp.Enabled = .Item(cscLpIdpadre).HelpId <> csNO_ID
        m_ObjAbm.ShowValue iProp
    
      Case K_MON_ID
        pSetFilterLPBase
        
      Case K_CMD_PR_FILTER
        pShowPrecios
    
      Case K_CMD_CLI_FILTER
        pShowClientes
      
      Case K_NOFILTRARPR
        
        Set iProp = .Item(c_Precios)
        
        If Val(.Item(cscLpNoFiltrarPr).Value) Then
          
          iProp.Grid.Columns(c_Producto).Table = csProducto
        
        Else
        
          Tipo = .Item(cscLpTipo).ListItemData
        
          If Tipo = csELPT_Compra Then
            .Item(c_keyClientes).Enabled = False
            .Item(c_keyProveedores).Enabled = True
            .Item(cscLpAutoXCompra).Enabled = True
            
            iProp.Grid.Columns(c_Producto).Table = csProductoCompra
          
          ElseIf Tipo = csELPT_Costo Then
            .Item(c_keyClientes).Enabled = False
            .Item(c_keyProveedores).Enabled = False
            .Item(cscLpAutoXCompra).Enabled = True
            
            iProp.Grid.Columns(c_Producto).Table = csProducto
          
          Else
            .Item(c_keyClientes).Enabled = True
            .Item(c_keyProveedores).Enabled = False
            .Item(cscLpAutoXCompra).Enabled = False
            
            iProp.Grid.Columns(c_Producto).Table = csProductoVenta
          End If
          
        End If
    
        m_ObjAbm.ShowValue iProp
    
    End Select
  End With
End Function

Private Sub pShowPrecios()
  If m_WasChanged Then
    If Not Ask(LNGGetText(3075, vbNullString), vbNo) Then Exit Sub
          'Ud. ha editado precios si continúa perderá estos cambios.;; & _
          Para conservarlos presione el boton 'NO' y luego el boton 'Guardar'.;; & _
          ¿Descarta los cambios?.
  End If
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties.Item(c_Precios)
  pLoadPrecios iProp
  m_ObjAbm.ShowValue iProp
End Sub

Private Sub pShowClientes()
  If m_WasChangedCli Then
    If Not Ask(LNGGetText(3076, vbNullString), vbNo) Then Exit Sub
                'Ud. ha editado clientes si continúa perderá estos cambios.;; & _
                Para conservarlos presione el boton 'NO' y luego el botón 'Guardar'.;; & _
                ¿Descarta los cambios?.
  End If
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties.Item(c_keyClientes)
  pLoadClientes iProp
  m_ObjAbm.ShowValue iProp
End Sub

Private Sub pSetFilterLPBase()
  Dim iProp     As cIABMProperty
  Dim strFilter As String
  
  With m_ObjAbm.Properties
  
    ' Filtro de lista base
    '
    Set iProp = .Item(cscLpIdpadre)
    
    strFilter = "lp_id <> " & m_Id '& " and  mon_id = " & .Item(cscMonId).HelpId
    
    Dim Tipo As csEListaPrecioTipo
    Tipo = .Item(cscLpTipo).ListItemData
    
    If Tipo = csELPT_Compra Then
      strFilter = strFilter & " and lp_tipo = " & csELPT_Compra
    
    ElseIf Tipo = csELPT_Costo Then
      strFilter = strFilter & " and (lp_tipo = " & csELPT_Compra & _
                                " or lp_tipo = " & csELPT_Costo & ")"
    End If
    iProp.HelpFilter = strFilter
    
    m_ObjAbm.ShowValue iProp
    
    Set iProp = m_ObjAbm.Properties.Item(c_ListasPadre)
    iProp.Grid.Columns.Item(cscLpIdpadre).HelpFilter = strFilter
  End With
End Sub

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Dim fields   As cFields
  Dim Tipo     As csEListaPrecioTipo
  Dim LastId   As Long

  Set register = New cRegister
  With register
    Set fields = .fields
    .fieldId = cscLpId
    .Table = csTListaPrecio
  
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
          fields.Add2 cscLpNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscLpCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscLpDescrip, .Value, csText
        Case K_FECHADESDE
          fields.Add2 cscLpFechadesde, .Value, csDate
        Case K_FECHAHASTA
          fields.Add2 cscLpFechahasta, .Value, csDate
        Case K_DEFAULT
          fields.Add2 cscLpDefault, .Value, csBoolean
        Case K_ENCACHE
          fields.Add2 cscLpEnCache, .Value, csBoolean
        Case K_AUTOXCOMPRA
          fields.Add2 cscLpAutoXCompra, .Value, csBoolean
        Case K_NOFILTRARPR
          fields.Add2 cscLpNoFiltrarPr, .Value, csBoolean
        Case K_ID_PADRE
          fields.Add2 cscLpIdpadre, .HelpId, csId
        Case K_PORCENTAJE
          fields.Add2 cscLpPorcentaje, .Value, csCurrency
        Case K_MON_ID
          fields.Add2 cscMonId, .HelpId, csId
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
        Case K_TIPO
          fields.Add2 cscLpTipo, .ListItemData, csInteger
          Tipo = Val(.ListItemData)
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.SaveEx(register, , _
                    cscLpCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.ID
  
  If Not pSaveItemsListasPadre() Then GoTo SaveError
  
  If m_Copy Then
    If Not pSaveItemsCopy(LastId, m_Id) Then GoTo SaveError
  Else
    If Not pSaveItems() Then GoTo SaveError
  End If
  If Not pSaveItemsClientes(Tipo) Then GoTo SaveError
  If Not pSaveItemsProveedores(Tipo) Then GoTo SaveError
    
  If Not register.CommitTrans() Then GoTo SaveError
  
  pUpdateListaPrecioPrecio
  
  pShowDuplicados
  
  m_Copy = False
  cIABMClient_Save = Load(register.ID)

  Exit Function
SaveError:
  m_Id = LastId
End Function

Private Function pSaveItemsCopy(ByVal IdSource As Long, _
                                ByVal IdTarget As Long)
  Dim sqlstmt As String
  sqlstmt = "sp_lpCopiarItems " & IdSource & "," & IdTarget & "," & User.ID
  
  pSaveItemsCopy = gDB.Execute(sqlstmt)
End Function

Private Function pSaveItems() As Boolean
  Dim register    As cRegister
  Dim IProperty   As cIABMProperty
  Dim RowIndex    As Long
  Dim sqlstmt     As String

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_PRECIOS
        
          Dim Row  As cIABMGridRow
          Dim Cell As cIABMGridCellValue
          
          For Each Row In IProperty.Grid.Rows
          
            RowIndex = RowIndex + 1
          
            If Not pValidateRowPrecios(Row, RowIndex) Then Exit Function
            
            Set register = New cRegister
            
            With register
              .fieldId = cscLpiId
              .Table = csTListaPrecioItem
              .ID = csNew
              
              For Each Cell In Row
                Select Case Cell.Key
                  Case KI_LPI_ID
                    If Not m_Copy Then
                      .ID = Val(Cell.Value)
                    End If
                  Case KI_PORCENTAJE
                    .fields.Add2 cscLpiPorcentaje, Val(Cell.Value), csDouble
                  Case KI_PRECIO
                    .fields.Add2 cscLpiPrecio, Val(Cell.Value), csDouble
                  Case KI_PRODUCTO
                    .fields.Add2 cscPrId, Cell.ID, csId
                  Case KI_LPM_ID
                    .fields.Add2 cscLpmId, Cell.ID, csId
                  Case KI_FECHA
                    .fields.Add2 cscLpiFecha, Cell.Value, csDate
                End Select
              Next
            
              .fields.Add2 cscLpId, m_Id, csId
            
              .fields.HaveLastUpdate = True
              .fields.HaveWhoModify = True
                        
            End With
            
            If Not gDB.Save(register, , C_pSaveItemsFunc, C_Module, c_ErrorSave) Then Exit Function
            
            sqlstmt = "sp_ListaPrecioUpdateHistorial " & register.ID
            
            If Not gDB.Execute(sqlstmt) Then Exit Function
            
          Next
      End Select
    End With
  Next
  
  If LenB(m_ItemsDeleted) And Not m_Copy Then
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    sqlstmt = "delete ListaPrecioItem where lpi_id in (" & m_ItemsDeleted & ")"
  
    If Not gDB.Execute(sqlstmt, C_pSaveItemsFunc, C_Module) Then Exit Function
  End If
  
  pSaveItems = True
End Function

Private Function pSaveItemsClientes(ByVal Tipo As csEListaPrecioTipo) As Boolean
  Dim sqlstmt   As String
  Dim register  As cRegister
  
  If Tipo = csELPT_Compra Or Tipo = csELPT_Costo Then
  
    sqlstmt = "delete ListaPrecioCliente where lp_id = " & m_Id
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsClientes", C_Module) Then Exit Function
  
  Else
          
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In m_ObjAbm.Properties.Item(c_keyClientes).Grid.Rows
    
      Set register = New cRegister
      
      With register
        .fieldId = cscLpCliId
        .Table = csTListaPrecioCliente
        .ID = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_LPCLI_ID
              If Not m_Copy Then
                .ID = Val(Cell.Value)
              End If
            
            Case KI_CLI_ID
              .fields.Add2 cscCliId, Cell.ID, csId
          
          End Select
        Next
        
        .fields.Add2 cscLpId, m_Id, csId
        
        .fields.HaveLastUpdate = True
        .fields.HaveWhoModify = True
            
      End With
      
      If Not gDB.Save(register, , "pSaveItemsClientes", C_Module, c_ErrorSave) Then Exit Function
    Next
  
    If LenB(m_ItemsDeletedClientes) And Not m_Copy Then
      m_ItemsDeletedClientes = RemoveLastColon(m_ItemsDeletedClientes)
      sqlstmt = "delete ListaPrecioCliente where lpcli_id in (" & m_ItemsDeletedClientes & ")"
    
      If Not gDB.Execute(sqlstmt, "pSaveItemsClientes", C_Module) Then Exit Function
    End If
  End If
  
  pSaveItemsClientes = True
End Function

Private Function pSaveItemsListasPadre() As Boolean
  Dim sqlstmt   As String
  Dim register  As cRegister
          
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  For Each Row In m_ObjAbm.Properties.Item(c_ListasPadre).Grid.Rows
  
    Set register = New cRegister
    
    With register
      .fieldId = cscLplId
      .Table = csTListaPrecioLista
      .ID = csNew
      
      For Each Cell In Row
        Select Case Cell.Key
          
          Case KI_LPL_ID
            If Not m_Copy Then
              .ID = Val(Cell.Value)
            End If
          
          Case KI_LP_ID_PADRE
            .fields.Add2 cscLpIdpadre, Cell.ID, csId
          
          Case KI_LPM_ID
            .fields.Add2 cscLpmId, Cell.ID, csId
        
          Case KI_LPL_PORCENTAJE
            .fields.Add2 cscLplPorcentaje, Cell.Value, csDouble
        
        End Select
      Next
      
      .fields.Add2 cscLpId, m_Id, csId
      
      .fields.HaveLastUpdate = True
      .fields.HaveWhoModify = True
        
    End With
    
    If Not gDB.Save(register, , "pSaveItemsClientes", C_Module, c_ErrorSave) Then Exit Function
  Next
  
  If LenB(m_ItemsDeletedListasPadre) And Not m_Copy Then
    m_ItemsDeletedListasPadre = RemoveLastColon(m_ItemsDeletedListasPadre)
    sqlstmt = "delete ListaPrecioLista where lpl_id in (" & m_ItemsDeletedListasPadre & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsListasPadre", C_Module) Then Exit Function
  End If
  
  Dim rs As Recordset
  sqlstmt = "sp_ListaPrecioValidate " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  If rs.fields.Item(0).Value = 0 Then
    Dim msg As String
    Set rs = rs.NextRecordset
    If rs Is Nothing Then Exit Function
    msg = LNGGetText(3077, vbNullString)
          'Las siguientes Listas generan referencias cruzadas que no están permitidas;
    While Not rs.EOF
      msg = msg & ";" & rs.fields.Item(0).Value
      rs.MoveNext
    Wend
    MsgWarning msg
    Exit Function
  End If
  
  pSaveItemsListasPadre = True
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
    cIABMClient_Title = LNGGetText(3078, vbNullString) 'Listas de Precios
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
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            .Value = c_get_codigo_from_id
          End If
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
            MsgInfo LNGGetText(1113, vbNullString) 'Debe indicar una moneda
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
  Select Case Key
    Case K_PRECIOS
      m_WasChanged = True
    Case K_CLIENTES
      m_WasChangedCli = True
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
  Dim ID As Long
  
  Select Case Key
  
    Case K_LISTAS_PADRE
      ID = Val(pCell(Row, KI_LPL_ID).Value)
      If ID <> csNO_ID Then m_ItemsDeletedListasPadre = m_ItemsDeletedListasPadre & ID & C_StrColon
  
    Case K_PRECIOS
      ID = Val(pCell(Row, KI_LPI_ID).Value)
      If ID <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & ID & C_StrColon
    
    Case K_CLIENTES
      ID = Val(pCell(Row, KI_LPCLI_ID).Value)
      If ID <> csNO_ID Then m_ItemsDeletedClientes = m_ItemsDeletedClientes & ID & C_StrColon
    
    Case K_PROVEEDORES
      ID = Val(pCell(Row, KI_LPPROV_ID).Value)
      If ID <> csNO_ID Then m_ItemsDeletedProveedores = m_ItemsDeletedProveedores & ID & C_StrColon
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_LISTAS_PADRE
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowListasPadre(Row, RowIndex)
    Case K_PRECIOS
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

Private Function pValidateRowPrecios(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
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
      Case KI_PRECIO
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
      Case KI_LPM_ID
        If Cell.ID <> csNO_ID Then
          EmptyPriceAndPercent = False
        End If
    End Select
  Next
  
  If EmptyPriceAndPercent Then
    MsgWarning LNGGetText(3079, vbNullString, strRow)
                'Debe indicar un Precio ó un Porcentaje (1)
    Exit Function
  End If

  pValidateRowPrecios = True

End Function

Private Function pValidateRowListasPadre(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_LP_ID_PADRE
        If Cell.ID = csNO_ID Then
          MsgWarning LNGGetText(3080, vbNullString, strRow)
                      'Debe indicar una Lista de Precios (1)
          Exit Function
        Else
          If Not pValidateLpBase(Cell.ID, Cell.Value) Then Exit Function
        End If
    End Select
  Next
  
  pValidateRowListasPadre = True
End Function

Private Function pValidateLpBase(ByVal lp_id As Long, ByVal lp_nombre As String) As Boolean
  Dim rs As Recordset
  Dim sqlstmt As String
  Dim strCompras As String
  
  sqlstmt = "select lp_id from ListaPrecio where lp_id = " & lp_id & _
            " and lp_id <> " & m_Id '& " and mon_id = " & m_ObjAbm.Properties.Item(cscMonId).HelpId
  
  If m_Tipo = csELPT_Compra Then
    
    sqlstmt = sqlstmt & " and lp_tipo = " & csELPT_Compra
    strCompras = LNGGetText(3081, vbNullString) ';;La lista debe ser  de Compras
  
  ElseIf m_Tipo = csELPT_Costo Then
  
    sqlstmt = sqlstmt & " and (lp_tipo = " & csELPT_Compra & _
                          " or lp_tipo = " & csELPT_Costo & ")"
    strCompras = LNGGetText(3082, vbNullString)  ';;La lista debe ser  de Compras o Costos.
  End If

  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then
    MsgWarning LNGGetText(3083, vbNullString, lp_nombre, strCompras)
              'La lista de precios  & lp_nombre &  no es válida. & strCompras
    Exit Function
  End If
  
  pValidateLpBase = True
End Function

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_LISTAS_PADRE
      cIABMClientGrid_ValidateRow = pValidateRowListasPadre(Row, RowIndex)
    Case K_PRECIOS
      cIABMClientGrid_ValidateRow = pValidateRowPrecios(Row, RowIndex)
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListListaPrecio)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(ID As Long) As Boolean
    If Not SecurityCanAccess(csPreGDeleteListaPrecio) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "sp_listaPrecioDelete " & ID
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If ID = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewListaPrecio) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditListaPrecio) Then Exit Function
  End If

' JMA I
  m_ObjAbm.InModalWindow = InModalWindow
' JMA F

  If Not Load(ID) Then Exit Function
  
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
  m_Host.Server.AddMenu LNGGetText(3078, vbNullString), csPreGListListaPrecio, C_MenuArticulos, 0, True, False, False, False, False, Me
                        '&Listas de Precios
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  m_Host.MenuABMClick "CSArticulo.cListaPrecio", Me, LNGGetText(3078, vbNullString), 0, csETablasGeneral.csListaPrecio
                                                    'Listas de Precios
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 6400
  
  Dim iProp As cABMProperty
  Dim c As cIABMProperty
      
  With m_ObjAbm.Tabs
   
    .Clear
      
    With .Add(Nothing)
      .Index = 0
      .Name = C_strGeneral
    End With
    
    With .Add(Nothing)
      .Index = 1
      .Name = c_ListasPadre
    End With
    
    With .Add(Nothing)
      .Index = 2
      .Name = c_Precios
    End With
    
    With .Add(Nothing)
      .Index = 3
      .Name = LNGGetText(1303, vbNullString)  'Clientes
    End With
  
    With .Add(Nothing)
      .Index = 4
      .Name = LNGGetText(1302, vbNullString)  'Proveedores
    End With
  
  End With
  
  m_ObjAbm.Properties.Clear
  m_ObjAbm.Title2 = m_Nombre
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscLpNombre)
  c.PropertyType = cspText
  c.Name = C_strNombre
  c.Size = 100
  c.Key = K_NOMBRE
  c.Value = m_Nombre
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscLpCodigo)
  c.PropertyType = cspText
  c.Name = C_strCodigo
  c.Size = 15
  c.Key = K_CODIGO
  c.Value = m_Codigo
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscLpFechadesde)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1203, vbNullString) 'Fecha Desde
  c.Key = K_FECHADESDE
  c.Value = m_FechaDesde
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscLpFechahasta)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1204, vbNullString) 'Fecha Hasta
  c.Key = K_FECHAHASTA
  c.Value = m_FechaHasta
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscLpDefault)
  c.PropertyType = cspCheck
  c.Name = LNGGetText(3085, vbNullString) 'Lista por Defecto
  c.Key = K_DEFAULT
  c.Value = m_Default
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscLpEnCache)
  c.PropertyType = cspCheck
  c.Name = LNGGetText(3599, vbNullString) 'Incluida en el Cache
  c.Key = K_ENCACHE
  c.Value = m_EnCache
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscLpAutoXCompra)
  c.PropertyType = cspCheck
  c.Name = LNGGetText(3086, vbNullString) 'Automática X Compras/Ventas
  c.Key = K_AUTOXCOMPRA
  c.Value = m_AutoXCompra
  
  Set c = m_ObjAbm.Properties.Add(Nothing, m_Activo)
  c.PropertyType = cspCheck
  c.TopFromProperty = cscLpDefault
  c.Left = 3000
  c.LeftLabel = -800
  c.Name = C_strActivo
  c.Key = K_ACTIVO
  c.Value = CInt(m_Activo)
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscMonId)
  c.PropertyType = cspHelp
  c.TopFromProperty = cscLpNombre
  c.Left = 5500
  c.Table = csMoneda
  c.Name = LNGGetText(1113, vbNullString) 'Moneda
  c.Key = K_MON_ID
  c.Value = m_Moneda
  c.HelpId = m_mon_id
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscLpIdpadre)
  c.PropertyType = cspHelp
  c.Table = csListaPrecio
  c.Name = LNGGetText(3087, vbNullString) 'Lista de Precios Base
  c.Key = K_ID_PADRE
  c.Value = m_ListaPadre
  c.HelpFilter = "lp_id <> " & m_Id & " and mon_id = " & m_mon_id
  If m_Tipo = csELPT_Compra Then
    c.HelpFilter = c.HelpFilter & " and lp_tipo = " & csELPT_Compra
  ElseIf m_Tipo = csELPT_Costo Then
    c.HelpFilter = c.HelpFilter & " and (lp_tipo = " & csELPT_Compra & _
                                    " or lp_tipo = " & csELPT_Costo & ")"
  End If
  c.HelpId = m_Id_Padre
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscLpPorcentaje)
  c.PropertyType = cspNumeric
  c.SubType = cspPercent
  c.Name = LNGGetText(3073, vbNullString) 'Porcentaje s/base
  c.Key = K_PORCENTAJE
  c.Enabled = m_Id_Padre <> csNO_ID
  c.Value = m_Porcentaje
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscLpTipo)
  c.PropertyType = cspList
    With c.List.Add(Nothing)
      .ID = csELPT_Compra
      .Value = LNGGetText(1058, vbNullString) 'Compra
    End With
    With c.List.Add(Nothing)
      .ID = csELPT_Venta
      .Value = LNGGetText(1059, vbNullString) 'Venta
    End With
    With c.List.Add(Nothing)
      .ID = csELPT_Costo
      .Value = LNGGetText(3088, vbNullString) 'Costo
    End With
  c.ListWhoSetItem = csListItemData
  c.Name = LNGGetText(1223, vbNullString) 'Tipo
  c.Key = K_TIPO
  c.ListItemData = m_Tipo
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_EditPrecio)
  c.PropertyType = cspButton
  c.Width = 1200
  c.LeftLabel = -1
  c.Name = "Editar Precios"
  c.Enabled = m_Id <> csNO_ID
  c.Key = K_EDIT_PRECIO
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscLpDescrip)
  c.PropertyType = cspText
  c.Name = C_strDescrip
  c.Size = 5000
  c.TopFromProperty = cscLpAutoXCompra
  c.TopToPrevious = 440
  c.Height = 780
  c.Width = 6250
  c.SubType = cspMemo
  c.LeftFromProperty = cscLpNombre
  c.Key = K_DESCRIP
  c.Value = m_Descrip
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_ListasPadre)
  c.PropertyType = cspGrid
  If Not pLoadListasPadre(c) Then Exit Function
  c.Name = "Listas Base"
  c.Key = K_LISTAS_PADRE
  c.LeftLabel = -1
  c.TabIndex = 1
  c.GridAdd = True
  c.GridEdit = True
  c.GridRemove = True
  
  m_ItemsDeletedListasPadre = vbNullString
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPrId)
  c.Name = LNGGetText(3089, vbNullString) 'Productos
  c.PropertyType = cspText
  c.TabIndex = 2
  Set iProp = c
  iProp.IsEditProperty = False
  c.Key = K_PR_ID_FILTER
    
  Set c = m_ObjAbm.Properties.Add(Nothing, "cmdFilter")
  c.PropertyType = cspButton
  c.TopFromProperty = cscPrId
  c.Left = 4000
  c.LeftNotChange = True
  c.TopNotChange = True
  c.LeftLabel = -1
  c.Name = "Filtrar"
  c.TabIndex = 2
  c.Key = K_CMD_PR_FILTER
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscLpNoFiltrarPr)
  c.PropertyType = cspCheck
  c.TopFromProperty = cscPrId
  c.Left = 7000
  c.LeftNotChange = True
  c.TopNotChange = True
  c.Name = LNGGetText(3090, vbNullString) 'No filtrar x vta.
  c.Key = K_NOFILTRARPR
  c.Value = m_NoFiltrarPr
  c.TabIndex = 2
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_Precios)
  c.PropertyType = cspGrid
  If Not pLoadPrecios(c) Then Exit Function
  c.Name = c_Precios
  c.Key = K_PRECIOS
  c.LeftLabel = -1
  c.Left = 400
  c.TopFromProperty = cscPrId
  c.TopToPrevious = 440
  c.Height = 5000
  c.TabIndex = 2
  c.GridAdd = True
  c.GridEdit = True
  c.GridRemove = True
  
  m_ItemsDeleted = vbNullString
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCliId)
  c.Name = LNGGetText(1150, vbNullString) 'Cliente
  c.PropertyType = cspText
  c.TabIndex = 3
  Set iProp = c
  iProp.IsEditProperty = False
  c.Left = 1200
  c.LeftLabel = -800
  c.Key = K_CLI_ID_FILTER
  
  Set c = m_ObjAbm.Properties.Add(Nothing, "cmdCliFilter")
  c.PropertyType = cspButton
  c.TopFromProperty = cscCliId
  c.Left = 4000
  c.LeftNotChange = True
  c.TopNotChange = True
  c.LeftLabel = -1
  c.Name = "Filtrar"
  c.TabIndex = 3
  c.Key = K_CMD_CLI_FILTER
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_keyClientes)
  c.PropertyType = cspGrid
  If Not pLoadClientes(c) Then Exit Function
  c.Name = "Clientes"
  c.Key = K_CLIENTES
  c.LeftLabel = -1
  c.Left = 400
  c.TopFromProperty = cscCliId
  c.TopToPrevious = 440
  c.Height = 5000
  c.TabIndex = 3
  c.GridAdd = True
  c.GridEdit = True
  c.GridRemove = True
  c.Enabled = m_Tipo = csELPT_Venta
  
  m_ItemsDeletedClientes = vbNullString
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_keyProveedores)
  c.PropertyType = cspGrid
  If Not pLoadProveedores(c) Then Exit Function
  c.Name = "Proveedores"
  c.Key = K_PROVEEDORES
  c.LeftLabel = -1
  c.TabIndex = 4
  c.GridAdd = True
  c.GridEdit = True
  c.GridRemove = True
  c.Enabled = m_Tipo = csELPT_Compra
  
  m_ItemsDeletedProveedores = vbNullString
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal ID As Long) As Boolean
  Dim sqlstmt As String
  Dim rs As Recordset

  sqlstmt = "sp_ListaPrecioGet " & ID

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscLpId)
    m_Nombre = gDB.ValField(rs.fields, cscLpNombre)
    m_Codigo = gDB.ValField(rs.fields, cscLpCodigo)
    m_Descrip = gDB.ValField(rs.fields, cscLpDescrip)
    m_FechaDesde = gDB.ValField(rs.fields, cscLpFechadesde)
    m_FechaHasta = gDB.ValField(rs.fields, cscLpFechahasta)
    m_Default = gDB.ValField(rs.fields, cscLpDefault)
    m_EnCache = gDB.ValField(rs.fields, cscLpEnCache)
    m_AutoXCompra = gDB.ValField(rs.fields, cscLpAutoXCompra)
    m_NoFiltrarPr = gDB.ValField(rs.fields, cscLpNoFiltrarPr)
    m_Id_Padre = gDB.ValField(rs.fields, cscLpIdpadre)
    m_ListaPadre = gDB.ValField(rs.fields, "Padre")
    m_Porcentaje = gDB.ValField(rs.fields, cscLpPorcentaje)
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_Tipo = gDB.ValField(rs.fields, cscLpTipo)
    m_mon_id = gDB.ValField(rs.fields, cscMonId)
    m_Moneda = gDB.ValField(rs.fields, cscMonNombre)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Descrip = vbNullString
    m_FechaDesde = Date
    m_FechaHasta = VDGetDateById(csMonthNext_LastDay)
    m_Default = 0
    m_EnCache = 0
    m_AutoXCompra = 0
    m_NoFiltrarPr = 0
    m_Id_Padre = csNO_ID
    m_ListaPadre = vbNullString
    m_Porcentaje = 0
    m_Activo = True
    m_Tipo = csELPT_Venta
    m_mon_id = csNO_ID
    m_Moneda = vbNullString
  End If

  Load = True
End Function

Private Function pLoadPrecios(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  Dim fecha As Date
  Dim precio As Double
  
  m_WasChanged = False
  
  With m_ObjAbm.Properties
    sqlstmt = "sp_listaPrecioGetPrecios " _
                      & m_Id & "," _
                      & .Item(cscLpTipo).ListItemData & "," _
                      & gDB.sqlString(.Item(cscPrId).Value)
  End With
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadPrecios", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Name = "lpi_id"
        .Visible = False
        .Key = KI_LPI_ID
      End With
      
      With .Add(Nothing, c_Producto)
        .Name = LNGGetText(1367, vbNullString) 'Articulo
        .PropertyType = cspHelp
        If m_Tipo = csELPT_Compra Then
          .Table = csProductoCompra
        ElseIf m_Tipo = csELPT_Costo Then
          .Table = csProducto
        Else
          If m_NoFiltrarPr Then
            .Table = csProducto
          Else
            .Table = csProductoVenta
          End If
        End If
        .Width = 3500
        .Key = KI_PRODUCTO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1586, vbNullString) 'Precio
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = "0.000;-0.000"
        .Width = 1200
        .Key = KI_PRECIO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1105, vbNullString) 'Porcentaje
        .PropertyType = cspNumeric
        .SubType = cspPercent
        .Width = 1200
        .Key = KI_PORCENTAJE
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(3519, vbNullString) 'Tabla de Marcado
        .PropertyType = cspHelp
        .Table = csListaPrecioMarcado
        .Width = 1200
        .Key = KI_LPM_ID
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1569, vbNullString) 'Fecha
        .PropertyType = cspDate
        .Width = 1200
        .Key = KI_FECHA
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(4987, vbNullString) 'Fecha 1
        .PropertyType = cspDate
        .Width = 1200
        .Key = KI_FECHAH1
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(4992, vbNullString) 'Historico 1
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = "0.000;-0.000"
        .Width = 1200
        .Key = KI_PRECIOH1
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(4988, vbNullString) 'Fecha 2
        .PropertyType = cspDate
        .Width = 1200
        .Key = KI_FECHAH2
        .Enabled = False
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(4993, vbNullString) 'Historico 2
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = "0.000;-0.000"
        .Width = 1200
        .Key = KI_PRECIOH2
        .Enabled = False
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(4989, vbNullString) 'Fecha 3
        .PropertyType = cspDate
        .Width = 1200
        .Key = KI_FECHAH3
        .Enabled = False
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(4994, vbNullString) 'Historico 3
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = "0.000;-0.000"
        .Width = 1200
        .Key = KI_PRECIOH3
        .Enabled = False
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(4990, vbNullString) 'Fecha 4
        .PropertyType = cspDate
        .Width = 1200
        .Key = KI_FECHAH4
        .Enabled = False
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(4995, vbNullString) 'Historico 4
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = "0.000;-0.000"
        .Width = 1200
        .Key = KI_PRECIOH4
        .Enabled = False
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(4991, vbNullString) 'Fecha 5
        .PropertyType = cspDate
        .Width = 1200
        .Key = KI_FECHAH5
        .Enabled = False
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(4996, vbNullString) 'Historico 5
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = "0.000;-0.000"
        .Width = 1200
        .Key = KI_PRECIOH5
        .Enabled = False
      End With
    
    End With
      
    With .Rows
    
      .Clear
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscLpiId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscLpiId).Value
            .Key = KI_LPI_ID
          End With
          
          With .Add(Nothing)
            .Value = rs("pr_nombre").Value
            .ID = rs(cscPrId).Value
            .Key = KI_PRODUCTO
          End With
          
          With .Add(Nothing)
            .Value = rs(cscLpiPrecio).Value
            .Key = KI_PRECIO
          End With
          
          With .Add(Nothing)
            .Value = rs(cscLpiPorcentaje).Value
            .Key = KI_PORCENTAJE
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscLpmNombre)
            .ID = gDB.ValField(rs.fields, cscLpmId)
            .Key = KI_LPM_ID
          End With
        
          fecha = gDB.ValField(rs.fields, cscLpiFecha)
        
          With .Add(Nothing)
            If fecha <> csNoDate Then
              .Value = fecha
            End If
            .Key = KI_FECHA
          End With
        
          fecha = gDB.ValField(rs.fields, cscLpiFechah1)
        
          With .Add(Nothing)
            If fecha <> csNoDate Then
              .Value = fecha
            End If
            .Key = KI_FECHAH1
          End With
        
          precio = gDB.ValField(rs.fields, cscLpiPrecioh1)
        
          With .Add(Nothing)
            If fecha <> csNoDate Then
              .Value = precio
            End If
            .Key = KI_PRECIOH1
          End With
        
          fecha = gDB.ValField(rs.fields, cscLpiFechah2)
        
          With .Add(Nothing)
            If fecha <> csNoDate Then
              .Value = fecha
            End If
            .Key = KI_FECHAH2
          End With
        
          precio = gDB.ValField(rs.fields, cscLpiPrecioh2)
        
          With .Add(Nothing)
            If fecha <> csNoDate Then
              .Value = precio
            End If
            .Key = KI_PRECIOH2
          End With
        
          fecha = gDB.ValField(rs.fields, cscLpiFechah3)
        
          With .Add(Nothing)
            If fecha <> csNoDate Then
              .Value = fecha
            End If
            .Key = KI_FECHAH3
          End With
        
          precio = gDB.ValField(rs.fields, cscLpiPrecioh3)
        
          With .Add(Nothing)
            If fecha <> csNoDate Then
              .Value = precio
            End If
            .Key = KI_PRECIOH3
          End With
        
          fecha = gDB.ValField(rs.fields, cscLpiFechah4)
        
          With .Add(Nothing)
            If fecha <> csNoDate Then
              .Value = fecha
            End If
            .Key = KI_FECHAH4
          End With
        
          precio = gDB.ValField(rs.fields, cscLpiPrecioh4)
        
          With .Add(Nothing)
            If fecha <> csNoDate Then
              .Value = precio
            End If
            .Key = KI_PRECIOH4
          End With
        
          fecha = gDB.ValField(rs.fields, cscLpiFechah5)
        
          With .Add(Nothing)
            If fecha <> csNoDate Then
              .Value = fecha
            End If
            .Key = KI_FECHAH5
          End With
        
          precio = gDB.ValField(rs.fields, cscLpiPrecioh5)
        
          With .Add(Nothing)
            If fecha <> csNoDate Then
              .Value = precio
            End If
            .Key = KI_PRECIOH5
          End With
        
        End With
        
        rs.MoveNext
      Wend
    
    End With
  End With
  
  pLoadPrecios = True
End Function

Private Function pLoadListasPadre(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select lpl.*, lp_nombre, lpm_nombre" & _
            " from ListaPrecioLista lpl inner join ListaPrecio lp on lpl.lp_id_padre = lp.lp_id" & _
                                      " left  join ListaPrecioMarcado lpm on lpl.lpm_id = lpm.lpm_id" & _
              " where lpl.lp_id = " & m_Id & _
              " order by lp_nombre"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadListasPadre", C_Module) Then Exit Function
    
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
    
      With .Add(Nothing)
        .Name = "lpl_id"
        .Visible = False
        .Key = KI_LPL_ID
      End With
      
      With .Add(Nothing, cscLpIdpadre)
        .Name = LNGGetText(3091, vbNullString) 'Lista Base
        .PropertyType = cspHelp
        .Table = csListaPrecio
        .Width = 3500
        .HelpFilter = "lp_id <> " & m_Id '& " and mon_id = " & m_mon_id
        If m_Tipo = csELPT_Compra Then
          .HelpFilter = .HelpFilter & " and lp_tipo = " & csELPT_Compra
        ElseIf m_Tipo = csELPT_Compra Then
          .HelpFilter = .HelpFilter & " and (lp_tipo = " & csELPT_Compra & _
                                        " or lp_tipo = " & csELPT_Costo & ")"
        End If
        .Key = KI_LP_ID_PADRE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1105, vbNullString) 'Porcentaje
        .PropertyType = cspNumeric
        .SubType = cspPercent
        .Width = 1200
        .Key = KI_LPL_PORCENTAJE
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(3519, vbNullString) 'Tabla de Marcado
        .PropertyType = cspHelp
        .Table = csListaPrecioMarcado
        .Width = 1200
        .Key = KI_LPM_ID
      End With
    
    End With
    
    With .Rows
      
      .Clear
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscLplId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscLplId).Value
            .Key = KI_LPL_ID
          End With
          
          With .Add(Nothing)
            .Value = rs(cscLpNombre).Value
            .ID = rs(cscLpIdpadre).Value
            .Key = KI_LP_ID_PADRE
          End With
          
          With .Add(Nothing)
            .Value = rs(cscLplPorcentaje).Value
            .Key = KI_LPL_PORCENTAJE
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscLpmNombre)
            .ID = gDB.ValField(rs.fields, cscLpmId)
            .Key = KI_LPM_ID
          End With
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadListasPadre = True
End Function

Private Function pLoadClientes(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
'  sqlstmt = "select ListaPrecioCliente.*,cli_nombre"
'  sqlstmt = sqlstmt & " from ListaPrecioCliente, cliente"
'  sqlstmt = sqlstmt & " where ListaPrecioCliente.lp_id = " & m_Id
'  sqlstmt = sqlstmt & " and ListaPrecioCliente.cli_id = cliente.cli_id"
  
  m_WasChangedCli = False
  
  With m_ObjAbm.Properties
    sqlstmt = "sp_listaPrecioGetClientes " & m_Id & "," & gDB.sqlString(.Item(cscCliId).Value)
  End With
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadClientes", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Propiedad.Grid.Columns.Clear
  Propiedad.Grid.Rows.Clear
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "lpcli_id"
  o.Visible = False
  o.Key = KI_LPCLI_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1150, vbNullString) 'Cliente
  o.PropertyType = cspHelp
  o.Table = csCliente
  o.Width = 3500
  o.Key = KI_CLI_ID
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, gDB.ValField(rs.fields, cscLpCliId))
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscLpCliId)
    fv.Key = KI_LPCLI_ID
    
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
  
  sqlstmt = "select ListaPrecioProveedor.*,prov_nombre" & _
            " from ListaPrecioProveedor, Proveedor" & _
              " where ListaPrecioProveedor.lp_id = " & m_Id & _
                " and ListaPrecioProveedor.prov_id = Proveedor.prov_id" & _
              " order by prov_nombre"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadProveedores", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "lpprov_id"
  o.Visible = False
  o.Key = KI_LPPROV_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1151, vbNullString) 'Proveedor
  o.PropertyType = cspHelp
  o.Table = csProveedor
  o.Width = 3500
  o.Key = KI_PROV_ID
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, gDB.ValField(rs.fields, cscLpProvId))
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscLpProvId)
    fv.Key = KI_LPPROV_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscProvNombre)
    fv.ID = gDB.ValField(rs.fields, cscProvId)
    fv.Key = KI_PROV_ID
    
    rs.MoveNext
  Wend
  
  pLoadProveedores = True
End Function

Private Function pSaveItemsProveedores(ByVal Tipo As csEListaPrecioTipo) As Boolean
  Dim sqlstmt   As String
  Dim register  As cRegister
  Dim IProperty As cIABMProperty
  
  If Tipo = csELPT_Venta Or Tipo = csELPT_Costo Then
  
    sqlstmt = "delete ListaPrecioProveedor where lp_id = " & m_Id
  
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
                .fieldId = cscLpProvId
                .Table = csTListaPrecioProveedor
                .ID = csNew
                
                For Each Cell In Row
                  Select Case Cell.Key
                    
                    Case KI_LPPROV_ID
                      If Not m_Copy Then
                        .ID = Val(Cell.Value)
                      End If
                    
                    Case KI_PROV_ID
                      .fields.Add2 cscProvId, Cell.ID, csId
                  
                  End Select
                Next
                
                .fields.Add2 cscLpId, m_Id, csId
                
                .fields.HaveLastUpdate = True
                .fields.HaveWhoModify = True
                            
              End With
              
              If Not gDB.Save(register, , "pSaveItemsProveedores", "provstaPrecio", c_ErrorSave) Then Exit Function
            Next
        End Select
      End With
    Next
    
    If LenB(m_ItemsDeletedProveedores) And Not m_Copy Then
      m_ItemsDeletedProveedores = RemoveLastColon(m_ItemsDeletedProveedores)
      sqlstmt = "delete ListaPrecioProveedor where lpprov_id in (" & m_ItemsDeletedProveedores & ")"
    
      If Not gDB.Execute(sqlstmt, "pSaveItemsProveedores", C_Module) Then Exit Function
    End If
  End If
  
  pSaveItemsProveedores = True
End Function

Private Function pIsEmptyRowClientes(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
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
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_PRODUCTO
        If Not ValEmpty(Cell.ID, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_PRECIO
        If Val(Cell.Value) <> 0 Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_PORCENTAJE
        If Val(Cell.Value) <> 0 Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_LPM_ID
        If Not ValEmpty(Cell.ID, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowPrecios = bRowIsEmpty
End Function

Private Function pIsEmptyRowListasPadre(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_LP_ID_PADRE
        If Not ValEmpty(Cell.ID, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_LPL_PORCENTAJE
        If Not ValEmpty(Cell.Value, csDouble) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowListasPadre = bRowIsEmpty
End Function

Private Function pIsEmptyRowProveedores(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
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

Private Sub pEditPrecio()
  Dim objEdit As Object
  Set objEdit = CSKernelClient2.CreateObject("CSEditPrecio2.cEditPrecio")
  If Not objEdit.Edit(m_Id, gDB) Then Exit Sub
  
  Dim c      As cIABMProperty
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  Set c = m_ObjAbm.Properties(c_Precios)
  
  If Not pLoadPrecios(c) Then Exit Sub
  AbmObj.ShowValue c, False
End Sub

Private Sub pUpdateListaPrecioPrecio()
  
  If Not m_VentaConfig.UsarListaPrecioPrecio Then Exit Sub
  
  If Ask(LNGGetText(3598, vbNullString), vbYes) Then
  
    Dim sqlstmt     As String
    Dim oldTimeOut  As Long
    
    sqlstmt = "sp_listaPrecioUpdateCache " & m_Id
    oldTimeOut = gDB.CommandTimeout
    gDB.CommandTimeout = 10800
    gDB.OpenRsEX True, False, True, sqlstmt, Nothing
    gDB.CommandTimeout = oldTimeOut
  End If
  
End Sub

Private Sub pShowDuplicados()
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_ListaPrecioShowDuplicados " & m_Id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  If rs.fields(0).Value Then
  
    ShowInfo LNGGetText(4920, vbNullString), _
             "sp_ListaPrecioShowDuplicadosDetalle " & m_Id
  End If
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(3092, vbNullString) 'Error al grabar la lista de precios
  
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load

  Set m_VentaConfig = New cVentaConfig
  m_VentaConfig.Load

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
  Set m_VentaConfig = Nothing
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
