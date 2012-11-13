VERSION 5.00
Begin VB.Form fFinish 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Instalación de CrowSoft Server"
   ClientHeight    =   3345
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5610
   Icon            =   "fFinish.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3345
   ScaleWidth      =   5610
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Aceptar"
      Default         =   -1  'True
      Height          =   375
      Left            =   1740
      TabIndex        =   3
      Top             =   2820
      Width           =   1935
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   6010
      Y1              =   2655
      Y2              =   2655
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   6010
      Y1              =   2640
      Y2              =   2640
   End
   Begin VB.Label Label3 
      Caption         =   $"fFinish.frx":000C
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   795
      Left            =   120
      TabIndex        =   2
      Top             =   1860
      Width           =   5355
   End
   Begin VB.Label Label2 
      Caption         =   "Importante:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   120
      TabIndex        =   1
      Top             =   1560
      Width           =   1275
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   -10
      X2              =   6000
      Y1              =   1340
      Y2              =   1340
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   -10
      X2              =   6000
      Y1              =   1320
      Y2              =   1320
   End
   Begin VB.Image Image1 
      Height          =   750
      Left            =   180
      Picture         =   "fFinish.frx":00AF
      Top             =   180
      Width           =   750
   End
   Begin VB.Label Label1 
      Caption         =   "La instalación de CrowSoft Cairo ha concluido con éxito. Ahora solo debe solicitar el código de liecencia a CrowSoft."
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   915
      Left            =   1320
      TabIndex        =   0
      Top             =   180
      Width           =   3795
   End
End
Attribute VB_Name = "fFinish"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdOk_Click()
  Unload Me
End Sub
