VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCondicionPago"
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
' cCondicionPago
' 02-12-03
'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cCondicionPago"
Private Const c_Items = "Items"

Private Const csTblDocumento = 4001

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_ESCONTADO                      As Integer = 4
Private Const K_ACTIVO                         As Integer = 5
Private Const K_ITEMS                          As Integer = 6
Private Const K_LIBRE                          As Integer = 7
Private Const K_ASIENTOXVTO                    As Integer = 8
Private Const K_TIPO                           As Integer = 9
Private Const K_CUEG_ID                        As Integer = 10
Private Const K_DOC_ID                         As Integer = 11

Private Const KI_CPGI_ID                        As Integer = 1
Private Const KI_CPG_ID                         As Integer = 2
Private Const KI_DIAS                           As Integer = 3
Private Const KI_PORCENTAJE                     As Integer = 4

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_descrip                      As String
Private m_Escontado                    As Boolean
Private m_EsLibre                      As Boolean
Private m_AsientoXVto                  As Boolean
Private m_Activo                       As Boolean
Private m_Tipo                         As Long
Private m_Documento                    As String
Private m_doc_id                       As Long
Private m_CuentaGrupo                  As String
Private m_cueg_id                      As Long

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long
Private m_Copy              As Boolean

Private m_Host As CSMenu.cIMenuHost

Private m_ItemsDeletedItems            As String

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

  Doc.ClientTable = csTCondicionPago
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
                               csPreGNewCondicionPago
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
  
  With m_ObjAbm.Properties(cscCpgCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscCpgNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscCpgCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscCpgNombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  cIABMClient_PropertyChange = True
  
  With m_ObjAbm.Properties
  
    Select Case Key
        
      Case K_TIPO
      
        Select Case .Item(cscCpgTipo).ListItemData
        
          Case csEcpgT_DebitoAuto
          
            .Item(cscCuegId).Enabled = True
            .Item(cscDocId).Enabled = True
          
            .Item(cscCuegId).HelpFilter = pGetCtaGrupoFilter(csEcpgT_DebitoAuto)
            m_ObjAbm.ShowValue .Item(cscCuegId)
          
          Case csEcpgT_FondoFijo
        
            .Item(cscCuegId).Enabled = True
            .Item(cscDocId).Enabled = True
        
            .Item(cscCuegId).HelpFilter = pGetCtaGrupoFilter(csEcpgT_FondoFijo)
            m_ObjAbm.ShowValue .Item(cscCuegId)
        
          Case Else
            
            .Item(cscCuegId).Enabled = False
            .Item(cscDocId).Enabled = False
        
        End Select
      
      Case K_LIBRE
      
          .Item(cscCpgAsientoXVto).Enabled = Val(.Item(cscCpgEsLibre).Value)
          m_ObjAbm.ShowValue .Item(cscCpgAsientoXVto)
      
    End Select
        
  End With

End Function

Private Function cIABMClient_Save() As Boolean
  Dim LastId   As Long
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscCpgId
    .Table = csTCondicionPago
    
    If m_Id = csECpgTipo.csECpgT_FechaDocumento Then
      MsgWarning LNGGetText(1099, vbNullString)
      Exit Function
    End If
    
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
          fields.Add2 cscCpgNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscCpgCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscCpgDescrip, .Value, csText
        Case K_ESCONTADO
          fields.Add2 cscCpgEscontado, .Value, csBoolean
        Case K_LIBRE
          fields.Add2 cscCpgEsLibre, .Value, csBoolean
        Case K_ASIENTOXVTO
          fields.Add2 cscCpgAsientoXVto, .Value, csBoolean
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
        Case K_TIPO
          fields.Add2 cscCpgTipo, .ListItemData, csInteger
        Case K_DOC_ID
          fields.Add2 cscDocId, .HelpId, csId
        Case K_CUEG_ID
          fields.Add2 cscCuegId, .HelpId, csId
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
                                                          
  If Not gDB.SaveEx(register, , _
                    cscCpgCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.Id
  
  If Not pSaveItemsItems() Then GoTo SaveError
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
    cIABMClient_Title = LNGGetText(1093, vbNullString)  'Condiciones de Pago
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
        
        Case K_ITEMS
        
          If Not pValidItems(IProperty) Then Exit Function

      End Select
    End With
  Next

  If Not pValidateTipo() Then Exit Function

  cIABMClient_Validate = True
End Function

Private Function pValidateTipo() As Boolean
  Dim Tipo        As csECpgTipo
  Dim cueg_id     As Long
  Dim Cueg_tipo   As Long
  Dim doc_id      As Long
  
  With m_ObjAbm.Properties
    cueg_id = .Item(cscCuegId).HelpId
    doc_id = .Item(cscDocId).HelpId
    Tipo = .Item(cscCpgTipo).ListItemData
  End With
  
  If Tipo = csEcpgT_DebitoAuto Or Tipo = csEcpgT_FondoFijo Then
    If cueg_id = csNO_ID Then
      MsgInfo LNGGetText(2565, vbNullString) 'El grupo de cuentas debe ser de tipo fondo fijo.
      Exit Function
    End If
    If doc_id = csNO_ID Then
      MsgInfo LNGGetText(3576, vbNullString) 'Debe indicar un documento de orden de pago
      Exit Function
    End If
  End If
  
  If Not gDB.GetData(csTCuentaGrupo, cscCuegId, cueg_id, cscCuegTipo, Cueg_tipo) Then Exit Function
  
  Select Case Tipo
    Case csEcpgT_DebitoAuto
      If Cueg_tipo <> csECuecTipoDebitoAutomatico Then
        MsgInfo LNGGetText(3574, vbNullString) 'El grupo de cuentas debe ser de tipo debito automatico.
        Exit Function
      End If
      
    Case csEcpgT_FondoFijo
      If Cueg_tipo <> csECuecTipoFondoFijo Then
        MsgInfo LNGGetText(3575, vbNullString) 'El grupo de cuentas debe ser de tipo fondo fijo.
        Exit Function
      End If
  
  End Select
  
  pValidateTipo = True
End Function

Private Function pValidItems(ByRef IProperty As cIABMProperty) As Boolean
  Dim Percent As Double
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  If Val(m_ObjAbm.Properties(cscCpgEscontado).Value) Then
    pValidItems = True
  
  Else
  
    If IProperty.Grid.Rows.Count Then
  
      For Each Row In IProperty.Grid.Rows
      
        For Each Cell In Row
          Select Case Cell.Key
            Case KI_PORCENTAJE
              Percent = Percent + Val(Cell.Value)
          End Select
        Next
      Next
      
      If Round(Percent, 2) > 100 Or Round(Percent, 2) < 99.99 Then
        MsgInfo LNGGetText(1094, vbNullString, Round(Percent, 2))
                'La suma de los porcentajes de los items de la condición de pago deben sumar 100. Los items ingresados suman Round(Percent, 2)
      Else
        pValidItems = True
      End If
    Else
      MsgInfo LNGGetText(1095, vbNullString)
                'Debe indicar en 'Items' los plazos de la condición de pago
    End If
  End If
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRow(Row, RowIndex)
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListCondicionPago)
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

  If m_Id = csECpgTipo.csECpgT_FechaDocumento Then
    MsgWarning LNGGetText(1100, vbNullString)
    Exit Function
  End If

  If Not SecurityCanAccess(csPreGDeleteCondicionPago) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "delete CondicionPagoItem where cpg_id = " & Id & vbCrLf & _
            "delete CondicionPago where cpg_id = " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewCondicionPago) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditCondicionPago) Then Exit Function
  End If

  m_ObjAbm.InModalWindow = InModalWindow

  If Not Load(Id) Then Exit Function
  
  If m_Id = csECpgTipo.csECpgT_FechaDocumento Then
    MsgWarning LNGGetText(1101, vbNullString)
                'Esta condición de pago es interna al sistema. No puede ser editada.
    Exit Function
  End If
  
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
  m_Host.Server.AddMenu C_MenuTesoreria, csMenuConfigTesoreria, C_MenuConfig, 0, True, False, False, False, True, Nothing
                        'Condición de &pago
  m_Host.Server.AddMenu LNGGetText(1096, vbNullString), csPreGListCondicionPago, C_MenuTesoreria, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                        'Condiciones de Pago
  m_Host.MenuABMClick "CSGeneral2.cCondicionPago", Me, LNGGetText(1093, vbNullString), 0, csETablasGeneral.csCondicionPago
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
  
  Id = Val(pCell(Row, KI_CPGI_ID).Value)
  
  If Id <> csNO_ID Then m_ItemsDeletedItems = m_ItemsDeletedItems & Id & C_StrColon
  
  cIABMClientGrid_DeleteRow = True
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
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function GetData(ByVal Id As Long, ByVal strField As String, ByVal TypeValue As csTypes) As Variant
  Dim Data As Variant
  
  Select Case TypeValue
    Case csTypes.csBoolean
      Data = False
    Case csTypes.csCuit, csTypes.csText
      Data = vbNullString
    Case csTypes.csDate, csTypes.csDateOrNull
      Data = csNoDate
    Case csTypes.csCurrency, csTypes.csDouble, _
         csTypes.csInteger, csTypes.csLong, _
         csTypes.csSingle, csTypes.csId
      Data = 0
    Case csTypes.csVariant
      Data = Empty
  End Select
  
  If Not gDB.GetData(csTCondicionPago, cscCpgId, Id, strField, Data, "GetData", C_Module) Then
    Select Case TypeValue
      Case csTypes.csBoolean
        Data = False
      Case csTypes.csCuit, csTypes.csText
        Data = vbNullString
      Case csTypes.csDate, csTypes.csDateOrNull
        Data = csNoDate
      Case csTypes.csCurrency, csTypes.csDouble, _
           csTypes.csInteger, csTypes.csLong, _
           csTypes.csSingle, csTypes.csId
        Data = 0
      Case csTypes.csVariant
        Data = Empty
    End Select
  End If
  
  GetData = Data
End Function

' funciones privadas

Private Function pValidateRowItems(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_DIAS
        If ValEmpty(Cell.Value, csInteger) Then
                  'Debe indicar la cantidad de días
          MsgInfo LNGGetText(1097, vbNullString, strRow)
          Exit Function
        End If
      Case KI_PORCENTAJE
        If ValEmpty(Cell.Value, csCurrency) Then
                  'Debe indicar un porcentaje
          MsgInfo LNGGetText(1098, vbNullString, strRow)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowItems = True
End Function

Private Function LoadCollection() As Boolean
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 6500
  
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
  
  End With
  
  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, cscCpgNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Width = 6300
      .Key = K_NOMBRE
      .Value = m_Nombre
    End With
    
    With .Add(Nothing, cscCpgCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 15
      .Key = K_CODIGO
      .Value = m_Codigo
    End With
    
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .TopFromProperty = cscCpgCodigo
      .Left = 5500
      .LeftNotChange = True
      .TopNotChange = True
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
    
    With .Add(Nothing, cscCpgEscontado)
      .PropertyType = cspCheck
      .Name = LNGGetText(1102, vbNullString)   'Es Contado
      .Key = K_ESCONTADO
      .Value = CInt(m_Escontado)
    End With
    
    With .Add(Nothing, cscCpgEsLibre)
      .PropertyType = cspCheck
      .Name = LNGGetText(1103, vbNullString)   'Es Libre"
      .Key = K_LIBRE
      .Value = CInt(m_EsLibre)
    End With
    
    With .Add(Nothing, cscCpgAsientoXVto)
      .PropertyType = cspCheck
      .TopFromProperty = cscCpgEsLibre
      .Left = 4500
      .LeftLabel = -2000
      .LeftNotChange = True
      .TopNotChange = True
      .Name = LNGGetText(1104, vbNullString)   'Asiento por Vencimiento
      .Key = K_ASIENTOXVTO
      .Value = CInt(m_AsientoXVto)
      .Enabled = CInt(m_EsLibre)
    End With
    
    With .Add(Nothing, cscCpgTipo)
      .PropertyType = cspList
      .Name = LNGGetText(1223, vbNullString) 'Tipo
      .ListWhoSetItem = csListItemData
      .ListItemData = m_Tipo
      With .List
        With .Add(Nothing)
          .Id = csECpgTipo.csEcpgT_General
          .Value = LNGGetText(1027, vbNullString) 'General
        End With
        With .Add(Nothing)
          .Id = csECpgTipo.csEcpgT_DebitoAuto
          .Value = LNGGetText(3569, vbNullString) 'Debito Automatico
        End With
        With .Add(Nothing)
          .Id = csECpgTipo.csEcpgT_FondoFijo
          .Value = LNGGetText(3570, vbNullString) 'Fondo Fijo
        End With
      End With
      .Key = K_TIPO
    End With
    
    With .Add(Nothing, cscCuegId)
      .PropertyType = cspHelp
      .Table = csCuentaGrupo
      .Name = LNGGetText(1516, vbNullString)   'Grupo de Cuenta
      .Key = K_CUEG_ID
      .Value = m_CuentaGrupo
      .HelpId = m_cueg_id
      .HelpFilter = pGetCtaGrupoFilter(m_Tipo)
      .Enabled = m_Tipo = csECpgTipo.csEcpgT_DebitoAuto Or m_Tipo = csECpgTipo.csEcpgT_FondoFijo
    End With
    
    With .Add(Nothing, cscDocId)
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Name = LNGGetText(1922, vbNullString)   'Orden de pago
      .Key = K_DOC_ID
      .Value = m_Documento
      .HelpId = m_doc_id
      .HelpFilter = "doct_id = 16"
      .Enabled = m_Tipo = csECpgTipo.csEcpgT_DebitoAuto Or m_Tipo = csECpgTipo.csEcpgT_FondoFijo
    End With
    
    With .Add(Nothing, cscCpgDescrip)
      .PropertyType = cspText
      .Name = C_strDescrip
      .SubType = cspMemo
      .Size = 255
      .Width = 6300
      .Height = 880
      .LeftFromProperty = cscCpgNombre
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
  
  m_ItemsDeletedItems = vbNullString
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As Recordset

  sqlstmt = "select cpg.*,doc_nombre, cueg_nombre " & _
            "from condicionpago cpg left join documento doc " & _
                          "on cpg.doc_id = doc.doc_id " & _
                                    "left join cuentagrupo cueg " & _
                           "on cpg.cueg_id = cueg.cueg_id " & _
            "where cpg_id = " & Id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscCpgId)
    m_Nombre = gDB.ValField(rs.fields, cscCpgNombre)
    m_Codigo = gDB.ValField(rs.fields, cscCpgCodigo)
    m_descrip = gDB.ValField(rs.fields, cscCpgDescrip)
    m_Escontado = gDB.ValField(rs.fields, cscCpgEscontado)
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_EsLibre = gDB.ValField(rs.fields, cscCpgEsLibre)
    m_AsientoXVto = gDB.ValField(rs.fields, cscCpgAsientoXVto)
    m_Tipo = gDB.ValField(rs.fields, cscCpgTipo)
    m_Documento = gDB.ValField(rs.fields, cscDocNombre)
    m_doc_id = gDB.ValField(rs.fields, cscDocId)
    m_CuentaGrupo = gDB.ValField(rs.fields, cscCuegNombre)
    m_cueg_id = gDB.ValField(rs.fields, cscCuegId)

  Else
    
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_descrip = vbNullString
    m_Escontado = False
    m_Activo = True
    m_EsLibre = False
    m_AsientoXVto = False
    m_Tipo = csEcpgT_General
    m_Documento = vbNullString
    m_doc_id = csNO_ID
    m_CuentaGrupo = vbNullString
    m_cueg_id = csNO_ID

  End If

  Load = True
End Function

Private Function pSaveItemsItems() As Boolean
  Dim register As cRegister
  Dim fields   As cFields
  
  With m_ObjAbm.Properties(c_Items)
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscCpgiId
        .Table = csTCondicionPagoItem
        .Id = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_CPGI_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_DIAS
              fields.Add2 cscCpgiDias, Cell.Value, csInteger
            Case KI_PORCENTAJE
              fields.Add2 cscCpgiPorcentaje, Cell.Value, csCurrency
          End Select
        Next
        
        fields.Add2 cscCpgId, m_Id, csId
        
        fields.HaveLastUpdate = False
        fields.HaveWhoModify = False
      
      End With
                                                                  
      If Not gDB.Save(register, , "pSaveItemsItems", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedItems) And Not m_Copy Then
    m_ItemsDeletedItems = RemoveLastColon(m_ItemsDeletedItems)
    sqlstmt = "delete CondicionPagoItem where cpgi_id in (" & m_ItemsDeletedItems & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsItems", C_Module) Then Exit Function
  End If
  
  pSaveItemsItems = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select *" & _
            " from CondicionPagoItem" & _
            " where cpg_id = " & m_Id & _
            " order by cpgi_dias"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  With Propiedad.Grid

    With .Columns
    
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_CPGI_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1085, vbNullString) 'Dias
        .PropertyType = cspNumeric
        .SubType = cspInteger
        .Width = 1200
        .Key = KI_DIAS
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1105, vbNullString) 'Porcentaje
        .PropertyType = cspNumeric
        .SubType = cspPercent
        .Width = 1200
        .Key = KI_PORCENTAJE
      End With
      
    End With
    
    With .Rows
    
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscCpgiId).Value)
          
          With .Add(Nothing)
            .Value = rs(cscCpgiId).Value
            .Key = KI_CPGI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCpgiDias)
            .Key = KI_DIAS
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCpgiPorcentaje)
            .Key = KI_PORCENTAJE
          End With
        
        End With
        
        rs.MoveNext
      Wend
    
    End With
  End With
  
  pLoadItems = True
End Function

Private Function pIsEmptyRow(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_DIAS
        If Not ValEmpty(Cell.Value, csInteger) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_PORCENTAJE
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRow = bRowIsEmpty
End Function

Private Function pGetCtaGrupoFilter(ByVal Tipo As csECpgTipo) As String
  Dim filter    As String
                             
  Select Case Tipo
    Case csEcpgT_DebitoAuto
      filter = "cueg_tipo = 5" ' Debito Automatico
    Case csEcpgT_FondoFijo
      filter = "cueg_tipo = 6" ' Fondo Fijo
    Case Else
      filter = "1=2"
  End Select
  
  pGetCtaGrupoFilter = filter

End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error Resume Next
  c_ErrorSave = LNGGetText(1092, vbNullString)
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
