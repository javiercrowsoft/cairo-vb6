Attribute VB_Name = "mdlRegistry"
'   (c) Copyright by Cyber Chris
'       Email: cyber_chris235@gmx.net
'
'   Please mail me when you want to use my code!

Option Explicit
Private Const REG_SZ                As Long = 1
Private Const REG_DWORD             As Long = 4
Public Const HKEY_CURRENT_USER      As Long = &H80000001
Private Const KEY_ALL_ACCESS        As Long = &H3F

Private Declare Function RegCloseKey Lib "advapi32.dll" (ByVal hKey As Long) As Long
Private Declare Function RegOpenKeyEx Lib "advapi32.dll" Alias "RegOpenKeyExA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal ulOptions As Long, ByVal samDesired As Long, phkResult As Long) As Long
Private Declare Function RegSetValueExString Lib "advapi32.dll" Alias "RegSetValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal Reserved As Long, ByVal dwType As Long, ByVal lpValue As String, ByVal cbData As Long) As Long
Private Declare Function RegSetValueExLong Lib "advapi32.dll" Alias "RegSetValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal Reserved As Long, ByVal dwType As Long, lpValue As Long, ByVal cbData As Long) As Long
Private Declare Function RegDeleteValue Lib "advapi32.dll" Alias "RegDeleteValueA" (ByVal hKey As Long, ByVal lpValueName As String) As Long

Public Sub CreateNewKey(ByVal lPredefinedKey As Long, ByVal sNewKeyName As String)
    Dim hNewKey As Long
    'lRetVal = RegCreateKeyEx(lPredefinedKey, sNewKeyName, 0&, vbNullString, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, 0&, hNewKey, lRetVal)
    RegCloseKey (hNewKey)
End Sub

Public Sub DeleteValue(lPredefinedKey As Long, _
                       sKeyName As String, _
                       sValueName As String)

    Dim lRetVal As Long
    Dim hKey    As Long            'handle of open key
    
    'open the specified key
    lRetVal = RegOpenKeyEx(lPredefinedKey, sKeyName, 0, KEY_ALL_ACCESS, hKey)
    lRetVal = RegDeleteValue(hKey, sValueName)
    RegCloseKey (hKey)

End Sub

Public Sub SetKeyValue(lPredefinedKey As Long, _
                       sKeyName As String, _
                       sValueName As String, _
                       vValueSetting As Variant, _
                       lValueType As Long)
    
    Dim lRetVal As Long
    Dim hKey    As Long            'handle of open key
    
    lRetVal = RegOpenKeyEx(lPredefinedKey, sKeyName, 0, KEY_ALL_ACCESS, hKey)
    lRetVal = SetValueEx(hKey, sValueName, lValueType, vValueSetting)
    RegCloseKey (hKey)

End Sub

Private Function SetValueEx(ByVal hKey As Long, _
                            sValueName As String, _
                            lType As Long, _
                            vValue As Variant) As Long

    Dim lValue As Long
    Dim sValue As String
    
    Select Case lType
    Case REG_SZ
       sValue = vValue
       SetValueEx = RegSetValueExString(hKey, sValueName, 0&, lType, sValue, Len(sValue))
    Case REG_DWORD
       lValue = vValue
       SetValueEx = RegSetValueExLong(hKey, sValueName, 0&, lType, lValue, 4)
    End Select

End Function
