VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportAspect"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportAspect
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
Private m_Left          As Single
Private m_Top           As Single
Private m_Height        As Single
Private m_Width         As Single
Private m_BackColor     As Long
Private m_BorderWidth   As Single
Private m_BorderType    As csReportBorderType
Private m_BorderColor   As Long
Private m_BorderColor3d As Long
Private m_BorderColor3dShadow As Long
Private m_SelectColor   As Long
Private m_Font          As cReportFont
Private m_CanGrow       As Boolean
Private m_nZOrder       As Integer
Private m_Align         As AlignmentConstants
Private m_Transparent   As Boolean
Private m_Format        As String
Private m_Symbol        As String
Private m_IsAccounting  As Boolean
Private m_WordWrap      As Boolean
Private m_BorderRounded As Boolean

' eventos
' propiedades publicas
Public Property Get Left() As Single
  Left = m_Left
End Property

Public Property Let Left(ByVal rhs As Single)
  m_Left = rhs
End Property

Public Property Get Top() As Single
  Top = m_Top
End Property

Public Property Let Top(ByVal rhs As Single)
  m_Top = rhs
End Property

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
  If rhs < 20 Then rhs = 20
  m_Height = rhs
End Property

Public Property Get BackColor() As Long
  BackColor = m_BackColor
End Property

Public Property Let BackColor(ByVal rhs As Long)
  m_BackColor = rhs
End Property

Public Property Get BorderWidth() As Single
  BorderWidth = m_BorderWidth
End Property

Public Property Let BorderWidth(ByVal rhs As Single)
  m_BorderWidth = rhs
End Property

Public Property Get BorderType() As csReportBorderType
  BorderType = m_BorderType
End Property

Public Property Let BorderType(ByVal rhs As csReportBorderType)
  m_BorderType = rhs
End Property

Public Property Get BorderColor() As Long
  BorderColor = m_BorderColor
End Property

Public Property Let BorderColor(ByVal rhs As Long)
  m_BorderColor = rhs
End Property

Public Property Get BorderColor3d() As Long
  BorderColor3d = m_BorderColor3d
End Property

Public Property Let BorderColor3d(ByVal rhs As Long)
  m_BorderColor3d = rhs
End Property

Public Property Get BorderColor3dShadow() As Long
  BorderColor3dShadow = m_BorderColor3dShadow
End Property

Public Property Let BorderColor3dShadow(ByVal rhs As Long)
  m_BorderColor3dShadow = rhs
End Property

Public Property Get SelectColor() As Long
  SelectColor = m_SelectColor
End Property

Public Property Let SelectColor(ByVal rhs As Long)
  m_SelectColor = rhs
End Property

Public Property Get Font() As cReportFont
  Set Font = m_Font
End Property

Public Property Let Font(ByVal rhs As cReportFont)
  m_Font = rhs
End Property

Public Property Get CanGrow() As Boolean
  CanGrow = m_CanGrow
End Property

Public Property Let CanGrow(ByVal rhs As Boolean)
  m_CanGrow = rhs
End Property

Public Property Get nZOrder() As Integer
  nZOrder = m_nZOrder
End Property

Public Property Let nZOrder(ByVal rhs As Integer)
  m_nZOrder = rhs
End Property

Public Property Get Align() As AlignmentConstants
  Align = m_Align
End Property

Public Property Let Align(ByVal rhs As AlignmentConstants)
  m_Align = rhs
End Property

Public Property Get Transparent() As Boolean
  Transparent = m_Transparent
End Property

Public Property Let Transparent(ByVal rhs As Boolean)
  m_Transparent = rhs
End Property

Public Property Get Format() As String
  Format = m_Format
End Property

Public Property Let Format(ByVal rhs As String)
  m_Format = rhs
End Property

Public Property Get Symbol() As String
  Symbol = m_Symbol
End Property

Public Property Let Symbol(ByVal rhs As String)
  m_Symbol = rhs
End Property

Public Property Get IsAccounting() As Boolean
  IsAccounting = m_IsAccounting
End Property

Public Property Let IsAccounting(ByVal rhs As Boolean)
  m_IsAccounting = rhs
End Property

Public Property Get WordWrap() As Boolean
   WordWrap = m_WordWrap
End Property

Public Property Let WordWrap(ByVal rhs As Boolean)
   m_WordWrap = rhs
End Property

Public Property Get BorderRounded() As Boolean
   BorderRounded = m_BorderRounded
End Property

Public Property Let BorderRounded(ByVal rhs As Boolean)
   m_BorderRounded = rhs
End Property

' propiedades privadas
' funciones friend
#If CSReport Then
Friend Function Load(ByRef xDoc As CSXml2.cXml, ByRef NodObj As Object) As Boolean
  Set NodObj = xDoc.GetNodeFromNode(NodObj, "Aspect")

  ' Si le falta alguna propiedad no hay problema
  On Error Resume Next

  m_Align = xDoc.GetNodeProperty(NodObj, "Align").Value(csInteger)
  m_BackColor = xDoc.GetNodeProperty(NodObj, "BackColor").Value(csLong)
  m_BorderColor = xDoc.GetNodeProperty(NodObj, "BorderColor").Value(csLong)
  m_BorderColor3d = xDoc.GetNodeProperty(NodObj, "BorderColor3D").Value(csLong)
  m_BorderColor3dShadow = xDoc.GetNodeProperty(NodObj, "BorderColor3DShadow").Value(csLong)
  m_BorderType = xDoc.GetNodeProperty(NodObj, "BorderType").Value(csInteger)
  m_BorderWidth = xDoc.GetNodeProperty(NodObj, "BorderWidth").Value(csLong)
  m_Height = xDoc.GetNodeProperty(NodObj, "Height").Value(csLong)
  m_CanGrow = xDoc.GetNodeProperty(NodObj, "CanGrow").Value(csInteger)
  m_Left = xDoc.GetNodeProperty(NodObj, "Left").Value(csLong)
  m_nZOrder = xDoc.GetNodeProperty(NodObj, "nZOrder").Value(csInteger)
  m_SelectColor = xDoc.GetNodeProperty(NodObj, "SelectColor").Value(csLong)
  m_Top = xDoc.GetNodeProperty(NodObj, "Top").Value(csLong)
  m_Width = xDoc.GetNodeProperty(NodObj, "Width").Value(csLong)
  m_Transparent = xDoc.GetNodeProperty(NodObj, "Transparent").Value(csBoolean)
  m_Format = xDoc.GetNodeProperty(NodObj, "Format").Value(csText)
  m_Symbol = xDoc.GetNodeProperty(NodObj, "Symbol").Value(csText)
  m_IsAccounting = xDoc.GetNodeProperty(NodObj, "IsAccounting").Value(csBoolean)
  m_WordWrap = xDoc.GetNodeProperty(NodObj, "WordWrap").Value(csBoolean)
  m_BorderRounded = xDoc.GetNodeProperty(NodObj, "BorderRounded").Value(csBoolean)

  If Not m_Font.Load(xDoc, NodObj) Then Exit Function

  Load = True
End Function

#If Not PREPROC_SFS Then
  Friend Function Save(ByRef xDoc As CSXml2.cXml, ByRef NodeFather As Object) As Boolean
    Dim xProperty As CSXml2.cXmlProperty
    Dim NodObj As Object
    Set xProperty = New CSXml2.cXmlProperty
  
    xProperty.Name = "Aspect"
    Set NodObj = xDoc.AddNodeToNode(NodeFather, xProperty)
  
    xProperty.Name = "Align"
    xProperty.Value(csInteger) = m_Align
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "BackColor"
    xProperty.Value(csLong) = m_BackColor
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "BorderColor"
    xProperty.Value(csLong) = m_BorderColor
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "BorderColor3D"
    xProperty.Value(csLong) = m_BorderColor3d
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "BorderColor3DShadow"
    xProperty.Value(csLong) = m_BorderColor3dShadow
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "BorderType"
    xProperty.Value(csInteger) = m_BorderType
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "BorderWidth"
    xProperty.Value(csLong) = m_BorderWidth
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "CanGrow"
    xProperty.Value(csBoolean) = m_CanGrow
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "Height"
    xProperty.Value(csLong) = m_Height
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "Format"
    xProperty.Value(csText) = m_Format
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "Left"
    xProperty.Value(csLong) = m_Left
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "nZOrder"
    xProperty.Value(csInteger) = m_nZOrder
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "SelectColor"
    xProperty.Value(csLong) = m_SelectColor
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "Top"
    xProperty.Value(csLong) = m_Top
  
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "Width"
    xProperty.Value(csLong) = m_Width
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "Transparent"
    xProperty.Value(csBoolean) = m_Transparent
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "Symbol"
    xProperty.Value(csText) = m_Symbol
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "IsAccounting"
    xProperty.Value(csBoolean) = m_IsAccounting
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "WordWrap"
    xProperty.Value(csBoolean) = m_WordWrap
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "BorderRounded"
    xProperty.Value(csBoolean) = m_BorderRounded
    xDoc.AddPropertyToNode NodObj, xProperty
  
    If Not m_Font.Save(xDoc, NodObj) Then Exit Function
  
    Save = True
  End Function
#End If
#End If
' funciones publicas
' funciones privadas
' construccion - destruccion

Private Sub Class_Initialize()
  Set m_Font = New cReportFont
  m_BackColor = vbWhite
  m_BorderColor = vbBlack
  m_Align = AlignmentConstants.vbLeftJustify
End Sub

Private Sub Class_Terminate()
  Set m_Font = Nothing
End Sub



