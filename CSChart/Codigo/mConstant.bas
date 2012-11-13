Attribute VB_Name = "mConstant"
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


' WebChartImageStream
    Public Const HandlerFileName As String = "webchart_image_processor.aspx"
    Public Const ChartNamePrefixInApplication As String = "C#H#R#"

' Exception HResults
Public Const E_POINTER                  As Long = &H5B
Public Const COR_E_ARGUMENT             As Long = &H5
Public Const COR_E_SYSTEM               As Long = &H80131501
Public Const COR_E_INVALIDOPERATION     As Long = &H5
Public Const COR_E_NOTSUPPORTED         As Long = &H1B6
Public Const COR_E_ARGUMENTOUTOFRANGE   As Long = &H5
Public Const COR_E_EXCEPTION            As Long = &H80131500

' ArgumentOutOfRange
Public Const ArgumentOutOfRange_NeedNonNegNum           As Long = 1002
Public Const ArgumentOutOfRange_LBound                  As Long = 1006
' ArgumentNull
Public Const ArgumentNull_Array                         As Long = 2100
' Argument
Public Const Argument_InvalidCountOffset                As Long = 2000
Public Const ArgumentNull_Exception                     As Long = 2101
