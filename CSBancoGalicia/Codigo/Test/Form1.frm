VERSION 5.00
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
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Click()
  Dim congreso As CSAAARBA.cCongreso2005
  Set congreso = New cCongreso2005
  
  congreso.AddInscripcion2 17, 999
  congreso.ReconocerDeudaEnSag "D:\Proyectos\CSHtml\AAARBA", "file name=C:\CrowSoftWeb2.UDL"
End Sub
