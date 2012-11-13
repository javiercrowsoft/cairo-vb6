Attribute VB_Name = "mAux"
Option Explicit

Public Sub MngError(ByVal FunctionName As String, Optional ByVal sModule As String, Optional ByVal InfoAdd As String)
#If DEBUGMODE_ERROR_MSG = 1 Then
  MsgBox FunctionName & ": " & Err.Description
#Else
  Debug.Print FunctionName & ": " & Err.Description
#End If
End Sub

