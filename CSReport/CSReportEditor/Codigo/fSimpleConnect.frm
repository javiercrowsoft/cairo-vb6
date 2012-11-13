VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.2#0"; "CSMaskEdit2.ocx"
Begin VB.Form fSimpleConnect 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Conexión Sql"
   ClientHeight    =   4305
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   4680
   Icon            =   "fSimpleConnect.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4305
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.OptionButton opNT 
      Caption         =   "Trusted Connection"
      Height          =   195
      Left            =   360
      TabIndex        =   4
      Top             =   1935
      Width           =   3255
   End
   Begin VB.OptionButton opSQL 
      Caption         =   "SQL"
      Height          =   195
      Left            =   360
      TabIndex        =   5
      Top             =   2340
      Width           =   1695
   End
   Begin CSMaskEdit2.cMaskEdit txServer 
      Height          =   315
      Left            =   930
      TabIndex        =   1
      Top             =   885
      Width           =   3465
      _ExtentX        =   6112
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
      ForeColor       =   0
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderColor     =   12164479
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSMaskEdit2.cMaskEdit txDataBase 
      Height          =   315
      Left            =   930
      TabIndex        =   3
      Top             =   1260
      Width           =   3465
      _ExtentX        =   6112
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
      ForeColor       =   0
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderColor     =   12164479
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSMaskEdit2.cMaskEdit txUser 
      Height          =   315
      Left            =   1740
      TabIndex        =   7
      Top             =   2835
      Width           =   2655
      _ExtentX        =   4683
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
      ForeColor       =   0
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderColor     =   12164479
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSMaskEdit2.cMaskEdit txPassword 
      Height          =   315
      Left            =   1740
      TabIndex        =   9
      Top             =   3210
      Width           =   2655
      _ExtentX        =   4683
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
      ForeColor       =   0
      PasswordChar    =   "*"
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderColor     =   12164479
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSButton.cButton cmdCancel 
      Height          =   315
      Left            =   3270
      TabIndex        =   11
      Top             =   3930
      Width           =   1275
      _ExtentX        =   2249
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
   Begin CSButton.cButton cmdOk 
      Height          =   315
      Left            =   1875
      TabIndex        =   10
      Top             =   3930
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   556
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
   Begin VB.Image Image1 
      Height          =   585
      Left            =   135
      Picture         =   "fSimpleConnect.frx":058A
      Top             =   45
      Width           =   675
   End
   Begin VB.Label Label8 
      BackStyle       =   0  'Transparent
      Caption         =   "Controles"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   1050
      TabIndex        =   12
      Top             =   225
      Width           =   2235
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   7075
      Y1              =   3810
      Y2              =   3810
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000010&
      X1              =   -75
      X2              =   7000
      Y1              =   3795
      Y2              =   3795
   End
   Begin VB.Label Label4 
      Caption         =   "Password"
      Height          =   195
      Left            =   660
      TabIndex        =   8
      Top             =   3270
      Width           =   855
   End
   Begin VB.Label Label3 
      Caption         =   "User"
      Height          =   195
      Left            =   660
      TabIndex        =   6
      Top             =   2895
      Width           =   855
   End
   Begin VB.Label Label2 
      Caption         =   "Database"
      Height          =   195
      Left            =   120
      TabIndex        =   2
      Top             =   1335
      Width           =   855
   End
   Begin VB.Label Label1 
      Caption         =   "Server"
      Height          =   195
      Left            =   120
      TabIndex        =   0
      Top             =   960
      Width           =   855
   End
   Begin VB.Shape Shape1 
      BorderStyle     =   0  'Transparent
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   690
      Left            =   0
      Top             =   0
      Width           =   6360
   End
End
Attribute VB_Name = "fSimpleConnect"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fColumns
' 01-11-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fSimpleConnect"

' estructuras
' variables privadas
Private m_Ok                            As Boolean
Private m_strConnect                    As String
' eventos
' propiedades publicas
Public Property Get Ok() As Boolean
   Ok = m_Ok
End Property

Public Property Get strConnect() As String
  strConnect = m_strConnect
End Property

Private Sub cmdCancel_Click()
  m_Ok = False
  Me.Hide
End Sub

Private Sub cmdOk_Click()

  If txServer.Text = "" Then
    MsgWarning "Debe indicar un server"
    Exit Sub
  End If
    
  If txDataBase.Text = "" Then
    MsgWarning "Debe indicar una base de datos"
    Exit Sub
  End If

  If opNT.Value Then
    m_strConnect = "Provider=SQLOLEDB.1;"
    m_strConnect = m_strConnect & "Integrated Security=SSPI;"
    m_strConnect = m_strConnect & "Persist Security Info=False;"
    m_strConnect = m_strConnect & "Initial Catalog=" & txDataBase.Text & ";"
    m_strConnect = m_strConnect & "Data Source=" & txServer.Text & ";"
  Else
  
    If txUser.Text = "" Then
      MsgWarning "Debe indicar un usuario"
      Exit Sub
    End If
  
    m_strConnect = "Provider=SQLOLEDB.1;"
    m_strConnect = m_strConnect & "Persist Security Info=True;"
    m_strConnect = m_strConnect & "Data Source=" & txServer.Text & ";"
    m_strConnect = m_strConnect & "User ID=" & txUser.Text & ";"
    m_strConnect = m_strConnect & "Password=" & txPassword.Text & ";"
    m_strConnect = m_strConnect & "Initial Catalog=" & txDataBase.Text & ";"
  End If

  m_Ok = True
  Me.Hide
End Sub

' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Form_Load()
  m_Ok = False
  CenterForm Me
  opSQL.Value = True
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

Private Sub opNT_Click()
  txPassword.Enabled = False
  txUser.Enabled = False
End Sub

Private Sub opSQL_Click()
  txPassword.Enabled = True
  txUser.Enabled = True
End Sub
