Attribute VB_Name = "mMouse"
'==========================================================
'           Copyright Information
'==========================================================
'Program Name: Mewsoft Editawy
'Program Author   : Elsheshtawy, A. A.
'Home Page        : http://www.mewsoft.com
'Copyrights © 2006 Mewsoft Corporation. All rights reserved.
'==========================================================
'==========================================================
Option Explicit

'GetMousePos
Private aPosition As POINTAPI
Private Type POINTAPI
    X As Long
    Y As Long
End Type
Private Declare Function GetCursorPos Lib "user32" (lpPoint As POINTAPI) As Long

Public Function MousePosX() As Long
    GetCursorPos aPosition
    MousePosX = aPosition.X * Screen.TwipsPerPixelX
End Function

Public Function MousePosY() As Long
    GetCursorPos aPosition
    MousePosY = aPosition.Y * Screen.TwipsPerPixelY
End Function
