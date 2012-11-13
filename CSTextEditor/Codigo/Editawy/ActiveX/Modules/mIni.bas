Attribute VB_Name = "mIni"
'==========================================================
'           Copyright Information
'==========================================================
'Program Name: Mewsoft Editawy
'Program Author   : Elsheshtawy, A. A.
'Home Page        : http://www.mewsoft.com
'Copyrights © 2006 Mewsoft Corporation. All rights reserved.
'==========================================================
'==========================================================
Option Explicit

' See full tutorial at http://www.vbexplorer.com/VBExplorer/focus/ini_tutorial.asp

#If Win16 Then
    Public Declare Function WritePrivateProfileString Lib "Kernel" (ByVal AppName As String, ByVal KeyName As String, ByVal NewString As String, ByVal FileName As String) As Integer
    Public Declare Function GetPrivateProfileString Lib "Kernel" Alias "GetPrivateProfilestring" (ByVal AppName As String, ByVal KeyName As Any, ByVal default As String, ByVal ReturnedString As String, ByVal MAXSIZE As Integer, ByVal FileName As String) As Integer
#Else
    Public Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As String, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
    Public Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As String, ByVal lpString As Any, ByVal lpFileName As String) As Long
#End If

Public Function ReadINI(Section, KeyName, FileName As String) As String
    Dim sRet As String
    sRet = String(5000, Chr(0))
    ReadINI = Left(sRet, GetPrivateProfileString(Section, ByVal KeyName, "", sRet, Len(sRet), FileName))
End Function

Public Function WriteINI(sSection As String, sKeyName As String, sNewString As String, sFileName) As Long
    'Returns non-zero on success; zero on failure.
    WriteINI = WritePrivateProfileString(sSection, sKeyName, sNewString, sFileName)
End Function

'====================================================================
'====================================================================
'http://cloanto.com/specs/ini.html
'File Structure
'An INI file is an 8-bit text file divided into sections, each containing zero or more keys. Each key contains zero or more values.
'
'Example:
'
'[SectionName]
'
'KeyName = value
'
';comment
'
'keyname=value, value, value ;comment

'\ at end of line           Continuation Character
 
'====================================================================

