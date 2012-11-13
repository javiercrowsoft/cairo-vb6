Attribute VB_Name = "mColorXpStyle"
Option Explicit

' TODO: border around selected item has its own colour, vbHighlight when no theme

Public Declare Function GetDC Lib "user32" (ByVal hWnd As Long) As Long
Public Declare Function ReleaseDC Lib "user32" (ByVal hWnd As Long, ByVal hdc As Long) As Long

Private Declare Function OleTranslateColor Lib "OLEPRO32.DLL" (ByVal OLE_COLOR As Long, ByVal HPALETTE As Long, pccolorref As Long) As Long

Public Declare Function GetSysColor Lib "user32" (ByVal nIndex As Long) As Long

Private Declare Function OpenThemeData Lib "uxtheme.dll" _
   (ByVal hWnd As Long, ByVal pszClassList As Long) As Long
Private Declare Function CloseThemeData Lib "uxtheme.dll" _
   (ByVal hTheme As Long) As Long
Private Declare Function GetCurrentThemeName Lib "uxtheme.dll" ( _
    ByVal pszThemeFileName As Long, _
    ByVal dwMaxNameChars As Long, _
    ByVal pszColorBuff As Long, _
    ByVal cchMaxColorChars As Long, _
    ByVal pszSizeBuff As Long, _
    ByVal cchMaxSizeChars As Long _
   ) As Long
Private Declare Function GetThemeFilename Lib "uxtheme.dll" _
   (ByVal hTheme As Long, _
    ByVal iPartId As Long, _
    ByVal iStateId As Long, _
    ByVal iPropId As Long, _
    pszThemeFileName As Long, _
    ByVal cchMaxBuffChars As Long _
   ) As Long

Private Declare Function GetDesktopWindow Lib "user32" () As Long
Private Declare Function GetDeviceCaps Lib "gdi32" (ByVal hdc As Long, ByVal nIndex As Long) As Long
Private Const BITSPIXEL = 12         '  Number of bits per pixel

Private Declare Function SystemParametersInfo Lib "user32" Alias "SystemParametersInfoA" ( _
      ByVal uAction As Long, _
      ByVal uParam As Long, _
      ByRef lpvParam As Any, _
      ByVal fuWinIni As Long) As Long
Private Const SPI_GETHIGHCONTRAST = &H42
Private Type HIGH_CONTRAST
   cbSize As Long
   dwFlags As Long
   lpszDefaultScheme As Long
End Type
Private Const HCF_HIGHCONTRASTON = &H1
Private Const HCF_AVAILABLE = &H2
Private Const HCF_HOTKEYACTIVE = &H4
Private Const HCF_CONFIRMHOTKEY = &H8
Private Const HCF_HOTKEYSOUND = &H10
Private Const HCF_INDICATOR = &H20
Private Const HCF_HOTKEYAVAILABLE = &H40

Private Type OSVERSIONINFO
   dwVersionInfoSize As Long
   dwMajorVersion As Long
   dwMinorVersion As Long
   dwBuildNumber As Long
   dwPlatformId As Long
   szCSDVersion(0 To 127) As Byte
End Type
Private Declare Function GetVersionEx Lib "kernel32" Alias "GetVersionExA" (lpVersionInfo As OSVERSIONINFO) As Long
Private Const VER_PLATFORM_WIN32_NT = 2

Public Enum EToolBarStyle
   ' Render using Office XP style
   eOfficeXP
   ' Render using Office 2003 style (the default)
   eOffice2003
   ' Render using MS Money style
   eMoney
   ' Render using same style as System's ComCtl32.DLL
   eComCtl32
End Enum

Public Enum ECustomColors
   [_eccCustomColorFirst]
   eccButtonTextColor
   eccButtonTextHotColor
   eccButtonTextDisabledColor
   eccButtonBackgroundColorStart
   eccButtonBackgroundColorEnd
   eccButtonHotBackgroundColorStart
   eccButtonHotBackgroundColorEnd
   eccButtonCheckedBackgroundColorStart
   eccButtonCheckedBackgroundColorEnd
   eccButtonCheckedHotBackgroundColorStart
   eccButtonCheckedHotBackgroundColorEnd
   eccMenuShadowColor
   eccMenuBorderColor
   eccMenuTextColor
   eccMenuTextHotColor
   eccMenuTextDisabledColor
   eccMenuBackgroundColorStart
   eccMenuBackgroundColorEnd
   eccMenuHotBackgroundColorStart
   eccMenuHotBackgroundColorEnd
   eccMenuHotBorderColor
   eccMenuCheckedBackgroundColorStart
   eccMenuCheckedBackgroundColorEnd
   eccMenuCheckedHotBackgroundColorStart
   eccMenuCheckedHotBackgroundColorEnd
   eccIconDisabledColor
   eccLightColor
   eccDarkColor
   eccGradientColorStart
   eccGradientColorEnd
   [_eccCustomColorLast]
End Enum

Public Const CLR_INVALID = -1
Public Const CLR_NONE = CLR_INVALID

Private m_bIsXp As Boolean
Private m_bIsNt As Boolean
Private m_bIs2000OrAbove As Boolean

Private m_iTheme As Long
Private m_eStyle As EToolBarStyle
Private m_bCustomColours As Long
Private m_bTrueColor As Boolean
Private m_bHighContrast As Boolean

Private m_eColors(ECustomColors.[_eccCustomColorFirst] To ECustomColors.[_eccCustomColorLast]) As OLE_COLOR
Private m_eLastColors(ECustomColors.[_eccCustomColorFirst] To ECustomColors.[_eccCustomColorLast]) As OLE_COLOR

Public Sub VerInitialise()
   
   Dim tOSV As OSVERSIONINFO
   tOSV.dwVersionInfoSize = Len(tOSV)
   GetVersionEx tOSV
   
   m_bIsNt = ((tOSV.dwPlatformId And VER_PLATFORM_WIN32_NT) = VER_PLATFORM_WIN32_NT)
   If (tOSV.dwMajorVersion > 5) Then
      m_bIsXp = True
      m_bIs2000OrAbove = True
   ElseIf (tOSV.dwMajorVersion = 5) Then
      m_bIs2000OrAbove = True
      If (tOSV.dwMinorVersion >= 1) Then
         m_bIsXp = True
      End If
   End If
   
End Sub
Public Property Get Is2000OrAbove() As Boolean
   Is2000OrAbove = m_bIs2000OrAbove
End Property
Public Property Get IsXp() As Boolean
   IsXp = m_bIsXp
End Property
Public Property Get IsNt() As Boolean
   IsNt = m_bIsNt
End Property
Public Property Get CustomColor(ByVal eColor As ECustomColors) As OLE_COLOR
   CustomColor = m_eColors(eColor)
End Property
Public Property Let CustomColor(ByVal eColor As ECustomColors, ByVal oColor As OLE_COLOR)
   m_eColors(eColor) = oColor
   If Not (oColor = CLR_NONE) Then
      m_eLastColors(eColor) = m_eColors(eColor)
   End If
End Property
Public Property Get UseStyleColor(ByVal eColor As ECustomColors) As Boolean
   UseStyleColor = (m_eColors(eColor) = CLR_NONE)
End Property
Public Property Let UseStyleColor(ByVal eColor As ECustomColors, ByVal bState As Boolean)
   If (bState) Then
      m_eColors(eColor) = CLR_NONE
   Else
      If Not (m_eColors(eColor) = CLR_NONE) Then
         m_eColors(eColor) = m_eLastColors(eColor)
      End If
   End If
End Property
Public Property Get StyleColor(eColor As ECustomColors) As OLE_COLOR
Dim oColor As OLE_COLOR
Dim bReset As Boolean
   
   If Not (m_eColors(eColor) = CLR_NONE) Then
      oColor = m_eColors(eColor)
      m_eColors(eColor) = CLR_NONE
      bReset = True
   End If
   
   Select Case eColor
   Case eccButtonTextColor
      StyleColor = ButtonTextColor
   Case eccButtonTextHotColor
      StyleColor = ButtonTextHotColor
   Case eccButtonTextDisabledColor
      StyleColor = ButtonTextDisabledColor
   Case eccButtonBackgroundColorStart
      StyleColor = ButtonBackgroundColorStart
   Case eccButtonBackgroundColorEnd
      StyleColor = ButtonBackgroundColorEnd
   Case eccButtonHotBackgroundColorStart
      StyleColor = ButtonHotBackgroundColorStart
   Case eccButtonHotBackgroundColorEnd
      StyleColor = ButtonHotBackgroundColorEnd
   Case eccButtonCheckedBackgroundColorStart
      StyleColor = ButtonCheckedBackgroundColorStart
   Case eccButtonCheckedBackgroundColorEnd
      StyleColor = ButtonCheckedBackgroundColorEnd
   Case eccButtonCheckedHotBackgroundColorStart
      StyleColor = ButtonCheckedHotBackgroundColorStart
   Case eccButtonCheckedHotBackgroundColorEnd
      StyleColor = ButtonCheckedHotBackgroundColorEnd
   Case eccMenuShadowColor
      StyleColor = MenuShadowColor
   Case eccMenuBorderColor
      StyleColor = MenuBorderColor
   Case eccMenuTextColor
      StyleColor = MenuTextColor
   Case eccMenuTextHotColor
      StyleColor = MenuTextHotColor
   Case eccMenuTextDisabledColor
      StyleColor = MenuTextDisabledColor
   Case eccMenuBackgroundColorStart
      StyleColor = MenuBackgroundColorStart
   Case eccMenuBackgroundColorEnd
      StyleColor = MenuBackgroundColorEnd
   Case eccMenuHotBackgroundColorStart
      StyleColor = MenuHotBackgroundColorStart
   Case eccMenuHotBackgroundColorEnd
      StyleColor = MenuHotBackgroundColorEnd
   Case eccMenuHotBorderColor
      StyleColor = MenuHotBorderColor
   Case eccMenuCheckedBackgroundColorStart
      StyleColor = MenuCheckedBackgroundColorStart
   Case eccMenuCheckedBackgroundColorEnd
      StyleColor = MenuCheckedBackgroundColorEnd
   Case eccMenuCheckedHotBackgroundColorStart
      StyleColor = MenuCheckedHotBackgroundColorStart
   Case eccMenuCheckedHotBackgroundColorEnd
      StyleColor = MenuCheckedHotBackgroundColorEnd
   Case eccIconDisabledColor
      StyleColor = IconDisabledColor
   Case eccLightColor
      StyleColor = LightColor
   Case eccDarkColor
      StyleColor = DarkColor
   Case eccGradientColorStart
      StyleColor = GradientColorStart
   Case eccGradientColorEnd
      StyleColor = GradientColorEnd
   End Select
   
   If (bReset) Then
      m_eColors(eColor) = oColor
   End If
   
End Property

Public Sub ColourInitialise()
   m_eStyle = eOffice2003
   m_bTrueColor = True
   Dim i As Long
   For i = ECustomColors.[_eccCustomColorFirst] To ECustomColors.[_eccCustomColorLast]
      m_eColors(i) = CLR_NONE
      m_eLastColors(i) = CLR_NONE
   Next i
End Sub

Public Property Get Style() As EToolBarStyle
   Style = m_eStyle
End Property
Public Property Let Style(ByVal eStyle As EToolBarStyle)
   If Not (m_eStyle = eStyle) Then
      m_eStyle = eStyle
      InitTheme GetDesktopWindow()
   End If
End Property
   
Public Property Get TrueColor() As Boolean
   TrueColor = m_bTrueColor
End Property
Public Property Get HighContrast() As Boolean
   HighContrast = m_bHighContrast
End Property

Public Sub InitTheme(ByVal hWnd As Long)
Dim hTheme As Long
Dim lPtrColorName As Long
Dim lPtrThemeFile As Long
Dim sThemeFile As String
Dim sColorName As String
Dim sShellStyle As String
Dim hRes As Long
Dim iPos As Long
Dim lhWndD As Long
Dim lhDCC As Long
Dim lBitsPixel As Long

   If (m_eStyle = eOffice2003) Then
      If (IsXp) Then
         On Error Resume Next
         hTheme = OpenThemeData(hWnd, StrPtr("ExplorerBar"))
         If Not (hTheme = 0) Then
            
            ReDim bThemeFile(0 To 260 * 2) As Byte
            lPtrThemeFile = VarPtr(bThemeFile(0))
            ReDim bColorName(0 To 260 * 2) As Byte
            lPtrColorName = VarPtr(bColorName(0))
            hRes = GetCurrentThemeName(lPtrThemeFile, 260, lPtrColorName, 260, 0, 0)
            
            sThemeFile = bThemeFile
            iPos = InStr(sThemeFile, vbNullChar)
            If (iPos > 1) Then sThemeFile = Left(sThemeFile, iPos - 1)
            sColorName = bColorName
            iPos = InStr(sColorName, vbNullChar)
            If (iPos > 1) Then sColorName = Left(sColorName, iPos - 1)
            
            Select Case sColorName
            Case "NormalColor"
               m_iTheme = 1
            Case "Metallic"
               m_iTheme = 2
            Case "Homestead"
               m_iTheme = 3
            Case Else
               m_iTheme = 0
            End Select
            
            CloseThemeData hTheme
         End If
      End If
   End If
   
   lhWndD = GetDesktopWindow()
   lhDCC = GetDC(lhWndD)
   lBitsPixel = GetDeviceCaps(lhDCC, BITSPIXEL)
   ReleaseDC lhWndD, lhDCC
   m_bTrueColor = (lBitsPixel > 8)
   
   Dim tHC As HIGH_CONTRAST
   tHC.cbSize = Len(tHC)
   tHC.lpszDefaultScheme = 0
   SystemParametersInfo SPI_GETHIGHCONTRAST, Len(tHC), tHC, 0
   m_bHighContrast = ((tHC.dwFlags And HCF_HIGHCONTRASTON) = HCF_HIGHCONTRASTON)
   
End Sub

' NOTE: Color = -1 indicates transparent

' Toolbar item colours:
Public Property Get ButtonTextColor() As Long
   If Not (m_eColors(eccButtonTextColor) = CLR_NONE) Then
      ButtonTextColor = TranslateColor(m_eColors(eccButtonTextColor))
   Else
      Select Case m_eStyle
      Case eMoney
         ButtonTextColor = &HFFFFFF
      Case Else
         ButtonTextColor = GetSysColor(vbWindowText And &H1F&)
      End Select
   End If
End Property
Public Property Get ButtonTextHotColor() As Long
   If Not (m_eColors(eccButtonTextHotColor) = CLR_NONE) Then
      ButtonTextHotColor = m_eColors(eccButtonTextHotColor)
   Else
      Select Case m_eStyle
      Case eMoney
         ButtonTextHotColor = MenuTextHotColor
      Case eComCtl32
         ButtonTextHotColor = ButtonTextColor
      Case Else
         ButtonTextHotColor = ButtonTextColor
      End Select
   End If
End Property
Public Property Get ButtonTextDisabledColor() As Long
   If Not (m_eColors(eccButtonTextDisabledColor) = CLR_NONE) Then
      ButtonTextDisabledColor = TranslateColor(m_eColors(eccButtonTextDisabledColor))
   Else
      Select Case m_eStyle
      Case eMoney
         ButtonTextDisabledColor = RGB(190, 190, 190)
      Case Else
         ButtonTextDisabledColor = DarkColor()
      End Select
   End If
End Property
Public Property Get ButtonBackgroundColorStart() As Long
   If Not (m_eColors(eccButtonBackgroundColorStart) = CLR_NONE) Then
      ButtonBackgroundColorStart = TranslateColor(m_eColors(eccButtonBackgroundColorStart))
   Else
      ButtonBackgroundColorStart = -1
   End If
End Property
Public Property Get ButtonBackgroundColorEnd() As Long
   If Not (m_eColors(eccButtonBackgroundColorEnd) = CLR_NONE) Then
      ButtonBackgroundColorEnd = TranslateColor(m_eColors(eccButtonBackgroundColorEnd))
   Else
      ButtonBackgroundColorEnd = -1
   End If
End Property
Public Property Get ButtonHotBackgroundColorStart() As Long
   If Not (m_eColors(eccButtonHotBackgroundColorStart) = CLR_NONE) Then
      ButtonHotBackgroundColorStart = TranslateColor(m_eColors(eccButtonHotBackgroundColorStart))
   Else
      Select Case m_eStyle
      Case eOffice2003
         Select Case m_iTheme
         Case 1
            ButtonHotBackgroundColorStart = RGB(253, 254, 211)
         Case 2
            ButtonHotBackgroundColorStart = RGB(255, 239, 192)
         Case 3
         Case Else
            If (m_bTrueColor) Then
               ButtonHotBackgroundColorStart = BlendColor(vbHighlight, vb3DHighlight, 77)
            Else
               ButtonHotBackgroundColorStart = TranslateColor(vbButtonFace)
            End If
         End Select
      Case eOfficeXP
         If (m_bTrueColor) Then
            ButtonHotBackgroundColorStart = BlendColor(BlendColor(vb3DHighlight, &HFFFFFF), vbHighlight, 178)
         Else
            ButtonHotBackgroundColorStart = TranslateColor(vbButtonFace)
         End If
      Case eMoney
         ButtonHotBackgroundColorStart = RGB(70, 70, 70)
      Case eComCtl32
         ButtonHotBackgroundColorStart = TranslateColor(vbButtonFace)
      End Select
   End If
End Property
Public Property Get ButtonHotBackgroundColorEnd() As Long
   If Not (m_eColors(eccButtonHotBackgroundColorEnd) = CLR_NONE) Then
      ButtonHotBackgroundColorEnd = TranslateColor(m_eColors(eccButtonHotBackgroundColorEnd))
   Else
      Select Case m_eStyle
      Case eOffice2003
         Select Case m_iTheme
         Case 1
            ButtonHotBackgroundColorEnd = RGB(253, 221, 152)
         Case 2
            ButtonHotBackgroundColorEnd = RGB(255, 220, 115)
         Case 3
         Case Else
            If (m_bTrueColor) Then
               ButtonHotBackgroundColorEnd = BlendColor(vbHighlight, vb3DHighlight, 84)
            Else
               ButtonHotBackgroundColorEnd = ButtonHotBackgroundColorStart
            End If
         End Select
      
      Case Else
         ButtonHotBackgroundColorEnd = ButtonHotBackgroundColorStart
         
      End Select
   End If
   
End Property
Public Property Get ButtonCheckedBackgroundColorStart() As Long
   If Not (m_eColors(eccButtonHotBackgroundColorEnd) = CLR_NONE) Then
      ButtonCheckedBackgroundColorStart = TranslateColor(m_eColors(eccButtonCheckedBackgroundColorStart))
   Else
      Select Case m_eStyle
      Case eOffice2003
         Select Case m_iTheme
         Case 1
            ButtonCheckedBackgroundColorStart = RGB(251, 223, 128)
         Case 2
            ButtonCheckedBackgroundColorStart = RGB(250, 218, 152)
         Case 3
         Case Else
            If (m_bTrueColor) Then
               ButtonCheckedBackgroundColorStart = BlendColor(GradientColorStart, ButtonHotBackgroundColorStart, 16)
            Else
               ButtonCheckedBackgroundColorStart = TranslateColor(vbButtonFace)
            End If
         End Select
      Case eOfficeXP
         If (m_bTrueColor) Then
            ButtonCheckedBackgroundColorStart = BlendColor(vbHighlight, GradientColorStart, 21)
         Else
            ButtonCheckedBackgroundColorStart = TranslateColor(vbButtonFace)
         End If
      Case eMoney
         ButtonCheckedBackgroundColorStart = MenuHotBackgroundColorStart
      Case eComCtl32
         If (m_bTrueColor) Then
            ButtonCheckedBackgroundColorStart = BlendColor(vb3DHighlight, vbButtonFace, 220)
         Else
            ButtonCheckedBackgroundColorStart = TranslateColor(vbButtonFace)
         End If
      End Select
   End If
End Property
Public Property Get ButtonCheckedBackgroundColorEnd() As Long
   If Not (m_eColors(eccButtonCheckedBackgroundColorEnd) = CLR_NONE) Then
      ButtonCheckedBackgroundColorEnd = TranslateColor(eccButtonCheckedBackgroundColorEnd)
   Else
      Select Case m_eStyle
      Case eOffice2003
         Select Case m_iTheme
         Case 1
            ButtonCheckedBackgroundColorEnd = RGB(245, 185, 74)
         Case 2
            ButtonCheckedBackgroundColorEnd = RGB(229, 165, 33)
         Case 3
         Case Else
            ButtonCheckedBackgroundColorEnd = GradientColorStart
         End Select
      Case eOfficeXP
         ButtonCheckedBackgroundColorEnd = ButtonCheckedBackgroundColorStart
      Case eMoney
         ButtonCheckedBackgroundColorEnd = ButtonCheckedBackgroundColorStart
      Case eComCtl32
         ButtonCheckedBackgroundColorEnd = ButtonCheckedBackgroundColorStart
      End Select
   End If
End Property
Public Property Get ButtonCheckedHotBackgroundColorStart() As Long
   If Not (m_eColors(eccButtonCheckedHotBackgroundColorStart) = CLR_NONE) Then
      ButtonCheckedHotBackgroundColorStart = TranslateColor(eccButtonCheckedHotBackgroundColorStart)
   Else
      Select Case m_eStyle
      Case eOffice2003
         Select Case m_iTheme
         Case 1
            ButtonCheckedHotBackgroundColorStart = RGB(251, 139, 89)
         Case 2
            ButtonCheckedHotBackgroundColorStart = RGB(236, 176, 139)
         Case 3
         Case Else
            If (m_bTrueColor) Then
               ButtonCheckedHotBackgroundColorStart = BlendColor(vbHighlight, vb3DHighlight)
            Else
               ButtonCheckedHotBackgroundColorStart = TranslateColor(vb3DHighlight)
            End If
         End Select
      Case eOfficeXP
         If (m_bTrueColor) Then
            ButtonCheckedHotBackgroundColorStart = BlendColor(vb3DHighlight, vbHighlight)
         Else
            ButtonCheckedHotBackgroundColorStart = TranslateColor(vb3DHighlight)
         End If
      Case eMoney
         ButtonCheckedHotBackgroundColorStart = RGB(90, 90, 90)
      Case eComCtl32
         ButtonCheckedHotBackgroundColorStart = TranslateColor(vbButtonFace)
      End Select
   End If
End Property
Public Property Get ButtonCheckedHotBackgroundColorEnd() As Long
   If Not (m_eColors(eccButtonCheckedHotBackgroundColorEnd) = CLR_NONE) Then
      ButtonCheckedHotBackgroundColorEnd = TranslateColor(eccButtonCheckedHotBackgroundColorEnd)
   Else
      Select Case m_eStyle
      Case eOffice2003
         Select Case m_iTheme
         Case 1
            ButtonCheckedHotBackgroundColorEnd = RGB(206, 47, 3)
         Case 2
            ButtonCheckedHotBackgroundColorEnd = RGB(196, 103, 48)
         Case 3
         Case Else
            If (m_bTrueColor) Then
               ButtonCheckedHotBackgroundColorEnd = BlendColor(vbHighlight, vb3DHighlight, 150)
            Else
               ButtonCheckedHotBackgroundColorEnd = ButtonCheckedHotBackgroundColorStart
            End If
         End Select
      Case eOfficeXP
         ButtonCheckedHotBackgroundColorEnd = ButtonCheckedHotBackgroundColorStart
      Case eMoney
         ButtonCheckedHotBackgroundColorEnd = ButtonCheckedHotBackgroundColorStart
      Case eComCtl32
         ButtonCheckedHotBackgroundColorEnd = ButtonCheckedHotBackgroundColorStart
      End Select
   End If
End Property
' Menu colours:
Public Property Get MenuShadowColor() As Long
   If Not (m_eColors(eccMenuShadowColor) = CLR_NONE) Then
      MenuShadowColor = TranslateColor(m_eColors(eccMenuShadowColor))
   Else
      If (m_eStyle = eMoney) Then
         MenuShadowColor = &H0
      ElseIf (m_eStyle = eOfficeXP) Or (m_eStyle = eComCtl32) Then
         MenuShadowColor = GetSysColor(vb3DDKShadow)
      Else
         MenuShadowColor = ButtonTextDisabledColor
      End If
   End If
End Property

Public Property Get MenuBorderColor() As Long
   If Not (m_eColors(eccMenuBorderColor) = CLR_NONE) Then
      MenuBorderColor = TranslateColor(m_eColors(eccMenuBorderColor))
   Else
      Select Case m_eStyle
      Case eOffice2003
         Select Case m_iTheme
         Case 1
            MenuBorderColor = RGB(0, 45, 150)
         Case 2
            MenuBorderColor = RGB(124, 124, 148)
         Case 3
         Case Else
            If (m_bTrueColor) Then
               MenuBorderColor = BlendColor(vb3DDKShadow, vb3DShadow, 96)
            Else
               MenuBorderColor = vb3DShadow
            End If
         End Select
      Case eOfficeXP
         If (m_bTrueColor) Then
            MenuBorderColor = BlendColor(vbButtonShadow, vb3DDKShadow, 108)
         Else
            MenuBorderColor = TranslateColor(vbButtonShadow)
         End If
      Case eMoney
         MenuBorderColor = RGB(68, 68, 68)
      Case eComCtl32
         MenuBorderColor = TranslateColor(vbButtonShadow)
      End Select
   End If
End Property

Public Property Get MenuHotBorderColor() As Long
   If Not (m_eColors(eccMenuHotBorderColor) = CLR_NONE) Then
      MenuHotBorderColor = TranslateColor(m_eColors(eccMenuHotBorderColor))
   Else
      Select Case m_eStyle
      Case eOffice2003
         Select Case m_iTheme
         Case 1
            MenuHotBorderColor = RGB(0, 0, 128)
         Case 2
            MenuHotBorderColor = RGB(75, 75, 111)
         Case 3
         Case Else
            MenuHotBorderColor = GetSysColor(vbHighlight And &H1F&)
         End Select
      Case eOfficeXP
         MenuHotBorderColor = GetSysColor(vbHighlight And &H1F&)
      Case eMoney
         MenuHotBorderColor = RGB(65, 65, 65)
      Case eComCtl32
         MenuHotBorderColor = GetSysColor(vbHighlight And &H1F&)
      End Select
   End If
End Property

Public Property Get MenuTextColor() As Long
   If Not (m_eColors(eccMenuTextColor) = CLR_NONE) Then
      MenuTextColor = TranslateColor(m_eColors(eccMenuTextColor))
   Else
      If (m_eStyle = eMoney) Then
         MenuTextColor = RGB(255, 255, 255)
      Else
         MenuTextColor = GetSysColor(vbWindowText And &H1F&)
      End If
   End If
End Property
Public Property Get MenuTextHotColor() As Long
   If Not (m_eColors(eccMenuTextHotColor) = CLR_NONE) Then
      MenuTextHotColor = TranslateColor(m_eColors(eccMenuTextHotColor))
   Else
      Select Case m_eStyle
      Case eMoney
         MenuTextHotColor = RGB(255, 223, 127)
      Case eComCtl32
         MenuTextHotColor = TranslateColor(vbHighlightText)
      Case Else
         MenuTextHotColor = MenuTextColor
      End Select
   End If
End Property
Public Property Get MenuTextDisabledColor() As Long
   If Not (m_eColors(eccMenuTextDisabledColor) = CLR_NONE) Then
      MenuTextDisabledColor = TranslateColor(m_eColors(eccMenuTextDisabledColor))
   Else
      Select Case m_eStyle
      Case eOffice2003
         Select Case m_iTheme
         Case 1
            MenuTextDisabledColor = RGB(160, 160, 160)
         Case 2
            MenuTextDisabledColor = RGB(148, 148, 148)
         Case 3
         Case Else
            MenuTextDisabledColor = DarkColor
         End Select
      Case eOfficeXP
         If (m_bTrueColor) Then
            MenuTextDisabledColor = BlendColor(vbButtonFace, vbGrayText, 128)
         Else
            MenuTextDisabledColor = DarkColor
         End If
      Case eMoney
         MenuTextDisabledColor = RGB(145, 145, 145)
      Case eComCtl32
         MenuTextDisabledColor = DarkColor
      End Select
   End If
End Property
Public Property Get MenuBackgroundColorStart() As Long
   If Not (m_eColors(eccMenuBackgroundColorStart) = CLR_NONE) Then
      MenuBackgroundColorStart = TranslateColor(m_eColors(eccMenuBackgroundColorStart))
   Else
      If Not (m_bTrueColor) Then
         MenuBackgroundColorStart = GetSysColor(vbMenuBar And &H1F&)
      Else
         Select Case m_eStyle
         Case eOffice2003
            Select Case m_iTheme
            Case 1
               MenuBackgroundColorStart = RGB(246, 246, 246) 'GetSysColor(vbMenuBar And &H1F&)
            Case 2
               MenuBackgroundColorStart = RGB(253, 250, 255)
            Case 3
            Case Else
               MenuBackgroundColorStart = RGB(249, 248, 247)
            End Select
         Case eOfficeXP
            MenuBackgroundColorStart = BlendColor(vbWindowBackground, vbButtonFace, 220)
         Case eMoney
            MenuBackgroundColorStart = RGB(91, 91, 91)
         Case Else
            MenuBackgroundColorStart = TranslateColor(vbMenuBar)
         End Select
      End If
   End If
End Property
Public Property Get MenuBackgroundColorEnd() As Long
   If Not (m_eColors(eccMenuBackgroundColorEnd) = CLR_NONE) Then
      MenuBackgroundColorEnd = TranslateColor(m_eColors(eccMenuBackgroundColorEnd))
   Else
      Select Case m_eStyle
      Case eOffice2003
         Select Case m_iTheme
         Case 1
            MenuBackgroundColorEnd = MenuBackgroundColorStart
         Case 2
            MenuBackgroundColorEnd = MenuBackgroundColorStart
         Case 3
            MenuBackgroundColorEnd = MenuBackgroundColorStart
         Case Else
            MenuBackgroundColorEnd = MenuBackgroundColorStart
         End Select
      Case eOfficeXP
         MenuBackgroundColorEnd = MenuBackgroundColorStart
      Case eMoney
         MenuBackgroundColorEnd = MenuBackgroundColorStart
      Case Else
         MenuBackgroundColorEnd = MenuBackgroundColorStart
      End Select
   End If
End Property
Public Property Get MenuHotBackgroundColorStart() As Long
   If Not (m_eColors(eccMenuHotBackgroundColorStart) = CLR_NONE) Then
      MenuHotBackgroundColorStart = TranslateColor(m_eColors(eccMenuHotBackgroundColorStart))
   Else
      Select Case m_eStyle
      Case eComCtl32
         MenuHotBackgroundColorStart = TranslateColor(vbHighlight)
      Case Else
         MenuHotBackgroundColorStart = ButtonHotBackgroundColorStart
      End Select
   End If
End Property
Public Property Get MenuHotBackgroundColorEnd() As Long
   If Not (m_eColors(eccMenuHotBackgroundColorEnd) = CLR_NONE) Then
      MenuHotBackgroundColorEnd = TranslateColor(m_eColors(eccMenuHotBackgroundColorEnd))
   Else
      Select Case m_eStyle
      Case eComCtl32
         MenuHotBackgroundColorEnd = MenuHotBackgroundColorStart
      Case Else
         MenuHotBackgroundColorEnd = ButtonHotBackgroundColorEnd
      End Select
   End If
End Property
Public Property Get MenuCheckedBackgroundColorStart() As Long
   If Not (m_eColors(eccMenuCheckedBackgroundColorStart) = CLR_NONE) Then
      MenuCheckedBackgroundColorStart = TranslateColor(m_eColors(eccMenuHotBackgroundColorEnd))
   Else
      Select Case m_eStyle
      Case eComCtl32
         MenuCheckedBackgroundColorStart = MenuBackgroundColorStart
      Case Else
         MenuCheckedBackgroundColorStart = ButtonCheckedBackgroundColorStart
      End Select
   End If
End Property
Public Property Get MenuCheckedBackgroundColorEnd() As Long
   If Not (m_eColors(eccMenuCheckedBackgroundColorEnd) = CLR_NONE) Then
      MenuCheckedBackgroundColorEnd = TranslateColor(m_eColors(eccMenuCheckedBackgroundColorEnd))
   Else
      Select Case m_eStyle
      Case eComCtl32
         MenuCheckedBackgroundColorEnd = MenuBackgroundColorStart
      Case Else
         MenuCheckedBackgroundColorEnd = ButtonCheckedBackgroundColorEnd
      End Select
   End If
End Property
Public Property Get MenuCheckedHotBackgroundColorStart() As Long
   If Not (m_eColors(eccMenuCheckedHotBackgroundColorStart) = CLR_NONE) Then
      MenuCheckedHotBackgroundColorStart = TranslateColor(m_eColors(eccMenuCheckedHotBackgroundColorStart))
   Else
      Select Case m_eStyle
      Case eComCtl32
         MenuCheckedHotBackgroundColorStart = MenuBackgroundColorStart
      Case Else
         MenuCheckedHotBackgroundColorStart = ButtonCheckedHotBackgroundColorStart
      End Select
   End If
End Property
Public Property Get MenuCheckedHotBackgroundColorEnd() As Long
   If Not (m_eColors(eccMenuCheckedHotBackgroundColorEnd) = CLR_NONE) Then
      MenuCheckedHotBackgroundColorEnd = TranslateColor(m_eColors(MenuCheckedHotBackgroundColorEnd))
   Else
      Select Case m_eStyle
      Case eComCtl32
         MenuCheckedHotBackgroundColorEnd = MenuBackgroundColorStart
      Case Else
         MenuCheckedHotBackgroundColorEnd = ButtonCheckedHotBackgroundColorEnd
      End Select
   End If
End Property

' General colours:
Public Property Get IconDisabledColor() As Long
   If Not (m_eColors(eccIconDisabledColor) = CLR_NONE) Then
      IconDisabledColor = m_eColors(eccIconDisabledColor)
   Else
      Select Case m_eStyle
      Case eOffice2003
         Select Case m_iTheme
         Case 1
            IconDisabledColor = RGB(109, 150, 208)
         Case 2
            IconDisabledColor = RGB(168, 167, 190)
         Case 3
         Case Else
            If (m_bTrueColor) Then
               IconDisabledColor = BlendColor(vbButtonShadow, vb3DHighlight, 224)
            Else
               IconDisabledColor = TranslateColor(vbButtonShadow)
            End If
         End Select
      Case eOfficeXP
         IconDisabledColor = GetSysColor(vbButtonShadow And &H1F&)
      Case eMoney
         IconDisabledColor = RGB(70, 70, 70)
      Case eComCtl32
         IconDisabledColor = GetSysColor(vbButtonShadow And &H1F&)
      End Select
   End If
End Property

Public Property Get LightColor() As Long
   If Not (m_eColors(eccLightColor) = CLR_NONE) Then
      LightColor = TranslateColor(m_eColors(eccLightColor))
   Else
      Select Case m_eStyle
      Case eOffice2003
         Select Case m_iTheme
         Case 1
            LightColor = RGB(255, 255, 255)
         Case 2
            LightColor = RGB(255, 255, 255)
         Case 3
         Case Else
            LightColor = GetSysColor(vb3DHighlight And &H1F&)
         End Select
      Case eOfficeXP
         LightColor = GetSysColor(vb3DHighlight And &H1F&)
      Case eMoney
         LightColor = RGB(160, 160, 160)
      Case eComCtl32
         LightColor = TranslateColor(vb3DHighlight)
      End Select
   End If
End Property
Public Property Get DarkColor() As Long
   If Not (m_eColors(eccDarkColor) = CLR_NONE) Then
      DarkColor = m_eColors(eccDarkColor)
   Else
      Select Case m_eStyle
      Case eOffice2003
         Select Case m_iTheme
         Case 1
            DarkColor = RGB(106, 140, 203)
         Case 2
            DarkColor = RGB(110, 109, 143)
         Case 3
         Case Else
            If (m_bTrueColor) Then
               DarkColor = BlendColor(vbButtonShadow, vb3DHighlight, 180)
            Else
               DarkColor = TranslateColor(vbButtonShadow)
            End If
         End Select
      Case eOfficeXP
         DarkColor = GetSysColor(vbButtonShadow And &H1F&)
      Case eMoney
         DarkColor = RGB(112, 112, 112)
      Case eComCtl32
         DarkColor = TranslateColor(vbButtonShadow)
      End Select
   End If
End Property

Public Property Get GradientColorStart() As Long
   If Not (m_eColors(eccGradientColorStart) = CLR_NONE) Then
      GradientColorStart = TranslateColor(m_eColors(eccGradientColorStart))
   Else
      Select Case m_eStyle
      Case eOffice2003
         Select Case m_iTheme
         Case 1
            GradientColorStart = RGB(209, 227, 251)
         Case 2
            GradientColorStart = RGB(249, 249, 255)
         Case 3
         Case Else
            If (m_bTrueColor) Then
               GradientColorStart = BlendColor(vbButtonFace, vb3DHighlight, 24)
            Else
               GradientColorStart = TranslateColor(vbButtonFace)
            End If
         End Select
      Case eOfficeXP
         If (m_bTrueColor) Then
            GradientColorStart = BlendColor(vb3DLight, vbButtonFace)
         Else
            GradientColorStart = TranslateColor(vbButtonFace)
         End If
      Case eMoney
         GradientColorStart = MenuBackgroundColorStart
      Case eComCtl32
         GradientColorStart = CLR_NONE
      End Select
   End If
End Property

Public Property Get GradientColorEnd() As Long
   If Not (m_eColors(eccGradientColorEnd) = CLR_NONE) Then
      GradientColorEnd = TranslateColor(m_eColors(eccGradientColorEnd))
   Else
      Select Case m_eStyle
      Case eOffice2003
         Select Case m_iTheme
         Case 1
            GradientColorEnd = RGB(129, 169, 226)
         Case 2
            GradientColorEnd = RGB(159, 157, 185)
         Case 3
         Case Else
            GradientColorEnd = GetSysColor(vbButtonFace And &H1F&)
         End Select
      Case eOfficeXP
         GradientColorEnd = GradientColorStart
      Case eMoney
         GradientColorEnd = GradientColorStart
      Case eComCtl32
         GradientColorEnd = CLR_NONE
      End Select
   End If
End Property

Public Function TranslateColor(ByVal oClr As OLE_COLOR, _
                        Optional hPal As Long = 0) As Long
    ' Convert Automation color to Windows color
    If OleTranslateColor(oClr, hPal, TranslateColor) Then
        TranslateColor = CLR_INVALID
    End If
End Function

Public Property Get BlendColor( _
      ByVal oColorFrom As OLE_COLOR, _
      ByVal oColorTo As OLE_COLOR, _
      Optional ByVal Alpha As Long = 128 _
   ) As Long
Dim lCFrom As Long
Dim lCTo As Long
   lCFrom = TranslateColor(oColorFrom)
   lCTo = TranslateColor(oColorTo)
Dim lSrcR As Long
Dim lSrcG As Long
Dim lSrcB As Long
Dim lDstR As Long
Dim lDstG As Long
Dim lDstB As Long
   lSrcR = lCFrom And &HFF
   lSrcG = (lCFrom And &HFF00&) \ &H100&
   lSrcB = (lCFrom And &HFF0000) \ &H10000
   lDstR = lCTo And &HFF
   lDstG = (lCTo And &HFF00&) \ &H100&
   lDstB = (lCTo And &HFF0000) \ &H10000
     
   
   BlendColor = RGB( _
      ((lSrcR * Alpha) / 255) + ((lDstR * (255 - Alpha)) / 255), _
      ((lSrcG * Alpha) / 255) + ((lDstG * (255 - Alpha)) / 255), _
      ((lSrcB * Alpha) / 255) + ((lDstB * (255 - Alpha)) / 255) _
      )
      
End Property


