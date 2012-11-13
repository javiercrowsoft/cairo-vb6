VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPropertyItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

' ==================================================================================
' cPropertyItem.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from Microsoft Platform SDK February 2003
'
' The PropertyItem class is a helper class for the Image and Bitmap classes.
' A PropertyItem object holds one piece of image metadata.
' ==================================================================================

Private m_udtID        As Image_Property_ID_Tags
Private m_lngLength    As Long
Private m_udtItemType  As Image_Property_Types
Private m_byData()     As Byte

Friend Sub fInitialize(ByVal propId As Long, _
                       ByVal Length As Long, _
                       ByVal ImageType As Long, _
                       ByVal lPtr As Long, _
                       ByVal lSize As Long)
    Dim lngSize        As Long
    m_udtID = propId
    m_lngLength = Length
    m_udtItemType = ImageType
    If Not (lPtr = 0) And (Length > 0) Then
       lngSize = lSize - 16
       If (lngSize > 0) Then
          ReDim m_byData(0 To lngSize - 1) As Byte
          CopyMemory m_byData(0), ByVal lPtr, lngSize
       End If
    End If
End Sub

Public Sub GetData(ByRef byData() As Byte)
    Dim lngI As Long
    
    If (m_lngLength > 0) Then
       For lngI = LBound(byData) To UBound(byData)
           byData(lngI) = m_byData(lngI - LBound(byData))
       Next lngI
    End If
End Sub

' Integer that identifies the kind of metadata stored in this PropertyItem object
Public Property Get ID() As Image_Property_ID_Tags
    ID = m_udtID
End Property

' Integer that identifies the data type of the values in the value array.
Public Property Get ImageType() As Image_Property_Types
    ImageType = m_udtItemType
End Property

' Size, in bytes, of the value array
Public Property Get Length() As Long
    Length = m_lngLength
End Property
