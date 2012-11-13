Attribute VB_Name = "mMain"
Option Explicit

Private Declare Function GetComputerNameAPI Lib "kernel32" Alias "GetComputerNameA" _
    (ByVal lpBuffer As String, nSize As Long) As Long

Public Const csNoDate          As Date = #1/1/1900#
Public Const C_PSqlFechaHora = "'/'yyyymmdd hh:nn:ss/'"

Public Function GetComputerName() As String
  ' Set or retrieve the name of the computer.
  Dim strBuffer As String
  Dim lngLen As Long
    
  strBuffer = Space(255 + 1)
  lngLen = Len(strBuffer)
  If CBool(GetComputerNameAPI(strBuffer, lngLen)) Then
    GetComputerName = Left$(strBuffer, lngLen)
  Else
    GetComputerName = ""
  End If
End Function

