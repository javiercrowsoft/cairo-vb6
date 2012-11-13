VERSION 5.00
Begin VB.Form fAbout 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "About MyApp"
   ClientHeight    =   3285
   ClientLeft      =   2340
   ClientTop       =   1935
   ClientWidth     =   6750
   ClipControls    =   0   'False
   Icon            =   "fAbout.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2267.365
   ScaleMode       =   0  'User
   ScaleWidth      =   6338.599
   ShowInTaskbar   =   0   'False
   Begin VB.PictureBox picIcon 
      AutoSize        =   -1  'True
      BorderStyle     =   0  'None
      ClipControls    =   0   'False
      Height          =   1110
      Left            =   120
      Picture         =   "fAbout.frx":1042
      ScaleHeight     =   779.59
      ScaleMode       =   0  'User
      ScaleWidth      =   1495.97
      TabIndex        =   1
      Top             =   120
      Width           =   2130
   End
   Begin VB.CommandButton cmdOk 
      Cancel          =   -1  'True
      Caption         =   "&Aceptar"
      Default         =   -1  'True
      Height          =   345
      Left            =   5385
      TabIndex        =   0
      Top             =   2265
      Width           =   1260
   End
   Begin VB.Line Line1 
      BorderColor     =   &H00808080&
      BorderStyle     =   6  'Inside Solid
      Index           =   1
      X1              =   84.515
      X2              =   6199.619
      Y1              =   1439.104
      Y2              =   1439.104
   End
   Begin VB.Label lblDescription 
      BackStyle       =   0  'Transparent
      Caption         =   "App Description"
      ForeColor       =   &H00000000&
      Height          =   570
      Left            =   120
      TabIndex        =   2
      Top             =   1380
      Width           =   6405
   End
   Begin VB.Line Line1 
      BorderColor     =   &H00E0E0E0&
      BorderWidth     =   2
      Index           =   0
      X1              =   98.6
      X2              =   6199.619
      Y1              =   1449.457
      Y2              =   1449.457
   End
   Begin VB.Label lblVersion 
      BackStyle       =   0  'Transparent
      Caption         =   "Version"
      Height          =   225
      Left            =   2610
      TabIndex        =   4
      Top             =   780
      Width           =   3945
   End
   Begin VB.Label lblDisclaimer 
      BackStyle       =   0  'Transparent
      ForeColor       =   &H00000000&
      Height          =   825
      Left            =   255
      TabIndex        =   3
      Top             =   2265
      Width           =   5010
   End
   Begin VB.Image Image1 
      Height          =   465
      Left            =   2580
      Picture         =   "fAbout.frx":1F14
      Top             =   240
      Width           =   3930
   End
End
Attribute VB_Name = "fAbout"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdOk_Click()
  Unload Me
End Sub

Private Sub Form_Load()
    Me.Caption = "Acerca de " & App.Title
    lblVersion.Caption = "Version " & App.Major & "." & App.Minor & "." & App.Revision
    lblDisclaimer.Caption = "Advertencia: Este programa esta protegido por las leyes de CopyRight y tratados internacionales. " & _
                            "La reproducción, copia o distribución no autorizada de este programa o parte de él, puede llevar a " & _
                            "realizar acciones civiles y/o penales en su contra."
    lblDescription.Caption = "Esta aplicación permite configurar las tareas de Backup " & _
                             "y recuperar archivos de resguardo CrowSoft (*.cszip)."
End Sub

