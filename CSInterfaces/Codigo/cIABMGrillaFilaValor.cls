VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIABMGridCellValue"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cIABMGridCellValue
' 01-02-01

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
' Properties publicas
Public Property Let Value(ByRef rhs As String)
End Property
Public Property Get Value() As String
End Property
Public Property Let ID(ByRef rhs As Long)
End Property
Public Property Get ID() As Long
End Property
Public Property Let Key(ByVal rhs As Integer)
End Property
Public Property Get Key() As Integer
End Property
Public Property Get Format() As cIABMGridCellFormat
End Property
Public Property Set Format(ByRef c As cIABMGridCellFormat)
End Property
' Properties privadas
' funciones publicas
' funciones privadas
' construccion - destruccion


