Attribute VB_Name = "mRegistry"
Option Explicit

Const ERROR_SUCCESS = 0&

Const REG_SZ = 1
Const REG_BINARY = 3
Const REG_DWORD = 4

Public Const HKEY_LOCAL_MACHINE = &H80000002

Const HKEY_CLASSES_ROOT = &H80000000
Const HKEY_CURRENT_USER = &H80000001
Const HKEY_USERS = &H80000003

Declare Function OSRegCloseKey Lib "advapi32" Alias "RegCloseKey" (ByVal hKey As Long) As Long
Private Declare Function OSRegOpenKey Lib "advapi32" Alias "RegOpenKeyA" (ByVal hKey As Long, ByVal lpszSubKey As String, phkResult As Long) As Long
Private Declare Function OSRegQueryValueEx Lib "advapi32" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpszValueName As String, ByVal dwReserved As Long, lpdwType As Long, lpbData As Any, cbData As Long) As Long

' Hkey cache (used for logging purposes)
Private Type HKEY_CACHE
    hKey As Long
    strHkey As String
End Type

Private hkeyCache() As HKEY_CACHE

'-----------------------------------------------------------
' FUNCTION: RegOpenKey
'
' Opens an existing key in the system registry.
'
' Returns: True if the key was opened OK, False otherwise
'   Upon success, phkResult is set to the handle of the key.
'-----------------------------------------------------------
'
Public Function RegOpenKey(ByVal hKey As Long, ByVal lpszSubKey As String, phkResult As Long) As Boolean
    Dim lResult As Long
    Dim strHkey As String

    On Error GoTo 0

    strHkey = strGetHKEYString(hKey)

    lResult = OSRegOpenKey(hKey, lpszSubKey, phkResult)
    If lResult = ERROR_SUCCESS Then
        RegOpenKey = True
        AddHkeyToCache phkResult, strHkey & "\" & lpszSubKey
    Else
        RegOpenKey = False
    End If
End Function

' FUNCTION: RegQueryStringValue
'
' Retrieves the string data for a named
' (strValueName = name) or unnamed (strValueName = "")
' value within a registry key.  If the named value
' exists, but its data is not a string, this function
' fails.
'
' NOTE: For 16-bits, strValueName MUST be "" (but the
' NOTE: parameter is left in for source code compatability)
'
' Returns: True on success, else False.
'   On success, strData is set to the string data value
'
Public Function RegQueryStringValue(ByVal hKey As Long, ByVal strValueName As String, strData As String) As Boolean
    Dim lResult As Long
    Dim lValueType As Long
    Dim strBuf As String
    Dim lDataBufSize As Long
    
    RegQueryStringValue = False
    On Error GoTo 0
    ' Get length/data type
    lResult = OSRegQueryValueEx(hKey, strValueName, 0&, lValueType, ByVal 0&, lDataBufSize)
    If lResult = ERROR_SUCCESS Then
        If lValueType = REG_SZ Then
            strBuf = String(lDataBufSize, " ")
            lResult = OSRegQueryValueEx(hKey, strValueName, 0&, 0&, ByVal strBuf, lDataBufSize)
            If lResult = ERROR_SUCCESS Then
                RegQueryStringValue = True
                strData = StripTerminator(strBuf)
            End If
        End If
    End If
End Function

'-----------------------------------------------------------
' FUNCTION: RegCloseKey
'
' Closes an open registry key.
'
' Returns: True on success, else False.
'-----------------------------------------------------------
'
Public Function RegCloseKey(ByVal hKey As Long) As Boolean
    Dim lResult As Long
    
    On Error GoTo 0
    lResult = OSRegCloseKey(hKey)
    RegCloseKey = (lResult = ERROR_SUCCESS)
End Function

'Given an HKEY, return the text string representing that
'key.
Public Function strGetHKEYString(ByVal hKey As Long) As String
    Dim strKey As String

    'Is the hkey predefined?
    strKey = strGetPredefinedHKEYString(hKey)
    If strKey <> "" Then
        strGetHKEYString = strKey
        Exit Function
    End If
    
    'It is not predefined.  Look in the cache.
    Dim intIdx As Integer
    intIdx = intGetHKEYIndex(hKey)
    If intIdx >= 0 Then
        strGetHKEYString = hkeyCache(intIdx).strHkey
    Else
        strGetHKEYString = ""
    End If
End Function

'Adds or replaces an HKEY to the list of HKEYs in cache.
'Note that it is not necessary to remove keys from
'this list.
Private Sub AddHkeyToCache(ByVal hKey As Long, ByVal strHkey As String)
    Dim intIdx As Integer
    
    intIdx = intGetHKEYIndex(hKey)
    If intIdx < 0 Then
        'The key does not already exist.  Add it to the end.
        On Error Resume Next
        ReDim Preserve hkeyCache(0 To UBound(hkeyCache) + 1)
        If Err Then
            'If there was an error, it means the cache was empty.
            On Error GoTo 0
            ReDim hkeyCache(0 To 0)
        End If
        On Error GoTo 0

        intIdx = UBound(hkeyCache)
    Else
        'The key already exists.  It will be replaced.
    End If

    hkeyCache(intIdx).hKey = hKey
    hkeyCache(intIdx).strHkey = strHkey
End Sub

'-----------------------------------------------------------
' FUNCTION: StripTerminator
'
' Returns a string without any zero terminator.  Typically,
' this was a string returned by a Windows API call.
'
' IN: [strString] - String to remove terminator from
'
' Returns: The value of the string passed in minus any
'          terminating zero.
'-----------------------------------------------------------
'
Private Function StripTerminator(ByVal strString As String) As String
    Dim intZeroPos As Integer

    intZeroPos = InStr(strString, Chr$(0))
    If intZeroPos > 0 Then
        StripTerminator = Left$(strString, intZeroPos - 1)
    Else
        StripTerminator = strString
    End If
End Function

'Given a predefined HKEY, return the text string representing that
'key, or else return "".
Private Function strGetPredefinedHKEYString(ByVal hKey As Long) As String
    Select Case hKey
        Case HKEY_CLASSES_ROOT
            strGetPredefinedHKEYString = "HKEY_CLASSES_ROOT"
        Case HKEY_CURRENT_USER
            strGetPredefinedHKEYString = "HKEY_CURRENT_USER"
        Case HKEY_LOCAL_MACHINE
            strGetPredefinedHKEYString = "HKEY_LOCAL_MACHINE"
        Case HKEY_USERS
            strGetPredefinedHKEYString = "HKEY_USERS"
        'End Case
    End Select
End Function

'Searches the cache for the index of the given HKEY.
'Returns the index if found, else returns -1.
Private Function intGetHKEYIndex(ByVal hKey As Long) As Integer
    Dim intUBound As Integer
    
    On Error Resume Next
    intUBound = UBound(hkeyCache)
    If Err Then
        'If there was an error accessing the ubound of the array,
        'then the cache is empty
        GoTo NotFound
    End If
    On Error GoTo 0

    Dim intIdx As Integer
    For intIdx = 0 To intUBound
        If hkeyCache(intIdx).hKey = hKey Then
            intGetHKEYIndex = intIdx
            Exit Function
        End If
    Next intIdx
    
NotFound:
    intGetHKEYIndex = -1
End Function

