VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportFormulaType"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportFormulaType
' 11-11-01

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
Private m_Name As String
Private m_NameUser As String
Private m_Id As Long
Private m_Decrip As String
Private m_HelpContextId As Long

' eventos
' propiedades publicas

' propiedades privadas
' propiedades Friend
Public Property Get Name() As String
  Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
   m_Name = rhs
End Property

Public Property Get NameUser() As String
  NameUser = m_NameUser
End Property

Public Property Let NameUser(ByVal rhs As String)
   m_NameUser = rhs
End Property

Public Property Get Id() As Long
   Id = m_Id
End Property

Public Property Let Id(ByVal rhs As Long)
   m_Id = rhs
End Property

Public Property Get Decrip() As String
  Decrip = m_Decrip
End Property

Public Property Let Decrip(ByVal rhs As String)
   m_Decrip = rhs
End Property

Public Property Get HelpContextId() As Long
  HelpContextId = m_HelpContextId
End Property

Public Property Let HelpContextId(ByVal rhs As Long)
   m_HelpContextId = rhs
End Property

' funciones publicas
' funciones privadas
' funciones friend
' construccion - destruccion
