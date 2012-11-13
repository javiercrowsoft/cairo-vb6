VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cABMListView"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cABMListView
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
' estructuras
' variables privadas
Private m_Grid As ListView

Private m_CheckBox          As Boolean
Private m_BackColor         As OLE_COLOR
' propiedades publicas
Public Property Get Grid() As Object
    Set Grid = m_Grid
End Property
Public Property Set Grid(RHS As Object)
    Set m_Grid = RHS
End Property
Public Property Get Columns() As Integer
    Columns = m_Grid.ColumnHeaders.Count
End Property
Public Property Get Rows() As Integer
    Rows = m_Grid.ListItems.Count
End Property
Public Property Get CheckBox() As Boolean
    CheckBox = m_CheckBox
End Property
Public Property Let CheckBox(ByVal RHS As Boolean)
    m_CheckBox = RHS
End Property
Public Property Get BackColor() As OLE_COLOR
    BackColor = m_BackColor
End Property
Public Property Let BackColor(ByVal RHS As OLE_COLOR)
    m_BackColor = RHS
    m_Grid.BackColor = m_BackColor
End Property
Public Property Get Id() As Long
    If m_Grid.SelectedItem Is Nothing Then Exit Property
    Id = GetIdFromKey(m_Grid.SelectedItem.Key)
End Property
Public Property Get Ids(ByRef vIds() As Long) As Boolean
    Dim n    As Long
    Dim i    As Integer
    Dim j    As Integer
    
    For i = 1 To m_Grid.ListItems.Count
        If m_Grid.ListItems(i).Selected Then
            n = n + 1
        End If
    Next i
    
    If n = 0 Then
        ReDim vIds(0)
    Else
        ReDim vIds(n - 1)
    End If
    
    j = 0
    For i = 1 To m_Grid.ListItems.Count
        If m_Grid.ListItems(i).Selected Then
            vIds(j) = GetIdFromKey(m_Grid.ListItems(i).Key)
            j = j + 1
        End If
    Next i
End Property
' propiedades privadas
' funciones publicas
Public Function Add() As Boolean

End Function
Public Function Remove() As Boolean

End Function
'-----------------------------------------------------------------------------------------------------------
Public Function LoadFromRows(ByVal Grid As cIABMGrid) As Boolean
    Dim Row            As cIABMGridRow
    Dim RowValue       As cIABMGridCellValue
    Dim Column         As cIABMGridColumn
    Dim i              As Integer
    
    Dim Item        As MSComctlLib.ListItem
    Dim SubItem     As MSComctlLib.ListSubItem
    
    On Error GoTo ControlError
    
    m_Grid.ListItems.Clear
    m_Grid.ColumnHeaders.Clear
    
    For Each Column In Grid.Columns
        m_Grid.ColumnHeaders.Add , , Column.Name
    Next
    
    For Each Row In Grid.Rows
        
        ' En la primera Column esta el id que lo meto en el Key, y el Name esta en
        ' la segunda Column que lo meto en el text del item
        Set Item = m_Grid.ListItems.Add(, GetKey(Row(1).Value), Row(2).Value)
        
        For i = 3 To Row.Count
            
            Set RowValue = Row(i)
            Set SubItem = Item.ListSubItems.Add(, , RowValue.Value)
        Next
    Next
    
    If m_Grid.ListItems.Count > 0 Then
        Dim oldMultiSelect As Boolean
        
        oldMultiSelect = m_Grid.MultiSelect
        m_Grid.MultiSelect = False
        m_Grid.ListItems(1).Selected = True
        m_Grid.MultiSelect = oldMultiSelect
    End If
    
    LoadFromRows = True
    GoTo ExitProc
ControlError:
    MngError Err, "LoadFromRows", "cABMListView", "", "Error al cargar la Grid", csErrorWarning, csErrorVba
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

Public Sub GetSelected(ByRef Seleccionados() As Long)
    Dim n    As Long
    Dim i    As Integer
    Dim j    As Integer
    
    Dim mouse As cMouseWait
    Set mouse = New cMouseWait
    
    DoEvents
    
    For i = 1 To m_Grid.ListItems.Count
        If m_Grid.ListItems(i).Selected Then
            n = n + 1
        End If
    Next i
    
    If n = 0 Then
        ReDim Seleccionados(0)
    Else
        ReDim Seleccionados(n - 1)
    End If
    
    j = 0
    For i = 1 To m_Grid.ListItems.Count
        If m_Grid.ListItems(i).Selected Then
            Seleccionados(j) = GetIdFromKey(m_Grid.ListItems(i).Key)
            j = j + 1
        End If
    Next i
End Sub

' Solo para Grids con multiselect = false
Public Function GetSelectedId() As Long
    
    If m_Grid.SelectedItem Is Nothing Then Exit Function
    
    GetSelectedId = GetIdFromKey(m_Grid.SelectedItem.Key)
End Function

Public Function GetSelectedName() As String
    GetSelectedName = GetSelectedCol(2)
End Function

Public Function GetSelectedAlias() As String
    GetSelectedAlias = GetSelectedCol(1)
End Function

Public Function GetSelectedCol(ByVal Col As Integer) As String
    On Error GoTo ControlError
    If m_Grid.SelectedItem Is Nothing Then Exit Function
    
    If Col = 1 Then
        GetSelectedCol = m_Grid.SelectedItem.Text
    Else
        GetSelectedCol = m_Grid.SelectedItem.SubItems(Col - 1)
    End If
    Exit Function
ControlError:
    MngError Err, "GetSelectedCol", "cABMListView", "", "Error al obtener la Column " & Col, csErrorWarning, csErrorVba
End Function

Public Function GetSelectedCount() As Integer
    Dim n    As Long
    Dim i    As Integer
    Dim j    As Integer
    
    For i = 1 To m_Grid.ListItems.Count
        If m_Grid.ListItems(i).Selected Then
            n = n + 1
        End If
    Next i
    
    GetSelectedCount = n
End Function

Public Sub Clear()
    m_Grid.ListItems.Clear
End Sub
'-----------------------------------------------------------------------------------------------------------
Public Sub SetPropertys()
    m_Grid.Checkboxes = m_CheckBox
    m_Grid.BackColor = m_BackColor
    m_Grid.AllowColumnReorder = True
    m_Grid.BorderStyle = ccNone
    m_Grid.FullRowSelect = True
    m_Grid.HideColumnHeaders = False
    m_Grid.View = lvwReport
    m_Grid.LabelEdit = lvwManual
    m_Grid.MultiSelect = True
    m_Grid.GridLines = True
End Sub
Public Sub SaveColumnWidth(ByVal Name As String)
    Dim i As Integer
    For i = 1 To m_Grid.ColumnHeaders.Count
        SetRegistry csInterface, Name + "_COL_" + Trim(i), m_Grid.ColumnHeaders(i).Width
    Next i
End Sub
Public Sub GetColumnWidth(ByVal Name As String, Optional idxOcultar As Integer = 0)
    Dim i As Integer
    Dim Width As Long
    
    For i = 1 To m_Grid.ColumnHeaders.Count
        Width = GetRegistry(csInterface, Name + "_COL_" + Trim(i), -1)
        If Width > -1 Then
            m_Grid.ColumnHeaders(i).Width = Width
        ElseIf m_Grid.ColumnHeaders(i).Width = 0 Then
            m_Grid.ColumnHeaders(i).Width = 2000
        End If
    Next i
    
    For i = 2 To idxOcultar + 1
        m_Grid.ColumnHeaders(i).Width = 0
    Next i
End Sub

' funciones privadas
Private Function GetAlignment(ByVal VarType As csTypes) As Integer
    Select Case VarType
        Case csTypes.csBoolean
            ' esto es por que el listview no centra iconos
            GetAlignment = lvwColumnLeft
        Case csTypes.csCurrency, csTypes.csDouble, csTypes.csInteger, csTypes.csLong, csTypes.csSingle
            GetAlignment = lvwColumnRight
        Case Else
            GetAlignment = lvwColumnLeft
    End Select
End Function
' construccion - destruccion
Private Sub Class_Initialize()
    m_BackColor = vbWindowBackground
End Sub
Private Sub Class_Terminate()
    Set m_Grid = Nothing
End Sub


