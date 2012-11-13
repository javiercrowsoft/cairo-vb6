Attribute VB_Name = "mGDIPlus"
Option Explicit

Private m_token As Long
Private gfx As Long

Public Function GDIPlusCreate() As Boolean
Dim gpInput As GdiplusStartupInput
Dim token As Long
   gpInput.GdiplusVersion = 1
   If GdiplusStartup(token, gpInput) = Ok Then
      m_token = token
      GDIPlusCreate = True
   End If
End Function

Public Sub GDIPlusDispose()
   If Not (m_token = 0) Then
      GdiplusShutdown m_token
      m_token = 0
   End If
End Sub

Public Function PtrToString(ByVal lPtr As Long) As String
Dim lSize As Long
Dim b() As Byte
Dim s As String
   If Not (lPtr = 0) Then
      lSize = lstrlenW(lPtr)
      If ((lSize > 0) And (lSize < &H10000)) Then
         ReDim b(0 To (lSize * 2) - 1) As Byte
         RtlMoveMemory b(0), ByVal lPtr, lSize * 2
         s = b
      End If
   End If
   PtrToString = b
End Function

Public Function SetStatusHelper(ByVal status As GpStatus) As GpStatus
   If (status = Ok) Then
      ' ok
   Else
      Err.Raise 1048 + status, App.EXEName & ".GDIP", "GDI+ Error " & status
   End If
   SetStatusHelper = status
End Function

Public Function GetGuidString(Guid As CLSID) As String
Dim i As Long
Dim sGuid As String

   sGuid = "{" & hexPad(Guid.Data1, 8) & "-" & hexPad(Guid.Data2, 4) & "-" & hexPad(Guid.Data3, 4) & "-"
   sGuid = sGuid & hexPad(Guid.Data4(0), 2) & hexPad(Guid.Data4(1), 2) & "-"
   For i = 2 To 7
      sGuid = sGuid & hexPad(Guid.Data4(i), 2)
   Next i
   sGuid = sGuid & "}"
   GetGuidString = sGuid

End Function

Private Function hexPad(ByVal value As Long, ByVal padSize As Long) As String
Dim sRet As String
Dim lMissing As Long
   sRet = Hex$(value)
   lMissing = padSize - Len(sRet)
   If (lMissing > 0) Then
      sRet = String$(lMissing, "0") & sRet
   ElseIf (lMissing < 0) Then
      sRet = Mid$(sRet, -lMissing + 1)
   End If
   hexPad = sRet
End Function

Public Function UnsignedAdd(Start As Long, Incr As Long) As Long
' This function is useful when doing pointer arithmetic,
' but note it only works for positive values of Incr

   If Start And &H80000000 Then 'Start < 0
      UnsignedAdd = Start + Incr
   ElseIf (Start Or &H80000000) < -Incr Then
      UnsignedAdd = Start + Incr
   Else
      UnsignedAdd = (Start + &H80000000) + (Incr + &H80000000)
   End If
   
End Function

