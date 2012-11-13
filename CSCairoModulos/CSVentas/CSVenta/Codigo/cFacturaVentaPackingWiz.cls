VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFacturaVentaPackingWiz"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIWizardClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cFacturaVentaPackingWiz
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
Private Const C_Module = "cFacturaVentaPackingWiz"

Private Const c_StepWelcome             As Integer = 1
Private Const c_StepSelectCliente       As Integer = 3
Private Const c_StepSelectPacking       As Integer = 4
Private Const c_StepSelectItems         As Integer = 6
Private Const c_StepPercepciones        As Integer = 7
Private Const c_StepDatosGenerales      As Integer = 8

' Paso 2
Private Const KW_PACKINGLIST                 As Integer = 10
Private Const KW_TODOS                       As Integer = 110

' Paso 3
Private Const KW_ITEMS                       As Integer = 120
Private Const KW_TODOS_ITEMS                 As Integer = 130

' Paso 4
Private Const KW_PERCEPCIONES                   As Integer = 150
Private Const KW_TOTAPERCEPCIONES               As Integer = 160

' Paso 5
Private Const KW_LPALL_ITEMS                 As Integer = 131
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
Private Const KW_LP_ID2                      As Integer = 305
Private Const KW_LD_ID                       As Integer = 310
Private Const KW_DOC_ID                      As Integer = 320
Private Const KW_CLI_ID                      As Integer = 340

Private Const KW_COTIZACION                  As Integer = 350
Private Const KW_VEN_ID                      As Integer = 360

Private Const KW_PRO_ID_ORIGEN               As Integer = 390
Private Const KW_PRO_ID_DESTINO              As Integer = 400
Private Const KW_TRANS_ID                    As Integer = 410
Private Const KW_CLIS_ID                     As Integer = 420

Private Const KW_ORDENCOMPRA                 As Integer = 670

Private Const KI_PKLST_ID                    As Integer = 1
Private Const KI_SELECT                      As Integer = 2
Private Const KI_DOC                         As Integer = 3
Private Const KI_NRODOC                      As Integer = 4
Private Const KI_FECHA                       As Integer = 5
Private Const KI_DESCRIP                     As Integer = 8
Private Const KI_TOTAL                       As Integer = 10

' TO
Private Const KII_TO_ID                      As Integer = 400

Private Const KW_DEPL_ID                     As Integer = 500

Private Const KII_SELECT                 As Integer = 1
Private Const KII_PKLSTI_ID              As Integer = 2
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
Private m_Cliente           As String
Private m_doc_id            As Long
Private m_Documento         As String
Private m_PklstIds()        As Long

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

' PrintDoc
'
Private m_LastNroDoc        As String

'nrs
Private m_NrosSerie         As Collection
Private m_CollKitInfo       As Collection

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

' Percepciones
'
Private m_doc_sin_perc      As Boolean
Private m_vPercepciones()   As T_Percepcion

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
  m_Cliente = rhs
End Property

Public Property Let PklstIds(ByRef rhs() As Long)
  On Error Resume Next
  Dim i As Long
  ReDim m_PklstIds(UBound(rhs))
  For i = 0 To UBound(rhs)
    m_PklstIds(i) = rhs(i)
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

' Implementacion de cIABMClientGrid
Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case KW_PACKINGLIST
      cIABMClientGrid_IsEmptyRow = False
    Case KW_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowItems(row, RowIndex)
    Case KW_PERCEPCIONES
      cIABMClientGrid_IsEmptyRow = IsEmptyRowPercepciones(row, RowIndex)
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
    Case KW_PACKINGLIST
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdatePacking(pGetPackingProperty(), lRow, lCol)
    Case KW_ITEMS
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateItems(pGetItemsProperty(), lRow, lCol)
    Case KW_PERCEPCIONES
      PercepcionShowTotales pGetPercepciones.Rows, pGetTotalPercepciones
      m_ObjWizard.ShowValue pGetTotalPercepciones
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
    Case KW_PACKINGLIST
      cIABMClientGrid_ColumnAfterEdit = True
    Case KW_ITEMS
      cIABMClientGrid_ColumnAfterEdit = True
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
    Case KW_PACKINGLIST
      cIABMClientGrid_ColumnBeforeEdit = pColBEditPacking(pGetPackingProperty(), lRow, lCol, iKeyAscii)
    Case KW_ITEMS
      cIABMClientGrid_ColumnBeforeEdit = pColBEditItems(pGetItemsProperty(), lRow, lCol, iKeyAscii)
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
  'nrs
  Dim row As cIABMGridRow
  
  Select Case Key
    Case KW_ITEMS
      With pGetItems()
        Select Case .Columns(lCol).Key
          Case KI_NROSERIE
            Set row = .Rows(lRow)
            If pCell(row, KI_PR_LLEVANROSERIE).id Then
            
              Dim PrId   As Long
              Dim DeplId As Long
              
              PrId = pCell(row, KII_ARTICULO).id
              DeplId = WizGetDeposito(m_ObjWizard, c_StepSelectCliente, c_Wiz_Key_Deposito)
            
              cIABMClientGrid_ColumnButtonClick = EditNroSerie(pCell(row, KI_GRUPO).id, _
                                                               Val(pCell(row, KII_APLICAR).Value), _
                                                               row, _
                                                               m_NrosSerie, _
                                                               KI_GRUPO, _
                                                               KI_NROSERIE, _
                                                               lRow, _
                                                               PrId, DeplId, False, _
                                                               pCell(row, KI_ES_KIT).id, _
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

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim id As Long
  
  Select Case Key
    Case KW_PACKINGLIST
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
          PercepcionShowTotales pGetPercepciones.Rows, pGetTotalPercepciones
          m_ObjWizard.ShowValue pGetTotalPercepciones
      
      End Select
    
  End Select

End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)
  
End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case KW_PACKINGLIST
      cIABMClientGrid_ValidateRow = True
    Case KW_ITEMS
      cIABMClientGrid_ValidateRow = pValidateRowItems(row, RowIndex)
    Case KW_PERCEPCIONES
      cIABMClientGrid_ValidateRow = ValidateRowPercepciones(row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pColBEditPacking(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
  Select Case pGetKeyFromCol(IProperty.Grid.Columns, lCol)
    Case KI_SELECT
    Case Else
      Exit Function
  End Select
  
  pColBEditPacking = True
End Function

Private Function pColBEditItems(ByRef IProperty As cIABMProperty, _
                                ByVal lRow As Long, _
                                ByVal lCol As Long, _
                                ByVal iKeyAscii As Integer) As Boolean
  Dim row As cIABMGridRow
                                
  Select Case pGetKeyFromCol(IProperty.Grid.Columns, lCol)
    Case KII_SELECT, KII_APLICAR, KII_PRECIO_SIN_IVA, KII_TO_ID ' TO
    
    'nrs
    Case KI_NROSERIE
      Set row = IProperty.Grid.Rows(lRow)
      If Not row Is Nothing Then
        pColBEditItems = pCell(row, KI_PR_LLEVANROSERIE).id
      End If
    
    ' Lote
    '
    Case KI_STL_ID
      Set row = IProperty.Grid.Rows(lRow)
      
      If Not row Is Nothing Then
      
        If pCell(row, KI_PR_LLEVALOTE).id And _
           pCell(row, KI_PR_LLEVANROSERIE).id = 0 Then
           
          Dim pr_id_kit As Long
          If pCell(row, KI_ES_KIT).id Then
            pr_id_kit = pCell(row, KII_ARTICULO).id
          End If
           
          With IProperty.Grid.Columns.Item(cscStlId)
            .HelpFilter = "'pr_id = " & _
                                  pCell(row, KII_ARTICULO).id & _
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

Private Function pColAUpdatePacking(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long)
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KI_SELECT
        pShowTotalPacking
    End Select
  End With
  
  pColAUpdatePacking = True
End Function

Private Function pColAUpdateItems(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long)
  Dim row      As cIABMGridRow
  Dim Value    As Double
  Dim MaxVal   As Double
  
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      
      Case KII_SELECT
        Set row = .Rows(lRow)
        pSelectItem row, .Columns
        pShowTotalItems
        SetTotal row, KII_TOTAL, KII_APLICAR, KII_PRECIOIVA
        
      Case KII_APLICAR
        Set row = .Rows(lRow)
        With pCell(row, KII_APLICAR)
          MaxVal = Val(pCell(row, KII_PENDIENTE).Value)
          If Val(.Value) > MaxVal Then
            .Value = MaxVal
          ElseIf Val(.Value) < 0 Then
            .Value = 0
          End If
        End With
        pShowTotalItems
        SetTotal row, KII_TOTAL, KII_APLICAR, KII_PRECIOIVA
        
      Case KII_PRECIO_SIN_IVA
        Set row = .Rows(lRow)
        SetPrecioIva row, KII_PRECIO_SIN_IVA, KII_IVARIPercent, _
                     KII_IVARNIPercent, KII_PRECIOIVA, _
                     m_bIva, m_bIvaRni
        pShowTotalItems
        SetTotal row, KII_TOTAL, KII_APLICAR, KII_PRECIOIVA
        
      Case Else
        pColAUpdateItems = True
        Exit Function
    End Select
  End With
  
  pColAUpdateItems = True
End Function

Private Sub pSelectAllPacking(ByVal bSelect As Boolean)
  Dim row As cIABMGridRow
  
  With pGetPacking
    For Each row In .Rows
      pCell(row, KI_SELECT).id = CInt(bSelect)
    Next
  End With
  
  Dim ObjWiz As cWizardGeneric
  Set ObjWiz = m_ObjWizard
  
  ObjWiz.ShowValue pGetPackingProperty, True
End Sub

Private Sub pSelectAllItems(ByVal bSelect As Boolean)
  Dim row As cIABMGridRow
  
  With pGetItems
    For Each row In .Rows
      pCell(row, KII_SELECT).id = CInt(bSelect)
      pSelectItem row, .Columns
      SetTotal row, KII_TOTAL, KII_APLICAR, KII_PRECIOIVA
    Next
  End With
  
  Dim ObjWiz As cWizardGeneric
  Set ObjWiz = m_ObjWizard
  
  ObjWiz.ShowValue pGetItemsProperty, True
End Sub

Private Sub pSelectItem(ByRef row As cIABMGridRow, ByRef Columns As cIABMGridColumns)
  With pCell(row, KII_APLICAR)
    If pCell(row, KII_SELECT).id Then
      If Val(.Value) = 0 Then
        .Value = pCell(row, KII_PENDIENTE).Value
      End If
    Else
      .Value = 0
    End If
  End With
End Sub

Private Sub pShowTotalPacking()
  Dim row           As cIABMGridRow
  Dim Total         As Double
  
  For Each row In pGetPacking().Rows
    If pCell(row, KI_SELECT).id Then
      Total = Total + Val(pCell(row, KI_TOTAL).Value)
    End If
  Next
  
  pGetTotal().Value = Total
  
  m_ObjWizard.ShowValue pGetTotal
End Sub

Private Sub pShowTotalItems()
  Dim row           As cIABMGridRow
  Dim Total         As Double
  
  For Each row In pGetItems().Rows
    Total = Total + Val(pCell(row, KII_APLICAR).Value) * Val(pCell(row, KII_PRECIOIVA).Value)
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
        iProp.Name = c_selectall
        m_ObjWizard.ShowValue iProp
      End If
    
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
                            csEDocumentoTipo.csEDT_PackingList, _
                            m_PklstIds, _
                            0
      cIWizardClient_PropertyChange KW_DOC_ID
    
    Case c_StepSelectCliente
    
      If pGetDoc() = csNO_ID Then
        'MsgWarning "Debe indicar un documento", "Facturas"
        MsgWarning LNGGetText(1562, vbNullString), LNGGetText(1607, vbNullString)
        nNextStep = c_StepSelectCliente
      ElseIf pGetCliente() = csNO_ID Then
        MsgWarning LNGGetText(1563, vbNullString), LNGGetText(1607, vbNullString)
        'MsgWarning "Debe indicar un cliente", "Facturas"
        nNextStep = c_StepSelectCliente
      ElseIf WizGetDeposito(m_ObjWizard, c_StepSelectCliente, c_Wiz_Key_Deposito) = csNO_ID _
                                                          And m_bShowStockData Then
        'MsgWarning "Debe indicar un Depósito, Packing Lists
        MsgWarning LNGGetText(1559, vbNullString), LNGGetText(1670, vbNullString)
        nNextStep = c_StepSelectCliente
      ElseIf Not pLoadPackingXCliente() Then
        'MsgWarning "No se pudieron cargar los Packing List para este Cliente", "Facturas"
        MsgWarning LNGGetText(1671, vbNullString), LNGGetText(1607, vbNullString)
        nNextStep = c_StepSelectCliente
      Else
        pGetTodos.Name = c_selectall
        m_ObjWizard.ShowValue pGetTodos
        m_ObjWizard.cmdBack.Enabled = True
        nNextStep = c_StepSelectPacking
      End If
      
    Case c_StepSelectPacking
      If Not pChecPackingList() Then
        nNextStep = c_StepSelectPacking
      ElseIf Not pLoadItemsXPacking() Then
        'MsgWarning "No se pudieron cargar los items de los Packing List para este Cliente", "Facturas"
        MsgWarning LNGGetText(1672, vbNullString), LNGGetText(1607, vbNullString)
        nNextStep = c_StepSelectPacking
      Else
        nNextStep = c_StepSelectItems
      End If
    
    Case c_StepSelectItems
      If Not pCheckItems() Then
        nNextStep = c_StepSelectItems
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

    Case c_StepSelectCliente
      nNextStep = c_StepSelectCliente
    
    Case c_StepSelectPacking
      m_ObjWizard.cmdBack.Enabled = False
      nNextStep = c_StepSelectCliente
    
    Case c_StepSelectItems
      nNextStep = c_StepSelectPacking
    
    Case c_StepPercepciones
      nNextStep = c_StepSelectItems
    
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
                    m_LastDoc, _
                    GetEmailFromCliente(m_LastCli)
    
    Case KW_NEW_DOC
      pNewEmptyProperties
      WizNewDoc m_ObjWizard, c_StepWelcome
    
    Case KW_TODOS
      If pGetTodos.Name = c_selectall Then
        pSelectAllPacking True
        pGetTodos.Name = c_unselectall
      Else
        pSelectAllPacking False
        pGetTodos.Name = c_selectall
      End If
      m_ObjWizard.ShowValue pGetTodos
      pShowTotalPacking
  
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
      m_LastDoc = pGetDoc()
      WizSetShowStockData m_ObjWizard, c_StepSelectCliente, m_bShowStockData
      Set iProp = WizGetDepositoProp(m_ObjWizard, _
                         c_StepSelectCliente, _
                         c_Wiz_Key_Deposito)
      iProp.Enabled = m_bShowStockData
      m_ObjWizard.ShowValue iProp
      
      pSetListaPrecio
      
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
      pSetDatosCliente
      
    Case KW_LP_ID
      pSetLpId2
      
    Case KW_LPALL_ITEMS
      pSetPrecios True
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
      
    ' Lote
    '
    Case KW_DEPL_ID
    
      pSetStock

  End Select
End Function

Private Sub pSetPrecios(ByVal bAll As Boolean)
  Dim row As cIABMGridRow
  
  For Each row In pGetItems.Rows
    If Val(pCell(row, KII_PRECIO_LP).Value) = 0 Or bAll Then
    
      SetPrecio row, pCell(row, KII_ARTICULO).id, pGetListaPrecio, _
                KII_PRECIO_LP, KII_PRECIO_USR
                
      pCell(row, KII_PRECIO_SIN_IVA).Value = pCell(row, KII_PRECIO_LP).Value
      
      SetPrecioIva row, KII_PRECIO_SIN_IVA, KII_IVARIPercent, _
                   KII_IVARNIPercent, KII_PRECIOIVA, _
                   m_bIva, m_bIvaRni
      
      SetTotal row, KII_TOTAL, KII_APLICAR, KII_PRECIOIVA
    End If
  Next
  
  Dim ObjWiz As cWizardGeneric
  Set ObjWiz = m_ObjWizard
  
  ObjWiz.ShowValue pGetItemsProperty, True
End Sub

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
  m_ObjClient.TerminateWizard m_Id
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
  pLoadStepSelectPacking
  pLoadStepSelectItems
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
      .Value = LNGGetText(1653, vbNullString)   'Bienvenido al Asistente de Facturas de Venta
    End With
    
    With .Add(Nothing, c_Wiz_Key_MainTitle)
      .Top = 1200
      .Left = 3000
      '.Name = vbNullString
      .PropertyType = cspLabel
      .Width = 6000
      .Height = 880
      .FontBold = True
      .Value = LNGGetText(1673, vbNullString)
              'Con este asistente usted podrá generar las Facturas sobre Packing List.
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
      .Value = LNGGetText(1655, vbNullString)
                'Indique el documento a utilizar y el cliente al que se le emitirá la factura
    End With
    
    With .Add(Nothing, c_Wiz_Key_Doc)
      .Top = 1500
      .Left = 3700
      .Name = LNGGetText(1567, vbNullString)    'Documento
      .PropertyType = cspHelp
      .HelpFilter = "'doct_id = " & csEDT_FacturaVenta & " and " & cscDocTipoFactura & " = " & csETFacPackingList & "'"
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
      .Value = m_Cliente
      .HelpId = m_cli_id
      .Key = KW_CLI_ID
    End With
  
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
      .Name = LNGGetText(1674, vbNullString)  'Cargar sólo Packing List seleccionados
      
      If m_UserCfg.ShowAllInWizard Then
        .Value = 0
      Else
        .Value = UBound(m_PklstIds)
      End If
      .Left = 5310
      .LeftLabel = -2800
    End With
  End With
End Sub

Private Sub pLoadStepSelectPacking()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepSelectPacking)).Properties
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
      .Value = LNGGetText(1675, vbNullString)  'Seleccione los Packing List
    End With
    
    With .Add(Nothing, c_Wiz_Key_PackingList)
      .Top = 1100
      .Left = 150
      '.Name = vbNullString
      .PropertyType = cspGrid
      .LeftLabel = -1
      pLoadPackingList .Grid
      .Width = 11500
      .Height = 4400
      .Key = KW_PACKINGLIST
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
      .Name = LNGGetText(1584, vbNullString)  'Total
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

Private Sub pLoadPackingList(ByRef Grid As cIABMGrid)
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
      .Name = LNGGetText(1223, vbNullString)  'Tipo
      .PropertyType = cspText
      .Width = 3000
      .Key = KI_DOC
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1567, vbNullString)  'Documento
      .PropertyType = cspText
      .Width = 1800
      .Key = KI_NRODOC
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1065, vbNullString)  'Número
      .PropertyType = cspNumeric
      .Width = 800
      .Key = KI_PKLST_ID
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1569, vbNullString)  'Fecha
      .PropertyType = cspDate
      .Width = 1040
      .Format = "dd/mm/yy"
      .Key = KI_FECHA
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1584, vbNullString)  'Total
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
      .Value = LNGGetText(1676, vbNullString)
              'Seleccione los items he indique las cantidades que facturará de cada una de ellos
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
      .Name = LNGGetText(1584, vbNullString)  'Total
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
  With Grid.Columns
    
    ' La primera simpre esta invisible
    With .Add(Nothing)
      .Visible = False
      .Key = KII_PKLSTI_ID
    End With
    
    With .Add(Nothing)
      '.Name = vbNullString
      .PropertyType = cspCheck
      .Width = 320
      .Key = KII_SELECT
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1567, vbNullString)  'Documento
      .PropertyType = cspText
      .Width = 1600
      .Key = KI_NRODOC
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1065, vbNullString)  'Número
      .PropertyType = cspNumeric
      .Width = 800
      .Key = KI_PKLST_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1367, vbNullString)  'Articulo
      .PropertyType = cspText
      .Width = 3000
      .Key = KII_ARTICULO
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1586, vbNullString)  'Precio
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 920
      .Key = KII_PRECIO_SIN_IVA
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = SecurityCanAccessSilent(csPreVtaEditPriceFac)
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1374, vbNullString)  'Cantidad
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 920
      .Key = KII_CANTIDAD
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
    
    With .Add(Nothing, c_Wiz_Key_Pendiente)
      .Name = LNGGetText(1609, vbNullString)  'Pendiente
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 920
      .Key = KII_PENDIENTE
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1662, vbNullString)  'Aplicar
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 920
      .Key = KII_APLICAR
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
    
    'nrs
    With .Add(Nothing)
      .Name = LNGGetText(1639, vbNullString)  'Nro. Serie
      .PropertyType = cspText
      .SubType = cspTextButton
      .Width = 950
      .Key = KI_NROSERIE
    End With
    
    ' Lote
    '
    With .Add(Nothing, cscStlId)
      .Name = LNGGetText(1640, vbNullString)  'Lote
      .PropertyType = cspHelp
      .Table = csStockLote
      .Width = 2000
      .Key = KI_STL_ID
    End With
    
    With .Add(Nothing, c_Wiz_Key_TotalItems)
      .Name = LNGGetText(1584, vbNullString)  'Total
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 920
      .Key = KII_TOTAL
      .Format = m_GeneralConfig.FormatDecImporte
    End With
    
    ' TO
    With .Add(Nothing)
      .Name = LNGGetText(1661, vbNullString)  'Tipo Operación
      .PropertyType = cspHelp
      .Table = csTipoOperacion
      .Width = 1800
      .Key = KII_TO_ID
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

Private Sub pLoadStepPercepciones()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepPercepciones)).Properties
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
      .Value = LNGGetText(1915, vbNullString)  'Indique las percepciones si corresponde
    End With
    
    With .Add(Nothing, c_Wiz_Key_percepciones)
      .Top = 1100
      .Left = 150
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
      .Name = LNGGetText(1584, vbNullString)  'Total
      .Top = 5660
      .Left = 9820
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
      .Value = LNGGetText(1663, vbNullString)  'Complete los siguientes datos de la factura
    End With
  
    With .Add(Nothing, c_Wiz_Key_Fecha)
      .PropertyType = cspDate
      .Left = 2800
      .Name = LNGGetText(1569, vbNullString) 'Fecha
      .Key = KW_FECHA
      .Value = Date
    End With
    
    With .Add(Nothing, c_Wiz_Key_FechaIva)
      .PropertyType = cspDate
      .Name = LNGGetText(1638, vbNullString)  'Fecha IVA
      .Key = KW_FECHAIVA
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
      .Key = KW_CONDICION_PAGO
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
      .Key = KW_COTIZACION
    End With
    
    With .Add(Nothing, c_Wiz_Key_ListaPrecio2)
      .PropertyType = cspHelp
      .Table = csListaPrecio
      .Name = LNGGetText(1397, vbNullString) 'Lista de Precios
      .Enabled = False
      .Key = KW_LP_ID2
      .HelpFilter = GetListaPrecioGetXCliente(m_doc_id, m_cli_id)
    End With
  
    With .Add(Nothing, c_Wiz_Key_ListaDescuento)
      .PropertyType = cspHelp
      .Table = csListaDescuento
      .Name = LNGGetText(1398, vbNullString) 'Lista de Descuentos
      .Key = KW_LD_ID
      .HelpFilter = GetListaDescGetXCliente(m_doc_id, m_cli_id)
    End With
  
    With .Add(Nothing, c_Wiz_Key_OrdenCompra)
      .PropertyType = cspText
      .Name = LNGGetText(1924, vbNullString) 'Orden de Compra
      .Key = KW_ORDENCOMPRA
    End With
    
    With .Add(Nothing, c_Wiz_Key_Desc1)
      .TopFromProperty = c_Wiz_Key_Fecha
      .PropertyType = cspNumeric
      .Left = 5500
      .LeftLabel = -1000
      .SubType = cspPercent
      .Width = 1000
      .Name = LNGGetText(1664, vbNullString) 'Descuento 1
      .Key = KW_DESCUENTO1
    End With
    
    With .Add(Nothing, c_Wiz_Key_Desc2)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .LeftLabel = -200
      .Width = 1000
      .Name = "2"
      .Key = KW_DESCUENTO2
    End With
    
    With .Add(Nothing, c_Wiz_Key_Comprobante)
      .PropertyType = cspText
      .Left = 7800
      .TopFromProperty = c_Wiz_Key_Fecha
      .Name = LNGGetText(1610, vbNullString) 'Comprobante
      .Key = KW_COMPROBANTE
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
    
    With .Add(Nothing, c_Wiz_Key_Legajo)
      .PropertyType = cspHelp
      .Table = csLegajo
      .Name = LNGGetText(1575, vbNullString) 'Legajo
      .Key = KW_LEGAJO
    End With
    
    With .Add(Nothing, c_Wiz_Key_Vendedor)
      .PropertyType = cspHelp
      .Table = csVendedores
      .Name = LNGGetText(1510, vbNullString) 'Vendedor
      .Key = KW_VEN_ID
    End With
    
    With .Add(Nothing, c_Wiz_Key_CentroCosto)
      .PropertyType = cspHelp
      .Table = csCentroCosto
      .Name = LNGGetText(1057, vbNullString) 'Centro de Costo
      .Key = KW_CENTROCOSTO
    End With
  
    With .Add(Nothing, c_Wiz_Key_Observaciones)
      .PropertyType = cspText
      .Left = 2800
      .TopFromProperty = c_Wiz_Key_OrdenCompra
      .TopToPrevious = 440
      .Height = 880
      .Width = 7250
      .Name = LNGGetText(1861, vbNullString) 'Observaciones
      .Key = KW_DESCRIP
    End With
  End With
End Sub

Private Function pUserCancel() As Boolean
  If m_WizardCancel Then
    
    'If Ask("Desea cancelar el proceso", vbNo) Then
    If Ask(LNGGetText(1665, vbNullString), vbNo) Then
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
                                c_StepSelectPacking, _
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
                                c_StepSelectPacking, _
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

Private Function pGetPacking() As cIABMGrid
  Set pGetPacking = GetWizProperty(m_ObjWizard, _
                                c_StepSelectPacking, _
                                c_Wiz_Key_PackingList).Grid
End Function

Private Function pGetPackingProperty() As cIABMProperty
  Set pGetPackingProperty = GetWizProperty(m_ObjWizard, _
                                c_StepSelectPacking, _
                                c_Wiz_Key_PackingList)
End Function

Private Sub pRefreshPackingList()
  Dim ObjWiz As cWizardGeneric
  Set ObjWiz = m_ObjWizard
  
  ObjWiz.ShowValue GetWizProperty(m_ObjWizard, _
                                c_StepSelectPacking, _
                                c_Wiz_Key_PackingList), True
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

Private Function pGetCotizacion() As cIABMProperty
  Set pGetCotizacion = GetWizProperty(m_ObjWizard, _
                                    c_StepDatosGenerales, _
                                    c_Wiz_Key_Cotizacion)
End Function

Private Function pGetVendedor() As cIABMProperty
  Set pGetVendedor = GetWizProperty(m_ObjWizard, _
                                    c_StepDatosGenerales, _
                                    c_Wiz_Key_Vendedor)
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

Private Function pGetOrdenCompra() As cIABMProperty
  Set pGetOrdenCompra = GetWizProperty(m_ObjWizard, _
                                c_StepDatosGenerales, _
                                c_Wiz_Key_OrdenCompra)
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

Private Function pChecPackingList() As Boolean
  Dim row As cIABMGridRow
  For Each row In pGetPacking().Rows
    If pCell(row, KI_SELECT).id Then
      pChecPackingList = True
      Exit Function
    End If
  Next
  
  MsgWarning LNGGetText(1677, vbNullString)  'Debe indicar uno o más Remitos.
End Function

Private Function pCheckPercepciones() As Boolean
  pCheckPercepciones = True
End Function

'nrs
Private Function pCheckItems() As Boolean
  Dim row                 As cIABMGridRow
  Dim bExistsSelected     As Boolean
  Dim i                   As Long
  
  For Each row In pGetItems().Rows
    i = i + 1
    If Val(pCell(row, KII_APLICAR).Value) > 0 Then
      If Not pValidateRowItems(row, i) Then Exit Function
      bExistsSelected = True
      If Not Val(pCell(row, KII_PRECIO_SIN_IVA).Value) > 0 Then
      
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
  
  If Not ValidateNroSerieCantidad(pGetItems(), _
                                  KI_PR_LLEVANROSERIE, _
                                  KII_SELECT, _
                                  m_NrosSerie, _
                                  KII_APLICAR) Then
    Exit Function
  End If
  
  pCheckItems = True
End Function

Private Function pValidateRowItems(ByRef row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bLlevaNroSerie        As Boolean
  
  If pCell(row, KII_SELECT).id Then
  
    strRow = " (Fila " & RowIndex & ")"
    
    bLlevaNroSerie = pCell(row, KI_PR_LLEVANROSERIE).id
    If ValEmpty(pCell(row, KI_NROSERIE).Value, csText) And bLlevaNroSerie Then
      MsgInfo LNGGetText(1630, vbNullString, strRow)
              'Debe indicar un numero de serie (1)
      Exit Function
    End If
    
    ' Lote
    '
    If ValEmpty(pCell(row, KI_STL_ID).id, csId) And _
       pCell(row, KI_PR_LLEVALOTE).id And _
       pCell(row, KI_PR_LOTEFIFO).id = 0 And _
       Not bLlevaNroSerie Then
      
      MsgInfo LNGGetText(1632, vbNullString, strRow)
              'Debe indicar un lote (1)
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

Private Function pGetPackingIds() As String
  Dim row         As cIABMGridRow
  Dim Ids         As String
  
  For Each row In pGetPacking().Rows
    If pCell(row, KI_SELECT).id Then
      Ids = Ids & pCell(row, KI_PKLST_ID).id & ","
    End If
  Next
  
  pGetPackingIds = RemoveLastColon(Ids)
End Function

Private Function pLoadItemsXPacking() As Boolean
  Dim sqlstmt           As String
  Dim rs                As Recordset
  Dim i                 As Long
  
  sqlstmt = "sp_DocFacturaVentaGetPackingItems '" & pGetPackingIds & "'"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  With pGetItems().Rows
    
    .Clear

    While Not rs.EOF
    
      With .Add(Nothing)
      
        ' La primera no se usa
        With .Add(Nothing)
          .id = gDB.ValField(rs.fields, cscPklstiId)
          .Key = KII_PKLSTI_ID
        End With
        
        With .Add(Nothing)
          .Value = 0
          .Key = KII_SELECT
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPklstNrodoc)
          .Key = KI_NRODOC
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPklstNumero)
          .id = gDB.ValField(rs.fields, cscPklstId)
          .Key = KI_PKLST_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPrNombreVenta)
          .id = gDB.ValField(rs.fields, cscPrId)
          .Key = KII_ARTICULO
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPklstiPrecio & "2")
          .Key = KII_PRECIO_SIN_IVA
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPklstiCantidad)
          .Key = KII_CANTIDAD
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPklstiPendientefac)
          .Key = KII_PENDIENTE
        End With
        
        With .Add(Nothing)
          .Value = 0
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
          .Value = gDB.ValField(rs.fields, cscPklstiImporte)
          .Key = KII_TOTAL
        End With
        
        With .Add(Nothing)
          .id = C_TO_ComercialId
          .Value = C_TO_Comercial
          .Key = KII_TO_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPklstiDescrip)
          .Key = KII_DESCRIP
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPklstiPrecio)
          .Key = KII_PRECIOIVA
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPklstiPrecioLista)
          .Key = KII_PRECIO_LP
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPklstiPrecioUsr)
          .Key = KII_PRECIO_USR
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPklstiIvariporc)
          .Key = KII_IVARIPercent
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPklstiIvarniporc)
          .Key = KII_IVARNIPercent
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPklstiDescuento)
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
          .id = 0
          .Key = KI_GRUPO
        End With
        
      End With
      
      rs.MoveNext
    
    Wend
  
  End With
  
  'nrs
  CollClear m_NrosSerie
  
  '//////////////////////////////////////////////////
  ' Kit
  '//////////////////////////////////////////////////
  Dim PrId  As Long
  Dim Coll  As Collection
  
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
  
  pRefreshItems
  pShowTotalItems
  
  pLoadItemsXPacking = True
End Function

Private Function pLoadPackingXCliente() As Boolean
  Dim sqlstmt           As String
  Dim rs                As Recordset
  Dim pklst_id          As Long
  
  ' Edit From ListDoc
  '
  Dim bSelected         As Boolean
  Dim bOnlySelected     As Boolean
  
  sqlstmt = "sp_DocFacturaVentaGetPacking " & EmpId & "," & pGetCliente & ", " & pGetMonId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  ' Edit From ListDoc
  '
  bOnlySelected = pGetOnlySelected().Value
  
  With pGetPacking().Rows
    
    .Clear
  
    While Not rs.EOF
    
      ' Edit From ListDoc
      '
      pklst_id = gDB.ValField(rs.fields, cscPklstId)
      
      bSelected = pGetApply(pklst_id)
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
            .Value = gDB.ValField(rs.fields, cscPklstNrodoc)
            .Key = KI_NRODOC
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPklstNumero)
            .id = gDB.ValField(rs.fields, cscPklstId)
            .Key = KI_PKLST_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPklstFecha)
            .Key = KI_FECHA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPklstTotal)
            .Key = KI_TOTAL
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPklstDescrip)
            .Key = KI_DESCRIP
          End With
        End With
      End If
      
      rs.MoveNext
    Wend
  End With
  
  pRefreshPackingList
  pShowTotalPacking
  
  pLoadPackingXCliente = True
End Function

' Edit From ListDoc
'
Private Function pGetApply(ByVal pklst_id As Long) As Boolean
  Dim i As Long
  
  For i = 1 To UBound(m_PklstIds)
    If m_PklstIds(i) = pklst_id Then
      pGetApply = True
      Exit Function
    End If
  Next
End Function

' Validaciones de Filas
Private Function pIsEmptyRowItems(ByRef row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In row
    Select Case Cell.Key
      Case KII_PKLSTI_ID, KII_ARTICULO, KII_PENDIENTE
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
    MsgWarning LNGGetText(1669, vbNullString)
               'Debe indicar la fecha de la factura
    Exit Function
  End If
  
  If ValEmpty(pGetCondicionPago().HelpId, csId) Then
    MsgWarning LNGGetText(1561, vbNullString)
               'Debe indicar una condición de pago
    Exit Function
  End If
  
  If ValEmpty(pGetCotizacion().Value, csDouble) And WizMustValidateCotizacion(pGetDoc()) Then
    MsgWarning LNGGetText(1626, vbNullString)
               'Debe indicar la cotizacion
    Exit Function
  End If
  
  If ValEmpty(pGetSucursal().HelpId, csId) Then
    MsgWarning LNGGetText(1560, vbNullString)
               'Debe indicar la sucursal
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
  
  ReDim m_PklstIds(0)

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
  ReDim m_PklstIds(0)
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
      
      pGetFooter Neto, IvaRi, IvaRni
    
      ' Aplico descuentos
      '
      IvaRi = IvaRi - (IvaRi * Desc1 / 100)
      IvaRni = IvaRni - (IvaRni * Desc1 / 100)
      
      IvaRi = IvaRi - (IvaRi * Desc2 / 100)
      IvaRni = IvaRni - (IvaRni * Desc2 / 100)
      
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
      .Add2 cscFvImportedesc1, Desc1 * Cotizacion, csCurrency
      .Add2 cscFvImportedesc2, Desc2 * Cotizacion, csCurrency
      .Add2 cscFvTotalPercepciones, TotalPercep * Cotizacion, csCurrency
      
      .Add2 cscFvTotal, (Neto + IvaRi + IvaRni + TotalPercep) * Cotizacion, csCurrency ' Por ahora no hay descuentos
      
      .HaveLastUpdate = True
      .HaveWhoModify = True
      
    End With
    
    If Not .BeginTrans(gDB) Then Exit Function
    
    If Not gDB.Save(register, , "pSave", C_Module, c_ErrorSave) Then Exit Function
    
    If Not pSaveItems(.id, Cotizacion, bMonedaLegal) Then Exit Function
    
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
                            ByVal bMonedaLegal As Boolean) As Boolean
  
  'Generales
  '
  Dim register  As cRegister
  Dim iOrden    As Long
  Dim row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  Dim Precio    As Double
  Dim IvaRi     As Double
  Dim IvaRni    As Double
  Dim Neto      As Double
  Dim Importe   As Double
  Dim Cantidad  As Double
  Dim sqlstmt   As String
  
  'nrs
  ' Para numeros de serie
  '
  Dim iOrden2     As Long
  Dim PrId        As Long
  
  For Each row In pGetItems().Rows
  
    If Val(pCell(row, KII_APLICAR).Value) Then
    
      Set register = New cRegister
      
      With register
        
        .fieldId = cscFviTMPId
        .Table = csTFacturaVentaItemTMP
        .id = csNew
          
        With .fields
          
          For Each Cell In row
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
                If m_bIva Then
                  IvaRi = Cell.Value
                End If
                .Add2 cscFviIvariporc, IvaRi, csDouble
              Case KII_IVARNIPercent
                If m_bIvaRni Then
                  IvaRni = Cell.Value
                End If
                .Add2 cscFviIvarniporc, IvaRni, csDouble
              Case KII_ARTICULO
                'nrs
                PrId = Cell.id
                .Add2 cscPrId, PrId, csId
              ' TO
              Case KII_TO_ID
                .Add2 cscToId, Cell.id, csId
              Case KII_CCOS_ID
                .Add2 cscCcosId, Cell.id, csId
              ' Lote
              '
              Case KI_STL_ID
                .Add2 cscStlId, Cell.id, csId
            End Select
          Next
        
          Neto = Precio * Cantidad
          .Add2 cscFviNeto, Neto, csCurrency
          
          IvaRi = Neto * IvaRi / 100
          .Add2 cscFviIvari, IvaRi, csCurrency
          
          IvaRni = Neto * IvaRni / 100
          .Add2 cscFviIvarni, IvaRni, csCurrency
          
          Importe = Neto + IvaRi + IvaRni
          .Add2 cscFviImporte, Importe, csCurrency
          
          If bMonedaLegal Then
            .Add2 cscFviImporteOrigen, 0, csCurrency
          Else
            .Add2 cscFviImporteOrigen, DivideByCero(Importe, Cotizacion), csCurrency
          End If
          
          ' Esto es muy importante ya que se usa para vincular el packint list item
          ' con el nuevo Facturaventaitem
          iOrden = iOrden + 1
          .Add2 cscFviOrden, iOrden, csInteger
          
          .Add2 cscFvTMPId, id, csId
          .Add2 cscFviId, id, csLong
          
          ' Cuentas contables - Por ahora se resuelve asi
          .Add2 cscCueId, -1, csId
          .Add2 cscCueIdIvaRI, -1, csId
          .Add2 cscCueIdIvaRNI, -1, csId
          
          .HaveLastUpdate = False
          .HaveWhoModify = False
          
        End With
        
        If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
      
        'nrs
        If Not pSaveItemNroSerie(row, iOrden2, PrId, id, .id, iOrden * -1) Then Exit Function
        
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
  Dim row             As cIABMGridRow
  Dim Cell            As cIABMGridCellValue
  
  For Each row In pGetItems().Rows
  
    Set register = New cRegister
    
    With register
      
      .fieldId = cscPklstFvTMPId
      .Table = csTPackingListFacturaVentaTMP
      .id = csNew
      
      bSave = False
      
      With .fields
        
        For Each Cell In row
          If pCell(row, KII_SELECT).id Then
            bSave = True
            Select Case Cell.Key
              Case KII_PKLSTI_ID
                .Add2 cscPklstiId, Cell.id, csId
              Case KII_APLICAR
                .Add2 cscPklstFvCantidad, Cell.Value, csDouble
            End Select
          End If
        Next
        
        If bSave Then
          
          .Add2 cscPklstFvId, 0, csLong
          .Add2 cscFvTMPId, id, csId
          
          ' Esto es muy importante ya que se usa para vincular el packint list item
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

Private Sub pGetFooter(ByRef Neto As Double, ByRef IvaRi As Double, ByRef IvaRni As Double)
  Dim row           As cIABMGridRow
  Dim Cell          As cIABMGridCellValue
  Dim Precio        As Double
  Dim Cantidad      As Double
  Dim IvaRniPercent As Double
  Dim IvaRiPercent  As Double
  
  For Each row In pGetItems().Rows
    
    If pCell(row, KII_SELECT).id Then
      For Each Cell In row
        Select Case Cell.Key
          Case KII_APLICAR
            Cantidad = Cell.Value
          Case KII_PRECIO_SIN_IVA
            Precio = Cell.Value
          Case KII_IVARIPercent
            IvaRiPercent = Cell.Value
          Case KII_IVARNIPercent
            IvaRniPercent = Cell.Value
        End Select
      Next
      
      Neto = Neto + (Precio * Cantidad)
      If m_bIva Then
        IvaRi = IvaRi + ((Precio * Cantidad) * IvaRiPercent / 100)
      Else
        IvaRi = 0
      End If
      If m_bIvaRni Then
        IvaRni = IvaRni + ((Precio * Cantidad) * IvaRniPercent / 100)
      Else
        IvaRni = 0
      End If
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
Private Function pSaveItemNroSerie(ByRef row As CSInterfacesABM.cIABMGridRow, _
                                   ByRef iOrden As Long, _
                                   ByVal PrId As Long, _
                                   ByVal FvTMPId As Long, _
                                   ByVal FviTMPId As Long, _
                                   ByVal Grupo As Long) As Boolean
                                   
  Dim pt        As cProductoSerieType
  Dim register  As cRegister
  
  ' Si lleva numero de serie
  '
  If pCell(row, KI_PR_LLEVANROSERIE).id Then
  
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
  Dim cpg_id      As Long
  Dim cpg_nombre  As String
  Dim iProp       As cIABMProperty
  
  With pGetClienteProp()
    If m_LastCli = .HelpId Then
      Exit Sub
    End If
    m_LastCli = .HelpId
  End With

  If Not GetClienteData2(m_LastCli, 0, 0, cpg_id, m_LastDoc) Then Exit Sub
  
  ' Condicion de pago
  If cpg_id <> csNO_ID Then
    
    If Not gDB.GetData(csTCondicionPago, cscCpgId, cpg_id, cscCpgNombre, cpg_nombre) Then Exit Sub
    
    Set iProp = pGetCondicionPago()
    iProp.Value = cpg_nombre
    iProp.HelpId = cpg_id
    m_ObjWizard.ShowValue iProp
  End If
  
  pSetListaPrecio
  
  Set iProp = pGetSucCliente()
  With iProp
    .HelpFilter = GetHelpFilterCliSuc(m_LastCli)
  End With
  
  m_ObjWizard.ShowValue iProp
  
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
  
  pGetPacking().Rows.Clear
  pGetItems().Rows.Clear
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
    .ShowValue pGetPackingProperty()
    .ShowValue pGetItemsProperty()
    .ShowValue pGetPercepcionesProperty()
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

  Dim row       As cIABMGridRow
  Dim i         As Long
  Dim perc_id   As Long
  Dim Neto      As Double
  Dim Total     As Double
  
  If m_doc_sin_perc Then Exit Sub
  
  For i = 1 To UBound(m_vPercepciones)
    With m_vPercepciones(i)
      
      .base = 0
      
      For Each row In pGetItems().Rows
      
        Neto = Val(pCell(row, KII_APLICAR).Value) _
             * Val(pCell(row, KII_PRECIO_SIN_IVA).Value)
             
        Select Case .tipo_base
          Case csE_PercepcionBase.csEPB_Neto
            .base = .base + Neto
          
          Case csE_PercepcionBase.csEPB_NetoGravado
            
            If Val(pCell(row, KII_IVARIPercent).Value) Then
              .base = .base + Neto
            End If
            
          Case csE_PercepcionBase.csEPB_Total
          
            Total = Neto + (Neto * Val(pCell(row, KII_IVARIPercent).Value) / 100)
            .base = .base + Total
        End Select
      Next
      
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
            
        Set row = Rows.Add(Nothing)
              
        Set Cell = row.Add(Nothing)
        Cell.Value = 0
        Cell.Key = KIP_FVPERC_ID
        
        Set Cell = row.Add(Nothing)
        Cell.Value = .nombre
        Cell.id = .perc_id
        Cell.Key = KIP_PERC_ID
        
        Set Cell = row.Add(Nothing)
        Cell.Value = .base
        Cell.Key = KIP_BASE
        
        Set Cell = row.Add(Nothing)
        Cell.Value = .porc
        Cell.Key = KIP_PORCENTAJE
        
        Set Cell = row.Add(Nothing)
        Cell.Value = .percepcion
        Cell.Key = KIP_IMPORTE
        
        Set Cell = row.Add(Nothing)
        Cell.Value = vbNullString
        Cell.Key = KIP_DESCRIP
        
        Set Cell = row.Add(Nothing)
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


