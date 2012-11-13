VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCobranzaAplic"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cCobranzaAplic
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
Private Const C_Module = "cCobranzaAplic"

Private Const K_APLICACIONES = 1
Private Const K_PENDIENTE = 2
Private Const K_TOTAL = 3

Private Const c_Aplicaciones = "Aplic"
Private Const c_pendiente = "Pendiente"
Private Const c_total = "Total"

Private Const KI_FVCOB_ID                As Integer = 1
Private Const KI_FVD_ID                  As Integer = 2
Private Const KI_FVP_ID                  As Integer = 3
Private Const KI_FV_ID                   As Integer = 4
Private Const KI_DOC                     As Integer = 5
Private Const KI_FECHA                   As Integer = 6
Private Const KI_COTIZACION              As Integer = 7
Private Const KI_PENDIENTE               As Integer = 8
Private Const KI_PENDIENTE2              As Integer = 9
Private Const KI_APLICADO                As Integer = 10
Private Const KI_APLICADO2               As Integer = 11
Private Const KI_APLICADO3               As Integer = 12

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric
Private m_Total             As Double
Private m_GeneralConfig     As cGeneralConfig
Private m_CobzId            As Long
Private m_CobzNumero        As String
Private m_Cliente           As String

' Edit Apply
'
Private m_ObjectClient      As cCobranza
Private m_emp_id            As Long
Private m_emp_nombre        As String

' eventos
' propiedades publicas

' Edit Apply
'
Public Property Set ObjectClient(ByVal rhs As cCobranza)
  Set m_ObjectClient = rhs
End Property

Public Property Get id() As Long
  id = m_CobzId
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Show(ByVal CobzId As Long, ByVal Total As Double, ByVal CobzNumero As String, ByVal Cliente As String) As Boolean
  If m_ObjAbm Is Nothing Then
    Set m_ObjAbm = New cABMGeneric
  End If
  
  If m_CobzId <> CobzId Then
    m_CobzId = CobzId
    m_CobzNumero = CobzNumero
    m_Cliente = Cliente
    m_Total = Total
    
    ' Edit Apply
    '
    If Not gDB.GetData(csTCobranza, _
                       cscCobzId, _
                       m_CobzId, _
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
  m_CobzId = csNO_ID
  Set m_ObjAbm = Nothing

  ' Edit Apply
  '
  Set m_ObjectClient = Nothing
End Function

Private Property Get cIABMClient_Title() As String
  On Error Resume Next
  cIABMClient_Title = LNGGetText(2124, vbNullString)  'Aplicación Cobranza
  m_ObjAbm.Title2 = m_CobzNumero & " - " & m_Cliente
End Property

Private Function cIABMClient_Validate() As Boolean
  cIABMClient_Validate = True
End Function

Private Sub pEdit()
  On Error GoTo ControlError
  
  If Not LoadCollection() Then Exit Sub
  
  m_Editing = True
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", C_Module, vbNullString
End Sub

Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  
  m_ObjAbm.Properties.Clear
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_total)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.Name = LNGGetText(2125, vbNullString) 'Importe Cobrado
  c.Enabled = False
  c.Left = 2000
  c.LeftLabel = -1500
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Value = m_Total
  c.Key = K_TOTAL
  c.Width = 1400
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_pendiente)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.Name = LNGGetText(1609, vbNullString) 'Pendiente
  c.Enabled = False
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Key = K_PENDIENTE
  c.TopFromProperty = c_total
  c.Left = 6200
  c.Width = 1400
  c.LeftLabel = -1100
  

  Set c = m_ObjAbm.Properties.Add(Nothing, c_Aplicaciones)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  If Not pLoadAplic(c) Then Exit Function
  c.Key = K_APLICACIONES
  c.Width = 9400
  c.Left = 250
  c.TopToPrevious = 540
  c.GridEdit = True
  c.GridAdd = False
  c.GridRemove = False
  
  Dim AbmObj  As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 7800
  
  ' Edit Apply
  '
  AbmObj.MinWidth = 10050
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  pShowPendiente
  
  LoadCollection = True
End Function

Private Function pLoadAplic(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim Grid    As cIABMGrid
  Dim Cotizacion  As Double
  
  sqlstmt = "sp_DocCobranzaGetAplic " & EmpId & "," & m_CobzId
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadAplic", C_Module) Then Exit Function
  
  Propiedad.Grid.Columns.Clear
  Propiedad.Grid.Rows.Clear
  
  Set Grid = Propiedad.Grid
  
  With Grid.Columns
    With .Add(Nothing)
      .Visible = False
      .Key = KI_FVCOB_ID
    End With
    
    With .Add(Nothing)
      .Visible = False
      .Key = KI_FVD_ID
    End With
    
    With .Add(Nothing)
      .Visible = False
      .Key = KI_FVP_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1567, vbNullString) 'Documento
      .PropertyType = cspText
      .Width = 2925
      .Key = KI_DOC
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1610, vbNullString) 'Comprobante
      .PropertyType = cspText
      .Width = 1575
      .Key = KI_FV_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1569, vbNullString) 'Fecha
      .PropertyType = cspDate
      .Width = 1395
      .Key = KI_FECHA
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1609, vbNullString) 'Pendiente
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 1245
      .Key = KI_PENDIENTE
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1608, vbNullString) 'Aplicado
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .SubType = cspMoney
      .Width = 1245
      .Key = KI_APLICADO
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1650, vbNullString) 'Cotiz.
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Format = m_GeneralConfig.FormatDecCotizacion
      .Width = 920
      .Key = KI_COTIZACION
    End With
    
    With .Add(Nothing)
      .Visible = False
      .Key = KI_PENDIENTE2
    End With
    
    With .Add(Nothing)
      .Visible = False
      .Key = KI_APLICADO2
    End With
    
    With .Add(Nothing)
      .Visible = False
      .Key = KI_APLICADO3
    End With
  End With
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscFvCobzId)
    fv.Key = KI_FVCOB_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscFvdId)
    fv.Key = KI_FVD_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscFvpId)
    fv.Key = KI_FVP_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscDocNombre)
    fv.Key = KI_DOC
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscFvNrodoc)
    fv.id = gDB.ValField(rs.Fields, cscFvId)
    fv.Key = KI_FV_ID
    
    Set fv = F.Add(Nothing)
    If IsNull(rs.Fields(cscFvdFecha)) Then
      If IsNull(rs.Fields(cscFvpFecha)) Then
        fv.Value = vbNullString
      Else
        fv.Value = gDB.ValField(rs.Fields, cscFvpFecha)
      End If
    Else
      fv.Value = gDB.ValField(rs.Fields, cscFvdFecha)
    End If
    fv.Key = KI_FECHA

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscFvdPendiente)
    fv.Key = KI_PENDIENTE
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscFvCobzImporte)
    fv.Key = KI_APLICADO
    
    Set fv = F.Add(Nothing)
    Cotizacion = gDB.ValField(rs.Fields, cscFvCobzCotizacion)
    If Cotizacion <> 0 Then
      fv.Value = Cotizacion
    End If
    fv.Key = KI_COTIZACION
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscFvdPendiente)
    fv.Key = KI_PENDIENTE2
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscFvCobzImporte)
    fv.Key = KI_APLICADO2
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscFvCobzImporte)
    fv.Key = KI_APLICADO3
    
    rs.MoveNext
  Wend
  
  pLoadAplic = True
End Function

' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2098, vbNullString) 'Error al grabar la cobranza
  
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

' Implementacion de cIABMClientGrid
Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  cIABMClientGrid_IsEmptyRow = False
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  On Error GoTo ControlError
  
  cIABMClientGrid_ColumnAfterUpdate = pColAUpdate(pGetItemsProperty(), lRow, lCol)

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

  cIABMClientGrid_ColumnBeforeEdit = pColBEdit(pGetItemsProperty(), lRow, lCol, iKeyAscii)
  
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
  
  Select Case Key
    
    Case K_APLICACIONES
      
      With pGetItems().Rows
        ShowDocAux pCell(.Item(lRow), KI_FV_ID).id, _
                   "CSVenta2.cFacturaVenta", _
                   "CSABMInterface2.cABMGeneric"
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

Private Function pColAUpdate(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long)
  Dim Row        As cIABMGridRow
  Dim MaxVal     As Double
  Dim bVisible   As Boolean
  Dim Pendiente  As Double
  
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KI_APLICADO
        Set Row = .Rows(lRow)
        
        With pCell(Row, KI_APLICADO)
          
          Pendiente = Val(pGetPendiente.Value) + Val(pCell(Row, KI_APLICADO3).Value)
          MaxVal = Val(pCell(Row, KI_PENDIENTE2).Value) + Val(pCell(Row, KI_APLICADO2).Value)
          
          If MaxVal > Pendiente Then
            MaxVal = Pendiente
          End If
          
          If Val(.Value) > MaxVal Then
            .Value = MaxVal
          ElseIf Val(.Value) < 0 Then
            .Value = 0
          End If
          
          pCell(Row, KI_APLICADO3).Value = .Value
        End With
        
        ' Actulizo el pendiente
        With pCell(Row, KI_PENDIENTE)
          .Value = Val(pCell(Row, KI_PENDIENTE2).Value) + (Val(pCell(Row, KI_APLICADO2).Value) - Val(pCell(Row, KI_APLICADO).Value))
        End With
        
        pShowPendiente
    End Select
  End With
  
  pColAUpdate = True
End Function

Private Function pGetItemsProperty() As cIABMProperty
  Set pGetItemsProperty = m_ObjAbm.Properties(c_Aplicaciones)
End Function

Private Function pGetItems() As cIABMGrid
  Set pGetItems = m_ObjAbm.Properties(c_Aplicaciones).Grid
End Function

Private Function pColBEdit(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
  Select Case pGetKeyFromCol(IProperty.Grid.Columns, lCol)
    ' Facturas
    Case KI_APLICADO
    Case KI_COTIZACION
      If pCell(IProperty.Grid.Rows(lRow), KI_COTIZACION).Value = vbNullString Then
        Exit Function
      End If
    Case Else
      Exit Function
  End Select
  
  pColBEdit = True
End Function

Private Sub pShowPendiente()
  Dim Row           As cIABMGridRow
  Dim Total         As Double
  
  For Each Row In pGetItems().Rows
    Total = Total + Val(pCell(Row, KI_APLICADO).Value)
  Next
  
  pGetPendiente().Value = m_Total - Total
  
  m_ObjAbm.ShowValue pGetPendiente
End Sub

Private Function pGetPendiente() As cIABMProperty
  Set pGetPendiente = m_ObjAbm.Properties.Item(c_pendiente)
End Function

Private Function pSave() As Boolean
    
  ' Edit Apply
  '
  If m_emp_id <> EmpId Then
    MsgApplyDisabled m_emp_nombre
    Exit Function
  End If
  
  Dim register     As cRegister
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  register.fieldId = cscCobzTMPId
  register.Table = csTCobranzaTMP
  
  register.id = csNew
  
  register.Fields.Add2 cscCobzNumero, 0, csLong
  register.Fields.Add2 cscCliId, csNO_ID, csLong
  register.Fields.Add2 cscSucId, csNO_ID, csLong
  register.Fields.Add2 cscDocId, csNO_ID, csLong
  register.Fields.Add2 cscEstId, csNO_ID, csLong
  register.Fields.Add2 cscCobzId, m_CobzId, csId
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  Dim c_ErrorSave As String
  
  c_ErrorSave = LNGGetText(2126, vbNullString) 'Error al grabar la aplicación de la Cobranza
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "pSave", C_Module, c_ErrorSave) Then Exit Function
  
  If Not pSaveItems(register.id) Then Exit Function
  If Not pSaveCtaCte(register.id) Then Exit Function
  
  If Not register.CommitTrans() Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocCobranzaSaveAplic " & register.id
  If Not gDB.OpenRs(sqlstmt, rs, , , , "pSave", C_Module, c_ErrorSave) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim id As Long
  If Not GetDocIDFromRecordset(rs, id) Then Exit Function
  
  pSave = id <> csNO_ID
    
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

Private Function pSaveItems(ByVal id As Long) As Boolean
  Dim register    As cRegister
  Dim IProperty   As cIABMProperty
  Dim bSave       As Boolean
  Dim Row         As cIABMGridRow
  Dim Cell        As cIABMGridCellValue
  Dim importe     As Double
  Dim Cotizacion  As Double
  
  For Each Row In pGetItems().Rows
  
    Set register = New cRegister
    register.fieldId = cscFvCobzTMPid
    register.Table = csTFacturaVentaCobranzaTMP
    register.id = csNew
    
    bSave = False
    
    If Val(pCell(Row, KI_APLICADO).Value) Then
      
      bSave = True
      
      For Each Cell In Row
        Select Case Cell.Key
          Case KI_FV_ID
            register.Fields.Add2 cscFvId, Cell.id, csId
          Case KI_FVD_ID
            register.Fields.Add2 cscFvdId, Val(Cell.Value), csId
          Case KI_FVP_ID
            register.Fields.Add2 cscFvpId, Val(Cell.Value), csId
          Case KI_APLICADO
            importe = Val(Cell.Value)
            register.Fields.Add2 cscFvCobzImporte, importe, csDouble
          Case KI_COTIZACION
            Cotizacion = Val(Cell.Value)
            register.Fields.Add2 cscFvCobzCotizacion, Cotizacion, csDouble
        End Select
      Next
    End If
    
    If bSave Then
      
      register.Fields.Add2 cscFvCobzImporteOrigen, DivideByCero(importe, Cotizacion), csDouble
      register.Fields.Add2 cscFvCobzId, 0, csLong
      register.Fields.Add2 cscCobzId, 0, csLong
      register.Fields.Add2 cscCobzTMPId, id, csId
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
                                                          
      If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
    End If
  Next
  
  pSaveItems = True
End Function

Private Function pSaveCtaCte(ByVal id As Long) As Boolean
  Dim register    As cRegister
  Dim vCtaCte()   As T_CtaCte
  Dim i           As Long
  
  ' Obtengo las cuentas del tercero
  If Not GetCuentasDeudor(pGetItems(), vCtaCte(), KI_FV_ID, KI_APLICADO, _
                          KI_COTIZACION, 0, 0, vbNullString, 0) Then Exit Function
  
  For i = 1 To UBound(vCtaCte())
  
    Set register = New cRegister
    register.fieldId = cscCobziTMPId
    register.Table = csTCobranzaItemTMP
    register.id = csNew
    
    register.Fields.Add2 cscCueId, vCtaCte(i).Cue_id, csId
    register.Fields.Add2 cscCobziImporteOrigen, vCtaCte(i).ImporteOrigen, csCurrency
    register.Fields.Add2 cscCobziImporte, vCtaCte(i).importe, csCurrency
    
    register.Fields.Add2 cscCobziOrden, i, csInteger
    register.Fields.Add2 cscCobziTipo, csECobranzaItemTipo.csECobziTCtaCte, csInteger
    register.Fields.Add2 cscCobzTMPId, id, csId
    register.Fields.Add2 cscCobziId, id, csLong
    register.Fields.Add2 cscCobziOtroTipo, csEItemOtroTipo.csEOtroHaber, csInteger
    
    register.Fields.HaveLastUpdate = False
    register.Fields.HaveWhoModify = False
                                         
    If Not gDB.Save(register, , "pSaveCtaCte", C_Module, c_ErrorSave) Then Exit Function
  Next
  
  pSaveCtaCte = True
End Function
