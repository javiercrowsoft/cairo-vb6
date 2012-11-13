Attribute VB_Name = "mWinApi"
Option Explicit

'--------------------------------------------------------------------------------
' mWinApi
' 31-01-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    Public Const LVM_FIRST As Long = &H1000
    Public Const LVM_SETCOLUMNWIDTH As Long = (LVM_FIRST + 30)
    Public Const LVSCW_AUTOSIZE As Long = -1
    Public Const LVSCW_AUTOSIZE_USEHEADER As Long = -2

    ' estructuras
    ' funciones
    Public Declare Function LockWindowUpdate Lib "user32" (ByVal hwndLock As Long) As Long
    Public Declare Function SendMessage Lib "user32" _
                               Alias "SendMessageA" _
                                            (ByVal hwnd As Long, _
                                             ByVal wMsg As Long, _
                                             ByVal wParam As Long, _
                                             lParam As Any) As Long
'--------------------------------------------------------------------------------

' constantes
' estructuras
' variables privadas
' Properties publicas
' Properties privadas
' funciones publicas
' funciones privadas
' construccion - destruccion

