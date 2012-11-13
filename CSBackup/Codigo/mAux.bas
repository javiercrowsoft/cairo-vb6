Attribute VB_Name = "mAux"
Option Explicit

Public Enum csSQLSecurityType
  csTSNT = 1
  csTSSQL = 2
End Enum

Public Const csSchEndUndefined = #12/31/9999#

Public Function CharacterValidForDate(ByVal KeyAscii As Integer) As Integer
  Select Case KeyAscii
    Case vbKey0, vbKey1, vbKey2, vbKey3, vbKey4, vbKey5, vbKey6, vbKey7, vbKey8, vbKey9, vbKeyBack
      CharacterValidForDate = KeyAscii
    Case vbKeyDivide, vbKeyDecimal, vbKeySubtract, 47, 46, 45
      CharacterValidForDate = 47 ' 47 = /
    Case Else
      CharacterValidForDate = 0
  End Select
End Function

Public Function CharacterValidForInteger(ByVal KeyAscii As Integer) As Integer
  Select Case KeyAscii
    Case vbKey0, vbKey1, vbKey2, vbKey3, vbKey4, vbKey5, vbKey6, vbKey7, vbKey8, vbKey9, vbKeyBack
      CharacterValidForInteger = KeyAscii
    Case Else
      CharacterValidForInteger = 0
  End Select
End Function

Public Function CharacterValidForTime(ByVal KeyAscii As Integer) As Integer
  Select Case KeyAscii
    Case vbKey0, vbKey1, vbKey2, vbKey3, vbKey4, vbKey5, vbKey6, vbKey7, vbKey8, vbKey9, vbKeyBack
      CharacterValidForTime = KeyAscii
    Case 46, 45, 58
      CharacterValidForTime = 58 ' 58 = :
    Case Else
      CharacterValidForTime = 0
  End Select
End Function

Public Function CheckValueTime(ByVal Time As String) As String
  If Not IsNumeric(Time) And Not IsDate(Time) Then Exit Function
  If InStr(1, Time, ":") = 0 Then
    Time = Time & ":00"
  End If
  CheckValueTime = Time
End Function

Public Function FormatDate(ByVal varDate As Variant) As String
  FormatDate = Format(varDate, "dd/mm/yyyy")
End Function

Public Function FormatTime(ByVal varDate As Variant, Optional ByVal withSeconds As Boolean) As String
  If IsMissing(withSeconds) Then
    FormatTime = Format(varDate, "hh:nn")
  ElseIf withSeconds Then
    FormatTime = Format(varDate, "hh:nn:ss")
  Else
    FormatTime = Format(varDate, "hh:nn")
  End If
End Function

Public Function GetItemData(ByRef cbList As Object) As Long
  If cbList.ListIndex = -1 Then Exit Function
  GetItemData = cbList.ItemData(cbList.ListIndex)
End Function

Public Function SelectItemByItemData(ByRef cbList As Object, ByVal ItemData As Integer) As Integer
  Dim i As Integer
  
  SelectItemByItemData = -1
  
  For i = 0 To cbList.ListCount - 1
    If cbList.ItemData(i) = ItemData Then
      cbList.ListIndex = i
      SelectItemByItemData = i
      Exit For
    End If
  Next
End Function

Public Function SelectItemByText(ByRef cbList As Object, ByVal Text As String) As Integer
  Dim i As Integer
  
  SelectItemByText = -1
  
  For i = 0 To cbList.ListCount - 1
    If cbList.List(i) = Text Then
      cbList.ListIndex = i
      SelectItemByText = i
      Exit For
    End If
  Next
End Function

Public Function AddItemToList(ByRef cbList As Object, ByVal Text As String, Optional ByVal ItemData As Variant) As Integer
  cbList.AddItem Text
  If Not IsMissing(ItemData) Then cbList.ItemData(cbList.NewIndex) = ItemData
  AddItemToList = cbList.NewIndex
End Function

Public Sub FormCenter(ByRef f As Form)
  f.Move (Screen.Width - f.Width) * 0.5, (Screen.Height - f.Height) * 0.5
End Sub

Public Sub Info(ByVal msg As String)
  MsgBox msg, vbInformation
End Sub

Public Sub SetFocusControl(ByRef ctl As Object)
  On Error Resume Next
  ctl.SetFocus
  Err.Clear
End Sub

' XML
Public Function pGetChildNodeProperty(ByRef Root As Object, _
                                      ByRef DocXml As cXml, _
                                      ByVal NodeName As String, _
                                      ByVal PropertyName As String, _
                                      Optional ByVal csType As csTypes = csText) As Variant
  Dim Node  As Object
  Dim Prop  As Object

  Set Node = DocXml.GetNodeFromNode(Root, NodeName)
  
  If Not Node Is Nothing Then
    Set Prop = DocXml.GetNodeProperty(Node, PropertyName)
                                     
    If Not Prop Is Nothing Then
      pGetChildNodeProperty = Prop.Value(csType)
      Exit Function
    End If
    
  End If
  
  Dim EmptyDate As Date
  
  Select Case csType
    Case csInteger
      pGetChildNodeProperty = 0
    Case csDouble
      pGetChildNodeProperty = 0
    Case csCurrency
      pGetChildNodeProperty = 0
    Case csText
      pGetChildNodeProperty = vbNullString
    Case csId
      pGetChildNodeProperty = 0
    Case csCuit
      pGetChildNodeProperty = vbNullString
    Case csBoolean
      pGetChildNodeProperty = False
    Case csSingle
      pGetChildNodeProperty = 0
    Case csVariant
      pGetChildNodeProperty = Empty
    Case csLong
      pGetChildNodeProperty = 0
    Case csDate
      pGetChildNodeProperty = EmptyDate
    Case csDateOrNull
      pGetChildNodeProperty = EmptyDate
  End Select
  
End Function

Public Function pAddTag(ByRef xml As cXml, _
                         ByRef NodeFather As Object, _
                         ByVal TagName As String, _
                         ByVal Value As String) As Object
                    
  
  Dim Prop As cXmlProperty
  Dim Node As Object
  
  Set Prop = New cXmlProperty
  
  Prop.Name = TagName
  Set Node = xml.AddNodeToNode(NodeFather, Prop)
  
  Set Prop = New cXmlProperty
  Prop.Name = "Value"
  Prop.Value(csText) = Value
  xml.AddPropertyToNode Node, Prop
  
  Set pAddTag = Node

End Function

Public Function ExistsItemByText(ByRef cbList As Object, ByVal Text As String) As Boolean
  Dim i As Integer
  
  ExistsItemByText = False
  
  For i = 0 To cbList.ListCount - 1
    If cbList.List(i) = Text Then
      ExistsItemByText = True
      Exit For
    End If
  Next
End Function

Public Function DivideByZero(ByVal x As Double, ByVal y As Double) As Double
  If y = 0 Then
    DivideByZero = 0
  Else
    DivideByZero = x / y
  End If
End Function
