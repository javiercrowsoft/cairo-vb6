VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRectangleF"
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

Private m_Rectangle                     As GpGDIPlus.cRectF
Private m_Location                      As cPointF

'-----------------------------------------------------------
' LEFT
'
Public Property Get Left() As Single
   Left = m_Rectangle.Left
End Property

Public Property Let Left(ByVal rhs As Single)
   m_Rectangle.Left = rhs
   m_Location.X = rhs
End Property

  Public Property Get X() As Single
     X = m_Rectangle.Left
  End Property
  
  Public Property Let X(ByVal rhs As Single)
     Left = rhs
  End Property

'-----------------------------------------------------------
' WIDTH
'
Public Property Get Width() As Single
   Width = m_Rectangle.Width
End Property

Public Property Let Width(ByVal rhs As Single)
   m_Rectangle.Width = rhs
End Property

  Public Property Get Right() As Single
     Right = m_Rectangle.Right
  End Property
  
  Public Property Let Right(ByVal rhs As Single)
     m_Rectangle.Width = rhs - m_Rectangle.Left
  End Property

'-----------------------------------------------------------
' HEIGHT
'
Public Property Get Height() As Single
   Height = m_Rectangle.Height
End Property

Public Property Let Height(ByVal rhs As Single)
   m_Rectangle.Height = rhs
End Property

  Public Property Get Bottom() As Single
     Bottom = m_Rectangle.Bottom
  End Property
  
  Public Property Let Bottom(ByVal rhs As Single)
     m_Rectangle.Height = rhs - m_Rectangle.Top
  End Property

'-----------------------------------------------------------
' TOP
'
Public Property Get Top() As Single
   Top = m_Rectangle.Top
End Property

Public Property Let Top(ByVal rhs As Single)
   m_Rectangle.Top = rhs
   m_Location.Y = rhs
End Property

  Public Property Get Y() As Single
     Y = m_Rectangle.Top
  End Property
  
  Public Property Let Y(ByVal rhs As Single)
     Top = rhs
  End Property

'-----------------------------------------------------------
' LOCATION
'
Public Property Get Location() As cPointF
   Set Location = m_Location
End Property

Public Property Set Location(ByRef rhs As cPointF)
   Set m_Location = rhs
End Property

Public Property Get Rectangle() As GpGDIPlus.cRectF
  Set Rectangle = m_Rectangle
End Property

Public Function NewRectangle(ByVal X As Single, ByVal Y As Single, _
                             ByVal Width As Single, ByVal Height As Single) As cRectangleF

  m_Rectangle.Create X, Y, Width, Height
  Set NewRectangle = Me
End Function

Private Sub Class_Initialize()
  Set m_Rectangle = New GpGDIPlus.cRectF
  Set m_Location = New cPointF
End Sub

Private Sub Class_Terminate()
  Set m_Rectangle = Nothing
  Set m_Location = Nothing
End Sub
