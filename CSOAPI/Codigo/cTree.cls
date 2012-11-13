VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTreeAux"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cTreeAux
' 23-01-2000

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
Private Type Tree
    ID          As Long
    Name        As String
End Type

Private Type Branch
    ID          As Long
    Name        As String
    TreeId      As Long
    Father      As Long
End Type

' variables privadas
Private m_Tree        As TreeView
Private m_Grid        As Object
Private m_Combo       As ComboBox

Private m_Table         As String

Private m_DB            As cDataBase
Private m_Trees()       As Tree
Private m_Branchs()     As Branch

Private m_LastTree      As Long
Private m_LastBranch    As Long

Private m_Sqlstmt       As String
Private m_FieldId       As String

' Properties publicas
Public Property Set DB(ByRef rhs As cDataBase)
    Set m_DB = rhs
End Property
' Properties privadas
' funciones publicas
Public Function LoadTree(ByVal Table As csTables, ByRef Tree As Object, Optional ByRef Combo As Object, Optional ByRef Grid As Object) As Boolean
    Dim DiccTabla As cDiccTabla
    Set DiccTabla = New cDiccTabla
    If Not DiccTabla.Load(Table) Then
        Set DiccTabla = Nothing
        Exit Function
    End If
    LoadTree = LoadTreeForDiccTabla(DiccTabla, Tree, Combo, Grid)
    Set DiccTabla = Nothing
End Function
Public Sub ShowLeaves()
    Dim RamId As Long
    Dim rs As ADODB.Recordset
    Dim sqlstmt As String
    Dim nGrid As cGrid
    
    RamId = GetIDfromTree()
    sqlstmt = m_Sqlstmt + " where " + m_FieldId + " IN (select " + cscHojaId + " where " + cscRamId + " = " + Trim(RamId) + ")"
    
    If Not m_DB.OpenRs(sqlstmt, rs, csRsKeySet, csLockReadOnly, , "ShowLeaves", "cTreeAux", "Error al mostrar el contenido de la rama", csErrorInformation) Then Exit Sub
    
    Set nGrid = New cGrid
    
    nGrid.Grid = m_Grid
    
    If Not nGrid.LoadFromRecordSet(rs) Then Exit Sub
    
End Sub
' funciones friend
Friend Function LoadTreeForDiccTabla(Table As cDiccTabla, ByRef Tree As TreeView, Optional ByRef Combo As ComboBox, Optional ByRef Grid As Object) As Boolean
    Dim sqlstmt As String
    Dim rs As ADODB.Recordset
'
'------
'
    CSKernelClient2.Title = "Carga de arboles"
    
    m_Table = Table.Name
    
    m_Sqlstmt = Table.SqlHelp
    
    m_FieldId = Table.FieldId
    
    ' Obtengo los árboles
    sqlstmt = "select " + cscArbId + "," + cscArbNombre + " from " + csTArbol + _
              " where " + cscTblId + " = " + Table.ID
    
    If Not m_DB.OpenRs(sqlstmt, rs, csRsKeySet, csLockReadOnly, 8, "LoadTree", "cTreeAux", "Error al cargar arboles de la tabla " + Table.Name, csErrorInformation) Then Exit Function
    
    If rs.EOF Then
        CSKernelClient2.MsgWarning "Debe definir al menos un árbol de " + m_Table
        Exit Function
    End If

    rs.MoveLast
    rs.MoveFirst
    ReDim m_Trees(1 To rs.RecordCount)
    
    Dim i As Integer
    i = 0
    While Not rs.EOF
        i = i + 1
        m_Trees(i).ID = rs.Fields(cscArbId)
        m_Trees(i).Name = rs.Fields(cscArbNombre)
        rs.MoveNext
    Wend
    
'
'------
'
    ' Obtengo las ramas
    sqlstmt = "select " + csTArbol + "." + cscArbId + "," + cscRamId + "," + cscRamNombre + "," + cscRamPadre + " from " + csTArbol + " inner join " + _
              "\n " + csTRama + " on " + csTArbol + "." + cscArbId + " = " + csTRama + "." + cscArbId + "\n " + _
              " where " + cscTblId + " = " + m_Table
    
    If Not m_DB.OpenRs(sqlstmt, rs, csRsKeySet, csLockReadOnly, 8, "LoadTree", "cTreeAux", "Error al cargar arboles de la tabla " + Table.ID, csErrorInformation) Then Exit Function

    If rs.EOF Then
        CSKernelClient2.MsgError "Falta la raiz del árbol de " + m_Table + ". Consulte con el implementador"
        Exit Function
    End If

    rs.MoveLast
    rs.MoveFirst
    ReDim m_Branchs(1 To rs.RecordCount)
    
    i = 0
    While Not rs.EOF
        i = i + 1
        m_Branchs(i).ID = rs.Fields(cscRamId)
        m_Branchs(i).Name = rs.Fields(cscRamNombre)
        m_Branchs(i).TreeId = rs.Fields(cscArbId)
        m_Branchs(i).Father = rs.Fields(cscRamPadre)
        rs.MoveNext
    Wend

    LoadConfig Table.ID
    
    Set m_Tree = Tree
    Set m_Grid = Grid
    Set m_Combo = Combo
    
    On Error GoTo ControlError
    
    m_Tree.Visible = False
    
    LoadComboTree
    LoadTree_
    
        
    LoadTreeForDiccTabla = True
ExitProc:
    m_Tree.Visible = True
    Exit Function
ControlError:
    
    Resume ExitProc
End Function
' funciones privadas
Private Function LoadConfig(ByVal ID As Long) As Boolean
    
End Function
' construccion - destruccion

Private Function LoadComboTree() As Boolean
    Dim i As Integer
    
    On Error GoTo ControlError

    m_Combo.Clear
    For i = 1 To UBound(m_Trees)
        ListAdd m_Combo, m_Trees(i).Name, m_Trees(i).ID
    Next i
    
ControlError:
    MngError Err, "LoadComboTree", "cTreeAux", "", "Error al cargar la lista de arboles para la tabla " + m_Table, csErrorWarning
End Function

Private Function LoadTree_() As Boolean
    Dim ID As Long
    Dim i As Integer
    
    LockWindowUpdate m_Tree.hWnd
    m_Tree.Nodes.Clear
    ID = ListID(m_Combo)
    If ID = 0 Then GoTo ExitProc
    
    ' Primero agrego todas las ramas
    For i = 1 To UBound(m_Branchs)
        AddNodo m_Branchs(i).Name, m_Branchs(i).ID
    Next i
    
    ' ahora las ordeno
    For i = 1 To UBound(m_Branchs)
        SetFather m_Branchs(i).ID, m_Branchs(i).Father
    Next i
    
ExitProc:
    LockWindowUpdate 0
End Function

Private Sub AddNodo(ByVal Value As String, ByVal ID As Long)
    m_Tree.Nodes.Add , , GetKey(ID), Value
End Sub

Private Sub SetFather(ByVal KeyHijo As Long, ByVal KeyFather As Long)
    Set m_Tree.Nodes(GetKey(KeyHijo)).Parent = m_Tree.Nodes(GetKey(KeyFather))
End Sub

Private Function GetIDfromTree() As Long
    GetIDfromTree = Mid(m_Tree.SelectedItem.Key, 2)
End Function

