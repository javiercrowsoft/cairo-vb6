VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cListaPrecioConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cListaPrecioConfig
' 07-10-2008

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cListaPrecioConfig"

Private Const c_fixed_col = 3

Private Const c_Items = "Precios"
Private Const c_Top = "top"

Private Const K_PRODUCTO                       As Integer = 1
Private Const K_CMD_PR_FILTER                  As Integer = 2
Private Const K_ITEMS                          As Integer = 3
Private Const K_LISTA                          As Integer = 4
Private Const K_CMD_LOAD                       As Integer = 5
Private Const K_TOP                            As Integer = 6

Private Const KI_ITEM_ID                       As Integer = 1
Private Const KI_PR_ID                         As Integer = 2


' estructuras
' Seudo - Variables
Private c_ErrorSave         As String

' variables privadas
Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_BranchId          As Long
Private m_TreeId            As Long
 
Private m_ItemsDeleted      As String

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

Private m_RamaProducto      As String
Private m_ram_id_producto   As String

Private m_WasChanged        As Boolean

' Properties publicas

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

End Property

Private Property Get cIABMClient_CanCopy() As Boolean

End Property

Private Property Get cIABMClient_CanNew() As Boolean

End Property

Private Function cIABMClient_ShowDocDigital() As Boolean

End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  Select Case MessageID
    Case MSG_POP_MENU_ITEM
      Select Case Val(Info)
        Case 0 ' Aplicar una Lista de Precios
          pSetListaPrecio
      End Select
  End Select
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

  With m_ObjAbm.Properties
    Select Case Key
      
      Case K_CMD_PR_FILTER
        pShowItems
      Case K_CMD_LOAD
        pAddProductos
    
    End Select
  End With
End Function

Private Sub pShowItems()
  If m_WasChanged Then
    If Not Ask(LNGGetText(4615, vbNullString), vbNo) Then Exit Sub
          'Exiten cambios que aun no se han guardado.;; & _
          Para conservarlos presione el boton 'NO' y luego el boton 'Guardar'.;; & _
          ¿Descarta los cambios?.
  End If
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties.Item(c_Items)
  pLoadItems iProp
  m_ObjAbm.ShowValue iProp
End Sub

Private Function cIABMClient_Save() As Boolean
  
  cIABMClient_Save = pSaveItems()

End Function

Private Function pGetItems() As cIABMProperty
  Set pGetItems = m_ObjAbm.Properties.Item(c_Items)
End Function

Private Function pSaveItems() As Boolean
  Dim register    As cRegister
  Dim row         As cIABMGridRow
  Dim Cell        As cIABMGridCellValue
  Dim toDelete    As String
  Dim iCol        As Long
  Dim sqlstmt     As String
  
  Dim bHaveToDelete           As Boolean
  Dim bHaveToUpdateInsert     As Boolean
  
  Dim Pr_id As Long
  
  With pGetItems().Grid
    
    For Each row In .Rows
    
      iCol = 0
    
      Set register = New cRegister
      With register
        .fieldId = cscLpcId
        .Table = csTListaPrecioConfig
        .Id = csNew
      End With
      
      ' Para eliminar configuraciones repetidas borro
      ' toda referencia a este producto
      '
      sqlstmt = "delete ListaPrecioConfig where pr_id = " & pCell(row, KI_PR_ID).Id
      If Not gDB.Execute(sqlstmt) Then Exit Function
      
      For Each Cell In row
      
        iCol = iCol + 1
            
        Select Case Cell.Key
          
          Case KI_ITEM_ID
            
            ' Nada que hacer, solo esta para que no entre por el else
            ' y se descarta automaticamente
          
          Case KI_PR_ID
            Pr_id = Cell.Id
                        
          Case Else
          
            ' En la primera no se hace nada
            '
            If iCol = 1 Then
            
            ' Si la columna es de listas de precios
            '
            ElseIf pIsColLp(iCol) Then
            
              ' Si no hay lista de precios tengo que borrar el registro en ListaPrecioConfig
              '
              If Cell.Id = csNO_ID Then
                bHaveToDelete = True
              
              Else
                
                register.fields.Add2 cscLpId, Cell.Id, csId
                bHaveToUpdateInsert = True
                
              End If
            
            ' Si la columna es de Id
            '
            Else
              
              ' Si hay que borrar el producto-lista
              '
              If bHaveToDelete Then
              
                If Cell.Id Then
                  toDelete = toDelete & Cell.Id & ","
                End If
                
                bHaveToDelete = False
              
              ' Si hay una lista de precios
              '
              ElseIf bHaveToUpdateInsert Then
                
                register.Id = csNew
                
                register.fields.Add2 cscPrId, Pr_id, csId
                register.fields.Add2 cscLpcOrden, (iCol / 2) - 1, csDouble
              
                If Not gDB.Save(register, , _
                                C_pSaveItemsFunc, _
                                C_Module, _
                                c_ErrorSave) Then Exit Function
                
                ' Nuevo registro
                '
                Set register = New cRegister
                With register
                  .fieldId = cscLpcId
                  .Table = csTListaPrecioConfig
                  .Id = csNew
                End With
                
                bHaveToUpdateInsert = False
              
              End If
            
            End If
            
        End Select
      Next
      
    Next
  End With
  
  If LenB(m_ItemsDeleted) And Not m_Copy Then
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    sqlstmt = "delete ListaPrecioConfig where pr_id in (" & m_ItemsDeleted & ")"
  
    If Not gDB.Execute(sqlstmt, C_pSaveItemsFunc, C_Module) Then Exit Function
  End If
  
  If LenB(toDelete) And Not m_Copy Then
    toDelete = RemoveLastColon(toDelete)
    sqlstmt = "delete ListaPrecioConfig where lpc_id in (" & toDelete & ")"
  
    If Not gDB.Execute(sqlstmt, C_pSaveItemsFunc, C_Module) Then Exit Function
  End If
  
  pSaveItems = True
End Function

Private Function pIsColLp(ByVal iColIndex As Long) As Boolean
  pIsColLp = ((iColIndex - c_fixed_col) Mod 2 - 1) = 0
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(4616, vbNullString) 'Configuración de Listas de Precios
End Property

Private Function cIABMClient_Validate() As Boolean
  cIABMClient_Validate = True
End Function

' Implementacion de cIABMClientGrid
Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  Select Case Key
    Case K_ITEMS
      m_WasChanged = True
  End Select
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

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Select Case Key
  
    Case K_ITEMS
      Id = pCell(row, KI_PR_ID).Id
      If Id <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & Id & C_StrColon
  
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowItems(row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_IsEmptyRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function pValidateRowItems(row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
    
  If pCell(row, KI_PR_ID).Id = csNO_ID Then
    MsgWarning LNGGetText(3068, vbNullString, strRow) 'Debe indicar un producto (1)
    Exit Function
  End If
  
  pValidateRowItems = True

End Function

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_ValidateRow = pValidateRowItems(row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
  
  m_Host.Server.AddMenu C_MenuArticulos, csMenuConfigArticulos, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(4617, vbNullString), csPreGListaPrecioConfig, C_MenuArticulos, 0, True, False, False, False, False, Me
                        '&Configuración de Listas de Precios
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  pEdit
End Function

Private Sub pEdit()
  On Error GoTo ControlError
  
  Set m_ObjAbm = New cABMGeneric
  
  If Not SecurityCanAccess(csPreGListaPrecioConfig) Then Exit Sub

  If Not LoadCollection() Then Exit Sub
  
  m_Editing = True
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", C_Module, vbNullString
End Sub

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim oGrid  As cABMGrid
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 6400
  AbmObj.UseHelpValueProcess = True
  
  Dim iProp   As cABMProperty
  Dim c       As cIABMProperty
  Dim oProp   As cABMProperty
  
  m_ObjAbm.Tabs.Clear
  m_ObjAbm.Title2 = vbNullString
  
  ' OJO: El indice de los menus es en funcion de su
  '      posicion y empieza en 0 (cero)
  '
  AbmObj.PopMenuClient = LNGGetText(4619, vbNullString) 'Aplicar una Lista de Precios
  
  With m_ObjAbm.Properties
    
    .Clear
    
    Set c = .Add(Nothing, cscPrId)
    With c
      .PropertyType = cspHelp
      .Table = csProducto
      .Name = LNGGetText(1367, vbNullString) 'Articulo
      .Key = K_PRODUCTO
    
      .HelpId = Val(m_ram_id_producto)
      .HelpValueProcess = m_ram_id_producto
      .Value = m_RamaProducto
    
      Set oProp = c
      oProp.HelpType = csTree
      oProp.IsEditProperty = False
      Set oProp = Nothing
    
    End With
    
    Set c = .Add(Nothing, cscLpId)
    With c
      .PropertyType = cspHelp
      .Table = csListaPrecio
      .Name = LNGGetText(1397, vbNullString) 'Lista
      .Key = K_LISTA
    
      .TopFromProperty = cscPrId
      .Left = 5500
    
      Set oProp = c
      oProp.IsEditProperty = False
      Set oProp = Nothing
    
    End With
    
    Set c = .Add(Nothing, c_Top)
    With c
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(2800, vbNullString) 'Top
      .Key = K_TOP
      .Width = 800
      
      .TopFromProperty = cscPrId
      .Left = 8500
      .LeftLabel = -400
    
      Set oProp = c
      oProp.IsEditProperty = False
      Set oProp = Nothing
    
    End With
    
    With .Add(Nothing, "cmdFilter")
      .PropertyType = cspButton
      .Name = "Filtrar"
      .Key = K_CMD_PR_FILTER
      
      .TopFromProperty = cscPrId
      .Left = 9500
      .LeftNotChange = True
      .TopNotChange = True
      .LeftLabel = -1
    End With
    
    With .Add(Nothing, "cmdLoad")
      .PropertyType = cspButton
      .Name = "Cargar"
      .Key = K_CMD_LOAD
      
      .TopFromProperty = cscPrId
      .Left = 12000
      .LeftNotChange = True
      .TopNotChange = True
      .LeftLabel = -1
    End With
    
    Set c = .Add(Nothing, c_Items)
    With c
      .PropertyType = cspGrid
      If Not pLoadItems(c) Then Exit Function
      .Name = c_Items
      .Key = K_ITEMS
      .LeftLabel = -1
      .Left = 400
      .TopFromProperty = cscPrId
      .TopToPrevious = 440
      .Height = 5000
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
      Set oGrid = c.Grid
      oGrid.MultiSelect = True
    End With
    
    m_ItemsDeleted = vbNullString
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim offset  As Integer
  Dim i       As Integer
  Dim iCol    As Long
    
  Dim bAddRow     As Boolean
  Dim row         As cIABMGridRow
  Dim lastPrId    As Long
    
  m_WasChanged = False
  
  With m_ObjAbm.Properties
  
    sqlstmt = "sp_ListaPrecioConfigGetitems " _
                & gDB.sqlString(.Item(cscPrId).HelpValueProcess) & "," _
                & .Item(cscLpId).HelpId & "," _
                & Val(pGetTop().Value)

  End With
  
  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pLoadItems", _
                    C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_ITEM_ID
      End With
      
      With .Add(Nothing, cscPrId)
        .Name = LNGGetText(1367, vbNullString) 'Articulo
        .PropertyType = cspHelp
        .Table = csProductoCompra
        .Width = 3500
        .Key = KI_PR_ID
      End With
      
      For i = 1 To 20
        
        With .Add(Nothing)
          .Name = "[    " & Format(i, "00") & "   ]"
          .PropertyType = cspHelp
          .Table = csListaPrecio
          .HelpFilter = "lp_tipo = 2"
          .Width = 500
        End With
        
        .Add(Nothing).Visible = False
        
      Next
    
    End With
      
    With .Rows
    
      .Clear
    
      While Not rs.EOF
      
        If lastPrId <> gDB.ValField(rs.fields, cscPrId) Then
          
          bAddRow = True
          lastPrId = gDB.ValField(rs.fields, cscPrId)
          
        End If
      
        ' Si estoy en un nuevo producto o lista de precios
        ' agrego una fila
        '
        If bAddRow Then
          Set row = .Add(Nothing)
        
          With row
            
            ' Columnas fijas de la fila
            '
            .Add(Nothing).Key = KI_ITEM_ID
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.fields, cscPrNombrecompra)
              .Id = gDB.ValField(rs.fields, cscPrId)
              .Key = KI_PR_ID
            End With
                      
            ' Columnas de fechas de la fila
            '
            For i = 1 To 20
                            
              .Add Nothing ' Lista de precios
              .Add Nothing ' lpc_id
              
            Next
          
          End With
          
          bAddRow = False
          
        End If
        
        ' Ahora tengo que colocar en la columna correspondiente
        ' las horas y su emh_id
        '
        With row
        
          iCol = gDB.ValField(rs.fields, cscLpcOrden)
                    
          Dim Cell As cIABMGridCellValue
          
          '---------------------------------------------
          
          Set Cell = pGetCellFromIndex(row, iCol)
                    
          With Cell
            .Value = gDB.ValField(rs.fields, cscLpNombre)
            .Id = gDB.ValField(rs.fields, cscLpId)
          End With
          
          If gDB.ValField(rs.fields, "tiene_precio") = 0 Then
            Set Cell.Format = New cABMGridCellFormat
            Cell.Format.Color = vbRed
          End If
          
          '---------------------------------------------
          
          pGetCellIdFromIndex(row, iCol).Id = gDB.ValField(rs.fields, cscLpcId)
                    
        End With
        
        rs.MoveNext
      Wend
    
    End With
  End With
  
  pLoadItems = True
End Function

Private Function pIsEmptyRowItems(ByRef row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
      
  If Not ValEmpty(pCell(row, KI_PR_ID).Value, csText) Then
    bRowIsEmpty = False
  End If
  
  pIsEmptyRowItems = bRowIsEmpty
End Function

Private Function pGetCellFromIndex(ByRef row As cIABMGridRow, ByVal iCol As Long) As cIABMGridCellValue
  
  iCol = iCol * 2 - 1
  Set pGetCellFromIndex = row.Item(iCol + c_fixed_col)
  
End Function

Private Function pGetCellIdFromIndex(ByRef row As cIABMGridRow, ByVal iCol As Long) As cIABMGridCellValue
 
  iCol = iCol * 2
  Set pGetCellIdFromIndex = row.Item(iCol + c_fixed_col)
  
End Function

Private Function pGetProductos() As cIABMProperty
  Set pGetProductos = m_ObjAbm.Properties.Item(cscPrId)
End Function

Private Function pGetLista() As cIABMProperty
  Set pGetLista = m_ObjAbm.Properties.Item(cscLpId)
End Function

Private Function pGetTop() As cIABMProperty
  Set pGetTop = m_ObjAbm.Properties.Item(c_Top)
End Function

Private Sub pAddProductos()
  Dim row         As cIABMGridRow
  Dim rs          As ADODB.Recordset
  Dim sqlstmt     As String
  Dim i           As Long
  Dim bAddRow     As Boolean
  Dim lastPrId    As Long
  Dim iCol        As Long
  
  If m_WasChanged Then
    If Not Ask(LNGGetText(4615, vbNullString), vbNo) Then Exit Sub
          'Exiten cambios que aun no se han guardado.;; & _
          Para conservarlos presione el boton 'NO' y luego el boton 'Guardar'.;; & _
          ¿Descarta los cambios?.
  End If
  
  sqlstmt = "sp_ListaPrecioConfigAddProductos " & _
                      gDB.sqlString(pGetProductos().HelpValueProcess) & "," & _
                      pGetLista().HelpId
                      
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub

  With pGetItems.Grid
    
    With .Rows
    
      .Clear
  
      While Not rs.EOF
        
        If lastPrId <> gDB.ValField(rs.fields, cscPrId) Then
          
          bAddRow = True
          lastPrId = gDB.ValField(rs.fields, cscPrId)
          
        End If
      
        ' Si estoy en un nuevo empleado o centro de costo
        ' agrego una fila
        '
        If bAddRow Then
        
          Set row = .Add(Nothing)
        
          With row
            
            ' Columnas fijas de la fila
            '
            .Add(Nothing).Key = KI_ITEM_ID
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.fields, cscPrNombrecompra)
              .Id = gDB.ValField(rs.fields, cscPrId)
              .Key = KI_PR_ID
            End With
                    
            ' Columnas de fechas de la fila
            '
            For i = 1 To 20
              
              .Add Nothing ' Lista
              .Add Nothing ' lpc_id
              
            Next
            
            bAddRow = False
          
          End With
        End If
        
        ' Ahora tengo que colocar en la columna correspondiente
        ' las horas y su lpc_id
        '
        With row
        
          iCol = gDB.ValField(rs.fields, cscLpcOrden)
          
          If iCol > 0 Then
          
            With pGetCellFromIndex(row, iCol)
              .Value = gDB.ValField(rs.fields, cscLpNombre)
              .Id = gDB.ValField(rs.fields, cscLpId)
            End With
            
            pGetCellIdFromIndex(row, iCol).Id = gDB.ValField(rs.fields, cscLpcId)
          
          End If
          
        End With
         
        rs.MoveNext
      Wend
    
    End With
    
  End With
  
  Dim AbmGen As cABMGeneric
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValue pGetItems(), True
  
End Sub

Private Sub pSetListaPrecio()
  
  Dim iRow        As cIABMGridRow
  Dim oRow        As cABMGridRow
  Dim iCol        As Long
  Dim lp_id       As Long
  Dim lp_nombre   As String
  Dim iColAux     As String
  Dim help        As CSOAPI2.cHelp
  Dim i           As Long
  
  Set help = New CSOAPI2.cHelp
                           ' Indique la posición de la lista
  If Not GetInput(iColAux, LNGGetText(4620, vbNullString)) Then
    Exit Sub
  End If
  
  iCol = Val(iColAux)
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  AbmObj.RefreshSelectedInGrid pGetItems()
  
  With help.Show(Nothing, csListaPrecio, csNO_ID, _
                 vbNullString, vbNullString, csNormal)

    If Not .Cancel Then
      lp_id = .Id
      lp_nombre = .Value
    End If
  End With
  
  For Each iRow In pGetItems().Grid.Rows
    
    Set oRow = iRow
    i = i + 1
    
    If oRow.IsSelected Then
    
      With pGetCellFromIndex(iRow, iCol)
        .Id = lp_id
        .Value = lp_nombre
      End With
      
      AbmObj.ShowCellValue pGetItems, i, iCol * 2 + 2
    End If
  Next
  
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(4618, vbNullString) 'Error al grabar la configuración de listas de precios

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
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
