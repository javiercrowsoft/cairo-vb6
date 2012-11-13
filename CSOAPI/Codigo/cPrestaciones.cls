VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cPrestaciones
' 11-07-00

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
Public Sub Clear()
    CollClear m_Coll
    m_IsLoaded = False
End Sub

' el remove de esta colección es especial ya que tiene que borrar todos los hijos del nodo dentro de la coleccion
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

Public Function Item(ByVal kItem As Variant) As cPrestacion
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

Public Function Load() As Boolean
    Dim sqlstmt As String
    Dim rsPrestaciones As ADODB.Recordset
    Dim Prestacion As cPrestacion
    
    If Not m_IsLoaded Then
        Clear
    
        sqlstmt = "select * from prestacion"
        
        If Not gDB.OpenRs(sqlstmt, rsPrestaciones, , , , "cPrestaciones.Load", "cPrestaciones", "Error al cargar las prestaciones") Then Exit Function
                                
        While Not rsPrestaciones.EOF
        
            Set Prestacion = Add(Prestacion, rsPrestaciones(cscPreID).Value)
            Prestacion.Id = rsPrestaciones.fields(cscPreID).Value
            Prestacion.Name = gDB.ValField(rsPrestaciones.fields, cscPreNombre)
            Prestacion.Group = gDB.ValField(rsPrestaciones.fields, cscPreGrupo)
                        
            Set Prestacion = Nothing
            
            rsPrestaciones.MoveNext
        Wend
    End If
    m_IsLoaded = True
    Load = True
End Function


Public Function Add2(ByVal PRE_ID As Long, ByVal Name As String, ByVal Group As String) As Boolean
    Dim Register As cRegister
    Set Register = New cRegister
  
    Register.FieldId = cscPreID
    Register.Table = csTPrestacion
    Register.Id = PRE_ID
        
    Register.fields.Add2 cscPreNombre, Name, csText
    Register.fields.Add2 cscPreGrupo, Group, csText
        
    If Not gDB.Save(Register, True, "Agregar", "cPrestaciones", "Error al agregar la prestación") Then Exit Function
        
    ' Ahora lo agrego a la coleccion
    Dim Prestacion As cPrestacion
    Set Prestacion = Add(Prestacion, PRE_ID)
    Prestacion.Id = PRE_ID
    Prestacion.Name = Name
    Prestacion.Group = Group
    
    Set Prestacion = Nothing
    
    Add2 = True
End Function

' funciones privadas
Private Function Add(ByVal c As cPrestacion, Optional Key As Variant) As cPrestacion
    On Error GoTo ControlError

    If c Is Nothing Then Set c = New cPrestacion

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

' construccion - destruccion
Private Sub Class_Initialize()
    Set m_Coll = New Collection
End Sub

Private Sub Class_Terminate()
    CollClear m_Coll
    Set m_Coll = Nothing
End Sub


