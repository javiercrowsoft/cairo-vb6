VERSION 5.00
Begin VB.Form FrmAsistenteProperty 
   Caption         =   "Form1"
   ClientHeight    =   6405
   ClientLeft      =   60
   ClientTop       =   300
   ClientWidth     =   11430
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   6405
   ScaleWidth      =   11430
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton Command3 
      Caption         =   "Copiar"
      Height          =   375
      Left            =   5040
      TabIndex        =   51
      Top             =   6000
      Width           =   1695
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Limpiar"
      Height          =   375
      Left            =   2040
      TabIndex        =   50
      Top             =   6000
      Width           =   1695
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Check1"
      Height          =   255
      Index           =   15
      Left            =   3840
      TabIndex        =   47
      Top             =   5640
      Width           =   255
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Check1"
      Height          =   255
      Index           =   14
      Left            =   3840
      TabIndex        =   44
      Top             =   5280
      Width           =   255
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Check1"
      Height          =   255
      Index           =   13
      Left            =   3840
      TabIndex        =   41
      Top             =   4920
      Width           =   255
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Check1"
      Height          =   255
      Index           =   12
      Left            =   3840
      TabIndex        =   38
      Top             =   4560
      Width           =   255
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Check1"
      Height          =   255
      Index           =   11
      Left            =   3840
      TabIndex        =   35
      Top             =   4200
      Width           =   255
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Check1"
      Height          =   255
      Index           =   10
      Left            =   3840
      TabIndex        =   32
      Top             =   3840
      Width           =   255
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Check1"
      Height          =   255
      Index           =   9
      Left            =   3840
      TabIndex        =   29
      Top             =   3480
      Width           =   255
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Check1"
      Height          =   255
      Index           =   8
      Left            =   3840
      TabIndex        =   26
      Top             =   3120
      Width           =   255
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Check1"
      Height          =   255
      Index           =   7
      Left            =   3840
      TabIndex        =   23
      Top             =   2760
      Width           =   255
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Check1"
      Height          =   255
      Index           =   6
      Left            =   3840
      TabIndex        =   20
      Top             =   2400
      Width           =   255
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Check1"
      Height          =   255
      Index           =   5
      Left            =   3840
      TabIndex        =   17
      Top             =   2040
      Width           =   255
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Check1"
      Height          =   255
      Index           =   4
      Left            =   3840
      TabIndex        =   14
      Top             =   1680
      Width           =   255
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Check1"
      Height          =   255
      Index           =   3
      Left            =   3840
      TabIndex        =   11
      Top             =   1320
      Width           =   255
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Check1"
      Height          =   255
      Index           =   2
      Left            =   3840
      TabIndex        =   8
      Top             =   960
      Width           =   255
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Check1"
      Height          =   255
      Index           =   1
      Left            =   3840
      TabIndex        =   5
      Top             =   600
      Width           =   255
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Check1"
      Height          =   255
      Index           =   0
      Left            =   3840
      TabIndex        =   2
      Top             =   240
      Width           =   255
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Generar"
      Height          =   375
      Left            =   240
      TabIndex        =   49
      Top             =   6000
      Width           =   1695
   End
   Begin VB.TextBox Text2 
      Height          =   5655
      Left            =   4200
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   48
      Top             =   240
      Width           =   7095
   End
   Begin VB.ComboBox Combo1 
      Height          =   315
      Index           =   15
      ItemData        =   "FrmAsistenteProperty.frx":0000
      Left            =   2040
      List            =   "FrmAsistenteProperty.frx":0016
      TabIndex        =   46
      Text            =   "Combo1"
      Top             =   5640
      Width           =   1695
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   15
      Left            =   240
      TabIndex        =   45
      Top             =   5640
      Width           =   1695
   End
   Begin VB.ComboBox Combo1 
      Height          =   315
      Index           =   14
      ItemData        =   "FrmAsistenteProperty.frx":004A
      Left            =   2040
      List            =   "FrmAsistenteProperty.frx":0060
      TabIndex        =   43
      Text            =   "Combo1"
      Top             =   5280
      Width           =   1695
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   14
      Left            =   240
      TabIndex        =   42
      Top             =   5280
      Width           =   1695
   End
   Begin VB.ComboBox Combo1 
      Height          =   315
      Index           =   13
      ItemData        =   "FrmAsistenteProperty.frx":0094
      Left            =   2040
      List            =   "FrmAsistenteProperty.frx":00AA
      TabIndex        =   40
      Text            =   "Combo1"
      Top             =   4920
      Width           =   1695
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   13
      Left            =   240
      TabIndex        =   39
      Top             =   4920
      Width           =   1695
   End
   Begin VB.ComboBox Combo1 
      Height          =   315
      Index           =   12
      ItemData        =   "FrmAsistenteProperty.frx":00DE
      Left            =   2040
      List            =   "FrmAsistenteProperty.frx":00F4
      TabIndex        =   37
      Text            =   "Combo1"
      Top             =   4560
      Width           =   1695
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   12
      Left            =   240
      TabIndex        =   36
      Top             =   4560
      Width           =   1695
   End
   Begin VB.ComboBox Combo1 
      Height          =   315
      Index           =   11
      ItemData        =   "FrmAsistenteProperty.frx":0128
      Left            =   2040
      List            =   "FrmAsistenteProperty.frx":013E
      TabIndex        =   34
      Text            =   "Combo1"
      Top             =   4200
      Width           =   1695
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   11
      Left            =   240
      TabIndex        =   33
      Top             =   4200
      Width           =   1695
   End
   Begin VB.ComboBox Combo1 
      Height          =   315
      Index           =   10
      ItemData        =   "FrmAsistenteProperty.frx":0172
      Left            =   2040
      List            =   "FrmAsistenteProperty.frx":0188
      TabIndex        =   31
      Text            =   "Combo1"
      Top             =   3840
      Width           =   1695
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   10
      Left            =   240
      TabIndex        =   30
      Top             =   3840
      Width           =   1695
   End
   Begin VB.ComboBox Combo1 
      Height          =   315
      Index           =   9
      ItemData        =   "FrmAsistenteProperty.frx":01BC
      Left            =   2040
      List            =   "FrmAsistenteProperty.frx":01D2
      TabIndex        =   28
      Text            =   "Combo1"
      Top             =   3480
      Width           =   1695
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   9
      Left            =   240
      TabIndex        =   27
      Top             =   3480
      Width           =   1695
   End
   Begin VB.ComboBox Combo1 
      Height          =   315
      Index           =   8
      ItemData        =   "FrmAsistenteProperty.frx":0206
      Left            =   2040
      List            =   "FrmAsistenteProperty.frx":021C
      TabIndex        =   25
      Text            =   "Combo1"
      Top             =   3120
      Width           =   1695
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   8
      Left            =   240
      TabIndex        =   24
      Top             =   3120
      Width           =   1695
   End
   Begin VB.ComboBox Combo1 
      Height          =   315
      Index           =   7
      ItemData        =   "FrmAsistenteProperty.frx":0250
      Left            =   2040
      List            =   "FrmAsistenteProperty.frx":0266
      TabIndex        =   22
      Text            =   "Combo1"
      Top             =   2760
      Width           =   1695
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   7
      Left            =   240
      TabIndex        =   21
      Top             =   2760
      Width           =   1695
   End
   Begin VB.ComboBox Combo1 
      Height          =   315
      Index           =   6
      ItemData        =   "FrmAsistenteProperty.frx":029A
      Left            =   2040
      List            =   "FrmAsistenteProperty.frx":02B0
      TabIndex        =   19
      Text            =   "Combo1"
      Top             =   2400
      Width           =   1695
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   6
      Left            =   240
      TabIndex        =   18
      Top             =   2400
      Width           =   1695
   End
   Begin VB.ComboBox Combo1 
      Height          =   315
      Index           =   5
      ItemData        =   "FrmAsistenteProperty.frx":02E4
      Left            =   2040
      List            =   "FrmAsistenteProperty.frx":02FA
      TabIndex        =   16
      Text            =   "Combo1"
      Top             =   2040
      Width           =   1695
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   5
      Left            =   240
      TabIndex        =   15
      Top             =   2040
      Width           =   1695
   End
   Begin VB.ComboBox Combo1 
      Height          =   315
      Index           =   4
      ItemData        =   "FrmAsistenteProperty.frx":032E
      Left            =   2040
      List            =   "FrmAsistenteProperty.frx":0344
      TabIndex        =   13
      Text            =   "Combo1"
      Top             =   1680
      Width           =   1695
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   4
      Left            =   240
      TabIndex        =   12
      Top             =   1680
      Width           =   1695
   End
   Begin VB.ComboBox Combo1 
      Height          =   315
      Index           =   3
      ItemData        =   "FrmAsistenteProperty.frx":0378
      Left            =   2040
      List            =   "FrmAsistenteProperty.frx":038E
      TabIndex        =   10
      Text            =   "Combo1"
      Top             =   1320
      Width           =   1695
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   3
      Left            =   240
      TabIndex        =   9
      Top             =   1320
      Width           =   1695
   End
   Begin VB.ComboBox Combo1 
      Height          =   315
      Index           =   2
      ItemData        =   "FrmAsistenteProperty.frx":03C2
      Left            =   2040
      List            =   "FrmAsistenteProperty.frx":03D8
      TabIndex        =   7
      Text            =   "Combo1"
      Top             =   960
      Width           =   1695
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   2
      Left            =   240
      TabIndex        =   6
      Top             =   960
      Width           =   1695
   End
   Begin VB.ComboBox Combo1 
      Height          =   315
      Index           =   1
      ItemData        =   "FrmAsistenteProperty.frx":040C
      Left            =   2040
      List            =   "FrmAsistenteProperty.frx":0422
      TabIndex        =   4
      Text            =   "Combo1"
      Top             =   600
      Width           =   1695
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   1
      Left            =   240
      TabIndex        =   3
      Top             =   600
      Width           =   1695
   End
   Begin VB.ComboBox Combo1 
      Height          =   315
      Index           =   0
      ItemData        =   "FrmAsistenteProperty.frx":0456
      Left            =   2040
      List            =   "FrmAsistenteProperty.frx":046C
      TabIndex        =   1
      Text            =   "Combo1"
      Top             =   240
      Width           =   1695
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   0
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   1695
   End
End
Attribute VB_Name = "FrmAsistenteProperty"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
    Dim s As String
    Dim i As Integer
    
    For i = 0 To Text1.Count - 1
        If Text1(i).Text <> "" Then
            s = s & CreateVariable(i)
        End If
    Next i
    
    s = s & vbCrLf
    
    For i = 0 To Text1.Count - 1
        If Text1(i).Text <> "" Then
            s = s & CreateProperty(i)
        End If
    Next i
    
    Text2.Text = s
End Sub

Private Function CreateVariable(ByVal i As Integer) As String
    Dim s As String
    
    With Text1(i)
        .Text = UCase(Left(.Text, 1)) & Mid(.Text, 2)
    
        s = "private m_" & .Text & String(30 - Len(.Text), " ") & "as " & Combo1(i).Text & vbCrLf
    
    End With
    CreateVariable = s
End Function
Private Function CreateProperty(ByVal i As Integer) As String
    Dim s As String
    
    With Text1(i)
    
        If Check1(i).Value = vbChecked Then
            s = "Public Property Get " & .Text & "() As " & Combo1(i).Text & vbCrLf
            s = s & "   Set " & .Text & " = m_" & .Text & vbCrLf
            s = s & "End Property" & vbCrLf & vbCrLf
            
            s = s & "Public Property Set " & .Text & "(byref rhs As " & Combo1(i).Text & ")" & vbCrLf
            s = s & "   Set m_" & .Text & " = rhs" & vbCrLf
            s = s & "End Property" & vbCrLf & vbCrLf
            
        Else
            s = "Public Property Get " & .Text & "() As " & Combo1(i).Text & vbCrLf
            s = s & "   " & .Text & " = m_" & .Text & vbCrLf
            s = s & "End Property" & vbCrLf & vbCrLf
            
            s = s & "Public Property Let " & .Text & "(byval rhs As " & Combo1(i).Text & ")" & vbCrLf
            s = s & "   m_" & .Text & " = rhs" & vbCrLf
            s = s & "End Property" & vbCrLf & vbCrLf
        End If
    End With
    
    CreateProperty = s
End Function

Private Sub Command2_Click()
    Dim i As Integer
    If MsgBox("Esta seguro?", vbQuestion + vbYesNo) = vbYesNo Then Exit Sub
    For i = 0 To Text1.Count - 1
        Combo1(i).Text = ""
        Text1(i).Text = ""
    Next i
    Text2.Text = ""
End Sub

Private Sub Command3_Click()
    Clipboard.Clear
    Clipboard.SetText Text2.Text
End Sub

