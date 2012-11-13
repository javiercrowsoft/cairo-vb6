VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFontFamily"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cFontFamily.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiplusFontFamily.h:Microsoft Platform SDK February 2003
'
' This FontFamily class encapsulates a set of fonts that make up a font family.
' A font family is a group of fonts that have the same typeface but different styles.
' ==================================================================================

Private m_lngFamily As Long
Private m_uLastStatus As GpStatus
Private m_blnIsAvailable As Boolean

' creates a new FontFamily object based on this FontFamily object.
Public Function Clone() As cFontFamily
    Dim lngFamily       As Long
    Dim clsClone        As cFontFamily
    
    m_uLastStatus = GdipCloneFontFamily(m_lngFamily, lngFamily)
    If m_uLastStatus <> Ok Then Set clsClone = Nothing: Exit Function
    Set clsClone = New cFontFamily
    clsClone.fInitialize (lngFamily)
    Set Clone = clsClone
End Function

Public Function Create(ByVal name As String, Optional ByVal fontCollection As cFontCollection = Nothing) As GpStatus
    If fontCollection Is Nothing Then
       m_uLastStatus = GdipCreateFontFamilyFromName(StrConv(name, vbUnicode), ByVal 0&, m_lngFamily)
    Else
       m_uLastStatus = GdipCreateFontFamilyFromName(StrConv(name, vbUnicode), fontCollection.NativeFontCollection, m_lngFamily)
    End If
    If m_uLastStatus = Ok Then m_blnIsAvailable = True
    Create = m_uLastStatus
End Function

Public Sub DisposeFamily()
    m_blnIsAvailable = False
    If m_lngFamily <> 0 Then m_uLastStatus = GdipDeleteFontFamily(m_lngFamily): m_lngFamily = 0
End Sub

Friend Sub fInitialize(ByVal lFamily As Long)
    Call DisposeFamily
    m_lngFamily = lFamily
End Sub

' gets a FontFamily object that specifies a generic monospace typeface.
Public Function GenericMonospace() As cFontFamily
    Dim clsP As cFontFamily
    Dim lngNew As Long
    
    m_uLastStatus = GdipGetGenericFontFamilyMonospace(lngNew)
    If m_uLastStatus <> Ok Then Set clsP = Nothing: Exit Function
    Set clsP = New cFontFamily
    clsP.fInitialize lngNew
    Set GenericMonospace = clsP
End Function

' gets a FontFamily object that specifies a generic sans serif typeface.
Public Function GenericSansSerif() As cFontFamily
    Dim clsP As cFontFamily
    Dim lngNew As Long
    
    m_uLastStatus = GdipGetGenericFontFamilySansSerif(lngNew)
    If m_uLastStatus <> Ok Then Set clsP = Nothing: Exit Function
    Set clsP = New cFontFamily
    clsP.fInitialize lngNew
    Set GenericSansSerif = clsP
End Function

' gets a FontFamily object that represents a generic serif typeface.
Public Function GenericSerif() As cFontFamily
    Dim clsP As cFontFamily
    Dim lngNew As Long
    
    m_uLastStatus = GdipGetGenericFontFamilySerif(lngNew)
    If m_uLastStatus <> Ok Then Set clsP = Nothing: Exit Function
    Set clsP = New cFontFamily
    clsP.fInitialize lngNew
    Set GenericSerif = clsP
End Function

' gets the cell ascent, in design units, of this font family for the specified style or style combination.
Public Function GetCellAscent(ByVal style As Long) As Integer
    Dim intCellAscent As Integer
    m_uLastStatus = GdipGetCellAscent(m_lngFamily, style, intCellAscent)
    GetCellAscent = intCellAscent
End Function

' gets the cell descent, in design units, of this font family for the specified style or style combination.
Public Function GetCellDescent(ByVal style As Long) As Integer
    Dim intCellDescent As Integer
    m_uLastStatus = GdipGetEmHeight(m_lngFamily, style, intCellDescent)
    GetCellDescent = intCellDescent
End Function

' gets the size (commonly called em size or em height), in design units, of this font family.
Public Function GetEmHeight(ByVal style As Long) As Integer
    Dim intEmHeight As Integer
    m_uLastStatus = GdipGetEmHeight(m_lngFamily, style, intEmHeight)
    GetEmHeight = intEmHeight
End Function

' gets the name of this font family.
Public Function GetFamilyName(Optional language As Integer = LANG_NEUTRAL) As String
    Dim strName As String * LF_FACESIZE
    m_uLastStatus = GdipGetFamilyName(m_lngFamily, strName, language)
    GetFamilyName = strName
End Function

' returns a value that indicates the nature of this CustomLineCap object's most recent method failure.
Public Function GetLastStatus() As GpStatus
    GetLastStatus = m_uLastStatus
End Function

' gets the line spacing, in design units, of this font family for the specified style or style combination.
Public Function GetLineSpacing(ByVal style As Long) As Integer
    Dim intLineSpacing As Integer
    m_uLastStatus = GdipGetLineSpacing(m_lngFamily, style, intLineSpacing)
    GetLineSpacing = intLineSpacing
End Function

' determines whether this FontFamily object was created successfully.
Public Function IsAvailable() As Boolean
    IsAvailable = m_blnIsAvailable
End Function

' determines whether the specified style is available for this font family.
Public Function IsStyleAvailable(ByVal style As Long) As Boolean
    Dim lngStyleAvailable As Long
    m_uLastStatus = GdipIsStyleAvailable(m_lngFamily, style, lngStyleAvailable)
    If m_uLastStatus = Ok Then
       IsStyleAvailable = lngStyleAvailable
    Else
       IsStyleAvailable = False
    End If
End Function

Public Property Get NativeFontFamily() As Long
    NativeFontFamily = m_lngFamily
End Property

Private Sub Class_Initialize()
    Call DisposeFamily
End Sub

Private Sub Class_Terminate()
    Call DisposeFamily
End Sub

