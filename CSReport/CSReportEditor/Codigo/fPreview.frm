VERSION 5.00
Object = "{AE4714A0-35E2-44BC-9460-84B3AD745E81}#2.4#0"; "CSReportPreview.ocx"
Begin VB.Form fPreview 
   Caption         =   "Preview"
   ClientHeight    =   5910
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8415
   Icon            =   "fPreview.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5910
   ScaleWidth      =   8415
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox picFrame 
      Height          =   2895
      Left            =   0
      ScaleHeight     =   2835
      ScaleWidth      =   3615
      TabIndex        =   0
      Top             =   180
      Width           =   3675
      Begin CSReportPreview.cReportPreview rpwReport 
         Height          =   5325
         Left            =   780
         TabIndex        =   1
         Top             =   300
         Width           =   7755
         _ExtentX        =   11853
         _ExtentY        =   8758
      End
   End
End
Attribute VB_Name = "fPreview"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fPreview
' 15-09-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fPreview"
' estructuras
' variables privadas
' eventos
Public Event FormUnload()

' propiedades publicas
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Form_Load()
  With picFrame
    .Left = 0
    .Top = 0
  End With
  With rpwReport
    .Left = 0
    .Top = 0
  End With
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  RaiseEvent FormUnload
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  With picFrame
    .Width = ScaleWidth
    .Height = ScaleHeight
  End With
  With rpwReport
    .Width = picFrame.ScaleWidth
    .Height = picFrame.ScaleHeight
  End With
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
