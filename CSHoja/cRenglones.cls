VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRenglones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"No"
Attribute VB_Ext_KEY = "Collection" ,"UserDefinedCollection"
Attribute VB_Ext_KEY = "Member0" ,"cRenglon"
Option Explicit

Private m_coll As Collection


Public Property Get Item(ByVal Index As Variant) As cRenglon
Attribute Item.VB_UserMemId = 0
  Set Item = m_coll(Index)
End Property

Public Property Get Count() As Integer
  Count = m_coll.Count
End Property

'------------------------------------------------------------------
Public Function Remove(ByVal Index As Long) As Boolean
  On Error GoTo ControlError
  
  m_coll.Remove Index
  
  Exit Function
ControlError:
  ScShowError "cRenglones.Add", 1
End Function

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
  On Error GoTo ControlError
  Set NewEnum = m_coll.[_NewEnum]
ControlError:
End Function

Public Sub Clear()
  ClearColl m_coll
End Sub

'------------------------------------------------------------------
Public Function Add(Optional sKey As Variant) As cRenglon
    On Error GoTo ControlError
    
    Dim C As cRenglon
    
    If C Is Nothing Then Set C = New cRenglon

    If IsMissing(sKey) Then
        m_coll.Add C
    Else
        m_coll.Add C, GetKey(sKey)
    End If

    Set Add = C
    Exit Function
ControlError:
    
    If Err.Number = 457 Then
      ScInfo "El renglon ya esta en la lista de renglones"
    End If
    
    Set Add = Nothing
End Function
'------------------------------------------------------------------
Private Sub Class_Initialize()
  Set m_coll = New Collection
End Sub

Private Sub Class_Terminate()
  ClearColl m_coll
  Set m_coll = Nothing
End Sub

