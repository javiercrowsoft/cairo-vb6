VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cLiquidacionAux"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
'--------------------------------------------------------------------------------
' cLiquidacionAux
' 12-10-2008

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cLiquidacionAux"

Private Const c_cancel = "cancel"
Private Const c_Progress = "prg"
Private Const c_LbVan = "van"
Private Const c_LbSon = "son"
Private Const c_LbEmpleado = "empleado"

Private Const K_LABEL = 6
Private Const K_PROGRESS = 7
Private Const K_CANCEL = 8

' estructuras
' variables privadas
Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric

Private m_liq_id            As Long
Private m_last_liqf_id      As Long
Private m_GlobalCode        As String
Private m_liqf_nombre       As String

Private m_liqcTMP_id        As Long

Private m_bCancel           As Boolean

Private m_vSelectd()        As Long

Private m_ObjScript As MSScriptControl.ScriptControl ' Objeto para evaluar scripting
Private m_ObjLiq    As cLiquidacionClient


' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Edit(ByVal LiqId As Long, ByRef vSelected() As Long) As Boolean
                     
  On Error GoTo ControlError
    
  If UBound(vSelected) > 0 Then
               
    If Not Ask(LNGGetText(4845, vbNullString), vbYes) Then
               'Confirma que solo desea liquidar a los empleados seleccionados
      Exit Function
    End If
  End If
    
  m_vSelectd = vSelected
    
  ' Lo primero es definir la liquidacion
  '
  m_liq_id = LiqId
  
  Dim AbmObj As cABMGeneric
  
  Set m_ObjAbm = New cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.OkCancelDialog = True
  AbmObj.bDontAskForSave = True
  
  m_ObjAbm.InModalWindow = True
  
  LoadCollection

  Edit = AbmObj.OkCancelDialogRslt
  
  GoTo ExitProc
ControlError:
  MngError Err, "Edit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function


Private Function cIABMClient_Copy() As Boolean
End Function

Private Function cIABMClient_EditNew() As Boolean
End Function

Private Property Get cIABMClient_Aplication() As String
  cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
  cIABMClient_CanAddDocDigital = False
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
  cIABMClient_CanCopy = False
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = False
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
  cIABMClient_ShowDocDigital = False
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean
End Function

Private Sub cIABMClient_Load()
End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  Select Case Key
      
    Case K_CANCEL
      If Ask(LNGGetText(2973, vbNullString), vbNo) Then
              'Confirma que desea cancelar
        m_bCancel = True
      End If
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  On Error GoTo ControlError
    
  Dim mouseex As cMouse
  Set mouseex = New cMouse
  
  mouseex.MouseSet vbArrowHourglass
  
  m_bCancel = False
  
  Dim iPropCancel As cIABMProperty
  Set iPropCancel = m_ObjAbm.Properties.Item(c_cancel)
  iPropCancel.Enabled = True
  m_ObjAbm.ShowValue iPropCancel
  
  Dim iProg    As cIABMProperty
  Dim iPropSon As cIABMProperty
  Dim iPropVan As cIABMProperty
  Dim iPropEmp As cIABMProperty
  
  Set iProg = m_ObjAbm.Properties.Item(c_Progress)
  Set iPropSon = m_ObjAbm.Properties.Item(c_LbSon)
  Set iPropVan = m_ObjAbm.Properties.Item(c_LbVan)
  Set iPropEmp = m_ObjAbm.Properties.Item(c_LbEmpleado)
  
  Dim i As Long
  Dim rs As ADODB.Recordset
  Dim sqlstmt As String
  
  sqlstmt = "sp_LiquidacionGetItemsForExec " & m_liq_id
  If Not gDB.OpenRs(sqlstmt, rs) Then GoTo ExitProc
    
  If Not rs.EOF Then
    
    rs.MoveLast
    rs.MoveFirst
    
    iPropSon.Value = rs.RecordCount
    m_ObjAbm.ShowValue iPropSon
  
  End If
    
  If Not pGetLiqcTMPId() Then GoTo ExitProc
    
  i = 0
  While Not rs.EOF
        
    i = i + 1

    iProg.Value = DivideByCero(i, rs.RecordCount) * 100
    m_ObjAbm.ShowValue iProg
    
    iPropVan.Value = i
    m_ObjAbm.ShowValue iPropVan
    
    iPropEmp.Value = gDB.ValField(rs.fields, cscEmNombre)
    m_ObjAbm.ShowValue iPropEmp
    
    If Not pProcess(rs) Then GoTo ExitProc
    
    DoEvents
        
    If m_bCancel Then GoTo ExitProc
    
    rs.MoveNext
    
  Wend
  
  sqlstmt = "sp_LiquidacionItemCodigoSave " & m_liqcTMP_id & "," & m_liq_id
  If Not gDB.Execute(sqlstmt) Then GoTo ExitProc
  
  MsgInfo LNGGetText(4628, vbNullString) ' El proceso de Liquidacion de Haberes termino con éxito
  
  cIABMClient_Save = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_Save", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next

  iPropCancel.Enabled = False
  m_ObjAbm.ShowValue iPropCancel

End Function

Private Function pGetLiqcTMPId() As Boolean
  If Not gDB.GetNewId(csTLiquidacionItemCodigoTMP, _
                      cscLiqcTMPId, _
                      m_liqcTMP_id) Then Exit Function
  pGetLiqcTMPId = True
End Function

Private Function pProcess(ByRef rsLiqItem As ADODB.Recordset) As Boolean
  
  Dim Code          As String
  Dim liqfi_codigo  As String
  Dim sqlstmt       As String
  Dim rs            As ADODB.Recordset
  Dim em_id         As Long
  Dim liqi_id       As Long
  
  If UBound(m_vSelectd) Then
  
    Dim k As Long
    Dim bFound As Boolean
    
    liqi_id = gDB.ValField(rsLiqItem.fields, cscLiqiId)
    
    For k = 1 To UBound(m_vSelectd)
      If liqi_id = m_vSelectd(k) Then
      
        bFound = True
        Exit For
      End If
    Next
    
    If Not bFound Then
      pProcess = True
      Exit Function
    End If
  End If
  
  em_id = gDB.ValField(rsLiqItem.fields, cscEmId)
  
  sqlstmt = "sp_LiquidacionGetEmpleadoFormula " _
                 & m_liq_id & "," _
                 & em_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then
    MsgWarning LNGGetText(4634, vbNullString, _
                          gDB.ValField(rsLiqItem.fields, cscEmNombre)) _
               'El empleado #1# no tiene asociada ninguna formula de liquidación
    Exit Function
  End If
  
  If m_last_liqf_id <> gDB.ValField(rs.fields, cscLiqfId) Then
    
    m_ObjScript.Reset
    
    m_GlobalCode = rs.fields.Item(cscLiqfFormula).Value
    If LenB(m_GlobalCode) Then m_ObjScript.AddCode m_GlobalCode
    
    m_last_liqf_id = rs.fields.Item(cscLiqfId).Value
    m_liqf_nombre = rs.fields.Item(cscLiqfNombre).Value
    
  End If
  
  sqlstmt = "sp_LiquidacionGetEmpleadoGetFormulaItem " _
                 & m_liq_id & "," _
                 & em_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then
    MsgWarning LNGGetText(4635, vbNullString) 'La formula de liquidación no devolvio codigos a procesar
    Exit Function
  End If
  
  m_ObjLiq.Init m_liq_id, rsLiqItem, m_liqcTMP_id
  m_ObjLiq.liqf_id = m_last_liqf_id
  
  While Not rs.EOF

    m_ObjLiq.liqfi_id = rs.fields.Item(cscLiqfiId).Value

    liqfi_codigo = rs.fields.Item(cscLiqfiCodigo).Value
    Code = rs.fields.Item(cscLiqfiFormula).Value
      
    If Not pExecuteStatement(Code, liqfi_codigo) Then
      Exit Function
    End If

    rs.MoveNext

  Wend
  
  pProcess = True
  
End Function

Private Function pExecuteStatement(ByVal Code As String, _
                                   ByVal liqfi_codigo As String) As Boolean
  On Error GoTo ControlError
  
  m_ObjScript.ExecuteStatement Code
  
  pExecuteStatement = True
  
  GoTo ExitProc
ControlError:
  
  ' Si el codigo dispara un error
  ' en la funcion rtn del objeto cLiquidacionClient
  ' el mensaje del error ya fue presentado al usuario
  ' por la misma funcion.
  '
  ' El error se dispara solo para interumpir el proceso
  '
  If Err.Number <> c_ErrorInRtn Then
  
    Dim details As String
    
    details = LNGGetText(4637, vbNullString, _
                         Err.Description, _
                         m_liqf_nombre, _
                         liqfi_codigo, _
                         m_GlobalCode, _
                         Code)
    
    MsgWarningEx LNGGetText(4636, vbNullString, liqfi_codigo), _
                 LNGGetText(4638, vbNullString), _
                 details
  
  End If
  
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(3197, vbNullString) 'Importar Saldos Iniciales
End Property

Private Function cIABMClient_Validate() As Boolean
  cIABMClient_Validate = True
End Function

Private Function LoadCollection() As Boolean

  Const c_top_buttons = 2800

  m_ObjAbm.Properties.Clear

  With m_ObjAbm.Properties.Add(Nothing, "Label")
    .PropertyType = cspLabel
    .Width = 5000
    .Height = 1500
    .FontBold = True
    .Value = LNGGetText(4626, vbNullString)
    
             ' Presione aceptar para iniciar el proceso
             ' de la liquidacion de haberes
               
    .Key = K_LABEL
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_cancel)
    .PropertyType = cspButton
    .Name = LNGGetText(4627, vbNullString) 'Cancelar
    .LeftLabel = -1
    .Key = K_CANCEL
    .Top = c_top_buttons
    .Enabled = False
    .Left = 4000
    .LeftNotChange = True
  End With
    
  With m_ObjAbm.Properties.Add(Nothing, c_Progress)
    .PropertyType = cspProgressBar
    .Name = LNGGetText(2984, vbNullString) 'Progreso
    .Width = 7000
    .Key = K_PROGRESS
    .TopToPrevious = 700
  End With
    
  With m_ObjAbm.Properties.Add(Nothing)
    .PropertyType = cspLabel
    .Value = LNGGetText(3318, vbNullString) 'Son
    .TopNotChange = True
    .FontBold = True
  End With
    
  With m_ObjAbm.Properties.Add(Nothing, c_LbSon)
    .PropertyType = cspLabel
    .LeftNotChange = True
    .Left = 3000
  End With
    
  With m_ObjAbm.Properties.Add(Nothing)
    .PropertyType = cspLabel
    .Value = LNGGetText(2043, vbNullString) 'Van
    .TopNotChange = True
    .FontBold = True
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_LbVan)
    .PropertyType = cspLabel
    .LeftNotChange = True
    .Left = 3000
  End With
    
  With m_ObjAbm.Properties.Add(Nothing)
    .PropertyType = cspLabel
    .Value = LNGGetText(4555, vbNullString) 'Empleado
    .TopNotChange = True
    .FontBold = True
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_LbEmpleado)
    .PropertyType = cspLabel
    .Width = 7000
    .LeftNotChange = True
    .Left = 3000
  End With
    
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.bDontAskForSave = True
  AbmObj.OkCancelDialog = True
  AbmObj.MinHeight = 10000
  AbmObj.NotLockWnd = True
  AbmObj.DontMoveGenericButton = True
  
  AbmObj.SaveCaption = LNGGetText(4629, vbNullString) ' Ejecutar Liquidacion
  AbmObj.CancelCaption = LNGGetText(2232, vbNullString) ' Cerrar
  
  AbmObj.SaveWidth = 2000
  
  AbmObj.SaveTop = c_top_buttons
  AbmObj.CancelTop = c_top_buttons
  
  AbmObj.SaveLeft = 1500
  AbmObj.CancelLeft = 7000
  
  m_ObjAbm.InModalWindow = True

  If Not m_ObjAbm.Show(Me) Then Exit Function
    
  LoadCollection = True
End Function

' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_ObjLiq = New cLiquidacionClient
  Set m_ObjScript = New MSScriptControl.ScriptControl
  
  With m_ObjScript
    .Language = "VBScript"
    .AllowUI = True
    .AddObject "oLiq", m_ObjLiq, True
  End With
        
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjScript = Nothing
  Set m_ObjLiq = Nothing
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

