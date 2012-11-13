VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCodeParameter"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cCodeParameter
' 03-03-04

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
Private m_Code    As String
Private m_CodeC   As String
Private m_oCode   As cCode
' eventos
' propiedades publicas
Public Property Get Name() As String
 Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
  m_Name = rhs
End Property

Public Property Get Code() As String
  Code = m_Code
End Property

Public Property Let Code(ByVal rhs As String)
   m_Code = rhs
End Property

Public Property Get CodeC() As String
  CodeC = m_CodeC
End Property

Public Property Let CodeC(ByVal rhs As String)
  m_CodeC = rhs
End Property

Public Property Get oCode() As cCode
  Set oCode = m_oCode
End Property

Public Property Set oCodeC(ByVal rhs As cCode)
  Set m_oCode = rhs
End Property
' propiedades privadas
' propiedades Friend
' funciones publicas
' funciones privadas
' funciones friend
' construccion - destruccion
Private Sub Class_Initialize()
  Set m_oCode = New cCode
End Sub

Private Sub Class_Terminate()
  Set m_oCode = Nothing
End Sub
