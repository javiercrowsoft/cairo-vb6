VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Begin VB.Form fSecProperties 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Propiedades"
   ClientHeight    =   3780
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   6000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3780
   ScaleWidth      =   6000
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txName 
      BorderStyle     =   0  'None
      Height          =   315
      Left            =   1140
      TabIndex        =   9
      Top             =   825
      Width           =   4755
   End
   Begin VB.CheckBox chkFormulaHide 
      Appearance      =   0  'Flat
      Caption         =   "Tiene formula para mostrar"
      ForeColor       =   &H80000008&
      Height          =   285
      Left            =   1470
      TabIndex        =   1
      Top             =   1410
      Width           =   2430
   End
   Begin CSButton.cButton cmdFormulaHide 
      Height          =   315
      Left            =   135
      TabIndex        =   0
      ToolTipText     =   "Editar Formula ..."
      Top             =   1365
      Width           =   1005
      _ExtentX        =   1773
      _ExtentY        =   556
      Caption         =   "Editar..."
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
      Picture         =   "fSecProperties.frx":0000
   End
   Begin CSButton.cButton cmdCancelar 
      Cancel          =   -1  'True
      Height          =   315
      Left            =   4575
      TabIndex        =   3
      Top             =   3405
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
      Default         =   -1  'True
      Height          =   315
      Left            =   3180
      TabIndex        =   4
      Top             =   3405
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
   Begin VB.Shape Shape2 
      BorderColor     =   &H80000010&
      Height          =   345
      Left            =   1125
      Top             =   810
      Width           =   4785
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   6000
      Y1              =   3300
      Y2              =   3300
   End
   Begin VB.Label Label2 
      Caption         =   "Nombre:"
      Height          =   375
      Left            =   120
      TabIndex        =   8
      Top             =   825
      Width           =   915
   End
   Begin VB.Label Label1 
      Caption         =   "La formula debe devolver un valor distinto de cero para que se muestre la sección."
      Height          =   375
      Left            =   120
      TabIndex        =   7
      Top             =   1785
      Width           =   5715
   End
   Begin VB.Shape Shape3 
      BorderColor     =   &H80000010&
      Height          =   975
      Left            =   120
      Top             =   2205
      Width           =   5715
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   6000
      Y1              =   3285
      Y2              =   3285
   End
   Begin VB.Image Image1 
      Height          =   585
      Left            =   135
      Picture         =   "fSecProperties.frx":059A
      Top             =   45
      Width           =   675
   End
   Begin VB.Label lbSecLn 
      BackStyle       =   0  'Transparent
      Caption         =   "Propiedades de la sección:"
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
      Left            =   915
      TabIndex        =   6
      Top             =   225
      Width           =   2475
   End
   Begin VB.Label LbControl 
      BackStyle       =   0  'Transparent
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
      Left            =   3390
      TabIndex        =   5
      Top             =   225
      Width           =   2535
   End
   Begin VB.Label lbFormulaHide 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   900
      Left            =   135
      TabIndex        =   2
      Top             =   2250
      Width           =   5700
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
Attribute VB_Name = "fSecProperties"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fSecProperties
' 27-09-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fSecProperties"

Private Const C_Label = 0
Private Const C_Formula = 1
Private Const C_Field = 2

' estructuras
' variables privadas
Private m_Ok                As Boolean
Private m_Done              As Boolean

Private m_FormulaHide                   As String
Private m_FormulaName                   As String

Private m_Mouse                         As cMouse

Private m_FormulaHideChanged            As Boolean
Private m_FormulaValueChanged           As Boolean
Private m_SetFormulaHideChanged         As Boolean
Private m_SetFormulaValueChanged        As Boolean

' eventos
Public Event ShowEditFormula(ByRef Formula As String, ByRef Cancel As Boolean)
Public Event UnloadForm()
Public Event Cancel()
' propiedades publicas
Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property

Public Property Get FormulaHide() As String
   FormulaHide = m_FormulaHide
End Property

Public Property Let FormulaHide(ByVal rhs As String)
   m_FormulaHide = rhs
End Property

Public Property Get FormulaName() As String
   FormulaName = m_FormulaName
End Property

Public Property Let FormulaName(ByVal rhs As String)
   m_FormulaName = rhs
End Property

Public Property Get FormulaHideChanged() As Boolean
   FormulaHideChanged = m_FormulaHideChanged
End Property

Public Property Let FormulaHideChanged(ByVal rhs As Boolean)
   m_FormulaHideChanged = rhs
End Property

Public Property Get FormulaValueChanged() As Boolean
   FormulaValueChanged = m_FormulaValueChanged
End Property

Public Property Let FormulaValueChanged(ByVal rhs As Boolean)
   m_FormulaValueChanged = rhs
End Property

Public Property Get SetFormulaHideChanged() As Boolean
   SetFormulaHideChanged = m_SetFormulaHideChanged
End Property

Public Property Let SetFormulaHideChanged(ByVal rhs As Boolean)
   m_SetFormulaHideChanged = rhs
End Property

Public Property Get SetFormulaValueChanged() As Boolean
   SetFormulaValueChanged = m_SetFormulaValueChanged
End Property

Public Property Let SetFormulaValueChanged(ByVal rhs As Boolean)
   m_SetFormulaValueChanged = rhs
End Property

' propiedades privadas
' funciones publicas
Public Sub ResetChangedFlags()
  m_FormulaHideChanged = False
  m_FormulaValueChanged = False
  m_SetFormulaHideChanged = False
  m_SetFormulaValueChanged = False
End Sub

' funciones privadas
Private Sub chkFormulaHide_Click()
  m_SetFormulaHideChanged = True
End Sub

Private Sub cmdAceptar_Click()
  m_Ok = True
  Me.Hide
End Sub

Private Sub cmdCancelar_Click()
  m_Ok = False
  Me.Hide
  RaiseEvent Cancel
End Sub

Private Sub cmdFormulaHide_Click()
  Dim Cancel As Boolean
  m_FormulaName = "Ocultar"
  ShowFormula m_FormulaHide, Cancel
  If Not Cancel Then
    m_FormulaHideChanged = True
    lbFormulaHide.Caption = m_FormulaHide
  End If
End Sub

Private Sub ShowFormula(ByRef Formula As String, ByRef Cancel As Boolean)
  RaiseEvent ShowEditFormula(Formula, Cancel)
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If UnloadMode <> vbFormCode Then
    Cancel = True
    cmdCancelar_Click
  End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Set m_Mouse = Nothing
  RaiseEvent UnloadForm
End Sub

' construccion - destruccion
Private Sub Form_Activate()
  On Error Resume Next
  
  If m_Done Then Exit Sub
  m_Done = True
  m_Mouse.MouseSet vbDefault
  lbFormulaHide.Caption = m_FormulaHide
End Sub

Private Sub Form_Load()
  m_Done = False
  CenterForm Me
  m_Ok = False
  Set m_Mouse = New cMouse
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'ExitProc:
