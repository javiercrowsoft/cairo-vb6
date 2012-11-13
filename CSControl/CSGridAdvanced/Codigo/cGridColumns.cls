VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGridColumns"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cGridColumns
' 03-10-00

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
Private m_Coll          As Collection

' eventos
Public Event AddColumn(ByVal c As cGridColumn)
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Function Add(ByVal c As cGridColumn, _
                    Optional ByVal Key As Variant, _
                    Optional ByVal IsDetail As Boolean) As cGridColumn
                    
  On Error GoTo ControlError

  Const c_col_aux_group1 As String = "#aux_group_1"
  Const c_col_aux_group2 As String = "#aux_group_2"

  Dim bRaiseEvent As Boolean
  bRaiseEvent = True

  If c Is Nothing Then Set c = New cGridColumn
  
  If IsMissing(Key) Then
    m_Coll.Add c
  Else
    If IsNumeric(Key) Then Key = GetKey(Key)
    
    If Key = c_col_aux_group1 Or _
       Key = c_col_aux_group2 Then
      
      bRaiseEvent = False
      m_Coll.Add c, Key, 1
      
    Else
      m_Coll.Add c, Key
    End If
    
    c.Key = Key
  End If

  Set Add = c
  
  c.Index = m_Coll.Count
  c.IsDetail = IsDetail
    
  If bRaiseEvent Then
  
    RaiseEvent AddColumn(c)
  End If
  
  Exit Function
ControlError:
  Set Add = Nothing
End Function

Public Sub Clear()
  CollClear m_Coll
End Sub

Public Sub Remove(ByVal kItem As Variant)
  On Error GoTo ControlError
  If IsNumeric(kItem) Then kItem = GetKey(kItem)
  m_Coll.Remove kItem
  Exit Sub
ControlError:
End Sub

Public Function Count() As Long
  On Error GoTo ControlError
  Count = m_Coll.Count
  Exit Function
ControlError:
  Count = 0
End Function

Public Function Item(ByVal kItem As Variant) As cGridColumn
Attribute Item.VB_UserMemId = 0
  On Error GoTo ControlError
  Set Item = m_Coll(kItem)
  Exit Function
ControlError:
  Err.Clear
End Function

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
  Set NewEnum = m_Coll.[_NewEnum]
End Function
' funciones privadas
Private Sub Class_Initialize()
  Set m_Coll = New Collection
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  CollClear m_Coll
  Set m_Coll = Nothing
End Sub
