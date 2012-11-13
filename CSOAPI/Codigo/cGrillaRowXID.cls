VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGridRowXID"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cGridRowXID
' 16-02-00

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
Private m_Id As Long
Private m_Row As Integer
' Properties publicas
Public Property Get Id() As Long
    Id = m_Id
End Property
Public Property Let Id(ByVal rhs As Long)
    m_Id = rhs
End Property
Public Property Get Row() As Integer
    Row = m_Row
End Property
Public Property Let Row(ByVal rhs As Integer)
    m_Row = rhs
End Property
' Properties privadas
' funciones publicas
' funciones privadas
' construccion - destruccion

