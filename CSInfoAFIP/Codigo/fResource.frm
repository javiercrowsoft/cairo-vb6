VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form fResource 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.ImageList ilList 
      Left            =   3900
      Top             =   240
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   1
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fResource.frx":0000
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.Image ImgWiz5 
      Height          =   480
      Left            =   3240
      Picture         =   "fResource.frx":015A
      Top             =   2220
      Width           =   480
   End
   Begin VB.Image ImgWiz3 
      Height          =   735
      Left            =   3105
      Picture         =   "fResource.frx":5D6C
      Top             =   990
      Width           =   735
   End
   Begin VB.Image ImgWiz1 
      Height          =   4365
      Left            =   90
      Picture         =   "fResource.frx":63CC
      Top             =   45
      Width           =   2505
   End
End
Attribute VB_Name = "fResource"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

