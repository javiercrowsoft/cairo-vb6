VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{059DDBAF-ED7D-4789-A31E-638692EFCEA2}#1.9#0"; "CSGridAdvanced2.ocx"
Begin VB.Form fPrint 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Imprimir"
   ClientHeight    =   4125
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7890
   Icon            =   "fPrint.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4125
   ScaleWidth      =   7890
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer tmAutoPrint 
      Left            =   3360
      Top             =   1800
   End
   Begin CSGridAdvanced2.cGridAdvanced grReports 
      Height          =   3255
      Left            =   60
      TabIndex        =   1
      Top             =   780
      Width           =   5475
      _ExtentX        =   9657
      _ExtentY        =   5741
   End
   Begin CSButton.cButton cmdPrint 
      Height          =   375
      Left            =   5640
      TabIndex        =   0
      Top             =   1260
      Width           =   2115
      _ExtentX        =   3731
      _ExtentY        =   661
      Caption         =   "&Imprimir"
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
      Picture         =   "fPrint.frx":058A
   End
   Begin CSButton.cButton cmdPreview 
      Height          =   375
      Left            =   5640
      TabIndex        =   2
      Top             =   840
      Width           =   2115
      _ExtentX        =   3731
      _ExtentY        =   661
      Caption         =   "&Vista Previa"
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
      Picture         =   "fPrint.frx":0924
   End
   Begin CSButton.cButton cmdClose 
      Height          =   375
      Left            =   5640
      TabIndex        =   6
      Top             =   3600
      Width           =   2115
      _ExtentX        =   3731
      _ExtentY        =   661
      Caption         =   "&Cerrar"
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
   Begin CSButton.cButton cmdExport 
      Height          =   375
      Left            =   5640
      TabIndex        =   4
      ToolTipText     =   "Genera un archivo PDF"
      Top             =   2400
      Width           =   2115
      _ExtentX        =   3731
      _ExtentY        =   661
      Caption         =   "E&xportar a PDF"
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
      Picture         =   "fPrint.frx":0CBE
   End
   Begin CSButton.cButton cmdEmail 
      Height          =   375
      Left            =   5640
      TabIndex        =   3
      ToolTipText     =   "Genera un archivo PDF y lo asocia a un e-mail nuevo usando el cliente de correo instalado en la PC del usuario"
      Top             =   1980
      Width           =   2115
      _ExtentX        =   3731
      _ExtentY        =   661
      Caption         =   "&e-Mail (en formato PDF)"
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
      Picture         =   "fPrint.frx":1258
   End
   Begin CSButton.cButton cmdAdvanced 
      Height          =   375
      Left            =   5640
      TabIndex        =   8
      Top             =   3600
      Visible         =   0   'False
      Width           =   1455
      _ExtentX        =   2566
      _ExtentY        =   661
      Caption         =   "&Avanzado ..."
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
   Begin CSButton.cButton cmdExportToFile 
      Height          =   375
      Left            =   5640
      TabIndex        =   5
      ToolTipText     =   "Genera un archivo PDF en la carpeta indicada por las preferencias del usuario"
      Top             =   2820
      Width           =   2115
      _ExtentX        =   3731
      _ExtentY        =   661
      Caption         =   "E&xportar a Carpeta"
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
      Picture         =   "fPrint.frx":15F2
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000010&
      X1              =   -180
      X2              =   8540
      Y1              =   3360
      Y2              =   3360
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   1380
      X2              =   8100
      Y1              =   1800
      Y2              =   1800
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   180
      Picture         =   "fPrint.frx":198C
      Top             =   120
      Width           =   480
   End
   Begin VB.Label lbTitle 
      BackStyle       =   0  'Transparent
      Caption         =   "Imprimir"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H8000000E&
      Height          =   315
      Left            =   840
      TabIndex        =   7
      Top             =   180
      Width           =   6855
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H8000000C&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   615
      Left            =   60
      Top             =   60
      Width           =   7755
   End
End
Attribute VB_Name = "fPrint"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fPrint
' 28-10-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fPrint"


' estructuras
' variables privadas
Private m_bClosed As Boolean
' eventos
Public Event CloseForm()
Public Event Preview()
Public Event PrinterAdvanced()
Public Event DoPrint()
Public Event SendEmail()
Public Event ExportPdf()
Public Event ExportPdfToFolder()

' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas

Private Sub cmdClose_Click()
  m_bClosed = True
  RaiseEvent CloseForm
End Sub

Private Sub cmdAdvanced_Click()
  RaiseEvent PrinterAdvanced
End Sub

Private Sub cmdEmail_Click()
  RaiseEvent SendEmail
End Sub

Private Sub cmdExport_Click()
  RaiseEvent ExportPdf
End Sub

Private Sub cmdExportToFile_Click()
  RaiseEvent ExportPdfToFolder
End Sub

Private Sub cmdPreview_Click()
  RaiseEvent Preview
End Sub

Private Sub cmdPrint_Click()
  RaiseEvent DoPrint
End Sub

Private Sub tmAutoPrint_Timer()
  cmdPrint_Click
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If Not m_bClosed Then
    cmdClose_Click
  End If
End Sub

Private Sub grReports_ValidateRow(ByVal lRow As Long, bCancel As Boolean)
  bCancel = True
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  m_bClosed = False
  CenterForm Me

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error GoTo ControlError

  Set fPrint = Nothing

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Unload", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

#If PREPROC_DEBUG Then
Private Sub Form_Initialize()
  gdbInitInstance C_Module
End Sub

Private Sub Form_Terminate()
  gdbTerminateInstance C_Module
End Sub
#End If

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
