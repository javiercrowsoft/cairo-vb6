VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "pcNCMetrics"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' ===========================================================================
' Name:     cMCMetrics
' Author:   Steve McMahon (steve@vbaccelerator.com)
' Date:     24 December 1998
' Requires: SSUBTMR.DLL
'
' ---------------------------------------------------------------------------
' Copyright ® 1998 Steve McMahon (steve@vbaccelerator.com)
' Visit vbAccelerator - free, advanced source code for VB programmers.
'     http://vbaccelerator.com
' ---------------------------------------------------------------------------
'
' Description:
' A class to provide fonts and measurements for the non-client (NC)
' portion of a Window to VB.
'
' FREE SOURCE CODE! - ENJOY.
' - Please report bugs to the author for incorporation into future releases
' - See licence below
' ===========================================================================


' ---------------------------------------------------------------------
' vbAccelerator Software License
' Version 1.0
' Copyright (c) 2002 vbAccelerator.com
'
' Redistribution and use in source and binary forms, with or
' without modification, are permitted provided that the following
' conditions are met:
'
' 1. Redistributions of source code must retain the above copyright
'    notice, this list of conditions and the following disclaimer.
'
' 2. Redistributions in binary form must reproduce the above copyright
'    notice, this list of conditions and the following disclaimer in
'    the documentation and/or other materials provided with the distribution.
'
' 3. The end-user documentation included with the redistribution, if any,
'    must include the following acknowledgment:
'
'  "This product includes software developed by vbAccelerator (http://vbaccelerator.com/)."
'
' Alternately, this acknowledgment may appear in the software itself, if
' and wherever such third-party acknowledgments normally appear.
'
' 4. The name "vbAccelerator" must not be used to endorse or promote products
'    derived from this software without prior written permission. For written
'    permission, please contact vbAccelerator through steve@vbaccelerator.com.
'
' 5. Products derived from this software may not be called "vbAccelerator",
'    nor may "vbAccelerator" appear in their name, without prior written
'    permission of vbAccelerator.
'
' THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES,
' INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
' AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
' VBACCELERATOR OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
' INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
' BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
' USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
' THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
' (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
' THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
'
' ---------------------------------------------------------------------



Private Declare Function GetDeviceCaps Lib "gdi32" (ByVal hdc As Long, ByVal nIndex As Long) As Long
Private Const LOGPIXELSY = 90    '  Logical pixels/inch in Y

Private Declare Function GetSystemMetrics Lib "user32" (ByVal nIndex As Long) As Long
Public Enum SystemMetricsIndexConstants
    SM_CMETRICS = 44&
     SM_CMOUSEBUTTONS = 43&
     SM_CXBORDER = 5&
     SM_CXCURSOR = 13&
     SM_CXDLGFRAME = 7&
     SM_CXDOUBLECLK = 36&
     SM_CXFIXEDFRAME = SM_CXDLGFRAME
     SM_CXFRAME = 32&
     SM_CXFULLSCREEN = 16&
     SM_CXHSCROLL = 21&
     SM_CXHTHUMB = 10&
     SM_CXICON = 11&
     SM_CXICONSPACING = 38&
     SM_CXMIN = 28&
     SM_CXMINTRACK = 34&
     SM_CXSCREEN = 0&
     SM_CXSIZE = 30&
     SM_CXSIZEFRAME = SM_CXFRAME
     SM_CXVSCROLL = 2&
     SM_CYBORDER = 6&
     SM_CYCAPTION = 4&
     SM_CYCURSOR = 14&
     SM_CYDLGFRAME = 8&
     SM_CYDOUBLECLK = 37&
     SM_CYFIXEDFRAME = SM_CYDLGFRAME
     SM_CYFRAME = 33&
     SM_CYFULLSCREEN = 17&
     SM_CYHSCROLL = 3&
     SM_CYICON = 12&
     SM_CYICONSPACING = 39&
     SM_CYKANJIWINDOW = 18&
     SM_CYMENU = 15&
     SM_CYMIN = 29&
     SM_CYMINTRACK = 35&
     SM_CYSCREEN = 1&
     SM_CYSIZE = 31&
     SM_CYSIZEFRAME = SM_CYFRAME
     SM_CYVSCROLL = 20&
     SM_CYVTHUMB = 9&
     SM_DBCSENABLED = 42&
     SM_DEBUG = 22&
     SM_MENUDROPALIGNMENT = 40&
     SM_MOUSEPRESENT = 19&
     SM_PENWINDOWS = 41&
     SM_SWAPBUTTON = 23&
End Enum

Private Const SPI_GETICONMETRICS = 45
Private Const SPI_GETICONTITLELOGFONT = 31
Private Const LF_FACESIZE = 32
Private Const LF_FULLFACESIZE = 64

' Normal log font structure:
Private Type LOGFONT
    lfHeight As Long
    lfWidth As Long
    lfEscapement As Long
    lfOrientation As Long
    lfWeight As Long
    lfItalic As Byte
    lfUnderline As Byte
    lfStrikeOut As Byte
    lfCharSet As Byte
    lfOutPrecision As Byte
    lfClipPrecision As Byte
    lfQuality As Byte
    lfPitchAndFamily As Byte
    lfFaceName(LF_FACESIZE) As Byte
End Type
Private Enum CNCMetricsFontWeightConstants
   FW_DONTCARE = 0
   FW_THIN = 100
   FW_EXTRALIGHT = 200
   FW_ULTRALIGHT = 200
   FW_LIGHT = 300
   FW_NORMAL = 400
   FW_REGULAR = 400
   FW_MEDIUM = 500
   FW_SEMIBOLD = 600
   FW_DEMIBOLD = 600
   FW_BOLD = 700
   FW_EXTRABOLD = 800
   FW_ULTRABOLD = 800
   FW_HEAVY = 900
   FW_BLACK = 900
End Enum
' Here but thanks to a bit of hacking (testing cbSize
' parameter until it worked - see sub XXXTest1!) is the required
' definition for NONCLIENTMETRICS structure - differs
' to the one in WIN32API.TXT with VB.
' For some bizarre reason, maybe to do with byte
' alignment, the LOGFONT structure we must apply
' to NONCLIENTMETRICS seems to require an LF_FACESIZE
' 4 bytes smaller than normal:
Private Type NMLOGFONT
    lfHeight As Long
    lfWidth As Long
    lfEscapement As Long
    lfOrientation As Long
    lfWeight As Long
    lfItalic As Byte
    lfUnderline As Byte
    lfStrikeOut As Byte
    lfCharSet As Byte
    lfOutPrecision As Byte
    lfClipPrecision As Byte
    lfQuality As Byte
    lfPitchAndFamily As Byte
    lfFaceName(LF_FACESIZE - 4) As Byte
End Type
Private Type NONCLIENTMETRICS
    cbSize As Long
    iBorderWidth As Long
    iScrollWidth As Long
    iScrollHeight As Long
    iCaptionWidth As Long
    iCaptionHeight As Long
    lfCaptionFont As NMLOGFONT
    iSMCaptionWidth As Long
    iSMCaptionHeight As Long
    lfSMCaptionFont As NMLOGFONT
    iMenuWidth As Long
    iMenuHeight As Long
    lfMenuFont As NMLOGFONT
    lfStatusFont As NMLOGFONT
    lfMessageFont As NMLOGFONT
End Type
Private Const SPI_GETNONCLIENTMETRICS = 41
Private Const SPI_SETNONCLIENTMETRICS = 42
Private Declare Function SystemParametersInfo Lib "user32" Alias "SystemParametersInfoA" ( _
    ByVal uAction As Long, _
    ByVal uParam As Long, _
    lpvParam As Any, _
    ByVal fuWinIni As Long) As Long
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" ( _
    lpvDest As Any, lpvSource As Any, ByVal cbCopy As Long)
Private Declare Function CreateFontIndirect Lib "gdi32" Alias "CreateFontIndirectA" (lpLogFont As LOGFONT) As Long
Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long

Private m_tNCM As NONCLIENTMETRICS
Private m_tLF As LOGFONT
Private m_hFont(1 To 6) As Long

Public Enum CNCMetricsFontTypes
    IconFont = 1
    CaptionFont = 2
    SMCaptionFont = 3
    MenuFOnt = 4
    StatusFont = 5
    MessageFont = 6
End Enum

Public Function GetMetrics() As Boolean
Dim lR As Long

    ClearUp
    ' Get Non-client metrics:
    m_tNCM.cbSize = 340 'LenB(m_tNCM) - why doesn't this go?
    lR = SystemParametersInfo( _
            SPI_GETNONCLIENTMETRICS, _
            0, _
            m_tNCM, _
            0)
    If (lR <> 0) Then
        ' Get icon font:
        lR = SystemParametersInfo( _
            SPI_GETICONTITLELOGFONT, _
            0, _
            m_tLF, _
            0)
        GetMetrics = (lR <> 0)
    End If
End Function
Property Get FontHandle( _
        ByVal eFontNum As CNCMetricsFontTypes _
    ) As Long
Dim lR As Long
Dim tLF As LOGFONT
    Select Case eFontNum
    Case StatusFont
        CopyMemory tLF, m_tNCM.lfStatusFont, LenB(m_tNCM.lfStatusFont)
    Case SMCaptionFont
        CopyMemory tLF, m_tNCM.lfSMCaptionFont, LenB(m_tNCM.lfSMCaptionFont)
    Case MessageFont
        CopyMemory tLF, m_tNCM.lfMessageFont, LenB(m_tNCM.lfMessageFont)
    Case MenuFOnt
        CopyMemory tLF, m_tNCM.lfMenuFont, LenB(m_tNCM.lfMenuFont)
    Case IconFont
        CopyMemory tLF, m_tLF, LenB(m_tLF)
    Case CaptionFont
        CopyMemory tLF, m_tNCM.lfCaptionFont, LenB(m_tNCM.lfCaptionFont)
    End Select
    
    FontHandle = plGetFont(eFontNum, tLF)

End Property
Property Get BoldenedFontHandle( _
      ByVal eFontNum As CNCMetricsFontTypes _
   ) As Long
Dim tLF As LOGFONT
   Select Case eFontNum
   Case StatusFont
       CopyMemory tLF, m_tNCM.lfStatusFont, LenB(m_tNCM.lfStatusFont)
   Case SMCaptionFont
       CopyMemory tLF, m_tNCM.lfSMCaptionFont, LenB(m_tNCM.lfSMCaptionFont)
   Case MessageFont
       CopyMemory tLF, m_tNCM.lfMessageFont, LenB(m_tNCM.lfMessageFont)
   Case MenuFOnt
       CopyMemory tLF, m_tNCM.lfMenuFont, LenB(m_tNCM.lfMenuFont)
   Case IconFont
       CopyMemory tLF, m_tLF, LenB(m_tLF)
   Case CaptionFont
       CopyMemory tLF, m_tNCM.lfCaptionFont, LenB(m_tNCM.lfCaptionFont)
   End Select
   If (tLF.lfWeight < FW_BOLD) Then
      tLF.lfWeight = FW_BOLD
   Else
      tLF.lfWeight = FW_BLACK
   End If
   ' Not cleared up by this class....
   BoldenedFontHandle = CreateFontIndirect(tLF)
End Property
Private Sub pLogFontToStdFont(ByRef tLF As NMLOGFONT, ByVal hdc As Long, ByRef sFnt As StdFont)
   With sFnt
     .Name = StrConv(tLF.lfFaceName, vbUnicode)
     If tLF.lfHeight < 1 Then
       .Size = Abs((72# / GetDeviceCaps(hdc, LOGPIXELSY)) * tLF.lfHeight)
     Else
       .Size = tLF.lfHeight
     End If
     .Charset = tLF.lfCharSet
     .Italic = Not (tLF.lfItalic = 0)
     .Underline = Not (tLF.lfUnderline = 0)
     .Strikethrough = Not (tLF.lfStrikeOut = 0)
     .Bold = (tLF.lfWeight > FW_REGULAR)
   End With
End Sub
Property Get Font( _
      ByVal lHDC As Long, _
      ByVal eFontNum As CNCMetricsFontTypes _
   ) As IFont
   Dim sFnt As New StdFont
   Select Case eFontNum
   Case StatusFont
      pLogFontToStdFont m_tNCM.lfStatusFont, lHDC, sFnt
   Case SMCaptionFont
      pLogFontToStdFont m_tNCM.lfSMCaptionFont, lHDC, sFnt
   Case MessageFont
      pLogFontToStdFont m_tNCM.lfMessageFont, lHDC, sFnt
   Case MenuFOnt
      pLogFontToStdFont m_tNCM.lfMenuFont, lHDC, sFnt
   Case IconFont
      Dim tNM As NMLOGFONT
      CopyMemory tNM, m_tLF, Len(tNM)
      pLogFontToStdFont tNM, lHDC, sFnt
   Case CaptionFont
      pLogFontToStdFont m_tNCM.lfCaptionFont, lHDC, sFnt
   End Select
   Set Font = sFnt
End Property
Property Get CaptionHeight() As Long
    CaptionHeight = m_tNCM.iCaptionHeight
End Property
Property Get CaptionWIdth() As Long
    CaptionWIdth = m_tNCM.iCaptionWidth
End Property
Property Get MenuHeight() As Long
    MenuHeight = m_tNCM.iMenuHeight
End Property
Property Get MenuWidth() As Long
    MenuWidth = m_tNCM.iMenuWidth
End Property
Property Get ScrollHeight() As Long
    ScrollHeight = m_tNCM.iScrollHeight
End Property
Property Get ScrollWidth() As Long
    ScrollWidth = m_tNCM.iScrollWidth
End Property
Property Get SMCaptionHeight() As Long
    SMCaptionHeight = m_tNCM.iSMCaptionHeight
End Property
Property Get SMCaptionWIdth() As Long
    SMCaptionWIdth = m_tNCM.iSMCaptionWidth
End Property
Property Get BorderWidth() As Long
    BorderWidth = m_tNCM.iBorderWidth
End Property
Public Function ClearUp()
Dim l As Long
    For l = 1 To 6
        If (m_hFont(l) <> 0) Then
            DeleteObject m_hFont(l)
        End If
        m_hFont(l) = 0
    Next l
End Function
Private Function plGetFont( _
        ByVal eFontNum As CNCMetricsFontTypes, _
        ByRef tLF As LOGFONT _
    )
    If (m_hFont(eFontNum) = 0) Then
        m_hFont(eFontNum) = CreateFontIndirect(tLF)
    End If
    plGetFont = m_hFont(eFontNum)
End Function
Private Function XXXTest1()
Dim lSize As Long
Dim lR As Long
    For lSize = 0 To 1024
        m_tNCM.cbSize = lSize
        lR = SystemParametersInfo( _
            SPI_GETNONCLIENTMETRICS, _
            0, _
            m_tNCM, _
            0)
        If (lR <> 0) Then
            Debug.Print lSize
        End If
    Next lSize
End Function


Private Sub Class_Terminate()
    ClearUp
End Sub






