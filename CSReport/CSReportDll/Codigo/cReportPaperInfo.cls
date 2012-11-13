VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportPaperInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportPaperInfo
' 15-09-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "cReportPaperInfo"
' estructuras
' variables privadas
Private m_Width                         As Single
Private m_Height                        As Single
Private m_PaperSize                     As csReportPaperType
Private m_Orientation                   As Long
Private m_CustomHeight                  As Long
Private m_CustomWidth                   As Long
Private m_PagesToPrint                  As String
Private m_PaperBin                      As Long

' eventos
' propiedades publicas
Public Property Get Width() As Single
  Width = m_Width
End Property

Public Property Let Width(ByVal rhs As Single)
  m_Width = rhs
End Property

Public Property Get Height() As Single
  Height = m_Height
End Property

Public Property Let Height(ByVal rhs As Single)
  m_Height = rhs
End Property

Public Property Get PaperSize() As csReportPaperType
  PaperSize = m_PaperSize
End Property

Public Property Let PaperSize(ByRef rhs As csReportPaperType)
  m_PaperSize = rhs
End Property

Public Property Get Orientation() As Long
   Orientation = m_Orientation
End Property

Public Property Let Orientation(ByVal rhs As Long)
   m_Orientation = rhs
End Property

Public Property Get CustomHeight() As Long
   CustomHeight = m_CustomHeight
End Property

Public Property Let CustomHeight(ByVal rhs As Long)
   m_CustomHeight = rhs
End Property

Public Property Get CustomWidth() As Long
   CustomWidth = m_CustomWidth
End Property

Public Property Let CustomWidth(ByVal rhs As Long)
   m_CustomWidth = rhs
End Property

Public Property Get PaperBin() As Long
   PaperBin = m_PaperBin
End Property

Public Property Let PaperBin(ByVal rhs As Long)
   m_PaperBin = rhs
End Property

Public Property Get PagesToPrint() As String
   PagesToPrint = m_PagesToPrint
End Property

Public Property Let PagesToPrint(ByVal rhs As String)
   m_PagesToPrint = rhs
End Property

' propiedades privadas
' funciones publicas
' funciones privadas
' funciones friend
' funciones friend
Friend Function Load(ByRef xDoc As CSXml2.cXml, ByRef NodObj As Object) As Boolean
  On Error Resume Next

  If Not NodObj Is Nothing Then
    m_Height = xDoc.GetNodeProperty(NodObj, "Height").Value(csLong)
    m_PaperSize = xDoc.GetNodeProperty(NodObj, "PaperSize").Value(csInteger)
    m_Width = xDoc.GetNodeProperty(NodObj, "Width").Value(csLong)
    m_Orientation = xDoc.GetNodeProperty(NodObj, "Orientation").Value(csInteger)
    m_CustomWidth = xDoc.GetNodeProperty(NodObj, "CustomWidth").Value(csLong)
    m_CustomHeight = xDoc.GetNodeProperty(NodObj, "CustomHeight").Value(csLong)
  End If
  
  Load = True
End Function

#If Not PREPROC_SFS Then
  Friend Function Save(ByRef xDoc As CSXml2.cXml, ByRef NodeFather As Object) As Boolean
    Dim xProperty As CSXml2.cXmlProperty
    Dim NodObj As Object
    
    Set xProperty = New CSXml2.cXmlProperty
    
    Set NodObj = NodeFather
    
    xProperty.Name = "Height"
    xProperty.Value(csLong) = m_Height
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "PaperSize"
    xProperty.Value(csInteger) = m_PaperSize
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "Width"
    xProperty.Value(csLong) = m_Width
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "Orientation"
    xProperty.Value(csInteger) = m_Orientation
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "CustomWidth"
    xProperty.Value(csLong) = m_CustomWidth
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "CustomHeight"
    xProperty.Value(csLong) = m_CustomHeight
    xDoc.AddPropertyToNode NodObj, xProperty
    
    Save = True
  End Function
#End If

' construccion - destruccion

