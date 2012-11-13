VERSION 5.00
Begin VB.UserControl cCalendar 
   ClientHeight    =   4155
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   3645
   ScaleHeight     =   4155
   ScaleWidth      =   3645
   Begin VB.ComboBox cbYear 
      Height          =   315
      Left            =   2280
      Style           =   2  'Dropdown List
      TabIndex        =   7
      Top             =   160
      Width           =   1035
   End
   Begin VB.ComboBox cbMonth 
      Height          =   315
      Left            =   240
      Style           =   2  'Dropdown List
      TabIndex        =   6
      Top             =   160
      Width           =   1995
   End
   Begin VB.PictureBox picMonth 
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'None
      ClipControls    =   0   'False
      Height          =   2295
      Left            =   120
      ScaleHeight     =   2295
      ScaleWidth      =   3315
      TabIndex        =   0
      Top             =   1200
      Width           =   3315
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Dom  Lun  Mar  Mié  Jue   Vie  Sab"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   195
      Left            =   240
      TabIndex        =   8
      Top             =   960
      Width           =   3315
   End
   Begin VB.Label lblPrev 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "<<"
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
      TabIndex        =   5
      Top             =   540
      Width           =   315
   End
   Begin VB.Label lblNext 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   ">>"
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
      Left            =   2700
      TabIndex        =   4
      Top             =   540
      Width           =   315
   End
   Begin VB.Shape Shape3 
      BorderColor     =   &H000000FF&
      BorderWidth     =   2
      Height          =   330
      Left            =   1320
      Shape           =   3  'Circle
      Top             =   3645
      Width           =   330
   End
   Begin VB.Label lbTodayNumber 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "31"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   1380
      TabIndex        =   3
      Top             =   3690
      Width           =   255
   End
   Begin VB.Label lbToday 
      BackStyle       =   0  'Transparent
      Caption         =   "Miercoles"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   240
      TabIndex        =   2
      Top             =   3690
      Width           =   1035
   End
   Begin VB.Shape Shape2 
      BackColor       =   &H00FFFFFF&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H80000010&
      Height          =   435
      Left            =   120
      Top             =   3600
      Width           =   1655
   End
   Begin VB.Label lblMonth 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Septiembre 2004"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   600
      TabIndex        =   1
      Top             =   495
      Width           =   2115
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H80000014&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H80000010&
      Height          =   795
      Left            =   60
      Top             =   60
      Width           =   3435
   End
End
Attribute VB_Name = "cCalendar"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'Calendar - Calendar demo program
'Copyright (c) 1997 SoftCircuits Programming (R)
'Redistributed by Permission.
'
'This example program demonstrates how to create a mini calendar in
'Visual Basic 5.0. It takes advantage of the changes made to VB in
'version 4 that allow forms to have public methods and properties.
'Although the Calendar form contains a fair amount of code, you can
'take advantage of all of its features by calling the single method,
'GetDate().
'
'This program may be distributed on the condition that it is
'distributed in full and unchanged, and that no fee is charged for
'such distribution with the exception of reasonable shipping and media
'charged. In addition, the code in this program may be incorporated
'into your own programs and the resulting programs may be distributed
'without payment of royalties.
'
'This example program was provided by:
' SoftCircuits Programming
' http://www.softcircuits.com
' P.O. Box 16262
' Irvine, CA 92623
Option Explicit

'Grid dimensions for days
Private Const GRID_ROWS = 6
Private Const GRID_COLS = 7

'Private variables
Private m_CurrDate As Date
Private m_nGridWidth As Integer, m_nGridHeight As Integer
Private m_BackColor  As Long

Private m_SettingDate As Boolean

'Private m_cFlattenMonth As cFlatControl
'Private m_cFlattenYear  As cFlatControl

Public Event DblClick()

Public Property Let BackColor(ByVal RHS As Long)
  m_BackColor = RHS
  picMonth.BackColor = RHS
End Property

Public Property Get vDay() As Long
  vDay = Day(m_CurrDate)
End Property

Public Property Get vMonth() As Long
  vMonth = Month(m_CurrDate)
End Property

Public Property Get vYear() As Long
  vYear = Year(m_CurrDate)
End Property

'Public function: If user selects date, sets UserDate to selected
'date and returns True. Otherwise, returns False.
Public Function GetDate(ByVal UserDate As Date) As Boolean
  ' 2 = 1-1-1900
  If CLng(UserDate) = 2 Then UserDate = Date
  SetNewDate UserDate
End Function

Private Sub cbMonth_Click()
  On Error Resume Next
  SetNewDateEx
End Sub

Private Sub cbYear_Click()
  On Error Resume Next
  SetNewDateEx
End Sub

Private Sub SetNewDateEx()
  On Error Resume Next
  If m_SettingDate Then Exit Sub
  
  Dim NewDate As Date
  
  Dim d As Long
  Dim m As Long
  Dim y As Long
  
  d = Day(m_CurrDate)
  m = cbMonth.ListIndex + 1
  y = Val(cbYear.Text)
  
  NewDate = DateSerial(y, m, d)
  
  SetNewDate NewDate
End Sub

'Form initialization
Private Sub UserControl_Initialize()
  BackColor = vbWhite

  'Calculate calendar grid measurements
  m_nGridWidth = ((picMonth.ScaleWidth - Screen.TwipsPerPixelX) \ GRID_COLS)
  m_nGridHeight = ((picMonth.ScaleHeight - Screen.TwipsPerPixelY) \ GRID_ROWS)
  
'  Set m_cFlattenMonth = New cFlatControl
'  m_cFlattenMonth.Attach cbMonth
'
'  Set m_cFlattenYear = New cFlatControl
'  m_cFlattenYear.Attach cbYear
  
  Dim i As Integer
  
  m_SettingDate = True
  
  For i = 1900 To 2200
    cbYear.AddItem Trim$(i)
  Next
  
  For i = 1 To 12
    cbMonth.AddItem Format(DateSerial(2000, i, 1), "mmmm")
  Next
  
  lbToday.Caption = Format(Date, "dddd")
  lbTodayNumber.Caption = Day(Date)
  
  m_SettingDate = False
  
  SetNewDate Date
End Sub

'Process user keystrokes
Private Sub picMonth_KeyDown(KeyCode As Integer, Shift As Integer)
  Dim NewDate As Date
  
  Select Case KeyCode
    Case vbKeyRight
      NewDate = DateAdd("d", 1, m_CurrDate)
    Case vbKeyLeft
      NewDate = DateAdd("d", -1, m_CurrDate)
    Case vbKeyDown
      NewDate = DateAdd("ww", 1, m_CurrDate)
    Case vbKeyUp
      NewDate = DateAdd("ww", -1, m_CurrDate)
    Case vbKeyPageDown
      NewDate = DateAdd("m", 1, m_CurrDate)
    Case vbKeyPageUp
      NewDate = DateAdd("m", -1, m_CurrDate)
    Case vbKeyReturn
      picMonth_DblClick
      Exit Sub
    Case vbKeyEscape
      Exit Sub
    Case Else
      Exit Sub
  End Select
  SetNewDate NewDate
  KeyCode = 0
End Sub

'Double-click accepts current date
Private Sub picMonth_DblClick()
  RaiseEvent DblClick
End Sub

' Select the date by mouse
Private Sub picMonth_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
  Dim i As Integer, MaxDay As Integer

  'Determine which date is being clicked
  i = Weekday(DateSerial(Year(m_CurrDate), Month(m_CurrDate), 1)) - 1
  i = (((x \ m_nGridWidth) + 1) + ((y \ m_nGridHeight) * GRID_COLS)) - i
  'Get last day of current month
  MaxDay = Day(DateAdd("d", -1, DateSerial(Year(m_CurrDate), Month(m_CurrDate) + 1, 1)))
  If i >= 1 And i <= MaxDay Then
    SetNewDate DateSerial(Year(m_CurrDate), Month(m_CurrDate), i)
  End If
End Sub

'Click on ">>" goes to next month
Private Sub lblNext_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
  If Button And vbLeftButton Then
    SetNewDate DateAdd("m", 1, m_CurrDate)
  End If
End Sub

'Double-click has same effect
Private Sub lblNext_DblClick()
  SetNewDate DateAdd("m", 1, m_CurrDate)
End Sub

'Click on "<<" goes to previous month
Private Sub lblPrev_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
  If Button And vbLeftButton Then
    SetNewDate DateAdd("m", -1, m_CurrDate)
  End If
End Sub

'Double-click has same effect
Private Sub lblPrev_DblClick()
  SetNewDate DateAdd("m", -1, m_CurrDate)
End Sub

'Changes the selected date
Private Sub SetNewDate(NewDate As Date)
  m_SettingDate = True
  
  If Month(m_CurrDate) = Month(NewDate) And Year(m_CurrDate) = Year(NewDate) Then
    DrawSelectionBox False
    m_CurrDate = NewDate
    DrawSelectionBox True
  Else
    m_CurrDate = NewDate
    picMonth_Paint
  End If
  
  On Error Resume Next
  cbYear.ListIndex = Year(m_CurrDate) - 1900
  cbMonth.ListIndex = Month(m_CurrDate) - 1
  m_SettingDate = False
End Sub

'Here's the calendar paint handler; displayes the calendar days
Private Sub picMonth_Paint()
  Dim i As Integer, j As Integer, x As Integer, y As Integer
  Dim NumDays As Integer, CurrPos As Integer, bCurrMonth As Boolean
  Dim MonthStart As Date, buffer As String
  
  'Determine if this month is today's month
  If Month(m_CurrDate) = Month(Date) And Year(m_CurrDate) = Year(Date) Then
    bCurrMonth = True
  End If
  'Get first date in the month
  MonthStart = DateSerial(Year(m_CurrDate), Month(m_CurrDate), 1)
  'Number of days in the month
  NumDays = DateDiff("d", MonthStart, DateAdd("m", 1, MonthStart))
  'Get first weekday in the month (0 - based)
  j = Weekday(MonthStart) - 1
  'Tweak for 1-based For/Next index
  j = j - 1
  'Show current month/year
  lblMonth = Format$(m_CurrDate, "mmmm yyyy")
  'Clear existing data
  picMonth.Cls
  'Display dates for current month
  For i = 1 To NumDays
    CurrPos = i + j
    x = (CurrPos Mod GRID_COLS) * m_nGridWidth
    y = (CurrPos \ GRID_COLS) * m_nGridHeight
    'Show date as bold if today's date
    If bCurrMonth And i = Day(Date) Then
      picMonth.Font.Bold = True
    Else
      picMonth.Font.Bold = False
    End If
    'Center date within "date cell"
    buffer = CStr(i)
    picMonth.CurrentX = x + ((m_nGridWidth - picMonth.TextWidth(buffer)) / 2)
    picMonth.CurrentY = y + ((m_nGridHeight - picMonth.TextHeight(buffer)) / 2)
    'Print date
    picMonth.Print buffer;
  Next i
  'Indicate selected date
  DrawSelectionBox True
End Sub

'Draw or clears the selection box around the current date
Private Sub DrawSelectionBox(bSelected As Boolean)
  Dim clrTopLeft As Long, clrBottomRight As Long
  Dim i As Integer, x As Integer, y As Integer

  'Set highlight and shadow colors
  If bSelected Then
    clrTopLeft = vbButtonShadow
    clrBottomRight = vbButtonShadow
  Else
    clrTopLeft = m_BackColor
    clrBottomRight = m_BackColor
  End If
  'Compute location for current date
  i = Weekday(DateSerial(Year(m_CurrDate), Month(m_CurrDate), 1)) - 1
  i = i + (Day(m_CurrDate) - 1)
  x = (i Mod GRID_COLS) * m_nGridWidth
  y = (i \ GRID_COLS) * m_nGridHeight
  'Draw box around date
  picMonth.Line (x, y + m_nGridHeight)-Step(0, -m_nGridHeight), clrTopLeft
  picMonth.Line -Step(m_nGridWidth, 0), clrTopLeft
  picMonth.Line -Step(0, m_nGridHeight), clrBottomRight
  picMonth.Line -Step(-m_nGridWidth, 0), clrBottomRight
End Sub
