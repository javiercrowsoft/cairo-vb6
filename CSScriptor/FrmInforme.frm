VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form FrmInforme 
   Caption         =   "Ubicación"
   ClientHeight    =   6165
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6900
   Icon            =   "FrmInforme.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   6165
   ScaleWidth      =   6900
   WindowState     =   2  'Maximized
   Begin MSComctlLib.ImageList ImageList1 
      Left            =   4905
      Top             =   3690
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   2
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "FrmInforme.frx":08CA
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "FrmInforme.frx":11A4
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ListView ListView1 
      Height          =   6135
      Left            =   2520
      TabIndex        =   1
      Top             =   0
      Width           =   4335
      _ExtentX        =   7646
      _ExtentY        =   10821
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin MSComctlLib.TreeView TreeView1 
      Height          =   6135
      Left            =   45
      TabIndex        =   0
      Top             =   0
      Width           =   2445
      _ExtentX        =   4313
      _ExtentY        =   10821
      _Version        =   393217
      Indentation     =   265
      LineStyle       =   1
      Style           =   7
      ImageList       =   "ImageList1"
      Appearance      =   1
   End
End
Attribute VB_Name = "FrmInforme"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    On Error GoTo ControlError
    
    Dim sqlstmt     As String
    
    Dim Componentes As Recordset
    Dim Sectores    As Recordset
    
    sqlstmt = "select ID_Tipo_HW, Descripcion_Tipo_HW from [Base de Datos - Tipos de Hardware]"
    If Not gDb.OpenRs(sqlstmt, Componentes) Then GoTo ExitProc
    sqlstmt = "select Sector_Personal from [Personal DirecTV] group by Sector_Personal"
    If Not gDb.OpenRs(sqlstmt, Sectores) Then GoTo ExitProc
    
    ArbolCargar TreeView1, Sectores, Componentes
    
    GoTo ExitProc
ControlError:
    MngError Err, "Form_Load", "FrmInforme", ""
ExitProc:
End Sub

Private Sub Form_Resize()
    TreeView1.Width = ScaleWidth / 3
    TreeView1.Height = ScaleHeight
    
    ListView1.Left = TreeView1.Width
    ListView1.Width = ScaleWidth - TreeView1.Width
    ListView1.Height = ScaleHeight
End Sub
