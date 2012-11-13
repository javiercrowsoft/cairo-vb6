VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCobranzaContado"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
Implements CSIDocumento.cIDocumento
'--------------------------------------------------------------------------------
' cPagoContado
' 24-09-2007

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cPagoContado"

Private Const c_Cheques = "Cheques"
Private Const c_Efectivo = "Efectivo"
Private Const c_Tarjeta = "Tarjetas"
Private Const c_Otros = "Otros"
Private Const c_Cuotas = "Cuotas"
Private Const c_CobrosPendientes = "CobrosPendientes"
Private Const c_CtaCte = "CtaCte"

Private Const c_cobrado = "cobrado"
Private Const c_cambio = "cambio"
Private Const c_pedidos = "pedidos"
Private Const c_cvxi_pago = "cvxipagos"
Private Const c_cvxi_highlight_button = "cvxi_high"
Private Const c_cmd_ctacte = "cmd_ctacte"
Private Const c_acobrar = "acobrar"
Private Const c_list_cobrado = "list_cobrado"
Private Const c_filtro_cobrado = "filtro_cobrado"
Private Const c_detalle_cobrado = "detalle_cobrado"

Private Const C_VM_ID = 0
Private Const C_VM_MENU_ID = 1
Private Const C_VM_IS_CONTADO = 2
Private Const C_VM_CUE_ID = 3
Private Const C_VM_VMXI_PAGO = 4

Private Const K_CHEQUES                        As Integer = 15
Private Const K_ACOBRAR                        As Integer = 8
Private Const K_COBRADO                        As Integer = 7
Private Const K_CAMBIO                         As Integer = 10
Private Const K_NETO                           As Integer = 6
Private Const K_OTROS                          As Integer = 24
Private Const K_TOTAL                          As Integer = 9
Private Const K_EFECTIVO                       As Integer = 28
Private Const K_TARJETA                        As Integer = 29
Private Const K_COBROS_PENDIENTES              As Integer = 31
Private Const K_CTA_CTE                        As Integer = 32

Private Const K_COPY_CHEQUE                    As Integer = 30
Private Const K_REFRESH                        As Integer = 33
Private Const K_CMD_CTACTE                     As Integer = 34
Private Const K_LIST_COBRADO                   As Integer = 35
Private Const K_DETALLE_COBRADO                As Integer = 36

Private Const K_CMD_FILTER                      As Integer = 507
Private Const K_FILTER                          As Integer = 508

Private Const KIO_COBZI_ID                   As Integer = 1
Private Const KIO_CUE_ID                     As Integer = 2
Private Const KIO_DEBE                       As Integer = 3
Private Const KIO_HABER                      As Integer = 4
Private Const KIO_IMPORTEORIGEN              As Integer = 5
Private Const KIO_DESCRIP                    As Integer = 6
Private Const KIO_RET_ID                     As Integer = 7
Private Const KIO_NRORETENCION               As Integer = 8
Private Const KIO_PORCRETENCION              As Integer = 9
Private Const KIO_FECHARETENCION             As Integer = 10
Private Const KIO_CCOS_ID                    As Integer = 11

Private Const KICH_COBZI_ID              As Integer = 1
Private Const KICH_CUE_ID                As Integer = 2
Private Const KICH_IMPORTE               As Integer = 3
Private Const KICH_IMPORTEORIGEN         As Integer = 4
Private Const KICH_BCO_ID                As Integer = 5
Private Const KICH_CHEQUE                As Integer = 6
Private Const KICH_MON_ID                As Integer = 8
Private Const KICH_FECHACOBRO            As Integer = 9
Private Const KICH_FECHAVTO              As Integer = 10
Private Const KICH_CLE_ID                As Integer = 11
Private Const KICH_DESCRIP               As Integer = 12
Private Const KICH_PROPIO                As Integer = 13
Private Const KICH_SUCURSAL              As Integer = 14

Private Const KIE_COBZI_ID               As Integer = 1
Private Const KIE_CUE_ID                 As Integer = 2
Private Const KIE_MON_ID                 As Integer = 3
Private Const KIE_IMPORTE                As Integer = 4
Private Const KIE_IMPORTEORIGEN          As Integer = 5
Private Const KIE_DESCRIP                As Integer = 6

Private Const KIT_COBZI_ID                As Integer = 1
Private Const KIT_CUPON                   As Integer = 2
Private Const KIT_TJC_ID                  As Integer = 3
Private Const KIT_IMPORTE                 As Integer = 4
Private Const KIT_IMPORTEORIGEN           As Integer = 5
Private Const KIT_FECHAVTO                As Integer = 7
Private Const KIT_NROTARJETA              As Integer = 8
Private Const KIT_NROAUTORIZACION         As Integer = 9
Private Const KIT_TITULAR                 As Integer = 10
Private Const KIT_MON_ID                  As Integer = 11
Private Const KIT_DESCRIP                 As Integer = 12
Private Const KIT_TARJETA_TIPO            As Integer = 13
Private Const KIT_TJCCU_ID                As Integer = 15

Private Const KIFV_ID                     As Integer = 1
Private Const KIFV_CLIENTE                As Integer = 2
Private Const KIFV_TOTAL                  As Integer = 3
Private Const KIFV_COMPROBANTE            As Integer = 4
Private Const KIFV_DESCRIP                As Integer = 5
Private Const KIFV_DIRECCION              As Integer = 6

Private Const KI_MCJM_ID                       As Integer = 1
Private Const KI_AS_ID                         As Integer = 100
Private Const KI_COMPROBANTE                   As Integer = 101
Private Const KI_FECHA                         As Integer = 102
Private Const KI_IMPORTE                       As Integer = 4
Private Const KI_DESCRIP                       As Integer = 5
Private Const KI_INGRESOS                      As Integer = 6
Private Const KI_EGRESOS                       As Integer = 7
Private Const KI_CUE_ID                        As Integer = 103

' Cobranza
Private Const csTCobranza                               As String = "Cobranza"
Private Const cscCobzId                                 As String = "cobz_id"
Private Const cscCobzNumero                             As String = "cobz_numero"
Private Const cscCobzNroDoc                             As String = "cobz_nrodoc"
Private Const cscCobzDescrip                            As String = "cobz_descrip"
Private Const cscCobzFecha                              As String = "cobz_fecha"
Private Const cscCobzNeto                               As String = "cobz_neto"
Private Const cscCobzOtros                              As String = "cobz_otros"
Private Const cscCobzTotal                              As String = "cobz_total"
Private Const cscCobzPendiente                          As String = "cobz_pendiente"
Private Const cscCobzCotizacion                         As String = "cobz_cotizacion"
Private Const cscCobzGrabarAsiento                      As String = "cobz_grabarAsiento"
Private Const cscCobzFirmado                            As String = "cobz_firmado"

' CobranzaTMP
Private Const csTCobranzaTMP                            As String = "CobranzaTMP"
Private Const cscCobzTMPId                              As String = "cobzTMP_id"

' CobranzaItem
Private Const csTCobranzaItem                            As String = "CobranzaItem"
Private Const cscCobziId                                 As String = "cobzi_id"
Private Const cscCobziOrden                              As String = "cobzi_orden"
Private Const cscCobziOtroTipo                           As String = "cobzi_otroTipo"
Private Const cscCobziImporte                            As String = "cobzi_importe"
Private Const cscCobziImporteOrigen                      As String = "cobzi_importeOrigen"
Private Const cscCobziDescrip                            As String = "cobzi_descrip"
Private Const cscCobziPorcRetencion                      As String = "cobzi_porcRetencion"
Private Const cscCobziFechaRetencion                     As String = "cobzi_fechaRetencion"
Private Const cscCobziNroRetencion                       As String = "cobzi_nroRetencion"
Private Const cscCobziTipo                               As String = "cobzi_tipo"
Private Const cscCobziTarjetaTipo                        As String = "cobzi_tarjetaTipo"

' CobranzaItemTMP
Private Const csTCobranzaItemTMP                         As String = "CobranzaItemTMP"
Private Const cscCobziTMPId                              As String = "cobziTMP_id"
Private Const cscCobziTMPCheque                          As String = "cobziTMP_cheque"
Private Const cscCobziTMPChequera                        As String = "cobziTMP_chequera"
Private Const cscCobziTMPCupon                           As String = "cobziTMP_cupon"
Private Const cscCobziTMPFechaCobro                      As String = "cobziTMP_fechaCobro"
Private Const cscCobziTMPFechaVto                        As String = "cobziTMP_fechaVto"
Private Const cscCobziTMPTitular                         As String = "cobziTMP_titular"
Private Const cscCobziTMPAutorizacion                    As String = "cobziTMP_autorizacion"
Private Const cscCobziTMPNroTarjeta                      As String = "cobziTMP_nroTarjeta"
Private Const cscCobziTMPPropio                          As String = "cobziTMP_propio"
Private Const cscCobziTMPSucursal                        As String = "cobziTMP_sucursal"

' Banco
Private Const csTBanco                            As String = "Banco"
Private Const cscBcoId                            As String = "bco_id"
Private Const cscBcoNombre                        As String = "bco_nombre"

' Chequera
Private Const csTChequera                              As String = "Chequera"
Private Const cscChqId                                 As String = "chq_id"
Private Const cscChqCodigo                             As String = "chq_codigo"

' Cheque
Private Const csTCheque                                 As String = "Cheque"
Private Const cscCheqId                                 As String = "cheq_id"
Private Const cscCheqNumero                             As String = "cheq_numero"
Private Const cscCheqNumeroDoc                          As String = "cheq_numerodoc"
Private Const cscCheqImporte                            As String = "cheq_importe"
Private Const cscCheqImporteOrigen                      As String = "cheq_importeOrigen"
Private Const cscCheqTipo                               As String = "cheq_tipo"
Private Const cscCheqFechaVto                           As String = "cheq_fechaVto"
Private Const cscCheqFechaCobro                         As String = "cheq_fechaCobro"
Private Const cscCheqDescrip                            As String = "cheq_descrip"
Private Const cscCheqFcImporte1                         As String = "cheq_fc_importe1"
Private Const cscCheqFcImporte2                         As String = "cheq_fc_importe2"
Private Const cscCheqFvImporte                          As String = "cheq_fv_importe"
Private Const cscCheqFechaRechazo                       As String = "cheq_fechaRechazo"
Private Const cscCheqRechazado                          As String = "cheq_rechazado"
Private Const cscFcIdNd1                                As String = "fc_id_nd1"
Private Const cscFcIdNd2                                As String = "fc_id_nd2"
Private Const cscFvIdNd                                 As String = "fv_id_nd"

'Clearing
Private Const csTClearing                         As String = "Clearing"
Private Const cscCleId                            As String = "cle_id"
Private Const cscCleNombre                        As String = "cle_nombre"

' Tarjeta Credito Cupon
Private Const csTTarjetaCreditoCupon                    As String = "TarjetaCreditoCupon"
Private Const cscTjccId                                 As String = "tjcc_id"
Private Const cscTjccNumero                             As String = "tjcc_numero"
Private Const cscTjccNumeroDoc                          As String = "tjcc_numerodoc"
Private Const cscTjccDescrip                            As String = "tjcc_descrip"
Private Const cscTjccFechavto                           As String = "tjcc_fechavto"
Private Const cscTjccNroTarjeta                         As String = "tjcc_nroTarjeta"
Private Const cscTjccNroAutorizacion                    As String = "tjcc_nroAutorizacion"
Private Const cscTjccTitular                            As String = "tjcc_titular"
Private Const cscTjccImporte                            As String = "tjcc_importe"
Private Const cscTjccImporteOrigen                      As String = "tjcc_importeOrigen"

' TarjetaCredito
Private Const csTTarjetaCredito                   As String = "TarjetaCredito"
Private Const cscTjcId                            As String = "tjc_id"
Private Const cscTjcNombre                        As String = "tjc_nombre"
Private Const cscTjcComision                      As String = "tjc_comision"

' Tarjeta Credito Cuota
Private Const cscTjccuId                          As String = "tjccu_id"
Private Const cscTjccuCantidad                    As String = "tjccu_cantidad"
Private Const cscTjccuComision                    As String = "tjccu_comision"

' Retencion
Private Const cscRetId                                 As String = "ret_id"
Private Const cscRetNombre                             As String = "ret_nombre"

' CuentaCategoria
Private Const csTCuentaCategoria                  As String = "CuentaCategoria"
Private Const cscCuecId                           As String = "cuec_id"

Private Const cscCobId                                 As String = "cob_id"

' FacturaVentaCobranza
Private Const csTFacturaVentaCobranzaTMP         As String = "FacturaVentaCobranzaTMP"
Private Const cscFvCobzImporte                   As String = "fvcobz_importe"
Private Const cscFvCobzTMPid                     As String = "fvcobzTMP_id"
Private Const cscFvCobzId                        As String = "fvcobz_id"
Private Const cscFvCobzImporteOrigen             As String = "fvcobz_importeOrigen"
Private Const cscFvCobzCotizacion                As String = "fvcobz_cotizacion"

' FacturaVentaDeuda
Private Const cscFvdId                           As String = "fvd_id"
Private Const cscFvdFecha                        As String = "fvd_fecha"
Private Const cscFvdPendiente                    As String = "fvd_pendiente"

Private Enum csECuponTipo
  csECuponPosnet = 1
  csECuponManual = 2
End Enum

Private Enum csECobranzaItemTipo
  csECobziTCheques = 1
  csECobziTEfectivo = 2
  csECobziTTarjeta = 3
  csECobziTOtros = 4
  csECobziTCtaCte = 5
End Enum

Private Enum csEItemOtroTipo
  csEOtroDebe = 1
  csEOtroHaber = 2
End Enum

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Descrip                      As String
Private m_Fecha                        As Date
Private m_Neto                         As Double
Private m_Otros                        As Double
Private m_Total                        As Double
Private m_FvTotal                      As Double
Private m_Cobrado                      As Double
Private m_lgj_id                       As Long
Private m_Legajo                       As String
Private m_ccos_id                      As Long
Private m_CentroCosto                  As String
Private m_suc_id                       As Long
Private m_Sucursal                     As String
Private m_cli_id                       As Long
Private m_cliente                      As String
Private m_apodo                        As String
Private m_venta                        As String
Private m_pago                         As String
Private m_pagocvxi                     As Double
Private m_factura                      As String
Private m_FvId                         As Long
Private m_doc_id                       As Long
Private m_Documento                    As String
Private m_Doct_id                      As Long
Private m_cj_id                        As Long

Private m_iOrden                       As Long

' Pago Automatico
'
Private m_bAutoPago         As Boolean
Private m_cue_id_autoPago   As Long

' Para ver documentos auxiliares
'
Private m_as_id                        As Long

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric

Private m_GeneralConfig     As cGeneralConfig

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

Private m_lColCuotas        As Long

Private m_MonDefault        As Long

Private m_vMenuModoPago()   As Long

Private m_key_cmvxi         As Long

Private m_bIsCobranzaCajero As Boolean

Private m_bProcessingKey    As Boolean

Private m_inShortCut        As Boolean

Private m_bCobranzaCdo      As Boolean

' propiedades publicas
Public Property Get wasClosed() As Boolean
  wasClosed = m_Editing = False
End Property
' propiedades privadas
' funciones publicas

Public Function ShowCobranza(ByVal CliId As Long, _
                             ByVal FvId As Long, _
                             ByVal FvFecha As Date, _
                             ByVal FvTotal As Double, _
                             ByVal SucId As Long, _
                             ByVal CcosId As Long, _
                             ByVal LgjId As Long, _
                             ByVal CjId As Long, _
                             ByVal bAutoPago As Boolean, _
                             ByVal CueIdAutoPago As Long) As Boolean
                        
  On Error GoTo ControlError

  m_Fecha = FvFecha
  m_FvTotal = FvTotal
  m_FvId = FvId
  m_cli_id = CliId
  m_doc_id = m_UserCfg.DocCobzId
  m_Documento = m_UserCfg.DocCobzNombre
  m_suc_id = SucId
  m_ccos_id = CcosId
  m_lgj_id = LgjId
  m_cj_id = CjId
  m_bAutoPago = bAutoPago
  m_cue_id_autoPago = CueIdAutoPago
  
  If m_doc_id = csNO_ID Then
    MsgWarning LNGGetText(3558, vbNullString) ' Debe configurar un documento de cobranzas para pago contado en el menu Configuracion > General > Preferencias
    Exit Function
  End If
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocCobranzaCdoGetCliente " & FvId
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  m_cliente = gDB.ValField(rs.fields, cscCliNombre)
  m_apodo = gDB.ValField(rs.fields, cscliCodigoComunidad)
  m_venta = gDB.ValField(rs.fields, "venta")
  m_pago = gDB.ValField(rs.fields, "pago")
  m_factura = gDB.ValField(rs.fields, "factura")
  m_pagocvxi = gDB.ValField(rs.fields, "pagocvxi")
  
  m_bCobranzaCdo = True
  
  If Not pInitMembers Then
    Exit Function
  End If
  
  LoadCollection True

  GoTo ExitProc
ControlError:
  MngError Err, "ShowCobranza", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function ShowCobranzaCajero() As Boolean
                        
  On Error GoTo ControlError

  m_bIsCobranzaCajero = True

  m_Fecha = Date
  m_FvTotal = 0
  m_FvId = csNO_ID
  m_cli_id = csNO_ID
  m_doc_id = m_UserCfg.DocCobzId
  m_Documento = m_UserCfg.DocCobzNombre
  m_suc_id = csNO_ID
  m_ccos_id = csNO_ID
  m_lgj_id = csNO_ID
  m_cj_id = csNO_ID
  m_bAutoPago = False
  m_cue_id_autoPago = csNO_ID
  
  If Not pLoadCajaForUsuario() Then Exit Function
  
  If m_doc_id = csNO_ID Then
    MsgWarning LNGGetText(3558, vbNullString) ' Debe configurar un documento de cobranzas para pago contado en el menu Configuracion > General > Preferencias
    Exit Function
  End If
    
  m_cliente = vbNullString
  m_apodo = vbNullString
  m_venta = vbNullString
  m_pago = vbNullString
  m_factura = vbNullString
  m_pagocvxi = 0
  
  m_bCobranzaCdo = False
  
  If Not pInitMembers Then
    Exit Function
  End If
  
  LoadCollection False

  GoTo ExitProc
ControlError:
  MngError Err, "ShowCobranzaCajero", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Sub ShowWindow()
  On Error Resume Next
  m_ObjAbm.ObjForm.ZOrder
End Sub

Private Function pInitMembers() As Boolean
  Set m_ObjAbm = New cABMGeneric
  
  If Not DocSecurityCanAccess(csPreVtaCobranzaContado, _
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
  cIABMClient_CanAddDocDigital = False
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
  cIABMClient_CanCopy = False
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = False
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
  cIABMClient_ShowDocDigital = False
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  On Error GoTo ControlError
  
  Dim iProp As cIABMProperty
  Dim AbmGen As cABMGeneric
    
  Select Case MessageID
  
    Case MSG_GRID_ROW_DELETED
      cIABMClient_MessageEx = True
      Select Case Info
        Case K_CHEQUES, K_EFECTIVO, K_TARJETA
          pShowCobroNeto
        Case K_OTROS
          pShowCobroOtro
      End Select
      pShowCobroTotal
      
    Case MSG_FORM_AFTER_SHOW_MODAL
      
      Set iProp = pGetCMDCvxi()
      
      If Not iProp Is Nothing Then
      
        Set AbmGen = m_ObjAbm
        
        AbmGen.refreshButtonsStyle iProp
  
      End If
      
    Case MSG_GRID_ROW_CHANGE
      
      If Info Is Nothing Then Exit Function
              
      Set iProp = Info
      
      pManageRowSelection iProp
      
    Case MSG_DOC_REFRESH
    
      pLoadDataFromFactura csNO_ID
      
    Case MSG_KEY_DOWN
    
      pProcessKeyDown Info
      
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_MessageEx", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub pProcessKeyDown(ByVal Info As Variant)
  On Error Resume Next
  
  If m_bProcessingKey Then Exit Sub
  
  m_bProcessingKey = True

  If Info = vbKeyF5 Then
    pRefresh
  ElseIf Info = vbKeyF7 Then
    pCheckCobroButtons 10000
  ElseIf Info = vbKeyF8 Then
    pCheckCobroButtons 11000
  ElseIf Info = vbKeyF9 Then
    pCheckCobroButtons 12000
  ElseIf Info = vbKeyF2 Then
    Dim AbmGen As cABMGeneric
    Set AbmGen = m_ObjAbm
    AbmGen.SetFocusCtrl pGetCobrado()
  End If
  
  m_bProcessingKey = False

End Sub

Private Sub pLoadDataFromFactura(ByVal fv_id As Long)
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  m_Total = 0
  
  If fv_id <> csNO_ID Then
  
    sqlstmt = "sp_DocCobranzaCdoGetCliente " & fv_id
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
    If rs.EOF Then Exit Sub
    
    m_FvId = fv_id
    m_Fecha = gDB.ValField(rs.fields, cscFvFecha)
    m_FvTotal = gDB.ValField(rs.fields, cscFvTotal)
    m_cli_id = gDB.ValField(rs.fields, cscCliId)
    m_suc_id = gDB.ValField(rs.fields, cscSucId)
    m_ccos_id = gDB.ValField(rs.fields, cscCcosId)
    m_lgj_id = gDB.ValField(rs.fields, cscLgjId)
    m_cliente = gDB.ValField(rs.fields, cscCliNombre)
    m_apodo = gDB.ValField(rs.fields, cscliCodigoComunidad)
    m_venta = gDB.ValField(rs.fields, "venta")
    m_pago = gDB.ValField(rs.fields, "pago")
    m_factura = gDB.ValField(rs.fields, "factura")
    m_pagocvxi = gDB.ValField(rs.fields, "pagocvxi")
  
  Else
  
    m_FvId = fv_id
    m_Fecha = csNoDate
    m_FvTotal = 0
    m_cli_id = csNO_ID
    m_suc_id = csNO_ID
    m_ccos_id = csNO_ID
    m_lgj_id = csNO_ID
    m_cliente = vbNullString
    m_apodo = vbNullString
    m_venta = vbNullString
    m_pago = vbNullString
    m_factura = vbNullString
    m_pagocvxi = 0
  
  End If
  
  Dim AbmGen As cABMGeneric
  Dim iProp As cIABMProperty
  
  Set AbmGen = m_ObjAbm
  
  Set iProp = m_ObjAbm.Properties.Item(cscFvFecha)
  iProp.Value = m_Fecha
  AbmGen.ShowValue iProp
  
  Set iProp = m_ObjAbm.Properties.Item(cscFvTotal)
  iProp.Value = m_FvTotal
  AbmGen.ShowValue iProp
  
  Set iProp = m_ObjAbm.Properties.Item(cscCobzNeto)
  iProp.Value = m_Neto
  AbmGen.ShowValue iProp
  
  Set iProp = m_ObjAbm.Properties.Item(cscCobzOtros)
  iProp.Value = m_Otros
  AbmGen.ShowValue iProp
  
  Set iProp = m_ObjAbm.Properties.Item(cscCobzTotal)
  iProp.Value = m_Total
  AbmGen.ShowValue iProp
  
  Set iProp = m_ObjAbm.Properties.Item(c_cambio)
  iProp.Value = Format(0, m_GeneralConfig.FormatDecImporte)
  AbmGen.ShowValue iProp

  Set iProp = m_ObjAbm.Properties.Item(cscCliId)
  iProp.Value = m_apodo
  AbmGen.ShowValue iProp
    
  Set iProp = m_ObjAbm.Properties.Item(cscCliNombre)
  iProp.Value = m_cliente
  AbmGen.ShowValue iProp
  
  Set iProp = m_ObjAbm.Properties.Item(c_acobrar)
  iProp.Value = Format(m_FvTotal, m_GeneralConfig.FormatDecImporte)
  AbmGen.ShowValue iProp
  
  Set iProp = m_ObjAbm.Properties.Item(cscFvNrodoc)
  iProp.Value = m_factura
  AbmGen.ShowValue iProp
  
  Set iProp = m_ObjAbm.Properties.Item(c_pedidos)
  iProp.Value = m_venta
  AbmGen.ShowValue iProp
  
  Set iProp = m_ObjAbm.Properties.Item(c_cvxi_pago)
  iProp.Value = m_pago
  AbmGen.ShowValue iProp
  
  Set iProp = m_ObjAbm.Properties.Item(c_cvxi_highlight_button)
  If m_pagocvxi <> 0 Then
    If Abs(m_pagocvxi - m_FvTotal) > 0.1 Then
      iProp.BackColor = vbRed
    Else
      iProp.BackColor = vbGreen
    End If
  Else
    iProp.BackColor = vbWhite
  End If
  AbmGen.ShowValue iProp
  
  pLoadEfectivo pGetEfectivoProperty()
  AbmGen.ShowValue pGetEfectivoProperty(), True
  pLoadTarjetas pGetTarjetasProperty()
  AbmGen.ShowValue pGetTarjetasProperty(), True
  pLoadOtros pGetOtrosProperty()
  AbmGen.ShowValue pGetOtrosProperty(), True
  pLoadCheques pGetChequesProperty()
  AbmGen.ShowValue pGetChequesProperty(), True

  pResetCobrado
  pShowCobroNeto
  pShowCobroTotal
  pShowCambio

End Sub

Private Sub cIABMClient_DiscardChanges()

End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  Select Case Key
    
    Case K_COBRADO
      pShowCambio
      
    Case K_COPY_CHEQUE
      pCopyCheque
      
    Case K_REFRESH
      pRefresh
      
    Case K_CMD_FILTER
      pRefreshCtaCte
      
    Case K_CMD_CTACTE
      pSendToCtaCte m_FvId
    
    Case Else
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      If Not AbmGen.InSave Then
        pCheckCobroButtons Key
      End If
      
  End Select
End Function

Private Sub pCopyCheque()
  If pGetCheques.Rows.count Then
  
    Dim count As Long
    Dim dias  As Long
    
    count = 1
    
    If GetInput(count, "Ingrese la cantidad de veces que desea copiar el cheque") Then
    
      dias = 7
      If GetInput(dias, "Ingrese la cantidad de días entre vencimientos") Then
    
        Dim Row     As cIABMGridRow
        Dim NewRow  As cIABMGridRow
        Dim Rows    As cIABMGridRows
        
        Set Rows = pGetCheques.Rows
        With Rows
          Set Row = .Item(.count)
        End With
        
        Dim i As Long
        Dim j As Long
        
        Dim bPropio     As Boolean
        Dim Numero      As Long
        Dim FechaCobro  As Date
        
        bPropio = pCell(Row, KICH_PROPIO).id
        Numero = Val(pCell(Row, KICH_CHEQUE).Value)
        FechaCobro = pCell(Row, KICH_FECHACOBRO).Value
        
        For i = 1 To count
          Set NewRow = Rows.Add(Nothing)
          FechaCobro = DateAdd("d", dias, FechaCobro)
          Numero = Numero + 1
          With NewRow
            For j = 1 To Row.count
              If j > 1 Then
                NewRow.Add Nothing
                Set .Item(j).Format = Row.Item(j).Format
                .Item(j).id = Row.Item(j).id
                .Item(j).Key = Row.Item(j).Key
                
                If Row.Item(j).Key = KICH_FECHACOBRO Then
                  .Item(j).Value = FechaCobro
                ElseIf Row.Item(j).Key = KICH_CHEQUE And bPropio Then
                  .Item(j).Value = Numero
                Else
                  .Item(j).Value = Row.Item(j).Value
                End If
              End If
            Next
          End With
        Next
        
        Dim AbmObj As cABMGeneric
        Set AbmObj = m_ObjAbm
        AbmObj.ShowValue pGetChequesProperty(), True
        
        pShowCobroNeto
        pShowCobroTotal
        
      End If
    End If
  Else
    MsgWarning "Debe agregar al menos un cheque para poder copiarlo"
  End If
End Sub

Private Function cIABMClient_Save() As Boolean
  Dim register     As cRegister
  
  ' Save and State
  '
  If Not DocCanEdit(True, vbNullString) Then
    cIABMClient_Save = True
    Exit Function
  End If
  If Not DocCanSave(m_ObjAbm, cscFvFecha) Then
    cIABMClient_Save = False
    Exit Function
  End If
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  m_Total = pGetCobroTotal().Value
  m_Neto = pGetCobroNeto().Value
  m_Otros = pGetCobroOtros().Value
  
  Set register = New cRegister
  register.fieldId = cscCobzTMPId
  register.Table = csTCobranzaTMP
  
  register.id = csNew
    
  register.fields.Add2 cscCobzId, csNew, csLong
    
  register.fields.Add2 cscCobzNumero, 0, csLong
  register.fields.Add2 cscCobzNroDoc, vbNullString, csText
  register.fields.Add2 cscCobzDescrip, m_Descrip, csText
  register.fields.Add2 cscCobzFecha, Date, csDate
  register.fields.Add2 cscCliId, m_cli_id, csId
  register.fields.Add2 cscCcosId, m_ccos_id, csId
  register.fields.Add2 cscSucId, m_suc_id, csId
  register.fields.Add2 cscDocId, m_doc_id, csId
  register.fields.Add2 cscCobzCotizacion, 0, csDouble
  register.fields.Add2 cscCobId, csNO_ID, csId
  register.fields.Add2 cscLgjId, m_lgj_id, csId
  
  register.fields.Add2 cscCobzNeto, m_Neto, csCurrency
  register.fields.Add2 cscCobzOtros, m_Otros, csCurrency
  register.fields.Add2 cscCobzTotal, m_Total, csCurrency
  
  register.fields.Add2 cscCobzGrabarAsiento, 1, csBoolean
  register.fields.Add2 cscEstId, CSGeneralEx2.csEEstado.csEEst_Pendiente, csId
  
  register.fields.HaveLastUpdate = True
  register.fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  m_iOrden = 0
  If Not pSaveCheques(register.id) Then Exit Function
  If Not pSaveEfectivo(register.id) Then Exit Function
  If Not pSaveOtros(register.id) Then Exit Function
  If Not pSaveTarjetas(register.id) Then Exit Function
  If Not pSaveCtaCte(register.id) Then Exit Function
  If Not pSaveFacturas(register.id) Then Exit Function
  
  If Not register.CommitTrans() Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DocCobranzaSave " & register.id
  
  If Not gDB.OpenRs(sqlstmt, rs, , , , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim id As Long
  If Not GetDocIDFromRecordset(rs, id) Then Exit Function
  
  m_Id = id
  
  pSaveDetalleOperacion m_FvId, m_Id, m_pagocvxi, False
    
  cIABMClient_Save = True
  
  If Not m_bCobranzaCdo Then
    If Not m_inShortCut Then
      pRefresh
      
      pResetCobrado
      pShowCobroNeto
      pShowCobroTotal
      pShowCambio
    End If
  End If
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2060, vbNullString)  'Cobranza
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim Cobrado As Double
  Dim ACobrar As Double
  
  ACobrar = Round(Val(pGetTotal().Value), m_GeneralConfig.DecimalesImporte)
  Cobrado = Round(Val(pGetCobroTotal().Value), m_GeneralConfig.DecimalesImporte)
  
  If ACobrar < Cobrado Then
    If Not Ask(LNGGetText(3720, vbNullString, Cobrado, ACobrar), vbNo) Then
              'El total de los instrumentos supera el monto a cobrar. Cobrado: Cobrado, a cobrar: ACobrar
      Exit Function
    End If
    
    m_Cobrado = Cobrado
    
  ElseIf Cobrado <= 0 Then
  
    MsgWarning LNGGetText(3721, vbNullString)
              ' El importe cobrado debe ser mayor a cero
    Exit Function
    
  Else
  
    m_Cobrado = Cobrado
    
  End If
  
  cIABMClient_Validate = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_CHEQUES
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowCheques(Row, RowIndex)
    Case K_TARJETA
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowTarjetas(Row, RowIndex)
    Case K_OTROS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowOtros(Row, RowIndex)
    Case K_EFECTIVO
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowEfectivo(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  On Error GoTo ControlError
  
  Select Case Key
    Case K_CHEQUES
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateCheque(m_ObjAbm.Properties(c_Cheques), lRow, lCol)
    Case K_TARJETA
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateTarjeta(m_ObjAbm.Properties(c_Tarjeta), lRow, lCol)
    Case K_OTROS
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateOtro(m_ObjAbm.Properties(c_Otros), lRow, lCol)
    Case K_EFECTIVO
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateEfectivo(m_ObjAbm.Properties(c_Efectivo), lRow, lCol)
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
    Case K_CHEQUES, K_EFECTIVO, K_TARJETA, K_OTROS
      cIABMClientGrid_ColumnAfterEdit = True
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
    Case K_CHEQUES
      cIABMClientGrid_ColumnBeforeEdit = True
    Case K_TARJETA
      cIABMClientGrid_ColumnBeforeEdit = pColBeforeEditTarjeta(Key, lRow, lCol, iKeyAscii)
    Case K_OTROS
      cIABMClientGrid_ColumnBeforeEdit = True
    Case K_EFECTIVO
      cIABMClientGrid_ColumnBeforeEdit = True
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnBeforeEdit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pColBeforeEditTarjeta(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  Dim Row As cIABMGridRow
  Dim IProperty As cIABMProperty
  Set IProperty = m_ObjAbm.Properties(c_Tarjeta)
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KIT_TJCCU_ID
        Set Row = .Rows(lRow)
        SetFilterCuotas Row, IProperty, m_ObjAbm, KIT_TJC_ID
    End Select
  End With
  pColBeforeEditTarjeta = True
End Function

Private Function pColumnBeforeEdit(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
  pColumnBeforeEdit = True
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
  If m_cj_id Then
    cIABMClientGrid_DeleteRow = False
  Else
    cIABMClientGrid_DeleteRow = True
  End If
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_CHEQUES
      cIABMClientGrid_ValidateRow = pValidateRowCheques(Row, RowIndex)
    Case K_TARJETA
      cIABMClientGrid_ValidateRow = pValidateRowTarjetas(Row, RowIndex)
    Case K_OTROS
      cIABMClientGrid_ValidateRow = pValidateRowOtros(Row, RowIndex)
    Case K_EFECTIVO
      cIABMClientGrid_ValidateRow = pValidateRowEfectivo(Row, RowIndex)
    Case K_CTA_CTE
      cIABMClientGrid_ValidateRow = True
    Case K_COBROS_PENDIENTES
      cIABMClientGrid_ValidateRow = True
    Case K_LIST_COBRADO
      cIABMClientGrid_ValidateRow = True
    Case K_DETALLE_COBRADO
      cIABMClientGrid_ValidateRow = True
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' funciones privadas
Private Function LoadCollection(ByVal bModal As Boolean) As Boolean
  Dim iTab        As cIABMTabItem
  Dim c           As cIABMProperty
  Dim AbmGen      As cABMGeneric
  Dim oProp       As cABMProperty
  
  Set AbmGen = m_ObjAbm

  AbmGen.SaveCaption = LNGGetText(4822, vbNullString) ' &Guardar
  AbmGen.CancelCaption = LNGGetText(4823, vbNullString) ' &Cancelar
  
  AbmGen.tabTopHeight = 4350
  AbmGen.MinHeight = 8000
  
  AbmGen.bDontAskForSave = True
  
  m_ObjAbm.Tabs.Clear
    
  Dim c_TabCobrosPendientes As Integer
  Dim c_TabEfectivo As Integer
  Dim c_TabCheque As Integer
  Dim c_TabTarjeta As Integer
  Dim c_TabOtros As Integer
  Dim c_TabCtaCte As Integer
  Dim c_tabCobrado As Integer
  Dim c_tabDetalleCobrado As Integer
    
  If m_bCobranzaCdo Then
    
    c_TabEfectivo = 0
    c_TabCheque = 1
    c_TabTarjeta = 2
    c_TabOtros = 3
  
  Else
  
    c_TabCobrosPendientes = 0
    c_TabEfectivo = 1
    c_TabCheque = 2
    c_TabTarjeta = 3
    c_TabOtros = 4
    c_TabCtaCte = 5
    c_tabCobrado = 6
    c_tabDetalleCobrado = 7
  
  End If
  
  AbmGen.tabHideCtrlsInAllTab = c_TabCtaCte
      
  If Not m_bCobranzaCdo Then
    Set iTab = m_ObjAbm.Tabs.Add(Nothing)
    iTab.Index = c_TabCobrosPendientes
    iTab.name = LNGGetText(5109, vbNullString)  'Cobros Pendientes
  End If
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = c_TabEfectivo
  iTab.name = LNGGetText(2100, vbNullString)  'Efectivo
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = c_TabCheque
  iTab.name = LNGGetText(2099, vbNullString)  'Cheques
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = c_TabTarjeta
  iTab.name = LNGGetText(2101, vbNullString)  'Tarjetas
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = c_TabOtros
  iTab.name = LNGGetText(1070, vbNullString)  'Otros
    
  If Not m_bCobranzaCdo Then
  
    Set iTab = m_ObjAbm.Tabs.Add(Nothing)
    iTab.Index = c_TabCtaCte
    iTab.name = LNGGetText(5110, vbNullString)  'En Cuenta Corriente
    
    Set iTab = m_ObjAbm.Tabs.Add(Nothing)
    iTab.Index = c_tabCobrado
    iTab.name = LNGGetText(5117, vbNullString)  'Cobranzas Realizadas
    
    Set iTab = m_ObjAbm.Tabs.Add(Nothing)
    iTab.Index = c_tabDetalleCobrado
    iTab.name = LNGGetText(5120, vbNullString)  'Resumen de Cobranzas
  
  End If
  
  AbmGen.ResetLayoutMembers
  m_ObjAbm.Properties.Clear
  
  With m_ObjAbm.Properties.Add(Nothing, cscFvFecha)
    .PropertyType = cspDate
    .Value = m_Fecha
    .Visible = False
    .TopNotChange = True
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscDocId)
    .PropertyType = cspHelp
    .Table = CSDocumento
    .Value = m_Documento
    .HelpId = m_doc_id
    .Visible = False
    .TopNotChange = True
  End With

  Set c = m_ObjAbm.Properties.Add(Nothing, cscFvTotal)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.name = LNGGetText(2147, vbNullString)  'A cobrar
  c.Key = K_ACOBRAR
  c.Value = m_FvTotal
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  c.TabIndex = csETabIdxT_All
  c.left = 1200
  c.LeftLabel = -700
  c.Width = 1100
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCobzNeto)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.name = LNGGetText(1581, vbNullString)  'Neto
  c.Key = K_NETO
  c.Value = m_Neto
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  c.TabIndex = csETabIdxT_All
  c.TopFromProperty = cscFvTotal
  c.left = 2900
  c.LeftLabel = -400
  c.Width = 1100
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCobzOtros)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.name = LNGGetText(1070, vbNullString)  'Otros
  c.Key = K_OTROS
  c.Value = m_Otros
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  c.TabIndex = csETabIdxT_All
  c.TopFromProperty = cscFvTotal
  c.left = 4600
  c.LeftLabel = -450
  c.Width = 1100
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCobzTotal)
  c.PropertyType = cspNumeric
  c.Format = m_GeneralConfig.FormatDecImporte
  c.name = LNGGetText(1584, vbNullString)  'Total
  c.SubType = cspMoney
  c.Key = K_TOTAL
  c.Value = m_Total
  c.Enabled = False
  c.TabIndex = csETabIdxT_All
  c.TopFromProperty = cscFvTotal
  c.left = 6350
  c.LeftLabel = -500
  c.Width = 1100
    
  '/////////////////////////////////////////////////////////////////
  ' EFECTIVO
  Set c = m_ObjAbm.Properties.Add(Nothing, c_Efectivo)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  
  If Not pLoadEfectivo(c) Then Exit Function
  c.name = c_Efectivo
  c.Key = K_EFECTIVO
  c.TabIndex = c_TabEfectivo
  c.GridEdit = True
  If m_cj_id Then
    c.GridAdd = False
    c.GridRemove = False
  Else
    c.GridAdd = True
    c.GridRemove = True
  End If
  c.TopFromProperty = cscFvTotal
  c.TopToPrevious = 440
  c.left = 360
      
  '/////////////////////////////////////////////////////////////////
  ' CHEQUES
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_Cheques)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  
  If Not pLoadCheques(c) Then Exit Function
  c.name = c_Cheques
  c.Key = K_CHEQUES
  c.TabIndex = c_TabCheque
  c.GridEdit = True
  c.GridAdd = True
  If m_cj_id Then
    c.GridRemove = False
  Else
    c.GridRemove = True
  End If
  c.left = 360
    
  Set c = m_ObjAbm.Properties.Add(Nothing)
  c.PropertyType = cspButton
  c.name = "Copiar Cheque"
  c.Key = K_COPY_CHEQUE
  c.left = 11500
  c.Width = 1500
  c.LeftLabel = -1
  c.LeftNotChange = True
  c.TabIndex = c_TabCheque
  c.TopFromProperty = cscFvTotal
    
  '/////////////////////////////////////////////////////////////////
  ' TARJETAS
  Set c = m_ObjAbm.Properties.Add(Nothing, c_Tarjeta)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  
  If Not pLoadTarjetas(c) Then Exit Function
  c.name = c_Tarjeta
  c.Key = K_TARJETA
  c.TabIndex = c_TabTarjeta
  c.GridEdit = True
  If m_cj_id Then
    c.GridAdd = False
    c.GridRemove = False
  Else
    c.GridAdd = True
    c.GridRemove = True
  End If
  c.left = 360
        
  '/////////////////////////////////////////////////////////////////
  ' OTROS
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_Otros)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  
  If Not pLoadOtros(c) Then Exit Function
  c.name = c_Otros
  c.Key = K_OTROS
  c.TabIndex = c_TabOtros
  c.GridAdd = True
  c.GridEdit = True
  c.GridRemove = True
  c.left = 360
  
  If Not m_bCobranzaCdo Then

    '/////////////////////////////////////////////////////////////////
    ' Cobros Pendientes
    
    Set c = m_ObjAbm.Properties.Add(Nothing, c_CobrosPendientes)
    c.PropertyType = cspGrid
    c.LeftLabel = -1
    
    If Not pLoadCobros(c) Then Exit Function
    c.name = c_CobrosPendientes
    c.Key = K_COBROS_PENDIENTES
    c.TabIndex = c_TabCobrosPendientes
    c.GridAdd = False
    c.GridEdit = False
    c.GridRemove = False
    c.left = 360
    
    With m_ObjAbm.Properties.Add(Nothing, c_cmd_ctacte)
      .PropertyType = cspButton
      .name = LNGGetText(5116, vbNullString) 'Enviar a Cuenta Corriente
      .Key = K_CMD_CTACTE
      .TabIndex = c_TabCobrosPendientes
      .TopFromProperty = cscFvTotal
      .left = 10000
      .Width = 2000
      .TopToPrevious = -40
      .LeftLabel = -1
    End With
    
    '/////////////////////////////////////////////////////////////////
    ' Cuenta Corriente
    
    Set c = m_ObjAbm.Properties.Add(Nothing, c_CtaCte)
    c.PropertyType = cspGrid
    c.LeftLabel = -1
    
    If Not pLoadCobros(c) Then Exit Function
    c.name = c_CtaCte
    c.Key = K_CTA_CTE
    c.TabIndex = c_TabCtaCte
    c.GridAdd = False
    c.GridEdit = False
    c.GridRemove = False
    c.left = 360
      
    Set c = m_ObjAbm.Properties.Add(Nothing, c_filtro_cobrado)
    With c
      .name = LNGGetText(2826, vbNullString) 'Filtro
      .PropertyType = cspText
      .TabIndex = c_TabCtaCte
      .Value = vbNullString
      .Key = K_FILTER
      .Width = 3500
      .TopFromProperty = cscFvTotal
    End With
          
    With m_ObjAbm.Properties.Add(Nothing)
      .PropertyType = cspButton
      .TopFromProperty = c_filtro_cobrado
      .left = 4000
      .LeftNotChange = True
      .TopNotChange = True
      .LeftLabel = -1
      .name = LNGGetText(3432, vbNullString) 'Filtrar
      .TabIndex = c_TabCtaCte
      .Key = K_CMD_FILTER
    End With
      
    ' esto tiene que estar despues de agregar la propiedad filtro
    '
    If Not pLoadDataCobros(c, False) Then Exit Function
    If Not pLoadDataCobros(c, True) Then Exit Function
      
    '/////////////////////////////////////////////////////////////////
    ' Listado de Cobros
    
    Set c = m_ObjAbm.Properties.Add(Nothing, c_list_cobrado)
    c.PropertyType = cspGrid
    c.LeftLabel = -1
    
    If Not pLoadMovimientos(c) Then Exit Function
    pLoadMovimientosXCjId c, True
    
    c.name = c_list_cobrado
    c.Key = K_LIST_COBRADO
    c.TabIndex = c_tabCobrado
    c.GridAdd = False
    c.GridEdit = False
    c.GridRemove = False
    c.left = 360
    
    Set c = m_ObjAbm.Properties.Add(Nothing, c_detalle_cobrado)
    c.PropertyType = cspGrid
    c.LeftLabel = -1
    
    If Not pLoadCajaCuentas(c) Then Exit Function
    pLoadCajaCuentaImportesXCjId c, True
    
    c.name = c_list_cobrado
    c.Key = K_DETALLE_COBRADO
    c.TabIndex = c_tabDetalleCobrado
    c.GridAdd = False
    c.GridEdit = False
    c.GridRemove = False
    c.left = 360

  End If
  
  ' Info
  '
  
  With m_ObjAbm.Properties.Add(Nothing)
    .PropertyType = cspLabel
    .BackColor = RGB(&HFF, &HAA, &H0)
    .left = 280
    .Width = 13000
    .Top = 600
    .Height = 2890
    .TabIndex = csETabIdxT_All2
  End With
  
  With m_ObjAbm.Properties.Add(Nothing)
    .PropertyType = cspLabel
    .BackColor = RGB(&HEA, &HEA, &HEA)
    .left = 300
    .Width = 12970
    .Top = 620
    .Height = 2860
    .TabIndex = csETabIdxT_All2
  End With
    
  With m_ObjAbm.Properties.Add(Nothing, cscCliId)
    .PropertyType = cspLabel
    .name = LNGGetText(1150, vbNullString)  'Cliente
    .Value = m_apodo
    .Width = 2500
    .FontBold = True
    .left = 600
    .Top = 700
    .TabIndex = csETabIdxT_All2
  End With
    
  With m_ObjAbm.Properties.Add(Nothing, cscCliNombre)
    .PropertyType = cspLabel
    .Value = m_cliente
    .FontBold = True
    .left = 3400
    .Top = 700
    .Height = 220
    .Width = 4000
    .TabIndex = csETabIdxT_All2
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscFvNrodoc)
    .PropertyType = cspLabel
    .name = LNGGetText(1610, vbNullString)  'Comprobante
    .Value = m_factura
    .Width = 3000
    .FontBold = True
    .left = 7400
    .Top = 700
    .TabIndex = csETabIdxT_All2
  End With
  
  With m_ObjAbm.Properties.Add(Nothing)
    .PropertyType = cspLabel
    .Value = LNGGetText(2147, vbNullString) 'A cobrar
    .left = 10400
    .Width = 700
    .Top = 700
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_acobrar)
    .PropertyType = cspLabel
    .Value = Format(m_FvTotal, m_GeneralConfig.FormatDecImporte)
    .Width = 1500
    .FontBold = True
    
    .left = 11100
    .LeftLabel = -700
    .Top = 700
    .FontSize = 14
    .Height = 370
    .Width = 2000
    .BackColor = RGB(&HFF, &HAA, &H0)
    .TextAlign = vbRightJustify
    .TabIndex = csETabIdxT_All2
  End With
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_cobrado)
  c.PropertyType = cspText
  c.name = LNGGetText(3957, vbNullString)  'Recibido
  c.Key = K_COBRADO
  c.Value = vbNullString
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = True
  c.TabIndex = csETabIdxT_All2
  c.LeftLabel = -700
  c.left = 11100
  c.Width = 2000
  c.Top = 1180
  c.Height = 400
  c.FontSize = 14
  c.TopNotChange = True
  c.LeftNotChange = True
  c.TextAlign = vbRightJustify
  
  With m_ObjAbm.Properties.Add(Nothing)
    .PropertyType = cspLabel
    .Value = LNGGetText(3553, vbNullString)  'Cambio
    .left = 10400
    .Width = 700
    .Top = 1650
  End With
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_cambio)
  c.PropertyType = cspLabel
  c.Key = K_CAMBIO
  c.Value = Format(0, m_GeneralConfig.FormatDecImporte)
  c.FontBold = True
  c.TabIndex = csETabIdxT_All2
  c.LeftLabel = -700
  c.left = 11100
  c.Top = 1650
  c.FontSize = 14
  c.Height = 400
  c.Width = 2000
  c.TextAlign = vbRightJustify
  c.BackColor = RGB(&HFF, &HAA, &H0)
    
  With m_ObjAbm.Properties.Add(Nothing, c_pedidos)
    .PropertyType = cspText
    .SubType = cspMemo
    .name = LNGGetText(1150, vbNullString)  'Pedidos
    .Value = m_venta
    .Width = 9500
    .left = 600
    .Top = 1000
    .Height = 800
    .Enabled = False
    .TabIndex = csETabIdxT_All2
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_cvxi_pago)
    .PropertyType = cspText
    .SubType = cspMemo
    .name = LNGGetText(1150, vbNullString)  'Mercado Pago
    .Value = m_pago
    .Width = 9500
    .left = 600
    .Top = 1900
    .Height = 1500
    .Enabled = False
    .TabIndex = csETabIdxT_All2
  End With
  
  ' Pagos
  '
  
  With m_ObjAbm.Properties.Add(Nothing)
    .PropertyType = cspLabel
    .BackColor = RGB(&HFF, &HAA, &H0)
    .left = 280
    .Width = 13000
    .Top = 3630
    .Height = 590
    .TabIndex = csETabIdxT_All2
  End With
  
  With m_ObjAbm.Properties.Add(Nothing)
    .PropertyType = cspLabel
    .BackColor = vbWhite
    .left = 300
    .Width = 12970
    .Top = 3640
    .Height = 550
    .TabIndex = csETabIdxT_All2
  End With
  
  With m_ObjAbm.Properties.Add(Nothing)
    .PropertyType = cspButton
    .name = LNGGetText(5113, vbNullString) ' Refrezcar Facturas
    .Key = K_REFRESH
    .left = 10850
    .Top = 3750
    .LeftLabel = -1
    .Width = 2200
    .TabIndex = csETabIdxT_All2
  End With
  
  pAddModoPago
      
  pShowCobroNeto False
  pShowCobroTotal False
  
  m_Editing = True
  
  ' Si trabaja en modo modal es por que viene desde una factura de venta
  '
  If bModal Then
  
    m_ObjAbm.InModalWindow = True
    AbmGen.OkCancelDialog = True
    AbmGen.bSendAutoSave = m_bAutoPago
  
    If Not m_ObjAbm.Show(Me) Then Exit Function

    If m_Id <> csNO_ID Then
      If m_UserCfg.PrintInNewCobzCdo Then
       
        AbmGen.AutoPrint = m_UserCfg.NoAskInPrint
       
        AbmGen.PrintDocumentoCobranzaCdo Me
      
      End If
    End If
  
  ' Sino, es por que estamos en la ventana de cobranzas del cajero
  '
  Else
    
    AbmGen.bSendRefresh = True
    If Not m_ObjAbm.Show(Me) Then Exit Function
    AbmGen.Frm.cmdCancel.Visible = False
  
  End If
  
  LoadCollection = True
End Function

Private Function pLoadCobros(ByRef Propiedad As cIABMProperty) As Boolean
  
  With Propiedad.Grid.Columns
  
    .Clear
  
    With .Add(Nothing)
      .Visible = False
      .Key = KIFV_ID
    End With
  
    With .Add(Nothing)
      .name = LNGGetText(1150, vbNullString)  'Cliente
      .PropertyType = cspText
      .Key = KIFV_CLIENTE
    End With
  
    With .Add(Nothing)
      .name = LNGGetText(1584, vbNullString)  'Total
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Format = m_GeneralConfig.FormatDecImporte
      .Key = KIFV_TOTAL
    End With
  
    With .Add(Nothing)
      .name = LNGGetText(1610, vbNullString)  'Comprobante
      .PropertyType = cspText
      .Key = KIFV_COMPROBANTE
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(1037, vbNullString) ' Direccion
      .PropertyType = cspText
      .Key = KIFV_DIRECCION
    End With
  
    Dim oCol As cABMGridColumn
    Dim iCol As cIABMGridColumn
    Set iCol = .Add(Nothing)
    Set oCol = iCol
    With iCol
      .name = LNGGetText(1861, vbNullString)  'Observaciones
      .PropertyType = cspText
      .Key = KIFV_DESCRIP
      .Width = 7000
      oCol.IsDetail = True
    End With
    
  End With
  
  Propiedad.Grid.Rows.Clear
  
  pLoadCobros = True
End Function

Private Function pLoadDataCobros(ByRef Propiedad As cIABMProperty, ByVal CtaCte As Boolean) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset

  sqlstmt = "sp_DocCobranzaCdoGetFacturas " _
                             & m_cj_id & "," _
                             & IIf(CtaCte, 1, 0) & "," _
                             & gDB.sqlString(pGetFilter().Value)
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function

  With Propiedad.Grid.Rows

    .Clear

    Dim i As Long
    Dim iFormat As cIABMGridCellFormat
    Dim oFormat As cABMGridCellFormat
    Set iFormat = New cABMGridCellFormat
    Set oFormat = iFormat
        
    oFormat.FontName = "Tahoma"
    oFormat.FontSize = 8
    iFormat.Color = vbBlue

    Dim iFormatNroDoc As cIABMGridCellFormat
    Set iFormatNroDoc = New cABMGridCellFormat
    Set oFormat = iFormatNroDoc

    oFormat.FontName = "Tahoma"
    oFormat.FontSize = 9
    oFormat.Bold = True
    iFormatNroDoc.Color = vbRed

    Dim iFormatImporte As cIABMGridCellFormat
    Set iFormatImporte = New cABMGridCellFormat
    Set oFormat = iFormatImporte

    oFormat.FontName = "MS Sans Serif"
    oFormat.FontSize = 14
    oFormat.Bold = True
    oFormat.Align = 2 'DT_RIGHT
    iFormatImporte.BackColor = RGB(&HFF, &HAA, &H0)

    While Not rs.EOF
    
      i = i + 1
    
      Dim iRow As cIABMGridRow
      Dim oRow As cABMGridRow
      
      Set iRow = .Add(Nothing, rs(cscFvId).Value)
      Set oRow = iRow
    
      With iRow
      
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscFvId)
          .Key = KIFV_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscCliNombre)
          .Key = KIFV_CLIENTE
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscFvTotal)
          .Key = KIFV_TOTAL
          Set .Format = iFormatImporte
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscFvNrodoc)
          .Key = KIFV_COMPROBANTE
          Set .Format = iFormatNroDoc
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, "direccion")
          .Key = KIFV_DIRECCION
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscFviDescrip)
          .Key = KIFV_DESCRIP
          Set .Format = iFormat
        End With
        
        If i Mod 2 = 1 Then
          oRow.BackColor = 12639458
        End If
        
      End With
      
      rs.MoveNext
    Wend

  End With

  pLoadDataCobros = True
End Function

Private Function pLoadOtros(ByRef Propiedad As cIABMProperty) As Boolean
  
  With Propiedad.Grid.Columns
  
    .Clear
  
    With .Add(Nothing)
      .Visible = False
      .Key = KIO_COBZI_ID
    End With
  
    With .Add(Nothing)
      .name = LNGGetText(1267, vbNullString)  'Cuenta
      .PropertyType = cspHelp
      .Table = csCuenta
      .Width = 2200
      .Key = KIO_CUE_ID
      If m_cj_id Then
        .HelpFilter = "(emp_id = " & EmpId & " or emp_id is null) and " & _
                      "(exists(select * from cajacuenta where cue_id_trabajo = cue_id))"
      Else
        .HelpFilter = "(emp_id = " & EmpId & " or emp_id is null)"
      End If
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(1904, vbNullString)  'Debe
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KIO_DEBE
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(1905, vbNullString)  'Haber
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KIO_HABER
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(1901, vbNullString)  'Origen
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KIO_IMPORTEORIGEN
    End With
    
    With .Add(Nothing)
      .name = C_strDescrip
      .PropertyType = cspText
      .SubType = cspTextButtonEx
      .Width = 1000
      .Key = KIO_DESCRIP
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(1403, vbNullString)  'Retención
      .PropertyType = cspHelp
      .Table = csRetencion
      .Width = 1500
      .Key = KIO_RET_ID
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(2103, vbNullString)  'C. Retención
      .PropertyType = cspText
      .Width = 1200
      .Key = KIO_NRORETENCION
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(2104, vbNullString)  '% Retención
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .Width = 1200
      .Key = KIO_PORCRETENCION
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(1634, vbNullString)  'Vto.
      .PropertyType = cspDate
      .Width = 920
      .Key = KIO_FECHARETENCION
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(1057, vbNullString)  'Centro de Costo
      .PropertyType = cspHelp
      .Table = csCentroCosto
      .Width = 1800
      .Key = KIO_CCOS_ID
    End With
  End With
  
  Propiedad.Grid.Rows.Clear
  
  pLoadOtros = True
End Function

Private Function pLoadCheques(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  ' Cargamos la cuenta para tenerla antes de crear la columna
  ' pues necesitamos dar un default
  '
  If m_cj_id Then
  
    sqlstmt = "sp_DocCobranzaCdoGetCuenta " & m_cj_id & "," & EmpId & ",3" ' Cheques
  
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  End If
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
  
    With .Columns
      
      With .Add(Nothing)
        .Visible = False
        .Key = KICH_COBZI_ID
      End With
    
      With .Add(Nothing)
        .name = LNGGetText(1267, vbNullString)  'Cuenta
        .PropertyType = cspHelp
        .Table = csCuenta
        
        '.HelpFilter = "(" & cscCuecId & "=" & csECuecBancos & " or " & _
                            cscCuecId & "=" & csECuecDocEnCartera & ")"
        .HelpFilter = GetHelpFilterCheques()
        
        .Width = 2200
        .Key = KICH_CUE_ID
        
        If m_cj_id Then
        
          If Not rs.EOF Then
            
            Set .DefaultValue = New cABMGridRowValue
            With .DefaultValue
              .Value = gDB.ValField(rs.fields, cscCueNombre)
              .id = gDB.ValField(rs.fields, cscCueId)
            End With
          End If
        
        End If
        
        .Enabled = m_cj_id = csNO_ID
        
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(2063, vbNullString)  'Mon
        .PropertyType = cspHelp
        .Table = csMoneda
        .Width = 520
        .Key = KICH_MON_ID
        .Enabled = False
        
        If m_cj_id Then
        
          If Not rs.EOF Then
            
            Set .DefaultValue = New cABMGridRowValue
            With .DefaultValue
              .Value = gDB.ValField(rs.fields, cscMonNombre)
              .id = gDB.ValField(rs.fields, cscMonId)
            End With
          End If
        End If
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1901, vbNullString)  'Origen
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 920
        .Key = KICH_IMPORTEORIGEN
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1228, vbNullString)  'Importe
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 920
        .Key = KICH_IMPORTE
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1122, vbNullString)  'Banco
        .PropertyType = cspHelp
        .Table = csBanco
        .Width = 1620
        .Key = KICH_BCO_ID
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(3719, vbNullString)  'Propio
        .PropertyType = cspCheck
        .Width = 1000
        .Key = KICH_PROPIO
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1281, vbNullString)  'Sucursal
        .PropertyType = cspText
        .Width = 1500
        .Key = KICH_SUCURSAL
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(2059, vbNullString)  'Nro. Cheque
        .PropertyType = cspText
        .Width = 1000
        .Key = KICH_CHEQUE
      End With
            
      With .Add(Nothing)
        .name = LNGGetText(2065, vbNullString)  'Depositar el
        .PropertyType = cspDate
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Value = Date
        .Width = 970
        .Key = KICH_FECHACOBRO
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1634, vbNullString)  'Vto.
        .PropertyType = cspDate
        .Width = 970
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Value = DateAdd("m", 1, Date)
        .Key = KICH_FECHAVTO
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1083, vbNullString)  'Clering
        .PropertyType = cspHelp
        .Table = csClearing
        .Width = 800
        .Key = KICH_CLE_ID
      End With
      
      With .Add(Nothing)
        .name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 1600
        .Key = KICH_DESCRIP
      End With
    End With
    
  End With

  Propiedad.Grid.Rows.Clear
  
  pLoadCheques = True
End Function

Private Function pLoadEfectivo(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim bFirst  As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim MonId   As Long
  Dim Moneda  As String
  
  With Propiedad.Grid.Columns
  
    .Clear
    
    With .Add(Nothing)
      .Visible = False
      .Key = KIE_COBZI_ID
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(1267, vbNullString)  'Cuenta
      .PropertyType = cspHelp
      .Table = csCuenta
      
      '.HelpFilter = cscCuecId & "=" & csECuecCaja & " or " & cscCuecId & "=" & csECuecBancos
      .HelpFilter = GetHelpFilterEfectivo()
      
      .Width = 3000
      .Key = KIE_CUE_ID
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(2063, vbNullString)  'Mon
      .PropertyType = cspHelp
      .Table = csMoneda
      .Width = 520
      .Key = KIE_MON_ID
      .Enabled = False
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(1901, vbNullString)  'Origen
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KIE_IMPORTEORIGEN
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(1228, vbNullString)  'Importe
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KIE_IMPORTE
    End With
    
    With .Add(Nothing)
      .name = C_strDescrip
      .PropertyType = cspText
      .SubType = cspTextButtonEx
      .Width = 2500
      .Key = KIE_DESCRIP
    End With
  End With
    
  Propiedad.Grid.Rows.Clear
  
  If m_bAutoPago And m_cue_id_autoPago Then
  
    With Propiedad.Grid.Rows
      
      With .Add(Nothing)
        
        .Add(Nothing).Key = KIE_COBZI_ID
      
        Dim cue_nombre_autoPago As String
        gDB.GetData csTCuenta, cscCueId, m_cue_id_autoPago, cscCueNombre, cue_nombre_autoPago
        
        With .Add(Nothing)
          .Value = cue_nombre_autoPago
          .id = m_cue_id_autoPago
          .Key = KIE_CUE_ID
        End With
        
        GetMonedaFromCuenta MonId, Moneda, m_UserCfg.CueIdFvoxDefecto
      
        With .Add(Nothing)
          .Value = MonId
          .Value = Moneda
          .Key = KIE_MON_ID
        End With
        
        With .Add(Nothing)
          .Value = 0
          .Key = KIE_IMPORTEORIGEN
        End With
        
        With .Add(Nothing)
          .Value = Val(pGetTotal().Value) - Val(pGetCobroTotal().Value)
          .Key = KIE_IMPORTE
        End With
        
        With .Add(Nothing)
          .Value = vbNullString
          .Key = KIE_DESCRIP
        End With
      
      End With
    End With
  
  ElseIf m_cj_id Then
  
    sqlstmt = "sp_DocCobranzaCdoGetCuenta " & m_cj_id & "," & EmpId & ",1" ' Efectivo
  
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    
    bFirst = True
    
    With Propiedad.Grid.Rows
    
      While Not rs.EOF
      
        With .Add(Nothing)
          
          .Add(Nothing).Key = KIE_COBZI_ID
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCueNombre)
            .id = gDB.ValField(rs.fields, cscCueId)
            .Key = KIE_CUE_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscMonNombre)
            .id = gDB.ValField(rs.fields, cscMonId)
            .Key = KIE_MON_ID
          End With
          
          With .Add(Nothing)
            .Value = 0
            .Key = KIE_IMPORTEORIGEN
          End With
          
          With .Add(Nothing)
            If bFirst And Not m_bIsCobranzaCajero Then
              .Value = Val(pGetTotal().Value) - Val(pGetCobroTotal().Value)
            Else
              .Value = 0
            End If
            .Key = KIE_IMPORTE
          End With
          
          With .Add(Nothing)
            .Value = vbNullString
            .Key = KIE_DESCRIP
          End With
        
          bFirst = False
        End With

        rs.MoveNext
      Wend
    End With
  
  Else
  
    If m_UserCfg.CueIdFvoxDefecto Then
    
      With Propiedad.Grid.Rows
        
        With .Add(Nothing)
          
          .Add(Nothing).Key = KIE_COBZI_ID
        
          With .Add(Nothing)
            .Value = m_UserCfg.CuentaFvoxDefecto
            .id = m_UserCfg.CueIdFvoxDefecto
            .Key = KIE_CUE_ID
          End With
          
          GetMonedaFromCuenta MonId, Moneda, m_UserCfg.CueIdFvoxDefecto
        
          With .Add(Nothing)
            .Value = MonId
            .Value = Moneda
            .Key = KIE_MON_ID
          End With
          
          With .Add(Nothing)
            .Value = 0
            .Key = KIE_IMPORTEORIGEN
          End With
          
          With .Add(Nothing)
            .Value = Val(pGetTotal().Value) - Val(pGetCobroTotal().Value)
            .Key = KIE_IMPORTE
          End With
          
          With .Add(Nothing)
            .Value = vbNullString
            .Key = KIE_DESCRIP
          End With
        
        End With
      End With
    
    End If
  
  End If
  
  pLoadEfectivo = True
End Function

Private Function pLoadTarjetas(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  With Propiedad.Grid.Columns
  
    .Clear
  
    With .Add(Nothing)
      .Visible = False
      .Key = KIT_COBZI_ID
    End With
  
    With .Add(Nothing)
      .name = LNGGetText(2105, vbNullString)  'Cupon
      .PropertyType = cspText
      .Width = 1500
      .Key = KIT_CUPON
    End With
  
    With .Add(Nothing)
      .name = LNGGetText(2106, vbNullString)  'Tarjeta
      .PropertyType = cspHelp
      .Table = csTarjetaCredito
      .Width = 1800
      .Key = KIT_TJC_ID
    End With
    
    With .Add(Nothing, c_Cuotas)
      .name = LNGGetText(1473, vbNullString)  'Cuotas
      .PropertyType = cspHelp
      .Table = csTarjetaCreditoCuota
      .Width = 1800
      .Key = KIT_TJCCU_ID
    End With
    m_lColCuotas = .count

    With .Add(Nothing)
      .name = LNGGetText(2063, vbNullString)  'Mon
      .PropertyType = cspHelp
      .Table = csMoneda
      .Width = 520
      .Key = KIT_MON_ID
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(1901, vbNullString)  'Origen
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KIT_IMPORTEORIGEN
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(1228, vbNullString)  'Importe
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KIT_IMPORTE
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(1634, vbNullString)  'Vto.
      .PropertyType = cspDate
      Set .DefaultValue = New cABMGridRowValue
      .DefaultValue.Value = DateAdd("d", 1, Date)
      .Width = 970
      .Key = KIT_FECHAVTO
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(2107, vbNullString)  'Nro. Tarjeta
      .PropertyType = cspText
      .Width = 1300
      .Key = KIT_NROTARJETA
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(2123, vbNullString)  'Cod. Autoriz.
      .PropertyType = cspText
      .Width = 1000
      .Key = KIT_NROAUTORIZACION
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(2108, vbNullString)  'Operacion
      .PropertyType = cspList
      With .List.Add(Nothing)
        .id = csECuponPosnet
        .Value = LNGGetText(2110, vbNullString)  'Posnet
      End With
      With .List.Add(Nothing)
        .id = csECuponManual
        .Value = LNGGetText(2111, vbNullString)  'Manual
      End With
      Set .DefaultValue = New cABMGridRowValue
      .DefaultValue.id = csECuponPosnet
      .Width = 1000
      .Key = KIT_TARJETA_TIPO
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(2109, vbNullString)  'Titular
      .PropertyType = cspText
      .Width = 1000
      .Key = KIT_TITULAR
    End With
    
    With .Add(Nothing)
      .name = C_strDescrip
      .PropertyType = cspText
      .SubType = cspTextButtonEx
      .Width = 1300
      .Key = KIT_DESCRIP
    End With
  End With
  
  Propiedad.Grid.Rows.Clear
  
  If m_cj_id Then
  
    sqlstmt = "sp_DocCobranzaCdoGetCuenta " & m_cj_id & "," & EmpId & ",2" ' Tarjeta
  
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
        
    With Propiedad.Grid.Rows
    
      While Not rs.EOF
      
        With .Add(Nothing)
          
          .Add(Nothing).Key = KIT_COBZI_ID
          .Add(Nothing).Key = KIT_CUPON
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscTjcNombre)
            .id = gDB.ValField(rs.fields, cscTjcId)
            .Key = KIT_TJC_ID
          End With
          
          .Add(Nothing).Key = KIT_TJCCU_ID
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscMonNombre)
            .id = gDB.ValField(rs.fields, cscMonId)
            .Key = KIT_MON_ID
          End With
          
          .Add(Nothing).Key = KIT_IMPORTEORIGEN
          .Add(Nothing).Key = KIT_IMPORTE
          .Add(Nothing).Key = KIT_FECHAVTO
          .Add(Nothing).Key = KIT_NROTARJETA
          .Add(Nothing).Key = KIT_NROAUTORIZACION
          
          With .Add(Nothing)
            .id = csECuponPosnet
            .Key = KIT_TARJETA_TIPO
          End With
    
          .Add(Nothing).Key = KIT_TITULAR
          .Add(Nothing).Key = KIT_DESCRIP

        End With

        rs.MoveNext
      Wend
    End With
  
  End If
  
  pLoadTarjetas = True
End Function

' Reglas del Objeto de Negocios

Private Function pGetCueIdCliente(ByRef Cue_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  ' Cuenta contable del cliente
  sqlstmt = "sp_DocGetCueId " & m_cli_id & "," & m_doc_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function

  If rs.EOF Then Exit Function

  Cue_id = gDB.ValField(rs.fields, cscCueId)
  
  pGetCueIdCliente = True
End Function

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
  cIDocumento_LoadForPrint = False
End Function

' Construccion - Destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2098, vbNullString) 'Error al grabar la Cobranza
  
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  m_MonDefault = GetMonedaDefault()

  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load

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
  Set m_GeneralConfig = Nothing

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

'////////////////////////////////////////////////////////////
Private Function pSaveCheques(ByVal id As Long) As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  
  For Each Row In pGetCheques().Rows
  
    If Val(pCell(Row, KICH_IMPORTE).Value) Then
  
      Set register = New cRegister
      register.fieldId = cscCobziTMPId
      register.Table = csTCobranzaItemTMP
      register.id = csNew
      
      register.fields.Add2 cscCheqId, csNew, csId
  
      For Each Cell In Row
        Select Case Cell.Key
        
          Case KICH_COBZI_ID
            register.fields.Add2 cscCobziId, csNew, csInteger
          
          Case KICH_DESCRIP
            register.fields.Add2 cscCobziDescrip, Cell.Value, csText
          
          Case KICH_CHEQUE
            register.fields.Add2 cscCobziTMPCheque, Cell.Value, csText
          
          Case KICH_CLE_ID
            register.fields.Add2 cscCleId, Cell.id, csId
          
          Case KICH_BCO_ID
            register.fields.Add2 cscBcoId, Cell.id, csId
          
          Case KICH_PROPIO
            register.fields.Add2 cscCobziTMPPropio, Cell.id, csBoolean
            
          Case KICH_SUCURSAL
            register.fields.Add2 cscCobziTMPSucursal, Cell.Value, csText
          
          Case KICH_MON_ID
            register.fields.Add2 cscMonId, Cell.id, csId
          
          Case KICH_FECHACOBRO
            register.fields.Add2 cscCobziTMPFechaCobro, Cell.Value, csDate
          
          Case KICH_FECHAVTO
            register.fields.Add2 cscCobziTMPFechaVto, Cell.Value, csDate
          
          Case KICH_CUE_ID
            register.fields.Add2 cscCueId, Cell.id, csId
          
          Case KICH_IMPORTEORIGEN
            register.fields.Add2 cscCobziImporteOrigen, Val(Cell.Value), csCurrency
          
          Case KICH_IMPORTE
            register.fields.Add2 cscCobziImporte, Val(Cell.Value), csCurrency
        End Select
      Next
      
      m_iOrden = m_iOrden + 1
      register.fields.Add2 cscCobziOrden, m_iOrden, csInteger
      register.fields.Add2 cscCobziTipo, csECobranzaItemTipo.csECobziTCheques, csInteger
      register.fields.Add2 cscCobzTMPId, id, csId
      register.fields.Add2 cscCobziOtroTipo, csEItemOtroTipo.csEOtroDebe, csInteger
      
      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False
                                                            
      If Not gDB.Save(register, , "pSaveCheques", C_Module, c_ErrorSave) Then Exit Function
  
    End If
    
  Next
  
  pSaveCheques = True
End Function

Private Function pSaveTarjetas(ByVal id As Long) As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  Dim tjc_id    As Long
  
  For Each Row In pGetTarjetas().Rows
  
    If Val(pCell(Row, KIT_IMPORTE).Value) Then
  
      Set register = New cRegister
      register.fieldId = cscCobziTMPId
      register.Table = csTCobranzaItemTMP
      register.id = csNew
      
      register.fields.Add2 cscTjccId, csNew, csId
  
      For Each Cell In Row
        Select Case Cell.Key
          
          Case KIT_COBZI_ID
            register.fields.Add2 cscCobziId, csNew, csInteger
          Case KIT_DESCRIP
            register.fields.Add2 cscCobziDescrip, Cell.Value, csText
          Case KIT_CUPON
            register.fields.Add2 cscCobziTMPCupon, Cell.Value, csText
          Case KIT_TJC_ID
            tjc_id = Cell.id
            register.fields.Add2 cscTjcId, Cell.id, csId
          Case KIT_TJCCU_ID
            register.fields.Add2 cscTjccuId, pGetTjccuId(tjc_id, Cell.id), csId
          Case KIT_MON_ID
            register.fields.Add2 cscMonId, Cell.id, csId
          Case KIT_FECHAVTO
            register.fields.Add2 cscCobziTMPFechaVto, Cell.Value, csDate
          Case KIT_TITULAR
            register.fields.Add2 cscCobziTMPTitular, Cell.Value, csText
          Case KIT_NROTARJETA
            register.fields.Add2 cscCobziTMPNroTarjeta, Cell.Value, csText
          Case KIT_NROAUTORIZACION
            register.fields.Add2 cscCobziTMPAutorizacion, Cell.Value, csText
          Case KIT_TARJETA_TIPO
            register.fields.Add2 cscCobziTarjetaTipo, Cell.id, csLong
          Case KIT_IMPORTEORIGEN
            register.fields.Add2 cscCobziImporteOrigen, Val(Cell.Value), csCurrency
          Case KIT_IMPORTE
            register.fields.Add2 cscCobziImporte, Val(Cell.Value), csCurrency
        End Select
      Next
      
      m_iOrden = m_iOrden + 1
      register.fields.Add2 cscCobziOrden, m_iOrden, csInteger
      register.fields.Add2 cscCobziTipo, csECobranzaItemTipo.csECobziTTarjeta, csInteger
      register.fields.Add2 cscCobzTMPId, id, csId
      register.fields.Add2 cscCobziOtroTipo, csEItemOtroTipo.csEOtroDebe, csInteger
      
      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False
                                                            
      If Not gDB.Save(register, , "pSaveTarjetas", C_Module, c_ErrorSave) Then Exit Function
  
    End If
    
  Next
  
  pSaveTarjetas = True
End Function

Private Function pSaveOtros(ByVal id As Long) As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  
  For Each Row In pGetOtros().Rows
  
    Set register = New cRegister
    register.fieldId = cscCobziTMPId
    register.Table = csTCobranzaItemTMP
    register.id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KIO_COBZI_ID
          register.fields.Add2 cscCobziId, csNew, csInteger
        Case KIO_DESCRIP
          register.fields.Add2 cscCobziDescrip, Cell.Value, csText
        Case KIO_RET_ID
          register.fields.Add2 cscRetId, Cell.id, csId
        Case KIO_NRORETENCION
          register.fields.Add2 cscCobziNroRetencion, Cell.Value, csText
        Case KIO_PORCRETENCION
          register.fields.Add2 cscCobziPorcRetencion, Val(Cell.Value), csDouble
        Case KIO_CCOS_ID
          register.fields.Add2 cscCcosId, Cell.id, csId
        Case KIO_CUE_ID
          register.fields.Add2 cscCueId, Cell.id, csId
        Case KIO_FECHARETENCION
          register.fields.Add2 cscCobziFechaRetencion, Cell.Value, csDate
        Case KIO_IMPORTEORIGEN
          register.fields.Add2 cscCobziImporteOrigen, Val(Cell.Value), csCurrency
        Case KIO_DEBE
          If Val(Cell.Value) <> 0 Then
            register.fields.Add2 cscCobziImporte, Val(Cell.Value), csCurrency
            register.fields.Add2 cscCobziOtroTipo, csEItemOtroTipo.csEOtroDebe, csInteger
          End If
        Case KIO_HABER
          If Val(Cell.Value) <> 0 Then
            register.fields.Add2 cscCobziImporte, Val(Cell.Value), csCurrency
            register.fields.Add2 cscCobziOtroTipo, csEItemOtroTipo.csEOtroHaber, csInteger
          End If
      End Select
    Next
    
    m_iOrden = m_iOrden + 1
    register.fields.Add2 cscCobziOrden, m_iOrden, csInteger
    register.fields.Add2 cscCobziTipo, csECobranzaItemTipo.csECobziTOtros, csInteger
    register.fields.Add2 cscCobzTMPId, id, csId
    
    register.fields.HaveLastUpdate = False
    register.fields.HaveWhoModify = False
                                                        
    If Not gDB.Save(register, , "pSaveOtros", C_Module, c_ErrorSave) Then Exit Function
  Next
  
  pSaveOtros = True
End Function

Private Function pSaveEfectivo(ByVal id As Long) As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  
  For Each Row In pGetEfectivo().Rows
  
    If Val(pCell(Row, KIE_IMPORTE).Value) Then
  
      Set register = New cRegister
      register.fieldId = cscCobziTMPId
      register.Table = csTCobranzaItemTMP
      register.id = csNew
      
      For Each Cell In Row
        Select Case Cell.Key
          
          Case KIE_COBZI_ID
            register.fields.Add2 cscCobziId, csNew, csInteger
          Case KIE_DESCRIP
            register.fields.Add2 cscCobziDescrip, Cell.Value, csText
          Case KIE_CUE_ID
            register.fields.Add2 cscCueId, Cell.id, csId
          Case KIE_IMPORTEORIGEN
            register.fields.Add2 cscCobziImporteOrigen, Val(Cell.Value), csCurrency
          Case KIE_IMPORTE
            register.fields.Add2 cscCobziImporte, Val(Cell.Value), csCurrency
        End Select
      Next
      
      m_iOrden = m_iOrden + 1
      register.fields.Add2 cscCobziOrden, m_iOrden, csInteger
      register.fields.Add2 cscCobziTipo, csECobranzaItemTipo.csECobziTEfectivo, csInteger
      register.fields.Add2 cscCobzTMPId, id, csId
      register.fields.Add2 cscCobziOtroTipo, csEItemOtroTipo.csEOtroDebe, csInteger
      
      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False
                                                            
      If Not gDB.Save(register, , "pSaveEfectivo", C_Module, c_ErrorSave) Then Exit Function
    
    End If
    
  Next
  
  pSaveEfectivo = True
End Function

Private Function pSaveCtaCte(ByVal id As Long) As Boolean
  
  Dim cue_id_ctacte As Long
  Dim ImporteOrigen As Double
  Dim Importe       As Double
  
  cue_id_ctacte = pGetCuentaCtaCte()
  If m_Cobrado <= m_FvTotal Then
    Importe = m_Cobrado
  ElseIf m_FvTotal < m_Cobrado Then
    Importe = m_FvTotal
  End If
  
  If cue_id_ctacte = csNO_ID Then
  
    MsgWarning LNGGetText(3559, vbNullString) ' No se pudo obtener la cuenta contable del deudor en el asiento de la factura de venta. No se puede grabar la cobranza.
    Exit Function
    
  End If
  
  Dim register  As cRegister
  
  Set register = New cRegister
  register.fieldId = cscCobziTMPId
  register.Table = csTCobranzaItemTMP
  register.id = csNew
  
  register.fields.Add2 cscCobziId, csNew, csInteger
  register.fields.Add2 cscCueId, cue_id_ctacte, csId
  register.fields.Add2 cscCobziImporteOrigen, ImporteOrigen, csCurrency
  register.fields.Add2 cscCobziImporte, Importe, csCurrency
  
  m_iOrden = m_iOrden + 1
  register.fields.Add2 cscCobziOrden, m_iOrden, csInteger
  register.fields.Add2 cscCobziTipo, csECobranzaItemTipo.csECobziTCtaCte, csInteger
  register.fields.Add2 cscCobzTMPId, id, csId
  register.fields.Add2 cscCobziOtroTipo, csEItemOtroTipo.csEOtroHaber, csInteger
    
  register.fields.HaveLastUpdate = False
  register.fields.HaveWhoModify = False
                                                      
  If Not gDB.Save(register, , "pSaveCtaCte", C_Module, c_ErrorSave) Then Exit Function
  
  ' Anticipo
  '
  If m_FvTotal < m_Cobrado Then
  
    Set register = New cRegister
    register.fieldId = cscCobziTMPId
    register.Table = csTCobranzaItemTMP
    register.id = csNew
    
    register.fields.Add2 cscCobziId, csNew, csInteger
    register.fields.Add2 cscCueId, cue_id_ctacte, csId ' Va a la misma cuenta que la factura
    register.fields.Add2 cscCobziImporteOrigen, ImporteOrigen, csCurrency
    register.fields.Add2 cscCobziImporte, m_Cobrado - m_FvTotal, csCurrency
    
    m_iOrden = m_iOrden + 1
    register.fields.Add2 cscCobziOrden, m_iOrden, csInteger
    register.fields.Add2 cscCobziTipo, csECobranzaItemTipo.csECobziTCtaCte, csInteger
    register.fields.Add2 cscCobzTMPId, id, csId
    register.fields.Add2 cscCobziOtroTipo, csEItemOtroTipo.csEOtroHaber, csInteger
      
    register.fields.HaveLastUpdate = False
    register.fields.HaveWhoModify = False
                                                        
    If Not gDB.Save(register, , "pSaveCtaCte", C_Module, c_ErrorSave) Then Exit Function
  
  End If
  
  pSaveCtaCte = True
End Function

'//////////////////////////////////////////////////////////////////////////////
Private Function pGetCobranzas() As cIABMProperty
  Set pGetCobranzas = m_ObjAbm.Properties.Item(c_list_cobrado)
End Function

Private Function pGetDetalleCobrado() As cIABMProperty
  Set pGetDetalleCobrado = m_ObjAbm.Properties.Item(c_detalle_cobrado)
End Function

Private Function pGetFacturas() As cIABMProperty
  Set pGetFacturas = m_ObjAbm.Properties.Item(c_CobrosPendientes)
End Function

Private Function pGetFacturasCtaCte() As cIABMProperty
  Set pGetFacturasCtaCte = m_ObjAbm.Properties.Item(c_CtaCte)
End Function

Private Function pGetCheques() As cIABMGrid
  Set pGetCheques = pGetChequesProperty().Grid
End Function

Private Function pGetTarjetas() As cIABMGrid
  Set pGetTarjetas = pGetTarjetasProperty().Grid
End Function

Private Function pGetEfectivo() As cIABMGrid
  Set pGetEfectivo = pGetEfectivoProperty().Grid
End Function

Private Function pGetOtros() As cIABMGrid
  Set pGetOtros = pGetOtrosProperty().Grid
End Function

Private Function pGetChequesProperty() As cIABMProperty
  Set pGetChequesProperty = m_ObjAbm.Properties.Item(c_Cheques)
End Function

Private Function pGetTarjetasProperty() As cIABMProperty
  Set pGetTarjetasProperty = m_ObjAbm.Properties.Item(c_Tarjeta)
End Function

Private Function pGetEfectivoProperty() As cIABMProperty
  Set pGetEfectivoProperty = m_ObjAbm.Properties.Item(c_Efectivo)
End Function

Private Function pGetOtrosProperty() As cIABMProperty
  Set pGetOtrosProperty = m_ObjAbm.Properties.Item(c_Otros)
End Function

Private Function pColAUpdateCheque(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  Dim Row      As cIABMGridRow
  Dim Value    As Double
  
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KICH_IMPORTEORIGEN
        Set Row = .Rows(lRow)
        With pCell(Row, KICH_MON_ID)
          If .id <> m_MonDefault Or .id = 0 Then
            pCell(Row, KICH_IMPORTE).Value = Val(pCell(Row, KICH_IMPORTEORIGEN).Value) _
                                              * Val(pGetCotizacion(.id))
          Else
            pCell(Row, KICH_IMPORTEORIGEN).Value = 0
          End If
        End With
      Case KICH_IMPORTE
      
      Case KICH_CUE_ID
        Dim MonId   As Long
        Dim Moneda  As String
        Set Row = .Rows(lRow)
        GetMonedaFromCuenta MonId, Moneda, pCell(Row, KICH_CUE_ID).id
        With pCell(Row, KICH_MON_ID)
          .Value = Moneda
          .id = MonId
        End With
      
        If MonId = m_MonDefault Or MonId = 0 Then
          pCell(Row, KICH_IMPORTEORIGEN).Value = 0
        End If
        
        If Val(pCell(Row, KICH_IMPORTE).Value) = 0 Then
          pCell(Row, KICH_IMPORTE).Value = Val(pGetTotal().Value) - Val(pGetCobroTotal().Value)
          pShowCobroNeto
          pShowCobroTotal
        End If
        
        pColAUpdateCheque = True
        Exit Function
      Case Else
        pColAUpdateCheque = True
        Exit Function
    End Select
  End With
  
  pShowCobroNeto
  pShowCobroTotal
  pColAUpdateCheque = True
End Function

Private Function pColAUpdateTarjeta(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  Dim Row      As cIABMGridRow
  Dim Value    As Double
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KIT_IMPORTEORIGEN
        Set Row = .Rows(lRow)
        pCell(Row, KIT_IMPORTE).Value = Val(pCell(Row, KIT_IMPORTEORIGEN).Value) _
                                         * Val(pGetCotizacion(pCell(Row, KICH_MON_ID).id))
      Case KIT_IMPORTE
      
      Case KIT_CUPON
      
        Dim pago As Double
        Dim ACobrar As Double
        Dim CobroEfvo As Double
        
        pago = Val(pGetCobroNeto().Value)
        ACobrar = Val(pGetTotal().Value)
        CobroEfvo = Val(pCell(pGetEfectivo.Rows.Item(1), KIE_IMPORTE).Value)
        
        Set Row = .Rows(lRow)
        
        If CobroEfvo = ACobrar Then
          
          pCell(pGetEfectivo().Rows.Item(1), KIE_IMPORTE).Value = 0
          AbmObj.ShowValue pGetEfectivoProperty(), True
          
          pCell(Row, KIT_IMPORTE).Value = ACobrar
          
        Else
          
          Dim Importe As Double
          Importe = ACobrar - pago
          pCell(Row, KIT_IMPORTE).Value = IIf(Importe > 0, Importe, 0)
        
        End If
      
      Case KIT_TJC_ID
      
        Dim TjcId  As Long
        Set Row = .Rows(lRow)
        
        TjcId = pCell(Row, KIT_TJC_ID).id
        SetFilterCuotas Row, IProperty, m_ObjAbm, KIT_TJC_ID
        
        With pCell(Row, KIT_TJCCU_ID)
          If Not ValidateCuota(TjcId, .id) Then
            .id = csNO_ID
            .Value = vbNullString
            AbmObj.ShowCellValue IProperty, lRow, m_lColCuotas
          End If
        End With
        
        If Val(pCell(Row, KIT_IMPORTE).Value) = 0 Then
          pCell(Row, KIT_IMPORTE).Value = Val(pGetTotal().Value) - Val(pGetCobroTotal().Value)
          pShowCobroNeto
          pShowCobroTotal
        End If
        
        pColAUpdateTarjeta = True
        Exit Function
        
      Case Else
      
        pColAUpdateTarjeta = True
        Exit Function
    End Select
  End With
  
  pShowCobroNeto
  pShowCobroTotal
  pColAUpdateTarjeta = True
End Function

Private Function pColAUpdateCtaCte(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  pColAUpdateCtaCte = True
End Function

Private Function pColAUpdateEfectivo(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  Dim Row      As cIABMGridRow
  Dim Value    As Double
  
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KIE_IMPORTEORIGEN
        Set Row = .Rows(lRow)
        With pCell(Row, KIE_MON_ID)
          If .id <> m_MonDefault Or .id = 0 Then
            pCell(Row, KIE_IMPORTE).Value = Val(pCell(Row, KIE_IMPORTEORIGEN).Value) _
                                             * Val(pGetCotizacion(.id))
          Else
            pCell(Row, KIE_IMPORTEORIGEN).Value = 0
          End If
        End With
      
      Case KIE_IMPORTE
        
      Case KIE_CUE_ID
        Dim MonId   As Long
        Dim Moneda  As String
        Set Row = .Rows(lRow)
        GetMonedaFromCuenta MonId, Moneda, pCell(Row, KIE_CUE_ID).id
        With pCell(Row, KIE_MON_ID)
          .Value = Moneda
          .id = MonId
        End With
      
        If MonId = m_MonDefault Or MonId = 0 Then
          pCell(Row, KIE_IMPORTEORIGEN).Value = 0
        End If
        
        If Val(pCell(Row, KIE_IMPORTE).Value) = 0 Then
          pCell(Row, KIE_IMPORTE).Value = Val(pGetTotal().Value) - Val(pGetCobroTotal().Value)
          pShowCobroNeto
          pShowCobroTotal
        End If
        
        pColAUpdateEfectivo = True
        Exit Function
      Case Else
        pColAUpdateEfectivo = True
        Exit Function
    End Select
  End With
  
  pShowCobroNeto
  pShowCobroTotal
  pShowCambio
  pColAUpdateEfectivo = True
End Function

Private Function pColAUpdateOtro(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  Dim Row      As cIABMGridRow
  Dim Value    As Double
  
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KIO_DEBE
        Set Row = .Rows(lRow)
        pCell(Row, KIO_IMPORTEORIGEN).Value = Val(pCell(Row, KIO_DEBE).Value)
        pCell(Row, KIO_HABER).Value = 0
      Case KIO_HABER
        Set Row = .Rows(lRow)
        pCell(Row, KIO_IMPORTEORIGEN).Value = Val(pCell(Row, KIO_HABER).Value)
        pCell(Row, KIO_DEBE).Value = 0
      Case Else
        pColAUpdateOtro = True
        Exit Function
    End Select
  End With
  
  pShowCobroOtro
  pShowCobroTotal
  pColAUpdateOtro = True
End Function

Private Function pGetCotizacion(ByVal mon_id As Long) As Double
  Dim Cotiz As Double
  pGetCotizacion = GetCotizacion(mon_id, m_Fecha)
End Function

Private Sub pShowCobroNeto(Optional ByVal bShow As Boolean = True)
  Dim Row           As cIABMGridRow
  Dim Total         As Double
  Dim TotalOrigen   As Double
  
  For Each Row In pGetCheques().Rows
    Total = Total + Val(pCell(Row, KICH_IMPORTE).Value)
  Next
  
  For Each Row In pGetEfectivo().Rows
    Total = Total + Val(pCell(Row, KIE_IMPORTE).Value)
  Next
  
  For Each Row In pGetTarjetas().Rows
    Total = Total + Val(pCell(Row, KIE_IMPORTE).Value)
  Next
  
  pGetCobroNeto().Value = Total
  If bShow Then m_ObjAbm.ShowValue pGetCobroNeto
End Sub

Private Sub pShowCobroTotal(Optional ByVal bShow As Boolean = True)
  pGetCobroTotal.Value = Val(pGetCobroNeto().Value) + Val(pGetCobroOtros().Value)
  If bShow Then m_ObjAbm.ShowValue pGetCobroTotal
End Sub

Private Sub pShowCobroOtro()
  Dim Row           As cIABMGridRow
  Dim Total         As Double
  
  For Each Row In pGetOtros().Rows
    Total = Total + Val(pCell(Row, KIO_DEBE).Value) - Val(pCell(Row, KIO_HABER).Value)
  Next
  
  pGetCobroOtros().Value = Total
  m_ObjAbm.ShowValue pGetCobroOtros
End Sub

Private Function pGetCobrado() As cIABMProperty
  Set pGetCobrado = m_ObjAbm.Properties.Item(c_cobrado)
End Function

Private Function pGetCobroNeto() As cIABMProperty
  Set pGetCobroNeto = m_ObjAbm.Properties.Item(cscCobzNeto)
End Function

Private Function pGetCobroOtros() As cIABMProperty
  Set pGetCobroOtros = m_ObjAbm.Properties.Item(cscCobzOtros)
End Function

Private Function pGetCobroTotal() As cIABMProperty
  Set pGetCobroTotal = m_ObjAbm.Properties.Item(cscCobzTotal)
End Function

Private Function pGetTotal() As cIABMProperty
  Set pGetTotal = m_ObjAbm.Properties.Item(cscFvTotal)
End Function

'///////////////////////////////////////////////////////////////////
' Validaciones de Filas de Instrumentos de cobro
Private Function pIsEmptyRowCheques(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KICH_CUE_ID
        If m_cj_id = csNO_ID Then
          If Not ValEmpty(Cell.id, csId) Then
            bRowIsEmpty = False
            Exit For
          End If
        End If
      Case KICH_BCO_ID, KICH_MON_ID, KICH_CLE_ID
        If Not ValEmpty(Cell.id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    
      Case KICH_IMPORTE, KICH_IMPORTEORIGEN
        If Not ValEmpty(Val(Cell.Value), csDouble) Then
          bRowIsEmpty = False
          Exit For
        End If
      
      Case KICH_DESCRIP, KICH_CHEQUE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowCheques = bRowIsEmpty
End Function

Private Function pValidateRowCheques(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bOrigen               As Boolean
  Dim MonId                 As Long
  
  strRow = " (Fila " & RowIndex & ")"
  
  If m_cj_id <> csNO_ID And Val(pCell(Row, KICH_IMPORTE).Value) = 0 Then
    pValidateRowCheques = True
    Exit Function
  End If
  
  For Each Cell In Row
    Select Case Cell.Key
      
      Case KICH_CUE_ID
        If ValEmpty(Cell.id, csId) Then
          MsgInfo LNGGetText(2113, vbNullString, strRow) 'Debe indicar una Cuenta Contable (1)
          Exit Function
        End If
        
      Case KICH_BCO_ID
        If ValEmpty(Cell.id, csId) Then
          MsgInfo LNGGetText(2094, vbNullString, strRow) 'Debe indicar un banco (1)
          Exit Function
        End If
        
      Case KICH_MON_ID
        If ValEmpty(Cell.id, csId) Then
          MsgInfo LNGGetText(2114, vbNullString, strRow) 'Debe indicar una moneda (1)
          Exit Function
        End If
        MonId = Cell.id
        
      Case KICH_CLE_ID
        If ValEmpty(Cell.id, csId) Then
          MsgInfo LNGGetText(2115, vbNullString, strRow) 'Debe indicar un clearing (1)
          Exit Function
        End If
    
      Case KICH_IMPORTEORIGEN
        bOrigen = Not (Val(Cell.Value) <= 0)
      
      Case KICH_IMPORTE
        If Val(Cell.Value) <= 0 Then
          MsgInfo LNGGetText(2116, vbNullString, strRow) 'Debe indicar un número de Cheque (1)
          Exit Function
        End If
      
      Case KICH_CHEQUE
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(2116, vbNullString, strRow) 'Debe indicar un número de cheque (1)
          Exit Function
        End If
      
      Case KICH_FECHACOBRO
        If ValEmpty(Cell.Value, csDate) Then
          MsgInfo LNGGetText(2117, vbNullString, strRow) 'Debe indicar una fecha para depositar (1)
          Exit Function
        End If
      
      Case KICH_FECHAVTO
        If ValEmpty(Cell.Value, csDate) Then
          MsgInfo LNGGetText(1384, vbNullString, strRow) 'Debe indicar una fecha de vencimiento (1)
          Exit Function
        End If
    End Select
  Next
  
  If Not bOrigen And MonId <> m_MonDefault Then
    MsgInfo LNGGetText(2118, vbNullString, strRow)
            'Debe indicar un importe para la moneda extranjera (1)
    Exit Function
  End If
  
  pValidateRowCheques = True
End Function

Private Function pIsEmptyRowTarjetas(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KIT_TJC_ID, KIT_MON_ID, KIT_TJCCU_ID
        If Not ValEmpty(Cell.id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    
      Case KIT_IMPORTE, KIT_IMPORTEORIGEN
        If Not ValEmpty(Val(Cell.Value), csDouble) Then
          bRowIsEmpty = True
          Exit For
        End If
      
      Case KIT_NROTARJETA, KIT_NROAUTORIZACION, KIT_TITULAR, KIT_DESCRIP
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = True
          Exit For
        End If
      
      Case KIT_FECHAVTO
        If Not ValEmpty(Cell.Value, csDate) Then
          bRowIsEmpty = True
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowTarjetas = bRowIsEmpty
End Function

Private Function pValidateRowTarjetas(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bOrigen               As Boolean
  Dim MonId                 As Long
  
  strRow = " (Fila " & RowIndex & ")"
  
  If m_cj_id <> csNO_ID And Val(pCell(Row, KIT_IMPORTE).Value) = 0 Then
    pValidateRowTarjetas = True
    Exit Function
  End If
  
  For Each Cell In Row
    Select Case Cell.Key
      
      Case KIT_TJC_ID
        If ValEmpty(Cell.id, csId) Then
          MsgInfo LNGGetText(2119, vbNullString, strRow)  'Debe indicar una Tarjeta de Crédito (1)
          Exit Function
        End If
        
      Case KIT_MON_ID
        If ValEmpty(Cell.id, csId) Then
          MsgInfo LNGGetText(2114, vbNullString, strRow)  'Debe indicar una moneda (1)
          Exit Function
        End If
        MonId = Cell.id
        
      Case KIT_IMPORTEORIGEN
        bOrigen = Not (Val(Cell.Value) <= 0)
      
      Case KIT_IMPORTE
        If Val(Cell.Value) <= 0 Then
          MsgInfo LNGGetText(1897, vbNullString, strRow)  'Debe indicar un importe (1)
          Exit Function
        End If
      
      Case KIT_NROTARJETA
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(2120, vbNullString, strRow)  'Debe indicar un número tarjeta (1)
          Exit Function
        End If
      
'      Case KIT_NROAUTORIZACION
'        If ValEmpty(Cell.Value, csText) Then
'          MsgInfo LNGGetText(2121, vbNullString, strRow)  'Debe indicar un número autorización (1)
'          Exit Function
'        End If
'
'      Case KIT_FECHAVTO
'        If ValEmpty(Cell.Value, csDate) Then
'          MsgInfo LNGGetText(1384, vbNullString, strRow)  'Debe indicar una fecha de vencimiento (1)
'          Exit Function
'        End If
'
'      Case KIT_TITULAR
'        If ValEmpty(Cell.Value, csText) Then
'          MsgInfo LNGGetText(2122, vbNullString, strRow)  'Debe indicar un Titular (1)
'          Exit Function
'        End If
    
    End Select
  Next
  
  If Not bOrigen And MonId <> m_MonDefault Then
    MsgInfo LNGGetText(2118, vbNullString, strRow)
            'Debe indicar un importe para la moneda extranjera (1)
    Exit Function
  End If
  
  pValidateRowTarjetas = True
End Function

Private Function pIsEmptyRowOtros(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KIO_CUE_ID, KIO_CCOS_ID, KIO_RET_ID
        If Not ValEmpty(Cell.id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    
      Case KIO_DEBE, KIO_HABER, KIO_IMPORTEORIGEN, KIO_PORCRETENCION
        If Not ValEmpty(Val(Cell.Value), csDouble) Then
          bRowIsEmpty = True
          Exit For
        End If
      
      Case KIO_NRORETENCION, KIO_DESCRIP
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = True
          Exit For
        End If
      
      Case KIO_FECHARETENCION
        If Not ValEmpty(Cell.Value, csDate) Then
          bRowIsEmpty = True
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowOtros = bRowIsEmpty
End Function

Private Function pValidateRowOtros(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bOrigen               As Boolean
  Dim bDebe                 As Boolean
  Dim bHaber                As Boolean
  Dim MonId                 As Long
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      
      Case KIO_CUE_ID
        If ValEmpty(Cell.id, csId) Then
          MsgInfo LNGGetText(2113, vbNullString, strRow)  'Debe indicar una cuenta contable (1)
          Exit Function
        End If
      
        If Not gDB.GetData(csTCuenta, cscCueId, Cell.id, cscMonId, MonId) Then Exit Function
        
      Case KIO_DEBE
        bDebe = Not (Val(Cell.Value) <= 0)
        
      Case KIO_HABER
        bHaber = Not (Val(Cell.Value) <= 0)
        
      Case KIO_IMPORTEORIGEN
        bOrigen = Not (Val(Cell.Value) <= 0)
        
    End Select
  Next
  
  If Not bDebe And Not bHaber Then
    MsgInfo LNGGetText(1898, vbNullString, strRow)
            'Debe indicar un importe en el debe o en el haber (1)
    Exit Function
  End If
  
  If Not bOrigen And MonId <> m_MonDefault Then
    MsgInfo LNGGetText(2118, vbNullString, strRow)
            'Debe indicar un importe para la moneda extranjera (1)
    Exit Function
  End If
  
  pValidateRowOtros = True
End Function

Private Function pIsEmptyRowEfectivo(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KIE_CUE_ID
        If Not ValEmpty(Cell.id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    
      Case KIE_IMPORTE, KIE_IMPORTEORIGEN
        If Not ValEmpty(Val(Cell.Value), csDouble) Then
          bRowIsEmpty = True
          Exit For
        End If
      
      Case KIE_DESCRIP
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = True
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowEfectivo = bRowIsEmpty
End Function

Private Function pValidateRowEfectivo(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bOrigen               As Boolean
  Dim MonId                 As Long
  
  strRow = " (Fila " & RowIndex & ")"
  
  If m_cj_id <> csNO_ID And Val(pCell(Row, KIE_IMPORTE).Value) = 0 Then
    pValidateRowEfectivo = True
    Exit Function
  End If
  
  For Each Cell In Row
    Select Case Cell.Key
      
      Case KIE_CUE_ID
        If ValEmpty(Cell.id, csId) Then
          MsgInfo LNGGetText(2113, vbNullString, strRow)
                  'Debe indicar una cuenta contable (1)
          Exit Function
        End If
        
        If Not gDB.GetData(csTCuenta, cscCueId, Cell.id, cscMonId, MonId) Then Exit Function
        
      Case KIE_IMPORTEORIGEN
        bOrigen = Not (Val(Cell.Value) <= 0)
      
      Case KIE_IMPORTE
        If Val(Cell.Value) <= 0 Then
          MsgInfo LNGGetText(1897, vbNullString, strRow)
                  'Debe indicar un importe (1)
          Exit Function
        End If
    End Select
  Next
  
  If Not bOrigen And MonId <> m_MonDefault Then
    MsgInfo LNGGetText(2118, vbNullString, strRow)
            'Debe indicar un importe para la moneda extranjera (1)
    Exit Function
  End If
  
  pValidateRowEfectivo = True
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

Private Sub SetFilterCuotas(ByRef Row As cIABMGridRow, ByRef IProperty As cIABMProperty, ByRef AbmObj As cABMGeneric, ByVal KIT_TJC_ID As Integer)
  Dim TjcId As Long
  Const c_Cuotas = "Cuotas"
  
  TjcId = pCell(Row, KIT_TJC_ID).id
  IProperty.Grid.Columns(c_Cuotas).HelpFilter = "tjc_id = " & TjcId
  AbmObj.RefreshColumnProperties IProperty, c_Cuotas
End Sub

Private Function GetHelpFilterCheques() As String
  GetHelpFilterCheques = "(" & cscCuecId & "=" & csECuecBancos & " or " _
                          & cscCuecId & "=" & csECuecDocEnCartera & _
                          ") and (emp_id = " & EmpId & " or emp_id is null)"
End Function

Private Function GetHelpFilterEfectivo() As String
  GetHelpFilterEfectivo = "(" & cscCuecId & "=" & csECuecCaja & " or " _
                          & cscCuecId & "=" & csECuecBancos & _
                          ") and (emp_id = " & EmpId & " or emp_id is null)"
End Function

Private Function ValidateCuota(ByVal tjc_id As Long, ByVal tjccu_id As Long) As Boolean
  Dim tjc_id2 As Long
  
  If tjccu_id <> csNO_ID Then
    If Not gDB.GetData("TarjetaCreditoCuota", "tjccu_id", tjccu_id, "tjc_id", tjc_id2) Then Exit Function
    If tjc_id2 <> tjc_id Then Exit Function
  End If
  ValidateCuota = True
End Function

Private Function pGetCuentaCtaCte() As Long
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select asi.cue_id from asientoitem asi inner join facturaventa fv on asi.as_id = fv.as_id and fv.fv_id = " & m_FvId & " inner join cuenta cue on asi.cue_id = cue.cue_id where cuec_id = 4"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  pGetCuentaCtaCte = rs.fields.Item(cscCueId).Value
  
End Function

Private Function pGetFvdId() As Long
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select fvd_id from facturaventadeuda where fv_id = " & m_FvId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  pGetFvdId = rs.fields.Item(cscFvdId).Value

End Function

Private Function pSaveFacturas(ByVal id As Long) As Boolean
                               
  Dim register        As cRegister
  Dim CotiOrigen      As Double
  Dim CotiCobranza    As Double
  
  Set register = New cRegister
  
  With register
  
    .fieldId = cscFvCobzTMPid
    .Table = csTFacturaVentaCobranzaTMP
    .id = csNew
      
    With .fields
    
      .Add2 cscFvId, m_FvId, csId
      .Add2 cscFvdId, pGetFvdId(), csId
      .Add2 cscFvCobzImporteOrigen, m_Cobrado, csDouble
      CotiOrigen = 1
      CotiCobranza = 1
      .Add2 cscFvCobzCotizacion, CotiCobranza, csDouble
      .Add2 cscFvCobzImporte, m_Cobrado, csDouble
      .Add2 cscFvCobzId, 0, csLong
      .Add2 cscCobzTMPId, id, csId
      .Add2 cscCobzId, 0, csLong
      
      .HaveLastUpdate = False
      .HaveWhoModify = False
                                                            
      If Not gDB.Save(register, , "pSaveFacturas", C_Module, c_ErrorSave) Then Exit Function
      
    End With
  
  End With
  
  pSaveFacturas = True
End Function

Private Function pGetTjccuId(ByVal tjc_id As Long, _
                             ByVal tjccu_id As Long) As Long
  If tjccu_id <> csNO_ID Then
    
    pGetTjccuId = tjccu_id
    
  Else
  
    Dim sqlstmt As String
    Dim rs      As ADODB.Recordset
    
    sqlstmt = "select tjccu_id from TarjetaCreditoCuota where tjc_id = " & tjc_id _
                & " and tjccu_cantidad = (select min(tjccu_cantidad) " _
                                      & " from TarjetaCreditoCuota where tjc_id = " & tjc_id & ")"
    
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    If rs.EOF Then Exit Function
    
    pGetTjccuId = gDB.ValField(rs.fields, cscTjccuId)
                                      
  End If
End Function

Private Function pGeCobroEfectivo() As Double
  
  Dim efectivo As Double
  Dim ACobrar  As Double
  
  efectivo = Val(pCell(pGetEfectivo.Rows.Item(1), KIE_IMPORTE).Value)
  ACobrar = Val(m_ObjAbm.Properties.Item(cscFvTotal).Value)
  
  If efectivo <= 0 Or efectivo > ACobrar Then
    efectivo = ACobrar
  End If

  pGeCobroEfectivo = efectivo
  
End Function

Private Sub pShowCambio()
  On Error GoTo ControlError
  
  With m_ObjAbm.Properties
    Dim cambio As Double
    cambio = Val(.Item(c_cobrado).Value) - pGeCobroEfectivo()
    If cambio < 0 Then cambio = 0
    .Item(c_cambio).Value = Format(cambio, m_GeneralConfig.FormatDecImporte)
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties.Item(c_cambio)

  GoTo ExitProc
ControlError:
  MngError Err, "pShowCambio", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pResetCobrado()
  m_ObjAbm.Properties.Item(c_cobrado).Value = vbNullString
  m_ObjAbm.ShowValue m_ObjAbm.Properties.Item(c_cobrado)
End Sub

' Presenta opciones de menu que generan una
' factura automatica desde uno o mas pedidos
' sin preguntar por los medios de pago
' ya que la cuenta esta definida en
' el modo de venta
'
Private Sub pAddModoPago()
  Dim i As Long
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  ReDim Preserve m_vMenuModoPago(4, 0)
  
  ' Uso los venta modo de pedidos
  '
  sqlstmt = "select * from VentaModo where vm_cobz <> 0"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Dim Key As Long
  Dim left As Long
  
  Key = 10000
  left = 1000
  
  While Not rs.EOF
    
    ReDim Preserve m_vMenuModoPago(4, UBound(m_vMenuModoPago, 1) + 1)
    i = i + 1
    m_vMenuModoPago(C_VM_ID, i) = gDB.ValField(rs.fields, "vm_id")
    m_vMenuModoPago(C_VM_MENU_ID, i) = Key
    m_vMenuModoPago(C_VM_IS_CONTADO, i) = gDB.ValField(rs.fields, "vm_ctacte") <> csE_VentaModoCtaCte.csVM_CtaCteHojaRuta
    m_vMenuModoPago(C_VM_CUE_ID, i) = gDB.ValField(rs.fields, "cue_id")
    m_vMenuModoPago(C_VM_VMXI_PAGO, i) = gDB.ValField(rs.fields, "vm_cmvxi")
  
    With m_ObjAbm.Properties.Add(Nothing)
      .PropertyType = cspButton
      .left = left
      If i <= 3 Then
        .name = gDB.ValField(rs.fields, "vm_nombre") & "   F" & i + 6
      Else
        .name = gDB.ValField(rs.fields, "vm_nombre")
      End If
      .Top = 3750
      .LeftLabel = -1
      .Key = Key
      .TabIndex = csETabIdxT_All2
    End With
  
    If gDB.ValField(rs.fields, "vm_cmvxi") And m_key_cmvxi = 0 Then
      m_key_cmvxi = Key
      With m_ObjAbm.Properties.Add(Nothing, c_cvxi_highlight_button)
        .PropertyType = cspLabel
        .BackColor = vbWhite
        .left = left - 40
        .Top = 3710
        .Width = 1600
        .Height = 420
        .TabIndex = csETabIdxT_All2
      End With
    End If
  
    Key = Key + 1000
    left = left + 2100
  
    rs.MoveNext
  Wend
End Sub

Private Function pGetCMDCvxi() As cIABMProperty
  Dim iProp As cIABMProperty
  For Each iProp In m_ObjAbm.Properties
    If iProp.Key = m_key_cmvxi Then
      Set pGetCMDCvxi = iProp
      Exit Function
    End If
  Next
End Function

Private Function pLoadCajaForUsuario() As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim Msg     As String
  
  sqlstmt = "sp_MovimientoCajaGetCjForUsId " & User.id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
      
  Msg = gDB.ValField(rs.fields, "warning")
  If LenB(Msg) Then
    MsgWarning Msg
    Exit Function
  End If
  
  m_cj_id = gDB.ValField(rs.fields, cscCjId)
  
  pLoadCajaForUsuario = True
  
End Function

Private Function pCheckCobroButtons(ByVal Key As Long) As Boolean
  On Error GoTo ControlError
  
  Dim i As Long
  Dim Row As cIABMGridRow
  Dim bFound As Boolean
  Dim bEnabledChanged As Boolean
  
  Dim AbmGen As cABMGeneric
  Set AbmGen = m_ObjAbm
  
  For i = 1 To UBound(m_vMenuModoPago)
    If m_vMenuModoPago(C_VM_MENU_ID, i) = Key Then
    
      bEnabledChanged = True
      AbmGen.ShowMessage LNGGetText(5121, vbNullString) 'Guardando la Cobranza
      pSetEnableState False
    
      If m_vMenuModoPago(C_VM_IS_CONTADO, i) Then
        For Each Row In pGetEfectivo().Rows
        
          If pCell(Row, KIE_CUE_ID).id = m_vMenuModoPago(C_VM_CUE_ID, i) Then
          
            If m_vMenuModoPago(C_VM_VMXI_PAGO, i) Then
          
              pCell(Row, KIE_IMPORTE).Value = m_pagocvxi
              AbmGen.ShowValue pGetEfectivoProperty(), True
              
              pShowCobroNeto
              pShowCobroTotal
              pShowCambio
              
              If Abs(m_pagocvxi - m_FvTotal) > 0.1 Then
                Dim pago As String
                Dim factura As String
                Dim diferencia As String
                
                pago = Format(m_pagocvxi, m_GeneralConfig.FormatDecImporte)
                factura = Format(m_FvTotal, m_GeneralConfig.FormatDecImporte)
                diferencia = Format(Abs(m_FvTotal - m_pagocvxi), m_GeneralConfig.FormatDecImporte)
                
                If m_FvTotal - m_pagocvxi > 0 Then
                  MsgWarning LNGGetText(5114, vbNullString, factura, pago, diferencia)
                      ' El monto pagado por internet es menor al la factura
                      ' Factura:
                      ' Pago internet:
                      ' Diferencia:
                Else
                  MsgWarning LNGGetText(5115, vbNullString, factura, pago, diferencia)
                      ' El monto pagado por internet es mayor al la factura
                      ' Factura:
                      ' Pago internet:
                      ' Diferencia:
                End If
                
                GoTo ExitProc
              End If
            Else
              
              pCell(Row, KIE_IMPORTE).Value = m_FvTotal
              AbmGen.ShowValue pGetEfectivoProperty(), True
              
              pShowCobroNeto
              pShowCobroTotal
              pShowCambio
              
            End If
          
            bFound = True
            Exit For
          End If
        
        Next
      End If
      Exit For
    End If
  Next
  
  If bFound Then
    
    m_inShortCut = True
    
    If Not AbmGen.Save() Then GoTo ExitProc
    
    m_inShortCut = False
  
    If Not m_bCobranzaCdo Then
      
      pRefresh
      
      pResetCobrado
      pShowCobroNeto
      pShowCobroTotal
      pShowCambio
    
    End If
    
  End If
  
  pCheckCobroButtons = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pCheckCobroButtons", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  If bEnabledChanged Then
    pSetEnableState True
    AbmGen.HideMessage
  End If
  m_inShortCut = False
End Function

Private Sub pSetEnableState(ByVal state As Boolean)
  Dim iProp As cIABMProperty
  Dim i     As Long
  
  For i = 1 To UBound(m_vMenuModoPago)
    For Each iProp In m_ObjAbm.Properties
      If iProp.Key = m_vMenuModoPago(C_VM_MENU_ID, i) Then
        
        iProp.Enabled = state
        Exit For
      End If
    Next
  Next
End Sub

' 1 si pago con mercado pago y tiene los montos no coinciden
'
' 2 si envio a hoja de ruta
'
Private Sub pSaveDetalleOperacion(ByVal fv_id As Long, _
                                  ByVal cobz_id As Long, _
                                  ByVal pagocvxi As Double, _
                                  ByVal HojaRuta As Boolean)
  Dim sqlstmt As String
  sqlstmt = "sp_DocCobranzaCdoSaveDetalle " & fv_id & "," _
                                            & cobz_id & "," _
                                            & gDB.sqlNumber(pagocvxi) & "," _
                                            & IIf(HojaRuta, 1, 0)
  gDB.Execute sqlstmt
End Sub

Private Sub pSendToCtaCte(ByVal fv_id As Long)
  Dim sqlstmt As String
  sqlstmt = "sp_DocCobranzaCdoMoveCtaCte " & fv_id
  
  If gDB.Execute(sqlstmt) Then Exit Sub
  
  pRefresh
End Sub

Private Sub pRefresh()
  On Error GoTo ControlError

  Dim MouseWait As cMouseWait
  Set MouseWait = New cMouseWait
  
  Dim AbmGen As cABMGeneric
  Set AbmGen = m_ObjAbm
  
  AbmGen.ShowMessage "Cargando Facturas"
  
  pGetFilter().Value = vbNullString
  AbmGen.ShowValue pGetFilter()
  
  pLoadDataCobros pGetFacturas(), False
  pLoadDataCobros pGetFacturasCtaCte(), True
  
  AbmGen.ShowValue pGetFacturas(), True
  AbmGen.ShowValue pGetFacturasCtaCte(), True
  
  pLoadMovimientosXCjId pGetCobranzas(), False
  pLoadCajaCuentaImportesXCjId pGetDetalleCobrado(), False
  
  If pGetFacturas().Grid.Rows.count > 0 Then
    AbmGen.SetRowSelected pGetFacturas(), 1
    pManageRowSelection pGetFacturas()
  End If
  
  AbmGen.SetFocusCtrl pGetCobrado()
  
  GoTo ExitProc
ControlError:
  MngError Err, "", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  AbmGen.HideMessage
End Sub

Private Sub pRefreshCtaCte()
  Dim AbmGen As cABMGeneric
  Set AbmGen = m_ObjAbm
  
  pLoadDataCobros pGetFacturasCtaCte(), True
  AbmGen.ShowValue pGetFacturasCtaCte(), True
End Sub

Private Sub pManageRowSelection(ByVal iProp As cIABMProperty)
  Dim Row As cIABMGridRow
  Dim MouseWait As cMouseWait
  Set MouseWait = New cMouseWait
  
  Select Case iProp.Key
  
    Case K_CTA_CTE
    
      Set Row = iProp.Grid.Rows(iProp.SelectedIndex)
      If Row Is Nothing Then Exit Sub
    
      pLoadDataFromFactura Val(pCell(Row, KIFV_ID).Value)
      
    Case K_COBROS_PENDIENTES
  
      Set Row = iProp.Grid.Rows(iProp.SelectedIndex)
      If Row Is Nothing Then Exit Sub
    
      pLoadDataFromFactura Val(pCell(Row, KIFV_ID).Value)
      
  End Select
End Sub

Private Function pLoadMovimientosXCjId(ByRef iProp As cIABMProperty, ByVal inLoadCollection As Boolean) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
      
  sqlstmt = "sp_MovimientoCajaGetMovimientosXCjId " & m_cj_id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadMovimientosXCjId", C_Module) Then Exit Function
  
  With iProp.Grid
  
    .Rows.Clear
  
    With .Rows
    
      If Not rs.EOF Then
        rs.Sort = "sort_column desc"
      End If
    
      While Not rs.EOF
      
        With .Add(Nothing)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscMcjmId)
            .Key = KI_MCJM_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscAsNrodoc)
            .id = gDB.ValField(rs.fields, "as_id_movimiento")
            .Key = KI_AS_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscAsDocCliente)
            .id = gDB.ValField(rs.fields, cscCobzId)
            .Key = KI_COMPROBANTE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscAsFecha)
            .Key = KI_FECHA
          End With
                    
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, "ingreso")
            .Key = KI_INGRESOS
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, "egreso")
            .Key = KI_EGRESOS
          End With
                    
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscMcjmDescrip)
            .Key = KI_DESCRIP
          End With
                    
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  If Not inLoadCollection Then
  
    Dim AbmGen As cABMGeneric
    Set AbmGen = m_ObjAbm
  
    AbmGen.ShowValue iProp, True
  
  End If
  
  pLoadMovimientosXCjId = True
End Function

Private Function pLoadMovimientos(ByRef Propiedad As cIABMProperty) As Boolean
  
  With Propiedad.Grid
  
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
  
      With .Add(Nothing)
        .Visible = False
        .Key = KI_MCJM_ID
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(4730, vbNullString)  'Asiento
        .Key = KI_AS_ID
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1610, vbNullString)  'Comprobante
        .Key = KI_COMPROBANTE
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1569, vbNullString)  'Fecha
        .Key = KI_FECHA
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1228, vbNullString)  'Ingresos
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .Key = KI_INGRESOS
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1228, vbNullString)  'Egresos
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .Key = KI_EGRESOS
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1861, vbNullString)  'Observaciones
        .Key = KI_DESCRIP
      End With
      
    End With
  
  End With
  
  pLoadMovimientos = True
End Function

Private Function pLoadCajaCuentaImportesXCjId(ByRef iProp As cIABMProperty, ByVal inLoadCollection As Boolean) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
      
  sqlstmt = "sp_MovimientoCajaGetTotalesXCjId " & m_cj_id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCajaCuentaImportesXCjId", C_Module) Then Exit Function
  
  With iProp.Grid
  
    .Rows.Clear
  
    With .Rows
        
      While Not rs.EOF
      
        With .Add(Nothing)
        
          With .Add(Nothing)
            .Value = 0
            .Key = KI_MCJM_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCueNombre)
            .Key = KI_CUE_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, "saldo")
            .Key = KI_EGRESOS
          End With
                                        
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  If Not inLoadCollection Then
  
    Dim AbmGen As cABMGeneric
    Set AbmGen = m_ObjAbm
  
    AbmGen.ShowValue iProp, True
  
  End If
  
  pLoadCajaCuentaImportesXCjId = True
End Function

Private Function pLoadCajaCuentas(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
    
  sqlstmt = "sp_cajaGetCuentas " & m_cj_id
  
  With Propiedad.Grid
  
    .Columns.Clear
    
    With .Columns
  
      With .Add(Nothing)
        .Visible = False
        .Key = KI_MCJM_ID
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(4730, vbNullString)  'Cuenta
        .Key = KI_CUE_ID
      End With
            
      With .Add(Nothing)
        .name = LNGGetText(5119, vbNullString)  'Importe
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .Key = KI_IMPORTE
      End With
            
    End With
  
  End With
  
  pLoadCajaCuentas = True
End Function

Private Function pGetFilter() As cIABMProperty
  Set pGetFilter = m_ObjAbm.Properties.Item(c_filtro_cobrado)
End Function
