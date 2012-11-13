VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAjusteInflacion"
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
' cAjusteInflacion
' 19-11-2007

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cAjusteInflacion"

Private Const c_activo_pasivo = "activo_pasivo"
Private Const c_resultados = "resultados"
Private Const c_patrimonio_neto = "patrimonio_neto"

Private Const c_cue_id_rama_ap = "rama_ap"
Private Const c_cue_id_rama_r = "rama_r"
Private Const c_cue_id_rama_pn = "rama_pn"

Private Enum csE_AjusteInflacionTipo
  csEAjet_ActivoPasivo = 1
  csEAjet_Resultados = 2
  csEAjet_PatrimonioNeto = 3
End Enum

Private Enum csE_AjusteInflacionItemTipo
  csEAjit_SinDefinir = 1
  csEAjit_Cualitativos = 2
  csEAjit_Cuantitativos = 3
  csEAjit_CostosVenta = 4
  csEAjit_BienesdeUso = 5
  csEAjit_BienesdeCambio = 6
  csEAjit_IngresosEgresos = 7
End Enum

Private Enum csE_AjusteInflacionMetodo
  csEAje_PPP = 1
  csEAje_FIFO = 2
End Enum

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_ACTIVO                         As Integer = 4
Private Const K_CUE_ID_PATRIMONIAL             As Integer = 5
Private Const K_CUE_ID_RESULTADOS              As Integer = 6
Private Const K_CCOS_ID                        As Integer = 7
Private Const K_AGRUPACENTROCOSTO              As Integer = 8
Private Const K_INCLUIRSINCENTROCOSTO          As Integer = 9
Private Const K_METODO                         As Integer = 13

Private Const K_ACTIVO_PASIVO                  As Integer = 10
Private Const K_RESULTADOS                     As Integer = 11
Private Const K_PATRIMONIO_NETO                As Integer = 12
Private Const K_CUE_ID_RAMA_AP                 As Integer = 13
Private Const K_CUE_ID_RAMA_R                  As Integer = 14
Private Const K_CUE_ID_RAMA_PN                 As Integer = 15

Private Const KI_AJI_ID                        As Integer = 1
Private Const KI_CUE_ID                        As Integer = 2
Private Const KI_AJIT_ID                       As Integer = 3
Private Const KI_CUEC_ID                       As Integer = 4


' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_descrip                      As String
Private m_Activo                       As Boolean
Private m_cue_id_patrimonial           As Long
Private m_cue_id_resultados            As Long
Private m_cuentaPatrimonial            As String
Private m_cuentaResultados             As String
Private m_ccos_id                      As String
Private m_centrocosto                  As String
Private m_agrupa_centrocosto           As Boolean
Private m_incluir_sin_centrocosto      As Boolean
Private m_metodo                       As csE_AjusteInflacionMetodo

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

Private m_ItemsDeletedCuenta As String

' Properties publicas

Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property

' Properties privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscAjeCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscAjeNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscAjeCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscAjeNombre)
  
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

  Doc.ClientTable = csTAjusteInflacion
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
  Select Case MessageID
  
    Case MSG_DOC_INFO
    
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      
      CSKernelClient2.ShowHelp AbmGen.hWnd, _
                               vbNullString, _
                               vbNullString, _
                               csPreGNewAjusteInflacion
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    Case Else
      cIABMClient_MessageEx = True
  End Select
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  Select Case Key
    Case K_CUE_ID_RAMA_AP
      With m_ObjAbm.Properties
        pAddToGrid .Item(c_activo_pasivo).Grid, _
                   .Item(c_cue_id_rama_ap).HelpValueProcess, _
                   csEAjet_ActivoPasivo
        AbmObj.ShowValue .Item(c_activo_pasivo), True
      End With
    Case K_CUE_ID_RAMA_R
      With m_ObjAbm.Properties
        pAddToGrid .Item(c_resultados).Grid, _
                   .Item(c_cue_id_rama_r).HelpValueProcess, _
                   csEAjet_Resultados
        AbmObj.ShowValue .Item(c_resultados), True
      End With
    Case K_CUE_ID_RAMA_PN
      With m_ObjAbm.Properties
        pAddToGrid .Item(c_patrimonio_neto).Grid, _
                   .Item(c_cue_id_rama_pn).HelpValueProcess, _
                   csEAjet_PatrimonioNeto
                   
        AbmObj.ShowValue .Item(c_patrimonio_neto), True
      End With
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  Dim LastId     As Long
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscAjeId
    .Table = csTAjusteInflacion
  
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
          fields.Add2 cscAjeNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscAjeCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscAjeDescrip, .Value, csText
        Case K_CUE_ID_PATRIMONIAL
          fields.Add2 cscCueIdPatrimonial, .HelpId, csId
        Case K_CUE_ID_RESULTADOS
          fields.Add2 cscCueIdResultados, .HelpId, csId
        Case K_CCOS_ID
          fields.Add2 cscCcosId, .HelpValueProcess, csText
        Case K_AGRUPACENTROCOSTO
          fields.Add2 cscAjeAgrupaccos, .Value, csBoolean
        Case K_INCLUIRSINCENTROCOSTO
          fields.Add2 cscAjeIncluirsinccos, .Value, csBoolean
        Case K_METODO
          fields.Add2 cscAjeMetodo, .ListItemData, csInteger
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.SaveEx(register, , _
                    cscAjeCodigo, _
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
    cIABMClient_Title = LNGGetText(3610, vbNullString)
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
        Case K_CUE_ID_PATRIMONIAL
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(3616, vbNullString) 'Debe indicar una cuenta de patrimonial
            Exit Function
          End If
        Case K_CUE_ID_RESULTADOS
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(3617, vbNullString) 'Debe indicar una cuenta de resultados
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

' Implementacion de cIABMClientGrid
Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  Dim Row As cIABMGridRow
  
  Select Case Key
    Case K_ACTIVO_PASIVO
      If lCol = 3 Then
        Set Row = m_ObjAbm.Properties.Item(c_activo_pasivo).Grid.Rows(lRow)
        pCuentaSetData Row, csEAjet_ActivoPasivo
      End If
    Case K_RESULTADOS
      If lCol = 3 Then
        Set Row = m_ObjAbm.Properties.Item(c_resultados).Grid.Rows(lRow)
        pCuentaSetData Row, csEAjet_Resultados
      End If
    Case K_PATRIMONIO_NETO
      If lCol = 3 Then
        Set Row = m_ObjAbm.Properties.Item(c_patrimonio_neto).Grid.Rows(lRow)
        pCuentaSetData Row, csEAjet_PatrimonioNeto
      End If
    
  End Select
  
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Sub pCuentaSetData(ByRef Row As cIABMGridRow, ByVal Tipo As csE_AjusteInflacionTipo)
  Dim cuec_id     As Long
  Dim ajit_id     As Long
  Dim ajit_nombre As String
  
  cuec_id = pGetCuentaCategoria(pCell(Row, KI_CUE_ID).Id)
  
  With pCell(Row, KI_CUEC_ID)
    .Id = cuec_id
    .Value = pGetCuentaCategoriaNombre(cuec_id)
  End With
  
  ajit_id = pCell(Row, KI_AJIT_ID).Id
  
  pGetAjusteItemTipo cuec_id, Tipo, ajit_id, ajit_nombre
  
  With pCell(Row, KI_AJIT_ID)
    .Id = ajit_id
    .Value = ajit_nombre
  End With

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ACTIVO_PASIVO
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowCuenta(Row, RowIndex)
    Case K_RESULTADOS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowCuenta(Row, RowIndex)
    Case K_PATRIMONIO_NETO
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowCuenta(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Select Case Key
    Case K_ACTIVO_PASIVO, K_PATRIMONIO_NETO, K_RESULTADOS
      Id = Val(pCell(Row, KI_AJI_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedCuenta = m_ItemsDeletedCuenta & Id & C_StrColon
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ACTIVO_PASIVO
      cIABMClientGrid_ValidateRow = pValidateRowCuentas(Row, RowIndex)
    Case K_PATRIMONIO_NETO
      cIABMClientGrid_ValidateRow = pValidateRowCuentas(Row, RowIndex)
    Case K_RESULTADOS
      cIABMClientGrid_ValidateRow = pValidateRowCuentas(Row, RowIndex)
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListAjusteInflacion)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreGDeleteAjusteInflacion) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "sp_AjusteInflacionDelete " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewAjusteInflacion) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditAjusteInflacion) Then Exit Function
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

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host

  m_Host.Server.AddMenu C_MenuContabilidad, csMenuConfigContabilidad, C_MenuConfig, 0, True, False, False, False, True, Nothing
                        '&Esquemas de Ajuste por Inflación
  m_Host.Server.AddMenu LNGGetText(3611, vbNullString), csPreGListAjusteInflacion, C_MenuContabilidad, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc

ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                  ' Esquemas de Ajuste por Inflación
  m_Host.MenuABMClick "CSGeneral2.cAjusteInflacion", Me, LNGGetText(3610, vbNullString), 0, csETablasGeneral.csAjusteInflacion
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c     As cIABMProperty
  Dim oProp As cABMProperty

  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 7400
  AbmObj.UseHelpValueProcess = True
  
  Const c_tab_general = 0
  Const c_tab_activo_pasivo = 1
  Const c_tab_resultados = 2
  Const c_tab_patrimonio_neto = 3
  
  With m_ObjAbm
  
    With .Tabs
      
      .Clear
    
      With .Add(Nothing)
        .Name = C_strGeneral
      End With
      
      With .Add(Nothing)
        .Index = c_tab_activo_pasivo
        .Name = LNGGetText(3618, vbNullString) 'Activo y Pasivo
      End With
      
      With .Add(Nothing)
        .Index = c_tab_resultados
        .Name = LNGGetText(3619, vbNullString) 'Resultados
      End With
      
      With .Add(Nothing)
        .Index = c_tab_patrimonio_neto
        .Name = LNGGetText(3620, vbNullString) 'Patrimonio Neto
      End With
      
    End With
  End With
  
  m_ObjAbm.Title2 = m_Nombre

  With m_ObjAbm.Properties
    
    .Clear

    With .Add(Nothing, cscAjeNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Width = 6000
      .Size = 255
      .Key = K_NOMBRE
      .Value = m_Nombre
    End With
    
    With .Add(Nothing, cscAjeCodigo)
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
    
      .LeftNotChange = True
      .Left = 7100
      .Width = 500
      .LeftLabel = -800
      .TopFromProperty = cscAjeCodigo
      .TopNotChange = True
    End With
    
    With .Add(Nothing, cscCueIdPatrimonial)
      .PropertyType = cspHelp
      .Table = csCuenta
      .Name = LNGGetText(3612, vbNullString) 'Cuenta Patrimonial
      .Key = K_CUE_ID_PATRIMONIAL
      .Value = m_cuentaPatrimonial
      .HelpId = m_cue_id_patrimonial
      .HelpFilter = "'cuec_id not in (9,10)'"
      .Width = 4500
    End With
    
    With .Add(Nothing, cscCueIdResultados)
      .PropertyType = cspHelp
      .Table = csCuenta
      .Name = LNGGetText(3613, vbNullString) 'Cuenta de Resultados
      .Key = K_CUE_ID_RESULTADOS
      .Value = m_cuentaResultados
      .HelpId = m_cue_id_resultados
      .HelpFilter = "'cuec_id in (9,10)'"
      .Width = 4500
    End With
    
    Set c = .Add(Nothing, cscCcosId)
    With c
      .PropertyType = cspHelp
      .Table = csCentroCosto
      .Name = LNGGetText(1057, vbNullString) 'Centro de costo
      .Key = K_CCOS_ID
      .Width = 4500
      
      .HelpId = Val(m_ccos_id)
      .HelpValueProcess = m_ccos_id
      .Value = m_centrocosto
    
      Set oProp = c
      oProp.HelpType = csTree
      Set oProp = Nothing
      
    End With
    
    With .Add(Nothing, cscAjeMetodo)
      .PropertyType = cspList
      .ListWhoSetItem = csListItemData
      .ListItemData = m_metodo
      .Name = LNGGetText(3623, vbNullString)
      .Key = K_METODO
      .Width = 3500
      With .List
        With .Add(Nothing)
          .Value = LNGGetText(3622, vbNullString) ' Precio Promedio Ponderado
          .Id = csE_AjusteInflacionMetodo.csEAje_PPP
        End With
        With .Add(Nothing)
          .Value = LNGGetText(3621, vbNullString) ' Primero en entrar primero en salir
          .Id = csE_AjusteInflacionMetodo.csEAje_FIFO
        End With
      End With
    End With
    
    With .Add(Nothing, cscAjeAgrupaccos)
      .PropertyType = cspCheck
      .Name = LNGGetText(3614, vbNullString) ' Agrupar por centro de costo
      .Key = K_AGRUPACENTROCOSTO
      .Value = CInt(m_agrupa_centrocosto)
      .Left = 2580
      .LeftLabel = -2200
    End With
    
    With .Add(Nothing, cscAjeIncluirsinccos)
      .PropertyType = cspCheck
      .Name = LNGGetText(3615, vbNullString) ' Incluir movimientos sin centro de costo
      .Key = K_INCLUIRSINCENTROCOSTO
      .Value = CInt(m_incluir_sin_centrocosto)
      .Left = 3280
      .LeftLabel = -2900
    End With
    
    With .Add(Nothing, cscAjeDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Height = 780
      .Width = 6000
      .Name = C_strDescrip
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_descrip
      .LeftFromProperty = cscAjeNombre
    End With
    
    Set c = .Add(Nothing, c_cue_id_rama_ap)
    With c
      .PropertyType = cspHelp
      .Table = csCuenta
      .Name = LNGGetText(1267, vbNullString) 'Cuenta
      .Width = 4500
      .Key = K_CUE_ID_RAMA_AP
      .Left = 1800
      .TabIndex = c_tab_activo_pasivo
      Set oProp = c
      oProp.IsEditProperty = False
      oProp.HelpType = csTree
    End With
    
    Set c = .Add(Nothing, c_activo_pasivo)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadActivoPasivo(c) Then Exit Function
      .Name = c_activo_pasivo
      .Key = K_ACTIVO_PASIVO
      .TabIndex = c_tab_activo_pasivo
      .Top = 1500
      .Left = 200
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    Set c = .Add(Nothing, c_cue_id_rama_r)
    With c
      .PropertyType = cspHelp
      .Table = csCuenta
      .Name = LNGGetText(1267, vbNullString) 'Cuenta
      .Width = 4500
      .Key = K_CUE_ID_RAMA_R
      .Left = 1800
      .TabIndex = c_tab_resultados
      Set oProp = c
      oProp.IsEditProperty = False
      oProp.HelpType = csTree
    End With
    
    Set c = .Add(Nothing, c_resultados)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadResultados(c) Then Exit Function
      .Name = c_resultados
      .Key = K_RESULTADOS
      .TabIndex = c_tab_resultados
      .Top = 1500
      .Left = 200
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    Set c = .Add(Nothing, c_cue_id_rama_pn)
    With c
      .PropertyType = cspHelp
      .Table = csCuenta
      .Name = LNGGetText(1267, vbNullString) 'Cuenta
      .Width = 4500
      .Key = K_CUE_ID_RAMA_PN
      .Left = 1800
      .TabIndex = c_tab_patrimonio_neto
      Set oProp = c
      oProp.IsEditProperty = False
      oProp.HelpType = csTree
    End With
    
    Set c = .Add(Nothing, c_patrimonio_neto)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadPatrimonioNeto(c) Then Exit Function
      .Name = c_patrimonio_neto
      .Key = K_PATRIMONIO_NETO
      .TabIndex = c_tab_patrimonio_neto
      .Top = 1500
      .Left = 200
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_ItemsDeletedCuenta = vbNullString
    
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As Recordset

  sqlstmt = "sp_AjusteInflacionGet " & Id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscAjeId)
    m_Nombre = gDB.ValField(rs.fields, cscAjeNombre)
    m_Codigo = gDB.ValField(rs.fields, cscAjeCodigo)
    m_descrip = gDB.ValField(rs.fields, cscAjeDescrip)
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_cue_id_patrimonial = gDB.ValField(rs.fields, cscCueIdPatrimonial)
    m_cue_id_resultados = gDB.ValField(rs.fields, cscCueIdResultados)
    m_ccos_id = gDB.ValField(rs.fields, cscCcosId)
    m_cuentaPatrimonial = gDB.ValField(rs.fields, "cuenta_patrimonial")
    m_cuentaResultados = gDB.ValField(rs.fields, "cuenta_resultados")
    m_centrocosto = gDB.ValField(rs.fields, cscCcosNombre)
    m_incluir_sin_centrocosto = gDB.ValField(rs.fields, cscAjeIncluirsinccos)
    m_agrupa_centrocosto = gDB.ValField(rs.fields, cscAjeAgrupaccos)
    m_metodo = gDB.ValField(rs.fields, cscAjeMetodo)

  Else
  
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_descrip = vbNullString
    m_Activo = True
    m_cue_id_patrimonial = csNO_ID
    m_cue_id_resultados = csNO_ID
    m_ccos_id = csNO_ID
    m_cuentaPatrimonial = vbNullString
    m_cuentaResultados = vbNullString
    m_centrocosto = vbNullString
    m_incluir_sin_centrocosto = False
    m_agrupa_centrocosto = False
    m_metodo = csEAje_PPP

  End If

  Load = True
  
End Function

Private Function pIsEmptyRowCuenta(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CUE_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowCuenta = bRowIsEmpty

End Function

Private Function pValidateRowCuentas(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CUE_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(1261, vbNullString, strRow) 'Debe indicar una cuenta
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowCuentas = True
End Function

Private Function pLoadActivoPasivo(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  sqlstmt = "sp_AjusteInflacionGetCuentas " & m_Id & "," & 1 'Activo y Pasivo
  pLoadActivoPasivo = pLoadCuentas(Propiedad, sqlstmt, csEAjet_ActivoPasivo)
End Function

Private Function pLoadResultados(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  sqlstmt = "sp_AjusteInflacionGetCuentas " & m_Id & "," & 2 'Resultados
  pLoadResultados = pLoadCuentas(Propiedad, sqlstmt, csEAjet_Resultados)
End Function

Private Function pLoadPatrimonioNeto(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  sqlstmt = "sp_AjusteInflacionGetCuentas " & m_Id & "," & 3 'Patrimonio neto
  pLoadPatrimonioNeto = pLoadCuentas(Propiedad, sqlstmt, csEAjet_PatrimonioNeto)
End Function

Private Function pLoadCuentas(ByRef Propiedad As cIABMProperty, _
                              ByVal sqlstmt As String, _
                              ByVal Tipo As csE_AjusteInflacionTipo) As Boolean
  Dim rs As ADODB.Recordset
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadSucursales", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
    
      .Clear
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_AJI_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1267, vbNullString) 'Cuenta
        .PropertyType = cspHelp
        .Table = csCuenta
        .Width = 3000
        .Key = KI_CUE_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1120, vbNullString) 'Categoria
        .PropertyType = cspText
        .Width = 3000
        .Enabled = False
        .Key = KI_CUEC_ID
      End With
    
      With .Add(Nothing, cscAjitId)
        .Name = LNGGetText(1223, vbNullString) 'Tipo
        .PropertyType = cspHelp
        .Table = csAjusteInflacionItemTipo
        .Width = 2000
        .Key = KI_AJIT_ID
        
        If Tipo = csEAjet_ActivoPasivo Then
          .HelpFilter = "ajit_id in (5,6,1)"
        ElseIf Tipo = csEAjet_Resultados Then
          .HelpFilter = "ajit_id in (4,7)"
        Else
          .HelpFilter = "ajit_id in (2,3)"
        End If
      End With
    
    End With
    
    .Rows.Clear
    pLoadCuentasAux Propiedad.Grid, rs
  
  End With
  
  pLoadCuentas = True
End Function

Private Function pLoadCuentasAux(ByRef Grid As cIABMGrid, _
                                 ByRef rs As ADODB.Recordset) As Boolean

  Dim Row     As cIABMGridRow
  Dim aji_id  As Long
  
  With Grid.Rows
    
    While Not rs.EOF
    
      aji_id = gDB.ValField(rs.fields, cscAjiId)
      If aji_id Then
        Set Row = .Add(Nothing, aji_id)
      Else
        Set Row = .Add(Nothing)
      End If
    
      With Row
      
        With .Add(Nothing)
          .Value = aji_id
          .Key = KI_AJI_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscCueNombre)
          .Id = gDB.ValField(rs.fields, cscCueId)
          .Key = KI_CUE_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscCuecNombre)
          .Key = KI_CUEC_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscAjitNombre)
          .Id = gDB.ValField(rs.fields, cscAjitId)
          .Key = KI_AJIT_ID
        End With
        
      End With
      
      rs.MoveNext
    Wend
  End With
End Function

Private Function pSaveItems() As Boolean

  If Not pSaveItemsAux(m_ObjAbm.Properties.Item(c_activo_pasivo)) Then Exit Function
  If Not pSaveItemsAux(m_ObjAbm.Properties.Item(c_resultados)) Then Exit Function
  If Not pSaveItemsAux(m_ObjAbm.Properties.Item(c_patrimonio_neto)) Then Exit Function

  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedCuenta) And Not m_Copy Then
    m_ItemsDeletedCuenta = RemoveLastColon(m_ItemsDeletedCuenta)
    sqlstmt = "delete AjusteInflacionItem where aji_id in (" & m_ItemsDeletedCuenta & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItems", C_Module) Then Exit Function
  End If
  
  pSaveItems = True
End Function

Private Function pSaveItemsAux(ByRef iProp As cIABMProperty) As Boolean
  Dim register As cRegister
  Dim fields   As cFields

  With iProp
  
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscAjiId
        .Table = csTAjusteInflacionItem
        .Id = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_AJI_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_CUE_ID
              fields.Add2 cscCueId, Cell.Id, csId
            Case KI_AJIT_ID
              fields.Add2 cscAjitId, Cell.Id, csId
          End Select
        Next
        
        fields.Add2 cscAjeId, m_Id, csId
        
        fields.HaveLastUpdate = False
        fields.HaveWhoModify = False
      End With
                                                                    
      If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  pSaveItemsAux = True
End Function

Private Function pGetCuentaCategoria(ByVal Cue_id As Long) As Long
  Dim cuec_id As Long
  If Not gDB.GetData(csTCuenta, cscCueId, Cue_id, cscCuecId, cuec_id) Then Exit Function
  pGetCuentaCategoria = cuec_id
End Function

Private Function pGetCuentaCategoriaNombre(ByVal cuec_id As Long) As String
  Dim cuec_nombre As String
  If Not gDB.GetData(csTCuentaCategoria, cscCuecId, cuec_id, cscCuecNombre, cuec_nombre) Then Exit Function
  pGetCuentaCategoriaNombre = cuec_nombre
End Function

Private Sub pGetAjusteItemTipo(ByVal cuec_id As Long, _
                               ByVal Tipo As csE_AjusteInflacionTipo, _
                               ByRef ajit_id As Long, _
                               ByRef ajit_nombre As String)
  
  If cuec_id = csNO_ID Then
  
    ajit_id = csNO_ID
    ajit_nombre = vbNullString
  
  Else
  
    Select Case Tipo
      Case csE_AjusteInflacionTipo.csEAjet_ActivoPasivo
      
        Select Case cuec_id
          
          Case 5 'Bienes de Uso
            ajit_id = csE_AjusteInflacionItemTipo.csEAjit_BienesdeUso
          Case 6 'Bienes de Cambio
            ajit_id = csE_AjusteInflacionItemTipo.csEAjit_BienesdeCambio
          Case Else
            ajit_id = csE_AjusteInflacionItemTipo.csEAjit_SinDefinir
        End Select
        
      Case csE_AjusteInflacionTipo.csEAjet_PatrimonioNeto
      
        ajit_id = csE_AjusteInflacionItemTipo.csEAjit_Cualitativos
      
      Case csE_AjusteInflacionTipo.csEAjet_Resultados
  
        Select Case cuec_id
      
          Case 12  'Costos de Mercaderia Vendida
            ajit_id = csE_AjusteInflacionItemTipo.csEAjit_CostosVenta
          Case Else ' 9 'Ingresos - 10  'Egresos
            ajit_id = csE_AjusteInflacionItemTipo.csEAjit_IngresosEgresos
        End Select
        
    End Select
    
    If ajit_id Then
      gDB.GetData csTAjusteInflacionItemTipo, cscAjitId, ajit_id, cscAjitNombre, ajit_nombre
    End If
  End If
End Sub

Private Sub pAddToGrid(ByRef Grid As cIABMGrid, _
                       ByVal idRama As String, _
                       ByVal Tipo As csE_AjusteInflacionTipo)
                       
  If LCase$(Left$(idRama, 1)) <> "n" Then Exit Sub
  
  Dim ram_id  As Long
  
  ram_id = Val(Mid$(idRama, 2))
  If ram_id = csNO_ID Then Exit Sub
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_AjusteInflacionGetCuentasXramId " & ram_id & "," & Tipo
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  pLoadCuentasAux Grid, rs

End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  On Error Resume Next
  c_ErrorSave = LNGGetText(3609, vbNullString)
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub
