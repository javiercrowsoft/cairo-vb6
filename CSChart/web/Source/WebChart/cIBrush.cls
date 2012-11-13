VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIBrush"
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

Public Enum eBrushes
  Gainsboro = &HFFDCDCDC
  Black = &HFF000000
  Silver = &HFFC0C0C0
End Enum

Public Enum eLinearGradientMode
  Horizontal
  Vertical
  ForwardDiagonal
  BackwardDiagonal
End Enum

Public Enum eHatchStyle
  Percent50
End Enum

Public Function Brush() As GpGDIPlus.cBrush

End Function

Public Function NewSolidBrush(ByVal Color As GpGDIPlus.colors) As cIBrush

End Function

Public Function NewGradientBrush(ByVal rect As cRectangleF, _
                                 ByVal color1 As GpGDIPlus.colors, _
                                 ByVal color2 As GpGDIPlus.colors, _
                                 ByVal linearGradientMode As eLinearGradientMode) As cIBrush

End Function

Public Function NewHatchBrush(ByVal HatchStyle As eHatchStyle, _
                              ByVal ForeColor As GpGDIPlus.colors) As cIBrush
                        
End Function

Public Sub Dispose()

End Sub
