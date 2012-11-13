VERSION 5.00
Object = "{AE4714A0-35E2-44BC-9460-84B3AD745E81}#2.4#0"; "CSReportPreview.ocx"
Begin VB.Form fPreview 
   Caption         =   "Vista Previa"
   ClientHeight    =   6330
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6315
   Icon            =   "fPreview.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   6330
   ScaleWidth      =   6315
   StartUpPosition =   3  'Windows Default
   Begin CSReportPreview.cReportPreview rptMain 
      Height          =   5295
      Left            =   60
      TabIndex        =   0
      Top             =   60
      Width           =   5895
      _ExtentX        =   10398
      _ExtentY        =   9340
   End
   Begin VB.Image imgCur 
      Height          =   480
      Left            =   120
      Picture         =   "fPreview.frx":09AA
      Top             =   5700
      Width           =   480
   End
End
Attribute VB_Name = "fPreview"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fPreview
' 06-10-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fPreview"

' estructuras
' variables privadas
'Private WithEvents m_RptPrint As CSReportPaint2.cReportPrint
Private WithEvents m_RptPrint As cReportPrint
Attribute m_RptPrint.VB_VarHelpID = -1
Private m_RptManager          As cRptManager
Private m_LnkForeColor        As Long
Private m_LnkFontBold         As Boolean
Private m_LastIndexField      As Long
Private m_EasyLink            As Boolean
' eventos
' propiedades publicas
'Public Property Set RptPrint(ByRef rhs As CSReportPaint2.cReportPrint)
Public Property Set RptPrint(ByRef rhs As cReportPrint)
  Set m_RptPrint = rhs
  If Not m_RptPrint Is Nothing Then
    If Not m_RptPrint.Report Is Nothing Then
      With m_RptPrint.Report
        GetRptManager m_RptManager, .Name, .Path, m_RptPrint.Report, Me
      End With
    End If
  End If
End Property

'Public Property Get RptPrint() As CSReportPaint2.cReportPrint
Public Property Get RptPrint() As cReportPrint
  Set RptPrint = m_RptPrint
End Property

Public Property Let LnkForeColor(ByRef rhs As Long)
  m_LnkForeColor = rhs
End Property

Public Property Get LnkForeColor() As Long
  LnkForeColor = m_LnkForeColor
End Property

Public Property Let LnkFontBold(ByRef rhs As Long)
  m_LnkFontBold = rhs
End Property

Public Property Get LnkFontBold() As Long
  LnkFontBold = m_LnkFontBold
End Property

Public Property Let LastIndexField(ByRef rhs As Long)
  m_LastIndexField = rhs
End Property

Public Property Get LastIndexField() As Long
  LastIndexField = m_LastIndexField
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas

'/////////////////////////////////////////////////////////////////////////////////////////

Private Sub m_RptPrint_ClickOnField(ByVal IndexField As Long)
  On Error GoTo ControlError
  
  If m_RptManager Is Nothing Then Exit Sub
  m_RptManager.ClickOnField Me, IndexField

  GoTo ExitProc
ControlError:
  MngError Err, "m_RptPrint_ClickOnField", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_RptPrint_ClickOnLine(ByVal Id As Long)
  On Error GoTo ControlError
  
  If m_RptManager Is Nothing Then Exit Sub
  m_RptManager.ClickOnLine Me, Id

  GoTo ExitProc
ControlError:
  MngError Err, "m_RptPrint_ClickOnLine", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_RptPrint_DblClickOnField(ByVal IndexField As Long)
  On Error GoTo ControlError
  
  If m_RptManager Is Nothing Then Exit Sub
  m_RptManager.DblClickOnField Me, IndexField
  
  GoTo ExitProc
ControlError:
  MngError Err, "m_RptPrint_DblClickOnField", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_RptPrint_DblClickOnLine(ByVal Id As Long)
  On Error GoTo ControlError
  
  If m_RptManager Is Nothing Then Exit Sub
  m_RptManager.DblClickOnLine Me, Id

  GoTo ExitProc
ControlError:
  MngError Err, "m_RptPrint_DblClickOnLine", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_RptPrint_MouseDownOnField(ByVal IndexField As Long, ByVal Button As Integer, ByVal Shift As Integer, Cancel As Boolean, ByVal x As Single, ByVal y As Single)
  On Error GoTo ControlError
  
  If m_RptManager Is Nothing Then Exit Sub
  m_RptManager.MouseDownOnField Me, IndexField, Button, Shift, Cancel, x, y

  GoTo ExitProc
ControlError:
  MngError Err, "m_RptPrint_MouseDownOnField", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_RptPrint_MouseOnField(ByVal IndexField As Long)
  On Error GoTo ControlError
  
  If m_RptManager Is Nothing Then Exit Sub
  m_RptManager.MouseOnField Me, IndexField
  
  GoTo ExitProc
ControlError:
  MngError Err, "m_RptPrint_MouseOnField", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub m_RptPrint_MouseOutField()
  On Error GoTo ControlError
  
  If m_RptManager Is Nothing Then Exit Sub
  m_RptManager.MouseOutField Me
  
  GoTo ExitProc
ControlError:
  MngError Err, "m_RptPrint_MouseOutField", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub
'/////////////////////////////////////////////////////////////////////////////////////////

Private Sub Form_Resize()
  On Error Resume Next
  rptMain.Move 0, 0, ScaleWidth, ScaleHeight
End Sub

' construccion - destruccion
Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  CSKernelClient2.UnloadForm Me, Me.Name
  
  Set m_RptManager = Nothing
  DestroyRptManager m_RptPrint.Report.Name
  
  With m_RptPrint
    Set .PreviewControl = Nothing
    With .Report.LaunchInfo
      Set .ObjPaint.Report = Nothing
      Set .ObjPaint = Nothing
    End With
  End With
  Set m_RptPrint = Nothing
End Sub

Private Sub Form_Load()
  On Error Resume Next
  CSKernelClient2.LoadForm Me, Me.Name
End Sub

#If PREPROC_DEBUG Then
Private Sub Form_Initialize()
  gdbInitInstance C_Module
End Sub

Private Sub Form_Terminate()
  gdbTerminateInstance C_Module
End Sub
#End If
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
