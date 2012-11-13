VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cABMListItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMListItem

'--------------------------------------------------------------------------------
' cABMListItem
' 14-01-01

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
' eventos
' propiedades publicas
' propiedades privadas
Private m_ID As Long
Private m_Value As String
' funciones publicas
' funciones privadas
Private Property Let cIABMListItem_ID(ByVal rhs As Long)
    m_ID = rhs
End Property

Private Property Get cIABMListItem_ID() As Long
    cIABMListItem_ID = m_ID
End Property

Private Property Let cIABMListItem_Value(ByVal rhs As String)
    m_Value = rhs
End Property

Private Property Get cIABMListItem_Value() As String
    cIABMListItem_Value = m_Value
End Property
' construccion - destruccion

