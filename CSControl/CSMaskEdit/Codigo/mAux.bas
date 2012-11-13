Attribute VB_Name = "mAux"
Option Explicit

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    Public Enum STATUS_BUTTON
        PRESSED = 1
        UNPRESSED = 2
        MOUSE_MOVE = 3
    End Enum
    ' estructuras
    Public Type RECT
            Left As Long
            Top As Long
            Right As Long
            Bottom As Long
    End Type
    
    ' funciones
    Public Declare Function ReleaseCapture Lib "user32" () As Long
    Public Declare Function SetCapture Lib "user32" (ByVal hWnd As Long) As Long
    Public Declare Function GetWindowRect Lib "user32" (ByVal hWnd As Long, lpRect As RECT) As Long
    Public Declare Function FillRect Lib "user32" (ByVal hDC As Long, lptR As RECT, ByVal hBrush As Long) As Long
    Public Declare Function OleTranslateColor Lib "OLEPRO32.DLL" (ByVal OLE_COLOR As Long, ByVal HPALETTE As Long, pccolorref As Long) As Long
    Public Declare Function CreateSolidBrush Lib "gdi32" (ByVal crColor As Long) As Long
    Public Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long

'--------------------------------------------------------------------------------

Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)


Public Const csNoDate          As Date = #1/1/1900#
