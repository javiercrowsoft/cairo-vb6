VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIABMClientGrid"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cIABMClient
' 15-01-01

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
' Properties privadas
' funciones publicas
Public Function ListAdHock(ByVal Key As Integer, ByRef Row As cIABMGridRow, ByVal ColIndex As Long, ByRef List As cIABMList) As Boolean
End Function
Public Function ValidateRow(ByVal Key As Integer, ByRef Row As cIABMGridRow, ByVal RowIndex As Long) As Boolean
End Function
Public Function IsEmptyRow(ByVal Key As Integer, ByRef Row As cIABMGridRow, ByVal RowIndex As Long) As Boolean
End Function
Public Sub NewRow(ByVal Key As Integer, ByVal Rows As Integer)
End Sub
Public Function ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
End Function
Public Function ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
End Function
Public Function ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
End Function
Public Sub ColumnCancelEdit(ByVal Key As Integer)
End Sub
Public Function ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
End Function
Public Sub ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)
End Sub
Public Sub DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)
End Sub
Public Function DeleteRow(ByVal Key As Integer, ByRef Row As cIABMGridRow, ByVal lRow As Long) As Boolean
End Function

' funciones privadas
' construccion - destruccion

