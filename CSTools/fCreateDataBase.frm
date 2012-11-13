VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form fCreateDataBase 
   BorderStyle     =   3  'Fixed Dialog
   ClientHeight    =   5610
   ClientLeft      =   45
   ClientTop       =   420
   ClientWidth     =   6960
   Icon            =   "fCreateDataBase.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5610
   ScaleWidth      =   6960
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox frDefinition 
      BorderStyle     =   0  'None
      Height          =   4785
      Left            =   90
      ScaleHeight     =   4785
      ScaleWidth      =   6765
      TabIndex        =   0
      Top             =   45
      Width           =   6765
      Begin VB.TextBox txLogSize 
         Alignment       =   1  'Right Justify
         Height          =   300
         Left            =   1035
         TabIndex        =   14
         Top             =   4185
         Width           =   720
      End
      Begin VB.TextBox txLogFile 
         Height          =   300
         Left            =   1035
         TabIndex        =   11
         Top             =   3825
         Width           =   4965
      End
      Begin VB.CommandButton cmdLogFindFile 
         Caption         =   "..."
         Height          =   285
         Left            =   6030
         TabIndex        =   12
         Top             =   3825
         Width           =   375
      End
      Begin VB.TextBox txDataSize 
         Alignment       =   1  'Right Justify
         Height          =   300
         Left            =   1035
         TabIndex        =   8
         Top             =   2745
         Width           =   720
      End
      Begin VB.TextBox txDataFile 
         Height          =   300
         Left            =   1035
         TabIndex        =   5
         Top             =   2385
         Width           =   4965
      End
      Begin VB.CommandButton cmdDataFindFile 
         Caption         =   "..."
         Height          =   285
         Left            =   6030
         TabIndex        =   6
         Top             =   2385
         Width           =   375
      End
      Begin VB.TextBox txName 
         Height          =   300
         Left            =   1035
         TabIndex        =   2
         Top             =   1395
         Width           =   4965
      End
      Begin VB.Label Label9 
         Caption         =   "MB"
         Height          =   285
         Left            =   1845
         TabIndex        =   34
         Top             =   4230
         Width           =   510
      End
      Begin VB.Label Label8 
         Caption         =   "MB"
         Height          =   285
         Left            =   1845
         TabIndex        =   33
         Top             =   2790
         Width           =   510
      End
      Begin VB.Line Line6 
         BorderColor     =   &H80000010&
         X1              =   0
         X2              =   6855
         Y1              =   3330
         Y2              =   3330
      End
      Begin VB.Line Line5 
         BorderColor     =   &H80000014&
         X1              =   0
         X2              =   6855
         Y1              =   3345
         Y2              =   3345
      End
      Begin VB.Line Line4 
         BorderColor     =   &H80000010&
         X1              =   -45
         X2              =   6810
         Y1              =   1935
         Y2              =   1935
      End
      Begin VB.Line Line3 
         BorderColor     =   &H80000014&
         X1              =   -45
         X2              =   6810
         Y1              =   1950
         Y2              =   1950
      End
      Begin VB.Label lbDescrip 
         BackColor       =   &H80000005&
         Caption         =   "Debe indicar un nombre para la base de datos y un nombre y un tamaño para los archivos de datos y log."
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   645
         Left            =   405
         TabIndex        =   18
         Top             =   405
         Width           =   6360
      End
      Begin VB.Label Label6 
         Caption         =   "Ta&maño :"
         Height          =   330
         Left            =   315
         TabIndex        =   13
         Top             =   4185
         Width           =   825
      End
      Begin VB.Label Label5 
         Caption         =   "A&rchivo :"
         Height          =   330
         Left            =   315
         TabIndex        =   10
         Top             =   3825
         Width           =   825
      End
      Begin VB.Label Label4 
         Caption         =   "Log :"
         Height          =   330
         Left            =   315
         TabIndex        =   9
         Top             =   3465
         Width           =   825
      End
      Begin VB.Label Label3 
         Caption         =   "&Tamaño :"
         Height          =   330
         Left            =   315
         TabIndex        =   7
         Top             =   2745
         Width           =   825
      End
      Begin VB.Label Label2 
         Caption         =   "Archiv&o :"
         Height          =   330
         Left            =   315
         TabIndex        =   4
         Top             =   2385
         Width           =   825
      End
      Begin VB.Label Label1 
         Caption         =   "Data :"
         Height          =   330
         Left            =   315
         TabIndex        =   3
         Top             =   2025
         Width           =   825
      End
      Begin VB.Label lbName 
         Caption         =   "&Nombre :"
         Height          =   330
         Left            =   315
         TabIndex        =   1
         Top             =   1440
         Width           =   825
      End
      Begin VB.Label lbDescripBack 
         BackColor       =   &H80000005&
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1005
         Left            =   45
         TabIndex        =   19
         Top             =   180
         Width           =   6675
      End
   End
   Begin MSComctlLib.ImageList liProgress 
      Left            =   3195
      Top             =   2520
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   4
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fCreateDataBase.frx":000C
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fCreateDataBase.frx":0166
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fCreateDataBase.frx":0700
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fCreateDataBase.frx":085A
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.PictureBox frProgress 
      BorderStyle     =   0  'None
      Height          =   4785
      Left            =   315
      ScaleHeight     =   4785
      ScaleWidth      =   6765
      TabIndex        =   25
      Top             =   360
      Width           =   6765
      Begin MSComctlLib.ProgressBar prgbProgress 
         Height          =   330
         Left            =   180
         TabIndex        =   29
         Top             =   3915
         Width           =   6450
         _ExtentX        =   11377
         _ExtentY        =   582
         _Version        =   393216
         BorderStyle     =   1
         Appearance      =   0
         Scrolling       =   1
      End
      Begin MSComctlLib.ListView lvProgress 
         Height          =   2175
         Left            =   180
         TabIndex        =   28
         Top             =   1440
         Width           =   6450
         _ExtentX        =   11377
         _ExtentY        =   3836
         LabelWrap       =   -1  'True
         HideSelection   =   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   0
      End
      Begin MSComctlLib.ProgressBar prgbProgressFull 
         Height          =   330
         Left            =   180
         TabIndex        =   32
         Top             =   4365
         Width           =   6450
         _ExtentX        =   11377
         _ExtentY        =   582
         _Version        =   393216
         BorderStyle     =   1
         Appearance      =   0
         Scrolling       =   1
      End
      Begin VB.Label lbProgress 
         Height          =   240
         Left            =   1485
         TabIndex        =   30
         Top             =   3645
         Width           =   4335
      End
      Begin VB.Label Label7 
         Caption         =   "Creando objeto:"
         Height          =   240
         Left            =   225
         TabIndex        =   31
         Top             =   3645
         Width           =   1680
      End
      Begin VB.Label lbDescrip3 
         BackColor       =   &H80000005&
         Caption         =   "Todo listo"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   645
         Left            =   360
         TabIndex        =   26
         Top             =   540
         Width           =   6360
      End
      Begin VB.Label lbDescripBack3 
         BackColor       =   &H80000005&
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1005
         Left            =   0
         TabIndex        =   27
         Top             =   315
         Width           =   6675
      End
   End
   Begin MSComDlg.CommonDialog cd 
      Left            =   1845
      Top             =   5130
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton cmdDoScript 
      Caption         =   "&Script"
      Height          =   330
      Left            =   45
      TabIndex        =   24
      Top             =   5130
      Width           =   1275
   End
   Begin VB.CommandButton cmdBack 
      Caption         =   "&Atras"
      Height          =   330
      Left            =   2835
      TabIndex        =   15
      Top             =   5130
      Width           =   1275
   End
   Begin VB.CommandButton cmdNext 
      Caption         =   "&Siguiente"
      Height          =   330
      Left            =   4140
      TabIndex        =   16
      Top             =   5130
      Width           =   1275
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&Cancelar"
      Height          =   330
      Left            =   5625
      TabIndex        =   17
      Top             =   5130
      Width           =   1275
   End
   Begin VB.PictureBox frDescrip 
      BorderStyle     =   0  'None
      Height          =   4785
      Left            =   225
      ScaleHeight     =   4785
      ScaleWidth      =   6765
      TabIndex        =   20
      Top             =   360
      Width           =   6765
      Begin VB.TextBox txDescrip 
         BeginProperty Font 
            Name            =   "Courier New"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   3210
         Left            =   135
         MultiLine       =   -1  'True
         ScrollBars      =   3  'Both
         TabIndex        =   23
         Top             =   1305
         Width           =   6495
      End
      Begin VB.Label lbDescrip2 
         BackColor       =   &H80000005&
         Caption         =   "Todo listo"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   645
         Left            =   360
         TabIndex        =   21
         Top             =   540
         Width           =   6360
      End
      Begin VB.Label lbDescripBack2 
         BackColor       =   &H80000005&
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1005
         Left            =   0
         TabIndex        =   22
         Top             =   315
         Width           =   6675
      End
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   45
      X2              =   6900
      Y1              =   5010
      Y2              =   5010
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   45
      X2              =   6900
      Y1              =   4995
      Y2              =   4995
   End
End
Attribute VB_Name = "fCreateDataBase"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fCreateDataBase
' 15-05-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fCreateDataBase"

Private Const c_descrip = 1
' estructuras
' variables privadas
Private m_Ok            As Boolean

Private m_oldDataBaseName As String
Private m_IsForInstall    As Boolean
' eventos
Public Event MoveNext()
Public Event MoveBack()
Public Event Cancel()
Public Event FindFile(ByVal Database As String, ByRef File As String, ByVal Title As String, ByRef Cancel As Boolean)
Public Event DoScript()
Public Event ErrorDetail(ByRef Managed As Boolean, ByVal Id As Integer)
' propiedadades publicas
Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property
Friend Property Let IsForInstall(ByRef rhs As Boolean)
  m_IsForInstall = rhs
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function CreateDataBase()
  If m_IsForInstall Then
    cmdNext_Click
    cmdNext_Click
    cmdNext_Click
  End If
End Function

Public Function Progress(ByVal Descrip As String, ByVal Percent As Integer)
  On Error Resume Next
  prgbProgress.Value = Percent
  lbProgress.Caption = Descrip
End Function

Public Sub InitProgressFull(ByVal Max As Integer)
  On Error Resume Next
  prgbProgressFull.Max = Max
End Sub

Public Sub ProgressFull(Optional ByVal Init As Boolean)
  On Error Resume Next
  If Init Then
    prgbProgressFull.Value = 0
  Else
    prgbProgressFull.Value = prgbProgressFull.Value + 1
  End If
End Sub

Public Function ShowProgress(ByVal Id As Integer, ByVal Descrip As String, ByVal Icon As csIconProgress) As Integer
  On Error Resume Next
  
  Dim li As ListItem
  
  ' Nuevo mensaje
  If Id = 0 Then
    Set li = lvProgress.ListItems.Add()
    li.ListSubItems.Add
    li.ListSubItems.Add
    Id = li.Index
  Else
    Set li = lvProgress.ListItems(Id)
    If li Is Nothing Then Exit Function
  End If

  If Icon <> 0 Then
    li.SmallIcon = Icon
  End If

  li.SubItems(c_descrip) = Descrip
  
  li.EnsureVisible
  
  DoEvents
  
  ShowProgress = Id
End Function
' funciones friend
' funciones privadas
Private Sub cmdNext_Click()
  On Error Resume Next
  m_Ok = True
  RaiseEvent MoveNext
End Sub

Private Sub cmdBack_Click()
  On Error Resume Next
  RaiseEvent MoveBack
End Sub

Private Sub cmdDoScript_Click()
  On Error Resume Next
  RaiseEvent DoScript
End Sub

Private Sub lvProgress_DblClick()
  On Error Resume Next
    
  If lvProgress.SelectedItem Is Nothing Then Exit Sub
  
  Dim Managed As Boolean
  RaiseEvent ErrorDetail(Managed, lvProgress.SelectedItem.Index)
  
  If Managed Then Exit Sub
  
  Dim f As fErrorDetail
  Set f = New fErrorDetail
  f.txDetail.Text = lvProgress.SelectedItem.SubItems(c_descrip)
  f.Icon = liProgress.ListImages(lvProgress.SelectedItem.SmallIcon).Picture
  f.Show vbModal
  Unload f
End Sub

Private Sub txDataSize_KeyPress(KeyAscii As Integer)
  On Error GoTo ControlError
  
  KeyAscii = CharacterValidForInteger(KeyAscii)
  
  GoTo ExitProc
ControlError:
  MngError Err, "txDataSize_KeyPress", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub txDescrip_KeyPress(KeyAscii As Integer)
  KeyAscii = 0
End Sub

Private Sub txLogSize_KeyPress(KeyAscii As Integer)
  On Error GoTo ControlError
  
  KeyAscii = CharacterValidForInteger(KeyAscii)
  
  GoTo ExitProc
ControlError:
  MngError Err, "txLogSize_KeyPress", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub txName_Change()
  On Error Resume Next
  
  Dim Path As String
  Dim File As String
  Dim FileExt As String
  
  File = FileGetNameWithoutExt(txDataFile.Text)
  If File = m_oldDataBaseName Then
    Path = FileGetPath(txDataFile.Text)
    FileExt = FileGetType(txDataFile.Text)
    If FileExt <> "" Then
      FileExt = "." & FileExt
    Else
      FileExt = ".mdf"
    End If
    txDataFile.Text = FileGetValidPath(Path) & txName.Text & FileExt
  End If
  
  File = FileGetNameWithoutExt(txLogFile.Text)
  If File = m_oldDataBaseName Then
    Path = FileGetPath(txLogFile.Text)
    FileExt = FileGetType(txLogFile.Text)
    If FileExt <> "" Then
      FileExt = "." & FileExt
    Else
      FileExt = ".ldf"
    End If
    txLogFile.Text = FileGetValidPath(Path) & txName.Text & FileExt
  End If
  
  m_oldDataBaseName = txName.Text
End Sub

Private Sub cmdCancel_Click()
  On Error GoTo ControlError

  m_Ok = False
  RaiseEvent Cancel

  GoTo ExitProc
ControlError:
  MngError Err, "cmdCancel_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdDataFindFile_Click()
  On Error GoTo ControlError
  
  Dim File As String
  Dim Cancel As Boolean
  
  File = txDataFile.Text
  
  RaiseEvent FindFile(txName.Text, File, "Archivo de datos", Cancel)
  
  If Cancel Then Exit Sub
  
  txDataFile.Text = File
  
  GoTo ExitProc
ControlError:
  MngError Err, "cmdDataFindFile_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdLogFindFile_Click()
  On Error GoTo ControlError

  Dim File As String
  Dim Cancel As Boolean
  
  File = txLogFile.Text
  
  RaiseEvent FindFile(txName.Text, File, "Archivo de log", Cancel)
  
  If Cancel Then Exit Sub
  
  txLogFile.Text = File
  
  GoTo ExitProc
ControlError:
  MngError Err, "cmdLogFindFile_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub ShowData()
  
  SetPosAndSizeOfFrames frDefinition
  SetPosAndSizeOfFrames frDescrip
  SetPosAndSizeOfFrames frProgress
  SetPosAndSizeDescrip lbDescripBack, lbDescrip, frDefinition
  SetPosAndSizeDescrip lbDescripBack2, lbDescrip2, frDescrip
  SetPosAndSizeDescrip lbDescripBack3, lbDescrip3, frProgress
  
  setHeaderlvProgress
  
End Sub

Private Sub setHeaderlvProgress()
  lvProgress.ColumnHeaders.Clear
  lvProgress.ColumnHeaders.Add , , , 500
  lvProgress.ColumnHeaders.Add , , , 5000
  lvProgress.ListItems.Clear
  lvProgress.LabelEdit = lvwManual
  lvProgress.View = lvwReport
  lvProgress.GridLines = False
  lvProgress.FullRowSelect = True
  lvProgress.HideColumnHeaders = True
  Set lvProgress.SmallIcons = liProgress
End Sub

Private Sub SetPosAndSizeOfFrames(ByRef f As PictureBox)
  With f
    .BorderStyle = 0
    .Left = 0
    .Top = 0
    .Width = ScaleWidth
    .Height = Line1.Y1 - 20
  End With
End Sub

Private Sub SetPosAndSizeDescrip(ByRef DescripBack As Label, ByRef Descrip As Label, ByRef f As PictureBox)
  With DescripBack
    .Left = 0
    .Top = 0
    .Height = 1045
    .Width = f.Width
  End With
  With Descrip
    .Left = 180
    .Top = 205
    .Height = 645
    .Width = 6360
  End With
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  ShowData
  
  FormCenter Me
  
  RaiseEvent MoveNext
  
  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  On Error GoTo ControlError

  If UnloadMode <> vbFormCode Then
    Cancel = True
    cmdCancel_Click
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "Form_QueryUnload", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
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


