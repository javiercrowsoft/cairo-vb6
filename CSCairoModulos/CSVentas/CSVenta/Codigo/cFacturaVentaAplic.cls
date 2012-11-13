VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFacturaVentaAplic"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cFacturaVentaAplic
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
Private Const C_Module = "cFacturaVentaAplic"

'////////////////////////////////////////////////////////////////////////////////////
'
'   COBRANZAS / NOTAS DE CREDITO - COLUMNAS
'
'////////////////////////////////////////////////////////////////////////////////////
  
  ' FacturaVentaCobranza
  Private Const csTFacturaVentaCobranzaTMP         As String = "FacturaVentaCobranzaTMP"
  Private Const cscFvCobzId                        As String = "fvcobz_id"
  Private Const cscFvCobzImporte                   As String = "fvcobz_importe"
  Private Const cscFvCobzCotizacion                As String = "fvcobz_cotizacion"
  Private Const cscFvCobzTMPid                     As String = "fvcobzTMP_id"
  Private Const cscFvCobzImporteOrigen             As String = "fvcobz_importeOrigen"
  
  ' Cobranza
  Private Const cscCobzNumero                             As String = "cobz_numero"
  Private Const cscCobzNroDoc                             As String = "cobz_nrodoc"
  Private Const cscCobzId                                 As String = "cobz_id"
  Private Const cscCobzFecha                              As String = "cobz_fecha"
  Private Const cscCobzPendiente                          As String = "cobz_pendiente"
  Private Const cscCobzCotizacion                         As String = "cobz_cotizacion"
  
  ' CobranzaTMP
  Private Const csTCobranzaTMP                            As String = "CobranzaTMP"
  Private Const cscCobzTMPId                              As String = "cobzTMP_id"
  
  ' FacturaVentaDeuda
  Private Const cscFvdId                           As String = "fvd_id"
  Private Const cscFvdFecha                        As String = "fvd_fecha"
  Private Const cscFvdPendiente                    As String = "fvd_pendiente"
  
  ' FacturaVentaPago
  Private Const cscFvpId                           As String = "fvp_id"
  Private Const cscFvpFecha                        As String = "fvp_fecha"
  Private Const cscFvpImporte                      As String = "fvp_importe"
  
  ' CobranzaItemTMP
  Private Const csTCobranzaItemTMP                         As String = "CobranzaItemTMP"
  Private Const cscCobziTMPId                              As String = "cobziTMP_id"
  
  'Private Const csTCobranzaItem                            As String = "CobranzaItem"
  Private Const cscCobziId                                 As String = "cobzi_id"
  Private Const cscCobziOrden                              As String = "cobzi_orden"
  Private Const cscCobziOtroTipo                           As String = "cobzi_otroTipo"
  Private Const cscCobziImporte                            As String = "cobzi_importe"
  Private Const cscCobziImporteOrigen                      As String = "cobzi_importeOrigen"
  Private Const cscCobziTipo                               As String = "cobzi_tipo"
  
  ' FacturaVentaNotaCreditoTMP
  Private Const csTFacturaVentaNotaCreditoTMP      As String = "FacturaVentaNotaCreditoTMP"
  Private Const cscFvNcTMPid                       As String = "fvncTMP_id"
  
  ' FacturaVentaNotaCredito
  Private Const csTFacturaVentaNotaCredito         As String = "FacturaVentaNotaCredito"
  Private Const cscFvNcImporte                     As String = "fvnc_importe"
  Private Const cscFvNcId                          As String = "fvnc_id"
  Private Const cscFvIdNotaCredito                 As String = "fv_id_notacredito"
  Private Const cscFvIdFactura                     As String = "fv_id_factura"
  Private Const cscFvdIdNotaCredito                As String = "fvd_id_notacredito"
  Private Const cscFvdIdFactura                    As String = "fvd_id_factura"
  Private Const cscFvpIdNotaCredito                As String = "fvp_id_notacredito"
  Private Const cscFvpIdFactura                    As String = "fvp_id_factura"
  
  Private Const cscNroDoc                          As String = "nrodoc"
  Private Const cscPendiente                       As String = "Pendiente"
  Private Const cscImporte                         As String = "Importe"
  
'////////////////////////////////////////////////////////////////////////////////////
'
'   COBRANZAS / NOTAS DE CREDITO - CONSTANTES
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private Enum csECobranzaItemTipo
    csECobziTCheques = 1
    csECobziTEfectivo = 2
    csECobziTTarjeta = 3
    csECobziTOtros = 4
    csECobziTCtaCte = 5
  End Enum
  
  Private Enum csECobranzaItemOtroTipo
    csEOtroDebe = 1
    csEOtroHaber = 2
  End Enum

'////////////////////////////////////////////////////////////////////////////////////
'
'   COBRANZAS / NOTAS DE CREDITO - SOLAPA
'
'////////////////////////////////////////////////////////////////////////////////////

  ' Cobranza / Nota de credito
  Private Const K_PENDIENTE_COBRANZA = 10
  Private Const K_TOTAL_COBRANZA = 11
  Private Const K_VENCIMIENTOS = 12
  Private Const K_APLIC_COBRANZA = 13
  Private Const c_Vencimientos = "Vencimientos"
  Private Const c_AplicCobranza = "AplicCobr"
  Private Const c_PendienteCobranza = "PendienteCob"
  Private Const c_TotalCobranza = "TotalCob"

  ' Grillas de Factura / Cobranza / Nota de credito
  Private Const KIV_FVD_ID                  As Integer = 1
  Private Const KIV_FVP_ID                  As Integer = 2
  Private Const KIV_FECHA                   As Integer = 3
  Private Const KIV_APLICADO                As Integer = 4
  Private Const KIV_APLICADO2               As Integer = 5
  Private Const KIV_PENDIENTE               As Integer = 6
  
  Private Const KIC_FVCOBZ_ID               As Integer = 1
  Private Const KIC_FVD_ID                  As Integer = 2
  Private Const KIC_FVP_ID                  As Integer = 3
  Private Const KIC_FV_ID                   As Integer = 4
  Private Const KIC_DOC                     As Integer = 5
  Private Const KIC_FECHA                   As Integer = 6
  Private Const KIC_COTIZACION              As Integer = 7
  Private Const KIC_PENDIENTE               As Integer = 8
  Private Const KIC_APLICADO                As Integer = 11
  Private Const KIC_APLICADO2               As Integer = 12
  Private Const KIC_COBZ_ID                 As Integer = 14
  Private Const KIC_NRODOC                  As Integer = 15
  Private Const KIC_IDX1                    As Integer = 16
  Private Const KIC_IDX2                    As Integer = 17
  Private Const KIC_FVNC_ID                 As Integer = 18

'////////////////////////////////////////////////////////////////////////////////////
'
'   PEDIDO - SOLAPA
'
'////////////////////////////////////////////////////////////////////////////////////
  
  ' Pedido / Remito
  
  Private Const K_ITEMS = 20
  Private Const K_APLIC_PEDIDO_REMITO = 21
  Private Const c_Items = "Items"
  Private Const c_AplicPedidoRemito = "AplicPedidoRemito"

  Private Const K_DESAPLIC_ITEMS = 22

  Private Const cscFecha        As String = "Fecha"
  Private Const cscAplicado     As String = "Aplicado"

  ' Grillas de Pedidos / Remitos
  Private Const KII_FVI_ID                  As Integer = 1
  Private Const KII_PR_ID                   As Integer = 2
  Private Const KII_APLICADO                As Integer = 4
  Private Const KII_APLICADO2               As Integer = 5
  Private Const KII_PENDIENTE               As Integer = 6
  
  Private Const KIPR_PVFV_ID                 As Integer = 1
  Private Const KIPR_RVFV_ID                 As Integer = 2
  Private Const KIPR_PVI_ID                  As Integer = 3
  Private Const KIPR_RVI_ID                  As Integer = 4
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
  Private Type T_Cobranza
    cobz_id                 As Long
    NewAplic                As Double
    CurrAplic               As Double
  End Type
  
  Private Type T_CobAplic
    fvnc_id                 As Long
    fvcobz_id               As Long
    fvd_id                  As Long   ' Ids de deuda o pago a de los vto's al que este credito esta vinculado
    fvp_id                  As Long   '
    
    Aplicado                As Double
  End Type
  
  Private Type T_CobzNC
    cobz_id                 As Long ' Ids de creditos
    fvd_id                  As Long '
    fvp_id                  As Long '
    
    fv_id                   As Long
    Fecha                   As Date
    docNombre               As String
    NroDoc                  As String
    Cotizacion              As Double
    
    PendienteActual         As Double
    AplicadoActual          As Double
    
    Pendiente               As Double
    Aplicado                As Double
    
    vAplicaciones()         As T_CobAplic
  End Type

'////////////////////////////////////////////////////////////////////////////////////
'
'   PEDIDOS / REMITOS
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private Type T_ItAplic
    pvfv_id                 As Long
    rvfv_id                 As Long
    fvi_id                  As Long   ' Ids de items al que este credito esta vinculado
    
    Aplicado                As Double
  End Type
  
  Private Type T_PedidoRemito
    rvi_id                  As Long ' Ids de creditos
    pvi_id                  As Long '
    
    pr_id                   As Long
    
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
Private m_FvId              As Long
Private m_IsNotaCredito     As Boolean
Private m_FvNumero          As String
Private m_cliente           As String
Private m_CliId             As Long
Private m_DocId             As Long
Private m_SucId             As Long
Private m_Total             As Double

Private m_MonDefault        As Long

Private m_LastRowVto        As Long
Private m_LastRowItem       As Long

' Edit Apply
'
Private m_ObjectClient      As Object
Private m_emp_id            As Long
Private m_emp_nombre        As String

'////////////////////////////////////////////////////////////////////////////////////
'
'   COBRANZAS / NOTAS DE CREDITO
'
'////////////////////////////////////////////////////////////////////////////////////

  Private m_vCobzNC()         As T_CobzNC
  Private m_fvd_id            As Long
  Private m_fvp_id            As Long

'////////////////////////////////////////////////////////////////////////////////////
'
'   PEDIDOS / REMITOS
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private m_vPedidoRemito()   As T_PedidoRemito
  Private m_fvi_id            As Long

' eventos
' propiedades publicas

' Edit Apply
'
Public Property Set ObjectClient(ByVal rhs As Object)
  Set m_ObjectClient = rhs
End Property

Public Property Get id() As Long
  id = m_FvId
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Show(ByVal FvId As Long, ByVal Total As Double, _
                     ByVal FvNumero As String, _
                     ByVal CliId As Long, ByVal Cliente As String, _
                     ByVal SucId As Long, ByVal DocId As Long, _
                     ByVal IsNotaCredito As Boolean) As Boolean
  
  If m_ObjAbm Is Nothing Then
    Set m_ObjAbm = New cABMGeneric
  End If
  
  If m_FvId <> FvId Then
    m_IsNotaCredito = IsNotaCredito
    m_FvId = FvId
    m_FvNumero = FvNumero
    m_cliente = Cliente
    m_CliId = CliId
    m_DocId = DocId
    m_SucId = SucId
    m_Total = Total
    
    ' Edit Apply
    '
    If Not gDB.GetData(csTFacturaVenta, _
                       cscFvId, _
                       m_FvId, _
                       cscEmpId, _
                       m_emp_id) Then Exit Function
    
    If Not gDB.GetData(csTEmpresa, _
                       cscEmpId, _
                       m_emp_id, _
                       cscEmpNombre, _
                       m_emp_nombre) Then Exit Function
    
    pEdit
  Else
    m_ObjAbm.ObjForm.ZOrder
  End If
  
  Show = True
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
              Aplicado = pCobUpdateGrids
              
              pCobRefreshVto Aplicado
            End If
            
            ' Muestro las aplicaciones para este vencimiento
            '
            m_LastRowVto = iProp.SelectedIndex
            Set Row = iProp.Grid.Rows(m_LastRowVto)
            If Row Is Nothing Then Exit Function
            
            pCobSetAplicVtos pCobGetItemsCobranzaProperty(), _
                             pCell(Row, KIV_FVD_ID).id, _
                             pCell(Row, KIV_FVP_ID).id
            
            AbmObj.ShowValue pCobGetItemsCobranzaProperty(), True
          
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
            
            pItSetAplicItems m_ObjAbm.Properties(c_AplicPedidoRemito), _
                             pCell(Row, KII_FVI_ID).id, _
                             pCell(Row, KII_PR_ID).id
            
            AbmObj.ShowValue m_ObjAbm.Properties(c_AplicPedidoRemito), True
          
        End Select
    End Select
    
    cIABMClient_MessageEx = True
  End Function
  
  Private Sub cIABMClient_DiscardChanges()
    If Not pCobLoadAplicVtos() Then Exit Sub
    If Not pItLoadAplicItems() Then Exit Sub
    LoadCollection
  End Sub
  
  Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean
  End Function
  
  Private Sub cIABMClient_Load()
  End Sub
  
  Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
    Select Case Key
      Case K_DESAPLIC_ITEMS
        pDesAplicItems
    End Select
  End Function
  
  Private Sub pDesAplicItems()
    Dim i As Long
    Dim j As Long
    
    For i = 1 To UBound(m_vPedidoRemito)
      With m_vPedidoRemito(i)
        .Aplicado = 0
        .Pendiente = .PendienteActual + .AplicadoActual
        For j = 1 To UBound(.vAplicaciones)
          .vAplicaciones(j).Aplicado = 0
        Next
      End With
    Next
  
    Dim AbmObj As cABMGeneric
    Set AbmObj = m_ObjAbm
  
    pSetDesAplicToGrid m_vPedidoRemito, m_ObjAbm.Properties(c_Items)
    
    If m_LastRowItem > 0 Then
      With m_ObjAbm.Properties(c_Items).Grid.Rows.Item(m_LastRowItem)
        pItSetAplicItems m_ObjAbm.Properties(c_AplicPedidoRemito), .Item(KII_FVI_ID).id, .Item(KII_PR_ID).id
      End With
    End If
  
    AbmObj.ShowValue m_ObjAbm.Properties(c_Items), True
    AbmObj.ShowValue m_ObjAbm.Properties(c_AplicPedidoRemito), True
  End Sub
  
  Private Sub pSetDesAplicToGrid(ByRef vAplic() As T_PedidoRemito, ByRef iProp As cIABMProperty)
    Dim Row  As cIABMGridRow

    For Each Row In iProp.Grid.Rows
      pCell(Row, KII_PENDIENTE).Value = Val(pCell(Row, KII_PENDIENTE).Value) + Val(pCell(Row, KII_APLICADO).Value)
      pCell(Row, KII_APLICADO).Value = 0
    Next
  
    Dim i As Long
    Dim j As Long
  
    For i = 1 To UBound(vAplic)
      With vAplic(i)
        For j = 1 To UBound(.vAplicaciones)
          .Aplicado = pItAddToAplic(.vAplicaciones, 0, j)
          .Pendiente = .PendienteActual - (.Aplicado - .AplicadoActual)
        Next
      End With
    Next
  End Sub
  
  Private Function cIABMClient_Save() As Boolean
    cIABMClient_Save = pSave
  End Function
  
  Private Function cIABMClient_Terminate() As Boolean
    m_Editing = False
    cIABMClient_Terminate = True
    m_FvId = csNO_ID
    Set m_ObjAbm = Nothing
    
    ' Edit Apply
    '
    Set m_ObjectClient = Nothing
  End Function
  
  Private Property Get cIABMClient_Title() As String
    On Error Resume Next
    cIABMClient_Title = LNGGetText(1649, vbNullString)  'Aplicación Factura de Venta
    m_ObjAbm.Title2 = m_FvNumero & " - " & m_cliente
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
      Case K_APLIC_COBRANZA
        cIABMClientGrid_ColumnAfterUpdate = pCobColAUpdateCobranza(pCobGetItemsCobranzaProperty(), lRow, lCol)
      Case K_APLIC_PEDIDO_REMITO
        cIABMClientGrid_ColumnAfterUpdate = pItColAUpdatePedidoRemito(pItGetItemsPedidoRemitoProperty(), lRow, lCol)
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
      Case K_APLIC_COBRANZA
        cIABMClientGrid_ColumnBeforeEdit = pCobColBEditCobranza(pCobGetItemsCobranzaProperty(), lRow, lCol, iKeyAscii)
      Case K_APLIC_PEDIDO_REMITO
        cIABMClientGrid_ColumnBeforeEdit = pItColBEditPedidoRemito(pItGetItemsPedidoRemitoProperty(), lRow, lCol, iKeyAscii)
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
      
      Case K_APLIC_COBRANZA
        
        With pCobGetItemsCobranza().Rows
          If pCell(.Item(lRow), KIC_COBZ_ID).id = csNO_ID Then
            ShowDocAux pCell(.Item(lRow), KIC_FV_ID).id, _
                       "CSVenta2.cFacturaVenta", _
                       "CSABMInterface2.cABMGeneric"
          Else
            ShowDocAux pCell(.Item(lRow), KIC_COBZ_ID).id, _
                       "CSTesoreria2.cCobranza", _
                       "CSABMInterface2.cABMGeneric"
          End If
        End With
        
      Case K_APLIC_PEDIDO_REMITO

        With pItGetItemsPedidoRemito().Rows
          
          Dim id          As Long
          Dim ObjEditName As String
          
          id = pCell(.Item(lRow), KIPR_PVI_ID).id
          
          If id <> csNO_ID Then
            If Not gDB.GetData("PedidoVentaItem", _
                               "pvi_id", _
                               id, _
                               "pv_id", _
                               id) Then Exit Sub
            ObjEditName = "CSPedidoVenta2.cPedidoVenta"
          Else
            id = pCell(.Item(lRow), KIPR_RVI_ID).id
            If id <> csNO_ID Then
              If Not gDB.GetData("RemitoVentaItem", _
                                 "rvi_id", _
                                 id, _
                                 "rv_id", _
                                 id) Then Exit Sub
              ObjEditName = "CSVenta2.cRemitoVenta"
            End If
          End If
          
          If id <> csNO_ID Then
          
            ShowDocAux id, _
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

  Private Sub pEdit()
    On Error GoTo ControlError
    
    If Not pCobLoadAplicVtos() Then Exit Sub
    If Not pItLoadAplicItems() Then Exit Sub
    If Not LoadCollection() Then Exit Sub
    
    m_Editing = True
    
    Exit Sub
ControlError:
    MngError Err, "pEdit", C_Module, vbNullString
  End Sub
  
  Private Function LoadCollection() As Boolean
    Dim c       As cIABMProperty
    Dim iTab    As cIABMTabItem
    Dim oGrd    As cABMGrid
  
    m_LastRowVto = 0
    m_LastRowItem = 0
    
    m_ObjAbm.Properties.Clear
    m_ObjAbm.Tabs.Clear
    
    Set iTab = m_ObjAbm.Tabs.Add(Nothing)
    iTab.Index = 0
    iTab.Name = LNGGetText(1371, vbNullString)  'Items
    
    
    Set iTab = m_ObjAbm.Tabs.Add(Nothing)
    iTab.Index = 1
    iTab.Name = LNGGetText(1644, vbNullString)  'Vencimientos
    
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
      
      With .Add(Nothing)
        .PropertyType = cspButton
        .Name = LNGGetText(2523, vbNullString) 'Desaplicar todos
        .Key = K_DESAPLIC_ITEMS
      End With
      
      Set c = .Add(Nothing, c_AplicPedidoRemito)
      c.PropertyType = cspGrid
      c.LeftLabel = -1
      If Not pItSetGridAplicPedidoRemito(c) Then Exit Function
      c.Key = K_APLIC_PEDIDO_REMITO
      c.Name = "PedidoRemito"
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
            
      ' Cobranza
      Set c = .Add(Nothing, c_TotalCobranza)
      c.PropertyType = cspNumeric
      c.SubType = cspMoney
      c.Name = "Importe facturado"
      c.Enabled = False
      c.Left = 2000
      c.LeftLabel = -1500
      c.Format = m_GeneralConfig.FormatDecImporte
      c.Value = m_Total
      c.Key = K_TOTAL_COBRANZA
      c.Width = 1400
      c.TabIndex = 1
      
      Set c = .Add(Nothing, c_PendienteCobranza)
      c.PropertyType = cspNumeric
      c.SubType = cspMoney
      c.Name = "Pendiente"
      c.Enabled = False
      c.Format = m_GeneralConfig.FormatDecImporte
      c.Key = K_PENDIENTE_COBRANZA
      c.TopFromProperty = c_TotalCobranza
      c.Left = 6200
      c.Width = 1400
      c.LeftLabel = -1100
      c.TabIndex = 1
      
      Set c = .Add(Nothing, c_Vencimientos)
      c.PropertyType = cspGrid
      c.LeftLabel = -1
      If Not pCobLoadVencimientos(c) Then Exit Function
      c.Key = K_VENCIMIENTOS
      c.Name = "Vencimientos"
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
      
      Set c = .Add(Nothing, c_AplicCobranza)
      c.PropertyType = cspGrid
      c.LeftLabel = -1
      If Not pCobSetGridAplicCobranza(c) Then Exit Function
      c.Key = K_APLIC_COBRANZA
      c.Name = "Cobranza"
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
    
    pCobShowPendienteCobranza
    
    LoadCollection = True
  End Function

  Private Function pSave() As Boolean
    
    ' Edit Apply
    '
    If m_emp_id <> EmpId Then
      MsgApplyDisabled m_emp_nombre
      Exit Function
    End If
    
    Dim FvTMPId As Long
    
    pCobUpdateGrids
    pItUpdateGrids
    
    ' Temporal
    If Not pSaveDocVta(m_DocId, FvTMPId) Then Exit Function
  
    ' Pedidos / Remitos
    If Not pItSavePedidoRemito(FvTMPId) Then Exit Function
    
    ' Notas de credito
    If Not pSaveNotaCredito(FvTMPId) Then Exit Function
      
    ' Cobranzas
    If Not pSaveCobranza(FvTMPId) Then Exit Function
    
    ' Aplico llamando al sp
    Dim sqlstmt As String
    Dim rs      As Recordset
    
    sqlstmt = "sp_DocFacturaVentaSaveAplic " & FvTMPId
    If Not gDB.OpenRs(sqlstmt, rs, , , , "pSave", C_Module, c_ErrorSave) Then Exit Function
    
    If rs.EOF Then Exit Function
    
    Dim id As Long
    If Not GetDocIDFromRecordset(rs, id) Then Exit Function
    
    If id = csNO_ID Then Exit Function
    
    If Not pCobLoadAplicVtos() Then Exit Function
    If Not pItLoadAplicItems() Then Exit Function
    
    pSave = True
    
    ' Edit Apply
    '
    pRefreshClient
  End Function

  ' Edit Apply
  '
  Private Sub pRefreshClient()
    On Error Resume Next
    If m_ObjectClient Is Nothing Then Exit Sub
    m_ObjectClient.Refresh
  End Sub

  '////////////////////////////////////////////////////////////////////////////////////
  ' FacturaVentaTemporal
  '////////////////////////////////////////////////////////////////////////////////////
  Private Function pSaveDocVta(ByVal DocId As Long, _
                               ByRef FvTMPId As Long) As Boolean
    Dim register     As cRegister
    
    Set register = New cRegister
    register.fieldId = cscFvTMPId
    register.Table = csTFacturaVentaTMP
  
    register.id = csNew
    register.fields.Add2 cscFvId, m_FvId, csId
  
    register.fields.Add2 cscFvNumero, 0, csLong
    register.fields.Add2 cscFvNrodoc, vbNullString, csText
    
    register.fields.Add2 cscCliId, 0, csLong
    register.fields.Add2 cscSucId, 0, csLong
    register.fields.Add2 cscDocId, DocId, csId
    register.fields.Add2 cscCpgId, csECpgTipo.csECpgT_FechaDocumento, csId
  
    register.fields.Add2 cscFvGrabarAsiento, 0, csBoolean
    register.fields.Add2 cscEstId, CSGeneralEx2.csEEstado.csEEst_Pendiente, csId
  
    register.fields.HaveLastUpdate = True
    register.fields.HaveWhoModify = True
  
    If Not register.BeginTrans(gDB) Then Exit Function
  
    If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
    If Not register.CommitTrans() Then Exit Function
  
    FvTMPId = register.id
    pSaveDocVta = True
  End Function

'////////////////////////////////////////////////////////////////////////////////////
'
'   PEDIDOS / REMITOS
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
  
    sqlstmt = "sp_DocFacturaVentaGetAplic " & EmpId & "," & m_FvId & ",4"
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pItLoadItems", C_Module) Then Exit Function
  
    Propiedad.Grid.Columns.Clear
    Propiedad.Grid.Rows.Clear
  
    Set Grid = Propiedad.Grid
  
    With Grid.Columns
      With .Add(Nothing)
        .Visible = False
        .Key = KII_FVI_ID
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
      fv.id = gDB.ValField(rs.fields, cscFviId)
      fv.Key = KII_FVI_ID
  
      Set fv = f.Add(Nothing)
      fv.id = gDB.ValField(rs.fields, cscPrId)
      fv.Value = gDB.ValField(rs.fields, cscPrNombreVenta)
      fv.Key = KII_PR_ID
  
      Set fv = f.Add(Nothing)
      fv.Value = gDB.ValField(rs.fields, cscFviPendiente)
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

  Private Function pItSetGridAplicPedidoRemito(ByRef Propiedad As cIABMProperty) As Boolean
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
        .Key = KIPR_RVFV_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIPR_PVFV_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIPR_RVI_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIPR_PVI_ID
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
    
    pItSetGridAplicPedidoRemito = True
  End Function

  Private Function pItLoadAplicAplicados() As Boolean
    Dim sqlstmt       As String
    Dim rs            As ADODB.Recordset
    Dim i             As Long
    Dim Idx           As Long
    
    sqlstmt = "sp_DocFacturaVentaGetAplic " & EmpId & "," & m_FvId & ",5"
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadAplicAplicados", C_Module) Then Exit Function
    
    ReDim m_vPedidoRemito(0)
    ReDim m_vPedidoRemito(0).vAplicaciones(0)
    
    If Not rs.EOF Then
    
      rs.MoveLast
      rs.MoveFirst
    
      While Not rs.EOF
            
        i = pItAddToCreditos(gDB.ValField(rs.fields, cscRviId), _
                             gDB.ValField(rs.fields, cscPviId), _
                             Idx)
        With m_vPedidoRemito(i)
        
          ' Documento
          '
          .docNombre = gDB.ValField(rs.fields, cscDocNombre)
          .NroDoc = gDB.ValField(rs.fields, cscNroDoc)
          .Fecha = gDB.ValField(rs.fields, cscFecha)
          
          ' Pendiente
          '
          .Pendiente = gDB.ValField(rs.fields, cscPendiente)
          .PendienteActual = .Pendiente
          
          ' Pedido / Remito
          '
          .rvi_id = gDB.ValField(rs.fields, cscRviId)
          .pvi_id = gDB.ValField(rs.fields, cscPviId)
          .pr_id = gDB.ValField(rs.fields, cscPrId)
          
          ' Aplicaciones
          With .vAplicaciones(Idx)
          
            .rvfv_id = gDB.ValField(rs.fields, cscRvFvId)
            .pvfv_id = gDB.ValField(rs.fields, cscPvFvId)
              
            .fvi_id = gDB.ValField(rs.fields, cscFviId)
            
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
    
    sqlstmt = "sp_DocFacturaVentaGetAplic " & EmpId & "," & m_FvId & ",6"
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadAplicCreditos", C_Module) Then Exit Function
    
    If Not rs.EOF Then
      
      rs.MoveLast
      rs.MoveFirst
    
      i = UBound(m_vPedidoRemito)
      ReDim Preserve m_vPedidoRemito(i + rs.RecordCount)
      
      While Not rs.EOF
            
        i = i + 1
        With m_vPedidoRemito(i)
          .pr_id = gDB.ValField(rs.fields, cscPrId)
          .rvi_id = gDB.ValField(rs.fields, cscRviId)
          .pvi_id = gDB.ValField(rs.fields, cscPviId)
          
  
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
  
  Private Function pItAddToCreditos(ByVal RviId As Long, ByVal PviId As Long, ByRef Idx As Long) As Long
    Dim i As Long
    
    For i = 1 To UBound(m_vPedidoRemito)
      With m_vPedidoRemito(i)
        If (.rvi_id = RviId And RviId <> csNO_ID) Or _
           (.pvi_id = PviId And PviId <> csNO_ID) Then
           
           ReDim Preserve .vAplicaciones(UBound(.vAplicaciones) + 1)
           
           Idx = UBound(.vAplicaciones)
           pItAddToCreditos = i
           Exit Function
        End If
      End With
    Next
    
    ReDim Preserve m_vPedidoRemito(UBound(m_vPedidoRemito) + 1)
    ReDim m_vPedidoRemito(UBound(m_vPedidoRemito)).vAplicaciones(1)
    pItAddToCreditos = UBound(m_vPedidoRemito)
    Idx = 1
  End Function
  
  Private Function pItUpdateGrids() As Double
    Dim iProp As cIABMProperty
    Dim Row   As cIABMGridRow
    
    Set iProp = m_ObjAbm.Properties(c_Items)
    
    If m_LastRowItem <> 0 Then
      
      Set Row = iProp.Grid.Rows(m_LastRowItem)
      pItUpdateGrids = pItUpdateAplicItems(m_ObjAbm.Properties(c_AplicPedidoRemito), _
                                           pCell(Row, KII_FVI_ID).id)
    End If
  End Function
  
  Private Function pItSetAplicItems(ByRef iProp As cIABMProperty, _
                                    ByVal fvi_id As Long, _
                                    ByVal pr_id As Long) As Boolean
    Dim Cotizacion    As Double
    Dim i             As Long
    Dim j             As Long
    
    iProp.Grid.Rows.Clear
    
    m_fvi_id = fvi_id
    
    For i = 1 To UBound(m_vPedidoRemito)
    
      If m_vPedidoRemito(i).pr_id = pr_id Then
    
        If UBound(m_vPedidoRemito(i).vAplicaciones) > 0 Then
          pItSetAplicItemsAux1 i, iProp, fvi_id
        Else
          pItSetAplicItemsAux2 i, iProp
        End If
      End If
      
    Next
    
    ' Ahora los creditos que tienen aplicaciones
    ' pero no estan con este vencimiento y tienen pendiente
    Dim id      As Long
    Dim bAplic  As Boolean
    Dim Row     As cIABMGridRow
    
    For i = 1 To UBound(m_vPedidoRemito)
    
      bAplic = False
      
      If m_vPedidoRemito(i).pr_id = pr_id Then
      
        For Each Row In iProp.Grid.Rows
          id = pCell(Row, KIPR_RVI_ID).id
          If id = m_vPedidoRemito(i).rvi_id And id <> csNO_ID Then
            bAplic = True
            Exit For
          End If
          
          id = pCell(Row, KIPR_PVI_ID).id
          If id = m_vPedidoRemito(i).pvi_id And id <> csNO_ID Then
            bAplic = True
            Exit For
          End If
        
          id = m_fvi_id
          For j = 1 To UBound(m_vPedidoRemito(i).vAplicaciones)
            If id = m_vPedidoRemito(i).vAplicaciones(j).fvi_id And id <> csNO_ID Then
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
                                       ByVal fvi_id As Long) As Double
    Dim Cotizacion    As Double
    Dim i             As Long
    Dim j             As Long
    Dim Row           As cIABMGridRow
    Dim Aplicado      As Double
    Dim AplicadoTotal As Double
    
    For Each Row In pItGetItemsPedidoRemito().Rows
    
      If Val(pCell(Row, KIPR_APLICADO).Value) > 0 Or pCell(Row, KIPR_IDX2).id <> 0 Then
    
        i = pCell(Row, KIPR_IDX1).id
        j = pCell(Row, KIPR_IDX2).id
        
        Aplicado = Val(pCell(Row, KIPR_APLICADO).Value)
        AplicadoTotal = AplicadoTotal + Aplicado
        
        With m_vPedidoRemito(i)
          .Aplicado = pItAddToAplic(.vAplicaciones, Aplicado, j)
          .Pendiente = .PendienteActual - (.Aplicado - .AplicadoActual)
        End With
      End If
    Next
    
    pItUpdateAplicItems = AplicadoTotal
  End Function
  
  Private Sub pItSetAplicItemsAux1(ByVal Idx As Long, ByRef iProp As cIABMProperty, ByVal fvi_id As Long)
    Dim f               As cIABMGridRow
    Dim fv              As cIABMGridCellValue
    Dim i               As Long
    Dim iPropItem       As cIABMProperty
    Dim Row             As cABMGridRow
    
    For i = 1 To UBound(m_vPedidoRemito(Idx).vAplicaciones)
    
      With m_vPedidoRemito(Idx).vAplicaciones(i)
    
        If .fvi_id = fvi_id And fvi_id <> csNO_ID Then
        
          Set f = iProp.Grid.Rows.Add(Nothing)
          
          Set fv = f.Add(Nothing)
          fv.id = Idx
          fv.Key = KIPR_IDX1
          
          Set fv = f.Add(Nothing)
          fv.id = i
          fv.Key = KIPR_IDX2
          
          Set fv = f.Add(Nothing)
          fv.id = .rvfv_id
          fv.Key = KIPR_RVFV_ID
          
          Set fv = f.Add(Nothing)
          fv.id = .pvfv_id
          fv.Key = KIPR_PVFV_ID
          
          Set fv = f.Add(Nothing)
          fv.id = m_vPedidoRemito(Idx).rvi_id
          fv.Key = KIPR_RVI_ID
          
          Set fv = f.Add(Nothing)
          fv.id = m_vPedidoRemito(Idx).pvi_id
          fv.Key = KIPR_PVI_ID
          
          Set fv = f.Add(Nothing)
          fv.Value = m_vPedidoRemito(Idx).docNombre
          fv.Key = KIPR_DOC
          
          Set fv = f.Add(Nothing)
          fv.Value = m_vPedidoRemito(Idx).NroDoc
          fv.Key = KIPR_NRODOC
          
          Set fv = f.Add(Nothing)
          If m_vPedidoRemito(Idx).Fecha = csNoDate Then
            fv.Value = vbNullString
          Else
            fv.Value = m_vPedidoRemito(Idx).Fecha
          End If
          fv.Key = KIPR_FECHA
      
          Set fv = f.Add(Nothing)
          fv.Value = m_vPedidoRemito(Idx).Pendiente
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
    
    If m_vPedidoRemito(i).Pendiente <= 0 Then Exit Sub
    
    With m_vPedidoRemito(i)
  
      Set f = iProp.Grid.Rows.Add(Nothing)
      
      Set fv = f.Add(Nothing)
      fv.id = i
      fv.Key = KIPR_IDX1
      
      Set fv = f.Add(Nothing)
      fv.id = 0
      fv.Key = KIPR_IDX2
      
      Set fv = f.Add(Nothing)
      fv.id = csNO_ID
      fv.Key = KIPR_RVFV_ID
      
      Set fv = f.Add(Nothing)
      fv.id = csNO_ID
      fv.Key = KIPR_PVFV_ID
      
      Set fv = f.Add(Nothing)
      fv.id = .rvi_id
      fv.Key = KIPR_RVI_ID
      
      Set fv = f.Add(Nothing)
      fv.id = .pvi_id
      fv.Key = KIPR_PVI_ID
      
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
        .fvi_id = m_fvi_id
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

  Private Function pItGetItemsPedidoRemitoProperty() As cIABMProperty
    Set pItGetItemsPedidoRemitoProperty = m_ObjAbm.Properties(c_AplicPedidoRemito)
  End Function
  
  Private Function pItGetItemsPedidoRemito() As cIABMGrid
    Set pItGetItemsPedidoRemito = m_ObjAbm.Properties(c_AplicPedidoRemito).Grid
  End Function

  Private Function pItColBEditPedidoRemito(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
    Select Case pGetKeyFromCol(IProperty.Grid.Columns, lCol)
      Case KIPR_APLICADO
      Case Else
        Exit Function
    End Select
    
    pItColBEditPedidoRemito = True
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
  
  Private Function pItColAUpdatePedidoRemito(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long)
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
    
    pItColAUpdatePedidoRemito = True
  End Function
  
  Private Function pItGetAplicado() As Double
    Dim Row       As cIABMGridRow
    Dim rtn       As Double
    
    For Each Row In m_ObjAbm.Properties(c_AplicPedidoRemito).Grid.Rows
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
  
  Private Function pItSavePedidoRemito(ByVal FvTMPId As Long) As Boolean
    If Not pItSavePedido(FvTMPId) Then Exit Function
    If Not pItSaveRemito(FvTMPId) Then Exit Function
    pItSavePedidoRemito = True
  End Function
  
  Private Function pItSavePedido(ByVal FvTMPId As Long) As Boolean
    Dim register    As cRegister
    Dim i           As Long
    Dim j           As Long
    
    For i = 1 To UBound(m_vPedidoRemito)
   
      If m_vPedidoRemito(i).pvi_id <> csNO_ID Then
   
        For j = 1 To UBound(m_vPedidoRemito(i).vAplicaciones)
        
          If m_vPedidoRemito(i).vAplicaciones(j).fvi_id <> csNO_ID Then
        
            With m_vPedidoRemito(i).vAplicaciones(j)
              
              If .Aplicado > 0 Then
          
                Set register = New cRegister
                register.fieldId = cscPvFvTMPId
                register.Table = csTPedidoFacturaVentaTMP
                register.id = csNew
                
                register.fields.Add2 cscFvTMPId, FvTMPId, csId
                register.fields.Add2 cscPviId, m_vPedidoRemito(i).pvi_id, csId
                register.fields.Add2 cscFviId, .fvi_id, csId
                register.fields.Add2 cscPvFvCantidad, .Aplicado, csDouble
                
                register.fields.Add2 cscPvFvId, .pvfv_id, csLong
                
                register.fields.HaveLastUpdate = False
                register.fields.HaveWhoModify = False
                
                If Not gDB.Save(register, , "pItSavePedido", C_Module, c_ErrorSave) Then Exit Function
              End If
            End With
          End If
        Next
      End If
    Next
    
    pItSavePedido = True
  End Function
  
  Private Function pItSaveRemito(ByVal FvTMPId As Long) As Boolean
    Dim register    As cRegister
    Dim i           As Long
    Dim j           As Long
    
    For i = 1 To UBound(m_vPedidoRemito)
   
      If m_vPedidoRemito(i).rvi_id <> csNO_ID Then
   
        For j = 1 To UBound(m_vPedidoRemito(i).vAplicaciones)
        
          If m_vPedidoRemito(i).vAplicaciones(j).fvi_id <> csNO_ID Then
        
            With m_vPedidoRemito(i).vAplicaciones(j)
              
              If .Aplicado > 0 Then
          
                Set register = New cRegister
                register.fieldId = cscRvFvTMPId
                register.Table = csTRemitoFacturaVentaTMP
                register.id = csNew
                
                register.fields.Add2 cscFvTMPId, FvTMPId, csId
                register.fields.Add2 cscRviId, m_vPedidoRemito(i).rvi_id, csId
                register.fields.Add2 cscFviId, .fvi_id, csId
                register.fields.Add2 cscRvFvCantidad, .Aplicado, csDouble
                
                register.fields.Add2 cscRvFvId, .rvfv_id, csLong
                
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

  Private Function pCobLoadAplicVtos() As Boolean
    
    If Not pCobLoadAplicAplicados() Then Exit Function
    If Not pCobLoadAplicCreditos() Then Exit Function
    
    pCobLoadAplicVtos = True
  End Function
    
  Private Function pCobLoadAplicAplicados() As Boolean
    Dim sqlstmt       As String
    Dim rs            As ADODB.Recordset
    Dim i             As Long
    Dim Idx           As Long
    
    sqlstmt = "sp_DocFacturaVentaGetAplic " & EmpId & "," & m_FvId & ",2"
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadAplicAplicados", C_Module) Then Exit Function
    
    ReDim m_vCobzNC(0)
    ReDim m_vCobzNC(0).vAplicaciones(0)
    
    If Not rs.EOF Then
    
      rs.MoveLast
      rs.MoveFirst
    
      While Not rs.EOF
            
        i = pCobAddToCreditos(gDB.ValField(rs.fields, cscCobzId), _
                              gDB.ValField(rs.fields, cscFvdId), _
                              gDB.ValField(rs.fields, cscFvpId), _
                              Idx)
        With m_vCobzNC(i)
        
          ' Documento
          '
          .docNombre = gDB.ValField(rs.fields, cscDocNombre)
          .NroDoc = gDB.ValField(rs.fields, cscNroDoc)
          
          ' Pendiente
          '
          .Pendiente = gDB.ValField(rs.fields, cscPendiente)
          .PendienteActual = .Pendiente
          
          ' Factura o Nota de credito
          '
          .fv_id = gDB.ValField(rs.fields, cscFvId)
          
          .fvp_id = gDB.ValField(rs.fields, "fvp_id2")
          .fvd_id = gDB.ValField(rs.fields, "fvd_id2")
          
          ' Cobranza
          '
          .cobz_id = gDB.ValField(rs.fields, cscCobzId)
          .Fecha = gDB.ValField(rs.fields, cscCobzFecha)
          .Cotizacion = gDB.ValField(rs.fields, cscFvCobzCotizacion)
          
          ' Aplicaciones
          With .vAplicaciones(Idx)
          
            .fvcobz_id = gDB.ValField(rs.fields, cscFvCobzId)
            .fvnc_id = gDB.ValField(rs.fields, cscFvNcId)
              
            .fvp_id = gDB.ValField(rs.fields, cscFvpId)
            .fvd_id = gDB.ValField(rs.fields, cscFvdId)
            
            .Aplicado = gDB.ValField(rs.fields, cscAplicado)
          End With
          
          ' Aplicacion total sobre este credito
          .Aplicado = .Aplicado + .vAplicaciones(Idx).Aplicado
          .AplicadoActual = .Aplicado
        End With
        
        rs.MoveNext
      Wend
    End If
    
    pCobLoadAplicAplicados = True
  End Function
  
  Private Function pCobLoadVencimientos(ByRef Propiedad As cIABMProperty) As Boolean
    Dim sqlstmt     As String
    Dim rs          As ADODB.Recordset
    Dim Grid        As cIABMGrid
    Dim Row         As cABMGridRow
    Dim Value       As Double
  
    sqlstmt = "sp_DocFacturaVentaGetAplic " & EmpId & "," & m_FvId & ",1"
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadAplic", C_Module) Then Exit Function
  
    Propiedad.Grid.Columns.Clear
    Propiedad.Grid.Rows.Clear
  
    Set Grid = Propiedad.Grid
  
    With Grid.Columns
      With .Add(Nothing)
        .Visible = False
        .Key = KIV_FVD_ID
      End With
  
      With .Add(Nothing)
        .Visible = False
        .Key = KIV_FVP_ID
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
        .PropertyType = cspText
        .Visible = False
        .Key = KIV_APLICADO2
      End With
    End With
    
    Dim f  As cIABMGridRow
    Dim fv As cIABMGridCellValue
  
    While Not rs.EOF
  
      Set f = Propiedad.Grid.Rows.Add(Nothing)
  
      Set fv = f.Add(Nothing)
      fv.id = gDB.ValField(rs.fields, cscFvdId)
      fv.Key = KIV_FVD_ID
  
      Set fv = f.Add(Nothing)
      fv.id = gDB.ValField(rs.fields, cscFvpId)
      fv.Key = KIV_FVP_ID
  
      Set fv = f.Add(Nothing)
      fv.Value = gDB.ValField(rs.fields, cscFecha)
      fv.Key = KIV_FECHA
  
      Set fv = f.Add(Nothing)
      fv.Value = gDB.ValField(rs.fields, cscPendiente)
      fv.Key = KIV_PENDIENTE
  
      Value = gDB.ValField(rs.fields, cscImporte)
      Set fv = f.Add(Nothing)
      fv.Value = Value
      fv.Key = KIV_APLICADO
      
      If Value <> 0 Then
        Set Row = f
        Row.BackColor = &HFFCC99
      End If
      
      Set fv = f.Add(Nothing)
      fv.Value = gDB.ValField(rs.fields, cscImporte)
      fv.Key = KIV_APLICADO2
      
      rs.MoveNext
    Wend
  
    pCobLoadVencimientos = True
  End Function

  Private Function pCobLoadAplicCreditos() As Boolean
    Dim sqlstmt       As String
    Dim rs            As ADODB.Recordset
    Dim i             As Long
    
    sqlstmt = "sp_DocFacturaVentaGetAplic " & EmpId & "," & m_FvId & ",3"
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadAplicCreditos", C_Module) Then Exit Function
    
    If Not rs.EOF Then
      
      rs.MoveLast
      rs.MoveFirst
    
      i = UBound(m_vCobzNC)
      ReDim Preserve m_vCobzNC(i + rs.RecordCount)
      
      While Not rs.EOF
            
        i = i + 1
        With m_vCobzNC(i)
          .cobz_id = gDB.ValField(rs.fields, cscCobzId)
          .fv_id = gDB.ValField(rs.fields, cscFvId)
          .fvd_id = gDB.ValField(rs.fields, cscFvdId)
  
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
    
    pCobLoadAplicCreditos = True
  End Function

  Private Function pCobSetGridAplicCobranza(ByRef Propiedad As cIABMProperty) As Boolean
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
        .Key = KIC_FVCOBZ_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIC_FVNC_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIC_COBZ_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIC_FV_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIC_FVD_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIC_FVP_ID
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
        .Name = LNGGetText(1569, vbNullString)  'Fecha"
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
    
    pCobSetGridAplicCobranza = True
  End Function
  
  Private Function pCobAddToCreditos(ByVal CobzId As Long, ByVal FvdId As Long, ByVal FvpId As Long, ByRef Idx As Long) As Long
    Dim i As Long
    
    For i = 1 To UBound(m_vCobzNC)
      With m_vCobzNC(i)
        If (.cobz_id = CobzId And CobzId <> csNO_ID) Or _
           (.fvd_id = FvdId And FvdId <> csNO_ID) Or _
           (.fvp_id = FvpId And FvpId <> csNO_ID) Then
           
           ReDim Preserve .vAplicaciones(UBound(.vAplicaciones) + 1)
           
           Idx = UBound(.vAplicaciones)
           pCobAddToCreditos = i
           Exit Function
        End If
      End With
    Next
    
    ReDim Preserve m_vCobzNC(UBound(m_vCobzNC) + 1)
    ReDim m_vCobzNC(UBound(m_vCobzNC)).vAplicaciones(1)
    pCobAddToCreditos = UBound(m_vCobzNC)
    Idx = 1
  End Function
  
  Private Function pCobSetAplicVtos(ByRef iProp As cIABMProperty, _
                                    ByVal fvd_id As Long, _
                                    ByVal fvp_id As Long) As Boolean
    Dim Cotizacion    As Double
    Dim i             As Long
    Dim j             As Long
    
    iProp.Grid.Rows.Clear
    
    m_fvd_id = fvd_id
    m_fvp_id = fvp_id
    
    For i = 1 To UBound(m_vCobzNC)
    
      If UBound(m_vCobzNC(i).vAplicaciones) > 0 Then
        pCobSetAplicVtosAux1 i, iProp, fvd_id, fvp_id
      Else
        pCobSetAplicVtosAux2 i, iProp
      End If
      
    Next
    
    ' Ahora los creditos que tienen aplicaciones
    ' pero no estan con este vencimiento y tienen pendiente
    Dim id      As Long
    Dim bAplic  As Boolean
    Dim Row     As cIABMGridRow
    
    For i = 1 To UBound(m_vCobzNC)
    
      bAplic = False
      
      For Each Row In iProp.Grid.Rows
        id = pCell(Row, KIC_COBZ_ID).id
        If id = m_vCobzNC(i).cobz_id And id <> csNO_ID Then
          bAplic = True
          Exit For
        End If
        
        id = pCell(Row, KIC_FVD_ID).id
        If id = m_vCobzNC(i).fvd_id And id <> csNO_ID Then
          bAplic = True
          Exit For
        End If
        
        id = pCell(Row, KIC_FVP_ID).id
        If id = m_vCobzNC(i).fvp_id And id <> csNO_ID Then
          bAplic = True
          Exit For
        End If
      
        For j = 1 To UBound(m_vCobzNC(i).vAplicaciones)
        
          id = pCell(Row, KIC_FVD_ID).id
          If id = m_vCobzNC(i).vAplicaciones(j).fvd_id And id <> csNO_ID Then
            bAplic = True
            Exit For
          End If
          
          id = pCell(Row, KIC_FVP_ID).id
          If id = m_vCobzNC(i).vAplicaciones(j).fvp_id And id <> csNO_ID Then
            bAplic = True
            Exit For
          End If
        Next
      
        If bAplic Then Exit For
      Next
    
      If Not bAplic Then pCobSetAplicVtosAux2 i, iProp
      
    Next
    
    pCobSetAplicVtos = True
  End Function
  
  Private Sub pCobSetAplicVtosAux1(ByVal Idx As Long, ByRef iProp As cIABMProperty, _
                                   ByVal fvd_id As Long, ByVal fvp_id As Long)
                                
    Dim f               As cIABMGridRow
    Dim fv              As cIABMGridCellValue
    Dim i               As Long
    Dim iPropVto        As cIABMProperty
    Dim Row             As cABMGridRow
    
    For i = 1 To UBound(m_vCobzNC(Idx).vAplicaciones)
    
      With m_vCobzNC(Idx).vAplicaciones(i)
    
        If (.fvd_id = fvd_id And fvd_id <> csNO_ID) Or (.fvp_id = fvp_id And fvp_id <> csNO_ID) Then
        
          Set f = iProp.Grid.Rows.Add(Nothing)
          
          Set fv = f.Add(Nothing)
          fv.id = Idx
          fv.Key = KIC_IDX1
          
          Set fv = f.Add(Nothing)
          fv.id = i
          fv.Key = KIC_IDX2
          
          Set fv = f.Add(Nothing)
          fv.id = .fvcobz_id
          fv.Key = KIC_FVCOBZ_ID
          
          Set fv = f.Add(Nothing)
          fv.id = .fvnc_id
          fv.Key = KIC_FVNC_ID
          
          Set fv = f.Add(Nothing)
          fv.id = m_vCobzNC(Idx).cobz_id
          fv.Key = KIC_COBZ_ID
          
          Set fv = f.Add(Nothing)
          fv.id = m_vCobzNC(Idx).fv_id
          fv.Key = KIC_FV_ID
          
          Set fv = f.Add(Nothing)
          fv.id = .fvd_id
          fv.Key = KIC_FVD_ID
          
          Set fv = f.Add(Nothing)
          fv.id = .fvp_id
          fv.Key = KIC_FVP_ID
          
          Set fv = f.Add(Nothing)
          fv.Value = m_vCobzNC(Idx).docNombre
          fv.Key = KIC_DOC
          
          Set fv = f.Add(Nothing)
          fv.Value = m_vCobzNC(Idx).NroDoc
          fv.Key = KIC_NRODOC
          
          Set fv = f.Add(Nothing)
          If m_vCobzNC(Idx).Fecha = csNoDate Then
            fv.Value = vbNullString
          Else
            fv.Value = m_vCobzNC(Idx).Fecha
          End If
          fv.Key = KIC_FECHA
      
          Set fv = f.Add(Nothing)
          fv.Value = m_vCobzNC(Idx).Pendiente
          fv.Key = KIC_PENDIENTE
          
          Set fv = f.Add(Nothing)
          fv.Value = .Aplicado
          fv.Key = KIC_APLICADO
          
          Set fv = f.Add(Nothing)
          If m_vCobzNC(Idx).Cotizacion <> 0 Then
            fv.Value = m_vCobzNC(Idx).Cotizacion
          End If
          fv.Key = KIC_COTIZACION
          
          Set fv = f.Add(Nothing)
          fv.Value = .Aplicado
          fv.Key = KIC_APLICADO2
          
          Set Row = f
          Row.BackColor = &HFFCC99
        End If
      End With
    Next
  End Sub
  
  Private Sub pCobSetAplicVtosAux2(ByVal i As Long, ByRef iProp As cIABMProperty)
    Dim f             As cIABMGridRow
    Dim fv            As cIABMGridCellValue
    
    If m_vCobzNC(i).Pendiente <= 0 Then Exit Sub
    
    With m_vCobzNC(i)
  
      Set f = iProp.Grid.Rows.Add(Nothing)
      
      Set fv = f.Add(Nothing)
      fv.id = i
      fv.Key = KIC_IDX1
      
      Set fv = f.Add(Nothing)
      fv.id = 0
      fv.Key = KIC_IDX2
      
      Set fv = f.Add(Nothing)
      fv.id = csNO_ID
      fv.Key = KIC_FVCOBZ_ID
      
      Set fv = f.Add(Nothing)
      fv.id = csNO_ID
      fv.Key = KIC_FVNC_ID
      
      Set fv = f.Add(Nothing)
      fv.id = .cobz_id
      fv.Key = KIC_COBZ_ID
      
      Set fv = f.Add(Nothing)
      fv.id = .fv_id
      fv.Key = KIC_FV_ID
      
      Set fv = f.Add(Nothing)
      fv.id = .fvd_id
      fv.Key = KIC_FVD_ID
      
      Set fv = f.Add(Nothing)
      fv.id = csNO_ID
      fv.Key = KIC_FVP_ID
      
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

  Private Function pCobUpdateAplicVtos(ByRef Propiedad As cIABMProperty, _
                                       ByVal fvd_id As Long, _
                                       ByVal fvp_id As Long) As Double
    Dim Cotizacion    As Double
    Dim i             As Long
    Dim j             As Long
    Dim Row           As cIABMGridRow
    Dim Aplicado      As Double
    Dim AplicadoTotal As Double
    
    For Each Row In pCobGetItemsCobranza().Rows
    
      If Val(pCell(Row, KIC_APLICADO).Value) > 0 Or pCell(Row, KIC_IDX2).id <> 0 Then
    
        i = pCell(Row, KIC_IDX1).id
        j = pCell(Row, KIC_IDX2).id
        
        Aplicado = Val(pCell(Row, KIC_APLICADO).Value)
        AplicadoTotal = AplicadoTotal + Aplicado
        
        With m_vCobzNC(i)
          .Aplicado = pCobAddToAplic(.vAplicaciones, Aplicado, j)
          .Pendiente = .PendienteActual - (.Aplicado - .AplicadoActual)
        End With
      End If
    Next
    
    pCobUpdateAplicVtos = AplicadoTotal
  End Function
  
  Private Function pCobAddToAplic(ByRef vAplicaciones() As T_CobAplic, ByVal Importe As Double, ByVal Idx As Long) As Double
    Dim i    As Long
    Dim rtn  As Double
    
    If Idx = 0 Then
      ReDim Preserve vAplicaciones(UBound(vAplicaciones) + 1)
      Idx = UBound(vAplicaciones)
      With vAplicaciones(Idx)
        .fvd_id = m_fvd_id
        .fvp_id = m_fvp_id
      End With
    End If
    
    vAplicaciones(Idx).Aplicado = Importe
    
    For i = 1 To UBound(vAplicaciones)
      rtn = rtn + vAplicaciones(i).Aplicado
    Next
    
    pCobAddToAplic = rtn
  End Function

  Private Function pCobGetVtoPendiente() As cIABMGridCellValue
    Dim iProp As cIABMProperty
    Set iProp = m_ObjAbm.Properties(c_Vencimientos)
    Set pCobGetVtoPendiente = pCell(iProp.Grid.Rows(iProp.SelectedIndex), KIV_PENDIENTE)
  End Function
  
  Private Function pCobGetVtoAplicado() As cIABMGridCellValue
    Dim iProp As cIABMProperty
    Set iProp = m_ObjAbm.Properties(c_Vencimientos)
    Set pCobGetVtoAplicado = pCell(iProp.Grid.Rows(iProp.SelectedIndex), KIV_APLICADO2)
  End Function
  
  Private Function pCobColAUpdateCobranza(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long)
    Dim Row        As cIABMGridRow
    Dim MaxVal     As Double
    Dim bVisible   As Boolean
    Dim Pendiente  As Double
    
    With IProperty.Grid
      Select Case .Columns(lCol).Key
        Case KIC_APLICADO
          Set Row = .Rows(lRow)
          
          With pCell(Row, KIC_APLICADO)
            
            Pendiente = Val(pCobGetVtoPendiente.Value) + Val(pCell(Row, KIC_APLICADO2).Value)
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
            Aplicado = pCobGetAplicado
            pCobRefreshVto Aplicado
            pCobGetVtoAplicado.Value = Aplicado
          End With
          
          ' Actulizo el pendiente
          With pCell(Row, KIC_PENDIENTE)
            .Value = Val(.Value) + Val(pCell(Row, KIC_APLICADO2).Value) - Val(pCell(Row, KIC_APLICADO).Value)
          End With
          pCell(Row, KIC_APLICADO2).Value = pCell(Row, KIC_APLICADO).Value
          
          pCobShowPendienteCobranza
      End Select
    End With
    
    pCobColAUpdateCobranza = True
  End Function
  
  Private Function pCobGetAplicado() As Double
    Dim Row       As cIABMGridRow
    Dim rtn       As Double
    
    For Each Row In pCobGetItemsCobranzaProperty().Grid.Rows
      rtn = rtn + Val(pCell(Row, KIC_APLICADO).Value)
    Next
    pCobGetAplicado = rtn
  End Function
  
  Private Sub pCobRefreshVto(ByVal Aplicado As Double)
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
  
  Private Function pCobGetItemsCobranzaProperty() As cIABMProperty
    Set pCobGetItemsCobranzaProperty = m_ObjAbm.Properties(c_AplicCobranza)
  End Function
  
  Private Function pCobGetItemsCobranza() As cIABMGrid
    Set pCobGetItemsCobranza = m_ObjAbm.Properties(c_AplicCobranza).Grid
  End Function
  
  Private Function pCobGetItemsVtosProperty() As cIABMProperty
    Set pCobGetItemsVtosProperty = m_ObjAbm.Properties(c_Vencimientos)
  End Function
  
  Private Function pCobColBEditCobranza(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
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
    
    pCobColBEditCobranza = True
  End Function
  
  Private Sub pCobShowPendienteCobranza()
    Dim Row           As cIABMGridRow
    Dim Total         As Double
    
    For Each Row In pCobGetItemsVtosProperty().Grid.Rows
      Total = Total + Val(pCell(Row, KIV_PENDIENTE).Value)
    Next
    
    pCobGetPendienteCobranza().Value = Total
    
    m_ObjAbm.ShowValue pCobGetPendienteCobranza
  End Sub
  
  Private Function pCobGetPendienteCobranza() As cIABMProperty
    Set pCobGetPendienteCobranza = m_ObjAbm.Properties.Item(c_PendienteCobranza)
  End Function

  Private Function pCobUpdateGrids() As Double
    Dim iProp As cIABMProperty
    Dim Row   As cIABMGridRow
    
    Set iProp = m_ObjAbm.Properties(c_Vencimientos)
    
    If m_LastRowVto <> 0 Then
      
      Set Row = iProp.Grid.Rows(m_LastRowVto)
      pCobUpdateGrids = pCobUpdateAplicVtos(pCobGetItemsCobranzaProperty(), _
                                            pCell(Row, KIV_FVD_ID).id, _
                                            pCell(Row, KIV_FVP_ID).id)
    End If
  End Function

  '////////////////////////////////////////////////////////////////////////////////////
  ' Nota de credito
  '////////////////////////////////////////////////////////////////////////////////////
  
  ' Proposito: Vincular una/s nota de credito con una/s factura
  '
  Private Function pSaveNotaCredito(ByVal FvTMPId As Long) As Boolean
    Dim register    As cRegister
    Dim Row         As cIABMGridRow
    Dim Cell        As cIABMGridCellValue
    Dim i           As Long
    Dim j           As Long
    
    For i = 1 To UBound(m_vCobzNC)
    
      If m_vCobzNC(i).fv_id <> csNO_ID Then
    
        For j = 1 To UBound(m_vCobzNC(i).vAplicaciones)
      
          With m_vCobzNC(i).vAplicaciones(j)
            
            If .Aplicado > 0 Or .fvnc_id Then
        
              Set register = New cRegister
              register.fieldId = cscFvNcTMPid
              register.Table = csTFacturaVentaNotaCreditoTMP
              register.id = csNew
              
              register.fields.Add2 cscFvTMPId, FvTMPId, csId
              
              If m_IsNotaCredito Then
                register.fields.Add2 cscFvIdNotaCredito, m_FvId, csId
                register.fields.Add2 cscFvIdFactura, m_vCobzNC(i).fv_id, csId
              
                register.fields.Add2 cscFvdIdNotaCredito, .fvd_id, csId
                register.fields.Add2 cscFvdIdFactura, m_vCobzNC(i).fvd_id, csId
                
                register.fields.Add2 cscFvpIdNotaCredito, .fvp_id, csId
                register.fields.Add2 cscFvpIdFactura, m_vCobzNC(i).fvp_id, csId
              Else
                register.fields.Add2 cscFvIdNotaCredito, m_vCobzNC(i).fv_id, csId
                register.fields.Add2 cscFvIdFactura, m_FvId, csId
              
                register.fields.Add2 cscFvdIdNotaCredito, m_vCobzNC(i).fvd_id, csId
                register.fields.Add2 cscFvdIdFactura, .fvd_id, csId
                
                register.fields.Add2 cscFvpIdNotaCredito, m_vCobzNC(i).fvp_id, csId
                register.fields.Add2 cscFvpIdFactura, .fvp_id, csId
              End If
              
              
              register.fields.Add2 cscFvNcImporte, .Aplicado, csDouble
              register.fields.Add2 cscFvNcId, 0, csLong
              
              register.fields.HaveLastUpdate = False
              register.fields.HaveWhoModify = False
              
              If Not gDB.Save(register, , "pSaveFVNCAux", C_Module, c_ErrorSave) Then Exit Function
            End If
          End With
        Next
      End If
    Next
    
    pSaveNotaCredito = True
  End Function

  '////////////////////////////////////////////////////////////////////////////////////
  ' Cobranza
  '////////////////////////////////////////////////////////////////////////////////////
  
  ' Guardo cada una de las cobranzas modificadas
  ' por la edicion de esta aplicacion
  Private Function pSaveCobranza(ByVal FvTMPId As Long) As Boolean
    Dim vCobranzas() As T_Cobranza
    Dim i          As Long
    
    pGetCobranzas vCobranzas()
    
    For i = 1 To UBound(vCobranzas)
      With vCobranzas(i)
        If Not pSaveCobranzaAux(.cobz_id, FvTMPId, .NewAplic) Then Exit Function
      End With
    Next
    
    pSaveCobranza = True
  End Function
  
  Private Sub pGetCobranzas(ByRef vCobranzas() As T_Cobranza)
    Dim Row     As cIABMGridRow
    Dim i       As Long
    Dim k       As Long
    
    ReDim vCobranzas(0)
    
    For i = 1 To UBound(m_vCobzNC)
      If m_vCobzNC(i).cobz_id <> csNO_ID Then
        
        With m_vCobzNC(i)
          
          If .Aplicado > 0 Or .AplicadoActual <> 0 Then
          
            k = pGetIdxCobranzas(vCobranzas, .cobz_id)
            With vCobranzas(k)
              .cobz_id = m_vCobzNC(i).cobz_id
              .NewAplic = m_vCobzNC(i).Aplicado
              .CurrAplic = m_vCobzNC(i).AplicadoActual
            End With
          End If
        End With
      End If
    Next
  End Sub
  
  Private Function pGetIdxCobranzas(ByRef vCobranzas() As T_Cobranza, ByVal CobzId As Long) As Long
    Dim bFound As Boolean
    Dim i      As Long
    
    For i = 1 To UBound(vCobranzas)
      If vCobranzas(i).cobz_id = CobzId Then
        pGetIdxCobranzas = i
        Exit Function
      End If
    Next
    
    If Not bFound Then
      ReDim Preserve vCobranzas(UBound(vCobranzas) + 1)
    End If
    
    pGetIdxCobranzas = UBound(vCobranzas)
  End Function
  
  Private Function pSaveCobranzaAux(ByVal CobzId As Long, ByVal FvTMPId As Long, ByVal Aplic As Double) As Boolean
    Dim register     As cRegister
    
    Dim Mouse As cMouseWait
    Set Mouse = New cMouseWait
    
    DoEvents: DoEvents: DoEvents: DoEvents
    
    Set register = New cRegister
    register.fieldId = cscCobzTMPId
    register.Table = csTCobranzaTMP
    
    register.id = csNew
    
    register.fields.Add2 cscFvTMPId, FvTMPId, csId
    register.fields.Add2 cscCobzNumero, 0, csLong
    register.fields.Add2 cscCliId, csNO_ID, csLong
    register.fields.Add2 cscSucId, csNO_ID, csLong
    register.fields.Add2 cscDocId, csNO_ID, csLong
    register.fields.Add2 cscEstId, csNO_ID, csLong
    register.fields.Add2 cscCobzId, CobzId, csId
    
    register.fields.HaveLastUpdate = True
    register.fields.HaveWhoModify = True
    
    If Not register.BeginTrans(gDB) Then Exit Function
    
    If Not gDB.Save(register, , "pSave", C_Module, c_ErrorSave) Then Exit Function
    
    If Not pSaveItems(register.id, CobzId) Then Exit Function
    If Not pSaveCtaCte(register.id, CobzId, Aplic) Then Exit Function
    
    If Not register.CommitTrans() Then Exit Function
    
    pSaveCobranzaAux = True
  End Function
  
  Private Function pSaveItems(ByVal id As Long, ByVal CobzId As Long) As Boolean
    Dim register    As cRegister
    Dim i           As Long
    Dim j           As Long
    
    For i = 1 To UBound(m_vCobzNC)
    
      If m_vCobzNC(i).cobz_id = CobzId Then
    
        For j = 1 To UBound(m_vCobzNC(i).vAplicaciones)
    
          With m_vCobzNC(i).vAplicaciones(j)
          
            If .Aplicado > 0 Or .fvcobz_id Then
        
              Set register = New cRegister
              register.fieldId = cscFvCobzTMPid
              register.Table = csTFacturaVentaCobranzaTMP
              register.id = csNew
            
              register.fields.Add2 cscCobzId, m_vCobzNC(i).cobz_id, csLong
              register.fields.Add2 cscCobzTMPId, id, csId
              
              register.fields.Add2 cscFvId, m_FvId, csId
              register.fields.Add2 cscFvdId, .fvd_id, csId
              register.fields.Add2 cscFvpId, .fvp_id, csId
              register.fields.Add2 cscFvCobzId, .fvcobz_id, csLong
              
              register.fields.Add2 cscFvCobzCotizacion, m_vCobzNC(i).Cotizacion, csDouble
              register.fields.Add2 cscFvCobzImporte, .Aplicado, csDouble
              register.fields.Add2 cscFvCobzImporteOrigen, DivideByCero(.Aplicado, m_vCobzNC(i).Cotizacion), csDouble
              
              register.fields.HaveLastUpdate = False
              register.fields.HaveWhoModify = False
              
              If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
            End If
          End With
        Next
      End If
    Next
    
    pSaveItems = True
  End Function
  
  Private Function pSaveCtaCte(ByVal id As Long, ByVal CobzId As Long, ByVal Aplic As Double) As Boolean
    Dim register    As cRegister
    Dim CtaCte      As T_CtaCte
    
    ' Obtengo las cuentas del tercero
    If Not pGetCuentasDeudor(CobzId, CtaCte, Aplic) Then Exit Function
    
    Set register = New cRegister
    register.fieldId = cscCobziTMPId
    register.Table = csTCobranzaItemTMP
    register.id = csNew
    
    register.fields.Add2 cscCueId, CtaCte.Cue_id, csId
    register.fields.Add2 cscCobziImporteOrigen, CtaCte.ImporteOrigen, csCurrency
    register.fields.Add2 cscCobziImporte, CtaCte.Importe, csCurrency
    
    register.fields.Add2 cscCobziOrden, 1, csInteger
    register.fields.Add2 cscCobziTipo, csECobranzaItemTipo.csECobziTCtaCte, csInteger
    register.fields.Add2 cscCobzTMPId, id, csId
    register.fields.Add2 cscCobziId, id, csLong
    register.fields.Add2 cscCobziOtroTipo, csECobranzaItemOtroTipo.csEOtroHaber, csInteger
    
    register.fields.HaveLastUpdate = False
    register.fields.HaveWhoModify = False
    
    If Not gDB.Save(register, , "pSaveCtaCte", C_Module, c_ErrorSave) Then Exit Function
    
    pSaveCtaCte = True
  End Function
  
Private Function pGetCuentasDeudor(ByVal CobzId As Long, ByRef CtaCte As T_CtaCte, ByVal Aplic As Double) As Boolean
    Dim CueIdFactura    As Long
    Dim Cotizacion      As Double
    
    If Not pGetCueIdFactura(CueIdFactura) Then Exit Function
    
    With CtaCte
      .Cue_id = CueIdFactura
      .Importe = Aplic
      
      If pGetMonIdForCueId(CueIdFactura) <> m_MonDefault Then
         If Not pGetCotizacionCobranza(CobzId, Cotizacion) Then Exit Function
        .ImporteOrigen = Aplic * Cotizacion
      End If
    End With
    
    pGetCuentasDeudor = True
End Function
  
  Private Function pGetMonIdForCueId(ByVal CueId As Long) As Long
    On Error GoTo ControlError
    
    Dim sqlstmt As String
    Dim rs      As ADODB.Recordset
    
    sqlstmt = "select mon_id from Cuenta where cue_id = " & CueId
  
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    
    If rs.EOF Then Exit Function
  
    pGetMonIdForCueId = gDB.ValField(rs.fields, cscMonId)
  
    GoTo ExitProc
ControlError:
    MngError Err, "pGetMonIdForCueId", C_Module, vbNullString
    If Err.Number Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Function
  
  Private Function pGetCotizacionCobranza(ByVal CobzId As Long, ByRef Cotizacion As Double) As Boolean
    On Error GoTo ControlError
    
    Dim sqlstmt As String
    Dim rs      As ADODB.Recordset
    
    sqlstmt = "select cobz_cotizacion from Cobranza where cobz_id = " & CobzId
  
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    
    If rs.EOF Then Exit Function
    
    Cotizacion = gDB.ValField(rs.fields, cscCobzCotizacion)
  
    pGetCotizacionCobranza = True
  
    GoTo ExitProc
ControlError:
    MngError Err, "pGetCotizacionCobranza", C_Module, vbNullString
    If Err.Number Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Function
  
  Private Function pGetCueIdFactura(ByRef CueIdFactura As Long) As Boolean
    On Error GoTo ControlError
    
    Dim sqlstmt As String
    Dim rs      As ADODB.Recordset
    
    sqlstmt = "sp_DocFacturaVentaGetCueDeudor " & m_FvId
  
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    
    If rs.EOF Then Exit Function
    
    CueIdFactura = gDB.ValField(rs.fields, cscCueId)
  
    pGetCueIdFactura = True
  
    GoTo ExitProc
ControlError:
    MngError Err, "pGetCueIdFactura", C_Module, vbNullString
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

  c_ErrorSave = LNGGetText(2220, vbNullString) 'Error al grabar la Factura de Venta
  
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  ReDim m_vCobzNC(0)
  ReDim m_vCobzNC(0).vAplicaciones(0)
  
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
  
  ReDim m_vCobzNC(0)
  ReDim m_vPedidoRemito(0)
  
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
