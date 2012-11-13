VERSION 5.00
Object = "{600443F6-6F00-4B3F-BEB8-92D0CDADE10D}#4.0#0"; "csMaskEdit.ocx"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin CSMaskEdit.cMaskEdit cMaskEdit1 
      Height          =   435
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   420
      Width           =   1875
      _ExtentX        =   3307
      _ExtentY        =   767
      Text            =   "$ 0.00"
      Alignment       =   1
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
      csNotRaiseError =   -1  'True
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

