VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form fConnectsAux 
   BorderStyle     =   5  'Sizable ToolWindow
   Caption         =   "Conexiones A"
   ClientHeight    =   3555
   ClientLeft      =   60
   ClientTop       =   300
   ClientWidth     =   8640
   Icon            =   "fConnectsAux.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3555
   ScaleWidth      =   8640
   StartUpPosition =   3  'Windows Default
   Begin CSButton.cButton cmdClose 
      Height          =   315
      Left            =   7275
      TabIndex        =   1
      Top             =   3180
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   556
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
   Begin MSComctlLib.ListView lvColumns 
      Height          =   1950
      Left            =   60
      TabIndex        =   2
      Top             =   1020
      Width           =   8535
      _ExtentX        =   15055
      _ExtentY        =   3440
      Sorted          =   -1  'True
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      FlatScrollBar   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      Appearance      =   1
      NumItems        =   0
   End
   Begin CSButton.cButton cmdAdd 
      Height          =   315
      Left            =   60
      TabIndex        =   3
      Top             =   660
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   556
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
   Begin CSButton.cButton cmdDelete 
      Height          =   315
      Left            =   2700
      TabIndex        =   4
      Top             =   660
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   556
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
      Height          =   315
      Left            =   1380
      TabIndex        =   5
      Top             =   660
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   556
      Caption         =   "&Editar"
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
   Begin VB.Line Line6 
      BorderColor     =   &H80000014&
      X1              =   -90
      X2              =   6195
      Y1              =   3075
      Y2              =   3075
   End
   Begin VB.Line Line5 
      BorderColor     =   &H80000010&
      X1              =   -75
      X2              =   6210
      Y1              =   3060
      Y2              =   3060
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   135
      Picture         =   "fConnectsAux.frx":058A
      Top             =   45
      Width           =   480
   End
   Begin VB.Label Label8 
      BackStyle       =   0  'Transparent
      Caption         =   "Conexiones Adicionales:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   690
      TabIndex        =   0
      Top             =   135
      Width           =   2235
   End
   Begin VB.Shape Shape1 
      BorderStyle     =   0  'Transparent
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   600
      Left            =   0
      Top             =   0
      Width           =   8700
   End
End
Attribute VB_Name = "fConnectsAux"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fConnectsAux
' -08-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fConnectsAux"

' estructuras
' variables privadas
' eventos
Public Event AddConnect()
Public Event EditConnect()
Public Event DeleteConnect()

' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub cmdClose_Click()
  Me.Hide
End Sub

Private Sub cmdAdd_Click()
  RaiseEvent AddConnect
End Sub

Private Sub cmdDelete_Click()
  RaiseEvent DeleteConnect
End Sub

Private Sub cmdEdit_Click()
  RaiseEvent EditConnect
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  lvColumns.Width = Me.ScaleWidth - lvColumns.Left * 2
  lvColumns.Height = Me.ScaleHeight - lvColumns.Top - cmdClose.Height - 220
  Line5.X2 = Me.Width
  Line6.X2 = Me.Width
  Line5.y1 = Me.ScaleHeight - cmdClose.Height - 160
  Line5.Y2 = Line5.y1
  Line6.y1 = Line5.y1 + 10
  Line6.Y2 = Line6.y1
  cmdClose.Top = Me.ScaleHeight - cmdClose.Height - 80
  cmdClose.Left = Me.ScaleWidth - cmdClose.Width - 100
  Shape1.Width = Me.Width
End Sub

' construccion - destruccion
Private Sub Form_Load()
  CSKernelClient2.LoadForm Me, Me.Name
  With lvColumns
    .View = lvwReport
    .LabelEdit = lvwManual
    .FlatScrollBar = False
    .FullRowSelect = True
    .GridLines = True
    .HideSelection = False
  End With
End Sub

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
Private Sub Form_Unload(Cancel As Integer)
  CSKernelClient2.UnloadForm Me, Me.Name
End Sub
