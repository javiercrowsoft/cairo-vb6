VERSION 5.00
Object = "{57EC5E1A-9098-47A9-A8E3-EF352F97282B}#3.0#0"; "CSButton.ocx"
Begin VB.Form fCSA 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "CSA"
   ClientHeight    =   6720
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6435
   Icon            =   "fCSA.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6720
   ScaleWidth      =   6435
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkStopCairo 
      Height          =   240
      Left            =   1620
      TabIndex        =   20
      Top             =   5760
      Width           =   420
   End
   Begin VB.CheckBox chkBackup 
      Height          =   240
      Left            =   1620
      TabIndex        =   19
      Top             =   5355
      Width           =   420
   End
   Begin VB.TextBox txDataBases 
      BorderStyle     =   0  'None
      Height          =   285
      Left            =   1650
      TabIndex        =   17
      Text            =   "{ALL}"
      Top             =   4890
      Width           =   4605
   End
   Begin VB.TextBox txSqlVer 
      BorderStyle     =   0  'None
      Height          =   285
      Left            =   1650
      TabIndex        =   15
      Text            =   "MSSQL2000+"
      Top             =   4485
      Width           =   2805
   End
   Begin VB.TextBox txOSVer 
      BorderStyle     =   0  'None
      Height          =   285
      Left            =   1650
      TabIndex        =   13
      Text            =   "MSW2000+"
      Top             =   4080
      Width           =   2805
   End
   Begin VB.TextBox txAPPMinVer 
      Alignment       =   1  'Right Justify
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   1650
      TabIndex        =   11
      Text            =   "1.00.1"
      Top             =   3675
      Width           =   1725
   End
   Begin VB.TextBox txEXEMinVer 
      Alignment       =   1  'Right Justify
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   1650
      TabIndex        =   9
      Text            =   "1.00.1"
      Top             =   3270
      Width           =   1725
   End
   Begin VB.TextBox txDBMinVer 
      Alignment       =   1  'Right Justify
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   1650
      TabIndex        =   7
      Text            =   "1.00.1"
      Top             =   2865
      Width           =   1725
   End
   Begin VB.TextBox txDescrip 
      BorderStyle     =   0  'None
      Height          =   645
      Left            =   1650
      MultiLine       =   -1  'True
      TabIndex        =   5
      Text            =   "fCSA.frx":038A
      Top             =   2100
      Width           =   4605
   End
   Begin VB.TextBox txVersion 
      Alignment       =   1  'Right Justify
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      Left            =   1650
      TabIndex        =   3
      Text            =   "1.00.1"
      Top             =   1650
      Width           =   1725
   End
   Begin VB.TextBox txIdCliente 
      BorderStyle     =   0  'None
      Height          =   285
      Left            =   1650
      TabIndex        =   1
      Text            =   "{ALL}"
      Top             =   1245
      Width           =   2805
   End
   Begin CSButton.cButtonLigth cmdCancel 
      Cancel          =   -1  'True
      Height          =   330
      Left            =   4905
      TabIndex        =   22
      Top             =   6255
      Width           =   1410
      _ExtentX        =   2487
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
      ForeColor       =   0
   End
   Begin CSButton.cButtonLigth cmdOk 
      Default         =   -1  'True
      Height          =   330
      Left            =   3330
      TabIndex        =   23
      Top             =   6255
      Width           =   1500
      _ExtentX        =   2646
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
      ForeColor       =   0
   End
   Begin VB.Label Label12 
      BackStyle       =   0  'Transparent
      Caption         =   "Indique las propiedades del paquete"
      Height          =   375
      Left            =   1170
      TabIndex        =   24
      Top             =   585
      Width           =   5505
   End
   Begin VB.Image Image1 
      Height          =   990
      Left            =   90
      Picture         =   "fCSA.frx":03AE
      Top             =   0
      Width           =   975
   End
   Begin VB.Label Label11 
      BackStyle       =   0  'Transparent
      Caption         =   "Stop Cairo:"
      Height          =   285
      Left            =   225
      TabIndex        =   21
      Top             =   5760
      Width           =   1320
   End
   Begin VB.Label Label10 
      BackStyle       =   0  'Transparent
      Caption         =   "Backup DB:"
      Height          =   285
      Left            =   225
      TabIndex        =   18
      Top             =   5355
      Width           =   1320
   End
   Begin VB.Shape Shape9 
      BorderColor     =   &H80000010&
      Height          =   345
      Left            =   1620
      Top             =   4860
      Width           =   4665
   End
   Begin VB.Label Label9 
      BackStyle       =   0  'Transparent
      Caption         =   "Data Bases:"
      Height          =   285
      Left            =   225
      TabIndex        =   16
      Top             =   4905
      Width           =   1320
   End
   Begin VB.Shape Shape8 
      BorderColor     =   &H80000010&
      Height          =   345
      Left            =   1620
      Top             =   4455
      Width           =   2865
   End
   Begin VB.Label Label8 
      BackStyle       =   0  'Transparent
      Caption         =   "SQL Versión:"
      Height          =   285
      Left            =   225
      TabIndex        =   14
      Top             =   4500
      Width           =   1320
   End
   Begin VB.Shape Shape7 
      BorderColor     =   &H80000010&
      Height          =   345
      Left            =   1620
      Top             =   4050
      Width           =   2865
   End
   Begin VB.Label Label7 
      BackStyle       =   0  'Transparent
      Caption         =   "OS Versión:"
      Height          =   285
      Left            =   225
      TabIndex        =   12
      Top             =   4095
      Width           =   1320
   End
   Begin VB.Shape Shape6 
      BorderColor     =   &H80000010&
      Height          =   345
      Left            =   1620
      Top             =   3645
      Width           =   1785
   End
   Begin VB.Label Label6 
      BackStyle       =   0  'Transparent
      Caption         =   "APP Min. Versión:"
      Height          =   285
      Left            =   225
      TabIndex        =   10
      Top             =   3690
      Width           =   1320
   End
   Begin VB.Shape Shape5 
      BorderColor     =   &H80000010&
      Height          =   345
      Left            =   1620
      Top             =   3240
      Width           =   1785
   End
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "EXE Min. Versión:"
      Height          =   285
      Left            =   225
      TabIndex        =   8
      Top             =   3285
      Width           =   1275
   End
   Begin VB.Shape Shape4 
      BorderColor     =   &H80000010&
      Height          =   345
      Left            =   1620
      Top             =   2835
      Width           =   1785
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "DB Min. Versión:"
      Height          =   285
      Left            =   225
      TabIndex        =   6
      Top             =   2880
      Width           =   1185
   End
   Begin VB.Shape Shape3 
      BorderColor     =   &H80000010&
      Height          =   705
      Left            =   1620
      Top             =   2070
      Width           =   4665
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Descripción:"
      Height          =   285
      Left            =   225
      TabIndex        =   4
      Top             =   2070
      Width           =   1005
   End
   Begin VB.Shape Shape2 
      BorderColor     =   &H80000010&
      Height          =   345
      Left            =   1620
      Top             =   1620
      Width           =   1785
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Version:"
      Height          =   285
      Left            =   225
      TabIndex        =   2
      Top             =   1620
      Width           =   1005
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H80000010&
      Height          =   345
      Left            =   1620
      Top             =   1215
      Width           =   2865
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "ID Cliente:"
      Height          =   285
      Left            =   225
      TabIndex        =   0
      Top             =   1215
      Width           =   1005
   End
   Begin VB.Shape Shape10 
      BackColor       =   &H8000000F&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   5055
      Left            =   0
      Top             =   1080
      Width           =   6720
   End
End
Attribute VB_Name = "fCSA"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fCSA
' 07-05-2006

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "fCSA"

' estructuras
' variables privadas
Private m_Ok As Boolean

Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property

Private Sub cmdCancel_Click()
  m_Ok = False
  Me.Hide
End Sub

Private Sub cmdOk_Click()
  m_Ok = True
  Me.Hide
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  CenterForm Me

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub
