VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cWebReportHiperLink"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'--------------------------------------------------------------------------------
' cWebReportHiperLink
' -01-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "CSWebReport.cWebReportHiperLink"
' estructuras
' variables privadas
Private m_Name                          As String
Private m_Url                           As String
Private m_IdFieldName                   As String
Private m_Index                         As Long
' eventos
' propiedades publicas
Public Property Get Name() As String
   Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
   m_Name = rhs
End Property

Public Property Get Url() As String
   Url = m_Url
End Property

Public Property Let Url(ByVal rhs As String)
   m_Url = rhs
End Property

Public Property Get IdFieldName() As String
   IdFieldName = m_IdFieldName
End Property

Public Property Let IdFieldName(ByVal rhs As String)
   m_IdFieldName = rhs
End Property

Public Property Get Index() As Long
   Index = m_Index
End Property

Public Property Let Index(ByVal rhs As Long)
   m_Index = rhs
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion
