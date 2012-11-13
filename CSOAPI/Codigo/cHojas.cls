VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cLeaves"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCollection
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
Private Const C_Module = "cLeaves"
' estructuras
' variables privadas
Private m_Coll      As Collection
Private m_IsLoaded    As Boolean
Private m_Branch    As cBranch
Private m_rsLeaves    As ADODB.Recordset
Private m_SpGetHojas  As String

' Properties publicas
Public Property Let SpGetHojas(ByVal rhs As String)
  m_SpGetHojas = rhs
End Property
Public Property Get rsLeaves() As Recordset
  Set rsLeaves = m_rsLeaves
End Property
Public Property Get IsLoaded() As Boolean
  IsLoaded = m_IsLoaded
End Property
Public Property Let IsLoaded(ByVal rhs As Boolean)
  m_IsLoaded = rhs
End Property
Public Property Let Branch(ByRef rhs As cBranch)
  Set m_Branch = rhs
End Property
' Properties privadas
' funciones publicas
Public Function Add(ByVal c As cLeave, Optional Key As Variant) As cLeave
  On Error GoTo ControlError

  If c Is Nothing Then Set c = New cLeave

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

Public Function Item(ByVal kItem As Variant) As cLeave
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

Public Function LoadRs(ByVal branch_id As Long, Optional ByVal Top As Long = -1) As Boolean
  Dim sqlstmt   As String
  If Not m_IsLoaded Or m_rsLeaves Is Nothing Then
  Clear
  
  sqlstmt = m_SpGetHojas & " " & branch_id
  
  If Top > 0 Then sqlstmt = sqlstmt & ",0,'', " & Top
  
    If Not gDB.OpenRs(sqlstmt, _
                      m_rsLeaves, , , , _
                      "cLeaves.Load", _
                      C_Module, _
                      "Error al cargar las hojas") Then
      Exit Function
    End If
  End If
  
  LoadRs = True
End Function

Public Function Load(ByVal branch_id As Long) As Boolean
  Dim sqlstmt   As String
  Dim rsLeaves  As ADODB.Recordset
  Dim fldLeaves As Field
  Dim Leave   As cLeave
  Dim c     As cLeaveColumn
  Dim q     As Integer

  If Not m_IsLoaded Then
    Clear

    sqlstmt = "SP_ArbGetHojas " + Trim(branch_id)

    If Not gDB.OpenRs(sqlstmt, rsLeaves, , , , "cLeaves.Load", C_Module, "Error al cargar las hojas") Then Exit Function

    ' Cargo los Names de las Columns en la rama
    m_Branch.Columns.Clear

    For q = 0 To rsLeaves.Fields.Count - 1
      Set fldLeaves = rsLeaves.Fields(q)
      Set c = m_Branch.Columns.Add(c, fldLeaves.Name)
      c.Name = fldLeaves.Name
      c.VarType = gDB.GetFieldType(fldLeaves)

      Set c = Nothing
    Next

    While Not rsLeaves.EOF
      Set Leave = Add(Leave, gDB.ValField(rsLeaves.Fields, cscHojaId))
      Leave.Id = gDB.ValField(rsLeaves.Fields, cscHojaId)
      Leave.ClientId = gDB.ValField(rsLeaves.Fields, 1)
      Leave.Name = gDB.ValField(rsLeaves.Fields, 2)

      For q = 0 To rsLeaves.Fields.Count - 1
        Set fldLeaves = rsLeaves.Fields(q)
        Set c = Leave.Columns.Add(c, fldLeaves.Name)
        c.Name = fldLeaves.Name
        c.Value = Trim(gDB.ValField(rsLeaves.Fields, fldLeaves.Name))
        c.VarType = gDB.GetFieldType(fldLeaves)

        Set c = Nothing
      Next

      Set Leave = Nothing

      rsLeaves.MoveNext
    Wend
  End If
  m_IsLoaded = True
  Load = True
End Function

Public Sub Copy(ByVal Id As Long)

End Sub

Public Function Paste(ByRef IdToCopy() As Long, ByVal RamIdToPaste As Long, ByVal IsCut As Boolean) As Boolean
  
  On Error GoTo ControlError
  
  Dim rsLeave           As ADODB.Recordset
  Dim rsLeaveNew        As ADODB.Recordset
  Dim rsLeavesInBranch  As ADODB.Recordset
  Dim F                 As ADODB.Field
  Dim sqlstmt           As String
  Dim Id                As Long
  Dim i                 As Integer
  Dim Founded           As Boolean
  Dim str_3445          As String
  
  str_3445 = LNGGetText(3445, vbNullString) 'Error al copiar hojas
  
  Dim mouse As cMouseWait
  Set mouse = New cMouseWait

  sqlstmt = "select * from Hoja where hoja_Id in (" & ArrayToString(IdToCopy()) & ")"
  
  If Not gDB.OpenRs(sqlstmt, rsLeave, csRsStatic, csLockOptimistic, , "Paste", C_Module, str_3445) Then
    Exit Function
  End If
  
  sqlstmt = "select " & cscId & " from Hoja where ram_id = " & RamIdToPaste
  
  If Not gDB.OpenRs(sqlstmt, rsLeavesInBranch, csRsStatic, csLockReadOnly, , "Paste", C_Module, str_3445) Then
    Exit Function
  End If
  
  ' desconecto el recordset
  gDB.DisconnectRecordset rsLeavesInBranch
  
  gDB.BeginTransaction
  
  If Not rsLeave.EOF Then
    
    ' un recordset que no tiene nada
    If Not gDB.OpenRs("select * from Hoja where 1=2", rsLeaveNew, csRsStatic, csLockOptimistic, , "Paste", C_Module, str_3445) Then
      gDB.RollBackTransaction
      Exit Function
    End If
    
    While Not rsLeave.EOF
        
      If Not gDB.ExistsInRecordset(rsLeavesInBranch, cscId, rsLeave(cscId).Value, Founded, "Paste", C_Module, str_3445) Then
        gDB.RollBackTransaction
        Exit Function
      End If
    
      If Not Founded Then
        
        If IsCut Then
          ' Si esta cortando solo cambio el id de la rama
          rsLeave(cscRamId).Value = RamIdToPaste
        Else
          If Not gDB.AddNew(rsLeaveNew) Then GoTo RollBack
          
          If Not gDB.GetNewId(csTHoja, cscHojaId, Id, "Paste", C_Module, str_3445) Then
            gDB.RollBackTransaction
            Exit Function
          End If
          
          For Each F In rsLeave.Fields
            rsLeaveNew(F.Name).Value = F.Value
          Next
          rsLeaveNew(cscHojaId) = Id
          rsLeaveNew(cscRamId) = RamIdToPaste
          If Not gDB.Update(rsLeaveNew) Then GoTo RollBack
        End If
      Else
        ' Si esta cortando y pengando en la misma Branch, no hay que hacer nada
        If rsLeave(cscRamId) <> RamIdToPaste Then
          If IsCut Then
            ' si esta cortando y ya esta en la rama destino, borro la hoja de la rama origen
            If Not gDB.Delete(rsLeave) Then GoTo RollBack
          End If
        End If
      End If
      
      rsLeave.MoveNext
    Wend
    
  End If
  
  
  ' Ahora los que estan en la raiz pero sin asignar
  For i = 0 To UBound(IdToCopy())
  
    If IdToCopy(i) < 0 Then
  
      If Not gDB.GetNewId(csTHoja, cscHojaId, Id, "Paste", C_Module, str_3445) Then
        gDB.RollBackTransaction
        Exit Function
      End If
      
  
      sqlstmt = "insert into Hoja (" & cscHojaId & "," & cscId & "," & cscRamId & "," & cscArbId & "," & cscModificado
      sqlstmt = sqlstmt & "," & cscModifico & "," & cscCreado & ")"
      sqlstmt = sqlstmt & " select " & Id & "," & (IdToCopy(i) * -1) & "," & RamIdToPaste & "," & cscArbId & ", getdate()," & gUser.Id & ", getdate() "
      sqlstmt = sqlstmt & " from Rama where ram_Id = " & RamIdToPaste
      
      If Not gDB.Execute(sqlstmt, "Paste", C_Module, str_3445) Then
        gDB.RollBackTransaction
        Exit Function
      End If
    End If
  Next i
  
  gDB.CommitTransaction
  
  Paste = True
  Exit Function
ControlError:
RollBack:
  gDB.RollBackTransaction
End Function

Public Function Cut(ByVal Id As Long)

End Function
' funciones privadas
Private Sub ConvertIds(ByRef v() As Long)
  Dim i As Integer
  For i = 0 To UBound(v())
    If v(i) < 0 Then v(i) = v(i) * -1
  Next i
End Sub
' construccion - destruccion
Private Sub Class_Initialize()
  Set m_Coll = New Collection
  m_SpGetHojas = "SP_ArbGetHojas"
End Sub

Private Sub Class_Terminate()
  CollClear m_Coll
  Set m_Coll = Nothing
  Set m_Branch = Nothing
  Set m_rsLeaves = Nothing
End Sub
