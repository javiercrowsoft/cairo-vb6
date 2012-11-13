VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPedidoVentaAplic"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cPedidoVentaAplic
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
Private Const C_Module = "cPedidoVentaAplic"

Private Enum c_TypeApply
  cE_Presupuesto = 1
  cE_Packing = 2
  cE_FacDev = 3
End Enum

'////////////////////////////////////////////////////////////////////////////////////
'
'   PRESTACIONES
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private Const cscNroDoc                          As String = "nrodoc"
  Private Const cscPendiente                       As String = "Pendiente"
  Private Const cscImporte                         As String = "Importe"
  Private Const cscVincId                          As String = "vinc_id"
  Private Const cscPvdId                           As String = "pvd_id"
'////////////////////////////////////////////////////////////////////////////////////
'
'   REMITO - SOLAPA
'
'////////////////////////////////////////////////////////////////////////////////////
  
  ' Remito
  Private Const K_PRESUPUESTO = 10
  Private Const K_APLIC_PRESU = 11
  
  Private Const c_Presu = "Presu"
  Private Const c_AplicPresu = "AplicPresu"
  
  Private Const K_PACKING = 12
  Private Const K_APLIC_PACKING = 13
  
  Private Const c_Items = "Items"
  Private Const c_AplicPacking = "AplicPacking"

  Private Const cscFecha            As String = "Fecha"
  Private Const cscAplicado         As String = "Aplicado"
  Private Const cscAplicPresu       As String = "AplicPresu"
  Private Const cscAplicPacking     As String = "AplicPacking"
  Private Const cscAplicRemito      As String = "AplicRemito"
  
  ' Grillas de Remitos / Pedidos
  Private Const KII_PVI_ID                  As Integer = 1
  Private Const KII_PR_ID                   As Integer = 2
  Private Const KII_APLICADO                As Integer = 4
  Private Const KII_APLICADO2               As Integer = 5
  Private Const KII_PENDIENTE               As Integer = 6
  
  Private Const KIP_PVRV_ID                 As Integer = 1
  
  Private Const KIFD_FVI_ID                 As Integer = 2
  Private Const KIFD_RVI_ID                 As Integer = 3
  
  ' Estos dos tienen el mismo valor a proposito
  Private Const KIP_PKI_ID                  As Integer = 4
  Private Const KIP_PRVI_ID                 As Integer = KIP_PKI_ID
  Private Const KIFD_PVI_ID                 As Integer = KIP_PKI_ID
  
  
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
  
  ' Remito
  
  Private Const K_FAC_DEV = 20
  Private Const K_APLIC_FAC_DEV = 21
  Private Const c_FacDev = "FacDev"
  Private Const c_AplicFacDev = "AplicFacDev"

' estructuras

'////////////////////////////////////////////////////////////////////////////////////
'
'   REMITOS / REMITOS
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private Type T_ItAplic
    vinc_id                 As Long   ' lo uso para pvrv_id, pvfv_id y pvdv_id y pvpklst_id
    pvi_id                  As Long   ' Ids de items al que este credito esta vinculado
    
    Aplicado                As Double
  End Type
  
  Private Type T_Aplic
                                    ' Vinculacion con
                                    
    pki_id                  As Long ' Packing list
    prvi_id                 As Long ' Presupuesto
    
    rvi_id                  As Long ' Remito
    fvi_id                  As Long ' Factura
    pvi_id                  As Long ' Cancelacion de pedido
    
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

' pseudo-constantes
Private c_ErrorSave As String

' variables privadas

' generales

Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric
Private m_GeneralConfig     As cGeneralConfig
Private m_PvId              As Long
Private m_IsDevolucion      As Boolean
Private m_PvNumero          As String
Private m_Cliente           As String
Private m_CliId             As Long
Private m_DocId             As Long
Private m_SucId             As Long
Private m_Total             As Double

Private m_MonDefault        As Long

Private m_LastRowPresu      As Long
Private m_LastRowItem       As Long
Private m_LastRowFacDev     As Long

' Edit Apply
'
Private m_ObjectClient      As cPedidoVenta
Private m_emp_id            As Long
Private m_emp_nombre        As String

'////////////////////////////////////////////////////////////////////////////////////
'
'   REMITOS / REMITOS
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private m_vPresupuesto()    As T_Aplic
  Private m_vPacking()        As T_Aplic
  Private m_vFacDevs()        As T_Aplic
  Private m_pvi_id            As Long

' eventos
' propiedades publicas

' Edit Apply
'
Public Property Set ObjectClient(ByVal rhs As cPedidoVenta)
  Set m_ObjectClient = rhs
End Property

Public Property Get Id() As Long
  Id = m_PvId
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Show(ByVal PvId As Long, ByVal Total As Double, _
                     ByVal PvNumero As String, _
                     ByVal CliId As Long, ByVal Cliente As String, _
                     ByVal SucId As Long, ByVal DocId As Long, _
                     ByVal IsDevolucion As Boolean) As Boolean
  
  If m_ObjAbm Is Nothing Then
    Set m_ObjAbm = New cABMGeneric
  End If
  
  If m_PvId <> PvId Then
    m_IsDevolucion = IsDevolucion
    m_PvId = PvId
    m_PvNumero = PvNumero
    m_Cliente = Cliente
    m_CliId = CliId
    m_DocId = DocId
    m_SucId = SucId
    m_Total = Total
    
    ' Edit Apply
    '
    If Not gDB.GetData(csTPedidoVenta, _
                       cscPvId, _
                       m_PvId, _
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
          
          Case K_PRESUPUESTO
          
            Set AbmObj = m_ObjAbm
            
            ' Guardo la aplicacion para el item editado anteriormente
            '
            If m_LastRowPresu <> 0 Then
              Aplicado = pItUpdateGrids(cE_Presupuesto, m_vPresupuesto)
            End If
            
            ' Muestro las aplicaciones para este item
            '
            m_LastRowPresu = iProp.SelectedIndex
            Set Row = iProp.Grid.Rows(m_LastRowPresu)
            If Row Is Nothing Then Exit Function
            
            pItSetAplicItems m_ObjAbm.Properties(c_AplicPresu), _
                             pCell(Row, KII_PVI_ID).Id, _
                             pCell(Row, KII_PR_ID).Id, m_vPresupuesto, cE_Presupuesto
            
            AbmObj.ShowValue m_ObjAbm.Properties(c_AplicPresu), True

          Case K_PACKING
          
            Set AbmObj = m_ObjAbm
            
            ' Guardo la aplicacion para el item editado anteriormente
            '
            If m_LastRowItem <> 0 Then
              Aplicado = pItUpdateGrids(cE_Packing, m_vPacking)
            End If
            
            ' Muestro las aplicaciones para este item
            '
            m_LastRowItem = iProp.SelectedIndex
            Set Row = iProp.Grid.Rows(m_LastRowItem)
            If Row Is Nothing Then Exit Function
            
            pItSetAplicItems m_ObjAbm.Properties(c_AplicPacking), _
                             pCell(Row, KII_PVI_ID).Id, _
                             pCell(Row, KII_PR_ID).Id, m_vPacking, cE_Packing
            
            AbmObj.ShowValue m_ObjAbm.Properties(c_AplicPacking), True
          
          Case K_FAC_DEV
          
            Set AbmObj = m_ObjAbm
            
            ' Guardo la aplicacion para el item editado anteriormente
            '
            If m_LastRowFacDev <> 0 Then
              Aplicado = pItUpdateGrids(cE_FacDev, m_vFacDevs)
            End If
            
            ' Muestro las aplicaciones para este item
            '
            m_LastRowFacDev = iProp.SelectedIndex
            Set Row = iProp.Grid.Rows(m_LastRowFacDev)
            If Row Is Nothing Then Exit Function
            
            pItSetAplicItems m_ObjAbm.Properties(c_AplicFacDev), _
                             pCell(Row, KII_PVI_ID).Id, _
                             pCell(Row, KII_PR_ID).Id, m_vFacDevs, cE_FacDev
            
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
    m_PvId = csNO_ID
    Set m_ObjAbm = Nothing
    
    ' Edit Apply
    '
    Set m_ObjectClient = Nothing
  End Function
  
  Private Property Get cIABMClient_Title() As String
    On Error Resume Next
    cIABMClient_Title = LNGGetText(1600, vbNullString)  'Aplicación pedido de venta
    m_ObjAbm.Title2 = m_PvNumero & " - " & m_Cliente
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
      Case K_APLIC_PRESU
        cIABMClientGrid_ColumnAfterUpdate = pItColAUpdate(pItGetItemsProperty(cE_Presupuesto), lRow, lCol, cE_Presupuesto)
      Case K_APLIC_PACKING
        cIABMClientGrid_ColumnAfterUpdate = pItColAUpdate(pItGetItemsProperty(cE_Packing), lRow, lCol, cE_Packing)
      Case K_APLIC_FAC_DEV
        cIABMClientGrid_ColumnAfterUpdate = pItColAUpdate(pItGetItemsProperty(cE_FacDev), lRow, lCol, cE_FacDev)
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
      Case K_APLIC_PRESU
        cIABMClientGrid_ColumnBeforeEdit = pItColBEdit(pItGetItemsProperty(cE_Presupuesto), lRow, lCol, iKeyAscii)
      Case K_APLIC_PACKING
        cIABMClientGrid_ColumnBeforeEdit = pItColBEdit(pItGetItemsProperty(cE_Packing), lRow, lCol, iKeyAscii)
      Case K_APLIC_FAC_DEV
        cIABMClientGrid_ColumnBeforeEdit = pItColBEdit(pItGetItemsProperty(cE_FacDev), lRow, lCol, iKeyAscii)
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

      Case K_APLIC_PRESU
        
        With pItGetItemsAplic(cE_Presupuesto).Rows
          
          Id = pCell(.Item(lRow), KIP_PRVI_ID).Id
          
          If Id <> csNO_ID Then
            
            If Not gDB.GetData("PresupuestoVentaItem", _
                               "prvi_id", _
                               Id, _
                               "prv_id", _
                               Id) Then Exit Sub
            
            If Id <> csNO_ID Then
            
              ShowDocAux Id, _
                         "CSVenta2.cPresupuestoVenta", _
                         "CSABMInterface2.cABMGeneric"
            End If
          End If
          
        End With

      Case K_APLIC_PACKING
        
        With pItGetItemsAplic(cE_Packing).Rows
          
          Id = pCell(.Item(lRow), KIP_PKI_ID).Id
          
          If Id <> csNO_ID Then
            
            If Not gDB.GetData("PackingListItem", _
                               "pklsti_id", _
                               Id, _
                               "pklst_id", _
                               Id) Then Exit Sub
            
            If Id <> csNO_ID Then
            
              ShowDocAux Id, _
                         "CSExport2.cPackingList", _
                         "CSABMInterface2.cABMGeneric"
            End If
          End If
          
        End With
        
      Case K_APLIC_FAC_DEV

        With pItGetItemsAplic(cE_FacDev).Rows
          
          Dim ObjEditName As String
                    
          Id = pCell(.Item(lRow), KIFD_RVI_ID).Id
          
          If Id <> csNO_ID Then
            
            If Not gDB.GetData("RemitoVentaItem", _
                               "rvi_id", _
                               Id, _
                               "rv_id", _
                               Id) Then Exit Sub
            
            ObjEditName = "CSVenta2.cRemitoVenta"
            
          Else
          
            Id = pCell(.Item(lRow), KIFD_FVI_ID).Id
            
            If Id <> csNO_ID Then
              If Not gDB.GetData("FacturaVentaItem", _
                                 "fvi_id", _
                                 Id, _
                                 "fv_id", _
                                 Id) Then Exit Sub
              
              ObjEditName = "CSVenta2.cFacturaVenta"
            
            Else
            
              Id = pCell(.Item(lRow), KIFD_PVI_ID).Id
              
              If Id <> csNO_ID Then
                If Not gDB.GetData("PedidoVentaItem", _
                                   "pvi_id", _
                                   Id, _
                                   "pv_id", _
                                   Id) Then Exit Sub
                
                ObjEditName = "CSPedidoVenta2.cPedidoVenta"
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
    Dim oGrd    As cABMGrid
  
    m_LastRowItem = 0
    m_LastRowFacDev = 0
    m_LastRowPresu = 0
    
    m_ObjAbm.Properties.Clear
    With m_ObjAbm.Tabs
    
      .Clear
    
      With .Add(Nothing)
       .Name = LNGGetText(1601, vbNullString)   'Presupuestos
      End With
      
      With .Add(Nothing)
       .Index = 1
       .Name = LNGGetText(1602, vbNullString)   'Packing List
      End With
      
      With .Add(Nothing)
       .Index = 2
       .Name = LNGGetText(1603, vbNullString)   'Remitos/Facturas
      End With
      
    End With
   
    Set c = m_ObjAbm.Properties.Add(Nothing, c_Presu)
    c.PropertyType = cspGrid
    c.LeftLabel = -1
    If Not pItLoadPresupuesto(c) Then Exit Function
    c.Key = K_PRESUPUESTO
    c.Name = "Items1"
    c.Width = 9400
    c.Left = 250
    c.Height = 2600
    c.GridEdit = False
    c.GridAdd = False
    c.GridRemove = False
    Set oGrd = c.Grid
    oGrd.RowSelect = True
    oGrd.DontSelectInGotFocus = True
   
    Set c = m_ObjAbm.Properties.Add(Nothing, c_AplicPresu)
    c.PropertyType = cspGrid
    c.LeftLabel = -1
    If Not pItSetGridAplicPresupuesto(c) Then Exit Function
    c.Key = K_APLIC_PRESU
    c.Name = "Presupuestos"
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
    
    Set c = m_ObjAbm.Properties.Add(Nothing, c_Items)
    c.PropertyType = cspGrid
    c.LeftLabel = -1
    If Not pItLoadItems(c) Then Exit Function
    c.Key = K_PACKING
    c.Name = "Items"
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
  
    Set c = m_ObjAbm.Properties.Add(Nothing, c_AplicPacking)
    c.PropertyType = cspGrid
    c.LeftLabel = -1
    If Not pItSetGridAplicPacking(c) Then Exit Function
    c.Key = K_APLIC_PACKING
    c.Name = "Packing"
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
    
    Set c = m_ObjAbm.Properties.Add(Nothing, c_FacDev)
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
    c.TabIndex = 2
    Set oGrd = c.Grid
    oGrd.RowSelect = True
    oGrd.DontSelectInGotFocus = True
  
    Set c = m_ObjAbm.Properties.Add(Nothing, c_AplicFacDev)
    c.PropertyType = cspGrid
    c.LeftLabel = -1
    If Not pItSetGridAplicFacDev(c) Then Exit Function
    c.Key = K_APLIC_FAC_DEV
    c.Name = "Facturas"
    c.Width = 9400
    c.Left = 250
    c.Top = 4200
    c.Height = 2000
    c.GridEdit = True
    c.GridAdd = False
    c.GridRemove = False
    c.TabIndex = 2
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
    
    Dim pvTMPId As Long
    
    pItUpdateGrids cE_Presupuesto, m_vPresupuesto
    pItUpdateGrids cE_Packing, m_vPacking
    pItUpdateGrids cE_FacDev, m_vFacDevs
    
    ' Temporal
    If Not pSaveDocVta(m_DocId, pvTMPId) Then Exit Function
  
    ' Packing
    If Not pItSavePresupuesto(pvTMPId, m_vPresupuesto) Then Exit Function
  
    ' Packing
    If Not pItSavePacking(pvTMPId, m_vPacking) Then Exit Function
    
    ' Facturas / Devoluciones
    If Not pItSaveFacDev(pvTMPId, m_vFacDevs) Then Exit Function
    
    ' Aplico llamando al sp
    Dim sqlstmt As String
    Dim rs      As Recordset
    
    sqlstmt = "sp_DocPedidoVentaSaveAplic " & pvTMPId
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
  ' PedidoVentaTemporal
  '////////////////////////////////////////////////////////////////////////////////////
  Private Function pSaveDocVta(ByVal DocId As Long, _
                               ByRef pvTMPId As Long) As Boolean
    Dim register     As cRegister
    
    Set register = New cRegister
    register.fieldId = cscPvTMPId
    register.Table = csTPedidoVentaTMP
  
    register.Id = csNew
    register.Fields.Add2 cscPvId, m_PvId, csId
  
    register.Fields.Add2 cscPvNumero, 0, csLong
    register.Fields.Add2 cscPvNrodoc, "", csText
    
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
  
    pvTMPId = register.Id
    pSaveDocVta = True
  End Function

'////////////////////////////////////////////////////////////////////////////////////
'
'   PEDIDOS
'
'////////////////////////////////////////////////////////////////////////////////////

  Private Function pItLoadAplicItems() As Boolean
    
    If Not pItLoadAplicAplicados(m_vPresupuesto, cE_Presupuesto) Then Exit Function
    If Not pItLoadAplicCreditos(m_vPresupuesto, cE_Presupuesto) Then Exit Function
    
    If Not pItLoadAplicAplicados(m_vPacking, cE_Packing) Then Exit Function
    If Not pItLoadAplicCreditos(m_vPacking, cE_Packing) Then Exit Function
    
    If Not pItLoadAplicAplicados(m_vFacDevs, cE_FacDev) Then Exit Function
    If Not pItLoadAplicCreditos(m_vFacDevs, cE_FacDev) Then Exit Function
    
    pItLoadAplicItems = True
  End Function
  
  Private Function pItLoadItems(ByRef iProp As cIABMProperty) As Boolean
    pItLoadItems = pItLoadItemsAux(iProp, cE_Packing)
  End Function

  Private Function pItSetGridAplicPacking(ByRef iProp As cIABMProperty) As Boolean
    pItSetGridAplicPacking = pItSetGridAplicAux(iProp, cE_Packing)
  End Function

'////////////////////////////////////////////////////////////////////////////////////
'
'   GENERICAS
'
'////////////////////////////////////////////////////////////////////////////////////

  Private Function pItLoadItemsAux(ByRef iProp As cIABMProperty, _
                                   ByVal TypeApply As c_TypeApply) As Boolean
    Dim sqlstmt     As String
    Dim rs          As ADODB.Recordset
    Dim Grid        As cIABMGrid
    Dim Row         As cABMGridRow
    Dim Value       As Double
  
    sqlstmt = "sp_DocPedidoVentaGetAplic " & EmpId & "," & m_PvId & ",1"
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pItLoadItems", C_Module) Then Exit Function
  
    iProp.Grid.Columns.Clear
    iProp.Grid.Rows.Clear
  
    Set Grid = iProp.Grid
  
    With Grid.Columns
      With .Add(Nothing)
        .Visible = False
        .Key = KII_PVI_ID
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1619, vbNullString)    'Producto
        .PropertyType = cspText
        .Width = 2500
        .Key = KII_PR_ID
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1609, vbNullString)    'Pendiente
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1245
        .Key = KII_PENDIENTE
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1608, vbNullString)    'Aplicado
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
      fv.Id = gDB.ValField(rs.Fields, cscPviId)
      fv.Key = KII_PVI_ID
  
      Set fv = f.Add(Nothing)
      fv.Id = gDB.ValField(rs.Fields, cscPrId)
      fv.Value = gDB.ValField(rs.Fields, cscPrNombreventa)
      fv.Key = KII_PR_ID
  
      Set fv = f.Add(Nothing)
      Select Case TypeApply
        Case c_TypeApply.cE_Presupuesto
          fv.Value = gDB.ValField(rs.Fields, cscPviPendientePrv)
        Case c_TypeApply.cE_Packing
          fv.Value = gDB.ValField(rs.Fields, cscPviPendientePklst)
        Case c_TypeApply.cE_FacDev
          fv.Value = gDB.ValField(rs.Fields, cscPviPendiente)
      End Select
      fv.Key = KII_PENDIENTE
  
      Select Case TypeApply
        Case c_TypeApply.cE_Presupuesto
          Value = gDB.ValField(rs.Fields, cscAplicPresu)
        Case c_TypeApply.cE_Packing
          Value = gDB.ValField(rs.Fields, cscAplicPacking)
        Case c_TypeApply.cE_FacDev
          Value = gDB.ValField(rs.Fields, cscAplicRemito)
      End Select
      
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

  Private Function pItSetGridAplicAux(ByRef iProp As cIABMProperty, _
                                      ByVal TypeApply As c_TypeApply) As Boolean
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
        .Key = KIP_PVRV_ID
      End With
      
      If TypeApply = cE_FacDev Then
        With .Add(Nothing)
          .Visible = False
          .Key = KIFD_FVI_ID
        End With
        With .Add(Nothing)
          .Visible = False
          .Key = KIFD_RVI_ID
        End With
      End If
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIP_PKI_ID ' KIP_PRVI_ID Valen lo mismo
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1567, vbNullString)    'Documento
        .PropertyType = cspText
        .Width = 2925
        .Key = KIP_DOC
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1610, vbNullString)    'Comprobante
        .PropertyType = cspText
        .Width = 1575
        .Key = KIP_NRODOC
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1569, vbNullString)    'Fecha
        .PropertyType = cspDate
        .Width = 1395
        .Key = KIP_FECHA
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1609, vbNullString)    'Pendiente
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1245
        .Key = KIP_PENDIENTE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1608, vbNullString)    'Aplicado
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
  
  Private Function pItLoadAplicAplicados(ByRef vAplic() As T_Aplic, _
                                         ByVal TypeApply As c_TypeApply) As Boolean
    Dim sqlstmt       As String
    Dim rs            As ADODB.Recordset
    Dim i             As Long
    Dim Idx           As Long
    
    Select Case TypeApply
      Case c_TypeApply.cE_Presupuesto
        sqlstmt = "sp_DocPedidoVentaGetAplic " & EmpId & "," & m_PvId & ",6"
      Case c_TypeApply.cE_Packing
        sqlstmt = "sp_DocPedidoVentaGetAplic " & EmpId & "," & m_PvId & ",4"
      Case c_TypeApply.cE_FacDev
        sqlstmt = "sp_DocPedidoVentaGetAplic " & EmpId & "," & m_PvId & ",2"
    End Select
    
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadAplicAplicados", C_Module) Then Exit Function
    
    ReDim vAplic(0)
    ReDim vAplic(0).vAplicaciones(0)
    
    If Not rs.EOF Then
    
      rs.MoveLast
      rs.MoveFirst
    
      While Not rs.EOF
            
        Select Case TypeApply
        
          Case c_TypeApply.cE_Presupuesto
            i = pItAddToCreditos(csNO_ID, _
                                 csNO_ID, csNO_ID, csNO_ID, _
                                 gDB.ValField(rs.Fields, cscPrviId), _
                                 Idx, vAplic)
          
          Case c_TypeApply.cE_Packing
            i = pItAddToCreditos(gDB.ValField(rs.Fields, cscPklstiId), _
                                 csNO_ID, csNO_ID, csNO_ID, csNO_ID, _
                                 Idx, vAplic)
          
          Case c_TypeApply.cE_FacDev
            i = pItAddToCreditos(csNO_ID, _
                                 gDB.ValField(rs.Fields, cscRviId), _
                                 gDB.ValField(rs.Fields, cscFviId), _
                                 gDB.ValField(rs.Fields, cscPviId), _
                                 csNO_ID, _
                                 Idx, vAplic)
        End Select
        
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
          
          Select Case TypeApply
          
            Case c_TypeApply.cE_Presupuesto
              ' Presupuesto
              '
              .prvi_id = gDB.ValField(rs.Fields, cscPrviId)
            
            Case c_TypeApply.cE_Packing
              ' Packing
              '
              .pki_id = gDB.ValField(rs.Fields, cscPklstiId)
            
            Case c_TypeApply.cE_FacDev
              ' Factura/remito/devolucion
              '
              .pvi_id = gDB.ValField(rs.Fields, cscPvdId)
              .fvi_id = gDB.ValField(rs.Fields, cscFviId)
              .rvi_id = gDB.ValField(rs.Fields, cscRviId)
          End Select
          
          
          .PR_ID = gDB.ValField(rs.Fields, cscPrId)
          
          ' Aplicaciones
          With .vAplicaciones(Idx)
          
            .vinc_id = gDB.ValField(rs.Fields, cscVincId)
              
            .pvi_id = gDB.ValField(rs.Fields, cscPviId)
            
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
  
  Private Function pItLoadAplicCreditos(ByRef vAplic() As T_Aplic, _
                                        ByVal TypeApply As c_TypeApply) As Boolean
    Dim sqlstmt       As String
    Dim rs            As ADODB.Recordset
    Dim i             As Long
    
    Select Case TypeApply
    
      Case c_TypeApply.cE_Presupuesto
        sqlstmt = "sp_DocPedidoVentaGetAplic " & EmpId & "," & m_PvId & ",7"
        
      Case c_TypeApply.cE_Packing
        sqlstmt = "sp_DocPedidoVentaGetAplic " & EmpId & "," & m_PvId & ",5"
        
      Case c_TypeApply.cE_FacDev
        sqlstmt = "sp_DocPedidoVentaGetAplic " & EmpId & "," & m_PvId & ",3"
    
    End Select
    
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
          
          Select Case TypeApply
          
            Case c_TypeApply.cE_Presupuesto
              .prvi_id = gDB.ValField(rs.Fields, cscPrviId)
              
            Case c_TypeApply.cE_Packing
              .pki_id = gDB.ValField(rs.Fields, cscPklstiId)
            
            Case c_TypeApply.cE_FacDev
              .rvi_id = gDB.ValField(rs.Fields, cscRviId)
              .pvi_id = gDB.ValField(rs.Fields, cscPvdId)
              .fvi_id = gDB.ValField(rs.Fields, cscFviId)
              
          End Select
  
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
  
  Private Function pItAddToCreditos(ByVal PkiId As Long, _
                                    ByVal RviId As Long, _
                                    ByVal FviId As Long, _
                                    ByVal PviId As Long, _
                                    ByVal PrviId As Long, _
                                    ByRef Idx As Long, _
                                    ByRef vAplic() As T_Aplic) As Long
    Dim i As Long
    
    For i = 1 To UBound(vAplic)
      With vAplic(i)
        If (.pki_id = PkiId And PkiId <> csNO_ID) Or _
           (.rvi_id = RviId And RviId <> csNO_ID) Or _
           (.fvi_id = FviId And FviId <> csNO_ID) Or _
           (.pvi_id = PviId And PviId <> csNO_ID) Or _
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
  
  Private Function pItUpdateGrids(ByVal TypeApply As c_TypeApply, _
                                  ByRef vAplic() As T_Aplic) As Double
    Dim iProp         As cIABMProperty
    Dim iPropAplic    As cIABMProperty
    Dim Row           As cIABMGridRow
    Dim LastRow       As Long
    
    Select Case TypeApply
      
      Case c_TypeApply.cE_Presupuesto
        Set iProp = m_ObjAbm.Properties(c_Presu)
        Set iPropAplic = m_ObjAbm.Properties(c_AplicPresu)
        LastRow = m_LastRowPresu
      
      Case c_TypeApply.cE_Packing
        Set iProp = m_ObjAbm.Properties(c_Items)
        Set iPropAplic = m_ObjAbm.Properties(c_AplicPacking)
        LastRow = m_LastRowItem
      
      Case c_TypeApply.cE_FacDev
        Set iProp = m_ObjAbm.Properties(c_FacDev)
        Set iPropAplic = m_ObjAbm.Properties(c_AplicFacDev)
        LastRow = m_LastRowFacDev
        
    End Select
    
    If LastRow <> 0 Then
      
      Set Row = iProp.Grid.Rows(LastRow)
      pItUpdateGrids = pItUpdateAplicItems(iPropAplic, _
                                           pCell(Row, KII_PVI_ID).Id, _
                                           vAplic, _
                                           TypeApply)
    End If
  End Function
  
  Private Function pItSetAplicItems(ByRef iProp As cIABMProperty, _
                                    ByVal pvi_id As Long, _
                                    ByVal PR_ID As Long, _
                                    ByRef vAplic() As T_Aplic, _
                                    ByVal TypeApply As c_TypeApply) As Boolean
    Dim Cotizacion    As Double
    Dim i             As Long
    Dim j             As Long
    
    iProp.Grid.Rows.Clear
    
    m_pvi_id = pvi_id
    
    For i = 1 To UBound(vAplic)
    
      If vAplic(i).PR_ID = PR_ID Then
    
        If UBound(vAplic(i).vAplicaciones) > 0 Then
          pItSetAplicItemsAux1 i, iProp, pvi_id, vAplic, TypeApply
        Else
          pItSetAplicItemsAux2 i, iProp, vAplic, TypeApply
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
        
          Select Case TypeApply
          
            Case c_TypeApply.cE_Presupuesto
              Id = pCell(Row, KIP_PRVI_ID).Id
              If Id = vAplic(i).prvi_id And Id <> csNO_ID Then
                bAplic = True
                Exit For
              End If
            
            Case c_TypeApply.cE_Packing
              Id = pCell(Row, KIP_PKI_ID).Id
              If Id = vAplic(i).pki_id And Id <> csNO_ID Then
                bAplic = True
                Exit For
              End If
            
            Case c_TypeApply.cE_FacDev
              Id = pCell(Row, KIFD_FVI_ID).Id
              If Id = vAplic(i).fvi_id And Id <> csNO_ID Then
                bAplic = True
                Exit For
              End If
          
              Id = pCell(Row, KIFD_RVI_ID).Id
              If Id = vAplic(i).rvi_id And Id <> csNO_ID Then
                bAplic = True
                Exit For
              End If
            
              Id = pCell(Row, KIFD_PVI_ID).Id
              If Id = vAplic(i).pvi_id And Id <> csNO_ID Then
                bAplic = True
                Exit For
              End If
          End Select
        
          Id = m_pvi_id
          For j = 1 To UBound(vAplic(i).vAplicaciones)
            If Id = vAplic(i).vAplicaciones(j).pvi_id And Id <> csNO_ID Then
              bAplic = True
              Exit For
            End If
          Next
        
          If bAplic Then Exit For
        Next
    
        If Not bAplic Then pItSetAplicItemsAux2 i, iProp, vAplic, TypeApply
      End If
    Next
    
    pItSetAplicItems = True
  End Function
  
  Private Function pItUpdateAplicItems(ByRef iProp As cIABMProperty, _
                                       ByVal pvi_id As Long, _
                                       ByRef vAplic() As T_Aplic, _
                                       ByVal TypeApply As c_TypeApply) As Double
    Dim Cotizacion    As Double
    Dim i             As Long
    Dim j             As Long
    Dim Row           As cIABMGridRow
    Dim Aplicado      As Double
    Dim AplicadoTotal As Double
    
    For Each Row In pItGetItemsAplic(TypeApply).Rows
    
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
  
  Private Sub pItSetAplicItemsAux1(ByVal Idx As Long, ByRef iProp As cIABMProperty, ByVal pvi_id As Long, _
                                   ByRef vAplic() As T_Aplic, _
                                   ByVal TypeApply As c_TypeApply)
    Dim f               As cIABMGridRow
    Dim fv              As cIABMGridCellValue
    Dim i               As Long
    Dim iPropItem       As cIABMProperty
    Dim Row             As cABMGridRow
    
    For i = 1 To UBound(vAplic(Idx).vAplicaciones)
    
      With vAplic(Idx).vAplicaciones(i)
    
        If .pvi_id = pvi_id And pvi_id <> csNO_ID Then
        
          Set f = iProp.Grid.Rows.Add(Nothing)
          
          Set fv = f.Add(Nothing)
          fv.Id = Idx
          fv.Key = KIP_IDX1
          
          Set fv = f.Add(Nothing)
          fv.Id = i
          fv.Key = KIP_IDX2
          
          Set fv = f.Add(Nothing)
          fv.Id = .vinc_id
          fv.Key = KIP_PVRV_ID
          
          Set fv = f.Add(Nothing)
          
          Select Case TypeApply
          
            Case c_TypeApply.cE_Presupuesto
              fv.Key = KIP_PRVI_ID
              fv.Id = vAplic(Idx).prvi_id
            
            Case c_TypeApply.cE_Packing
              fv.Key = KIP_PKI_ID
              fv.Id = vAplic(Idx).pki_id
              
            Case c_TypeApply.cE_FacDev
              
              fv.Key = KIFD_PVI_ID
              fv.Id = vAplic(Idx).pvi_id
              
              Set fv = f.Add(Nothing)
              fv.Id = vAplic(Idx).fvi_id
              fv.Key = KIFD_FVI_ID
            
              Set fv = f.Add(Nothing)
              fv.Id = vAplic(Idx).rvi_id
              fv.Key = KIFD_RVI_ID
          End Select
          
          Set fv = f.Add(Nothing)
          fv.Value = vAplic(Idx).docNombre
          fv.Key = KIP_DOC
          
          Set fv = f.Add(Nothing)
          fv.Value = vAplic(Idx).nroDoc
          fv.Key = KIP_NRODOC
          
          Set fv = f.Add(Nothing)
          If vAplic(Idx).Fecha = csNoDate Then
            fv.Value = ""
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
                                   ByRef vAplic() As T_Aplic, _
                                   ByVal TypeApply As c_TypeApply)
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
      fv.Key = KIP_PVRV_ID
      
      Set fv = f.Add(Nothing)
      
      Select Case TypeApply
      
        Case c_TypeApply.cE_Presupuesto
          fv.Key = KIP_PRVI_ID
          fv.Id = .prvi_id
        
        Case c_TypeApply.cE_Packing
          fv.Key = KIP_PKI_ID
          fv.Id = .pki_id
        
        Case c_TypeApply.cE_FacDev
        
          fv.Key = KIFD_PVI_ID
          fv.Id = .pvi_id
          
          Set fv = f.Add(Nothing)
          fv.Id = .fvi_id
          fv.Key = KIFD_FVI_ID
        
          Set fv = f.Add(Nothing)
          fv.Id = .rvi_id
          fv.Key = KIFD_RVI_ID
      End Select
      
      Set fv = f.Add(Nothing)
      fv.Value = .docNombre
      fv.Key = KIP_DOC
      
      Set fv = f.Add(Nothing)
      fv.Value = .nroDoc
      fv.Key = KIP_NRODOC
      
      Set fv = f.Add(Nothing)
      If .Fecha = csNoDate Then
        fv.Value = ""
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
        .pvi_id = m_pvi_id
      End With
    End If
    
    vAplicaciones(Idx).Aplicado = Importe
    
    For i = 1 To UBound(vAplicaciones)
      rtn = rtn + vAplicaciones(i).Aplicado
    Next
    
    pItAddToAplic = rtn
  End Function

  Private Function pItGetItemsProperty(ByVal TypeApply As c_TypeApply) As cIABMProperty
    Select Case TypeApply
      
      Case c_TypeApply.cE_Presupuesto
        Set pItGetItemsProperty = m_ObjAbm.Properties(c_AplicPresu)
      
      Case c_TypeApply.cE_Packing
        Set pItGetItemsProperty = m_ObjAbm.Properties(c_AplicPacking)
      
      Case c_TypeApply.cE_FacDev
        Set pItGetItemsProperty = m_ObjAbm.Properties(c_AplicFacDev)
        
    End Select
  End Function
  
  Private Function pItGetItemsAplic(ByVal TypeApply As c_TypeApply) As cIABMGrid
    Select Case TypeApply
      
      Case c_TypeApply.cE_Presupuesto
        Set pItGetItemsAplic = m_ObjAbm.Properties(c_AplicPresu).Grid
        
      Case c_TypeApply.cE_Packing
        Set pItGetItemsAplic = m_ObjAbm.Properties(c_AplicPacking).Grid
        
      Case c_TypeApply.cE_FacDev
        Set pItGetItemsAplic = m_ObjAbm.Properties(c_AplicFacDev).Grid
    End Select
  End Function

  Private Function pItColBEdit(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
    Select Case pGetKeyFromCol(IProperty.Grid.Columns, lCol)
      Case KIP_APLICADO
      Case Else
        Exit Function
    End Select
    
    pItColBEdit = True
  End Function

  Private Function pItGetItemPendiente(ByVal TypeApply As c_TypeApply) As cIABMGridCellValue
    Dim iProp As cIABMProperty
    
    Select Case TypeApply
      
      Case c_TypeApply.cE_Presupuesto
        Set iProp = m_ObjAbm.Properties(c_Presu)
        
      Case c_TypeApply.cE_Packing
        Set iProp = m_ObjAbm.Properties(c_Items)
      
      Case c_TypeApply.cE_FacDev
        Set iProp = m_ObjAbm.Properties(c_FacDev)
    End Select
    
    Set pItGetItemPendiente = pCell(iProp.Grid.Rows(iProp.SelectedIndex), KII_PENDIENTE)
  End Function
  
  Private Function pItGetItemAplicado(ByVal TypeApply As c_TypeApply) As cIABMGridCellValue
    Dim iProp As cIABMProperty
    
    Select Case TypeApply
      
      Case c_TypeApply.cE_Presupuesto
        Set iProp = m_ObjAbm.Properties(c_Presu)
        
      Case c_TypeApply.cE_Packing
        Set iProp = m_ObjAbm.Properties(c_Items)
      
      Case c_TypeApply.cE_FacDev
        Set iProp = m_ObjAbm.Properties(c_FacDev)
    End Select
    
    Set pItGetItemAplicado = pCell(iProp.Grid.Rows(iProp.SelectedIndex), KII_APLICADO2)
  End Function
  
  Private Function pItColAUpdate(ByRef IProperty As cIABMProperty, _
                                 ByVal lRow As Long, _
                                 ByVal lCol As Long, _
                                 ByVal TypeApply As c_TypeApply)
    Dim Row        As cIABMGridRow
    Dim MaxVal     As Double
    Dim bVisible   As Boolean
    Dim Pendiente  As Double
    
    With IProperty.Grid
      Select Case .Columns(lCol).Key
        Case KIP_APLICADO
          Set Row = .Rows(lRow)
          
          With pCell(Row, KIP_APLICADO)
            
            Pendiente = Val(pItGetItemPendiente(TypeApply).Value) + Val(pCell(Row, KIP_APLICADO2).Value)
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
            Aplicado = pItGetAplicado(TypeApply)
            pItRefreshItem Aplicado, TypeApply
            pItGetItemAplicado(TypeApply).Value = Aplicado
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
  
  Private Function pItGetAplicado(ByVal TypeApply As c_TypeApply) As Double
    Dim Row       As cIABMGridRow
    Dim rtn       As Double
    Dim iProp     As cIABMProperty
    
    Select Case TypeApply
      
      Case c_TypeApply.cE_Presupuesto
        Set iProp = m_ObjAbm.Properties(c_AplicPresu)
        
      Case c_TypeApply.cE_Packing
        Set iProp = m_ObjAbm.Properties(c_AplicPacking)
        
      Case c_TypeApply.cE_FacDev
        Set iProp = m_ObjAbm.Properties(c_AplicFacDev)
        
    End Select
    
    For Each Row In iProp.Grid.Rows
      rtn = rtn + Val(pCell(Row, KIP_APLICADO).Value)
    Next
    pItGetAplicado = rtn
  End Function
  
  Private Sub pItRefreshItem(ByVal Aplicado As Double, _
                             ByVal TypeApply As c_TypeApply)
    Dim iProp     As cIABMProperty
    Dim AbmObj    As cABMGeneric
    Dim Row       As cIABMGridRow
    Dim AplicadoActual  As Double
    Dim LastRow   As Long
    
    Set AbmObj = m_ObjAbm
    
    Select Case TypeApply
      
      Case c_TypeApply.cE_Presupuesto
        Set iProp = m_ObjAbm.Properties(c_Presu)
        LastRow = m_LastRowPresu
        
      Case c_TypeApply.cE_Packing
        Set iProp = m_ObjAbm.Properties(c_Items)
        LastRow = m_LastRowItem
        
      Case c_TypeApply.cE_FacDev
        Set iProp = m_ObjAbm.Properties(c_FacDev)
        LastRow = m_LastRowFacDev
    End Select
    
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
  
  Private Function pItSavePacking(ByVal pvTMPId As Long, ByRef vAplic() As T_Aplic) As Boolean
    Dim register    As cRegister
    Dim i           As Long
    Dim j           As Long
    
    For i = 1 To UBound(vAplic)
   
      If vAplic(i).pki_id <> csNO_ID Then
   
        For j = 1 To UBound(vAplic(i).vAplicaciones)
        
          If vAplic(i).vAplicaciones(j).pvi_id <> csNO_ID Then
        
            With vAplic(i).vAplicaciones(j)
              
              If .Aplicado > 0 Then
          
                Set register = New cRegister
                register.fieldId = cscPvPklstTMPid
                register.Table = csTPedidoPackingListTMP
                register.Id = csNew
                
                register.Fields.Add2 cscPvTMPId, pvTMPId, csId
                register.Fields.Add2 cscPklstiId, vAplic(i).pki_id, csId
                register.Fields.Add2 cscPviId, .pvi_id, csId
                register.Fields.Add2 cscPvPklstCantidad, .Aplicado, csDouble
                
                register.Fields.Add2 cscPvPklstId, .vinc_id, csLong
                
                register.Fields.HaveLastUpdate = False
                register.Fields.HaveWhoModify = False
                
                If Not gDB.Save(register, , "pItSavePacking", C_Module, c_ErrorSave) Then Exit Function
              End If
            End With
          End If
        Next
      End If
    Next
    
    pItSavePacking = True
  End Function
  
'////////////////////////////////////////////////////////////////////////////////////
'
'   construccion - destruccion
'
'////////////////////////////////////////////////////////////////////////////////////
Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(1591, vbNullString)
                'Error al grabar el Pedido de Venta

  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  ReDim m_vPresupuesto(0)
  ReDim m_vPresupuesto(0).vAplicaciones(0)
  
  ReDim m_vPacking(0)
  ReDim m_vPacking(0).vAplicaciones(0)
  
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
  
  ReDim m_vPresupuesto(0)
  ReDim m_vFacDevs(0)
  ReDim m_vPacking(0)
  
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

  Private Function pItLoadFacDev(ByRef iProp As cIABMProperty) As Boolean
    pItLoadFacDev = pItLoadItemsAux(iProp, cE_FacDev)
  End Function
  
  Private Function pItSetGridAplicFacDev(ByRef iProp As cIABMProperty) As Boolean
    pItSetGridAplicFacDev = pItSetGridAplicAux(iProp, cE_FacDev)
  End Function

  Private Function pItSaveFacDev(ByVal pvTMPId As Long, ByRef vAplic() As T_Aplic) As Boolean
    Dim register    As cRegister
    Dim i           As Long
    Dim j           As Long
    
    For i = 1 To UBound(vAplic)
   
      If vAplic(i).fvi_id <> csNO_ID Or vAplic(i).pvi_id <> csNO_ID Or vAplic(i).rvi_id <> csNO_ID Then
   
        For j = 1 To UBound(vAplic(i).vAplicaciones)
        
          If vAplic(i).vAplicaciones(j).pvi_id <> csNO_ID Then
        
            With vAplic(i).vAplicaciones(j)
              
              If .Aplicado > 0 Then
          
                Set register = New cRegister
                
                ' Si estoy vinculando contra una factura
                If vAplic(i).fvi_id <> 0 Then
                  register.fieldId = cscPvFvTMPId
                  register.Table = csTPedidoFacturaVentaTMP
                  register.Fields.Add2 cscFviId, vAplic(i).fvi_id, csId
                  register.Fields.Add2 cscPviId, .pvi_id, csId
                
                  register.Fields.Add2 cscPvFvCantidad, .Aplicado, csDouble
                  register.Fields.Add2 cscPvFvId, .vinc_id, csLong
                
                ElseIf vAplic(i).rvi_id <> 0 Then
                
                  register.fieldId = cscPvRvTMPid
                  register.Table = csTPedidoRemitoVentaTMP
                  register.Fields.Add2 cscRviId, vAplic(i).rvi_id, csId
                  register.Fields.Add2 cscPviId, .pvi_id, csId
                  
                  register.Fields.Add2 cscPvRvCantidad, .Aplicado, csDouble
                  register.Fields.Add2 cscPvRvId, .vinc_id, csLong
                
                ' Si vinculo contra un pedido (Pedido - Devolucion)
                Else
                  register.fieldId = cscPvDvTMPId
                  register.Table = csTPedidoDevolucionVentaTMP
                  
                  If m_IsDevolucion Then
                    register.Fields.Add2 cscPviIdDevolucion, .pvi_id, csId
                    register.Fields.Add2 cscPviIdPedido, vAplic(i).pvi_id, csId
                  Else
                    register.Fields.Add2 cscPviIdPedido, .pvi_id, csId
                    register.Fields.Add2 cscPviIdDevolucion, vAplic(i).pvi_id, csId
                  End If
                
                  register.Fields.Add2 cscPvDvCantidad, .Aplicado, csDouble
                  register.Fields.Add2 cscPvDvId, .vinc_id, csLong
                
                End If
                
                register.Id = csNew
                register.Fields.Add2 cscPvTMPId, pvTMPId, csId
                
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

  Private Function pItLoadPresupuesto(ByRef iProp As cIABMProperty) As Boolean
    pItLoadPresupuesto = pItLoadItemsAux(iProp, cE_Presupuesto)
  End Function

  Private Function pItSetGridAplicPresupuesto(ByRef iProp As cIABMProperty) As Boolean
    pItSetGridAplicPresupuesto = pItSetGridAplicAux(iProp, cE_Presupuesto)
  End Function

  Private Function pItSavePresupuesto(ByVal pvTMPId As Long, ByRef vAplic() As T_Aplic) As Boolean
    Dim register    As cRegister
    Dim i           As Long
    Dim j           As Long
    
    For i = 1 To UBound(vAplic)
   
      If vAplic(i).prvi_id <> csNO_ID Then
   
        For j = 1 To UBound(vAplic(i).vAplicaciones)
        
          If vAplic(i).vAplicaciones(j).pvi_id <> csNO_ID Then
        
            With vAplic(i).vAplicaciones(j)
              
              If .Aplicado > 0 Then
          
                Set register = New cRegister
                register.fieldId = cscPrvPvTMPid
                register.Table = csTPresupuestoPedidoVentaTMP
                register.Id = csNew
                
                register.Fields.Add2 cscPvTMPId, pvTMPId, csId
                register.Fields.Add2 cscPrviId, vAplic(i).prvi_id, csId
                register.Fields.Add2 cscPviId, .pvi_id, csId
                register.Fields.Add2 cscPrvPvCantidad, .Aplicado, csDouble
                
                register.Fields.Add2 cscPrvPvId, .vinc_id, csLong
                
                register.Fields.HaveLastUpdate = False
                register.Fields.HaveWhoModify = False
                
                If Not gDB.Save(register, , "pItSavePresupuesto", C_Module, c_ErrorSave) Then Exit Function
              End If
            End With
          End If
        Next
      End If
    Next
    
    pItSavePresupuesto = True
  End Function

