VERSION 5.00
Object = "{EBA71138-C194-4F8F-8A43-4781BBB517F8}#1.0#0"; "CSTree2.ocx"
Begin VB.Form fEditPrecio 
   Caption         =   "Editar Precios"
   ClientHeight    =   5880
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7005
   Icon            =   "fEditPrecio.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5880
   ScaleWidth      =   7005
   StartUpPosition =   3  'Windows Default
   Begin CSTree2.cTreeCtrl treePrecios 
      Height          =   4935
      Left            =   240
      TabIndex        =   0
      Top             =   300
      Width           =   6015
      _ExtentX        =   10610
      _ExtentY        =   8705
   End
End
Attribute VB_Name = "fEditPrecio"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public Event MenuClick(ByVal MenuId As Long)

Private Sub Form_Load()
  On Error Resume Next
  CSKernelClient2.LoadForm Me, "EditPrecio"
  Me.BackColor = vbWhite
  treePrecios.Left = 10
  treePrecios.Top = 10
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  treePrecios.Width = ScaleWidth - 20
  treePrecios.Height = ScaleHeight - 20
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  CSKernelClient2.UnloadForm Me, "EditPrecio"
End Sub

Private Sub treePrecios_MenuClick(ByVal MenuId As Long)
  On Error Resume Next
  RaiseEvent MenuClick(MenuId)
End Sub

