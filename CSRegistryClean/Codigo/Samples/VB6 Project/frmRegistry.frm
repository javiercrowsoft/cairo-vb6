VERSION 5.00
Begin VB.Form frmRegistry 
   Caption         =   "Registry Example"
   ClientHeight    =   2955
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   6300
   LinkTopic       =   "Form1"
   ScaleHeight     =   2955
   ScaleWidth      =   6300
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame fraStandardAdv 
      Caption         =   "Advanced Registry Functions"
      Height          =   2535
      Index           =   1
      Left            =   3360
      TabIndex        =   6
      Top             =   240
      Width           =   2775
      Begin VB.CommandButton cmdDeleteKey 
         Caption         =   "Delete Key"
         Height          =   495
         Left            =   1440
         TabIndex        =   11
         Top             =   1080
         Width           =   1215
      End
      Begin VB.TextBox txtEnumKeys 
         Height          =   615
         Left            =   120
         MultiLine       =   -1  'True
         ScrollBars      =   2  'Vertical
         TabIndex        =   10
         Top             =   1680
         Width           =   2535
      End
      Begin VB.CommandButton cmdEnumKeys 
         Caption         =   "Enumerate Keys"
         Height          =   495
         Left            =   120
         TabIndex        =   9
         Top             =   1080
         Width           =   1215
      End
      Begin VB.CommandButton cmdQueryValue 
         Caption         =   "Query Value"
         Height          =   495
         Left            =   1440
         TabIndex        =   8
         Top             =   360
         Width           =   1215
      End
      Begin VB.CommandButton cmdCreateKey 
         Caption         =   "Create Key"
         Height          =   495
         Left            =   120
         TabIndex        =   7
         Top             =   360
         Width           =   1215
      End
   End
   Begin VB.Frame fraStandardAdv 
      Caption         =   "Standard Registry Functions"
      Height          =   2535
      Index           =   0
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   2895
      Begin VB.CommandButton cmdSave 
         Caption         =   "SaveSetting"
         Height          =   495
         Left            =   120
         TabIndex        =   5
         Top             =   360
         Width           =   1215
      End
      Begin VB.CommandButton cmdGet 
         Caption         =   "GetSetting"
         Height          =   495
         Left            =   1560
         TabIndex        =   4
         Top             =   360
         Width           =   1215
      End
      Begin VB.CommandButton cmdDelete 
         Caption         =   "Delete"
         Height          =   495
         Left            =   1560
         TabIndex        =   3
         Top             =   1080
         Width           =   1215
      End
      Begin VB.CommandButton cmdGetAll 
         Caption         =   "GetAllSettings"
         Height          =   495
         Left            =   120
         TabIndex        =   2
         Top             =   1080
         Width           =   1215
      End
      Begin VB.TextBox txtGetAllSettings 
         Height          =   615
         Left            =   120
         MultiLine       =   -1  'True
         ScrollBars      =   2  'Vertical
         TabIndex        =   1
         Top             =   1680
         Width           =   2655
      End
   End
End
Attribute VB_Name = "frmRegistry"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

   Private Const REG_SZ As Long = 1 'REG_SZ represents a fixed-length text string.
   Private Const REG_DWORD As Long = 4 'REG_DWORD represents data by a number that is 4 bytes long.

   Private Const HKEY_CLASSES_ROOT = &H80000000 'The information stored here ensures that the correct program opens when you open a file by using Windows Explorer.
   Private Const HKEY_CURRENT_USER = &H80000001 'Contains the root of the configuration information for the user who is currently logged on.
   Private Const HKEY_LOCAL_MACHINE = &H80000002 'Contains configuration information particular to the computer (for any user).
   Private Const HKEY_USERS = &H80000003 'Contains the root of all user profiles on the computer.

   'Return values for all registry functions
   Private Const ERROR_SUCCESS = 0
   Private Const ERROR_NONE = 0

   Private Const KEY_QUERY_VALUE = &H1 'Required to query the values of a registry key.
   Private Const KEY_ALL_ACCESS = &H3F 'Combines the STANDARD_RIGHTS_REQUIRED, KEY_QUERY_VALUE, KEY_SET_VALUE, KEY_CREATE_SUB_KEY, KEY_ENUMERATE_SUB_KEYS, KEY_NOTIFY, and KEY_CREATE_LINK access rights.


'API Calls for writing to Registry
  'Close Registry Key
   Private Declare Function RegCloseKey Lib "advapi32.dll" (ByVal hKey As Long) As Long
  'Create Registry Key
   Private Declare Function RegCreateKey Lib "advapi32.dll" Alias "RegCreateKeyA" (ByVal hKey As Long, ByVal lpSubKey As String, phkResult As Long) As Long
  'Open Registry Key
   Private Declare Function RegOpenKeyEx Lib "advapi32.dll" Alias "RegOpenKeyExA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal ulOptions As Long, ByVal samDesired As Long, phkResult As Long) As Long
  'Query a String Value
   Private Declare Function RegQueryValueExString Lib "advapi32.dll" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, lpType As Long, ByVal lpData As String, lpcbData As Long) As Long
  'Query a Long Value
   Private Declare Function RegQueryValueExLong Lib "advapi32.dll" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, lpType As Long, lpData As Long, lpcbData As Long) As Long
  'Query a NULL Value
   Private Declare Function RegQueryValueExNULL Lib "advapi32.dll" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, lpType As Long, ByVal lpData As Long, lpcbData As Long) As Long
  'Enumerate Sub Keys
   Private Declare Function RegEnumKey Lib "advapi32.dll" Alias "RegEnumKeyA" (ByVal hKey As Long, ByVal dwIndex As Long, ByVal lpName As String, ByVal cbName As Long) As Long
  'Store a Value
   Private Declare Function RegSetValueEx Lib "advapi32.dll" Alias "RegSetValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal Reserved As Long, ByVal dwType As Long, lpData As Any, ByVal cbData As Long) As Long
  'Delete Key
   Private Declare Function RegDeleteKey Lib "advapi32.dll" Alias "RegDeleteKeyA" (ByVal hKey As Long, ByVal lpSubKey As String) As Long

Private Sub SaveValue(hKey As Long, strPath As String, strvalue As String, strData As String)
    
   Dim ret
  'Create a new key
   RegCreateKey hKey, strPath, ret
  'Save a string to the key
   RegSetValueEx ret, strvalue, 0, REG_SZ, ByVal strData, Len(strData)
  'close the key
   RegCloseKey ret
    
End Sub
 
Private Sub QueryValue(sKeyName As String, sValueName As String)
       
  Dim lRetVal As Long         'result of the API functions
  Dim hKey As Long         'handle of opened key
  Dim vValue As Variant      'setting of queried value

  lRetVal = RegOpenKeyEx(HKEY_LOCAL_MACHINE, sKeyName, 0, KEY_QUERY_VALUE, hKey) 'Open Key to Query a value
  lRetVal = QueryValueEx(hKey, sValueName, vValue) 'Query (determine) the value stored

  frmRegistry.Caption = vValue 'Set the Form's Caption to whatever text was stored
  RegCloseKey (hKey) 'Close the Key
       
End Sub
   
Function QueryValueEx(ByVal lhKey As Long, ByVal szValueName As String, vValue As Variant) As Long
       
       Dim Data As Long
       Dim retval As Long 'Return value of RegQuery functions
       Dim lType As Long 'Determine data type of present data
       Dim lValue As Long 'Long value
       Dim sValue As String 'String value

       On Error GoTo QueryValueExError

       ' Determine the size and type of data to be read
       retval = RegQueryValueExNULL(lhKey, szValueName, 0&, lType, 0&, Data)
       
       If retval <> ERROR_NONE Then Error 5

       Select Case lType
           ' Determine strings
           Case REG_SZ:
               sValue = String(Data, 0)

               retval = RegQueryValueExString(lhKey, szValueName, 0&, lType, sValue, Data)
               
               If retval = ERROR_NONE Then
                   vValue = Left$(sValue, Data - 1)
               Else
                   vValue = Empty
               End If
               
           ' Determine DWORDS
           Case REG_DWORD:
               retval = RegQueryValueExLong(lhKey, szValueName, 0&, lType, lValue, Data)
               
               If retval = ERROR_NONE Then vValue = lValue
           
           Case Else
               'all other data types not supported
               retval = -1
       End Select
    
QueryValueExError:
       QueryValueEx = retval
       Exit Function

   End Function
Private Sub cmdCreateKey_Click()

    SaveValue HKEY_LOCAL_MACHINE, "Software\" & App.Title, "Test", "Testing123" 'Call SaveValue Sub to save a value in the Registry

End Sub

Private Sub cmdDelete_Click()

    DeleteSetting App.Title, "Form Location" 'Delete Form Location
    
    cmdGet.Enabled = False 'Disable GetSetting Button

    MsgBox "The section - Form Location - has been deleted from the " & App.Title & " Registry Key" 'Inform User that Key has been deleted

End Sub

Private Sub cmdDeleteKey_Click()

    RegDeleteKey HKEY_LOCAL_MACHINE, "Software\" & App.Title 'Delete the Key created with API

    MsgBox "The key - " & App.Title & " - has been deleted from HKEY_LOCAL_MACHINE\Software Key" 'Inform User that Key has been deleted

End Sub

Private Sub cmdEnumKeys_Click()

    Dim strvalue As String 'Variable to hold current enumerated key
    Dim lDataLen As Long 'Length of data
    Dim lresult As Long 'Result of RegEnumKey
    Dim lValueLen As Long
    Dim lCurIdx As Long 'Current Index which gets incremented with each pass through the loop
    Dim lRetVal As Long 'Result of RegOpenKeyEx
    Dim hKeyResult As Long

         
    lRetVal = RegOpenKeyEx(HKEY_LOCAL_MACHINE, "Software\Microsoft", 0, KEY_ALL_ACCESS, hKeyResult) 'Open key with Full Access Rights

    If lRetVal = ERROR_SUCCESS Then
      lCurIdx = 0 'Initialise loop counter
      lDataLen = 32 'data Length
      lValueLen = 32

    Do
      strvalue = String(lValueLen, 0) 'get current key's value
         lresult = RegEnumKey(hKeyResult, lCurIdx, strvalue, lDataLen) 'Enumerate keys


         If lresult = ERROR_SUCCESS Then 'if successful, add current enumerated key to the txtEnumKeys textbox
            txtEnumKeys.Text = txtEnumKeys & vbCrLf & Left(strvalue, lValueLen)
         End If

         lCurIdx = lCurIdx + 1 'Increment counter for next enumeration

    Loop While lresult = ERROR_SUCCESS 'continue while successful

         RegCloseKey hKeyResult 'Close key
    Else 'If lRetVal is unsuccessful
      MsgBox "Cannot Open Key"
    End If
    
End Sub

Private Sub cmdGet_Click()
    Dim strTop As String 'Variable to hold value returned from the Registry
    Dim strLeft As String 'Variable to hold value returned from Registry

    strLeft = GetSetting(App.Title, "Form Location", "Left") 'Read Left value stored
    strTop = GetSetting(App.Title, "Form Location", "Top") 'Read Top value stored

    frmRegistry.Left = CInt(strLeft) 'Convert the string read from the Registry to an Integer value
    frmRegistry.Top = CInt(strTop)
    
End Sub

Private Sub cmdGetAll_Click()

    Dim arrAllSettings As Variant 'Variable to store 2 dimensional array of values read from Registry

    arrAllSettings = GetAllSettings(App.Title, "Form Location") 'Retrieve Registry values stored under Form Location


    txtGetAllSettings.Text = arrAllSettings(0, 0) & " = " & arrAllSettings(0, 1) & vbCrLf 'Display the first key and first value under Form Location (Left)
    txtGetAllSettings.Text = txtGetAllSettings.Text & arrAllSettings(1, 0) & " = " & arrAllSettings(1, 1) 'Display the second key and second value under Form Location (Top)

End Sub

Private Sub cmdQueryValue_Click()
    
    QueryValue "Software\" & App.Title, "Test" 'Read value in Specified Registry Key

End Sub

Private Sub cmdSave_Click()

    SaveSetting App.Title, "Form Location", "Left", "250" 'Store Left Value
    SaveSetting App.Title, "Form Location", "Top", "300" 'Store Top Value

    cmdGet.Enabled = True 'Enable the GetValue button, because there is a value to be read again
    
End Sub
