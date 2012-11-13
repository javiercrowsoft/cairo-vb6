VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cWebChartItemCollection"
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

'Imports System

'<Serializable()> _
'Public Class cWebChartItemCollection : Inherits System.Collections.CollectionBase

    Private m_Owner As cWebChart


Private m_coll              As Collection

Public Property Get Count() As Integer
  Count = m_coll.Count
End Property

Public Sub Dispose()
  Set m_Owner = Nothing
End Sub

    Public Sub NewColl()
      Set m_coll = New Collection
    End Sub

    Public Sub NewCollOwner(ByVal Owner As cWebChart)
        NewColl
        Set m_Owner = Owner
    End Sub

    Private Property Get Owner() As cWebChart
            Set Owner = m_Owner
    End Property
    Private Property Set Owner(ByVal Value As cWebChart)
            Set m_Owner = Value
    End Property

    Public Property Get Item(ByVal index As Long) As cWebChartItem
Attribute Item.VB_UserMemId = 0
            Set Item = m_coll.Item(index)
    End Property

    Public Function Add(ByVal Item As cWebChartItem) As Integer
        If Item Is Nothing Then Set Item = New cWebChartItem
        m_coll.Add Item
        Add = m_coll.Count
    End Function


Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
  Set NewEnum = m_coll.[_NewEnum]
End Function

Private Sub Class_Initialize()
  Set m_coll = New Collection
End Sub

Private Sub Class_Terminate()
  Dispose
  Set m_coll = Nothing
End Sub
