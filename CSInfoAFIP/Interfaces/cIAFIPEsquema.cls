VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIAFIPEsquema"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Property Get LineCount() As Long
End Property

Public Property Get NombreArchivo() As String
End Property

Public Property Let NombreArchivo(ByVal rhs As String)
End Property

Public Sub Log(ByVal Module As String, ByVal msg As String, ByVal Severity As csInfoAFIPLogSeverity)
End Sub

Public Function AddLine(ByRef Campos As cIAFIPCampos) As Boolean
End Function
