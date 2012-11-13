Attribute VB_Name = "mError"
Option Explicit

Public gLastError         As Long
Public gLastErrorDescrip  As String

#If Not PREPROC_EXE Then
Public Sub MngError(ByRef Err As Object, ByVal sFunction As String, ByVal sModule As String, ByVal info As String)
  If Err.Number = 0 Then Exit Sub
  gLastError = Err.Number
  MsgBox "Function: " + sFunction + vbCrLf + "Modulo: " + sModule + vbCrLf + vbCrLf + pGetErr(Err.Description) + vbCrLf + info, vbCritical
End Sub

Private Function pGetErr(ByVal Descript As String) As String
  Descript = Replace(Descript, "[Microsoft]", "")
  Descript = Replace(Descript, "[ODBC SQL Server Driver]", "")
  Descript = Replace(Descript, "[Shared Memory]", "")
  Descript = Replace(Descript, "[DBNETLIB]", "")
  
  pGetErr = Descript
End Function
#End If

