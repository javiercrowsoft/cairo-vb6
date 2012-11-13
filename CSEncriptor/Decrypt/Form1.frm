VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Decrypt"
   ClientHeight    =   7155
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10455
   LinkTopic       =   "Form1"
   ScaleHeight     =   7155
   ScaleWidth      =   10455
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox Text2 
      Height          =   5415
      Left            =   120
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   2
      Top             =   1680
      Width           =   10290
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Decrypt"
      Height          =   375
      Left            =   180
      TabIndex        =   1
      Top             =   1260
      Width           =   1755
   End
   Begin VB.TextBox Text1 
      Height          =   1095
      Left            =   120
      MultiLine       =   -1  'True
      TabIndex        =   0
      Top             =   60
      Width           =   10290
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
  Dim e As cEncrypt
  Set e = New cEncrypt
  
  Dim i As Long
  Dim v As Variant
  
  Text2.Text = vbNullString
  v = Split(Text1.Text, vbCrLf)
  
  For i = 0 To UBound(v)
    Text2.SelStart = Len(Text2.Text)
    Text2.SelText = e.Decript(v(i), "Virginia Said-Neron-Catalina-la belleza") & vbCrLf
  Next
End Sub
