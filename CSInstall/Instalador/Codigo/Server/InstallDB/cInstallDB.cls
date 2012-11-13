VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cInstallDB"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Function CreateDataBases(ByVal dbFolder As String, _
                                ByVal BackupFolder As String, _
                                ByVal AppFolder As String) As Boolean
  On Error Resume Next
  
  fMain.dbFolder = dbFolder
  fMain.BackupFolder = BackupFolder
  fMain.AppFolder = AppFolder
  fMain.Show vbModal
  
  CreateDataBases = fMain.Ok
End Function
