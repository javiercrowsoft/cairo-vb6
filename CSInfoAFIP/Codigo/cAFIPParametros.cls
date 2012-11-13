VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAFIPParametros"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesInfoAFIP.cIAFIPParametros
'--------------------------------------------------------------------------------
' cAFIPParametros
' cAFIPParametro
' 00-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cAFIPParametros"
' estructuras
' variables privadas
Private m_Coll As Collection
' propiedades publicas
' propiedades privadas
' funciones publicas

Public Function Load(ByVal Afesq_id As Long) As Boolean
  Dim rs      As ADODB.Recordset
  Dim sqlstmt As String
  
  Dim Mouse   As cMouseWait
  Set Mouse = New cMouseWait
  
  sqlstmt = "select afparam_id from AFIPParametro" & _
              " where afesq_id = " & Afesq_id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", C_Module) Then Exit Function
  
  Clear
  
  While Not rs.EOF
    
    With Add(Nothing, GetKey(rs.Fields(0)))
      If Not .Load(rs.Fields(0)) Then Exit Function
    End With
  
    rs.MoveNext
  Wend
  
  Load = True
End Function

Public Function Add(ByVal c As cAFIPParametro, Optional Key As Variant) As cAFIPParametro
  On Error GoTo ControlError

  If c Is Nothing Then Set c = New cAFIPParametro

  If IsMissing(Key) Then
      m_Coll.Add c
  Else
      m_Coll.Add c, GetKey(Key)
  End If

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
    If VarType(kItem) = vbString Then
      m_Coll.Remove GetIndexFromKey(m_Coll, kItem)
    Else
      m_Coll.Remove kItem
    End If
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

Public Function Item(ByVal kItem As Variant) As cAFIPParametro
Attribute Item.VB_UserMemId = 0
    On Error GoTo ControlError
    Set Item = m_Coll(kItem)
    Exit Function
ControlError:
End Function

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
    Set NewEnum = m_Coll.[_NewEnum]
End Function


Private Function cIAFIPParametros_Add(ByVal c As CSInterfacesInfoAFIP.cIAFIPParametro, Optional Key As Variant) As CSInterfacesInfoAFIP.cIAFIPParametro
  Set cIAFIPParametros_Add = Add(c, Key)
End Function

Private Sub cIAFIPParametros_Clear()
  Clear
End Sub

Private Function cIAFIPParametros_Count() As Long
  cIAFIPParametros_Count = Count
End Function

Private Function cIAFIPParametros_Item(ByVal kItem As Variant) As CSInterfacesInfoAFIP.cIAFIPParametro
  Set cIAFIPParametros_Item = Item(kItem)
End Function

Private Function cIAFIPParametros_NewEnum() As stdole.IUnknown
  Set cIAFIPParametros_NewEnum = m_Coll.[_NewEnum]
End Function

Private Sub cIAFIPParametros_Remove(ByVal kItem As Variant)
  Remove kItem
End Sub

' funciones friend
Friend Function EndCopy(ByVal Afesq_id As Long) As Boolean
  Dim Parametro As cAFIPParametro
  For Each Parametro In m_Coll
    If Not Parametro.EndCopy(Afesq_id) Then Exit Function
  Next
  
  EndCopy = True
End Function

Friend Function BeginCopy() As Boolean
  Dim Parametro As cAFIPParametro
  For Each Parametro In m_Coll
    If Not Parametro.BeginCopy() Then Exit Function
  Next
  BeginCopy = True
End Function
' funciones privadas

' construccion - destruccion
Private Sub Class_Initialize()
    Set m_Coll = New Collection
End Sub

Private Sub Class_Terminate()
    CollClear m_Coll
    Set m_Coll = Nothing
End Sub
