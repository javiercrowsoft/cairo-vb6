VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSendKey"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Copyright by Data Solutions Pty Ltd (ACN 010 951 498)
' All rights reserved.
' Email for info: clatta@ozemail.com.au

Option Explicit

Private Const C_Module = "cSendKey"

' These variables indicate whether these keys are pressed
Private ShiftOn As Integer
Private ControlOn As Integer
Private AltOn As Integer

Private Const KEYEVENTF_EXTENDEDKEY = &H1
Private Const KEYEVENTF_KEYUP = &H2

Private Declare Sub keybd_event Lib "user32" (ByVal bVk As Byte, ByVal bScan As Byte, ByVal dwFlags As Long, ByVal dwExtraInfo As Long)
Private Declare Function OemKeyScan Lib "user32" (ByVal wOemChar As Integer) As Long
Private Declare Function CharToOem Lib "user32" Alias "CharToOemA" (ByVal lpszSrc As String, ByVal lpszDst As String) As Long
Private Declare Function VkKeyScan Lib "user32" Alias "VkKeyScanA" (ByVal cChar As Byte) As Integer
Private Declare Function MapVirtualKey Lib "user32" Alias "MapVirtualKeyA" (ByVal wCode As Long, ByVal wMapType As Long) As Long
Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

' Constants for Virtual Keys
Private Const VK_BREAK = &H3       ' Break = ^C
Private Const VK_BELL = &H7        ' Bell = ^G
Private Const VK_BACK = &H8        ' Backspace = ^H
Private Const VK_TAB = &H9         ' Tab = ^I
Private Const VK_LINEFEED = &HA    ' Line feed = ^J
Private Const VK_CLEAR = &HC       ' Form feed = ^L
Private Const VK_RETURN = &HD      ' Enter key = ^M

Private Const VK_SHIFT = &H10      ' Shift Key
Private Const VK_CONTROL = &H11    ' Control key
Private Const VK_MENU = &H12       ' Alt key
Private Const VK_PAUSE = &H13      ' Pause??
Private Const VK_CAPITAL = &H14    ' Capslock
Private Const VK_NUMLOCK = &H90    ' Numeric lock
Private Const VK_SCROLL = &H91     ' Scroll lock

Private Const VK_ESCAPE = &H1B     ' Escape

Private Const VK_SPACE = &H20      ' Space
Private Const VK_PRIOR = &H21      ' Page Up
Private Const VK_NEXT = &H22       ' Page Down
Private Const VK_END = &H23        ' End
Private Const VK_HOME = &H24       ' Home
Private Const VK_LEFT = &H25       ' Left arrow
Private Const VK_UP = &H26         ' Up arrow
Private Const VK_RIGHT = &H27      ' Right arrow
Private Const VK_DOWN = &H28       ' Down arrow
Private Const VK_SELECT = &H29     ' Select??
Private Const VK_PRINT = &H2A      ' Print Screen
Private Const VK_EXECUTE = &H2B    ' Execute??
Private Const VK_SNAPSHOT = &H2C   ' Snapshot??
Private Const VK_INSERT = &H2D     ' Insert
Private Const VK_DELETE = &H2E     ' Delete
Private Const VK_HELP = &H2F       ' Help

' Numeric Keypad
Private Const VK_NUMPAD0 = &H60
Private Const VK_NUMPAD1 = &H61
Private Const VK_NUMPAD2 = &H62
Private Const VK_NUMPAD3 = &H63
Private Const VK_NUMPAD4 = &H64
Private Const VK_NUMPAD5 = &H65
Private Const VK_NUMPAD6 = &H66
Private Const VK_NUMPAD7 = &H67
Private Const VK_NUMPAD8 = &H68
Private Const VK_NUMPAD9 = &H69
Private Const VK_MULTIPLY = &H6A
Private Const VK_ADD = &H6B
Private Const VK_SEPARATOR = &H6C
Private Const VK_SUBTRACT = &H6D
Private Const VK_DECIMAL = &H6E
Private Const VK_DIVIDE = &H6F

' Function Keys
Private Const VK_F1 = &H70
Private Const VK_F2 = &H71
Private Const VK_F3 = &H72
Private Const VK_F4 = &H73
Private Const VK_F5 = &H74
Private Const VK_F6 = &H75
Private Const VK_F7 = &H76
Private Const VK_F8 = &H77
Private Const VK_F9 = &H78
Private Const VK_F10 = &H79
Private Const VK_F11 = &H7A
Private Const VK_F12 = &H7B
Private Const VK_F13 = &H7C
Private Const VK_F14 = &H7D
Private Const VK_F15 = &H7E
Private Const VK_F16 = &H7F
Private Const VK_F17 = &H80
Private Const VK_F18 = &H81
Private Const VK_F19 = &H82
Private Const VK_F20 = &H83
Private Const VK_F21 = &H84
Private Const VK_F22 = &H85
Private Const VK_F23 = &H86
Private Const VK_F24 = &H87

Private Sub PressKey(ByVal Vk As Byte, ByVal Scan As Byte)
' Copyright by Data Solutions Pty Ltd (ACN 010 951 498)
' All rights reserved.
' Email for info: clatta@ozemail.com.au

  ' Presses the appropriate key specified
  keybd_event Vk, Scan, 0, 0
  keybd_event Vk, Scan, KEYEVENTF_KEYUP, 0
End Sub

Private Sub PushAKey(ByVal char As String)
' Copyright by Data Solutions Pty Ltd (ACN 010 951 498)
' All rights reserved.
' Email for info: clatta@ozemail.com.au

  ' Pushes a normal (non-function) key
  Dim Vk As Integer
  Dim Scan As Integer
  Dim oemchar As String
    
  ' Get the virtual key code for this character
  Vk = VkKeyScan(Asc(char)) And &HFF
  
  oemchar = "  " ' 2 character buffer
  CharToOem char, oemchar
  
  ' Get the scan code for this key
  Scan = OemKeyScan(Asc(oemchar)) And &HFF
    
  ' Press the key
  PressKey Vk, Scan
End Sub
Public Sub PushKeys(ByVal Source As String)
' Copyright by Data Solutions Pty Ltd (ACN 010 951 498)
' All rights reserved.
' Email for info: clatta@ozemail.com.au

  ' This is the routine that does all the work
  
  Dim Ctr As Long
  Dim vkscan As Integer
  Dim SubStr As String
  Dim BrCnt As Integer    ' Bracket count
  Dim BrOpen As String    ' Open bracket
  Dim BrClose As String   ' Close bracket
  Dim Ch As String        ' Temporary character
  
  ShiftOn = False
  ControlOn = False
  AltOn = False
  
  ' Add a space to solve Mid$ problems. We won't process it.
  Source = Source + " "
  Ctr = 1
  Do While Ctr <= Len(Source) - 1
    
    Select Case Mid$(Source, Ctr, 1)
      Case "+"
        ' Shift key pressed
        BrOpen = Mid$(Source, Ctr + 1, 1)
        If BrOpen = "(" Or BrOpen = "{" Then
          Select Case BrOpen
            Case "("
              BrClose = ")"
            Case "{"
              BrClose = "}"
          End Select
          
          Ctr = Ctr + 1
          SubStr = ""
          BrCnt = 1
          Do While Ctr <= Len(Source) And BrCnt <> 0
            Ctr = Ctr + 1
            Ch = Mid$(Source, Ctr, 1)
            If Ch <> BrClose Then
              SubStr = SubStr + Mid$(Source, Ctr, 1)
            Else
              BrCnt = BrCnt - 1
            End If
            If Ch = BrOpen Then BrCnt = BrCnt + 1
          Loop
          
          If Not ShiftOn Then
            ' Turn shift on
            vkscan = MapVirtualKey(VK_SHIFT, 0)
            keybd_event VK_SHIFT, vkscan, 0, 0
            ShiftOn = True
          End If
            
          ' Push the keys
          Select Case BrOpen
            Case "("
              PushKeys SubStr
            Case "{"
              PushFnKey SubStr
          End Select
          
          ' Turn shift off
          vkscan = MapVirtualKey(VK_SHIFT, 0)
          keybd_event VK_SHIFT, vkscan, KEYEVENTF_KEYUP, 0
          ShiftOn = False
        Else
          ' The next key is shifted
          Ctr = Ctr + 1
          PushShiftKey Mid$(Source, Ctr, 1)
        End If
        
      Case "^"
        ' Control key pressed
        BrOpen = Mid$(Source, Ctr + 1, 1)
        If BrOpen = "(" Or BrOpen = "{" Then
          Select Case BrOpen
            Case "("
              BrClose = ")"
            Case "{"
              BrClose = "}"
          End Select
          
          Ctr = Ctr + 1
          SubStr = ""
          BrCnt = 1
          Do While Ctr <= Len(Source) And BrCnt <> 0
            Ctr = Ctr + 1
            Ch = Mid$(Source, Ctr, 1)
            If Ch <> BrClose Then
              SubStr = SubStr + Mid$(Source, Ctr, 1)
            Else
              BrCnt = BrCnt - 1
            End If
            If Ch = BrOpen Then BrCnt = BrCnt + 1
          Loop
          
          If Not ControlOn Then
            ' Turn control on
            vkscan = MapVirtualKey(VK_CONTROL, 0)
            keybd_event VK_CONTROL, vkscan, 0, 0
            ControlOn = True
          End If
            
          ' Push the keys
          Select Case BrOpen
            Case "("
              PushKeys SubStr
            Case "{"
              PushFnKey SubStr
          End Select
          
          ' Turn control off
          vkscan = MapVirtualKey(VK_CONTROL, 0)
          keybd_event VK_CONTROL, vkscan, KEYEVENTF_KEYUP, 0
          ControlOn = False
        Else
          ' The next key is controlled
          Ctr = Ctr + 1
          If Not ControlOn Then
            vkscan = MapVirtualKey(VK_CONTROL, 0)
            keybd_event VK_CONTROL, vkscan, 0, 0
          End If
          PushAKey Mid$(Source, Ctr, 1)
          vkscan = MapVirtualKey(VK_CONTROL, 0)
          keybd_event VK_CONTROL, vkscan, KEYEVENTF_KEYUP, 0
        End If
        
      Case "%"
        ' Push Alt key
        BrOpen = Mid$(Source, Ctr + 1, 1)
        If BrOpen = "(" Or BrOpen = "{" Then
          Select Case BrOpen
            Case "("
              BrClose = ")"
            Case "{"
              BrClose = "}"
          End Select
          
          Ctr = Ctr + 1
          SubStr = ""
          BrCnt = 1
          Do While Ctr <= Len(Source) And BrCnt <> 0
            Ctr = Ctr + 1
            Ch = Mid$(Source, Ctr, 1)
            If Ch <> BrClose Then
              SubStr = SubStr + Mid$(Source, Ctr, 1)
            Else
              BrCnt = BrCnt - 1
            End If
            If Ch = BrOpen Then BrCnt = BrCnt + 1
          Loop
          
          If Not AltOn Then
            ' Turn Alt on
            vkscan = MapVirtualKey(VK_MENU, 0)
            keybd_event VK_MENU, vkscan, 0, 0
            AltOn = True
          End If
            
          ' Push the keys
          Select Case BrOpen
            Case "("
              PushKeys SubStr
            Case "{"
              PushFnKey SubStr
          End Select
          
          ' Turn alt off
          vkscan = MapVirtualKey(VK_MENU, 0)
          keybd_event VK_MENU, vkscan, KEYEVENTF_KEYUP, 0
          AltOn = False
        Else
          ' The next key is Alted
          Ctr = Ctr + 1
          If Not AltOn Then
            vkscan = MapVirtualKey(VK_MENU, 0)
            keybd_event VK_MENU, vkscan, 0, 0
          End If
          PushAKey Mid$(Source, Ctr, 1)
          vkscan = MapVirtualKey(VK_MENU, 0)
          keybd_event VK_MENU, vkscan, KEYEVENTF_KEYUP, 0
        End If
        
      Case "{"
        ' Function keys
        Ctr = Ctr + 1
        SubStr = ""
        Do While Ctr < Len(Source) And Mid$(Source, Ctr, 1) <> "}"
          SubStr = SubStr + Mid$(Source, Ctr, 1)
          Ctr = Ctr + 1
        Loop
        If Mid$(Source, Ctr, 1) = "}" And Mid$(Source, Ctr + 1, 1) = "}" Then
          ' Right brace
          PushShiftKey "}"
          Ctr = Ctr + 1
        Else
          PushFnKey SubStr
        End If
        
      Case "A" To "Z", "!", "@", "#", "$", "&", "*", "(", ")", "_", "|", """", ":", "?", ">", "<"
        ' Shifted keys
        PushShiftKey Mid$(Source, Ctr, 1)
        
      Case "~"
        ' The enter key
        PushFnKey "ENTER"
        
      Case Else
        PushAKey Mid$(Source, Ctr, 1)
        
    End Select
    
    Ctr = Ctr + 1
  Loop
  
  If ShiftOn Then
    ' Turn shift off if need be
    vkscan = MapVirtualKey(VK_SHIFT, 0)
    keybd_event VK_SHIFT, vkscan, KEYEVENTF_KEYUP, 0
  End If
  If ControlOn Then
    ' Turn control off if need be
    vkscan = MapVirtualKey(VK_CONTROL, 0)
    keybd_event VK_CONTROL, vkscan, KEYEVENTF_KEYUP, 0
  End If
  If AltOn Then
    ' Turn alt off if need be
    vkscan = MapVirtualKey(VK_MENU, 0)
    keybd_event VK_MENU, vkscan, KEYEVENTF_KEYUP, 0
  End If
  
End Sub

Private Sub PushFnKey(KeyCode As String)
' Copyright by Data Solutions Pty Ltd (ACN 010 951 498)
' All rights reserved.
' Email for info: clatta@ozemail.com.au


  ' Outputs function key. KeyCode may have a number of times to be output
  Dim ScanKey As Integer
  Dim NumPushes As Long
  Dim Ctr As Integer
  Dim FnKey As String
  Dim OrigCode As String
  
  On Error GoTo PushFnKey_ErrorHandler
  
  ' Work out which function key to push and how many times
  If InStr(KeyCode, " ") > 0 Then
    ' We're doing this multpile times
    ' Find the rightmost space. I do this because I want to allow people to
    ' output multiple words with spaces in them. eg "{Seven times 7}"
    Ctr = Len(KeyCode)
    Do While Ctr > 1 And Mid$(KeyCode, Ctr, 1) <> " "
      Ctr = Ctr - 1
    Loop
    OrigCode = Left$(KeyCode, Ctr - 1)
    FnKey = UCase(OrigCode)
    ' This may fail if not a number, in which case NumPushes will be 1
    NumPushes = CInt(Right$(KeyCode, Len(KeyCode) - Ctr))
  Else
    ' Once only
    NumPushes = 1
    FnKey = UCase(KeyCode)
    OrigCode = KeyCode
  End If
  
  ' Function Keys
  ' BTW, if you're reading my code, I do the for-next loop in each case rather
  ' than outside the select because I figured it might be faster to do one Select
  ' and the for-next loop n-times than do both the for-next and the Select n-times.
  Select Case FnKey
    Case "BACKSPACE", "BS", "BKSP"
      ' Backspace
      ScanKey = MapVirtualKey(VK_BACK, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_BACK, ScanKey
      Next Ctr
    Case "BELL"
      ' Bell = ^G
      ScanKey = MapVirtualKey(VK_BELL, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_BELL, ScanKey
      Next Ctr
    Case "BREAK"
      ' Break = ^C
      ScanKey = MapVirtualKey(VK_BREAK, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_BREAK, ScanKey
      Next Ctr
    Case "CAPSLOCK", "CAPS"
      ' Capslock
      ScanKey = MapVirtualKey(VK_CAPITAL, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_CAPITAL, ScanKey
      Next Ctr
    Case "DELETE", "DEL"
      ' Delete
      ScanKey = MapVirtualKey(VK_DELETE, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_DELETE, ScanKey
      Next Ctr
    Case "DOWN"
      ' Down Arrow
      ScanKey = MapVirtualKey(VK_DOWN, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_DOWN, ScanKey
      Next Ctr
    Case "END"
      ' End
      ScanKey = MapVirtualKey(VK_END, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_END, ScanKey
      Next Ctr
    Case "ENTER", "RETURN"
      ' Enter = ^M
      ScanKey = MapVirtualKey(VK_RETURN, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_RETURN, ScanKey
      Next Ctr
    Case "ESCAPE", "ESC"
      ' Escape = ^[
      ScanKey = MapVirtualKey(VK_ESCAPE, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_ESCAPE, ScanKey
      Next Ctr
    Case "FORMFEED", "FF"
      ' Form feed = ^L
      ScanKey = MapVirtualKey(VK_CLEAR, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_CLEAR, ScanKey
      Next Ctr
    Case "HELP"
      ' Help
      ScanKey = MapVirtualKey(VK_HELP, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_HELP, ScanKey
      Next Ctr
    Case "HOME"
      ' Home
      ScanKey = MapVirtualKey(VK_HOME, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_HOME, ScanKey
      Next Ctr
    Case "INSERT", "INS"
      ' Insert
      ScanKey = MapVirtualKey(VK_INSERT, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_INSERT, ScanKey
      Next Ctr
    Case "LEFT"
      ' Left Arrow
      ScanKey = MapVirtualKey(VK_LEFT, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_LEFT, ScanKey
      Next Ctr
    Case "LINEFEED", "LF"
      ' Linefeed = ^J
      ScanKey = MapVirtualKey(VK_LINEFEED, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_LINEFEED, ScanKey
      Next Ctr
    Case "NEWLINE", "NL"
      ' New line = Carraige return & Line Feed = ^M^J
      For Ctr = 1 To NumPushes
        ScanKey = MapVirtualKey(VK_RETURN, 0)
        PressKey VK_RETURN, ScanKey
        ScanKey = MapVirtualKey(VK_LINEFEED, 0)
        PressKey VK_LINEFEED, ScanKey
      Next Ctr
    Case "NUMLOCK"
      ' Numeric Lock
      ScanKey = MapVirtualKey(VK_NUMLOCK, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_NUMLOCK, ScanKey
      Next Ctr
    Case "PGDN", "PAGEDOWN", "NEXT"
      ' Page Down
      ScanKey = MapVirtualKey(VK_NEXT, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_NEXT, ScanKey
      Next Ctr
    Case "PGUP", "PAGEUP", "PRIOR"
      ' Page Up
      ScanKey = MapVirtualKey(VK_PRIOR, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_PRIOR, ScanKey
      Next Ctr
    Case "PRINTSCREEN", "PRTSC"
      ' Print Screen
      ScanKey = MapVirtualKey(VK_PRINT, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_PRINT, ScanKey
      Next Ctr
    Case "RIGHT"
      ' Right Arrow
      ScanKey = MapVirtualKey(VK_RIGHT, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_RIGHT, ScanKey
      Next Ctr
    Case "SCROLLLOCK", "SCRLK"
      ' Scroll lock
      ScanKey = MapVirtualKey(VK_SCROLL, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_SCROLL, ScanKey
      Next Ctr
    Case "TAB"
      ' Tab = ^I
      ScanKey = MapVirtualKey(VK_TAB, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_TAB, ScanKey
      Next Ctr
    Case "UP"
      ' Up Arrow
      ScanKey = MapVirtualKey(VK_UP, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_UP, ScanKey
      Next Ctr
    Case "SLEEP"
      ' We sleep for a few seconds
      Sleep NumPushes * 1000
    Case "F1"
      ' F1
      ScanKey = MapVirtualKey(VK_F1, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F1, ScanKey
      Next Ctr
    Case "F2"
      ' F2
      ScanKey = MapVirtualKey(VK_F2, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F2, ScanKey
      Next Ctr
    Case "F3"
      ' F3
      ScanKey = MapVirtualKey(VK_F3, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F3, ScanKey
      Next Ctr
    Case "F4"
      ' F4
      ScanKey = MapVirtualKey(VK_F4, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F4, ScanKey
      Next Ctr
    Case "F5"
      ' F5
      ScanKey = MapVirtualKey(VK_F5, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F5, ScanKey
      Next Ctr
    Case "F6"
      ' F6
      ScanKey = MapVirtualKey(VK_F6, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F6, ScanKey
      Next Ctr
    Case "F7"
      ' F7
      ScanKey = MapVirtualKey(VK_F7, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F7, ScanKey
      Next Ctr
    Case "F8"
      ' F8
      ScanKey = MapVirtualKey(VK_F8, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F8, ScanKey
      Next Ctr
    Case "F9"
      ' F9
      ScanKey = MapVirtualKey(VK_F9, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F9, ScanKey
      Next Ctr
    Case "F10"
      ' F10
      ScanKey = MapVirtualKey(VK_F10, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F10, ScanKey
      Next Ctr
    Case "F11"
      ' F11
      ScanKey = MapVirtualKey(VK_F11, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F11, ScanKey
      Next Ctr
    Case "F12"
      ' F12
      ScanKey = MapVirtualKey(VK_F12, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F12, ScanKey
      Next Ctr
    Case "F13"
      ' F13
      ScanKey = MapVirtualKey(VK_F13, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F13, ScanKey
      Next Ctr
    Case "F14"
      ' F14
      ScanKey = MapVirtualKey(VK_F14, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F14, ScanKey
      Next Ctr
    Case "F15"
      ' F15
      ScanKey = MapVirtualKey(VK_F15, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F15, ScanKey
      Next Ctr
    Case "F16"
      ' F16
      ScanKey = MapVirtualKey(VK_F16, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F16, ScanKey
      Next Ctr
    Case "F17"
      ' F17
      ScanKey = MapVirtualKey(VK_F17, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F17, ScanKey
      Next Ctr
    Case "F18"
      ' F18
      ScanKey = MapVirtualKey(VK_F18, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F18, ScanKey
      Next Ctr
    Case "F19"
      ' F19
      ScanKey = MapVirtualKey(VK_F19, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F19, ScanKey
      Next Ctr
    Case "F20"
      ' F20
      ScanKey = MapVirtualKey(VK_F20, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F20, ScanKey
      Next Ctr
    Case "F21"
      ' F21
      ScanKey = MapVirtualKey(VK_F21, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F21, ScanKey
      Next Ctr
    Case "F22"
      ' F22
      ScanKey = MapVirtualKey(VK_F22, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F22, ScanKey
      Next Ctr
    Case "F23"
      ' F23
      ScanKey = MapVirtualKey(VK_F23, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F23, ScanKey
      Next Ctr
    Case "F24"
      ' F24
      ScanKey = MapVirtualKey(VK_F24, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_F24, ScanKey
      Next Ctr
    Case "NUMPAD0"
      ' Numeric Keypad 0
      ScanKey = MapVirtualKey(VK_NUMPAD0, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_NUMPAD0, ScanKey
      Next Ctr
    Case "NUMPAD1"
      ' Numeric Keypad 1
      ScanKey = MapVirtualKey(VK_NUMPAD1, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_NUMPAD1, ScanKey
      Next Ctr
    Case "NUMPAD2"
      ' Numeric Keypad 2
      ScanKey = MapVirtualKey(VK_NUMPAD2, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_NUMPAD2, ScanKey
      Next Ctr
    Case "NUMPAD3"
      ' Numeric Keypad 3
      ScanKey = MapVirtualKey(VK_NUMPAD3, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_NUMPAD3, ScanKey
      Next Ctr
    Case "NUMPAD4"
      ' Numeric Keypad 4
      ScanKey = MapVirtualKey(VK_NUMPAD4, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_NUMPAD4, ScanKey
      Next Ctr
    Case "NUMPAD5"
      ' Numeric Keypad 5
      ScanKey = MapVirtualKey(VK_NUMPAD5, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_NUMPAD5, ScanKey
      Next Ctr
    Case "NUMPAD6"
      ' Numeric Keypad 6
      ScanKey = MapVirtualKey(VK_NUMPAD6, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_NUMPAD6, ScanKey
      Next Ctr
    Case "NUMPAD7"
      ' Numeric Keypad 7
      ScanKey = MapVirtualKey(VK_NUMPAD7, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_NUMPAD7, ScanKey
      Next Ctr
    Case "NUMPAD8"
      ' Numeric Keypad 8
      ScanKey = MapVirtualKey(VK_NUMPAD8, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_NUMPAD8, ScanKey
      Next Ctr
    Case "NUMPAD9"
      ' Numeric Keypad 9
      ScanKey = MapVirtualKey(VK_NUMPAD9, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_NUMPAD9, ScanKey
      Next Ctr
    Case "NUMPADMULTIPLY", "NUMPAD*"
      ' Numeric Keypad Multiply
      ScanKey = MapVirtualKey(VK_MULTIPLY, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_MULTIPLY, ScanKey
      Next Ctr
    Case "NUMPADADD", "NUMPAD+"
      ' Numeric Keypad +
      ScanKey = MapVirtualKey(VK_ADD, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_ADD, ScanKey
      Next Ctr
    Case "NUMPADSUBTRACT", "NUMPAD-"
      ' Numeric Keypad -
      ScanKey = MapVirtualKey(VK_SUBTRACT, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_SUBTRACT, ScanKey
      Next Ctr
    Case "NUMPADDECIMAL", "NUMPAD."
      ' Numeric Keypad .
      ScanKey = MapVirtualKey(VK_DECIMAL, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_DECIMAL, ScanKey
      Next Ctr
    Case "NUMPADDIVIDE", "NUMPAD/"
      ' Numeric Keypad /
      ScanKey = MapVirtualKey(VK_DIVIDE, 0)
      For Ctr = 1 To NumPushes
        PressKey VK_DIVIDE, ScanKey
      Next Ctr
    
    Case "~", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "_", "+", "|", "{", "}", """", ":", "?", ">", "<"
      ' Shifted keys
      For Ctr = 1 To NumPushes
        PushShiftKey OrigCode
      Next Ctr
    
    Case Else
      ' Ordinary keys
      For Ctr = 1 To NumPushes
        PushKeys OrigCode
      Next Ctr

  End Select
  
  Exit Sub
  
PushFnKey_ErrorHandler:
  ' Should only occur when the number of pushes isn't an integer
  NumPushes = 1
  Resume Next
End Sub

Private Sub PushShiftKey(ByVal char As String)
' Copyright by Data Solutions Pty Ltd (ACN 010 951 498)
' All rights reserved.
' Email for info: clatta@ozemail.com.au

  ' Pushes a key with the shift key down
  ' If ShiftOn is true, it does not press and release the shift key
  
  Dim vkscan As Integer
  
  If Not ShiftOn Then
    ' Turn shift on
    vkscan = MapVirtualKey(VK_SHIFT, 0)
    keybd_event VK_SHIFT, vkscan, 0, 0
  End If
  
  ' Push key
  PushAKey char
  
  If Not ShiftOn Then
    ' Turn shift off
    vkscan = MapVirtualKey(VK_SHIFT, 0)
    keybd_event VK_SHIFT, vkscan, KEYEVENTF_KEYUP, 0
  End If
End Sub

#If PREPROC_DEBUG Then
Private Sub Form_Initialize()
  gdbInitInstance C_Module
End Sub

Private Sub Form_Terminate()
  gdbTerminateInstance C_Module
End Sub
#End If

