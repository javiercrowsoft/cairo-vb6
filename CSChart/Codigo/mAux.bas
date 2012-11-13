Attribute VB_Name = "mAux"
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

Public Const PI As Double = 3.14159265358979 '4 * Atn(1)

Public System                       As cSystem
Public Color                        As cColor
Public ChartFormat                  As cChartFormat

Public Function NewPoint(ByVal X As Long, ByVal Y As Long) As cPoint
  Dim rtn As cPoint
  Set rtn = New cPoint
  rtn.NewPoint X, Y
  Set NewPoint = rtn
End Function

Public Function NewPointF(ByVal X As Single, ByVal Y As Single) As cPointF
  Dim rtn As cPointF
  Set rtn = New cPointF
  rtn.NewPointF X, Y
  Set NewPointF = rtn
End Function

Public Function NewSizeF(ByVal X As Single, ByVal Y As Single) As cSizeF
  Dim rtn As cSizeF
  Set rtn = New cSizeF
  rtn.NewSizeF X, Y
  Set NewSizeF = rtn
End Function

Public Function NewBitmap(ByVal Width As Long, ByVal Height As Long) As cBitmap
  Dim rtn As cBitmap
  Set rtn = New cBitmap
  Set NewBitmap = rtn.NewBitmap(Width, Height)
End Function

Public Function NewHatchBrush(ByVal HatchStyle As eHatchStyle, _
                              ByVal ForeColor As GpGDIPlus.colors) As cIBrush
  Dim rtn As cHatchBrush
  Set rtn = New cHatchBrush
  Set NewHatchBrush = rtn.NewHatch(HatchStyle, ForeColor)
End Function

Function NewGraphics() As cGraphics
  Set NewGraphics = New cGraphics
End Function

Public Sub Main()
  WebChartInitialize
End Sub

Public Sub WebChartInitialize()
  Set System = New cSystem
  Set Color = New cColor
  Set ChartFormat = New cChartFormat
End Sub

Public Function Zdiv(ByVal x1 As Double, ByVal x2 As Double) As Double
  If x2 <> 0 Then
    Zdiv = x1 / x2
  Else
    Zdiv = 0
  End If
End Function

