VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTipoOperacion"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cTipoOperacion
' 14-02-01

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cTipoOperacion"

Private Const c_cuentagrupo = "CuentaGrupo"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 4
Private Const K_ACTIVO                         As Integer = 5
Private Const K_GENERADEUDA                    As Integer = 6
Private Const K_CUENTAGRUPO                    As Integer = 7

Private Const KI_CUEG_ID                        As Integer = 2
Private Const KI_TOCUEG_ID                      As Integer = 3
Private Const KI_CUE_ID                         As Integer = 4

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id               As Long
Private m_Nombre           As String
Private m_Codigo           As String
Private m_descrip          As String
Private m_GeneraDeuda      As Boolean
Private m_Activo           As Boolean

Private m_Editing      As Boolean

Private m_ObjAbm       As cIABMGeneric
Private m_ObjTree      As Object

Private m_IsNew        As Boolean

Private m_BranchId      As Long
Private m_TreeId        As Long

Private m_Host        As cIMenuHost
Private m_Copy        As Boolean

Private m_ItemsDeletedCuentaGrupo           As String

' propiedades publicas

Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property

' propiedades privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscToCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscToNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscToCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscToNombre)
  
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

  Doc.ClientTable = csTTipoOperacion
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
                               csPreGNewTipoOperacion
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    Case Else
      cIABMClient_MessageEx = True
  End Select
End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(Lista As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim LastId   As Long
  Dim register As cRegister
  Dim fields   As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscToId
    .Table = csTTipoOperacion
  
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
          fields.Add2 cscToNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscToCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscToDescrip, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
        Case K_GENERADEUDA
          fields.Add2 cscToGeneradeuda, .Value, csBoolean
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
                                                        
  If Not gDB.SaveEx(register, , _
                    cscToCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.Id
   
  If Not pSaveItemsCuentaGrupo() Then GoTo SaveError
    
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
  cIABMClient_Title = LNGGetText(1492, vbNullString)    'Tipos de Operación
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty     As cIABMProperty
  Dim CreditoCC     As Double
  Dim CreditoTotal  As Double

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
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_CUENTAGRUPO
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowCuentaGrupo(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' Implementacion de cIEditGeneric
Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreGListTipoOperacion)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  If Not SecurityCanAccess(csPreGDeleteTipoOperacion) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "sp_TipoOperacionDelete " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewTipoOperacion) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditTipoOperacion) Then Exit Function
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

Private Function cIEditGeneric_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)
  m_BranchId = rhs
End Property

Private Property Get cIEditGeneric_BranchId() As Long
  cIEditGeneric_BranchId = m_BranchId
End Property

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Function cIEditGeneric_Preview(ByVal Id As Long) As Boolean

End Function

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
  
  m_Host.Server.AddMenu C_MenuVentas, csMenuConfigVentas, C_MenuConfig, 0, True, False, False, False, True, Nothing
                          '&Tipo de Operación
  m_Host.Server.AddMenu LNGGetText(1493, vbNullString), csPreGListTipoOperacion, C_MenuVentas, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                        'Tipos de Operacion
  m_Host.MenuABMClick "CSGeneral2.cTipoOperacion", Me, LNGGetText(1492, vbNullString), 0, csETablasGeneral.csTipoOperacion
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Select Case Key
    Case K_CUENTAGRUPO
      Id = Val(pCell(Row, KI_TOCUEG_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedCuentaGrupo = m_ItemsDeletedCuentaGrupo & Id & C_StrColon
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_CUENTAGRUPO
      cIABMClientGrid_ValidateRow = pValidateRowCuentaGrupo(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pValidateRowCuentaGrupo(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
        Case KI_CUEG_ID
          If ValEmpty(Cell.Id, csId) Then
            MsgInfo LNGGetText(1387, vbNullString, strRow)
                    'Debe indicar un grupo de cuentas (1)
            Exit Function
          End If
        Case KI_CUE_ID
          If ValEmpty(Cell.Id, csId) Then
            MsgInfo LNGGetText(1388, vbNullString, strRow)
                    'Debe indicar una cuenta (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowCuentaGrupo = True
End Function

' funciones privadas
Private Function LoadCollection() As Boolean

  Dim c As cIABMProperty
  
  Const c_tab_general = 0
  Const c_tab_cuentagrupo = 1
  
  With m_ObjAbm.Tabs
    .Clear
    
    With .Add(Nothing)
      .Index = c_tab_general
      .Name = C_strGeneral
    End With
      
    With .Add(Nothing)
      .Index = c_tab_cuentagrupo
      .Name = LNGGetText(1391, vbNullString)   'Grupos de ctas
    End With
  End With
  
  m_ObjAbm.Title2 = m_Nombre
  With m_ObjAbm.Properties
    
    .Clear
     
    With .Add(Nothing, cscToNombre)
       .PropertyType = cspText
       .Name = C_strNombre
       .Size = 255
       .Key = K_NOMBRE
       .Value = m_Nombre
    End With
       
    With .Add(Nothing, cscToCodigo)
       .PropertyType = cspText
       .Name = C_strCodigo
       .Size = 15
       .Key = K_CODIGO
       .Value = m_Codigo
    End With
       
    With .Add(Nothing, cscActivo)
       .PropertyType = cspCheck
       .Name = C_strActivo
       .Key = K_ACTIVO
       .Value = CInt(m_Activo)
    End With
    
    With .Add(Nothing, cscToGeneradeuda)
       .PropertyType = cspCheck
       .Name = LNGGetText(1494, vbNullString)   'Genera Deuda
       .Key = K_GENERADEUDA
       .Value = CInt(m_GeneraDeuda)
    End With
    
    With .Add(Nothing, cscToDescrip)
       .PropertyType = cspText
       .SubType = cspMemo
       .Width = 6000
       .Height = 880
       .Name = C_strDescrip
       .Size = 255
       .Key = K_DESCRIP
       .Value = m_descrip
    End With
      
    Set c = .Add(Nothing, c_cuentagrupo)
    With c
       .PropertyType = cspGrid
       .LeftLabel = -1
       If Not pLoadCuentaGrupo(c) Then Exit Function
       .Name = c_cuentagrupo
       .Key = K_CUENTAGRUPO
       .TabIndex = c_tab_cuentagrupo
       .GridAdd = True
       .GridEdit = True
       .GridRemove = True
    End With
  
    m_ItemsDeletedCuentaGrupo = vbNullString
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset

  sqlstmt = "select * from TipoOperacion where to_id = " & Id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then
  
    m_Id = gDB.ValField(rs.fields, cscToId)
    m_Nombre = gDB.ValField(rs.fields, cscToNombre)
    m_Codigo = gDB.ValField(rs.fields, cscToCodigo)
    m_descrip = gDB.ValField(rs.fields, cscToDescrip)
    m_GeneraDeuda = gDB.ValField(rs.fields, cscToGeneradeuda)
    m_Activo = gDB.ValField(rs.fields, cscActivo)
  
  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_descrip = vbNullString
    m_GeneraDeuda = True
    m_Activo = True

  End If

  Load = True
End Function

Private Function pLoadCuentaGrupo(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select tcg.*,cue_nombre,cueg_nombre" & _
            " from TipoOperacionCuentaGrupo tcg " & _
                    " inner join Cuenta c on tcg.cue_id = c.cue_id" & _
                    " inner join CuentaGrupo cg on tcg.cueg_id = cg.cueg_id" & _
            " where tcg.to_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCuentaGrupo", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
  
      With .Add(Nothing)
        .Visible = False
        .Key = KI_TOCUEG_ID
      End With
        
      With .Add(Nothing)
        .Name = LNGGetText(1404, vbNullString)   'Grupo
        .PropertyType = cspHelp
        .Table = csCuentaGrupo
        .Width = 3500
        .Key = KI_CUEG_ID
      End With
        
      With .Add(Nothing)
        .Name = LNGGetText(1267, vbNullString)   'Cuenta
        .PropertyType = cspHelp
        .Table = csCuenta
        .Width = 3500
        .Key = KI_CUE_ID
      End With
      
    End With
  
    With .Rows
    
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscToCuegId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscToCuegId).Value
            .Key = KI_TOCUEG_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCuegNombre)
            .Id = gDB.ValField(rs.fields, cscCuegId)
            .Key = KI_CUEG_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCueNombre)
            .Id = gDB.ValField(rs.fields, cscCueId)
            .Key = KI_CUE_ID
          End With
        
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With

  pLoadCuentaGrupo = True
End Function

Private Function pIsEmptyRowCuentaGrupo(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CUE_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_CUEG_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowCuentaGrupo = bRowIsEmpty
End Function

Private Function pSaveItemsCuentaGrupo() As Boolean
  Dim register As cRegister
  Dim fields   As cFields
  
  With m_ObjAbm.Properties.Item(c_cuentagrupo)
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscToCuegId
        .Table = csTTipoOperacionCuentaGrupo
        .Id = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_TOCUEG_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_CUE_ID
              fields.Add2 cscCueId, Cell.Id, csId
            Case KI_CUEG_ID
              fields.Add2 cscCuegId, Cell.Id, csId
          End Select
        Next
        
        fields.Add2 cscToId, m_Id, csId
        
        fields.HaveLastUpdate = True
        fields.HaveWhoModify = True
      
      End With
                                                                    
      If Not gDB.Save(register, , "pSaveItemsCuentaGrupo", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedCuentaGrupo) And Not m_Copy Then
    m_ItemsDeletedCuentaGrupo = RemoveLastColon(m_ItemsDeletedCuentaGrupo)
    sqlstmt = "delete TipoOperacionCuentaGrupo where tocueg_id in (" & m_ItemsDeletedCuentaGrupo & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsCuentaGrupo", C_Module) Then Exit Function
  End If
  
  pSaveItemsCuentaGrupo = True
End Function

Private Sub Class_Initialize()
  On Error Resume Next
  c_ErrorSave = LNGGetText(1491, vbNullString) 'Error al grabar el Tipo de Operación
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub

