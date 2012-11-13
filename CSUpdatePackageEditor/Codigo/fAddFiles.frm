VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Begin VB.Form fAddFiles 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Agregar Archivos"
   ClientHeight    =   4065
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7170
   Icon            =   "fAddFiles.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4065
   ScaleWidth      =   7170
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.ComboBox cbTarget 
      Height          =   315
      Left            =   780
      Style           =   2  'Dropdown List
      TabIndex        =   6
      Top             =   960
      Width           =   3135
   End
   Begin CSButton.cButtonLigth cmdCancel 
      Cancel          =   -1  'True
      Height          =   330
      Left            =   5445
      TabIndex        =   4
      Top             =   3600
      Width           =   1410
      _ExtentX        =   2487
      _ExtentY        =   582
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
      ForeColor       =   0
   End
   Begin CSButton.cButtonLigth cmdOk 
      Default         =   -1  'True
      Height          =   330
      Left            =   3870
      TabIndex        =   3
      Top             =   3600
      Width           =   1500
      _ExtentX        =   2646
      _ExtentY        =   582
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
      ForeColor       =   0
   End
   Begin CSButton.cButtonLigth cmdAddFiles 
      Height          =   330
      Left            =   4050
      TabIndex        =   1
      Top             =   945
      Width           =   1590
      _ExtentX        =   2805
      _ExtentY        =   582
      Caption         =   "&Agregar Archivos"
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
   End
   Begin MSComDlg.CommonDialog cdFiles 
      Left            =   6030
      Top             =   855
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.ListBox lsFiles 
      Appearance      =   0  'Flat
      Height          =   1785
      Left            =   90
      TabIndex        =   0
      Top             =   1395
      Width           =   6990
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   225
      Picture         =   "fAddFiles.frx":000C
      Top             =   135
      Width           =   420
   End
   Begin VB.Label Label12 
      BackStyle       =   0  'Transparent
      Caption         =   "Indique las propiedades del paquete"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   855
      TabIndex        =   5
      Top             =   225
      Width           =   5505
   End
   Begin VB.Label lbTarget 
      BackStyle       =   0  'Transparent
      Caption         =   "Destino:"
      Height          =   285
      Left            =   135
      TabIndex        =   2
      Top             =   990
      Width           =   645
   End
   Begin VB.Shape Shape10 
      BackColor       =   &H8000000F&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   2670
      Left            =   0
      Top             =   765
      Width           =   7620
   End
End
Attribute VB_Name = "fAddFiles"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fAddFiles
' 07-05-2006

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "fAddFiles"

' estructuras
' variables privadas
Private m_IdTypeFile    As Long
Private m_Ok            As Boolean
' propiedades publicas
Public Property Let IdTypeFile(ByVal rhs As Long)
  m_IdTypeFile = rhs
End Property
Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property
' funciones publicas
' funciones privadas
Private Sub cmdAddFiles_Click()
  On Error GoTo ControlError

  cdFiles.Filename = ""
  cdFiles.Flags = cdlOFNAllowMultiselect + _
                  cdlOFNFileMustExist + _
                  cdlOFNExplorer
  cdFiles.ShowOpen
  
  If cdFiles.Filename <> vbNullString Then
    Dim vFiles As Variant
    Dim i      As Long
    Dim Path   As String
    
    If InStr(1, cdFiles.Filename, Chr(0)) Then
    
      vFiles = Split(cdFiles.Filename, Chr(0))
      
      Path = GetValidPath(vFiles(0))
      
      For i = 1 To UBound(vFiles)
        lsFiles.AddItem Path & vFiles(i)
      Next
    
    Else
      
      lsFiles.AddItem cdFiles.Filename
    
    End If
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "cmdAddFiles_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdCancel_Click()
  m_Ok = False
  Me.Hide
End Sub

Private Sub cmdOk_Click()
  m_Ok = True
  Me.Hide
End Sub

Private Sub lsFiles_DblClick()
  On Error GoTo ControlError
  
  Dim idFile As Long
  
  If lsFiles.ListIndex = -1 Then Exit Sub
  
  idFile = lsFiles.ItemData(lsFiles.ListIndex)
  
  If idFile = 0 Then idFile = m_IdTypeFile
  
  If CSAEditFile(lsFiles.Text, idFile) Then
    lsFiles.ItemData(lsFiles.ListIndex) = idFile
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  cdFiles.MaxFileSize = 8192

  CenterForm Me
  
  InitCBTarget cbTarget

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
