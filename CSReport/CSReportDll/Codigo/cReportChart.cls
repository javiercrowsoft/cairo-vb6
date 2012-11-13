VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportChart"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cReportChart
' 28-06-2005

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cReportChart"

Public Enum csRptChartLineStyle
  None
  Horizontal
  Numbered
  Both
End Enum

Public Enum csRptChartPieThickness
  None = 0
  Wafer = 2
  Thin = 4
  Medium = 8
  Thick = 16
  Thickest = 32
End Enum

Public Enum csRptChartPieDiameter
  Smallest = 50
  Smaller = 100
  Small = 150
  Medium = 200
  Large = 250
  Larger = 350
  Largest = 450
End Enum

Public Enum csRptChartFormat
  Gif
  Jpeg
  Png
  Bmp
End Enum

Public Enum csRptChartType
  Pie
  Bar
End Enum

' estructuras
Private Type t_SerieValue
  Label     As String
  Value     As Double
  Idx       As Long
End Type

' variables privadas
Private m_Series                        As cReportChartSeries
Private m_ChartLineStyle                As csRptChartLineStyle
Private m_ChartBarOutline               As Boolean
Private m_ChartShowValues               As Boolean
Private m_PieThickness                  As csRptChartPieThickness
Private m_PieDiameter                   As csRptChartPieDiameter
Private m_ImageFormat                   As csRptChartFormat
Private m_Copyright                     As String
Private m_ChartTitle                    As String
Private m_ChartType                     As csRptChartType
Private m_hImage                        As Long
Private m_Top                           As Integer
Private m_ChartCreated                  As Boolean
Private m_GroupFieldName                As String
Private m_GroupValue                    As String
Private m_GroupFieldIndex               As Long
Private m_Sort                          As Boolean
' eventos
' propiedades publicas
Public Property Get LastErrorDescription() As String
  LastErrorDescription = CSKernelClient2.LastErrorDescription
End Property

Public Property Get LastErrorInfoAdd() As String
  LastErrorInfoAdd = CSKernelClient2.LastErrorInfoAdd
End Property

Public Property Get LastErrorModule() As String
  LastErrorModule = CSKernelClient2.LastErrorModule
End Property

Public Property Get LastErrorNumber() As String
  LastErrorNumber = CSKernelClient2.LastErrorNumber
End Property

Public Property Get LastErrorLine() As String
  LastErrorLine = CSKernelClient2.LastErrorLine
End Property

Public Property Get LastErrorFunction() As String
  LastErrorFunction = CSKernelClient2.LastErrorFunction
End Property

Public Property Get Series() As cReportChartSeries
   Set Series = m_Series
End Property

Public Property Set Series(ByRef rhs As cReportChartSeries)
   Set m_Series = rhs
End Property

Public Property Get GridLines() As csRptChartLineStyle
  GridLines = m_ChartLineStyle
End Property

Public Property Let GridLines(ByVal Value As csRptChartLineStyle)
  m_ChartLineStyle = Value
End Property

Public Property Get OutlineBars() As Boolean
  OutlineBars = m_ChartBarOutline
End Property

Public Property Let OutlineBars(ByVal Value As Boolean)
  m_ChartBarOutline = Value
End Property

Public Property Get ShowValues() As Boolean
  ShowValues = m_ChartShowValues
End Property

Public Property Let ShowValues(ByVal Value As Boolean)
  m_ChartShowValues = Value
End Property

Public Property Get Thickness() As csRptChartPieThickness
  Thickness = m_PieThickness
End Property

Public Property Let Thickness(ByVal Value As csRptChartPieThickness)
  m_PieThickness = Value
End Property

Public Property Get Diameter() As csRptChartPieDiameter
  Diameter = m_PieDiameter
End Property

Public Property Let Diameter(ByVal Value As csRptChartPieDiameter)
  m_PieDiameter = Value
End Property

Public Property Get Format() As csRptChartFormat
  Format = m_ImageFormat
End Property

Public Property Let Format(ByVal Value As csRptChartFormat)
  m_ImageFormat = Value
End Property

Public Property Get CopyRight() As String
  CopyRight = m_Copyright
End Property

Public Property Let CopyRight(ByVal Value As String)
  m_Copyright = Value
End Property

Public Property Get GroupFieldName() As String
  GroupFieldName = m_GroupFieldName
End Property

Public Property Let GroupFieldName(ByVal Value As String)
  m_GroupFieldName = Value
End Property

Public Property Get GroupValue() As String
  GroupValue = m_GroupValue
End Property

Public Property Let GroupValue(ByVal Value As String)
  m_GroupValue = Value
End Property

Public Property Get GroupFieldIndex() As String
  GroupFieldIndex = m_GroupFieldIndex
End Property

Public Property Let GroupFieldIndex(ByVal Value As String)
  m_GroupFieldIndex = Value
End Property

Public Property Get ChartTitle() As String
  ChartTitle = m_ChartTitle
End Property

Public Property Let ChartTitle(ByVal rhs As String)
  m_ChartTitle = rhs
End Property

Public Property Get Sort() As Boolean
  Sort = m_Sort
End Property

Public Property Let Sort(ByVal rhs As Boolean)
  m_Sort = rhs
End Property

Public Property Get ChartType() As csRptChartType
  ChartType = m_ChartType
End Property

Public Property Let ChartType(ByRef rhs As csRptChartType)
  m_ChartType = rhs
End Property

Public Property Get Top() As Integer
  Top = m_Top
End Property

Public Property Let Top(ByRef rhs As Integer)
  m_Top = rhs
End Property
' propiedades friend
Friend Property Get ChartCreated() As Boolean
  ChartCreated = m_ChartCreated
End Property

Friend Property Let ChartCreated(ByVal rhs As Boolean)
  m_ChartCreated = rhs
End Property

Friend Property Get hImage() As Long
  hImage = m_hImage
End Property
' propiedades privadas
' funciones publicas
#If PREPROC_WEB_CHART Then
  Public Function MakeChartFromRs(ByRef rs As Object, ByVal FileName As String) As Boolean
    Dim Rows As Variant
    CSKernelClient2.Silent = True
    Rows = rs.GetRows()
    MakeChartFromRs = Make(Rows, "###,###,##0.00", True, FileName)
  End Function
  
  Public Function MakeChartFromRsVariant(ByRef rs As Variant, ByVal FileName As String) As Boolean
    Dim Rows As Variant
    CSKernelClient2.Silent = True
    Rows = rs.GetRows()
    MakeChartFromRsVariant = Make(Rows, "###,###,##0.00", True, FileName)
  End Function

#End If
' funciones friend
#If Not PREPROC_WEB_CHART Then
Friend Function Load(ByRef xDoc As CSXml2.cXml, ByRef NodObj As Object) As Boolean

  Set NodObj = xDoc.GetNodeFromNode(NodObj, "Chart")
  
  If Not NodObj Is Nothing Then
    m_ChartLineStyle = xDoc.GetNodeProperty(NodObj, "LineStyle").Value(csInteger)
    m_ChartBarOutline = xDoc.GetNodeProperty(NodObj, "BarOutline").Value(csBoolean)
    m_ChartShowValues = xDoc.GetNodeProperty(NodObj, "ShowValues").Value(csBoolean)
    m_PieThickness = xDoc.GetNodeProperty(NodObj, "PieThickness").Value(csInteger)
    m_PieDiameter = xDoc.GetNodeProperty(NodObj, "PieDiameter").Value(csInteger)
    m_ImageFormat = xDoc.GetNodeProperty(NodObj, "ImageFormat").Value(csInteger)
    m_Copyright = xDoc.GetNodeProperty(NodObj, "Copyright").Value(csText)
    m_ChartTitle = xDoc.GetNodeProperty(NodObj, "ChartTitle").Value(csText)
    m_ChartType = xDoc.GetNodeProperty(NodObj, "ChartType").Value(csInteger)
    m_Top = xDoc.GetNodeProperty(NodObj, "Top").Value(csInteger)
    m_GroupValue = xDoc.GetNodeProperty(NodObj, "GroupValue").Value(csText)
    m_GroupFieldName = xDoc.GetNodeProperty(NodObj, "GroupFieldName").Value(csText)
    m_GroupFieldIndex = xDoc.GetNodeProperty(NodObj, "GroupFieldIndex").Value(csInteger)
    m_Sort = xDoc.GetNodeProperty(NodObj, "Sort").Value(csBoolean)
  
    Dim NodObjAux     As Object
    Dim NodObjSerie   As Object
    Dim Index         As Long
    
    Set NodObj = xDoc.GetNodeFromNode(NodObj, "Series")
    
    If xDoc.NodeHasChild(NodObj) Then
      Set NodObjSerie = xDoc.GetNodeChild(NodObj)
      
      While Not NodObjSerie Is Nothing
        Index = Index + 1
        Set NodObjAux = NodObjSerie
        If Not Series.Add(Nothing).Load(xDoc, NodObjAux, Index) Then Exit Function
        Set NodObjSerie = xDoc.GetNextNode(NodObjSerie)
      Wend
    End If
  End If
  
  Load = True
End Function

#If Not PREPROC_SFS Then
  Friend Function Save(ByRef xDoc As CSXml2.cXml, ByRef NodeFather As Object) As Boolean
    Dim xProperty As CSXml2.cXmlProperty
    Dim NodObj As Object
    
    Set xProperty = New CSXml2.cXmlProperty
    
    xProperty.Name = "Chart"
    Set NodObj = xDoc.AddNodeToNode(NodeFather, xProperty)
    
    xProperty.Name = "LineStyle"
    xProperty.Value(csInteger) = m_ChartLineStyle
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "BarOutline"
    xProperty.Value(csBoolean) = m_ChartBarOutline
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "ShowValues"
    xProperty.Value(csBoolean) = m_ChartShowValues
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "PieThickness"
    xProperty.Value(csInteger) = m_PieThickness
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "PieDiameter"
    xProperty.Value(csInteger) = m_PieDiameter
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "ImageFormat"
    xProperty.Value(csInteger) = m_ImageFormat
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "Copyright"
    xProperty.Value(csText) = m_Copyright
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "ChartTitle"
    xProperty.Value(csText) = m_ChartTitle
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "ChartType"
    xProperty.Value(csInteger) = m_ChartType
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "Top"
    xProperty.Value(csInteger) = m_Top
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "GroupFieldName"
    xProperty.Value(csText) = m_GroupFieldName
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "GroupFieldIndex"
    xProperty.Value(csInteger) = m_GroupFieldIndex
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "GroupValue"
    xProperty.Value(csText) = m_GroupValue
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "Sort"
    xProperty.Value(csBoolean) = m_Sort
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "Series"
    Set NodObj = xDoc.AddNodeToNode(NodObj, xProperty)
    
    Dim Serie As cReportChartSerie
    Dim Index As Long
    
    For Each Serie In m_Series
      Index = Index + 1
      Serie.Save xDoc, NodObj, Index
    Next Serie

    Save = True
  End Function
#End If
#End If

Friend Function Make(ByRef Rows As Variant, _
                     ByVal strFormat As String, _
                     ByVal bIsForWeb As Boolean, _
                     ByVal FileName As String) As Boolean
100   On Error GoTo ControlError
110
120   ' Si o si elimino la imagen anterior
130   '
140   pDestroyImage
150
160   If IsEmpty(Rows) Then Exit Function
170
180   Dim Chart   As Object
190   Set Chart = CSKernelClient2.CreateObject("CSChartServer.cWebChart")
200
210   Chart.NewChartType m_ChartType, m_ChartTitle
220
230   pFill Chart, Rows, strFormat
240
250   Chart.ColorPrimary = m_Series.Item(1).Color
260   Chart.LabelPrimary = GetRealName(m_Series.Item(1).ValueFieldName)
270   If m_Series.Count > 1 Then
280     Chart.ColorAlternate = m_Series.Item(2).Color
290     Chart.LabelAlternate = GetRealName(m_Series.Item(2).ValueFieldName)
300   End If
310   Chart.GridLines = m_ChartLineStyle
320   Chart.OutlineBars = m_ChartBarOutline
330   Chart.ShowValues = m_ChartShowValues
340   Chart.ShowLegend = IIf(m_ChartType = Bar, False, m_ChartShowValues)
350
360   Chart.Thickness = m_PieThickness
370   Chart.Diameter = m_PieDiameter
380
390   If Not bIsForWeb Then
400     FileName = GetValidPath(Environ$("TEMP")) & "~ChartImage"
410   End If
420
430   Chart.Format = m_ImageFormat
440   Chart.SaveTo = 1 ' SaveToFile
450   Chart.FileName = FileName
460
470   pKillFile FileName
480
490   Chart.CopyRight = m_Copyright
500   Chart.RenderWebChartImage
510
520   If Not bIsForWeb Then
530     LoadChart FileName
540   End If
550
560   m_ChartCreated = True
570   Make = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "Make", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Chart.Dispose
End Function

' funciones privadas
Private Function pGetExt() As String
  Select Case m_ImageFormat
    Case csRptChartFormat.Bmp
      pGetExt = ".bmp"
    Case csRptChartFormat.Jpeg
      pGetExt = ".jpg"
    Case csRptChartFormat.Gif
      pGetExt = ".gif"
    Case csRptChartFormat.Png
      pGetExt = ".png"
  End Select
End Function

Private Sub pKillFile(ByVal FileName As String)
  On Error Resume Next
  Kill FileName
End Sub

Private Function LoadChart(ByVal FileName As String)

  ' Si o si elimino la imagen anterior
  '
  pDestroyImage

  If LenB(FileName) > 0 Then
    Dim iPic As IPictureDisp
    Set iPic = LoadPicture(FileName)
    
    With iPic
      Dim Width  As Long
      Dim Height As Long
      
      GetBitmapSize .Handle, Width, Height
      m_hImage = CopyBitmap(.Handle, Width, Height, 0)
    End With
  End If
End Function

Private Sub pDestroyImage()
  If m_hImage Then DeleteObject CLng(m_hImage)
  m_hImage = 0
  m_ChartCreated = False
End Sub

Private Sub pGetSerieValues(ByRef Rows As Variant, _
                            ByRef v() As t_SerieValue, _
                            ByVal ValueIndex As Long, _
                            ByVal LabelIndex As Long, _
                            ByVal bOthers As Boolean)
  Dim i           As Long
  Dim j           As Long
  Dim q           As Long
  Dim Value       As Double
  Dim bFound      As Boolean
  Dim bCompare    As Boolean
  Dim newTop      As Long
  
  If m_GroupFieldIndex >= 0 Then
    
    For j = 0 To UBound(Rows, 2)
      
      If ValVariant(Rows(m_GroupFieldIndex, j)) = m_GroupValue Then
        newTop = newTop + 1
      End If
    Next
    
    If newTop > 0 Then newTop = newTop - 1

    If UBound(v) > newTop Then
      ReDim Preserve v(newTop)
    End If
  End If
  
  If m_Sort Then
  
    If m_GroupFieldIndex >= 0 Then
      For j = 0 To UBound(Rows, 2)
      
        If ValVariant(Rows(m_GroupFieldIndex, j)) = m_GroupValue Then
      
          v(0).Value = ValVariant(Rows(ValueIndex, j))
          v(0).Label = ValVariant(Rows(LabelIndex, j))
          v(0).Idx = j
          Exit For
        End If
      Next
    
    Else
      
      v(0).Value = ValVariant(Rows(ValueIndex, 0))
      v(0).Label = ValVariant(Rows(LabelIndex, 0))
      v(0).Idx = 0
  
    End If
    
    For j = 1 To UBound(Rows, 2)
      
      If m_GroupFieldIndex >= 0 Then
        bCompare = ValVariant(Rows(m_GroupFieldIndex, j)) = m_GroupValue
      Else
        bCompare = True
      End If
      
      If bCompare Then
        Value = Val(ValVariant(Rows(ValueIndex, j)))
        
        If Value > v(0).Value Then
          v(0).Value = Value
          v(0).Label = ValVariant(Rows(LabelIndex, j))
          v(0).Idx = j
        End If
      End If
    Next
    
    For i = 1 To UBound(v)
      
      v(i).Idx = -1
      
      For j = 1 To UBound(Rows, 2)
        
        If m_GroupFieldIndex >= 0 Then
          bCompare = ValVariant(Rows(m_GroupFieldIndex, j)) = m_GroupValue
        Else
          bCompare = True
        End If
        
        If bCompare Then
          Value = Val(ValVariant(Rows(ValueIndex, j)))
          
          If (Value > v(i).Value Or v(i).Idx = -1) And _
             Value <= v(i - 1).Value And _
             j <> v(i - 1).Idx Then
            
            bFound = False
            For q = 0 To i
              If j = v(q).Idx Then
                bFound = True
                Exit For
              End If
            Next
            
            If Not bFound Then
              v(i).Value = Value
              v(i).Label = ValVariant(Rows(LabelIndex, j))
              v(i).Idx = j
            End If
          End If
        End If
      Next
    Next
  
  Else
    i = 0
    For j = 0 To UBound(Rows, 2)
      If m_GroupFieldIndex >= 0 Then
        If ValVariant(Rows(m_GroupFieldIndex, j)) = m_GroupValue Then
          If pGetSerieValuesAux(Rows, v, ValueIndex, LabelIndex, i, j, False) Then Exit For
        End If
      Else
        If pGetSerieValuesAux(Rows, v, ValueIndex, LabelIndex, i, j, False) Then Exit For
      End If
    Next
    
    If bOthers Then
    
      If UBound(Rows, 2) > UBound(v) Then
      
        Dim n As Long
        Dim k As Long
        Dim bHaveToRedim As Boolean
        bHaveToRedim = True
        n = UBound(v) + 1
        For j = 0 To UBound(Rows, 2)
          If m_GroupFieldIndex >= 0 Then
            If ValVariant(Rows(m_GroupFieldIndex, j)) = m_GroupValue Then
              If k >= n Then
                If bHaveToRedim Then
                  ReDim Preserve v(n)
                  bHaveToRedim = False
                End If
                pGetSerieValuesAux Rows, v, ValueIndex, LabelIndex, UBound(v), j, True
              Else
                k = k + 1
              End If
            End If
          Else
            If bHaveToRedim Then
              ReDim Preserve v(n)
              bHaveToRedim = False
            End If
            pGetSerieValuesAux Rows, v, ValueIndex, LabelIndex, UBound(v), j, True
          End If
        Next
      End If
    End If
  End If
End Sub

Private Function pGetSerieValuesAux(ByRef Rows As Variant, _
                                    ByRef v() As t_SerieValue, _
                                    ByVal ValueIndex As Long, _
                                    ByVal LabelIndex As Long, _
                                    ByRef i As Long, _
                                    ByVal j As Long, _
                                    ByVal bAdd As Boolean) As Boolean
  
  If bAdd Then
    v(i).Value = v(i).Value + ValVariant(Rows(ValueIndex, j))
  Else
    v(i).Value = ValVariant(Rows(ValueIndex, j))
  End If
  v(i).Label = ValVariant(Rows(LabelIndex, j))
  v(i).Idx = j
  i = i + 1
  pGetSerieValuesAux = i > UBound(v)
End Function

Private Sub pFill(ByRef Chart As Object, _
                  ByRef Rows As Variant, _
                  ByVal strFormat As String)

  Dim i        As Long
  Dim Values() As t_SerieValue
  Dim Serie    As cReportChartSerie
  Dim idxSerie As Integer
  
  If m_Top = 0 Then m_Top = 50
  
  If UBound(Rows, 2) < 0 Then Exit Sub
  
  If UBound(Rows, 2) < m_Top Then
    ReDim Values(UBound(Rows, 2))
  Else
    ReDim Values(m_Top - 1)
  End If
  
  For Each Serie In m_Series
  
    ' Por ahora solo se permiten dos series
    '
    '
    idxSerie = idxSerie + 1
    If idxSerie > 2 Then Exit Sub
    
    pGetSerieValues Rows, Values, Serie.ValueIndex, Serie.LabelIndex, m_ChartType = Pie
    
    For i = 0 To UBound(Values)
  
      If Values(i).Idx <> -1 Then
        If idxSerie = 1 Then
          With Chart.webchartitems.Item(Chart.webchartitems.Add(Nothing))
            .PrimaryValue = Values(i).Value
            .PrimaryLabel = mAux.Format(Values(i).Label, strFormat)
            .PieLabel = mAux.Format(Values(i).Label, strFormat)
            .AlternateValue = 0
          End With
        ElseIf idxSerie = 2 Then
          With Chart.webchartitems.Item(i + 1)
            .AlternateValue = Values(i).Value
            .PieLabel = mAux.Format(Values(i).Label, strFormat)
            .AltLabel = mAux.Format(Values(i).Label, strFormat)
          End With
        End If
      End If
    Next
    
    If UBound(Values) > m_Top - 1 And m_ChartType = Pie Then
    
      With Chart.webchartitems.Item(Chart.webchartitems.Count)
        .PrimaryLabel = "Otros"
        .PieLabel = "Otros"
      End With
    End If
    
  Next
  
  If Chart.webchartitems.Count Then
    Chart.webchartitems.Item(1).Explode = True
  End If
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_Series = New cReportChartSeries
  m_ImageFormat = Png

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_Series = Nothing
  pDestroyImage

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
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

