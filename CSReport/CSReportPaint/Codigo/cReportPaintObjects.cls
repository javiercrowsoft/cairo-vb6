VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportPaintObjects"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportPaintObjects
' 18-09-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' constantes
' estructuras
' variables privadas
Private m_Coll As Collection
Private m_vZorder() As String
' propiedades publicas
' propiedades privadas
' funciones publicas
Friend Function Add(Optional ByVal c As cReportPaintObject = Nothing, Optional ByRef Key As Variant) As cReportPaintObject
  On Error GoTo ControlError
  
  If c Is Nothing Then Set c = New cReportPaintObject
  

  If IsMissing(Key) Then

    Key = GetNextKey()
  End If
  

  Key = GetKey(Key)
  
  m_Coll.Add c, Key
  

  c.Key = Key
  
  ReDim Preserve m_vZorder(m_Coll.Count())
  

  m_vZorder(m_Coll.Count()) = Key
  
  Set Add = c
  Exit Function
ControlError:

  Set Add = Nothing
End Function

Public Sub Clear()
  CollClear m_Coll
  ReDim m_vZorder(0)
End Sub

Public Sub Remove(ByVal kItem As Variant)
  On Error GoTo ControlError
  Dim sKey As String
  sKey = Item(kItem).Key
  m_Coll.Remove (kItem)
  DellZOrder (sKey)
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

Public Sub BringToFront(ByVal kItem As String)
  Zorder kItem, True
End Sub

Public Sub SendToBack(ByVal kItem As String)
  Zorder kItem, False
End Sub

' Recibe una clave y mueve esta clave al elemento 1 del vector si Top es False
' o al ultimo elemento del vector si Top es True.
' El vector tiene las posiciones de los elementos de la coleccion, donde el elemento
' que esta mas Top esta en la ultima posicion y el que esta mas abajo esta en la posicion
' 1.
' El nZorder sirve para gurdar la posicion de los controles.
Public Sub Zorder(ByVal kItem As String, Optional ByVal Top As Boolean = True)
  Dim i As Integer
  
  ' Busco la clave y la pongo al principio del vector
  For i = 1 To UBound(m_vZorder)
    If m_vZorder(i) = kItem Then
      Exit For
    End If
  Next
  
  If i >= UBound(m_vZorder) And Top Then Exit Sub
  If i = 1 And Not Top Then Exit Sub
  
  If Top Then
    For i = i To UBound(m_vZorder) - 1
      m_vZorder(i) = m_vZorder(i + 1)
      Item(m_vZorder(i)).Aspect.nZOrder = i
    Next
    m_vZorder(UBound(m_vZorder)) = kItem
    Item(kItem).Aspect.nZOrder = UBound(m_vZorder)
  Else
    For i = i To 2 Step -1
      m_vZorder(i) = m_vZorder(i - 1)
      Item(m_vZorder(i)).Aspect.nZOrder = i
    Next
    m_vZorder(1) = kItem
    Item(kItem).Aspect.nZOrder = 1
  End If
End Sub

Public Function GetZOrderForKey(ByVal Key As String) As Integer
  Dim i As Integer
  
  For i = 1 To UBound(m_vZorder)
    If m_vZorder(i) = Key Then
      GetZOrderForKey = i
      Exit For
    End If
  Next i
  
End Function

Public Function GetNextKeyForZOrder(ByVal Index As Integer) As String
  GetNextKeyForZOrder = m_vZorder(Index)
End Function

Public Function GetNextPaintObjForZOrder(ByVal Index As Integer) As cReportPaintObject
  Set GetNextPaintObjForZOrder = m_Coll.Item(GetNextKeyForZOrder(Index))
End Function

Public Function Item(ByVal kItem As Variant) As cReportPaintObject
Attribute Item.VB_UserMemId = 0
  On Error GoTo ControlError
  Set Item = m_Coll.Item(kItem)
  Exit Function
ControlError:
End Function

' funciones privadas
Private Sub DellZOrder(ByVal sKey As String)
  Dim i As Integer
  Dim j As Integer
  For i = 1 To UBound(m_vZorder)
    If m_vZorder(i) = sKey Then
      For j = i To UBound(m_vZorder) - 1
        m_vZorder(j) = m_vZorder(j + 1)
      Next
      ReDim Preserve m_vZorder(UBound(m_vZorder) - 1)
      Exit Sub
    End If
  Next
End Sub

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
  Set NewEnum = m_Coll.[_NewEnum]
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  Set m_Coll = New Collection
  ReDim m_vZorder(0)
End Sub

Private Sub Class_Terminate()
  CollClear m_Coll

  Set m_Coll = Nothing
  ReDim m_vZorder(0)
End Sub

