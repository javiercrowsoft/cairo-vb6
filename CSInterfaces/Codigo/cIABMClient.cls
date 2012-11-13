VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIABMClient"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cIABMClient
' 15-01-01

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
Public Property Get Title() As String
End Property
Public Property Get Aplication() As String
End Property
Public Property Get CanNew() As Boolean
End Property
Public Property Get CanCopy() As Boolean
End Property
Public Property Get CanAddDocDigital() As Boolean
End Property
' Properties privadas
' funciones publicas
Public Sub DiscardChanges()
End Sub
Public Function ListAdHock(ByRef List As cIABMList) As Boolean
End Function
Public Sub Load()
End Sub
Public Function Save() As Boolean
End Function
Public Function Validate() As Boolean
End Function
Public Function Terminate() As Boolean
End Function
Public Function PropertyChange(ByVal Key As Integer) As Boolean
End Function
Public Function Copy() As Boolean
End Function
Public Function EditNew() As Boolean
End Function
Public Function ShowDocDigital() As Boolean
End Function
Public Function MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
End Function
' funciones privadas
' construccion - destruccion
