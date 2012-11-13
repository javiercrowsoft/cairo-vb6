VERSION 5.00
Begin VB.Form fToken 
   Caption         =   "Token"
   ClientHeight    =   3660
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   3660
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txName 
      Height          =   315
      Left            =   1380
      TabIndex        =   1
      Top             =   300
      Width           =   2775
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Aceptar"
      Default         =   -1  'True
      Height          =   315
      Left            =   1200
      TabIndex        =   12
      Top             =   3240
      Width           =   1575
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancelar"
      Height          =   315
      Left            =   2880
      TabIndex        =   13
      Top             =   3240
      Width           =   1575
   End
   Begin VB.TextBox txRunBetween 
      Height          =   315
      Left            =   1380
      TabIndex        =   11
      Top             =   2400
      Width           =   2775
   End
   Begin VB.TextBox txRunAt 
      Height          =   315
      Left            =   1380
      TabIndex        =   9
      Top             =   1980
      Width           =   2775
   End
   Begin VB.TextBox txTagEnd 
      Height          =   315
      Left            =   1380
      TabIndex        =   7
      Top             =   1560
      Width           =   2775
   End
   Begin VB.TextBox txTag 
      Height          =   315
      Left            =   1380
      TabIndex        =   5
      Top             =   1140
      Width           =   2775
   End
   Begin VB.TextBox txUrl 
      Height          =   315
      Left            =   1380
      TabIndex        =   3
      Top             =   720
      Width           =   2775
   End
   Begin VB.Label Label6 
      Caption         =   "&Nombre:"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   360
      Width           =   675
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   -2340
      X2              =   4680
      Y1              =   3060
      Y2              =   3060
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   -2340
      X2              =   4680
      Y1              =   3075
      Y2              =   3075
   End
   Begin VB.Label Label5 
      Caption         =   "Run &Between:"
      Height          =   255
      Left            =   120
      TabIndex        =   10
      Top             =   2460
      Width           =   1095
   End
   Begin VB.Label Label4 
      Caption         =   "&Run At:"
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   2040
      Width           =   795
   End
   Begin VB.Label Label3 
      Caption         =   "Tag &End:"
      Height          =   255
      Left            =   120
      TabIndex        =   6
      Top             =   1620
      Width           =   795
   End
   Begin VB.Label Label2 
      Caption         =   "&Tag:"
      Height          =   255
      Left            =   120
      TabIndex        =   4
      Top             =   1200
      Width           =   675
   End
   Begin VB.Label Label1 
      Caption         =   "&URL:"
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   780
      Width           =   675
   End
End
Attribute VB_Name = "fToken"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_Ok  As Boolean

Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property

Private Sub cmdCancel_Click()
  Unload Me
End Sub

Private Sub cmdOk_Click()
  m_Ok = True
  Me.Hide
  
End Sub

Private Sub Form_Load()
  m_Ok = False
End Sub
