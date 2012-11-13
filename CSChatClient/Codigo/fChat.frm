VERSION 5.00
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "richtx32.ocx"
Begin VB.Form fChat 
   Caption         =   "Form1"
   ClientHeight    =   6495
   ClientLeft      =   165
   ClientTop       =   855
   ClientWidth     =   7485
   Icon            =   "fChat.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   ScaleHeight     =   6495
   ScaleWidth      =   7485
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer tmBlink 
      Left            =   6660
      Top             =   2640
   End
   Begin VB.CommandButton cmdSend 
      Caption         =   "Enviar"
      Default         =   -1  'True
      Height          =   375
      Left            =   5160
      TabIndex        =   1
      Top             =   4800
      Width           =   1275
   End
   Begin RichTextLib.RichTextBox rtxChat 
      Height          =   4575
      Left            =   60
      TabIndex        =   2
      Top             =   60
      Width           =   6375
      _ExtentX        =   11245
      _ExtentY        =   8070
      _Version        =   393217
      BorderStyle     =   0
      ScrollBars      =   2
      TextRTF         =   $"fChat.frx":038A
   End
   Begin RichTextLib.RichTextBox rtxEdit 
      Height          =   915
      Left            =   60
      TabIndex        =   0
      Top             =   4680
      Width           =   4995
      _ExtentX        =   8811
      _ExtentY        =   1614
      _Version        =   393217
      TextRTF         =   $"fChat.frx":0415
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&Archivo"
      Begin VB.Menu mnuSave 
         Caption         =   "&Guardar..."
      End
      Begin VB.Menu mnuPrint 
         Caption         =   "&Imprimir..."
      End
      Begin VB.Menu mnuFileSep 
         Caption         =   "-"
      End
      Begin VB.Menu mnuExit 
         Caption         =   "&Salir"
      End
   End
End
Attribute VB_Name = "fChat"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const C_Module = "fChat"

Private Declare Function FlashWindow Lib "user32" (ByVal hwnd As Long, ByVal bInvert As Long) As Long
Private Declare Function GetCaretBlinkTime Lib "user32" () As Long
Private Declare Function PlaySound Lib "winmm.dll" Alias "PlaySoundA" (ByVal lpszName As String, ByVal hModule As Long, ByVal dwFlags As Long) As Long

'
' In a form, with a Timer control (timer1)
'
Private Declare Function GetForegroundWindow Lib "user32" () As Long
Private Declare Function GetWindowText Lib "user32" Alias "GetWindowTextA" (ByVal hwnd As Long, ByVal lpString As String, ByVal cch As Long) As Long
      
Private m_SessionKey  As String
Private m_User        As String
Private m_Computer    As String

Private Enum e_Sound
  sNewalert
  sNewemail
  sNudge
  sOnline
  sOutgoing
  sPhone
  sType
  sVimdone
End Enum

Public Property Get SessionKey() As String
  SessionKey = m_SessionKey
End Property

Public Property Let SessionKey(ByVal rhs As String)
  m_SessionKey = rhs
End Property

Public Property Get User() As String
  User = m_User
End Property

Public Property Let User(ByVal rhs As String)
  m_User = rhs
End Property

Public Property Get Computer() As String
  Computer = m_Computer
End Property

Public Property Let Computer(ByVal rhs As String)
  m_Computer = rhs
End Property

Public Sub AddText(ByVal From As String, _
                   ByVal Text As String, _
                   ByVal Color As Long, _
                   ByVal bFromOther As Boolean)
  
  'rtxChat.Text = rtxChat.Text & vbCrLf & _
                 From & " dice: " & vbCrLf & _
                 Text
  With rtxChat
  
    .SelStart = Len(.Text)
    .SelColor = &HAAAAAA
    .SelIndent = 100
    .SelText = Format(Now, "HH:NN - ") & From & " dice: " & vbCrLf
    
    .SelStart = Len(.Text)
    .SelColor = Color
    .SelIndent = 300
    .SelText = Text & vbCrLf
    
  End With
  
  If LCase$(Text) = "hello!" Or LCase$(Text) = "hola!" Or LCase$(Text) = "hello" Or LCase$(Text) = "hola" Then
    pSound sNudge
  Else
    If bFromOther Then pSound sType
  End If
  
  If Not pWindowIsActive() Then
    tmBlink.Enabled = True
  End If
End Sub

Private Sub cmdSend_Click()
  If LenB(rtxEdit.Text) Then
  
    Dim msg As String
    
    msg = rtxEdit.Text
    
    rtxEdit.Text = vbNullString
    
    DoEvents
    
    AddText fMain.txUser.Text, msg, vbWindowText, False
        
    Send m_SessionKey, _
         msg, _
         Me

  End If
End Sub

Private Sub mnuExit_Click()
  Unload Me
End Sub

Private Sub mnuPrint_Click()
  On Error Resume Next
  
  fPrinters.Show vbModal
  
  If Not fPrinters.Ok Then Exit Sub
  
  Dim printerName As String
  printerName = Printer.DeviceName
  
  Set Printer = Printers(fPrinters.lsPrinter.ListIndex)
  
  Unload fPrinters
  
  Me.rtxChat.SelPrint Printer.hDC
  
  Dim p As Printer
  
  For Each p In Printers
    If p.DeviceName = printerName Then
      Set Printer = p
      Exit For
    End If
  Next

End Sub

Private Sub mnuSave_Click()
  Dim file    As CSKernelFile.cFile
  Dim sFile   As String
  
  Set file = New CSKernelFile.cFile
  file.Init "mnuSave_Click", C_Module, fMain.cd
  If Not file.FSave(vbNullString, False, False) Then Exit Sub
  If LCase$(file.GetFileExt(fMain.cd.FileName)) <> "rtf" Then
    If Right$(file.Name, 1) <> "." Then
      sFile = GetValidPath(file.GetPath(fMain.cd.FileName)) & file.Name & ".rtf"
    Else
      sFile = GetValidPath(file.GetPath(fMain.cd.FileName)) & file.Name & "rtf"
    End If
  Else
    sFile = GetValidPath(fMain.cd.FileName) & file.Name
  End If
  
  On Error GoTo ControlError
  
  Me.rtxChat.SaveFile sFile
  
  Exit Sub
ControlError:
  If Err.Number = 75 Then
    MsgWarning "El archivo esta en uso o protegido contra escritura"
  Else
    MngError Err, "mnuSave_Click", C_Module, vbNullString
  End If
End Sub

Private Sub tmBlink_Timer()
  If pWindowIsActive() Then
    tmBlink.Enabled = False
  Else
    FlashWindow Me.hwnd, 1
  End If
End Sub

Private Sub Form_Load()
  On Error Resume Next
  rtxChat.Text = vbNullString
  rtxEdit.Text = vbNullString
  rtxEdit.Font.Size = 10
  rtxChat.Font.Size = 10
  tmBlink.Interval = GetCaretBlinkTime()
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  rtxChat.Height = Me.ScaleHeight - rtxEdit.Height - 260
  rtxEdit.Top = Me.ScaleHeight - rtxEdit.Height - 120
  cmdSend.Top = rtxEdit.Top
  rtxChat.Width = Me.ScaleWidth - rtxChat.Left * 2
  rtxEdit.Width = rtxChat.Width - cmdSend.Width - 160
  cmdSend.Left = rtxEdit.Left + rtxEdit.Width + 80
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  CSKernelClient2.UnloadForm Me, Me.Name
End Sub

Private Sub rtxChat_KeyDown(KeyCode As Integer, Shift As Integer)
  ' Copy secuence
  Select Case KeyCode
    Case vbKeyDown
    Case vbKeyUp
    Case vbKeyLeft
    Case vbKeyRight
    Case vbKeyPageDown
    Case vbKeyPageUp
    Case vbKeyHome
    Case vbKeyEnd
    Case Else
      If Not KeyCode = vbKeyC Then
        If (Shift And vbCtrlMask) = False Then
          KeyCode = 0
        End If
      End If
  End Select
End Sub

Private Sub rtxEdit_KeyPress(KeyAscii As Integer)
  If KeyAscii = vbKeyReturn Then
    cmdSend_Click
    KeyAscii = 0
  End If
End Sub

Private Function pWindowIsActive() As Boolean
  pWindowIsActive = GetForegroundWindow() = hwnd
End Function

Private Sub pSound(ByVal nSound As e_Sound)
  Select Case nSound
    
    Case sNewalert
      pPlaySound GetValidPath(App.Path) & "newalert.wav"
    Case sNewemail
      pPlaySound GetValidPath(App.Path) & "newemail.wav"
    Case sNudge
      pPlaySound GetValidPath(App.Path) & "nudge.wav"
    Case sOnline
      pPlaySound GetValidPath(App.Path) & "online.wav"
    Case sOutgoing
      pPlaySound GetValidPath(App.Path) & "outgoing.wav"
    Case sPhone
      pPlaySound GetValidPath(App.Path) & "phone.wav"
    Case sType
      pPlaySound GetValidPath(App.Path) & "type.wav"
    Case sVimdone
      pPlaySound GetValidPath(App.Path) & "vimdone.wav"
  End Select
End Sub

Private Sub pPlaySound(ByVal file As String)
  Dim soundfile As String
  
  PlaySound file, 0, &H0
End Sub
