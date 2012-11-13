VERSION 5.00
Begin VB.Form fMain 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Importar Afip"
   ClientHeight    =   3705
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   6105
   Icon            =   "fMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3705
   ScaleWidth      =   6105
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txFile 
      Height          =   375
      Left            =   120
      TabIndex        =   7
      Text            =   "\\server1\CrowSoft\Implementacion\Afip\afip-inscripcion.txt"
      Top             =   540
      Width           =   5835
   End
   Begin VB.CommandButton cmdProcesar 
      Caption         =   "Procesar"
      Height          =   435
      Left            =   1200
      TabIndex        =   3
      Top             =   3000
      Width           =   2115
   End
   Begin VB.CommandButton cmdCancelar 
      Caption         =   "Cancelar"
      Height          =   435
      Left            =   3480
      TabIndex        =   2
      Top             =   3000
      Width           =   2115
   End
   Begin VB.Line Line2 
      BorderColor     =   &H8000000C&
      X1              =   -60
      X2              =   7020
      Y1              =   2820
      Y2              =   2820
   End
   Begin VB.Line Line1 
      BorderColor     =   &H8000000C&
      X1              =   -60
      X2              =   7020
      Y1              =   1080
      Y2              =   1080
   End
   Begin VB.Label Label3 
      Caption         =   "Archivo descargado de la pagina web de afip"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   120
      TabIndex        =   6
      Top             =   180
      Width           =   3975
   End
   Begin VB.Label lbRecords 
      Alignment       =   1  'Right Justify
      BorderStyle     =   1  'Fixed Single
      Caption         =   "0"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   2280
      TabIndex        =   5
      Top             =   1980
      Width           =   2415
   End
   Begin VB.Label Label2 
      Caption         =   "Registros"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   1260
      TabIndex        =   4
      Top             =   1980
      Width           =   915
   End
   Begin VB.Label lbProgreso 
      Alignment       =   1  'Right Justify
      BorderStyle     =   1  'Fixed Single
      Caption         =   "0"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   18
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   555
      Left            =   2280
      TabIndex        =   1
      Top             =   1320
      Width           =   2415
   End
   Begin VB.Label Label1 
      Caption         =   "Progreso"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   1260
      TabIndex        =   0
      Top             =   1260
      Width           =   915
   End
End
Attribute VB_Name = "fMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdCancelar_Click()

  If MsgBox("Confirma que cancela", vbQuestion + vbYesNo) = vbYes Then

    gCancel = True
    
  End If
  
End Sub

Private Sub cmdProcesar_Click()
  On Error GoTo ControlError
  
  cmdProcesar.Enabled = False
  
  ' Reparar el archivo
  '
  Dim Import As cAfipImport
  
  Set Import = New cAfipImport
  
  gCancel = False
  
  Import.RepairFile fMain.txFile.Text

  cmdProcesar.Enabled = True

  GoTo ExitProc
ControlError:
  MsgBox Err.Description
ExitProc:
  cmdProcesar.Enabled = True
End Sub

