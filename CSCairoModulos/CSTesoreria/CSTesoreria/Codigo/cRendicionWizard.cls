VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRendicionWizard"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIWizardClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cFacturaVentaWizard
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
Private Const C_Module = "cFacturaVentaWizard"

Private Const c_StepWelcome             As Integer = 1
Private Const c_StepSelectCliente       As Integer = 3
Private Const c_StepSelectPedido        As Integer = 4
Private Const c_StepSelectItems         As Integer = 6
Private Const c_StepDatosGenerales      As Integer = 7

Private Const c_Wiz_Key_ResultTitle = "RESULTT"
Private Const c_Wiz_Key_Result = "RESULT"
Private Const c_Wiz_Key_Cliente = "CLIENT"

Private Const c_Wiz_Key_Doc = "DOC"
Private Const c_Wiz_Key_Movimientos = "MOVIMIENTOS"
Private Const c_Wiz_Key_Todos = "TODOS"

Private Const c_Wiz_Key_Items = "ITEMS"
Private Const c_Wiz_Key_TodosItems = "TODOS-ITEMS"

Private Const c_Wiz_Key_Total = "Total"
Private Const c_Wiz_Key_TotalItems = "TotalItems"
Private Const c_Wiz_Key_Pendiente = "Pendiente"

Private Const c_Wiz_Key_Fecha = "Fecha"
Private Const c_Wiz_Key_Cliente2 = "Cliente"
Private Const c_Wiz_Key_Sucursal = "Sucursal"
Private Const c_Wiz_Key_Observaciones = "Observaciones"
Private Const c_Wiz_Key_Comprobante = "Comprobante"
Private Const c_Wiz_Key_Legajo = "Legajo"
Private Const c_Wiz_Key_CentroCosto = "Centro de Costo"

Private Const KW_MOVIMIENTOS                 As Integer = 10
Private Const KW_TODOS                       As Integer = 110
Private Const KW_ITEMS                       As Integer = 120
Private Const KW_TODOS_ITEMS                 As Integer = 130
Private Const KW_CLIENTE2                    As Integer = 220
Private Const KW_FECHA                       As Integer = 230
Private Const KW_SUCURSAL                    As Integer = 240
Private Const KW_DESCRIP                     As Integer = 250
Private Const KW_COMPROBANTE                 As Integer = 260
Private Const KW_LEGAJO                      As Integer = 280
Private Const KW_CENTROCOSTO                 As Integer = 290

Private Const KI_MF_ID                       As Integer = 1
Private Const KI_SELECT                      As Integer = 2
Private Const KI_DOC                         As Integer = 3
Private Const KI_NRODOC                      As Integer = 4
Private Const KI_FECHA                       As Integer = 5
Private Const KI_DESCRIP                     As Integer = 8
Private Const KI_TOTAL                       As Integer = 10

Private Const KII_SELECT                 As Integer = 1
Private Const KII_MFI_ID                 As Integer = 2
Private Const KII_ARTICULO               As Integer = 5
Private Const KII_CANTIDAD               As Integer = 6
Private Const KII_PENDIENTE              As Integer = 7
Private Const KII_APLICAR                As Integer = 8
Private Const KII_PRECIO                 As Integer = 9
Private Const KII_TOTAL                  As Integer = 10
Private Const KII_DESCRIP                As Integer = 11
Private Const KII_DESCUENTO              As Integer = 17
Private Const KII_CCOS_ID                As Integer = 18

Private Const c_WizardTitle = "Asistente de Rendición"

Private Const c_ErrorSave = "Error al grabar la rendición"

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

' variables privadas
Private m_ObjWizard               As cIWizardGeneric

Private m_WizardProcessing        As Boolean
Private m_WizardCancel            As Boolean

'Private m_Resource                As fResource

Private m_GeneralConfig     As cGeneralConfig

Private m_Id                As Long

Private m_Cli_id            As Long
Private m_Cliente           As String
Private m_doc_id            As Long
Private m_Documento         As String
Private m_MfIds()           As Long

Private m_ObjClient         As Object

Private m_LastDoc           As Long

' PrintDoc
'
Private m_LastNroDoc        As String

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

Public Property Let cli_id(ByVal rhs As Long)
  m_Cli_id = rhs
End Property

Public Property Let Cliente(ByVal rhs As String)
  m_Cliente = rhs
End Property

Public Property Let MfIds(ByRef rhs() As Long)
  On Error Resume Next
  Dim i As Long
  ReDim m_MfIds(UBound(rhs))
  For i = 0 To UBound(rhs)
    m_MfIds(i) = rhs(i)
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
    Case KW_MOVIMIENTOS
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
    Case KW_MOVIMIENTOS
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
    Case KW_MOVIMIENTOS
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
    Case KW_MOVIMIENTOS
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
  Dim Id As Long
  
  Select Case Key
    Case KW_MOVIMIENTOS
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
    Case KW_MOVIMIENTOS
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
    Case KII_SELECT, KII_APLICAR
    Case Else
      Exit Function
  End Select

  pColBEditItems = True
End Function

Private Function pColBEditPedidos(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
  Select Case pGetKeyFromCol(IProperty.Grid.Columns, lCol)
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
      
      Case Else
        pColAUpdateItems = True
        Exit Function
    End Select
  End With
  
  pColAUpdateItems = True
End Function

Private Sub pSelectAllPedidos(ByVal bSelect As Boolean)
  Dim Row As cIABMGridRow
  
  With pGetPedidos
    For Each Row In .Rows
      pCell(Row, KI_SELECT).Id = CInt(bSelect)
    Next
  End With
  
  m_ObjWizard.ShowValue pGetPedidosProperty
End Sub

Private Sub pSelectAllItems(ByVal bSelect As Boolean)
  Dim Row As cIABMGridRow
  
  With pGetItems
    For Each Row In .Rows
      pCell(Row, KII_SELECT).Id = CInt(bSelect)
      pSelectItem Row, .Columns
    Next
  End With
  
  m_ObjWizard.ShowValue pGetItemsProperty
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


Private Sub pShowTotalPedidos()
  Dim Row           As cIABMGridRow
  Dim Total         As Double
  
  For Each Row In pGetPedidos().Rows
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
    Total = Total + Val(pCell(Row, KII_APLICAR).Value) * Val(pCell(Row, KII_PRECIO).Value)
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
      m_ObjWizard.cmdBack.Enabled = False
      
    Case c_StepSelectCliente
    
      If pGetDoc() = csNO_ID Then
        MsgWarning "Debe indicar un documento", "Facturas"
        nNextStep = c_StepSelectCliente
      ElseIf pGetCliente() = csNO_ID Then
        MsgWarning "Debe indicar un cliente", "Facturas"
        nNextStep = c_StepSelectCliente
      ElseIf Not pLoadPedidosXCliente() Then
        MsgWarning "No se pudieron cargar los pedidos para este cliente", "Facturas"
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
        MsgWarning "No se pudieron cargar los items de los pedidos para este cliente", "Facturas"
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
          ' Finish, now close wizard
          m_ObjWizard.CloseWizard
          ' We return False to cancel pending steps in the generic Wizard's code
          Exit Function
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
      .Value = "Bienvenido al Asistente de Rendición"
    End With
    With .Properties.Add(Nothing)
      .Top = 1200
      .Left = 3000
      '.Name = vbNullString
      .PropertyType = cspLabel
      .Width = 6000
      .Height = 880
      .FontBold = True
      .Value = "Con este asistente usted podra generar las facturas sobre pedidos."
    End With
  End With
End Sub

Private Sub pLoadStepSelectCliente()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepSelectCliente))
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
      .Value = "Indique el documento a utilizar y el cliente al que se le emitirá la factura"
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_Doc)
      .Top = 1500
      .Left = 3700
      .Name = "Documento"
      .PropertyType = cspHelp
      .HelpFilter = "'doct_id = " & csEDT_FacturaVenta & "'"
      .Table = CSDocumento2.CSDocumento
      .Width = 4000
      .Value = m_Documento
      .HelpId = m_doc_id
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_Cliente)
      .Top = 2000
      .Left = 3700
      .Name = "Cliente"
      .PropertyType = cspHelp
      .Table = csCliente
      .Width = 4000
      .Value = m_Cliente
      .HelpId = m_Cli_id
    End With
  End With
End Sub

Private Sub pLoadStepSelectPedido()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepSelectPedido))
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
      .Value = "Seleccione los pedidos"
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_Movimientos)
      .Top = 1100
      .Left = 150
      '.Name = vbNullString
      .PropertyType = cspGrid
      .LeftLabel = -1
      pLoadPedidos .Grid
      .Width = 11500
      .Height = 4450
      .Key = KW_MOVIMIENTOS
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_Todos)
      .Name = c_selectall
      .Top = 5600
      .Left = 200
      .LeftLabel = -1
      .Width = 2200
      .PropertyType = cspButton
      .Key = KW_TODOS
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_Total)
      .Name = "Total"
      .Top = 5600
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
      '.Name = vbNullString
      .PropertyType = cspCheck
      .Width = 320
      .Key = KI_SELECT
    End With
    
    With .Add(Nothing)
      .Name = "Tipo"
      .PropertyType = cspText
      .Width = 3000
      .Key = KI_DOC
    End With
  
    With .Add(Nothing)
      .Name = "Documento"
      .PropertyType = cspText
      .Width = 1800
      .Key = KI_NRODOC
    End With
  
    With .Add(Nothing)
      .Name = "Número"
      .PropertyType = cspNumeric
      .Width = 800
      .Key = KI_MF_ID
    End With
  
    With .Add(Nothing)
      .Name = "Fecha"
      .PropertyType = cspDate
      .Width = 1040
      .Format = "dd/mm/yy"
      .Key = KI_FECHA
    End With
  
    With .Add(Nothing)
      .Name = "Total"
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 920
      .Key = KI_TOTAL
      .Format = m_GeneralConfig.FormatDecImporte
    End With
  
    With .Add(Nothing)
      .Name = "Descripción"
      .PropertyType = cspText
      .Width = 3000
      .Key = KI_DESCRIP
    End With
  End With
End Sub

Private Sub pLoadStepSelectItems()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepSelectItems))
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
      .Value = "Seleccione los items he indique las cantidades que facturará de cada una de ellos"
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_Items)
      .Top = 1100
      .Left = 150
      '.Name = vbNullString
      .PropertyType = cspGrid
      .LeftLabel = -1
      pLoadItems .Grid
      .Width = 11500
      .Height = 4450
      .Key = KW_ITEMS
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_TodosItems)
      .Name = c_selectall
      .Top = 5600
      .Left = 200
      .LeftLabel = -1
      .Width = 2200
      .PropertyType = cspButton
      .Key = KW_TODOS_ITEMS
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_TotalItems)
      .Name = "Total"
      .Top = 5600
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
      .Key = KII_MFI_ID
    End With
  
    With .Add(Nothing)
      '.Name = vbNullString
      .PropertyType = cspCheck
      .Width = 320
      .Key = KII_SELECT
    End With
    
    With .Add(Nothing)
      .Name = "Documento"
      .PropertyType = cspText
      .Width = 1600
      .Key = KI_NRODOC
    End With
  
    With .Add(Nothing)
      .Name = "Número"
      .PropertyType = cspNumeric
      .Width = 800
      .Key = KI_MF_ID
    End With
    
    With .Add(Nothing)
      .Name = "Articulo"
      .PropertyType = cspText
      .Width = 3000
      .Key = KII_ARTICULO
    End With
  
    With .Add(Nothing)
      .Name = "Precio"
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 920
      .Key = KII_PRECIO
      .Format = m_GeneralConfig.FormatDecImporte
    End With
    
    With .Add(Nothing)
      .Name = "Cantidad"
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 920
      .Key = KII_CANTIDAD
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
    
    With .Add(Nothing, c_Wiz_Key_Pendiente)
      .Name = "Pendiente"
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 920
      .Key = KII_PENDIENTE
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
  
    With .Add(Nothing)
      .Name = "Aplicar"
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 920
      .Key = KII_APLICAR
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
    
    With .Add(Nothing, c_Wiz_Key_TotalItems)
      .Name = "Total"
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 920
      .Key = KII_TOTAL
      .Format = m_GeneralConfig.FormatDecImporte
    End With
    
    With .Add(Nothing)
      .Name = "Descripción"
      .PropertyType = cspText
      .Width = 3000
      .Key = KII_DESCRIP
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
      .Value = "Complete los siguientes datos de la factura"
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_Fecha)
      .PropertyType = cspDate
      .Left = 2800
      .Name = c_Wiz_Key_Fecha
      .Key = KW_FECHA
      .Value = Date
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_Cliente2)
      .PropertyType = cspHelp
      .Table = csCliente
      .Enabled = False
      .Name = c_Wiz_Key_Cliente2
      .Key = KW_CLIENTE2
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_Sucursal)
      .PropertyType = cspHelp
      .Table = csSucursal
      .Name = c_Wiz_Key_Sucursal
      .Value = User.Sucursal
      .HelpId = User.suc_id
      .Key = KW_SUCURSAL
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_Comprobante)
      .PropertyType = cspText
      .Left = 6800
      .TopFromProperty = c_Wiz_Key_Fecha
      .Name = c_Wiz_Key_Comprobante
      .Key = KW_COMPROBANTE
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_Legajo)
      .PropertyType = cspHelp
      .Table = csLegajo
      .Name = c_Wiz_Key_Legajo
      .Key = KW_LEGAJO
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_CentroCosto)
      .PropertyType = cspHelp
      .Table = csCentroCosto
      .Name = c_Wiz_Key_CentroCosto
      .Key = KW_CENTROCOSTO
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_Observaciones)
      .PropertyType = cspText
      .Left = 2800
      .TopFromProperty = c_Wiz_Key_CentroCosto
      .TopToPrevious = 440
      .Height = 880
      .Width = 6250
      .Name = c_Wiz_Key_Observaciones
      .Key = KW_DESCRIP
    End With
  End With
End Sub

Private Function pUserCancel() As Boolean
  If m_WizardCancel Then
    
    If Ask("Desea cancelar el proceso", vbNo) Then
    
      pUserCancel = True
    End If
  End If
  m_WizardCancel = False
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
                                c_StepSelectPedido, _
                                c_Wiz_Key_Todos)
End Function

Private Function pGetTodosItems() As cIABMProperty
  Set pGetTodosItems = GetWizProperty(m_ObjWizard, _
                                c_StepSelectItems, _
                                c_Wiz_Key_TodosItems)
End Function

Private Function pGetTotal() As cIABMProperty
  Set pGetTotal = GetWizProperty(m_ObjWizard, _
                                c_StepSelectPedido, _
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

Private Function pGetClienteName() As String
  pGetClienteName = GetWizProperty(m_ObjWizard, _
                           c_StepSelectCliente, _
                           c_Wiz_Key_Cliente).Value
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

Private Function pGetPedidos() As cIABMGrid
  Set pGetPedidos = GetWizProperty(m_ObjWizard, _
                                c_StepSelectPedido, _
                                c_Wiz_Key_Movimientos).Grid
End Function

Private Function pGetPedidosProperty() As cIABMProperty
  Set pGetPedidosProperty = GetWizProperty(m_ObjWizard, _
                                c_StepSelectPedido, _
                                c_Wiz_Key_Movimientos)
End Function

Private Sub pRefreshPedidos()
  m_ObjWizard.ShowValue GetWizProperty(m_ObjWizard, _
                                c_StepSelectPedido, _
                                c_Wiz_Key_Movimientos)
End Sub

Private Sub pRefreshItems()
  m_ObjWizard.ShowValue GetWizProperty(m_ObjWizard, _
                                c_StepSelectItems, _
                                c_Wiz_Key_Items)
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

Private Function pChecPedidos() As Boolean
  If Val(pGetTotal.Value) = 0 Then
    MsgWarning "Debe indicar un o más pedidos."
    Exit Function
  End If
  pChecPedidos = True
End Function

Private Function pChecItems() As Boolean
  If Val(pGetTotalItems.Value) = 0 Then
    MsgWarning "Debe indicar un o más items."
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
    If pCell(Row, KI_SELECT).Id Then
      Ids = Ids & pCell(Row, KI_MF_ID).Id & ","
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
  
  sqlstmt = "sp_DocFacturaVentaGetPedidoItems '" & pGetPedidosIds & "'"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  pGetItems().Rows.Clear
  
  ReDim vMonId(0)
  
  While Not rs.EOF
  
    Set F = pGetItems().Rows.Add(Nothing)
    
    ' La primera no se usa
    Set fv = F.Add(Nothing)
    fv.Id = gDB.ValField(rs.Fields, cscMfiId)
    fv.Key = KII_MFI_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = 0
    fv.Key = KII_SELECT
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscMfNrodoc)
    fv.Key = KI_NRODOC

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscMfNumero)
    fv.Id = gDB.ValField(rs.Fields, cscMfId)
    fv.Key = KI_MF_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscMfdPendiente)
    fv.Key = KII_PENDIENTE

    Set fv = F.Add(Nothing)
    fv.Value = 0
    fv.Key = KII_APLICAR
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscMfiImporte)
    fv.Key = KII_TOTAL
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscMfiDescrip)
    fv.Key = KII_DESCRIP
    
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
  Dim F                 As cIABMGridRow
  Dim fv                As cIABMGridCellValue
  Dim i                 As Long
  
  sqlstmt = "sp_DocFacturaVentaGetPedidos " & EmpId & "," & pGetCliente & ", " & pGetMonId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  pGetPedidos().Rows.Clear
  
  ReDim vMonId(0)
  
  While Not rs.EOF
  
    Set F = pGetPedidos().Rows.Add(Nothing)
    
    ' La primera no se usa
    Set fv = F.Add(Nothing)
    
    Set fv = F.Add(Nothing)
    fv.Value = 0
    fv.Key = KI_SELECT
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscDocNombre)
    fv.Key = KI_DOC
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscMfNrodoc)
    fv.Key = KI_NRODOC

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscMfNumero)
    fv.Id = gDB.ValField(rs.Fields, cscMfId)
    fv.Key = KI_MF_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscMfFecha)
    fv.Key = KI_FECHA
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscMfTotal)
    fv.Key = KI_TOTAL
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscMfDescrip)
    fv.Key = KI_DESCRIP
    
    rs.MoveNext
  Wend
  
  pRefreshPedidos
  pShowTotalPedidos
  
  pLoadPedidosXCliente = True
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
      Case KII_MFI_ID, KII_ARTICULO, KII_PENDIENTE
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
    MsgWarning "Debe indicar la fecha de la factura"
    Exit Function
  End If
  
  If ValEmpty(pGetSucursal().HelpId, csId) Then
    MsgWarning "Debe indicar la sucursal"
    Exit Function
  End If
  
  pValidateDatosGenerales = True
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  ReDim m_MfIds(0)

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
  ReDim m_MfIds(0)
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
  Dim register     As cRegister
  Dim Total      As Double
  Dim Mouse        As cMouseWait

  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  register.fieldId = cscMfTMPId
  register.Table = csTFacturaVentaTMP
  
  register.Id = csNew
  
  ' Header
  register.Fields.Add2 cscMfNumero, 0, csLong
  With pGetComprobante()
    register.Fields.Add2 cscMfNrodoc, SetMask(.Value, .TextMask), csText
  End With
  register.Fields.Add2 cscMfDescrip, pGetDescrip().Value, csText
  register.Fields.Add2 cscMfFecha, pGetFecha().Value, csDate
  register.Fields.Add2 cscCliId, pGetCliente(), csId
  register.Fields.Add2 cscCcosId, pGetCentroCosto().HelpId, csId
  register.Fields.Add2 cscSucId, pGetSucursal().HelpId, csId
  register.Fields.Add2 cscDocId, pGetDoc(), csId
  register.Fields.Add2 cscLgjId, pGetLegajo().HelpId, csId
  register.Fields.Add2 cscMfGrabarasiento, 1, csBoolean
  
  register.Fields.Add2 cscEstId, CSGeneralEx2.csEEstado.csEEst_Pendiente, csId
  register.Fields.Add2 cscRendId, csNew, csLong
  
  pGetFooter Total

  ' Footer
  register.Fields.Add2 cscMfTotal, Total, csCurrency
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "pSave", "cFacturaVentaWizard", c_ErrorSave) Then Exit Function
  
  If Not pSaveItems(register.Id) Then Exit Function
  If Not pSaveVinculacion(register.Id) Then Exit Function
  
  If Not register.CommitTrans() Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocFacturaVentaSave " & register.Id
  If Not gDB.OpenRs(sqlstmt, rs, , , , "pSave", "cFacturaVentaWizard", c_ErrorSave) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim Id As Long
  If Not GetDocIDFromRecordset(rs, Id) Then Exit Function
  
  m_Id = Id
  
  pSave = m_Id <> 0
End Function

Private Function pSaveItems(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim iOrden    As Long
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  Dim sqlstmt   As String
  
  For Each Row In pGetItems().Rows
  
    If Val(pCell(Row, KII_APLICAR).Value) Then
    
      Set register = New cRegister
      register.fieldId = cscRendiTMPId
      register.Table = csTFacturaVentaItemTMP
      register.Id = csNew
      
      For Each Cell In Row
        Select Case Cell.Key
          Case KII_APLICAR
            register.Fields.Add2 cscRendiImporte, Cell.Value, csDouble
          Case KII_DESCRIP
            register.Fields.Add2 cscRendiDescrip, Cell.Value, csText
          Case KII_ARTICULO
            register.Fields.Add2 cscPrId, Cell.Id, csId
          Case KII_CCOS_ID
            register.Fields.Add2 cscCcosId, Cell.Id, csId
        End Select
      Next
    
      ' Esto es muy importante ya que se usa para vincular el pedidoventaitem
      ' con el nuevo Facturaventaitem
      iOrden = iOrden + 1
      register.Fields.Add2 cscRendiOrden, iOrden, csInteger
      
      register.Fields.Add2 cscMfTMPId, Id, csId
      register.Fields.Add2 cscRendiId, Id, csLong
      
      ' Cuentas contables - Por ahora se resuelve asi
      register.Fields.Add2 cscCueId, -1, csId
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSaveItems", "cFacturaVentaWizard", c_ErrorSave) Then Exit Function
    End If
  Next
  
  sqlstmt = "sp_DocFacturaVentaWizardSave " & Id
  If Not gDB.Execute(sqlstmt, "pSaveItems", "cFacturaVentaWizard", c_ErrorSave) Then Exit Function
  
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
    register.fieldId = cscMfrendTMPId
    register.Table = csTMovimientoFondoRendicionTMP
    register.Id = csNew
    
    bSave = False
    For Each Cell In Row
      If pCell(Row, KII_SELECT).Id Then
        bSave = True
        Select Case Cell.Key
          Case KII_MFI_ID
            register.Fields.Add2 cscMfiId, Cell.Id, csId
          Case KII_APLICAR
            register.Fields.Add2 cscMfrendImporte, Cell.Value, csDouble
        End Select
      End If
    Next
    
    If bSave Then
      
      register.Fields.Add2 cscMfrendId, 0, csLong
      register.Fields.Add2 cscMfTMPId, Id, csId
      
      ' Esto es muy importante ya que se usa para vincular el pedidoventaitem
      ' con el nuevo Facturaventaitem
      iOrden = iOrden + 1
      register.Fields.Add2 cscRendiId, iOrden, csLong
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSaveVinculacion", "cFacturaVentaWizard", c_ErrorSave) Then Exit Function
    End If
  Next
  
  pSaveVinculacion = True
End Function

Private Sub pGetFooter(ByRef Total As Double)
  Dim Row           As cIABMGridRow
  Dim Cell          As cIABMGridCellValue
  
  For Each Row In pGetItems().Rows
    If pCell(Row, KII_SELECT).Id Then
      For Each Cell In Row
        Select Case Cell.Key
          Case KII_APLICAR
            Total = Cell.Value
        End Select
      Next
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

