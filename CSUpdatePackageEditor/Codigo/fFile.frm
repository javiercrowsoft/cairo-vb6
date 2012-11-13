VERSION 5.00
Object = "{57EC5E1A-9098-47A9-A8E3-EF352F97282B}#3.0#0"; "CSButton.ocx"
Object = "{C3B62925-B0EA-11D7-8204-00D0090360E2}#7.2#0"; "CSComboBox.ocx"
Begin VB.Form fFile 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Archivo"
   ClientHeight    =   8475
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7260
   Icon            =   "fFile.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   8475
   ScaleWidth      =   7260
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkAsocToTbl 
      Height          =   240
      Left            =   1620
      TabIndex        =   28
      Top             =   6975
      Width           =   420
   End
   Begin VB.CheckBox chkAsocToDoc 
      Height          =   240
      Left            =   1620
      TabIndex        =   24
      Top             =   6075
      Width           =   420
   End
   Begin VB.TextBox txDataBases 
      BorderStyle     =   0  'None
      Height          =   285
      Left            =   1650
      TabIndex        =   5
      Top             =   2730
      Width           =   5415
   End
   Begin VB.TextBox txName 
      BorderStyle     =   0  'None
      Height          =   285
      Left            =   1650
      TabIndex        =   1
      Top             =   1470
      Width           =   5415
   End
   Begin VB.CheckBox chkDelAfterRun 
      Height          =   240
      Left            =   1620
      TabIndex        =   19
      Top             =   5580
      Width           =   420
   End
   Begin VB.CheckBox chkRegister 
      Height          =   240
      Left            =   1620
      TabIndex        =   17
      Top             =   5130
      Width           =   420
   End
   Begin VB.TextBox txVersion 
      Alignment       =   1  'Right Justify
      BorderStyle     =   0  'None
      Height          =   300
      Left            =   1650
      TabIndex        =   9
      Text            =   "1.00.1"
      Top             =   3585
      Width           =   1725
   End
   Begin VB.TextBox txDescrip 
      BorderStyle     =   0  'None
      Height          =   645
      Left            =   1650
      MultiLine       =   -1  'True
      TabIndex        =   3
      Text            =   "fFile.frx":000C
      Top             =   1920
      Width           =   5415
   End
   Begin VB.CheckBox chkCreateShortcut 
      Height          =   240
      Left            =   1620
      TabIndex        =   11
      Top             =   4005
      Width           =   420
   End
   Begin VB.CheckBox chkExecute 
      Height          =   240
      Left            =   1620
      TabIndex        =   15
      Top             =   4770
      Width           =   420
   End
   Begin CSButton.cButtonLigth cmdCancel 
      Cancel          =   -1  'True
      Height          =   330
      Left            =   5715
      TabIndex        =   21
      Top             =   8010
      Width           =   1410
      _ExtentX        =   2487
      _ExtentY        =   582
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
   Begin CSButton.cButtonLigth cmdOk 
      Default         =   -1  'True
      Height          =   330
      Left            =   4140
      TabIndex        =   20
      Top             =   8010
      Width           =   1500
      _ExtentX        =   2646
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
      ForeColor       =   0
   End
   Begin CSComboBox.cComboBox cbTarget 
      Height          =   315
      Left            =   1635
      TabIndex        =   7
      Top             =   3150
      Width           =   3120
      _ExtentX        =   5503
      _ExtentY        =   556
      StyleEx         =   2
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ListIndex       =   -1
      Text            =   "cbCombo2"
   End
   Begin CSComboBox.cComboBox cbTargetShortcut 
      Height          =   315
      Left            =   1635
      TabIndex        =   13
      Top             =   4365
      Width           =   3120
      _ExtentX        =   5503
      _ExtentY        =   556
      StyleEx         =   2
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ListIndex       =   -1
      Text            =   "cbCombo2"
   End
   Begin CSComboBox.cComboBox cbDoct_id 
      Height          =   315
      Left            =   1635
      TabIndex        =   25
      Top             =   6525
      Width           =   3120
      _ExtentX        =   5503
      _ExtentY        =   556
      StyleEx         =   2
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ListIndex       =   -1
      Text            =   "cbCombo2"
   End
   Begin CSComboBox.cComboBox cbTbl_id 
      Height          =   315
      Left            =   1635
      TabIndex        =   29
      Top             =   7425
      Width           =   3120
      _ExtentX        =   5503
      _ExtentY        =   556
      StyleEx         =   2
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ListIndex       =   -1
      Text            =   "cbCombo2"
   End
   Begin VB.Shape Shape8 
      BorderColor     =   &H80000010&
      Height          =   360
      Left            =   1605
      Top             =   7395
      Width           =   3165
   End
   Begin VB.Label Label14 
      BackStyle       =   0  'Transparent
      Caption         =   "&Tabla:"
      Height          =   285
      Left            =   225
      TabIndex        =   31
      Top             =   7425
      Width           =   1275
   End
   Begin VB.Label Label9 
      BackStyle       =   0  'Transparent
      Caption         =   "&Asociar a maestros:"
      Height          =   420
      Left            =   225
      TabIndex        =   30
      Top             =   6930
      Width           =   1320
   End
   Begin VB.Label Label8 
      BackStyle       =   0  'Transparent
      Caption         =   "&Asociar a documentos:"
      Height          =   420
      Left            =   225
      TabIndex        =   27
      Top             =   6030
      Width           =   1320
   End
   Begin VB.Label Label7 
      BackStyle       =   0  'Transparent
      Caption         =   "&Documento:"
      Height          =   285
      Left            =   225
      TabIndex        =   26
      Top             =   6525
      Width           =   1275
   End
   Begin VB.Shape Shape7 
      BorderColor     =   &H80000010&
      Height          =   360
      Left            =   1605
      Top             =   6495
      Width           =   3165
   End
   Begin VB.Label Label6 
      BackStyle       =   0  'Transparent
      Caption         =   "&DataBases:"
      Height          =   285
      Left            =   225
      TabIndex        =   4
      Top             =   2700
      Width           =   1005
   End
   Begin VB.Shape Shape6 
      BorderColor     =   &H80000010&
      Height          =   345
      Left            =   1620
      Top             =   2700
      Width           =   5475
   End
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "&Nombre:"
      Height          =   285
      Left            =   225
      TabIndex        =   0
      Top             =   1440
      Width           =   1005
   End
   Begin VB.Shape Shape5 
      BorderColor     =   &H80000010&
      Height          =   345
      Left            =   1620
      Top             =   1440
      Width           =   5475
   End
   Begin VB.Shape Shape4 
      BorderColor     =   &H80000010&
      Height          =   360
      Left            =   1605
      Top             =   4335
      Width           =   3165
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H80000010&
      Height          =   360
      Left            =   1605
      Top             =   3120
      Width           =   3165
   End
   Begin VB.Label lbFile 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   510
      Left            =   900
      TabIndex        =   23
      Top             =   675
      Width           =   6180
   End
   Begin VB.Label Label11 
      BackStyle       =   0  'Transparent
      Caption         =   "&Borrar despues de Ejecutar:"
      Height          =   420
      Index           =   1
      Left            =   225
      TabIndex        =   18
      Top             =   5490
      Width           =   1140
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "&Registrar:"
      Height          =   285
      Left            =   225
      TabIndex        =   16
      Top             =   5130
      Width           =   1320
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "&Destino Shortcut:"
      Height          =   285
      Left            =   225
      TabIndex        =   12
      Top             =   4365
      Width           =   1275
   End
   Begin VB.Label Label13 
      BackStyle       =   0  'Transparent
      Caption         =   "De&stino:"
      Height          =   285
      Left            =   225
      TabIndex        =   6
      Top             =   3150
      Width           =   645
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   270
      Picture         =   "fFile.frx":0030
      Top             =   180
      Width           =   420
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "&Version:"
      Height          =   285
      Left            =   225
      TabIndex        =   8
      Top             =   3555
      Width           =   1005
   End
   Begin VB.Shape Shape2 
      BorderColor     =   &H80000010&
      Height          =   345
      Left            =   1620
      Top             =   3555
      Width           =   1785
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "&Descripción:"
      Height          =   285
      Left            =   225
      TabIndex        =   2
      Top             =   1890
      Width           =   1005
   End
   Begin VB.Shape Shape3 
      BorderColor     =   &H80000010&
      Height          =   705
      Left            =   1620
      Top             =   1890
      Width           =   5475
   End
   Begin VB.Label Label10 
      BackStyle       =   0  'Transparent
      Caption         =   "&Crear Shortcut:"
      Height          =   285
      Left            =   225
      TabIndex        =   10
      Top             =   4005
      Width           =   1320
   End
   Begin VB.Label Label11 
      BackStyle       =   0  'Transparent
      Caption         =   "&Ejecutar:"
      Height          =   285
      Index           =   0
      Left            =   225
      TabIndex        =   14
      Top             =   4770
      Width           =   1320
   End
   Begin VB.Label Label12 
      BackStyle       =   0  'Transparent
      Caption         =   "Indique las propiedades del archivo:"
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
      Left            =   900
      TabIndex        =   22
      Top             =   270
      Width           =   5505
   End
   Begin VB.Shape Shape10 
      BackColor       =   &H8000000F&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   6630
      Left            =   0
      Top             =   1260
      Width           =   7485
   End
End
Attribute VB_Name = "fFile"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fFile
' 08-05-2006

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "fFile"

' estructuras
' variables privadas
Private m_Ok As Boolean

Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property

Private Sub cmdCancel_Click()
  m_Ok = False
  Me.Hide
End Sub

Private Sub cmdOk_Click()
  m_Ok = True
  Me.Hide
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  CenterForm Me
  
  InitCBTarget cbTarget
  InitCBTarget cbTargetShortcut
  InitCBDoctId cbDoct_id
  InitCBTblId cbTbl_id

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

