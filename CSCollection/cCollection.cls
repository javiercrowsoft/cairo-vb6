VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCollection"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'Option Explicit
'
''--------------------------------------------------------------------------------
'' cCollection
'' 04-01-00
'
''--------------------------------------------------------------------------------
'' notas:
'
''--------------------------------------------------------------------------------
'' api win32
'    ' constantes
'    ' estructuras
'    ' funciones
'
''--------------------------------------------------------------------------------
'
'' constantes
'' estructuras
'' variables privadas
'Private m_Coll As Collection
'' propiedades publicas
'' propiedades privadas
'' funciones publicas
'Public Function Add(ByVal c As cObject, Optional Key As Variant) As cObject
'    On Error GoTo ControlError
'
'    If c Is Nothing Then Set c = New cObject
'
'    If IsMissing(Key) Then
'        m_Coll.Add c
'    Else
'        m_Coll.Add c, GetKey(Key)
'    End If
'
'    Set Add = c
'    Exit Function
'ControlError:
'    Set Add = Nothing
'End Function
'
'Public Sub Clear()
'    CollClear m_Coll
'End Sub
'
'
'Public Sub Remove(ByVal kItem As Variant)
'    On Error GoTo ControlError
'    m_Coll.Remove kItem
'    Exit Sub
'ControlError:
'End Sub
'
'Public Function Count() As Long
'    On Error GoTo ControlError
'    Count = m_Coll.Count
'    Exit Function
'ControlError:
'    Count = 0
'End Function
'
'Public Function item(ByVal kItem As Variant) As cObject
'    On Error GoTo ControlError
'    Set item = m_Coll(kItem)
'    Exit Function
'ControlError:
'End Function
'
'Public Function NewEnum() As IUnknown
'    Set NewEnum = m_Coll.[_NewEnum]
'End Function
'
'Public Function Load(ByVal ID As Long) As Boolean
'
'End Function
'
'Public Sub Copy(ByVal ID As Long)
'
'End Sub
'
'Public Function Paste(ByVal IdToCopy As Long, ByVal IdToPaste As Long)
'
'End Function
'
'Public Function Cut(ByVal ID As Long)
'
'End Function
'' funciones privadas
'Private Function GetKey(ByVal vVal As Variant) As String
'    GetKey = "K" + vVal
'End Function
'
'Private Sub Class_Initialize()
'    Set m_Coll = New Collection
'End Sub
'
'' construccion - destruccion
'Private Sub Class_Terminate()
'    CollClear m_Coll
'    Set m_Coll = Nothing
'End Sub
'
'
