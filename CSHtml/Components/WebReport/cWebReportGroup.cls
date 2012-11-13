VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cWebReportGroup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cWebReportGroup
' 23-04-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "CSWebReport.cWebReportGroup"
' estructuras
' variables privadas
Private m_FieldName                     As String
Private m_Index                         As Long
Private m_Default                       As Integer
' eventos
' propiedades publicas
Public Property Get FieldName() As String
   FieldName = m_FieldName
End Property

Public Property Let FieldName(ByVal rhs As String)
   m_FieldName = rhs
End Property

Public Property Get Index() As Long
   Index = m_Index
End Property

Public Property Let Index(ByVal rhs As Long)
   m_Index = rhs
End Property

Public Property Get Default() As Integer
  Default = m_Default
End Property

Public Property Let Default(ByVal rhs As Integer)
  m_Default = rhs
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion
