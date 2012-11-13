VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRectangles"
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

Private m_coll              As Collection

Public Function Add(ByRef rect As cRectangle) As cRectangle
  If rect Is Nothing Then Set rect = New cRectangle
  m_coll.Add rect
  Set Add = rect
End Function

Public Function AddF(ByRef rect As cRectangleF) As cRectangleF
  If rect Is Nothing Then Set rect = New cRectangleF
  Set AddF = rect
End Function

Public Function Count() As Long
  Count = m_coll.Count
End Function

Public Function Item(ByVal idx As Variant) As Object
Attribute Item.VB_UserMemId = 0
  Set Item = m_coll(idx)
End Function

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
  Set NewEnum = m_coll.[_NewEnum]
End Function

Private Sub Class_Initialize()
  Set m_coll = New Collection
End Sub

Private Sub Class_Terminate()
  Set m_coll = Nothing
End Sub
