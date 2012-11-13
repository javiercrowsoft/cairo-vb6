VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   7980
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   8160
   LinkTopic       =   "Form1"
   ScaleHeight     =   7980
   ScaleWidth      =   8160
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command1 
      Caption         =   "Compilar"
      Height          =   315
      Left            =   6780
      TabIndex        =   2
      Top             =   7500
      Width           =   1215
   End
   Begin VB.TextBox Text2 
      Height          =   3555
      Left            =   180
      MultiLine       =   -1  'True
      TabIndex        =   1
      Top             =   3840
      Width           =   7815
   End
   Begin VB.TextBox Text1 
      Height          =   3555
      Left            =   180
      MultiLine       =   -1  'True
      TabIndex        =   0
      Top             =   180
      Width           =   7815
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
  Dim c As cCode
  Set c = New cCode
  
  c.Compile Text1.Text, ""
  
  Text2.Text = c.CodeC
End Sub

Private Sub Form_Load()
  Dim s As String
  
  s = "function x()" & vbCrLf & _
     "  x = x+1" & vbCrLf & _
     "  x = x + _sum(1)" & vbCrLf & _
     "  x = x + _sum(_min(1),1)" & vbCrLf & _
     "  x = x + _sum(1,_min(1))" & vbCrLf & _
     "  x = x + _sum(1,_min(1),1)" & vbCrLf & _
     "  x = x + _sum(1,_min(1),1,_min(1))" & vbCrLf & _
     "end function"
  
  Text1.Text = s
End Sub

