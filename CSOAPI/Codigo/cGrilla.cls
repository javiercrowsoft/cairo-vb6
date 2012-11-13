VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGrid"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cGrid
' 03-02-00

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
Private m_Grid As Object

Private m_Row      As Integer
Private m_Rows     As Integer
Private m_Column   As Integer
Private m_Columns  As Integer

Private m_CollRowXId    As Collection
' Properties publicas
Public Property Get Grid() As Object
    Set Grid = m_Grid
End Property
Public Property Set Grid(rhs As Object)
    Set m_Grid = rhs
End Property
Public Property Get Columns() As Integer
    Columns = m_Columns
End Property
Public Property Let Columns(rhs As Integer)
    m_Columns = rhs
End Property
Public Property Get Rows() As Integer
    Rows = m_Rows
End Property
Public Property Let Rows(rhs As Integer)
    m_Rows = rhs
End Property
' Properties privadas
' funciones publicas
Public Function Add() As Boolean

End Function
Public Function Remove() As Boolean

End Function
'-----------------------------------------------------------------------------------------------------------
Public Function LoadFromRecordSet(rs As ADODB.Recordset) As Boolean
    Dim RowXId As cGridRowXID
    On Error GoTo ControlError
    
    CollClear m_CollRowXId
    m_Columns = rs.Fields.Count
    Set gDB.rs = rs
    
    If rs.EOF Then
        m_Grid.Rows = 0
        m_Rows = 2
    Else
        rs.MoveLast
        rs.MoveFirst
        If rs.RecordCount = -1 Then
            m_Rows = 2
        Else
            m_Rows = rs.RecordCount + 1
        End If
    End If

    ' Cantidad de Rows
    m_Grid.Rows = m_Rows
    
    m_Grid.FixedRows = 1
    m_Grid.FixedCols = 0
    m_Grid.ColWidth(0) = 0
    
    ' Title de las Columnas
    m_Grid.Cols = m_Columns + 1
    m_Grid.Row = 0
    For m_Column = 0 To m_Columns - 1
        m_Grid.Col = m_Column
        m_Grid.Text = rs.Fields(m_Column).Name
    Next m_Column
    
    m_Row = 0
    While Not gDB.EOF
        m_Row = m_Row + 1
        
        If m_Row >= m_Rows Then
            m_Rows = m_Rows + 1
            m_Grid.Rows = m_Rows
        End If
        m_Column = 0
        m_Grid.Row = m_Row
        While Not gDB.EOF_Field
            m_Grid.Col = m_Column
            m_Grid.Text = gDB.Field
            If gDB.FieldType = csFieldBoolean Then
                m_Grid.CellAlignment = 1 ' flexAlignCenterCenter
            End If
            m_Column = m_Column + 1
        Wend
        Set RowXId = New cGridRowXID
        RowXId.Id = rs.Fields(0)
        RowXId.Row = m_Row
        m_CollRowXId.Add RowXId
        gDB.MoveNext
    Wend
    
    If m_Grid.Rows > 1 Then
        m_Grid.Row = 1
        m_Grid.Col = 0
        m_Grid.RowSel = 1
        m_Grid.ColSel = m_Grid.Cols - 1
    End If
    
    LoadFromRecordSet = True
    GoTo ExitProc
ControlError:
    MngError Err, "LoadFromRecordSet", "cGrid", "", "Error al cargar la grilla", csErrorWarning, csErrorVba
ExitProc:
    Set RowXId = Nothing
End Function
Public Function SetLineFromRecordSet(rs As ADODB.Recordset, ByVal Id As Long) As Boolean
    Dim RowXId As cGridRowXID
    On Error GoTo ControlError
    
    For Each RowXId In m_CollRowXId
        If RowXId.Id = Id Then
            Set gDB.rs = rs
            While Not gDB.EOF
                m_Grid.Row = RowXId.Row
                m_Column = 0
                While Not gDB.EOF_Field
                    m_Grid.Col = m_Column
                    m_Grid.Text = gDB.Field
                    If gDB.FieldType = csFieldBoolean Then
                        m_Grid.CellAlignment = 1 'flexAlignCenterCenter
                    End If
                    m_Column = m_Column + 1
                Wend
                gDB.MoveNext
            Wend
            Exit For
        End If
    Next
        
    m_Grid.Col = 0
    m_Grid.ColSel = m_Grid.Cols - 1
    
    SetLineFromRecordSet = True
    Exit Function
ControlError:
    MngError Err, "SetLineFromRecordSet", "cGrid", "", "Error al cargar la linea", csErrorWarning, csErrorVba
End Function
'-----------------------------------------------------------------------------------------------------------
'Public Function LoadFromBranch(ByVal Branch As cBranch) As Boolean
'    Dim RowXId  As cGridRowXID
'    Dim Leave   As cLeave
'    Dim Column As cLeaveColumn
'    On Error GoTo ControlError
'
'    CollClear m_CollRowXId
'    m_Columns = Branch.Columns.Count
'
'    If Branch.Leaves.Count = 0 Then
'        m_Grid.Rows = 0
'        m_Rows = 2
'    Else
'        m_Rows = Branch.Leaves.Count + 1
'    End If
'
'    ' Cantidad de filas
'    m_Grid.Rows = m_Rows
'
'    m_Grid.FixedRows = 1
'    m_Grid.FixedCols = 0
'    m_Grid.ColWidth(0) = 0
'
'    ' Titulo de las Columnas
'    m_Grid.Cols = m_Columns + 1
'    m_Grid.Row = 0
'
'    m_Column = 0
'    For Each Column In Branch.Columns
'        m_Grid.Col = m_Column
'        m_Grid.Text = Column.Name
'        m_Column = m_Column + 1
'    Next
'
'    m_Row = 0
'
'    For Each Leave In Branch.Leaves
'        m_Row = m_Row + 1
'
'        If m_Row >= m_Rows Then
'            m_Rows = m_Rows + 1
'            m_Grid.Rows = m_Rows
'        End If
'        m_Column = 0
'        m_Grid.Row = m_Row
'        For Each Column In Leave.Columns
'            m_Grid.Col = m_Column
'            m_Grid.Text = Column.Value
'            If Column.VarType = csFieldBoolean Then
'                m_Grid.CellAlignment = 1 'flexAlignCenterCenter
'            End If
'            m_Column = m_Column + 1
'        Next
'        Set RowXId = New cGridRowXID
'        RowXId.Id = Leave.Id
'        RowXId.Row = m_Row
'        m_CollRowXId.Add RowXId
'    Next
'
'    If m_Grid.Rows > 1 Then
'        m_Grid.Row = 1
'        m_Grid.Col = 0
'        m_Grid.RowSel = 1
'        m_Grid.ColSel = m_Grid.Cols - 1
'    End If
'
'    LoadFromBranch = True
'    GoTo ExitProc
'ControlError:
'    MngError Err, "LoadFromBranch", "cGrid", "", "Error al cargar la grilla", csErrorWarning, csErrorVba
'ExitProc:
'    Set RowXId = Nothing
'End Function

' Devuelve un string con el ucase de la suma de todos los Names de Columns
Public Function GetKeyFromColumns(ByVal Branch As cBranch) As String
    Dim Column As cLeaveColumn
    
    For Each Column In Branch.Columns
        GetKeyFromColumns = GetKeyFromColumns + Column.Name
    Next
    GetKeyFromColumns = UCase(GetKeyFromColumns)
End Function

Public Sub GetSelected(ByRef Seleccionados() As Long)
    Dim r    As Long
    Dim rsel As Long
    Dim i    As Integer
    Dim j    As Integer
    
    ' Los seleccionados van desde row hasta rowsel
    rsel = m_Grid.RowSel
    r = m_Grid.Row
    j = 0
    
    If r < rsel Then
        i = r
        r = rsel
        rsel = i
    End If
    
    ReDim Seleccionados(r - rsel)
    For i = rsel To r
        Seleccionados(j) = m_CollRowXId(i).Id
        j = j + 1
    Next i
End Sub

Public Sub Clear()
    CollClear m_CollRowXId
    
    ' Cantidad de Rows
    m_Grid.Rows = 2
    m_Grid.Cols = 1
    
    m_Grid.FixedRows = 1
    m_Grid.FixedCols = 0
    m_Grid.ColWidth(0) = 15000
    
    m_Grid.Col = 0
    m_Grid.Row = 0
    m_Grid.Text = ""
    m_Grid.Row = 1
    m_Grid.Text = ""
End Sub
'-----------------------------------------------------------------------------------------------------------
Public Function SetPropertys()
    m_Grid.AllowUserResizing = 1 'flexResizeColumns
    m_Grid.BackColorBkg = m_Grid.BackColor
    m_Grid.GridColorFixed = vbWindowBackground
    m_Grid.GridColor = vbWindowBackground
    m_Grid.AllowBigSelection = False
    m_Grid.SelectionMode = 1 'flexSelectionByRow
    m_Grid.Rows = 2
    m_Grid.Cols = 1
    m_Grid.FixedRows = 1
    m_Grid.FixedCols = 0
    m_Grid.ColWidth(0) = 50000
End Function
Public Sub SaveColumnWidth(ByVal Name As String)
    Dim i As Integer
    For i = 0 To m_Grid.Cols - 1
        SetRegistry csInterface, Name + "_COL_" + Trim(i), m_Grid.ColWidth(i)
    Next i
End Sub
Public Sub GetColumnWidth(ByVal Name As String, Optional idxOcultar As Integer = 0)
    Dim i As Integer
    Dim Width As Long
    
    For i = 0 To m_Grid.Cols - 1
        Width = GetRegistry(csInterface, Name + "_COL_" + Trim(i), -1)
        If Width > -1 Then
            m_Grid.ColWidth(i) = Width
        ElseIf m_Grid.ColWidth(i) = 0 Then
            m_Grid.ColWidth(i) = 2000
        End If
    Next i
    
    For i = 0 To idxOcultar
        m_Grid.ColWidth(i) = 0
    Next i
    m_Grid.ColWidth(m_Grid.Cols - 1) = 10000
End Sub

' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
    Set m_CollRowXId = New Collection
End Sub
Private Sub Class_Terminate()
    Set m_Grid = Nothing
    CollClear m_CollRowXId
    Set m_CollRowXId = Nothing
End Sub
