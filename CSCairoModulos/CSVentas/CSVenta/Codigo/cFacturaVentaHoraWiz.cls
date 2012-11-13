VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFacturaVentaHoraWiz"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIWizardClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cFacturaVentaHoraWiz
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
Private Const C_Module = "cFacturaVentaHoraWiz"

Private Const c_StepWelcome             As Integer = 1
Private Const c_StepSelectCliente       As Integer = 3
Private Const c_StepSelectProyecto      As Integer = 4
Private Const c_StepSelectHoras         As Integer = 6
Private Const c_StepPercepciones        As Integer = 7
Private Const c_StepDatosGenerales      As Integer = 8

' Paso 2
Private Const KW_PROYECTOS                   As Integer = 10
Private Const KW_TODOS                       As Integer = 110

' Paso 3
Private Const KW_HORAS                       As Integer = 120
Private Const KW_TODOS_HORAS                 As Integer = 130

' Paso 4
Private Const KW_PERCEPCIONES                   As Integer = 150
Private Const KW_TOTAPERCEPCIONES               As Integer = 160

' Paso 5
Private Const KW_CLIENTE2                    As Integer = 220
Private Const KW_FECHA                       As Integer = 230
Private Const KW_FECHAIVA                    As Integer = 231
Private Const KW_SUCURSAL                    As Integer = 240
Private Const KW_CONDICION_PAGO              As Integer = 245
Private Const KW_DESCRIP                     As Integer = 250
Private Const KW_COMPROBANTE                 As Integer = 260
Private Const KW_LEGAJO                      As Integer = 280
Private Const KW_CENTROCOSTO                 As Integer = 290
Private Const KW_DOC_ID                      As Integer = 320
Private Const KW_CLI_ID                      As Integer = 340

Private Const KW_COTIZACION                  As Integer = 350 'lp

Private Const KW_PRO_ID_ORIGEN               As Integer = 390 'lp
Private Const KW_PRO_ID_DESTINO              As Integer = 400 'lp

Private Const KW_ORDENCOMPRA                 As Integer = 670

Private Const KI_PROY_ID                     As Integer = 1
Private Const KI_SELECT                      As Integer = 2
Private Const KI_DESCRIP                     As Integer = 3

' TO
Private Const KII_TO_ID                  As Integer = 400

Private Const KII_SELECT                 As Integer = 1
Private Const KII_HORA_ID                As Integer = 2
Private Const KII_ARTICULO               As Integer = 5
Private Const KII_CANTIDAD               As Integer = 6
Private Const KII_PENDIENTE              As Integer = 7
Private Const KII_APLICAR                As Integer = 8
Private Const KII_PRECIOIVA              As Integer = 9
Private Const KII_TOTAL                  As Integer = 10
Private Const KII_TITULO                 As Integer = 11
Private Const KII_PRECIO_SIN_IVA         As Integer = 12
Private Const KII_PRECIO_LP              As Integer = 13
Private Const KII_PRECIO_USR             As Integer = 14
Private Const KII_IVARIPercent           As Integer = 15
Private Const KII_IVARNIPercent          As Integer = 16
Private Const KII_DESCUENTO              As Integer = 17
Private Const KII_CCOS_ID                As Integer = 18

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
Private m_Cliente           As String
Private m_doc_id            As Long
Private m_Documento         As String
Private m_HoraIds()         As Long

Private m_ObjClient         As Object

Private m_bIva              As Boolean
Private m_bIvaRni           As Boolean

Private m_LastCli           As Long
Private m_LastDoc           As Long

Private m_lastmonid         As Long

' PrintDoc
'
Private m_LastNroDoc        As String

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

Public Property Let HoraIds(ByRef rhs() As Long)
  On Error Resume Next
  Dim i As Long
  ReDim m_HoraIds(UBound(rhs))
  For i = 0 To UBound(rhs)
    m_HoraIds(i) = rhs(i)
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
    Case KW_PROYECTOS
      cIABMClientGrid_IsEmptyRow = False
    Case KW_HORAS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowHoras(Row, RowIndex)
    Case KW_PERCEPCIONES
      cIABMClientGrid_IsEmptyRow = IsEmptyRowPercepciones(Row, RowIndex)
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
    Case KW_PROYECTOS
      cIABMClientGrid_ColumnAfterUpdate = True
    Case KW_HORAS
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateHoras(pGetHorasProperty(), lRow, lCol)
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
    Case KW_PROYECTOS
      cIABMClientGrid_ColumnAfterEdit = True
    Case KW_HORAS
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
    Case KW_PROYECTOS
      cIABMClientGrid_ColumnBeforeEdit = pColBEditProyectos(pGetProyectosProperty(), lRow, lCol, iKeyAscii)
    Case KW_HORAS
      cIABMClientGrid_ColumnBeforeEdit = pColBEditHoras(pGetHorasProperty(), lRow, lCol, iKeyAscii)
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
    Case KW_PROYECTOS
    Case KW_HORAS
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

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)
  
End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case KW_PROYECTOS
      cIABMClientGrid_ValidateRow = True
    Case KW_HORAS
      cIABMClientGrid_ValidateRow = pValidateRowHoras(Row, RowIndex)
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

Private Function pValidateRowHoras(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
  
    If pCell(Row, KII_SELECT).id Then
  
      Select Case Cell.Key
        Case KII_CANTIDAD
          If ValEmpty(Cell.Value, csDate) Then
            MsgInfo LNGGetText(1365, vbNullString, strRow)
                    'Debe indicar una cantidad (1)
            Exit Function
          End If
      End Select
    End If
  Next
  
  pValidateRowHoras = True
End Function

Private Function pColBEditHoras(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  Select Case pGetKeyFromCol(IProperty.Grid.Columns, lCol)
    Case KII_SELECT, KII_APLICAR, KII_PRECIO_SIN_IVA, KII_TO_ID ' TO
    Case Else
      Exit Function
  End Select

  pColBEditHoras = True
End Function

Private Function pColBEditProyectos(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
  Select Case pGetKeyFromCol(IProperty.Grid.Columns, lCol)
    Case KI_SELECT
    Case Else
      Exit Function
  End Select
  
  pColBEditProyectos = True
End Function

Private Function pColAUpdateHoras(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long)
  Dim Row      As cIABMGridRow
  Dim Value    As Double
  Dim MaxVal   As Double
  
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      
      Case KII_SELECT
        Set Row = .Rows(lRow)
        pSelectHora Row, .Columns
        pShowTotalHoras
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
        pShowTotalHoras
        SetTotal Row, KII_TOTAL, KII_APLICAR, KII_PRECIOIVA
        
      Case KII_PRECIO_SIN_IVA
        Set Row = .Rows(lRow)
        SetPrecioIva Row, KII_PRECIO_SIN_IVA, KII_IVARIPercent, _
                     KII_IVARNIPercent, KII_PRECIOIVA, _
                     m_bIva, m_bIvaRni
        pShowTotalHoras
        SetTotal Row, KII_TOTAL, KII_APLICAR, KII_PRECIOIVA
        
      Case Else
        pColAUpdateHoras = True
        Exit Function
    End Select
  End With
  
  pColAUpdateHoras = True
End Function

Private Sub pSelectAllProyectos(ByVal bSelect As Boolean)
  Dim Row As cIABMGridRow
  
  With pGetProyectos
    For Each Row In .Rows
      pCell(Row, KI_SELECT).id = CInt(bSelect)
    Next
  End With
  
  Dim ObjWiz As cWizardGeneric
  Set ObjWiz = m_ObjWizard
  
  ObjWiz.ShowValue pGetProyectosProperty, True
End Sub

Private Sub pSelectAllHoras(ByVal bSelect As Boolean)
  Dim Row As cIABMGridRow
  
  With pGetHoras
    For Each Row In .Rows
      pCell(Row, KII_SELECT).id = CInt(bSelect)
      pSelectHora Row, .Columns
      SetTotal Row, KII_TOTAL, KII_APLICAR, KII_PRECIOIVA
    Next
  End With
  
  Dim ObjWiz As cWizardGeneric
  Set ObjWiz = m_ObjWizard
  
  ObjWiz.ShowValue pGetHorasProperty, True
End Sub

Private Sub pSelectHora(ByRef Row As cIABMGridRow, ByRef Columns As cIABMGridColumns)
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

Private Sub pShowTotalHoras()
  Dim Row           As cIABMGridRow
  Dim Total         As Double
  
  For Each Row In pGetHoras().Rows
    Total = Total + Val(pCell(Row, KII_APLICAR).Value) * Val(pCell(Row, KII_PRECIOIVA).Value)
  Next
  
  pGetTotalHoras().Value = Total
  
  m_ObjWizard.ShowValue pGetTotalHoras
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
    
    Case c_StepSelectHoras
    
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
                            0, _
                            m_HoraIds, _
                            -1 ' Horas
      cIWizardClient_PropertyChange KW_DOC_ID
    
    Case c_StepSelectCliente
    
      If pGetDoc() = csNO_ID Then
        MsgWarning LNGGetText(1562, vbNullString), LNGGetText(1607, vbNullString)
        'MsgWarning "Debe indicar un documento", "Facturas"
        nNextStep = c_StepSelectCliente
      ElseIf pGetCliente() = csNO_ID Then
        MsgWarning LNGGetText(1563, vbNullString), LNGGetText(1607, vbNullString)
        'MsgWarning "Debe indicar un cliente", "Facturas"
        nNextStep = c_StepSelectCliente
      ElseIf Not pLoadProyectosXCliente() Then
        MsgWarning LNGGetText(1651, vbNullString), LNGGetText(1607, vbNullString)
        'MsgWarning "No se pudieron cargar los Proyectos para este Cliente", "Facturas"
        nNextStep = c_StepSelectCliente
      Else
        pGetTodos.Name = c_selectall
        m_ObjWizard.ShowValue pGetTodos
        m_ObjWizard.cmdBack.Enabled = True
        nNextStep = c_StepSelectProyecto
      End If
      
    Case c_StepSelectProyecto
      If Not pChecProyectos() Then
        nNextStep = c_StepSelectProyecto
      ElseIf Not pLoadHorasXProyectos() Then
        MsgWarning LNGGetText(1652, vbNullString), LNGGetText(1607, vbNullString)
              'No se pudieron cargar las horas de los Proyectos para este Cliente", "Facturas"
        nNextStep = c_StepSelectProyecto
      Else
        nNextStep = c_StepSelectHoras
      End If
    
    Case c_StepSelectHoras
      If Not pCheckHoras() Then
        nNextStep = c_StepSelectHoras
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
    
    Case c_StepSelectProyecto
      m_ObjWizard.cmdBack.Enabled = False
      nNextStep = c_StepSelectCliente
    
    Case c_StepSelectHoras
      nNextStep = c_StepSelectProyecto
    
    Case c_StepPercepciones
      nNextStep = c_StepSelectHoras
    
    Case c_StepDatosGenerales
      m_ObjWizard.cmdNext.Caption = c_WizStr_Next
      nNextStep = c_StepPercepciones

'    Case c_StepDatosGenerales
'      m_ObjWizard.cmdNext.Caption = c_WizStr_Next
'      nNextStep = c_StepSelectHoras
  End Select

  cIWizardClient_PreviousStep = True
End Function

Private Function cIWizardClient_PropertyChange(ByVal Key As Integer) As Boolean
  Dim ObjWiz As cWizardGeneric
  
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
        pSelectAllProyectos True
        pGetTodos.Name = c_unselectall
      Else
        pSelectAllProyectos False
        pGetTodos.Name = c_selectall
      End If
      m_ObjWizard.ShowValue pGetTodos
  
    Case KW_TODOS_HORAS
      If pGetTodosHoras.Name = c_selectall Then
        pSelectAllHoras True
        pGetTodosHoras.Name = c_unselectall
      Else
        pSelectAllHoras False
        pGetTodosHoras.Name = c_selectall
      End If
      m_ObjWizard.ShowValue pGetTodosHoras
      pShowTotalHoras
  
    Case KW_DOC_ID
      m_LastDoc = pGetDoc()
      
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
  pLoadStepSelectProyecto
  pLoadStepSelectHoras
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
      .Value = LNGGetText(1653, vbNullString)  'Bienvenido al Asistente de Facturas de Venta
    End With
    
    With .Add(Nothing, c_Wiz_Key_MainTitle)
      .Top = 1200
      .Left = 3000
      '.Name = vbNullString
      .PropertyType = cspLabel
      .Width = 6000
      .Height = 880
      .FontBold = True
      .Value = LNGGetText(1654, vbNullString)  'Con este asistente usted podrá generar las facturas sobre proyectos.
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
      .Value = LNGGetText(1655, vbNullString)  'Indique el documento a utilizar y el cliente al que se le emitirá la factura
    End With
    
    With .Add(Nothing, c_Wiz_Key_Doc)
      .Top = 1500
      .Left = 3700
      .Name = LNGGetText(1567, vbNullString)  'Documento
      .PropertyType = cspHelp
      .HelpFilter = "'doct_id = " & csEDT_FacturaVenta & " and " & cscDocTipoFactura & " = " & csETFacProyecto & "'"
      .Table = CSDocumento2.CSDocumento
      .Width = 4000
      .Value = m_Documento
      .HelpId = m_doc_id
      .Key = KW_DOC_ID
    End With
  
    With .Add(Nothing, c_Wiz_Key_Cliente)
      .Top = 2000
      .Left = 3700
      .Name = LNGGetText(1150, vbNullString)  'Cliente
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
      .Name = LNGGetText(1656, vbNullString)  'Cargar solo horas seleccionadas
      
      If m_UserCfg.ShowAllInWizard Then
        .Value = 0
      Else
        .Value = UBound(m_HoraIds)
      End If
      .Left = 5310
      .LeftLabel = -2800
    End With
  End With
End Sub

Private Sub pLoadStepSelectProyecto()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepSelectProyecto)).Properties
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
      .Value = LNGGetText(1657, vbNullString)  'Seleccione los proyectos
    End With
    
    With .Add(Nothing, c_Wiz_Key_Proyectos)
      .Top = 1100
      .Left = 150
      '.Name = vbNullString
      .PropertyType = cspGrid
      .LeftLabel = -1
      pLoadProyectos .Grid
      .Width = 11500
      .Height = 4400
      .Key = KW_PROYECTOS
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

Private Sub pLoadProyectos(ByRef Grid As cIABMGrid)
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
      .Name = LNGGetText(1658, vbNullString)  'Proyecto
      .PropertyType = cspText
      .Width = 800
      .Key = KI_PROY_ID
    End With
  
    With .Add(Nothing)
      .Name = C_strDescrip
      .PropertyType = cspText
      .Width = 3000
      .Key = KI_DESCRIP
    End With
  End With
End Sub

Private Sub pLoadStepSelectHoras()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepSelectHoras)).Properties
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
      .Value = LNGGetText(1659, vbNullString)
            'Seleccione las horas he indique las cantidades que facturará de cada una de ellas
    End With
    
    With .Add(Nothing, c_Wiz_Key_Horas)
      .Top = 1100
      .Left = 150
      '.Name = vbNullString
      .PropertyType = cspGrid
      .LeftLabel = -1
      pLoadHoras .Grid
      .Width = 11500
      .Height = 4400
      .Key = KW_HORAS
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
    End With
  
    With .Add(Nothing, c_Wiz_Key_TodosHoras)
      .Name = c_selectall
      .Top = 5550
      .Left = 200
      .LeftLabel = -1
      .Width = 2200
      .PropertyType = cspButton
      .Key = KW_TODOS_HORAS
    End With
    
    With .Add(Nothing, c_Wiz_Key_TotalHoras)
      .Name = LNGGetText(1584, vbNullString) 'Total
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

Private Sub pLoadHoras(ByRef Grid As cIABMGrid)
  With Grid.Columns

    ' La primera simpre esta invisible
    With .Add(Nothing)
      .Visible = False
      .Key = KII_HORA_ID
    End With
    
    With .Add(Nothing)
      '.Name = vbNullString
      .PropertyType = cspCheck
      .Width = 320
      .Key = KII_SELECT
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1658, vbNullString) 'Proyecto
      .PropertyType = cspText
      .Width = 800
      .Key = KI_PROY_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1367, vbNullString) 'Articulo
      .PropertyType = cspText
      .Width = 3000
      .Key = KII_ARTICULO
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1586, vbNullString) 'Precio
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 920
      .Key = KII_PRECIO_SIN_IVA
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = SecurityCanAccessSilent(csPreVtaEditPriceFac)
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1660, vbNullString) 'Horas
      .PropertyType = cspTime
      .Width = 920
      .Key = KII_CANTIDAD
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
      .Width = 920
      .Key = KII_APLICAR
      .Format = m_GeneralConfig.FormatDecCantidad
    End With
    
    With .Add(Nothing, c_Wiz_Key_TotalHoras)
      .Name = LNGGetText(1584, vbNullString) 'Total
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Width = 920
      .Key = KII_TOTAL
      .Format = m_GeneralConfig.FormatDecImporte
    End With
    
    ' TO
    With .Add(Nothing)
      .Name = LNGGetText(1661, vbNullString) 'Tipo Operación
      .PropertyType = cspHelp
      .Table = csTipoOperacion
      .Width = 1800
      .Key = KII_TO_ID
    End With
    
    With .Add(Nothing)
      .Name = C_strDescrip
      .PropertyType = cspText
      .Width = 3000
      .Key = KII_TITULO
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
      .Name = LNGGetText(1057, vbNullString) 'Centro de costo
      .PropertyType = cspHelp
      .Table = csCentroCosto
      .Key = KII_CCOS_ID
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
      .Value = LNGGetText(1663, vbNullString) 'Complete los siguientes datos de la factura
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
  
    With .Add(Nothing, c_Wiz_Key_Legajo)
      .PropertyType = cspHelp
      .Table = csLegajo
      .Name = LNGGetText(1575, vbNullString) 'Legajo
      .Key = KW_LEGAJO
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
    
    If Ask(LNGGetText(1665, vbNullString), vbNo) Then
    'If Ask("Desea cancelar el proceso", vbNo) Then
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
                                c_StepSelectProyecto, _
                                c_Wiz_Key_Todos)
End Function

Private Function pGetTodosHoras() As cIABMProperty
  Set pGetTodosHoras = GetWizProperty(m_ObjWizard, _
                                 c_StepSelectHoras, _
                                 c_Wiz_Key_TodosHoras)
End Function

Private Function pGetTotal() As cIABMProperty
  Set pGetTotal = GetWizProperty(m_ObjWizard, _
                                c_StepSelectProyecto, _
                                c_Wiz_Key_Total)
End Function

Private Function pGetTotalHoras() As cIABMProperty
  Set pGetTotalHoras = GetWizProperty(m_ObjWizard, _
                                 c_StepSelectHoras, _
                                 c_Wiz_Key_TotalHoras)
End Function

Private Function pGetTotalPercepciones() As cIABMProperty
  Set pGetTotalPercepciones = GetWizProperty(m_ObjWizard, _
                                             c_StepPercepciones, _
                                             c_Wiz_Key_TotalPercepciones)
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

Private Function pGetHoras() As cIABMGrid
  Set pGetHoras = GetWizProperty(m_ObjWizard, _
                                 c_StepSelectHoras, _
                                 c_Wiz_Key_Horas).Grid
End Function

Private Function pGetPercepciones() As cIABMGrid
  Set pGetPercepciones = GetWizProperty(m_ObjWizard, _
                                      c_StepPercepciones, _
                                      c_Wiz_Key_percepciones).Grid
End Function

Private Function pGetHorasProperty() As cIABMProperty
  Set pGetHorasProperty = GetWizProperty(m_ObjWizard, _
                                 c_StepSelectHoras, _
                                 c_Wiz_Key_Horas)
End Function

Private Function pGetPercepcionesProperty() As cIABMProperty
  Set pGetPercepcionesProperty = GetWizProperty(m_ObjWizard, _
                                                c_StepPercepciones, _
                                                c_Wiz_Key_percepciones)
End Function

Private Function pGetProyectos() As cIABMGrid
  Set pGetProyectos = GetWizProperty(m_ObjWizard, _
                                    c_StepSelectProyecto, _
                                    c_Wiz_Key_Proyectos).Grid
End Function

Private Function pGetProyectosProperty() As cIABMProperty
  Set pGetProyectosProperty = GetWizProperty(m_ObjWizard, _
                                    c_StepSelectProyecto, _
                                    c_Wiz_Key_Proyectos)
End Function

Private Sub pRefreshProyectos()
  Dim ObjWiz As cWizardGeneric
  Set ObjWiz = m_ObjWizard
  
  ObjWiz.ShowValue GetWizProperty(m_ObjWizard, _
                                  c_StepSelectProyecto, _
                                  c_Wiz_Key_Proyectos), True
End Sub

Private Sub pRefreshHoras()
  Dim ObjWiz As cWizardGeneric
  Set ObjWiz = m_ObjWizard
  
  ObjWiz.ShowValue GetWizProperty(m_ObjWizard, _
                                 c_StepSelectHoras, _
                                 c_Wiz_Key_Horas), True
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

Private Function pChecProyectos() As Boolean
  Dim Row As cIABMGridRow
  For Each Row In pGetProyectos().Rows
    If pCell(Row, KI_SELECT).id Then
      pChecProyectos = True
      Exit Function
    End If
  Next
  
  MsgWarning LNGGetText(1666, vbNullString)   'Debe indicar uno o más Proyectos.
End Function

Private Function pCheckPercepciones() As Boolean
  pCheckPercepciones = True
End Function

Private Function pCheckHoras() As Boolean
  Dim Row                 As cIABMGridRow
  Dim bExistsSelected     As Boolean
  Dim i                   As Long
  
  For Each Row In pGetHoras().Rows
    i = i + 1
    If Val(pCell(Row, KII_APLICAR).Value) > 0 Then
      If Not pValidateRowHoras(Row, i) Then Exit Function
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
    MsgWarning LNGGetText(1668, vbNullString) 'Debe indicar una o más Horas.
    Exit Function
  End If
  
  If Not Val(pGetTotalHoras.Value) > 0 Then
    MsgWarning LNGGetText(1668, vbNullString) 'Debe indicar una o más Horas.
    Exit Function
  End If
  
  pCheckHoras = True
End Function

Private Function pGetProyectosIds() As String
  Dim Row         As cIABMGridRow
  Dim Ids         As String
  
  For Each Row In pGetProyectos().Rows
    If pCell(Row, KI_SELECT).id Then
      Ids = Ids & pCell(Row, KI_PROY_ID).id & ","
    End If
  Next
  
  pGetProyectosIds = RemoveLastColon(Ids)
End Function

Private Function pLoadHorasXProyectos() As Boolean
  Dim sqlstmt           As String
  Dim rs                As Recordset
  Dim hora_id           As Long
  
  ' Edit From ListDoc
  '
  Dim bSelected         As Boolean
  Dim bOnlySelected     As Boolean
  
  sqlstmt = "sp_DocFacturaVentaGetProyectoHoras '" & pGetProyectosIds & "'"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  ' Edit From ListDoc
  '
  bOnlySelected = pGetOnlySelected().Value
  
  With pGetHoras().Rows
    
    .Clear
  
    While Not rs.EOF
    
      ' Edit From ListDoc
      '
      hora_id = gDB.ValField(rs.fields, cscHoraId)
      
      bSelected = pGetApply(hora_id)
      If Not bOnlySelected Or bSelected Then
      
        With .Add(Nothing)
          
          ' La primera no se usa
          With .Add(Nothing)
            .id = gDB.ValField(rs.fields, cscHoraId)
            .Key = KII_HORA_ID
          End With
          
          With .Add(Nothing)
            .id = CInt(bSelected)
            .Key = KII_SELECT
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscProyNombre)
            .id = gDB.ValField(rs.fields, cscProyId)
            .Key = KI_PROY_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrNombreVenta)
            .id = gDB.ValField(rs.fields, cscPrId)
            .Key = KII_ARTICULO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscProypPrecio & "2")
            .Key = KII_PRECIO_SIN_IVA
          End With
          
          With .Add(Nothing)
            .Value = Format(TimeSerial(gDB.ValField(rs.fields, cscHoraHoras), _
                                       gDB.ValField(rs.fields, cscHoraMinutos), _
                                       0), "hh:nn")
            .Key = KII_CANTIDAD
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscHoraPendiente)
            .Key = KII_PENDIENTE
          End With
          
          With .Add(Nothing)
            If bSelected Then
              .Value = gDB.ValField(rs.fields, cscHoraPendiente)
            Else
              .Value = 0
            End If
            .Key = KII_APLICAR
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscHoraImporte)
            .Key = KII_TOTAL
          End With
          
          With .Add(Nothing)
            .id = C_TO_ComercialId
            .Value = C_TO_Comercial
            .Key = KII_TO_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscHoraTitulo)
            .Key = KII_TITULO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscProypPrecioIva)
            .Key = KII_PRECIOIVA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscProypPrecio)
            .Key = KII_PRECIO_LP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscProypPrecio)
            .Key = KII_PRECIO_USR
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscHoraIvariporc)
            .Key = KII_IVARIPercent
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscHoraIvarniporc)
            .Key = KII_IVARNIPercent
          End With
          
          With .Add(Nothing)
            .Value = 0
            .Key = KII_DESCUENTO
          End With
          
          With .Add(Nothing)
            .Key = KII_CCOS_ID
          End With
        End With
      End If
      
      rs.MoveNext
    Wend
  End With
  
  pRefreshHoras
  pShowTotalHoras
  
  pLoadHorasXProyectos = True
End Function

Private Function pLoadProyectosXCliente() As Boolean
  Dim sqlstmt           As String
  Dim rs                As Recordset
  
  sqlstmt = "sp_DocFacturaVentaGetProyectos " & EmpId & "," & pGetCliente & ", " & GetMonIdFromDoc(pGetDoc)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  With pGetProyectos().Rows
    
    .Clear
  
    While Not rs.EOF
      
      With .Add(Nothing)
      
        ' La primera no se usa
        .Add Nothing
        
        With .Add(Nothing)
          .id = 0
          .Key = KI_SELECT
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscProyNombre)
          .id = gDB.ValField(rs.fields, cscProyId)
          .Key = KI_PROY_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscProyDescrip)
          .Key = KI_DESCRIP
        End With
      End With
      
      rs.MoveNext
    Wend
  End With
  
  pRefreshProyectos
  
  pLoadProyectosXCliente = True
End Function

' Edit From ListDoc
'
Private Function pGetApply(ByVal hora_id As Long) As Boolean
  Dim i As Long
  
  For i = 1 To UBound(m_HoraIds)
    If m_HoraIds(i) = hora_id Then
      pGetApply = True
      Exit Function
    End If
  Next
End Function

' Validaciones de Filas
Private Function pIsEmptyRowHoras(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KII_HORA_ID, KII_ARTICULO, KII_PENDIENTE
        If Not ValEmpty(Cell.id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
      
      Case KII_TITULO, KII_CANTIDAD
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
  
  pIsEmptyRowHoras = bRowIsEmpty
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
    MsgWarning LNGGetText(1669, vbNullString) 'Debe indicar la fecha de la Factura
    Exit Function
  End If
  
  If ValEmpty(pGetCondicionPago().HelpId, csId) Then
    MsgWarning LNGGetText(1561, vbNullString) 'Debe indicar la condición de pago
    Exit Function
  End If
  
  If ValEmpty(pGetCotizacion().Value, csDouble) And WizMustValidateCotizacion(pGetDoc()) Then
    MsgWarning LNGGetText(1626, vbNullString) 'Debe indicar la cotizacion
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

  c_ErrorSave = LNGGetText(2220, vbNullString) 'Error al grabar la Factura de Venta
  
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load
  
  ReDim m_HoraIds(0)

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
  
  ' Preferencias del Usuario
  '
  Set m_UserCfg = Nothing
  
  ReDim m_HoraIds(0)
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
      
      .Add2 cscProIdOrigen, pGetProOrigen().HelpId, csId
      .Add2 cscProIdDestino, pGetProDestino().HelpId, csId
      
      .Add2 cscFvGrabarAsiento, 1, csBoolean
    
      .Add2 cscEstId, CSGeneralEx2.csEEstado.csEEst_Pendiente, csId
      .Add2 cscFvId, csNew, csLong
      
      bIvaRni = IsRNI(pGetCliente)
      pGetFooter Neto, IvaRi, IvaRni, bIvaRni
    
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
    
    If Not pSaveHoras(.id, Cotizacion, bMonedaLegal, bIvaRni) Then Exit Function
    
    If Not SavePercepciones(pGetPercepcionesProperty, _
                            .id, Cotizacion, bMonedaLegal, _
                            False, vbNullString, _
                            csNO_ID, C_Module) Then Exit Function
    
    If Not pSaveVinculacion(.id) Then Exit Function
    
    If Not register.CommitTrans() Then Exit Function
  
  End With
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocFacturaVentaSave " & register.id
  If Not gDB.OpenRs(sqlstmt, rs, , , , "pSave", C_Module, c_ErrorSave) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim id As Long
  If Not GetDocIDFromRecordset(rs, id) Then Exit Function
  
  m_Id = id
  
  pSave = m_Id <> 0
End Function

Private Function pSaveHoras(ByVal id As Long, _
                            ByVal Cotizacion As Double, _
                            ByVal bMonedaLegal As Boolean, _
                            ByVal bIvaRni As Boolean) As Boolean
                            
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
  
  For Each Row In pGetHoras().Rows
  
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
              Case KII_TITULO
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
          
          Importe = Neto + IvaRi + IvaRni
          .Add2 cscFviImporte, Importe, csCurrency
          
          If bMonedaLegal Then
            .Add2 cscFviImporteOrigen, 0, csCurrency
          Else
            .Add2 cscFviImporteOrigen, DivideByCero(Importe, Cotizacion), csCurrency
          End If
          
          ' Esto es muy importante ya que se usa para vincular la hora
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
      End With
      
      If Not gDB.Save(register, , "pSaveHoras", C_Module, c_ErrorSave) Then Exit Function
      
    End If
  Next
  
  sqlstmt = "sp_DocFacturaVentaWizardSave " & id
  If Not gDB.Execute(sqlstmt, "pSaveHoras", C_Module, c_ErrorSave) Then Exit Function
  
  pSaveHoras = True
End Function

Private Function pSaveVinculacion(ByVal id As Long) As Boolean
  Dim register        As cRegister
  Dim iOrden          As Long
  Dim bSave           As Boolean
  Dim Row             As cIABMGridRow
  Dim Cell            As cIABMGridCellValue
  
  For Each Row In pGetHoras().Rows
  
    Set register = New cRegister
    
    With register
    
      .fieldId = cscHoraFvTMPId
      .Table = csTHoraFacturaVentaTMP
      .id = csNew
    
      bSave = False
      
      With .fields
        For Each Cell In Row
          If pCell(Row, KII_SELECT).id Then
            bSave = True
            Select Case Cell.Key
              Case KII_HORA_ID
                .Add2 cscHoraId, Cell.id, csId
              Case KII_APLICAR
                .Add2 cscHoraFvCantidad, Cell.Value, csDouble
            End Select
          End If
        Next
        
        If bSave Then
          
          .Add2 cscHoraFvId, 0, csLong
          .Add2 cscFvTMPId, id, csId
          
          ' Esto es muy importante ya que se usa para vincular la hora
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

Private Sub pGetFooter(ByRef Neto As Double, ByRef IvaRi As Double, ByRef IvaRni As Double, ByVal bIvaRni As Boolean)
  Dim Row           As cIABMGridRow
  Dim Cell          As cIABMGridCellValue
  Dim Precio        As Double
  Dim Cantidad      As Double
  Dim IvaRniPercent As Double
  Dim IvaRiPercent  As Double
  
  For Each Row In pGetHoras().Rows
    
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
  
  
  ' Talonario y Categoria fiscal
  pGetIvaFromCliente m_LastCli
  
'////////////////////////////////////////////////////////////

  ' Percepciones
  LoadPercepcionesForCliente m_LastCli, _
                             m_vPercepciones(), _
                             pGetFecha().Value
End Sub

Private Sub pNewEmptyProperties()
  ' (ByRef Grid As cIABMGrid)
  
  pGetProyectos().Rows.Clear
  pGetHoras().Rows.Clear
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
  With pGetProOrigen()
    .HelpId = csNO_ID
    .Value = vbNullString
  End With
  With pGetProDestino()
    .HelpId = csNO_ID
    .Value = vbNullString
  End With
  With pGetLegajo()
    .HelpId = csNO_ID
    .Value = vbNullString
  End With
  
  pGetDescrip().Value = vbNullString
  
  With m_ObjWizard
    .ShowValue pGetProyectosProperty()
    .ShowValue pGetHorasProperty()
    .ShowValue pGetPercepcionesProperty()
    .ShowValue pGetComprobante()
    .ShowValue pGetCentroCosto()
    .ShowValue pGetCondicionPago()
    .ShowValue pGetProOrigen()
    .ShowValue pGetProDestino()
    .ShowValue pGetLegajo()
    .ShowValue pGetDescrip()
  End With
  
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
      
      For Each Row In pGetHoras().Rows
      
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


