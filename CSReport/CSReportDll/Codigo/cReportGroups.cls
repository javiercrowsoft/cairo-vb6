VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportGroups"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportGroups
' 30-06-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' Clase base
' constantes
' estructuras
' variables privadas
Private m_Coll As Collection
Private m_GroupsHeaders As cReportSections
Private m_GroupsFooters As cReportSections
' propiedades publicas
' propiedades friend
Friend Property Get GroupsHeaders() As cReportSections
  Set GroupsHeaders = m_GroupsHeaders
End Property

Friend Property Set GroupsHeaders(ByRef rhs As cReportSections)
  Set m_GroupsHeaders = rhs
End Property

Friend Property Get GroupsFooters() As cReportSections
  Set GroupsFooters = m_GroupsFooters
End Property

Friend Property Set GroupsFooters(ByRef rhs As cReportSections)
  Set m_GroupsFooters = rhs
End Property
' propiedades privadas
' funciones publicas
Public Function Add(Optional ByVal c As cReportGroup = Nothing, Optional ByRef Key As Variant) As cReportGroup
  On Error GoTo ControlError
  
  If c Is Nothing Then Set c = New cReportGroup

  If IsMissing(Key) Then
    Key = GetNextKey()
  Else
    RefreshNextKey (Key)
  End If

  Key = GetKey(Key)
  
  m_Coll.Add c, Key
  
  c.Key = Key
  c.Indice = m_Coll.Count()
  
  Set c.Header = m_GroupsHeaders.Add()
  Set c.Footer = m_GroupsFooters.Add(, , 1)
  
  ' Esto es por que me canse de ver los
  ' nombres de las secciones mal formateados
  '
  pSetName c, "G_" & c.Indice
  pSetName c.Header, c.Name
  pSetName c.Footer, c.Name
  
  c.Header.TypeSection = csRptTypeSection.csRptTpGroupHeader
  c.Footer.TypeSection = csRptTypeSection.csRptTpGroupFooter
  
  Set Add = c
  Exit Function
ControlError:
  Set Add = Nothing
End Function

Public Function Add2(Optional ByVal c As cReportGroup = Nothing, Optional ByRef Key As Variant) As cReportGroup
  On Error GoTo ControlError
  
  If c Is Nothing Then Set c = New cReportGroup

  If IsMissing(Key) Then
    Key = GetNextKey()
  Else
    RefreshNextKey (Key)
  End If

  Key = GetKey(Key)
  
  m_Coll.Add c, Key
  
  c.Key = Key
  c.Indice = m_Coll.Count()
  
  m_GroupsHeaders.Add c.Header
  m_GroupsFooters.Add c.Footer, , 1
  
  ' Esto es por que me canse de ver los
  ' nombres de las secciones mal formateados
  '
  pSetName c, "G_" & c.Indice
  pSetName c.Header, c.Name
  pSetName c.Footer, c.Name
  
  c.Header.TypeSection = csRptTypeSection.csRptTpGroupHeader
  c.Footer.TypeSection = csRptTypeSection.csRptTpGroupFooter
  
  Set Add2 = c
  Exit Function
ControlError:
  Set Add2 = Nothing
End Function

Private Sub pSetName(ByRef c As Object, ByVal Name As String)
  If Left$(LCase$(c.Name), 5) = "group" _
  Or Left$(LCase$(c.Name), 5) = "grupo" _
  Or Left$(LCase$(c.Name), 3) = "gh_" _
  Or Left$(LCase$(c.Name), 3) = "gf_" _
  Or Left$(LCase$(c.Name), 2) = "g_" _
  Or LenB(c.Name) = 0 Then
    c.Name = Name
  End If

End Sub

Public Sub Clear()
  CollClear m_Coll
  m_GroupsHeaders.Clear
  m_GroupsFooters.Clear
End Sub

Public Sub Remove(ByVal kItem As Variant)
  On Error GoTo ControlError
  
  Dim KeyH As String
  Dim KeyF As String
  
  KeyH = m_GroupsHeaders.Item(Item(kItem).Header.Key).Key
  KeyF = m_GroupsFooters.Item(Item(kItem).Footer.Key).Key
  
  m_GroupsHeaders.Remove KeyH
  m_GroupsFooters.Remove KeyF
  
  m_Coll.Remove kItem
  
  ' Actualizo el indice
  Dim i As Integer
  For i = 1 To m_Coll.Count()
     m_Coll.Item(i).Indice = i
  Next
  
  Exit Sub
ControlError:
End Sub

Public Function Count() As Long
  On Error GoTo ControlError
  Count = m_Coll.Count()
  Exit Function
ControlError:
  Count = 0
End Function

Public Function Item(ByVal kItem As Variant) As cReportGroup
Attribute Item.VB_UserMemId = 0
  On Error GoTo ControlError
  Set Item = m_Coll.Item(kItem)
  Exit Function
ControlError:
End Function

' funciones privadas
Private Sub Class_Initialize()
  Set m_Coll = New Collection
  Set m_GroupsHeaders = New cReportSections
  Set m_GroupsFooters = New cReportSections
End Sub

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
  Set NewEnum = m_Coll.[_NewEnum]
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  CollClear m_Coll
  Set m_Coll = Nothing
  Set m_GroupsHeaders = Nothing
  Set m_GroupsFooters = Nothing
End Sub
