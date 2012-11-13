VERSION 5.00
Object = "{57EC5E1A-9098-47A9-A8E3-EF352F97282B}#3.0#0"; "CSButton.ocx"
Begin VB.Form fAsk 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Update Package Manager"
   ClientHeight    =   2145
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6870
   Icon            =   "fAsk.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2145
   ScaleWidth      =   6870
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin CSButton.cButtonLigth cmdYes 
      Height          =   330
      Left            =   1260
      TabIndex        =   0
      Top             =   1710
      Width           =   1365
      _ExtentX        =   2408
      _ExtentY        =   582
      Caption         =   "&Si"
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
      ForeColor       =   0
   End
   Begin CSButton.cButtonLigth cmdNo 
      Height          =   330
      Left            =   2700
      TabIndex        =   1
      Top             =   1710
      Width           =   1365
      _ExtentX        =   2408
      _ExtentY        =   582
      Caption         =   "&No"
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
      ForeColor       =   0
   End
   Begin CSButton.cButtonLigth cmdIgnore 
      Height          =   330
      Left            =   4140
      TabIndex        =   2
      Top             =   1710
      Width           =   1365
      _ExtentX        =   2408
      _ExtentY        =   582
      Caption         =   "&Ignorar"
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
      ForeColor       =   0
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   315
      Picture         =   "fAsk.frx":038A
      Top             =   405
      Width           =   480
   End
   Begin VB.Label lbQuestion 
      Caption         =   "Label1"
      Height          =   1140
      Left            =   1170
      TabIndex        =   3
      Top             =   315
      Width           =   5505
   End
End
Attribute VB_Name = "fAsk"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_answer As Integer

Public Property Get Answer() As Integer
  Answer = m_answer
End Property

Private Sub cmdIgnore_Click()
  m_answer = vbIgnore
  Me.Hide
End Sub

Private Sub cmdNo_Click()
  m_answer = vbNo
  Me.Hide
End Sub

Private Sub cmdYes_Click()
  m_answer = vbYes
  Me.Hide
End Sub

Private Sub Form_Load()
  CSKernelClient2.CenterForm Me
End Sub
