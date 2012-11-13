VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cABMUtil"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cABMUtil
' 00-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cABMUtil"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function pCell(ByRef Row As cIABMGridRow, ByVal Key As Long) As cIABMGridCellValue
  On Error Resume Next
  Dim Cell    As cIABMGridCellValue
  For Each Cell In Row
    If Cell.Key = Key Then
      Set pCell = Cell
      Exit Function
    End If
  Next
End Function

Public Function pGetKeyFromCol(ByRef Columns As cIABMGridColumns, ByVal lCol As Long) As Long
  pGetKeyFromCol = Columns.Item(lCol).Key
End Function

Public Function pGetColFromKey(ByRef Columns As cIABMGridColumns, ByVal Key As Long) As Long
  Dim i As Long
  For i = 1 To Columns.Count
    If Columns(i).Key = Key Then
      pGetColFromKey = i
      Exit Function
    End If
  Next
End Function

Public Function pCol(ByRef Columns As cIABMGridColumns, ByVal Key As Long) As cIABMGridColumn
  On Error Resume Next
  Dim Col    As cIABMGridColumn
  For Each Col In Columns
    If Col.Key = Key Then
      Set pCol = Col
      Exit Function
    End If
  Next
End Function
' funciones friend
' funciones privadas
' construccion - destruccion
'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next






