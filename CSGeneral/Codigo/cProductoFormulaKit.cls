VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProductoFormulaKit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cProductoFormulaKit
' 12-08-2006

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes

Private Const C_Module = "cProductoFormulaKit"

Private Const c_Items = "Items"

' pSeudo-constante
Private c_colAlt As Integer

Private Const K_NOMBRE         As Integer = 1
Private Const K_CODIGO         As Integer = 2
Private Const K_ACTIVO         As Integer = 3
Private Const K_DEFAULT        As Integer = 4
Private Const K_PR_ID          As Integer = 5
Private Const K_DESCRIP        As Integer = 6
Private Const K_ITEMS          As Integer = 7
Private Const K_PR_ID_SERIE    As Integer = 8
Private Const K_PR_ID_LOTE     As Integer = 9

Private Const KIK_PRK_ID                       As Integer = 1
Private Const KIK_PRK_CANTIDAD                 As Integer = 2
Private Const KIK_PR_ID_ITEM                   As Integer = 3
Private Const KIK_PRK_VARIABLE                 As Integer = 4
Private Const KIK_PRK_ALT                      As Integer = 5

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                As Long
Private m_Nombre            As String
Private m_Codigo            As String
Private m_Default           As Boolean
Private m_Activo            As Boolean
Private m_Pr_id             As Long
Private m_Producto          As String
Private m_descrip           As String
Private m_bEditable         As Boolean

Private m_pr_id_serie       As Long
Private m_ProductoSerie     As String
Private m_pr_id_lote        As Long
Private m_ProductoLote      As String

Private m_Editing          As Boolean

Private m_ObjAbm           As cIABMGeneric
Private m_ObjTree          As Object

Private m_IsNew            As Boolean

Private m_BranchId         As Long
Private m_TreeId           As Long

Private m_Host              As cIMenuHost
Private m_Copy              As Boolean

Private m_ItemsDeleted      As String

' Para contener las alternativas
'
Private m_CollAlts          As Collection

' propiedades publicas

Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property

' propiedades privadas
' funciones publicas
' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm
  
    With .Properties.Item(cscPrfkCodigo)
      .Value = C_C & .Value
    End With
    
'    With .Properties.Item(cscPrfkNombre)
'      .Value = C_CopiaDe & .Value
'    End With
  
    With .Properties.Item(cscPrId)
      .Enabled = True
    End With
    
    With .Properties.Item(c_Items)
      .Enabled = True
    End With
  
    .ShowValue .Properties(cscPrfkCodigo)
    .ShowValue .Properties(cscPrfkNombre)
    .ShowValue .Properties(cscPrId)
    .ShowValue .Properties(c_Items)
    
  End With
  
  m_bEditable = True
  
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

  Doc.ClientTable = csTProductoFormulaKit
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

Private Function cIABMClient_ListAdHock(Lista As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  
  Select Case Key
    Case K_PR_ID
      Dim Pr_id         As Long
      Dim bNeedLote     As Boolean
      Dim bNeedSerie    As Boolean
      
      With m_ObjAbm.Properties
      
        Pr_id = .Item(cscPrId).HelpId
        If Pr_id <> csNO_ID Then
          If Not pProductoGetSerieLote(Pr_id, bNeedLote, bNeedSerie) Then Exit Function
        End If
        
        Dim iProp    As cIABMProperty
        
        Set iProp = .Item(cscPrIdSerie)
        iProp.Enabled = bNeedSerie
        m_ObjAbm.ShowValue iProp
        
        Set iProp = .Item(cscPrIdLote)
        iProp.Enabled = bNeedLote
        m_ObjAbm.ShowValue iProp
          
      End With
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  Dim LastId      As Long
  Dim Pr_id       As Long
  Dim bDefault    As Boolean
  Dim register    As cRegister
  Dim fields      As cFields
  
  Set register = New cRegister
  
  With register
    Set fields = .fields
    .fieldId = cscPrfkId
    .Table = csTProductoFormulaKit
  
    If m_Copy Then
      .Id = csNew
    Else
      .Id = m_Id
    End If
  End With
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          fields.Add2 cscPrfkNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscPrfkCodigo, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, Val(.Value), csBoolean
        Case K_DEFAULT
          bDefault = Val(.Value)
          fields.Add2 cscPrfkDefault, bDefault, csBoolean
        Case K_DESCRIP
          fields.Add2 cscPrfkDescrip, .Value, csText
        Case K_PR_ID
          Pr_id = .HelpId
          fields.Add2 cscPrId, Pr_id, csId
        Case K_PR_ID_SERIE
          fields.Add2 cscPrIdSerie, .HelpId, csId
        Case K_PR_ID_LOTE
          fields.Add2 cscPrIdLote, .HelpId, csId
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not pSaveDefault(bDefault, Pr_id) Then Exit Function
                                                            
  If Not gDB.SaveEx(register, , _
                    cscPrfkCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.Id
  
  If Not pSaveItems() Then GoTo SaveError
  
  If Not register.CommitTrans() Then GoTo SaveError
  
  m_Copy = False
  cIABMClient_Save = Load(register.Id)

  Exit Function
SaveError:
  m_Id = LastId
End Function

Private Function pSaveDefault(ByVal bDefault As Boolean, _
                              ByVal Pr_id As Long) As Boolean
  Dim sqlstmt As String
  
  If bDefault Then
    sqlstmt = "update ProductoFormulaKit set prfk_default = 0 " & _
              "where pr_id = " & Pr_id
    If Not gDB.Execute(sqlstmt) Then Exit Function
  End If
  
  pSaveDefault = True
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
                        'Fórmulas de Kits
  cIABMClient_Title = LNGGetText(1358, vbNullString)
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IProperty     As cIABMProperty
  Dim bHaveLote     As Boolean
  Dim bHaveSerie    As Boolean
  Dim bNeedLote     As Boolean
  Dim bNeedSerie    As Boolean
  Dim Pr_id         As Long
  
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
        
        Case K_PR_ID
          Pr_id = .HelpId
          If ValEmpty(Pr_id, csId) Then
            MsgInfo LNGGetText(1359, vbNullString)
                    'Debe indicar un artículo
            Exit Function
          End If
        
        Case K_PR_ID_SERIE
          bHaveSerie = .HelpId <> csNO_ID
        
        Case K_PR_ID_LOTE
          bHaveLote = .HelpId <> csNO_ID
        
      End Select
    End With
  Next
  
  If Not bHaveLote Or Not bHaveSerie Then
  
    If Not pProductoGetSerieLote(Pr_id, bNeedLote, bNeedSerie) Then Exit Function
    
    If bNeedSerie And Not bHaveSerie Then
      MsgInfo LNGGetText(1360, vbNullString)
                'Debe indicar el item que define la identidad del Kit
      Exit Function
    End If
    
    If bNeedLote And Not bHaveLote Then
      MsgInfo LNGGetText(1361, vbNullString)
                'Debe indicar el item que define el lote del Kit
      Exit Function
    End If
  
  End If
  
  If Not pCheckSerieInItems() Then
    Exit Function
  End If
  
  cIABMClient_Validate = True
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

Private Function cIEditGeneric_GridAdd(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
  cIEditGeneric_ShowList = SecurityCanAccess(csPreGListProductoFKit)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  If Not SecurityCanAccess(csPreGDeleteProductoFKit) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "sp_ProductoFormulaKitDelete " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
  m_IsNew = True
  If Not SecurityCanAccess(csPreGNewProductoFKit) Then Exit Function
  Else
  m_IsNew = False
  If Not SecurityCanAccess(csPreGEditProductoFKit) Then Exit Function
  End If

  m_ObjAbm.InModalWindow = InModalWindow
  
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
  MngError Err, C_EditGenericEdit, C_Module, vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal Id As Long) As Boolean

End Function

Private Property Set cIEditGeneric_ObjTree(rhs As Object)
  Set m_ObjTree = rhs
End Property

Private Function cIEditGeneric_PropertyChange(ByVal Clave As Integer) As Boolean

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

  Set m_Host = Host
  
  m_Host.Server.AddMenu C_MenuArticulos, csMenuConfigArticulos, C_MenuConfig, 0, True, False, False, False, True, Nothing
                        '&Formulas de Kits
  m_Host.Server.AddMenu LNGGetText(1362, vbNullString), csPreGListProductoFKit, C_MenuArticulos, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                                  'Fórmula de Kit
  m_Host.MenuABMClick "CSGeneral2.cProductoFormulaKit", Me, LNGGetText(1363, vbNullString), 0, csETablasGeneral.csProductoFormulaKit
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, _
                                                   ByVal lRow As Long, _
                                                   ByVal lCol As Long, _
                                                   ByVal iKeyAscii As Integer) As Boolean
  Dim Row As cIABMGridRow
  
  Select Case Key
    Case K_ITEMS
      If lCol = c_colAlt Then
        With m_ObjAbm.Properties.Item(c_Items).Grid.Rows
          Set Row = .Item(lRow)
        End With
        
        Dim Id As Long
        Id = Val(pCell(Row, KIK_PRK_ID).Value)
        If Id = csNO_ID Then
          Id = lRow * -1
        End If
        pEditAlternativas Id, _
                          pCell(Row, KIK_PR_ID_ITEM).Value, _
                          Row
      End If
  End Select
End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Id = Val(pCell(Row, KIK_PRK_ID).Value)
  
  If Id <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & Id & C_StrColon
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_ValidateRow = pValidateRowItems(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean

End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowItems(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_IsEmptyRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pIsEmptyRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell              As cIABMGridCellValue
  Dim bRowIsEmpty       As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      
      Case KIK_PR_ID_ITEM
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
        
      Case KIK_PRK_CANTIDAD
        If Not ValEmpty(Cell.Value, csDouble) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  
  pIsEmptyRowItems = bRowIsEmpty
End Function


Private Function pValidateRowItems(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell              As cIABMGridCellValue
  Dim strRow            As String
  Dim bNeedCantidad     As Boolean
  Dim bHaveCantidad     As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    
    Select Case Cell.Key
      
      Case KIK_PR_ID_ITEM
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(1364, vbNullString, strRow)
                  'Debe indicar un artículo
          Exit Function
        End If
      
      Case KIK_PRK_VARIABLE
        bNeedCantidad = Cell.Id = 0
      
      Case KIK_PRK_CANTIDAD
        bHaveCantidad = Val(Cell.Value) > 0
        
    End Select
  Next
  
  If Not bHaveCantidad And bNeedCantidad Then
    MsgInfo LNGGetText(1365, vbNullString, strRow)
            'Debe indicar una cantidad
    Exit Function
  End If
  
  pValidateRowItems = True
  
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  Dim c As cIABMProperty
  
  With m_ObjAbm
  
    With .Tabs
      .Clear
        
      With .Add(Nothing)
        .Index = 0
        .Name = C_strGeneral
      End With
      
      With .Add(Nothing)
        .Index = 1
        .Name = LNGGetText(1366, vbNullString)    'Insumos
      End With
    End With
  
    .Title2 = m_Nombre
    
    With .Properties
      
      .Clear
    
      With .Add(Nothing, cscPrfkNombre)
        .PropertyType = cspText
        .Name = C_strNombre
        .Size = 255
        .Key = K_NOMBRE
        .Width = 6000
        .Value = m_Nombre
      End With
      
      With .Add(Nothing, cscPrfkCodigo)
        .PropertyType = cspText
        .Name = C_strCodigo
        .Size = 15
        .Value = m_Codigo
        .Key = K_CODIGO
      End With
      
      With .Add(Nothing, cscActivo)
        .PropertyType = cspCheck
        .Name = C_strActivo
        .Key = K_ACTIVO
        .Value = CInt(m_Activo)
      End With
      
      With .Add(Nothing, cscPrfkDefault)
        .PropertyType = cspCheck
        .Name = LNGGetText(1368, vbNullString) 'Fórmula por defecto
        .Key = K_DEFAULT
        .Value = CInt(m_Default)
      End With
      
      With .Add(Nothing, cscPrId)
        .PropertyType = cspHelp
        .Table = csProductoStock
        .HelpFilter = cscPrEskit & " <> 0"
        .Name = LNGGetText(1367, vbNullString) 'Artículo
        .Key = K_PR_ID
        .HelpId = m_Pr_id
        .Value = m_Producto
        .Enabled = m_bEditable
        .TopFromProperty = cscPrfkCodigo
        .Left = 6000
      End With
      
      Dim Pr_id         As Long
      Dim bNeedLote     As Boolean
      Dim bNeedSerie    As Boolean
      
      If Not pProductoGetSerieLote(m_Pr_id, bNeedLote, bNeedSerie) Then Exit Function
      
      With .Add(Nothing, cscPrIdSerie)
        .PropertyType = cspHelp
        .Table = csProductoStock
        .HelpFilter = cscPrLlevaNroSerie & " <> 0"
        .Name = LNGGetText(1369, vbNullString) 'Item Serie
        .Key = K_PR_ID_SERIE
        .HelpId = m_pr_id_serie
        .Value = m_ProductoSerie
        .Enabled = m_bEditable And bNeedSerie
      End With
      
      With .Add(Nothing, cscPrIdLote)
        .PropertyType = cspHelp
        .Table = csProductoStock
        .HelpFilter = cscPrLlevaNroLote & " <> 0"
        .Name = LNGGetText(1370, vbNullString) 'Item Lote
        .Key = K_PR_ID_LOTE
        .HelpId = m_pr_id_lote
        .Value = m_ProductoLote
        .Enabled = m_bEditable And bNeedLote
      End With
      
      With .Add(Nothing, cscPrDescripcompra)
        .PropertyType = cspText
        .Name = C_strDescrip
        .Height = 880
        .Width = 8000
        .SubType = cspMemo
        .Size = 2000
        .Key = K_DESCRIP
        .Value = m_descrip
        .LeftFromProperty = cscPrfkNombre
        .TopFromProperty = cscPrfkDefault
        .TopToPrevious = 440
      End With
      
      Set c = .Add(Nothing, c_Items)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadItems(c) Then Exit Function
        .Name = LNGGetText(1371, vbNullString) 'Items
        .Key = K_ITEMS
        .TabIndex = 1
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
        .Enabled = m_bEditable
      End With
      
      m_ItemsDeleted = vbNullString
      
    End With

    If Not .Show(Me) Then Exit Function
    
  End With

  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_ProductoFormulaKitGet " & Id
  
  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    C_LoadFunction, _
                    C_Module) Then Exit Function
  
  If rs.EOF Then
    
    m_Activo = True
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Id = csNO_ID
    m_Default = False
    m_Producto = vbNullString
    m_Pr_id = csNO_ID
    m_ProductoSerie = vbNullString
    m_pr_id_serie = csNO_ID
    m_ProductoLote = vbNullString
    m_pr_id_lote = csNO_ID
    m_descrip = vbNullString
    m_bEditable = True
    
  Else
  
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_Nombre = gDB.ValField(rs.fields, cscPrfkNombre)
    m_Codigo = gDB.ValField(rs.fields, cscPrfkCodigo)
    m_Id = gDB.ValField(rs.fields, cscPrfkId)
    m_Default = gDB.ValField(rs.fields, cscPrfkDefault)
    m_descrip = gDB.ValField(rs.fields, cscPrfkDescrip)
    m_Producto = gDB.ValField(rs.fields, cscPrNombrecompra)
    m_Pr_id = gDB.ValField(rs.fields, cscPrId)
    m_ProductoSerie = gDB.ValField(rs.fields, "ProductoSerie")
    m_pr_id_serie = gDB.ValField(rs.fields, cscPrIdSerie)
    m_ProductoLote = gDB.ValField(rs.fields, "ProductoLote")
    m_pr_id_lote = gDB.ValField(rs.fields, cscPrIdLote)
    m_bEditable = gDB.ValField(rs.fields, "bEdit")
  End If
  
  Set m_CollAlts = Nothing
  
  Load = True
  
End Function

Private Function pSaveItems() As Boolean
  Dim bFoundSerie As Boolean
  Dim bFoundLote  As Boolean
  Dim pr_id_serie As Long
  Dim pr_id_lote  As Long
  Dim bVariable   As Boolean
  Dim Cantidad    As Double
  Dim iOrden      As Long
  Dim iOrden2     As Long
  Dim register    As cRegister
  Dim fields      As cFields
  
  With m_ObjAbm.Properties
    pr_id_serie = .Item(cscPrIdSerie).HelpId
    pr_id_lote = .Item(cscPrIdLote).HelpId
  End With
  
  With m_ObjAbm.Properties.Item(c_Items)
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      Set register = New cRegister
      iOrden2 = iOrden2 + 1
      
      With register
        Set fields = .fields
        .fieldId = cscPrkId
        .Table = csTProductoKit
        .Id = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KIK_PRK_ID
              iOrden = Val(Cell.Value)
              If Not m_Copy Then
                .Id = iOrden
              End If
              
              If iOrden = csNO_ID Then
                iOrden = iOrden2 * -1
              End If
              
            Case KIK_PR_ID_ITEM
              fields.Add2 cscPrIdItem, Cell.Id, csId
              
              If Cell.Id = pr_id_serie Then
                bFoundSerie = True
              End If
              
              If Cell.Id = pr_id_lote Then
                bFoundLote = True
              End If
            
            Case KIK_PRK_CANTIDAD
              Cantidad = Val(Cell.Value)
            
            Case KIK_PRK_VARIABLE
              bVariable = Cell.Id
              fields.Add2 cscPrkVariable, Cell.Id, csBoolean
              
          End Select
        Next
        
        If bVariable Then
          Cantidad = 0
        End If
        fields.Add2 cscPrkCantidad, Cantidad, csDouble
        fields.Add2 cscPrfkId, m_Id, csId
        
        fields.HaveLastUpdate = True
        fields.HaveWhoModify = True
            
      End With
                                                            
      If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
      
      If Not pSaveItemsA(register.Id, iOrden) Then Exit Function
    Next
  End With
  
  If Not bFoundSerie And pr_id_serie <> csNO_ID Then
    If Not pAddProductoToItems(pr_id_serie) Then Exit Function
  End If
  
  If Not bFoundLote And pr_id_lote <> csNO_ID Then
    If Not pAddProductoToItems(pr_id_lote) Then Exit Function
  End If
  
  Dim sqlstmt As String
  
  If m_ItemsDeleted <> vbNullString And Not m_Copy Then
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    sqlstmt = "delete ProductoKit where prk_id in (" & m_ItemsDeleted & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItems", C_Module) Then Exit Function
  End If
  
  sqlstmt = "sp_ProductoSaveKit " & m_Id
  If Not gDB.Execute(sqlstmt, "pSaveItems", C_Module) Then Exit Function
  
  pSaveItems = True
End Function

Private Function pCheckSerieInItems() As Boolean
  Dim bFoundSerie As Boolean
  Dim bFoundLote  As Boolean
  Dim serie       As String
  Dim lote        As String
  Dim pr_id_serie As Long
  Dim pr_id_lote  As Long
  
  With m_ObjAbm.Properties
    With .Item(cscPrIdSerie)
      pr_id_serie = .HelpId
      serie = .Value
    End With
    With .Item(cscPrIdLote)
      pr_id_lote = .HelpId
      lote = .Value
    End With
  End With
  
  If pr_id_serie <> csNO_ID Or pr_id_lote <> csNO_ID Then
  
    With m_ObjAbm.Properties.Item(c_Items)
      
      Dim Row As cIABMGridRow
      For Each Row In .Grid.Rows
      
        With pCell(Row, KIK_PR_ID_ITEM)
         
          If .Id = pr_id_serie Then
            bFoundSerie = True
          End If
          
          If .Id = pr_id_lote Then
            bFoundLote = True
          End If
        End With
      
      Next
    End With
    
    If Not bFoundSerie And pr_id_serie <> csNO_ID Then
      'If Not Ask("No se encontro el artículo que indica el número " & _
                 "de serie para este kit (" & serie & ") entre los items de la formula, " & _
                 "¿Desea que el sistema lo agregue por Ud.?", vbYes) Then
      If Not Ask(LNGGetText(1550, vbNullString, serie), vbYes) Then
        Exit Function
      End If
    End If
    
    If Not bFoundLote And pr_id_lote <> csNO_ID Then
      'If Not Ask("No se encontro el artículo que indica el lote " & _
                 "para este kit (" & lote & ") entre los items de la formula, " & _
                 "¿Desea que el sistema lo agregue por Ud.?.", vbYes) Then
      If Not Ask(LNGGetText(1551, vbNullString, lote), vbYes) Then
        Exit Function
      End If
    End If
  
  End If
  
  pCheckSerieInItems = True
End Function

Private Function pAddProductoToItems(ByVal Pr_id As Long) As Boolean
  Dim register    As cRegister
  Dim fields      As cFields
  
  Set register = New cRegister
  With register
    
    Set fields = .fields
    .fieldId = cscPrkId
    .Table = csTProductoKit
    .Id = csNew
    fields.Add2 cscPrIdItem, Pr_id, csId
    fields.Add2 cscPrkCantidad, 1, csDouble
    fields.Add2 cscPrkVariable, 0, csBoolean
    fields.Add2 cscPrfkId, m_Id, csId
    fields.HaveLastUpdate = True
    fields.HaveWhoModify = True
        
  End With
                                                      
  If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
  
  pAddProductoToItems = True
End Function

Private Function pSaveItemsA(ByVal prk_id As Long, _
                             ByVal iOrden As Long _
                            ) As Boolean
  
  Dim Item      As cProductoKitItemA
  Dim register  As cRegister
  Dim fields    As cFields
  Dim ItemsDel  As String
    
  If ExistsObjectInColl(m_CollAlts, pGetItemKey(iOrden)) Then
    
    For Each Item In m_CollAlts.Item(pGetItemKey(iOrden))
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscPrkaId
        .Table = csTProductoKitItemA
        .Id = csNew
        
        If Not m_Copy Then
          If Item.Id > 0 Then
            .Id = Item.Id
          End If
        End If
        
        With fields
          .Add2 cscPrId, Item.Pr_id, csId
          .Add2 cscActivo, Item.Activo, csBoolean
          .Add2 cscPrkId, prk_id, csId
        End With
        
      End With
                                                            
      If Not gDB.Save(register, , "pSaveItemsA", C_Module, c_ErrorSave) Then Exit Function
      
    Next
    
    Dim sqlstmt As String
    
    ItemsDel = m_CollAlts.Item(pGetItemKey(iOrden, True))
    If ItemsDel <> vbNullString And Not m_Copy Then
      ItemsDel = RemoveLastColon(ItemsDel)
      sqlstmt = "delete ProductoKitItemA where prka_id in (" & ItemsDel & ")"
      If Not gDB.Execute(sqlstmt, "pSaveItemsA", C_Module) Then Exit Function
    End If
  
  End If
  
  pSaveItemsA = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim descrip As String
  Dim coll    As Collection
  Dim prk_id  As Long
  Dim Item    As cProductoKitItemA
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_productoFormulaKitGetItems " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pLoadItems", _
                    C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIK_PRK_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1367, vbNullString) 'Articulo
        .PropertyType = cspHelp
        .Table = csProducto
        .Width = 2500
        .Key = KIK_PR_ID_ITEM
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1374, vbNullString) 'Cantidad
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Format = gFormatDecCantidad
        .Width = 2000
        .Key = KIK_PRK_CANTIDAD
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1375, vbNullString) 'Variable
        .PropertyType = cspCheck
        .Width = 1000
        .Key = KIK_PRK_VARIABLE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1376, vbNullString) 'Alternativas
        .PropertyType = cspText
        .SubType = cspTextButton
        .Width = 1000
        .Key = KIK_PRK_ALT
      End With
      c_colAlt = .Count
      
    End With
    
    With .Rows
      
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscPrkId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscPrkId).Value
            .Key = KIK_PRK_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrNombrecompra)
            .Id = gDB.ValField(rs.fields, cscPrIdItem)
            .Key = KIK_PR_ID_ITEM
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrkCantidad)
            .Key = KIK_PRK_CANTIDAD
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, cscPrkVariable)
            .Key = KIK_PRK_VARIABLE
          End With
         
          With .Add(Nothing)
            .Key = KIK_PRK_ALT
          End With
         
         End With
         
        rs.MoveNext
      Wend
    
    End With
    
  End With
  
  Set rs = rs.NextRecordset
  
  If Not rs.EOF Then
    Set m_CollAlts = New Collection
  End If
  
  While Not rs.EOF
    
    If prk_id <> gDB.ValField(rs.fields, cscPrkId) Then
      If Not coll Is Nothing Then
        m_CollAlts.Add coll, pGetItemKey(prk_id)
        m_CollAlts.Add vbNullString, pGetItemKey(prk_id, True)
        pSetDescripInRow descrip, prk_id
      End If
      descrip = vbNullString
      prk_id = gDB.ValField(rs.fields, cscPrkId)
      Set coll = New Collection
    End If
    
    Set Item = New cProductoKitItemA
    With Item
      .Id = gDB.ValField(rs.fields, cscPrkaId)
      .Activo = gDB.ValField(rs.fields, cscActivo)
      .Nombre = gDB.ValField(rs.fields, cscPrNombrecompra)
      .Pr_id = gDB.ValField(rs.fields, cscPrId)
      descrip = descrip & .Nombre & ","
    End With
    
    coll.Add Item
    
    rs.MoveNext
  Wend
  
  If Not coll Is Nothing Then
    m_CollAlts.Add coll, pGetItemKey(prk_id)
    m_CollAlts.Add vbNullString, pGetItemKey(prk_id, True)
    pSetDescripInRow descrip, prk_id
  End If
  
  pLoadItems = True
End Function

Private Sub pSetDescripInRow(ByVal descrip As String, _
                             ByVal prk_id As Long)
  Dim Row As cIABMGridRow
  
  For Each Row In m_ObjAbm.Properties.Item(c_Items).Grid.Rows
    If Val(pCell(Row, KIK_PRK_ID).Value) = prk_id Then
      pCell(Row, KIK_PRK_ALT).Value = RemoveLastColon(descrip)
    End If
  Next
End Sub

Private Function pProductoGetSerieLote(ByVal Pr_id As Long, _
                                       ByRef bNeedLote As Boolean, _
                                       ByRef bNeedSerie As Boolean) As Boolean
                                       
  If Not gDB.GetData(csTProducto, cscPrId, Pr_id, cscPrKitLoteXItem, bNeedLote) Then Exit Function
  If Not gDB.GetData(csTProducto, cscPrId, Pr_id, cscPrKitIdentidadXItem, bNeedSerie) Then Exit Function
  
  pProductoGetSerieLote = True
End Function

Private Function pEditAlternativas(ByVal Id As Long, _
                                   ByVal Producto As String, _
                                   ByRef Row As cIABMGridRow) As Boolean
                                   
  Dim ObjEdit  As cProductoKitItemEdit
  Dim CollAlt  As Collection
  Dim ItemsDel As String
  Dim bRemove  As Boolean
  Dim ObjAbm   As cABMGeneric
  
  Set ObjAbm = New cABMGeneric
  Set ObjEdit = New cProductoKitItemEdit
  
  If m_CollAlts Is Nothing Then
    Set m_CollAlts = New Collection
  End If
  
  If ExistsObjectInColl(m_CollAlts, pGetItemKey(Id)) Then
    bRemove = True
    Set CollAlt = m_CollAlts.Item(pGetItemKey(Id))
    ItemsDel = m_CollAlts.Item(pGetItemKey(Id, True))
  End If
  
  If Not ObjEdit.Edit(ObjAbm, _
                      CollAlt, _
                      ItemsDel, _
                      m_bEditable, _
                      Producto) Then Exit Function
                      
  If bRemove Then
    m_CollAlts.Remove pGetItemKey(Id)
    m_CollAlts.Remove pGetItemKey(Id, True)
  End If
  
  m_CollAlts.Add ObjEdit.CollAlt, pGetItemKey(Id)
  m_CollAlts.Add ObjEdit.ItemsDeleted, pGetItemKey(Id, True)
  
  pCell(Row, KIK_PRK_ALT).Value = ObjEdit.descrip
End Function

Private Function pGetItemKey(ByVal Id As Long, _
                             Optional ByVal bIsDelete As Boolean) As String
  Dim rtn As String
  rtn = "K" & Id
  If bIsDelete Then rtn = rtn & "D"
  pGetItemKey = rtn
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error Resume Next
  c_ErrorSave = LNGGetText(2305, vbNullString) 'Error al grabar la Formula de Kit
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
  Set m_CollAlts = Nothing
End Sub
