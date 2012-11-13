VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.1#0"; "CSMaskEdit2.ocx"
Begin VB.Form fActiveCode 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Codigo de Activación"
   ClientHeight    =   4980
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7320
   Icon            =   "fActiveCode.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4980
   ScaleWidth      =   7320
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox picHand 
      Height          =   495
      Left            =   120
      Picture         =   "fActiveCode.frx":058A
      ScaleHeight     =   435
      ScaleWidth      =   435
      TabIndex        =   17
      Top             =   3360
      Visible         =   0   'False
      Width           =   495
   End
   Begin CSButton.cButton cmdOk 
      Height          =   315
      Left            =   3600
      TabIndex        =   0
      Top             =   4560
      Width           =   1140
      _ExtentX        =   2011
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
   Begin CSButton.cButton cmdCancel 
      Cancel          =   -1  'True
      Height          =   315
      Left            =   4800
      TabIndex        =   1
      Top             =   4560
      Width           =   1140
      _ExtentX        =   2011
      _ExtentY        =   556
      Caption         =   "&Cerrar"
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
   Begin CSMaskEdit2.cMaskEdit txActiveCode 
      Height          =   315
      Left            =   2640
      TabIndex        =   2
      Top             =   2400
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
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderColor     =   12164479
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSMaskEdit2.cMaskEdit txClientCode 
      Height          =   315
      Left            =   2640
      TabIndex        =   5
      Top             =   1920
      Width           =   2655
      _ExtentX        =   4683
      _ExtentY        =   556
      BackColor       =   -2147483644
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
      Enabled         =   0   'False
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderColor     =   12164479
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSMaskEdit2.cMaskEdit txCompanys 
      Height          =   315
      Left            =   2640
      TabIndex        =   6
      Top             =   2880
      Width           =   2655
      _ExtentX        =   4683
      _ExtentY        =   556
      BackColor       =   -2147483644
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
      Enabled         =   0   'False
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderColor     =   12164479
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSMaskEdit2.cMaskEdit txUsers 
      Height          =   315
      Left            =   2640
      TabIndex        =   8
      Top             =   3360
      Width           =   2655
      _ExtentX        =   4683
      _ExtentY        =   556
      BackColor       =   -2147483644
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
      Enabled         =   0   'False
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderColor     =   12164479
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSMaskEdit2.cMaskEdit txActiveDate 
      Height          =   315
      Left            =   2640
      TabIndex        =   10
      Top             =   3840
      Width           =   2655
      _ExtentX        =   4683
      _ExtentY        =   556
      BackColor       =   -2147483644
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
      Enabled         =   0   'False
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderColor     =   12164479
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSButton.cButton cmdCopy 
      Height          =   315
      Left            =   5400
      TabIndex        =   13
      Top             =   1920
      Width           =   1800
      _ExtentX        =   3175
      _ExtentY        =   556
      Caption         =   "Copiar al portapapeles"
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
   Begin CSButton.cButton cmdApply 
      Height          =   315
      Left            =   6120
      TabIndex        =   14
      Top             =   4560
      Width           =   1140
      _ExtentX        =   2011
      _ExtentY        =   556
      Caption         =   "&Aplicar"
      Style           =   2
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
   Begin VB.Label lbTitle3 
      BackColor       =   &H00C0C0FF&
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   795
      Left            =   120
      TabIndex        =   16
      Top             =   840
      Width           =   7035
   End
   Begin VB.Label lbUrl 
      BackColor       =   &H00C0C0FF&
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   255
      Left            =   120
      TabIndex        =   15
      Top             =   540
      Width           =   7035
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   8015
      Y1              =   1680
      Y2              =   1680
   End
   Begin VB.Label lbTitle2 
      BackColor       =   &H00C0C0FF&
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   435
      Left            =   120
      TabIndex        =   12
      Top             =   60
      Width           =   7035
   End
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "Fecha de vencimiento :"
      Height          =   255
      Left            =   900
      TabIndex        =   11
      Top             =   3900
      Width           =   1665
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Usuarios :"
      Height          =   255
      Left            =   900
      TabIndex        =   9
      Top             =   3420
      Width           =   1665
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Empresas :"
      Height          =   255
      Left            =   900
      TabIndex        =   7
      Top             =   2940
      Width           =   1665
   End
   Begin VB.Image Image3 
      Height          =   480
      Left            =   180
      Picture         =   "fActiveCode.frx":0894
      Top             =   1935
      Width           =   480
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Codigo del cliente :"
      Height          =   255
      Left            =   900
      TabIndex        =   4
      Top             =   1980
      Width           =   1605
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "&Codigo de activacion :"
      Height          =   255
      Left            =   900
      TabIndex        =   3
      Top             =   2460
      Width           =   1665
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   -15
      X2              =   8000
      Y1              =   4380
      Y2              =   4380
   End
   Begin VB.Shape Shape1 
      BackStyle       =   1  'Opaque
      Height          =   5535
      Left            =   -60
      Top             =   -60
      Width           =   7515
   End
End
Attribute VB_Name = "fActiveCode"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fActiveCode
' 28-05-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fActiveCode"

Private m_bChanged As Boolean

Private Sub cmdApply_Click()
  pSaveActiveCode
End Sub

' estructuras
' variables privadas
' eventos
' propiedadades publicas
' propiedadades friend
' propiedades privadas
' funciones publicas

' funciones privadas
Private Sub cmdCancel_Click()
  On Error Resume Next
  Unload Me
End Sub

Private Sub cmdCopy_Click()
  On Error Resume Next
  Clipboard.Clear
  Clipboard.SetText txClientCode.Text
End Sub

Private Sub cmdOk_Click()
  If m_bChanged Then
    If Not pSaveActiveCode() Then Exit Sub
  End If
  cmdCancel_Click
End Sub

' funciones friend
' funciones privadas
Private Function pSaveActiveCode() As Boolean
  Dim sqlstmt   As String
  Dim db        As cDataBase
  Dim Connstr   As String
  Dim ErrorMsg  As String
  
  If IsValidCode(txActiveCode.Text) <> c_ACTIVE_CODE_OK Then
    MsgWarning "El código de activación no es valido"
  Else
    If Not GetConnstrToDomain(Connstr, ErrorMsg) Then
      CSKernelClient2.MsgWarning ErrorMsg, "Código de Activación"
    Else
      Set db = New cDataBase
      
      If Not db.InitDB(, , , , Connstr) Then Exit Function
      sqlstmt = "sp_SysDomainUpdateActiveCode " & db.sqlString(txActiveCode.Text)
      
      If Not db.Execute(sqlstmt) Then Exit Function
      
      pRefreshServer
      
      MsgInfo "El código de activación se ha ingresado exitosamente.;;Gracias por adquirir un producto CrowSoft."
      
      m_bChanged = False
      cmdApply.Enabled = False
      
      pSaveActiveCode = True
    End If
    
    pShowData
  End If
End Function

Private Sub pShowData()
  Dim strCode   As String
  
  GetMacAddressFromServer strCode, ""
  txClientCode.Text = strCode ' GetMACAddressInText(GetMACAddress())
  
  If GetActiveCode(strCode) Then
    txActiveCode.Text = strCode
    txActiveDate.Text = GetVto(strCode)
    txCompanys.Text = GetEmpresas(strCode)
    txUsers.Text = GetUsuarios(strCode)
  End If
End Sub

Private Sub pRefreshServer()
  Dim Buffer        As String
  Dim Message       As String
  Dim DataReceived  As String
  
  Buffer = TCPGetMessage(cTCPCommandRefreshActiveInfo, ClientProcessId, Message)
  If Not fMain.Client.SendAndReciveText(Buffer, SRV_ID_SERVER) Then
    MsgWarning "No se pudo informar la activacion al servicio.;;Debe reiniciar el servicio " & c_CompanyName
  End If
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError
  
  Dim str As String
  
  CSKernelClient2.LoadForm Me, Me.name
  
  lbTitle2.Caption = "Ingrese a la pagina de registración de " & c_CompanyName & " para obtener el código de activación." & vbCrLf & vbCrLf
  
  lbUrl.Caption = "http://www.crowsoft.com.ar/registracion.php?p=cairo"
  
  str = str & "Importante: Respete las mayusculas y minusculas." & vbCrLf & vbCrLf
  str = str & "Si presiona el bóton ""Copiar al portapeles"" puede pegar el código en la página y evitará errores de tipeo."
  
  lbTitle3.Caption = str
  
  lbTitle2.BackColor = vbWhite
  lbTitle3.BackColor = vbWhite
  lbUrl.BackColor = vbWhite
  
  pShowData
  
  cmdOk.Enabled = Len(txActiveCode.Text)
  m_bChanged = False
  cmdApply.Enabled = m_bChanged
  
  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error GoTo ControlError

  CSKernelClient2.UnloadForm Me, Me.name
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
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

Private Sub lbUrl_Click()
  On Error Resume Next
  SwhowPage lbUrl.Caption & "&c=" & txClientCode.Text, Me.hWnd
End Sub

Private Sub SwhowPage(ByVal strFile As String, ByVal hWnd As Long)
  CSKernelClient2.EditFile strFile, Me.hWnd
End Sub

Private Sub lbUrl_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
  On Error Resume Next
  Screen.MousePointer = vbCustom
  Screen.MouseIcon = picHand.Picture
End Sub

Private Sub txActiveCode_Change()
  On Error Resume Next
  cmdOk.Enabled = Len(txActiveCode.Text)
  m_bChanged = True
  cmdApply.Enabled = m_bChanged
End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
  Screen.MousePointer = vbDefault
End Sub

