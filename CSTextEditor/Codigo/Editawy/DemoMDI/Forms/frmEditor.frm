VERSION 5.00
Object = "{9AA2B010-29D7-4BAF-829F-4BF3233B3E66}#49.0#0"; "Editawy.ocx"
Begin VB.Form frmEditor 
   Appearance      =   0  'Flat
   BackColor       =   &H80000005&
   BorderStyle     =   0  'None
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin EditawyX.Editawy Editawy1 
      Left            =   1320
      Top             =   840
      _ExtentX        =   847
      _ExtentY        =   847
      SymbolMargin    =   0   'False
      Folding         =   0   'False
      BeginProperty DefaultFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   178
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      CaretLineVisible=   0   'False
      TabWidth        =   0
      EdgeColumn      =   120
      EdgeColor       =   0
   End
End
Attribute VB_Name = "frmEditor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

