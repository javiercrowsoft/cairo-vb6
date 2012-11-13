Attribute VB_Name = "mMain"
Option Explicit

                 '1234567890123456789012345678901234567890123456789
Public Const c_filler = "                                                 "

Public gCancel As Boolean

Public Sub MngError(ByVal FunctionName As String, ByVal error As Object)
  Debug.Print error.Description
End Sub
