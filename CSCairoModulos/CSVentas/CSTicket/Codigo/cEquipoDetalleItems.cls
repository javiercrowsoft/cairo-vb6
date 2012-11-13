VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cEquipoDetalleItems"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cEquipoDetalleItems
' cEquipoDetalleItem
' 06-10-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cEquipoDetalleItems"
' estructuras
' variables privadas
Private m_Coll As Collection
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Function Add(ByVal c As cEquipoDetalleItem, Optional key As Variant) As cEquipoDetalleItem
    On Error GoTo ControlError

    If c Is Nothing Then Set c = New cEquipoDetalleItem

    If IsMissing(key) Then
        m_Coll.Add c
    Else
        m_Coll.Add c, GetKey(key)
    End If

    Set Add = c
    Exit Function
ControlError:
    Set Add = Nothing
End Function

Public Sub Clear()
    CollClear m_Coll
End Sub

Public Sub Remove(ByVal kItem As Variant)
    On Error GoTo ControlError
    If VarType(kItem) = vbString Then
      m_Coll.Remove GetIndexFromKey(m_Coll, kItem)
    Else
      m_Coll.Remove kItem
    End If
    Exit Sub
ControlError:
End Sub

Public Function Count() As Long
    On Error GoTo ControlError
    Count = m_Coll.Count
    Exit Function
ControlError:
    Count = 0
End Function

Public Function Item(ByVal kItem As Variant) As cEquipoDetalleItem
Attribute Item.VB_UserMemId = 0
    On Error GoTo ControlError
    Set Item = m_Coll(kItem)
    Exit Function
ControlError:
End Function

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
    Set NewEnum = m_Coll.[_NewEnum]
End Function

' funciones privadas

' construccion - destruccion
Private Sub Class_Initialize()
    Set m_Coll = New Collection
End Sub

Private Sub Class_Terminate()
    CollClear m_Coll
    Set m_Coll = Nothing
End Sub
