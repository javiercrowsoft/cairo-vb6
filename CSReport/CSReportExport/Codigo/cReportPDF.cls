VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportPDF"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cReportPDF
' 14-07-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cReportPDF"

' estructuras
' variables privadas
Private m_FileName                      As String
Private m_Report                        As cReport
'Private m_StartTime                     As Date
'Private m_noStart                       As Boolean
'Private m_bError                        As Boolean
'Private m_bDone                         As Boolean
Private m_RptPrint                      As Object
Private m_CancelExport                  As Boolean
Private m_OutputFile                    As String

Private m_ExportEmailAddress As String

Private WithEvents m_fProgress          As fProgress
Attribute m_fProgress.VB_VarHelpID = -1
'Private WithEvents m_PDFCreator         As PDFCreator.clsPDFCreator
Private WithEvents m_fPDFExport         As fPDFExport
Attribute m_fPDFExport.VB_VarHelpID = -1

' eventos
' propiedades publicas
Public Property Get ExportEmailAddress() As String
  ExportEmailAddress = m_ExportEmailAddress
End Property

Public Property Let ExportEmailAddress(ByRef rhs As String)
  m_ExportEmailAddress = rhs
End Property

Public Property Get FileName() As String
   FileName = m_FileName
End Property

Public Property Let FileName(ByVal rhs As String)
   m_FileName = rhs
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Export(ByRef Report As cReport, _
                       ByRef RptPrint As Object) As Boolean
  Export = pExportAux(Report, RptPrint, False, True, vbNullString)
End Function

Public Function ExportEx(ByRef Report As cReport, _
                         ByRef RptPrint As Object, _
                         ByRef OutputFile As String, _
                         ByVal bShowPDFWindow As Boolean) As Boolean
  ExportEx = pExportAux(Report, RptPrint, False, bShowPDFWindow, OutputFile)
End Function

Public Function ExportToEmail(ByRef Report As cReport, _
                              ByRef RptPrint As Object) As Boolean
  ExportToEmail = pExportAux(Report, RptPrint, True, False, vbNullString)
End Function

Private Function pExportAux(ByRef Report As cReport, _
                            ByRef RptPrint As Object, _
                            ByVal bSendByEmail As Boolean, _
                            ByVal bShowPDFWindow As Boolean, _
                            ByRef OutputFile As String) As Boolean
                       
  If pPrinterIndex("novaPDF Pro v5") = -1 Then
    MsgWarning "Para exportar a PDF debe estar instalada la impresora [novaPDF Pro v5]."
    Exit Function
  End If
                       
  Set m_fProgress = New fProgress
  
  Set m_Report = Report
  Set m_RptPrint = RptPrint
  
  m_fProgress.lbPages.Caption = Report.Pages.Count
  m_fProgress.lbTask.Caption = "Exportando a Acrobat PDF"
  m_fProgress.Caption = "Exportando a Acrobat PDF"
  m_fProgress.InitAcrobat
  
  m_OutputFile = vbNullString
  
  m_fProgress.Show vbModal
  
  If m_fProgress.Ok Then
  
    If ExistsFile(m_OutputFile) Then
    
      OutputFile = m_OutputFile

      If bSendByEmail Then
    
        SendMail m_OutputFile
        
      Else
      
        If bShowPDFWindow Then
          Dim Mouse As cMouse
          Set Mouse = New cMouse
          Mouse.MouseDefault
        
          Set m_fPDFExport = New fPDFExport
          Load m_fPDFExport
          m_fPDFExport.OutputFile = m_OutputFile
          m_fPDFExport.lbFile.Caption = m_OutputFile
          m_fPDFExport.Show vbModal
        End If
        
      End If
      
    End If
    
    pExportAux = True
    
  End If
  
  Set m_Report = Nothing
  
  CloseProgressDlg
  ClosePDFDlg
End Function

Public Function PrintingPage(ByVal iPage As Long) As Boolean
  PrintingPage = pShowProgress(iPage, m_Report.Pages.Count)
End Function

' funciones friend
' funciones privadas

Private Function pGetIdFile() As String
  pGetIdFile = "_" & Format(Now, "dd-mm-yy-hhnnss")
End Function

Private Function pExport(ByRef Report As cReport, _
                         ByRef RptPrint As Object) As Boolean
'  On Error GoTo ControlError
'
'  Dim Mouse As cMouseWait
'  Set Mouse = New cMouseWait
'
'  Dim oFile As CSKernelFile.cFileEx
'  Set oFile = New CSKernelFile.cFileEx
'
'  Dim OutputFile As String
'  OutputFile = GetValidPath(oFile.FileGetPath(m_FileName)) & _
'                oFile.FileGetNameWithoutExt(m_FileName) & _
'                pGetIdFile() & _
'                ".pdf"
'
'  If pKillFile(OutputFile) Then
'
'    Dim bSetOldLaunchInfo As Boolean
'    Dim LaunchInfo As CSReportTDll.cReportLaunchInfo
'    Set LaunchInfo = New CSReportTDll.cReportLaunchInfo
'
'    Dim OldLaunchInfo As CSReportTDll.cReportLaunchInfo
'    Set OldLaunchInfo = Report.LaunchInfo
'
'    With LaunchInfo
'      .Action = csRptLaunchPrinter
'      .ShowPrintersDialog = False
'
'      Dim prn As Printer
'      Dim Index As Long
'      Index = pPrinterIndex("novaPDF Pro v5")
'      MsgWarning Index
'
'      Set prn = Printers(Index)
'
'      MsgBox Erl
'
'      .InitPrinter prn.DeviceName, _
'                   prn.DriverName, _
'                   prn.Port
'
'      .Printer.PaperInfo.PagesToPrint = "1-" & Report.Pages.Count
'      .Copies = 1
'    End With
'
'    bSetOldLaunchInfo = True
'    Report.SetLaunchInfo LaunchInfo
'
'    RptPrint.IsForExportToPDF = True
'    RptPrint.FileToSavePDF = OutputFile
'    RptPrint.PDFQuality = 2 'PDFQualitySmall
'
'    m_CancelExport = False
'
'    RptPrint.DoPrint Me
'
'    m_fProgress.lbTask.Caption = "Generando el archivo PDF"
'
'    Dim n           As Long
'    Dim k           As Long
'    Dim lastFileLen As Long
'    Dim q           As Long
'
'    k = m_Report.Pages.Count * 4
'    lastFileLen = -1
'
'    Do
'
'      If m_CancelExport Then Exit Do
'
'      If n > k Then n = 0
'      n = n + 1
'      pShowProgress n, k
'
'      Sleep 500
'
'      If ExistsFile(OutputFile) Then
'
'        If FileLen(OutputFile) <> lastFileLen Or FileLen(OutputFile) = 0 Then
'
'          q = 0
'
'          lastFileLen = FileLen(OutputFile)
'          'Debug.Print OutputFile
'          'Debug.Print FileLen(OutputFile)
'          'Debug.Print lastFileLen
'
'        ElseIf FileLen(OutputFile) = lastFileLen Then
'
'          q = q + 1
'          If q > 4 Then
'            Exit Do
'          End If
'        End If
'      End If
'
'    Loop
'
'    m_fProgress.lbCurrPage.Visible = False
'    m_fProgress.lbPages.Visible = False
'    m_fProgress.Label3.Caption = "Procesando ..."
'    m_fProgress.Label1.Visible = False
'
'    If Not m_CancelExport Then
'
'      If ExistsFile(OutputFile) Then
'
'        m_OutputFile = OutputFile
'        pExport = True
'
'      Else
'
'        MsgError "La exportacion fallo por un error inexperado. Pruebe nuevamente la exportación."
'
'      End If
'
'    End If
'
'  End If
'
'  GoTo ExitProc

100   On Error GoTo ControlError
101
102   Dim Mouse As cMouseWait
103   Set Mouse = New cMouseWait
104
105   Dim oFile As CSKernelFile.cFileEx
106   Set oFile = New CSKernelFile.cFileEx
107
108   Dim OutputFile As String
109   OutputFile = GetValidPath(oFile.FileGetPath(m_FileName)) & _
                 oFile.FileGetNameWithoutExt(m_FileName) & _
                 pGetIdFile() & _
                 ".pdf"
113
114   If pKillFile(OutputFile) Then
115
116     Dim bSetOldLaunchInfo As Boolean
117     Dim LaunchInfo As CSReportTDll.cReportLaunchInfo
118     Set LaunchInfo = New CSReportTDll.cReportLaunchInfo
119
120     Dim OldLaunchInfo As CSReportTDll.cReportLaunchInfo
121     Set OldLaunchInfo = Report.LaunchInfo
122
123     With LaunchInfo
124       .Action = csRptLaunchPrinter
125       .ShowPrintersDialog = False
126
127       Dim prn As Printer
128       Dim Index As Long
129       Index = pPrinterIndex("novaPDF Pro v5")
131
132       Set prn = Printers(Index)

133       'MsgBox prn.DeviceName
134       'MsgBox prn.DriverName
135       'MsgBox prn.Port

136       .InitPrinter prn.DeviceName, _
                    prn.DriverName, _
                    prn.Port
139
          
140       .Printer.PaperInfo.PagesToPrint = "1-" & Report.Pages.Count
141       .Copies = 1
142     End With
143
144     bSetOldLaunchInfo = True
145     Report.SetLaunchInfo LaunchInfo
146
147     RptPrint.IsForExportToPDF = True
148     RptPrint.FileToSavePDF = OutputFile
149     RptPrint.PDFQuality = 2 'PDFQualitySmall
150
151     m_CancelExport = False
152
153     RptPrint.DoPrint Me
154
155     m_fProgress.lbTask.Caption = "Generando el archivo PDF"
156
157     Dim n           As Long
158     Dim k           As Long
159     Dim lastFileLen As Long
160     Dim q           As Long
161
162     k = m_Report.Pages.Count * 4
163     lastFileLen = -1
164
165     Do
166
167       If m_CancelExport Then Exit Do
168
169       If n > k Then n = 0
170       n = n + 1
171       pShowProgress n, k
172
173       Sleep 500
174
175       If ExistsFile(OutputFile) Then
176
177         If FileLen(OutputFile) <> lastFileLen Or FileLen(OutputFile) = 0 Then
178
179           q = 0
180
181           lastFileLen = FileLen(OutputFile)
182           'Debug.Print OutputFile
183           'Debug.Print FileLen(OutputFile)
184           'Debug.Print lastFileLen
185
186         ElseIf FileLen(OutputFile) = lastFileLen Then
187
188           q = q + 1
189           If q > 4 Then
190             Exit Do
191           End If
192         End If
193       End If
194
195     Loop
196
197     m_fProgress.lbCurrPage.Visible = False
198     m_fProgress.lbPages.Visible = False
199     m_fProgress.Label3.Caption = "Procesando ..."
200     m_fProgress.Label1.Visible = False
201
202     If Not m_CancelExport Then
203
204       If ExistsFile(OutputFile) Then
205
206         m_OutputFile = OutputFile
207         pExport = True
208
209       Else
210
211         MsgError "La exportacion fallo por un error inexperado. Pruebe nuevamente la exportación."
212
213       End If
214
215     End If
216
217   End If
218
219   GoTo ExitProc

ControlError:
  MngError Err, "pExport", C_Module, "Linea: " & Erl
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  If bSetOldLaunchInfo Then
    Report.SetLaunchInfo OldLaunchInfo
  End If
End Function

Private Sub m_fPDFExport_Preview()
  pPreview m_fPDFExport.OutputFile
End Sub

Private Sub m_fPDFExport_Save()
  pSave m_fPDFExport.OutputFile
End Sub

Private Sub m_fPDFExport_SendEmail()
  SendMail m_fPDFExport.OutputFile
End Sub

Private Sub m_fProgress_Cancel()
  m_CancelExport = True
End Sub

Private Sub m_fProgress_Export()
  m_fProgress.Ok = pExport(m_Report, m_RptPrint)
End Sub

Private Function pPrinterIndex(ByVal Printername As String) As Long
  Dim i As Long
  
  pPrinterIndex = -1
  
  For i = 0 To Printers.Count - 1
    If UCase(Printers(i).DeviceName) = UCase$(Printername) Then
      pPrinterIndex = i
      Exit For
    End If
  Next i
End Function

'Private Sub m_PDFCreator_eReady()
'  'MsgInfo "El archivo: """ & m_PDFCreator.cOutputFilename & """ se generó con éxito! (" & _
'  'DateDiff("s", m_StartTime, Now) & " segundos)"
'  m_PDFCreator.cPrinterStop = True
'  m_bError = False
'  m_bDone = True
'End Sub

'Private Sub m_PDFCreator_eError()
'  Dim pErr As clsPDFCreatorError
'  Set pErr = m_PDFCreator.cError
'  If pErr.Number <> 2 Then
'    MsgError "La exportación a PDF fallo con el siguiente error[" & pErr.Number & "]: " & pErr.Description
'    m_bError = True
'    m_bDone = True
'  End If
'End Sub

Private Function pShowProgress(ByVal nPage As Long, ByVal nPages As Long) As Boolean
  DoEvents

  If m_CancelExport Then
    CSKernelClient2.Title = "Exportando a PDF"
    If Ask("Confirma que desea cancelar la exportación a PDF", vbNo) Then
      Exit Function
    Else
      m_CancelExport = False
    End If
  End If

  If m_fProgress Is Nothing Then Exit Function

  If nPage > 0 Then m_fProgress.lbCurrPage.Caption = nPage

  Dim Percent As Double
  If nPages > 0 And nPage > 0 Then
    Percent = nPage / nPages
    On Error Resume Next
    m_fProgress.prgVar.Value = Percent * 100
  End If
  
  pShowProgress = True
End Function

Private Sub CloseProgressDlg()
  On Error Resume Next
  Unload m_fProgress
  Set m_fProgress = Nothing
End Sub

Private Sub ClosePDFDlg()
  On Error Resume Next
  Unload m_fPDFExport
  Set m_fPDFExport = Nothing
End Sub

Private Function pPreview(ByVal PdfFile As String) As Boolean
  On Error GoTo ControlError

  CSKernelClient2.EditFile PdfFile, 0

  GoTo ExitProc
ControlError:
  MngError Err, "pPreview", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pSave(ByVal PdfFile As String) As Boolean
  On Error GoTo ControlError

  Dim oFile As CSKernelFile.cFile
  Set oFile = New CSKernelFile.cFile
  
  Dim iFile As CSKernelFile.cFileEx
  Set iFile = New CSKernelFile.cFileEx
  
  With m_fPDFExport
    .cdSave.InitDir = GetValidPath( _
                      GetEspecialFolders(sfidPERSONAL))
    oFile.Init "pSave", C_Module, .cdSave
  End With
  
  oFile.Filter = "Archivos PDF|*.pdf"
  
  If oFile.FSave(oFile.GetFileName(PdfFile), False, False) Then
    
    If ExistsFile(oFile.FullName) Then
      If Not iFile.FileDelete(oFile.FullName) Then Exit Function
    End If
    
    pSave = iFile.FileCopyFile(PdfFile, oFile.FullName)
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "pSave", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function SendMail(ByVal PdfFile As String) As Boolean
  SendMail = SendMail2(PdfFile, "", "")
End Function

Public Function SendMail2(ByVal PdfFile As String, ByVal subject As String, ByVal body As String) As Boolean
  On Error GoTo ControlError
  
  Dim oMail As cMailSimpleMapi
  Set oMail = New cMailSimpleMapi
  
  Dim vList As Variant
  Dim i     As Integer
  
  vList = Split(PdfFile, "|")
  
  For i = 0 To UBound(vList)
    If LenB(Trim$(vList(i))) Then
      oMail.AttachFiles.Add vList(i)
    End If
  Next
  
  oMail.SendMail "", m_ExportEmailAddress, subject, body
  
  SendMail2 = True
  
  GoTo ExitProc
ControlError:
  If Err.Number <> 32001 Then
    MngError Err, "SendMail2", C_Module, ""
  End If
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error GoTo ControlError

'  If m_noStart = False And _
'     Not m_PDFCreator Is Nothing Then
'
'    DoEvents
'    m_PDFCreator.cClose
'  End If
'
'  Set m_PDFCreator = Nothing
  
  Set m_Report = Nothing
  Set m_RptPrint = Nothing
  CloseProgressDlg
  ClosePDFDlg

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pKillFile(ByVal FullFileName As String) As Boolean
  On Error GoTo ControlError

  If ExistsFile(FullFileName) Then
    Kill FullFileName
  End If
  
  pKillFile = True

  GoTo ExitProc
ControlError:
  MngError Err, "pKillFile", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

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
