VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIABMGeneric"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cIABMGeneric
' 03-01-01

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
Public Property Let InModalWindow(ByVal rhs As Boolean)
End Property
Public Property Get InModalWindow() As Boolean
End Property
Public Property Let IsDocument(ByVal rhs As Boolean)
End Property
Public Property Let IsItems(ByVal rhs As Boolean)
End Property
Public Property Let IsFooter(ByVal rhs As Boolean)
End Property
Public Property Get Properties() As cIABMProperties
End Property
Public Property Get Tabs() As cIABMTabs
End Property
Public Property Get ObjForm() As Object
End Property
Public Property Set ObjForm(ByVal rhs As Object)
End Property
Public Property Let HideTitle(ByVal rhs As Boolean)
End Property
Public Property Let Title2(ByVal rhs As String)
End Property
Public Property Let Left(ByVal rhs As Single)
End Property
Public Property Get Left() As Single
End Property
Public Property Let Top(ByVal rhs As Single)
End Property
Public Property Get Top() As Single
End Property
Public Property Get ShapeMain() As Object
End Property
Public Property Get PicMain() As Object
End Property
Public Sub ShowValue(ByRef iProp As cIABMProperty)
End Sub

' Properties privadas
' funciones publicas
Public Function Show(ByRef Obj As cIABMClient) As Boolean
End Function
Public Function Terminate() As Boolean
End Function
Public Sub RefreshControls(Optional ByVal NoGrids = True)
End Sub

' funciones privadas
' construccion - destruccion
