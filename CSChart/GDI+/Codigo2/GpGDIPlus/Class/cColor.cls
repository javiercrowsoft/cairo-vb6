VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cColor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cColor.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiplusColor.h:Microsoft Platform SDK February 2003
'
' Color object stores a 32-bit value that represents a color. The color value
' contains four, 8-bit components: alpha, red, green, and blue. The first 8
' bits (the most significant) contain the alpha component, the next 8 bits contain
' the red component, the next 8 bits contain the green component, and the next 8 bits
' (the least significant) contain the blue component. The 32-bit value is stored in a
' variable of type ARGB.
' ==================================================================================

Private m_lngColor As Long

' Creates a Color object by using specified values for the alpha, red, green, and blue components.
Public Sub FromARGB(ByVal alpha As Byte, ByVal Red As Byte, ByVal Green As Byte, ByVal Blue As Byte)
   m_lngColor = MakeARGB(alpha, Red, Green, Blue)
End Sub

' Creates a Color object by using an ARGB value.
Public Sub FromARGBColor(ByVal argb As Long)
    m_lngColor = argb
End Sub

' Creates a Color object by using specified values for the red, green, and blue components.
' This constructor sets the alpha component to 255 (opaque).
Public Sub FromRGB(ByVal Red As Byte, ByVal Green As Byte, ByVal Blue As Byte)
    m_lngColor = MakeARGB(255, Red, Green, Blue)
End Sub

' Creates a Color object by using an VB/standard color value.
Public Sub FromRGBColor(ByVal lrgb As Long)
    Call SetFromCOLORREF(lrgb)
End Sub

' gets the alpha component of this Color object.
Public Function GetAlpha() As Byte
   Dim argb As COLORBYTES
   
   CopyMemory argb, m_lngColor, 4
   GetAlpha = argb.AlphaByte
End Function

' gets the blue component of this Color object.
Public Function GetBlue() As Byte
   Dim argb As COLORBYTES
   
   CopyMemory argb, m_lngColor, 4
   GetBlue = argb.BlueByte
End Function

' gets the green component of this Color object.
Public Function GetGreen() As Byte
   Dim argb As COLORBYTES
   
   CopyMemory argb, m_lngColor, 4
   GetGreen = argb.GreenByte
End Function

' gets the red component of this Color object.
Public Function GetRed() As Byte
   Dim argb As COLORBYTES
   
   CopyMemory argb, m_lngColor, 4
   GetRed = argb.RedByte
End Function

Public Function GetValue() As Long
    GetValue = m_lngColor
End Function

Public Function MakeARGB(ByVal alpha As Byte, ByVal Red As Byte, ByVal Green As Byte, ByVal Blue As Byte) As Long
   Dim bytestruct As COLORBYTES
   Dim result As COLORLONG
   
   With bytestruct
      .AlphaByte = alpha
      .RedByte = Red
      .GreenByte = Green
      .BlueByte = Blue
   End With
   
   LSet result = bytestruct
   MakeARGB = result.longval
End Function

Public Sub SetAlpha(ByVal alpha As Byte)
    Dim argb As COLORBYTES
    Dim result As COLORLONG
    
    CopyMemory argb, m_lngColor, 4

    argb.AlphaByte = alpha

    LSet result = argb
    m_lngColor = result.longval
End Sub

Public Sub SetFromCOLORREF(ByVal lrgb As Long)
   Dim rgbq As RGBQUAD
   
   CopyMemory rgbq, lrgb, 4
   ' I must have done something wrong, but swapping Red and Blue works...
   m_lngColor = MakeARGB(255, rgbq.rgbBlue, rgbq.rgbGreen, rgbq.rgbRed)
End Sub

Public Sub SetValue(ByVal argb As Long)
    m_lngColor = argb
End Sub

Public Function ToCOLORREF() As Long
   Dim argb As COLORBYTES
   
   CopyMemory argb, m_lngColor, 4
   ToCOLORREF = RGB(argb.RedByte, argb.GreenByte, argb.BlueByte)
End Function

Private Sub Class_Initialize()
    m_lngColor = 0
End Sub

Private Sub Class_Terminate()
    m_lngColor = 0
End Sub
