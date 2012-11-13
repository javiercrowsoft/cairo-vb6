VERSION 5.00
Begin VB.Form frmAsistente 
   Caption         =   "Asistente de ABMs"
   ClientHeight    =   4905
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   5880
   BeginProperty Font 
      Name            =   "MS Sans Serif"
      Size            =   8.25
      Charset         =   0
      Weight          =   700
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   ScaleHeight     =   4905
   ScaleWidth      =   5880
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton CmdCopiar 
      Caption         =   "Copiar"
      Height          =   252
      Left            =   4680
      TabIndex        =   17
      Top             =   1080
      Width           =   975
   End
   Begin VB.TextBox txtPreConstante 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   288
      Left            =   4680
      TabIndex        =   15
      Text            =   "pol"
      Top             =   1560
      Width           =   972
   End
   Begin VB.TextBox txtPreTabla 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   288
      Left            =   1680
      TabIndex        =   13
      Text            =   "bco_"
      Top             =   1560
      Width           =   1092
   End
   Begin VB.CommandButton cmdGenerar 
      Caption         =   "Generar"
      Height          =   252
      Left            =   3600
      TabIndex        =   12
      Top             =   1080
      Width           =   975
   End
   Begin VB.ComboBox cbTablas 
      Height          =   288
      Left            =   960
      Style           =   2  'Dropdown List
      TabIndex        =   10
      Top             =   1080
      Width           =   2532
   End
   Begin VB.TextBox txtResultado 
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2532
      Left            =   120
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   8
      Top             =   2025
      Width           =   5652
   End
   Begin VB.CommandButton cmdLogin 
      Caption         =   "Login"
      Height          =   252
      Left            =   4920
      TabIndex        =   7
      Top             =   120
      Width           =   852
   End
   Begin VB.TextBox txtClave 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   288
      IMEMode         =   3  'DISABLE
      Left            =   3480
      PasswordChar    =   "*"
      TabIndex        =   6
      ToolTipText     =   "Ingrese su clave"
      Top             =   600
      Width           =   1332
   End
   Begin VB.TextBox txtUsuario 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   288
      Left            =   960
      TabIndex        =   5
      Text            =   "sa"
      Top             =   600
      Width           =   1332
   End
   Begin VB.TextBox txtBaseDatos 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   288
      Left            =   3480
      TabIndex        =   3
      Text            =   "Cairo"
      Top             =   120
      Width           =   1332
   End
   Begin VB.TextBox txtServidor 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   288
      Left            =   960
      TabIndex        =   1
      Text            =   "souyirozeta\msde"
      Top             =   120
      Width           =   1332
   End
   Begin VB.Label lbPreConstante 
      Caption         =   "Prefijo de Constante"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   372
      Left            =   3120
      TabIndex        =   16
      Top             =   1560
      Width           =   1452
   End
   Begin VB.Label lbPreTabla 
      Caption         =   "Prefijo de la Tabla"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Left            =   120
      TabIndex        =   14
      Top             =   1560
      Width           =   1332
   End
   Begin VB.Line Line1 
      X1              =   120
      X2              =   5760
      Y1              =   960
      Y2              =   960
   End
   Begin VB.Label lbClave 
      Caption         =   "Clave"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Left            =   2400
      TabIndex        =   11
      Top             =   600
      Width           =   612
   End
   Begin VB.Label lbTabla 
      Caption         =   "Tabla"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Left            =   120
      TabIndex        =   9
      Top             =   1080
      Width           =   612
   End
   Begin VB.Label lbUsuario 
      Caption         =   "Usuario"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Left            =   120
      TabIndex        =   4
      Top             =   600
      Width           =   732
   End
   Begin VB.Label lbDataBase 
      Caption         =   "Base de Datos"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   372
      Left            =   2400
      TabIndex        =   2
      Top             =   120
      Width           =   852
   End
   Begin VB.Label lbServidor 
      Caption         =   "Servidor"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   732
   End
End
Attribute VB_Name = "frmAsistente"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CmdCopiar_Click()
    Clipboard.Clear
    Clipboard.SetText txtResultado.Text
End Sub

Private Sub cmdGenerar_Click()
    Generar
End Sub

Private Sub cmdLogin_Click()
    Conectar
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  txtResultado.Move 120, 2040, Me.ScaleWidth - txtResultado.Left * 2, Me.ScaleHeight - txtResultado.Top - 60
End Sub
