VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRemitoCompraAplic"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cRemitoCompraAplic
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
Private Const C_Module = "cRemitoCompraAplic"

Private Const c_ErrorSave = "Error al grabar el remito de compra"

  Private Const cscNroDoc                          As String = "nrodoc"
  Private Const cscPendiente                       As String = "Pendiente"
  Private Const cscImporte                         As String = "Importe"
  Private Const cscVincId                          As String = "vinc_id"
  Private Const cscRcdId                           As String = "rcd_id"
'////////////////////////////////////////////////////////////////////////////////////
'
'   ORDEN - SOLAPA
'
'////////////////////////////////////////////////////////////////////////////////////
  
  ' Orden
  
  Private Const K_ORDEN = 10
  Private Const K_APLIC_ORDEN = 11
  Private Const c_Items = "Items"
  Private Const c_AplicOrden = "AplicOrden"

  Private Const cscFecha        As String = "Fecha"
  Private Const cscAplicado     As String = "Aplicado"
  Private Const cscAplicRemito  As String = "AplicRemito"
  Private Const cscAplicOrden   As String = "AplicOrden"
  
  ' Grillas de Ordenes / Remitos
  Private Const KII_RCI_ID                  As Integer = 1
  Private Const KII_PR_ID                   As Integer = 2
  Private Const KII_APLICADO                As Integer = 4
  Private Const KII_APLICADO2               As Integer = 5
  Private Const KII_PENDIENTE               As Integer = 6
  
  Private Const KIP_OCRC_ID                 As Integer = 1
  
  Private Const KIFD_FCI_ID                 As Integer = 2
  
  ' Estos dos tienen el mismo valor aproposito
  Private Const KIP_OCI_ID                  As Integer = 3
  Private Const KIFD_RCI_ID                 As Integer = KIP_OCI_ID
  
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
  
  ' Orden
  
  Private Const K_FAC_DEV = 20
  Private Const K_APLIC_FAC_DEV = 21
  Private Const c_FacDev = "FacDev"
  Private Const c_AplicFacDev = "AplicFacDev"

' estructuras

'////////////////////////////////////////////////////////////////////////////////////
'
'   ORDENES / REMITOS
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private Type T_ItAplic
    vinc_id                 As Long   ' lo uso para ocrc_id, rcfc_id y rcdc_id
    rci_id                  As Long   ' Ids de items al que este credito esta vinculado
    
    Aplicado                As Double
  End Type
  
  Private Type T_Aplic
    oci_id                  As Long ' Vinculacion con orden
    
    fci_id                  As Long ' factura
    rci_id                  As Long ' devolucion / remito
    
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

' variables privadas

' generales

Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric
Private m_GeneralConfig     As cGeneralConfig
Private m_RcId              As Long
Private m_IsDevolucion      As Boolean
Private m_RcNumero          As String
Private m_proveedor         As String
Private m_ProvId            As Long
Private m_DocId             As Long
Private m_SucId             As Long
Private m_Total             As Double

Private m_MonDefault        As Long

Private m_LastRowItem       As Long
Private m_LastRowFacDev     As Long

' Edit Apply
'
Private m_ObjectClient      As cRemitoCompra
Private m_emp_id            As Long
Private m_emp_nombre        As String

'////////////////////////////////////////////////////////////////////////////////////
'
'   ORDENES / REMITOS
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private m_vOrdenes()        As T_Aplic
  Private m_vFacDevs()        As T_Aplic
  Private m_rci_id            As Long

' eventos
' propiedades publicas

' Edit Apply
'
Public Property Set ObjectClient(ByVal rhs As cRemitoCompra)
  Set m_ObjectClient = rhs
End Property

Public Property Get Id() As Long
  Id = m_RcId
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Show(ByVal RcId As Long, ByVal Total As Double, _
                     ByVal RcNumero As String, _
                     ByVal ProvId As Long, ByVal Proveedor As String, _
                     ByVal SucId As Long, ByVal DocId As Long, _
                     ByVal IsDevolucion As Boolean) As Boolean
  
  If m_ObjAbm Is Nothing Then
    Set m_ObjAbm = New cABMGeneric
  End If
  
  If m_RcId <> RcId Then
    m_IsDevolucion = IsDevolucion
    m_RcId = RcId
    m_RcNumero = RcNumero
    m_proveedor = Proveedor
    m_ProvId = ProvId
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
          
          Case K_ORDEN
          
            Set AbmObj = m_ObjAbm
            
            ' Guardo la aplicacion para el item editado anteriormente
            '
            If m_LastRowItem <> 0 Then
              Aplicado = pItUpdateGrids(True, m_vOrdenes)
            End If
            
            ' Muestro las aplicaciones para este item
            '
            m_LastRowItem = iProp.SelectedIndex
            Set Row = iProp.Grid.Rows(m_LastRowItem)
            If Row Is Nothing Then Exit Function
            
            pItSetAplicItems m_ObjAbm.Properties(c_AplicOrden), _
                             pCell(Row, KII_RCI_ID).Id, _
                             pCell(Row, KII_PR_ID).Id, m_vOrdenes, True
            
            AbmObj.ShowValue m_ObjAbm.Properties(c_AplicOrden), True
          
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
                             pCell(Row, KII_RCI_ID).Id, _
                             pCell(Row, KII_PR_ID).Id, m_vFacDevs, False
            
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
    m_RcId = csNO_ID
    Set m_ObjAbm = Nothing
    
    ' Edit Apply
    '
    Set m_ObjectClient = Nothing
  End Function
  
  Private Property Get cIABMClient_Title() As String
    On Error Resume Next
    cIABMClient_Title = LNGGetText(1949, vbNullString)  'Aplicación Remito de Compra
    m_ObjAbm.Title2 = m_RcNumero & " - " & m_proveedor
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
      Case K_APLIC_ORDEN
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
      Case K_APLIC_ORDEN
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
    
    Dim Id As Long
    
    Select Case Key

      Case K_APLIC_ORDEN
        
        With pItGetItemsAplic(True).Rows
          
          Id = pCell(.Item(lRow), KIP_OCI_ID).Id
          
          If Id <> csNO_ID Then
            
            If Not gDB.GetData("OrdenCompraItem", _
                               "oci_id", _
                               Id, _
                               "oc_id", _
                               Id) Then Exit Sub
            
            If Id <> csNO_ID Then
            
              ShowDocAux Id, _
                         "CSCompra2.cOrdenCompra", _
                         "CSABMInterface2.cABMGeneric"
            End If
          End If
          
        End With
        
      Case K_APLIC_FAC_DEV

        With pItGetItemsAplic(False).Rows
          
          Dim ObjEditName As String
                    
          Id = pCell(.Item(lRow), KIFD_RCI_ID).Id
          
          If Id <> csNO_ID Then
            
            If Not gDB.GetData("RemitoCompraItem", _
                               "rci_id", _
                               Id, _
                               "rc_id", _
                               Id) Then Exit Sub
            
            ObjEditName = "CSCompra2.cRemitoCompra"
            
          Else
          
            Id = pCell(.Item(lRow), KIFD_FCI_ID).Id
            
            If Id <> csNO_ID Then
              If Not gDB.GetData("FacturaCompraItem", _
                                 "fci_id", _
                                 Id, _
                                 "fc_id", _
                                 Id) Then Exit Sub
              
              ObjEditName = "CSCompra2.cFacturaCompra"
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
  
    m_LastRowItem = 0
    m_LastRowFacDev = 0
    
    m_ObjAbm.Properties.Clear
    
    With m_ObjAbm.Tabs
      
      .Clear
    
      With .Add(Nothing)
       .Name = LNGGetText(1950, vbNullString) 'Ordenes
      End With
       
      With .Add(Nothing)
       .Index = 1
       .Name = LNGGetText(1607, vbNullString) 'Facturas
      End With
      
    End With
    
    With m_ObjAbm.Properties
   
      Set c = .Add(Nothing, c_Items)
      c.PropertyType = cspGrid
      c.LeftLabel = -1
      If Not pItLoadItems(c) Then Exit Function
      c.Key = K_ORDEN
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
      
      Set c = .Add(Nothing, c_AplicOrden)
      c.PropertyType = cspGrid
      c.LeftLabel = -1
      If Not pItSetGridAplicOrden(c) Then Exit Function
      c.Key = K_APLIC_ORDEN
      c.Name = "Orden"
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
      c.TabIndex = 1
      Set oGrd = c.Grid
      oGrd.RowSelect = True
      oGrd.DontSelectInGotFocus = True
      
      Set c = .Add(Nothing, c_AplicFacDev)
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
      c.TabIndex = 1
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
    
    Dim RcTMPId As Long
    
    pItUpdateGrids True, m_vOrdenes
    pItUpdateGrids False, m_vFacDevs
    
    ' Temporal
    If Not pSaveDocCpra(m_DocId, RcTMPId) Then Exit Function
  
    ' Ordenes
    If Not pItSaveOrdenes(RcTMPId, m_vOrdenes) Then Exit Function
    
    ' Facturas / Devoluciones
    If Not pItSaveFacDev(RcTMPId, m_vFacDevs) Then Exit Function
    
    ' Aplico llamando al sp
    Dim sqlstmt As String
    Dim rs      As Recordset
    
    sqlstmt = "sp_DocRemitoCompraSaveAplic " & RcTMPId
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
  ' RemitoCompraTemporal
  '////////////////////////////////////////////////////////////////////////////////////
  Private Function pSaveDocCpra(ByVal DocId As Long, _
                               ByRef RcTMPId As Long) As Boolean
    Dim register     As cRegister
    
    Set register = New cRegister
    register.fieldId = cscRcTMPId
    register.Table = csTRemitoCompraTMP
  
    register.Id = csNew
    register.fields.Add2 cscRcId, m_RcId, csId
  
    register.fields.Add2 cscRcNumero, 0, csLong
    register.fields.Add2 cscRcNrodoc, vbNullString, csText
    
    register.fields.Add2 cscProvId, 0, csLong
    register.fields.Add2 cscSucId, 0, csLong
    register.fields.Add2 cscDocId, DocId, csId
    register.fields.Add2 cscCpgId, csECpgTipo.csECpgT_FechaDocumento, csId
    
    register.fields.Add2 cscEstId, CSGeneralEx2.csEEstado.csEEst_Pendiente, csId
  
    register.fields.HaveLastUpdate = True
    register.fields.HaveWhoModify = True
  
    If Not register.BeginTrans(gDB) Then Exit Function
  
    If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
    If Not register.CommitTrans() Then Exit Function
  
    RcTMPId = register.Id
    pSaveDocCpra = True
  End Function

'////////////////////////////////////////////////////////////////////////////////////
'
'   ORDENES / REMITOS
'
'////////////////////////////////////////////////////////////////////////////////////

  Private Function pItLoadAplicItems() As Boolean
    
    If Not pItLoadAplicAplicados(m_vOrdenes, True) Then Exit Function
    If Not pItLoadAplicCreditos(m_vOrdenes, True) Then Exit Function
    
    If Not pItLoadAplicAplicados(m_vFacDevs, False) Then Exit Function
    If Not pItLoadAplicCreditos(m_vFacDevs, False) Then Exit Function
    
    pItLoadAplicItems = True
  End Function
  
  Private Function pItLoadItems(ByRef iProp As cIABMProperty) As Boolean
    pItLoadItems = pItLoadItemsAux(iProp, True)
  End Function

  Private Function pItSetGridAplicOrden(ByRef iProp As cIABMProperty) As Boolean
    pItSetGridAplicOrden = pItSetGridAplicAux(iProp, True)
  End Function

'////////////////////////////////////////////////////////////////////////////////////
'
'   GENERICAS
'
'////////////////////////////////////////////////////////////////////////////////////

  Private Function pItLoadItemsAux(ByRef iProp As cIABMProperty, ByVal IsOrden As Boolean) As Boolean
    Dim sqlstmt     As String
    Dim rs          As ADODB.Recordset
    Dim Grid        As cIABMGrid
    Dim Row         As cABMGridRow
    Dim Value       As Double
  
    sqlstmt = "sp_DocRemitoCompraGetAplic " & EmpId & "," & m_RcId & ",1"
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pItLoadItems", C_Module) Then Exit Function
  
    iProp.Grid.Columns.Clear
    iProp.Grid.Rows.Clear
  
    Set Grid = iProp.Grid
  
    With Grid.Columns
      With .Add(Nothing)
        .Visible = False
        .Key = KII_RCI_ID
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
        .Name = LNGGetText(1608, vbNullString)  'Aplicado
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
      fv.Id = gDB.ValField(rs.fields, cscRciId)
      fv.Key = KII_RCI_ID
  
      Set fv = f.Add(Nothing)
      fv.Id = gDB.ValField(rs.fields, cscPrId)
      fv.Value = gDB.ValField(rs.fields, cscPrNombrecompra)
      fv.Key = KII_PR_ID
  
      Set fv = f.Add(Nothing)
      If IsOrden Then
        fv.Value = gDB.ValField(rs.fields, cscRciPendiente)
      Else
        fv.Value = gDB.ValField(rs.fields, cscRciPendientefac)
      End If
      fv.Key = KII_PENDIENTE
  
      If IsOrden Then
        Value = gDB.ValField(rs.fields, cscAplicOrden)
      Else
        Value = gDB.ValField(rs.fields, cscAplicRemito)
      End If
      
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

  Private Function pItSetGridAplicAux(ByRef iProp As cIABMProperty, ByVal IsOrden As Boolean) As Boolean
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
        .Key = KIP_OCRC_ID
      End With
      
      If Not IsOrden Then
        With .Add(Nothing)
          .Visible = False
          .Key = KIFD_FCI_ID
        End With
      End If
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIP_OCI_ID
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
  
  Private Function pItLoadAplicAplicados(ByRef vAplic() As T_Aplic, ByVal IsOrden As Boolean) As Boolean
    Dim sqlstmt       As String
    Dim rs            As ADODB.Recordset
    Dim i             As Long
    Dim Idx           As Long
    
    If IsOrden Then
      sqlstmt = "sp_DocRemitoCompraGetAplic " & EmpId & "," & m_RcId & ",4"
    Else
      sqlstmt = "sp_DocRemitoCompraGetAplic " & EmpId & "," & m_RcId & ",2"
    End If
    
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadAplicAplicados", C_Module) Then Exit Function
    
    ReDim vAplic(0)
    ReDim vAplic(0).vAplicaciones(0)
    
    If Not rs.EOF Then
    
      rs.MoveLast
      rs.MoveFirst
    
      While Not rs.EOF
            
        If IsOrden Then
          i = pItAddToCreditos(gDB.ValField(rs.fields, cscOciId), _
                               csNO_ID, csNO_ID, _
                               Idx, vAplic)
        Else
          i = pItAddToCreditos(csNO_ID, _
                               gDB.ValField(rs.fields, cscFciId), _
                               gDB.ValField(rs.fields, cscRciId), _
                               Idx, vAplic)
        End If
        
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
          
          If IsOrden Then
            ' Orden
            '
            .oci_id = gDB.ValField(rs.fields, cscOciId)
          
          Else
            ' Remito
            '
            .rci_id = gDB.ValField(rs.fields, cscRcdId)
            .fci_id = gDB.ValField(rs.fields, cscFciId)
          End If
          
          .PR_ID = gDB.ValField(rs.fields, cscPrId)
          
          ' Aplicaciones
          With .vAplicaciones(Idx)
          
            .vinc_id = gDB.ValField(rs.fields, cscVincId)
              
            .rci_id = gDB.ValField(rs.fields, cscRciId)
            
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
  
  Private Function pItLoadAplicCreditos(ByRef vAplic() As T_Aplic, ByVal IsOrden As Boolean) As Boolean
    Dim sqlstmt       As String
    Dim rs            As ADODB.Recordset
    Dim i             As Long
    
    If IsOrden Then
      sqlstmt = "sp_DocRemitoCompraGetAplic " & EmpId & "," & m_RcId & ",5"
    Else
      sqlstmt = "sp_DocRemitoCompraGetAplic " & EmpId & "," & m_RcId & ",3"
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
          .PR_ID = gDB.ValField(rs.fields, cscPrId)
          
          If IsOrden Then
            
            .oci_id = gDB.ValField(rs.fields, cscOciId)
          
          Else
          
            .rci_id = gDB.ValField(rs.fields, cscRcdId)
            .fci_id = gDB.ValField(rs.fields, cscFciId)
          End If
  
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
  
  Private Function pItAddToCreditos(ByVal OciId As Long, _
                                    ByVal FciId As Long, _
                                    ByVal RciId As Long, _
                                    ByRef Idx As Long, _
                                    ByRef vAplic() As T_Aplic) As Long
    Dim i As Long
    
    For i = 1 To UBound(vAplic)
      With vAplic(i)
        If (.oci_id = OciId And OciId <> csNO_ID) Or _
           (.fci_id = FciId And FciId <> csNO_ID) Or _
           (.rci_id = RciId And RciId <> csNO_ID) Then
           
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
  
  Private Function pItUpdateGrids(ByVal IsOrden As Boolean, ByRef vAplic() As T_Aplic) As Double
    Dim iProp         As cIABMProperty
    Dim iPropAplic    As cIABMProperty
    Dim Row           As cIABMGridRow
    Dim LastRow       As Long
    
    If IsOrden Then
      Set iProp = m_ObjAbm.Properties(c_Items)
      Set iPropAplic = m_ObjAbm.Properties(c_AplicOrden)
      LastRow = m_LastRowItem
    Else
      Set iProp = m_ObjAbm.Properties(c_FacDev)
      Set iPropAplic = m_ObjAbm.Properties(c_AplicFacDev)
      LastRow = m_LastRowFacDev
    End If
    
    If LastRow <> 0 Then
      
      Set Row = iProp.Grid.Rows(LastRow)
      pItUpdateGrids = pItUpdateAplicItems(iPropAplic, _
                                           pCell(Row, KII_RCI_ID).Id, _
                                           vAplic, _
                                           IsOrden)
    End If
  End Function
  
  Private Function pItSetAplicItems(ByRef iProp As cIABMProperty, _
                                    ByVal rci_id As Long, _
                                    ByVal PR_ID As Long, _
                                    ByRef vAplic() As T_Aplic, _
                                    ByVal IsOrden As Boolean) As Boolean
    Dim i             As Long
    Dim j             As Long
    
    iProp.Grid.Rows.Clear
    
    m_rci_id = rci_id
    
    For i = 1 To UBound(vAplic)
    
      If vAplic(i).PR_ID = PR_ID Then
    
        If UBound(vAplic(i).vAplicaciones) > 0 Then
          pItSetAplicItemsAux1 i, iProp, rci_id, vAplic, IsOrden
        Else
          pItSetAplicItemsAux2 i, iProp, vAplic, IsOrden
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
        
          If IsOrden Then
            Id = pCell(Row, KIP_OCI_ID).Id
            If Id = vAplic(i).oci_id And Id <> csNO_ID Then
              bAplic = True
              Exit For
            End If
          Else
            Id = pCell(Row, KIFD_FCI_ID).Id
            If Id = vAplic(i).fci_id And Id <> csNO_ID Then
              bAplic = True
              Exit For
            End If
          
            Id = pCell(Row, KIFD_RCI_ID).Id
            If Id = vAplic(i).rci_id And Id <> csNO_ID Then
              bAplic = True
              Exit For
            End If
          End If
        
          Id = m_rci_id
          For j = 1 To UBound(vAplic(i).vAplicaciones)
            If Id = vAplic(i).vAplicaciones(j).rci_id And Id <> csNO_ID Then
              bAplic = True
              Exit For
            End If
          Next
        
          If bAplic Then Exit For
        Next
    
        If Not bAplic Then pItSetAplicItemsAux2 i, iProp, vAplic, IsOrden
      End If
    Next
    
    pItSetAplicItems = True
  End Function
  
  Private Function pItUpdateAplicItems(ByRef iProp As cIABMProperty, _
                                       ByVal rci_id As Long, _
                                       ByRef vAplic() As T_Aplic, _
                                       ByVal IsOrden As Boolean) As Double
    Dim i             As Long
    Dim j             As Long
    Dim Row           As cIABMGridRow
    Dim Aplicado      As Double
    Dim AplicadoTotal As Double
    
    For Each Row In pItGetItemsAplic(IsOrden).Rows
    
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
  
  Private Sub pItSetAplicItemsAux1(ByVal Idx As Long, ByRef iProp As cIABMProperty, ByVal rci_id As Long, _
                                   ByRef vAplic() As T_Aplic, ByVal IsOrden As Boolean)
    Dim f               As cIABMGridRow
    Dim fv              As cIABMGridCellValue
    Dim i               As Long
    Dim iPropItem       As cIABMProperty
    Dim Row             As cABMGridRow
    
    For i = 1 To UBound(vAplic(Idx).vAplicaciones)
    
      With vAplic(Idx).vAplicaciones(i)
    
        If .rci_id = rci_id And rci_id <> csNO_ID Then
        
          Set f = iProp.Grid.Rows.Add(Nothing)
          
          Set fv = f.Add(Nothing)
          fv.Id = Idx
          fv.Key = KIP_IDX1
          
          Set fv = f.Add(Nothing)
          fv.Id = i
          fv.Key = KIP_IDX2
          
          Set fv = f.Add(Nothing)
          fv.Id = .vinc_id
          fv.Key = KIP_OCRC_ID
          
          Set fv = f.Add(Nothing)
          
          If IsOrden Then
            
            fv.Key = KIP_OCI_ID
            fv.Id = vAplic(Idx).oci_id
            
          Else
            
            fv.Key = KIFD_RCI_ID
            fv.Id = vAplic(Idx).rci_id
            
            Set fv = f.Add(Nothing)
            fv.Id = vAplic(Idx).fci_id
            fv.Key = KIFD_FCI_ID
          End If
          
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
                                   ByRef vAplic() As T_Aplic, ByVal IsOrden As Boolean)
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
      fv.Key = KIP_OCRC_ID
      
      Set fv = f.Add(Nothing)
      
      If IsOrden Then
        
        fv.Key = KIP_OCI_ID
        fv.Id = .oci_id
        
      Else
        
        fv.Key = KIFD_RCI_ID
        fv.Id = .rci_id
        
        Set fv = f.Add(Nothing)
        fv.Id = .fci_id
        fv.Key = KIFD_FCI_ID
      End If
      
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
        .rci_id = m_rci_id
      End With
    End If
    
    vAplicaciones(Idx).Aplicado = Importe
    
    For i = 1 To UBound(vAplicaciones)
      rtn = rtn + vAplicaciones(i).Aplicado
    Next
    
    pItAddToAplic = rtn
  End Function

  Private Function pItGetItemsProperty(ByVal IsOrden As Boolean) As cIABMProperty
    If IsOrden Then
      Set pItGetItemsProperty = m_ObjAbm.Properties(c_AplicOrden)
    Else
      Set pItGetItemsProperty = m_ObjAbm.Properties(c_AplicFacDev)
    End If
  End Function
  
  Private Function pItGetItemsAplic(ByVal IsOrden As Boolean) As cIABMGrid
    If IsOrden Then
      Set pItGetItemsAplic = m_ObjAbm.Properties(c_AplicOrden).Grid
    Else
      Set pItGetItemsAplic = m_ObjAbm.Properties(c_AplicFacDev).Grid
    End If
  End Function

  Private Function pItColBEdit(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
    Select Case pGetKeyFromCol(IProperty.Grid.Columns, lCol)
      Case KIP_APLICADO
      Case Else
        Exit Function
    End Select
    
    pItColBEdit = True
  End Function

  Private Function pItGetItemPendiente(ByVal IsOrden As Boolean) As cIABMGridCellValue
    Dim iProp As cIABMProperty
    If IsOrden Then
      Set iProp = m_ObjAbm.Properties(c_Items)
    Else
      Set iProp = m_ObjAbm.Properties(c_FacDev)
    End If
    Set pItGetItemPendiente = pCell(iProp.Grid.Rows(iProp.SelectedIndex), KII_PENDIENTE)
  End Function
  
  Private Function pItGetItemAplicado(ByVal IsOrden As Boolean) As cIABMGridCellValue
    Dim iProp As cIABMProperty
    If IsOrden Then
      Set iProp = m_ObjAbm.Properties(c_Items)
    Else
      Set iProp = m_ObjAbm.Properties(c_FacDev)
    End If
    Set pItGetItemAplicado = pCell(iProp.Grid.Rows(iProp.SelectedIndex), KII_APLICADO2)
  End Function
  
  Private Function pItColAUpdate(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal IsOrden As Boolean)
    Dim Row        As cIABMGridRow
    Dim MaxVal     As Double
    Dim bVisible   As Boolean
    Dim Pendiente  As Double
    
    With IProperty.Grid
      Select Case .Columns(lCol).Key
        Case KIP_APLICADO
          Set Row = .Rows(lRow)
          
          With pCell(Row, KIP_APLICADO)
            
            Pendiente = Val(pItGetItemPendiente(IsOrden).Value) + Val(pCell(Row, KIP_APLICADO2).Value)
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
            Aplicado = pItGetAplicado(IsOrden)
            pItRefreshItem Aplicado, IsOrden
            pItGetItemAplicado(IsOrden).Value = Aplicado
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
  
  Private Function pItGetAplicado(ByVal IsOrden As Boolean) As Double
    Dim Row       As cIABMGridRow
    Dim rtn       As Double
    Dim iProp     As cIABMProperty
    
    If IsOrden Then
      Set iProp = m_ObjAbm.Properties(c_AplicOrden)
    Else
      Set iProp = m_ObjAbm.Properties(c_AplicFacDev)
    End If
    
    For Each Row In iProp.Grid.Rows
      rtn = rtn + Val(pCell(Row, KIP_APLICADO).Value)
    Next
    pItGetAplicado = rtn
  End Function
  
  Private Sub pItRefreshItem(ByVal Aplicado As Double, ByVal IsOrden As Boolean)
    Dim iProp     As cIABMProperty
    Dim AbmObj    As cABMGeneric
    Dim Row       As cIABMGridRow
    Dim AplicadoActual  As Double
    Dim LastRow   As Long
    
    Set AbmObj = m_ObjAbm
    
    If IsOrden Then
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
  
  Private Function pItSaveOrdenes(ByVal RcTMPId As Long, ByRef vAplic() As T_Aplic) As Boolean
    Dim register    As cRegister
    Dim i           As Long
    Dim j           As Long
    
    For i = 1 To UBound(vAplic)
   
      If vAplic(i).oci_id <> csNO_ID Then
   
        For j = 1 To UBound(vAplic(i).vAplicaciones)
        
          If vAplic(i).vAplicaciones(j).rci_id <> csNO_ID Then
        
            With vAplic(i).vAplicaciones(j)
              
              If .Aplicado > 0 Then
          
                Set register = New cRegister
                register.fieldId = cscOcRcTMPid
                register.Table = csTOrdenRemitoCompraTMP
                register.Id = csNew
                
                register.fields.Add2 cscRcTMPId, RcTMPId, csId
                register.fields.Add2 cscOciId, vAplic(i).oci_id, csId
                register.fields.Add2 cscRciId, .rci_id, csId
                register.fields.Add2 cscOcRcCantidad, .Aplicado, csDouble
                
                register.fields.Add2 cscOcRcId, .vinc_id, csLong
                
                register.fields.HaveLastUpdate = False
                register.fields.HaveWhoModify = False
                
                If Not gDB.Save(register, , "pItSaveOrdenes", C_Module, c_ErrorSave) Then Exit Function
              End If
            End With
          End If
        Next
      End If
    Next
    
    pItSaveOrdenes = True
  End Function
  
'////////////////////////////////////////////////////////////////////////////////////
'
'   construccion - destruccion
'
'////////////////////////////////////////////////////////////////////////////////////
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  ReDim m_vOrdenes(0)
  ReDim m_vOrdenes(0).vAplicaciones(0)
  
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
  ReDim m_vOrdenes(0)
  
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
'   ORDENES / REMITOS
'
'////////////////////////////////////////////////////////////////////////////////////

  Private Function pItLoadFacDev(ByRef iProp As cIABMProperty) As Boolean
    pItLoadFacDev = pItLoadItemsAux(iProp, False)
  End Function
  
  Private Function pItSetGridAplicFacDev(ByRef iProp As cIABMProperty) As Boolean
    pItSetGridAplicFacDev = pItSetGridAplicAux(iProp, False)
  End Function

  Private Function pItSaveFacDev(ByVal RcTMPId As Long, ByRef vAplic() As T_Aplic) As Boolean
    Dim register    As cRegister
    Dim i           As Long
    Dim j           As Long
    
    For i = 1 To UBound(vAplic)
   
      If vAplic(i).fci_id <> csNO_ID Or vAplic(i).rci_id <> csNO_ID Then
   
        For j = 1 To UBound(vAplic(i).vAplicaciones)
        
          If vAplic(i).vAplicaciones(j).rci_id <> csNO_ID Then
        
            With vAplic(i).vAplicaciones(j)
              
              If .Aplicado > 0 Then
          
                Set register = New cRegister
                
                ' Si estoy vinculando contra una factura
                If vAplic(i).fci_id <> 0 Then
                  register.fieldId = cscRcFcTMPId
                  register.Table = csTRemitoFacturaCompraTMP
                  register.fields.Add2 cscFciId, vAplic(i).fci_id, csId
                  register.fields.Add2 cscRciId, .rci_id, csId
                
                  register.fields.Add2 cscRcFcCantidad, .Aplicado, csDouble
                  register.fields.Add2 cscRcFcId, .vinc_id, csLong
                
                ' Si vinculo contra un remito (Remito - Devolucion)
                Else
                  register.fieldId = cscRcDcTMPId
                  register.Table = csTRemitoDevolucionCompraTMP
                  
                  If m_IsDevolucion Then
                    register.fields.Add2 cscRciIdDevolucion, .rci_id, csId
                    register.fields.Add2 cscRciIdRemito, vAplic(i).rci_id, csId
                  Else
                    register.fields.Add2 cscRciIdRemito, .rci_id, csId
                    register.fields.Add2 cscRciIdDevolucion, vAplic(i).rci_id, csId
                  End If
                
                  register.fields.Add2 cscRcDcCantidad, .Aplicado, csDouble
                  register.fields.Add2 cscRcDcId, .vinc_id, csLong
                
                End If
                
                register.Id = csNew
                register.fields.Add2 cscRcTMPId, RcTMPId, csId
                
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
