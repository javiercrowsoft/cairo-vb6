VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Begin VB.Form fPrint 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Imprimir"
   ClientHeight    =   4965
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   6750
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4965
   ScaleWidth      =   6750
   StartUpPosition =   3  'Windows Default
   Begin CSButton.cButton cmdOpciones 
      Height          =   330
      Left            =   135
      TabIndex        =   22
      Top             =   4590
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   582
      Caption         =   "Opciones"
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
   Begin CSButton.cButton cmdProperties 
      Height          =   330
      Left            =   4995
      TabIndex        =   21
      Top             =   45
      Width           =   1590
      _ExtentX        =   2805
      _ExtentY        =   582
      Caption         =   "&Propiedades"
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
   Begin CSButton.cButton cmdCancelar 
      Height          =   330
      Left            =   5490
      TabIndex        =   20
      Top             =   4590
      Width           =   1230
      _ExtentX        =   2170
      _ExtentY        =   582
      Caption         =   "Cancelar"
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
   Begin CSButton.cButton cmdAceptar 
      Height          =   330
      Left            =   4230
      TabIndex        =   19
      Top             =   4590
      Width           =   1230
      _ExtentX        =   2170
      _ExtentY        =   582
      Caption         =   "&Aceptar"
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
   Begin VB.ComboBox cbImprimir 
      Height          =   315
      Left            =   810
      TabIndex        =   17
      Top             =   4095
      Width           =   2220
   End
   Begin VB.CheckBox chkIntercalar 
      Caption         =   "&Intercalar"
      Height          =   240
      Left            =   5265
      TabIndex        =   16
      Top             =   2790
      Width           =   1095
   End
   Begin VB.TextBox txCCopies 
      Height          =   285
      Left            =   5265
      TabIndex        =   15
      Top             =   2205
      Width           =   1050
   End
   Begin VB.TextBox txPages 
      Height          =   285
      Left            =   1440
      TabIndex        =   12
      Top             =   2880
      Width           =   1725
   End
   Begin VB.OptionButton OptPages 
      Caption         =   "Págin&as"
      Height          =   240
      Left            =   135
      TabIndex        =   11
      Top             =   2880
      Width           =   1140
   End
   Begin VB.OptionButton OptCurrentPage 
      Caption         =   "Página Actua&l"
      Height          =   240
      Left            =   135
      TabIndex        =   10
      Top             =   2520
      Width           =   1545
   End
   Begin VB.OptionButton OptAll 
      Caption         =   "&Todo"
      Height          =   240
      Left            =   135
      TabIndex        =   9
      Top             =   2160
      Width           =   1140
   End
   Begin VB.CheckBox chkPrnFile 
      Caption         =   "&Imprimir en archivo"
      Height          =   285
      Left            =   4725
      TabIndex        =   7
      Top             =   990
      Width           =   1770
   End
   Begin VB.ComboBox cbPrinter 
      Height          =   315
      Left            =   1440
      TabIndex        =   6
      Top             =   45
      Width           =   2805
   End
   Begin VB.Image imgIntercalado 
      Height          =   720
      Index           =   1
      Left            =   4410
      Picture         =   "fPrint.frx":0000
      Top             =   3060
      Visible         =   0   'False
      Width           =   720
   End
   Begin VB.Image imgIntercalado 
      Height          =   720
      Index           =   0
      Left            =   3690
      Picture         =   "fPrint.frx":068A
      Top             =   3060
      Visible         =   0   'False
      Width           =   720
   End
   Begin VB.Image imgIntercalado 
      Height          =   720
      Index           =   4
      Left            =   4680
      Picture         =   "fPrint.frx":0D14
      Top             =   3060
      Width           =   720
   End
   Begin VB.Image imgIntercalado 
      Height          =   720
      Index           =   3
      Left            =   4185
      Picture         =   "fPrint.frx":139E
      Top             =   3060
      Width           =   720
   End
   Begin VB.Image imgIntercalado 
      Height          =   720
      Index           =   2
      Left            =   3645
      Picture         =   "fPrint.frx":1A28
      Top             =   3060
      Width           =   720
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000010&
      X1              =   90
      X2              =   6705
      Y1              =   4500
      Y2              =   4500
   End
   Begin VB.Label lbComment 
      Height          =   240
      Left            =   1440
      TabIndex        =   26
      Top             =   1350
      Width           =   5055
   End
   Begin VB.Label lbPort 
      Height          =   240
      Left            =   1440
      TabIndex        =   25
      Top             =   1035
      Width           =   3075
   End
   Begin VB.Label lbPrintName 
      Height          =   240
      Left            =   1440
      TabIndex        =   24
      Top             =   720
      Width           =   3210
   End
   Begin VB.Label lbState 
      Height          =   240
      Left            =   1440
      TabIndex        =   23
      Top             =   405
      Width           =   1680
   End
   Begin VB.Label lbImprimir 
      Caption         =   "Imprimir:"
      Height          =   285
      Left            =   90
      TabIndex        =   18
      Top             =   4095
      Width           =   645
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000010&
      X1              =   90
      X2              =   6705
      Y1              =   3960
      Y2              =   3960
   End
   Begin VB.Label lbCantCopias 
      Caption         =   "Cantidad de copias:"
      Height          =   285
      Left            =   3780
      TabIndex        =   14
      Top             =   2250
      Width           =   1590
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000010&
      X1              =   3555
      X2              =   3555
      Y1              =   3960
      Y2              =   1710
   End
   Begin VB.Label lbExplicacion 
      Caption         =   "Escriba los números de páginas e intervalos separados por comas. Ejemplo:1,2,3,20-23"
      Height          =   465
      Left            =   90
      TabIndex        =   13
      Top             =   3285
      Width           =   3435
   End
   Begin VB.Label Label1 
      Caption         =   "Intervalo de Páginas"
      Height          =   240
      Left            =   135
      TabIndex        =   8
      Top             =   1800
      Width           =   1680
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   45
      X2              =   6660
      Y1              =   1710
      Y2              =   1710
   End
   Begin VB.Label lbCopias 
      Caption         =   "Copias"
      Height          =   240
      Left            =   3600
      TabIndex        =   5
      Top             =   1800
      Width           =   1230
   End
   Begin VB.Label lbComentario 
      Caption         =   "Comentario:"
      Height          =   240
      Left            =   90
      TabIndex        =   4
      Top             =   1350
      Width           =   1230
   End
   Begin VB.Label lbUbicacion 
      Caption         =   "Ubicacion:"
      Height          =   240
      Left            =   90
      TabIndex        =   3
      Top             =   1035
      Width           =   1230
   End
   Begin VB.Label lbTipo 
      Caption         =   "Tipo:"
      Height          =   240
      Left            =   90
      TabIndex        =   2
      Top             =   720
      Width           =   1230
   End
   Begin VB.Label lbEstado 
      Caption         =   "Estado:"
      Height          =   240
      Left            =   90
      TabIndex        =   1
      Top             =   405
      Width           =   1230
   End
   Begin VB.Label lbPrinter 
      Caption         =   "Impresora:"
      Height          =   240
      Left            =   90
      TabIndex        =   0
      Top             =   90
      Width           =   1230
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
' 16-10-2003

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
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub cbPrinter_Click()
  lbPrintName.Caption = Printers(cbPrinter.ListIndex).DeviceName
  lbPort.Caption = Printers(cbPrinter.ListIndex).Port
End Sub

Private Sub chkIntercalar_Click()
  If chkIntercalar = vbChecked Then
    imgIntercalado(0).Visible = True
    imgIntercalado(1).Visible = True
    imgIntercalado(2).Visible = False
    imgIntercalado(3).Visible = False
    imgIntercalado(4).Visible = False
  Else
    imgIntercalado(0).Visible = False
    imgIntercalado(1).Visible = False
    imgIntercalado(2).Visible = True
    imgIntercalado(3).Visible = True
    imgIntercalado(4).Visible = True
  End If
End Sub

' construccion - destruccion
Private Sub Form_Load()
  Dim i As Long
  For i = 0 To Printers.Count - 1
    cbPrinter.AddItem Printers(i).DeviceName
  Next i
  With fPrint.cbImprimir
    .AddItem "El intervalo"
    .AddItem "Páginas impares"
    .AddItem "Páginas pares"
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


