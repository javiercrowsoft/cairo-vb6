VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cWebChart"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'/////////////////////////////////////////////////////////////////////////////////////////
' CopyRight © 2003-2005 Javier Alvarez (javier@crowsoft.com.ar)

' This library is free software; you can redistribute it and/or modify
' it under the terms of the GNU Lesser Gereral Public Licence as published
' by the Free Software Foundation; either version 2 of the Licence,
' or (at your opinion) any later version.

' This library is distributed in the hope that it will be usefull,
' but WITHOUT ANY WARRANTY; without even the implied warranty of merchantability
' or fitness for a particular purpose. See the GNU Lesser General Public Licence
' for more details.

' You should have received a copy of the GNU Lesser General Public Licence
' along with this library; if not, write to the Free Software Foundation, Inc.,
' 59 Temple Place, Suite 330, Boston, Ma 02111-1307 USA.

' Visit CrowSoft.
'    http://www.crowsoft.com.ar
'/////////////////////////////////////////////////////////////////////////////////////////

Private Const c_Module = "cWebChart"

'Imports System
'Imports System.IO
'Imports System.Web
'Imports System.Web.UI
'Imports System.Web.UI.WebControls
'Imports System.DateTime
'Imports System.Drawing
'Imports System.Drawing.Imaging
'Imports System.Drawing.Drawing2D
'Imports System.ComponentModel
'Imports System.ComponentModel.Design
'Imports System.ComponentModel.Design.Serialization
'Imports System.Globalization
'Imports Microsoft.VisualBasic

' Assign Tag Prefix to WebControls

'<DefaultProperty("Type"), _
'ToolboxData("<{0}:WebChart runat=server></{0}:WebChart>"), _
'ParseChildren(True, "WebChartItems"), ToolboxBitmapAttribute(GetType(Bitmap))> _
'Public Class WebChart
'    Inherits WebControl

'#Region " Chart Enumerations "

    Public Enum eSaveTo
      SaveToStream
      SaveToFile
    End Enum

    Public Enum eLineStyle
        None
        Horizontal
        Numbered
        Both
    End Enum

    Public Enum eChartType
        Pie
        Bar
    End Enum

    Public Enum ePieDiameter
        Smallest = 50
        Smaller = 100
        Small = 150
        Medium = 200
        Large = 250
        Larger = 350
        Largest = 450
    End Enum

    Public Enum ePieThickness
        None = 0
        Wafer = 2
        Thin = 4
        Medium = 8
        Thick = 16
        Thickest = 32
    End Enum

    'Corresponds to System.Drawing.Imaging.ImageFormat
    Public Enum eChartFormat
        Gif
        Jpeg
        Png
        Bmp
    End Enum

'#End Region

Private m_BaseClass                     As cWebControl
Private m_Font                          As cFont
Private m_ForeColor                     As Long
Private m_BackColor                     As Long
Private m_ID                            As String
Private m_Page                          As cPage
Private m_SaveTo                        As eSaveTo
Private m_FileName                      As String

'#Region " Chart Private Members and Events "

    'Chart data fields - All Types
    Private m_WebChartItems       As cWebChartItemCollection

    'Chart layout fields
    Private m_ChartTitle          As String
    Private m_ChartShowValues     As Boolean
    Private m_ChartBarOutline     As Boolean
    Private m_ChartShowTitle      As Boolean
    Private m_ChartType           As eChartType
    Private m_ChartLineStyle      As eLineStyle
    Private m_ChartPrimaryColor   As GpGDIPlus.colors
    Private m_ChartAltColor       As GpGDIPlus.colors
    Private m_ImageFormat         As eChartFormat
    Private m_ChartLegend         As Boolean
    Private m_PrimaryLabel        As String
    Private m_AltLabel            As String

    'Exposed in overloaded constructor
    Private m_Copyright           As String

    'Chart data fields - Pie Chart
    Private m_ColorIndex          As Long
    Private m_PieDiameter         As ePieDiameter
    Private m_PieRotation         As Single
    Private m_PieThickness        As ePieThickness
    Private m_PieExplode          As Boolean
    Private m_PieExplodeOffset    As Single

'#End Region
Public Property Let fileName(ByVal rhs As String)
  m_FileName = rhs
End Property

Public Property Let SaveTo(ByVal rhs As eSaveTo)
  m_SaveTo = rhs
End Property

Public Property Get Font() As cFont
   Set Font = m_Font
End Property

Public Property Set Font(ByRef rhs As cFont)
   Set m_Font = rhs
End Property

Public Property Get ForeColor() As Long
   ForeColor = m_ForeColor
End Property

Public Property Let ForeColor(ByVal rhs As Long)
   m_ForeColor = rhs
End Property

Public Property Get BackColor() As Long
   BackColor = m_BackColor
End Property

Public Property Let BackColor(ByVal rhs As Long)
   m_BackColor = rhs
End Property

Public Property Get ChartTitle() As String
   ChartTitle = m_ChartTitle
End Property

Public Property Let ChartTitle(ByVal rhs As String)
   m_ChartTitle = rhs
End Property

Public Property Get ID() As String
   ID = m_ID
End Property

Public Property Let ID(ByVal rhs As String)
   m_ID = rhs
End Property

Public Property Get Page() As cPage
   Set Page = m_Page
End Property

Public Property Set Page(ByRef rhs As cPage)
   Set m_Page = rhs
End Property

'#Region " Chart Public Properties "

'    <Category("Chart Common"), DesignerSerializationVisibility(DesignerSerializationVisibility.Content), PersistenceMode(PersistenceMode.InnerDefaultProperty), Description("Supply data values for selected chart.")>
    Public Property Get WebChartItems() As cWebChartItemCollection
        
            If m_WebChartItems Is Nothing Then
                Set m_WebChartItems = New cWebChartItemCollection
                m_WebChartItems.NewCollOwner Me
            End If
            Set WebChartItems = m_WebChartItems
    End Property

'    <DefaultValue("Primary"), Category("Chart Bar"), Description("Primary label for bar chart legend."), DesignerSerializationVisibility(DesignerSerializationVisibility.Visible)>
    Public Property Get LabelPrimary() As String
        
            LabelPrimary = m_PrimaryLabel
    End Property
    Public Property Let LabelPrimary(ByVal Value As String)
            If Value = "" Then
                m_PrimaryLabel = "Primary"
            Else
                m_PrimaryLabel = Value
            End If
    End Property

'    <DefaultValue("Alternate"), Category("Chart Bar"), Description("Alternate label for bar chart legend."), DesignerSerializationVisibility(DesignerSerializationVisibility.Visible)>
   Public Property Get LabelAlternate() As String
            LabelAlternate = m_AltLabel
   End Property
   
   Public Property Let LabelAlternate(ByVal Value As String)
            If Value = "" Then
                m_AltLabel = "Alternate"
            Else
                m_AltLabel = Value
            End If
    End Property

'    <Category("Chart Common"), DefaultValue("Chart Title"), Description("Title displayed on top of chart.")>
    Public Property Get Title() As String
            Title = m_ChartTitle
    End Property
    
    Public Property Let Title(ByVal Value As String)
            If Value <> "" Then
                m_ChartTitle = Value
            Else
                m_ChartShowTitle = False
                m_ChartTitle = ""
            End If
    End Property

'    <Category("Chart Common"), DefaultValue(True), Description("Show or hide chart title.")>
    Public Property Get ShowTitle() As Boolean
            ShowTitle = m_ChartShowTitle
    End Property
    
    Public Property Let ShowTitle(ByVal Value As Boolean)
            If Title = "" Then
                Err.Raise vbObjectError + 1, c_Module, "Title cannot be displayed as an empty value."
                m_ChartShowTitle = False
            Else
                m_ChartShowTitle = Value
            End If
    End Property

'    <Category("Chart Bar"), DefaultValue(False), Description("Show or hide chart numerical values.")>
    Public Property Get ShowValues() As Boolean
            ShowValues = m_ChartShowValues
    End Property
    
    Public Property Let ShowValues(ByVal Value As Boolean)
            m_ChartShowValues = Value
    End Property

'    <DefaultValue(GetType(ChartFormat), "Gif"), Category("Chart Common"), Description("Compression format for image.")>
    Public Property Get Format() As eChartFormat
            Format = m_ImageFormat
    End Property
    Public Property Let Format(ByVal Value As eChartFormat)
            m_ImageFormat = Value
    End Property

'    <DefaultValue(GetType(ChartType), "Bar"), Category("Chart Common"), Description("Type of chart to generate.")>
    Public Property Get ChartType() As eChartType
            ChartType = m_ChartType
    End Property
    Public Property Let ChartType(ByVal Value As eChartType)
            m_ChartType = Value
    End Property

'    <DefaultValue(GetType(LineStyle), "Both"), Category("Chart Bar"), Description("Show horizontal,numbered or no grid lines.")>
    Public Property Get GridLines() As eLineStyle
            GridLines = m_ChartLineStyle
    End Property
    Public Property Let GridLines(ByVal Value As eLineStyle)
            m_ChartLineStyle = Value
    End Property

'    <DefaultValue(GetType(Color), "DarkBlue"), Category("Chart Bar"), Description("Color of primary chart values.")>
    Public Property Get ColorPrimary() As GpGDIPlus.colors
            ColorPrimary = m_ChartPrimaryColor
    End Property
    Public Property Let ColorPrimary(ByVal Value As GpGDIPlus.colors)
            m_ChartPrimaryColor = Value
    End Property

'    <DefaultValue(GetType(Color), "CornFlowerBlue"), Category("Chart Bar"), Description("Color of alternate chart values.")>
    Public Property Get ColorAlternate() As GpGDIPlus.colors
            ColorAlternate = m_ChartAltColor
    End Property
    Public Property Let ColorAlternate(ByVal Value As GpGDIPlus.colors)
            m_ChartAltColor = Value
    End Property

'    <DefaultValue(True), Category("Chart Common"), Description("Show or hide chart legend.")>
    Public Property Get ShowLegend() As Boolean
            ShowLegend = m_ChartLegend
    End Property
    Public Property Let ShowLegend(ByVal Value As Boolean)
            m_ChartLegend = Value
    End Property

'    <DefaultValue(GetType(PieThickness), "Medium"), Category("Chart Pie"), Description("Thickness of 3D image.  Use none for 2D effect.")>
    Public Property Get Thickness() As ePieThickness
            Thickness = m_PieThickness
    End Property
    Public Property Let Thickness(ByVal Value As ePieThickness)
            m_PieThickness = Value
    End Property

'    <DefaultValue(25.0F), Category("Chart Pie"), Description("Offset value for exploded pie sections.")>
    Public Property Get ExplodeOffset() As Single
            ExplodeOffset = m_PieExplodeOffset
    End Property
    Public Property Let ExplodeOffset(ByVal Value As Single)
            m_PieExplodeOffset = Value
    End Property

'    <DefaultValue(GetType(PieDiameter), "Medium"), Category("Chart Pie"), Description("Total diameter of pie chart.")>
    Public Property Get Diameter() As ePieDiameter
            Diameter = m_PieDiameter
    End Property
    Public Property Let Diameter(ByVal Value As ePieDiameter)
            m_PieDiameter = Value
    End Property

'    <DefaultValue(70.0F), Category("Chart Pie"), Description("Rotate pie chart forward on Y-Axis.")>
    Public Property Get Rotate() As Single
            Rotate = m_PieRotation
    End Property
    Public Property Let Rotate(ByVal Value As Single)
            m_PieRotation = Value
    End Property

'    <DefaultValue(True), Category("Chart Bar"), Description("Outline charted bar values.")>
    Public Property Get OutlineBars() As Boolean
            OutlineBars = m_ChartBarOutline
    End Property
    Public Property Let OutlineBars(ByVal Value As Boolean)
            m_ChartBarOutline = Value
    End Property

'    <Browsable(False)>
    Public Property Get HtmlContentType() As String
            HtmlContentType = "image/" & ChartFormat.GetName(Me.Format).ToString.ToLower
    End Property

'#End Region


'#Region " Chart Constructors "

    Public Sub NewChart()
        GDIPlusInitialize
        m_BaseClass.NewControl
        Me.Font.Name = "Tahoma"
        Me.ForeColor = GpGDIPlus.colors.Black
        Me.BackColor = GpGDIPlus.colors.White
    End Sub

    Public Sub NewChartCopyRight(ByVal CopyRight As String)
        NewChart
        m_Copyright = CopyRight
    End Sub

    Public Sub NewChartType(ByVal ChartType As eChartType, ByVal ChartTitle As String)
        NewChart
        m_ChartType = ChartType
        m_ChartTitle = ChartTitle
    End Sub

'#End Region

'#Region " Chart Private Properties "

    Private Property Get CopyRight() As String
            CopyRight = m_Copyright
    End Property
    Public Property Let CopyRight(ByVal Value As String)
            m_Copyright = Value
    End Property

    'Pie Chart Properties
    Private Property Get PieColors() As Variant()
            PieColors = Array( _
              Color.FromRGB(204, 0, 0), _
              Color.FromRGB(204, 0, 255), _
              Color.FromRGB(204, 153, 255), _
              Color.FromRGB(51, 0, 153), _
              Color.FromRGB(51, 102, 153), _
              Color.FromRGB(102, 153, 255), _
              Color.FromRGB(51, 102, 0), _
              Color.FromRGB(51, 153, 0), _
              Color.FromRGB(51, 204, 0), _
              Color.FromRGB(255, 102, 0), _
              Color.FromRGB(255, 153, 0), _
              Color.FromRGB(255, 204, 0), _
              Color.FromRGB(255, 255, 0) _
              )
    End Property

'#End Region

'#Region " Chart Rendering Methods "

    'Initial request for WebChart object
    Friend Sub Render(ByVal output As cHtmlTextWriter)
        Dim WebSource As String
        WebSource = GenerateNameAndRegisterForCall()
        'Write relative URL for image stream request
        output.doWrite ("<img src='" & HandlerFileName & "?id=" & WebSource & "' border='0'></img><br>")
        Dispose
    End Sub

    'RenderWebChartImage() is called by <img> tag
    Public Function RenderWebChartImage() As cMemoryStream
        Select Case m_ChartType
            Case eChartType.Bar
                Set RenderWebChartImage = makeBarChart()
            Case eChartType.Pie
                Set RenderWebChartImage = makePieChart()
            Case Else
                Exit Function
        End Select
        Dispose
    End Function

    'Generates a new name for this control & registers
    'application level object
    Function GenerateNameAndRegisterForCall() As String
        Dim sControlName As String
        sControlName = System.Guid.NewGuid.ToString
        
        'Identifies requested WebChart image
        Set Me.Page.Application(ChartNamePrefixInApplication & sControlName) = Me
        GenerateNameAndRegisterForCall = sControlName
    End Function

'#End Region


'#Region " Chart Functions and Subroutines "

    Private Function getBarData() As cCommonData
        Dim i           As Long
        Dim Item        As cWebChartItem
        Dim barData     As cCommonData
        Dim barHeight   As Single
        Dim barWidth    As Single
        Dim titleWidth  As Single
        Dim LegendWidth As Single
        Dim HighVal     As Single
        
        Set barData = New cCommonData
        barHeight = 185
        HighVal = 0

        'Determine high value for chart
        For Each Item In WebChartItems
            If Item.PrimaryValue > HighVal Then
                HighVal = Item.PrimaryValue
            End If
            If Item.AlternateValue > HighVal Then
                HighVal = Item.AlternateValue
            End If
        Next

        For Each Item In WebChartItems
            barWidth = barWidth + 20
            If Item.AlternateValue <> 0 Then
                barWidth = barWidth + 10
            End If
        Next

        'Generate temp Graphics Object
        Dim tmpGraphics As cGraphics
        Dim Bitmap      As cBitmap
        
        Set Bitmap = New cBitmap
        Set tmpGraphics = NewGraphics.FromImage(Bitmap.NewBitmap(1, 1))

        Dim tmpFont As cFont

        'Determine width of graph title
        If ShowTitle Then
            'Measure Title Width
            Set tmpFont = New cFont
            tmpFont.NewFont Me.Font.Name, 14, eFontStyle.Bold
            titleWidth = tmpGraphics.MeasureString(Title, tmpFont).Width
            titleWidth = titleWidth + 40
            Set tmpFont = Nothing
        End If

        'Measure value left label width
        Dim maxValWidth     As Single
        Dim tmpLabelWidth   As Single
        
        If GridLines = eLineStyle.Both Or GridLines = eLineStyle.Numbered Then
            Set tmpFont = New cFont
            tmpFont.NewFont Me.Font.Name, 7
            For i = 0 To 100 Step 10
                tmpLabelWidth = tmpGraphics.MeasureString(Trim(Round((HighVal / 100 * i))), _
                                                          tmpFont).Width
                If tmpLabelWidth > maxValWidth Then
                    maxValWidth = tmpLabelWidth
                End If
            Next
            Set tmpFont = Nothing
        End If

        'Calculate legend width
        If ShowLegend Then
            Dim tmpLabels As Single
            Set tmpFont = New cFont
            tmpFont.NewFont Me.Font.Name, 7
            tmpLabels = tmpGraphics.MeasureString(LabelPrimary, tmpFont).Width
            tmpLabels = tmpLabels + tmpGraphics.MeasureString(LabelAlternate, tmpFont).Width
            LegendWidth = tmpLabels + 30
            Set tmpFont = Nothing
        End If

        tmpGraphics.Dispose
        barWidth = barWidth + maxValWidth + 15

        If titleWidth > barWidth Then
            barWidth = titleWidth
        Else
            If LegendWidth > barWidth Then
                barWidth = LegendWidth
            End If
        End If

        barWidth = barWidth + 10

        With barData
            .ImgHeight = barHeight
            .ImgWidth = barWidth
            .ValWidth = maxValWidth + 2
        End With

        Set getBarData = barData
    End Function

    Private Function makeBarChart() As cMemoryStream
        Dim i           As Long
        Dim barData     As cCommonData
        Dim Item        As cWebChartItem
        Dim HighVal     As Single
        Dim barHeight   As Single
        Dim barWidth    As Single

        Set barData = getBarData()
        HighVal = 0
        barHeight = barData.ImgHeight
        barWidth = barData.ImgWidth

        Dim rAlternateOutline As cRectangle
        Dim rPrimaryOutline   As cRectangle

        'Determine high value for chart
        For Each Item In WebChartItems
            If Item.PrimaryValue > HighVal Then
                HighVal = Item.PrimaryValue
            End If
            If Item.AlternateValue > HighVal Then
                HighVal = Item.AlternateValue
            End If
        Next

        'Declare object variables
        Dim objBitMap     As cBitmap
        Dim objGraphics   As cGraphics
        Dim rPrimary      As cRectangle
        Dim bPrimary      As cIBrush
        Dim rAlternate    As cRectangle
        Dim bAlternate    As cIBrush

        Set objBitMap = New cBitmap
        objBitMap.NewBitmap barWidth, barHeight
        
        Set objGraphics = NewGraphics.FromImage(objBitMap)
        objGraphics.Clear (Me.BackColor)
        objGraphics.SmoothingMode = GpGDIPlus.SmoothingMode.SmoothingModeAntiAlias
        objGraphics.TextRenderingHint = GpGDIPlus.TextRenderingHint.TextRenderingHintAntiAliasGridFit

        Dim fBrush    As cIBrush
        Dim objPen    As cPen
        
        Dim tmpPen    As cPen
        Dim tmpFont   As cFont
        Dim tmpPoint  As cPointF
        
        Dim pX As Long
        Dim pY As Long
        
        Set fBrush = New cSolidBrush
        fBrush.NewSolidBrush Me.ForeColor
        Set objPen = New cPen
        objPen.NewPen Me.ForeColor

        'Write out shaded graph title
        If ShowTitle Then
            Set tmpFont = New cFont
            tmpFont.NewFont Me.Font.Name, 14, eFontStyle.Bold
            Set tmpPoint = New cPointF
            tmpPoint.NewPointF (barData.ValWidth + 1) / 2, 7
            objGraphics.DrawString Title, tmpFont, eBrushes.Gainsboro, tmpPoint
            
            Set tmpPoint = New cPointF
            tmpPoint.NewPointF barData.ValWidth / 2, 5
            objGraphics.DrawString Title, tmpFont, fBrush, tmpPoint
            
            Set tmpFont = Nothing
            Set tmpPoint = Nothing
        End If

        'Build Legend if specified
        If ShowLegend Then
            Dim blnAlternates   As Boolean
            Dim pSymbol         As cPointF
            Dim pSymbolDesc     As cPointF

            blnAlternates = False
            Set pSymbol = New cPointF
            pSymbol.NewPointF barData.ValWidth + 10, barHeight - 40
            Set pSymbolDesc = New cPointF
            pSymbolDesc.NewPointF pSymbol.X + 12, pSymbol.Y

            For Each Item In WebChartItems
                If Item.AlternateValue <> 0 Then
                    blnAlternates = True
                End If
            Next

            'Primary Symbol
            Set rPrimary = New cRectangle
            rPrimary.NewRectangle pSymbol.X, pSymbol.Y, 10, 10
            'No gradients for gif format
            If Format = eChartFormat.Gif Then
                Set bPrimary = New cSolidBrush
                bPrimary.NewSolidBrush ColorPrimary
            Else
                Set bPrimary = New cLinearGradientBrush
                bPrimary.NewGradientBrush rPrimary, _
                                          getLightColor(ColorPrimary, 55), _
                                          getDarkColor(ColorPrimary, 55), _
                                          eLinearGradientMode.ForwardDiagonal
            End If
            objGraphics.FillRectangle bPrimary, rPrimary
            
            Set tmpFont = New cFont
            tmpFont.NewFont Me.Font.Name, 7
            objGraphics.DrawString LabelPrimary, tmpFont, eBrushes.Black, pSymbolDesc
            Set tmpFont = Nothing
            
            'Primary Symbol Outline
            If OutlineBars Then
                Set rPrimaryOutline = New cRectangle
                rPrimaryOutline.NewRectangle pSymbol.X, pSymbol.Y, 10, 10
                Set tmpPen = New cPen
                tmpPen.NewPen Me.ForeColor
                
                objGraphics.DrawRectangle tmpPen, rPrimaryOutline
                
                Set rPrimaryOutline = Nothing
                Set tmpPen = Nothing
            End If

            If blnAlternates Then
                'Estimate Coordinates for Alternate Symbol
                'MeasureString doesn't return accurate string width
                Set tmpFont = New cFont
                tmpFont.NewFont Me.Font.Name, 7
                pSymbol.X = pSymbol.X + objGraphics.MeasureString(LabelPrimary, _
                                                                  tmpFont).ToPointF.X
                pSymbol.X = pSymbol.X + 20
                pSymbolDesc.X = pSymbol.X + 12
                Set tmpFont = Nothing

                'Alternate Symbol
                Set rAlternate = New cRectangle
                rAlternate.NewRectangle pSymbol.X, pSymbol.Y, 10, 10
                'No gradients for gif format
                If Format = eChartFormat.Gif Then
                    Set bAlternate = New cSolidBrush
                    bAlternate.NewSolidBrush ColorAlternate
                Else
                    Set bAlternate = New cLinearGradientBrush
                    bAlternate.NewGradientBrush rAlternate, _
                                                getLightColor(ColorAlternate, 55), _
                                                getDarkColor(ColorAlternate, 55), _
                                                eLinearGradientMode.ForwardDiagonal
                End If
                objGraphics.FillRectangle bAlternate, rAlternate
                Set tmpFont = New cFont
                tmpFont.NewFont Me.Font.Name, 7
                objGraphics.DrawString LabelAlternate, tmpFont, eBrushes.Black, pSymbolDesc
                Set tmpFont = Nothing
                'Alternate Symbol Outline
                If OutlineBars Then
                    Set rAlternateOutline = New cRectangle
                    rAlternateOutline.NewRectangle pSymbol.X, pSymbol.Y, 10, 10
                    Set tmpPen = New cPen
                    tmpPen.NewPen Me.ForeColor
                    objGraphics.DrawRectangle tmpPen, rAlternateOutline
                    Set rAlternateOutline = Nothing
                    Set tmpPen = Nothing
                End If
            End If
        End If

        'Draw major horizontal lines
        If GridLines <> eLineStyle.None Then
            Set tmpPen = New cPen
            tmpPen.NewPen GpGDIPlus.colors.Gainsboro
            For i = 0 To 100 Step 10
                If GridLines = eLineStyle.Horizontal Or GridLines = eLineStyle.Both Then
                    'Horizontal lines
                    objGraphics.DrawLinePoint tmpPen, _
                                              NewPoint(barData.ValWidth + 10, barHeight - i - 45), _
                                              NewPoint(barWidth - 10, barHeight - i - 45)
                    'Vertical Left
                    objGraphics.DrawLinePoint tmpPen, _
                                              NewPoint(barData.ValWidth + 10, barHeight - i - 45), _
                                              NewPoint(barData.ValWidth + 10, 40)
                                         
                    'Vertical Right
                    objGraphics.DrawLinePoint tmpPen, _
                                              NewPoint(barWidth - 10, barHeight - i - 45), _
                                              NewPoint(barWidth - 10, 40)
                                         
                End If
                Set tmpFont = New cFont
                tmpFont.NewFont Me.Font.Name, 7
                If GridLines = eLineStyle.Numbered Or GridLines = eLineStyle.Both Then
                    objGraphics.DrawString Math.Round((HighVal / 100 * i)), _
                                           tmpFont, _
                                           eBrushes.Black, _
                                           NewPointF(10, (barHeight - i) - 51)
                End If
            Next
            Set tmpPen = Nothing
        End If

        'Loop through the values to create the Bar Chart.
        i = 0
        
        Dim BrushValue As cIBrush
        Set BrushValue = New cSolidBrush
        BrushValue.NewSolidBrush Me.ForeColor
        
        Dim tmpFont2 As cFont
        Set tmpFont2 = New cFont
        
        tmpFont2.NewFont Me.Font.Name, 6
        
        For Each Item In WebChartItems
            If Item.AlternateValue <> 0 Then
                ' Try
                On Error GoTo Catch1
                    'Primary bar
                    Set rPrimary = New cRectangle
                    rPrimary.NewRectangle (i * 30) + barData.ValWidth + 20, _
                                        (((HighVal - Item.PrimaryValue) / HighVal) * 100) + 40, _
                                        10, Round((Item.PrimaryValue / HighVal) * 100)
                                        
                    'No gradients for gif format
                    If Format = eChartFormat.Gif Then
                        Set bPrimary = New cSolidBrush
                        bPrimary.NewSolidBrush ColorPrimary
                    Else
                        Set bPrimary = New cLinearGradientBrush
                        bPrimary.NewGradientBrush rPrimary, _
                                                  getLightColor(ColorPrimary, 55), _
                                                  getDarkColor(ColorPrimary, 55), _
                                                  eLinearGradientMode.ForwardDiagonal
                    End If
                    objGraphics.FillRectangle bPrimary, rPrimary
                    If ShowValues Then
                        objGraphics.DrawString Item.PrimaryValue.ToString, _
                                               tmpFont2, _
                                               BrushValue, _
                                               NewPointF((i * 30) + barData.ValWidth + 20, _
                                                         (((HighVal - Item.PrimaryValue) _
                                                                  / HighVal) * 100) + 30)
                    End If
                    'Primary Bar Outline
                    If OutlineBars Then
                        Set rPrimaryOutline = New cRectangle
                        rPrimaryOutline.NewRectangle (i * 30) + barData.ValWidth + 20, _
                                                     (((HighVal - Item.PrimaryValue) / HighVal) * 100) + 40, _
                                                     10, ((Item.PrimaryValue / HighVal) * 100)

                        objGraphics.DrawRectangle objPen, rPrimaryOutline
                    End If

Catch1:     '-->Catch
                    'Primary Bar - Negligable Scaled Value
                    Set tmpPen = New cPen
                    tmpPen.NewPen Me.ColorPrimary
                    pX = (i * 30) + barData.ValWidth + 20
                    pY = (((HighVal - Item.PrimaryValue) / HighVal) * 100) + 40
                    objGraphics.DrawLineL tmpPen, pX, pY, pX + 10, pY
                    If ShowValues Then
                        objGraphics.DrawString Item.PrimaryValue.ToString, _
                                               tmpFont2, _
                                               BrushValue, _
                                               NewPointF((i * 30) + barData.ValWidth + 20, _
                                                         (((HighVal - Item.PrimaryValue) / HighVal) * 100) + 30)
                    End If
'           '-->b-End Try
                If Err.Number Then Resume EndCatch1
EndCatch1:
                On Error GoTo 0
'           '-->e-End Try

                ' Try
                On Error GoTo Catch2
                    'Alternate bar
                    Set rAlternate = New cRectangle
                    rAlternate.NewRectangle (i * 30) + barData.ValWidth + 25, _
                                            (((HighVal - Item.AlternateValue) / HighVal) * 100) + 40, _
                                            10, _
                                            (Item.AlternateValue / HighVal) * 100
                    
                    'No gradients for gif format
                    If Format = eChartFormat.Gif Then
                        Set bAlternate = New cSolidBrush
                        bAlternate.NewSolidBrush ColorAlternate
                    Else
                        Set bAlternate = New cLinearGradientBrush
                        bAlternate.NewGradientBrush rAlternate, _
                                                    getLightColor(ColorAlternate, 55), _
                                                    getDarkColor(ColorAlternate, 55), _
                                                    eLinearGradientMode.ForwardDiagonal
                    End If
                    objGraphics.FillRectangle bAlternate, rAlternate
                    If ShowValues Then
                        objGraphics.DrawString Item.AlternateValue.ToString, _
                                                tmpFont2, _
                                                BrushValue, _
                                                NewPointF((i * 30) + barData.ValWidth + 30, _
                                                          (((HighVal - Item.AlternateValue) _
                                                                / HighVal) * 100) + 30)
                    End If
                    'Alternate Bar Outline
                    If OutlineBars Then
                        Set rAlternateOutline = New cRectangle
                        rAlternateOutline.NewRectangle (i * 30) + barData.ValWidth + 25, _
                                                       (((HighVal - Item.AlternateValue) / HighVal) * 100) + 40, _
                                                       10, (Item.AlternateValue / HighVal) * 100
                        objGraphics.DrawRectangle objPen, rAlternateOutline
                        Set rAlternateOutline = Nothing
                    End If

Catch2:     '-->Catch
                    'Alternate Bar - Negligable Scaled Value
                    Set tmpPen = New cPen
                    tmpPen.NewPen Me.ColorAlternate
                    Dim aX As Long
                    aX = (i * 30) + barData.ValWidth + 25
                    Dim aY As Long
                    aY = (((HighVal - Item.AlternateValue) / HighVal) * 100) + 40
                    objGraphics.DrawLineL tmpPen, aX, aY, aX + 10, aY
                    If ShowValues Then
                        objGraphics.DrawString Item.AlternateValue.ToString, _
                                               tmpFont2, _
                                               BrushValue, _
                                               NewPointF((i * 30) + barData.ValWidth + 30, _
                                                         (((HighVal - Item.AlternateValue) _
                                                                   / HighVal) * 100) + 30)
                    End If
                    Set tmpPen = Nothing

'           '-->b-End Try
                If Err.Number Then Resume EndCatch2
EndCatch2:
                On Error GoTo 0
'           '-->e-End Try

            Else
                ' Try
                On Error GoTo Catch3
                    'Primary bar
                    Set rPrimary = New cRectangle
                    rPrimary.NewRectangle (i * 20) + barData.ValWidth + 20, _
                                          (((HighVal - Item.PrimaryValue) / HighVal) * 100) + 40, _
                                          10, _
                                          Math.Round((Item.PrimaryValue / HighVal) * 100)
                                        
                    'No gradients for gif format
                    If Format = eChartFormat.Gif Then
                        Set bPrimary = New cSolidBrush
                        bPrimary.NewSolidBrush ColorPrimary
                    Else
                        Set bPrimary = New cLinearGradientBrush
                        bPrimary.NewGradientBrush rPrimary, _
                                                  getLightColor(ColorPrimary, 55), _
                                                  getDarkColor(ColorPrimary, 55), _
                                                  eLinearGradientMode.ForwardDiagonal
                    End If
                    objGraphics.FillRectangle bPrimary, rPrimary
                    If ShowValues Then
                        objGraphics.DrawString Item.PrimaryValue.ToString, _
                                               tmpFont2, _
                                               BrushValue, _
                                               NewPointF((i * 20) + barData.ValWidth + 20, _
                                                         (((HighVal - Item.PrimaryValue) _
                                                                  / HighVal) * 100) + 30)
                    End If
                    'Primary Bar Outline
                    If OutlineBars Then
                        Set rPrimaryOutline = New cRectangle
                        rPrimaryOutline.NewRectangle (i * 20) + barData.ValWidth + 20, _
                                                     (((HighVal - Item.PrimaryValue) / HighVal) * 100) + 40, _
                                                     10, _
                                                     ((Item.PrimaryValue / HighVal) * 100)
                                                   
                        objGraphics.DrawRectangle objPen, rPrimaryOutline
                    End If

Catch3:     '-->Catch
                    'Primary Bar - Negligable Value
                    Set tmpPen = New cPen
                    tmpPen.NewPen Me.ColorPrimary
                    pX = (i * 20) + barData.ValWidth + 20
                    pY = (((HighVal - Item.PrimaryValue) / HighVal) * 100) + 40
                    objGraphics.DrawLineL tmpPen, pX, pY, pX + 10, pY
                    If ShowValues Then
                        objGraphics.DrawString Item.PrimaryValue.ToString, _
                                               tmpFont2, _
                                               BrushValue, _
                                               NewPointF((i * 20) + barData.ValWidth + 20, _
                                               (((HighVal - Item.PrimaryValue) / HighVal) * 100) + 30)
                    End If
'           '-->b-End Try
                If Err.Number Then Resume EndCatch3
EndCatch3:
                On Error GoTo 0
'           '-->e-End Try

            End If
            i = i + 1
        Next
        Set tmpFont2 = Nothing
        Set BrushValue = Nothing

        'Draw Copyright info
        objGraphics.DrawString CopyRight, tmpFont, eBrushes.Silver, _
                               NewPointF(10, barData.ImgHeight - 15)
        
        Select Case m_SaveTo
          Case SaveToStream
            'Copy WebChart to MemoryStream
            Dim memStream As cMemoryStream
            Set memStream = New cMemoryStream
            objBitMap.SaveStream memStream, ImageFormat(Format)
          Case SaveToFile
            objBitMap.SaveFile m_FileName, ImageFormat(Format)
        End Select
        
        objBitMap.Dispose
        objGraphics.Dispose

        Set makeBarChart = memStream
    End Function

    Private Function getPieData() As cCommonData
        Dim pieData         As cCommonData
        Dim Item            As cWebChartItem
        Dim ChartElements   As Long
        Dim rPie            As cRectangles
        Dim bPie            As cIBrush
        
        ChartElements = WebChartItems.Count - 1
        Set pieData = New cCommonData

        Dim i, ColorIndex As Long
        Dim xShift()      As Single
        Dim yShift()      As Single
        Dim PercentVal()  As Single
        Dim StartAngle()  As Single
        Dim SweepAngle()  As Single
        Dim CenterAngle   As Single
        Dim maxXS         As Single
        Dim maxYS         As Single
        Dim minXS         As Single
        Dim minYS         As Single
        Dim Total         As Single
        Dim Color()       As GpGDIPlus.colors

        'Resize local arrays
        Set rPie = New cRectangles
        ReDim xShift(ChartElements)
        ReDim yShift(ChartElements)
        ReDim StartAngle(ChartElements)
        ReDim SweepAngle(ChartElements)
        ReDim PercentVal(ChartElements)
        ReDim Color(ChartElements)

        'Loop through the values to create the Pie Chart.
        Dim Sum               As Single
        Dim sglCurrentAngle   As Single
        Dim sglTotalAngle     As Single

        Sum = 0
        sglCurrentAngle = 0
        sglTotalAngle = 0

        Dim tmpFont     As cFont

        'Sum of Primary Values
        For Each Item In WebChartItems
            Sum = Sum + Item.PrimaryValue
        Next

        'Calculate start, sweep, percent and color
        i = 0
        For Each Item In WebChartItems
            StartAngle(i) = CSng(Total)
            SweepAngle(i) = CSng((Item.PrimaryValue * 360) / Sum)
            PercentVal(i) = CSng(Math.Round((Item.PrimaryValue * 10000 / Sum) / 100, 2))
            Total = Total + (Item.PrimaryValue * 360) / Sum
            If (ColorIndex + 1) >= UBound(PieColors) Then
                ColorIndex = 0
            End If
            Color(i) = PieColors()(ColorIndex)
            ColorIndex = ColorIndex + 1
            i = i + 1
        Next

        'Calculate Exploding Section
        For i = 0 To WebChartItems.Count - 1
            If WebChartItems(i + 1).Explode = True Then
                CenterAngle = (StartAngle(i) + (SweepAngle(i) / 2)) * CSng(PI) / 180
                xShift(i) = CSng(Math.Cos(CenterAngle)) _
                            * CSng(Diameter) _
                            * ExplodeOffset _
                            * 0.5 * 0.01
                            
                yShift(i) = CSng(Math.Sin(CenterAngle)) _
                            * CSng(Diameter) _
                            * Rotate _
                            * ExplodeOffset _
                            * 0.5 _
                            * 0.01 _
                            * 0.01

                If (xShift(i) > maxXS) Then maxXS = xShift(i)
                If (yShift(i) > maxYS) Then maxYS = yShift(i)
                If (xShift(i) < minXS) Then minXS = xShift(i)
                If (yShift(i) < minYS) Then minYS = yShift(i)
            End If
        Next

        For i = 0 To WebChartItems.Count - 1
            If WebChartItems(i + 1).Explode = True Then
                CenterAngle = (StartAngle(i) + (SweepAngle(i) / 2)) * CSng(PI) / 180
                xShift(i) = CSng(Math.Cos(CenterAngle)) _
                            * CSng(Diameter) _
                            * ExplodeOffset _
                            * 0.5 _
                            * 0.01
                yShift(i) = CSng(Math.Sin(CenterAngle)) _
                            * CSng(Diameter) _
                            * Rotate _
                            * ExplodeOffset _
                            * 0.5 _
                            * 0.01 _
                            * 0.01

                If (xShift(i) > maxXS) Then maxXS = xShift(i)
                If (yShift(i) > maxYS) Then maxYS = yShift(i)
                If (xShift(i) < minXS) Then minXS = xShift(i)
                If (yShift(i) < minYS) Then minYS = yShift(i)
            Else
                xShift(i) = 0
                yShift(i) = 0
            End If
            ' Concentric circles
            rPie.Add(Nothing).NewRectangle 10 + xShift(i) - minXS, _
                                           40 + yShift(i) - minYS, _
                                           Diameter, _
                                           Diameter * Rotate * 0.01
        Next

        'Get size of image
        Dim ImgHeight       As Single
        Dim ImgWidth        As Single
        Dim imgLegendHeight As Single
        
        ImgHeight = CSng(Diameter) * (Rotate * 0.01) _
                    + maxYS - minYS _
                    + CSng(Diameter) * CSng(Thickness) * 0.01 _
                    + 65
        imgLegendHeight = imgLegendHeight + CSng(ChartElements) * 15 + 75

        If imgLegendHeight > ImgHeight And ShowLegend Then
            ImgHeight = imgLegendHeight
        End If

        Dim tmpGraphics As cGraphics
        Set tmpGraphics = NewGraphics.FromImage(NewBitmap(1, 1))
        Dim maxNameWidth      As Single
        Dim maxValsWidth      As Single
        Dim maxPercWidth      As Single
        Dim tmpNameWidth      As Single
        Dim tmpValsWidth      As Single
        Dim tmpPercWidth      As Single

        Set tmpFont = New cFont
        tmpFont.NewFont Me.Font.Name, 7


        i = 0
        For Each Item In WebChartItems
            tmpNameWidth = tmpGraphics.MeasureString(Item.PieLabel, tmpFont).Width
            tmpValsWidth = tmpGraphics.MeasureString(Item.PrimaryValue.ToString, tmpFont).Width
            tmpPercWidth = tmpGraphics.MeasureString(PercentVal(i) & Space(5), tmpFont).Width
            i = i + 1
        Next
        
        Set tmpFont = Nothing

        If tmpNameWidth > maxNameWidth Then maxNameWidth = tmpNameWidth
        If tmpValsWidth > maxValsWidth Then maxValsWidth = tmpValsWidth
        If tmpPercWidth > maxPercWidth Then maxPercWidth = tmpPercWidth

        ImgWidth = CSng(Diameter) + ExplodeOffset + 20
        Dim PieWidth As Single
        PieWidth = CSng(Diameter) + maxXS - minXS
        If ShowLegend Then
            ImgWidth = PieWidth + 7 * 2.75 + _
                       47 + maxValsWidth + maxNameWidth + maxPercWidth
        End If

        tmpGraphics.Dispose

        With pieData
            .ImgHeight = ImgHeight
            .ImgWidth = ImgWidth
            .LegendWidth = maxNameWidth
            .PercentWidth = maxPercWidth
            Set .PieRect = rPie
            .PieWidth = PieWidth
            .ValWidth = maxValsWidth
            .StartAngle = StartAngle
            .SweepAngle = SweepAngle
            .PercentVal = PercentVal
            .SecColor = Color
        End With

        Set getPieData = pieData
    End Function

    Private Function makePieChart() As cMemoryStream
        Dim pieData       As cCommonData
        Dim Item          As cWebChartItem
        Dim ChartVals     As Single
        Dim objBitMap     As cBitmap
        Dim objGraphics   As cGraphics
        Dim bPie          As cIBrush

        Set pieData = getPieData()
        ChartVals = WebChartItems.Count - 1
        Set objBitMap = New cBitmap
        objBitMap.NewBitmap pieData.ImgWidth, pieData.ImgHeight, ePixelFormat.Format24bppRGB

        'Pre-render
        Set objGraphics = NewGraphics.FromImage(objBitMap)
        objGraphics.Clear (Me.BackColor)
        objGraphics.SmoothingMode = GpGDIPlus.SmoothingMode.SmoothingModeAntiAlias
        objGraphics.TextRenderingHint = GpGDIPlus.TextRenderingHint.TextRenderingHintAntiAliasGridFit

        Dim fBrush As cIBrush
        Set fBrush = New cSolidBrush
        fBrush.NewSolidBrush Me.ForeColor

        Dim tmpFont As cFont

        Set tmpFont = New cFont
        tmpFont.NewFont Me.Font.Name, 14, eFontStyle.Bold

        'Write out shaded graph title
        If ShowTitle Then
            objGraphics.DrawString Title, tmpFont, eBrushes.Gainsboro, NewPointF(11, 7)
            objGraphics.DrawString Title, tmpFont, fBrush, NewPointF(10, 5)
        End If
        
        Set tmpFont = Nothing

        Dim PieRect As cRectangle
        Dim i As Long
        Dim j As Long

        i = 0
        j = 0

        'Concentric Circles for 3D depth
        If Thickness <> ePieThickness.None Then
            For j = CInt(Diameter * Thickness * 0.01) To 0 Step -1
                For i = 0 To WebChartItems.Count - 1
                    Set PieRect = New cRectangle
                    PieRect.NewRectangle pieData.PieRect(i + 1).X, _
                                         CInt(pieData.PieRect(i + 1).Y + CSng(j)), _
                                         pieData.PieRect(i + 1).Width, _
                                         pieData.PieRect(i + 1).Height
                    
                    objGraphics.FillPie NewHatchBrush(eHatchStyle.Percent50, _
                                                      pieData.SecColor()(i) _
                                        ), _
                                        PieRect, _
                                        pieData.StartAngle()(i), _
                                        pieData.SweepAngle()(i)
                Next
            Next
        End If

        'Top Layer of Circle
        For j = CInt(Diameter * 0.01) To 0 Step -1
            For i = 0 To WebChartItems.Count - 1
                Set PieRect = New cRectangle
                PieRect.NewRectangle pieData.PieRect(i + 1).X, _
                                     CInt(pieData.PieRect(i + 1).Y + CSng(j)), _
                                     pieData.PieRect(i + 1).Width, _
                                     pieData.PieRect(i + 1).Height
                If Format = eChartFormat.Gif Then
                    Set bPie = New cSolidBrush
                    bPie.NewSolidBrush pieData.SecColor()(i)
                Else
                    Set bPie = New cLinearGradientBrush
                    bPie.NewGradientBrush PieRect, _
                                          getLightColor(pieData.SecColor()(i), 55), _
                                          getDarkColor(pieData.SecColor()(i), 55), _
                                          eLinearGradientMode.ForwardDiagonal
                End If
                objGraphics.FillPie bPie, _
                                    PieRect, _
                                    pieData.StartAngle()(i), _
                                    pieData.SweepAngle()(i)
            Next
        Next

        Set tmpFont = New cFont
        tmpFont.NewFont Me.Font.Name, 7

        'Build Legend if specified
        If ShowLegend Then
            Dim rPrimary    As cRectangle
            Dim bPrimary    As cIBrush
            Dim pSymbol     As cPointF
            Dim pSymbolDesc As cPointF
            
            Set pSymbol = NewPointF(pieData.PieWidth + 40, 40)
            Set pSymbolDesc = NewPointF(pieData.PieWidth + 55, 40)
            
            Dim tmpPen As cPen
            Set tmpPen = New cPen
            tmpPen.NewPen Me.ForeColor
            
            i = 0 'Reset Counter
            For Each Item In WebChartItems
                'Primary Symbol
                Set rPrimary = New cRectangle
                rPrimary.NewRectangle pSymbol.X, pSymbol.Y, 10, 10
                
                If Format = eChartFormat.Gif Then
                    Set bPrimary = New cSolidBrush
                    bPrimary.NewSolidBrush pieData.SecColor()(i)
                Else
                    Set bPrimary = New cLinearGradientBrush
                    bPrimary.NewGradientBrush rPrimary, _
                                              getLightColor(pieData.SecColor()(i), 55), _
                                              getDarkColor(pieData.SecColor()(i), 55), _
                                              eLinearGradientMode.ForwardDiagonal
                End If
                objGraphics.FillRectangle bPrimary, rPrimary
                objGraphics.DrawString Item.PieLabel & " (" & pieData.PercentVal()(i) & "%)", _
                                       tmpFont, _
                                       eBrushes.Black, _
                                       pSymbolDesc
                'Primary Symbol Outline
                If OutlineBars Then
                    Dim rPrimaryOutline As cRectangle
                    Set rPrimaryOutline = New cRectangle
                    rPrimaryOutline.NewRectangle pSymbol.X, pSymbol.Y, 10, 10
                    objGraphics.DrawRectangle tmpPen, rPrimaryOutline
                End If
                pSymbol.Y = pSymbol.Y + 15
                pSymbolDesc.Y = pSymbolDesc.Y + 15
                i = i + 1
            Next
            
            Set tmpPen = Nothing
        End If

        'Draw Copyright info
        objGraphics.DrawString CopyRight, tmpFont, eBrushes.Silver, _
                               NewPointF(10, pieData.ImgHeight - 15)
        
        Select Case m_SaveTo
          Case SaveToStream
            'Copy WebChart to MemoryStream
            Dim memStream As cMemoryStream
            Set memStream = New cMemoryStream
            objBitMap.SaveStream memStream, ImageFormat(Format)
          Case SaveToFile
            objBitMap.SaveFile m_FileName, ImageFormat(Format)
        End Select
        
        objBitMap.Dispose
        objGraphics.Dispose
        
        Set tmpFont = Nothing

        Set makePieChart = memStream
    End Function

    Private Function getDarkColor(ByVal Color As GpGDIPlus.colors, ByVal d As Byte) As GpGDIPlus.colors
        Dim R As Byte
        Dim G As Byte
        Dim B As Byte
        
        Dim c As cColor
        Set c = New cColor
        
        c.FromRGBColor Color

        If (c.R > d) Then R = (c.R - d)
        If (c.G > d) Then G = (c.G - d)
        If (c.B > d) Then B = (c.B - d)

        getDarkColor = c.FromRGB(R, G, B)
    End Function

    Private Function getLightColor(ByVal Color As GpGDIPlus.colors, ByVal d As Byte) As GpGDIPlus.colors
        Dim R As Byte
        Dim G As Byte
        Dim B As Byte

        Dim c As cColor
        Set c = New cColor
        
        c.FromRGBColor Color

        R = 255
        G = 255
        B = 255

        If (CInt(c.R) + CInt(d) <= 255) Then R = (c.R + d)
        If (CInt(c.G) + CInt(d) <= 255) Then G = (c.G + d)
        If (CInt(c.B) + CInt(d) <= 255) Then B = (c.B + d)

        getLightColor = c.FromRGB(R, G, B)
    End Function

    Private Function ImageFormat(ByVal enumFormat As eChartFormat) As eImageFormat
        Dim imgFormat As eImageFormat
        Select Case enumFormat
            Case eChartFormat.Bmp
                imgFormat = eImageFormat.Bmp
            Case eChartFormat.Gif
                imgFormat = eImageFormat.Gif
            Case eChartFormat.Jpeg
                imgFormat = eImageFormat.Jpeg
            Case eChartFormat.Png
                imgFormat = eImageFormat.Png
            Case Else
                imgFormat = eImageFormat.Gif
        End Select
        ImageFormat = imgFormat
    End Function

'#End Region

'#Region " Aux "
    
    Public Sub Dispose()
      m_BaseClass.Dispose
      m_WebChartItems.Dispose
      m_Font.Dispose
      GDIPlusTerminate
    End Sub

'#End Region


Private Sub Class_Initialize()
  Set m_BaseClass = New cWebControl
  Set m_WebChartItems = New cWebChartItemCollection
  Set m_Font = New cFont
  m_WebChartItems.NewCollOwner Me
  m_ChartTitle = "Chart Title"

  m_ChartShowValues = False
  m_ChartBarOutline = True
  m_ChartShowTitle = True
  m_ChartType = eChartType.Bar
  m_ChartLineStyle = eLineStyle.Both
  m_ChartPrimaryColor = GpGDIPlus.colors.DarkBlue
  m_ChartAltColor = GpGDIPlus.colors.CornflowerBlue
  m_ImageFormat = eChartFormat.Gif
  m_ChartLegend = True
  m_PrimaryLabel = "Label A"
  m_AltLabel = "Label B"

  m_Copyright = "Copyright © " & Year(Date) & " YOU"
  
  'Chart data fields - Pie Chart
  m_ColorIndex = 0
  m_PieDiameter = ePieDiameter.Medium
  m_PieRotation = 70
  m_PieThickness = ePieThickness.Medium
  m_PieExplode = False
  m_PieExplodeOffset = 25

End Sub

Private Sub Class_Terminate()
  Dispose
  Set m_BaseClass = Nothing
  Set m_WebChartItems = Nothing
  Set m_Font = Nothing
End Sub
