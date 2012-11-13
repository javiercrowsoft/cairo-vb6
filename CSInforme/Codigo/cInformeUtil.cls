VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cInformeUtil"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private Const C_Module = "cInformeUtil"

Private m_Path                    As String
Private WithEvents m_fProgress    As fProgress
Attribute m_fProgress.VB_VarHelpID = -1
Private m_Cancel                  As Boolean
Private m_warning                 As String

Public Sub ValidateInformeParametroCSRs()
  On Error GoTo ControlError
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_informeGetValidate"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then
    MsgInfo LNGGetText(2740, vbNullString)  'No hay Informes definidos en Cairo
    Exit Sub
  End If
  
  Dim msg As String
  
  Dim inf_id          As Long
  Dim inf_codigo      As String
  Dim inf_nombre      As String
  Dim inf_param_count As Long

  rs.MoveLast
  rs.MoveFirst

  m_Cancel = False
  m_warning = vbNullString

  ShowProgressDlg rs.RecordCount

  While Not rs.EOF
  
    inf_id = gDB.ValField(rs.Fields, cscInfId)
    inf_codigo = gDB.ValField(rs.Fields, cscInfCodigo)
    inf_nombre = gDB.ValField(rs.Fields, cscInfNombre)
    inf_param_count = gDB.ValField(rs.Fields, "inf_param_count")
    
    pValidateInformeParametroCSR inf_id, inf_codigo, inf_nombre, inf_param_count, msg
    
    pUpdateProgress rs.AbsolutePosition, rs.RecordCount, inf_codigo
    
    If m_Cancel Then
      If Ask(LNGGetText(2741, vbNullString), vbNo) Then
             'Confirma que desea cancelar la ejecución del Proceso
        CloseProgressDlg
        Exit Sub
      Else
        m_Cancel = False
      End If
    End If
    
    rs.MoveNext
  Wend

  CloseProgressDlg

  If LenB(m_warning) Then
    msg = msg & vbCrLf & vbCrLf & LNGGetText(2849, vbNullString) & vbCrLf & m_warning
                                  'Errores:
  End If

  If LenB(msg) > 0 Then
    CSKernelClient2.GetInputEx msg, LNGGetText(2742, vbNullString)
                                    'Informes cuya definición con coincide con el CSR
  End If

  Exit Sub
ControlError:
  MngError Err, "ShowInfo", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  CloseProgressDlg
End Sub

Private Sub pUpdateProgress(ByVal current As Long, _
                            ByVal total As Long, _
                            ByVal inf_codigo As String)
  
  If m_fProgress Is Nothing Then Exit Sub

  m_fProgress.lbCurrRecord.Caption = current
  m_fProgress.lbTask.Caption = inf_codigo

  Dim Percent As Double
  If total > 0 And current > 0 Then
    Percent = current / total
    On Error Resume Next
    m_fProgress.prgVar.Value = Percent * 100
  End If
  
  DoEvents

End Sub

Private Sub pValidateInformeParametroCSR(ByVal inf_id As Long, _
                                         ByVal inf_codigo As String, _
                                         ByVal inf_nombre As String, _
                                         ByVal inf_param_count As Long, _
                                         ByRef msg As String)
                         
  Dim Rpt         As cReport
  
  Dim Mouse As cMouse
  Set Mouse = New cMouse
  
  Mouse.MouseSet vbArrowHourglass
  
  Set Rpt = New cReport
  
  If Not Rpt.Init(New cReportLaunchInfo) Then GoTo ExitProc
  
  Dim Informe As cInforme
  Set Informe = New cInforme
  
  If Not Informe.Load(inf_id) Then
    pMsgWarning LNGGetText(2947, vbNullString, inf_nombre)
                'No se pudo cargar el informe;; & inf_nombre .
    GoTo ExitProc
  End If
  
  Dim rptFile As String
  rptFile = GetValidPath(m_Path) & Informe.Reporte
  
  Dim FileEx As CSKernelFile.cFileEx
  Set FileEx = New CSKernelFile.cFileEx
  
  If Not FileEx.FileExists(rptFile) Then
    pMsgWarning rptFile & LNGGetText(2948, vbNullString) ' no existe.
    GoTo ExitProc
  End If
  
  If Not Rpt.LoadSilent(rptFile) Then
    pMsgWarning LNGGetText(2946, vbNullString, rptFile, CSKernelClient2.LastErrorDescription)
      'No se pudo cargar el reporte  & rptFile & ;( & CSKernelClient2.LastErrorDescription & )
    GoTo ExitProc
  End If
  
  Dim rptParamCount As Integer
  
  rptParamCount = Rpt.Connect.Parameters.Count - 1
  If rptParamCount <> inf_param_count Then
    msg = LNGGetText(2945, vbNullString, inf_codigo, rptParamCount, inf_param_count)
    'msg & _
          inf_codigo & _
           - Reporte:  & rptParamCount & _
           - Informe:  & inf_param_count & vbCrLf
    
    GoTo ExitProc
  End If
  
ExitProc:
End Sub

Private Sub m_fProgress_Cancel()
  m_Cancel = True
End Sub

Private Sub CloseProgressDlg()
  On Error Resume Next
  Unload m_fProgress
  Set m_fProgress = Nothing
End Sub

Private Sub ShowProgressDlg(ByVal total As Long)
  
  m_Cancel = False
  If m_fProgress Is Nothing Then Set m_fProgress = New fProgress
  
  m_fProgress.lbTask.Caption = vbNullString
  
  m_fProgress.Label3.Caption = vbNullString
  
  m_fProgress.lbCurrPage.ZOrder
  m_fProgress.lbCurrPage.Alignment = 0
  m_fProgress.lbCurrPage.BackStyle = 0
  m_fProgress.lbCurrPage.Top = 1000
  m_fProgress.lbCurrPage.Height = 800
  m_fProgress.lbCurrPage.Left = 100
  m_fProgress.lbCurrPage.Width = m_fProgress.ScaleWidth - m_fProgress.lbCurrPage.Left
  
  m_fProgress.Label1.Caption = LNGGetText(2743, vbNullString) 'Total:
  m_fProgress.lbRecordCount.Caption = total
  m_fProgress.Show
  m_fProgress.ZOrder
End Sub

Private Function pGetRptPath() As String
  pGetRptPath = GetValidPath(IniGetEx(c_RPT_KEY, c_RPT_PathReportes, App.Path))
End Function

Private Sub Class_Initialize()
  m_Path = pGetRptPath()
End Sub

Private Sub pMsgWarning(ByVal msg As String)
  m_warning = m_warning & msg & vbCrLf
  If m_fProgress Is Nothing Then Exit Sub
  m_fProgress.lbCurrPage.Caption = msg
End Sub
