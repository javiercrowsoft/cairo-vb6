VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.MDIForm fMain 
   AutoShowChildren=   0   'False
   BackColor       =   &H8000000C&
   Caption         =   "CrowSoft Consola del Administrador"
   ClientHeight    =   5145
   ClientLeft      =   165
   ClientTop       =   855
   ClientWidth     =   8265
   Icon            =   "fMain.frx":0000
   LinkTopic       =   "MDIForm1"
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.StatusBar sbrMain 
      Align           =   2  'Align Bottom
      Height          =   240
      Left            =   0
      TabIndex        =   2
      Top             =   4905
      Width           =   8265
      _ExtentX        =   14579
      _ExtentY        =   423
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   1
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
      EndProperty
   End
   Begin VB.PictureBox picBar 
      Align           =   1  'Align Top
      Appearance      =   0  'Flat
      BackColor       =   &H80000004&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   510
      Left            =   0
      ScaleHeight     =   510
      ScaleWidth      =   8265
      TabIndex        =   0
      Top             =   0
      Width           =   8265
      Begin VB.Label lbBar 
         BackStyle       =   0  'Transparent
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H8000000E&
         Height          =   285
         Left            =   270
         TabIndex        =   1
         Top             =   90
         Width           =   1635
      End
      Begin VB.Shape shBar 
         BackColor       =   &H80000010&
         BackStyle       =   1  'Opaque
         BorderStyle     =   0  'Transparent
         Height          =   375
         Left            =   45
         Shape           =   4  'Rounded Rectangle
         Top             =   90
         Width           =   3255
      End
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&Archivo"
      Begin VB.Menu mnuChangePwd 
         Caption         =   "Cambiar Cl&ave..."
      End
      Begin VB.Menu mnuFileSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuExit 
         Caption         =   "&Salir"
      End
   End
   Begin VB.Menu mnuSys 
      Caption         =   "&Sistema"
      Begin VB.Menu mnuActiveCode 
         Caption         =   "&Codigo de Activación..."
      End
      Begin VB.Menu mnuSysSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuDataBases 
         Caption         =   "&Empresas..."
      End
      Begin VB.Menu mnuSysSep2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuSysConnectDom2 
         Caption         =   "&Conexión para CSUpdate..."
      End
   End
   Begin VB.Menu mMonitor 
      Caption         =   "&Monitor"
      Begin VB.Menu mnuMonitorClientList 
         Caption         =   "&Clientes Conectados..."
      End
   End
   Begin VB.Menu mnuTools 
      Caption         =   "&Herramientas"
      Begin VB.Menu mnuFileConfig 
         Caption         =   "&Configuración..."
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "A&yuda"
      Begin VB.Menu mnuAbout 
         Caption         =   "Acerca de CSAdmin..."
      End
   End
End
Attribute VB_Name = "fMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fMain
' 27-04-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fMain"

Private Const c_sbrOperation = "k1"
Private Const c_sbrPercent = "k2"
Private Const c_sbrStatus = "k3"
Private Const c_sbrInfo = "k4"

' estructuras
' variables privadas
Private WithEvents m_Client                        As cTCPIPClient
Attribute m_Client.VB_VarHelpID = -1

' eventos
' propiedadades publicas
Public Property Get Client() As cTCPIPClient
   Set Client = m_Client
End Property

Public Property Set Client(ByRef rhs As cTCPIPClient)
   Set m_Client = rhs
End Property

Public Property Let Operation(ByVal rhs As String)
   sbrMain.Panels(c_sbrOperation).Text = rhs & "..."
End Property

Public Property Let Percent(ByVal rhs As Double)
   sbrMain.Panels(c_sbrPercent).Text = rhs
End Property

Public Property Let Status(ByVal rhs As String)
   sbrMain.Panels(c_sbrStatus).Text = rhs
End Property

Public Property Let Info(ByVal rhs As String)
   sbrMain.Panels(c_sbrInfo).Text = rhs
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub m_Client_ReciveText(ByVal Buffer As String)
  On Error GoTo ControlError
  
  ProcessMessage Buffer

  GoTo ExitProc
ControlError:
  MngError Err, "m_Client_ReciveText", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuAbout_Click()
  fSplash.IsSplash = False
  fSplash.Show vbModal
End Sub

Private Sub mnuActiveCode_Click()
  On Error Resume Next
  fActiveCode.Show vbModal
End Sub

Private Sub mnuChangePwd_Click()
  On Error Resume Next
  fChangePwd.Show vbModal
End Sub

Private Sub mnuDataBases_Click()
  On Error Resume Next
  fDataBases.Show
End Sub

Private Sub mnuExit_Click()
  On Error Resume Next
  Unload Me
  CloseApp
End Sub

Private Sub mnuFileConfig_Click()
  EditConfig
End Sub

Private Sub mnuMonitorClientList_Click()
  ListClients
End Sub

Private Sub mnuSysConnectDom2_Click()
  On Error GoTo ControlError

  fLogin2.Show vbModal
  
  If fLogin2.Ok Then
  
  On Error GoTo ControlError
  
    Dim sqlstmt     As String
    Dim db          As cDataBase
    Dim rs          As Recordset
    Dim Encrypt     As cEncrypt
    Dim dbAux       As cDataSource
    Dim strConnect  As String
    
    Set Encrypt = New cEncrypt
    Set dbAux = New cDataSource
    
    sqlstmt = "sp_SysDomainUpdateDom2 " & vbCrLf
    With fLogin2
    
      strConnect = dbAux.GetConnetString( _
                        .txServer.Text, _
                        .txDataBase.Text, _
                        .txUser.Text, _
                        .txPassword.Text, _
                        .chkNTSecurity.Value = vbChecked)
                        
      Set db = GetDataBaseDom2(strConnect)
                        
      sqlstmt = sqlstmt & _
                db.sqlString( _
                  Encrypt.Encript( _
                    dbAux.GetConnetString( _
                        .txServer.Text, _
                        .txDataBase.Text, _
                        .txUser.Text, _
                        .txPassword.Text, _
                        .chkNTSecurity.Value = vbChecked), _
                    c_LoginSignature))
    End With
    
    If Not db.OpenRs(sqlstmt, rs) Then GoTo ExitProc
  
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "pInitForm", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  Unload fLogin2
End Sub

Private Function GetDataBaseDom2(ByVal strConnect As String) As cDataBase
  Dim db        As cDataBase
  
  Set db = New cDataBase
  If Not db.InitDB(, , , , strConnect) Then
    Exit Function
  End If
  
  Set GetDataBaseDom2 = db
End Function

Private Sub picBar_Resize()
  On Error Resume Next
  shBar.Width = picBar.ScaleWidth - shBar.Left * 2
  lbBar.Width = picBar.ScaleWidth - lbBar.Left * 2
End Sub

Private Sub pInitForm()
  On Error GoTo ControlError

  With sbrMain
    
    .Panels.Clear
    
    With .Panels.Add(, c_sbrOperation)
      .Width = 3000
      .Style = sbrText
    End With
    With .Panels.Add(, c_sbrPercent)
      .Width = 800
      .Style = sbrText
    End With
    With .Panels.Add(, c_sbrStatus)
      .Width = 1000
      .Style = sbrText
    End With
    With .Panels.Add(, c_sbrInfo)
      .AutoSize = sbrSpring
      .Style = sbrText
    End With
    With .Panels.Add
      .AutoSize = sbrContents
      .Style = sbrTime
    End With
  End With

  GoTo ExitProc
ControlError:
  MngError Err, "pInitForm", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
Private Sub MDIForm_Load()
  pInitForm
  LoadForm Me, Me.name
End Sub

Private Sub MDIForm_Unload(Cancel As Integer)
  CSKernelClient2.UnloadForm Me, Me.name
  CloseApp
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
