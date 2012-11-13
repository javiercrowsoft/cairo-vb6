VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10140
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   10140
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.Toolbar tbMain 
      Align           =   1  'Align Top
      Height          =   330
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   10140
      _ExtentX        =   17886
      _ExtentY        =   582
      ButtonWidth     =   609
      ButtonHeight    =   582
      Style           =   1
      _Version        =   393216
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Click()
'  Call GetInputEx("", "Ingrese un texto")
'  Call GetInput("", "Ingrese un texto")
'  Call GetInputEx("", "Ingrese un texto")
On Error GoTo ControlError
  Dim i As Integer
  i = 1 / 0
Exit Sub
ControlError:
  CSKernelClient2.MngError Err, "Form_Click", "Form1", ""
End Sub

Private Sub Form_Load()
  Dim Buttons1 As Long
  Buttons1 = BUTTON_NEW + BUTTON_SAVE + BUTTON_RELOAD + BUTTON_ANULAR + BUTTON_COPY + BUTTON_SEARCH
  Buttons1 = Buttons1 + BUTTON_DOC_FIRST + BUTTON_DOC_PREVIOUS + BUTTON_DOC_NEXT + BUTTON_DOC_LAST
  Buttons1 = Buttons1 + BUTTON_DELETE + BUTTON_PRINTOBJ + BUTTON_DOC_SIGNATURE + BUTTON_DOC_MODIFY
  Buttons1 = Buttons1 + BUTTON_DOC_APLIC + BUTTON_ATTACH + BUTTON_EDIT_STATE + BUTTON_DOC_HELP + BUTTON_EXIT
  CSKernelClient2.SetToolbar tbMain, Buttons1
  tbMain.BorderStyle = ccNone

  CSKernelClient2.EmailAddress = "javier@crowsoft.com.ar"
  CSKernelClient2.EmailErrDescrip = "prueba"
  CSKernelClient2.EmailPort = 25
  CSKernelClient2.EmailServer = "192.160.142.98"
  CSKernelClient2.EmailUser = "javier"
  CSKernelClient2.EmailPwd = "catalina"
  

End Sub
