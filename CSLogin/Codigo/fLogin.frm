VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{532123E7-BCE7-43D6-94ED-AEA94949D5E6}#1.0#0"; "CSComboBox.ocx"
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.2#0"; "CSMaskEdit2.ocx"
Begin VB.Form fLogin 
   BackColor       =   &H8000000C&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Login"
   ClientHeight    =   2010
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5895
   Icon            =   "fLogin.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2010
   ScaleWidth      =   5895
   StartUpPosition =   3  'Windows Default
   Begin CSComboBox.cComboBox cbCompany 
      Height          =   315
      Left            =   1740
      TabIndex        =   5
      Top             =   420
      Width           =   2295
      _ExtentX        =   4048
      _ExtentY        =   556
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ListIndex       =   -1
      Text            =   ""
   End
   Begin CSMaskEdit2.cMaskEdit TxPassword 
      Height          =   315
      Left            =   1740
      TabIndex        =   1
      Top             =   1380
      Width           =   2295
      _ExtentX        =   4048
      _ExtentY        =   556
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Marlett"
         Size            =   8.25
         Charset         =   2
         Weight          =   500
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "Marlett"
      FontSize        =   8.25
      PasswordChar    =   "h"
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderColor     =   12164479
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSMaskEdit2.cMaskEdit TxUser 
      Height          =   315
      Left            =   1740
      TabIndex        =   7
      Top             =   900
      Width           =   2295
      _ExtentX        =   4048
      _ExtentY        =   556
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
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderColor     =   12164479
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSButton.cButtonLigth cmdCancel 
      Cancel          =   -1  'True
      Height          =   330
      Left            =   4320
      TabIndex        =   3
      Top             =   900
      Width           =   1320
      _ExtentX        =   2328
      _ExtentY        =   582
      Caption         =   "Cancelar"
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
   Begin CSButton.cButtonLigth cmdOk 
      Default         =   -1  'True
      Height          =   330
      Left            =   4320
      TabIndex        =   2
      Top             =   420
      Width           =   1320
      _ExtentX        =   2328
      _ExtentY        =   582
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
   Begin VB.Label lbCompany 
      BackStyle       =   0  'Transparent
      Caption         =   "&Empresa :"
      Height          =   255
      Left            =   945
      TabIndex        =   4
      Top             =   435
      Width           =   1005
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   330
      Picture         =   "fLogin.frx":058A
      Top             =   255
      Width           =   480
   End
   Begin VB.Image Image5 
      Height          =   480
      Left            =   300
      Picture         =   "fLogin.frx":0E54
      Top             =   780
      Width           =   480
   End
   Begin VB.Image Image3 
      Height          =   480
      Left            =   330
      Picture         =   "fLogin.frx":171E
      Top             =   1305
      Width           =   480
   End
   Begin VB.Label lbUser 
      BackStyle       =   0  'Transparent
      Caption         =   "&Usuario :"
      Height          =   255
      Left            =   930
      TabIndex        =   6
      Top             =   930
      Width           =   1005
   End
   Begin VB.Label lbPassword 
      BackStyle       =   0  'Transparent
      Caption         =   "&Clave :"
      Height          =   255
      Left            =   945
      TabIndex        =   0
      Top             =   1470
      Width           =   1005
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H80000014&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   1815
      Left            =   120
      Top             =   120
      Width           =   5685
   End
End
Attribute VB_Name = "fLogin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' FrmLogin
' 10-01-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const c_Key_LastCompany As String = "LastCompany"
Private Const c_Key_LastUser    As String = "LastUser_"
' estructuras
' variables privadas
Private m_User        As String
Private m_LastCompany As String
Private m_Password    As String
Private m_Login       As cLogin
Private m_Ok          As Boolean
Private m_App         As String
' propiedades publicas
Public Property Get Ok() As Boolean
    Ok = m_Ok
End Property
Public Property Let Ok(ByVal rhs As Boolean)
    m_Ok = rhs
End Property
Public Property Get User() As String
    User = m_User
End Property
Public Property Set Login(ByVal rhs As cLogin)
    Set m_Login = rhs
End Property
' propiedades privadas
' funciones publicas
Public Sub Init(ByVal AppNombre As String)
  m_App = AppNombre
  Caption = "Login - " & m_App
  pLoadRegistry
    
  ListSetListIndexForText cbCompany, m_LastCompany
  If cbCompany.ListIndex = -1 Then ListSetListIndex cbCompany, 0
    
End Sub

' funciones privadas
Private Sub cbCompany_Click()
  m_LastCompany = cbCompany.Text
  pLoadRegistryUser
  TxUser.Text = m_User
End Sub

Private Sub cmdCancel_Click()
    Ok = False
    Me.Hide
End Sub

Private Sub cmdOk_Click()
    Dim ErrorMsg As String
    
    m_User = TxUser.Text
    m_Password = TxPassword.Text
    m_LastCompany = cbCompany.Text

    If m_Login.Login_(m_User, m_Password, ListID(cbCompany), 0, ErrorMsg) Then
        Ok = True
        Me.Hide
    Else
      If ErrorMsg <> "" Then
        CSKernelClient2.MsgWarning ErrorMsg, "Login"
      End If
    End If
End Sub

Private Sub Form_Load()
    m_Ok = False
    
    CSKernelClient2.CenterForm Me
End Sub
Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    If UnloadMode <> vbFormCode Then
        m_Ok = False
        Me.Hide
        Cancel = True
    End If
End Sub
Private Sub Form_Unload(Cancel As Integer)
    If m_Ok Then
        pSaveLastLogin
    End If
End Sub

Private Sub pSaveLastLogin()
  CSKernelClient2.SetRegistry csSeccionSetting.csLogin, c_Key_LastCompany, m_LastCompany
  CSKernelClient2.SetRegistry csSeccionSetting.csLogin, c_Key_LastUser & m_LastCompany, m_User
End Sub

Private Sub pLoadRegistry()
  m_LastCompany = CSKernelClient2.GetRegistry(csSeccionSetting.csLogin, c_Key_LastCompany, "")
End Sub

Private Sub pLoadRegistryUser()
  m_User = CSKernelClient2.GetRegistry(csSeccionSetting.csLogin, c_Key_LastUser & m_LastCompany, "")
  If LenB(m_User) = 0 Then m_User = "administrador"
End Sub

