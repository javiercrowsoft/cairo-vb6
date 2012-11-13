VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPresupuestoEnvio"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericDoc
Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cPresupuestoEnvio
' 09-05-2003

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cPresupuestoEnvio"

Private Const c_Items = "Items"
Private Const c_Gastos = "Gastos"

Private Const K_NUMERO                         As Integer = 1000
Private Const K_NRODOC                         As Integer = 2000
Private Const K_DESCRIP                        As Integer = 3000
Private Const K_FECHA                          As Integer = 4000
Private Const K_FECHAENTREGA                   As Integer = 5000
Private Const K_NETO                           As Integer = 6000
Private Const K_IVARI                          As Integer = 7000
Private Const K_IVARNI                         As Integer = 8000
Private Const K_TOTAL                          As Integer = 9000
Private Const K_CLI_ID                         As Integer = 10000
Private Const K_DOC_ID                         As Integer = 11000
Private Const K_DOCT_ID                        As Integer = 12000
Private Const K_ITEMS                          As Integer = 15000
Private Const K_CPG_ID                         As Integer = 16000
Private Const K_EST_ID                         As Integer = 17000
Private Const K_CCOS_ID                        As Integer = 18000
Private Const K_SUC_ID                         As Integer = 19000
Private Const K_DESCUENTO1                     As Integer = 20000
Private Const K_DESCUENTO2                     As Integer = 21000
Private Const K_IMPORTEDESC1                   As Integer = 22000
Private Const K_IMPORTEDESC2                   As Integer = 23000
Private Const K_SUBTOTAL                       As Integer = 24000
Private Const K_GASTOS                         As Integer = 25000
Private Const K_VEN_ID                         As Integer = 26000

Private Const KI_PREE_ID                        As Integer = 10
Private Const KI_PREEI_ID                       As Integer = 20
Private Const KI_ORDEN                          As Integer = 30
Private Const KI_CANTIDAD                       As Integer = 40
Private Const KI_VOLUMEN                        As Integer = 41
Private Const KI_KILOS                          As Integer = 42
Private Const KI_DESCRIP                        As Integer = 60
Private Const KI_PRECIO                         As Integer = 70
Private Const KI_MINIMO                         As Integer = 71
Private Const KI_IMPORTE                        As Integer = 80
Private Const KI_NETO                           As Integer = 90
Private Const KI_IVARI                          As Integer = 100
Private Const KI_IVARNI                         As Integer = 110
Private Const KI_PR_ID                          As Integer = 130
Private Const KI_IVARIPercent                   As Integer = 160
Private Const KI_IVARNIPercent                  As Integer = 170
Private Const KI_UNIDAD                         As Integer = 190
Private Const KI_CCOS_ID                        As Integer = 220
Private Const KI_PUE_ID_ORIGEN                  As Integer = 310
Private Const KI_PUE_ID_DESTINO                 As Integer = 320

Private Const KI_PREEG_ID                       As Integer = 230
Private Const KI_PRECIOTARIFAGASTO              As Integer = 240
Private Const KI_TRANS_ID                       As Integer = 280
Private Const KI_TRFG_ID                        As Integer = 290
Private Const KI_GTO_ID                         As Integer = 300

Private Const KI_TRFI_ID                        As Integer = 330

' Seudo - variables
Private c_ErrorSave     As String
Private c_strTitle As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Numero                       As Long
Private m_Estado                       As String
Private m_est_id                       As Long
Private m_Nrodoc                       As String
Private m_Descrip                      As String
Private m_Fecha                        As Date
Private m_Fechaentrega                 As Date
Private m_Neto                         As Double
Private m_Ivari                        As Double
Private m_Ivarni                       As Double
Private m_Total                        As Double
Private m_SubTotal                     As Double
Private m_Descuento1                   As Double
Private m_Descuento2                   As Double
Private m_ImporteDesc1                 As Double
Private m_ImporteDesc2                 As Double
Private m_cpg_id                       As Long
Private m_CondicionPago                As String
Private m_ccos_id                      As Long
Private m_CentroCosto                  As String
Private m_suc_id                       As Long
Private m_Sucursal                     As String
Private m_ven_id                       As Long
Private m_Vendedor                     As String
Private m_cli_id                       As Long
Private m_Cliente                      As String
Private m_doc_id                       As Long
Private m_Documento                    As String
Private m_Doct_id                      As Long
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_Firmado                      As Boolean

Private m_Editing           As Boolean

Private m_Footer            As cIABMGeneric
Private m_Items             As cIABMGeneric
Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_LastDoc           As Long
Private m_LastCli           As Long
Private m_LastDocName       As String
Private m_LastCliName       As String

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost

Private m_ItemsDeleted      As String
Private m_GastosDeleted     As String

Private m_Copy              As Boolean

Private m_GeneralConfig     As cGeneralConfig

Private m_bIva              As Boolean
Private m_bIvaRni           As Boolean

Private m_DocEditable       As Boolean
Private m_DocEditMsg        As String

Private m_pr_id_Gastos      As Long
Private m_ProductoGastos    As String

Private m_TaPropuesto       As Boolean
Private m_TaMascara         As String

Private m_pr_id_Envios      As Long
Private m_ProductoEnvios    As String

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

' iPropertyes publicas
' iPropertyes privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  If Not DocSecurityCanAccessEx(csPreEnvNewPresupuesto, _
                                m_doc_id, _
                                csEDocTPreNew, _
                                True) Then Exit Function
  
  cIABMClient_Terminate
  m_IsNew = True
  m_Copy = True
  m_DocEditable = True
  m_DocEditMsg = vbNullString
  
  ' Obtengo el numero para este comprobante
  '
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscPreeNrodoc
  pSetEnabled
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True

  If Not m_DocEditable Then
    If LenB(m_DocEditMsg) Then
      MsgWarning m_DocEditMsg
    End If
  End If
  
  If m_ObjAbm.Properties.Item(cscDocId).HelpId = csNO_ID Then
    MsgInfo LNGGetText(1562, vbNullString)  'Debe indicar un documento
  End If
  
  cIEditGeneric_Edit csNO_ID

  ' Obtengo el numero para este comprobante
  '
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscPreeNrodoc
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

  Doc.ClientTable = csTPresupuestoEnvio
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
    
  Select Case MessageID
    Case MSG_DOC_FIRST, MSG_DOC_PREVIOUS, MSG_DOC_NEXT, MSG_DOC_LAST
      cIABMClient_MessageEx = pMove(MessageID)
    Case MSG_DOC_SIGNATURE
      cIABMClient_MessageEx = pFirmar()
    Case MSG_GRID_ROW_DELETED
    
      Select Case Info
        Case K_ITEMS
          cIABMClient_MessageEx = True
          pShowTotales
        Case K_GASTOS
          cIABMClient_MessageEx = True
          pShowTotales
      End Select
    
    Case MSG_DOC_EDIT_STATE
      ShowEditState m_DocEditMsg, c_strTitle
      
    Case MSG_DOC_DELETE
      If cIEditGeneric_Delete(m_Id) Then
        cIABMClient_MessageEx = True
        pMove MSG_DOC_NEXT
      End If
      
    Case MSG_DOC_ANULAR
      DocAnular m_Id, m_est_id, m_Estado, csPreEnvAnular, csPreEnvDesAnular, m_ObjAbm, m_DocEditable, m_DocEditMsg, "sp_DocPresupuestoEnvioAnular", "sp_DocPresupuestoEnvioEditableGet"
      pSetEnabled
    
    Case MSG_DOC_REFRESH
      Load m_Id
      pRefreshProperties
  
    Case MSG_DOC_EX_GET_ITEMS
      Set cIABMClient_MessageEx = m_Items
    
    Case MSG_DOC_EX_GET_FOOTERS
      Set cIABMClient_MessageEx = m_Footer
  
    Case MSG_DOC_SEARCH                     ' En info cABMInteface nos
                                            ' indica si hay cambios sin
                                            ' guardar
      DocumentSearch csEDT_PresupuestoEnvio, Me, Not CBool(Info)
  
    Case MSG_DOC_HISTORY
    
      If m_Id <> csNO_ID Then
    
        ShowHistory csPresupuestoEnvio, m_Id, m_Documento & " " & m_Nrodoc
      Else
        
        MsgInfo LNGGetText(1552, vbNullString) 'El documento aun no ha sido guardado
      End If
  
    Case MSG_EXPORT_GET_EMAIL
    
      With m_ObjAbm.Properties.Item(cscCliId)
        cIABMClient_MessageEx = GetEmailFromCliente(.HelpId)
      End With
  
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
  Select Case Key
    Case K_DOC_ID
      ' Si cambio de documento
      '
      If DocChange(m_ObjAbm, m_LastDoc, m_LastDocName) Then
        
        ' Si cambie de documento y estaba en un comprobante ya guardado
        ' tengo que mostrar el formulario sin datos, para evitar
        ' que presione guardar y le cambie el doc_id al comprobante por error
        '
        If m_Id <> csNO_ID And m_doc_id <> m_LastDoc Then cIEditGeneric_Edit csDocChanged
        
        ' Obtengo el numero para este comprobante
        '
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscPreeNrodoc
      
      End If

      ' Defino el estado de edicion del comprobante
      '
      pSetEnabled
    
    Case K_CLI_ID
      
      ' Obtengo datos del cliente
      '
      pSetDatosCliente
    
    Case K_DESCUENTO1, K_DESCUENTO2
      pShowTotales
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  
  ' Save and State
  '
  If Not DocCanEdit(m_DocEditable, m_DocEditMsg) Then
    cIABMClient_Save = True
    Exit Function
  End If
  If Not DocCanSave(m_ObjAbm, cscPreeFecha) Then
    cIABMClient_Save = False
    Exit Function
  End If
  
  If pGetItems().Grid.Rows.Count = 0 Then
    MsgWarning LNGGetText(3903, vbNullString) 'El documento debe contener al menos un item
    cIABMClient_Save = False
    Exit Function
  End If
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  register.fieldId = cscPreeTMPId
  register.Table = csTPresupuestoEnvioTMP
  
  register.ID = csNew
    
  If m_Copy Then
    register.fields.Add2 cscPreeId, csNew, csLong
  Else
    register.fields.Add2 cscPreeId, m_Id, csLong
  End If
  
  If register.ID = csNew Then
    m_est_id = CSGeneralEx2.csEEstado.csEEst_Pendiente
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NUMERO
          register.fields.Add2 cscPreeNumero, .Value, csLong
        Case K_NRODOC
          register.fields.Add2 cscPreeNrodoc, .Value, csText
        Case K_DESCRIP
          register.fields.Add2 cscPreeDescrip, .Value, csText
        Case K_FECHA
          register.fields.Add2 cscPreeFecha, .Value, csDate
        Case K_FECHAENTREGA
          register.fields.Add2 cscPreeFechaentrega, .Value, csDate
        Case K_CLI_ID
          register.fields.Add2 cscCliId, .HelpId, csId
        Case K_CCOS_ID
          register.fields.Add2 cscCcosId, .HelpId, csId
        Case K_SUC_ID
          register.fields.Add2 cscSucId, .HelpId, csId
        Case K_VEN_ID
          register.fields.Add2 cscVenId, .HelpId, csId
        Case K_DESCUENTO1
          register.fields.Add2 cscPreeDescuento1, .Value, csCurrency
        Case K_DESCUENTO2
          register.fields.Add2 cscPreeDescuento2, .Value, csCurrency
        Case K_DOC_ID
          register.fields.Add2 cscDocId, .HelpId, csId
        Case K_DOCT_ID
          register.fields.Add2 cscDoctId, .HelpId, csId
        Case K_CPG_ID
          register.fields.Add2 cscCpgId, .HelpId, csId
      End Select
    End With
  Next
  
  For Each IProperty In m_Footer.Properties
    With IProperty
      Select Case .Key
        Case K_TOTAL
          register.fields.Add2 cscPreeTotal, .Value, csCurrency
        Case K_NETO
          register.fields.Add2 cscPreeNeto, .Value, csCurrency
        Case KI_IVARI
          If m_bIva Then
            register.fields.Add2 cscPreeIvari, .Value, csCurrency
          End If
        Case KI_IVARNI
          If m_bIvaRni Then
            register.fields.Add2 cscPreeIvarni, .Value, csCurrency
          End If
        Case K_SUBTOTAL
          register.fields.Add2 cscPreeSubtotal, .Value, csCurrency
        Case K_IMPORTEDESC1
          register.fields.Add2 cscPreeImportedesc1, .Value, csCurrency
        Case K_IMPORTEDESC2
          register.fields.Add2 cscPreeImportedesc2, .Value, csCurrency
      End Select
    End With
  Next
  
  register.fields.Add2 cscEstId, m_est_id, csId
  register.fields.Add2 cscDoctId, csEDT_PresupuestoEnvio, csId
  
  register.fields.HaveLastUpdate = True
  register.fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If Not pSaveItems(register.ID) Then Exit Function
  If Not pSaveGastos(register.ID) Then Exit Function
  If Not register.CommitTrans() Then Exit Function
  
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DocPresupuestoEnvioSave " & register.ID
  
  If Not gDB.OpenRs(sqlstmt, rs, , , , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim ID As Long
  If Not GetDocIDFromRecordset(rs, ID) Then Exit Function
  
  m_Copy = False
  
  cIABMClient_Save = Load(ID)
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  m_ObjTree.sqlstmt = "sp_lsdoc_PresupuestoEnvio"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = c_strTitle
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_FECHA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(1558, vbNullString) 'Debe indicar una fecha
            Exit Function
          End If
        Case K_FECHAENTREGA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(1564, vbNullString) 'Debe indicar una fecha de entrega
            Exit Function
          End If
        Case K_CLI_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1563, vbNullString) 'Debe indicar un cliente
            Exit Function
          End If
        Case K_DOC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1562, vbNullString) 'Debe indicar un documento
            Exit Function
          End If
        Case K_CPG_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1561, vbNullString) 'Debe indicar una condición de pago
            Exit Function
          End If
        Case K_SUC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1560, vbNullString) 'Debe indicar una sucursal
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowItem(Row, RowIndex)
    Case K_GASTOS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowGasto(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

'-------------------------------------------------------------------------------------
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

Private Function cIEditGeneric_GridAdd(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
  cIEditGeneric_ShowList = SecurityCanAccess(csPreEnvListPresupuesto)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
  m_ObjAbm.IsDocument = True

#If Not PREPROC_SFS Then
  Dim AbmGen      As cABMGenericDocEx
  
  Set AbmGen = m_ObjAbm
  With AbmGen
    .FactoryObject = "CSABMInterface2.cFactory"
    .ObjForm = "CSABMInterface2.fPresupuestoEnvio"
  End With
#End If
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(ID As Long) As Boolean
  Dim doc_id As Long
  
  If Not m_ObjAbm Is Nothing Then
    doc_id = GetdocIdFromObjAbm(m_ObjAbm)
  Else
    If Not GetDocIdFromId(ID, _
                          csTPresupuestoEnvio, _
                          cscPreeId, _
                          doc_id) Then
      Exit Function
    End If
  End If
  
  If Not DocSecurityCanAccess( _
                  csPreEnvDeletePresupuesto, _
                  doc_id, _
                  csEDocTPreDelete) Then
    Exit Function
  End If

  Dim sqlstmt As String
  
  sqlstmt = "sp_DocPresupuestoEnvioDelete " & ID & "," & EmpId & "," & User.ID
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not DocSecurityCanAccess(csPreEnvListPresupuesto, GetdocIdFromObjAbm(m_ObjAbm), csEDocTPreList) Then Exit Function
  
                            ' Id = csDocChanged esto significa que se cambio
                            '                   el documento estando en un
                            '                   comprobante ya guardado
                            '
  m_IsNew = ID = csNO_ID Or ID = csDocChanged

  If Not Load(ID) Then Exit Function
  
  If m_ObjAbm.Properties.Count = 0 Then
    If Not LoadCollection() Then Exit Function
  Else
    pRefreshProperties
  End If
  
  m_Editing = True
  m_Copy = False
  
  cIEditGeneric_Edit = True
  Exit Function
ControlError:
  MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal ID As Long) As Boolean

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

Private Function cIEditGeneric_Preview(ByVal ID As Long) As Boolean

End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  On Error GoTo ControlError
  
  Select Case Key
    Case K_ITEMS
      pColumnAfterUpdateItems Key, lRow, lCol
      pShowImporteAndIva m_Items.Properties.Item(c_Items).Grid.Rows(lRow), K_ITEMS
      pShowTotales
      cIABMClientGrid_ColumnAfterUpdate = True
    
    Case K_GASTOS
      pShowImporteAndIva m_Items.Properties.Item(c_Gastos).Grid.Rows(lRow), K_GASTOS
      pShowTotales
      cIABMClientGrid_ColumnAfterUpdate = True
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnAfterUpdate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_ColumnAfterEdit = pColumnAfterEdit(m_Items.Properties(c_Items), lRow, lCol, NewValue, NewValueID)
    Case K_GASTOS
      cIABMClientGrid_ColumnAfterEdit = pColumnAfterEdit(m_Items.Properties(c_Gastos), lRow, lCol, NewValue, NewValueID)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnAfterEdit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_ColumnBeforeEdit = pColumnBeforeEdit(m_Items.Properties(c_Items), lRow, lCol, iKeyAscii)
    Case K_GASTOS
      cIABMClientGrid_ColumnBeforeEdit = pColumnBeforeEdit(m_Items.Properties(c_Gastos), lRow, lCol, iKeyAscii)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnBeforeEdit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pColumnBeforeEdit(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
  pColumnBeforeEdit = True
End Function

Private Function pGetPrecioFromRow(ByVal Row As cIABMGridRow) As Double
  Dim Precio  As Double
  
  With pCell(Row, KI_PRECIO)
    If IsNumeric(.Value) Then
      Precio = CDbl(.Value)
    Else
      Precio = 0
    End If
  End With
  
  pGetPrecioFromRow = Precio
End Function

Private Function pColumnAfterUpdateItems(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)
  Dim IProperty As cIABMProperty
  Set IProperty = m_Items.Properties(c_Items)
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KI_PUE_ID_DESTINO, KI_PUE_ID_ORIGEN
        Dim Filter As String
      
        With .Rows
          Filter = pCell(.Item(lRow), KI_PUE_ID_ORIGEN).ID & "," & pCell(.Item(lRow), KI_PUE_ID_DESTINO).ID
        End With
        .Columns(cscTrfiId).HelpFilter = Filter
        
#If PREPROC_SFS Then
        Dim AbmObj As cABMGeneric
#Else
        Dim AbmObj As cABMGenericDocEx
#End If
        Set AbmObj = m_ObjAbm

        AbmObj.RefreshColumnProperties IProperty, cscTrfiId
      Case KI_TRFI_ID
        pSetTarifa IProperty, lRow
        Set IProperty = m_Items.Properties(c_Gastos)
        pSetGastos IProperty, lRow
      Case KI_CANTIDAD, KI_VOLUMEN
        pSetTarifa IProperty, lRow
    End Select
  End With
End Function

Private Sub pSetGastos(ByRef IProperty As cIABMProperty, ByVal lRow As Long)
  Dim trfi_id     As Long
  Dim Row         As cIABMGridRow
  Dim Rows        As cIABMGridRows
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  Dim i           As Integer
  Dim F           As cIABMGridRow
  Dim fv          As cIABMGridCellValue
  
  ' Elimino todas las filas de la tarifa
  i = 1
  With IProperty.Grid.Rows
    While i <= .Count
      Set Row = .Item(i)
      
      If pIsEmptyRowGasto(Row, i) Then
        .Remove i
      ElseIf pCell(Row, KI_TRFG_ID).ID <> csNO_ID Then
        m_GastosDeleted = m_GastosDeleted & Val(pCell(Row, KI_PREEG_ID).Value) & ","
        .Remove i
      Else
        i = i + 1
      End If
    Wend
  End With
  
  ' Muevo las filas de gastos propios a una coleccion temporal
  Set Rows = New cABMGridRows
  With IProperty.Grid.Rows
    For i = 1 To .Count
      Rows.Add .Item(1)
      .Remove 1
    Next
  End With
  
  Set Row = m_Items.Properties(c_Items).Grid.Rows(lRow)
  trfi_id = pCell(Row, KI_TRFI_ID).ID
  
  If trfi_id <> csNO_ID Then
  
    sqlstmt = "sp_DocPresupuestoEnvioGetGastos2 " & trfi_id
    
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
    While Not rs.EOF
    
      Set F = IProperty.Grid.Rows.Add(Nothing)
      
      Set fv = F.Add(Nothing)
      fv.Value = csNew
      fv.Key = KI_PREEG_ID
      
      Set fv = F.Add(Nothing)
      fv.ID = gDB.ValField(rs.fields, cscTransId)
      fv.Key = KI_TRANS_ID
      
      Set fv = F.Add(Nothing, csctrfgId)
      fv.Value = gDB.ValField(rs.fields, csctrfgImporte)
      fv.ID = gDB.ValField(rs.fields, csctrfgId)
      fv.Key = KI_TRFG_ID
      
      Set fv = F.Add(Nothing)
      fv.Value = gDB.ValField(rs.fields, cscPrNombreventa)
      fv.ID = gDB.ValField(rs.fields, cscPrId)
      fv.Key = KI_PR_ID
      
      Set fv = F.Add(Nothing)
      fv.Value = gDB.ValField(rs.fields, cscGtoNombre)
      fv.ID = gDB.ValField(rs.fields, cscGtoId)
      fv.Key = KI_GTO_ID
      Set fv.Format = New cABMGridCellFormat
      fv.Format.Enabled = False
      
      Set fv = F.Add(Nothing)
      fv.Value = vbNullString
      fv.Key = KI_DESCRIP
      
      Set fv = F.Add(Nothing)
      fv.Value = Val(pCell(Row, KI_KILOS).Value)
      fv.Key = KI_CANTIDAD
      
      Set fv = F.Add(Nothing)
      fv.Value = gDB.ValField(rs.fields, csctrfgImporte)
      fv.Key = KI_PRECIOTARIFAGASTO
      
      Set fv = F.Add(Nothing)
      fv.Value = gDB.ValField(rs.fields, csctrfgImporte)
      fv.Key = KI_PRECIO
      
      Set fv = F.Add(Nothing)
      fv.Value = 0
      fv.Key = KI_NETO
  
      Set fv = F.Add(Nothing)
      fv.Value = 0
      fv.Key = KI_IVARI
  
      Set fv = F.Add(Nothing)
      fv.Value = 0
      fv.Key = KI_IVARNI
  
      Set fv = F.Add(Nothing)
      fv.Value = 0
      fv.Key = KI_IMPORTE
  
      Set fv = F.Add(Nothing)
      fv.Value = 0
      fv.Key = KI_IVARIPercent
  
      Set fv = F.Add(Nothing)
      fv.Value = 0
      fv.Key = KI_IVARNIPercent
      
      Set fv = F.Add(Nothing)
      fv.Value = vbNullString
      fv.ID = csNO_ID
      fv.Key = KI_CCOS_ID
      
      pShowImporteAndIva F, K_GASTOS
      
      rs.MoveNext
    Wend
  End If
  
  Dim oRow As cABMGridRow
  With IProperty.Grid.Rows
    For i = 1 To Rows.Count
      Set oRow = Rows.Item(i)
      oRow.Index = 0
      .Add oRow
    Next
  End With
  
#If PREPROC_SFS Then
  Dim AbmGen  As cABMGeneric
#Else
  Dim AbmGen  As cABMGenericDocEx
#End If

  Set AbmGen = m_Items
  AbmGen.ShowValue m_Items.Properties(c_Gastos), True
End Sub

Private Sub pSetTarifa(ByRef IProperty As cIABMProperty, ByVal lRow As Long)
  Dim Kilos       As Double
  Dim Volumen     As Double
  Dim trfi_id     As Long
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  Dim Transporte  As String
  Dim trans_id    As Long
  Dim Minimo      As Double
  Dim Row         As cIABMGridRow
  Dim Tarifa      As Double
  
  Set Row = IProperty.Grid.Rows.Item(lRow)
  
  trfi_id = pCell(Row, KI_TRFI_ID).ID
  If trfi_id <> csNO_ID Then
    Kilos = Val(pCell(Row, KI_CANTIDAD).Value)
    Volumen = Val(pCell(Row, KI_VOLUMEN).Value)
    sqlstmt = "sp_help_TarifaItemEx " & trfi_id & "," & gDB.sqlString(Kilos) & "," & gDB.sqlString(Volumen)
    
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
    If rs.EOF Then Exit Sub
    
    Transporte = gDB.ValField(rs.fields, cscTransNombre)
    trans_id = gDB.ValField(rs.fields, cscTransId)
    Minimo = gDB.ValField(rs.fields, cscTrfiMinimo)
    Kilos = gDB.ValField(rs.fields, "Kilos")
    Tarifa = gDB.ValField(rs.fields, "Tarifa")
  End If

  With pCell(Row, KI_TRANS_ID)
    .Value = Transporte
    .ID = trans_id
  End With
  pCell(Row, KI_TRFI_ID).Value = Tarifa
  pCell(Row, KI_MINIMO).Value = Minimo
  pCell(Row, KI_KILOS).Value = Kilos
End Sub

Private Function pColumnAfterEdit(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long)
  Dim Row     As cIABMGridRow
  
  Select Case IProperty.Grid.Columns(lCol).Key
    Case KI_PR_ID
      Set Row = IProperty.Grid.Rows(lRow)
      If IProperty.Key = K_ITEMS Then
        pSetDataProducto Row, NewValueID
      End If
      pSetPrecios Row, NewValueID
      pSetTasasImpositivas Row, NewValueID, NewValue
  End Select
  
  pColumnAfterEdit = True
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
    Case K_ITEMS
      ID = Val(pCell(Row, KI_PREEI_ID).Value)
      If ID <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & ID & ","
    Case K_GASTOS
      ID = Val(pCell(Row, KI_PREEG_ID).Value)
      If ID <> csNO_ID Then m_GastosDeleted = m_GastosDeleted & ID & ","
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
    Case K_ITEMS
      cIABMClientGrid_ValidateRow = pValidateRowItem(Row, RowIndex)
    Case K_GASTOS
      cIABMClientGrid_ValidateRow = pValidateRowGasto(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pIsEmptyRowGasto(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CANTIDAD
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_PRECIO
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_GTO_ID
        If Not ValEmpty(Cell.ID, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowGasto = bRowIsEmpty
End Function

Private Function pValidateRowGasto(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CANTIDAD
        If ValEmpty(Cell.Value, csLong) Then
          MsgInfo LNGGetText(1365, vbNullString, strRow) 'Debe indicar una cantidad (1)
          Exit Function
        End If
      Case KI_PRECIO
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(1631, vbNullString, strRow) 'Debe indicar un precio (1)
          Exit Function
        End If
      Case KI_PR_ID
        If ValEmpty(Cell.ID, csId) Then
          MsgInfo LNGGetText(1565, vbNullString, strRow) 'Debe indicar un Producto de venta (1)
          Exit Function
        End If
      Case KI_GTO_ID
        If ValEmpty(Cell.ID, csId) Then
          MsgInfo LNGGetText(2375, vbNullString, strRow) 'Debe indicar un Gasto (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowGasto = True
End Function

Private Function pIsEmptyRowItem(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_KILOS
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_VOLUMEN
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_CANTIDAD
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_PRECIO
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_TRFI_ID
        If Not ValEmpty(Cell.ID, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowItem = bRowIsEmpty
End Function

Private Function pValidateRowItem(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_KILOS
        If ValEmpty(Cell.Value, csDouble) Then
          MsgInfo LNGGetText(2376, vbNullString, strRow) 'Debe indicar un Peso (1)
          Exit Function
        End If
      Case KI_VOLUMEN
        If ValEmpty(Cell.Value, csDouble) Then
          MsgInfo LNGGetText(2377, vbNullString, strRow) 'Debe indicar un Volumen (1)
          Exit Function
        End If
      Case KI_CANTIDAD
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(1365, vbNullString, strRow) 'Debe indicar una cantidad (1)
          Exit Function
        End If
      Case KI_PRECIO
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(1631, vbNullString, strRow) 'Debe indicar un precio (1)
          Exit Function
        End If
      Case KI_TRFI_ID
        If ValEmpty(Cell.ID, csId) Then
          MsgInfo LNGGetText(2378, vbNullString, strRow) 'Debe indicar un Tarifa (1)
          Exit Function
        End If
      Case KI_PR_ID
        If ValEmpty(Cell.ID, csId) Then
          MsgInfo LNGGetText(1565, vbNullString, strRow) 'Debe indicar un Producto de venta (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowItem = True
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim Filter  As String
  Dim iTab    As cIABMTabItem
  Dim c       As cIABMProperty
#If PREPROC_SFS Then
  Dim AbmGen  As cABMGeneric
#Else
  Dim AbmGen  As cABMGenericDocEx
#End If

  ' Preferencias del usuario
  '
  Dim bValidateDocDefault As Boolean
  
  Set AbmGen = m_ObjAbm
  AbmGen.ResetLayoutMembers
  
  AbmGen.NoButtons2 = BUTTON_DOC_ACTION
  AbmGen.InitButtons
  
  m_ObjAbm.Properties.Clear

  Set c = m_ObjAbm.Properties.Add(Nothing, cscDocId)
  c.PropertyType = cspHelp
  c.Table = CSDocumento2.CSDocumento
  c.Name = LNGGetText(1567, vbNullString) 'Documento
  c.Key = K_DOC_ID
      
  If m_doc_id <> csNO_ID Then
    c.HelpId = m_doc_id
    c.Value = m_Documento
  Else
    ' Preferencias del usuario
    '
    c.HelpId = m_UserCfg.DocPreeId
    c.Value = m_UserCfg.DocPreeNombre
    
    bValidateDocDefault = c.HelpId <> csNO_ID
  End If
      
  c.HelpFilter = "'doct_id = " & csEDT_PresupuestoEnvio & "'"
  
  Set c = m_ObjAbm.Properties.Add(Nothing, csDocNumberID)
  c.PropertyType = cspNumeric
  c.SubType = cspInteger
  c.Name = LNGGetText(1065, vbNullString) 'Número
  c.Key = K_NUMERO
  c.Value = m_Numero
  c.Enabled = False
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, csDocEstateID)
  c.PropertyType = cspText
  c.Name = LNGGetText(1568, vbNullString) 'Estado
  c.Key = K_EST_ID
  c.Value = m_Estado
  c.Enabled = False
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPreeFecha)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1569, vbNullString) 'Fecha
  c.LeftLabel = -580
  c.Left = 700
  c.Key = K_FECHA
  c.Value = m_Fecha
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPreeFechaentrega)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1570, vbNullString) 'Entrega
  c.Key = K_FECHAENTREGA
  c.Value = m_Fechaentrega
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCliId)
  c.PropertyType = cspHelp
  c.Table = csCliente
  c.TopFromProperty = cscPreeFecha
  c.Left = 2700
  c.LeftLabel = -580
  c.Name = LNGGetText(1150, vbNullString) 'Cliente
  c.Key = K_CLI_ID
  c.HelpId = m_cli_id
  c.Value = m_Cliente
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPreeNrodoc)
  c.PropertyType = cspText
  c.Name = LNGGetText(1065, vbNullString) 'Numero
  c.Size = 50
  c.Key = K_NRODOC
  c.Value = m_Nrodoc
  c.TextMask = m_TaMascara
  c.TextAlign = vbRightJustify
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCpgId)
  c.PropertyType = cspHelp
  c.Table = csCondicionPago
  c.Name = LNGGetText(1571, vbNullString) 'Cond. pago
  c.TopFromProperty = cscPreeFecha
  c.Left = 5900
  c.LeftLabel = -900
  c.Key = K_CPG_ID
  c.HelpId = m_cpg_id
  c.Value = m_CondicionPago
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPreeDescuento1)
  c.PropertyType = cspNumeric
  c.SubType = cspPercent
  c.LeftLabel = -600
  c.Name = LNGGetText(1573, vbNullString) 'Desc. 1
  c.Key = K_DESCUENTO1
  c.Value = m_Descuento1
  c.Width = 1000
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPreeDescuento2)
  c.PropertyType = cspNumeric
  c.SubType = cspPercent
  c.TopFromProperty = cscPreeDescuento1
  c.Left = 7150
  c.LeftLabel = -150
  c.Name = "2"
  c.Key = K_DESCUENTO2
  c.Value = m_Descuento2
  c.Width = 1000
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCcosId)
  c.PropertyType = cspHelp
  c.TopFromProperty = cscCliId
  c.Left = 9400
  c.Table = csCentroCosto
  c.Name = LNGGetText(1057, vbNullString) 'Centro de Costo
  c.Key = K_CCOS_ID
  c.HelpId = m_ccos_id
  c.Value = m_CentroCosto
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscSucId)
  c.PropertyType = cspHelp
  c.Table = csSucursal
  c.Name = LNGGetText(1281, vbNullString) 'Sucursal
  c.Key = K_SUC_ID
  c.HelpId = m_suc_id
  c.Value = m_Sucursal
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscVenId)
  c.PropertyType = cspHelp
  c.Table = csVendedores
  c.Name = LNGGetText(1510, vbNullString) 'Vendedor
  c.Key = K_VEN_ID
  c.HelpId = m_ven_id
  c.Value = m_Vendedor
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPreeDescrip)
  c.PropertyType = cspText
  c.SubType = cspMemo
  c.Name = LNGGetText(1211, vbNullString) 'Observ.
  c.LeftLabel = -600
  c.Size = 5000
  c.Key = K_DESCRIP
  c.Value = m_Descrip
  c.LeftFromProperty = cscPreeFecha
  c.TopFromProperty = cscPreeNrodoc
  c.Width = 7450
  c.Height = 800
  c.TopToPrevious = 440
  
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
      
  m_Items.Tabs.Clear
  
  Set iTab = m_Items.Tabs.Add(Nothing)
  iTab.Index = 0
  iTab.Name = LNGGetText(1371, vbNullString) 'Items
  
  
  Set iTab = m_Items.Tabs.Add(Nothing)
  iTab.Index = 1
  iTab.Name = LNGGetText(1221, vbNullString) 'Gastos
  
  
  Set AbmGen = m_Items
  AbmGen.ResetLayoutMembers
  m_Items.Properties.Clear
  
  Set c = m_Items.Properties.Add(Nothing, c_Items)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  If Not pLoadItems(c) Then Exit Function
  c.Name = c_Items
  c.Key = K_ITEMS
  c.TabIndex = 0
  c.GridAdd = True
  c.GridEdit = True
  c.GridRemove = True
  
  
  m_ItemsDeleted = vbNullString
  
  Set c = m_Items.Properties.Add(Nothing, c_Gastos)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  If Not pLoadGastos(c) Then Exit Function
  c.Name = c_Gastos
  c.Key = K_GASTOS
  c.TabIndex = 1
  c.GridAdd = True
  c.GridEdit = True
  c.GridRemove = True
  
  
  m_GastosDeleted = vbNullString
  
  If Not m_Items.Show(Me) Then Exit Function
  
  Set AbmGen = m_Footer
  AbmGen.ResetLayoutMembers
  m_Footer.Properties.Clear
  
  Set c = m_Footer.Properties.Add(Nothing, cscPreeSubtotal)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.Name = LNGGetText(1579, vbNullString) 'Sub Total
  c.Key = K_SUBTOTAL
  c.Value = m_SubTotal
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  
  
  Set c = m_Footer.Properties.Add(Nothing, cscPreeImportedesc1)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.Name = LNGGetText(1573, vbNullString) 'Desc. 1
  c.Key = K_DESCUENTO1
  c.Value = m_ImporteDesc1
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  
  
  Set c = m_Footer.Properties.Add(Nothing, cscPreeImportedesc2)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.Name = LNGGetText(1580, vbNullString) 'Desc. 2
  c.Key = K_DESCUENTO2
  c.Value = m_ImporteDesc2
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  
  
  Set c = m_Footer.Properties.Add(Nothing, cscPreeNeto)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.Name = LNGGetText(1581, vbNullString) 'Neto
  c.Key = K_NETO
  c.Value = m_Neto
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  
  
  Set c = m_Footer.Properties.Add(Nothing, cscPreeIvari)
  c.PropertyType = cspNumeric
  c.Name = LNGGetText(1582, vbNullString) 'IVA RI
  c.SubType = cspMoney
  c.Key = K_IVARI
  c.Value = m_Ivari
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  
  
  Set c = m_Footer.Properties.Add(Nothing, cscPreeIvarni)
  c.PropertyType = cspNumeric
  c.Name = LNGGetText(1583, vbNullString) 'IVA RNI
  c.SubType = cspMoney
  c.Key = K_IVARNI
  c.Value = m_Ivarni
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  
  
  Set c = m_Footer.Properties.Add(Nothing, cscPreeTotal)
  c.PropertyType = cspNumeric
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Name = LNGGetText(1584, vbNullString) 'Total
  c.SubType = cspMoney
  c.Key = K_TOTAL
  c.Value = m_Total
  c.Enabled = False
  
  
  pSetEnabled
  
  If Not m_Footer.Show(Me) Then Exit Function
  
  ' Preferencias del Usuario
  '
  If bValidateDocDefault Then
    cIABMClient_PropertyChange K_DOC_ID
  End If
  
  LoadCollection = True
End Function

Private Function pLoadItems(ByRef IProperty As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  Dim pue_id_origen  As Long
  Dim pue_id_destino As Long
  
  sqlstmt = "sp_DocPresupuestoEnvioGetItems " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  With IProperty.Grid.Columns
    .Clear
    IProperty.Grid.Rows.Clear
  
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_PREEI_ID
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1367, vbNullString) 'Articulo
    o.PropertyType = cspHelp
    o.Table = csProducto
    o.Width = 1000
    If m_pr_id_Envios <> csNO_ID Then
      Set o.DefaultValue = New cABMGridRowValue
      With o.DefaultValue
        .ID = m_pr_id_Envios
        .Value = m_ProductoEnvios
      End With
    End If
    o.Key = KI_PR_ID
    
    Set o = .Add(Nothing)
    o.Name = "u."
    o.PropertyType = cspText
    o.Width = 600
    o.Key = KI_UNIDAD
    o.Enabled = False
    
    Set o = .Add(Nothing)
    o.Name = C_strDescrip
    o.PropertyType = cspText
    o.Width = 1000
    o.Key = KI_DESCRIP
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(2379, vbNullString) 'Kilos
    o.Format = m_GeneralConfig.FormatDecCantidad
    o.PropertyType = cspNumeric
    o.SubType = cspInteger
    o.Width = 800
    o.Key = KI_CANTIDAD
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(2380, vbNullString) 'Volumen
    o.Format = m_GeneralConfig.FormatDecCantidad
    o.PropertyType = cspNumeric
    o.SubType = cspDouble
    o.Width = 1000
    o.Key = KI_VOLUMEN
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(2381, vbNullString) 'Kilos Teóricos
    o.Format = m_GeneralConfig.FormatDecCantidad
    o.PropertyType = cspNumeric
    o.SubType = cspDouble
    o.Width = 1200
    o.Key = KI_KILOS
    o.Enabled = False
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1901, vbNullString) 'Origen
    o.PropertyType = cspHelp
    o.Table = csPuerto
    o.Width = 1000
    o.Key = KI_PUE_ID_ORIGEN
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1902, vbNullString) 'Destino
    o.PropertyType = cspHelp
    o.Table = csPuerto
    o.Width = 1000
    o.Key = KI_PUE_ID_DESTINO
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1050, vbNullString) 'Transporte
    o.PropertyType = cspText
    o.Width = 1000
    o.Key = KI_TRANS_ID
    o.Visible = True
    o.Enabled = False
    
    Set o = .Add(Nothing, cscTrfiId)
    o.Name = LNGGetText(2382, vbNullString) 'Precio Tarifa
    o.PropertyType = cspHelp
    o.Table = csTarifaItem
    o.HelpFilter = "0,0"
    o.Format = "0.00"
    o.Width = 1000
    o.Key = KI_TRFI_ID
    o.Visible = True
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1586, vbNullString) 'Precio
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Width = 1000
    o.Format = m_GeneralConfig.FormatDecImporte
    o.Key = KI_PRECIO
    o.Enabled = True
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1227, vbNullString) 'Mínimo
    o.Format = m_GeneralConfig.FormatDecCantidad
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Width = 800
    o.Key = KI_MINIMO
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1581, vbNullString) 'Neto
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Format = m_GeneralConfig.FormatDecImporte
    o.Width = 1000
    o.Key = KI_NETO
    o.Enabled = False
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1582, vbNullString) 'IVA RI
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Format = m_GeneralConfig.FormatDecImporte
    o.Width = 800
    o.Key = KI_IVARI
    o.Enabled = False
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1583, vbNullString) 'IVA RNI
    o.PropertyType = cspNumeric
    o.Format = m_GeneralConfig.FormatDecImporte
    o.SubType = cspMoney
    o.Width = 800
    o.Key = KI_IVARNI
    o.Enabled = False
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1228, vbNullString) 'Importe
    o.PropertyType = cspNumeric
    o.Format = m_GeneralConfig.FormatDecImporte
    o.SubType = cspMoney
    o.Width = 1000
    o.Key = KI_IMPORTE
    o.Enabled = False
    
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_IVARIPercent
    
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_IVARNIPercent
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1057, vbNullString) 'Centro de Costo
    o.PropertyType = cspHelp
    o.Table = csCentroCosto
    o.Width = 1800
    o.Key = KI_CCOS_ID
  End With
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = IProperty.Grid.Rows.Add(Nothing, rs(cscPreeiId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPreeiId)
    fv.Key = KI_PREEI_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPrNombreventa)
    fv.ID = gDB.ValField(rs.fields, cscPrId)
    fv.Key = KI_PR_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscUnNombre)
    fv.Key = KI_UNIDAD
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPreeiDescrip)
    fv.Key = KI_DESCRIP
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPreeiCantidad)
    fv.Key = KI_CANTIDAD
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPreeiVolumen)
    fv.Key = KI_VOLUMEN
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPreeiKilos)
    fv.Key = KI_KILOS
    
    pue_id_origen = gDB.ValField(rs.fields, cscPueIdOrigen)
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, "Origen")
    fv.ID = pue_id_origen
    fv.Key = KI_PUE_ID_ORIGEN
    
    pue_id_destino = gDB.ValField(rs.fields, cscPueIdDestino)
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, "Destino")
    fv.ID = pue_id_destino
    fv.Key = KI_PUE_ID_DESTINO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscTransNombre)
    fv.ID = gDB.ValField(rs.fields, cscTransId)
    fv.Key = KI_TRANS_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPreeiPrecioTarifa)
    fv.ID = gDB.ValField(rs.fields, cscTrfiId)
    fv.Key = KI_TRFI_ID
    Set fv.Format = New cABMGridCellFormat
    With fv.Format
      .PropertyType = cspHelp
      .Table = csTarifaItem
      .HelpFilter = pue_id_origen & "," & pue_id_destino
      .Format = "0.00"
    End With
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPreeiPrecio)
    fv.Key = KI_PRECIO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPreeiMinimo)
    fv.Key = KI_MINIMO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPreeiNeto)
    fv.Key = KI_NETO

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPreeiIvari)
    fv.Key = KI_IVARI

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPreeiIvarni)
    fv.Key = KI_IVARNI

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPreeiImporte)
    fv.Key = KI_IMPORTE

    Set fv = F.Add(Nothing)
    If m_bIva Then
      fv.Value = gDB.ValField(rs.fields, "iva_ri_porcentaje")
    Else
      fv.Value = 0
    End If
    fv.Key = KI_IVARIPercent

    Set fv = F.Add(Nothing)
    If m_bIvaRni Then
      fv.Value = gDB.ValField(rs.fields, "iva_rni_porcentaje")
    Else
      fv.Value = 0
    End If
    fv.Key = KI_IVARNIPercent
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscCcosNombre)
    fv.ID = gDB.ValField(rs.fields, cscCcosId)
    fv.Key = KI_CCOS_ID
    
    rs.MoveNext
  Wend
  
  pLoadItems = True
End Function

Private Sub pLoadProductosDefault()
  On Error GoTo ControlError

  Dim Cfg As cEnvioConfig
  Set Cfg = New cEnvioConfig
  
  If Not Cfg.Load Then Exit Sub
  
  m_pr_id_Envios = Cfg.Pr_id_Envio
  m_pr_id_Gastos = Cfg.Pr_id_Gasto
  
  m_ProductoEnvios = Cfg.ProductoEnvio
  m_ProductoGastos = Cfg.ProductoGasto

  GoTo ExitProc
ControlError:
  MngError Err, "pLoadProductosDefault", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pLoadGastos(ByRef IProperty As cIABMProperty) As Boolean
  Dim sqlstmt   As String
  Dim trfg_id   As Long
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_DocPresupuestoEnvioGetGastos " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadGastos", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  With IProperty.Grid.Columns
    .Clear
    IProperty.Grid.Rows.Clear
  
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_PREEG_ID
    
    Set o = .Add(Nothing)
    o.Key = KI_TRANS_ID
    o.Visible = False
    
    Set o = .Add(Nothing)
    o.Key = KI_TRFG_ID
    o.Visible = False
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1367, vbNullString) 'Articulo
    o.PropertyType = cspHelp
    o.Table = csProducto
    o.Width = 1800
    If m_pr_id_Gastos <> csNO_ID Then
      Set o.DefaultValue = New cABMGridRowValue
      With o.DefaultValue
        .ID = m_pr_id_Gastos
        .Value = m_ProductoGastos
      End With
    End If
    o.Key = KI_PR_ID
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1221, vbNullString) 'Gasto
    o.PropertyType = cspHelp
    o.Table = csGasto
    o.Width = 1400
    o.Key = KI_GTO_ID
    
    Set o = .Add(Nothing)
    o.Name = C_strDescrip
    o.PropertyType = cspText
    o.Width = 1200
    o.Key = KI_DESCRIP
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1374, vbNullString) 'Cantidad
    o.Format = m_GeneralConfig.FormatDecCantidad
    o.PropertyType = cspNumeric
    o.SubType = cspDouble
    o.Width = 1200
    o.Key = KI_CANTIDAD
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(2382, vbNullString) 'Precio Tarifa
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Width = 1200
    o.Format = m_GeneralConfig.FormatDecImporte
    o.Key = KI_PRECIOTARIFAGASTO
    o.Enabled = False
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1586, vbNullString) 'Precio
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Width = 1200
    o.Format = m_GeneralConfig.FormatDecImporte
    o.Key = KI_PRECIO
    o.Enabled = True
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1581, vbNullString) 'Neto
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Format = m_GeneralConfig.FormatDecImporte
    o.Width = 1200
    o.Key = KI_NETO
    o.Enabled = False
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1582, vbNullString) 'IVA RI
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Format = m_GeneralConfig.FormatDecImporte
    o.Width = 1200
    o.Key = KI_IVARI
    o.Enabled = False
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1583, vbNullString) 'IVA RNI
    o.PropertyType = cspNumeric
    o.Format = m_GeneralConfig.FormatDecImporte
    o.SubType = cspMoney
    o.Width = 1200
    o.Key = KI_IVARNI
    o.Enabled = False
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1228, vbNullString) 'Importe
    o.PropertyType = cspNumeric
    o.Format = m_GeneralConfig.FormatDecImporte
    o.SubType = cspMoney
    o.Width = 1200
    o.Key = KI_IMPORTE
    o.Enabled = False
    
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_IVARIPercent
    
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_IVARNIPercent
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1057, vbNullString) 'Centro de Costo
    o.PropertyType = cspHelp
    o.Table = csCentroCosto
    o.Width = 1800
    o.Key = KI_CCOS_ID
  End With
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = IProperty.Grid.Rows.Add(Nothing, rs(cscpreegId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = rs(cscpreegId).Value
    fv.Key = KI_PREEG_ID
    
    Set fv = F.Add(Nothing)
    fv.ID = gDB.ValField(rs.fields, cscTransId)
    fv.Key = KI_TRANS_ID
    
    trfg_id = gDB.ValField(rs.fields, csctrfgId)
    Set fv = F.Add(Nothing, csctrfgId)
    fv.Value = gDB.ValField(rs.fields, csctrfgImporte)
    fv.ID = trfg_id
    fv.Key = KI_TRFG_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPrNombreventa)
    fv.ID = gDB.ValField(rs.fields, cscPrId)
    fv.Key = KI_PR_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscGtoNombre)
    fv.ID = gDB.ValField(rs.fields, cscGtoId)
    fv.Key = KI_GTO_ID
    If trfg_id <> csNO_ID Then
      Set fv.Format = New cABMGridCellFormat
      fv.Format.Enabled = False
    End If
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscpreegDescrip)
    fv.Key = KI_DESCRIP
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscpreegCantidad)
    fv.Key = KI_CANTIDAD
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscpreegPrecioTarifa)
    fv.Key = KI_PRECIOTARIFAGASTO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscpreegPrecio)
    fv.Key = KI_PRECIO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscpreegNeto)
    fv.Key = KI_NETO

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscpreegIvari)
    fv.Key = KI_IVARI

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscpreegIvarni)
    fv.Key = KI_IVARNI

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscpreegImporte)
    fv.Key = KI_IMPORTE

    Set fv = F.Add(Nothing)
    If m_bIva Then
      fv.Value = gDB.ValField(rs.fields, "iva_ri_porcentaje")
    Else
      fv.Value = 0
    End If
    fv.Key = KI_IVARIPercent

    Set fv = F.Add(Nothing)
    If m_bIvaRni Then
      fv.Value = gDB.ValField(rs.fields, "iva_rni_porcentaje")
    Else
      fv.Value = 0
    End If
    fv.Key = KI_IVARNIPercent
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscCcosNombre)
    fv.ID = gDB.ValField(rs.fields, cscCcosId)
    fv.Key = KI_CCOS_ID
    
    rs.MoveNext
  Wend
  
  pLoadGastos = True
End Function

Private Function Load(ByVal ID As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "sp_DocPresupuestoEnvioGet " & EmpId & "," & ID & "," & gDB.UserId
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscPreeId)
    m_Numero = gDB.ValField(rs.fields, cscPreeNumero)
    m_Nrodoc = gDB.ValField(rs.fields, cscPreeNrodoc)
    m_Descrip = gDB.ValField(rs.fields, cscPreeDescrip)
    m_Fecha = gDB.ValField(rs.fields, cscPreeFecha)
    m_Fechaentrega = gDB.ValField(rs.fields, cscPreeFechaentrega)
    m_Neto = gDB.ValField(rs.fields, cscPreeNeto)
    m_Ivari = gDB.ValField(rs.fields, cscPreeIvari)
    m_Ivarni = gDB.ValField(rs.fields, cscPreeIvarni)
    m_Total = gDB.ValField(rs.fields, cscPreeTotal)
    m_SubTotal = gDB.ValField(rs.fields, cscPreeSubtotal)
    m_Descuento1 = gDB.ValField(rs.fields, cscPreeDescuento1)
    m_Descuento2 = gDB.ValField(rs.fields, cscPreeDescuento2)
    m_ImporteDesc1 = gDB.ValField(rs.fields, cscPreeImportedesc1)
    m_ImporteDesc2 = gDB.ValField(rs.fields, cscPreeImportedesc2)
    m_cli_id = gDB.ValField(rs.fields, cscCliId)
    m_Cliente = gDB.ValField(rs.fields, cscCliNombre)
    m_ccos_id = gDB.ValField(rs.fields, cscCcosId)
    m_CentroCosto = gDB.ValField(rs.fields, cscCcosNombre)
    m_suc_id = gDB.ValField(rs.fields, cscSucId)
    m_Sucursal = gDB.ValField(rs.fields, cscSucNombre)
    m_ven_id = gDB.ValField(rs.fields, cscVenId)
    m_Vendedor = gDB.ValField(rs.fields, cscVenNombre)
    m_doc_id = gDB.ValField(rs.fields, cscDocId)
    m_Documento = gDB.ValField(rs.fields, cscDocNombre)
    m_Doct_id = gDB.ValField(rs.fields, cscDoctId)
    m_cpg_id = gDB.ValField(rs.fields, cscCpgId)
    m_CondicionPago = gDB.ValField(rs.fields, cscCpgNombre)
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)
    m_est_id = gDB.ValField(rs.fields, cscEstId)
    m_Estado = gDB.ValField(rs.fields, cscEstNombre)
    m_Firmado = gDB.ValField(rs.fields, cscPreeFirmado)

    m_TaPropuesto = gDB.ValField(rs.fields, cscTa_Propuesto)
    m_TaMascara = gDB.ValField(rs.fields, cscTa_Mascara)
    
    m_DocEditable = gDB.ValField(rs.fields, cscDocEditable)
    m_DocEditMsg = gDB.ValField(rs.fields, cscDoceditMsg)

    m_bIva = gDB.ValField(rs.fields, cscbIvaRi)
    m_bIvaRni = gDB.ValField(rs.fields, cscbIvaRni)
    
    m_LastDoc = m_doc_id
    m_LastCli = m_cli_id
    m_LastDocName = m_Documento
    m_LastCliName = m_Cliente

  Else
    m_Id = csNO_ID
    m_Numero = 0
    m_Nrodoc = vbNullString
    m_Descrip = vbNullString
    m_Fecha = VDGetDateById(csToday)
    m_Fechaentrega = VDGetDateById(csTomorrow)
    m_Neto = 0
    m_Ivari = 0
    m_Ivarni = 0
    m_Total = 0
    m_SubTotal = 0
    m_Descuento1 = 0
    m_Descuento2 = 0
    m_ImporteDesc1 = 0
    m_ImporteDesc2 = 0
    m_cli_id = csNO_ID
    m_Cliente = vbNullString
    m_ccos_id = csNO_ID
    m_CentroCosto = vbNullString
    m_doc_id = csNO_ID
    m_Documento = vbNullString
    m_Doct_id = csNO_ID
    m_cpg_id = csNO_ID
    m_CondicionPago = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_est_id = csNO_ID
    m_Estado = vbNullString
    m_suc_id = User.suc_id
    m_Sucursal = User.Sucursal
    m_ven_id = csNO_ID
    m_Vendedor = vbNullString
    m_Firmado = False
  
    m_TaPropuesto = False
    m_TaMascara = vbNullString
    
    m_doc_id = m_LastDoc
    m_cli_id = m_LastCli
    m_Cliente = m_LastCliName
    m_Documento = m_LastDocName
  
    m_bIvaRni = False
    m_bIva = False
    
    DocEditableGet m_doc_id, m_DocEditable, m_DocEditMsg, csPreEnvNewPresupuesto
  End If

  Load = True
End Function
' construccion - destruccion

Private Property Set cIEditGenericDoc_Footer(ByVal rhs As CSInterfacesABM.cIABMGeneric)
  Set m_Footer = rhs
  
  If rhs Is Nothing Then Exit Property
  
  m_Footer.IsDocument = True
  m_Footer.IsFooter = True
  Set m_Footer.ObjForm = m_ObjAbm.ObjForm
End Property

Private Property Set cIEditGenericDoc_Items(ByVal rhs As CSInterfacesABM.cIABMGeneric)
  Set m_Items = rhs
  
  If rhs Is Nothing Then Exit Property
  
  m_Items.IsDocument = True
  m_Items.IsItems = True
  Set m_Items.ObjForm = m_ObjAbm.ObjForm
End Property

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_2383 As String
  
  str_2383 = LNGGetText(2383, vbNullString) '&Envios
  Set m_Host = Host
  m_Host.Server.AddMenu str_2383, csMenuEnum.csMenuEnvio, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(2384, vbNullString), csPreEnvListPresupuesto, str_2383, 0, True, False, False, False, False, Me
                        '&Presupuestos
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
#If PREPROC_SFS Then
  m_Host.MenuListDocClick "CSABMInterface2.cABMGeneric", "CSEnvio2.cPresupuestoEnvio", "CSABMInterface2.CABMGenericListDoc", "CSEnvio2.cPresupuestoEnvioListDoc", Me, c_strTitle, 0
#Else
  m_Host.MenuListDocClick "CSABMInterface2.cABMGenericDocEx", "CSEnvio2.cPresupuestoEnvio", "CSABMInterface2.CABMGenericListDoc", "CSEnvio2.cPresupuestoEnvioListDoc", Me, c_strTitle, 0
#End If
End Function

Private Function pSaveItems(ByVal ID As Long) As Boolean
  Dim register  As cRegister
  Dim IProperty As cIABMProperty
  Dim iOrden    As Long
  
  Set register = New cRegister
  
  With register
    
    .fieldId = cscPreeiTMPId
    .Table = csTPresupuestoEnvioItemTMP

    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In m_Items.Properties.Item(c_Items).Grid.Rows
      
      .ID = csNew
      
      With .fields
      
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_PREEI_ID
              If m_Copy Then
                .Add2 cscPreeiId, csNew, csInteger
              Else
                .Add2 cscPreeiId, Val(Cell.Value), csInteger
              End If
            Case KI_CANTIDAD
              .Add2 cscPreeiCantidad, Cell.Value, csDouble
            Case KI_VOLUMEN
              .Add2 cscPreeiVolumen, Cell.Value, csDouble
            Case KI_KILOS
              .Add2 cscPreeiKilos, Cell.Value, csDouble
            Case KI_DESCRIP
              .Add2 cscPreeiDescrip, Cell.Value, csText
            Case KI_PRECIO
              .Add2 cscPreeiPrecio, Cell.Value, csCurrency
            Case KI_MINIMO
              .Add2 cscPreeiMinimo, Cell.Value, csCurrency
            Case KI_IMPORTE
              .Add2 cscPreeiImporte, Cell.Value, csCurrency
            Case KI_NETO
              .Add2 cscPreeiNeto, Cell.Value, csCurrency
            Case KI_IVARI
              .Add2 cscPreeiIvari, Cell.Value, csCurrency
            Case KI_IVARNI
              .Add2 cscPreeiIvarni, Cell.Value, csCurrency
            Case KI_IVARIPercent
              .Add2 cscPreeiIvariporc, Cell.Value, csDouble
            Case KI_IVARNIPercent
              .Add2 cscPreeiIvarniporc, Cell.Value, csDouble
            Case KI_PR_ID
              .Add2 cscPrId, Cell.ID, csId
            Case KI_CCOS_ID
              .Add2 cscCcosId, Cell.ID, csId
            Case KI_TRFI_ID
              .Add2 cscTrfiId, Cell.ID, csId
              .Add2 cscPreeiPrecioTarifa, Val(Cell.Value), csCurrency
            Case KI_TRANS_ID
              .Add2 cscTransId, Cell.ID, csId
            Case KI_PUE_ID_ORIGEN
              .Add2 cscPueIdOrigen, Cell.ID, csId
            Case KI_PUE_ID_DESTINO
              .Add2 cscPueIdDestino, Cell.ID, csId
          End Select
        Next
            
        iOrden = iOrden + 1
        .Add2 cscPreeiOrden, iOrden, csInteger
        .Add2 cscPreeTMPId, ID, csId
        
        .HaveLastUpdate = False
        .HaveWhoModify = False
      
      End With
      
      If Not gDB.Save(register, , _
                      "pSaveItems", _
                      C_Module, _
                      c_ErrorSave) Then Exit Function
    Next
  
    Dim sqlstmt As String
    
    If m_ItemsDeleted <> vbNullString And m_Id <> csNO_ID And Not m_Copy Then
    
      Dim vDeletes As Variant
      Dim i As Long
      
      m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
      vDeletes = Split(m_ItemsDeleted, ",")
      
      .fieldId = cscPreeibTMPId
      .Table = csTPresupuestoEnvioItemBorradoTMP
            
      .fields.HaveLastUpdate = False
      .fields.HaveWhoModify = False
      
      For i = 0 To UBound(vDeletes)
          
        With .fields
          .Clear
          register.ID = csNew
          
          .Add2 cscPreeiId, Val(vDeletes(i)), csInteger
          .Add2 cscPreeId, m_Id, csId
          .Add2 cscPreeTMPId, ID, csId
        End With
        
        If Not gDB.Save(register, , _
                        "pSaveItems", _
                        C_Module, _
                        c_ErrorSave) Then Exit Function
      Next
    End If
  
  End With
  
  pSaveItems = True
End Function

Private Function pSaveGastos(ByVal ID As Long) As Boolean
  Dim register  As cRegister
  Dim IProperty As cIABMProperty
  Dim iOrden    As Long
  
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  Set register = New cRegister
  
  With register
    .fieldId = cscpreegTMPId
    .Table = csTPresupuestoEnvioGastoTMP
  
    .fields.HaveLastUpdate = False
    .fields.HaveWhoModify = False
  
    For Each Row In m_Items.Properties.Item(c_Gastos).Grid.Rows
    
      .ID = csNew
      
      With .fields
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_PREEG_ID
              If m_Copy Then
                .Add2 cscpreegId, csNew, csInteger
              Else
                .Add2 cscpreegId, Val(Cell.Value), csInteger
              End If
            Case KI_CANTIDAD
              .Add2 cscpreegCantidad, Cell.Value, csDouble
            Case KI_DESCRIP
              .Add2 cscpreegDescrip, Cell.Value, csText
            Case KI_PRECIO
              .Add2 cscpreegPrecio, Cell.Value, csCurrency
            Case KI_IMPORTE
              .Add2 cscpreegImporte, Cell.Value, csCurrency
            Case KI_NETO
              .Add2 cscpreegNeto, Cell.Value, csCurrency
            Case KI_IVARI
              .Add2 cscpreegIvari, Cell.Value, csCurrency
            Case KI_IVARNI
              .Add2 cscpreegIvarni, Cell.Value, csCurrency
            Case KI_IVARIPercent
              .Add2 cscpreegIvariporc, Cell.Value, csDouble
            Case KI_IVARNIPercent
              .Add2 cscpreegIvarniporc, Cell.Value, csDouble
            Case KI_PR_ID
              .Add2 cscPrId, Cell.ID, csId
            Case KI_TRFG_ID
              .Add2 csctrfgId, Cell.ID, csId
            Case KI_TRANS_ID
              .Add2 cscTransId, Cell.ID, csId
            Case KI_GTO_ID
              .Add2 cscGtoId, Cell.ID, csId
            Case KI_CCOS_ID
              .Add2 cscCcosId, Cell.ID, csId
          End Select
        Next
        
        iOrden = iOrden + 1
        .Add2 cscpreegOrden, iOrden, csInteger
        .Add2 cscPreeTMPId, ID, csId
        
      End With
      
      If Not gDB.Save(register, , _
                      "pSaveGastos", _
                      C_Module, _
                      c_ErrorSave) Then Exit Function
    Next
    
    Dim sqlstmt As String
    
    If m_GastosDeleted <> vbNullString And m_Id <> csNO_ID Then
    
      Dim vDeletes As Variant
      Dim i As Long
      
      m_GastosDeleted = RemoveLastColon(m_GastosDeleted)
      vDeletes = Split(m_GastosDeleted, ",")
      
      .fieldId = cscpreegbTMPId
      .Table = csTPresupuestoEnvioGastoBorradoTMP
      
      .fields.HaveLastUpdate = False
      .fields.HaveWhoModify = False
      
      For i = 0 To UBound(vDeletes)
      
        .ID = csNew
        
        With .fields
          .Clear
          .Add2 cscpreegId, Val(vDeletes(i)), csInteger
          .Add2 cscPreeId, m_Id, csId
          .Add2 cscPreeTMPId, ID, csId
        End With
        
        If Not gDB.Save(register, , _
                        "pSaveGastos", _
                        C_Module, _
                        c_ErrorSave) Then Exit Function
      Next
      
    End If
  End With
  
  pSaveGastos = True
End Function

' Reglas del Objeto de Negocios
Private Sub pShowImporteAndIva(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal K_GRID As Long)
  Dim Importe As Double
  Dim Neto    As Double
  Dim IvaRi   As Double
  Dim IvaRni  As Double
  Dim ColCantidad As Long
  
  Select Case K_GRID
    Case K_ITEMS
      ColCantidad = KI_KILOS
    Case K_GASTOS
      ColCantidad = KI_CANTIDAD
  End Select

  
  Neto = Val(pCell(Row, ColCantidad).Value) * Val(pCell(Row, KI_PRECIO).Value)
  
  If K_GRID = K_ITEMS Then
    With pCell(Row, KI_MINIMO)
      If Neto < Val(.Value) Then
        Neto = Val(.Value)
      End If
    End With
  End If
  
  If m_bIva Then
    IvaRi = (Neto * Val(pCell(Row, KI_IVARIPercent).Value)) / 100
  End If
  If m_bIvaRni Then
    IvaRni = (Neto * Val(pCell(Row, KI_IVARNIPercent).Value)) / 100
  End If
  Importe = Neto + IvaRi + IvaRni
  
  pCell(Row, KI_NETO).Value = Neto
  pCell(Row, KI_IVARI).Value = IvaRi
  pCell(Row, KI_IVARNI).Value = IvaRni
  pCell(Row, KI_IMPORTE).Value = Importe
End Sub
  
Private Sub pShowTotalesAux(ByRef Neto As Double, _
                            ByRef IvaRi As Double, _
                            ByRef IvaRni As Double, _
                            ByRef Desc1 As Double, _
                            ByRef Desc2 As Double, _
                            ByRef Rows As CSInterfacesABM.cIABMGridRows)
  
  Dim Row       As CSInterfacesABM.cIABMGridRow
  Dim lRow      As Long
  
  For Each Row In Rows
    lRow = lRow + 1
    If pIsEmptyRowGasto(Row, lRow) Then Exit For
    Neto = Neto + Val(pCell(Row, KI_NETO).Value)
    IvaRi = IvaRi + Val(pCell(Row, KI_IVARI).Value)
    IvaRni = IvaRni + Val(pCell(Row, KI_IVARNI).Value)
  Next
  
End Sub

Private Sub pShowTotales()
  Dim Neto      As Double
  Dim IvaRi     As Double
  Dim IvaRni    As Double
  Dim Desc1     As Double
  Dim Desc2     As Double
  Dim Rows      As CSInterfacesABM.cIABMGridRows
  
  Dim Row       As CSInterfacesABM.cIABMGridRow
  
  pShowTotalesAux Neto, IvaRi, IvaRni, Desc1, Desc2, m_Items.Properties(c_Items).Grid.Rows
  pShowTotalesAux Neto, IvaRi, IvaRni, Desc1, Desc2, m_Items.Properties(c_Gastos).Grid.Rows
  
  m_Footer.Properties(cscPreeSubtotal).Value = Neto
  
  Desc1 = m_ObjAbm.Properties(cscPreeDescuento1).Value
  Desc2 = m_ObjAbm.Properties(cscPreeDescuento2).Value
  
  Desc1 = Neto * Desc1 / 100
  m_Footer.Properties(cscPreeImportedesc1).Value = Desc1
  
  Neto = Neto - Desc1
  
  Desc2 = Neto * Desc2 / 100
  m_Footer.Properties(cscPreeImportedesc2).Value = Desc2
  
  Neto = Neto - Desc2
  
  m_Footer.Properties(cscPreeNeto).Value = Neto
  m_Footer.Properties(cscPreeIvari).Value = IvaRi
  m_Footer.Properties(cscPreeIvarni).Value = IvaRni
  m_Footer.Properties(cscPreeTotal).Value = Neto + IvaRni + IvaRi
  
  m_Footer.RefreshControls
End Sub

Private Sub pSetTasasImpositivas(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal PR_ID As Long, ByVal pr_nombre As String)
  Dim ti_ri    As Long
  Dim ti_rni   As Long
  
  If PR_ID = 0 Then Exit Sub
  
  If Not GetTasaFromProducto(PR_ID, ti_ri, ti_rni, False) Then Exit Sub
  
  If ti_ri = 0 Then
    MsgWarning LNGGetText(1597, vbNullString, pr_nombre)
                'El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de & _
                  ventas para el iva responsable inscripto
    Exit Sub
  End If
  
  If ti_rni = 0 Then
    MsgWarning LNGGetText(1598, vbNullString, pr_nombre)
               'El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de & _
                ventas para el iva responsable no inscripto
    Exit Sub
  End If
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  If m_bIva Then
    sqlstmt = "select ti_porcentaje,cue_id from tasaimpositiva where ti_id = " & ti_ri
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
    
    If Not rs.EOF Then
      pCell(Row, KI_IVARIPercent).Value = gDB.ValField(rs.fields, cscTiPorcentaje)
    End If
  Else
    pCell(Row, KI_IVARIPercent).Value = 0
  End If
  
  If m_bIvaRni Then
    sqlstmt = "select ti_porcentaje,cue_id from tasaimpositiva where ti_id = " & ti_rni
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
    
    If Not rs.EOF Then
      pCell(Row, KI_IVARNIPercent).Value = gDB.ValField(rs.fields, cscTiPorcentaje)
    End If
  Else
    pCell(Row, KI_IVARNIPercent).Value = 0
  End If
End Sub

Private Sub pSetDataProducto(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal PR_ID As Long)
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select un_nombre from producto, unidad where un_id_venta = un_id and pr_id = " & PR_ID
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
    pCell(Row, KI_UNIDAD).Value = gDB.ValField(rs.fields, cscUnNombre)
  End If
End Sub

Private Sub pSetPrecios(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal PR_ID As Long)
  Dim Precio    As Double
  
  pCell(Row, KI_PRECIO).Value = Precio
End Sub

Private Sub pSetEnabled()
  Dim bState As Boolean
  Dim Prop   As cIABMProperty
  
  If m_DocEditable Then
    bState = m_ObjAbm.Properties.Item(cscDocId).HelpId <> csNO_ID
  Else
    bState = False
  End If
  
  For Each Prop In m_ObjAbm.Properties
    If Prop.Key <> K_DOC_ID And Prop.Key <> K_NUMERO And Prop.Key <> K_EST_ID Then
    
      If bState Then
        If Prop.Key <> K_NRODOC Then
          Prop.Enabled = bState
        Else
          Prop.Enabled = m_TaPropuesto
        End If
      Else
        Prop.Enabled = False
      End If
    End If
  Next
  
  For Each Prop In m_Items.Properties
    Prop.Enabled = bState
  Next
  
#If PREPROC_SFS Then
  Dim AbmGen  As cABMGeneric
#Else
  Dim AbmGen  As cABMGenericDocEx
#End If

  Set AbmGen = m_Items
  AbmGen.RefreshEnabledState m_Items.Properties

  Set AbmGen = m_ObjAbm
  AbmGen.RefreshEnabledState m_ObjAbm.Properties

End Sub

Private Sub pSetDatosCliente()
  Dim lp_id       As Long
  Dim ld_id       As Long
  Dim cpg_id      As Long
  Dim cpg_nombre  As String
  Dim LP          As cListaPrecio
  Dim LD          As cListaDescuento
  Dim iProp       As cIABMProperty
  Dim Filter      As String
  
  With m_ObjAbm.Properties.Item(cscCliId)
    If m_LastCli = .HelpId Then
      Exit Sub
    End If
    m_LastCli = .HelpId
  End With

  If Not GetClienteData(m_LastCli, lp_id, ld_id, cpg_id) Then Exit Sub
  
  ' Condicion de pago
  If cpg_id <> csNO_ID Then
    
    If Not gDB.GetData(csTCondicionPago, cscCpgId, cpg_id, cscCpgNombre, cpg_nombre) Then Exit Sub
    
    Set iProp = m_ObjAbm.Properties.Item(cscCpgId)
    iProp.Value = cpg_nombre
    iProp.HelpId = cpg_id
    m_ObjAbm.ShowValue iProp
  End If
  
  pGetIvaFromCliente m_LastCli
End Sub

Private Sub pGetIvaFromCliente(ByVal Cli_id As Long)
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  Dim bIvaChanged As Boolean
  Dim bLastIva    As Boolean
  
  sqlstmt = "sp_clienteGetIva " & Cli_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  bLastIva = m_bIva
  m_bIva = gDB.ValField(rs.fields, "bIva")
  If bLastIva <> m_bIva Then bIvaChanged = True
  
  bLastIva = m_bIvaRni
  m_bIvaRni = gDB.ValField(rs.fields, "bIvaRni")
  If bLastIva <> m_bIvaRni Then bIvaChanged = True
  
  If bIvaChanged Then
    pShowTotales
  End If
End Sub

Private Function pFirmar() As Boolean
  Dim Doc     As cDocumento
  Dim us_id   As Long
  
  Set Doc = New cDocumento
  
  If m_Id = csNO_ID Then
    MsgWarning LNGGetText(1592, vbNullString)
                'Antes de poder firmar el documento debe guardarlo.
    Exit Function
  End If
  
  If m_Firmado Then
    If Not Ask(LNGGetText(1593, vbNullString), vbYes, LNGGetText(1594, vbNullString)) Then
               'El documento ya ha sido firmado desea borrar la firma, Firmar
      Exit Function
    End If
  End If
  
  If Not Doc.Firmar(m_doc_id, us_id) Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocPresupuestoEnvioFirmar " & m_Id & "," & us_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_est_id = gDB.ValField(rs.fields, cscEstId)
  m_Estado = gDB.ValField(rs.fields, cscEstNombre)
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties(csDocEstateID)
  
  With iProp
    .HelpId = m_est_id
    .Value = m_Estado
  End With
  
  gDB.GetData csTPresupuestoEnvio, cscPreeId, m_Id, cscPreeFirmado, m_Firmado
  
  m_ObjAbm.ShowValue iProp
  
  pFirmar = True
End Function

Private Function pMove(ByVal MoveTo As ABM_MSG) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim doc_id  As Long
  
  doc_id = m_ObjAbm.Properties(cscDocId).HelpId
  
  If doc_id = csNO_ID Then MsgInfo LNGGetText(1595, vbNullString)
                                    'Debe seleccionar un documento
  
  sqlstmt = "sp_DocPresupuestoEnvioMover " & MoveTo & "," & m_Numero & "," & doc_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  ' Si no obtuve ningun id al moverme
  '
  If rs.EOF Then
    
    Select Case MoveTo
      
      ' Si era siguiente ahora busco el ultimo
      '
      Case MSG_DOC_NEXT
        pMove MSG_DOC_LAST
      
      ' Si era anterior ahora busco el primero
      '
      Case MSG_DOC_PREVIOUS
        pMove MSG_DOC_FIRST
      
      ' Si no encontre ni ultimo ni primero
      ' es por que no hay ningun comprobante para
      ' este documento
      '
      Case MSG_DOC_FIRST, MSG_DOC_LAST
        
        ' Limpio incluso el ultimo cliente
        '
        m_LastCli = csNO_ID
        m_LastCliName = vbNullString
        
        ' Cargo un registro vacio
        '
        Load csNO_ID
        
        ' Refresco el formulario
        '
        pRefreshProperties
    
        ' Obtengo un nuevo numero de comprobante
        '
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscPreeNrodoc
    
    End Select
    
  Else
    If Not Load(gDB.ValField(rs.fields, 0)) Then Exit Function
    
    pRefreshProperties
  End If
  
  pMove = True
End Function

Private Sub pRefreshProperties()
  Dim c       As cIABMProperty
#If PREPROC_SFS Then
  Dim AbmGen  As cABMGeneric
#Else
  Dim AbmGen  As cABMGenericDocEx
#End If
  Dim Filter  As String
  
  With m_ObjAbm.Properties
    
    Set c = .Item(cscDocId)
    c.HelpId = m_doc_id
    c.Value = m_Documento
    
    Set c = .Item(cscPreeFecha)
    c.Value = m_Fecha
    
    Set c = .Item(cscPreeFechaentrega)
    c.Value = m_Fechaentrega
    
    Set c = .Item(cscCliId)
    c.HelpId = m_cli_id
    c.Value = m_Cliente
    
    Set c = .Item(csDocNumberID)
    c.Value = m_Numero
    
    Set c = .Item(csDocEstateID)
    c.Value = m_Estado
    
    Set c = .Item(cscPreeNrodoc)
    c.Value = m_Nrodoc
    c.TextMask = m_TaMascara
    c.TextAlign = vbRightJustify
    
    Set c = .Item(cscPreeDescuento1)
    c.Value = m_Descuento1
    
    Set c = .Item(cscPreeDescuento2)
    c.Value = m_Descuento2
    
    Set c = .Item(cscCpgId)
    c.HelpId = m_cpg_id
    c.Value = m_CondicionPago
    
    Set c = .Item(cscCcosId)
    c.HelpId = m_ccos_id
    c.Value = m_CentroCosto
    
    Set c = .Item(cscSucId)
    c.HelpId = m_suc_id
    c.Value = m_Sucursal
    
    Set c = .Item(cscVenId)
    c.HelpId = m_ven_id
    c.Value = m_Vendedor
    
    Set c = .Item(cscPreeDescrip)
    c.Value = m_Descrip
      
  End With
  
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValues m_ObjAbm.Properties
  
  AbmGen.ResetChanged
  
  Set c = m_Items.Properties.Item(c_Items)
  If Not pLoadItems(c) Then Exit Sub
  
  Set c = m_Items.Properties.Item(c_Gastos)
  If Not pLoadGastos(c) Then Exit Sub
  
  m_ItemsDeleted = vbNullString
  m_GastosDeleted = vbNullString
  
  Set AbmGen = m_Items
  AbmGen.ShowValues m_Items.Properties
  
  With m_Footer.Properties
  
    Set c = .Item(cscPreeSubtotal)
    c.Value = m_SubTotal
    
    Set c = .Item(cscPreeImportedesc1)
    c.Value = m_ImporteDesc1
    
    Set c = .Item(cscPreeImportedesc2)
    c.Value = m_ImporteDesc2
    
    Set c = .Item(cscPreeNeto)
    c.Value = m_Neto
    
    Set c = .Item(cscPreeIvari)
    c.Value = m_Ivari
    
    Set c = .Item(cscPreeIvarni)
    c.Value = m_Ivarni
    
    Set c = .Item(cscPreeTotal)
    c.Value = m_Total
  
  End With
  
  Set AbmGen = m_Footer
  AbmGen.ShowValues m_Footer.Properties
  
  pSetEnabled
End Sub

' Construccion - Destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_strTitle = LNGGetText(1601, vbNullString) 'Presupuestos
  c_ErrorSave = LNGGetText(2385, vbNullString) 'Error al grabar Presupuesto Envío
  
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  pLoadProductosDefault

  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load
  m_UserCfg.ValidatePREE

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
  Set m_Footer = Nothing
  Set m_Items = Nothing
  
  ' Preferencias del Usuario
  '
  Set m_UserCfg = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetItems() As cIABMProperty
  Set pGetItems = m_Items.Properties.Item(c_Items)
End Function

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

