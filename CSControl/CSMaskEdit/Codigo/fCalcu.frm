VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Begin VB.Form fCalc 
   Appearance      =   0  'Flat
   BackColor       =   &H80000010&
   BorderStyle     =   0  'None
   ClientHeight    =   2445
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   1950
   ControlBox      =   0   'False
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2445
   ScaleWidth      =   1950
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin CSButton.cButton cmdNumber 
      Height          =   330
      Index           =   9
      Left            =   1035
      TabIndex        =   1
      Top             =   450
      Width           =   375
      _ExtentX        =   661
      _ExtentY        =   582
      Caption         =   "9"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontBold        =   -1  'True
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
   End
   Begin CSButton.cButton cmdNumber 
      Height          =   330
      Index           =   0
      Left            =   45
      TabIndex        =   2
      Top             =   1665
      Width           =   870
      _ExtentX        =   1535
      _ExtentY        =   582
      Caption         =   "0"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontBold        =   -1  'True
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
   End
   Begin CSButton.cButton cmdNumber 
      Height          =   330
      Index           =   1
      Left            =   45
      TabIndex        =   3
      Top             =   1260
      Width           =   375
      _ExtentX        =   661
      _ExtentY        =   582
      Caption         =   "1"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontBold        =   -1  'True
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
   End
   Begin CSButton.cButton cmdNumber 
      Height          =   330
      Index           =   2
      Left            =   540
      TabIndex        =   4
      Top             =   1260
      Width           =   375
      _ExtentX        =   661
      _ExtentY        =   582
      Caption         =   "2"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontBold        =   -1  'True
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
   End
   Begin CSButton.cButton cmdNumber 
      Height          =   330
      Index           =   3
      Left            =   1035
      TabIndex        =   5
      Top             =   1260
      Width           =   375
      _ExtentX        =   661
      _ExtentY        =   582
      Caption         =   "3"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontBold        =   -1  'True
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
   End
   Begin CSButton.cButton cmdNumber 
      Height          =   330
      Index           =   4
      Left            =   45
      TabIndex        =   6
      Top             =   855
      Width           =   375
      _ExtentX        =   661
      _ExtentY        =   582
      Caption         =   "4"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontBold        =   -1  'True
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
   End
   Begin CSButton.cButton cmdNumber 
      Height          =   330
      Index           =   5
      Left            =   540
      TabIndex        =   7
      Top             =   855
      Width           =   375
      _ExtentX        =   661
      _ExtentY        =   582
      Caption         =   "5"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontBold        =   -1  'True
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
   End
   Begin CSButton.cButton cmdNumber 
      Height          =   330
      Index           =   6
      Left            =   1035
      TabIndex        =   8
      Top             =   855
      Width           =   375
      _ExtentX        =   661
      _ExtentY        =   582
      Caption         =   "6"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontBold        =   -1  'True
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
   End
   Begin CSButton.cButton cmdNumber 
      Height          =   330
      Index           =   7
      Left            =   45
      TabIndex        =   9
      Top             =   450
      Width           =   375
      _ExtentX        =   661
      _ExtentY        =   582
      Caption         =   "7"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontBold        =   -1  'True
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
   End
   Begin CSButton.cButton cmdNumber 
      Height          =   330
      Index           =   8
      Left            =   540
      TabIndex        =   10
      Top             =   450
      Width           =   375
      _ExtentX        =   661
      _ExtentY        =   582
      Caption         =   "8"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontBold        =   -1  'True
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
   End
   Begin CSButton.cButton cmdPlus 
      Height          =   330
      Left            =   1530
      TabIndex        =   11
      Top             =   1260
      Width           =   375
      _ExtentX        =   661
      _ExtentY        =   582
      Caption         =   "+"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontBold        =   -1  'True
      FontName        =   "MS Sans Serif"
      FontSize        =   12
   End
   Begin CSButton.cButton cmdDivide 
      Height          =   330
      Left            =   1530
      TabIndex        =   12
      Top             =   1665
      Width           =   375
      _ExtentX        =   661
      _ExtentY        =   582
      Caption         =   "/"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontBold        =   -1  'True
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
   End
   Begin CSButton.cButton cmdMultiply 
      Height          =   330
      Left            =   1530
      TabIndex        =   13
      Top             =   450
      Width           =   375
      _ExtentX        =   661
      _ExtentY        =   582
      Caption         =   "*"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontBold        =   -1  'True
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
   End
   Begin CSButton.cButton cmdMinus 
      Height          =   330
      Left            =   1530
      TabIndex        =   14
      Top             =   855
      Width           =   375
      _ExtentX        =   661
      _ExtentY        =   582
      Caption         =   "-"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontBold        =   -1  'True
      FontName        =   "MS Sans Serif"
      FontSize        =   12
   End
   Begin CSButton.cButton cmdPoint 
      Height          =   330
      Left            =   1035
      TabIndex        =   15
      Top             =   1665
      Width           =   375
      _ExtentX        =   661
      _ExtentY        =   582
      Caption         =   "i"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Marlett"
         Size            =   9.75
         Charset         =   2
         Weight          =   500
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "Marlett"
      FontSize        =   9.75
   End
   Begin CSButton.cButton cmdPlusMinus 
      Height          =   330
      Left            =   45
      TabIndex        =   16
      Top             =   2070
      Width           =   375
      _ExtentX        =   661
      _ExtentY        =   582
      Caption         =   "+/-"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontBold        =   -1  'True
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
   End
   Begin CSButton.cButton cmdClear 
      Height          =   330
      Left            =   540
      TabIndex        =   17
      Top             =   2070
      Width           =   375
      _ExtentX        =   661
      _ExtentY        =   582
      Caption         =   "C"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontBold        =   -1  'True
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
   End
   Begin CSButton.cButton cmdIqual 
      Height          =   330
      Left            =   1035
      TabIndex        =   18
      Top             =   2070
      Width           =   870
      _ExtentX        =   1535
      _ExtentY        =   582
      Caption         =   "="
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontBold        =   -1  'True
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
   End
   Begin VB.Shape Shape2 
      BorderColor     =   &H80000010&
      Height          =   330
      Left            =   45
      Top             =   45
      Width           =   1860
   End
   Begin VB.Label LbDisplay 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      BackColor       =   &H80000016&
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   330
      Left            =   45
      TabIndex        =   0
      Top             =   45
      Width           =   1860
   End
   Begin VB.Shape Shape1 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H80000014&
      BorderStyle     =   0  'Transparent
      Height          =   2435
      Left            =   15
      Top             =   15
      Width           =   1935
   End
End
Attribute VB_Name = "fCalc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const KEY_RESULT = -1
Private Const SIGN_CHANGE = -2
Private Const KEY_DECIMAL = -3
Private Const KEY_ADD = 43
Private Const KEY_SUSTRACT = 45
Private Const KEY_MULTIPLY = 42
Private Const KEY_DIVIDE = 47

Public Cancel As Boolean

Private m_Result    As Double
Private m_Operation As Integer
Private m_Clear     As Boolean
Private m_Sign      As Boolean

Private Sub cmdNumber_Click(Index As Integer)
  On Error Resume Next
  KeyProcess vbKey0 + Index
End Sub

Private Sub Form_Activate()
  On Error Resume Next
  cmdIqual.SetFocus
End Sub

Private Sub Form_Load()
  On Error Resume Next
  m_Result = 0
  m_Operation = KEY_ADD
  m_Clear = False
  LbDisplay.Caption = "0"
  m_Sign = False
  Cancel = False
End Sub

Private Sub cmdClear_Click()
  On Error Resume Next
  LbDisplay.Caption = "0"
  m_Result = 0
  m_Operation = KEY_ADD
  m_Clear = False
End Sub

Private Sub cmdPlusMinus_Click()
  On Error Resume Next
  
  m_Sign = Not m_Sign
  
  With LbDisplay
    
    If m_Sign Then
      .ForeColor = vbRed
    Else
      .ForeColor = &H80000008
    End If
    
    ' si le cambia el signo al resultado
    If m_Clear Then
      m_Result = m_Result * -1
      .Caption = m_Result
      
      If m_Result < 0 Then
        .ForeColor = vbRed
      Else
        .ForeColor = &H80000008
      End If
    End If
  End With
End Sub

Private Sub cmdPlus_Click()
  On Error Resume Next
  KeyProcess KEY_ADD
End Sub

Private Sub cmdPoint_Click()
  On Error Resume Next
  KeyProcess KEY_DECIMAL
End Sub


Private Sub cmdDivide_Click()
  On Error Resume Next
  KeyProcess KEY_DIVIDE
End Sub


Private Sub cmdMultiply_Click()
  On Error Resume Next
  KeyProcess KEY_MULTIPLY
End Sub

Private Sub cmdMinus_Click()
  On Error Resume Next
  KeyProcess KEY_SUSTRACT
End Sub

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  
  With LbDisplay
    Select Case KeyCode
      Case vbKeySeparator, vbKeyReturn
        KeyProcess KEY_RESULT
      Case vbKeyBack
        .Caption = Left(.Caption, Len(.Caption) - 1)
      Case vbKeyDelete
        .Caption = ""
      Case vbKeyEscape
        Cancel = True
        Me.Hide
    End Select
  End With
End Sub

Private Sub Form_KeyPress(KeyAscii As Integer)
  On Error Resume Next
  Select Case KeyAscii
    Case vbKey0 To vbKey9, KEY_ADD, KEY_SUSTRACT, KEY_MULTIPLY, KEY_DIVIDE
      KeyProcess KeyAscii
      
      ' PUNTO =46 COMA =44
    Case 46, 44
      KeyProcess KEY_DECIMAL
  End Select
End Sub

Private Sub cmdIqual_Click()
  On Error Resume Next
  KeyProcess KEY_RESULT
End Sub

Private Sub KeyProcess(ByVal nnumero As Integer)
  
  ' Para que el enter siempre signifique igual(=)
  cmdIqual.SetFocus
  
  With LbDisplay

    Select Case nnumero
      Case vbKey0 To vbKey9
        If m_Clear Then
          .Caption = ""
          m_Clear = False
          ' El proximo numero sera positivo
          m_Sign = False
          .ForeColor = &H80000008
        End If
  
        .Caption = .Caption + Chr(nnumero)
  
      Case KEY_DECIMAL
        If m_Clear Then
          .Caption = ""
          m_Clear = False
          ' El proximo numero sera positivo
          m_Sign = False
          .ForeColor = &H80000008
        End If
  
        
        If InStr(LbDisplay, GetSepDecimal()) = 0 Then
          If .Caption = "" Then .Caption = "0"
          .Caption = .Caption + GetSepDecimal()
        End If
        
      Case KEY_ADD, KEY_SUSTRACT, KEY_MULTIPLY, KEY_DIVIDE, KEY_RESULT
        Process nnumero
    End Select
    
    If InStr(.Caption, GetSepDecimal()) = 0 Then
      .Caption = Format(.Caption, "0")
    End If
  
  End With
End Sub

Private Sub Process(ByVal nOperacion As Integer)
  With LbDisplay
    If Trim(.Caption) = "" Then .Caption = "0"
    
    If m_Sign Then
      .Caption = .Caption * -1
    End If
  
    Select Case m_Operation
      Case KEY_ADD
        m_Result = m_Result + .Caption
      Case KEY_SUSTRACT
        m_Result = m_Result - .Caption
      Case KEY_MULTIPLY
        m_Result = m_Result * .Caption
      Case KEY_DIVIDE
        m_Result = m_Result / .Caption
    End Select
    
    m_Sign = False
    m_Clear = True
    .Caption = m_Result
    
    m_Operation = nOperacion
    
    If nOperacion = KEY_RESULT Then
      Process KEY_ADD
      m_Result = 0
      m_Clear = True
      Me.Hide
    End If
  End With
End Sub
