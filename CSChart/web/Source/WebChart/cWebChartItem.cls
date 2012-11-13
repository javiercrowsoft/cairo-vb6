VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cWebChartItem"
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
'Imports System.Data
'Imports System.Web.UI
'Imports System.ComponentModel
'Imports System.ComponentModel.Design
'Imports System.ComponentModel.Design.Serialization
'Imports System.Globalization
'Imports Microsoft.VisualBasic

'<Serializable(), TypeConverter(GetType(WebChartItem.WebChartConverter)), PersistenceMode(PersistenceMode.InnerDefaultProperty)> _
'    Public Class WebChartItem

    ' Default Values
    Private Const dPrimaryValue     As Single = 0#
    Private Const dAltValue         As Single = 0#
    Private Const dChartExplode     As Boolean = False
    Private Const dPieLabel         As String = "Label"

    ' Chart data fields - All Charts
    Private m_PrimaryValue    As cObject
    Private m_AltValue        As cObject
    Private m_ChartExplode    As Boolean
    Private m_PieLabel        As String

    'Bar Chart Constructor
    Sub Construct2(ByVal BarValueA As Single, ByVal BarValueB As Single)
        m_PrimaryValue = BarValueA
        m_AltValue = BarValueB
    End Sub

    'Pie Chart Constructor
    Sub Construct3(ByVal PieLabel As String, ByVal PieValue As Single, ByVal Explode As Boolean)
        m_PieLabel = PieLabel
        m_PrimaryValue = PieValue
        m_ChartExplode = Explode
    End Sub

    Public Function ToString() As String
        ToString = "Chart Item"
    End Function

'    <DefaultValue(dPrimaryValue), DesignerSerializationVisibility(DesignerSerializationVisibility.Visible)>
    Public Property Get PrimaryValue() As Variant
            Set PrimaryValue = m_PrimaryValue
    End Property
    Public Property Let PrimaryValue(ByVal Value As Variant)
            If VarType(Value) = vbObject Then
              Set m_PrimaryValue = Value
            Else
              If m_PrimaryValue Is Nothing Then
                Set m_PrimaryValue = New cObject
              End If
              m_PrimaryValue.Value = CSng(Value)
            End If
    End Property

'    <DefaultValue(dAltValue), DesignerSerializationVisibility(DesignerSerializationVisibility.Visible)>
    Public Property Get AlternateValue() As Variant
            Set AlternateValue = m_AltValue
    End Property
    Public Property Let AlternateValue(ByVal Value As Variant)
            If VarType(Value) = vbObject Then
              Set m_AltValue = Value
            Else
              If m_PrimaryValue Is Nothing Then
                Set m_AltValue = New cObject
              End If
              m_AltValue.Value = CSng(Value)
            End If
    End Property

'    <DefaultValue(dPieLabel), DesignerSerializationVisibility(DesignerSerializationVisibility.Visible)>
    Public Property Get PieLabel() As String
            PieLabel = m_PieLabel
    End Property
    Public Property Let PieLabel(ByVal Value As String)
            m_PieLabel = Value
    End Property

'    <DefaultValue(dChartExplode), DesignerSerializationVisibility(DesignerSerializationVisibility.Visible)>
    Public Property Get Explode() As Boolean
            Explode = m_ChartExplode
    End Property
    Public Property Let Explode(ByVal Value As Boolean)
            m_ChartExplode = Value
    End Property

'#End Region

Private Sub Class_Initialize()
  Set m_PrimaryValue = New cObject
  Set m_AltValue = New cObject
  m_PrimaryValue = dPrimaryValue
  m_AltValue = dAltValue
  m_ChartExplode = dChartExplode
  m_PieLabel = dPieLabel
End Sub

Private Sub Class_Terminate()
  Set m_PrimaryValue = Nothing
  Set m_AltValue = Nothing
End Sub
