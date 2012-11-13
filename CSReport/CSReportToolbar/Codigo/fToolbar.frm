VERSION 5.00
Object = "{AE4714A0-35E2-44BC-9460-84B3AD745E81}#2.4#0"; "CSReportPreview.ocx"
Begin VB.Form fDesktop 
   Caption         =   "Escritorio"
   ClientHeight    =   6525
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8610
   Icon            =   "fToolbar.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   6525
   ScaleWidth      =   8610
   Begin VB.CommandButton cmdLoad 
      Caption         =   "Load"
      Height          =   315
      Left            =   7320
      TabIndex        =   2
      Top             =   180
      Width           =   1095
   End
   Begin VB.TextBox txFile 
      Height          =   315
      Left            =   960
      TabIndex        =   0
      Text            =   "D:\proyectos\CSCairo\Escritorio\Toolbar.csd"
      Top             =   180
      Width           =   6255
   End
   Begin VB.Timer tmRefreshReport 
      Enabled         =   0   'False
      Interval        =   300
      Left            =   6420
      Top             =   720
   End
   Begin CSReportPreview.cReportPreview rptMain 
      Height          =   3195
      Left            =   120
      TabIndex        =   3
      Top             =   720
      Width           =   4695
      _ExtentX        =   8281
      _ExtentY        =   5636
   End
   Begin VB.Label Label1 
      Caption         =   "File"
      Height          =   315
      Left            =   120
      TabIndex        =   1
      Top             =   180
      Width           =   675
   End
   Begin VB.Image imgCur 
      Height          =   480
      Left            =   5880
      Picture         =   "fToolbar.frx":000C
      Top             =   660
      Visible         =   0   'False
      Width           =   480
   End
End
Attribute VB_Name = "fDesktop"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fDesktop
' 02-10-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fDesktop"

Private Const c_ObjABMName = "CSABMInterface2.cABMGeneric"

' estructuras
' variables privadas
Private WithEvents m_RptPrint As CSReportTPaint.cReportPrint
Attribute m_RptPrint.VB_VarHelpID = -1

Private m_CurrentPage         As Long

Private m_rpt                 As cReport
Private m_InReportWindow      As Boolean
Private m_InProcessWindow     As Boolean
Private m_bMoving             As Single
Private m_IndexField          As Long

Private m_LastIndexField      As Long ' Para iluminar y apagar iconos

Private m_bLoadClicked        As Boolean

' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas

' funciones publicas
Private Sub cmdLoad_Click()
  On Error GoTo ControlError
  
  Dim rpt As cReport
  Set rpt = New cReport
  
  If Not rpt.Init(New cReportLaunchInfo) Then Exit Sub
  
  Set m_RptPrint = New CSReportTPaint.cReportPrint
  Set m_RptPrint.PreviewControl = Me.rptMain
  Set rpt.LaunchInfo.ObjPaint = m_RptPrint
  
  Dim RptInicio As String
  
  RptInicio = txFile.Text
  
  If LenB(RptInicio) Then
  
    If Not rpt.LoadSilent(RptInicio) Then Exit Sub
  
  End If
  
  Set m_rpt = rpt

  m_bLoadClicked = True
  pRefreshReport

  GoTo ExitProc
ControlError:
  MngError Err, "cmdLoad_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' funciones friend
' funciones privadas
Private Sub Form_Resize()
  On Error Resume Next
    
  If m_InReportWindow Or m_InProcessWindow Then
  
    rptMain.Move -1000, 900, Me.ScaleWidth + 1000, Me.ScaleHeight - 900
  
  Else
    
    rptMain.Move 0, 900, Me.ScaleWidth, Me.ScaleHeight - 900
  
  End If
  
  pRefreshReport
End Sub

Private Sub pRefreshReport()
  tmRefreshReport.Enabled = True
  m_bMoving = Timer
End Sub

#If PREPROC_DEBUG Then
Private Sub Form_Initialize()
  gdbInitInstance C_Module
End Sub

Private Sub Form_Terminate()
  gdbTerminateInstance C_Module
End Sub
#End If

Private Sub m_RptPrint_MouseDownOnField(ByVal IndexField As Long, ByVal Button As Integer, ByVal Shift As Integer, Cancel As Boolean, ByVal x As Single, ByVal y As Single)
  On Error GoTo ControlError

  If Button = vbRightButton Then
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "m_RptPrint_MouseDownOnField", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub tmRefreshReport_Timer()
  On Error Resume Next
  Static LastHeight As Long
  Static LastWidth  As Long
  
  If Timer - m_bMoving < 0.3 Then Exit Sub
  
  If Me.WindowState = vbMinimized Then Exit Sub
  
  If LastHeight <> Me.ScaleHeight _
  Or LastWidth <> Me.ScaleWidth _
  Or m_bLoadClicked Then
  
    m_bLoadClicked = False
  
    LastHeight = Me.ScaleHeight
    LastWidth = Me.ScaleWidth
    
    If Not m_rpt.LoadSilent(GetValidPath(m_rpt.Path) & m_rpt.Name) Then Exit Sub
        
    m_rpt.LaunchInfo.InternalPreview = True
    With m_rpt.LaunchInfo.Printer.PaperInfo
      .PaperSize = vbPRPSUser
      .CustomHeight = Me.ScaleHeight
      .CustomWidth = Me.ScaleWidth
    End With
    
    m_rpt.Launch
    pShowCurrPage
    rptMain.Refresh
    
    pShowFrBack
    
  End If
  
  tmRefreshReport.Enabled = False
End Sub

Private Sub m_RptPrint_ClickOnField(ByVal IndexField As Long)
  On Error GoTo ControlError
  
  Dim RptField As cReportPageField
  
  Set RptField = m_RptPrint.GetField(IndexField)
  
  If RptField Is Nothing Then Exit Sub
  
  Debug.Print RptField.Info.Name
  
  Select Case RptField.Info.Name
    Case "ctlCALC"
      CSKernelClient2.ExecuteCalc
    Case Else
      pProcessTag m_RptPrint.GetField(IndexField).Info.Tag
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "m_RptPrint_ClickOnField", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pEditRpt()
  Dim oRpt As cIEditGeneric
  Set oRpt = CSKernelClient2.CreateObject("CSInforme2.cReporte")
  
  oRpt.Edit pGetRptId

End Sub

Private Sub pRefreshWindow()
  m_rpt.Launch
  pShowCurrPage
  rptMain.Refresh
  pShowFrBack
End Sub

Private Function pGetRptId() As Long
  Dim RptIcon As Long
  
  Dim RptField As cReportPageField
  
  Set RptField = m_RptPrint.GetField(m_IndexField)
  
  If RptField Is Nothing Then Exit Function
  
  Select Case RptField.Info.Name
    Case "ctlRPT1", "ctlRPTICON1"
      RptIcon = 1
    Case "ctlRPT2", "ctlRPTICON2"
      RptIcon = 2
  End Select
  
  Dim rpt_id As Long
  Dim Fields As cReportPageFields
  Set Fields = m_RptPrint.GetLine(m_IndexField)
  
  If RptIcon = 1 Then
    rpt_id = pGetFieldFromName("ctlRPTID1", Fields).Value
  Else
    rpt_id = pGetFieldFromName("ctlRPTID2", Fields).Value
  End If
  
  pGetRptId = rpt_id
End Function

Private Sub m_RptPrint_MouseOnField(ByVal IndexField As Long)
  On Error Resume Next
  rptMain.MousePointer = vbCustom
  Set rptMain.MouseIcon = imgCur.Picture
  pShowReportDescrip IndexField
  pHiglightIcon IndexField
End Sub

Private Sub pShowReportDescrip(ByVal IndexField As Long)
  
  If Not (m_InReportWindow Or m_InProcessWindow) Then
    Exit Sub
  End If
  
  Dim Fields As cReportPageFields
  Set Fields = m_RptPrint.GetLine(IndexField)
  
  Dim Fld As cReportPageField
  Dim Descrip As String
  
  Set Fld = m_RptPrint.GetField(IndexField)
  
  If Not Fld Is Nothing Then
    Select Case Fld.Info.Name
      Case "ctlRPT1"
        Descrip = pGetFieldFromName("ctlDESCRIP1", Fields).Value
      Case "ctlRPT2"
        Descrip = pGetFieldFromName("ctlDESCRIP2", Fields).Value
    End Select
  End If
  
  pSetReportDescrip Descrip
End Sub

Private Sub pHiglightIcon(ByVal IndexField As Long)
  
  Const c_Color = "CLR"
  
  pShadowIcon

  Dim Fields As cReportPageFields
  Set Fields = m_RptPrint.GetLine(IndexField)
  
  Dim Fld         As cReportPageField
  Dim ctlName     As String
  Dim ctlNameCLR  As String
  Dim i           As Long
  
  Set Fld = m_RptPrint.GetField(IndexField)
  
  ctlName = Fld.Info.Name
  ctlNameCLR = ctlName & c_Color
  
  With m_RptPrint
    
    For Each Fld In .GetLine(IndexField)
      If Fld.Info.Name = ctlNameCLR Then
                
        i = .GetPaintObjByCtrlNameEx( _
                            "frBack", _
                            IndexField).IndexField
        
        .RefreshCtrl i
                
        m_LastIndexField = IndexField
                
        IndexField = .GetPaintObjByCtrlNameEx( _
                            ctlNameCLR & "mini", _
                            IndexField).IndexField
        
        i = -1
        
        On Error Resume Next
        
        Err.Clear
        
        While IndexField And Err.Number = 0
        
          .RefreshCtrl IndexField
          
          i = i + 1
          IndexField = .GetPaintObjByCtrlNameEx( _
                              ctlNameCLR & i, _
                              IndexField).IndexField
        
        Wend
        
        IndexField = .GetPaintObjByCtrlNameEx( _
                            ctlNameCLR, _
                            IndexField).IndexField

        .RefreshCtrl IndexField
        
        Exit For
      End If
    Next
  End With
End Sub

Private Sub pShadowIcon()
  
  With m_RptPrint
    
    If m_LastIndexField Then
    
      .RefreshCtrl m_LastIndexField
    
    End If
    
  End With
  
End Sub

Private Sub pShowFrBack()
  Dim i As Long
  
  DoEvents

  With m_RptPrint
    
    i = .GetPaintObjByCtrlNameEx( _
                        "frBack", _
                        1).IndexField
    
    .RefreshCtrl i
  End With
End Sub

Private Sub pProcessTag(ByVal Tag As String)
  Const c_tag_link As String = "@link:" ' OJO: cambiar la constante
  Const c_len_tag_link As Long = 6      ' _len_ si cambian el nombre de la macro
  
  Dim link As String
  
  If LCase$(Left$(Tag, c_len_tag_link)) = c_tag_link Then
    link = Mid$(Tag, c_len_tag_link + 1)
    CSKernelClient2.EditFile link, Me.hWnd
  End If
End Sub

Private Sub pSetReportDescrip(ByVal Descrip As String)
'  Dim Fld As cReportPageField
'
'  Static OldDescrip As String
'
'  If OldDescrip = Descrip Then Exit Sub
'
'  OldDescrip = Descrip
'
'  Set Fld = m_RptPrint.GetCtrlFooter("ctlDESCRIP")
'  If Fld Is Nothing Then Exit Sub
'
'  Fld.Value = Descrip
'  m_RptPrint.RefreshCtrlFooter "ctlDESCRIP"
End Sub

Private Function pGetFieldFromName(ByVal Name As String, ByRef Fields As cReportPageFields) As cReportPageField
  Dim Fld As cReportPageField
  
  For Each Fld In Fields
    If Fld.Info.Name = Name Then
      Set pGetFieldFromName = Fld
      Exit Function
    End If
  Next
End Function

Private Sub pSearchDocs()
  DocumentSearch csEDT_FacturaVenta, Nothing, False
End Sub

Private Sub m_RptPrint_MouseOutField()
  On Error Resume Next
  rptMain.MousePointer = vbDefault
  Set rptMain.MouseIcon = Nothing
  pSetReportDescrip ""
  pShadowIcon
End Sub

Private Sub pShowCurrPage()
  On Error Resume Next
  If m_CurrentPage <> 0 Then
    m_RptPrint.PrintPage m_CurrentPage
  End If
End Sub

Private Sub pEditPreferences()
  Dim AbmObj As cIMenuClient
  Set AbmObj = CSKernelClient2.CreateObject("CSGeneralEx2.cUsuarioConfig")
  AbmObj.ProcessMenu 0
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  Me.rptMain.OnlyShowPage = True

  m_CurrentPage = 0

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  
  Set m_RptPrint.PreviewControl = Nothing
  Set m_rpt.LaunchInfo.ObjPaint.Report = Nothing
  Set m_rpt.LaunchInfo.ObjPaint = Nothing
  Set m_RptPrint = Nothing
  Set m_rpt = Nothing
    
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

