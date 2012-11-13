VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form fDocDigital 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Documento Digitalizado"
   ClientHeight    =   4890
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6945
   Icon            =   "fDocDigital.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4890
   ScaleWidth      =   6945
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkZip 
      Appearance      =   0  'Flat
      Caption         =   "Comprimir el Archivo"
      ForeColor       =   &H80000008&
      Height          =   240
      Left            =   3420
      TabIndex        =   25
      Top             =   1575
      Value           =   1  'Checked
      Width           =   2760
   End
   Begin MSComDlg.CommonDialog commDlg 
      Left            =   6240
      Top             =   3780
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.TextBox txModificado 
      BackColor       =   &H8000000F&
      BorderStyle     =   0  'None
      Height          =   285
      Left            =   1395
      TabIndex        =   21
      Top             =   3795
      Width           =   1815
   End
   Begin VB.TextBox txFormato 
      BackColor       =   &H8000000F&
      BorderStyle     =   0  'None
      Height          =   285
      Left            =   5715
      TabIndex        =   19
      Top             =   3375
      Width           =   975
   End
   Begin VB.TextBox txFile 
      BackColor       =   &H8000000F&
      BorderStyle     =   0  'None
      Height          =   285
      Left            =   1395
      TabIndex        =   17
      Top             =   3375
      Width           =   3375
   End
   Begin CSButton.cButtonLigth cmdBrowse 
      Height          =   330
      Left            =   6465
      TabIndex        =   16
      Top             =   2940
      Width           =   275
      _ExtentX        =   476
      _ExtentY        =   582
      Caption         =   "..."
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
   Begin VB.TextBox txPath 
      BorderStyle     =   0  'None
      Height          =   300
      Left            =   1395
      TabIndex        =   14
      Top             =   2955
      Width           =   5055
   End
   Begin VB.TextBox txDescrip 
      BorderStyle     =   0  'None
      Height          =   900
      Left            =   1395
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   12
      Top             =   1935
      Width           =   5310
   End
   Begin VB.TextBox txCodigo 
      BorderStyle     =   0  'None
      Height          =   300
      Left            =   1395
      TabIndex        =   10
      Top             =   1515
      Width           =   1830
   End
   Begin VB.TextBox txClientTable 
      BackColor       =   &H8000000F&
      BorderStyle     =   0  'None
      Enabled         =   0   'False
      Height          =   285
      Left            =   1395
      TabIndex        =   8
      Top             =   675
      Width           =   3015
   End
   Begin VB.TextBox txNombre 
      BorderStyle     =   0  'None
      Height          =   300
      Left            =   1395
      TabIndex        =   7
      Top             =   1095
      Width           =   5310
   End
   Begin VB.TextBox txClientTableId 
      Alignment       =   1  'Right Justify
      BackColor       =   &H8000000F&
      BorderStyle     =   0  'None
      Enabled         =   0   'False
      Height          =   285
      Left            =   5940
      TabIndex        =   4
      Top             =   660
      Width           =   735
   End
   Begin CSButton.cButton cmdSave 
      Height          =   330
      Left            =   1800
      TabIndex        =   2
      Top             =   4440
      Width           =   1320
      _ExtentX        =   2328
      _ExtentY        =   582
      Caption         =   "&Guardar"
      Style           =   3
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
   Begin CSButton.cButton cmdClose 
      Height          =   330
      Left            =   5640
      TabIndex        =   3
      Top             =   4440
      Width           =   1095
      _ExtentX        =   1931
      _ExtentY        =   582
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
   Begin CSButton.cButton cmdCancel 
      Height          =   330
      Left            =   3255
      TabIndex        =   23
      Top             =   4440
      Width           =   2085
      _ExtentX        =   3678
      _ExtentY        =   582
      Caption         =   "&Descartar cambios"
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
   Begin CSButton.cButton cmdUpdate 
      Height          =   330
      Left            =   3360
      TabIndex        =   24
      Top             =   3780
      Width           =   2340
      _ExtentX        =   4128
      _ExtentY        =   582
      Caption         =   "&Actualizar el archivo"
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
   Begin VB.Label Label9 
      Caption         =   "Modificado:"
      Height          =   315
      Left            =   360
      TabIndex        =   22
      Top             =   3780
      Width           =   915
   End
   Begin VB.Shape Shape9 
      BorderColor     =   &H80000010&
      Height          =   330
      Left            =   1380
      Top             =   3780
      Width           =   1860
   End
   Begin VB.Label Label8 
      Caption         =   "Formato:"
      Height          =   315
      Left            =   4920
      TabIndex        =   20
      Top             =   3360
      Width           =   615
   End
   Begin VB.Shape Shape8 
      BorderColor     =   &H80000010&
      Height          =   330
      Left            =   5700
      Top             =   3360
      Width           =   1020
   End
   Begin VB.Label Label7 
      Caption         =   "Archivo:"
      Height          =   315
      Left            =   360
      TabIndex        =   18
      Top             =   3360
      Width           =   675
   End
   Begin VB.Shape Shape7 
      BorderColor     =   &H80000010&
      Height          =   330
      Left            =   1380
      Top             =   3360
      Width           =   3420
   End
   Begin VB.Label Label6 
      Caption         =   "Ubicación:"
      Height          =   315
      Left            =   360
      TabIndex        =   15
      Top             =   2940
      Width           =   855
   End
   Begin VB.Shape Shape6 
      BorderColor     =   &H80000010&
      Height          =   330
      Left            =   1380
      Top             =   2940
      Width           =   5360
   End
   Begin VB.Shape Shape4 
      BorderColor     =   &H80000010&
      Height          =   330
      Left            =   1380
      Top             =   1500
      Width           =   1860
   End
   Begin VB.Label Label5 
      Caption         =   "Descripción:"
      Height          =   315
      Left            =   360
      TabIndex        =   13
      Top             =   1920
      Width           =   975
   End
   Begin VB.Shape Shape5 
      BorderColor     =   &H80000010&
      Height          =   930
      Left            =   1380
      Top             =   1920
      Width           =   5340
   End
   Begin VB.Label Label4 
      Caption         =   "Codigo:"
      Height          =   315
      Left            =   360
      TabIndex        =   11
      Top             =   1500
      Width           =   675
   End
   Begin VB.Label Label3 
      Caption         =   "Nombre:"
      Height          =   315
      Left            =   360
      TabIndex        =   9
      Top             =   1080
      Width           =   675
   End
   Begin VB.Shape Shape3 
      BorderColor     =   &H80000010&
      Height          =   330
      Left            =   1380
      Top             =   1080
      Width           =   5340
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H80000010&
      Height          =   330
      Left            =   1380
      Top             =   660
      Width           =   3060
   End
   Begin VB.Shape Shape2 
      BorderColor     =   &H80000010&
      Height          =   330
      Left            =   5920
      Top             =   640
      Width           =   780
   End
   Begin VB.Label Label2 
      Caption         =   "ID:"
      Height          =   315
      Left            =   5340
      TabIndex        =   6
      Top             =   660
      Width           =   555
   End
   Begin VB.Label Label1 
      Caption         =   "Tabla:"
      Height          =   315
      Left            =   360
      TabIndex        =   5
      Top             =   660
      Width           =   555
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   60
      X2              =   6850
      Y1              =   4320
      Y2              =   4320
   End
   Begin VB.Line Line2 
      BorderColor     =   &H8000000E&
      X1              =   60
      X2              =   6850
      Y1              =   4335
      Y2              =   4335
   End
   Begin VB.Label lbTitle 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Documento Digitalizado"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   14.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      Left            =   765
      TabIndex        =   1
      Top             =   45
      Width           =   3000
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   135
      Picture         =   "fDocDigital.frx":08CA
      Top             =   0
      Width           =   480
   End
   Begin VB.Label lbTitleEx2 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   14.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      Left            =   3690
      TabIndex        =   0
      Top             =   45
      Width           =   75
   End
   Begin VB.Shape shTitle 
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   510
      Left            =   0
      Top             =   0
      Width           =   6975
   End
End
Attribute VB_Name = "fDocDigital"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fDocDigital
' 17-10-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fDocDigital"
' estructuras
' variables privadas
Private m_FileChanged                   As Boolean
Private m_OldPath                       As String
Private m_ID                            As Long
Private m_Initdone                      As Boolean
' eventos
Public Event Save()
Public Event ReLoad()
' propiedades publicas
Public Property Get FileChanged() As Boolean
   FileChanged = m_FileChanged
End Property

Public Property Let FileChanged(ByVal rhs As Boolean)
   m_FileChanged = rhs
End Property

Public Property Get ID() As Long
   ID = m_ID
End Property

Public Property Let ID(ByVal rhs As Long)
   m_ID = rhs
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Init()
  m_OldPath = txPath.Text
  m_Initdone = True
  m_FileChanged = False
End Function

Private Sub cmdUpdate_Click()
  m_FileChanged = True
  MsgInfo "Haga click en el bóton guardar para actualizar el archivo", "Documento digital"
End Sub

' funciones friend
' funciones privadas
Private Sub txPath_Change()
  On Error Resume Next
  If Not m_Initdone Then Exit Sub
  If m_OldPath <> txPath.Text Then
    m_OldPath = txPath.Text
    m_FileChanged = True
    
    Dim File As String
    Dim FileEx    As cFileEx
    
    Set FileEx = New cFileEx
    File = txPath.Text
    txPath.Text = FileEx.FileGetPath(File)
    txFile.Text = FileEx.FileGetName(File)
  End If
End Sub

Private Sub cmdBrowse_Click()
  On Error GoTo ControlError

  Dim File As cFile
  Set File = New cFile
  
  File.Init "cmdBrowse_Click", C_Module, Me.commDlg
  
  File.Filter = "Todos los archivos|*.*|Imagenes|*.ico;*.bmp;*.jpg;*.gif|Word|*.doc|Excel|*.xls|Zips|*.zip;*.rar"
  If Not File.FOpen("", csRead, False, False, csShared, True, True) Then Exit Sub

  m_OldPath = File.GetPath(File.FullName)
  txPath.Text = m_OldPath
  txFile.Text = File.GetFileNameSinExt(File.FullName)
  txFormato.Text = File.GetFileExt(File.FullName)
  
  If txNombre.Text = "" Then txNombre.Text = txFile.Text

  m_FileChanged = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cmdBrowse_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdCancel_Click()
  On Error Resume Next
  m_Initdone = False
  RaiseEvent ReLoad
End Sub

Private Sub cmdClose_Click()
  On Error Resume Next
  Me.Hide
End Sub

Private Sub cmdSave_Click()
  On Error Resume Next
  RaiseEvent Save
End Sub
' construccion - destruccion
Private Sub Form_Load()
  On Error Resume Next
  CenterForm Me
  m_Initdone = False
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
