VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cColor"
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

Private m_R                             As Long
Private m_G                             As Long
Private m_B                             As Long

Public Property Get R() As Long
   R = m_R
End Property

Public Property Let R(ByVal rhs As Long)
   m_R = rhs
End Property

Public Property Get G() As Long
   G = m_G
End Property

Public Property Let G(ByVal rhs As Long)
   m_G = rhs
End Property

Public Property Get B() As Long
   B = m_B
End Property

Public Property Let B(ByVal rhs As Long)
   m_B = rhs
End Property

Public Function FromRGB(ByVal Red As Long, ByVal Green As Long, ByVal Blue As Long) As GpGDIPlus.colors
  Dim Color As GpGDIPlus.cColor
  Set Color = New GpGDIPlus.cColor
  Color.FromRGB Red, Green, Blue
  FromRGB = Color.ToCOLORREF()
  Set Color = Nothing
End Function

Public Function FromRGBColor(ByVal rgb As Long) As GpGDIPlus.colors
  Dim Color As GpGDIPlus.cColor
  Set Color = New GpGDIPlus.cColor
  Color.FromRGBColor rgb
  m_G = Color.GetGreen
  m_B = Color.GetBlue
  m_R = Color.GetGreen
  FromRGBColor = Color.ToCOLORREF
  Set Color = Nothing
End Function

