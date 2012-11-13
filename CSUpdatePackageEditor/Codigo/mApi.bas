Attribute VB_Name = "mApi"
Option Explicit

Public Const NOERROR = 0

Private Const OF_EXIST = &H4000

'OFSTRUCT structure used by the OpenFile API function
Private Type OFSTRUCT            '136 bytes in length
  cBytes As String * 1
  fFixedDisk As String * 1
  nErrCode As Integer
  reserved As String * 4
  szPathName As String * 128
End Type

Private Declare Function OpenFile Lib "kernel32" (ByVal lpFileName As String, lpReOpenBuff As OFSTRUCT, ByVal wStyle As Long) As Long

'////////////////////////////////////////////////////////////////
' Funciones Publicas
Public Function FileExists(ByVal TestFile As String) As Boolean
  On Error GoTo ControlError
  
  Dim wStyle As Integer
  Dim Buffer As OFSTRUCT
  
  If OpenFile(TestFile, Buffer, OF_EXIST) < 0 Then Exit Function
  
  FileExists = True
  
  Exit Function
ControlError:
End Function
