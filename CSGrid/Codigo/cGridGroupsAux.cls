VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGridGroups"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Sub EditFilters(ByRef Grd As Object, _
                       ByRef vColumns() As String, _
                       ByRef vKeys() As String)
  mGroup.EditFilters Grd, vColumns, vKeys
End Sub

Public Sub EditFormats(ByRef Grd As Object, _
                       ByRef vColumns() As String, _
                       ByRef vKeys() As String)
  mGroup.EditFormats Grd, vColumns, vKeys
End Sub

Public Sub EditFormulas(ByRef Grd As Object, _
                        ByRef vColumns() As String, _
                        ByRef vKeys() As String)
  mGroup.EditFormulas Grd, vColumns, vKeys
End Sub

Public Sub EditGroups(ByRef Grd As Object, _
                      ByRef vColumns() As String, _
                      ByRef vKeys() As String)
  mGroup.EditGroups Grd, vColumns, vKeys
End Sub

Public Sub ExpandAll(ByRef Grd As Object)
  mGroup.ExpandAll Grd
End Sub

Public Sub CollapseAll(ByRef Grd As Object)
  mGroup.CollapseAll Grd
End Sub

Public Sub EditHideColumns(ByRef Grd As Object, _
                           ByRef vColumns() As String, _
                           ByRef vKeys() As String)
  mGroup.EditHideColumns Grd, vColumns, vKeys
End Sub

Public Sub DoFilters(ByRef Grd As Object)
  mGroup.DoFilters Grd
End Sub

Public Sub DoFormats(ByRef Grd As Object)
  mGroup.DoFormats Grd
End Sub

Public Sub DoGroup(ByRef Grd As Object, ByVal iItems As Long, sGroupColumns() As String, eOrder() As cShellSortOrderCOnstants)
  mGroup.DoGroup Grd, iItems, sGroupColumns, eOrder
End Sub

Public Sub ClickInGroup(ByRef Grd As Object, ByVal lRow As Long, ByVal lCol As Long)
  mGroup.ClickInGroup Grd, lRow, lCol
End Sub
