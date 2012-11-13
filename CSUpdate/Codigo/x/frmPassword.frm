VERSION 5.00
Begin VB.Form frmPassword 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Enter Password"
   ClientHeight    =   2505
   ClientLeft      =   4665
   ClientTop       =   4005
   ClientWidth     =   4410
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2505
   ScaleWidth      =   4410
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.Frame fraSep 
      Height          =   120
      Left            =   -840
      TabIndex        =   5
      Top             =   1920
      Width           =   5595
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   375
      Left            =   3300
      TabIndex        =   4
      Top             =   2100
      Width           =   1095
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   2160
      TabIndex        =   3
      Top             =   2100
      Width           =   1095
   End
   Begin VB.TextBox txtPassword 
      Height          =   315
      IMEMode         =   3  'DISABLE
      Left            =   660
      MaxLength       =   254
      PasswordChar    =   "*"
      TabIndex        =   0
      Top             =   300
      Width           =   3675
   End
   Begin VB.Image imgIcon 
      Height          =   480
      Left            =   60
      Picture         =   "frmPassword.frx":0000
      Top             =   60
      Width           =   480
   End
   Begin VB.Label lblInfo 
      Caption         =   $"frmPassword.frx":030A
      Height          =   795
      Left            =   660
      TabIndex        =   2
      Top             =   960
      Width           =   3675
   End
   Begin VB.Label lblPassword 
      Caption         =   "Password:"
      Height          =   255
      Left            =   660
      TabIndex        =   1
      Top             =   60
      Width           =   3615
   End
End
Attribute VB_Name = "frmPassword"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_sPassword As String
Private m_bCancel As Boolean

Public Property Get Password() As String
   Password = m_sPassword
End Property
Public Property Get Cancelled() As Boolean
   Cancelled = m_bCancel
End Property

Private Sub cmdCancel_Click()
   Unload Me
End Sub

Private Sub cmdOK_Click()
Dim sPwd As String
   sPwd = Trim$(txtPassword.Text)
   If Len(sPwd) > 0 Then
      m_sPassword = sPwd
      m_bCancel = False
      Unload Me
   Else
      MsgBox "Please enter a password.", vbInformation
      txtPassword.SetFocus
   End If
End Sub

Private Sub Form_Load()
   m_bCancel = True
   Me.Icon = imgIcon.Picture
End Sub
