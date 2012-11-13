VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCollection"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCollection
' 10-07-04

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
Public Sub CollClear(ByRef Coll As Collection)
  mCollection.CollClear Coll
End Sub
Public Function ExistsStandarTypeInColl(ByRef Coll As Object, ByVal Item As String) As Boolean
  ExistsStandarTypeInColl = mCollection.ExistsStandarTypeInColl(Coll, Item)
End Function
Public Function ExistsObjectInColl(ByRef Coll As Object, ByVal Item As String) As Boolean
  ExistsObjectInColl = mCollection.ExistsObjectInColl(Coll, Item)
End Function
Public Function GetKey(ByVal vVal As Variant) As Variant
  GetKey = mCollection.GetKey(vVal)
End Function
Public Function GetIdFromKey(ByVal sVal As String) As Long
  GetIdFromKey = mCollection.GetIdFromKey(sVal)
End Function
Public Function GetIndexFromKey(ByRef Coll As Collection, ByVal kItem As String) As Integer
  GetIndexFromKey = mCollection.GetIndexFromKey(Coll, kItem)
End Function
' funciones privadas
' construccion - destruccion


