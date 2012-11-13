VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIEditGenericListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cIEditGenericListDoc
' 25-03-02

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
Public Property Set ObjABM(ByRef o As cIABMGenericListDoc)
End Property
Public Property Set ObjList(ByRef o As Object)
End Property
' Properties privadas
' funciones publicas
Public Function ShowParams(ByVal us_id As Long) As Boolean
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
