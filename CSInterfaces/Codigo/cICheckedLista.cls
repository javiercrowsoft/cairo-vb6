VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cICheckedList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cICheckedList
' 27-01-01

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
Public Property Get HaveToShowTag() As Boolean

End Property
' propiedades privadas
' funciones publicas
Public Function Add(ByVal o As cICheckedListItem, Optional Key As Variant) As cICheckedListItem

End Function

Public Sub Remove(ByVal kItem As Variant)

End Sub

Public Function Count() As Long

End Function

Public Function Item(ByVal kItem As Variant) As cICheckedListItem
Attribute Item.VB_UserMemId = 0

End Function

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4

End Function

Public Sub Clear()

End Sub
' funciones privadas
' construccion - destruccion



