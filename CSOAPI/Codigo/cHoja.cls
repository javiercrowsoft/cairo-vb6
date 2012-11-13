VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cLeave"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cLeave
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
Private m_ID            As Long
Private m_ClientId      As Long
Private m_Columns       As cLeaveColumns
Private m_Branch        As Long
Private m_Name          As String
' Properties publicas
Public Property Get Id() As Long
    Id = m_ID
End Property
Public Property Let Id(ByVal rhs As Long)
    m_ID = rhs
End Property
Public Property Get Columns() As cLeaveColumns
    Set Columns = m_Columns
End Property
Public Property Get Branch() As Long
    Branch = m_Branch
End Property
Public Property Get Name() As String
    Name = m_Name
End Property
Public Property Let Name(ByVal rhs As String)
    m_Name = rhs
End Property
Public Property Get ClientId() As String
    ClientId = m_ClientId
End Property
Public Property Let ClientId(ByVal rhs As String)
    m_ClientId = rhs
End Property
' Properties privadas
' funciones publicas
Public Function Rename(ByVal Id As Long)

End Function
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
    Set m_Columns = New cLeaveColumns
End Sub
Private Sub Class_Terminate()
    Set m_Columns = Nothing
End Sub
