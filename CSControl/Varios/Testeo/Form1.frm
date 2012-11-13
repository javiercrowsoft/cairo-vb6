VERSION 5.00
Object = "{EB085854-3FFC-11D4-9DB2-A39AC4721A49}#6.0#0"; "csControls.ocx"
Begin VB.Form Form1 
   BackColor       =   &H80000013&
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox Text1 
      Height          =   405
      Left            =   480
      TabIndex        =   2
      Text            =   "Text1"
      Top             =   600
      Width           =   2655
   End
   Begin csControls.cHelp cHelp1 
      Height          =   255
      Left            =   480
      TabIndex        =   1
      ToolTipText     =   "popo"
      Top             =   240
      Width           =   2655
      _ExtentX        =   4683
      _ExtentY        =   450
      ButtonColor     =   12632064
      BorderColor     =   8454143
      BackColor       =   12632319
      BorderType      =   1
      ForeColorIn     =   8421631
      ForeColorOut    =   32768
      ErrorColor      =   65535
      BackColor       =   12632319
      Tabla           =   2
      ColumnaValorProceso=   "rererer"
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   375
      Left            =   360
      TabIndex        =   0
      Top             =   1560
      Width           =   2055
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

