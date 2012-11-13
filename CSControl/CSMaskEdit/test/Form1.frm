VERSION 5.00
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.1#0"; "CSMaskEdit2.ocx"
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
   Begin CSMaskEdit2.cMaskEdit cMaskEdit1 
      Height          =   375
      Left            =   300
      TabIndex        =   1
      Top             =   360
      Width           =   2895
      _ExtentX        =   5106
      _ExtentY        =   661
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
      ForeColor       =   0
      EnabledNoChngBkColor=   0   'False
      Text            =   "01-01-1900"
      csType          =   6
      BorderColor     =   12164479
      csNotRaiseError =   -1  'True
   End
   Begin VB.TextBox Text1 
      Height          =   420
      Left            =   270
      TabIndex        =   0
      Text            =   "Text1"
      Top             =   1260
      Width           =   3165
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

