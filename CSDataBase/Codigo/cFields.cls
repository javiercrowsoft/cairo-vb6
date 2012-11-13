VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFields"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cFields
' 04-01-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' FunctionNamees

'--------------------------------------------------------------------------------

' constantes
' estructuras
' variables privadas
Private m_Coll As Collection
Private m_HaveLastUpdate      As Boolean
Private m_HaveWhoModify       As Boolean
Private m_UserId              As Long
' propiedades publicas
Public Property Let UserId(ByVal rhs As Long)
    m_UserId = rhs
End Property
Public Property Get UserId() As Long
    UserId = m_UserId
End Property
Public Property Let HaveLastUpdate(ByVal rhs As Boolean)
    m_HaveLastUpdate = rhs
End Property
Public Property Get HaveLastUpdate() As Boolean
    HaveLastUpdate = m_HaveLastUpdate
End Property

Public Property Let HaveWhoModify(ByVal rhs As Boolean)
    m_HaveWhoModify = rhs
End Property
Public Property Get HaveWhoModify() As Boolean
    HaveWhoModify = m_HaveWhoModify
End Property
' propiedades privadas
' FunctionNamees publicas
Public Function Add(ByVal oField As cField, Optional Key As Variant) As cField
    On Error GoTo ControlError
    
    If oField Is Nothing Then Set oField = New cField
    
    If IsMissing(Key) Then
        m_Coll.Add oField
    Else
        m_Coll.Add oField, GetKey(Key)
    End If
    
    Set Add = oField
    Exit Function
ControlError:
    Set Add = Nothing
End Function

Public Function Add2(ByVal Name As String, ByVal Value As Variant, VarType As csTypes) As cField
    Dim oField As cField
    On Error GoTo ControlError
    
    Set oField = New cField
    
    oField.Name = Name
    If VarType = csBoolean Then
      oField.Value = Trim(CInt(Value))  ' esto es por que convertir boolean a string devuelve "TRUE" O "FALSE" en lugar de "1" o "0"
    Else
      oField.Value = Trim(Value)
    End If
    oField.VarType = VarType
    
    Set Add2 = Add(oField, Name)
    Exit Function
ControlError:
    Set Add2 = Nothing
End Function

Public Sub Remove(ByVal kItem As Variant)
    On Error GoTo ControlError
    m_Coll.Remove kItem
    Exit Sub
ControlError:
End Sub

Public Sub Clear()
    On Error GoTo ControlError
    CollClear m_Coll
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

Public Function item(ByVal kItem As Variant) As cField
Attribute item.VB_UserMemId = 0
    On Error GoTo ControlError
    Set item = m_Coll(kItem)
    Exit Function
ControlError:
End Function

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    Set NewEnum = m_Coll.[_NewEnum]
End Function

Public Function GetInsertFieldString() As String
    Dim s As String
    Dim v As String
    Dim oField As cField
    s = "("
    v = "("
    For Each oField In m_Coll
        s = s & oField.Name & ","
        v = v & oField.Value & ","
    Next
    
    If m_HaveLastUpdate Then
        s = s & cscModificado & ","
        v = v & Format(Now, csSqlDateString) & ","
    End If
    
    If m_HaveWhoModify Then
        s = s & cscModifico & ","
        v = v & m_UserId & ","
    End If
    
    ' saco la ultima coma
    GetInsertFieldString = Left(s, Len(s) - 1) + ") Values " + Left(v, Len(v) - 1) + ")"
End Function

Public Function GetUpdateFieldString() As String
    Dim s As String
    Dim oField As cField

    For Each oField In m_Coll
        s = s & oField.Name & " = " & oField.Value & ","
    Next
    
    If m_HaveLastUpdate Then
        s = s & cscModificado & "=" & Format(Now, csSqlDateString) & ","
    End If
    
    If m_HaveWhoModify Then
        s = s & cscModifico & "=" & m_UserId & ","
    End If
    
    ' saco la ultima coma
    GetUpdateFieldString = Left(s, Len(s) - 1)
End Function

' FunctionNamees privadas

' construccion - destruccion
Private Sub Class_Initialize()
    Set m_Coll = New Collection
End Sub

Private Sub Class_Terminate()
    CollClear m_Coll
    Set m_Coll = Nothing
End Sub

