VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPickingListPedido"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid

'--------------------------------------------------------------------------------
' cPickingListPedido
' 28-04-09

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cPickingListPedido"

Private Const c_Items = "Items"

Private Const c_doc_id_factura = "doc_id_factura"
Private Const c_doc_id_interno = "doc_id_interno"

Private Const K_PEDIDOS As Integer = 1

Private Const K_DOC_ID_FACTURA As Integer = 2
Private Const K_DOC_ID_INTERNO As Integer = 3

Private Const c_key_col_cliente = "col_cli"
Private Const c_key_col_fecha = "col_fecha"
Private Const c_select_key = "kselect"

Private Const KI_PKLPV_ID                      As Integer = 1
Private Const KI_PV_ID                         As Integer = 2
Private Const KI_CLIENTE                       As Integer = 4
Private Const KI_SELECT                        As Integer = 3
Private Const KI_FECHA                         As Integer = 5
Private Const KI_ORDEN                         As Integer = 1000
Private Const KI_NRODOC                        As Integer = 7
Private Const KI_IMPORTE                       As Integer = 8
Private Const KI_PENDIENTE                     As Integer = 307
Private Const KI_DESCRIP                       As Integer = 2001
Private Const KI_INTERNO                       As Integer = 2002
' estructuras
' variables privadas

Private m_doc_id_factura                As Long
Private m_DocFactura                    As String

Private m_doc_id_interno                As Long
Private m_DocInterno                    As String

'OJO HASTA ACA

Private m_Id As Long

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric

Private m_GeneralConfig     As cGeneralConfig
Private m_UserCfg           As cUsuarioConfig

' Propiedades publicas
Public Property Get doc_id_factura() As Long
  doc_id_factura = m_doc_id_factura
End Property

Public Property Get doc_id_interno() As Long
  doc_id_interno = m_doc_id_interno
End Property

Public Property Get DocFactura() As String
  DocFactura = m_DocFactura
End Property

Public Property Get DocInterno() As String
  DocInterno = m_DocInterno
End Property

' Properties privadas

' funciones publicas

' Implementacion de cIABMClient

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
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  Select Case MessageID
  
    Case MSG_DOC_INFO
    
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      
      CSKernelClient2.ShowHelp AbmGen.hWnd, _
                               vbNullString, _
                               vbNullString, _
                               csPreVtaModificarArticulo
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    Case Else
      cIABMClient_MessageEx = True
  End Select
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  
  With pGetDocFactura()
    m_doc_id_factura = .HelpId
    m_DocFactura = .Value
  End With
  
  With pGetDocInterno()
    m_doc_id_interno = .HelpId
    m_DocInterno = .Value
  End With
  
  cIABMClient_Save = True
End Function

Private Function cIABMClient_Terminate() As Boolean
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(4878, vbNullString) ' Facturar Pedidos
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_DOC_ID_FACTURA
          If .HelpId = csNO_ID Then
            MsgInfo LNGGetText(4883, vbNullString) 'Debe indicar un documento para facturar los pedidos
            Exit Function
          End If
        Case K_DOC_ID_INTERNO
          If .HelpId = csNO_ID Then
            MsgInfo LNGGetText(4884, vbNullString) 'Debe indicar un documento para los despachos internos
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True

End Function

' Implementacion cIABMClientGrid

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean

End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  Dim Keycol As Long
  
  Select Case Key
    Case K_PEDIDOS
      Keycol = pGetItems().Grid.Columns(lCol).Key
      If Keycol = KI_INTERNO Or Keycol = KI_SELECT Then
        cIABMClientGrid_ColumnBeforeEdit = True
      Else
        cIABMClientGrid_ColumnBeforeEdit = False
      End If
  End Select
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

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean

End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  cIABMClientGrid_ValidateRow = True
End Function

' Intefaz de cPickingListPedido

Public Function Edit(ByVal id As Long) As Boolean

  If id = csNO_ID Then
    MsgWarning LNGGetText(4877, vbNullString) ' Debe guardar la lista de despacho para poder facturar los pedidos
    Exit Function
  End If

  If Not SecurityCanAccess(csPreVtaModificarArticulo) Then Exit Function
  
  If m_ObjAbm Is Nothing Then
    Set m_ObjAbm = New cABMGeneric
  End If
  
  m_Id = id
  
  m_ObjAbm.InModalWindow = True
  Dim AbmGen As cABMGeneric
  
  Set AbmGen = m_ObjAbm
  
  AbmGen.OkCancelDialog = True
  AbmGen.bDontAskForSave = True
  
  m_doc_id_factura = m_UserCfg.PklDocIdFactura
  m_DocFactura = m_UserCfg.PklDocFactura
  m_doc_id_interno = m_UserCfg.PklDocIdInerno
  m_DocInterno = m_UserCfg.PklDocInterno
    
  If Not LoadCollection() Then Exit Function

  Edit = AbmGen.OkCancelDialogRslt

  Exit Function
ControlError:
  MngError Err, C_EditGenericEdit, C_Module, vbNullString
End Function

Public Function PvIdsFactura() As Collection
  Dim rtn As Collection
  Dim Row As cIABMGridRow
  
  Set rtn = New Collection
  
  For Each Row In pGetItems().Grid.Rows
    If pCell(Row, KI_SELECT).id <> 0 And pCell(Row, KI_INTERNO).id = 0 Then
    
      rtn.Add New cPickingListPedidoItem
      With rtn.Item(rtn.count)
        .pv_id = Val(pCell(Row, KI_PV_ID).Value)
        .cli_id = pCell(Row, KI_CLIENTE).id
      End With
      
    End If
  Next
  
  Set PvIdsFactura = rtn
End Function

Public Function PvIdsInterno() As Collection
  Dim rtn As Collection
  Dim Row As cIABMGridRow
  
  Set rtn = New Collection
  
  For Each Row In pGetItems().Grid.Rows
    If pCell(Row, KI_SELECT).id <> 0 And pCell(Row, KI_INTERNO).id <> 0 Then
    
      rtn.Add New cPickingListPedidoItem
      With rtn.Item(rtn.count)
        .pv_id = Val(pCell(Row, KI_PV_ID).Value)
        .cli_id = pCell(Row, KI_CLIENTE).id
      End With
      
    End If
  Next
  
  Set PvIdsInterno = rtn
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  
  Dim AbmObj  As cABMGeneric
  
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 6500
  AbmObj.MinWidth = 10000
  
  With m_ObjAbm.Properties
    
    .Clear
                
    With .Add(Nothing, c_doc_id_factura)
      .PropertyType = cspHelp
      .Table = CSDocumento
      .Name = LNGGetText(4880, vbNullString) 'Documento de Factura
      .Key = K_DOC_ID_FACTURA
      .Width = 2700
      .HelpId = m_doc_id_factura
      .Value = m_DocFactura
      .Left = 2300
      .LeftLabel = -1900
      .HelpFilter = "doct_id = 1"
    End With
                
    With .Add(Nothing, c_doc_id_interno)
      .PropertyType = cspHelp
      .Table = CSDocumento
      .Name = LNGGetText(4881, vbNullString) 'Documento Interno
      .Key = K_DOC_ID_INTERNO
      .Width = 2700
      .HelpId = m_doc_id_interno
      .Value = m_DocInterno
      .TopFromProperty = c_doc_id_factura
      .Left = 7500
      .LeftLabel = -1900
      .HelpFilter = "doct_id = 1"
    End With
                
    With .Add(Nothing)
      .PropertyType = cspLabel
      .Width = 11500
      .Height = 10
      .BackColor = &HCCCCCC
      .Left = 300
      .TopToPrevious = 400
    End With
                
    With .Add(Nothing)
      .PropertyType = cspLabel
      .Value = LNGGetText(4882, vbNullString) 'Seleccione los pedidos a despachar
      .Width = 11500
      .Left = 400
      .Height = 285
      .FontBold = True
    End With
                
    Set c = .Add(Nothing, c_Items)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItems(c) Then Exit Function
      .Name = LNGGetText(1694, vbNullString) ' Pedidos
      .Key = K_PEDIDOS
      .Left = 200
      .Top = 2000
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
    End With
      
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function pLoadItems(ByRef iProp As cIABMProperty) As Boolean

  With iProp.Grid
  
    With .Columns
    
      .Clear
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PKLPV_ID
      End With
            
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PV_ID
      End With
                        
      With .Add(Nothing, c_select_key)
        .PropertyType = cspCheck
        .Width = 320
        .Key = KI_SELECT
      End With
            
      With .Add(Nothing, c_key_col_cliente)
        .Name = LNGGetText(1150, vbNullString) 'Cliente
        .Key = KI_CLIENTE
      End With
            
      With .Add(Nothing, c_key_col_fecha)
        .PropertyType = cspDate
        .Name = LNGGetText(1569, vbNullString) 'Fecha
        .Key = KI_FECHA
      End With
            
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .Width = 320
        .Name = LNGGetText(1809, vbNullString) 'Orden
        .Key = KI_ORDEN
      End With
      
      With .Add(Nothing)
        .PropertyType = cspText
        .Name = LNGGetText(1065, vbNullString) 'Numero
        .Key = KI_NRODOC
      End With
            
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = LNGGetText(1228, vbNullString) 'Importe
        .Key = KI_IMPORTE
        .Format = m_GeneralConfig.FormatDecImporte
      End With
                                    
      With .Add(Nothing)
        .Key = KI_PENDIENTE
        .Visible = False
      End With
                                    
      With .Add(Nothing)
        .PropertyType = cspCheck
        .Name = LNGGetText(4879, vbNullString) ' Interno
        .Key = KI_INTERNO
      End With
                                    
      With .Add(Nothing)
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Name = LNGGetText(1861, vbNullString) 'Observaciones
        .Key = KI_DESCRIP
      End With
                                                
    End With
  
    .Rows.Clear
    
  End With

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  ' Pedidos
  '
  sqlstmt = "sp_PickingListGetItemsPedidos " & m_Id
  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pLoadItems", _
                    C_Module) Then Exit Function
  
  Dim Row As cIABMGridRow
  
  With iProp.Grid.Rows
      
    While Not rs.EOF
    
      Set Row = .Add(Nothing)
    
      With Row
      
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPklpvId)
          .Key = KI_PKLPV_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPvId)
          .Key = KI_PV_ID
        End With
                                
        With .Add(Nothing)
          .id = 1
          .Key = KI_SELECT
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscCliNombre)
          .id = gDB.ValField(rs.fields, cscCliId)
          .Key = KI_CLIENTE
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPvFecha)
          .Key = KI_FECHA
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPklpvOrden)
          .Key = KI_ORDEN
        End With
                
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPvNrodoc)
          .Key = KI_NRODOC
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPvTotal)
          .Key = KI_IMPORTE
        End With
                        
        .Add(Nothing).Key = KI_PENDIENTE
                
        With .Add(Nothing)
          .id = 0
          .Key = KI_INTERNO
        End With
                
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPklpvDescrip)
          .Key = KI_DESCRIP
        End With
                                
      End With
      
      rs.MoveNext
    Wend
  End With

  pLoadItems = True

End Function

Private Function pGetItems() As cIABMProperty
  Set pGetItems = m_ObjAbm.Properties.Item(c_Items)
End Function

Private Function pGetDocFactura() As cIABMProperty
  Set pGetDocFactura = m_ObjAbm.Properties.Item(c_doc_id_factura)
End Function

Private Function pGetDocInterno() As cIABMProperty
  Set pGetDocInterno = m_ObjAbm.Properties.Item(c_doc_id_interno)
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
    
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load
  m_UserCfg.ValidatePklFactura
  m_UserCfg.ValidatePklInterno
    
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_GeneralConfig = Nothing
  Set m_UserCfg = Nothing
End Sub


