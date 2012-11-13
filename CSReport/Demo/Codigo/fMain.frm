VERSION 5.00
Object = "{AE4714A0-35E2-44BC-9460-84B3AD745E81}#2.4#0"; "CSReportPreview.ocx"
Begin VB.Form fMain 
   Caption         =   "CSReportDemo"
   ClientHeight    =   8610
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   11355
   Icon            =   "fMain.frx":0000
   LinkTopic       =   "Form1"
   Picture         =   "fMain.frx":038A
   ScaleHeight     =   8610
   ScaleWidth      =   11355
   Begin CSReportPreview.cReportPreview rptMain 
      Height          =   3195
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   4695
      _ExtentX        =   8281
      _ExtentY        =   5636
   End
   Begin VB.Timer tmRefreshReport 
      Enabled         =   0   'False
      Interval        =   300
      Left            =   1740
      Top             =   1380
   End
   Begin VB.Image imgCur 
      Height          =   480
      Left            =   180
      Picture         =   "fMain.frx":0694
      Top             =   2700
      Width           =   480
   End
End
Attribute VB_Name = "fMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fMain
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
Private Const C_Module = "fMain"

Private Const c_ObjABMName = "CSABMInterface2.cABMGeneric"
Private Const c_demo_report_file = "demo.csr"
Private Const c_reports_report_file = "reports.csr"

' estructuras
' variables privadas

Private WithEvents m_Report       As CSReportTDll.cReport
Attribute m_Report.VB_VarHelpID = -1
Private WithEvents m_fProgress    As fProgress
Attribute m_fProgress.VB_VarHelpID = -1
Private m_CancelPrinting          As Boolean

Private WithEvents m_RptPrint As CSReportTPaint.cReportPrint
Attribute m_RptPrint.VB_VarHelpID = -1
Private m_CurrentPage         As Long

Private m_rpt                 As cReport
Private m_InReportWindow      As Boolean
Private m_InProcessWindow     As Boolean
Private m_bMoving             As Single
Private m_IndexField          As Long

Private m_LastIndexField      As Long ' Para iluminar y apagar iconos

Private m_bUnloaded           As Boolean
Private m_bRefreshing         As Boolean
Private m_bShowReports        As Boolean
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Sub ShowReportes(ByVal bIsReports As Boolean)
  On Error GoTo ControlError
  
  Dim rpt As cReport
  Set rpt = New cReport
  
  If Not rpt.Init(New cReportLaunchInfo) Then Exit Sub
  
  If m_RptPrint Is Nothing Then

    Set m_RptPrint = New CSReportTPaint.cReportPrint
    Set m_RptPrint.PreviewControl = Me.rptMain
  End If
  
  Set rpt.LaunchInfo.ObjPaint = m_RptPrint
  
  rpt.LoadSilent App.path & "\" & c_reports_report_file
  
  rpt.LaunchInfo.InternalPreview = True
  With rpt.LaunchInfo.Printer.PaperInfo
    .PaperSize = vbPRPSUser
    .CustomHeight = fMain.ScaleHeight
    .CustomWidth = fMain.ScaleWidth
  End With
  
  If bIsReports Then
    m_InReportWindow = True
    Me.Caption = "Centro de Reportes"
  Else
    m_InProcessWindow = True
    Me.Caption = "Consola de Procesos"
  End If
  
  Set m_rpt = rpt
  
  Me.Show
  Me.ZOrder
  
  GoTo ExitProc
ControlError:
  MngError Err, "ShowReportes", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If m_bRefreshing Then
    MsgBox "No es posible descargar el formulario en este momento. Intente cerrar la ventana nuevamente."
    
    Cancel = m_bRefreshing
  End If
End Sub

' funciones friend
' funciones privadas
Private Sub Form_Resize()
  On Error Resume Next
  
  If m_InReportWindow Then
    rptMain.Move -1000, 0, Me.ScaleWidth + 1000, Me.ScaleHeight
  Else
    rptMain.Move 0, 0, Me.ScaleWidth, Me.ScaleHeight
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

Private Sub m_RptEvent_RefreshDesktop()
  ShowReportes m_InReportWindow
  pRefreshWindow
End Sub

Private Sub m_RptPrint_MouseDownOnField(ByVal IndexField As Long, ByVal Button As Integer, ByVal Shift As Integer, Cancel As Boolean, ByVal x As Single, ByVal y As Single)
  On Error GoTo ControlError

  If Button = vbRightButton Then
    Cancel = True
    
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
  
  If Not m_bUnloaded And Me.Visible Then
  
    m_bRefreshing = True
  
    If Timer - m_bMoving < 0.3 Then Exit Sub
    
    If Me.WindowState = vbMinimized Then
      GoTo ExitProc
    End If
    
    If fMain.WindowState = vbMinimized Then
      GoTo ExitProc
    End If
    
    If LastHeight <> Me.ScaleHeight Or LastWidth <> Me.ScaleWidth Then
    
      LastHeight = Me.ScaleHeight
      LastWidth = Me.ScaleWidth
      
      If Not m_rpt.LoadSilent(GetValidPath(m_rpt.path) & m_rpt.Name) Then
        GoTo ExitProc
      End If
      
      m_rpt.Connect.StrConnect = pGetConnect(m_rpt.Connect.StrConnect)
      m_rpt.LaunchInfo.InternalPreview = True
      With m_rpt.LaunchInfo.Printer.PaperInfo
        .PaperSize = vbPRPSUser
        .CustomHeight = Me.ScaleHeight
        .CustomWidth = Me.ScaleWidth
      End With
      
      m_rpt.Launch
      pShowCurrPage
      rptMain.Refresh
    End If
    
    If m_bShowReports And Not m_InReportWindow Then
      m_bShowReports = False
      pShowReportes
    End If
  End If
  
ExitProc:
  tmRefreshReport.Enabled = False
  m_bRefreshing = False
End Sub

Private Sub m_RptPrint_ClickOnField(ByVal IndexField As Long)
  On Error GoTo ControlError
  
  Dim RptField As cReportPageField
  
  Set RptField = m_RptPrint.GetField(IndexField)
  
  If RptField Is Nothing Then Exit Sub
  
  Select Case RptField.Info.Name
    Case "ctlCALC"
      CSKernelClient2.ExecuteCalc
    Case "ctlWORD"
      CSKernelClient2.StartWord
    Case "ctlEXCEL"
      CSKernelClient2.StartExcel
    Case "ctlIEXPLORER"
      CSKernelClient2.StartIExplorer
    Case "ctlEXPLORER"
      CSKernelClient2.ExecuteExplorer
    Case "ctlDESKTOP"
      CSKernelClient2.ShowDesktop
    Case "ctlREPORTS"
      pShowReportes
    Case "ctlRPT1", "ctlRPTICON1"
      pShowParams IndexField, 1
    Case "ctlRPT2", "ctlRPTICON2"
      pShowParams IndexField, 2
    Case "ctlPreviousPage"
      m_RptPrint.PrintPage C_PreviousPage
      m_CurrentPage = m_RptPrint.CurrPage
    Case "ctlNextPage"
      m_RptPrint.PrintPage C_NextPage
      m_CurrentPage = m_RptPrint.CurrPage
    Case "ctlCONFIG"
      Dim path As String
      path = GetValidPath(App.path)
      Shell path & "CSReportEditor.exe " & path & "demo.csr", vbNormalFocus
    Case "ctlHELP"
      On Error Resume Next
      CSKernelClient2.EditFile CSKernelClient2.GetValidPath(App.path) & "CSReport.chm", Me.hWnd
    Case Else
      Dim Tag As String
      Tag = m_RptPrint.GetField(IndexField).Info.Tag
      If Tag <> vbNullString Then
        pProcessTag Tag
      Else
        MsgBox "Has hecho click en el bóton " & m_RptPrint.GetField(IndexField).Info.Name
      End If
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "m_RptPrint_ClickOnField", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pRefreshWindow()
  m_rpt.Launch
  pShowCurrPage
  rptMain.Refresh
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

Private Sub pShowParams(ByVal IndexField As Long, _
                        ByVal RptIcon As Long)
                        
  Dim rpt_id As Long
  Dim Fields As cReportPageFields
  Set Fields = m_RptPrint.GetLine(IndexField)
  
  If RptIcon = 1 Then
    rpt_id = pGetFieldFromName("ctlRPTID1", Fields).Value
  Else
    rpt_id = pGetFieldFromName("ctlRPTID2", Fields).Value
  End If
  
  pLaunchReport rpt_id
End Sub

Private Sub pShowReportes()
  On Error GoTo ControlError
  
  If fReportes Is Nothing Then
    Set fReportes = New fMain
  End If
  
  fReportes.ShowReportes True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pShowReportes", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

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
  
  Set Fld = m_RptPrint.GetField(IndexField)
  
  ctlName = Fld.Info.Name
  ctlNameCLR = ctlName & c_Color
  
  With m_RptPrint
    For Each Fld In .GetLine(IndexField)
      If Fld.Info.Name = ctlNameCLR Then
        
        .RefreshCtrl .GetPaintObjByCtrlNameEx( _
                            ctlNameCLR, _
                            IndexField).IndexField
                            
        m_LastIndexField = IndexField
        Exit For
      End If
    Next
  End With
End Sub

Private Sub pShadowIcon()
  If m_LastIndexField = 0 Then Exit Sub
  m_RptPrint.RefreshCtrl m_LastIndexField
  m_LastIndexField = 0
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
  Dim Fld As cReportPageField
  
  Static OldDescrip As String
  
  If OldDescrip = Descrip Then Exit Sub
  
  OldDescrip = Descrip
  
  Set Fld = m_RptPrint.GetCtrlFooter("ctlDESCRIP")
  If Fld Is Nothing Then Exit Sub
  
  Fld.Value = Descrip
  m_RptPrint.RefreshCtrlFooter "ctlDESCRIP"
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

'------------------------------------------------------------------

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  Me.rptMain.OnlyShowPage = True

  m_CurrentPage = 0

  If m_InReportWindow Or m_InProcessWindow Then
    If pFirstRun() Then
      SaveSetting c_APP_Name, "CONFIG", "FIRST_RUN", 0
      Me.Width = 10500
      Me.Height = 6000
      Me.Top = fMain.Top + 1500
      Me.Left = fMain.Left + 1500
    Else
      CSKernelClient2.LoadForm Me, "csreport_report"
    End If
    Exit Sub
  End If

  m_bShowReports = True

  Dim rpt As cReport
  Set rpt = New cReport
  
  If Not rpt.Init(New cReportLaunchInfo) Then Exit Sub
  
  Set m_RptPrint = New CSReportTPaint.cReportPrint
  Set m_RptPrint.PreviewControl = Me.rptMain
  Set rpt.LaunchInfo.ObjPaint = m_RptPrint
  
  Dim RptInicio As String
  
  RptInicio = GetValidPath(App.path) & c_demo_report_file
  
  If Not rpt.LoadSilent(RptInicio) Then Exit Sub
  
  Set m_rpt = rpt

  CSKernelClient2.LoadForm Me, "csreportdemo"

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  
  If fReportes Is Me Then
    CSKernelClient2.UnloadForm Me, "csreport_report"
    Set fReportes = Nothing
  Else
    CSKernelClient2.UnloadForm Me, "csreportdemo"
    Set CSKernelClient2.OForms = Forms
    CSKernelClient2.FreeResource
    Set fMain = Nothing
  End If
  
  Set m_RptPrint.PreviewControl = Nothing
  Set m_rpt.LaunchInfo.ObjPaint.Report = Nothing
  Set m_rpt.LaunchInfo.ObjPaint = Nothing
  Set m_RptPrint = Nothing
  Set m_rpt = Nothing
  
  m_bUnloaded = True
  
End Sub

Private Function pFirstRun() As Boolean
  pFirstRun = Val(GetSetting(c_APP_Name, "CONFIG", "FIRST_RUN", 1))
End Function

Private Sub pLaunchReport(ByVal rpt_id As Long)
  Select Case rpt_id
    Case 22
      pLaunchReportAux "DC_CSC_VEN_0020.csr"
    Case 84
      pLaunchReportAux "DC_CSC_VEN_0035.csr"
    Case 86
      pLaunchReportAux "DC_CSC_VEN_0200.csr"
    Case Else
      MsgBox "Por cuestiones de espacio y de tiempo, el reporte con id " & rpt_id & " no se ha incluido en esta demo, si desea que se incluya, envienos un mail a info@crowSoft.com.ar y con gusto lo haremos.", vbInformation
  End Select
End Sub

Private Sub pLaunchReportAux(ByVal report_csr As String)
  On Error GoTo ControlError
  
  Dim rpt As cReport
  Set rpt = New cReport
  
  If Not rpt.Init(New cReportLaunchInfo) Then Exit Sub
  
  Set rpt.LaunchInfo.ObjPaint = New CSReportTPaint.cReportPrint
  
  rpt.LoadSilent App.path & "\" & report_csr
  
  Dim StrConnect As String
  StrConnect = pGetConnect(rpt.Connect.StrConnect)
  rpt.Connect.StrConnect = StrConnect
  If rpt.ConnectsAux.Count Then
    rpt.ConnectsAux.Item(1).StrConnect = StrConnect
    rpt.ConnectsAux.Item(2).StrConnect = StrConnect
  End If
  rpt.LaunchInfo.InternalPreview = False
  
  Set m_Report = rpt
  
  ShowProgressDlg

  rpt.Launch
  
  GoTo ExitProc
ControlError:
  MngError Err, "pLaunchReportAux", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Set m_Report = Nothing
  CloseProgressDlg
End Sub


Private Sub m_Report_Progress(ByVal Task As String, ByVal Page As Long, ByVal CurrRecord As Long, ByVal RecordCount As Long, ByRef Cancel As Boolean)

  DoEvents

  If m_CancelPrinting Then
    If Ask("Confirma que desea cancelar la ejecución del reporte", vbNo) Then
      Cancel = True
      CloseProgressDlg
      Exit Sub
    Else
      m_CancelPrinting = False
    End If
  End If

  If m_fProgress Is Nothing Then Exit Sub

  If Page > 0 Then m_fProgress.lbCurrPage.Caption = Page
  If Task <> vbNullString Then m_fProgress.lbTask.Caption = Task
  If CurrRecord > 0 Then m_fProgress.lbCurrRecord.Caption = CurrRecord
  If RecordCount > 0 And Val(m_fProgress.lbRecordCount.Caption) <> RecordCount Then m_fProgress.lbRecordCount.Caption = RecordCount

  Dim Percent As Double
  If RecordCount > 0 And CurrRecord > 0 Then
    Percent = CurrRecord / RecordCount
    On Error Resume Next
    m_fProgress.prgVar.Value = Percent * 100
  End If
End Sub

Private Sub CloseProgressDlg()
  On Error Resume Next
  Unload m_fProgress
  Set m_fProgress = Nothing
End Sub

Private Sub ShowProgressDlg()
  m_CancelPrinting = False
  If m_fProgress Is Nothing Then Set m_fProgress = New fProgress
  m_fProgress.Show
  m_fProgress.ZOrder
End Sub

Private Sub m_fProgress_Cancel()
  m_CancelPrinting = True
End Sub

Private Function pGetConnect(ByVal StrConnect As String) As String

  pGetConnect = Replace(StrConnect, _
                       "D:\Proyectos\CSReport\Demo\DataBaseDemo\demo.mdb", _
                       App.path & "\demo.mdb")
End Function

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
