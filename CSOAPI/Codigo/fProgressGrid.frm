VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Begin VB.Form fProgressGrid 
   BackColor       =   &H00FF8080&
   BorderStyle     =   0  'None
   Caption         =   "Obteniendo datos"
   ClientHeight    =   1485
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   3900
   Icon            =   "fProgressGrid.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   1485
   ScaleWidth      =   3900
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.ProgressBar prgProgress 
      Height          =   210
      Left            =   240
      TabIndex        =   3
      Top             =   1140
      Width           =   3435
      _ExtentX        =   6059
      _ExtentY        =   370
      _Version        =   393216
      BorderStyle     =   1
      Appearance      =   0
      Scrolling       =   1
   End
   Begin CSButton.cButtonLigth cmdCancel 
      Height          =   315
      Left            =   1200
      TabIndex        =   0
      Top             =   720
      Width           =   1335
      _ExtentX        =   2355
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
   Begin VB.Label lbTime 
      BackColor       =   &H00FFFFFF&
      Caption         =   "00:00"
      Height          =   315
      Left            =   2340
      TabIndex        =   2
      Top             =   360
      Width           =   555
   End
   Begin VB.Label lbMessage 
      BackStyle       =   0  'Transparent
      Caption         =   "Cargando ...."
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   240
      TabIndex        =   1
      Top             =   360
      Width           =   2115
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H00FFFFFF&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H80000010&
      BorderStyle     =   0  'Transparent
      BorderWidth     =   2
      FillColor       =   &H80000010&
      Height          =   1445
      Left            =   25
      Top             =   25
      Width           =   3855
   End
End
Attribute VB_Name = "fProgressGrid"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fCancelQuery
' 31-07-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fCancelQuery"
' estructuras
' variables privadas
Private m_HaveToRaiseEvent              As Boolean
Private m_EventRaised                   As Boolean
Private m_RaiseEventProgress            As Boolean
Private m_StartTime                     As Date
Private m_bSuccess                      As Boolean

' eventos
Public Event Export(ByRef bSuccess As Boolean)
Public Event Cancel()

' propiedades publicas
Public Property Get bSuccess() As Boolean
  bSuccess = m_bSuccess
End Property

Public Property Get HaveToRaiseEvent() As Boolean
   HaveToRaiseEvent = m_HaveToRaiseEvent
End Property

Public Property Let HaveToRaiseEvent(ByVal rhs As Boolean)
   m_HaveToRaiseEvent = rhs
End Property

Public Property Get RaiseEventProgress() As Boolean
   RaiseEventProgress = m_RaiseEventProgress
End Property

Public Property Let RaiseEventProgress(ByVal rhs As Boolean)
   m_RaiseEventProgress = rhs
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
Public Sub ShowSorting()
  cmdCancel.Visible = False
  prgProgress.Visible = False
  lbTime.Visible = False
  lbMessage.Caption = "Ordenando ..."
  DoEvents
End Sub

Public Sub ShowTime()
  Dim Seconds As Long
  Dim Minutes As Long
  
  Seconds = DateDiff("s", m_StartTime, Now)
  Minutes = Fix(Seconds / 60)
  Seconds = Seconds Mod 60
  
  lbTime.Caption = Format(Minutes, "00") & ":" & Format(Seconds, "00")
End Sub

Public Sub ShowProgress(ByVal Value As Integer)
  On Error Resume Next
  prgProgress.Value = Value
  ShowTime
End Sub
' funciones friend
' funciones privadas
Private Sub cmdCancel_Click()
  RaiseEvent Cancel
End Sub

Private Sub Form_Activate()
  If m_HaveToRaiseEvent And Not m_EventRaised Then
    m_EventRaised = True
    RaiseEvent Export(m_bSuccess)
    Me.Hide
  End If
End Sub
' construccion - destruccion
Private Sub Form_Load()
  CenterForm Me
  m_HaveToRaiseEvent = False
  m_EventRaised = False
  m_RaiseEventProgress = False
  m_StartTime = Now
  prgProgress.Min = 0
  prgProgress.Max = 100
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


