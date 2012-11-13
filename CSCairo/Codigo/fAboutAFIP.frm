VERSION 5.00
Object = "{57EC5E1A-9098-47A9-A8E3-EF352F97282B}#2.1#0"; "CSButton.ocx"
Begin VB.Form fAbout 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   ClientHeight    =   2865
   ClientLeft      =   45
   ClientTop       =   45
   ClientWidth     =   8370
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Picture         =   "fAboutAFIP.frx":0000
   ScaleHeight     =   2865
   ScaleWidth      =   8370
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin CSButton.cButtonLigth cmdClose 
      Cancel          =   -1  'True
      Default         =   -1  'True
      Height          =   315
      Left            =   5820
      TabIndex        =   0
      Top             =   2220
      Width           =   1035
      _ExtentX        =   1826
      _ExtentY        =   556
      Caption         =   "&Cerrar"
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
      BackColor       =   16777215
      BackColorPressed=   16777215
      BackColorUnpressed=   16777215
   End
   Begin VB.Shape Shape1 
      Height          =   615
      Left            =   720
      Top             =   1920
      Width           =   3975
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Venados S.A."
      Height          =   255
      Left            =   900
      TabIndex        =   2
      Top             =   1980
      Width           =   3375
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Se autoriza el uso de este programa a:"
      Height          =   255
      Left            =   720
      TabIndex        =   1
      Top             =   1680
      Width           =   3375
   End
End
Attribute VB_Name = "fAbout"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdClose_Click()
  Unload Me
End Sub

Private Sub Form_Activate()
  ActiveBar Me
End Sub

Private Sub Form_Deactivate()
  DeactiveBar Me
End Sub

Private Sub Form_Load()
    CSKernelClient.CenterForm Me, fMain
End Sub

Private Sub Form_Unload(Cancel As Integer)
  DeactiveBar Me
End Sub
