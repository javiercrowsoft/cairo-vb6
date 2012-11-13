VERSION 5.00
Begin VB.Form fAux 
   Caption         =   "fAux"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txLog 
      Height          =   3030
      Left            =   45
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   0
      Top             =   90
      Width           =   4605
   End
End
Attribute VB_Name = "fAux"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fAux
' 10-04-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fAux"

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If UnloadMode <> vbFormCode Then Cancel = True
End Sub

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
Private Sub Form_Resize()
  On Error GoTo ControlError

  txLog.Move 20, 20, ScaleWidth - 40, ScaleHeight - 40

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Resize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
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
Private Sub txLog_Change()
  txLog.SelStart = Len(txLog.Text)
End Sub
