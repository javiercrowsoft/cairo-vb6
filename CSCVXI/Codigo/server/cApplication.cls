VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cApplication"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private m_activexobject As String
Private m_nombre        As String

Public Property Let ActivexObject(ByVal rhs As String)
  m_activexobject = rhs
End Property

Public Property Get ActivexObject() As String
  ActivexObject = m_activexobject
End Property

Public Property Let Nombre(ByVal rhs As String)
  m_nombre = rhs
End Property

Public Property Get Nombre() As String
  Nombre = m_nombre
End Property

