VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCobranzaWizard"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIWizardClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cCobranzaWizard
' 09-03-2004

'--------------------------------------------------------------------------------
' notas:

' Reemplazar

' Asistente de cobranzas         Ejemplo: Asistente para Nuevo Reporte

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cCobranzaWizard"

Private Const c_Cuotas = "Cuotas"

Private Const c_StepWelcome             As Integer = 1
Private Const c_StepSelectCliente       As Integer = 3
Private Const c_StepSelectFactura       As Integer = 4
Private Const c_StepAnticipo            As Integer = 5
Private Const c_StepDifCambio           As Integer = 6
Private Const c_StepSelectCobros        As Integer = 7
Private Const c_StepDatosGenerales      As Integer = 8

Private Const c_Wiz_Key_ResultTitle = "RESULTT"
Private Const c_Wiz_Key_Result = "RESULT"
Private Const c_Wiz_Key_Cliente = "CLIENT"
Private Const c_Wiz_Key_OnlySelected = "ONLYSEL" ' Edit From ListDoc

Private Const c_Wiz_Key_Doc = "DOC"
Private Const c_Wiz_Key_Vencidos = "VENCIDOS"
Private Const c_Wiz_Key_Agrupados = "AGRUPADOS"
Private Const c_Wiz_Key_Factuas = "FACTURAS"
Private Const c_Wiz_Key_Cotizacion = "COTIZACION"
Private Const c_Wiz_Key_Cotizacion2 = "COTIZACION2"
Private Const c_Wiz_Key_TotalPago = "TOTAL-PAGO"
Private Const c_Wiz_Key_TotalPagoOrigen = "TOTAL-PAGO-ORIGEN"
Private Const c_Wiz_Key_Anticipo = "ANTICIPO"
Private Const c_Wiz_Key_Todos = "TODOS"
Private Const c_Wiz_Key_Importe = "IMPORTE"
Private Const c_Wiz_Key_Pendiente = "PENDIENTE"
Private Const c_Wiz_Key_Moneda = "MONEDA"

Private Const c_Wiz_Key_MonedaAnticipo = "ANT-MONEDA"
Private Const c_Wiz_Key_CuentaAnticipo = "ANT-CUENTA"
Private Const c_Wiz_Key_CotizacionAnticipo = "ANT-COTIZACION"
Private Const c_Wiz_Key_AnticipoImporte = "ANT-IMPORTE"

Private Const c_Wiz_Key_CobroOtros = "COBRO-OTROS"
Private Const c_Wiz_Key_CobroTotal = "COBRO-TOTAL"
Private Const c_Wiz_Key_CobroNeto = "COBRO-NETO"
Private Const c_Wiz_Key_CobroIndicado = "COBRO-INDICADO"

Private Const c_Wiz_Key_Cheques = "CHEQUES"
Private Const c_Wiz_Key_Otros = "OTROS"
Private Const c_Wiz_Key_CtaCte = "CTACTE"
Private Const c_Wiz_Key_Efectivo = "EFVO"
Private Const c_Wiz_Key_Tarjetas = "TARJETA"

Private Const c_Wiz_Key_CueIdDifCambio = "Cuenta contable"
Private Const c_Wiz_Key_NCDifCambio = "Nota de credito"
Private Const c_Wiz_Key_NDDifCambio = "Nota de debito"
Private Const c_Wiz_Key_DefaultDifCambio = "Utilizar"
Private Const c_Wiz_Key_ModoIvaDifCambio = "Tratamiento del Iva"
Private Const c_Wiz_Key_PrIdDifCambio = "Articulo"
Private Const c_Wiz_Key_FechaNDNC = "FechaNDNC"
Private Const c_Wiz_Key_AplicacionND = "AplicND"

Private Const c_Wiz_Key_Fecha = "Fecha"
Private Const c_Wiz_Key_Cliente2 = "Cliente"
Private Const c_Wiz_Key_Sucursal = "Sucursal"
Private Const c_Wiz_Key_Observaciones = "Observaciones"
Private Const c_Wiz_Key_Comprobante = "Comprobante"
Private Const c_Wiz_Key_Cobrador = "Cobrador"
Private Const c_Wiz_Key_Legajo = "Legajo"
Private Const c_Wiz_Key_CentroCosto = "Centro de Costo"

Private Const c_LabelCobros = "LabelCobros"

Private Const KW_FACTURAS                    As Integer = 10
Private Const KW_COTIZACION                  As Integer = 20
Private Const KW_AGRUPADOS                   As Integer = 30
Private Const KW_VENCIDOS                    As Integer = 40
Private Const KW_CUE_ID_DIFCAMBIO            As Integer = 50
Private Const KW_DOC_ID_NC_DIFCAMBIO         As Integer = 60
Private Const KW_DOC_ID_ND_DIFCAMBIO         As Integer = 70
Private Const KW_PR_ID_DIFCAMBIO             As Integer = 80
Private Const KW_DEFALUT_DIFCAMBIO           As Integer = 90
Private Const KW_MODO_IVA_DIFCAMBIO          As Integer = 100
Private Const KW_APLICACION_DIFCAMBIO        As Integer = 101
Private Const KW_TODOS                       As Integer = 110
Private Const KW_CHEQUES                     As Integer = 120
Private Const KW_CTACTE                      As Integer = 130
Private Const KW_EFECTIVO                    As Integer = 140
Private Const KW_OTROS                       As Integer = 150
Private Const KW_TARJETAS                    As Integer = 160
Private Const KW_ANTICIPO                    As Integer = 170
Private Const KW_IMPORTE_OTROS               As Integer = 180
Private Const KW_IMPORTE_TOTAL               As Integer = 190
Private Const KW_IMPORTE_NETO                As Integer = 200
Private Const KW_IMPORTE_INDICADO            As Integer = 210
Private Const KW_CLIENTE2                    As Integer = 220
Private Const KW_FECHA                       As Integer = 230
Private Const KW_FECHA_NDNC                  As Integer = 235
Private Const KW_SUCURSAL                    As Integer = 240
Private Const KW_DESCRIP                     As Integer = 250
Private Const KW_COMPROBANTE                 As Integer = 260
Private Const KW_COBRADOR                    As Integer = 270
Private Const KW_LEGAJO                      As Integer = 280
Private Const KW_CENTROCOSTO                 As Integer = 290

Private Const KW_CUENTA_ANTICIPO             As Integer = 300
Private Const KW_MONEDA_ANTICIPO             As Integer = 310
Private Const KW_COTIZACION_ANTICIPO         As Integer = 320
Private Const KW_IMPORTE_ANTICIPO            As Integer = 330

Private Const KW_DOC_ID                      As Integer = 340

Private Const KI_IMPORTE                     As Integer = 1
Private Const KI_FV_ID                       As Integer = 2
Private Const KI_SELECT                      As Integer = 3
Private Const KI_FECHA                       As Integer = 4
Private Const KI_APLICAR                     As Integer = 5
Private Const KI_DESCRIP                     As Integer = 6
Private Const KI_DOC                         As Integer = 7
Private Const KI_PENDIENTE                   As Integer = 8
Private Const KI_VTO                         As Integer = 9
Private Const KI_TOTAL                       As Integer = 10
Private Const KI_COTIZACION                  As Integer = 11
Private Const KI_NRODOC                      As Integer = 12
Private Const KI_IMPORTEORIGEN               As Integer = 13
Private Const KI_MONEDA                      As Integer = 14
Private Const KI_COTIZACION2                 As Integer = 15
Private Const KI_FVD_ID                      As Integer = 16

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
Private Const KIO_FV_ID_RET                  As Integer = 12

Private Const KICH_CUE_ID                As Integer = 2
Private Const KICH_IMPORTE               As Integer = 3
Private Const KICH_IMPORTEORIGEN         As Integer = 4
Private Const KICH_BCO_ID                As Integer = 5
Private Const KICH_CHEQUE                As Integer = 6
Private Const KICH_MON_ID                As Integer = 7
Private Const KICH_FECHACOBRO            As Integer = 8
Private Const KICH_FECHAVTO              As Integer = 9
Private Const KICH_CLE_ID                As Integer = 10
Private Const KICH_DESCRIP               As Integer = 11
Private Const KICH_PROPIO                As Integer = 12

Private Const KIE_CUE_ID                 As Integer = 2
Private Const KIE_MON_ID                 As Integer = 3
Private Const KIE_IMPORTE                As Integer = 4
Private Const KIE_IMPORTEORIGEN          As Integer = 5
Private Const KIE_DESCRIP                As Integer = 6

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
Private Const KIT_TJCCU_ID                As Integer = 14

Private Const KICC_CUE_ID                 As Integer = 2
Private Const KICC_IMPORTE                As Integer = 3
Private Const KICC_IMPORTEORIGEN          As Integer = 4

Private Const c_WizardTitle = "Asistente de cobranzas"

' estructuras
Private Type T_Iva
  importe         As Double
  porcentaje      As Double
End Type
Private Type T_Item
  importe         As Double
  ImporteIva      As Double
  TasaIva         As Double
End Type

' pseudo-constantes
Private c_ErrorSave As String
Private c_NCNDDescripDifCambio As String
Private c_LabelCobrosText As String

' variables privadas
Private m_ObjWizard               As cIWizardGeneric
Private m_WizardProcessing        As Boolean
Private m_WizardCancel            As Boolean

'Private m_Resource                As fResource

Private m_bDifCambio              As Boolean

Private m_TesoreriaConfig   As cTesoreriaConfig
Private m_GeneralConfig     As cGeneralConfig

Private m_MonDefault        As Long

Private m_Id                As Long

Private m_iOrden            As Long

Private m_Cli_id            As Long
Private m_Cliente           As String

' Current Document
'
Private m_Cli_idDoc         As Long
Private m_ClienteDoc        As String

Private m_FvIds()           As Long

Private m_CliIds()          As Long
Private m_FvIdsxCliId()     As Long
Private m_CobranzaInfo      As cCobranzaInfo
Private m_isHojaRuta        As Boolean
Private m_cj_id             As Long

Private m_lColCuotas        As Long

Private m_ObjClient         As Object

Private m_LastDoc           As Long
Private m_LastCli           As Long

' PrintDoc
'
Private m_LastNroDoc        As String


' Multiples cobranzas
'
Private m_NextCliIdIndex    As Long
Private m_bUseCliIds        As Boolean

' Autorun
Private m_bAutoSelect       As Boolean
Private m_bWizWasClosed     As Boolean

' Me permite tener un semi-automatico
'
Private m_bVirtualNextStopInPagos   As Boolean
Private m_bRestarVirtualPush        As Boolean

' eventos
' propiedades publicas
Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Let cli_id(ByVal rhs As Long)
  m_Cli_id = rhs
End Property

Public Property Let Cliente(ByVal rhs As String)
  m_Cliente = rhs
End Property

Public Property Let FvIds(ByRef rhs() As Long)
  On Error Resume Next
  Dim i As Long
  ReDim m_FvIds(UBound(rhs))
  For i = 0 To UBound(rhs)
    m_FvIds(i) = rhs(i)
  Next
End Property

Public Property Let CliIds(ByRef rhs() As Long)
  On Error Resume Next
  Dim i As Long
  ReDim m_CliIds(UBound(rhs))
  For i = 0 To UBound(rhs)
    m_CliIds(i) = rhs(i)
  Next
End Property

Public Property Let FvIdsxCliId(ByRef rhs() As Long)
  On Error Resume Next
  Dim i As Long
  Dim j As Long
  
  ReDim m_FvIdsxCliId(UBound(rhs, 1), UBound(rhs, 2))
  
  For i = 0 To UBound(rhs, 1)
  
    For j = 0 To UBound(rhs, 2)
      m_FvIdsxCliId(i, j) = rhs(i, j)
    Next
  Next
End Property

Public Property Set ObjClient(ByVal rhs As Object)
  Set m_ObjClient = rhs
End Property

Public Property Set CobranzaInfo(ByVal rhs As cCobranzaInfo)
  Set m_CobranzaInfo = rhs
End Property

Public Property Let isHojaRuta(ByVal rhs As Boolean)
  ' Solo aceptamos true pues si el que llama no esta
  ' prendiendo el flag, el valor sale de configuracion
  ' general de tesoreria
  '
  If rhs Then
    m_isHojaRuta = rhs
  End If
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Load() As Boolean
  On Error GoTo ControlError

  If m_isHojaRuta Then
  
    If Not pLoadCajaForUsuario() Then Exit Function

  End If
  
  Load = True

  GoTo ExitProc
ControlError:
  MngError Err, C_LoadFunction, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  
  MessageEx = True
  
  Select Case MessageID
    
    Case MSG_GRID_ROW_DELETED
      
      Select Case Info
        Case KW_CHEQUES, KW_EFECTIVO, KW_TARJETAS
          pShowCobroNeto
        Case KW_OTROS
          pShowCobroOtro
      End Select
      pShowCobroTotal
    
  End Select

End Function

' Implementacion de cIABMClientGrid
Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case KW_FACTURAS
      cIABMClientGrid_IsEmptyRow = False
    Case KW_CHEQUES
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowCheques(Row, RowIndex)
    Case KW_TARJETAS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowTarjetas(Row, RowIndex)
    Case KW_OTROS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowOtros(Row, RowIndex)
    Case KW_EFECTIVO
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
    Case KW_FACTURAS
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateFactura(pGetFacturasProperty(), lRow, lCol)
    Case KW_CHEQUES
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateCheque(pGetChequesProperty(), lRow, lCol)
    Case KW_TARJETAS
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateTarjeta(pGetTarjetasProperty(), lRow, lCol)
    Case KW_OTROS
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateOtro(pGetOtrosProperty(), lRow, lCol)
    Case KW_EFECTIVO
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateEfectivo(pGetEfectivoProperty(), lRow, lCol)
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
    Case KW_FACTURAS
      cIABMClientGrid_ColumnAfterEdit = True
    Case KW_CHEQUES
      cIABMClientGrid_ColumnAfterEdit = True
    Case KW_TARJETAS
      cIABMClientGrid_ColumnAfterEdit = True
    Case KW_OTROS
      cIABMClientGrid_ColumnAfterEdit = True
    Case KW_EFECTIVO
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
    Case KW_FACTURAS
      cIABMClientGrid_ColumnBeforeEdit = pColBEditFacturas(pGetFacturasProperty(), lRow, lCol, iKeyAscii)
    Case KW_CHEQUES
      cIABMClientGrid_ColumnBeforeEdit = True
    Case KW_TARJETAS
      cIABMClientGrid_ColumnBeforeEdit = pColBeforeEditTarjeta(Key, lRow, lCol, iKeyAscii)
    Case KW_OTROS
      cIABMClientGrid_ColumnBeforeEdit = True
    Case KW_EFECTIVO
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
  Dim Row       As cIABMGridRow
  Dim IProperty As cIABMProperty
  Dim WizObj    As cWizardGeneric
  
  Set WizObj = m_ObjWizard
  Set IProperty = WizObj.ObjAbm.Properties(c_Wiz_Key_Tarjetas)
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KIT_TJCCU_ID
        Set Row = .Rows(lRow)
        SetFilterCuotas Row, IProperty, WizObj.ObjAbm, KIT_TJC_ID
    End Select
  End With
  pColBeforeEditTarjeta = True
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
    
    Case KW_FACTURAS
      
      With pGetFacturas().Rows
        ShowDocAux pCell(.Item(lRow), KI_FV_ID).Id, _
                   "CSVenta2.cFacturaVenta", _
                   "CSABMInterface2.cABMGeneric"
      End With

  End Select

  Exit Sub
ControlError:
  MngError Err, "cIABMClientGrid_DblClick", C_Module, vbNullString
End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Select Case Key
    Case KW_FACTURAS
    Case Else
      cIABMClientGrid_DeleteRow = True
  End Select
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case KW_FACTURAS
      cIABMClientGrid_ValidateRow = True
    Case KW_CHEQUES
      cIABMClientGrid_ValidateRow = pValidateRowCheques(Row, RowIndex)
    Case KW_TARJETAS
      cIABMClientGrid_ValidateRow = pValidateRowTarjetas(Row, RowIndex)
    Case KW_OTROS
      cIABMClientGrid_ValidateRow = pValidateRowOtros(Row, RowIndex)
    Case KW_EFECTIVO
      cIABMClientGrid_ValidateRow = pValidateRowEfectivo(Row, RowIndex)
    Case KW_CTACTE
      cIABMClientGrid_ValidateRow = True
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pColBEditFacturas(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
  Select Case pGetKeyFromCol(IProperty.Grid.Columns, lCol)
    ' Facturas
    Case KI_APLICAR, KI_SELECT, KI_COTIZACION2
    Case Else
      Exit Function
  End Select
  
  pColBEditFacturas = True
End Function

Private Function pCol(ByRef Columns As cIABMGridColumns, ByVal Key As Long) As cIABMGridColumn
  Dim Col    As cIABMGridColumn
  For Each Col In Columns
    If Col.Key = Key Then
      Set pCol = Col
    End If
  Next
End Function

Private Function pColAUpdateFactura(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  Dim Row      As cIABMGridRow
  Dim MaxVal   As Double
  Dim bVisible As Boolean
  
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KI_SELECT
        Set Row = .Rows(lRow)
        pSelectFactura Row, .Columns
        pShowTotalFacturas
      Case KI_COTIZACION2
        Dim Cotiz  As Double
        Set Row = .Rows(lRow)
        Cotiz = Val(pCell(Row, KI_COTIZACION2).Value)
        If pCol(.Columns, KI_IMPORTE).Visible Then
          With pCell(Row, KI_IMPORTE)
            .Value = pCell(Row, KI_IMPORTEORIGEN).Value * Cotiz
          End With
        Else
          With pCell(Row, KI_PENDIENTE)
            .Value = pCell(Row, KI_IMPORTEORIGEN).Value * Cotiz
          End With
        End If
      Case KI_APLICAR
        Set Row = .Rows(lRow)
        bVisible = pCol(.Columns, KI_IMPORTE).Visible
        With pCell(Row, KI_APLICAR)
          If bVisible Then
            MaxVal = Val(pCell(Row, KI_IMPORTE).Value)
            If Val(.Value) > MaxVal Then
              .Value = MaxVal
            ElseIf Val(.Value) < 0 Then
              .Value = 0
            End If
          Else
            MaxVal = Val(pCell(Row, KI_PENDIENTE).Value)
            If Val(.Value) > MaxVal Then
              .Value = MaxVal
            ElseIf Val(.Value) < 0 Then
              .Value = 0
            End If
          End If
        End With
        pShowTotalFacturas
    End Select
  End With
  
  pColAUpdateFactura = True
End Function

Private Function pColAUpdateCheque(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  Dim Row      As cIABMGridRow
  Dim Value    As Double
  
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KICH_IMPORTEORIGEN
        Set Row = .Rows(lRow)
        With pCell(Row, KICH_MON_ID)
          If .Id <> m_MonDefault Or .Id = 0 Then
            pCell(Row, KICH_IMPORTE).Value = Val(pCell(Row, KICH_IMPORTEORIGEN).Value) _
                                           * Val(pGetCotizacion().Value)
          Else
            pCell(Row, KICH_IMPORTEORIGEN).Value = 0
          End If
        End With
      Case KICH_IMPORTE
      
      Case KICH_CUE_ID
        Dim MonId   As Long
        Dim Moneda  As String
        Set Row = .Rows(lRow)
        GetMonedaFromCuenta MonId, Moneda, pCell(Row, KICH_CUE_ID).Id
        With pCell(Row, KICH_MON_ID)
          .Value = Moneda
          .Id = MonId
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
      
      Case KICH_FECHACOBRO
        Set Row = .Rows(lRow)
        With pCell(Row, KICH_FECHACOBRO)
          If IsDate(.Value) Then
            pCell(Row, KICH_FECHAVTO).Value = DateAdd("m", 1, .Value)
          End If
        End With
      
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
  
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KIT_IMPORTEORIGEN
        Set Row = .Rows(lRow)
        pCell(Row, KIT_IMPORTE).Value = Val(pCell(Row, KIT_IMPORTEORIGEN).Value) _
                                      * Val(pGetCotizacion().Value)
      Case KIT_IMPORTE
      
      Case KIT_TJC_ID
        Dim TjcId  As Long
        Dim WizObj As cWizardGeneric
        Dim AbmObj As cABMGeneric
        
        Set WizObj = m_ObjWizard
        Set AbmObj = WizObj.ObjAbm
        Set Row = .Rows(lRow)
        
        TjcId = pCell(Row, KIT_TJC_ID).Id
        'IProperty.Grid.Columns(c_Cuotas).HelpFilter = "tjc_id = " & TjcId
        'AbmObj.RefreshColumnProperties IProperty, c_Cuotas
        SetFilterCuotas Row, IProperty, AbmObj, KIT_TJC_ID
        
        With pCell(Row, KIT_TJCCU_ID)
          If Not ValidateCuota(TjcId, .Id) Then
            .Id = csNO_ID
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

Private Function pColAUpdateEfectivo(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  Dim Row      As cIABMGridRow
  Dim Value    As Double
  
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KIE_IMPORTEORIGEN
        Set Row = .Rows(lRow)
        With pCell(Row, KIE_MON_ID)
          If .Id <> m_MonDefault Or .Id = 0 Then
            pCell(Row, KIE_IMPORTE).Value = Val(pCell(Row, KIE_IMPORTEORIGEN).Value) _
                                          * Val(pGetCotizacion().Value)
          Else
            pCell(Row, KIE_IMPORTEORIGEN).Value = 0
          End If
        End With
      Case KIE_IMPORTE
        
      Case KIE_CUE_ID
        Dim MonId   As Long
        Dim Moneda  As String
        Set Row = .Rows(lRow)
        GetMonedaFromCuenta MonId, Moneda, pCell(Row, KIE_CUE_ID).Id
        With pCell(Row, KIE_MON_ID)
          .Value = Moneda
          .Id = MonId
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

Private Sub pSelectAllFactura(ByVal bSelect As Boolean)
  Dim Row As cIABMGridRow
  
  With pGetFacturas
    For Each Row In .Rows
      pCell(Row, KI_SELECT).Id = CInt(bSelect)
      pSelectFactura Row, .Columns
    Next
  End With
  
#If PREPROC_SFS Then
  Dim ObjWizard As cWizardGeneric
#Else
  Dim ObjWizard As cWizardGenericDocEx
#End If

  Set ObjWizard = m_ObjWizard
  ObjWizard.ShowValue pGetFacturasProperty, True
End Sub

Private Sub pRefreshCotizacion(ByVal TakeFromCotizCtrl As Boolean)
  Dim Row As cIABMGridRow
  Dim Cotiz As Double
  
  Cotiz = pGetCotizacion().Value
  
  With pGetFacturas
    For Each Row In .Rows
      If Val(pCell(Row, KI_IMPORTEORIGEN).Value) Then
      
        If TakeFromCotizCtrl Then
          pCell(Row, KI_COTIZACION2).Value = Cotiz
        Else
          Cotiz = Val(pCell(Row, KI_COTIZACION2).Value)
        End If
      
        If pCol(.Columns, KI_IMPORTE).Visible Then
          With pCell(Row, KI_IMPORTE)
            .Value = pCell(Row, KI_IMPORTEORIGEN).Value * Cotiz
          End With
        Else
          With pCell(Row, KI_PENDIENTE)
            .Value = pCell(Row, KI_IMPORTEORIGEN).Value * Cotiz
          End With
        End If
        pSelectFactura Row, .Columns
      End If
    Next
  End With
  
  m_ObjWizard.ShowValue pGetFacturasProperty
End Sub

Private Sub pSelectFactura(ByRef Row As cIABMGridRow, ByRef Columns As cIABMGridColumns)
  Dim bVisible As Boolean
  bVisible = pCol(Columns, KI_IMPORTE).Visible
  With pCell(Row, KI_APLICAR)
    If pCell(Row, KI_SELECT).Id Then
      If Val(.Value) = 0 Then
        If bVisible Then
          .Value = pCell(Row, KI_IMPORTE).Value
        Else
          .Value = pCell(Row, KI_PENDIENTE).Value
        End If
      End If
    Else
      .Value = 0
    End If
  End With
End Sub

Private Sub pValidateAnticipo()
  If Val(pGetAnticipo.Value) < 0 Then
    pGetAnticipo.Value = 0
  End If
  m_ObjWizard.ShowValue pGetAnticipo
End Sub

Private Sub pShowCobroNeto()
  Dim Row           As cIABMGridRow
  Dim Total         As Double
  
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
  m_ObjWizard.ShowValue pGetCobroNeto
End Sub

Private Sub pShowCobroOtro()
  Dim Row           As cIABMGridRow
  Dim Total         As Double
  
  For Each Row In pGetOtros().Rows
    Total = Total + Val(pCell(Row, KIO_DEBE).Value) - Val(pCell(Row, KIO_HABER).Value)
  Next
  
  pGetCobroOtros().Value = Total
  m_ObjWizard.ShowValue pGetCobroOtros
End Sub

Private Sub pShowCobroTotal()
  pGetCobroTotal.Value = Val(pGetCobroNeto().Value) + Val(pGetCobroOtros().Value)
  m_ObjWizard.ShowValue pGetCobroTotal
End Sub

Private Sub pShowAnticipo()
  pGetAnticipoImporte().Value = Val(pGetAnticipo().Value)
  m_ObjWizard.ShowValue pGetAnticipoImporte
End Sub

Private Sub pShowMonedaAnticipo(ByVal bShow As Boolean)
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim cue_id  As Long
  Dim Mon_id      As Long
  Dim mon_nombre  As String
  
  cue_id = pGetCuentaAnticipo().HelpId
  If cue_id <> csNO_ID Then
    sqlstmt = "select moneda.mon_id, mon_nombre from cuenta inner join moneda on cuenta.mon_id = moneda.mon_id where cue_id = " & cue_id
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
    If Not rs.EOF Then
      Mon_id = rs.Fields(0).Value
      mon_nombre = rs.Fields(1).Value
    End If
  End If
  
  With pGetMonedaAnticipo
    .HelpId = Mon_id
    .Value = mon_nombre
  End With
  
  If bShow Then
    m_ObjWizard.ShowValue pGetMonedaAnticipo
  End If
  
  With pGetCotizacionAnticipo()
    If Mon_id <> m_MonDefault Then
      Dim Moneda As cMoneda
      Set Moneda = New cMoneda
      .Enabled = True
      .Value = Moneda.GetCotizacion(Mon_id, Date)
    Else
      .Value = 1
      .Enabled = False
    End If
  End With
  
  If bShow Then
    m_ObjWizard.ShowValue pGetCotizacionAnticipo
  End If
End Sub

Private Sub pShowTotalFacturas()
  Dim Row           As cIABMGridRow
  Dim Total         As Double
  Dim TotalOrigen   As Double
  
  For Each Row In pGetFacturas().Rows
    Total = Total + Val(pCell(Row, KI_APLICAR).Value)
    If Val(pCell(Row, KI_IMPORTEORIGEN).Value) <> 0 Then
      TotalOrigen = TotalOrigen + Val(pCell(Row, KI_APLICAR).Value)
    End If
  Next
  
  pGetTotal().Value = Total + Val(pGetAnticipo.Value)
  pGetTotalOrigen().Value = DivideByCero(TotalOrigen, Val(pGetCotizacion().Value))
  
  m_ObjWizard.ShowValue pGetTotal
  m_ObjWizard.ShowValue pGetTotalOrigen
End Sub

' Proposito: Obtiene la deuda en moneda extranjera a la cotizacion original de la operacion
Private Function pGetDeudaOrigen() As Double
  Dim Row             As cIABMGridRow
  Dim Total           As Double
  Dim DecimalesCotiz  As Double
  
  DecimalesCotiz = m_GeneralConfig.DecimalesCotizacion
  
  For Each Row In pGetFacturas().Rows
    Total = Total + DivideByCero(Val(pCell(Row, KI_APLICAR).Value), _
                                 Round(Val(pCell(Row, KI_COTIZACION2).Value), _
                                       DecimalesCotiz) _
                                ) * Val(pCell(Row, KI_COTIZACION).Value)
  Next
  
  pGetDeudaOrigen = Total
End Function

' Obtiene los pesos cobrados por operaciones en moneda extranjera a la cotizacion de la cobranza
Private Function pGetCobrado() As Double
  Dim Row           As cIABMGridRow
  Dim Total         As Double
  
  For Each Row In pGetFacturas().Rows
    
    ' Solo si es moneda extranjera
    '
    If Val(pCell(Row, KI_COTIZACION).Value) Then
      Total = Total + Val(pCell(Row, KI_APLICAR).Value)
    End If
  Next
  
  pGetCobrado = Total
End Function

' Implementacion de cIWizardClient
Private Property Get cIWizardClient_Aplication() As String
  cIWizardClient_Aplication = gAppName
End Property

Private Function cIWizardClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Function cIWizardClient_Load() As Boolean
  On Error GoTo ControlError
  
  Dim WizObj As cWizardGeneric
  Set WizObj = m_ObjWizard
  ' Autorun
  m_bAutoSelect = WizObj.PushVirtualNext
  
#If Not PREPROC_SFS Then
  pSetObjectForm
#End If

  m_ObjWizard.EditGeneric.HideTitle = True
  cIWizardClient_Load = LoadSteps()

  Exit Function
ControlError:
  MngError Err, "cIWizardClient_Load", C_Module, vbNullString
End Function

Private Property Set cIWizardClient_ObjWizard(rhs As CSInterfacesABM.cIWizardGeneric)
  Set m_ObjWizard = rhs

  If Not rhs Is Nothing Then
    Dim ObjWiz As cWizardGeneric
    Set ObjWiz = rhs
    Set ObjWiz.ObjClientObj = Me
  End If
End Property

Private Property Get cIWizardClient_ObjWizard() As CSInterfacesABM.cIWizardGeneric
   Set cIWizardClient_ObjWizard = m_ObjWizard
End Property

Private Function cIWizardClient_Work(ByVal CurrentStep As Integer, ByVal GoingToNext As Boolean) As Boolean
  On Error GoTo ControlError

  Select Case CurrentStep
    Case -1
    
    Case c_StepWelcome
      ' First step, Disable back
      m_ObjWizard.cmdBack.Enabled = False
    
    Case c_StepSelectCobros
      If GoingToNext Then
        If Not pGetCuentasDeudor() Then Exit Function
        pSetFilterColFactura
        pRefreshLabelPagos
      End If
      
    Case c_StepDatosGenerales
      pSetDatosGenerales
      
  End Select

  cIWizardClient_Work = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIWizardClient_Work", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIWizardClient_NextStep(ByVal nCurrentStep As Integer, nNextStep As Integer) As Boolean
  On Error GoTo ControlError

  Select Case nCurrentStep

    ' Este paso es el primero que se recibe
    ' su proposito es darle una oportunidad al cliente del wizard
    ' de indicar cual es el primer paso
    Case -1
      nNextStep = c_StepWelcome
      m_ObjWizard.cmdBack.Enabled = False
      
    Case c_StepWelcome
      nNextStep = c_StepSelectCliente
      m_ObjWizard.cmdNext.Caption = c_WizStr_Next
      m_ObjWizard.cmdBack.Enabled = False
      
      ' Cada vez que paso por aca activo este flag
      ' para detenerme en pagos sin mostrar un cartel
      '
      m_bVirtualNextStopInPagos = True
      m_bRestarVirtualPush = False
      
    Case c_StepSelectCliente
    
      If pGetDoc() = csNO_ID Then
        MsgWarning LNGGetText(1562, vbNullString), LNGGetText(2128, vbNullString)  'Cobranzas
                    'Debe indicar un documento
        nNextStep = c_StepSelectCliente
      ElseIf pGetCliente() = csNO_ID Then
        MsgWarning LNGGetText(1563, vbNullString), LNGGetText(2128, vbNullString)  'Cobranzas
                    'Debe indicar un cliente
        nNextStep = c_StepSelectCliente
      ElseIf Not pLoadFacturasXCliente() Then
        MsgWarning LNGGetText(2129, vbNullString), LNGGetText(2128, vbNullString)  'Cobranzas
                    'No se pudieron cargar las facturas para este cliente
        nNextStep = c_StepSelectCliente
      Else
        pGetTodos.Name = c_selectall
        m_ObjWizard.ShowValue pGetTodos
        m_ObjWizard.cmdBack.Enabled = True
        nNextStep = c_StepSelectFactura
      End If
      
    Case c_StepSelectFactura
      If pChecFacturas() Then
        pShowAnticipo
        nNextStep = c_StepAnticipo
      Else
        nNextStep = c_StepSelectFactura
      End If
    
    Case c_StepAnticipo
      If pCheckAnticipo() Then
        If m_bDifCambio Then
          nNextStep = c_StepDifCambio
        Else
        
          pLoadVirtualNextCobros
        
          nNextStep = c_StepSelectCobros
        End If
      Else
        nNextStep = c_StepAnticipo
      End If
    
    Case c_StepDifCambio
        
      pLoadVirtualNextCobros
    
      nNextStep = c_StepSelectCobros
      
    Case c_StepSelectCobros
      If Not pValidateCobro() Then
        nNextStep = c_StepSelectCobros
      Else
        
        m_ObjWizard.cmdBack.Enabled = True
        m_ObjWizard.cmdNext.Caption = c_WizStr_Finish
        
        nNextStep = c_StepDatosGenerales
        
        If m_bAutoSelect Then
        
          Dim WizObj As cWizardGeneric
          Set WizObj = m_ObjWizard
          
          If m_bRestarVirtualPush Then
          
            WizObj.RestartVirtualPush = True
            
          End If
        End If
      End If
    
    Case c_StepDatosGenerales

      If pValidateDatosGenerales() Then

        If pSave() Then
          
          ' Si esta en automatico no pasamos por la impresion,
          ' vamos directamente a crear un nuevo documento
          '
          If m_bAutoSelect Then
          
            cIWizardClient_PropertyChange KW_NEW_DOC
            nNextStep = c_StepWelcome
          
          Else
          
            ' PrintDoc
            '
            WizShowNewStep m_ObjWizard, c_StepWelcome, m_LastNroDoc
            nNextStep = c_StepWelcome
            
          End If
          
        Else
          nNextStep = c_StepDatosGenerales
        End If
      Else
        nNextStep = c_StepDatosGenerales
      End If
  End Select

  cIWizardClient_NextStep = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIWizardClient_NextStep", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIWizardClient_PreviousStep(ByVal nCurrentStep As Integer, nNextStep As Integer) As Boolean
  Select Case nCurrentStep
    Case c_StepWelcome
      nNextStep = c_StepWelcome

    Case c_StepSelectCliente
      nNextStep = c_StepSelectCliente
    
    Case c_StepSelectFactura
      m_ObjWizard.cmdBack.Enabled = False
      nNextStep = c_StepSelectCliente
    
    Case c_StepAnticipo
      nNextStep = c_StepSelectFactura
    
    Case c_StepDifCambio
      nNextStep = c_StepAnticipo
    
    Case c_StepSelectCobros
      If m_bDifCambio Then
        nNextStep = c_StepDifCambio
      Else
        nNextStep = c_StepAnticipo
      End If
    
    Case c_StepDatosGenerales
      m_ObjWizard.cmdNext.Caption = c_WizStr_Next
      nNextStep = c_StepSelectCobros
  End Select

  cIWizardClient_PreviousStep = True
End Function

Private Function cIWizardClient_PropertyChange(ByVal Key As Integer) As Boolean
  Select Case Key
    Case KW_CANCEL
      If m_WizardProcessing Then
        m_WizardCancel = True
      Else
        cIWizardClient_PropertyChange = True
      End If
    
    Case KW_CLOSE_WIZARD
      ' Finish, now close wizard
      m_ObjWizard.CloseWizard
      
    ' PrintDoc
    '
    Case KW_PRINT_DOC
      WizPrintDocEx m_Id, _
                    m_LastDoc, _
                    GetEmailFromCliente(m_LastCli)
    
    Case KW_NEW_DOC
      pSetMultyCliente
      
      ' Si el wizard se cerro no hay mas nada que hacer
      '
      If Not m_bWizWasClosed Then
      
        pNewEmptyProperties
        WizNewDoc m_ObjWizard, c_StepWelcome
        
      End If

    Case KW_VENCIDOS, KW_AGRUPADOS
      pLoadFacturasXCliente
    Case KW_COTIZACION
      pRefreshCotizacion True
      pShowTotalFacturas
    Case KW_ANTICIPO
      pValidateAnticipo
      pShowTotalFacturas
    Case KW_TODOS
      If pGetTodos.Name = c_selectall Then
        pSelectAllFactura True
        pGetTodos.Name = c_unselectall
      Else
        pSelectAllFactura False
        pGetTodos.Name = c_selectall
      End If
      m_ObjWizard.ShowValue pGetTodos
      pShowTotalFacturas
    Case KW_CUENTA_ANTICIPO
      pShowMonedaAnticipo True
    
    Case KW_DOC_ID
      m_LastDoc = pGetDoc()

  End Select
End Function

Private Function cIWizardClient_Terminate() As Boolean
  cIWizardClient_Terminate = True
  'Unload m_Resource
  'Set m_Resource = Nothing

  ' Puede fallar y no importa
  ' ya que no conozco si el
  ' objecto Proveedor soporta
  ' la interfaz
  On Error Resume Next
  
  m_ObjClient.SetWizardCompleteSuccess m_Id <> csNO_ID
  
  ' Autorun
  If m_bAutoSelect Then
    m_ObjClient.TerminateWizard csNO_ID
  Else
    m_ObjClient.TerminateWizard m_Id
  End If

End Function

Private Property Get cIWizardClient_Title() As String
  cIWizardClient_Title = c_WizardTitle
End Property

' funciones friend
' funciones privadas
Private Function LoadSteps() As Boolean
  
  'If m_Resource Is Nothing Then Set m_Resource = New fResource

#If PREPROC_SFS Then
  Dim Wizard As cWizardGeneric
  Dim AbmObj As cABMGeneric

  Dim sh As Shape
  Set sh = m_ObjWizard.EditGeneric.ShapeMain

  sh.Move 0, 0, 9000, 7000
  sh.BorderStyle = 0
  sh.BackColor = vbWhite

  Dim Img As Image
  Set Img = m_ObjWizard.EditGeneric.PicMain

  Img.Visible = False

#Else
  Dim Wizard As cWizardGenericDocEx
  Dim AbmObj As cABMGenericDocEx
#End If
  
  Set Wizard = m_ObjWizard
  Set AbmObj = Wizard.ObjAbm
  AbmObj.MinHeight = 7000
  
  m_LastDoc = m_TesoreriaConfig.DocIdCobranza
  
  pSetMultyDoc
  
  pLoadStepWelcome
  pLoadStepSelectCliente
  pLoadStepSelectFactura
  pLoadStepAnticipo
  pLoadStepDifCambio
  pLoadStepSelectCobros
  pLoadStepDatosGenerales

  LoadSteps = True
End Function

Private Sub pSetMultyDoc()
  If UBound(m_CliIds) > 0 Then
  
    m_NextCliIdIndex = 1
    m_bUseCliIds = True
  Else
    m_NextCliIdIndex = 0
  End If
End Sub

Private Sub pSetMultyCliente()
  
  If m_NextCliIdIndex Then
  
    m_Cli_idDoc = m_CliIds(m_NextCliIdIndex)
    m_ClienteDoc = pGetCliNombre(m_Cli_idDoc)
  
    m_NextCliIdIndex = m_NextCliIdIndex + 1
        
    ' Termine
    '
    If m_NextCliIdIndex > UBound(m_CliIds) Then
    
      m_NextCliIdIndex = 0
      
    End If
    
  Else
      
    If m_bAutoSelect Then
    
      Dim WizObj As cWizardGeneric
      Set WizObj = m_ObjWizard

      If WizObj.CloseWizardAfterSave Then
    
        m_ObjWizard.CloseWizard
    
        m_bWizWasClosed = True
        
      End If
      
    End If
    
    If Not m_bWizWasClosed Then
  
      m_bUseCliIds = False
      m_ClienteDoc = m_Cliente
      m_Cli_idDoc = m_Cli_id
    
    End If
    
  End If
End Sub

Private Function pGetCliNombre(ByVal cli_id As Long) As String
  Dim rtn As String
  If Not gDB.GetData(csTCliente, cscCliId, cli_id, cscCliNombre, rtn) Then Exit Function
  pGetCliNombre = rtn
End Function

Private Sub pLoadStepWelcome()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepWelcome))
    With .Properties.Add(Nothing)
      '.Name = vbNullString
      .Top = 0
      .Left = 0
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 1
      'Set .Picture = m_Resource.ImgWiz1.Picture
    End With

    With .Properties.Add(Nothing, c_Wiz_Key_Title)
      '.Name = vbNullString
      .Top = 100
      .Left = 2700
      .TopNotChange = True
      .LeftNotChange = True
      .Height = 880
      .Width = 7000
      .PropertyType = cspTitle
      .Value = LNGGetText(2130, vbNullString) 'Bienvenido al Asistente de Cobranza
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_MainTitle)
      .Top = 1200
      .Left = 3000
      '.Name = vbNullString
      .PropertyType = cspLabel
      .Width = 6000
      .Height = 880
      .FontBold = True
      .Value = LNGGetText(2131, vbNullString)
              'Con este Asistente usted podra generar los Recibos por Cobranzas.
    End With
  
    WizAddNewDocProperties m_ObjWizard, c_StepWelcome

  End With
End Sub

Private Sub pLoadStepSelectCliente()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepSelectCliente)).Properties
    With .Add(Nothing)
      '.Name = vbNullString
      .Top = 100
      .Left = 100
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 3
      'Set .Picture = m_Resource.ImgWiz3.Picture
    End With

    With .Add(Nothing)
      '.Name = vbNullString
      .Top = 400
      .Left = 1500
      .TopNotChange = True
      .LeftNotChange = True
      .Height = 880
      .Width = 8000
      .PropertyType = cspLabel
      .FontBold = True
      .Value = LNGGetText(2132, vbNullString)
                'Indique el documento a utilizar y el Cliente al que se le emitirá el Recibo
    End With
    
    With .Add(Nothing, c_Wiz_Key_Doc)
      .Top = 1500
      .Left = 3700
      .Name = LNGGetText(1567, vbNullString)    'Documento
      .PropertyType = cspHelp
      .HelpFilter = "'doct_id = " & csEDT_Cobranza & "'"
      .Table = CSDocumento2.CSDocumento
      .Width = 4000
      .Value = m_TesoreriaConfig.DocCobranza
      .HelpId = m_TesoreriaConfig.DocIdCobranza
      .Key = KW_DOC_ID
    End With
  
    pSetMultyCliente
  
    With .Add(Nothing, c_Wiz_Key_Cliente)
      .Top = 2000
      .Left = 3700
      .Name = LNGGetText(1150, vbNullString)    'Cliente
      .PropertyType = cspHelp
      .Table = csCliente
      .Width = 4000
      .Value = m_ClienteDoc
      .HelpId = m_Cli_idDoc
    End With
  
    ' Edit From ListDoc
    '
    With .Add(Nothing, c_Wiz_Key_OnlySelected)
      .PropertyType = cspCheck
      .Name = LNGGetText(2133, vbNullString)    'Cargar sólo Facturas seleccionadas
      .Value = UBound(m_FvIds)
      .Left = 5310
      .LeftLabel = -2800
    End With
  End With
End Sub

Private Sub pLoadStepSelectFactura()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepSelectFactura))
    With .Properties.Add(Nothing)
      '.Name = vbNullString
      .Top = 100
      .Left = 100
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 3
      'Set .Picture = m_Resource.ImgWiz3.Picture
    End With

    With .Properties.Add(Nothing)
      '.Name = vbNullString
      .Top = 400
      .Left = 1500
      .TopNotChange = True
      .LeftNotChange = True
      .Height = 880
      .Width = 8000
      .PropertyType = cspLabel
      .FontBold = True
      .Value = LNGGetText(2134, vbNullString)
              'Seleccione las Facturas he indique los importes que cancelará en cada una de ellas
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_Agrupados)
      .Name = LNGGetText(2135, vbNullString)    'Agrupar
      .Top = 100
      .Left = 11400
      .LeftLabel = -700
      .Width = 370
      .PropertyType = cspCheck
      .Key = KW_AGRUPADOS
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_Vencidos)
      .Name = LNGGetText(2136, vbNullString)    'Ver solo vencidos
      .Top = 400
      .Left = 11400
      .LeftLabel = -1400
      .Width = 370
      .PropertyType = cspCheck
      .Key = KW_VENCIDOS
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_Cotizacion)
      .Name = LNGGetText(1635, vbNullString)    'Cotización
      .Top = 750
      .Left = 10650
      .LeftLabel = -1400
      .Width = 1200
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecCotizacion
      .SubType = cspMoney
      .Key = KW_COTIZACION
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_Factuas)
      .Top = 1100
      .Left = 150
      '.Name = vbNullString
      .PropertyType = cspGrid
      .LeftLabel = -1
      pLoadFacturas .Grid
      .Width = 11500
      .Height = 4400
      .Key = KW_FACTURAS
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_Todos)
      .Name = c_selectall
      .Top = 5550
      .Left = 200
      .LeftLabel = -1
      .Width = 2200
      .PropertyType = cspButton
      .Key = KW_TODOS
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_Anticipo)
      .Name = LNGGetText(2137, vbNullString)    'Anticipo
      .Top = 5550
      .Left = 3500
      .LeftLabel = -1000
      .Width = 1800
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Format = m_GeneralConfig.FormatDecImporte
      .Key = KW_ANTICIPO
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_TotalPagoOrigen)
      .Name = LNGGetText(2138, vbNullString)    'Total Origen
      .Top = 5550
      .Left = 7000
      .LeftLabel = -1000
      .Width = 1800
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Enabled = False
      .Format = m_GeneralConfig.FormatDecImporte
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_TotalPago)
      .Name = LNGGetText(1584, vbNullString)    'Total
      .Top = 5550
      .Left = 9820
      .LeftLabel = -600
      .Width = 1800
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Enabled = False
      .Format = m_GeneralConfig.FormatDecImporte
    End With
  End With
End Sub

Private Sub pLoadFacturas(ByRef Grid As cIABMGrid)
  Dim Signo As String
  
  ' La primera simpre esta invisible
  With Grid.Columns
    
    .Add(Nothing).Visible = False
  
    With .Add(Nothing)
      .Visible = False
      .Key = KI_FVD_ID
    End With
    
    With .Add(Nothing)
      '.Name = vbNullString
      .PropertyType = cspCheck
      .Width = 320
      .Key = KI_SELECT
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1223, vbNullString)    'Tipo
      .PropertyType = cspText
      .Width = 1320
      .Key = KI_DOC
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1567, vbNullString)    'Documento
      .PropertyType = cspText
      .Width = 1340
      .Key = KI_NRODOC
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1065, vbNullString)    'Número
      .PropertyType = cspNumeric
      .Width = 800
      .Key = KI_FV_ID
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1569, vbNullString)    'Fecha
      .PropertyType = cspDate
      .Width = 740
      .Format = "dd/mm/yy"
      .Key = KI_FECHA
    End With
  
    Signo = pGetNomMonedaDefault
  
    With .Add(Nothing, c_Wiz_Key_Moneda)
      .Name = LNGGetText(2063, vbNullString)    'Mon
      .PropertyType = cspText
      .Width = 520
      .Key = KI_MONEDA
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1901, vbNullString)    'Origen
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 920
      .Key = KI_IMPORTEORIGEN
      .Format = m_GeneralConfig.FormatDecImporte
    End With
  
    With .Add(Nothing, c_Wiz_Key_Cotizacion)
      .Name = LNGGetText(1650, vbNullString)    'Cotiz.
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 570
      .Key = KI_COTIZACION
      .Format = m_GeneralConfig.FormatDecCotizacion
    End With
  
    With .Add(Nothing)
      .Name = Signo
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 920
      .Key = KI_TOTAL
      .Format = m_GeneralConfig.FormatDecImporte
    End With
    
    With .Add(Nothing, c_Wiz_Key_Cotizacion2)
      .Name = LNGGetText(1650, vbNullString)    'Cotiz.
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 570
      .Key = KI_COTIZACION2
      .Visible = False
      .Format = m_GeneralConfig.FormatDecCotizacion
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1634, vbNullString)    'Vto.
      .PropertyType = cspDate
      .Width = 740
      .Format = "dd/mm/yy"
      .Key = KI_VTO
    End With
  
    With .Add(Nothing, c_Wiz_Key_Pendiente)
      .Name = LNGGetText(2139, vbNullString, Signo)   'Importe  & Signo
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 920
      .Key = KI_PENDIENTE
      .Format = m_GeneralConfig.FormatDecImporte
    End With
  
    With .Add(Nothing, c_Wiz_Key_Importe)
      .Name = LNGGetText(2139, vbNullString, Signo)   'Importe  & Signo
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 920
      .Key = KI_IMPORTE
      .Format = m_GeneralConfig.FormatDecImporte
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1662, vbNullString)   'Aplicar
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 920
      .Key = KI_APLICAR
      .Format = m_GeneralConfig.FormatDecImporte
    End With
    
    With .Add(Nothing)
      .Name = C_strDescrip
      .PropertyType = cspText
      .Width = 3000
      .Key = KI_DESCRIP
    End With
  End With
End Sub

Private Sub pLoadStepAnticipo()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepAnticipo))
  
    With .Properties.Add(Nothing)
      '.Name = vbNullString
      .Top = 100
      .Left = 100
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 3
      'Set .Picture = m_Resource.ImgWiz3.Picture
    End With

    With .Properties.Add(Nothing)
      '.Name = vbNullString
      .Top = 400
      .Left = 1500
      .TopNotChange = True
      .LeftNotChange = True
      .Height = 880
      .Width = 8000
      .PropertyType = cspLabel
      .FontBold = True
      .Value = LNGGetText(2140, vbNullString)   'Indique los datos del anticipo
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_CuentaAnticipo)
      .Left = 2800
      .Width = 3000
      .LeftLabel = -1500
      .PropertyType = cspHelp
      .Table = csCuenta
      .HelpFilter = "(" & cscCuecId & " = " & csECuecDeudPorVentas & _
                    " or " & cscCuecId & " = " & csECuecDepositoCupones & _
                    ")and " & GetHelpFilterCuenta()
                    
      .Name = LNGGetText(1267, vbNullString)   'Cuenta
      
      .Value = m_TesoreriaConfig.CueAnticipoCobz
      .HelpId = m_TesoreriaConfig.cue_id_ant_cobz
      
      .Key = KW_CUENTA_ANTICIPO
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_MonedaAnticipo)
      .Left = 2800
      .Width = 3000
      .LeftLabel = -1500
      .PropertyType = cspHelp
      .Table = csMoneda
      .Name = LNGGetText(1113, vbNullString)   'Moneda
      .Key = KW_MONEDA_ANTICIPO
      .Enabled = False
    End With
      
    With .Properties.Add(Nothing, c_Wiz_Key_CotizacionAnticipo)
      .Left = 2800
      .Width = 3000
      .LeftLabel = -1500
      .Name = LNGGetText(1635, vbNullString)   'Cotización
      .Format = m_GeneralConfig.FormatDecCotizacion
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Key = KW_COTIZACION_ANTICIPO
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_AnticipoImporte)
      .Left = 2800
      .Width = 3000
      .LeftLabel = -1500
      .Name = LNGGetText(1228, vbNullString)   'Importe
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Key = KW_IMPORTE_ANTICIPO
    End With
  
    If m_TesoreriaConfig.cue_id_ant_cobz <> csNO_ID Then
      pShowMonedaAnticipo False
    End If
  
  End With
End Sub

Private Sub pLoadStepDifCambio()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepDifCambio))
  
    With .Properties.Add(Nothing)
      '.Name = vbNullString
      .Top = 100
      .Left = 100
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 3
      'Set .Picture = m_Resource.ImgWiz3.Picture
    End With

    With .Properties.Add(Nothing)
      '.Name = vbNullString
      .Top = 400
      .Left = 1500
      .TopNotChange = True
      .LeftNotChange = True
      .Height = 880
      .Width = 8000
      .PropertyType = cspLabel
      .FontBold = True
      .Value = LNGGetText(2141, vbNullString)   'Indique como tratar las diferencias de cambio
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_DefaultDifCambio)
      .PropertyType = cspList
      .Left = 2800
      .Width = 3000
      .LeftLabel = -1500
      .Name = LNGGetText(2286, vbNullString) 'Utilizar
      .Key = KW_DEFALUT_DIFCAMBIO
      .ListWhoSetItem = csListItemData
      .ListItemData = m_TesoreriaConfig.DefaultDifCambio
      With .List.Add(Nothing)
        .Id = csEModoDifCambio.csEDifCambioCuenta
        .Value = LNGGetText(2142, vbNullString)   'Una cuenta contable
      End With
      With .List.Add(Nothing)
        .Id = csEModoDifCambio.csEDifCambioNCND
        .Value = LNGGetText(2143, vbNullString)   'Una Nota de Débito o Crédito
      End With
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_CueIdDifCambio)
      .PropertyType = cspHelp
      .Table = csCuenta
      .Left = 2800
      .Width = 3000
      .LeftLabel = -1500
      .Name = LNGGetText(2288, vbNullString) 'Cuenta contable
      .Key = KW_CUE_ID_DIFCAMBIO
      .HelpId = m_TesoreriaConfig.CueIdDifCambio
      .Value = m_TesoreriaConfig.CuentaDifCambio
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_NCDifCambio)
      .PropertyType = cspHelp
      .Table = CSDocumento2.CSDocumento
      .Left = 2800
      .Width = 3000
      .LeftLabel = -1500
      .Name = LNGGetText(2289, vbNullString) 'Nota de Crédito
      .Key = KW_DOC_ID_NC_DIFCAMBIO
      .HelpId = m_TesoreriaConfig.DocIdNCDifCambio
      .HelpFilter = "'doct_id = 7'"
      .Value = m_TesoreriaConfig.DocNCDifCambio
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_NDDifCambio)
      .PropertyType = cspHelp
      .Table = CSDocumento2.CSDocumento
      .Left = 2800
      .Width = 3000
      .LeftLabel = -1500
      .Name = LNGGetText(2230, vbNullString) 'Nota de Débito
      .Key = KW_DOC_ID_ND_DIFCAMBIO
      .HelpId = m_TesoreriaConfig.DocIdNDDifCambio
      .HelpFilter = "'doct_id = 9'"
      .Value = m_TesoreriaConfig.DocNDDifCambio
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_PrIdDifCambio)
      .PropertyType = cspHelp
      .Table = csProductoVenta
      .Left = 2800
      .Width = 3000
      .LeftLabel = -1500
      .Name = LNGGetText(1367, vbNullString) 'Artículo
      .Key = KW_PR_ID_DIFCAMBIO
      .HelpId = m_TesoreriaConfig.PrIdDifCambio
      .Value = m_TesoreriaConfig.ProductoDifCambio
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_ModoIvaDifCambio)
      .PropertyType = cspList
      .Left = 2800
      .Width = 5000
      .LeftLabel = -1500
      .Name = LNGGetText(2290, vbNullString) 'Tratamiento del IVA
      .Key = KW_MODO_IVA_DIFCAMBIO
      .ListWhoSetItem = csListItemData
      .ListItemData = m_TesoreriaConfig.ModoIvaDifCambio
      With .List.Add(Nothing)
        .Id = csEModoIvaDifCambio.csEDifIvaImponible
        .Value = LNGGetText(2144, vbNullString)   'Tomar la diferencia de cambio como base imponible para el IVA
      End With
      With .List.Add(Nothing)
        .Id = csEModoIvaDifCambio.csEDifIvaNoImponible
        .Value = LNGGetText(2145, vbNullString)   'IVA incluido en la diferencia de cambio
      End With
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_FechaNDNC)
      .PropertyType = cspDate
      .Left = 2800
      .Name = LNGGetText(1569, vbNullString) 'Fecha
      .Key = KW_FECHA_NDNC
      .Value = Date
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_AplicacionND)
      .PropertyType = cspList
      .Left = 2800
      .Width = 5000
      .LeftLabel = -1500
      .Name = LNGGetText(2479, vbNullString) 'Aplicación
      .Key = KW_APLICACION_DIFCAMBIO
      .ListWhoSetItem = csListItemData
      .ListItemData = m_TesoreriaConfig.AplicacionDifCambio
      With .List.Add(Nothing)
        .Id = csEAplicacionDifCambio.csEDifAplicacionND
        .Value = LNGGetText(2480, vbNullString)   'Cobrar la Nota de Débito y aplicar el resto a las Facturas
      End With
      With .List.Add(Nothing)
        .Id = csEAplicacionDifCambio.csEDifAplicacionFV
        .Value = LNGGetText(2481, vbNullString)   'Cobrar las Facturas y aplicar el resto a la Note de Débito
      End With
    End With
  
  End With
End Sub

Private Sub pLoadStepSelectCobros()
  Dim KeyCobros As String
  
  KeyCobros = GetKey(c_StepSelectCobros)
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, KeyCobros)
  
    With .Properties.Add(Nothing)
      '.Name = vbNullString
      .Top = 100
      .Left = 100
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 3
      'Set .Picture = m_Resource.ImgWiz3.Picture
    End With

    c_LabelCobrosText = LNGGetText(2146, vbNullString)

    With .Properties.Add(Nothing, c_LabelCobros)
      '.Name = vbNullString
      .Top = 400
      .Left = 1500
      .TopNotChange = True
      .LeftNotChange = True
      .Height = 880
      .Width = 8000
      .PropertyType = cspLabel
      .FontBold = True
      .Value = c_LabelCobrosText 'Indique los instrumentos de cobro
    End With
    
    Dim ObjAbm As cIABMGeneric
#If PREPROC_SFS Then
    Dim Wizard As cWizardGeneric
#Else
    Dim Wizard As cWizardGenericDocEx
#End If
    Dim oTab   As cABMTabItem
    Dim iTab   As cIABMTabItem
    Set Wizard = m_ObjWizard
    Set ObjAbm = Wizard.ObjAbm
    
    Set iTab = ObjAbm.Tabs.Add(Nothing)
    Set oTab = iTab
    With oTab
      .FatherTab = KeyCobros
      .Left = 150
      .Top = 1100
    End With
    With iTab
      .Name = "Cheques"
      .Index = -1
    End With
    
    Set iTab = ObjAbm.Tabs.Add(Nothing)
    Set oTab = iTab
    oTab.FatherTab = KeyCobros
    With iTab
      .Name = "Efectivo"
      .Index = -2
    End With
    
    Set iTab = ObjAbm.Tabs.Add(Nothing)
    Set oTab = iTab
    oTab.FatherTab = KeyCobros
    With iTab
      .Name = "Tarjetas"
      .Index = -3
    End With
    
    Set iTab = ObjAbm.Tabs.Add(Nothing)
    Set oTab = iTab
    oTab.FatherTab = KeyCobros
    With iTab
      .Name = "Otros"
      .Index = -4
    End With
      
    Set iTab = ObjAbm.Tabs.Add(Nothing)
    Set oTab = iTab
    oTab.FatherTab = KeyCobros
    With iTab
      .Name = "Cuenta Corriente"
      .Index = -5
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_Cheques)
      .Top = 1600
      .Left = 150
      '.Name = vbNullString
      .PropertyType = cspGrid
      .LeftLabel = -1
      pLoadCheques .Grid
      .Width = 11500
      .Height = 4000
      .Key = KW_CHEQUES
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
      .TabIndex = -1
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_Efectivo)
      .Top = 1600
      .Left = 150
      '.Name = vbNullString
      .PropertyType = cspGrid
      .LeftLabel = -1
      pLoadEfectivo .Grid
      .Width = 11500
      .Height = 4000
      .Key = KW_EFECTIVO
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
      .TabIndex = -2
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_Tarjetas)
      .Top = 1600
      .Left = 150
      '.Name = vbNullString
      .PropertyType = cspGrid
      .LeftLabel = -1
      pLoadTarjetas .Grid
      .Width = 11500
      .Height = 4000
      .Key = KW_TARJETAS
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
      .TabIndex = -3
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_Otros)
      .Top = 1600
      .Left = 150
      '.Name = vbNullString
      .PropertyType = cspGrid
      .LeftLabel = -1
      pLoadOtros .Grid
      .Width = 11500
      .Height = 4000
      .Key = KW_OTROS
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
      .TabIndex = -4
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_CtaCte)
      .Top = 1600
      .Left = 150
      '.Name = vbNullString
      .PropertyType = cspGrid
      .LeftLabel = -1
      pLoadCtaCte .Grid
      .Width = 11500
      .Height = 4000
      .Key = KW_CTACTE
      .GridAdd = False
      .GridEdit = False
      .GridRemove = False
      .TabIndex = -5
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_CobroIndicado)
      .Top = 5580
      .Left = 1800
      .LeftLabel = -1000
      .Width = 1800
      .Format = m_GeneralConfig.FormatDecImporte
      .Name = LNGGetText(2147, vbNullString)   'A cobrar
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Enabled = False
      .Key = KW_IMPORTE_INDICADO
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_CobroNeto)
      .Top = 5580
      .Left = 4800
      .Name = LNGGetText(1581, vbNullString)   'Neto
      .LeftLabel = -500
      .Width = 1800
      .Format = m_GeneralConfig.FormatDecImporte
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Enabled = False
      .Key = KW_IMPORTE_NETO
    End With

    With .Properties.Add(Nothing, c_Wiz_Key_CobroOtros)
      .Top = 5580
      .Left = 7200
      .LeftLabel = -500
      .Width = 1800
      .Format = m_GeneralConfig.FormatDecImporte
      .Name = LNGGetText(1070, vbNullString)   'Otros
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Enabled = False
      .Key = KW_IMPORTE_OTROS
    End With

    With .Properties.Add(Nothing, c_Wiz_Key_CobroTotal)
      .Top = 5580
      .Left = 9850
      .LeftLabel = -500
      .Width = 1800
      .Name = LNGGetText(1584, vbNullString)   'Total
      .Format = m_GeneralConfig.FormatDecImporte
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Enabled = False
      .Key = KW_IMPORTE_TOTAL
    End With
  End With
End Sub

Private Sub pLoadOtros(ByRef Grid As cIABMGrid)
  ' La primera simpre esta invisible
  With Grid.Columns
    
    .Add(Nothing).Visible = False
  
    With .Add(Nothing)
      .Name = LNGGetText(1267, vbNullString)   'Cuenta
      .PropertyType = cspHelp
      .Table = csCuenta
      .Width = 2200
      .Key = KIO_CUE_ID
      .HelpFilter = "(emp_id = " & EmpId & " or emp_id is null)" & pGetFilterCuentaXCaja() 'c_filter_cuentas_de_caja
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1904, vbNullString)   'Debe
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KIO_DEBE
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1905, vbNullString)   'Haber
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KIO_HABER
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1901, vbNullString)   'Origen
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KIO_IMPORTEORIGEN
    End With
    
    With .Add(Nothing)
      .Name = C_strDescrip
      .PropertyType = cspText
      .Width = 1000
      .Key = KIO_DESCRIP
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1403, vbNullString)   'Retención
      .PropertyType = cspHelp
      .Table = csRetencion
      .Width = 1500
      .Key = KIO_RET_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2103, vbNullString)   'C. Retención
      .PropertyType = cspText
      .Width = 1200
      .Key = KIO_NRORETENCION
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2104, vbNullString)   '% Retención
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .Width = 1200
      .Key = KIO_PORCRETENCION
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1569, vbNullString)   'Fecha
      .PropertyType = cspDate
      .Width = 920
      .Key = KIO_FECHARETENCION
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1057, vbNullString)   'Centro de Costo
      .PropertyType = cspHelp
      .Table = csCentroCosto
      .Width = 1800
      .Key = KIO_CCOS_ID
    End With
  
    With .Add(Nothing, cscFvIdRet)
      .Name = LNGGetText(1866, vbNullString) ' Factura
      .PropertyType = cspHelp
      .Table = csFacturaVenta
      .Width = 1200
      .Key = KIO_FV_ID_RET
    End With
  End With
End Sub

Private Sub pLoadCheques(ByRef Grid As cIABMGrid)
  ' La primera simpre esta invisible
  With Grid.Columns
    
    .Add(Nothing).Visible = False
  
    With .Add(Nothing)
      .Name = LNGGetText(1267, vbNullString)   'Cuenta
      .PropertyType = cspHelp
      .Table = csCuenta
      
      '.HelpFilter = "(" & cscCuecId & "=" & csECuecBancos & " or " _
                    & cscCuecId & "=" & csECuecDocEnCartera & _
                    ") and (emp_id = " & EmpId & " or emp_id is null)"
      .HelpFilter = GetHelpFilterCheques() & pGetFilterCuentaXCaja() 'c_filter_cuentas_de_caja
      
      .Width = 2200
      .Key = KICH_CUE_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2063, vbNullString)   'Mon
      .PropertyType = cspHelp
      .Table = csMoneda
      .Width = 520
      .Key = KICH_MON_ID
      .Enabled = False
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1901, vbNullString)   'Origen
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KICH_IMPORTEORIGEN
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1228, vbNullString)   'Importe
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KICH_IMPORTE
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1122, vbNullString)   'Banco
      .PropertyType = cspHelp
      .Table = csBanco
      .Width = 1620
      .Key = KICH_BCO_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2059, vbNullString)   'Nro. Cheque
      .PropertyType = cspText
      .Width = 1000
      .Key = KICH_CHEQUE
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(3719, vbNullString)  'Propio
      .PropertyType = cspCheck
      .Width = 800
      .Key = KICH_PROPIO
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2065, vbNullString)   'Depositar el
      Set .DefaultValue = New cABMGridRowValue
      .DefaultValue.Value = Date
      .PropertyType = cspDate
      .Width = 970
      .Key = KICH_FECHACOBRO
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1634, vbNullString)   'Vto.
      Set .DefaultValue = New cABMGridRowValue
      .DefaultValue.Value = DateAdd("m", 1, Date)
      .PropertyType = cspDate
      .Width = 970
      .Key = KICH_FECHAVTO
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1083, vbNullString)   'Clering
      .PropertyType = cspHelp
      .Table = csClearing
      .Width = 800
      .Key = KICH_CLE_ID
    End With
    
    With .Add(Nothing)
      .Name = C_strDescrip
      .PropertyType = cspText
      .Width = 1600
      .Key = KICH_DESCRIP
    End With
    
  End With
End Sub

Private Sub pLoadEfectivo(ByRef Grid As cIABMGrid)
  ' La primera simpre esta invisible
  With Grid.Columns
    
    .Add(Nothing).Visible = False
  
    With .Add(Nothing)
      .Name = LNGGetText(1267, vbNullString)   'Cuenta
      .PropertyType = cspHelp
      .Table = csCuenta
      
      '.HelpFilter = "(" & cscCuecId & "=" & csECuecCaja & " or " _
                    & cscCuecId & "=" & csECuecBancos & _
                    ") and (emp_id = " & EmpId & " or emp_id is null)"
      .HelpFilter = GetHelpFilterEfectivo() & pGetFilterCuentaXCaja() 'c_filter_cuentas_de_caja
      
      .Width = 3000
      .Key = KIE_CUE_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2063, vbNullString)   'Mon
      .PropertyType = cspHelp
      .Table = csMoneda
      .Width = 520
      .Key = KIE_MON_ID
      .Enabled = False
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1901, vbNullString)   'Origen
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KIE_IMPORTEORIGEN
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1228, vbNullString)   'Importe
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KIE_IMPORTE
    End With
    
    With .Add(Nothing)
      .Name = C_strDescrip
      .PropertyType = cspText
      .Width = 2500
      .Key = KIE_DESCRIP
    End With
  End With
End Sub

Private Sub pLoadTarjetas(ByRef Grid As cIABMGrid)
  ' La primera simpre esta invisible
  With Grid.Columns
  
    .Add(Nothing).Visible = False
  
    With .Add(Nothing)
      .Name = LNGGetText(2105, vbNullString)   'Cupon
      .PropertyType = cspText
      .Width = 1500
      .Key = KIT_CUPON
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(2106, vbNullString)   'Tarjeta
      .PropertyType = cspHelp
      .HelpFilter = "emp_id = " & EmpId
      .Table = csTarjetaCredito
      .Width = 1800
      .Key = KIT_TJC_ID
    End With
    
    With .Add(Nothing, c_Cuotas)
      .Name = LNGGetText(1473, vbNullString)   'Cuotas
      .PropertyType = cspHelp
      .Table = csTarjetaCreditoCuota
      .Width = 900
      .Key = KIT_TJCCU_ID
    End With
    m_lColCuotas = .count

    With .Add(Nothing)
      .Name = LNGGetText(2063, vbNullString)   'Mon
      .PropertyType = cspHelp
      .Table = csMoneda
      .Width = 520
      .Key = KIT_MON_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1901, vbNullString)   'Origen
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KIT_IMPORTEORIGEN
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1228, vbNullString)   'Importe
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KIT_IMPORTE
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1634, vbNullString)   'Vto.
      .PropertyType = cspDate
      Set .DefaultValue = New cABMGridRowValue
      .DefaultValue.Value = DateAdd("d", 1, Date)
      .Width = 970
      .Key = KIT_FECHAVTO
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2107, vbNullString)   'Nro. Tarjeta
      .PropertyType = cspText
      .Width = 1300
      .Key = KIT_NROTARJETA
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2123, vbNullString)   'Cod. Autoriz.
      .PropertyType = cspText
      .Width = 1000
      .Key = KIT_NROAUTORIZACION
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2108, vbNullString)   'Operacion
      .PropertyType = cspList
      With .List.Add(Nothing)
        .Id = csECuponPosnet
        .Value = LNGGetText(2110, vbNullString)   'Posnet
      End With
      With .List.Add(Nothing)
        .Id = csECuponManual
        .Value = LNGGetText(2111, vbNullString)   'Manual
      End With
      Set .DefaultValue = New cABMGridRowValue
      .DefaultValue.Id = csECuponPosnet
      .Width = 1000
      .Key = KIT_TARJETA_TIPO
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2109, vbNullString)   'Titular
      .PropertyType = cspText
      .Width = 1000
      .Key = KIT_TITULAR
    End With
    
    With .Add(Nothing)
      .Name = C_strDescrip
      .PropertyType = cspText
      .Width = 1300
      .Key = KIT_DESCRIP
    End With
  End With
End Sub

Private Sub pLoadCtaCte(ByRef Grid As cIABMGrid)
  ' La primera simpre esta invisible
  With Grid.Columns
  
    .Add(Nothing).Visible = False
  
    With .Add(Nothing)
      .Name = LNGGetText(1267, vbNullString)   'Cuenta
      .PropertyType = cspHelp
      .Table = csCuenta
      .Width = 3000
      .HelpFilter = "(1=1)" & c_filter_cuentas_de_caja
      .Key = KICC_CUE_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1901, vbNullString)   'Origen
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KICC_IMPORTEORIGEN
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1228, vbNullString)   'Importe
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KICC_IMPORTE
    End With
  End With
End Sub

Private Sub pLoadStepDatosGenerales()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepDatosGenerales))
  
    With .Properties.Add(Nothing)
      '.Name = vbNullString
      .Top = 100
      .Left = 100
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 3
      'Set .Picture = m_Resource.ImgWiz3.Picture
    End With

    With .Properties.Add(Nothing)
      '.Name = vbNullString
      .Top = 400
      .Left = 1500
      .TopNotChange = True
      .LeftNotChange = True
      .Height = 880
      .Width = 8000
      .PropertyType = cspLabel
      .FontBold = True
      .Value = LNGGetText(2148, vbNullString)   'Complete los siguientes datos del Recibo
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_Fecha)
      .PropertyType = cspDate
      .Left = 2800
      .Name = LNGGetText(1569, vbNullString) 'Fecha
      .Key = KW_FECHA
      .Value = Date
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_Cliente2)
      .PropertyType = cspHelp
      .Table = csCliente
      .Enabled = False
      .Name = LNGGetText(1150, vbNullString) 'Cliente
      .Key = KW_CLIENTE2
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_Sucursal)
      .PropertyType = cspHelp
      .Table = csSucursal
      .Name = LNGGetText(1281, vbNullString) 'Sucursal
      .Value = User.Sucursal
      .HelpId = User.suc_id
      .Key = KW_SUCURSAL
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_Comprobante)
      .PropertyType = cspText
      .Left = 6800
      .TopFromProperty = c_Wiz_Key_Fecha
      .Name = LNGGetText(1610, vbNullString) 'Comprobante
      .Key = KW_COMPROBANTE
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_Cobrador)
      .PropertyType = cspHelp
      .Table = csCobrador
      .Name = LNGGetText(1088, vbNullString) 'Cobrador
      .Key = KW_COBRADOR
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_Legajo)
      .PropertyType = cspHelp
      .Table = csLegajo
      .Name = LNGGetText(1575, vbNullString) 'Legajo
      .Key = KW_LEGAJO
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_CentroCosto)
      .PropertyType = cspHelp
      .Table = csCentroCosto
      .Name = LNGGetText(1057, vbNullString) 'Centro de Costo
      .Key = KW_CENTROCOSTO
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_Observaciones)
      .PropertyType = cspText
      .Left = 2800
      .TopFromProperty = c_Wiz_Key_CentroCosto
      .TopToPrevious = 440
      .Height = 880
      .Width = 6250
      .Name = LNGGetText(1861, vbNullString) 'Observaciones
      .Key = KW_DESCRIP
    End With
  End With
End Sub

Private Function pUserCancel() As Boolean
  If m_WizardCancel Then
    
    If Ask(LNGGetText(1665, vbNullString), vbNo) Then
               'Desea cancelar el proceso
      pUserCancel = True
    End If
  End If
  m_WizardCancel = False
End Function

Private Function pGetAnticipo2(ByRef Origen As Double) As Double
  Dim MonId       As Long
  Dim Cotizacion  As Double
  Dim Anticipo    As Double
  
  MonId = pGetMonedaAnticipo().HelpId
  Anticipo = Val(pGetAnticipoImporte().Value)
  
  If MonId <> m_MonDefault Then
    Cotizacion = Val(pGetCotizacionAnticipo().Value)
    Origen = Anticipo
    Anticipo = Anticipo * Cotizacion
  Else
    Origen = 0
  End If
  
  pGetAnticipo2 = Anticipo
End Function

Private Function pCheckAnticipo() As Boolean
  pCheckAnticipo = True
End Function

Private Function pChecFacturas() As Boolean
  If Val(pGetTotal.Value) = 0 Then
    MsgWarning LNGGetText(2149, vbNullString)
                'Debe indicar una o más Facturas, un importe como anticipo, o ambas cosas.
    Exit Function
  End If
  pChecFacturas = True
End Function

Private Function pLoadFacturasXCliente() As Boolean
  Dim sqlstmt           As String
  Dim rs                As Recordset
  Dim bAgrupados        As Boolean
  Dim bShowCotizacion   As Boolean
  Dim vMonId()          As Long
  Dim vCotiz()          As Double
  Dim MonId             As Long
  Dim i                 As Long
  Dim Moneda            As cMoneda
  Dim Cotiz             As Double
  Dim Origen            As Double
  
  Dim fv_id             As Long
  
  ' Edit From ListDoc
  '
  Dim bSelected         As Boolean
  Dim bOnlySelected     As Boolean
  
  m_bDifCambio = False
  
  bAgrupados = pGetAgrupados
  sqlstmt = "sp_DocCobranzaGetFacturas " & EmpId & "," & pGetCliente & "," & Abs(CInt(pGetVencidos)) & "," & Abs(CInt(bAgrupados))
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  ' Edit From ListDoc
  '
  bOnlySelected = pGetOnlySelected().Value
  
  With pGetFacturas()
  
    ReDim vMonId(0)
    
    If pGetAgrupados Then
      .Columns(c_Wiz_Key_Importe).Visible = False
      .Columns(c_Wiz_Key_Pendiente).Visible = True
    Else
      .Columns(c_Wiz_Key_Importe).Visible = True
      .Columns(c_Wiz_Key_Pendiente).Visible = False
    End If
    
    With .Rows
        
      .Clear
        
      While Not rs.EOF
      
        ' Edit From ListDoc
        '
        fv_id = gDB.ValField(rs.Fields, cscFvId)
        
        bSelected = pGetApply(fv_id)
        If Not bOnlySelected Or bSelected Then
        
          With .Add(Nothing)
          
            ' La primera no se usa
            .Add Nothing
            
            With .Add(Nothing)
              .Id = gDB.ValField(rs.Fields, cscFvdId)
              .Key = KI_FVD_ID
            End With
            
            With .Add(Nothing)
              .Id = CInt(bSelected)
              .Key = KI_SELECT
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscDocNombre)
              .Key = KI_DOC
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscFvNrodoc)
              .Key = KI_NRODOC
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscFvNumero)
              .Id = gDB.ValField(rs.Fields, cscFvId)
              .Key = KI_FV_ID
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscFvFecha)
              .Key = KI_FECHA
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscMonNombre)
              .Id = gDB.ValField(rs.Fields, cscMonId)
              .Key = KI_MONEDA
            End With
            
            With .Add(Nothing)
              Origen = gDB.ValField(rs.Fields, cscFvTotalOrigen)
              .Value = IIf(Origen, Origen, vbNullString)
              .Key = KI_IMPORTEORIGEN
              If Val(.Value) <> 0 Then bShowCotizacion = True
            End With
            
            With .Add(Nothing)
              Cotiz = gDB.ValField(rs.Fields, cscFvCotizacion)
              .Value = IIf(Cotiz, Cotiz, vbNullString)
              .Key = KI_COTIZACION
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscFvTotal)
              .Key = KI_TOTAL
            End With
            
            With .Add(Nothing)
              .Value = 0
              .Key = KI_COTIZACION2
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscFvdFecha)
              .Key = KI_VTO
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscFvPendiente)
              .Key = KI_PENDIENTE
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscFvdPendiente)
              .Key = KI_IMPORTE
            End With
            
            With .Add(Nothing)
              If bSelected Then
                .Value = pGetApplyImporte(fv_id, _
                                          gDB.ValField(rs.Fields, cscFvdPendiente) _
                                          )
              Else
                .Value = 0
              End If
              .Key = KI_APLICAR
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscFvDescrip)
              .Key = KI_DESCRIP
            End With
          End With
          
          MonId = gDB.ValField(rs.Fields, cscMonId)
          If m_MonDefault <> MonId Then
            pAddMoneda vMonId(), MonId
          End If
        End If
        
        rs.MoveNext
      Wend
    End With
  End With
  
  If Not bShowCotizacion Then
    pGetFacturas().Columns(c_Wiz_Key_Cotizacion).Visible = False
    pGetFacturas().Columns(c_Wiz_Key_Moneda).Visible = False
    pGetCotizacion().Visible = False
    pGetTotalOrigen().Visible = False
    m_bDifCambio = False
  Else
    pGetFacturas().Columns(c_Wiz_Key_Cotizacion).Visible = True
    pGetFacturas().Columns(c_Wiz_Key_Moneda).Visible = True
    pGetCotizacion().Visible = True
    pGetTotalOrigen().Visible = True
    m_bDifCambio = True
  End If
  
  If UBound(vMonId) > 0 Then
    Set Moneda = New cMoneda
    
    pGetFacturas.Columns(c_Wiz_Key_Cotizacion2).Visible = True
  
    ReDim vCotiz(UBound(vMonId))
    For i = 1 To UBound(vMonId)
      vCotiz(i) = Moneda.GetCotizacion(vMonId(i), Date)
    Next
    
    Dim Row As cIABMGridRow
    For Each Row In pGetFacturas.Rows
      For i = 1 To UBound(vMonId)
        If vMonId(i) = pCell(Row, KI_MONEDA).Id Then
          pCell(Row, KI_COTIZACION2).Value = vCotiz(i)
          Exit For
        End If
      Next
    Next
    
    Set Moneda = New cMoneda
    
    pGetCotizacion().Value = Moneda.GetCotizacion(vMonId(1), Date)
    pRefreshCotizacion False
  
  Else
    pGetCotizacion().Visible = False
    pGetFacturas.Columns(c_Wiz_Key_Cotizacion2).Visible = False
  End If
  
  m_ObjWizard.ShowValue pGetCotizacion()
  m_ObjWizard.ShowValue pGetTotalOrigen()
  
  pRefreshFacturas
  pShowTotalFacturas
  
  pLoadFacturasXCliente = True
End Function

' Edit From ListDoc
'
Private Function pGetApplyImporte(ByVal fv_id As Long, ByVal Pendiente As Double) As Double
  Dim i As Long
  Dim j As Long
  Dim Cobrado As Double
  
  If m_bUseCliIds Then
  
    If Not m_CobranzaInfo Is Nothing Then
    
      ' Cobranza por Info
      '
      Dim FvInfo As cCobranzaInfoFactura

      For Each FvInfo In m_CobranzaInfo.Facturas
      
        If FvInfo.CliId = m_Cli_idDoc Then
        
          If FvInfo.FvId = fv_id Then
        
            Cobrado = FvInfo.ImporteCobrado
            
            If Pendiente < Cobrado Then
              pGetApplyImporte = Pendiente
            Else
              pGetApplyImporte = Cobrado
            End If
            Exit Function
            
          End If
        
        End If
      Next
    
    Else
    
      ' Cobranza por vector
      '
    
      For j = 1 To UBound(m_FvIdsxCliId, 2)
        
        If m_FvIdsxCliId(1, j) = m_Cli_idDoc Then
        
          If m_FvIdsxCliId(2, j) = fv_id Then
            
            Cobrado = m_FvIdsxCliId(3, j) / 100
            If Pendiente < Cobrado Then
              pGetApplyImporte = Pendiente
            Else
              pGetApplyImporte = Cobrado
            End If
            Exit Function
          End If
        End If
      Next
    
    End If
    
  Else
  
    pGetApplyImporte = Pendiente
  
  End If

End Function

Private Function pGetApply(ByVal fv_id As Long) As Boolean
  Dim i As Long
  Dim j As Long
  
  If m_bUseCliIds Then
  
    If Not m_CobranzaInfo Is Nothing Then
    
      ' Cobranza por Info
      '
      Dim FvInfo As cCobranzaInfoFactura
  
      For Each FvInfo In m_CobranzaInfo.Facturas
      
        If FvInfo.CliId = m_Cli_idDoc Then
        
          If FvInfo.FvId = fv_id Then
        
            pGetApply = True
            Exit Function
            
          End If
        
        End If
      Next
    
    Else
  
      ' Cobranza por vector
      '
      
      For j = 1 To UBound(m_FvIdsxCliId, 2)
        
        If m_FvIdsxCliId(1, j) = m_Cli_idDoc Then
        
          If m_FvIdsxCliId(2, j) = fv_id Then
            pGetApply = True
            Exit Function
          End If
        End If
      Next
    
    End If
    
  Else
  
    For i = 1 To UBound(m_FvIds)
      If m_FvIds(i) = fv_id Then
        pGetApply = True
        Exit Function
      End If
    Next
  End If
End Function

Private Sub pAddMoneda(ByRef vMonIds() As Long, ByVal MonId As Long)
  Dim i As Long
  
  For i = 1 To UBound(vMonIds)
    If vMonIds(i) = MonId Then Exit Sub
  Next
  
  ReDim Preserve vMonIds(UBound(vMonIds) + 1)
  vMonIds(UBound(vMonIds)) = MonId
End Sub

Private Function pGetNomMonedaDefault() As String
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select mon_signo from Moneda where mon_legal <> 0"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then
    MsgWarning LNGGetText(2150, vbNullString)
              'Debe definir cual es la moneda legal con la que opera el Sistema
    Exit Function
  End If
  
  pGetNomMonedaDefault = gDB.ValField(rs.Fields, "mon_signo")
End Function

Private Function pGetCuentasDeudor() As Boolean
  Dim i             As Long
  Dim Row           As cIABMGridRow
  Dim Cell          As cIABMGridCellValue
  Dim Total         As Double
  Dim vCtaCte()       As T_CtaCte
  Dim Anticipo        As Double
  Dim AnticipoOrigen  As Double
  Dim cue_id_anticipo As Double
  Dim CuentaAnticipo  As String
  
  ' Dimensiono la grilla y el vector de facturas
  pGetCtaCte().Rows.Clear
  
  With pGetCuentaAnticipo()
    cue_id_anticipo = .HelpId
    CuentaAnticipo = .Value
  End With
  
  Anticipo = pGetAnticipo2(AnticipoOrigen)
  
  ' Obtengo las cuentas del tercero
  If Not GetCuentasDeudor(pGetFacturas(), vCtaCte(), KI_FV_ID, KI_APLICAR, _
                          KI_COTIZACION2, Anticipo, _
                          cue_id_anticipo, CuentaAnticipo, _
                          AnticipoOrigen) Then Exit Function
  
  ' Agrego las cuentas a la grilla
  For i = 1 To UBound(vCtaCte)
    Set Row = pGetCtaCte().Rows.Add(Nothing)
    
    ' La primera no se usa
    Set Cell = Row.Add(Nothing)
    
    With vCtaCte(i)
      Set Cell = Row.Add(Nothing)
      Cell.Value = .Cuenta
      Cell.Id = .cue_id
      Cell.Key = KICC_CUE_ID
      
      Set Cell = Row.Add(Nothing)
      Cell.Value = .ImporteOrigen
      Cell.Key = KICC_IMPORTEORIGEN
      
      Set Cell = Row.Add(Nothing)
      Cell.Value = .importe
      Cell.Key = KICC_IMPORTE
      
      Total = Total + .importe
    End With
  Next
  
  ' Refrezco la grilla
  pGetCobroIndicado.Value = Total
  m_ObjWizard.ShowValue pGetCobroIndicado
  
  pRefreshCtaCte
  pGetCuentasDeudor = True
End Function

' Validaciones de Filas de Instrumentos de cobro
Private Function pIsEmptyRowCheques(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KICH_CUE_ID, KICH_BCO_ID, KICH_MON_ID, KICH_CLE_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    
      Case KICH_IMPORTE, KICH_IMPORTEORIGEN
        If Not ValEmpty(Val(Cell.Value), csDouble) Then
          bRowIsEmpty = True
          Exit For
        End If
      
      Case KICH_DESCRIP, KICH_CHEQUE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = True
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
  
  For Each Cell In Row
    Select Case Cell.Key
      
      Case KICH_CUE_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2113, vbNullString, strRow) 'Debe indicar una cuenta contable (1)
          Exit Function
        End If
        
      Case KICH_BCO_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2094, vbNullString, strRow) 'Debe indicar un banco (1)
          Exit Function
        End If
        
      Case KICH_MON_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2114, vbNullString, strRow) 'Debe indicar una moneda (1)
          Exit Function
        End If
        MonId = Cell.Id
        
      Case KICH_CLE_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2115, vbNullString, strRow) 'Debe indicar un clearing (1)
          Exit Function
        End If
    
      Case KICH_IMPORTEORIGEN
        bOrigen = Not ValEmpty(Val(Cell.Value), csDouble)
      
      Case KICH_IMPORTE
        If ValEmpty(Val(Cell.Value), csDouble) Then
          MsgInfo LNGGetText(1897, vbNullString, strRow) 'Debe indicar un importe (1)
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
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KIT_TJC_ID, KIT_MON_ID, KIT_TJCCU_ID
        If Not ValEmpty(Cell.Id, csId) Then
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
  
  For Each Cell In Row
    Select Case Cell.Key
      
      Case KIT_TJC_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2113, vbNullString, strRow) 'Debe indicar una cuenta contable (1)
          Exit Function
        End If
      
      Case KIT_TJCCU_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(1478, vbNullString, strRow) 'Debe indicar la cantidad de cuotas (1)
          Exit Function
        End If
        
      Case KIT_MON_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2114, vbNullString, strRow) 'Debe indicar una moneda (1)
          Exit Function
        End If
        MonId = Cell.Id
        
      Case KIT_IMPORTEORIGEN
        bOrigen = Not ValEmpty(Val(Cell.Value), csDouble)
      
      Case KIT_IMPORTE
        If ValEmpty(Val(Cell.Value), csDouble) Then
          MsgInfo LNGGetText(1897, vbNullString, strRow) 'Debe indicar un importe (1)
          Exit Function
        End If
      
      Case KIT_NROTARJETA
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(2120, vbNullString, strRow) 'Debe indicar un número tarjeta (1)
          Exit Function
        End If
      
      Case KIT_NROAUTORIZACION
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(2121, vbNullString, strRow) 'Debe indicar un número autorización (1)
          Exit Function
        End If
      
      Case KIT_FECHAVTO
        If ValEmpty(Cell.Value, csDate) Then
          MsgInfo LNGGetText(1384, vbNullString, strRow) 'Debe indicar una fecha de vencimiento (1)
          Exit Function
        End If
      
      Case KIT_TITULAR
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(2122, vbNullString, strRow) 'Debe indicar un Titular (1)
          Exit Function
        End If
    End Select
  Next
  
  If Not bOrigen And MonId <> m_MonDefault Then
    MsgInfo LNGGetText(2118, vbNullString, strRow) 'Debe indicar un importe para la moneda extranjera (1)
    Exit Function
  End If
  
  pValidateRowTarjetas = True
End Function

Private Function pIsEmptyRowOtros(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KIO_CUE_ID, KIO_CCOS_ID, KIO_RET_ID
        If Not ValEmpty(Cell.Id, csId) Then
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
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2113, vbNullString, strRow) 'Debe indicar una cuenta contable (1)
          Exit Function
        End If
      
      Case KIO_DEBE
        bDebe = Not ValEmpty(Val(Cell.Value), csDouble)
        
      Case KIO_HABER
        bHaber = Not ValEmpty(Val(Cell.Value), csDouble)
        
      Case KIO_IMPORTEORIGEN
        bOrigen = Not ValEmpty(Val(Cell.Value), csDouble)
        
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
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KIE_CUE_ID
        If Not ValEmpty(Cell.Id, csId) Then
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
  
  For Each Cell In Row
    Select Case Cell.Key
      
      Case KIE_CUE_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2113, vbNullString, strRow) 'Debe indicar una cuenta contable (1)
          Exit Function
        End If
        
        If Not gDB.GetData(csTCuenta, cscCueId, Cell.Id, cscMonId, MonId) Then Exit Function
        
      Case KIE_IMPORTEORIGEN
        bOrigen = Not ValEmpty(Val(Cell.Value), csDouble)
      
      Case KIE_IMPORTE
        If ValEmpty(Val(Cell.Value), csDouble) Then
          MsgInfo LNGGetText(1897, vbNullString, strRow) 'Debe indicar un importe (1)
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

Private Function pValidateCobro() As Boolean
  Dim Row As cIABMGridRow
  Dim i   As Long
  
  i = 0
  For Each Row In pGetCheques().Rows
    i = i + 1
    If Not pIsEmptyRowCheques(Row, i) Then
      If Not pValidateRowCheques(Row, i) Then Exit Function
    End If
  Next
  
  i = 0
  For Each Row In pGetEfectivo().Rows
    i = i + 1
    If Not pIsEmptyRowEfectivo(Row, i) Then
      If Not pValidateRowEfectivo(Row, i) Then Exit Function
    End If
  Next
  
  i = 0
  For Each Row In pGetOtros().Rows
    i = i + 1
    If Not pIsEmptyRowOtros(Row, i) Then
      If Not pValidateRowOtros(Row, i) Then Exit Function
    End If
  Next
  
  i = 0
  For Each Row In pGetTarjetas().Rows
    i = i + 1
    If Not pIsEmptyRowTarjetas(Row, i) Then
      If Not pValidateRowTarjetas(Row, i) Then Exit Function
    End If
  Next

  If Round(Val(pGetCobroIndicado().Value), m_GeneralConfig.DecimalesImporte) _
     <> Round(Val(pGetCobroTotal().Value), m_GeneralConfig.DecimalesImporte) Then
     
    ' Si me tengo que detener en pagos y estoy en una
    ' cobranza semi-automatica (las que se disparan desde
    ' la recepcion de hojas de ruta), no presento un mensaje
    '
    If m_bVirtualNextStopInPagos And m_bAutoSelect Then
    
      ' Apago el flag por que a la proxima que de next y no
      ' alcance para el pago ya le tengo que avisar
      '
      m_bVirtualNextStopInPagos = False
      m_bRestarVirtualPush = True
      
    Else
      
      MsgWarning LNGGetText(2151, vbNullString)
                'El total de los instrumentos de cobro no coincide con el monto a cobrar
    End If
    
    Exit Function
  End If
  pValidateCobro = True
End Function

Private Sub pGetDocNumber()
  Dim Tl          As cTalonario
  Dim TAL_ID      As Long
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  Dim Mask        As String
  Dim bEditable   As Boolean
  
  If LenB(pGetComprobante().Value) Then Exit Sub
  
  sqlstmt = "sp_clienteGetTalonario " & pGetCliente() & "," & pGetDoc()
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  TAL_ID = gDB.ValField(rs.Fields, 0)
  
  Set Tl = New cTalonario
  
  With pGetComprobante()
    .Value = Tl.GetNextNumber(TAL_ID, Mask, bEditable)
    .TextMask = Mask
    .Enabled = bEditable
  End With
  
  m_ObjWizard.ShowValue pGetComprobante()
End Sub

Private Sub pSetDatosGenerales()
  With pGetCliente2
    .HelpId = pGetCliente
    .Value = pGetClienteName
  End With
  m_ObjWizard.ShowValue pGetCliente2
  pGetDocNumber
  pSetDatosFromAplic
End Sub

Private Function pValidateDatosGenerales() As Boolean
  If ValEmpty(pGetFecha().Value, csDate) Then
    MsgWarning LNGGetText(2152, vbNullString) 'Debe indicar la fecha de la Cobranza
    Exit Function
  End If
  
  If ValEmpty(pGetSucursal().HelpId, csId) Then
    MsgWarning LNGGetText(1560, vbNullString) 'Debe indicar la sucursal
    Exit Function
  End If
  
  pValidateDatosGenerales = True
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2098, vbNullString) 'Error al grabar la Cobranza
  c_NCNDDescripDifCambio = LNGGetText(2281, vbNullString) 'Generado automáticamente por diferencia de cambio

  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  Set m_TesoreriaConfig = New cTesoreriaConfig
  m_TesoreriaConfig.Load
  
  m_MonDefault = GetMonedaDefault()
  
  ReDim m_FvIds(0)
  ReDim m_CliIds(0)
  ReDim m_FvIdsxCliId(0, 0)
  
  ' Hay que agregarlo a la configuracion de tesoreria
  '
  m_isHojaRuta = m_TesoreriaConfig.CobranzasXHojaRuta

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_GeneralConfig = Nothing
  Set m_TesoreriaConfig = Nothing
  ReDim m_FvIds(0)
  ReDim m_CliIds(0)
  ReDim m_FvIdsxCliId(0, 0)
  Set m_ObjClient = Nothing
  Set m_CobranzaInfo = Nothing
  
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



'///////////////////////////////////////////////////////////////////////////////
Private Function pSave() As Boolean
  
  If Not DocCanSaveEx(m_ObjWizard.EditGeneric, c_Wiz_Key_Fecha, c_Wiz_Key_Doc) Then
    pSave = False
    Exit Function
  End If
  
  Dim register     As cRegister
  
  ' Para determinar la aplicacion de las diferencias de cambio
  '
  Dim Aplicado     As Double
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  
  With register
    
    .fieldId = cscCobzTMPId
    .Table = csTCobranzaTMP
    .Id = csNew
  
    With .Fields
      .Add2 cscCobzNumero, 0, csLong
      With pGetComprobante()
        ' PrintDoc
        '
        m_LastNroDoc = SetMask(.Value, .TextMask)
        register.Fields.Add2 cscCobzNrodoc, m_LastNroDoc, csText
      End With
      .Add2 cscCobzDescrip, pGetDescrip().Value, csText
      .Add2 cscCobzFecha, pGetFecha().Value, csDate
      m_LastCli = pGetCliente()
      .Add2 cscCliId, m_LastCli, csId
      .Add2 cscCcosId, pGetCentroCosto().HelpId, csId
      .Add2 cscSucId, pGetSucursal().HelpId, csId
      .Add2 cscDocId, pGetDoc(), csId
      .Add2 cscCobzCotizacion, Val(pGetCotizacion().Value), csDouble
      .Add2 cscCobId, pGetCobrador().HelpId, csId
      .Add2 cscLgjId, pGetLegajo().HelpId, csId
      .Add2 cscCobzHojaRuta, CInt(m_isHojaRuta), csBoolean
      
      .Add2 cscCobzNeto, Val(pGetCobroNeto().Value), csCurrency
      .Add2 cscCobzOtros, Val(pGetCobroOtros().Value), csCurrency
      .Add2 cscCobzTotal, Val(pGetCobroTotal().Value), csCurrency
      
      .Add2 cscCobzGrabarAsiento, 1, csBoolean
      .Add2 cscEstId, CSGeneralEx2.csEEstado.csEEst_Pendiente, csId
      .Add2 cscCobzId, csNew, csLong
      
      .HaveLastUpdate = True
      .HaveWhoModify = True
    
    End With
        
    If Not .BeginTrans(gDB) Then Exit Function
    
    If Not gDB.Save(register, , "pSave", C_Module, c_ErrorSave) Then Exit Function
    
    m_iOrden = 0
    If Not pSaveCheques(.Id) Then Exit Function
    If Not pSaveEfectivo(.Id) Then Exit Function
    If Not pSaveTarjetas(.Id) Then Exit Function
    If Not pSaveOtros(.Id) Then Exit Function
    If Not pSaveCtaCte(.Id) Then Exit Function
    If Not pSaveFacturas(.Id, Aplicado) Then Exit Function
    
    If Not pSaveDifCambio(.Id, Aplicado) Then Exit Function
    
    If Not .CommitTrans() Then Exit Function
  
  End With
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocCobranzaSave " & register.Id
  If Not gDB.OpenRs(sqlstmt, rs, , , , "pSave", C_Module, c_ErrorSave) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim Id As Long
  If Not GetDocIDFromRecordset(rs, Id) Then Exit Function
  
  m_Id = Id
  
  pSave = m_Id <> 0
End Function

Private Function pSaveCheques(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  Dim i         As Long
  
  For Each Row In pGetCheques().Rows
    
    i = i + 1
    If Not pIsEmptyRowCheques(Row, i) Then
  
      Set register = New cRegister
      
      With register
        
        .fieldId = cscCobziTMPId
        .Table = csTCobranzaItemTMP
        .Id = csNew
      
        With .Fields
        
          For Each Cell In Row
            Select Case Cell.Key
              
              Case KICH_DESCRIP
                .Add2 cscCobziDescrip, Cell.Value, csText
              Case KICH_CHEQUE
                .Add2 cscCobziTMPCheque, Cell.Value, csText
              
              Case KICH_CLE_ID
                .Add2 cscCleId, Cell.Id, csId
              Case KICH_BCO_ID
                .Add2 cscBcoId, Cell.Id, csId
              Case KICH_MON_ID
                .Add2 cscMonId, Cell.Id, csId
              Case KICH_FECHACOBRO
                .Add2 cscCobziTMPFechaCobro, Cell.Value, csDate
              Case KICH_FECHAVTO
                .Add2 cscCobziTMPFechaVto, Cell.Value, csDate
              
              Case KICH_CUE_ID
                .Add2 cscCueId, Cell.Id, csId
              Case KICH_IMPORTEORIGEN
                .Add2 cscCobziImporteOrigen, Val(Cell.Value), csCurrency
              Case KICH_IMPORTE
                .Add2 cscCobziImporte, Val(Cell.Value), csCurrency
              Case KICH_PROPIO
                .Add2 cscCobziTMPPropio, Cell.Id, csBoolean
            End Select
          Next
          
          m_iOrden = m_iOrden + 1
          .Add2 cscCobziOrden, m_iOrden, csInteger
          .Add2 cscCobziTipo, csECobranzaItemTipo.csECobziTCheques, csInteger
          .Add2 cscCobzTMPId, Id, csId
          .Add2 cscCobziId, csNew, csLong
          .Add2 cscCobziOtroTipo, csEItemOtroTipo.csEOtroDebe, csInteger
          
          .HaveLastUpdate = False
          .HaveWhoModify = False
        
        End With
      End With
                                                            
      If Not gDB.Save(register, , "pSaveCheques", C_Module, c_ErrorSave) Then Exit Function
    End If
  Next
  
  pSaveCheques = True
End Function

Private Function pSaveFacturas(ByVal Id As Long, _
                               ByRef Aplicado As Double) As Boolean
                               
  Dim register        As cRegister
  Dim bSave           As Boolean
  Dim Row             As cIABMGridRow
  Dim Cell            As cIABMGridCellValue
  Dim Pago            As Double
  Dim CotiOrigen      As Double
  Dim CotiCobranza    As Double
  
  Dim MaxPago         As Double
  
  '-------------------------------------------------
  ' Aplicacion de Diferencias de cambio
  '
  Dim AplicarND As Boolean
  
  AplicarND = pGetAplicDifCambio().ListItemData = csEAplicacionDifCambio.csEDifAplicacionND
  
  '-------------------------------------------------
  ' Determinamos la aplicacion de cada factura
  '
  For Each Row In pGetFacturas().Rows
  
    Set register = New cRegister
    
    With register
    
      .fieldId = cscFvCobzTMPid
      .Table = csTFacturaVentaCobranzaTMP
      .Id = csNew
        
      bSave = False
      
      With .Fields
      
        For Each Cell In Row
          If pCell(Row, KI_SELECT).Id Then
            bSave = True
            Select Case Cell.Key
              Case KI_FV_ID
                .Add2 cscFvId, Cell.Id, csId
              Case KI_FVD_ID
                .Add2 cscFvdId, Cell.Id, csId
              Case KI_APLICAR
                Pago = Val(Cell.Value)
              Case KI_IMPORTEORIGEN
                .Add2 cscFvCobzImporteOrigen, Val(Cell.Value), csDouble
              Case KI_COTIZACION
                CotiOrigen = Val(Cell.Value)
              Case KI_COTIZACION2
                CotiCobranza = Val(Cell.Value)
                .Add2 cscFvCobzCotizacion, CotiCobranza, csDouble
              Case KI_PENDIENTE
                MaxPago = Val(Cell.Value)
            End Select
          End If
        Next
        
        If bSave Then
        
          ' Si hay diferencia de cambio y la cotizacion original
          ' del comprobante es menor que la de la cobranza aplico
          ' SIEMPRE por la cotizacion del comprobante
          If CotiOrigen < CotiCobranza Then
            
            ' Si aplica primero sobre la ND por dif. de cambio
            '
            If AplicarND Then
              
              Pago = Pago / CotiCobranza * CotiOrigen
              
            Else
            
              If Pago > MaxPago Then Pago = MaxPago
              
            End If
            
          End If
          
          Aplicado = Aplicado + Pago
          
          .Add2 cscFvCobzImporte, Pago, csDouble
          .Add2 cscFvCobzId, 0, csLong
          .Add2 cscCobzTMPId, Id, csId
          .Add2 cscCobzId, 0, csLong
          
          .HaveLastUpdate = False
          .HaveWhoModify = False
                                                                
          If Not gDB.Save(register, , "pSaveFacturas", C_Module, c_ErrorSave) Then Exit Function
        End If
        
      End With
    End With
  Next
  
  pSaveFacturas = True
End Function

Private Function pSaveTarjetas(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim IProperty As cIABMProperty
        
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  Dim i    As Long
  
  For Each Row In pGetTarjetas().Rows
  
    i = i + 1
    If Not pIsEmptyRowTarjetas(Row, i) Then
    
      Set register = New cRegister
      
      With register
        .fieldId = cscCobziTMPId
        .Table = csTCobranzaItemTMP
        .Id = csNew
        
        With .Fields
          
          For Each Cell In Row
            Select Case Cell.Key
              
              Case KIT_DESCRIP
                .Add2 cscCobziDescrip, Cell.Value, csText
              Case KIT_CUPON
                .Add2 cscCobziTMPCupon, Cell.Value, csText
              Case KIT_TJC_ID
                .Add2 cscTjcId, Cell.Id, csId
              Case KIT_TJCCU_ID
                .Add2 cscTjccuId, Cell.Id, csId
              Case KIT_MON_ID
                .Add2 cscMonId, Cell.Id, csId
              Case KIT_FECHAVTO
                .Add2 cscCobziTMPFechaVto, Cell.Value, csDate
              Case KIT_TITULAR
                .Add2 cscCobziTMPTitular, Cell.Value, csText
              Case KIT_NROTARJETA
                .Add2 cscCobziTMPNroTarjeta, Cell.Value, csText
              Case KIT_NROAUTORIZACION
                .Add2 cscCobziTMPAutorizacion, Cell.Value, csText
              Case KIT_TARJETA_TIPO
                .Add2 cscCobziTarjetaTipo, Cell.Id, csLong
              Case KIT_IMPORTEORIGEN
                .Add2 cscCobziImporteOrigen, Val(Cell.Value), csCurrency
              Case KIT_IMPORTE
                .Add2 cscCobziImporte, Val(Cell.Value), csCurrency
            End Select
          Next
          
          m_iOrden = m_iOrden + 1
          .Add2 cscCobziOrden, m_iOrden, csInteger
          .Add2 cscCobziTipo, csECobranzaItemTipo.csECobziTTarjeta, csInteger
          .Add2 cscCobzTMPId, Id, csId
          .Add2 cscCobziId, csNew, csLong
          .Add2 cscCobziOtroTipo, csEItemOtroTipo.csEOtroDebe, csInteger
          
          .HaveLastUpdate = False
          .HaveWhoModify = False
      
        End With
      End With
                                                            
      If Not gDB.Save(register, , "pSaveTarjetas", C_Module, c_ErrorSave) Then Exit Function
    End If
  Next
  
  pSaveTarjetas = True
End Function

Private Function pSaveOtros(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim IProperty As cIABMProperty
  
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  Dim i    As Long
  
  For Each Row In pGetOtros().Rows
  
    i = i + 1
    If Not pIsEmptyRowOtros(Row, i) Then
    
      Set register = New cRegister
        
      With register
      
        .fieldId = cscCobziTMPId
        .Table = csTCobranzaItemTMP
        .Id = csNew
        
        With .Fields
      
          For Each Cell In Row
            Select Case Cell.Key
              
              Case KIO_DESCRIP
                .Add2 cscCobziDescrip, Cell.Value, csText
              Case KIO_RET_ID
                .Add2 cscRetId, Cell.Id, csId
              Case KIO_NRORETENCION
                .Add2 cscCobziNroRetencion, Cell.Value, csText
              Case KIO_PORCRETENCION
                .Add2 cscCobziPorcRetencion, Val(Cell.Value), csDouble
              Case KIO_CCOS_ID
                .Add2 cscCcosId, Cell.Id, csId
              Case KIO_FV_ID_RET
                .Add2 cscFvIdRet, Cell.Id, csId
              Case KIO_CUE_ID
                .Add2 cscCueId, Cell.Id, csId
              Case KIO_FECHARETENCION
                If Not ValEmpty(Cell.Value, csDate) Then
                  .Add2 cscCobziFechaRetencion, Cell.Value, csDate
                End If
              Case KIO_IMPORTEORIGEN
                .Add2 cscCobziImporteOrigen, Val(Cell.Value), csCurrency
              Case KIO_DEBE
                If Val(Cell.Value) <> 0 Then
                  .Add2 cscCobziImporte, Val(Cell.Value), csCurrency
                  .Add2 cscCobziOtroTipo, csEItemOtroTipo.csEOtroDebe, csInteger
                End If
              Case KIO_HABER
                If Val(Cell.Value) <> 0 Then
                  .Add2 cscCobziImporte, Val(Cell.Value), csCurrency
                  .Add2 cscCobziOtroTipo, csEItemOtroTipo.csEOtroHaber, csInteger
                End If
            End Select
          Next
          
          m_iOrden = m_iOrden + 1
          .Add2 cscCobziOrden, m_iOrden, csInteger
          .Add2 cscCobziTipo, csECobranzaItemTipo.csECobziTOtros, csInteger
          .Add2 cscCobzTMPId, Id, csId
          .Add2 cscCobziId, csNew, csLong
          
          .HaveLastUpdate = False
          .HaveWhoModify = False
      
        End With
      End With
                                                          
      If Not gDB.Save(register, , "pSaveOtros", C_Module, c_ErrorSave) Then Exit Function
    End If
  Next
  
  pSaveOtros = True
End Function

Private Function pSaveEfectivo(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  Dim i         As Long
  
  For Each Row In pGetEfectivo().Rows
  
    i = i + 1
    If Not pIsEmptyRowEfectivo(Row, i) Then
      
      Set register = New cRegister
      
      With register
      
        .fieldId = cscCobziTMPId
        .Table = csTCobranzaItemTMP
        .Id = csNew
      
        With .Fields
        
          For Each Cell In Row
            Select Case Cell.Key
              
              Case KIE_DESCRIP
                .Add2 cscCobziDescrip, Cell.Value, csText
              Case KIE_CUE_ID
                .Add2 cscCueId, Cell.Id, csId
              Case KIE_IMPORTEORIGEN
                .Add2 cscCobziImporteOrigen, Val(Cell.Value), csCurrency
              Case KIE_IMPORTE
                .Add2 cscCobziImporte, Val(Cell.Value), csCurrency
            End Select
          Next
          
          m_iOrden = m_iOrden + 1
          .Add2 cscCobziOrden, m_iOrden, csInteger
          .Add2 cscCobziTipo, csECobranzaItemTipo.csECobziTEfectivo, csInteger
          .Add2 cscCobzTMPId, Id, csId
          .Add2 cscCobziId, csNew, csLong
          .Add2 cscCobziOtroTipo, csEItemOtroTipo.csEOtroDebe, csInteger
          
          .HaveLastUpdate = False
          .HaveWhoModify = False
      
        End With
      End With
                                                            
      If Not gDB.Save(register, , "pSaveEfectivo", C_Module, c_ErrorSave) Then Exit Function
    End If
  Next
  
  pSaveEfectivo = True
End Function

Private Function pSaveCtaCte(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  
  For Each Row In pGetCtaCte().Rows
  
    Set register = New cRegister
    
    With register
      .fieldId = cscCobziTMPId
      .Table = csTCobranzaItemTMP
      .Id = csNew
    
      With .Fields
    
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KICC_CUE_ID
              .Add2 cscCueId, Cell.Id, csId
            Case KICC_IMPORTEORIGEN
              .Add2 cscCobziImporteOrigen, Val(Cell.Value), csCurrency
            Case KICC_IMPORTE
              .Add2 cscCobziImporte, Val(Cell.Value), csCurrency
          End Select
        Next
        
        m_iOrden = m_iOrden + 1
        .Add2 cscCobziOrden, m_iOrden, csInteger
        .Add2 cscCobziTipo, csECobranzaItemTipo.csECobziTCtaCte, csInteger
        .Add2 cscCobzTMPId, Id, csId
        .Add2 cscCobziId, csNew, csLong
        .Add2 cscCobziOtroTipo, csEItemOtroTipo.csEOtroHaber, csInteger
        
        .HaveLastUpdate = False
        .HaveWhoModify = False
    
      End With
    End With
                                                          
    If Not gDB.Save(register, , "pSaveCtaCte", C_Module, c_ErrorSave) Then Exit Function
  Next
  
  pSaveCtaCte = True
End Function

Private Function pSaveDifCambio(ByVal Id As Long, ByVal Aplicado As Double) As Boolean
  If pGetDefaultDifCambio().ListItemData = csEModoDifCambio.csEDifCambioCuenta Then
    pSaveDifCambio = pSaveDifCambioCtaCble(Id)
  Else
    pSaveDifCambio = pSaveDifCambioNCND(Id, Aplicado)
  End If
End Function

Private Function pSaveDifCambioCtaCble(ByVal Id As Long) As Boolean
  Dim register      As cRegister
  Dim IProperty     As cIABMProperty
  Dim Row           As cIABMGridRow
  Dim Cell          As cIABMGridCellValue
  Dim Cobrado       As Double
  Dim DeudaOrigen   As Double
  Dim Diferencia    As Double
  Dim cue_id        As Long
  
  DeudaOrigen = pGetDeudaOrigen
  Cobrado = pGetCobrado
  
  Diferencia = Abs(DeudaOrigen - Cobrado)
  
  If Round(Diferencia, 2) = 0 Then
    pSaveDifCambioCtaCble = True
    Exit Function
  End If
  
  cue_id = pGetCueIdDifCambio().HelpId
  
  If cue_id = csNO_ID Then
    MsgWarning LNGGetText(2153, vbNullString)
    'Debe configurar la cuenta de "Diferencia de Cambio" para que el sistema pueda contabilizar los importes cobrados.
    Exit Function
  End If
  
  Set register = New cRegister
  
  With register
    
    .fieldId = cscCobziTMPId
    .Table = csTCobranzaItemTMP
    .Id = csNew
    
    With .Fields
      
      .Add2 cscCobziDescrip, "Diferencia de cambio", csText
      .Add2 cscCueId, cue_id, csId
      
      If DeudaOrigen > Cobrado Then
        .Add2 cscCobziImporte, DeudaOrigen - Cobrado, csCurrency
        .Add2 cscCobziOtroTipo, csEItemOtroTipo.csEOtroDebe, csInteger
      Else
        .Add2 cscCobziImporte, Abs(DeudaOrigen - Cobrado), csCurrency
        .Add2 cscCobziOtroTipo, csEItemOtroTipo.csEOtroHaber, csInteger
      End If
      
      m_iOrden = m_iOrden + 1
      .Add2 cscCobziOrden, m_iOrden, csInteger
      .Add2 cscCobziTipo, csECobranzaItemTipo.csECobziTOtros, csInteger
      .Add2 cscCobzTMPId, Id, csId
      .Add2 cscCobziId, csNew, csLong
      
      .HaveLastUpdate = False
      .HaveWhoModify = False
    
    End With
  End With
                                                     
  If Not gDB.Save(register, , "pSaveOtros", C_Module, c_ErrorSave) Then Exit Function

  pSaveDifCambioCtaCble = True
End Function

Private Function pSaveDifCambioNCND(ByVal Id As Long, _
                                    ByVal Aplicado As Double) As Boolean
  Dim Cobrado       As Double
  Dim DeudaOrigen   As Double
  Dim Diferencia    As Double
  Dim FvTMPId       As Long
  
  DeudaOrigen = pGetDeudaOrigen
  Cobrado = pGetCobrado
  
  Diferencia = Abs(DeudaOrigen - Cobrado)
  
  If Round(Diferencia, 2) = 0 Then
    pSaveDifCambioNCND = True
    Exit Function
  End If
  
  ' Nota de debito
  If DeudaOrigen < Cobrado Then
  
    If Not pSaveDocVta(Id, pGetNDDifCambio().HelpId, Diferencia, True, FvTMPId) Then Exit Function
    
    ' Agrego la nota de debito a la coleccion de
    ' aplicaciones con la cobranza
    '
    If Not pSaveCobranzaND(Id, FvTMPId, Diferencia, Aplicado) Then Exit Function
  
  ' Nota de credito
  Else
  
    If Not pSaveDocVta(Id, pGetNCDifCambio().HelpId, Diferencia, False, FvTMPId) Then Exit Function
    
    ' Aplico la nota de credito con cada una de las
    ' facturas que generaron diferencias de cambio
    '
    If Not pSaveFacturaVentaNotaCredito(FvTMPId, Diferencia) Then Exit Function
  
  End If
  
  pSaveDifCambioNCND = True
End Function

Private Function pGetNCNDDocNumber(ByVal DocId As Long) As String
  Dim Tl          As cTalonario
  Dim TAL_ID      As Long
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  Dim Mask        As String
  Dim rtn         As String
  
  If DocId = csNO_ID Then
  
    Err.Raise -1, , LNGGetText(2154, vbNullString)
    
                    '"@@ERROR_SP:Debe configurar un documento " & _
                    "para las notas de crédito/debito que se generan automaticamente.;;" & _
                    "Debe indicar estos documentos en el paso anterior para poder guardar esta cobranza." & _
                    ";;Utilize la opción [Configuracion\Tesoreria\General] " & _
                    "en la solapa [Diferencia de Cambio] para indicar los documentos por defecto " & _
                    "y evitará tener que indicarlos en cada cobranza."
    
  End If
  
  sqlstmt = "sp_clienteGetTalonario " & pGetCliente() & "," & DocId
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then
  
    Err.Raise -1, , LNGGetText(2155, vbNullString)
          '@@ERROR_SP:No fue posible encontrar el talonario asociado al documento para notas de debito/crédito que se generan automaticamente.
    
  End If
  
  TAL_ID = gDB.ValField(rs.Fields, 0)
  
  Set Tl = New cTalonario
  
  rtn = Tl.GetNextNumber(TAL_ID, Mask, False)
  If LenB(Mask) Then Mask = Mid(Mask, 1, Len(Mask) - Len(rtn))
  pGetNCNDDocNumber = Mask & rtn
End Function

Private Function pSaveDocVta(ByVal CobzTMPId As Long, _
                             ByVal DocId As Long, _
                             ByVal Diferencia As Double, _
                             ByVal bIsND As Boolean, _
                             ByRef FvTMPId As Long) As Boolean
  Dim register     As cRegister
  Dim Neto         As Double
  Dim IvaRi        As Double
  Dim vIva()       As T_Iva
  Dim vItems()     As T_Item
  
  If Not pGetIva(vIva) Then Exit Function
  If Not pGetItems(vIva, vItems, Diferencia, bIsND, Neto, IvaRi) Then Exit Function

  Set register = New cRegister
  
  With register
    .fieldId = cscFvTMPId
    .Table = csTFacturaVentaTMP
    .Id = csNew
  
    With .Fields
    
      .Add2 cscFvId, csNew, csLong
      .Add2 cscCobzTMPId, CobzTMPId, csId
    
      .Add2 cscFvNumero, 0, csLong
      .Add2 cscFvNrodoc, pGetNCNDDocNumber(DocId), csText
      
      .Add2 cscFvDescrip, pGetDescripNDNC(), csText
      .Add2 cscFvFecha, pGetFechaNdNc().Value, csDate
      .Add2 cscFvFechaentrega, pGetFecha().Value, csDate
      .Add2 cscCliId, pGetCliente(), csId
      .Add2 cscSucId, pGetSucursal().HelpId, csId
      .Add2 cscDocId, DocId, csId
      .Add2 cscCpgId, csECpgTipo.csECpgT_FechaDocumento, csId
      .Add2 cscLgjId, pGetLegajo().HelpId, csId
       
      .Add2 cscFvNeto, Neto, csCurrency
      .Add2 cscFvSubtotal, Neto, csCurrency
      .Add2 cscFvIvari, IvaRi, csCurrency
    
      .Add2 cscFvTotal, Neto + IvaRi, csCurrency
      .Add2 cscFvGrabarAsiento, 1, csBoolean
      .Add2 cscEstId, CSGeneralEx2.csEEstado.csEEst_Pendiente, csId
    
      .HaveLastUpdate = True
      .HaveWhoModify = True
    End With
    
    Dim c_ErrorSave As String
    
    If bIsND Then
      c_ErrorSave = LNGGetText(2156, vbNullString)  ' Error al grabar la Nota de Débito
    Else
      c_ErrorSave = LNGGetText(2157, vbNullString)  ' Error al grabar la Nota de Crédito
    End If
    
    If Not .BeginTrans(gDB) Then Exit Function
   
    If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
    If Not pSaveItemsNCND(.Id, vItems(), c_ErrorSave) Then Exit Function
    If Not .CommitTrans() Then Exit Function
  
    FvTMPId = .Id
    
  End With

  pSaveDocVta = True
End Function

Private Function pSaveItemsNCND(ByVal Id As Long, _
                                ByRef vItems() As T_Item, _
                                ByVal strError As String) As Boolean
  Dim register      As cRegister
  Dim Fields        As cFields
  Dim iOrden        As Long
  Dim PR_ID         As Long
  Dim cue_id        As Long
  Dim cue_id_ivari  As Long
  
  Set register = New cRegister
  
  With register
    
    Set Fields = .Fields
    .fieldId = cscFviTMPId
    .Table = csTFacturaVentaItemTMP
  
    PR_ID = pGetPrIdDifCambio().HelpId
    If Not pGetCuentas(PR_ID, cue_id, cue_id_ivari) Then Exit Function
  
      For iOrden = 1 To UBound(vItems)
        With vItems(iOrden)
          Fields.Add2 cscFviId, csNew, csInteger
          Fields.Add2 cscFviCantidad, 1, csDouble
          Fields.Add2 cscFviPrecio, .importe, csCurrency
          Fields.Add2 cscFviPrecioUsr, .importe, csCurrency
          Fields.Add2 cscFviNeto, .importe, csCurrency
          Fields.Add2 cscFviIvari, .ImporteIva, csCurrency
          Fields.Add2 cscFviIvariporc, .TasaIva, csDouble
          Fields.Add2 cscPrId, PR_ID, csId
          Fields.Add2 cscFviImporte, .importe + .ImporteIva, csCurrency
          Fields.Add2 cscCueId, cue_id, csId
          Fields.Add2 cscCueIdIvaRI, cue_id_ivari, csId
          Fields.Add2 cscFviOrden, iOrden, csInteger
          Fields.Add2 cscFvTMPId, Id, csId
        End With
      
        .Id = csNew
      
        With .Fields
          .HaveLastUpdate = False
          .HaveWhoModify = False
        End With
      
        If Not gDB.Save(register, , "pSaveItems", C_Module, strError) Then Exit Function
      
        .Fields.Clear
      
      Next
      
  End With

  pSaveItemsNCND = True
End Function

Private Function pGetItems(ByRef vIva() As T_Iva, ByRef vItems() As T_Item, _
                           ByVal Diferencia As Double, _
                           ByVal bIsND As Boolean, _
                           ByRef Neto As Double, _
                           ByRef TotalIva As Double) As Boolean
  Dim i           As Long
  Dim Iva         As Double
  Dim base        As Double
  Dim ModoIva     As csEModoIvaDifCambio
  Dim importe     As Double
  Dim ImporteIva  As Double
  
  ReDim vItems(UBound(vIva))
  ModoIva = pGetModoIvaDifCambio().ListItemData
  
  Neto = 0
  TotalIva = 0
  
  For i = 1 To UBound(vIva)
    Iva = Iva + vIva(i).importe
  Next i
  
  ' Solo voy hasta el anteultimo
  ' El ultimo me lo reservo para liquidar lo
  ' que quede de la diferencia y me evito problemas
  ' de redondeo
  For i = 1 To UBound(vIva) - 1
    
    ' Porcentaje del Neto imponible para cada tasa de iva
    base = Diferencia * DivideByCero(vIva(i).importe, Iva)
    
    ' Si hay que usar el iva como base imponible y se trata
    ' de una nota de debito
    If ModoIva = csEDifIvaImponible And bIsND Then
      ImporteIva = base * vIva(i).porcentaje / 100
      importe = base
    
    ' Si es una nota de credito o no hay que usar el iva como
    ' base imponible
    Else
      importe = base / (1 + vIva(i).porcentaje / 100)
      ImporteIva = importe * vIva(i).porcentaje / 100
    End If
  
    With vItems(i)
      .importe = importe
      .ImporteIva = ImporteIva
      .TasaIva = vIva(i).porcentaje
    End With
    
    Neto = Neto + importe
    TotalIva = TotalIva + ImporteIva
  Next
  
  ' Si la diferencia es distinta del neto y use el iva como base imponible y es una nota de debito
  ' o
  ' si la diferencia es distinta del neto mas el iva y
  '         (no tome el iva como base imponible o es una nota de credito) -> {en ambos casos no se toma el iva como base imponible}
  '
  If (Diferencia <> Neto And ModoIva = csEDifIvaImponible And bIsND) Or _
     (Diferencia <> Neto + ImporteIva And (ModoIva = csEDifIvaNoImponible Or Not bIsND)) Then
     
    i = UBound(vIva)
  
    If ModoIva = csEDifIvaImponible And bIsND Then
      ' Porcentaje del Neto imponible para cada tasa de iva
      base = Diferencia - Neto
    
    Else '(ModoIva = csEDifIvaNoImponible Or Not bIsND)
      base = Diferencia - Neto - TotalIva
    End If
    
    ' Si hay que usar el iva como base imponible y se trata
    ' de una nota de debito
    If ModoIva = csEDifIvaImponible And bIsND Then
      ImporteIva = base * vIva(i).porcentaje / 100
      importe = base
    
    ' Si es una nota de credito o no hay que usar el iva como
    ' base imponible
    Else
      importe = base / (1 + vIva(i).porcentaje / 100)
      ImporteIva = importe * vIva(i).porcentaje / 100
    End If
  
    With vItems(i)
      .importe = importe
      .ImporteIva = ImporteIva
      .TasaIva = vIva(i).porcentaje
    End With
    
    Neto = Neto + importe
    TotalIva = TotalIva + ImporteIva
  End If
  
  pGetItems = True
End Function

Private Function pGetIva(ByRef vIva() As T_Iva) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim FvIds   As String
  Dim i       As Long
  
  ReDim vIva(0)
  
  FvIds = pGetFvIds()
  sqlstmt = "select fvi_ivariporc, sum(fvi_ivari) as fvi_ivari" & _
            " from FacturaVentaItem" & _
            " where fv_id in(" & FvIds & ")" & _
            " group by fvi_ivariporc " & _
            " order by fvi_ivariporc desc"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    rs.MoveLast
    rs.MoveFirst
    ReDim vIva(rs.RecordCount)
  End If
  
  While Not rs.EOF
    i = i + 1
    With vIva(i)
      .importe = gDB.ValField(rs.Fields, cscFviIvari)
      .porcentaje = gDB.ValField(rs.Fields, cscFviIvariporc)
    End With
    rs.MoveNext
  Wend
  pGetIva = True
End Function

Private Function pGetFvIds() As String
  Dim rtn As String
  Dim Row As cIABMGridRow
  
  For Each Row In pGetFacturas().Rows
    If pCell(Row, KI_SELECT).Id Then
      If Val(pCell(Row, KI_APLICAR).Value) Then
        rtn = rtn & pCell(Row, KI_FV_ID).Id & ","
      End If
    End If
  Next
  
  pGetFvIds = RemoveLastColon(rtn)
End Function

' Proposito: Vincula la nota de debito por dif. de cambio con la cobranza
'
Private Function pSaveCobranzaND(ByVal Id As Long, _
                                 ByVal FvTMPId As Long, _
                                 ByVal importe As Double, _
                                 ByVal Aplicado As Double) As Boolean
                                 
  Dim Aplicar As Double
  
  ' Vemos cuanta guita queda sin aplicar
  '
  Aplicar = Val(pGetCobroTotal().Value) - Aplicado
  
  '
  ' Solo aplicamos si queda algo de guita
  '
  If Aplicar > 0 Then
                                 
    If importe > Aplicar Then
      importe = Aplicar
    End If
                                 
    Dim register        As cRegister
    
    Set register = New cRegister
    
    With register
      .fieldId = cscFvCobzTMPid
      .Table = csTFacturaVentaCobranzaTMP
      .Id = csNew
    
      With .Fields
      
        .Add2 cscFvId, FvTMPId * -1, csId ' Indica que se trata de una ND aun
                                          ' no generada el sp_DocCobranzaSave
                                          ' Graba la ND y luego la vincula con
                                          ' la cobranza
                                          '
        .Add2 cscFvdId, -1, csId ' Indica que la deuda sera generada
                                 ' por el sp_DocCobranzaSave
                                 '
        
        .Add2 cscFvCobzImporte, importe, csDouble
        .Add2 cscFvCobzId, 0, csLong
        .Add2 cscCobzTMPId, Id, csId
        .Add2 cscCobzId, 0, csLong
        
        .HaveLastUpdate = False
        .HaveWhoModify = False
        
      End With
    End With
                                                            
    If Not gDB.Save(register, , "pSaveCobranzaND", C_Module, c_ErrorSave) Then Exit Function
  
  End If
  
  pSaveCobranzaND = True
End Function

' Proposito: Vincular la nota de credito por dif. de cambio con las facturas de
'            esta cobranza
Private Function pSaveFacturaVentaNotaCredito(ByVal FvTMPId As Long, ByVal importe As Double) As Boolean
  Dim Row         As cIABMGridRow
  Dim ACobrar     As Double
  Dim Cobrado     As Double
  Dim Diferencia  As Double
  
  ' Por cada factura con diferencia de cambio
  ' aplico contra esta nota de credito
  For Each Row In pGetFacturas.Rows
    
    If pCell(Row, KI_MONEDA).Id <> m_MonDefault Then
    
      Cobrado = Val(pCell(Row, KI_APLICAR).Value)
                ' (Cobrado dividido la cotizacion a la que estoy cobrando) por la cotizacion de la factura
      
      ACobrar = DivideByCero(Cobrado, Val(pCell(Row, KI_COTIZACION2).Value)) * Val(pCell(Row, KI_COTIZACION).Value)
    
      Diferencia = ACobrar - Cobrado
      If importe < Diferencia Then Diferencia = importe
      
      If Not pSaveFVNCAux(FvTMPId, pCell(Row, KI_FV_ID).Id, pCell(Row, KI_FVD_ID).Id, Diferencia) Then Exit Function
      
      importe = importe - Diferencia
      
      If importe <= 0 Then Exit For
    End If
  Next
  
  pSaveFacturaVentaNotaCredito = True
End Function

Private Function pSaveFVNCAux(ByVal FvTMPId As Long, ByVal FvIdFactura As Long, ByVal FvdIdFactura As Long, ByVal importe As Double) As Boolean
  Dim register        As cRegister
  
  Set register = New cRegister
  
  With register
    
    .fieldId = cscFvNcTMPid
    .Table = csTFacturaVentaNotaCreditoTMP
    .Id = csNew
    
    With .Fields
  
      .Add2 cscFvTMPId, FvTMPId, csId
      
      ' Indica que se trata de una NC aun
      ' no generada el sp_DocCobranzaSave
      ' Graba la NC y luego la vincula con
      ' las facturas
      '
      .Add2 cscFvIdNotaCredito, FvTMPId * -1, csId
      
      ' Indica que la deuda sera generada
      ' por el sp_DocCobranzaSave
      '
      .Add2 cscFvdIdNotaCredito, -1, csId
    
      .Add2 cscFvIdFactura, FvIdFactura, csId
      .Add2 cscFvdIdFactura, FvdIdFactura, csId
      .Add2 cscFvNcImporte, importe, csDouble
      .Add2 cscFvNcId, 0, csLong
      
      .HaveLastUpdate = False
      .HaveWhoModify = False
  
    End With
  End With
                                                          
  If Not gDB.Save(register, , "pSaveFVNCAux", C_Module, c_ErrorSave) Then Exit Function
  
  pSaveFVNCAux = True
End Function

Private Function pGetCuentas(ByVal PR_ID As Long, ByRef cue_id As Long, cue_id_ivari As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim ti_id   As Long
  Dim cueg_id As Long
  
  sqlstmt = "select cueg_id_venta, ti_id_ivariventa from producto where pr_id = " & PR_ID
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If Not rs.EOF Then
    cueg_id = gDB.ValField(rs.Fields, "cueg_id_venta")
    ti_id = gDB.ValField(rs.Fields, cscPrTiIdRiVenta)
    
    sqlstmt = "select cue_id from ClienteCuentaGrupo where cli_id = " & pGetCliente() & " and cueg_id = " & cueg_id
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    If Not rs.EOF Then
      cue_id = gDB.ValField(rs.Fields, cscCueId)
    Else
      sqlstmt = "select cue_id from CuentaGrupo where cueg_id = " & cueg_id
      If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
      If Not rs.EOF Then
        cue_id = gDB.ValField(rs.Fields, cscCueId)
      Else
        MsgWarning LNGGetText(2158, vbNullString, cueg_id)
          'No se pudo encontrar el grupo de cuentas con id  & cueg_id &  para que el Cairo pueda grabar la Nota de Débito/Crédito automáticamente.
        Exit Function
      End If
    End If
  Else
    MsgWarning LNGGetText(2159, vbNullString)
      'Debe configurar el artículo "Diferencia de Cambio" en "Configuración > Tesorería > General", para que Cairo pueda grabar la Nota de Débito/Crédito automáticamente.
    Exit Function
  End If
  
  sqlstmt = "select cue_id from TasaImpositiva where ti_id = " & ti_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If Not rs.EOF Then cue_id_ivari = gDB.ValField(rs.Fields, cscCueId)
  
  pGetCuentas = True
End Function

#If Not PREPROC_SFS Then
  Private Sub pSetObjectForm()
    Dim AbmGen      As cABMGenericDocEx
    Dim WizGen      As cWizardGenericDocEx
    
    Set WizGen = m_ObjWizard
    Set AbmGen = WizGen.ObjAbm
    
    With AbmGen
      .FactoryObject = "CSABMInterface2.cFactory"
      .ObjForm = "CSABMInterface2.fwCobranza"
    End With
  End Sub
#End If

'///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Private Function pGetMonedaAnticipo() As cIABMProperty
  Set pGetMonedaAnticipo = GetWizProperty(m_ObjWizard, _
                                    c_StepAnticipo, _
                                    c_Wiz_Key_MonedaAnticipo)
End Function

Private Function pGetCuentaAnticipo() As cIABMProperty
  Set pGetCuentaAnticipo = GetWizProperty(m_ObjWizard, _
                                    c_StepAnticipo, _
                                    c_Wiz_Key_CuentaAnticipo)
End Function

Private Function pGetCobroIndicado() As cIABMProperty
  Set pGetCobroIndicado = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectCobros, _
                                      c_Wiz_Key_CobroIndicado)
End Function

Private Function pGetCobroNeto() As cIABMProperty
  Set pGetCobroNeto = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectCobros, _
                                      c_Wiz_Key_CobroNeto)
End Function

Private Function pGetCobroOtros() As cIABMProperty
  Set pGetCobroOtros = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectCobros, _
                                      c_Wiz_Key_CobroOtros)
End Function

Private Function pGetCobroTotal() As cIABMProperty
  Set pGetCobroTotal = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectCobros, _
                                      c_Wiz_Key_CobroTotal)
End Function

Private Function pGetTotal() As cIABMProperty
  Set pGetTotal = GetWizProperty(m_ObjWizard, _
                                    c_StepSelectFactura, _
                                    c_Wiz_Key_TotalPago)
End Function

Private Function pGetTotalOrigen() As cIABMProperty
  Set pGetTotalOrigen = GetWizProperty(m_ObjWizard, _
                                    c_StepSelectFactura, _
                                    c_Wiz_Key_TotalPagoOrigen)
End Function

Private Function pGetCliente2() As cIABMProperty
  Set pGetCliente2 = GetWizProperty(m_ObjWizard, _
                                c_StepDatosGenerales, _
                                c_Wiz_Key_Cliente2)
End Function

Private Function pGetClienteProperty() As cIABMProperty
  Set pGetClienteProperty = GetWizProperty(m_ObjWizard, _
                                c_StepSelectCliente, _
                                c_Wiz_Key_Cliente)
End Function

Private Function pGetCliente() As Long
  pGetCliente = GetWizProperty(m_ObjWizard, _
                           c_StepSelectCliente, _
                           c_Wiz_Key_Cliente).HelpId
End Function

Private Function pGetClienteName() As String
  pGetClienteName = GetWizProperty(m_ObjWizard, _
                           c_StepSelectCliente, _
                           c_Wiz_Key_Cliente).Value
End Function

' Edit From ListDoc
'
Private Function pGetOnlySelected() As cIABMProperty
  Set pGetOnlySelected = GetWizProperty(m_ObjWizard, _
                           c_StepSelectCliente, _
                           c_Wiz_Key_OnlySelected)
End Function

Private Function pGetCheques() As cIABMGrid
  Set pGetCheques = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectCobros, _
                                      c_Wiz_Key_Cheques).Grid
End Function

Private Function pGetChequesProperty() As cIABMProperty
  Set pGetChequesProperty = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectCobros, _
                                      c_Wiz_Key_Cheques)
End Function

Private Function pGetTarjetas() As cIABMGrid
  Set pGetTarjetas = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectCobros, _
                                      c_Wiz_Key_Tarjetas).Grid
End Function

Private Function pGetTarjetasProperty() As cIABMProperty
  Set pGetTarjetasProperty = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectCobros, _
                                      c_Wiz_Key_Tarjetas)
End Function

Private Function pGetEfectivo() As cIABMGrid
  Set pGetEfectivo = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectCobros, _
                                      c_Wiz_Key_Efectivo).Grid
End Function

Private Function pGetEfectivoProperty() As cIABMProperty
  Set pGetEfectivoProperty = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectCobros, _
                                      c_Wiz_Key_Efectivo)
End Function

Private Function pGetOtros() As cIABMGrid
  Set pGetOtros = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectCobros, _
                                      c_Wiz_Key_Otros).Grid
End Function

Private Function pGetOtrosProperty() As cIABMProperty
  Set pGetOtrosProperty = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectCobros, _
                                      c_Wiz_Key_Otros)
End Function

Private Function pGetFacturas() As cIABMGrid
  Set pGetFacturas = GetWizProperty(m_ObjWizard, _
                                    c_StepSelectFactura, _
                                    c_Wiz_Key_Factuas).Grid
End Function

Private Function pGetCtaCte() As cIABMGrid
  Set pGetCtaCte = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectCobros, _
                                      c_Wiz_Key_CtaCte).Grid
End Function

Private Function pGetFacturasProperty() As cIABMProperty
  Set pGetFacturasProperty = GetWizProperty(m_ObjWizard, _
                                    c_StepSelectFactura, _
                                    c_Wiz_Key_Factuas)
End Function

Private Function pGetCtaCteProperty() As cIABMProperty
  Set pGetCtaCteProperty = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectCobros, _
                                      c_Wiz_Key_CtaCte)
End Function

Private Sub pRefreshFacturas()
  m_ObjWizard.ShowValue GetWizProperty(m_ObjWizard, _
                                        c_StepSelectFactura, _
                                        c_Wiz_Key_Factuas)
End Sub

Private Sub pRefreshCtaCte()
  m_ObjWizard.ShowValue GetWizProperty(m_ObjWizard, _
                                      c_StepSelectCobros, _
                                      c_Wiz_Key_CtaCte)
End Sub

Private Function pGetComprobante() As cIABMProperty
  Set pGetComprobante = GetWizProperty(m_ObjWizard, _
                                c_StepDatosGenerales, _
                                c_Wiz_Key_Comprobante)
End Function

Private Function pGetCobrador() As cIABMProperty
  Set pGetCobrador = GetWizProperty(m_ObjWizard, _
                                c_StepDatosGenerales, _
                                c_Wiz_Key_Cobrador)
End Function

Private Function pGetLegajo() As cIABMProperty
  Set pGetLegajo = GetWizProperty(m_ObjWizard, _
                                c_StepDatosGenerales, _
                                c_Wiz_Key_Legajo)
End Function

Private Function pGetDescrip() As cIABMProperty
  Set pGetDescrip = GetWizProperty(m_ObjWizard, _
                                c_StepDatosGenerales, _
                                c_Wiz_Key_Observaciones)
End Function

Private Function pGetCentroCosto() As cIABMProperty
  Set pGetCentroCosto = GetWizProperty(m_ObjWizard, _
                                c_StepDatosGenerales, _
                                c_Wiz_Key_CentroCosto)
End Function

Private Function pGetSucursal() As cIABMProperty
  Set pGetSucursal = GetWizProperty(m_ObjWizard, _
                                c_StepDatosGenerales, _
                                c_Wiz_Key_Sucursal)
End Function

Private Function pGetFecha() As cIABMProperty
  Set pGetFecha = GetWizProperty(m_ObjWizard, _
                                c_StepDatosGenerales, _
                                c_Wiz_Key_Fecha)
End Function

Private Function pGetFechaNdNc() As cIABMProperty
  Set pGetFechaNdNc = GetWizProperty(m_ObjWizard, _
                                c_StepDifCambio, _
                                c_Wiz_Key_FechaNDNC)
End Function

Private Function pGetDoc() As Long
  pGetDoc = GetWizProperty(m_ObjWizard, _
                           c_StepSelectCliente, _
                           c_Wiz_Key_Doc).HelpId
End Function

Private Function pGetDocName() As String
  pGetDocName = GetWizProperty(m_ObjWizard, _
                           c_StepSelectCliente, _
                           c_Wiz_Key_Doc).Value
End Function

Private Function pGetVencidos() As Long
  pGetVencidos = Val(GetWizProperty(m_ObjWizard, _
                                    c_StepSelectFactura, _
                                    c_Wiz_Key_Vencidos).Value)
End Function

Private Function pGetTodos() As cIABMProperty
  Set pGetTodos = GetWizProperty(m_ObjWizard, _
                                    c_StepSelectFactura, _
                                    c_Wiz_Key_Todos)
End Function

Private Function pGetAgrupados() As Long
  pGetAgrupados = Val(GetWizProperty(m_ObjWizard, _
                                    c_StepSelectFactura, _
                                    c_Wiz_Key_Agrupados).Value)
End Function

Private Function pGetCotizacion() As cIABMProperty
  Set pGetCotizacion = GetWizProperty(m_ObjWizard, _
                                    c_StepSelectFactura, _
                                    c_Wiz_Key_Cotizacion)
End Function

Private Function pGetCotizacionAnticipo() As cIABMProperty
  Set pGetCotizacionAnticipo = GetWizProperty(m_ObjWizard, _
                                    c_StepAnticipo, _
                                    c_Wiz_Key_CotizacionAnticipo)
End Function

Private Function pGetAnticipo() As cIABMProperty
  Set pGetAnticipo = GetWizProperty(m_ObjWizard, _
                                    c_StepSelectFactura, _
                                    c_Wiz_Key_Anticipo)
End Function

Private Function pGetAnticipoImporte() As cIABMProperty
  Set pGetAnticipoImporte = GetWizProperty(m_ObjWizard, _
                                    c_StepAnticipo, _
                                    c_Wiz_Key_AnticipoImporte)
End Function

Private Function pGetLabelCobros() As cIABMProperty
  Set pGetLabelCobros = GetWizProperty(m_ObjWizard, _
                                    c_StepSelectCobros, _
                                    c_LabelCobros)
End Function

' Diferencias de cambio
Private Function pGetModoIvaDifCambio() As cIABMProperty
  Set pGetModoIvaDifCambio = GetWizProperty(m_ObjWizard, _
                                          c_StepDifCambio, _
                                          c_Wiz_Key_ModoIvaDifCambio)
End Function

Private Function pGetAplicDifCambio() As cIABMProperty
  Set pGetAplicDifCambio = GetWizProperty(m_ObjWizard, _
                                          c_StepDifCambio, _
                                          c_Wiz_Key_AplicacionND)
End Function

Private Function pGetDefaultDifCambio() As cIABMProperty
  Set pGetDefaultDifCambio = GetWizProperty(m_ObjWizard, _
                                          c_StepDifCambio, _
                                          c_Wiz_Key_DefaultDifCambio)
End Function

Private Function pGetCueIdDifCambio() As cIABMProperty
  Set pGetCueIdDifCambio = GetWizProperty(m_ObjWizard, _
                                          c_StepDifCambio, _
                                          c_Wiz_Key_CueIdDifCambio)
End Function

Private Function pGetNCDifCambio() As cIABMProperty
  Set pGetNCDifCambio = GetWizProperty(m_ObjWizard, _
                                          c_StepDifCambio, _
                                          c_Wiz_Key_NCDifCambio)
End Function

Private Function pGetNDDifCambio() As cIABMProperty
  Set pGetNDDifCambio = GetWizProperty(m_ObjWizard, _
                                          c_StepDifCambio, _
                                          c_Wiz_Key_NDDifCambio)
End Function

Private Function pGetPrIdDifCambio() As cIABMProperty
  Set pGetPrIdDifCambio = GetWizProperty(m_ObjWizard, _
                                          c_StepDifCambio, _
                                          c_Wiz_Key_PrIdDifCambio)
End Function

Private Sub pNewEmptyProperties()
  ' (ByRef Grid As cIABMGrid)
  pGetAnticipo().Value = 0
  
  pGetFacturas().Rows.Clear
  pGetOtros().Rows.Clear
  pGetCheques().Rows.Clear
  pGetEfectivo().Rows.Clear
  pGetTarjetas().Rows.Clear
  pGetCtaCte().Rows.Clear
  
  pGetCobroNeto().Value = 0
  pGetCobroOtros().Value = 0
  pGetCobroTotal().Value = 0
  
  With pGetClienteProperty()
    .HelpId = m_Cli_idDoc
    .Value = m_ClienteDoc
  End With
  
  With pGetCliente2()
    .HelpId = m_Cli_idDoc
    .Value = m_ClienteDoc
  End With
  
  With pGetComprobante()
    .Value = vbNullString
    .TextMask = vbNullString
  End With
  With pGetCentroCosto()
    .HelpId = csNO_ID
    .Value = vbNullString
  End With
  pGetDescrip().Value = vbNullString
  
  With m_ObjWizard
  
    .ShowValue pGetClienteProperty()
    .ShowValue pGetCliente2()
    .ShowValue pGetFacturasProperty()
    .ShowValue pGetOtrosProperty()
    .ShowValue pGetChequesProperty()
    .ShowValue pGetEfectivoProperty()
    .ShowValue pGetTarjetasProperty()
    .ShowValue pGetCtaCteProperty()
    .ShowValue pGetAnticipo()
    .ShowValue pGetCobroNeto()
    .ShowValue pGetCobroOtros()
    .ShowValue pGetCobroTotal()
    .ShowValue pGetComprobante()
    .ShowValue pGetCentroCosto()
    .ShowValue pGetDescrip()
  End With
  
End Sub

Private Function pGetDescripNDNC() As String
  Dim Facturas As String
  Dim cobranza As String
  
  Dim Row           As cIABMGridRow
  Dim Total         As Double
  
  For Each Row In pGetFacturas().Rows
    If Val(pCell(Row, KI_APLICAR).Value) Then
      Facturas = Facturas & pCell(Row, KI_NRODOC).Value & ","
    End If
  Next
  
  Facturas = RemoveLastColon(Facturas)
  cobranza = pGetComprobante().Value
  
  pGetDescripNDNC = c_NCNDDescripDifCambio & vbCrLf & vbCrLf & _
                  LNGGetText(2483, vbNullString, cobranza, Facturas)
End Function

Private Sub pSetDatosFromAplic()
  Dim sqlstmt           As String
  Dim rs                As Recordset
  Dim i                 As Long
  
  sqlstmt = "sp_DocCobranzaGetDataFromAplic 1,'" & pGetFvIds & "'"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Dim iProp As cIABMProperty
  
  While Not rs.EOF

    Set iProp = pGetSucursal()
    If iProp.HelpId = csNO_ID And _
       gDB.ValField(rs.Fields, cscSucId) <> csNO_ID Then
       
      With iProp
        .HelpId = gDB.ValField(rs.Fields, cscSucId)
        .Value = gDB.ValField(rs.Fields, cscSucNombre)
      End With
      m_ObjWizard.ShowValue iProp
    End If

    Set iProp = pGetCentroCosto()
    If iProp.HelpId = csNO_ID And _
       gDB.ValField(rs.Fields, cscCcosId) <> csNO_ID Then
       
      With iProp
        .HelpId = gDB.ValField(rs.Fields, cscCcosId)
        .Value = gDB.ValField(rs.Fields, cscCcosNombre)
      End With
      m_ObjWizard.ShowValue iProp
    End If

    Set iProp = pGetLegajo()
    If iProp.HelpId = csNO_ID And _
       gDB.ValField(rs.Fields, cscLgjId) <> csNO_ID Then
       
      With iProp
        .HelpId = gDB.ValField(rs.Fields, cscLgjId)
        .Value = gDB.ValField(rs.Fields, cscLgjTitulo)
      End With
      m_ObjWizard.ShowValue iProp
    End If
            
    rs.MoveNext
  Wend
End Sub

Private Sub pSetFilterColFactura()
  
  Dim WizObj As cWizardGeneric
  Dim AbmObj As cABMGeneric
  
  Set WizObj = m_ObjWizard
  Set AbmObj = WizObj.ObjAbm
  
  pCol(pGetOtros().Columns, KIO_FV_ID_RET).HelpFilter = "cli.cli_id = " & pGetCliente()
  AbmObj.RefreshColumnProperties pGetOtrosProperty(), cscFvIdRet
  
End Sub

Private Sub pRefreshLabelPagos()
  Dim iProp As cIABMProperty
  Set iProp = pGetLabelCobros()
  iProp.Value = c_LabelCobrosText & " - " & pGetClienteProperty().Value
  m_ObjWizard.ShowValue iProp
End Sub

Private Sub pLoadVirtualNextCobros()
  
  ' Si no hay objeto de info de cobranzas
  ' no hay pagos automaticos
  '
  If m_CobranzaInfo Is Nothing Then Exit Sub
  
  Dim FvInfo    As cCobranzaInfoFactura
  Dim efectivo  As Double
  Dim tickets   As Double
  Dim MonId     As Long
  Dim Moneda    As String
    
  For Each FvInfo In m_CobranzaInfo.Facturas
    If FvInfo.CliId = m_Cli_idDoc Then
      
      Select Case FvInfo.FormaDePago
        Case csE_HojaRutaCobranzaTipo.csHRCT_Efectivo
          efectivo = efectivo + FvInfo.ImporteCobrado
        Case csE_HojaRutaCobranzaTipo.csHRCT_Tickets
          tickets = tickets + FvInfo.ImporteCobrado
      End Select
    End If
  Next
  
  If efectivo <> 0 Then
    With pGetEfectivo().Rows.Add(Nothing)
    
      .Add Nothing
    
      With .Add(Nothing)
        .Value = m_CobranzaInfo.CuentaEfectivo
        .Id = m_CobranzaInfo.CueIdEfectivo
        .Key = KIE_CUE_ID
      End With
      
      GetMonedaFromCuenta MonId, _
                          Moneda, _
                          m_CobranzaInfo.CueIdEfectivo
      
      With .Add(Nothing)
        .Value = Moneda
        .Id = MonId
        .Key = KIE_MON_ID
      End With
      
      With .Add(Nothing)
        If MonId <> m_MonDefault Then
          .Value = efectivo
        Else
          .Value = 0
        End If
        .Key = KIE_IMPORTEORIGEN
      End With
      
      With .Add(Nothing)
        If MonId <> m_MonDefault Then
          .Value = efectivo * Val(pGetCotizacion().Value)
        Else
          .Value = efectivo
        End If
        .Key = KIE_IMPORTE
      End With
            
      With .Add(Nothing)
        .Value = vbNullString
        .Key = KIE_DESCRIP
      End With
    
    End With
    
  End If
  
  If tickets <> 0 Then
  
    With pGetEfectivo().Rows.Add(Nothing)
    
      .Add Nothing
    
      With .Add(Nothing)
        .Value = m_CobranzaInfo.CuentaTicket
        .Id = m_CobranzaInfo.CueIdTicket
        .Key = KIE_CUE_ID
      End With
      
      GetMonedaFromCuenta MonId, _
                          Moneda, _
                          m_CobranzaInfo.CueIdTicket
      
      With .Add(Nothing)
        .Value = Moneda
        .Id = MonId
        .Key = KIE_MON_ID
      End With
      
      With .Add(Nothing)
        If MonId <> m_MonDefault Then
          .Value = tickets
        Else
          .Value = 0
        End If
        .Key = KIE_IMPORTEORIGEN
      End With
      
      With .Add(Nothing)
        If MonId <> m_MonDefault Then
          .Value = tickets * Val(pGetCotizacion().Value)
        Else
          .Value = tickets
        End If
        .Key = KIE_IMPORTE
      End With
            
      With .Add(Nothing)
        .Value = vbNullString
        .Key = KIE_DESCRIP
      End With
    
    End With
        
  End If
  
  If efectivo <> 0 Or tickets <> 0 Then
    
    pRefreshEfectivo
  
    pShowCobroNeto
    pShowCobroOtro
    pShowCobroTotal
  
  End If
  
End Sub

Private Sub pRefreshEfectivo()
  m_ObjWizard.ShowValue GetWizProperty(m_ObjWizard, _
                                        c_StepSelectCobros, _
                                        c_Wiz_Key_Efectivo)
End Sub

Private Function pGetFilterCuentaXCaja() As String

  If m_isHojaRuta Then

    ' Debo obtener la caja abierta para saber que cuentas puedo usar
    '
    pGetFilterCuentaXCaja = " and cue_id in (select cue_id_trabajo from cajacuenta where cj_id = " & m_cj_id & ")"

  Else
  
    pGetFilterCuentaXCaja = c_filter_cuentas_de_caja
    
  End If

End Function

Private Function pLoadCajaForUsuario() As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim Msg     As String
  
  sqlstmt = "sp_MovimientoCajaGetCjForUsId " & User.Id & ",1,0,0,'',1"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
      
  Msg = gDB.ValField(rs.Fields, "warning")
  If LenB(Msg) Then
    MsgWarning Msg
    Exit Function
  End If
  
  m_cj_id = gDB.ValField(rs.Fields, cscCjId)
  
  pLoadCajaForUsuario = True
  
End Function

