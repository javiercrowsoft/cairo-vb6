VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cBranchConfigs"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cBranchConfigs
' 25-03-00

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
Private m_IsLoaded      As Boolean
' Properties publicas
Public Property Get IsLoaded() As Boolean
    IsLoaded = m_IsLoaded
End Property
Public Property Let IsLoaded(ByVal rhs As Boolean)
    m_IsLoaded = rhs
End Property
' Properties privadas
' funciones publicas
Public Function Add(ByVal c As cBranchConfig, Optional Key As Variant) As cBranchConfig
    On Error GoTo ControlError

    If c Is Nothing Then Set c = New cBranchConfig

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
    m_IsLoaded = False
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

Public Function Item(ByVal kItem As Variant) As cBranchConfig
Attribute Item.VB_UserMemId = 0
    On Error GoTo ControlError
    If IsNumeric(kItem) Then kItem = GetKey(kItem)
    Set Item = m_Coll(kItem)
    Exit Function
ControlError:
End Function

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
    Set NewEnum = m_Coll.[_NewEnum]
End Function

Public Function Load(ByVal Id As Long) As Boolean
    Dim sqlstmt As String
    Dim rsConfig As ADODB.Recordset
    Dim BranchConfig As cBranchConfig
    
    If Not m_IsLoaded Then
        Clear
        
        sqlstmt = "select  " + cscRamcAspecto + "," + cscRamcValor + " from " + csTramaConfig + " where " + cscRamId + " = " + Trim(Id)
    
        If Not gDB.OpenRs(sqlstmt, rsConfig, , , , "cBranchConfigs.GetConfig", "cBranchConfigs", "Error al cargar la rama") Then Exit Function
        
        While Not rsConfig.EOF
            Set BranchConfig = Add(BranchConfig, gDB.ValField(rsConfig.fields, cscRamcAspecto))
            BranchConfig.Aspect = gDB.ValField(rsConfig.fields, cscRamcAspecto)
            BranchConfig.Value = gDB.ValField(rsConfig.fields, cscRamcValor)
            
            Set BranchConfig = Nothing
            
            rsConfig.MoveNext
        Wend
    End If
    m_IsLoaded = True
    Load = True
End Function

Public Sub Copy(ByVal Id As Long)

End Sub

Public Function Paste(ByVal IdToCopy As Long, ByVal IdToPaste As Long)

End Function

Public Function Cut(ByVal Id As Long)

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
