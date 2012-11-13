VERSION 5.00
Begin VB.Form fSQLLogin 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Login"
   ClientHeight    =   3480
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4950
   ForeColor       =   &H80000008&
   Icon            =   "fSQLLogin.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3480
   ScaleWidth      =   4950
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.ComboBox cbServer 
      Height          =   315
      Left            =   1320
      Sorted          =   -1  'True
      TabIndex        =   0
      Top             =   180
      Width           =   3360
   End
   Begin VB.TextBox txPassword 
      BackColor       =   &H80000004&
      Height          =   360
      IMEMode         =   3  'DISABLE
      Left            =   1940
      PasswordChar    =   "*"
      TabIndex        =   4
      Top             =   2410
      Width           =   2500
   End
   Begin VB.TextBox txUser 
      BackColor       =   &H80000004&
      Height          =   360
      Left            =   1940
      TabIndex        =   3
      Top             =   1990
      Width           =   2500
   End
   Begin VB.OptionButton opNt 
      BackColor       =   &H00FFFFFF&
      Caption         =   "Autentificación por Windows"
      Height          =   330
      Left            =   405
      TabIndex        =   1
      Top             =   1260
      Width           =   2670
   End
   Begin VB.OptionButton opSQL 
      BackColor       =   &H00FFFFFF&
      Caption         =   "Seguridad de SQL Server"
      Height          =   330
      Left            =   405
      TabIndex        =   2
      Top             =   1620
      Width           =   2715
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   330
      Left            =   3690
      TabIndex        =   6
      Top             =   3060
      Width           =   1185
   End
   Begin VB.CommandButton cmdConnect 
      Caption         =   "C&onectar"
      Default         =   -1  'True
      Height          =   330
      Left            =   2385
      TabIndex        =   5
      Top             =   3060
      Width           =   1185
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Conectarse usando :"
      Height          =   375
      Left            =   135
      TabIndex        =   10
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
      Picture         =   "fSQLLogin.frx":000C
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
      TabIndex        =   9
      Top             =   180
      Width           =   600
   End
   Begin VB.Label Label2 
      BackColor       =   &H00FFFFFF&
      Caption         =   "User:"
      Height          =   285
      Left            =   990
      TabIndex        =   8
      Top             =   2025
      Width           =   825
   End
   Begin VB.Label Label3 
      BackColor       =   &H00FFFFFF&
      Caption         =   "Password:"
      Height          =   240
      Left            =   990
      TabIndex        =   7
      Top             =   2475
      Width           =   825
   End
End
Attribute VB_Name = "fSQLLogin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fSQLLogin
' 07-10-2007

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fSQLLogin"

' estructuras
' variables privadas
Private m_Ok                As Boolean

Private m_vUsers()           As String
Private m_vSecurityType()    As String

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
Public Sub SetLogin(ByVal Server As String, _
                    ByVal User As String, _
                    ByVal Pwd As String, _
                    ByVal SecurityType As csSQLSecurityType)
                                        
  If Not ExistsItemByText(cbServer, Server) Then
    ReDim Preserve m_vUsers(UBound(m_vUsers) + 1)
    ReDim Preserve m_vSecurityType(UBound(m_vSecurityType) + 1)
    
    m_vUsers(UBound(m_vUsers)) = User
    m_vSecurityType(UBound(m_vSecurityType)) = SecurityType
    
    
    AddItemToList cbServer, Server, UBound(m_vUsers)
  Else
  
    Dim i As Long
    
    For i = 0 To cbServer.ListCount - 1
      If cbServer.List(i) = Server Then
        m_vUsers(i) = User
        m_vSecurityType(i) = SecurityType
        Exit For
      End If
    Next
  End If
                    
  SelectItemByText cbServer, Server
  
  txPassword.Text = Pwd
  
End Sub

' funciones friend
' funciones privadas
Private Sub cmdConnect_Click()
  On Error GoTo ControlError
  
  Dim Cancel As Boolean
  RaiseEvent Connect(Cancel)
  
  If Cancel Then Exit Sub

  SaveLoginToIni
  
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

    Select Case Val(m_vSecurityType(i))
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
  Dim Servers As String
  Dim Users   As String
  Dim TypeS   As String
  Dim LastServer As String
  
  GetMainIniLogin Servers, Users, TypeS, LastServer
  
  Dim vServers() As String
  
  vServers() = Split(Servers, ",")
  m_vUsers = Split(Users, ",")
  m_vSecurityType = Split(TypeS, ",")
  
  Dim i As Integer
  
  For i = 0 To UBound(vServers)
    If Not ExistsItemByText(cbServer, vServers(i)) Then
      AddItemToList cbServer, vServers(i), i
    End If
  Next
  
  SelectItemByText cbServer, LastServer
End Sub

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
    ReDim Preserve m_vSecurityType(i)
  Else
    i = cbServer.ListIndex
  End If
  
  If UBound(m_vUsers) < i Then
    ReDim Preserve m_vUsers(i)
  End If
  
  m_vUsers(i) = txUser.Text
  If opNt.Value Then
    m_vSecurityType(i) = csTSNT
  Else
    m_vSecurityType(i) = csTSSQL
  End If
  
  Servers = Join(vServers, ",")
  Users = Join(m_vUsers, ",")
  TypeS = Join(m_vSecurityType, ",")
  
  SaveMainIniLogin Servers, Users, TypeS, cbServer.Text
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError
  
  opNt.Value = True
  txPassword.Text = vbNullString

  LoadLoginFromIni
  
  FormCenter Me

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
