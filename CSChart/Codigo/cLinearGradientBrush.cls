VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cLinearGradientBrush"
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

Implements cIBrush

Private m_Brush               As GpGDIPlus.cLinearGradientBrush

Public Function NewLinearGradient(ByVal rect As cRectangleF, _
                                  ByVal color1 As GpGDIPlus.colors, _
                                  ByVal color2 As GpGDIPlus.colors, _
                                  ByVal linearGradientMode As eLinearGradientMode) As cLinearGradientBrush
  Dim oColor1 As GpGDIPlus.cColor
  Dim oColor2 As GpGDIPlus.cColor
  Set oColor1 = New GpGDIPlus.cColor
  Set oColor2 = New GpGDIPlus.cColor
  oColor1.FromRGBColor color1
  oColor2.FromRGBColor color2
  m_Brush.CreateLineBrushFromRectF rect.Rectangle, oColor1, oColor2, LinearGradientModeBackwardDiagonal
  Set NewLinearGradient = Me
End Function

Public Sub Dispose()
  m_Brush.DisposeLinearGradientBrush
End Sub

Private Function cIBrush_Brush() As GpGDIPlus.cBrush
  Set cIBrush_Brush = m_Brush.Brush
End Function

Private Sub cIBrush_Dispose()
  Dispose
End Sub

Private Function cIBrush_NewSolidBrush(ByVal Color As GpGDIPlus.colors) As cIBrush
' not used
End Function

Private Function cIBrush_NewGradientBrush(ByVal rect As cRectangleF, _
                                          ByVal color1 As GpGDIPlus.colors, _
                                          ByVal color2 As GpGDIPlus.colors, _
                                          ByVal linearGradientMode As eLinearGradientMode) As cIBrush
  Set cIBrush_NewGradientBrush = NewLinearGradient(rect, color1, color2, linearGradientMode)
End Function

Private Function cIBrush_NewHatchBrush(ByVal HatchStyle As eHatchStyle, _
                                       ByVal ForeColor As GpGDIPlus.colors) As cIBrush
' not used
End Function

Private Sub Class_Initialize()
  Set m_Brush = New GpGDIPlus.cLinearGradientBrush
End Sub

Private Sub Class_Terminate()
  Dispose
  Set m_Brush = Nothing
End Sub
