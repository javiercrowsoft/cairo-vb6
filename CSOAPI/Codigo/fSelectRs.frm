VERSION 5.00
Object = "{757F6B6F-8057-4D0A-85C2-0A1807E33D34}#1.8#0"; "CSGrid2.ocx"
Begin VB.Form fSelectRs 
   BackColor       =   &H00FFFFFF&
   Caption         =   "Seleccion"
   ClientHeight    =   5745
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   5415
   Icon            =   "fSelectRs.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5745
   ScaleWidth      =   5415
   StartUpPosition =   3  'Windows Default
   Begin CSGrid2.cGrid grdGrid 
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
   Begin VB.Image Image1 
      Height          =   480
      Left            =   135
      Picture         =   "fSelectRs.frx":08CA
      Top             =   90
      Width           =   480
   End
   Begin VB.Label lbCaption 
      BackStyle       =   0  'Transparent
      Caption         =   "Seleccionar"
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
   Begin VB.Shape shTop 
      BackColor       =   &H80000010&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   660
      Left            =   0
      Top             =   0
      Width           =   8070
   End
End
Attribute VB_Name = "fSelectRs"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fSelectRs
' 05-03-2008

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fSelectRs"
' estructuras
' variables privadas
Private m_FormName  As String
Private m_OK         As Boolean

' eventos

' propiedades publicas
Public Property Get Ok() As Boolean
  Ok = m_OK
End Property

Public Property Let FormName(ByVal rhs As String)
  m_FormName = rhs
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub Form_Resize()
  On Error Resume Next
  
  With grdGrid
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
  Export.Export dblExGrid, "", grdGrid
End Sub

Private Sub popGridAutoWidthCol_Click()
  On Error Resume Next
  grdGrid.AutoWidthColumns
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error Resume Next
  CSKernelClient2.LoadForm Me, C_Module & m_FormName
  Me.Caption = m_FormName
  Me.lbCaption.Caption = m_FormName
  grdGrid.RowMode = True
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  CSKernelClient2.UnloadForm Me, C_Module & m_FormName
End Sub

Private Sub grdGrid_DblClick(ByVal lRow As Long, ByVal lCol As Long)
  On Error GoTo ControlError

  If grdGrid.SelectedRow > 0 Then
  
    Me.Hide
    m_OK = True
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "grdGrid_DblClick", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub grdGrid_KeyPress(KeyAscii As Integer)
  If grdGrid.SelectedRow > 0 Then
    If KeyAscii = vbKeyReturn Then
      KeyAscii = 0
      grdGrid_DblClick grdGrid.SelectedRow, grdGrid.SelectedCol
    End If
  End If
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
