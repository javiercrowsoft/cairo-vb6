VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form fTask 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Configuración de Tarea de Backup"
   ClientHeight    =   4785
   ClientLeft      =   45
   ClientTop       =   345
   ClientWidth     =   7485
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4785
   ScaleWidth      =   7485
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdOpenFile 
      Caption         =   "..."
      Height          =   375
      Left            =   6840
      TabIndex        =   9
      Top             =   2160
      Width           =   375
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Aceptar"
      Default         =   -1  'True
      Height          =   315
      Left            =   3780
      TabIndex        =   8
      Top             =   4020
      Width           =   1575
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancelar"
      Height          =   315
      Left            =   5460
      TabIndex        =   7
      Top             =   4020
      Width           =   1575
   End
   Begin VB.TextBox txDescrip 
      Height          =   315
      Left            =   1800
      TabIndex        =   6
      Top             =   1680
      Width           =   4935
   End
   Begin VB.TextBox txFile 
      Height          =   315
      Left            =   1800
      TabIndex        =   5
      Top             =   2160
      Width           =   4935
   End
   Begin VB.TextBox txTitulo 
      Height          =   315
      Left            =   1800
      TabIndex        =   4
      Top             =   1200
      Width           =   4935
   End
   Begin MSComDlg.CommonDialog dlg 
      Left            =   600
      Top             =   2760
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   8000
      Y1              =   3840
      Y2              =   3840
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   8000
      Y1              =   3855
      Y2              =   3855
   End
   Begin VB.Label Label3 
      Caption         =   "Nombre del Archivo:"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   2280
      Width           =   1695
   End
   Begin VB.Label Label2 
      Caption         =   "Descripción:"
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   1800
      Width           =   1095
   End
   Begin VB.Label lbTitulo 
      Caption         =   "Titulo:"
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   1320
      Width           =   735
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Configuración de Tareas de Backup"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   1800
      TabIndex        =   0
      Top             =   120
      UseMnemonic     =   0   'False
      Width           =   4935
   End
   Begin VB.Image Image1 
      Height          =   720
      Left            =   360
      Picture         =   "fDef.frx":0000
      Top             =   120
      Width           =   720
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H00FFFFFF&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   975
      Left            =   0
      Top             =   0
      Width           =   7480
   End
End
Attribute VB_Name = "fTask"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdCancel_Click()
  Unload Me
End Sub

Private Sub cmdOpenFile_Click()

  With dlg
    .Filter = "Archivos de Backup de CrowSoft|*.cszip"
    .ShowOpen
    If .FileName <> vbNullString Then
      txFile.Text = .FileName
    End If
  End With
End Sub

Private Sub Form_Load()
  FormLoad Me, False
End Sub

Private Sub Form_Unload(Cancel As Integer)

  FormUnload Me, False

End Sub

