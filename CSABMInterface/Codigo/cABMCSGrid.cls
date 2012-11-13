VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cABMCSGrid"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cABMCSGrid
' 10-02-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const COL_MAX_WIDTH = 10000
Private Const c_noRow = 0
Private Const c_col_width = 60

' estructuras
' variables privadas
Private m_CheckBox          As Boolean
Private m_BackColor         As OLE_COLOR

Private m_ItemIndexId       As Integer
Private m_AllowAddNew       As Boolean

' propiedades publicas
Public Property Let AllowAddNew(ByRef oGrid As Object, ByRef rhs As Boolean)
  m_AllowAddNew = rhs
  oGrid.RowMode = Not rhs
End Property

Public Property Let AllowEdit(ByRef oGrid As Object, ByRef rhs As Boolean)
  oGrid.Editable = rhs
  oGrid.RowMode = Not rhs
End Property

Public Property Let AllowDelete(ByRef oGrid As Object, ByRef rhs As Boolean)
  
End Property

Public Property Get Columns(ByRef oGrid As Object) As Integer
  Columns = oGrid.Columns.Count
End Property
Public Property Get Rows(ByRef oGrid As Object) As Integer
  Rows = oGrid.Rows
End Property
Public Property Get CheckBox() As Boolean
  CheckBox = m_CheckBox
End Property
Public Property Let CheckBox(ByVal rhs As Boolean)
  m_CheckBox = rhs
End Property
Public Property Get BackColor(ByRef oGrid As Object) As OLE_COLOR
  BackColor = m_BackColor
End Property
Public Property Let BackColor(ByRef oGrid As Object, ByVal rhs As OLE_COLOR)
  m_BackColor = rhs
  oGrid.BackColor = m_BackColor
End Property
Public Property Get Id(ByRef oGrid As Object) As Long
  If oGrid.SelectedRow = 0 Then Exit Property
  Id = oGrid.Cell(oGrid.SelectedRow, m_ItemIndexId)
End Property

Public Property Get Ids(ByRef oGrid As Object, ByRef vIds() As Long) As Boolean
  Dim n  As Long
  Dim i  As Integer
  Dim j  As Integer
  
  For i = 1 To oGrid.Rows
    If oGrid.IsRowSelected(i) Then
      n = n + 1
    End If
  Next i
  
  If n = 0 Then
    ReDim vIds(0)
  Else
    ReDim vIds(n - 1)
  End If
  
  j = 0
  For i = 1 To oGrid.Rows
    If oGrid.IsRowSelected(i) Then
      vIds(j) = oGrid.Cell(i, m_ItemIndexId)
      j = j + 1
    End If
  Next i
End Property
' propiedades privadas
' funciones publicas
Public Sub SetColumnPropertys(ByRef oGrid As Object, _
                              ByRef Column As cIABMGridColumn, _
                              ByRef c As cGridColumn)
  Dim oCol As cABMGridColumn
  Set oCol = Column
  
  c.Caption = Column.Name
  c.Visible = Column.Visible
  
  c.EditType = Column.PropertyType
  c.EditSubType = Column.SubType
  c.Table = Column.Table
  c.AllowEdit = Column.Enabled
  c.Enabled = Column.Enabled
  c.HelpFilter = Column.HelpFilter
  c.HelpType = oCol.HelpType
  
  c.Size = Column.Size
  c.Width = Column.Width
  c.Format = Column.Format
  c.IsForAbm = oCol.IsForAbm
  
  If Column.PropertyType = cspList Then
    c.List = Column.List
  End If
  
  If Column.SubType = cspPercent Then
    If Column.Format = "" Then
      c.Format = "0.00 %"
    End If
  End If
End Sub

Public Function RemoveRow(ByRef oGrid As Object, ByVal lRowToDelete As Long) As Boolean
  oGrid.RemoveRow lRowToDelete
End Function

Public Function ShowCellValue(ByRef oGrid As Object, ByRef Grid As cIABMGrid, ByVal iRow As Long, ByVal iCol As Long) As Boolean
  Dim Row  As cIABMGridRow
  
  On Error GoTo ControlError
  
  oGrid.Redraw = False
  Set Row = Grid.Rows(iRow)
  
  If iRow > oGrid.Rows Then Exit Function
  
  ' Si es un checkbox
  '
  If Grid.Columns(iCol).PropertyType = cspCheck Then
    ' Se que es horrible, pero hay que solucionarlo de
    ' la forma mas simple
    oGrid.Cell(iRow, iCol).IconIndex = IIf(Row(iCol).Id, csECheck, csEUncheck)
    oGrid.Cell(iRow, iCol).ItemData = Row(iCol).Id
    Row(iCol).Value = ""
  
  ' Listas y Helps van por aca
  ElseIf Row(iCol).Id <> 0 Then
    
    oGrid.Cell(iRow, iCol).ItemData = Row(iCol).Id
    If oGrid.Columns(iCol).List Is Nothing Then
      oGrid.Cell(iRow, iCol).Text = Row(iCol).Value
    Else
      oGrid.Cell(iRow, iCol).Text = GetItemFromList(oGrid.Columns(iCol).List, Row(iCol).Id)
    End If
    
  ' El resto por aca
  Else
  
    ' Si es un porcentaje
    If Grid.Columns(iCol).SubType = cspPercent Then
      oGrid.Cell(iRow, iCol).Text = Val(Row(iCol).Value) / 100
    Else
      oGrid.Cell(iRow, iCol).Text = Row(iCol).Value
      oGrid.Cell(iRow, iCol).ItemData = 0
    End If
  End If
  oGrid.Cell(iRow, iCol).TextAlign = oGrid.Columns(iCol).Align

  oGrid.Redraw = True

  ShowCellValue = True
  GoTo ExitProc
ControlError:
  MngError Err, "ShowCellValue", "cABMCSGrid", "", "Error al modificar la Grid", csErrorWarning, csErrorVba
ExitProc:
End Function

' Actualiza la coleccion rows del objeto grid de iProp
' con los valores select del objeto row de la coleccion
' rows del control cGrid.
'
' Siempre hay al menos una fila seleccionada ya que la
' que tiene el foco esta siempre seleccionada
'
Public Sub RefreshSelectedInGrid(ByRef iProp As cIABMProperty)
  On Error GoTo ControlError
  
  Dim oProp As cABMProperty
  Dim oRow  As cABMGridRow
  Dim i     As Long
  
  Set oProp = iProp
  
  Dim ctlGrid As cGridAdvanced
  
  Set ctlGrid = oProp.ctl
  
  If ctlGrid Is Nothing Then
  
    For Each oRow In iProp.Grid.Rows
      oRow.IsSelected = False
    Next
  
  Else
  
    For Each oRow In iProp.Grid.Rows
      i = i + 1
      oRow.IsSelected = ctlGrid.IsRowSelected(i)
    Next
  
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "RefreshSelectedInGrid", "cABMCSGrid", "", "Error al modificar la Grid", csErrorWarning, csErrorVba
ExitProc:
End Sub

' Solo acepta filas seleccionadas si el foco esta en la primera
' columna
'
' Esto es para diferenciar entre una fila seleccionada explicitamente
' de una fila seleccionada por que el foco esta en ella
'
Public Sub RefreshSelectedInGrid2(ByRef iProp As cIABMProperty)
  On Error GoTo ControlError
  
  Dim oProp As cABMProperty
  Dim oRow  As cABMGridRow
  Dim i     As Long
  
  Set oProp = iProp
  
  Dim ctlGrid As cGridAdvanced
  
  Set ctlGrid = oProp.ctl
  
  If ctlGrid Is Nothing Then
  
    For Each oRow In iProp.Grid.Rows
      oRow.IsSelected = False
    Next
  
  Else
  
    Dim grdctl As Object
    Set grdctl = ctlGrid.GridCtrl
  
    If grdctl.SelectedCol <> 1 Then
  
      For Each oRow In iProp.Grid.Rows
        oRow.IsSelected = False
      Next
  
    Else
    
      For Each oRow In iProp.Grid.Rows
        i = i + 1
        oRow.IsSelected = ctlGrid.IsRowSelected(i)
      Next
      
    End If
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "RefreshSelectedInGrid", "cABMCSGrid", "", "Error al modificar la Grid", csErrorWarning, csErrorVba
ExitProc:
End Sub

'-----------------------------------------------------------------------------------------------------------
Public Function LoadFromRows(ByRef oGrid As Object, ByVal Grid As cIABMGrid, ByVal NoChangeColumns As Boolean, ByVal Name As String) As Boolean
  On Error GoTo ControlError
  
  Dim Row         As cIABMGridRow
  Dim Column      As cIABMGridColumn
  Dim iRow        As Integer
  Dim oRow        As cABMGridRow
  Dim c           As cGridColumn
  Dim oCol        As cABMGridColumn
  Dim lHeight     As Long
  
  oGrid.Redraw = False
  
  SaveColumnWidth oGrid, Name
  SaveColumnOrder oGrid, Name
  
  If Not NoChangeColumns Then
    oGrid.Clear True
    oGrid.Columns.Clear
    
    For Each Column In Grid.Columns
      Set oCol = Column
      Set c = oGrid.Columns.Add(Nothing, , oCol.IsDetail)
      SetColumnPropertys oGrid, Column, c
    Next
  End If
  
  With oGrid
    If .HasRowText Then
      .RowTextStartColumn = 4
      .RowMode = True
    End If
  End With
  
  If Grid.Rows.Count > 0 Then
    oGrid.Rows = Grid.Rows.Count
    
    For Each Row In Grid.Rows
      iRow = iRow + 1
      
      Set oRow = Row
      If Not oRow.Visible Then
        oGrid.RowVisible(oRow.Index) = False
      End If
      
      oGrid.RowBackColor(oRow.Index) = oRow.BackColor
      oGrid.RowForeColor(oRow.Index) = oRow.ForeColor
      
      pSetRow oGrid, Row, iRow, Grid.Columns
      
      With oGrid
        If .HasRowText Then
          lHeight = .EvaluateTextHeight(iRow, .Columns.Count) + .DefaultRowHeight + 2
          .RowHeight(iRow) = lHeight
        End If
      End With

    Next
  
    If oGrid.Rows > 0 Then
      Dim oldMultiSelect As Boolean
      
      oldMultiSelect = oGrid.MultiSelect
      oGrid.MultiSelect = False
      oGrid.SelectedRow = 1
      oGrid.MultiSelect = oldMultiSelect
    End If
    
  Else
    oGrid.Clear False
  End If
  
  If Not NoChangeColumns Then
    GetColumnWidth oGrid, Name
    GetColumnOrder oGrid, Name
  End If
  
  If m_AllowAddNew Then
    oGrid.Rows = oGrid.Rows + 1
    oGrid.Cell(oGrid.Rows, 1).Text = oGrid.Rows
  End If
  
  oGrid.ClearSelection
  
  oGrid.Redraw = True
  
  LoadFromRows = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "LoadFromRows", "cABMCSGrid", "", "Error al cargar la Grid", csErrorWarning, csErrorVba
ExitProc:
End Function

Public Function LoadFromRow(ByRef oGrid As Object, ByRef Row As cIABMGridRow, ByVal RowIndex As Long, ByRef Columns As cIABMGridColumns) As Boolean
  On Error GoTo ControlError
  
  Dim iRow           As Integer
  
  oGrid.Redraw = False
  
  If RowIndex > oGrid.Rows Then
    oGrid.Rows = RowIndex
  End If
  
  iRow = RowIndex
  pSetRow oGrid, Row, iRow, Columns
  
  oGrid.Redraw = True
  
  LoadFromRow = True
  GoTo ExitProc
ControlError:
  MngError Err, "LoadFromRow", "cABMCSGrid", "", "Error al cargar la Grid", csErrorWarning, csErrorVba
ExitProc:
End Function

' Devuelve un string con el ucase de la suma de todos los Names de Columns
Public Function GetPasswordFromColumns(ByVal Grid As cIABMGrid) As String
  Dim Column As cIABMGridColumn
  
  For Each Column In Grid.Columns
      GetPasswordFromColumns = GetPasswordFromColumns + Column.Name
  Next
  GetPasswordFromColumns = UCase(GetPasswordFromColumns)
End Function

Public Sub GetSelected(ByRef oGrid As Object, ByRef Seleccionados() As Long)
  Dim n  As Long
  Dim i  As Integer
  Dim j  As Integer
  
  Dim mouse As cMouseWait
  Set mouse = New cMouseWait
  
  DoEvents
  
  For i = 1 To oGrid.Rows
    If oGrid.IsRowSelected(i) Then
      n = n + 1
    End If
  Next i
  
  If n = 0 Then
    ReDim Seleccionados(0)
  Else
    ReDim Seleccionados(n - 1)
  End If
  
  j = 0
  For i = 1 To oGrid.Rows
    If oGrid.IsRowSelected(i) Then
      Seleccionados(j) = oGrid.Cell(i, m_ItemIndexId)
      j = j + 1
    End If
  Next i
End Sub

' Solo para Grids con multiselect = false
Public Function GetSelectedId(ByRef oGrid As Object) As Long
  
  If oGrid.SelectedRow = 0 Then Exit Function
  
  GetSelectedId = oGrid.Cell(oGrid.SelectedRow, m_ItemIndexId)
End Function

Public Function GetSelectedName(ByRef oGrid As Object) As String
  GetSelectedName = GetSelectedCol(oGrid, 2)
End Function

Public Function GetSelectedAlias(ByRef oGrid As Object) As String
  GetSelectedAlias = GetSelectedCol(oGrid, 1)
End Function

Public Function GetSelectedCol(ByRef oGrid As Object, ByVal Col As Integer) As String
  On Error GoTo ControlError
  
  If oGrid.SelectedRow = 0 Then Exit Function
  
  GetSelectedCol = oGrid.Cell(oGrid.SelectedRow, Col).Text
  
  Exit Function
ControlError:
  MngError Err, "GetSelectedCol", "cABMCSGrid", "", "Error al obtener la Column " & Col, csErrorWarning, csErrorVba
End Function

Public Function GetSelectedCount(ByRef oGrid As Object) As Integer
  Dim n  As Long
  Dim i  As Integer
  Dim j  As Integer
  
  For i = 1 To oGrid.Rows
    If oGrid.IsRowSelected(i) Then
      n = n + 1
    End If
  Next i
  
  GetSelectedCount = n
End Function

Public Sub Clear(ByRef oGrid As Object, ByVal Name As String)
  SaveColumnWidth oGrid, Name
  SaveColumnOrder oGrid, Name
  oGrid.Clear True
End Sub
'-----------------------------------------------------------------------------------------------------------
Public Sub SetPropertys(ByRef oGrid As Object)
  'oGrid.Checkboxes = m_CheckBox
  oGrid.BackColor = m_BackColor
  oGrid.BorderStyle = ecgBorderStyle3d
  oGrid.HeaderDragReOrderColumns = True
  oGrid.HeaderFlat = True
  oGrid.RowMode = True
  oGrid.Header = True
  oGrid.MultiSelect = False
  oGrid.DrawFocusRectangle = True
  oGrid.GridLines = True
End Sub

Public Sub SaveColumnWidth(ByRef oGrid As Object, ByVal Name As String)
  On Error GoTo ControlError
  
  Dim i As Integer
  With oGrid
    For i = 2 To .Columns.Count
      SetRegistry csInterface, Name + "_COL_" + Trim(i), .Columns(i).Width
    Next i
  End With

ControlError:
End Sub

Public Sub GetColumnWidth(ByRef oGrid As Object, ByVal Name As String, Optional idxOcultar As Integer = 0)
  Dim i As Integer
  Dim Width As Long
  Dim iLastCol As Long
  Dim colsWidth As Long
  Dim startRowCol As Long
  With oGrid
    iLastCol = .Columns.Count
    If .HasRowText Then
    
      ' Con esto funciona mal
      ' abra que ver por que
      '
      'startRowCol = .RowTextStartColumn
      
      If startRowCol < idxOcultar + 1 Then
        startRowCol = idxOcultar + 2
      End If
      
      For i = 2 To iLastCol - 1
        Width = GetRegistry(csInterface, Name + "_COL_" + Trim(i), -1)
        If Width = 0 Then Width = c_col_width
        
        ' Esto es por que aveces anda mal y las columnas quedan chiquitas
        '
        If .Columns(i).Visible Then If Width < 70 Then Width = 1500
        
        If Width > -1 Then
          .Columns(i).Width = IIf(Width > COL_MAX_WIDTH, COL_MAX_WIDTH, Width)
        ElseIf .Columns(i).Width = 0 Then
          .Columns(i).Width = c_col_width
        End If
        
        If i >= startRowCol Then
          colsWidth = colsWidth + .Columns(i).Width
        End If
      Next i
      .Columns(iLastCol).Width = colsWidth
    Else
      For i = 2 To iLastCol
        Width = GetRegistry(csInterface, Name + "_COL_" + Trim(i), -1)
        If Width = 0 Then Width = c_col_width
        
        ' Esto es por que aveces anda mal y las columnas quedan chiquitas
        '
        If .Columns(i).Visible Then If Width < 70 Then Width = 1500
        
        If Width > -1 Then
          .Columns(i).Width = IIf(Width > COL_MAX_WIDTH, COL_MAX_WIDTH, Width)
        ElseIf .Columns(i).Width = 0 Then
          .Columns(i).Width = c_col_width
        End If
        
      Next i
    End If
    
    For i = 2 To idxOcultar + 1
      .Columns(i).Width = 0
      .SetHeaders
    Next i
  End With
End Sub

Public Sub SaveColumnOrder(ByRef oGrid As Object, ByVal Name As String)
  On Error GoTo ControlError
  
  Dim i As Integer
  With oGrid
    For i = 1 To .Columns.Count
      SetRegistry csInterface, Name + "_ORDER_" + Trim(i), .Columns(i).Order
    Next i
  End With

ControlError:
End Sub

Public Sub GetColumnOrder(ByRef oGrid As Object, ByVal Name As String)
  Dim i As Integer
  Dim Width As Long
  Dim iLastCol As Long
  
  With oGrid
    iLastCol = .Columns.Count
    For i = 1 To iLastCol
      .Columns(i).Order = GetRegistry(csInterface, Name + "_ORDER_" + Trim(i), -1)
    Next i
  End With
End Sub

' funciones privadas

' construccion - destruccion
Private Sub Class_Initialize()
  m_BackColor = vbWindowBackground
  m_ItemIndexId = 1
End Sub

Private Sub pSetRow(ByRef oGrid As Object, _
                    ByRef Row As cIABMGridRow, _
                    ByVal iRow As Integer, _
                    ByRef Columns As cIABMGridColumns)
  
  Dim iCol        As Integer
  Dim Cell        As cGridCell
  Dim Column      As cIABMGridColumn
  Dim CtlColumn   As cGridColumn
  
  Dim oFormat   As cABMGridCellFormat
  Dim iFormat   As cIABMGridCellFormat
  Dim oFont     As StdFont
  Dim bEnabled  As Boolean
  
  bEnabled = oGrid.Enabled
  
  For iCol = 1 To Row.Count
  
    Set Cell = oGrid.Cell(iRow, iCol)
    Set CtlColumn = oGrid.Columns(iCol)
    Set Column = Columns(iCol)
    
    With Row(iCol)
  
      ' Si es un checkbox
      '
      If Column.PropertyType = cspCheck Then
        ' Se que es horrible, pero hay que solucionarlo de
        ' la forma mas simple
        Cell.IconIndex = IIf(.Id, csECheck, csEUncheck)
        Cell.ItemData = .Id
        .Value = ""
      
      ' Listas y Helps van por aca
      ElseIf .Id <> 0 Then
        Cell.ItemData = .Id
        
        ' Si es Help
        '
        If CtlColumn.List Is Nothing Then
          Cell.Text = .Value
        
        ' Si es una lista
        '
        Else
          .Value = GetItemFromList(CtlColumn.List, .Id)
          Cell.Text = .Value
        End If
      
      ' El resto por aca
      Else
      
        If Column.PropertyType = cspDate Then
          Cell.Text = GetDateValueForGrid(.Value)
      
        ' Si es un porcentaje
        ElseIf Column.SubType = cspPercent Then
          Cell.Text = Val(.Value) / 100
        
        Else
          Cell.Text = .Value
          Cell.ItemData = 0
        End If
      
      End If
      
      Cell.TextAlign = CtlColumn.Align
      
      ' Formato de cada celda
      '
      Set iFormat = .Format
      If Not iFormat Is Nothing Then
      
        Set oFormat = .Format
      
        If Not iFormat.Enabled Then
          Cell.BackColor = vbButtonFace
          oFormat.Bold = True
        Else
          Cell.BackColor = iFormat.BackColor
        End If
        
        Cell.ForeColor = iFormat.Color
        Cell.TextAlign = oFormat.Align
        
        Set oFont = New StdFont
        With oFont
          .Name = oFormat.FontName
          .Italic = oFormat.Italic
          .Bold = oFormat.Bold
          .Size = oFormat.FontSize
          .Strikethrough = oFormat.Strike
          .Underline = oFormat.Underline
        End With
        Set Cell.Font = oFont
      End If
    
    End With
  Next
End Sub
