VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form fRegistry 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "CSRegistryClean"
   ClientHeight    =   7890
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   11745
   Icon            =   "fRegistry.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7890
   ScaleWidth      =   11745
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.ListView lvKeys 
      Height          =   6555
      Left            =   180
      TabIndex        =   4
      Top             =   900
      Width           =   11355
      _ExtentX        =   20029
      _ExtentY        =   11562
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin VB.CommandButton cmdDelete 
      Caption         =   "Borrar"
      Height          =   435
      Left            =   7140
      TabIndex        =   3
      Top             =   120
      Width           =   1995
   End
   Begin VB.CommandButton cmdSearch 
      Caption         =   "Buscar"
      Height          =   435
      Left            =   4800
      TabIndex        =   2
      Top             =   120
      Width           =   1995
   End
   Begin VB.TextBox txSearch 
      Height          =   375
      Left            =   780
      TabIndex        =   1
      Top             =   120
      Width           =   3735
   End
   Begin VB.Label Label1 
      Caption         =   "Buscar"
      Height          =   495
      Left            =   180
      TabIndex        =   0
      Top             =   120
      Width           =   1095
   End
End
Attribute VB_Name = "fRegistry"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdDelete_Click()
  DeleteKeys lvKeys, Me
End Sub

Private Sub cmdSearch_Click()
  
  SearchInRegistryTypeLib txSearch.Text, lvKeys, Me
    
End Sub

Private Sub Form_Load()
  Set mReg = New cRegistry
  lvKeys.LabelEdit = lvwAutomatic
  lvKeys.View = lvwReport
  lvKeys.ColumnHeaders.Add , , "Clave"
  lvKeys.ColumnHeaders.Add , , "Descripcion"
  lvKeys.ColumnHeaders.Add , , "Path"
  lvKeys.ColumnHeaders.Add , , "Extra"
  lvKeys.ColumnHeaders.Add , , "Key"
End Sub

Private Sub lvKeys_ColumnClick(ByVal ColumnHeader As MSComctlLib.ColumnHeader)
  lvKeys.SortKey = ColumnHeader.Index - 1
  lvKeys.Sorted = True
  If lvKeys.SortOrder = lvwAscending Then
    lvKeys.SortOrder = lvwDescending
  Else
    lvKeys.SortOrder = lvwAscending
  End If
End Sub
