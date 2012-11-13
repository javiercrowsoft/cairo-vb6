VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cExportToCSV"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cExportToCSV
' 14-08-2006

'--------------------------------------------------------------------------------
' notas:

  ' Proposito: Export Data a excel
  
  ' Interfaz publica:
  ' Export                  Exporta Data a excel
  ' Evento ChangeComplete   Informa el porcentaje del trabajo realizado

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cExportToCSV"

' estructuras
' variables privadas
Private m_oData   As Object
Private m_vData   As Variant
Private m_Total   As Long

' Coordenadas en la hoja excell

#If Not PREPROC_WEBREPORT Then
Private WithEvents m_fExportToExcel As fExportToExcel
Attribute m_fExportToExcel.VB_VarHelpID = -1
#End If

Private m_Success       As Boolean
Private m_Cancel        As Boolean
Private m_ShowDialog    As Boolean
Private m_DataType      As dblDataTypeExport

Private m_tempFile      As String
Private m_itempFile     As Long

' eventos
Public Event ChangeComplete(ByRef bCancel As Boolean, ByVal dPorcentaje As Double)

' propiedades publicas
Public Property Get ShowDialog() As Boolean
   ShowDialog = m_ShowDialog
End Property

Public Property Let ShowDialog(ByVal rhs As Boolean)
   m_ShowDialog = rhs
End Property

Public Property Get LastError() As String
  LastError = gStrError
End Property

Public Property Get LogFile() As String
  LogFile = gLogFile
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Export(ByVal DataType As dblDataTypeExport, _
                       ByVal strFile As String, _
                       Optional ByRef oData As Object, _
                       Optional ByRef vData As Variant) As Boolean
  
  On Error GoTo ControlError
  
#If PREPROC_WEBREPORT Then
  SaveLog "Iniciando la Exportación"
#End If
  
  ' Obtengo una referencia a los Datos
  
  Set m_oData = oData
  m_vData = vData
  
  If oData Is Nothing And _
    TypeOf vData Is Object  Then
    Set m_oData = vData
  End If
  
  m_Success = False
  
  m_DataType = DataType
  
#If Not PREPROC_WEBREPORT Then
  If m_ShowDialog Then
    Set m_fExportToExcel = New fExportToExcel
    
    Load m_fExportToExcel
    
    m_fExportToExcel.HaveToRaiseEvent = True
    m_fExportToExcel.RaiseEventProgress = True
    
    m_fExportToExcel.Show vbModal
  Else
#End If

#If PREPROC_WEBREPORT Then
    SaveLog "Output file " & strFile
#End If

    pExport pGetFilePath(strFile)

#If Not PREPROC_WEBREPORT Then
  End If
#End If
  
  If m_Success Then
  
    ' Guardo en el archivo
    If strFile = "" Then
      ' TODO: Execute csv editor
      '       with shellexecute
    Else
      pRenameFile m_tempFile, strFile
    End If
  
    Export = True
  End If
  
  GoTo ExitProc
ControlError:
  If Err <> 1004 Then
    MngError_ Err, "Export", C_Module, ""
  End If
  Resume ExitProc
ExitProc:
  On Error Resume Next
  
#If Not PREPROC_WEBREPORT Then
  Unload m_fExportToExcel
  Set m_fExportToExcel = Nothing
#End If
End Function
' funciones friend
' funciones privadas
Private Sub pExport(ByVal PathDest As String)
  On Error GoTo ControlError
  
  ' Creo un objeto aplicación excel
  m_tempFile = pGetTempFile(Replace$("~ExportCSV" & Timer & ".csv", _
                                     ",", _
                                     vbNullString), _
                            PathDest)
  m_itempFile = FreeFile
  
  SaveLog "File Temp: " & m_tempFile
  
  Open m_tempFile For Output As m_itempFile
  
  m_Total = pGetTotal(m_DataType)
  
  pPrintHeaders
  
  Select Case m_DataType
    Case dblExGrid
      If Not pExportGrid() Then GoTo ExitProc
    Case dblExGridAdvanced
      If Not pExportGridAdvanced() Then GoTo ExitProc
    Case dblExMatrix
      If Not pExportMatrix() Then GoTo ExitProc
    Case dblArray
      If Not pExportArray() Then GoTo ExitProc
    Case dblExRecordsetDao
      If Not pExportDao() Then GoTo ExitProc
    Case dblExRecordsetAdo
      If Not pExportAdo() Then GoTo ExitProc
  End Select
  
  m_Success = True
  
  GoTo ExitProc
ControlError:
  MngError_ Err, "", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Close m_itempFile
  
#If Not PREPROC_WEBREPORT Then
  If m_ShowDialog Then
    Unload m_fExportToExcel
  End If
#End If
End Sub

#If Not PREPROC_WEBREPORT Then
Private Sub m_fExportToExcel_Export()
  pExport
End Sub

Private Sub m_fExportToExcel_Cancel()
  If Ask_("Desea cancelar la exportacion", vbNo) Then
    m_Cancel = True
  End If
End Sub
#End If

Private Function pGetTotal(ByVal DataType As Integer) As Long
  Select Case DataType
    Case dblExGrid, dblExGridAdvanced
      pGetTotal = m_oData.Rows
    Case dblExMatrix
      pGetTotal = UBound(m_vData, 2) - LBound(m_vData, 2) + 1
    Case dblArray
      pGetTotal = UBound(m_vData, 1) - LBound(m_vData, 1) + 1
      
    ' Esto puede no funcionar si el recordset no esta en memoria
    ' No funcionar significa que recordcount devuelve cero, no que
    ' se produsca un error
    Case dblExRecordsetDao
      pGetTotal = m_oData.RecordCount
    Case dblExRecordsetAdo
      pGetTotal = m_oData.RecordCount
  End Select
End Function

Private Function pGetPercent(ByVal lfila As Long) As Double
  If m_Total = 0 Then
    pGetPercent = 0
  Else
    pGetPercent = lfila / m_Total
  End If
End Function

' Print from Grid
Private Function pExportGrid() As Boolean
  Dim i As Long
  Dim j As Integer
  Dim bCancel As Boolean
  Dim Cols    As Long
  Dim bDescripCol As Boolean
  Dim bIsGroup    As Boolean
  Dim iRowCol     As Long
  Dim offsetGroup As Integer
  Dim strBuff     As String
  
  On Error GoTo ControlError
    
  iRowCol = m_oData.RowTextStartColumn
  
  ' Si hay descripciones la ultima columna no se agrega
  If iRowCol > 0 Then
    Cols = m_oData.Columns - 1
    offsetGroup = 1
    bDescripCol = True
  Else
    Cols = m_oData.Columns
    offsetGroup = 0
    bDescripCol = False
  End If
    
  For i = 1 To m_oData.Rows
  
    If m_oData.RowIsGroup(i) Then
      bIsGroup = True
      pPrintCell m_oData.Cell(i, Cols + offsetGroup).Text, strBuff
      
    Else
      bIsGroup = False
      
      For j = 1 To Cols
        If m_oData.ColumnVisible(j) Then
          pPrintCell m_oData.Cell(i, j).Text, strBuff
          
          If iRowCol = j Then iRowCol = 1
        End If
      Next j
    End If
    
#If Not PREPROC_WEBREPORT Then
    If m_ShowDialog Then
      m_fExportToExcel.ShowPercent pGetPercent(i) * 100
      DoEvents
      If m_Cancel Then Exit Function
    End If
#End If

    If bDescripCol And Not bIsGroup Then
      pPrintCell m_oData.Cell(i, Cols + 1).Text, strBuff
      pNextRow strBuff
      
    End If
    
    RaiseEvent ChangeComplete(bCancel, pGetPercent(i))
    If bCancel Then Exit Function
    pNextRow strBuff
  Next i
    
  pExportGrid = True
  Exit Function
ControlError:
  MngError_ Err, "pExportGrid", C_Module, ""
End Function

Private Function pGetHeight(ByVal strText As String) As Long
  Dim nLines As Long
  Dim i As Long
  
  i = 1
  i = InStr(i, strText, vbCrLf)
  While i
    nLines = nLines + 1
    i = i + 2
    i = InStr(i, strText, vbCrLf)
  Wend
  
  pGetHeight = 12.7 * (nLines + 1)
End Function

Private Function pExportGridAdvanced() As Boolean
  Dim i As Long
  Dim j As Integer
  Dim bCancel As Boolean
  Dim strBuff As String
  
  On Error GoTo ControlError
    
  For i = 1 To m_oData.Rows
    
    For j = 1 To m_oData.Columns.Count
      If m_oData.Columns(j).Visible Then
        pPrintCell m_oData.Cell(i, j).Text, strBuff
      End If
    Next j
    
#If Not PREPROC_WEBREPORT Then
    If m_ShowDialog Then
      m_fExportToExcel.ShowPercent pGetPercent(i) * 100
      DoEvents
      If m_Cancel Then Exit Function
    End If
#End If

    RaiseEvent ChangeComplete(bCancel, pGetPercent(i))
    If bCancel Then Exit Function
    pNextRow strBuff
  Next i
    
  pExportGridAdvanced = True
  Exit Function
ControlError:
  MngError_ Err, "pExportGridAdvanced", C_Module, ""
End Function

Private Function pExportMatrix() As Boolean
  Dim i As Long
  Dim j As Integer
  Dim bCancel As Boolean
  Dim strBuff As String
  
  On Error GoTo ControlError
  
  For i = LBound(m_vData, 2) To UBound(m_vData, 2)
    For j = LBound(m_vData, 1) To UBound(m_vData, 1)
      pPrintCell m_vData(j, i), strBuff
    Next j
    
#If Not PREPROC_WEBREPORT Then
    If m_ShowDialog Then
      m_fExportToExcel.ShowPercent pGetPercent(i) * 100
      DoEvents
      If m_Cancel Then Exit Function
    End If
#End If
    
    RaiseEvent ChangeComplete(bCancel, pGetPercent(i))
    If bCancel Then Exit Function
    pNextRow strBuff
  Next i
  
  pExportMatrix = True
  Exit Function
ControlError:
  MngError_ Err, "pExportMatrix", C_Module, ""
End Function

Private Function pExportArray() As Boolean
  Dim i As Long
  Dim bCancel As Boolean
  Dim strBuff As String
  
  On Error GoTo ControlError
  
  For i = LBound(m_vData) To UBound(m_vData)
    pPrintCell m_vData(i), strBuff
    
#If Not PREPROC_WEBREPORT Then
    If m_ShowDialog Then
      m_fExportToExcel.ShowPercent pGetPercent(i) * 100
      DoEvents
      If m_Cancel Then Exit Function
    End If
#End If
    
    RaiseEvent ChangeComplete(bCancel, pGetPercent(i))
    If bCancel Then Exit Function
  Next i
  
  
  pExportArray = True
  Exit Function
ControlError:
  MngError_ Err, "pExportArray", C_Module, ""
End Function

Private Function pExportDao() As Boolean
  pExportDao = pExportRs()
End Function

Private Function pExportAdo() As Boolean
  pExportAdo = pExportRs()
End Function

Private Function pExportRs() As Boolean
  Dim Col As Object
  Dim i As Long
  Dim bCancel As Boolean
  Dim strBuff As String
  
  On Error GoTo ControlError
  
  While Not m_oData.EOF
    For Each Col In m_oData.Fields
      pPrintCell Col.Value, strBuff
    Next
    
    i = i + 1
    
#If Not PREPROC_WEBREPORT Then
    If m_ShowDialog Then
      m_fExportToExcel.ShowPercent pGetPercent(i) * 100
      DoEvents
      If m_Cancel Then Exit Function
    End If
#End If

    RaiseEvent ChangeComplete(bCancel, pGetPercent(i))
    If bCancel Then Exit Function
    m_oData.MoveNext
    pNextRow strBuff
    
  Wend
  
  pExportRs = True
  Exit Function
ControlError:
  MngError_ Err, "pExportRs", C_Module, ""
End Function


' Print in Sheet
Private Function pPrintCell(ByVal vValor As Variant, ByRef strBuff As String) As Boolean
  On Error GoTo ControlError
  
  If IsNull(vValor) Then
    strBuff = strBuff & """NULL""" & vbTab
  Else
    If IsDate(vValor) And Not IsNumeric(vValor) Then
      If Len(vValor) > 10 Then
        strBuff = strBuff & """" & Format(vValor, "mm/dd/yyyy hh:nn:ss") & """" & vbTab
      Else
        strBuff = strBuff & """" & Format(DateValue(vValor), "mm/dd/yyyy") & """" & vbTab
      End If
    Else
      strBuff = strBuff & """" & Replace(vValor, vbCrLf, vbNullString) & """" & vbTab
    End If
  End If
  
  pPrintCell = True
  Exit Function
ControlError:
  MngError_ Err, "pPrintCell", C_Module, ""
End Function

Private Function pNextRow(ByRef strBuff As String) As Boolean
  
  Print #m_itempFile, strBuff
  strBuff = vbNullString
  
  pNextRow = True
  Exit Function
ControlError:
  MngError_ Err, "pNextRow", C_Module, ""
End Function

' Headers
Private Function pPrintHeaders() As Boolean
  Dim Col       As Object
  Dim i         As Long
  Dim strBuff   As String
  
  On Error GoTo ControlError
  
  Select Case m_DataType
    Case dblExGrid
      Dim Cols As Long
      
      ' Si hay descripciones la ultima columna no se agrega
      If m_oData.RowTextStartColumn > 0 Then
        Cols = m_oData.Columns - 1
      Else
        Cols = m_oData.Columns
      End If
      
      For i = 1 To Cols
        If m_oData.ColumnVisible(i) Then
          pPrintCell m_oData.ColumnHeader(i), strBuff
        End If
      Next
      pNextRow strBuff
      
    Case dblExGridAdvanced
      For i = 1 To m_oData.Columns.Count
        If m_oData.Columns(i).Visible Then
          pPrintCell m_oData.Columns(i).Caption, strBuff
        End If
      Next
      pNextRow strBuff
      
    Case dblExMatrix
      For i = LBound(m_vData) To UBound(m_vData)
        pPrintCell m_vData(i, 0), strBuff
      Next
      pNextRow strBuff
      
    Case dblArray
      
    Case dblExRecordsetDao, dblExRecordsetAdo
      For Each Col In m_oData.Fields
        If Not pPrintCell(Col.Name, strBuff) Then Exit Function
      Next
      pNextRow strBuff
      
  End Select
  
  pPrintHeaders = True
  Exit Function
ControlError:
  MngError_ Err, "pPrintHeaders", C_Module, ""
End Function

Private Function pGetTempFile(ByVal tempFile As String, ByVal PathDest As String) As String
  On Error Resume Next
  Dim rtn As String
#If Not PREPROC_WEBREPORT Then
  rtn = Environ$("TEMP")
  If rtn = vbNullString Then
#End If
    rtn = PathDest
#If Not PREPROC_WEBREPORT Then
  End If
#End If
  pGetTempFile = rtn & "\" & tempFile
End Function

Private Function pGetFilePath(ByVal strFullFile As String) As String
  Dim n As Integer
  
  For n = Len(strFullFile) To 1 Step -1
    If Mid$(strFullFile, n, 1) = "\" Then
      pGetFilePath = Left$(strFullFile, n)
      Exit Function
    End If
  Next
End Function

Private Sub pRenameFile(ByVal strFile As String, ByVal strNewName As String)
  FileCopy strFile, strNewName
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_oData = Nothing
  
#If Not PREPROC_WEBREPORT Then
  On Error Resume Next
  Unload m_fExportToExcel
  Set m_fExportToExcel = Nothing
#End If

  GoTo ExitProc
ControlError:
  MngError_ Err, "Class_Terminate", C_Module, ""
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

