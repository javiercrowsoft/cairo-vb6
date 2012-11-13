VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportChartSerie"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cReportChartSerie
' 28-06-2005

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cReportChartSerie"

Public Enum csColors
  AliceBlue = &HFFF0F8FF
  AntiqueWhite = &HFFFAEBD7
  Aqua = &HFF00FFFF
  Aquamarine = &HFF7FFFD4
  Azure = &HFFF0FFFF
  Beige = &HFFF5F5DC
  Bisque = &HFFFFE4C4
  Black = &HFF000000
  BlanchedAlmond = &HFFFFEBCD
  Blue = &HFF0000FF
  BlueViolet = &HFF8A2BE2
  Brown = &HFFA52A2A
  BurlyWood = &HFFDEB887
  CadetBlue = &HFF5F9EA0
  Chartreuse = &HFF7FFF00
  Chocolate = &HFFD2691E
  Coral = &HFFFF7F50
  CornflowerBlue = &HFF6495ED
  Cornsilk = &HFFFFF8DC
  Crimson = &HFFDC143C
  Cyan = &HFF00FFFF
  DarkBlue = &HFF00008B
  DarkCyan = &HFF008B8B
  DarkGoldenrod = &HFFB8860B
  DarkGray = &HFFA9A9A9
  DarkGreen = &HFF006400
  DarkKhaki = &HFFBDB76B
  DarkMagenta = &HFF8B008B
  DarkOliveGreen = &HFF556B2F
  DarkOrange = &HFFFF8C00
  DarkOrchid = &HFF9932CC
  DarkRed = &HFF8B0000
  DarkSalmon = &HFFE9967A
  DarkSeaGreen = &HFF8FBC8B
  DarkSlateBlue = &HFF483D8B
  DarkSlateGray = &HFF2F4F4F
  DarkTurquoise = &HFF00CED1
  DarkViolet = &HFF9400D3
  DeepPink = &HFFFF1493
  DeepSkyBlue = &HFF00BFFF
  DimGray = &HFF696969
  DodgerBlue = &HFF1E90FF
  Firebrick = &HFFB22222
  FloralWhite = &HFFFFFAF0
  ForestGreen = &HFF228B22
  Fuchsia = &HFFFF00FF
  Gainsboro = &HFFDCDCDC
  GhostWhite = &HFFF8F8FF
  Gold = &HFFFFD700
  Goldenrod = &HFFDAA520
  Gray = &HFF808080
  Green = &HFF008000
  GreenYellow = &HFFADFF2F
  Honeydew = &HFFF0FFF0
  HotPink = &HFFFF69B4
  IndianRed = &HFFCD5C5C
  Indigo = &HFF4B0082
  Ivory = &HFFFFFFF0
  Khaki = &HFFF0E68C
  Lavender = &HFFE6E6FA
  LavenderBlush = &HFFFFF0F5
  LawnGreen = &HFF7CFC00
  LemonChiffon = &HFFFFFACD
  LightBlue = &HFFADD8E6
  LightCoral = &HFFF08080
  LightCyan = &HFFE0FFFF
  LightGoldenrodYellow = &HFFFAFAD2
  LightGray = &HFFD3D3D3
  LightGreen = &HFF90EE90
  LightPink = &HFFFFB6C1
  LightSalmon = &HFFFFA07A
  LightSeaGreen = &HFF20B2AA
  LightSkyBlue = &HFF87CEFA
  LightSlateGray = &HFF778899
  LightSteelBlue = &HFFB0C4DE
  LightYellow = &HFFFFFFE0
  Lime = &HFF00FF00
  LimeGreen = &HFF32CD32
  Linen = &HFFFAF0E6
  Magenta = &HFFFF00FF
  Maroon = &HFF800000
  MediumAquamarine = &HFF66CDAA
  MediumBlue = &HFF0000CD
  MediumOrchid = &HFFBA55D3
  MediumPurple = &HFF9370DB
  MediumSeaGreen = &HFF3CB371
  MediumSlateBlue = &HFF7B68EE
  MediumSpringGreen = &HFF00FA9A
  MediumTurquoise = &HFF48D1CC
  MediumVioletRed = &HFFC71585
  MidnightBlue = &HFF191970
  MintCream = &HFFF5FFFA
  MistyRose = &HFFFFE4E1
  Moccasin = &HFFFFE4B5
  NavajoWhite = &HFFFFDEAD
  Navy = &HFF000080
  OldLace = &HFFFDF5E6
  Olive = &HFF808000
  OliveDrab = &HFF6B8E23
  Orange = &HFFFFA500
  OrangeRed = &HFFFF4500
  Orchid = &HFFDA70D6
  PaleGoldenrod = &HFFEEE8AA
  PaleGreen = &HFF98FB98
  PaleTurquoise = &HFFAFEEEE
  PaleVioletRed = &HFFDB7093
  PapayaWhip = &HFFFFEFD5
  PeachPuff = &HFFFFDAB9
  Peru = &HFFCD853F
  Pink = &HFFFFC0CB
  Plum = &HFFDDA0DD
  PowderBlue = &HFFB0E0E6
  Purple = &HFF800080
  Red = &HFFFF0000
  RosyBrown = &HFFBC8F8F
  RoyalBlue = &HFF4169E1
  SaddleBrown = &HFF8B4513
  Salmon = &HFFFA8072
  SandyBrown = &HFFF4A460
  SeaGreen = &HFF2E8B57
  SeaShell = &HFFFFF5EE
  Sienna = &HFFA0522D
  Silver = &HFFC0C0C0
  SkyBlue = &HFF87CEEB
  SlateBlue = &HFF6A5ACD
  SlateGray = &HFF708090
  Snow = &HFFFFFAFA
  SpringGreen = &HFF00FF7F
  SteelBlue = &HFF4682B4
  Tan = &HFFD2B48C
  Teal = &HFF008080
  Thistle = &HFFD8BFD8
  Tomato = &HFFFF6347
  Transparent = &HFFFFFF
  Turquoise = &HFF40E0D0
  Violet = &HFFEE82EE
  Wheat = &HFFF5DEB3
  White = &HFFFFFFFF
  WhiteSmoke = &HFFF5F5F5
  Yellow = &HFFFFFF00
  YellowGreen = &HFF9ACD32
End Enum

' estructuras
' variables privadas
Private m_ValueFieldName                As String
Private m_LabelFieldName                As String
Private m_Color                         As csColors
Private m_ValueIndex                    As Long
Private m_LabelIndex                    As Long
' eventos
' propiedades publicas
Public Property Get ValueFieldName() As String
  ValueFieldName = m_ValueFieldName
End Property

Public Property Let ValueFieldName(ByVal rhs As String)
  m_ValueFieldName = rhs
End Property

Public Property Get LabelFieldName() As String
  LabelFieldName = m_LabelFieldName
End Property

Public Property Let LabelFieldName(ByVal rhs As String)
  m_LabelFieldName = rhs
End Property

Public Property Get Color() As csColors
  Color = m_Color
End Property

Public Property Let Color(ByVal Value As csColors)
  m_Color = Value
End Property

Public Property Get ValueIndex() As Integer
  ValueIndex = m_ValueIndex
End Property

Public Property Let ValueIndex(ByVal rhs As Integer)
  m_ValueIndex = rhs
End Property

Public Property Get LabelIndex() As Integer
  LabelIndex = m_LabelIndex
End Property

Public Property Let LabelIndex(ByVal rhs As Integer)
  m_LabelIndex = rhs
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
#If Not PREPROC_WEB_CHART Then
Friend Function Load(ByRef xDoc As CSXml2.cXml, _
                     ByRef NodObj As Object, _
                     ByVal Index As Long) As Boolean
  
  ' Si le falta alguna propiedad no hay problema
  On Error Resume Next

  m_ValueFieldName = xDoc.GetNodeProperty(NodObj, "ValueFieldName").Value(csText)
  m_LabelFieldName = xDoc.GetNodeProperty(NodObj, "LabelFieldName").Value(csText)
  m_Color = xDoc.GetNodeProperty(NodObj, "Color").Value(csLong)

  Load = True
End Function

#If Not PREPROC_SFS Then
  Friend Function Save(ByRef xDoc As CSXml2.cXml, _
                       ByRef NodeFather As Object, _
                       ByVal Index As Long) As Boolean
                       
    Dim xProperty As CSXml2.cXmlProperty
    Dim NodObj As Object
    Set xProperty = New CSXml2.cXmlProperty
  
    xProperty.Name = "Serie_" & Index
    Set NodObj = xDoc.AddNodeToNode(NodeFather, xProperty)
  
    xProperty.Name = "ValueFieldName"
    xProperty.Value(csText) = m_ValueFieldName
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "LabelFieldName"
    xProperty.Value(csText) = m_LabelFieldName
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "Color"
    xProperty.Value(csLong) = m_Color
    xDoc.AddPropertyToNode NodObj, xProperty
  
    Save = True
  End Function
#End If
#End If

' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  m_Color = AliceBlue
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
