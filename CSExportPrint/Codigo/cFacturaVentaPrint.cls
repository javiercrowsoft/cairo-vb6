VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFacturaVentaPrint"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cFacturaVentaPrint
' 07-10-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cFacturaVentaPrint"

Private Const c_Items = "ITEMS"

Private Const K_IDIOMA                         As Integer = 1
Private Const K_FV_ID                          As Integer = 2
Private Const K_ITEMS                          As Integer = 3

Private Const KI_egp_ID                         As Integer = 1
Private Const KI_CODIGO                        As Integer = 2
Private Const KI_LEY_ID                        As Integer = 3
Private Const KI_TEXTO                         As Integer = 4
Private Const KI_POSARANCEL                    As Integer = 5
Private Const KI_UNIDAD                        As Integer = 6
Private Const KI_TITULO                        As Integer = 7
Private Const KI_OBLIGATORIO                   As Integer = 8

' estructuras
' Seudo - Variables
Private c_ErrorSave                    As String

' variables privadas
Private m_idm_id                       As Long
Private m_Idioma                       As String
Private m_fv_id                        As Long
Private m_fvNroDoc                     As String

Private m_LastIdm_id                   As Long

'Private m_Modificado                   As Date
'Private m_Modifico                     As Long
'Private m_Activo                       As Boolean

'OJO HASTA ACA

Private m_rptName           As String
Private m_rptFile           As String
Private m_Action            As csRptLaunchAction
Private m_Copies            As Long
Private m_Path              As String

Private m_ConnectionTimeout             As Long
Private m_CommandTimeout                As Long

Private m_ObjAbm            As cIABMGeneric

Private m_IsNew             As Boolean

' eventos
' Properties publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function DoPrint(ByVal rptName As String, _
                        ByVal rptFile As String, _
                        ByVal Action As csRptLaunchAction, _
                        ByVal Copies As Long, _
                        ByVal strId As String, _
                        ByVal Path As String, _
                        ByVal CommandTimeout As Long, _
                        ByVal ConnectionTimeout As Long) As Boolean
                        
  Dim Id As Long
  
  Id = Val(strId)
  m_rptName = rptName
  m_rptFile = rptFile
  m_Action = Action
  m_Copies = Copies
  m_Path = Path
  m_ConnectionTimeout = ConnectionTimeout
  m_CommandTimeout = CommandTimeout
  
  Set m_ObjAbm = New CSABMInterface2.cABMGeneric
  pGetFvNumero Id
  cIEditGeneric_Edit Id, False
  
  DoPrint = True
End Function

' funciones friend

' Implementacion de cIABMClient
Private Property Get cIABMClient_Aplication() As String
  cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
End Property

Private Property Get cIABMClient_CanNew() As Boolean
End Property

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Function cIABMClient_ShowDocDigital() As Boolean
End Function

Private Function cIABMClient_EditNew() As Boolean
  cIEditGeneric_Edit csNO_ID
End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_Copy() As Boolean
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  Select Case Key
    Case K_IDIOMA
      Dim idm_id As Long
      Dim iProp  As cIABMProperty
      
      With m_ObjAbm.Properties
        idm_id = .Item(cscIdmId).HelpId
        Set iProp = .Item(c_Items)
      End With
  
      iProp.Enabled = idm_id <> csNO_ID
  
      If idm_id <> m_LastIdm_id Then
        m_LastIdm_id = idm_id
        pLoadItems iProp, idm_id
        m_ObjAbm.ShowValue iProp
      End If
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  Dim IProperty As cIABMProperty
  Dim register As cRegister
  
  Set register = New cRegister
  register.fieldId = cscEfvId
  register.Table = csTExpoFacturaVenta
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  Dim idm_id As Long
  Dim Idioma As String
  
  With m_ObjAbm.Properties.Item(cscIdmId)
    idm_id = .HelpId
    Idioma = .Value
  End With
  
  If Not pDelete(idm_id) Then Exit Function
  
  register.Id = csNO_ID
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_IDIOMA
          register.Fields.Add2 cscEfvTexto, .HelpId, csText
          register.Fields.Add2 cscEfvCodigo, cscIdmId, csText
          register.Fields.Add2 cscFvId, m_fv_id, csId
          register.Fields.Add2 cscIdmId, idm_id, csId
      End Select
    End With
  Next
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  If Not pSaveItems(idm_id) Then Exit Function
  
  If Not register.CommitTrans() Then Exit Function
  
  m_idm_id = idm_id
  m_Idioma = Idioma
  
  pPrint m_rptName, m_rptFile, m_Action, m_Copies
  
  cIABMClient_Save = True
End Function

Private Function cIABMClient_Terminate() As Boolean
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(3277, vbNullString) 'ExportPrint Factura de Exportación
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_IDIOMA
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(3278, vbNullString) 'Debe indicar un Idioma
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

' Implementacion de cIEditGeneric

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal rhs As Long)
End Property

Private Property Get cIEditGeneric_TreeId() As Long
End Property

Private Function cIEditGeneric_GridAdd(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
    cIEditGeneric_ShowList = False
End Function

Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  cIEditGeneric_Delete = False
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  m_IsNew = Id = csNO_ID
  m_fv_id = Id
  
  m_ObjAbm.InModalWindow = InModalWindow
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.OkCancelDialog = True
  
  If Not LoadCollection() Then Exit Function
    
  Exit Function
ControlError:
  MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal Id As Long) As Boolean

End Function

Private Property Set cIEditGeneric_ObjTree(rhs As Object)
End Property

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)
End Property

Private Property Get cIEditGeneric_BranchId() As Long
End Property

Private Function cIEditGeneric_Preview(ByVal Id As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim iTab    As cIABMTabItem
  Dim c       As cIABMProperty
  
  m_ObjAbm.Tabs.Clear
  m_ObjAbm.Properties.Clear
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = 0
  iTab.Name = C_strGeneral
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = 1
  iTab.Name = LNGGetText(1371, vbNullString) 'Items
  
  Set c = m_ObjAbm.Properties.Add(Nothing, "label1")
  c.PropertyType = cspLabel
  c.Value = LNGGetText(3279, vbNullString)
            'Seleccione un idioma y luego _
            podrá modificar los textos de la Factura en la solapa Items
  c.FontBold = True
  c.Width = 4000
  c.Height = 700
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscFvId)
  c.PropertyType = cspText
  c.Name = LNGGetText(1866, vbNullString) 'Factura
  c.Key = K_FV_ID
  c.Value = m_fvNroDoc
  c.Enabled = False

  Set c = m_ObjAbm.Properties.Add(Nothing, cscIdmId)
  c.PropertyType = cspHelp
  c.Table = csIdioma
  c.Name = LNGGetText(1239, vbNullString) 'Idioma
  c.Size = 100
  c.Key = K_IDIOMA
  c.Value = m_Idioma
  c.HelpId = m_idm_id
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_Items)
  c.PropertyType = cspGrid
  If Not pLoadItems(c, m_idm_id) Then Exit Function
  c.Name = c_Items
  c.Key = K_ITEMS
  c.TabIndex = 1
  c.Enabled = m_idm_id <> csNO_ID
  c.GridAdd = False
  c.GridEdit = True
  c.GridRemove = False
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  m_ObjAbm.ObjForm.cmdsave.Caption = LNGGetText(1835, vbNullString) 'Imprimir
  
  LoadCollection = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty, ByVal idm_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_ExpoFacturaVentaGet " & m_fv_id & "," & idm_id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  Dim o         As cIABMGridColumn
  Dim egp_id  As Long
  
  Propiedad.Grid.Columns.Clear
  Propiedad.Grid.Rows.Clear
  
  With Propiedad.Grid.Columns
    .Add(Nothing).Visible = False
  
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_egp_ID
    
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_OBLIGATORIO
  
    Set o = .Add(Nothing)
    o.Name = C_strCodigo
    o.PropertyType = cspText
    o.Width = 1800
    o.Key = KI_CODIGO
    o.Enabled = False
  
    Set o = .Add(Nothing, cscLeyId)
    o.Name = LNGGetText(1240, vbNullString) 'Leyenda
    o.PropertyType = cspHelp
    o.Table = csLeyenda
    o.HelpFilter = "idm_id = " & idm_id
    o.Width = 1800
    o.Key = KI_LEY_ID
  
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1005, vbNullString) 'Texto
    o.PropertyType = cspText
    o.SubType = cspTextButtonEx
    o.Width = 1800
    o.Key = KI_TEXTO
  
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1864, vbNullString) 'Titulo
    o.PropertyType = cspText
    o.Width = 1800
    o.Key = KI_TITULO
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1165, vbNullString) 'Unidad
    o.PropertyType = cspText
    o.Width = 1800
    o.Key = KI_UNIDAD
  
    Set o = .Add(Nothing)
    o.Name = LNGGetText(3275, vbNullString) 'Posicion Arancel
    o.PropertyType = cspText
    o.Width = 1800
    o.Key = KI_POSARANCEL
  
  End With
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscEfvId)
    
    Set fv = F.Add(Nothing)
    fv.Id = gDB.ValField(rs.Fields, cscEgpId)
    fv.Key = KI_egp_ID
    
    Set fv = F.Add(Nothing)
    fv.Id = gDB.ValField(rs.Fields, cscObligatorio)
    fv.Key = KI_OBLIGATORIO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscEfvCodigo)
    fv.Key = KI_CODIGO
    
    Set fv = F.Add(Nothing)
    fv.Value = ""
    fv.Key = KI_LEY_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscEfvTexto)
    fv.Key = KI_TEXTO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscEfvTitulo)
    fv.Key = KI_TITULO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscEfvUnidad)
    fv.Key = KI_UNIDAD
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscEfvPosArancel)
    fv.Key = KI_POSARANCEL
    
    rs.MoveNext
  Wend
  
  pLoadItems = True
End Function

Private Sub pGetFvNumero(ByVal Id As Long)
  gDB.GetData csTFacturaVenta, cscFvId, Id, cscFvNroDoc, m_fvNroDoc
End Sub

Private Function pDelete(ByVal idm_id As Long) As Boolean
  Dim sqlstmt As String
  sqlstmt = "delete ExpoFacturaVenta where fv_id = " & m_fv_id & " and idm_id = " & idm_id
  pDelete = gDB.Execute(sqlstmt)
End Function

Private Sub pSetLeyenda(ByVal lRow As Long, ByVal lCol As Long)
  Dim Row As cIABMGridRow
  With m_ObjAbm.Properties.Item(c_Items).Grid
  
    If .Columns(lCol).Key = KI_LEY_ID Then
      Set Row = .Rows(lRow)
      Dim ley_id As Long
      ley_id = pCell(Row, KI_LEY_ID).Id
      If ley_id <> csNO_ID Then
        pCell(Row, KI_TEXTO).Value = pGetTexto(ley_id)
      End If
    End If
  End With
End Sub

Private Function pGetTexto(ByVal ley_id As Long) As String
  Dim rtn As String
  gDB.GetData csTLeyenda, cscLeyId, ley_id, cscLeyTexto, rtn
  pGetTexto = rtn
End Function

Private Function pValidateRow(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bLlevaNroSerie        As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  If pCell(Row, KI_OBLIGATORIO).Id Then
  
    For Each Cell In Row
    
      Select Case Cell.Key
        Case KI_TEXTO
          If ValEmpty(Cell.Value, csText) Then
            MsgInfo LNGGetText(3280, vbNullString, pCell(Row, KI_CODIGO).Value, strRow)
                  'Debe indicar un texto para  & pCell(Row, KI_CODIGO).Value & strRow
            Exit Function
          End If
      End Select
    Next
  End If
  
  pValidateRow = True
End Function

Private Sub pPrint(ByVal rptName As String, _
                   ByVal rptFile As String, _
                   ByVal Action As csRptLaunchAction, _
                   ByVal Copies As Long)
                   
  On Error GoTo ControlError

  Dim c_OpenRpt As String
  c_OpenRpt = LNGGetText(2888, vbNullString)  'Abrir Reporte

  Dim rpt      As cReport
  'Dim RptPrint As CSReportPaint2.cReportPrint
  Dim RptPrint As cReportPrint

  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait

  Set rpt = New cReport

  If Not rpt.Init(New cReportLaunchInfo) Then Exit Sub

  'Set RptPrint = New CSReportPaint2.cReportPrint
  Set RptPrint = New cReportPrint
  Set rpt.LaunchInfo.ObjPaint = RptPrint

  rptFile = GetValidPath(m_Path) & rptFile

  Dim FileEx As CSKernelFile.cFileEx
  Set FileEx = New CSKernelFile.cFileEx
  
  If Not FileEx.FileExists(rptFile) Then
    MsgWarning LNGGetText(2889, vbNullString, rptFile), c_OpenRpt
                'El archivo;;" & rptFile & ";;no existe.;;Verifique la ubicación de los reportes.
    Exit Sub
  End If

  If Not rpt.LoadSilent(rptFile) Then
    MsgWarning LNGGetText(3105, vbNullString, rptFile, CSKernelClient2.LastErrorDescription), c_OpenRpt
              'No se pudo cargar el reporte  & rptFile & ;( & CSKernelClient2.LastErrorDescription & )
    Exit Sub
  End If

  rpt.Connect.StrConnect = gDB.StrConnect
  
  Dim ConnectAux As cReportConnect
  For Each ConnectAux In rpt.ConnectsAux
    ConnectAux.StrConnect = gDB.StrConnect
  Next
  
  With rpt.LaunchInfo
    With .Printer.PaperInfo
      .PaperSize = rpt.PaperInfo.PaperSize
      .Orientation = rpt.PaperInfo.Orientation
      .CustomHeight = rpt.PaperInfo.CustomHeight
      .CustomWidth = rpt.PaperInfo.CustomWidth
    End With
    .Copies = Copies
    .Action = Action
    .ShowPrintersDialog = True
  End With

  rpt.DescripUser = rptName

  pSetParams rpt

  If m_CommandTimeout > 0 Then rpt.Connect.CommandTimeout = m_CommandTimeout
  If m_ConnectionTimeout > 0 Then rpt.Connect.ConnectionTimeout = m_ConnectionTimeout

  rpt.LaunchInfo.InternalPreview = True

  rpt.Launch

  GoTo ExitProc
ControlError:
  MngError Err, "pPrint", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pSetParams(ByRef rpt As cReport)
  On Error Resume Next
  With rpt.Connect.Parameters
    .Item(1).Value = m_fv_id
    .Item(2).Value = m_idm_id
  End With
End Sub

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  cIABMClientGrid_IsEmptyRow = False
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  On Error GoTo ControlError
  
  pSetLeyenda lRow, lCol
  
  cIABMClientGrid_ColumnAfterUpdate = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnAfterUpdate", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
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
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean
End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)
End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  cIABMClientGrid_ValidateRow = pValidateRow(Row, RowIndex)
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

'////////////////////////////////////////////////////////////////////////////////
Private Function pSaveItems(ByVal idm_id As Long) As Boolean
  Dim register  As cRegister
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  For Each Row In m_ObjAbm.Properties(c_Items).Grid.Rows
  
    Set register = New cRegister
    register.fieldId = cscEfvId
    register.Table = csTExpoFacturaVenta
    register.Id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        Case KI_CODIGO
          register.Fields.Add2 cscEfvCodigo, Cell.Value, csText
        Case KI_TEXTO
          register.Fields.Add2 cscEfvTexto, Cell.Value, csText
        Case KI_egp_ID
          register.Fields.Add2 cscEgpId, Cell.Id, csId
        Case KI_TITULO
          register.Fields.Add2 cscEfvTitulo, Cell.Value, csText
        Case KI_UNIDAD
          register.Fields.Add2 cscEfvUnidad, Cell.Value, csText
        Case KI_POSARANCEL
          register.Fields.Add2 cscEfvPosArancel, Cell.Value, csText
      End Select
    Next
    
    register.Fields.Add2 cscIdmId, idm_id, csId
    register.Fields.Add2 cscFvId, m_fv_id, csId
    register.Fields.HaveLastUpdate = True
    register.Fields.HaveWhoModify = True
    
    If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
  Next
  
  pSaveItems = True
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(2220, vbNullString) 'Error al guardar la factura de venta

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_ObjAbm = Nothing

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
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
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
