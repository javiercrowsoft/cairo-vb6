VERSION 5.00
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.0#0"; "CSMaskEdit2.ocx"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   6975
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5220
   LinkTopic       =   "Form1"
   ScaleHeight     =   6975
   ScaleWidth      =   5220
   StartUpPosition =   3  'Windows Default
   Begin CSMaskEdit2.cMultiLine cMultiLine1 
      Height          =   330
      Left            =   1620
      TabIndex        =   6
      Top             =   3330
      Width           =   1995
      _ExtentX        =   3519
      _ExtentY        =   582
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      MultiLine       =   -1  'True
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
   End
   Begin VB.PictureBox cMaskEdit5 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1695
      Left            =   240
      ScaleHeight     =   1635
      ScaleWidth      =   4275
      TabIndex        =   5
      Top             =   4980
      Width           =   4335
   End
   Begin VB.TextBox Text1 
      Height          =   375
      Left            =   300
      TabIndex        =   1
      Text            =   "Text1"
      Top             =   1500
      Width           =   3375
   End
   Begin VB.PictureBox cMaskEdit1 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   300
      ScaleHeight     =   315
      ScaleWidth      =   3315
      TabIndex        =   0
      Top             =   600
      Width           =   3375
   End
   Begin VB.PictureBox cMaskEdit2 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   300
      ScaleHeight     =   315
      ScaleWidth      =   3315
      TabIndex        =   2
      Top             =   2280
      Width           =   3375
   End
   Begin VB.PictureBox cMaskEdit3 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   300
      ScaleHeight     =   315
      ScaleWidth      =   3315
      TabIndex        =   3
      Top             =   3240
      Width           =   3375
   End
   Begin VB.PictureBox cMaskEdit4 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   300
      ScaleHeight     =   315
      ScaleWidth      =   3315
      TabIndex        =   4
      Top             =   4140
      Width           =   3375
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Click()
'  Me.BackColor = vbButtonShadow
'  cMaskEdit3.Enabled = Not cMaskEdit3.Enabled
'  cMaskEdit4.Enabled = Not cMaskEdit4.Enabled
'  cMaskEdit4.EnabledNoChngBkColor = True
'        cMaskEdit4.BackColor = vbButtonShadow
'        cMaskEdit4.BorderColor = vbButtonFace
'
'  cMaskEdit5.Enabled = Not cMaskEdit5.Enabled

'  cMaskEdit3.NoFormat = True
'  cMaskEdit3.Text = "0,"
'  cMaskEdit3.SelStart = 2
'  cMaskEdit3.SetFocus
'  cMaskEdit3.Edit
'  DoEvents
'  cMaskEdit3.NoFormat = False
  
  cMaskEdit4.Text = "1/1/1900"
  MsgBox cMaskEdit4.Text
  MsgBox cMaskEdit4.csValue
  MsgBox cMaskEdit4.csDateName

  cMaskEdit4.csValue = "1/1/1900"
  MsgBox cMaskEdit4.Text
  MsgBox cMaskEdit4.csValue
  MsgBox cMaskEdit4.csDateName
End Sub

