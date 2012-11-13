VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCashFlowParams"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cCashFlowParams
' 04-12-2004

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes

Private Const C_Module = "cCashFlowParams"

Private Const c_clientes = "clientes"
Private Const c_proveedores = "proveedores"
Private Const c_bancos = "bancos"
Private Const c_cuentas = "cuentas"

Private Const K_CLIENTES        As Integer = 1
Private Const K_PROVEEDORES     As Integer = 2
Private Const K_BANCOS          As Integer = 3
Private Const K_CUENTAS         As Integer = 4

Private Const KI_CLI_ID         As Integer = 2
Private Const KI_PROV_ID        As Integer = 3
Private Const KI_BCO_ID         As Integer = 4
Private Const KI_CUE_ID         As Integer = 5

' estructuras
' variables privadas
Private m_Id               As Long
Private m_Params           As Collection

Private m_ObjAbm           As cIABMGeneric

' propiedades publicas
' propiedades privadas
' funciones publicas
Public Function Edit(ByRef Params As Collection) As Boolean
  
  On Error GoTo ControlError
  
  Set m_Params = Params
  Set m_ObjAbm = New cABMGeneric
 
  If Not LoadCollection() Then Exit Function
  
  Edit = True
  
  Exit Function
ControlError:
  MngError Err, "Edit", C_Module, vbNullString
End Function

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
End Function

Private Function cIABMClient_EditNew() As Boolean
End Function

Private Property Get cIABMClient_Aplication() As String
    cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
End Property

Private Property Get cIABMClient_CanNew() As Boolean
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(Lista As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim Row     As cIABMGridRow
  Dim Param   As cCashFlowParam
  Dim cli_id  As Long
  Dim prov_id As Long
  Dim bco_id  As Long
  Dim cue_id  As Long
  
  CollClear m_Params
  
  For Each Row In pGetClientes().Grid.Rows
    cli_id = pCell(Row, KI_CLI_ID).Id
    If cli_id Then
      Set Param = New cCashFlowParam
      With Param
        .cli_id = cli_id
        .Cliente = pCell(Row, KI_CLI_ID).Value
      End With
      m_Params.Add Param
    End If
  Next

  For Each Row In pGetProveedores().Grid.Rows
    prov_id = pCell(Row, KI_PROV_ID).Id
    If prov_id Then
      Set Param = New cCashFlowParam
      With Param
        .prov_id = prov_id
        .Proveedor = pCell(Row, KI_PROV_ID).Value
      End With
      m_Params.Add Param
    End If
  Next

  For Each Row In pGetBancos().Grid.Rows
    bco_id = pCell(Row, KI_BCO_ID).Id
    If bco_id Then
      Set Param = New cCashFlowParam
      With Param
        .bco_id = bco_id
        .Banco = pCell(Row, KI_BCO_ID).Value
      End With
      m_Params.Add Param
    End If
  Next

  For Each Row In pGetCuentas().Grid.Rows
    cue_id = pCell(Row, KI_CUE_ID).Id
    If cue_id Then
      Set Param = New cCashFlowParam
      With Param
        .cue_id = cue_id
        .Cuenta = pCell(Row, KI_CUE_ID).Value
      End With
      m_Params.Add Param
    End If
  Next

  cIABMClient_Save = True
End Function

Private Function cIABMClient_Terminate() As Boolean
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2093, vbNullString)  'Parámetros del Flujo de Fondos
End Property

Private Function cIABMClient_Validate() As Boolean
  cIABMClient_Validate = True
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

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_CLIENTES
      cIABMClientGrid_ValidateRow = pValidateRowClientes(Row, RowIndex)
    Case K_PROVEEDORES
      cIABMClientGrid_ValidateRow = pValidateRowProveedores(Row, RowIndex)
    Case K_BANCOS
      cIABMClientGrid_ValidateRow = pValidateRowBancos(Row, RowIndex)
    Case K_CUENTAS
      cIABMClientGrid_ValidateRow = pValidateRowCuentas(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_CLIENTES
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowClientes(Row, RowIndex)
    Case K_PROVEEDORES
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowProveedores(Row, RowIndex)
    Case K_BANCOS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowBancos(Row, RowIndex)
    Case K_CUENTAS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowCuentas(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_IsEmptyRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pIsEmptyRowClientes(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CLI_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowClientes = bRowIsEmpty
End Function

Private Function pIsEmptyRowProveedores(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_PROV_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowProveedores = bRowIsEmpty
End Function

Private Function pIsEmptyRowBancos(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_BCO_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowBancos = bRowIsEmpty
End Function

Private Function pIsEmptyRowCuentas(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CUE_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowCuentas = bRowIsEmpty
End Function

Private Function pValidateRowClientes(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
        Case KI_CLI_ID
          If ValEmpty(Cell.Id, csId) Then
            MsgInfo LNGGetText(1351, vbNullString, strRow) 'Debe indicar un cliente (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowClientes = True
  
End Function

Private Function pValidateRowProveedores(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
        Case KI_PROV_ID
          If ValEmpty(Cell.Id, csId) Then
            MsgInfo LNGGetText(1349, vbNullString, strRow) 'Debe indicar un proveedor (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowProveedores = True
  
End Function

Private Function pValidateRowBancos(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
        Case KI_BCO_ID
          If ValEmpty(Cell.Id, csId) Then
            MsgInfo LNGGetText(2094, vbNullString, strRow) 'Debe indicar un Banco (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowBancos = True
  
End Function

Private Function pValidateRowCuentas(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
        Case KI_CUE_ID
          If ValEmpty(Cell.Id, csId) Then
            MsgInfo LNGGetText(1351, vbNullString, strRow) 'Debe indicar un cuenta (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowCuentas = True
  
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
      
  m_ObjAbm.Title2 = vbNullString
      
  With m_ObjAbm.Tabs
    .Clear
    With .Add(Nothing)
      .Name = LNGGetText(1303, vbNullString) 'Clientes
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1302, vbNullString) 'Proveedores
      .Index = 1
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1040, vbNullString) 'Bancos
      .Index = 2
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1107, vbNullString) 'Cuentas
      .Index = 3
    End With
  End With
  
  With m_ObjAbm.Properties
    .Clear
  
    With .Add(Nothing)
      .PropertyType = cspLabel
      .Left = 300
      .Width = 5000
      .Value = LNGGetText(2095, vbNullString) 'Indique los Clientes a excluir
    End With
    
    Set c = .Add(Nothing, c_clientes)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadClientes(c) Then Exit Function
      .Name = "Clientes"
      .Key = K_CLIENTES
      .TopToPrevious = 440
      .Left = 300
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
  
    With .Add(Nothing)
      .PropertyType = cspLabel
      .Left = 300
      .Width = 5000
      .Value = LNGGetText(2096, vbNullString) 'Indique los Proveedores a excluir
      .TabIndex = 1
    End With
    
    Set c = .Add(Nothing, c_proveedores)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadProveedores(c) Then Exit Function
      .Name = "Proveedores"
      .Key = K_PROVEEDORES
      .TopToPrevious = 440
      .Left = 300
      .TabIndex = 1
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
  
    With .Add(Nothing)
      .PropertyType = cspLabel
      .Left = 300
      .Width = 5000
      .Value = LNGGetText(2097, vbNullString) 'Indique los Bancos a excluir
      .TabIndex = 2
    End With
    
    Set c = .Add(Nothing, c_bancos)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadBancos(c) Then Exit Function
      .Name = "Bancos"
      .Key = K_BANCOS
      .TopToPrevious = 440
      .Left = 300
      .TabIndex = 2
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
  
    With .Add(Nothing)
      .PropertyType = cspLabel
      .Left = 300
      .Width = 5000
      .Value = LNGGetText(4826, vbNullString) 'Indique las cuentas de disponibilidades
      .TabIndex = 3
    End With
    
    Set c = .Add(Nothing, c_cuentas)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadCuentas(c) Then Exit Function
      .Name = "Cuentas"
      .Key = K_CUENTAS
      .TopToPrevious = 440
      .Left = 300
      .TabIndex = 3
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
  End With
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  AbmObj.OkCancelDialog = True
  m_ObjAbm.InModalWindow = True
  
  If Not m_ObjAbm.Show(Me) Then Exit Function

  LoadCollection = True
End Function

Private Function pLoadClientes(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim Param As cCashFlowParam
  
  With Propiedad.Grid
    With .Columns
    
      With .Add(Nothing)
        .Visible = False
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1150, vbNullString) 'Cliente
        .PropertyType = cspHelp
        .Table = csCliente
        .Key = KI_CLI_ID
      End With
    
    End With
    
    With .Rows
      
      For Each Param In m_Params
    
        If Param.cli_id <> csNO_ID Then
    
          With .Add(Nothing)
            
            .Add Nothing
            
            With .Add(Nothing)
              .Id = Param.cli_id
              .Value = Param.Cliente
            End With
          End With
        
        End If
      Next
    End With
  End With
  
  pLoadClientes = True
End Function

Private Function pLoadProveedores(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim Param As cCashFlowParam
  
  With Propiedad.Grid
    With .Columns
    
      With .Add(Nothing)
        .Visible = False
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1151, vbNullString) 'Proveedor
        .PropertyType = cspHelp
        .Table = csProveedor
        .Key = KI_PROV_ID
      End With
    
    End With
    
    With .Rows
      
      For Each Param In m_Params
    
        If Param.prov_id <> csNO_ID Then
    
          With .Add(Nothing)
            
            .Add Nothing
            
            With .Add(Nothing)
              .Id = Param.prov_id
              .Value = Param.Proveedor
            End With
          End With
        
        End If
      Next
    End With
  End With
  
  pLoadProveedores = True
End Function

Private Function pLoadBancos(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim Param As cCashFlowParam
  
  With Propiedad.Grid
    With .Columns
    
      With .Add(Nothing)
        .Visible = False
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1122, vbNullString) 'Banco
        .PropertyType = cspHelp
        .Table = csBanco
        .Key = KI_BCO_ID
      End With
    
    End With
    
    With .Rows
      
      For Each Param In m_Params
    
        If Param.bco_id <> csNO_ID Then
    
          With .Add(Nothing)
            
            .Add Nothing
            
            With .Add(Nothing)
              .Id = Param.bco_id
              .Value = Param.Banco
            End With
          End With
        
        End If
      Next
    End With
  End With
  
  pLoadBancos = True
End Function

Private Function pLoadCuentas(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim Param As cCashFlowParam
  
  With Propiedad.Grid
    With .Columns
    
      With .Add(Nothing)
        .Visible = False
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1267, vbNullString) 'Cuenta
        .PropertyType = cspHelp
        .Table = csCuenta
        .Key = KI_CUE_ID
      End With
    
    End With
    
    With .Rows
      
      For Each Param In m_Params
    
        If Param.cue_id <> csNO_ID Then
    
          With .Add(Nothing)
            
            .Add Nothing
            
            With .Add(Nothing)
              .Id = Param.cue_id
              .Value = Param.Cuenta
            End With
          End With
        
        End If
      Next
    End With
  End With
  
  pLoadCuentas = True
End Function

Private Function pGetClientes() As cIABMProperty
  Set pGetClientes = m_ObjAbm.Properties.Item(c_clientes)
End Function

Private Function pGetProveedores() As cIABMProperty
  Set pGetProveedores = m_ObjAbm.Properties.Item(c_proveedores)
End Function

Private Function pGetBancos() As cIABMProperty
  Set pGetBancos = m_ObjAbm.Properties.Item(c_bancos)
End Function

Private Function pGetCuentas() As cIABMProperty
  Set pGetCuentas = m_ObjAbm.Properties.Item(c_cuentas)
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_Params = Nothing
End Sub

