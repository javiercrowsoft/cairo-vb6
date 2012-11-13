Attribute VB_Name = "mCollection"
Attribute VB_Ext_KEY = "RVB_UniqueId" ,"3B3E646203C8"
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
  Do While coll.count > 0
    coll.Remove 1
  Loop
End Sub
Public Function ExistsStandarTypeInColl(ByRef coll As Object, ByVal Item As String) As Boolean
  Dim v As Variant
  On Error Resume Next
  Err = 0
  v = coll(Item)
  ExistsStandarTypeInColl = Err = 0
End Function
Public Function ExistsObjectInColl(ByRef coll As Object, ByVal Item As String) As Boolean
  Dim v As Variant
  On Error Resume Next
  Err = 0
  Set v = coll(Item)
  ExistsObjectInColl = Err = 0
End Function
Public Function GetKey(ByVal vVal As Variant) As Variant
  If IsNumeric(vVal) Then
    GetKey = "K" & vVal
  Else
    GetKey = vVal
  End If
End Function
Public Function GetIdFromKey(ByVal sVal As String) As Long
  GetIdFromKey = Mid(sVal, 2)
End Function
Public Function GetIndexFromKey(ByRef m_Coll As Collection, ByVal kItem As String) As Integer
  Dim i As Integer
  For i = 1 To m_Coll.count
  If m_Coll(kItem) Is m_Coll(i) Then
    GetIndexFromKey = i
    Exit Function
  End If
  Next
End Function
' funciones privadas
' construccion - destruccion

