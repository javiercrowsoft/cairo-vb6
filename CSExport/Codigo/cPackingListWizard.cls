VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPackingListWizard"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIWizardClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cPackingListWizard
' 04-05-2004

'--------------------------------------------------------------------------------
' notas:

  ' Al copiar a factura acordate que tenes que agregar grabarasiento al save

' Reemplazar

' Asistente de Facturas

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cPackingListWizard"

Private Const c_StepWelcome             As Integer = 1
Private Const c_StepSelectCliente       As Integer = 3
Private Const c_StepSelectPedido        As Integer = 4
Private Const c_StepSelectItems         As Integer = 6
Private Const c_StepDatosGenerales      As Integer = 7

Private Const c_Wiz_Key_ResultTitle = "RESULTT"
Private Const c_Wiz_Key_Result = "RESULT"
Private Const c_Wiz_Key_Cliente = "CLIENT"

Private Const c_Wiz_Key_Doc = "DOC"
Private Const c_Wiz_Key_Pedidos = "PEDIDOS"
Private Const c_Wiz_Key_Todos = "TODOS"
Private Const c_Wiz_Key_OnlySelected = "ONLYSEL" ' Edit From ListDoc

Private Const c_Wiz_Key_Items = "ITEMS"
Private Const c_Wiz_Key_TodosItems = "TODOS-ITEMS"

Private Const c_Wiz_Key_Total = "Total"
Private Const c_Wiz_Key_TotalItems = "TotalItems"
Private Const c_Wiz_Key_Pendiente = "Pendiente"

Private Const c_Wiz_Key_Fecha = "Fecha"
Private Const c_Wiz_Key_Cliente2 = "Cliente"
Private Const c_Wiz_Key_Sucursal = "Sucursal"
Private Const c_Wiz_Key_CondicionPago = "Condición de Pago"
Private Const c_Wiz_Key_Observaciones = "Observaciones"
Private Const c_Wiz_Key_Marca = "Marcas"
Private Const c_Wiz_Key_Comprobante = "Comprobante"
Private Const c_Wiz_Key_Legajo = "Legajo"
Private Const c_Wiz_Key_CentroCosto = "Centro de Costo"
Private Const c_Wiz_Key_ListaPrecio = "Lista de Precio"
Private Const c_Wiz_Key_ListaDescuento = "Lista de Descuento"

Private Const c_Wiz_Key_PuertoOrigen = "Puerto origen"
Private Const c_Wiz_Key_PuertoDestino = "Puerto destino"

Private Const c_Wiz_Key_Barco = "Barco"

Private Const KW_PEDIDOS                     As Integer = 10
Private Const KW_TODOS                       As Integer = 110
Private Const KW_ITEMS                       As Integer = 120
Private Const KW_TODOS_ITEMS                 As Integer = 130
Private Const KW_CLIENTE2                    As Integer = 220
Private Const KW_FECHA                       As Integer = 230
Private Const KW_SUCURSAL                    As Integer = 240
Private Const KW_CONDICION_PAGO              As Integer = 245
Private Const KW_DESCRIP                     As Integer = 250
Private Const KW_MARCAS                      As Integer = 255
Private Const KW_COMPROBANTE                 As Integer = 260
Private Const KW_LEGAJO                      As Integer = 280
Private Const KW_CENTROCOSTO                 As Integer = 290
Private Const KW_LP_ID                       As Integer = 300
Private Const KW_LD_ID                       As Integer = 310

Private Const KW_PUE_ID_ORIGEN               As Integer = 320
Private Const KW_PUE_ID_DESTINO              As Integer = 340

Private Const KW_BARC_ID                     As Integer = 350

Private Const KW_DOC_ID                      As Integer = 360
Private Const KW_CLI_ID                      As Integer = 370

Private Const KI_PV_ID                       As Integer = 1
Private Const KI_SELECT                      As Integer = 2
Private Const KI_DOC                         As Integer = 3
Private Const KI_NRODOC                      As Integer = 4
Private Const KI_FECHA                       As Integer = 5
Private Const KI_DESCRIP                     As Integer = 8
Private Const KI_TOTAL                       As Integer = 10

Private Const KII_SELECT                 As Integer = 1
Private Const KII_PVI_ID                 As Integer = 2
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
Private Const KII_PALLETS                As Integer = 19
Private Const KII_CAJA_DESDE             As Integer = 20
Private Const KII_CAJA_HASTA             As Integer = 21
Private Const KII_GRUPO_EXPO             As Integer = 22
Private Const KII_PESO_NETO              As Integer = 23
Private Const KII_PESO_TOTAL             As Integer = 24
Private Const KII_UNIDAD_PESO            As Integer = 25

' estructuras
Private Type T_Iva
  Importe         As Double
  Porcentaje      As Double
End Type
Private Type T_Item
  Importe         As Double
  ImporteIva      As Double
  TasaIva         As Double
End Type

' Seudo - Variables
Private c_ErrorSave         As String

' variables privadas
Private m_ObjWizard               As cIWizardGeneric

Private m_WizardProcessing        As Boolean
Private m_WizardCancel            As Boolean

'Private m_Resource                As fResource

Private m_GeneralConfig     As cGeneralConfig

Private m_Id                As Long

Private m_cli_id            As Long
Private m_Cliente           As String
Private m_doc_id            As Long
Private m_Documento         As String
Private m_PvIds()           As Long

Private m_bIva              As Boolean
Private m_bIvaRni           As Boolean

Private m_LastCli           As Long
Private m_LastDoc           As Long

' PrintDoc
'
Private m_LastNroDoc        As String

Private m_ObjClient         As Object
' eventos
' propiedades publicas
Public Property Get ID() As Long
  ID = m_Id
End Property

Public Property Let doc_id(ByVal rhs As Long)
  m_doc_id = rhs
End Property

Public Property Let Documento(ByVal rhs As String)
  m_Documento = rhs
End Property

Public Property Let Cli_id(ByVal rhs As Long)
  m_cli_id = rhs
End Property

Public Property Let Cliente(ByVal rhs As String)
  m_Cliente = rhs
End Property

Public Property Let PvIds(ByRef rhs() As Long)
  On Error Resume Next
  Dim i As Long
  ReDim m_PvIds(UBound(rhs))
  For i = 0 To UBound(rhs)
    m_PvIds(i) = rhs(i)
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
    Case KW_PEDIDOS
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
    Case KW_PEDIDOS
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdatePedido(pGetPedidosProperty(), lRow, lCol)
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
    Case KW_PEDIDOS
      cIABMClientGrid_ColumnAfterEdit = True
    Case KW_ITEMS
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
    Case KW_PEDIDOS
      cIABMClientGrid_ColumnBeforeEdit = pColBEditPedidos(pGetPedidosProperty(), lRow, lCol, iKeyAscii)
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

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim ID As Long
  
  Select Case Key
    Case KW_PEDIDOS
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
    Case KW_PEDIDOS
      cIABMClientGrid_ValidateRow = True
    Case KW_ITEMS
      cIABMClientGrid_ValidateRow = True
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pColBEditItems(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  Select Case pGetKeyFromCol(IProperty.Grid.Columns, lCol)
    ' Pedidos
    Case KII_SELECT, KII_APLICAR, KII_CAJA_DESDE, KII_CAJA_HASTA, KII_GRUPO_EXPO, KII_PALLETS, KII_PESO_NETO, KII_PESO_TOTAL
    Case Else
      Exit Function
  End Select

  pColBEditItems = True
End Function

Private Function pColBEditPedidos(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  Select Case pGetKeyFromCol(IProperty.Grid.Columns, lCol)
    ' Pedidos
    Case KI_SELECT
    Case Else
      Exit Function
  End Select
  
  pColBEditPedidos = True
End Function

Private Function pColAUpdatePedido(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long)
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KI_SELECT
        pShowTotalPedidos
    End Select
  End With
  
  pColAUpdatePedido = True
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
        pSetPrecioIva Row
        pShowTotalItems
    End Select
  End With
  
  pColAUpdateItems = True
End Function

Private Sub pSelectAllPedidos(ByVal bSelect As Boolean)
  Dim Row As cIABMGridRow
  
  With pGetPedidos
    For Each Row In .Rows
      pCell(Row, KI_SELECT).ID = CInt(bSelect)
    Next
  End With
  
  Dim ObjWiz As cWizardGeneric
  Set ObjWiz = m_ObjWizard
  
  ObjWiz.ShowValue pGetPedidosProperty, True
End Sub

Private Sub pSelectAllItems(ByVal bSelect As Boolean)
  Dim Row As cIABMGridRow
  
  With pGetItems
    For Each Row In .Rows
      pCell(Row, KII_SELECT).ID = CInt(bSelect)
      pSelectItem Row, .Columns
    Next
  End With
  
  Dim ObjWiz As cWizardGeneric
  Set ObjWiz = m_ObjWizard
  
  ObjWiz.ShowValue pGetItemsProperty, True
End Sub

Private Sub pSelectItem(ByRef Row As cIABMGridRow, ByRef Columns As cIABMGridColumns)
  With pCell(Row, KII_APLICAR)
    If pCell(Row, KII_SELECT).ID Then
      If Val(.Value) = 0 Then
        .Value = pCell(Row, KII_PENDIENTE).Value
      End If
    Else
      .Value = 0
    End If
  End With
End Sub


Private Sub pShowTotalPedidos()
  Dim Row           As cIABMGridRow
  Dim Total         As Double
  
  For Each Row In pGetPedidos().Rows
    If pCell(Row, KI_SELECT).ID Then
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
      
    Case c_StepSelectCliente
    
      If pGetDoc() = csNO_ID Then
        MsgWarning LNGGetText(1562, vbNullString) 'Debe indicar un documento
        nNextStep = c_StepSelectCliente
      ElseIf pGetCliente() = csNO_ID Then
        MsgWarning LNGGetText(1563, vbNullString) 'Debe indicar un cliente
        nNextStep = c_StepSelectCliente
      ElseIf Not pLoadPedidosXCliente() Then
        MsgWarning LNGGetText(1684, vbNullString)
                    'No se pudieron cargar los pedidos para este cliente
        nNextStep = c_StepSelectCliente
      Else
        pGetTodos.Name = c_selectall
        m_ObjWizard.ShowValue pGetTodos
        m_ObjWizard.cmdBack.Enabled = True
        nNextStep = c_StepSelectPedido
      End If
      
    Case c_StepSelectPedido
      If Not pChecPedidos() Then
        nNextStep = c_StepSelectPedido
      ElseIf Not pLoadItemsXPedidos() Then
        MsgWarning LNGGetText(1685, vbNullString), LNGGetText(1607, vbNullString)
          'No se pudieron cargar los items de los pedidos para este cliente, Facturas
        nNextStep = c_StepSelectPedido
      Else
        nNextStep = c_StepSelectItems
      End If
    
    Case c_StepSelectItems
      If Not pChecItems() Then
        nNextStep = c_StepSelectItems
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

    Case c_StepSelectCliente
      nNextStep = c_StepSelectCliente
    
    Case c_StepSelectPedido
      m_ObjWizard.cmdBack.Enabled = False
      nNextStep = c_StepSelectCliente
    
    Case c_StepSelectItems
      nNextStep = c_StepSelectPedido
    
    Case c_StepDatosGenerales
      m_ObjWizard.cmdNext.Caption = c_WizStr_Next
      nNextStep = c_StepSelectItems
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
      pNewEmptyProperties
      WizNewDoc m_ObjWizard, c_StepWelcome
    
    Case KW_TODOS
      If pGetTodos.Name = c_selectall Then
        pSelectAllPedidos True
        pGetTodos.Name = c_unselectall
      Else
        pSelectAllPedidos False
        pGetTodos.Name = c_selectall
      End If
      m_ObjWizard.ShowValue pGetTodos
      pShowTotalPedidos
  
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
    
    Case KW_CLI_ID
      pSetDatosCliente
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
  cIWizardClient_Title = LNGGetText(2536, vbNullString) ' Asistente de Packing List
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
  Set AbmObj = Wizard.ObjABM
  AbmObj.MinHeight = 7000
  
  sh.Move 0, 0, 9000, 7000
  sh.BorderStyle = 0
  sh.BackColor = vbWhite

  Dim Img As Image
  Set Img = m_ObjWizard.EditGeneric.PicMain

  Img.Visible = False

  pLoadStepWelcome
  pLoadStepSelectCliente
  pLoadStepSelectPedido
  pLoadStepSelectItems
  pLoadStepDatosGenerales

  LoadSteps = True
End Function

Private Sub pLoadStepWelcome()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepWelcome)).Properties
    With .Add(Nothing)
      .Top = 0
      .Left = 0
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 1
      'Set .Picture = m_Resource.ImgWiz1.Picture
    End With

    With .Add(Nothing, c_Wiz_Key_Title)
      .Top = 100
      .Left = 2700
      .TopNotChange = True
      .LeftNotChange = True
      .Height = 880
      .Width = 7000
      .PropertyType = cspTitle
      .Value = LNGGetText(2553, vbNullString) 'Bienvenido al Asistente de Facturas de Venta
    End With
    
    With .Add(Nothing, c_Wiz_Key_MainTitle)
      .Top = 1200
      .Left = 3000
      .PropertyType = cspLabel
      .Width = 6000
      .Height = 880
      .FontBold = True
      .Value = LNGGetText(1686, vbNullString)
              'Con este asistente usted podra generar las facturas sobre pedidos.
    End With
    
    WizAddNewDocProperties m_ObjWizard, c_StepWelcome
    
  End With
End Sub

Private Sub pLoadStepSelectCliente()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepSelectCliente)).Properties
    With .Add(Nothing)
      .Top = 100
      .Left = 100
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 3
      'Set .Picture = m_Resource.ImgWiz3.Picture
    End With

    With .Add(Nothing)
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
      .Name = LNGGetText(1567, vbNullString) 'Documento
      .PropertyType = cspHelp
      .HelpFilter = "'doct_id = " & csEDT_PackingList & "'"
      .Table = CSDocumento2.CSDocumento
      .Width = 4000
      .Value = m_Documento
      .HelpId = m_doc_id
      .Key = KW_DOC_ID
    End With
  
    With .Add(Nothing, c_Wiz_Key_Cliente)
      .Top = 2000
      .Left = 3700
      .Name = LNGGetText(1150, vbNullString) 'Cliente
      .PropertyType = cspHelp
      .Table = csCliente
      .Width = 4000
      .Value = m_Cliente
      .HelpId = m_cli_id
      .Key = KW_CLI_ID
    End With
  
    ' Edit From ListDoc
    '
    With .Add(Nothing, c_Wiz_Key_OnlySelected)
      .PropertyType = cspCheck
      .Name = LNGGetText(1687, vbNullString) 'Cargar solo pedidos seleccionados
      .Value = UBound(m_PvIds)
      .Left = 5310
      .LeftLabel = -2800
    End With
  End With
End Sub

Private Sub pLoadStepSelectPedido()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepSelectPedido)).Properties
    With .Add(Nothing)
      .Top = 100
      .Left = 100
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 3
      'Set .Picture = m_Resource.ImgWiz3.Picture
    End With

    With .Add(Nothing)
      .Top = 400
      .Left = 1500
      .TopNotChange = True
      .LeftNotChange = True
      .Height = 880
      .Width = 8000
      .PropertyType = cspLabel
      .FontBold = True
      .Value = LNGGetText(1688, vbNullString) 'Seleccione los pedidos
    End With
    
    With .Add(Nothing, c_Wiz_Key_Pedidos)
      .Top = 1100
      .Left = 150
      .PropertyType = cspGrid
      .LeftLabel = -1
      pLoadPedidos .Grid
      .Width = 11500
      .Height = 4500
      .Key = KW_PEDIDOS
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
      .Name = LNGGetText(1584, vbNullString) 'Total
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

Private Sub pLoadPedidos(ByRef Grid As cIABMGrid)
  Dim Signo As String
  
  ' La primera simpre esta invisible
  With Grid.Columns
    
    .Add(Nothing).Visible = False
  
    With .Add(Nothing)
      .PropertyType = cspCheck
      .Width = 320
      .Key = KI_SELECT
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1223, vbNullString) 'Tipo
      .PropertyType = cspText
      .Width = 3000
      .Key = KI_DOC
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1567, vbNullString) 'Documento
      .PropertyType = cspText
      .Width = 1800
      .Key = KI_NRODOC
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1065, vbNullString) 'Numero
      .PropertyType = cspNumeric
      .Width = 800
      .Key = KI_PV_ID
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1569, vbNullString) 'Fecha
      .PropertyType = cspDate
      .Width = 1040
      .Format = "dd/mm/yy"
      .Key = KI_FECHA
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1584, vbNullString) 'Total
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
      .Top = 100
      .Left = 100
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 3
      'Set .Picture = m_Resource.ImgWiz3.Picture
    End With

    With .Add(Nothing)
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
      .Name = LNGGetText(1584, vbNullString) 'Total
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

Private Sub pLoadItems(ByRef Grid As cIABMGrid)
  ' La primera simpre esta invisible
  With Grid.Columns
    With .Add(Nothing)
      .Visible = False
      .Key = KII_PVI_ID
    End With
    
    With .Add(Nothing)
      .PropertyType = cspCheck
      .Width = 320
      .Key = KII_SELECT
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1567, vbNullString) 'Documento
      .PropertyType = cspText
      .Width = 1400
      .Key = KI_NRODOC
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1932, vbNullString) 'Nro
      .PropertyType = cspNumeric
      .Width = 500
      .Key = KI_PV_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1367, vbNullString) 'Articulo
      .PropertyType = cspText
      .Width = 2000
      .Key = KII_ARTICULO
    End With
  
    With .Add(Nothing, c_Wiz_Key_Pendiente)
      .Name = LNGGetText(1609, vbNullString) 'Pendiente
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 920
      .Key = KII_PENDIENTE
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1662, vbNullString) 'Aplicar
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 800
      .Key = KII_APLICAR
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2510, vbNullString) 'Pallets
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 800
      .Key = KII_PALLETS
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2532, vbNullString) 'Desde
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 700
      .Key = KII_CAJA_DESDE
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2533, vbNullString) 'Hasta
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 700
      .Key = KII_CAJA_HASTA
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1404, vbNullString) 'Grupo
      .PropertyType = cspText
      .Width = 800
      .Key = KII_GRUPO_EXPO
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(2534, vbNullString) 'Peso N.
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 900
      .Key = KII_PESO_NETO
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(2535, vbNullString) 'Peso T.
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 900
      .Key = KII_PESO_TOTAL
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1165, vbNullString) 'Unidad
      .PropertyType = cspText
      .Width = 800
      .Key = KII_UNIDAD_PESO
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1586, vbNullString) 'Precio
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 800
      .Key = KII_PRECIO_SIN_IVA
      .Format = m_GeneralConfig.FormatDecImporte
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1374, vbNullString) 'Cantidad
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 900
      .Key = KII_CANTIDAD
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
    
    With .Add(Nothing, c_Wiz_Key_TotalItems)
      .Name = LNGGetText(1584, vbNullString) 'Total
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 800
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
  End With
End Sub

Private Sub pLoadStepDatosGenerales()
  Dim Filter As String
  
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepDatosGenerales)).Properties
  
    With .Add(Nothing)
      .Top = 100
      .Left = 100
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 3
      'Set .Picture = m_Resource.ImgWiz3.Picture
    End With

    With .Add(Nothing)
      .Top = 400
      .Left = 1500
      .TopNotChange = True
      .LeftNotChange = True
      .Height = 880
      .Width = 8000
      .PropertyType = cspLabel
      .FontBold = True
      .Value = LNGGetText(2554, vbNullString) 'Complete los siguientes datos del Packing List
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
  
    With .Add(Nothing, c_Wiz_Key_Comprobante)
      .PropertyType = cspText
      .Left = 6800
      .TopFromProperty = c_Wiz_Key_Fecha
      .Name = LNGGetText(1610, vbNullString) 'Comprobante
      .Key = KW_COMPROBANTE
    End With
  
    With .Add(Nothing, c_Wiz_Key_ListaPrecio)
      .PropertyType = cspHelp
      .Table = csListaPrecio
      .Name = LNGGetText(1397, vbNullString) 'Lista de Precios
      .Key = KW_LP_ID
      
      Filter = "exists(select lp_id from ListaPrecioCliente where cli_id =" & m_cli_id
      Filter = Filter & " and lp_id = ListaPrecio.lp_id)"
      
      .HelpFilter = Filter
    End With
  
    With .Add(Nothing, c_Wiz_Key_ListaDescuento)
      .PropertyType = cspHelp
      .Table = csListaDescuento
      .Name = LNGGetText(1398, vbNullString) 'Lista de Descuentos
      .Key = KW_LP_ID
      
      Filter = "exists(select ld_id from ListaDescuentoCliente where cli_id =" & m_cli_id
      Filter = Filter & " and ld_id = ListaDescuento.ld_id)"
      
      .HelpFilter = Filter
    End With
  
    With .Add(Nothing, c_Wiz_Key_Legajo)
      .PropertyType = cspHelp
      .Table = csLegajo
      .Name = LNGGetText(1575, vbNullString) 'Legajo
      .Key = KW_LEGAJO
    End With
    
    With .Add(Nothing, c_Wiz_Key_PuertoOrigen)
      .PropertyType = cspHelp
      .Table = csPuerto
      .Name = LNGGetText(2400, vbNullString) 'Puerto Origen
      .Key = KW_PUE_ID_ORIGEN
    End With
    
    With .Add(Nothing, c_Wiz_Key_PuertoDestino)
      .PropertyType = cspHelp
      .Table = csPuerto
      .Name = LNGGetText(2401, vbNullString) 'Puerto Destino
      .Key = KW_PUE_ID_DESTINO
    End With
    
    With .Add(Nothing, c_Wiz_Key_Barco)
      .PropertyType = cspHelp
      .Table = csBarco
      .Name = LNGGetText(2424, vbNullString) 'Barco
      .Key = KW_BARC_ID
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
      .TopFromProperty = c_Wiz_Key_CentroCosto
      .TopToPrevious = 440
      .Height = 880
      .Width = 6250
      .Name = LNGGetText(1861, vbNullString) 'Observaciones
      .Key = KW_DESCRIP
    End With
  
    With .Add(Nothing, c_Wiz_Key_Marca)
      .PropertyType = cspText
      .Left = 7500
      .TopFromProperty = c_Wiz_Key_Marca
      .TopToPrevious = 440
      .Height = 880
      .Width = 3000
      .Name = LNGGetText(1310, vbNullString) 'Marca
      .Key = KW_MARCAS
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

Private Function pGetDoc() As Long
  With m_ObjWizard.Steps.Item(GetKey(c_StepSelectCliente))
    pGetDoc = .Properties.Item(c_Wiz_Key_Doc).HelpId
  End With
End Function

Private Function pGetDocName() As String
  With m_ObjWizard.Steps.Item(GetKey(c_StepSelectCliente))
    pGetDocName = .Properties.Item(c_Wiz_Key_Doc).Value
  End With
End Function

Private Function pGetTodos() As cIABMProperty
  With m_ObjWizard.Steps.Item(GetKey(c_StepSelectPedido))
    Set pGetTodos = .Properties.Item(c_Wiz_Key_Todos)
  End With
End Function

Private Function pGetTodosItems() As cIABMProperty
  With m_ObjWizard.Steps.Item(GetKey(c_StepSelectItems))
    Set pGetTodosItems = .Properties.Item(c_Wiz_Key_TodosItems)
  End With
End Function

Private Function pGetTotal() As cIABMProperty
  With m_ObjWizard.Steps.Item(GetKey(c_StepSelectPedido))
    Set pGetTotal = .Properties.Item(c_Wiz_Key_Total)
  End With
End Function

Private Function pGetTotalItems() As cIABMProperty
  With m_ObjWizard.Steps.Item(GetKey(c_StepSelectItems))
    Set pGetTotalItems = .Properties.Item(c_Wiz_Key_TotalItems)
  End With
End Function

Private Function pGetCliente2() As cIABMProperty
  With m_ObjWizard.Steps.Item(GetKey(c_StepDatosGenerales))
    Set pGetCliente2 = .Properties.Item(c_Wiz_Key_Cliente2)
  End With
End Function

Private Function pGetClienteProp() As cIABMProperty
  With m_ObjWizard.Steps.Item(GetKey(c_StepSelectCliente))
    Set pGetClienteProp = .Properties.Item(c_Wiz_Key_Cliente)
  End With
End Function

Private Function pGetCliente() As Long
  With m_ObjWizard.Steps.Item(GetKey(c_StepSelectCliente))
    pGetCliente = .Properties.Item(c_Wiz_Key_Cliente).HelpId
  End With
End Function

Private Function pGetClienteName() As String
  With m_ObjWizard.Steps.Item(GetKey(c_StepSelectCliente))
    pGetClienteName = .Properties.Item(c_Wiz_Key_Cliente).Value
  End With
End Function

' Edit From ListDoc
'
Private Function pGetOnlySelected() As cIABMProperty
  With m_ObjWizard.Steps.Item(GetKey(c_StepSelectCliente))
    Set pGetOnlySelected = .Properties.Item(c_Wiz_Key_OnlySelected)
  End With
End Function

Private Function pGetItems() As cIABMGrid
  With m_ObjWizard.Steps.Item(GetKey(c_StepSelectItems))
    Set pGetItems = .Properties.Item(c_Wiz_Key_Items).Grid
  End With
End Function

Private Function pGetItemsProperty() As cIABMProperty
  With m_ObjWizard.Steps.Item(GetKey(c_StepSelectItems))
    Set pGetItemsProperty = .Properties.Item(c_Wiz_Key_Items)
  End With
End Function

Private Function pGetPedidos() As cIABMGrid
  With m_ObjWizard.Steps.Item(GetKey(c_StepSelectPedido))
    Set pGetPedidos = .Properties.Item(c_Wiz_Key_Pedidos).Grid
  End With
End Function

Private Function pGetPedidosProperty() As cIABMProperty
  With m_ObjWizard.Steps.Item(GetKey(c_StepSelectPedido))
    Set pGetPedidosProperty = .Properties.Item(c_Wiz_Key_Pedidos)
  End With
End Function

Private Sub pRefreshPedidos()
  Dim ObjWiz As cWizardGeneric
  Set ObjWiz = m_ObjWizard
  
  With m_ObjWizard.Steps.Item(GetKey(c_StepSelectPedido))
    ObjWiz.ShowValue .Properties.Item(c_Wiz_Key_Pedidos), True
  End With
End Sub

Private Sub pRefreshItems()
  Dim ObjWiz As cWizardGeneric
  Set ObjWiz = m_ObjWizard
  
  With m_ObjWizard.Steps.Item(GetKey(c_StepSelectItems))
    ObjWiz.ShowValue .Properties.Item(c_Wiz_Key_Items), True
  End With
End Sub

Private Function pGetComprobante() As cIABMProperty
  With m_ObjWizard.Steps.Item(GetKey(c_StepDatosGenerales))
    Set pGetComprobante = .Properties.Item(c_Wiz_Key_Comprobante)
  End With
End Function

Private Function pGetLegajo() As cIABMProperty
  With m_ObjWizard.Steps.Item(GetKey(c_StepDatosGenerales))
    Set pGetLegajo = .Properties.Item(c_Wiz_Key_Legajo)
  End With
End Function

Private Function pGetPuertoOrigen() As cIABMProperty
  With m_ObjWizard.Steps.Item(GetKey(c_StepDatosGenerales))
    Set pGetPuertoOrigen = .Properties.Item(c_Wiz_Key_PuertoOrigen)
  End With
End Function

Private Function pGetPuertoDestino() As cIABMProperty
  With m_ObjWizard.Steps.Item(GetKey(c_StepDatosGenerales))
    Set pGetPuertoDestino = .Properties.Item(c_Wiz_Key_PuertoDestino)
  End With
End Function

Private Function pGetBarco() As cIABMProperty
  With m_ObjWizard.Steps.Item(GetKey(c_StepDatosGenerales))
    Set pGetBarco = .Properties.Item(c_Wiz_Key_Barco)
  End With
End Function

Private Function pGetDescrip() As cIABMProperty
  With m_ObjWizard.Steps.Item(GetKey(c_StepDatosGenerales))
    Set pGetDescrip = .Properties.Item(c_Wiz_Key_Observaciones)
  End With
End Function

Private Function pGetMarca() As cIABMProperty
  With m_ObjWizard.Steps.Item(GetKey(c_StepDatosGenerales))
    Set pGetMarca = .Properties.Item(c_Wiz_Key_Marca)
  End With
End Function

Private Function pGetCentroCosto() As cIABMProperty
  With m_ObjWizard.Steps.Item(GetKey(c_StepDatosGenerales))
    Set pGetCentroCosto = .Properties.Item(c_Wiz_Key_CentroCosto)
  End With
End Function

Private Function pGetCondicionPago() As cIABMProperty
  With m_ObjWizard.Steps.Item(GetKey(c_StepDatosGenerales))
    Set pGetCondicionPago = .Properties.Item(c_Wiz_Key_CondicionPago)
  End With
End Function

Private Function pGetListaPrecio() As cIABMProperty
  With m_ObjWizard.Steps.Item(GetKey(c_StepDatosGenerales))
    Set pGetListaPrecio = .Properties.Item(c_Wiz_Key_ListaPrecio)
  End With
End Function

Private Function pGetListaDescuento() As cIABMProperty
  With m_ObjWizard.Steps.Item(GetKey(c_StepDatosGenerales))
    Set pGetListaDescuento = .Properties.Item(c_Wiz_Key_ListaDescuento)
  End With
End Function

Private Function pGetSucursal() As cIABMProperty
  With m_ObjWizard.Steps.Item(GetKey(c_StepDatosGenerales))
    Set pGetSucursal = .Properties.Item(c_Wiz_Key_Sucursal)
  End With
End Function

Private Function pGetFecha() As cIABMProperty
  With m_ObjWizard.Steps.Item(GetKey(c_StepDatosGenerales))
    Set pGetFecha = .Properties.Item(c_Wiz_Key_Fecha)
  End With
End Function

Private Function pChecPedidos() As Boolean
  If Val(pGetTotal.Value) = 0 Then
    MsgWarning LNGGetText(1689, vbNullString)   'Debe indicar un o más pedidos.
    Exit Function
  End If
  pChecPedidos = True
End Function

Private Function pChecItems() As Boolean
  If Val(pGetTotalItems.Value) = 0 Then
    MsgWarning LNGGetText(1678, vbNullString)   'Debe indicar un o más items.
    Exit Function
  End If
  pChecItems = True
End Function

Private Function pGetMonId() As Long
  Dim Doc As cDocumento
  Set Doc = New cDocumento
  
  pGetMonId = Doc.GetData(pGetDoc, cscMonId, csLong)
End Function

Private Function pGetPedidosIds() As String
  Dim Row         As cIABMGridRow
  Dim Ids         As String
  
  For Each Row In pGetPedidos().Rows
    If pCell(Row, KI_SELECT).ID Then
      Ids = Ids & pCell(Row, KI_PV_ID).ID & ","
    End If
  Next
  
  pGetPedidosIds = RemoveLastColon(Ids)
End Function

Private Function pLoadItemsXPedidos() As Boolean
  Dim sqlstmt           As String
  Dim rs                As Recordset
  Dim F                 As cIABMGridRow
  Dim fv                As cIABMGridCellValue
  Dim i                 As Long
  
  sqlstmt = "sp_DocPackingListGetPedidoItems '" & pGetPedidosIds & "'"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  pGetItems().Rows.Clear
  
  ReDim vMonId(0)
  
  While Not rs.EOF
  
    Set F = pGetItems().Rows.Add(Nothing)
    
    ' La primera no se usa
    Set fv = F.Add(Nothing)
    fv.ID = gDB.ValField(rs.Fields, cscPviId)
    fv.Key = KII_PVI_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = 0
    fv.Key = KII_SELECT
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPvNrodoc)
    fv.Key = KI_NRODOC

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPvNumero)
    fv.ID = gDB.ValField(rs.Fields, cscPvId)
    fv.Key = KI_PV_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPrNombreventa)
    fv.ID = gDB.ValField(rs.Fields, cscPrId)
    fv.Key = KII_ARTICULO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPviPendiente)
    fv.Key = KII_PENDIENTE

    Set fv = F.Add(Nothing)
    fv.Value = 0
    fv.Key = KII_APLICAR
    
    Set fv = F.Add(Nothing)
    fv.Value = 0
    fv.Key = KII_PALLETS
    
    Set fv = F.Add(Nothing)
    fv.Value = 0
    fv.Key = KII_CAJA_DESDE
    
    Set fv = F.Add(Nothing)
    fv.Value = 0
    fv.Key = KII_CAJA_HASTA
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPrGrupoExpo)
    fv.Key = KII_GRUPO_EXPO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPrPesoNeto)
    fv.Key = KII_PESO_NETO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPrPesoTotal)
    fv.Key = KII_PESO_TOTAL
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscUnNombre)
    fv.Key = KII_UNIDAD_PESO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPviPrecio)
    fv.Key = KII_PRECIO_SIN_IVA
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPviCantidadaremitir)
    fv.Key = KII_CANTIDAD
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPviImporte)
    fv.Key = KII_TOTAL
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPviDescrip)
    fv.Key = KII_DESCRIP
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPviPrecio & 2)
    fv.Key = KII_PRECIOIVA
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPviPrecioLista)
    fv.Key = KII_PRECIO_LP
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPviPrecioUsr)
    fv.Key = KII_PRECIO_USR
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPviIvariPorc)
    fv.Key = KII_IVARIPercent
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPviIvarniPorc)
    fv.Key = KII_IVARNIPercent
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPviDescuento)
    fv.Key = KII_DESCUENTO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCcosId)
    fv.Key = KII_CCOS_ID
    
    rs.MoveNext
  Wend
  
  pRefreshItems
  pShowTotalItems
  
  pLoadItemsXPedidos = True
End Function

Private Function pLoadPedidosXCliente() As Boolean
  Dim sqlstmt           As String
  Dim rs                As Recordset
  Dim pv_id             As Long
  
  ' Edit From ListDoc
  '
  Dim bSelected         As Boolean
  Dim bOnlySelected     As Boolean
  
  sqlstmt = "sp_DocPackingListGetPedidos " & EmpId & "," & pGetCliente & ", " & pGetMonId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  ' Edit From ListDoc
  '
  bOnlySelected = pGetOnlySelected().Value
  
  ReDim vMonId(0)
  
  With pGetPedidos().Rows
    
    .Clear
  
    While Not rs.EOF
    
      ' Edit From ListDoc
      '
      pv_id = gDB.ValField(rs.Fields, cscPvId)
      
      bSelected = pGetApply(pv_id)
      If Not bOnlySelected Or bSelected Then
        
        With .Add(Nothing)
        
          ' La primera no se usa
          .Add Nothing
          
          With .Add(Nothing)
            .ID = CInt(bSelected)
            .Key = KI_SELECT
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscDocNombre)
            .Key = KI_DOC
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPvNrodoc)
            .Key = KI_NRODOC
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPvNumero)
            .ID = gDB.ValField(rs.Fields, cscPvId)
            .Key = KI_PV_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPvFecha)
            .Key = KI_FECHA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPvTotal)
            .Key = KI_TOTAL
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPvDescrip)
            .Key = KI_DESCRIP
          End With
        End With
      End If
      
      rs.MoveNext
    Wend
  End With
  
  pRefreshPedidos
  pShowTotalPedidos
  
  pLoadPedidosXCliente = True
End Function

' Edit From ListDoc
'
Private Function pGetApply(ByVal pv_id As Long) As Boolean
  Dim i As Long
  
  For i = 1 To UBound(m_PvIds)
    If m_PvIds(i) = pv_id Then
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

' Validaciones de Filas de Instrumentos de cobro
Private Function pIsEmptyRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KII_PVI_ID, KII_ARTICULO, KII_PENDIENTE
        If Not ValEmpty(Cell.ID, csId) Then
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
End Sub

Private Function pValidateDatosGenerales() As Boolean
  If ValEmpty(pGetFecha().Value, csDate) Then
    MsgWarning LNGGetText(2555, vbNullString)   'Debe indicar la fecha del Packing List
    Exit Function
  End If
  
  If ValEmpty(pGetSucursal().HelpId, csId) Then
    MsgWarning LNGGetText(1560, vbNullString)   'Debe indicar la sucursal
    Exit Function
  End If
  
  If ValEmpty(pGetPuertoOrigen().HelpId, csId) Then
    MsgWarning LNGGetText(2500, vbNullString)   'Debe indicar un puerto origen
    Exit Function
  End If
  
  If ValEmpty(pGetPuertoDestino().HelpId, csId) Then
    MsgWarning LNGGetText(2501, vbNullString)   'Debe indicar un puerto destino
    Exit Function
  End If
  
  pValidateDatosGenerales = True
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2515, vbNullString) 'Error al grabar el Packing List

  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  ReDim m_PvIds(0)

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
  ReDim m_PvIds(0)
  Set m_ObjClient = Nothing
  
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
  Dim Pallets      As Double
  Dim Cantidad     As Double

  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  
  With register
    
    .fieldId = cscPklstTMPId
    .Table = csTPackingListTMP
    .ID = csNew
    
    ' Header
    With .Fields
      
      .Add2 cscPklstNumero, 0, csLong
      With pGetComprobante()
        ' PrintDoc
        '
        m_LastNroDoc = SetMask(.Value, .TextMask)
        register.Fields.Add2 cscPklstNrodoc, m_LastNroDoc, csText
      End With
      .Add2 cscPklstDescrip, pGetDescrip().Value, csText
      .Add2 cscPklstMarca, pGetMarca().Value, csText
      .Add2 cscPklstFecha, pGetFecha().Value, csDate
      .Add2 cscCliId, pGetCliente(), csId
      .Add2 cscCcosId, pGetCentroCosto().HelpId, csId
      .Add2 cscSucId, pGetSucursal().HelpId, csId
      .Add2 cscCpgId, pGetCondicionPago().HelpId, csId
      .Add2 cscLpId, pGetListaPrecio().HelpId, csId
      .Add2 cscLdId, pGetListaDescuento().HelpId, csId
      .Add2 cscDocId, pGetDoc(), csId
      .Add2 cscLgjId, pGetLegajo().HelpId, csId
      .Add2 cscPueIdOrigen, pGetPuertoOrigen().HelpId, csId
      .Add2 cscPueIdDestino, pGetPuertoDestino().HelpId, csId
      .Add2 cscBarcId, pGetBarco().HelpId, csId
      
      .Add2 cscEstId, CSGeneralEx2.csEEstado.csEEst_Pendiente, csId
      .Add2 cscPklstId, csNew, csLong
      
      bIvaRni = IsRNI(pGetCliente)
      pGetFooter Neto, IvaRi, IvaRni, bIvaRni, Pallets, Cantidad
    
      ' Footer
      .Add2 cscPklstSubtotal, Neto, csCurrency
      .Add2 cscPklstNeto, Neto, csCurrency
      .Add2 cscPklstIvari, IvaRi, csCurrency
      .Add2 cscPklstIvarni, IvaRni, csCurrency
      .Add2 cscPklstTotal, Neto + IvaRi + IvaRni, csCurrency  ' Por ahora no hay descuentos
      .Add2 cscPklstCantidad, Cantidad, csLong
      .Add2 cscPklstPallets, Pallets, csLong
      
      .HaveLastUpdate = True
      .HaveWhoModify = True
      
    End With
      
    If Not .BeginTrans(gDB) Then Exit Function
    
    If Not gDB.Save(register, , "pSave", C_Module, c_ErrorSave) Then Exit Function
    
    If Not pSaveItems(.ID, bIvaRni) Then Exit Function
    If Not pSaveVinculacion(.ID) Then Exit Function
    
    If Not .CommitTrans() Then Exit Function
  
  End With
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocPackingListSave " & register.ID
  If Not gDB.OpenRs(sqlstmt, rs, , , , "pSave", C_Module, c_ErrorSave) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim ID As Long
  If Not GetDocIDFromRecordset(rs, ID) Then Exit Function
  
  m_Id = ID
  
  pSave = m_Id <> 0
End Function

Private Function pSaveItems(ByVal ID As Long, ByVal bIvaRni As Boolean) As Boolean
  Dim register  As cRegister
  Dim iOrden    As Long
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  Dim Precio    As Double
  Dim IvaRi     As Double
  Dim IvaRni    As Double
  Dim Neto      As Double
  Dim Cantidad  As Double
  Dim sqlstmt   As String
  
  For Each Row In pGetItems().Rows
  
    If Val(pCell(Row, KII_APLICAR).Value) Then
    
      Set register = New cRegister
      
      With register
      
        .fieldId = cscPklstiTMPId
        .Table = csTPackingListItemTMP
        .ID = csNew
          
        With .Fields
          
          For Each Cell In Row
            Select Case Cell.Key
              Case KII_APLICAR
                Cantidad = Cell.Value
                .Add2 cscPklstiCantidad, Cell.Value, csDouble
              Case KII_PALLETS
                .Add2 cscPklstiPallets, Cell.Value, csText
              Case KII_GRUPO_EXPO
                .Add2 cscPklstiGrupoExpo, Cell.Value, csText
              Case KII_PESO_NETO
                .Add2 cscPklstiPesoNeto, Cell.Value, csDouble
              Case KII_PESO_TOTAL
                .Add2 cscPklstiPesoTotal, Cell.Value, csDouble
              Case KII_CAJA_DESDE
                .Add2 cscPklstiCajaDesde, Cell.Value, csInteger
              Case KII_CAJA_HASTA
                .Add2 cscPklstiCajaHasta, Cell.Value, csInteger
              Case KII_DESCRIP
                .Add2 cscPklstiDescrip, Cell.Value, csText
              Case KII_PRECIO_SIN_IVA
                Precio = Cell.Value
                .Add2 cscPklstiPrecio, Precio, csCurrency
              Case KII_PRECIO_LP
                .Add2 cscPklstiPrecioLista, Cell.Value, csCurrency
              Case KII_PRECIO_USR
                .Add2 cscPklstiPrecioUsr, Cell.Value, csCurrency
              Case KII_DESCUENTO
                .Add2 cscPklstiDescuento, Cell.Value, csText
              Case KII_IVARIPercent
                IvaRi = Cell.Value
                .Add2 cscPklstiIvariporc, IvaRi, csDouble
              Case KII_IVARNIPercent
                If bIvaRni Then
                  IvaRni = Cell.Value
                End If
                .Add2 cscPklstiIvarniporc, IvaRni, csDouble
              Case KII_ARTICULO
                .Add2 cscPrId, Cell.ID, csId
              Case KII_CCOS_ID
                .Add2 cscCcosId, Cell.ID, csId
            End Select
          Next
        
          Neto = Precio * Cantidad
          .Add2 cscPklstiNeto, Neto, csCurrency
          
          IvaRi = Neto * IvaRi / 100
          .Add2 cscPklstiIvari, IvaRi, csCurrency
          
          IvaRni = Neto * IvaRni / 100
          .Add2 cscPklstiIvarni, IvaRni, csCurrency
          .Add2 cscPklstiImporte, Neto + IvaRi + IvaRni, csCurrency
          
          ' Esto es muy importante ya que se usa para vincular el pedidoventaitem
          ' con el nuevo PackingListitem
          iOrden = iOrden + 1
          .Add2 cscPklstiOrden, iOrden, csInteger
          
          .Add2 cscPklstTMPId, ID, csId
          .Add2 cscPklstiId, ID, csLong
          
          .HaveLastUpdate = False
          .HaveWhoModify = False
      
        End With
      End With
      
      If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
    End If
  Next
  
  pSaveItems = True
End Function

Private Function pSaveVinculacion(ByVal ID As Long) As Boolean
  Dim register        As cRegister
  Dim iOrden          As Long
  Dim bSave           As Boolean
  Dim Row             As cIABMGridRow
  Dim Cell            As cIABMGridCellValue
  
  For Each Row In pGetItems().Rows
  
    Set register = New cRegister
    
    With register
    
      .fieldId = cscPvPklstTMPId
      .Table = csTPedidoPackingListTMP
      .ID = csNew
    
      bSave = False
      
      With .Fields
    
        For Each Cell In Row
          If pCell(Row, KII_SELECT).ID Then
            bSave = True
            Select Case Cell.Key
              Case KII_PVI_ID
                .Add2 cscPviId, Cell.ID, csId
              Case KII_APLICAR
                .Add2 cscPvPklstCantidad, Cell.Value, csDouble
            End Select
          End If
        Next
        
        If bSave Then
          
          .Add2 cscPvPklstId, 0, csLong
          .Add2 cscPklstTMPId, ID, csId
          
          ' Esto es muy importante ya que se usa para vincular el pedidoventaitem
          ' con el nuevo PackingListitem
          iOrden = iOrden + 1
          .Add2 cscPklstiId, iOrden, csLong
          
          .HaveLastUpdate = False
          .HaveWhoModify = False
          
          If Not gDB.Save(register, , "pSaveVinculacion", C_Module, c_ErrorSave) Then Exit Function
        End If
      
      End With
    End With
  Next
  
  pSaveVinculacion = True
End Function

Private Sub pGetFooter(ByRef Neto As Double, ByRef IvaRi As Double, _
                       ByRef IvaRni As Double, ByVal bIvaRni As Boolean, _
                       ByRef Pallets As Double, ByRef Cantidad2 As Double)
                       
  Dim Row           As cIABMGridRow
  Dim Cell          As cIABMGridCellValue
  Dim Precio        As Double
  Dim Cantidad      As Double
  Dim IvaRniPercent As Double
  Dim IvaRiPercent  As Double
  
  For Each Row In pGetItems().Rows
    If pCell(Row, KII_SELECT).ID Then
      For Each Cell In Row
        Select Case Cell.Key
          Case KII_PALLETS
            Pallets = Pallets + Cell.Value
          Case KII_APLICAR
            Cantidad = Cell.Value
            Cantidad2 = Cantidad2 + Cantidad
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

'//////////////////////////////////////////////////////////////////////////////
Private Sub pSetPrecioIva(ByRef Row As CSInterfacesABM.cIABMGridRow)
  Dim PrecioIva As Double
  Dim Precio    As Double
  Dim IvaRi     As Double
  Dim IvaRni    As Double
  
  Precio = Val(pCell(Row, KII_PRECIO_SIN_IVA).Value)
  If m_bIva Then
    IvaRi = (Precio * Val(pCell(Row, KII_IVARIPercent).Value)) / 100
  End If
  If m_bIvaRni Then
    IvaRni = (Precio * Val(pCell(Row, KII_IVARNIPercent).Value)) / 100
  End If
  PrecioIva = Precio + IvaRi + IvaRni
  
  pCell(Row, KII_PRECIOIVA).Value = PrecioIva
End Sub

Private Sub pGetIvaFromCliente(ByVal Cli_id As Long)
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  
  sqlstmt = "sp_ClienteGetIva " & Cli_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  m_bIva = gDB.ValField(rs.Fields, "bIva")
  m_bIvaRni = gDB.ValField(rs.Fields, "bIvaRni")
End Sub

Private Sub pSetDatosCliente()
  Dim lp_id       As Long
  Dim ld_id       As Long
  Dim cpg_id      As Long
  Dim cpg_nombre  As String
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

  If Not GetClienteData2(m_LastCli, lp_id, ld_id, cpg_id, m_LastDoc) Then Exit Sub
  
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
  
  ' Lista de descuentos
  Set iProp = pGetListaDescuento()
  iProp.HelpFilter = GetListaDescGetXCliente(m_LastDoc, m_LastCli)
  
  If ld_id <> csNO_ID Then
    Set LD = New cListaDescuento
    iProp.Value = LD.GetData(ld_id, cscLdNombre, csText)
    iProp.HelpId = ld_id
  End If
  
  m_ObjWizard.ShowValue iProp
  
  ' Talonario y Categoria fiscal
  pGetIvaFromCliente m_LastCli
  
End Sub

Private Sub pNewEmptyProperties()
  ' (ByRef Grid As cIABMGrid)
  
  pGetPedidos().Rows.Clear
  pGetItems().Rows.Clear
  
  With pGetComprobante()
    .Value = ""
    .TextMask = ""
  End With
  With pGetCentroCosto()
    .HelpId = csNO_ID
    .Value = ""
  End With
  With pGetCondicionPago()
    .HelpId = csNO_ID
    .Value = ""
  End With
  With pGetListaPrecio()
    .HelpId = csNO_ID
    .Value = ""
  End With
  With pGetPuertoOrigen()
    .HelpId = csNO_ID
    .Value = ""
  End With
  With pGetPuertoDestino()
    .HelpId = csNO_ID
    .Value = ""
  End With
  With pGetBarco()
    .HelpId = csNO_ID
    .Value = ""
  End With
  With pGetMarca()
    .HelpId = csNO_ID
    .Value = ""
  End With
  With pGetLegajo()
    .HelpId = csNO_ID
    .Value = ""
  End With
  
  pGetDescrip().Value = ""
  
  With m_ObjWizard
    .ShowValue pGetPedidosProperty()
    .ShowValue pGetItemsProperty()
    .ShowValue pGetComprobante()
    .ShowValue pGetCentroCosto()
    .ShowValue pGetCondicionPago()
    .ShowValue pGetPuertoOrigen()
    .ShowValue pGetPuertoDestino()
    .ShowValue pGetBarco()
    .ShowValue pGetMarca()
    .ShowValue pGetLegajo()
    .ShowValue pGetListaPrecio()
    .ShowValue pGetDescrip()
  End With
  
End Sub


