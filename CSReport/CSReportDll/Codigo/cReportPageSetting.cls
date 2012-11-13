VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportPageSetting"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportPageInfoSetting
' 05-11-01

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
Private m_Height As Single
' propiedades publicas
Public Property Get Height() As Single
  Height = m_Height
End Property

Public Property Let Height(ByVal rhs As Single)
  m_Height = rhs
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Add(ByRef SectionLine As cReportSectionLine, Optional ByVal c As cReportPageInfo = Nothing, Optional ByRef Key As Variant) As cReportPageInfo
  On Error GoTo ControlError
  
  If c Is Nothing Then Set c = New cReportPageInfo

  If IsMissing(Key) Then
    Key = GetNextKey()
  End If
  
  Key = GetKey(Key)
  
  m_Coll.Add c, Key
  
  Set Add = c
  Set c.SectionLine = SectionLine
  
  Exit Function
ControlError:
  Set Add = Nothing
End Function

Public Sub Clear()
  CollClear m_Coll
End Sub

Public Sub Remove(ByVal kItem As Variant)
  On Error GoTo ControlError
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

Public Function Item(ByVal kItem As Variant) As cReportPageInfo
Attribute Item.VB_UserMemId = 0
  On Error GoTo ControlError
  Set Item = m_Coll.Item(kItem)
  Exit Function
ControlError:
End Function

' funciones privadas
Private Sub Class_Initialize()
  Set m_Coll = New Collection
End Sub

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
  Set NewEnum = m_Coll.[_NewEnum]
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  CollClear m_Coll
   Set m_Coll = Nothing
End Sub
