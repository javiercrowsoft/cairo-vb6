VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cStringFormat"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cStringFormat.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiplusStringFormat.h:Microsoft Platform SDK February 2003
'
' The StringFormat class encapsulates text layout information (such as alignment,
' orientation, tab stops, and clipping) and display manipulations (such as trimming,
' font substitution for characters that are not supported by the requested font,
' and digit substitution for languages that do not use Western European digits).
' ==================================================================================

Private m_lngFormat As Long
Private m_uLastStatus As GpStatus

' creates a new StringFormat object and initializes it with the contents of
' this StringFormat object.
Public Function Clone() As cStringFormat
    Dim lngFormat       As Long
    Dim clsClone        As cStringFormat
    
    m_uLastStatus = GdipCloneStringFormat(m_lngFormat, lngFormat)
    If m_uLastStatus <> Ok Then Set clsClone = Nothing: Exit Function
    Set clsClone = New cStringFormat
    clsClone.fInitialize (lngFormat)
    Set Clone = clsClone
End Function

' Creates a StringFormat object based on string format flags and a language.
Public Function Create(Optional ByVal formatFlags As Long = 0, _
                       Optional ByVal language As Integer = LANG_NEUTRAL) As GpStatus
    Call DisposeStringFormat
    m_uLastStatus = GdipCreateStringFormat(formatFlags, language, m_lngFormat)
    Create = m_uLastStatus
End Function

' Creates a StringFormat object from another StringFormat object.
Public Function CreateFromStringFormat(ByVal format As cStringFormat) As GpStatus
    Call DisposeStringFormat
    If format Is Nothing Then
       m_uLastStatus = GdipCloneStringFormat(ByVal 0&, m_lngFormat)
    Else
       m_uLastStatus = GdipCloneStringFormat(format.NativeStringFormat, m_lngFormat)
    End If
    CreateFromStringFormat = m_uLastStatus
End Function

Public Sub DisposeStringFormat()
    If m_lngFormat <> 0 Then m_uLastStatus = GdipDeleteStringFormat(m_lngFormat): m_lngFormat = 0
End Sub

Friend Sub fInitialize(ByVal lFormat As Long)
    Call DisposeStringFormat
    m_lngFormat = lFormat
End Sub

' creates a generic, default StringFormat object.
Public Function GenericDefault() As cStringFormat
    Dim clsP As cStringFormat
    Dim lngNew As Long
    
    m_uLastStatus = GdipStringFormatGetGenericDefault(lngNew)
    If m_uLastStatus <> Ok Then Set clsP = Nothing: Exit Function
    Set clsP = New cStringFormat
    clsP.fInitialize lngNew
    Set GenericDefault = clsP
End Function

' creates a generic, typographic StringFormat object.
Public Function GenericTypographic() As cStringFormat
    Dim clsP As cStringFormat
    Dim lngNew As Long
    
    m_uLastStatus = GdipStringFormatGetGenericTypographic(lngNew)
    If m_uLastStatus <> Ok Then Set clsP = Nothing: Exit Function
    Set clsP = New cStringFormat
    clsP.fInitialize lngNew
    Set GenericTypographic = clsP
End Function

' gets an element of the StringAlignment enumeration that indicates the character
' alignment of this StringFormat object in relation to the origin of the layout rectangle.
' A layout rectangle is used to position the displayed string.
Public Function GetAlignment() As StringAlignment
    Dim uAlignment As StringAlignment
    
    m_uLastStatus = GdipGetStringFormatAlign(m_lngFormat, uAlignment)
    GetAlignment = uAlignment
End Function

' sets the character alignment of this StringFormat object in relation to the origin
' of the layout rectangle. A layout rectangle is used to position the displayed string.
Public Function SetAlignment(ByVal align As StringAlignment) As GpStatus
    m_uLastStatus = GdipSetStringFormatAlign(m_lngFormat, align)
    SetAlignment = m_uLastStatus
End Function

' gets the language that corresponds with the digits that are to be substituted
' for Western European digits
Public Function GetDigitSubstitutionLanguage() As Integer
    Dim iLanguage As Integer
    
    m_uLastStatus = GdipGetStringFormatDigitSubstitution(m_lngFormat, iLanguage, ByVal 0&)
    GetDigitSubstitutionLanguage = iLanguage
End Function

' gets an element of the StringDigitSubstitute enumeration that indicates the
' digit substitution method that is used by this StringFormat object.
Public Function GetDigitSubstitutionMethod() As StringDigitSubstitute
    Dim uSubstitute As StringDigitSubstitute
    
    m_uLastStatus = GdipGetStringFormatDigitSubstitution(m_lngFormat, ByVal 0&, uSubstitute)
    GetDigitSubstitutionMethod = uSubstitute
End Function

' sets the digit substitution method and the language that corresponds to the digit substitutes.
Public Function SetDigitSubstitution(ByVal iLanguage As Integer, _
                                     ByVal uSubstitute As StringDigitSubstitute) As GpStatus
    m_uLastStatus = GdipSetStringFormatDigitSubstitution(m_lngFormat, iLanguage, uSubstitute)
    SetDigitSubstitution = m_uLastStatus
End Function

' gets the string format flags for this StringFormat object.
Public Function GetFormatFlags() As Long
    Dim lngFlags As Long
    
    m_uLastStatus = GdipGetStringFormatFlags(m_lngFormat, lngFlags)
    GetFormatFlags = lngFlags
End Function

' sets the format flags for this StringFormat object.
' The format flags determine most of the characteristics of a StringFormat object.
Public Function SetFormatFlags(ByVal flags As Long) As GpStatus
    m_uLastStatus = GdipSetStringFormatFlags(m_lngFormat, flags)
    SetFormatFlags = m_uLastStatus
End Function

' gets an element of the HotkeyPrefix enumeration that indicates the type of processing
' that is performed on a string when a hot key prefix, an ampersand (&), is encountered.
Public Function GetHotkeyPrefix() As HotkeyPrefix
    Dim uHotkey As HotkeyPrefix
    
    m_uLastStatus = GdipGetStringFormatHotkeyPrefix(m_lngFormat, uHotkey)
    GetHotkeyPrefix = uHotkey
End Function

' sets the type of processing that is performed on a string when the hot key prefix,
' an ampersand (&), is encountered. The ampersand is called the hot key prefix and can
' be used to designate certain keys as hot keys
Public Function SetHotkeyPrefix(uHotkey As HotkeyPrefix) As GpStatus
    m_uLastStatus = GdipSetStringFormatHotkeyPrefix(m_lngFormat, uHotkey)
    SetHotkeyPrefix = m_uLastStatus
End Function

' returns a value that indicates the nature of this StringFormat object's most recent
' method failure.
Public Function GetLastStatus() As GpStatus
    GetLastStatus = m_uLastStatus
End Function

' gets an element of the StringAlignment enumeration that indicates the line alignment
' of this StringFormat object in relation to the origin of the layout rectangle.
' The line alignment setting specifies how to align the string vertically in the layout
' rectangle. The layout rectangle is used to position the displayed string.
Public Function GetLineAlignment() As StringAlignment
    Dim uAlignment As StringAlignment
    
    m_uLastStatus = GdipGetStringFormatLineAlign(m_lngFormat, uAlignment)
    GetLineAlignment = uAlignment
End Function

' sets the line alignment of this StringFormat object in relation to the origin of
' the layout rectangle. The line alignment setting specifies how to align the string
' vertically in the layout rectangle. The layout rectangle is used to position the
' displayed string.
Public Function SetLineAlignment(ByVal align As StringAlignment) As GpStatus
    m_uLastStatus = GdipSetStringFormatLineAlign(m_lngFormat, align)
    SetLineAlignment = m_uLastStatus
End Function

' gets the number of measurable character ranges that are currently set.
' The character ranges that are set can be measured in a string by using the
' cGraphics.MeasureCharacterRanges method
Public Function GetMeasurableCharacterRangeCount() As Long
    Dim lCount As Long
    
    m_uLastStatus = GdipGetStringFormatMeasurableCharacterRangeCount(m_lngFormat, lCount)
    GetMeasurableCharacterRangeCount = lCount
End Function

' sets a series of character ranges for this StringFormat object that, when in a string,
' can be measured by the cGraphics.MeasureCharacterRanges method.
Public Function SetMeasurableCharacterRanges(ByVal rangeCount As Long, _
                                             ByRef ranges() As cCharacterRange) As GpStatus
    Dim uRange() As CharacterRange
    
    Call ConvertRangeToType(ranges, uRange)
    m_uLastStatus = GdipSetStringFormatMeasurableCharacterRanges(m_lngFormat, rangeCount, uRange(LBound(uRange)))
    Erase uRange
    SetMeasurableCharacterRanges = m_uLastStatus
End Function

' gets the number of tab-stop offsets in this StringFormat object.
Public Function GetTabStopCount() As Long
    Dim lCount As Long
    
    m_uLastStatus = GdipGetStringFormatTabStopCount(m_lngFormat, lCount)
    GetTabStopCount = lCount
End Function

' gets the offsets of the tab stops in this StringFormat object
Public Function GetTabStops(ByVal lCount As Long, _
                            firstTabOffset As Single, _
                            tabStops() As Single) As GpStatus
    ReDim tabStops(0 To lCount - 1)
    m_uLastStatus = GdipGetStringFormatTabStops(m_lngFormat, lCount, firstTabOffset, _
                                                tabStops(0))
    GetTabStops = m_uLastStatus
End Function

' sets the offsets for tab stops in this StringFormat object.
Public Function SetTabStops(ByVal firstTabOffset As Single, _
                            ByVal lCount As Long, _
                            tabStops() As Single) As GpStatus
    m_uLastStatus = GdipSetStringFormatTabStops(m_lngFormat, firstTabOffset, lCount, _
                                                tabStops(LBound(tabStops)))
    SetTabStops = m_uLastStatus
End Function

' gets an element of the StringTrimming enumeration that indicates the trimming style
' of this StringFormat object. The trimming style determines how to trim characters
' from a string that is too large to fit in the layout rectangle.
Public Function GetTrimming() As StringTrimming
    Dim uTrimming As StringTrimming
    
    m_uLastStatus = GdipGetStringFormatTrimming(m_lngFormat, uTrimming)
    GetTrimming = uTrimming
End Function

' sets the trimming style for this StringFormat object.
' The trimming style determines how to trim a string so that it fits into the layout rectangle
Public Function SetTrimming(ByVal trimming As StringTrimming) As GpStatus
    m_uLastStatus = GdipSetStringFormatTrimming(m_lngFormat, trimming)
    SetTrimming = m_uLastStatus
End Function

Public Property Get NativeStringFormat() As Long
    NativeStringFormat = m_lngFormat
End Property

Private Sub Class_Initialize()
    Call DisposeStringFormat
    Call Create
End Sub

Private Sub Class_Terminate()
    Call DisposeStringFormat
End Sub
