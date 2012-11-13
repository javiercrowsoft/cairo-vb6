VERSION 5.00
Object = "{AB350268-0AA3-445C-8F38-C22EB727290F}#1.0#0"; "CSHelp2.ocx"
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Begin VB.Form fEditSerieH 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Editar Número de Serie Anterior"
   ClientHeight    =   3090
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   6600
   Icon            =   "fEditSerieH.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3090
   ScaleWidth      =   6600
   StartUpPosition =   3  'Windows Default
   Begin CSHelp2.cHelp cHelpSerie 
      Height          =   315
      Left            =   1920
      TabIndex        =   0
      Top             =   1620
      Width           =   3555
      _ExtentX        =   6271
      _ExtentY        =   556
      BorderColor     =   12164479
      BorderType      =   1
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
   End
   Begin CSButton.cButtonLigth cmdCancel 
      Height          =   330
      Left            =   180
      TabIndex        =   3
      Top             =   2595
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   582
      Caption         =   "&Cancelar"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
   End
   Begin CSButton.cButtonLigth cmdOk 
      Default         =   -1  'True
      Height          =   330
      Left            =   3615
      TabIndex        =   1
      Top             =   2595
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   582
      Caption         =   "&Aceptar"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
   End
   Begin CSButton.cButtonLigth cmdSkip 
      Cancel          =   -1  'True
      Height          =   330
      Left            =   4980
      TabIndex        =   2
      Top             =   2595
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   582
      Caption         =   "&Omitir"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H00FFC0C0&
      Height          =   375
      Left            =   1920
      Top             =   1020
      Width           =   3555
   End
   Begin VB.Image Image1 
      Height          =   630
      Left            =   90
      Picture         =   "fEditSerieH.frx":08CA
      Top             =   90
      Width           =   555
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   -1500
      X2              =   6750
      Y1              =   2460
      Y2              =   2460
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   -1500
      X2              =   6735
      Y1              =   2475
      Y2              =   2475
   End
   Begin VB.Label Label3 
      Caption         =   "Número anterior"
      Height          =   315
      Left            =   660
      TabIndex        =   6
      Top             =   1680
      Width           =   1215
   End
   Begin VB.Label lbSerie 
      Alignment       =   2  'Center
      BackColor       =   &H00FFFFFF&
      Caption         =   "30550"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   1920
      TabIndex        =   5
      Top             =   1020
      Width           =   3555
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Indique el numero de serie anterior para este numero de serie:"
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
      Left            =   840
      TabIndex        =   4
      Top             =   360
      Width           =   6255
   End
   Begin VB.Shape Shape3 
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   870
      Left            =   0
      Top             =   0
      Width           =   8655
   End
End
Attribute VB_Name = "fEditSerieH"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'--------------------------------------------------------------------------------
' fEdit
' 23-04-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' Funciones

'--------------------------------------------------------------------------------

' constantes
' estructuras
' variables privadas
Private m_bOk         As Boolean
Private m_bCancel     As Boolean
Private m_PrnsId      As Long

' eventos

' Properties publicas
Public Property Get Ok() As Boolean
  Ok = m_bOk
End Property

Public Property Get Cancel() As Boolean
  Cancel = m_bCancel
End Property

Public Property Get PrnsId() As Long
  PrnsId = m_PrnsId
End Property

Public Property Let PrnsId(ByVal rhs As Long)
  m_PrnsId = rhs
End Property
' Properties privadas
' Funciones publicas

Public Function ShowForm(ByVal NroSerie As String)
  lbSerie.Caption = NroSerie
  cHelpSerie.text = vbNullString
  cHelpSerie.Id = csNO_ID
  cHelpSerie.table = csProductoSerie
  m_bOk = False
  m_bCancel = False
  Me.Show vbModal
End Function

' Funciones privadas
Private Sub cmdOk_Click()
  On Error Resume Next
  m_bOk = True
  Me.Hide
End Sub

Private Sub cmdCancel_Click()
  On Error Resume Next
  m_bCancel = True
  Me.Hide
End Sub

Private Sub cmdSkip_Click()
  On Error Resume Next
  m_bOk = False
  Me.Hide
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error Resume Next
  Dim win As cWindow
  Set win = New cWindow
  win.CenterForm Me
End Sub
