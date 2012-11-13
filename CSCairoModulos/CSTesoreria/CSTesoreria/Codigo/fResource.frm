VERSION 5.00
Object = "{E82A759A-7510-4F56-B239-9C0B78CF437B}#1.0#0"; "CSImageList.ocx"
Begin VB.Form fResource 
   Caption         =   "fResource"
   ClientHeight    =   4425
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5115
   LinkTopic       =   "Form1"
   ScaleHeight     =   4425
   ScaleWidth      =   5115
   StartUpPosition =   3  'Windows Default
   Begin CSImageList.cImageList iList 
      Left            =   3360
      Top             =   2280
      _ExtentX        =   953
      _ExtentY        =   953
      Size            =   940
      Images          =   "fResource.frx":0000
      KeyCount        =   1
      Keys            =   ""
   End
   Begin VB.Image ImgWiz1 
      Height          =   4365
      Left            =   0
      Picture         =   "fResource.frx":03CC
      Top             =   0
      Width           =   2505
   End
   Begin VB.Image ImgWiz3 
      Height          =   960
      Left            =   3015
      Picture         =   "fResource.frx":334D
      Top             =   945
      Width           =   1125
   End
End
Attribute VB_Name = "fResource"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

