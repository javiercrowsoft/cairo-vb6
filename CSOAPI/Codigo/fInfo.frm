VERSION 5.00
Object = "{757F6B6F-8057-4D0A-85C2-0A1807E33D34}#1.8#0"; "CSGrid2.ocx"
Begin VB.Form fInfo 
   Caption         =   "Información"
   ClientHeight    =   5100
   ClientLeft      =   165
   ClientTop       =   855
   ClientWidth     =   5430
   Icon            =   "fInfo.frx":0000
   LinkTopic       =   "Form1"
   NegotiateMenus  =   0   'False
   ScaleHeight     =   5100
   ScaleWidth      =   5430
   StartUpPosition =   3  'Windows Default
   Begin CSGrid2.cGrid grdInfo 
      Height          =   4275
      Left            =   0
      TabIndex        =   0
      Top             =   780
      Width           =   5415
      _ExtentX        =   9551
      _ExtentY        =   7541
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
      BorderStyle     =   2
      DisableIcons    =   -1  'True
   End
   Begin VB.Label lbCaption 
      BackStyle       =   0  'Transparent
      Caption         =   "Información"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H8000000E&
      Height          =   420
      Left            =   720
      TabIndex        =   1
      Top             =   180
      Width           =   4110
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   135
      Picture         =   "fInfo.frx":058A
      Top             =   90
      Width           =   480
   End
   Begin VB.Shape shTop 
      BackColor       =   &H80000010&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   660
      Left            =   0
      Top             =   0
      Width           =   8070
   End
   Begin VB.Menu popGrid 
      Caption         =   "&Opciones"
      Begin VB.Menu popGridAutoWidthCol 
         Caption         =   "&Ajustar el Ancho de las Columnas"
      End
      Begin VB.Menu popGridExportToExel 
         Caption         =   "&Exportar a Excel..."
      End
   End
End
Attribute VB_Name = "fInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fInfo
' -12-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fInfo"
' estructuras
' variables privadas
Private m_FormName  As String
Private m_bNotes    As Boolean
Private m_AuxRef    As Object

Private m_ObjectEdit As String
Private m_ObjectABM  As String

' eventos

Public Event grdInfoDblClick(ByVal lRow As Long, ByVal lCol As Long)

' propiedades publicas
Public Property Set AuxRef(ByRef rhs As Object)
  Set m_AuxRef = rhs
End Property

Public Property Let IsNotes(ByVal rhs As Boolean)
  m_bNotes = rhs
End Property

Public Property Let ObjectEdit(ByVal rhs As String)
  m_ObjectEdit = rhs
End Property

Public Property Let ObjectABM(ByVal rhs As String)
  m_ObjectABM = rhs
End Property

Public Property Let FormName(ByVal rhs As String)
  m_FormName = rhs
End Property

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  Set m_AuxRef = Nothing
End Sub

' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub Form_Resize()
  On Error Resume Next
  
  With grdInfo
    .Move .Left, .Top, ScaleWidth - .Left * 2, ScaleHeight - .Top - 50
  End With
  With shTop
    .Move .Left, .Top, ScaleWidth - .Left * 2, .Height
  End With
  With lbCaption
    .Move .Left, .Top, ScaleWidth - .Left - 100, .Height
  End With
End Sub

Private Sub popGridExportToExel_Click()
  On Error Resume Next
  Dim Export As cExporToExcel
  Set Export = New cExporToExcel
  
  Export.ShowDialog = True
  Export.Export dblExGrid, "", grdInfo
End Sub

Private Sub popGridAutoWidthCol_Click()
  On Error Resume Next
  grdInfo.AutoWidthColumns
End Sub

Private Sub grdInfo_ShowPopMenu(Cancel As Boolean)
  On Error Resume Next
  Me.PopupMenu popGrid
  Cancel = True
End Sub

' construccion - destruccion
Private Sub Form_Initialize()
  On Error Resume Next
  m_ObjectEdit = "CSEnvio2.cParteDiario"
  m_ObjectABM = "CSABMInterface2.cABMGeneric"
End Sub
Private Sub Form_Load()
  On Error Resume Next
  CSKernelClient2.LoadForm Me, C_Module & m_FormName
  Me.Caption = m_FormName
  Me.lbCaption.Caption = m_FormName
End Sub
Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  CSKernelClient2.UnloadForm Me, C_Module & m_FormName
End Sub

Private Sub grdInfo_DblClick(ByVal lRow As Long, ByVal lCol As Long)
  On Error GoTo ControlError

  RaiseEvent grdInfoDblClick(lRow, lCol)

  If Not m_bNotes Then Exit Sub

  Dim iEdit As cIEditGeneric
  Dim Parte As Object
  
  Set Parte = CSKernelClient2.CreateObject(m_ObjectEdit)
  
  Set iEdit = Parte
  Set iEdit.ObjABM = CSKernelClient2.CreateObject(m_ObjectABM)
  iEdit.Edit grdInfo.Cell(lRow, 1).ItemData, True

  GoTo ExitProc
ControlError:
  MngError Err, "grdInfo_DblClick", C_Module, ""
  If Err.Number Then Resume ExitProc
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
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

