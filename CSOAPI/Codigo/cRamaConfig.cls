VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cBranchConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cBranchConfig
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
Private m_Aspect           As String
Private m_Value             As String
' Properties publicas
Public Property Get Aspect() As String
    Aspect = m_Aspect
End Property
Public Property Let Aspect(ByVal rhs As String)
    m_Aspect = rhs
End Property
Public Property Get Value() As String
    Value = m_Value
End Property
Public Property Let Value(ByVal rhs As String)
    m_Value = rhs
End Property
' Properties privadas
' funciones publicas
' funciones privadas
' construccion - destruccion

