Attribute VB_Name = "mMain"
Option Explicit

Private Const SEM_NOGPFAULTERRORBOX = &H2
Private Declare Function SetErrorMode Lib "kernel32" (ByVal wMode As Long) As Long

Public Const APP_NAME = "CSChatClient"

Private Const C_Module = "mMain"

Public Sub Main()
  On Error Resume Next

  If pOnlyRegister() Then Exit Sub

  SetIsSoporte

  CSKernelClient2.AppName = APP_NAME
  CSKernelClient2.LoadForm fMain, fMain.Name
  
  If gIsSoporte Then fMain.Caption = "CrowSoft Soporte"
  
  fMain.Show
  Set fMain.Icon = fSpalsh.Icon
  
  If LoginFromCommandLineAux() Then
    fMain.Connect
  End If
End Sub

Public Sub CloseApp()
  On Error Resume Next
  
  SetErrorMode SEM_NOGPFAULTERRORBOX
  
  Set CSKernelClient2.OForms = Forms
  CSKernelClient2.FreeResource
  
  CloseChat
  CloseSession
  
  Dim f As Form
  
  Set fMain = Nothing
  Set fChat = Nothing
  
  For Each f In Forms
    If TypeOf f Is fChat Then
      Unload f
    End If
  Next
  
  Err.Clear
  End
End Sub

Public Function GetExeVersion() As String
  GetExeVersion = App.Major & "." & Format(App.Minor, "00") & "." & Format(App.Revision, "00")
End Function

Private Function pOnlyRegister() As Boolean
  pOnlyRegister = LCase$(Command$) = "register"
End Function
