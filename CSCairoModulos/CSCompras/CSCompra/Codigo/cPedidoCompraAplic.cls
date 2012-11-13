VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPedidoCompraAplic"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cPedidoCompraAplic
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
Private Const C_Module = "cPedidoCompraAplic"

  Private Const cscNroDoc                          As String = "nrodoc"
  Private Const cscPendiente                       As String = "Pendiente"
  Private Const cscImporte                         As String = "Importe"
  Private Const cscVincId                          As String = "vinc_id"
  Private Const cscPcdId                           As String = "pcd_id"
'////////////////////////////////////////////////////////////////////////////////////
'
'   COTIZACIONES - SOLAPA
'
'////////////////////////////////////////////////////////////////////////////////////
  
  ' Cotizaciones
  
  Private Const cscFecha            As String = "Fecha"
  Private Const cscAplicado         As String = "Aplicado"
  Private Const cscAplicCotizacion  As String = "AplicCotizacion"
  
  ' Grillas de Cotizaciones / Pedidos
  Private Const KII_PCI_ID                  As Integer = 1
  Private Const KII_PR_ID                   As Integer = 2
  Private Const KII_APLICADO                As Integer = 4
  Private Const KII_APLICADO2               As Integer = 5
  Private Const KII_PENDIENTE               As Integer = 6
  
  Private Const KIP_PCCOT_ID                 As Integer = 1
  
  Private Const KIOD_OCI_ID                 As Integer = 2
  Private Const KIOD_COTI_ID                As Integer = 3
  Private Const KIOD_PCI_ID                 As Integer = 4
  
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
'   ORDEN DE COMPRA / DEVOLUCION - SOLAPA
'
'////////////////////////////////////////////////////////////////////////////////////
  
  ' Cotizaciones
  
  Private Const K_FAC_DEV = 20
  Private Const K_APLIC_FAC_DEV = 21
  Private Const c_FacDev = "FacDev"
  Private Const c_AplicFacDev = "AplicFacDev"

' estructuras

'////////////////////////////////////////////////////////////////////////////////////
'
'   COTIZACIONES / ORDENES DE COMPRA
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private Type T_ItAplic
    vinc_id                 As Long   ' lo uso para pcoc_id, pccot_id y pcdc_id
    pci_id                  As Long   ' Ids de items al que este credito esta vinculado
    
    Aplicado                As Double
  End Type
  
  Private Type T_Aplic
                                    ' Vinculacion con

    coti_id                 As Long ' Cotizaciones
    oci_id                  As Long ' Ordenes de compra
    pci_id                  As Long ' Cancelacion de pedido
    
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
Private m_PcId              As Long
Private m_IsDevolucion      As Boolean
Private m_PcNumero          As String
Private m_Usuario           As String
Private m_UsId              As Long
Private m_DocId             As Long
Private m_SucId             As Long
Private m_Total             As Double

Private m_MonDefault        As Long

Private m_LastRowFacDev     As Long

' Edit Apply
'
Private m_ObjectClient      As cPedidoCompra
Private m_emp_id            As Long
Private m_emp_nombre        As String

'////////////////////////////////////////////////////////////////////////////////////
'
'   COTIZACIONES / ORDENES DE COMPRA
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private m_vFacDevs()        As T_Aplic
  Private m_pci_id            As Long

' eventos
' propiedades publicas

' Edit Apply
'
Public Property Set ObjectClient(ByVal rhs As cPedidoCompra)
  Set m_ObjectClient = rhs
End Property

Public Property Get Id() As Long
  Id = m_PcId
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Show(ByVal PcId As Long, ByVal Total As Double, _
                     ByVal PcNumero As String, _
                     ByVal UsId As Long, ByVal Usuario As String, _
                     ByVal SucId As Long, ByVal DocId As Long, _
                     ByVal IsDevolucion As Boolean) As Boolean
  
  If m_ObjAbm Is Nothing Then
    Set m_ObjAbm = New cABMGeneric
  End If
  
  If m_PcId <> PcId Then
    m_IsDevolucion = IsDevolucion
    m_PcId = PcId
    m_PcNumero = PcNumero
    m_Usuario = Usuario
    m_UsId = UsId
    m_DocId = DocId
    m_SucId = SucId
    m_Total = Total
    
    ' Edit Apply
    '
    If Not gDB.GetData(csTDocumento, _
                       cscDocId, _
                       m_DocId, _
                       cscEmpId, _
                       m_emp_id) Then Exit Function
    
    If Not gDB.GetData(csTEmpresa, _
                       cscEmpId, _
                       m_emp_id, _
                       cscEmpNombre, _
                       m_emp_nombre) Then Exit Function
    
    Show = pEdit()
  Else
    m_ObjAbm.ObjForm.ZOrder
    
    Show = True
  End If
  
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
          
          Case K_FAC_DEV
          
            Set AbmObj = m_ObjAbm
            
            ' Guardo la aplicacion para el item editado anteriormente
            '
            If m_LastRowFacDev <> 0 Then
              Aplicado = pItUpdateGrids(m_vFacDevs)
            End If
            
            ' Muestro las aplicaciones para este item
            '
            m_LastRowFacDev = iProp.SelectedIndex
            Set Row = iProp.Grid.Rows(m_LastRowFacDev)
            If Row Is Nothing Then Exit Function
            
            pItSetAplicItems m_ObjAbm.Properties(c_AplicFacDev), _
                             pCell(Row, KII_PCI_ID).Id, _
                             pCell(Row, KII_PR_ID).Id, m_vFacDevs
            
            AbmObj.ShowValue m_ObjAbm.Properties(c_AplicFacDev), True
          
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
    m_PcId = csNO_ID
    Set m_ObjAbm = Nothing
    
    ' Edit Apply
    '
    Set m_ObjectClient = Nothing
  End Function
  
  Private Property Get cIABMClient_Title() As String
    On Error Resume Next
    cIABMClient_Title = LNGGetText(1940, vbNullString) 'Aplicación Pedido de Compra
    m_ObjAbm.Title2 = m_PcNumero & " - " & m_Usuario
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
      Case K_APLIC_FAC_DEV
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
      Case K_APLIC_FAC_DEV
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
        
      Case K_APLIC_FAC_DEV

        With pItGetItemsAplic().Rows
          
          Dim ObjEditName As String
                    
          Id = pCell(.Item(lRow), KIOD_COTI_ID).Id
          
          If Id <> csNO_ID Then
            
            If Not gDB.GetData("CotizacionCompraItem", _
                               "coti_id", _
                               Id, _
                               "cot_id", _
                               Id) Then Exit Sub
            
            ObjEditName = "CSCompra2.cCotizacionCompra"
            
          Else
          
            Id = pCell(.Item(lRow), KIOD_OCI_ID).Id
            
            If Id <> csNO_ID Then
              If Not gDB.GetData("OrdenCompraItem", _
                                 "oci_id", _
                                 Id, _
                                 "oc_id", _
                                 Id) Then Exit Sub
              
              ObjEditName = "CSCompra2.cOrdenCompra"
            
            Else
            
              Id = pCell(.Item(lRow), KIOD_PCI_ID).Id
              
              If Id <> csNO_ID Then
                If Not gDB.GetData("PedidoCompraItem", _
                                   "pci_id", _
                                   Id, _
                                   "pc_id", _
                                   Id) Then Exit Sub
                
                ObjEditName = "CSPedidoCompra2.cPedidoCompra"
              End If
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

  Private Function pEdit() As Boolean
    On Error GoTo ControlError
    
    If Not pItLoadAplicItems() Then Exit Function
    If Not LoadCollection() Then Exit Function
    
    m_Editing = True
    pEdit = True
    
    Exit Function
ControlError:
    MngError Err, "pEdit", C_Module, vbNullString
  End Function
  
  Private Function LoadCollection() As Boolean
    Dim c       As cIABMProperty
    Dim iTab    As cIABMTabItem
    Dim oGrd    As cABMGrid
  
    m_LastRowFacDev = 0
    
    m_ObjAbm.Properties.Clear
    m_ObjAbm.Tabs.Clear
    
    Set iTab = m_ObjAbm.Tabs.Add(Nothing)
    iTab.Index = 0
    iTab.Name = LNGGetText(1941, vbNullString) 'Cotizaciones/Ordenes de Compra
   
    With m_ObjAbm.Properties
   
      Set c = .Add(Nothing, c_FacDev)
      c.PropertyType = cspGrid
      c.LeftLabel = -1
      If Not pItLoadFacDev(c) Then Exit Function
      c.Key = K_FAC_DEV
      c.Name = "Items2"
      c.Width = 9400
      c.Left = 250
      c.Height = 2600
      c.GridEdit = False
      c.GridAdd = False
      c.GridRemove = False
      Set oGrd = c.Grid
      oGrd.RowSelect = True
      oGrd.DontSelectInGotFocus = True
      
      Set c = .Add(Nothing, c_AplicFacDev)
      c.PropertyType = cspGrid
      c.LeftLabel = -1
      If Not pItSetGridAplicFacDev(c) Then Exit Function
      c.Key = K_APLIC_FAC_DEV
      c.Name = "Ordenes de compra"
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
    End With
    
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
    
    Dim pcTMPId As Long
    
    pItUpdateGrids m_vFacDevs
    
    ' Temporal
    If Not pSaveDocCpra(m_DocId, pcTMPId) Then Exit Function
  
    ' Ordenes de compra / Devoluciones
    If Not pItSaveFacDev(pcTMPId, m_vFacDevs) Then Exit Function
    
    ' Aplico llamando al sp
    Dim sqlstmt As String
    Dim rs      As Recordset
    
    sqlstmt = "sp_DocPedidoCompraSaveAplic " & pcTMPId
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
  ' PedidoCompraTemporal
  '////////////////////////////////////////////////////////////////////////////////////
  Private Function pSaveDocCpra(ByVal DocId As Long, _
                               ByRef pcTMPId As Long) As Boolean
    Dim register     As cRegister
    
    Set register = New cRegister
    register.fieldId = cscPcTMPId
    register.Table = csTPedidoCompraTMP
  
    register.Id = csNew
    register.fields.Add2 cscPcId, m_PcId, csId
  
    register.fields.Add2 cscPcNumero, 0, csLong
    register.fields.Add2 cscPcNrodoc, vbNullString, csText
    
    register.fields.Add2 cscUsId, 0, csLong
    register.fields.Add2 cscSucId, 0, csLong
    register.fields.Add2 cscDocId, DocId, csId
    
    register.fields.Add2 cscEstId, CSGeneralEx2.csEEstado.csEEst_Pendiente, csId
  
    register.fields.HaveLastUpdate = True
    register.fields.HaveWhoModify = True
  
    If Not register.BeginTrans(gDB) Then Exit Function
  
    If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
    If Not register.CommitTrans() Then Exit Function
  
    pcTMPId = register.Id
    pSaveDocCpra = True
  End Function

'////////////////////////////////////////////////////////////////////////////////////
'
'   PEDIDOS
'
'////////////////////////////////////////////////////////////////////////////////////

  Private Function pItLoadAplicItems() As Boolean
    
    If Not pItLoadAplicAplicados(m_vFacDevs) Then Exit Function
    If Not pItLoadAplicCreditos(m_vFacDevs) Then Exit Function
    
    pItLoadAplicItems = True
  End Function
  
  Private Function pItLoadItems(ByRef iProp As cIABMProperty) As Boolean
    pItLoadItems = pItLoadItemsAux(iProp)
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
  
    sqlstmt = "sp_DocPedidoCompraGetAplic " & EmpId & "," & m_PcId & ",1"
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pItLoadItems", C_Module) Then Exit Function
  
    iProp.Grid.Columns.Clear
    iProp.Grid.Rows.Clear
  
    Set Grid = iProp.Grid
  
    With Grid.Columns
      With .Add(Nothing)
        .Visible = False
        .Key = KII_PCI_ID
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1619, vbNullString) 'Producto
        .PropertyType = cspText
        .Width = 2500
        .Key = KII_PR_ID
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1609, vbNullString) 'Pendiente
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1245
        .Key = KII_PENDIENTE
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1608, vbNullString) 'Aplicado
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
      fv.Id = gDB.ValField(rs.fields, cscPciId)
      fv.Key = KII_PCI_ID
  
      Set fv = f.Add(Nothing)
      fv.Id = gDB.ValField(rs.fields, cscPrId)
      fv.Value = gDB.ValField(rs.fields, cscPrNombrecompra)
      fv.Key = KII_PR_ID
  
      Set fv = f.Add(Nothing)
      fv.Value = gDB.ValField(rs.fields, cscPciPendiente)
      fv.Key = KII_PENDIENTE
      
      Value = gDB.ValField(rs.fields, cscAplicCotizacion)
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
        .Key = KIP_PCCOT_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIOD_OCI_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIOD_COTI_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIOD_PCI_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1567, vbNullString) 'Documento
        .PropertyType = cspText
        .Width = 2925
        .Key = KIP_DOC
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1610, vbNullString) 'Comprobante
        .PropertyType = cspText
        .Width = 1575
        .Key = KIP_NRODOC
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1569, vbNullString) 'Fecha
        .PropertyType = cspDate
        .Width = 1395
        .Key = KIP_FECHA
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1609, vbNullString) 'Pendiente
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1245
        .Key = KIP_PENDIENTE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1608, vbNullString) 'Aplicado
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
    
    sqlstmt = "sp_DocPedidoCompraGetAplic " & EmpId & "," & m_PcId & ",2"
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadAplicAplicados", C_Module) Then Exit Function
    
    ReDim vAplic(0)
    ReDim vAplic(0).vAplicaciones(0)
    
    If Not rs.EOF Then
    
      rs.MoveLast
      rs.MoveFirst
    
      While Not rs.EOF
            
        i = pItAddToCreditos(gDB.ValField(rs.fields, cscCotiId), _
                             gDB.ValField(rs.fields, cscOciId), _
                             gDB.ValField(rs.fields, cscPciId), _
                             Idx, vAplic)
        
        With vAplic(i)
        
          ' Documento
          '
          .docNombre = gDB.ValField(rs.fields, cscDocNombre)
          .NroDoc = gDB.ValField(rs.fields, cscNroDoc)
          .Fecha = gDB.ValField(rs.fields, cscFecha)
          
          ' Pendiente
          '
          .Pendiente = gDB.ValField(rs.fields, cscPendiente)
          .PendienteActual = .Pendiente
          
          ' Pedido
          '
          .pci_id = gDB.ValField(rs.fields, cscPcdId)
          .oci_id = gDB.ValField(rs.fields, cscOciId)
          .coti_id = gDB.ValField(rs.fields, cscCotiId)
          
          .PR_ID = gDB.ValField(rs.fields, cscPrId)
          
          ' Aplicaciones
          With .vAplicaciones(Idx)
          
            .vinc_id = gDB.ValField(rs.fields, cscVincId)
              
            .pci_id = gDB.ValField(rs.fields, cscPciId)
            
            .Aplicado = gDB.ValField(rs.fields, cscAplicado)
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
    
    sqlstmt = "sp_DocPedidoCompraGetAplic " & EmpId & "," & m_PcId & ",3"
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadAplicCreditos", C_Module) Then Exit Function
    
    If Not rs.EOF Then
      
      rs.MoveLast
      rs.MoveFirst
    
      i = UBound(vAplic)
      ReDim Preserve vAplic(i + rs.RecordCount)
      
      While Not rs.EOF
            
        i = i + 1
        With vAplic(i)
          .PR_ID = gDB.ValField(rs.fields, cscPrId)
          
          .coti_id = gDB.ValField(rs.fields, cscCotiId)
          .pci_id = gDB.ValField(rs.fields, cscPcdId)
          .oci_id = gDB.ValField(rs.fields, cscOciId)
  
          .docNombre = gDB.ValField(rs.fields, cscDocNombre)
          .NroDoc = gDB.ValField(rs.fields, cscNroDoc)
          .Fecha = gDB.ValField(rs.fields, cscFecha)
            
          .Pendiente = gDB.ValField(rs.fields, cscPendiente)
          .PendienteActual = .Pendiente
          
          ReDim .vAplicaciones(0)
        End With
        
        rs.MoveNext
      Wend
    End If
    
    pItLoadAplicCreditos = True
  End Function
  
  Private Function pItAddToCreditos(ByVal CotiId As Long, _
                                    ByVal OciId As Long, _
                                    ByVal PciId As Long, _
                                    ByRef Idx As Long, _
                                    ByRef vAplic() As T_Aplic) As Long
    Dim i As Long
    
    For i = 1 To UBound(vAplic)
      With vAplic(i)
        If (.coti_id = CotiId And CotiId <> csNO_ID) Or _
           (.oci_id = OciId And OciId <> csNO_ID) Or _
           (.pci_id = PciId And PciId <> csNO_ID) Then
           
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
    
    Set iProp = m_ObjAbm.Properties(c_FacDev)
    Set iPropAplic = m_ObjAbm.Properties(c_AplicFacDev)
    LastRow = m_LastRowFacDev
    
    If LastRow <> 0 Then
      
      Set Row = iProp.Grid.Rows(LastRow)
      pItUpdateGrids = pItUpdateAplicItems(iPropAplic, _
                                           pCell(Row, KII_PCI_ID).Id, _
                                           vAplic)
    End If
  End Function
  
  Private Function pItSetAplicItems(ByRef iProp As cIABMProperty, _
                                    ByVal pci_id As Long, _
                                    ByVal PR_ID As Long, _
                                    ByRef vAplic() As T_Aplic) As Boolean
    Dim Cotizacion    As Double
    Dim i             As Long
    Dim j             As Long
    
    iProp.Grid.Rows.Clear
    
    m_pci_id = pci_id
    
    For i = 1 To UBound(vAplic)
    
      If vAplic(i).PR_ID = PR_ID Then
    
        If UBound(vAplic(i).vAplicaciones) > 0 Then
          pItSetAplicItemsAux1 i, iProp, pci_id, vAplic
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
        
          Id = pCell(Row, KIOD_OCI_ID).Id
          If Id = vAplic(i).oci_id And Id <> csNO_ID Then
            bAplic = True
            Exit For
          End If
        
          Id = pCell(Row, KIOD_COTI_ID).Id
          If Id = vAplic(i).coti_id And Id <> csNO_ID Then
            bAplic = True
            Exit For
          End If
        
          Id = pCell(Row, KIOD_PCI_ID).Id
          If Id = vAplic(i).pci_id And Id <> csNO_ID Then
            bAplic = True
            Exit For
          End If
        
          Id = m_pci_id
          For j = 1 To UBound(vAplic(i).vAplicaciones)
            If Id = vAplic(i).vAplicaciones(j).pci_id And Id <> csNO_ID Then
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
                                       ByVal pci_id As Long, _
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
  
  Private Sub pItSetAplicItemsAux1(ByVal Idx As Long, ByRef iProp As cIABMProperty, ByVal pci_id As Long, _
                                   ByRef vAplic() As T_Aplic)
    Dim f               As cIABMGridRow
    Dim fv              As cIABMGridCellValue
    Dim i               As Long
    Dim iPropItem       As cIABMProperty
    Dim Row             As cABMGridRow
    
    For i = 1 To UBound(vAplic(Idx).vAplicaciones)
    
      With vAplic(Idx).vAplicaciones(i)
    
        If .pci_id = pci_id And pci_id <> csNO_ID Then
        
          Set f = iProp.Grid.Rows.Add(Nothing)
          
          Set fv = f.Add(Nothing)
          fv.Id = Idx
          fv.Key = KIP_IDX1
          
          Set fv = f.Add(Nothing)
          fv.Id = i
          fv.Key = KIP_IDX2
          
          Set fv = f.Add(Nothing)
          fv.Id = .vinc_id
          fv.Key = KIP_PCCOT_ID
          
          Set fv = f.Add(Nothing)
          
          fv.Key = KIOD_PCI_ID
          fv.Id = vAplic(Idx).pci_id
          
          Set fv = f.Add(Nothing)
          fv.Id = vAplic(Idx).oci_id
          fv.Key = KIOD_OCI_ID
        
          Set fv = f.Add(Nothing)
          fv.Id = vAplic(Idx).coti_id
          fv.Key = KIOD_COTI_ID
          
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
      fv.Key = KIP_PCCOT_ID
      
      Set fv = f.Add(Nothing)
      
      fv.Key = KIOD_PCI_ID
      fv.Id = .pci_id
      
      Set fv = f.Add(Nothing)
      fv.Id = .oci_id
      fv.Key = KIOD_OCI_ID
    
      Set fv = f.Add(Nothing)
      fv.Id = .coti_id
      fv.Key = KIOD_COTI_ID
      
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
        .pci_id = m_pci_id
      End With
    End If
    
    vAplicaciones(Idx).Aplicado = Importe
    
    For i = 1 To UBound(vAplicaciones)
      rtn = rtn + vAplicaciones(i).Aplicado
    Next
    
    pItAddToAplic = rtn
  End Function

  Private Function pItGetItemsProperty() As cIABMProperty
    Set pItGetItemsProperty = m_ObjAbm.Properties(c_AplicFacDev)
  End Function
  
  Private Function pItGetItemsAplic() As cIABMGrid
    Set pItGetItemsAplic = m_ObjAbm.Properties(c_AplicFacDev).Grid
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
    Set iProp = m_ObjAbm.Properties(c_FacDev)
    Set pItGetItemPendiente = pCell(iProp.Grid.Rows(iProp.SelectedIndex), KII_PENDIENTE)
  End Function
  
  Private Function pItGetItemAplicado() As cIABMGridCellValue
    Dim iProp As cIABMProperty
    Set iProp = m_ObjAbm.Properties(c_FacDev)
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
    
    Set iProp = m_ObjAbm.Properties(c_AplicFacDev)
    
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
    
    Set iProp = m_ObjAbm.Properties(c_FacDev)
    LastRow = m_LastRowFacDev
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

  c_ErrorSave = LNGGetText(1936, vbNullString) 'Error al grabar el Pedido de Compra

  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  ReDim m_vFacDevs(0)
  ReDim m_vFacDevs(0).vAplicaciones(0)
  
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
  
  ReDim m_vFacDevs(0)
  
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
'   COTIZACIONES / ORDENES DE COMPRA
'
'////////////////////////////////////////////////////////////////////////////////////

  Private Function pItLoadFacDev(ByRef iProp As cIABMProperty) As Boolean
    pItLoadFacDev = pItLoadItemsAux(iProp)
  End Function
  
  Private Function pItSetGridAplicFacDev(ByRef iProp As cIABMProperty) As Boolean
    pItSetGridAplicFacDev = pItSetGridAplicAux(iProp)
  End Function

  Private Function pItSaveFacDev(ByVal pcTMPId As Long, ByRef vAplic() As T_Aplic) As Boolean
    Dim register    As cRegister
    Dim i           As Long
    Dim j           As Long
    
    For i = 1 To UBound(vAplic)
   
      If vAplic(i).oci_id <> csNO_ID Or vAplic(i).pci_id <> csNO_ID Or vAplic(i).coti_id <> csNO_ID Then
   
        For j = 1 To UBound(vAplic(i).vAplicaciones)
        
          If vAplic(i).vAplicaciones(j).pci_id <> csNO_ID Then
        
            With vAplic(i).vAplicaciones(j)
              
              If .Aplicado > 0 Then
          
                Set register = New cRegister
                
                ' Si estoy vinculando contra una orden de compra
                If vAplic(i).oci_id <> 0 Then
                  register.fieldId = cscPcOcTMPId
                  register.Table = csTPedidoOrdenCompraTMP
                  register.fields.Add2 cscOciId, vAplic(i).oci_id, csId
                  register.fields.Add2 cscPciId, .pci_id, csId
                
                  register.fields.Add2 cscPcOcCantidad, .Aplicado, csDouble
                  register.fields.Add2 cscPcOcId, .vinc_id, csLong
                
                ElseIf vAplic(i).coti_id <> 0 Then
                
                  register.fieldId = cscPccotTMPId
                  register.Table = csTPedidoCotizacionCompraTMP
                  register.fields.Add2 cscCotiId, vAplic(i).coti_id, csId
                  register.fields.Add2 cscPciId, .pci_id, csId
                  
                  register.fields.Add2 cscPccotCantidad, .Aplicado, csDouble
                  register.fields.Add2 cscPccotId, .vinc_id, csLong
                
                ' Si vinculo contra un pedido (Pedido - Devolucion)
                Else
                  register.fieldId = cscPcDcTMPId
                  register.Table = csTPedidoDevolucionCompraTMP
                  
                  If m_IsDevolucion Then
                    register.fields.Add2 cscPciIdDevolucion, .pci_id, csId
                    register.fields.Add2 cscPciIdPedido, vAplic(i).pci_id, csId
                  Else
                    register.fields.Add2 cscPciIdPedido, .pci_id, csId
                    register.fields.Add2 cscPciIdDevolucion, vAplic(i).pci_id, csId
                  End If
                
                  register.fields.Add2 cscPcDcCantidad, .Aplicado, csDouble
                  register.fields.Add2 cscPcDcId, .vinc_id, csLong
                
                End If
                
                register.Id = csNew
                register.fields.Add2 cscPcTMPId, pcTMPId, csId
                
                register.fields.HaveLastUpdate = False
                register.fields.HaveWhoModify = False
                
                If Not gDB.Save(register, , "pItSaveFacDev ", C_Module, c_ErrorSave) Then Exit Function
              End If
            End With
          End If
        Next
      End If
    Next
    
    pItSaveFacDev = True
  End Function
