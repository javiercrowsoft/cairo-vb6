VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTree"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cTreeAux
' 25-03-00

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
Private m_Id            As Long
Private m_Branchs       As cBranchs
Private m_Root          As Long
Private m_Name          As String
' Properties publicas
Public Property Get Id() As Long
    Id = m_Id
End Property
Public Property Let Id(ByVal rhs As Long)
    m_Id = rhs
End Property
Public Property Get Branchs() As cBranchs
    Set Branchs = m_Branchs
End Property
Public Property Get Root() As Long
    Root = m_Root
End Property
Public Property Let Root(ByVal rhs As Long)
    m_Root = rhs
End Property
Public Property Get Name() As String
    Name = m_Name
End Property
Public Property Let Name(ByVal rhs As String)
    m_Name = rhs
End Property
' Properties privadas
' funciones publicas
Public Function Rename(ByVal Id As Long)

End Function
Public Function Load() As Boolean
    Load = m_Branchs.Load(m_Id)
End Function
Public Function Reload() As Boolean
    m_Branchs.IsLoaded = False
    Reload = m_Branchs.Load(m_Id)
End Function

Public Function Search(ByVal Id As Long) As Long
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  'sqlstmt = "select ram_id from hoja where arb_id = " & m_Id
  'sqlstmt = sqlstmt & " and id = " & Id
  
  sqlstmt = "sp_ArbolABMBuscar " & m_Id & "," & Id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then
    Search = m_Root
  Else
    Search = gDB.ValField(rs.Fields, 0)
  End If
End Function

Public Function SortTree() As Boolean
  Dim sqlstmt As String
  
  sqlstmt = "sp_ArbSortRamas " & m_Id
  
  SortTree = gDB.Execute(sqlstmt)
End Function

' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
    Set m_Branchs = New cBranchs
End Sub

Private Sub Class_Terminate()
    Set m_Branchs = Nothing
End Sub
