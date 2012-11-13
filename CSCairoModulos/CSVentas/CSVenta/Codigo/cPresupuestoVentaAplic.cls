VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPresupuestoVentaAplic"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cPresupuestoVentaAplic
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
Private Const C_Module = "cPresupuestoVentaAplic"

'////////////////////////////////////////////////////////////////////////////////////
'
'   PRESTACIONES
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private Const cscNroDoc                          As String = "nrodoc"
  Private Const cscPendiente                       As String = "Pendiente"
  Private Const cscImporte                         As String = "Importe"
  Private Const cscVincId                          As String = "vinc_id"
  Private Const cscPrvdId                          As String = "prvd_id"
'////////////////////////////////////////////////////////////////////////////////////
'
'   PRESUPUESTO - SOLAPA
'
'////////////////////////////////////////////////////////////////////////////////////
  
  ' Prespuesto

  Private Const cscFecha            As String = "Fecha"
  Private Const cscAplicado         As String = "Aplicado"
  Private Const cscAplicRemito      As String = "AplicRemito"
  
  ' Grillas de Pedidos / Presupuestos
  Private Const KII_PRVI_ID                 As Integer = 1
  Private Const KII_PR_ID                   As Integer = 2
  Private Const KII_APLICADO                As Integer = 4
  Private Const KII_APLICADO2               As Integer = 5
  Private Const KII_PENDIENTE               As Integer = 6
  
  Private Const KIP_PRVPV_ID                As Integer = 1
  Private Const KIPD_PVI_ID                 As Integer = 2
  Private Const KIPD_PRVI_ID                As Integer = 3
  
  Private Const KIP_DOC                     As Integer = 7
  Private Const KIP_FECHA                   As Integer = 8
  Private Const KIP_PENDIENTE               As Integer = 9
  Private Const KIP_APLICADO                As Integer = 11
  Private Const KIP_APLICADO2               As Integer = 12
  Private Const KIP_NRODOC                  As Integer = 15
  Private Const KIP_IDX1                    As Integer = 16
  Private Const KIP_IDX2                    As Integer = 17

'////////////////////////////////////////////////////////////////////////////////////
'
'   PEDIDOS / DEVOLUCION - SOLAPA
'
'////////////////////////////////////////////////////////////////////////////////////
  
  ' Pedidos
  
  Private Const K_PEDIDO_DEV = 20
  Private Const K_APLIC_PEDIDO_DEV = 21
  Private Const c_PedidoDev = "PedidoDev"
  Private Const c_AplicPedidoDev = "AplicPedidoDev"

' estructuras

'////////////////////////////////////////////////////////////////////////////////////
'
'   PEDIDOS
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private Type T_ItAplic
    vinc_id                 As Long   ' lo uso para prvpv_id y prvdv_id
    prvi_id                 As Long   ' Ids de items al que este credito esta vinculado
    
    Aplicado                As Double
  End Type
  
  Private Type T_Aplic
                                    ' Vinculacion con
                                    
    pvi_id                  As Long ' Pedido
    prvi_id                 As Long ' Cancelacion de presupuesto
    
    PR_ID                   As Long
    
    Fecha                   As Date
    docNombre               As String
    NroDoc                  As String
    
    PendienteActual         As Double
    AplicadoActual          As Double
    
    Pendiente               As Double
    Aplicado                As Double
    
    vAplicaciones()         As T_ItAplic
  End Type

' pseudo-constantes
Private c_ErrorSave As String

' variables privadas

' generales

Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric
Private m_GeneralConfig     As cGeneralConfig
Private m_PrvId             As Long
Private m_IsDevolucion      As Boolean
Private m_PrvNumero         As String
Private m_Cliente           As String
Private m_CliId             As Long
Private m_DocId             As Long
Private m_SucId             As Long
Private m_Total             As Double

Private m_MonDefault        As Long

Private m_LastRowItem       As Long
Private m_LastRowPedidoDev  As Long

' Edit Apply
'
Private m_ObjectClient      As cPresupuestoVenta
Private m_emp_id            As Long
Private m_emp_nombre        As String

'////////////////////////////////////////////////////////////////////////////////////
'
'   REMITOS / REMITOS
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private m_vPedidoDevs()      As T_Aplic
  Private m_prvi_id            As Long

' eventos
' propiedades publicas

' Edit Apply
'
Public Property Set ObjectClient(ByVal rhs As cPresupuestoVenta)
  Set m_ObjectClient = rhs
End Property

Public Property Get Id() As Long
  Id = m_PrvId
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Show(ByVal PrvId As Long, ByVal Total As Double, _
                     ByVal PrvNumero As String, _
                     ByVal CliId As Long, ByVal Cliente As String, _
                     ByVal SucId As Long, ByVal DocId As Long, _
                     ByVal IsDevolucion As Boolean) As Boolean
  
  If m_ObjAbm Is Nothing Then
    Set m_ObjAbm = New cABMGeneric
  End If
  
  If m_PrvId <> PrvId Then
    m_IsDevolucion = IsDevolucion
    m_PrvId = PrvId
    m_PrvNumero = PrvNumero
    m_Cliente = Cliente
    m_CliId = CliId
    m_DocId = DocId
    m_SucId = SucId
    m_Total = Total
    
    ' Edit Apply
    '
    If Not gDB.GetData(csTPresupuestoVenta, _
                       cscPrvId, _
                       m_PrvId, _
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

' funciones friend
' funciones privadas

'////////////////////////////////////////////////////////////////////////////////////
'
'   cIABMClient_
'
'////////////////////////////////////////////////////////////////////////////////////

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
    Dim AbmObj As cABMGeneric

    Select Case MessageID
      
      Case MSG_GRID_ROW_CHANGE
        If Info Is Nothing Then Exit Function
        
        Dim Row      As cIABMGridRow
        Dim iProp    As cIABMProperty
        Dim Aplicado As Double
        
        Set iProp = Info
        
        Select Case iProp.Key
          
          Case K_PEDIDO_DEV
          
            Set AbmObj = m_ObjAbm
            
            ' Guardo la aplicacion para el item editado anteriormente
            '
            If m_LastRowPedidoDev <> 0 Then
              Aplicado = pItUpdateGrids(m_vPedidoDevs)
            End If
            
            ' Muestro las aplicaciones para este item
            '
            m_LastRowPedidoDev = iProp.SelectedIndex
            Set Row = iProp.Grid.Rows(m_LastRowPedidoDev)
            If Row Is Nothing Then Exit Function
            
            pItSetAplicItems m_ObjAbm.Properties(c_AplicPedidoDev), _
                             pCell(Row, KII_PRVI_ID).Id, _
                             pCell(Row, KII_PR_ID).Id, m_vPedidoDevs
            
            AbmObj.ShowValue m_ObjAbm.Properties(c_AplicPedidoDev), True
          
        End Select
    End Select
    
    cIABMClient_MessageEx = True
  End Function
  
  Private Sub cIABMClient_DiscardChanges()
    If Not pItLoadAplicItems() Then Exit Sub
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
    m_PrvId = csNO_ID
    Set m_ObjAbm = Nothing
    
    ' Edit Apply
    '
    Set m_ObjectClient = Nothing
  End Function
  
  Private Property Get cIABMClient_Title() As String
    On Error Resume Next
    cIABMClient_Title = "Aplicacion presupuesto de venta"
    m_ObjAbm.Title2 = m_PrvNumero & " - " & m_Cliente
  End Property
  
  Private Function cIABMClient_Validate() As Boolean
    cIABMClient_Validate = True
  End Function

'////////////////////////////////////////////////////////////////////////////////////
'
'   cIABMClientGrid_
'
'////////////////////////////////////////////////////////////////////////////////////

  Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
    cIABMClientGrid_IsEmptyRow = False
  End Function
  
  Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
    On Error GoTo ControlError
    Select Case Key
      Case K_APLIC_PEDIDO_DEV
        cIABMClientGrid_ColumnAfterUpdate = pItColAUpdate(pItGetItemsProperty(), lRow, lCol)
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
      Case K_APLIC_PEDIDO_DEV
        cIABMClientGrid_ColumnBeforeEdit = pItColBEdit(pItGetItemsProperty(), lRow, lCol, iKeyAscii)
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
    On Error GoTo ControlError
    
    Dim Id As Long
    
    Select Case Key

      Case K_APLIC_PEDIDO_DEV

        With pItGetItemsAplic().Rows
          
          Dim ObjEditName As String
                    
          Id = pCell(.Item(lRow), KIPD_PVI_ID).Id
          
          If Id <> csNO_ID Then
            If Not gDB.GetData("PedidoVentaItem", _
                               "pvi_id", _
                               Id, _
                               "pv_id", _
                               Id) Then Exit Sub
            
            ObjEditName = "CSPedidoVenta2.cPedidoVenta"
          
          Else
          
            Id = pCell(.Item(lRow), KIPD_PRVI_ID).Id
            
            If Id <> csNO_ID Then
              If Not gDB.GetData("PresupuestoVentaItem", _
                                 "prvi_id", _
                                 Id, _
                                 "prv_id", _
                                 Id) Then Exit Sub
              
              ObjEditName = "CSVenta2.cPresupuestoVenta"
            End If
          End If
            
          If Id <> csNO_ID Then
          
            ShowDocAux Id, _
                       ObjEditName, _
                       "CSABMInterface2.cABMGeneric"
          End If
          
        End With

    End Select
  
    Exit Sub
ControlError:
    MngError Err, "cIABMClientGrid_DblClick", C_Module, vbNullString
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

'////////////////////////////////////////////////////////////////////////////////////
'
'   GENERICAS
'
'////////////////////////////////////////////////////////////////////////////////////

  Private Sub pEdit()
    On Error GoTo ControlError
    
    If Not pItLoadAplicItems() Then Exit Sub
    If Not LoadCollection() Then Exit Sub
    
    m_Editing = True
    
    Exit Sub
ControlError:
    MngError Err, "pEdit", C_Module, vbNullString
  End Sub
  
  Private Function LoadCollection() As Boolean
    Dim c       As cIABMProperty
    Dim iTab    As cIABMTabItem
    Dim oGrd    As cABMGrid
  
    m_LastRowPedidoDev = 0
    
    m_ObjAbm.Properties.Clear
    m_ObjAbm.Tabs.Clear
    
    Set c = m_ObjAbm.Properties.Add(Nothing, c_PedidoDev)
    c.PropertyType = cspGrid
    c.LeftLabel = -1
    If Not pItLoadPedidoDev(c) Then Exit Function
    c.Key = K_PEDIDO_DEV
    c.Name = "Items"
    c.Width = 9400
    c.Left = 250
    c.Height = 2600
    c.GridEdit = False
    c.GridAdd = False
    c.GridRemove = False
    Set oGrd = c.Grid
    oGrd.RowSelect = True
    oGrd.DontSelectInGotFocus = True
  
    Set c = m_ObjAbm.Properties.Add(Nothing, c_AplicPedidoDev)
    c.PropertyType = cspGrid
    c.LeftLabel = -1
    If Not pItSetGridAplicPedidoDev(c) Then Exit Function
    c.Key = K_APLIC_PEDIDO_DEV
    c.Name = "Pedidos"
    c.Width = 9400
    c.Left = 250
    c.Top = 4200
    c.Height = 2000
    c.GridEdit = True
    c.GridAdd = False
    c.GridRemove = False
    Set oGrd = c.Grid
    oGrd.RowSelect = True
    oGrd.DontSelectInGotFocus = True
    
    Dim AbmObj  As cABMGeneric
    Set AbmObj = m_ObjAbm
    AbmObj.MinHeight = 7800
    
    ' Edit Apply
    '
    AbmObj.MinWidth = 10050
    
    If Not m_ObjAbm.Show(Me) Then Exit Function
    
    LoadCollection = True
  End Function

  Private Function pSave() As Boolean
    
    ' Edit Apply
    '
    If m_emp_id <> EmpId Then
      MsgApplyDisabled m_emp_nombre
      Exit Function
    End If
    
    Dim prvTMPId As Long
    
    pItUpdateGrids m_vPedidoDevs
    
    ' Temporal
    If Not pSaveDocVta(m_DocId, prvTMPId) Then Exit Function
    
    ' Facturas / Devoluciones
    If Not pItSavePedidoDev(prvTMPId, m_vPedidoDevs) Then Exit Function
    
    ' Aplico llamando al sp
    Dim sqlstmt As String
    Dim rs      As Recordset
    
    sqlstmt = "sp_DocPresupuestoVentaSaveAplic " & prvTMPId
    If Not gDB.OpenRs(sqlstmt, rs, , , , "pSave", C_Module, c_ErrorSave) Then Exit Function
    
    If rs.EOF Then Exit Function
    
    Dim Id As Long
    If Not GetDocIDFromRecordset(rs, Id) Then Exit Function
    
    If Id = csNO_ID Then Exit Function
    
    If Not pItLoadAplicItems() Then Exit Function
    
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

  '////////////////////////////////////////////////////////////////////////////////////
  ' PresupuestoVentaTemporal
  '////////////////////////////////////////////////////////////////////////////////////
  Private Function pSaveDocVta(ByVal DocId As Long, _
                               ByRef prvTMPId As Long) As Boolean
    Dim register     As cRegister
    
    Set register = New cRegister
    register.fieldId = cscPrvTMPId
    register.Table = csTPresupuestoVentaTMP
  
    register.Id = csNew
    register.Fields.Add2 cscPrvId, m_PrvId, csId
  
    register.Fields.Add2 cscPrvNumero, 0, csLong
    register.Fields.Add2 cscPrvNrodoc, vbNullString, csText
    
    register.Fields.Add2 cscCliId, 0, csLong
    register.Fields.Add2 cscSucId, 0, csLong
    register.Fields.Add2 cscDocId, DocId, csId
    register.Fields.Add2 cscCpgId, csECpgTipo.csECpgT_FechaDocumento, csId
    
    register.Fields.Add2 cscEstId, CSGeneralEx2.csEEstado.csEEst_Pendiente, csId
  
    register.Fields.HaveLastUpdate = True
    register.Fields.HaveWhoModify = True
  
    If Not register.BeginTrans(gDB) Then Exit Function
  
    If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
    If Not register.CommitTrans() Then Exit Function
  
    prvTMPId = register.Id
    pSaveDocVta = True
  End Function

'////////////////////////////////////////////////////////////////////////////////////
'
'   PRESUPUESTOS
'
'////////////////////////////////////////////////////////////////////////////////////

  Private Function pItLoadAplicItems() As Boolean
    
    If Not pItLoadAplicAplicados(m_vPedidoDevs) Then Exit Function
    If Not pItLoadAplicCreditos(m_vPedidoDevs) Then Exit Function
    
    pItLoadAplicItems = True
  End Function

'////////////////////////////////////////////////////////////////////////////////////
'
'   GENERICAS
'
'////////////////////////////////////////////////////////////////////////////////////

  Private Function pItLoadItemsAux(ByRef iProp As cIABMProperty) As Boolean
    Dim sqlstmt     As String
    Dim rs          As ADODB.Recordset
    Dim Grid        As cIABMGrid
    Dim Row         As cABMGridRow
    Dim Value       As Double
  
    sqlstmt = "sp_DocPresupuestoVentaGetAplic " & EmpId & "," & m_PrvId & ",1"
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pItLoadItems", C_Module) Then Exit Function
  
    iProp.Grid.Columns.Clear
    iProp.Grid.Rows.Clear
  
    Set Grid = iProp.Grid
  
    With Grid.Columns
      With .Add(Nothing)
        .Visible = False
        .Key = KII_PRVI_ID
      End With
  
      With .Add(Nothing)
        .Name = "Producto"
        .PropertyType = cspText
        .Width = 2500
        .Key = KII_PR_ID
      End With
    
      With .Add(Nothing)
        .Name = "Pendiente"
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1245
        .Key = KII_PENDIENTE
      End With
    
      With .Add(Nothing)
        .Name = "Aplicado"
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1245
        .Key = KII_APLICADO
      End With
    
      With .Add(Nothing)
        .Visible = False
        .Key = KII_APLICADO2
      End With
    End With
    
    Dim f  As cIABMGridRow
    Dim fv As cIABMGridCellValue
  
    While Not rs.EOF
  
      Set f = iProp.Grid.Rows.Add(Nothing)
  
      Set fv = f.Add(Nothing)
      fv.Id = gDB.ValField(rs.Fields, cscPrviId)
      fv.Key = KII_PRVI_ID
  
      Set fv = f.Add(Nothing)
      fv.Id = gDB.ValField(rs.Fields, cscPrId)
      fv.Value = gDB.ValField(rs.Fields, cscPrNombreVenta)
      fv.Key = KII_PR_ID
  
      Set fv = f.Add(Nothing)
      fv.Value = gDB.ValField(rs.Fields, cscPrviPendiente)
      fv.Key = KII_PENDIENTE
      Value = gDB.ValField(rs.Fields, cscAplicRemito)
      
      Set fv = f.Add(Nothing)
      fv.Value = Value
      fv.Key = KII_APLICADO
      
      If Value <> 0 Then
        Set Row = f
        Row.BackColor = &HFFCC99
      End If
      
      Set fv = f.Add(Nothing)
      fv.Value = Value
      fv.Key = KII_APLICADO2
      
      rs.MoveNext
    Wend
  
    pItLoadItemsAux = True
  End Function

  Private Function pItSetGridAplicAux(ByRef iProp As cIABMProperty) As Boolean
    Dim Grid          As cIABMGrid
    
    iProp.Grid.Columns.Clear
    iProp.Grid.Rows.Clear
    
    Set Grid = iProp.Grid
    
    With Grid.Columns
      With .Add(Nothing)
        .Visible = False
        .Key = KIP_IDX1
      End With
    
      With .Add(Nothing)
        .Visible = False
        .Key = KIP_IDX2
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIP_PRVPV_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIPD_PRVI_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIPD_PVI_ID
      End With
      
      With .Add(Nothing)
        .Name = "Documento"
        .PropertyType = cspText
        .Width = 2925
        .Key = KIP_DOC
      End With
      
      With .Add(Nothing)
        .Name = "Comprobante"
        .PropertyType = cspText
        .Width = 1575
        .Key = KIP_NRODOC
      End With
      
      With .Add(Nothing)
        .Name = "Fecha"
        .PropertyType = cspDate
        .Width = 1395
        .Key = KIP_FECHA
      End With
      
      With .Add(Nothing)
        .Name = "Pendiente"
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1245
        .Key = KIP_PENDIENTE
      End With
      
      With .Add(Nothing)
        .Name = "Aplicado"
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1245
        .Key = KIP_APLICADO
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIP_APLICADO2
      End With
    End With
    
    pItSetGridAplicAux = True
  End Function
  
  Private Function pItLoadAplicAplicados(ByRef vAplic() As T_Aplic) As Boolean
    Dim sqlstmt       As String
    Dim rs            As ADODB.Recordset
    Dim i             As Long
    Dim Idx           As Long
    
    sqlstmt = "sp_DocPresupuestoVentaGetAplic " & EmpId & "," & m_PrvId & ",2"
    
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadAplicAplicados", C_Module) Then Exit Function
    
    ReDim vAplic(0)
    ReDim vAplic(0).vAplicaciones(0)
    
    If Not rs.EOF Then
    
      rs.MoveLast
      rs.MoveFirst
    
      While Not rs.EOF
            
        i = pItAddToCreditos(gDB.ValField(rs.Fields, cscPviId), _
                             gDB.ValField(rs.Fields, cscPrviId), _
                             Idx, vAplic)
        
        With vAplic(i)
        
          ' Documento
          '
          .docNombre = gDB.ValField(rs.Fields, cscDocNombre)
          .NroDoc = gDB.ValField(rs.Fields, cscNroDoc)
          .Fecha = gDB.ValField(rs.Fields, cscFecha)
          
          ' Pendiente
          '
          .Pendiente = gDB.ValField(rs.Fields, cscPendiente)
          .PendienteActual = .Pendiente
          
          ' Presupuesto
          '
          .prvi_id = gDB.ValField(rs.Fields, cscPrvdId)
          .pvi_id = gDB.ValField(rs.Fields, cscPviId)
          
          
          .PR_ID = gDB.ValField(rs.Fields, cscPrId)
          
          ' Aplicaciones
          With .vAplicaciones(Idx)
          
            .vinc_id = gDB.ValField(rs.Fields, cscVincId)
              
            .prvi_id = gDB.ValField(rs.Fields, cscPrviId)
            
            .Aplicado = gDB.ValField(rs.Fields, cscAplicado)
          End With
          
          ' Aplicacion total sobre este credito
          .Aplicado = .Aplicado + .vAplicaciones(Idx).Aplicado
          .AplicadoActual = .Aplicado
        End With
        
        rs.MoveNext
      Wend
    End If
    
    pItLoadAplicAplicados = True
  End Function
  
  Private Function pItLoadAplicCreditos(ByRef vAplic() As T_Aplic) As Boolean
    Dim sqlstmt       As String
    Dim rs            As ADODB.Recordset
    Dim i             As Long
    
    sqlstmt = "sp_DocPresupuestoVentaGetAplic " & EmpId & "," & m_PrvId & ",3"
    
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadAplicCreditos", C_Module) Then Exit Function
    
    If Not rs.EOF Then
      
      rs.MoveLast
      rs.MoveFirst
    
      i = UBound(vAplic)
      ReDim Preserve vAplic(i + rs.RecordCount)
      
      While Not rs.EOF
            
        i = i + 1
        With vAplic(i)
          .PR_ID = gDB.ValField(rs.Fields, cscPrId)
          
          .pvi_id = gDB.ValField(rs.Fields, cscPviId)
          .prvi_id = gDB.ValField(rs.Fields, cscPrvdId)
  
          .docNombre = gDB.ValField(rs.Fields, cscDocNombre)
          .NroDoc = gDB.ValField(rs.Fields, cscNroDoc)
          .Fecha = gDB.ValField(rs.Fields, cscFecha)
            
          .Pendiente = gDB.ValField(rs.Fields, cscPendiente)
          .PendienteActual = .Pendiente
          
          ReDim .vAplicaciones(0)
        End With
        
        rs.MoveNext
      Wend
    End If
    
    pItLoadAplicCreditos = True
  End Function
  
  Private Function pItAddToCreditos(ByVal PviId As Long, _
                                    ByVal PrviId As Long, _
                                    ByRef Idx As Long, _
                                    ByRef vAplic() As T_Aplic) As Long
    Dim i As Long
    
    For i = 1 To UBound(vAplic)
      With vAplic(i)
        If (.pvi_id = PviId And PviId <> csNO_ID) Or _
           (.prvi_id = PrviId And PrviId <> csNO_ID) Then
           
           ReDim Preserve .vAplicaciones(UBound(.vAplicaciones) + 1)
           
           Idx = UBound(.vAplicaciones)
           pItAddToCreditos = i
           Exit Function
        End If
      End With
    Next
    
    ReDim Preserve vAplic(UBound(vAplic) + 1)
    ReDim vAplic(UBound(vAplic)).vAplicaciones(1)
    pItAddToCreditos = UBound(vAplic)
    Idx = 1
  End Function
  
  Private Function pItUpdateGrids(ByRef vAplic() As T_Aplic) As Double
    Dim iProp         As cIABMProperty
    Dim iPropAplic    As cIABMProperty
    Dim Row           As cIABMGridRow
    Dim LastRow       As Long
    
    Set iProp = m_ObjAbm.Properties(c_PedidoDev)
    Set iPropAplic = m_ObjAbm.Properties(c_AplicPedidoDev)
    LastRow = m_LastRowPedidoDev
    
    If LastRow <> 0 Then
      
      Set Row = iProp.Grid.Rows(LastRow)
      pItUpdateGrids = pItUpdateAplicItems(iPropAplic, _
                                           pCell(Row, KII_PRVI_ID).Id, _
                                           vAplic)
    End If
  End Function
  
  Private Function pItSetAplicItems(ByRef iProp As cIABMProperty, _
                                    ByVal prvi_id As Long, _
                                    ByVal PR_ID As Long, _
                                    ByRef vAplic() As T_Aplic) As Boolean
    Dim Cotizacion    As Double
    Dim i             As Long
    Dim j             As Long
    
    iProp.Grid.Rows.Clear
    
    m_prvi_id = prvi_id
    
    For i = 1 To UBound(vAplic)
    
      If vAplic(i).PR_ID = PR_ID Then
    
        If UBound(vAplic(i).vAplicaciones) > 0 Then
          pItSetAplicItemsAux1 i, iProp, prvi_id, vAplic
        Else
          pItSetAplicItemsAux2 i, iProp, vAplic
        End If
      End If
      
    Next
    
    ' Ahora los creditos que tienen aplicaciones
    ' pero no estan con este item y tienen pendiente
    Dim Id      As Long
    Dim bAplic  As Boolean
    Dim Row     As cIABMGridRow
    
    For i = 1 To UBound(vAplic)
    
      bAplic = False
      
      If vAplic(i).PR_ID = PR_ID Then
      
        For Each Row In iProp.Grid.Rows
        
          Id = pCell(Row, KIPD_PVI_ID).Id
          If Id = vAplic(i).pvi_id And Id <> csNO_ID Then
            bAplic = True
            Exit For
          End If
        
          Id = pCell(Row, KIPD_PRVI_ID).Id
          If Id = vAplic(i).prvi_id And Id <> csNO_ID Then
            bAplic = True
            Exit For
          End If
        
          Id = m_prvi_id
          For j = 1 To UBound(vAplic(i).vAplicaciones)
            If Id = vAplic(i).vAplicaciones(j).prvi_id And Id <> csNO_ID Then
              bAplic = True
              Exit For
            End If
          Next
        
          If bAplic Then Exit For
        Next
    
        If Not bAplic Then pItSetAplicItemsAux2 i, iProp, vAplic
      End If
    Next
    
    pItSetAplicItems = True
  End Function
  
  Private Function pItUpdateAplicItems(ByRef iProp As cIABMProperty, _
                                       ByVal prvi_id As Long, _
                                       ByRef vAplic() As T_Aplic) As Double
    Dim Cotizacion    As Double
    Dim i             As Long
    Dim j             As Long
    Dim Row           As cIABMGridRow
    Dim Aplicado      As Double
    Dim AplicadoTotal As Double
    
    For Each Row In pItGetItemsAplic().Rows
    
      If Val(pCell(Row, KIP_APLICADO).Value) > 0 Or pCell(Row, KIP_IDX2).Id <> 0 Then
    
        i = pCell(Row, KIP_IDX1).Id
        j = pCell(Row, KIP_IDX2).Id
        
        Aplicado = Val(pCell(Row, KIP_APLICADO).Value)
        AplicadoTotal = AplicadoTotal + Aplicado
        
        With vAplic(i)
          .Aplicado = pItAddToAplic(.vAplicaciones, Aplicado, j)
          .Pendiente = .PendienteActual - (.Aplicado - .AplicadoActual)
        End With
      End If
    Next
    
    pItUpdateAplicItems = AplicadoTotal
  End Function
  
  Private Sub pItSetAplicItemsAux1(ByVal Idx As Long, ByRef iProp As cIABMProperty, ByVal prvi_id As Long, _
                                   ByRef vAplic() As T_Aplic)
    Dim f               As cIABMGridRow
    Dim fv              As cIABMGridCellValue
    Dim i               As Long
    Dim iPropItem       As cIABMProperty
    Dim Row             As cABMGridRow
    
    For i = 1 To UBound(vAplic(Idx).vAplicaciones)
    
      With vAplic(Idx).vAplicaciones(i)
    
        If .prvi_id = prvi_id And prvi_id <> csNO_ID Then
        
          Set f = iProp.Grid.Rows.Add(Nothing)
          
          Set fv = f.Add(Nothing)
          fv.Id = Idx
          fv.Key = KIP_IDX1
          
          Set fv = f.Add(Nothing)
          fv.Id = i
          fv.Key = KIP_IDX2
          
          Set fv = f.Add(Nothing)
          fv.Id = .vinc_id
          fv.Key = KIP_PRVPV_ID
          
          Set fv = f.Add(Nothing)
          fv.Id = vAplic(Idx).prvi_id
          fv.Key = KIPD_PRVI_ID
        
          Set fv = f.Add(Nothing)
          fv.Id = vAplic(Idx).pvi_id
          fv.Key = KIPD_PVI_ID
          
          Set fv = f.Add(Nothing)
          fv.Value = vAplic(Idx).docNombre
          fv.Key = KIP_DOC
          
          Set fv = f.Add(Nothing)
          fv.Value = vAplic(Idx).NroDoc
          fv.Key = KIP_NRODOC
          
          Set fv = f.Add(Nothing)
          If vAplic(Idx).Fecha = csNoDate Then
            fv.Value = vbNullString
          Else
            fv.Value = vAplic(Idx).Fecha
          End If
          fv.Key = KIP_FECHA
      
          Set fv = f.Add(Nothing)
          fv.Value = vAplic(Idx).Pendiente
          fv.Key = KIP_PENDIENTE
          
          Set fv = f.Add(Nothing)
          fv.Value = .Aplicado
          fv.Key = KIP_APLICADO
          
          Set fv = f.Add(Nothing)
          fv.Value = .Aplicado
          fv.Key = KIP_APLICADO2
          
          Set Row = f
          Row.BackColor = &HFFCC99
        End If
      End With
    Next
  End Sub

  Private Sub pItSetAplicItemsAux2(ByVal i As Long, ByRef iProp As cIABMProperty, _
                                   ByRef vAplic() As T_Aplic)
    Dim f             As cIABMGridRow
    Dim fv            As cIABMGridCellValue
    
    If vAplic(i).Pendiente <= 0 Then Exit Sub
    
    With vAplic(i)
  
      Set f = iProp.Grid.Rows.Add(Nothing)
      
      Set fv = f.Add(Nothing)
      fv.Id = i
      fv.Key = KIP_IDX1
      
      Set fv = f.Add(Nothing)
      fv.Id = 0
      fv.Key = KIP_IDX2
      
      Set fv = f.Add(Nothing)
      fv.Id = csNO_ID
      fv.Key = KIP_PRVPV_ID
      
      Set fv = f.Add(Nothing)
      fv.Id = .prvi_id
      fv.Key = KIPD_PRVI_ID
    
      Set fv = f.Add(Nothing)
      fv.Id = .pvi_id
      fv.Key = KIPD_PVI_ID
      
      Set fv = f.Add(Nothing)
      fv.Value = .docNombre
      fv.Key = KIP_DOC
      
      Set fv = f.Add(Nothing)
      fv.Value = .NroDoc
      fv.Key = KIP_NRODOC
      
      Set fv = f.Add(Nothing)
      If .Fecha = csNoDate Then
        fv.Value = vbNullString
      Else
        fv.Value = .Fecha
      End If
      fv.Key = KIP_FECHA
  
      Set fv = f.Add(Nothing)
      fv.Value = .Pendiente
      fv.Key = KIP_PENDIENTE
      
      Set fv = f.Add(Nothing)
      fv.Value = 0
      fv.Key = KIP_APLICADO
      
      Set fv = f.Add(Nothing)
      fv.Value = 0
      fv.Key = KIP_APLICADO2
    End With
  End Sub

  Private Function pItAddToAplic(ByRef vAplicaciones() As T_ItAplic, ByVal Importe As Double, ByVal Idx As Long) As Double
    Dim i    As Long
    Dim rtn  As Double
    
    If Idx = 0 Then
      ReDim Preserve vAplicaciones(UBound(vAplicaciones) + 1)
      Idx = UBound(vAplicaciones)
      With vAplicaciones(Idx)
        .prvi_id = m_prvi_id
      End With
    End If
    
    vAplicaciones(Idx).Aplicado = Importe
    
    For i = 1 To UBound(vAplicaciones)
      rtn = rtn + vAplicaciones(i).Aplicado
    Next
    
    pItAddToAplic = rtn
  End Function

  Private Function pItGetItemsProperty() As cIABMProperty
    Set pItGetItemsProperty = m_ObjAbm.Properties(c_AplicPedidoDev)
  End Function
  
  Private Function pItGetItemsAplic() As cIABMGrid
    Set pItGetItemsAplic = m_ObjAbm.Properties(c_AplicPedidoDev).Grid
  End Function

  Private Function pItColBEdit(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
    Select Case pGetKeyFromCol(IProperty.Grid.Columns, lCol)
      Case KIP_APLICADO
      Case Else
        Exit Function
    End Select
    
    pItColBEdit = True
  End Function

  Private Function pItGetItemPendiente() As cIABMGridCellValue
    Dim iProp As cIABMProperty
    Set iProp = m_ObjAbm.Properties(c_PedidoDev)
    Set pItGetItemPendiente = pCell(iProp.Grid.Rows(iProp.SelectedIndex), KII_PENDIENTE)
  End Function
  
  Private Function pItGetItemAplicado() As cIABMGridCellValue
    Dim iProp As cIABMProperty
    Set iProp = m_ObjAbm.Properties(c_PedidoDev)
    Set pItGetItemAplicado = pCell(iProp.Grid.Rows(iProp.SelectedIndex), KII_APLICADO2)
  End Function
  
  Private Function pItColAUpdate(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long)
    Dim Row        As cIABMGridRow
    Dim MaxVal     As Double
    Dim bVisible   As Boolean
    Dim Pendiente  As Double
    
    With IProperty.Grid
      Select Case .Columns(lCol).Key
        Case KIP_APLICADO
          Set Row = .Rows(lRow)
          
          With pCell(Row, KIP_APLICADO)
            
            Pendiente = Val(pItGetItemPendiente().Value) + Val(pCell(Row, KIP_APLICADO2).Value)
            MaxVal = Val(pCell(Row, KIP_PENDIENTE).Value) + Val(pCell(Row, KIP_APLICADO2).Value)
            
            If MaxVal > Pendiente Then
              MaxVal = Pendiente
            End If
            
            If Val(.Value) > MaxVal Then
              .Value = MaxVal
            ElseIf Val(.Value) < 0 Then
              .Value = 0
            End If
            
            Dim Aplicado As Double
            Aplicado = pItGetAplicado()
            pItRefreshItem Aplicado
            pItGetItemAplicado().Value = Aplicado
          End With
          
          ' Actulizo el pendiente
          With pCell(Row, KIP_PENDIENTE)
            .Value = Val(.Value) + Val(pCell(Row, KIP_APLICADO2).Value) - Val(pCell(Row, KIP_APLICADO).Value)
          End With
          pCell(Row, KIP_APLICADO2).Value = pCell(Row, KIP_APLICADO).Value
      End Select
    End With
    
    pItColAUpdate = True
  End Function
  
  Private Function pItGetAplicado() As Double
    Dim Row       As cIABMGridRow
    Dim rtn       As Double
    Dim iProp     As cIABMProperty
    
    Set iProp = m_ObjAbm.Properties(c_AplicPedidoDev)
    
    For Each Row In iProp.Grid.Rows
      rtn = rtn + Val(pCell(Row, KIP_APLICADO).Value)
    Next
    pItGetAplicado = rtn
  End Function
  
  Private Sub pItRefreshItem(ByVal Aplicado As Double)
    Dim iProp     As cIABMProperty
    Dim AbmObj    As cABMGeneric
    Dim Row       As cIABMGridRow
    Dim AplicadoActual  As Double
    Dim LastRow   As Long
    
    Set AbmObj = m_ObjAbm
    
    Set iProp = m_ObjAbm.Properties(c_PedidoDev)
    LastRow = m_LastRowPedidoDev
    Set Row = iProp.Grid.Rows(LastRow)
            
    pCell(Row, KII_APLICADO).Value = Aplicado
    AplicadoActual = Val(pCell(Row, KII_APLICADO2).Value)
    
    With pCell(Row, KII_PENDIENTE)
      .Value = .Value - (Aplicado - AplicadoActual)
    End With
    
    pCell(Row, KII_APLICADO2).Value = Aplicado
    
    AbmObj.ShowCellValue iProp, LastRow, pGetColFromKey(iProp.Grid.Columns, KII_PENDIENTE)
    AbmObj.ShowCellValue iProp, LastRow, pGetColFromKey(iProp.Grid.Columns, KII_APLICADO)
  End Sub
  
'////////////////////////////////////////////////////////////////////////////////////
'
'   construccion - destruccion
'
'////////////////////////////////////////////////////////////////////////////////////
Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(1707, vbNullString)    'Error al grabar el Presupuesto de Venta

  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  ReDim m_vPedidoDevs(0)
  ReDim m_vPedidoDevs(0).vAplicaciones(0)
  
  m_MonDefault = GetMonedaDefault()

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
  
  ReDim m_vPedidoDevs(0)
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
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


'////////////////////////////////////////////////////////////////////////////////////
'
'   REMITOS / REMITOS
'
'////////////////////////////////////////////////////////////////////////////////////

  Private Function pItLoadPedidoDev(ByRef iProp As cIABMProperty) As Boolean
    pItLoadPedidoDev = pItLoadItemsAux(iProp)
  End Function
  
  Private Function pItSetGridAplicPedidoDev(ByRef iProp As cIABMProperty) As Boolean
    pItSetGridAplicPedidoDev = pItSetGridAplicAux(iProp)
  End Function

  Private Function pItSavePedidoDev(ByVal prvTMPId As Long, ByRef vAplic() As T_Aplic) As Boolean
    Dim register    As cRegister
    Dim i           As Long
    Dim j           As Long
    
    For i = 1 To UBound(vAplic)
   
      If vAplic(i).prvi_id <> csNO_ID Or vAplic(i).pvi_id <> csNO_ID Then
   
        For j = 1 To UBound(vAplic(i).vAplicaciones)
        
          If vAplic(i).vAplicaciones(j).prvi_id <> csNO_ID Then
        
            With vAplic(i).vAplicaciones(j)
              
              If .Aplicado > 0 Then
          
                Set register = New cRegister
                
                ' Si estoy vinculando contra un pedido
                If vAplic(i).pvi_id <> 0 Then
                  register.fieldId = cscPrvPvTMPId
                  register.Table = csTPresupuestoPedidoVentaTMP
                  register.Fields.Add2 cscPviId, vAplic(i).pvi_id, csId
                  register.Fields.Add2 cscPrviId, .prvi_id, csId
                
                  register.Fields.Add2 cscPrvPvCantidad, .Aplicado, csDouble
                  register.Fields.Add2 cscPrvPvId, .vinc_id, csLong
                
                ' Si vinculo contra un Presupuesto (Presupuesto - Devolucion)
                Else
                  register.fieldId = cscPrvDvTMPId
                  register.Table = csTPresupuestoDevolucionVentaTMP
                  
                  If m_IsDevolucion Then
                    register.Fields.Add2 cscPrviIdDevolucion, .prvi_id, csId
                    register.Fields.Add2 cscPrviIdPresupuesto, vAplic(i).prvi_id, csId
                  Else
                    register.Fields.Add2 cscPrviIdPresupuesto, .prvi_id, csId
                    register.Fields.Add2 cscPrviIdDevolucion, vAplic(i).prvi_id, csId
                  End If
                
                  register.Fields.Add2 cscPrvDvCantidad, .Aplicado, csDouble
                  register.Fields.Add2 cscPrvDvId, .vinc_id, csLong
                
                End If
                
                register.Id = csNew
                register.Fields.Add2 cscPrvTMPId, prvTMPId, csId
                
                register.Fields.HaveLastUpdate = False
                register.Fields.HaveWhoModify = False
                
                If Not gDB.Save(register, , "pItSavePedidoDev ", C_Module, c_ErrorSave) Then Exit Function
              End If
            End With
          End If
        Next
      End If
    Next
    
    pItSavePedidoDev = True
  End Function
