VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFacturaCompraWizard"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIWizardClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cFacturaCompraWizard
' 04-05-2004

'--------------------------------------------------------------------------------
' notas:

' Asistente de Facturas

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cFacturaCompraWizard"

' Paso 2
Private Const KW_ORDENESCOMPRA               As Integer = 10
Private Const KW_TODOS                       As Integer = 110

' Paso 3
Private Const KW_ITEMS                       As Integer = 120
Private Const KW_TODOS_ITEMS                 As Integer = 130

' Paso 4
Private Const KW_PERCEPCIONES                   As Integer = 150
Private Const KW_TOTAPERCEPCIONES               As Integer = 160

' Paso 5
Private Const KI_OC_ID                       As Integer = 1
Private Const KI_SELECT                      As Integer = 2
Private Const KI_DOC                         As Integer = 3
Private Const KI_NRODOC                      As Integer = 4
Private Const KI_FECHA                       As Integer = 5
Private Const KI_DESCRIP                     As Integer = 8
Private Const KI_TOTAL                       As Integer = 10

' TO
Private Const KII_TO_ID                  As Integer = 400

Private Const KII_SELECT                 As Integer = 1
Private Const KII_OCI_ID                 As Integer = 2
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

' Lote
'
Private Const KI_STL_ID                         As Integer = 26
Private Const KI_PR_LLEVALOTE                   As Integer = 27

Private Const c_WizardTitle = "Asistente de Facturas de compra"

Private Const c_ErrorSave = "Error al grabar la factura de compra"

' estructuras
' variables privadas
Private m_ObjWizard               As cIWizardGeneric

Private m_WizardProcessing        As Boolean
Private m_WizardCancel            As Boolean

'Private m_Resource                As fResource

Private m_GeneralConfig     As cGeneralConfig

Private m_Id                As Long

Private m_Prov_id           As Long
Private m_proveedor         As String
Private m_doc_id            As Long
Private m_Documento         As String
Private m_OcIds()           As Long

Private m_bShowStockData               As Boolean
Private m_depl_id                      As Long
Private m_Deposito                     As String

Private m_ObjClient         As Object

Private m_bIva              As Boolean
Private m_bIvaRni           As Boolean

Private m_LastProv          As Long
Private m_LastDoc           As Long

' PrintDoc
'
Private m_LastNroDoc        As String

'nrs
Private m_NrosSerie         As Collection

' eventos
' propiedades publicas
Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Let doc_id(ByVal rhs As Long)
  m_doc_id = rhs
End Property

Public Property Let Documento(ByVal rhs As String)
  m_Documento = rhs
End Property

Public Property Let prov_id(ByVal rhs As Long)
  m_Prov_id = rhs
End Property

Public Property Let Proveedor(ByVal rhs As String)
  m_proveedor = rhs
End Property

Public Property Let OcIds(ByRef rhs() As Long)
  On Error Resume Next
  Dim i As Long
  ReDim m_OcIds(UBound(rhs))
  For i = 0 To UBound(rhs)
    m_OcIds(i) = rhs(i)
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
Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case KW_ORDENESCOMPRA
      cIABMClientGrid_IsEmptyRow = False
    Case KW_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowItems(Row, RowIndex)
    Case KW_PERCEPCIONES
      cIABMClientGrid_IsEmptyRow = IsEmptyRowPercepciones(Row, RowIndex)
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
    Case KW_ORDENESCOMPRA
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateOrdenCompra(pGetOrdenesProperty(), lRow, lCol)
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
    Case KW_ORDENESCOMPRA
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
    Case KW_ORDENESCOMPRA
      cIABMClientGrid_ColumnBeforeEdit = pColBEditOrdenes(pGetOrdenesProperty(), lRow, lCol, iKeyAscii)
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
  Dim Row As cIABMGridRow
  
  Select Case Key
    Case KW_ITEMS
      With pGetItems()
        Select Case .Columns(lCol).Key
          Case KI_NROSERIE
            Set Row = .Rows(lRow)
            If pCell(Row, KI_PR_LLEVANROSERIE).Id Then
            
              Dim PrId As Long
              
              PrId = pCell(Row, KII_ARTICULO).Id
            
              cIABMClientGrid_ColumnButtonClick = EditNroSerie(pCell(Row, KI_GRUPO).Id, _
                                                               Val(pCell(Row, KII_APLICAR).Value), _
                                                               Row, _
                                                               m_NrosSerie, _
                                                               KI_GRUPO, _
                                                               KI_NROSERIE, _
                                                               lRow, _
                                                               csNO_ID, csNO_ID, True, _
                                                               False, Nothing, csNO_ID, csNO_ID)
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
  Dim Id As Long
  
  Select Case Key
    Case KW_ORDENESCOMPRA
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
    Case KW_ORDENESCOMPRA
      cIABMClientGrid_ValidateRow = True
    Case KW_ITEMS
      cIABMClientGrid_ValidateRow = True
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

Private Function pColBEditItems(ByRef IProperty As cIABMProperty, _
                                ByVal lRow As Long, _
                                ByVal lCol As Long, _
                                ByVal iKeyAscii As Integer) As Boolean
  Dim Row As cIABMGridRow
                                
  Select Case pGetKeyFromCol(IProperty.Grid.Columns, lCol)
    Case KII_SELECT, KII_APLICAR, KII_PRECIO_SIN_IVA, KII_TO_ID ' TO
    
    'nrs
    Case KI_NROSERIE
      Set Row = IProperty.Grid.Rows(lRow)
      If Not Row Is Nothing Then
        pColBEditItems = pCell(Row, KI_PR_LLEVANROSERIE).Id
      End If
    
    ' Lote
    '
    Case KI_STL_ID
      Set Row = IProperty.Grid.Rows(lRow)
      If Not Row Is Nothing Then
        pColBEditItems = pCell(Row, KI_PR_LLEVALOTE).Id
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

Private Function pColAUpdateOrdenCompra(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long)
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KI_SELECT
        pShowTotalOrdenes
    End Select
  End With
  
  pColAUpdateOrdenCompra = True
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
      pCell(Row, KI_SELECT).Id = CInt(bSelect)
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
      pCell(Row, KII_SELECT).Id = CInt(bSelect)
      pSelectItem Row, .Columns
    Next
  End With
  
  Dim ObjWiz As cWizardGeneric
  Set ObjWiz = m_ObjWizard
  
  ObjWiz.ShowValue pGetItemsProperty, True
End Sub

Private Sub pSelectItem(ByRef Row As cIABMGridRow, ByRef Columns As cIABMGridColumns)
  With pCell(Row, KII_APLICAR)
    If pCell(Row, KII_SELECT).Id Then
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
    If pCell(Row, KI_SELECT).Id Then
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
      nNextStep = c_StepSelectProveedor
      m_ObjWizard.cmdNext.Caption = c_WizStr_Next
      m_ObjWizard.cmdBack.Enabled = False
      m_LastProv = csNO_ID
      pSetDatosProveedor
      
    Case c_StepSelectProveedor
    
      If pGetDoc() = csNO_ID Then
        MsgWarning LNGGetText(1562, vbNullString), LNGGetText(1607, vbNullString)
                'Debe indicar un documento, Facturas
        nNextStep = c_StepSelectProveedor
      ElseIf pGetProveedor() = csNO_ID Then
        MsgWarning LNGGetText(1860, vbNullString), LNGGetText(1607, vbNullString)
                'Debe indicar un proveedor, Facturas
        nNextStep = c_StepSelectProveedor
      ElseIf WizGetDeposito(m_ObjWizard, c_StepSelectProveedor, c_Wiz_Key_Deposito) = csNO_ID _
                                                          And m_bShowStockData Then
        MsgWarning LNGGetText(1559, vbNullString), LNGGetText(1722, vbNullString)
                'Debe indicar un deposito, Remitos
        nNextStep = c_StepSelectProveedor
      ElseIf Not pLoadOrdenesXProveedor() Then
        MsgWarning LNGGetText(1916, vbNullString), LNGGetText(1607, vbNullString)
                'No se pudieron cargar las Ordenes de Compra para este Proveedor, Facturas
        nNextStep = c_StepSelectProveedor
      Else
        pGetTodos.Name = c_selectall
        m_ObjWizard.ShowValue pGetTodos
        m_ObjWizard.cmdBack.Enabled = True
        nNextStep = c_StepSelectOrdenRemito
      End If
      
    Case c_StepSelectOrdenRemito
      If Not pCheckOrdenes() Then
        nNextStep = c_StepSelectOrdenRemito
      ElseIf Not pLoadItemsXOrdenes() Then
        MsgWarning LNGGetText(1917, vbNullString), LNGGetText(1607, vbNullString)
                'No se pudieron cargar los items de las ordenes de compra para este proveedor, Facturas
        nNextStep = c_StepSelectOrdenRemito
      Else
        nNextStep = c_StepSelectItems
      End If
    
    Case c_StepSelectItems
      If Not pCheckItems() Then
        nNextStep = c_StepSelectItems
      Else
        nNextStep = c_StepPercepciones
      End If
    
    Case c_StepPercepciones
      If Not pCheckPercepciones() Then
        nNextStep = c_StepPercepciones
      Else
        
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
    
    Case c_StepSelectOrdenRemito
      m_ObjWizard.cmdBack.Enabled = False
      nNextStep = c_StepSelectProveedor
    
    Case c_StepSelectItems
      nNextStep = c_StepSelectOrdenRemito
    
    Case c_StepPercepciones
      nNextStep = c_StepSelectItems
    
    Case c_StepDatosGenerales
      m_ObjWizard.cmdNext.Caption = c_WizStr_Next
      nNextStep = c_StepPercepciones
  End Select

  cIWizardClient_PreviousStep = True
End Function

Private Function cIWizardClient_PropertyChange(ByVal Key As Integer) As Boolean
  
  Dim iProp As cIABMProperty
  
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
      WizPrintDoc m_Id, m_LastDoc
    
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
      m_LastDoc = pGetDoc()
      WizSetShowStockData m_ObjWizard, c_StepSelectProveedor, m_bShowStockData
      Set iProp = WizGetDepositoProp(m_ObjWizard, _
                         c_StepSelectProveedor, _
                         c_Wiz_Key_Deposito)
      iProp.Enabled = m_bShowStockData
      m_ObjWizard.ShowValue iProp
      
      WizCpraShowCotizacion m_ObjWizard, c_StepDatosGenerales, m_LastDoc, True
      
    Case KW_PROV_ID
      pSetDatosProveedor
      
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
  m_ObjClient.TerminateWizard m_Id
End Function

Private Property Get cIWizardClient_Title() As String
  cIWizardClient_Title = c_WizardTitle
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
  m_LastProv = m_Prov_id
  
  pLoadStepWelcome
  pLoadStepSelectProveedor
  pLoadStepSelectOrden
  pLoadStepSelectItems
  pLoadStepPercepciones
  'WizCpraLoadStepDatosGrales m_ObjWizard, m_Resource, m_doc_id, m_prov_id
  WizCpraLoadStepDatosGrales m_ObjWizard, _
                             Nothing, _
                             m_doc_id, _
                             m_Prov_id, _
                             m_GeneralConfig.FormatDecCotizacion
  WizCpraShowCotizacion m_ObjWizard, c_StepDatosGenerales, m_LastDoc, False
  pGetIvaFromProveedor m_Prov_id, m_bIva, m_bIvaRni

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
      .Value = LNGGetText(1913, vbNullString) 'Bienvenido al Asistente de Facturas de Compra
    End With
    
    With .Add(Nothing, c_Wiz_Key_MainTitle)
      .Top = 1200
      .Left = 3000
      '.Name = vbNullString
      .PropertyType = cspLabel
      .Width = 6000
      .Height = 880
      .FontBold = True
      .Value = LNGGetText(1918, vbNullString)
              'Con este Asistente usted podrá generar las Facturas sobre Ordenes de Compra.
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
      .Value = LNGGetText(1914, vbNullString)
            'Indique el documento a utilizar y el proveedor al que se le emitirá la factura
    End With
    
    With .Add(Nothing, c_Wiz_Key_Doc)
      .Top = 1500
      .Left = 3700
      .Name = LNGGetText(1567, vbNullString)  'Documento
      .PropertyType = cspHelp
      .HelpFilter = "'doct_id = " & csEDT_FacturaCompra & " and " & cscDocTipoFactura & " = " & csETFacOrden & "'"
      .Table = CSDocumento2.CSDocumento
      .Width = 4000
      .Value = m_Documento
      .HelpId = m_doc_id
      .Key = KW_DOC_ID
    End With
  
    With .Add(Nothing, c_Wiz_Key_Proveedor)
      .Top = 2000
      .Left = 3700
      .Name = LNGGetText(1151, vbNullString)  'Proveedor
      .PropertyType = cspHelp
      .Table = csProveedor
      .Width = 4000
      .Value = m_proveedor
      .HelpId = m_Prov_id
      .Key = KW_PROV_ID
    End With

    'nrs
    WizSetShowStockData m_ObjWizard, c_StepSelectProveedor, m_bShowStockData

    With .Add(Nothing, c_Wiz_Key_Deposito)
      .Top = 2500
      .Left = 3700
      .Name = LNGGetText(1574, vbNullString)  'Deposito
      .PropertyType = cspHelp
      .Table = csDepositoLogico
      .Width = 4000
      .Value = m_Deposito
      .HelpId = m_depl_id
      .Enabled = m_bShowStockData
    End With
  
    ' Edit From ListDoc
    '
    With .Add(Nothing, c_Wiz_Key_OnlySelected)
      .PropertyType = cspCheck
      .Name = LNGGetText(1919, vbNullString)  'Cargar solo ordenes de compra seleccionadas
      .Value = UBound(m_OcIds)
    End With
  End With

End Sub

Private Sub pLoadStepSelectOrden()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepSelectOrdenRemito)).Properties
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
      .Value = LNGGetText(1920, vbNullString)  'Seleccione las ordenes de compra
    End With
    
    With .Add(Nothing, c_Wiz_Key_Ordenes)
      .Top = 1100
      .Left = 150
      '.Name = vbNullString
      .PropertyType = cspGrid
      .LeftLabel = -1
      pLoadOrdenes .Grid
      .Width = 11500
      .Height = 4500
      .Key = KW_ORDENESCOMPRA
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
    End With
  
    With .Add(Nothing, c_Wiz_Key_Todos)
      .Name = c_selectall
      .Top = 5660
      .Left = 200
      .LeftLabel = -1
      .Width = 2200
      .PropertyType = cspButton
      .Key = KW_TODOS
    End With
  
    With .Add(Nothing, c_Wiz_Key_Total)
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

Private Sub pLoadOrdenes(ByRef Grid As cIABMGrid)
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
      .Key = KI_OC_ID
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
      .Height = 4500
      .Key = KW_ITEMS
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
    End With
  
    With .Add(Nothing, c_Wiz_Key_TodosItems)
      .Name = c_selectall
      .Top = 5660
      .Left = 200
      .LeftLabel = -1
      .Width = 2200
      .PropertyType = cspButton
      .Key = KW_TODOS_ITEMS
    End With
  
    With .Add(Nothing, c_Wiz_Key_TotalItems)
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

Private Sub pLoadItems(ByRef Grid As cIABMGrid)
  ' La primera simpre esta invisible
  With Grid.Columns
    With .Add(Nothing)
      .Visible = False
      .Key = KII_OCI_ID
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
      .Width = 1500
      .Key = KI_NRODOC
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1065, vbNullString)  'Número
      .PropertyType = cspNumeric
      .Width = 700
      .Key = KI_OC_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1367, vbNullString)  'Articulo
      .PropertyType = cspText
      .Width = 2500
      .Key = KII_ARTICULO
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1586, vbNullString)  'Precio
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 920
      .Key = KII_PRECIO_SIN_IVA
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = SecurityCanAccessSilent(csPreCpraEditPriceFac)
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
    With .Add(Nothing)
      .Name = LNGGetText(1640, vbNullString)  'Lote
      .PropertyType = cspText
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
      .Width = 1000
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
    
    'nrs
    With .Add(Nothing)
      .Visible = False
      .Key = KI_PR_LLEVANROSERIE
    End With
  
    With .Add(Nothing)
      .Visible = False
      .Key = KI_GRUPO
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

Private Function pGetCotizacion() As cIABMProperty
  Set pGetCotizacion = GetWizProperty(m_ObjWizard, _
                                      c_StepDatosGenerales, _
                                      c_Wiz_Key_Cotizacion)
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

Private Function pGetTodos() As cIABMProperty
  Set pGetTodos = GetWizProperty(m_ObjWizard, _
                                c_StepSelectOrdenRemito, _
                                c_Wiz_Key_Todos)
End Function

Private Function pGetTodosItems() As cIABMProperty
  Set pGetTodosItems = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectItems, _
                                      c_Wiz_Key_TodosItems)
End Function

Private Function pGetTotal() As cIABMProperty
  Set pGetTotal = GetWizProperty(m_ObjWizard, _
                                 c_StepSelectOrdenRemito, _
                                 c_Wiz_Key_Total)
End Function

Private Function pGetTotalItems() As cIABMProperty
  Set pGetTotalItems = GetWizProperty(m_ObjWizard, _
                                      c_StepSelectItems, _
                                      c_Wiz_Key_TotalItems)
End Function

Private Function pGetTotalPercepciones() As cIABMProperty
  Set pGetTotalPercepciones = GetWizProperty(m_ObjWizard, _
                                             c_StepPercepciones, _
                                             c_Wiz_Key_TotalPercepciones)
End Function

Private Function pGetProveedor2() As cIABMProperty
  Set pGetProveedor2 = GetWizProperty(m_ObjWizard, _
                                      c_StepDatosGenerales, _
                                      c_Wiz_Key_Proveedor2)
End Function

Private Function pGetProveedorProp() As cIABMProperty
  Set pGetProveedorProp = GetWizProperty(m_ObjWizard, _
                                         c_StepSelectProveedor, _
                                         c_Wiz_Key_Proveedor)
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

Private Function pGetOrdenes() As cIABMGrid
  Set pGetOrdenes = GetWizProperty(m_ObjWizard, _
                                  c_StepSelectOrdenRemito, _
                                  c_Wiz_Key_Ordenes).Grid
End Function

Private Function pGetOrdenesProperty() As cIABMProperty
  Set pGetOrdenesProperty = GetWizProperty(m_ObjWizard, _
                                           c_StepSelectOrdenRemito, _
                                           c_Wiz_Key_Ordenes)
End Function

Private Sub pRefreshOrdenes()
  Dim ObjWiz As cWizardGeneric
  Set ObjWiz = m_ObjWizard
  
  ObjWiz.ShowValue GetWizProperty(m_ObjWizard, _
                                  c_StepSelectOrdenRemito, _
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

Private Function pGetCondicionPago() As cIABMProperty
  Set pGetCondicionPago = GetWizProperty(m_ObjWizard, _
                                         c_StepDatosGenerales, _
                                         c_Wiz_Key_CondicionPago)
End Function

Private Function pGetListaPrecio() As cIABMProperty
  Set pGetListaPrecio = GetWizProperty(m_ObjWizard, _
                                       c_StepDatosGenerales, _
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

Private Function pGetTipoComprobante() As cIABMProperty
  Set pGetTipoComprobante = GetWizProperty(m_ObjWizard, _
                                    c_StepDatosGenerales, _
                                    c_Wiz_Key_TipoComprobante)
End Function

Private Function pGetFecha() As cIABMProperty
  Set pGetFecha = GetWizProperty(m_ObjWizard, _
                                 c_StepDatosGenerales, _
                                 c_Wiz_Key_Fecha)
End Function

Private Function pCheckOrdenes() As Boolean
  Dim Row As cIABMGridRow
  For Each Row In pGetOrdenes().Rows
    If pCell(Row, KI_SELECT).Id Then
      pCheckOrdenes = True
      Exit Function
    End If
  Next
  
  MsgWarning LNGGetText(1921, vbNullString) 'Debe indicar una o más Ordenes de Compra.
End Function

Private Function pCheckPercepciones() As Boolean
  pCheckPercepciones = True
End Function

'nrs
Private Function pCheckItems() As Boolean
  Dim Row                 As cIABMGridRow
  Dim bExistsSelected     As Boolean
  Dim i                   As Long
  
  For Each Row In pGetItems().Rows
    i = i + 1
    If Val(pCell(Row, KII_APLICAR).Value) > 0 Then
      If Not pValidateRowItems(Row, i) Then Exit Function
      bExistsSelected = True
      If Not Val(pCell(Row, KII_PRECIO_SIN_IVA).Value) <> 0 Then
        MsgWarning LNGGetText(1667, vbNullString, i)
                  'Debe indicar un precio para el item (1)
        Exit Function
      End If
    End If
  Next

  If Not bExistsSelected Then
    MsgWarning LNGGetText(1678, vbNullString) 'Debe indicar uno o más items.
    Exit Function
  End If
  
  If Not Val(pGetTotalItems.Value) > 0 Then
    MsgWarning LNGGetText(1678, vbNullString) 'Debe indicar uno o más items.
    Exit Function
  End If
  
  pCheckItems = True
End Function

Private Function pValidateRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim strRow                As String
  Dim bLlevaNroSerie        As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bLlevaNroSerie = pCell(Row, KI_PR_LLEVANROSERIE).Id
  If ValEmpty(pCell(Row, KI_NROSERIE).Value, csText) And bLlevaNroSerie Then
    MsgInfo LNGGetText(1630, vbNullString, strRow)
            'Debe indicar un numero de serie (1)
    Exit Function
  End If
  
  If ValEmpty(pCell(Row, KII_TO_ID).Id, csId) Then
    MsgInfo LNGGetText(1633, vbNullString, strRow)
          'Debe indicar un tipo de operación (1)
    Exit Function
  End If
  
  If ValEmpty(pCell(Row, KI_STL_ID).Value, csText) And pCell(Row, KI_PR_LLEVALOTE).Id Then
    MsgInfo LNGGetText(1632, vbNullString, strRow)
            'Debe indicar un lote (1)
    Exit Function
  End If
  
  pValidateRowItems = True
End Function

Private Function pGetOrdenesIds() As String
  Dim Row         As cIABMGridRow
  Dim Ids         As String
  
  For Each Row In pGetOrdenes().Rows
    If pCell(Row, KI_SELECT).Id Then
      Ids = Ids & pCell(Row, KI_OC_ID).Id & ","
    End If
  Next
  
  pGetOrdenesIds = RemoveLastColon(Ids)
End Function

Private Function pLoadItemsXOrdenes() As Boolean
  Dim sqlstmt           As String
  Dim rs                As Recordset
  Dim f                 As cIABMGridRow
  Dim fv                As cIABMGridCellValue
  Dim i                 As Long
  
  sqlstmt = "sp_DocFacturaCompraGetOrdenItems '" & pGetOrdenesIds & "'"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  With pGetItems().Rows
    
    .Clear
  
    While Not rs.EOF
    
      With .Add(Nothing)
      
        ' La primera no se usa
        With .Add(Nothing)
          .Id = gDB.ValField(rs.fields, cscOciId)
          .Key = KII_OCI_ID
        End With
        
        With .Add(Nothing)
          .Value = 0
          .Key = KII_SELECT
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOcNrodoc)
          .Key = KI_NRODOC
        End With
    
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOcNumero)
          .Id = gDB.ValField(rs.fields, cscOcId)
          .Key = KI_OC_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPrNombrecompra)
          .Id = gDB.ValField(rs.fields, cscPrId)
          .Key = KII_ARTICULO
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOciPrecio & "2")
          .Key = KII_PRECIO_SIN_IVA
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOciCantidadaremitir)
          .Key = KII_CANTIDAD
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOciPendienteFac)
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
          .Value = gDB.ValField(rs.fields, cscOciImporte)
          .Key = KII_TOTAL
        End With
        
        With .Add(Nothing)
          .Id = C_TO_ComercialId
          .Value = C_TO_Comercial
          .Key = KII_TO_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOciDescrip)
          .Key = KII_DESCRIP
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOciPrecio)
          .Key = KII_PRECIOIVA
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOciPrecioLista)
          .Key = KII_PRECIO_LP
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOciPrecioUsr)
          .Key = KII_PRECIO_USR
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOciIvariPorc)
          .Key = KII_IVARIPercent
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOciIvarniPorc)
          .Key = KII_IVARNIPercent
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOciDescuento)
          .Key = KII_DESCUENTO
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscCcosId)
          .Key = KII_CCOS_ID
        End With
        
        ' Lote
        '
        With .Add(Nothing)
          If m_bShowStockData Then
            .Id = gDB.ValField(rs.fields, cscPrLlevaNroLote)
          Else
            .Id = False
          End If
          .Key = KI_PR_LLEVALOTE
        End With
        
        'nrs
        With .Add(Nothing)
          If m_bShowStockData Then
            .Id = gDB.ValField(rs.fields, cscPrLlevaNroSerie)
          Else
            .Id = False
          End If
          .Key = KI_PR_LLEVANROSERIE
        End With
        
        With .Add(Nothing)
          .Id = 0
          .Key = KI_GRUPO
        End With
        
      End With
      
      rs.MoveNext
      
    Wend
    
  End With
  
  'nrs
  CollClear m_NrosSerie
  
  pRefreshItems
  pShowTotalItems
  
  pLoadItemsXOrdenes = True
End Function

Private Function pLoadOrdenesXProveedor() As Boolean
  Dim sqlstmt           As String
  Dim rs                As Recordset
  Dim oc_id             As Long
  
  ' Edit From ListDoc
  '
  Dim bSelected         As Boolean
  Dim bOnlySelected     As Boolean
  
  sqlstmt = "sp_DocFacturaCompraGetOrdenes " & EmpId & "," & pGetProveedor & ", " & GetMonIdFromDoc(pGetDoc)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  ' Edit From ListDoc
  '
  bOnlySelected = pGetOnlySelected().Value
  
  With pGetOrdenes().Rows
  
    .Clear
  
    While Not rs.EOF
    
      ' Edit From ListDoc
      '
      oc_id = gDB.ValField(rs.fields, cscOcId)
      
      bSelected = pGetApply(oc_id)
      If Not bOnlySelected Or bSelected Then
        
        With .Add(Nothing)
          
          ' La primera no se usa
          .Add Nothing
          
          With .Add(Nothing)
            .Id = CInt(bSelected)
            .Key = KI_SELECT
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscDocNombre)
            .Key = KI_DOC
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscOcNrodoc)
            .Key = KI_NRODOC
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscOcNumero)
            .Id = gDB.ValField(rs.fields, cscOcId)
            .Key = KI_OC_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscOcFecha)
            .Key = KI_FECHA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscOcTotal)
            .Key = KI_TOTAL
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscOcDescrip)
            .Key = KI_DESCRIP
          End With
        End With
      End If
      
      rs.MoveNext
    Wend
  End With
  
  pRefreshOrdenes
  pShowTotalOrdenes
  
  pLoadOrdenesXProveedor = True
End Function

' Edit From ListDoc
'
Private Function pGetApply(ByVal oc_id As Long) As Boolean
  Dim i As Long
  
  For i = 1 To UBound(m_OcIds)
    If m_OcIds(i) = oc_id Then
      pGetApply = True
      Exit Function
    End If
  Next
End Function

' Validaciones de Filas de Instrumentos de cobro
Private Function pIsEmptyRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KII_OCI_ID, KII_ARTICULO, KII_PENDIENTE
        If Not ValEmpty(Cell.Id, csId) Then
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
  
  sqlstmt = "sp_proveedorGetTalonario " & pGetProveedor() & "," & pGetDoc()
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
  With pGetProveedor2
    .HelpId = pGetProveedor
    .Value = pGetProveedorName
  End With
  m_ObjWizard.ShowValue pGetProveedor2
  pGetDocNumber
End Sub

Private Function pValidateDatosGenerales() As Boolean
  If ValEmpty(pGetFecha().Value, csDate) Then
    MsgWarning LNGGetText(1669, vbNullString) 'Debe indicar la fecha de la factura
    Exit Function
  End If
  
  If ValEmpty(pGetCondicionPago().HelpId, csId) Then
    MsgWarning LNGGetText(1561, vbNullString) 'Debe indicar la condicion de pago
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

  'nrs
  Set m_NrosSerie = New Collection
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  ReDim m_OcIds(0)

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
  ReDim m_OcIds(0)
  Set m_ObjClient = Nothing
  
  'nrs
  CollClear m_NrosSerie
  Set m_NrosSerie = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

'///////////////////////////////////////////////////////////////////////////////
Private Sub pGetSave(ByRef register As cRegister, _
                     ByRef Comp As cIABMProperty, _
                     ByRef bIvaRni As Boolean, _
                     ByRef Cotizacion As Double, _
                     ByRef bMonedaLegal As Boolean)
  
  Dim Neto         As Double
  Dim IvaRi        As Double
  Dim IvaRni       As Double
  Dim TotalOrigen  As Double
  Dim TotalPercep  As Double

  With register
    .fieldId = cscFcTMPId
    .Table = csTFacturaCompraTMP
    
    .Id = csNew
    
    ' Header
    With .fields
      .Add2 cscFcNumero, 0, csLong
      
      ' PrintDoc
      '
      m_LastNroDoc = SetMask(Comp.Value, Comp.TextMask)
      .Add2 cscFcNrodoc, m_LastNroDoc, csText
      
      .Add2 cscFcDescrip, pGetDescrip().Value, csText
      .Add2 cscFcFecha, pGetFecha().Value, csDate
      .Add2 cscProvId, pGetProveedor(), csId
      .Add2 cscCcosId, pGetCentroCosto().HelpId, csId
      .Add2 cscSucId, pGetSucursal().HelpId, csId
      .Add2 cscCpgId, pGetCondicionPago().HelpId, csId
      .Add2 cscLpId, pGetListaPrecio().HelpId, csId
      .Add2 cscLdId, pGetListaDescuento().HelpId, csId
      .Add2 cscDocId, pGetDoc(), csId
      .Add2 cscLgjId, pGetLegajo().HelpId, csId
      .Add2 cscFcGrabarAsiento, 1, csBoolean
      .Add2 cscFcTipoComprobante, pGetTipoComprobante().ListItemData, csInteger
      .Add2 cscDeplId, WizGetDeposito(m_ObjWizard, c_StepSelectProveedor, c_Wiz_Key_Deposito), csId
    
      Cotizacion = Val(pGetCotizacion.Value)
      .Add2 cscFcCotizacion, Cotizacion, csDouble
      
      .Add2 cscEstId, CSGeneralEx2.csEEstado.csEEst_Pendiente, csId
      .Add2 cscFcId, csNew, csLong
      
      bIvaRni = IsRNI(pGetProveedor)
      pGetFooter Neto, IvaRi, IvaRni, bIvaRni
    
      ' Manejo de la moneda y la cotizacion
      '
      bMonedaLegal = GetMonedaDefault = GetMonIdFromDoc(pGetDoc)
      If bMonedaLegal Then
        Cotizacion = 1
      Else
        If Cotizacion = 0 Then Cotizacion = 1
      End If
      
      TotalPercep = Val(pGetTotalPercepciones().Value)
      
      ' Footer
      .Add2 cscFcSubtotal, Neto * Cotizacion, csCurrency
      .Add2 cscFcNeto, Neto * Cotizacion, csCurrency
      .Add2 cscFcIvari, IvaRi * Cotizacion, csCurrency
      .Add2 cscFcIvarni, IvaRni * Cotizacion, csCurrency
      .Add2 cscFcTotalPercepciones, TotalPercep * Cotizacion, csCurrency
      
      TotalOrigen = Neto + TotalPercep
      If m_bIva Then
        TotalOrigen = TotalOrigen + IvaRi
      End If
      If m_bIvaRni Then
        TotalOrigen = TotalOrigen + IvaRni
      End If
      
      If bMonedaLegal Then
        .Add2 cscFcTotalOrigen, 0, csCurrency
      Else
        .Add2 cscFcTotalOrigen, TotalOrigen, csCurrency
      End If
      
      .Add2 cscFcTotal, TotalOrigen * Cotizacion, csCurrency ' Por ahora no hay descuentos
      
      .HaveLastUpdate = True
      .HaveWhoModify = True
      
    End With
  End With
End Sub

Private Function pSave() As Boolean
  Dim register     As cRegister
  Dim bIvaRni      As Boolean
  Dim Cotizacion   As Double
  Dim bMonedaLegal As Boolean
  Dim Mouse        As cMouseWait

  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  
  pGetSave register, pGetComprobante(), bIvaRni, Cotizacion, bMonedaLegal
  
  With register
  
    If Not .BeginTrans(gDB) Then Exit Function
    
    If Not gDB.Save(register, , "pSave", C_Module, c_ErrorSave) Then Exit Function
    
    If Not pSaveItems(.Id, Cotizacion, bMonedaLegal, bIvaRni) Then Exit Function
    
    If Not SavePercepciones(pGetPercepcionesProperty, _
                            .Id, Cotizacion, bMonedaLegal, _
                            False, vbNullString, _
                            csNO_ID, C_Module) Then Exit Function
    
    If Not pSaveVinculacion(.Id) Then Exit Function
    
    If Not .CommitTrans() Then Exit Function
    
  End With
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocFacturaCompraSave " & register.Id
  If Not gDB.OpenRs(sqlstmt, rs, , , , "pSave", C_Module, c_ErrorSave) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim Id As Long
  If Not GetDocIDFromRecordset(rs, Id) Then Exit Function
  
  m_Id = Id
  
  pSave = m_Id <> 0
End Function

Private Function pSaveItems(ByVal Id As Long, ByVal Cotizacion As Double, ByVal bMonedaLegal As Boolean, ByVal bIvaRni As Boolean) As Boolean
  
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
  Dim Importe   As Double
  Dim Cantidad  As Double
  Dim sqlstmt   As String
  
  'nrs
  ' Para numeros de serie
  '
  Dim iOrden2     As Long
  Dim iOrden3     As Long
  Dim PrId        As Long
  
  For Each Row In pGetItems().Rows
  
    iOrden3 = iOrden3 + 1
    
    If Val(pCell(Row, KII_APLICAR).Value) Then
    
      Set register = New cRegister
      register.fieldId = cscFciTMPId
      register.Table = csTFacturaCompraItemTMP
      register.Id = csNew
      
      For Each Cell In Row
        Select Case Cell.Key
          Case KII_APLICAR
            Cantidad = Cell.Value
            register.fields.Add2 cscFciCantidad, Cell.Value, csDouble
          Case KII_DESCRIP
            register.fields.Add2 cscFciDescrip, Cell.Value, csText
          Case KII_PRECIO_SIN_IVA
            Precio = Val(Cell.Value) * Cotizacion
            register.fields.Add2 cscFciPrecio, Precio, csCurrency
          Case KII_PRECIO_LP
            register.fields.Add2 cscFciPrecioLista, Val(Cell.Value) * Cotizacion, csCurrency
          Case KII_PRECIO_USR
            register.fields.Add2 cscFciPrecioUsr, Val(Cell.Value) * Cotizacion, csCurrency
          Case KII_DESCUENTO
            register.fields.Add2 cscFciDescuento, Val(Cell.Value) * Cotizacion, csText
          Case KII_IVARIPercent
            IvaRi = Cell.Value
            register.fields.Add2 cscFciIvariporc, IvaRi, csDouble
          Case KII_IVARNIPercent
            If bIvaRni Then
              IvaRni = Cell.Value
            End If
            register.fields.Add2 cscFciIvarniporc, IvaRni, csDouble
          Case KII_ARTICULO
            'nrs
            PrId = Cell.Id
            register.fields.Add2 cscPrId, PrId, csId
          Case KII_CCOS_ID
            register.fields.Add2 cscCcosId, Cell.Id, csId
          ' Lote
          '
          Case KI_STL_ID
            register.fields.Add2 cscStlCodigo, Cell.Value, csText
          ' TO
          Case KII_TO_ID
            register.fields.Add2 cscToId, Cell.Id, csId
        End Select
      Next
    
      Neto = Precio * Cantidad
      register.fields.Add2 cscFciNeto, Neto, csCurrency
      
      IvaRi = Neto * IvaRi / 100
      register.fields.Add2 cscFciIvari, IvaRi, csCurrency
      
      IvaRni = Neto * IvaRni / 100
      register.fields.Add2 cscFciIvarni, IvaRni, csCurrency
      
      Importe = Neto + IvaRi + IvaRni
      register.fields.Add2 cscFciImporte, Importe, csCurrency
      
      If bMonedaLegal Then
        register.fields.Add2 cscFciImporteOrigen, 0, csCurrency
      Else
        register.fields.Add2 cscFciImporteOrigen, DivideByCero(Importe, Cotizacion), csCurrency
      End If
      
      ' Esto es muy importante ya que se usa para vincular el ordencompraitem
      ' con el nuevo Facturacompraitem
      iOrden = iOrden + 1
      register.fields.Add2 cscFciOrden, iOrden, csInteger
      
      register.fields.Add2 cscFcTMPId, Id, csId
      register.fields.Add2 cscFciId, Id, csLong
      
      ' Cuentas contables - Por ahora se resuelve asi
      register.fields.Add2 cscCueId, -1, csId
      register.fields.Add2 cscCueIdIvaRI, -1, csId
      register.fields.Add2 cscCueIdIvaRNI, -1, csId
      
      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
    
      'nrs
      If Not pSaveItemNroSerie(Row, iOrden2, PrId, Id, register.Id, iOrden3 * -1) Then Exit Function
    End If
  Next
  
  sqlstmt = "sp_DocFacturaCompraWizardSave " & Id
  If Not gDB.Execute(sqlstmt, "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
  
  pSaveItems = True
End Function

Private Function pSaveVinculacion(ByVal Id As Long) As Boolean
  Dim register        As cRegister
  Dim iOrden          As Long
  Dim bSave           As Boolean
  Dim Row             As cIABMGridRow
  Dim Cell            As cIABMGridCellValue
  
  For Each Row In pGetItems().Rows
  
    Set register = New cRegister
    register.fieldId = cscOcFcTMPId
    register.Table = csTOrdenFacturaCompraTMP
    register.Id = csNew
    
    bSave = False
    For Each Cell In Row
      If pCell(Row, KII_SELECT).Id Then
        bSave = True
        Select Case Cell.Key
          Case KII_OCI_ID
            register.fields.Add2 cscOciId, Cell.Id, csId
          Case KII_APLICAR
            register.fields.Add2 cscOcFcCantidad, Cell.Value, csDouble
        End Select
      End If
    Next
    
    If bSave Then
      
      register.fields.Add2 cscOcFcId, 0, csLong
      register.fields.Add2 cscFcTMPId, Id, csId
      
      ' Esto es muy importante ya que se usa para vincular el ordencompraitem
      ' con el nuevo Facturacompraitem
      iOrden = iOrden + 1
      register.fields.Add2 cscFciId, iOrden, csLong
      
      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSaveVinculacion", C_Module, c_ErrorSave) Then Exit Function
    End If
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
  
    If pCell(Row, KII_SELECT).Id Then
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
                                   ByVal FcTMPId As Long, _
                                   ByVal FciTMPId As Long, _
                                   ByVal Grupo As Long) As Boolean
                                   
  Dim pt        As cProductoSerieType
  Dim register  As cRegister
  
  ' Si lleva numero de serie
  '
  If pCell(Row, KI_PR_LLEVANROSERIE).Id Then
  
    ' Obtengo los numeros de serie y guardo un Item por cada uno
    '
    For Each pt In m_NrosSerie.Item(GetKey(Grupo))
      
      Set register = New cRegister
      register.fieldId = cscFcisTMPId
      register.Table = csTFacturaCompraItemSerieTMP
      register.Id = csNew
      
      register.fields.Add2 cscPrId, PrId, csId
      
      register.fields.Add2 cscPrnsId, pt.prns_id, csId
      
      register.fields.Add2 cscPrnsCodigo, pt.codigo, csText
      register.fields.Add2 cscPrnsDescrip, pt.Descrip, csText
      register.fields.Add2 cscPrnsFechavto, pt.FechaVto, csDate
      
      register.fields.Add2 cscFcTMPId, FcTMPId, csId
      register.fields.Add2 cscFciTMPId, FciTMPId, csId
      
      iOrden = iOrden + 1
      register.fields.Add2 cscFcisOrden, iOrden, csInteger
      
      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False
                                                                'Error al grabar el Factura de compra
      If Not gDB.Save(register, , "pSaveItemNroSerie", C_Module, LNGGetText(1907, vbNullString)) Then Exit Function
      
    Next
  End If
  
  pSaveItemNroSerie = True
End Function

Private Sub pSetDatosProveedor()
  Dim lp_id       As Long
  Dim ld_id       As Long
  Dim cpg_id      As Long
  Dim cpg_nombre  As String
  Dim LP          As cListaPrecio
  Dim LD          As cListaDescuento
  Dim iProp       As cIABMProperty
  Dim Filter      As String
  
  With pGetProveedorProp()
    If m_LastProv = .HelpId Then
      Exit Sub
    End If
    m_LastProv = .HelpId
  End With

  If Not GetProveedorDataEx(m_LastProv, lp_id, ld_id, cpg_id, m_LastDoc) Then Exit Sub
  
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
  iProp.HelpFilter = GetListaPrecioGetXProveedor(m_LastDoc, m_LastProv)
  
  If lp_id <> csNO_ID Then
    Set LP = New cListaPrecio
    iProp.Value = LP.GetData(lp_id, cscLpNombre, csText)
    iProp.HelpId = lp_id
  End If
  
  m_ObjWizard.ShowValue iProp
  
  ' Lista de descuentos
  Set iProp = pGetListaDescuento()
  iProp.HelpFilter = GetListaDescGetXProveedor(m_LastDoc, m_LastProv)
  
  If ld_id <> csNO_ID Then
    Set LD = New cListaDescuento
    iProp.Value = LD.GetData(ld_id, cscLdNombre, csText)
    iProp.HelpId = ld_id
  End If
  
  m_ObjWizard.ShowValue iProp
  
  ' Talonario y Categoria fiscal
  pGetIvaFromProveedor m_LastProv, m_bIva, m_bIvaRni
End Sub

Private Sub pNewEmptyProperties()
  ' (ByRef Grid As cIABMGrid)
  
  pGetOrdenes().Rows.Clear
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
  With pGetLegajo()
    .HelpId = csNO_ID
    .Value = vbNullString
  End With
  
  pGetDescrip().Value = vbNullString
  
  With m_ObjWizard
    .ShowValue pGetOrdenesProperty()
    .ShowValue pGetItemsProperty()
    .ShowValue pGetPercepcionesProperty()
    .ShowValue pGetComprobante()
    .ShowValue pGetCentroCosto()
    .ShowValue pGetCondicionPago()
    .ShowValue pGetListaPrecio()
    .ShowValue pGetListaDescuento()
    .ShowValue pGetLegajo()
    .ShowValue pGetDescrip()
  End With
  
End Sub
