VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cForms"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public Property Get Item(ByVal Index As Integer) As Object
  Set Item = List.Item(Index)
End Property

Public Function Add(ByVal oForm As Form) As Integer
  Add = List.Add(oForm)
End Function

Public Sub Remove(ByVal Index As Integer)
  If Index > Count - 1 Or Index < 0 Then Exit Sub

  List.RemoveAt (Index)
End Sub

