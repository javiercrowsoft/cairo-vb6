Attribute VB_Name = "mColorXPStyle"
Option Explicit

Private Declare Function GetVersionEx Lib "kernel32" Alias "GetVersionExA" (lpVersionInfo As OSVERSIONINFO) As Long

Private Const VER_PLATFORM_WIN32_NT = 2

Private Type OSVERSIONINFO
   dwVersionInfoSize As Long
   dwMajorVersion As Long
   dwMinorVersion As Long
   dwBuildNumber As Long
   dwPlatformId As Long
   szCSDVersion(0 To 127) As Byte
End Type

Private m_bIsXp As Boolean
Private m_bIsNt As Boolean
Private m_bIs2000OrAbove As Boolean

Public Property Get IsXp() As Boolean
   IsXp = m_bIsXp
End Property

Public Sub VerInitialise()
   
   Dim tOSV As OSVERSIONINFO
   tOSV.dwVersionInfoSize = Len(tOSV)
   GetVersionEx tOSV
   
   m_bIsNt = ((tOSV.dwPlatformId And VER_PLATFORM_WIN32_NT) = VER_PLATFORM_WIN32_NT)
   If (tOSV.dwMajorVersion > 5) Then
      m_bIsXp = True
      m_bIs2000OrAbove = True
   ElseIf (tOSV.dwMajorVersion = 5) Then
      m_bIs2000OrAbove = True
      If (tOSV.dwMinorVersion >= 1) Then
         m_bIsXp = True
      End If
   End If
   
End Sub

