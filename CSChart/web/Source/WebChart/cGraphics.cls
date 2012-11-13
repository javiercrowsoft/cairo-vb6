VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGraphics"
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

Private m_Graphics            As GpGDIPlus.cGraphics

Public Property Get SmoothingMode() As GpGDIPlus.SmoothingMode
  SmoothingMode = m_Graphics.GetSmoothingMode()
End Property

Public Property Let SmoothingMode(ByVal rhs As GpGDIPlus.SmoothingMode)
  m_Graphics.SetSmoothingMode rhs
End Property

Public Property Get TextRenderingHint() As GpGDIPlus.TextRenderingHint
  TextRenderingHint = m_Graphics.GetTextRenderingHint
End Property

Public Property Let TextRenderingHint(ByVal rhs As GpGDIPlus.TextRenderingHint)
  m_Graphics.SetTextRenderingHint rhs
End Property

Public Function FromImage(ByVal Image As cBitmap) As cGraphics
  m_Graphics.FromImage Image.Bitmap.Image
  Set FromImage = Me
End Function

Public Function MeasureString(ByVal str As String, _
                              ByVal Font As cFont) As cSizeF
  Dim rtn As cSizeF
  Set rtn = New cSizeF
  m_Graphics.MeasureStringSizeFormat str, Len(str), Font.Font, NewSizeF(0, 0).SizeF, Nothing, rtn.SizeF
  Set MeasureString = rtn
End Function

Public Sub Dispose()
  m_Graphics.DisposeGraphics
End Sub

Public Sub Clear(ByVal lcolor As Long)
  Dim Color As GpGDIPlus.cColor
  Set Color = New GpGDIPlus.cColor
  Color.FromRGBColor lcolor
  m_Graphics.Clear Color
End Sub

Public Sub DrawString(ByVal Text As String, _
                      ByVal Font As cFont, _
                      ByVal vBrush As Variant, _
                      ByVal Point As cPointF)
  Dim Brush As cIBrush
  
  If VarType(vBrush) = vbObject Then
    Set Brush = vBrush
  Else
    Set Brush = New cSolidBrush
    Brush.NewSolidBrush vBrush
  End If
  
  m_Graphics.DrawStringPointF Text, Len(Text), Font.Font, Point.Point, Brush.Brush
End Sub

Public Sub FillRectangle(ByVal Brush As cIBrush, _
                         ByVal rect As cRectangle)
  m_Graphics.FillRectangleRectL Brush.Brush, rect.Rectangle
End Sub

Public Sub DrawRectangle(ByVal Pen As cPen, _
                         ByVal rect As cRectangle)
  m_Graphics.DrawRectangleRectL Pen.Pen, rect.Rectangle
End Sub

Public Sub DrawLinePoint(ByVal Pen As cPen, _
                         ByVal pt1 As cPoint, _
                         ByVal pt2 As cPoint)
  
  m_Graphics.DrawLinePointL Pen.Pen, pt1.Point, pt2.Point
End Sub

Public Sub DrawLineL(ByVal Pen As cPen, _
                     ByVal pX1 As Long, _
                     ByVal pY1 As Long, _
                     ByVal pX2 As Long, _
                     ByVal pY2 As Long)

  m_Graphics.DrawLineL Pen.Pen, pX1, pY1, pX2, pY2
End Sub

Public Sub FillPie(ByVal Brush As cIBrush, _
                   ByVal rect As cRectangle, _
                   ByVal StartAngle As Single, _
                   ByVal SweepAngle As Single)
  m_Graphics.FillPieRectL Brush.Brush, rect.Rectangle, StartAngle, SweepAngle
End Sub

Private Sub Class_Initialize()
  Set m_Graphics = New GpGDIPlus.cGraphics
End Sub

Private Sub Class_Terminate()
  Dispose
  Set m_Graphics = Nothing
End Sub
