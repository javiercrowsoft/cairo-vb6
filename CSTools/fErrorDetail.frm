VERSION 5.00
Begin VB.Form fErrorDetail 
   Caption         =   "Detalle"
   ClientHeight    =   4155
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5700
   Icon            =   "fErrorDetail.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   4155
   ScaleWidth      =   5700
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Aceptar"
      Height          =   330
      Left            =   2385
      TabIndex        =   1
      Top             =   3780
      Width           =   1275
   End
   Begin VB.TextBox txDetail 
      Height          =   3570
      Left            =   45
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   0
      Top             =   90
      Width           =   5595
   End
End
Attribute VB_Name = "fErrorDetail"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cToolsDeclaration
' 15-05-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cToolsDeclaration"

' estructuras
' variables privadas
' eventos
' propiedadades publicas
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion

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

Private Sub cmdOk_Click()
  On Error Resume Next
  Me.Hide
End Sub

Private Sub Form_Load()
  On Error Resume Next
  FormCenter Me
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  cmdOk.Top = ScaleHeight - cmdOk.Height - 200
  cmdOk.Left = (ScaleWidth - cmdOk.Width) / 2
  txDetail.Height = cmdOk.Top - 300
  txDetail.Width = ScaleWidth - txDetail.Left * 2
End Sub
