VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCodeParameters"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cCodeParameters
' 03-03-04

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' Clase base
' constantes
' estructuras
' variables privadas
Private m_Coll As Collection
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Add() As cCodeParameter
  On Error GoTo ControlError
  Dim c As cCodeParameter

  Set c = New cCodeParameter

  m_Coll.Add c

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
  m_Coll.Remove kItem
  Exit Sub
ControlError:
End Sub

Public Function Count() As Long
  On Error GoTo ControlError
  Count = m_Coll.Count()
  Exit Function
ControlError:
  Count = 0
End Function

Public Function Item(ByVal kItem As Variant) As cCodeParameter
  On Error GoTo ControlError
  Set Item = m_Coll.Item(kItem)
  Exit Function
ControlError:
End Function

' funciones friend
' funciones privadas
Private Sub Class_Initialize()
  Set m_Coll = New Collection
End Sub

Public Function NewEnum() As IUnknown
  Set NewEnum = m_Coll.[_NewEnum]
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  CollClear m_Coll
  Set m_Coll = Nothing
End Sub
