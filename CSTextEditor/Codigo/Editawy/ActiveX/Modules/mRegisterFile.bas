Attribute VB_Name = "mRegisterFile"
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

Public Const HKEY_CLASSES_ROOT = &H80000000
Public Const HKEY_CURRENT_USER = &H80000001
Public Const HKEY_LOCAL_MACHINE = &H80000002
Public Const HKEY_USERS = &H80000003
Public Const HKEY_PERFORMANCE_DATA = &H80000004
Public Const KEY_ALL_ACCESS                   As Long = &H3F
Public Const KEY_SET_VALUE                    As Long = &H2
Public Const KEY_CREATE_SUB_KEY               As Long = &H4
Public Const REG_PRIMARY_KEY                  As String = "Software\Classes\"
Public Const REG_SHELL_KEY                    As String = "Shell\"
Public Const REG_SHELL_OPEN_KEY               As String = "Open\"
Public Const REG_SHELL_OPEN_COMMAND_KEY       As String = "Command"
Public Const REG_ICON_KEY                     As String = "DefaultIcon"
Public Const REG_SZ                           As Long = 1
Public Const REG_OPTION_NON_VOLATILE          As Long = 0
Public Const ERROR_SUCCESS                    As Long = 0

Public Declare Function Beep Lib "KERNEL32" (ByVal dwFreq As Long, ByVal dwDuration As Long) As Long
Public Declare Function RegCloseKey Lib "advapi32.dll" (ByVal hKey As Long) As Long
Public Declare Function RegOpenKeyEx Lib "advapi32.dll" Alias "RegOpenKeyExA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal ulOptions As Long, ByVal samDesired As Long, phkResult As Long) As Long
Public Declare Function RegCreateKeyEx Lib "advapi32.dll" Alias "RegCreateKeyExA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal Reserved As Long, ByVal lpClass As String, ByVal dwOptions As Long, ByVal samDesired As Long, lpSecurityAttributes As SECURITY_ATTRIBUTES, phkResult As Long, lpdwDisposition As Long) As Long
Public Declare Function RegSetValue Lib "advapi32.dll" Alias "RegSetValueA" (ByVal hKey As Long, ByVal lpSubKey As Any, ByVal dwType As Long, ByVal lpData As String, ByVal cbData As Long) As Long

'ex: RegisterFile ".secure", LoadResString(135) & AV.AVname, "Anti Virus", App.path & "\" & App.EXEName & ".exe /R %1", App.path & "\secicon.ico"  '"This file is secured by "
Public Function RegisterFile(sFileExt As String, _
                             sFileDescr As String, _
                             sAppID As String, _
                             sOpenCmd As String, _
                             sIconFile As String) As Boolean

    Dim hKey      As Long
    Dim bSuccess  As Boolean
    Dim bSuccess2 As Boolean
    
    bSuccess = False
    hKey = HKEY_LOCAL_MACHINE
    If CreateKey(hKey, REG_PRIMARY_KEY, sFileExt) Then
        If SetValue(hKey, REG_PRIMARY_KEY & sFileExt, sAppID) Then
            If CreateKey(hKey, REG_PRIMARY_KEY, sAppID) Then
                If SetValue(hKey, REG_PRIMARY_KEY & sAppID, sFileDescr) Then
                    If CreateKey(hKey, REG_PRIMARY_KEY & sAppID, REG_SHELL_KEY & REG_SHELL_OPEN_KEY & REG_SHELL_OPEN_COMMAND_KEY) Then
                        bSuccess = SetValue(hKey, REG_PRIMARY_KEY & sAppID & "\" & REG_SHELL_KEY & REG_SHELL_OPEN_KEY & REG_SHELL_OPEN_COMMAND_KEY, sOpenCmd)
                        If CreateKey(hKey, REG_PRIMARY_KEY & sAppID, REG_ICON_KEY) Then
                            bSuccess2 = SetValue(hKey, REG_PRIMARY_KEY & sAppID & "\" & REG_ICON_KEY, sIconFile)
                        End If
                    End If
                End If
            End If
        End If
    End If
    RegisterFile = (bSuccess = bSuccess2)

End Function

Private Function SetValue(lhKey As Long, _
                          SubKey As String, _
                          sValue As String) As Boolean
    
    Dim lhKeyOpen As Long
    Dim lResult   As Long
    Dim lTyp      As Long
    Dim lByte     As Long
    
    lByte = Len(sValue)
    lTyp = REG_SZ
    lhKeyOpen = OpenKey(lhKey, SubKey, KEY_SET_VALUE)
    lResult = RegSetValue(lhKey, SubKey, lTyp, sValue, lByte)
    If lResult <> ERROR_SUCCESS Then
        SetValue = False
     Else 'NOT LRESULT...
        SetValue = True
        RegCloseKey (lhKeyOpen)
    End If

End Function

Private Function OpenKey(lhKey As Long, _
                         SubKey As String, _
                         ulOptions As Long) As Long
    
    Dim lhKeyOpen As Long
    Dim lResult   As Long
    
    lhKeyOpen = 0
    lResult = RegOpenKeyEx(lhKey, SubKey, 0, ulOptions, lhKeyOpen)
    If lResult <> ERROR_SUCCESS Then
        OpenKey = 0
     Else 'NOT LRESULT...
        OpenKey = lhKeyOpen
    End If
    
End Function

Private Function CreateKey(lhKey As Long, _
                           SubKey As String, _
                           NewSubKey As String) As Boolean

    Dim lhKeyOpen    As Long
    Dim lhKeyNew     As Long
    Dim lDisposition As Long
    Dim lResult      As Long
    Dim Security     As SECURITY_ATTRIBUTES
    
    lhKeyOpen = OpenKey(lhKey, SubKey, KEY_CREATE_SUB_KEY)
    lResult = RegCreateKeyEx(lhKeyOpen, NewSubKey, 0, vbNullString, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, Security, lhKeyNew, lDisposition)
    If lResult = ERROR_SUCCESS Then
        CreateKey = True
        RegCloseKey (lhKeyNew)
     Else 'NOT LRESULT...
        CreateKey = False
    End If
    RegCloseKey (lhKeyOpen)

End Function

