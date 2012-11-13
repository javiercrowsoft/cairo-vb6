VERSION 5.00
Begin VB.MDIForm FrmMain 
   BackColor       =   &H8000000C&
   Caption         =   "Scriptor"
   ClientHeight    =   6990
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   7950
   Icon            =   "FrmMain.frx":0000
   LinkTopic       =   "MDIForm1"
   StartUpPosition =   3  'Windows Default
   Begin VB.Menu mnuArchivo 
      Caption         =   "&Archivo"
      Begin VB.Menu mnuSalir 
         Caption         =   "Salir"
      End
   End
   Begin VB.Menu mnuMaquinas 
      Caption         =   "Scriptor"
      Begin VB.Menu mnuMaqUbic 
         Caption         =   "Generar script"
      End
   End
End
Attribute VB_Name = "FrmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub mnuMaqUbic_Click()
'    FrmInforme.Show
  FrmScriptor.Show
End Sub

Private Sub mnuSalir_Click()
    Unload Me
    CloseApp
End Sub
