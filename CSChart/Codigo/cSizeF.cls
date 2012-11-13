VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSizeF"
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

Private m_SizeF              As GpGDIPlus.cSizeF

Public Property Get Height() As Single
   Height = m_SizeF.Height
End Property

Public Property Let Height(ByVal rhs As Single)
   m_SizeF.Height = rhs
End Property

Public Property Get Width() As Single
   Width = m_SizeF.Width
End Property

Public Property Let Width(ByVal rhs As Single)
   m_SizeF.Width = rhs
End Property

Public Property Get SizeF() As GpGDIPlus.cSizeF
  Set SizeF = m_SizeF
End Property

Public Function NewSizeF(ByVal Width As Single, ByVal Height As Single) As cSizeF
  m_SizeF.Width = Width
  m_SizeF.Height = Height
  Set NewSizeF = Me
End Function

Public Function ToPointF() As cPointF
  Dim rtn As cPointF
  Set rtn = New cPointF
  
  rtn.NewPointF m_SizeF.Width, m_SizeF.Height
  Set ToPointF = rtn
End Function

Private Sub Class_Initialize()
  Set m_SizeF = New GpGDIPlus.cSizeF
End Sub

Private Sub Class_Terminate()
  Set m_SizeF = Nothing
End Sub
