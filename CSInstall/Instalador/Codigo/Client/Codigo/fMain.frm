VERSION 5.00
Begin VB.Form fMain 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Install Client"
   ClientHeight    =   2775
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8145
   Icon            =   "fMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2775
   ScaleWidth      =   8145
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txFolder 
      BorderStyle     =   0  'None
      Height          =   285
      Left            =   300
      TabIndex        =   0
      Top             =   1995
      Width           =   5525
   End
   Begin VB.Image cmdCancel 
      Height          =   330
      Left            =   6360
      Picture         =   "fMain.frx":08CA
      Top             =   2400
      Width           =   1635
   End
   Begin VB.Image cmdOk 
      Height          =   330
      Left            =   6360
      Picture         =   "fMain.frx":113A
      Top             =   1980
      Width           =   1635
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H0080C0FF&
      Height          =   330
      Left            =   240
      Top             =   1980
      Width           =   5595
   End
   Begin VB.Image Image1 
      Height          =   1800
      Left            =   120
      Picture         =   "fMain.frx":1934
      Top             =   120
      Width           =   8025
   End
   Begin VB.Image cmdExplorer 
      Height          =   330
      Left            =   5820
      Picture         =   "fMain.frx":6168
      Top             =   1980
      Width           =   315
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
  If DirExists(txFolder.Text) Then
  
    If Not pCreateShortCut() Then Exit Sub
    
    fMain2.Path = txFolder.Text
    fMain2.Show vbModal
    
    MsgBox "La instalación ha concluido con éxito."
    
    pInstallPDF
    
    Unload Me
  Else
    MsgBox "Debe indicar un nombre de archivo valido.", vbExclamation, "Instalación"
  End If
End Sub

Private Sub pInstallPDF()
  If Ask("Desea instalar la impresora [novaPDF Pro v5] que le permitira exportar los reportes a PDF y enviarlos por e-mail") Then
    
    ShellExecute App.Path & "\NOVAPDF\novapin.exe /SILENT /PrinterName=""novaPDF Pro v5""", vbNormalFocus, False
  End If
End Sub

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
  Me.Left = (Screen.Width - Me.Width) * 0.5
  Me.Top = (Screen.Height - Me.Height) * 0.5
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If UnloadMode <> vbFormCode Then Cancel = UnloadForm
End Sub

Private Function UnloadForm() As Boolean
  If vbYes = MsgBox("Si cancela no se creara un acceso directo a la aplicación en su escritorio." & vbCrLf & vbCrLf & "¿Desea cancelar de todas formas?", vbYesNo + vbQuestion, "Instalación") Then
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
  MngError "Sub TxPath_Buttonhit", vbCritical
  Resume ExitSuccess
End Sub

Private Sub MngError(ByVal FunctionName As String, Optional ByVal Severity As Integer)
  MsgBox "Error en funcion: " & FunctionName & vbCrLf & vbCrLf & Err.Description, vbExclamation, "Error"
End Sub

Private Function pCreateShortCut() As Boolean
  Dim i     As Integer
  Dim sFile As String
  
  For i = 1 To UBound(gFileNames)
    sFile = GetPath() & gFileNames(i) & ".exe"
    If FileExists(sFile) Then
      If Not CreateShortcut(gFileNames(i), sFile, csEDeskTop) Then Exit Function
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
