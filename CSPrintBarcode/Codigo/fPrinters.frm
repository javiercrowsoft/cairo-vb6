VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Begin VB.Form fPrinters 
   Caption         =   "Impresoras"
   ClientHeight    =   2805
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   6825
   LinkTopic       =   "Form1"
   ScaleHeight     =   2805
   ScaleWidth      =   6825
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txNumbers 
      BorderStyle     =   0  'None
      Height          =   315
      Left            =   840
      TabIndex        =   4
      Top             =   1560
      Width           =   5715
   End
   Begin CSButton.cButton cmdPrint 
      Default         =   -1  'True
      Height          =   315
      Left            =   3660
      TabIndex        =   2
      Top             =   2340
      Width           =   1455
      _ExtentX        =   2566
      _ExtentY        =   556
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
   End
   Begin VB.ComboBox cbPrinters 
      Height          =   315
      Left            =   840
      Sorted          =   -1  'True
      Style           =   2  'Dropdown List
      TabIndex        =   0
      Top             =   300
      Width           =   5775
   End
   Begin CSButton.cButton cmdCancel 
      Cancel          =   -1  'True
      Height          =   315
      Left            =   5280
      TabIndex        =   3
      Top             =   2340
      Width           =   1455
      _ExtentX        =   2566
      _ExtentY        =   556
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
   End
   Begin VB.Label Label3 
      Caption         =   "Ingrese los números separados por comas, ejemplo: 1234,1235"
      Height          =   315
      Left            =   840
      TabIndex        =   6
      Top             =   1140
      Width           =   5655
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H80000010&
      Height          =   345
      Left            =   825
      Top             =   1545
      Width           =   5745
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   6915
      Y1              =   2175
      Y2              =   2175
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   -60
      X2              =   6855
      Y1              =   2160
      Y2              =   2160
   End
   Begin VB.Label Label1 
      Caption         =   "Impresora"
      Height          =   435
      Left            =   60
      TabIndex        =   1
      Top             =   300
      Width           =   855
   End
   Begin VB.Label Label2 
      Caption         =   "Números"
      Height          =   435
      Left            =   60
      TabIndex        =   5
      Top             =   1560
      Width           =   855
   End
End
Attribute VB_Name = "fPrinters"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_ok        As Boolean
Private m_printer   As String
Private m_numbers   As String

Private Const c_BarcodePrint = "BarcodePrinter"

Public Property Get PrinterName() As String
  PrinterName = m_printer
End Property

Public Property Get numbers() As String
  numbers = m_numbers
End Property

Public Property Get Ok() As Boolean
  Ok = m_ok
End Property

Private Sub cmdCancel_Click()
  m_ok = False
  Me.Hide
End Sub

Private Sub cmdPrint_Click()
  If cbPrinters.Text = vbNullString Then
    MsgWarning "Debe seleccionar una impresora"
    Exit Sub
  End If
  
  m_printer = cbPrinters.Text
  m_numbers = txNumbers.Text
  
  CSKernelClient2.SetRegistry CSConfig, c_BarcodePrint, m_printer
  
  m_ok = True
  Me.Hide
End Sub

Private Sub Form_Load()
  On Error GoTo ControlError
  
  m_ok = False
  
  Dim obj As Object
  
  For Each obj In Printers
    cbPrinters.AddItem obj.DeviceName
  Next
  
  Dim printer_name As String
  Dim numbers      As String
  
  printer_name = CSKernelClient2.GetRegistry(CSConfig, c_BarcodePrint, vbNullString)
  
  CSKernelClient2.ListSetListIndexForText cbPrinters, printer_name
  
ControlError:
End Sub
