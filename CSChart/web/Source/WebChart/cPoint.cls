VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPoint"
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

Private m_Point               As GpGDIPlus.cPoint

Public Property Get X() As Single
   X = m_Point.X
End Property

Public Property Let X(ByVal rhs As Single)
   m_Point.X = rhs
End Property

Public Property Get Y() As Single
   Y = m_Point.Y
End Property

Public Property Let Y(ByVal rhs As Single)
   m_Point.Y = rhs
End Property

Public Property Get Point() As GpGDIPlus.cPoint
  Set Point = m_Point
End Property

Public Function NewPoint(ByVal X As Single, ByVal Y As Single) As cPoint
  m_Point.X = X
  m_Point.Y = Y
  Set NewPoint = Me
End Function

Private Sub Class_Initialize()
  Set m_Point = New GpGDIPlus.cPoint
End Sub

Private Sub Class_Terminate()
  Set m_Point = Nothing
End Sub
