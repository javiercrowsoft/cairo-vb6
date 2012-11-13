VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFacturaCompraAplic"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cFacturaCompraAplic
' 25-03-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cFacturaCompraAplic"

'////////////////////////////////////////////////////////////////////////////////////
'
'   ORDEN DE PAGO / NOTAS DE CREDITO - COLUMNAS
'
'////////////////////////////////////////////////////////////////////////////////////


  ' FacturaCompraOrdenPago
  Private Const csTFacturaCompraOrdenPagoTMP       As String = "FacturaCompraOrdenPagoTMP"
  Private Const cscfcOpgId                         As String = "fcOpg_id"
  Private Const cscfcOpgImporte                    As String = "fcOpg_importe"
  Private Const cscfcOpgCotizacion                 As String = "fcOpg_cotizacion"
  Private Const cscfcOpgTMPid                      As String = "fcOpgTMP_id"
  Private Const cscfcOpgImporteOrigen              As String = "fcOpg_importeOrigen"
  
  ' OrdenPago
  Private Const cscOpgNumero                       As String = "opg_numero"
  Private Const cscOpgNroDoc                       As String = "opg_nrodoc"
  Private Const cscOpgId                           As String = "opg_id"
  Private Const cscOpgFecha                        As String = "opg_fecha"
  Private Const cscOpgPendiente                    As String = "opg_pendiente"
  Private Const cscOpgCotizacion                   As String = "opg_cotizacion"
  
  ' OrdenPagoTMP
  Private Const csTOrdenPagoTMP                    As String = "OrdenPagoTMP"
  Private Const cscOpgTMPId                        As String = "OpgTMP_id"
  
  ' FacturaCompraDeuda
  Private Const cscfcdId                           As String = "fcd_id"
  Private Const cscfcdFecha                        As String = "fcd_fecha"
  Private Const cscfcdPendiente                    As String = "fcd_pendiente"
  
  ' FacturaCompraPago
  Private Const cscfcpId                           As String = "fcp_id"
  Private Const cscfcpFecha                        As String = "fcp_fecha"
  Private Const cscfcpImporte                      As String = "fcp_importe"
  
  ' OrdenPagoItemTMP
  Private Const csTOrdenPagoItemTMP                As String = "OrdenPagoItemTMP"
  Private Const cscOpgiTMPId                       As String = "OpgiTMP_id"
  
  Private Const cscOpgiId                          As String = "Opgi_id"
  Private Const cscOpgiOrden                       As String = "Opgi_orden"
  Private Const cscOpgiOtroTipo                    As String = "Opgi_otroTipo"
  Private Const cscOpgiImporte                     As String = "Opgi_importe"
  Private Const cscOpgiImporteOrigen               As String = "Opgi_importeOrigen"
  Private Const cscOpgiTipo                        As String = "Opgi_tipo"
  
  ' FacturaCompraNotaCreditoTMP
  Private Const csTFacturaCompraNotaCreditoTMP     As String = "FacturaCompraNotaCreditoTMP"
  Private Const cscfcNcTMPid                       As String = "fcncTMP_id"
  
  ' FacturaCompraNotaCredito
  Private Const csTFacturaCompraNotaCredito        As String = "FacturaCompraNotaCredito"
  Private Const cscfcNcImporte                     As String = "fcnc_importe"
  Private Const cscfcNcId                          As String = "fcnc_id"
  Private Const cscfcIdNotaCredito                 As String = "fc_id_notacredito"
  Private Const cscfcIdFactura                     As String = "fc_id_factura"
  Private Const cscfcdIdNotaCredito                As String = "fcd_id_notacredito"
  Private Const cscfcdIdFactura                    As String = "fcd_id_factura"
  Private Const cscfcpIdNotaCredito                As String = "fcp_id_notacredito"
  Private Const cscfcpIdFactura                    As String = "fcp_id_factura"

  Private Const cscNroDoc                          As String = "nrodoc"
  Private Const cscPendiente                       As String = "Pendiente"
  Private Const cscImporte                         As String = "Importe"

'////////////////////////////////////////////////////////////////////////////////////
'
'   ORDEN DE PAGO / NOTAS DE CREDITO - CONSTANTES
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private Enum csEOrdenPagoItemTipo
    csEOpgiTCheques = 1
    csEOpgiTEfectivo = 2
    csEOpgiTTarjeta = 3
    csEOpgiTOtros = 4
    csEOpgiTCtaCte = 5
  End Enum
  
  Private Enum csEOrdenPagoItemOtroTipo
    csEOtroDebe = 1
    csEOtroHaber = 2
  End Enum

'////////////////////////////////////////////////////////////////////////////////////
'
'   COBRANZAS / NOTAS DE CREDITO - SOLAPA
'
'////////////////////////////////////////////////////////////////////////////////////
  
  ' Cobranza / Nota de credito
  Private Const K_PENDIENTE_OrdenPago = 10
  Private Const K_TOTAL_OrdenPago = 11
  Private Const K_VENCIMIENTOS = 12
  Private Const K_APLIC_ORDENPAGO = 13
  Private Const c_Vencimientos = "Vencimientos"
  Private Const c_AplicOrdenPago = "AplicCobr"
  Private Const c_PendienteOrdenPago = "PendienteCob"
  Private Const c_TotalOrdenPago = "TotalCob"

  ' Grillas de Factura / Ordenes de Pago / Nota de credito
  Private Const KIV_FCD_ID                  As Integer = 1
  Private Const KIV_FCP_ID                  As Integer = 2
  Private Const KIV_FECHA                   As Integer = 3
  Private Const KIV_APLICADO                As Integer = 4
  Private Const KIV_APLICADO2               As Integer = 5
  Private Const KIV_PENDIENTE               As Integer = 6
  
  Private Const KIC_FCOPG_ID                As Integer = 1
  Private Const KIC_FCD_ID                  As Integer = 2
  Private Const KIC_FCP_ID                  As Integer = 3
  Private Const KIC_FC_ID                   As Integer = 4
  Private Const KIC_DOC                     As Integer = 5
  Private Const KIC_FECHA                   As Integer = 6
  Private Const KIC_COTIZACION              As Integer = 7
  Private Const KIC_PENDIENTE               As Integer = 8
  Private Const KIC_APLICADO                As Integer = 11
  Private Const KIC_APLICADO2               As Integer = 12
  Private Const KIC_OPG_ID                  As Integer = 14
  Private Const KIC_NRODOC                  As Integer = 15
  Private Const KIC_IDX1                    As Integer = 16
  Private Const KIC_IDX2                    As Integer = 17
  Private Const KIC_FCNC_ID                 As Integer = 18

'////////////////////////////////////////////////////////////////////////////////////
'
'   ORDEN - SOLAPA
'
'////////////////////////////////////////////////////////////////////////////////////
  
  ' Orden / Remito

  Private Const K_ITEMS = 20
  Private Const K_APLIC_ORDEN_REMITO = 21
  Private Const c_Items = "Items"
  Private Const c_AplicOrdenRemito = "AplicOrdenRemito"

  Private Const cscFecha        As String = "Fecha"
  Private Const cscAplicado     As String = "Aplicado"

  ' Grillas de Ordenes / Remitos
  Private Const KII_FCI_ID                  As Integer = 1
  Private Const KII_PR_ID                   As Integer = 2
  Private Const KII_APLICADO                As Integer = 4
  Private Const KII_APLICADO2               As Integer = 5
  Private Const KII_PENDIENTE               As Integer = 6
  
  Private Const KIPR_OCFC_ID                 As Integer = 1
  Private Const KIPR_RCFC_ID                 As Integer = 2
  Private Const KIPR_OCI_ID                  As Integer = 3
  Private Const KIPR_RCI_ID                  As Integer = 4
  Private Const KIPR_OC_ID                   As Integer = 5
  Private Const KIPR_RC_ID                   As Integer = 6
  Private Const KIPR_DOC                     As Integer = 7
  Private Const KIPR_FECHA                   As Integer = 8
  Private Const KIPR_PENDIENTE               As Integer = 9
  Private Const KIPR_APLICADO                As Integer = 11
  Private Const KIPR_APLICADO2               As Integer = 12
  Private Const KIPR_NRODOC                  As Integer = 15
  Private Const KIPR_IDX1                    As Integer = 16
  Private Const KIPR_IDX2                    As Integer = 17

' estructuras
'////////////////////////////////////////////////////////////////////////////////////
'
'   COBRANZAS / NOTAS DE CREDITO
'
'////////////////////////////////////////////////////////////////////////////////////

  ' Factura / Cobranza / Nota de credito
  Private Type T_OrdenPago
    opg_id                  As Long
    NewAplic                As Double
    CurrAplic               As Double
  End Type
  
  Private Type T_Aplic
    fcnc_id                 As Long
    fcopg_id                As Long
    fcd_id                  As Long   ' Ids de deuda o pago a de los vto's al que este credito esta vinculado
    fcp_id                  As Long   '
    
    Aplicado                As Double
  End Type
  
  Private Type T_OpgNC
    opg_id                  As Long ' Ids de creditos
    fcd_id                  As Long '
    fcp_id                  As Long '
    
    fc_id                   As Long
    Fecha                   As Date
    docNombre               As String
    NroDoc                  As String
    Cotizacion              As Double
    
    PendienteActual         As Double
    AplicadoActual          As Double
    
    Pendiente               As Double
    Aplicado                As Double
    
    vAplicaciones()         As T_Aplic
  End Type

'////////////////////////////////////////////////////////////////////////////////////
'
'   ORDENES / REMITOS
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private Type T_ItAplic
    ocfc_id                 As Long
    rcfc_id                 As Long
    fci_id                  As Long   ' Ids de items al que este credito esta vinculado
    
    Aplicado                As Double
  End Type
  
  Private Type T_OrdenRemito
    rci_id                  As Long ' Ids de creditos
    oci_id                  As Long '
    
    PR_ID                   As Long
    
    Fecha                   As Date
    docNombre               As String
    NroDoc                  As String
    
    PendienteActual         As Double
    AplicadoActual          As Double
    
    Pendiente               As Double
    Aplicado                As Double
    
    vAplicaciones()         As T_ItAplic
  End Type

' pseudo-constantes
Private c_ErrorSave As String

' variables privadas

' generales
Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric
Private m_GeneralConfig     As cGeneralConfig
Private m_FcId              As Long
Private m_IsNotaCredito     As Boolean
Private m_FcNumero          As String
Private m_proveedor         As String
Private m_ProvId            As Long
Private m_DocId             As Long
Private m_SucId             As Long
Private m_Total             As Double

Private m_MonDefault        As Long

Private m_LastRowVto        As Long
Private m_LastRowItem       As Long

' Edit Apply
'
Private m_ObjectClient      As cFacturaCompra
Private m_emp_id            As Long
Private m_emp_nombre        As String

'////////////////////////////////////////////////////////////////////////////////////
'
'   COBRANZAS / NOTAS DE CREDITO
'
'////////////////////////////////////////////////////////////////////////////////////
  Private m_vOpgNC()          As T_OpgNC
  Private m_fcd_id            As Long
  Private m_fcp_id            As Long

'////////////////////////////////////////////////////////////////////////////////////
'
'   ORDENES / REMITOS
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private m_vOrdenRemito()    As T_OrdenRemito
  Private m_fci_id            As Long

' eventos
' propiedades publicas

' Edit Apply
'
Public Property Set ObjectClient(ByVal rhs As cFacturaCompra)
  Set m_ObjectClient = rhs
End Property

Public Property Get Id() As Long
  Id = m_FcId
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Show(ByVal FcId As Long, ByVal Total As Double, _
                     ByVal FcNumero As String, _
                     ByVal ProvId As Long, ByVal Proveedor As String, _
                     ByVal SucId As Long, ByVal DocId As Long, _
                     ByVal IsNotaCredito As Boolean) As Boolean
  
  If m_ObjAbm Is Nothing Then
    Set m_ObjAbm = New cABMGeneric
  End If
  
  If m_FcId <> FcId Then
    m_IsNotaCredito = IsNotaCredito
    m_FcId = FcId
    m_FcNumero = FcNumero
    m_proveedor = Proveedor
    m_ProvId = ProvId
    m_DocId = DocId
    m_SucId = SucId
    m_Total = Total
    
    ' Edit Apply
    '
    If Not gDB.GetData(csTDocumento, _
                       cscDocId, _
                       m_DocId, _
                       cscEmpId, _
                       m_emp_id) Then Exit Function
    
    If Not gDB.GetData(csTEmpresa, _
                       cscEmpId, _
                       m_emp_id, _
                       cscEmpNombre, _
                       m_emp_nombre) Then Exit Function
    
    Show = pEdit()
  Else
    m_ObjAbm.ObjForm.ZOrder
    
    Show = True
  End If
  
End Function

' funciones friend
' funciones privadas

'////////////////////////////////////////////////////////////////////////////////////
'
'   cIABMClient_
'
'////////////////////////////////////////////////////////////////////////////////////

  Private Function cIABMClient_Copy() As Boolean
  End Function
  
  Private Function cIABMClient_EditNew() As Boolean
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
    Dim AbmObj As cABMGeneric
    
    Select Case MessageID
      
      Case MSG_GRID_ROW_CHANGE
        If Info Is Nothing Then Exit Function
        
        Dim Row      As cIABMGridRow
        Dim iProp    As cIABMProperty
        Dim Aplicado As Double
        
        Set iProp = Info
        
        Select Case iProp.Key
          
          Case K_VENCIMIENTOS
          
            Set AbmObj = m_ObjAbm
            
            ' Guardo la aplicacion para el vencimiento editado anteriormente
            '
            If m_LastRowVto <> 0 Then
              Aplicado = pOPUpdateGrids
              
              pOPRefreshVto Aplicado
            End If
            
            ' Muestro las aplicaciones para este vencimiento
            '
            m_LastRowVto = iProp.SelectedIndex
            Set Row = iProp.Grid.Rows(m_LastRowVto)
            If Row Is Nothing Then Exit Function
            
            pOPSetAplicVtos m_ObjAbm.Properties(c_AplicOrdenPago), _
                              pCell(Row, KIV_FCD_ID).Id, _
                              pCell(Row, KIV_FCP_ID).Id
            
            AbmObj.ShowValue m_ObjAbm.Properties(c_AplicOrdenPago), True
          
          Case K_ITEMS
          
            Set AbmObj = m_ObjAbm
            
            ' Guardo la aplicacion para el vencimiento editado anteriormente
            '
            If m_LastRowItem <> 0 Then
              Aplicado = pItUpdateGrids
            End If
            
            ' Muestro las aplicaciones para este vencimiento
            '
            m_LastRowItem = iProp.SelectedIndex
            Set Row = iProp.Grid.Rows(m_LastRowItem)
            If Row Is Nothing Then Exit Function
            
            pItSetAplicItems m_ObjAbm.Properties(c_AplicOrdenRemito), _
                             pCell(Row, KII_FCI_ID).Id, _
                             pCell(Row, KII_PR_ID).Id
            
            AbmObj.ShowValue m_ObjAbm.Properties(c_AplicOrdenRemito), True
        End Select
    End Select
    
    cIABMClient_MessageEx = True
  End Function
  
  Private Sub cIABMClient_DiscardChanges()
    If Not pOPLoadAplicVtos() Then Exit Sub
    If Not pItLoadAplicItems() Then Exit Sub
    LoadCollection
  End Sub
  
  Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean
  End Function
  
  Private Sub cIABMClient_Load()
  End Sub
  
  Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  End Function
  
  Private Function cIABMClient_Save() As Boolean
    cIABMClient_Save = pSave
  End Function
  
  Private Function cIABMClient_Terminate() As Boolean
    m_Editing = False
    cIABMClient_Terminate = True
    m_FcId = csNO_ID
    Set m_ObjAbm = Nothing
    
    ' Edit Apply
    '
    Set m_ObjectClient = Nothing
  End Function
  
  Private Property Get cIABMClient_Title() As String
    On Error Resume Next
    cIABMClient_Title = LNGGetText(1908, vbNullString) 'Aplicación Factura de Compra
    m_ObjAbm.Title2 = m_FcNumero & " - " & m_proveedor
  End Property
  
  Private Function cIABMClient_Validate() As Boolean
    cIABMClient_Validate = True
  End Function

'////////////////////////////////////////////////////////////////////////////////////
'
'   cIABMClientGrid_
'
'////////////////////////////////////////////////////////////////////////////////////

  Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
    cIABMClientGrid_IsEmptyRow = False
  End Function
  
  Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
    On Error GoTo ControlError
    Select Case Key
      Case K_APLIC_ORDENPAGO
        cIABMClientGrid_ColumnAfterUpdate = pOPColAUpdateOrdenPago(pOPGetItemsOrdenPagoProperty(), lRow, lCol)
      Case K_APLIC_ORDEN_REMITO
        cIABMClientGrid_ColumnAfterUpdate = pItColAUpdateOrdenRemito(pItGetItemsOrdenRemitoProperty(), lRow, lCol)
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
    On Error GoTo ControlError
    Select Case Key
      Case K_APLIC_ORDENPAGO
        cIABMClientGrid_ColumnBeforeEdit = pOPColBEditOrdenPago(pOPGetItemsOrdenPagoProperty(), lRow, lCol, iKeyAscii)
      Case K_APLIC_ORDEN_REMITO
        cIABMClientGrid_ColumnBeforeEdit = pItColBEditOrdenRemito(pItGetItemsOrdenRemitoProperty(), lRow, lCol, iKeyAscii)
    End Select
    GoTo ExitProc
ControlError:
    MngError Err, "cIABMClientGrid_ColumnBeforeEdit", C_Module, vbNullString
    If Err.Number Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Function
  
  Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  
  End Function
  
  Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)
  
  End Sub
  
  Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)
  
  End Sub
  
  Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)
    On Error GoTo ControlError
    
    Select Case Key
      
      Case K_APLIC_ORDENPAGO
        
        With pOPGetItemsOrdenPago().Rows
          If pCell(.Item(lRow), KIC_OPG_ID).Id = csNO_ID Then
            ShowDocAux pCell(.Item(lRow), KIC_FC_ID).Id, _
                       "CSCompra2.cFacturaCompra", _
                       "CSABMInterface2.cABMGeneric"
          Else
            ShowDocAux pCell(.Item(lRow), KIC_OPG_ID).Id, _
                       "CSTesoreria2.cOrdenPago", _
                       "CSABMInterface2.cABMGeneric"
          End If
        End With
        
      Case K_APLIC_ORDEN_REMITO

        With pItGetItemsOrdenRemito().Rows
          
          Dim Id          As Long
          Dim ObjEditName As String
          
          Id = pCell(.Item(lRow), KIPR_OCI_ID).Id
          
          If Id <> csNO_ID Then
            If Not gDB.GetData("OrdenCompraItem", _
                               "oci_id", _
                               Id, _
                               "oc_id", _
                               Id) Then Exit Sub
            ObjEditName = "CSCompra2.cOrdenCompra"
          Else
            Id = pCell(.Item(lRow), KIPR_RCI_ID).Id
            If Id <> csNO_ID Then
              If Not gDB.GetData("RemitoCompraItem", _
                                 "rci_id", _
                                 Id, _
                                 "rc_id", _
                                 Id) Then Exit Sub
              ObjEditName = "CSCompra2.cRemitoCompra"
            End If
          End If
          
          If Id <> csNO_ID Then
          
            ShowDocAux Id, _
                       ObjEditName, _
                       "CSABMInterface2.cABMGeneric"
          End If
        End With

    End Select
  
    Exit Sub
ControlError:
    MngError Err, "cIABMClientGrid_DblClick", C_Module, vbNullString
  End Sub
  
  Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  
  End Function
  
  Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean
  
  End Function
  
  Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)
    
  End Sub
  
  Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
    cIABMClientGrid_ValidateRow = True
  End Function

'////////////////////////////////////////////////////////////////////////////////////
'
'   GENERICAS
'
'////////////////////////////////////////////////////////////////////////////////////

  Private Function pEdit() As Boolean
    On Error GoTo ControlError
    
    If Not pOPLoadAplicVtos() Then Exit Function
    If Not pItLoadAplicItems() Then Exit Function
    If Not LoadCollection() Then Exit Function
    
    m_Editing = True
    pEdit = True
    
    Exit Function
ControlError:
    MngError Err, "pEdit", C_Module, vbNullString
  End Function
  
  Private Function LoadCollection() As Boolean
    Dim c       As cIABMProperty
    Dim oGrd    As cABMGrid
    Dim ObjAbm  As cABMGeneric
    
    Set ObjAbm = m_ObjAbm
    
    ObjAbm.MinHeight = 7430
    
    m_LastRowVto = 0
    m_ObjAbm.Properties.Clear
    
    With m_ObjAbm.Tabs
    
      .Clear
    
      With .Add(Nothing)
        .Name = LNGGetText(1371, vbNullString)  'Items
      End With
      
      With .Add(Nothing)
        .Index = 1
        .Name = LNGGetText(1644, vbNullString)  'Vencimientos
      End With
      
    End With
   
    With m_ObjAbm.Properties
      Set c = .Add(Nothing, c_Items)
      c.PropertyType = cspGrid
      c.LeftLabel = -1
      If Not pItLoadItems(c) Then Exit Function
      c.Key = K_ITEMS
      c.Name = "Items"
      c.Width = 9400
      c.Left = 250
      c.Height = 2600
      c.GridEdit = False
      c.GridAdd = False
      c.GridRemove = False
      Set oGrd = c.Grid
      oGrd.RowSelect = True
      oGrd.DontSelectInGotFocus = True
      
      Set c = .Add(Nothing, c_AplicOrdenRemito)
      c.PropertyType = cspGrid
      c.LeftLabel = -1
      If Not pItSetGridAplicOrdenRemito(c) Then Exit Function
      c.Key = K_APLIC_ORDEN_REMITO
      c.Name = "OrdenRemito"
      c.Width = 9400
      c.Left = 250
      c.Top = 4200
      c.Height = 2000
      c.GridEdit = True
      c.GridAdd = False
      c.GridRemove = False
      Set oGrd = c.Grid
      oGrd.RowSelect = True
      oGrd.DontSelectInGotFocus = True
      
      ' OrdenPago
      Set c = .Add(Nothing, c_TotalOrdenPago)
      c.PropertyType = cspNumeric
      c.SubType = cspMoney
      c.Name = LNGGetText(1909, vbNullString)  'Importe facturado
      c.Enabled = False
      c.Left = 2000
      c.LeftLabel = -1500
      c.Format = m_GeneralConfig.FormatDecImporte
      c.Value = m_Total
      c.Key = K_TOTAL_OrdenPago
      c.Width = 1400
      c.TabIndex = 1
      
      Set c = .Add(Nothing, c_PendienteOrdenPago)
      c.PropertyType = cspNumeric
      c.SubType = cspMoney
      c.Name = LNGGetText(1609, vbNullString)  'Pendiente
      c.Enabled = False
      c.Format = m_GeneralConfig.FormatDecImporte
      c.Key = K_PENDIENTE_OrdenPago
      c.TopFromProperty = c_TotalOrdenPago
      c.Left = 6200
      c.Width = 1400
      c.LeftLabel = -1100
      c.TabIndex = 1
      
      Set c = .Add(Nothing, c_Vencimientos)
      c.PropertyType = cspGrid
      c.LeftLabel = -1
      If Not pOPLoadVencimientos(c) Then Exit Function
      c.Key = K_VENCIMIENTOS
      c.Name = LNGGetText(1644, vbNullString)  'Vencimientos
      c.LeftLabel = -1
      c.Width = 9400
      c.Left = 250
      c.TopToPrevious = 440
      c.Height = 1600
      c.GridEdit = False
      c.GridAdd = False
      c.GridRemove = False
      c.TabIndex = 1
      Set oGrd = c.Grid
      oGrd.RowSelect = True
      oGrd.DontSelectInGotFocus = True
      
      Set c = .Add(Nothing, c_AplicOrdenPago)
      c.PropertyType = cspGrid
      c.LeftLabel = -1
      If Not pOPSetGridAplicOrdenPago(c) Then Exit Function
      c.Key = K_APLIC_ORDENPAGO
      c.Name = "OrdenPago"
      c.LeftLabel = -1
      c.Width = 9400
      c.Left = 250
      c.Top = 3200
      c.Height = 3000
      c.GridEdit = True
      c.GridAdd = False
      c.GridRemove = False
      Set oGrd = c.Grid
      oGrd.RowSelect = True
      oGrd.DontSelectInGotFocus = True
      c.TabIndex = 1
    End With
    
    Dim AbmObj  As cABMGeneric
    Set AbmObj = m_ObjAbm
    AbmObj.MinHeight = 7800
    
    ' Edit Apply
    '
    AbmObj.MinWidth = 10050
    
    If Not m_ObjAbm.Show(Me) Then Exit Function
    
    pOPShowPendienteOrdenPago
    
    LoadCollection = True
  End Function

  Private Function pSave() As Boolean
    
    ' Edit Apply
    '
    If m_emp_id <> EmpId Then
      MsgApplyDisabled m_emp_nombre
      Exit Function
    End If
    
    Dim FcTMPId As Long
    
    pOPUpdateGrids
    pItUpdateGrids
    
    ' Temporal
    If Not pSaveDocCpra(m_DocId, FcTMPId) Then Exit Function
  
    ' Ordenes / Remitos
    If Not pItSaveOrdenRemito(FcTMPId) Then Exit Function
    
    ' Aplicaciones Automaticas
    '
    Dim bSuccess    As Boolean
    Dim bAutomatic  As Boolean
    
    If pIsAutomatic(bSuccess) Then
      MsgWarning LNGGetText(3582, vbNullString) 'El tipo de condición de pago de esta factura ha generado automticamente la orden de pago y su aplicacion no puede modificarse manualmente. Solo se guardara la aplicación de la factura entre remitos y ordenes de compra.
      bAutomatic = True
    Else
      If Not bSuccess Then
        MsgWarning LNGGetText(3583, vbNullString) 'No se pudo determinar si esta factura genera automaticamente una orden de pago. Vuelva a intentar gurdar la aplicación.
        Exit Function
      End If
    End If
    
    ' Solo modifico la aplicacion de remitos y ordenes de compra
    ' cuando la factura tiene una condicion de pago Debito Automatico
    ' o fondo fijo
    '
    If bSuccess And Not bAutomatic Then
      
      ' Notas de credito
      If Not pOPSaveNotaCredito(FcTMPId) Then Exit Function
        
      ' OrdenPagos
      If Not pOPSaveOrdenPago(FcTMPId) Then Exit Function
    
    End If
    
    ' Aplico llamando al sp
    Dim sqlstmt As String
    Dim rs      As Recordset
    
    sqlstmt = "sp_DocFacturaCompraSaveAplic " & FcTMPId
    If Not gDB.OpenRs(sqlstmt, rs, , , , "pSave", C_Module, c_ErrorSave) Then Exit Function
    
    If rs.EOF Then Exit Function
    
    Dim Id As Long
    If Not GetDocIDFromRecordset(rs, Id) Then Exit Function
    
    If Id = csNO_ID Then Exit Function
    
    If Not pOPLoadAplicVtos() Then Exit Function
    If Not pItLoadAplicItems() Then Exit Function
    
    pSave = True
    
    ' Edit Apply
    '
    pRefreshClient
  End Function

  Private Function pIsAutomatic(ByRef bSuccess As Boolean) As Boolean
    Dim opg_id As Long
    
    If Not gDB.GetData(csTFacturaCompra, cscFcId, m_FcId, cscOpgId, opg_id) Then
      Exit Function
    End If
    
    bSuccess = True
    
    pIsAutomatic = opg_id <> csNO_ID
  End Function

  ' Edit Apply
  '
  Private Sub pRefreshClient()
    On Error Resume Next
    If m_ObjectClient Is Nothing Then Exit Sub
    m_ObjectClient.Refresh
  End Sub

  '////////////////////////////////////////////////////////////////////////////////////
  ' FacturaCompraTemporal
  '////////////////////////////////////////////////////////////////////////////////////
  Private Function pSaveDocCpra(ByVal DocId As Long, _
                               ByRef FcTMPId As Long) As Boolean
    Dim register     As cRegister
    
    Set register = New cRegister
    register.fieldId = cscFcTMPId
    register.Table = csTFacturaCompraTMP
  
    register.Id = csNew
    register.fields.Add2 cscFcId, m_FcId, csId
  
    register.fields.Add2 cscFcNumero, 0, csLong
    register.fields.Add2 cscFcNrodoc, vbNullString, csText
    
    register.fields.Add2 cscProvId, 0, csLong
    register.fields.Add2 cscSucId, 0, csLong
    register.fields.Add2 cscDocId, DocId, csId
    register.fields.Add2 cscCpgId, csECpgTipo.csECpgT_FechaDocumento, csId
  
    register.fields.Add2 cscFcGrabarAsiento, 0, csBoolean
    register.fields.Add2 cscEstId, CSGeneralEx2.csEEstado.csEEst_Pendiente, csId
  
    register.fields.HaveLastUpdate = True
    register.fields.HaveWhoModify = True
  
    If Not register.BeginTrans(gDB) Then Exit Function
  
    If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
    If Not register.CommitTrans() Then Exit Function
  
    FcTMPId = register.Id
    pSaveDocCpra = True
  End Function

'////////////////////////////////////////////////////////////////////////////////////
'
'   ORDENES / REMITOS
'
'////////////////////////////////////////////////////////////////////////////////////

  Private Function pItLoadAplicItems() As Boolean
    
    If Not pItLoadAplicAplicados() Then Exit Function
    If Not pItLoadAplicCreditos() Then Exit Function
    
    pItLoadAplicItems = True
  End Function
  
  Private Function pItLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
    Dim sqlstmt     As String
    Dim rs          As ADODB.Recordset
    Dim Grid        As cIABMGrid
    Dim Row         As cABMGridRow
    Dim Value       As Double
  
    sqlstmt = "sp_DocFacturaCompraGetAplic " & EmpId & "," & m_FcId & ",4"
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pItLoadItems", C_Module) Then Exit Function
  
    Propiedad.Grid.Columns.Clear
    Propiedad.Grid.Rows.Clear
  
    Set Grid = Propiedad.Grid
  
    With Grid.Columns
      With .Add(Nothing)
        .Visible = False
        .Key = KII_FCI_ID
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1619, vbNullString)  'Producto
        .PropertyType = cspText
        .Width = 2500
        .Key = KII_PR_ID
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1609, vbNullString)  'Pendiente
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1245
        .Key = KII_PENDIENTE
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1608, vbNullString)  'Aplicado
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1245
        .Key = KII_APLICADO
      End With
    
      With .Add(Nothing)
        .Visible = False
        .Key = KII_APLICADO2
      End With
    End With
    
    Dim f  As cIABMGridRow
    Dim fv As cIABMGridCellValue
  
    While Not rs.EOF
  
      Set f = Propiedad.Grid.Rows.Add(Nothing)
  
      Set fv = f.Add(Nothing)
      fv.Id = gDB.ValField(rs.fields, cscFciId)
      fv.Key = KII_FCI_ID
  
      Set fv = f.Add(Nothing)
      fv.Id = gDB.ValField(rs.fields, cscPrId)
      fv.Value = gDB.ValField(rs.fields, cscPrNombrecompra)
      fv.Key = KII_PR_ID
  
      Set fv = f.Add(Nothing)
      fv.Value = gDB.ValField(rs.fields, cscFciPendiente)
      fv.Key = KII_PENDIENTE
  
      Value = gDB.ValField(rs.fields, cscAplicado)
      Set fv = f.Add(Nothing)
      fv.Value = Value
      fv.Key = KII_APLICADO
      
      If Value <> 0 Then
        Set Row = f
        Row.BackColor = &HFFCC99
      End If
      
      Set fv = f.Add(Nothing)
      fv.Value = gDB.ValField(rs.fields, cscAplicado)
      fv.Key = KII_APLICADO2
      
      rs.MoveNext
    Wend
  
    pItLoadItems = True
  End Function

  Private Function pItSetGridAplicOrdenRemito(ByRef Propiedad As cIABMProperty) As Boolean
    Dim Grid          As cIABMGrid
    
    Propiedad.Grid.Columns.Clear
    Propiedad.Grid.Rows.Clear
    
    Set Grid = Propiedad.Grid
    
    With Grid.Columns
      With .Add(Nothing)
        .Visible = False
        .Key = KIPR_IDX1
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIPR_IDX2
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIPR_RCFC_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIPR_OCFC_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIPR_RCI_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIPR_OCI_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1567, vbNullString)  'Documento
        .PropertyType = cspText
        .Width = 2925
        .Key = KIPR_DOC
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1610, vbNullString)  'Comprobante
        .PropertyType = cspText
        .Width = 1575
        .Key = KIPR_NRODOC
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1569, vbNullString)  'Fecha
        .PropertyType = cspDate
        .Width = 1395
        .Key = KIPR_FECHA
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1609, vbNullString)  'Pendiente
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1245
        .Key = KIPR_PENDIENTE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1608, vbNullString)  'Aplicado
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1245
        .Key = KIPR_APLICADO
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIPR_APLICADO2
      End With
      
    End With
    pItSetGridAplicOrdenRemito = True
  End Function

  Private Function pItLoadAplicAplicados() As Boolean
    Dim sqlstmt       As String
    Dim rs            As ADODB.Recordset
    Dim i             As Long
    Dim Idx           As Long
    
    sqlstmt = "sp_DocFacturaCompraGetAplic " & EmpId & "," & m_FcId & ",5"
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadAplicAplicados", C_Module) Then Exit Function
    
    ReDim m_vOrdenRemito(0)
    ReDim m_vOrdenRemito(0).vAplicaciones(0)
    
    If Not rs.EOF Then
    
      rs.MoveLast
      rs.MoveFirst
    
      While Not rs.EOF
            
        i = pItAddToCreditos(gDB.ValField(rs.fields, cscRciId), _
                             gDB.ValField(rs.fields, cscOciId), _
                             Idx)
        With m_vOrdenRemito(i)
        
          ' Documento
          '
          .docNombre = gDB.ValField(rs.fields, cscDocNombre)
          .NroDoc = gDB.ValField(rs.fields, cscNroDoc)
          .Fecha = gDB.ValField(rs.fields, cscFecha)
          
          ' Pendiente
          '
          .Pendiente = gDB.ValField(rs.fields, cscPendiente)
          .PendienteActual = .Pendiente
          
          ' Orden / Remito
          '
          .rci_id = gDB.ValField(rs.fields, cscRciId)
          .oci_id = gDB.ValField(rs.fields, cscOciId)
          .PR_ID = gDB.ValField(rs.fields, cscPrId)
          
          ' Aplicaciones
          With .vAplicaciones(Idx)
          
            .rcfc_id = gDB.ValField(rs.fields, cscRcFcId)
            .ocfc_id = gDB.ValField(rs.fields, cscOcFcId)
              
            .fci_id = gDB.ValField(rs.fields, cscFciId)
            
            .Aplicado = gDB.ValField(rs.fields, cscAplicado)
          End With
          
          ' Aplicacion total sobre este credito
          .Aplicado = .Aplicado + .vAplicaciones(Idx).Aplicado
          .AplicadoActual = .Aplicado
        End With
        
        rs.MoveNext
      Wend
    End If
    
    pItLoadAplicAplicados = True
  End Function
  
  Private Function pItLoadAplicCreditos() As Boolean
    Dim sqlstmt       As String
    Dim rs            As ADODB.Recordset
    Dim i             As Long
    
    sqlstmt = "sp_DocFacturaCompraGetAplic " & EmpId & "," & m_FcId & ",6"
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadAplicCreditos", C_Module) Then Exit Function
    
    If Not rs.EOF Then
      
      rs.MoveLast
      rs.MoveFirst
    
      i = UBound(m_vOrdenRemito)
      ReDim Preserve m_vOrdenRemito(i + rs.RecordCount)
      
      While Not rs.EOF
            
        i = i + 1
        With m_vOrdenRemito(i)
          .PR_ID = gDB.ValField(rs.fields, cscPrId)
          .rci_id = gDB.ValField(rs.fields, cscRciId)
          .oci_id = gDB.ValField(rs.fields, cscOciId)
          
  
          .docNombre = gDB.ValField(rs.fields, cscDocNombre)
          .NroDoc = gDB.ValField(rs.fields, cscNroDoc)
          .Fecha = gDB.ValField(rs.fields, cscFecha)
          
          .Pendiente = gDB.ValField(rs.fields, cscPendiente)
          .PendienteActual = .Pendiente
          
          ReDim .vAplicaciones(0)
        End With
        
        rs.MoveNext
      Wend
    End If
    
    pItLoadAplicCreditos = True
  End Function
  
  Private Function pItAddToCreditos(ByVal RciId As Long, ByVal OciId As Long, ByRef Idx As Long) As Long
    Dim i As Long
    
    For i = 1 To UBound(m_vOrdenRemito)
      With m_vOrdenRemito(i)
        If (.rci_id = RciId And RciId <> csNO_ID) Or _
           (.oci_id = OciId And OciId <> csNO_ID) Then
           
           ReDim Preserve .vAplicaciones(UBound(.vAplicaciones) + 1)
           
           Idx = UBound(.vAplicaciones)
           pItAddToCreditos = i
           Exit Function
        End If
      End With
    Next
    
    ReDim Preserve m_vOrdenRemito(UBound(m_vOrdenRemito) + 1)
    ReDim m_vOrdenRemito(UBound(m_vOrdenRemito)).vAplicaciones(1)
    pItAddToCreditos = UBound(m_vOrdenRemito)
    Idx = 1
  End Function
  
  Private Function pItUpdateGrids() As Double
    Dim iProp As cIABMProperty
    Dim Row   As cIABMGridRow
    
    Set iProp = m_ObjAbm.Properties(c_Items)
    
    If m_LastRowItem <> 0 Then
      
      Set Row = iProp.Grid.Rows(m_LastRowItem)
      pItUpdateGrids = pItUpdateAplicItems(m_ObjAbm.Properties(c_AplicOrdenRemito), _
                                           pCell(Row, KII_FCI_ID).Id)
    End If
  End Function
  
  Private Function pItSetAplicItems(ByRef iProp As cIABMProperty, _
                                    ByVal fci_id As Long, _
                                    ByVal PR_ID As Long) As Boolean
    Dim Cotizacion    As Double
    Dim i             As Long
    Dim j             As Long
    
    iProp.Grid.Rows.Clear
    
    m_fci_id = fci_id
    
    For i = 1 To UBound(m_vOrdenRemito)
    
      If m_vOrdenRemito(i).PR_ID = PR_ID Then
    
        If UBound(m_vOrdenRemito(i).vAplicaciones) > 0 Then
          pItSetAplicItemsAux1 i, iProp, fci_id
        Else
          pItSetAplicItemsAux2 i, iProp
        End If
      End If
      
    Next
    
    ' Ahora los creditos que tienen aplicaciones
    ' pero no estan con este vencimiento y tienen pendiente
    Dim Id      As Long
    Dim bAplic  As Boolean
    Dim Row     As cIABMGridRow
    
    For i = 1 To UBound(m_vOrdenRemito)
    
      bAplic = False
      
      If m_vOrdenRemito(i).PR_ID = PR_ID Then
      
        For Each Row In iProp.Grid.Rows
          Id = pCell(Row, KIPR_RCI_ID).Id
          If Id = m_vOrdenRemito(i).rci_id And Id <> csNO_ID Then
            bAplic = True
            Exit For
          End If
          
          Id = pCell(Row, KIPR_OCI_ID).Id
          If Id = m_vOrdenRemito(i).oci_id And Id <> csNO_ID Then
            bAplic = True
            Exit For
          End If
        
          Id = m_fci_id
          For j = 1 To UBound(m_vOrdenRemito(i).vAplicaciones)
            If Id = m_vOrdenRemito(i).vAplicaciones(j).fci_id And Id <> csNO_ID Then
              bAplic = True
              Exit For
            End If
          Next
        
          If bAplic Then Exit For
        Next
    
        If Not bAplic Then pItSetAplicItemsAux2 i, iProp
      End If
    Next
    
    pItSetAplicItems = True
  End Function
  
  Private Function pItUpdateAplicItems(ByRef Propiedad As cIABMProperty, _
                                       ByVal fci_id As Long) As Double
    Dim Cotizacion    As Double
    Dim i             As Long
    Dim j             As Long
    Dim Row           As cIABMGridRow
    Dim Aplicado      As Double
    Dim AplicadoTotal As Double
    
    For Each Row In pItGetItemsOrdenRemito().Rows
    
      If Val(pCell(Row, KIPR_APLICADO).Value) > 0 Or pCell(Row, KIPR_IDX2).Id <> 0 Then
    
        i = pCell(Row, KIPR_IDX1).Id
        j = pCell(Row, KIPR_IDX2).Id
        
        Aplicado = Val(pCell(Row, KIPR_APLICADO).Value)
        AplicadoTotal = AplicadoTotal + Aplicado
        
        With m_vOrdenRemito(i)
          .Aplicado = pItAddToAplic(.vAplicaciones, Aplicado, j)
          .Pendiente = .PendienteActual - (.Aplicado - .AplicadoActual)
        End With
      End If
    Next
    
    pItUpdateAplicItems = AplicadoTotal
  End Function
  
  Private Sub pItSetAplicItemsAux1(ByVal Idx As Long, ByRef iProp As cIABMProperty, ByVal fci_id As Long)
    Dim f               As cIABMGridRow
    Dim fv              As cIABMGridCellValue
    Dim i               As Long
    Dim iPropItem       As cIABMProperty
    Dim Row             As cABMGridRow
    
    For i = 1 To UBound(m_vOrdenRemito(Idx).vAplicaciones)
    
      With m_vOrdenRemito(Idx).vAplicaciones(i)
    
        If .fci_id = fci_id And fci_id <> csNO_ID Then
        
          Set f = iProp.Grid.Rows.Add(Nothing)
          
          Set fv = f.Add(Nothing)
          fv.Id = Idx
          fv.Key = KIPR_IDX1
          
          Set fv = f.Add(Nothing)
          fv.Id = i
          fv.Key = KIPR_IDX2
          
          Set fv = f.Add(Nothing)
          fv.Id = .rcfc_id
          fv.Key = KIPR_RCFC_ID
          
          Set fv = f.Add(Nothing)
          fv.Id = .ocfc_id
          fv.Key = KIPR_OCFC_ID
          
          Set fv = f.Add(Nothing)
          fv.Id = m_vOrdenRemito(Idx).rci_id
          fv.Key = KIPR_RCI_ID
          
          Set fv = f.Add(Nothing)
          fv.Id = m_vOrdenRemito(Idx).oci_id
          fv.Key = KIPR_OCI_ID
          
          Set fv = f.Add(Nothing)
          fv.Value = m_vOrdenRemito(Idx).docNombre
          fv.Key = KIPR_DOC
          
          Set fv = f.Add(Nothing)
          fv.Value = m_vOrdenRemito(Idx).NroDoc
          fv.Key = KIPR_NRODOC
          
          Set fv = f.Add(Nothing)
          If m_vOrdenRemito(Idx).Fecha = csNoDate Then
            fv.Value = vbNullString
          Else
            fv.Value = m_vOrdenRemito(Idx).Fecha
          End If
          fv.Key = KIPR_FECHA
      
          Set fv = f.Add(Nothing)
          fv.Value = m_vOrdenRemito(Idx).Pendiente
          fv.Key = KIPR_PENDIENTE
          
          Set fv = f.Add(Nothing)
          fv.Value = .Aplicado
          fv.Key = KIPR_APLICADO
          
          Set fv = f.Add(Nothing)
          fv.Value = .Aplicado
          fv.Key = KIPR_APLICADO2
          
          Set Row = f
          Row.BackColor = &HFFCC99
        End If
      End With
    Next
  End Sub

  Private Sub pItSetAplicItemsAux2(ByVal i As Long, ByRef iProp As cIABMProperty)
    Dim f             As cIABMGridRow
    Dim fv            As cIABMGridCellValue
    
    If m_vOrdenRemito(i).Pendiente <= 0 Then Exit Sub
    
    With m_vOrdenRemito(i)
  
      Set f = iProp.Grid.Rows.Add(Nothing)
      
      Set fv = f.Add(Nothing)
      fv.Id = i
      fv.Key = KIPR_IDX1
      
      Set fv = f.Add(Nothing)
      fv.Id = 0
      fv.Key = KIPR_IDX2
      
      Set fv = f.Add(Nothing)
      fv.Id = csNO_ID
      fv.Key = KIPR_RCFC_ID
      
      Set fv = f.Add(Nothing)
      fv.Id = csNO_ID
      fv.Key = KIPR_OCFC_ID
      
      Set fv = f.Add(Nothing)
      fv.Id = .rci_id
      fv.Key = KIPR_RCI_ID
      
      Set fv = f.Add(Nothing)
      fv.Id = .oci_id
      fv.Key = KIPR_OCI_ID
      
      Set fv = f.Add(Nothing)
      fv.Value = .docNombre
      fv.Key = KIPR_DOC
      
      Set fv = f.Add(Nothing)
      fv.Value = .NroDoc
      fv.Key = KIPR_NRODOC
      
      Set fv = f.Add(Nothing)
      If .Fecha = csNoDate Then
        fv.Value = vbNullString
      Else
        fv.Value = .Fecha
      End If
      fv.Key = KIPR_FECHA
  
      Set fv = f.Add(Nothing)
      fv.Value = .Pendiente
      fv.Key = KIPR_PENDIENTE
      
      Set fv = f.Add(Nothing)
      fv.Value = 0
      fv.Key = KIPR_APLICADO
      
      Set fv = f.Add(Nothing)
      fv.Value = 0
      fv.Key = KIPR_APLICADO2
    End With
  End Sub

  Private Function pItAddToAplic(ByRef vAplicaciones() As T_ItAplic, ByVal Importe As Double, ByVal Idx As Long) As Double
    Dim i    As Long
    Dim rtn  As Double
    
    If Idx = 0 Then
      ReDim Preserve vAplicaciones(UBound(vAplicaciones) + 1)
      Idx = UBound(vAplicaciones)
      With vAplicaciones(Idx)
        .fci_id = m_fci_id
      End With
    End If
    
    vAplicaciones(Idx).Aplicado = Importe
    
    For i = 1 To UBound(vAplicaciones)
      rtn = rtn + vAplicaciones(i).Aplicado
    Next
    
    pItAddToAplic = rtn
  End Function

  Private Function pItGetItemsItemsProperty() As cIABMProperty
    Set pItGetItemsItemsProperty = m_ObjAbm.Properties(c_Items)
  End Function

  Private Function pItGetItemsOrdenRemitoProperty() As cIABMProperty
    Set pItGetItemsOrdenRemitoProperty = m_ObjAbm.Properties(c_AplicOrdenRemito)
  End Function
  
  Private Function pItGetItemsOrdenRemito() As cIABMGrid
    Set pItGetItemsOrdenRemito = m_ObjAbm.Properties(c_AplicOrdenRemito).Grid
  End Function

  Private Function pItColBEditOrdenRemito(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
    Select Case pGetKeyFromCol(IProperty.Grid.Columns, lCol)
      Case KIPR_APLICADO
      Case Else
        Exit Function
    End Select
    
    pItColBEditOrdenRemito = True
  End Function

  Private Function pItGetItemPendiente() As cIABMGridCellValue
    Dim iProp As cIABMProperty
    Set iProp = m_ObjAbm.Properties(c_Items)
    Set pItGetItemPendiente = pCell(iProp.Grid.Rows(iProp.SelectedIndex), KII_PENDIENTE)
  End Function
  
  Private Function pItGetItemAplicado() As cIABMGridCellValue
    Dim iProp As cIABMProperty
    Set iProp = m_ObjAbm.Properties(c_Items)
    Set pItGetItemAplicado = pCell(iProp.Grid.Rows(iProp.SelectedIndex), KII_APLICADO2)
  End Function
  
  Private Function pItColAUpdateOrdenRemito(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long)
    Dim Row        As cIABMGridRow
    Dim MaxVal     As Double
    Dim bVisible   As Boolean
    Dim Pendiente  As Double
    
    With IProperty.Grid
      Select Case .Columns(lCol).Key
        Case KIPR_APLICADO
          Set Row = .Rows(lRow)
          
          With pCell(Row, KIPR_APLICADO)
            
            Pendiente = Val(pItGetItemPendiente.Value) + Val(pCell(Row, KIPR_APLICADO2).Value)
            MaxVal = Val(pCell(Row, KIPR_PENDIENTE).Value) + Val(pCell(Row, KIPR_APLICADO2).Value)
            
            If MaxVal > Pendiente Then
              MaxVal = Pendiente
            End If
            
            If Val(.Value) > MaxVal Then
              .Value = MaxVal
            ElseIf Val(.Value) < 0 Then
              .Value = 0
            End If
            
            Dim Aplicado As Double
            Aplicado = pItGetAplicado
            pItRefreshItem Aplicado
            pItGetItemAplicado.Value = Aplicado
          End With
          
          ' Actulizo el pendiente
          With pCell(Row, KIPR_PENDIENTE)
            .Value = Val(.Value) + Val(pCell(Row, KIPR_APLICADO2).Value) - Val(pCell(Row, KIPR_APLICADO).Value)
          End With
          pCell(Row, KIPR_APLICADO2).Value = pCell(Row, KIPR_APLICADO).Value
      End Select
    End With
    
    pItColAUpdateOrdenRemito = True
  End Function
  
  Private Function pItGetAplicado() As Double
    Dim Row       As cIABMGridRow
    Dim rtn       As Double
    
    For Each Row In m_ObjAbm.Properties(c_AplicOrdenRemito).Grid.Rows
      rtn = rtn + Val(pCell(Row, KIPR_APLICADO).Value)
    Next
    pItGetAplicado = rtn
  End Function
  
  Private Sub pItRefreshItem(ByVal Aplicado As Double)
    Dim iProp     As cIABMProperty
    Dim AbmObj    As cABMGeneric
    Dim Row       As cIABMGridRow
    Dim AplicadoActual  As Double
    
    Set AbmObj = m_ObjAbm
    Set iProp = m_ObjAbm.Properties(c_Items)
    Set Row = iProp.Grid.Rows(m_LastRowItem)
            
    pCell(Row, KII_APLICADO).Value = Aplicado
    AplicadoActual = Val(pCell(Row, KII_APLICADO2).Value)
    
    With pCell(Row, KII_PENDIENTE)
      .Value = .Value - (Aplicado - AplicadoActual)
    End With
    
    pCell(Row, KII_APLICADO2).Value = Aplicado
    
    AbmObj.ShowCellValue iProp, m_LastRowItem, pGetColFromKey(iProp.Grid.Columns, KII_PENDIENTE)
    AbmObj.ShowCellValue iProp, m_LastRowItem, pGetColFromKey(iProp.Grid.Columns, KII_APLICADO)
  End Sub
  
  Private Function pItSaveOrdenRemito(ByVal FcTMPId As Long) As Boolean
    If Not pItSaveOrdenCompra(FcTMPId) Then Exit Function
    If Not pItSaveRemito(FcTMPId) Then Exit Function
    pItSaveOrdenRemito = True
  End Function
  
  Private Function pItSaveOrdenCompra(ByVal FcTMPId As Long) As Boolean
    Dim register    As cRegister
    Dim i           As Long
    Dim j           As Long
    
    For i = 1 To UBound(m_vOrdenRemito)
   
      If m_vOrdenRemito(i).oci_id <> csNO_ID Then
   
        For j = 1 To UBound(m_vOrdenRemito(i).vAplicaciones)
        
          If m_vOrdenRemito(i).vAplicaciones(j).fci_id <> csNO_ID Then
        
            With m_vOrdenRemito(i).vAplicaciones(j)
              
              If .Aplicado > 0 Then
          
                Set register = New cRegister
                register.fieldId = cscOcFcTMPId
                register.Table = csTOrdenFacturaCompraTMP
                register.Id = csNew
                
                register.fields.Add2 cscFcTMPId, FcTMPId, csId
                register.fields.Add2 cscOciId, m_vOrdenRemito(i).oci_id, csId
                register.fields.Add2 cscFciId, .fci_id, csId
                register.fields.Add2 cscOcFcCantidad, .Aplicado, csDouble
                
                register.fields.Add2 cscOcFcId, .ocfc_id, csLong
                
                register.fields.HaveLastUpdate = False
                register.fields.HaveWhoModify = False
                
                If Not gDB.Save(register, , "pItSaveOrdenCompra", C_Module, c_ErrorSave) Then Exit Function
              End If
            End With
          End If
        Next
      End If
    Next
    
    pItSaveOrdenCompra = True
  End Function
  
  Private Function pItSaveRemito(ByVal FcTMPId As Long) As Boolean
    Dim register    As cRegister
    Dim i           As Long
    Dim j           As Long
    
    For i = 1 To UBound(m_vOrdenRemito)
   
      If m_vOrdenRemito(i).rci_id <> csNO_ID Then
   
        For j = 1 To UBound(m_vOrdenRemito(i).vAplicaciones)
        
          If m_vOrdenRemito(i).vAplicaciones(j).fci_id <> csNO_ID Then
        
            With m_vOrdenRemito(i).vAplicaciones(j)
              
              If .Aplicado > 0 Then
          
                Set register = New cRegister
                register.fieldId = cscRcFcTMPId
                register.Table = csTRemitoFacturaCompraTMP
                register.Id = csNew
                
                register.fields.Add2 cscFcTMPId, FcTMPId, csId
                register.fields.Add2 cscRciId, m_vOrdenRemito(i).rci_id, csId
                register.fields.Add2 cscFciId, .fci_id, csId
                register.fields.Add2 cscRcFcCantidad, .Aplicado, csDouble
                
                register.fields.Add2 cscRcFcId, .rcfc_id, csLong
                
                register.fields.HaveLastUpdate = False
                register.fields.HaveWhoModify = False
                
                If Not gDB.Save(register, , "pItSaveRemito", C_Module, c_ErrorSave) Then Exit Function
              End If
            End With
          End If
        Next
      End If
    Next
    
    pItSaveRemito = True
  End Function

'////////////////////////////////////////////////////////////////////////////////////
'
'   COBRANZAS / NOTAS DE CREDITO
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private Function pOPLoadAplicVtos() As Boolean
    
    If Not pOPLoadAplicAplicados() Then Exit Function
    If Not pOPLoadAplicCreditos() Then Exit Function
    
    pOPLoadAplicVtos = True
  End Function

  Private Function pOPLoadAplicAplicados() As Boolean
    Dim sqlstmt       As String
    Dim rs            As ADODB.Recordset
    Dim Cotizacion    As Double
    Dim i             As Long
    Dim Idx           As Long
    
    sqlstmt = "sp_DocFacturaCompraGetAplic " & EmpId & "," & m_FcId & ",2"
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadAplicAplicados", C_Module) Then Exit Function
    
    ReDim m_vOpgNC(0)
    ReDim m_vOpgNC(0).vAplicaciones(0)
    
    If Not rs.EOF Then
    
      rs.MoveLast
      rs.MoveFirst
    
      While Not rs.EOF
            
        i = pOPAddToCreditos(gDB.ValField(rs.fields, cscOpgId), _
                           gDB.ValField(rs.fields, cscfcdId), _
                           gDB.ValField(rs.fields, cscfcpId), _
                           Idx)
        With m_vOpgNC(i)
        
          ' Documento
          '
          .docNombre = gDB.ValField(rs.fields, cscDocNombre)
          .NroDoc = gDB.ValField(rs.fields, "nrodoc")
          
          ' Pendiente
          '
          .Pendiente = gDB.ValField(rs.fields, "Pendiente")
          .PendienteActual = .Pendiente
          
          ' Factura o Nota de credito
          '
          .fc_id = gDB.ValField(rs.fields, cscFcId)
          
          .fcp_id = gDB.ValField(rs.fields, "fcp_id2")
          .fcd_id = gDB.ValField(rs.fields, "fcd_id2")
          
          ' OrdenPago
          '
          .opg_id = gDB.ValField(rs.fields, cscOpgId)
          .Fecha = gDB.ValField(rs.fields, cscOpgFecha)
          .Cotizacion = gDB.ValField(rs.fields, cscfcOpgCotizacion)
          
          ' Aplicaciones
          With .vAplicaciones(Idx)
          
            .fcopg_id = gDB.ValField(rs.fields, cscfcOpgId)
            .fcnc_id = gDB.ValField(rs.fields, cscfcNcId)
              
            .fcp_id = gDB.ValField(rs.fields, cscfcpId)
            .fcd_id = gDB.ValField(rs.fields, cscfcdId)
            
            .Aplicado = gDB.ValField(rs.fields, "Aplicado")
          End With
          
          ' Aplicacion total sobre este credito
          .Aplicado = .Aplicado + .vAplicaciones(Idx).Aplicado
          .AplicadoActual = .Aplicado
        End With
        
        rs.MoveNext
      Wend
    End If
    
    pOPLoadAplicAplicados = True
  End Function
  
  Private Function pOPLoadVencimientos(ByRef Propiedad As cIABMProperty) As Boolean
    Dim sqlstmt As String
    Dim rs      As ADODB.Recordset
    Dim Grid    As cIABMGrid
    Dim Cotizacion  As Double
  
    sqlstmt = "sp_DocFacturaCompraGetAplic " & EmpId & "," & m_FcId & ",1"
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadAplic", C_Module) Then Exit Function
  
    Propiedad.Grid.Columns.Clear
    Propiedad.Grid.Rows.Clear
  
    Set Grid = Propiedad.Grid
  
    With Grid.Columns
      With .Add(Nothing)
        .Visible = False
        .Key = KIV_FCD_ID
      End With
  
      With .Add(Nothing)
        .Visible = False
        .Key = KIV_FCP_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1569, vbNullString)  'Fecha
        .PropertyType = cspDate
        .Width = 1395
        .Key = KIV_FECHA
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1609, vbNullString)  'Pendiente
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1245
        .Key = KIV_PENDIENTE
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1608, vbNullString)  'Aplicado
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1245
        .Key = KIV_APLICADO
      End With
    
      With .Add(Nothing)
        .Visible = False
        .Key = KIV_APLICADO2
      End With
    End With
  
    Dim f  As cIABMGridRow
    Dim fv As cIABMGridCellValue
  
    While Not rs.EOF
  
      Set f = Propiedad.Grid.Rows.Add(Nothing)
  
      Set fv = f.Add(Nothing)
      fv.Id = gDB.ValField(rs.fields, cscfcdId)
      fv.Key = KIV_FCD_ID
  
      Set fv = f.Add(Nothing)
      fv.Id = gDB.ValField(rs.fields, cscfcpId)
      fv.Key = KIV_FCP_ID
  
      Set fv = f.Add(Nothing)
      fv.Value = gDB.ValField(rs.fields, "Fecha")
      fv.Key = KIV_FECHA
  
      Set fv = f.Add(Nothing)
      fv.Value = gDB.ValField(rs.fields, "Pendiente")
      fv.Key = KIV_PENDIENTE
  
      Set fv = f.Add(Nothing)
      fv.Value = gDB.ValField(rs.fields, "Importe")
      fv.Key = KIV_APLICADO
      
      Set fv = f.Add(Nothing)
      fv.Value = gDB.ValField(rs.fields, "Importe")
      fv.Key = KIV_APLICADO2
      
      rs.MoveNext
    Wend
  
    pOPLoadVencimientos = True
  End Function

  Private Function pOPLoadAplicCreditos() As Boolean
    Dim sqlstmt       As String
    Dim rs            As ADODB.Recordset
    Dim Cotizacion    As Double
    Dim i             As Long
    
    sqlstmt = "sp_DocFacturaCompraGetAplic " & EmpId & "," & m_FcId & ",3"
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadAplicCreditos", C_Module) Then Exit Function
    
    If Not rs.EOF Then
      
      rs.MoveLast
      rs.MoveFirst
    
      i = UBound(m_vOpgNC)
      ReDim Preserve m_vOpgNC(i + rs.RecordCount)
      
      While Not rs.EOF
            
        i = i + 1
        With m_vOpgNC(i)
          .opg_id = gDB.ValField(rs.fields, cscOpgId)
          .fc_id = gDB.ValField(rs.fields, cscFcId)
          .fcd_id = gDB.ValField(rs.fields, cscfcdId)
  
          .docNombre = gDB.ValField(rs.fields, cscDocNombre)
          .NroDoc = gDB.ValField(rs.fields, "nroDoc")
          
          .Fecha = gDB.ValField(rs.fields, "fecha")
          .Pendiente = gDB.ValField(rs.fields, "pendiente")
          .PendienteActual = .Pendiente
          
          ReDim .vAplicaciones(0)
        End With
        
        rs.MoveNext
      Wend
    End If
    
    pOPLoadAplicCreditos = True
  End Function

  Private Function pOPSetGridAplicOrdenPago(ByRef Propiedad As cIABMProperty) As Boolean
    Dim Grid          As cIABMGrid
    
    Propiedad.Grid.Columns.Clear
    Propiedad.Grid.Rows.Clear
    
    Set Grid = Propiedad.Grid
    
    With Grid.Columns
      With .Add(Nothing)
        .Visible = False
        .Key = KIC_IDX1
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIC_IDX2
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIC_FCOPG_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIC_FCNC_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIC_OPG_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIC_FC_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIC_FCD_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIC_FCP_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1567, vbNullString)  'Documento
        .PropertyType = cspText
        .Width = 2925
        .Key = KIC_DOC
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1610, vbNullString)  'Comprobante
        .PropertyType = cspText
        .Width = 1575
        .Key = KIC_NRODOC
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1569, vbNullString)  'Fecha
        .PropertyType = cspDate
        .Width = 1395
        .Key = KIC_FECHA
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1609, vbNullString)  'Pendiente
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1245
        .Key = KIC_PENDIENTE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1608, vbNullString)  'Aplicado
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1245
        .Key = KIC_APLICADO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1650, vbNullString)  'Cotiz.
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecCotizacion
        .Width = 920
        .Key = KIC_COTIZACION
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIC_APLICADO2
      End With
    End With
    
    pOPSetGridAplicOrdenPago = True
  End Function

  Private Function pOPAddToCreditos(ByVal OpgId As Long, ByVal FcdId As Long, ByVal FcpId As Long, ByRef Idx As Long) As Long
    Dim i As Long
    
    For i = 1 To UBound(m_vOpgNC)
      With m_vOpgNC(i)
        If (.opg_id = OpgId And OpgId <> csNO_ID) Or _
           (.fcd_id = FcdId And FcdId <> csNO_ID) Or _
           (.fcp_id = FcpId And FcpId <> csNO_ID) Then
           
           ReDim Preserve .vAplicaciones(UBound(.vAplicaciones) + 1)
           
           Idx = UBound(.vAplicaciones)
           pOPAddToCreditos = i
           Exit Function
        End If
      End With
    Next
    
    ReDim Preserve m_vOpgNC(UBound(m_vOpgNC) + 1)
    ReDim m_vOpgNC(UBound(m_vOpgNC)).vAplicaciones(1)
    pOPAddToCreditos = UBound(m_vOpgNC)
    Idx = 1
  End Function

  Private Function pOPSetAplicVtos(ByRef iProp As cIABMProperty, _
                                 ByVal fcd_id As Long, _
                                 ByVal fcp_id As Long) As Boolean
    Dim Cotizacion    As Double
    Dim i             As Long
    Dim j             As Long
    
    iProp.Grid.Rows.Clear
    
    m_fcd_id = fcd_id
    m_fcp_id = fcp_id
    
    For i = 1 To UBound(m_vOpgNC)
    
      If UBound(m_vOpgNC(i).vAplicaciones) > 0 Then
        pOPSetAplicVtosAux1 i, iProp, fcd_id, fcp_id
      Else
        pOPSetAplicVtosAux2 i, iProp
      End If
      
    Next
    
    ' Ahora los creditos que tienen aplicaciones
    ' pero no estan con este vencimiento y tienen pendiente
    Dim Id      As Long
    Dim bAplic  As Boolean
    Dim Row     As cIABMGridRow
    
    For i = 1 To UBound(m_vOpgNC)
    
      bAplic = False
      
      For Each Row In iProp.Grid.Rows
        Id = pCell(Row, KIC_OPG_ID).Id
        If Id = m_vOpgNC(i).opg_id And Id <> csNO_ID Then
          bAplic = True
          Exit For
        End If
        
        Id = pCell(Row, KIC_FCD_ID).Id
        If Id = m_vOpgNC(i).fcd_id And Id <> csNO_ID Then
          bAplic = True
          Exit For
        End If
        
        Id = pCell(Row, KIC_FCP_ID).Id
        If Id = m_vOpgNC(i).fcp_id And Id <> csNO_ID Then
          bAplic = True
          Exit For
        End If
      
        For j = 1 To UBound(m_vOpgNC(i).vAplicaciones)
        
          Id = pCell(Row, KIC_FCD_ID).Id
          If Id = m_vOpgNC(i).vAplicaciones(j).fcd_id And Id <> csNO_ID Then
            bAplic = True
            Exit For
          End If
          
          Id = pCell(Row, KIC_FCP_ID).Id
          If Id = m_vOpgNC(i).vAplicaciones(j).fcp_id And Id <> csNO_ID Then
            bAplic = True
            Exit For
          End If
        Next
      
        If bAplic Then Exit For
      Next
    
      If Not bAplic Then pOPSetAplicVtosAux2 i, iProp
      
    Next
    
    pOPSetAplicVtos = True
  End Function

  Private Sub pOPSetAplicVtosAux1(ByVal Idx As Long, ByRef iProp As cIABMProperty, _
                                ByVal fcd_id As Long, ByVal fcp_id As Long)
                                
    Dim f               As cIABMGridRow
    Dim fv              As cIABMGridCellValue
    Dim i               As Long
    Dim iPropVto        As cIABMProperty
    
    For i = 1 To UBound(m_vOpgNC(Idx).vAplicaciones)
    
      With m_vOpgNC(Idx).vAplicaciones(i)
    
        If (.fcd_id = fcd_id And fcd_id <> csNO_ID) Or (.fcp_id = fcp_id And fcp_id <> csNO_ID) Then
        
          Set f = iProp.Grid.Rows.Add(Nothing)
          
          Set fv = f.Add(Nothing)
          fv.Id = Idx
          fv.Key = KIC_IDX1
          
          Set fv = f.Add(Nothing)
          fv.Id = i
          fv.Key = KIC_IDX2
          
          Set fv = f.Add(Nothing)
          fv.Id = .fcopg_id
          fv.Key = KIC_FCOPG_ID
          
          Set fv = f.Add(Nothing)
          fv.Id = .fcnc_id
          fv.Key = KIC_FCNC_ID
          
          Set fv = f.Add(Nothing)
          fv.Id = m_vOpgNC(Idx).opg_id
          fv.Key = KIC_OPG_ID
          
          Set fv = f.Add(Nothing)
          fv.Id = m_vOpgNC(Idx).fc_id
          fv.Key = KIC_FC_ID
          
          Set fv = f.Add(Nothing)
          fv.Id = .fcd_id
          fv.Key = KIC_FCD_ID
          
          Set fv = f.Add(Nothing)
          fv.Id = .fcp_id
          fv.Key = KIC_FCP_ID
          
          Set fv = f.Add(Nothing)
          fv.Value = m_vOpgNC(Idx).docNombre
          fv.Key = KIC_DOC
          
          Set fv = f.Add(Nothing)
          fv.Value = m_vOpgNC(Idx).NroDoc
          fv.Key = KIC_NRODOC
          
          Set fv = f.Add(Nothing)
          If m_vOpgNC(Idx).Fecha = csNoDate Then
            fv.Value = vbNullString
          Else
            fv.Value = m_vOpgNC(Idx).Fecha
          End If
          fv.Key = KIC_FECHA
      
          Set fv = f.Add(Nothing)
          fv.Value = m_vOpgNC(Idx).Pendiente
          fv.Key = KIC_PENDIENTE
          
          Set fv = f.Add(Nothing)
          fv.Value = .Aplicado
          fv.Key = KIC_APLICADO
          
          Set fv = f.Add(Nothing)
          If m_vOpgNC(Idx).Cotizacion <> 0 Then
            fv.Value = m_vOpgNC(Idx).Cotizacion
          End If
          fv.Key = KIC_COTIZACION
          
          Set fv = f.Add(Nothing)
          fv.Value = .Aplicado
          fv.Key = KIC_APLICADO2
        End If
      End With
    Next
  End Sub
  
  Private Sub pOPSetAplicVtosAux2(ByVal i As Long, ByRef iProp As cIABMProperty)
    Dim f             As cIABMGridRow
    Dim fv            As cIABMGridCellValue
    
    If m_vOpgNC(i).Pendiente <= 0 Then Exit Sub
    
    With m_vOpgNC(i)
  
      Set f = iProp.Grid.Rows.Add(Nothing)
      
      Set fv = f.Add(Nothing)
      fv.Id = i
      fv.Key = KIC_IDX1
      
      Set fv = f.Add(Nothing)
      fv.Id = 0
      fv.Key = KIC_IDX2
      
      Set fv = f.Add(Nothing)
      fv.Id = csNO_ID
      fv.Key = KIC_FCOPG_ID
      
      Set fv = f.Add(Nothing)
      fv.Id = csNO_ID
      fv.Key = KIC_FCNC_ID
      
      Set fv = f.Add(Nothing)
      fv.Id = .opg_id
      fv.Key = KIC_OPG_ID
      
      Set fv = f.Add(Nothing)
      fv.Id = .fc_id
      fv.Key = KIC_FC_ID
      
      Set fv = f.Add(Nothing)
      fv.Id = .fcd_id
      fv.Key = KIC_FCD_ID
      
      Set fv = f.Add(Nothing)
      fv.Id = csNO_ID
      fv.Key = KIC_FCP_ID
      
      Set fv = f.Add(Nothing)
      fv.Value = .docNombre
      fv.Key = KIC_DOC
      
      Set fv = f.Add(Nothing)
      fv.Value = .NroDoc
      fv.Key = KIC_NRODOC
      
      Set fv = f.Add(Nothing)
      If .Fecha = csNoDate Then
        fv.Value = vbNullString
      Else
        fv.Value = .Fecha
      End If
      fv.Key = KIC_FECHA
  
      Set fv = f.Add(Nothing)
      fv.Value = .Pendiente
      fv.Key = KIC_PENDIENTE
      
      Set fv = f.Add(Nothing)
      fv.Value = 0
      fv.Key = KIC_APLICADO
      
      Set fv = f.Add(Nothing)
      fv.Key = KIC_COTIZACION
      
      Set fv = f.Add(Nothing)
      fv.Value = 0
      fv.Key = KIC_APLICADO2
    End With
  End Sub

  Private Function pOPUpdateAplicVtos(ByRef Propiedad As cIABMProperty, _
                                    ByVal fcd_id As Long, _
                                    ByVal fcp_id As Long) As Double
    Dim Cotizacion    As Double
    Dim i             As Long
    Dim j             As Long
    Dim Row           As cIABMGridRow
    Dim Aplicado      As Double
    Dim AplicadoTotal As Double
    
    For Each Row In pOPGetItemsOrdenPago().Rows
    
      If Val(pCell(Row, KIC_APLICADO).Value) > 0 Or pCell(Row, KIC_IDX2).Id <> 0 Then
    
        i = pCell(Row, KIC_IDX1).Id
        j = pCell(Row, KIC_IDX2).Id
        
        Aplicado = Val(pCell(Row, KIC_APLICADO).Value)
        AplicadoTotal = AplicadoTotal + Aplicado
        
        With m_vOpgNC(i)
          .Aplicado = pOPAddToAplic(.vAplicaciones, Aplicado, j)
          .Pendiente = .PendienteActual - (.Aplicado - .AplicadoActual)
        End With
      End If
    Next
    
    pOPUpdateAplicVtos = AplicadoTotal
  End Function

  Private Function pOPAddToAplic(ByRef vAplicaciones() As T_Aplic, ByVal Importe As Double, ByVal Idx As Long) As Double
    Dim i    As Long
    Dim rtn  As Double
    
    If Idx = 0 Then
      ReDim Preserve vAplicaciones(UBound(vAplicaciones) + 1)
      Idx = UBound(vAplicaciones)
      With vAplicaciones(Idx)
        .fcd_id = m_fcd_id
        .fcp_id = m_fcp_id
      End With
    End If
    
    vAplicaciones(Idx).Aplicado = Importe
    
    For i = 1 To UBound(vAplicaciones)
      rtn = rtn + vAplicaciones(i).Aplicado
    Next
    
    pOPAddToAplic = rtn
  End Function

  Private Function pOPGetVtoPendiente() As cIABMGridCellValue
    Dim iProp As cIABMProperty
    Set iProp = m_ObjAbm.Properties(c_Vencimientos)
    Set pOPGetVtoPendiente = pCell(iProp.Grid.Rows(iProp.SelectedIndex), KIV_PENDIENTE)
  End Function
  
  Private Function pOPGetVtoAplicado() As cIABMGridCellValue
    Dim iProp As cIABMProperty
    Set iProp = m_ObjAbm.Properties(c_Vencimientos)
    Set pOPGetVtoAplicado = pCell(iProp.Grid.Rows(iProp.SelectedIndex), KIV_APLICADO2)
  End Function
  
  Private Function pOPColAUpdateOrdenPago(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long)
    Dim Row        As cIABMGridRow
    Dim MaxVal     As Double
    Dim bVisible   As Boolean
    Dim Pendiente  As Double
    
    With IProperty.Grid
      Select Case .Columns(lCol).Key
        Case KIC_APLICADO
          Set Row = .Rows(lRow)
          
          With pCell(Row, KIC_APLICADO)
            
            Pendiente = Val(pOPGetVtoPendiente.Value) + Val(pCell(Row, KIC_APLICADO2).Value)
            MaxVal = Val(pCell(Row, KIC_PENDIENTE).Value) + Val(pCell(Row, KIC_APLICADO2).Value)
            
            If MaxVal > Pendiente Then
              MaxVal = Pendiente
            End If
            
            If Val(.Value) > MaxVal Then
              .Value = MaxVal
            ElseIf Val(.Value) < 0 Then
              .Value = 0
            End If
            
            Dim Aplicado As Double
            Aplicado = pOPGetAplicado
            pOPRefreshVto Aplicado
            pOPGetVtoAplicado.Value = Aplicado
          End With
          
          ' Actulizo el pendiente
          With pCell(Row, KIC_PENDIENTE)
            .Value = Val(.Value) + Val(pCell(Row, KIC_APLICADO2).Value) - Val(pCell(Row, KIC_APLICADO).Value)
          End With
          pCell(Row, KIC_APLICADO2).Value = pCell(Row, KIC_APLICADO).Value
          
          pOPShowPendienteOrdenPago
      End Select
    End With
    
    pOPColAUpdateOrdenPago = True
  End Function

  Private Function pOPGetAplicado() As Double
    Dim Row       As cIABMGridRow
    Dim rtn       As Double
    
    For Each Row In m_ObjAbm.Properties(c_AplicOrdenPago).Grid.Rows
      rtn = rtn + Val(pCell(Row, KIC_APLICADO).Value)
    Next
    pOPGetAplicado = rtn
  End Function
  
  Private Sub pOPRefreshVto(ByVal Aplicado As Double)
    Dim iProp     As cIABMProperty
    Dim AbmObj    As cABMGeneric
    Dim Row       As cIABMGridRow
    Dim AplicadoActual  As Double
    
    Set AbmObj = m_ObjAbm
    Set iProp = m_ObjAbm.Properties(c_Vencimientos)
    Set Row = iProp.Grid.Rows(m_LastRowVto)
            
    pCell(Row, KIV_APLICADO).Value = Aplicado
    AplicadoActual = Val(pCell(Row, KIV_APLICADO2).Value)
    
    With pCell(Row, KIV_PENDIENTE)
      .Value = .Value - (Aplicado - AplicadoActual)
    End With
    
    pCell(Row, KIV_APLICADO2).Value = Aplicado
    
    AbmObj.ShowCellValue iProp, m_LastRowVto, pGetColFromKey(iProp.Grid.Columns, KIV_PENDIENTE)
    AbmObj.ShowCellValue iProp, m_LastRowVto, pGetColFromKey(iProp.Grid.Columns, KIV_APLICADO)
  End Sub

  Private Function pOPGetItemsOrdenPagoProperty() As cIABMProperty
    Set pOPGetItemsOrdenPagoProperty = m_ObjAbm.Properties(c_AplicOrdenPago)
  End Function
  
  Private Function pOPGetItemsOrdenPago() As cIABMGrid
    Set pOPGetItemsOrdenPago = m_ObjAbm.Properties(c_AplicOrdenPago).Grid
  End Function
  
  Private Function pOPGetItemsVtosProperty() As cIABMProperty
    Set pOPGetItemsVtosProperty = m_ObjAbm.Properties(c_Vencimientos)
  End Function
  
  Private Function pOPColBEditOrdenPago(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
    Select Case pGetKeyFromCol(IProperty.Grid.Columns, lCol)
      ' Facturas
      Case KIC_APLICADO
      Case KIC_COTIZACION
        If pCell(IProperty.Grid.Rows(lRow), KIC_COTIZACION).Value = vbNullString Then
          Exit Function
        End If
      Case Else
        Exit Function
    End Select
    
    pOPColBEditOrdenPago = True
  End Function
  
  Private Sub pOPShowPendienteOrdenPago()
    Dim Row           As cIABMGridRow
    Dim Total         As Double
    
    For Each Row In pOPGetItemsVtosProperty().Grid.Rows
      Total = Total + Val(pCell(Row, KIV_PENDIENTE).Value)
    Next
    
    pOPGetPendienteOrdenPago().Value = Total
    
    m_ObjAbm.ShowValue pOPGetPendienteOrdenPago
  End Sub
  
  Private Function pOPGetPendienteOrdenPago() As cIABMProperty
    Set pOPGetPendienteOrdenPago = m_ObjAbm.Properties.Item(c_PendienteOrdenPago)
  End Function
  
  Private Function pOPUpdateGrids() As Double
    Dim iProp As cIABMProperty
    Dim Row   As cIABMGridRow
    
    Set iProp = m_ObjAbm.Properties(c_Vencimientos)
    
    If m_LastRowVto <> 0 Then
      
      Set Row = iProp.Grid.Rows(m_LastRowVto)
      pOPUpdateGrids = pOPUpdateAplicVtos(m_ObjAbm.Properties(c_AplicOrdenPago), _
                                      pCell(Row, KIV_FCD_ID).Id, _
                                      pCell(Row, KIV_FCP_ID).Id)
    End If
  End Function

  '////////////////////////////////////////////////////////////////////////////////////
  ' Nota de credito
  '////////////////////////////////////////////////////////////////////////////////////
  
  ' Proposito: Vincular una/s nota de credito con una/s factura
  '
  Private Function pOPSaveNotaCredito(ByVal FcTMPId As Long) As Boolean
    Dim register    As cRegister
    Dim Row         As cIABMGridRow
    Dim Cell        As cIABMGridCellValue
    Dim i           As Long
    Dim j           As Long
    
    For i = 1 To UBound(m_vOpgNC)
    
      If m_vOpgNC(i).fc_id <> csNO_ID Then
    
        For j = 1 To UBound(m_vOpgNC(i).vAplicaciones)
      
          With m_vOpgNC(i).vAplicaciones(j)
            
            If .Aplicado > 0 Or .fcnc_id Then
        
              Set register = New cRegister
              register.fieldId = cscfcNcTMPid
              register.Table = csTFacturaCompraNotaCreditoTMP
              register.Id = csNew
              
              register.fields.Add2 cscFcTMPId, FcTMPId, csId
              
              If m_IsNotaCredito Then
                register.fields.Add2 cscfcIdNotaCredito, m_FcId, csId
                register.fields.Add2 cscfcIdFactura, m_vOpgNC(i).fc_id, csId
              
                register.fields.Add2 cscfcdIdNotaCredito, .fcd_id, csId
                register.fields.Add2 cscfcdIdFactura, m_vOpgNC(i).fcd_id, csId
                
                register.fields.Add2 cscfcpIdNotaCredito, .fcp_id, csId
                register.fields.Add2 cscfcpIdFactura, m_vOpgNC(i).fcp_id, csId
              Else
                register.fields.Add2 cscfcIdNotaCredito, m_vOpgNC(i).fc_id, csId
                register.fields.Add2 cscfcIdFactura, m_FcId, csId
              
                register.fields.Add2 cscfcdIdNotaCredito, m_vOpgNC(i).fcd_id, csId
                register.fields.Add2 cscfcdIdFactura, .fcd_id, csId
                
                register.fields.Add2 cscfcpIdNotaCredito, m_vOpgNC(i).fcp_id, csId
                register.fields.Add2 cscfcpIdFactura, .fcp_id, csId
              End If
              
              
              register.fields.Add2 cscfcNcImporte, .Aplicado, csDouble
              register.fields.Add2 cscfcNcId, 0, csLong
              
              register.fields.HaveLastUpdate = False
              register.fields.HaveWhoModify = False
                                                                            
              If Not gDB.Save(register, , "pOPSaveNotaCredito", C_Module, c_ErrorSave) Then Exit Function
            End If
          End With
        Next
      End If
    Next
    
    pOPSaveNotaCredito = True
  End Function
  
  '////////////////////////////////////////////////////////////////////////////////////
  ' OrdenPago
  '////////////////////////////////////////////////////////////////////////////////////
  
  ' Guardo cada una de las OrdenPagos modificadas
  ' por la edicion de esta aplicacion
  Private Function pOPSaveOrdenPago(ByVal FcTMPId As Long) As Boolean
    Dim vOrdenPagos() As T_OrdenPago
    Dim i          As Long
    
    pOPGetOrdenPagos vOrdenPagos()
    
    For i = 1 To UBound(vOrdenPagos)
      With vOrdenPagos(i)
        If Not pOPSaveOrdenPagoAux(.opg_id, FcTMPId, .NewAplic) Then Exit Function
      End With
    Next
    
    pOPSaveOrdenPago = True
  End Function
  
  Private Sub pOPGetOrdenPagos(ByRef vOrdenPagos() As T_OrdenPago)
    Dim Row     As cIABMGridRow
    Dim i       As Long
    Dim k       As Long
    
    ReDim vOrdenPagos(0)
    
    For i = 1 To UBound(m_vOpgNC)
      If m_vOpgNC(i).opg_id <> csNO_ID Then
        
        With m_vOpgNC(i)
          
          If .Aplicado > 0 Or .AplicadoActual <> 0 Then
          
            k = pOPGetIdxOrdenPagos(vOrdenPagos, .opg_id)
            With vOrdenPagos(k)
              .opg_id = m_vOpgNC(i).opg_id
              .NewAplic = m_vOpgNC(i).Aplicado
              .CurrAplic = m_vOpgNC(i).AplicadoActual
            End With
          End If
        End With
      End If
    Next
  End Sub
  
  Private Function pOPGetIdxOrdenPagos(ByRef vOrdenPagos() As T_OrdenPago, ByVal OpgId As Long) As Long
    Dim bFound As Boolean
    Dim i      As Long
    
    For i = 1 To UBound(vOrdenPagos)
      If vOrdenPagos(i).opg_id = OpgId Then
        pOPGetIdxOrdenPagos = i
        Exit Function
      End If
    Next
    
    If Not bFound Then
      ReDim Preserve vOrdenPagos(UBound(vOrdenPagos) + 1)
    End If
    
    pOPGetIdxOrdenPagos = UBound(vOrdenPagos)
  End Function
  
  Private Function pOPSaveOrdenPagoAux(ByVal OpgId As Long, ByVal FcTMPId As Long, ByVal Aplic As Double) As Boolean
    Dim register     As cRegister
    
    Dim Mouse As cMouseWait
    Set Mouse = New cMouseWait
    
    DoEvents: DoEvents: DoEvents: DoEvents
    
    Set register = New cRegister
    register.fieldId = cscOpgTMPId
    register.Table = csTOrdenPagoTMP
    
    register.Id = csNew
    
    register.fields.Add2 cscFcTMPId, FcTMPId, csId
    register.fields.Add2 cscOpgNumero, 0, csLong
    register.fields.Add2 cscProvId, csNO_ID, csLong
    register.fields.Add2 cscSucId, csNO_ID, csLong
    register.fields.Add2 cscDocId, csNO_ID, csLong
    register.fields.Add2 cscEstId, csNO_ID, csLong
    register.fields.Add2 cscOpgId, OpgId, csId
    
    register.fields.HaveLastUpdate = True
    register.fields.HaveWhoModify = True
    
    If Not register.BeginTrans(gDB) Then Exit Function
    
    If Not gDB.Save(register, , "pSave", C_Module, c_ErrorSave) Then Exit Function
    
    If Not pOPSaveItems(register.Id, OpgId) Then Exit Function
    If Not pOPSaveCtaCte(register.Id, OpgId, Aplic) Then Exit Function
    
    If Not register.CommitTrans() Then Exit Function
    
    pOPSaveOrdenPagoAux = True
  End Function
  
  Private Function pOPSaveItems(ByVal Id As Long, ByVal OpgId As Long) As Boolean
    Dim register    As cRegister
    Dim i           As Long
    Dim j           As Long
    
    For i = 1 To UBound(m_vOpgNC)
    
      If m_vOpgNC(i).opg_id = OpgId Then
    
        For j = 1 To UBound(m_vOpgNC(i).vAplicaciones)
    
          With m_vOpgNC(i).vAplicaciones(j)
          
            If .Aplicado > 0 Or .fcopg_id Then
        
              Set register = New cRegister
              register.fieldId = cscfcOpgTMPid
              register.Table = csTFacturaCompraOrdenPagoTMP
              register.Id = csNew
            
              register.fields.Add2 cscOpgId, m_vOpgNC(i).opg_id, csLong
              register.fields.Add2 cscOpgTMPId, Id, csId
              
              register.fields.Add2 cscFcId, m_FcId, csId
              register.fields.Add2 cscfcdId, .fcd_id, csId
              register.fields.Add2 cscfcpId, .fcp_id, csId
              register.fields.Add2 cscfcOpgId, .fcopg_id, csLong
              
              register.fields.Add2 cscfcOpgCotizacion, m_vOpgNC(i).Cotizacion, csDouble
              register.fields.Add2 cscfcOpgImporte, .Aplicado, csDouble
              register.fields.Add2 cscfcOpgImporteOrigen, DivideByCero(.Aplicado, m_vOpgNC(i).Cotizacion), csDouble
              
              register.fields.HaveLastUpdate = False
              register.fields.HaveWhoModify = False
                                                                  
              If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
            End If
          End With
        Next
      End If
    Next
    
    pOPSaveItems = True
  End Function
  
  Private Function pOPSaveCtaCte(ByVal Id As Long, ByVal OpgId As Long, ByVal Aplic As Double) As Boolean
    Dim register    As cRegister
    Dim CtaCte      As T_CtaCte
    
    ' Obtengo las cuentas del tercero
    If Not pOPGetCuentasAcreedor(OpgId, CtaCte, Aplic) Then Exit Function
    
    Set register = New cRegister
    register.fieldId = cscOpgiTMPId
    register.Table = csTOrdenPagoItemTMP
    register.Id = csNew
    
    register.fields.Add2 cscCueId, CtaCte.Cue_id, csId
    register.fields.Add2 cscOpgiImporteOrigen, CtaCte.ImporteOrigen, csCurrency
    register.fields.Add2 cscOpgiImporte, CtaCte.Importe, csCurrency
    
    register.fields.Add2 cscOpgiOrden, 1, csInteger
    register.fields.Add2 cscOpgiTipo, csEOrdenPagoItemTipo.csEOpgiTCtaCte, csInteger
    register.fields.Add2 cscOpgTMPId, Id, csId
    register.fields.Add2 cscOpgiId, Id, csLong
    register.fields.Add2 cscOpgiOtroTipo, csEOrdenPagoItemOtroTipo.csEOtroHaber, csInteger
    
    register.fields.HaveLastUpdate = False
    register.fields.HaveWhoModify = False
                                                        
    If Not gDB.Save(register, , "pSaveCtaCte", C_Module, c_ErrorSave) Then Exit Function
    
    pOPSaveCtaCte = True
  End Function
  
  Private Function pOPGetCuentasAcreedor(ByVal OpgId As Long, ByRef CtaCte As T_CtaCte, ByVal Aplic As Double) As Boolean
    Dim CueIdFactura    As Long
    Dim Cotizacion      As Double
    
    If Not pOPGetCueIdFactura(CueIdFactura) Then Exit Function
    
    With CtaCte
      .Cue_id = CueIdFactura
      .Importe = Aplic
      
      If pOPGetMonIdForCueId(CueIdFactura) <> m_MonDefault Then
         If Not pOPGetCotizacionPago(OpgId, Cotizacion) Then Exit Function
        .ImporteOrigen = Aplic * Cotizacion
      End If
    End With
    
    pOPGetCuentasAcreedor = True
  End Function
  
  Private Function pOPGetMonIdForCueId(ByVal CueId As Long) As Long
    On Error GoTo ControlError
    
    Dim sqlstmt As String
    Dim rs      As ADODB.Recordset
    
    sqlstmt = "select mon_id from Cuenta where cue_id = " & CueId
  
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    
    If rs.EOF Then Exit Function
  
    pOPGetMonIdForCueId = gDB.ValField(rs.fields, cscMonId)
  
    GoTo ExitProc
ControlError:
    MngError Err, "pGetMonIdForCueId", C_Module, vbNullString
    If Err.Number Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Function
  
  Private Function pOPGetCotizacionPago(ByVal OpgId As Long, ByRef Cotizacion As Double) As Boolean
    On Error GoTo ControlError
    
    Dim sqlstmt As String
    Dim rs      As ADODB.Recordset
    
    sqlstmt = "select opg_cotizacion from OrdenPago where opg_id = " & OpgId
  
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    
    If rs.EOF Then Exit Function
    
    Cotizacion = gDB.ValField(rs.fields, cscOpgCotizacion)
  
    pOPGetCotizacionPago = True
  
    GoTo ExitProc
ControlError:
    MngError Err, "pGetCotizacionPago", C_Module, vbNullString
    If Err.Number Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Function
  
  Private Function pOPGetCueIdFactura(ByRef CueIdFactura As Long) As Boolean
    On Error GoTo ControlError
    
    Dim sqlstmt As String
    Dim rs      As ADODB.Recordset
    
    sqlstmt = "sp_DocFacturaCompraGetCueDeudor " & m_FcId
  
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    
    If rs.EOF Then Exit Function
    
    CueIdFactura = gDB.ValField(rs.fields, cscCueId)
  
    pOPGetCueIdFactura = True
  
    GoTo ExitProc
ControlError:
    MngError Err, "pOPGetCueIdFactura", C_Module, vbNullString
    If Err.Number Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Function

'////////////////////////////////////////////////////////////////////////////////////
'
'   construccion - destruccion
'
'////////////////////////////////////////////////////////////////////////////////////
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(1907, vbNullString) 'Error al grabar la factura de Compra

  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  ReDim m_vOpgNC(0)
  ReDim m_vOpgNC(0).vAplicaciones(0)

  m_MonDefault = GetMonedaDefault()
  
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
  
  ReDim m_vOpgNC(0)
  ReDim m_vOrdenRemito(0)
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
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
