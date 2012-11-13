VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCaja"
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
' cCaja
' 04-08-07

'--------------------------------------------------------------------------------

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cCaja"

Private Const csDocumento = 4001

Private Const c_Usuarios     As String = "Usuarios"
Private Const c_cuentas      As String = "Cuentas"

Private Const K_NOMBRE       As Integer = 1
Private Const K_CODIGO       As Integer = 2
Private Const K_ACTIVO       As Integer = 3
Private Const K_DESCRIP      As Integer = 4
Private Const K_SUCURSAL     As Integer = 5
Private Const K_USUARIOS     As Integer = 7
Private Const K_CUENTAS      As Integer = 8
Private Const K_DOC_ID       As Integer = 9
Private Const K_EMP_ID       As Integer = 10
Private Const K_HOJA_RUTA    As Integer = 11

Private Const KI_CJCJ_ID     As Integer = 1
Private Const KI_US_ID       As Integer = 2

Private Const KI_CJC_ID            As Integer = 1
Private Const KI_CUE_ID_TRABAJO    As Integer = 2
Private Const KI_CUE_ID_FONDOS     As Integer = 3

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                 As Long
Private m_Nombre             As String
Private m_Codigo             As String
Private m_Activo             As Boolean
Private m_hojaruta           As Boolean
Private m_Sucursal           As String
Private m_sucId              As Long
Private m_Documento          As String
Private m_docId              As Long

Private m_Empresa            As String
Private m_empId              As Long

Private m_descrip            As String

Private m_Editing            As Boolean

Private m_ItemsDeletedU      As String
Private m_ItemsDeletedC      As String

Private m_ObjAbm             As cIABMGeneric
Private m_ObjTree            As Object

Private m_IsNew              As Boolean

Private m_BranchId           As Long
Private m_TreeId             As Long

Private m_Host               As CSMenu.cIMenuHost
Private m_Copy               As Boolean

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
  
  With m_ObjAbm.Properties(cscCjCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscCjNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscCjCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscCjNombre)
  
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

  Doc.ClientTable = csTCaja
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
                               csPreGNewCaja
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
  Select Case Key
    Case K_EMP_ID
      Dim emp_id As Long
      Dim iProp As cIABMProperty
      
      emp_id = m_ObjAbm.Properties.Item(cscEmpId).HelpId
      Set iProp = m_ObjAbm.Properties.Item(cscDocId)
      iProp.Enabled = emp_id
      iProp.HelpFilter = "emp_id = " & emp_id & " and doct_id = 15 " ' Asiento Contable
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      AbmGen.ShowValue iProp
      
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  Dim LastId     As Long
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscCjId
    .Table = csTCaja
    
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
            fields.Add2 cscCjNombre, .Value, csText
        Case K_CODIGO
            fields.Add2 cscCjCodigo, .Value, csText
        Case K_ACTIVO
            fields.Add2 cscActivo, Val(.Value), csBoolean
        Case K_SUCURSAL
            fields.Add2 cscSucId, .HelpId, csId
        Case K_DESCRIP
            fields.Add2 cscCjDescrip, .Value, csText
        Case K_EMP_ID
            fields.Add2 cscEmpId, .HelpId, csId
        Case K_HOJA_RUTA
            fields.Add2 cscCjHojaRuta, Val(.Value), csBoolean
        Case K_DOC_ID
            fields.Add2 cscDocId, .HelpId, csId
      End Select
    End With
  Next
    
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
    
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.SaveEx(register, , _
                    cscCjCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.Id
  
  If Not pSaveUsuarios() Then GoTo SaveError
  If Not pSaveCuentas() Then GoTo SaveError
  
  If Not pValidateCaja() Then GoTo SaveError
  
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
    cIABMClient_Title = LNGGetText(3497, vbNullString) 'Caja
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
        Case K_SUCURSAL
          If ValEmpty(Val(.HelpId), csId) Then
              MsgInfo LNGGetText(1560, vbNullString) 'Debe indicar una Sucursal
              Exit Function
          End If
        Case K_EMP_ID
          If ValEmpty(Val(.HelpId), csId) Then
              MsgInfo LNGGetText(1129, vbNullString) 'Debe indicar una Empresa
              Exit Function
          End If
        Case K_DOC_ID
          If ValEmpty(Val(.HelpId), csId) Then
              MsgInfo LNGGetText(1562, vbNullString) 'Debe indicar un Documento
              Exit Function
          End If
              
      End Select
    End With
  Next
  
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

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Select Case Key
    Case K_USUARIOS
      Id = Val(pCell(row, KI_CJCJ_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedU = m_ItemsDeletedU & Id & C_StrColon
    Case K_CUENTAS
      Id = Val(pCell(row, KI_CJC_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedC = m_ItemsDeletedC & Id & C_StrColon
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_USUARIOS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowU(row, RowIndex)
    Case K_CUENTAS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowC(row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_USUARIOS
      cIABMClientGrid_ValidateRow = pValidadeRowU(row, RowIndex)
    Case K_CUENTAS
      cIABMClientGrid_ValidateRow = pValidadeRowC(row, RowIndex)
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListCaja)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreGDeleteCaja) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "delete CajaCajero where cj_Id = " & Id & _
              "delete CajaCuenta where cj_Id = " & Id & _
              "delete Caja where cj_id = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewCaja) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditCaja) Then Exit Function
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

  m_Host.Server.AddMenu C_MenuTesoreria, csMenuConfigTesoreria, C_MenuConfig, 0, True, False, False, False, True, Nothing
                        'Ca&ja
  m_Host.Server.AddMenu LNGGetText(3498, vbNullString), csPreGListCaja, C_MenuTesoreria, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                          'Caja
  m_Host.MenuABMClick "CSGeneral2.cCaja", Me, LNGGetText(3497, vbNullString), 0, csETablasGeneral.csCaja
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  
  m_ObjAbm.Title2 = m_Nombre
  
  Const tab_general = 0
  Const tab_usuarios = 1
  
  With m_ObjAbm.Tabs
    
    .Clear
  
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
    
    With .Add(Nothing)
      .Index = tab_usuarios
      .Name = LNGGetText(3499, vbNullString)    'Cajeros
    End With
  
    With .Add(Nothing)
      .Index = 2
      .Name = LNGGetText(1107, vbNullString)  'Cuentas
    End With
  End With
  
  With m_ObjAbm.Properties
    
    .Clear

    With .Add(Nothing, cscCjNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Width = 7450
      .Key = K_NOMBRE
      .Value = m_Nombre
    End With
    
    With .Add(Nothing, cscCjCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 15
      .Value = m_Codigo
      .Key = K_CODIGO
    End With
    
    With .Add(Nothing, cscActivo)
      .TopFromProperty = cscCjCodigo
      .Left = 5000
      .LeftLabel = -600
      .LeftNotChange = True
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
    
    With .Add(Nothing, cscSucId)
      .PropertyType = cspHelp
      .Table = csSucursal
      .Name = LNGGetText(1281, vbNullString)    'Sucursal
      .Key = K_SUCURSAL
      .Value = m_Sucursal
      .Width = 3000
      .HelpId = m_sucId
    End With
    
    With .Add(Nothing, cscEmpId)
      .PropertyType = cspHelp
      .Table = csEmpresa
      .Name = LNGGetText(1114, vbNullString)    'Empresa
      .Key = K_EMP_ID
      .Value = m_Empresa
      .Width = 3000
      .HelpId = m_empId
      .Enabled = m_Id = csNO_ID
    End With
    
    Set c = .Add(Nothing, cscDocId)
    With c
      .PropertyType = cspHelp
      .Table = csDocumento
      .Name = LNGGetText(1567, vbNullString)    'Documento
      .Key = K_DOC_ID
      .Value = m_Documento
      .Width = 3000
      .HelpId = m_docId
      .HelpFilter = "emp_id = " & m_empId & " and doct_id = 15 " ' Asiento Contable
      .Enabled = m_empId
    End With
    Dim oProp As cABMProperty
    Set oProp = c
    oProp.IsForAbm = True
    
    With .Add(Nothing, cscCjHojaRuta)
      .PropertyType = cspCheck
      .Name = LNGGetText(5103, vbNullString) ' Para Hoja de Ruta
      .Key = K_HOJA_RUTA
      .Value = CInt(m_hojaruta)
    End With
            
    With .Add(Nothing, cscCjDescrip)
      .PropertyType = cspText
      .Name = C_strDescrip
      .LeftFromProperty = cscCjNombre
      .TopFromProperty = cscCjHojaRuta
      .TopToPrevious = 440
      .Height = 660
      .Width = 7450
      .Size = 255
      .SubType = cspMemo
      .Key = K_DESCRIP
      .Value = m_descrip
    End With
    
    Set c = .Add(Nothing, c_Usuarios)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadUsuarios(c) Then Exit Function
      .Name = c_Usuarios
      .Key = K_USUARIOS
      .TabIndex = tab_usuarios
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_ItemsDeletedU = vbNullString

    Set c = .Add(Nothing, c_cuentas)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadCuentas(c) Then Exit Function
      .Name = LNGGetText(1107, vbNullString)   'Cuentas
      .Key = K_CUENTAS
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
      .TabIndex = 2
    End With

    m_ItemsDeletedC = vbNullString

  End With
      
  If Not m_ObjAbm.Show(Me) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select cj.*,suc_nombre, doc_nombre, emp_nombre " & _
            "from Caja cj " & _
            "inner join Sucursal suc on cj.suc_id = suc.suc_id " & _
            "inner join Empresa emp on cj.emp_id = emp.emp_id " & _
            "inner join Documento doc on cj.doc_id = doc.doc_id " & _
            "where cj_id = " & Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
  
  If rs.EOF Then
    m_Activo = True
    m_hojaruta = False
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_descrip = vbNullString
    m_Id = csNO_ID
    m_sucId = csNO_ID
    m_Sucursal = vbNullString
    m_docId = csNO_ID
    m_Documento = vbNullString
    m_empId = csNO_ID
    m_Empresa = vbNullString
  Else
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_hojaruta = gDB.ValField(rs.fields, cscCjHojaRuta)
    m_Nombre = gDB.ValField(rs.fields, cscCjNombre)
    m_Codigo = gDB.ValField(rs.fields, cscCjCodigo)
    m_descrip = gDB.ValField(rs.fields, cscCjDescrip)
    m_Id = gDB.ValField(rs.fields, cscCjId)
    m_sucId = gDB.ValField(rs.fields, cscSucId)
    m_Sucursal = gDB.ValField(rs.fields, cscSucNombre)
    m_docId = gDB.ValField(rs.fields, cscDocId)
    m_Documento = gDB.ValField(rs.fields, cscDocNombre)
    m_empId = gDB.ValField(rs.fields, cscEmpId)
    m_Empresa = gDB.ValField(rs.fields, cscEmpNombre)
  End If
  Load = True
End Function

Private Function pLoadUsuarios(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select cjcj.*,us_nombre from CajaCajero cjcj inner join Usuario us on cjcj.us_id = us.us_id where cj_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadUsuarios", C_Module) Then Exit Function
  
  With Propiedad.Grid
    With .Columns
    
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_CJCJ_ID
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(3499, vbNullString)  'Cajeros
        .PropertyType = cspHelp
        .Table = csUsuario
        .Width = 3500
        .Key = KI_US_ID
      End With
      
    End With
          
    With .Rows
    
      .Clear
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscCjcjId).Value)
          
          With .Add(Nothing)
            .Value = rs(cscCjcjId).Value
            .Key = KI_CJCJ_ID
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
  
  pLoadUsuarios = True
End Function

Private Function pSaveUsuarios() As Boolean
  
  Dim register  As cRegister
  Dim fields    As cFields
  Dim IProperty As cIABMProperty
  
  With m_ObjAbm.Properties.Item(c_Usuarios)
    Dim row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscCjcjId
        .Table = csTCajaCajero
        .Id = csNew
        
        For Each Cell In row
          Select Case Cell.Key
            
            Case KI_CJCJ_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_US_ID
              fields.Add2 cscUsId, Cell.Id, csId
          End Select
        Next
        
        fields.Add2 cscCjId, m_Id, csId
        
        fields.HaveLastUpdate = False
        fields.HaveWhoModify = False
        
      End With
                                                              
      If Not gDB.Save(register, , "pSaveUsuarios", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedU) And Not m_Copy Then
    m_ItemsDeletedU = RemoveLastColon(m_ItemsDeletedU)
    sqlstmt = "delete CajaCajero where cjcj_id in (" & m_ItemsDeletedU & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveUsuarios", C_Module) Then Exit Function
  End If
  
  pSaveUsuarios = True
End Function

Private Function pValidadeRowU(row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In row
    Select Case Cell.Key
      Case KI_US_ID
        If ValEmpty(Cell.Id, csId) Then
                    'Debe indicar un usuario
          MsgInfo LNGGetText(1153, vbNullString, strRow)
          Exit Function
        End If
    End Select
  Next
  
  pValidadeRowU = True
End Function

Private Function pIsEmptyRowU(ByRef row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In row
    Select Case Cell.Key
      Case KI_US_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowU = bRowIsEmpty
End Function

Private Function pLoadCuentas(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_CajaGetCuentas " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    C_LoadFunction, _
                    C_Module) Then Exit Function
  
  With Propiedad.Grid
    With .Columns
    
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_CJC_ID
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(3500, vbNullString)  'Cuenta de Trabajo
        .PropertyType = cspHelp
        .Table = csCuenta
        .HelpFilter = pGetFilterCuentas()
        .Width = 3500
        .Key = KI_CUE_ID_TRABAJO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(3501, vbNullString)  'Cuenta de Fondos
        .PropertyType = cspHelp
        .Table = csCuenta
        .HelpFilter = pGetFilterCuentas()
        .Width = 3500
        .Key = KI_CUE_ID_FONDOS
      End With
            
    End With
          
    With .Rows
    
      .Clear
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscCjcId).Value)
          
          With .Add(Nothing)
            .Value = rs(cscCjcId).Value
            .Key = KI_CJC_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, "cue_trabajo")
            .Id = gDB.ValField(rs.fields, cscCueIdTrabajo)
            .Key = KI_CUE_ID_TRABAJO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, "cue_fondos")
            .Id = gDB.ValField(rs.fields, cscCueIdFondos)
            .Key = KI_CUE_ID_TRABAJO
          End With
               
        End With
                
        rs.MoveNext
      Wend
    
    End With
  End With
  
  pLoadCuentas = True

End Function

Private Function pSaveCuentas() As Boolean
  
  Dim register  As cRegister
  Dim fields    As cFields
  Dim IProperty As cIABMProperty
  
  With m_ObjAbm.Properties.Item(c_cuentas)
    Dim row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscCjcId
        .Table = csTCajaCuenta
        .Id = csNew
        
        For Each Cell In row
          Select Case Cell.Key
            
            Case KI_CJC_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_CUE_ID_TRABAJO
              fields.Add2 cscCueIdTrabajo, Cell.Id, csId
            Case KI_CUE_ID_FONDOS
              fields.Add2 cscCueIdFondos, Cell.Id, csId
          End Select
        Next
        
        fields.Add2 cscCjId, m_Id, csId
        
        fields.HaveLastUpdate = False
        fields.HaveWhoModify = False
        
      End With
                                                              
      If Not gDB.Save(register, , "pSaveCuentas", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedC) And Not m_Copy Then
    m_ItemsDeletedC = RemoveLastColon(m_ItemsDeletedC)
    sqlstmt = "delete CajaCuenta where cjc_id in (" & m_ItemsDeletedC & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveCuentas", C_Module) Then Exit Function
  End If
  
  pSaveCuentas = True
End Function

Private Function pValidadeRowC(row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In row
    Select Case Cell.Key
      Case KI_CUE_ID_TRABAJO
        If ValEmpty(Cell.Id, csId) Then
                    'Debe indicar una Cuenta de Trabajo
          MsgInfo LNGGetText(3503, vbNullString, strRow)
          Exit Function
        End If
      Case KI_CUE_ID_FONDOS
        If ValEmpty(Cell.Id, csId) Then
                    'Debe indicar una Cuenta de Fondos
          MsgInfo LNGGetText(3502, vbNullString, strRow)
          Exit Function
        End If
    End Select
  Next
  
  pValidadeRowC = True
End Function

Private Function pIsEmptyRowC(ByRef row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In row
    Select Case Cell.Key
      Case KI_CUE_ID_TRABAJO
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      
      Case KI_CUE_ID_FONDOS
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    
    End Select
  Next
  
  pIsEmptyRowC = bRowIsEmpty
End Function

Private Function pValidateCaja() As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_CajaValidate " & m_Id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim error_code As Long
  error_code = gDB.ValField(rs.fields, "error_code")
  
  If error_code Then
    
    Dim cuentas As String
    
    Set rs = rs.NextRecordset
    
    While Not rs.EOF
      cuentas = cuentas & gDB.ValField(rs.fields, cscCueNombre) & ", "
      rs.MoveNext
    Wend
    cuentas = RemoveLastColon(Trim$(cuentas))
    
    Select Case error_code
      Case 1
        MsgWarning LNGGetText(3514, vbNullString, cuentas) '"Esta caja posee cuentas de fondos que son cuentas de trabajo de otras cajas:;;"
      
      Case 2
        MsgWarning LNGGetText(3515, vbNullString, cuentas) '"Esta caja posee cuentas de fondos que tambien estan mencionadas como cuentas de trabajo;;"
      
      Case 3
        MsgWarning LNGGetText(3516, vbNullString, cuentas) '"Esta caja posee cuentas de trabajo que estan mencionadas mas de una vez;;"
    
      Case 4
        MsgWarning LNGGetText(3517, vbNullString, cuentas) '"Esta caja posee cuentas de trabajo que ya estan mencionadas por otras cajas;;"
    
      Case 5
        MsgWarning LNGGetText(3518, vbNullString, cuentas) '"Las cuentas de trabajo de tipo Bancos o Documentos en Cartera no pueden tener asociada una cuenta de fondos de tipo Caja;;"
    End Select
  Else
    pValidateCaja = True
  End If
End Function

Private Function pGetFilterCuentas() As String
  
  ' 1  Documentos en Cartera
  ' 2  Bancos
  ' 14 Caja
  ' 19 Cupones presentados
  '
  pGetFilterCuentas = "cuec_id in (1,2,14,19,7)"
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error Resume Next
  c_ErrorSave = LNGGetText(3504, vbNullString) 'Error al grabar la Caja
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub


