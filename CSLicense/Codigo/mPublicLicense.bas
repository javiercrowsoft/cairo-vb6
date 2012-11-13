Attribute VB_Name = "mPublicLicense"
Option Explicit

Public Const c_ACTIVE_CODE_OK = 1
Public Const c_ACTIVE_CODE_INVALID_DATE = 2
Public Const c_ACTIVE_CODE_INVALID_CODE = 3
Public Const c_ACTIVE_CODE_ERROR = 4
Public Const c_ACTIVE_CODE_UNDEFINED = 5

Public Function GetSumCode(ByVal strCode As String, ByRef vCodes() As Long, Optional ByVal n As Long = 6) As Long
  Dim k As Long
  Dim i As Long
  Dim j As Long
  
  m_vChars = Split(c_strChar, ",")
  
  For i = 1 To n
    For j = 1 To UBound(m_vChars)
      If Mid(strCode, i, 1) = m_vChars(j) Then
        vCodes(i) = j
        k = k + j
        Exit For
      End If
    Next
  Next

  k = Val(Right$(Trim(k), 1))
  If k > 6 Then k = k Mod 6

  If k <= 0 Then k = 1

  GetSumCode = k
End Function
