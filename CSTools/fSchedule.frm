VERSION 5.00
Begin VB.Form fSchedule 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Programación"
   ClientHeight    =   7380
   ClientLeft      =   45
   ClientTop       =   360
   ClientWidth     =   6360
   Icon            =   "fSchedule.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7380
   ScaleWidth      =   6360
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txName 
      Height          =   300
      Left            =   1125
      TabIndex        =   1
      Top             =   45
      Width           =   4965
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Aceptar"
      Height          =   330
      Left            =   3510
      TabIndex        =   47
      Top             =   6975
      Width           =   1275
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&Cancelar"
      Height          =   330
      Left            =   4995
      TabIndex        =   48
      Top             =   6975
      Width           =   1275
   End
   Begin VB.PictureBox Frame3 
      Appearance      =   0  'Flat
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   1005
      Left            =   90
      ScaleHeight     =   1005
      ScaleWidth      =   6240
      TabIndex        =   41
      Top             =   5805
      Width           =   6240
      Begin VB.OptionButton opEndDateNever 
         Caption         =   "Nunca termina"
         Height          =   240
         Left            =   2520
         TabIndex        =   46
         Top             =   675
         Width           =   1365
      End
      Begin VB.TextBox txEndDate 
         Alignment       =   1  'Right Justify
         Height          =   300
         Left            =   3690
         MaxLength       =   10
         TabIndex        =   45
         Top             =   270
         Width           =   1000
      End
      Begin VB.OptionButton opEndDate 
         Caption         =   "Termina el :"
         Height          =   240
         Left            =   2520
         TabIndex        =   44
         Top             =   315
         Width           =   1365
      End
      Begin VB.TextBox txStartDate 
         Alignment       =   1  'Right Justify
         Height          =   300
         Left            =   1170
         MaxLength       =   10
         TabIndex        =   43
         Top             =   270
         Width           =   1000
      End
      Begin VB.Label Label9 
         Caption         =   "Duración"
         Height          =   255
         Left            =   120
         TabIndex        =   52
         Top             =   0
         Width           =   795
      End
      Begin VB.Label Label5 
         Caption         =   "Arranca el :"
         Height          =   330
         Left            =   180
         TabIndex        =   42
         Top             =   315
         Width           =   960
      End
      Begin VB.Shape Shape4 
         BorderColor     =   &H80000003&
         Height          =   855
         Left            =   0
         Top             =   120
         Width           =   6195
      End
   End
   Begin VB.PictureBox Frame4 
      Appearance      =   0  'Flat
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   1500
      Left            =   90
      ScaleHeight     =   1500
      ScaleWidth      =   6225
      TabIndex        =   31
      Top             =   4140
      Width           =   6225
      Begin VB.TextBox txTimeEnd 
         Alignment       =   1  'Right Justify
         Height          =   300
         Left            =   4770
         MaxLength       =   5
         TabIndex        =   40
         Top             =   1080
         Width           =   700
      End
      Begin VB.TextBox txTimeStart 
         Alignment       =   1  'Right Justify
         Height          =   300
         Left            =   4770
         MaxLength       =   5
         TabIndex        =   38
         Top             =   720
         Width           =   700
      End
      Begin VB.ComboBox cbTimeType 
         Height          =   315
         Left            =   2340
         Style           =   2  'Dropdown List
         TabIndex        =   36
         Top             =   720
         Width           =   915
      End
      Begin VB.TextBox txOccursEach 
         Alignment       =   1  'Right Justify
         Height          =   300
         Left            =   1755
         TabIndex        =   35
         Top             =   720
         Width           =   500
      End
      Begin VB.OptionButton opOccursEach 
         Caption         =   "Ocurre cada :"
         Height          =   285
         Left            =   225
         TabIndex        =   34
         Top             =   720
         Width           =   1590
      End
      Begin VB.TextBox txOnceAt 
         Alignment       =   1  'Right Justify
         Height          =   300
         Left            =   1755
         MaxLength       =   5
         TabIndex        =   33
         Top             =   315
         Width           =   700
      End
      Begin VB.OptionButton opOnceAt 
         Caption         =   "Ocurre a las :"
         Height          =   285
         Left            =   225
         TabIndex        =   32
         Top             =   315
         Width           =   1590
      End
      Begin VB.Label Label8 
         Caption         =   "Frecuencia"
         Height          =   255
         Left            =   120
         TabIndex        =   51
         Top             =   0
         Width           =   975
      End
      Begin VB.Label Label4 
         Caption         =   "Terminando :"
         Height          =   270
         Left            =   3780
         TabIndex        =   39
         Top             =   1125
         Width           =   960
      End
      Begin VB.Label Label3 
         Caption         =   "Empesando :"
         Height          =   330
         Left            =   3780
         TabIndex        =   37
         Top             =   765
         Width           =   960
      End
      Begin VB.Shape Shape3 
         BorderColor     =   &H80000003&
         Height          =   1335
         Left            =   0
         Top             =   120
         Width           =   6195
      End
   End
   Begin VB.TextBox txOnTime 
      Alignment       =   1  'Right Justify
      Height          =   300
      Left            =   3465
      MaxLength       =   5
      TabIndex        =   5
      Top             =   630
      Width           =   700
   End
   Begin VB.PictureBox Frame2 
      Appearance      =   0  'Flat
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   1590
      Left            =   90
      ScaleHeight     =   1590
      ScaleWidth      =   6225
      TabIndex        =   11
      Top             =   2385
      Width           =   6225
      Begin VB.TextBox txEachMonth2 
         Alignment       =   1  'Right Justify
         Height          =   300
         Left            =   2250
         TabIndex        =   28
         Top             =   1170
         Width           =   600
      End
      Begin VB.ComboBox cbDayName 
         Height          =   315
         Left            =   2070
         Style           =   2  'Dropdown List
         TabIndex        =   26
         Top             =   765
         Width           =   1635
      End
      Begin VB.ComboBox cbCardinalDay 
         Height          =   315
         Left            =   1260
         Style           =   2  'Dropdown List
         TabIndex        =   25
         Top             =   765
         Width           =   735
      End
      Begin VB.OptionButton opCardinalDay 
         Caption         =   "El :"
         Height          =   330
         Left            =   225
         TabIndex        =   17
         Top             =   720
         Width           =   960
      End
      Begin VB.TextBox txEachMonth1 
         Alignment       =   1  'Right Justify
         Height          =   300
         Left            =   2970
         TabIndex        =   16
         Top             =   315
         Width           =   600
      End
      Begin VB.OptionButton opDay 
         Caption         =   "Día :"
         Height          =   330
         Left            =   225
         TabIndex        =   13
         Top             =   315
         Width           =   825
      End
      Begin VB.CheckBox chkSaturday 
         Caption         =   "Sa&bado"
         Height          =   195
         Left            =   1710
         TabIndex        =   24
         Top             =   1215
         Width           =   1005
      End
      Begin VB.CheckBox chkFriday 
         Caption         =   "&Viernes"
         Height          =   195
         Left            =   630
         TabIndex        =   23
         Top             =   1215
         Width           =   825
      End
      Begin VB.CheckBox chkThursday 
         Caption         =   "&Jueves"
         Height          =   195
         Left            =   4995
         TabIndex        =   22
         Top             =   855
         Width           =   1005
      End
      Begin VB.CheckBox chkWednesday 
         Caption         =   "M&iercoles"
         Height          =   195
         Left            =   3825
         TabIndex        =   21
         Top             =   855
         Width           =   1005
      End
      Begin VB.CheckBox chkTuesday 
         Caption         =   "M&artes"
         Height          =   195
         Left            =   2745
         TabIndex        =   20
         Top             =   855
         Width           =   1005
      End
      Begin VB.CheckBox chkMonday 
         Caption         =   "&Lunes"
         Height          =   195
         Left            =   1710
         TabIndex        =   19
         Top             =   855
         Width           =   1005
      End
      Begin VB.CheckBox chkSunday 
         Caption         =   "Domin&go"
         Height          =   195
         Left            =   630
         TabIndex        =   18
         Top             =   855
         Width           =   1005
      End
      Begin VB.TextBox txEach 
         Alignment       =   1  'Right Justify
         Height          =   300
         Left            =   1260
         TabIndex        =   14
         Top             =   315
         Width           =   600
      End
      Begin VB.Label Label7 
         Caption         =   "Programación"
         Height          =   255
         Left            =   120
         TabIndex        =   50
         Top             =   0
         Width           =   1095
      End
      Begin VB.Label lbEachDescrip2 
         Caption         =   "de cada"
         Height          =   285
         Left            =   1260
         TabIndex        =   27
         Top             =   1215
         Width           =   1050
      End
      Begin VB.Label lbMonths2 
         Caption         =   "Mese(s)"
         Height          =   285
         Left            =   2880
         TabIndex        =   30
         Top             =   1215
         Width           =   1050
      End
      Begin VB.Label lbMonths1 
         Caption         =   "Mes(s)"
         Height          =   285
         Left            =   3780
         TabIndex        =   29
         Top             =   360
         Width           =   1050
      End
      Begin VB.Label lbEachDescrip1 
         Caption         =   "EachDescrip"
         Height          =   285
         Left            =   1980
         TabIndex        =   15
         Top             =   360
         Width           =   1050
      End
      Begin VB.Label Label1 
         Caption         =   "Cada :"
         Height          =   285
         Left            =   495
         TabIndex        =   12
         Top             =   360
         Width           =   510
      End
      Begin VB.Shape Shape2 
         BorderColor     =   &H80000003&
         Height          =   1455
         Left            =   0
         Top             =   120
         Width           =   6195
      End
   End
   Begin VB.PictureBox Frame1 
      Appearance      =   0  'Flat
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   735
      Left            =   90
      ScaleHeight     =   735
      ScaleWidth      =   6225
      TabIndex        =   7
      Top             =   1485
      Width           =   6225
      Begin VB.OptionButton opWeekly 
         Caption         =   "&Semanal"
         Height          =   285
         Left            =   1665
         TabIndex        =   9
         Top             =   360
         Width           =   1185
      End
      Begin VB.OptionButton opMonthly 
         Caption         =   "&Mensual"
         Height          =   285
         Left            =   3240
         TabIndex        =   10
         Top             =   360
         Width           =   1185
      End
      Begin VB.OptionButton opDaily 
         Caption         =   "&Diario"
         Height          =   285
         Left            =   180
         TabIndex        =   8
         Top             =   360
         Width           =   1185
      End
      Begin VB.Label Label6 
         Caption         =   "Ocurre"
         Height          =   255
         Left            =   120
         TabIndex        =   49
         Top             =   0
         Width           =   675
      End
      Begin VB.Shape Shape1 
         BorderColor     =   &H80000003&
         Height          =   615
         Left            =   0
         Top             =   120
         Width           =   6195
      End
   End
   Begin VB.OptionButton opRunRecurring 
      Caption         =   "Se repite cada :"
      Height          =   330
      Left            =   180
      TabIndex        =   6
      Top             =   1080
      Width           =   1680
   End
   Begin VB.TextBox txOnDate 
      Alignment       =   1  'Right Justify
      Height          =   300
      Left            =   1845
      MaxLength       =   10
      TabIndex        =   3
      Top             =   630
      Width           =   1000
   End
   Begin VB.OptionButton opRunAt 
      Caption         =   "En este momento :"
      Height          =   330
      Left            =   180
      TabIndex        =   2
      Top             =   630
      Width           =   1680
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   7000
      Y1              =   465
      Y2              =   465
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   7000
      Y1              =   450
      Y2              =   450
   End
   Begin VB.Label lbName 
      Caption         =   "Nombre :"
      Height          =   330
      Left            =   135
      TabIndex        =   0
      Top             =   45
      Width           =   825
   End
   Begin VB.Label Label2 
      Caption         =   "Hora :"
      Height          =   285
      Left            =   2925
      TabIndex        =   4
      Top             =   675
      Width           =   510
   End
End
Attribute VB_Name = "fSchedule"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fSchedule
' 15-05-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fSchedule"

' estructuras
' variables privadas
Private m_Schedule      As cSQLTaskSchedule
Private m_Ok            As Boolean
' eventos
' propiedadades publicas
Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property

Public Property Get Schedule() As cSQLTaskSchedule
  Set Schedule = m_Schedule
End Property

Public Property Set Schedule(ByRef rhs As cSQLTaskSchedule)
  Set m_Schedule = rhs
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub cmdCancel_Click()
  On Error GoTo ControlError

  m_Ok = False
  Me.Hide

  GoTo ExitProc
ControlError:
  MngError Err, "cmdCancel_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdOk_Click()
  On Error GoTo ControlError
  
  If Not Validate() Then Exit Sub
  CollectData
  
  m_Ok = True
  Me.Hide

  GoTo ExitProc
ControlError:
  MngError Err, "cmdOk_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  On Error GoTo ControlError

  If UnloadMode <> vbFormCode Then
    Cancel = True
    cmdCancel_Click
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "Form_QueryUnload", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  Set m_Schedule = Nothing
End Sub

Private Sub opDaily_Click()
  On Error GoTo ControlError

  txEach.Enabled = True
  txEach.BackColor = vbWindowBackground
  opDay.Visible = False
  lbEachDescrip1.Caption = "Dia(s)"
  txEachMonth1.Visible = False
  opCardinalDay.Visible = False
  cbCardinalDay.Visible = False
  cbDayName.Visible = False
  
  chkMonday.Visible = False
  chkSunday.Visible = False
  chkTuesday.Visible = False
  chkWednesday.Visible = False
  chkThursday.Visible = False
  chkFriday.Visible = False
  chkSaturday.Visible = False
  
  lbEachDescrip2.Visible = False
  txEachMonth2.Visible = False
  lbMonths1.Visible = False
  lbMonths2.Visible = False
  
  GoTo ExitProc
ControlError:
  MngError Err, "opDaily_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub opDay_Click()
  On Error GoTo ControlError

  txEach.Enabled = True
  txEach.BackColor = vbWindowBackground
  txEachMonth1.Enabled = True
  txEachMonth1.BackColor = vbWindowBackground
  
  cbCardinalDay.Enabled = False
  cbDayName.Enabled = False
  cbCardinalDay.BackColor = vbButtonFace
  cbDayName.BackColor = vbButtonFace
  txEachMonth2.Enabled = False
  txEachMonth2.BackColor = vbButtonFace
  
  GoTo ExitProc
ControlError:
  MngError Err, "opDay_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub opCardinalDay_Click()
  On Error GoTo ControlError

  txEach.Enabled = False
  txEach.BackColor = vbButtonFace
  txEachMonth1.Enabled = False
  txEachMonth1.BackColor = vbButtonFace
  
  cbCardinalDay.Enabled = True
  cbDayName.Enabled = True
  cbCardinalDay.BackColor = vbWindowBackground
  cbDayName.BackColor = vbWindowBackground
  txEachMonth2.Enabled = True
  txEachMonth2.BackColor = vbWindowBackground
  
  GoTo ExitProc
ControlError:
  MngError Err, "opCardinalDay_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub opEndDate_Click()
  On Error GoTo ControlError

  txEndDate.Enabled = True
  txEndDate.BackColor = vbWindowBackground
  
  GoTo ExitProc
ControlError:
  MngError Err, "opEndDate_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub opEndDateNever_Click()
  On Error GoTo ControlError

  txEndDate.Enabled = False
  txEndDate.BackColor = vbButtonFace
  
  GoTo ExitProc
ControlError:
  MngError Err, "opEndDateNever_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub opMonthly_Click()
  On Error GoTo ControlError

  opDay.Visible = True
  lbEachDescrip1.Caption = "de cada :"
  txEachMonth1.Visible = True
  opCardinalDay.Visible = True
  cbCardinalDay.Visible = True
  cbDayName.Visible = True
  
  chkMonday.Visible = False
  chkSunday.Visible = False
  chkTuesday.Visible = False
  chkWednesday.Visible = False
  chkThursday.Visible = False
  chkFriday.Visible = False
  chkSaturday.Visible = False
  
  lbEachDescrip2.Visible = True
  txEachMonth2.Visible = True
  lbMonths1.Visible = True
  lbMonths2.Visible = True
  opDay.Value = True
  opDay_Click
  
  GoTo ExitProc
ControlError:
  MngError Err, "opMonthly_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub opOnceAt_Click()
  On Error GoTo ControlError

  txOnceAt.Enabled = True
  txOnceAt.BackColor = vbWindowBackground
  
  txOccursEach.Enabled = False
  txOccursEach.BackColor = vbButtonFace
  
  txTimeStart.Enabled = False
  txTimeStart.BackColor = vbButtonFace
  txTimeEnd.Enabled = False
  txTimeEnd.BackColor = vbButtonFace
  
  cbTimeType.Enabled = False
  cbTimeType.BackColor = vbButtonFace
  
  GoTo ExitProc
ControlError:
  MngError Err, "opOnceAt_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub opOccursEach_Click()
  On Error GoTo ControlError

  txOnceAt.Enabled = False
  txOnceAt.BackColor = vbButtonFace
  
  txOccursEach.Enabled = True
  txOccursEach.BackColor = vbWindowBackground
  
  cbTimeType.Enabled = True
  cbTimeType.BackColor = vbWindowBackground
  txTimeStart.Enabled = True
  txTimeStart.BackColor = vbWindowBackground
  txTimeEnd.Enabled = True
  txTimeEnd.BackColor = vbWindowBackground
  
  GoTo ExitProc
ControlError:
  MngError Err, "opOccursEach_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub opWeekly_Click()
  On Error GoTo ControlError

  txEach.Enabled = True
  txEach.BackColor = vbWindowBackground
  opDay.Visible = False
  lbEachDescrip1.Caption = "semana(s) en :"
  txEachMonth1.Visible = False
  opCardinalDay.Visible = False
  cbCardinalDay.Visible = False
  cbDayName.Visible = False
  
  chkMonday.Visible = True
  chkSunday.Visible = True
  chkTuesday.Visible = True
  chkWednesday.Visible = True
  chkThursday.Visible = True
  chkFriday.Visible = True
  chkSaturday.Visible = True
  
  lbEachDescrip2.Visible = False
  txEachMonth2.Visible = False
  lbMonths1.Visible = False
  lbMonths2.Visible = False

  GoTo ExitProc
ControlError:
  MngError Err, "opWeekly_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub opRunAt_Click()
  On Error GoTo ControlError
  
  Dim ctl As Control
  
  For Each ctl In Controls
    If ctl Is opRunRecurring Then
    ElseIf ctl Is cmdCancel Then
    ElseIf ctl Is cmdOk Then
    ElseIf TypeOf ctl Is Line Then
    ElseIf ctl Is txName Then
    ElseIf ctl Is lbName Then
    ElseIf ctl Is txOnTime Or ctl Is txOnDate Then
      ctl.Enabled = True
      ctl.BackColor = vbWindowBackground
    ElseIf ctl Is opRunAt Then
    ElseIf TypeOf ctl Is Shape Then
      ctl.BorderColor = vbButtonShadow
    Else
      ctl.Enabled = False
      If TypeOf ctl Is TextBox Or TypeOf ctl Is ComboBox Then
        ctl.BackColor = vbButtonFace
      End If
    End If
  Next

  GoTo ExitProc
ControlError:
  MngError Err, "opRunAt_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  opRunAt.SetFocus
End Sub

Private Sub opRunRecurring_Click()
  On Error GoTo ControlError
  
  Dim ctl As Control
  
  For Each ctl In Controls
    If ctl Is txOnDate Or ctl Is txOnTime Then
      ctl.Enabled = False
      ctl.BackColor = vbButtonFace
    ElseIf TypeOf ctl Is Line Then
    ElseIf ctl Is lbName Then
    ElseIf ctl Is txName Then
    ElseIf TypeOf ctl Is Shape Then
      ctl.BorderColor = &H80000003
    Else
      ctl.Enabled = True
      If TypeOf ctl Is TextBox Or TypeOf ctl Is ComboBox Then
        ctl.BackColor = vbWindowBackground
      End If
    End If
  Next

  opDaily.Value = True
  opEndDateNever.Value = True
  opOccursEach.Value = True
  
  opDaily_Click
  opEndDateNever_Click
  opOccursEach_Click
  
  GoTo ExitProc
ControlError:
  MngError Err, "opRunRecurring_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  opRunRecurring.SetFocus
End Sub

Private Sub txEndDate_KeyPress(KeyAscii As Integer)
  On Error GoTo ControlError
  
  KeyAscii = CharacterValidForDate(KeyAscii)
  
  GoTo ExitProc
ControlError:
  MngError Err, "txEndDate_KeyPress", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub txOccursEach_KeyPress(KeyAscii As Integer)
  On Error GoTo ControlError
  
  KeyAscii = CharacterValidForInteger(KeyAscii)
  
  GoTo ExitProc
ControlError:
  MngError Err, "txOccursEach_KeyPress", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub txOnceAt_KeyPress(KeyAscii As Integer)
  On Error GoTo ControlError
  
  KeyAscii = CharacterValidForTime(KeyAscii)
  
  GoTo ExitProc
ControlError:
  MngError Err, "txOnceAt_KeyPress", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub txOnTime_KeyPress(KeyAscii As Integer)
  On Error GoTo ControlError
  
  KeyAscii = CharacterValidForTime(KeyAscii)
  
  GoTo ExitProc
ControlError:
  MngError Err, "txOnTime_KeyPress", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub txTimeEnd_KeyPress(KeyAscii As Integer)
  On Error GoTo ControlError
  
  KeyAscii = CharacterValidForTime(KeyAscii)
  
  GoTo ExitProc
ControlError:
  MngError Err, "txTimeEnd_KeyPress", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub txTimeStart_KeyPress(KeyAscii As Integer)
  On Error GoTo ControlError
  
  KeyAscii = CharacterValidForTime(KeyAscii)
  
  GoTo ExitProc
ControlError:
  MngError Err, "txTimeStart_KeyPress", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub txOnDate_KeyPress(KeyAscii As Integer)
  On Error GoTo ControlError
  
  KeyAscii = CharacterValidForDate(KeyAscii)
  
  GoTo ExitProc
ControlError:
  MngError Err, "txOnDate_KeyPress", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub txStartDate_KeyPress(KeyAscii As Integer)
  On Error GoTo ControlError
  
  KeyAscii = CharacterValidForDate(KeyAscii)
  
  GoTo ExitProc
ControlError:
  MngError Err, "txStartDate_KeyPress", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub txTimeStart_LostFocus()
  txTimeStart.Text = CheckValueTime(txTimeStart.Text)
  txTimeStart.Text = FormatTime(txTimeStart.Text)
End Sub

Private Sub txOnTime_LostFocus()
  txOnTime.Text = CheckValueTime(txOnTime.Text)
  txOnTime.Text = FormatTime(txOnTime.Text)
End Sub

Private Sub txStartDate_LostFocus()
  txStartDate.Text = FormatDate(txStartDate.Text)
End Sub

Private Sub txEndDate_LostFocus()
  txEndDate.Text = FormatDate(txEndDate.Text)
End Sub

Private Sub txOnceAt_LostFocus()
  txOnceAt.Text = CheckValueTime(txOnceAt.Text)
  txOnceAt.Text = FormatTime(txOnceAt.Text)
End Sub

Private Sub txOnDate_LostFocus()
  txOnDate.Text = FormatDate(txOnDate.Text)
End Sub

Private Sub txTimeEnd_LostFocus()
  txTimeEnd.Text = CheckValueTime(txTimeEnd.Text)
  txTimeEnd.Text = FormatTime(txTimeEnd.Text)
End Sub

Private Sub CollectData()
  If m_Schedule Is Nothing Then Exit Sub
  
  m_Schedule.Name = txName.Text
  
  If opRunAt.Value Then
    m_Schedule.TypeRun = csSchTypeRunOnce
    m_Schedule.Time = txOnDate.Text & " " & txOnTime.Text
    Exit Sub
  
  ElseIf opDaily.Value Then
    m_Schedule.TypeRun = csSchTypeRunDaily
    m_Schedule.RunDailyInterval = txEach.Text
    
  ElseIf opMonthly.Value Then
  
    If opDay.Value Then
      m_Schedule.TypeRun = csSchTypeRunMonthly
      m_Schedule.RunMonthlyNumberDay = Val(txEach.Text)
      m_Schedule.RunMonthlyInterval = Val(txEachMonth1.Text)
        
    Else
      m_Schedule.TypeRun = csSchTypeRunMonthlyRelative
      m_Schedule.RunMonthlyCardinalDay = GetItemData(cbCardinalDay)
      m_Schedule.RunMonthlyNameDay = GetItemData(cbDayName)
      m_Schedule.RunMonthlyInterval = txEachMonth2.Text
    End If
    
  ElseIf opWeekly.Value Then
    m_Schedule.TypeRun = csSchTypeRunWeekly
    m_Schedule.RunWeeklyInterval = txEach.Text
    m_Schedule.RunSunday = chkSunday.Value = vbChecked
    m_Schedule.RunMonday = chkMonday.Value = vbChecked
    m_Schedule.RunTuesday = chkTuesday.Value = vbChecked
    m_Schedule.RunWednesday = chkWednesday.Value = vbChecked
    m_Schedule.RunThursday = chkThursday.Value = vbChecked
    m_Schedule.RunFriday = chkFriday.Value = vbChecked
    m_Schedule.RunSaturday = chkSaturday.Value = vbChecked
  End If
  
  m_Schedule.TimeStart = txTimeStart.Text
  m_Schedule.TimeEnd = txTimeEnd.Text
  
  If opOnceAt.Value Then
    m_Schedule.TypeTime = csSchTypeTimeAtThisTime
    m_Schedule.TimeStart = txOnceAt.Text
  
  Else
    m_Schedule.TypeTime = csSchTypeTimeRecurring
    m_Schedule.RunEach = txOccursEach.Text
    m_Schedule.RunEachType = GetItemData(cbTimeType)
  End If
  
  m_Schedule.FirtsRunStartAt = txStartDate.Text
  If opEndDate.Value Then
    m_Schedule.LastRunEndAt = txEndDate.Text
  Else
    m_Schedule.LastRunEndAt = csSchEndUndefined
  End If
End Sub

Private Function Validate() As Boolean
  On Error GoTo ControlError
  
  Dim rtn As Boolean
  
  If txName.Text = "" Then
    info "Debe indicar un nombre"
    SetFocusControl txName
    Exit Function
  End If
  
  If opRunAt.Value Then
    rtn = ValidateRunAt()
  Else
    If opDaily.Value Then
      rtn = ValidateDaily()
    ElseIf opWeekly.Value Then
      rtn = ValidateWeekly()
    ElseIf opMonthly.Value Then
      rtn = ValidateMonthly()
    End If
  
    If Not rtn Then Exit Function
    
    If opOnceAt.Value Then
      rtn = ValidateOnceAt()
    Else
      rtn = ValidateOccursEach()
    End If
    
    If Not rtn Then Exit Function
    
    rtn = ValidatePeriod()
    
  End If

  If Not rtn Then Exit Function

  Validate = True

  GoTo ExitProc
ControlError:
  MngError Err, "Validate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function ValidatePeriod() As Boolean
  If Not IsDate(txStartDate.Text) Then
    info "Debe indicar la fecha de inicio para el periodo en el que estará vigente la tarea"
    SetFocusControl txStartDate
    Exit Function
  End If
  
  If opEndDate.Value Then
    If Not IsDate(txEndDate.Text) Then
      info "Debe indicar la fecha de fin para el periodo en el que estará vigente la tarea"
      SetFocusControl txEndDate
      Exit Function
    End If
    
    If DateValue(txEndDate.Text) < DateValue(txStartDate.Text) Then
      info "La fecha de fin del periodo de vigencia de la tarea debe ser mayor o igual a la fecha de inicio"
      SetFocusControl txEndDate
      Exit Function
    End If
  End If
  
  ValidatePeriod = True
End Function

Private Function ValidateOnceAt() As Boolean
  If Not IsDate(txOnceAt.Text) Then
    info "Debe indicar la hora a la que se ejecuta la tarea"
    SetFocusControl txOnceAt
    Exit Function
  End If
  
  ValidateOnceAt = True
End Function

Private Function ValidateOccursEach() As Boolean
  Dim OccursEach As Integer
  
  If GetItemData(cbTimeType) = csSchEachTypeHour Then
  
    If Not IsNumeric(txOccursEach.Text) Then
      info "Debe cada cuantas horas se ejecuta la tarea"
      SetFocusControl txOccursEach
      Exit Function
    End If
    
    OccursEach = txOccursEach.Text
    
    If OccursEach > 12 Then
      info "El rango para el campo 'Ocurre cada' es de 1 a 12"
      SetFocusControl txOccursEach
      Exit Function
    End If
  
  Else
    If Not IsNumeric(txOccursEach.Text) Then
      info "Debe cada cuantos minutos se ejecuta la tarea"
      SetFocusControl txOccursEach
      Exit Function
    End If
    
    OccursEach = txOccursEach.Text
    
    If OccursEach > 59 Then
      info "El rango para el campo 'Ocurre cada' es de 1 a 59"
      SetFocusControl txOccursEach
      Exit Function
    End If
  End If
  
  If Not IsDate(txTimeStart.Text) Then
    info "Debe indicar una hora de inicio"
    SetFocusControl txTimeStart
    Exit Function
  End If
  
  If Not IsDate(txTimeEnd.Text) Then
    info "Debe indicar una hora de finalización"
    SetFocusControl txTimeEnd
    Exit Function
  End If
  
  If TimeValue(txTimeEnd.Text) <= TimeValue(txTimeStart.Text) Then
    info "La hora de finalizacion de la tarea debe ser mayor a la de inicio"
    SetFocusControl txTimeEnd
    Exit Function
  End If
  
  ValidateOccursEach = True
End Function

Private Function ValidateRunAt() As Boolean
  Dim DateAndTime As Date
  Dim Time        As Date
  
  If Not IsDate(txOnDate.Text) Then
    info "Debe indicar una fecha valida para la tarea"
    SetFocusControl txOnDate
    Exit Function
  End If
  
  If Not IsDate(txOnTime.Text) Then
    info "Debe indicar una hora valida para la tarea"
    SetFocusControl txOnTime
    Exit Function
  End If
  
  DateAndTime = DateValue(txOnDate.Text)
  Time = TimeValue(txOnTime.Text)
  DateAndTime = DateAdd("h", Hour(Time), DateAndTime)
  DateAndTime = DateAdd("n", Minute(Time), DateAndTime)
  
  If DateAndTime < Date Then
    info "La fecha de la tarea debe ser mayor a hoy"
    SetFocusControl txOnDate
    Exit Function
  End If

  If DateAndTime < Now Then
    info "La hora de la tarea debe ser mayor a " & FormatTime(Now)
    SetFocusControl txOnTime
    Exit Function
  End If
  
  ValidateRunAt = True
End Function

Private Function ValidateDaily() As Boolean
  If Not IsNumeric(txEach.Text) Then
    info "Debe indicar el día"
    SetFocusControl txEach
    Exit Function
  End If
  
  ValidateDaily = True
End Function

Private Function ValidateWeekly() As Boolean
  Dim chk As Boolean
  
  If Not IsNumeric(txEach.Text) Then
    info "Debe indicar el día"
    SetFocusControl txEach
    Exit Function
  End If
  
  chk = chk Or chkFriday.Value <> vbUnchecked
  chk = chk Or chkMonday.Value <> vbUnchecked
  chk = chk Or chkSaturday.Value <> vbUnchecked
  chk = chk Or chkSunday.Value <> vbUnchecked
  chk = chk Or chkTuesday.Value <> vbUnchecked
  chk = chk Or chkThursday.Value <> vbUnchecked
  chk = chk Or chkWednesday.Value <> vbUnchecked
  
  If Not chk Then
    info "Debe seleccionar al menos un dia"
    SetFocusControl chkSunday
    Exit Function
  End If
  
  ValidateWeekly = True
End Function

Private Function ValidateMonthly() As Boolean
  If opDay.Value Then
    If Not IsNumeric(txEach.Text) Then
      info "Debe indicar el día"
      SetFocusControl txEach
      Exit Function
    End If
    If Not IsNumeric(txEachMonth1.Text) Then
      info "Debe indicar cada cuantos mese(s) se repite la tarea"
      SetFocusControl txEachMonth1
      Exit Function
    End If
  Else
    If Not IsNumeric(txEachMonth2.Text) Then
      info "Debe indicar cada cuantos mese(s) se repite la tarea"
      SetFocusControl txEachMonth2
      Exit Function
    End If
  End If
  
  ValidateMonthly = True
End Function

Private Sub ShowData()
  If m_Schedule Is Nothing Then Exit Sub
  
  txName.Text = m_Schedule.Name
  
  Select Case m_Schedule.TypeRun
    
    Case csSchTypeRunOnce
      opRunAt.Value = True
      opRunAt_Click
      txOnDate.Text = FormatDate(m_Schedule.Time)
      txOnTime.Text = FormatTime(m_Schedule.Time)
      Exit Sub
      
    Case csSchTypeRunDaily
      opDaily.Value = True
      opDaily_Click
      txEach.Text = m_Schedule.RunDailyInterval
    
    Case csSchTypeRunMonthly
      opMonthly.Value = True
      opMonthly_Click
      opDay.Value = True
      opDay_Click
      txEach.Text = m_Schedule.RunMonthlyNumberDay
      txEachMonth1.Text = m_Schedule.RunMonthlyInterval
    
    Case csSchTypeRunMonthlyRelative
      opMonthly.Value = True
      opMonthly_Click
      opCardinalDay.Value = True
      opCardinalDay_Click
      SelectItemByItemData cbCardinalDay, m_Schedule.RunMonthlyCardinalDay
      SelectItemByItemData cbDayName, m_Schedule.RunMonthlyNameDay
      txEachMonth2.Text = m_Schedule.RunMonthlyInterval
    
    Case csSchTypeRunWeekly
      opWeekly.Value = True
      opWeekly_Click
      txEach.Text = m_Schedule.RunWeeklyInterval
      chkSunday.Value = IIf(m_Schedule.RunSunday, vbChecked, vbUnchecked)
      chkMonday.Value = IIf(m_Schedule.RunMonday, vbChecked, vbUnchecked)
      chkTuesday.Value = IIf(m_Schedule.RunTuesday, vbChecked, vbUnchecked)
      chkWednesday.Value = IIf(m_Schedule.RunWednesday, vbChecked, vbUnchecked)
      chkThursday.Value = IIf(m_Schedule.RunThursday, vbChecked, vbUnchecked)
      chkFriday.Value = IIf(m_Schedule.RunFriday, vbChecked, vbUnchecked)
      chkSaturday.Value = IIf(m_Schedule.RunSaturday, vbChecked, vbUnchecked)
  End Select
  
  txTimeStart.Text = FormatTime(m_Schedule.TimeStart)
  txTimeEnd.Text = FormatTime(m_Schedule.TimeEnd)
  
  If m_Schedule.TypeTime = csSchTypeTimeAtThisTime Then
    opOnceAt.Value = True
    opOnceAt_Click
    txOnceAt.Text = m_Schedule.TimeStart
  
  ElseIf m_Schedule.TypeTime = csSchTypeTimeRecurring Then
    opOccursEach.Value = True
    opOccursEach_Click
    txOccursEach.Text = m_Schedule.RunEach
    SelectItemByItemData cbTimeType, m_Schedule.RunEachType
  End If
  
  txStartDate.Text = FormatDate(m_Schedule.FirtsRunStartAt)
  txEndDate.Text = FormatDate(m_Schedule.LastRunEndAt)
  If m_Schedule.LastRunEndAt <> csSchEndUndefined Then
    opEndDate.Value = True
    opEndDate_Click
  Else
    opEndDateNever.Value = True
    opEndDateNever_Click
  End If
  
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  opRunRecurring.Value = True
  opRunRecurring_Click

  opDaily.Value = True
  opDaily_Click
  
  opOnceAt.Value = True
  opOnceAt_Click
  
  opEndDateNever.Value = True
  opEndDateNever_Click
  
  txEach.Text = "1"
  txEachMonth1.Text = "1"
  txEachMonth2.Text = "1"
  txOccursEach.Text = "1"
  txStartDate.Text = FormatDate(Now)
  txOnDate.Text = FormatDate(Now)
  txOnceAt.Text = FormatTime(Now)
  txOnTime.Text = FormatTime(Now)
  txEndDate.Text = FormatDate(Now)
  
  txTimeStart.Text = FormatTime("06:00")
  txTimeEnd.Text = FormatTime("22:00")
  
  AddItemToList cbTimeType, "Minuto(s)", csScheduleEachType.csSchEachTypeMinute
  AddItemToList cbTimeType, "Hora(s)", csScheduleEachType.csSchEachTypeHour
  SelectItemByItemData cbTimeType, csScheduleEachType.csSchEachTypeHour
  
  AddItemToList cbCardinalDay, "1ro", csScheduleRunMonthlyCardinal.csSchRunMonCard_1st
  AddItemToList cbCardinalDay, "2do", csScheduleRunMonthlyCardinal.csSchRunMonCard_2nd
  AddItemToList cbCardinalDay, "3ro", csScheduleRunMonthlyCardinal.csSchRunMonCard_3rd
  AddItemToList cbCardinalDay, "4to", csScheduleRunMonthlyCardinal.csSchRunMonCard_4th
  AddItemToList cbCardinalDay, "Ultimo", csScheduleRunMonthlyCardinal.csSchRunMonCard_Last
  SelectItemByItemData cbCardinalDay, csScheduleRunMonthlyCardinal.csSchRunMonCard_1st
  
  AddItemToList cbDayName, "Domingo", csScheduleRunMonthlyName.csSchRunMonName_Sunday
  AddItemToList cbDayName, "Lunes", csScheduleRunMonthlyName.csSchRunMonName_Monday
  AddItemToList cbDayName, "Martes", csScheduleRunMonthlyName.csSchRunMonName_Tuesday
  AddItemToList cbDayName, "Miercoles", csScheduleRunMonthlyName.csSchRunMonName_Wednesday
  AddItemToList cbDayName, "Jueves", csScheduleRunMonthlyName.csSchRunMonName_Thursday
  AddItemToList cbDayName, "Viernes", csScheduleRunMonthlyName.csSchRunMonName_FriDay
  AddItemToList cbDayName, "Sabado", csScheduleRunMonthlyName.csSchRunMonName_Saturday
  SelectItemByItemData cbDayName, csScheduleRunMonthlyName.csSchRunMonName_Sunday
  
  ShowData
  
  FormCenter Me
  
  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub


'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

