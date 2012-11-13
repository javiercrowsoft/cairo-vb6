VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cExportToXML"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cExportToXML
' 12-10-1999

'--------------------------------------------------------------------------------
' notas:

  ' Proposito: Export Data a excel
  
  ' Interfaz publica:
  ' Export                  Exporta Data a xml
  ' Evento ChangeComplete   Informa el porcentaje del trabajo realizado

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cExportToXML"

Private Const c_RowTag = "@row_tag"

' estructuras

' variables privadas
Private m_oData   As Object
Private m_vData   As Variant
Private m_Total   As Long

#If Not PREPROC_WEBREPORT Then
Private WithEvents m_fExportToExcel As fExportToExcel
Attribute m_fExportToExcel.VB_VarHelpID = -1
#End If

Private m_Success       As Boolean
Private m_Cancel        As Boolean
Private m_ShowDialog    As Boolean
Private m_DataType      As dblDataTypeExport

Private m_strXmlHeader    As String
Private m_strXmlFooter    As String
Private m_str_def_XmlRow  As String
Private m_strFile         As String
Private m_xmlFile         As Long
Private m_rowTag          As String
Private m_vTags()         As String

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
                       ByVal strXmlHeader As String, _
                       ByVal strXmlFooter As String, _
                       ByVal str_def_XmlRow As String, _
                       Optional ByRef oData As Object, _
                       Optional ByRef vData As Variant) As Boolean
  
  On Error GoTo ControlError
  
  If ExistsFile_(strFile) Then
    Kill strFile
  End If
  
  m_strFile = strFile
  m_strXmlHeader = strXmlHeader
  m_strXmlFooter = strXmlFooter
  m_str_def_XmlRow = str_def_XmlRow
  
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
    
    m_fExportToExcel.lbExportTo.Caption = "Exportando a XML ...."
    m_fExportToExcel.imgXLS.Visible = False
    m_fExportToExcel.imgXML.Visible = True
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
Private Sub pExport()
  On Error GoTo ControlError
  
  m_Total = pGetTotal(m_DataType)

  If Not pOpenXml() Then Exit Sub

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
  
  If Not pCloseXml() Then Exit Sub
  
  m_Success = True
  
  GoTo ExitProc
ControlError:
  MngError_ Err, "", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  ' Por si dio error
  '
  pCloseXml
  
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
  
  On Error GoTo ControlError
    
  pInitTagVector
    
  For i = 1 To m_oData.Rows
      
    pOpenRowTag
      
    For j = 1 To m_oData.Columns
      If m_oData.ColumnVisible(j) Then
        pPrintCell m_oData.Cell(i, j).Text, j
      End If
    Next j
    
#If Not PREPROC_WEBREPORT Then
    If m_ShowDialog Then
      m_fExportToExcel.ShowPercent pGetPercent(i) * 100
      DoEvents
      If m_Cancel Then Exit Function
    End If
#End If

    pCloseRowTag

    RaiseEvent ChangeComplete(bCancel, pGetPercent(i))
    If bCancel Then Exit Function

  Next i
    
  pExportGrid = True
  Exit Function
ControlError:
  MngError_ Err, "pExportGrid", C_Module, ""
End Function

Private Function pExportGridAdvanced() As Boolean
  Dim i As Long
  Dim j As Integer
  Dim bCancel As Boolean
  
  On Error GoTo ControlError
    
  For i = 1 To m_oData.Rows
    
    pOpenRowTag
    
    For j = 1 To m_oData.Columns.Count
      If m_oData.Columns(j).Visible Then
        pPrintCell m_oData.Cell(i, j).Text, j
      End If
    Next j
    
#If Not PREPROC_WEBREPORT Then
    If m_ShowDialog Then
      m_fExportToExcel.ShowPercent pGetPercent(i) * 100
      DoEvents
      If m_Cancel Then Exit Function
    End If
#End If
    
    pCloseRowTag
    
    RaiseEvent ChangeComplete(bCancel, pGetPercent(i))
    If bCancel Then Exit Function
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
  
  For i = LBound(m_vData, 1) To UBound(m_vData, 1)
  
    pOpenRowTag
    
    For j = LBound(m_vData, 2) To UBound(m_vData, 2)
      pPrintCell m_vData(i, j), i
    Next j
    
#If Not PREPROC_WEBREPORT Then
    If m_ShowDialog Then
      m_fExportToExcel.ShowPercent pGetPercent(i) * 100
      DoEvents
      If m_Cancel Then Exit Function
    End If
#End If
    
    pCloseRowTag
    
    RaiseEvent ChangeComplete(bCancel, pGetPercent(i))
    If bCancel Then Exit Function
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
  
    pOpenRowTag
  
    pPrintCell m_vData(i), 0
    
#If Not PREPROC_WEBREPORT Then
    If m_ShowDialog Then
      m_fExportToExcel.ShowPercent pGetPercent(i) * 100
      DoEvents
      If m_Cancel Then Exit Function
    End If
#End If
    
    pCloseRowTag
    
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
  Dim j As Long
  Dim bCancel As Boolean
  On Error GoTo ControlError
  
  While Not m_oData.EOF
    
    pOpenRowTag
    j = 0
    For Each Col In m_oData.Fields
      j = j + 1
      pPrintCell Col.Value, j
    Next
    
    i = i + 1
    
#If Not PREPROC_WEBREPORT Then
    If m_ShowDialog Then
      m_fExportToExcel.ShowPercent pGetPercent(i) * 100
      DoEvents
      If m_Cancel Then Exit Function
    End If
#End If

    pCloseRowTag

    RaiseEvent ChangeComplete(bCancel, pGetPercent(i))
    If bCancel Then Exit Function
    m_oData.MoveNext
  Wend
  
  pExportRs = True
  Exit Function
ControlError:
  MngError_ Err, "pExportRs", C_Module, ""
End Function

' Print in Sheet
Private Function pPrintCell(ByVal vValor As Variant, ByVal ColIndex As Long) As Boolean
  On Error GoTo ControlError
  
  Dim Value As String
  
  If IsNull(vValor) Then
    Value = "NULL"
  Else
    If IsDate(vValor) And Not IsNumeric(vValor) Then
      If Len(vValor) > 10 Then
        Value = Format(vValor, "mm/dd/yyyy hh:nn:ss")
      Else
        Value = Format(DateValue(vValor), "mm/dd/yyyy")
      End If
    Else
      Value = Replace(vValor, vbCrLf, vbLf)
    End If
  End If
    
  Dim tag As String
  tag = pGetTagAux(ColIndex)
  
  If LenB(tag) <> 0 Then

    Print #m_xmlFile, "<" & tag & ">" & Value & "</" & tag & ">"
  
  End If
  
  pPrintCell = True
  Exit Function
ControlError:
  MngError_ Err, "pPrintCell", C_Module, ""
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_oData = Nothing
  ReDim m_vTags(0)
  
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

Private Function pOpenXml() As Boolean
  m_xmlFile = FreeFile
  Open m_strFile For Append Access Write As #m_xmlFile
  Print #m_xmlFile, m_strXmlHeader
  pOpenXml = True
End Function

Private Function pCloseXml() As Boolean
  If m_xmlFile Then
    Print #m_xmlFile, m_strXmlFooter
    Close m_xmlFile
    m_xmlFile = 0
  End If
  pCloseXml = True
End Function

Private Function pGetTagAux(ByVal ColIndex As Long) As String
  If ColIndex <= UBound(m_vTags) Then
    pGetTagAux = m_vTags(ColIndex)
  End If
End Function

Private Function pInitTagVector()
    
  ReDim m_vTags(0)
  m_rowTag = pGetTag(Mid$(c_RowTag, 2))

  Select Case m_DataType
    Case dblExGrid
      pInitTagVectorGrid
    Case dblExGridAdvanced
      pInitTagVectorGrid
    Case dblExMatrix
      pInitTagVectorMatrix
    Case dblArray
      ' Nada que hacer
    Case dblExRecordsetDao
      pInitTagVectorRs
    Case dblExRecordsetAdo
      pInitTagVectorRs
  End Select

End Function

Private Sub pInitTagVectorGrid()
  Dim j As Long
  ReDim m_vTags(m_oData.Columns)
  For j = 1 To m_oData.Columns
    m_vTags(j) = pGetTag(m_oData.ColumnHeader(j))
  Next j
End Sub

Private Sub pInitTagVectorMatrix()
  Dim j As Long
  ReDim m_vTags(UBound(m_vData, 1))
  For j = LBound(m_vData, 1) To UBound(m_vData, 1)
    m_vTags(j) = pGetTag(m_vData(1, j))
  Next j
End Sub

Private Sub pInitTagVectorRs()
  Dim Col As Object
  Dim i   As Long
  ReDim m_vTags(m_oData.Fields.Count)
  For Each Col In m_oData.Fields
    i = i + 1
    m_vTags(i) = pGetTag(Col.Name)
  Next
End Sub

Private Function pGetTag(ByVal ColName As String) As String
  Dim i       As Long
  Dim tag_id  As String
  Dim end_tag As Long
  
  tag_id = "@" & LCase$(ColName) & "="
  
  i = InStr(1, LCase$(m_str_def_XmlRow), tag_id)
  If i Then
    i = i + Len(tag_id)
    end_tag = InStr(i, LCase$(m_str_def_XmlRow), vbCrLf)
    If end_tag = 0 Then
      end_tag = Len(m_str_def_XmlRow) - i
    Else
      end_tag = end_tag - i
    End If
    
    If end_tag > 0 Then
      pGetTag = Mid$(m_str_def_XmlRow, i, end_tag)
    End If
  End If
End Function

Private Sub pOpenRowTag()
  Print #m_xmlFile, "<" & m_rowTag & ">"
End Sub

Private Sub pCloseRowTag()
  Print #m_xmlFile, "</" & m_rowTag & ">"
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

