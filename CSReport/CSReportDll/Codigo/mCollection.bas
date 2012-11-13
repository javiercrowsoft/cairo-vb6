Attribute VB_Name = "mCollection"
Option Explicit
'--------------------------------------------------------------------------------
' mCollection
' 05-01-00

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
' propiedades privadas
' funciones publicas
Public Sub CollClear(ByRef coll As Collection)
  If coll Is Nothing Then Exit Sub
  Do While coll.Count() > 0
    coll.Remove (1)
  Loop
End Sub

Public Function ExistsStandarTypeInColl(ByRef coll As Object, ByVal Item As String) As Boolean
  Dim v As Variant
  On Error Resume Next
  Err.Clear
  v = coll(Item)
  ExistsStandarTypeInColl = Err.Number = 0
End Function

Public Function ExistsObjectInColl(ByRef coll As Object, ByVal Item As String) As Boolean
  Dim v As Variant
  On Error Resume Next
  Err.Clear
  v = coll(Item)
  ExistsObjectInColl = Err.Number = 0
End Function

Public Function GetKey(ByVal vVal As Variant) As String
  If IsNumeric(vVal) Then
    GetKey = "K" & vVal
  Else
    GetKey = vVal
  End If
End Function
Public Function GetIdFromKey(ByVal sVal As String) As Long
  GetIdFromKey = CLng(Mid(sVal, 2))
End Function
' funciones privadas
' construccion - destruccion

