VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{E82A759A-7510-4F56-B239-9C0B78CF437B}#1.0#0"; "CSImageList.ocx"
Object = "{757F6B6F-8057-4D0A-85C2-0A1807E33D34}#1.0#0"; "CSGrid2.ocx"
Begin VB.Form fDocsDigital 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Documentos Digitalizados"
   ClientHeight    =   4395
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8100
   Icon            =   "fDocsDigital.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4395
   ScaleWidth      =   8100
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin CSImageList.cImageList imList 
      Left            =   1920
      Top             =   3780
      _ExtentX        =   953
      _ExtentY        =   953
      Size            =   9400
      Images          =   "fDocsDigital.frx":0A02
      KeyCount        =   10
      Keys            =   "ÿÿÿÿÿÿÿÿÿ"
   End
   Begin CSGrid2.cGrid grFiles 
      Height          =   2535
      Left            =   120
      TabIndex        =   4
      Top             =   1320
      Width           =   7875
      _ExtentX        =   13891
      _ExtentY        =   4471
      BackgroundPictureHeight=   0
      BackgroundPictureWidth=   0
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      HeaderFlat      =   -1  'True
      BorderStyle     =   2
      DisableIcons    =   -1  'True
   End
   Begin CSButton.cButton cmdAdd 
      Height          =   330
      Left            =   2760
      TabIndex        =   1
      Top             =   4020
      Width           =   1320
      _ExtentX        =   2328
      _ExtentY        =   582
      Caption         =   "&Agregar"
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
   Begin CSButton.cButton cmdClose 
      Height          =   330
      Left            =   6960
      TabIndex        =   2
      Top             =   4020
      Width           =   1095
      _ExtentX        =   1931
      _ExtentY        =   582
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
   Begin CSButton.cButton cmdDelete 
      Height          =   330
      Left            =   5535
      TabIndex        =   3
      Top             =   4020
      Width           =   1245
      _ExtentX        =   2196
      _ExtentY        =   582
      Caption         =   "&Borrar"
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
   Begin CSButton.cButton cmdEdit 
      Height          =   330
      Left            =   4140
      TabIndex        =   6
      Top             =   4020
      Width           =   1320
      _ExtentX        =   2328
      _ExtentY        =   582
      Caption         =   "&Actualizar"
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
   Begin CSButton.cButton cmdView 
      Height          =   330
      Left            =   180
      TabIndex        =   7
      Top             =   4020
      Width           =   1320
      _ExtentX        =   2328
      _ExtentY        =   582
      Caption         =   "&Ver"
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
   Begin VB.Label lbOwner 
      BackStyle       =   0  'Transparent
      Caption         =   "Pedido de venta"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H8000000E&
      Height          =   255
      Left            =   300
      TabIndex        =   5
      Top             =   780
      Width           =   4935
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H80000010&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   495
      Left            =   120
      Top             =   660
      Width           =   7875
   End
   Begin VB.Line Line2 
      BorderColor     =   &H8000000E&
      X1              =   60
      X2              =   8080
      Y1              =   3915
      Y2              =   3915
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   60
      X2              =   8080
      Y1              =   3900
      Y2              =   3900
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   135
      Picture         =   "fDocsDigital.frx":2EDA
      Top             =   0
      Width           =   480
   End
   Begin VB.Label lbTitle 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Documentos Digitalizados"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   14.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      Left            =   765
      TabIndex        =   0
      Top             =   45
      Width           =   3300
   End
   Begin VB.Shape shTitle 
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   510
      Left            =   0
      Top             =   0
      Width           =   8175
   End
End
Attribute VB_Name = "fDocsDigital"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fDocsDigital
' 16-08-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fDocsDigital"
' estructuras
' variables privadas
' eventos
Public Event Delete()
Public Event Add()
Public Event Edit()
Public Event View()
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub cmdAdd_Click()
  On Error Resume Next
  RaiseEvent Add
End Sub

Private Sub cmdClose_Click()
  On Error Resume Next
  Me.Hide
End Sub

Private Sub cmdDelete_Click()
  On Error Resume Next
  RaiseEvent Delete
End Sub

Private Sub cmdEdit_Click()
  On Error Resume Next
  RaiseEvent Edit
End Sub

Private Sub cmdView_Click()
  On Error Resume Next
  RaiseEvent View
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error Resume Next
  CenterForm Me
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


