Attribute VB_Name = "mPublic2"
Option Explicit

Public Sub MsgInfoEx(ByVal Info As String)
  fInfo.Info = Info
  fInfo.Show vbModal
End Sub
