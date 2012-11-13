VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportPage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportPage
' 05-11-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "cReportPage"

Private Const c_NodeRptHeader As String = "Header"
Private Const c_NodeRptHeaderLine As String = "HeaderLine"
Private Const c_NodeRptDetail As String = "Detail"
Private Const c_NodeRptDetailLine As String = "DetailLine"
Private Const c_NodeRptFooter As String = "Footer"
Private Const c_NodeRptFooterLine As String = "FooterLine"
' estructuras
' variables privadas
Private m_Detail As cReportPageFields
Private m_Header As cReportPageFields
Private m_Footer As cReportPageFields
Private m_PageNumber As Integer

Private m_HeaderBottom As Single
Private m_FooterTop As Single

' eventos
' propiedades publicas
Public Property Get Header() As cReportPageFields
  Set Header = m_Header
End Property

Public Property Set Header(ByRef rhs As cReportPageFields)
  Set m_Header = rhs
End Property

Public Property Get Detail() As cReportPageFields
   Set Detail = m_Detail
End Property

Public Property Set Detail(ByRef rhs As cReportPageFields)
  Set m_Detail = rhs
End Property

Public Property Get Footer() As cReportPageFields
  Set Footer = m_Footer
End Property

Public Property Set Footer(ByRef rhs As cReportPageFields)
  Set m_Footer = rhs
End Property

Public Property Get PageNumber() As Integer
  PageNumber = m_PageNumber
End Property

Public Property Let PageNumber(ByVal rhs As Integer)
  m_PageNumber = rhs
End Property

Public Property Get HeaderBottom() As Single
  HeaderBottom = m_HeaderBottom
End Property

Public Property Let HeaderBottom(ByVal rhs As Single)
  m_HeaderBottom = rhs
End Property

Public Property Get FooterTop() As Single
  FooterTop = m_FooterTop
End Property

Public Property Let FooterTop(ByVal rhs As Single)
  m_FooterTop = rhs
End Property

' propiedades privadas
' funciones publicas
' funciones friend
Friend Function Load(ByRef xDoc As CSXml2.cXml, ByRef NodObj As Object) As Boolean
  Dim NodObjSecLn As Object

  On Error Resume Next

  m_PageNumber = xDoc.GetNodeProperty(NodObj, "PageNumber").Value(csInteger)
  m_HeaderBottom = xDoc.GetNodeProperty(NodObj, "HeaderBottom").Value(csLong)
  m_FooterTop = xDoc.GetNodeProperty(NodObj, "FooterTop").Value(csLong)

  m_Header.Clear
  m_Detail.Clear
  m_Footer.Clear

  Set NodObj = xDoc.GetNodeFromNode(NodObj, c_NodeRptHeader)
  If xDoc.NodeHasChild(NodObj) Then
    Set NodObjSecLn = xDoc.GetNodeChild(NodObj)
    While Not NodObjSecLn Is Nothing
      If Not m_Header.Add().Load(xDoc, NodObjSecLn) Then Exit Function
      Set NodObjSecLn = xDoc.GetNextNode(NodObjSecLn)
    Wend
  End If

  Set NodObj = xDoc.GetNodeFromNode(NodObj, c_NodeRptDetail)
  If xDoc.NodeHasChild(NodObj) Then
    Set NodObjSecLn = xDoc.GetNodeChild(NodObj)
    While Not NodObjSecLn Is Nothing
      If Not m_Detail.Add().Load(xDoc, NodObjSecLn) Then Exit Function
      Set NodObjSecLn = xDoc.GetNextNode(NodObjSecLn)
    Wend
  End If

  Set NodObj = xDoc.GetNodeFromNode(NodObj, c_NodeRptFooter)
  If xDoc.NodeHasChild(NodObj) Then
    Set NodObjSecLn = xDoc.GetNodeChild(NodObj)
    While Not NodObjSecLn Is Nothing
      If Not m_Footer.Add().Load(xDoc, NodObjSecLn) Then Exit Function
      Set NodObjSecLn = xDoc.GetNextNode(NodObjSecLn)
    Wend
  End If

  Load = True
End Function

#If Not PREPROC_SFS Then
  Friend Function Save(ByRef xDoc As CSXml2.cXml, ByRef NodeFather As Object) As Boolean
    Dim xProperty As CSXml2.cXmlProperty
    Dim NodObj As Object
  
    Set xProperty = New CSXml2.cXmlProperty
  
    xProperty.Name = "Page"
    Set NodObj = xDoc.AddNodeToNode(NodeFather, xProperty)
  
    xDoc.SetNodeText NodObj, "Página " & m_PageNumber
  
    xProperty.Name = "PageNumber"
    xProperty.Value(csInteger) = m_PageNumber
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "HeaderBottom"
    xProperty.Value(csLong) = m_HeaderBottom
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "FooterTop"
    xProperty.Value(csLong) = m_FooterTop
    xDoc.AddPropertyToNode NodObj, xProperty
  
    Dim PageFld As cReportPageField
    Dim NodAux As Object
  
    xProperty.Name = c_NodeRptHeader
    xProperty.Value(csText) = vbNullString
    NodAux = xDoc.AddNodeToNode(NodObj, xProperty)
  
    For Each PageFld In m_Header
      PageFld.Save xDoc, NodAux
    Next
  
    xProperty.Name = c_NodeRptDetail
    xProperty.Value(csText) = vbNullString
    NodAux = xDoc.AddNodeToNode(NodObj, xProperty)
  
    For Each PageFld In m_Detail
      PageFld.Save xDoc, NodAux
    Next
  
    xProperty.Name = c_NodeRptFooter
    xProperty.Value(csText) = vbNullString
    NodAux = xDoc.AddNodeToNode(NodObj, xProperty)
  
    For Each PageFld In m_Footer
      PageFld.Save xDoc, NodAux
    Next
  
    Save = True
  End Function
#End If

#If Not PREPROC_SFS Then
  Friend Function SaveForWeb(ByRef xDoc As CSXml2.cXml, ByRef NodeFather As Object) As Boolean
    Dim xProperty As CSXml2.cXmlProperty
    Dim NodObj As Object
  
    Set xProperty = New CSXml2.cXmlProperty
  
    xProperty.Name = "Page"
    Set NodObj = xDoc.AddNodeToNode(NodeFather, xProperty)
  
    xDoc.SetNodeText NodObj, "Página " & m_PageNumber
  
    Dim PageFld As cReportPageField
    Dim NodAux As Object
    Dim Top As Long
    Dim AddLine As Boolean
  
    Dim nHeader As Long
  
    xProperty.Name = c_NodeRptHeader
    xProperty.Value(csText) = vbNullString
    NodAux = xDoc.AddNodeToNode(NodObj, xProperty)
  
    For Each PageFld In m_Header
      AddLine = False
  
      If PageFld.Top = 0 Then
        If Top <> PageFld.Info.Aspect.Top Then
          Top = PageFld.Info.Aspect.Top
          AddLine = True
          nHeader = nHeader + 1
        End If
      Else
        If Top <> PageFld.Top Then
          Top = PageFld.Top
          AddLine = True
          nHeader = nHeader + 1
        End If
      End If
  
      If AddLine Then
        xProperty.Name = c_NodeRptHeaderLine & nHeader
        xProperty.Value(csText) = vbNullString
        NodAux = xDoc.AddNodeToNode(NodObj, xProperty)
      End If
  
      PageFld.SaveForWeb xDoc, NodAux
    Next
  
    xProperty.Name = c_NodeRptDetail
    xProperty.Value(csText) = vbNullString
    NodAux = xDoc.AddNodeToNode(NodObj, xProperty)
  
    For Each PageFld In m_Detail
  
      AddLine = False
  
      If PageFld.Top = 0 Then
        If Top <> PageFld.Info.Aspect.Top Then
          Top = PageFld.Info.Aspect.Top
          AddLine = True
        End If
      Else
        If Top <> PageFld.Top Then
          Top = PageFld.Top
          AddLine = True
        End If
      End If
  
      If AddLine Then
        xProperty.Name = c_NodeRptDetailLine
        xProperty.Value(csText) = vbNullString
        NodAux = xDoc.AddNodeToNode(NodObj, xProperty)
      End If
  
      PageFld.SaveForWeb xDoc, NodAux
    Next
  
    xProperty.Name = c_NodeRptFooter
    xProperty.Value(csText) = vbNullString
    NodAux = xDoc.AddNodeToNode(NodObj, xProperty)
  
    For Each PageFld In m_Footer
      AddLine = False
  
      If PageFld.Top = 0 Then
        If Top <> PageFld.Info.Aspect.Top Then
          Top = PageFld.Info.Aspect.Top
          AddLine = True
        End If
      Else
        If Top <> PageFld.Top Then
          Top = PageFld.Top
          AddLine = True
        End If
      End If
  
      If AddLine Then
        xProperty.Name = c_NodeRptFooterLine
        xProperty.Value(csText) = vbNullString
        NodAux = xDoc.AddNodeToNode(NodObj, xProperty)
      End If
  
      PageFld.SaveForWeb xDoc, NodAux
    Next
  
    SaveForWeb = True
  End Function
#End If

' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  Set m_Header = New cReportPageFields
  Set m_Detail = New cReportPageFields
  Set m_Footer = New cReportPageFields
End Sub

Private Sub Class_Terminate()
  Set m_Header = Nothing
  Set m_Detail = Nothing
  Set m_Footer = Nothing
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

