VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3645
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9150
   LinkTopic       =   "Form1"
   ScaleHeight     =   3645
   ScaleWidth      =   9150
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command5 
      Caption         =   "Copiar al portapapeles"
      Height          =   375
      Left            =   7080
      TabIndex        =   15
      Top             =   2580
      Width           =   1875
   End
   Begin VB.TextBox Text5 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Left            =   2460
      TabIndex        =   11
      Top             =   1920
      Width           =   2895
   End
   Begin VB.TextBox Text4 
      Height          =   315
      Left            =   1500
      TabIndex        =   10
      Text            =   "1/1/2056"
      Top             =   2640
      Width           =   795
   End
   Begin VB.TextBox Text3 
      Height          =   315
      Left            =   900
      TabIndex        =   8
      Text            =   "4"
      Top             =   2640
      Width           =   495
   End
   Begin VB.TextBox Text2 
      Height          =   315
      Left            =   60
      TabIndex        =   7
      Text            =   "1"
      Top             =   2640
      Width           =   435
   End
   Begin VB.CommandButton Command4 
      Caption         =   "Resolver Codigo"
      Height          =   375
      Left            =   5460
      TabIndex        =   5
      Top             =   3180
      Width           =   1455
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Get Activacion"
      Height          =   375
      Left            =   5460
      TabIndex        =   3
      Top             =   2580
      Width           =   1455
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Get Codigo"
      Height          =   375
      Left            =   60
      TabIndex        =   2
      Top             =   1920
      Width           =   1455
   End
   Begin VB.TextBox Text1 
      BackColor       =   &H8000000F&
      Enabled         =   0   'False
      Height          =   315
      Left            =   2460
      TabIndex        =   1
      Top             =   120
      Width           =   2895
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Get MacAdress"
      Height          =   375
      Left            =   5460
      TabIndex        =   0
      Top             =   120
      Width           =   1455
   End
   Begin VB.Label Label6 
      Caption         =   "Codigo"
      Height          =   255
      Left            =   1800
      TabIndex        =   14
      Top             =   1980
      Width           =   555
   End
   Begin VB.Label Label5 
      Caption         =   $"Form1.frx":0000
      Height          =   1035
      Left            =   60
      TabIndex        =   13
      Top             =   780
      Width           =   6975
   End
   Begin VB.Line Line1 
      BorderWidth     =   3
      X1              =   9180
      X2              =   0
      Y1              =   600
      Y2              =   600
   End
   Begin VB.Label Label1 
      Caption         =   "Solo para pruebas :"
      Height          =   255
      Left            =   960
      TabIndex        =   12
      Top             =   120
      Width           =   1455
   End
   Begin VB.Label Label4 
      Caption         =   "Empresas   Usuarios    Vto"
      Height          =   255
      Left            =   60
      TabIndex        =   9
      Top             =   2340
      Width           =   2115
   End
   Begin VB.Label Label3 
      BorderStyle     =   1  'Fixed Single
      Height          =   315
      Left            =   2460
      TabIndex        =   6
      Top             =   3240
      Width           =   2895
   End
   Begin VB.Label Label2 
      BackColor       =   &H00C0E0FF&
      BorderStyle     =   1  'Fixed Single
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   375
      Left            =   2460
      TabIndex        =   4
      Top             =   2580
      Width           =   2895
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
  Text1.Text = GetMACAddress(0)
End Sub

Private Sub Command2_Click()
  Text5.Text = GetMACAddressInText(Text1.Text)
End Sub

Private Sub Command3_Click()
  Label2.Caption = GetCodigo(Text5.Text, Text2.Text, Text3.Text, Text4.Text)
End Sub

Private Sub Command4_Click()
  Label3.Caption = "Emp= " & GetEmpresas(Label2.Caption) & " Us=" & GetUsuarios(Label2.Caption) & " Vto=" & GetVto(Label2.Caption)
End Sub

Private Sub Command5_Click()
  Clipboard.Clear
  Clipboard.SetText Label2.Caption
End Sub

Private Sub Form_Load()
  Left = (Screen.Width - Width) / 2
  Top = (Screen.Height - Height) / 2
End Sub
