VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProductoBOM"
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
' cProductoBOM
' 17-04-06

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cProductoBOM"

Private Const c_elaborados = "Elaborados"
Private Const c_items = "Insumos"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHAAUTO                      As Integer = 4
Private Const K_MERMA                          As Integer = 5
Private Const K_VARPOS                         As Integer = 6
Private Const K_VARNEG                         As Integer = 7
Private Const K_VARTIPO                        As Integer = 8
Private Const K_ACTIVO                         As Integer = 9
Private Const K_DEFAULT                        As Integer = 12

Private Const K_ELABORADO                   As Integer = 10
Private Const K_ITEMS                       As Integer = 11

' Producto ELABORADO
Private Const KI_PBME_ID                    As Integer = 1
Private Const KI_PBME_CANTIDAD              As Integer = 2
Private Const KI_PR_ID_E                    As Integer = 3
Private Const KI_PBME_CANTTIPO              As Integer = 4
Private Const KI_PBME_VARPOS                As Integer = 5
Private Const KI_PBME_VARNEG                As Integer = 6
Private Const KI_PBME_VARTIPO               As Integer = 7

' Producto ITEM
Private Const KI_PBMI_ID                    As Integer = 1
Private Const KI_PR_ID_I                    As Integer = 2
Private Const KI_PBMI_CANTIDAD              As Integer = 3
Private Const KI_PBMI_MERMA                 As Integer = 4
Private Const KI_PBMI_VARPOS                As Integer = 5
Private Const KI_PBMI_VARNEG                As Integer = 6
Private Const KI_PBMI_VARTIPO               As Integer = 7
Private Const KI_PBMI_ESBASE                As Integer = 8
Private Const KI_PBMI_TEMP                  As Integer = 9
Private Const KI_PBMIT_ID                   As Integer = 10
Private Const KI_PBMIA_ID                   As Integer = 11

' estructuras
' Seudo - Variables
Private c_ErrorSave                    As String

' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_Descrip                      As String
Private m_FechaAuto                    As Date
Private m_Merma                        As Double
Private m_Varpos                       As Double
Private m_Varneg                       As Double
Private m_Vartipo                      As Boolean
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_Activo                       As Boolean
Private m_Default                      As Boolean

Private m_ItemsDeletedE                As String
Private m_ItemsDeletedI                As String

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

Private m_GeneralConfig     As cGeneralConfig

' Properties publicas
Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Codigo
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
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

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  Select Case MessageID
  
    Case MSG_DOC_INFO
    
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      
      CSKernelClient2.ShowHelp AbmGen.hWnd, _
                               vbNullString, _
                               vbNullString, _
                               csPreProdNewProductoBOM
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    Case Else
      cIABMClient_MessageEx = True
  End Select
End Function

Private Function cIABMClient_ShowDocDigital() As Boolean
  On Error GoTo ControlError
  
  If m_Id = csNO_ID Then Exit Function
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = csTProductoBOM
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  cIEditGeneric_Edit csNO_ID
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_Copy() As Boolean
  cIABMClient_Terminate
  m_IsNew = True

  With m_ObjAbm.Properties(cscPbmCodigo)
    .Value = "C-" & .Value
  End With
  
  With m_ObjAbm.Properties(cscPbmNombre)
    .Value = "Copia de " & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscPbmCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscPbmNombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim LastId   As Long
  Dim register As cRegister
  Dim fields   As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscPbmId
    .Table = csTProductoBOM
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
          fields.Add2 cscPbmNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscPbmCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscPbmDescrip, .Value, csText
        Case K_FECHAAUTO
          fields.Add2 cscPbmFechaAuto, .Value, csDate
        Case K_MERMA
          fields.Add2 cscPbmMerma, .Value, csCurrency
        Case K_VARPOS
          fields.Add2 cscPbmVarpos, .Value, csCurrency
        Case K_VARNEG
          fields.Add2 cscPbmVarneg, .Value, csCurrency
        Case K_VARTIPO
          fields.Add2 cscPbmVartipo, .Value, csBoolean
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
        Case K_DEFAULT
          fields.Add2 cscPbmDefault, .Value, csBoolean
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
    
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , C_ABMClientSave, C_Module, c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.Id
  
  If Not pSaveElaborados() Then GoTo SaveError
  If Not pSaveItems() Then GoTo SaveError
  
  If Not register.CommitTrans() Then GoTo SaveError
  
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
    
    If m_IsNew Then
        m_ObjTree.AddLeave m_Id, m_BranchId, m_TreeId
    Else
        m_ObjTree.AddEditedId m_Id
        m_ObjTree.RefreshActiveBranch
    End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = "B.O.M."
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1007, vbNullString) 'Debe indicar un nombre
            Exit Function
          End If
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1008, vbNullString) 'Debe indicar un código
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  Dim Row As cIABMGridRow
  
  Select Case Key
    Case K_ITEMS
      Set Row = m_ObjAbm.Properties.Item(c_items).Grid.Rows(lRow)
      If m_Id = csNO_ID Or Val(pCell(Row, KI_PBMI_ID).Value) = csNO_ID Then
        MsgWarning LNGGetText(3044, vbNullString)
                  'Antes de poder indicar productos alternativos debe guardar la B.O.M.
      Else
        pAddAlternativa Row
      End If
  End Select
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
    Case K_ELABORADO
      Id = Val(pCell(Row, KI_PBME_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedE = m_ItemsDeletedE & Id & C_StrColon
    Case K_ITEMS
      Id = Val(pCell(Row, KI_PBMI_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedI = m_ItemsDeletedI & Id & C_StrColon
  End Select
  
  cIABMClientGrid_DeleteRow = True

End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ELABORADO
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowE(Row, RowIndex)
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowI(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
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
    Case K_ELABORADO
      cIABMClientGrid_ValidateRow = pValidateRowE(Row, RowIndex)
    Case K_ITEMS
      cIABMClientGrid_ValidateRow = pValidateRowI(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next

End Function

' Implementacion de cIEditGeneric

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreProdListProductoBOM)
End Function

Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreProdDeleteProductoBOM) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "sp_ProductoBOMDelete " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreProdNewProductoBOM) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreProdEditProductoBOM) Then Exit Function
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
  MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal Id As Long) As Boolean

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

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

'/////////////////////////////////////////////////////////////
' Menu
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  
  Set m_Host = Host
  m_Host.Server.AddMenu "&Producción", _
                        csMenuEnum.csMenuConfig, _
                        "Co&nfiguración", _
                        1, _
                        False, _
                        False, _
                        False, _
                        True, _
                        False, _
                        Nothing
  
  m_Host.Server.AddMenu "&B.O.M.", _
                        csPreProdListProductoBOM, _
                        "&Producción", _
                        0, True, _
                        False, _
                        False, _
                        False, _
                        False, _
                        Me
  
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuABMClick "CSProduccion2.cProductoBOM", Me, LNGGetText(1304, vbNullString), 0, csETablesProduccion.csProductoBOM
                                                        'B.O.M.
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim iTab As cIABMTabItem
  
  Const tab_general = 0
  Const tab_elaborado = 1
  Const tab_item = 2
  
  m_ObjAbm.Tabs.Clear
    
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = tab_general
  iTab.Name = C_strGeneral
    
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = tab_elaborado
  iTab.Name = LNGGetText(3045, vbNullString)  'Elaborados
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = tab_item
  iTab.Name = LNGGetText(1366, vbNullString)  'Insumos
   
  Dim c As cIABMProperty
  
  m_ObjAbm.Title2 = m_Nombre
  
  With m_ObjAbm.Properties
    .Clear
    
    With .Add(Nothing, cscPbmNombre)
      .PropertyType = cspText
      .Width = 6000
      .Name = C_strNombre
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
    End With
    
    With .Add(Nothing, cscPbmCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 50
      .Key = K_CODIGO
      .Value = m_Codigo
    End With
    
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Left = 5800
      .LeftNotChange = True
      .TopFromProperty = cscPbmCodigo
      .TopNotChange = True
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
    
    With .Add(Nothing, cscPbmDefault)
      .PropertyType = cspCheck
      .Left = 8100
      .LeftNotChange = True
      .LeftLabel = -1400
      .TopFromProperty = cscPbmCodigo
      .TopNotChange = True
      .Name = LNGGetText(3948, vbNullString) ' BOM por defecto
      .Key = K_DEFAULT
      .Value = CInt(m_Default)
    End With
    
    With .Add(Nothing, cscPbmFechaAuto)
      .PropertyType = cspDate
      .Name = LNGGetText(3046, vbNullString)  'Fecha Autorización
      .Key = K_FECHAAUTO
      .Value = m_FechaAuto
    End With
    
    With .Add(Nothing, cscPbmMerma)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 1100
      .Name = LNGGetText(3047, vbNullString)  'Merma
      .Key = K_MERMA
      .Value = m_Merma
    End With
    
    With .Add(Nothing, cscPbmVartipo)
      .PropertyType = cspList
      .Name = LNGGetText(3048, vbNullString)  'Variación Tipo
      .Key = K_VARTIPO
      .ListWhoSetItem = csListItemData
      .HelpId = m_Vartipo
      With .List.Add(Nothing)
        .Id = csEBOMVarTipo.csEBOMVT_Percent
        .Value = LNGGetText(1105, vbNullString)  'Porcentaje
      End With
      With .List.Add(Nothing)
        .Id = csEBOMVarTipo.csEBOMVT_Unit
        .Value = LNGGetText(1165, vbNullString)  'Unidad
      End With
    End With
    
    With .Add(Nothing, cscPbmVarpos)
      .PropertyType = cspNumeric
      .Left = 5800
      .TopFromProperty = cscPbmFechaAuto
      .Width = 1100
      .SubType = cspDouble
      .Name = LNGGetText(3049, vbNullString)  'Variación Positiva
      .Key = K_VARPOS
      .Value = m_Varpos
    End With
    
    With .Add(Nothing, cscPbmVarneg)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 1100
      .Name = LNGGetText(3050, vbNullString)  'Variación Negativa
      .Key = K_VARNEG
      .Value = m_Varneg
    End With
  
    With .Add(Nothing, cscPbmDescrip)
      .LeftFromProperty = cscPbmNombre
      .TopFromProperty = cscPbmVartipo
      .TopToPrevious = 440
      .PropertyType = cspText
      .SubType = cspMemo
      .Width = 6000
      .Height = 660
      .Name = C_strDescrip
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_Descrip
    End With

    Set c = .Add(Nothing, c_elaborados)

    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadElaborados(c) Then Exit Function
      .Name = c_elaborados
      .Key = K_ELABORADO
      .TabIndex = tab_elaborado
      .Enabled = pGetBOMEnabled()
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    m_ItemsDeletedE = vbNullString
    
    Set c = .Add(Nothing, c_items)
    
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItem(c) Then Exit Function
      .Name = c_items
      .Key = K_ITEMS
      .TabIndex = tab_item
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    m_ItemsDeletedI = vbNullString
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "select * from ProductoBOM where pbm_id = " & Id

  Dim rs As ADODB.Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscPbmId)
    m_Nombre = gDB.ValField(rs.fields, cscPbmNombre)
    m_Codigo = gDB.ValField(rs.fields, cscPbmCodigo)
    m_Descrip = gDB.ValField(rs.fields, cscPbmDescrip)
    m_FechaAuto = gDB.ValField(rs.fields, cscPbmFechaAuto)
    m_Merma = gDB.ValField(rs.fields, cscPbmMerma)
    m_Varpos = gDB.ValField(rs.fields, cscPbmVarpos)
    m_Varneg = gDB.ValField(rs.fields, cscPbmVarneg)
    m_Vartipo = gDB.ValField(rs.fields, cscPbmVartipo)
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_Default = gDB.ValField(rs.fields, cscPbmDefault)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Descrip = vbNullString
    m_FechaAuto = csNoDate
    m_Merma = 0
    m_Varpos = 0
    m_Varneg = 0
    m_Vartipo = False
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_Activo = True
    m_Default = False

  End If

  Load = True
End Function

Private Function pLoadElaborados(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_ProductoBOMEGet " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadElaborados", C_Module) Then Exit Function
  
  With Propiedad.Grid.Columns
    With .Add(Nothing)
      .Visible = False
      .Key = KI_PBME_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1367, vbNullString)  'Artículo
      .PropertyType = cspHelp
      .Table = csProducto
      .HelpFilter = "pr_seproduce <> 0"
      .Width = 2500
      .Key = KI_PR_ID_E
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1374, vbNullString)  'Cantidad
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Format = m_GeneralConfig.FormatDecCantidad
      .Width = 2000
      .Key = KI_PBME_CANTIDAD
    End With

    With .Add(Nothing)
      .Name = LNGGetText(3051, vbNullString)  'Cant. Tipo
      .PropertyType = cspList
      .Width = 2000
      .Key = KI_PBME_CANTTIPO
      With .List.Add(Nothing)
        .Id = csEBOMVarTipo.csEBOMVT_Percent
        .Value = LNGGetText(1105, vbNullString)  'Porcentaje
      End With
      With .List.Add(Nothing)
        .Id = csEBOMVarTipo.csEBOMVT_Unit
        .Value = LNGGetText(1165, vbNullString)  'Unidad
      End With
      Set .DefaultValue = New cABMGridRowValue
      .DefaultValue.Id = csEBOMVarTipo.csEBOMVT_Unit
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(3052, vbNullString)  'Var. +
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Format = m_GeneralConfig.FormatDecCantidad
      .Width = 2000
      .Key = KI_PBME_VARPOS
    End With

    With .Add(Nothing)
      .Name = LNGGetText(3053, vbNullString)  'Var. -
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Format = m_GeneralConfig.FormatDecCantidad
      .Width = 2000
      .Key = KI_PBME_VARNEG
    End With

    With .Add(Nothing)
      .Name = LNGGetText(3054, vbNullString)  'Var. Tipo
      .PropertyType = cspList
      .Width = 2000
      .Key = KI_PBME_VARTIPO
      With .List.Add(Nothing)
        .Id = csEBOMVarTipo.csEBOMVT_Percent
        .Value = LNGGetText(1105, vbNullString)  'Porcentaje
      End With
      With .List.Add(Nothing)
        .Id = csEBOMVarTipo.csEBOMVT_Unit
        .Value = LNGGetText(1165, vbNullString)  'Unidad
      End With
      Set .DefaultValue = New cABMGridRowValue
      .DefaultValue.Id = csEBOMVarTipo.csEBOMVT_Unit
    End With
  
  End With
  
  With Propiedad.Grid.Rows
  
    While Not rs.EOF
    
      With .Add(Nothing, rs(cscPbmeId).Value)
      
        With .Add(Nothing)
          .Value = rs(cscPbmeId).Value
          .Key = KI_PBME_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPrNombreCompra)
          .Id = gDB.ValField(rs.fields, cscPrId)
          .Key = KI_PR_ID_E
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPbmeCantidad)
          .Key = KI_PBME_CANTIDAD
        End With
      
        With .Add(Nothing)
          .Id = gDB.ValField(rs.fields, cscPbmeCanttipo)
          .Key = KI_PBME_CANTTIPO
        End With
          
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPbmeVarpos)
          .Key = KI_PBME_VARPOS
        End With
          
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPbmeVarneg)
          .Key = KI_PBME_VARNEG
        End With
          
        With .Add(Nothing)
          .Id = gDB.ValField(rs.fields, cscPbmeVartipo)
          .Key = KI_PBME_VARTIPO
        End With
          
      End With
      rs.MoveNext
    Wend
  
  End With
  
  pLoadElaborados = True
End Function

Private Function pLoadItem(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_ProductoBOMIGet " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItem", C_Module) Then Exit Function
  
  With Propiedad.Grid.Columns
    With .Add(Nothing)
      .Visible = False
      .Key = KI_PBMI_ID
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1367, vbNullString)  'Artículo
      .PropertyType = cspHelp
      .Table = csProducto
      .Width = 2500
      .Key = KI_PR_ID_I
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1374, vbNullString)  'Cantidad
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Format = m_GeneralConfig.FormatDecCantidad
      .Width = 2000
      .Key = KI_PBMI_CANTIDAD
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(3047, vbNullString)  'Merma
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Format = m_GeneralConfig.FormatDecCantidad
      .Width = 2500
      .Key = KI_PBMI_MERMA
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(3052, vbNullString)  'Var. +
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Format = m_GeneralConfig.FormatDecCantidad
      .Width = 2000
      .Key = KI_PBMI_VARPOS
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(3053, vbNullString)  'Var. -
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Format = m_GeneralConfig.FormatDecCantidad
      .Width = 2000
      .Key = KI_PBMI_VARNEG
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(3054, vbNullString)  'Var. Tipo
      .PropertyType = cspList
      .Width = 2000
      .Key = KI_PBMI_VARTIPO
      With .List.Add(Nothing)
        .Id = csEBOMVarTipo.csEBOMVT_Percent
        .Value = LNGGetText(1105, vbNullString)  'Porcentaje
      End With
      With .List.Add(Nothing)
        .Id = csEBOMVarTipo.csEBOMVT_Unit
        .Value = LNGGetText(1165, vbNullString)  'Unidad
      End With
      Set .DefaultValue = New cABMGridRowValue
      .DefaultValue.Id = csEBOMVarTipo.csEBOMVT_Unit
    End With

     With .Add(Nothing)
      .Name = LNGGetText(3055, vbNullString)  'Es Base
      .PropertyType = cspCheck
      .Width = 1000
      .Key = KI_PBMI_ESBASE
    End With
    
     With .Add(Nothing)
      .Name = LNGGetText(3056, vbNullString)  'Se Importa x Temporal
      .PropertyType = cspCheck
      .Width = 1000
      .Key = KI_PBMI_TEMP
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1223, vbNullString)  'Tipo
      .PropertyType = cspHelp
      .Table = csProductoBOMTipo
      .Width = 2500
      .Key = KI_PBMIT_ID
      Set .DefaultValue = New cABMGridRowValue
      .DefaultValue.Id = csEBOMIT_Normal
      .DefaultValue.Value = LNGGetText(3057, vbNullString)  'Normal
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1376, vbNullString)  'Alternativas
      .PropertyType = cspText
      .SubType = cspTextButton
      .Width = 1500
      .Key = KI_PBMIA_ID
    End With
    
  End With
    
  With Propiedad.Grid.Rows
    While Not rs.EOF
    
      With .Add(Nothing, rs(cscPbmiId).Value)
        
        With .Add(Nothing)
          .Value = rs(cscPbmiId).Value
          .Key = KI_PBMI_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPrNombreCompra)
          .Id = gDB.ValField(rs.fields, cscPrId)
          .Key = KI_PR_ID_I
        End With
      
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPbmiCantidad)
          .Key = KI_PBME_CANTIDAD
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPbmiMerma)
          .Key = KI_PBMI_MERMA
        End With
          
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPbmiVarpos)
          .Key = KI_PBMI_VARPOS
        End With
          
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPbmiVarneg)
          .Key = KI_PBMI_VARNEG
        End With
          
        With .Add(Nothing)
          .Id = gDB.ValField(rs.fields, cscPbmiVartipo)
          .Key = KI_PBMI_VARTIPO
        End With
      
        With .Add(Nothing)
          .Id = gDB.ValField(rs.fields, cscPbmiEsBase)
          .Key = KI_PBMI_ESBASE
        End With
      
        With .Add(Nothing)
          .Id = gDB.ValField(rs.fields, cscPbmiTemp)
          .Key = KI_PBMI_TEMP
        End With
      
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPbmitNombre)
          .Id = gDB.ValField(rs.fields, cscPbmitId)
          .Key = KI_PBMIT_ID
        End With
      
        With .Add(Nothing)
          .Value = vbNullString
          .Key = KI_PBMIA_ID
        End With
      
      End With
      
      rs.MoveNext
    Wend
  
  End With
  
  Dim CurGroup     As Long
  Dim Alternativas As String
  
  Set rs = rs.NextRecordset
  
  While Not rs.EOF
    
    ' Si cambie de grupo
    If CurGroup <> gDB.ValField(rs.fields, cscPbmiId) Then
    
      pSetAlternativasInRow CurGroup, Alternativas
      Alternativas = ""
    
      CurGroup = gDB.ValField(rs.fields, cscPbmiId)
    End If
    
    Alternativas = Alternativas & gDB.ValField(rs.fields, _
                                  cscPrNombreCompra) & ", "
    rs.MoveNext
  Wend
  
  pSetAlternativasInRow CurGroup, Alternativas
  
  pLoadItem = True
End Function

Private Sub pSetAlternativasInRow(ByVal CurrGroup As Long, _
                                  ByVal Alternativas As String)
  Dim Row As cIABMGridRow
  
  If CurrGroup = 0 Then Exit Sub
  
  For Each Row In m_ObjAbm.Properties.Item(c_items).Grid.Rows
    If Val(pCell(Row, KI_PBMI_ID).Value) = CurrGroup Then
      pCell(Row, KI_PBMIA_ID).Value = RemoveLastColon(Trim$(Alternativas))
      Exit Sub
    End If
  Next
End Sub

Private Function pIsEmptyRowI(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_PR_ID_I
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_PBMI_CANTIDAD, KI_PBMI_MERMA, KI_PBMI_VARNEG, KI_PBMI_VARPOS
        If Not ValEmpty(Cell.Value, csDouble) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowI = bRowIsEmpty
End Function

Private Function pIsEmptyRowE(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_PR_ID_E
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_PBME_CANTIDAD
        If Not ValEmpty(Cell.Value, csDouble) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowE = bRowIsEmpty
End Function

Private Function pValidateRowE(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_PR_ID_E
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(1364, vbNullString, strRow) 'Debe indicar un artículo (1)
          Exit Function
        End If
      Case KI_PBME_CANTIDAD
        If ValEmpty(Cell.Value, csDouble) Then
          MsgInfo LNGGetText(1365, vbNullString, strRow) 'Debe indicar una cantidad (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowE = True
End Function

Private Function pValidateRowI(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      'Case KI_PR_ID_I
      '  If ValEmpty(Cell.Id, csId) Then
      '    MsgInfo "Debe indicar un artículo" & strRow
      '    Exit Function
      '  End If
      Case KI_PBMI_CANTIDAD
        If ValEmpty(Cell.Value, csDouble) Then
          MsgInfo LNGGetText(1365, vbNullString, strRow) 'Debe indicar una cantidad (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowI = True
End Function

Private Function pSaveElaborados() As Boolean
  Dim register  As cRegister
  Dim fields    As cFields
  Dim IProperty As cIABMProperty
  
  With m_ObjAbm.Properties.Item(c_elaborados)
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscPbmeId
        .Table = csTProductoBOMElaborado
        .Id = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_PBME_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_PR_ID_E
              fields.Add2 cscPrId, Cell.Id, csId
            Case KI_PBME_CANTIDAD
              fields.Add2 cscPbmeCantidad, Val(Cell.Value), csDouble
            Case KI_PBME_CANTTIPO
              fields.Add2 cscPbmeCanttipo, Cell.Id, csInteger
            Case KI_PBME_VARPOS
              fields.Add2 cscPbmeVarpos, Val(Cell.Value), csDouble
            Case KI_PBME_VARNEG
              fields.Add2 cscPbmeVarneg, Val(Cell.Value), csDouble
            Case KI_PBME_VARTIPO
              fields.Add2 cscPbmeVartipo, Cell.Id, csInteger
          End Select
        Next
        
        fields.Add2 cscPbmId, m_Id, csId
        
        fields.HaveLastUpdate = False
        fields.HaveWhoModify = False
            
      End With
      
      If Not gDB.Save(register, , "pSaveElaborados", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedE) And Not m_Copy Then
    m_ItemsDeletedE = RemoveLastColon(m_ItemsDeletedE)
    sqlstmt = "delete ProductoBOMElaborado where pbme_id in (" & m_ItemsDeletedE & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveElaborados", C_Module) Then Exit Function
  End If
  
  pSaveElaborados = True
End Function

Private Function pSaveItems() As Boolean
  
  Dim pbmit_id  As Boolean
  Dim register  As cRegister
  Dim fields    As cFields
  Dim IProperty As cIABMProperty
  
  With m_ObjAbm.Properties.Item(c_items)
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscPbmiId
        .Table = csTProductoBOMItem
        .Id = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_PBMI_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_PR_ID_I
              fields.Add2 cscPrId, Cell.Id, csId
            Case KI_PBMI_CANTIDAD
              fields.Add2 cscPbmiCantidad, Val(Cell.Value), csDouble
            Case KI_PBMI_MERMA
              fields.Add2 cscPbmiMerma, Val(Cell.Value), csDouble
            Case KI_PBMI_VARPOS
              fields.Add2 cscPbmiVarpos, Val(Cell.Value), csDouble
            Case KI_PBMI_VARNEG
              fields.Add2 cscPbmiVarneg, Val(Cell.Value), csDouble
            Case KI_PBMI_VARTIPO
              fields.Add2 cscPbmiVartipo, Cell.Id, csInteger
            Case KI_PBMI_ESBASE
              fields.Add2 cscPbmiEsBase, Cell.Id, csBoolean
            Case KI_PBMI_TEMP
              fields.Add2 cscPbmiTemp, Cell.Id, csBoolean
            Case KI_PBMIT_ID
              pbmit_id = Cell.Id
              If pbmit_id = csNO_ID Then pbmit_id = csEBOMIT_Normal
              fields.Add2 cscPbmitId, Cell.Id, csId
          End Select
        Next
        
        fields.Add2 cscPbmId, m_Id, csId
        
        fields.HaveLastUpdate = False
        fields.HaveWhoModify = False
        
      End With
      
      If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedI) And Not m_Copy Then
    m_ItemsDeletedI = RemoveLastColon(m_ItemsDeletedI)
    sqlstmt = "delete ProductoBOMItem where pbmi_id in (" & m_ItemsDeletedI & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItems", C_Module) Then Exit Function
  End If
  
  Dim rs As ADODB.Recordset
  sqlstmt = "sp_ProductoBOMSave " & m_Id
  If Not gDB.OpenRs(sqlstmt, rs, , , , "pSaveItems", C_Module) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim msg As String
  msg = gDB.ValField(rs.fields, 1)
  
  If msg <> vbNullString Then MsgWarning msg
  
  pSaveItems = gDB.ValField(rs.fields, 0)
End Function

Private Function pGetBOMEnabled() As Boolean
  If m_Id Then
    Dim sqlstmt As String
    Dim rs      As Recordset
    sqlstmt = "sp_productoBOMEsEditable " & m_Id
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    If rs.EOF Then Exit Function
    If gDB.ValField(rs.fields, 0) Then
      pGetBOMEnabled = True
    End If
  Else
    pGetBOMEnabled = True
  End If
End Function

Private Sub pAddAlternativa(ByRef Row As cIABMGridRow)
  Dim AbmAlt As cProductoBOMItemA
  Set AbmAlt = New cProductoBOMItemA

  AbmAlt.Edit Val(pCell(Row, KI_PBMI_ID).Value), m_Id
  
  pCell(Row, KI_PBMIA_ID).Value = RemoveLastColon(Trim$(AbmAlt.Alternativas))
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  On Error Resume Next
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load

  c_ErrorSave = LNGGetText(3058, vbNullString) 'Error al grabar Producto BOM

GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
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
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
