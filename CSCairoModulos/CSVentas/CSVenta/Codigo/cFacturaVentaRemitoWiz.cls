VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFacturaVentaRemitoWiz"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIWizardClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cFacturaVentaRemitoWiz
' 05-05-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cFacturaVentaRemitoWiz"

' HIDECOLS
Private Const c_HideColsFv = "HideColsFv"

Private Const c_StepWelcome             As Integer = 1
Private Const c_StepSelectCliente       As Integer = 3
Private Const c_StepSelectRemito        As Integer = 4
Private Const c_StepSelectItems         As Integer = 6
Private Const c_StepNewItems            As Integer = 9
Private Const c_StepPercepciones        As Integer = 8
Private Const c_StepDatosGenerales      As Integer = 7

' Paso 2
Private Const KW_REMITOS                     As Integer = 10
Private Const KW_TODOS                       As Integer = 110

' Paso 3
Private Const KW_ITEMS                       As Integer = 120
Private Const KW_TODOS_ITEMS                 As Integer = 130

' Paso 4
Private Const KW_NEW_ITEMS                   As Integer = 140

' Paso 5
Private Const KW_PERCEPCIONES                   As Integer = 150
Private Const KW_TOTAPERCEPCIONES               As Integer = 160

' Paso 6
Private Const KW_LPALL_ITEMS                 As Integer = 131 'lp
Private Const KW_LPZERO_ITEMS                As Integer = 132 'lp
Private Const KW_CLIENTE2                    As Integer = 220
Private Const KW_FECHA                       As Integer = 230
Private Const KW_FECHAIVA                    As Integer = 231
Private Const KW_SUCURSAL                    As Integer = 240
Private Const KW_CONDICION_PAGO              As Integer = 245
Private Const KW_DESCRIP                     As Integer = 250
Private Const KW_COMPROBANTE                 As Integer = 260
Private Const KW_LEGAJO                      As Integer = 280
Private Const KW_CENTROCOSTO                 As Integer = 290
Private Const KW_LP_ID                       As Integer = 300
Private Const KW_LP_ID2                      As Integer = 305 'lp
Private Const KW_LD_ID                       As Integer = 310

Private Const KW_DOC_ID                      As Integer = 320
Private Const KW_CLI_ID                      As Integer = 340

Private Const KW_COTIZACION                  As Integer = 350 'lp
Private Const KW_VEN_ID                      As Integer = 360 'lp

Private Const KW_TRANS_ID                    As Integer = 380
Private Const KW_PRO_ID_ORIGEN               As Integer = 390 'lp
Private Const KW_PRO_ID_DESTINO              As Integer = 400 'lp
Private Const KW_CLIS_ID                     As Integer = 420

Private Const KW_ORDENCOMPRA                 As Integer = 670

Private Const KI_RV_ID                       As Integer = 1
Private Const KI_SELECT                      As Integer = 2
Private Const KI_DOC                         As Integer = 3
Private Const KI_NRODOC                      As Integer = 4
Private Const KI_FECHA                       As Integer = 5
Private Const KI_DESCRIP                     As Integer = 600
Private Const KI_TOTAL                       As Integer = 10

' TO
Private Const KII_TO_ID                  As Integer = 400

Private Const KII_SELECT                 As Integer = 1
Private Const KII_RVI_ID                 As Integer = 2
Private Const KII_ARTICULO               As Integer = 5
Private Const KII_CANTIDAD               As Integer = 6
Private Const KII_PENDIENTE              As Integer = 7
Private Const KII_APLICAR                As Integer = 8
Private Const KII_PRECIOIVA              As Integer = 9
Private Const KII_TOTAL                  As Integer = 10
Private Const KII_DESCRIP                As Integer = 11
Private Const KII_PRECIO_SIN_IVA         As Integer = 12
Private Const KII_PRECIO_LP              As Integer = 13
Private Const KII_PRECIO_USR             As Integer = 14
Private Const KII_IVARIPercent           As Integer = 15
Private Const KII_IVARNIPercent          As Integer = 16
Private Const KII_DESCUENTO              As Integer = 17
Private Const KII_CCOS_ID                As Integer = 18

' Internos
Private Const KII_INTERNOSPercent        As Integer = 19
Private Const KII_INTERNOSPorc           As Integer = 20

' New items
Private Const KI_FVI_ID                         As Integer = 2
Private Const KI_ORDEN                          As Integer = 3
Private Const KI_CANTIDAD                       As Integer = 4
Private Const KI_PRECIO                         As Integer = 7
Private Const KI_IMPORTE                        As Integer = 8
Private Const KI_NETO                           As Integer = 9
Private Const KI_IVARI                          As Integer = 10
Private Const KI_IVARNI                         As Integer = 11
Private Const KI_INTERNOS                       As Integer = 101 ' Internos
Private Const KI_INTERNOS_PORC                  As Integer = 103 ' Internos
Private Const KI_PR_ID                          As Integer = 13
Private Const KI_LPI_ID                         As Integer = 14
Private Const KI_LDI_ID                         As Integer = 15
Private Const KI_IVARIPercent                   As Integer = 16
Private Const KI_IVARNIPercent                  As Integer = 17
Private Const KI_INTERNOSPercent                As Integer = 102 ' Internos
Private Const KI_DESCUENTO                      As Integer = 18
Private Const KI_UNIDAD                         As Integer = 19
Private Const KI_PRECIO_LP                      As Integer = 20
Private Const KI_PRECIO_USR                     As Integer = 21
Private Const KI_CUE_ID                         As Integer = 23
Private Const KI_CUE_ID_IVARI                   As Integer = 24
Private Const KI_CUE_ID_IVARNI                  As Integer = 25

Private Const KI_PR_LLEVANROSERIE               As Integer = 26
Private Const KI_ES_KIT                         As Integer = 27
Private Const KI_NROSERIE                       As Integer = 28
Private Const KI_GRUPO                          As Integer = 29

' Lote
'
Private Const KI_STL_ID                         As Integer = 30
Private Const KI_PR_LLEVALOTE                   As Integer = 31

' Lote Fifo
'
Private Const KI_PR_LOTEFIFO                    As Integer = 32

' TO
Private Const KI_TO_ID                          As Integer = 400

Private Const KW_DEPL_ID                        As Integer = 500

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_ObjWizard               As cIWizardGeneric

Private m_WizardProcessing        As Boolean
Private m_WizardCancel            As Boolean

'Private m_Resource                As fResource

Private m_GeneralConfig     As cGeneralConfig

Private m_Id                As Long

Private m_cli_id            As Long
Private m_cliente           As String
Private m_doc_id            As Long
Private m_Documento         As String
Private m_RvIds()           As Long

Private m_bShowStockData               As Boolean

' Lote
'
Private m_depf_id                      As Long

Private m_ObjClient         As Object

Private m_bIva              As Boolean
Private m_bIvaRni           As Boolean

Private m_LastCli           As Long
Private m_LastDoc           As Long
Private m_lastmonid         As Long

Private m_FvTotal           As Double

' PrintDoc
'
Private m_LastNroDoc        As String

Private m_StockConfig       As cStockConfig

'nrs
Private m_NrosSerie         As Collection
Private m_CollKitInfo       As Collection

' Autorun
Private m_bAutoSelect       As Boolean
Private m_bAutoPago         As Boolean
Private m_ModoVentaCtaCte   As Boolean
Private m_cue_id_autoPago   As Long

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

' Percepciones
'
Private m_doc_sin_perc      As Boolean
Private m_vPercepciones()   As T_Percepcion

Private m_cj_id             As Long

' eventos
' propiedades publicas
Public Property Get id() As Long
  id = m_Id
End Property

Public Property Let doc_id(ByVal rhs As Long)
  m_doc_id = rhs
End Property

Public Property Let Documento(ByVal rhs As String)
  m_Documento = rhs
End Property

Public Property Let cli_id(ByVal rhs As Long)
  m_cli_id = rhs
End Property

Public Property Let cj_id(ByVal rhs As Long)
  m_cj_id = rhs
End Property

Public Property Let Cliente(ByVal rhs As String)
  m_cliente = rhs
End Property

Public Property Let RvIds(ByRef rhs() As Long)
  On Error Resume Next
  Dim i As Long
  ReDim m_RvIds(UBound(rhs))
  For i = 1 To UBound(rhs)
    m_RvIds(i) = rhs(i)
  Next
End Property

Public Property Set ObjClient(ByVal rhs As Object)
  Set m_ObjClient = rhs
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

' Implementacion de cIABMClientGrid
Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case KW_REMITOS
      cIABMClientGrid_IsEmptyRow = False
    Case KW_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowItems(Row, RowIndex)
    Case KW_PERCEPCIONES
      cIABMClientGrid_IsEmptyRow = IsEmptyRowPercepciones(Row, RowIndex)
    Case KW_NEW_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowNewItems(Row, RowIndex)
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
    Case KW_REMITOS
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateRemito(pGetRemitosProperty(), lRow, lCol)
    Case KW_ITEMS
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateItems(pGetItemsProperty(), lRow, lCol)
    Case KW_NEW_ITEMS
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateNewItems(pGetNewItemsProperty(), lRow, lCol)
    Case KW_PERCEPCIONES
      PercepcionShowTotales pGetPercepciones.Rows, pGetTotalPercepciones()
      m_ObjWizard.ShowValue pGetTotalPercepciones()
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
    Case KW_REMITOS
      cIABMClientGrid_ColumnAfterEdit = True
    Case KW_ITEMS
      cIABMClientGrid_ColumnAfterEdit = True
    Case KW_NEW_ITEMS
      cIABMClientGrid_ColumnAfterEdit = pColumnAfterEdit( _
                                            pGetNewItemsProperty(), _
                                            lRow, _
                                            lCol, _
                                            NewValue, _
                                            NewValueID)
    Case KW_PERCEPCIONES
      cIABMClientGrid_ColumnAfterEdit = ColumnAfterEditPercepciones(pGetPercepcionesProperty(), lRow, lCol, NewValue, NewValueID)
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
    Case KW_REMITOS
      cIABMClientGrid_ColumnBeforeEdit = pColBEditRemitos(pGetRemitosProperty(), lRow, lCol, iKeyAscii)
    Case KW_ITEMS
      cIABMClientGrid_ColumnBeforeEdit = pColBEditItems(pGetItemsProperty(), lRow, lCol, iKeyAscii)
    Case KW_NEW_ITEMS
      cIABMClientGrid_ColumnBeforeEdit = True
    Case KW_PERCEPCIONES
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
  Dim Row As cIABMGridRow
  
  Select Case Key
    Case KW_NEW_ITEMS
      With pGetNewItems()
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
                                                               csNO_ID, pGetCliente())
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
  
  Select Case Key
    Case KW_REMITOS
    Case KW_ITEMS
    Case Else
      cIABMClientGrid_DeleteRow = True
  End Select
End Function

Public Function MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  
  MessageEx = True
  
  Select Case MessageID
    
    Case MSG_GRID_ROW_DELETED
      
      Select Case Info
        
        Case KW_PERCEPCIONES
          PercepcionShowTotales pGetPercepciones.Rows, pGetTotalPercepciones()
          m_ObjWizard.ShowValue pGetTotalPercepciones()
        
        Case KW_NEW_ITEMS
          pShowTotalNewItems
          
      End Select
    
    Case MSG_GRID_VIRTUAL_ROW

      Select Case Info.Key
      
        Case KW_NEW_ITEMS

          MessageEx = pProcessMultiRow(Info)
          
      End Select
    
  End Select

End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)
  
End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case KW_REMITOS
      cIABMClientGrid_ValidateRow = True
    Case KW_ITEMS
      cIABMClientGrid_ValidateRow = pValidateRowItems(Row, RowIndex)
    Case KW_NEW_ITEMS
      cIABMClientGrid_ValidateRow = pValidateRowNewItems(Row, RowIndex)
    Case KW_PERCEPCIONES
      cIABMClientGrid_ValidateRow = ValidateRowPercepciones(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pValidateRowNewItems(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                      ByVal RowIndex As Long) As Boolean
                                   
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
          MsgInfo LNGGetText(1365, vbNullString, strRow)
                  'Debe indicar una cantidad (1)
          Exit Function
        End If
      
      Case KI_PRECIO
        If ValEmpty(Cell.Value, csCurrency) Then
          
          If Not Ask(LNGGetText(2538, vbNullString, strRow), vbYes) Then
                     'Confirma el precio cero para el item (1)
            MsgInfo LNGGetText(1667, vbNullString, strRow)
                    'Debe indicar un precio (1)
            Exit Function
          End If
        End If
      
      Case KI_PR_ID
        If ValEmpty(Cell.id, csId) Then
          MsgInfo LNGGetText(1565, vbNullString, strRow)
                  'Debe indicar un producto de venta (1)
          Exit Function
        End If
      
      Case KI_NROSERIE
        bLlevaNroSerie = pCell(Row, KI_PR_LLEVANROSERIE).id
        If ValEmpty(Cell.Value, csText) _
           And bLlevaNroSerie _
           And m_bShowStockData Then
          MsgInfo LNGGetText(1630, vbNullString, strRow)
                  'Debe indicar un numero de serie (1)
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
             
            MsgInfo LNGGetText(1632, vbNullString, strRow)
                    'Debe indicar un lote (1)
            Exit Function
          End If
        End If
        
      ' TO
      Case KI_TO_ID
        If ValEmpty(Cell.id, csId) Then
          MsgInfo LNGGetText(1633, vbNullString, strRow)
                    'Debe indicar un Tipo de Operación (1)
          Exit Function
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
  
  pValidateRowNewItems = True
End Function

Private Function pValidateRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                   ByVal RowIndex As Long) As Boolean
                                   
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
  
    If pCell(Row, KII_SELECT).id Then
  
      Select Case Cell.Key
        Case KII_CANTIDAD
          If ValEmpty(Cell.Value, csCurrency) Then
            MsgInfo LNGGetText(1365, vbNullString, strRow)
                    'Debe indicar una cantidad (1)
            Exit Function
          End If
      End Select
    End If
  Next
  
  pValidateRowItems = True
End Function

Private Function pColBEditItems(ByRef IProperty As cIABMProperty, _
                                ByVal lRow As Long, _
                                ByVal lCol As Long, _
                                ByVal iKeyAscii As Integer) As Boolean
  Select Case pGetKeyFromCol(IProperty.Grid.Columns, lCol)
    Case KII_SELECT, KII_APLICAR, KII_PRECIO_SIN_IVA, KII_TO_ID ' TO
    Case Else
      Exit Function
  End Select

  pColBEditItems = True
End Function

Private Function pColBEditRemitos(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
  Select Case pGetKeyFromCol(IProperty.Grid.Columns, lCol)
    Case KI_SELECT
    Case Else
      Exit Function
  End Select
  
  pColBEditRemitos = True
End Function

Private Function pColAUpdateRemito(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long)
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KI_SELECT
        pShowTotalRemitos
    End Select
  End With
  
  pColAUpdateRemito = True
End Function


Private Function pColAUpdateNewItems(ByRef IProperty As cIABMProperty, _
                                     ByVal lRow As Long, _
                                     ByVal lCol As Long)

  With IProperty
    pShowImporteAndIva .Grid.Rows(lRow)
    pShowTotalNewItems
  End With
  
  pColAUpdateNewItems = True
End Function

Private Function pColAUpdateItems(ByRef IProperty As cIABMProperty, _
                                  ByVal lRow As Long, _
                                  ByVal lCol As Long)
  Dim Row      As cIABMGridRow
  Dim Value    As Double
  Dim MaxVal   As Double
  
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      
      Case KII_SELECT
        Set Row = .Rows(lRow)
        pSelectItem Row, .Columns
        pShowTotalItems
        SetTotal Row, KII_TOTAL, KII_APLICAR, KII_PRECIOIVA
      
      Case KII_APLICAR
        Set Row = .Rows(lRow)
        With pCell(Row, KII_APLICAR)
          MaxVal = Val(pCell(Row, KII_PENDIENTE).Value)
          If Val(.Value) > MaxVal Then
            .Value = MaxVal
          ElseIf Val(.Value) < 0 Then
            .Value = 0
          End If
        End With
        pShowTotalItems
        SetTotal Row, KII_TOTAL, KII_APLICAR, KII_PRECIOIVA
        
      Case KII_PRECIO_SIN_IVA
        Set Row = .Rows(lRow)
        
        ' Internos
        SetPrecioIvaEx Row, _
                       KII_PRECIO_SIN_IVA, _
                       KII_IVARIPercent, _
                       KII_IVARNIPercent, _
                       KII_INTERNOSPercent, _
                       KII_INTERNOSPorc, _
                       KII_PRECIOIVA, _
                       m_bIva, m_bIvaRni
        pShowTotalItems
        SetTotal Row, KII_TOTAL, KII_APLICAR, KII_PRECIOIVA
        
      Case Else
        pColAUpdateItems = True
        Exit Function
    End Select
  End With
  
  pColAUpdateItems = True
End Function

Private Sub pSelectAllRemitos(ByVal bSelect As Boolean)
  Dim Row As cIABMGridRow
  
  With pGetRemitos
    For Each Row In .Rows
      pCell(Row, KI_SELECT).id = CInt(bSelect)
    Next
  End With
  
  Dim ObjWiz As cWizardGeneric
  Set ObjWiz = m_ObjWizard
  
  ObjWiz.ShowValue pGetRemitosProperty, True
End Sub

Private Sub pSelectAllItems(ByVal bSelect As Boolean)
  Dim Row As cIABMGridRow
  
  With pGetItems
    For Each Row In .Rows
      pCell(Row, KII_SELECT).id = CInt(bSelect)
      pSelectItem Row, .Columns
      SetTotal Row, KII_TOTAL, KII_APLICAR, KII_PRECIOIVA
    Next
  End With
  
  Dim ObjWiz As cWizardGeneric
  Set ObjWiz = m_ObjWizard
  
  ObjWiz.ShowValue pGetItemsProperty, True
End Sub

Private Sub pSelectItem(ByRef Row As cIABMGridRow, ByRef Columns As cIABMGridColumns)
  With pCell(Row, KII_APLICAR)
    If pCell(Row, KII_SELECT).id Then
      If Val(.Value) = 0 Then
        .Value = pCell(Row, KII_PENDIENTE).Value
      End If
    Else
      .Value = 0
    End If
  End With
End Sub

Private Sub pShowTotalRemitos()
  Dim Row           As cIABMGridRow
  Dim Total         As Double
  
  For Each Row In pGetRemitos().Rows
    If pCell(Row, KI_SELECT).id Then
      Total = Total + Val(pCell(Row, KI_TOTAL).Value)
    End If
  Next
  
  pGetTotal().Value = Total
  
  m_ObjWizard.ShowValue pGetTotal
End Sub

Private Sub pShowTotalItems()
  Dim Row           As cIABMGridRow
  Dim Total         As Double
  
  For Each Row In pGetItems().Rows
    Total = Total + Val(pCell(Row, KII_APLICAR).Value) * Val(pCell(Row, KII_PRECIOIVA).Value)
  Next
  
  pGetTotalItems().Value = Total
  
  m_ObjWizard.ShowValue pGetTotalItems
End Sub

Private Sub pShowTotalNewItems()
  Dim Rows       As CSInterfacesABM.cIABMGridRows
  
  Dim Neto      As Double
  Dim IvaRi     As Double
  Dim IvaRni    As Double
  Dim Internos  As Double ' Internos
  Dim Row       As CSInterfacesABM.cIABMGridRow
  
  Set Rows = pGetNewItems().Rows

  For Each Row In Rows
    Neto = Neto + Val(pCell(Row, KI_NETO).Value)
    IvaRi = IvaRi + Val(pCell(Row, KI_IVARI).Value)
    IvaRni = IvaRni + Val(pCell(Row, KI_IVARNI).Value)
    
    ' Internos
    Internos = Internos + Val(pCell(Row, KI_INTERNOS).Value)
  Next
  
  pGetNetoNewItems().Value = Neto
  pGetIvaNewItems().Value = IvaRi
  
  ' Internos
  pGetInternosNewItems().Value = Internos
    
  pGetTotalNewItems().Value = Neto + IvaRni + IvaRi + Internos
  
  m_ObjWizard.ShowValue pGetNetoNewItems()
  m_ObjWizard.ShowValue pGetIvaNewItems()
  m_ObjWizard.ShowValue pGetInternosNewItems()
  m_ObjWizard.ShowValue pGetTotalNewItems()
End Sub

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
    
    Case c_StepSelectItems
      If GoingToNext Then
        Dim iProp As cIABMProperty
        Set iProp = pGetTodosItems
        iProp.name = c_selectall
        m_ObjWizard.ShowValue iProp
      End If
      
    Case c_StepNewItems
    
    Case c_StepPercepciones
    
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
      m_LastCli = csNO_ID
      pSetDatosCliente
      
      SetDocumentoForDoctId pGetDocProperty(), _
                            m_ObjWizard, _
                            csEDocumentoTipo.csEDT_FacturaVenta, _
                            csEDocumentoTipo.csEDT_RemitoVenta, _
                            m_RvIds, _
                            0
      cIWizardClient_PropertyChange KW_DOC_ID
    
    Case c_StepSelectCliente
    
      If pGetDoc() = csNO_ID Then
        MsgWarning LNGGetText(1562, vbNullString), LNGGetText(1607, vbNullString)
                   'Debe indicar un documento", "Facturas"
        nNextStep = c_StepSelectCliente
      ElseIf pGetCliente() = csNO_ID Then
        MsgWarning LNGGetText(1563, vbNullString), LNGGetText(1607, vbNullString)
                   'Debe indicar un cliente", "Facturas"
        nNextStep = c_StepSelectCliente
      ElseIf WizGetDeposito(m_ObjWizard, c_StepSelectCliente, c_Wiz_Key_Deposito) = csNO_ID _
                                                          And m_bShowStockData Then
        MsgWarning LNGGetText(1559, vbNullString), LNGGetText(1607, vbNullString)
                   'Debe indicar un deposito", "Facturas"
        nNextStep = c_StepSelectCliente
      ElseIf Not pLoadRemitosXCliente() Then
        MsgWarning LNGGetText(1679, vbNullString), LNGGetText(1607, vbNullString)
                   'No se pudieron cargar los Remitos para este Cliente", "Facturas"
        nNextStep = c_StepSelectCliente
      Else
        pGetTodos.name = c_selectall
        m_ObjWizard.ShowValue pGetTodos
        m_ObjWizard.cmdBack.Enabled = True
        nNextStep = c_StepSelectRemito
      End If
      
    Case c_StepSelectRemito
      If Not pChecRemitos() Then
        nNextStep = c_StepSelectRemito
      ElseIf Not pLoadItemsXRemitos() Then
        MsgWarning LNGGetText(1680, vbNullString), LNGGetText(1607, vbNullString)
                   'No se pudieron cargar los items de los Remitos para este Cliente", "Facturas"
        nNextStep = c_StepSelectRemito
      Else
        nNextStep = c_StepSelectItems
      End If
    
    Case c_StepSelectItems
      If Not pCheckItems() Then
        nNextStep = c_StepSelectItems
      Else
        nNextStep = c_StepNewItems
      End If
    
    Case c_StepNewItems
      If Not pCheckNewItems() Then
        nNextStep = c_StepNewItems
      Else
        pCalcularPercepciones
        PercepcionShowTotales pGetPercepciones.Rows, pGetTotalPercepciones
        m_ObjWizard.ShowValue pGetTotalPercepciones
        nNextStep = c_StepPercepciones
      End If
    
    Case c_StepPercepciones
      If Not pCheckPercepciones() Then
        nNextStep = c_StepPercepciones
      Else
        
        PercepcionShowTotales pGetPercepciones.Rows, pGetTotalPercepciones
        m_ObjWizard.ShowValue pGetTotalPercepciones
        
        m_ObjWizard.cmdNext.Caption = c_WizStr_Finish
        
        nNextStep = c_StepDatosGenerales
      End If
    
    Case c_StepDatosGenerales

      If pValidateDatosGenerales() Then

        m_FvTotal = 0

        If pSave() Then
        
          Dim WizObj As cWizardGeneric
          Set WizObj = m_ObjWizard
        
          If Not m_ModoVentaCtaCte Then
            
            If IsCobranzaPorCajero(m_Id) Then
          
              SaveFacturaVentaCajero m_Id, m_cj_id, False
            
            ElseIf IsCobranzaContado(m_Id) Then
              ShowCobranzaContado pGetCliente(), _
                                  m_Id, _
                                  pGetFecha().Value, _
                                  m_FvTotal, _
                                  pGetSucursal().HelpId, _
                                  pGetCentroCosto().HelpId, _
                                  pGetLegajo().HelpId, _
                                  m_cj_id, m_bAutoPago, m_cue_id_autoPago
            End If
          
          Else
          
            SaveFacturaVentaCajero m_Id, m_cj_id, True
            
          End If
          
          If m_UserCfg.PrintInNewFv Then
           
            WizAutoPrint = m_UserCfg.NoAskInPrint
      
            WizPrintDocEx m_Id, _
                    pGetDocIdFromDb(), _
                    GetEmailFromCliente(m_LastCli)
          
          End If
          
          If WizObj.CloseWizardAfterSave Or m_UserCfg.CloseWizard Then
        
            m_ObjWizard.CloseWizard
        
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
    
    Case c_StepSelectRemito
      m_ObjWizard.cmdBack.Enabled = False
      nNextStep = c_StepSelectCliente
    
    Case c_StepSelectItems
      nNextStep = c_StepSelectRemito
    
    Case c_StepNewItems
      nNextStep = c_StepSelectItems
    
    Case c_StepPercepciones
      nNextStep = c_StepNewItems
    
    Case c_StepDatosGenerales
      m_ObjWizard.cmdNext.Caption = c_WizStr_Next
      nNextStep = c_StepPercepciones

'    Case c_StepDatosGenerales
'      m_ObjWizard.cmdNext.Caption = c_WizStr_Next
'      nNextStep = c_StepSelectItems
  End Select

  cIWizardClient_PreviousStep = True
End Function

Private Function pGetDeplId() As Long
  pGetDeplId = WizGetDeposito(m_ObjWizard, c_StepSelectCliente, c_Wiz_Key_Deposito)
End Function

Private Function cIWizardClient_PropertyChange(ByVal Key As Integer) As Boolean
  Dim ObjWiz As cWizardGeneric
  Dim iProp  As cIABMProperty
  
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
                    pGetDocIdFromDb(), _
                    GetEmailFromCliente(m_LastCli)
    
    Case KW_NEW_DOC
      pNewEmptyProperties
      WizNewDoc m_ObjWizard, c_StepWelcome
    
    Case KW_TODOS
      If pGetTodos.name = c_selectall Then
        pSelectAllRemitos True
        pGetTodos.name = c_unselectall
      Else
        pSelectAllRemitos False
        pGetTodos.name = c_selectall
      End If
      m_ObjWizard.ShowValue pGetTodos
      pShowTotalRemitos
  
    Case KW_TODOS_ITEMS
      If pGetTodosItems.name = c_selectall Then
        pSelectAllItems True
        pGetTodosItems.name = c_unselectall
      Else
        pSelectAllItems False
        pGetTodosItems.name = c_selectall
      End If
      m_ObjWizard.ShowValue pGetTodosItems
      pShowTotalItems
  
    Case KW_DOC_ID
      m_LastDoc = pGetDoc() 'lp
      WizSetShowStockData m_ObjWizard, c_StepSelectCliente, m_bShowStockData
      Set iProp = WizGetDepositoProp(m_ObjWizard, _
                         c_StepSelectCliente, _
                         c_Wiz_Key_Deposito)
      iProp.Enabled = m_bShowStockData
      m_ObjWizard.ShowValue iProp
      pSetListaPrecio 'lp
  
      ' Si corresponde muestro la cotizacion de la moneda del documento
      '
      Set ObjWiz = m_ObjWizard
      ShowCotizacion csNO_ID, _
                     pGetDoc(), _
                     csNO_ID, _
                     m_lastmonid, _
                     ObjWiz.ObjAbm, _
                     c_Wiz_Key_Cotizacion, _
                     c_Wiz_Key_Fecha
  
      ' Obtengo si lleva percepciones
      '
      If Not gDB.GetData(csTDocumento, _
                         cscDocId, _
                         m_LastDoc, _
                         cscDocFvSinPercepcion, _
                         m_doc_sin_perc) Then
        Exit Function
      End If
  
    Case KW_CLI_ID
      pSetDatosCliente 'lp
      
    Case KW_LP_ID 'lp
      pSetLpId2 'lp
      
    Case KW_LPALL_ITEMS 'lp
      pSetPrecios True 'lp
      pShowTotalItems
    
    Case KW_LPZERO_ITEMS 'lp
      pSetPrecios False 'lp
      pShowTotalItems
  
    Case KW_FECHA
      
      ' Cotizacion
      Set ObjWiz = m_ObjWizard
      m_lastmonid = csNO_ID
      ShowCotizacion csNO_ID, _
                     pGetDoc(), _
                     csNO_ID, _
                     m_lastmonid, _
                     ObjWiz.ObjAbm, _
                     c_Wiz_Key_Cotizacion, _
                     c_Wiz_Key_Fecha
  End Select
End Function

'lp
Private Sub pSetPrecios(ByVal bAll As Boolean)
  Dim Row As cIABMGridRow
  
  For Each Row In pGetItems.Rows
    If Val(pCell(Row, KII_PRECIO_LP).Value) = 0 Or bAll Then
    
      SetPrecio Row, pCell(Row, KII_ARTICULO).id, pGetListaPrecio, _
                KII_PRECIO_LP, KII_PRECIO_USR
                
      pCell(Row, KII_PRECIO_SIN_IVA).Value = pCell(Row, KII_PRECIO_LP).Value
      
      SetPrecioIva Row, KII_PRECIO_SIN_IVA, KII_IVARIPercent, _
                   KII_IVARNIPercent, KII_PRECIOIVA, _
                   m_bIva, m_bIvaRni
      
      SetTotal Row, KII_TOTAL, KII_APLICAR, KII_PRECIOIVA
    End If
  Next
  
  Dim ObjWiz As cWizardGeneric
  Set ObjWiz = m_ObjWizard
  
  ObjWiz.ShowValue pGetItemsProperty, True
End Sub

'lp
Private Sub pSetLpId2()
  Dim lp_id  As Long
  Dim iProp1 As cIABMProperty
  Dim iProp2 As cIABMProperty
  
  Set iProp1 = pGetListaPrecio()
  Set iProp2 = pGetListaPrecio2()
  
  lp_id = iProp1.HelpId
  
  If lp_id <> csNO_ID Then
    iProp2.Value = iProp1.Value
    iProp2.HelpId = lp_id
  End If
  
  m_ObjWizard.ShowValue iProp2
End Sub

Private Function cIWizardClient_Terminate() As Boolean
  cIWizardClient_Terminate = True
  'Unload m_Resource
  'Set m_Resource = Nothing
  
  ' Puede fallar y no importa
  ' ya que no conozco si el
  ' objecto cliente soporta
  ' la interfaz
  On Error Resume Next
  
  ' Autorun
  If m_bAutoSelect Then
    m_ObjClient.TerminateWizard csNO_ID
  Else
    m_ObjClient.TerminateWizard m_Id
  End If
End Function

Private Property Get cIWizardClient_Title() As String
  cIWizardClient_Title = LNGGetText(2223, vbNullString) 'Asistente de Facturas de Venta
End Property

' funciones friend
' funciones privadas
Private Function LoadSteps() As Boolean
  Dim sh As Shape
  Set sh = m_ObjWizard.EditGeneric.ShapeMain

  'If m_Resource Is Nothing Then Set m_Resource = New fResource

  Dim Wizard As cWizardGeneric
  Dim AbmObj As cABMGeneric
  
  Set Wizard = m_ObjWizard
  Set AbmObj = Wizard.ObjAbm
  AbmObj.MinHeight = 7000
  
  sh.Move 0, 0, 9000, 7000
  sh.BorderStyle = 0
  sh.BackColor = vbWhite

  Dim Img As Image
  Set Img = m_ObjWizard.EditGeneric.PicMain

  Img.Visible = False

  m_LastDoc = m_doc_id
  m_LastCli = m_cli_id
  
  pLoadStepWelcome
  pLoadStepSelectCliente
  pLoadStepSelectRemito
  pLoadStepSelectItems
  pLoadStepNewItems
  pLoadStepPercepciones
  pLoadStepDatosGenerales
  WizVtaShowCotizacion m_ObjWizard, c_StepDatosGenerales, m_LastDoc, False
  
  ' Obtengo si lleva percepciones
  '
  If Not gDB.GetData(csTDocumento, _
                     cscDocId, _
                     m_LastDoc, _
                     cscDocFvSinPercepcion, _
                     m_doc_sin_perc) Then
    Exit Function
  End If
  
  LoadSteps = True
End Function

Private Sub pLoadStepWelcome()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepWelcome)).Properties
    With .Add(Nothing)
      '.Name = vbNullString
      .Top = 0
      .left = 0
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 1
      'Set .Picture = m_Resource.ImgWiz1.Picture
    End With

    With .Add(Nothing, c_Wiz_Key_Title)
      '.Name = vbNullString
      .Top = 100
      .left = 2700
      .TopNotChange = True
      .LeftNotChange = True
      .Height = 880
      .Width = 7000
      .PropertyType = cspTitle
      .Value = LNGGetText(1653, vbNullString) 'Bienvenido al Asistente de Facturas de Venta
    End With
    
    With .Add(Nothing, c_Wiz_Key_MainTitle)
      .Top = 1200
      .left = 3000
      '.Name = vbNullString
      .PropertyType = cspLabel
      .Width = 6000
      .Height = 880
      .FontBold = True
      .Value = LNGGetText(1681, vbNullString)
              'Con este asistente usted podrá generar las Facturas sobre Remitos.
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
      .left = 100
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 3
      'Set .Picture = m_Resource.ImgWiz3.Picture
    End With

    With .Add(Nothing)
      '.Name = vbNullString
      .Top = 400
      .left = 1500
      .TopNotChange = True
      .LeftNotChange = True
      .Height = 880
      .Width = 8000
      .PropertyType = cspLabel
      .FontBold = True
      .Value = LNGGetText(1655, vbNullString)
                'Indique el documento a utilizar y el cliente al que se le emitirá la factura
    End With
    
    With .Add(Nothing, c_Wiz_Key_Doc)
      .Top = 1500
      .left = 3700
      .name = LNGGetText(1567, vbNullString)  'Documento
      .PropertyType = cspHelp
      .HelpFilter = "'doct_id = " & csEDT_FacturaVenta & " and " & cscDocTipoFactura & " = " & csETFacRemito & "'"
      .Table = CSDocumento2.CSDocumento
      .Width = 4000
      .Value = m_Documento
      .HelpId = m_doc_id
      .Key = KW_DOC_ID
    End With
  
    With .Add(Nothing, c_Wiz_Key_Cliente)
      .Top = 2000
      .left = 3700
      .name = LNGGetText(1150, vbNullString)  'Cliente
      .PropertyType = cspHelp
      .Table = csCliente
      .Width = 4000
      .Value = m_cliente
      .HelpId = m_cli_id
      .Key = KW_CLI_ID
    End With
  
    'lp
    With .Add(Nothing, c_Wiz_Key_ListaPrecio)
      .PropertyType = cspHelp
      .Table = csListaPrecio
      .Width = 4000
      .name = LNGGetText(1397, vbNullString)  'Lista de precios
      .Key = KW_LP_ID
      .HelpFilter = GetListaPrecioGetXCliente(m_doc_id, m_cli_id)
    End With
    
    'nrs
    WizSetShowStockData m_ObjWizard, c_StepSelectCliente, m_bShowStockData
    
    With .Add(Nothing, c_Wiz_Key_Deposito)
      .left = 3700
      .name = LNGGetText(1574, vbNullString) 'Deposito
      .PropertyType = cspHelp
      .Table = csDepositoLogico
      .Width = 4000
      .HelpId = m_UserCfg.DeplId
      .Value = m_UserCfg.DeplNombre
      .Enabled = m_bShowStockData
      
      ' Lote
      '
      .Key = KW_DEPL_ID
    End With
    
    pSetStock
    
    ' Edit From ListDoc
    '
    With .Add(Nothing, c_Wiz_Key_OnlySelected)
      .PropertyType = cspCheck
      .name = LNGGetText(1682, vbNullString)  'Cargar solo Remitos seleccionados
      
      If m_UserCfg.ShowAllInWizard Then
        .Value = 0
      Else
        .Value = UBound(m_RvIds)
      End If
      .left = 5310
      .LeftLabel = -2800
    End With
  End With

  WizSetShowStockData m_ObjWizard, c_StepSelectCliente, m_bShowStockData

End Sub

Private Sub pLoadStepSelectRemito()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepSelectRemito)).Properties
    With .Add(Nothing)
      '.Name = vbNullString
      .Top = 100
      .left = 100
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 3
      'Set .Picture = m_Resource.ImgWiz3.Picture
    End With

    With .Add(Nothing)
      '.Name = vbNullString
      .Top = 400
      .left = 1500
      .TopNotChange = True
      .LeftNotChange = True
      .Height = 880
      .Width = 8000
      .PropertyType = cspLabel
      .FontBold = True
      .Value = LNGGetText(1683, vbNullString)  'Seleccione los Remitos
    End With
    
    With .Add(Nothing, c_Wiz_Key_Remitos)
      .Top = 1100
      .left = 150
      '.Name = vbNullString
      .PropertyType = cspGrid
      .LeftLabel = -1
      pLoadRemitos .Grid
      .Width = 11500
      .Height = 4400
      .Key = KW_REMITOS
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
    End With
  
    With .Add(Nothing, c_Wiz_Key_Todos)
      .name = c_selectall
      .Top = 5550
      .left = 200
      .LeftLabel = -1
      .Width = 2200
      .PropertyType = cspButton
      .Key = KW_TODOS
    End With
  
    With .Add(Nothing, c_Wiz_Key_Total)
      .name = LNGGetText(1584, vbNullString)  'Total
      .Top = 5550
      .left = 9820
      .LeftLabel = -600
      .Width = 1800
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Format = m_GeneralConfig.FormatDecImporte
    End With
  End With
End Sub

Private Sub pLoadRemitos(ByRef Grid As cIABMGrid)
  Dim Signo As String
  
  With Grid.Columns
  
    ' La primera simpre esta invisible
    .Add(Nothing).Visible = False
    
    With .Add(Nothing)
      '.Name = vbNullString
      .PropertyType = cspCheck
      .Width = 320
      .Key = KI_SELECT
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(1223, vbNullString)  'Tipo
      .PropertyType = cspText
      .Width = 3000
      .Key = KI_DOC
    End With
  
    With .Add(Nothing)
      .name = LNGGetText(1567, vbNullString)  'Documento
      .PropertyType = cspText
      .Width = 1800
      .Key = KI_NRODOC
    End With
  
    With .Add(Nothing)
      .name = LNGGetText(1065, vbNullString)  'Número
      .PropertyType = cspNumeric
      .Width = 800
      .Key = KI_RV_ID
    End With
  
    With .Add(Nothing)
      .name = LNGGetText(1569, vbNullString)  'Fecha
      .PropertyType = cspDate
      .Width = 1040
      .Format = "dd/mm/yy"
      .Key = KI_FECHA
    End With
  
    With .Add(Nothing)
      .name = LNGGetText(1584, vbNullString)  'Total
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 920
      .Key = KI_TOTAL
      .Format = m_GeneralConfig.FormatDecImporte
    End With
  
    With .Add(Nothing)
      .name = C_strDescrip
      .PropertyType = cspText
      .Width = 3000
      .Key = KI_DESCRIP
    End With
  End With
End Sub

Private Sub pLoadStepSelectItems()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepSelectItems)).Properties
    With .Add(Nothing)
      '.Name = vbNullString
      .Top = 100
      .left = 100
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 3
      'Set .Picture = m_Resource.ImgWiz3.Picture
    End With

    With .Add(Nothing)
      '.Name = vbNullString
      .Top = 400
      .left = 1500
      .TopNotChange = True
      .LeftNotChange = True
      .Height = 880
      .Width = 8000
      .PropertyType = cspLabel
      .FontBold = True
      .Value = LNGGetText(1676, vbNullString)
            'Seleccione los items he indique las cantidades que facturará de cada una de ellos
    End With
    
    With .Add(Nothing, c_Wiz_Key_Items)
      .Top = 1100
      .left = 150
      '.Name = vbNullString
      .PropertyType = cspGrid
      .LeftLabel = -1
      pLoadItems .Grid
      .Width = 11500
      .Height = 4400
      .Key = KW_ITEMS
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
    End With
  
    With .Add(Nothing, c_Wiz_Key_TodosItems)
      .name = c_selectall
      .Top = 5550
      .left = 200
      .LeftLabel = -1
      .Width = 2200
      .PropertyType = cspButton
      .Key = KW_TODOS_ITEMS
    End With
      
    'lp
    With .Add(Nothing, c_Wiz_Key_LPAplyAll)
      .name = c_aplicarprecio
      .Top = 5550
      .LeftFromProperty = c_Wiz_Key_TodosItems
      .LeftToPrevious = 2400
      .LeftLabel = -1
      .Width = 2200
      .PropertyType = cspButton
      .Key = KW_LPALL_ITEMS
    End With
    
    'lp
    With .Add(Nothing, c_Wiz_Key_LPAplyZero)
      .name = c_aplicarpreciocero
      .Top = 5550
      .LeftFromProperty = c_Wiz_Key_TodosItems
      .LeftToPrevious = 4700
      .LeftLabel = -1
      .Width = 2200
      .PropertyType = cspButton
      .Key = KW_LPZERO_ITEMS
    End With
    
    With .Add(Nothing, c_Wiz_Key_TotalItems)
      .name = LNGGetText(1584, vbNullString)  'Total
      .Top = 5550
      .left = 9820
      .LeftLabel = -600
      .Width = 1800
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Format = m_GeneralConfig.FormatDecImporte
    End With
  End With
End Sub

Private Sub pLoadItems(ByRef Grid As cIABMGrid)
  With Grid.Columns

    ' La primera simpre esta invisible
    With .Add(Nothing)
      .Visible = False
      .Key = KII_RVI_ID
    End With
    
    With .Add(Nothing)
      '.Name = vbNullString
      .PropertyType = cspCheck
      .Width = 320
      .Key = KII_SELECT
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(1567, vbNullString)  'Documento
      .PropertyType = cspText
      .Width = 1600
      .Key = KI_NRODOC
    End With
  
    With .Add(Nothing)
      .name = LNGGetText(1065, vbNullString)  'Número
      .PropertyType = cspNumeric
      .Width = 800
      .Key = KI_RV_ID
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(1367, vbNullString)  'Articulo
      .PropertyType = cspText
      .Width = 3000
      .Key = KII_ARTICULO
    End With
  
    With .Add(Nothing)
      .name = LNGGetText(1586, vbNullString)  'Precio
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 920
      .Key = KII_PRECIO_SIN_IVA
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = SecurityCanAccessSilent(csPreVtaEditPriceFac)
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(1374, vbNullString)  'Cantidad
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 920
      .Key = KII_CANTIDAD
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
    
    With .Add(Nothing, c_Wiz_Key_Pendiente)
      .name = LNGGetText(1609, vbNullString)  'Pendiente
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 920
      .Key = KII_PENDIENTE
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
  
    With .Add(Nothing)
      .name = LNGGetText(1662, vbNullString)  'Aplicar
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 920
      .Key = KII_APLICAR
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
    
    With .Add(Nothing, c_Wiz_Key_TotalItems)
      .name = LNGGetText(1584, vbNullString)  'Total
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 920
      .Key = KII_TOTAL
      .Format = m_GeneralConfig.FormatDecImporte
    End With
    
    ' TO
    With .Add(Nothing)
      .name = LNGGetText(1661, vbNullString)  'Tipo Operación
      .PropertyType = cspHelp
      .Table = csTipoOperacion
      .Width = 1800
      .Key = KII_TO_ID
    End With
    
    With .Add(Nothing)
      .name = C_strDescrip
      .PropertyType = cspText
      .Width = 3000
      .Key = KII_DESCRIP
    End With
    
    With .Add(Nothing)
      .Visible = False
      .Key = KII_PRECIOIVA
    End With
  
    With .Add(Nothing)
      .Visible = False
      .Key = KII_PRECIO_LP
    End With
  
    With .Add(Nothing)
      .Visible = False
      .Key = KII_PRECIO_USR
    End With
    
    With .Add(Nothing)
      .Visible = False
      .Key = KII_IVARIPercent
    End With
    
    With .Add(Nothing)
      .Visible = False
      .Key = KII_IVARNIPercent
    End With
  
    ' Internos
    With .Add(Nothing)
      .Visible = False
      .Key = KII_INTERNOSPercent
    End With
    
    ' Internos
    With .Add(Nothing)
      .Visible = False
      .Key = KII_INTERNOSPorc
    End With
    
    With .Add(Nothing)
      .Visible = False
      .Key = KII_DESCUENTO
    End With
  
    With .Add(Nothing)
      .Visible = False
      .Key = KII_CCOS_ID
    End With
  End With
End Sub

Private Sub pLoadStepNewItems()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepNewItems)).Properties
    With .Add(Nothing)
      '.Name = vbNullString
      .Top = 100
      .left = 100
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 3
      'Set .Picture = m_Resource.ImgWiz3.Picture
    End With

    With .Add(Nothing)
      '.Name = vbNullString
      .Top = 400
      .left = 1500
      .TopNotChange = True
      .LeftNotChange = True
      .Height = 880
      .Width = 8000
      .PropertyType = cspLabel
      .FontBold = True
      .Value = LNGGetText(3650, vbNullString)  'Agregue mas items si corresponde
    End With
    
    With .Add(Nothing, c_Wiz_Key_NewItems)
      .Top = 1100
      .left = 150
      '.Name = vbNullString
      .PropertyType = cspGrid
      .LeftLabel = -1
      pLoadNewItems .Grid
      .Width = 11500
      .Height = 4300
      .Key = KW_NEW_ITEMS
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
  
    With .Add(Nothing, c_Wiz_Key_NetoNewItems)
      .name = LNGGetText(1581, vbNullString)  'Neto
      .Top = 5600
      .left = 1820
      .LeftLabel = -600
      .Width = 1800
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Format = m_GeneralConfig.FormatDecImporte
    End With
    
    With .Add(Nothing, c_Wiz_Key_IvaNewItems)
      .name = LNGGetText(1582, vbNullString)  'Iva
      .Top = 5600
      .left = 4520
      .LeftLabel = -600
      .Width = 1800
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Format = m_GeneralConfig.FormatDecImporte
    End With
    
    With .Add(Nothing, c_Wiz_Key_InternosNewItems)
      .name = LNGGetText(4914, vbNullString)  'Internos
      .Top = 5600
      .left = 7320
      .LeftLabel = -600
      .Width = 1800
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Format = m_GeneralConfig.FormatDecImporte
    End With
    
    With .Add(Nothing, c_Wiz_Key_TotalNewItems)
      .name = LNGGetText(1584, vbNullString)  'Total
      .Top = 5600
      .left = 9820
      .LeftLabel = -600
      .Width = 1800
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Format = m_GeneralConfig.FormatDecImporte
    End With
  End With
End Sub

Private Sub pLoadStepPercepciones()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepPercepciones)).Properties
    With .Add(Nothing)
      '.Name = vbNullString
      .Top = 100
      .left = 100
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 3
      'Set .Picture = m_Resource.ImgWiz3.Picture
    End With

    With .Add(Nothing)
      '.Name = vbNullString
      .Top = 400
      .left = 1500
      .TopNotChange = True
      .LeftNotChange = True
      .Height = 880
      .Width = 8000
      .PropertyType = cspLabel
      .FontBold = True
      .Value = LNGGetText(1915, vbNullString)  'Indique las percepciones si corresponde
    End With
    
    With .Add(Nothing, c_Wiz_Key_percepciones)
      .Top = 1100
      .left = 150
      '.Name = vbNullString
      .PropertyType = cspGrid
      .LeftLabel = -1
      pLoadPercepciones .Grid
      .Width = 11500
      .Height = 4500
      .Key = KW_PERCEPCIONES
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
  
    With .Add(Nothing, c_Wiz_Key_TotalPercepciones)
      .name = LNGGetText(1584, vbNullString)  'Total
      .Top = 5660
      .left = 9820
      .LeftLabel = -600
      .Width = 1800
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Format = m_GeneralConfig.FormatDecImporte
    End With
  End With
End Sub

Private Sub pLoadPercepciones(ByRef Grid As cIABMGrid)
  LoadPercepciones Grid, m_GeneralConfig
End Sub

Private Sub pLoadStepDatosGenerales()
  Dim Filter As String
  
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepDatosGenerales)).Properties
  
    With .Add(Nothing)
      '.Name = vbNullString
      .Top = 100
      .left = 100
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 3
      'Set .Picture = m_Resource.ImgWiz3.Picture
    End With

    With .Add(Nothing)
      '.Name = vbNullString
      .Top = 400
      .left = 1500
      .TopNotChange = True
      .LeftNotChange = True
      .Height = 880
      .Width = 8000
      .PropertyType = cspLabel
      .FontBold = True
      .Value = LNGGetText(1663, vbNullString)  'Complete los siguientes datos de la factura
    End With
  
    With .Add(Nothing, c_Wiz_Key_Fecha)
      .PropertyType = cspDate
      .left = 2800
      .name = LNGGetText(1569, vbNullString) 'Fecha
      .Key = KW_FECHA
      .Value = Date
    End With
    
    With .Add(Nothing, c_Wiz_Key_FechaIva)
      .PropertyType = cspDate
      .name = LNGGetText(1638, vbNullString)  'Fecha IVA
      .Key = KW_FECHAIVA
      .Value = Date
    End With
    
    With .Add(Nothing, c_Wiz_Key_Cliente2)
      .PropertyType = cspHelp
      .Table = csCliente
      .Enabled = False
      .name = LNGGetText(1150, vbNullString) 'Cliente
      .Key = KW_CLIENTE2
    End With
  
    With .Add(Nothing, c_Wiz_Key_CondicionPago)
      .PropertyType = cspHelp
      .Table = csCondicionPago
      .name = LNGGetText(1395, vbNullString) 'Condición de Pago
      .Key = KW_CONDICION_PAGO
    End With
    
    With .Add(Nothing, c_Wiz_Key_Sucursal)
      .PropertyType = cspHelp
      .Table = csSucursal
      .name = LNGGetText(1281, vbNullString) 'Sucursal
      .Value = User.Sucursal
      .HelpId = User.suc_id
      .Key = KW_SUCURSAL
    End With
  
    With .Add(Nothing, c_Wiz_Key_Cotizacion)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .name = LNGGetText(1635, vbNullString) 'Cotización
      .Key = KW_COTIZACION
    End With
    
    'lp
    With .Add(Nothing, c_Wiz_Key_ListaPrecio2)
      .PropertyType = cspHelp
      .Table = csListaPrecio
      .name = LNGGetText(1397, vbNullString) 'Lista de Precios
      .Enabled = False
      .Key = KW_LP_ID2
      .HelpFilter = GetListaPrecioGetXCliente(m_doc_id, m_cli_id)
    End With
  
    With .Add(Nothing, c_Wiz_Key_ListaDescuento)
      .PropertyType = cspHelp
      .Table = csListaDescuento
      .name = LNGGetText(1398, vbNullString) 'Lista de Descuentos
      .Key = KW_LD_ID
      .HelpFilter = GetListaDescGetXCliente(m_doc_id, m_cli_id)
    End With
    
    With .Add(Nothing, c_Wiz_Key_OrdenCompra)
      .PropertyType = cspText
      .name = LNGGetText(1924, vbNullString) 'Orden de Compra
      .Key = KW_ORDENCOMPRA
    End With
    
    With .Add(Nothing, c_Wiz_Key_Desc1)
      .TopFromProperty = c_Wiz_Key_Fecha
      .PropertyType = cspNumeric
      .left = 5500
      .LeftLabel = -1000
      .SubType = cspPercent
      .Width = 1000
      .name = LNGGetText(1664, vbNullString) 'Descuento 1
      .Key = KW_DESCUENTO1
    End With
    
    With .Add(Nothing, c_Wiz_Key_Desc2)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .LeftLabel = -200
      .Width = 1000
      .name = "2"
      .Key = KW_DESCUENTO2
    End With
    
    With .Add(Nothing, c_Wiz_Key_Comprobante)
      .PropertyType = cspText
      .left = 7800
      .TopFromProperty = c_Wiz_Key_Fecha
      .name = LNGGetText(1610, vbNullString) 'Comprobante
      .Key = KW_COMPROBANTE
    End With
  
    With .Add(Nothing, c_Wiz_Key_SucCliente)
      .PropertyType = cspHelp
      .Table = csSucursalCliente
      .name = LNGGetText(1576, vbNullString) 'Sucursal del Cliente
      .HelpFilter = GetHelpFilterCliSuc(m_cli_id)
      .Key = KW_CLIS_ID
    End With
    
    With .Add(Nothing, c_Wiz_Key_Transporte)
      .PropertyType = cspHelp
      .Table = csTransporte
      .name = LNGGetText(1050, vbNullString) 'Transporte
      .Key = KW_TRANS_ID
    End With
    
    With .Add(Nothing, c_Wiz_Key_Origen)
      .PropertyType = cspHelp
      .Table = csProvincia
      .name = LNGGetText(1901, vbNullString) 'Origen
      .Key = KW_PRO_ID_ORIGEN
    End With
    
    With .Add(Nothing, c_Wiz_Key_Destino)
      .PropertyType = cspHelp
      .Table = csProvincia
      .name = LNGGetText(1902, vbNullString) 'Destino
      .Key = KW_PRO_ID_DESTINO
    End With
    
    With .Add(Nothing, c_Wiz_Key_Legajo)
      .PropertyType = cspHelp
      .Table = csLegajo
      .name = LNGGetText(1575, vbNullString) 'Legajo
      .Key = KW_LEGAJO
    End With
    
    With .Add(Nothing, c_Wiz_Key_Vendedor)
      .PropertyType = cspHelp
      .Table = csVendedores
      .name = LNGGetText(1510, vbNullString) 'Vendedor
      .Key = KW_VEN_ID
    End With
    
    With .Add(Nothing, c_Wiz_Key_CentroCosto)
      .PropertyType = cspHelp
      .Table = csCentroCosto
      .name = LNGGetText(1057, vbNullString) 'Centro de Costo
      .Key = KW_CENTROCOSTO
    End With
    
    With .Add(Nothing, c_Wiz_Key_Observaciones)
      .PropertyType = cspText
      .left = 2800
      .Height = 880
      .Width = 7250
      .TopFromProperty = c_Wiz_Key_CentroCosto
      .TopNotChange = True
      .TopToPrevious = 880
      .name = LNGGetText(1861, vbNullString) 'Observaciones
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

Private Function pGetDocProperty() As cIABMProperty
  Set pGetDocProperty = GetWizProperty(m_ObjWizard, _
                                       c_StepSelectCliente, _
                                       c_Wiz_Key_Doc)
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

Private Function pGetTodos() As cIABMProperty
  Set pGetTodos = GetWizProperty(m_ObjWizard, _
                                c_StepSelectRemito, _
                                c_Wiz_Key_Todos)
End Function

Private Function pGetTodosItems() As cIABMProperty
  Set pGetTodosItems = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectItems, _
                                      c_Wiz_Key_TodosItems)
End Function

Private Function pGetTotalPercepciones() As cIABMProperty
  Set pGetTotalPercepciones = GetWizProperty(m_ObjWizard, _
                                             c_StepPercepciones, _
                                             c_Wiz_Key_TotalPercepciones)
End Function

Private Function pGetTotal() As cIABMProperty
  Set pGetTotal = GetWizProperty(m_ObjWizard, _
                                c_StepSelectRemito, _
                                c_Wiz_Key_Total)
End Function

Private Function pGetTotalItems() As cIABMProperty
  Set pGetTotalItems = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectItems, _
                                      c_Wiz_Key_TotalItems)
End Function

Private Function pGetTotalNewItems() As cIABMProperty
  Set pGetTotalNewItems = GetWizProperty(m_ObjWizard, _
                                      c_StepNewItems, _
                                      c_Wiz_Key_TotalNewItems)
End Function

Private Function pGetInternosNewItems() As cIABMProperty
  Set pGetInternosNewItems = GetWizProperty(m_ObjWizard, _
                                      c_StepNewItems, _
                                      c_Wiz_Key_InternosNewItems)
End Function

Private Function pGetNetoNewItems() As cIABMProperty
  Set pGetNetoNewItems = GetWizProperty(m_ObjWizard, _
                                      c_StepNewItems, _
                                      c_Wiz_Key_NetoNewItems)
End Function

Private Function pGetIvaNewItems() As cIABMProperty
  Set pGetIvaNewItems = GetWizProperty(m_ObjWizard, _
                                      c_StepNewItems, _
                                      c_Wiz_Key_IvaNewItems)
End Function

Private Function pGetCliente2() As cIABMProperty
  Set pGetCliente2 = GetWizProperty(m_ObjWizard, _
                                    c_StepDatosGenerales, _
                                    c_Wiz_Key_Cliente2)
End Function

Private Function pGetClienteProp() As cIABMProperty
  Set pGetClienteProp = GetWizProperty(m_ObjWizard, _
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

Private Function pGetNewItems() As cIABMGrid
  Set pGetNewItems = GetWizProperty(m_ObjWizard, _
                                c_StepNewItems, _
                                c_Wiz_Key_NewItems).Grid
End Function

Private Function pGetItems() As cIABMGrid
  Set pGetItems = GetWizProperty(m_ObjWizard, _
                                c_StepSelectItems, _
                                c_Wiz_Key_Items).Grid
End Function

Private Function pGetPercepciones() As cIABMGrid
  Set pGetPercepciones = GetWizProperty(m_ObjWizard, _
                                      c_StepPercepciones, _
                                      c_Wiz_Key_percepciones).Grid
End Function

Private Function pGetNewItemsProperty() As cIABMProperty
  Set pGetNewItemsProperty = GetWizProperty(m_ObjWizard, _
                                      c_StepNewItems, _
                                      c_Wiz_Key_NewItems)
End Function

Private Function pGetItemsProperty() As cIABMProperty
  Set pGetItemsProperty = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectItems, _
                                      c_Wiz_Key_Items)
End Function

Private Function pGetPercepcionesProperty() As cIABMProperty
  Set pGetPercepcionesProperty = GetWizProperty(m_ObjWizard, _
                                                c_StepPercepciones, _
                                                c_Wiz_Key_percepciones)
End Function

Private Function pGetRemitos() As cIABMGrid
  Set pGetRemitos = GetWizProperty(m_ObjWizard, _
                                   c_StepSelectRemito, _
                                   c_Wiz_Key_Remitos).Grid
End Function

Private Function pGetRemitosProperty() As cIABMProperty
  Set pGetRemitosProperty = GetWizProperty(m_ObjWizard, _
                                   c_StepSelectRemito, _
                                   c_Wiz_Key_Remitos)
End Function

Private Sub pRefreshRemitos()
  Dim ObjWiz As cWizardGeneric
  Set ObjWiz = m_ObjWizard
  
  ObjWiz.ShowValue GetWizProperty(m_ObjWizard, _
                                   c_StepSelectRemito, _
                                   c_Wiz_Key_Remitos), True
End Sub

Private Sub pRefreshItems()
  Dim ObjWiz As cWizardGeneric
  Set ObjWiz = m_ObjWizard
  
  ObjWiz.ShowValue GetWizProperty(m_ObjWizard, _
                                  c_StepSelectItems, _
                                  c_Wiz_Key_Items), True
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

'lp
Private Function pGetCotizacion() As cIABMProperty
  Set pGetCotizacion = GetWizProperty(m_ObjWizard, _
                                   c_StepDatosGenerales, _
                                   c_Wiz_Key_Cotizacion)
End Function
'lp
Private Function pGetVendedor() As cIABMProperty
  Set pGetVendedor = GetWizProperty(m_ObjWizard, _
                                   c_StepDatosGenerales, _
                                   c_Wiz_Key_Vendedor)
End Function

Private Function pGetSucCliente() As cIABMProperty
  Set pGetSucCliente = GetWizProperty(m_ObjWizard, _
                                   c_StepDatosGenerales, _
                                   c_Wiz_Key_SucCliente)
End Function

Private Function pGetTransporte() As cIABMProperty
  Set pGetTransporte = GetWizProperty(m_ObjWizard, _
                                   c_StepDatosGenerales, _
                                   c_Wiz_Key_Transporte)
End Function
'lp
Private Function pGetProOrigen() As cIABMProperty
  Set pGetProOrigen = GetWizProperty(m_ObjWizard, _
                                   c_StepDatosGenerales, _
                                   c_Wiz_Key_Origen)
End Function
'lp
Private Function pGetProDestino() As cIABMProperty
  Set pGetProDestino = GetWizProperty(m_ObjWizard, _
                                   c_StepDatosGenerales, _
                                   c_Wiz_Key_Destino)
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

Private Function pGetOrdenCompra() As cIABMProperty
  Set pGetOrdenCompra = GetWizProperty(m_ObjWizard, _
                                c_StepDatosGenerales, _
                                c_Wiz_Key_OrdenCompra)
End Function

Private Function pGetCondicionPago() As cIABMProperty
  Set pGetCondicionPago = GetWizProperty(m_ObjWizard, _
                                   c_StepDatosGenerales, _
                                   c_Wiz_Key_CondicionPago)
End Function

'lp
Private Function pGetListaPrecio2() As cIABMProperty
  Set pGetListaPrecio2 = GetWizProperty(m_ObjWizard, _
                                   c_StepDatosGenerales, _
                                   c_Wiz_Key_ListaPrecio2)
End Function

Private Function pGetListaPrecio() As cIABMProperty
  Set pGetListaPrecio = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectCliente, _
                                      c_Wiz_Key_ListaPrecio)
End Function

Private Function pGetListaDescuento() As cIABMProperty
  Set pGetListaDescuento = GetWizProperty(m_ObjWizard, _
                                   c_StepDatosGenerales, _
                                   c_Wiz_Key_ListaDescuento)
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

Private Function pGetFechaIva() As cIABMProperty
  Set pGetFechaIva = GetWizProperty(m_ObjWizard, _
                                c_StepDatosGenerales, _
                                c_Wiz_Key_FechaIva)
End Function

Private Function pChecRemitos() As Boolean
  Dim Row As cIABMGridRow
  For Each Row In pGetRemitos().Rows
    If pCell(Row, KI_SELECT).id Then
      pChecRemitos = True
      Exit Function
    End If
  Next
  
  MsgWarning LNGGetText(1677, vbNullString)   'Debe indicar uno o más remitos.
End Function

Private Function pCheckPercepciones() As Boolean
  pCheckPercepciones = True
End Function

Private Function pCheckItems() As Boolean
  Dim Row                 As cIABMGridRow
  Dim bExistsSelected     As Boolean
  Dim i                   As Long
  
  For Each Row In pGetItems().Rows
    i = i + 1
    If Val(pCell(Row, KII_APLICAR).Value) > 0 Then
      If Not pValidateRowItems(Row, i) Then Exit Function
      bExistsSelected = True
      
      If Val(pCell(Row, KII_PRECIO_SIN_IVA).Value) = 0 Then
        
        If Not Ask(LNGGetText(2538, vbNullString, i), vbYes) Then
                   'Confirma el precio cero para el item (1)
          MsgInfo LNGGetText(1667, vbNullString, i)
                  'Debe indicar un precio (1)
          Exit Function
        End If
      End If
    End If
  Next

  If Not bExistsSelected Then
    MsgWarning LNGGetText(1678, vbNullString)
              'Debe indicar uno o más items.
    Exit Function
  End If
  
  If Not Val(pGetTotalItems.Value) > 0 Then
    MsgWarning LNGGetText(1678, vbNullString)
              'Debe indicar uno o más items.
    Exit Function
  End If
  
  pCheckItems = True
End Function

Private Function pGetRemitosIds() As String
  Dim Row         As cIABMGridRow
  Dim Ids         As String
  
  For Each Row In pGetRemitos().Rows
    If pCell(Row, KI_SELECT).id Then
      Ids = Ids & pCell(Row, KI_RV_ID).id & ","
    End If
  Next
  
  pGetRemitosIds = RemoveLastColon(Ids)
End Function

Private Function pLoadItemsXRemitos() As Boolean
  Dim sqlstmt           As String
  Dim rs                As Recordset
  Dim i                 As Long
  
  sqlstmt = "sp_DocFacturaVentaGetRemitoItems '" & pGetRemitosIds & "'"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  With pGetItems().Rows
    
    .Clear
  
    While Not rs.EOF
    
      With .Add(Nothing)
      
        ' La primera no se usa
        With .Add(Nothing)
          .id = gDB.ValField(rs.fields, cscRviId)
          .Key = KII_RVI_ID
        End With
        
        With .Add(Nothing)
          ' Autorun
          If m_bAutoSelect Then
            .id = -1
          Else
            .id = 0
          End If
          .Key = KII_SELECT
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscRvNrodoc)
          .Key = KI_NRODOC
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscRvNumero)
          .id = gDB.ValField(rs.fields, cscRvId)
          .Key = KI_RV_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPrNombreVenta)
          .id = gDB.ValField(rs.fields, cscPrId)
          .Key = KII_ARTICULO
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscRviPrecio & "2")
          .Key = KII_PRECIO_SIN_IVA
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscRviCantidadaremitir)
          .Key = KII_CANTIDAD
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscRviPendientefac)
          .Key = KII_PENDIENTE
        End With
        
        With .Add(Nothing)
          ' Autorun
          If m_bAutoSelect Then
            .Value = gDB.ValField(rs.fields, cscRviPendientefac)
          Else
            .Value = 0
          End If
          .Key = KII_APLICAR
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscRviImporte)
          .Key = KII_TOTAL
        End With
        
        With .Add(Nothing)
          .id = C_TO_ComercialId
          .Value = C_TO_Comercial
          .Key = KII_TO_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscRviDescrip)
          .Key = KII_DESCRIP
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscRviPrecio)
          .Key = KII_PRECIOIVA
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscRviPrecioLista)
          .Key = KII_PRECIO_LP
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscRviPrecioUsr)
          .Key = KII_PRECIO_USR
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscRviIvariporc)
          .Key = KII_IVARIPercent
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscRviIvarniporc)
          .Key = KII_IVARNIPercent
        End With
        
        ' Internos
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscFviInternosPorc)
          .Key = KII_INTERNOSPercent
        End With
        
        ' Internos
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPrPorcInternoV)
          .Key = KII_INTERNOSPorc
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscRviDescuento)
          .Key = KII_DESCUENTO
        End With
        
        With .Add(Nothing)
          .id = gDB.ValField(rs.fields, cscCcosId)
          .Key = KII_CCOS_ID
        End With
      End With
      
      rs.MoveNext
    Wend
  End With
  
  pRefreshItems
  pShowTotalItems

  pLoadItemsXRemitos = True
End Function

Private Function pLoadRemitosXCliente() As Boolean
  Dim sqlstmt           As String
  Dim rs                As Recordset
  Dim rv_id             As Long
  
  ' Edit From ListDoc
  '
  Dim bSelected         As Boolean
  Dim bOnlySelected     As Boolean
  
  sqlstmt = "sp_DocFacturaVentaGetRemitos " & EmpId & "," & pGetCliente & ", " & GetMonIdFromDoc(pGetDoc)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  ' Edit From ListDoc
  '
  bOnlySelected = pGetOnlySelected().Value
  
  With pGetRemitos().Rows
  
    .Clear
    
    While Not rs.EOF
    
      ' Edit From ListDoc
      '
      rv_id = gDB.ValField(rs.fields, cscRvId)
      
      bSelected = pGetApply(rv_id)
      If Not bOnlySelected Or bSelected Then
    
        With .Add(Nothing)
        
          ' La primera no se usa
          .Add Nothing
          
          With .Add(Nothing)
            .id = CInt(bSelected)
            .Key = KI_SELECT
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscDocNombre)
            .Key = KI_DOC
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRvNrodoc)
            .Key = KI_NRODOC
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRvNumero)
            .id = rv_id
            .Key = KI_RV_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRvFecha)
            .Key = KI_FECHA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRvTotal)
            .Key = KI_TOTAL
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRvDescrip)
            .Key = KI_DESCRIP
          End With
        End With
      End If
      
      rs.MoveNext
    Wend
  End With
  
  pRefreshRemitos
  pShowTotalRemitos
  
  pLoadRemitosXCliente = True
End Function

' Edit From ListDoc
'
Private Function pGetApply(ByVal rv_id As Long) As Boolean
  Dim i As Long
  
  For i = 1 To UBound(m_RvIds)
    If m_RvIds(i) = rv_id Then
      pGetApply = True
      Exit Function
    End If
  Next
End Function

' Validaciones de Filas
Private Function pIsEmptyRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                  ByVal RowIndex As Long) As Boolean
                                  
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KII_RVI_ID, KII_ARTICULO, KII_PENDIENTE
        If Not ValEmpty(Cell.id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
      
      Case KII_DESCRIP, KII_CANTIDAD
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = True
          Exit For
        End If
      
      Case KII_APLICAR
        If Not ValEmpty(Cell.Value, csDate) Then
          bRowIsEmpty = True
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowItems = bRowIsEmpty
End Function

Private Function pIsEmptyRowNewItems(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                     ByVal RowIndex As Long) As Boolean
                                  
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
  
  pIsEmptyRowNewItems = bRowIsEmpty
End Function

Private Sub pGetDocNumber()
  Dim Tl          As cTalonario
  Dim TAL_ID      As Long
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  Dim Mask        As String
  Dim bEditable   As Boolean
  
  If pGetComprobante().Value <> vbNullString Then Exit Sub
  
  sqlstmt = "sp_clienteGetTalonario " & pGetCliente() & "," & pGetDoc()
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  TAL_ID = gDB.ValField(rs.fields, 0)
  
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
    MsgWarning LNGGetText(1669, vbNullString)   'Debe indicar la fecha de la factura
    Exit Function
  End If
  
  If ValEmpty(pGetCondicionPago().HelpId, csId) Then
    MsgWarning LNGGetText(1561, vbNullString)   'Debe indicar una condición de pago
    Exit Function
  End If
  
  If ValEmpty(pGetCotizacion().Value, csDouble) And WizMustValidateCotizacion(pGetDoc()) Then
    MsgWarning LNGGetText(1626, vbNullString)   'Debe indicar una cotizacion
    Exit Function
  End If
  
  If ValEmpty(pGetSucursal().HelpId, csId) Then
    MsgWarning LNGGetText(1560, vbNullString)   'Debe indicar una sucursal
    Exit Function
  End If
  
  pValidateDatosGenerales = True
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(2220, vbNullString) 'Error al grabar la Factura de Venta
  
  'nrs
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
  
  ReDim m_RvIds(0)
  
  ReDim m_vPercepciones(0)

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
  ReDim m_RvIds(0)
  
  Set m_ObjClient = Nothing
  
  'nrs
  CollClear m_NrosSerie
  Set m_NrosSerie = Nothing
  
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

'///////////////////////////////////////////////////////////////////////////////
Private Function pSave() As Boolean
  
  If Not DocCanSaveEx(m_ObjWizard.EditGeneric, c_Wiz_Key_Fecha, c_Wiz_Key_Doc) Then
    pSave = False
    Exit Function
  End If
  
  Dim register     As cRegister
  Dim Neto         As Double
  Dim IvaRi        As Double
  Dim IvaRni       As Double
  Dim Internos     As Double ' Internos
  Dim Mouse        As cMouseWait
  Dim bIvaRni      As Boolean
  Dim Cotizacion   As Double
  Dim bMonedaLegal As Boolean
  Dim Desc1        As Double
  Dim Desc2        As Double

  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  
  With register
  
    .fieldId = cscFvTMPId
    .Table = csTFacturaVentaTMP
    
    .id = csNew
    
    ' Header
    With .fields
      .Add2 cscFvNumero, 0, csLong
      With pGetComprobante()
        ' PrintDoc
        '
        m_LastNroDoc = SetMask(.Value, .TextMask)
        register.fields.Add2 cscFvNrodoc, m_LastNroDoc, csText
      End With
      .Add2 cscFvDescrip, pGetDescrip().Value, csText
      .Add2 cscFvFecha, pGetFecha().Value, csDate
      .Add2 cscFvFechaentrega, pGetFecha().Value, csDate
      .Add2 cscFvFechaIva, pGetFechaIva().Value, csDate
      .Add2 cscCliId, pGetCliente(), csId
      .Add2 cscCcosId, pGetCentroCosto().HelpId, csId
      .Add2 cscSucId, pGetSucursal().HelpId, csId
      .Add2 cscCpgId, pGetCondicionPago().HelpId, csId
      .Add2 cscLpId, pGetListaPrecio2().HelpId, csId
      .Add2 cscLdId, pGetListaDescuento().HelpId, csId
      .Add2 cscDocId, pGetDoc(), csId
      .Add2 cscLgjId, pGetLegajo().HelpId, csId
      .Add2 cscFvOrdenCompra, pGetOrdenCompra().Value, csText
      
      Desc1 = WizGetDesc(m_ObjWizard, _
                        c_StepDatosGenerales, _
                        c_Wiz_Key_Desc1)
      Desc2 = WizGetDesc(m_ObjWizard, _
                        c_StepDatosGenerales, _
                        c_Wiz_Key_Desc2)
      
      .Add2 cscFvDescuento1, Desc1, csCurrency
      .Add2 cscFvDescuento2, Desc2, csCurrency
      
      Cotizacion = Val(pGetCotizacion().Value)
      .Add2 cscFvCotizacion, Cotizacion, csDouble
      
      .Add2 cscVenId, pGetVendedor().HelpId, csId
      
      .Add2 cscClisId, pGetSucCliente().HelpId, csId
      .Add2 cscTransId, pGetTransporte().HelpId, csId
      .Add2 cscProIdOrigen, pGetProOrigen().HelpId, csId
      .Add2 cscProIdDestino, pGetProDestino().HelpId, csId
      
      .Add2 cscFvGrabarAsiento, 1, csBoolean
      .Add2 cscDeplId, WizGetDeposito(m_ObjWizard, c_StepSelectCliente, c_Wiz_Key_Deposito), csId
    
      .Add2 cscEstId, CSGeneralEx2.csEEstado.csEEst_Pendiente, csId
      .Add2 cscFvId, csNew, csLong
      
      bIvaRni = IsRNI(pGetCliente)
      
      ' Internos
      pGetFooter Neto, IvaRi, IvaRni, bIvaRni, Internos
    
      ' Aplico descuentos
      '
      IvaRi = IvaRi - (IvaRi * Desc1 / 100)
      IvaRni = IvaRni - (IvaRni * Desc1 / 100)
      Internos = Internos - (Internos * Desc1 / 100)
      
      IvaRi = IvaRi - (IvaRi * Desc2 / 100)
      IvaRni = IvaRni - (IvaRni * Desc2 / 100)
      Internos = Internos - (Internos * Desc2 / 100)
      
      Desc1 = Neto * Desc1 / 100
      Neto = Neto - Desc1
      
      Desc2 = Neto * Desc2 / 100
      Neto = Neto - Desc2
      '
      ' Fin descuentos
    
      ' Manejo de la moneda y la cotizacion
      '
      bMonedaLegal = GetMonedaDefault = GetMonIdFromDoc(pGetDoc)
      If bMonedaLegal Then
        Cotizacion = 1
      Else
        If Cotizacion = 0 Then Cotizacion = 1
      End If
      
      Dim TotalPercep  As Double
      TotalPercep = Val(pGetTotalPercepciones().Value)
      
      ' Footer
      .Add2 cscFvSubtotal, Neto * Cotizacion, csCurrency
      .Add2 cscFvNeto, Neto * Cotizacion, csCurrency
      .Add2 cscFvIvari, IvaRi * Cotizacion, csCurrency
      .Add2 cscFvIvarni, IvaRni * Cotizacion, csCurrency
      ' Internos
      .Add2 cscFvInternos, Internos * Cotizacion, csCurrency
      .Add2 cscFvImportedesc1, Desc1 * Cotizacion, csCurrency
      .Add2 cscFvImportedesc2, Desc2 * Cotizacion, csCurrency
      .Add2 cscFvTotalPercepciones, TotalPercep * Cotizacion, csCurrency
            
      ' Internos
      m_FvTotal = (Neto + IvaRi + IvaRni + TotalPercep + Internos) * Cotizacion
      
      .Add2 cscFvTotal, m_FvTotal, csCurrency ' Por ahora no hay descuentos
      
      .HaveLastUpdate = True
      .HaveWhoModify = True
    
    End With
    
    If Not .BeginTrans(gDB) Then Exit Function
    
    If Not gDB.Save(register, , "pSave", C_Module, c_ErrorSave) Then Exit Function
    
    Dim iOrden As Long
    If Not pSaveItems(.id, Cotizacion, bMonedaLegal, bIvaRni, iOrden) Then Exit Function
    If Not pSaveNewItems(.id, Cotizacion, bMonedaLegal, bIvaRni, iOrden) Then Exit Function
    
    If Not SavePercepciones(pGetPercepcionesProperty, _
                            .id, Cotizacion, bMonedaLegal, _
                            False, vbNullString, _
                            csNO_ID, C_Module) Then Exit Function
    
    If Not pSaveVinculacion(.id) Then Exit Function
    
    If Not .CommitTrans() Then Exit Function
  
  End With
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocFacturaVentaSave " & register.id
  
  If Not gDB.SaveSp(sqlstmt, rs, DocGetTimeOut(m_NrosSerie), _
                "pSave", C_Module, c_ErrorSave) Then Exit Function
    
  If rs.EOF Then Exit Function
  
  Dim id As Long
  If Not GetDocIDFromRecordset(rs, id) Then Exit Function
  
  m_Id = id
  
  pSave = m_Id <> 0
End Function

Private Function pSaveItems(ByVal id As Long, _
                            ByVal Cotizacion As Double, _
                            ByVal bMonedaLegal As Boolean, _
                            ByVal bIvaRni As Boolean, _
                            ByRef iOrden As Long) As Boolean
                            
  'Generales
  '
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  Dim Precio    As Double
  Dim IvaRi     As Double
  Dim IvaRni    As Double
  Dim Internos  As Double ' Internos
  Dim int_porc  As Double
  Dim Neto      As Double
  Dim Importe   As Double
  Dim Cantidad  As Double
  Dim sqlstmt   As String
  
  For Each Row In pGetItems().Rows
  
    If Val(pCell(Row, KII_APLICAR).Value) Then
    
      Set register = New cRegister
      
      With register
      
        .fieldId = cscFviTMPId
        .Table = csTFacturaVentaItemTMP
        .id = csNew
        
        With .fields
        
          For Each Cell In Row
            Select Case Cell.Key
              Case KII_APLICAR
                Cantidad = Cell.Value
                .Add2 cscFviCantidad, Cell.Value, csDouble
              Case KII_DESCRIP
                .Add2 cscFviDescrip, Cell.Value, csText
              Case KII_PRECIO_SIN_IVA
                Precio = Val(Cell.Value) * Cotizacion
                .Add2 cscFviPrecio, Precio, csCurrency
              Case KII_PRECIO_LP
                .Add2 cscFviPrecioLista, Val(Cell.Value) * Cotizacion, csCurrency
              Case KII_PRECIO_USR
                .Add2 cscFviPrecioUsr, Val(Cell.Value) * Cotizacion, csCurrency
              Case KII_DESCUENTO
                .Add2 cscFviDescuento, Val(Cell.Value) * Cotizacion, csText
              Case KII_IVARIPercent
                IvaRi = Cell.Value
                .Add2 cscFviIvariporc, IvaRi, csDouble
              Case KII_IVARNIPercent
                If bIvaRni Then
                  IvaRni = Cell.Value
                End If
                .Add2 cscFviIvarniporc, IvaRni, csDouble
              
              ' Internos
              Case KII_INTERNOSPercent
                Internos = Cell.Value
                register.fields.Add2 cscFviInternosPorc, Internos, csDouble
                
              ' Internos
              Case KII_INTERNOSPorc
                int_porc = Cell.Value
                  
              Case KII_ARTICULO
                .Add2 cscPrId, Cell.id, csId
              ' TO
              Case KII_TO_ID
                .Add2 cscToId, Cell.id, csId
              Case KII_CCOS_ID
                .Add2 cscCcosId, Cell.id, csId
            End Select
          Next
        
          Neto = Precio * Cantidad
          .Add2 cscFviNeto, Neto, csCurrency
          
          IvaRi = Neto * IvaRi / 100
          .Add2 cscFviIvari, IvaRi, csCurrency
          
          IvaRni = Neto * IvaRni / 100
          .Add2 cscFviIvarni, IvaRni, csCurrency
          
          ' Internos
          Internos = (Neto * int_porc / 100) * Internos / 100
          .Add2 cscFviInternos, Internos, csCurrency
          
          ' Internos
          Importe = Neto + IvaRi + IvaRni + Internos
          .Add2 cscFviImporte, Importe, csCurrency
                              
          If bMonedaLegal Then
            .Add2 cscFviImporteOrigen, 0, csCurrency
          Else
            .Add2 cscFviImporteOrigen, DivideByCero(Importe, Cotizacion), csCurrency
          End If
          
          ' Esto es muy importante ya que se usa para vincular el remitoventaitem
          ' con el nuevo Facturaventaitem
          iOrden = iOrden + 1
          .Add2 cscFviOrden, iOrden, csInteger
          
          .Add2 cscFvTMPId, id, csId
          .Add2 cscFviId, id, csLong
          
          .Add2 cscFviNoStock, True, csBoolean ' Con esto indicamos que este item no mueve stock
          
          ' Cuentas contables - Por ahora se resuelve asi
          .Add2 cscCueId, -1, csId
          .Add2 cscCueIdIvaRI, -1, csId
          .Add2 cscCueIdIvaRNI, -1, csId
          
          .HaveLastUpdate = False
          .HaveWhoModify = False
      
        End With
        
        If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
        
      End With
      
    End If
  Next
  
  sqlstmt = "sp_DocFacturaVentaWizardSave " & id
  If Not gDB.Execute(sqlstmt, "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
  
  pSaveItems = True
End Function

Private Function pSaveVinculacion(ByVal id As Long) As Boolean
  Dim register        As cRegister
  Dim iOrden          As Long
  Dim bSave           As Boolean
  Dim Row             As cIABMGridRow
  Dim Cell            As cIABMGridCellValue
  
  For Each Row In pGetItems().Rows
  
    Set register = New cRegister
    
    With register
    
      .fieldId = cscRvFvTMPId
      .Table = csTRemitoFacturaVentaTMP
      .id = csNew
    
      bSave = False
      
      With .fields
      
        For Each Cell In Row
          If pCell(Row, KII_SELECT).id Then
            bSave = True
            Select Case Cell.Key
              Case KII_RVI_ID
                .Add2 cscRviId, Cell.id, csId
              Case KII_APLICAR
                .Add2 cscRvFvCantidad, Cell.Value, csDouble
            End Select
          End If
        Next
        
        If bSave Then
          
          .Add2 cscRvFvId, 0, csLong
          .Add2 cscFvTMPId, id, csId
          
          ' Esto es muy importante ya que se usa para vincular el remitoventaitem
          ' con el nuevo Facturaventaitem
          iOrden = iOrden + 1
          .Add2 cscFviId, iOrden, csLong
          
          .HaveLastUpdate = False
          .HaveWhoModify = False
          
          If Not gDB.Save(register, , "pSaveVinculacion", C_Module, c_ErrorSave) Then Exit Function
        End If
        
      End With
    End With
  Next
  
  pSaveVinculacion = True
End Function

Private Sub pGetFooter(ByRef Neto As Double, _
                        ByRef IvaRi As Double, _
                        ByRef IvaRni As Double, _
                        ByVal bIvaRni As Boolean, _
                        ByRef Internos As Double)

  Dim Row               As cIABMGridRow
  Dim Cell              As cIABMGridCellValue
  Dim Precio            As Double
  Dim Cantidad          As Double
  Dim IvaRniPercent     As Double
  Dim IvaRiPercent      As Double
  Dim InternosPercent   As Double ' Internos
  Dim int_porc          As Double
  
  For Each Row In pGetItems().Rows
    
    If pCell(Row, KII_SELECT).id Then
      For Each Cell In Row
        Select Case Cell.Key
          Case KII_APLICAR
            Cantidad = Cell.Value
          Case KII_PRECIO_SIN_IVA
            Precio = Cell.Value
          Case KII_IVARIPercent
            IvaRiPercent = Cell.Value
          Case KII_IVARNIPercent
            If bIvaRni Then
              IvaRniPercent = Cell.Value
            End If
        
          ' Internos
          Case KII_INTERNOSPercent
            InternosPercent = Cell.Value
          
          ' Internos
          Case KII_INTERNOSPorc
            int_porc = Cell.Value
        End Select
      Next
      
      Neto = Neto + (Precio * Cantidad)
      IvaRi = IvaRi + ((Precio * Cantidad) * IvaRiPercent / 100)
      IvaRni = IvaRni + ((Precio * Cantidad) * IvaRniPercent / 100)
    
      ' Internos
      Internos = Internos + ( _
                              ((Precio * Cantidad) * int_porc / 100) _
                              * InternosPercent / 100 _
                            )
    End If
  Next

  ' Nuevos Items
  '
  For Each Row In pGetNewItems().Rows
    Neto = Neto + Val(pCell(Row, KI_NETO).Value)
    IvaRi = IvaRi + Val(pCell(Row, KI_IVARI).Value)
    IvaRni = IvaRni + Val(pCell(Row, KI_IVARNI).Value)
  
    ' Internos
    Internos = Internos + Val(pCell(Row, KI_INTERNOS).Value)
  Next

End Sub

'nrs
'///////////////////////////////////////////////////////////////////////////////////////////////////////////
Private Function pSaveItemNroSerie(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                   ByRef iOrden As Long, _
                                   ByVal PrId As Long, _
                                   ByVal FvTMPId As Long, _
                                   ByVal FviTMPId As Long, _
                                   ByVal Grupo As Long) As Boolean
                                   
  Dim pt        As cProductoSerieType
  Dim register  As cRegister
  
  ' Si lleva numero de serie
  '
  If pCell(Row, KI_PR_LLEVANROSERIE).id Then
  
    ' Obtengo los numeros de serie y guardo un Item por cada uno
    '
    For Each pt In m_NrosSerie.Item(GetKey(Grupo))
      
      Set register = New cRegister
      
      With register
      
        .fieldId = cscFvisTMPId
        .Table = csTFacturaVentaItemSerieTMP
        .id = csNew
        
        With .fields
          .Add2 cscPrId, PrId, csId
        
          .Add2 cscPrnsId, pt.prns_id, csId
        
          .Add2 cscPrnsCodigo, pt.Codigo, csText
          .Add2 cscPrnsDescrip, pt.Descrip, csText
          .Add2 cscPrnsFechavto, pt.FechaVto, csDate
          .Add2 cscPrIdItem, pt.pr_id_item, csId
          
          .Add2 cscFvTMPId, FvTMPId, csId
          .Add2 cscFviTMPId, FviTMPId, csId
          
          iOrden = iOrden + 1
          .Add2 cscFvisOrden, iOrden, csInteger
          
          .HaveLastUpdate = False
          .HaveWhoModify = False
        
        End With
      End With
      
      If Not gDB.Save(register, , "pSaveItemNroSerie", C_Module, c_ErrorSave) Then Exit Function
    Next
  End If
  
  pSaveItemNroSerie = True
End Function

Private Sub pGetIvaFromCliente(ByVal cli_id As Long)
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  
  sqlstmt = "sp_ClienteGetIva " & cli_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  m_bIva = gDB.ValField(rs.fields, "bIva")
  m_bIvaRni = gDB.ValField(rs.fields, "bIvaRni")
End Sub

Private Sub pSetDatosCliente()
  
  Dim trans_id      As Long
  Dim pro_id        As Long
  Dim ven_id        As Long
  
  Dim trans_nombre      As String
  Dim pro_nombre        As String
  Dim ven_nombre        As String
  
  Dim cpg_id      As Long
  Dim cpg_nombre  As String
  Dim iProp       As cIABMProperty
  
  With pGetClienteProp()
    If m_LastCli = .HelpId Then
      Exit Sub
    End If
    m_LastCli = .HelpId
  End With

  If Not GetClienteDataEx2(m_LastCli, _
                          0, _
                          0, _
                          cpg_id, _
                          trans_id, pro_id, ven_id, _
                          trans_nombre, pro_nombre, ven_nombre, _
                          m_LastDoc) Then Exit Sub
  
  ' Condicion de pago
  If cpg_id <> csNO_ID Then
    
    If Not gDB.GetData(csTCondicionPago, cscCpgId, cpg_id, cscCpgNombre, cpg_nombre) Then Exit Sub
    
    Set iProp = pGetCondicionPago()
    iProp.Value = cpg_nombre
    iProp.HelpId = cpg_id
    m_ObjWizard.ShowValue iProp
  End If
  
  pSetListaPrecio
  
'////////////////////////////////////////////////////////////
  Set iProp = pGetVendedor()
  With iProp
    If ven_id <> csNO_ID Then
      .Value = ven_nombre
      .HelpId = ven_id
    Else
      .Value = vbNullString
      .HelpId = csNO_ID
    End If
  End With
  m_ObjWizard.ShowValue iProp
  
  Set iProp = pGetTransporte()
  With iProp
    If trans_id <> csNO_ID Then
      .Value = trans_nombre
      .HelpId = trans_id
    Else
      .Value = vbNullString
      .HelpId = csNO_ID
    End If
  End With
  m_ObjWizard.ShowValue iProp
  
  Set iProp = pGetProDestino()
  With iProp
    If pro_id <> csNO_ID Then
      .Value = pro_nombre
      .HelpId = pro_id
    Else
      .Value = vbNullString
      .HelpId = csNO_ID
    End If
  End With
  m_ObjWizard.ShowValue iProp

  Set iProp = pGetSucCliente()
  With iProp
    .HelpFilter = GetHelpFilterCliSuc(m_LastCli)
  End With
  
  m_ObjWizard.ShowValue iProp

'////////////////////////////////////////////////////////////
  
  ' Talonario y Categoria fiscal
  pGetIvaFromCliente m_LastCli
  
'////////////////////////////////////////////////////////////

  ' Percepciones
  LoadPercepcionesForCliente m_LastCli, _
                             m_vPercepciones(), _
                             pGetFecha().Value
End Sub

Private Sub pSetListaPrecio()
  Dim iProp       As cIABMProperty
  Dim lp_id       As Long
  Dim ld_id       As Long
  Dim LP          As cListaPrecio
  Dim LD          As cListaDescuento
  Dim Filter      As String
  
  If Not GetClienteData2(m_LastCli, lp_id, ld_id, 0, m_LastDoc) Then Exit Sub
  
  ' Lista de precios
  Set iProp = pGetListaPrecio()
  iProp.HelpFilter = GetListaPrecioGetXCliente(m_LastDoc, m_LastCli)
  
  If lp_id <> csNO_ID Then
    Set LP = New cListaPrecio
    iProp.Value = LP.GetData(lp_id, cscLpNombre, csText)
    iProp.HelpId = lp_id
  End If
  
  m_ObjWizard.ShowValue iProp
  
  ' Lista de precios
  Set iProp = pGetListaPrecio2()
  iProp.HelpFilter = GetListaPrecioGetXCliente(m_LastDoc, m_LastCli)
  
  If lp_id <> csNO_ID Then
    Set LP = New cListaPrecio
    iProp.Value = LP.GetData(lp_id, cscLpNombre, csText)
    iProp.HelpId = lp_id
  End If
  
  m_ObjWizard.ShowValue iProp
  
  ' Lista de descuentos
  Set iProp = pGetListaDescuento()
  iProp.HelpFilter = GetListaDescGetXCliente(m_LastDoc, m_LastCli)
  
  If ld_id <> csNO_ID Then
    Set LD = New cListaDescuento
    iProp.Value = LD.GetData(ld_id, cscLdNombre, csText)
    iProp.HelpId = ld_id
  End If
  
  m_ObjWizard.ShowValue iProp
End Sub

Private Sub pNewEmptyProperties()
  ' (ByRef Grid As cIABMGrid)
  
  pGetRemitos().Rows.Clear
  pGetItems().Rows.Clear
  pGetNewItems().Rows.Clear
  pGetPercepciones().Rows.Clear

  With pGetComprobante()
    .Value = vbNullString
    .TextMask = vbNullString
  End With
  With pGetCentroCosto()
    .HelpId = csNO_ID
    .Value = vbNullString
  End With
  With pGetCondicionPago()
    .HelpId = csNO_ID
    .Value = vbNullString
  End With
  With pGetListaPrecio()
    .HelpId = csNO_ID
    .Value = vbNullString
  End With
  With pGetListaDescuento()
    .HelpId = csNO_ID
    .Value = vbNullString
  End With
  With pGetProOrigen()
    .HelpId = csNO_ID
    .Value = vbNullString
  End With
  With pGetProDestino()
    .HelpId = csNO_ID
    .Value = vbNullString
  End With
  With pGetTransporte()
    .HelpId = csNO_ID
    .Value = vbNullString
  End With
  With pGetSucCliente()
    .HelpId = csNO_ID
    .Value = vbNullString
  End With
  With pGetOrdenCompra()
    .Value = vbNullString
  End With
  With pGetLegajo()
    .HelpId = csNO_ID
    .Value = vbNullString
  End With
  With pGetVendedor()
    .HelpId = csNO_ID
    .Value = vbNullString
  End With
  
  pGetDescrip().Value = vbNullString
  
  With m_ObjWizard
    .ShowValue pGetRemitosProperty()
    .ShowValue pGetItemsProperty()
    .ShowValue pGetNewItemsProperty()
    .ShowValue pGetPercepcionesProperty()
    .ShowValue pGetComprobante()
    .ShowValue pGetCentroCosto()
    .ShowValue pGetCondicionPago()
    .ShowValue pGetProOrigen()
    .ShowValue pGetProDestino()
    .ShowValue pGetTransporte()
    .ShowValue pGetSucCliente()
    .ShowValue pGetOrdenCompra()
    .ShowValue pGetLegajo()
    .ShowValue pGetVendedor()
    .ShowValue pGetListaPrecio()
    .ShowValue pGetListaDescuento()
    .ShowValue pGetDescrip()
  End With
  
End Sub

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

'////////////////////////////////////////////////////////////////////////////////
'
' Percepciones
'

Private Sub pCalcularPercepciones()

  Dim Row       As cIABMGridRow
  Dim i         As Long
  Dim perc_id   As Long
  Dim Neto      As Double
  Dim Total     As Double
  
  If m_doc_sin_perc Then Exit Sub
  
  For i = 1 To UBound(m_vPercepciones)
    With m_vPercepciones(i)
      
      .base = 0
      
      '----------------------------------------------
      ' Items sobre remitos
      '
      
      For Each Row In pGetItems().Rows
      
        Neto = Val(pCell(Row, KII_APLICAR).Value) _
             * Val(pCell(Row, KII_PRECIO_SIN_IVA).Value)
             
        Select Case .tipo_base
          Case csE_PercepcionBase.csEPB_Neto
            .base = .base + Neto
          
          Case csE_PercepcionBase.csEPB_NetoGravado
            
            If Val(pCell(Row, KII_IVARIPercent).Value) Then
              .base = .base + Neto
            End If
            
          Case csE_PercepcionBase.csEPB_Total
          
            Total = Neto + (Neto * Val(pCell(Row, KII_IVARIPercent).Value) / 100)
            .base = .base + Total
        End Select
      Next
      
      '----------------------------------------------
      ' Nuevos Items
      '
      
      For Each Row In pGetNewItems().Rows
      
        Neto = Val(pCell(Row, KI_NETO).Value)
             
        Select Case .tipo_base
          Case csE_PercepcionBase.csEPB_Neto
            .base = .base + Neto
          
          Case csE_PercepcionBase.csEPB_NetoGravado
            
            If Val(pCell(Row, KI_IVARI).Value) Then
              .base = .base + Neto
            End If
            
          Case csE_PercepcionBase.csEPB_Total
          
            Total = Val(pCell(Row, KI_IMPORTE).Value)
            .base = .base + Total
        End Select
      Next
      
      '----------------------------------------------
      
      If .base > .minimo Then
      
        If .base >= .desde And .base <= .hasta Then
        
          .percepcion = .base * .porc / 100 + .fijo
        End If
      End If
      
    End With
  Next
  
  Dim Rows As cIABMGridRows
  Dim Cell As cIABMGridCellValue
  
  Set Rows = pGetPercepcion().Grid.Rows
  
  Rows.Clear
  
  For i = 1 To UBound(m_vPercepciones)
    
    With m_vPercepciones(i)
      
      If .percepcion Then
            
        Set Row = Rows.Add(Nothing)
              
        Set Cell = Row.Add(Nothing)
        Cell.Value = 0
        Cell.Key = KIP_FVPERC_ID
        
        Set Cell = Row.Add(Nothing)
        Cell.Value = .nombre
        Cell.id = .perc_id
        Cell.Key = KIP_PERC_ID
        
        Set Cell = Row.Add(Nothing)
        Cell.Value = .base
        Cell.Key = KIP_BASE
        
        Set Cell = Row.Add(Nothing)
        Cell.Value = .porc
        Cell.Key = KIP_PORCENTAJE
        
        Set Cell = Row.Add(Nothing)
        Cell.Value = .percepcion
        Cell.Key = KIP_IMPORTE
        
        Set Cell = Row.Add(Nothing)
        Cell.Value = vbNullString
        Cell.Key = KIP_DESCRIP
        
        Set Cell = Row.Add(Nothing)
        Cell.Value = vbNullString
        Cell.id = csNO_ID
        Cell.Key = KI_CCOS_ID
      
      End If
    End With
  Next
  
  Dim ObjWiz As cWizardGeneric
  Set ObjWiz = m_ObjWizard
  
  ObjWiz.ShowValue pGetPercepcion(), True
  
End Sub

Private Function pGetPercepcion() As cIABMProperty
  Set pGetPercepcion = GetWizProperty(m_ObjWizard, _
                                      c_StepPercepciones, _
                                      c_Wiz_Key_percepciones)
End Function

Private Sub pSetDatosFromAplic()
  Dim sqlstmt           As String
  Dim rs                As Recordset
  Dim i                 As Long
  
  sqlstmt = "sp_DocFacturaVentaGetDataFromAplic 3,'" & pGetRemitosIds & "'"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Dim iProp As cIABMProperty
  
  While Not rs.EOF

    Set iProp = pGetSucursal()
    If iProp.HelpId = csNO_ID And _
       gDB.ValField(rs.fields, cscSucId) <> csNO_ID Then
       
      With iProp
        .HelpId = gDB.ValField(rs.fields, cscSucId)
        .Value = gDB.ValField(rs.fields, cscSucNombre)
      End With
      m_ObjWizard.ShowValue iProp
    End If

    Set iProp = pGetCondicionPago()
    If iProp.HelpId = csNO_ID And _
       gDB.ValField(rs.fields, cscCpgId) <> csNO_ID Then
       
      With iProp
        .HelpId = gDB.ValField(rs.fields, cscCpgId)
        .Value = gDB.ValField(rs.fields, cscCpgNombre)
      End With
      m_ObjWizard.ShowValue iProp
    End If

    Set iProp = pGetCentroCosto()
    If iProp.HelpId = csNO_ID And _
       gDB.ValField(rs.fields, cscCcosId) <> csNO_ID Then
       
      With iProp
        .HelpId = gDB.ValField(rs.fields, cscCcosId)
        .Value = gDB.ValField(rs.fields, cscCcosNombre)
      End With
      m_ObjWizard.ShowValue iProp
    End If

    Set iProp = pGetVendedor()
    If iProp.HelpId = csNO_ID And _
       gDB.ValField(rs.fields, cscVenId) <> csNO_ID Then
       
      With iProp
        .HelpId = gDB.ValField(rs.fields, cscVenId)
        .Value = gDB.ValField(rs.fields, cscVenNombre)
      End With
      m_ObjWizard.ShowValue iProp
    End If

    Set iProp = pGetLegajo()
    If iProp.HelpId = csNO_ID And _
       gDB.ValField(rs.fields, cscLgjId) <> csNO_ID Then
       
      With iProp
        .HelpId = gDB.ValField(rs.fields, cscLgjId)
        .Value = gDB.ValField(rs.fields, cscLgjTitulo)
      End With
      m_ObjWizard.ShowValue iProp
    End If

    Set iProp = pGetProOrigen()
    If iProp.HelpId = csNO_ID And _
       gDB.ValField(rs.fields, cscProIdOrigen) <> csNO_ID Then
       
      With iProp
        .HelpId = gDB.ValField(rs.fields, cscProIdOrigen)
        .Value = gDB.ValField(rs.fields, "provincia_origen")
      End With
      m_ObjWizard.ShowValue iProp
    End If

    Set iProp = pGetProDestino()
    If iProp.HelpId = csNO_ID And _
       gDB.ValField(rs.fields, cscProIdDestino) <> csNO_ID Then
       
      With iProp
        .HelpId = gDB.ValField(rs.fields, cscProIdDestino)
        .Value = gDB.ValField(rs.fields, "provincia_destino")
      End With
      m_ObjWizard.ShowValue iProp
    End If
            
    Set iProp = pGetSucCliente()
    If iProp.HelpId = csNO_ID And _
       gDB.ValField(rs.fields, cscClisId) <> csNO_ID Then
       
      With iProp
        .HelpId = gDB.ValField(rs.fields, cscClisId)
        .Value = gDB.ValField(rs.fields, cscClisNombre)
      End With
      m_ObjWizard.ShowValue iProp
    End If
            
    Set iProp = pGetOrdenCompra()
    If LenB(iProp.Value) = 0 And _
       LenB(gDB.ValField(rs.fields, cscRvOrdenCompra)) Then
       
      With iProp
        .Value = gDB.ValField(rs.fields, cscRvOrdenCompra)
      End With
      m_ObjWizard.ShowValue iProp
    End If
            
    Set iProp = pGetTransporte()
    If iProp.HelpId = csNO_ID And _
       gDB.ValField(rs.fields, cscTransId) <> csNO_ID Then
       
      With iProp
        .HelpId = gDB.ValField(rs.fields, cscTransId)
        .Value = gDB.ValField(rs.fields, cscTransNombre)
      End With
      m_ObjWizard.ShowValue iProp
    End If
            
    rs.MoveNext
  Wend
End Sub

'-----------------------------------------------------------------------------
Private Function pColumnAfterEdit(ByRef IProperty As cIABMProperty, _
                                  ByVal lRow As Long, _
                                  ByVal lCol As Long, _
                                  ByVal NewValue As Variant, _
                                  ByVal NewValueID As Long) As Boolean
  Dim Row As cIABMGridRow
  
  Select Case IProperty.Grid.Columns(lCol).Key
    Case KI_PR_ID
      Set Row = IProperty.Grid.Rows(lRow)
      pSetDataProducto Row, NewValueID
      SetPrecio Row, NewValueID, pGetListaPrecio(), KI_PRECIO_LP, KI_PRECIO_USR
      SetDescuento Row, NewValueID, pGetPrecioFromRow(Row), pGetListaPrecio(), KI_PRECIO, KI_DESCUENTO
      pSetTasasImpositivas Row, NewValueID, NewValue
    
    Case KI_PRECIO_USR
      Set Row = IProperty.Grid.Rows(lRow)
      SetDescuento Row, pCell(Row, KI_PR_ID).id, NewValue, pGetListaDescuento(), KI_PRECIO, KI_DESCUENTO
      
  End Select
  
  pColumnAfterEdit = True
End Function

' Reglas del Objeto de Negocios
Private Sub pSetDataProducto(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                             ByVal pr_id As Long)
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim bEsKit  As Boolean
  
  Dim bChanged As Boolean
  
  bChanged = pr_id <> pCell(Row, KI_PR_ID).id
  
  sqlstmt = "sp_StockProductoGetData " & pr_id & "," & pGetCliente() & ",Null"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
    bEsKit = gDB.ValField(rs.fields, cscPrEskit)

    pCell(Row, KI_UNIDAD).Value = gDB.ValField(rs.fields, "unidadVenta")
    
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
    pCell(Row, KI_CUE_ID).Value = gDB.ValField(rs.fields, cscCueidventa)
  
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

Private Sub pSetTasasImpositivas(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal pr_id As Long, ByVal pr_nombre As String)
  Dim ti_ri         As Long
  Dim ti_rni        As Long
  Dim ti_internos   As Long ' Internos
  Dim porc_internos As Double
  
  If pr_id = 0 Then Exit Sub
  
  ' Internos
  If Not GetTasaFromProductoEx(pr_id, ti_ri, ti_rni, _
                               ti_internos, porc_internos, _
                               False) Then Exit Sub
  
  If ti_ri = 0 Then
    MsgWarning LNGGetText(1597, vbNullString, pr_nombre)
    'El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de ventas para el iva responsable inscripto"
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
      pCell(Row, KI_CUE_ID_IVARI).Value = gDB.ValField(rs.fields, cscCueId)
    End If
  Else
    pCell(Row, KI_IVARIPercent).Value = 0
    pCell(Row, KI_CUE_ID_IVARI).Value = csNO_ID
  End If
  
  If m_bIvaRni Then
    sqlstmt = "select ti_porcentaje,cue_id from tasaimpositiva where ti_id = " & ti_rni
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
    
    If Not rs.EOF Then
      pCell(Row, KI_IVARNIPercent).Value = gDB.ValField(rs.fields, cscTiPorcentaje)
      pCell(Row, KI_CUE_ID_IVARNI).Value = gDB.ValField(rs.fields, cscCueId)
    End If
  Else
    pCell(Row, KI_IVARNIPercent).Value = 0
    pCell(Row, KI_CUE_ID_IVARNI).Value = csNO_ID
  End If

  ' Internos
  sqlstmt = "select ti_porcentaje from tasaimpositiva where ti_id = " & ti_internos
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
    ' Internos
    pCell(Row, KI_INTERNOSPercent).Value = gDB.ValField(rs.fields, cscTiPorcentaje)
    pCell(Row, KI_INTERNOS_PORC).Value = porc_internos
  End If

End Sub

Private Function pLoadNewItems(ByRef Grid As cIABMGrid) As Boolean
  
  Dim bHideCols As Boolean
  bHideCols = CInt(CSKernelClient2.GetRegistry(csInterface, c_HideColsFv, 1))
  
  Dim oCol    As cABMGridColumn
  Dim iCol    As cIABMGridColumn
  
  With Grid
  
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
  
      With .Add(Nothing)
        .Visible = False
        .Key = KI_FVI_ID
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
        .Visible = False
        .Key = KI_CUE_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_CUE_ID_IVARI
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_CUE_ID_IVARNI
      End With
      
      With .Add(Nothing)
        .name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 1200
        .Key = KI_DESCRIP
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1374, vbNullString)  'Cantidad
        .Format = m_GeneralConfig.FormatDecCantidad
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KI_CANTIDAD
      
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Value = 1
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1639, vbNullString)  'Nro. Serie
        .PropertyType = cspText
        .SubType = cspTextButton
        .Width = 3000
        .Key = KI_NROSERIE
        .Visible = m_bShowStockData
      End With
      
      ' Lote
      '
      With .Add(Nothing, cscStlId)
        .name = LNGGetText(1640, vbNullString)  'Lote
        .PropertyType = cspHelp
        .Table = csStockLote
        .Width = 2000
        .Key = KI_STL_ID
        .Visible = m_bShowStockData
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1585, vbNullString)  'Descuento
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .Key = KI_DESCUENTO
        .Enabled = False
        .Visible = Not bHideCols
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1165, vbNullString)  'Unidad
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_UNIDAD
        .Enabled = False
        .Visible = Not bHideCols
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1587, vbNullString)  'Precio (LP)
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .Key = KI_PRECIO_LP
        .Enabled = False
        .Visible = Not bHideCols
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1586, vbNullString)  'Precio
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1200
        .Format = m_GeneralConfig.FormatDecImporte
        .Key = KI_PRECIO_USR
        .Enabled = SecurityCanAccessSilent(csPreVtaEditPriceFac)
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1588, vbNullString)  'Precio c/desc.
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1200
        .Format = m_GeneralConfig.FormatDecImporte
        .Key = KI_PRECIO
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1581, vbNullString)  'Neto
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .Key = KI_NETO
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1582, vbNullString)  'IVA RI
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .Key = KI_IVARI
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1583, vbNullString)  'IVA RNI
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .Key = KI_IVARNI
        .Enabled = False
        .Visible = Not bHideCols
      End With
      
      ' Internos
      With .Add(Nothing)
        .name = LNGGetText(4914, vbNullString)  'Internos
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .Key = KI_INTERNOS
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1228, vbNullString)  'Importe
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
      
      ' Internos
      With .Add(Nothing)
        .Visible = False
        .Key = KI_INTERNOSPercent
      End With
      
      ' Internos
      With .Add(Nothing)
        .Visible = False
        .Key = KI_INTERNOS_PORC
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1057, vbNullString)  'Centro de Costo
        .PropertyType = cspHelp
        .Table = csCentroCosto
        .Width = 1800
        .Key = KI_CCOS_ID
      End With
      
      ' TO
      With .Add(Nothing)
        .name = LNGGetText(1492, vbNullString)  'Tipo Operación
        .PropertyType = cspHelp
        .Table = csTipoOperacion
        .Width = 1800
        Set .DefaultValue = New cABMGridRowValue
        With .DefaultValue
          .id = C_TO_ComercialId
          .Value = C_TO_Comercial
        End With
        .Key = KI_TO_ID
        .Visible = Not bHideCols
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
  
  End With
  
  pLoadNewItems = True
End Function

Private Function pCheckNewItems() As Boolean
  Dim Row                 As cIABMGridRow
  Dim i                   As Long
  
  With pGetNewItems().Rows
    If .count Then
      If pIsEmptyRowNewItems(.Item(.count), .count) Then
        .Remove .count
      End If
    End If
  End With
  
  For Each Row In pGetNewItems().Rows
    i = i + 1
    If Not pValidateRowNewItems(Row, i) Then Exit Function
  Next
  
  If Not (Val(pGetTotalNewItems.Value) + Val(pGetTotalItems().Value)) > 0 Then
    MsgWarning LNGGetText(1678, vbNullString) 'Debe indicar uno o más items.
    Exit Function
  End If
  
  pCheckNewItems = True
End Function

Private Sub pShowImporteAndIva(ByRef Row As CSInterfacesABM.cIABMGridRow)
  Dim Importe     As Double
  Dim Neto        As Double
  Dim IvaRi       As Double
  Dim IvaRni      As Double
  Dim Internos    As Double ' Internos
  
  Neto = Val(pCell(Row, KI_CANTIDAD).Value) * Val(pCell(Row, KI_PRECIO).Value)
  If m_bIva Then
    IvaRi = (Neto * Val(pCell(Row, KI_IVARIPercent).Value)) / 100
  End If
  If m_bIvaRni Then
    IvaRni = (Neto * Val(pCell(Row, KI_IVARNIPercent).Value)) / 100
  End If
  
  ' Internos
  Internos = (Neto _
              * (Val(pCell(Row, KI_INTERNOS_PORC).Value) / 100) _
              * Val(pCell(Row, KI_INTERNOSPercent).Value)) / 100
  
  ' Internos
  Importe = Neto + IvaRi + IvaRni + Internos
  
  pCell(Row, KI_NETO).Value = Neto
  pCell(Row, KI_IVARI).Value = IvaRi
  pCell(Row, KI_IVARNI).Value = IvaRni
  
  ' Internos
  pCell(Row, KI_INTERNOS).Value = Internos
  pCell(Row, KI_IMPORTE).Value = Importe
End Sub

Private Function pSaveNewItems(ByVal id As Long, _
                               ByVal Cotizacion As Double, _
                               ByVal bMonedaLegal As Boolean, _
                               ByVal bIvaRni As Boolean, _
                               ByVal iOrden As Long) As Boolean
  Dim register  As cRegister
  Dim Origen    As Double
  Dim Neto      As Double
  Dim IvaRi     As Double
  Dim IvaRni    As Double
  Dim Internos  As Double ' Internos
  Dim int_porc  As Double
  
  ' Para numeros de serie
  '
  Dim iOrden2     As Long
  Dim Grupo       As Long
  Dim PrId        As Long
        
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  For Each Row In pGetNewItems().Rows
  
    Set register = New cRegister
    register.fieldId = cscFviTMPId
    register.Table = csTFacturaVentaItemTMP
    register.id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KI_FVI_ID
          register.fields.Add2 cscFviId, csNew, csInteger
        Case KI_CANTIDAD
          register.fields.Add2 cscFviCantidad, Cell.Value, csDouble
        Case KI_DESCRIP
          register.fields.Add2 cscFviDescrip, Cell.Value, csText
        Case KI_PRECIO
          register.fields.Add2 cscFviPrecio, Val(Cell.Value) * Cotizacion, csCurrency
        Case KI_PRECIO_LP
          register.fields.Add2 cscFviPrecioLista, Val(Cell.Value) * Cotizacion, csCurrency
        Case KI_PRECIO_USR
          register.fields.Add2 cscFviPrecioUsr, Val(Cell.Value) * Cotizacion, csCurrency
        Case KI_NETO
          Neto = Val(Cell.Value)
          register.fields.Add2 cscFviNeto, Neto * Cotizacion, csCurrency
        Case KI_IVARI
          ' Por seguridad
          If m_bIva Then
            IvaRi = Val(Cell.Value)
            register.fields.Add2 cscFviIvari, IvaRi * Cotizacion, csCurrency
          End If
        Case KI_IVARNI
          ' Por seguridad
          If bIvaRni Then
            IvaRni = Val(Cell.Value)
            register.fields.Add2 cscFviIvarni, IvaRni * Cotizacion, csCurrency
          End If
          
        ' Internos
        Case KI_INTERNOS
          Internos = Val(Cell.Value)
          register.fields.Add2 cscFviInternos, Internos * Cotizacion, csCurrency
          
        Case KI_IVARIPercent
          register.fields.Add2 cscFviIvariporc, Cell.Value, csDouble
        Case KI_IVARNIPercent
          register.fields.Add2 cscFviIvarniporc, Cell.Value, csDouble
        
        ' Internos
        Case KI_INTERNOSPercent
          register.fields.Add2 cscFviInternosPorc, Cell.Value, csDouble
        
        Case KI_PR_ID
          PrId = Cell.id
          register.fields.Add2 cscPrId, PrId, csId
        Case KI_CCOS_ID
          register.fields.Add2 cscCcosId, Cell.id, csId
        ' TO
        Case KI_TO_ID
          register.fields.Add2 cscToId, Cell.id, csId
        Case KI_CUE_ID
          register.fields.Add2 cscCueId, Val(Cell.Value), csId
        Case KI_CUE_ID_IVARI
          register.fields.Add2 cscCueIdIvaRI, Val(Cell.Value), csId
        Case KI_CUE_ID_IVARNI
          register.fields.Add2 cscCueIdIvaRNI, Val(Cell.Value), csId
        Case KI_GRUPO
          Grupo = Cell.id
        
        ' Lote
        '
        Case KI_STL_ID
          register.fields.Add2 cscStlId, Cell.id, csId
      End Select
    Next
    
    ' Por seguridad
    Origen = Neto
    If m_bIva Then
      Origen = Origen + IvaRi
    End If
    If bIvaRni Then
      Origen = Origen + IvaRni
    End If
    
    ' Internos
    Origen = Origen + Internos
    
    register.fields.Add2 cscFviImporte, Origen * Cotizacion, csCurrency
    If bMonedaLegal Then
      register.fields.Add2 cscFviImporteOrigen, 0, csCurrency
    Else
      register.fields.Add2 cscFviImporteOrigen, Origen, csCurrency
    End If
    
    iOrden = iOrden + 1
    register.fields.Add2 cscFviOrden, iOrden, csInteger
    register.fields.Add2 cscFvTMPId, id, csId
    
    register.fields.HaveLastUpdate = False
    register.fields.HaveWhoModify = False
    
    If Not gDB.Save(register, , "pSaveNewItems", C_Module, c_ErrorSave) Then Exit Function
  
    ' Si es nuevo se usa el orden
    If Grupo = 0 Then Grupo = iOrden * -1
    If Not pSaveItemNroSerie(Row, iOrden2, PrId, id, register.id, Grupo) Then Exit Function
  Next
    
  pSaveNewItems = True
End Function

Private Function pProcessMultiRow(ByVal Info As Variant) As Boolean
  
  Info.bAddRows = False
  
  Select Case Info.Key
    Case KW_NEW_ITEMS
      With pGetNewItemsProperty()
        
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

Private Function pGetDocIdFromDb() As Long
  Dim doc_id As Long
  If Not gDB.GetData(csTFacturaVenta, cscFvId, m_Id, cscDocId, doc_id) Then Exit Function
  pGetDocIdFromDb = doc_id
End Function
