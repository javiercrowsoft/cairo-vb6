VERSION 5.00
Begin VB.Form fLogin 
   Caption         =   "Login"
   ClientHeight    =   4170
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6405
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4170
   ScaleWidth      =   6405
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton CmdExaminar 
      Caption         =   "E&xaminar"
      Height          =   315
      Left            =   4875
      TabIndex        =   17
      Top             =   3735
      Width           =   1335
   End
   Begin VB.TextBox TxPWD 
      Height          =   330
      IMEMode         =   3  'DISABLE
      Left            =   2520
      PasswordChar    =   "*"
      TabIndex        =   14
      Top             =   3240
      Width           =   2100
   End
   Begin VB.TextBox TxServer 
      Height          =   330
      Left            =   2520
      TabIndex        =   10
      Top             =   2340
      Width           =   2100
   End
   Begin VB.TextBox TxUID 
      Height          =   330
      Left            =   2520
      TabIndex        =   12
      Top             =   2790
      Width           =   2100
   End
   Begin VB.TextBox TxDataBase 
      Height          =   330
      Left            =   2520
      TabIndex        =   16
      Top             =   3690
      Width           =   2100
   End
   Begin VB.OptionButton OpSqlServer 
      Caption         =   "&SQL Server"
      Height          =   330
      Left            =   2160
      TabIndex        =   8
      Top             =   1845
      Width           =   1860
   End
   Begin VB.OptionButton OpAccess 
      Caption         =   "Acc&ess"
      Height          =   330
      Left            =   180
      TabIndex        =   7
      Top             =   1845
      Width           =   1860
   End
   Begin VB.CommandButton CmdDetalles 
      Caption         =   "Ava&nzado ..."
      Height          =   315
      Left            =   4875
      TabIndex        =   6
      Top             =   1170
      Width           =   1335
   End
   Begin VB.CommandButton CmdConectar 
      Caption         =   "&Aceptar"
      Default         =   -1  'True
      Height          =   315
      Left            =   4860
      TabIndex        =   4
      Top             =   180
      Width           =   1335
   End
   Begin VB.CommandButton CmdCancelar 
      Cancel          =   -1  'True
      Caption         =   "&Cancelar"
      Height          =   315
      Left            =   4875
      TabIndex        =   5
      Top             =   675
      Width           =   1335
   End
   Begin VB.TextBox TxUsuario 
      Height          =   285
      Left            =   2385
      TabIndex        =   3
      Top             =   210
      Width           =   2235
   End
   Begin VB.TextBox TxClave 
      Height          =   285
      IMEMode         =   3  'DISABLE
      Left            =   2385
      PasswordChar    =   "*"
      TabIndex        =   1
      Top             =   675
      Width           =   2235
   End
   Begin VB.Label LbCommentAccess 
      Caption         =   "Indique el path completo y el nombre del archivo."
      Height          =   420
      Left            =   855
      TabIndex        =   18
      Top             =   2610
      Width           =   3930
   End
   Begin VB.Label LbPWD 
      Caption         =   "C&lave:"
      Height          =   285
      Left            =   900
      TabIndex        =   13
      Top             =   3285
      Width           =   690
   End
   Begin VB.Label LbServer 
      Caption         =   "Ser&vidor:"
      Height          =   285
      Left            =   900
      TabIndex        =   9
      Top             =   2385
      Width           =   690
   End
   Begin VB.Label LbUID 
      Caption         =   "&UID:"
      Height          =   285
      Left            =   900
      TabIndex        =   11
      Top             =   2835
      Width           =   690
   End
   Begin VB.Label Label7 
      Caption         =   "&Base de datos:"
      Height          =   285
      Left            =   900
      TabIndex        =   15
      Top             =   3735
      Width           =   1275
   End
   Begin VB.Line LnDetalle 
      BorderColor     =   &H8000000E&
      X1              =   135
      X2              =   6212
      Y1              =   1680
      Y2              =   1680
   End
   Begin VB.Line Line1 
      X1              =   135
      X2              =   6210
      Y1              =   1665
      Y2              =   1665
   End
   Begin VB.Image Image5 
      Height          =   480
      Left            =   270
      Picture         =   "fLogin.frx":0000
      Top             =   90
      Width           =   480
   End
   Begin VB.Image Image3 
      Height          =   480
      Left            =   330
      Picture         =   "fLogin.frx":0ABA
      Top             =   645
      Width           =   480
   End
   Begin VB.Label Label3 
      Caption         =   "&Id de Usuario:"
      Height          =   255
      Left            =   930
      TabIndex        =   2
      Top             =   210
      Width           =   1275
   End
   Begin VB.Label Label5 
      Caption         =   "&Clave:"
      Height          =   255
      Left            =   945
      TabIndex        =   0
      Top             =   690
      Width           =   1275
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
' estructuras
' variables privadas
Private m_DB        As cDataBase
Private m_App       As String
Private m_Server    As String
Private m_DataBase  As String
Private m_TipoBase  As csServerVersion
Private m_UID       As String
Private m_PWD       As String
Private m_OK        As Boolean
Private m_PWDbyUser As Boolean
Private m_AlreadyConnect   As Boolean
Private m_User      As cUser
Private m_nombre    As String
Private m_Clave     As String
' propiedades publicas
Public Property Get Ok() As Boolean
    Ok = m_OK
End Property
Public Property Let Ok(ByVal rhs As Boolean)
    m_OK = rhs
End Property
Public Property Get DB() As cDataBase
    Set DB = m_DB
End Property
Public Property Set DB(ByRef rhs As cDataBase)
    Set m_DB = rhs
End Property
Public Property Get user() As cUser
    Set user = m_User
End Property


' propiedades privadas
' funciones publicas
Public Sub Init(ByVal AppNombre As String)
    m_App = AppNombre
    GetRegistry
    If m_TipoBase = csVSAccess Then
        OpAccess.Value = True
    Else
        OpSqlServer.Value = True
    End If
    TxDataBase = m_DataBase
    TxUID = m_UID
    TxPWD = m_PWD
    TxServer = m_Server
    TxUsuario = m_nombre
End Sub

' funciones privadas
Private Sub SetRegistry()
    SaveSetting m_App, "LOGIN", "SERVER", m_Server
    SaveSetting m_App, "LOGIN", "UID", m_UID
    SaveSetting m_App, "LOGIN", "PWD", m_PWD
    SaveSetting m_App, "LOGIN", "DB", m_DataBase
    SaveSetting m_App, "LOGIN", "TIPO_BASE", m_TipoBase
    SaveSetting m_App, "LOGIN", "LAST_USER", m_nombre
End Sub

Private Sub GetRegistry()
    m_Server = GetSetting(m_App, "LOGIN", "SERVER", "")
    m_UID = GetSetting(m_App, "LOGIN", "UID", "")
    m_PWD = GetSetting(m_App, "LOGIN", "PWD", "")
    m_DataBase = GetSetting(m_App, "LOGIN", "DB", "")
    m_TipoBase = GetSetting(m_App, "LOGIN", "TIPO_BASE", csVSql70)
    m_nombre = GetSetting(m_App, "LOGIN", "LAST_USER", "")
End Sub

Private Sub CmdCancelar_Click()
    Ok = False
    Me.Hide
End Sub

Private Sub CmdConectar_Click()
    ' Cargo las variables
    m_Server = TxServer
    m_UID = TxUID
    m_nombre = TxUsuario
    m_Clave = TxClave
    m_DataBase = TxDataBase
    
    If m_nombre = "" Then
        gWindow.MsgWarning "Debe indicar un usuario"
        TxUsuario.SetFocus
        Exit Sub
    End If
    
    If m_PWDbyUser Then m_PWD = TxPWD
    
    If OpAccess Then
        m_TipoBase = csVSAccess
    Else
        m_TipoBase = csVSql70
        
        ' si es un sql hay mas datos que validar
        If m_Server = "" Then
            gWindow.MsgWarning "Debe indicar un servidor SQL"
            CmdDetalles_Click
            TxServer.SetFocus
            Exit Sub
        ElseIf m_UID = "" Then
            gWindow.MsgWarning "Debe indicar un login de usuario SQL"
            CmdDetalles_Click
            TxUID.SetFocus
            Exit Sub
        End If
    End If
    
    If m_DataBase = "" Then
        gWindow.MsgWarning "Debe indicar una base de datos"
        CmdDetalles_Click
        TxDataBase.SetFocus
        Exit Sub
    End If
    
    
    ' Si necesito volver a conectarme
    If Not m_AlreadyConnect Then
        If Not Connect() Then Exit Sub
    End If
    
    ' si no tengo usuario me creo uno
    If m_User Is Nothing Then Set m_User = New cUser
    
    Set m_User.DB = m_DB
    If Not m_User.Login(m_nombre, m_Clave) Then Exit Sub
    
    ' Me pude conectar a la base de datos, y el usuario es valido
    Ok = True
    Me.Hide
End Sub

Private Function Connect() As Boolean
    Dim sConnect As String
    
    Select Case m_TipoBase
        Case csVSAccess
            sConnect = "PROVIDER=Microsoft.Jet.OLEDB.3.51;Data Source=" + m_DataBase
        Case csVSql65, csVSql70
            sConnect = "PROVIDER=MSDASQL;driver={SQL Server};server=" + m_Server
            sConnect = sConnect + ";uid=" + m_UID + ";pwd=" + m_PWD + ";database=" + m_DataBase + ";"
    End Select
    
    ' si no tengo objeto de base de datos me creo uno
    If m_DB Is Nothing Then Set m_DB = New cDataBase
    
    Connect = m_DB.InitDB(, , , , sConnect)
    m_AlreadyConnect = Connect
End Function

Private Sub CmdDetalles_Click()
    Height = Height - ScaleHeight + 50 + TxDataBase.Top + TxDataBase.Height
End Sub

Private Sub CmdExaminar_Click()
    Dim File As cFile
    Set File = New cFile
    
    If File.FOpen("", csRead, False, False) Then
        TxDataBase = File.FullNombre
        m_DataBase = TxDataBase
    End If
    Set File = Nothing
End Sub

Private Sub Form_Load()
    G_FormResult = True
    m_OK = False
    
    Set m_DB = Nothing
    m_App = ""
    m_PWDbyUser = False
    m_nombre = ""
    m_Clave = ""
    Height = Height - ScaleHeight + LnDetalle.Y1 - 10
    
    gWindow.CentrarForm Me
End Sub
Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    If UnloadMode <> vbFormCode Then
        m_OK = False
        G_FormResult = False
    End If
End Sub
Private Sub Form_KeyPress(KeyAscii As Integer)
    If KeyAscii = vbKeyEscape Then
        m_OK = False
        G_FormResult = False
        Unload Me
    End If
End Sub
Private Sub Form_Unload(Cancel As Integer)
    If m_OK Then
        SetRegistry
    End If
End Sub

Private Sub OpAccess_Click()
    m_AlreadyConnect = False
    LbCommentAccess.Visible = True
    CmdExaminar.Visible = True
    TxPWD.Visible = False
    TxUID.Visible = False
    TxServer.Visible = False
    LbServer.Visible = False
    LbUID.Visible = False
    LbPWD.Visible = False
End Sub

Private Sub OpSqlServer_Click()
    m_AlreadyConnect = False
    LbCommentAccess.Visible = False
    CmdExaminar.Visible = False
    TxPWD.Visible = True
    TxUID.Visible = True
    TxServer.Visible = True
    LbServer.Visible = True
    LbUID.Visible = True
    LbPWD.Visible = True
End Sub

Private Sub TxDataBase_Change()
    m_AlreadyConnect = False
    m_PWDbyUser = True
End Sub

Private Sub TxPWD_Change()
    m_AlreadyConnect = False
End Sub

Private Sub TxServer_Change()
    m_AlreadyConnect = False
End Sub

Private Sub TxUID_Change()
    m_AlreadyConnect = False
End Sub
