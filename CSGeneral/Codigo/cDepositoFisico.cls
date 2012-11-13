VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDepositoFisico"
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
' cDepositoFisico
' 27-01-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cDepositoFisico"

Private Const c_productos   As String = "productos"
Private Const c_Filter      As String = "filter"
Private Const c_Top         As String = "top"

Private Const K_NOMBRE                        As Integer = 1
Private Const K_CODIGO                        As Integer = 2
Private Const K_ACTIVO                        As Integer = 3
Private Const K_DESCRIP                       As Integer = 4
Private Const K_DEP_LOGICOS                   As Integer = 5
Private Const K_TEL                           As Integer = 6
Private Const K_DIR                           As Integer = 7
Private Const K_PRODUCTOS                     As Integer = 8

Private Const K_CMD_FILTER                      As Integer = 507
Private Const K_FILTER                          As Integer = 508
Private Const K_TOP                             As Integer = 509

Private Const KI_PRDEPF_ID                    As Integer = 1
Private Const KI_PR_ID                        As Integer = 2
Private Const KI_X                            As Integer = 3
Private Const KI_Y                            As Integer = 4
Private Const KI_Z                            As Integer = 5
Private Const KI_MINIMO                       As Integer = 6
Private Const KI_MAXIMO                       As Integer = 7
Private Const KI_REPOSICION                   As Integer = 8

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                As Long
Private m_Nombre            As String
Private m_Codigo            As String
Private m_Activo            As Boolean
Private m_descrip           As String
Private m_Tel               As String
Private m_Dir               As String

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

Private m_ItemsDeletedP     As String

Private m_WasChanged        As Boolean

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
  
  With m_ObjAbm.Properties(cscDepfCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscDepfNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscDepfCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscDepfNombre)
    
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

  Doc.ClientTable = csTDepositoFisico
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
                               csPreGNewDepositoFisico
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

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

  With m_ObjAbm.Properties
    Select Case Key
      
      Case K_CMD_FILTER, K_TOP
        pShowProductos
    End Select
  End With

End Function

Private Function cIABMClient_Save() As Boolean
  Dim LastId     As Long
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscDepfId
    .Table = csTDepositoFisico
    
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
                  fields.Add2 cscDepfNombre, .Value, csText
              Case K_CODIGO
                  fields.Add2 cscDepfCodigo, .Value, csText
              Case K_ACTIVO
                  fields.Add2 cscActivo, Val(.Value), csBoolean
              Case K_DESCRIP
                  fields.Add2 cscDepfDescrip, .Value, csText
              Case K_DIR
                  fields.Add2 cscDepfDir, .Value, csText
              Case K_TEL
                  fields.Add2 cscDepfTel, .Value, csText
          
          End Select
      End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
                                                         
  If Not register.BeginTrans(gDB) Then Exit Function
                                                         
  If Not gDB.SaveEx(register, , _
                    cscDepfCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.Id
    
  If Not pSaveProductos() Then GoTo SaveError
  
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
    cIABMClient_Title = LNGGetText(1140, vbNullString)  'Depósitos Físicos
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
                Case K_ACTIVO
            End Select
        End With
    Next
    
    cIABMClient_Validate = True
End Function

'/////////////////////////////////////////////////////////////////////////////////////
Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  Select Case Key
    Case K_PRODUCTOS
      m_WasChanged = True
  End Select
  cIABMClientGrid_ColumnAfterUpdate = True
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
    Case K_PRODUCTOS
      Id = Val(pCell(Row, KI_PRDEPF_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedP = m_ItemsDeletedP & Id & C_StrColon
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_DEP_LOGICOS
      cIABMClientGrid_IsEmptyRow = True
    Case K_PRODUCTOS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRow(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
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
    Case K_DEP_LOGICOS
      cIABMClientGrid_ValidateRow = True

    Case K_PRODUCTOS
      cIABMClientGrid_ValidateRow = pValidadeRow(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

'/////////////////////////////////////////////////////////////////////////////////////

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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListDepositoFisico)
End Function

' Implementacion de cIEditGeneric
Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreGDeleteDepositoFisico) Then Exit Function
    
    Dim sqlstmt As String
    
    sqlstmt = "delete ProductoDepositoFisico where depf_id = " & Id & _
              " delete DepositoFisico where depf_id = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewDepositoFisico) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditDepositoFisico) Then Exit Function
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

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

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
  
  m_Host.Server.AddMenu C_MenuStock, csMenuConfigStock, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(1141, vbNullString), csPreGListDepositoFisico, C_MenuStock, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                      'Depósito Físico
  m_Host.MenuABMClick "CSGeneral2.cDepositoFisico", Me, LNGGetText(1142, vbNullString), 0, csETablasGeneral.csDepositoFisico
End Function


' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  Dim iProp As cABMProperty
  
  m_ObjAbm.Title2 = m_Nombre
  
  With m_ObjAbm.Tabs
    
    .Clear
      
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
      
    With .Add(Nothing)
      .Index = 1
      .Name = LNGGetText(1143, vbNullString)  'Dep. Lógicos
    End With
  
    With .Add(Nothing)
      .Index = 2
      .Name = LNGGetText(3089, vbNullString)  'Productos
    End With
  
  End With
  
  With m_ObjAbm.Properties
  
    .Clear
    
    With .Add(Nothing, cscDepfNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
      .Width = 6500
    End With
        
    With .Add(Nothing, cscDepfCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 15
      .Value = m_Codigo
      .Key = K_CODIGO
    End With
        
    With .Add(Nothing, cscDepfTel)
      .PropertyType = cspText
      .Name = LNGGetText(1036, vbNullString)   'Teléfono
      .Size = 100
      .Key = K_TEL
      .Value = m_Tel
    End With
    
    With .Add(Nothing, cscDepfDir)
      .PropertyType = cspText
      .Name = LNGGetText(1037, vbNullString)   'Dirección
      .Size = 255
      .Key = K_DIR
      .Value = m_Dir
      .Width = 6500
    End With
        
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
      .TabIndex = 0
    End With
        
    Set c = .Add(Nothing)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not LoadDepositosLogicos(c) Then Exit Function
      .Name = LNGGetText(1143, vbNullString)   'Dep. Lógicos
      .Key = K_DEP_LOGICOS
      .TabIndex = 1
    End With
        
    Set c = .Add(Nothing, c_Filter)
    With c
      .Name = LNGGetText(2826, vbNullString) 'Filtro
      .PropertyType = cspText
      .TabIndex = 2
      Set iProp = c
      iProp.IsEditProperty = False
      .Key = K_FILTER
    End With
        
    With .Add(Nothing)
      .PropertyType = cspButton
      .TopFromProperty = c_Filter
      .Left = 4000
      .LeftNotChange = True
      .TopNotChange = True
      .LeftLabel = -1
      .Name = LNGGetText(3432, vbNullString) 'Filtrar
      .TabIndex = 2
      .Key = K_CMD_FILTER
    End With
    
    Set c = .Add(Nothing, c_Top)
    With c
      .PropertyType = cspCheck
      .Name = LNGGetText(3479, vbNullString) 'Top 50
      .TopFromProperty = c_Filter
      .Left = 7500
      .LeftNotChange = True
      .TopNotChange = True
      .LeftLabel = -800
      .TabIndex = 2
      .Key = K_TOP
      .Value = -1
      Set iProp = c
      iProp.IsEditProperty = False
    End With
    
    Set c = .Add(Nothing, c_productos)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadProductos(c) Then Exit Function
      .Name = LNGGetText(3089, vbNullString)   'Productos
      .Key = K_PRODUCTOS
      .Top = 1500
      .Left = 200
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
      .TabIndex = 2
    End With
    
    m_ItemsDeletedP = vbNullString
        
    With .Add(Nothing, cscDepfDescrip)
      .PropertyType = cspText
      .Name = C_strDescrip
      .LeftFromProperty = cscDepfNombre
      .TopFromProperty = cscActivo
      .TopToPrevious = 440
      .Height = 660
      .Width = 6500
      .Size = 255
      .SubType = cspMemo
      .Key = K_DESCRIP
      .Value = m_descrip
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
    
    Dim sqlstmt As String
    Dim rs      As ADODB.Recordset
    
    sqlstmt = "select * from DepositoFisico where depf_Id = " & Id
    
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
    
    If rs.EOF Then
        m_Activo = True
        m_Nombre = vbNullString
        m_Codigo = vbNullString
        m_descrip = vbNullString
        m_Id = csNO_ID
        m_Dir = vbNullString
        m_Tel = vbNullString
    Else
        m_Activo = gDB.ValField(rs.fields, cscActivo)
        m_Nombre = gDB.ValField(rs.fields, cscDepfNombre)
        m_Codigo = gDB.ValField(rs.fields, cscDepfCodigo)
        m_Id = gDB.ValField(rs.fields, cscDepfId)
        m_descrip = gDB.ValField(rs.fields, cscDepfDescrip)
        m_Dir = gDB.ValField(rs.fields, cscDepfDir)
        m_Tel = gDB.ValField(rs.fields, cscDepfTel)
    End If
    
    Load = True
End Function

Private Function LoadDepositosLogicos(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select depl_id, depl_nombre, depl_codigo" & _
            " from DepositoLogico where depf_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
  
  With Propiedad.Grid
  
    With .Columns
    
      .Clear
      
      .Add(Nothing).Visible = False
      .Add(Nothing).Name = C_strNombre
      .Add(Nothing).Name = C_strCodigo
  
    End With
    
    With .Rows
    
      .Clear
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscDeplId).Value)
        
          .Add(Nothing).Value = rs(cscDeplId).Value
          .Add(Nothing).Value = rs(cscDeplNombre).Value
          .Add(Nothing).Value = rs(cscDeplCodigo).Value
          
        End With
        
        rs.MoveNext
      Wend
    
    End With
  End With
  
  LoadDepositosLogicos = True

End Function

Private Function pLoadProductos(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  m_WasChanged = False
  
  Dim filter As String
  
  With m_ObjAbm.Properties
    filter = .Item(c_Filter).Value
    
    sqlstmt = "select " & _
              IIf(Val(.Item(c_Top).Value), _
                  "top 50 ", _
                  vbNullString)
  End With
  
  sqlstmt = sqlstmt & "prdepf.*,pr_nombrecompra" & _
            " from ProductoDepositoFisico prdepf" & _
            " inner join producto pr on prdepf.pr_id = pr.pr_id" & _
            " where prdepf.depf_id = " & m_Id
  
  If LenB(filter) Then
    
    filter = Replace(filter, "*", "%")
    filter = gDB.sqlString(filter)
  
    sqlstmt = sqlstmt & _
              " and (pr_nombrecompra like " & filter & _
              " or pr_codigo like " & filter & ")"
  End If
  
  sqlstmt = sqlstmt & " order by pr_nombrecompra"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
  
  With Propiedad.Grid
    With .Columns
    
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PRDEPF_ID
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1619, vbNullString)  'Producto
        .PropertyType = cspHelp
        .Table = csProductoStock
        .Width = 3500
        .Key = KI_PR_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1323, vbNullString)  'x
        .PropertyType = cspNumeric
        .SubType = cspInteger
        .Width = 1200
        .Key = KI_X
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1324, vbNullString)  'y
        .PropertyType = cspNumeric
        .SubType = cspInteger
        .Width = 1200
        .Key = KI_Y
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1325, vbNullString)  'z
        .PropertyType = cspNumeric
        .SubType = cspInteger
        .Width = 1200
        .Key = KI_Z
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1326, vbNullString)  'Stock Minimo
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Format = gFormatDecCantidad
        .Width = 1200
        .Key = KI_MINIMO
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1327, vbNullString)  'Stock Maximo
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Format = gFormatDecCantidad
        .Width = 1200
        .Key = KI_MAXIMO
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1328, vbNullString)  'Reposicion
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Format = gFormatDecCantidad
        .Width = 1200
        .Key = KI_REPOSICION
      End With
    End With
          
    With .Rows
    
      .Clear
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscPrdepfId).Value)
          
          With .Add(Nothing)
            .Value = rs(cscPrdepfId).Value
            .Key = KI_PRDEPF_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrNombrecompra)
            .Id = gDB.ValField(rs.fields, cscPrId)
            .Key = KI_PR_ID
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrdepfX)
            .Key = KI_X
          End With
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrdepfY)
            .Key = KI_Y
          End With
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrdepfZ)
            .Key = KI_Z
          End With
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrdepfStockminimo)
            .Key = KI_MINIMO
          End With
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrdepfStockmaximo)
            .Key = KI_MAXIMO
          End With
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrdepfReposicion)
            .Key = KI_REPOSICION
          End With
       
        End With
                
        rs.MoveNext
      Wend
    
    End With
  End With
  
  pLoadProductos = True

End Function

Private Function pSaveProductos() As Boolean
  
  Dim register  As cRegister
  Dim fields    As cFields
  Dim IProperty As cIABMProperty
  
  With m_ObjAbm.Properties.Item(c_productos)
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscPrdepfId
        .Table = csTProductoDepositoFisico
        .Id = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_PRDEPF_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_PR_ID
              fields.Add2 cscPrId, Cell.Id, csId
          
            Case KI_X
              fields.Add2 cscPrdepfX, Cell.Value, csInteger
            Case KI_Y
              fields.Add2 cscPrdepfY, Cell.Value, csInteger
            Case KI_Z
              fields.Add2 cscPrdepfZ, Cell.Value, csInteger
          
            Case KI_MINIMO
              fields.Add2 cscPrdepfStockminimo, Cell.Value, csDouble
            Case KI_MAXIMO
              fields.Add2 cscPrdepfStockmaximo, Cell.Value, csDouble
            Case KI_REPOSICION
              fields.Add2 cscPrdepfReposicion, Cell.Value, csDouble
          End Select
        Next
        
        fields.Add2 cscDepfId, m_Id, csId
        
        fields.HaveLastUpdate = False
        fields.HaveWhoModify = False
        
      End With
                                                              
      If Not gDB.Save(register, , "pSaveProductos", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If m_ItemsDeletedP <> vbNullString And Not m_Copy Then
    m_ItemsDeletedP = RemoveLastColon(m_ItemsDeletedP)
    sqlstmt = "delete ProductoDepositoFisico where prdepf_id in (" & m_ItemsDeletedP & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveProductos", C_Module) Then Exit Function
  End If
  
  pSaveProductos = True
End Function

Private Function pValidadeRow(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_PR_ID
        If ValEmpty(Cell.Id, csId) Then
                    'Debe indicar un producto
          MsgInfo LNGGetText(3068, vbNullString, strRow)
          Exit Function
        End If
    End Select
  Next
  
  pValidadeRow = True
End Function

Private Function pIsEmptyRow(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_PR_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRow = bRowIsEmpty
End Function

Private Sub pShowProductos()
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  If AbmObj.InSave Then Exit Sub
  
  If m_WasChanged Then
    If Not Ask(LNGGetText(1086, vbNullString), vbNo) Then Exit Sub
  End If
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties.Item(c_productos)
  pLoadProductos iProp
  m_ObjAbm.ShowValue iProp
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  On Error Resume Next
  c_ErrorSave = LNGGetText(1139, vbNullString) 'Error al grabar el Depósito Lógico
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub
