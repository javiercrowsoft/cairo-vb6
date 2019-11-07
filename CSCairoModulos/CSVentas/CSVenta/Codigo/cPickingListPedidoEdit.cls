VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPickingListPedidoEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
Implements CSIDocumento.cIDocumento
'--------------------------------------------------------------------------------
' cPedidoVenta
' 09-05-2003

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cPedidoVenta"

Private Const csPrePVEditPedidoVta = 3001
Private Const csPrePVEditPrice = 3006

Private Const c_Items = "ITEMS"

Private Const c_Menu_ShowRemito = 1
Private Const c_Menu_ShowFactura = 2

' HIDECOLS
Private Const c_HideColsPv = "HideColsPv"

Private Const K_NUMERO                         As Integer = 1
Private Const K_NRODOC                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHA                          As Integer = 4
Private Const K_FECHAENTREGA                   As Integer = 5
Private Const K_NETO                           As Integer = 6
Private Const K_IVARI                          As Integer = 7
Private Const K_IVARNI                         As Integer = 8
Private Const K_TOTAL                          As Integer = 9
Private Const K_CLI_ID                         As Integer = 10
Private Const K_DOC_ID                         As Integer = 11
Private Const K_DOCT_ID                        As Integer = 12
Private Const K_LP_ID                          As Integer = 13
Private Const K_LD_ID                          As Integer = 14
Private Const K_ITEMS                          As Integer = 15
Private Const K_CPG_ID                         As Integer = 16
Private Const K_EST_ID                         As Integer = 17
Private Const K_CCOS_ID                        As Integer = 18
Private Const K_SUC_ID                         As Integer = 19
Private Const K_DESCUENTO1                     As Integer = 20
Private Const K_DESCUENTO2                     As Integer = 21
Private Const K_IMPORTEDESC1                   As Integer = 22
Private Const K_IMPORTEDESC2                   As Integer = 23
Private Const K_SUBTOTAL                       As Integer = 24
Private Const K_RAM_ID_STOCK                   As Integer = 25

Private Const K_VEN_ID                         As Integer = 26
Private Const K_LGJ_ID                         As Integer = 27
Private Const K_PRO_ID_ORIGEN                  As Integer = 29
Private Const K_PRO_ID_DESTINO                 As Integer = 30
Private Const K_TRANS_ID                       As Integer = 31
Private Const K_DEPL_ID                        As Integer = 32
Private Const K_CLIS_ID                        As Integer = 33

Private Const K_CHOF_ID                        As Integer = 36
Private Const K_CAM_ID                         As Integer = 37
Private Const K_CAM_ID_SEMI                    As Integer = 38
Private Const K_DESTINATARIO                   As Integer = 39

Private Const K_ORDENCOMPRA                    As Integer = 40

' HIDECOLS
Private Const K_HIDECOLS                       As Integer = 41

Private Const KI_PV_ID                          As Integer = 1
Private Const KI_PVI_ID                         As Integer = 2
Private Const KI_ORDEN                          As Integer = 3
Private Const KI_CANTIDAD                       As Integer = 4
Private Const KI_STOCK                          As Integer = 500
Private Const KI_STOCK_REAL                     As Integer = 501
Private Const KI_STOCK_PEDIDOS                  As Integer = 502
Private Const KI_DESCRIP                        As Integer = 6
Private Const KI_PRECIO                         As Integer = 7
Private Const KI_IMPORTE                        As Integer = 8
Private Const KI_NETO                           As Integer = 9
Private Const KI_IVARI                          As Integer = 10
Private Const KI_IVARNI                         As Integer = 11
Private Const KI_PR_ID                          As Integer = 13
Private Const KI_LPI_ID                         As Integer = 14
Private Const KI_LDI_ID                         As Integer = 15
Private Const KI_IVARIPercent                   As Integer = 16
Private Const KI_IVARNIPercent                  As Integer = 17
Private Const KI_DESCUENTO                      As Integer = 18
Private Const KI_UNIDAD                         As Integer = 19
Private Const KI_PRECIO_LP                      As Integer = 20
Private Const KI_PRECIO_USR                     As Integer = 21
Private Const KI_CCOS_ID                        As Integer = 22

' pseudo-constantes
Private c_ErrorSave As String

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
Private m_cli_id                       As Long
Private m_cliente                      As String
Private m_doc_id                       As Long
Private m_Documento                    As String
Private m_Doct_id                      As Long
Private m_Lp_id                        As Long
Private m_ListaPrecio                  As String
Private m_Ld_id                        As Long
Private m_ListaDescuento               As String
Private m_RamaStock                    As String
Private m_ram_id_stock                 As String
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_Firmado                      As Boolean

Private m_ven_id                       As Long
Private m_vendedor                     As String
Private m_lgj_id                       As Long
Private m_Legajo                       As String

Private m_clis_id                      As Long
Private m_ClienteSucursal              As String

Private m_pro_id_origen                As Long
Private m_ProOrigen                    As String
Private m_pro_id_destino               As Long
Private m_ProDestino                   As String

Private m_trans_id                     As String
Private m_Transporte                   As String

Private m_chof_id                      As Long
Private m_Chofer                       As String

Private m_cam_id                       As Long
Private m_Camion                       As String

Private m_cam_id_semi                  As Long
Private m_Semi                         As String

Private m_Destinatario                 As String

Private m_OrdenCompra                  As String

Private m_TaPropuesto                  As Boolean
Private m_TaMascara                    As String

Private m_Editing           As Boolean

Private m_Footer            As cIABMGeneric
Private m_Items             As cIABMGeneric
Private m_ObjAbm            As cIABMGeneric
Private m_ObjClient         As Object
Private m_bWasChanged       As Boolean

Private m_LastDoc           As Long
Private m_LastCli           As Long
Private m_LastDocName       As String
Private m_LastCliName       As String
Private m_LastTrans         As Long
Private m_LastChof          As Long

Private m_bIva              As Boolean
Private m_bIvaRni           As Boolean

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost

Private m_ItemsDeleted      As String

Private m_Copy              As Boolean

Private m_GeneralConfig     As cGeneralConfig
Private m_StockConfig       As cStockConfig

Private m_DocEditable       As Boolean
Private m_DocEditMsg        As String

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

' propiedades publicas
' propiedades privadas
' funciones publicas

' Edit Apply
'
Public Sub Refresh()
  Load m_Id
  pRefreshProperties
End Sub

Private Function pInitMembers() As Boolean
  
  Set m_ObjAbm = New cABMGeneric
  m_ObjAbm.IsDocument = True
  
  Set m_Footer = New cABMGeneric
  m_Footer.IsDocument = True
  m_Footer.IsFooter = True
  Set m_Footer.ObjForm = m_ObjAbm.ObjForm
  
  Set m_Items = New cABMGeneric
  m_Items.IsDocument = True
  m_Items.IsItems = True
  Set m_Items.ObjForm = m_ObjAbm.ObjForm
  
  If Not DocSecurityCanAccess(csPrePVEditPedidoVta, _
                              csNO_ID, _
                              csEDocTPreNew) Then
    Exit Function
  End If
  pInitMembers = True
End Function

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  cIABMClient_Copy = False
End Function

Private Function cIABMClient_EditNew() As Boolean
  cIABMClient_EditNew = False
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

  Doc.ClientTable = csTPedidoVenta
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
      cIABMClient_MessageEx = True
      pShowTotales m_Items.Properties(c_Items).Grid.Rows
    
    Case MSG_DOC_EDIT_STATE
      ShowEditState m_DocEditMsg, LNGGetText(1553, vbNullString)
                                    'Pedido de Venta
      
    Case MSG_DOC_DELETE
    
    Case MSG_DOC_APPLY
    
    Case MSG_DOC_ANULAR
  
    Case MSG_DOC_REFRESH
      Load m_Id
      pRefreshProperties
  
    Case MSG_DOC_INFO
      'If m_Id <> csNO_ID Then
      '  CSOAPI2.ShowInfo LNGGetText(1596, vbNullString), "sp_DocPedidoVentaStockInfo " & m_Id
                        'Pendientes de Stock
      'Else
      '  MsgWarning LNGGetText(1554, vbNullString)
                  'Antes de pedir Info sobre el Pedido debe guardarlo
      'End If
      
    Case MSG_DOC_NEW_WITH_WIZARD
      cIABMClient_MessageEx = True
    
    Case MSG_DOC_EX_GET_ITEMS
      Set cIABMClient_MessageEx = m_Items
    
    Case MSG_DOC_EX_GET_FOOTERS
      Set cIABMClient_MessageEx = m_Footer
  
    Case MSG_DOC_SEARCH                     ' En info cABMInteface nos
                                            ' indica si hay cambios sin
                                            ' guardar
      DocumentSearch csEDT_PedidoVenta, Me, Not CBool(Info)
  
    Case MSG_DOC_DOC_EDIT
  
    Case MSG_DOC_DOC_ACTION
    
    Case MSG_MENU_AUX
    
      Select Case Val(Info)
        
        Case c_Menu_ShowRemito
          pShowRemito
          
        Case c_Menu_ShowFactura
          pShowFactura
      End Select
    
    Case MSG_DOC_HISTORY
  
    Case MSG_EXPORT_GET_EMAIL
    
      cIABMClient_MessageEx = GetEmailFromCliente(m_cli_id)
  
    Case MSG_GRID_VIRTUAL_ROW

      cIABMClient_MessageEx = pProcessMultiRow(Info)
  
    Case MSG_EXPORT_GET_FILE_NAME_POSTFIX
      
      cIABMClient_MessageEx = pGetFileNamePostFix()
  
    Case MSG_PRINT_GET_TITLE
      
      cIABMClient_MessageEx = m_Nrodoc & " - " & m_cliente
  
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

    Case K_CLI_ID
      
    Case K_DESCUENTO1, K_DESCUENTO2
  
    Case K_TRANS_ID
  
    Case K_CHOF_ID
  
    ' HIDECOLS
    '
    Case K_HIDECOLS
    
      pShowHideCols False
  
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
  If Not DocCanSave(m_ObjAbm, cscPvFecha) Then
    cIABMClient_Save = False
    Exit Function
  End If
  
  If pGetItems().Grid.Rows.count = 0 Then
    MsgWarning LNGGetText(3903, vbNullString) 'El documento debe contener al menos un item
    cIABMClient_Save = False
    Exit Function
  End If
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  register.fieldId = cscPvTMPId
  register.Table = csTPedidoVentaTMP
  
  register.id = csNew
    
  If m_Copy Then
    register.fields.Add2 cscPvId, csNew, csLong
  Else
    register.fields.Add2 cscPvId, m_Id, csLong
  End If
  
  If register.id = csNew Then
    m_est_id = CSGeneralEx2.csEEstado.csEEst_Pendiente
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NUMERO
          register.fields.Add2 cscPvNumero, .Value, csLong
        Case K_NRODOC
          register.fields.Add2 cscPvNrodoc, .Value, csText
        Case K_DESCRIP
          register.fields.Add2 cscPvDescrip, .Value, csText
        Case K_FECHA
          register.fields.Add2 cscPvFecha, .Value, csDate
        Case K_FECHAENTREGA
          register.fields.Add2 cscPvFechaentrega, .Value, csDate
        Case K_CLI_ID
          register.fields.Add2 cscCliId, .HelpId, csId
        Case K_CCOS_ID
          register.fields.Add2 cscCcosId, .HelpId, csId
        Case K_SUC_ID
          register.fields.Add2 cscSucId, .HelpId, csId
        Case K_RAM_ID_STOCK
          register.fields.Add2 cscRamIdStock, .HelpValueProcess, csText
        Case K_DESCUENTO1
          register.fields.Add2 cscPvDescuento1, .Value, csCurrency
        Case K_DESCUENTO2
          register.fields.Add2 cscPvDescuento2, .Value, csCurrency
        Case K_DOC_ID
          register.fields.Add2 cscDocId, .HelpId, csId
        Case K_LP_ID
          register.fields.Add2 cscLpId, .HelpId, csId
        Case K_LD_ID
          register.fields.Add2 cscLdId, .HelpId, csId
        Case K_CPG_ID
          register.fields.Add2 cscCpgId, .HelpId, csId
        Case K_VEN_ID
          register.fields.Add2 cscVenId, .HelpId, csId
        Case K_LGJ_ID
          register.fields.Add2 cscLgjId, .HelpId, csId
        Case K_PRO_ID_ORIGEN
          register.fields.Add2 cscProIdOrigen, .HelpId, csId
        Case K_PRO_ID_DESTINO
          register.fields.Add2 cscProIdDestino, .HelpId, csId
        Case K_TRANS_ID
          register.fields.Add2 cscTransId, .HelpId, csId
        Case K_CHOF_ID
          register.fields.Add2 cscChofId, .HelpId, csId
        Case K_CAM_ID
          register.fields.Add2 cscCamId, .HelpId, csId
        Case K_CAM_ID_SEMI
          register.fields.Add2 cscCamIdSemi, .HelpId, csId
        Case K_DESTINATARIO
          register.fields.Add2 cscPvDestinatario, .Value, csText
        Case K_ORDENCOMPRA
          register.fields.Add2 cscPvOrdenCompra, .Value, csText
        Case K_CLIS_ID
          register.fields.Add2 cscClisId, .HelpId, csId
      End Select
    End With
  Next
  
  For Each IProperty In m_Footer.Properties
    With IProperty
      Select Case .Key
        Case K_TOTAL
          register.fields.Add2 cscPvTotal, .Value, csCurrency
        Case K_NETO
          register.fields.Add2 cscPvNeto, .Value, csCurrency
        Case K_IVARI
          register.fields.Add2 cscPvIvari, .Value, csCurrency
        Case K_IVARNI
          register.fields.Add2 cscPvIvarni, .Value, csCurrency
        Case K_SUBTOTAL
          register.fields.Add2 cscPvSubTotal, .Value, csCurrency
        Case K_IMPORTEDESC1
          register.fields.Add2 cscPvImporteDesc1, .Value, csCurrency
        Case K_IMPORTEDESC2
          register.fields.Add2 cscPvImporteDesc2, .Value, csCurrency
      End Select
    End With
  Next
  
  register.fields.Add2 cscEstId, m_est_id, csId
  
  register.fields.HaveLastUpdate = True
  register.fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If Not pSaveItems(register.id) Then Exit Function
  If Not register.CommitTrans() Then Exit Function
  
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DocPedidoVentaSave " & register.id
  
  If Not gDB.OpenRs(sqlstmt, rs, , , , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim id As Long
  If Not GetDocIDFromRecordset(rs, id) Then Exit Function
  
  m_Copy = False
  
  m_bWasChanged = True
  
  cIABMClient_Save = Load(id)
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  ' HIDECOLS
  '
  CSKernelClient2.SetRegistry csInterface, c_HideColsPv, Val(m_ObjAbm.Properties.Item(c_HideCols).Value)
  
  cIABMClient_Terminate = True
  
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  
  If m_Id = csNO_ID Then Exit Function
  If m_ObjClient Is Nothing Then Exit Function
  
  If m_bWasChanged Then
    m_ObjClient.RefreshItems
  End If
  
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(1557, vbNullString)  'Pedidos de Venta
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_FECHA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(1558, vbNullString)
                    'Debe indicar una fecha
            Exit Function
          End If
        Case K_FECHAENTREGA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(1564, vbNullString)
                    'Debe indicar una Fecha de entrega
            Exit Function
          End If
        Case K_CLI_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1563, vbNullString)
                    'Debe indicar un Cliente
            Exit Function
          End If
        Case K_DOC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1562, vbNullString)
                    'Debe indicar un Documento
            Exit Function
          End If
        Case K_CPG_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1561, vbNullString)
                    'Debe indicar una Condición de Pago
            Exit Function
          End If
        Case K_SUC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1560, vbNullString)
                    'Debe indicar una Sucursal
            Exit Function
          End If
        Case K_RAM_ID_STOCK
          If m_StockConfig.StockPedidoVta Then
            If ValEmpty(.HelpValueProcess, csText) Then
              MsgInfo LNGGetText(1559, vbNullString)
                      'Debe indicar un Depósito
              Exit Function
            End If
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
      cIABMClientGrid_IsEmptyRow = pIsEmptyRow(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

'-------------------------------------------------------------------------------------
' Documento
Private Property Get cIDocumento_DocId() As Long
  cIDocumento_DocId = m_doc_id
End Property

Private Property Get cIDocumento_DocTId() As Long
  cIDocumento_DocTId = m_Doct_id
End Property

Private Property Get cIDocumento_Id() As Long
  cIDocumento_Id = m_Id
End Property

Private Function cIDocumento_LoadForPrint(ByVal id As Long) As Boolean
  On Error GoTo ControlError

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select pv.doct_id, pv.doc_id, fv_nrodoc, cli_nombre, pv.cli_id " & _
            "from PedidoVenta pv inner join Cliente cli " & _
              "on pv.cli_id = cli.cli_id " & _
            "where pv.fv_id = " & id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_Id = id
  m_doc_id = gDB.ValField(rs.fields, cscDocId)
  m_Doct_id = gDB.ValField(rs.fields, cscDoctId)
  m_cli_id = gDB.ValField(rs.fields, cscCliId)
  m_cliente = gDB.ValField(rs.fields, cscCliNombre)
  m_Nrodoc = gDB.ValField(rs.fields, cscPvNrodoc)
  
  cIDocumento_LoadForPrint = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIDocumento_LoadForPrint", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

'-------------------------------------------------------------------------------------
' Implementacion de cIEditGeneric
Public Function Edit(ByVal id As Long, _
                     ByRef ObjClient As Object, _
                     Optional ByVal InModalWindow As Boolean _
                     ) As Boolean
  On Error GoTo ControlError
  
  If Not DocSecurityCanAccess(csPrePVEditPedidoVta, GetdocIdFromObjAbm(m_ObjAbm), csEDocTPreEdit) Then Exit Function
  
                            ' Id = csDocChanged esto significa que se cambio
                            '                   el documento estando en un
                            '                   comprobante ya guardado
                            '
  m_IsNew = id = csNO_ID Or id = csDocChanged
  
  m_bWasChanged = False

  ' Esto solo edita
  '
  If m_IsNew Then Exit Function

  If Not pInitMembers Then
    Exit Function
  End If

  If Not Load(id) Then Exit Function
  
  If m_ObjAbm.Properties.count = 0 Then
    If Not LoadCollection() Then Exit Function
  Else
    pRefreshProperties
  End If
  
  Dim AbmGen As cABMGeneric
  Set AbmGen = m_ObjAbm
  
  AbmGen.NewKeyPropFocus = vbNullString
  AbmGen.NewKeyPropFocus = cscCliId
  
  Set m_ObjClient = ObjClient
  
  m_Editing = True
  m_Copy = False
  
  Edit = True
  Exit Function
ControlError:
  MngError Err, "Edit", C_Module, vbNullString
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, _
                                                   ByVal lRow As Long, _
                                                   ByVal lCol As Long) As Boolean
  On Error GoTo ControlError
  
  Select Case Key
    Case K_ITEMS
      With m_Items.Properties(c_Items)
        pShowImporteAndIva .Grid.Rows(lRow)
        pShowTotales .Grid.Rows
        
        Dim colKey As Long
        colKey = .Grid.Columns(lCol).Key
        If colKey = KI_PR_ID Or colKey = KI_CANTIDAD Then
          pShowStock .Grid.Rows(lRow), .Grid.Rows
        End If
      End With
      cIABMClientGrid_ColumnAfterUpdate = True
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnAfterUpdate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pShowStock(ByRef Row As cIABMGridRow, _
                            ByRef Rows As cIABMGridRows)
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  Dim Value       As String
  Dim stock_real  As String
  Dim pedidos     As String
  Dim pr_id       As Long
  
  pr_id = pCell(Row, KI_PR_ID).id
  
  sqlstmt = "sp_DocPedidoVentaGetStockItem " _
                          & m_Id & "," _
                          & pr_id & "," _
                          & gDB.sqlString(pGetRamIdStock().HelpValueProcess)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then
    Value = LNGGetText(3209, vbNullString) 'Error
    stock_real = Value
    pedidos = Value
  Else
    If rs.EOF Then
      Value = LNGGetText(3209, vbNullString) 'Error
      stock_real = Value
      pedidos = Value
    Else
      Value = gDB.ValField(rs.fields, "stock")
      stock_real = gDB.ValField(rs.fields, "stock_real")
      pedidos = gDB.ValField(rs.fields, "pedidos")
    End If
  End If
  
  Dim row2 As cIABMGridRow
  For Each row2 In Rows
    If pr_id = pCell(row2, KI_PR_ID).id Then
      Value = Value - Val(pCell(row2, KI_CANTIDAD).Value)
    End If
  Next
  
  pCell(Row, KI_STOCK).Value = Value
  pCell(Row, KI_STOCK_REAL).Value = stock_real
  pCell(Row, KI_STOCK_PEDIDOS).Value = pedidos
End Function

Private Function pGetRamIdStock() As cIABMProperty
  Set pGetRamIdStock = m_ObjAbm.Properties.Item(cscRamIdStock)
End Function

Private Function pProcessMultiRow(ByVal Info As Variant) As Boolean
  
  Info.bAddRows = False
  
  Select Case Info.Key
    Case K_ITEMS
      With pGetItems()
        
        Dim Row As cIABMGridRow
        Set Row = .Grid.Rows(Info.lRow)

        If Row.Item(Info.lCol).Key = KI_PR_ID Then
          
          Dim oCell As cABMGridRowValue
          
          Set oCell = pCell(Row, KI_PR_ID)
          
          If LenB(oCell.HelpValueProcess) Then
            If InStr(1, oCell.HelpValueProcess, ",") Then
              AddMultiRowsVentas oCell.HelpValueProcess, Info, KI_CANTIDAD
              pProcessMultiRow = True
            End If
          End If
        End If
      End With
  End Select
  
End Function

'Private Sub pAddMultiRows(ByVal Ids As String, _
'                          ByRef Info As Variant)
'  Dim sqlstmt As String
'  Dim rs      As ADODB.Recordset
'
'  sqlstmt = "select pr_nombreventa, pr_id from Producto where pr_id in (" & Ids & ")"
'  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
'  If rs.EOF Then Exit Sub
'
'  Dim i As Long
'  Dim j As Long
'  Dim k As Long
'  Dim pr_id As Long
'  Dim vIds  As Variant
'  Dim vIds2 As Variant
'  Dim bFound As Boolean
'
'  vIds2 = Split(Ids, ",")
'
'  ReDim vIds(UBound(vIds2))
'
'  For i = 0 To UBound(vIds2)
'    bFound = False
'    For j = 0 To UBound(vIds)
'
'      If vIds2(i) = vIds(j) Then
'        bFound = True
'        Exit For
'      End If
'
'    Next
'    If Not bFound Then
'      vIds(k) = vIds2(i)
'      k = k + 1
'    End If
'  Next
'
'  ReDim Preserve vIds(k - 1)
'
'  ' Ahora respeto el orden de seleccion
'  '
'  For i = 0 To UBound(vIds)
'
'    rs.MoveFirst
'
'    Do While Not rs.EOF
'
'      pr_id = gDB.ValField(rs.fields, cscPrId)
'
'      If Val(vIds(i)) = pr_id Then
'        Info.NewId.Add pr_id
'        Info.NewValue.Add gDB.ValField(rs.fields, cscPrNombreVenta)
'        Exit Do
'      End If
'
'      rs.MoveNext
'    Loop
'
'  Next
'
'  ' No lo toquen, es mas 1 :( o explota todooo :P
'  ' ups al final no era jeje
'  '
'  Info.iAddRows = Info.NewId.count '+ 1
'
'  Info.bAddRows = Info.iAddRows
'
'End Sub

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_ColumnAfterEdit = pColumnAfterEdit(m_Items.Properties(c_Items), lRow, lCol, NewValue, NewValueID)
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
  
  With pCell(Row, KI_PRECIO_USR)
    If IsNumeric(.Value) Then
      Precio = CDbl(.Value)
    Else
      Precio = 0
    End If
  End With
  
  pGetPrecioFromRow = Precio
End Function

Private Function pColumnAfterEdit(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  Dim Row As cIABMGridRow
  
  Select Case IProperty.Grid.Columns(lCol).Key
    Case KI_PR_ID
      Set Row = IProperty.Grid.Rows(lRow)
      pSetDataProducto Row, NewValueID
      pSetPrecios Row, NewValueID
      pSetDescuentos Row, NewValueID, pGetPrecioFromRow(Row)
      pSetTasasImpositivas Row, NewValueID, NewValue
      
    Case KI_PRECIO_USR
      Set Row = IProperty.Grid.Rows(lRow)
      pSetDescuentos Row, pCell(Row, KI_PR_ID).id, NewValue
      
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
  Dim id As Long
  
  id = Val(pCell(Row, KI_PVI_ID).Value)
  
  If id <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & id & ","
  
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
      cIABMClientGrid_ValidateRow = pValidateRow(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pIsEmptyRow(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CANTIDAD
        If Not ValEmpty(Cell.Value, csCurrency) Then
          If Val(Cell.Value) <> 1 Then
            bRowIsEmpty = False
            Exit For
          End If
        End If
      Case KI_PRECIO
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_PR_ID
        If Not ValEmpty(Cell.id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRow = bRowIsEmpty
End Function

Private Function pValidateRow(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CANTIDAD
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(1365, vbNullString, strRow)
                  'Debe indicar una cantidad (1)
          Exit Function
        End If

' Por ahora no lo exijo
'
'      Case KI_PRECIO
'        If ValEmpty(Cell.value, csCurrency) Then
'          MsgInfo "Debe indicar un precio" & strRow
'          Exit Function
'        End If

      Case KI_PR_ID
        If ValEmpty(Cell.id, csId) Then
          MsgInfo LNGGetText(1565, vbNullString, strRow)
                  'Debe indicar un Producto de Venta  (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRow = True
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim Filter  As String
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
  AbmGen.UseHelpValueProcess = True
  
  Dim Buttons1 As Long
  Dim Buttons2 As Long

  Buttons1 = BUTTON_NEW + BUTTON_RELOAD + BUTTON_ANULAR + BUTTON_COPY + BUTTON_SEARCH
  Buttons1 = Buttons1 + BUTTON_DOC_FIRST + BUTTON_DOC_PREVIOUS + BUTTON_DOC_NEXT + BUTTON_DOC_LAST
  Buttons1 = Buttons1 + BUTTON_DELETE + BUTTON_PRINTOBJ + BUTTON_DOC_SIGNATURE + BUTTON_DOC_MODIFY
  Buttons1 = Buttons1 + BUTTON_DOC_APLIC + BUTTON_ATTACH
  
  Buttons2 = BUTTON_DOC_AUX + BUTTON_DOC_EDIT + BUTTON_DOC_ALERT + BUTTON_DOC_TIP + BUTTON_DOC_ACTION + BUTTON_DOC_MAIL
  Buttons2 = Buttons2
  
  AbmGen.NoButtons1 = Buttons1
  AbmGen.NoButtons2 = Buttons2
  
  AbmGen.InitButtons
  
  ' DATADD
  If m_UserCfg.ShowDataAddInVentas Then
    AbmGen.SetHeightToDocWithDescrip
  End If
  
  m_ObjAbm.Properties.Clear
  
  With m_ObjAbm.Tabs
      
    .Clear
  
    With .Add(Nothing)
      .name = C_strGeneral
    End With
    
    With .Add(Nothing)
      .Index = 1
      .name = LNGGetText(1566, vbNullString)    'Adicionales
    End With
    
    With .Add(Nothing)
      .Index = 2
      .name = LNGGetText(1050, vbNullString) 'Transporte
    End With
    
  End With
  
  With m_ObjAbm.Properties
    
    With .Add(Nothing, cscDocId)
      .PropertyType = cspHelp
      .Table = CSDocumento2.CSDocumento
      .name = LNGGetText(1567, vbNullString)    'Documento
      .Key = K_DOC_ID
      
      If m_doc_id <> csNO_ID Then
        .HelpId = m_doc_id
        .Value = m_Documento
      Else
        ' Preferencias del usuario
        '
        .HelpId = m_UserCfg.DocPvId
        .Value = m_UserCfg.DocPvNombre
        
        bValidateDocDefault = .HelpId <> csNO_ID
      End If
      
      .HelpFilter = pGetDocFilter
    End With
    
    With .Add(Nothing, csDocNumberID)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .name = LNGGetText(1065, vbNullString)    'Número
      .Key = K_NUMERO
      .Value = m_Numero
      .Enabled = False
    End With
    
    With .Add(Nothing, csDocEstateID)
      .PropertyType = cspText
      .name = LNGGetText(1568, vbNullString)    'Estado
      .Key = K_EST_ID
      .Value = m_Estado
      .Enabled = False
    End With
    
    With .Add(Nothing, cscPvFecha)
      .PropertyType = cspDate
      .name = LNGGetText(1569, vbNullString)    'Fecha
      .LeftLabel = -580
      .left = 700
      .Key = K_FECHA
      .Value = m_Fecha
    End With
    
    With .Add(Nothing, cscPvFechaentrega)
      .PropertyType = cspDate
      .name = LNGGetText(1570, vbNullString)    'Entrega
      .Key = K_FECHAENTREGA
      .Value = m_Fechaentrega
    End With
    
    With .Add(Nothing, cscCliId)
      .PropertyType = cspHelp
      .Table = csCliente
      .TopFromProperty = cscPvFecha
      .left = 2700
      .LeftLabel = -580
      .name = LNGGetText(1150, vbNullString)    'Cliente
      .Key = K_CLI_ID
      .HelpId = m_cli_id
      .Value = m_cliente
      AbmGen.NewKeyPropFocus = cscCliId
    
      ' CLI-WIDTH
      .Width = 5450
    End With
    
    With .Add(Nothing, cscPvNrodoc)
      .PropertyType = cspText
      .name = LNGGetText(1065, vbNullString)    'Número
      .Size = 50
      .Key = K_NRODOC
      .Value = m_Nrodoc
      .TextMask = m_TaMascara
      .TextAlign = vbRightJustify
    End With
    
    With .Add(Nothing, cscCpgId)
      .PropertyType = cspHelp
      .Table = csCondicionPago
      .name = LNGGetText(1571, vbNullString)    'Cond. Pago
      .TopFromProperty = cscPvFecha
      .TopToPrevious = 440
      .left = 5900
      .LeftLabel = -900
      .Key = K_CPG_ID
      .HelpId = m_cpg_id
      .Value = m_CondicionPago
    End With
    
    With .Add(Nothing, cscPvDescuento1)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .LeftLabel = -600
      .name = LNGGetText(1573, vbNullString)    'Desc. 1
      .Key = K_DESCUENTO1
      .Value = m_Descuento1
      .Width = 1000
    End With
    
    With .Add(Nothing, cscPvDescuento2)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .TopFromProperty = cscPvDescuento1
      .left = 7150
      .LeftLabel = -150
      .name = "2"
      .Key = K_DESCUENTO2
      .Value = m_Descuento2
      .Width = 1000
    End With
    
    Set c = .Add(Nothing, cscRamIdStock)
    With c
      .PropertyType = cspHelp
      .LeftFromProperty = cscPvDescuento1
      .LeftLabel = -800
      .Table = csDepositoLogico
      .name = LNGGetText(1574, vbNullString)    'Depósito
      .Key = K_RAM_ID_STOCK
      
      If Val(m_ram_id_stock) <> csNO_ID Then
        
        .HelpId = Val(m_ram_id_stock)
        .HelpValueProcess = m_ram_id_stock
        .Value = m_RamaStock
          
      Else
        ' Preferencias del usuario
        '
        .HelpValueProcess = m_UserCfg.DeplRamId
        .HelpId = m_UserCfg.DeplId
        .Value = m_UserCfg.DeplNombre
      End If
      
      Dim oProp As cABMProperty
      Set oProp = c
      oProp.HelpType = csTree
      Set oProp = Nothing
    End With
        
    With .Add(Nothing, cscLpId)
      .PropertyType = cspHelp
      .Table = csListaPrecio
      .name = LNGGetText(1397, vbNullString)    'Lista de Precios
      .HelpFilter = GetListaPrecioGetXCliente(m_doc_id, m_cli_id)
      .TopFromProperty = cscPvFecha
      .left = 9400
      .Key = K_LP_ID
      .HelpId = m_Lp_id
      .Value = m_ListaPrecio
    End With
    
    With .Add(Nothing, cscVenId)
      .PropertyType = cspHelp
      .Table = csVendedores
      .LeftLabel = -800
      .name = LNGGetText(1510, vbNullString)    'Vendedor
      .Key = K_VEN_ID
      .HelpId = m_ven_id
      .Value = m_vendedor
    End With
        
    With .Add(Nothing, cscCcosId)
      .PropertyType = cspHelp
      .Table = csCentroCosto
      .name = LNGGetText(1057, vbNullString)    'Centro de Costo
      .Key = K_CCOS_ID
      .HelpId = m_ccos_id
      .Value = m_CentroCosto
    End With
    
    With .Add(Nothing, cscSucId)
      .PropertyType = cspHelp
      .Table = csSucursal
      .name = LNGGetText(1281, vbNullString)    'Sucursal
      .Key = K_SUC_ID
      .HelpId = m_suc_id
      .Value = m_Sucursal
    End With
    
    With .Add(Nothing, cscPvDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .name = LNGGetText(1618, vbNullString)
      .LeftLabel = -600
      .Size = 5000
      .Key = K_DESCRIP
      .Value = m_Descrip
      .LeftFromProperty = cscPvFecha
      .TopFromProperty = cscPvNrodoc
      .Width = 4280
      .Height = 800
      .TopToPrevious = 440
    End With
  
    With .Add(Nothing, cscLgjId)
      .PropertyType = cspHelp
      .Table = csLegajo
      .left = 1500
      .name = LNGGetText(1575, vbNullString)    'Legajo
      .Key = K_LGJ_ID
      .HelpId = m_lgj_id
      .Value = m_Legajo
      .TabIndex = 1
    End With
      
    With .Add(Nothing, cscClisId)
      .PropertyType = cspHelp
      .Table = csSucursalCliente
      .name = LNGGetText(1576, vbNullString)    'Sucursal del Cliente
      .Key = K_CLIS_ID
      .Value = m_ClienteSucursal
      .HelpId = m_clis_id
      .TabIndex = 1
    End With
        
    With .Add(Nothing, cscProIdOrigen)
      .PropertyType = cspHelp
      .Table = csProvincia
      .name = LNGGetText(1577, vbNullString)     'Pcia. Origen
      .Key = K_PRO_ID_ORIGEN
      .HelpId = m_pro_id_origen
      .Value = m_ProOrigen
      .TabIndex = 1
    End With
      
    With .Add(Nothing, cscProIdDestino)
      .PropertyType = cspHelp
      .Table = csProvincia
      .name = LNGGetText(1578, vbNullString)    'Pcia. Destino
      .Key = K_PRO_ID_DESTINO
      .HelpId = m_pro_id_destino
      .Value = m_ProDestino
      .TabIndex = 1
    End With
      
    With .Add(Nothing, cscPvOrdenCompra)
      .PropertyType = cspText
      .name = LNGGetText(1924, vbNullString)    'Orden de Compra
      .Key = K_ORDENCOMPRA
      .Value = m_OrdenCompra
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscLdId)
      .PropertyType = cspHelp
      .Table = csListaDescuento
      .name = LNGGetText(1398, vbNullString)    'Lista de Descuentos
      .HelpFilter = GetListaDescGetXCliente(m_doc_id, m_cli_id)
      .Key = K_LD_ID
      .HelpId = m_Ld_id
      .Value = m_ListaDescuento
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscTransId)
      .PropertyType = cspHelp
      .Table = csTransporte
      .name = LNGGetText(1050, vbNullString) 'Transporte
      .Key = K_TRANS_ID
      .Value = m_Transporte
      .HelpId = m_trans_id
      .TabIndex = 2
    End With
    
    With .Add(Nothing, cscChofId)
      .PropertyType = cspHelp
      .Table = csChofer
      .name = LNGGetText(1051, vbNullString) 'Chofer
      .Key = K_CHOF_ID
      .Value = m_Chofer
      .HelpId = m_chof_id
      .HelpFilter = GetHelpTransporte(m_trans_id)
      .TabIndex = 2
    End With
    
    With .Add(Nothing, cscCamId)
      .PropertyType = cspHelp
      .Table = csCamion
      .name = LNGGetText(3489, vbNullString) 'Camion
      .Key = K_CAM_ID
      .Value = m_Camion
      .HelpId = m_cam_id
      .HelpFilter = GetHelpTransporte(m_trans_id)
      .TopFromProperty = cscTransId
      .left = 6000
      .TabIndex = 2
    End With
    
    With .Add(Nothing, cscCamIdSemi)
      .PropertyType = cspHelp
      .Table = csCamionSemi
      .name = LNGGetText(3493, vbNullString) 'Semi
      .Key = K_CAM_ID_SEMI
      .Value = m_Semi
      .HelpId = m_cam_id_semi
      .HelpFilter = GetHelpTransporte(m_trans_id)
      .TabIndex = 2
    End With
  
    With .Add(Nothing, cscPvDestinatario)
      .PropertyType = cspText
      .SubType = cspMemo
      .name = LNGGetText(3494, vbNullString) 'Destinatario
      .Key = K_DESTINATARIO
      .Value = m_Destinatario
      .Width = 7000
      .LeftFromProperty = cscTransId
      .TopFromProperty = cscChofId
      .TopToPrevious = 440
      .Height = 880
      .TabIndex = 2
    End With
  
    ' DATADD
    If m_UserCfg.ShowDataAddInVentas Then
    
      With .Add(Nothing, c_ClienteDataAdd)
        .PropertyType = cspText
        .SubType = cspMemo
        .Width = 10970
        .TopFromProperty = cscPvDescrip
        .TopToPrevious = 860
        .LeftFromProperty = cscPvDescrip
        .Height = 600
      End With
    
    End If
    
    ' HIDECOLS
    '
    With .Add(Nothing)
      .PropertyType = cspLabel
      .BackColor = vbButtonShadow
      .Width = 2540
      .TopNotChange = True
      .LeftNotChange = True

      ' DATADD
      ' Aca van las preferencias del usuario
      '
      If m_UserCfg.ShowDataAddInVentas Then
        .Top = 4000
      Else
        .Top = 3460
      End If

      .left = 9210
      .Height = 330
    End With
    
    With .Add(Nothing)
      .PropertyType = cspLabel
      .BackColor = vbWindowBackground
      .Width = 2500
      .TopNotChange = True
      .LeftNotChange = True

      ' DATADD
      ' Aca van las preferencias del usuario
      '
      If m_UserCfg.ShowDataAddInVentas Then
        .Top = 4020
      Else
        .Top = 3480
      End If

      .left = 9220
      .Height = 300
    End With
  
    Dim iProp As cIABMProperty
    Set iProp = .Add(Nothing, c_HideCols)
    Set oProp = iProp
    With iProp
      .PropertyType = cspCheck
      .name = LNGGetText(3901, vbNullString)  'Ocultar Columnas
      .Key = K_HIDECOLS
      .Value = CInt(CSKernelClient2.GetRegistry(csInterface, c_HideColsPv, 1))
      .TopNotChange = True
      .LeftNotChange = True

      ' DATADD
      ' Aca van las preferencias del usuario
      '
      If m_UserCfg.ShowDataAddInVentas Then
        .Top = 4040
      Else
        .Top = 3500
      End If

      .left = 11120
      .LeftLabel = -1500
    End With
    oProp.IsEditProperty = False
    '
    ' HIDECOLS - fin
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
      
  With m_Items.Tabs
    .Clear
  
    With .Add(Nothing)
      .name = LNGGetText(1371, vbNullString)    'Items
    End With
  
  End With
  
  Set AbmGen = m_Items
  AbmGen.ResetLayoutMembers
  
  ' DATADD
  If m_UserCfg.ShowDataAddInVentas Then
    AbmGen.SetHeightToDocWithDescrip
  End If
  
  With m_Items.Properties
  
    .Clear
  
    Set c = .Add(Nothing, c_Items)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItems(c) Then Exit Function
      .name = c_Items
      .Key = K_ITEMS
      .TabIndex = 0
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
  End With
  
  m_ItemsDeleted = vbNullString
  
  If Not m_Items.Show(Me) Then Exit Function
  
  Set AbmGen = m_Footer
  AbmGen.ResetLayoutMembers
  
  With m_Footer.Properties
    
    .Clear
    
    With .Add(Nothing, cscPvSubTotal)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .name = LNGGetText(1579, vbNullString)    'Sub Total
      .Key = K_SUBTOTAL
      .Value = m_SubTotal
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscPvImporteDesc1)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .name = LNGGetText(1573, vbNullString)    'Desc. 1
      .Key = K_IMPORTEDESC1
      .Value = m_ImporteDesc1
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscPvImporteDesc2)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .name = LNGGetText(1580, vbNullString)    'Desc. 2
      .Key = K_IMPORTEDESC2
      .Value = m_ImporteDesc2
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscPvNeto)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .name = LNGGetText(1581, vbNullString)    'Neto
      .Key = K_NETO
      .Value = m_Neto
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscPvIvari)
      .PropertyType = cspNumeric
      .name = LNGGetText(1582, vbNullString)    'IVA RI
      .SubType = cspMoney
      .Key = K_IVARI
      .Value = m_Ivari
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscPvIvarni)
      .PropertyType = cspNumeric
      .name = LNGGetText(1583, vbNullString)    'IVA RNI
      .SubType = cspMoney
      .Key = K_IVARNI
      .Value = m_Ivarni
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscPvTotal)
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .name = LNGGetText(1584, vbNullString)    'Total
      .SubType = cspMoney
      .Key = K_TOTAL
      .Value = m_Total
      .Enabled = False
    End With
  End With
  
  pSetEnabled
  
  If Not m_Footer.Show(Me) Then Exit Function
  
  ' Preferencias del Usuario
  '
  If bValidateDocDefault Then
    cIABMClient_PropertyChange K_DOC_ID
  End If
  
  ' DATADD
  ShowDataAddCliente m_UserCfg.ShowDataAddInVentas, _
                     m_ObjAbm
  
  LoadCollection = True
End Function

Private Function pGetDocFilter() As String
  pGetDocFilter = "'doct_id = " & csEDT_PedidoVenta & _
                  " or doct_id = " & csEDT_DevolucionPedidoVta & "'"
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim oCol    As cABMGridColumn
  Dim iCol    As cIABMGridColumn
  
  ' HIDECOLS
  '
  Dim bColVisible As Boolean
  bColVisible = Val(m_ObjAbm.Properties.Item(c_HideCols).Value) = 0
  
  sqlstmt = "sp_DocPedidoVentaGetItems " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  With Propiedad.Grid
  
    With .Columns
    
      .Clear
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PVI_ID
      End With
      
      Set iCol = .Add(Nothing)
      Set oCol = iCol
      With iCol
        .name = LNGGetText(1367, vbNullString)  'Articulo
        .PropertyType = cspHelp
        .Table = csProductoVenta
        .Width = 1800
        .Key = KI_PR_ID
      End With
      If m_UserCfg.MultiSelect Then
        oCol.HelpType = csMultiSelect
      End If
      Set iCol = Nothing
      Set oCol = Nothing
      
      With .Add(Nothing)
        .name = LNGGetText(1618, vbNullString)
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 1200
        .Key = KI_DESCRIP
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1374, vbNullString)   'Cantidad
        .Format = m_GeneralConfig.FormatDecCantidad
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KI_CANTIDAD
      
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Value = 1
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(3568, vbNullString)   'Disponible
        .Format = m_GeneralConfig.FormatDecCantidad
        .PropertyType = cspText
        .Enabled = False
        .Width = 1200
        .Key = KI_STOCK
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(3567, vbNullString)   'Sotck Real
        .Format = m_GeneralConfig.FormatDecCantidad
        .PropertyType = cspText
        .Enabled = False
        .Width = 1200
        .Key = KI_STOCK_REAL
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1694, vbNullString)   'Pedidos
        .Format = m_GeneralConfig.FormatDecCantidad
        .PropertyType = cspText
        .Enabled = False
        .Width = 1200
        .Key = KI_STOCK_PEDIDOS
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1585, vbNullString)   'Descuento
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .Key = KI_DESCUENTO
        .Enabled = False
        .Visible = bColVisible ' HIDECOLS
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1165, vbNullString)   'Unidad
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_UNIDAD
        .Enabled = False
        .Visible = bColVisible ' HIDECOLS
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1587, vbNullString)   'Precio (LP)
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .Key = KI_PRECIO_LP
        .Enabled = False
        .Visible = bColVisible ' HIDECOLS
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1586, vbNullString)   'Precio
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1200
        .Format = m_GeneralConfig.FormatDecImporte
        .Key = KI_PRECIO_USR
        .Enabled = SecurityCanAccessSilent(csPrePVEditPrice)
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1588, vbNullString)   'Precio c/desc.
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1200
        .Format = m_GeneralConfig.FormatDecImporte
        .Key = KI_PRECIO
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1581, vbNullString)   'Neto
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .Key = KI_NETO
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1582, vbNullString)   'IVA RI
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .Key = KI_IVARI
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1583, vbNullString)   'IVA RNI
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .Key = KI_IVARNI
        .Enabled = False
        .Visible = bColVisible ' HIDECOLS
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1228, vbNullString)   'Importe
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .Key = KI_IMPORTE
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_IVARIPercent
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_IVARNIPercent
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1057, vbNullString)   'Centro de Costo
        .PropertyType = cspHelp
        .Table = csCentroCosto
        .Width = 1800
        .Key = KI_CCOS_ID
        .Visible = bColVisible ' HIDECOLS
      End With
      
    End With
  
    With .Rows
      
      .Clear
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscPviId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPviId)
            .Key = KI_PVI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrNombreVenta)
            .id = gDB.ValField(rs.fields, cscPrId)
            .Key = KI_PR_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPviDescrip)
            .Key = KI_DESCRIP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPviCantidad)
            .Key = KI_CANTIDAD
          End With
          
          With .Add(Nothing)
            .Value = vbNullString
            .Key = KI_STOCK
          End With
          
          With .Add(Nothing)
            .Value = vbNullString
            .Key = KI_STOCK_REAL
          End With
          
          With .Add(Nothing)
            .Value = vbNullString
            .Key = KI_STOCK_PEDIDOS
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPviDescuento)
            .Key = KI_DESCUENTO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscUnNombre)
            .Key = KI_UNIDAD
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPviPrecioLista)
            .Key = KI_PRECIO_LP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPviPrecioUsr)
            .Key = KI_PRECIO_USR
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPviPrecio)
            .Key = KI_PRECIO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPviNeto)
            .Key = KI_NETO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPviIvari)
            .Key = KI_IVARI
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPviIvarni)
            .Key = KI_IVARNI
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPviImporte)
            .Key = KI_IMPORTE
          End With
          
          With .Add(Nothing)
            If m_bIva Then
              .Value = gDB.ValField(rs.fields, "iva_ri_porcentaje")
            Else
              .Value = 0
            End If
            .Key = KI_IVARIPercent
          End With
          
          With .Add(Nothing)
            If m_bIvaRni Then
              .Value = gDB.ValField(rs.fields, "iva_rni_porcentaje")
            Else
              .Value = 0
            End If
            .Key = KI_IVARNIPercent
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCcosNombre)
            .id = gDB.ValField(rs.fields, cscCcosId)
            .Key = KI_CCOS_ID
          End With
          
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadItems = True
End Function

Private Function Load(ByVal id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "sp_DocPedidoVentaGet " & empId & "," & id & "," & gDB.UserId
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscPvId)
    m_Numero = gDB.ValField(rs.fields, cscPvNumero)
    m_Nrodoc = gDB.ValField(rs.fields, cscPvNrodoc)
    m_Descrip = gDB.ValField(rs.fields, cscPvDescrip)
    m_Fecha = gDB.ValField(rs.fields, cscPvFecha)
    m_Fechaentrega = gDB.ValField(rs.fields, cscPvFechaentrega)
    m_Neto = gDB.ValField(rs.fields, cscPvNeto)
    m_Ivari = gDB.ValField(rs.fields, cscPvIvari)
    m_Ivarni = gDB.ValField(rs.fields, cscPvIvarni)
    m_Total = gDB.ValField(rs.fields, cscPvTotal)
    m_SubTotal = gDB.ValField(rs.fields, cscPvSubTotal)
    m_Descuento1 = gDB.ValField(rs.fields, cscPvDescuento1)
    m_Descuento2 = gDB.ValField(rs.fields, cscPvDescuento2)
    m_ImporteDesc1 = gDB.ValField(rs.fields, cscPvImporteDesc1)
    m_ImporteDesc2 = gDB.ValField(rs.fields, cscPvImporteDesc2)
    m_cli_id = gDB.ValField(rs.fields, cscCliId)
    m_cliente = gDB.ValField(rs.fields, cscCliNombre)
    m_ccos_id = gDB.ValField(rs.fields, cscCcosId)
    m_CentroCosto = gDB.ValField(rs.fields, cscCcosNombre)
    m_suc_id = gDB.ValField(rs.fields, cscSucId)
    m_Sucursal = gDB.ValField(rs.fields, cscSucNombre)
    m_doc_id = gDB.ValField(rs.fields, cscDocId)
    m_Documento = gDB.ValField(rs.fields, cscDocNombre)
    m_Doct_id = gDB.ValField(rs.fields, cscDoctId)
    m_Lp_id = gDB.ValField(rs.fields, cscLpId)
    m_ListaPrecio = gDB.ValField(rs.fields, cscLpNombre)
    m_cpg_id = gDB.ValField(rs.fields, cscCpgId)
    m_CondicionPago = gDB.ValField(rs.fields, cscCpgNombre)
    m_Ld_id = gDB.ValField(rs.fields, cscLdId)
    m_ListaDescuento = gDB.ValField(rs.fields, cscLdNombre)
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)
    m_est_id = gDB.ValField(rs.fields, cscEstId)
    m_Estado = gDB.ValField(rs.fields, cscEstNombre)
    m_Firmado = gDB.ValField(rs.fields, cscPvFirmado)
    m_ram_id_stock = gDB.ValField(rs.fields, cscRamIdStock)
    m_RamaStock = gDB.ValField(rs.fields, cscRamaStock)
    m_DocEditable = gDB.ValField(rs.fields, cscDocEditable)
    m_DocEditMsg = gDB.ValField(rs.fields, cscDoceditMsg)
    
    m_ven_id = gDB.ValField(rs.fields, cscVenId)
    m_vendedor = gDB.ValField(rs.fields, cscVenNombre)
    m_lgj_id = gDB.ValField(rs.fields, cscLgjId)
    m_Legajo = gDB.ValField(rs.fields, cscLgjCodigo)
    m_pro_id_origen = gDB.ValField(rs.fields, cscProIdOrigen)
    m_ProOrigen = gDB.ValField(rs.fields, "ProOrigen")
    m_pro_id_destino = gDB.ValField(rs.fields, cscProIdDestino)
    m_ProDestino = gDB.ValField(rs.fields, "ProDestino")
    m_trans_id = gDB.ValField(rs.fields, cscTransId)
    m_Transporte = gDB.ValField(rs.fields, cscTransNombre)
    
    m_chof_id = gDB.ValField(rs.fields, cscChofId)
    m_Chofer = gDB.ValField(rs.fields, cscChofNombre)

    m_cam_id = gDB.ValField(rs.fields, cscCamId)
    m_Camion = gDB.ValField(rs.fields, cscCamPatente)

    m_cam_id_semi = gDB.ValField(rs.fields, cscCamIdSemi)
    m_Semi = gDB.ValField(rs.fields, cscCamPatentesemi)
    
    m_Destinatario = gDB.ValField(rs.fields, cscPvDestinatario)
    m_OrdenCompra = gDB.ValField(rs.fields, cscPvOrdenCompra)
    
    m_clis_id = gDB.ValField(rs.fields, cscClisId)
    m_ClienteSucursal = gDB.ValField(rs.fields, cscClisNombre)
    
    m_TaPropuesto = gDB.ValField(rs.fields, cscTa_Propuesto)
    m_TaMascara = gDB.ValField(rs.fields, cscTa_Mascara)

    m_bIva = gDB.ValField(rs.fields, cscbIvaRi)
    m_bIvaRni = gDB.ValField(rs.fields, cscbIvaRni)
    
    m_LastDoc = m_doc_id
    m_LastCli = m_cli_id
    m_LastTrans = m_trans_id
    m_LastChof = m_chof_id
    m_LastDocName = m_Documento
    m_LastCliName = m_cliente

    Load = True
  
  Else
  
    Load = False
  
  End If

End Function

Private Function pSaveItems(ByVal id As Long) As Boolean
  Dim register As cRegister
  Dim IProperty As cIABMProperty
  Dim iOrden As Long
  
        
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  For Each Row In m_Items.Properties(c_Items).Grid.Rows
  
    Set register = New cRegister
    register.fieldId = cscPviTMPId
    register.Table = csTPedidoVentaItemTMP
    register.id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KI_PVI_ID
          If m_Copy Then
            register.fields.Add2 cscPviId, csNew, csInteger
          Else
            register.fields.Add2 cscPviId, Val(Cell.Value), csInteger
          End If
        Case KI_CANTIDAD
          register.fields.Add2 cscPviCantidad, Cell.Value, csDouble
        Case KI_DESCRIP
          register.fields.Add2 cscPviDescrip, Cell.Value, csText
        Case KI_PRECIO
          register.fields.Add2 cscPviPrecio, Cell.Value, csCurrency
        Case KI_PRECIO_LP
          register.fields.Add2 cscPviPrecioLista, Cell.Value, csCurrency
        Case KI_PRECIO_USR
          register.fields.Add2 cscPviPrecioUsr, Cell.Value, csCurrency
        Case KI_DESCUENTO
          register.fields.Add2 cscPviDescuento, Cell.Value, csText
        Case KI_IMPORTE
          register.fields.Add2 cscPviImporte, Cell.Value, csCurrency
        Case KI_NETO
          register.fields.Add2 cscPviNeto, Cell.Value, csCurrency
        Case KI_IVARI
          If m_bIva Then
            register.fields.Add2 cscPviIvari, Cell.Value, csCurrency
          End If
        Case KI_IVARNI
          If m_bIvaRni Then
            register.fields.Add2 cscPviIvarni, Cell.Value, csCurrency
          End If
        Case KI_IVARIPercent
          If m_bIva Then
            register.fields.Add2 cscPviIvariPorc, Cell.Value, csDouble
          End If
        Case KI_IVARNIPercent
          If m_bIvaRni Then
            register.fields.Add2 cscPviIvarniPorc, Cell.Value, csDouble
          End If
        Case KI_PR_ID
          register.fields.Add2 cscPrId, Cell.id, csId
        Case KI_CCOS_ID
          register.fields.Add2 cscCcosId, Cell.id, csId
      End Select
    Next
    
    iOrden = iOrden + 1
    register.fields.Add2 cscPviOrden, iOrden, csInteger
    register.fields.Add2 cscPvTMPId, id, csId
    
    register.fields.HaveLastUpdate = False
    register.fields.HaveWhoModify = False
                                                          
    If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
  Next
  
  Dim sqlstmt As String
  
  If m_ItemsDeleted <> vbNullString And m_Id <> csNO_ID And Not m_Copy Then
  
    Dim vDeletes As Variant
    Dim i As Long
    
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    vDeletes = Split(m_ItemsDeleted, ",")
    
    For i = 0 To UBound(vDeletes)
    
      Set register = New cRegister
      register.fieldId = cscPvibTMPId
      register.Table = csTPedidoVentaItemBorradoTMP
      register.id = csNew
      
      register.fields.Add2 cscPviId, Val(vDeletes(i)), csInteger
      register.fields.Add2 cscPvId, m_Id, csId
      register.fields.Add2 cscPvTMPId, id, csId
      
      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False
                                                          
      If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveItems = True
End Function

' Reglas del Objeto de Negocios
Private Sub pShowImporteAndIva(ByRef Row As CSInterfacesABM.cIABMGridRow)
  Dim Importe As Double
  Dim Neto    As Double
  Dim IvaRi   As Double
  Dim IvaRni  As Double
  
  Neto = Val(pCell(Row, KI_CANTIDAD).Value) * Val(pCell(Row, KI_PRECIO).Value)
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
  
Private Sub pShowTotales(ByRef Rows As CSInterfacesABM.cIABMGridRows)
  Dim Neto      As Double
  Dim IvaRi     As Double
  Dim IvaRni    As Double
  Dim Desc1     As Double
  Dim Desc2     As Double
  
  Dim Row       As CSInterfacesABM.cIABMGridRow
  
  For Each Row In Rows
    Neto = Neto + Val(pCell(Row, KI_NETO).Value)
    IvaRi = IvaRi + Val(pCell(Row, KI_IVARI).Value)
    IvaRni = IvaRni + Val(pCell(Row, KI_IVARNI).Value)
  Next
  
  With m_Footer.Properties
    .Item(cscPvSubTotal).Value = Neto
  
    Desc1 = m_ObjAbm.Properties(cscPvDescuento1).Value
    Desc2 = m_ObjAbm.Properties(cscPvDescuento2).Value
  
    IvaRi = IvaRi - (IvaRi * Desc1 / 100)
    IvaRni = IvaRni - (IvaRni * Desc1 / 100)
    
    IvaRi = IvaRi - (IvaRi * Desc2 / 100)
    IvaRni = IvaRni - (IvaRni * Desc2 / 100)
    
    Desc1 = Neto * Desc1 / 100
    .Item(cscPvImporteDesc1).Value = Desc1
  
    Neto = Neto - Desc1
  
    Desc2 = Neto * Desc2 / 100
    .Item(cscPvImporteDesc2).Value = Desc2
  
    Neto = Neto - Desc2
  
    .Item(cscPvNeto).Value = Neto
    .Item(cscPvIvari).Value = IvaRi
    .Item(cscPvIvarni).Value = IvaRni
    .Item(cscPvTotal).Value = Neto + IvaRni + IvaRi
  End With
  
  m_Footer.RefreshControls
End Sub

Private Sub pSetTasasImpositivas(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal pr_id As Long, ByVal pr_nombre As String)
  Dim ti_ri    As Long
  Dim ti_rni   As Long
  
  If pr_id = 0 Then Exit Sub
  
  If Not GetTasaFromProducto(pr_id, ti_ri, ti_rni, False) Then Exit Sub
  
  If ti_ri = 0 Then
    MsgWarning LNGGetText(1597, vbNullString, pr_nombre)
    'MsgWarning "El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de ventas para el iva responsable inscripto"
    Exit Sub
  End If
  
  If ti_rni = 0 Then
    MsgWarning LNGGetText(1598, vbNullString, pr_nombre)
    'MsgWarning "El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de ventas para el iva responsable no inscripto"
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

Private Sub pSetDataProducto(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal pr_id As Long)
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select un_nombre, ccos_id_venta, ccos_nombre" & _
            " from producto" & _
            " left join unidad on un_id_venta = un_id" & _
            " left join centrocosto on ccos_id_venta = ccos_id" & _
            " where pr_id = " & pr_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
    pCell(Row, KI_UNIDAD).Value = gDB.ValField(rs.fields, cscUnNombre)
  
    With pCell(Row, KI_CCOS_ID)
      .Value = gDB.ValField(rs.fields, cscCcosNombre)
      .id = gDB.ValField(rs.fields, cscCcosIdVenta)
    End With
  End If
End Sub

Private Sub pSetPrecios(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal pr_id As Long)
  Dim LP        As cListaPrecio
  Dim lp_id     As Long
  Dim Precio    As Double
  
  lp_id = m_ObjAbm.Properties(cscLpId).HelpId
    
  If lp_id <> 0 Then
    Set LP = New cListaPrecio
    Precio = LP.GetPrecio(lp_id, pr_id)
  End If
  
  pCell(Row, KI_PRECIO_LP).Value = Precio
  pCell(Row, KI_PRECIO_USR).Value = Precio
End Sub

Private Sub pSetDescuentos(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal pr_id As Long, ByVal Precio As Double)
  Dim LD        As cListaDescuento
  Dim ld_id     As Long
  Dim Descuento As String
  
  ld_id = m_ObjAbm.Properties(cscLdId).HelpId
  
  If ld_id <> 0 Then
    Set LD = New cListaDescuento
    Precio = LD.GetPrecio(ld_id, pr_id, Precio)
    Descuento = LD.GetDescuentoStr(ld_id, pr_id)
  End If
  
  pCell(Row, KI_PRECIO).Value = Precio
  pCell(Row, KI_DESCUENTO).Value = Descuento
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
                                                                              
    If Prop.Key = K_ITEMS Then
      Prop.Enabled = bState
    Else
      If Prop.Key <> K_HIDECOLS Then
        Prop.Enabled = False
      End If
'                                                                                ' HIDECOLS
'      If Prop.Key <> K_DOC_ID And Prop.Key <> K_NUMERO And Prop.Key <> K_EST_ID And Prop.Key <> K_HIDECOLS Then
'
'        If bState Then
'          If Prop.Key <> K_NRODOC Then
'            Prop.Enabled = bState
'          Else
'            Prop.Enabled = m_TaPropuesto
'          End If
'        Else
'          Prop.Enabled = False
'        End If
'      End If
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
  
  Dim trans_id      As Long
  Dim pro_id        As Long
  Dim ven_id        As Long
  
  Dim trans_nombre      As String
  Dim pro_nombre        As String
  Dim ven_nombre        As String
  
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

  If Not GetClienteDataEx2(m_LastCli, _
                          lp_id, _
                          ld_id, _
                          cpg_id, _
                          trans_id, pro_id, ven_id, _
                          trans_nombre, pro_nombre, ven_nombre, _
                          m_LastDoc) Then Exit Sub
  
  ' Condicion de pago
  If cpg_id <> csNO_ID Then
    
    If Not gDB.GetData(csTCondicionPago, cscCpgId, cpg_id, cscCpgNombre, cpg_nombre) Then Exit Sub
    
    Set iProp = m_ObjAbm.Properties.Item(cscCpgId)
    iProp.Value = cpg_nombre
    iProp.HelpId = cpg_id
    m_ObjAbm.ShowValue iProp
  End If
  
  ' Lista de precios
  Set iProp = m_ObjAbm.Properties.Item(cscLpId)
  iProp.HelpFilter = GetListaPrecioGetXCliente(m_LastDoc, m_LastCli)
  
  If lp_id <> csNO_ID Then
    Set LP = New cListaPrecio
    iProp.Value = LP.GetData(lp_id, cscLpNombre, csText)
    iProp.HelpId = lp_id
  End If
  
  m_ObjAbm.ShowValue iProp
  
  ' Lista de descuentos
  Set iProp = m_ObjAbm.Properties.Item(cscLdId)
  iProp.HelpFilter = GetListaDescGetXCliente(m_LastDoc, m_LastCli)
  
  If ld_id <> csNO_ID Then
    Set LD = New cListaDescuento
    iProp.Value = LD.GetData(ld_id, cscLdNombre, csText)
    iProp.HelpId = ld_id
  End If
  
'////////////////////////////////////////////////////////////
  If ven_id <> csNO_ID Then
    Set iProp = m_ObjAbm.Properties.Item(cscVenId)
    With iProp
      .Value = ven_nombre
      .HelpId = ven_id
    End With
    m_ObjAbm.ShowValue iProp
  End If
  If trans_id <> csNO_ID Then
    Set iProp = m_ObjAbm.Properties.Item(cscTransId)
    With iProp
      .Value = trans_nombre
      .HelpId = trans_id
    End With
    m_ObjAbm.ShowValue iProp
    pSetDatosTransporte
  End If
  If pro_id <> csNO_ID Then
    Set iProp = m_ObjAbm.Properties.Item(cscProIdDestino)
    With iProp
      .Value = pro_nombre
      .HelpId = pro_id
    End With
    m_ObjAbm.ShowValue iProp
  End If
'////////////////////////////////////////////////////////////
  
  ' Talonario y Categoria fiscal
  pGetIvaFromCliente m_LastCli
  
  m_ObjAbm.ShowValue iProp
End Sub

Private Sub pGetIvaFromCliente(ByVal cli_id As Long)
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  Dim bIvaChanged As Boolean
  Dim bLastIva    As Boolean
  
  sqlstmt = "sp_clienteGetIva " & cli_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  bLastIva = m_bIva
  m_bIva = gDB.ValField(rs.fields, "bIva")
  If bLastIva <> m_bIva Then bIvaChanged = True
  
  bLastIva = m_bIvaRni
  m_bIvaRni = gDB.ValField(rs.fields, "bIvaRni")
  If bLastIva <> m_bIvaRni Then bIvaChanged = True
  
  If bIvaChanged Then
    pShowTotales m_Items.Properties(c_Items).Grid.Rows
  End If
End Sub

Private Function pFirmar() As Boolean
  Dim Doc     As cDocumento
  Dim us_id   As Long
  
  Set Doc = New cDocumento
  
  If m_Id = csNO_ID Then
    MsgWarning LNGGetText(1592, vbNullString)
              'Antes de poder firmar el Documento debe guardarlo.
    Exit Function
  End If
  
  If m_Firmado Then
    If Not Ask(LNGGetText(1593, vbNullString), vbYes, LNGGetText(1594, vbNullString)) Then
    'If Not Ask("El documento ya ha sido firmado desea borrar la firma", vbYes, "Firmar") Then
      Exit Function
    End If
  End If
  
  If Not Doc.Firmar(m_doc_id, us_id) Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocPedidoVentaFirmar " & m_Id & "," & us_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_est_id = gDB.ValField(rs.fields, cscEstId)
  m_Estado = gDB.ValField(rs.fields, cscEstNombre)
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties(csDocEstateID)
  
  With iProp
    .HelpId = m_est_id
    .Value = m_Estado
  End With
  
  gDB.GetData csTPedidoVenta, cscPvId, m_Id, cscPvFirmado, m_Firmado
  
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
  
  sqlstmt = "sp_DocPedidoVentaMover " & MoveTo & "," & m_Numero & "," & doc_id
  
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
        m_LastTrans = csNO_ID
        m_LastChof = csNO_ID
        
        ' Cargo un registro vacio
        '
        Load csNO_ID
        
        ' Refresco el formulario
        '
        pRefreshProperties
    
        ' Obtengo un nuevo numero de comprobante
        '
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscPvNrodoc
    
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
    c.HelpValueProcess = vbNullString
    c.Value = m_Documento
    
    Set c = .Item(cscPvFecha)
    c.Value = m_Fecha
    
    Set c = .Item(cscPvFechaentrega)
    c.Value = m_Fechaentrega
    
    Set c = .Item(cscCliId)
    c.HelpId = m_cli_id
    c.HelpValueProcess = vbNullString
    c.Value = m_cliente
    
    Set c = .Item(csDocNumberID)
    c.Value = m_Numero
    
    Set c = .Item(csDocEstateID)
    c.Value = m_Estado
    
    Set c = .Item(cscPvNrodoc)
    c.Value = m_Nrodoc
    c.TextMask = m_TaMascara
    c.TextAlign = vbRightJustify
    
    Set c = .Item(cscPvDescuento1)
    c.Value = m_Descuento1
    
    Set c = .Item(cscPvDescuento2)
    c.Value = m_Descuento2
    
    Set c = .Item(cscRamIdStock)
    If Val(m_ram_id_stock) <> csNO_ID Then
      c.HelpValueProcess = m_ram_id_stock
      c.HelpId = Val(m_ram_id_stock)
      c.Value = m_RamaStock
    Else
      ' Preferencias del usuario
      '
      c.HelpValueProcess = m_UserCfg.DeplRamId
      c.HelpId = m_UserCfg.DeplId
      c.Value = m_UserCfg.DeplNombre
    End If
    
    Set c = .Item(cscCpgId)
    c.HelpId = m_cpg_id
    c.HelpValueProcess = vbNullString
    c.Value = m_CondicionPago
    
    Set c = .Item(cscLpId)
    c.HelpFilter = GetListaPrecioGetXCliente(m_doc_id, m_cli_id)
    c.HelpId = m_Lp_id
    c.HelpValueProcess = vbNullString
    c.Value = m_ListaPrecio
    
    Set c = .Item(cscLdId)
    c.HelpFilter = GetListaDescGetXCliente(m_doc_id, m_cli_id)
    c.HelpId = m_Ld_id
    c.HelpValueProcess = vbNullString
    c.Value = m_ListaDescuento
    
    Set c = .Item(cscCcosId)
    c.HelpId = m_ccos_id
    c.HelpValueProcess = vbNullString
    c.Value = m_CentroCosto
    
    Set c = .Item(cscSucId)
    c.HelpId = m_suc_id
    c.HelpValueProcess = vbNullString
    c.Value = m_Sucursal
    
    Set c = .Item(cscVenId)
    c.HelpId = m_ven_id
    c.HelpValueProcess = vbNullString
    c.Value = m_vendedor
    
    Set c = .Item(cscPvDescrip)
    c.Value = m_Descrip
  
    Set c = .Item(cscLgjId)
    c.HelpId = m_lgj_id
    c.HelpValueProcess = vbNullString
    c.Value = m_Legajo
    
    Set c = .Item(cscProIdOrigen)
    c.HelpId = m_pro_id_origen
    c.HelpValueProcess = vbNullString
    c.Value = m_ProOrigen
    
    Set c = .Item(cscProIdDestino)
    c.HelpId = m_pro_id_destino
    c.HelpValueProcess = vbNullString
    c.Value = m_ProDestino
    
    Set c = .Item(cscTransId)
    c.HelpId = m_trans_id
    c.HelpValueProcess = vbNullString
    c.Value = m_Transporte
  
    Set c = .Item(cscPvDestinatario)
    c.Value = m_Destinatario
    
    Set c = .Item(cscPvOrdenCompra)
    c.Value = m_OrdenCompra
    
    Set c = .Item(cscChofId)
    c.HelpId = m_chof_id
    c.Value = m_Chofer
    c.HelpFilter = GetHelpTransporte(m_trans_id)
    
    Set c = .Item(cscCamId)
    c.HelpId = m_cam_id
    c.Value = m_Camion
    c.HelpFilter = GetHelpTransporte(m_trans_id)
    
    Set c = .Item(cscCamIdSemi)
    c.HelpId = m_cam_id_semi
    c.Value = m_Semi
    c.HelpFilter = GetHelpTransporte(m_trans_id)
    
    Set c = .Item(cscClisId)
    c.HelpId = m_clis_id
    c.HelpValueProcess = vbNullString
    c.Value = m_ClienteSucursal
  End With
  
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValues m_ObjAbm.Properties
  
  AbmGen.ResetChanged
  
  Set c = m_Items.Properties.Item(c_Items)
  If Not pLoadItems(c) Then Exit Sub
  
  m_ItemsDeleted = vbNullString
  
  Set AbmGen = m_Items
  AbmGen.ShowValues m_Items.Properties
  
  With m_Footer.Properties
    Set c = .Item(cscPvSubTotal)
    c.Value = m_SubTotal
    
    Set c = .Item(cscPvImporteDesc1)
    c.Value = m_ImporteDesc1
    
    Set c = .Item(cscPvImporteDesc2)
    c.Value = m_ImporteDesc2
    
    Set c = .Item(cscPvNeto)
    c.Value = m_Neto
    
    Set c = .Item(cscPvIvari)
    c.Value = m_Ivari
    
    Set c = .Item(cscPvIvarni)
    c.Value = m_Ivarni
    
    Set c = .Item(cscPvTotal)
    c.Value = m_Total
  End With
  
  Set AbmGen = m_Footer
  AbmGen.ShowValues m_Footer.Properties
  
  pSetEnabled

  ' DATADD
  ShowDataAddCliente m_UserCfg.ShowDataAddInVentas, _
                     m_ObjAbm

End Sub

' Construccion - Destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(1591, vbNullString)
                'Error al grabar el Pedido de Venta
  
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  Set m_StockConfig = New cStockConfig
  m_StockConfig.Load

  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load
  m_UserCfg.ValidatePV
  
  ReDim m_PrvIds(0)

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_StockConfig = Nothing
  Set m_GeneralConfig = Nothing
  Set m_ObjAbm = Nothing
  Set m_ObjClient = Nothing
  Set m_Footer = Nothing
  Set m_Items = Nothing
  ReDim m_PrvIds(0)
  
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

Private Sub pSetDatosTransporte()
  Dim chof_id         As Long
  Dim cam_id          As Long
  Dim chofer          As String
  Dim camion          As String
  
  Dim iProp       As cIABMProperty
  Dim Filter      As String
  
  With m_ObjAbm.Properties.Item(cscTransId)
    If m_LastTrans = .HelpId Then
      Exit Sub
    End If
    m_LastTrans = .HelpId
  End With

  Filter = GetHelpTransporte(m_LastTrans)

  If Not GetTransporteData(m_LastTrans, _
                          chof_id, chofer, _
                          cam_id, camion) Then Exit Sub

  ' Chofer
  Set iProp = m_ObjAbm.Properties.Item(cscChofId)
  iProp.HelpFilter = Filter
  
  If cam_id <> csNO_ID Then
    
    iProp.Value = chofer
    iProp.HelpId = chof_id
    
  End If
  
  m_ObjAbm.ShowValue iProp
  
  ' Camion
  Set iProp = m_ObjAbm.Properties.Item(cscCamId)
  iProp.HelpFilter = Filter
  
  If cam_id <> csNO_ID Then
    
    iProp.Value = camion
    iProp.HelpId = cam_id
    
  End If
  
  m_ObjAbm.ShowValue iProp
End Sub

Private Sub pSetDatosChofer()
  Dim chof_id         As Long
  Dim cam_id          As Long
  Dim camion          As String
  Dim cam_id_semi     As Long
  Dim semi            As String
  Dim iProp           As cIABMProperty

  With m_ObjAbm.Properties.Item(cscChofId)
    If m_LastChof = .HelpId Then
      Exit Sub
    End If
    m_LastChof = .HelpId
  End With

  If Not GetChoferData(m_LastChof, _
                       cam_id, camion, _
                       cam_id_semi, semi) Then Exit Sub

  ' Camion
  Set iProp = m_ObjAbm.Properties.Item(cscCamId)
  
  If cam_id <> csNO_ID Then
    
    iProp.Value = camion
    iProp.HelpId = cam_id
    
  End If
  
  m_ObjAbm.ShowValue iProp

  ' Semi
  Set iProp = m_ObjAbm.Properties.Item(cscCamIdSemi)
  
  If cam_id_semi <> csNO_ID Then
    
    iProp.Value = semi
    iProp.HelpId = cam_id_semi
    
  End If
  
  m_ObjAbm.ShowValue iProp
End Sub

Private Sub pShowRemito()
  On Error GoTo ControlError

  Dim o As Object
  Set o = CSKernelClient2.CreateObject("CSVenta2.cRemitoVenta")
  
  o.ShowRemito pGetCliId(), pGetPvIds()

  GoTo ExitProc
ControlError:
  MngError Err, "pShowRemito", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pShowFactura()
  On Error GoTo ControlError

  Dim o As Object
  Set o = CSKernelClient2.CreateObject("CSVenta2.cFacturaVenta")
  
  o.ShowFacturaPedido pGetCliId(), pGetPvIds()

  GoTo ExitProc
ControlError:
  MngError Err, "pShowFactura", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetPvIds() As Long()
  Dim rtn() As Long
  ReDim rtn(1)
  rtn(1) = m_Id
  pGetPvIds = rtn
End Function

Private Function pGetCliId() As Long
  pGetCliId = m_ObjAbm.Properties(cscCliId).HelpId
End Function

Private Function pGetItems() As cIABMProperty
  Set pGetItems = m_Items.Properties.Item(c_Items)
End Function

' HIDECOLS
'
Private Sub pShowHideCols(ByVal bOnlyStock As Boolean)
  Dim Columns   As cIABMGridColumns
  Dim bVisible  As Boolean
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  If AbmObj.InSave Then Exit Sub
  
  bVisible = Val(m_ObjAbm.Properties.Item(c_HideCols).Value) = 0
  
  Dim iProp As cIABMProperty
  Set iProp = pGetItems()
    
  AbmObj.DrawGrid iProp, False
  
  Dim i As Integer
  
  Set Columns = iProp.Grid.Columns
  For i = 1 To Columns.count
    Select Case Columns(i).Key
      
      Case KI_DESCUENTO, KI_UNIDAD, KI_PRECIO_LP, KI_IVARNI, KI_CCOS_ID
        
        ' Solo si la llamada fue para todas las columnas
        ' y no unicamente para las columnas de stock
        '
        If Not bOnlyStock Then
          Columns(i).Visible = bVisible
          AbmObj.RefreshColumnPropertiesByIndex iProp, i
        End If
            
    End Select
  Next
  
  AbmObj.DrawGrid iProp, True
End Sub
'
' HIDECOLS - fin

Private Function pGetFileNamePostFix() As String
  pGetFileNamePostFix = left$(m_cliente, 50) & "-" & m_Nrodoc
End Function

Private Sub pShowMenuDocAction()
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  Dim Menu As String
  
  Menu = LNGGetText(3966, vbNullString) & "~1" _
       & "|" & LNGGetText(3967, vbNullString) & "~2"
                ' Remitir el pedido|Facturar el pedido
  
  AbmObj.ShowPopMenu Menu
End Sub
