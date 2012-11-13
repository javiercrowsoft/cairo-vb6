VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRetencion"
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
' cRetencion
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
Private Const C_Module = "cRetencion"

Private Const c_Items = "Items"
Private Const c_provincias = "provincias"
Private Const c_CatFiscal = "CatFiscal"

Private Const K_RETT_ID                        As Integer = 1
Private Const K_NOMBRE                         As Integer = 2
Private Const K_CODIGO                         As Integer = 3
Private Const K_IMPORTEMINIMO                  As Integer = 4
Private Const K_REGIMENSICORE                  As Integer = 5
Private Const K_TA_ID                          As Integer = 6
Private Const K_DESCRIP                        As Integer = 7
Private Const K_ACTIVO                         As Integer = 8
Private Const K_IBC_ID                         As Integer = 12
Private Const K_ACUMULAPOR                     As Integer = 13
Private Const K_TIPOMINIMO                     As Integer = 14
Private Const K_ITEMS                          As Integer = 9

Private Const K_CAT_FISCAL                     As Integer = 10
Private Const K_PROVINCIAS                     As Integer = 11

Private Const K_ESIIBB                         As Integer = 15

Private Const KI_RETI_ID                        As Integer = 2
Private Const KI_IMPORTEDESDE                   As Integer = 3
Private Const KI_IMPORTEHASTA                   As Integer = 4
Private Const KI_PORCENTAJE                     As Integer = 5
Private Const KI_IMPORTEFIJO                    As Integer = 6

Private Const KI_RETCATF_ID                     As Integer = 1
Private Const KI_CATF_ID                        As Integer = 2
Private Const KI_BASE                           As Integer = 3

Private Const KI_RETPRO_ID                      As Integer = 1
Private Const KI_PRO_ID                         As Integer = 2

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Rett_id                      As Long
Private m_RetencionTipo                As String
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_ImporteMinimo                As Double
Private m_RegimenSicore                As String
Private m_Ta_id                        As Long
Private m_Talonario                    As String

Private m_Ibc_id                       As Long
Private m_IGBCategoria                 As String

Private m_AcumulaPor                   As csE_RetencionTipoAcumulado
Private m_TipoMinimo                   As csE_RetencionTipoMinimo

Private m_esIIBB                       As Boolean

Private m_descrip                      As String
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

  Doc.ClientTable = csTRetencion
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
                               csPreGNewRetencion
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

  With m_ObjAbm.Properties(cscRetCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscRetNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscRetCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscRetNombre)
  
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
    .fieldId = cscRetId
    .Table = csTRetencion
    
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
        Case K_RETT_ID
          fields.Add2 cscRettId, .HelpId, csId
        Case K_NOMBRE
          fields.Add2 cscRetNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscRetCodigo, .Value, csText
        Case K_IMPORTEMINIMO
          fields.Add2 cscRetImporteMinimo, .Value, csCurrency
        Case K_REGIMENSICORE
          fields.Add2 cscRetRegimenSicore, .Value, csText
        Case K_TA_ID
          fields.Add2 cscTaId, .HelpId, csId
        Case K_IBC_ID
          fields.Add2 cscIbcId, .HelpId, csId
        Case K_ACUMULAPOR
          fields.Add2 cscRetAcumulaPor, .ListItemData, csInteger
        Case K_TIPOMINIMO
          fields.Add2 cscRetTipoMinimo, .ListItemData, csInteger
        Case K_ESIIBB
          fields.Add2 cscRetEsIIBB, .Value, csBoolean
        Case K_DESCRIP
          fields.Add2 cscRetDescrip, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
                                                            
  If Not gDB.SaveEx(register, , _
                    cscRetCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.Id
  
  If Not pSaveItems() Then GoTo SaveError
  If Not pSaveCatFiscal() Then GoTo SaveError
  If Not pSaveProvincias() Then GoTo SaveError
  
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
    cIABMClient_Title = LNGGetText(1393, vbNullString)  'Retenciones
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_RETT_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1418, vbNullString)
                  'Debe indicar un tipo de retención
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
      Id = Val(pCell(Row, KI_RETI_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & Id & C_StrColon
    
    Case K_CAT_FISCAL
      Id = Val(pCell(Row, KI_RETCATF_ID).Value)
      If Id <> csNO_ID Then m_CatFiscalDeleted = m_CatFiscalDeleted & Id & C_StrColon
    
    Case K_PROVINCIAS
      Id = Val(pCell(Row, KI_RETPRO_ID).Value)
      If Id <> csNO_ID Then m_ProvinciasDeleted = m_ProvinciasDeleted & Id & C_StrColon
    
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListRetencion)
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
    If Not SecurityCanAccess(csPreGDeleteRetencion) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "sp_RetencionDelete " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewRetencion) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditRetencion) Then Exit Function
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
                          '&Retención
  m_Host.Server.AddMenu LNGGetText(1419, vbNullString), csPreGListRetencion, C_MenuContabilidad, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                      'Retención
  m_Host.MenuABMClick "CSGeneral2.cRetencion", Me, LNGGetText(1403, vbNullString), 0, csETablasGeneral.csRetencion
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  Dim c As cIABMProperty
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 6000
  
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
  
  End With
  
  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, cscRetNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
      .Width = 6250
    End With
    
    With .Add(Nothing, cscRetCodigo)
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
    
    With .Add(Nothing, cscRettId)
      .PropertyType = cspHelp
      .Table = csRetencionTipo
      .Name = LNGGetText(1420, vbNullString)   'Tipo de Retención
      .Key = K_RETT_ID
      .Value = m_RetencionTipo
      .HelpId = m_Rett_id
    End With
    
    With .Add(Nothing, cscRetImporteMinimo)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1255, vbNullString)   'Importe Minimo
      .Key = K_IMPORTEMINIMO
      .Value = m_ImporteMinimo
      .Width = 1000
    End With
    
    With .Add(Nothing, cscRetEsIIBB)
      .PropertyType = cspCheck
      .Name = LNGGetText(3753, vbNullString) 'Es de IIBB
      .Key = K_ESIIBB
      .Value = CInt(m_esIIBB)
    End With
    
    With .Add(Nothing, cscRetRegimenSicore)
      .PropertyType = cspText
      .TopFromProperty = cscRetCodigo
      .Left = 5500
      .Name = LNGGetText(1254, vbNullString)   'Regimen Sicore
      .Size = 50
      .Key = K_REGIMENSICORE
      .Value = m_RegimenSicore
    End With
    
    With .Add(Nothing, cscTaId)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(1256, vbNullString)   'Talonario
      .Key = K_TA_ID
      .Value = m_Talonario
      .HelpId = m_Ta_id
    End With
    
    With .Add(Nothing, cscIbcId)
      .PropertyType = cspHelp
      .Table = csIngresosBrutosCategoria
      .Name = LNGGetText(1308, vbNullString) 'Categoría Ingresos Brutos
      .Key = K_IBC_ID
      .Value = m_IGBCategoria
      .HelpId = m_Ibc_id
    End With
    
    With .Add(Nothing, cscRetAcumulaPor)
      .PropertyType = cspList
      .Name = LNGGetText(2939, vbNullString) 'Acumula Por
      .ListWhoSetItem = csListItemData
      .ListItemData = m_AcumulaPor
      With .List
        With .Add(Nothing)
          .Id = csE_RetencionTipoAcumulado.csERAC_NoAcumula
          .Value = LNGGetText(2940, vbNullString) 'No Acumula
        End With
        With .Add(Nothing)
          .Id = csE_RetencionTipoAcumulado.csERAC_Mensual
          .Value = LNGGetText(1215, vbNullString) 'Mes
        End With
      End With
      .Key = K_ACUMULAPOR
    End With
    
    With .Add(Nothing, cscRetTipoMinimo)
      .PropertyType = cspList
      .Name = LNGGetText(2969, vbNullString) 'Tipo Minimo
      .ListWhoSetItem = csListItemData
      .ListItemData = m_TipoMinimo
      With .List
        With .Add(Nothing)
          .Id = csE_RetencionTipoMinimo.csERM_NoImponible
          .Value = LNGGetText(2971, vbNullString) 'No Imponible
        End With
        With .Add(Nothing)
          .Id = csE_RetencionTipoMinimo.csERM_Imponible
          .Value = LNGGetText(2970, vbNullString) 'Imponible
        End With
      End With
      .Key = K_TIPOMINIMO
    End With
        
    With .Add(Nothing, cscRetDescrip)
      .PropertyType = cspText
      .LeftFromProperty = cscRetCodigo
      .TopFromProperty = cscRetTipoMinimo
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
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As Recordset

  sqlstmt = "sp_RetencionGet " & Id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Rett_id = gDB.ValField(rs.fields, cscRettId)
    m_RetencionTipo = gDB.ValField(rs.fields, cscRettNombre)
    m_Id = gDB.ValField(rs.fields, cscRetId)
    m_Nombre = gDB.ValField(rs.fields, cscRetNombre)
    m_Codigo = gDB.ValField(rs.fields, cscRetCodigo)
    m_AcumulaPor = gDB.ValField(rs.fields, cscRetAcumulaPor)
    m_TipoMinimo = gDB.ValField(rs.fields, cscRetTipoMinimo)
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_descrip = gDB.ValField(rs.fields, cscRetDescrip)
    m_ImporteMinimo = gDB.ValField(rs.fields, cscRetImporteMinimo)
    m_RegimenSicore = gDB.ValField(rs.fields, cscRetRegimenSicore)
    m_Ta_id = gDB.ValField(rs.fields, cscTaId)
    m_Talonario = gDB.ValField(rs.fields, cscTaNombre)
    m_Ibc_id = gDB.ValField(rs.fields, cscIbcId)
    m_IGBCategoria = gDB.ValField(rs.fields, cscIbcNombre)
    m_esIIBB = gDB.ValField(rs.fields, cscRetEsIIBB)

  Else
  
    m_Rett_id = csNO_ID
    m_RetencionTipo = vbNullString
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_AcumulaPor = csERAC_NoAcumula
    m_TipoMinimo = csERM_NoImponible
    m_Activo = True
    m_descrip = vbNullString
    m_ImporteMinimo = 0
    m_RegimenSicore = vbNullString
    m_Ta_id = csNO_ID
    m_Talonario = vbNullString
    m_Ibc_id = csNO_ID
    m_IGBCategoria = vbNullString
    m_esIIBB = False
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
        .fieldId = cscRetiId
        .Table = csTRetencionItem
        .Id = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_RETI_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_IMPORTEDESDE
              fields.Add2 cscRetiImporteDesde, Cell.Value, csCurrency
            Case KI_IMPORTEHASTA
              fields.Add2 cscRetiImporteHasta, Cell.Value, csCurrency
            Case KI_PORCENTAJE
              fields.Add2 cscRetiPorcentaje, Cell.Value, csCurrency
            Case KI_IMPORTEFIJO
              fields.Add2 cscRetiImportefijo, Cell.Value, csCurrency
          End Select
        Next
        
        fields.Add2 cscRetId, m_Id, csId
        
        fields.HaveLastUpdate = True
        fields.HaveWhoModify = True
      
      End With
                                                                      
      If Not gDB.Save(register, , C_pSaveItemsFunc, C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeleted) And Not m_Copy Then
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    sqlstmt = "delete RetencionItem where reti_id in (" & m_ItemsDeleted & ")"
  
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
        .fieldId = cscRetCatfId
        .Table = csTRetencionCategoriaFiscal
        .Id = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_RETCATF_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_CATF_ID
              fields.Add2 cscCatfId, Cell.Id, csId
            Case KI_BASE
              fields.Add2 cscRetCatfBase, Cell.Id, csInteger
          End Select
        Next
        
        fields.Add2 cscRetId, m_Id, csId
        
        fields.HaveLastUpdate = False
        fields.HaveWhoModify = False
        
      End With
                                                              
      If Not gDB.Save(register, , "pSaveCatFiscal", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_CatFiscalDeleted) And Not m_Copy Then
    m_CatFiscalDeleted = RemoveLastColon(m_CatFiscalDeleted)
    sqlstmt = "delete RetencionCategoriaFiscal where retcatf_id in (" & m_CatFiscalDeleted & ")"
  
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
        .fieldId = cscRetProId
        .Table = csTRetencionProvincia
        .Id = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_RETPRO_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_PRO_ID
              fields.Add2 cscProId, Cell.Id, csId
          End Select
        Next
        
        fields.Add2 cscRetId, m_Id, csId
        
        fields.HaveLastUpdate = False
        fields.HaveWhoModify = False
      
      End With
                                                              
      If Not gDB.Save(register, , "pSaveProvincias", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ProvinciasDeleted) And Not m_Copy Then
    m_ProvinciasDeleted = RemoveLastColon(m_ProvinciasDeleted)
    sqlstmt = "delete RetencionProvincia where retpro_id in (" & m_ProvinciasDeleted & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveProvincias", C_Module) Then Exit Function
  End If
  
  pSaveProvincias = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select * from RetencionItem where ret_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
 
  With Propiedad.Grid
  
    With .Columns
    
      .Clear
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_RETI_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1257, vbNullString)   'Importe Desde
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1500
        .Format = "#,###,##0.00"
        .Key = KI_IMPORTEDESDE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1258, vbNullString)   'Importe Hasta
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1500
        .Format = "#,###,##0.00"
        .Key = KI_IMPORTEHASTA
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1259, vbNullString)   'Importe Fijo
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1500
        .Format = "#,###,##0.00"
        .Key = KI_IMPORTEFIJO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1105, vbNullString)   'Porcentaje
        .PropertyType = cspNumeric
        .SubType = cspPercent
        .Width = 1500
        .Key = KI_PORCENTAJE
      End With
      
    End With
    
    With .Rows
    
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscRetiId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscRetiId).Value
            .Key = KI_RETI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRetiImporteDesde)
            .Key = KI_IMPORTEDESDE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRetiImporteHasta)
            .Key = KI_IMPORTEHASTA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRetiImportefijo)
            .Key = KI_IMPORTEFIJO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRetiPorcentaje)
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
            "from RetencionCategoriaFiscal p inner join CategoriaFiscal catf " & _
                               "on p.catf_id = catf.catf_id " & _
            "where ret_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCatFiscal", C_Module) Then Exit Function
  
  With Propiedad.Grid

    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_RETCATF_ID
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
            .Id = csE_RetencionBase.csERB_Neto
            .Value = LNGGetText(1581, vbNullString) 'Neto
          End With
          With .Add(Nothing)
            .Id = csE_RetencionBase.csERB_NetoGravado
            .Value = LNGGetText(2551, vbNullString) 'Neto Gravado
          End With
          With .Add(Nothing)
            .Id = csE_RetencionBase.csERB_Total
            .Value = LNGGetText(1584, vbNullString) 'Total
          End With
        End With
        .Key = KI_BASE
      End With
      
    End With
    
    With .Rows
    
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscRetCatfId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscRetCatfId).Value
            .Key = KI_RETCATF_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCatfNombre)
            .Id = gDB.ValField(rs.fields, cscCatfId)
            .Key = KI_CATF_ID
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, cscRetCatfBase)
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
            "from RetencionProvincia p inner join Provincia pro " & _
                            "on p.pro_id = pro.pro_id " & _
            "where ret_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadProvincias", C_Module) Then Exit Function
  
  With Propiedad.Grid

    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_RETPRO_ID
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
      
        With .Add(Nothing, rs(cscRetProId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscRetProId).Value
            .Key = KI_RETPRO_ID
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
                  'Debe indicar un importe hasta (1)
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
  c_ErrorSave = LNGGetText(1417, vbNullString) 'Error al grabar retencion
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
