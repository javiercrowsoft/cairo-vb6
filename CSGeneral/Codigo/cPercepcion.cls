VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPercepcion"
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
' cPercepcion
' 27-04-04

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cPercepcion"

Private Const c_Items = "Items"
Private Const c_empresas = "empresas"
Private Const c_provincias = "provincias"
Private Const c_CatFiscal = "CatFiscal"

Private Const K_PERCT_ID                       As Integer = 1
Private Const K_NOMBRE                         As Integer = 2
Private Const K_CODIGO                         As Integer = 3
Private Const K_IMPORTEMINIMO                  As Integer = 4
Private Const K_REGIMENSICORE                  As Integer = 5
Private Const K_TA_ID                          As Integer = 6
Private Const K_DESCRIP                        As Integer = 7
Private Const K_ACTIVO                         As Integer = 8
Private Const K_ESIIBB                         As Integer = 13
Private Const K_ITEMS                          As Integer = 9

Private Const K_CAT_FISCAL                     As Integer = 10
Private Const K_PROVINCIAS                     As Integer = 11
Private Const K_EMPRESAS                       As Integer = 12

Private Const KI_PERCI_ID                       As Integer = 2
Private Const KI_IMPORTEDESDE                   As Integer = 3
Private Const KI_IMPORTEHASTA                   As Integer = 4
Private Const KI_PORCENTAJE                     As Integer = 5
Private Const KI_IMPORTEFIJO                    As Integer = 6

Private Const KI_PERCCATF_ID                    As Integer = 1
Private Const KI_CATF_ID                        As Integer = 2
Private Const KI_BASE                           As Integer = 3

Private Const KI_PERCPRO_ID                     As Integer = 1
Private Const KI_PRO_ID                         As Integer = 2

Private Const KI_PERCEMP_ID                     As Integer = 1
Private Const KI_EMP_ID                         As Integer = 2

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Perct_id                     As Long
Private m_PercepcionTipo               As String
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_ImporteMinimo                As Double
Private m_RegimenSicore                As String
Private m_Ta_id                        As Long
Private m_Talonario                    As String
Private m_descrip                      As String
Private m_esIIBB                       As Boolean
Private m_Activo                       As Boolean

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long
Private m_Copy              As Boolean

Private m_ItemsDeleted      As String
Private m_CatFiscalDeleted  As String
Private m_ProvinciasDeleted As String

Private m_Host              As CSMenu.cIMenuHost
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

  Doc.ClientTable = csTPercepcion
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, C_ShowDocDigital, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  cIEditGeneric_Edit csNO_ID
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  Select Case MessageID
  
    Case MSG_DOC_INFO
    
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      
      CSKernelClient2.ShowHelp AbmGen.hWnd, _
                               vbNullString, _
                               vbNullString, _
                               csPreGNewPercepcion
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    Case Else
      cIABMClient_MessageEx = True
  End Select
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True

  With m_ObjAbm.Properties(cscPercCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscPercNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscPercCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscPercNombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim register   As cRegister
  Dim fields     As cFields
  Dim LastId     As Long

  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscPercId
    .Table = csTPercepcion
    
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
        Case K_PERCT_ID
          fields.Add2 cscPerctId, .HelpId, csId
        Case K_NOMBRE
          fields.Add2 cscPercNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscPercCodigo, .Value, csText
        Case K_IMPORTEMINIMO
          fields.Add2 cscPercImporteMinimo, .Value, csCurrency
        Case K_REGIMENSICORE
          fields.Add2 cscPercRegimenSicore, .Value, csText
        Case K_TA_ID
          fields.Add2 cscTaId, .HelpId, csId
        Case K_DESCRIP
          fields.Add2 cscPercDescrip, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
        Case K_ESIIBB
          fields.Add2 cscPercEsIIBB, .Value, csBoolean
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
                                                          
  If Not gDB.SaveEx(register, , _
                    cscPercCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.Id
  
  If Not pSaveItems() Then GoTo SaveError
  If Not pSaveCatFiscal() Then GoTo SaveError
  If Not pSaveProvincias() Then GoTo SaveError
  If Not pSaveItemsEmpresa() Then GoTo SaveError
  
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
                      'Percepciones
  cIABMClient_Title = LNGGetText(1248, vbNullString)
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_PERCT_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1249, vbNullString)  'Debe indicar un tipo de percepción
            Exit Function
          End If
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

' Grilla
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
      Id = Val(pCell(Row, KI_PERCI_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & Id & C_StrColon
    
    Case K_CAT_FISCAL
      Id = Val(pCell(Row, KI_PERCCATF_ID).Value)
      If Id <> csNO_ID Then m_CatFiscalDeleted = m_CatFiscalDeleted & Id & C_StrColon
    
    Case K_PROVINCIAS
      Id = Val(pCell(Row, KI_PERCPRO_ID).Value)
      If Id <> csNO_ID Then m_ProvinciasDeleted = m_ProvinciasDeleted & Id & C_StrColon
    
    Case K_EMPRESAS
      cIABMClientGrid_DeleteRow = False
      Exit Function
  
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowItems(Row, RowIndex)
    Case K_PROVINCIAS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowProvincia(Row, RowIndex)
    Case K_CAT_FISCAL
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowCatFiscal(Row, RowIndex)
    Case K_EMPRESAS
      cIABMClientGrid_IsEmptyRow = False
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

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_ValidateRow = pValidateRowItems(Row, RowIndex)
    Case K_CAT_FISCAL
      cIABMClientGrid_ValidateRow = pValidateRowCatFiscal(Row, RowIndex)
    Case K_PROVINCIAS
      cIABMClientGrid_ValidateRow = pValidateRowProvincia(Row, RowIndex)
    Case K_EMPRESAS
      cIABMClientGrid_ValidateRow = True
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListPercepcion)
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
    If Not SecurityCanAccess(csPreGDeletePercepcion) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "sp_PercepcionDelete " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewPercepcion) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditPercepcion) Then Exit Function
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

' Menu
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
  
  m_Host.Server.AddMenu C_MenuContabilidad, csMenuConfigContabilidad, C_MenuConfig, 0, True, False, True, False, True, Nothing
                          '&Percepción
  m_Host.Server.AddMenu LNGGetText(1251, vbNullString), csPreGListPercepcion, C_MenuContabilidad, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                      'Percepción
  m_Host.MenuABMClick "CSGeneral2.cPercepcion", Me, LNGGetText(1252, vbNullString), 0, csETablasGeneral.csPercepcion
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  Dim c As cIABMProperty
  
  m_ObjAbm.Title2 = m_Nombre
  
  With m_ObjAbm.Tabs
    
    .Clear
      
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
    
    With .Add(Nothing)
      .Index = 1
      .Name = c_Items
    End With
    
    With .Add(Nothing)
      .Index = 2
      .Name = LNGGetText(1181, vbNullString) 'Categoria Fiscale
    End With
    
    With .Add(Nothing)
      .Index = 3
      .Name = LNGGetText(1410, vbNullString) 'Provincias
    End With
    
    With .Add(Nothing)
      .Index = 4
      .Name = LNGGetText(1171, vbNullString) 'Empresas
    End With
    
  End With
  
  With m_ObjAbm.Properties
    
    .Clear

    With .Add(Nothing, cscPercNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
      .Width = 6250
    End With
    
    With .Add(Nothing, cscPercCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 15
      .Key = K_CODIGO
      .Value = m_Codigo
    End With

    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
  
    With .Add(Nothing, cscPerctId)
      .PropertyType = cspHelp
      .Table = csPercepcionTipo
      .Name = LNGGetText(1253, vbNullString) 'Tipo de Percepción
      .Key = K_PERCT_ID
      .Value = m_PercepcionTipo
      .HelpId = m_Perct_id
    End With
    
    With .Add(Nothing, cscPercImporteMinimo)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1255, vbNullString) 'Importe Mínimo
      .Key = K_IMPORTEMINIMO
      .Value = m_ImporteMinimo
    End With

    With .Add(Nothing, cscPercRegimenSicore)
      .PropertyType = cspText
      .Name = LNGGetText(1254, vbNullString) 'Régimen Sicore
      .TopFromProperty = cscPercCodigo
      .Left = 5500
      .Size = 50
      .Key = K_REGIMENSICORE
      .Value = m_RegimenSicore
    End With
    
    With .Add(Nothing, cscTaId)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(1256, vbNullString) 'Talonario
      .Key = K_TA_ID
      .Value = m_Talonario
      .HelpId = m_Ta_id
    End With
  
    With .Add(Nothing, cscPercEsIIBB)
      .PropertyType = cspCheck
      .Name = LNGGetText(3753, vbNullString) 'Es de IIBB
      .Key = K_ESIIBB
      .Value = CInt(m_esIIBB)
    End With
  
    With .Add(Nothing, cscPercDescrip)
      .PropertyType = cspText
      .LeftFromProperty = cscActivo
      .TopFromProperty = cscPercImporteMinimo
      .TopToPrevious = 440
      .SubType = cspMemo
      .Name = C_strDescrip
      .Size = 255
      .Width = 6250
      .Height = 600
      .Key = K_DESCRIP
      .Value = m_descrip
    End With
  
    Set c = .Add(Nothing, c_Items)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItems(c) Then Exit Function
      .Name = c_Items
      .Key = K_ITEMS
      .TabIndex = 1
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_ItemsDeleted = vbNullString
  
    Set c = .Add(Nothing, c_CatFiscal)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadCatFiscal(c) Then Exit Function
      .Name = c_CatFiscal
      .Key = K_CAT_FISCAL
      .TabIndex = 2
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_CatFiscalDeleted = vbNullString
  
    Set c = .Add(Nothing, c_provincias)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadProvincias(c) Then Exit Function
      .Name = c_provincias
      .Key = K_PROVINCIAS
      .TabIndex = 3
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_ProvinciasDeleted = vbNullString
  
    Set c = .Add(Nothing, c_empresas)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadEmpresas(c) Then Exit Function
      .Name = c_empresas
      .Key = K_EMPRESAS
      .TabIndex = 4
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As Recordset

  sqlstmt = "sp_percepcionGet " & Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Perct_id = gDB.ValField(rs.fields, cscPerctId)
    m_PercepcionTipo = gDB.ValField(rs.fields, cscPerctNombre)
    m_Id = gDB.ValField(rs.fields, cscPercId)
    m_Nombre = gDB.ValField(rs.fields, cscPercNombre)
    m_Codigo = gDB.ValField(rs.fields, cscPercCodigo)
    m_descrip = gDB.ValField(rs.fields, cscPercDescrip)
    m_ImporteMinimo = gDB.ValField(rs.fields, cscPercImporteMinimo)
    m_RegimenSicore = gDB.ValField(rs.fields, cscPercRegimenSicore)
    m_Ta_id = gDB.ValField(rs.fields, cscTaId)
    m_Talonario = gDB.ValField(rs.fields, cscTaNombre)
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_esIIBB = gDB.ValField(rs.fields, cscPercEsIIBB)

  Else
  
    m_Perct_id = csNO_ID
    m_PercepcionTipo = vbNullString
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_descrip = vbNullString
    m_Activo = True
    m_esIIBB = False
    m_ImporteMinimo = 0
    m_RegimenSicore = vbNullString
    m_Ta_id = csNO_ID
    m_Talonario = vbNullString
  End If

  Load = True
End Function

Private Function pSaveItems() As Boolean
  Dim register As cRegister
  Dim fields   As cFields
  
  With m_ObjAbm.Properties(c_Items)
  
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscPerciId
        .Table = csTPercepcionItem
        .Id = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_PERCI_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_IMPORTEDESDE
              fields.Add2 cscPerciImporteDesde, Cell.Value, csCurrency
            Case KI_IMPORTEHASTA
              fields.Add2 cscPerciImporteHasta, Cell.Value, csCurrency
            Case KI_PORCENTAJE
              fields.Add2 cscPerciPorcentaje, Cell.Value, csCurrency
            Case KI_IMPORTEFIJO
              fields.Add2 cscPerciImportefijo, Cell.Value, csCurrency
          End Select
        Next
        
        fields.Add2 cscPercId, m_Id, csId
        
        fields.HaveLastUpdate = True
        fields.HaveWhoModify = True
        
      End With
                                                              
      If Not gDB.Save(register, , C_pSaveItemsFunc, C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeleted) And Not m_Copy Then
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    sqlstmt = "delete PercepcionItem where perci_id in (" & m_ItemsDeleted & ")"
  
    If Not gDB.Execute(sqlstmt, C_pSaveItemsFunc, C_Module) Then Exit Function
  End If
  
  pSaveItems = True
End Function

Private Function pSaveCatFiscal() As Boolean
  Dim register As cRegister
  Dim fields   As cFields
  
  With m_ObjAbm.Properties(c_CatFiscal)
  
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscPercCatfId
        .Table = csTPercepcionCategoriaFiscal
        .Id = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_PERCCATF_ID
              .Id = Val(Cell.Value)
            Case KI_CATF_ID
              fields.Add2 cscCatfId, Cell.Id, csId
            Case KI_BASE
              fields.Add2 cscPercCatfBase, Cell.Id, csInteger
          End Select
        Next
        
        fields.Add2 cscPercId, m_Id, csId
        
        fields.HaveLastUpdate = False
        fields.HaveWhoModify = False
        
      End With
                                                              
      If Not gDB.Save(register, , "pSaveCatFiscal", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_CatFiscalDeleted) And Not m_Copy Then
    m_CatFiscalDeleted = RemoveLastColon(m_CatFiscalDeleted)
    sqlstmt = "delete PercepcionCategoriaFiscal where perccatf_id in (" & m_CatFiscalDeleted & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveCatFiscal", C_Module) Then Exit Function
  End If
  
  pSaveCatFiscal = True
End Function

Private Function pSaveProvincias() As Boolean
  Dim register As cRegister
  Dim fields   As cFields

  With m_ObjAbm.Properties.Item(c_provincias)
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscPercProId
        .Table = csTPercepcionProvincia
        .Id = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_PERCPRO_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_PRO_ID
              fields.Add2 cscProId, Cell.Id, csId
          End Select
        Next
        
        fields.Add2 cscPercId, m_Id, csId
        
        fields.HaveLastUpdate = False
        fields.HaveWhoModify = False
      
      End With
                                                              
      If Not gDB.Save(register, , "pSaveProvincias", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ProvinciasDeleted) And Not m_Copy Then
    m_ProvinciasDeleted = RemoveLastColon(m_ProvinciasDeleted)
    sqlstmt = "delete PercepcionProvincia where percpro_id in (" & m_ProvinciasDeleted & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveProvincias", C_Module) Then Exit Function
  End If
  
  pSaveProvincias = True
End Function

Private Function pSaveItemsEmpresa() As Boolean
  Dim register  As cRegister
  Dim fields    As cFields

  Dim sqlstmt As String
  sqlstmt = "delete PercepcionEmpresa where perc_id = " & m_Id
  If Not gDB.Execute(sqlstmt, "pSaveItemsEmpresa", C_Module) Then Exit Function

  With m_ObjAbm.Properties.Item(c_empresas)
    Dim Row  As cIABMGridRow
    
    For Each Row In .Grid.Rows
    
      If pCell(Row, KI_PERCEMP_ID).Id Then
        
        Set register = New cRegister
        
        With register
          Set fields = .fields
          .fieldId = cscPercEmpId
          .Table = csTPercepcionEmpresa
          .Id = csNew
          
          fields.Add2 cscEmpId, pCell(Row, KI_EMP_ID).Id, csId
          
          fields.Add2 cscPercId, m_Id, csId
          
          fields.HaveLastUpdate = False
          fields.HaveWhoModify = False
        End With
                                                                    
        If Not gDB.Save(register, , "pSaveItemsEmpresa", C_Module, c_ErrorSave) Then Exit Function
      End If
    Next
  End With
  
  pSaveItemsEmpresa = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select * from PercepcionItem where perc_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  With Propiedad.Grid

    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PERCI_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1257, vbNullString)  'Importe Desde
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1500
        .Format = "#,###,##0.00"
        .Key = KI_IMPORTEDESDE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1258, vbNullString)  'Importe Hasta
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1500
        .Format = "#,###,##0.00"
        .Key = KI_IMPORTEHASTA
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1259, vbNullString)  'Importe Fijo
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1500
        .Format = "#,###,##0.00"
        .Key = KI_IMPORTEFIJO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1105, vbNullString)  'Porcentaje
        .PropertyType = cspNumeric
        .SubType = cspPercent
        .Width = 1500
        .Key = KI_PORCENTAJE
      End With
    End With
    
    With .Rows
    
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscPerciId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscPerciId).Value
            .Key = KI_PERCI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPerciImporteDesde)
            .Key = KI_IMPORTEDESDE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPerciImporteHasta)
            .Key = KI_IMPORTEHASTA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPerciImportefijo)
            .Key = KI_IMPORTEFIJO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPerciPorcentaje)
            .Key = KI_PORCENTAJE
          End With
          
        End With
        
        rs.MoveNext
      Wend
    
    End With
  End With
  
  pLoadItems = True
End Function

Private Function pLoadCatFiscal(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select p.*, catf_nombre " & _
            "from PercepcionCategoriaFiscal p inner join CategoriaFiscal catf " & _
                               "on p.catf_id = catf.catf_id " & _
            "where perc_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCatFiscal", C_Module) Then Exit Function
  
  With Propiedad.Grid

    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PERCCATF_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1181, vbNullString)  'Categoria Fiscal
        .PropertyType = cspHelp
        .Table = csCategoriaFiscal
        .Width = 1500
        .Key = KI_CATF_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2550, vbNullString)  'Base
        .PropertyType = cspList
        .Width = 1500
        With .List
          With .Add(Nothing)
            .Id = csE_PercepcionBase.csEPB_Neto
            .Value = LNGGetText(1581, vbNullString) 'Neto
          End With
          With .Add(Nothing)
            .Id = csE_PercepcionBase.csEPB_NetoGravado
            .Value = LNGGetText(2551, vbNullString) 'Neto Gravado
          End With
          With .Add(Nothing)
            .Id = csE_PercepcionBase.csEPB_Total
            .Value = LNGGetText(1584, vbNullString) 'Total
          End With
        End With
        .Key = KI_BASE
      End With
      
    End With
    
    With .Rows
    
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscPercCatfId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscPercCatfId).Value
            .Key = KI_PERCCATF_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCatfNombre)
            .Id = gDB.ValField(rs.fields, cscCatfId)
            .Key = KI_CATF_ID
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, cscPercCatfBase)
            .Key = KI_BASE
          End With
          
        End With
        
        rs.MoveNext
      Wend
    
    End With
  End With
  
  pLoadCatFiscal = True
End Function

Private Function pLoadProvincias(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select p.*,pro_nombre " & _
            "from PercepcionProvincia p inner join Provincia pro " & _
                            "on p.pro_id = pro.pro_id " & _
            "where perc_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadProvincias", C_Module) Then Exit Function
  
  With Propiedad.Grid

    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PERCPRO_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1080, vbNullString)  'Provincia
        .PropertyType = cspHelp
        .Table = csProvincia
        .Width = 1500
        .Key = KI_PRO_ID
      End With
      
    End With
    
    With .Rows
    
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscPercProId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscPercProId).Value
            .Key = KI_PERCPRO_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscProNombre)
            .Id = gDB.ValField(rs.fields, cscProId)
            .Key = KI_PRO_ID
          End With
          
        End With
        
        rs.MoveNext
      Wend
    
    End With
  End With
  
  pLoadProvincias = True
End Function

Private Function pLoadEmpresas(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select e.emp_id,emp_nombre,percemp_id" & _
            " from empresa e left join percepcionempresa ep" & _
                    " on  e.emp_id = ep.emp_id" & _
                    " and ep.perc_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadEmpresas", C_Module) Then Exit Function
  
  With Propiedad.Grid
  
    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1114, vbNullString)  'Empresa
        .PropertyType = cspText
        .Width = 3500
        .Key = KI_EMP_ID
      End With
      
      With .Add(Nothing)
        .Width = 800
        .PropertyType = cspCheck
        .Key = KI_PERCEMP_ID
      End With
      
    End With
  
    With .Rows
    
      .Clear
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscEmpId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscEmpId).Value
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscEmpNombre)
            .Id = rs(cscEmpId).Value
            .Key = KI_EMP_ID
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, cscPercEmpId)
            .Value = .Id
            .Key = KI_PERCEMP_ID
          End With
          
        End With
        
        rs.MoveNext
      Wend
    
    End With
  End With
  
  pLoadEmpresas = True
End Function

Private Function pIsEmptyRowItems(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_IMPORTEDESDE
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_IMPORTEHASTA
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowItems = bRowIsEmpty
End Function

Private Function pIsEmptyRowCatFiscal(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CATF_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowCatFiscal = bRowIsEmpty
End Function

Private Function pIsEmptyRowProvincia(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_PRO_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowProvincia = bRowIsEmpty
End Function

Private Function pValidateRowItems(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_IMPORTEHASTA
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(1260, vbNullString, strRow)
                'Debe indicar un Importe Hasta
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowItems = True
End Function

Private Function pValidateRowCatFiscal(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CATF_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(1109, vbNullString, strRow)
                            'Debe indicar una categoria
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowCatFiscal = True
End Function

Private Function pValidateRowProvincia(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
        Case KI_PRO_ID
          If ValEmpty(Cell.Id, csId) Then
            MsgInfo LNGGetText(1077, vbNullString, strRow)
                              'Debe indicar una provincia (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowProvincia = True
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error Resume Next
  c_ErrorSave = LNGGetText(1247, vbNullString) 'Error al grabar Percepción
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
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
