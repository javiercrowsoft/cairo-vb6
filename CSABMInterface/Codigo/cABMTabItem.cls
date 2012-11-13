VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cABMTabItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMTabItem

'--------------------------------------------------------------------------------
' cABMTabItem
' 06-01-01

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
Private m_Index           As Integer
Private m_CtlIndex        As Integer
Private m_Name            As String
Private m_FatherTab       As String
Private m_KeyTab          As String
Private m_Left            As Long
Private m_Top             As Long
' eventos
' propiedades publicas
Public Property Get FatherTab() As String
  FatherTab = m_FatherTab
End Property

Public Property Let FatherTab(ByVal RHS As String)
  m_FatherTab = RHS
End Property

Public Property Get KeyTab() As String
  KeyTab = m_KeyTab
End Property

Public Property Let KeyTab(ByVal RHS As String)
  m_KeyTab = RHS
End Property

Public Property Get Left() As Long
  Left = m_Left
End Property

Public Property Let Left(ByVal RHS As Long)
  m_Left = RHS
End Property

Public Property Get Top() As Long
  Top = m_Top
End Property

Public Property Let Top(ByVal RHS As Long)
  m_Top = RHS
End Property

Friend Property Get CtlIndex() As Integer
  CtlIndex = m_CtlIndex
End Property

Friend Property Let CtlIndex(ByVal RHS As Integer)
  m_CtlIndex = RHS
End Property

Private Property Get cIABMTabItem_Index() As Integer
  cIABMTabItem_Index = m_Index
End Property

Private Property Let cIABMTabItem_Index(ByVal RHS As Integer)
  m_Index = RHS
End Property

Private Property Get cIABMTabItem_Name() As String
  cIABMTabItem_Name = m_Name
End Property

Private Property Let cIABMTabItem_Name(RHS As String)
  m_Name = RHS
End Property
' propiedades privadas
' funciones publicas
' funciones privadas
' construccion - destruccion

