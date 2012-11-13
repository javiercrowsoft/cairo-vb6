VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCommonData"
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

Private m_ImgWidth                      As Single
Private m_ImgHeight                     As Single
Private m_LegendWidth                   As Single
Private m_ValWidth                      As Single
Private m_PercentWidth                  As Single
Private m_PieRect                       As cRectangles
Private m_PieWidth                      As Single
Private m_StartAngle()                  As Single
Private m_SweepAngle()                  As Single
Private m_PercentVal()                  As Single
Private m_SecColor()                    As GpGDIPlus.colors

Public Property Get ImgWidth() As Single
  ImgWidth = m_ImgWidth
End Property

Public Property Let ImgWidth(ByVal rhs As Single)
  m_ImgWidth = rhs
End Property

Public Property Get ImgHeight() As Single
  ImgHeight = m_ImgHeight
End Property

Public Property Let ImgHeight(ByVal rhs As Single)
  m_ImgHeight = rhs
End Property

Public Property Get LegendWidth() As Single
  LegendWidth = m_LegendWidth
End Property

Public Property Let LegendWidth(ByVal rhs As Single)
  m_LegendWidth = rhs
End Property

Public Property Get ValWidth() As Single
  ValWidth = m_ValWidth
End Property

Public Property Let ValWidth(ByVal rhs As Single)
  m_ValWidth = rhs
End Property

Public Property Get PercentWidth() As Single
  PercentWidth = m_PercentWidth
End Property

Public Property Let PercentWidth(ByVal rhs As Single)
  m_PercentWidth = rhs
End Property

Public Property Get PieRect() As cRectangles
  Set PieRect = m_PieRect
End Property

Public Property Set PieRect(ByRef rhs As cRectangles)
  Set m_PieRect = rhs
End Property

Public Property Get PieWidth() As Single
  PieWidth = m_PieWidth
End Property

Public Property Let PieWidth(ByVal rhs As Single)
  m_PieWidth = rhs
End Property

Public Property Get StartAngle() As Single()
  StartAngle = m_StartAngle
End Property

Public Property Let StartAngle(ByRef rhs() As Single)
  m_StartAngle = rhs
End Property

Public Property Get SweepAngle() As Single()
  SweepAngle = m_SweepAngle
End Property

Public Property Let SweepAngle(ByRef rhs() As Single)
  m_SweepAngle = rhs
End Property

Public Property Get PercentVal() As Single()
  PercentVal = m_PercentVal
End Property

Public Property Let PercentVal(ByRef rhs() As Single)
  m_PercentVal = rhs
End Property

Friend Property Get SecColor() As GpGDIPlus.colors()
  SecColor = m_SecColor
End Property

Friend Property Let SecColor(ByRef rhs() As GpGDIPlus.colors)
  m_SecColor = rhs
End Property


