VERSION 5.00
Begin VB.Form fLogin 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Login"
   ClientHeight    =   3480
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4950
   ForeColor       =   &H80000008&
   Icon            =   "fLogin.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3480
   ScaleWidth      =   4950
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txServer 
      BorderStyle     =   0  'None
      Height          =   285
      Left            =   1345
      TabIndex        =   0
      Top             =   150
      Width           =   3360
   End
   Begin VB.ComboBox cbServer 
      Height          =   315
      Left            =   1395
      Sorted          =   -1  'True
      TabIndex        =   1
      Top             =   120
      Width           =   3360
   End
   Begin VB.TextBox txPassword 
      BackColor       =   &H80000004&
      BorderStyle     =   0  'None
      Height          =   300
      IMEMode         =   3  'DISABLE
      Left            =   1940
      PasswordChar    =   "*"
      TabIndex        =   5
      Top             =   2410
      Width           =   2500
   End
   Begin VB.TextBox txUser 
      BackColor       =   &H80000004&
      BorderStyle     =   0  'None
      Height          =   300
      Left            =   1940
      TabIndex        =   4
      Top             =   1990
      Width           =   2500
   End
   Begin VB.OptionButton opNt 
      BackColor       =   &H00FFFFFF&
      Caption         =   "Autentificación por Windows"
      Height          =   330
      Left            =   405
      TabIndex        =   2
      Top             =   1260
      Width           =   2670
   End
   Begin VB.OptionButton opSQL 
      BackColor       =   &H00FFFFFF&
      Caption         =   "Seguridad de SQL Server"
      Height          =   330
      Left            =   405
      TabIndex        =   3
      Top             =   1620
      Width           =   2715
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   330
      Left            =   3690
      TabIndex        =   7
      Top             =   3060
      Width           =   1185
   End
   Begin VB.CommandButton cmdConnect 
      Caption         =   "C&onectar"
      Default         =   -1  'True
      Height          =   330
      Left            =   2385
      TabIndex        =   6
      Top             =   3060
      Width           =   1185
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H0080C0FF&
      Height          =   330
      Left            =   1320
      Top             =   120
      Visible         =   0   'False
      Width           =   3435
   End
   Begin VB.Shape Shape3 
      BorderColor     =   &H0080C0FF&
      Height          =   330
      Left            =   1920
      Top             =   2400
      Visible         =   0   'False
      Width           =   2535
   End
   Begin VB.Shape Shape2 
      BorderColor     =   &H0080C0FF&
      Height          =   330
      Left            =   1920
      Top             =   1980
      Visible         =   0   'False
      Width           =   2535
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Conectarse usando :"
      Height          =   375
      Left            =   135
      TabIndex        =   11
      Top             =   900
      Width           =   1635
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000014&
      X1              =   -45
      X2              =   4965
      Y1              =   735
      Y2              =   735
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000010&
      X1              =   -45
      X2              =   4965
      Y1              =   720
      Y2              =   720
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   135
      Picture         =   "fLogin.frx":000C
      Top             =   90
      Width           =   480
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   -45
      X2              =   4965
      Y1              =   2925
      Y2              =   2925
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   -45
      X2              =   4965
      Y1              =   2940
      Y2              =   2940
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Server:"
      Height          =   375
      Left            =   720
      TabIndex        =   10
      Top             =   180
      Width           =   600
   End
   Begin VB.Label Label2 
      BackColor       =   &H00FFFFFF&
      Caption         =   "User:"
      Height          =   285
      Left            =   990
      TabIndex        =   9
      Top             =   2025
      Width           =   825
   End
   Begin VB.Label Label3 
      BackColor       =   &H00FFFFFF&
      Caption         =   "Password:"
      Height          =   240
      Left            =   990
      TabIndex        =   8
      Top             =   2475
      Width           =   825
   End
End
Attribute VB_Name = "fLogin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fLogin
' 23-07-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fLogin"

Private Enum csTypeSecurity
  csTSNT = 1
  csTSSQL = 2
End Enum
' estructuras
' variables privadas
Private m_Ok                As Boolean

Private m_vUsers()           As String
Private m_vTypeSecurity()    As String

#If PREPROC_UPDATE Then
Private m_Mouse              As cMouseWait
#Else
Private m_Mouse              As CSTools.cMouseWait
#End If
' eventos
Public Event Connect(ByRef Cancel As Boolean)
' propiedadades publicas
Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property
Public Property Let Ok(ByVal rhs As Boolean)
  m_Ok = rhs
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub cmdConnect_Click()
  On Error GoTo ControlError
  
  Dim Cancel As Boolean
  RaiseEvent Connect(Cancel)
  
  If Cancel Then Exit Sub

#If PREPROC_INSTALL = 0 Then
  SaveLoginToIni
#End If
  
  m_Ok = True
  Me.Hide

  GoTo ExitProc
ControlError:
  MngError Err, "cmdConnect_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cbServer_Click()
  On Error Resume Next

  Dim i As Integer

  i = cbServer.ListIndex

  If i >= 0 Then

    Select Case Val(m_vTypeSecurity(i))
      Case csTSNT
        opNt.Value = True
      Case csTSSQL
        opSQL.Value = True
    End Select

    If UBound(m_vUsers) < i Then Exit Sub

    txUser.Text = m_vUsers(i)
  End If
End Sub

Private Sub cmdCancel_Click()
  On Error Resume Next
  m_Ok = False
  Me.Hide
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  Set m_Mouse = Nothing
End Sub

Private Sub opNt_Click()
  On Error Resume Next
  If opNt.Value Then
    txPassword.Enabled = False
    txUser.Enabled = False
  
    txPassword.BackColor = vbButtonFace
    txUser.BackColor = vbButtonFace
  End If
End Sub

Private Sub opSQL_Click()
  On Error Resume Next
  If opSQL.Value Then
    txPassword.Enabled = True
    txUser.Enabled = True
  
    txPassword.BackColor = vbWindowBackground
    txUser.BackColor = vbWindowBackground
  End If
End Sub

Private Sub LoadLoginFromIni()
#If PREPROC_INSTALL = 0 Then
  Dim Servers As String
  Dim Users   As String
  Dim TypeS   As String
  Dim LastServer As String
  
  txServer.Visible = False
  GetMainIniLogin Servers, Users, TypeS, LastServer
  
  Dim vServers() As String
  
  vServers() = Split(Servers, ",")
  m_vUsers = Split(Users, ",")
  m_vTypeSecurity = Split(TypeS, ",")
  
  Dim i As Integer
  
  For i = 0 To UBound(vServers)
    If Not ExistsItemByText(cbServer, vServers(i)) Then
      AddItemToList cbServer, vServers(i), i
    End If
  Next
  
  SelectItemByText cbServer, LastServer
#Else

  cbServer.Visible = False
  opNt.Value = True
  txServer.Text = GetComputerName()
#End If
End Sub

#If PREPROC_INSTALL = 0 Then
Private Sub SaveLoginToIni()
  Dim Servers As String
  Dim Users   As String
  Dim TypeS   As String
  Dim vServers() As String
  Dim i As Integer
  
  If cbServer.Text = "" Then Exit Sub
  
  If cbServer.ListCount > 0 Then
    ReDim Preserve vServers(cbServer.ListCount - 1)
    For i = 0 To cbServer.ListCount - 1
      vServers(i) = cbServer.List(i)
    Next
  End If
  
  If cbServer.ListIndex = -1 Then
    ReDim Preserve vServers(cbServer.ListCount)
    vServers(cbServer.ListCount) = cbServer.Text
    i = UBound(vServers)
    ReDim Preserve m_vUsers(i)
    ReDim Preserve m_vTypeSecurity(i)
  Else
    i = cbServer.ListIndex
  End If
  
  If UBound(m_vUsers) < i Then
    ReDim Preserve m_vUsers(i)
  End If
  
  m_vUsers(i) = txUser.Text
  If opNt.Value Then
    m_vTypeSecurity(i) = csTSNT
  Else
    m_vTypeSecurity(i) = csTSSQL
  End If
  
  Servers = Join(vServers, ",")
  Users = Join(m_vUsers, ",")
  TypeS = Join(m_vTypeSecurity, ",")
  
  SaveMainIniLogin Servers, Users, TypeS, cbServer.Text
End Sub
#End If
' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError
  
#If PREPROC_UPDATE Then
  Set m_Mouse = New cMouseWait
#Else
  Set m_Mouse = New CSTools.cMouseWait
#End If
  m_Mouse.SetMouseDefatul

#If PREPROC_INSTALL = 0 Then
  opNt.Value = True
  Shape1.Visible = False
  Shape2.Visible = False
  Shape3.Visible = False
  txPassword.BorderStyle = 1
  txUser.BorderStyle = 1
  txServer.Visible = False
#Else
  opSQL.Value = True
  Shape1.Visible = True
  Shape2.Visible = True
  Shape3.Visible = True
#End If

  LoadLoginFromIni
  
#If PREPROC_INSTALL = 0 Then
  FormCenter Me
#Else
  CenterForm Me
#End If

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  On Error Resume Next
  If UnloadMode <> vbFormCode Then
    cmdCancel_Click
  End If
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
