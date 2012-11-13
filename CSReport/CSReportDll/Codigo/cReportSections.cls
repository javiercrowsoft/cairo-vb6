VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportSections"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements cIReportGroupSections 'CSReportDll2.cIReportGroupSections
'--------------------------------------------------------------------------------
' cReportSections
' 30-06-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' interfaces

' Clase base
' constantes
Private Const C_Module = "cReportSections"

' estructuras
' variables privadas
Private m_Coll            As Collection
' Este es un puntero a la coleccion gemela que contiene cReport
Private m_CopyColl        As cReportControls2
Private m_TypeSection     As csRptTypeSection
Private m_MainTypeSection As csRptTypeSection

' propiedades publicas
Public Property Get TypeSection() As csRptTypeSection
  TypeSection = m_TypeSection
End Property

Public Property Let TypeSection(ByRef rhs As csRptTypeSection)
  m_TypeSection = rhs
End Property

' propiedades friend
Friend Property Let MainTypeSection(ByRef rhs As csRptTypeSection)
  m_MainTypeSection = rhs
End Property

Friend Property Set CopyColl(ByRef rhs As cReportControls2)
  Set m_CopyColl = rhs
  
  If m_Coll Is Nothing Then Exit Property
  
  Dim Section As cReportSection
  
  For Each Section In m_Coll
    Set Section.CopyColl = rhs
  Next Section
End Property

Private Function cIReportGroupSections_Item(ByVal kItem As Variant) As cReportSection
  Set cIReportGroupSections_Item = Item(kItem)
End Function

Private Function cIReportGroupSections_NewEnum() As stdole.IUnknown
  Set cIReportGroupSections_NewEnum = NewEnum()
End Function

Private Property Let cIReportGroupSections_TypeSection(rhs As csRptTypeSection)
  TypeSection = rhs
End Property

Private Property Get cIReportGroupSections_TypeSection() As csRptTypeSection
  cIReportGroupSections_TypeSection = TypeSection
End Property
' propiedades privadas
' funciones publicas
Public Function Add(Optional ByVal c As cReportSection = Nothing, _
                    Optional ByRef Key As Variant, _
                    Optional ByVal Index As Integer = -1) As cReportSection
                    
  On Error GoTo ControlError

  If c Is Nothing Then Set c = New cReportSection

  If IsMissing(Key) Then
    Key = GetNextKey()
  Else
    RefreshNextKey Key
  End If

  Key = GetKey(Key)

  If Index <> -1 And m_Coll.Count > 0 Then
    
    m_Coll.Add c, Key, Index
  Else
    m_Coll.Add c, Key
  End If

  Set c.CopyColl = m_CopyColl

  If m_Coll.Count() = 1 Then
    c.TypeSection = m_MainTypeSection
  Else
    c.TypeSection = m_TypeSection
  End If

  pRefreshIndex
  c.Indice = m_Coll.Count()

  c.Key = Key

  Set Add = c
  Exit Function
ControlError:
  Set Add = Nothing
End Function

Public Sub Clear()
  CollClear m_Coll
End Sub

Public Sub Remove(ByVal kItem As Variant)
  On Error GoTo ControlError
  
  Item(kItem).SectionLines.Clear
  m_Coll.Remove kItem

  Dim i As Integer
  For i = 1 To m_Coll.Count()
    m_Coll.Item(i).Indice = i
    m_Coll.Item(i).Name = Replace(Mid$(m_Coll.Item(i).Name, 1, 2), "_", vbNullString) & "_" & i
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

Public Function Item(ByVal kItem As Variant) As cReportSection
Attribute Item.VB_UserMemId = 0
  On Error GoTo ControlError
  Set Item = m_Coll.Item(kItem)
  Exit Function
ControlError:
End Function

'---------------------------------------
' cIReportGroupSections
Private Function cIReportGroupSections_Count() As Long
  cIReportGroupSections_Count = Count()
End Function

' funciones privadas
Private Sub pRefreshIndex()
  Dim i As Integer
  For i = 1 To m_Coll.Count
    m_Coll(i).RealIndice = i
  Next
End Sub

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
  Set NewEnum = m_Coll.[_NewEnum]
End Function

' construccion - destruccion
Private Sub Class_Initialize()
#If PREPROC_DEBUG Then
  gdbInitInstance C_Module
#End If
  
  Set m_Coll = New Collection
End Sub

Private Sub Class_Terminate()
  Set CopyColl = Nothing
  CollClear m_Coll
  Set m_Coll = Nothing
  
#If PREPROC_DEBUG Then
  gdbTerminateInstance C_Module
#End If
End Sub

