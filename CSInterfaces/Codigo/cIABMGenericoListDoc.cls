VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIABMGenericListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cIABMGenericListDoc
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
Public Property Get Properties() As cIABMProperties
End Property
Public Property Get Tabs() As cIABMTabs
End Property
' Properties privadas
' funciones publicas
Public Function Show(ByRef Obj As cIABMListDocClient, ByRef ObjABM As Object) As Boolean
End Function
Public Function Terminate() As Boolean
End Function
Public Property Let Left(ByVal rhs As Single)
End Property
Public Property Get Left() As Single
End Property
Public Property Let Top(ByVal rhs As Single)
End Property
Public Property Get Top() As Single
End Property
Public Sub RefreshControls()
End Sub
Public Function Refresh() As String
End Function
' funciones privadas
' construccion - destruccion

