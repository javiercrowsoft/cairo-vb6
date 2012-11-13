VERSION 5.00
Begin VB.Form fPrinters 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Impresoras"
   ClientHeight    =   4575
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   8640
   Icon            =   "fPrinters.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4575
   ScaleWidth      =   8640
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancelar"
      Height          =   375
      Left            =   6060
      TabIndex        =   3
      Top             =   3960
      Width           =   1635
   End
   Begin VB.CommandButton cmdPrint 
      Caption         =   "&Imprimir"
      Default         =   -1  'True
      Height          =   375
      Left            =   4380
      TabIndex        =   2
      Top             =   3960
      Width           =   1575
   End
   Begin VB.ListBox lsPrinter 
      Height          =   2985
      Left            =   120
      TabIndex        =   1
      Top             =   720
      Width           =   8355
   End
   Begin VB.Label Label1 
      Caption         =   "Seleccione la impresora:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   180
      TabIndex        =   0
      Top             =   300
      Width           =   3255
   End
End
Attribute VB_Name = "fPrinters"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_ok As Boolean

Public Property Get Ok() As Boolean
  Ok = m_ok
End Property

Private Sub cmdCancel_Click()
  m_ok = False
  Me.Hide
End Sub

Private Sub cmdPrint_Click()
  m_ok = True
  Me.Hide
End Sub

Private Sub Form_Load()
  On Error Resume Next
  Dim p As Printer
  
  lsPrinter.Clear
  
  For Each p In Printers
    lsPrinter.AddItem p.DeviceName
    If p.DeviceName = Printer.DeviceName Then
      lsPrinter.Selected(lsPrinter.NewIndex) = True
    End If
  Next
  
  CSKernelClient2.CenterForm Me
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If UnloadMode <> vbFormCode Then
    Cancel = True
    cmdCancel_Click
  End If
End Sub
