VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cBranch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cBranch
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
Private Const C_Module = "cBranch"
' estructuras
' Seudo - Variables
Private c_ErrorSave     As String

' variables privadas
Private m_Id            As Long
Private m_TreeId        As Long
Private m_Leaves        As cLeaves
Private m_Father        As Long
Private m_Name          As String
Private m_Columns       As cLeaveColumns
'Private m_BranchConfigs As cBranchConfigs
Private m_IdOfCopy      As Long

Private m_Childs         As Collection ' es una Collection de Childs, solo contiene el primer nivel
Private m_ChildsLoaded   As Boolean

' Properties publicas
Public Property Get Id() As Long
    Id = m_Id
End Property
Public Property Let Id(ByVal rhs As Long)
    m_Id = rhs
End Property
Public Property Get TreeId() As Long
    Id = m_TreeId
End Property
Public Property Let TreeId(ByVal rhs As Long)
    m_TreeId = rhs
End Property
Public Property Get Leaves() As cLeaves
    Set Leaves = m_Leaves
End Property
Public Property Get Father() As Long
    Father = m_Father
End Property
Public Property Let Father(ByVal rhs As Long)
    m_Father = rhs
End Property
Public Property Get Name() As String
    Name = m_Name
End Property
Public Property Let Name(ByVal rhs As String)
    m_Name = rhs
End Property
Public Property Get Columns() As cLeaveColumns
    Set Columns = m_Columns
End Property
Public Property Get IdOfCopy() As Long
    IdOfCopy = m_IdOfCopy
End Property
Friend Property Let IdOfCopy(ByVal rhs As Long)
    m_IdOfCopy = rhs
End Property
Public Property Get Childs() As Collection
    Set Childs = m_Childs
End Property
Public Property Get ChildsLoaded() As Boolean
    ChildsLoaded = m_ChildsLoaded
End Property
Public Property Let ChildsLoaded(ByVal rhs As Boolean)
    m_ChildsLoaded = rhs
End Property

' Properties privadas
' funciones publicas
Public Function Rename(ByVal Name As String) As Boolean
  Dim sqlstmt As String
  
  ' si es la raiz tengo que modificar el Tree
  If m_Father = csNO_ID Then
      sqlstmt = "update " + csTArbol + " set " + cscArbNombre + " = '" + Name + "' where " + cscArbId + " = " + Trim(m_TreeId) + vbCrLf
  End If
  
  sqlstmt = sqlstmt + "update " + csTRama + " set " + cscRamNombre + " = '" + Name + "' where " + cscRamId + " = " + Trim(m_Id)
  
  If Not gDB.Execute(sqlstmt, "Rename", C_Module, c_ErrorSave) Then Exit Function
  
  m_Name = Name
  
  Rename = True
End Function
'Public Function LoadConfig(Optional ByVal Reload As Boolean = False) As Boolean
'    Dim sqlstmt As String
'    Dim rsConfig As cRegister
'
'    If Reload Then m_BranchConfigs.IsLoaded = False
'
'    LoadConfig = m_BranchConfigs.Load(m_ID)
'End Function
Public Function LoadColumns() As Boolean
    Dim sqlstmt As String
    Dim rsLeaves As cRegister
    Dim fldLeaves As cField
    Dim c       As cLeaveColumn
    
    m_Columns.Clear
   
    sqlstmt = "SP_ArbGetHojas " + Trim(Id) + ",1"
    
    If Not gDB.OpenRs(sqlstmt, rsLeaves, , , , "LoadColumns", C_Module, c_ErrorSave) Then Exit Function
    
    For Each fldLeaves In rsLeaves.Fields
        Set c = m_Columns.Add(c, fldLeaves.Name)
        c.Name = fldLeaves.Name
        c.VarType = gDB.GetFieldType(fldLeaves)
        
        Set c = Nothing
    Next
            
    LoadColumns = True
End Function

Public Function UpBranch() As Boolean
    Dim sqlstmt As String
    
    sqlstmt = "SP_ArbSubirRama " & m_Id
    
    If Not gDB.Execute(sqlstmt, "UpBranch", C_Module, c_ErrorSave) Then Exit Function
    
    UpBranch = True
End Function

Public Function DownBranch() As Boolean
    Dim sqlstmt As String
    
    sqlstmt = "SP_ArbBajarRama " & m_Id
    
    If Not gDB.Execute(sqlstmt, "DownBranch", C_Module, c_ErrorSave) Then Exit Function
    
    DownBranch = True
End Function

Friend Sub AddChild(ByVal idx As Long)
    m_Childs.Add idx
End Sub
Friend Sub RemoveChild(ByVal idx As Long)
    m_Childs.Remove idx
End Sub
Friend Function NewEnum() As IUnknown
    Set NewEnum = m_Childs.[_NewEnum]
End Function
Friend Sub Clear()
    CollClear m_Childs
    m_ChildsLoaded = False
End Sub

' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  Set m_Leaves = New cLeaves
  Set m_Columns = New cLeaveColumns
  Set m_Childs = New Collection
  m_Leaves.Branch = Me
  
  c_ErrorSave = LNGGetText(3434, vbNullString)  'Error al editar la Rama
  
End Sub

Private Sub Class_Terminate()
    Set m_Columns = Nothing
    m_Leaves.Branch = Nothing
    Set m_Leaves = Nothing
    CollClear m_Childs
    Set m_Childs = Nothing
End Sub

