VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cExporToExcel"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cExportToExcel
' 12-10-1999

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
Private Const C_Module = "cExportToExcel"

Private Const xlDiagonalDown = 5
Private Const xlNone = &HFFFFEFD2
Private Const xlAutomatic = &HFFFFEFF7
Private Const xlLeft = &HFFFFEFDD
Private Const xlUnderlineStyleNone = &HFFFFEFD2
Private Const xlDiagonalUp = 6
Private Const xlEdgeLeft = 7
Private Const xlContinuous = 1
Private Const xlThin = 2
Private Const xlEdgeTop = 8
Private Const xlEdgeBottom = 9
Private Const xlEdgeRight = 10
Private Const xlSolid = 1
' estructuras
' variables privadas
Private m_xlApp   As Object
Private m_xlBook  As Object
Private m_xlSheet As Object
Private m_oData   As Object
Private m_vData   As Variant
Private m_Total   As Long

' Coordenadas en la hoja excell
Private m_curX As Long
Private m_curY As Long
Private m_curLastCol As Long
Private m_CurrentSheet As Long

#If Not PREPROC_WEBREPORT Then
Private WithEvents m_fExportToExcel As fExportToExcel
Attribute m_fExportToExcel.VB_VarHelpID = -1
#End If

Private m_Success       As Boolean
Private m_Cancel        As Boolean
Private m_ShowDialog    As Boolean
Private m_DataType      As dblDataTypeExport

Private m_bDescripColInCol As Boolean

' eventos
Public Event ChangeComplete(ByRef bCancel As Boolean, ByVal dPorcentaje As Double)

' propiedades publicas
Public Property Get ShowDialog() As Boolean
   ShowDialog = m_ShowDialog
End Property

Public Property Let ShowDialog(ByVal rhs As Boolean)
   m_ShowDialog = rhs
End Property

#If PREPROC_WEBREPORT Then
Public Property Get LastError() As String
  LastError = gStrError
End Property
#End If
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Export(ByVal DataType As dblDataTypeExport, _
                       ByVal strFile As String, _
                       Optional ByRef oData As Object, _
                       Optional ByRef vData As Variant) As Boolean
  
  On Error GoTo ControlError
  
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
    
    pExport

#If Not PREPROC_WEBREPORT Then
  End If
#End If
  
  If m_Success Then
  
    ' Guardo en el archivo
    If strFile = "" Then
      m_xlApp.Visible = True
    Else
      m_xlSheet.SaveAs strFile
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
  
  If m_Success Then
    If strFile <> "" Then
      m_xlBook.Close False
    End If
  End If
  
  If m_Cancel Then
    ' Para que el usuario tenga posibilidad de cerrar
    ' excel
    m_xlApp.Visible = True
  End If

  Set m_xlSheet = Nothing
  Set m_xlBook = Nothing
  Set m_xlApp = Nothing
  
#If Not PREPROC_WEBREPORT Then
  Unload m_fExportToExcel
  Set m_fExportToExcel = Nothing
#End If
End Function
' funciones friend
' funciones privadas
Private Sub pExport()
  On Error GoTo ControlError
  
  ' Creo un objeto aplicación excel
  Set m_xlApp = CreateObject("Excel.Application")
  
  ' Agrego un libro
  Set m_xlBook = m_xlApp.Workbooks.Add
  
  ' Obtengo una hoja
  m_CurrentSheet = 1
  Set m_xlSheet = m_xlBook.Worksheets(m_CurrentSheet)
  
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
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
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
  Dim Range       As Object 'Excel.Range
  Dim offsetGroup As Integer
  
  On Error GoTo ControlError
    
  If Not m_bDescripColInCol Then
    iRowCol = m_oData.RowTextStartColumn
  End If
  
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
  
    If m_oData.RowVisible(i) Then
  
      If m_oData.RowIsGroup(i) Then
        
        bIsGroup = True
        m_curX = m_oData.IndexGroup(i)
        
        If m_curX = -1001 Or m_curX > 0 Then
        
          If m_curX = -1001 Then m_curX = 1
          
          pPrintCell m_oData.Cell(i, Cols + offsetGroup).Text
          Set Range = m_xlSheet.Range(m_xlSheet.Cells(m_curY, m_curX - 1), _
                                      m_xlSheet.Cells(m_curY, m_curX - 1))
          Range.ColumnWidth = 3
          pFormatHeader m_curY, 1, Cols - 2
          Set Range = m_xlSheet.Range(m_xlSheet.Cells(m_curY, m_curX - 1), _
                                      m_xlSheet.Cells(m_curY, Cols - 2))
          Range.Merge
          Range.HorizontalAlignment = xlLeft
        
        ElseIf m_curX < 0 Then
        
          m_curX = 1
          For j = 1 To Cols
            If m_oData.ColumnVisible(j) Then
              pPrintCell m_oData.Cell(i, j).Text
              
              If iRowCol = j Then iRowCol = m_curX - 1
            End If
          Next j
          pFormatHeader m_curY, 1, Cols - 2
        End If
        
      Else
        bIsGroup = False
        
        For j = 1 To Cols
          If m_oData.ColumnVisible(j) Then
            pPrintCell m_oData.Cell(i, j).Text
            
            If iRowCol = j Then iRowCol = m_curX - 1
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
        If m_oData.Cell(i, Cols + 1).Text <> "" Then
        
          pNextRow
          m_curX = iRowCol
          pPrintCell vbNullString
          pPrintCell m_oData.Cell(i, Cols + 1).Text
          
          Set Range = m_xlSheet.Range(m_xlSheet.Cells(m_curY, m_curX - 1), m_xlSheet.Cells(m_curY, Cols - iRowCol))
          Range.Merge
          Range.RowHeight = pGetHeight(m_oData.Cell(i, Cols + 1).Text)
          Range.VerticalAlignment = &HFFFFEFC0 'xlTop
          Range.Font.Color = vbBlue
        End If
      End If
    
      RaiseEvent ChangeComplete(bCancel, pGetPercent(i))
      If bCancel Then Exit Function
      
      pNextRow
    
    End If
  
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
  
  On Error GoTo ControlError
    
  For i = 1 To m_oData.Rows
    
    For j = 1 To m_oData.Columns.Count
      If m_oData.Columns(j).Visible Then
        pPrintCell m_oData.Cell(i, j).Text
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
    pNextRow
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
  On Error GoTo ControlError
  
  For i = LBound(m_vData, 2) To UBound(m_vData, 2)
    For j = LBound(m_vData, 1) To UBound(m_vData, 1)
      pPrintCell m_vData(j, i)
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
    pNextRow
  Next i
  
  pExportMatrix = True
  Exit Function
ControlError:
  MngError_ Err, "pExportMatrix", C_Module, ""
End Function

Private Function pExportArray() As Boolean
  Dim i As Long
  Dim bCancel As Boolean
  On Error GoTo ControlError
  
  For i = LBound(m_vData) To UBound(m_vData)
    pPrintCell m_vData(i)
    
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
  On Error GoTo ControlError
  
  While Not m_oData.EOF
    For Each Col In m_oData.Fields
      pPrintCell Col.Value
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
    pNextRow
  Wend
  
  pExportRs = True
  Exit Function
ControlError:
  MngError_ Err, "pExportRs", C_Module, ""
End Function


' Print in Sheet
Private Function pPrintCell(ByVal vValor As Variant) As Boolean
  On Error GoTo ControlError
  
  If IsNull(vValor) Then
    m_xlSheet.Cells(m_curY, m_curX) = "NULL"
  Else
    If IsDate(vValor) And Not IsNumeric(vValor) Then
      If Len(vValor) > 10 Then
        m_xlSheet.Cells(m_curY, m_curX) = Format(vValor, "mm/dd/yyyy hh:nn:ss")
      Else
        m_xlSheet.Cells(m_curY, m_curX) = Format(DateValue(vValor), "mm/dd/yyyy")
      End If
      
    ElseIf IsNumeric(vValor) Then
      m_xlSheet.Cells(m_curY, m_curX) = vValor
    Else
      m_xlSheet.Cells(m_curY, m_curX) = Replace(vValor, vbCrLf, vbLf)
    End If
  End If
  m_curX = m_curX + 1
  
  pPrintCell = True
  Exit Function
ControlError:
  MngError_ Err, "pPrintCell", C_Module, ""
End Function

Private Function pNextRow() As Boolean
  m_curLastCol = m_curX - 1
  m_curY = m_curY + 1
  m_curX = 1
  ' Si se me acabo la hoja empiezo en una nueva
  If m_curY > 655356 Then
    
    m_CurrentSheet = m_CurrentSheet + 1
    If m_CurrentSheet < 4 Then
      ' Continuo con la siguiente
      Set m_xlSheet = m_xlBook.Worksheets(m_CurrentSheet)
    Else
      ' Creo un hoja
      m_xlBook.Worksheets.Add
      Set m_xlSheet = m_xlBook.Worksheets(m_CurrentSheet)
    End If
    m_curY = 2
  End If
  
  pNextRow = True
  Exit Function
ControlError:
  MngError_ Err, "pNextRow", C_Module, ""
End Function

' Headers
Private Function pPrintHeaders() As Boolean
  Dim Col       As Object
  Dim i         As Long
  
  On Error GoTo ControlError
  
  m_curY = 1
  m_curX = 1
  
  Select Case m_DataType
    Case dblExGrid
      Dim Cols As Long
      
      ' Si hay descripciones la ultima columna no se agrega
      If m_oData.RowTextStartColumn > 0 Then
        Cols = m_oData.Columns - 1
      
#If Not PREPROC_WEBREPORT Then
        If Ask_("Desea que la fila de descripciones se exporte como una columna", vbYes) Then
      
          m_bDescripColInCol = True
        End If
#End If

      Else
        Cols = m_oData.Columns
      End If
      
      For i = 1 To Cols
        If m_oData.ColumnVisible(i) Then
          pPrintCell m_oData.ColumnHeader(i)
        End If
      Next
      
      ' La grilla tiene columna de observaciones
      ' y el usuario pidio que salga en una columna
      ' y no en una fila
      '
      If m_bDescripColInCol Then
        pPrintCell m_oData.ColumnHeader(m_oData.Columns)
      End If
      
      pNextRow
    Case dblExGridAdvanced
      For i = 1 To m_oData.Columns.Count
        If m_oData.Columns(i).Visible Then
          pPrintCell m_oData.Columns(i).Caption
        End If
      Next
      pNextRow
    Case dblExMatrix
      For i = LBound(m_vData) To UBound(m_vData)
        pPrintCell m_vData(i, 0)
      Next
      pNextRow
    Case dblArray
      
    Case dblExRecordsetDao, dblExRecordsetAdo
      For Each Col In m_oData.Fields
        If Not pPrintCell(Col.Name) Then Exit Function
      Next
      pNextRow
  End Select
  
  pFormatHeader m_curY - 1, 1, m_curLastCol
  
  pPrintHeaders = True
  Exit Function
ControlError:
  MngError_ Err, "pPrintHeaders", C_Module, ""
End Function

Private Sub pFormatHeader(ByVal y As Long, ByVal x1 As Long, ByVal x2 As Long)
  Dim Range     As Object 'Excel.Range
  
  Set Range = m_xlSheet.Range(m_xlSheet.Cells(y, x1), m_xlSheet.Cells(y, x2))
  
  With Range.Font
    .Name = "Arial"
    .FontStyle = "Bold"
    .Size = 10
    .Strikethrough = False
    .Superscript = False
    .Subscript = False
    .OutlineFont = False
    .Shadow = False
    .Underline = xlUnderlineStyleNone
    .ColorIndex = xlAutomatic
  End With
  
  Range.Borders(xlDiagonalDown).LineStyle = xlNone
  Range.Borders(xlDiagonalUp).LineStyle = xlNone
  With Range.Borders(xlEdgeLeft)
    .LineStyle = xlContinuous
    .Weight = xlThin
    .ColorIndex = xlAutomatic
  End With
  With Range.Borders(xlEdgeTop)
    .LineStyle = xlContinuous
    .Weight = xlThin
    .ColorIndex = xlAutomatic
  End With
  With Range.Borders(xlEdgeBottom)
    .LineStyle = xlContinuous
    .Weight = xlThin
    .ColorIndex = xlAutomatic
  End With
  With Range.Borders(xlEdgeRight)
    .LineStyle = xlContinuous
    .Weight = xlThin
    .ColorIndex = xlAutomatic
  End With
  With Range.Interior
    .ColorIndex = 15
    .Pattern = xlSolid
    .PatternColorIndex = xlAutomatic
  End With
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_xlApp = Nothing
  Set m_xlBook = Nothing
  Set m_xlSheet = Nothing
  Set m_oData = Nothing
  
#If Not PREPROC_WEBREPORT Then
  On Error Resume Next
  Unload m_fExportToExcel
  Set m_fExportToExcel = Nothing
#End If

  GoTo ExitProc
ControlError:
  MngError_ Err, "Class_Terminate", C_Module, ""
  If Err.Number Then Resume ExitProc
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
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


