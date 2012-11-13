VERSION 5.00
Object = "{E82A759A-7510-4F56-B239-9C0B78CF437B}#1.0#0"; "CSImageList.ocx"
Object = "{E3029087-6983-4DF6-A07F-E770EFB12BC0}#1.1#0"; "CSToolBar.ocx"
Object = "{757F6B6F-8057-4D0A-85C2-0A1807E33D34}#1.0#0"; "CSGrid2.ocx"
Begin VB.Form fListClients 
   Caption         =   "Usuarios conectados"
   ClientHeight    =   4590
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5790
   Icon            =   "fListClients.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   4590
   ScaleWidth      =   5790
   Begin CSImageList.cImageList ilList 
      Left            =   3720
      Top             =   2520
      _ExtentX        =   953
      _ExtentY        =   953
      Size            =   1880
      Images          =   "fListClients.frx":08CA
      KeyCount        =   2
      Keys            =   "ÿ"
   End
   Begin CSGrid2.cGrid cgrClients 
      Height          =   1860
      Left            =   180
      TabIndex        =   0
      Top             =   540
      Width           =   3705
      _ExtentX        =   6535
      _ExtentY        =   3281
      BackgroundPictureHeight=   0
      BackgroundPictureWidth=   0
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin CSToolBar.cReBar rbMain 
      Left            =   0
      Top             =   0
      _ExtentX        =   8678
      _ExtentY        =   979
   End
   Begin CSToolBar.cToolbar tbrTool 
      Height          =   555
      Left            =   585
      Top             =   3465
      Width           =   3885
      _ExtentX        =   6853
      _ExtentY        =   979
   End
End
Attribute VB_Name = "fListClients"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fListClients
' 00-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fListClients"
' estructuras
' variables privadas
Private m_IsPresent As Boolean
' eventos
' propiedadades publicas
Public Property Get IsPresent() As Boolean
  IsPresent = m_IsPresent
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Sub Update()
  On Error Resume Next
  ListClients
End Sub
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  Me.WindowState = vbMaximized

  cgrClients.ImageList = ilList

  m_IsPresent = True
  
  pSetToolBar
  
  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pSetToolBar()
  Dim Buttons1 As Long
  
  Buttons1 = BUTTON_UPDATE
  CSKernelClient2.SetToolBarEx tbrTool, Buttons1, 0, 0
  
  With rbMain
    .DestroyRebar
    .CreateRebar Me.hWnd
    .AddBandByHwnd tbrTool.hWnd, , , , "MainToolBar"
    .BandChildMinWidth(.BandCount - 1) = 24
  End With

  DoEvents
  
  Form_Resize
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  Dim tbHeight As Integer
  rbMain.RebarSize
  tbHeight = rbMain.RebarHeight * Screen.TwipsPerPixelY + 60
  cgrClients.Move 0, tbHeight, ScaleWidth, ScaleHeight - tbHeight
End Sub

Private Sub Form_Unload(Cancel As Integer)
  m_IsPresent = False
End Sub

Private Sub tbrTool_ButtonClick(ByVal lButton As Long)
  On Error Resume Next
  CSKernelClient2.PresButtonToolbarEx tbrTool.ButtonKey(lButton), Me
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
