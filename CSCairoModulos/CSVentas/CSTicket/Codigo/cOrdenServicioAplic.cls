VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cOrdenServicioAplic"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cOrdenServicioAplic
' 18-11-2006

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cOrdenServicioAplic"

'////////////////////////////////////////////////////////////////////////////////////
'
'   PRESTACIONES
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private Const cscNroDoc                          As String = "nrodoc"
  Private Const cscPendiente                       As String = "Pendiente"
  Private Const cscImporte                         As String = "Importe"
  Private Const cscVincId                          As String = "vinc_id"
'////////////////////////////////////////////////////////////////////////////////////
'
'   REMITO - SOLAPA
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private Const K_REMITO = 20
  Private Const K_APLIC_REMITO = 21
  Private Const c_Remito = "Remito"
  Private Const c_AplicRemito = "AplicRemito"
  
  ' Remito
  Private Const cscFecha            As String = "Fecha"
  Private Const cscAplicado         As String = "Aplicado"
  Private Const cscAplicRemito      As String = "AplicRemito"
  
  ' Grillas de Remitos / Ordenes
  Private Const KII_osi_ID                  As Integer = 1
  Private Const KII_PR_ID                   As Integer = 2
  Private Const KII_APLICADO                As Integer = 4
  Private Const KII_APLICADO2               As Integer = 5
  Private Const KII_PENDIENTE               As Integer = 6
  
  Private Const KIP_osrv_ID                 As Integer = 1
  
  Private Const KIP_RVI_ID                  As Integer = 3
  
  Private Const KIP_DOC                     As Integer = 7
  Private Const KIP_FECHA                   As Integer = 8
  Private Const KIP_PENDIENTE               As Integer = 9
  Private Const KIP_APLICADO                As Integer = 11
  Private Const KIP_APLICADO2               As Integer = 12
  Private Const KIP_NRODOC                  As Integer = 15
  Private Const KIP_IDX1                    As Integer = 16
  Private Const KIP_IDX2                    As Integer = 17

' estructuras

'////////////////////////////////////////////////////////////////////////////////////
'
'   REMITOS / REMITOS
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private Type T_ItAplic
    vinc_id                 As Long   ' lo uso para osrv_id
    osi_id                  As Long   ' Ids de items al que este credito esta vinculado
    
    Aplicado                As Double
  End Type
  
  Private Type T_Aplic
                                    ' Vinculacion con
                                    
    rvi_id                  As Long ' Remito
    
    pr_id                   As Long
    
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

' pseudo-constantes
Private c_ErrorSave As String

' generales

Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric
Private m_GeneralConfig     As cGeneralConfig
Private m_OsId              As Long
Private m_PvNumero          As String
Private m_Cliente           As String
Private m_CliId             As Long
Private m_DocId             As Long
Private m_SucId             As Long
Private m_Total             As Double

Private m_MonDefault        As Long

Private m_LastRowItem       As Long
Private m_LastRowRemito     As Long

' Edit Apply
'
Private m_ObjectClient      As cOrdenServicio
Private m_emp_id            As Long
Private m_emp_nombre        As String

'////////////////////////////////////////////////////////////////////////////////////
'
'   REMITOS / REMITOS
'
'////////////////////////////////////////////////////////////////////////////////////
  
  Private m_vRemitos()        As T_Aplic
  Private m_osi_id            As Long

' eventos
' propiedades publicas

' Edit Apply
'
Public Property Set ObjectClient(ByVal rhs As cOrdenServicio)
  Set m_ObjectClient = rhs
End Property

Public Property Get Id() As Long
  Id = m_OsId
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Show(ByVal OsId As Long, ByVal Total As Double, _
                     ByVal PvNumero As String, _
                     ByVal CliId As Long, ByVal Cliente As String, _
                     ByVal SucId As Long, ByVal DocId As Long) As Boolean
  
  If m_ObjAbm Is Nothing Then
    Set m_ObjAbm = New cABMGeneric
  End If
  
  If m_OsId <> OsId Then
    m_OsId = OsId
    m_PvNumero = PvNumero
    m_Cliente = Cliente
    m_CliId = CliId
    m_DocId = DocId
    m_SucId = SucId
    m_Total = Total
    
    ' Edit Apply
    '
    If Not gDB.GetData(csTOrdenServicio, _
                       cscOsId, _
                       m_OsId, _
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
        
        Select Case iProp.key
          
          Case K_REMITO
          
            Set AbmObj = m_ObjAbm
            
            ' Guardo la aplicacion para el item editado anteriormente
            '
            If m_LastRowRemito <> 0 Then
              Aplicado = pItUpdateGrids(m_vRemitos)
            End If
            
            ' Muestro las aplicaciones para este item
            '
            m_LastRowRemito = iProp.SelectedIndex
            Set Row = iProp.Grid.Rows(m_LastRowRemito)
            If Row Is Nothing Then Exit Function
            
            pItSetAplicItems m_ObjAbm.Properties(c_AplicRemito), _
                             pCell(Row, KII_osi_ID).Id, _
                             pCell(Row, KII_PR_ID).Id, m_vRemitos
            
            AbmObj.ShowValue m_ObjAbm.Properties(c_AplicRemito), True
          
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
  
  Private Function cIABMClient_PropertyChange(ByVal key As Integer) As Boolean
  End Function
  
  Private Function cIABMClient_Save() As Boolean
    cIABMClient_Save = pSave
  End Function
  
  Private Function cIABMClient_Terminate() As Boolean
    m_Editing = False
    cIABMClient_Terminate = True
    m_OsId = csNO_ID
    Set m_ObjAbm = Nothing
    
    ' Edit Apply
    '
    Set m_ObjectClient = Nothing
  End Function
  
  Private Property Get cIABMClient_Title() As String
    On Error Resume Next
    cIABMClient_Title = LNGGetText(2287, vbNullString)  'Aplicación Orden de Servicio
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

  Private Function cIABMClientGrid_IsEmptyRow(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
    cIABMClientGrid_IsEmptyRow = False
  End Function
  
  Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
    On Error GoTo ControlError
    Select Case key
      Case K_APLIC_REMITO
        cIABMClientGrid_ColumnAfterUpdate = pItColAUpdate(pItGetItemsProperty(), lRow, lCol)
    End Select
  
    GoTo ExitProc
ControlError:
    MngError Err, "cIABMClientGrid_ColumnAfterUpdate", C_Module, vbNullString
    If Err.Number Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Function
  
  Private Function cIABMClientGrid_ColumnAfterEdit(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
    cIABMClientGrid_ColumnAfterEdit = True
  End Function
  
  Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
    On Error GoTo ControlError
    Select Case key
      Case K_APLIC_REMITO
        cIABMClientGrid_ColumnBeforeEdit = pItColBEdit(pItGetItemsProperty(), lRow, lCol, iKeyAscii)
    End Select
    GoTo ExitProc
ControlError:
    MngError Err, "cIABMClientGrid_ColumnBeforeEdit", C_Module, vbNullString
    If Err.Number Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Function
  
  Private Function cIABMClientGrid_ColumnButtonClick(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  
  End Function
  
  Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal key As Integer)
  
  End Sub
  
  Private Sub cIABMClientGrid_ColumnClick(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long)
  
  End Sub
  
  Private Sub cIABMClientGrid_DblClick(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long)
    On Error GoTo ControlError
    
    Dim Id As Long
    
    Select Case key

      Case K_APLIC_REMITO

        With pItGetItemsAplic().Rows
          
          Dim ObjEditName As String
                    
          Id = pCell(.Item(lRow), KIP_RVI_ID).Id
          
          If Id <> csNO_ID Then
            
            If Not gDB.GetData("RemitoVentaItem", _
                               "rvi_id", _
                               Id, _
                               "rv_id", _
                               Id) Then Exit Sub
            
            ObjEditName = "CSVenta2.cRemitoVenta"
            
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
  
  Private Function cIABMClientGrid_DeleteRow(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  
  End Function
  
  Private Function cIABMClientGrid_ListAdHock(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean
  
  End Function
  
  Private Sub cIABMClientGrid_NewRow(ByVal key As Integer, ByVal Rows As Integer)
    
  End Sub
  
  Private Function cIABMClientGrid_ValidateRow(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
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
    m_LastRowRemito = 0
    
    m_ObjAbm.Properties.Clear
    
    With m_ObjAbm.Tabs
      
      .Clear
          
      With .Add(Nothing)
        .Name = LNGGetText(1722, vbNullString) 'Remitos
      End With
    
    End With
    
    Set c = m_ObjAbm.Properties.Add(Nothing, c_Remito)
    c.PropertyType = cspGrid
    c.LeftLabel = -1
    If Not pItLoadRemito(c) Then Exit Function
    c.key = K_REMITO
    c.Name = LNGGetText(1606, vbNullString) 'Items2
    c.Width = 9400
    c.Left = 250
    c.Height = 2600
    c.GridEdit = False
    c.GridAdd = False
    c.GridRemove = False
    Set oGrd = c.Grid
    oGrd.RowSelect = True
    oGrd.DontSelectInGotFocus = True
  
    Set c = m_ObjAbm.Properties.Add(Nothing, c_AplicRemito)
    c.PropertyType = cspGrid
    c.LeftLabel = -1
    If Not pItSetGridAplicRemito(c) Then Exit Function
    c.key = K_APLIC_REMITO
    c.Name = LNGGetText(1607, vbNullString) 'Facturas
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
    
    Dim OsTMPId As Long
    
    pItUpdateGrids m_vRemitos
    
    ' Temporal
    If Not pSaveDocVta(m_DocId, OsTMPId) Then Exit Function
  
    ' Remitos
    If Not pItSaveRemito(OsTMPId, m_vRemitos) Then Exit Function
    
    ' Aplico llamando al sp
    Dim sqlstmt As String
    Dim rs      As Recordset
    
    sqlstmt = "sp_DocOrdenServicioSaveAplic " & OsTMPId
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
  ' OrdenServicioTemporal
  '////////////////////////////////////////////////////////////////////////////////////
  Private Function pSaveDocVta(ByVal DocId As Long, _
                               ByRef OsTMPId As Long) As Boolean
    Dim register     As cRegister
    
    Set register = New cRegister
    register.fieldId = cscOsTMPId
    register.table = csTOrdenServicioTMP
  
    register.Id = csNew
    register.Fields.Add2 cscOsId, m_OsId, csId
  
    register.Fields.Add2 cscOsNumero, 0, csLong
    register.Fields.Add2 cscOsNrodoc, vbNullString, csText
    
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
  
    OsTMPId = register.Id
    pSaveDocVta = True
  End Function

'////////////////////////////////////////////////////////////////////////////////////
'
'   Ordenes
'
'////////////////////////////////////////////////////////////////////////////////////

  Private Function pItLoadAplicItems() As Boolean
    
    If Not pItLoadAplicAplicados(m_vRemitos) Then Exit Function
    If Not pItLoadAplicCreditos(m_vRemitos) Then Exit Function
    
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
  
    sqlstmt = "sp_DocOrdenServicioGetAplic " & EmpId & "," & m_OsId & ",1"
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pItLoadItems", C_Module) Then Exit Function
  
    iProp.Grid.Columns.Clear
    iProp.Grid.Rows.Clear
  
    Set Grid = iProp.Grid
  
    With Grid.Columns
      With .Add(Nothing)
        .Visible = False
        .key = KII_osi_ID
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1619, vbNullString) 'Producto
        .PropertyType = cspText
        .Width = 2500
        .key = KII_PR_ID
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1609, vbNullString) 'Pendiente
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1245
        .key = KII_PENDIENTE
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1608, vbNullString) 'Aplicado
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1245
        .key = KII_APLICADO
      End With
    
      With .Add(Nothing)
        .Visible = False
        .key = KII_APLICADO2
      End With
    End With
    
    Dim F  As cIABMGridRow
    Dim fv As cIABMGridCellValue
  
    While Not rs.EOF
  
      Set F = iProp.Grid.Rows.Add(Nothing)
  
      Set fv = F.Add(Nothing)
      fv.Id = gDB.ValField(rs.Fields, cscOsiId)
      fv.key = KII_osi_ID
  
      Set fv = F.Add(Nothing)
      fv.Id = gDB.ValField(rs.Fields, cscPrId)
      fv.Value = gDB.ValField(rs.Fields, cscPrNombreventa)
      fv.key = KII_PR_ID
  
      Set fv = F.Add(Nothing)
      fv.Value = gDB.ValField(rs.Fields, cscOsiPendiente)
      fv.key = KII_PENDIENTE
      
      Value = gDB.ValField(rs.Fields, cscAplicRemito)
      Set fv = F.Add(Nothing)
      fv.Value = Value
      fv.key = KII_APLICADO
      
      If Value <> 0 Then
        Set Row = F
        Row.BackColor = &HFFCC99
      End If
      
      Set fv = F.Add(Nothing)
      fv.Value = Value
      fv.key = KII_APLICADO2
      
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
        .key = KIP_IDX1
      End With
    
      With .Add(Nothing)
        .Visible = False
        .key = KIP_IDX2
      End With
      
      With .Add(Nothing)
        .Visible = False
        .key = KIP_osrv_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .key = KIP_RVI_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1567, vbNullString) 'Documento
        .PropertyType = cspText
        .Width = 2925
        .key = KIP_DOC
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1610, vbNullString) 'Comprobante
        .PropertyType = cspText
        .Width = 1575
        .key = KIP_NRODOC
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1569, vbNullString) 'Fecha
        .PropertyType = cspDate
        .Width = 1395
        .key = KIP_FECHA
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1609, vbNullString) 'Pendiente
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1245
        .key = KIP_PENDIENTE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1608, vbNullString) 'Aplicado
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1245
        .key = KIP_APLICADO
      End With
      
      With .Add(Nothing)
        .Visible = False
        .key = KIP_APLICADO2
      End With
    End With
    
    pItSetGridAplicAux = True
  End Function
  
  Private Function pItLoadAplicAplicados(ByRef vAplic() As T_Aplic) As Boolean
    Dim sqlstmt       As String
    Dim rs            As ADODB.Recordset
    Dim i             As Long
    Dim Idx           As Long
    
    sqlstmt = "sp_DocOrdenServicioGetAplic " & EmpId & "," & m_OsId & ",2"
    
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadAplicAplicados", C_Module) Then Exit Function
    
    ReDim vAplic(0)
    ReDim vAplic(0).vAplicaciones(0)
    
    If Not rs.EOF Then
    
      rs.MoveLast
      rs.MoveFirst
    
      While Not rs.EOF
            
        i = pItAddToCreditos(csNO_ID, _
                             gDB.ValField(rs.Fields, cscRviId), _
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
          
          ' Remito
          '
          .rvi_id = gDB.ValField(rs.Fields, cscRviId)
          
          .pr_id = gDB.ValField(rs.Fields, cscPrId)
          
          ' Aplicaciones
          With .vAplicaciones(Idx)
          
            .vinc_id = gDB.ValField(rs.Fields, cscVincId)
              
            .osi_id = gDB.ValField(rs.Fields, cscOsiId)
            
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
    
    sqlstmt = "sp_DocOrdenServicioGetAplic " & EmpId & "," & m_OsId & ",3"
    
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadAplicCreditos", C_Module) Then Exit Function
    
    If Not rs.EOF Then
      
      rs.MoveLast
      rs.MoveFirst
    
      i = UBound(vAplic)
      ReDim Preserve vAplic(i + rs.RecordCount)
      
      While Not rs.EOF
            
        i = i + 1
        With vAplic(i)
          .pr_id = gDB.ValField(rs.Fields, cscPrId)
          .rvi_id = gDB.ValField(rs.Fields, cscRviId)
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
  
  Private Function pItAddToCreditos(ByVal PkiId As Long, _
                                    ByVal RviId As Long, _
                                    ByRef Idx As Long, _
                                    ByRef vAplic() As T_Aplic) As Long
    Dim i As Long
    
    For i = 1 To UBound(vAplic)
      With vAplic(i)
        If (.rvi_id = RviId And RviId <> csNO_ID) Then
           
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
    
    Set iProp = m_ObjAbm.Properties(c_Remito)
    Set iPropAplic = m_ObjAbm.Properties(c_AplicRemito)
    LastRow = m_LastRowRemito
    
    If LastRow <> 0 Then
      
      Set Row = iProp.Grid.Rows(LastRow)
      pItUpdateGrids = pItUpdateAplicItems(iPropAplic, _
                                           pCell(Row, KII_osi_ID).Id, _
                                           vAplic)
    End If
  End Function
  
  Private Function pItSetAplicItems(ByRef iProp As cIABMProperty, _
                                    ByVal osi_id As Long, _
                                    ByVal pr_id As Long, _
                                    ByRef vAplic() As T_Aplic) As Boolean
    Dim Cotizacion    As Double
    Dim i             As Long
    Dim j             As Long
    
    iProp.Grid.Rows.Clear
    
    m_osi_id = osi_id
    
    For i = 1 To UBound(vAplic)
    
      If vAplic(i).pr_id = pr_id Then
    
        If UBound(vAplic(i).vAplicaciones) > 0 Then
          pItSetAplicItemsAux1 i, iProp, osi_id, vAplic
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
      
      If vAplic(i).pr_id = pr_id Then
      
        For Each Row In iProp.Grid.Rows
        
          Id = pCell(Row, KIP_RVI_ID).Id
          If Id = vAplic(i).rvi_id And Id <> csNO_ID Then
            bAplic = True
            Exit For
          End If
        
          Id = m_osi_id
          For j = 1 To UBound(vAplic(i).vAplicaciones)
            If Id = vAplic(i).vAplicaciones(j).osi_id And Id <> csNO_ID Then
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
                                       ByVal osi_id As Long, _
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
  
  Private Sub pItSetAplicItemsAux1(ByVal Idx As Long, ByRef iProp As cIABMProperty, ByVal osi_id As Long, _
                                   ByRef vAplic() As T_Aplic)
    Dim F               As cIABMGridRow
    Dim fv              As cIABMGridCellValue
    Dim i               As Long
    Dim iPropItem       As cIABMProperty
    Dim Row             As cABMGridRow
    
    For i = 1 To UBound(vAplic(Idx).vAplicaciones)
    
      With vAplic(Idx).vAplicaciones(i)
    
        If .osi_id = osi_id And osi_id <> csNO_ID Then
        
          Set F = iProp.Grid.Rows.Add(Nothing)
          
          Set fv = F.Add(Nothing)
          fv.Id = Idx
          fv.key = KIP_IDX1
          
          Set fv = F.Add(Nothing)
          fv.Id = i
          fv.key = KIP_IDX2
          
          Set fv = F.Add(Nothing)
          fv.Id = .vinc_id
          fv.key = KIP_osrv_ID
          
          Set fv = F.Add(Nothing)
          fv.Id = vAplic(Idx).rvi_id
          fv.key = KIP_RVI_ID
          
          Set fv = F.Add(Nothing)
          fv.Value = vAplic(Idx).docNombre
          fv.key = KIP_DOC
          
          Set fv = F.Add(Nothing)
          fv.Value = vAplic(Idx).NroDoc
          fv.key = KIP_NRODOC
          
          Set fv = F.Add(Nothing)
          If vAplic(Idx).Fecha = csNoDate Then
            fv.Value = vbNullString
          Else
            fv.Value = vAplic(Idx).Fecha
          End If
          fv.key = KIP_FECHA
      
          Set fv = F.Add(Nothing)
          fv.Value = vAplic(Idx).Pendiente
          fv.key = KIP_PENDIENTE
          
          Set fv = F.Add(Nothing)
          fv.Value = .Aplicado
          fv.key = KIP_APLICADO
          
          Set fv = F.Add(Nothing)
          fv.Value = .Aplicado
          fv.key = KIP_APLICADO2
          
          Set Row = F
          Row.BackColor = &HFFCC99
        End If
      End With
    Next
  End Sub

  Private Sub pItSetAplicItemsAux2(ByVal i As Long, ByRef iProp As cIABMProperty, _
                                   ByRef vAplic() As T_Aplic)
    Dim F             As cIABMGridRow
    Dim fv            As cIABMGridCellValue
    
    If vAplic(i).Pendiente <= 0 Then Exit Sub
    
    With vAplic(i)
  
      Set F = iProp.Grid.Rows.Add(Nothing)
      
      Set fv = F.Add(Nothing)
      fv.Id = i
      fv.key = KIP_IDX1
      
      Set fv = F.Add(Nothing)
      fv.Id = 0
      fv.key = KIP_IDX2
      
      Set fv = F.Add(Nothing)
      fv.Id = csNO_ID
      fv.key = KIP_osrv_ID
      
      Set fv = F.Add(Nothing)
      fv.Id = .rvi_id
      fv.key = KIP_RVI_ID
      
      Set fv = F.Add(Nothing)
      fv.Value = .docNombre
      fv.key = KIP_DOC
      
      Set fv = F.Add(Nothing)
      fv.Value = .NroDoc
      fv.key = KIP_NRODOC
      
      Set fv = F.Add(Nothing)
      If .Fecha = csNoDate Then
        fv.Value = vbNullString
      Else
        fv.Value = .Fecha
      End If
      fv.key = KIP_FECHA
  
      Set fv = F.Add(Nothing)
      fv.Value = .Pendiente
      fv.key = KIP_PENDIENTE
      
      Set fv = F.Add(Nothing)
      fv.Value = 0
      fv.key = KIP_APLICADO
      
      Set fv = F.Add(Nothing)
      fv.Value = 0
      fv.key = KIP_APLICADO2
    End With
  End Sub

  Private Function pItAddToAplic(ByRef vAplicaciones() As T_ItAplic, ByVal Importe As Double, ByVal Idx As Long) As Double
    Dim i    As Long
    Dim rtn  As Double
    
    If Idx = 0 Then
      ReDim Preserve vAplicaciones(UBound(vAplicaciones) + 1)
      Idx = UBound(vAplicaciones)
      With vAplicaciones(Idx)
        .osi_id = m_osi_id
      End With
    End If
    
    vAplicaciones(Idx).Aplicado = Importe
    
    For i = 1 To UBound(vAplicaciones)
      rtn = rtn + vAplicaciones(i).Aplicado
    Next
    
    pItAddToAplic = rtn
  End Function

  Private Function pItGetItemsProperty() As cIABMProperty
    Set pItGetItemsProperty = m_ObjAbm.Properties(c_AplicRemito)
  End Function
  
  Private Function pItGetItemsAplic() As cIABMGrid
    Set pItGetItemsAplic = m_ObjAbm.Properties(c_AplicRemito).Grid
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
    
    Set iProp = m_ObjAbm.Properties(c_Remito)
    
    Set pItGetItemPendiente = pCell(iProp.Grid.Rows(iProp.SelectedIndex), KII_PENDIENTE)
  End Function
  
  Private Function pItGetItemAplicado() As cIABMGridCellValue
    Dim iProp As cIABMProperty
    
    Set iProp = m_ObjAbm.Properties(c_Remito)
    
    Set pItGetItemAplicado = pCell(iProp.Grid.Rows(iProp.SelectedIndex), KII_APLICADO2)
  End Function
  
  Private Function pItColAUpdate(ByRef IProperty As cIABMProperty, _
                                 ByVal lRow As Long, _
                                 ByVal lCol As Long)
    Dim Row        As cIABMGridRow
    Dim MaxVal     As Double
    Dim bVisible   As Boolean
    Dim Pendiente  As Double
    
    With IProperty.Grid
      Select Case .Columns(lCol).key
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
    
    Set iProp = m_ObjAbm.Properties(c_AplicRemito)
    
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
    
    Set iProp = m_ObjAbm.Properties(c_Remito)
    LastRow = m_LastRowRemito
    
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

  c_ErrorSave = LNGGetText(1831, vbNullString)
                'Error al grabar la Orden de Servicio

  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  ReDim m_vRemitos(0)
  ReDim m_vRemitos(0).vAplicaciones(0)
  
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
  
  ReDim m_vRemitos(0)
  
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

  Private Function pItLoadRemito(ByRef iProp As cIABMProperty) As Boolean
    pItLoadRemito = pItLoadItemsAux(iProp)
  End Function
  
  Private Function pItSetGridAplicRemito(ByRef iProp As cIABMProperty) As Boolean
    pItSetGridAplicRemito = pItSetGridAplicAux(iProp)
  End Function

  Private Function pItSaveRemito(ByVal OsTMPId As Long, ByRef vAplic() As T_Aplic) As Boolean
    Dim register    As cRegister
    Dim i           As Long
    Dim j           As Long
    
    For i = 1 To UBound(vAplic)
   
      If vAplic(i).rvi_id <> csNO_ID Then
   
        For j = 1 To UBound(vAplic(i).vAplicaciones)
        
          If vAplic(i).vAplicaciones(j).osi_id <> csNO_ID Then
        
            With vAplic(i).vAplicaciones(j)
              
              If .Aplicado > 0 Then
          
                Set register = New cRegister
              
                register.fieldId = cscOsRvTMPid
                register.table = csTOrdenRemitoVentaTMP
                register.Fields.Add2 cscRviId, vAplic(i).rvi_id, csId
                register.Fields.Add2 cscOsiId, .osi_id, csId
                
                register.Fields.Add2 cscOsRvCantidad, .Aplicado, csDouble
                register.Fields.Add2 cscOsRvId, .vinc_id, csLong
                
                register.Id = csNew
                register.Fields.Add2 cscOsTMPId, OsTMPId, csId
                
                register.Fields.HaveLastUpdate = False
                register.Fields.HaveWhoModify = False
                
                If Not gDB.Save(register, , "pItSaveRemito ", C_Module, c_ErrorSave) Then Exit Function
              End If
            End With
          End If
        Next
      End If
    Next
    
    pItSaveRemito = True
  End Function
