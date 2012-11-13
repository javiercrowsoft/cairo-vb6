VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.2#0"; "CSMaskEdit2.ocx"
Begin VB.Form fGroup 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Propiedades del grupo"
   ClientHeight    =   6120
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5340
   Icon            =   "fGroup.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6120
   ScaleWidth      =   5340
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkGrandTotal 
      Caption         =   "&Es un grupo para totales generales"
      Height          =   240
      Left            =   120
      TabIndex        =   18
      Top             =   5040
      Width           =   4890
   End
   Begin VB.CheckBox chkReprintGroup 
      Caption         =   "&Reimprimir grupos al cambiar de pagina"
      Height          =   240
      Left            =   120
      TabIndex        =   10
      Top             =   4410
      Width           =   4890
   End
   Begin VB.CheckBox chkPrintInNewPage 
      Caption         =   "&Imprimir en una nueva pagina"
      Height          =   240
      Left            =   120
      TabIndex        =   4
      Top             =   3930
      Width           =   3030
   End
   Begin CSButton.cButton cmdCancelar 
      Height          =   315
      Left            =   3960
      TabIndex        =   0
      Top             =   5595
      Width           =   1275
      _ExtentX        =   2249
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
   Begin CSButton.cButton cmdAceptar 
      Height          =   315
      Left            =   2565
      TabIndex        =   1
      Top             =   5595
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   556
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
   Begin CSMaskEdit2.cMaskEdit TxDbField 
      Height          =   285
      Left            =   1080
      TabIndex        =   2
      Top             =   1365
      Width           =   3300
      _ExtentX        =   5821
      _ExtentY        =   503
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
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderColor     =   12164479
      BorderType      =   1
      csNotRaiseError =   -1  'True
   End
   Begin CSMaskEdit2.cMaskEdit TxName 
      Height          =   285
      Left            =   1080
      TabIndex        =   5
      Top             =   825
      Width           =   3300
      _ExtentX        =   5821
      _ExtentY        =   503
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
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderColor     =   12164479
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin VB.PictureBox Picture1 
      BorderStyle     =   0  'None
      Height          =   495
      Left            =   60
      ScaleHeight     =   495
      ScaleWidth      =   5175
      TabIndex        =   11
      Top             =   3060
      Width           =   5175
      Begin VB.OptionButton opText 
         Caption         =   "&Texto"
         Height          =   285
         Left            =   420
         TabIndex        =   14
         Top             =   120
         Value           =   -1  'True
         Width           =   960
      End
      Begin VB.OptionButton opDate 
         Caption         =   "&Fecha"
         Height          =   285
         Left            =   1725
         TabIndex        =   13
         Top             =   120
         Width           =   960
      End
      Begin VB.OptionButton opNumber 
         Caption         =   "&Número"
         Height          =   285
         Left            =   3075
         TabIndex        =   12
         Top             =   120
         Width           =   960
      End
   End
   Begin VB.PictureBox Picture2 
      BorderStyle     =   0  'None
      Height          =   555
      Left            =   60
      ScaleHeight     =   555
      ScaleWidth      =   5175
      TabIndex        =   15
      Top             =   2040
      Width           =   5175
      Begin VB.OptionButton opDesc 
         Caption         =   "&Descendente"
         Height          =   225
         Left            =   2805
         TabIndex        =   17
         Top             =   180
         Width           =   1290
      End
      Begin VB.OptionButton opAsc 
         Caption         =   "&Ascendente"
         Height          =   225
         Left            =   600
         TabIndex        =   16
         Top             =   180
         Value           =   -1  'True
         Width           =   1290
      End
      Begin VB.Image I_ordenDesc 
         Height          =   480
         Index           =   0
         Left            =   4050
         Picture         =   "fGroup.frx":000C
         Top             =   0
         Width           =   480
      End
      Begin VB.Image I_OrdenAsc 
         Height          =   480
         Index           =   0
         Left            =   1800
         Picture         =   "fGroup.frx":0316
         Top             =   0
         Width           =   480
      End
   End
   Begin VB.Line Line6 
      BorderColor     =   &H80000010&
      X1              =   90
      X2              =   5220
      Y1              =   4800
      Y2              =   4800
   End
   Begin VB.Image Image1 
      Height          =   585
      Left            =   135
      Picture         =   "fGroup.frx":0620
      Top             =   45
      Width           =   675
   End
   Begin VB.Label Label8 
      BackStyle       =   0  'Transparent
      Caption         =   "Grupos"
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
      Left            =   1050
      TabIndex        =   9
      Top             =   225
      Width           =   2235
   End
   Begin VB.Line Line5 
      BorderColor     =   &H80000010&
      X1              =   90
      X2              =   5220
      Y1              =   3750
      Y2              =   3750
   End
   Begin VB.Label Label2 
      Caption         =   "Tipo de &comparación :"
      Height          =   240
      Left            =   135
      TabIndex        =   8
      Top             =   2760
      Width           =   1680
   End
   Begin VB.Label Label1 
      Caption         =   "&Orden :"
      Height          =   195
      Left            =   135
      TabIndex        =   7
      Top             =   1815
      Width           =   600
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000010&
      X1              =   990
      X2              =   5220
      Y1              =   2895
      Y2              =   2895
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000010&
      X1              =   720
      X2              =   5220
      Y1              =   1905
      Y2              =   1905
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000010&
      X1              =   90
      X2              =   5220
      Y1              =   5415
      Y2              =   5415
   End
   Begin VB.Label Label9 
      Caption         =   "Nombre :"
      Height          =   285
      Left            =   135
      TabIndex        =   6
      Top             =   825
      Width           =   915
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   90
      X2              =   5220
      Y1              =   1230
      Y2              =   1230
   End
   Begin VB.Label Label7 
      Caption         =   "Campo :"
      Height          =   285
      Left            =   135
      TabIndex        =   3
      Top             =   1410
      Width           =   1140
   End
   Begin VB.Shape Shape1 
      BorderStyle     =   0  'Transparent
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   690
      Left            =   0
      Top             =   0
      Width           =   6360
   End
End
Attribute VB_Name = "fGroup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fGroup
' 24-11-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fGroup"

' estructuras
' variables privadas
Private m_Ok                As Boolean
Private m_Done              As Boolean

Private m_Index                         As Long
Private m_FieldType                     As Long
' eventos
Public Event ShowHelpDbField()
Public Event UnloadForm()
' propiedades publicas
Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property

Public Property Get Index() As Long
   Index = m_Index
End Property

Public Property Get FieldType() As Long
   FieldType = m_FieldType
End Property

Public Property Let Index(ByVal rhs As Long)
   m_Index = rhs
End Property

Public Property Let FieldType(ByVal rhs As Long)
   m_FieldType = rhs
End Property

' propiedades privadas
' funciones publicas
' funciones privadas
Private Sub cmdAceptar_Click()
  
  If chkGrandTotal.Value <> vbChecked Then

    If TxDbField.Text = vbNullString Then
      MsgWarning "Debe seleccionar una columna sobre la que se creará el grupo."
      Exit Sub
    End If
  End If
  
  m_Ok = True
  Me.Hide
End Sub

Private Sub cmdCancelar_Click()
  m_Ok = False
  Me.Hide
End Sub

Private Sub Form_Unload(Cancel As Integer)
  RaiseEvent UnloadForm
End Sub

Private Sub TxDbField_ButtonClick(ByRef Cancel As Boolean)
  Cancel = True
  RaiseEvent ShowHelpDbField
End Sub

' construccion - destruccion
Private Sub Form_Activate()
  On Error Resume Next
  If m_Done Then Exit Sub
  m_Done = True
  Me.TxName.SetFocus
End Sub

Private Sub Form_Load()
  m_Done = False
  CenterForm Me
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'ExitProc:


