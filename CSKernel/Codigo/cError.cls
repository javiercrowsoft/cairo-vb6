VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cError"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cError
' 04-01-00

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
Public Property Get LastErrorNumber() As Long
  LastErrorNumber = gLastErrorNumber
End Property

Public Property Get LastErrorDescription() As String
  LastErrorDescription = gLastErrDescription
End Property

Public Property Get LastErrorFunction() As String
  LastErrorFunction = gLastErrFunction
End Property

Public Property Get LastErrorModule() As String
  LastErrorModule = gLastErrModule
End Property

Public Property Get LastErrorInfoAdd() As String
  LastErrorInfoAdd = gLastErrInfoAdd
End Property

Public Property Get LastErrorLine() As Long
  LastErrorLine = gLastErrLine
End Property

' propiedades privadas
' Funciones publicas
Public Sub MngError(ByRef ErrObj As Object, _
                    ByVal NameFunction As String, _
                    ByVal Module As String, _
                    ByVal InfoAdd As String, _
                    Optional ByVal Title As String = "", _
                    Optional ByVal Level As csErrorLevel = csErrorWarning, _
                    Optional ByVal VarType As csErrorType = csErrorVba, _
                    Optional ByVal ConnectionObj As Object)
                    
    MngError_ ErrObj, NameFunction, Module, InfoAdd, Title, Level, VarType, ConnectionObj
End Sub

Public Sub ErrorClear()
  gLastErrDescription = ""
  gLastErrorNumber = 0
  gLastErrFunction = ""
  gLastErrModule = ""
  gLastErrInfoAdd = ""
  gLastErrLine = 0
End Sub
' Funciones privadas
