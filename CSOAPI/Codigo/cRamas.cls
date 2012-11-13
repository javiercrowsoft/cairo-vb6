VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cBranchs"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cBranchs
' 04-01-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cBranchs"
' estructuras
' Seudo - Variables
Private c_ErrorSave     As String

' variables privadas
Private m_Coll          As Collection
Private m_IsLoaded      As Boolean
Private m_Root          As Long
Private m_NestedLevel   As Long

Private m_NextIdOfCopy  As Long ' identifica a las ramas que se agregaron a la coleccion despues de una copia
                                ' es unico para cada copia y se agrega a la propiedad IdOfCopy de la rama.

' Properties publicas
Public Property Get IsLoaded() As Boolean
    IsLoaded = m_IsLoaded
End Property
Public Property Let IsLoaded(ByVal rhs As Boolean)
    m_IsLoaded = rhs
    If rhs = False Then m_Root = 0
End Property
Public Property Get Root() As cBranch
    If m_Root = csNO_ID Then
        Set Root = Nothing
    Else
        Set Root = Item(m_Root)
    End If
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
    
    Dim Id      As Long
    Dim HijoId  As Long
    
    m_NestedLevel = m_NestedLevel + 1
    
    If IsNumeric(kItem) Then
        Id = kItem
        kItem = GetKey(kItem)
    Else
        Id = m_Coll(kItem).Id
    End If

    While HaveChilds(Id, HijoId)
        Remove HijoId
    Wend

    m_NestedLevel = m_NestedLevel - 1
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

Public Function Item(ByVal kItem As Variant) As cBranch
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
    Dim rsBranchs As ADODB.Recordset
    Dim Branch As cBranch
    
    If Not m_IsLoaded Then
        Clear
    
        sqlstmt = "SP_ArbGetRamas " + Trim(Id)
        
        If Not gDB.OpenRs(sqlstmt, rsBranchs, , , , "cBranchs.Load", C_Module, c_ErrorSave) Then Exit Function
        
        m_Root = 0
        If Not rsBranchs.EOF Then m_Root = rsBranchs.Fields(cscRamId).Value
        
        While Not rsBranchs.EOF
        
            Set Branch = Add(Branch, rsBranchs.Fields(cscRamId).Value)
            Branch.Id = gDB.ValField(rsBranchs.Fields, cscRamId)
            Branch.Name = gDB.ValField(rsBranchs.Fields, cscRamNombre)
            Branch.Father = gDB.ValField(rsBranchs.Fields, cscRamPadre)
            Branch.TreeId = Id
            
            Set Branch = Nothing
            
            rsBranchs.MoveNext
        Wend
    End If
    m_IsLoaded = True
    Load = True
End Function

Public Function ReLoadBranch(ByVal ram_id As Long, ByRef IdOfCopy As Long) As Boolean
    Dim sqlstmt As String
    Dim rsBranchs As ADODB.Recordset
    Dim Branch As cBranch
    
    IdOfCopy = 0
    m_NextIdOfCopy = m_NextIdOfCopy + 1
    
    sqlstmt = "SP_ArbGetDecendencia " & ram_id & ",0,1,1,1" ' sin ram_id y con ram_id_padre y con nombre
    
    If Not gDB.OpenRs(sqlstmt, rsBranchs, , , , "ReLoadBranch", C_Module, c_ErrorSave) Then Exit Function
    
    While Not rsBranchs.EOF
        
        If ExistsObjectInColl(m_Coll, GetKey(rsBranchs(cscRamId).Value)) Then
            m_Coll.Remove GetKey(rsBranchs(cscRamId).Value)
        End If
        
        Set Branch = Add(Branch, rsBranchs(cscRamId).Value)
        Branch.Id = gDB.ValField(rsBranchs.Fields, cscRamId)
        Branch.Name = gDB.ValField(rsBranchs.Fields, cscRamNombre)
        Branch.Father = gDB.ValField(rsBranchs.Fields, cscRamPadre)
        Branch.TreeId = gDB.ValField(rsBranchs.Fields, cscArbId)
        Branch.IdOfCopy = m_NextIdOfCopy
        Set Branch = Nothing
        
        rsBranchs.MoveNext
    Wend

    IdOfCopy = m_NextIdOfCopy
    ReLoadBranch = True
End Function

Public Function LoadBranch(ByVal ram_id As Long, ByRef IdOfCopy As Long) As Boolean
    Dim sqlstmt As String
    Dim rsBranchs As ADODB.Recordset
    Dim Branch As cBranch
    
    IdOfCopy = 0
    m_NextIdOfCopy = m_NextIdOfCopy + 1

    sqlstmt = "SP_ArbGetDecendencia " & ram_id & ",0,1,1,1" ' sin ram_id y con ram_id_padre y con nombre
    
    If Not gDB.OpenRs(sqlstmt, rsBranchs, , , , "cBranchs.LoadBranch", C_Module, c_ErrorSave) Then Exit Function
    
    While Not rsBranchs.EOF
        
        If Not ExistsObjectInColl(m_Coll, GetKey(rsBranchs(cscRamId).Value)) Then
            
            Set Branch = Add(Branch, rsBranchs(cscRamId).Value)
            Branch.Id = gDB.ValField(rsBranchs.Fields, cscRamId)
            Branch.Name = gDB.ValField(rsBranchs.Fields, cscRamNombre)
            Branch.Father = gDB.ValField(rsBranchs.Fields, cscRamPadre)
            Branch.TreeId = gDB.ValField(rsBranchs.Fields, cscArbId)
            Branch.IdOfCopy = m_NextIdOfCopy
            Set Branch = Nothing
        
        End If
        rsBranchs.MoveNext
    Wend

    IdOfCopy = m_NextIdOfCopy
    LoadBranch = True
End Function

Public Function Add2(ByVal Name As String, ByVal TreeId As Long, ByVal Father As Long, ByRef BranchId As Long) As Boolean
    Dim register As cRegister
    Set register = New cRegister
  
    Dim RamOrden    As Integer
    Dim rs          As ADODB.Recordset
    Dim sqlstmt     As String
    Dim bTempBranch As Boolean
    
    bTempBranch = Father = csTEMP_BRANCH
    
    '
    ' - Si es una rama temporal la agrego como una raiz
    '   y despues le asigno como padre
    '   su propio ID para que quede huerfana
    If bTempBranch Then
      
      Father = 0
    
    '
    ' - Si no obtengo el numero de orden que le corresponde
    '   dentro del padre
    '
    Else
      sqlstmt = "select maximo = max(ram_orden) from rama where ram_id_padre = " & Father
      
      If Not gDB.OpenRs(sqlstmt, rs, , csLockReadOnly, , "Agregar", C_Module, c_ErrorSave, csErrorInformation) Then Exit Function
    
      If rs.EOF Then
          RamOrden = 1
      Else
          RamOrden = gDB.ValField(rs.Fields, "maximo") + 1
      End If
    End If
    
    register.FieldId = cscRamId
    register.Table = csTRama
    register.Id = csNO_ID
    
    register.Fields.Add2 cscRamNombre, Name, csText
    register.Fields.Add2 cscModifico, gUser.Id, csId
    register.Fields.Add2 cscArbId, TreeId, csId
    register.Fields.Add2 cscRamOrden, RamOrden, csInteger
    
    ' Si es temporal abro una transaccion
    If bTempBranch Then
      register.Fields.Add2 cscRamPadre, Father, csInteger ' Lo paso como entero para
                                                          ' que no convierta el 0 en NULL
      gDB.BeginTransaction
    Else
      register.Fields.Add2 cscRamPadre, Father, csId
    End If
    
    If Not gDB.Save(register, True, "Agregar", C_Module, c_ErrorSave) Then
      If bTempBranch Then gDB.RollBackTransaction
      Exit Function
    End If
    
    ' Obtengo el id de la nueva rama
    BranchId = register.Id
    
    ' Si es temporal le asigno como padre su propio ID
    If bTempBranch Then
      
      sqlstmt = "update rama set ram_id_padre = ram_id," & _
                " creado = " & Format(DateAdd("d", 2, Now), C_PSqlDateTime) & _
                " where ram_id = " & BranchId
      If Not gDB.Execute(sqlstmt) Then
        gDB.RollBackTransaction
        Exit Function
      End If
      
      gDB.CommitTransaction
    
    ' Si no es temporal la agrego a la coleccion de ramas
    Else
    
      ' Ahora lo agrego a la coleccion
      Dim Branch As cBranch
      Set Branch = Add(Branch, BranchId)
      Branch.Id = BranchId
      Branch.Name = Name
      Branch.Father = Father
      
      Set Branch = Nothing
    End If
    
    Add2 = True
End Function

Public Function Delete(ByVal Id As Long) As Boolean
    Dim sqlstmt As String
    
    gDB.BeginTransaction
        
    sqlstmt = "SP_ArbBorrarRama " & Id
    If Not gDB.Execute(sqlstmt, "Borrar", C_Module, c_ErrorSave) Then GoTo RollBack
    
    sqlstmt = "delete Rama where ram_id  = " & Id
    If Not gDB.Execute(sqlstmt, "Borrar", C_Module, c_ErrorSave) Then GoTo RollBack
    
    Remove Id
    
    gDB.CommitTransaction
    
    Delete = True
    Exit Function
RollBack:
    gDB.RollBackTransaction
End Function

Public Function Copy(ByVal Id As Long) As Boolean

End Function

Public Function Paste(ByVal IdToCopy As Long, ByVal IdToPaste As Long, ByVal SoloLosChilds As Boolean, ByVal IsCut As Boolean) As Boolean
    Dim sqlstmt As String
        
    If Not IsCut Then
        sqlstmt = "SP_ArbCopiarRama " & IdToCopy & ", " & IdToPaste & "," & CInt(SoloLosChilds)
    Else
        sqlstmt = "SP_ArbCortarRama " & IdToCopy & ", " & IdToPaste & "," & CInt(SoloLosChilds)
    End If
    
    If Not gDB.Execute(sqlstmt, "Paste", C_Module, c_ErrorSave) Then Exit Function
    
    Paste = True
    If IsCut Then Remove IdToCopy
End Function

Public Function Cut(ByVal Id As Long)

End Function

Public Function IsChildOf(ByVal Hijo As Long, ByVal Father As Long) As Boolean
    Dim o As Variant
    
    
    If Not ExistsObjectInColl(m_Coll, GetKey(Father)) Then Exit Function
    
    If Hijo = Father Then
        IsChildOf = True
        Exit Function
    End If
    
    LoadChilds Father
    
    For Each o In Item(Father).Childs
    
        If IsChildOf(Hijo, o) Then
            IsChildOf = True
            Exit Function
        End If
    Next
End Function

' funciones privadas
Private Function Add(ByVal c As cBranch, Optional Key As Variant) As cBranch
    On Error GoTo ControlError

    If c Is Nothing Then Set c = New cBranch

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

Private Function HaveChilds(ByVal Id As Long, ByRef HijoId As Long) As Boolean
    Dim o As cBranch

    ' si m_NestedLevel es mayor a la cantidad de elementos en la coleccion, entonces
    ' estoy ante una referencia ciruclar
    If m_NestedLevel > m_Coll.Count Then Exit Function

    For Each o In m_Coll
        If o.Father = Id Then
            HijoId = o.Id
            HaveChilds = True
            Exit For
        End If
    Next
End Function

Public Sub LoadChilds(ByVal RamId As Long)
    Dim o As cBranch
    
    Item(RamId).Clear
    
    For Each o In m_Coll
        If o.Father = RamId Then
            Item(RamId).AddChild o.Id
        End If
    Next
    
    Item(RamId).ChildsLoaded = True
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  Set m_Coll = New Collection
  m_NextIdOfCopy = 0
  m_NestedLevel = 0
    
  c_ErrorSave = LNGGetText(3435, vbNullString) 'Error al editar Ramas
End Sub

Private Sub Class_Terminate()
    CollClear m_Coll
    Set m_Coll = Nothing
End Sub
