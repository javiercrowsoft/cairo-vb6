VERSION 5.00
Begin VB.Form fLogin 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "QBOnix Login Server"
   ClientHeight    =   2580
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   5400
   FillColor       =   &H00808080&
   ForeColor       =   &H8000000C&
   Icon            =   "fQBLoginServer.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2580
   ScaleWidth      =   5400
   StartUpPosition =   3  'Windows Default
   Begin VB.ComboBox cbServers 
      Height          =   315
      Left            =   960
      Sorted          =   -1  'True
      TabIndex        =   0
      Text            =   "cbServers"
      Top             =   1260
      Width           =   4215
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancelar"
      Height          =   315
      Left            =   3840
      TabIndex        =   3
      Top             =   2100
      Width           =   1455
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Aceptar"
      Default         =   -1  'True
      Height          =   315
      Left            =   2340
      TabIndex        =   2
      Top             =   2100
      Width           =   1455
   End
   Begin VB.Line Line2 
      BorderColor     =   &H8000000F&
      X1              =   0
      X2              =   6000
      Y1              =   1875
      Y2              =   1875
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   6000
      Y1              =   1860
      Y2              =   1860
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Seleccione el servidor QBPoint "
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   1320
      TabIndex        =   4
      Top             =   480
      Width           =   3795
   End
   Begin VB.Image Image1 
      Height          =   750
      Left            =   240
      Picture         =   "fQBLoginServer.frx":1042
      Top             =   240
      Width           =   750
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "&Servidor:"
      Height          =   315
      Left            =   120
      TabIndex        =   1
      Top             =   1260
      Width           =   795
   End
End
Attribute VB_Name = "fLogin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_Ok        As Boolean
Private m_DontShow  As Boolean

Public Property Get DontShow() As Boolean
  DontShow = m_DontShow
End Property

Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property

Public Property Get server() As String
  On Error Resume Next
  Dim vServer As Variant
  vServer = Split(cbServers.Text, ":")
  server = vServer(0)
End Property

Public Property Get Port() As Long
  On Error Resume Next
  Dim vServer As Variant
  vServer = Split(cbServers.Text, ":")
  Port = vServer(1)
End Property

Private Sub cmdOk_Click()
  On Error Resume Next
  
  StartCairo
  Unload fLogin
End Sub

Private Sub cmdCancel_Click()
  On Error Resume Next
  Unload Me
End Sub

Private Sub Form_Load()
  On Error Resume Next
          
  Dim vServer As Variant
  Dim servers As String
  
  servers = GetIniValue("CONFIG", "SERVERS", "", GetValidPath(App.Path) & "CSLoginServer.ini")
  vServer = Split(servers, ",")
  
  cbServers.Clear
  
  If servers = vbNullString Then
    m_DontShow = True
    m_Ok = True
  Else
    m_DontShow = False
  
    Dim server As String
    
    server = GetIniValue("CONFIG", "SERVER", "", GetValidPath(App.Path) & "CSLogin.ini")
    cbServers.AddItem server
    cbServers.ListIndex = cbServers.NewIndex
  
    Me.Move (Screen.Width - Me.Width) * 0.5, _
            (Screen.Height - Me.Height) * 0.5
  
    Dim i As Long
    Dim j As Long
    Dim bFound As Boolean
    
    For i = 0 To UBound(vServer)
      
      bFound = False
      For j = 0 To cbServers.ListCount - 1
        If LCase(cbServers.List(j)) = LCase(vServer(i)) Then
          bFound = True
          Exit For
        End If
      Next
      If Not bFound Then
        cbServers.AddItem vServer(i)
      End If
    Next
    
  End If
End Sub
