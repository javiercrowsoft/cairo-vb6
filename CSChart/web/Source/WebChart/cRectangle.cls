VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRectangle"
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

Implements cRectangleF

Private m_Rectangle                     As GpGDIPlus.cRect
Private m_Location                      As cPoint

'-----------------------------------------------------------
' LEFT
'
Public Property Get Left() As Long
   Left = m_Rectangle.Left
End Property

Public Property Let Left(ByVal rhs As Long)
   m_Rectangle.Left = rhs
   m_Location.X = rhs
End Property

  Public Property Get X() As Long
     X = m_Rectangle.Left
  End Property
  
  Public Property Let X(ByVal rhs As Long)
     Left = rhs
  End Property

'-----------------------------------------------------------
' WIDTH
'
Public Property Get Width() As Long
   Width = m_Rectangle.Width
End Property

Public Property Let Width(ByVal rhs As Long)
   m_Rectangle.Width = rhs
End Property

  Public Property Get Right() As Long
     Right = m_Rectangle.Right
  End Property
  
  Public Property Let Right(ByVal rhs As Long)
     m_Rectangle.Width = rhs - m_Rectangle.Left
  End Property

'-----------------------------------------------------------
' HEIGHT
'
Public Property Get Height() As Long
   Height = m_Rectangle.Height
End Property

Public Property Let Height(ByVal rhs As Long)
   m_Rectangle.Height = rhs
End Property

  Public Property Get Bottom() As Long
     Bottom = m_Rectangle.Bottom
  End Property
  
  Public Property Let Bottom(ByVal rhs As Long)
     m_Rectangle.Height = rhs - m_Rectangle.Top
  End Property

'-----------------------------------------------------------
' TOP
'
Public Property Get Top() As Long
   Top = m_Rectangle.Top
End Property

Public Property Let Top(ByVal rhs As Long)
   m_Rectangle.Top = rhs
   m_Location.Y = rhs
End Property

  Public Property Get Y() As Long
     Y = m_Rectangle.Top
  End Property
  
  Public Property Let Y(ByVal rhs As Long)
     Top = rhs
  End Property

'-----------------------------------------------------------
' LOCATION
'
Public Property Get Location() As cPoint
   Set Location = m_Location
End Property

Public Property Set Location(ByRef rhs As cPoint)
   Set m_Location = rhs
End Property

Public Property Get Rectangle() As GpGDIPlus.cRect
  Set Rectangle = m_Rectangle
End Property

Public Function NewRectangle(ByVal X As Long, ByVal Y As Long, _
                             ByVal Width As Long, ByVal Height As Long) As cRectangle

  m_Rectangle.Create X, Y, Width, Height
  Set NewRectangle = Me
End Function

Private Sub Class_Initialize()
  Set m_Rectangle = New GpGDIPlus.cRect
  Set m_Location = New cPoint
End Sub

Private Sub Class_Terminate()
  Set m_Rectangle = Nothing
  Set m_Location = Nothing
End Sub

'-----------------------------------------------------------------------------------------------
' Intefaz cRectangleF
'
Private Property Let cRectangleF_Bottom(ByVal rhs As Single)
  Bottom = rhs
End Property

Private Property Get cRectangleF_Bottom() As Single
  cRectangleF_Bottom = Bottom
End Property

Private Property Let cRectangleF_Height(ByVal rhs As Single)
  Height = rhs
End Property

Private Property Get cRectangleF_Height() As Single
  cRectangleF_Height = Height
End Property

Private Property Let cRectangleF_Left(ByVal rhs As Single)
  Left = rhs
End Property

Private Property Get cRectangleF_Left() As Single
  cRectangleF_Left = Left
End Property

Private Property Set cRectangleF_Location(rhs As cPointF)
  m_Location.NewPoint rhs.X, rhs.Y
End Property

Private Property Get cRectangleF_Location() As cPointF
  Dim rtn As cPointF
  Set rtn = New cPointF
  rtn.NewPointF Location.X, Location.Y
  Set Location = rtn
End Property

Private Function cRectangleF_NewRectangle(ByVal X As Single, ByVal Y As Single, ByVal Width As Single, ByVal Height As Single) As cRectangleF
  Set cRectangleF_NewRectangle = NewRectangle(X, Y, Width, Height)
End Function

Private Property Get cRectangleF_Rectangle() As GpGDIPlus.cRectF
  Dim rtn As GpGDIPlus.cRectF
  Set rtn = New GpGDIPlus.cRectF
  rtn.Create Left, Top, Width, Height
  Set cRectangleF_Rectangle = rtn
End Property

Private Property Let cRectangleF_Right(ByVal rhs As Single)
  Right = rhs
End Property

Private Property Get cRectangleF_Right() As Single
  cRectangleF_Right = Right
End Property

Private Property Let cRectangleF_Top(ByVal rhs As Single)
  Top = rhs
End Property

Private Property Get cRectangleF_Top() As Single
  cRectangleF_Top = Top
End Property

Private Property Let cRectangleF_Width(ByVal rhs As Single)
  Width = rhs
End Property

Private Property Get cRectangleF_Width() As Single
  cRectangleF_Width = Width
End Property

Private Property Let cRectangleF_X(ByVal rhs As Single)
  X = rhs
End Property

Private Property Get cRectangleF_X() As Single
  cRectangleF_X = X
End Property

Private Property Let cRectangleF_Y(ByVal rhs As Single)
  Y = rhs
End Property

Private Property Get cRectangleF_Y() As Single
  cRectangleF_Y = Y
End Property
