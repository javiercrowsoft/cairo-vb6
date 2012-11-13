VERSION 5.00
Object = "{57EC5E1A-9098-47A9-A8E3-EF352F97282B}#2.2#0"; "CSButton.ocx"
Begin VB.Form fImport 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Importación"
   ClientHeight    =   3975
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   7440
   Icon            =   "fImport.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3975
   ScaleWidth      =   7440
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin CSButton.cButtonLigth cmdCancel 
      Cancel          =   -1  'True
      Height          =   375
      Left            =   3120
      TabIndex        =   3
      Top             =   3360
      Width           =   1695
      _ExtentX        =   2990
      _ExtentY        =   661
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
   Begin VB.PictureBox picStatus 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'None
      ClipControls    =   0   'False
      FillColor       =   &H0080C0FF&
      Height          =   330
      Left            =   1020
      ScaleHeight     =   330
      ScaleWidth      =   5595
      TabIndex        =   2
      TabStop         =   0   'False
      Top             =   2580
      Width           =   5592
   End
   Begin VB.Label lbDescrip 
      BackStyle       =   0  'Transparent
      Caption         =   "Obteniendo datos...."
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   855
      Left            =   960
      TabIndex        =   4
      Top             =   1440
      Width           =   5535
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H0080C0FF&
      Height          =   435
      Left            =   960
      Top             =   2520
      Width           =   5715
   End
   Begin VB.Label lbTitle 
      BackStyle       =   0  'Transparent
      Caption         =   "Importando Productos"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   1440
      TabIndex        =   1
      Top             =   720
      Width           =   5535
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Importando :"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   240
      TabIndex        =   0
      Top             =   360
      Width           =   1095
   End
   Begin VB.Shape Shape2 
      BackColor       =   &H00E0E0E0&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   975
      Left            =   840
      Top             =   1320
      Width           =   6015
   End
End
Attribute VB_Name = "fImport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fImport
' 27-06-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fImport"
' estructuras
' variables privadas
Private m_Done          As Boolean
Private m_Ok            As Boolean
Private m_bCancel       As Boolean
' eventos
Public Event Execute()
' propiedades publicas
Public Property Get Cancel() As Boolean
  Cancel = m_bCancel
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub cmdCancel_Click()
  On Error Resume Next
  Dim rslt As VbMsgBoxResult
  
  rslt = MsgBox("¿Confirma que desea cancelar?", vbQuestion + vbYesNo)
  
  If rslt = vbYes Then
    m_Ok = False
    m_bCancel = True
  End If
End Sub

Private Sub Form_Activate()
  On Error GoTo ControlError
  
  If m_Done Then Exit Sub
  m_Done = True
  
  RaiseEvent Execute

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Activate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  m_Done = False
  CenterForm Me

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If UnloadMode <> vbFormCode Then Cancel = True
End Sub
'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


