VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIABMDocForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cIABMDocForm
' 16-05-04

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
Public Property Get ABMObject() As Object
End Property
Public Property Set ABMObject(ByRef rhs As Object)
End Property
Public Property Let Loading(ByVal rhs As Boolean)
End Property
Public Property Get CancelUnload() As Boolean
End Property
Public Property Let CancelUnload(ByVal rhs As Boolean)
End Property
Public Property Get WasChanged() As Boolean
End Property
Public Property Let WasChanged(ByVal rhs As Boolean)
End Property

' propiedades privadas
' funciones publicas
Public Sub doPropertyChange()
End Sub
Public Sub InitMembers()
End Sub
Public Function CtrlKeySave() As Boolean
End Function
Public Function CtrlKeyNew() As Boolean
End Function
Public Function CtrlKeyCopy() As Boolean
End Function
Public Function CtrlKeyRefresh() As Boolean
End Function
Public Function CtrlKeyClose() As Boolean
End Function
Public Sub SetToolbar(ByRef Tbl As Object)
End Sub
Public Sub UnLoadToolbar()
End Sub
Public Sub SetFocusFirstControl()
End Sub
' funciones privadas
'----------------
' construccion - destruccion

