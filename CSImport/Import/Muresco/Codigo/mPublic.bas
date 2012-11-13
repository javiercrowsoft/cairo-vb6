Attribute VB_Name = "mPublic"
Option Explicit

Private Enum csLogSeverity
  LogSevInformation = 1
  LogSevWarnning = 2
  LogSevError = 3
End Enum

Public Function GetDateWhereInformix(ByVal field As String, ByVal dDate As Date, ByVal operator As String) As String
  If Trim(operator) = ">=" Or Trim(operator) = ">" Then
    GetDateWhereInformix = "((day(" & field & ")" & operator & Day(dDate) & _
                           " and month(" & field & ")=" & Month(dDate) & _
                           " and year(" & field & ")=" & Year(dDate) & ")" & _
                           " or (month(" & field & ")>" & Month(dDate) & _
                           " and year(" & field & ")>=" & Year(dDate) & "))"
  
  ElseIf Trim(operator) = "<=" Or Trim(operator) = "<" Then
  
    GetDateWhereInformix = "((day(" & field & ")" & operator & Day(dDate) & _
                           " and month(" & field & ")=" & Month(dDate) & _
                           " and year(" & field & ")=" & Year(dDate) & ")" & _
                           " or (month(" & field & ")<" & Month(dDate) & _
                           " and year(" & field & ")<=" & Year(dDate) & "))"
  
  Else
  
    GetDateWhereInformix = "(day(" & field & ")" & operator & Day(dDate) & _
                           " and month(" & field & ")" & operator & Month(dDate) & _
                           " and year(" & field & ")" & operator & Year(dDate) & ")"
  End If
End Function

Sub MngError(ByVal ObjLog As Object, ByVal impp_id As Long, ByRef ErrObj As Object, _
             ByVal NameFunction As String, ByVal Module As String, _
             ByVal InfoAdd As String, Optional ByVal Title As String, _
             Optional ByVal Level As csErrorLevel = csErrorWarning, _
             Optional VarType As csErrorType = csErrorVba, Optional ByRef ConnectionObj As Object)
  
  CSKernelClient2.MngError ErrObj, NameFunction, Module, InfoAdd, Title, _
                           Level, VarType, ConnectionObj
  On Error Resume Next
  ObjLog.SaveLogToDb LastErrorDescription, LogSevError, impp_id, Module
  
End Sub

Sub MsgError(ByVal ObjLog As Object, ByVal impp_id As Long, ByVal msg As String, _
             ByVal Module As String, Optional ByVal Title As String = "@@@@@")
  
  CSKernelClient2.MsgWarning msg, Title
  
  On Error Resume Next
  ObjLog.SaveLogToDb msg, LogSevWarnning, impp_id, Module
End Sub

Sub MsgWarning(ByVal ObjLog As Object, ByVal impp_id As Long, ByVal msg As String, Optional ByVal Title As String = "@@@@@")
  
  CSKernelClient2.MsgWarning msg, Title
  
  On Error Resume Next
  ObjLog.SaveLogToDb msg, LogSevWarnning, impp_id, ""
End Sub
