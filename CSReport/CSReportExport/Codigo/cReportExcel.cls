VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportExcel"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cReportExcel
' 27-10-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cReportExcel"
' estructuras
' variables privadas
Private m_FileName                      As String
Private WithEvents m_fProgress          As fProgress
Attribute m_fProgress.VB_VarHelpID = -1
Private m_CancelExport                  As Boolean
Private m_Report                        As cReport
Private m_CurrentSheet                  As Long
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
  m_fProgress.lbTask.Caption = "Exportando a Excel"
  m_fProgress.Caption = "Exportando a Excel"
  m_fProgress.InitExcel
  
  m_fProgress.Show vbModal
  
  Export = m_fProgress.Ok
  
  Set m_Report = Nothing
  
  CloseProgressDlg
End Function

Private Function pExport() As Boolean
  On Error GoTo ControlError
  
  Dim Page          As cReportPage
  Dim AppExcel      As Object 'Excel.Application
  Dim DocExcel      As Object 'Excel.Workbook
  Dim bPageBreack   As Boolean
  Dim currentRow    As Long

  
  Set AppExcel = CSKernelClient2.CreateObject("Excel.Application")
  
  Set DocExcel = AppExcel.Workbooks.Add
  
  Dim nPage  As Long
  Dim nPages As Long
  
  nPages = m_Report.Pages.Count
  
  m_CurrentSheet = 1
  
  For Each Page In m_Report.Pages
    nPage = nPage + 1
    
    pPrintInExcel Page.Header, DocExcel, currentRow
    pPrintInExcel Page.Detail, DocExcel, currentRow
    pPrintInExcel Page.Footer, DocExcel, currentRow
    bPageBreack = True
    
    If Not pShowProgress(nPage, nPages) Then
      DocExcel.Close False
      AppExcel.Quit
      GoTo ExitProc
    End If
  Next

  AppExcel.Visible = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pExport", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function
' funciones friend
' funciones privadas
'Private Sub pPrintInExcel(ByRef Fields As cReportPageFields, ByRef DocExcel As Excel.Workbook, ByRef currentRow As Long)
Private Sub pPrintInExcel(ByRef Fields As cReportPageFields, _
                          ByRef DocExcel As Object, ByRef currentRow As Long)
  Dim Fld As cReportPageField
  Dim CurrentIndex    As Long
  Dim Sheet           As Object 'Excel.Worksheet
  Dim nCol            As Long
  Dim strFormat       As String
  
  If DocExcel.Worksheets.Count < m_CurrentSheet Then
    Set Sheet = DocExcel.Worksheets.Add
  Else
    Set Sheet = DocExcel.Worksheets.Item(m_CurrentSheet)
  End If
   
  For Each Fld In Fields
    
    ' si (Fld.Info.Aspect.Width > 7000 And Fld.Value = "")
    ' Probablemente sea un objeto de dibujo asi que no lo proceso
    If Not (Fld.Info.Aspect.Width > 7000 And Fld.Value = "") Then
    
      ' Imprimo el campo en Excel
      If CurrentIndex <> Fld.IndexLine Then
        CurrentIndex = Fld.IndexLine
        
        nCol = 1
        currentRow = currentRow + 1
        If currentRow > 65536 Then
          m_CurrentSheet = m_CurrentSheet + 1
          
          If DocExcel.Worksheets.Count < m_CurrentSheet Then
            Set Sheet = DocExcel.Worksheets.Add
          Else
            Set Sheet = DocExcel.Worksheets.Item(m_CurrentSheet)
          End If
          
          currentRow = 1
        End If
      Else
        nCol = nCol + 1
      End If
      
      Select Case Fld.Info.FieldType
      
        Case adDate, _
             adDBDate, _
             adDBTime, _
             adDBTimeStamp, _
             adBSTR
             
          strFormat = Replace(Fld.Info.Aspect.Format, "-", "/")
          strFormat = Replace(strFormat, ".", "/")
          strFormat = Replace(strFormat, "*", "/")
          If strFormat = "dd/mm/yyyy" Or strFormat = "dd/mm/yy" Then
            Sheet.cells.Item(currentRow, nCol) = pDateSerial(Mid$(Fld.Value, 7, 4), _
                                                             Mid$(Fld.Value, 4, 2), _
                                                             Mid$(Fld.Value, 1, 2))
          ElseIf strFormat = "mm/dd/yyyy" Or strFormat = "mm/dd/yy" Then
            Sheet.cells.Item(currentRow, nCol) = Fld.Value
          ElseIf strFormat = "yyyy/mm/dd" Or strFormat = "yy/mm/dd" Then
            Sheet.cells.Item(currentRow, nCol) = pDateSerial(Mid$(Fld.Value, 1, 4), _
                                                             Mid$(Fld.Value, 6, 2), _
                                                             Mid$(Fld.Value, 9, 2))
          ElseIf IsDate(Fld.Value) Then
            Sheet.cells.Item(currentRow, nCol) = DateValue(Fld.Value)
          End If
        Case Else
          Sheet.cells.Item(currentRow, nCol) = Fld.Value
      End Select
    End If
  Next
End Sub

Private Function pShowProgress(ByVal nPage As Long, ByVal nPages As Long) As Boolean
  DoEvents

  If m_CancelExport Then
    CSKernelClient2.Title = "Exportando a Excel"
    If Ask("Confirma que desea cancelar la exportación a Excel", vbNo) Then
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

Private Function pDateSerial(ByVal Year As String, _
                             ByVal Month As String, _
                             ByVal Day As String) As Date
  On Error Resume Next
  pDateSerial = DateSerial(Year, Month, Day)
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
