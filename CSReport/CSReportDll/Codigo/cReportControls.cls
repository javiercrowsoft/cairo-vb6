VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportControls"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cReportControls
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
Private Const C_Module As String = "cReportControls"

' estructuras
' variables privadas
Private m_Coll As Collection
Private m_CopyColl As cReportControls2
Private m_TypeSection As csRptTypeSection
Private m_CollByLeft() As Long
' Este puntero redundante es para poder saber cual es la
' coleccion en la que esta un control
Private m_SectionLine As cReportSectionLine
' propiedades publicas
' propiedades friend
Public Property Get TypeSection() As csRptTypeSection
  TypeSection = m_TypeSection
End Property

Public Property Let TypeSection(ByRef rhs As csRptTypeSection)
  m_TypeSection = rhs
End Property

Friend Property Get CopyColl() As cReportControls2
  Set CopyColl = m_CopyColl
End Property

Friend Property Set CopyColl(ByRef rhs As cReportControls2)
  Set m_CopyColl = rhs
End Property

Friend Property Get SectionLine() As cReportSectionLine
  Set SectionLine = m_SectionLine
End Property

Friend Property Set SectionLine(ByRef rhs As cReportSectionLine)
  Set m_SectionLine = rhs
  
  Dim Ctrl As cReportControl
  For Each Ctrl In m_Coll
    Set Ctrl.SectionLine = rhs
  Next
End Property

Friend Property Get CollByLeft() As Variant
  CollByLeft = m_CollByLeft
End Property

' propiedades privadas
' funciones publicas
Public Function Add(Optional ByVal c As cReportControl = Nothing, Optional ByVal Key As Variant) As cReportControl
  On Error GoTo ControlError
  
  If c Is Nothing Then Set c = New cReportControl

  If IsMissing(Key) Then
    Key = GetNextKey()
  Else
    RefreshNextKey (Key)
  End If
  
  Key = GetKey(Key)
  
  m_Coll.Add c, Key
  
  c.Key = Key
  
  c.TypeSection = m_TypeSection
  
  Set c.SectionLine = m_SectionLine
  
  If Not m_CopyColl Is Nothing Then m_CopyColl.Add2 c, Key
  
  Set Add = c
  Exit Function
ControlError:
  Set Add = Nothing
End Function

Public Sub Clear()
  On Error GoTo ControlError
  Dim i As Long
  
  For i = 1 To m_Coll.Count
    Remove 1
  Next
  
  Exit Sub
ControlError:
End Sub

Public Sub Remove(ByVal kItem As Variant)
  On Error GoTo ControlError
  Set Item(kItem).SectionLine = Nothing
  If Not m_CopyColl Is Nothing Then
    m_CopyColl.Remove Item(kItem).Key
  End If
  m_Coll.Remove kItem
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

Public Function Item(ByVal kItem As Variant) As cReportControl
Attribute Item.VB_UserMemId = 0
  On Error GoTo ControlError
  Set Item = m_Coll.Item(kItem)
  Exit Function
ControlError:
End Function

' funciones friend
Friend Sub OrderCollByLeft()
  Dim j As Long
  Dim i As Long
  Dim tmp As Long
  Dim ctl1 As cReportControl
  Dim ctl2 As cReportControl
  
  ReDim m_CollByLeft(m_Coll.Count)
  
  For i = 1 To UBound(m_CollByLeft)
    m_CollByLeft(i) = i
  Next
  
  For i = 1 To m_Coll.Count - 1
    For j = i To m_Coll.Count - 1
      
      Set ctl1 = m_Coll.Item(m_CollByLeft(j))
      Set ctl2 = m_Coll.Item(m_CollByLeft(j + 1))
      
      If ctl2.Label.Aspect.Left < ctl1.Label.Aspect.Left Then
        tmp = m_CollByLeft(j)
        m_CollByLeft(j) = m_CollByLeft(j + 1)
        m_CollByLeft(j + 1) = tmp
      End If
    Next
  Next
End Sub

' funciones privadas
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
  Dim Ctrl As cReportControl
  
  For Each Ctrl In m_Coll
    Set Ctrl.SectionLine = Nothing
  Next
  
  CollClear m_Coll
  Set m_Coll = Nothing
  Set m_CopyColl = Nothing
  Set m_SectionLine = Nothing
  ReDim m_CollByLeft(0)

#If PREPROC_DEBUG Then
  gdbTerminateInstance C_Module
#End If
End Sub

