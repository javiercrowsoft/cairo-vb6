VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportPrint"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportPrint
' 08-11-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' interfaces
Implements CSIReportPrint.cIReportPrint

' constantes
Private Const C_Module As String = "cReportPrint"

Public Enum csEMoveTo
  C_FirstPage = 1
  C_NextPage = -1
  C_PreviousPage = -2
  C_LastPage = -3
End Enum

Public Enum csPDFQuality
  PDFQualityFull = 1
  PDFQualitySmall = 2
  PDFQualityMedium = 3
End Enum

Private Const c_OffSetHeader = 0
Private Const c_OffSetDetail = 100000
Private Const c_OffSetFooter = 1000000

' estructuras
' variables privadas
Private m_Report                As cReport
Private m_Paint                 As cReportPaint
Private WithEvents m_rpwPrint   As CSReportPreview.cReportPreview
Attribute m_rpwPrint.VB_VarHelpID = -1
Private WithEvents m_fPreview   As fPreview
Attribute m_fPreview.VB_VarHelpID = -1

Private m_LastIndexField        As Long

Private m_CurrPage              As Integer

Private m_Fnt()                 As StdFont
Private m_hFnt()                As Long
Private m_iFontCount            As Long

Private m_hDC As Long

Private m_X As Long
Private m_Y As Long

Private m_RePaintObject  As Boolean

Private m_RealWidth     As Long
Private m_RealHeight    As Long
Private m_ScaleFont     As Single

Private m_ScaleY        As Single
Private m_ScaleX        As Single

Private m_bModal        As Boolean

Private m_bHidePreviewWindow As Boolean

Private m_bIsForExportToPDF As Boolean
Private m_fileToSavePDF     As String
Private m_PDFQuality        As csPDFQuality

Private m_ExportFileName    As String

' eventos

Public Event MouseDownOnField(ByVal IndexField As Long, ByVal Button As Integer, ByVal Shift As Integer, ByRef Cancel As Boolean, ByVal x As Single, ByVal y As Single)
Public Event MouseDownOnLine(ByVal Id As Long)

Public Event MouseOnField(ByVal IndexField As Long)
Public Event MouseOutField()

Public Event ClickOnField(ByVal IndexField As Long)
Public Event ClickOnLine(ByVal Id As Long)

Public Event DblClickOnField(ByVal IndexField As Long)
Public Event DblClickOnLine(ByVal Id As Long)

' propiedades publicas

'---------------------------------------------------------------------------
'
' Exportacion a PDF

' Estas son para cExportPDF
'
  
  Public Property Get IsForExportToPDF() As Boolean
    IsForExportToPDF = m_bIsForExportToPDF
  End Property
  
  Public Property Let IsForExportToPDF(ByRef rhs As Boolean)
    m_bIsForExportToPDF = rhs
  End Property
  
  Public Property Get FileToSavePDF() As String
    FileToSavePDF = m_fileToSavePDF
  End Property
  
  Public Property Let FileToSavePDF(ByRef rhs As String)
    m_fileToSavePDF = rhs
  End Property
  
  Public Property Get PDFQuality() As csPDFQuality
    PDFQuality = m_PDFQuality
  End Property
  
  Public Property Let PDFQuality(ByRef rhs As csPDFQuality)
    m_PDFQuality = rhs
  End Property

' Estas son para cPrintManager
'
  Public Property Get ExportFileName() As String
    ExportFileName = m_ExportFileName
  End Property
  
  Public Property Let ExportFileName(ByRef rhs As String)
    m_ExportFileName = rhs
  End Property

'
'---------------------------------------------------------------------------

Public Property Get Report() As cReport
  Set Report = m_Report
End Property

Public Property Set PreviewControl(ByRef rhs As Object)
  Set m_rpwPrint = rhs
End Property

Public Property Get CurrPage() As Integer
  CurrPage = m_CurrPage
End Property

Public Property Let CurrPage(ByVal rhs As Integer)
  m_CurrPage = rhs
End Property

Public Property Let Modal(ByVal rhs As Boolean)
  m_bModal = rhs
End Property

Public Property Let HidePreviewWindow(ByVal rhs As Boolean)
  m_bHidePreviewWindow = rhs
End Property

' propiedades privadas
Private Property Set Report(ByRef rhs As cReport)
  Set m_Report = rhs
End Property

' funciones publicas
Public Function ClosePreviewWindow() As Boolean
  On Error GoTo ControlError

  If Not m_fPreview Is Nothing Then
    Unload m_fPreview
    Set m_fPreview = Nothing
  End If
  ClosePreviewWindow = True

  GoTo ExitProc
ControlError:
  MngError Err, "ClosePreviewWindow", C_Module, vbNullString
ExitProc:
End Function

Public Function GetLine(ByVal IndexField As Long) As cReportPageFields
  Dim IndexLine As Long
  
  Dim Fld As cReportPageField
  Set Fld = GetField(IndexField)
  
  If Fld Is Nothing Then Exit Function
  
  With m_Report.Pages.Item(m_CurrPage)
    If IndexField < c_OffSetDetail Then
      Set GetLine = pGetLineAux(Fld.IndexLine, .Header)
    ElseIf IndexField < c_OffSetFooter Then
      Set GetLine = pGetLineAux(Fld.IndexLine, .Detail)
    Else
      Set GetLine = pGetLineAux(Fld.IndexLine, .Footer)
    End If
  End With
End Function

Public Function GetCtrlFooter(ByVal CtrlName As String) As cReportPageField
  Set GetCtrlFooter = GetFieldByCtrlName( _
                              CtrlName, _
                              m_Report.Pages.Item(m_CurrPage).Footer _
                                        )
End Function

Public Function GetIndexFieldByName(ByVal CtrlName As String) As Long
  GetIndexFieldByName = m_Paint.PaintObjects(CtrlName).IndexField
End Function

Public Sub RefreshCtrl(ByVal IndexField As Long)
  Dim PaintObj As cReportPaintObject
  Dim Fld      As cReportPageField
  Dim Page     As cReportPage
  
  Set Page = m_Report.Pages.Item(m_CurrPage)
  
  If IndexField < c_OffSetDetail Then
    If Not pGetFieldFromIndexAux(Page.Header, IndexField, Fld) Then Exit Sub
  ElseIf IndexField < c_OffSetFooter Then
    If Not pGetFieldFromIndexAux(Page.Detail, IndexField - c_OffSetDetail, Fld) Then Exit Sub
  Else
    If Not pGetFieldFromIndexAux(Page.Footer, IndexField - c_OffSetFooter, Fld) Then Exit Sub
  End If
  
  Set PaintObj = pGetPaintObjByIndex(IndexField)
  
  #If Not PREPROC_SFS Then
    Dim CtrlFont As CSReportDll2.cReportFont
  #Else
    Dim CtrlFont As CSReportTDll.cReportFont
  #End If
  Set CtrlFont = Fld.Info.Aspect.Font
  
  With PaintObj.Aspect
    With .Font
      .ForeColor = CtrlFont.ForeColor
      .Bold = CtrlFont.Bold
      .Italic = CtrlFont.Italic
      .Name = CtrlFont.Name
      .Size = CtrlFont.Size
      .Strike = CtrlFont.Strike
      .UnderLine = CtrlFont.UnderLine
    End With
  End With
  
  m_Paint.RefreshObject PaintObj.Key, m_rpwPrint.body.hDC, m_rpwPrint.body
End Sub

Public Sub RefreshCtrlFooter(ByVal CtrlName As String)
  Dim PaintObj As cReportPaintObject
  Set PaintObj = pGetPaintObjByCtrlName(CtrlName, m_Report.Pages.Item(m_CurrPage).Footer, c_OffSetFooter)
  PaintObj.Text = GetCtrlFooter(CtrlName).Value
  m_Paint.RefreshObject PaintObj.Key, m_rpwPrint.body.hDC, m_rpwPrint.body
End Sub

Public Function GetFieldByCtrlName(ByVal CtrlName As String, _
                                   ByRef Fields As cReportPageFields, _
                                   Optional ByVal IndexField As Long) As cReportPageField
  Dim Fld As cReportPageField
  
  For Each Fld In Fields
    If Fld.Info.Name = CtrlName Then
      If IsInThisLine(CtrlName, IndexField, Fld) Then
        Set GetFieldByCtrlName = Fld
        Exit Function
      End If
    End If
  Next
End Function

Public Function GetPaintObjByCtrlNameEx(ByVal CtrlName As String, _
                                        Optional ByVal IndexField As Long) As cReportPaintObject
  
  Dim Fld As cReportPageField
  Dim rtn As cReportPaintObject
  Dim Fields As cReportPageFields
  Dim Offset As Long
  
  With m_Report.Pages.Item(m_CurrPage)
    
    Set Fields = .Header
    Offset = c_OffSetHeader
    Set Fld = GetFieldByCtrlName(CtrlName, Fields, IndexField)
    
    If Fld Is Nothing Then
      
      Set Fields = .Detail
      Offset = c_OffSetDetail
      Set Fld = GetFieldByCtrlName(CtrlName, Fields, IndexField)
      
      If Fld Is Nothing Then
      
        Set Fields = .Footer
        Offset = c_OffSetFooter
        Set Fld = GetFieldByCtrlName(CtrlName, Fields, IndexField)
        If Fld Is Nothing Then Exit Function
      End If
    End If
  End With
  
  For Each rtn In m_Paint.PaintObjects
    If Fields(rtn.IndexField - Offset) Is Fld Then
      
      If IsInThisLine(CtrlName, IndexField, Fld) Then
      
        Set GetPaintObjByCtrlNameEx = rtn
        Exit Function
      End If
    End If
  Next
End Function

Public Function IsInThisLine(ByVal CtrlName As String, _
                             ByVal IndexField As Long, _
                             ByRef testFld As cReportPageField) As Boolean
                             
  Dim Fields  As cReportPageFields
  Dim Fld     As cReportPageField
  
  If IndexField = 0 Then
    IsInThisLine = True
    Exit Function
  End If
  
  Set Fields = GetLine(IndexField)
  
  For Each Fld In Fields
    If Fld.Info.Name = CtrlName Then
      If testFld Is Fld Then
        IsInThisLine = True
        Exit Function
      End If
    End If
  Next

End Function

Public Function GetField(ByVal IndexField As Long) As cReportPageField
  Dim rtn  As cReportPageField
  Dim Page As cReportPage
  
  Set Page = m_Report.Pages.Item(m_CurrPage)
  
  If IndexField < c_OffSetDetail Then
    If Not pGetFieldFromIndexAux(Page.Header, IndexField, rtn) Then Exit Function
  ElseIf IndexField < c_OffSetFooter Then
    If Not pGetFieldFromIndexAux(Page.Detail, IndexField - c_OffSetDetail, rtn) Then Exit Function
  Else
    If Not pGetFieldFromIndexAux(Page.Footer, IndexField - c_OffSetFooter, rtn) Then Exit Function
  End If
  Set GetField = rtn
End Function

Public Function FieldIsInDetail(ByVal IndexField As Long) As Boolean
  FieldIsInDetail = IndexField >= c_OffSetDetail And IndexField < c_OffSetFooter
End Function

Public Sub PrintPage(ByVal nPage As csEMoveTo, Optional ByVal InPrinter As Boolean = False)
  'Dim Page As CSReportDll2.cReportPage
  Dim Page As cReportPage
  
  Dim Mouse As New CSKernelClient2.cMouseWait

  m_RePaintObject = True

  With m_Report
    Select Case nPage
      Case Is > 1, C_FirstPage
        m_CurrPage = nPage
      Case C_LastPage
        m_CurrPage = .Pages.Count
      Case C_NextPage
        If m_CurrPage + 1 <= .Pages.Count Then
          m_CurrPage = m_CurrPage + 1
        Else
          m_CurrPage = .Pages.Count
        End If
      Case C_PreviousPage
        If m_CurrPage - 1 >= 1 Then
          m_CurrPage = m_CurrPage - 1
        Else
          m_CurrPage = 1
        End If
    End Select

    If m_CurrPage = 0 Then Exit Sub

    Set Page = .Pages.Item(m_CurrPage)

    ' Limpio el objeto de impresion
    m_Paint.PaintObjects.Clear

    ' Cargo la pagina
    CreatePaintObjects Page.Header, c_OffSetHeader
    CreatePaintObjects Page.Detail, c_OffSetDetail
    CreatePaintObjects Page.Footer, c_OffSetFooter
  End With

  If Not InPrinter Then
    ' Seteo la pagina acutal del Preview
    m_rpwPrint.CurrPage = m_CurrPage

    m_rpwPrint.Refresh
  End If
End Sub

Public Function DoPrint(ByRef ObjClient As Object) As Boolean
  DoPrint = pDoPrint(ObjClient)
End Function

' funciones friend

'----------------------------------------------------
' Implementacion de cIReportPrint
Public Function cIReportPrint_MakeReport() As Boolean
  cIReportPrint_MakeReport = Make()
End Function

Public Function cIReportPrint_MakeXml() As Boolean

End Function

Public Function cIReportPrint_PreviewReport() As Boolean
  SetPreviewForm
  
  pCreatePaint
  
  m_rpwPrint.Pages = m_Report.Pages.Count
  PrintPage C_FirstPage
  
  With m_rpwPrint.Parent
  
    If m_bModal Then
      .Show vbModal
    Else
      If Not m_bHidePreviewWindow Then
        .Show
        If .WindowState = vbMinimized Then
          .WindowState = vbNormal
        End If
      End If
    End If
  End With
  
  cIReportPrint_PreviewReport = True
End Function

Public Function cIReportPrint_PrintReport() As Boolean
  cIReportPrint_PrintReport = pDoPrint()
End Function

Private Function pDoPrint(Optional ByRef ObjClient As Object) As Boolean
  On Error GoTo ControlError

100   Dim hwnd    As Long
101   Dim Copies  As Long
102   Dim q       As Long
103
104   Dim pNova As Object
105   Dim activeProfile As String
106   Dim nActiveProfilePublic As Long
107
108   pCreatePaint
109
110   m_RePaintObject = True
111
112   Dim Printer As cPrinter
113
114   ' Si hay que mostrar el dialogo o no se definio la impresora
115   If m_Report.LaunchInfo.Printer Is Nothing Then
116
117     Set Printer = GetcPrinterFromDefaultPrinter()
118
119   ' Uso la impresora que me dieron
120   Else
121     Set Printer = m_Report.LaunchInfo.Printer
122   End If
123
124   With m_Report.LaunchInfo
125     Copies = .Copies
126     If .ShowPrintersDialog Then
127       If m_fPreview Is Nothing Then
128         hwnd = .hwnd
129       Else
130         hwnd = m_fPreview.hwnd
131       End If
132       Printer.Copies = Copies
133       If Not Printer.ShowDialog(hwnd, m_Report.Pages.Count) Then GoTo ExitProc
134       Copies = Printer.Copies
135     Else
136       Printer.PaperInfo.PagesToPrint = "1-" & m_Report.Pages.Count
137     End If
138   End With
139
140   If m_bIsForExportToPDF Then
141     If IsPDFPrinter(Printer.DeviceName) Then
142       InitPDFPrinter pNova, activeProfile, nActiveProfilePublic, m_fileToSavePDF, m_PDFQuality
143     End If
144   End If
145
146   For q = 1 To Copies
147     If Not PrintPagesToPrinter(Printer, ObjClient) Then GoTo ExitProc
148   Next
149
150   If m_bIsForExportToPDF Then
151     If IsPDFPrinter(Printer.DeviceName) Then
152       ClosePDFPrinter pNova, activeProfile, nActiveProfilePublic
153     End If
154   End If
155
156   pDoPrint = True
157
158 ExitProc:
159   If Not m_rpwPrint Is Nothing Then
160     PrintPage m_CurrPage
161     m_rpwPrint.Refresh
162   End If
163
164   m_bIsForExportToPDF = False
  
  GoTo ExitProc2
ControlError:
  MngError Err, "pDoPrint", C_Module, "Linea: " & Erl
  If Err.Number Then Resume ExitProc
ExitProc2:
  On Error Resume Next
  
End Function

' --------------------------------------------------------------
' Por ahora solo refresca el Font para no hacer muy extensa
' la funcion
'
Private Function pGetPaintObjByIndex(ByVal IndexField As Long) As cReportPaintObject
  Dim rtn As cReportPaintObject
  
  For Each rtn In m_Paint.PaintObjects
    
    If rtn.IndexField = IndexField Then
      Set pGetPaintObjByIndex = rtn
      Exit Function
    End If
  Next
End Function

Private Function pGetPaintObjByCtrlName(ByVal CtrlName As String, _
                                        ByRef Fields As cReportPageFields, _
                                        ByVal Offset As Long) As cReportPaintObject
  Dim Fld As cReportPageField
  Dim rtn As cReportPaintObject
  
  Set Fld = GetFieldByCtrlName(CtrlName, Fields)
  
  For Each rtn In m_Paint.PaintObjects
    If Fields(rtn.IndexField - Offset) Is Fld Then
      Set pGetPaintObjByCtrlName = rtn
      Exit Function
    End If
  Next
End Function

Private Sub pCreatePaint()
  If m_Paint Is Nothing Then
    Set m_Paint = New cReportPaint
  End If
  m_Paint.NotBorder = True
End Sub

Private Function PrintPagesToPrinter(ByRef Printer As cPrinter, _
                                     Optional ByRef ObjClient As Object) As Boolean
  On Error GoTo ControlError
  
  Dim i         As Long
  Dim vPages()  As Long
  Dim dpiX      As Long
  Dim dpiY      As Long
  Dim oldZoom   As Long
  Dim oldScaleY      As Single
  Dim oldScaleX      As Single
  Dim oldScaleFont   As Single
  
  With m_Report.PaperInfo
    If Not Printer.StarDoc(m_Report.Name, .PaperSize, .Orientation) Then GoTo ControlError
  End With
  
  vPages = pGetPagesToPrint(Printer.PaperInfo.PagesToPrint)
  
  oldScaleX = m_Paint.ScaleX
  oldScaleY = m_Paint.ScaleY
  oldScaleFont = m_ScaleFont
  oldZoom = m_Paint.Zoom
  
  dpiX = GetDeviceCaps(Printer.hDC, LOGPIXELSX)
  dpiY = GetDeviceCaps(Printer.hDC, LOGPIXELSY)
  
  m_ScaleX = dpiX / 100
  m_ScaleY = dpiY / 100
  
  Dim DPI As Integer
  DPI = 1440 / Screen.TwipsPerPixelX
  
  If DPI <> 96 And DPI > 0 Then
    m_ScaleX = m_ScaleX * (96 / DPI)
    m_ScaleY = m_ScaleY * (96 / DPI)
  End If
  
  m_Paint.ScaleX = m_ScaleX
  m_Paint.ScaleY = m_ScaleY
  
  m_Paint.Zoom = 100
  m_ScaleFont = 1
  

  For i = 1 To m_Report.Pages.Count
    If pHaveToPrintThisPage(i, vPages) Then
      If Not Printer.StarPage Then GoTo ControlError2
      
      PrintPage i, True
      
      If Not DrawPage(Printer) Then GoTo ExitProc
      If Not Printer.EndPage Then GoTo ControlError2
      
      If Not pRefreshObjClient(i, ObjClient) Then GoTo ExitProc
    End If
  Next
  
  If Not Printer.EndDoc Then GoTo ControlError2
  
  PrintPagesToPrinter = True
  GoTo ExitProc
ControlError2:
  Err.Raise vbObjectError + 20, "CSReportPaint", "Ocurrio un error al imprimir el reporte. Número de error: " & Err.LastDllError
ControlError:
  MngError Err, "PrintPagePrinter", C_Module, vbNullString
ExitProc:
  Printer.EndDoc
  m_Paint.Zoom = oldZoom
  m_ScaleX = oldScaleX
  m_ScaleY = oldScaleY
  m_Paint.ScaleX = oldScaleX
  m_Paint.ScaleY = oldScaleY
  m_ScaleFont = oldScaleFont
End Function

Private Function pRefreshObjClient(ByVal iPage As Long, ByRef ObjClient As Object) As Boolean
  On Error Resume Next
  pRefreshObjClient = True
  If ObjClient Is Nothing Then Exit Function
  pRefreshObjClient = ObjClient.PrintingPage(iPage)
End Function

Private Function pHaveToPrintThisPage(ByVal Page As Long, ByRef v() As Long) As Boolean
  Dim n As Long
  
  For n = 1 To UBound(v)
    If Page = v(n) Then
      pHaveToPrintThisPage = True
      Exit Function
    End If
  Next
End Function

Private Function pGetPagesToPrint(ByVal PagesToPrint As String) As Variant
  Dim v()  As String
  Dim i    As Long
  Dim n()  As Long
  Dim k    As Long
  Dim v2() As String
  Dim t    As Long
  Dim r    As Long
  Dim AddInterval As Boolean
  
  v = Split(PagesToPrint, ",")
  
  ReDim n(0)
  
  For i = 0 To UBound(v)
    k = InStr(1, v(i), "-")
    If k > 0 Then
      v2 = Split(v(i), "-")
      AddInterval = False
      For t = 0 To UBound(v2)
        If IsNumeric(v2(t)) Then
          
          If AddInterval Then
          
            For r = n(UBound(n)) + 1 To v2(t) - 1
              ReDim Preserve n(UBound(n) + 1)
              n(UBound(n)) = r
            Next
            
          Else
            AddInterval = True
          End If
          
          ReDim Preserve n(UBound(n) + 1)
          n(UBound(n)) = v2(t)
        End If
      Next
    Else
      If IsNumeric(v(i)) Then
        ReDim Preserve n(UBound(n) + 1)
        n(UBound(n)) = v(i)
      End If
    End If
  Next
  
  
  pGetPagesToPrint = n
End Function

Private Property Set cIReportPrint_Report(rhs As Object)
  Set m_Report = rhs
End Property

' funciones privadas
Private Function pGetLineAux(ByVal IndexLine As Long, _
                             ByRef Fields As cReportPageFields) As cReportPageFields
  
  Dim rtn As cReportPageFields
  Dim Fld As cReportPageField
  
  Set rtn = New cReportPageFields
  
  For Each Fld In Fields
    If Fld.IndexLine = IndexLine Then rtn.Add Fld
  Next
  
  Set pGetLineAux = rtn
End Function

Private Function Make() As Boolean
  Dim DetailHeight  As Single
  Dim LineHeight    As Single
  
  Dim Fields        As cReportPageFields
  Dim Field         As cReportPageField
  Dim Detail        As cReportPageFields
  
  Dim Rslt          As csRptGetLineResult
  Dim RsltNewPage   As csRptNewPageResult
  Dim RsltEndPage   As csRptEndPageResult
  Dim Top           As Single
  Dim TopSection    As Single
  Dim TopSectionLn  As Single
  Dim HeightSection As Single
  Dim SecLnIndex    As Long
  Dim OffsetTop()   As Single
  Dim vdummy()      As Single

  Dim Mouse As CSKernelClient2.cMouseWait
  Set Mouse = New CSKernelClient2.cMouseWait
  
  With m_Report
    PrinterSetSizeAndOrient .LaunchInfo.Printer.DeviceName, _
                            .PaperInfo.PaperSize, _
                            .PaperInfo.Orientation
  End With
  
  m_CurrPage = 0

  With m_Report
    
    ' Creo la primera pagina
    '
    RsltNewPage = .NewPage()
    
    ' Si dio un error
    '
    If RsltNewPage = csRptNewPageResult.csRptNPError Then Exit Function
    
    ' Si no hay datos
    '
    If RsltNewPage = csRptNewPageResult.csRptNPEnd Then GoTo EndProc

'///////////////////////////////////////////////////
'
' OJO: ANTE CUALQUIER REPORTE QUE NO ANDE
'      ASUMIR QUE ESTE ES EL SOSPECHOSO
'      DE SIEMPRE
'
    ' Evaluacion de la primera linea del
    ' detalle or group header solo si no
    ' hay grupos
    '
    If .Groups.Count = 0 Then
      .EvalPreGroupHeader
      .EvalPre
    End If
'
'///////////////////////////////////////////////////

    ' Calculo las dimensiones del detail
    '
    DetailHeight = GetDetailHeight(.Pages.Item(.Pages.Count), Top)
    
    ' Le doy la altura a los controles de imagenes que pueden crecer
    ' y estan en el header
    '
    GetLineHeight .Pages.Item(.Pages.Count).Header, vdummy

    Do
    
      ' Obtengo la linea
      '
      Rslt = .GetLine(Fields)

      ' Si se termino
      '
      If Rslt = csRptGetLineResult.csRptGLEnd Then Exit Do
      
      ' Si la fila es virtual tengo que llamar al motor
      ' para darle una oportunidad de evalur formulas
      ' en el header que se compilan antes de imprimir
      '
      If Rslt = csRptGetLineResult.csRptGLVirtualH Then
      
        .EvalPreGroupHeader
      
      ' Idem pero para Footers
      '
      ElseIf Rslt = csRptGetLineResult.csRptGLVirtualF Then
      
        .EvalPreGroupFooter
      
      ' Si el motor me informa que debo crear una nueva pagina
      '
      ElseIf Rslt = csRptGetLineResult.csRptGLNewPage Then
          
        ' Obtengo la nueva pagina
        '
        If Not pNewPage(Top, DetailHeight) Then Exit Function
        
      Else
  
        ' Calculo el alto de la linea
        '
        LineHeight = GetLineHeight(Fields, OffsetTop())
  
        ' Si no entra genero una nueva pagina
        '
        If LineHeight > DetailHeight Then
  
          ' Pido una nueva pagina
          '
          If Not pNewPage(Top, DetailHeight) Then Exit Function
          
        Else
        
          HeightSection = 0
          TopSection = 0
          TopSectionLn = 0
          SecLnIndex = 0
          
          '---------------------------------------------------------------------------------
          ' Este bloque no esta en una funcion para obtener una mayor velocidad
          '
          ' Agrego la linea a la pagina
          '
          
          Set Detail = .Pages.Item(.Pages.Count).Detail
          
          For Each Field In Fields
            
            ' Obtengo el Top para este field segun su seccion
            '
            With Field.Info.SectionLine
              
              ' Lo hago una vez por seccion
              '
              If SecLnIndex <> .Indice Then
                SecLnIndex = .Indice
                With .Aspect
                  TopSection = TopSection + (.Top - (TopSection + HeightSection))
                  HeightSection = HeightSection + .Height
                End With
              End If
            End With
            
            ' Al Top del control en diseño lo reubico en la seccion Detalle.
            '
            With Field
              .Top = Top + OffsetTop(SecLnIndex) + (.Info.Aspect.Top - TopSection)
            End With
            
            Detail.Add Field
            
          Next Field
          '---------------------------------------------------------------------------------
  
          ' Le resto esta linea
          '
          Top = Top + LineHeight
          DetailHeight = DetailHeight - LineHeight
          
          ' Informo al reporte el estado de los grupos
          '
          If Rslt = csRptGLGroupHeader Then
            .MarkGroupHeaderPrinted
            
            ' Evaluo las funciones que se compilan despues de imprimir
            '
            .EvalPostGroupHeader
            
          ElseIf Rslt = csRptGLGroupFooter Then
            .MarkGroupFooterPrinted
            
            ' Evaluo las funciones que se compilan despues de imprimir
            '
            .EvalPostGroupFooter
          
          ElseIf Rslt = csRptGLDetail Then
            .EvalPost
            .MoveToNext
          End If
          
          If .GetLineType() = csRptGLDetail Then
            .EvalPre
          End If
        End If
      End If
    Loop
  End With

EndProc:
  RsltEndPage = m_Report.EndPage()
  If RsltEndPage = csRptEndPageResult.csRptEPError Then Exit Function

  Make = True
End Function

Private Function pNewPage(ByRef Top As Single, ByRef DetailHeight As Single) As Boolean
  Dim RsltNewPage As csRptNewPageResult
  Dim RsltEndPage As csRptEndPageResult
  
  With m_Report
    RsltEndPage = .EndPage()
    If RsltEndPage = csRptEndPageResult.csRptEPError Then Exit Function
  
    RsltNewPage = .NewPage()
    If RsltNewPage = csRptNewPageResult.csRptNPError Then Exit Function
  
    ' Calculo las dimensiones del detail
    DetailHeight = GetDetailHeight(.Pages.Item(.Pages.Count), Top)
  End With
  
  pNewPage = True
End Function

' Devuelve el alto del detail para la
' pagina recibida
Private Function GetDetailHeight(ByRef Page As cReportPage, ByRef Top As Single) As Single
  Top = Page.HeaderBottom
  GetDetailHeight = Page.FooterTop - Top
End Function

' Devuelve el Height mas grande y ademas define el Height de cada control
Private Function GetLineHeight(ByRef Fields As cReportPageFields, _
                               ByRef OffsetTop() As Single) As Single
  Dim Field         As cReportPageField
  Dim OffBottom     As Single
  Dim AspectHeight  As Long
  Dim AspectWidth   As Long

  #If Not PREPROC_SFS Then
    Dim Aspect      As CSReportDll2.cReportAspect
    Dim AspectLn    As CSReportDll2.cReportAspect
  #Else
    Dim Aspect      As CSReportTDll.cReportAspect
    Dim AspectLn    As CSReportTDll.cReportAspect
  #End If
  Dim LnHeight        As Single ' Este se usa para obtener el offset al top
  Dim LnHeight2       As Single ' Este se usa para agrandar el alto del renglon
  Dim NewLnHeight     As Single

  Dim oFont As StdFont
  Set oFont = New StdFont
  
  Dim TopSection As Single
  Dim IndexSection As Single
  Dim HeightSection As Single
  
  ReDim OffsetTop(0)
  
  If Fields.Count > 0 Then

    ' Busco el Field mas alto
    For Each Field In Fields
      With Field
        ' Si puede crecer tengo que calcular cuanto debe
        ' ser su alto para poder imprimirlo
        Set Aspect = .Info.Aspect
        Set AspectLn = .Info.SectionLine.Aspect
        
        ' Si cambie de renglon obtengo el alto del nuevo renglon y lo
        ' agrego al acumulado (HeightSection)
        If IndexSection <> .Info.SectionLine.Indice Then
          
          ' Guardo en que seccion estoy
          IndexSection = .Info.SectionLine.Indice
          
          If UBound(OffsetTop) < IndexSection Then
          
            ReDim Preserve OffsetTop(IndexSection)
          
          End If
          
          ' Guardo el desplazamiento para agregarselo al top de todos
          ' los controles que pertenescan a sectionlines que estan
          ' debajo de esta sectionline
          OffsetTop(IndexSection) = OffsetTop(IndexSection) + NewLnHeight - LnHeight
          
          ' Obtengo el top del renglon actual que incluye
          ' solo el alto de los renglones visibles
          TopSection = TopSection + (AspectLn.Top - (TopSection + HeightSection))
          
          ' Agrego al acumulado el alto de este renglon
          HeightSection = HeightSection + AspectLn.Height
          
          ' Guardo el alto del renglon para saber si cambia por CanGrow
          LnHeight = AspectLn.Height
          
          ' Alto original del section line
          LnHeight2 = LnHeight
          
          ' Almaceno el alto del renglon para analizar CanGrow
          NewLnHeight = LnHeight
        End If
        
        ' Agrego a cada control el Offset que producen los controles
        ' que pueden crecer
        If Aspect.CanGrow Then
          
          AspectHeight = Aspect.Height
          AspectWidth = Aspect.Width
        
          ' Si hay una imagen obtengo su alto
          '
          If .hImage <> 0 Then
          
            Dim imgWidth  As Long
            Dim imgHeight As Long
          
            GetBitmapSize .hImage, imgWidth, imgHeight, True
          
            .Height = imgHeight
            .Width = imgWidth
            
            If .Height < AspectHeight Then .Height = AspectHeight
            If .Width < AspectWidth Then .Width = AspectWidth
          Else
            If LenB(.Value) > 0 Then
              Dim Flags As Long
            
              If Aspect.WordWrap Then
                Flags = DT_WORDBREAK Or DT_WORD_ELLIPSIS Or DT_LEFT Or DT_NOPREFIX Or DT_EDITCONTROL
              Else
                Flags = DT_SINGLELINE Or DT_WORD_ELLIPSIS Or DT_LEFT Or DT_NOPREFIX
              End If
            
              With Aspect.Font
                oFont.Name = .Name
                oFont.Bold = .Bold
                oFont.Italic = .Italic
                oFont.UnderLine = .UnderLine
                oFont.Size = .Size
              End With
            
              .Height = EvaluateTextHeight(.Value, _
                                           m_hFnt(AddFontIfRequired(oFont, m_hDC, m_iFontCount, m_Fnt, m_hFnt)), _
                                           Aspect.Width, m_hDC, Flags, _
                                           m_ScaleY, m_ScaleX)
              If .Height < AspectHeight Then .Height = AspectHeight
            End If
          End If
          
          ' Si no entra en el renglon agrando el alto del mismo
          If .Height + Aspect.Top > TopSection + NewLnHeight Then
            OffBottom = (TopSection + NewLnHeight) - (Aspect.Top + AspectHeight)
            If OffBottom < 0 Then OffBottom = OffBottom + 80 ' Con esto lo separo un poquito
            
            ' Nuevo alto de renglon
            NewLnHeight = Aspect.Top - TopSection + .Height + OffBottom
          End If
          
          ' Si el alto del renglon anterior cambio por que algun
          ' control soportaba CanGrow y el contenido del control
          ' hizo crecer al renglon, agrego al acumulado la altura correcta
          If NewLnHeight > LnHeight2 Then
          '                                ' Resto la altura original
          '                                          ' Sumo la altura por CanGrow
            HeightSection = HeightSection - LnHeight2 + NewLnHeight
            LnHeight2 = NewLnHeight
          End If
          
        Else
          .Height = Aspect.Height
        End If
      End With
    Next Field
  End If
  
  ' Devuelvo el alto de la seccion
  GetLineHeight = HeightSection
End Function

' Si no me asignaron un objeto de impresion
' uso el propio
Private Sub SetPreviewForm()
  If m_rpwPrint Is Nothing Then
    If m_fPreview Is Nothing Then
      GoTo CreatefPreview
    End If
    GoTo SetfPreview
  Else
    If Not m_rpwPrint.Parent Is Nothing Then
      If TypeOf m_rpwPrint.Parent Is Form Then
        GoTo ShowPreview
      Else
        GoTo CreatefPreview
      End If
    Else
      GoTo CreatefPreview
    End If
  End If
  
CreatefPreview:
  Set m_fPreview = New fPreview
SetfPreview:
  Set m_rpwPrint = m_fPreview.rpwReport
  
ShowPreview:
  
  Dim tR As Rectangle
  
  With m_Report.LaunchInfo.Printer
    tR = GetRectFromPaperSize(.PaperInfo, .PaperInfo.PaperSize, .PaperInfo.Orientation)
  End With
  
  m_RealWidth = tR.Width
  m_RealHeight = tR.Height
  
  m_rpwPrint.body.Width = m_RealWidth
  m_rpwPrint.body.Height = m_RealHeight
  
  If Not m_bModal Then
    If Not m_bHidePreviewWindow Then
      m_rpwPrint.Parent.Show
    End If
  End If
End Sub

Private Sub CreatePaintObjects(ByRef Fields As cReportPageFields, _
                               ByVal Offset As Long)
  Dim Field     As cReportPageField
  
  #If Not PREPROC_SFS Then
    Dim RptAspect As CSReportDll2.cReportAspect
    Dim RptFont   As CSReportDll2.cReportFont
  #Else
    Dim RptAspect As CSReportTDll.cReportAspect
    Dim RptFont   As CSReportTDll.cReportFont
  #End If
  
  Dim Index     As Long
  
  For Each Field In Fields
    Index = Index + 1
    
    'Debug.Print Field.Info.Name
    
    If Field.Visible Then

      Set RptAspect = Field.Info.Aspect

      With m_Paint.PaintObjects.Add()
        With .Aspect
          If Field.Top > 0 Then
            .Top = Field.Top
          Else
            .Top = RptAspect.Top
          End If
          If Field.Height > 0 Then
            .Height = Field.Height
          Else
            .Height = RptAspect.Height
          End If
          If Field.Width > 0 Then
            .Width = Field.Width
          Else
            .Width = RptAspect.Width
          End If
          .Left = RptAspect.Left
          .BackColor = RptAspect.BackColor
          .Transparent = RptAspect.Transparent
          .Align = RptAspect.Align
          .WordWrap = RptAspect.WordWrap
          
          .BorderColor = RptAspect.BorderColor
          .BorderColor3d = RptAspect.BorderColor3d
          .BorderColor3dShadow = RptAspect.BorderColor3dShadow
          .BorderRounded = RptAspect.BorderRounded
          .BorderType = RptAspect.BorderType
          .BorderWidth = RptAspect.BorderWidth
          
          Set RptFont = RptAspect.Font
          With .Font
            .Bold = RptFont.Bold
            .ForeColor = RptFont.ForeColor
            .Italic = RptFont.Italic
            .Name = RptFont.Name
            .Size = RptFont.Size * m_ScaleFont
            .Strike = RptFont.Strike
            .UnderLine = RptFont.UnderLine
          End With
        End With
        
        .Text = Field.Value
        .hImage = Field.hImage
        
        If .hImage <> 0 Then .PaintType = csRptPaintObjImage
        
        .IndexField = Index + Offset
        If Not Field.ObjectID Is Nothing Then
          .Tag = Field.ObjectID.Value
        End If
      End With
    End If
  Next Field
End Sub

Private Sub m_fPreview_FormUnload()
  On Error Resume Next
  
  Set m_rpwPrint = Nothing
  Set m_Report.LaunchInfo.ObjPaint.Report = Nothing
  Set m_Report.LaunchInfo.ObjPaint = Nothing
End Sub

'------------------------------------------------------------------
' Eventos de la interfaz de preview
Private Sub m_rpwPrint_BodyDblClick()
  On Error GoTo ControlError
  
  Dim sKey As String
  
  If m_Paint Is Nothing Then Exit Sub
  If m_Paint.PointIsInObject(m_X, m_Y, sKey) Then
    RaiseEvent DblClickOnField(m_Paint.PaintObjects(sKey).IndexField)
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "m_rpwPrint_BodyDblClick", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetFieldFromIndexAux(ByRef Fields As cReportPageFields, _
                                       ByVal Index As Long, _
                                       ByRef rtn As cReportPageField) As Boolean
  On Error Resume Next
  Err.Clear
  Set rtn = Fields(Index)
  pGetFieldFromIndexAux = Err.Number = 0
End Function


Private Sub m_rpwPrint_BodyMouseDown(ByRef Button As Integer, ByRef Shift As Integer, ByRef x As Single, ByRef y As Single)
  On Error GoTo ControlError
  Dim sKey As String
  
  If m_Paint Is Nothing Then Exit Sub
  
  If m_Paint.PointIsInObject(x, y, sKey) Then
    Dim Index As Long
    Index = m_Paint.PaintObjects(sKey).IndexField
    
    Dim Cancel As Boolean
    RaiseEvent MouseDownOnField(Index, Button, Shift, Cancel, x, y)
    
    If Not Cancel Then
      RaiseEvent ClickOnField(Index)
    End If
  End If
  

  GoTo ExitProc
ControlError:
  MngError Err, "m_rpwPrint_BodyMouseDown", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_rpwPrint_BodyMouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
  On Error GoTo ControlError
  
  Dim sKey        As String
  Dim IndexField  As Long
  
  If m_Paint Is Nothing Then Exit Sub
  
  If m_Paint.PointIsInObject(x, y, sKey) Then
    IndexField = m_Paint.PaintObjects(sKey).IndexField
    If m_LastIndexField <> IndexField Then
      RaiseEvent MouseOnField(IndexField)
      m_LastIndexField = IndexField
    End If
  Else
    If m_LastIndexField Then
      RaiseEvent MouseOutField
      m_LastIndexField = 0
    End If
  End If
  
  m_X = x
  m_Y = y

  GoTo ExitProc
ControlError:
  MngError Err, "m_rpwPrint_BodyMouseMove", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_rpwPrint_BodyPaint()
  If m_Paint Is Nothing Then Exit Sub
  DrawPage m_rpwPrint.body
End Sub

Private Sub m_rpwPrint_ChangeZoom(ByVal Zoom As Long)
  Dim nZoom   As Single
  Dim Width   As Single
  Dim Height  As Single
  
  Select Case Zoom
    Case csEZoom.csEZoomAllPage
      
      Width = m_rpwPrint.ScaleWidth / m_RealWidth
      Height = m_rpwPrint.ScaleHeight / m_RealHeight
      
      If Width < Height Then
        nZoom = m_rpwPrint.ScaleWidth / m_RealWidth
      Else
        nZoom = m_rpwPrint.ScaleHeight / m_RealHeight
      End If
      
    Case csEZoom.csEZoomCustom
      nZoom = 1
    Case csEZoom.csEZoomWidth
      nZoom = m_rpwPrint.ScaleWidth / m_RealWidth
    Case Else
      nZoom = Zoom / 100
  End Select
  
  If nZoom < 0.01 Then nZoom = 0.01
  
  With m_rpwPrint.body
    .Width = m_RealWidth * nZoom
    .Height = m_RealHeight * nZoom
  End With
    
  If nZoom > 0.5 Then
    m_Paint.Zoom = 100
    m_Paint.ScaleX = nZoom
    m_Paint.ScaleY = nZoom
    m_ScaleFont = nZoom
    PrintPage m_CurrPage
  Else
    m_Paint.Zoom = Zoom
    m_rpwPrint.Refresh
  End If
End Sub

Private Sub m_rpwPrint_DoPrint()
  cIReportPrint_PrintReport
End Sub

Private Sub m_rpwPrint_ExportExcel()
  On Error GoTo ControlError

  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents

  Dim expExcel As CSReportExport2.cReportExcel
  Set expExcel = New CSReportExport2.cReportExcel
  
  expExcel.Export m_Report

  GoTo ExitProc
ControlError:
  MngError Err, "m_rpwPrint_ExportExcel", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_rpwPrint_ExportPDF()
  ExportPDF
End Sub

' Files es una lista de archivos separados por |
'
Public Function SendMail(ByVal Files As String, _
                         ByVal EmailAddress As String)
  
  ' Por ahora uso esta clase
  ' despues lo vamos a emprolijar
  ' ya que puedo mandar cualquier archivo con esto
  '
  Dim expPDF As CSReportExport2.cReportPDF
  Set expPDF = New CSReportExport2.cReportPDF
  
  With expPDF
    .ExportEmailAddress = EmailAddress
    SendMail = .SendMail(Files)
  End With
  
End Function

Public Function SendMail2(ByVal Files As String, _
                          ByVal EmailAddress As String, _
                          ByVal subject As String, _
                          ByVal body As String)
  
  ' Por ahora uso esta clase
  ' despues lo vamos a emprolijar
  ' ya que puedo mandar cualquier archivo con esto
  '
  Dim expPDF As CSReportExport2.cReportPDF
  Set expPDF = New CSReportExport2.cReportPDF
  
  With expPDF
    .ExportEmailAddress = EmailAddress
    SendMail2 = .SendMail2(Files, subject, body)
  End With
  
End Function

Public Function ExportPDFEx(ByRef OutputFile As String, _
                            ByVal bShowPDFWindow As Boolean) As Boolean
  ExportPDFEx = pExportPDF(OutputFile, bShowPDFWindow)
End Function

Public Function ExportPDF() As Boolean
  ExportPDF = pExportPDF(vbNullString, True)
End Function

Private Function pGetExportFileName() As String
  If LenB(m_ExportFileName) Then
    pGetExportFileName = m_ExportFileName
  Else
    pGetExportFileName = m_Report.Name
  End If
End Function

Private Function pExportPDF(ByRef OutputFile As String, _
                            ByVal bShowPDFWindow As Boolean) As Boolean
                            
  On Error GoTo ControlError

  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents

  Dim expPDF As CSReportExport2.cReportPDF
  Set expPDF = New CSReportExport2.cReportPDF
  
  With expPDF
    .Filename = GetValidPath(Environ$("TEMP")) & pGetExportFileName() 'm_Report.Name
    .ExportEmailAddress = m_Report.ExportEmailAddress
    
    pExportPDF = .ExportEx(m_Report, Me, OutputFile, bShowPDFWindow)
  End With
  
  GoTo ExitProc
ControlError:
  MngError Err, "pExportPDF", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub m_rpwPrint_ExportWord()
  On Error GoTo ControlError

  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents

  Dim expWord As CSReportExport2.cReportWord
  Set expWord = New CSReportExport2.cReportWord
  
  expWord.Export m_Report

  GoTo ExitProc
ControlError:
  MngError Err, "m_rpwPrint_ExportWord", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_rpwPrint_MoveFirst()
  PrintPage C_FirstPage
End Sub

Private Sub m_rpwPrint_MoveLast()
  PrintPage C_LastPage
End Sub

Private Sub m_rpwPrint_MoveNext()
  PrintPage C_NextPage
End Sub

Private Sub m_rpwPrint_MovePrevious()
  PrintPage C_PreviousPage
End Sub

Private Sub m_rpwPrint_MoveToPage(ByVal Page As Integer)
  PrintPage Page
End Sub

Private Sub m_rpwPrint_SaveDocument()
  'If Not m_Report.SaveData(m_rpwPrint.cmFileSaveDialog) Then Exit Sub
End Sub

Private Function DrawPage(ByRef Graph As Object) As Boolean
  Dim i As Integer

  With m_Paint
    
    If m_RePaintObject Then
      
      .ClearPage Graph
      
      If TypeOf Graph Is cPrinter Then
        For i = 1 To .PaintObjects.Count
  
          If Not .DrawObject(.PaintObjects.GetNextKeyForZOrder(i), Graph.hDC, Graph) Then Exit Function
        Next
  
        For i = 1 To .PaintSections.Count
  
          If Not .DrawSection(.PaintSections.GetNextKeyForZOrder(i), Graph.hDC, Graph) Then Exit Function
        Next
      Else
        m_RePaintObject = False
      End If

    Else
      .PaintPicture Graph
    End If
  End With
  
  DrawPage = True
End Function

Private Sub pDestroyFonts()
  Dim iFnt As Long
  For iFnt = 1 To m_iFontCount
    DeleteObject m_hFnt(iFnt)
  Next iFnt
  
  ReDim m_Fnt(0)
  ReDim m_hFnt(0)
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  On Error Resume Next
  
#If PREPROC_DEBUG Then
  gdbInitInstance C_Module
#End If
  
  ReDim m_Fnt(0)
  ReDim m_hFnt(0)
  m_hDC = CreateCompatibleDC(0)
  m_ScaleFont = 1
  m_ScaleY = 1
  m_ScaleX = 1
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  
  Set m_Report = Nothing
  Set m_Paint = Nothing
  
  If Not m_fPreview Is Nothing Then
    Unload m_fPreview
    Set m_fPreview = Nothing
  End If
  
  Set m_rpwPrint = Nothing
  
  pDestroyFonts
  DeleteObject m_hDC
  
#If PREPROC_DEBUG Then
  gdbTerminateInstance C_Module
#End If
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

