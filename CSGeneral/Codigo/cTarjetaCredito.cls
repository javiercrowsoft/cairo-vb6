VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTarjetaCredito"
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
' cTarjetaCredito
' 01-02-01

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cTarjetaCredito"

Private Const c_cuotas = "Cuotas"

Private Const K_NOMBRE            As Integer = 1
Private Const K_CODIGO            As Integer = 2
Private Const K_ACTIVO            As Integer = 3
Private Const K_DESCRIP           As Integer = 4
Private Const K_CUE_ID_BANCO      As Integer = 5
Private Const K_CUE_ID_ENCARTERA  As Integer = 6
Private Const K_CUE_ID_PRESENTADO As Integer = 7
Private Const K_CUE_ID_RECHAZO    As Integer = 8
Private Const K_CUE_ID_COMISION   As Integer = 9
Private Const K_COMISION          As Integer = 10
Private Const K_CUOTAS            As Integer = 11
Private Const K_EMP_ID            As Integer = 12

Private Const KI_TJCCU_ID         As Integer = 1
Private Const KI_CUOTAS           As Integer = 2
Private Const KI_COMISION         As Integer = 3

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                As Long
Private m_Nombre            As String
Private m_Codigo            As String
Private m_Activo            As Boolean

Private m_Banco             As String
Private m_cue_id_banco      As Long
Private m_Presentado        As String
Private m_cue_id_presentado As Long
Private m_EnCartera         As String
Private m_cue_id_enCartera  As Long
Private m_Comision          As String
Private m_cue_id_comision   As Long
Private m_Rechazo           As String
Private m_cue_id_rechazo    As Long
Private m_emp_id            As Long
Private m_Empresa           As String

Private m_PorcComision      As Double
Private m_descrip           As String

Private m_ItemsDeleted      As String

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

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
  
  With m_ObjAbm.Properties(cscTjcCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscTjcNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscTjcCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscTjcNombre)
  
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

  Doc.ClientTable = csTTarjetaCredito
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
                               csPreGNewTarjetaCredito
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
  Dim LastId     As Long
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscTjcId
    .Table = csTTarjetaCredito
  
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
          fields.Add2 cscTjcNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscTjcCodigo, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, Val(.Value), csBoolean
        Case K_COMISION
          fields.Add2 cscTjcComision, Val(.Value), csDouble
        Case K_DESCRIP
          fields.Add2 cscTjcDescrip, .Value, csText
        Case K_CUE_ID_BANCO
          fields.Add2 cscCueIdBanco, .HelpId, csId
        Case K_CUE_ID_ENCARTERA
          fields.Add2 cscCueIdEnCartera, .HelpId, csId
        Case K_CUE_ID_PRESENTADO
          fields.Add2 cscCueIdPresentado, .HelpId, csId
        Case K_CUE_ID_COMISION
          fields.Add2 cscCueIdComision, .HelpId, csId
        Case K_CUE_ID_RECHAZO
          fields.Add2 cscCueIdRechazo, .HelpId, csId
        Case K_EMP_ID
          fields.Add2 cscEmpId, .HelpId, csId
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
                                                         
  If Not gDB.SaveEx(register, , _
                    cscTjcCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.Id
   
  If Not pSaveItems() Then GoTo SaveError
  
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
  cIABMClient_Title = LNGGetText(1465, vbNullString)  'Tarjetas de Crédito
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
            MsgInfo LNGGetText(1129, vbNullString)
                  'Debe indicar una empresa
            Exit Function
          End If
        Case K_CUE_ID_BANCO
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1466, vbNullString)
                    'Debe indicar una cuenta de banco
            Exit Function
          End If
        Case K_CUE_ID_COMISION
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1467, vbNullString)
                    'Debe indicar una cuenta para las comisiones
            Exit Function
          End If
        Case K_CUE_ID_ENCARTERA
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1468, vbNullString)
                    'Debe indicar una cuenta para los cupones en cartera
            Exit Function
          End If
        Case K_CUE_ID_PRESENTADO
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1469, vbNullString)
                    'Debe indicar una cuenta para los cupones presentados
            Exit Function
          End If
        Case K_CUE_ID_RECHAZO
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1470, vbNullString)
                    'Debe indicar una cuenta para los cupones rechazados
            Exit Function
          End If
        'Case K_COMISION
        '  If ValEmpty(.Value, csDouble) Then
        '    MsgInfo LNGGetText(1471, vbNullString)
        '            'Debe indicar una comisión
        '    Exit Function
        '  End If
      End Select
    End With
  Next
  
  cIABMClient_Validate = True
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreGListTarjetaCredito)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  If Not SecurityCanAccess(csPreGDeleteTarjetaCredito) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "delete TarjetaCredito where tjc_id = " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewTarjetaCredito) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditTarjetaCredito) Then Exit Function
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
  
  m_Host.Server.AddMenu C_MenuTesoreria, csMenuConfigTesoreria, C_MenuConfig, 0, True, False, False, False, True, Nothing
                        '&Tarjeta de Crédito
  m_Host.Server.AddMenu LNGGetText(1472, vbNullString), csPreGListTarjetaCredito, C_MenuTesoreria, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                          'Tarjetas de Crédito
  m_Host.MenuABMClick "CSGeneral2.cTarjetaCredito", Me, LNGGetText(1465, vbNullString), 0, csETablasGeneral.csTarjetaCredito
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty

  Const c_tab_general = 0
  Const c_tab_cuentas = 1
  Const c_tab_cuotas = 2
  
  m_ObjAbm.Title2 = m_Nombre

  With m_ObjAbm.Tabs
    .Clear
    
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
    
    With .Add(Nothing)
      .Index = c_tab_cuentas
      .Name = LNGGetText(1107, vbNullString)  'Cuentas
    End With
  
    With .Add(Nothing)
      .Index = c_tab_cuotas
      .Name = LNGGetText(1473, vbNullString)  'Cuotas
    End With
  
  End With
  
  With m_ObjAbm.Properties
  
    .Clear
  
    With .Add(Nothing, cscTjcNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Width = 6000
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
    End With
    
    With .Add(Nothing, cscTjcCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 15
      .Value = m_Codigo
      .Key = K_CODIGO
    End With
     
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
        
    With .Add(Nothing, cscTjcComision)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .Name = LNGGetText(1091, vbNullString)  'Comisión
      .Size = 15
      .Value = m_PorcComision
      .Key = K_COMISION
    End With
        
    With .Add(Nothing, cscEmpId)
      .PropertyType = cspHelp
      .Table = csEmpresa
      .Name = LNGGetText(1114, vbNullString)  'Empresa
      .Key = K_EMP_ID
      .HelpId = m_emp_id
      .Value = m_Empresa
    End With
      
    With .Add(Nothing, cscCueIdBanco)
      .PropertyType = cspHelp
      .Table = csCuenta
      .Width = 4000
      .Name = LNGGetText(1122, vbNullString)  'Banco
      .Value = m_Banco
      .HelpId = m_cue_id_banco
      .HelpFilter = "cuec_id = " & csECuecBancos
      .TabIndex = c_tab_cuentas
      .Key = K_CUE_ID_BANCO
    End With
        
    With .Add(Nothing, cscCueIdComision)
      .PropertyType = cspHelp
      .Table = csCuenta
      .Width = 4000
      .Name = LNGGetText(1474, vbNullString)  'Comisiones
      .Value = m_Comision
      .HelpId = m_cue_id_comision
      .HelpFilter = "cuec_id = " & csECuecEgresos
      .TabIndex = c_tab_cuentas
      .Key = K_CUE_ID_COMISION
    End With
        
    With .Add(Nothing, cscCueIdEnCartera)
      .PropertyType = cspHelp
      .Table = csCuenta
      .Width = 4000
      .Name = LNGGetText(1475, vbNullString)  'En cartera
      .Value = m_EnCartera
      .HelpId = m_cue_id_enCartera
      .HelpFilter = "cuec_id = " & csECuecDocEnCartera
      .TabIndex = c_tab_cuentas
      .Key = K_CUE_ID_ENCARTERA
    End With
      
    With .Add(Nothing, cscCueIdPresentado)
      .PropertyType = cspHelp
      .Table = csCuenta
      .Width = 4000
      .Name = LNGGetText(1476, vbNullString)  'Presentados
      .Value = m_Presentado
      .HelpId = m_cue_id_presentado
      .HelpFilter = "cuec_id = " & csECuecDepositoCupones
      .TabIndex = c_tab_cuentas
      .Key = K_CUE_ID_PRESENTADO
    End With
        
    With .Add(Nothing, cscCueIdRechazo)
      .PropertyType = cspHelp
      .Table = csCuenta
      .Width = 4000
      .Name = LNGGetText(1477, vbNullString)  'Rechazados
      .Value = m_Rechazo
      .HelpId = m_cue_id_rechazo
      .HelpFilter = "cuec_id = " & csECuecPatrimoniales
      .TabIndex = c_tab_cuentas
      .Key = K_CUE_ID_RECHAZO
    End With
        
    With .Add(Nothing, cscTjcDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Width = 6000
      .Height = 880
      .Name = C_strDescrip
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_descrip
    End With
        
    Set c = .Add(Nothing, c_cuotas)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItems(c) Then Exit Function
      .Name = c_cuotas
      .Key = K_CUOTAS
      .TabIndex = c_tab_cuotas
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
  
  m_ItemsDeleted = vbNullString
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_tarjetaCreditoGet " & Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
  
  If Not rs.EOF Then
    m_Id = gDB.ValField(rs.fields, cscTjcId)
    m_Nombre = gDB.ValField(rs.fields, cscTjcNombre)
    m_Codigo = gDB.ValField(rs.fields, cscTjcCodigo)
    m_descrip = gDB.ValField(rs.fields, cscTjcDescrip)
    m_PorcComision = gDB.ValField(rs.fields, cscTjcComision)
    
    m_emp_id = gDB.ValField(rs.fields, cscEmpId)
    m_Empresa = gDB.ValField(rs.fields, cscEmpNombre)
    
    m_cue_id_banco = gDB.ValField(rs.fields, cscCueIdBanco)
    m_cue_id_comision = gDB.ValField(rs.fields, cscCueIdComision)
    m_cue_id_enCartera = gDB.ValField(rs.fields, cscCueIdEnCartera)
    m_cue_id_presentado = gDB.ValField(rs.fields, cscCueIdPresentado)
    m_cue_id_rechazo = gDB.ValField(rs.fields, cscCueIdRechazo)
    
    m_Banco = gDB.ValField(rs.fields, "cuentaBanco")
    m_Comision = gDB.ValField(rs.fields, "cuentaComision")
    m_EnCartera = gDB.ValField(rs.fields, "cuentaEnCartera")
    m_Presentado = gDB.ValField(rs.fields, "cuentaPresentado")
    m_Rechazo = gDB.ValField(rs.fields, "cuentaRechazo")
    
    
    m_Activo = gDB.ValField(rs.fields, cscActivo)
  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_descrip = vbNullString
    m_PorcComision = 0
    
    m_emp_id = csNO_ID
    m_Empresa = vbNullString
    
    m_cue_id_banco = csNO_ID
    m_cue_id_comision = csNO_ID
    m_cue_id_enCartera = csNO_ID
    m_cue_id_presentado = csNO_ID
    m_cue_id_rechazo = csNO_ID
    
    m_Banco = vbNullString
    m_Comision = vbNullString
    m_EnCartera = vbNullString
    m_Presentado = vbNullString
    m_Rechazo = vbNullString
    
    m_Activo = True
  End If
  Load = True
End Function

Private Sub Class_Initialize()
  On Error Resume Next
  c_ErrorSave = LNGGetText(1464, vbNullString) 'Error al grabar Tarjetas de Crédito
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub

'////////////////////////////////////////////////////////////////////////
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
    Case K_CUOTAS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRow(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
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
    Case K_CUOTAS
      Id = Val(pCell(Row, KI_TJCCU_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & Id & C_StrColon
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
    Case K_CUOTAS
      cIABMClientGrid_ValidateRow = pValidateRow(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

'////////////////////////////////////////////////////////////////////////////
Private Function pIsEmptyRow(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CUOTAS
        If Not ValEmpty(Cell.Value, csInteger) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_COMISION
        If Not ValEmpty(Cell.Value, csDouble) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRow = bRowIsEmpty
End Function

Private Function pValidateRow(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CUOTAS
        If ValEmpty(Cell.Value, csInteger) Then
          MsgInfo LNGGetText(1478, vbNullString, strRow)
                'Debe indicar la cantidad de cuotas (1)
          Exit Function
        End If
      Case KI_COMISION
        'If ValEmpty(Cell.Value, csDouble) Then
        '  MsgInfo LNGGetText(1479, vbNullString, strRow)
        '          'Debe indicar la tasa de comisión  (1)
        '  Exit Function
        'End If
        If Val(Cell.Value) < 0 Or Val(Cell.Value) > 200 Then
          MsgInfo LNGGetText(1480, vbNullString, strRow)
                  'El porcentaje esta fuera del rango permitido (0.00 a 200.00) (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRow = True
End Function

Private Function pSaveItems() As Boolean
  Dim register As cRegister
  Dim fields     As cFields
  
  With m_ObjAbm.Properties.Item(c_cuotas)
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscTjccuId
        .Table = csTTarjetaCreditoCuota
        .Id = csNew
      
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_TJCCU_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_CUOTAS
              fields.Add2 cscTjccuCantidad, Val(Cell.Value), csInteger
            Case KI_COMISION
              fields.Add2 cscTjccuComision, Val(Cell.Value), csDouble
          End Select
        Next
      
        fields.Add2 cscTjcId, m_Id, csId
        
        fields.HaveLastUpdate = True
        fields.HaveWhoModify = True
      End With
                                                          
      If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeleted) And Not m_Copy Then
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    sqlstmt = "delete TarjetaCreditoCuota where tjccu_id in (" & m_ItemsDeleted & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItems", C_Module) Then Exit Function
  End If
  
  pSaveItems = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select * from TarjetaCreditoCuota where tjc_id = " _
                & m_Id & " order by tjccu_cantidad"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
  
      .Clear
  
      With .Add(Nothing)
        .Visible = False
        .Key = KI_TJCCU_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1463, vbNullString) 'Cuota
        .PropertyType = cspNumeric
        .SubType = cspInteger
        .Width = 1000
        .Key = KI_CUOTAS
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1091, vbNullString) 'Comisión
        .PropertyType = cspNumeric
        .SubType = cspPercent
        .Width = 1000
        .Key = KI_COMISION
      End With
      
    End With
  
    With .Rows
    
      .Clear
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscTjccuId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscTjccuId).Value
            .Key = KI_TJCCU_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscTjccuCantidad)
            .Key = KI_CUOTAS
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscTjccuComision)
            .Key = KI_COMISION
          End With
          
        End With
        
        rs.MoveNext
      Wend
    
    End With
  End With
  
  pLoadItems = True
End Function
