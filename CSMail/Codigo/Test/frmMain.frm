VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form frmMain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Sending Email Using CDO"
   ClientHeight    =   7350
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   9120
   BeginProperty Font 
      Name            =   "Lucida Sans Unicode"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   7350
   ScaleWidth      =   9120
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton Command1 
      Caption         =   "Get Password"
      Height          =   330
      Left            =   45
      TabIndex        =   18
      Top             =   3150
      Width           =   1275
   End
   Begin VB.CommandButton cmdRemove 
      Caption         =   "-"
      BeginProperty Font 
         Name            =   "Lucida Sans Unicode"
         Size            =   14.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   960
      TabIndex        =   7
      Top             =   4800
      Width           =   375
   End
   Begin VB.CommandButton cmdAdd 
      Caption         =   "+"
      BeginProperty Font 
         Name            =   "Lucida Sans Unicode"
         Size            =   14.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   960
      TabIndex        =   6
      Top             =   4320
      Width           =   375
   End
   Begin MSComctlLib.StatusBar Status 
      Align           =   2  'Align Bottom
      Height          =   255
      Left            =   0
      TabIndex        =   17
      Top             =   7095
      Width           =   9120
      _ExtentX        =   16087
      _ExtentY        =   450
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   4
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            AutoSize        =   1
            Enabled         =   0   'False
            Object.Width           =   12779
            MinWidth        =   10583
         EndProperty
         BeginProperty Panel2 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Style           =   1
            Enabled         =   0   'False
            Object.Width           =   1058
            MinWidth        =   1058
            TextSave        =   "CAPS"
         EndProperty
         BeginProperty Panel3 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Style           =   2
            Object.Width           =   1058
            MinWidth        =   1058
            TextSave        =   "NUM"
         EndProperty
         BeginProperty Panel4 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Style           =   3
            Enabled         =   0   'False
            Object.Width           =   1058
            MinWidth        =   1058
            TextSave        =   "INS"
         EndProperty
      EndProperty
   End
   Begin VB.Frame fraAttachments 
      Caption         =   "Attachments"
      Height          =   2415
      Left            =   1440
      TabIndex        =   16
      Top             =   4080
      Width           =   7575
      Begin MSComctlLib.ListView lstAttachments 
         Height          =   2055
         Left            =   120
         TabIndex        =   8
         Top             =   240
         Width           =   7335
         _ExtentX        =   12938
         _ExtentY        =   3625
         View            =   3
         LabelEdit       =   1
         MultiSelect     =   -1  'True
         LabelWrap       =   -1  'True
         HideSelection   =   -1  'True
         FullRowSelect   =   -1  'True
         GridLines       =   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   0
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Lucida Sans Unicode"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         NumItems        =   2
         BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            Text            =   "File Name"
            Object.Width           =   3235
         EndProperty
         BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            SubItemIndex    =   1
            Text            =   "Path"
            Object.Width           =   9701
         EndProperty
      End
   End
   Begin MSComDlg.CommonDialog cmnDialog 
      Left            =   720
      Top             =   2400
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.TextBox txtFrom 
      Appearance      =   0  'Flat
      Height          =   285
      Left            =   1440
      TabIndex        =   2
      Text            =   "javier@crowsoft.com.ar"
      Top             =   840
      Width           =   7575
   End
   Begin VB.TextBox txtSender 
      Appearance      =   0  'Flat
      Height          =   285
      Left            =   1440
      TabIndex        =   1
      Text            =   "javier@crowsoft.com.ar"
      Top             =   480
      Width           =   7575
   End
   Begin VB.TextBox txtSMTP 
      Appearance      =   0  'Flat
      Height          =   285
      Left            =   1440
      TabIndex        =   0
      Text            =   "192.160.142.98"
      Top             =   120
      Width           =   7575
   End
   Begin VB.TextBox txtSubject 
      Appearance      =   0  'Flat
      Height          =   285
      Left            =   1440
      TabIndex        =   4
      Text            =   "prueba"
      Top             =   1560
      Width           =   7575
   End
   Begin VB.TextBox txtBody 
      Appearance      =   0  'Flat
      Height          =   2085
      Left            =   1440
      MultiLine       =   -1  'True
      TabIndex        =   5
      Top             =   1920
      Width           =   7575
   End
   Begin VB.TextBox txtTo 
      Appearance      =   0  'Flat
      Height          =   285
      Left            =   1440
      TabIndex        =   3
      Text            =   "jaresax@yahoo.com"
      Top             =   1200
      Width           =   7575
   End
   Begin VB.CommandButton cmdSend 
      Caption         =   "Send"
      Height          =   375
      Left            =   7080
      TabIndex        =   9
      Top             =   6600
      Width           =   1935
   End
   Begin VB.Label Label3 
      Caption         =   "Display From:"
      Height          =   255
      Left            =   120
      TabIndex        =   15
      Top             =   840
      Width           =   1335
   End
   Begin VB.Label lblSender 
      Caption         =   "Source Email:"
      Height          =   255
      Left            =   120
      TabIndex        =   14
      Top             =   480
      Width           =   1335
   End
   Begin VB.Label lblSMTP 
      Caption         =   "SMTP Server:"
      Height          =   255
      Left            =   120
      TabIndex        =   13
      Top             =   120
      Width           =   1335
   End
   Begin VB.Label lblMessage 
      Caption         =   "Message:"
      Height          =   255
      Left            =   120
      TabIndex        =   12
      Top             =   1920
      Width           =   1335
   End
   Begin VB.Label lblSubject 
      Caption         =   "Subject:"
      Height          =   255
      Left            =   120
      TabIndex        =   11
      Top             =   1560
      Width           =   1335
   End
   Begin VB.Label lblTo 
      Caption         =   "Recipient Email:"
      Height          =   255
      Left            =   120
      TabIndex        =   10
      Top             =   1200
      Width           =   1335
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdAdd_Click()
  On Error GoTo Err_cmdAdd_Click
  Dim itmX    As ListItem
  Dim sFile   As String
  Dim sPath   As String
  Dim sFull   As String

  cmnDialog.CancelError = True
  cmnDialog.ShowOpen

  sFull = cmnDialog.FileName
  sFile = Right$(sFull, Len(sFull) - InStrRev(sFull, "\"))
  sPath = Left$(sFull, Len(sFull) - Len(sFile))

  Set itmX = lstAttachments.ListItems.Add
  itmX.Text = sFile
  itmX.SubItems(1) = sPath

Err_cmdAdd_Click:
  Set itmX = Nothing
End Sub

Private Sub cmdRemove_Click()
  Dim i   As Integer

  For i = lstAttachments.ListItems.Count To 1 Step -1
    If lstAttachments.ListItems(i).Selected = True Then
      lstAttachments.ListItems.Remove i
    End If
  Next i
End Sub

Private Sub cmdSend_Click()
  
  Dim i     As Integer
  Dim sFull As String
  Dim itmX  As ListItem

  Dim MyMessage As CSMail.cMail
  
  Set MyMessage = New CSMail.cMail

  For i = 1 To lstAttachments.ListItems.Count
    Set itmX = lstAttachments.ListItems(i)
    sFull = itmX.SubItems(1) & itmX.Text
    MyMessage.AddAttach sFull
  Next i
  
  If MyMessage.SendEmail(txtTo.Text, _
                         txtFrom.Text, _
                         txtSender.Text, _
                         txtSMTP.Text, _
                         "javier", _
                         "catalina", _
                         txtSubject.Text, _
                         txtBody.Text) = True Then
    MsgBox "Email Sent Successfully!", vbOKOnly + vbInformation, "Email Sent"
  Else
    MsgBox "There was an error while sending your email.", vbOKOnly + vbExclamation, "Error"
  End If
End Sub

Private Sub Command1_Click()
  txtBody.Text = "Password = " & GeneratePassword(True) & vbCrLf & _
                 "Password = " & GeneratePassword(False)
End Sub
