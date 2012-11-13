VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRemitoVentaOrdenWiz"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIWizardClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cRemitoVentaOrdenWiz
' 01-05-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cRemitoVentaOrdenWiz"

Private Const c_StepWelcome             As Integer = 1
Private Const c_StepSelectCliente       As Integer = 3
Private Const c_StepSelectOrden         As Integer = 4
Private Const c_StepSelectItems         As Integer = 6
Private Const c_StepDatosGenerales      As Integer = 7

Private Const c_Wiz_Key_Ordenes = "ORDENES"

Private Const KW_ORDENES                     As Integer = 10
Private Const KW_TODOS                       As Integer = 110
Private Const KW_ITEMS                       As Integer = 120
Private Const KW_TODOS_ITEMS                 As Integer = 130
Private Const KW_LPALL_ITEMS                 As Integer = 131 'lp
Private Const KW_LPZERO_ITEMS                As Integer = 132 'lp
Private Const KW_CLIENTE2                    As Integer = 220
Private Const KW_FECHA                       As Integer = 230
Private Const KW_SUCURSAL                    As Integer = 240
Private Const KW_DESCRIP                     As Integer = 250
Private Const KW_COMPROBANTE                 As Integer = 260
Private Const KW_LEGAJO                      As Integer = 280
Private Const KW_CENTROCOSTO                 As Integer = 290
Private Const KW_LP_ID                       As Integer = 300
Private Const KW_LP_ID2                      As Integer = 305 'lp
Private Const KW_DOC_ID                      As Integer = 310
Private Const KW_CLI_ID                      As Integer = 340

Private Const KW_VEN_ID                      As Integer = 360 'lp

Private Const KW_TRANS_ID                    As Integer = 380
Private Const KW_PRO_ID_ORIGEN               As Integer = 390 'lp
Private Const KW_PRO_ID_DESTINO              As Integer = 400 'lp
Private Const KW_CLIS_ID                     As Integer = 420

Private Const KW_DEPL_ID                     As Integer = 500

Private Const KW_RETIRO                      As Integer = 610
Private Const KW_GUIA                        As Integer = 620

Private Const KI_OS_ID                       As Integer = 1
Private Const KI_SELECT                      As Integer = 2
Private Const KI_DOC                         As Integer = 3
Private Const KI_NRODOC                      As Integer = 4
Private Const KI_FECHA                       As Integer = 5
Private Const KI_DESCRIP                     As Integer = 8
Private Const KI_TOTAL                       As Integer = 10

Private Const KII_SELECT                 As Integer = 1
Private Const KII_OSI_ID                 As Integer = 2
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

'nrs
' Numeros de serie
Private Const KI_PR_LLEVANROSERIE               As Integer = 300
Private Const KI_NROSERIE                       As Integer = 301
Private Const KI_GRUPO                          As Integer = 302
Private Const KI_ES_KIT                         As Integer = 303

' Lote
'
Private Const KI_STL_ID                         As Integer = 26
Private Const KI_PR_LLEVALOTE                   As Integer = 27

' Lote Fifo
'
Private Const KI_PR_LOTEFIFO                    As Integer = 32

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_ObjWizard               As cIWizardGeneric

Private m_WizardProcessing        As Boolean
Private m_WizardCancel            As Boolean

'Private m_Resource                As fResource

Private m_GeneralConfig     As cGeneralConfig
Private m_StockConfig       As cStockConfig

Private m_Id                As Long

Private m_cli_id            As Long
Private m_cliente           As String
Private m_doc_id            As Long
Private m_Documento         As String
Private m_OsIds()           As Long
Private m_PrnsIds()         As Long

Private m_bShowStockData               As Boolean

' Lote
'
Private m_depf_id                      As Long

Private m_ObjClient         As Object

Private m_LastCli           As Long
Private m_LastDoc           As Long
Private m_lastmonid         As Long

' PrintDoc
'
Private m_LastNroDoc        As String

Private m_bIva              As Boolean
Private m_bIvaRni           As Boolean

'nrs
Private m_NrosSerie         As Collection
Private m_CollKitInfo       As Collection

Private m_bAutoSelect       As Boolean

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

Private m_bAutoFactura      As Boolean
Private m_bAutoPago         As Boolean
Private m_ModoVentaCtaCte   As Boolean
Private m_cue_id_autoPago   As Long

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

Public Property Let Cliente(ByVal rhs As String)
  m_cliente = rhs
End Property

Public Property Let OsIds(ByRef rhs() As Long)
  On Error Resume Next
  Dim i As Long
  ReDim m_OsIds(UBound(rhs))
  For i = 0 To UBound(rhs)
    m_OsIds(i) = rhs(i)
  Next
End Property

Public Property Let OsiIds(ByRef rhs() As Long)
  On Error Resume Next
  Dim i As Long
  ReDim m_PrnsIds(UBound(rhs))
  For i = 0 To UBound(rhs)
    m_PrnsIds(i) = rhs(i)
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

Public Property Let AutoFactura(ByVal rhs As Boolean)
  m_bAutoFactura = rhs
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
    Case KW_ORDENES
      cIABMClientGrid_IsEmptyRow = False
    Case KW_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowItems(Row, RowIndex)
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
    Case KW_ORDENES
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateOrden(pGetOrdenesProperty(), lRow, lCol)
    Case KW_ITEMS
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateItems(pGetItemsProperty(), lRow, lCol)
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
    Case KW_ORDENES
      cIABMClientGrid_ColumnAfterEdit = True
    Case KW_ITEMS
      cIABMClientGrid_ColumnAfterEdit = pColumnAfterEditItems( _
                                            pGetItemsProperty(), _
                                            lRow, _
                                            lCol, _
                                            NewValue, _
                                            NewValueID)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnAfterEdit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pColumnAfterEditItems(ByRef IProperty As cIABMProperty, _
                                       ByVal lRow As Long, _
                                       ByVal lCol As Long, _
                                       ByVal NewValue As Variant, _
                                       ByVal NewValueID As Long) As Boolean
  Dim Row As cIABMGridRow
  
  Select Case IProperty.Grid.Columns(lCol).Key
    
    Case KII_APLICAR
      
      Set Row = IProperty.Grid.Rows(lRow)
      
      If pCell(Row, KI_PR_LLEVANROSERIE).id Then
      
        Dim PrId As Long
        
        PrId = pCell(Row, KII_ARTICULO).id
      
        If Not NroSerieCantidadChanged(Row, _
                                       lRow, _
                                       KII_CANTIDAD, _
                                       NewValue, _
                                       KI_GRUPO, _
                                       m_NrosSerie, _
                                       KII_ARTICULO, _
                                       KI_NROSERIE, _
                                       PrId, _
                                       pGetDeplId(), _
                                       False, _
                                       csNO_ID) Then Exit Function
      End If
  End Select
  
  pColumnAfterEditItems = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case KW_ORDENES
      cIABMClientGrid_ColumnBeforeEdit = pColBEditOrdenes(pGetOrdenesProperty(), lRow, lCol, iKeyAscii)
    Case KW_ITEMS
      cIABMClientGrid_ColumnBeforeEdit = pColBEditItems(pGetItemsProperty(), lRow, lCol, iKeyAscii)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnBeforeEdit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  'nrs
  Dim Row As cIABMGridRow
  
  Select Case Key
    Case KW_ITEMS
      With pGetItems()
        Select Case .Columns(lCol).Key
          Case KI_NROSERIE
            Set Row = .Rows(lRow)
            If pCell(Row, KI_PR_LLEVANROSERIE).id Then
            
              Dim PrId  As Long
              Dim DeplId As Long
              
              DeplId = WizGetDeposito(m_ObjWizard, c_StepSelectCliente, c_Wiz_Key_Deposito)
              PrId = pCell(Row, KII_ARTICULO).id
            
              cIABMClientGrid_ColumnButtonClick = EditNroSerie(pCell(Row, KI_GRUPO).id, _
                                                               Val(pCell(Row, KII_APLICAR).Value), _
                                                               Row, _
                                                               m_NrosSerie, _
                                                               KI_GRUPO, _
                                                               KI_NROSERIE, _
                                                               lRow, _
                                                               PrId, DeplId, False, _
                                                               pCell(Row, KI_ES_KIT).id, _
                                                               GetKitInfo(PrId, m_CollKitInfo), _
                                                               csNO_ID, _
                                                               csNO_ID)

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
    Case KW_ORDENES
    Case KW_ITEMS
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
    Case KW_ORDENES
      cIABMClientGrid_ValidateRow = True
    Case KW_ITEMS
      cIABMClientGrid_ValidateRow = pValidateRow(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pValidateRow(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
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
  
  pValidateRow = True
End Function

Private Function pColBEditItems(ByRef IProperty As cIABMProperty, _
                                ByVal lRow As Long, _
                                ByVal lCol As Long, _
                                ByVal iKeyAscii As Integer) As Boolean
  Dim Row As cIABMGridRow
  
  Select Case pGetKeyFromCol(IProperty.Grid.Columns, lCol)
    Case KII_SELECT, KII_APLICAR, KII_PRECIO_SIN_IVA
    
    'nrs
    Case KI_NROSERIE
      Set Row = IProperty.Grid.Rows(lRow)
      If Not Row Is Nothing Then
        pColBEditItems = pCell(Row, KI_PR_LLEVANROSERIE).id
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
            pr_id_kit = pCell(Row, KII_ARTICULO).id
          End If
           
          With IProperty.Grid.Columns.Item(cscStlId)
            .HelpFilter = "'pr_id = " & _
                                  pCell(Row, KII_ARTICULO).id & _
                          " and " & GetStockLoteFilter( _
                                              pGetDeplId(), _
                                              m_StockConfig.StockXFisico, _
                                              pr_id_kit, _
                                              m_depf_id) & "'"
          End With
          
          Dim AbmObj As cABMGeneric
          Set AbmObj = m_ObjWizard.EditGeneric
          
          AbmObj.RefreshColumnProperties IProperty, cscStlId
          
          pColBEditItems = True
        
        Else
          Exit Function
        End If
      End If
    
    Case Else
      Exit Function
  End Select

  pColBEditItems = True
End Function

Private Function pColBEditOrdenes(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
  Select Case pGetKeyFromCol(IProperty.Grid.Columns, lCol)
    Case KI_SELECT
    Case Else
      Exit Function
  End Select
  
  pColBEditOrdenes = True
End Function

Private Function pColAUpdateOrden(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long)
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KI_SELECT
        pShowTotalOrdenes
    End Select
  End With
  
  pColAUpdateOrden = True
End Function

Private Function pColAUpdateItems(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long)
  Dim Row      As cIABMGridRow
  Dim Value    As Double
  Dim MaxVal   As Double
  
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KII_SELECT
        Set Row = .Rows(lRow)
        pSelectItem Row, .Columns
        pShowTotalItems
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
      
      Case KII_PRECIO_SIN_IVA
        Set Row = .Rows(lRow)
        SetPrecioIva Row, KII_PRECIO_SIN_IVA, KII_IVARIPercent, _
                     KII_IVARNIPercent, KII_PRECIOIVA, _
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

Private Sub pSelectAllOrdenes(ByVal bSelect As Boolean)
  Dim Row As cIABMGridRow
  
  With pGetOrdenes
    For Each Row In .Rows
      pCell(Row, KI_SELECT).id = CInt(bSelect)
    Next
  End With

  Dim ObjWiz As cWizardGeneric
  Set ObjWiz = m_ObjWizard
  
  ObjWiz.ShowValue pGetOrdenesProperty, True
End Sub

Private Sub pSelectAllItems(ByVal bSelect As Boolean)
  Dim Row As cIABMGridRow
  
  With pGetItems
    For Each Row In .Rows
      pCell(Row, KII_SELECT).id = CInt(bSelect)
      pSelectItem Row, .Columns
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


Private Sub pShowTotalOrdenes()
  Dim Row           As cIABMGridRow
  Dim Total         As Double
  
  For Each Row In pGetOrdenes().Rows
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
  m_bAutoSelect = WizObj.PushVirtualNext
  
  m_ObjWizard.EditGeneric.HideTitle = True
  cIWizardClient_Load = LoadSteps()

  Exit Function
ControlError:
  MngError Err, "cIWizardClient_Load", C_Module, vbNullString
End Function

Private Property Set cIWizardClient_ObjWizard(rhs As CSInterfacesABM.cIWizardGeneric)
  Set m_ObjWizard = rhs
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
        iProp.Name = c_selectall
        m_ObjWizard.ShowValue iProp
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
      m_LastCli = csNO_ID
      pSetDatosCliente
      
      SetDocumentoForDoctId pGetDocProperty(), _
                            m_ObjWizard, _
                            csEDocumentoTipo.csEDT_RemitoVenta, _
                            csEDocumentoTipo.csEDT_OrdenServicio, _
                            m_OsIds, _
                            0
      cIWizardClient_PropertyChange KW_DOC_ID
      
    Case c_StepSelectCliente
    
      If pGetDoc() = csNO_ID Then
        MsgWarning LNGGetText(1562, vbNullString), LNGGetText(1722, vbNullString)
                    'Debe indicar un documento, Remitos
        nNextStep = c_StepSelectCliente
      ElseIf pGetCliente() = csNO_ID Then
        MsgWarning LNGGetText(1563, vbNullString), LNGGetText(1722, vbNullString)
                    'Debe indicar un cliente, Remitos
        nNextStep = c_StepSelectCliente
      ElseIf WizGetDeposito(m_ObjWizard, c_StepSelectCliente, c_Wiz_Key_Deposito) = csNO_ID _
                                                          And m_bShowStockData Then
        MsgWarning LNGGetText(1559, vbNullString), LNGGetText(1722, vbNullString)
                    'Debe indicar un deposito, Remitos
        nNextStep = c_StepSelectCliente
      ElseIf Not pLoadOrdenesXCliente() Then
        MsgWarning LNGGetText(1734, vbNullString), LNGGetText(1722, vbNullString)
                    'No se pudieron cargar las ordenes para este Cliente, Remitos
        nNextStep = c_StepSelectCliente
      Else
        pGetTodos.Name = c_selectall
        m_ObjWizard.ShowValue pGetTodos
        m_ObjWizard.cmdBack.Enabled = True
        nNextStep = c_StepSelectOrden
      End If
      
    Case c_StepSelectOrden
      If Not pCheckOrdenes() Then
        nNextStep = c_StepSelectOrden
      ElseIf Not pLoadItemsXOrdenes() Then
        MsgWarning LNGGetText(1735, vbNullString), LNGGetText(1722, vbNullString)
                    'No se pudieron cargar los items de las ordenes para este Cliente, Remitos
        nNextStep = c_StepSelectOrden
      Else
        nNextStep = c_StepSelectItems
      End If
    
    Case c_StepSelectItems
      If Not pCheckItems() Then
        nNextStep = c_StepSelectItems
      Else
        
        m_ObjWizard.cmdBack.Enabled = True
        m_ObjWizard.cmdNext.Caption = c_WizStr_Finish
        
        nNextStep = c_StepDatosGenerales
      End If
    
    Case c_StepDatosGenerales

      If pValidateDatosGenerales() Then

        If pSave() Then
        
          If m_bAutoFactura Then
          
            pShowFactura True
          
            Dim WizObj As cWizardGeneric
            Set WizObj = m_ObjWizard
          
            If WizObj.CloseWizardAfterSave Or m_UserCfg.CloseWizard Then
            
              m_ObjWizard.CloseWizard
            
            End If
          
          Else
        
            ' PrintDoc
            '
            WizShowNewStepEx m_ObjWizard, c_StepWelcome, m_LastNroDoc, True
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
    
    Case c_StepSelectOrden
      m_ObjWizard.cmdBack.Enabled = False
      nNextStep = c_StepSelectCliente
    
    Case c_StepSelectItems
      nNextStep = c_StepSelectOrden
    
    Case c_StepDatosGenerales
      m_ObjWizard.cmdNext.Caption = c_WizStr_Next
      nNextStep = c_StepSelectItems
  End Select

  cIWizardClient_PreviousStep = True
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
                    m_LastDoc, _
                    GetEmailFromCliente(m_LastCli)
    
    Case KW_NEW_DOC
      pNewEmptyProperties
      WizNewDoc m_ObjWizard, c_StepWelcome
    
    Case KW_TODOS
      If pGetTodos.Name = c_selectall Then
        pSelectAllOrdenes True
        pGetTodos.Name = c_unselectall
      Else
        pSelectAllOrdenes False
        pGetTodos.Name = c_selectall
      End If
      m_ObjWizard.ShowValue pGetTodos
      pShowTotalOrdenes
  
    Case KW_TODOS_ITEMS
      If pGetTodosItems.Name = c_selectall Then
        pSelectAllItems True
        pGetTodosItems.Name = c_unselectall
      Else
        pSelectAllItems False
        pGetTodosItems.Name = c_selectall
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
      
    Case KW_ACTION_BUTTON_DOC
      
      If m_Id Then
        pShowFactura False
      Else
        MsgInfo LNGGetText(3955, vbNullString)
                'Esta opción solo sirve para modificar documentos guardados
      End If
      
    Case KW_ACTION_BUTTON_DOC_AUTO
      
      If m_Id Then
        pShowFactura True
      Else
        MsgInfo LNGGetText(3955, vbNullString)
                'Esta opción solo sirve para modificar documentos guardados
      End If
      
    Case KW_ACTION_BUTTON_DOC_CANCEL_AUTO
    
      If m_Id Then
        pCancelarRemito
      Else
        MsgInfo LNGGetText(3955, vbNullString)
                'Esta opción solo sirve para modificar documentos guardados
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
      
    ' Lote
    '
    Case KW_DEPL_ID
    
      pSetStock

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

Private Function cIWizardClient_Terminate() As Boolean
  cIWizardClient_Terminate = True
  'Unload m_Resource
  'Set m_Resource = Nothing
  
  ' Puede fallar y no importa
  ' ya que no conozco si el
  ' objecto cliente soporta
  ' la interfaz
  On Error Resume Next
  
  If m_bAutoSelect Then
    m_ObjClient.TerminateWizard csNO_ID
  Else
    m_ObjClient.TerminateWizard m_Id
  End If
End Function

Private Property Get cIWizardClient_Title() As String
  cIWizardClient_Title = LNGGetText(2221, vbNullString) 'Asistente de Remitos de Venta
End Property

' funciones friend
' funciones privadas
Private Function pGetDeplId() As Long
  pGetDeplId = WizGetDeposito(m_ObjWizard, c_StepSelectCliente, c_Wiz_Key_Deposito)
End Function

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
  pLoadStepSelectOrden
  pLoadStepSelectItems
  pLoadStepDatosGenerales
  WizVtaShowCotizacion m_ObjWizard, c_StepDatosGenerales, m_LastDoc, False

  LoadSteps = True
End Function

Private Sub pLoadStepWelcome()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepWelcome)).Properties
    With .Add(Nothing)
      '.Name = vbNullString
      .Top = 0
      .Left = 0
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 1
      'Set .Picture = m_Resource.ImgWiz1.Picture
    End With

    With .Add(Nothing, c_Wiz_Key_Title)
      '.Name = vbNullString
      .Top = 100
      .Left = 2700
      .TopNotChange = True
      .LeftNotChange = True
      .Height = 880
      .Width = 7000
      .PropertyType = cspTitle
      .Value = LNGGetText(1724, vbNullString)  'Bienvenido al Asistente de Remitos de Venta
    End With
    
    With .Add(Nothing, c_Wiz_Key_MainTitle)
      .Top = 1200
      .Left = 3000
      '.Name = vbNullString
      .PropertyType = cspLabel
      .Width = 6000
      .Height = 880
      .FontBold = True
      .Value = LNGGetText(1736, vbNullString)
              'Con este asistente usted podrá generar los Remitos sobre Ordenes.
    End With
                                                         
    WizAddNewDocPropertiesEx2 m_ObjWizard, c_StepWelcome, _
                             LNGGetText(3954, vbNullString), _
                             LNGGetText(3956, vbNullString), _
                             LNGGetText(4958, vbNullString) _
                             ' Facturar este remito _
                             ' Facturar este remito Automatico
                             ' Anular este remito Automatico
    
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
      .Value = LNGGetText(1726, vbNullString)
                'Indique el documento a utilizar y el cliente al que se le emitirá el remito
    End With
    
    With .Add(Nothing, c_Wiz_Key_Doc)
      .Top = 1500
      .Left = 3700
      .Name = LNGGetText(1567, vbNullString)   'Documento
      .PropertyType = cspHelp
      .HelpFilter = "'doct_id = " & csEDT_RemitoVenta & " and doc_rv_desde_os <> 0'"
      .Table = CSDocumento2.CSDocumento
      .Width = 4000
      .Value = m_Documento
      .HelpId = m_doc_id
      .Key = KW_DOC_ID
    End With
  
    With .Add(Nothing, c_Wiz_Key_Cliente)
      .Top = 2000
      .Left = 3700
      .Name = LNGGetText(1150, vbNullString)    'Cliente
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
      .Name = LNGGetText(1397, vbNullString)    'Lista de precios
      .Key = KW_LP_ID
      .HelpFilter = GetListaPrecioGetXCliente(m_doc_id, m_cli_id)
    End With
  
    'nrs
    WizSetShowStockData m_ObjWizard, c_StepSelectCliente, m_bShowStockData

    With .Add(Nothing, c_Wiz_Key_Deposito)
      .Name = LNGGetText(1574, vbNullString)    'Deposito
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
      .Name = LNGGetText(1737, vbNullString)    'Cargar solo Ordenes seleccionadas
      
      If m_UserCfg.ShowAllInWizard Then
        .Value = 0
      Else
        .Value = UBound(m_OsIds)
      End If
      .Left = 5310
      .LeftLabel = -2800
    End With
  End With
  
End Sub

Private Sub pLoadStepSelectOrden()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepSelectOrden)).Properties
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
      .Value = LNGGetText(1738, vbNullString)   'Seleccione las Ordenes
    End With
    
    With .Add(Nothing, c_Wiz_Key_Ordenes)
      .Top = 1100
      .Left = 150
      '.Name = vbNullString
      .PropertyType = cspGrid
      .LeftLabel = -1
      pLoadOrdenes .Grid
      .Width = 11500
      .Height = 4400
      .Key = KW_ORDENES
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
    End With
  
    With .Add(Nothing, c_Wiz_Key_Todos)
      .Name = c_selectall
      .Top = 5550
      .Left = 200
      .LeftLabel = -1
      .Width = 2200
      .PropertyType = cspButton
      .Key = KW_TODOS
    End With
  
    With .Add(Nothing, c_Wiz_Key_Total)
      .Name = LNGGetText(1584, vbNullString)   'Total
      .Top = 5550
      .Left = 9820
      .LeftLabel = -600
      .Width = 1800
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Format = m_GeneralConfig.FormatDecImporte
    End With
  End With
End Sub

Private Sub pLoadOrdenes(ByRef Grid As cIABMGrid)
  Dim Signo As String
  
  ' La primera simpre esta invisible
  With Grid.Columns
    
    .Add(Nothing).Visible = False
  
    With .Add(Nothing)
      '.Name = vbNullString
      .PropertyType = cspCheck
      .Width = 320
      .Key = KI_SELECT
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1223, vbNullString)   'Tipo
      .PropertyType = cspText
      .Width = 3000
      .Key = KI_DOC
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1567, vbNullString)   'Documento
      .PropertyType = cspText
      .Width = 1800
      .Key = KI_NRODOC
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1065, vbNullString)   'Número
      .PropertyType = cspNumeric
      .Width = 800
      .Key = KI_OS_ID
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1569, vbNullString)   'Fecha
      .PropertyType = cspDate
      .Width = 1040
      .Format = "dd/mm/yy"
      .Key = KI_FECHA
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1584, vbNullString)   'Total
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 920
      .Key = KI_TOTAL
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

Private Sub pLoadStepSelectItems()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepSelectItems)).Properties
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
      .Value = LNGGetText(1702, vbNullString)
              'Seleccione los items he indique las cantidades que remitirá de cada una de ellos
    End With
    
    With .Add(Nothing, c_Wiz_Key_Items)
      .Top = 1100
      .Left = 150
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
      .Name = c_selectall
      .Top = 5550
      .Left = 200
      .LeftLabel = -1
      .Width = 2200
      .PropertyType = cspButton
      .Key = KW_TODOS_ITEMS
    End With
  
    With .Add(Nothing, c_Wiz_Key_LPAplyAll)
      .Name = c_aplicarprecio
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
      .Name = c_aplicarpreciocero
      .Top = 5550
      .LeftFromProperty = c_Wiz_Key_TodosItems
      .LeftToPrevious = 4700
      .LeftLabel = -1
      .Width = 2200
      .PropertyType = cspButton
      .Key = KW_LPZERO_ITEMS
    End With
    
    With .Add(Nothing, c_Wiz_Key_TotalItems)
      .Name = LNGGetText(1584, vbNullString)   'Total
      .Top = 5550
      .Left = 9820
      .LeftLabel = -600
      .Width = 1800
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Format = m_GeneralConfig.FormatDecImporte
    End With
  End With
End Sub

Private Sub pLoadItems(ByRef Grid As cIABMGrid)
  ' La primera simpre esta invisible
  With Grid.Columns
    With .Add(Nothing)
      .Visible = False
      .Key = KII_OSI_ID
    End With
  
    With .Add(Nothing)
      '.Name = vbNullString
      .PropertyType = cspCheck
      .Width = 320
      .Key = KII_SELECT
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1567, vbNullString)   'Documento
      .PropertyType = cspText
      .Width = 1600
      .Key = KI_NRODOC
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1065, vbNullString)   'Número
      .PropertyType = cspNumeric
      .Width = 800
      .Key = KI_OS_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1367, vbNullString)   'Articulo
      .PropertyType = cspText
      .Width = 3000
      .Key = KII_ARTICULO
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1586, vbNullString)   'Precio
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 920
      .Key = KII_PRECIO_SIN_IVA
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = SecurityCanAccessSilent(csPreVtaEditPriceRem)
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1374, vbNullString)   'Cantidad
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 920
      .Key = KII_CANTIDAD
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
    
    With .Add(Nothing, c_Wiz_Key_Pendiente)
      .Name = LNGGetText(1609, vbNullString)   'Pendiente
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 920
      .Key = KII_PENDIENTE
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1662, vbNullString)   'Aplicar
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 920
      .Key = KII_APLICAR
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
    
    'nrs
    With .Add(Nothing)
      .Name = LNGGetText(1639, vbNullString)   'Nro. Serie
      .PropertyType = cspText
      .SubType = cspTextButton
      .Width = 950
      .Key = KI_NROSERIE
    End With
    
    ' Lote
    '
    With .Add(Nothing, cscStlId)
      .Name = LNGGetText(1640, vbNullString)   'Lote
      .PropertyType = cspHelp
      .Table = csStockLote
      .Width = 2000
      .Key = KI_STL_ID
    End With
    
    With .Add(Nothing, c_Wiz_Key_TotalItems)
      .Name = LNGGetText(1584, vbNullString)   'Total
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 920
      .Key = KII_TOTAL
      .Format = m_GeneralConfig.FormatDecImporte
    End With
    
    With .Add(Nothing)
      .Name = C_strDescrip
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
  
    With .Add(Nothing)
      .Visible = False
      .Key = KII_DESCUENTO
    End With
  
    With .Add(Nothing)
      .Visible = False
      .Key = KII_CCOS_ID
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
    
    'nrs
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
End Sub

Private Sub pLoadStepDatosGenerales()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepDatosGenerales)).Properties
  
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
      .Value = LNGGetText(1732, vbNullString)   'Complete los siguientes datos del remito
    End With
  
    With .Add(Nothing, c_Wiz_Key_Fecha)
      .PropertyType = cspDate
      .Left = 2800
      .Name = LNGGetText(1569, vbNullString) 'Fecha
      .Key = KW_FECHA
      .Value = Date
    End With
    
    With .Add(Nothing, c_Wiz_Key_Cliente2)
      .PropertyType = cspHelp
      .Table = csCliente
      .Enabled = False
      .Name = LNGGetText(1150, vbNullString) 'Cliente
      .Key = KW_CLIENTE2
    End With
  
    With .Add(Nothing, c_Wiz_Key_CondicionPago)
      .PropertyType = cspHelp
      .Table = csCondicionPago
      .Name = LNGGetText(1395, vbNullString) 'Condición de Pago
    End With
    
    With .Add(Nothing, c_Wiz_Key_Sucursal)
      .PropertyType = cspHelp
      .Table = csSucursal
      .Name = LNGGetText(1281, vbNullString) 'Sucursal
      .Value = User.Sucursal
      .HelpId = User.suc_id
      .Key = KW_SUCURSAL
    End With
  
    With .Add(Nothing, c_Wiz_Key_Cotizacion)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1635, vbNullString) 'Cotización
    End With
    
    'lp
    With .Add(Nothing, c_Wiz_Key_ListaPrecio2)
      .PropertyType = cspHelp
      .Table = csListaPrecio
      .Name = LNGGetText(1397, vbNullString) 'Lista de Precios
      .Enabled = False
      .Key = KW_LP_ID2
      .HelpFilter = GetListaPrecioGetXCliente(m_doc_id, m_cli_id)
    End With
  
    With .Add(Nothing, c_Wiz_Key_Vendedor)
      .PropertyType = cspHelp
      .Table = csVendedores
      .Name = LNGGetText(1510, vbNullString) 'Vendedor
      .Key = KW_VEN_ID
    End With
  
    With .Add(Nothing, c_Wiz_Key_Legajo)
      .PropertyType = cspHelp
      .Table = csLegajo
      .Name = LNGGetText(1575, vbNullString) 'Legajo
      .Key = KW_LEGAJO
    End With
    
    With .Add(Nothing, c_Wiz_Key_Comprobante)
      .PropertyType = cspText
      .Left = 6800
      .LeftLabel = -1300
      .TopFromProperty = c_Wiz_Key_Fecha
      .Name = LNGGetText(1610, vbNullString) 'Comprobante
      .Key = KW_COMPROBANTE
    End With
    
    With .Add(Nothing, c_Wiz_Key_CentroCosto)
      .PropertyType = cspHelp
      .Table = csCentroCosto
      .Name = LNGGetText(1057, vbNullString) 'Centro de Costo
      .Key = KW_CENTROCOSTO
    End With
  
    With .Add(Nothing, c_Wiz_Key_SucCliente)
      .PropertyType = cspHelp
      .Table = csSucursalCliente
      .Name = LNGGetText(1576, vbNullString) 'Sucursal del Cliente
      .HelpFilter = GetHelpFilterCliSuc(m_cli_id)
      .Key = KW_CLIS_ID
    End With
    
    With .Add(Nothing, c_Wiz_Key_Transporte)
      .PropertyType = cspHelp
      .Table = csTransporte
      .Name = LNGGetText(1050, vbNullString) 'Transporte
      .Key = KW_TRANS_ID
    End With
    
    With .Add(Nothing, c_Wiz_Key_Origen)
      .PropertyType = cspHelp
      .Table = csProvincia
      .Name = LNGGetText(1901, vbNullString) 'Origen
      .Key = KW_PRO_ID_ORIGEN
    End With
    
    With .Add(Nothing, c_Wiz_Key_Destino)
      .PropertyType = cspHelp
      .Table = csProvincia
      .Name = LNGGetText(1902, vbNullString) 'Destino
      .Key = KW_PRO_ID_DESTINO
    End With
    
    With .Add(Nothing, c_Wiz_Key_Retiro)
      .PropertyType = cspText
      .SubType = cspTextButtonEx
      .Name = LNGGetText(2883, vbNullString) 'Retirado Por
      .Key = KW_RETIRO
    End With
    
    With .Add(Nothing, c_Wiz_Key_Guia)
      .PropertyType = cspText
      .SubType = cspTextButtonEx
      .Name = LNGGetText(2884, vbNullString) 'Guia de Entrega
      .Key = KW_GUIA
    End With
    
    With .Add(Nothing, c_Wiz_Key_Observaciones)
      .PropertyType = cspText
      .Left = 2800
      .TopFromProperty = c_Wiz_Key_Guia
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
                                c_StepSelectOrden, _
                                c_Wiz_Key_Todos)
End Function

Private Function pGetTodosItems() As cIABMProperty
  Set pGetTodosItems = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectItems, _
                                      c_Wiz_Key_TodosItems)
End Function

Private Function pGetTotal() As cIABMProperty
  Set pGetTotal = GetWizProperty(m_ObjWizard, _
                                c_StepSelectOrden, _
                                c_Wiz_Key_Total)
End Function

Private Function pGetTotalItems() As cIABMProperty
  Set pGetTotalItems = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectItems, _
                                      c_Wiz_Key_TotalItems)
End Function

Private Function pGetCliente2() As cIABMProperty
  Set pGetCliente2 = GetWizProperty(m_ObjWizard, _
                                    c_StepDatosGenerales, _
                                    c_Wiz_Key_Cliente2)
End Function

Private Function pGetCliente() As Long
  pGetCliente = GetWizProperty(m_ObjWizard, _
                              c_StepSelectCliente, _
                              c_Wiz_Key_Cliente).HelpId
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

Private Function pGetGuia() As cIABMProperty
  Set pGetGuia = GetWizProperty(m_ObjWizard, _
                                c_StepDatosGenerales, _
                                c_Wiz_Key_Guia)
End Function

Private Function pGetRetiro() As cIABMProperty
  Set pGetRetiro = GetWizProperty(m_ObjWizard, _
                                  c_StepDatosGenerales, _
                                  c_Wiz_Key_Retiro)
End Function

Private Function pGetProOrigen() As cIABMProperty
  Set pGetProOrigen = GetWizProperty(m_ObjWizard, _
                                    c_StepDatosGenerales, _
                                    c_Wiz_Key_Origen)
End Function

Private Function pGetProDestino() As cIABMProperty
  Set pGetProDestino = GetWizProperty(m_ObjWizard, _
                                    c_StepDatosGenerales, _
                                    c_Wiz_Key_Destino)
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

Private Function pGetItems() As cIABMGrid
  Set pGetItems = GetWizProperty(m_ObjWizard, _
                                c_StepSelectItems, _
                                c_Wiz_Key_Items).Grid
End Function

Private Function pGetItemsProperty() As cIABMProperty
  Set pGetItemsProperty = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectItems, _
                                      c_Wiz_Key_Items)
End Function

Private Function pGetOrdenes() As cIABMGrid
  Set pGetOrdenes = GetWizProperty(m_ObjWizard, _
                                c_StepSelectOrden, _
                                c_Wiz_Key_Ordenes).Grid
End Function

Private Function pGetOrdenesProperty() As cIABMProperty
  Set pGetOrdenesProperty = GetWizProperty(m_ObjWizard, _
                                c_StepSelectOrden, _
                                c_Wiz_Key_Ordenes)
End Function

Private Sub pRefreshOrdenes()
  Dim ObjWiz As cWizardGeneric
  Set ObjWiz = m_ObjWizard
  
  ObjWiz.ShowValue GetWizProperty(m_ObjWizard, _
                                c_StepSelectOrden, _
                                c_Wiz_Key_Ordenes), True
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

Private Function pGetLegajo() As cIABMProperty
  Set pGetLegajo = GetWizProperty(m_ObjWizard, _
                                    c_StepDatosGenerales, _
                                    c_Wiz_Key_Legajo)
End Function

Private Function pGetCotizacion() As cIABMProperty
  Set pGetCotizacion = GetWizProperty(m_ObjWizard, _
                                    c_StepDatosGenerales, _
                                    c_Wiz_Key_Cotizacion)
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

Private Function pGetCondicionPago() As cIABMProperty
  Set pGetCondicionPago = GetWizProperty(m_ObjWizard, _
                                    c_StepDatosGenerales, _
                                    c_Wiz_Key_CondicionPago)
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

Private Function pCheckOrdenes() As Boolean
  Dim Row As cIABMGridRow
  For Each Row In pGetOrdenes().Rows
    If pCell(Row, KI_SELECT).id Then
      pCheckOrdenes = True
      Exit Function
    End If
  Next
  
  MsgWarning LNGGetText(1739, vbNullString)    'Debe indicar una o más órdenes.
End Function

' nrs
Private Function pCheckItems() As Boolean
  Dim Row                 As cIABMGridRow
  Dim bExistsSelected     As Boolean
  Dim i                   As Long
  
  For Each Row In pGetItems().Rows
    i = i + 1
    If Val(pCell(Row, KII_APLICAR).Value) > 0 Then
      If Not pValidateRowItems(Row, i) Then Exit Function
      bExistsSelected = True
    End If
  Next

  If Not bExistsSelected Then
    MsgWarning LNGGetText(1678, vbNullString)    'Debe indicar uno o más items.
    Exit Function
  End If
  
  If Not ValidateNroSerieCantidad(pGetItems(), _
                                  KI_PR_LLEVANROSERIE, _
                                  KII_SELECT, _
                                  m_NrosSerie, _
                                  KII_APLICAR) Then
    Exit Function
  End If
  
  pCheckItems = True
End Function

Private Function pValidateRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bLlevaNroSerie        As Boolean
  
  If pCell(Row, KII_SELECT).id Then
  
    strRow = " (Fila " & RowIndex & ")"
    
    bLlevaNroSerie = pCell(Row, KI_PR_LLEVANROSERIE).id
    If ValEmpty(pCell(Row, KI_NROSERIE).Value, csText) And bLlevaNroSerie Then
      MsgInfo LNGGetText(1630, vbNullString, strRow)
              'Debe indicar un numero de serie (1)
      Exit Function
    End If
    
    ' Lote
    '
    If ValEmpty(pCell(Row, KI_STL_ID).id, csId) And _
       pCell(Row, KI_PR_LLEVALOTE).id And _
       pCell(Row, KI_PR_LOTEFIFO).id = 0 And _
       Not bLlevaNroSerie Then
       
      MsgInfo LNGGetText(1632, vbNullString, strRow)    'Debe indicar un lote (1)
      Exit Function
    End If
  
  End If
  
  pValidateRowItems = True
End Function

Private Function pGetMonId() As Long
  Dim Doc As cDocumento
  Set Doc = New cDocumento
  
  pGetMonId = Doc.GetData(pGetDoc, cscMonId, csLong)
End Function

Private Function pGetOrdenesIds() As String
  Dim Row         As cIABMGridRow
  Dim Ids         As String
  
  For Each Row In pGetOrdenes().Rows
    If pCell(Row, KI_SELECT).id Then
      Ids = Ids & pCell(Row, KI_OS_ID).id & ","
    End If
  Next
  
  pGetOrdenesIds = RemoveLastColon(Ids)
End Function

Private Function pLoadItemsXOrdenes() As Boolean
  Dim sqlstmt           As String
  Dim rs                As Recordset
  Dim i                 As Long
  Dim bSelected         As Boolean
  
  sqlstmt = "sp_DocRemitoVentaGetOrdenItems '" & pGetOrdenesIds & "'"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  bSelected = pGetApplyItem()
  
  With pGetItems().Rows
  
    .Clear
  
    While Not rs.EOF
    
      With .Add(Nothing)
      
        ' La primera no se usa
        With .Add(Nothing)
          
          .id = gDB.ValField(rs.fields, cscOsiId)
          .Key = KII_OSI_ID
        End With
        
        With .Add(Nothing)
          .id = bSelected
          .Key = KII_SELECT
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOsNrodoc)
          .Key = KI_NRODOC
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOsNumero)
          .id = gDB.ValField(rs.fields, cscOsId)
          .Key = KI_OS_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPrNombreVenta)
          .id = gDB.ValField(rs.fields, cscPrId)
          .Key = KII_ARTICULO
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOsiPrecio & 2)
          .Key = KII_PRECIO_SIN_IVA
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOsiCantidadaremitir)
          .Key = KII_CANTIDAD
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOsiPendiente)
          .Key = KII_PENDIENTE
        End With
        
        With .Add(Nothing)
        
          If bSelected Then
            .Value = gDB.ValField(rs.fields, cscOsiPendiente)
          Else
            .Value = 0
          End If
          .Key = KII_APLICAR
        End With
        
        'nrs
        With .Add(Nothing)
          .Value = vbNullString
          .Key = KI_NROSERIE
        End With
        
        ' Lote
        '
        With .Add(Nothing)
          .Value = vbNullString
          .Key = KI_STL_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOsiImporte)
          .Key = KII_TOTAL
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOsiDescrip)
          .Key = KII_DESCRIP
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOsiPrecio)
          .Key = KII_PRECIOIVA
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOsiPrecioLista)
          .Key = KII_PRECIO_LP
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOsiPrecioUsr)
          .Key = KII_PRECIO_USR
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOsiIvariporc)
          .Key = KII_IVARIPercent
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOsiIvarniporc)
          .Key = KII_IVARNIPercent
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOsiDescuento)
          .Key = KII_DESCUENTO
        End With
        
        With .Add(Nothing)
          .id = gDB.ValField(rs.fields, cscCcosId)
          .Key = KII_CCOS_ID
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
        
        'nrs
        With .Add(Nothing)
          If m_bShowStockData Then
            .id = gDB.ValField(rs.fields, cscPrLlevaNroSerie)
          Else
            .id = False
          End If
          .Key = KI_PR_LLEVANROSERIE
        End With
        
        With .Add(Nothing)
          .id = gDB.ValField(rs.fields, cscPrEskit)
          .Key = KI_ES_KIT
        End With
        
        With .Add(Nothing)
          .id = gDB.ValField(rs.fields, cscPrnsGroupId)
          .Key = KI_GRUPO
        End With
        
      End With
      
      rs.MoveNext
    Wend
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
    If CurGroup <> gDB.ValField(rs.fields, cscPrnsGroupId) Then
    
      pSetNrosSerieInRow CurGroup, NrosSerie
      NrosSerie = vbNullString
    
      CurGroup = gDB.ValField(rs.fields, cscPrnsGroupId)
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
      .IdGroup = CurGroup
      
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
  Dim PrId  As Long
  
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
  '//////////////////////////////////////////////////
  
  ' Ahora me fijo si entre los numeros de serie hay preseleccionados
  '
  pSelectByPrnsId
  
  pRefreshItems
  pShowTotalItems
  
  pLoadItemsXOrdenes = True
End Function

Private Sub pSelectByPrnsId()
  
  Dim Coll      As Collection
  Dim NroSerie  As cProductoSerieType
  Dim CurrGroup As Long
  Dim i         As Long
  Dim Row       As cIABMGridRow
  Dim group_id  As Long
  
  For i = 1 To UBound(m_PrnsIds)

    For Each Coll In m_NrosSerie
      
      For Each NroSerie In Coll
      
        If m_PrnsIds(i) = NroSerie.prns_id Then
          
          For Each Row In pGetItems().Rows
          
            group_id = pCell(Row, KI_GRUPO).id
          
            If group_id = NroSerie.IdGroup Or _
               group_id * -1 = NroSerie.prns_id Then
                        
              pCell(Row, KII_SELECT).id = -1
              pCell(Row, KII_APLICAR).Value = pCell(Row, KII_PENDIENTE).Value
              
              If group_id * -1 = NroSerie.prns_id Then
                pCell(Row, KI_GRUPO).id = 0
              End If
              
            End If
          Next
        
          Exit For
        End If
      Next
    Next
  Next
End Sub

Private Function pSerieGetKeyForGroup(ByVal CurrGroup As Long) As Long
  Dim Row As cIABMGridRow
  Dim Idx As Long
  
  If CurrGroup = 0 Then Exit Function
  
  For Each Row In pGetItems().Rows
    Idx = Idx + 1
    If pCell(Row, KI_GRUPO).id = CurrGroup Then
      pSerieGetKeyForGroup = -Idx
      Exit Function
    End If
  Next
End Function

Private Sub pSetNrosSerieInRow(ByVal CurrGroup As Long, ByVal NroSerie As String)
  Dim Row As cIABMGridRow
  
  If CurrGroup = 0 Then Exit Sub
  
  For Each Row In pGetItems().Rows
    If pCell(Row, KI_GRUPO).id = CurrGroup Then
      pCell(Row, KI_NROSERIE).Value = RemoveLastColon(NroSerie)
      Exit Sub
    End If
  Next
End Sub

Private Function pLoadOrdenesXCliente() As Boolean
  Dim sqlstmt           As String
  Dim rs                As Recordset
  Dim os_id             As Long
  
  ' Edit From ListDoc
  '
  Dim bSelected         As Boolean
  Dim bOnlySelected     As Boolean
  
  sqlstmt = "sp_DocRemitoVentaGetOrdenes " & EmpId & "," & pGetCliente & ", " & pGetMonId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  ' Edit From ListDoc
  '
  bOnlySelected = pGetOnlySelected().Value
  
  With pGetOrdenes().Rows
  
    .Clear
  
    While Not rs.EOF
    
      ' Edit From ListDoc
      '
      os_id = gDB.ValField(rs.fields, cscOsId)
      
      bSelected = pGetApply(os_id)
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
            .Value = gDB.ValField(rs.fields, cscOsNrodoc)
            .Key = KI_NRODOC
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscOsNumero)
            .id = gDB.ValField(rs.fields, cscOsId)
            .Key = KI_OS_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscOsFecha)
            .Key = KI_FECHA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscOsTotal)
            .Key = KI_TOTAL
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscOsDescrip)
            .Key = KI_DESCRIP
          End With
        End With
      End If
      
      rs.MoveNext
    Wend
  End With
  
  pRefreshOrdenes
  pShowTotalOrdenes
  
  pLoadOrdenesXCliente = True
End Function

' Edit From ListDoc
'
Private Function pGetApply(ByVal os_id As Long) As Boolean
  Dim i As Long
  
  For i = 1 To UBound(m_OsIds)
    If m_OsIds(i) = os_id Then
      pGetApply = True
      Exit Function
    End If
  Next
End Function

Private Function pGetApplyItem() As Boolean
  
  ' Solo uso el vector si tiene algo y si me pasaron un prns_id
  '
  If UBound(m_PrnsIds) Then
  
    pGetApplyItem = False
    
  Else
  
    pGetApplyItem = m_bAutoSelect
  End If
End Function

' Validaciones de Filas
Private Function pIsEmptyRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KII_OSI_ID, KII_ARTICULO, KII_PENDIENTE
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
End Sub

Private Function pValidateDatosGenerales() As Boolean
  If ValEmpty(pGetFecha().Value, csDate) Then
    MsgWarning LNGGetText(1733, vbNullString)    'Debe indicar la fecha del remito
    Exit Function
  End If
  
  If ValEmpty(pGetSucursal().HelpId, csId) Then
    MsgWarning LNGGetText(1560, vbNullString)    'Debe indicar la sucursal
    Exit Function
  End If
  
  If ValEmpty(pGetCotizacion().Value, csDouble) And WizMustValidateCotizacion(pGetDoc()) Then
    MsgWarning LNGGetText(1626, vbNullString)    'Debe indicar la cotizacion
    Exit Function
  End If
  
  pValidateDatosGenerales = True
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(2222, vbNullString) 'Error al grabar el Remito de Venta
  
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

  Set m_GeneralConfig = Nothing
  ReDim m_OsIds(0)
  ReDim m_PrnsIds(0)
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
  Dim Mouse        As cMouseWait
  Dim bIvaRni      As Boolean
  Dim cli_id       As Long
  Dim Cliente      As String
  
  Set Mouse = New cMouseWait
    
  DoEvents: DoEvents: DoEvents: DoEvents
  
  cli_id = pGetCliente()
  Cliente = pGetClienteName()
  
  Set register = New cRegister
  
  With register
  
    .fieldId = cscRvTMPId
    .Table = csTRemitoVentaTMP
    .id = csNew
  
    ' Header
    With .fields
      
      .Add2 cscRvNumero, 0, csLong
      With pGetComprobante()
        ' PrintDoc
        '
        m_LastNroDoc = SetMask(.Value, .TextMask)
        register.fields.Add2 cscRvNrodoc, m_LastNroDoc, csText
      End With
      .Add2 cscRvDescrip, pGetDescrip().Value, csText
      .Add2 cscRvFecha, pGetFecha().Value, csDate
      .Add2 cscCliId, cli_id, csId
      .Add2 cscCcosId, pGetCentroCosto().HelpId, csId
      .Add2 cscSucId, pGetSucursal().HelpId, csId
      .Add2 cscCpgId, pGetCondicionPago().HelpId, csId
      .Add2 cscDocId, pGetDoc(), csId
      .Add2 cscLgjId, pGetLegajo().HelpId, csId
      .Add2 cscDeplId, WizGetDeposito(m_ObjWizard, c_StepSelectCliente, c_Wiz_Key_Deposito), csId
      .Add2 cscLpId, pGetListaPrecio2().HelpId, csId
      .Add2 cscVenId, pGetVendedor().HelpId, csId
      
      .Add2 cscRvCotizacion, Val(pGetCotizacion().Value), csDouble

      .Add2 cscClisId, pGetSucCliente().HelpId, csId
      .Add2 cscTransId, pGetTransporte().HelpId, csId
      .Add2 cscProIdOrigen, pGetProOrigen().HelpId, csId
      .Add2 cscProIdDestino, pGetProDestino().HelpId, csId
      
      .Add2 cscRvRetiro, pGetRetiro().Value, csText
      .Add2 cscRvGuia, pGetGuia().Value, csText
      
      .Add2 cscEstId, CSGeneralEx2.csEEstado.csEEst_Pendiente, csId
      .Add2 cscRvId, csNew, csLong
      
      bIvaRni = IsRNI(pGetCliente)
      pGetFooter Neto, IvaRi, IvaRni, bIvaRni
    
      ' Footer
      .Add2 cscRvSubtotal, Neto, csCurrency
      .Add2 cscRvNeto, Neto, csCurrency
      .Add2 cscRvIvari, IvaRi, csCurrency
      .Add2 cscRvIvarni, IvaRni, csCurrency
      .Add2 cscRvTotal, Neto + IvaRi + IvaRni, csCurrency  ' Por ahora no hay descuentos
      
      .HaveLastUpdate = True
      .HaveWhoModify = True
    
    End With
    
    If Not .BeginTrans(gDB) Then Exit Function
    
    If Not gDB.Save(register, , "pSave", C_Module, c_ErrorSave) Then Exit Function
    
    If Not pSaveItems(.id, bIvaRni) Then Exit Function
    If Not pSaveVinculacion(.id) Then Exit Function
    
    If Not .CommitTrans() Then Exit Function
  
  End With
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocRemitoVentaSave " & register.id
  
  If Not gDB.SaveSp(sqlstmt, rs, DocGetTimeOut(m_NrosSerie), _
                "pSave", C_Module, c_ErrorSave) Then Exit Function
    
  If rs.EOF Then Exit Function
  
  Dim id As Long
  If Not GetDocIDFromRecordset(rs, id) Then Exit Function
  
  m_Id = id
  m_cli_id = cli_id
  m_cliente = Cliente
  pSave = m_Id <> 0
End Function

Private Function pSaveItems(ByVal id As Long, ByVal bIvaRni As Boolean) As Boolean
  
  'Generales
  '
  Dim register  As cRegister
  Dim iOrden    As Long
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  Dim Precio    As Double
  Dim IvaRi     As Double
  Dim IvaRni    As Double
  Dim Neto      As Double
  Dim Cantidad  As Double
  
  'nrs
  ' Para numeros de serie
  '
  Dim iOrden2     As Long
  Dim iOrden3     As Long
  Dim PrId        As Long
  
  For Each Row In pGetItems().Rows
  
    If Val(pCell(Row, KII_APLICAR).Value) Then
      Set register = New cRegister
      
      With register
        
        .fieldId = cscRviTMPId
        .Table = csTRemitoVentaItemTMP
        .id = csNew
      
        With .fields
        
          For Each Cell In Row
            Select Case Cell.Key
              Case KII_APLICAR
                Cantidad = Cell.Value
                .Add2 cscRviCantidad, Cell.Value, csDouble
              Case KII_DESCRIP
                .Add2 cscRviDescrip, Cell.Value, csText
              Case KII_PRECIO_SIN_IVA
                Precio = Cell.Value
                .Add2 cscRviPrecio, Precio, csCurrency
              Case KII_PRECIO_LP
                .Add2 cscRviPrecioLista, Cell.Value, csCurrency
              Case KII_PRECIO_USR
                .Add2 cscRviPrecioUsr, Cell.Value, csCurrency
              Case KII_DESCUENTO
                .Add2 cscRviDescuento, Cell.Value, csText
              Case KII_IVARIPercent
                IvaRi = Cell.Value
                .Add2 cscRviIvariporc, IvaRi, csDouble
              Case KII_IVARNIPercent
                If bIvaRni Then
                  IvaRni = Cell.Value
                End If
                .Add2 cscRviIvarniporc, IvaRni, csDouble
              Case KII_ARTICULO
                'nrs
                PrId = Cell.id
                .Add2 cscPrId, Cell.id, csId
              Case KII_CCOS_ID
                .Add2 cscCcosId, Cell.id, csId
              ' Lote
              '
              Case KI_STL_ID
                .Add2 cscStlId, Cell.id, csId
              
              Case KI_GRUPO
                iOrden3 = Cell.id
            End Select
          Next
          
          Neto = Precio * Cantidad
          .Add2 cscRviNeto, Neto, csCurrency
          
          IvaRi = Neto * IvaRi / 100
          .Add2 cscRviIvari, IvaRi, csCurrency
          
          IvaRni = Neto * IvaRni / 100
          .Add2 cscRviIvarni, IvaRni, csCurrency
          .Add2 cscRviImporte, Neto + IvaRi + IvaRni, csCurrency
          
          ' Esto es muy importante ya que se usa para vincular el ordenservicioitem
          ' con el nuevo remitoventaitem
          iOrden = iOrden + 1
          .Add2 cscRviOrden, iOrden, csInteger
          
          .Add2 cscRvTMPId, id, csId
          .Add2 cscRviId, id, csLong
          
          .HaveLastUpdate = False
          .HaveWhoModify = False
        
        End With
        
        If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
      
        'nrs
        If Not pSaveItemNroSerie(Row, iOrden2, PrId, id, .id, iOrden3) Then Exit Function
      
      End With
    End If
  Next
  
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
      
      .fieldId = cscOsRvTMPid
      .Table = csTOrdenRemitoVentaTMP
      .id = csNew
    
      bSave = False
      
      With .fields
      
        For Each Cell In Row
          If pCell(Row, KII_SELECT).id Then
            bSave = True
            Select Case Cell.Key
              Case KII_OSI_ID
                .Add2 cscOsiId, Cell.id, csId
              Case KII_APLICAR
                .Add2 cscOsRvCantidad, Cell.Value, csDouble
            End Select
          End If
        Next
        
        If bSave Then
          
          .Add2 cscOsRvId, 0, csLong
          .Add2 cscRvTMPId, id, csId
          
          ' Esto es muy importante ya que se usa para vincular el ordenservicioitem
          ' con el nuevo remitoventaitem
          iOrden = iOrden + 1
          .Add2 cscRviId, iOrden, csLong
          
          .HaveLastUpdate = False
          .HaveWhoModify = False
          
          If Not gDB.Save(register, , "pSaveVinculacion", C_Module, c_ErrorSave) Then Exit Function
        End If
        
      End With
    End With
  Next
  
  pSaveVinculacion = True
End Function

Private Sub pGetFooter(ByRef Neto As Double, ByRef IvaRi As Double, ByRef IvaRni As Double, ByVal bIvaRni As Boolean)
  Dim Row           As cIABMGridRow
  Dim Cell          As cIABMGridCellValue
  Dim Precio        As Double
  Dim Cantidad      As Double
  Dim IvaRniPercent As Double
  Dim IvaRiPercent  As Double
  
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
        End Select
      Next
      
      Neto = Neto + (Precio * Cantidad)
      IvaRi = IvaRi + ((Precio * Cantidad) * IvaRiPercent / 100)
      IvaRni = IvaRni + ((Precio * Cantidad) * IvaRniPercent / 100)
    End If
  Next
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

'nrs
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
  If pCell(Row, KI_PR_LLEVANROSERIE).id Then
  
    ' Obtengo los numeros de serie y guardo un Item por cada uno
    '
    For Each pt In m_NrosSerie.Item(GetKey(Grupo))
      
      If Not pt.deleted Then
      
        Set register = New cRegister
        
        With register
          
          .fieldId = cscRvisTMPId
          .Table = csTRemitoVentaItemSerieTMP
          .id = csNew
        
          With .fields
            
            .Add2 cscPrId, PrId, csId
        
            .Add2 cscPrnsId, pt.prns_id, csId
            
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
        
        If Not gDB.Save(register, , "pSaveItemNroSerie", C_Module, c_ErrorSave) Then Exit Function
        
      End If
    Next
  End If
  
  pSaveItemNroSerie = True
End Function

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
  
  With pGetClienteProp()
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
    
    Set iProp = pGetCondicionPago()
    iProp.Value = cpg_nombre
    iProp.HelpId = cpg_id
    m_ObjWizard.ShowValue iProp
  End If
  
  ' Lista de precios
  Set iProp = pGetListaPrecio()
  iProp.HelpFilter = GetListaPrecioGetXCliente(m_LastDoc, m_LastCli)
  
  If lp_id <> csNO_ID Then
    Set LP = New cListaPrecio
    iProp.Value = LP.GetData(lp_id, cscLpNombre, csText)
    iProp.HelpId = lp_id
  End If
  
  m_ObjWizard.ShowValue iProp
  
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
  
End Sub

Private Sub pGetIvaFromCliente(ByVal cli_id As Long)
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  
  sqlstmt = "sp_ClienteGetIva " & cli_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  m_bIva = gDB.ValField(rs.fields, "bIva")
  m_bIvaRni = gDB.ValField(rs.fields, "bIvaRni")
End Sub

Private Function pGetClienteProp() As cIABMProperty
  Set pGetClienteProp = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectCliente, _
                                      c_Wiz_Key_Cliente)
End Function

Private Sub pNewEmptyProperties()
  ' (ByRef Grid As cIABMGrid)
  
  pGetOrdenes().Rows.Clear
  pGetItems().Rows.Clear
  
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
  With pGetLegajo()
    .HelpId = csNO_ID
    .Value = vbNullString
  End With
  With pGetVendedor()
    .HelpId = csNO_ID
    .Value = vbNullString
  End With
  With pGetRetiro()
    .Value = vbNullString
  End With
  With pGetGuia()
    .Value = vbNullString
  End With
  
  pGetDescrip().Value = vbNullString
  
  With m_ObjWizard
    .ShowValue pGetOrdenesProperty()
    .ShowValue pGetItemsProperty()
    .ShowValue pGetComprobante()
    .ShowValue pGetCentroCosto()
    .ShowValue pGetCondicionPago()
    .ShowValue pGetProOrigen()
    .ShowValue pGetProDestino()
    .ShowValue pGetTransporte()
    .ShowValue pGetSucCliente()
    .ShowValue pGetLegajo()
    .ShowValue pGetVendedor()
    .ShowValue pGetListaPrecio()
    .ShowValue pGetRetiro()
    .ShowValue pGetGuia()
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

Private Sub pShowFactura(ByVal bPushVirtualNext As Boolean)
  On Error GoTo ControlError

  Dim o As CSVenta2.cFacturaVenta
  Set o = New CSVenta2.cFacturaVenta
  o.PushVirtualNext = bPushVirtualNext
  o.AutoPago = m_bAutoPago
  o.ModoVentaCtaCte = m_ModoVentaCtaCte
  o.cue_id_autoPago = m_cue_id_autoPago
  o.ShowFacturaRemito m_cli_id, pGetRvIds()
  
  ' Finish, now close wizard
  m_ObjWizard.CloseWizard

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
  End If
  
End Sub
