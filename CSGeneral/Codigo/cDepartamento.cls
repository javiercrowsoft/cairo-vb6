VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDepartamento"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cDepartamento
' 06-06-03

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cDepartamento"

Private Const c_Items = "Items"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_ACTIVO                         As Integer = 4
Private Const K_DPTO_ID_PADRE                  As Integer = 5
Private Const K_EMP_ID                         As Integer = 6

Private Const K_USUARIO                        As Integer = 20

Private Const KI_USDPTO_ID   As Integer = 1
Private Const KI_US_ID       As Integer = 3

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_descrip                      As String
Private m_Activo                       As Boolean
Private m_emp_id                       As Long
Private m_empresa                      As String
Private m_dpto_id_padre                As Long
Private m_Departamento                 As String

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

Private m_ItemsDeletedUsuario   As String

' Properties publicas
Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property
' Properties privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscDptoCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscDptoNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscDptoCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscDptoNombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  cIEditGeneric_Edit csNO_ID
End Function

Private Property Get cIABMClient_Aplication() As String
    cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
  cIABMClient_CanAddDocDigital = m_Id <> csNO_ID
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
  cIABMClient_CanCopy = True
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = True
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
  On Error GoTo ControlError
  
  If m_Id = csNO_ID Then Exit Function
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = csTDepartamento
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, C_ShowDocDigital, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  Select Case MessageID
  
    Case MSG_DOC_INFO
    
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      
      CSKernelClient2.ShowHelp AbmGen.hWnd, _
                               vbNullString, _
                               vbNullString, _
                               csPreGNewDepartamento
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    Case Else
      cIABMClient_MessageEx = True
  End Select
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim register   As cRegister
  Dim fields     As cFields
  Dim LastId     As Long
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscDptoId
    .Table = csTDepartamento
  
    If m_Copy Then
      .Id = csNew
    Else
      .Id = m_Id
    End If
  End With
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          fields.Add2 cscDptoNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscDptoCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscDptoDescrip, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
        Case K_DPTO_ID_PADRE
          fields.Add2 cscDptoIdPadre, .HelpId, csId
        Case K_EMP_ID
          fields.Add2 cscEmpId, .HelpId, csId
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.SaveEx(register, , _
                    cscDptoCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.Id
  
  If Not pSaveItemsUsuario() Then GoTo SaveError
  If Not pSavePrestacion(m_Id) Then GoTo SaveError
  If Not pSavePermisos(m_Id) Then GoTo SaveError
  
  If Not register.CommitTrans() Then GoTo SaveError
  
  m_Copy = False
  cIABMClient_Save = Load(register.Id)

  Exit Function
SaveError:
  m_Id = LastId
End Function

Private Function cIABMClient_Terminate() As Boolean
    m_Editing = False
    
    cIABMClient_Terminate = True
    ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
    ' le doy bola
    On Error GoTo ControlError
    If m_Id = csNO_ID Then Exit Function
    If m_ObjTree Is Nothing Then Exit Function
    
    If m_IsNew Then
        m_ObjTree.AddLeave m_Id, m_BranchId, m_TreeId
    Else
        m_ObjTree.AddEditedId m_Id
        m_ObjTree.RefreshActiveBranch
    End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = LNGGetText(1128, vbNullString) 'Departamentos
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo C_DebeIndicarNombre
            Exit Function
          End If
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            .Value = c_get_codigo_from_id
          End If
        Case K_EMP_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1129, vbNullString) 'Debe indicar una empresa
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

'////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
' Grid
Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean

End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Select Case Key
  
    Case K_USUARIO
      Id = Val(pCell(Row, KI_USDPTO_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedUsuario = m_ItemsDeletedUsuario & Id & ","
    
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_USUARIO
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowUsuario(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_USUARIO
      cIABMClientGrid_ValidateRow = pValidateRowUsuario(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' Implementacion de cIEditGeneric
Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal rhs As Long)
    m_TreeId = rhs
End Property

Private Property Get cIEditGeneric_TreeId() As Long
    cIEditGeneric_TreeId = m_TreeId
End Property

Private Function cIEditGeneric_GridAdd(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListDepartamento)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreGDeleteDepartamento) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "sp_departamentoDelete " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewDepartamento) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditDepartamento) Then Exit Function
  End If

  m_ObjAbm.InModalWindow = InModalWindow

  If Not Load(Id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  m_Editing = True
  m_Copy = False

  If InModalWindow Then
    cIEditGeneric_Edit = m_Id <> csNO_ID
  Else
    cIEditGeneric_Edit = True
  End If

  Exit Function
ControlError:
  MngError Err, C_EditGenericEdit, C_Module, vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal Id As Long) As Boolean

End Function

Private Property Set cIEditGeneric_ObjTree(rhs As Object)
    Set m_ObjTree = rhs
End Property

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)
    m_BranchId = rhs
End Property

Private Property Get cIEditGeneric_BranchId() As Long
    cIEditGeneric_BranchId = m_BranchId
End Property

Private Function cIEditGeneric_Preview(ByVal Id As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
                          '&Departamentos                                       &Empresa
  m_Host.Server.AddMenu LNGGetText(1133, vbNullString), csPreGListDepartamento, LNGGetText(1134, vbNullString), 0, True, False, False, False, False, Me
  
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                      'Departamentos
  m_Host.MenuABMClick "CSGeneral2.cDepartamento", Me, LNGGetText(1128, vbNullString), 0, csETablasGeneral.csDepartamento
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  m_ObjAbm.Title2 = m_Nombre
  
  With m_ObjAbm.Tabs
    
    .Clear
    
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
      
    With .Add(Nothing)
      .Index = 1
      .Name = LNGGetText(1130, vbNullString) 'Usuarios
    End With
  
  End With
    
  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, cscDptoNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 50
      .Key = K_NOMBRE
      .Value = m_Nombre
      .Width = 5000
    End With
      
    With .Add(Nothing, cscDptoCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 10
      .Key = K_CODIGO
      .Value = m_Codigo
    End With
      
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
      
    With .Add(Nothing, cscDptoIdPadre)
      .PropertyType = cspHelp
      .Table = csDepartamento
      .Name = LNGGetText(1131, vbNullString) 'Departamento Padre
      .Key = K_DPTO_ID_PADRE
      .HelpId = m_dpto_id_padre
      .Value = m_Departamento
    End With
      
    With .Add(Nothing)
      .PropertyType = cspLabel
      .TopFromProperty = cscDptoIdPadre
      .Left = 4500
      .LeftNotChange = True
      .TopNotChange = True
      .Name = LNGGetText(1132, vbNullString) '(* Este departamento contiene al que estamos editando)
    End With
      
    With .Add(Nothing, cscEmpId)
      .PropertyType = cspHelp
      .Table = csEmpresa
      .Name = LNGGetText(1114, vbNullString) ' Empresa
      .Key = K_EMP_ID
      .HelpId = m_emp_id
      .Value = m_empresa
    End With
      
    With .Add(Nothing, cscDptoDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Height = 780
      .Width = 6000
      .Name = C_strDescrip
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_descrip
    End With
      
    Set c = .Add(Nothing, c_Items)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadUsuario(c) Then Exit Function
      .Name = LNGGetText(1130, vbNullString) 'Usuarios
      .Key = K_USUARIO
      .TabIndex = 1
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
      Set c = Nothing   '(ver que se hace con esto)
    End With
  
    m_ItemsDeletedUsuario = vbNullString
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As Recordset

  sqlstmt = "sp_DepartamentoGet " & Id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscDptoId)
    m_Nombre = gDB.ValField(rs.fields, cscDptoNombre)
    m_Codigo = gDB.ValField(rs.fields, cscDptoCodigo)
    m_descrip = gDB.ValField(rs.fields, cscDptoDescrip)
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_emp_id = gDB.ValField(rs.fields, cscEmpId)
    m_empresa = gDB.ValField(rs.fields, cscEmpNombre)
    m_dpto_id_padre = gDB.ValField(rs.fields, cscDptoIdPadre)
    m_Departamento = gDB.ValField(rs.fields, "NombrePadre")

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_descrip = vbNullString
    m_Activo = True
    m_emp_id = csNO_ID
    m_empresa = vbNullString
    m_dpto_id_padre = csNO_ID
    m_Departamento = vbNullString

  End If

  Load = True
End Function

Private Function pIsEmptyRowUsuario(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_US_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowUsuario = bRowIsEmpty
End Function

Private Function pValidateRowUsuario(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell          As cIABMGridCellValue
  Dim strRow        As String
  Dim bEmpty        As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_US_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bEmpty = False
        End If
    End Select
  Next
  
  If bEmpty Then
    MsgInfo LNGGetText(1135, vbNullString, strRow) 'Debe indicar un proveedor o un cliente"
    Exit Function
  End If
  
  pValidateRowUsuario = True
End Function

Private Function pSaveItemsUsuario() As Boolean
  Dim register As cRegister
  Dim fields   As cFields
        
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  For Each Row In m_ObjAbm.Properties(c_Items).Grid.Rows
  
    Set register = New cRegister
    
    With register
      Set fields = .fields
      .fieldId = cscUsdptoId
      .Table = csTUsuarioDepartamento
      .Id = csNew
      
      For Each Cell In Row
        Select Case Cell.Key
        
          Case KI_USDPTO_ID
            If Not m_Copy Then
              .Id = Val(Cell.Value)
            End If
          Case KI_US_ID
            fields.Add2 cscUsId, Cell.Id, csId
        End Select
      Next
      
      fields.Add2 cscDptoId, m_Id, csId
      
      fields.HaveLastUpdate = True
      fields.HaveWhoModify = True
    
    End With
  
    If Not gDB.Save(register, , "pSaveItemsUsuario", C_Module, c_ErrorSave) Then Exit Function
  Next
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedUsuario) And Not m_Copy Then
    m_ItemsDeletedUsuario = RemoveLastColon(m_ItemsDeletedUsuario)
    sqlstmt = "delete UsuarioDepartamento where usdpto_id in (" & m_ItemsDeletedUsuario & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsUsuario", C_Module) Then Exit Function
  End If
  
  pSaveItemsUsuario = True
End Function

Private Function pLoadUsuario(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select UsuarioDepartamento.*, us_nombre" & _
            " from UsuarioDepartamento, Usuario" & _
            " where dpto_id = " & m_Id & _
            " and UsuarioDepartamento.us_id = Usuario.us_id"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadUsuario", C_Module) Then Exit Function
  
  Const csCliente = 28
  Const csProveedor = 29
  
  With Propiedad.Grid
  
    With .Columns
  
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_USDPTO_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1137, vbNullString) 'Usuario
        .PropertyType = cspHelp
        .Table = csUsuario
        .Width = 3000
        .Key = KI_US_ID
      End With
    
    End With
    
    With .Rows
    
      .Clear
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscUsdptoId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscUsdptoId).Value
            .Key = KI_USDPTO_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscUsNombre)
            .Id = gDB.ValField(rs.fields, cscUsId)
            .Key = KI_US_ID
          End With
        
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadUsuario = True
End Function

' Prestaciones de un Departamento
Public Function pSavePrestacion(ByVal Id As Long) As Boolean
  Dim sqlstmt As String
  sqlstmt = "sp_DepartamentoSavePrestacion " & Id
  pSavePrestacion = gDB.Execute(sqlstmt)
End Function

Private Function pSavePermisos(ByVal Id As Long) As Boolean
  Dim sqlstmt   As String
  Dim response  As VbMsgBoxResult
  
  response = MsgBox(Replace(LNGGetText(1138, vbNullString), _
                            ";", vbCrLf), _
                    vbYesNoCancel)
                    
  If response = vbCancel Then
    pSavePermisos = True
  Else
    sqlstmt = "sp_DepartamentoUpdate " & Id & "," & Abs(response = vbYes)
    pSavePermisos = gDB.Execute(sqlstmt)
  End If
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error Resume Next
  c_ErrorSave = LNGGetText(1136, vbNullString) ' Error al grabar el Departamento
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub
