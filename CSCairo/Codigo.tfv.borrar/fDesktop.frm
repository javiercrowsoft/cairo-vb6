VERSION 5.00
Object = "{AE4714A0-35E2-44BC-9460-84B3AD745E81}#2.4#0"; "CSReportPreview.ocx"
Begin VB.Form fDesktop 
   Caption         =   "Escritorio"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   ControlBox      =   0   'False
   Icon            =   "fDesktop.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   Picture         =   "fDesktop.frx":058A
   ScaleHeight     =   3195
   ScaleWidth      =   4680
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
      Picture         =   "fDesktop.frx":0894
      Top             =   2700
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
Private WithEvents m_RptEvent As CSInforme2.cReporte
Attribute m_RptEvent.VB_VarHelpID = -1
Private WithEvents m_Menu     As cPopupMenu
Attribute m_Menu.VB_VarHelpID = -1

Private m_CurrentPage         As Long

Private m_rpt                 As cReport
Private m_InReportWindow      As Boolean
Private m_InProcessWindow     As Boolean
Private m_bMoving             As Single
Private m_IndexField          As Long

Private m_LastIndexField      As Long ' Para iluminar y apagar iconos

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
Private Property Get ObjEdit(ByVal sysm_id As Long) As cIEditGeneric
  On Error GoTo ControlError
  
  Set ObjEdit = GetObjectEdit(sysm_id)
  Exit Property
ControlError:
  MngError Err, "ObjEdit", C_Module, ""
End Property

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
  
  Dim csrFile As String
  If bIsReports Then
    csrFile = "Reportes.csr"
  Else
    csrFile = "Procesos.csr"
  End If
  
  rpt.LoadSilent GetValidPath( _
                      IniGetEx(c_DESKTOP_KEY, _
                               c_DESKTOP_PathInicio_RPT, _
                               App.Path) _
                             ) & csrFile
  
  rpt.Connect.StrConnect = OAPI.Database.StrConnect
  'rpt.Connect.StrConnect = OAPI.Database.LastStrConnectUsed
  
  rpt.Connect.Parameters.Item(1).Value = User.Id
  
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
  
  fMain.RefreshTabs
  
  GoTo ExitProc
ControlError:
  MngError Err, "ShowReportes", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' funciones friend
' funciones privadas
Private Sub Form_Resize()
  On Error Resume Next
  
  Me.WindowState = vbMaximized
  
  If m_InReportWindow Or m_InProcessWindow Then
  
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
    
    If m_Menu Is Nothing Then Exit Sub
    
    m_IndexField = IndexField
    m_Menu.ShowPopupMenu x + 1100, y + 200
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
  If fMain.WindowState = vbMinimized Then Exit Sub
  
  If LastHeight <> Me.ScaleHeight Or LastWidth <> Me.ScaleWidth Then
  
    LastHeight = Me.ScaleHeight
    LastWidth = Me.ScaleWidth
    
    If Not m_rpt.LoadSilent(GetValidPath(m_rpt.Path) & m_rpt.Name) Then Exit Sub
    
    m_rpt.Connect.StrConnect = OAPI.Database.StrConnect
    'm_rpt.Connect.StrConnect = OAPI.Database.LastStrConnectUsed

    m_rpt.Connect.Parameters.Item(1).Value = User.Id
    
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
  
  tmRefreshReport.Enabled = False
End Sub

Private Sub m_RptPrint_ClickOnField(ByVal IndexField As Long)
  On Error GoTo ControlError
  
  Dim RptField As cReportPageField
  
  Set RptField = m_RptPrint.GetField(IndexField)
  
  If RptField Is Nothing Then Exit Sub
  
  Select Case RptField.Info.Name
    Case "ctlCALC"
      CSKernelClient2.ExecuteCalc
    Case "ctlCHAT"
      fMain.ShowChatClient
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
    Case "ctlSEARCHDOCS"
      pSearchDocs
    Case "ctlREPORTS"
      pShowReportes
    Case "ctlPROCESS"
      pShowProcess
    Case "ctlADDREPORT"
      pAddReport
    Case "ctlRPT1", "ctlRPTICON1"
      pShowParams IndexField, 1
    Case "ctlPRE1", "ctlPREICON1"
      pProcessCommand IndexField, 1
    Case "ctlRPT2", "ctlRPTICON2"
      pShowParams IndexField, 2
    Case "ctlPRE2", "ctlPREICON2"
      pProcessCommand IndexField, 2
    Case "ctlPreviousPage"
      m_RptPrint.PrintPage C_PreviousPage
      m_CurrentPage = m_RptPrint.CurrPage
    Case "ctlNextPage"
      m_RptPrint.PrintPage C_NextPage
      m_CurrentPage = m_RptPrint.CurrPage
    Case "ctlHELP"
      On Error Resume Next
#If PREPROC_QBPOINT Then

      CSKernelClient2.EditFile CSKernelClient2.GetValidPath(App.Path) & "qbonix.chm", Me.hWnd
      
#Else

      CSKernelClient2.EditFile CSKernelClient2.GetValidPath(App.Path) & "cairo.chm", Me.hWnd

#End If

    Case "ctlCONFIG"
      pEditPreferences
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

Private Sub pInfoRpt()
  Dim oRpt As Object
  Set oRpt = CSKernelClient2.CreateObject("CSInforme2.cReporte")
  
  oRpt.ShowInfo pGetRptId, _
                GetRptPath, _
                GetRptCommandTimeOut, _
                GetRptConnectionTimeOut
End Sub

Private Sub pEditRpt()
  Dim oRpt As cIEditGeneric
  Set oRpt = CSKernelClient2.CreateObject("CSInforme2.cReporte")
  
  oRpt.Edit pGetRptId

  Set m_RptEvent = oRpt
End Sub

Private Sub pDeleteRpt()
  Dim oRpt As cIEditGeneric
  Set oRpt = CSKernelClient2.CreateObject("CSInforme2.cReporte")
  
  oRpt.Delete pGetRptId
  ShowReportes m_InReportWindow
  pRefreshWindow
End Sub

Private Sub pCopyRpt()
  Dim oRpt As Object
  Set oRpt = CSKernelClient2.CreateObject("CSInforme2.cReporte")
  
  oRpt.CopyRptToUsers pGetRptId

  Set m_RptEvent = oRpt
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
                        
  Dim oRpt As Object
  Set oRpt = CSKernelClient2.CreateObject("CSInforme2.cReporte")
  
  Dim rpt_id As Long
  Dim Fields As cReportPageFields
  Set Fields = m_RptPrint.GetLine(IndexField)
  
  If RptIcon = 1 Then
    rpt_id = pGetFieldFromName("ctlRPTID1", Fields).Value
  Else
    rpt_id = pGetFieldFromName("ctlRPTID2", Fields).Value
  End If
  
  oRpt.Id = rpt_id
  oRpt.Path = GetRptPath()
  oRpt.CommandTimeout = GetRptCommandTimeOut
  oRpt.ConnectionTimeout = GetRptConnectionTimeOut
  oRpt.ShowParams
End Sub

Private Sub pShowProcess()
  On Error GoTo ControlError
  
  If fProcesos Is Nothing Then
    Set fProcesos = New fDesktop
  End If
  
  fProcesos.ShowReportes False
  
  GoTo ExitProc
ControlError:
  MngError Err, "fProcesos", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pShowReportes()
  On Error GoTo ControlError
  
  If fReportes Is Nothing Then
    Set fReportes = New fDesktop
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

Private Sub pProcessCommand(ByVal IndexField As Long, _
                            ByVal RptIcon As Long)
                        
  Dim sysm_id As Long
  Dim Fields  As cReportPageFields
  Dim bList   As Boolean
  
  Set Fields = m_RptPrint.GetLine(IndexField)
  
  If RptIcon = 1 Then
    bList = InStr(1, LCase$(pGetFieldFromName("ctlPRE1", Fields).Value), "listar")
    sysm_id = pGetFieldFromName("ctlSYSM_ID1", Fields).Value
  Else
    bList = InStr(1, LCase$(pGetFieldFromName("ctlPRE2", Fields).Value), "listar")
    sysm_id = pGetFieldFromName("ctlSYSM_ID2", Fields).Value
  End If
  
  If bList Then
  
    pList sysm_id
  
  Else
  
    ObjEdit(sysm_id).Edit 0
  
  End If
End Sub

Private Sub pList(ByVal sysm_id As Long)
  fMain.MenuClickBySysmId sysm_id
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

Private Sub pAddReport()
  On Error GoTo ControlError
  
  Dim ObjWizard As cIWizardGeneric
  Set ObjWizard = CSKernelClient2.CreateObject("CSABMInterface2.cWizardGeneric")
  Dim oWiz As cWizardGeneric
  Set oWiz = ObjWizard
  Set m_RptEvent = CreateObject("CSInforme2.cReporte")
  m_RptEvent.IsProcess = m_InProcessWindow
  Set oWiz.ObjClient = m_RptEvent
  ObjWizard.Show "CSInforme2.cReporte"

  GoTo ExitProc
ControlError:
  MngError Err, "pAddReport", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

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

Private Sub Form_Activate()
  ActiveBar Me
End Sub

Private Sub Form_Deactivate()
  DeactiveBar Me
End Sub

' Menu
Private Sub m_Menu_Click(ItemNumber As Long)
  On Error GoTo ControlError
  
  Select Case m_Menu.ItemKey(ItemNumber)
    Case "popRptDelete"
      pDeleteRpt
    Case "popRptEdit"
      pEditRpt
    Case "popRptInfo"
      pInfoRpt
    Case "popRptCopyToUser"
      pCopyRpt
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "m_Menu_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pCreateMenu()
  Dim iPTop   As Long
  Dim iP      As Long
  Dim iP2     As Long
  Dim iP3     As Long
  
  If m_Menu Is Nothing Then
    Set m_Menu = New cPopupMenu
  End If
  
  m_Menu.Clear

  ' Creating a Menu:
  With m_Menu
    ' Initial set up:
    .hWndOwner = Me.hWnd
    .OfficeXpStyle = True
    
    ' File menu:
    iP = .AddItem("&Borrar", , , iPTop, , , , "popRptDelete")
  
    ' File menu:
    iP = .AddItem("&Editar", , , iPTop, , , , "popRptEdit")
    
    ' Separator:
    iP = .AddItem("-", , , iPTop)
    
    ' File menu:
    iP = .AddItem("&Info", , , iPTop, , , , "popRptInfo")
    
    ' Separator:
    iP = .AddItem("-", , , iPTop)
    
    ' File menu:
    iP = .AddItem("&Copiar este reporte en otro usuario", , , iPTop, , , , "popRptCopyToUser")
    
  End With
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

'------------------------------------------------------------------
' Edicion
'
Private Function GetObjectEdit(ByVal sysm_id As Long) As cIEditGeneric
  Dim ObjAbm As String
  
  ObjAbm = pGetObjectABM(sysm_id)
  
  If ObjAbm = "" Then Exit Function
  
  Dim o As cIEditGeneric

  Set o = CSKernelClient2.CreateObject(ObjAbm)
  Set o.ObjTree = Nothing
  
  Dim Editor As cIABMGeneric
  Set Editor = CSKernelClient2.CreateObject(c_ObjABMName)
  Set o.ObjAbm = Editor

  pSetGenericDoc o

  Set GetObjectEdit = o
End Function

Private Sub pSetGenericDoc(ByRef o As Object)
  Dim oDoc As cIEditGenericDoc
  If TypeOf o Is cIEditGenericDoc Then
    Set oDoc = o
    Set oDoc.Footer = CSKernelClient2.CreateObject(c_ObjABMName)
    Set oDoc.Items = CSKernelClient2.CreateObject(c_ObjABMName)
  End If
End Sub

Private Function pGetObjectABM(ByVal sysm_id As Long) As String
  Dim ObjectABM As String
  
  Const csTSysModulo = "sysModulo"
  Const cscSysmId = "sysm_id"
  Const cscSysmObjetoEdicion = "sysm_objetoedicion"
  
  If OAPI.Database.GetData(csTSysModulo, _
                           cscSysmId, _
                           sysm_id, _
                           cscSysmObjetoEdicion, _
                           ObjectABM) Then
    pGetObjectABM = ObjectABM
  End If
End Function

'------------------------------------------------------------------

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  Me.WindowState = vbMaximized
  Me.rptMain.OnlyShowPage = True

  m_CurrentPage = 0

  If m_InReportWindow Or m_InProcessWindow Then
    pCreateMenu
    Exit Sub
  End If

  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load

  Dim rpt As cReport
  Set rpt = New cReport
  
  If Not rpt.Init(New cReportLaunchInfo) Then Exit Sub
  
  Set m_RptPrint = New CSReportTPaint.cReportPrint
  Set m_RptPrint.PreviewControl = Me.rptMain
  Set rpt.LaunchInfo.ObjPaint = m_RptPrint
  
  Dim RptInicio As String
  
  If m_UserCfg.Desktop <> "" Then
    RptInicio = m_UserCfg.Desktop
  Else
    
#If PREPROC_QBPOINT Then
    
    RptInicio = GetValidPath( _
                        IniGetEx(c_DESKTOP_KEY, _
                                 c_DESKTOP_PathInicio_RPT, _
                                 App.Path) _
                                ) & "qbinicio.csr"
    
#Else

    RptInicio = GetValidPath( _
                        IniGetEx(c_DESKTOP_KEY, _
                                 c_DESKTOP_PathInicio_RPT, _
                                 App.Path) _
                                ) & "inicio.csr"
#End If

  End If
  
  If Not rpt.LoadSilent(RptInicio) Then Exit Sub
  
  Set m_rpt = rpt

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
    Set fReportes = Nothing
  
  ElseIf fProcesos Is Me Then
    Set fProcesos = Nothing
  
  Else
    Set fDesktop = Nothing
  End If
  
  Set m_RptPrint.PreviewControl = Nothing
  Set m_rpt.LaunchInfo.ObjPaint.Report = Nothing
  Set m_rpt.LaunchInfo.ObjPaint = Nothing
  Set m_RptPrint = Nothing
  Set m_RptEvent = Nothing
  Set m_rpt = Nothing
  Set m_Menu = Nothing
  
  ' Preferencias del Usuario
  '
  Set m_UserCfg = Nothing
  
  DeactiveBar Me
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
