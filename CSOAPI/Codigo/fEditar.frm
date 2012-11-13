VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Begin VB.Form fEdit 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Editar"
   ClientHeight    =   6975
   ClientLeft      =   45
   ClientTop       =   525
   ClientWidth     =   10680
   Icon            =   "fEditar.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6975
   ScaleWidth      =   10680
   ShowInTaskbar   =   0   'False
   Begin CSButton.cButtonLigth cmdCancel 
      Cancel          =   -1  'True
      Height          =   330
      Left            =   9255
      TabIndex        =   3
      Top             =   6510
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
      Left            =   7905
      TabIndex        =   2
      Top             =   6510
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
   Begin VB.TextBox TxValue 
      BorderStyle     =   0  'None
      Height          =   270
      Left            =   135
      TabIndex        =   1
      Top             =   1080
      Width           =   7170
   End
   Begin VB.TextBox txValueMemo 
      BorderStyle     =   0  'None
      Height          =   5160
      Left            =   135
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   0
      Top             =   1035
      Visible         =   0   'False
      Width           =   10470
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   -90
      X2              =   12900
      Y1              =   6390
      Y2              =   6390
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   -90
      X2              =   12900
      Y1              =   6375
      Y2              =   6375
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H00FF8080&
      Height          =   315
      Left            =   120
      Top             =   1065
      Width           =   7205
   End
   Begin VB.Image Image1 
      Height          =   630
      Left            =   45
      Picture         =   "fEditar.frx":038A
      Top             =   90
      Width           =   555
   End
   Begin VB.Label lbDescrip 
      BackStyle       =   0  'Transparent
      Caption         =   "Ingrese el valor solicitado"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   645
      Left            =   720
      TabIndex        =   4
      Top             =   180
      Width           =   7395
   End
   Begin VB.Shape Shape3 
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   870
      Left            =   -45
      Top             =   0
      Width           =   10995
   End
   Begin VB.Shape Shape2 
      BorderColor     =   &H00FF8080&
      Height          =   5190
      Left            =   120
      Top             =   1020
      Visible         =   0   'False
      Width           =   10500
   End
End
Attribute VB_Name = "fEdit"
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
Private m_bMemo As Boolean
' Properties publicas
Public Property Let bMemo(ByVal rhs As Boolean)
  m_bMemo = rhs
End Property
' Properties privadas
' Funciones publicas
' Funciones privadas
Private Sub cmdOk_Click()
  On Error Resume Next
  If m_bMemo Then
    G_InputValue = txValueMemo.Text
  Else
    G_InputValue = TxValue.Text
  End If
  G_FormResult = True
  Unload Me
End Sub

Private Sub cmdCancel_Click()
  On Error Resume Next
  G_FormResult = False
  Unload Me
End Sub
' construccion - destruccion
Private Sub Form_Load()
  On Error Resume Next
  Dim win As cWindow
  Set win = New cWindow
  m_bMemo = False
  win.CenterForm Me
End Sub
