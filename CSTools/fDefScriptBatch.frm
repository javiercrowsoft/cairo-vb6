VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form fDefScriptBatch 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Editar definicion de script batch"
   ClientHeight    =   6015
   ClientLeft      =   45
   ClientTop       =   360
   ClientWidth     =   7680
   Icon            =   "fDefScriptBatch.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6015
   ScaleWidth      =   7680
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdDown 
      Caption         =   "6"
      BeginProperty Font 
         Name            =   "Marlett"
         Size            =   14.25
         Charset         =   2
         Weight          =   500
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   7065
      TabIndex        =   15
      Top             =   2835
      Width           =   550
   End
   Begin VB.CommandButton cmdUp 
      Caption         =   "5"
      BeginProperty Font 
         Name            =   "Marlett"
         Size            =   14.25
         Charset         =   2
         Weight          =   500
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   6480
      TabIndex        =   14
      Top             =   2835
      Width           =   550
   End
   Begin VB.OptionButton opTask 
      Caption         =   "Task"
      Height          =   195
      Left            =   2970
      TabIndex        =   13
      Top             =   90
      Width           =   780
   End
   Begin VB.OptionButton opScript 
      Caption         =   "Script"
      Height          =   195
      Left            =   2025
      TabIndex        =   12
      Top             =   90
      Width           =   780
   End
   Begin VB.CommandButton cmdEditScript 
      Caption         =   "&Modificar"
      Height          =   330
      Left            =   3015
      TabIndex        =   11
      Top             =   2835
      Width           =   1095
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Aceptar"
      Height          =   330
      Left            =   4590
      TabIndex        =   10
      Top             =   5625
      Width           =   1275
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&Cancelar"
      Height          =   330
      Left            =   6075
      TabIndex        =   9
      Top             =   5625
      Width           =   1275
   End
   Begin VB.CommandButton cmdDeleteScript 
      Caption         =   "&Borrar"
      Height          =   330
      Left            =   1845
      TabIndex        =   5
      Top             =   2835
      Width           =   1095
   End
   Begin VB.CommandButton cmdAddScript 
      Caption         =   "&Agregar"
      Height          =   330
      Left            =   6480
      TabIndex        =   4
      Top             =   2205
      Width           =   1095
   End
   Begin VB.CommandButton cmdFindFile 
      Caption         =   "..."
      Height          =   285
      Left            =   7200
      TabIndex        =   3
      Top             =   360
      Width           =   375
   End
   Begin VB.TextBox txDescrip 
      Height          =   1050
      Left            =   135
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   2
      Top             =   1035
      Width           =   7440
   End
   Begin VB.TextBox txFile 
      Height          =   285
      Left            =   135
      TabIndex        =   1
      Top             =   360
      Width           =   6945
   End
   Begin MSComctlLib.ListView lvScripts 
      Height          =   2175
      Left            =   45
      TabIndex        =   0
      Top             =   3195
      Width           =   7575
      _ExtentX        =   13361
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
   Begin MSComDlg.CommonDialog cd 
      Left            =   1935
      Top             =   5535
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   7650
      Y1              =   2670
      Y2              =   2670
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   7650
      Y1              =   2655
      Y2              =   2655
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   7650
      Y1              =   5490
      Y2              =   5490
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   7650
      Y1              =   5505
      Y2              =   5505
   End
   Begin VB.Label Label3 
      Caption         =   "Descripción:"
      Height          =   240
      Left            =   135
      TabIndex        =   8
      Top             =   765
      Width           =   1410
   End
   Begin VB.Label Label2 
      Caption         =   "Archivo:"
      Height          =   240
      Left            =   135
      TabIndex        =   7
      Top             =   90
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "Scripts:"
      Height          =   240
      Left            =   135
      TabIndex        =   6
      Top             =   2880
      Width           =   1410
   End
End
Attribute VB_Name = "fDefScriptBatch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fDefScriptBatch
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
Private Const C_Module = "fDefScriptBatch"

Private Const c_descrip = 2
Private Const c_ScrType = 1
Private Const c_script = "Script"
' estructuras
' variables privadas
Private m_Ok            As Boolean
' eventos
Public Event FindFile(ByRef File As String, ByRef Cancel As Boolean)
' propiedadades publicas
Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
Public Sub AddScript(ByVal File As String, ByVal Descrip As String, ByVal ScrType As csScrType, Optional ByVal Index As Integer = 0)
  Dim si As ListItem
  Dim sType As String
  
  If Index <> 0 Then
    Set si = lvScripts.ListItems.Add(Index, , File)
  Else
    Set si = lvScripts.ListItems.Add(, , File)
  End If
  If ScrType = csScrTypeScript Then
    sType = c_script
  Else
    sType = c_task
  End If
  si.ListSubItems.Add , , sType
  si.ListSubItems.Add , , Descrip
End Sub
' funciones friend
' funciones privadas
Private Sub cmdAddScript_Click()
  On Error GoTo ControlError
  
  If Trim(txFile.Text) = "" Then
    info "Debe indicar un archivo"
    Exit Sub
  End If
  
  Dim ScrType As csScrType
  
  If opScript.Value Then
    ScrType = csScrTypeScript
  Else
    ScrType = csScrTypeTask
  End If
  
  AddScript txFile.Text, txDescrip.Text, ScrType

  GoTo ExitProc
ControlError:
  MngError Err, "cmdAddScript_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub SetColumnslvScripts()
  lvScripts.ColumnHeaders.Add , , "Archivos", 3500
  lvScripts.ColumnHeaders.Add , , "Tipo", 800
  lvScripts.ColumnHeaders.Add , , "Descripciones", 3500
  lvScripts.LabelEdit = lvwManual
  lvScripts.View = lvwReport
  lvScripts.GridLines = True
  lvScripts.FullRowSelect = True
  lvScripts.HideSelection = False
End Sub

Private Sub cmdCancel_Click()
  On Error GoTo ControlError

  m_Ok = False
  Me.Hide

  GoTo ExitProc
ControlError:
  MngError Err, "cmdCancel_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdDeleteScript_Click()
  On Error GoTo ControlError
  
  If lvScripts.SelectedItem Is Nothing Then Exit Sub
  
  lvScripts.ListItems.Remove lvScripts.SelectedItem.Index
  
  GoTo ExitProc
ControlError:
  MngError Err, "cmdDeleteScript_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdEditScript_Click()
  On Error GoTo ControlError
  
  Dim sType As String
  
  If lvScripts.SelectedItem Is Nothing Then Exit Sub
  
  If opScript.Value Then
    sType = c_script
  Else
    sType = c_task
  End If
  
  lvScripts.SelectedItem.Text = txFile.Text
  lvScripts.SelectedItem.ListSubItems.Remove 2
  lvScripts.SelectedItem.ListSubItems.Remove 1
  lvScripts.SelectedItem.ListSubItems.Add , , sType
  lvScripts.SelectedItem.ListSubItems.Add , , txDescrip.Text
  
  GoTo ExitProc
ControlError:
  MngError Err, "cmdEditScript_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdOk_Click()
  On Error GoTo ControlError
  
  m_Ok = True
  Me.Hide

  GoTo ExitProc
ControlError:
  MngError Err, "cmdOk_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdFindFile_Click()
  On Error GoTo ControlError
  
  Dim File As String
  Dim Cancel As Boolean
  
  File = txFile.Text
  
  RaiseEvent FindFile(File, Cancel)
  
  If Cancel Then Exit Sub
  
  txFile.Text = File
  
  GoTo ExitProc
ControlError:
  MngError Err, "cmdFindFile_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdUp_Click()
  On Error GoTo ControlError
  
  If lvScripts.SelectedItem Is Nothing Then Exit Sub
  
  If lvScripts.ListItems.Count < 2 Then Exit Sub
  
  If lvScripts.SelectedItem.Index = 1 Then Exit Sub
  
  MoveScript -1
  
  GoTo ExitProc
ControlError:
  MngError Err, "cmdUp_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub MoveScript(ByVal Direction As Integer)
  Dim ScrType As csScrType
  Dim Descrip As String
  Dim File    As String
  Dim Index   As Integer
  
  File = lvScripts.SelectedItem.Text
  Descrip = lvScripts.SelectedItem.SubItems(c_descrip)
  If lvScripts.SelectedItem.SubItems(c_ScrType) = c_script Then
    ScrType = csScrTypeScript
  Else
    ScrType = csScrTypeTask
  End If
  
  Index = lvScripts.SelectedItem.Index
  lvScripts.ListItems.Remove Index
  
  Index = Index + Direction
  
  AddScript File, Descrip, ScrType, Index
End Sub

Private Sub cmdDown_Click()
  On Error GoTo ControlError
  
  If lvScripts.SelectedItem Is Nothing Then Exit Sub
  
  If lvScripts.ListItems.Count < 2 Then Exit Sub
  
  If lvScripts.SelectedItem.Index = lvScripts.ListItems.Count Then Exit Sub
  
  MoveScript 1
  
  GoTo ExitProc
ControlError:
  MngError Err, "cmdDown_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub lvScripts_Click()
  On Error GoTo ControlError
  
  If lvScripts.SelectedItem Is Nothing Then Exit Sub
  
  txFile.Text = lvScripts.SelectedItem.Text
  txDescrip.Text = lvScripts.SelectedItem.SubItems(c_descrip)
  If lvScripts.SelectedItem.SubItems(c_ScrType) = c_task Then
    opTask.Value = True
  Else
    opScript.Value = True
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "lvScripts_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  SetColumnslvScripts
  opScript.Value = True
  FormCenter Me
  
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
