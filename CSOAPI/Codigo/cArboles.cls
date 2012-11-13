VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTrees"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cTrees
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
Private Const C_Module = "cTrees"
' estructuras
' variables privadas
Private m_Coll                As Collection
Private m_IsLoaded            As Boolean
Private m_SpGetArboles        As String
' Properties publicas
Public Property Get IsLoaded() As Boolean
  IsLoaded = m_IsLoaded
End Property
Public Property Let IsLoaded(ByVal rhs As Boolean)
  m_IsLoaded = rhs
End Property
Public Property Let SpGetArboles(ByVal rhs As String)
  m_SpGetArboles = rhs
End Property
' Properties privadas
' funciones publicas
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
Public Function Item(ByVal kItem As Variant) As cTree
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

Public Function Load(ByVal TableId As Long) As Boolean
  Dim sqlstmt As String
  Dim rsTrees As ADODB.Recordset
  Dim Tree As cTree
  
  If Not m_IsLoaded Then
    Clear
    
    sqlstmt = m_SpGetArboles & " " & TableId
                                                                        'Error al cargar los árboles
    If Not gDB.OpenRs(sqlstmt, rsTrees, , , , "cTrees.Load", C_Module, LNGGetText(3457, vbNullString)) Then Exit Function
    
    While Not rsTrees.EOF
      Set Tree = Add(Tree, gDB.ValField(rsTrees.Fields, cscArbId))
      Tree.Id = gDB.ValField(rsTrees.Fields, cscArbId)
      Tree.Name = gDB.ValField(rsTrees.Fields, cscArbNombre)
      Tree.Root = gDB.ValField(rsTrees.Fields, cscRamId)
      
      Set Tree = Nothing
      
      rsTrees.MoveNext
    Wend
  End If
  m_IsLoaded = True
  Load = True
End Function

Public Function Add2(ByVal Name As String, ByVal TableId As Long, ByRef TreeId As Long) As Boolean
  Dim register As cRegister
  Set register = New cRegister
  
  gDB.BeginTransaction
  
  ' Primero el Tree
  register.FieldId = cscArbId
  register.Table = csTArbol
  register.Id = csNO_ID
  
  register.Fields.Add2 cscArbNombre, Name, csText
  register.Fields.Add2 cscModifico, gUser.Id, csId
  register.Fields.Add2 cscTblId, TableId, csId
  
                                                        'Error al agregar el árbol
  If Not gDB.Save(register, False, "Agregar", C_Module, LNGGetText(3455, vbNullString)) Then GoTo RollBack
  
  ' Ahora la rama
  
  TreeId = register.Id
  Set register = Nothing
  Set register = New cRegister
  
  register.FieldId = cscRamId
  register.Table = csTRama
  register.Id = csNO_ID
  
  register.Fields.Add2 cscRamNombre, Name, csText
  register.Fields.Add2 cscModifico, gUser.Id, csId
  register.Fields.Add2 cscRamPadre, 0, csInteger
  register.Fields.Add2 cscArbId, TreeId, csId
                                                        'Error al agregar la raiz del árbol
  If Not gDB.Save(register, False, "Agregar", C_Module, LNGGetText(3456, vbNullString)) Then GoTo RollBack
  
  gDB.CommitTransaction
  
  ' Ahora lo agrego a la coleccion
  Dim Tree As cTree
  Set Tree = Add(Tree, TreeId)
  Tree.Id = TreeId
  Tree.Name = Name
  Tree.Root = register.Id
  
  ' Cargo las ramas
  Tree.Load
  
  Set Tree = Nothing
  
  Add2 = True
  Exit Function
RollBack:
  gDB.RollBackTransaction
End Function

Public Function Delete(ByVal Id As Long) As Boolean
  Dim sqlstmt   As String
  Dim str_3454  As String
  
  str_3454 = LNGGetText(3454, vbNullString) 'Error al borrar el árbol
  
  If Id = cTreePrincipal Then
    CSKernelClient2.MsgWarning LNGGetText(3453, vbNullString), LNGGetText(2581, vbNullString)
                                'Este árbol no se puede borrar, Configuración
    Exit Function
  End If
  
  gDB.BeginTransaction
    
  sqlstmt = "delete hoja where Arb_Id = " & Id
  If Not gDB.Execute(sqlstmt, "Delete", C_Module, str_3454) Then GoTo RollBack
  
  sqlstmt = "delete Rama where Arb_Id = " & Id
  If Not gDB.Execute(sqlstmt, "Delete", C_Module, str_3454) Then GoTo RollBack
  
  sqlstmt = "delete arbol where Arb_Id = " & Id
  If Not gDB.Execute(sqlstmt, "Delete", C_Module, str_3454) Then GoTo RollBack
  
  Remove Id
  
  gDB.CommitTransaction
  
  Delete = True
  Exit Function
RollBack:
  gDB.RollBackTransaction
End Function

Public Sub Copy(ByVal Id As Long)

End Sub

Public Function Paste(ByVal IdToCopy As Long, ByVal IdToPaste As Long)

End Function

Public Function Cut(ByVal Id As Long)

End Function
' funciones privadas
Private Function Add(ByVal c As cTree, Optional Key As Variant) As cTree
  On Error GoTo ControlError

  If c Is Nothing Then Set c = New cTree

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

Private Sub Class_Initialize()
  Set m_Coll = New Collection
  m_SpGetArboles = "SP_ArbGetArboles"
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  CollClear m_Coll
  Set m_Coll = Nothing
End Sub
