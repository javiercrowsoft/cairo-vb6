VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDocumentoPermiso"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cDocumentoPermiso
' 29-05-03

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cDocumentoPermiso"

Private Const c_Rols = "Rols"
Private Const c_Users = "Users"

Private Const csTPermiso  As String = "Permiso"
Private Const cscPerId    As String = "per_id"

Private Const c_SecRol = "ROL:"
Private Const c_SecUser = "USER:"

Private Const K_NOMBRE                  As Integer = 1
Private Const K_ROLS                    As Integer = 2
Private Const K_USERS                   As Integer = 3

Private Const KI_AUX                    As Integer = 1
Private Const KI_ROL_ID                 As Integer = 2
Private Const KI_US_ID                  As Integer = KI_ROL_ID

Private Const KI_NEW                    As Integer = 5
Private Const KI_EDIT                   As Integer = 6
Private Const KI_DELETE                 As Integer = 7
Private Const KI_LIST                   As Integer = 8
Private Const KI_ANULAR                 As Integer = 9
Private Const KI_DESANULAR              As Integer = 10
Private Const KI_APLICAR                As Integer = 11
Private Const KI_PRINT                  As Integer = 12

' Seudo - Variables
Private c_ErrorSave         As String

' estructuras
' variables privadas
Private m_doc_id                       As Long
Private m_doc_nombre                   As String

Private m_pre_id_new                   As String
Private m_pre_id_edit                  As String
Private m_pre_id_delete                As String
Private m_pre_id_list                  As String
Private m_pre_id_anular                As String
Private m_pre_id_desanular             As String
Private m_pre_id_aplicar               As String
Private m_pre_id_print                 As String

Private m_ItemsDeletedRol              As String
Private m_ItemsDeletedUser             As String

Private m_vUsers()    As Long
Private m_vRols()     As Long

Private m_ObjAbm            As cIABMGeneric

' Properties privadas
' funciones publicas

Public Function Edit(ByVal doc_id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If doc_id = csNO_ID Then
    Exit Function
  Else
    If Not SecurityCanAccess(csPreOListPermiso) Then Exit Function
  End If

  Set m_ObjAbm = New CSABMInterface2.cABMGeneric

  m_ObjAbm.InModalWindow = InModalWindow
  
  If Not Load(doc_id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  Edit = True
  
  Exit Function
ControlError:
  MngError Err, "Edit", "cDocumentoPermiso", vbNullString
End Function

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
End Function

Private Function cIABMClient_EditNew() As Boolean
End Function

Private Property Get cIABMClient_Aplication() As String
  cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
  cIABMClient_CanAddDocDigital = False
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
  cIABMClient_CanCopy = False
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = False
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
  cIABMClient_ShowDocDigital = False
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  cIABMClient_PropertyChange = True
End Function

Private Function cIABMClient_Save() As Boolean
  
  ReDim m_vUsers(0)
  ReDim m_vRols(0)

  If Not pSaveRols() Then Exit Function
  If Not pSaveUsers() Then Exit Function
  
  pNotifySecurity
  cIABMClient_Save = Load(m_doc_id)
End Function

Private Function cIABMClient_Terminate() As Boolean
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2612, vbNullString) 'Permisos del Documento
End Property

Private Function cIABMClient_Validate() As Boolean
  cIABMClient_Validate = True
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnButtonClick = True
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
  
    Case K_ROLS
      Id = pCell(Row, KI_ROL_ID).Id
      If Id <> csNO_ID Then m_ItemsDeletedRol = m_ItemsDeletedRol & Id & ","
  
    Case K_USERS
      Id = pCell(Row, KI_US_ID).Id
      If Id <> csNO_ID Then m_ItemsDeletedUser = m_ItemsDeletedUser & Id & ","
  
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ROLS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowRol(Row, RowIndex)
    Case K_USERS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowUser(Row, RowIndex)
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
    Case K_ROLS
      cIABMClientGrid_ValidateRow = pValidateRowRol(Row, RowIndex)
    Case K_USERS
      cIABMClientGrid_ValidateRow = pValidateRowUser(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  
  With m_ObjAbm
    With .Tabs
      .Clear
      With .Add(Nothing)
        .Name = LNGGetText(2613, vbNullString) 'Roles
      End With
      With .Add(Nothing)
        .Name = LNGGetText(1130, vbNullString) 'Usuarios
        .Index = 1
      End With
    End With
    
    .Title2 = m_doc_nombre
  End With

  With m_ObjAbm.Properties
  
    .Clear
    
    With .Add(Nothing)
      .PropertyType = cspLabel
      .Name = LNGGetText(1567, vbNullString) 'Documento
      .Value = m_doc_nombre
      .Width = 8000
      .Left = 200
      .FontBold = True
    End With
    
    Set c = .Add(Nothing, c_Rols)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadRols(c) Then Exit Function
      .Name = LNGGetText(2613, vbNullString) 'Roles
      .Key = K_ROLS
      .Top = 1400
      .Left = 200
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_ItemsDeletedRol = vbNullString
    
    With .Add(Nothing)
      .PropertyType = cspLabel
      .Name = LNGGetText(1567, vbNullString) 'Documento
      .Value = m_doc_nombre
      .Width = 8000
      .Left = 200
      .FontBold = True
      .TabIndex = 1
    End With
    
    Set c = .Add(Nothing, c_Users)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadUsers(c) Then Exit Function
      .Name = LNGGetText(1130, vbNullString) 'Usuarios
      .Key = K_USERS
      .Top = 1400
      .Left = 200
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
      .TabIndex = 1
    End With
    
    m_ItemsDeletedUser = vbNullString
    
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "select doc_nombre, pre_id_new, pre_id_edit, pre_id_delete, pre_id_list, pre_id_anular, pre_id_desanular, pre_id_aplicar, pre_id_print from Documento where doc_id = " & Id
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_doc_id = Id
    m_doc_nombre = gDB.ValField(rs.fields, cscDocNombre)
    m_pre_id_new = gDB.ValField(rs.fields, "pre_id_new")
    m_pre_id_edit = gDB.ValField(rs.fields, "pre_id_edit")
    m_pre_id_delete = gDB.ValField(rs.fields, "pre_id_delete")
    m_pre_id_list = gDB.ValField(rs.fields, "pre_id_list")
    m_pre_id_anular = gDB.ValField(rs.fields, "pre_id_anular")
    m_pre_id_desanular = gDB.ValField(rs.fields, "pre_id_desanular")
    m_pre_id_aplicar = gDB.ValField(rs.fields, "pre_id_aplicar")
    m_pre_id_print = gDB.ValField(rs.fields, "pre_id_print")

  Else
  
    Exit Function
    
  End If

  Load = True
End Function

Private Function pLoadUsers(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_DocumentoPermisosGet " & m_doc_id & ",0" ' Usuarios
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadUsers", C_Module) Then Exit Function
    
  With Propiedad.Grid
    
    With .Columns
      .Clear
  
      With .Add(Nothing)
        .Key = KI_AUX
        .Visible = False
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1137, vbNullString) 'Usuario
        .PropertyType = cspHelp
        .Table = csUsuario
        .Width = 2000
        .Key = KI_US_ID
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(2614, vbNullString) 'Agregar
        .PropertyType = cspCheck
        .Width = 1000
        .Key = KI_NEW
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(2615, vbNullString) 'Editar
        .PropertyType = cspCheck
        .Width = 1000
        .Key = KI_EDIT
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1983, vbNullString) 'Borrar
        .PropertyType = cspCheck
        .Width = 1000
        .Key = KI_DELETE
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(2616, vbNullString) 'Listar
        .PropertyType = cspCheck
        .Width = 1000
        .Key = KI_LIST
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(2617, vbNullString) 'Anular
        .PropertyType = cspCheck
        .Width = 1000
        .Key = KI_ANULAR
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(2618, vbNullString) 'Des-anular
        .PropertyType = cspCheck
        .Width = 1000
        .Key = KI_DESANULAR
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1662, vbNullString) 'Aplicar
        .PropertyType = cspCheck
        .Width = 1000
        .Key = KI_APLICAR
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1853, vbNullString) 'Imprimir
        .PropertyType = cspCheck
        .Width = 1000
        .Key = KI_PRINT
      End With
    
    End With
  
    With .Rows
      
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing)
        
          With .Add(Nothing)
            .Value = 0
            .Key = KI_AUX
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscUsNombre)
            .Id = gDB.ValField(rs.fields, cscUsId)
            .Key = KI_US_ID
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, "per_id_new")
            .Key = KI_NEW
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, "per_id_edit")
            .Key = KI_EDIT
          End With

          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, "per_id_delete")
            .Key = KI_DELETE
          End With

          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, "per_id_list")
            .Key = KI_LIST
          End With

          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, "per_id_anular")
            .Key = KI_ANULAR
          End With

          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, "per_id_desanular")
            .Key = KI_DESANULAR
          End With

          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, "per_id_aplicar")
            .Key = KI_APLICAR
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, "per_id_print")
            .Key = KI_PRINT
          End With
          
        End With
        
        rs.MoveNext
      Wend
    
    End With
    
  End With
  
  pLoadUsers = True
End Function

Private Function pLoadRols(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_DocumentoPermisosGet " & m_doc_id & ", 1" ' Roles
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadRols", C_Module) Then Exit Function
    
  With Propiedad.Grid
    
    With .Columns
      .Clear
  
      With .Add(Nothing)
        .Key = KI_AUX
        .Visible = False
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(2619, vbNullString) 'Rol
        .PropertyType = cspHelp
        .Table = csRol
        .Width = 2000
        .Key = KI_ROL_ID
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(2614, vbNullString) 'Agregar
        .PropertyType = cspCheck
        .Width = 1000
        .Key = KI_NEW
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(2615, vbNullString) 'Editar
        .PropertyType = cspCheck
        .Width = 1000
        .Key = KI_EDIT
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1983, vbNullString) 'Borrar
        .PropertyType = cspCheck
        .Width = 1000
        .Key = KI_DELETE
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(2616, vbNullString) 'Listar
        .PropertyType = cspCheck
        .Width = 1000
        .Key = KI_LIST
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(2617, vbNullString) 'Anular
        .PropertyType = cspCheck
        .Width = 1000
        .Key = KI_ANULAR
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(2618, vbNullString) 'Des-anular
        .PropertyType = cspCheck
        .Width = 1000
        .Key = KI_DESANULAR
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1662, vbNullString) 'Aplicar
        .PropertyType = cspCheck
        .Width = 1000
        .Key = KI_APLICAR
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1853, vbNullString) 'Imprimir
        .PropertyType = cspCheck
        .Width = 1000
        .Key = KI_PRINT
      End With
    
    End With
  
    With .Rows
      
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing)
        
          With .Add(Nothing)
            .Value = 0
            .Key = KI_AUX
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRolNombre)
            .Id = gDB.ValField(rs.fields, cscRolId)
            .Key = KI_ROL_ID
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, "per_id_new")
            .Key = KI_NEW
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, "per_id_edit")
            .Key = KI_EDIT
          End With

          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, "per_id_delete")
            .Key = KI_DELETE
          End With

          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, "per_id_list")
            .Key = KI_LIST
          End With

          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, "per_id_anular")
            .Key = KI_ANULAR
          End With

          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, "per_id_desanular")
            .Key = KI_DESANULAR
          End With

          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, "per_id_aplicar")
            .Key = KI_APLICAR
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, "per_id_print")
            .Key = KI_PRINT
          End With
          
        End With
        
        rs.MoveNext
      Wend
    
    End With
    
  End With
  
  pLoadRols = True
End Function

Private Function pIsEmptyRowUser(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                 ByVal RowIndex As Long) As Boolean
                                
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_US_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowUser = bRowIsEmpty
End Function

Private Function pIsEmptyRowRol(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                ByVal RowIndex As Long) As Boolean
                                
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_ROL_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowRol = bRowIsEmpty
End Function

Private Function pValidateRowUser(Row As CSInterfacesABM.cIABMGridRow, _
                                  ByVal RowIndex As Long) As Boolean
                                 
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  CSKernelClient2.Title = LNGGetText(2620, vbNullString) 'Permisos
  
  For Each Cell In Row
    Select Case Cell.Key
        Case KI_US_ID
          If ValEmpty(Cell.Id, csId) Then
            MsgInfo LNGGetText(1153, vbNullString, strRow) 'Debe indicar un usuario (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowUser = True
End Function

Private Function pValidateRowRol(Row As CSInterfacesABM.cIABMGridRow, _
                                 ByVal RowIndex As Long) As Boolean
                                 
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  CSKernelClient2.Title = LNGGetText(2620, vbNullString) 'Permisos
  
  For Each Cell In Row
    Select Case Cell.Key
        Case KI_ROL_ID
          If ValEmpty(Cell.Id, csId) Then
            MsgInfo LNGGetText(2621, vbNullString, strRow) 'Debe indicar un rol (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowRol = True
End Function

Private Function pSaveUsers() As Boolean
  Dim Row       As cIABMGridRow
  Dim register  As cRegister
  Dim us_id     As Long
  Dim sqlstmt   As String
  Dim i         As Long
  
  With m_ObjAbm.Properties.Item(c_Users).Grid
  
    ReDim m_vUsers(.Rows.Count)
  
    For Each Row In .Rows
      
      Set register = New cRegister
      
      With register
        .fieldId = cscPerId
        .Table = csTPermiso
        
        us_id = pCell(Row, KI_US_ID).Id
        i = i + 1
        m_vUsers(i) = us_id
        
        If Not register.BeginTrans(gDB) Then Exit Function
        
        ' La hago facil, borro todos los permisos y creo nuevos
        '
        sqlstmt = "sp_DocumentoPermisoDelete " & m_doc_id & "," & gDB.sqlString(us_id) & ",0" ' Usuario
      
        If Not gDB.Execute(sqlstmt, "pSaveUsers", C_Module) Then Exit Function
          
        If Not pSaveUsersPermiso(register, _
                                .fields, _
                                Row, _
                                us_id, _
                                KI_NEW, _
                                m_pre_id_new) Then Exit Function
        
        If Not pSaveUsersPermiso(register, _
                                .fields, _
                                Row, _
                                us_id, _
                                KI_EDIT, _
                                m_pre_id_edit) Then Exit Function
        
        If Not pSaveUsersPermiso(register, _
                                .fields, _
                                Row, _
                                us_id, _
                                KI_DELETE, _
                                m_pre_id_delete) Then Exit Function
        
        If Not pSaveUsersPermiso(register, _
                                .fields, _
                                Row, _
                                us_id, _
                                KI_LIST, _
                                m_pre_id_list) Then Exit Function
        
        If Not pSaveUsersPermiso(register, _
                                .fields, _
                                Row, _
                                us_id, _
                                KI_ANULAR, _
                                m_pre_id_anular) Then Exit Function
        
        If Not pSaveUsersPermiso(register, _
                                .fields, _
                                Row, _
                                us_id, _
                                KI_DESANULAR, _
                                m_pre_id_desanular) Then Exit Function
        
        If Not pSaveUsersPermiso(register, _
                                .fields, _
                                Row, _
                                us_id, _
                                KI_APLICAR, _
                                m_pre_id_aplicar) Then Exit Function
        
        If Not pSaveUsersPermiso(register, _
                                .fields, _
                                Row, _
                                us_id, _
                                KI_PRINT, _
                                m_pre_id_print) Then Exit Function
        
        If Not register.CommitTrans() Then Exit Function
        
      End With
      
    Next
  
  End With
  
  If LenB(m_ItemsDeletedUser) Then
    m_ItemsDeletedUser = RemoveLastColon(m_ItemsDeletedUser)
    sqlstmt = "sp_DocumentoPermisoDelete " & m_doc_id & "," & gDB.sqlString(m_ItemsDeletedUser) & ",0"  ' Usuario
  
    If Not gDB.Execute(sqlstmt, "pSaveUsers", C_Module) Then Exit Function
  End If
  
  pSaveUsers = True
End Function

Private Function pSaveRols() As Boolean
  Dim Row       As cIABMGridRow
  Dim register  As cRegister
  Dim rol_id    As Long
  Dim sqlstmt   As String
  Dim i         As Long
  
  With m_ObjAbm.Properties.Item(c_Rols).Grid
  
    ReDim m_vRols(.Rows.Count)
  
    For Each Row In .Rows
      
      Set register = New cRegister
      
      With register
        .fieldId = cscPerId
        .Table = csTPermiso
        
        rol_id = pCell(Row, KI_ROL_ID).Id
        i = i + 1
        m_vRols(i) = rol_id
        
        If Not register.BeginTrans(gDB) Then Exit Function
        
        ' La hago facil, borro todos los permisos y creo nuevos
        '
        sqlstmt = "sp_DocumentoPermisoDelete " & m_doc_id & "," & gDB.sqlString(rol_id) & ",1" ' Rol
      
        If Not gDB.Execute(sqlstmt, "pSaveRols", C_Module) Then Exit Function
          
        If Not pSaveRolsPermiso(register, _
                                .fields, _
                                Row, _
                                rol_id, _
                                KI_NEW, _
                                m_pre_id_new) Then Exit Function
        
        If Not pSaveRolsPermiso(register, _
                                .fields, _
                                Row, _
                                rol_id, _
                                KI_EDIT, _
                                m_pre_id_edit) Then Exit Function
        
        If Not pSaveRolsPermiso(register, _
                                .fields, _
                                Row, _
                                rol_id, _
                                KI_DELETE, _
                                m_pre_id_delete) Then Exit Function
        
        If Not pSaveRolsPermiso(register, _
                                .fields, _
                                Row, _
                                rol_id, _
                                KI_LIST, _
                                m_pre_id_list) Then Exit Function
        
        If Not pSaveRolsPermiso(register, _
                                .fields, _
                                Row, _
                                rol_id, _
                                KI_ANULAR, _
                                m_pre_id_anular) Then Exit Function
        
        If Not pSaveRolsPermiso(register, _
                                .fields, _
                                Row, _
                                rol_id, _
                                KI_DESANULAR, _
                                m_pre_id_desanular) Then Exit Function
        
        If Not pSaveRolsPermiso(register, _
                                .fields, _
                                Row, _
                                rol_id, _
                                KI_APLICAR, _
                                m_pre_id_aplicar) Then Exit Function
        
        If Not pSaveRolsPermiso(register, _
                                .fields, _
                                Row, _
                                rol_id, _
                                KI_PRINT, _
                                m_pre_id_print) Then Exit Function
        
        If Not register.CommitTrans() Then Exit Function
        
      End With
      
    Next
  
  End With
  
  If LenB(m_ItemsDeletedRol) Then
    m_ItemsDeletedRol = RemoveLastColon(m_ItemsDeletedRol)
    sqlstmt = "sp_DocumentoPermisoDelete " & m_doc_id & "," & gDB.sqlString(m_ItemsDeletedRol) & ",1"  ' Rol
  
    If Not gDB.Execute(sqlstmt, "pSaveRols", C_Module) Then Exit Function
  End If
  
  pSaveRols = True
End Function

Private Function pSaveRolsPermiso(ByRef register As CSDataBaseClient2.cRegister, _
                                  ByRef fields As CSDataBaseClient2.cFields, _
                                  ByRef Row As cIABMGridRow, _
                                  ByVal rol_id As Long, _
                                  ByVal KI_PER_ID As Long, _
                                  ByVal pre_id As Long) As Boolean
  Dim per_id As Long
  per_id = pCell(Row, KI_PER_ID).Id
  
  If per_id <> csNO_ID Then
  
    With fields
      .Clear
      .Add2 cscRolId, rol_id, csId
      .Add2 cscPreID, pre_id, csId
      
      .HaveWhoModify = True
    End With
    
    register.Id = csNew
  
    If Not gDB.Save(register, , _
                    "pSaveRolsPermiso", _
                    C_Module, c_ErrorSave) Then Exit Function
  End If
  
  pSaveRolsPermiso = True
End Function

Private Function pSaveUsersPermiso(ByRef register As CSDataBaseClient2.cRegister, _
                                   ByRef fields As CSDataBaseClient2.cFields, _
                                   ByRef Row As cIABMGridRow, _
                                   ByVal us_id As Long, _
                                   ByVal KI_PER_ID As Long, _
                                   ByVal pre_id As Long) As Boolean
  Dim per_id As Long
  per_id = pCell(Row, KI_PER_ID).Id
  
  If per_id <> csNO_ID Then
  
    With fields
      .Clear
      .Add2 cscUsId, us_id, csId
      .Add2 cscPreID, pre_id, csId
      
      .HaveWhoModify = True
    End With
    
    register.Id = csNew
  
    If Not gDB.Save(register, , _
                    "pSaveUsersPermiso", _
                    C_Module, c_ErrorSave) Then Exit Function
  End If
  
  pSaveUsersPermiso = True
End Function

Private Sub pNotifySecurity()
  Dim Buffer  As String
  Dim sqlstmt As String
  
  ' Si no hay conexion me voy
  If CSOAPI2.TCPClient Is Nothing Then Exit Sub
  
  Dim i     As Long
  
  For i = 1 To UBound(m_vUsers)
    
    sqlstmt = "sp_SysModuloRolGetEx " & m_vUsers(i)
    
    gDB.Execute sqlstmt
    
    Buffer = c_SecRol & Format(0, "00000000") & ":" & c_SecUser & Format(m_vUsers(i), "00000000")
    Buffer = TCPSecurityGetMessage(cTCPSecCommandRefresh, ClientProcessId, Buffer)
    CSOAPI2.TCPClient.SendText Buffer, SRV_ID_SERVER
  Next

  For i = 1 To UBound(m_vRols)
    
    sqlstmt = "sp_SysModuloGetEx " & m_vRols(i)
    
    gDB.Execute sqlstmt
    
    Buffer = c_SecRol & Format(m_vRols(i), "00000000") & ":" & c_SecUser & Format(0, "00000000")
    Buffer = TCPSecurityGetMessage(cTCPSecCommandRefresh, ClientProcessId, Buffer)
    CSOAPI2.TCPClient.SendText Buffer, SRV_ID_SERVER
  Next
End Sub

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2611, vbNullString)  'Error al grabar Documento
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  Set m_ObjAbm = Nothing
  ReDim m_vUsers(0)
  ReDim m_vRols(0)
End Sub
