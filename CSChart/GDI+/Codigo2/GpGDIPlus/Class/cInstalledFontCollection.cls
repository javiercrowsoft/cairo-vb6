VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cInstalledFontCollection"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cInstalledFontCollection.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiplusFontCollection.h:Microsoft Platform SDK February 2003
'
' The InstalledFontCollection class defines a class that represents the fonts
' installed on the system.
' ==================================================================================

Private m_uLastStatus As GpStatus
Private m_clsFontColl As cFontCollection

Public Function GetLastStatus() As GpStatus
    GetLastStatus = m_uLastStatus
End Function

Public Property Get NativeFontCollection() As Long
    NativeFontCollection = m_clsFontColl.NativeFontCollection
End Property

Private Sub Class_Initialize()
    Dim lCol As Long
    m_uLastStatus = GdipNewInstalledFontCollection(lCol)
    Set m_clsFontColl = New cFontCollection
    m_clsFontColl.fInitialize lCol
End Sub

Private Sub Class_Terminate()
    Set m_clsFontColl = Nothing
End Sub

