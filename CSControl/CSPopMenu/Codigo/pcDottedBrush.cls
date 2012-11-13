VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "pcDottedBrush"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' ===============================================================================================
' vbAccelerator
' http://vbaccelerator.com/
' Copyright © 1999 Steve McMahon (steve@vbaccelerator.com)
'
' cDottedBrush
' Allows drawing of correct dotted brushes like the ones in the TreeView.
'
' Based on an article "Drawing Dotted Lines" by Jean-Edouard Lachand-Robert published
' at CodeGuru (http://www.codeguru.com/)
' ===============================================================================================

Private Type BITMAP '24 bytes
   bmType As Long
   bmWidth As Long
   bmHeight As Long
   bmWidthBytes As Long
   bmPlanes As Integer
   bmBitsPixel As Integer
   bmBits As Long
End Type
Private Type POINTAPI
   x As Long
   y As Long
End Type
Private Type RECT
   Left As Long
   Top As Long
   Right As Long
   Bottom As Long
End Type
Private Declare Function SetBrushOrgEx Lib "gdi32" (ByVal hdc As Long, ByVal nXOrg As Long, ByVal nYOrg As Long, lppt As Any) As Long
Private Declare Function UnrealizeObject Lib "gdi32" (ByVal hObject As Long) As Long
Private Declare Function SelectObject Lib "gdi32" (ByVal hdc As Long, ByVal hObject As Long) As Long
Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Private Declare Function PatBlt Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal dwRop As Long) As Long
Private Declare Function CreateBitmapIndirect Lib "gdi32" (lpBitmap As BITMAP) As Long
Private Declare Function CreatePatternBrush Lib "gdi32" (ByVal hBitmap As Long) As Long
Private Declare Function FillRect Lib "user32" (ByVal hdc As Long, lpRect As RECT, ByVal hBrush As Long) As Long
Private Declare Function OleTranslateColor Lib "OLEPRO32.DLL" (ByVal OLE_COLOR As Long, ByVal HPALETTE As Long, pccolorref As Long) As Long
Private Const CLR_INVALID = -1
Private Declare Function SetBkColor Lib "gdi32" (ByVal hdc As Long, ByVal crColor As Long) As Long
Private Declare Function SetTextColor Lib "gdi32" (ByVal hdc As Long, ByVal crColor As Long) As Long

Public Enum EPBRasterOperations
   PATCOPY = &HF00021  ' (DWORD) dest = pattern
   PATINVERT = &H5A0049        ' (DWORD) dest = pattern XOR dest
   PATPAINT = &HFB0A09        ' (DWORD) dest = DPSnoo
End Enum

' The brush:
Private m_hBrush As Long
' The brush's pattern:
Private m_lPattern(0 To 3) As Long

Private Function TranslateColor(ByVal oClr As OLE_COLOR, _
                        Optional hPal As Long = 0) As Long
    ' Convert Automation color to Windows color
    If OleTranslateColor(oClr, hPal, TranslateColor) Then
        TranslateColor = CLR_INVALID
    End If
End Function

Public Function Create() As Boolean
Dim tbm As BITMAP
Dim hBm As Long

   Destroy
      
   ' Create a monochrome bitmap containing the desired pattern:
   tbm.bmType = 0
   tbm.bmWidth = 16
   tbm.bmHeight = 8
   tbm.bmWidthBytes = 2
   tbm.bmPlanes = 1
   tbm.bmBitsPixel = 1
   tbm.bmBits = VarPtr(m_lPattern(0))
   hBm = CreateBitmapIndirect(tbm)

   ' Make a brush from the bitmap bits
   m_hBrush = CreatePatternBrush(hBm)

   '// Delete the useless bitmap
   DeleteObject hBm

End Function

Public Sub Destroy()
   If m_hBrush <> 0 Then
      DeleteObject m_hBrush
      m_hBrush = 0
   End If
End Sub
Public Sub DrawLine( _
      ByVal hdc As Long, _
      ByVal xPixels As Long, _
      ByVal yPixels As Long, _
      ByVal widthPixels As Long, _
      ByVal heightPixels As Long, _
      Optional ByVal eRop As EPBRasterOperations = PATCOPY, _
      Optional ByVal oBackColor As OLE_COLOR = -1, _
      Optional ByVal oForeColor As OLE_COLOR = -1 _
   )
Dim hOldBrush As Long
Dim lBkColor As Long
Dim lForeColor As Long
   hOldBrush = SelectObject(hdc, m_hBrush)
      If Not (oBackColor = -1) Then
         lBkColor = SetBkColor(hdc, TranslateColor(oBackColor))
      End If
      If Not (oForeColor = -1) Then
         lForeColor = SetTextColor(hdc, TranslateColor(oForeColor))
      End If
   PatBlt hdc, xPixels, yPixels, widthPixels, heightPixels, eRop
   If Not (oBackColor = -1) Then
      SetBkColor hdc, lBkColor
   End If
   If Not (oForeColor = -1) Then
       SetTextColor hdc, lForeColor
   End If
   SelectObject hdc, hOldBrush
End Sub
Public Sub Rectangle( _
      ByVal hdc As Long, _
      ByVal xPixels As Long, _
      ByVal yPixels As Long, _
      ByVal widthRectPixels As Long, _
      ByVal heightRectPixels As Long, _
      ByVal lineSizePixels As Long, _
      Optional ByVal eRop As EPBRasterOperations = PATCOPY, _
      Optional ByVal bFill As Boolean = False, _
      Optional ByVal oBackColor As OLE_COLOR = -1, _
      Optional ByVal oForeColor As OLE_COLOR = -1 _
   )
Dim lBkColor As Long
Dim lForeColor As Long

   If bFill Then
      If Not (oBackColor = -1) Then
         lBkColor = SetBkColor(hdc, TranslateColor(oBackColor))
      End If
      If Not (oForeColor = -1) Then
         lForeColor = SetTextColor(hdc, TranslateColor(oForeColor))
      End If
      
      Dim tR As RECT
      tR.Left = xPixels: tR.Top = xPixels
      tR.Right = tR.Left + widthRectPixels: tR.Bottom = tR.Top + heightRectPixels
      FillRect hdc, tR, m_hBrush
   Else
      Dim hOldBrush As Long
      hOldBrush = SelectObject(hdc, m_hBrush)
      If Not (oBackColor = -1) Then
         lBkColor = SetBkColor(hdc, TranslateColor(oBackColor))
      End If
      If Not (oForeColor = -1) Then
         lForeColor = SetTextColor(hdc, TranslateColor(oForeColor))
      End If
      PatBlt hdc, xPixels, yPixels, widthRectPixels, lineSizePixels, eRop
      PatBlt hdc, xPixels + widthRectPixels, yPixels, lineSizePixels, heightRectPixels, eRop
      PatBlt hdc, xPixels, yPixels + heightRectPixels, widthRectPixels, lineSizePixels, eRop
      PatBlt hdc, xPixels, yPixels, lineSizePixels, heightRectPixels, eRop
      If Not (oBackColor = -1) Then
         SetBkColor hdc, lBkColor
      End If
      If Not (oForeColor = -1) Then
          SetTextColor hdc, lForeColor
      End If
      SelectObject hdc, hOldBrush
   End If
End Sub
   
Public Sub SetBrushOrigin( _
      ByVal hdc As Long, _
      ByVal xPixels As Long, _
      ByVal yPixels As Long _
   )
   SetBrushOrgEx hdc, -xPixels And &H7&, -yPixels And &H7&, ByVal 0&
End Sub


Private Sub Class_Initialize()
Dim i As Long
   For i = 0 To 3
      m_lPattern(i) = &HAAAA5555
   Next i
End Sub

Private Sub Class_Terminate()
   Destroy
End Sub





