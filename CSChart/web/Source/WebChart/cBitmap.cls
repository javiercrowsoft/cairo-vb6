VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cBitmap"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'/////////////////////////////////////////////////////////////////////////////////////////
' CopyRight © 2003-2005 Javier Alvarez (javier@crowsoft.com.ar)

' This library is free software; you can redistribute it and/or modify
' it under the terms of the GNU Lesser Gereral Public Licence as published
' by the Free Software Foundation; either version 2 of the Licence,
' or (at your opinion) any later version.

' This library is distributed in the hope that it will be usefull,
' but WITHOUT ANY WARRANTY; without even the implied warranty of merchantability
' or fitness for a particular purpose. See the GNU Lesser General Public Licence
' for more details.

' You should have received a copy of the GNU Lesser General Public Licence
' along with this library; if not, write to the Free Software Foundation, Inc.,
' 59 Temple Place, Suite 330, Boston, Ma 02111-1307 USA.

' Visit CrowSoft.
'    http://www.crowsoft.com.ar
'/////////////////////////////////////////////////////////////////////////////////////////

Private m_Bitmap As GpGDIPlus.cBitmap

Public Property Get Bitmap() As GpGDIPlus.cBitmap
  Set Bitmap = m_Bitmap
End Property

Public Function NewBitmap(ByVal Width As Long, _
                          ByVal Height As Long, _
                          Optional ByVal Format As ePixelFormat = Format32bppARGB) As cBitmap
                          
  m_Bitmap.FromSizeFormat Width, Height, Format
  Set NewBitmap = Me
End Function

Public Sub SaveFile(ByVal fileName As String, _
                    ByVal Format As eImageFormat)

    Dim clsSaveP  As GpGDIPlus.cImageSaveParameters
    Dim clsC      As GpGDIPlus.cBitmap
    
    Set clsSaveP = New cImageSaveParameters
    
    clsSaveP.ImageSaveFormat = Format
    clsSaveP.JPEGQuality = 90
    m_Bitmap.Image.SaveImageToFile fileName, clsSaveP
    
    Set clsSaveP = Nothing
End Sub

Public Sub SaveStream(ByVal stream As cStream, _
                      ByVal Format As eImageFormat)

    Dim clsSaveP  As GpGDIPlus.cImageSaveParameters
    Dim clsC      As GpGDIPlus.cBitmap
    
    Set clsSaveP = New cImageSaveParameters
    
    clsSaveP.ImageSaveFormat = Format
    clsSaveP.JPEGQuality = 90
    
    ' TODO: save to stream
    '
    'm_Bitmap.Image.SaveImageToFile app.Path & "\chart.jpg", clsSaveP
    
    Set clsSaveP = Nothing
End Sub

Public Sub Dispose()
  m_Bitmap.DisposeBitmap
End Sub

Private Sub Class_Initialize()
  Set m_Bitmap = New GpGDIPlus.cBitmap
End Sub

Private Sub Class_Terminate()
  Dispose
  Set m_Bitmap = Nothing
End Sub
