VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cISecurity"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cISecurity
' 10-06-00

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
' propiedades publicas
Public Property Get Success() As Boolean
End Property
Public Property Get LastError() As String
End Property
Public Property Get LastNumberError() As Long
End Property
' propiedades privadas
' funciones publicas
Public Function LogginOn(ByRef Config As cIConfig) As Boolean
End Function
Public Function LogginOff(ByRef Config As cIConfig) As Boolean
End Function
Public Function UpdateUser(ByVal Id As Long) As Boolean
End Function
Public Function UpdateRol(ByVal Id As Long) As Boolean
End Function
Public Function GetTable() As Boolean
End Function
Public Function GetActivity(ByRef Config As cIConfig) As Boolean
End Function
' funciones privadas

