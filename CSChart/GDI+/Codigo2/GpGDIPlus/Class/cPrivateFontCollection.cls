VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPrivateFontCollection"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cPrivateFontCollection.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiplusFontCollection.h:Microsoft Platform SDK February 2003
'
' The PrivateFontCollection is a collection class for fonts. This class keeps a
' collection of fonts specifically for an application. The fonts in the collection
' can include installed fonts as well as fonts that have not been installed on the system.
' ==================================================================================

Private m_uLastStatus As GpStatus
Private m_clsFontColl As cFontCollection

Public Function AddFontFile(ByVal filename As String) As GpStatus
    m_uLastStatus = GdipPrivateAddFontFile(m_clsFontColl.NativeFontCollection, StrConv(filename, vbUnicode))
    AddFontFile = m_uLastStatus
End Function

Public Function GetLastStatus() As GpStatus
    GetLastStatus = m_uLastStatus
End Function

Public Property Get NativeFontCollection() As Long
    NativeFontCollection = m_clsFontColl.NativeFontCollection
End Property

Private Sub Class_Initialize()
    Dim lCol As Long
    m_uLastStatus = GdipNewPrivateFontCollection(lCol)
    Set m_clsFontColl = New cFontCollection
    m_clsFontColl.fInitialize (lCol)
End Sub

Private Sub Class_Terminate()
    Call GdipDeletePrivateFontCollection(m_clsFontColl.NativeFontCollection)
    Set m_clsFontColl = Nothing
End Sub
