VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCatalogoWebCategoria"
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
' cCatalogoWebCategoria
' 24-09-2008

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cCatalogoWebCategoria"
Private Const c_Items = "Items"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_ACTIVO                         As Integer = 6


Private Const K_ITEMS                          As Integer = 16
Private Const K_PR_ID_FILTER                   As Integer = 17
Private Const K_CMD_PR_FILTER                  As Integer = 18

Private Const KI_CATWI_ID                      As Integer = 1
Private Const KI_PRODUCTO                      As Integer = 2
Private Const KI_CATWI_ACTIVO                  As Integer = 3
Private Const KI_POSICION                      As Integer = 4

' estructuras
' Seudo - Variables
Private c_ErrorSave                    As String

' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_descrip                      As String
Private m_Activo                       As Boolean

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long
 
Private m_ItemsDeleted      As String

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean
Private m_WasChanged        As Boolean

Private m_GeneralConfig     As cGeneralConfig

' Properties publicas

' JMA I
Public Property Get Id() As Long
  Id = m_Id
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
  
  With m_ObjAbm.Properties(cscCatwcCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscCatwcNombre)
'    .Value = C_CopiaDe & .Value
'  End With
   
  With m_ObjAbm
    .ShowValue .Properties.Item(cscCatwcCodigo)
    .ShowValue .Properties.Item(cscCatwcNombre)
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

  Doc.ClientTable = csTCatalogoWebCategoria
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
  
  With m_ObjAbm.Properties
    Select Case Key
      Case K_CMD_PR_FILTER
        pShowItems
    End Select
  End With

End Function

Private Sub pShowItems()
  If m_WasChanged Then
    If Not Ask(LNGGetText(3560, vbNullString), vbNo) Then Exit Sub
          'Ud. ha modificado la lista de artículos, si continúa perderá estos cambios.;; & _
          Para conservarlos presione el boton 'NO' y luego el boton 'Guardar'.;; & _
          ¿Descarta los cambios?.
  End If
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties.Item(c_Items)
  pLoadItems iProp
  m_ObjAbm.ShowValue iProp
End Sub

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Dim fields   As cFields
  Dim LastId   As Long

  Set register = New cRegister
  With register
    Set fields = .fields
    .fieldId = cscCatwcId
    .Table = csTCatalogoWebCategoria
  
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
          fields.Add2 cscCatwcNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscCatwcCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscCatwcDescrip, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.SaveEx(register, , _
                    cscCatwcCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.Id
  
  If m_Copy Then
    If Not pSaveItemsCopy(LastId, m_Id) Then GoTo SaveError
  Else
    If Not pSaveItems() Then GoTo SaveError
  End If
  
  If Not register.CommitTrans() Then GoTo SaveError
  
  m_Copy = False
  cIABMClient_Save = Load(register.Id)

  Exit Function
SaveError:
  m_Id = LastId
End Function

Private Function pSaveItemsCopy(ByVal IdSource As Long, _
                                ByVal IdTarget As Long)
  Dim sqlstmt As String
  sqlstmt = "sp_catwcCopiarItems " & IdSource & "," & IdTarget & "," & User.Id
  
  pSaveItemsCopy = gDB.Execute(sqlstmt)
End Function

Private Function pSaveItems() As Boolean
  Dim register    As cRegister
  Dim IProperty   As cIABMProperty
  Dim RowIndex    As Long
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_ITEMS
        
          Dim Row  As cIABMGridRow
          Dim Cell As cIABMGridCellValue
          
          For Each Row In IProperty.Grid.Rows
          
            RowIndex = RowIndex + 1
          
            If Not pValidateRowItems(Row, RowIndex) Then Exit Function
            
            Set register = New cRegister
            
            With register
              .fieldId = cscCatwciId
              .Table = csTCatalogoWebCategoriaItem
              .Id = csNew
              
              For Each Cell In Row
                Select Case Cell.Key
                  Case KI_CATWI_ID
                    If Not m_Copy Then
                      .Id = Val(Cell.Value)
                    End If
                  Case KI_PRODUCTO
                    .fields.Add2 cscPrId, Cell.Id, csId
                  Case KI_CATWI_ACTIVO
                    .fields.Add2 cscCatwciActivo, Cell.Id, csBoolean
                  Case KI_POSICION
                    .fields.Add2 cscCatwciPosicion, Cell.Value, csInteger
                End Select
              Next
            
              .fields.Add2 cscCatwcId, m_Id, csId
            
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
    sqlstmt = "delete CatalogoWebCategoriaItem where catwci_id in (" & m_ItemsDeleted & ")"
  
    If Not gDB.Execute(sqlstmt, C_pSaveItemsFunc, C_Module) Then Exit Function
  End If
  
  pSaveItems = True
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
  cIABMClient_Title = LNGGetText(4591, vbNullString) 'Categorias de Catalogos Web
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
    Case K_ITEMS
      m_WasChanged = True
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
  
    Case K_ITEMS
      Id = Val(pCell(Row, KI_CATWI_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & Id & C_StrColon
  End Select
  
  cIABMClientGrid_DeleteRow = True
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

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function pValidateRowItems(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_PRODUCTO
        If Cell.Id = csNO_ID Then
          MsgWarning LNGGetText(3068, vbNullString, strRow) 'Debe indicar un producto (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowItems = True

End Function

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

' Implementacion de cIEditGeneric
Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Function cIEditGeneric_PrintObj(ByVal Id As Long) As Boolean

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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreGListCatalogoWebCategoria)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  If Not SecurityCanAccess(csPreGDeleteCatalogoWebCategoria) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "sp_catalogoWebCategoriaDelete " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewCatalogoWebCategoria) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditCatalogoWebCategoria) Then Exit Function
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

Private Function cIEditGeneric_Preview(ByVal Id As Long) As Boolean

End Function

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
  
  m_Host.Server.AddMenu C_MenuArticulos, csMenuConfigArticulos, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(4592, vbNullString), csPreGListCatalogoWebCategoria, C_MenuArticulos, 0, True, False, False, False, False, Me
                        '&Categorias de Catalogos Web
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuABMClick "CSGeneral2.cCatalogoWebCategoria", _
                      Me, _
                      LNGGetText(4593, vbNullString), _
                      0, _
                      csETablasGeneral.csCatalogoWebCategoria
                      'Categoria de Catalogos Web
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim iProp As cABMProperty
  Dim c As cIABMProperty
      
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 7800
      
  With m_ObjAbm.Tabs
   
    .Clear
      
    With .Add(Nothing)
      .Index = 0
      .Name = C_strGeneral
    End With
    
    With .Add(Nothing)
      .Index = 1
      .Name = LNGGetText(1283, vbNullString) ' Articulos
    End With
  
  End With
  
  m_ObjAbm.Properties.Clear
  m_ObjAbm.Title2 = m_Nombre
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCatwcNombre)
  c.PropertyType = cspText
  c.Name = C_strNombre
  c.Size = 100
  c.Key = K_NOMBRE
  c.Value = m_Nombre
  c.Width = 5000
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCatwcCodigo)
  c.PropertyType = cspText
  c.Name = C_strCodigo
  c.Size = 15
  c.Key = K_CODIGO
  c.Value = m_Codigo
  
  Set c = m_ObjAbm.Properties.Add(Nothing, m_Activo)
  c.PropertyType = cspCheck
  c.TopFromProperty = cscCatwcCodigo
  c.TopNotChange = True
  c.LeftNotChange = True
  c.Left = 4000
  c.LeftLabel = -800
  c.Name = C_strActivo
  c.Key = K_ACTIVO
  c.Value = CInt(m_Activo)
                  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCatwcDescrip)
  c.PropertyType = cspText
  c.Name = C_strDescrip
  c.Size = 5000
  c.TopToPrevious = 440
  c.Height = 780
  c.Width = 6250
  c.SubType = cspMemo
  c.LeftFromProperty = cscCatwcNombre
  c.Key = K_DESCRIP
  c.Value = m_descrip
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPrId)
  c.Name = LNGGetText(3089, vbNullString) 'Productos
  c.PropertyType = cspText
  c.TabIndex = 1
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
  c.TabIndex = 1
  c.Key = K_CMD_PR_FILTER
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_Items)
  With c
    .PropertyType = cspGrid
    .LeftLabel = -1
    If Not pLoadItems(c) Then Exit Function
    .Left = 400
    .TopFromProperty = cscPrId
    .TopToPrevious = 440
    .Name = c_Items
    .Key = K_ITEMS
    .TabIndex = 1
    .GridAdd = True
    .GridEdit = True
    .GridRemove = True
  End With
  
  m_ItemsDeleted = vbNullString
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs As Recordset

  sqlstmt = "select * from CatalogoWebCategoria where catwc_id = " & Id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscCatwcId)
    m_Nombre = gDB.ValField(rs.fields, cscCatwcNombre)
    m_Codigo = gDB.ValField(rs.fields, cscCatwcCodigo)
    m_descrip = gDB.ValField(rs.fields, cscCatwcDescrip)
    m_Activo = gDB.ValField(rs.fields, cscActivo)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_descrip = vbNullString
    m_Activo = True
  End If

  Load = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  m_WasChanged = False
  
  With m_ObjAbm.Properties
    sqlstmt = "sp_CatalogoWebCategoriaGetItems " & m_Id & "," _
                      & gDB.sqlString(.Item(cscPrId).Value)
  End With
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Name = "lpi_id"
        .Visible = False
        .Key = KI_CATWI_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1367, vbNullString) 'Articulo
        .PropertyType = cspHelp
        .Table = csProductoVenta
        .Width = 3500
        .Key = KI_PRODUCTO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(3268, vbNullString) ' Posición
        .PropertyType = cspNumeric
        .SubType = cspInteger
        .Key = KI_POSICION
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(3557, vbNullString) 'Activo
        .PropertyType = cspCheck
        .Width = 1200
        .Key = KI_CATWI_ACTIVO
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Id = 1
      End With
      
    End With
      
    With .Rows
    
      .Clear
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscCatwciId).Value)
        
          With .Add(Nothing)
            .Value = rs.fields.Item(cscCatwciId).Value
            .Key = KI_CATWI_ID
          End With
          
          With .Add(Nothing)
            .Value = rs.fields.Item("pr_nombre").Value
            .Id = rs.fields.Item(cscPrId).Value
            .Key = KI_PRODUCTO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCatwciPosicion)
            .Key = KI_POSICION
          End With
          
          With .Add(Nothing)
            .Id = rs.fields.Item(cscCatwciActivo).Value
            .Key = KI_CATWI_ACTIVO
          End With
          
        End With
        
        rs.MoveNext
      Wend
    
    End With
  End With
  
  pLoadItems = True
End Function

Private Function pIsEmptyRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_PRODUCTO
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowItems = bRowIsEmpty
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(4594, vbNullString) 'Error al grabar la categoria de catalogo web
  
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
