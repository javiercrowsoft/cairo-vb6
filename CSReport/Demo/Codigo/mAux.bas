Attribute VB_Name = "mAux"
Option Explicit

Public Const c_APP_Name = "CSReportDemo"

Public fReportes As fMain

Public Sub MngError(ByRef Err, _
                    ByVal funtionName As String, _
                    ByVal moduleName As String, _
                    ByVal infoAdd As String)
  MsgBox Err.Description
End Sub

Public Sub Main()
  CSKernelClient2.AppName = c_APP_Name
  fMain.Show
End Sub
