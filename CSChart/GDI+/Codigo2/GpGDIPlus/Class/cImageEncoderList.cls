VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cImageEncoderList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

' ==================================================================================
' cImageEncoderList.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
' Thanks Avery P
' from Microsoft Platform SDK February 2003
' ==================================================================================

Private m_lngCount            As Long
Private m_blnOk               As Boolean
Private m_udtImageCodecInfo() As ImageCodecInfo

Public Property Get count() As Long
    count = m_lngCount
End Property

Public Function GetEncoderClsidFromExtension(ByVal Extension As String, ByRef ClassID As Clsid) As Boolean
    Dim i As Long
    Dim blnOk As Boolean
    
    blnOk = False
    If Not m_blnOk Then Exit Function
    ' Loop through all the codecs
    For i = 1 To m_lngCount
        ' Must convert the pointer into a usable string
        If (InStr(PtrToStrW(m_udtImageCodecInfo(i).FilenameExtension), Extension) > 0) Then
           LSet ClassID = m_udtImageCodecInfo(i).ClassID   ' Save the class id
           blnOk = True
           Exit For
        End If
    Next i
    GetEncoderClsidFromExtension = blnOk
End Function

Public Function GetEncoderClsidFromMimeType(ByVal MimeType As String, ByRef ClassID As Clsid) As Boolean
    Dim i As Long
    Dim blnOk As Boolean
    
    blnOk = False
    If Not m_blnOk Then Exit Function
    ' Loop through all the codecs
    For i = 1 To m_lngCount
        ' Must convert the pointer into a usable string
        If StrComp(PtrToStrW(m_udtImageCodecInfo(i).MimeType), MimeType, vbTextCompare) = 0 Then
           LSet ClassID = m_udtImageCodecInfo(i).ClassID   ' Save the class id
           blnOk = True
           Exit For
        End If
    Next i
    GetEncoderClsidFromMimeType = blnOk
End Function

Public Property Get Init() As Boolean
    Init = m_blnOk
End Property

Public Property Get Item(ByVal Index As Long) As cImageCodecInfo
    Dim clsItem As cImageCodecInfo
    
    If Index <= 0 Or Index > m_lngCount Or m_blnOk = False Then
       Err.Raise 380, App.EXEName & ".cImageEncoderList"
    End If
    Set clsItem = New cImageCodecInfo
    clsItem.fInit m_udtImageCodecInfo(Index)
    Set Item = clsItem
End Property

Private Sub Class_Initialize()
   Dim size As Long
   Dim buffer() As Byte
   
   m_blnOk = False

   ' Get the encoder array size
   If GdipGetImageEncodersSize(m_lngCount, size) <> Ok Then Exit Sub

   ' Allocate room for the arrays dynamically
   ReDim m_udtImageCodecInfo(1 To m_lngCount) As ImageCodecInfo
   ReDim buffer(1 To size) As Byte

   ' Get the array and string data
   If GdipGetImageEncoders(m_lngCount, size, buffer(1)) <> Ok Then Erase buffer: Exit Sub
   ' Copy the class headers
   Call CopyMemory(m_udtImageCodecInfo(1), buffer(1), (Len(m_udtImageCodecInfo(1)) * m_lngCount))

   ' Free the memory
   Erase buffer
   m_blnOk = True
End Sub

Private Sub Class_Terminate()
    Erase m_udtImageCodecInfo
End Sub
