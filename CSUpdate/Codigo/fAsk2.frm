VERSION 5.00
Begin VB.Form fAsk2 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Update Package Manager"
   ClientHeight    =   2145
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6870
   Icon            =   "fAsk2.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2145
   ScaleWidth      =   6870
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdYes 
      Caption         =   "&Yes"
      Height          =   315
      Left            =   1260
      TabIndex        =   5
      Top             =   1665
      Width           =   1365
   End
   Begin VB.CommandButton cmdNo 
      Caption         =   "&No"
      Height          =   315
      Left            =   2715
      TabIndex        =   4
      Top             =   1665
      Width           =   1365
   End
   Begin VB.CommandButton cmdIgnore 
      Cancel          =   -1  'True
      Caption         =   "&Ignorar"
      Height          =   315
      Left            =   4170
      TabIndex        =   3
      Top             =   1665
      Width           =   1365
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   315
      Picture         =   "fAsk2.frx":038A
      Top             =   405
      Width           =   480
   End
   Begin VB.Label lbQuestion 
      Caption         =   "Label1"
      Height          =   1140
      Left            =   1170
      TabIndex        =   0
      Top             =   315
      Width           =   5505
   End
End
Attribute VB_Name = "fAsk2"
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
  CenterForm Me
End Sub
