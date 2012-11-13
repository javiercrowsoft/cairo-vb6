VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRemitoVenta"
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
Implements CSIDocumento.cIDocumento
'--------------------------------------------------------------------------------
' cRemitoVenta
' 24-01-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cRemitoVenta"

Private Const c_Items = "ITEMS"

' HIDECOLS
Private Const c_HideColsRv = "HideColsRv"

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

Private Const K_DEPL_ID                        As Integer = 25
Private Const K_VEN_ID                         As Integer = 26
Private Const K_LGJ_ID                         As Integer = 27
Private Const K_PRO_ID_ORIGEN                  As Integer = 29
Private Const K_PRO_ID_DESTINO                 As Integer = 30
Private Const K_TRANS_ID                       As Integer = 31
Private Const K_CLIS_ID                        As Integer = 33

Private Const K_COTIZACION                     As Integer = 28

Private Const K_RETIRO                         As Integer = 34
Private Const K_GUIA                           As Integer = 35

Private Const K_CHOF_ID                        As Integer = 36
Private Const K_CAM_ID                         As Integer = 37
Private Const K_CAM_ID_SEMI                    As Integer = 38
Private Const K_DESTINATARIO                   As Integer = 39

Private Const K_ORDENCOMPRA                    As Integer = 40

' HIDECOLS
Private Const K_HIDECOLS                       As Integer = 41

Private Const KI_RV_ID                          As Integer = 1
Private Const KI_RVI_ID                         As Integer = 2
Private Const KI_ORDEN                          As Integer = 3
Private Const KI_CANTIDAD                       As Integer = 4
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

Private Const KI_PR_LLEVANROSERIE               As Integer = 23
Private Const KI_ES_KIT                         As Integer = 24
Private Const KI_NROSERIE                       As Integer = 25
Private Const KI_GRUPO                          As Integer = 26

' Lote
'
Private Const KI_STL_ID                         As Integer = 27
Private Const KI_PR_LLEVALOTE                   As Integer = 28

' Lote Fifo
'
Private Const KI_PR_LOTEFIFO                    As Integer = 32

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

Private m_chof_id                      As Long
Private m_Chofer                       As String

Private m_cam_id                       As Long
Private m_Camion                       As String

Private m_cam_id_semi                  As Long
Private m_Semi                         As String

Private m_Destinatario                 As String

Private m_OrdenCompra                  As String

Private m_pro_id_origen                As Long
Private m_ProOrigen                    As String
Private m_pro_id_destino               As Long
Private m_ProDestino                   As String

Private m_trans_id                     As String
Private m_Transporte                   As String

Private m_Editing                      As Boolean

Private m_bShowStockData               As Boolean
Private m_depl_id                      As Long
Private m_Deposito                     As String

Private m_Cotizacion                   As Double
Private m_mon_id                       As Long
Private m_lastFecha                    As Date
Private m_lastMonIdCotizacion          As Long

Private m_retiro                       As String
Private m_guia                         As String

' Lote
'
Private m_depf_id                      As Long

' Para ver documentos auxiliares
'
Private m_st_id                        As Long
Private m_st_id_consumo                As Long
Private m_st_id_consumoTemp            As Long
Private m_st_id_producido              As Long


Private m_Footer            As cIABMGeneric
Private m_Items             As cIABMGeneric
Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_LastDoc           As Long
Private m_LastDoctId        As Long ' nrs devolucion
Private m_LastCli           As Long
Private m_LastTrans         As Long
Private m_LastChof          As Long
Private m_LastDocName       As String
Private m_LastCliName       As String

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

Private m_PvIds()           As Long
Private m_OsIds()           As Long

Private m_PrnsIds()         As Long

Private m_bIva              As Boolean
Private m_bIvaRni           As Boolean

Private m_TaPropuesto       As Boolean
Private m_TaMascara         As String

Private m_ObjApply          As cRemitoVentaAplic

Private m_NrosSerie         As Collection
Private m_CollKitInfo       As Collection

Private m_bPushVirtualNext  As Boolean
Private m_bAutoFactura      As Boolean
Private m_bAutoPago         As Boolean
Private m_ModoVentaCtaCte   As Boolean
Private m_cue_id_autoPago   As Long

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

' propiedades publicas
Public Property Let PushVirtualNext(ByVal rhs As Boolean)
  m_bPushVirtualNext = rhs
End Property

Public Property Let AutoPago(ByVal rhs As Boolean)
  m_bAutoPago = rhs
End Property

Public Property Let cue_id_autoPago(ByVal rhs As Long)
  m_cue_id_autoPago = rhs
End Property

Public Property Let ModoVentaCtaCte(ByVal rhs As Boolean)
  m_ModoVentaCtaCte = rhs
End Property

Public Property Let AutoFactura(ByVal rhs As Boolean)
  m_bAutoFactura = rhs
End Property

' propiedades privadas
' funciones publicas

' Edit Apply
'
Public Sub Refresh()
  Load m_Id
  pRefreshProperties
End Sub

Public Function TerminateWizard(ByVal id As Long)
  On Error Resume Next
  If id <> csNO_ID Then
    cIEditGeneric_Edit id
  End If
End Function

Public Sub ShowRemito(ByVal CliId As Long, ByRef vPvIds() As Long)
  On Error GoTo ControlError

  m_cli_id = CliId
  gDB.GetData csTCliente, cscCliId, CliId, cscCliNombre, m_cliente
  
  Dim i As Long
  ReDim m_PvIds(UBound(vPvIds) + 1)
  For i = 1 To UBound(vPvIds) + 1
    m_PvIds(i) = vPvIds(i - 1)
  Next
  
  If Not pInitMembers Then
    Exit Sub
  End If

  pShowStartWizard

  GoTo ExitProc
ControlError:
  MngError Err, "ShowRemito", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub ShowRemitoOrden(ByVal CliId As Long, ByRef vOsIds() As Long)
  On Error GoTo ControlError

  m_cli_id = CliId
  gDB.GetData csTCliente, cscCliId, CliId, cscCliNombre, m_cliente
    
  Dim i As Long
  ReDim m_OsIds(UBound(vOsIds) + 1)
  For i = 1 To UBound(vOsIds) + 1
    m_OsIds(i) = vOsIds(i - 1)
  Next
  
  If Not pInitMembers Then
    Exit Sub
  End If

  pShowStartWizardOrden

  GoTo ExitProc
ControlError:
  MngError Err, "ShowRemito", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub ShowRemitoOrdenAuto(ByVal CliId As Long, _
                               ByRef vOsIds() As Long, _
                               ByRef vPrnsIds() As Long)
  On Error GoTo ControlError

  m_cli_id = CliId
  gDB.GetData csTCliente, cscCliId, CliId, cscCliNombre, m_cliente
  
  Dim i As Long
  ReDim m_OsIds(UBound(vOsIds) + 1)
  For i = 1 To UBound(vOsIds) + 1
    m_OsIds(i) = vOsIds(i - 1)
  Next
  
  ReDim m_PrnsIds(UBound(vPrnsIds) + 1)
  For i = 1 To UBound(vPrnsIds) + 1
    m_PrnsIds(i) = vPrnsIds(i - 1)
  Next
  
  If Not pInitMembers Then
    Exit Sub
  End If

  pShowStartWizardOrden

  GoTo ExitProc
ControlError:
  MngError Err, "ShowRemito", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pInitMembers() As Boolean
  Set cIEditGeneric_ObjAbm = New cABMGeneric
  Set cIEditGenericDoc_Footer = New cABMGeneric
  Set cIEditGenericDoc_Items = New cABMGeneric
  
  If Not DocSecurityCanAccess(csPreVtaNewRemito, _
                              csNO_ID, _
                              csEDocTPreNew) Then
    Exit Function
  End If
  pInitMembers = True
End Function

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  If Not DocSecurityCanAccessEx(csPreVtaNewRemito, _
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscRvNrodoc
  pSetEnabled
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True

  cIEditGeneric_Edit csNO_ID
  m_LastCli = csNO_ID
  m_LastTrans = csNO_ID
  m_LastChof = csNO_ID
  
  If Not m_DocEditable Then
    If LenB(m_DocEditMsg) Then
      MsgWarning m_DocEditMsg
    End If
  End If
  
  If m_ObjAbm.Properties.Item(cscDocId).HelpId = csNO_ID Then
    MsgInfo LNGGetText(1562, vbNullString)  'Debe indicar un documento
  End If
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties.Item(cscCliId)
  
  If m_UserCfg.NuevoAlGrabar Then
    With iProp
      .HelpId = csNO_ID
      .Value = vbNullString
    End With
    m_ObjAbm.ShowValue iProp
  End If
  AbmObj.SetFocusFirstCtrlInNew = True
  
  ' Obtengo los datos por defecto del cliente
  '
  pSetDatosCliente
  
  ' Obtengo el numero para este comprobante
  '
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscRvNrodoc
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

  Doc.ClientTable = csTRemitoVenta
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
      ShowEditState m_DocEditMsg, LNGGetText(1712, vbNullString)  'Remitos de ventas
      
    Case MSG_DOC_DELETE
      If cIEditGeneric_Delete(m_Id) Then
        cIABMClient_MessageEx = True
        pMove MSG_DOC_NEXT
      End If
    
    Case MSG_DOC_APPLY
      pShowApply
    
    Case MSG_DOC_ANULAR
      DocAnular m_Id, m_est_id, m_Estado, csPreVtaAnularRemito, csPreVtaDesAnularRemito, m_ObjAbm, m_DocEditable, m_DocEditMsg, "sp_DocRemitoVentaAnular", "sp_DocRemitoVentaEditableGet"
      pSetEnabled
    
    Case MSG_DOC_REFRESH
      Load m_Id
      pRefreshProperties
  
    Case MSG_DOC_NEW_WITH_WIZARD
      cIABMClient_MessageEx = True
    
    Case MSG_DOC_EX_GET_ITEMS
      Set cIABMClient_MessageEx = m_Items
    
    Case MSG_DOC_EX_GET_FOOTERS
      Set cIABMClient_MessageEx = m_Footer
  
    Case MSG_DOC_SEARCH                     ' En info cABMInteface nos
                                            ' indica si hay cambios sin
                                            ' guardar
      DocumentSearch csEDT_RemitoVenta, Me, Not CBool(Info)
    
    Case MSG_DOC_DOC_AUX
      
      If m_bShowStockData Then
        If m_Id Then
        
          Dim AbmObj As cABMGeneric
          Set AbmObj = m_ObjAbm
          
          If pDocDescargaBOM() Then
          
            Dim Menu As String
            Menu = LNGGetText(1713, vbNullString) & "~1"  'Ver &Transferencia de Stock~1
            
            If m_st_id_consumo <> csNO_ID Then
              Menu = Menu & "|" & LNGGetText(1714, vbNullString) & "~2"
                            '& "|Ver &Consumo~2"
            End If
            
            If m_st_id_consumoTemp <> csNO_ID Then
              Menu = Menu & "|" & LNGGetText(1715, vbNullString) & "~3"
                          '& "|Ver Consumo de T&emporales~3"
            End If
            
            If m_st_id_producido <> csNO_ID Then
              Menu = Menu & "|" & LNGGetText(1716, vbNullString) & "~4"
                          '& "|Ver &Producción~4"
            End If
            
            Menu = Menu & "|" & LNGGetText(1717, vbNullString) & "~5"
                        '& "|Ver T&odos~5"
            
            AbmObj.ShowPopMenu Menu
          Else
            cIABMClient_MessageEx MSG_MENU_AUX, 1
          End If
          
        Else
          MsgInfo LNGGetText(1620, vbNullString)
            'Debe editar un comprobante guardado para poder ver los documentos auxiliares
        End If
      End If
    
    Case MSG_DOC_DOC_EDIT
      
      If m_Id Then
      
        If m_DocEditable Then
        
          MsgInfo LNGGetText(1555, vbNullString)
                    'Este documento puede editarse normalmente
        Else
          
          If DocCanSave(m_ObjAbm, cscRvFecha) Then
            
            Dim EditDoc As cEditDocEx
            Set EditDoc = New cEditDocEx
            
            Set EditDoc.ObjectClient = Me
            EditDoc.Edit m_Id, _
                         m_Doct_id, _
                         csTRemitoVenta, _
                         cscRvId, _
                         csTRemitoVentaItem, _
                         cscRviId, _
                         csPreVtaNewRemito, _
                         csPreVtaEditRemito, _
                         m_cli_id, csNO_ID, _
                         True
          End If
          
        End If
      
      Else
        MsgInfo LNGGetText(1556, vbNullString)
                'Esta opción solo sirve para modificar documentos guardados y aplicados
      End If
    
    Case MSG_DOC_DOC_ACTION
    
      If m_Id Then
      
        pShowMenuDocAction
        
      Else
        MsgInfo LNGGetText(3955, vbNullString)
                'Esta opción solo sirve para modificar documentos guardados y aplicados
      End If
    
    Case MSG_MENU_AUX
      
      Select Case Val(Info)
        Case 1 ' Transferencia de Stock
          ShowDocAux m_st_id, _
                     "CSStock2.cStock", _
                     "CSABMInterface2.cABMGeneric"

        Case 2 ' Consumo
          ShowDocAux m_st_id_consumo, _
                     "CSStock2.cStock", _
                     "CSABMInterface2.cABMGeneric"
        
        Case 3 ' Consumo Temporal
          ShowDocAux m_st_id_consumoTemp, _
                     "CSStock2.cStock", _
                     "CSABMInterface2.cABMGeneric"
        
        Case 4 ' Producido
          ShowDocAux m_st_id_producido, _
                     "CSStock2.cStock", _
                     "CSABMInterface2.cABMGeneric"
        
        Case 5 ' Ambos
        
          ShowDocAux m_st_id, _
                     "CSStock2.cStock", _
                     "CSABMInterface2.cABMGeneric"
          
          If m_st_id_consumo <> csNO_ID Then
            ShowDocAux m_st_id_consumo, _
                       "CSStock2.cStock", _
                       "CSABMInterface2.cABMGeneric"
          End If
          
          If m_st_id_consumoTemp <> csNO_ID Then
            ShowDocAux m_st_id_consumoTemp, _
                       "CSStock2.cStock", _
                       "CSABMInterface2.cABMGeneric"
          End If
          
          If m_st_id_producido <> csNO_ID Then
            ShowDocAux m_st_id_producido, _
                       "CSStock2.cStock", _
                       "CSABMInterface2.cABMGeneric"
          End If
      
        Case 6
          pShowFactura False
          
        Case 7
          pShowFactura True
          
        Case 8
          pCancelarRemito
          
      End Select
  
    Case MSG_DOC_HISTORY
    
      If m_Id <> csNO_ID Then
    
        ShowHistory csRemitoVenta, m_Id, m_Documento & " " & m_Nrodoc
      Else
        
        MsgInfo LNGGetText(1552, vbNullString) 'El documento aun no ha sido guardado
      End If
  
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
      
      ' Si cambio de documento
      '
      If DocChange(m_ObjAbm, m_LastDoc, m_LastDocName) Then
        
        ' Obtengo el tipo de documento
        If Not gDB.GetData(csTDocumento, cscDocId, m_LastDoc, cscDoctId, m_LastDoctId) Then Exit Function ' nrs devolucion
        
        ' Si cambie de documento y estaba en un comprobante ya guardado
        ' tengo que mostrar el formulario sin datos, para evitar
        ' que presione guardar y le cambie el doc_id al comprobante por error
        '
        If m_Id <> csNO_ID And m_doc_id <> m_LastDoc Then cIEditGeneric_Edit csDocChanged
        
        ' Obtengo el numero para este comprobante
        '
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscRvNrodoc

        ' Si corresponde muestro la cotizacion de la moneda del documento
        '
        pShowCotizacion
        
        ' Si corresponde muestro el deposito
        '
        pSetShowStockData False
      End If
      
      ' Defino el estado de edicion del comprobante
      '
      pSetEnabled
      
    Case K_CLI_ID
      
      ' Obtengo los datos del cliente
      '
      pSetDatosCliente
      
      ' DATADD
      ShowDataAddCliente m_UserCfg.ShowDataAddInVentas, _
                         m_ObjAbm
      
    Case K_DESCUENTO1, K_DESCUENTO2
      pShowTotales m_Items.Properties(c_Items).Grid.Rows
      
    ' Lote
    '
    Case K_DEPL_ID
    
      pSetStock
  
    Case K_FECHA
      
      ' Cotizacion
      If m_lastFecha <> pGetFecha() Then
        m_lastFecha = pGetFecha()
        m_lastMonIdCotizacion = csNO_ID
        pShowCotizacion
      End If
      
    Case K_TRANS_ID
    
      pSetDatosTransporte
  
    Case K_CHOF_ID
    
      pSetDatosChofer
  
    ' HIDECOLS
    '
    Case K_HIDECOLS
    
      pShowHideCols False
  
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Dim fields   As cFields
  Dim bIsNew   As Boolean
  
  ' Save and State
  '
  If Not DocCanEdit(m_DocEditable, m_DocEditMsg) Then
    cIABMClient_Save = True
    Exit Function
  End If
  If Not DocCanSave(m_ObjAbm, cscRvFecha) Then
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
  
  With register
    .fieldId = cscRvTMPId
    .Table = csTRemitoVentaTMP
    
    .id = csNew
      
    Set fields = .fields
    
    With .fields
      
      If m_Copy Then
        .Add2 cscRvId, csNew, csLong
        bIsNew = True
      Else
        .Add2 cscRvId, m_Id, csLong
        bIsNew = m_Id = csNO_ID
      End If
      
      If m_est_id = csNO_ID Or bIsNew Then
        m_est_id = CSGeneralEx2.csEEstado.csEEst_Pendiente
      End If
      
      Dim IProperty As cIABMProperty
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_NUMERO
              fields.Add2 cscRvNumero, .Value, csLong
            Case K_NRODOC
              fields.Add2 cscRvNrodoc, .Value, csText
            Case K_DESCRIP
              fields.Add2 cscRvDescrip, .Value, csText
            Case K_FECHA
              fields.Add2 cscRvFecha, .Value, csDate
            Case K_FECHAENTREGA
              fields.Add2 cscRvFechaentrega, .Value, csDate
            Case K_CLI_ID
              fields.Add2 cscCliId, .HelpId, csId
            Case K_COTIZACION
              fields.Add2 cscRvCotizacion, .Value, csDouble
            Case K_CCOS_ID
              fields.Add2 cscCcosId, .HelpId, csId
            Case K_SUC_ID
              fields.Add2 cscSucId, .HelpId, csId
            Case K_DESCUENTO1
              fields.Add2 cscRvDescuento1, .Value, csCurrency
            Case K_DESCUENTO2
              fields.Add2 cscRvDescuento2, .Value, csCurrency
            Case K_DOC_ID
              fields.Add2 cscDocId, .HelpId, csId
            Case K_LP_ID
              fields.Add2 cscLpId, .HelpId, csId
            Case K_LD_ID
              fields.Add2 cscLdId, .HelpId, csId
            Case K_CPG_ID
              fields.Add2 cscCpgId, .HelpId, csId
            Case K_VEN_ID
              fields.Add2 cscVenId, .HelpId, csId
            Case K_LGJ_ID
              fields.Add2 cscLgjId, .HelpId, csId
            Case K_PRO_ID_ORIGEN
              fields.Add2 cscProIdOrigen, .HelpId, csId
            Case K_PRO_ID_DESTINO
              fields.Add2 cscProIdDestino, .HelpId, csId
            Case K_TRANS_ID
              fields.Add2 cscTransId, .HelpId, csId
            Case K_CLIS_ID
              fields.Add2 cscClisId, .HelpId, csId
            Case K_CHOF_ID
              fields.Add2 cscChofId, .HelpId, csId
            Case K_CAM_ID
              fields.Add2 cscCamId, .HelpId, csId
            Case K_CAM_ID_SEMI
              fields.Add2 cscCamIdSemi, .HelpId, csId
            Case K_DESTINATARIO
              fields.Add2 cscRvDestinatario, .Value, csText
            Case K_ORDENCOMPRA
              fields.Add2 cscRvOrdenCompra, .Value, csText
            Case K_DEPL_ID
              fields.Add2 cscDeplId, .HelpId, csId
            Case K_RETIRO
              fields.Add2 cscRvRetiro, .Value, csText
            Case K_GUIA
              fields.Add2 cscRvGuia, .Value, csText
          End Select
        End With
      Next
      
      For Each IProperty In m_Footer.Properties
        With IProperty
          Select Case .Key
            Case K_TOTAL
              fields.Add2 cscRvTotal, .Value, csCurrency
            Case K_NETO
              fields.Add2 cscRvNeto, .Value, csCurrency
            Case K_IVARI
              fields.Add2 cscRvIvari, .Value, csCurrency
            Case K_IVARNI
              fields.Add2 cscRvIvarni, .Value, csCurrency
            Case K_SUBTOTAL
              fields.Add2 cscRvSubtotal, .Value, csCurrency
            Case K_IMPORTEDESC1
              fields.Add2 cscRvImportedesc1, .Value, csCurrency
            Case K_IMPORTEDESC2
              fields.Add2 cscRvImportedesc2, .Value, csCurrency
          End Select
        End With
      Next
    
      .Add2 cscEstId, m_est_id, csId
    
      .HaveLastUpdate = True
      .HaveWhoModify = True
    
    End With
    
    If Not .BeginTrans(gDB) Then Exit Function
    
    If Not gDB.Save(register, , _
                    "cIABMClient_Save", _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
    
    If Not pSaveItems(.id) Then Exit Function
    If Not .CommitTrans() Then Exit Function
  
  End With
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DocRemitoVentaSave " & register.id
  
  If Not gDB.SaveSp(sqlstmt, rs, DocGetTimeOut(m_NrosSerie), _
                "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim id As Long
  If Not GetDocIDFromRecordset(rs, id) Then Exit Function
  
  m_Copy = False
  
  If Load(id) Then

    Dim AbmGen As cABMGeneric
    Set AbmGen = m_ObjAbm
    
    If bIsNew Then
    
      If m_UserCfg.NuevoAlGrabar Then
        AbmGen.PrintDocumento
      End If
    
    End If
  
    AbmGen.SendNewDoc = m_UserCfg.NuevoAlGrabar
    
    cIABMClient_Save = True
    
  Else
  
    cIABMClient_Save = False
    
  End If
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  ' HIDECOLS
  '
  CSKernelClient2.SetRegistry csInterface, c_HideColsRv, Val(m_ObjAbm.Properties.Item(c_HideCols).Value)
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  m_ObjTree.sqlstmt = "sp_lsdoc_RemitoVenta"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
  
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(1718, vbNullString)    'Remito de venta
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_FECHA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(1558, vbNullString)    'Debe indicar una fecha
            Exit Function
          End If
        Case K_FECHAENTREGA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(1564, vbNullString)    'Debe indicar una fecha de entrega
            Exit Function
          End If
        Case K_CLI_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1563, vbNullString)    'Debe indicar un Cliente
            Exit Function
          End If
        Case K_DOC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1562, vbNullString)    'Debe indicar un documento
            Exit Function
          End If
        Case K_SUC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1560, vbNullString)    'Debe indicar una sucursal
            Exit Function
          End If
        Case K_COTIZACION
          If ValEmpty(.Value, csDouble) And .Visible Then
            MsgInfo LNGGetText(1626, vbNullString)    'Debe indicar una cotización
            Exit Function
          End If
        Case K_DEPL_ID
          If ValEmpty(.HelpId, csId) And m_bShowStockData Then
            MsgInfo LNGGetText(1559, vbNullString)    'Debe indicar un deposito
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
  
  sqlstmt = "select rv.doct_id, rv.doc_id, rv_nrodoc, cli_nombre, rv.cli_id " & _
            "from RemitoVenta rv inner join Cliente cli " & _
              "on rv.cli_id = cli.cli_id " & _
            "where rv.rv_id = " & id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function

  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_Id = id
  m_doc_id = gDB.ValField(rs.fields, cscDocId)
  m_Doct_id = gDB.ValField(rs.fields, cscDoctId)
  m_cli_id = gDB.ValField(rs.fields, cscCliId)
  m_cliente = gDB.ValField(rs.fields, cscCliNombre)
  m_Nrodoc = gDB.ValField(rs.fields, cscRvNrodoc)
  
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreVtaListRemito)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
  m_ObjAbm.IsDocument = True

#If Not PREPROC_SFS Then
  Dim AbmGen      As cABMGenericDocEx
  
  Set AbmGen = m_ObjAbm
  With AbmGen
    .FactoryObject = "CSABMInterface2.cFactory"
    .ObjForm = "CSABMInterface2.fRemitoVenta"
  End With
#End If
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(id As Long) As Boolean
  Dim doc_id As Long
  
  If Not m_ObjAbm Is Nothing Then
    doc_id = GetdocIdFromObjAbm(m_ObjAbm)
  Else
    If Not GetDocIdFromId(id, _
                          csTRemitoVenta, _
                          cscRvId, _
                          doc_id) Then
      Exit Function
    End If
  End If
  
  If Not DocSecurityCanAccess( _
                  csPreVtaDeleteRemito, _
                  doc_id, _
                  csEDocTPreDelete) Then
    Exit Function
  End If
  
  Dim sqlstmt As String
  
  sqlstmt = "sp_DocRemitoVentaDelete " & id & "," & EmpId & "," & User.id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not DocSecurityCanAccess(csPreVtaListRemito, GetdocIdFromObjAbm(m_ObjAbm), csEDocTPreList) Then Exit Function
                     
                            ' Id = csDocChanged esto significa que se cambio
                            '                   el documento estando en un
                            '                   comprobante ya guardado
                            '
  m_IsNew = id = csNO_ID Or id = csDocChanged

  If Not Load(id) Then Exit Function
  
  If m_ObjAbm.Properties.count = 0 Then
    If Not LoadCollection() Then Exit Function
  Else
    pRefreshProperties
  End If

  Dim AbmGen As cABMGeneric
  Set AbmGen = m_ObjAbm
  AbmGen.NewKeyPropFocus = vbNullString

  ' Solo muestro asistentes si el nuevo no se esta dando por
  ' un cambio de documento
  '
  If id <> csDocChanged And m_IsNew And pDocDesdePedido() Then
      
    If pDocDescargaBOM() Then
    
      pShowStartWizardBOM
    
    Else
      
      pShowStartWizard
    End If
    
  ElseIf id <> csDocChanged And m_IsNew And pDocDesdeOrden() Then
  
    pShowStartWizardOrden
    
  Else
    AbmGen.NewKeyPropFocus = cscCliId
  End If
  
  m_Editing = True
  m_Copy = False
  
  cIEditGeneric_Edit = True
  Exit Function
ControlError:
  MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal id As Long) As Boolean

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

Private Function cIEditGeneric_Preview(ByVal id As Long) As Boolean

End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  On Error GoTo ControlError
  
  Select Case Key
    Case K_ITEMS
      With m_Items.Properties(c_Items)
        pShowImporteAndIva .Grid.Rows(lRow)
        pShowTotales .Grid.Rows
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
              pAddMultiRows oCell.HelpValueProcess, Info
              pProcessMultiRow = True
            End If
          End If
        End If
      End With
  End Select
  
End Function

Private Sub pAddMultiRows(ByVal Ids As String, _
                          ByRef Info As Variant)
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
    
  sqlstmt = "select pr_nombreventa, pr_id from Producto where pr_id in (" & Ids & ")"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  If rs.EOF Then Exit Sub
  
  Dim i As Long
  Dim j As Long
  Dim k As Long
  Dim pr_id As Long
  Dim vIds  As Variant
  Dim vIds2 As Variant
  Dim bFound As Boolean
  
  vIds2 = Split(Ids, ",")
  
  ReDim vIds(UBound(vIds2))
  
  For i = 0 To UBound(vIds2)
    bFound = False
    For j = 0 To UBound(vIds)
    
      If vIds2(i) = vIds(j) Then
        bFound = True
        Exit For
      End If
      
    Next
    If Not bFound Then
      vIds(k) = vIds2(i)
      k = k + 1
    End If
  Next
  
  ReDim Preserve vIds(k - 1)
  
  ' Ahora respeto el orden de seleccion
  '
  For i = 0 To UBound(vIds)
  
    rs.MoveFirst
    
    Do While Not rs.EOF
  
      pr_id = gDB.ValField(rs.fields, cscPrId)
      
      If Val(vIds(i)) = pr_id Then
        Info.NewId.Add pr_id
        Info.NewValue.Add gDB.ValField(rs.fields, cscPrNombreVenta)
        Exit Do
      End If
      
      rs.MoveNext
    Loop
    
  Next
  
  ' No lo toquen, es mas 1 :( o explota todooo :P
  ' ups al final no era jeje
  '
  Info.iAddRows = Info.NewId.count '+ 1
  
  Info.bAddRows = Info.iAddRows
  
End Sub

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

Private Function pColumnBeforeEdit(ByRef IProperty As cIABMProperty, _
                                   ByVal lRow As Long, _
                                   ByVal lCol As Long, _
                                   ByVal iKeyAscii As Integer) As Boolean
  Dim Row As cIABMGridRow
  
  Select Case IProperty.Grid.Columns(lCol).Key
    Case KI_NROSERIE
      Set Row = IProperty.Grid.Rows(lRow)
      If Not Row Is Nothing Then
        pColumnBeforeEdit = pCell(Row, KI_PR_LLEVANROSERIE).id
      End If
    
    ' Lote
    '
    Case KI_STL_ID
      Set Row = IProperty.Grid.Rows(lRow)
      
      If Not Row Is Nothing Then
      
        If pCell(Row, KI_PR_LLEVALOTE).id And _
           pCell(Row, KI_PR_LLEVANROSERIE).id = 0 Then
           
          Dim pr_id_kit As Long
          If pCell(Row, KI_ES_KIT).id Then
            pr_id_kit = pCell(Row, KI_PR_ID).id
          End If
           
          With IProperty.Grid.Columns.Item(cscStlId)
            .HelpFilter = "'pr_id = " & _
                                  pCell(Row, KI_PR_ID).id & _
                          " and " & GetStockLoteFilterEx( _
                                              pGetDeplId(), _
                                              m_StockConfig.StockXFisico, _
                                              pr_id_kit, _
                                              m_depf_id, _
                                              pGetCliId(), _
                                              csNO_ID) & "'"
          End With
          
          Dim AbmObj As cABMGeneric
          Set AbmObj = m_ObjAbm
          
          AbmObj.RefreshColumnProperties IProperty, cscStlId
          
          pColumnBeforeEdit = True
        
        End If
      End If
    
    Case Else
      pColumnBeforeEdit = True
  End Select
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
      SetPrecio Row, NewValueID, m_ObjAbm.Properties(cscLpId), KI_PRECIO_LP, KI_PRECIO_USR
      SetDescuento Row, NewValueID, pGetPrecioFromRow(Row), m_ObjAbm.Properties(cscLdId), KI_PRECIO, KI_DESCUENTO
      pSetTasasImpositivas Row, NewValueID, NewValue
      
    Case KI_PRECIO_USR
      Set Row = IProperty.Grid.Rows(lRow)
      SetDescuento Row, pCell(Row, KI_PR_ID).id, NewValue, m_ObjAbm.Properties(cscLdId), KI_PRECIO, KI_DESCUENTO
  
  End Select
  
  pColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  Dim Row As cIABMGridRow
  
  Select Case Key
    Case K_ITEMS
      With m_Items.Properties.Item(c_Items).Grid
        Select Case .Columns(lCol).Key
          Case KI_NROSERIE
            Set Row = .Rows(lRow)
            If pCell(Row, KI_PR_LLEVANROSERIE).id Then
              
              Dim PrId As Long
              
              PrId = pCell(Row, KI_PR_ID).id
              
              ' nrs devolucion
              cIABMClientGrid_ColumnButtonClick = EditNroSerie(pCell(Row, KI_GRUPO).id, _
                                                               Val(pCell(Row, KI_CANTIDAD).Value), _
                                                               Row, _
                                                               m_NrosSerie, _
                                                               KI_GRUPO, _
                                                               KI_NROSERIE, _
                                                               lRow, _
                                                               PrId, _
                                                               pGetDeplId, _
                                                               False, _
                                                               pCell(Row, KI_ES_KIT).id, _
                                                               GetKitInfo(PrId, m_CollKitInfo), _
                                                               csNO_ID, pGetCliId)
            End If
        End Select
      End With
  End Select
End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim id As Long
  
  id = Val(pCell(Row, KI_RVI_ID).Value)
  
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
  Dim bRowIsEmpty           As Boolean
  
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
  Dim bLlevaNroSerie        As Boolean
  Dim Cantidad              As Double
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CANTIDAD
        Cantidad = Val(Cell.Value)
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(1365, vbNullString, strRow)   'Debe indicar una cantidad (1)
          Exit Function
        End If

' Por ahora no lo exijo
'
'      Case KI_PRECIO
'        If ValEmpty(Cell.Value, csCurrency) Then
'          MsgInfo "Debe indicar un precio" & strRow
'          Exit Function
'        End If
      
      Case KI_PR_ID
        If ValEmpty(Cell.id, csId) Then
          MsgInfo LNGGetText(1565, vbNullString, strRow) 'Debe indicar un producto de venta (1)
          Exit Function
        End If
      
      Case KI_NROSERIE
        bLlevaNroSerie = pCell(Row, KI_PR_LLEVANROSERIE).id
        If ValEmpty(Cell.Value, csText) _
           And bLlevaNroSerie _
           And m_bShowStockData Then
          MsgInfo LNGGetText(1630, vbNullString, strRow) 'Debe indicar un numero de serie (1)
          Exit Function
        End If
      
      ' Lote
      '
      ' Lote Fifo
      '
      Case KI_STL_ID
        If m_bShowStockData Then
          If ValEmpty(Cell.id, csId) And _
             pCell(Row, KI_PR_LLEVALOTE).id And _
             pCell(Row, KI_PR_LLEVANROSERIE).id = 0 And _
             pCell(Row, KI_PR_LOTEFIFO).id = 0 Then
        
            MsgInfo LNGGetText(1632, vbNullString, strRow) 'Debe indicar un lote (1)
            Exit Function
          End If
        End If
    End Select
  Next
  
  ' Si lleva numero de serie valido que
  ' la cantidad indicada sea la misma
  ' que en la coleccion de numeros de serie
  '
  If bLlevaNroSerie And m_bShowStockData Then
  
    Dim PrId As Long
    
    PrId = pCell(Row, KI_PR_ID).id
  
    If Not NroSerieValidateCount(Row, _
                                 KI_GRUPO, _
                                 RowIndex, _
                                 m_NrosSerie, _
                                 Cantidad, _
                                 strRow, _
                                 KI_PR_ID, _
                                 KI_CANTIDAD, _
                                 KI_NROSERIE, _
                                 PrId, _
                                 pGetDeplId(), _
                                 False) Then
      Exit Function
    End If
  End If
  
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
  
  ' DATADD
  If m_UserCfg.ShowDataAddInVentas Then
    AbmGen.SetHeightToDocWithDescrip
  End If
  
  m_ObjAbm.Properties.Clear
  
  With m_ObjAbm.Tabs
      
    .Clear
    
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
    
    With .Add(Nothing)
      .Index = 1
      .Name = LNGGetText(1566, vbNullString) 'Adicionales
    End With
  
    With .Add(Nothing)
      .Index = 2
      .Name = LNGGetText(1050, vbNullString) 'Transporte
    End With
  
  End With
  
  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, cscDocId)
      .PropertyType = cspHelp
      .Table = CSDocumento2.CSDocumento
      .Name = LNGGetText(1567, vbNullString) 'Documento
      .Key = K_DOC_ID
      
      If m_doc_id <> csNO_ID Then
        .HelpId = m_doc_id
        .Value = m_Documento
      Else
        ' Preferencias del usuario
        '
        .HelpId = m_UserCfg.DocRvId
        .Value = m_UserCfg.DocRvNombre
        
        bValidateDocDefault = .HelpId <> csNO_ID
      End If
      
      .HelpFilter = "'doct_id = " & csEDT_RemitoVenta & " or " & _
                    "doct_id = " & csEDT_DevolucionRemitoVta & "'"
    End With
    
    With .Add(Nothing, csDocNumberID)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(1065, vbNullString) 'Número
      .Key = K_NUMERO
      .Value = m_Numero
      .Enabled = False
    End With
    
    With .Add(Nothing, csDocEstateID)
      .PropertyType = cspText
      .Name = LNGGetText(1568, vbNullString) 'Estado
      .Key = K_EST_ID
      .Value = m_Estado
      .Enabled = False
    End With
    
    With .Add(Nothing, cscRvFecha)
      .PropertyType = cspDate
      .Name = LNGGetText(1569, vbNullString) 'Fecha
      .LeftLabel = -580
      .Left = 700
      .Key = K_FECHA
      .Value = m_Fecha
    End With
    
    With .Add(Nothing, cscRvFechaentrega)
      .PropertyType = cspDate
      .Name = LNGGetText(1570, vbNullString) 'Entrega
      .Key = K_FECHAENTREGA
      .Value = m_Fechaentrega
    End With
    
    With .Add(Nothing, cscCliId)
      .PropertyType = cspHelp
      .Table = csCliente
      .TopFromProperty = cscRvFecha
      .Left = 2700
      .LeftLabel = -580
      .Name = LNGGetText(1150, vbNullString) 'Cliente
      .Key = K_CLI_ID
      .HelpId = m_cli_id
      .Value = m_cliente
      AbmGen.NewKeyPropFocus = cscCliId
      
      ' CLI-WIDTH
      .Width = 5450
    End With
    
    With .Add(Nothing, cscRvNrodoc)
      .PropertyType = cspText
      .Name = LNGGetText(1065, vbNullString) 'Número
      .Size = 50
      .Key = K_NRODOC
      .Value = m_Nrodoc
      .TextMask = m_TaMascara
      .TextAlign = vbRightJustify
    End With
    
    With .Add(Nothing, cscCpgId)
      .PropertyType = cspHelp
      .Table = csCondicionPago
      .Name = LNGGetText(1571, vbNullString) 'Cond. pago
      .Key = K_CPG_ID
      .HelpId = m_cpg_id
      .Value = m_CondicionPago
    
      ' CLI-WIDTH
      .TopFromProperty = cscRvFecha
      .Left = 9400
      .LeftLabel = -1200
    End With
    
    With .Add(Nothing, cscRvCotizacion)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1650, vbNullString) 'Cotiz.
      .Format = m_GeneralConfig.FormatDecCotizacion
      .Key = K_COTIZACION
      .Value = m_Cotizacion
      .Width = 1000
    
      ' CLI-WIDTH
      .TopFromProperty = cscRvFecha
      .TopToPrevious = 440
      .Left = 5900
      .LeftLabel = -600
    End With
    
    With .Add(Nothing, cscRvDescuento1)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .LeftLabel = -600
      .Name = LNGGetText(1573, vbNullString) 'Desc. 1
      .Key = K_DESCUENTO1
      .Value = m_Descuento1
      .Width = 1000
    End With
    
    With .Add(Nothing, cscRvDescuento2)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .TopFromProperty = cscRvDescuento1
      .Left = 7150
      .LeftLabel = -150
      .Name = "2"
      .Key = K_DESCUENTO2
      .Value = m_Descuento2
      .Width = 1000
    End With
    
    With .Add(Nothing, cscDeplIdOrigen)
      .PropertyType = cspHelp
      .Left = 5880
      .LeftLabel = -800
      .Table = csDepositoLogico
      .Name = LNGGetText(1574, vbNullString) 'Deposito
      .Key = K_DEPL_ID
      
      If m_depl_id <> csNO_ID Or Not m_bShowStockData Then
        .HelpId = m_depl_id
        .Value = m_Deposito
      Else
        ' Preferencias del usuario
        '
        .HelpId = m_UserCfg.DeplId
        .Value = m_UserCfg.DeplNombre
      End If
      
      .Enabled = m_bShowStockData
    End With
        
    With .Add(Nothing, cscLpId)
      .PropertyType = cspHelp
      .Table = csListaPrecio
      .Name = LNGGetText(1397, vbNullString) 'Lista de Precios
      .HelpFilter = GetListaPrecioGetXCliente(m_doc_id, m_cli_id)
      .Key = K_LP_ID
      .HelpId = m_Lp_id
      .Value = m_ListaPrecio
    
      ' CLI-WIDTH
      .TopFromProperty = cscCpgId
      .TopToPrevious = 440
      .LeftFromProperty = cscCpgId
      .LeftLabel = -1200
    End With
    
    With .Add(Nothing, cscVenId)
      .PropertyType = cspHelp
      .Table = csVendedores
      .Name = LNGGetText(1510, vbNullString) 'Vendedor
      .Key = K_VEN_ID
      .HelpId = m_ven_id
      .Value = m_vendedor
    End With
    
    With .Add(Nothing, cscSucId)
      .PropertyType = cspHelp
      .Table = csSucursal
      .Name = LNGGetText(1281, vbNullString) 'Sucursal
      .Key = K_SUC_ID
      .HelpId = m_suc_id
      .Value = m_Sucursal
    End With
    
    With .Add(Nothing, cscRvDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = LNGGetText(1211, vbNullString) 'Observ.
      .LeftLabel = -600
      .Size = 5000
      .Key = K_DESCRIP
      .Value = m_Descrip
      .LeftFromProperty = cscRvFecha
      .TopFromProperty = cscRvNrodoc
      .Width = 4275
      .Height = 800
      .TopToPrevious = 440
    End With
    
    With .Add(Nothing, cscClisId)
      .PropertyType = cspHelp
      .Table = csSucursalCliente
      .Name = LNGGetText(1576, vbNullString) 'Sucursal del Cliente
      .Key = K_CLIS_ID
      .Value = m_ClienteSucursal
      .HelpId = m_clis_id
      .HelpFilter = GetHelpFilterCliSuc(m_cli_id)
      .TabIndex = 1
      .Left = 1500
    End With
    
    With .Add(Nothing, cscProIdOrigen)
      .PropertyType = cspHelp
      .Table = csProvincia
      .Name = LNGGetText(1577, vbNullString) 'Pcia. Origen
      .Key = K_PRO_ID_ORIGEN
      .HelpId = m_pro_id_origen
      .Value = m_ProOrigen
      .LeftLabel = -1300
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscProIdDestino)
      .PropertyType = cspHelp
      .Table = csProvincia
      .Name = LNGGetText(1578, vbNullString) 'Pcia. Destino
      .Key = K_PRO_ID_DESTINO
      .HelpId = m_pro_id_destino
      .Value = m_ProDestino
      .LeftLabel = -1300
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscCcosId)
      .PropertyType = cspHelp
      .Table = csCentroCosto
      .Name = LNGGetText(1057, vbNullString) 'Centro de Costo
      .Key = K_CCOS_ID
      .HelpId = m_ccos_id
      .Value = m_CentroCosto
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscRvOrdenCompra)
      .PropertyType = cspText
      .Name = LNGGetText(1924, vbNullString) 'Orden de Compra
      .Key = K_ORDENCOMPRA
      .Value = m_OrdenCompra
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscLgjId)
      .PropertyType = cspHelp
      .Table = csLegajo
      .Name = LNGGetText(1575, vbNullString) 'Legajo
      .Key = K_LGJ_ID
      .HelpId = m_lgj_id
      .Value = m_Legajo
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscRvRetiro)
      .PropertyType = cspText
      .SubType = cspTextButtonEx
      .Name = LNGGetText(2883, vbNullString) 'Retirado Por
      .Key = K_RETIRO
      .Value = m_retiro
      .LeftLabel = -1300
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscRvGuia)
      .PropertyType = cspText
      .SubType = cspTextButtonEx
      .Name = LNGGetText(2884, vbNullString) 'Guia de Entrega
      .Key = K_GUIA
      .Value = m_guia
      .LeftLabel = -1300
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscLdId)
      .PropertyType = cspHelp
      .Table = csListaDescuento
      .Name = LNGGetText(1398, vbNullString) 'Lista de Descuentos
      .HelpFilter = GetListaDescGetXCliente(m_doc_id, m_cli_id)
      .Key = K_LD_ID
      .HelpId = m_Ld_id
      .Value = m_ListaDescuento
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscTransId)
      .PropertyType = cspHelp
      .Table = csTransporte
      .Name = LNGGetText(1050, vbNullString) 'Transporte
      .Key = K_TRANS_ID
      .Value = m_Transporte
      .HelpId = m_trans_id
      .TabIndex = 2
    End With
    
    With .Add(Nothing, cscChofId)
      .PropertyType = cspHelp
      .Table = csChofer
      .Name = LNGGetText(1051, vbNullString) 'Chofer
      .Key = K_CHOF_ID
      .Value = m_Chofer
      .HelpId = m_chof_id
      .HelpFilter = GetHelpTransporte(m_trans_id)
      .TabIndex = 2
    End With
    
    With .Add(Nothing, cscCamId)
      .PropertyType = cspHelp
      .Table = csCamion
      .Name = LNGGetText(3489, vbNullString) 'Camion
      .Key = K_CAM_ID
      .Value = m_Camion
      .HelpId = m_cam_id
      .HelpFilter = GetHelpTransporte(m_trans_id)
      .TopFromProperty = cscTransId
      .Left = 6000
      .TabIndex = 2
    End With
    
    With .Add(Nothing, cscCamIdSemi)
      .PropertyType = cspHelp
      .Table = csCamionSemi
      .Name = LNGGetText(3493, vbNullString) 'Semi
      .Key = K_CAM_ID_SEMI
      .Value = m_Semi
      .HelpId = m_cam_id_semi
      .HelpFilter = GetHelpTransporte(m_trans_id)
      .TabIndex = 2
    End With
  
    With .Add(Nothing, cscRvDestinatario)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = LNGGetText(3494, vbNullString) 'Destinatario
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
        .TopFromProperty = cscRvDescrip
        .TopToPrevious = 860
        .LeftFromProperty = cscRvDescrip
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

      .Left = 9210
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

      .Left = 9220
      .Height = 300
    End With
  
    Dim iProp As cIABMProperty
    Dim oProp As cABMProperty
    Set iProp = .Add(Nothing, c_HideCols)
    Set oProp = iProp
    With iProp
      .PropertyType = cspCheck
      .Name = LNGGetText(3901, vbNullString)  'Ocultar Columnas
      .Key = K_HIDECOLS
      .Value = CInt(CSKernelClient2.GetRegistry(csInterface, c_HideColsRv, 1))
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

      .Left = 11120
      .LeftLabel = -1500
    End With
    oProp.IsEditProperty = False
    '
    ' HIDECOLS - fin
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  pSetShowStockData True
  
  With m_Items.Tabs
    
    .Clear
  
    With .Add(Nothing)
      .Index = 0
      .Name = LNGGetText(1371, vbNullString) 'Items
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
      .Name = c_Items
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
  
    With .Add(Nothing, cscRvSubtotal)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1579, vbNullString) 'Sub Total
      .Key = K_SUBTOTAL
      .Value = m_SubTotal
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscRvImportedesc1)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1573, vbNullString) 'Desc. 1
      .Key = K_IMPORTEDESC1
      .Value = m_ImporteDesc1
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscRvImportedesc2)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1580, vbNullString) 'Desc. 2
      .Key = K_IMPORTEDESC2
      .Value = m_ImporteDesc2
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscRvNeto)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1581, vbNullString) 'Neto
      .Key = K_NETO
      .Value = m_Neto
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscRvIvari)
      .PropertyType = cspNumeric
      .Name = LNGGetText(1582, vbNullString) 'IVA RI
      .SubType = cspMoney
      .Key = K_IVARI
      .Value = m_Ivari
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscRvIvarni)
      .PropertyType = cspNumeric
      .Name = LNGGetText(1583, vbNullString) 'IVA RNI
      .SubType = cspMoney
      .Key = K_IVARNI
      .Value = m_Ivarni
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscRvTotal)
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .Name = LNGGetText(1584, vbNullString) 'Total
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
  
  pShowCotizacion

  ' DATADD
  ShowDataAddCliente m_UserCfg.ShowDataAddInVentas, _
                     m_ObjAbm
  
  AbmGen.SetIconFormDoc 3

  'c8f6c1
  If m_UserCfg.UsarColoresEnDocumentos Then
    AbmGen.SetBakcColorTagMain RGB(&HC8, &HF6, &HC1)
  End If

  LoadCollection = True
End Function

' Cotizacion
Private Function pGetCotizacion() As cIABMProperty
  Set pGetCotizacion = m_ObjAbm.Properties.Item(cscRvCotizacion)
End Function

Private Sub pShowCotizacion()
  Dim MonId   As Long
  Dim dDate   As Variant
  Dim iProp   As cIABMProperty
  
  If m_Id = csNO_ID Then
    If m_LastDoc = csNO_ID Then Exit Sub
    If Not gDB.GetData(csTDocumento, cscDocId, m_LastDoc, cscMonId, MonId) Then Exit Sub
  Else
    MonId = m_mon_id
  End If
  
  Set iProp = pGetCotizacion()
  iProp.Visible = MonId <> GetMonedaDefault
  
  If m_lastMonIdCotizacion <> MonId Or iProp.Value = 0 Then
    dDate = pGetFecha()
    If Not IsDate(dDate) Then dDate = Date
    iProp.Value = GetCotizacion(MonId, dDate)
    m_lastFecha = dDate
    m_lastMonIdCotizacion = MonId
  End If
  
  m_ObjAbm.ShowValue iProp
End Sub

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim PrId    As Long
  Dim rs      As ADODB.Recordset
  Dim oCol    As cABMGridColumn
  Dim iCol    As cIABMGridColumn
  
  ' HIDECOLS
  '
  Dim bColVisible As Boolean
  bColVisible = Val(m_ObjAbm.Properties.Item(c_HideCols).Value) = 0
  
  sqlstmt = "sp_DocRemitoVentaGetItems " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_RVI_ID
      End With
        
      Set iCol = .Add(Nothing)
      Set oCol = iCol
      With iCol
        .Name = LNGGetText(1367, vbNullString)  'Articulo
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
        .Name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 1200
        .Key = KI_DESCRIP
      End With
        
      With .Add(Nothing)
        .Name = LNGGetText(1374, vbNullString) 'Cantidad
        .Format = m_GeneralConfig.FormatDecCantidad
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KI_CANTIDAD
        
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Value = 1
      End With
        
      With .Add(Nothing)
        .Name = LNGGetText(1639, vbNullString) 'Nro. Serie
        .PropertyType = cspText
        .SubType = cspTextButton
        .Width = 3000
        .Key = KI_NROSERIE
        .Visible = m_bShowStockData ' HIDECOLS
      End With
      
      ' Lote
      '
      With .Add(Nothing, cscStlId)
        .Name = LNGGetText(1640, vbNullString) 'Lote
        .PropertyType = cspHelp
        .Table = csStockLote
        .Width = 2000
        .Key = KI_STL_ID
        .Visible = m_bShowStockData ' HIDECOLS
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1585, vbNullString) 'Descuento
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .Key = KI_DESCUENTO
        .Enabled = False
        .Visible = bColVisible ' HIDECOLS
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1165, vbNullString) 'Unidad
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_UNIDAD
        .Enabled = False
        .Visible = bColVisible ' HIDECOLS
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1587, vbNullString) 'Precio (LP)
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .Key = KI_PRECIO_LP
        .Enabled = False
        .Visible = bColVisible ' HIDECOLS
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1586, vbNullString) 'Precio
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1200
        .Format = m_GeneralConfig.FormatDecImporte
        .Key = KI_PRECIO_USR
        .Enabled = SecurityCanAccessSilent(csPreVtaEditPriceRem)
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1588, vbNullString) 'Precio c/desc.
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1200
        .Format = m_GeneralConfig.FormatDecImporte
        .Key = KI_PRECIO
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1581, vbNullString) 'Neto
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .Key = KI_NETO
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1582, vbNullString) 'IVA RI
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .Key = KI_IVARI
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1583, vbNullString) 'IVA RNI
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .Key = KI_IVARNI
        .Enabled = False
        .Visible = bColVisible ' HIDECOLS
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1228, vbNullString) 'Importe
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
        .Name = LNGGetText(1057, vbNullString) 'Centro de Costo
        .PropertyType = cspHelp
        .Table = csCentroCosto
        .Width = 1800
        .Key = KI_CCOS_ID
        .Visible = bColVisible ' HIDECOLS
      End With
      
      ' Lote
      '
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PR_LLEVALOTE
      End With
      
      ' Lote Fifo
      '
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PR_LOTEFIFO
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PR_LLEVANROSERIE
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_ES_KIT
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_GRUPO
      End With
    End With
  
    With .Rows
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscRviId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRviId)
            .Key = KI_RVI_ID
          End With
            
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrNombreVenta)
            .id = gDB.ValField(rs.fields, cscPrId)
            .Key = KI_PR_ID
          End With
            
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRviDescrip)
            .Key = KI_DESCRIP
          End With
            
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRviCantidad)
            .Key = KI_CANTIDAD
          End With
            
          With .Add(Nothing)
            .Value = vbNullString
            .Key = KI_NROSERIE
          End With
            
          ' Lote
          '
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscStlCodigo)
            .id = gDB.ValField(rs.fields, cscStlId)
            .Key = KI_STL_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRviDescuento)
            .Key = KI_DESCUENTO
          End With
            
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscUnNombre)
            .Key = KI_UNIDAD
          End With
            
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRviPrecioLista)
            .Key = KI_PRECIO_LP
          End With
            
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRviPrecioUsr)
            .Key = KI_PRECIO_USR
          End With
            
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRviPrecio)
            .Key = KI_PRECIO
          End With
            
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRviNeto)
            .Key = KI_NETO
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRviIvari)
            .Key = KI_IVARI
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRviIvarni)
            .Key = KI_IVARNI
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRviImporte)
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
            
          ' Lote
          '
          With .Add(Nothing)
            .id = gDB.ValField(rs.fields, cscPrLlevaNroLote)
            .Key = KI_PR_LLEVALOTE
          End With
          
          ' Lote Fifo
          '
          With .Add(Nothing)
            .id = gDB.ValField(rs.fields, cscPrLoteFifo)
            .Key = KI_PR_LOTEFIFO
          End With
          
          With .Add(Nothing)
            .id = gDB.ValField(rs.fields, cscPrLlevaNroSerie)
            .Key = KI_PR_LLEVANROSERIE
          End With
        
          With .Add(Nothing)
            .id = gDB.ValField(rs.fields, cscPrEskit)
            .Key = KI_ES_KIT
          End With
            
          With .Add(Nothing)
            .id = gDB.ValField(rs.fields, cscRviId)
            .Key = KI_GRUPO
          End With
        
        End With
        
        rs.MoveNext
      Wend
    End With
  End With

  '//////////////////////////////////////////////////
  ' Numeros de Serie
  '//////////////////////////////////////////////////
  
  Dim NroSerie  As cProductoSerieType
  Dim CurGroup  As Long
  Dim Coll      As Collection
  Dim NrosSerie As String
    
  CollClear m_NrosSerie
  
  Set rs = rs.NextRecordset
  
  While Not rs.EOF
    
    ' Si cambie de grupo
    If CurGroup <> gDB.ValField(rs.fields, cscRviId) Then
    
      pSetNrosSerieInRow CurGroup, NrosSerie
      NrosSerie = vbNullString
    
      CurGroup = gDB.ValField(rs.fields, cscRviId)
      Set Coll = New Collection
      m_NrosSerie.Add Coll, GetKey(CurGroup)
    End If
    
    ' Guardo el numero de serie
    Set NroSerie = New cProductoSerieType
    With NroSerie
      .Codigo = gDB.ValField(rs.fields, cscPrnsCodigo)
      .Descrip = gDB.ValField(rs.fields, cscPrnsDescrip)
      .FechaVto = gDB.ValField(rs.fields, cscPrnsFechavto)
      .prns_id = gDB.ValField(rs.fields, cscPrnsId)
      .pr_id_item = gDB.ValField(rs.fields, cscPrId)
      .KitItem = gDB.ValField(rs.fields, cscPrNombreCompra)
    
      NrosSerie = NrosSerie & .Codigo & ","
    End With
    
    ' Lo agrego a la bolsa
    Coll.Add NroSerie, GetKey(NroSerie.prns_id)
    
    rs.MoveNext
  Wend
  
  pSetNrosSerieInRow CurGroup, NrosSerie
  NrosSerie = vbNullString
  
  '//////////////////////////////////////////////////
  ' Kit
  '//////////////////////////////////////////////////
  CollClear m_CollKitInfo
  
  Set rs = rs.NextRecordset
  
  While Not rs.EOF
    
    PrId = gDB.ValField(rs.fields, cscPrId)
    Set Coll = GetCollKitInfoXPrId(PrId, m_CollKitInfo)
    
    PrId = gDB.ValField(rs.fields, cscPrIdItem)
    
    With GetKitInfoItem(Coll, PrId)
      .pr_id = PrId
      .nombre = gDB.ValField(rs.fields, cscPrNombreCompra)
      .Cantidad = gDB.ValField(rs.fields, "cantidad")
      .LlevaNroSerie = gDB.ValField(rs.fields, cscPrLlevaNroSerie)
    End With
    rs.MoveNext
  Wend
  
  pLoadItems = True
End Function

Private Function Load(ByVal id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "sp_DocRemitoVentaGet " & EmpId & "," & id & "," & gDB.UserId
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscRvId)
    m_Numero = gDB.ValField(rs.fields, cscRvNumero)
    m_Nrodoc = gDB.ValField(rs.fields, cscRvNrodoc)
    m_Descrip = gDB.ValField(rs.fields, cscRvDescrip)
    m_Fecha = gDB.ValField(rs.fields, cscRvFecha)
    m_Fechaentrega = gDB.ValField(rs.fields, cscRvFechaentrega)
    m_Neto = gDB.ValField(rs.fields, cscRvNeto)
    m_Ivari = gDB.ValField(rs.fields, cscRvIvari)
    m_Ivarni = gDB.ValField(rs.fields, cscRvIvarni)
    m_Total = gDB.ValField(rs.fields, cscRvTotal)
    m_SubTotal = gDB.ValField(rs.fields, cscRvSubtotal)
    m_Descuento1 = gDB.ValField(rs.fields, cscRvDescuento1)
    m_Descuento2 = gDB.ValField(rs.fields, cscRvDescuento2)
    m_ImporteDesc1 = gDB.ValField(rs.fields, cscRvImportedesc1)
    m_ImporteDesc2 = gDB.ValField(rs.fields, cscRvImportedesc2)
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
    m_Firmado = gDB.ValField(rs.fields, cscRvFirmado)
    m_Cotizacion = gDB.ValField(rs.fields, cscRvCotizacion)

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

    m_clis_id = gDB.ValField(rs.fields, cscClisId)
    m_ClienteSucursal = gDB.ValField(rs.fields, cscClisNombre)

    m_chof_id = gDB.ValField(rs.fields, cscChofId)
    m_Chofer = gDB.ValField(rs.fields, cscChofNombre)

    m_cam_id = gDB.ValField(rs.fields, cscCamId)
    m_Camion = gDB.ValField(rs.fields, cscCamPatente)

    m_cam_id_semi = gDB.ValField(rs.fields, cscCamIdSemi)
    m_Semi = gDB.ValField(rs.fields, cscCamPatentesemi)

    m_DocEditable = gDB.ValField(rs.fields, cscDocEditable)
    m_DocEditMsg = gDB.ValField(rs.fields, cscDoceditMsg)

    m_retiro = gDB.ValField(rs.fields, cscRvRetiro)
    m_guia = gDB.ValField(rs.fields, cscRvGuia)
    m_Destinatario = gDB.ValField(rs.fields, cscRvDestinatario)

    m_OrdenCompra = gDB.ValField(rs.fields, cscRvOrdenCompra)

    ' Lote
    '
    m_depf_id = gDB.ValField(rs.fields, cscDepfId)
    m_depl_id = gDB.ValField(rs.fields, cscDeplId)
    m_Deposito = gDB.ValField(rs.fields, cscDeplNombre)

    ' Para ver documentos auxiliares
    '
    m_st_id = gDB.ValField(rs.fields, cscStId)
    m_st_id_consumo = gDB.ValField(rs.fields, cscStIdConsumo)
    m_st_id_consumoTemp = gDB.ValField(rs.fields, cscStIdConsumoTemp)
    m_st_id_producido = gDB.ValField(rs.fields, cscStIdProducido)

    m_TaPropuesto = gDB.ValField(rs.fields, cscTa_Propuesto)
    m_TaMascara = gDB.ValField(rs.fields, cscTa_Mascara)

    m_bIva = gDB.ValField(rs.fields, cscbIvaRi)
    m_bIvaRni = gDB.ValField(rs.fields, cscbIvaRni)
    
    m_LastDoc = m_doc_id
    m_LastDoctId = m_Doct_id ' nrs devolucion
    m_LastCli = m_cli_id
    m_LastTrans = m_trans_id
    m_LastChof = m_chof_id
    m_LastDocName = m_Documento
    m_LastCliName = m_cliente

    m_mon_id = gDB.ValField(rs.fields, cscMonId)
    m_lastMonIdCotizacion = m_mon_id
    m_lastFecha = m_Fecha
  
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
    m_cliente = vbNullString
    m_ccos_id = csNO_ID
    m_CentroCosto = vbNullString
    m_doc_id = csNO_ID
    m_Documento = vbNullString
    m_Doct_id = csNO_ID
    m_Lp_id = csNO_ID
    m_Ld_id = csNO_ID
    m_cpg_id = csNO_ID
    m_CondicionPago = vbNullString
    m_ListaPrecio = vbNullString
    m_ListaDescuento = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_est_id = csNO_ID
    m_Estado = vbNullString
    m_suc_id = User.suc_id
    m_Sucursal = User.Sucursal
    m_Firmado = False
    m_Cotizacion = 0
  
    m_retiro = vbNullString
    m_guia = vbNullString
    m_Destinatario = vbNullString
    m_OrdenCompra = vbNullString
  
    m_clis_id = csNO_ID
    m_ClienteSucursal = vbNullString
    
    m_chof_id = csNO_ID
    m_Chofer = vbNullString
    
    m_cam_id = csNO_ID
    m_Camion = vbNullString
    
    m_cam_id_semi = csNO_ID
    m_Semi = vbNullString
    
    m_ven_id = csNO_ID
    m_vendedor = vbNullString
    m_lgj_id = csNO_ID
    m_Legajo = vbNullString
    m_pro_id_origen = csNO_ID
    m_ProOrigen = vbNullString
    m_pro_id_destino = csNO_ID
    m_ProDestino = vbNullString
    m_trans_id = csNO_ID
    m_Transporte = vbNullString
  
    ' Lote
    '
    m_depf_id = csNO_ID
    m_depl_id = csNO_ID
    m_Deposito = vbNullString
    
    ' Para ver documentos auxiliares
    '
    m_st_id = csNO_ID
    m_st_id_consumo = csNO_ID
    m_st_id_consumoTemp = csNO_ID
    m_st_id_producido = csNO_ID
    
    m_TaPropuesto = False
    m_TaMascara = vbNullString
  
    m_doc_id = m_LastDoc
    m_Doct_id = m_LastDoctId ' nrs devolucion
    m_cli_id = m_LastCli
    m_cliente = m_LastCliName
    m_Documento = m_LastDocName
  
    m_LastTrans = csNO_ID
    m_LastChof = csNO_ID
  
    m_bIvaRni = False
    m_bIva = False
    
    m_mon_id = csNO_ID
    m_lastMonIdCotizacion = csNO_ID
    m_lastFecha = csNoDate
    
    ' Cotizacion
    If m_doc_id <> csNO_ID Then
      m_Cotizacion = DocGetCotizacion(m_doc_id, m_Fecha)
    End If
    
    DocEditableGet m_doc_id, m_DocEditable, m_DocEditMsg, csPreVtaNewRemito
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

Private Function cIMenuClient_Initialize(f As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  
  Dim str_1589 As String
  
  str_1589 = LNGGetText(1589, vbNullString) '&Ventas
  
  Set m_Host = Host
  
  m_Host.Server.AddMenu str_1589, csMenuEnum.csMenuVentas, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(1719, vbNullString), csPreVtaListRemito, str_1589, 0, True, False, False, False, False, Me
                        '&Remitos de Venta
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal id As Long) As Variant
#If PREPROC_SFS Then
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", "CSVenta2.cRemitoVenta", "CSABMInterface2.CABMGenericListDoc", "CSVenta2.cRemitoVentaListDoc", Me, LNGGetText(1718, vbNullString), 0
#Else
  m_Host.MenuListDocClick "CSABMInterface2.CABMGenericDocEx", "CSVenta2.cRemitoVenta", "CSABMInterface2.CABMGenericListDoc", "CSVenta2.cRemitoVentaListDoc", Me, LNGGetText(1718, vbNullString), 0
                                                                                                                                                                  'Remito de venta
#End If
End Function

Private Function pSaveItems(ByVal id As Long) As Boolean
  
  ' Generales
  '
  Dim register  As cRegister
  Dim iOrden    As Long
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  
  ' Para numeros de serie
  '
  Dim iOrden2     As Long
  Dim Grupo       As Long
  Dim PrId        As Long
  
  For Each Row In m_Items.Properties(c_Items).Grid.Rows
  
    Set register = New cRegister
    With register
      .fieldId = cscRviTMPId
      .Table = csTRemitoVentaItemTMP
      .id = csNew
      
      With .fields
    
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_RVI_ID
              If m_Copy Then
                .Add2 cscRviId, csNew, csInteger
              Else
                .Add2 cscRviId, Val(Cell.Value), csInteger
              End If
            Case KI_CANTIDAD
              .Add2 cscRviCantidad, Cell.Value, csDouble
            Case KI_DESCRIP
              .Add2 cscRviDescrip, Cell.Value, csText
            Case KI_PRECIO
              .Add2 cscRviPrecio, Cell.Value, csCurrency
            Case KI_PRECIO_LP
              .Add2 cscRviPrecioLista, Cell.Value, csCurrency
            Case KI_PRECIO_USR
              .Add2 cscRviPrecioUsr, Cell.Value, csCurrency
            Case KI_DESCUENTO
              .Add2 cscRviDescuento, Cell.Value, csText
            Case KI_IMPORTE
              .Add2 cscRviImporte, Cell.Value, csCurrency
            Case KI_NETO
              .Add2 cscRviNeto, Cell.Value, csCurrency
            Case KI_IVARI
              If m_bIva Then
                .Add2 cscRviIvari, Cell.Value, csCurrency
              End If
            Case KI_IVARNI
              If m_bIvaRni Then
                .Add2 cscRviIvarni, Cell.Value, csCurrency
              End If
            Case KI_IVARIPercent
              .Add2 cscRviIvariporc, Cell.Value, csDouble
            Case KI_IVARNIPercent
              .Add2 cscRviIvarniporc, Cell.Value, csDouble
            Case KI_PR_ID
              PrId = Cell.id
              .Add2 cscPrId, PrId, csId
            Case KI_CCOS_ID
              .Add2 cscCcosId, Cell.id, csId
            Case KI_GRUPO
              Grupo = Cell.id
          
            ' Lote
            '
            Case KI_STL_ID
              .Add2 cscStlId, Cell.id, csId
          End Select
        Next
      
        iOrden = iOrden + 1
      
        .Add2 cscRviOrden, iOrden, csInteger
        .Add2 cscRvTMPId, id, csId
      
        .HaveLastUpdate = False
        .HaveWhoModify = False
      
      End With
      
      If Not gDB.Save(register, , _
                      "pSaveItems", _
                      C_Module, _
                      c_ErrorSave) Then Exit Function
    
      ' Si es nuevo se usa el orden
      If Grupo = 0 Then Grupo = iOrden * -1
      If Not pSaveItemNroSerie(Row, _
                               iOrden2, _
                               PrId, _
                               id, _
                               .id, _
                               Grupo) Then Exit Function
    End With
  Next
  
  Dim sqlstmt As String
  
  If m_ItemsDeleted <> vbNullString And m_Id <> csNO_ID And Not m_Copy Then
  
    Dim vDeletes As Variant
    Dim i As Long
    
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    vDeletes = Split(m_ItemsDeleted, ",")
    
    For i = 0 To UBound(vDeletes)
    
      Set register = New cRegister
      With register
        .fieldId = cscRvibTMPId
        .Table = csTRemitoVentaItemBorradoTMP
        .id = csNew
      
        With .fields
          .Add2 cscRviId, Val(vDeletes(i)), csInteger
          .Add2 cscRvId, m_Id, csId
          .Add2 cscRvTMPId, id, csId
      
          .HaveLastUpdate = False
          .HaveWhoModify = False
        End With
      End With
      
      If Not gDB.Save(register, , _
                      "pSaveItems", _
                      C_Module, _
                      c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveItems = True
End Function

' Reglas del Objeto de Negocios
Private Function pDocDesdePedido() As Boolean
  Dim Doc     As cDocumento
  Dim rtn     As Boolean
  Dim DocId   As Long
  
  ' Si todavia no se cargo el form no se que
  ' documento es, asi que no puede ser sobre pedido
  If m_ObjAbm.Properties.Item(cscDocId) Is Nothing Then Exit Function
  
  DocId = m_ObjAbm.Properties.Item(cscDocId).HelpId
  
  ' Si no hay un documento activo no se hace nada
  If DocId = csNO_ID Then Exit Function
  
  Set Doc = New cDocumento
  
  pDocDesdePedido = Doc.GetData(DocId, cscDocRvDesdePv, csBoolean)
End Function

Private Function pDocDescargaBOM() As Boolean
  Dim Doc     As cDocumento
  Dim rtn     As Boolean
  Dim DocId   As Long
  
  ' Si todavia no se cargo el form no se que
  ' documento es, asi que no puede ser sobre pedido
  If m_ObjAbm.Properties.Item(cscDocId) Is Nothing Then Exit Function
  
  DocId = m_ObjAbm.Properties.Item(cscDocId).HelpId
  
  ' Si no hay un documento activo no se hace nada
  If DocId = csNO_ID Then Exit Function
  
  Set Doc = New cDocumento
  
  pDocDescargaBOM = Doc.GetData(DocId, cscDocRvBom, csBoolean)
End Function

Private Function pDocDesdeOrden() As Boolean
  Dim Doc     As cDocumento
  Dim rtn     As Boolean
  Dim DocId   As Long
  
  ' Si todavia no se cargo el form no se que
  ' documento es, asi que no puede ser sobre pedido
  If m_ObjAbm.Properties.Item(cscDocId) Is Nothing Then Exit Function
  
  DocId = m_ObjAbm.Properties.Item(cscDocId).HelpId
  
  ' Si no hay un documento activo no se hace nada
  If DocId = csNO_ID Then Exit Function
  
  Set Doc = New cDocumento
  
  pDocDesdeOrden = Doc.GetData(DocId, cscDocRvDesdeOs, csBoolean)
End Function

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
    .Item(cscRvSubtotal).Value = Neto
    
    Desc1 = m_ObjAbm.Properties(cscRvDescuento1).Value
    Desc2 = m_ObjAbm.Properties(cscRvDescuento2).Value
    
    IvaRi = IvaRi - (IvaRi * Desc1 / 100)
    IvaRni = IvaRni - (IvaRni * Desc1 / 100)
    
    IvaRi = IvaRi - (IvaRi * Desc2 / 100)
    IvaRni = IvaRni - (IvaRni * Desc2 / 100)
    
    Desc1 = Neto * Desc1 / 100
    .Item(cscRvImportedesc1).Value = Desc1
    
    Neto = Neto - Desc1
    
    Desc2 = Neto * Desc2 / 100
    .Item(cscRvImportedesc2).Value = Desc2
    
    Neto = Neto - Desc2
    
    .Item(cscRvNeto).Value = Neto
    .Item(cscRvIvari).Value = IvaRi
    .Item(cscRvIvarni).Value = IvaRni
    .Item(cscRvTotal).Value = Neto + IvaRni + IvaRi
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
        'El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de ventas para el iva responsable inscripto
    Exit Sub
  End If
  
  If ti_rni = 0 Then
    MsgWarning LNGGetText(1598, vbNullString, pr_nombre)
        'El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de ventas para el iva responsable no inscripto
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

' Reglas del Objeto de Negocios
Private Sub pSetDataProducto(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                             ByVal pr_id As Long)
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim bEsKit  As Boolean
  
  Dim bChanged As Boolean
  
  bChanged = pr_id <> pCell(Row, KI_PR_ID).id
  
  sqlstmt = "sp_StockProductoGetData " & pr_id & "," & pGetCliId() & ",Null"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
    bEsKit = gDB.ValField(rs.fields, cscPrEskit)
    
    pCell(Row, KI_UNIDAD).Value = gDB.ValField(rs.fields, "unidadVenta")
    
    With pCell(Row, KI_CCOS_ID)
      .Value = gDB.ValField(rs.fields, "centro_costo_venta")
      .id = gDB.ValField(rs.fields, cscCcosIdVenta)
    End With
    
    ' Si el documento no mueve stock no se exigen los numeros de serie
    '
    If m_bShowStockData Then
      pCell(Row, KI_PR_LLEVANROSERIE).id = gDB.ValField(rs.fields, cscPrLlevaNroSerie)
      
      ' Lote
      '
      pCell(Row, KI_PR_LLEVALOTE).id = gDB.ValField(rs.fields, cscPrLlevaNroLote)
      
      ' Lote Fifo
      '
      pCell(Row, KI_PR_LOTEFIFO).id = gDB.ValField(rs.fields, cscPrLoteFifo)
    
    Else
      pCell(Row, KI_PR_LLEVANROSERIE).id = False
      
      ' Lote
      '
      pCell(Row, KI_PR_LLEVALOTE).id = False
    
      ' Lote Fifo
      '
      pCell(Row, KI_PR_LOTEFIFO).id = False
    End If
    
    pCell(Row, KI_ES_KIT).id = bEsKit
  
    If bEsKit Then
    
      Dim Coll    As Collection
    
      sqlstmt = "sp_StockProductoGetKitInfo " & pr_id
      If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
      
      Set Coll = GetCollKitInfoXPrId(pr_id, m_CollKitInfo)
      
      While Not rs.EOF
        pr_id = gDB.ValField(rs.fields, cscPrId)
        With GetKitInfoItem(Coll, pr_id)
          .pr_id = pr_id
          .nombre = gDB.ValField(rs.fields, cscPrNombreCompra)
          .Cantidad = gDB.ValField(rs.fields, "cantidad")
          .LlevaNroSerie = gDB.ValField(rs.fields, cscPrLlevaNroSerie)
        End With
        rs.MoveNext
      Wend
    End If
  End If
  
  ' Si cambio el producto borro los numeros de serie
  '
  If bChanged Or pCell(Row, KI_PR_LLEVANROSERIE).id = 0 Then
      
      pCell(Row, KI_NROSERIE).Value = vbNullString
      If ExistsObjectInColl(m_NrosSerie, GetKey(pCell(Row, KI_GRUPO).id)) Then
      
        m_NrosSerie.Remove GetKey(pCell(Row, KI_GRUPO).id)
      End If
  End If
End Sub

Private Sub pSetEnabled()
  Dim bState As Boolean
  
  ' Si se genera desde un pedido y es nuevo
  ' no puede editar, tiene que hacer click en
  ' nuevo y llamar al asistente
  If pDocDesdePedido And m_Id = csNO_ID Then
    bState = False
  ElseIf pDocDesdeOrden And m_Id = csNO_ID Then
    bState = False
  ElseIf m_DocEditable Then
    bState = m_ObjAbm.Properties.Item(cscDocId).HelpId <> csNO_ID
  Else
    bState = False
  End If
  
  pSetEnabledAux bState
End Sub

Private Sub pSetEnabledAux(ByVal bState As Boolean)
  Dim Prop   As cIABMProperty
  
  For Each Prop In m_ObjAbm.Properties
                                                                              ' HIDECOLS
    If Prop.Key <> K_DOC_ID And Prop.Key <> K_NUMERO And Prop.Key <> K_EST_ID And Prop.Key <> K_HIDECOLS Then
    
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
  
  If bState Then
    With m_ObjAbm.Properties
      .Item(cscDeplIdOrigen).Enabled = m_bShowStockData
    End With
  End If
  
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

  Set iProp = m_ObjAbm.Properties.Item(cscClisId)
  With iProp
    .HelpFilter = GetHelpFilterCliSuc(m_LastCli)
  End With
  
  m_ObjAbm.ShowValue iProp
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
              'Antes de poder firmar el documento debe guardarlo.
    Exit Function
  End If
  
  If m_Firmado Then
    If Not Ask(LNGGetText(1593, vbNullString), vbYes, LNGGetText(1594, vbNullString)) Then
              'El documento ya ha sido firmado desea borrar la firma, vbYes, Firmar
      Exit Function
    End If
  End If
  
  If Not Doc.Firmar(m_doc_id, us_id) Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocRemitoVentaFirmar " & m_Id & "," & us_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_est_id = gDB.ValField(rs.fields, cscEstId)
  m_Estado = gDB.ValField(rs.fields, cscEstNombre)
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties(csDocEstateID)
  
  With iProp
    .HelpId = m_est_id
    .Value = m_Estado
  End With
  
  gDB.GetData csTRemitoVenta, cscRvId, m_Id, cscRvFirmado, m_Firmado
  
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
  
  sqlstmt = "sp_DocRemitoVentaMover " & MoveTo & "," & m_Numero & "," & doc_id
  
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscRvNrodoc
    
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
    
    Set c = .Item(cscRvFecha)
    c.Value = m_Fecha
    
    Set c = .Item(cscRvFechaentrega)
    c.Value = m_Fechaentrega
    
    Set c = .Item(cscCliId)
    c.HelpId = m_cli_id
    c.Value = m_cliente
    
    Set c = .Item(csDocNumberID)
    c.Value = m_Numero
    
    Set c = .Item(csDocEstateID)
    c.Value = m_Estado
    
    Set c = .Item(cscRvNrodoc)
    c.Value = m_Nrodoc
    c.TextMask = m_TaMascara
    c.TextAlign = vbRightJustify
    
    Set c = .Item(cscRvDescuento1)
    c.Value = m_Descuento1
    
    Set c = .Item(cscRvDescuento2)
    c.Value = m_Descuento2
    
    Set c = .Item(cscDeplIdOrigen)
    If m_depl_id <> csNO_ID Or Not m_bShowStockData Then
      c.HelpId = m_depl_id
      c.Value = m_Deposito
    Else
      ' Preferencias del usuario
      '
      c.HelpId = m_UserCfg.DeplId
      c.Value = m_UserCfg.DeplNombre
      pSetStock
    End If
    
    Set c = .Item(cscCpgId)
    c.HelpId = m_cpg_id
    c.Value = m_CondicionPago
    
    Set c = .Item(cscRvCotizacion)
    c.Value = m_Cotizacion
    
    Set c = .Item(cscLpId)
    c.HelpFilter = GetListaPrecioGetXCliente(m_doc_id, m_cli_id)
    c.HelpId = m_Lp_id
    c.Value = m_ListaPrecio
    
    Set c = .Item(cscLdId)
    c.HelpFilter = GetListaDescGetXCliente(m_doc_id, m_cli_id)
    c.HelpId = m_Ld_id
    c.Value = m_ListaDescuento
    
    Set c = .Item(cscCcosId)
    c.HelpId = m_ccos_id
    c.Value = m_CentroCosto
    
    Set c = .Item(cscSucId)
    c.HelpId = m_suc_id
    c.Value = m_Sucursal
    
    Set c = .Item(cscVenId)
    c.HelpId = m_ven_id
    c.Value = m_vendedor
    
    Set c = .Item(cscRvDescrip)
    c.Value = m_Descrip
  
    Set c = .Item(cscLgjId)
    c.HelpId = m_lgj_id
    c.Value = m_Legajo
    
    Set c = .Item(cscProIdOrigen)
    c.HelpId = m_pro_id_origen
    c.Value = m_ProOrigen
    
    Set c = .Item(cscProIdDestino)
    c.HelpId = m_pro_id_destino
    c.Value = m_ProDestino
    
    Set c = .Item(cscTransId)
    c.HelpId = m_trans_id
    c.Value = m_Transporte
    
    Set c = .Item(cscRvRetiro)
    c.Value = m_retiro
    
    Set c = .Item(cscRvGuia)
    c.Value = m_guia
    
    Set c = .Item(cscRvDestinatario)
    c.Value = m_Destinatario
    
    Set c = .Item(cscRvOrdenCompra)
    c.Value = m_OrdenCompra
    
    Set c = .Item(cscClisId)
    c.HelpId = m_clis_id
    c.Value = m_ClienteSucursal
    
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
  
    Set c = .Item(cscRvSubtotal)
    c.Value = m_SubTotal
    
    Set c = .Item(cscRvImportedesc1)
    c.Value = m_ImporteDesc1
    
    Set c = .Item(cscRvImportedesc2)
    c.Value = m_ImporteDesc2
    
    Set c = .Item(cscRvNeto)
    c.Value = m_Neto
    
    Set c = .Item(cscRvIvari)
    c.Value = m_Ivari
    
    Set c = .Item(cscRvIvarni)
    c.Value = m_Ivarni
    
    Set c = .Item(cscRvTotal)
    c.Value = m_Total
  End With
  
  Set AbmGen = m_Footer
  AbmGen.ShowValues m_Footer.Properties
  
  pSetEnabled

  pShowCotizacion

  ' DATADD
  ShowDataAddCliente m_UserCfg.ShowDataAddInVentas, _
                     m_ObjAbm

End Sub

Private Sub pShowApply()
  
  If Not DocSecurityCanAccess(csPreVtaModifyAplic, m_doc_id, csEDocTPreAplicar) Then Exit Sub

  If m_ObjApply Is Nothing Then
    Set m_ObjApply = New cRemitoVentaAplic
  
  ' Edit Apply
  '
  Else
    If m_ObjApply.id <> m_Id Then
      Set m_ObjApply.ObjectClient = Nothing
      Set m_ObjApply = New cRemitoVentaAplic
    End If
  End If

  ' Edit Apply
  '
  Set m_ObjApply.ObjectClient = Me
  
  If Not m_ObjApply.Show(m_Id, _
                         m_Total, _
                         m_Nrodoc, _
                         m_cli_id, _
                         m_cliente, _
                         m_suc_id, _
                         m_doc_id, _
                         m_Doct_id = csEDocumentoTipo.csEDT_DevolucionRemitoVta) Then
    Set m_ObjApply = Nothing
  End If
End Sub

Private Sub pShowStartWizard()
  On Error GoTo ControlError
  
  Dim oWizard As cRemitoVentaWizard
  Set oWizard = New cRemitoVentaWizard
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  If Not oWizard.Load() Then Exit Sub

  With oWizard
    .cli_id = m_cli_id
    .Cliente = m_cliente
    .PvIds = m_PvIds
    .doc_id = m_LastDoc
    .Documento = m_LastDocName
    Set .ObjClient = Me
  End With
  
  'Dim iEditGeneric As cIEditGeneric
  'Set iEditGeneric = oWizard
  'Set iEditGeneric.ObjTree = m_ObjTree
  
  Dim iObjWizard As cIWizardGeneric
  Dim oObjWizard As cWizardGeneric
  
  Set iObjWizard = CSKernelClient2.CreateObject("CSABMInterface2.cWizardGeneric")
  Set oObjWizard = iObjWizard
  Set oObjWizard.ObjClient = oWizard
  oObjWizard.PushVirtualNext = m_bPushVirtualNext
    
  iObjWizard.Show "CSVenta2.cRemitoVentaWizard"
  
  oObjWizard.ObjAbm.ObjForm.ZOrder
  
  GoTo ExitProc
ControlError:
  MngError Err, "pShowStartWizard", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pShowStartWizardOrden()
  On Error GoTo ControlError
  
  Dim oWizard As cRemitoVentaOrdenWiz
  Set oWizard = New cRemitoVentaOrdenWiz
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  If Not oWizard.Load() Then Exit Sub

  With oWizard
    .cli_id = m_cli_id
    .Cliente = m_cliente
    .OsIds = m_OsIds
    .OsiIds = m_PrnsIds
    .doc_id = m_LastDoc
    .Documento = m_LastDocName
    .AutoFactura = m_bAutoFactura
    .AutoPago = m_bAutoPago
    .cue_id_autoPago = m_cue_id_autoPago
    .ModoVentaCtaCte = m_ModoVentaCtaCte
    Set .ObjClient = Me
  End With
  
  'Dim iEditGeneric As cIEditGeneric
  'Set iEditGeneric = oWizard
  'Set iEditGeneric.ObjTree = m_ObjTree
  
  Dim iObjWizard As cIWizardGeneric
  Dim oObjWizard As cWizardGeneric
  
  Set iObjWizard = CSKernelClient2.CreateObject("CSABMInterface2.cWizardGeneric")
  Set oObjWizard = iObjWizard
  Set oObjWizard.ObjClient = oWizard
  oObjWizard.PushVirtualNext = m_bPushVirtualNext
  
  iObjWizard.Show "CSVenta2.cRemitoVentaOrdenWiz"
  
  If Not oObjWizard.ObjAbm Is Nothing Then
    oObjWizard.ObjAbm.ObjForm.ZOrder
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "pShowStartWizardOrden", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pShowStartWizardBOM()
  On Error GoTo ControlError
  
  Dim oWizard As cRemitoVentaBOMWizard
  Set oWizard = New cRemitoVentaBOMWizard
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  If Not oWizard.Load() Then Exit Sub

  With oWizard
    .cli_id = m_cli_id
    .Cliente = m_cliente
    .PvIds = m_PvIds
    .doc_id = m_LastDoc
    .Documento = m_LastDocName
    Set .ObjClient = Me
  End With
  
  'Dim iEditGeneric As cIEditGeneric
  'Set iEditGeneric = oWizard
  'Set iEditGeneric.ObjTree = m_ObjTree
  
  Dim iObjWizard As cIWizardGeneric
  Dim oObjWizard As cWizardGeneric
  
  Set iObjWizard = CSKernelClient2.CreateObject("CSABMInterface2.cWizardGeneric")
  Set oObjWizard = iObjWizard
  Set oObjWizard.ObjClient = oWizard
  oObjWizard.PushVirtualNext = m_bPushVirtualNext
    
  iObjWizard.Show "CSVenta2.cRemitoVentaBOMWizard"
  
  oObjWizard.ObjAbm.ObjForm.ZOrder
  
  GoTo ExitProc
ControlError:
  MngError Err, "pShowStartWizardBOM", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' Construccion - Destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(2222, vbNullString)  'Error al grabar el Remito de Venta
  
  Set m_NrosSerie = New Collection
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  ' Lote
  '
  Set m_StockConfig = New cStockConfig
  m_StockConfig.Load
  
  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load
  m_UserCfg.ValidateRV
  
  ReDim m_PvIds(0)
  ReDim m_OsIds(0)
  ReDim m_PrnsIds(0)

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
  ReDim m_PvIds(0)
  ReDim m_OsIds(0)
  CollClear m_NrosSerie
  Set m_NrosSerie = Nothing
  Set m_GeneralConfig = Nothing
  
  ' Lote
  '
  Set m_StockConfig = Nothing
  
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

Private Sub pSetShowStockData(ByVal bInLoadCollection As Boolean)
  Dim DocId     As Long
  Dim DocIdRto  As Long
  Dim Doc       As cDocumento
  
  Set Doc = New cDocumento
  
  m_bShowStockData = False
  
  DocId = m_ObjAbm.Properties.Item(cscDocId).HelpId
  
  ' Si el remito mueve stock
  '
  If CBool(Doc.GetData(DocId, cscDocMueveStock, csBoolean)) Then
    m_bShowStockData = True
  End If

  ' HIDECOLS
  '
  If Not bInLoadCollection Then pShowHideCols True

End Sub

Private Sub pSetNrosSerieInRow(ByVal CurrGroup As Long, ByVal NroSerie As String)
  Dim Row As cIABMGridRow
  
  If CurrGroup = 0 Then Exit Sub
  
  For Each Row In m_Items.Properties(c_Items).Grid.Rows
    If pCell(Row, KI_GRUPO).id = CurrGroup Then
      pCell(Row, KI_NROSERIE).Value = RemoveLastColon(NroSerie)
      Exit Sub
    End If
  Next
End Sub

'///////////////////////////////////////////////////////////////////////////////////////////////////////////
Private Function pSaveItemNroSerie(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                   ByRef iOrden As Long, _
                                   ByVal PrId As Long, _
                                   ByVal RvTMPId As Long, _
                                   ByVal RviTMPId As Long, _
                                   ByVal Grupo As Long) As Boolean
                                   
  Dim pt        As cProductoSerieType
  Dim register  As cRegister
  
  ' Si lleva numero de serie
  '
  If pCell(Row, KI_PR_LLEVANROSERIE).id And m_bShowStockData Then
  
    ' Obtengo los numeros de serie y guardo un Item por cada uno
    '
    For Each pt In m_NrosSerie.Item(GetKey(Grupo))
      
      Set register = New cRegister
      With register
        .fieldId = cscRvisTMPId
        .Table = csTRemitoVentaItemSerieTMP
        .id = csNew
      
        With .fields
          .Add2 cscPrId, PrId, csId
      
          If m_Copy Then
            .Add2 cscPrnsId, csNew, csInteger
          Else
            .Add2 cscPrnsId, pt.prns_id, csId
          End If
          
          .Add2 cscPrnsCodigo, pt.Codigo, csText
          .Add2 cscPrnsDescrip, pt.Descrip, csText
          .Add2 cscPrnsFechavto, pt.FechaVto, csDate
          .Add2 cscPrIdItem, pt.pr_id_item, csId
          
          .Add2 cscRvTMPId, RvTMPId, csId
          .Add2 cscRviTMPId, RviTMPId, csId
          
          iOrden = iOrden + 1
          .Add2 cscRvisOrden, iOrden, csInteger
          
          .HaveLastUpdate = False
          .HaveWhoModify = False
        End With
      End With
      
      If Not gDB.Save(register, , _
                      "pSaveItemNroSerie", _
                      C_Module, _
                      c_ErrorSave) Then Exit Function
    Next
  End If
  
  pSaveItemNroSerie = True
End Function

'////////////////////////////////////////////////////////////////////////////////////////////////
' nrs devolucion
Private Function pGetDeplId() As Long
  If m_LastDoctId = csEDocumentoTipo.csEDT_DevolucionRemitoVta Then
    pGetDeplId = csE_DepositosInternos.csEDeplIdTercero
  Else
    pGetDeplId = m_ObjAbm.Properties(cscDeplIdOrigen).HelpId
  End If
End Function

Private Function pGetCliId() As Long
  pGetCliId = m_ObjAbm.Properties(cscCliId).HelpId
End Function

Private Function pGetFecha() As Date
  pGetFecha = m_ObjAbm.Properties.Item(cscRvFecha).Value
End Function

Private Sub pSetStock()

  If m_StockConfig.StockXFisico Or m_StockConfig.NoControlaStock Then
    
    m_depf_id = csNO_ID
    
    If Not gDB.GetData(csTDepositoLogico, _
                       cscDeplId, _
                       pGetDeplId(), _
                       cscDepfId, _
                       m_depf_id) Then
    End If
  End If

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

Private Sub pShowFactura(ByVal bPushVirtualNext As Boolean)
  On Error GoTo ControlError

  Dim o As CSVenta2.cFacturaVenta
  Set o = New CSVenta2.cFacturaVenta
  o.PushVirtualNext = bPushVirtualNext
  o.ShowFacturaRemito m_cli_id, pGetRvIds()

  GoTo ExitProc
ControlError:
  MngError Err, "pShowFactura", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetRvIds() As Long()
  Dim rtn() As Long
  ReDim rtn(1)
  rtn(1) = m_Id
  pGetRvIds = rtn
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
        
      Case KI_NROSERIE, KI_STL_ID
      
        ' Si mueve stock se ven siempre
        '
        Columns(i).Visible = m_bShowStockData
        AbmObj.RefreshColumnPropertiesByIndex iProp, i
    
    End Select
  Next
  
  AbmObj.DrawGrid iProp, True
End Sub
'
' HIDECOLS - fin

Private Function pGetFileNamePostFix() As String
  pGetFileNamePostFix = Left$(m_cliente, 50) & "-" & m_Nrodoc
End Function

Private Sub pShowMenuDocAction()
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  Dim Menu As String
  
  Menu = LNGGetText(4960, vbNullString) & "~6" _
       & "|" & LNGGetText(4961, vbNullString) & "~7" _
       & "|" & LNGGetText(4962, vbNullString) & "~8"
      ' Facturar el Documento|Facturar el Documento Automaticamente|Cancelar el Documento
  
  AbmObj.ShowPopMenu Menu
End Sub

Private Sub pCancelarRemito()
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocRemitoVentaCancelar " _
                    & User.id & "," _
                    & EmpId & "," _
                    & m_Id
                    
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  If rs.EOF Then Exit Sub
  
  If gDB.ValField(rs.fields, 0) = 0 Then
    MsgWarning gDB.ValField(rs.fields, 1)
  Else
    MsgInfo LNGGetText(4963, vbNullString) ' La operación concluyo con éxito
  End If
  
End Sub


