VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPackingListAplic"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cPackingListAplic
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
Private Const C_Module = "cPackingListAplic"

'////////////////////////////////////////////////////////////////////////////////////
'
'   CAMPOS
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private Const cscNroDoc                          As String = "nrodoc"
  Private Const cscPendiente                       As String = "Pendiente"
  Private Const cscImporte                         As String = "Importe"
  Private Const cscVincId                          As String = "vinc_id"
  Private Const cscPklstdId                        As String = "pklstd_id"
'////////////////////////////////////////////////////////////////////////////////////
'
'   PEDIDO - SOLAPA
'
'////////////////////////////////////////////////////////////////////////////////////
  
  ' Pedido
  
  Private Const K_PEDIDO = 10
  Private Const K_APLIC_PEDIDO = 11
  Private Const K_DES_APLIC_PEDIDO = 13
  
  Private Const c_Items = "Items"
  Private Const c_AplicPedido = "AplicPedido"
  Private Const c_DesAplicPedido = "DesAplicPedido"

  Private Const cscFecha              As String = "Fecha"
  Private Const cscAplicado           As String = "Aplicado"
  Private Const cscAplicPackingList   As String = "AplicPackingList"
  Private Const cscAplicPedido        As String = "AplicPedido"
  
  ' Grillas de Pedidos / PackingLists
  Private Const KII_PKLSTI_ID               As Integer = 1
  Private Const KII_PR_ID                   As Integer = 2
  Private Const KII_APLICADO                As Integer = 4
  Private Const KII_APLICADO2               As Integer = 5
  Private Const KII_PENDIENTE               As Integer = 6
  
  Private Const KIP_PVPKLST_ID              As Integer = 1
  
  Private Const KIFD_FVI_ID                 As Integer = 2
  
  ' Estos dos tienen el mismo valor aproposito
  Private Const KIP_PVI_ID                  As Integer = 3
  Private Const KIFD_PKLSTI_ID              As Integer = KIP_PVI_ID
  
  Private Const KIP_MFCI_ID                 As Integer = 4
  
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
'   FACTURA / DEVOLUCION - SOLAPA
'
'////////////////////////////////////////////////////////////////////////////////////
  
  ' Pedido
  
  Private Const K_FAC_DEV = 20
  Private Const K_APLIC_FAC_DEV = 21
  Private Const K_DES_APLIC_FAC = 22
  Private Const c_FacDev = "FacDev"
  Private Const c_AplicFacDev = "AplicFacDev"
  Private Const c_DesAplicFac = "DesAplicFac"
  
' estructuras

'////////////////////////////////////////////////////////////////////////////////////
'
'   PEDIDOS / PACKING LIST
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private Type T_ItAplic
    vinc_id                 As Long   ' lo uso para pvpklst_id, mfcpklst_id, pklstfv_id y pklstdv_id
    pklsti_id               As Long   ' Ids de items al que este credito esta vinculado
    
    Aplicado                As Double
  End Type
  
  Private Type T_Aplic
    pvi_id                  As Long ' Vinculacion con pedido
    mfci_id                 As Long ' Vinculacion con Manifiesto de carga
    fvi_id                  As Long ' Vinculacion con packing list
    
    pklsti_id               As Long
    
    PR_ID                   As Long
    
    Fecha                   As Date
    docNombre               As String
    nroDoc                  As String
    
    PendienteActual         As Double
    AplicadoActual          As Double
    
    Pendiente               As Double
    Aplicado                As Double
    
    vAplicaciones()         As T_ItAplic
  End Type

' Seudo - Variable
Private c_ErrorSave         As String

' variables privadas

' generales

Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric
Private m_GeneralConfig     As cGeneralConfig
Private m_PklstId           As Long
Private m_IsDevolucion      As Boolean
Private m_PklstNumero       As String
Private m_Cliente           As String
Private m_CliId             As Long
Private m_DocId             As Long
Private m_SucId             As Long
Private m_Total             As Double

Private m_MonDefault        As Long

Private m_LastRowItem       As Long
Private m_LastRowFacDev     As Long

' Edit Apply
'
Private m_ObjectClient      As cPackingList
Private m_emp_id            As Long
Private m_emp_nombre        As String

'////////////////////////////////////////////////////////////////////////////////////
'
'   PEDIDOS / PACKING LIST
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private m_vPedidos()        As T_Aplic
  Private m_vFacDevs()        As T_Aplic
  Private m_pklsti_id         As Long

' eventos
' propiedades publicas

' Edit Apply
'
Public Property Set ObjectClient(ByVal rhs As cPackingList)
  Set m_ObjectClient = rhs
End Property

Public Property Get ID() As Long
  ID = m_PklstId
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Show(ByVal PklstId As Long, ByVal Total As Double, _
                     ByVal PklstNumero As String, _
                     ByVal CliId As Long, ByVal Cliente As String, _
                     ByVal SucId As Long, ByVal DocId As Long, _
                     ByVal IsDevolucion As Boolean) As Boolean
  
  If m_ObjAbm Is Nothing Then
    Set m_ObjAbm = New cABMGeneric
  End If
  
  If m_PklstId <> PklstId Then
    m_IsDevolucion = IsDevolucion
    m_PklstId = PklstId
    m_PklstNumero = PklstNumero
    m_Cliente = Cliente
    m_CliId = CliId
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
          
          Case K_PEDIDO
          
            Set AbmObj = m_ObjAbm
            
            ' Guardo la aplicacion para el item editado anteriormente
            '
            If m_LastRowItem <> 0 Then
              Aplicado = pItUpdateGrids(True, m_vPedidos)
            End If
            
            ' Muestro las aplicaciones para este item
            '
            m_LastRowItem = iProp.SelectedIndex
            Set Row = iProp.Grid.Rows(m_LastRowItem)
            If Row Is Nothing Then Exit Function
            
            pItSetAplicItems m_ObjAbm.Properties(c_AplicPedido), _
                             pCell(Row, KII_PKLSTI_ID).ID, _
                             pCell(Row, KII_PR_ID).ID, m_vPedidos, True
            
            AbmObj.ShowValue m_ObjAbm.Properties(c_AplicPedido), True
          
          Case K_FAC_DEV
          
            Set AbmObj = m_ObjAbm
            
            ' Guardo la aplicacion para el item editado anteriormente
            '
            If m_LastRowFacDev <> 0 Then
              Aplicado = pItUpdateGrids(False, m_vFacDevs)
            End If
            
            ' Muestro las aplicaciones para este item
            '
            m_LastRowFacDev = iProp.SelectedIndex
            Set Row = iProp.Grid.Rows(m_LastRowFacDev)
            If Row Is Nothing Then Exit Function
            
            pItSetAplicItems m_ObjAbm.Properties(c_AplicFacDev), _
                             pCell(Row, KII_PKLSTI_ID).ID, _
                             pCell(Row, KII_PR_ID).ID, m_vFacDevs, False
            
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
    Select Case Key
      Case K_DES_APLIC_FAC
        pDesAplicFacturas
      Case K_DES_APLIC_PEDIDO
        pDesAplicPedidos
    End Select
  End Function
  
  Private Sub pDesAplicPedidos()
    Dim i As Long
    Dim j As Long
    
    For i = 1 To UBound(m_vPedidos)
      With m_vPedidos(i)
        .Aplicado = 0
        .Pendiente = .PendienteActual + .AplicadoActual
        For j = 1 To UBound(.vAplicaciones)
          .vAplicaciones(j).Aplicado = 0
        Next
      End With
    Next
  
    Dim AbmObj As cABMGeneric
    Set AbmObj = m_ObjAbm
  
    pSetDesAplicToGrid m_vPedidos, m_ObjAbm.Properties(c_Items)
    
    If m_LastRowItem > 0 Then
      With m_ObjAbm.Properties(c_Items).Grid.Rows.Item(m_LastRowItem)
        pItSetAplicItems m_ObjAbm.Properties(c_AplicPedido), .Item(KII_PKLSTI_ID).ID, .Item(KII_PR_ID).ID, m_vPedidos(), True
      End With
    End If
  
    AbmObj.ShowValue m_ObjAbm.Properties(c_Items), True
    AbmObj.ShowValue m_ObjAbm.Properties(c_AplicPedido), True
  End Sub
  
  Private Sub pDesAplicFacturas()
    Dim i As Long
    Dim j As Long
    
    For i = 1 To UBound(m_vFacDevs)
      With m_vFacDevs(i)
        .Aplicado = 0
        .Pendiente = .PendienteActual + .AplicadoActual
        For j = 1 To UBound(.vAplicaciones)
          .vAplicaciones(j).Aplicado = 0
        Next
      End With
    Next
  
    Dim AbmObj As cABMGeneric
    Set AbmObj = m_ObjAbm
  
    pSetDesAplicToGrid m_vFacDevs, m_ObjAbm.Properties(c_FacDev)
    
    If m_LastRowFacDev <> 0 Then
      With m_ObjAbm.Properties(c_FacDev).Grid.Rows.Item(m_LastRowFacDev)
        pItSetAplicItems m_ObjAbm.Properties(c_AplicFacDev), .Item(KII_PKLSTI_ID).ID, .Item(KII_PR_ID).ID, m_vFacDevs(), False
      End With
    End If
    
    AbmObj.ShowValue m_ObjAbm.Properties(c_FacDev), True
    AbmObj.ShowValue m_ObjAbm.Properties(c_AplicFacDev), True
  End Sub
  
  Private Sub pSetDesAplicToGrid(ByRef vAplic() As T_Aplic, ByRef iProp As cIABMProperty)
    Dim Row  As cIABMGridRow

    For Each Row In iProp.Grid.Rows
      pCell(Row, KII_PENDIENTE).Value = Val(pCell(Row, KII_PENDIENTE).Value) + Val(pCell(Row, KII_APLICADO).Value)
      pCell(Row, KII_APLICADO).Value = 0
    Next
  
    Dim i As Long
    Dim j As Long
  
    For i = 1 To UBound(vAplic)
      With vAplic(i)
        For j = 1 To UBound(.vAplicaciones)
          .Aplicado = pItAddToAplic(.vAplicaciones, 0, j)
          .Pendiente = .PendienteActual - (.Aplicado - .AplicadoActual)
        Next
      End With
    Next
  End Sub
  
  Private Function cIABMClient_Save() As Boolean
    cIABMClient_Save = pSave
  End Function
  
  Private Function cIABMClient_Terminate() As Boolean
    m_Editing = False
    cIABMClient_Terminate = True
    m_PklstId = csNO_ID
    Set m_ObjAbm = Nothing
  
    ' Edit Apply
    '
    Set m_ObjectClient = Nothing
  End Function
  
  Private Property Get cIABMClient_Title() As String
    On Error Resume Next
    cIABMClient_Title = LNGGetText(2522, vbNullString) 'Aplicación Packing List
    m_ObjAbm.Title2 = m_PklstNumero & " - " & m_Cliente
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
      Case K_APLIC_PEDIDO
        cIABMClientGrid_ColumnAfterUpdate = pItColAUpdate(pItGetItemsProperty(True), lRow, lCol, True)
      Case K_APLIC_FAC_DEV
        cIABMClientGrid_ColumnAfterUpdate = pItColAUpdate(pItGetItemsProperty(False), lRow, lCol, False)
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
        cIABMClientGrid_ColumnBeforeEdit = pItColBEdit(pItGetItemsProperty(True), lRow, lCol, iKeyAscii)
      Case K_APLIC_FAC_DEV
        cIABMClientGrid_ColumnBeforeEdit = pItColBEdit(pItGetItemsProperty(False), lRow, lCol, iKeyAscii)
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
    
    Dim ID          As Long
    Dim ObjEditName As String

    Select Case Key

      Case K_APLIC_PEDIDO
        
        With pItGetItemsAplic(True).Rows
          
          ID = pCell(.Item(lRow), KIP_PVI_ID).ID
          
          If ID <> csNO_ID Then
            
            If Not gDB.GetData("PedidoVentaItem", _
                               "pvi_id", _
                               ID, _
                               "pv_id", _
                               ID) Then Exit Sub
            
            ObjEditName = "CSPedidoVena2.cPedidoVenta"
            
          Else
          
            ID = pCell(.Item(lRow), KIP_MFCI_ID).ID
            
            If ID <> csNO_ID Then
              If Not gDB.GetData("ManifiestoCargaItem", _
                                 "mfci_id", _
                                 ID, _
                                 "mfc_id", _
                                 ID) Then Exit Sub
              
              ObjEditName = "CSExport2.cManifiestoCarga"
            End If
          End If
            
          If ID <> csNO_ID Then
          
            ShowDocAux ID, _
                       ObjEditName, _
                       "CSABMInterface2.cABMGeneric"
          End If
          
        End With
        
      Case K_APLIC_FAC_DEV

        With pItGetItemsAplic(False).Rows
                    
          ID = pCell(.Item(lRow), KIFD_PKLSTI_ID).ID
          
          If ID <> csNO_ID Then
            
            If Not gDB.GetData("PackinListItem", _
                               "pklsti_id", _
                               ID, _
                               "pklst_id", _
                               ID) Then Exit Sub
            
            ObjEditName = "CSExport2.cPackingList"
            
          Else
          
            ID = pCell(.Item(lRow), KIFD_FVI_ID).ID
            
            If ID <> csNO_ID Then
              If Not gDB.GetData("FacturaVentaItem", _
                                 "fvi_id", _
                                 ID, _
                                 "fv_id", _
                                 ID) Then Exit Sub
              
              ObjEditName = "CSVenta2.cFacturaVenta"
            End If
          End If
            
          If ID <> csNO_ID Then
          
            ShowDocAux ID, _
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
  
    m_LastRowItem = 0
    m_LastRowFacDev = 0
    
    m_ObjAbm.Properties.Clear
    m_ObjAbm.Tabs.Clear
    
    Set iTab = m_ObjAbm.Tabs.Add(Nothing)
    iTab.Index = 0
    iTab.Name = LNGGetText(1694, vbNullString) 'Pedidos
    
   
    Set iTab = m_ObjAbm.Tabs.Add(Nothing)
    iTab.Index = 1
    iTab.Name = LNGGetText(1607, vbNullString) 'Facturas
    
   
    Set c = m_ObjAbm.Properties.Add(Nothing, c_Items)
    c.PropertyType = cspGrid
    If Not pItLoadItems(c) Then Exit Function
    c.Key = K_PEDIDO
    c.Name = "Items"
    c.LeftLabel = -1
    c.Width = 9400
    c.Left = 250
    c.Height = 2600
    c.GridEdit = False
    c.GridAdd = False
    c.GridRemove = False
    Set oGrd = c.Grid
    oGrd.RowSelect = True
    oGrd.DontSelectInGotFocus = True
    
    Set c = m_ObjAbm.Properties.Add(Nothing, c_DesAplicPedido)
    c.PropertyType = cspButton
    c.Name = LNGGetText(2523, vbNullString) 'Desaplicar
    c.Key = K_DES_APLIC_PEDIDO
    
    Set c = m_ObjAbm.Properties.Add(Nothing, c_AplicPedido)
    c.PropertyType = cspGrid
    If Not pItSetGridAplicPedido(c) Then Exit Function
    c.Key = K_APLIC_PEDIDO
    c.Name = "Pedido"
    c.LeftLabel = -1
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
    
    Set c = m_ObjAbm.Properties.Add(Nothing, c_FacDev)
    c.PropertyType = cspGrid
    If Not pItLoadFacDev(c) Then Exit Function
    c.Key = K_FAC_DEV
    c.Name = "Items2"
    c.LeftLabel = -1
    c.Width = 9400
    c.Left = 250
    c.Height = 2600
    c.GridEdit = False
    c.GridAdd = False
    c.GridRemove = False
    c.TabIndex = 1
    Set oGrd = c.Grid
    oGrd.RowSelect = True
    oGrd.DontSelectInGotFocus = True
    
    Set c = m_ObjAbm.Properties.Add(Nothing, c_DesAplicFac)
    c.PropertyType = cspButton
    c.Name = LNGGetText(2523, vbNullString) 'Desaplicar
    c.Key = K_DES_APLIC_FAC
    c.TabIndex = 1
  
    Set c = m_ObjAbm.Properties.Add(Nothing, c_AplicFacDev)
    c.PropertyType = cspGrid
    If Not pItSetGridAplicFacDev(c) Then Exit Function
    c.Key = K_APLIC_FAC_DEV
    c.Name = "Facturas"
    c.LeftLabel = -1
    c.Width = 9400
    c.Left = 250
    c.Top = 4200
    c.Height = 2000
    c.GridEdit = True
    c.GridAdd = False
    c.GridRemove = False
    c.TabIndex = 1
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
    
    Dim PklstTMPId As Long
    
    pItUpdateGrids True, m_vPedidos
    pItUpdateGrids False, m_vFacDevs
    
    ' Temporal
    If Not pSaveDocVta(m_DocId, PklstTMPId) Then Exit Function
  
    ' Pedidos
    If Not pItSavePedidoManifiesto(PklstTMPId) Then Exit Function
    
    ' Facturas / Devoluciones
    If Not pItSaveFacDev(PklstTMPId, m_vFacDevs) Then Exit Function
    
    ' Aplico llamando al sp
    Dim sqlstmt As String
    Dim rs      As Recordset
    
    sqlstmt = "sp_DocPackingListSaveAplic " & PklstTMPId
    If Not gDB.OpenRs(sqlstmt, rs, , , , "pSave", C_Module, c_ErrorSave) Then Exit Function
    
    If rs.EOF Then Exit Function
    
    Dim ID As Long
    If Not GetDocIDFromRecordset(rs, ID) Then Exit Function
    
    If ID = csNO_ID Then Exit Function
    
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

  Private Function pItSavePedidoManifiesto(ByVal PklstTMPId As Long) As Boolean
    If Not pItSavePedido(PklstTMPId, m_vPedidos) Then Exit Function
    If Not pItSaveManifiesto(PklstTMPId, m_vPedidos) Then Exit Function
    pItSavePedidoManifiesto = True
  End Function

  '////////////////////////////////////////////////////////////////////////////////////
  ' PackingListTemporal
  '////////////////////////////////////////////////////////////////////////////////////
  Private Function pSaveDocVta(ByVal DocId As Long, _
                               ByRef PklstTMPId As Long) As Boolean
    Dim register     As cRegister
    
    Set register = New cRegister
    register.fieldId = cscPklstTMPId
    register.Table = csTPackingListTMP
  
    register.ID = csNew
    register.Fields.Add2 cscPklstId, m_PklstId, csId
  
    register.Fields.Add2 cscPklstNumero, 0, csLong
    register.Fields.Add2 cscPklstNrodoc, "", csText
    
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
  
    PklstTMPId = register.ID
    pSaveDocVta = True
  End Function

'////////////////////////////////////////////////////////////////////////////////////
'
'   PEDIDOS / PACKING LIST
'
'////////////////////////////////////////////////////////////////////////////////////

  Private Function pItLoadAplicItems() As Boolean
    
    If Not pItLoadAplicAplicados(m_vPedidos, True) Then Exit Function
    If Not pItLoadAplicCreditos(m_vPedidos, True) Then Exit Function
    
    If Not pItLoadAplicAplicados(m_vFacDevs, False) Then Exit Function
    If Not pItLoadAplicCreditos(m_vFacDevs, False) Then Exit Function
    
    pItLoadAplicItems = True
  End Function
  
  Private Function pItLoadItems(ByRef iProp As cIABMProperty) As Boolean
    pItLoadItems = pItLoadItemsAux(iProp, True)
  End Function

  Private Function pItSetGridAplicPedido(ByRef iProp As cIABMProperty) As Boolean
    pItSetGridAplicPedido = pItSetGridAplicAux(iProp, True)
  End Function

'////////////////////////////////////////////////////////////////////////////////////
'
'   GENERICAS
'
'////////////////////////////////////////////////////////////////////////////////////

  Private Function pItLoadItemsAux(ByRef iProp As cIABMProperty, ByVal IsPedido As Boolean) As Boolean
    Dim sqlstmt     As String
    Dim rs          As ADODB.Recordset
    Dim Grid        As cIABMGrid
    Dim Row         As cABMGridRow
    Dim Value       As Double
  
    sqlstmt = "sp_DocPackingListGetAplic " & EmpId & "," & m_PklstId & ",1"
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pItLoadItems", C_Module) Then Exit Function
  
    iProp.Grid.Columns.Clear
    iProp.Grid.Rows.Clear
  
    Set Grid = iProp.Grid
  
    With Grid.Columns
      With .Add(Nothing)
        .Visible = False
        .Key = KII_PKLSTI_ID
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
    
    Dim F  As cIABMGridRow
    Dim fv As cIABMGridCellValue
  
    While Not rs.EOF
  
      Set F = iProp.Grid.Rows.Add(Nothing)
  
      Set fv = F.Add(Nothing)
      fv.ID = gDB.ValField(rs.Fields, cscPklstiId)
      fv.Key = KII_PKLSTI_ID
  
      Set fv = F.Add(Nothing)
      fv.ID = gDB.ValField(rs.Fields, cscPrId)
      fv.Value = gDB.ValField(rs.Fields, cscPrNombreventa)
      fv.Key = KII_PR_ID
  
      Set fv = F.Add(Nothing)
      If IsPedido Then
        fv.Value = gDB.ValField(rs.Fields, cscPklstiPendiente)
      Else
        fv.Value = gDB.ValField(rs.Fields, cscPklstiPendientefac)
      End If
      fv.Key = KII_PENDIENTE
  
      If IsPedido Then
        Value = gDB.ValField(rs.Fields, cscAplicPedido)
      Else
        Value = gDB.ValField(rs.Fields, cscAplicPackingList)
      End If
      
      Set fv = F.Add(Nothing)
      fv.Value = Value
      fv.Key = KII_APLICADO
      
      If Value <> 0 Then
        Set Row = F
        Row.BackColor = &HFFCC99
      End If
      
      Set fv = F.Add(Nothing)
      fv.Value = Value
      fv.Key = KII_APLICADO2
      
      rs.MoveNext
    Wend
  
    pItLoadItemsAux = True
  End Function

  Private Function pItSetGridAplicAux(ByRef iProp As cIABMProperty, ByVal IsPedido As Boolean) As Boolean
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
        .Key = KIP_PVPKLST_ID
      End With
      
      If Not IsPedido Then
        With .Add(Nothing)
          .Visible = False
          .Key = KIFD_FVI_ID
        End With
      End If
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIP_PVI_ID
      End With
      
      If IsPedido Then
        With .Add(Nothing)
          .Visible = False
          .Key = KIP_MFCI_ID
        End With
      End If
      
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
  
  Private Function pItLoadAplicAplicados(ByRef vAplic() As T_Aplic, ByVal IsPedido As Boolean) As Boolean
    Dim sqlstmt       As String
    Dim rs            As ADODB.Recordset
    Dim i             As Long
    Dim Idx           As Long
    
    If IsPedido Then
      sqlstmt = "sp_DocPackingListGetAplic " & EmpId & "," & m_PklstId & ",4"
    Else
      sqlstmt = "sp_DocPackingListGetAplic " & EmpId & "," & m_PklstId & ",2"
    End If
    
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadAplicAplicados", C_Module) Then Exit Function
    
    ReDim vAplic(0)
    ReDim vAplic(0).vAplicaciones(0)
    
    If Not rs.EOF Then
    
      rs.MoveLast
      rs.MoveFirst
    
      While Not rs.EOF
            
        If IsPedido Then
          i = pItAddToCreditos(gDB.ValField(rs.Fields, cscPviId), _
                               gDB.ValField(rs.Fields, cscMfciId), _
                               csNO_ID, csNO_ID, _
                               Idx, vAplic)
        Else
          i = pItAddToCreditos(csNO_ID, csNO_ID, _
                               gDB.ValField(rs.Fields, cscFviId), _
                               gDB.ValField(rs.Fields, cscPklstiId), _
                               Idx, vAplic)
        End If
        
        With vAplic(i)
        
          ' Documento
          '
          .docNombre = gDB.ValField(rs.Fields, cscDocNombre)
          .nroDoc = gDB.ValField(rs.Fields, cscNroDoc)
          .Fecha = gDB.ValField(rs.Fields, cscFecha)
          
          ' Pendiente
          '
          .Pendiente = gDB.ValField(rs.Fields, cscPendiente)
          .PendienteActual = .Pendiente
          
          If IsPedido Then
            ' Pedido
            '
            .pvi_id = gDB.ValField(rs.Fields, cscPviId)
            .mfci_id = gDB.ValField(rs.Fields, cscMfciId)
          
          Else
            ' PackingList
            '
            .pklsti_id = gDB.ValField(rs.Fields, cscPklstdId)
            .fvi_id = gDB.ValField(rs.Fields, cscFviId)
          End If
          
          
          .PR_ID = gDB.ValField(rs.Fields, cscPrId)
          
          ' Aplicaciones
          With .vAplicaciones(Idx)
          
            .vinc_id = gDB.ValField(rs.Fields, cscVincId)
              
            .pklsti_id = gDB.ValField(rs.Fields, cscPklstiId)
            
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
  
  Private Function pItLoadAplicCreditos(ByRef vAplic() As T_Aplic, ByVal IsPedido As Boolean) As Boolean
    Dim sqlstmt       As String
    Dim rs            As ADODB.Recordset
    Dim i             As Long
    
    If IsPedido Then
      sqlstmt = "sp_DocPackingListGetAplic " & EmpId & "," & m_PklstId & ",5"
    Else
      sqlstmt = "sp_DocPackingListGetAplic " & EmpId & "," & m_PklstId & ",3"
    End If
    
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
          
          If IsPedido Then
            
            .pvi_id = gDB.ValField(rs.Fields, cscPviId)
            .mfci_id = gDB.ValField(rs.Fields, cscMfciId)
          
          Else
          
            .pklsti_id = gDB.ValField(rs.Fields, cscPklstdId)
            .fvi_id = gDB.ValField(rs.Fields, cscFviId)
          End If
          
          
  
          .docNombre = gDB.ValField(rs.Fields, cscDocNombre)
          .nroDoc = gDB.ValField(rs.Fields, cscNroDoc)
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
                                    ByVal MfciId As Long, _
                                    ByVal FviId As Long, _
                                    ByVal PklstiId As Long, _
                                    ByRef Idx As Long, _
                                    ByRef vAplic() As T_Aplic) As Long
    Dim i As Long
    
    For i = 1 To UBound(vAplic)
      With vAplic(i)
        If (.pvi_id = PviId And PviId <> csNO_ID) Or _
           (.mfci_id = MfciId And MfciId <> csNO_ID) Or _
           (.fvi_id = FviId And FviId <> csNO_ID) Or _
           (.pklsti_id = PklstiId And PklstiId <> csNO_ID) Then
           
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
  
  Private Function pItUpdateGrids(ByVal IsPedido As Boolean, ByRef vAplic() As T_Aplic) As Double
    Dim iProp         As cIABMProperty
    Dim Row           As cIABMGridRow
    Dim LastRow       As Long
    
    If IsPedido Then
      Set iProp = m_ObjAbm.Properties(c_Items)
      LastRow = m_LastRowItem
    Else
      Set iProp = m_ObjAbm.Properties(c_FacDev)
      LastRow = m_LastRowFacDev
    End If
    
    If LastRow <> 0 Then
      
      Set Row = iProp.Grid.Rows(LastRow)
      pItUpdateGrids = pItUpdateAplicItems(pCell(Row, KII_PKLSTI_ID).ID, _
                                           vAplic, _
                                           IsPedido)
    End If
  End Function
  
  Private Function pItSetAplicItems(ByRef iProp As cIABMProperty, _
                                    ByVal pklsti_id As Long, _
                                    ByVal PR_ID As Long, _
                                    ByRef vAplic() As T_Aplic, _
                                    ByVal IsPedido As Boolean) As Boolean
    Dim Cotizacion    As Double
    Dim i             As Long
    Dim j             As Long
    
    iProp.Grid.Rows.Clear
    
    m_pklsti_id = pklsti_id
    
    For i = 1 To UBound(vAplic)
    
      If vAplic(i).PR_ID = PR_ID Then
    
        If UBound(vAplic(i).vAplicaciones) > 0 Then
          pItSetAplicItemsAux1 i, iProp, pklsti_id, vAplic, IsPedido
        Else
          pItSetAplicItemsAux2 i, iProp, vAplic, IsPedido
        End If
      End If
      
    Next
    
    ' Ahora los creditos que tienen aplicaciones
    ' pero no estan con este item y tienen pendiente
    Dim ID      As Long
    Dim bAplic  As Boolean
    Dim Row     As cIABMGridRow
    
    For i = 1 To UBound(vAplic)
    
      bAplic = False
      
      If vAplic(i).PR_ID = PR_ID Then
      
        For Each Row In iProp.Grid.Rows
        
          If IsPedido Then
            ID = pCell(Row, KIP_PVI_ID).ID
            If ID = vAplic(i).pvi_id And ID <> csNO_ID Then
              bAplic = True
              Exit For
            End If
            ID = pCell(Row, KIP_MFCI_ID).ID
            If ID = vAplic(i).mfci_id And ID <> csNO_ID Then
              bAplic = True
              Exit For
            End If
          Else
            ID = pCell(Row, KIFD_FVI_ID).ID
            If ID = vAplic(i).fvi_id And ID <> csNO_ID Then
              bAplic = True
              Exit For
            End If
          
            ID = pCell(Row, KIFD_PKLSTI_ID).ID
            If ID = vAplic(i).pklsti_id And ID <> csNO_ID Then
              bAplic = True
              Exit For
            End If
          End If
        
          ID = m_pklsti_id
          For j = 1 To UBound(vAplic(i).vAplicaciones)
            If ID = vAplic(i).vAplicaciones(j).pklsti_id And ID <> csNO_ID Then
              bAplic = True
              Exit For
            End If
          Next
        
          If bAplic Then Exit For
        Next
    
        If Not bAplic Then pItSetAplicItemsAux2 i, iProp, vAplic, IsPedido
      End If
    Next
    
    pItSetAplicItems = True
  End Function
  
  Private Function pItUpdateAplicItems(ByVal pklsti_id As Long, _
                                       ByRef vAplic() As T_Aplic, _
                                       ByVal IsPedido As Boolean) As Double
    Dim Cotizacion    As Double
    Dim i             As Long
    Dim j             As Long
    Dim Row           As cIABMGridRow
    Dim Aplicado      As Double
    Dim AplicadoTotal As Double
    
    For Each Row In pItGetItemsAplic(IsPedido).Rows
    
      If Val(pCell(Row, KIP_APLICADO).Value) > 0 Or pCell(Row, KIP_IDX2).ID <> 0 Then
    
        i = pCell(Row, KIP_IDX1).ID
        j = pCell(Row, KIP_IDX2).ID
        
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
  
  Private Sub pItSetAplicItemsAux1(ByVal Idx As Long, ByRef iProp As cIABMProperty, ByVal pklsti_id As Long, _
                                   ByRef vAplic() As T_Aplic, ByVal IsPedido As Boolean)
    Dim F               As cIABMGridRow
    Dim fv              As cIABMGridCellValue
    Dim i               As Long
    Dim iPropItem       As cIABMProperty
    Dim Row             As cABMGridRow
    
    For i = 1 To UBound(vAplic(Idx).vAplicaciones)
    
      With vAplic(Idx).vAplicaciones(i)
    
        If .pklsti_id = pklsti_id And pklsti_id <> csNO_ID Then
        
          Set F = iProp.Grid.Rows.Add(Nothing)
          
          Set fv = F.Add(Nothing)
          fv.ID = Idx
          fv.Key = KIP_IDX1
          
          Set fv = F.Add(Nothing)
          fv.ID = i
          fv.Key = KIP_IDX2
          
          Set fv = F.Add(Nothing)
          fv.ID = .vinc_id
          fv.Key = KIP_PVPKLST_ID
          
          Set fv = F.Add(Nothing)
          
          If IsPedido Then
            
            fv.Key = KIP_PVI_ID
            fv.ID = vAplic(Idx).pvi_id
            
            Set fv = F.Add(Nothing)
            fv.ID = vAplic(Idx).mfci_id
            fv.Key = KIP_MFCI_ID
            
          Else
            
            fv.Key = KIFD_PKLSTI_ID
            fv.ID = vAplic(Idx).pklsti_id
            
            Set fv = F.Add(Nothing)
            fv.ID = vAplic(Idx).fvi_id
            fv.Key = KIFD_FVI_ID
          End If
          
          Set fv = F.Add(Nothing)
          fv.Value = vAplic(Idx).docNombre
          fv.Key = KIP_DOC
          
          Set fv = F.Add(Nothing)
          fv.Value = vAplic(Idx).nroDoc
          fv.Key = KIP_NRODOC
          
          Set fv = F.Add(Nothing)
          If vAplic(Idx).Fecha = csNoDate Then
            fv.Value = ""
          Else
            fv.Value = vAplic(Idx).Fecha
          End If
          fv.Key = KIP_FECHA
      
          Set fv = F.Add(Nothing)
          fv.Value = vAplic(Idx).Pendiente
          fv.Key = KIP_PENDIENTE
          
          Set fv = F.Add(Nothing)
          fv.Value = .Aplicado
          fv.Key = KIP_APLICADO
          
          Set fv = F.Add(Nothing)
          fv.Value = .Aplicado
          fv.Key = KIP_APLICADO2
          
          Set Row = F
          Row.BackColor = &HFFCC99
        End If
      End With
    Next
  End Sub

  Private Sub pItSetAplicItemsAux2(ByVal i As Long, ByRef iProp As cIABMProperty, _
                                   ByRef vAplic() As T_Aplic, ByVal IsPedido As Boolean)
    Dim F             As cIABMGridRow
    Dim fv            As cIABMGridCellValue
    
    If vAplic(i).Pendiente <= 0 Then Exit Sub
    
    With vAplic(i)
  
      Set F = iProp.Grid.Rows.Add(Nothing)
      
      Set fv = F.Add(Nothing)
      fv.ID = i
      fv.Key = KIP_IDX1
      
      Set fv = F.Add(Nothing)
      fv.ID = 0
      fv.Key = KIP_IDX2
      
      Set fv = F.Add(Nothing)
      fv.ID = csNO_ID
      fv.Key = KIP_PVPKLST_ID
      
      Set fv = F.Add(Nothing)
      
      If IsPedido Then
        
        fv.Key = KIP_PVI_ID
        fv.ID = .pvi_id
        
        Set fv = F.Add(Nothing)
        fv.ID = .mfci_id
        fv.Key = KIP_MFCI_ID
        
      Else
        
        fv.Key = KIFD_PKLSTI_ID
        fv.ID = .pklsti_id
        
        Set fv = F.Add(Nothing)
        fv.ID = .fvi_id
        fv.Key = KIFD_FVI_ID
      End If
      
      Set fv = F.Add(Nothing)
      fv.Value = .docNombre
      fv.Key = KIP_DOC
      
      Set fv = F.Add(Nothing)
      fv.Value = .nroDoc
      fv.Key = KIP_NRODOC
      
      Set fv = F.Add(Nothing)
      If .Fecha = csNoDate Then
        fv.Value = ""
      Else
        fv.Value = .Fecha
      End If
      fv.Key = KIP_FECHA
  
      Set fv = F.Add(Nothing)
      fv.Value = .Pendiente
      fv.Key = KIP_PENDIENTE
      
      Set fv = F.Add(Nothing)
      fv.Value = 0
      fv.Key = KIP_APLICADO
      
      Set fv = F.Add(Nothing)
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
        .pklsti_id = m_pklsti_id
      End With
    End If
    
    vAplicaciones(Idx).Aplicado = Importe
    
    For i = 1 To UBound(vAplicaciones)
      rtn = rtn + vAplicaciones(i).Aplicado
    Next
    
    pItAddToAplic = rtn
  End Function

  Private Function pItGetItemsProperty(ByVal IsPedido As Boolean) As cIABMProperty
    If IsPedido Then
      Set pItGetItemsProperty = m_ObjAbm.Properties(c_AplicPedido)
    Else
      Set pItGetItemsProperty = m_ObjAbm.Properties(c_AplicFacDev)
    End If
  End Function
  
  Private Function pItGetItemsAplic(ByVal IsPedido As Boolean) As cIABMGrid
    If IsPedido Then
      Set pItGetItemsAplic = m_ObjAbm.Properties(c_AplicPedido).Grid
    Else
      Set pItGetItemsAplic = m_ObjAbm.Properties(c_AplicFacDev).Grid
    End If
  End Function

  'Private Function pItGetItemsFacDevProperty() As cIABMProperty
  '  Set pItGetItemsFacDevProperty = m_ObjAbm.Properties(c_AplicFacDev)
  'End Function

  Private Function pItColBEdit(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
    Select Case pGetKeyFromCol(IProperty.Grid.Columns, lCol)
      Case KIP_APLICADO
      Case Else
        Exit Function
    End Select
    
    pItColBEdit = True
  End Function

  Private Function pItGetItemPendiente(ByVal IsPedido As Boolean) As cIABMGridCellValue
    Dim iProp As cIABMProperty
    If IsPedido Then
      Set iProp = m_ObjAbm.Properties(c_Items)
    Else
      Set iProp = m_ObjAbm.Properties(c_FacDev)
    End If
    Set pItGetItemPendiente = pCell(iProp.Grid.Rows(iProp.SelectedIndex), KII_PENDIENTE)
  End Function
  
  Private Function pItGetItemAplicado(ByVal IsPedido As Boolean) As cIABMGridCellValue
    Dim iProp As cIABMProperty
    If IsPedido Then
      Set iProp = m_ObjAbm.Properties(c_Items)
    Else
      Set iProp = m_ObjAbm.Properties(c_FacDev)
    End If
    Set pItGetItemAplicado = pCell(iProp.Grid.Rows(iProp.SelectedIndex), KII_APLICADO2)
  End Function
  
  Private Function pItColAUpdate(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal IsPedido As Boolean)
    Dim Row        As cIABMGridRow
    Dim MaxVal     As Double
    Dim bVisible   As Boolean
    Dim Pendiente  As Double
    
    With IProperty.Grid
      Select Case .Columns(lCol).Key
        Case KIP_APLICADO
          Set Row = .Rows(lRow)
          
          With pCell(Row, KIP_APLICADO)
            
            Pendiente = Val(pItGetItemPendiente(IsPedido).Value) + Val(pCell(Row, KIP_APLICADO2).Value)
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
            Aplicado = pItGetAplicado(IsPedido)
            pItRefreshItem Aplicado, IsPedido
            pItGetItemAplicado(IsPedido).Value = Aplicado
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
  
  Private Function pItGetAplicado(ByVal IsPedido As Boolean) As Double
    Dim Row       As cIABMGridRow
    Dim rtn       As Double
    Dim iProp     As cIABMProperty
    
    If IsPedido Then
      Set iProp = m_ObjAbm.Properties(c_AplicPedido)
    Else
      Set iProp = m_ObjAbm.Properties(c_AplicFacDev)
    End If
    
    For Each Row In iProp.Grid.Rows
      rtn = rtn + Val(pCell(Row, KIP_APLICADO).Value)
    Next
    pItGetAplicado = rtn
  End Function
  
  Private Sub pItRefreshItem(ByVal Aplicado As Double, ByVal IsPedido As Boolean)
    Dim iProp     As cIABMProperty
    Dim AbmObj    As cABMGeneric
    Dim Row       As cIABMGridRow
    Dim AplicadoActual  As Double
    Dim LastRow   As Long
    
    Set AbmObj = m_ObjAbm
    
    If IsPedido Then
      Set iProp = m_ObjAbm.Properties(c_Items)
      LastRow = m_LastRowItem
    Else
      Set iProp = m_ObjAbm.Properties(c_FacDev)
      LastRow = m_LastRowFacDev
    End If
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
  
  Private Function pItSaveManifiesto(ByVal PklstTMPId As Long, ByRef vAplic() As T_Aplic) As Boolean
    Dim register    As cRegister
    Dim i           As Long
    Dim j           As Long
    
    For i = 1 To UBound(vAplic)
   
      If vAplic(i).mfci_id <> csNO_ID Then
   
        For j = 1 To UBound(vAplic(i).vAplicaciones)
        
          If vAplic(i).vAplicaciones(j).pklsti_id <> csNO_ID Then
        
            With vAplic(i).vAplicaciones(j)
              
              If .Aplicado > 0 Then
          
                Set register = New cRegister
                register.fieldId = cscMfcPklstTMPId
                register.Table = csTManifiestoPackingListTMP
                register.ID = csNew
                
                register.Fields.Add2 cscPklstTMPId, PklstTMPId, csId
                register.Fields.Add2 cscMfciId, vAplic(i).mfci_id, csId
                register.Fields.Add2 cscPklstiId, .pklsti_id, csId
                register.Fields.Add2 cscMfcPklstCantidad, .Aplicado, csDouble
                
                register.Fields.Add2 cscMfcPklstId, .vinc_id, csLong
                
                register.Fields.HaveLastUpdate = False
                register.Fields.HaveWhoModify = False
                
                If Not gDB.Save(register, , "pItSaveManifiesto", C_Module, c_ErrorSave) Then Exit Function
              End If
            End With
          End If
        Next
      End If
    Next
    
    pItSaveManifiesto = True
  End Function
  
  Private Function pItSavePedido(ByVal PklstTMPId As Long, ByRef vAplic() As T_Aplic) As Boolean
    Dim register    As cRegister
    Dim i           As Long
    Dim j           As Long
    
    For i = 1 To UBound(vAplic)
   
      If vAplic(i).pvi_id <> csNO_ID Then
   
        For j = 1 To UBound(vAplic(i).vAplicaciones)
        
          If vAplic(i).vAplicaciones(j).pklsti_id <> csNO_ID Then
        
            With vAplic(i).vAplicaciones(j)
              
              If .Aplicado > 0 Then
          
                Set register = New cRegister
                register.fieldId = cscPvPklstTMPId
                register.Table = csTPedidoPackingListTMP
                register.ID = csNew
                
                register.Fields.Add2 cscPklstTMPId, PklstTMPId, csId
                register.Fields.Add2 cscPviId, vAplic(i).pvi_id, csId
                register.Fields.Add2 cscPklstiId, .pklsti_id, csId
                register.Fields.Add2 cscPvPklstCantidad, .Aplicado, csDouble
                
                register.Fields.Add2 cscPvPklstId, .vinc_id, csLong
                
                register.Fields.HaveLastUpdate = False
                register.Fields.HaveWhoModify = False
                
                If Not gDB.Save(register, , "pItSavePedido", C_Module, c_ErrorSave) Then Exit Function
              End If
            End With
          End If
        Next
      End If
    Next
    
    pItSavePedido = True
  End Function
  
'////////////////////////////////////////////////////////////////////////////////////
'
'   construccion - destruccion
'
'////////////////////////////////////////////////////////////////////////////////////
Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(2521, vbNullString)
                ' Error al grabar los parámetros de navegación de Packing List
  
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  ReDim m_vPedidos(0)
  ReDim m_vPedidos(0).vAplicaciones(0)
  
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
  ReDim m_vPedidos(0)
  
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
'   PEDIDOS / PACKING LIST
'
'////////////////////////////////////////////////////////////////////////////////////

  Private Function pItLoadFacDev(ByRef iProp As cIABMProperty) As Boolean
    pItLoadFacDev = pItLoadItemsAux(iProp, False)
  End Function
  
  Private Function pItSetGridAplicFacDev(ByRef iProp As cIABMProperty) As Boolean
    pItSetGridAplicFacDev = pItSetGridAplicAux(iProp, False)
  End Function

  Private Function pItSaveFacDev(ByVal PklstTMPId As Long, ByRef vAplic() As T_Aplic) As Boolean
    Dim register    As cRegister
    Dim i           As Long
    Dim j           As Long
    
    For i = 1 To UBound(vAplic)
   
      If vAplic(i).fvi_id <> csNO_ID Or vAplic(i).pklsti_id <> csNO_ID Then
   
        For j = 1 To UBound(vAplic(i).vAplicaciones)
        
          If vAplic(i).vAplicaciones(j).pklsti_id <> csNO_ID Then
        
            With vAplic(i).vAplicaciones(j)
              
              If .Aplicado > 0 Then
          
                Set register = New cRegister
                
                ' Si estoy vinculando contra una factura
                If vAplic(i).fvi_id <> 0 Then
                  register.fieldId = cscPklstFvTMPId
                  register.Table = csTPackingListFacturaVentaTMP
                  register.Fields.Add2 cscFviId, vAplic(i).fvi_id, csId
                  register.Fields.Add2 cscPklstiId, .pklsti_id, csId
                
                  register.Fields.Add2 cscPklstFvCantidad, .Aplicado, csDouble
                  register.Fields.Add2 cscPklstFvId, .vinc_id, csLong
                
                ' Si vinculo contra un packing list (PackingList - Devolucion)
                Else
                  register.fieldId = cscPklstDvTMPId
                  register.Table = csTPackingListDevolucionTMP
                  
                  If m_IsDevolucion Then
                    register.Fields.Add2 cscPklstiIdDevolucion, .pklsti_id, csId
                    register.Fields.Add2 cscPklstiIdPklst, vAplic(i).pklsti_id, csId
                  Else
                    register.Fields.Add2 cscPklstiIdPklst, .pklsti_id, csId
                    register.Fields.Add2 cscPklstiIdDevolucion, vAplic(i).pklsti_id, csId
                  End If
                
                  register.Fields.Add2 cscPklstDvCantidad, .Aplicado, csDouble
                  register.Fields.Add2 cscPklstDvId, .vinc_id, csLong
                
                End If
                
                register.ID = csNew
                register.Fields.Add2 cscPklstTMPId, PklstTMPId, csId
                
                register.Fields.HaveLastUpdate = False
                register.Fields.HaveWhoModify = False
                
                If Not gDB.Save(register, , "pItSaveFacDev ", C_Module, c_ErrorSave) Then Exit Function
              End If
            End With
          End If
        Next
      End If
    Next
    
    pItSaveFacDev = True
  End Function
