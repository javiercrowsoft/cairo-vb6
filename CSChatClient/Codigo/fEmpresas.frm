VERSION 5.00
Begin VB.Form fEmpresas 
   BackColor       =   &H80000005&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Empresas"
   ClientHeight    =   2130
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   4680
   Icon            =   "fEmpresas.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2130
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancelar"
      Height          =   315
      Left            =   2880
      TabIndex        =   3
      Top             =   1560
      Width           =   1395
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Aceptar"
      Default         =   -1  'True
      Height          =   315
      Left            =   1320
      TabIndex        =   2
      Top             =   1560
      Width           =   1455
   End
   Begin VB.ComboBox cbCompany 
      Height          =   315
      Left            =   1620
      Style           =   2  'Dropdown List
      TabIndex        =   1
      Top             =   480
      Width           =   2955
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   60
      X2              =   4560
      Y1              =   1260
      Y2              =   1260
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   240
      Picture         =   "fEmpresas.frx":038A
      Top             =   360
      Width           =   480
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "&Empresa :"
      Height          =   255
      Left            =   855
      TabIndex        =   0
      Top             =   540
      Width           =   1005
   End
End
Attribute VB_Name = "fEmpresas"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_ok As Boolean
Private m_LastCompany As String

Public Sub Init()
  pLoadRegistry
    
  ListSetListIndexForText cbCompany, m_LastCompany
  If cbCompany.ListIndex = -1 Then ListSetListIndex cbCompany, 0
    
End Sub

Public Property Get Ok() As Boolean
  Ok = m_ok
End Property

Private Sub cmdCancel_Click()
  m_ok = False
  Me.Hide
End Sub

Private Sub cmdOk_Click()
  m_ok = True
  pSaveLastLogin
  Me.Hide
End Sub

Private Sub Form_Load()
  On Error Resume Next
  Me.Left = fMain.Left + 500
  Me.Top = fMain.Top + 3000
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If UnloadMode <> vbFormCode Then
    cmdCancel_Click
  End If
End Sub

Private Sub pSaveLastLogin()
  CSKernelClient2.SetRegistry csSeccionSetting.csLogin, c_Key_LastCompany, m_LastCompany
End Sub

Private Sub pLoadRegistry()
  m_LastCompany = CSKernelClient2.GetRegistry(csSeccionSetting.csLogin, c_Key_LastCompany, "")
End Sub

