VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cEditDocEx"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cEditDocEx
' 16-07-06

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
    
'--------------------------------------------------------------------------------
Private Enum csEOrdenPagoItemTipo
  csEOpgiTCheques = 1
  csEOpgiTEfectivo = 2
  csEOpgiTOtros = 4
  csEOpgiTCtaCte = 5
  csEOpgiTChequesT = 6
End Enum

Private Enum csECobranzaItemTipo
  csECobziTCheques = 1
  csECobziTEfectivo = 2
  csECobziTTarjeta = 3
  csECobziTOtros = 4
  csECobziTCtaCte = 5
End Enum

Private Enum csEMovimientoFondoItemTipo
  csEMfiTCheques = 1
  csEMfiTEfectivo = 2
  csEMfiTChequesT = 6
  csEMfiTChequesI = 7
End Enum

' constantes
Private Const C_Module = "cEditDocEx"
Private Const c_Items = "ITEMS"
Private Const c_Otros = "OTROS"
Private Const c_Percepciones = "PERCEPCIONES"
Private Const c_Legajos = "LEGAJOS"

Private Const c_Fecha                            As String = "fecha"
Private Const c_Fechaentrega                     As String = "fechaE"
Private Const c_FechaIVA                         As String = "fechaIVA"
Private Const c_Nrodoc                           As String = "Comprobante"
Private Const c_Cai                              As String = "CAI"
Private Const c_Descrip                          As String = "Descrip"

Private Const c_Cheques = "Cheques"
Private Const c_ChequesT = "Cheque de Tercero"
Private Const c_Tarjeta = "Tarjetas"
Private Const c_Efectivo = "Efectivo"
Private Const c_ChequesI = "Ingreso de Cheques"

Private Const c_ChequeT = "chqt"

'////////////////////////////////////////////////////////////////////////////////////
' Contabilidad

  ' Asiento
    Private Const cscAsId                            As String = "as_id"

'////////////////////////////////////////////////////////////////////////////////////
' Compras

  ' PedidoCompra
    Private Const cscPcNrodoc                        As String = "pc_nrodoc"
    Private Const cscPcDescrip                       As String = "pc_descrip"
    Private Const cscPcFecha                         As String = "pc_fecha"
    Private Const cscPcFechaentrega                  As String = "pc_fechaentrega"
  
  ' PedidoCompraItem
    Private Const cscPciDescrip                      As String = "pci_descrip"
    
  ' RemitoCompra
    Private Const cscRcNrodoc                        As String = "rc_nrodoc"
    Private Const cscRcDescrip                       As String = "rc_descrip"
    Private Const cscRcFecha                         As String = "rc_fecha"
    Private Const cscRcFechaentrega                  As String = "rc_fechaentrega"
    
  ' RemitoCompraItem
    Private Const cscRciDescrip                      As String = "rci_descrip"
  
  ' FacturaCompra
    Private Const csTFacturaCompra                   As String = "FacturaCompra"
    Private Const cscFcId                            As String = "fc_id"
    Private Const cscFcDescrip                       As String = "fc_descrip"
    Private Const cscFcFecha                         As String = "fc_fecha"
    Private Const cscFcFechaentrega                  As String = "fc_fechaentrega"
    Private Const cscFcCai                           As String = "fc_cai"
    Private Const cscFcFechaIVA                      As String = "fc_fechaiva"
  
  ' FacturaCompraItem
    Private Const cscFciDescrip                      As String = "fci_descrip"
  
  ' FacturaCompraOtros
    Private Const csTFacturaCompraOtro               As String = "FacturaCompraOtro"
    Private Const cscFcotId                          As String = "fcot_id"
    Private Const cscFcotDescrip                     As String = "fcot_descrip"

  ' FacturaCompraLegajo
    Private Const csTFacturaCompraLegajo             As String = "FacturaCompraLegajo"
    Private Const cscFcLgjId                         As String = "fclgj_id"
    Private Const cscFcLgjImporte                    As String = "fclgj_importe"
    Private Const cscFcLgjDescrip                    As String = "fclgj_descrip"
    Private Const cscFcLgjImporteOrigen              As String = "fclgj_importeorigen"
    Private Const cscFcLgjOrden                      As String = "fclgj_orden"
    
  ' FacturaCompraPercepcion
    Private Const csTFacturaCompraPercepcion         As String = "FacturaCompraPercepcion"
    Private Const cscFcPercId                        As String = "fcperc_id"
    Private Const cscFcPercDescrip                   As String = "fcperc_descrip"

  ' Percepciones
    Private Const cscPercNombre                      As String = "perc_nombre"
    Private Const cscPercId                          As String = "perc_id"

'////////////////////////////////////////////////////////////////////////////////////
' Tesoreria

  ' Cobranza
    Private Const csTCobranza                      As String = "Cobranza"
    Private Const cscCobzId                        As String = "cobz_id"
    Private Const cscCobzNrodoc                    As String = "cobz_nrodoc"
    Private Const cscCobzDescrip                   As String = "cobz_descrip"
    Private Const cscCobzFecha                     As String = "cobz_fecha"

  ' CobranzaItem
    Private Const csTCobranzaItem                 As String = "CobranzaItem"
    Private Const cscCobziId                      As String = "cobzi_id"
    Private Const cscCobziDescrip                 As String = "cobzi_descrip"
    Private Const cscCobziPorcRetencion           As String = "cobzi_porcRetencion"
    Private Const cscCobziFechaRetencion          As String = "cobzi_fechaRetencion"
    Private Const cscCobziNroRetencion            As String = "cobzi_nroRetencion"

  ' Tarjeta de credito
    Private Const csTTarjetaCreditoCupon          As String = "TarjetaCreditoCupon"
    Private Const cscTjccId                       As String = "tjcc_id"
    Private Const cscTjccNumero                   As String = "tjcc_numero"
    Private Const cscTjccNumeroDoc                As String = "tjcc_numerodoc"
    Private Const cscTjcNombre                    As String = "tjc_nombre"
    Private Const cscTjccFechavto                 As String = "tjcc_fechavto"
    Private Const cscTjccNroTarjeta               As String = "tjcc_nroTarjeta"
    Private Const cscTjccNroAutorizacion          As String = "tjcc_nroAutorizacion"
    Private Const cscTjccTitular                  As String = "tjcc_titular"
    Private Const cscTjccDescrip                  As String = "tjcc_descrip"

  ' OrdenCompra
    Private Const cscOcNrodoc                      As String = "oc_nrodoc"
    Private Const cscOcDescrip                     As String = "oc_descrip"
    Private Const cscOcFecha                       As String = "oc_fecha"
    Private Const cscOcFechaentrega                As String = "oc_fechaentrega"
    
    Private Const csPreCpraEditPriceOrd = 17042
    
  ' OrdenCompraItem
    Private Const cscOciDescrip                    As String = "oci_descrip"
    Private Const cscOciPrecio                     As String = "oci_precio"
    Private Const cscOciPrecioUsr                  As String = "oci_precioUsr"

  ' OrdenPago
    Private Const csTOrdenPago                     As String = "OrdenPago"
    Private Const cscOpgId                         As String = "opg_id"
    Private Const cscOpgNrodoc                     As String = "opg_nrodoc"
    Private Const cscOpgDescrip                    As String = "opg_descrip"
    Private Const cscOpgFecha                      As String = "opg_fecha"
  
  ' OrdenPagoItem
    Private Const csTOrdenPagoItem                  As String = "OrdenPagoItem"
    Private Const cscOpgiId                         As String = "opgi_id"
    Private Const cscOpgiDescrip                    As String = "opgi_descrip"
    Private Const cscOpgiPorcRetencion              As String = "opgi_porcRetencion"
    Private Const cscOpgiFechaRetencion             As String = "opgi_fechaRetencion"
    Private Const cscOpgiNroRetencion               As String = "opgi_nroRetencion"
    
    
  ' Movimiento de Fondos
    Private Const csTMovimientoFondo                        As String = "MovimientoFondo"
    Private Const cscMfId                                   As String = "mf_id    "
    Private Const cscMfNrodoc                               As String = "mf_nrodoc"
    Private Const cscMfDescrip                              As String = "mf_descrip"
    Private Const cscMfFecha                                As String = "mf_fecha"
  
  ' Movimiento de Fondos Item
    Private Const csTMovimientoFondoItem            As String = "MovimientoFondoItem"
    Private Const cscMfiId                          As String = "mfi_id"
    Private Const cscMfiDescrip                     As String = "mfi_descrip"

'////////////////////////////////////////////////////////////////////////////////////
' Stock

  ' RecuentoSotck
    Private Const cscRsNrodoc                        As String = "rs_nrodoc"
    Private Const cscRsDescrip                       As String = "rs_descrip"
    Private Const cscRsFecha                         As String = "rs_fecha"
  
  ' RecuentoSotckItem
    Private Const cscRsiDescrip                      As String = "rsi_descrip"

'////////////////////////////////////////////////////////////////////////////////////
' ComEx
  
  ' PackingList
    Private Const cscPklstNrodoc                     As String = "pklst_nrodoc"
    Private Const cscPklstFecha                      As String = "pklst_fecha"
    Private Const cscPklstFechaEntrega               As String = "pklst_fechaentrega"
    Private Const cscPklstDescrip                    As String = "pklst_descrip"
    
  ' PackingListItem
    Private Const cscPkLstIdescrip                   As String = "pklsti_descrip"
    
  ' ManifiestoCarga
    Private Const cscMfcNrodoc                       As String = "mfc_nrodoc"
    Private Const cscMfcFecha                        As String = "mfc_fecha"
    Private Const cscMfcDescrip                      As String = "mfc_descrip"
  
  ' ManifiestoCargaItem
    Private Const cscMfcIdescrip                     As String = "mfci_descrip"
    
  ' PresupuestoEnvio
    Private Const cscPreeNrodoc                       As String = "pree_nrodoc"
    Private Const cscPreeDescrip                      As String = "pree_descrip"
    Private Const cscPreeFecha                        As String = "pree_fecha"
    Private Const cscPreeFechaentrega                 As String = "pree_fechaentrega"
    
  ' PresupuestoEnvioItem
    Private Const cscPreeIdescrip                     As String = "preei_descrip"
   
'////////////////////////////////////////////////////////////////////////////////////
' Ventas

  ' Condicion de Pago
  Private Const csTCondicionPago                   As String = "CondicionPago"

  ' FacturaVenta
  Private Const csTFacturaVenta                    As String = "FacturaVenta"
  Private Const cscFvId                            As String = "fv_id"
  Private Const cscFvDescrip                       As String = "fv_descrip"
  Private Const cscFvFecha                         As String = "fv_fecha"
  Private Const cscFvFechaentrega                  As String = "fv_fechaentrega"
  Private Const cscFvFechaIVA                      As String = "fv_fechaiva"

  ' FacturaVentaItem
  Private Const cscFviId                           As String = "fvi_id"
  Private Const cscFviDescrip                      As String = "fvi_descrip"

  ' PedidoVenta
  Private Const cscPvNrodoc                        As String = "pv_nrodoc"
  Private Const cscPvDescrip                       As String = "pv_descrip"
  Private Const cscPvFecha                         As String = "pv_fecha"
  Private Const cscPvFechaentrega                  As String = "pv_fechaentrega"
  
  ' PedidoVentaItem
  Private Const cscPviDescrip                      As String = "pvi_descrip"
  
  ' RemitoVenta
  Private Const cscRvNrodoc                        As String = "rv_nrodoc"
  Private Const cscRvDescrip                       As String = "rv_descrip"
  Private Const cscRvFecha                         As String = "rv_fecha"
  Private Const cscRvFechaentrega                  As String = "rv_fechaentrega"
  
  ' FacturaVentaItem
  Private Const cscRviDescrip                      As String = "rvi_descrip"
  
'////////////////////////////////////////////////////////////////////////////////////
' Genericos

  ' CentroCostos
  Private Const cscCcosId                          As String = "ccos_id"
  Private Const cscCcosNombre                      As String = "ccos_nombre"
  
  ' Sucursal
  Private Const cscSucNombre                       As String = "suc_nombre"
  
  ' Legajo
  Private Const cscLgjId                           As String = "lgj_Id"
  Private Const cscLgjCodigo                       As String = "lgj_Codigo"
  
  ' Provincia
  Private Const cscProIdOrigen                     As String = "pro_id_origen"
  Private Const cscProIdDestino                    As String = "pro_id_destino"
  
  ' Cliente Sucursal
  Private Const cscClisId                          As String = "clis_id"
  Private Const cscClisNombre                      As String = "clis_nombre"

  ' Cheque
  Private Const csTCheque                          As String = "Cheque"
  Private Const cscCheqId                          As String = "cheq_id"
  Private Const cscCheqNumeroDoc                   As String = "cheq_numerodoc"
  Private Const cscCheqNumero                      As String = "cheq_numero"
  Private Const cscCheqFechaVto                    As String = "cheq_fechaVto"
  Private Const cscCheqFechaCobro                  As String = "cheq_fechaCobro"
  Private Const cscCheqDescrip                     As String = "cheq_descrip"

  ' Clearing
  Private Const cscCleNombre                       As String = "cle_nombre"
  Private Const cscCleId                           As String = "cle_id"
  
  ' Cliente
  Private Const cscCliNombre                       As String = "cli_nombre"
  
  ' Banco
  Private Const cscBcoNombre                       As String = "bco_nombre"
  
  ' Condicion de Pago
  Private Const cscCpgAsientoXVto                  As String = "cpg_asientoXVto"
  
  ' Chofer
  Private Const cscChofId                          As String = "chof_id"
  Private Const cscChofNombre                      As String = "chof_nombre"
  
  ' Camion
  Private Const cscCamId                           As String = "cam_id"
  Private Const cscCamPatente                      As String = "cam_patente"
  
' Facturas en retenciones de pagos y cobranzas
  Private Const cscFcIdRet                                 As String = "fc_id_ret"
  Private Const cscFvIdRet                                 As String = "fv_id_ret"

  Private Const csFacturaCompra = 17001
  Private Const csFacturaVenta = 16001
  
'////////////////////////////////////////////////////////////////////////////////////

Private Const K_NRODOC                         As Integer = 1
Private Const K_DESCRIP                        As Integer = 2
Private Const K_FECHA                          As Integer = 3
Private Const K_FECHAENTREGA                   As Integer = 4
Private Const K_FECHAIVA                       As Integer = 101
Private Const K_ITEMS                          As Integer = 5
Private Const K_CCOS_ID                        As Integer = 6
Private Const K_SUC_ID                         As Integer = 7
Private Const K_VEN_ID                         As Integer = 8
Private Const K_LGJ_ID                         As Integer = 9
Private Const K_CAI                            As Integer = 10


Private Const K_PRO_ID_ORIGEN                  As Integer = 11
Private Const K_PRO_ID_DESTINO                 As Integer = 12
Private Const K_TRANS_ID                       As Integer = 13
Private Const K_CHOF_ID                        As Integer = 601
Private Const K_CAM_ID                         As Integer = 602
Private Const K_CLIS_ID                        As Integer = 14

Private Const K_OTROS                          As Integer = 15
Private Const K_PERCEPCIONES                   As Integer = 16
Private Const K_LEGAJOS                        As Integer = 17

Private Const K_CHEQUES                        As Integer = 18
Private Const K_EFECTIVO                       As Integer = 19
Private Const K_CTACTE                         As Integer = 20
Private Const K_CHEQUEST                       As Integer = 21
Private Const K_CHEQUESI                       As Integer = 22
Private Const K_TARJETA                        As Integer = 23

Private Const KICH_OPGI_ID                     As Integer = 23
Private Const KICH_CUE_ID                      As Integer = 24
Private Const KICH_CHEQUERA                    As Integer = 25
Private Const KICH_CHEQUE                      As Integer = 26
Private Const KICH_CHEQ_ID                     As Integer = 27
Private Const KICH_FECHACOBRO                  As Integer = 28
Private Const KICH_FECHAVTO                    As Integer = 29
Private Const KICH_CLE_ID                      As Integer = 30
Private Const KICH_DESCRIP                     As Integer = 31

Private Const KIE_OPGI_ID                      As Integer = 32
Private Const KIE_CUE_ID                       As Integer = 33
Private Const KIE_DESCRIP                      As Integer = 34

Private Const KICHT_CUE_ID                     As Integer = 37
Private Const KICHT_CLI_ID                     As Integer = 39
Private Const KICHT_BCO_ID                     As Integer = 40

Private Const KI_I_ID                          As Integer = 45
Private Const KI_DESCRIP                       As Integer = 46
Private Const KI_PR_ID                         As Integer = 47
Private Const KI_CCOS_ID                       As Integer = 48

Private Const KI_FCOT_ID                       As Integer = 49
Private Const KI_CUE_ID                        As Integer = 50

Private Const KIP_FCPERC_ID                    As Integer = 51
Private Const KIP_PERC_ID                      As Integer = 52
Private Const KIP_DESCRIP                      As Integer = 53

Private Const KIL_FCLGJ_ID                     As Integer = 54
Private Const KIL_LGJ_ID                       As Integer = 55
Private Const KIL_IMPORTE                      As Integer = 56
Private Const KIL_DESCRIP                      As Integer = 57

Private Const KIO_RET_ID                       As Integer = 58
Private Const KIO_NRORETENCION                 As Integer = 59
Private Const KIO_PORCRETENCION                As Integer = 60
Private Const KIO_FECHARETENCION               As Integer = 61

Private Const KIT_COBZI_ID                     As Integer = 62
Private Const KIT_TJCC_ID                      As Integer = 63
Private Const KIT_CUPON                        As Integer = 64
Private Const KIT_TJC_ID                       As Integer = 65
Private Const KIT_FECHAVTO                     As Integer = 66
Private Const KIT_NROTARJETA                   As Integer = 67
Private Const KIT_NROAUTORIZACION              As Integer = 68
Private Const KIT_TITULAR                      As Integer = 69
Private Const KIT_DESCRIP                      As Integer = 70

Private Const KICH_MFI_ID                      As Integer = 71
Private Const KICHT_MFI_ID                     As Integer = 72

Private Const KI_OCI_PRECIO                    As Integer = 73

Private Const KIO_FV_ID_RET                    As Integer = 74
Private Const KIO_FC_ID_RET                    As Integer = 75

Private Const csLegajo = 15001
' estructuras
' Seudo - Variables
Private c_ErrorSave         As String

' variables privadas
Private m_Id                As Long

Private m_GeneralConfig     As cGeneralConfig

Private m_Nrodoc                       As String
Private m_descrip                      As String
Private m_Fecha                        As Date
Private m_Fechaentrega                 As Date
Private m_FechaIVA                     As Date
Private m_ven_id                       As Long
Private m_Vendedor                     As String
Private m_Cai                          As String
Private m_lgj_id                       As Long
Private m_Legajo                       As String
'
Private m_clis_id                      As Long
Private m_ClienteSucursal              As String
Private m_suc_id                       As Long
Private m_Sucursal                     As String
'
Private m_pro_id_origen                As Long
Private m_ProOrigen                    As String
Private m_pro_id_destino               As Long
Private m_ProDestino                   As String
'
Private m_trans_id                     As String
Private m_Transporte                   As String
Private m_chof_id                      As Long
Private m_Chofer                       As String
Private m_cam_id                       As Long
Private m_Camion                       As String

Private m_ccos_id                      As Long
Private m_CentroCosto                  As String

' Para edicion de precios en ordenes de compra
'
Private m_bOciPrecioChanged           As Boolean
Private m_lColOciPrecio               As Long

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric

Private m_TaMascara         As String

Private m_Table             As String
Private m_FieldId           As String
Private m_PreIdNew          As Long
Private m_PreIdEdit         As Long
Private m_DoctId            As Long

Private m_TableItem         As String
Private m_FieldItemId       As String

Private m_cli_id            As Long
Private m_prov_id           As Long

Private m_ObjectClient      As Object
Private m_DocEditable       As Boolean
Private m_DocEditMsg        As Boolean
Private m_DocId             As Long

Private m_Cotizacion        As Double
Private m_bMonedaLegal      As Boolean

Private m_LegajosDeleted    As String

' propiedades publicas
Public Property Set ObjectClient(ByVal rhs As Object)
  Set m_ObjectClient = rhs
End Property

Public Property Let Cotizacion(ByVal rhs As Double)
  m_Cotizacion = rhs
End Property

Public Property Let bMonedaLegal(ByVal rhs As Double)
  m_bMonedaLegal = rhs
End Property

' propiedades privadas
' funciones publicas

Public Function Edit(ByVal Id As Long, _
                     ByVal doct_id As Long, _
                     ByVal Table As String, _
                     ByVal fieldId As String, _
                     ByVal TableItem As String, _
                     ByVal FieldItemId As String, _
                     ByVal PreIdNew As Long, _
                     ByVal PreIdEdit As Long, _
                     ByVal cli_id As Long, _
                     ByVal prov_id As Long, _
                     Optional ByVal InModalWindow As Boolean) As Boolean
  m_Id = Id
  m_DoctId = doct_id
  m_Table = Table
  m_FieldId = fieldId
  m_PreIdEdit = PreIdEdit
  m_PreIdNew = PreIdNew
  m_FieldItemId = FieldItemId
  m_TableItem = TableItem
  m_cli_id = cli_id
  m_prov_id = prov_id

  If Not SecurityCanAccess(m_PreIdEdit) Then Exit Function
  
  Dim DocId     As Long
  Dim DocEmpId  As Long
  
  If Not gDB.GetData(m_Table, m_FieldId, m_Id, cscDocId, DocId) Then Exit Function
  
  If Not gDB.GetData(csTDocumento, cscDocId, DocId, cscEmpId, DocEmpId) Then Exit Function
  
  If DocEmpId <> EmpId Then
    Dim emp_nombre As String
    
    If Not gDB.GetData("empresa", "emp_id", DocEmpId, "emp_nombre", emp_nombre) Then Exit Function
    MsgWarning LNGGetText(2829, vbNullString, emp_nombre)
               'Este Documento fue creado en la empresa  & emp_nombre &  para editarlo & _
                debe ingresar a dicha empresa.
    Exit Function
  End If
  
  If m_ObjAbm Is Nothing Then
    Set m_ObjAbm = New cABMGeneric
  End If
  
  m_ObjAbm.InModalWindow = InModalWindow
  
  If Not Load(Id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
      
  m_Editing = True

  If InModalWindow Then
    Edit = m_Id <> csNO_ID
  Else
    Edit = True
  End If

  Exit Function
ControlError:
  MngError Err, C_EditGenericEdit, C_Module, vbNullString
End Function

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean

End Function

Private Function cIABMClient_EditNew() As Boolean

End Function

Private Property Get cIABMClient_Aplication() As String
  cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
  cIABMClient_CanAddDocDigital = m_Id <> csNO_ID
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
  cIABMClient_CanCopy = False
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = False
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
  On Error GoTo ControlError
  
  If m_Id = csNO_ID Then Exit Function
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = m_Table
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
                               m_PreIdNew
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    Case Else
      cIABMClient_MessageEx = True
  End Select
End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(Lista As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal clave As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Dim fieldNroDoc   As String
  Dim fieldDescrip  As String
  Dim fieldFecha    As String
  Dim fieldFechaE   As String
  Dim fieldFechaIVA As String
  Dim fieldCAI      As String
  
  Select Case m_DoctId
  
    Case csEDT_PedidoCompra, csEDT_DevolucionPedidoCpra
      fieldNroDoc = cscPcNrodoc
      fieldDescrip = cscPcDescrip
      fieldFecha = cscPcFecha
      fieldFechaE = cscPcFechaentrega
      
    Case csEDT_RemitoCompra, csEDT_DevolucionRemitoCpra
      fieldNroDoc = cscRcNrodoc
      fieldDescrip = cscRcDescrip
      fieldFecha = cscRcFecha
      fieldFechaE = cscRcFechaentrega
      
    Case csEDT_FacturaCompra, csEDT_NotaCreditoCompra, csEDT_NotaDebitoCompra
      fieldNroDoc = cscFcNrodoc
      fieldDescrip = cscFcDescrip
      fieldFecha = cscFcFecha
      fieldFechaE = cscFcFechaentrega
      fieldCAI = cscFcCai
      fieldFechaIVA = cscFcFechaIVA
      
    Case csEDT_FacturaVenta, csEDT_NotaCreditoVenta, csEDT_NotaDebitoVenta
      fieldNroDoc = cscFvNrodoc
      fieldDescrip = cscFvDescrip
      fieldFecha = cscFvFecha
      fieldFechaE = cscFvFechaentrega
      fieldCAI = cscFvCai
      fieldFechaIVA = cscFvFechaIVA

    Case csEDT_PedidoVenta, csEDT_DevolucionPedidoVta
      fieldNroDoc = cscPvNrodoc
      fieldDescrip = cscPvDescrip
      fieldFecha = cscPvFecha
      fieldFechaE = cscPvFechaentrega
      
    Case csEDT_RemitoVenta, csEDT_DevolucionRemitoVta
      fieldNroDoc = cscRvNrodoc
      fieldDescrip = cscRvDescrip
      fieldFecha = cscRvFecha
      fieldFechaE = cscRvFechaentrega
      
    Case csEDT_OrdenCompra, csEDT_DevolucionOrdenCpra
      fieldNroDoc = cscOcNrodoc
      fieldDescrip = cscOcDescrip
      fieldFecha = cscOcFecha
      fieldFechaE = cscOcFechaentrega
      
    Case csEDT_RecuentoStock
      fieldNroDoc = cscRsNrodoc
      fieldDescrip = cscRsDescrip
      fieldFecha = cscRsFecha
      
    Case csEDT_PackingList, csEDT_PackingListDevolucion
      fieldNroDoc = cscPklstNrodoc
      fieldDescrip = cscPklstDescrip
      fieldFecha = cscPklstFecha
      fieldFechaE = cscPklstFechaEntrega
      
    Case csEDT_ManifiestoCarga, csEDT_DevolucionManifiesto
      fieldNroDoc = cscMfcNrodoc
      fieldDescrip = cscMfcDescrip
      fieldFecha = cscMfcFecha
      
    Case csEDT_PresupuestoEnvio
      fieldNroDoc = cscPreeNrodoc
      fieldDescrip = cscPreeDescrip
      fieldFecha = cscPreeFecha
      fieldFechaE = cscPreeFechaentrega
      
    Case csEDT_OrdenPago
      fieldNroDoc = cscOpgNrodoc
      fieldDescrip = cscOpgDescrip
      fieldFecha = cscOpgFecha
      
    Case csEDT_Cobranza
      fieldNroDoc = cscCobzNrodoc
      fieldDescrip = cscCobzDescrip
      fieldFecha = cscCobzFecha
      
    Case csEDT_MovimientoFondo
      fieldNroDoc = cscMfNrodoc
      fieldDescrip = cscMfDescrip
      fieldFecha = cscMfFecha
      
  End Select
  
  Dim IProperty As cIABMProperty
  Dim register  As cRegister
  Dim fields    As cFields
  
  Set register = New cRegister
  With register
    
    .fieldId = m_FieldId
    .Table = m_Table
    .Id = m_Id
  
    Set fields = .fields
    
    For Each IProperty In m_ObjAbm.Properties
      With IProperty
        Select Case .Key
          
          Case K_NRODOC
            fields.Add2 fieldNroDoc, .Value, csText
          Case K_DESCRIP
            fields.Add2 fieldDescrip, .Value, csText
          Case K_FECHA
            fields.Add2 fieldFecha, .Value, csDate
          Case K_FECHAENTREGA
            fields.Add2 fieldFechaE, .Value, csDate
          Case K_FECHAIVA
            fields.Add2 fieldFechaIVA, .Value, csDate
          Case K_CAI
            fields.Add2 fieldCAI, .Value, csText
          Case K_CCOS_ID
            fields.Add2 cscCcosId, .HelpId, csId
          Case K_SUC_ID
            fields.Add2 cscSucId, .HelpId, csId
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
          Case K_CHOF_ID
            fields.Add2 cscChofId, .HelpId, csId
          Case K_CAM_ID
            fields.Add2 cscCamId, .HelpId, csId
          Case K_CLIS_ID
            fields.Add2 cscClisId, .HelpId, csId
        
        End Select
      End With
    Next
  
    With fields
  
      .HaveLastUpdate = True
      .HaveWhoModify = True
    End With
    
    Dim bChangePreciosInOC As Boolean
    
    If m_DoctId = csEDT_OrdenCompra Or m_DoctId = csEDT_DevolucionOrdenCpra Then
      If m_bOciPrecioChanged Then
        bChangePreciosInOC = Ask(LNGGetText(3596, vbNullString), vbNo)
      End If
    End If
    
    If Not .BeginTrans(gDB) Then Exit Function
  
    If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
    Select Case m_DoctId
      
      Case csEDT_OrdenPago, csEDT_Cobranza, csEDT_MovimientoFondo, _
           csEDT_DepositoCupon
      
        ' Nada que hacer
      
      Case Else
        
        If Not pSaveItems(.Id) Then Exit Function
    
    End Select
    
    Select Case m_DoctId
      
      Case csEDT_FacturaCompra, csEDT_NotaCreditoCompra, csEDT_NotaDebitoCompra
    
        If Not pSaveOtros(.Id) Then Exit Function
        If Not pSavePercepciones(.Id) Then Exit Function
        If Not pSaveLegajos(.Id) Then Exit Function
    
    End Select
    
    Select Case m_DoctId
    
      Case csEDT_OrdenPago, csEDT_Cobranza
      
        If Not pSaveOtros(.Id) Then Exit Function
        If Not pSaveTCheques(.Id) Then Exit Function
        If Not pSaveEfectivo(.Id) Then Exit Function
        
    End Select
    
    Select Case m_DoctId
      
      Case csEDT_Cobranza
      
        If Not pSaveTarjetas(.Id) Then Exit Function
        
    End Select
    
    Select Case m_DoctId
      
      Case csEDT_OrdenPago, csEDT_MovimientoFondo
        
        If Not pSaveCheques(.Id) Then Exit Function
        
    End Select
    
    Select Case m_DoctId
      
      Case csEDT_MovimientoFondo
        
        If Not pSaveTCheques(.Id) Then Exit Function
        If Not pSaveICheques(.Id) Then Exit Function
        If Not pSaveEfectivo(.Id) Then Exit Function
        
    End Select
    
    Select Case m_DoctId
    
      Case csEDT_FacturaCompra, csEDT_NotaCreditoCompra, csEDT_NotaDebitoCompra
        If Not pSaveVencimientos(True) Then Exit Function
        
      Case csEDT_FacturaVenta, csEDT_NotaCreditoVenta, csEDT_NotaDebitoVenta
        If Not pSaveVencimientos(False) Then Exit Function
    
    End Select
  
    If Not pSaveFechaAsiento() Then Exit Function
  
    If bChangePreciosInOC Then
      If Not pChangePreciosInOc() Then Exit Function
    End If
  
    If Not .CommitTrans() Then Exit Function
  
  End With
  
  cIABMClient_Save = Load(m_Id)

  ' Edit Apply
  '
  pRefreshClient

End Function

Private Function pChangePreciosInOc() As Boolean
  Dim sqlstmt As String
  sqlstmt = "sp_DocOrdenCompraUpdatePrecios " & m_Id
  pChangePreciosInOc = gDB.Execute(sqlstmt)
End Function

Private Function pSaveItems(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  
  Dim fieldDescrip  As String
  
  Select Case m_DoctId
  
    Case csEDT_PedidoCompra, csEDT_DevolucionPedidoCpra
      fieldDescrip = cscPciDescrip
      
    Case csEDT_RemitoCompra, csEDT_DevolucionRemitoCpra
      fieldDescrip = cscRciDescrip
      
    Case csEDT_FacturaCompra, csEDT_NotaCreditoCompra, csEDT_NotaDebitoCompra
      fieldDescrip = cscFciDescrip
      
    Case csEDT_FacturaVenta, csEDT_NotaCreditoVenta, csEDT_NotaDebitoVenta
      fieldDescrip = cscFviDescrip
      
    Case csEDT_PedidoVenta, csEDT_DevolucionPedidoVta
      fieldDescrip = cscPviDescrip
      
    Case csEDT_RemitoVenta, csEDT_DevolucionRemitoVta
      fieldDescrip = cscRviDescrip
      
    Case csEDT_OrdenCompra, csEDT_DevolucionOrdenCpra
      fieldDescrip = cscOciDescrip
      
    Case csEDT_RecuentoStock
      fieldDescrip = cscRsiDescrip
      
    Case csEDT_PackingList, csEDT_PackingListDevolucion
      fieldDescrip = cscPkLstIdescrip
      
    Case csEDT_ManifiestoCarga, csEDT_DevolucionManifiesto
      fieldDescrip = cscMfcIdescrip
      
    Case csEDT_PresupuestoEnvio
      fieldDescrip = cscPreeIdescrip
      
  End Select

  
  For Each Row In m_ObjAbm.Properties(c_Items).Grid.Rows
  
    Set register = New cRegister
    
    With register
      
      .fieldId = m_FieldItemId
      .Table = m_TableItem
    
      With .fields
      
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_I_ID
              register.Id = Val(Cell.Value)
            Case KI_DESCRIP
              .Add2 fieldDescrip, Cell.Value, csText
            Case KI_CCOS_ID
              .Add2 cscCcosId, Cell.Id, csId
            Case KI_OCI_PRECIO
              .Add2 cscOciPrecio, Cell.Value, csCurrency
              .Add2 cscOciPrecioUsr, Cell.Value, csCurrency
          End Select
        Next
    
        .HaveLastUpdate = False
        .HaveWhoModify = False
      
      End With
    End With
    
    If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
  
  Next
  
  pSaveItems = True
End Function

Private Function pSaveOtros(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  
  For Each Row In m_ObjAbm.Properties(c_Otros).Grid.Rows
  
    Set register = New cRegister
    
    With register
      
      Select Case m_DoctId
    
        Case csEDT_FacturaCompra, csEDT_NotaCreditoCompra, csEDT_NotaDebitoCompra
          .fieldId = cscFcotId
          .Table = csTFacturaCompraOtro
        Case csEDT_OrdenPago
          .fieldId = cscOpgiId
          .Table = csTOrdenPagoItem
        Case csEDT_Cobranza
          .fieldId = cscCobziId
          .Table = csTCobranzaItem
      End Select
    
      With .fields
    
        Select Case m_DoctId
      
          Case csEDT_FacturaCompra, csEDT_NotaCreditoCompra, csEDT_NotaDebitoCompra
      
            For Each Cell In Row
              Select Case Cell.Key
                
                Case KI_FCOT_ID
                  register.Id = Val(Cell.Value)
                Case KI_DESCRIP
                  .Add2 cscFcotDescrip, Cell.Value, csText
                Case KI_CCOS_ID
                  .Add2 cscCcosId, Cell.Id, csId
              End Select
            Next
      
          Case csEDT_OrdenPago
          
            For Each Cell In Row
              Select Case Cell.Key
                
                Case KI_FCOT_ID
                  register.Id = Val(Cell.Value)
                Case KI_DESCRIP
                  .Add2 cscOpgiDescrip, Cell.Value, csText
                Case KI_CCOS_ID
                  .Add2 cscCcosId, Cell.Id, csId
                
                Case KIO_RET_ID
                  .Add2 cscRetId, Cell.Id, csId
                Case KIO_NRORETENCION
                  .Add2 cscOpgiNroRetencion, Cell.Value, csText
                Case KIO_PORCRETENCION
                  .Add2 cscOpgiPorcRetencion, Val(Cell.Value), csDouble
                Case KIO_FECHARETENCION
                  .Add2 cscOpgiFechaRetencion, Cell.Value, csDate
                  
                Case KIO_FC_ID_RET
                  .Add2 cscFcIdRet, Cell.Id, csId
              End Select
            Next
    
          Case csEDT_Cobranza
          
            For Each Cell In Row
              Select Case Cell.Key
                
                Case KI_FCOT_ID
                  register.Id = Val(Cell.Value)
                Case KI_DESCRIP
                  .Add2 cscCobziDescrip, Cell.Value, csText
                Case KI_CCOS_ID
                  .Add2 cscCcosId, Cell.Id, csId
                
                Case KIO_RET_ID
                  .Add2 cscRetId, Cell.Id, csId
                Case KIO_NRORETENCION
                  .Add2 cscCobziNroRetencion, Cell.Value, csText
                Case KIO_PORCRETENCION
                  .Add2 cscCobziPorcRetencion, Val(Cell.Value), csDouble
                Case KIO_FECHARETENCION
                  .Add2 cscCobziFechaRetencion, Cell.Value, csDate
              
                Case KIO_FV_ID_RET
                  .Add2 cscFvIdRet, Cell.Id, csId
              End Select
            Next
        End Select
    
        .HaveLastUpdate = False
        .HaveWhoModify = False
      
      End With
    End With
    
    If Not gDB.Save(register, , "pSaveOtros", C_Module, c_ErrorSave) Then Exit Function
  
  Next
  
  pSaveOtros = True
End Function

Private Function pSavePercepciones(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  
  For Each Row In m_ObjAbm.Properties(c_Percepciones).Grid.Rows
  
    Set register = New cRegister
    
    With register
      
      .fieldId = cscFcPercId
      .Table = csTFacturaCompraPercepcion
    
      With .fields
      
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KIP_FCPERC_ID
              register.Id = Val(Cell.Value)
            Case KIP_DESCRIP
              .Add2 cscFcPercDescrip, Cell.Value, csText
            Case KI_CCOS_ID
              .Add2 cscCcosId, Cell.Id, csId
          End Select
        Next
    
        .HaveLastUpdate = False
        .HaveWhoModify = False
      
      End With
    End With
    
    If Not gDB.Save(register, , "pSavePercepciones", C_Module, c_ErrorSave) Then Exit Function
  
  Next
  
  pSavePercepciones = True
End Function

Private Function pSaveLegajos(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim IProperty As cIABMProperty
  Dim iOrden    As Long
  Dim Origen    As Double
  
  With m_ObjAbm.Properties.Item(c_Legajos)
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      Set register = New cRegister
      With register
        
        .fieldId = cscFcLgjId
        .Table = csTFacturaCompraLegajo
      
        With .fields
        
          For Each Cell In Row
            Select Case Cell.Key
              
              Case KIL_FCLGJ_ID
                register.Id = Val(Cell.Value)
              Case KIL_LGJ_ID
                .Add2 cscLgjId, Cell.Id, csId
              Case KIL_IMPORTE
                Origen = Val(Cell.Value)
                .Add2 cscFcLgjImporte, Origen * m_Cotizacion, csCurrency
              Case KI_CCOS_ID
                .Add2 cscCcosId, Cell.Id, csId
              Case KIL_DESCRIP
                .Add2 cscFcLgjDescrip, Cell.Value, csText
            End Select
          Next
          
          If m_bMonedaLegal Then
            .Add2 cscFcLgjImporteOrigen, 0, csCurrency
          Else
            .Add2 cscFcLgjImporteOrigen, Origen, csCurrency
          End If
          
          iOrden = iOrden + 1
          .Add2 cscFcLgjOrden, iOrden, csInteger
          
          .HaveLastUpdate = False
          .HaveWhoModify = False
        
        End With
      End With
      
      If Not gDB.Save(register, , "pSaveLegajos", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_LegajosDeleted) And m_Id <> csNO_ID Then
  
    Dim vDeletes As Variant
    Dim i As Long
    
    m_LegajosDeleted = RemoveLastColon(m_LegajosDeleted)
    vDeletes = Split(m_LegajosDeleted, ",")
    
    For i = 0 To UBound(vDeletes)
    
      sqlstmt = "Delete FacturaCompraLegajo where fclgj_id = " & vDeletes(i)
      
      If Not gDB.Execute(sqlstmt, "pSaveLegajos", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveLegajos = True
End Function

Private Function pSaveCheques(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim IProperty As cIABMProperty
        
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  Dim fieldDescrip As String
  
  For Each Row In m_ObjAbm.Properties.Item(c_Cheques).Grid.Rows
  
    Set register = New cRegister
    With register
      
      Select Case m_DoctId
    
        Case csEDT_OrdenPago
          .fieldId = cscOpgiId
          .Table = csTOrdenPagoItem
          fieldDescrip = cscOpgiDescrip
          
        Case csEDT_MovimientoFondo
          .fieldId = cscMfiId
          .Table = csTMovimientoFondoItem
          fieldDescrip = cscMfiDescrip
          
      End Select
    
      With .fields
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KICH_OPGI_ID
              register.Id = Val(Cell.Value)
            
            Case KICH_DESCRIP
              .Add2 fieldDescrip, Cell.Value, csText
            
          End Select
        Next
        
        .HaveLastUpdate = False
        .HaveWhoModify = False
    
      End With
    End With
    
    If Not gDB.Save(register, , "pSaveCheques", C_Module, c_ErrorSave) Then Exit Function
    
    If Not pSaveChequeAux(Row) Then Exit Function
    
  Next
  
  pSaveCheques = True
End Function

Private Function pSaveEfectivo(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim IProperty As cIABMProperty
        
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  Dim fieldDescrip As String
  
  For Each Row In m_ObjAbm.Properties.Item(c_Efectivo).Grid().Rows
  
    Set register = New cRegister
    With register
      
      Select Case m_DoctId
    
        Case csEDT_OrdenPago
          .fieldId = cscOpgiId
          .Table = csTOrdenPagoItem
          fieldDescrip = cscOpgiDescrip
          
        Case csEDT_Cobranza
          .fieldId = cscCobziId
          .Table = csTCobranzaItem
          fieldDescrip = cscCobziDescrip
          
        Case csEDT_MovimientoFondo
          .fieldId = cscMfiId
          .Table = csTMovimientoFondoItem
          fieldDescrip = cscMfiDescrip
          
      End Select
    
      With .fields
      
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KIE_OPGI_ID
              register.Id = Val(Cell.Value)
            Case KIE_DESCRIP
              .Add2 fieldDescrip, Cell.Value, csText
          End Select
        Next
        
        .HaveLastUpdate = False
        .HaveWhoModify = False
        
      End With
    End With
    
    If Not gDB.Save(register, , "pSaveEfectivo", C_Module, c_ErrorSave) Then Exit Function
  Next
  
  pSaveEfectivo = True
End Function

Private Function pSaveTCheques(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  
  Dim fieldDescrip As String
  
  For Each Row In m_ObjAbm.Properties.Item(c_ChequesT).Grid.Rows
    
    Set register = New cRegister
    With register
      
      Select Case m_DoctId
    
        Case csEDT_OrdenPago
          .fieldId = cscOpgiId
          .Table = csTOrdenPagoItem
          fieldDescrip = cscOpgiDescrip
          
        Case csEDT_Cobranza
          .fieldId = cscCobziId
          .Table = csTCobranzaItem
          fieldDescrip = cscCobziDescrip
          
        Case csEDT_MovimientoFondo
          .fieldId = cscMfiId
          .Table = csTMovimientoFondoItem
          fieldDescrip = cscMfiDescrip
          
      End Select
    
      With .fields
      
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KICH_OPGI_ID
              register.Id = Val(Cell.Value)
              
            Case KICH_DESCRIP
              .Add2 fieldDescrip, Cell.Value, csText
            
          End Select
        Next
        
        .HaveLastUpdate = False
        .HaveWhoModify = False
        
      End With
    End With
    
    If Not gDB.Save(register, , "pSaveTCheques", C_Module, c_ErrorSave) Then Exit Function
    
    If Not pSaveChequeAux(Row) Then Exit Function
    
  Next
  
  pSaveTCheques = True
End Function

Private Function pSaveICheques(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue

  For Each Row In m_ObjAbm.Properties.Item(c_ChequesI).Grid.Rows

    Set register = New cRegister
    With register
      
      .fieldId = cscMfiId
      .Table = csTMovimientoFondoItem

      With .fields
      
        For Each Cell In Row
          Select Case Cell.Key
    
            Case KICH_MFI_ID
              register.Id = Val(Cell.Value)
            
            Case KICH_DESCRIP
              .Add2 cscMfiDescrip, Cell.Value, csText
    
          End Select
        Next
        
        .HaveLastUpdate = False
        .HaveWhoModify = False
    
      End With
    End With
    
    If Not gDB.Save(register, , "pSaveICheques", C_Module, c_ErrorSave) Then Exit Function
    
    If Not pSaveChequeAux(Row) Then Exit Function
    
  Next

  pSaveICheques = True
End Function

Private Function pSaveTarjetas(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  
  For Each Row In m_ObjAbm.Properties.Item(c_Tarjeta).Grid.Rows
  
    Set register = New cRegister
    With register
      
      .fieldId = cscCobziId
      .Table = csTCobranzaItem
    
      With .fields
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KIT_COBZI_ID
              register.Id = Val(Cell.Value)
            Case KIT_DESCRIP
              register.fields.Add2 cscCobziDescrip, Cell.Value, csText
          End Select
        Next
    
        .HaveLastUpdate = False
        .HaveWhoModify = False
        
      End With
    End With
    
    If Not gDB.Save(register, , "pSaveTarjetas", C_Module, c_ErrorSave) Then Exit Function
    
    If Not pSaveCupon(Row) Then Exit Function
    
  Next
  
  pSaveTarjetas = True
End Function

Private Function pSaveChequeAux(ByRef Row As cIABMGridRow) As Boolean
  Dim register  As cRegister
  Dim Cell      As cIABMGridCellValue
  Dim sqlstmt   As String
  
  Set register = New cRegister
  With register
    
    .fieldId = cscCheqId
    .Table = csTCheque
  
    With .fields
      For Each Cell In Row
        Select Case Cell.Key
          
          Case KICH_CHEQ_ID
            register.Id = Cell.Id
          Case KICH_DESCRIP
            register.fields.Add2 cscCheqDescrip, Cell.Value, csText
          Case KICH_CHEQUE
            register.fields.Add2 cscCheqNumeroDoc, Cell.Value, csText
          Case KICH_FECHACOBRO
            register.fields.Add2 cscCheqFechaCobro, Cell.Value, csDate
          Case KICH_FECHAVTO
            register.fields.Add2 cscCheqFechaVto, Cell.Value, csDate
          Case KICH_CLE_ID
            register.fields.Add2 cscCleId, Cell.Id, csId
          Case KICHT_BCO_ID
            register.fields.Add2 cscBcoId, Cell.Id, csId
        End Select
      Next
  
      .HaveLastUpdate = False
      .HaveWhoModify = False
      
    End With
  End With
  
  If Not gDB.Save(register, False, "pSaveChequeAux", C_Module, c_ErrorSave) Then Exit Function
  
  sqlstmt = "sp_DocChequeFechaUpdate " & register.Id
  If Not gDB.Execute(sqlstmt) Then Exit Function
  
  pSaveChequeAux = True
End Function

Private Function pSaveCupon(ByRef Row As cIABMGridRow) As Boolean
  Dim register  As cRegister
  Dim Cell      As cIABMGridCellValue

  Set register = New cRegister
  With register
    
    .fieldId = cscTjccId
    .Table = csTTarjetaCreditoCupon
  
    With .fields
      For Each Cell In Row
        Select Case Cell.Key
          
          Case KIT_TJCC_ID
            register.Id = Val(Cell.Value)
          Case KIT_DESCRIP
            register.fields.Add2 cscTjccDescrip, Cell.Value, csText
          Case KIT_CUPON
            register.fields.Add2 cscTjccNumeroDoc, Cell.Value, csText
          Case KIT_NROTARJETA
            register.fields.Add2 cscTjccNroTarjeta, Cell.Value, csText
          Case KIT_NROAUTORIZACION
            register.fields.Add2 cscTjccNroAutorizacion, Cell.Value, csText
          Case KIT_TITULAR
            register.fields.Add2 cscTjccTitular, Cell.Value, csText
          Case KIT_FECHAVTO
            register.fields.Add2 cscTjccFechavto, Cell.Value, csDate
        End Select
      Next
  
      .HaveLastUpdate = False
      .HaveWhoModify = False
      
    End With
  End With
  
  If Not gDB.Save(register, , "pSaveCupon", C_Module, c_ErrorSave) Then Exit Function

  pSaveCupon = True
End Function

Private Function pSaveFechaAsiento() As Boolean
  Dim as_id     As Long
  Dim cpg_id    As Long
  Dim cpg_xVto  As Long
  Dim sqlstmt   As String
  
  Select Case m_DoctId
  
    Case csEDT_FacturaCompra, csEDT_NotaCreditoCompra, csEDT_NotaDebitoCompra
      If Not gDB.GetData(csTFacturaCompra, cscFcId, m_Id, cscAsId, as_id) Then Exit Function
      If Not gDB.GetData(csTFacturaCompra, cscFcId, m_Id, cscCpgId, cpg_id) Then Exit Function
      If Not gDB.GetData(csTCondicionPago, cscCpgId, cpg_id, cscCpgAsientoXVto, cpg_xVto) Then Exit Function
      If as_id <> csNO_ID Then
        If cpg_xVto Then
          sqlstmt = "update asiento set as_fecha = fc_fechaVto, as_descrip = fc_descrip " & _
                    "from FacturaCompra where fc_id = " & m_Id & _
                                    " and Asiento.as_id = " & as_id
          
          If Not gDB.Execute(sqlstmt) Then Exit Function
        Else
          sqlstmt = "update asiento set as_fecha = fc_fechaiva, as_descrip = fc_descrip " & _
                    "from FacturaCompra where fc_id = " & m_Id & _
                                    " and Asiento.as_id = " & as_id
          
          If Not gDB.Execute(sqlstmt) Then Exit Function
        End If
      End If
      
    Case csEDT_FacturaVenta, csEDT_NotaCreditoVenta, csEDT_NotaDebitoVenta
      If Not gDB.GetData(csTFacturaVenta, cscFvId, m_Id, cscAsId, as_id) Then Exit Function
      If Not gDB.GetData(csTFacturaVenta, cscFvId, m_Id, cscCpgId, cpg_id) Then Exit Function
      If Not gDB.GetData(csTCondicionPago, cscCpgId, cpg_id, cscCpgAsientoXVto, cpg_xVto) Then Exit Function
      
      If as_id <> csNO_ID Then
        If cpg_xVto Then
          sqlstmt = "update asiento set as_fecha = fv_fechaVto, as_descrip = fv_descrip " & _
                    "from FacturaVenta where fv_id = " & m_Id & _
                                    " and Asiento.as_id = " & as_id
          
          If Not gDB.Execute(sqlstmt) Then Exit Function
        Else
          sqlstmt = "update asiento set as_fecha = fv_fechaiva, as_descrip = fv_descrip " & _
                    "from FacturaVenta where fv_id = " & m_Id & _
                                    " and Asiento.as_id = " & as_id
          
          If Not gDB.Execute(sqlstmt) Then Exit Function
        End If
      End If
    
    Case csEDT_OrdenPago
      If Not gDB.GetData(csTOrdenPago, cscOpgId, m_Id, cscAsId, as_id) Then Exit Function
      If as_id <> csNO_ID Then
        sqlstmt = "update asiento set as_fecha = opg_fecha, as_descrip = opg_descrip " & _
                  "from OrdenPago where opg_id = " & m_Id & _
                                  " and Asiento.as_id = " & as_id
        
        If Not gDB.Execute(sqlstmt) Then Exit Function
        
      End If
      
    Case csEDT_Cobranza
      If Not gDB.GetData(csTCobranza, cscCobzId, m_Id, cscAsId, as_id) Then Exit Function
      If as_id <> csNO_ID Then
        sqlstmt = "update asiento set as_fecha = cobz_fecha, as_descrip = cobz_descrip " & _
                  "from Cobranza where cobz_id = " & m_Id & _
                                  " and Asiento.as_id = " & as_id
        
        If Not gDB.Execute(sqlstmt) Then Exit Function
        
      End If
    
    Case csEDT_MovimientoFondo
      If Not gDB.GetData(csTMovimientoFondo, cscMfId, m_Id, cscAsId, as_id) Then Exit Function
      If as_id <> csNO_ID Then
        sqlstmt = "update asiento set as_fecha = mf_fecha, as_descrip = mf_descrip " & _
                  "from MovimientoFondo where mf_id = " & m_Id & _
                                  " and Asiento.as_id = " & as_id
        
        If Not gDB.Execute(sqlstmt) Then Exit Function
        
      End If
    
  End Select
  
  pSaveFechaAsiento = True
  
End Function

Private Function pSaveVencimientos(ByVal bCompra As Boolean) As Boolean
  Dim sqlstmt As String
  Dim diff    As Long

  diff = DateDiff("d", m_Fecha, DateValue(m_ObjAbm.Properties.Item(c_Fecha).Value))

  If diff <> 0 Then

    If bCompra Then
      sqlstmt = "sp_DocFacturaCompraUpdateVto " & m_Id & "," & diff
    Else
      sqlstmt = "sp_DocFacturaVentaUpdateVto " & m_Id & "," & diff
    End If
    
    If Not gDB.Execute(sqlstmt) Then Exit Function
  
  End If
  
  pSaveVencimientos = True
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  cIABMClient_Terminate = True

  ' Edit Apply
  '
  Set m_ObjectClient = Nothing
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(1567, vbNullString) 'Documento
End Property

Private Function cIABMClient_Validate() As Boolean
  cIABMClient_Validate = True
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim Filter      As String
  Dim c           As cIABMProperty
  Dim AbmGen      As cABMGeneric
  
  m_ObjAbm.Properties.Clear
  
  With m_ObjAbm.Tabs
    
    .Clear
    
    With .Add(Nothing)
      .Index = 0
      .name = C_strGeneral
    End With
    
    Select Case m_DoctId
      
      Case csEDT_OrdenPago, csEDT_Cobranza, csEDT_MovimientoFondo
      
        Const c_TabCheque = 1
        
        With .Add(Nothing)
          .Index = c_TabCheque
          .name = LNGGetText(2099, vbNullString) 'Cheques
        End With
      
      Case csEDT_DepositoCupon
      
        ' Nada que hacer
      
      Case Else
        
        With .Add(Nothing)
          .Index = 1
          .name = LNGGetText(1371, vbNullString) 'Items
        End With
    
    End Select
    
    Select Case m_DoctId
      
      Case csEDT_FacturaCompra, csEDT_NotaCreditoCompra, csEDT_NotaDebitoCompra, _
           csEDT_OrdenPago, csEDT_Cobranza
           
        With .Add(Nothing)
          .Index = 2
          .name = LNGGetText(1070, vbNullString) 'Otros
        End With
      
    End Select
    
    Select Case m_DoctId
      
      Case csEDT_FacturaCompra, csEDT_NotaCreditoCompra, csEDT_NotaDebitoCompra
      
        With .Add(Nothing)
          .Index = 3
          .name = LNGGetText(1248, vbNullString) 'Percepciones
        End With
      
        With .Add(Nothing)
          .Index = 4
          .name = LNGGetText(2318, vbNullString) 'Legajos
        End With
    
    End Select
  
    Select Case m_DoctId
      
      Case csEDT_OrdenPago, csEDT_Cobranza, csEDT_MovimientoFondo
      
        Const c_TabEfectivo = 3
        
        With .Add(Nothing)
          .Index = c_TabEfectivo
          .name = LNGGetText(2100, vbNullString) 'Efectivo
        End With
        
    End Select
    
    Select Case m_DoctId
      
      Case csEDT_OrdenPago, csEDT_MovimientoFondo
      
        Const c_TabChequeT = 4
        
        With .Add(Nothing)
          .Index = c_TabChequeT
          .name = LNGGetText(2195, vbNullString) 'Cheque de Tercero
        End With
        
    End Select
    
    Select Case m_DoctId
      Case csEDT_Cobranza
      
        Const c_TabTarjeta = 4
        
        With .Add(Nothing)
          .Index = c_TabTarjeta
          .name = LNGGetText(2101, vbNullString) 'Tarjetas
        End With
    End Select
    
    Select Case m_DoctId
      Case csEDT_MovimientoFondo
      
        Const c_TabChequeI = 4
        
        With .Add(Nothing)
          .Index = c_TabChequeI
          .name = LNGGetText(2189, vbNullString) 'Ingreso de Cheques
        End With
    End Select
    
  End With
  
  With m_ObjAbm.Properties
    
    ' Comun a todos los doc's
    '
    With .Add(Nothing, c_Fecha)
      .PropertyType = cspDate
      .name = LNGGetText(1569, vbNullString) 'Fecha
      .LeftLabel = -750
      .Left = 1000
      .Key = K_FECHA
      .Value = m_Fecha
    End With
    
    Select Case m_DoctId
    
      Case csEDT_PedidoCompra, csEDT_DevolucionPedidoCpra, _
           csEDT_OrdenCompra, csEDT_DevolucionOrdenCpra, _
           csEDT_RemitoCompra, csEDT_DevolucionRemitoCpra, _
           csEDT_FacturaCompra, csEDT_NotaCreditoCompra, csEDT_NotaDebitoCompra, _
           csEDT_PedidoVenta, csEDT_DevolucionPedidoVta, _
           csEDT_RemitoVenta, csEDT_DevolucionRemitoVta, _
           csEDT_FacturaVenta, csEDT_NotaCreditoVenta, csEDT_NotaDebitoVenta, _
           csEDT_PackingList, csEDT_PackingListDevolucion
    
            With .Add(Nothing, c_Fechaentrega)
              .PropertyType = cspDate
              .name = LNGGetText(1570, vbNullString) 'Entrega
              .Key = K_FECHAENTREGA
              .Value = m_Fechaentrega
            End With
            
            If m_DoctId = csEDT_FacturaVenta Or m_DoctId = csEDT_FacturaCompra Then
            
              With .Add(Nothing, c_FechaIVA)
                .PropertyType = cspDate
                .name = LNGGetText(1638, vbNullString) 'Fecha IVA
                .Key = K_FECHAIVA
                .Value = m_FechaIVA
              End With
            
            End If
    
    End Select
    
    ' Comun a todos los doc's
    '
    With .Add(Nothing, c_Nrodoc)
      .PropertyType = cspText
      .name = LNGGetText(1065, vbNullString) 'Número
      .Size = 50
      .Width = 1800
      .Key = K_NRODOC
      .Value = m_Nrodoc
      .TextMask = m_TaMascara
      .TextAlign = vbRightJustify
    End With
    
    Select Case m_DoctId
    
      Case csEDT_PedidoVenta, csEDT_DevolucionPedidoVta, _
           csEDT_RemitoVenta, csEDT_DevolucionRemitoVta, _
           csEDT_FacturaVenta, csEDT_NotaCreditoVenta, csEDT_NotaDebitoVenta, _
           csEDT_PackingList, csEDT_PackingListDevolucion
    
            With .Add(Nothing, cscVenId)
              .PropertyType = cspHelp
              .Table = csVendedores
              .name = LNGGetText(1510, vbNullString) 'Vendedor
              .Key = K_VEN_ID
              .HelpId = m_ven_id
              .Value = m_Vendedor
            End With
    
    End Select
        
    Select Case m_DoctId
    
      Case csEDT_DepositoCupon, csEDT_RecuentoStock, _
           csEDT_PermisoEmbarque
    
      Case Else
      
            With .Add(Nothing, cscCcosId)
              .PropertyType = cspHelp
              .Table = csCentroCosto
              .name = LNGGetText(1057, vbNullString) 'Centro de Costo
              .Left = 4900
              .LeftLabel = -1200
              .TopFromProperty = c_Fecha
              .Key = K_CCOS_ID
              .HelpId = m_ccos_id
              .Value = m_CentroCosto
            End With
    
    End Select
    
    ' Comun a todos los doc's
    '
    With .Add(Nothing, cscSucId)
      .PropertyType = cspHelp
      .Table = csSucursal
      .name = LNGGetText(1281, vbNullString) 'Sucursal
      .Key = K_SUC_ID
      .HelpId = m_suc_id
      .Value = m_Sucursal
    End With
    
    Select Case m_DoctId
    
      Case csEDT_ManifiestoCarga, csEDT_DevolucionManifiesto, csEDT_RecuentoStock
      
      Case Else
      
            With .Add(Nothing, cscLgjId)
              .PropertyType = cspHelp
              .Table = csLegajo
              .name = LNGGetText(1575, vbNullString) 'Legajo
              .Key = K_LGJ_ID
              .HelpId = m_lgj_id
              .Value = m_Legajo
            End With
    
    End Select
    
    Select Case m_DoctId
    
      Case csEDT_PedidoVenta, csEDT_DevolucionPedidoVta, _
           csEDT_RemitoVenta, csEDT_DevolucionRemitoVta, _
           csEDT_FacturaVenta, csEDT_NotaCreditoVenta, csEDT_NotaDebitoVenta, _
           csEDT_PackingList, csEDT_PackingListDevolucion
          
          With .Add(Nothing, cscClisId)
            .PropertyType = cspHelp
            .Table = csSucursalCliente
            .name = LNGGetText(1576, vbNullString) 'Sucursal del Cliente
            .Key = K_CLIS_ID
            .Value = m_ClienteSucursal
            .HelpId = m_clis_id
            .HelpFilter = GetHelpFilterCliSuc_(m_cli_id)
          End With
          
    End Select
    
    Select Case m_DoctId
    
      Case csEDT_PedidoVenta, csEDT_DevolucionPedidoVta, _
           csEDT_RemitoVenta, csEDT_DevolucionRemitoVta, _
           csEDT_FacturaVenta, csEDT_NotaCreditoVenta, csEDT_NotaDebitoVenta, _
           csEDT_PackingList, csEDT_PackingListDevolucion, _
           csEDT_ManifiestoCarga, csEDT_DevolucionManifiesto
            
            With .Add(Nothing, cscTransId)
              .PropertyType = cspHelp
              .Table = csTransporte
              .name = LNGGetText(1050, vbNullString) 'Transporte
              .Left = 8600
              .TopFromProperty = c_Fecha
              .Key = K_TRANS_ID
              .Value = m_Transporte
              .HelpId = m_trans_id
            End With
    
    End Select
    
    Select Case m_DoctId
    
      Case csEDT_RemitoVenta, csEDT_DevolucionRemitoVta
            
            With .Add(Nothing, cscChofId)
              .PropertyType = cspHelp
              .Table = csChofer
              .name = LNGGetText(1051, vbNullString) 'Chofer
              .Key = K_CHOF_ID
              .Value = m_Chofer
              .HelpId = m_chof_id
            End With
            
            With .Add(Nothing, cscCamId)
              .PropertyType = cspHelp
              .Table = csCamion
              .name = LNGGetText(3489, vbNullString) 'Camion
              .Key = K_CAM_ID
              .Value = m_Camion
              .HelpId = m_cam_id
            End With
    
    End Select
    
    Select Case m_DoctId
    
      Case csEDT_FacturaCompra, csEDT_NotaCreditoCompra, csEDT_NotaDebitoCompra, _
           csEDT_PedidoVenta, csEDT_DevolucionPedidoVta, _
           csEDT_RemitoVenta, csEDT_DevolucionRemitoVta, _
           csEDT_FacturaVenta, csEDT_NotaCreditoVenta, csEDT_NotaDebitoVenta, _
           csEDT_PackingList, csEDT_PackingListDevolucion
            
            With .Add(Nothing, cscProIdOrigen)
              .PropertyType = cspHelp
              .Table = csProvincia
              .name = LNGGetText(1577, vbNullString) 'Pcia. Origen
              .Key = K_PRO_ID_ORIGEN
              .HelpId = m_pro_id_origen
              .Value = m_ProOrigen
            End With
    
    End Select
    
    Select Case m_DoctId
    
      Case csEDT_FacturaCompra, csEDT_NotaCreditoCompra, csEDT_NotaDebitoCompra, _
           csEDT_PedidoVenta, csEDT_DevolucionPedidoVta, _
           csEDT_RemitoVenta, csEDT_DevolucionRemitoVta, _
           csEDT_FacturaVenta, csEDT_NotaCreditoVenta, csEDT_NotaDebitoVenta, _
           csEDT_PackingList, csEDT_PackingListDevolucion
    
            With .Add(Nothing, cscProIdDestino)
              .PropertyType = cspHelp
              .Table = csProvincia
              .name = LNGGetText(1578, vbNullString) 'Pcia. Destino
              .Key = K_PRO_ID_DESTINO
              .HelpId = m_pro_id_destino
              .Value = m_ProDestino
            End With
    
    End Select
    
    Select Case m_DoctId
    
      Case csEDT_FacturaVenta, csEDT_NotaCreditoVenta, csEDT_NotaDebitoVenta, _
           csEDT_FacturaCompra, csEDT_NotaCreditoCompra, csEDT_NotaDebitoCompra
           
            With .Add(Nothing, c_Cai)
              .PropertyType = cspText
              .name = LNGGetText(1636, vbNullString) 'Cai
              .Key = K_CAI
              .Value = m_Cai
            End With
     
    End Select
     
    ' Comun a todos los doc's
    '
    With .Add(Nothing, c_Descrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .name = LNGGetText(1211, vbNullString) 'Observ.
      .LeftLabel = -750
      .Size = 5000
      .Key = K_DESCRIP
      .Value = m_descrip
      .LeftFromProperty = c_Fecha
      .TopFromProperty = c_Fecha
      .Width = 6180
      .Height = 960
      .TopToPrevious = 440 * 5
    End With
     
    Select Case m_DoctId
      
      Case csEDT_OrdenPago, csEDT_Cobranza, csEDT_MovimientoFondo, _
           csEDT_DepositoCupon
      
        ' Nada que hacer
      
      Case Else
     
        Set c = .Add(Nothing, c_Items)
        With c
          .PropertyType = cspGrid
          .LeftLabel = -1
          If Not pLoadItems(c) Then Exit Function
          .name = c_Items
          .Key = K_ITEMS
          .TabIndex = 1
          .GridAdd = False
          .GridEdit = True
          .GridRemove = False
        End With
        
    End Select
    
    Select Case m_DoctId
    
      Case csEDT_FacturaCompra, csEDT_NotaCreditoCompra, csEDT_NotaDebitoCompra, _
           csEDT_OrdenPago, csEDT_Cobranza
    
        Set c = .Add(Nothing, c_Otros)
        With c
          .PropertyType = cspGrid
          .LeftLabel = -1
          If Not pLoadOtros(c) Then Exit Function
          .name = c_Otros
          .Key = K_OTROS
          .TabIndex = 2
          .GridAdd = False
          .GridEdit = True
          .GridRemove = False
        End With
        
    End Select
        
    Select Case m_DoctId
      
      Case csEDT_FacturaCompra, csEDT_NotaCreditoCompra, csEDT_NotaDebitoCompra
        
        Set c = .Add(Nothing, c_Percepciones)
        With c
          .PropertyType = cspGrid
          .LeftLabel = -1
          If Not pLoadPercepciones(c) Then Exit Function
          .name = c_Percepciones
          .Key = K_PERCEPCIONES
          .TabIndex = 3
          .GridAdd = False
          .GridEdit = True
          .GridRemove = False
        End With
        
        Set c = .Add(Nothing, c_Legajos)
        With c
          .PropertyType = cspGrid
          .LeftLabel = -1
          If Not pLoadLegajos(c, m_Cotizacion) Then Exit Function
          .name = c_Legajos
          .Key = K_LEGAJOS
          .TabIndex = 4
          .GridAdd = True
          .GridEdit = True
          .GridRemove = True
        End With
        
        m_LegajosDeleted = vbNullString
    
    End Select
    
    Select Case m_DoctId
      
      Case csEDT_OrdenPago, csEDT_MovimientoFondo
    
        Set c = .Add(Nothing, c_Cheques)
        With c
          .PropertyType = cspGrid
          .LeftLabel = -1
          If Not pLoadCheques(c) Then Exit Function
          .name = c_Cheques
          .Key = K_CHEQUES
          .TabIndex = c_TabCheque
          .GridAdd = False
          .GridEdit = True
          .GridRemove = False
        End With
        
    End Select
  
    Select Case m_DoctId
      
      Case csEDT_OrdenPago, csEDT_Cobranza, csEDT_MovimientoFondo
        Set c = .Add(Nothing, c_Efectivo)
        With c
          .PropertyType = cspGrid
          .LeftLabel = -1
          If Not pLoadEfectivo(c) Then Exit Function
          .name = c_Efectivo
          .Key = K_EFECTIVO
          .TabIndex = c_TabEfectivo
          .GridAdd = False
          .GridEdit = True
          .GridRemove = False
        End With
    End Select
    
    Select Case m_DoctId
      
      Case csEDT_Cobranza
        Set c = .Add(Nothing, c_Tarjeta)
        With c
          .PropertyType = cspGrid
          .LeftLabel = -1
          If Not pLoadTarjetas(c) Then Exit Function
          .name = c_Tarjeta
          .Key = K_TARJETA
          .TabIndex = c_TabTarjeta
          .GridAdd = False
          .GridEdit = True
          .GridRemove = False
        End With
    End Select
    
    Select Case m_DoctId
      
      Case csEDT_OrdenPago, csEDT_MovimientoFondo, csEDT_Cobranza
        
        Set c = .Add(Nothing, c_ChequesT)
        With c
          .PropertyType = cspGrid
          .LeftLabel = -1
          If Not pLoadTCheques(c) Then Exit Function
          If m_DoctId = csEDT_Cobranza Then
            .TabIndex = c_TabCheque
            .name = c_Cheques
          Else
            .TabIndex = c_TabChequeT
            .name = c_ChequesT
          End If
          .Key = K_CHEQUEST
          .GridAdd = False
          .GridEdit = True
          .GridRemove = False
        End With
      
    End Select
    
    Select Case m_DoctId
      
      Case csEDT_MovimientoFondo
        
        Set c = .Add(Nothing, c_ChequesI)
        With c
          .PropertyType = cspGrid
          .LeftLabel = -1
          If Not pLoadICheques(c) Then Exit Function
          .name = c_ChequesI
          .Key = K_CHEQUESI
          .TabIndex = c_TabChequeI
          .GridAdd = False
          .GridEdit = True
          .GridRemove = False
        End With
      
    End Select
    
  End With
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  AbmObj.MinWidth = 11000
  AbmObj.MinHeight = 5500
  
  If Not m_ObjAbm.Show(Me) Then Exit Function

  LoadCollection = True
End Function

Private Function pLoadCheques(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  Dim fieldId      As String
  Dim fieldDescrip As String
  
  Select Case m_DoctId
    
    Case csEDT_OrdenPago
      sqlstmt = "sp_DocOrdenPagoGetItems " & m_Id & "," & csEOrdenPagoItemTipo.csEOpgiTCheques
      fieldId = cscOpgiId
      fieldDescrip = cscOpgiDescrip
      
    Case csEDT_MovimientoFondo
      sqlstmt = "sp_DocMovimientoFondoGetItems " & m_Id & "," & csEMovimientoFondoItemTipo.csEMfiTCheques
      fieldId = cscMfiId
      fieldDescrip = cscMfiDescrip
      
  End Select
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCheques", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
  
    With .Columns
      With .Add(Nothing)
        .Visible = False
        .Key = KICH_OPGI_ID
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1267, vbNullString) 'Cuenta
        .Width = 2200
        .Key = KICH_CUE_ID
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(2059, vbNullString) 'Nro. Cheque
        .PropertyType = cspText
        .Width = 1000
        .Key = KICH_CHEQUE
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(2058, vbNullString) 'Cheque
        .Width = 1000
        .Enabled = False
        .Key = KICH_CHEQ_ID
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(2065, vbNullString) 'Depositar el
        .PropertyType = cspDate
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Value = Date
        .Width = 970
        .Key = KICH_FECHACOBRO
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1634, vbNullString) 'Vto.
        .PropertyType = cspDate
        .Width = 970
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Value = DateAdd("y", 1, Date)
        .Key = KICH_FECHAVTO
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1083, vbNullString) 'Clering
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
    
    With Propiedad.Grid.Rows
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(fieldId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, fieldId)
            .Key = KICH_OPGI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCueNombre)
            .Key = KICH_CUE_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCheqNumeroDoc)
            .Key = KICH_CHEQUE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCheqNumero)
            .Id = gDB.ValField(rs.fields, cscCheqId)
            .Key = KICH_CHEQ_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCheqFechaCobro)
            .Key = KICH_FECHACOBRO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCheqFechaVto)
            .Key = KICH_FECHAVTO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCleNombre)
            .Id = gDB.ValField(rs.fields, cscCleId)
            .Key = KICH_CLE_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, fieldDescrip)
            .Key = KICH_DESCRIP
          End With
          
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadCheques = True
End Function

Private Function pLoadEfectivo(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  Dim fieldId      As String
  Dim fieldDescrip As String
  
  Select Case m_DoctId
    
    Case csEDT_OrdenPago
      sqlstmt = "sp_DocOrdenPagoGetItems " & m_Id & "," & csEOrdenPagoItemTipo.csEOpgiTEfectivo
      fieldId = cscOpgiId
      fieldDescrip = cscOpgiDescrip
      
    Case csEDT_Cobranza
      sqlstmt = "sp_DocCobranzaGetItems " & m_Id & "," & csECobranzaItemTipo.csECobziTEfectivo
      fieldId = cscCobziId
      fieldDescrip = cscCobziDescrip
      
    Case csEDT_MovimientoFondo
      sqlstmt = "sp_DocMovimientoFondoGetItems " & m_Id & "," & csEMovimientoFondoItemTipo.csEMfiTEfectivo
      fieldId = cscMfiId
      fieldDescrip = cscMfiDescrip
      
  End Select
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadEfectivo", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
  
    With .Columns
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIE_OPGI_ID
      End With
    
      With .Add(Nothing)
        .name = LNGGetText(1267, vbNullString) 'Cuenta
        .Width = 3000
        .Key = KIE_CUE_ID
      End With
      
      With .Add(Nothing)
        .name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 2500
        .Key = KIE_DESCRIP
      End With
    End With
    
    With .Rows
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(fieldId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, fieldId)
            .Key = KIE_OPGI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCueNombre)
            .Key = KIE_CUE_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, fieldDescrip)
            .Key = KIE_DESCRIP
          End With
        
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadEfectivo = True
End Function

Private Function pLoadTCheques(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  Dim fieldId      As String
  Dim fieldDescrip As String
  Dim bShowCliente As Boolean
  
  Select Case m_DoctId
    
    Case csEDT_OrdenPago
      sqlstmt = "sp_DocOrdenPagoGetItems " & m_Id & "," & csEOrdenPagoItemTipo.csEOpgiTChequesT
      fieldId = cscOpgiId
      fieldDescrip = cscOpgiDescrip
      bShowCliente = True
      
    Case csEDT_Cobranza
      sqlstmt = "sp_DocCobranzaGetItems " & m_Id & "," & csECobranzaItemTipo.csECobziTCheques
      fieldId = cscCobziId
      fieldDescrip = cscCobziDescrip
      
    Case csEDT_MovimientoFondo
      sqlstmt = "sp_DocMovimientoFondoGetItems " & m_Id & "," & csEMovimientoFondoItemTipo.csEMfiTChequesT
      fieldId = cscMfiId
      fieldDescrip = cscMfiDescrip
      bShowCliente = True
      
  End Select
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCheques", C_Module) Then Exit Function
  
  With Propiedad.Grid
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
      With .Add(Nothing)
        .Visible = False
        .Key = KICH_OPGI_ID
      End With
    
      With .Add(Nothing)
        .name = LNGGetText(1267, vbNullString) 'Cuenta
        .Width = 2200
        .Key = KICHT_CUE_ID
      End With
      
      With .Add(Nothing, c_ChequeT)
        .name = LNGGetText(2059, vbNullString) 'Nr. Cheque
        .PropertyType = cspText
        .Width = 1000
        .Key = KICH_CHEQUE
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(2058, vbNullString) 'Cheque
        .Width = 1000
        .Enabled = False
        .Key = KICH_CHEQ_ID
      End With
      
      If bShowCliente Then
        With .Add(Nothing)
          .name = LNGGetText(1150, vbNullString) 'Cliente
          .Width = 2000
          .Key = KICHT_CLI_ID
        End With
      End If
      
      With .Add(Nothing)
        .name = LNGGetText(1122, vbNullString) 'Banco
        .PropertyType = cspHelp
        .Table = csBanco
        .Width = 2000
        .Key = KICHT_BCO_ID
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(2065, vbNullString) 'Depositar el
        .PropertyType = cspDate
        .Width = 970
        .Key = KICH_FECHACOBRO
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1634, vbNullString) 'Vto.
        .PropertyType = cspDate
        .Width = 970
        .Key = KICH_FECHAVTO
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1083, vbNullString) 'Clering
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
       
    With .Rows
       
      While Not rs.EOF
      
        With .Add(Nothing, rs(fieldId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, fieldId)
            .Key = KICH_OPGI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCueNombre)
            .Id = gDB.ValField(rs.fields, cscCueId)
            .Key = KICHT_CUE_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCheqNumeroDoc)
            .Id = gDB.ValField(rs.fields, cscCheqId)
            .Key = KICH_CHEQUE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCheqNumero)
            .Id = gDB.ValField(rs.fields, cscCheqId)
            .Key = KICH_CHEQ_ID
          End With
          
          If bShowCliente Then
            With .Add(Nothing)
              .Value = gDB.ValField(rs.fields, cscCliNombre)
              .Key = KICHT_CLI_ID
            End With
          End If
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscBcoNombre)
            .Id = gDB.ValField(rs.fields, cscBcoId)
            .Key = KICHT_BCO_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCheqFechaCobro)
            .Key = KICH_FECHACOBRO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCheqFechaVto)
            .Key = KICH_FECHAVTO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCleNombre)
            .Id = gDB.ValField(rs.fields, cscCleId)
            .Key = KICH_CLE_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, fieldDescrip)
            .Key = KICH_DESCRIP
          End With
        End With
        
        rs.MoveNext
      Wend
    
    End With
  End With
  
  pLoadTCheques = True
End Function

Private Function pLoadTarjetas(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocCobranzaGetItems " & m_Id & "," & csECobranzaItemTipo.csECobziTTarjeta
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadTarjetas", C_Module) Then Exit Function
  
  With Propiedad.Grid
    .Columns.Clear
    .Rows.Clear
  
    With .Columns
      With .Add(Nothing)
        .Visible = False
        .Key = KIT_COBZI_ID
      End With
    
      With .Add(Nothing)
        .name = LNGGetText(106, vbNullString) 'Número
        .Width = 900
        .Key = KIT_TJCC_ID
      End With
    
      With .Add(Nothing)
        .name = LNGGetText(2105, vbNullString) 'Cupon
        .PropertyType = cspText
        .Width = 1500
        .Key = KIT_CUPON
      End With
    
      With .Add(Nothing)
        .name = LNGGetText(2106, vbNullString) 'Tarjeta
        .Width = 1800
        .Key = KIT_TJC_ID
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1634, vbNullString) 'Vto.
        .PropertyType = cspDate
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Value = DateAdd("d", 1, Date)
        .Width = 970
        .Key = KIT_FECHAVTO
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(2107, vbNullString) 'Nro. Tarjeta
        .PropertyType = cspText
        .Width = 1300
        .Key = KIT_NROTARJETA
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(2123, vbNullString) 'Cod. Autoriz.
        .PropertyType = cspText
        .Width = 1000
        .Key = KIT_NROAUTORIZACION
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(2109, vbNullString) 'Titular
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
    
    With .Rows
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscCobziId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCobziId)
            .Key = KIT_COBZI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscTjccNumero)
            .Id = gDB.ValField(rs.fields, cscTjccId)
            .Key = KIT_TJCC_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscTjccNumeroDoc)
            .Key = KIT_CUPON
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscTjcNombre)
            .Key = KIT_TJC_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscTjccFechavto)
            .Key = KIT_FECHAVTO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscTjccNroTarjeta)
            .Key = KIT_NROTARJETA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscTjccNroAutorizacion)
            .Key = KIT_NROAUTORIZACION
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscTjccTitular)
            .Key = KIT_TITULAR
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCobziDescrip)
            .Key = KIT_DESCRIP
          End With
        
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadTarjetas = True
End Function

Private Function pLoadICheques(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocMovimientoFondoGetItems " & m_Id & "," & csEMovimientoFondoItemTipo.csEMfiTChequesI
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadICheques", C_Module) Then Exit Function

  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
      
      With .Add(Nothing)
        .Visible = False
        .Key = KICHT_MFI_ID
      End With
    
      With .Add(Nothing)
        .name = LNGGetText(2190, vbNullString) 'Cuenta Origen
        .Width = 2200
        .Key = KI_CUE_ID
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1122, vbNullString) 'Banco
        .PropertyType = cspHelp
        .Table = csBanco
        .Width = 2000
        .Key = KICHT_BCO_ID
      End With
      
      With .Add(Nothing, c_ChequeT)
        .name = LNGGetText(2059, vbNullString) 'Nr. Cheque
        .PropertyType = cspText
        .Width = 1000
        .Key = KICH_CHEQUE
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(2058, vbNullString) 'Cheque
        .Width = 1000
        .Enabled = False
        .Key = KICH_CHEQ_ID
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(2065, vbNullString) 'Depositar el
        .PropertyType = cspDate
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Value = Date
        .Width = 970
        .Key = KICH_FECHACOBRO
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1634, vbNullString) 'Vto.
        .PropertyType = cspDate
        .Width = 970
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Value = DateAdd("y", 1, Date)
        .Key = KICH_FECHAVTO
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1083, vbNullString) 'Clering
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
    
    With .Rows
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscMfiId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscMfiId)
            .Key = KICHT_MFI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, "Haber")
            .Key = KI_CUE_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscBcoNombre)
            .Id = gDB.ValField(rs.fields, cscBcoId)
            .Key = KICHT_BCO_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCheqNumeroDoc)
            .Key = KICH_CHEQUE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCheqNumero)
            .Id = gDB.ValField(rs.fields, cscCheqId)
            .Key = KICH_CHEQ_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCheqFechaCobro)
            .Key = KICH_FECHACOBRO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCheqFechaVto)
            .Key = KICH_FECHAVTO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCleNombre)
            .Id = gDB.ValField(rs.fields, cscCleId)
            .Key = KICH_CLE_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscMfiDescrip)
            .Key = KICH_DESCRIP
          End With
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadICheques = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  Dim Cotizacion  As Double
  Dim sqlstmt     As String

  Dim fieldNroDoc   As String
  Dim fieldDescrip  As String
  Dim fieldFecha    As String
  Dim fieldFechaE   As String
  Dim fieldFechaIVA As String
  Dim fieldCAI      As String
  
  Dim bCai            As Boolean
  Dim bFechaEntrega   As Boolean
  Dim bFechaIva       As Boolean
  Dim bProvincia      As Boolean
  Dim bTransporte     As Boolean
  Dim bChoferCamion   As Boolean
  Dim bCliSuc         As Boolean
  Dim bVendedor       As Boolean
  
  Select Case m_DoctId
                                          
    Case csEDT_PedidoCompra, csEDT_DevolucionPedidoCpra
      sqlstmt = "sp_DocPedidoCompraGet " & EmpId & "," _
                                         & Id & "," & gDB.UserId
      fieldNroDoc = cscPcNrodoc
      fieldDescrip = cscPcDescrip
      fieldFecha = cscPcFecha
      fieldFechaE = cscPcFechaentrega
      bFechaEntrega = True
      
    Case csEDT_RemitoCompra, csEDT_DevolucionRemitoCpra
      sqlstmt = "sp_DocRemitoCompraGet " & EmpId & "," _
                                         & Id & "," & gDB.UserId
      fieldNroDoc = cscRcNrodoc
      fieldDescrip = cscRcDescrip
      fieldFecha = cscRcFecha
      fieldFechaE = cscRcFechaentrega
      bFechaEntrega = True
      
    Case csEDT_FacturaCompra, csEDT_NotaCreditoCompra, csEDT_NotaDebitoCompra
      sqlstmt = "sp_DocFacturaCompraGet " & EmpId & "," _
                                          & Id & "," & gDB.UserId
      fieldNroDoc = cscFcNrodoc
      fieldDescrip = cscFcDescrip
      fieldFecha = cscFcFecha
      fieldFechaE = cscFcFechaentrega
      fieldFechaIVA = cscFcFechaIVA
      fieldCAI = cscFcCai
      bCai = True
      bFechaEntrega = True
      bProvincia = True
      bFechaIva = True
            
    Case csEDT_FacturaVenta, csEDT_NotaCreditoVenta, csEDT_NotaDebitoVenta
      sqlstmt = "sp_DocFacturaVentaGet " & EmpId & "," _
                                         & Id & "," & gDB.UserId
      fieldNroDoc = cscFvNrodoc
      fieldDescrip = cscFvDescrip
      fieldFecha = cscFvFecha
      fieldFechaE = cscFvFechaentrega
      fieldFechaIVA = cscFvFechaIVA
      fieldCAI = cscFvCai
      bCai = True
      bFechaEntrega = True
      bProvincia = True
      bFechaIva = True
      bTransporte = True
      
    Case csEDT_PedidoVenta, csEDT_DevolucionPedidoVta
      sqlstmt = "sp_DocPedidoVentaGet " & EmpId & "," _
                                        & Id & "," & gDB.UserId
      fieldNroDoc = cscPvNrodoc
      fieldDescrip = cscPvDescrip
      fieldFecha = cscPvFecha
      fieldFechaE = cscPvFechaentrega
      bFechaEntrega = True
      bProvincia = True
      bTransporte = True
      
    Case csEDT_RemitoVenta, csEDT_DevolucionRemitoVta
      sqlstmt = "sp_DocRemitoVentaGet " & EmpId & "," _
                                        & Id & "," & gDB.UserId
      fieldNroDoc = cscRvNrodoc
      fieldDescrip = cscRvDescrip
      fieldFecha = cscRvFecha
      fieldFechaE = cscRvFechaentrega
      bFechaEntrega = True
      bProvincia = True
      bTransporte = True
      bChoferCamion = True
      
    Case csEDT_OrdenCompra, csEDT_DevolucionOrdenCpra
      sqlstmt = "sp_DocOrdenCompraGet " & EmpId & "," _
                                        & Id & "," & gDB.UserId
      fieldNroDoc = cscOcNrodoc
      fieldDescrip = cscOcDescrip
      fieldFecha = cscOcFecha
      fieldFechaE = cscOcFechaentrega
      bFechaEntrega = True
      
    Case csEDT_RecuentoStock
      sqlstmt = "sp_DocRecuentoStockGet " & EmpId & "," _
                                          & Id & "," & gDB.UserId
      fieldNroDoc = cscRsNrodoc
      fieldDescrip = cscRsDescrip
      fieldFecha = cscRsFecha
      
    Case csEDT_PackingList, csEDT_PackingListDevolucion
      sqlstmt = "sp_DocPackingListGet " & EmpId & "," _
                                          & Id & "," & gDB.UserId
      fieldNroDoc = cscPklstNrodoc
      fieldDescrip = cscPklstDescrip
      fieldFecha = cscPklstFecha
      fieldFechaE = cscPklstFechaEntrega
      bFechaEntrega = True
      bProvincia = True
      bTransporte = True
      
    Case csEDT_ManifiestoCarga, csEDT_DevolucionManifiesto
      sqlstmt = "sp_DocManifiestoCargaGet " & EmpId & "," _
                                            & Id & "," & gDB.UserId
      fieldNroDoc = cscMfcNrodoc
      fieldDescrip = cscMfcDescrip
      fieldFecha = cscMfcFecha
      bTransporte = True
      
    Case csEDT_PresupuestoEnvio
      sqlstmt = "sp_DocPresupuestoEnvioGet " & EmpId & "," _
                                             & Id & "," & gDB.UserId
      fieldNroDoc = cscPreeNrodoc
      fieldDescrip = cscPreeDescrip
      fieldFecha = cscPreeFecha
      fieldFechaE = cscPreeFechaentrega
      bFechaEntrega = True
                                                                            
    Case csEDT_OrdenPago
      sqlstmt = "sp_DocOrdenPagoGet " & EmpId & "," _
                                      & Id & "," & gDB.UserId
      fieldNroDoc = cscOpgNrodoc
      fieldDescrip = cscOpgDescrip
      fieldFecha = cscOpgFecha
                                                                            
    Case csEDT_Cobranza
      sqlstmt = "sp_DocCobranzaGet " & EmpId & "," _
                                      & Id & "," & gDB.UserId
      fieldNroDoc = cscCobzNrodoc
      fieldDescrip = cscCobzDescrip
      fieldFecha = cscCobzFecha
                                                                            
    Case csEDT_MovimientoFondo
      sqlstmt = "sp_DocMovimientoFondoGet " & EmpId & "," _
                                      & Id & "," & gDB.UserId
      fieldNroDoc = cscMfNrodoc
      fieldDescrip = cscMfDescrip
      fieldFecha = cscMfFecha
                                                                            
  End Select
          
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    C_LoadFunction, _
                    C_Module) Then Exit Function

  If Not rs.EOF Then
    
    m_Fecha = gDB.ValField(rs.fields, fieldFecha)
    If bFechaEntrega Then
      m_Fechaentrega = gDB.ValField(rs.fields, fieldFechaE)
    End If
    If bFechaIva Then
      m_FechaIVA = gDB.ValField(rs.fields, fieldFechaIVA)
    End If
    m_Nrodoc = gDB.ValField(rs.fields, fieldNroDoc)
    m_descrip = gDB.ValField(rs.fields, fieldDescrip)
    If bCai Then
      m_Cai = gDB.ValField(rs.fields, fieldCAI)
    End If
    m_ccos_id = gDB.ValField(rs.fields, cscCcosId)
    m_CentroCosto = gDB.ValField(rs.fields, cscCcosNombre)
    m_suc_id = gDB.ValField(rs.fields, cscSucId)
    m_Sucursal = gDB.ValField(rs.fields, cscSucNombre)
    m_lgj_id = gDB.ValField(rs.fields, cscLgjId)
    m_Legajo = gDB.ValField(rs.fields, cscLgjCodigo)
    
    If bProvincia Then
      m_pro_id_origen = gDB.ValField(rs.fields, cscProIdOrigen)
      m_ProOrigen = gDB.ValField(rs.fields, "ProOrigen")
      m_pro_id_destino = gDB.ValField(rs.fields, cscProIdDestino)
      m_ProDestino = gDB.ValField(rs.fields, "ProDestino")
    End If
        
    If bTransporte Then
      m_trans_id = gDB.ValField(rs.fields, cscTransId)
      m_Transporte = gDB.ValField(rs.fields, cscTransNombre)
    End If
    
    If bChoferCamion Then
      m_chof_id = gDB.ValField(rs.fields, cscChofId)
      m_Chofer = gDB.ValField(rs.fields, cscChofNombre)
  
      m_cam_id = gDB.ValField(rs.fields, cscCamId)
      m_Camion = gDB.ValField(rs.fields, cscCamPatente)
    End If
    
    If bCliSuc Then
      m_clis_id = gDB.ValField(rs.fields, cscClisId)
      m_ClienteSucursal = gDB.ValField(rs.fields, cscClisNombre)
    End If
    
    If bVendedor Then
      m_ven_id = gDB.ValField(rs.fields, cscVenId)
      m_Vendedor = gDB.ValField(rs.fields, cscVenNombre)
    End If
    
  End If
  
  Load = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim PrId    As Long
  Dim rs      As ADODB.Recordset
  Dim fieldDescrip    As String
  Dim fieldProducto   As String
  Dim bShowOciPrecio  As Boolean
  
  Select Case m_DoctId
  
    Case csEDT_PedidoCompra, csEDT_DevolucionPedidoCpra
      sqlstmt = "sp_DocPedidoCompraGetItems " & m_Id
      fieldDescrip = cscPciDescrip
      fieldProducto = cscPrNombreCompra
      
    Case csEDT_RemitoCompra, csEDT_DevolucionRemitoCpra
      sqlstmt = "sp_DocRemitoCompraGetItems " & m_Id
      fieldDescrip = cscRciDescrip
      fieldProducto = cscPrNombreCompra
      
    Case csEDT_FacturaCompra, csEDT_NotaCreditoCompra, csEDT_NotaDebitoCompra
      sqlstmt = "sp_DocFacturaCompraGetItems " & m_Id
      fieldDescrip = cscFciDescrip
      fieldProducto = cscPrNombreCompra
      
    Case csEDT_FacturaVenta, csEDT_NotaCreditoVenta, csEDT_NotaDebitoVenta
      sqlstmt = "sp_DocFacturaVentaGetItems " & m_Id
      fieldDescrip = cscFviDescrip
      fieldProducto = cscPrNombreventa
      
    Case csEDT_PedidoVenta, csEDT_DevolucionPedidoVta
      sqlstmt = "sp_DocPedidoVentaGetItems " & m_Id
      fieldDescrip = cscPviDescrip
      fieldProducto = cscPrNombreventa
      
    Case csEDT_RemitoVenta, csEDT_DevolucionRemitoVta
      sqlstmt = "sp_DocRemitoventaGetItems " & m_Id
      fieldDescrip = cscRviDescrip
      fieldProducto = cscPrNombreventa
      
    Case csEDT_OrdenCompra, csEDT_DevolucionOrdenCpra
      sqlstmt = "sp_DocOrdenCompraGetItems " & m_Id
      fieldDescrip = cscOciDescrip
      fieldProducto = cscPrNombreCompra
      
    Case csEDT_RecuentoStock
      sqlstmt = "sp_DocRecuentoSotckGetItems " & m_Id
      fieldDescrip = cscRsiDescrip
      
    Case csEDT_PackingList, csEDT_PackingListDevolucion
      sqlstmt = "sp_DocPackingListGetItems " & m_Id
      fieldDescrip = cscPkLstIdescrip
      fieldProducto = cscPrNombreventa
      
    Case csEDT_ManifiestoCarga, csEDT_DevolucionManifiesto
      sqlstmt = "sp_DocManifiestoCargaGetItems " & m_Id
      fieldDescrip = cscMfcIdescrip
      fieldProducto = cscPrNombreventa
      
    Case csEDT_PresupuestoEnvio
      sqlstmt = "sp_DocPresupuestoEnvioGetItems " & m_Id
      fieldDescrip = cscPreeIdescrip
      fieldProducto = cscPrNombreventa
      
  End Select
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  With Propiedad.Grid
  
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
  
      With .Add(Nothing)
        .Visible = False
        .Key = KI_I_ID
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1367, vbNullString) 'Articulo
        .Width = 1800
        .Key = KI_PR_ID
      End With
      
      With .Add(Nothing)
        .name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 1200
        .Key = KI_DESCRIP
      End With
                        
      If m_DoctId = csEDT_OrdenCompra Or m_DoctId = csEDT_DevolucionOrdenCpra Then
        
        bShowOciPrecio = SecurityCanAccessSilent(csPreCpraEditPriceOrd)
        
        If bShowOciPrecio Then
          
          With .Add(Nothing)
            .name = LNGGetText(1586, vbNullString) 'Precio
            .PropertyType = cspNumeric
            .SubType = cspDouble
            .Width = 1000
            .Format = m_GeneralConfig.FormatDecImporte
            .Key = KI_OCI_PRECIO
          End With
                
          m_lColOciPrecio = .Count
          
        End If
      End If
                        
      With .Add(Nothing)
        .name = LNGGetText(1057, vbNullString) 'Centro de Costo
        .PropertyType = cspHelp
        .Table = csCentroCosto
        .Width = 1800
        .Key = KI_CCOS_ID
      End With
      
    End With
  
    With .Rows
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(m_FieldItemId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, m_FieldItemId)
            .Key = KI_I_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, fieldProducto)
            .Id = gDB.ValField(rs.fields, cscPrId)
            .Key = KI_PR_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, fieldDescrip)
            .Key = KI_DESCRIP
          End With
          
          If bShowOciPrecio Then
            With .Add(Nothing)
              .Value = gDB.ValField(rs.fields, cscOciPrecio)
            End With
          End If
                    
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCcosNombre)
            .Id = gDB.ValField(rs.fields, cscCcosId)
            .Key = KI_CCOS_ID
          End With
                   
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadItems = True
End Function

Private Function pLoadOtros(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  Dim fieldId      As String
  Dim fieldDescrip As String
  
  Dim fieldNroRetencion     As String
  Dim fieldPorcRetencion    As String
  Dim fieldFechaRetencion   As String
  
  Select Case m_DoctId
    Case csEDT_FacturaCompra, csEDT_NotaCreditoCompra, csEDT_NotaDebitoCompra
      sqlstmt = "sp_DocFacturaCompraGetOtros " & m_Id
      fieldId = cscFcotId
      fieldDescrip = cscFcotDescrip
      
    Case csEDT_OrdenPago
      sqlstmt = "sp_DocOrdenPagoGetItems " & m_Id & "," & csEOrdenPagoItemTipo.csEOpgiTOtros
      fieldId = cscOpgiId
      fieldDescrip = cscOpgiDescrip
      fieldNroRetencion = cscOpgiNroRetencion
      fieldPorcRetencion = cscOpgiPorcRetencion
      fieldFechaRetencion = cscOpgiFechaRetencion
      
    Case csEDT_Cobranza
      sqlstmt = "sp_DocCobranzaGetItems " & m_Id & "," & csECobranzaItemTipo.csECobziTOtros
      fieldId = cscCobziId
      fieldDescrip = cscCobziDescrip
      fieldNroRetencion = cscCobziNroRetencion
      fieldPorcRetencion = cscCobziPorcRetencion
      fieldFechaRetencion = cscCobziFechaRetencion
  End Select
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadOtros", C_Module) Then Exit Function
  
  With Propiedad.Grid
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
      With .Add(Nothing)
        .Visible = False
        .Key = KI_FCOT_ID
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1267, vbNullString) 'Cuenta
        .Width = 1800
        .Key = KI_CUE_ID
      End With
            
      With .Add(Nothing)
        .name = LNGGetText(1861, vbNullString) 'Observaciones
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 1800
        .Key = KI_DESCRIP
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1057, vbNullString) 'Centro de Costo
        .PropertyType = cspHelp
        .Table = csCentroCosto
        .Width = 1800
        .Key = KI_CCOS_ID
      End With
      
      Select Case m_DoctId
    
        Case csEDT_OrdenPago, csEDT_Cobranza
        
          With .Add(Nothing)
            .name = LNGGetText(1866, vbNullString) 'Factura
            .PropertyType = cspHelp
            If m_DoctId = csEDT_Cobranza Then
              .Table = csFacturaVenta
              .Key = KIO_FV_ID_RET
              .HelpFilter = "cli.cli_id = " & m_cli_id
            Else
              .Table = csFacturaCompra
              .Key = KIO_FC_ID_RET
              .HelpFilter = "prov.prov_id = " & m_prov_id
            End If
            .Width = 1500
          End With
          
          With .Add(Nothing)
            .name = LNGGetText(1403, vbNullString) 'Retención
            .PropertyType = cspHelp
            .Table = csRetencion
            .Width = 1500
            .Key = KIO_RET_ID
          End With
          
          With .Add(Nothing)
            .name = LNGGetText(2103, vbNullString) 'C. Retención
            .PropertyType = cspText
            .Width = 1200
            .Key = KIO_NRORETENCION
          End With
          
          With .Add(Nothing)
            .name = LNGGetText(2104, vbNullString) '% Retención
            .PropertyType = cspNumeric
            .SubType = cspPercent
            .Width = 1200
            .Key = KIO_PORCRETENCION
          End With
          
          With .Add(Nothing)
            .name = LNGGetText(1634, vbNullString) 'Vto.
            .PropertyType = cspDate
            .Width = 920
            .Key = KIO_FECHARETENCION
          End With
      
      End Select
    End With
    
    With .Rows
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(fieldId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, fieldId)
            .Key = KI_FCOT_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCueNombre)
            .Id = gDB.ValField(rs.fields, cscCueId)
            .Key = KI_CUE_ID
          End With
                    
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, fieldDescrip)
            .Key = KI_DESCRIP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCcosNombre)
            .Id = gDB.ValField(rs.fields, cscCcosId)
            .Key = KI_CCOS_ID
          End With
        
          Select Case m_DoctId
            
            Case csEDT_OrdenPago, csEDT_Cobranza
            
              With .Add(Nothing)
                If m_DoctId = csEDT_Cobranza Then
                  .Value = gDB.ValField(rs.fields, cscFvNrodoc)
                  .Id = gDB.ValField(rs.fields, cscFvIdRet)
                  .Key = KIO_FV_ID_RET
                Else
                  .Value = gDB.ValField(rs.fields, cscFcNrodoc)
                  .Id = gDB.ValField(rs.fields, cscFcIdRet)
                  .Key = KIO_FC_ID_RET
                End If
              End With
              
              With .Add(Nothing)
                .Value = gDB.ValField(rs.fields, cscRetNombre)
                .Id = gDB.ValField(rs.fields, cscRetId)
                .Key = KIO_RET_ID
              End With
                            
              With .Add(Nothing)
                .Value = gDB.ValField(rs.fields, fieldNroRetencion)
                .Key = KIO_NRORETENCION
              End With
              
              With .Add(Nothing)
                .Value = gDB.ValField(rs.fields, fieldPorcRetencion)
                .Key = KIO_PORCRETENCION
              End With
              
              With .Add(Nothing)
                .Value = gDB.ValField(rs.fields, fieldFechaRetencion)
                .Key = KIO_FECHARETENCION
              End With
              
          End Select
        
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadOtros = True
End Function

Private Function pLoadPercepciones(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_DocFacturaCompraGetPercepciones " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadPercepciones", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
  
    ' La primera simpre esta invisible
    With .Columns
      With .Add(Nothing)
        .Visible = False
        .Key = KIP_FCPERC_ID
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1252, vbNullString) 'Percepción
        .Width = 1800
        .Key = KIP_PERC_ID
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1861, vbNullString) 'Observaciones
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 1800
        .Key = KIP_DESCRIP
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1057, vbNullString) 'Centro de Costo
        .PropertyType = cspHelp
        .Table = csCentroCosto
        .Width = 1800
        .Key = KI_CCOS_ID
      End With
    End With
    
    With .Rows
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscFcPercId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFcPercId)
            .Key = KIP_FCPERC_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPercNombre)
            .Id = gDB.ValField(rs.fields, cscPercId)
            .Key = KIP_PERC_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFcPercDescrip)
            .Key = KIP_DESCRIP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCcosNombre)
            .Id = gDB.ValField(rs.fields, cscCcosId)
            .Key = KI_CCOS_ID
          End With
          
        End With
        
        rs.MoveNext
      Wend
      
    End With
  
  End With
  
  pLoadPercepciones = True
End Function

Private Function pLoadLegajos(ByRef Propiedad As cIABMProperty, ByVal Cotizacion As Double) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_DocFacturaCompraGetLegajos " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadLegajos", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  With Propiedad.Grid.Columns
    
    .Clear
    Propiedad.Grid.Rows.Clear
    
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KIL_FCLGJ_ID
    
    Set o = .Add(Nothing)
    o.name = LNGGetText(1575, vbNullString) 'Legajo
    o.PropertyType = cspHelp
    o.Table = csLegajo
    o.Width = 1800
    o.Key = KIL_LGJ_ID
    
    Set o = .Add(Nothing)
    o.name = LNGGetText(1228, vbNullString) 'Importe
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Format = m_GeneralConfig.FormatDecImporte
    o.Width = 1200
    o.Key = KIL_IMPORTE
    
    Set o = .Add(Nothing)
    o.name = LNGGetText(1861, vbNullString) 'Observaciones
    o.PropertyType = cspText
    o.SubType = cspTextButtonEx
    o.Width = 1800
    o.Key = KIL_DESCRIP
  End With
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscFcLgjId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscFcLgjId)
    fv.Key = KIL_FCLGJ_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscLgjCodigo)
    fv.Id = gDB.ValField(rs.fields, cscLgjId)
    fv.Key = KIL_LGJ_ID

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscFcLgjImporte) / Cotizacion
    fv.Key = KIL_IMPORTE
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscFcLgjDescrip)
    fv.Key = KIL_DESCRIP
    
    rs.MoveNext
  Wend
  
  pLoadLegajos = True
End Function

' Edit Apply
'
Private Sub pRefreshClient()
  On Error Resume Next
  If m_ObjectClient Is Nothing Then Exit Sub
  m_ObjectClient.Refresh
End Sub

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2861, vbNullString) 'Error al grabar el Documento
  
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_GeneralConfig = Nothing
End Sub

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError
  
  Select Case Key
    Case K_LEGAJOS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowLegajos(Row, RowIndex)
    Case Else
      cIABMClientGrid_IsEmptyRow = False
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_IsEmptyRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  On Error GoTo ControlError
  
  Select Case Key
    Case K_ITEMS
      With m_ObjAbm.Properties.Item(c_Items)
      
        m_bOciPrecioChanged = lCol = m_lColOciPrecio
      
        cIABMClientGrid_ColumnAfterUpdate = True
      End With
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnAfterUpdate", C_Module, vbNullString
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

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Select Case Key
    Case K_LEGAJOS
      Id = Val(pCell(Row, KIL_FCLGJ_ID).Value)
      If Id <> csNO_ID Then m_LegajosDeleted = m_LegajosDeleted & Id & ","
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
    Case K_LEGAJOS
      cIABMClientGrid_ValidateRow = pValidateRowLegajos(Row, RowIndex)
    Case Else
      cIABMClientGrid_ValidateRow = True
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function


Private Function pValidateRowLegajos(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KIL_LGJ_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(1896, vbNullString, strRow) 'Debe indicar un legajo (1)
          Exit Function
        End If
      Case KIL_IMPORTE
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(1897, vbNullString, strRow) 'Debe indicar un importe (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowLegajos = True
End Function

Private Function pIsEmptyRowLegajos(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KIL_IMPORTE
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KIL_LGJ_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KIL_DESCRIP
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowLegajos = bRowIsEmpty
End Function

