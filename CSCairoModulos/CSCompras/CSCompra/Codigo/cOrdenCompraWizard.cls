VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cOrdenCompraWizard"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIWizardClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cOrdenCompraWizard
' 01-05-2004

'--------------------------------------------------------------------------------
' notas:

  ' Al copiar a factura acordate que tenes que agregar grabarasiento al save

' Reemplazar

' Asistente de ordenes de compra

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cOrdenCompraWizard"

Private Const c_StepWelcome             As Integer = 1
Private Const c_StepSelectProveedor     As Integer = 3
Private Const c_StepSelectPedido        As Integer = 4
Private Const c_StepSelectItems         As Integer = 6
Private Const c_StepDatosGenerales      As Integer = 7

' Paso 2
Private Const KW_PEDIDOS                     As Integer = 10
Private Const KW_TODOS                       As Integer = 110

' Paso 3
Private Const KW_ITEMS                       As Integer = 120
Private Const KW_TODOS_ITEMS                 As Integer = 130

Private Const KI_PC_ID                       As Integer = 1
Private Const KI_SELECT                      As Integer = 2
Private Const KI_DOC                         As Integer = 3
Private Const KI_NRODOC                      As Integer = 4
Private Const KI_FECHA                       As Integer = 5
Private Const KI_DESCRIP                     As Integer = 8
Private Const KI_TOTAL                       As Integer = 10

Private Const KII_SELECT                 As Integer = 1
Private Const KII_PCI_ID                 As Integer = 2
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
Private Const KII_CCOS_ID                As Integer = 18

' pseudo-constantes
Private c_strTitle    As String
Private c_ErrorSave   As String

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
Private m_PcIds()           As Long

Private m_Us_id                        As Long
Private m_Usuario                      As String

Private m_ObjClient         As Object

Private m_bIva              As Boolean
Private m_bIvaRni           As Boolean

Private m_LastProv          As Long
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

Public Property Let prov_id(ByVal rhs As Long)
  m_Prov_id = rhs
End Property

Public Property Let Proveedor(ByVal rhs As String)
  m_proveedor = rhs
End Property

Public Property Let PcIds(ByRef rhs() As Long)
  On Error Resume Next
  Dim i As Long
  ReDim m_PcIds(UBound(rhs))
  For i = 0 To UBound(rhs)
    m_PcIds(i) = rhs(i)
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
  Dim Id As Long
  
  Select Case Key
    Case KW_PEDIDOS
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
    Case KII_SELECT, KII_APLICAR, KII_PRECIO_SIN_IVA
      ' Devuelvo True
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

Private Sub pSelectAllPedidos(ByVal bSelect As Boolean)
  Dim Row As cIABMGridRow
  
  With pGetPedidos
    For Each Row In .Rows
      pCell(Row, KI_SELECT).Id = CInt(bSelect)
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
    ' su proposito es darle una oportunidad al Proveedor del wizard
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
      
      SetDocumentoForDoctId pGetDocProperty(), _
                            m_ObjWizard, _
                            csEDocumentoTipo.csEDT_OrdenCompra, _
                            csEDocumentoTipo.csEDT_PedidoCompra, _
                            m_PcIds, _
                            0
      cIWizardClient_PropertyChange KW_DOC_ID
    
    Case c_StepSelectProveedor
    
      If pGetDoc() = csNO_ID Then
        MsgWarning LNGGetText(1562, vbNullString), c_strTitle
                   'Debe indicar un documento
        nNextStep = c_StepSelectProveedor
      ElseIf pGetProveedor() = csNO_ID Then
        MsgWarning LNGGetText(1860, vbNullString), c_strTitle
                   'Debe indicar un Proveedor
        nNextStep = c_StepSelectProveedor
      ElseIf Not pLoadPedidosXProveedor() Then
        MsgWarning LNGGetText(2172, vbNullString), c_strTitle
                    'No se pudieron cargar los Pedidos para este Proveedor
        nNextStep = c_StepSelectProveedor
      Else
        pGetTodos.Name = c_selectall
        m_ObjWizard.ShowValue pGetTodos
        m_ObjWizard.cmdBack.Enabled = True
        nNextStep = c_StepSelectPedido
      End If
      
    Case c_StepSelectPedido
      If Not pCheckPedidos() Then
        nNextStep = c_StepSelectPedido
      ElseIf Not pLoadItemsXPedidos() Then
        MsgWarning LNGGetText(2173, vbNullString), c_strTitle
                    'No se pudieron cargar los items de los Pedidos para este Proveedor
        nNextStep = c_StepSelectPedido
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
    
    Case c_StepSelectPedido
      m_ObjWizard.cmdBack.Enabled = False
      nNextStep = c_StepSelectProveedor
    
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
                    GetEmailFromProveedor(m_LastProv)
    
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
  ' objecto Proveedor soporta
  ' la interfaz
  On Error Resume Next
  m_ObjClient.TerminateWizard m_Id
End Function

Private Property Get cIWizardClient_Title() As String
  cIWizardClient_Title = LNGGetText(2174, vbNullString) 'Asistente de Ordenes de Compra
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
  pLoadStepSelectPedido
  pLoadStepSelectItems
  pLoadStepDatosGenerales
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
      .Value = LNGGetText(1929, vbNullString) 'Bienvenido al Asistente de Ordenes de Compra
    End With
    
    With .Add(Nothing, c_Wiz_Key_MainTitle)
      .Top = 1200
      .Left = 3000
      '.Name = vbNullString
      .PropertyType = cspLabel
      .Width = 6000
      .Height = 880
      .FontBold = True
      .Value = LNGGetText(1930, vbNullString)
              'Con este asistente usted podra generar las Ordenes de Compra sobre Pedidos.
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
      .Value = LNGGetText(1931, vbNullString)
          'Indique el documento a utilizar y el Proveedor al que se le emitirá la Orden de Compra
    End With
    
    With .Add(Nothing, c_Wiz_Key_Doc)
      .Top = 1500
      .Left = 3700
      .Name = LNGGetText(1567, vbNullString)    'Documento
      .PropertyType = cspHelp
      .HelpFilter = "'doct_id = " & csEDT_OrdenCompra & _
                    " and doc_tipoordencompra = " & csETOrdenPedido & "'"
      .Table = CSDocumento2.CSDocumento
      .Width = 4000
      .Value = m_Documento
      .HelpId = m_doc_id
      .Key = KW_DOC_ID
    End With
  
    With .Add(Nothing, c_Wiz_Key_Proveedor)
      .Top = 2000
      .Left = 3700
      .Name = LNGGetText(1151, vbNullString)    'Proveedor
      .PropertyType = cspHelp
      .Table = csProveedor
      .Width = 4000
      .Value = m_proveedor
      .HelpId = m_Prov_id
      .Key = KW_PROV_ID
    End With

    With .Add(Nothing, c_Wiz_Key_Usuario)
      .Top = 2500
      .Left = 3700
      .Name = LNGGetText(1137, vbNullString)    'Usuario
      .PropertyType = cspHelp
      .Table = csUsuario
      .Width = 4000
      .Value = m_Usuario
      .HelpId = m_Us_id
    End With
  
    ' Edit From ListDoc
    '
    With .Add(Nothing, c_Wiz_Key_OnlySelected)
      .PropertyType = cspCheck
      .Name = LNGGetText(1687, vbNullString)    'Cargar solo pedidos seleccionados
      .Value = UBound(m_PcIds)
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
      .Value = LNGGetText(1688, vbNullString)    'Seleccione los pedidos
    End With
    
    With .Add(Nothing, c_Wiz_Key_Pedidos)
      .Top = 1100
      .Left = 150
      '.Name = vbNullString
      .PropertyType = cspGrid
      .LeftLabel = -1
      pLoadPedidos .Grid
      .Width = 11500
      .Height = 4400
      .Key = KW_PEDIDOS
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
      .Name = LNGGetText(1584, vbNullString)    'Total
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
      .Name = LNGGetText(1223, vbNullString)    'Tipo
      .PropertyType = cspText
      .Width = 3000
      .Key = KI_DOC
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1567, vbNullString)    'Documento
      .PropertyType = cspText
      .Width = 1800
      .Key = KI_NRODOC
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1065, vbNullString)    'Número
      .PropertyType = cspNumeric
      .Width = 800
      .Key = KI_PC_ID
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1569, vbNullString)    'Fecha
      .PropertyType = cspDate
      .Width = 1040
      .Format = "dd/mm/yy"
      .Key = KI_FECHA
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1584, vbNullString)    'Total
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
  
    With .Add(Nothing, c_Wiz_Key_TotalItems)
      .Name = LNGGetText(1584, vbNullString)    'Total
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
      .Key = KII_PCI_ID
    End With
  
    With .Add(Nothing)
      '.Name = vbNullString
      .PropertyType = cspCheck
      .Width = 320
      .Key = KII_SELECT
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1567, vbNullString)    'Documento
      .PropertyType = cspText
      .Width = 1400
      .Key = KI_NRODOC
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1932, vbNullString)    'Nro
      .PropertyType = cspNumeric
      .Width = 700
      .Key = KI_PC_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1367, vbNullString)    'Articulo
      .PropertyType = cspText
      .Width = 2500
      .Key = KII_ARTICULO
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1586, vbNullString)    'Precio
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 920
      .Key = KII_PRECIO_SIN_IVA
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = SecurityCanAccessSilent(csPreCpraEditPriceOrd)
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1374, vbNullString)    'Cantidad
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 920
      .Key = KII_CANTIDAD
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
    
    With .Add(Nothing, c_Wiz_Key_Pendiente)
      .Name = LNGGetText(1609, vbNullString)    'Pendiente
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 920
      .Key = KII_PENDIENTE
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1662, vbNullString)    'Aplicar
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Width = 920
      .Key = KII_APLICAR
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
    
    With .Add(Nothing, c_Wiz_Key_TotalItems)
      .Name = LNGGetText(1584, vbNullString)    'Total
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 920
      .Key = KII_TOTAL
      .Format = m_GeneralConfig.FormatDecImporte
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
      .Key = KII_CCOS_ID
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
      .Value = LNGGetText(1933, vbNullString)
              'Complete los siguientes datos de la Orden de Compra
    End With
  
    With .Add(Nothing, c_Wiz_Key_Fecha)
      .PropertyType = cspDate
      .Left = 2800
      .Name = LNGGetText(1569, vbNullString) 'Fecha
      .Value = Date
    End With
    
    With .Add(Nothing, c_Wiz_Key_Proveedor2)
      .PropertyType = cspHelp
      .Table = csProveedor
      .Enabled = False
      .Name = LNGGetText(1151, vbNullString) 'Proveedor
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
    End With
  
    With .Add(Nothing, c_Wiz_Key_Comprobante)
      .PropertyType = cspText
      .Left = 6800
      .TopFromProperty = c_Wiz_Key_Fecha
      .Name = LNGGetText(1610, vbNullString) 'Comprobante
    End With
  
    With .Add(Nothing, c_Wiz_Key_Legajo)
      .PropertyType = cspHelp
      .Table = csLegajo
      .Name = LNGGetText(1575, vbNullString) 'Legajo
    End With
    
    With .Add(Nothing, c_Wiz_Key_CentroCosto)
      .PropertyType = cspHelp
      .Table = csCentroCosto
      .Name = LNGGetText(1057, vbNullString) 'Centro de Costo
    End With
  
    With .Add(Nothing, c_Wiz_Key_Observaciones)
      .PropertyType = cspText
      .Left = 2800
      .TopFromProperty = c_Wiz_Key_CentroCosto
      .TopToPrevious = 880
      .Height = 880
      .Width = 6250
      .Name = LNGGetText(1861, vbNullString) 'Observaciones
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
                                       c_StepSelectProveedor, _
                                       c_Wiz_Key_Doc)
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

Private Function pGetItemsProperty() As cIABMProperty
  Set pGetItemsProperty = GetWizProperty(m_ObjWizard, _
                              c_StepSelectItems, _
                              c_Wiz_Key_Items)
End Function

Private Function pGetPedidos() As cIABMGrid
  Set pGetPedidos = GetWizProperty(m_ObjWizard, _
                                c_StepSelectPedido, _
                                c_Wiz_Key_Pedidos).Grid
End Function

Private Function pGetPedidosProperty() As cIABMProperty
  Set pGetPedidosProperty = GetWizProperty(m_ObjWizard, _
                                c_StepSelectPedido, _
                                c_Wiz_Key_Pedidos)
End Function

Private Sub pRefreshPedidos()
  Dim ObjWiz As cWizardGeneric
  Set ObjWiz = m_ObjWizard
  
  ObjWiz.ShowValue GetWizProperty(m_ObjWizard, _
                                c_StepSelectPedido, _
                                c_Wiz_Key_Pedidos), True
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

Private Function pGetUsuario() As cIABMProperty
  Set pGetUsuario = GetWizProperty(m_ObjWizard, _
                                c_StepSelectProveedor, _
                                c_Wiz_Key_Usuario)
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

Private Function pCheckPedidos() As Boolean
  Dim Row As cIABMGridRow
  For Each Row In pGetPedidos().Rows
    If pCell(Row, KI_SELECT).Id Then
      pCheckPedidos = True
      Exit Function
    End If
  Next
  
  MsgWarning LNGGetText(1689, vbNullString)   'Debe indicar uno o más pedidos
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
    End If
  Next

  If Not bExistsSelected Then
    MsgWarning LNGGetText(1678, vbNullString) 'Debe indicar uno o más items.
    Exit Function
  End If
  
  pCheckItems = True
End Function

Private Function pValidateRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  pValidateRowItems = True
End Function
'nrs fin

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
      Ids = Ids & pCell(Row, KI_PC_ID).Id & ","
    End If
  Next
  
  pGetPedidosIds = RemoveLastColon(Ids)
End Function

Private Function pLoadItemsXPedidos() As Boolean
  Dim sqlstmt           As String
  Dim rs                As Recordset
  Dim f                 As cIABMGridRow
  Dim fv                As cIABMGridCellValue
  Dim i                 As Long
  
  sqlstmt = "sp_DocOrdenCompraGetPedidoItems " & pGetProveedor() & ",'" & pGetPedidosIds & "'"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  pGetItems().Rows.Clear
  
  While Not rs.EOF
  
    Set f = pGetItems().Rows.Add(Nothing)
    
    ' La primera no se usa
    Set fv = f.Add(Nothing)
    fv.Id = gDB.ValField(rs.fields, cscPciId)
    fv.Key = KII_PCI_ID
    
    Set fv = f.Add(Nothing)
    fv.Value = 0
    fv.Key = KII_SELECT
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPcNrodoc)
    fv.Key = KI_NRODOC

    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPcNumero)
    fv.Id = gDB.ValField(rs.fields, cscPcId)
    fv.Key = KI_PC_ID
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPrNombrecompra)
    fv.Id = gDB.ValField(rs.fields, cscPrId)
    fv.Key = KII_ARTICULO
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPciPrecio & 2)
    fv.Key = KII_PRECIO_SIN_IVA
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPciCantidadaremitir)
    fv.Key = KII_CANTIDAD
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPciPendiente)
    fv.Key = KII_PENDIENTE

    Set fv = f.Add(Nothing)
    fv.Value = 0
    fv.Key = KII_APLICAR
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPciImporte)
    fv.Key = KII_TOTAL
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPciDescrip)
    fv.Key = KII_DESCRIP
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPciPrecio)
    fv.Key = KII_PRECIOIVA
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPciPrecioLista)
    fv.Key = KII_PRECIO_LP
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPciPrecioUsr)
    fv.Key = KII_PRECIO_USR
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPciIvariPorc)
    fv.Key = KII_IVARIPercent
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPciIvarniPorc)
    fv.Key = KII_IVARNIPercent
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscCcosId)
    fv.Key = KII_CCOS_ID
    
    rs.MoveNext
  Wend
  
  pRefreshItems
  pShowTotalItems
  
  pLoadItemsXPedidos = True
End Function

Private Function pLoadPedidosXProveedor() As Boolean
  Dim sqlstmt           As String
  Dim rs                As Recordset
  Dim pc_id             As Long
  
  ' Edit From ListDoc
  '
  Dim bSelected         As Boolean
  Dim bOnlySelected     As Boolean
  
  sqlstmt = "sp_DocOrdenCompraGetPedidos " & EmpId & "," & pGetUsuario().HelpId & ", " & pGetMonId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  ' Edit From ListDoc
  '
  bOnlySelected = pGetOnlySelected().Value
  
  With pGetPedidos().Rows
  
    .Clear
  
    While Not rs.EOF
    
      ' Edit From ListDoc
      '
      pc_id = gDB.ValField(rs.fields, cscPcId)
      
      bSelected = pGetApply(pc_id)
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
            .Value = gDB.ValField(rs.fields, cscPcNrodoc)
            .Key = KI_NRODOC
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPcNumero)
            .Id = gDB.ValField(rs.fields, cscPcId)
            .Key = KI_PC_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPcFecha)
            .Key = KI_FECHA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPcTotal)
            .Key = KI_TOTAL
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPcDescrip)
            .Key = KI_DESCRIP
          End With
        End With
      End If
      rs.MoveNext
    Wend
  End With
  
  pRefreshPedidos
  pShowTotalPedidos
  
  pLoadPedidosXProveedor = True
End Function

' Edit From ListDoc
'
Private Function pGetApply(ByVal pc_id As Long) As Boolean
  Dim i As Long
  
  For i = 1 To UBound(m_PcIds)
    If m_PcIds(i) = pc_id Then
      pGetApply = True
      Exit Function
    End If
  Next
End Function

' Validaciones de Filas de Instrumentos de cobro
Private Function pIsEmptyRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KII_PCI_ID, KII_ARTICULO, KII_PENDIENTE
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
  
  sqlstmt = "sp_ProveedorGetTalonario " & pGetProveedor() & "," & pGetDoc()
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
    MsgWarning LNGGetText(1934, vbNullString) 'Debe indicar la fecha de la Orden de Compra
    Exit Function
  End If
  
  If ValEmpty(pGetCondicionPago().HelpId, csId) Then
    MsgWarning LNGGetText(1561, vbNullString) 'Debe indicar una condición de pago
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

  c_strTitle = LNGGetText(2169, vbNullString) 'Ordenes de Compra
  c_ErrorSave = LNGGetText(1925, vbNullString) 'Error al grabar la orden de compra
  
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  ReDim m_PcIds(0)

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
  ReDim m_PcIds(0)
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
  
  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  register.fieldId = cscOcTMPId
  register.Table = csTOrdenCompraTMP
  
  register.Id = csNew
  
  With register.fields
    
    ' Header
    .Add2 cscOcNumero, 0, csLong
    With pGetComprobante()
      ' PrintDoc
      '
      m_LastNroDoc = SetMask(.Value, .TextMask)
      register.fields.Add2 cscOcNrodoc, m_LastNroDoc, csText
    End With
    .Add2 cscOcDescrip, pGetDescrip().Value, csText
    .Add2 cscOcFecha, pGetFecha().Value, csDate
    .Add2 cscProvId, pGetProveedor(), csId
    .Add2 cscCcosId, pGetCentroCosto().HelpId, csId
    .Add2 cscSucId, pGetSucursal().HelpId, csId
    .Add2 cscDocId, pGetDoc(), csId
    .Add2 cscLgjId, pGetLegajo().HelpId, csId
    .Add2 cscCpgId, pGetCondicionPago().HelpId, csId
  
    .Add2 cscEstId, CSGeneralEx2.csEEstado.csEEst_Pendiente, csId
    .Add2 cscOcId, csNew, csLong
  
    bIvaRni = IsRNI(pGetProveedor)
    pGetFooter Neto, IvaRi, IvaRni, bIvaRni

    ' Footer
    .Add2 cscOcSubtotal, Neto, csCurrency
    .Add2 cscOcNeto, Neto, csCurrency
    .Add2 cscOcIvari, IvaRi, csCurrency
    .Add2 cscOcIvarni, IvaRni, csCurrency
    .Add2 cscOcTotal, Neto + IvaRi + IvaRni, csCurrency  ' Por ahora no hay descuentos
  
    .HaveLastUpdate = True
    .HaveWhoModify = True
  End With
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "pSave", C_Module, c_ErrorSave) Then Exit Function
  
  If Not pSaveItems(register.Id, bIvaRni) Then Exit Function
  If Not pSaveVinculacion(register.Id) Then Exit Function
  
  If Not register.CommitTrans() Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocOrdenCompraSave " & register.Id
  If Not gDB.OpenRs(sqlstmt, rs, , , , "pSave", C_Module, c_ErrorSave) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim Id As Long
  If Not GetDocIDFromRecordset(rs, Id) Then Exit Function
  
  m_Id = Id
  
  pSave = m_Id <> 0
End Function

Private Function pSaveItems(ByVal Id As Long, ByVal bIvaRni As Boolean) As Boolean
  
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
  
  For Each Row In pGetItems().Rows
  
    If Val(pCell(Row, KII_APLICAR).Value) Then
      Set register = New cRegister
      register.fieldId = cscOciTMPId
      register.Table = csTOrdenCompraItemTMP
      register.Id = csNew
      
      For Each Cell In Row
        Select Case Cell.Key
          Case KII_APLICAR
            Cantidad = Cell.Value
            register.fields.Add2 cscOciCantidad, Cell.Value, csDouble
          Case KII_DESCRIP
            register.fields.Add2 cscOciDescrip, Cell.Value, csText
          Case KII_PRECIO_SIN_IVA
            Precio = Cell.Value
            register.fields.Add2 cscOciPrecio, Precio, csCurrency
          Case KII_PRECIO_LP
            register.fields.Add2 cscOciPrecioLista, Cell.Value, csCurrency
          Case KII_PRECIO_USR
            register.fields.Add2 cscOciPrecioUsr, Cell.Value, csCurrency
          Case KII_IVARIPercent
            IvaRi = Cell.Value
            register.fields.Add2 cscOciIvariPorc, IvaRi, csDouble
          Case KII_IVARNIPercent
            If bIvaRni Then
              IvaRni = Cell.Value
            End If
            register.fields.Add2 cscOciIvarniPorc, IvaRni, csDouble
          Case KII_ARTICULO
            register.fields.Add2 cscPrId, Cell.Id, csId
          Case KII_CCOS_ID
            register.fields.Add2 cscCcosId, Cell.Id, csId
        End Select
      Next
      
      Neto = Precio * Cantidad
      register.fields.Add2 cscOciNeto, Neto, csCurrency
      
      IvaRi = Neto * IvaRi / 100
      register.fields.Add2 cscOciIvari, IvaRi, csCurrency
      
      IvaRni = Neto * IvaRni / 100
      register.fields.Add2 cscOciIvarni, IvaRni, csCurrency
      register.fields.Add2 cscOciImporte, Neto + IvaRi + IvaRni, csCurrency
      
      ' Esto es muy importante ya que se usa para vincular el pedidoCompraitem
      ' con el nuevo OrdenCompraitem
      iOrden = iOrden + 1
      register.fields.Add2 cscOciOrden, iOrden, csInteger
      
      register.fields.Add2 cscOcTMPId, Id, csId
      register.fields.Add2 cscOciId, Id, csLong
      
      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
    
    End If
  Next
  
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
    register.fieldId = cscPcOcTMPId
    register.Table = csTPedidoOrdenCompraTMP
    register.Id = csNew
    
    bSave = False
    For Each Cell In Row
      If pCell(Row, KII_SELECT).Id Then
        bSave = True
        Select Case Cell.Key
          Case KII_PCI_ID
            register.fields.Add2 cscPciId, Cell.Id, csId
          Case KII_APLICAR
            register.fields.Add2 cscPcOcCantidad, Cell.Value, csDouble
        End Select
      End If
    Next
    
    If bSave Then
      
      register.fields.Add2 cscPcOcId, 0, csLong
      register.fields.Add2 cscOcTMPId, Id, csId
      
      ' Esto es muy importante ya que se usa para vincular el pedidoCompraitem
      ' con el nuevo OrdenCompraitem
      iOrden = iOrden + 1
      register.fields.Add2 cscOciId, iOrden, csLong
      
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
  
  ' TODO: -- Soportar la lista de precios
  '
  '  Lista de precios
  '  Set iProp = pGetListaPrecio()
  '  iProp.HelpFilter = GetListaPrecioGetXProveedor(m_LastDoc, m_LastProv)
  '
  '  If lp_id <> csNO_ID Then
  '    Set LP = New cListaPrecio
  '    iProp.value = LP.GetData(lp_id, cscLpNombre, csText)
  '    iProp.HelpId = lp_id
  '  End If
  '
  '  m_ObjWizard.ShowValue iProp
  '
  '  ' Lista de descuentos
  '  Set iProp = pGetListaDescuento()
  '  iProp.HelpFilter = GetListaDescGetXProveedor(m_LastDoc, m_LastProv)
  '
  '  If ld_id <> csNO_ID Then
  '    Set LD = New cListaDescuento
  '    iProp.value = LD.GetData(ld_id, cscLdNombre, csText)
  '    iProp.HelpId = ld_id
  '  End If
  '
  '  m_ObjWizard.ShowValue iProp
  
  ' Talonario y Categoria fiscal
  pGetIvaFromProveedor m_LastProv, m_bIva, m_bIvaRni
End Sub

Private Sub pNewEmptyProperties()
  ' (ByRef Grid As cIABMGrid)
  
  pGetPedidos().Rows.Clear
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
  With pGetLegajo()
    .HelpId = csNO_ID
    .Value = vbNullString
  End With
  
  ' TODO: -- Soportar la lista de precios
  '
  'With pGetListaPrecio()
  '  .HelpId = csNO_ID
  '  .value = vbnullstring
  'End With
  'With pGetListaDescuento()
  '  .HelpId = csNO_ID
  '  .value = vbnullstring
  'End With
  
  pGetDescrip().Value = vbNullString
  
  With m_ObjWizard
    .ShowValue pGetPedidosProperty()
    .ShowValue pGetItemsProperty()
    .ShowValue pGetComprobante()
    .ShowValue pGetCentroCosto()
    .ShowValue pGetCondicionPago()
    .ShowValue pGetLegajo()
    
    ' TODO: -- Soportar la lista de precios
    '
    '.ShowValue pGetListaPrecio()
    '.ShowValue pGetListaDescuento()
    .ShowValue pGetDescrip()
  End With
  
End Sub
