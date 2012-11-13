VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportSectionLines"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportSectionLines
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
Private m_Coll          As Collection
' Este es un puntero a la coleccion gemela que contiene cReport
Private m_CopyColl      As cReportControls2
Private m_TypeSection   As csRptTypeSection
' propiedades publicas
Public Property Get TypeSection() As csRptTypeSection
  TypeSection = m_TypeSection
End Property

Public Property Let TypeSection(ByRef rhs As csRptTypeSection)
   m_TypeSection = rhs
End Property

' propiedades friend
Friend Property Set CopyColl(ByRef rhs As cReportControls2)
  Dim SectionLn As cReportSectionLine
  
  Set m_CopyColl = rhs
  
  If m_Coll Is Nothing Then Exit Property
  
  For Each SectionLn In m_Coll
    Set SectionLn.CopyColl = rhs
  Next SectionLn
End Property

Friend Property Get CopyColl() As cReportControls2
  Set CopyColl = m_CopyColl
End Property

' propiedades privadas
' funciones publicas
Public Function Add(Optional ByVal c As cReportSectionLine = Nothing, _
                    Optional ByRef Key As Variant, _
                    Optional ByVal Index As Integer = -1) As cReportSectionLine
                    
  On Error GoTo ControlError
  
  If c Is Nothing Then Set c = New cReportSectionLine
  
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

  c.TypeSection = m_TypeSection

  pRefreshIndex
  c.Indice = m_Coll.Count()

  c.Key = Key

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
  If Not Item(kItem) Is Nothing Then
    With Item(kItem)
      If Not .Controls Is Nothing Then
        .Controls.Clear
        Set .Controls.SectionLine = Nothing
        Set .Controls.CopyColl = Nothing
      End If
    End With
    m_Coll.Remove kItem
  End If
  
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

Public Function Item(ByVal kItem As Variant) As cReportSectionLine
Attribute Item.VB_UserMemId = 0
  On Error GoTo ControlError
  Set Item = m_Coll.Item(kItem)
  Exit Function
ControlError:
End Function

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
  Set NewEnum = m_Coll.[_NewEnum]
End Function

' funciones privadas
Private Sub pRefreshIndex()
  Dim i As Integer
  For i = 1 To m_Coll.Count
    m_Coll(i).RealIndice = i
  Next
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  Set m_Coll = New Collection
End Sub

Private Sub Class_Terminate()
  Set CopyColl = Nothing
  CollClear m_Coll
  Set m_Coll = Nothing
End Sub
