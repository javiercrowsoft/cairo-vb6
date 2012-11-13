VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIMenuHost"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cIMenuHost
' 15-09-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cIMenuHost"
' estructuras
' variables privadas
' eventos
' propiedades publicas
Public Property Get Server() As cMenu
End Property
' propiedades privadas
' funciones publicas
Public Sub MenuABMClick(ByVal ObjEdit As String, ByRef Obj As Object, ByVal NombreABM As String, ByVal Botones As String, ByVal Tabla As Long)
End Sub
Public Sub MenuListDocClick(ByVal ObjAbm As String, ByVal ObjEdit As String, ByVal ObjListABM As String, ByVal ObjList As String, _
                            ByRef Obj As Object, ByVal NombreABM As String, ByVal Botones As String)
End Sub
Public Sub MenuWizardClick(ByVal ClientName As String)
End Sub

Public Function AddIcon(ByRef iPicIcon As IPictureDisp) As Long
End Function

' funciones friend
' funciones privadas
' construccion - destruccion

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


