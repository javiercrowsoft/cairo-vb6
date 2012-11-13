Attribute VB_Name = "mAux"
Option Explicit

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  Type BITMAP '14 bytes
    bmType As Long
    bmWidth As Long
    bmHeight As Long
    bmWidthBytes As Long
    bmPlanes As Integer
    bmBitsPixel As Integer
    bmBits As Long
  End Type
  ' funciones
  Public Declare Function GetObjectAPI Lib "gdi32" Alias "GetObjectA" (ByVal hObject As Long, ByVal nCount As Long, lpObject As Any) As Long
  Public Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
  Private Declare Function CreateDCAsNull Lib "gdi32" Alias "CreateDCA" (ByVal lpDriverName As String, lpDeviceName As Any, lpOutput As Any, lpInitData As Any) As Long
  Private Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hDC As Long) As Long
  Private Declare Function SelectObject Lib "gdi32" (ByVal hDC As Long, ByVal hObject As Long) As Long
  Private Declare Function DeleteDC Lib "gdi32" (ByVal hDC As Long) As Long
  Private Declare Function CreateCompatibleBitmap Lib "gdi32" (ByVal hDC As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
  Private Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
  
Private Const csNoFecha As Date = #1/1/1900#
  
Public Function IsDbNull(ByVal Val As Variant) As Boolean
  IsDbNull = IsNull(Val)
End Function

Public Function GetRealName(ByVal Name As String) As String
  GetRealName = Name
End Function

Public Sub GetBitmapSize(ByVal hBmp, ByRef Width As Long, ByRef Height As Long)
  Dim sBitmapInfo   As BITMAP

  ' get the information about this image
  GetObjectAPI hBmp, Len(sBitmapInfo), sBitmapInfo

  Width = sBitmapInfo.bmWidth
  Height = sBitmapInfo.bmHeight
End Sub

Public Function CopyBitmap(ByVal hBmp As Long, _
                           ByVal Width As Long, ByVal Height As Long, _
                           ByVal hCurrentBmp As Long) As Long
  Dim hDCDest   As Long
  Dim hBmpOld   As Long
  Dim hDCSource As Long
  Dim hDCNULL   As Long
  
  hDCNULL = CreateDCAsNull("DISPLAY", ByVal 0&, ByVal 0&, ByVal 0&)
  hDCSource = CreateCompatibleDC(hDCNULL)
  DeleteObject SelectObject(hDCSource, hBmp)
  DeleteDC hDCNULL
  
  hDCDest = CreateCompatibleDC(hDCSource)
  hBmp = CreateCompatibleBitmap(hDCSource, Width, Height)
  hBmpOld = SelectObject(hDCDest, hBmp)
  
  BitBlt hDCDest, 0, 0, Width, Height, hDCSource, 0, 0, vbSrcCopy
  
  SelectObject hDCDest, hBmpOld
  DeleteObject hDCDest
  
  If hCurrentBmp <> 0 Then
    DeleteObject hCurrentBmp
  End If
  
  CopyBitmap = hBmp
End Function

Public Function ValVariant(ByRef Var As Variant) As Variant
  If IsDbNull(Var) Then
    Select Case VarType(Var)
      Case VbVarType.vbString
        ValVariant = ""
      Case VbVarType.vbBoolean
        ValVariant = 0
      Case VbVarType.vbByte, VbVarType.vbDecimal, VbVarType.vbDouble, VbVarType.vbDouble, _
           VbVarType.vbInteger, VbVarType.vbLong, VbVarType.vbByte, VbVarType.vbSingle
        ValVariant = 0
      Case VbVarType.vbDate
        ValVariant = csNoFecha
    End Select
  Else
    ValVariant = Var
  End If
End Function

Public Function Format(Expression, _
                       Optional strFormat, _
                       Optional FirstDayOfWeek As VbDayOfWeek = vbSunday, _
                       Optional FirstWeekOfYear As VbFirstWeekOfYear = vbFirstJan1) As Variant
  If IsMissing(strFormat) Then
    Format = Expression
  ElseIf IsEmpty(strFormat) Then
    Format = Expression
  ElseIf strFormat = "" Then
    Format = Expression
  Else
    Format = VBA.Format(Expression, strFormat, FirstDayOfWeek, FirstWeekOfYear)
  End If
End Function


