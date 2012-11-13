Attribute VB_Name = "mPublic"
Option Explicit
'--------------------------------------------------------------------------------
' mPublic
' 03-10-00

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
    Do While coll.Count > 0
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
Public Function GetKey(ByVal vVal As Variant) As String
    GetKey = "K" & vVal
End Function

Public Function GetIdFromKey(ByVal sVal As String) As Long
    GetIdFromKey = Mid(sVal, 2)
End Function

Public Sub SetFocusControl(ByRef Ctl As Control)
  On Error Resume Next
  Ctl.SetFocus
  DoEvents: DoEvents: DoEvents
End Sub

' funciones privadas
' construccion - destruccion
