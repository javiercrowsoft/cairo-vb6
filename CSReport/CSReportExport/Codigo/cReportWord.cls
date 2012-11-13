VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportWord"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cReportWord
' 21-10-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cReportWord"
' estructuras
' variables privadas
Private m_FileName                      As String
Private m_InFirstPage                   As Boolean
Private WithEvents m_fProgress          As fProgress
Attribute m_fProgress.VB_VarHelpID = -1
Private m_CancelExport                  As Boolean
Private m_Report                        As cReport
' eventos
' propiedades publicas
Public Property Get FileName() As String
   FileName = m_FileName
End Property

Public Property Let FileName(ByVal rhs As String)
   m_FileName = rhs
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Private Sub m_fProgress_Cancel()
  m_CancelExport = True
End Sub

Private Sub m_fProgress_Export()
  m_fProgress.Ok = pExport()
End Sub

Public Function Export(ByRef Report As cReport) As Boolean
  Set m_fProgress = New fProgress
  
  Set m_Report = Report
  
  m_fProgress.lbPages.Caption = Report.Pages.Count
  m_fProgress.lbTask.Caption = "Exportando a Word"
  m_fProgress.Caption = "Exportando a Word"
  m_fProgress.InitWord
  
  m_fProgress.Show vbModal
  
  Export = m_fProgress.Ok
  
  Set m_Report = Nothing
  
  CloseProgressDlg
End Function

Private Function pExport() As Boolean
  On Error GoTo ControlError
  
  Dim Page      As cReportPage
  Dim AppWord   As Object 'Word.Application
  Dim DocWord   As Object 'Word.Document
  Dim bPageBreack As Boolean
  
  Set AppWord = CSKernelClient2.CreateObject("Word.Application")
  
  Set DocWord = AppWord.Documents.Add
  
  m_InFirstPage = True
  
  Dim nPage  As Long
  Dim nPages As Long
  
  nPages = m_Report.Pages.Count
  
  For Each Page In m_Report.Pages
    nPage = nPage + 1
    
    pPrintInWord Page.Header, DocWord, bPageBreack
    pPrintInWord Page.Detail, DocWord
    pPrintInWord Page.Footer, DocWord
    bPageBreack = True
    
    If Not pShowProgress(nPage, nPages) Then
      AppWord.Quit False
      GoTo ExitProc
    End If
  Next

  AppWord.Visible = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pExport", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function
' funciones friend
' funciones privadas
'Private Sub pPrintInWord(ByRef Fields As cReportPageFields, ByRef DocWord As Word.Document, Optional ByVal PageBreackBefore As Boolean = False)
Private Sub pPrintInWord(ByRef Fields As cReportPageFields, _
                         ByRef DocWord As Object, Optional ByVal PageBreackBefore As Boolean = False)
  Dim Fld As cReportPageField
  Dim CurrentIndex  As Long
  Dim textParagraph  As String
  
  For Each Fld In Fields
    
    ' Imprimo el campo en word
    If CurrentIndex <> Fld.IndexLine Then
      If CurrentIndex <> 0 Then
        With DocWord.Paragraphs
          .Add
          If PageBreackBefore Then
            .Item(.Count).Range.InsertBreak 1 'wdPageBreak
            .Item(.Count).Range.InsertAfter textParagraph
            PageBreackBefore = False
          Else
            .Item(.Count).Range.Text = textParagraph
          End If
        End With
      End If
      
      CurrentIndex = Fld.IndexLine
      
      textParagraph = ""
    Else
      textParagraph = textParagraph & " "
    End If
    
    textParagraph = textParagraph & Fld.Value
  Next
  
  With DocWord.Paragraphs
    If m_InFirstPage Then
      m_InFirstPage = False
    Else
      .Add
    End If
    
    If PageBreackBefore Then
      .Item(.Count).Range.InsertBreak 1 'wdPageBreak
      .Item(.Count).Range.InsertAfter textParagraph
      PageBreackBefore = False
    Else
      .Item(.Count).Range.Text = textParagraph
    End If
  End With
End Sub

Private Function pShowProgress(ByVal nPage As Long, ByVal nPages As Long) As Boolean
  DoEvents

  If m_CancelExport Then
    CSKernelClient2.Title = "Exportando a Word"
    If Ask("Confirma que desea cancelar la exportación a Word", vbNo) Then
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

' construccion - destruccion

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  CloseProgressDlg
  Set m_Report = Nothing

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
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
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


