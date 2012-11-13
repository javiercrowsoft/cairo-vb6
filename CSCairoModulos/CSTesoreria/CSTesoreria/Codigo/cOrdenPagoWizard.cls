VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cOrdenPagoWizard"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIWizardClient
Implements CSInterfacesABM.cIABMClientGrid

'--------------------------------------------------------------------------------
' cOrdenPagoWizard
' 09-03-2004

'--------------------------------------------------------------------------------
' notas:

' Reemplazar

' Asistente de OrdenPagos         Ejemplo: Asistente para Nuevo Reporte

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cOrdenPagoWizard"

Private Const c_StepWelcome             As Integer = 1
Private Const c_StepSelectProveedor     As Integer = 3
Private Const c_StepSelectFactura       As Integer = 4
Private Const c_StepAnticipo            As Integer = 5
Private Const c_StepSelectPagos         As Integer = 6
Private Const c_StepDatosGenerales      As Integer = 7

Private Const c_Wiz_Key_ResultTitle = "RESULTT"
Private Const c_Wiz_Key_Result = "RESULT"
Private Const c_Wiz_Key_Proveedor = "CLIENT"
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

Private Const c_Wiz_Key_PagoOtros = "PAGO-OTROS"
Private Const c_Wiz_Key_PagoTotal = "PAGO-TOTAL"
Private Const c_Wiz_Key_PagoNeto = "PAGO-NETO"
Private Const c_Wiz_Key_PagoIndicado = "PAGO-INDICADO"

Private Const c_Wiz_Key_CopyCheques = "COPY-CHEQUES"
Private Const c_Wiz_Key_Cheques = "CHEQUES"
Private Const c_Wiz_Key_ChequesTercero = "CHEQUEST"
Private Const c_Wiz_Key_Otros = "OTROS"
Private Const c_Wiz_Key_CtaCte = "CTACTE"
Private Const c_Wiz_Key_Efectivo = "EFVO"

Private Const c_Wiz_Key_Fecha = "Fecha"
Private Const c_Wiz_Key_Proveedor2 = "Proveedor"
Private Const c_Wiz_Key_Sucursal = "Sucursal"
Private Const c_Wiz_Key_Observaciones = "Observaciones"
Private Const c_Wiz_Key_Comprobante = "Comprobante"
Private Const c_Wiz_Key_Legajo = "Legajo"
Private Const c_Wiz_Key_CentroCosto = "Centro de Costo"

Private Const c_Chequera = "Chequera"
Private Const c_ChequeT = "chqt"

Private Const KW_FACTURAS                    As Integer = 10
Private Const KW_COTIZACION                  As Integer = 20
Private Const KW_AGRUPADOS                   As Integer = 30
Private Const KW_VENCIDOS                    As Integer = 40
Private Const KW_TODOS                       As Integer = 110
Private Const KW_CHEQUES                     As Integer = 120
Private Const KW_CHEQUEST                    As Integer = 125
Private Const KW_CTACTE                      As Integer = 130
Private Const KW_EFECTIVO                    As Integer = 140
Private Const KW_OTROS                       As Integer = 150
Private Const KW_ANTICIPO                    As Integer = 170
Private Const KW_IMPORTE_OTROS               As Integer = 180
Private Const KW_IMPORTE_TOTAL               As Integer = 190
Private Const KW_IMPORTE_NETO                As Integer = 200
Private Const KW_IMPORTE_INDICADO            As Integer = 210
Private Const KW_PROVEEDOR2                  As Integer = 220
Private Const KW_FECHA                       As Integer = 230
Private Const KW_SUCURSAL                    As Integer = 240
Private Const KW_DESCRIP                     As Integer = 250
Private Const KW_COMPROBANTE                 As Integer = 260
Private Const KW_LEGAJO                      As Integer = 280
Private Const KW_CENTROCOSTO                 As Integer = 290

Private Const KW_CUENTA_ANTICIPO             As Integer = 300
Private Const KW_MONEDA_ANTICIPO             As Integer = 310
Private Const KW_COTIZACION_ANTICIPO         As Integer = 320
Private Const KW_IMPORTE_ANTICIPO            As Integer = 330

Private Const KW_DOC_ID                      As Integer = 340

Private Const KI_IMPORTE                     As Integer = 1
Private Const KI_FC_ID                       As Integer = 2
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
Private Const KI_FCD_ID                      As Integer = 16

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
Private Const KIO_FC_ID_RET                  As Integer = 12

Private Const K_COPY_CHEQUE              As Integer = 500

Private Const KICH_CUE_ID                As Integer = 2
Private Const KICH_IMPORTE               As Integer = 3
Private Const KICH_IMPORTEORIGEN         As Integer = 4
Private Const KICH_CHEQUERA              As Integer = 5
Private Const KICH_CHEQUE                As Integer = 6
Private Const KICH_MON_ID                As Integer = 7
Private Const KICH_FECHACOBRO            As Integer = 10
Private Const KICH_FECHAVTO              As Integer = 11
Private Const KICH_CLE_ID                As Integer = 12
Private Const KICH_DESCRIP               As Integer = 13

Private Const KIE_CUE_ID                 As Integer = 2
Private Const KIE_MON_ID                 As Integer = 3
Private Const KIE_IMPORTE                As Integer = 4
Private Const KIE_IMPORTEORIGEN          As Integer = 5
Private Const KIE_DESCRIP                As Integer = 6

Private Const KICC_CUE_ID                 As Integer = 2
Private Const KICC_IMPORTE                As Integer = 3
Private Const KICC_IMPORTEORIGEN          As Integer = 4

Private Const c_WizardTitle = "Asistente de ordenes de pago"

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

' variables privadas
Private m_ObjWizard               As cIWizardGeneric

Private m_WizardProcessing        As Boolean
Private m_WizardCancel            As Boolean

'Private m_Resource                As fResource

Private m_bMultiMoneda            As Boolean

Private m_TesoreriaConfig   As cTesoreriaConfig
Private m_GeneralConfig     As cGeneralConfig

Private m_MonDefault        As Long

Private m_Id                As Long

Private m_Prov_id           As Long
Private m_Proveedor         As String
Private m_FcIds()           As Long

Private m_iOrden            As Long

Private m_ObjClient         As Object

Private m_LastDoc           As Long
Private m_LastProv          As Long

' PrintDoc
'
Private m_LastNroDoc        As String

' eventos
' propiedades publicas
Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Let prov_id(ByVal rhs As Long)
  m_Prov_id = rhs
End Property

Public Property Let Proveedor(ByVal rhs As String)
  m_Proveedor = rhs
End Property

Public Property Let FcIds(ByRef rhs() As Long)
  On Error Resume Next
  Dim i As Long
  ReDim m_FcIds(UBound(rhs))
  For i = 0 To UBound(rhs)
    m_FcIds(i) = rhs(i)
  Next
End Property

Public Property Set ObjClient(ByVal rhs As Object)
  Set m_ObjClient = rhs
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Load() As Boolean
  On Error GoTo ControlError

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
        Case KW_CHEQUES, KW_EFECTIVO, KW_CHEQUEST
          pShowPagoNeto
        Case KW_OTROS
          pShowPagoOtro
      End Select
      pShowPagoTotal
    
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
    Case KW_CHEQUEST
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowTCheques(Row, RowIndex)
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
    Case KW_CHEQUEST
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateTCheque(pGetChequesTProperty(), lRow, lCol)
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
   cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case KW_FACTURAS
      cIABMClientGrid_ColumnBeforeEdit = pColBEditFacturas(pGetFacturasProperty(), lRow, lCol, iKeyAscii)
    Case Else
      cIABMClientGrid_ColumnBeforeEdit = True
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
    
    Case KW_FACTURAS
      
      With pGetFacturas().Rows
        ShowDocAux pCell(.Item(lRow), KI_FC_ID).Id, _
                   "CSCompra2.cFacturaCompra", _
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
    Case KW_CHEQUEST
      cIABMClientGrid_ValidateRow = pValidateRowTCheques(Row, RowIndex)
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
    Case KI_SELECT 'jav 2004-08-26
    Case KI_APLICAR, KI_COTIZACION2 'jav 2004-08-26
    
      Dim Row As cIABMGridRow
      
      Set Row = IProperty.Grid.Rows.Item(lRow)
    
      ' Si no esta seleccionado que salga sin editar
      '
      If pCell(Row, KI_SELECT).Id = 0 Then
        Exit Function
      End If
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
            pCell(Row, KICH_IMPORTE).Value = Val(pCell(Row, KICH_IMPORTEORIGEN).Value) * Val(pGetCotizacion().Value)
          Else
            pCell(Row, KICH_IMPORTEORIGEN).Value = 0
          End If
        End With
      Case KICH_IMPORTE
      
      Case KICH_CUE_ID
        Dim MonId   As Long
        Dim CueId   As Long
        Dim Moneda  As String
        
        Set Row = .Rows(lRow)
        
        CueId = pCell(Row, KICH_CUE_ID).Id
        GetMonedaFromCuenta MonId, Moneda, CueId
        
        With pCell(Row, KICH_MON_ID)
          .Value = Moneda
          .Id = MonId
        End With
      
        If MonId = m_MonDefault Or MonId = 0 Then
          pCell(Row, KICH_IMPORTEORIGEN).Value = 0
        End If
        
        pCol(IProperty.Grid.Columns, KICH_CHEQUERA).HelpFilter = cscCueId & "=" & CueId
        
#If PREPROC_SFS Then
        Dim AbmObj As cABMGeneric
#Else
        Dim AbmObj As cABMGenericDocEx
#End If
        Set AbmObj = m_ObjWizard.EditGeneric
        AbmObj.RefreshColumnProperties IProperty, c_Chequera
        
        If Val(pCell(Row, KICH_IMPORTE).Value) = 0 Then
          pCell(Row, KICH_IMPORTE).Value = Val(pGetTotal().Value) - Val(pGetPagoTotal().Value)
          pShowPagoNeto
          pShowPagoTotal
        End If
        
        pColAUpdateCheque = True
        Exit Function
        
      Case KICH_CHEQUERA
        
        Set Row = .Rows(lRow)
        With pCell(Row, KICH_CHEQUERA)
          If .Id <> csNO_ID Then
            pCell(Row, KICH_CHEQUE).Value = GetChequeNumber(.Id)
          End If
        End With
        
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
  
  pShowPagoNeto
  pShowPagoTotal
  pColAUpdateCheque = True
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
            pCell(Row, KIE_IMPORTE).Value = Val(pCell(Row, KIE_IMPORTEORIGEN).Value) * Val(pGetCotizacion().Value)
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
          pCell(Row, KIE_IMPORTE).Value = Val(pGetTotal().Value) - Val(pGetPagoTotal().Value)
          pShowPagoNeto
          pShowPagoTotal
        End If
        
        pColAUpdateEfectivo = True
        Exit Function
      Case Else
        pColAUpdateEfectivo = True
        Exit Function
    End Select
  End With
  
  pShowPagoNeto
  pShowPagoTotal
  pColAUpdateEfectivo = True
End Function

Private Function pColAUpdateTCheque(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  Dim Row      As cIABMGridRow
  Dim Value    As Double
  
  With IProperty.Grid
    
    Select Case .Columns(lCol).Key
      
      Case KICHT_IMPORTEORIGEN
        Set Row = .Rows(lRow)
        With pCell(Row, KICHT_MON_ID)
          If .Id <> m_MonDefault Or .Id = 0 Then
            pCell(Row, KICHT_IMPORTE).Value = Val(pCell(Row, KICHT_IMPORTEORIGEN).Value) * Val(pGetCotizacion().Value)
          Else
            pCell(Row, KICHT_IMPORTEORIGEN).Value = 0
          End If
        End With
      
      Case KICHT_CUE_ID
        Dim MonId   As Long
        Dim CueId   As Long
        Dim Moneda  As String
        
        Set Row = .Rows(lRow)
        
        CueId = pCell(Row, KICHT_CUE_ID).Id
        GetMonedaFromCuenta MonId, Moneda, CueId
        
        With pCell(Row, KICHT_MON_ID)
          .Value = Moneda
          .Id = MonId
        End With
      
        If MonId = m_MonDefault Or MonId = 0 Then
          pCell(Row, KICHT_IMPORTEORIGEN).Value = 0
        End If
        
        pCol(IProperty.Grid.Columns, _
             KICHT_CHEQUE).HelpFilter = GetChequeFileter(CueId)
        
#If PREPROC_SFS Then
        Dim AbmObj As cABMGeneric
#Else
        Dim AbmObj As cABMGenericDocEx
#End If
        Set AbmObj = m_ObjWizard.EditGeneric
        AbmObj.RefreshColumnProperties IProperty, c_ChequeT
        
        pColAUpdateTCheque = True
        Exit Function
      
      Case KICHT_CHEQUE
        Set Row = .Rows(lRow)
        SetChequeData Row, pCell(Row, KICHT_CHEQUE).Id
      
        pShowPagoNeto
        pShowPagoTotal
      
        pColAUpdateTCheque = True
        Exit Function
      
      Case Else
        pColAUpdateTCheque = True
        Exit Function
    End Select
  End With
  
  pColAUpdateTCheque = True
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
  
  pShowPagoOtro
  pShowPagoTotal
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

Private Sub pRefreshCotizacion()
  Dim Row As cIABMGridRow
  Dim Cotiz As Double
  
  Cotiz = pGetCotizacion().Value
  
  With pGetFacturas
    For Each Row In .Rows
      If Val(pCell(Row, KI_IMPORTEORIGEN).Value) Then
      
        If m_bMultiMoneda Then
          Cotiz = Val(pCell(Row, KI_COTIZACION2).Value)
        Else
          pCell(Row, KI_COTIZACION2).Value = Cotiz
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

Private Sub pShowPagoNeto()
  Dim Row           As cIABMGridRow
  Dim Total         As Double
  
  For Each Row In pGetCheques().Rows
    Total = Total + Val(pCell(Row, KICH_IMPORTE).Value)
  Next
  
  For Each Row In pGetEfectivo().Rows
    Total = Total + Val(pCell(Row, KIE_IMPORTE).Value)
  Next
  
  For Each Row In pGetTCheques().Rows
    Total = Total + Val(pCell(Row, KICHT_IMPORTE).Value)
  Next
  
  pGetPagoNeto().Value = Total
  m_ObjWizard.ShowValue pGetPagoNeto
End Sub

Private Sub pShowPagoOtro()
  Dim Row           As cIABMGridRow
  Dim Total         As Double
  
  For Each Row In pGetOtros().Rows
    Total = Total + Val(pCell(Row, KIO_DEBE).Value) - Val(pCell(Row, KIO_HABER).Value)
  Next
  
  pGetPagoOtros().Value = Total
  m_ObjWizard.ShowValue pGetPagoOtros
End Sub

Private Sub pShowAnticipo()
  pGetAnticipoImporte().Value = Val(pGetAnticipo().Value)
  m_ObjWizard.ShowValue pGetAnticipoImporte
End Sub

Private Sub pShowPagoTotal()
  pGetPagoTotal.Value = Val(pGetPagoNeto().Value) + Val(pGetPagoOtros().Value)
  m_ObjWizard.ShowValue pGetPagoTotal
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
  Dim Row           As cIABMGridRow
  Dim Total         As Double
  
  For Each Row In pGetFacturas().Rows
    Total = Total + DivideByCero(Val(pCell(Row, KI_APLICAR).Value), Val(pCell(Row, KI_COTIZACION2).Value)) * Val(pCell(Row, KI_COTIZACION).Value)
  Next
  
  pGetDeudaOrigen = Total
End Function

' Implementacion de cIWizardClient
Private Property Get cIWizardClient_Aplication() As String
  cIWizardClient_Aplication = gAppName
End Property

Private Function cIWizardClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Function cIWizardClient_Load() As Boolean
  On Error GoTo ControlError
  
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
    
    Case c_StepSelectPagos
      If GoingToNext Then
        If Not pGetCuentasAcreedor() Then Exit Function
        pSetFilterColFactura
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
      nNextStep = c_StepSelectProveedor
      m_ObjWizard.cmdNext.Caption = c_WizStr_Next
      m_ObjWizard.cmdBack.Enabled = False
      
    Case c_StepSelectProveedor
    
      If pGetDoc() = csNO_ID Then
        MsgWarning LNGGetText(1562, vbNullString), LNGGetText(2202, vbNullString)
                   'Debe indicar un documento, Ordenes de pago
        nNextStep = c_StepSelectProveedor
      ElseIf pGetProveedor() = csNO_ID Then
        MsgWarning LNGGetText(1860, vbNullString), LNGGetText(2202, vbNullString)
                   'Debe indicar un proveedor, Ordenes de pago
        nNextStep = c_StepSelectProveedor
      ElseIf Not pLoadFacturasXProveedor() Then
        MsgWarning LNGGetText(2203, vbNullString), LNGGetText(2202, vbNullString)
                   'No se pudieron cargar las Facturas para este Proveedor, Ordenes de Pago
        nNextStep = c_StepSelectProveedor
      Else
      
        pShowMessages
      
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
        nNextStep = c_StepSelectPagos
      Else
        nNextStep = c_StepSelectFactura
      End If
    
    Case c_StepSelectPagos
      If Not pValidatePago() Then
        nNextStep = c_StepSelectPagos
      Else
        
        m_ObjWizard.cmdBack.Enabled = True
        m_ObjWizard.cmdNext.Caption = c_WizStr_Finish
        
        nNextStep = c_StepDatosGenerales
      End If
    
    Case c_StepDatosGenerales

      If pValidateDatosGenerales() Then

        If pSave() Then
          
          ' PrintDoc
          '
          WizShowNewStep m_ObjWizard, c_StepWelcome, m_LastNroDoc
          nNextStep = c_StepWelcome
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

    Case c_StepSelectProveedor
      nNextStep = c_StepSelectProveedor
    
    Case c_StepSelectFactura
      m_ObjWizard.cmdBack.Enabled = False
      nNextStep = c_StepSelectProveedor
    
    Case c_StepAnticipo
      nNextStep = c_StepSelectFactura
    
    Case c_StepSelectPagos
      nNextStep = c_StepAnticipo
    
    Case c_StepDatosGenerales
      m_ObjWizard.cmdNext.Caption = c_WizStr_Next
      nNextStep = c_StepSelectPagos
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
                    GetEmailFromProveedor(m_LastProv)
    
    Case KW_NEW_DOC
      pNewEmptyProperties
      WizNewDoc m_ObjWizard, c_StepWelcome
    
    Case KW_VENCIDOS, KW_AGRUPADOS
      pLoadFacturasXProveedor
    Case KW_COTIZACION
      pRefreshCotizacion
      pShowTotalFacturas
    Case KW_ANTICIPO
      pValidateAnticipo
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
  
    Case K_COPY_CHEQUE
      pCopyCheque
  
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
  m_ObjClient.TerminateWizard m_Id
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

  m_LastDoc = m_TesoreriaConfig.DocIdOrdenPago

  pLoadStepWelcome
  pLoadStepSelectProveedor
  pLoadStepSelectFactura
  pLoadStepAnticipo
  pLoadStepSelectPagos
  pLoadStepDatosGenerales

  LoadSteps = True
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
      .Value = LNGGetText(2204, vbNullString)
                'Bienvenido al Asistente de Ordenes de Pago
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_MainTitle)
      .Top = 1200
      .Left = 3000
      '.Name = vbNullString
      .PropertyType = cspLabel
      .Width = 6000
      .Height = 880
      .FontBold = True
      .Value = LNGGetText(2205, vbNullString)
              'Con este Asistente usted podrá generar las Ordenes de Pago.
    End With
    
    WizAddNewDocProperties m_ObjWizard, c_StepWelcome
    
  End With
End Sub

Private Sub pLoadStepSelectProveedor()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepSelectProveedor)).Properties
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
      .Value = LNGGetText(2206, vbNullString)
              'Indique el documento a utilizar y el Proveedor al que se le emitirá el Recibo
    End With
    
    With .Add(Nothing, c_Wiz_Key_Doc)
      .Top = 1500
      .Left = 3700
      .Name = LNGGetText(1567, vbNullString)  'Documento
      .PropertyType = cspHelp
      .HelpFilter = "'doct_id = " & csEDT_OrdenPago & "'"
      .Table = CSDocumento2.CSDocumento
      .Width = 4000
      .Value = m_TesoreriaConfig.DocOrdenPago
      .HelpId = m_TesoreriaConfig.DocIdOrdenPago
      .Key = KW_DOC_ID
    End With
  
    With .Add(Nothing, c_Wiz_Key_Proveedor)
      .Top = 2000
      .Left = 3700
      .Name = LNGGetText(1151, vbNullString)  'Proveedor
      .PropertyType = cspHelp
      .Table = csProveedor
      .Width = 4000
      .Value = m_Proveedor
      .HelpId = m_Prov_id
    End With
  
    ' Edit From ListDoc
    '
    With .Add(Nothing, c_Wiz_Key_OnlySelected)
      .PropertyType = cspCheck
      .Name = LNGGetText(2133, vbNullString)  'Cargar solo facturas seleccionadas
      .Value = UBound(m_FcIds)
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
              'Seleccione las facturas he indique los importes que cancelará en cada una de ellas
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
      .Name = LNGGetText(2136, vbNullString)   'Ver solo vencidos
      .Top = 400
      .Left = 11400
      .LeftLabel = -1400
      .Width = 370
      .PropertyType = cspCheck
      .Key = KW_VENCIDOS
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_Cotizacion)
      .Name = LNGGetText(1635, vbNullString)   'Cotización
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
      .Name = LNGGetText(2137, vbNullString)   'Anticipo
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
      .Name = LNGGetText(2138, vbNullString)   'Total Origen
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
      .Name = LNGGetText(1584, vbNullString)   'Total
      .Top = 5550
      .Left = 9820
      .LeftLabel = -600
      .Width = 1800
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
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
      .HelpFilter = cscCuecId & " = " & csECuecAcreedores
      .Name = LNGGetText(1267, vbNullString)   'Cuenta
      
      .Value = m_TesoreriaConfig.CueAnticipoOpg
      .HelpId = m_TesoreriaConfig.cue_id_ant_opg
      
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
    
    If m_TesoreriaConfig.cue_id_ant_opg <> csNO_ID Then
      pShowMonedaAnticipo False
    End If
    
  End With
End Sub

Private Sub pLoadFacturas(ByRef Grid As cIABMGrid)
  Dim Signo As String
  
  ' La primera simpre esta invisible
  With Grid.Columns
  
    .Add(Nothing).Visible = False
  
    With .Add(Nothing)
      .Visible = False
      .Key = KI_FCD_ID
    End With
    
    With .Add(Nothing)
      '.Name = vbNullString
      .PropertyType = cspCheck
      .Width = 320
      .Key = KI_SELECT
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1223, vbNullString)   'Tipo
      .PropertyType = cspText
      .Width = 1320
      .Key = KI_DOC
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1567, vbNullString)   'Documento
      .PropertyType = cspText
      .Width = 1340
      .Key = KI_NRODOC
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1065, vbNullString)   'Número
      .PropertyType = cspNumeric
      .Width = 800
      .Key = KI_FC_ID
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1569, vbNullString)   'Fecha
      .PropertyType = cspDate
      .Width = 740
      .Format = "dd/mm/yy"
      .Key = KI_FECHA
    End With
  
    Signo = pGetNomMonedaDefault
  
    With .Add(Nothing, c_Wiz_Key_Moneda)
      .Name = LNGGetText(2063, vbNullString)   'Mon
      .PropertyType = cspText
      .Width = 520
      .Key = KI_MONEDA
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1901, vbNullString)   'Origen
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 920
      .Key = KI_IMPORTEORIGEN
      .Format = m_GeneralConfig.FormatDecImporte
    End With
  
    With .Add(Nothing, c_Wiz_Key_Cotizacion)
      .Name = LNGGetText(1650, vbNullString)   'Cotiz.
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
      .Name = LNGGetText(1650, vbNullString)   'Cotiz.
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 570
      .Key = KI_COTIZACION2
      .Visible = False
      .Format = m_GeneralConfig.FormatDecCotizacion
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1634, vbNullString)   'Vto.
      .PropertyType = cspDate
      .Width = 740
      .Format = "dd/mm/yy"
      .Key = KI_VTO
    End With
  
    With .Add(Nothing, c_Wiz_Key_Pendiente)
      .Name = LNGGetText(2139, vbNullString, Signo)   'Importe " & Signo
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 920
      .Key = KI_PENDIENTE
      .Format = m_GeneralConfig.FormatDecImporte
    End With
  
    With .Add(Nothing, c_Wiz_Key_Importe)
      .Name = LNGGetText(2139, vbNullString, Signo)  'Importe " & Signo
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

Private Sub pLoadStepSelectPagos()
  Dim KeyPagos As String
  
  KeyPagos = GetKey(c_StepSelectPagos)
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, KeyPagos)
  
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
      .Value = LNGGetText(2207, vbNullString)   'Indique los instrumentos de Pago
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
      .FatherTab = KeyPagos
      .Left = 150
      .Top = 1100
    End With
    With iTab
      .Name = "Cheques"
      .Index = -1
    End With
    
    Set iTab = ObjAbm.Tabs.Add(Nothing)
    Set oTab = iTab
    oTab.FatherTab = KeyPagos
    With iTab
      .Name = "Efectivo"
      .Index = -2
    End With
    
    Set iTab = ObjAbm.Tabs.Add(Nothing)
    Set oTab = iTab
    oTab.FatherTab = KeyPagos
    With iTab
      .Name = "Cheque de Tercero"
      .Index = -3
    End With
    
    Set iTab = ObjAbm.Tabs.Add(Nothing)
    Set oTab = iTab
    oTab.FatherTab = KeyPagos
    With iTab
      .Name = "Otros"
      .Index = -4
    End With
      
    Set iTab = ObjAbm.Tabs.Add(Nothing)
    Set oTab = iTab
    oTab.FatherTab = KeyPagos
    With iTab
      .Name = "Cuenta Corriente"
      .Index = -5
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_CopyCheques)
      .PropertyType = cspButton
      .Name = LNGGetText(3839, vbNullString)
      .Key = K_COPY_CHEQUE
      .Left = 150
      .Width = 1500
      .LeftLabel = -1
      .LeftNotChange = True
      .TabIndex = -1
      .Top = 1600
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_Cheques)
      .Top = 2000
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
  
    With .Properties.Add(Nothing, c_Wiz_Key_ChequesTercero)
      .Top = 1600
      .Left = 150
      '.Name = vbNullString
      .PropertyType = cspGrid
      .LeftLabel = -1
      pLoadTCheques .Grid
      .Width = 11500
      .Height = 4000
      .Key = KW_CHEQUEST
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
  
    With .Properties.Add(Nothing, c_Wiz_Key_PagoIndicado)
      .Top = 5580
      .Left = 1800
      .LeftLabel = -1000
      .Width = 1800
      .Format = m_GeneralConfig.FormatDecImporte
      .Name = LNGGetText(2208, vbNullString)   'A Pagar
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Enabled = False
      .Key = KW_IMPORTE_INDICADO
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_PagoNeto)
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

    With .Properties.Add(Nothing, c_Wiz_Key_PagoOtros)
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

    With .Properties.Add(Nothing, c_Wiz_Key_PagoTotal)
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
      .HelpFilter = "(emp_id = " & EmpId & " or emp_id is null)" & c_filter_cuentas_de_caja
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
      .Name = LNGGetText(1634, vbNullString)   'Vto.
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
    
    With .Add(Nothing, cscFcIdRet)
      .Name = LNGGetText(1866, vbNullString) ' Factura
      .PropertyType = cspHelp
      .Table = csFacturaCompra
      .Width = 1200
      .Key = KIO_FC_ID_RET
    End With
  End With
End Sub

Private Sub pLoadTCheques(ByRef Grid As cIABMGrid)
  ' La primera simpre esta invisible
  With Grid.Columns
  
    .Add(Nothing).Visible = False
    
    With .Add(Nothing)
      .Name = LNGGetText(1267, vbNullString)   'Cuenta
      .PropertyType = cspHelp
      .Table = csCuenta
      
      '.HelpFilter = cscCuecId & "=" & csECuecDocEnCartera & _
                    " and (emp_id = " & EmpId & " or emp_id is null)"
      .HelpFilter = GetHelpFilterChequesT() & c_filter_cuentas_de_caja
      
      .Width = 2200
      .Key = KICHT_CUE_ID
    End With
    
    With .Add(Nothing, c_ChequeT)
      .Name = LNGGetText(2059, vbNullString)   'Nr. Cheque
      .PropertyType = cspHelp
      .Table = csCheque
      .HelpFilter = "1 = 2"
      .SubType = cspInteger
      .Width = 1000
      .Key = KICHT_CHEQUE
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1150, vbNullString)   'Cliente
      .PropertyType = cspText
      .Width = 2000
      .Key = KICHT_CLI_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1122, vbNullString)   'Banco
      .PropertyType = cspText
      .Width = 2000
      .Key = KICHT_BCO_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2063, vbNullString)   'Mon
      .PropertyType = cspHelp
      .Table = csMoneda
      .Width = 520
      .Key = KICHT_MON_ID
      .Enabled = False
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1901, vbNullString)   'Origen
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KICHT_IMPORTEORIGEN
      .Enabled = False
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1228, vbNullString)   'Importe
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 920
      .Key = KICHT_IMPORTE
      .Enabled = False
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2065, vbNullString)   'Depositar el
      .PropertyType = cspDate
      .Width = 970
      .Key = KICHT_FECHACOBRO
      .Enabled = False
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1634, vbNullString)   'Vto.
      .PropertyType = cspDate
      .Width = 970
      .Key = KICHT_FECHAVTO
      .Enabled = False
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1083, vbNullString)   'Clering
      .PropertyType = cspHelp
      .Table = csClearing
      .Width = 800
      .Key = KICHT_CLE_ID
      .Enabled = False
    End With
    
    With .Add(Nothing)
      .Name = C_strDescrip
      .PropertyType = cspText
      .Width = 1600
      .Key = KICHT_DESCRIP
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
      
      '.HelpFilter = cscCuecId & "=" & csECuecBancos & " and emp_id = " & EmpId
      .HelpFilter = GetHelpFilterChequesP() & c_filter_cuentas_de_caja
      
      .Width = 2200
      .Key = KICH_CUE_ID
    End With
    
    With .Add(Nothing, c_Chequera)
      .Name = LNGGetText(2064, vbNullString)   'Chequera
      .PropertyType = cspHelp
      .Table = csChequera
      .HelpFilter = cscCueId & "=0"
      .Width = 1000
      .Key = KICH_CHEQUERA
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2059, vbNullString)   'Nro. Cheque
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Width = 1000
      .Key = KICH_CHEQUE
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
      .Name = LNGGetText(2065, vbNullString)   'Depositar el
      .PropertyType = cspDate
      Set .DefaultValue = New cABMGridRowValue
      .DefaultValue.Value = Date
      .Width = 970
      .Key = KICH_FECHACOBRO
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1634, vbNullString)   'Vto.
      .PropertyType = cspDate
      .Width = 970
      Set .DefaultValue = New cABMGridRowValue
      .DefaultValue.Value = DateAdd("m", 1, Date)
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
      
      '.HelpFilter = cscCuecId & "=" & csECuecCaja & _
                    " and (emp_id = " & EmpId & " or emp_id is null)"
      .HelpFilter = GetHelpFilterEfectivo() & c_filter_cuentas_de_caja
      
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
      .Value = LNGGetText(2148, vbNullString)   'Complete los siguientes datos del recibo
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_Fecha)
      .PropertyType = cspDate
      .Left = 2800
      .Name = LNGGetText(1569, vbNullString) 'Fecha
      .Key = KW_FECHA
      .Value = Date
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_Proveedor2)
      .PropertyType = cspHelp
      .Table = csProveedor
      .Enabled = False
      .Name = LNGGetText(1151, vbNullString) 'Proveedor
      .Key = KW_PROVEEDOR2
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
    
    If Ask(LNGGetText(1665, vbNullString), vbNo) Then       'Desea cancelar el proceso
    
      pUserCancel = True
    End If
  End If
  m_WizardCancel = False
End Function

Private Function pGetDoc() As Long
  pGetDoc = GetWizProperty(m_ObjWizard, _
                          c_StepSelectProveedor, _
                          c_Wiz_Key_Doc).HelpId
End Function

Private Function pGetDocName() As String
  pGetDocName = GetWizProperty(m_ObjWizard, _
                          c_StepSelectProveedor, _
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

Private Function pCheckAnticipo() As Boolean
  pCheckAnticipo = True
End Function

Private Function pGetPagoIndicado() As cIABMProperty
  Set pGetPagoIndicado = GetWizProperty(m_ObjWizard, _
                                  c_StepSelectPagos, _
                                  c_Wiz_Key_PagoIndicado)
End Function

Private Function pGetPagoNeto() As cIABMProperty
  Set pGetPagoNeto = GetWizProperty(m_ObjWizard, _
                                  c_StepSelectPagos, _
                                  c_Wiz_Key_PagoNeto)
End Function

Private Function pGetPagoOtros() As cIABMProperty
  Set pGetPagoOtros = GetWizProperty(m_ObjWizard, _
                                  c_StepSelectPagos, _
                                  c_Wiz_Key_PagoOtros)
End Function

Private Function pGetPagoTotal() As cIABMProperty
  Set pGetPagoTotal = GetWizProperty(m_ObjWizard, _
                                  c_StepSelectPagos, _
                                  c_Wiz_Key_PagoTotal)
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

Private Function pGetProveedor2() As cIABMProperty
  Set pGetProveedor2 = GetWizProperty(m_ObjWizard, _
                                c_StepDatosGenerales, _
                                c_Wiz_Key_Proveedor2)
End Function

Private Function pGetProveedor() As Long
  pGetProveedor = GetWizProperty(m_ObjWizard, _
                          c_StepSelectProveedor, _
                          c_Wiz_Key_Proveedor).HelpId
End Function

Private Function pGetProveedorName() As String
  pGetProveedorName = GetWizProperty(m_ObjWizard, _
                          c_StepSelectProveedor, _
                          c_Wiz_Key_Proveedor).Value
End Function

' Edit From ListDoc
'
Private Function pGetOnlySelected() As cIABMProperty
  Set pGetOnlySelected = GetWizProperty(m_ObjWizard, _
                          c_StepSelectProveedor, _
                          c_Wiz_Key_OnlySelected)
End Function

Private Function pGetTCheques() As cIABMGrid
  Set pGetTCheques = GetWizProperty(m_ObjWizard, _
                                  c_StepSelectPagos, _
                                  c_Wiz_Key_ChequesTercero).Grid
End Function

Private Function pGetCheques() As cIABMGrid
  Set pGetCheques = GetWizProperty(m_ObjWizard, _
                                  c_StepSelectPagos, _
                                  c_Wiz_Key_Cheques).Grid
End Function

Private Function pGetChequesProperty() As cIABMProperty
  Set pGetChequesProperty = GetWizProperty(m_ObjWizard, _
                                  c_StepSelectPagos, _
                                  c_Wiz_Key_Cheques)
End Function

Private Function pGetChequesTProperty() As cIABMProperty
  Set pGetChequesTProperty = GetWizProperty(m_ObjWizard, _
                                  c_StepSelectPagos, _
                                  c_Wiz_Key_ChequesTercero)
End Function

Private Function pGetEfectivo() As cIABMGrid
  Set pGetEfectivo = GetWizProperty(m_ObjWizard, _
                                  c_StepSelectPagos, _
                                  c_Wiz_Key_Efectivo).Grid
End Function

Private Function pGetEfectivoProperty() As cIABMProperty
  Set pGetEfectivoProperty = GetWizProperty(m_ObjWizard, _
                                  c_StepSelectPagos, _
                                  c_Wiz_Key_Efectivo)
End Function

Private Function pGetOtros() As cIABMGrid
  Set pGetOtros = GetWizProperty(m_ObjWizard, _
                                  c_StepSelectPagos, _
                                  c_Wiz_Key_Otros).Grid
End Function

Private Function pGetOtrosProperty() As cIABMProperty
  Set pGetOtrosProperty = GetWizProperty(m_ObjWizard, _
                                  c_StepSelectPagos, _
                                  c_Wiz_Key_Otros)
End Function

Private Function pGetFacturas() As cIABMGrid
  Set pGetFacturas = GetWizProperty(m_ObjWizard, _
                                    c_StepSelectFactura, _
                                    c_Wiz_Key_Factuas).Grid
End Function

Private Function pGetCtaCte() As cIABMGrid
  Set pGetCtaCte = GetWizProperty(m_ObjWizard, _
                                  c_StepSelectPagos, _
                                  c_Wiz_Key_CtaCte).Grid
End Function

Private Function pGetFacturasProperty() As cIABMProperty
  Set pGetFacturasProperty = GetWizProperty(m_ObjWizard, _
                                        c_StepSelectFactura, _
                                        c_Wiz_Key_Factuas)
End Function

Private Function pGetCtaCteProperty() As cIABMProperty
  Set pGetCtaCteProperty = GetWizProperty(m_ObjWizard, _
                                  c_StepSelectPagos, _
                                  c_Wiz_Key_CtaCte)
End Function

Private Sub pRefreshFacturas()
  m_ObjWizard.ShowValue GetWizProperty(m_ObjWizard, _
                                        c_StepSelectFactura, _
                                        c_Wiz_Key_Factuas)
End Sub

Private Sub pRefreshCtaCte()
  m_ObjWizard.ShowValue GetWizProperty(m_ObjWizard, _
                                  c_StepSelectPagos, _
                                  c_Wiz_Key_CtaCte)
End Sub

Private Sub pRefreshOtros()
  m_ObjWizard.ShowValue GetWizProperty(m_ObjWizard, _
                                  c_StepSelectPagos, _
                                  c_Wiz_Key_Otros)
End Sub

Private Function pGetComprobante() As cIABMProperty
  Set pGetComprobante = GetWizProperty(m_ObjWizard, _
                                c_StepDatosGenerales, _
                                c_Wiz_Key_Comprobante)
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

Private Function pChecFacturas() As Boolean
  If Val(pGetTotal.Value) = 0 Then
    MsgWarning LNGGetText(2149, vbNullString)
      'Debe indicar una o más facturas, un importe como anticipo, o ambas cosas.
    Exit Function
  End If
  pChecFacturas = True
End Function

Private Function pLoadFacturasXProveedor() As Boolean
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
  
  Dim fc_id             As Long
  
  ' Edit From ListDoc
  '
  Dim bSelected         As Boolean
  Dim bOnlySelected     As Boolean
  
  bAgrupados = pGetAgrupados
  sqlstmt = "sp_DocOrdenPagoGetFacturas " & EmpId & "," & pGetProveedor & "," & Abs(CInt(pGetVencidos)) & "," & Abs(CInt(bAgrupados))
  
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
        fc_id = gDB.ValField(rs.Fields, cscFcId)
        
        bSelected = pGetApply(fc_id)
        If Not bOnlySelected Or bSelected Then
          
          With .Add(Nothing)
          
            ' La primera no se usa
            .Add Nothing
            
            With .Add(Nothing)
              .Id = gDB.ValField(rs.Fields, cscFcdId)
              .Key = KI_FCD_ID
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
              .Value = gDB.ValField(rs.Fields, cscFcNrodoc)
              .Key = KI_NRODOC
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscFcNumero)
              .Id = gDB.ValField(rs.Fields, cscFcId)
              .Key = KI_FC_ID
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscFcFecha)
              .Key = KI_FECHA
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscMonNombre)
              .Id = gDB.ValField(rs.Fields, cscMonId) 'jav 2004-08-26
              .Key = KI_MONEDA
            End With
            
            With .Add(Nothing)
              Origen = gDB.ValField(rs.Fields, cscFcTotalOrigen)
              .Value = IIf(Origen, Origen, vbNullString)
              .Key = KI_IMPORTEORIGEN
              If Val(.Value) <> 0 Then bShowCotizacion = True
            End With
            
            With .Add(Nothing)
              Cotiz = gDB.ValField(rs.Fields, cscFcCotizacion)
              .Value = IIf(Cotiz, Cotiz, vbNullString)
              .Key = KI_COTIZACION
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscFcTotal)
              .Key = KI_TOTAL
            End With
            
            With .Add(Nothing)
              .Value = 0
              .Key = KI_COTIZACION2
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscFcdFecha)
              .Key = KI_VTO
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscFcPendiente)
              .Key = KI_PENDIENTE
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscFcdPendiente)
              .Key = KI_IMPORTE
            End With
            
            With .Add(Nothing)
              If bSelected Then
                .Value = gDB.ValField(rs.Fields, cscFcdPendiente)
              Else
                .Value = 0
              End If
              .Key = KI_APLICAR
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscFcDescrip)
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
  Else
    pGetFacturas().Columns(c_Wiz_Key_Cotizacion).Visible = True
    pGetFacturas().Columns(c_Wiz_Key_Moneda).Visible = True
    pGetCotizacion().Visible = True
    pGetTotalOrigen().Visible = True
  End If
  
  m_bMultiMoneda = False

  If UBound(vMonId) > 1 Then
    Set Moneda = New cMoneda
    
    m_bMultiMoneda = True
    
    pGetFacturas.Columns(c_Wiz_Key_Cotizacion2).Visible = True
    pGetCotizacion().Visible = False
  
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
  ElseIf UBound(vMonId) > 0 Then
    Set Moneda = New cMoneda
    
    pGetCotizacion().Value = Moneda.GetCotizacion(vMonId(1), Date)
    pRefreshCotizacion
    pGetFacturas.Columns(c_Wiz_Key_Cotizacion2).Visible = False
  End If
  
  m_ObjWizard.ShowValue pGetCotizacion()
  m_ObjWizard.ShowValue pGetTotalOrigen()
  
  pRefreshFacturas
  pShowTotalFacturas
  
  pLoadFacturasXProveedor = True
End Function

' Edit From ListDoc
'
Private Function pGetApply(ByVal fc_id As Long) As Boolean
  Dim i As Long
  
  For i = 1 To UBound(m_FcIds)
    If m_FcIds(i) = fc_id Then
      pGetApply = True
      Exit Function
    End If
  Next
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
                'Debe definir cual es la moneda legal con la que opera Cairo
    Exit Function
  End If
  
  pGetNomMonedaDefault = gDB.ValField(rs.Fields, "mon_signo")
End Function

Private Function pGetMonedaDefault() As Long
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select mon_id from Moneda where mon_legal <> 0"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then
    MsgWarning LNGGetText(2150, vbNullString)
                'Debe definir cual es la moneda legal con la que opera Cairo
    Exit Function
  End If
  
  pGetMonedaDefault = gDB.ValField(rs.Fields, cscMonId)
End Function

Private Function pGetCuentasAcreedor() As Boolean
  Dim i               As Long
  Dim Row             As cIABMGridRow
  Dim Cell            As cIABMGridCellValue
  Dim Total           As Double
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
  If Not GetCuentasAcreedor(pGetFacturas(), vCtaCte(), KI_FC_ID, KI_APLICAR, _
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
  pGetPagoIndicado.Value = Total
  m_ObjWizard.ShowValue pGetPagoIndicado
  
  pRefreshCtaCte
  
  ' Si se deben calcular las retenciones
  '
  If m_TesoreriaConfig.CalcularRetenciones Then
    
    pGetOtros.Rows.Clear
    
    Dim cue_id      As Long
    Dim cue_nombre  As String
    Dim ret_id      As Long
    Dim ret_nombre  As String
    Dim rsRet       As ADODB.Recordset
    
    Dim retencion   As Double
    Dim porcentaje  As Double
    Dim comprobante As String
    Dim base        As Double
    
    If Not pGetRetencionForProveedor(rsRet) Then Exit Function
    
    If rsRet.EOF Then
    
      MsgWarning LNGGetText(2210, vbNullString)
                  'Cairo está configurado para calcular retenciones, pero no sea ha
                  'indicado la Retención a usar.
    End If
    
    
    While Not rsRet.EOF

      ret_id = gDB.ValField(rsRet.Fields, cscRetId)
      ret_nombre = gDB.ValField(rsRet.Fields, cscRetNombre)
      
      pGetCuentaForRetencion ret_id, cue_id, cue_nombre
        
      If cue_id <> csNO_ID Then
      
        Dim Facturas    As String
        Dim sqlstmt     As String
        Dim rs          As ADODB.Recordset
        
        Facturas = pGetFacturarForRetencion()
        
        sqlstmt = "sp_DocOrdenPagoGetRetencion " & User.Id & "," _
                                                 & gDB.sqlDate(VDGetDateById(csMonth_FirstDay)) & "," _
                                                 & gDB.sqlDate(VDGetDateById(csMonth_LastDay)) & "," _
                                                 & pGetProveedor() & "," _
                                                 & EmpId & "," _
                                                 & ret_id & "," _
                                                 & gDB.sqlNumber(Total) & "," _
                                                 & gDB.sqlString(Facturas) & ", 1"
                                                 
        If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
      
        If Not rs.EOF Then
      
          retencion = gDB.ValField(rs.Fields, "retencion")
          porcentaje = gDB.ValField(rs.Fields, "porcentaje")
          comprobante = gDB.ValField(rs.Fields, "comprobante")
          base = gDB.ValField(rs.Fields, "base")
          
          If retencion > 0 Then
      
            With pGetOtros.Rows
              .Add Nothing
              With .Item(.count)
                .Add Nothing
                .Add(Nothing).Key = KIO_CUE_ID
                .Add(Nothing).Key = KIO_DEBE
                .Add(Nothing).Key = KIO_HABER
                .Add(Nothing).Key = KIO_IMPORTEORIGEN
                .Add(Nothing).Key = KIO_DESCRIP
                .Add(Nothing).Key = KIO_RET_ID
                .Add(Nothing).Key = KIO_NRORETENCION
                .Add(Nothing).Key = KIO_PORCRETENCION
                .Add(Nothing).Key = KIO_FECHARETENCION
                .Add(Nothing).Key = KIO_CCOS_ID
                .Add(Nothing).Key = KIO_FC_ID_RET
              End With
              
              With pCell(.Item(.count), KIO_CUE_ID)
                If .Id = csNO_ID Or .Id = cue_id Then
                  .Id = cue_id
                  .Value = cue_nombre
                End If
              End With
              
              With pCell(.Item(.count), KIO_RET_ID)
                If .Id = csNO_ID Or .Id = ret_id Then
                  .Id = ret_id
                  .Value = ret_nombre
                End If
              End With
              
              pCell(.Item(.count), KIO_DEBE).Value = retencion
              pCell(.Item(.count), KIO_PORCRETENCION).Value = porcentaje
              pCell(.Item(.count), KIO_NRORETENCION).Value = comprobante
              pCell(.Item(.count), KIO_DESCRIP).Value = LNGGetText(2972, vbNullString, _
                                                                   Format(base, _
                                                                   m_GeneralConfig.FormatDecImporte))
              
            End With
          Else
            
            ' Si la retencion dio 0 y la primera fila
            ' es de la retencion que estoy calculando
            ' borro la fila
            '
            With pGetOtros.Rows
              If .count > 0 Then
                If pCell(.Item(1), KIO_RET_ID).Id = ret_id And ret_id <> csNO_ID Then
                  .Remove 1
                End If
              End If
            End With
          End If
        End If
      Else
        MsgWarning LNGGetText(2209, vbNullString, retencion)
                  'Cairo está configurado para calcular retenciones, pero no se ha
                  'configurado la Cuenta Contable para la Retención " & retencion & "."
      End If
      
      rsRet.MoveNext
    Wend
  
  End If
  
  pRefreshOtros
  pShowPagoOtro
  pShowPagoTotal
  
  pGetCuentasAcreedor = True
End Function

Private Function pGetRetencionForProveedor(ByRef rs As ADODB.Recordset) As Boolean
  Dim sqlstmt As String
 
  sqlstmt = "sp_RetencionGetForProvId " & _
                     pGetProveedor() & "," & _
                     EmpId & "," & _
                     gDB.sqlDate(pGetFecha().Value)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  pGetRetencionForProveedor = True
  
End Function

Private Sub pGetCuentaForRetencion(ByVal ret_id As Long, _
                                   ByRef cue_id As Long, _
                                   ByRef cue_nombre As String)
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_RetencionTipoGetCuenta " & ret_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  cue_id = gDB.ValField(rs.Fields, cscCueId)
  cue_nombre = gDB.ValField(rs.Fields, cscCueNombre)
End Sub

Private Function pGetFacturarForRetencion() As String
  Dim rtn     As String
  Dim Row     As cIABMGridRow
  Dim Value   As Double
  
  For Each Row In pGetFacturas().Rows
    If pCell(Row, KI_SELECT).Id Then
      Value = Val(pCell(Row, KI_APLICAR).Value)
      If Value Then
        If Value <> Val(pCell(Row, KI_PENDIENTE).Value) Then
          rtn = rtn & pCell(Row, KI_FC_ID).Value & "-" & gDB.sqlNumber(Value) & "*"
        Else
          rtn = rtn & pCell(Row, KI_FC_ID).Value & "*"
        End If
      End If
    End If
  Next
  
  If Right(rtn, 1) = "*" Then rtn = Left(rtn, Len(rtn) - 1)
  
  pGetFacturarForRetencion = rtn
End Function

' Validaciones de Filas de Instrumentos de Pago
Private Function pIsEmptyRowCheques(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KICH_CUE_ID, KICH_CHEQUERA, KICH_MON_ID, KICH_CLE_ID
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

Private Function pIsEmptyRowTCheques(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KICHT_CUE_ID, KICHT_MON_ID, KICHT_CLE_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    
      Case KICHT_IMPORTE, KICHT_IMPORTEORIGEN
        If Not ValEmpty(Val(Cell.Value), csDouble) Then
          bRowIsEmpty = True
          Exit For
        End If
      
      Case KICHT_DESCRIP, KICHT_CHEQUE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = True
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowTCheques = bRowIsEmpty
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
      
      Case KICH_CHEQUERA
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2193, vbNullString, strRow) 'Debe indicar una chequera (1)
          Exit Function
        End If
      
      Case KICH_CHEQUE
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(2197, vbNullString, strRow) 'Debe indicar un cheque (1)
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
    MsgInfo LNGGetText(2211, vbNullString, strRow)
            'Debe indicar un importe para la moneda extranjera en la solapa de Cheques (1)
    Exit Function
  End If
  
  pValidateRowCheques = True
End Function

Private Function pValidateRowTCheques(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bOrigen               As Boolean
  Dim MonId                 As Long
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      
      Case KICHT_CUE_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2113, vbNullString, strRow)  'Debe indicar una cuenta contable (1)
          Exit Function
        End If
      
      Case KICHT_CHEQUE
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2197, vbNullString, strRow)  'Debe indicar un cheque (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowTCheques = True
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
          MsgInfo LNGGetText(2113, vbNullString, strRow)  'Debe indicar una cuenta contable (1)
          Exit Function
        End If
      
        If Not gDB.GetData(csTCuenta, cscCueId, Cell.Id, cscMonId, MonId) Then Exit Function

        If MonId = csNO_ID Then
          MsgInfo LNGGetText(2212, vbNullString, Cell.Value, strRow)
            'Debe indicar una moneda para la cuenta " & Cell.Value & " en la solapa otros" & strRow
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
            'Debe indicar un importe para la moneda extranjera en la solapa de otros (1)
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
          MsgInfo LNGGetText(2113, vbNullString, strRow)  'Debe indicar una cuenta contable (1)
          Exit Function
        End If
        
        If Not gDB.GetData(csTCuenta, cscCueId, Cell.Id, cscMonId, MonId) Then Exit Function
        
        If MonId = csNO_ID Then
          MsgInfo LNGGetText(2213, vbNullString, Cell.Value, strRow)
          'Debe indicar una moneda para la cuenta " & Cell.Value & " en la solapa efectivo" & strRow
          Exit Function
        End If
        
      Case KIE_IMPORTEORIGEN
        bOrigen = Not ValEmpty(Val(Cell.Value), csDouble)
      
      Case KIE_IMPORTE
        If ValEmpty(Val(Cell.Value), csDouble) Then
          MsgInfo LNGGetText(1897, vbNullString, strRow)  'Debe indicar un importe (1)
          Exit Function
        End If
    End Select
  Next
  
  If Not bOrigen And MonId <> m_MonDefault Then
    MsgInfo LNGGetText(2118, vbNullString, strRow)
            'Debe indicar un importe para la moneda extranjera en la solapa de efectivo (1)
    Exit Function
  End If
  
  pValidateRowEfectivo = True
End Function

Private Function pValidatePago() As Boolean
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
  For Each Row In pGetTCheques().Rows
    i = i + 1
    If Not pIsEmptyRowTCheques(Row, i) Then
      If Not pValidateRowTCheques(Row, i) Then Exit Function
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
  
  If Round(Val(pGetPagoIndicado().Value), m_GeneralConfig.DecimalesImporte) _
     <> Round(Val(pGetPagoTotal().Value), m_GeneralConfig.DecimalesImporte) Then
    MsgWarning LNGGetText(2214, vbNullString)
          'El total de los instrumentos de pago no coincide con el monto a pagar
    Exit Function
  End If
  pValidatePago = True
End Function

Private Sub pGetDocNumber()
  Dim Tl          As cTalonario
  Dim TAL_ID      As Long
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  Dim Mask        As String
  Dim bEditable   As Boolean
  
  If pGetComprobante().Value <> vbNullString Then Exit Sub
  
  sqlstmt = "sp_ProveedorGetTalonario " & pGetProveedor() & "," & pGetDoc()
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
  With pGetProveedor2
    .HelpId = pGetProveedor
    .Value = pGetProveedorName
  End With
  m_ObjWizard.ShowValue pGetProveedor2
  pGetDocNumber
  pSetDatosFromAplic
End Sub

Private Function pValidateDatosGenerales() As Boolean
  If ValEmpty(pGetFecha().Value, csDate) Then
    MsgWarning LNGGetText(2215, vbNullString) 'Debe indicar la fecha de la Orden de Pago
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
  
  c_ErrorSave = LNGGetText(1910, vbNullString) 'Error al grabar la Orden de Pago
  
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  Set m_TesoreriaConfig = New cTesoreriaConfig
  m_TesoreriaConfig.Load
  
  m_MonDefault = pGetMonedaDefault()
  ReDim m_FcIds(0)
  
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
  ReDim m_FcIds(0)
  Set m_ObjClient = Nothing

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
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  
  With register
    
    .fieldId = cscOpgTMPId
    .Table = csTOrdenPagoTMP
    .Id = csNew
  
    With .Fields
      
      .Add2 cscOpgNumero, 0, csLong
      With pGetComprobante()
        ' PrintDoc
        '
        m_LastNroDoc = SetMask(.Value, .TextMask)
        register.Fields.Add2 cscOpgNrodoc, m_LastNroDoc, csText
      End With
      .Add2 cscOpgDescrip, pGetDescrip().Value, csText
      .Add2 cscOpgFecha, pGetFecha().Value, csDate
      m_LastProv = pGetProveedor()
      .Add2 cscProvId, m_LastProv, csId
      .Add2 cscCcosId, pGetCentroCosto().HelpId, csId
      .Add2 cscSucId, pGetSucursal().HelpId, csId
      .Add2 cscDocId, pGetDoc(), csId
      .Add2 cscOpgCotizacion, Val(pGetCotizacion().Value), csDouble
      .Add2 cscLgjId, pGetLegajo().HelpId, csId
      
      .Add2 cscOpgNeto, Val(pGetPagoNeto().Value), csCurrency
      .Add2 cscOpgOtros, Val(pGetPagoOtros().Value), csCurrency
      .Add2 cscOpgTotal, Val(pGetPagoTotal().Value), csCurrency
      
      .Add2 cscOpgGrabarAsiento, 1, csBoolean
      .Add2 cscEstId, CSGeneralEx2.csEEstado.csEEst_Pendiente, csId
      .Add2 cscOpgId, csNew, csLong
      
      .HaveLastUpdate = True
      .HaveWhoModify = True
    
    End With
            
    If Not .BeginTrans(gDB) Then Exit Function
    
    If Not gDB.Save(register, , "pSave", C_Module, c_ErrorSave) Then Exit Function
    
    m_iOrden = 0
    If Not pSaveCheques(.Id) Then Exit Function
    If Not pSaveTCheques(.Id) Then Exit Function
    If Not pSaveEfectivo(.Id) Then Exit Function
    If Not pSaveOtros(.Id) Then Exit Function
    If Not pSaveCtaCte(.Id) Then Exit Function
    If Not pSaveFacturas(.Id) Then Exit Function
    
    If Not .CommitTrans() Then Exit Function
    
  End With
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocOrdenPagoSave " & register.Id
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
        
        .fieldId = cscOpgiTMPId
        .Table = csTOrdenPagoItemTMP
        .Id = csNew
      
        With .Fields
      
          For Each Cell In Row
            Select Case Cell.Key
              
              Case KICH_DESCRIP
                .Add2 cscOpgiDescrip, Cell.Value, csText
              
              Case KICH_CHEQUERA
                .Add2 cscChqId, Cell.Id, csId
              
              Case KICH_CHEQUE
                .Add2 cscOpgiTMPCheque, Cell.Value, csText
              
              Case KICH_CLE_ID
                .Add2 cscCleId, Cell.Id, csId
              
              Case KICH_MON_ID
                .Add2 cscMonId, Cell.Id, csId
              
              Case KICH_FECHACOBRO
                .Add2 cscOpgiTMPFechaCobro, Cell.Value, csDate
              
              Case KICH_FECHAVTO
                .Add2 cscOpgiTMPFechaVto, Cell.Value, csDate
              
              Case KICH_CUE_ID
                .Add2 cscCueId, csNO_ID, csId
              
              Case KICH_IMPORTEORIGEN
                .Add2 cscOpgiImporteOrigen, Val(Cell.Value), csCurrency
              
              Case KICH_IMPORTE
                .Add2 cscOpgiImporte, Val(Cell.Value), csCurrency
            End Select
          Next
          
          m_iOrden = m_iOrden + 1
          .Add2 cscOpgiOrden, m_iOrden, csInteger
          .Add2 cscOpgiTipo, csEOrdenPagoItemTipo.csEOpgiTCheques, csInteger
          .Add2 cscOpgTMPId, Id, csId
          .Add2 cscOpgiId, csNew, csLong
          .Add2 cscOpgiOtroTipo, csEItemOtroTipo.csEOtroHaber, csInteger
          
          .HaveLastUpdate = False
          .HaveWhoModify = False
          
        End With
      End With
                                                            
      If Not gDB.Save(register, , "pSaveCheques", C_Module, c_ErrorSave) Then Exit Function
    End If
  Next
  
  pSaveCheques = True
End Function

Private Function pSaveTCheques(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  Dim i         As Long
  
  For Each Row In pGetTCheques().Rows
  
    i = i + 1
    If Not pIsEmptyRowTCheques(Row, i) Then
    
      Set register = New cRegister
      
      With register
      
        .fieldId = cscOpgiTMPId
        .Table = csTOrdenPagoItemTMP
        .Id = csNew
          
        With .Fields
          
          For Each Cell In Row
            Select Case Cell.Key
              
              Case KICHT_DESCRIP
                .Add2 cscOpgiDescrip, Cell.Value, csText
              
              Case KICHT_CHEQUE
                .Add2 cscCheqId, Cell.Id, csId
              
              Case KICHT_CLE_ID
                .Add2 cscCleId, Cell.Id, csId
              
              Case KICHT_MON_ID
                .Add2 cscMonId, Cell.Id, csId
              
              Case KICHT_FECHACOBRO
                .Add2 cscOpgiTMPFechaCobro, Cell.Value, csDate
              
              Case KICHT_FECHAVTO
                .Add2 cscOpgiTMPFechaVto, Cell.Value, csDate
              
              Case KICHT_CUE_ID
                .Add2 cscCueId, Cell.Id, csId
              
              Case KICHT_IMPORTEORIGEN
                .Add2 cscOpgiImporteOrigen, Val(Cell.Value), csCurrency
              
              Case KICHT_IMPORTE
                .Add2 cscOpgiImporte, Val(Cell.Value), csCurrency
            End Select
          Next
          
          m_iOrden = m_iOrden + 1
          .Add2 cscOpgiOrden, m_iOrden, csInteger
          .Add2 cscOpgiTipo, csEOrdenPagoItemTipo.csEOpgiTChequesT, csInteger
          .Add2 cscOpgTMPId, Id, csId
          .Add2 cscOpgiId, csNew, csLong
          .Add2 cscOpgiOtroTipo, csEItemOtroTipo.csEOtroHaber, csInteger
          
          .HaveLastUpdate = False
          .HaveWhoModify = False
      
        End With
      End With
                                                            
      If Not gDB.Save(register, , "pSaveTCheques", C_Module, c_ErrorSave) Then Exit Function
    End If
  Next
  
  pSaveTCheques = True
End Function

Private Function pSaveOtros(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  Dim i         As Long
  
  For Each Row In pGetOtros().Rows
  
    i = i + 1
    If Not pIsEmptyRowOtros(Row, i) Then
    
      Set register = New cRegister
      
      With register
      
        .fieldId = cscOpgiTMPId
        .Table = csTOrdenPagoItemTMP
        .Id = csNew
      
        With .Fields
      
          For Each Cell In Row
            Select Case Cell.Key
              
              Case KIO_DESCRIP
                .Add2 cscOpgiDescrip, Cell.Value, csText
              Case KIO_RET_ID
                .Add2 cscRetId, Cell.Id, csId
              Case KIO_NRORETENCION
                .Add2 cscOpgiNroRetencion, Cell.Value, csText
              Case KIO_PORCRETENCION
                .Add2 cscOpgiPorcRetencion, Val(Cell.Value), csDouble
              Case KIO_CCOS_ID
                .Add2 cscCcosId, Cell.Id, csId
              Case KIO_FC_ID_RET
                .Add2 cscFcIdRet, Cell.Id, csId
              Case KIO_CUE_ID
                .Add2 cscCueId, Cell.Id, csId
              Case KIO_FECHARETENCION
                If Not ValEmpty(Cell.Value, csDate) Then
                  .Add2 cscOpgiFechaRetencion, Cell.Value, csDate
                End If
              Case KIO_IMPORTEORIGEN
                .Add2 cscOpgiImporteOrigen, Val(Cell.Value), csCurrency
              Case KIO_DEBE
                If Val(Cell.Value) <> 0 Then
                  .Add2 cscOpgiImporte, Val(Cell.Value), csCurrency
                  .Add2 cscOpgiOtroTipo, csEItemOtroTipo.csEOtroHaber, csInteger
                End If
              Case KIO_HABER
                If Val(Cell.Value) <> 0 Then
                  .Add2 cscOpgiImporte, Val(Cell.Value), csCurrency
                  .Add2 cscOpgiOtroTipo, csEItemOtroTipo.csEOtroDebe, csInteger
                End If
            End Select
          Next
          
          m_iOrden = m_iOrden + 1
          .Add2 cscOpgiOrden, m_iOrden, csInteger
          .Add2 cscOpgiTipo, csEOrdenPagoItemTipo.csEOpgiTOtros, csInteger
          .Add2 cscOpgiId, csNew, csLong
          .Add2 cscOpgTMPId, Id, csId
          
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
        
        .fieldId = cscOpgiTMPId
        .Table = csTOrdenPagoItemTMP
        .Id = csNew
          
        With .Fields
          
          For Each Cell In Row
            Select Case Cell.Key
              
              Case KIE_DESCRIP
                .Add2 cscOpgiDescrip, Cell.Value, csText
              Case KIE_CUE_ID
                .Add2 cscCueId, Cell.Id, csId
              Case KIE_IMPORTEORIGEN
                .Add2 cscOpgiImporteOrigen, Val(Cell.Value), csCurrency
              Case KIE_IMPORTE
                .Add2 cscOpgiImporte, Val(Cell.Value), csCurrency
            End Select
          Next
          
          m_iOrden = m_iOrden + 1
          .Add2 cscOpgiOrden, m_iOrden, csInteger
          .Add2 cscOpgiTipo, csEOrdenPagoItemTipo.csEOpgiTEfectivo, csInteger
          .Add2 cscOpgTMPId, Id, csId
          .Add2 cscOpgiId, csNew, csLong
          .Add2 cscOpgiOtroTipo, csEItemOtroTipo.csEOtroHaber, csInteger
          
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
      
      .fieldId = cscOpgiTMPId
      .Table = csTOrdenPagoItemTMP
      .Id = csNew
    
      With .Fields
      
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KICC_CUE_ID
              .Add2 cscCueId, Cell.Id, csId
            Case KICC_IMPORTEORIGEN
              .Add2 cscOpgiImporteOrigen, Val(Cell.Value), csCurrency
            Case KICC_IMPORTE
              .Add2 cscOpgiImporte, Val(Cell.Value), csCurrency
          End Select
        Next
        
        m_iOrden = m_iOrden + 1
        .Add2 cscOpgiOrden, m_iOrden, csInteger
        .Add2 cscOpgiTipo, csEOrdenPagoItemTipo.csEOpgiTCtaCte, csInteger
        .Add2 cscOpgTMPId, Id, csId
        .Add2 cscOpgiId, csNew, csLong
        .Add2 cscOpgiOtroTipo, csEItemOtroTipo.csEOtroDebe, csInteger
        
        .HaveLastUpdate = False
        .HaveWhoModify = False
    
      End With
    End With
                                                          
    If Not gDB.Save(register, , "pSaveCtaCte", C_Module, c_ErrorSave) Then Exit Function
  Next
  
  pSaveCtaCte = True
End Function

Private Function pGetIva(ByRef vIva() As T_Iva) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim FcIds   As String
  Dim i       As Long
  
  ReDim vIva(0)
  
  FcIds = pGetfcIds()
  sqlstmt = "select fci_ivariporc, sum(fci_ivari) as fci_ivari" & _
            " from FacturaVentaItem" & _
            " where fc_id in(" & FcIds & ")" & _
            " group by fci_ivariporc"
            
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    rs.MoveLast
    rs.MoveFirst
    ReDim vIva(rs.RecordCount)
  End If
  
  While Not rs.EOF
    i = i + 1
    With vIva(i)
      .importe = gDB.ValField(rs.Fields, cscFciIvari)
      .porcentaje = gDB.ValField(rs.Fields, cscFciIvariporc)
    End With
    rs.MoveNext
  Wend
  pGetIva = True
End Function

Private Function pGetfcIds() As String
  Dim rtn As String
  Dim Row As cIABMGridRow
  
  For Each Row In pGetFacturas().Rows
    If pCell(Row, KI_SELECT).Id Then
      If Val(pCell(Row, KI_APLICAR).Value) Then
        rtn = rtn & pCell(Row, KI_FC_ID).Id & ","
      End If
    End If
  Next
  
  pGetfcIds = RemoveLastColon(rtn)
End Function

Private Function pSaveFacturas(ByVal Id As Long) As Boolean
  Dim register        As cRegister
  Dim bSave           As Boolean
  Dim Row             As cIABMGridRow
  Dim Cell            As cIABMGridCellValue
  Dim Pago            As Double
  Dim CotiOrigen      As Double
  Dim CotiOrdenPago    As Double
  
  For Each Row In pGetFacturas().Rows
  
    Set register = New cRegister
    
    With register
      
      .fieldId = cscFcOpgTMPid
      .Table = csTFacturaCompraOrdenPagoTMP
      .Id = csNew
    
      bSave = False
      
      With .Fields
      
        For Each Cell In Row
          If pCell(Row, KI_SELECT).Id Then
            bSave = True
            Select Case Cell.Key
              Case KI_FC_ID
                .Add2 cscFcId, Cell.Id, csId
              Case KI_FCD_ID
                .Add2 cscFcdId, Cell.Id, csId
              Case KI_APLICAR
                Pago = Val(Cell.Value)
              Case KI_IMPORTEORIGEN
                .Add2 cscFcOpgImporteOrigen, Val(Cell.Value), csDouble
              Case KI_COTIZACION
                CotiOrigen = Val(Cell.Value)
              Case KI_COTIZACION2
                CotiOrdenPago = Val(Cell.Value)
                .Add2 cscFcOpgCotizacion, CotiOrdenPago, csDouble
            End Select
          End If
        Next
        
        If bSave Then
        
          ' Si hay diferencia de cambio y la cotizacion original
          ' del comprobante es menor que la de la OrdenPago aplico
          ' SIEMPRE por la cotizacion del comprobante
          If CotiOrigen < CotiOrdenPago Then
            Pago = Pago / CotiOrdenPago * CotiOrigen
          End If
          
          .Add2 cscFcOpgImporte, Pago, csDouble
          .Add2 cscFcOpgId, 0, csLong
          .Add2 cscOpgTMPId, Id, csId
          .Add2 cscOpgId, 0, csLong
          
          .HaveLastUpdate = False
          .HaveWhoModify = False
                                                                
          If Not gDB.Save(register, , "pSaveFacturas", C_Module, c_ErrorSave) Then Exit Function
        End If
        
      End With
    End With
  Next
  
  pSaveFacturas = True
End Function

#If Not PREPROC_SFS Then
  Private Sub pSetObjectForm()
    Dim AbmGen      As cABMGenericDocEx
    Dim WizGen      As cWizardGenericDocEx
  
    Set WizGen = m_ObjWizard
    Set AbmGen = WizGen.ObjAbm
    
    With AbmGen
      .FactoryObject = "CSABMInterface2.cFactory"
      .ObjForm = "CSABMInterface2.fwOrdenPago"
    End With
  End Sub
#End If

Private Sub pNewEmptyProperties()
  ' (ByRef Grid As cIABMGrid)
  pGetAnticipo().Value = 0
  
  pGetFacturas().Rows.Clear
  pGetOtros().Rows.Clear
  pGetCheques().Rows.Clear
  pGetTCheques().Rows.Clear
  pGetEfectivo().Rows.Clear
  pGetCtaCte().Rows.Clear
  
  pGetPagoNeto().Value = 0
  pGetPagoOtros().Value = 0
  pGetPagoTotal().Value = 0
  
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
    .ShowValue pGetFacturasProperty()
    .ShowValue pGetOtrosProperty()
    .ShowValue pGetChequesProperty()
    .ShowValue pGetChequesTProperty()
    .ShowValue pGetEfectivoProperty()
    .ShowValue pGetCtaCteProperty()
    .ShowValue pGetAnticipo()
    .ShowValue pGetPagoNeto()
    .ShowValue pGetPagoOtros()
    .ShowValue pGetPagoTotal()
    .ShowValue pGetComprobante()
    .ShowValue pGetCentroCosto()
    .ShowValue pGetDescrip()
  End With
  
End Sub

Private Sub pSetDatosFromAplic()
  Dim sqlstmt           As String
  Dim rs                As Recordset
  Dim i                 As Long
  
  sqlstmt = "sp_DocOrdenPagoGetDataFromAplic 2,'" & pGetfcIds & "'"
  
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


'--------------------------------------------------------------------

Private Sub pCopyCheque()
  If pGetCheques.Rows.count Then
  
    Dim scount As String
    Dim smeses As String
  
    Dim count As Long
    Dim meses As Long
    
    count = 1
    scount = count
    
    If GetInput(scount, LNGGetText(3840, vbNullString)) Then '"Ingrese la cantidad de veces que desea copiar el cheque
    
      count = Val(scount)
      If count = 0 Then Exit Sub
      
      meses = 1
      smeses = meses
      If GetInput(smeses, LNGGetText(3841, vbNullString)) Then '"Ingrese la cantidad de meses entre vencimientos
    
        meses = Val(smeses)
        If meses = 0 Then Exit Sub
    
        Dim Row     As cIABMGridRow
        Dim NewRow  As cIABMGridRow
        Dim Rows    As cIABMGridRows
        
        Set Rows = pGetCheques.Rows
        With Rows
          Set Row = .Item(.count)
        End With
        
        Dim i As Long
        Dim j As Long
        
        Dim Numero      As Long
        Dim FechaCobro  As Date
        
        Numero = Val(pCell(Row, KICH_CHEQUE).Value)
        FechaCobro = pCell(Row, KICH_FECHACOBRO).Value
        
        For i = 1 To count
          Set NewRow = Rows.Add(Nothing)
          FechaCobro = DateAdd("m", meses, FechaCobro)
          Numero = Numero + 1
          With NewRow
            For j = 1 To Row.count
              If j > 1 Then
                NewRow.Add Nothing
                Set .Item(j).Format = Row.Item(j).Format
                .Item(j).Id = Row.Item(j).Id
                .Item(j).Key = Row.Item(j).Key
                
                If Row.Item(j).Key = KICH_FECHACOBRO Then
                  .Item(j).Value = FechaCobro
                ElseIf Row.Item(j).Key = KICH_FECHAVTO Then
                  .Item(j).Value = DateAdd("m", 1, FechaCobro)
                ElseIf Row.Item(j).Key = KICH_CHEQUE Then
                  .Item(j).Value = Numero
                Else
                  .Item(j).Value = Row.Item(j).Value
                End If
              End If
            Next
          End With
        Next
        
        Dim WizObj As cWizardGeneric
        Dim AbmObj As cABMGeneric
        Set WizObj = m_ObjWizard
        Set AbmObj = WizObj.ObjAbm
        
        AbmObj.ShowValue pGetChequesProperty(), True
        
        pShowPagoNeto
        pShowPagoTotal
        
      End If
    End If
  Else
    MsgWarning LNGGetText(3841, vbNullString) 'Debe agregar al menos un cheque para poder copiarlo
  End If
End Sub

Private Sub pSetFilterColFactura()
  
  Dim WizObj As cWizardGeneric
  Dim AbmObj As cABMGeneric
  
  Set WizObj = m_ObjWizard
  Set AbmObj = WizObj.ObjAbm
  
  pCol(pGetOtros().Columns, KIO_FC_ID_RET).HelpFilter = "prov.prov_id = " & pGetProveedor()
  AbmObj.RefreshColumnProperties pGetOtrosProperty(), cscFcIdRet
  
End Sub

Private Sub pShowMessages()
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocOrdenPagoProveedorShowMessagess " & pGetProveedor() & "," & EmpId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  MsgInfo rs.Fields(0)
  
End Sub
