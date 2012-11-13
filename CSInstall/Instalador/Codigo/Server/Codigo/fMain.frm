VERSION 5.00
Begin VB.Form fMain 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Install Server"
   ClientHeight    =   5085
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8055
   Icon            =   "fMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5085
   ScaleWidth      =   8055
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txFolder 
      BorderStyle     =   0  'None
      Height          =   300
      Left            =   1580
      TabIndex        =   0
      Top             =   2835
      Width           =   5575
   End
   Begin VB.Image Image1 
      Height          =   1800
      Left            =   60
      Picture         =   "fMain.frx":08CA
      Top             =   120
      Width           =   8025
   End
   Begin VB.Image cmdExplorer 
      Height          =   330
      Left            =   7140
      Picture         =   "fMain.frx":4BB6
      Top             =   2820
      Width           =   315
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H0080C0FF&
      Height          =   330
      Left            =   1560
      Top             =   2820
      Width           =   5595
   End
   Begin VB.Image cmdOk 
      Height          =   330
      Left            =   4140
      Picture         =   "fMain.frx":4ECE
      Top             =   4440
      Width           =   1635
   End
   Begin VB.Image cmdCancel 
      Height          =   330
      Left            =   5820
      Picture         =   "fMain.frx":56C8
      Top             =   4440
      Width           =   1635
   End
End
Attribute VB_Name = "fMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const COLOR_OSCURO = &HD8E0E8
Private Const COLOR_SELECCION = &HBFEFFF
Private Const COLOR_FONDO = &HF5FFFF
Private Const COLOR_LETRAS = &H80&
Private Const COLOR_EVEN = &HF9FEFF
Private Const COLOR_ODD = &HEFF7F7
Private Const COLOR_BOTONES = &HD8E0E8

Private Const COLOR_JANUS_BACK = COLOR_FONDO
Private Const COLOR_JANUS_HEADER = COLOR_OSCURO
Private Const COLOR_TDBGRID_BACK = COLOR_FONDO
Private Const COLOR_TDBGRID_EDITBACKCOLOR = COLOR_FONDO
Private Const COLOR_TDBGRID_SELECT = COLOR_SELECCION
Private Const COLOR_TDBGRID_HEADER = COLOR_OSCURO
Private Const COLOR_TDBGRID_INACTIVEBACKCOLOR = COLOR_OSCURO
Private Const COLOR_TDBGRID_DEADAREA = COLOR_FONDO

Private Sub cmdOk_Click()
  '1) Copiar archivos
  If Not CopyFiles(txFolder.Text) Then Exit Sub
  
  '2) Crear shortcuts
  If Not pCreateShortCut() Then Exit Sub
  
  '3) Registrar componentes
  fMain2.Path = txFolder.Text
  fMain2.Show vbModal
  
  '4) Crear bases de datos
  If Not pCrearDataBases() Then Exit Sub
  
  '5) Registrar servicio
  If Not InstallService("CSServer", "CrowSoft Server", txFolder.Text & "\CSServer.exe") Then Exit Sub
  
  'MsgBox "La instalación server ha concluido con éxito."
  fFinish.Show vbModal
  
  If Not pLaunchCSAdmin() Then Exit Sub
  
  Unload Me
End Sub

Private Function pLaunchCSAdmin() As Boolean
  On Error GoTo ControlError
  Dim shelstmt As String
  
  shelstmt = txFolder.Text & "\CSAdmin.exe"
  pLaunchCSAdmin = ShellExecute(shelstmt, vbNormalFocus)

  Exit Function
ControlError:
  MngError "pLaunchCSAdmin", vbCritical
End Function

Private Function pCrearDataBases() As Boolean
  On Error GoTo ControlError
  
  Dim InstallDb As Object
  Set InstallDb = CreateObject("CSInstallDB.cInstallDB")
  
  pCrearDataBases = InstallDb.CreateDataBases(txFolder.Text & "\Data", txFolder.Text & "\Install_File", txFolder.Text)
  
ExitSuccess:
  Exit Function
ControlError:
  MngError "pCrearDataBases", vbCritical
  Resume ExitSuccess
End Function

Private Sub cmdBrowse_Click()
  Dim fld As cFolder
  Set fld = New cFolder
  Dim sPath As String
  
  sPath = fld.SeleccionarDirectorio(Me)
  
  If sPath <> "" Then txFolder.Text = sPath
End Sub

Private Sub cmdCancel_Click()
  UnloadForm
End Sub

Private Sub Form_Load()
  On Error Resume Next
  Me.Left = (Screen.Width - Me.Width) * 0.5
  Me.Top = (Screen.Height - Me.Height) * 0.5
  txFolder.Text = GetEspecialFolders(&H26) & "\CrowSoft"
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If UnloadMode <> vbFormCode Then Cancel = UnloadForm
End Sub

Private Function UnloadForm() As Boolean
  If vbYes = MsgBox("Si cancela la instalación CrowSoft no podra ejecutarce." & vbCrLf & vbCrLf & "Puede volver a correr la instalación en otra ocasión." & vbCrLf & vbCrLf & "¿Desea cancelar de todas formas?", vbYesNo + vbQuestion, "Instalación") Then
    Unload Me
  Else
    UnloadForm = True
  End If
End Function

Private Sub cmdExplorer_Click()
  On Error GoTo ControlError

  Dim fld As cFolder
  Dim sFld As String

  Set fld = New cFolder
  sFld = fld.SeleccionarDirectorio(Me)
  If sFld <> "" Then txFolder.Text = sFld
  
ExitSuccess:
  Exit Sub
ControlError:
  MngError "cmdExplorer_Click", vbCritical
  Resume ExitSuccess
End Sub

Private Function pCreateShortCut() As Boolean
  Dim i     As Integer
  Dim sFile As String
  
  For i = 1 To UBound(gFileNames)
    sFile = GetPath() & gFileNames(i) & ".exe"
    If FileExists(sFile) Then
      If Not CreateShortCut(gFileNames(i), sFile, csEDeskTop) Then Exit Function
    End If
  Next
  pCreateShortCut = True
End Function

Private Function GetPath() As String
  If Right(txFolder.Text, 1) = "\" Then
    GetPath = txFolder.Text
  Else
    GetPath = txFolder.Text & "\"
  End If
End Function
