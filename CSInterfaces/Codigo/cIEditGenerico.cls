VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIEditGeneric"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cIEditGeneric
' 19-01-01

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
Public Property Set ObjABM(ByRef o As cIABMGeneric)
End Property
Public Property Get ObjABM() As cIABMGeneric
End Property
Public Property Set ObjTree(ByRef o As Object)
End Property
Public Property Get Editing() As Boolean
End Property
Public Property Let BranchId(ByVal rhs As Long)
End Property
Public Property Get BranchId() As Long
End Property
Public Property Let TreeId(ByVal rhs As Long)
End Property
Public Property Get TreeId() As Long
End Property
' Properties privadas
' funciones publicas
Public Function Edit(ByRef ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
End Function
Public Function Delete(ByRef ID As Long) As Boolean
End Function
Public Function PrintObj(ByVal ID As Long) As Boolean
End Function
Public Function Search(ByRef ID As Long, ByRef Cancel As Boolean) As Boolean
End Function
Public Function Preview(ByVal ID As Long) As Boolean
End Function
Public Function ShowList() As Boolean
End Function
Public Function TabClick(ByVal Index As Integer) As Boolean
End Function
Public Function PropertyChange(ByVal Key As Integer) As Boolean
End Function
Public Function GridAdd(ByVal KeyProperty As Integer) As Boolean
End Function
Public Function GridRemove(ByVal KeyProperty As Integer) As Boolean
End Function
Public Function GridEdit(ByVal KeyProperty As Integer) As Boolean
End Function
' funciones privadas
' construccion - destruccion

