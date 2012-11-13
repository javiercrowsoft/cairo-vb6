VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIReportGroupSections"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Property Let TypeSection(ByRef rhs As csRptTypeSection)
End Property
Public Function Count() As Long
End Function
Public Function Item(ByVal kItem As Variant) As cReportSection
Attribute Item.VB_UserMemId = 0
End Function
Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
End Function


