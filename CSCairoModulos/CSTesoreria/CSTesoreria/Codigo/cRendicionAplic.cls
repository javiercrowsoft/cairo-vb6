VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRendicionAplic"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cRendicionAplic
' 25-03-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cRendicionAplic"

Private Const c_ErrorSave = "Error al grabar la rendición"

'////////////////////////////////////////////////////////////////////////////////////
'
'   FacturaS
'
'////////////////////////////////////////////////////////////////////////////////////

'////////////////////////////////////////////////////////////////////////////////////

Private Const K_APLIC_PEDIDO = 9
Private Const K_APLIC_FACTURA = 10

Private Const c_AplicPedido = "AplicPedido"
Private Const c_AplicFactura = "AplicFactura"

Private Const KIV_FVD_ID                  As Integer = 1
Private Const KIV_FVP_ID                  As Integer = 2
Private Const KIV_FECHA                   As Integer = 3
Private Const KIV_APLICADO                As Integer = 4
Private Const KIV_APLICADO2               As Integer = 5
Private Const KIV_PENDIENTE               As Integer = 6

Private Const KIC_RvFv_ID               As Integer = 1
Private Const KIC_FVD_ID                  As Integer = 2
Private Const KIC_FVP_ID                  As Integer = 3
Private Const KIC_Fv_ID                   As Integer = 4
Private Const KIC_DOC                     As Integer = 5
Private Const KIC_FECHA                   As Integer = 6
Private Const KIC_COTIZACION              As Integer = 7
Private Const KIC_PENDIENTE               As Integer = 8
Private Const KIC_APLICADO                As Integer = 11
Private Const KIC_APLICADO2               As Integer = 12
Private Const KIC_NRODOC                  As Integer = 15
Private Const KIC_IDX1                    As Integer = 16
Private Const KIC_IDX2                    As Integer = 17
Private Const KIC_FVNC_ID                 As Integer = 18

' estructuras
Private Type T_Aplic
  rvfv_id                 As Long
  fvi_id                  As Long
  rvi_id                  As Long
  Aplicado                As Double
End Type

' variables privadas
Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric
Private m_GeneralConfig     As cGeneralConfig
Private m_RvId              As Long
Private m_RvNumero          As String
Private m_Cliente           As String
Private m_Total             As Double

Private m_LastRow           As Long

' Edit Apply
'
Private m_ObjectClient      As cRendicion
Private m_emp_id            As Long
Private m_emp_nombre        As String

' eventos
' propiedades publicas

' Edit Apply
'
Public Property Set ObjectClient(ByVal rhs As cRendicion)
  Set m_ObjectClient = rhs
End Property

Public Property Get id() As Long
  id = m_RvId
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Show(ByVal RvId As Long, ByVal Total As Double, _
                     ByVal RvNumero As String, _
                     ByVal Cliente As String) As Boolean
  
  If m_ObjAbm Is Nothing Then
    Set m_ObjAbm = New cABMGeneric
  End If
  
  If m_RvId <> RvId Then
    m_RvId = RvId
    m_RvNumero = RvNumero
    m_Cliente = Cliente
    m_Total = Total
    
    ' Edit Apply
    '
    If Not gDB.GetData(csTRendicion, _
                       cscRendId, _
                       m_RvId, _
                       cscEmpId, _
                       m_emp_id) Then Exit Function
    
    If Not gDB.GetData(csTEmpresa, _
                       cscEmpId, _
                       m_emp_id, _
                       cscEmpNombre, _
                       m_emp_nombre) Then Exit Function
    
    pEdit
  Else
    m_ObjAbm.ObjForm.ZOrder
  End If
  
  Show = True
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
End Function

Private Function cIABMClient_Save() As Boolean
  cIABMClient_Save = pSave
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  cIABMClient_Terminate = True
  m_RvId = csNO_ID
  Set m_ObjAbm = Nothing

  ' Edit Apply
  '
  Set m_ObjectClient = Nothing
End Function

Private Property Get cIABMClient_Title() As String
  On Error Resume Next
  cIABMClient_Title = "Aplicacion Remito de venta"
  m_ObjAbm.Title2 = m_RvNumero & " - " & m_Cliente
End Property

Private Function cIABMClient_Validate() As Boolean
  cIABMClient_Validate = True
End Function

' Implementacion de cIABMClientGrid
Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  cIABMClientGrid_IsEmptyRow = False
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  On Error GoTo ControlError
  Select Case Key
    Case K_APLIC_PEDIDO
      'cIABMClientGrid_ColumnAfterUpdate = pColAUpdateFactura(pGetItemsFacturaProperty(), lRow, lCol)
    Case K_APLIC_FACTURA
      'cIABMClientGrid_ColumnAfterUpdate = pColAUpdateFactura(pGetItemsFacturaProperty(), lRow, lCol)
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
    Case K_APLIC_PEDIDO
      'cIABMClientGrid_ColumnBeforeEdit = pColBEditFactura(pGetItemsFacturaProperty(), lRow, lCol, iKeyAscii)
    Case K_APLIC_FACTURA
      'cIABMClientGrid_ColumnBeforeEdit = pColBEditFactura(pGetItemsFacturaProperty(), lRow, lCol, iKeyAscii)
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

'
'  TODO
'

'  On Error GoTo ControlError
'
'  Select Case Key
'
'    Case K_APLICACIONES
'
'      With pGetItems().Rows
'        ShowDocAux pCell(.Item(lRow), KI_FV_ID).Id, _
'                   "CSVenta2.cFacturaVenta", _
'                   "CSABMInterface2.cABMGeneric"
'      End With
'
'  End Select
'
'  Exit Sub
'ControlError:
'  MngError Err, "cIABMClientGrid_DblClick", C_Module, vbnullstring
End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean

End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)
  
End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  cIABMClientGrid_ValidateRow = True
End Function

'///////////////////////////////////////////////////////////////////////////////////
Private Sub pEdit()
  On Error GoTo ControlError
  
  If Not LoadCollection() Then Exit Sub
  
  m_Editing = True
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", C_Module, vbNullString
End Sub

Private Function LoadCollection() As Boolean
  Dim c       As cIABMProperty
  Dim iTab    As cIABMTabItem
  Dim oGrd As cABMGrid

  m_LastRow = 0
  m_ObjAbm.Properties.Clear
  m_ObjAbm.Tabs.Clear
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = 0
  iTab.Name = "Pedido"
  
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = 1
  iTab.Name = "Factura"
  
 
  ' Factura
  Set c = m_ObjAbm.Properties.Add(Nothing, c_AplicPedido)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  If Not pLoadAplicPedido(c) Then Exit Function
  c.Key = K_APLIC_PEDIDO
  c.Name = "Pedido"
  c.LeftLabel = -5
  c.Width = 9400
  c.Left = 250
  c.GridEdit = True
  c.GridAdd = False
  c.GridRemove = False
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_AplicFactura)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  If Not pLoadAplicFactura(c) Then Exit Function
  c.Key = K_APLIC_FACTURA
  c.Name = "Remito"
  c.LeftLabel = -5
  c.Width = 9400
  c.Left = 250
  c.TopFromProperty = c_AplicPedido
  c.GridEdit = True
  c.GridAdd = False
  c.GridRemove = False
  c.TabIndex = 1
  
  Dim AbmObj  As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 7800
  
  ' Edit Apply
  '
  AbmObj.MinWidth = 10050
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

'/////////////////////////////////////////////////////////////////////////////////////
'
'         Carga
'
'/////////////////////////////////////////////////////////////////////////////////////
Private Function pLoadAplicPedido(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim Grid    As cIABMGrid
  Dim Cotizacion  As Double
  
  sqlstmt = "sp_DocRendicionGetAplic " & EmpId & "," & m_RvId & ",1"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadAplicPedido", C_Module) Then Exit Function
  
  Propiedad.Grid.Columns.Clear
  Propiedad.Grid.Rows.Clear
  
  Set Grid = Propiedad.Grid
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing)
    
    rs.MoveNext
  Wend
  
  pLoadAplicPedido = True
End Function

Private Function pLoadAplicFactura(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim Grid    As cIABMGrid
  Dim Cotizacion  As Double
  
  sqlstmt = "sp_DocRendicionGetAplic " & EmpId & "," & m_RvId & ",2"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadAplicFactura", C_Module) Then Exit Function
  
  Propiedad.Grid.Columns.Clear
  Propiedad.Grid.Rows.Clear
  
  Set Grid = Propiedad.Grid
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing)
    
    rs.MoveNext
  Wend
  
  pLoadAplicFactura = True
End Function

Private Function pSetGridAplicFactura(ByRef Propiedad As cIABMProperty) As Boolean
  Dim Grid          As cIABMGrid
  
  Propiedad.Grid.Columns.Clear
  Propiedad.Grid.Rows.Clear
  
  Set Grid = Propiedad.Grid
  
  With Grid.Columns
    With .Add(Nothing)
      .Visible = False
      .Key = KIC_IDX1
    End With
  
    With .Add(Nothing)
      .Visible = False
      .Key = KIC_IDX2
    End With
    
    With .Add(Nothing)
      .Visible = False
      .Key = KIC_RvFv_ID
    End With
    
    With .Add(Nothing)
      .Visible = False
      .Key = KIC_FVNC_ID
    End With
    
    With .Add(Nothing)
      .Visible = False
      .Key = KIC_Fv_ID
    End With
    
    With .Add(Nothing)
      .Visible = False
      .Key = KIC_Fv_ID
    End With
    
    With .Add(Nothing)
      .Visible = False
      .Key = KIC_FVD_ID
    End With
    
    With .Add(Nothing)
      .Visible = False
      .Key = KIC_FVP_ID
    End With
    
    With .Add(Nothing)
      .Name = "Documento"
      .PropertyType = cspText
      .Width = 2925
      .Key = KIC_DOC
    End With
    
    With .Add(Nothing)
      .Name = "Comprobante"
      .PropertyType = cspText
      .Width = 1575
      .Key = KIC_NRODOC
    End With
    
    With .Add(Nothing)
      .Name = "Fecha"
      .PropertyType = cspDate
      .Width = 1395
      .Key = KIC_FECHA
    End With
    
    With .Add(Nothing)
      .Name = "Pendiente"
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 1245
      .Key = KIC_PENDIENTE
    End With
    
    With .Add(Nothing)
      .Name = "Aplicado"
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 1245
      .Key = KIC_APLICADO
    End With
    
    With .Add(Nothing)
      .Name = "Cotiz."
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Format = m_GeneralConfig.FormatDecCotizacion
      .Width = 920
      .Key = KIC_COTIZACION
    End With
    
    With .Add(Nothing)
      .Visible = False
      .Key = KIC_APLICADO2
    End With
  End With

  pSetGridAplicFactura = True
End Function


' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_ObjAbm = Nothing
  Set m_GeneralConfig = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

'/////////////////////////////////////////////////////////////////////////////////////
'
'         Facturas
'
'/////////////////////////////////////////////////////////////////////////////////////

Private Function pSave() As Boolean
    
  ' Edit Apply
  '
  If m_emp_id <> EmpId Then
    MsgApplyDisabled m_emp_nombre
    Exit Function
  End If
    
  Dim RvTMPId As Long
  
  ' Pedidos
  If Not pSavePedido(RvTMPId) Then Exit Function
  
  ' Aplico llamando al sp
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocRendicionSaveAplic " & RvTMPId
  If Not gDB.OpenRs(sqlstmt, rs, , , , "pSave", C_Module, c_ErrorSave) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim id As Long
  If Not GetDocIDFromRecordset(rs, id) Then Exit Function
  
  If id = csNO_ID Then Exit Function
  
  pSave = True
    
  ' Edit Apply
  '
  pRefreshClient
End Function

' Edit Apply
'
Private Sub pRefreshClient()
  On Error Resume Next
  If m_ObjectClient Is Nothing Then Exit Sub
  m_ObjectClient.Refresh
End Sub

Private Function pSavePedido(ByVal RvTMPId As Long) As Boolean

End Function
'////////////////////////////////////////////////////////////////////////////////////
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
