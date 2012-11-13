VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Begin VB.Form fCancelQuery 
   BackColor       =   &H80000010&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Obteniendo datos"
   ClientHeight    =   2370
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3900
   Icon            =   "fCancelQuery.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2370
   ScaleWidth      =   3900
   StartUpPosition =   3  'Windows Default
   Begin CSButton.cButtonLigth cmdCancel 
      Height          =   315
      Left            =   1200
      TabIndex        =   0
      Top             =   780
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
   Begin VB.Label lbDescrip 
      BackColor       =   &H80000005&
      Height          =   975
      Left            =   60
      TabIndex        =   3
      Top             =   1320
      Width           =   3795
   End
   Begin VB.Label lbTime 
      Caption         =   "00:30"
      Height          =   315
      Left            =   2340
      TabIndex        =   2
      Top             =   360
      Width           =   555
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   3000
      Picture         =   "fCancelQuery.frx":57E2
      Top             =   240
      Width           =   480
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Obteniendo datos ...."
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
      Left            =   420
      TabIndex        =   1
      Top             =   360
      Width           =   2115
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H8000000F&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H80000010&
      BorderStyle     =   0  'Transparent
      BorderWidth     =   2
      FillColor       =   &H80000010&
      Height          =   1200
      Left            =   40
      Top             =   40
      Width           =   3825
   End
End
Attribute VB_Name = "fCancelQuery"
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
Private m_Rs                            As Recordset
Private m_StartTime                     As Date
' eventos
Public Event OpenRs()
Public Event Cancel(ByRef bClose As Boolean)
' propiedades publicas
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

Public Property Get Rs() As Recordset
   Set Rs = m_Rs
End Property

Public Property Set Rs(ByRef rhs As Recordset)
   Set m_Rs = rhs
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Sub ShowTime()
  Dim Seconds As Long
  Dim Minutes As Long
  
  Seconds = DateDiff("s", m_StartTime, Now)
  Minutes = Fix(Seconds / 60)
  Seconds = Seconds Mod 60
  
  lbTime.Caption = Format(Minutes, "00") & ":" & Format(Seconds, "00")
End Sub
' funciones friend
' funciones privadas
Private Sub cmdCancel_Click()
  pCancel
End Sub

Private Function pCancel() As Boolean
  Dim bClose As Boolean
  RaiseEvent Cancel(bClose)
  pCancel = bClose
End Function

Private Sub Form_Activate()
  If m_HaveToRaiseEvent And Not m_EventRaised Then
    m_EventRaised = True
    RaiseEvent OpenRs
  End If
End Sub
' construccion - destruccion
Private Sub Form_Load()
  CenterForm Me
  m_HaveToRaiseEvent = False
  m_EventRaised = False
  m_RaiseEventProgress = False
  m_StartTime = Now
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If UnloadMode = vbFormControlMenu Then
    Cancel = Not pCancel
  End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Set m_Rs = Nothing
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


