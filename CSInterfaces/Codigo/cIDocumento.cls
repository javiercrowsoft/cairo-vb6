VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIDocumento"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cIDocumento
' 23-02-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cIDocumento"
' estructuras
' variables privadas
' eventos
' propiedades publicas
Public Property Get DocTId() As Long
End Property
Public Property Get DocId() As Long
End Property
Public Property Get Id() As Long
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function LoadForPrint(ByVal Id As Long) As Boolean
End Function
' funciones friend
' funciones privadas
' construccion - destruccion
