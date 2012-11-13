VERSION 5.00
Begin VB.Form fOverwrite 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "File Exists"
   ClientHeight    =   1755
   ClientLeft      =   3855
   ClientTop       =   2715
   ClientWidth     =   4695
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "fOverwrite.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1755
   ScaleWidth      =   4695
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CheckBox chkAllFiles 
      Caption         =   "&Apply to All Files"
      Height          =   255
      Left            =   1260
      TabIndex        =   3
      Top             =   1500
      Width           =   4695
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   315
      Left            =   3540
      TabIndex        =   2
      Top             =   1140
      Width           =   1095
   End
   Begin VB.CommandButton cmdNo 
      Caption         =   "&No"
      Default         =   -1  'True
      Height          =   315
      Left            =   2400
      TabIndex        =   1
      Top             =   1140
      Width           =   1095
   End
   Begin VB.CommandButton cmdYes 
      Caption         =   "&Yes"
      Height          =   315
      Left            =   1260
      TabIndex        =   0
      Top             =   1140
      Width           =   1095
   End
   Begin VB.Image Image1 
      Height          =   570
      Left            =   150
      Picture         =   "fOverwrite.frx":014A
      Top             =   150
      Width           =   615
   End
   Begin VB.Label lblCaption 
      Caption         =   "x"
      Height          =   795
      Left            =   735
      TabIndex        =   4
      Top             =   240
      Width           =   3915
   End
End
Attribute VB_Name = "fOverwrite"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_eResponse As VbMsgBoxResult
Private m_bAll As Boolean
Private m_sCaption As String

Public Property Let TheCaption(ByRef sCaption As String)
   m_sCaption = sCaption
End Property

Public Property Get Response() As VbMsgBoxResult
   Response = m_eResponse
End Property
Public Property Get ApplyToAll() As Boolean
   ApplyToAll = m_bAll
End Property

Private Sub cmdCancel_Click()
   m_bAll = True
   Unload Me
End Sub

Private Sub cmdNo_Click()
   m_eResponse = vbNo
   m_bAll = (chkAllFiles.Value = Checked)
   Unload Me
End Sub

Private Sub cmdYes_Click()
   m_eResponse = vbYes
   m_bAll = (chkAllFiles.Value = Checked)
   Unload Me
End Sub

Private Sub Form_Load()
   m_eResponse = vbCancel
   lblCaption.Caption = m_sCaption
End Sub
