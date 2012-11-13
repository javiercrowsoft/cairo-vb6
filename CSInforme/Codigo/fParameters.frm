VERSION 5.00
Object = "{AAE806BF-0AA4-415D-8EAA-4F0A32FF6B71}#1.5#0"; "CSControls2.ocx"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form fParameters 
   Caption         =   "Parametros"
   ClientHeight    =   7455
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5475
   Icon            =   "fParameters.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7455
   ScaleWidth      =   5475
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.Toolbar tbrTool 
      Align           =   1  'Align Top
      Height          =   630
      Left            =   0
      TabIndex        =   1
      Top             =   0
      Width           =   5475
      _ExtentX        =   9657
      _ExtentY        =   1111
      ButtonWidth     =   609
      ButtonHeight    =   953
      Appearance      =   1
      _Version        =   393216
   End
   Begin CSControls2.cReportParam rptParams 
      Height          =   6015
      Left            =   60
      TabIndex        =   0
      Top             =   1320
      Width           =   5235
      _ExtentX        =   9234
      _ExtentY        =   10610
      HelpType        =   2
   End
End
Attribute VB_Name = "fParameters"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'--------------------------------------------------------------------------------
' fParameters
' 05-10-03

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
Private m_Name      As String
Private m_Buttons1  As Long
Private m_Buttons2  As Long
Private m_Buttons3  As Long
Private m_IconText  As Integer
Private m_Reporte   As cReporte

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

' propiedades privadas
' propiedades publicas
Public Property Get NameEdit() As String
    NameEdit = m_Name
End Property
Public Property Let NameEdit(ByVal rhs As String)
    m_Name = rhs
End Property
Public Property Get Buttons1() As Long
    Buttons1 = m_Buttons1
End Property
Public Property Let Buttons1(ByVal rhs As Long)
    m_Buttons1 = rhs
End Property
Public Property Get Buttons2() As Long
    Buttons2 = m_Buttons2
End Property
Public Property Let Buttons2(ByVal rhs As Long)
    m_Buttons2 = rhs
End Property
Public Property Get Buttons3() As Long
    Buttons3 = m_Buttons3
End Property
Public Property Let Buttons3(ByVal rhs As Long)
    m_Buttons3 = rhs
End Property
Public Property Get IconPersona() As Integer
    IconPersona = csIMG_PERSON
End Property
Public Property Get IconRoles() As Integer
    IconRoles = csIMG_ROLS
End Property
Public Property Get IconCubo() As Integer
    IconCubo = csIMG_REDCUBE
End Property
Public Property Get IconText() As Integer
    IconText = m_IconText
End Property
Public Property Let IconText(ByVal rhs As Integer)
    m_IconText = rhs
End Property
Public Property Get Reporte() As cReporte
   Set Reporte = m_Reporte
End Property
Public Property Set Reporte(ByRef rhs As cReporte)
   Set m_Reporte = rhs
End Property
' propiedades privadas
' funciones publicas
Public Function Init() As Boolean
  Caption = m_Name
  rptParams.NameClient = m_Name
  rptParams.Buttons1 = m_Buttons1
  rptParams.Buttons2 = m_Buttons2
  rptParams.Buttons3 = m_Buttons3
  rptParams.SetToolBar
  Init = True
End Function

Public Sub ReloadParams()
  rptParams.ReloadParams
End Sub

Public Sub Saveparams()
  rptParams.Saveparams
End Sub

' funciones privadas
Private Sub rptParams_ToolBarClick(ByVal Button As Object)
  On Error GoTo ControlError

  Dim o As cIEditGeneric
  Select Case Button.key
    Case "EXIT"
      Unload Me
    Case "PREVIEW"
      m_Reporte.Launch csRptLaunchPreview
    Case "PRINTOBJ"
      m_Reporte.Launch csRptLaunchPrinter
    Case "GRID"
      m_Reporte.LaunchGrid
    Case "SAVE_PARAMS"
      Saveparams
    Case "RELOAD_PARAMS"
      ReloadParams
  End Select
  Exit Sub
ControlError:
  MngError Err, "rptParams_ToolBarClick", "fParameters", ""
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  
  Dim tbHeight As Integer
  
  tbHeight = tbrTool.Height + 60
  
  rptParams.Move 0, tbHeight, ScaleWidth, ScaleHeight - tbHeight
End Sub

Private Function pSetToolBar()
  On Error Resume Next
  
  Buttons1 = Buttons1 + BUTTON_PREVIEW
  Buttons1 = Buttons1 + BUTTON_PRINTOBJ
  Buttons1 = Buttons1 + BUTTON_GRID
  Buttons2 = BUTTON_SAVE_PARAMS + BUTTON_RELOAD_PARAMS
  
  CSKernelClient2.SetToolBar24 tbrTool, Buttons1, Buttons2, Buttons3, m_UserCfg.ViewNamesInToolbar
    
  DoEvents
  
  Form_Resize
End Function

Private Sub tbrTool_ButtonClick(ByVal Button As MSComctlLib.Button)
  On Error Resume Next
  rptParams_ToolBarClick Button
End Sub

' construccion - destruccion
Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  
  ' Preferencias del Usuario
  '
  Set m_UserCfg = Nothing
  
  CSKernelClient2.UnloadForm Me, m_Name
  m_Reporte.Terminate
  Set m_Reporte = Nothing
End Sub

Private Sub Form_Load()
  On Error Resume Next
  CSKernelClient2.LoadForm Me, m_Name
  
  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load
  
  pSetToolBar
End Sub
