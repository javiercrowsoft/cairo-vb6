Attribute VB_Name = "mAux"
Option Explicit
'--------------------------------------------------------------------------------
' mAux
' 15-09-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "mAux"
Private Const csNoFecha As Date = #1/1/1900#

Public Enum csRptFormulaType
  csRptFPageNumber = 10001
  csRptFTotalPages = 10002
  csRptFAverage = 10003
  csRptFSum = 10004
  csRptMax = 10005
  csRptMin = 10006
  csRptCount = 10007
  csRptLength = 10008
  csRptFCalculo = 10009
End Enum
' estructuras
Public Type Rectangle
  Height As Long
  Width  As Long
End Type
' variables privadas
Private m_NextKey As Long
' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
' funciones privadas
' construccion - destruccion
Public Function IsDbNull(ByVal Val As Variant) As Boolean
  IsDbNull = IsNull(Val)
End Function

Public Function GetNextKey() As Long
  m_NextKey = m_NextKey + 1
  GetNextKey = m_NextKey
End Function

Public Sub RefreshNextKey(ByVal sKey As String)
  Dim KeyNumber As Long
  If IsNumeric(sKey) Then
    KeyNumber = CInt(sKey)
  Else
    If IsNumeric(Mid(sKey, 2)) Then
      KeyNumber = CInt(Mid(sKey, 2))
    End If
  End If
  
  If m_NextKey < KeyNumber Then m_NextKey = KeyNumber + 1
End Sub


Public Sub Main()
  m_NextKey = 1000
End Sub

Public Function ValVariant(ByRef Var As Object) As Variant

  If IsDbNull(Var) Then

    Select Case VarType(Var)
      Case VbVarType.vbString
        ValVariant = vbNullString
      Case VbVarType.vbBoolean
        ValVariant = 0
      Case VbVarType.vbByte, VbVarType.vbDecimal, VbVarType.vbDecimal, VbVarType.vbDouble
        ValVariant = 0
      Case VbVarType.vbDate
        ValVariant = csNoFecha
    End Select
  Else

    ValVariant = Var
  End If
End Function

#If Not F_CSReportPaint Then
  Public Function GetControlsInZOrder(ByRef Col As cReportControls) As cReportControls
    Dim i As Long
    Dim Ctrl As cReportControl
    Dim ctrls As cReportControls
    
    Set ctrls = New cReportControls
    Set ctrls.CopyColl = Col.CopyColl
    ctrls.TypeSection = Col.TypeSection
    Set ctrls.SectionLine = Col.SectionLine
    
    'Cargo una nueva coleccion en funcion del zorder
    While Col.Count > 0
    
    'Busco el zorder menor de esta coleccion
    i = 32767
    For Each Ctrl In Col
    If Ctrl.Label.Aspect.nZOrder < i Then
    i = Ctrl.Label.Aspect.nZOrder
    End If
    Next
    
    For Each Ctrl In Col
    If Ctrl.Label.Aspect.nZOrder = i Then
    Col.Remove Ctrl.Key
    ctrls.Add Ctrl, Ctrl.Key
    Exit For
    End If
    Next
    i = i + 1
    Wend
    ' Devuelvo la coleccion ordenada
    Set GetControlsInZOrder = ctrls
  End Function
#End If

Public Sub RectTwipsToPixel(ByRef tR As RECT, ByVal ScaleX As Single, ByVal ScaleY As Single)
  Dim Height As Integer
  Height = (tR.Bottom - tR.Top) / Screen.TwipsPerPixelX
  tR.Left = tR.Left / Screen.TwipsPerPixelX
  tR.Top = tR.Top / Screen.TwipsPerPixelY
  tR.Right = tR.Right / Screen.TwipsPerPixelX
  tR.Bottom = tR.Top + Height

  tR.Left = tR.Left * ScaleX
  tR.Top = tR.Top * ScaleY
  tR.Right = tR.Right * ScaleX
  tR.Bottom = tR.Top + (Height * ScaleY)
End Sub

Public Function NewRectangle(ByVal Left As Long, ByVal Top As Long, ByVal Right As Long, ByVal Bottom As Long) As RECT
  Dim tR As RECT
  
  If Left < 0 Then Left = 0
  If Top < 0 Then Top = 0
  If Right < Left Then Right = Left
  If Bottom < Top Then Bottom = Top
  
  tR.Left = Left
  tR.Top = Top
  tR.Right = Right
  tR.Bottom = Bottom
  
  NewRectangle = tR
End Function

Public Function EvaluateTextHeight(ByVal Text As String, ByVal hFont As Long, _
                                   ByVal Width As Long, ByVal hDC As Long, _
                                   ByVal Flags As Long, _
                                   ByVal ScaleY As Long, ByVal ScaleX As Long) As Long
  Dim hFntOld As Long
  Dim tR      As RECT

  ' Ensure correct font:
  hFntOld = SelectObject(hDC, hFont)
  tR.Right = (Width / Screen.TwipsPerPixelX) * ScaleX
  
  ' Draw the text, calculating rect:
  DrawText hDC, Text & vbNullChar, -1, tR, Flags Or DT_CALCRECT
  EvaluateTextHeight = ((tR.Bottom - tR.Top) * Screen.TwipsPerPixelY) * ScaleY
   
  If (hFntOld <> 0) Then
    SelectObject hDC, hFntOld
    hFntOld = 0
  End If
End Function

Public Function AddFontIfRequired(ByVal oFont As StdFont, ByRef hDC As Long, ByRef iFontCount As Long, ByRef vFnt() As StdFont, ByRef vhFnt() As Long) As Long
  Dim iFnt As Long
  Dim tULF As LOGFONT
  For iFnt = 1 To iFontCount
    If (oFont.Name = vFnt(iFnt).Name) And (oFont.Bold = vFnt(iFnt).Bold) And (oFont.Italic = vFnt(iFnt).Italic) And (oFont.UnderLine = vFnt(iFnt).UnderLine) And (oFont.Size = vFnt(iFnt).Size) And (oFont.Strikethrough = vFnt(iFnt).Strikethrough) Then
      AddFontIfRequired = iFnt
      Exit Function
    End If
  Next iFnt
  iFontCount = iFontCount + 1
  ReDim Preserve vFnt(iFontCount) As StdFont
  ReDim Preserve vhFnt(iFontCount) As Long
  Set vFnt(iFontCount) = New StdFont
  With vFnt(iFontCount)
    .Name = oFont.Name
    .Size = oFont.Size
    .Bold = oFont.Bold
    .Italic = oFont.Italic
    .UnderLine = oFont.UnderLine
    .Strikethrough = oFont.Strikethrough
  End With
  OLEFontToLogFont vFnt(iFontCount), hDC, tULF
  vhFnt(iFontCount) = CreateFontIndirect(tULF)
  AddFontIfRequired = iFontCount
End Function

Public Sub OLEFontToLogFont(fntThis As StdFont, hDC As Long, tLF As LOGFONT)
  Dim sFont As String
  Dim iChar As Integer
  
  ' Convert an OLE StdFont to a LOGFONT structure:
  With tLF
    sFont = fntThis.Name
    ' There is a quicker way involving StrConv and CopyMemory, but
    ' this is simpler!:
    For iChar = 1 To Len(sFont)
        .lfFaceName(iChar - 1) = CByte(Asc(Mid$(sFont, iChar, 1)))
    Next iChar
    ' Based on the Win32SDK documentation:
    .lfHeight = -MulDiv((fntThis.Size), (GetDeviceCaps(hDC, LOGPIXELSY)), 72)
    .lfItalic = fntThis.Italic
    If (fntThis.Bold) Then
        .lfWeight = FW_BOLD
    Else
        .lfWeight = FW_NORMAL
    End If
    .lfUnderline = fntThis.UnderLine
    .lfStrikeOut = fntThis.Strikethrough
    .lfCharSet = fntThis.Charset
  End With
End Sub

Public Sub DrawBMP(ByVal hDCDest As Long, ByVal hBmp As Long, _
                   ByVal x As Long, ByVal y As Long, _
                   ByVal Width As Long, ByVal Height As Long, _
                   ByVal DestWidth As Long, ByVal DestHeight As Long)
  Dim hDC      As Long
  Dim hOldBmp  As Long
  
  hDC = CreateCompatibleDC(0&)
  hOldBmp = SelectObject(hDC, hBmp)
  
  x = x / Screen.TwipsPerPixelX
  y = y / Screen.TwipsPerPixelY
  Width = Width / Screen.TwipsPerPixelX
  Height = Height / Screen.TwipsPerPixelY
  DestWidth = DestWidth / Screen.TwipsPerPixelX
  DestHeight = DestHeight / Screen.TwipsPerPixelY
  
  If DestWidth <> Width Then
    Dim OldStrMode As Long
    
    OldStrMode = SetStretchBltMode(hDCDest, HALFTONE)
  
    StretchBlt hDCDest, x, y, DestWidth, DestHeight, hDC, 0, 0, Width, Height, vbSrcCopy
    
    SetStretchBltMode hDCDest, OldStrMode
    
  Else
    BitBlt hDCDest, x, y, Width, Height, hDC, 0, 0, vbSrcCopy
  End If
  
  SelectObject hDC, hOldBmp
  DeleteObject hDC
End Sub

Public Function TranslateColor(ByVal oClr As OLE_COLOR, Optional hPal As Long = 0) As Long
  ' Convert Automation color to Windows color
  If OleTranslateColor(oClr, hPal, TranslateColor) Then
    TranslateColor = CLR_INVALID
  End If
End Function

Public Sub GetBitmapSize(ByVal hBmp, ByRef Width As Long, ByRef Height As Long, Optional ByVal InTwips As Boolean = True)
  Dim sBitmapInfo   As BITMAP
  
  ' get the information about this image
  GetObjectAPI hBmp, Len(sBitmapInfo), sBitmapInfo
  
  If InTwips Then
    Width = sBitmapInfo.bmWidth * Screen.TwipsPerPixelX
    Height = sBitmapInfo.bmHeight * Screen.TwipsPerPixelY
  Else
    Width = sBitmapInfo.bmWidth
    Height = sBitmapInfo.bmHeight
  End If
End Sub

