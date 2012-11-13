VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPrestacion"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cPrestacion
' 12-07-00

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
Private m_Name    As String
Private m_Id        As Long
Private m_Group     As String

' Properties publicas
Public Property Get Name() As String
    Name = m_Name
End Property
Public Property Let Name(ByVal rhs As String)
    m_Name = rhs
End Property
Public Property Get Id() As Long
    Id = m_Id
End Property
Public Property Let Id(ByVal rhs As Long)
    m_Id = rhs
End Property
Public Property Get Group() As String
    Group = m_Group
End Property
Public Property Let Group(ByVal rhs As String)
    m_Group = rhs
End Property
' Properties privadas
' funciones publicas
' funciones privadas
' construccion - destruccion

