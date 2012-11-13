VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cInitKernelClient"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cInitKernelClient
' 10-06-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' Funciones

'--------------------------------------------------------------------------------

' constantes
' estructuras
' variables privadas
' propiedades publicas
Public Property Let AppName(ByVal rhs As String)
  gAppName = rhs
End Property

Public Property Let AppPath(ByVal rhs As String)
  gAppPath = rhs
End Property

Public Property Get AppPath() As String
  AppPath = gAppPath
End Property

Public Property Let DefaultHelpFile(ByVal rhs As String)
  gDefaultHelpFile = rhs
End Property
' propiedades privadas
' Funciones publicas
' Funciones privadas
' construccion - destruccion

