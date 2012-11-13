VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportControls2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportControls2
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
Private Const C_Module As String = "cReportControls2"

' estructuras
' variables privadas
Private m_Coll As Collection

' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
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

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
  Set NewEnum = m_Coll.[_NewEnum]
End Function

' funciones friend
Friend Sub Clear()
  CollClear m_Coll
End Sub

Friend Sub Remove(ByVal kItem As Variant)
  On Error GoTo ControlError
  m_Coll.Remove kItem
  Exit Sub
ControlError:
End Sub

Friend Function Add2(ByVal c As cReportControl, Optional ByRef Key As Variant) As cReportControl
  On Error GoTo ControlError
  
  If c Is Nothing Then Set c = New cReportControl
  
  If IsMissing(Key) Then
    m_Coll.Add (c)
  Else
    m_Coll.Add c, GetKey(Key)
  End If

  Set Add2 = c
  Exit Function
ControlError:
  Set Add2 = Nothing
End Function
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
#If PREPROC_DEBUG Then
  gdbInitInstance C_Module
#End If
  
  Set m_Coll = New Collection
End Sub

Private Sub Class_Terminate()
  CollClear m_Coll
  Set m_Coll = Nothing

#If PREPROC_DEBUG Then
  gdbTerminateInstance C_Module
#End If
End Sub
