VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportImage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportImage
' 30-06-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
' estructuras
' variables privadas
Private m_Aspect                        As cReportAspect
Private m_hImage                        As Long
' eventos
' propiedades publicas
Public Property Get Aspect() As cReportAspect
  Set Aspect = m_Aspect
End Property

Public Property Set Aspect(ByRef rhs As cReportAspect)
  Set m_Aspect = rhs
End Property

Public Property Get hImage() As Long
   hImage = m_hImage
End Property

Public Property Let hImage(ByVal rhs As Long)
   m_hImage = rhs
End Property
' propiedades privadas
' funciones publicas
' funciones friend
Friend Function Load(ByRef xDoc As CSXml2.cXml, ByRef NodObj As Object) As Boolean
  Dim xProperty As CSXml2.cXmlProperty
  
  Set NodObj = xDoc.GetNodeFromNode(NodObj, "Image")
  
  Dim vBytes() As Byte
  
  vBytes = xDoc.GetBinaryNodeProperty(NodObj, "Data").BinaryValue
  If UBound(vBytes) > 0 Then
    DeSerialiseBitmap m_hImage, vBytes()
  End If
  
  ReDim vBytes(0)
  
  If Not m_Aspect.Load(xDoc, NodObj) Then Exit Function
  
  Load = True
End Function

#If Not PREPROC_SFS Then
  Friend Function Save(ByRef xDoc As CSXml2.cXml, ByRef NodeFather As Object) As Boolean
    Dim xProperty As CSXml2.cXmlProperty
    Dim NodObj As Object
    Dim NodImage As Object
    
    Set xProperty = New CSXml2.cXmlProperty
    
    xProperty.Name = "Image"
    Set NodObj = xDoc.AddNodeToNode(NodeFather, xProperty)
    
    Dim vBytes() As Byte
    If hImage <> 0 Then
      SerialiseBitmap hImage, vBytes()
    Else
      ReDim vBytes(0)
    End If
    xProperty.Name = "Data"
    xProperty.BinaryValue = vBytes
    
    xDoc.AddBinaryPropertyToNode NodObj, xProperty
    ReDim vBytes(0)
    
    If Not m_Aspect.Save(xDoc, NodObj) Then Exit Function
    
    Save = True
  End Function
#End If

' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  Set m_Aspect = New cReportAspect
End Sub

Private Sub Class_Terminate()
  Set m_Aspect = Nothing
  If m_hImage <> 0 Then DeleteObject m_hImage
End Sub
