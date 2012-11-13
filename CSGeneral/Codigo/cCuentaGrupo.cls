VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCuentaGrupo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cCuentaGrupo
' 16-02-03

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cCuentaGrupo"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_CUE_ID                         As Integer = 4
Private Const K_ACTIVO                         As Integer = 5
Private Const K_TIPO                           As Integer = 6
' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_descrip                      As String
Private m_Cue_id                       As Long
Private m_Cuenta                       As String
Private m_Tipo                         As csE_CuentaGrupoTipo
Private m_Activo                       As Boolean

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long
Private m_Copy              As Boolean

Private m_Host              As CSMenu.cIMenuHost

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

  Doc.ClientTable = csTCuentaGrupo
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, C_ShowDocDigital, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_EditNew() As Boolean

  cIABMClient_Terminate
  m_IsNew = True

  cIEditGeneric_Edit csNO_ID
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  Select Case MessageID
  
    Case MSG_DOC_INFO
    
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      
      CSKernelClient2.ShowHelp AbmGen.hWnd, _
                               vbNullString, _
                               vbNullString, _
                               csPreGNewCuentaGrupo
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    Case Else
      cIABMClient_MessageEx = True
  End Select
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True

  With m_ObjAbm.Properties(cscCuegCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscCuegNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscCuegCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscCuegNombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  Select Case Key
    Case K_TIPO

      With m_ObjAbm.Properties
        .Item(cscCueId).HelpFilter = GetCtaGrupoFilter( _
                                       .Item(cscCuegTipo).ListItemData)
        m_ObjAbm.ShowValue .Item(cscCueId)
      End With
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscCuegId
    .Table = csTCuentaGrupo
    
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
          fields.Add2 cscCuegNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscCuegCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscCuegDescrip, .Value, csText
        Case K_CUE_ID
          fields.Add2 cscCueId, .HelpId, csId
        Case K_TIPO
          fields.Add2 cscCuegTipo, .ListItemData, csInteger
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
                                                         'Error al grabar grupos de cuenta
  If Not gDB.SaveEx(register, , _
                    cscCuegCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    LNGGetText(1123, vbNullString)) Then Exit Function
  
  m_Copy = False
  cIABMClient_Save = Load(register.Id)
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
                       'Grupos de cuentas
  cIABMClient_Title = LNGGetText(1124, vbNullString)
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
      End Select
    End With
  Next

  If Not pValidateTipo() Then Exit Function

  cIABMClient_Validate = True
End Function

Private Function pValidateTipo() As Boolean
  Dim Tipo    As csE_CuentaGrupoTipo
  Dim cuec_id As Long
  Dim Cue_id  As Long
  
  With m_ObjAbm.Properties
    Cue_id = .Item(cscCueId).HelpId
    Tipo = .Item(cscCuegTipo).ListItemData
  End With
  
  cuec_id = GetCuecIdFromCueId(Cue_id)
  
  Select Case Tipo
    Case csECuecTipoAcreedor
      If cuec_id <> csECuecAcreedores And cuec_id <> csECuecBancos Then
        MsgInfo LNGGetText(3529, vbNullString) 'La cuenta debe ser de tipo acreedor por compras o banco.
        Exit Function
      End If
      
    Case csECuecTipoDeudor
      If cuec_id <> csECuecDeudPorVentas Then
        MsgInfo LNGGetText(3530, vbNullString) 'La cuenta debe ser de tipo deudor por ventas.
        Exit Function
      End If
      
    Case csECuecTipoProductoVenta
      If cuec_id <> csECuecIngresos And cuec_id <> csECuecEgresos Then
        If pCuentaForProducto(Cue_id) = False Then
          MsgInfo LNGGetText(3531, vbNullString) 'La cuenta debe ser de tipo ingresos, o egresos o estar marcada como elegible para productos.
          Exit Function
        End If
      End If
      
    Case csECuecTipoProductoCompra
      If cuec_id <> csECuecBienesDeUso _
         And cuec_id <> csECuecBienesDeCambio _
         And cuec_id <> csECuecIngresos _
         And cuec_id <> csECuecEgresos Then
        
        If pCuentaForProducto(Cue_id) = False Then
        
          MsgInfo LNGGetText(3532, vbNullString) 'La cuenta debe ser de tipo bienes de cambio, o bienes de uso, o estar marcada como elegible para productos.
          Exit Function
        End If
      End If
    
    Case csECuecTipoDebitoAutomatico
      If cuec_id <> csECuecBancos Then
        MsgInfo LNGGetText(3571, vbNullString) 'La cuenta debe ser de tipo banco
        Exit Function
      End If
    
    Case csECuecTipoFondoFijo
      If cuec_id <> csECuecCaja Then
        MsgInfo LNGGetText(3572, vbNullString) 'La cuenta debe ser de tipo caja
        Exit Function
      End If
    
    Case Else
      MsgInfo LNGGetText(3533, vbNullString) 'Debe seleccionar un tipo de grupo de cuenta.
      Exit Function
  End Select
  pValidateTipo = True
End Function

Private Function pCuentaForProducto(ByVal Cue_id As Long) As Boolean
  If Cue_id <> csNO_ID Then
    Dim bProducto As Boolean
    If Not gDB.GetData(csTCuenta, _
                       cscCueId, _
                       Cue_id, _
                       cscCueProducto, _
                       bProducto) Then Exit Function
    pCuentaForProducto = bProducto
  Else
    pCuentaForProducto = False
  End If
End Function

' Implementacion de cIEditGeneric

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal rhs As Long)
    m_TreeId = rhs
End Property

Private Property Get cIEditGeneric_TreeId() As Long
    cIEditGeneric_TreeId = m_TreeId
End Property

Private Function cIEditGeneric_GridAdd(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListCuentaGrupo)
End Function

Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreGDeleteCuentaGrupo) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "delete CuentaGrupo where cueg_id = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  Screen.MousePointer = vbDefault
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewCuentaGrupo) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditCuentaGrupo) Then Exit Function
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

' Menu

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
  m_Host.Server.AddMenu C_MenuContabilidad, csMenuConfigContabilidad, C_MenuConfig, 0, True, False, True, False, True, Nothing
                          '&Grupos de Cuentas
  m_Host.Server.AddMenu LNGGetText(1125, vbNullString), csPreGListCuentaGrupo, C_MenuContabilidad, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                      'Grupos de Cuentas
  m_Host.MenuABMClick "CSGeneral2.cCuentaGrupo", Me, LNGGetText(1124, vbNullString), 0, csETablasGeneral.csCuentaGrupo
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  m_ObjAbm.Title2 = m_Nombre

  With m_ObjAbm.Properties
      
    .Clear
      
    With .Add(Nothing, cscCuegNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Width = 6000
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
      .Width = 6000
    End With
    
    With .Add(Nothing, cscCuegCodigo)
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
    
    With .Add(Nothing, cscCuegTipo)
      .PropertyType = cspList
      .Name = LNGGetText(1223, vbNullString) 'Tipo
      .ListWhoSetItem = csListItemData
      .ListItemData = m_Tipo
      With .List
        With .Add(Nothing)
          .Id = csE_CuentaGrupoTipo.csECuecTipoAcreedor
          .Value = LNGGetText(3534, vbNullString) 'Acreedor
        End With
        With .Add(Nothing)
          .Id = csE_CuentaGrupoTipo.csECuecTipoDeudor
          .Value = LNGGetText(3535, vbNullString) 'Deudor
        End With
        With .Add(Nothing)
          .Id = csE_CuentaGrupoTipo.csECuecTipoProductoCompra
          .Value = LNGGetText(3536, vbNullString) 'Articulos de Compra
        End With
        With .Add(Nothing)
          .Id = csE_CuentaGrupoTipo.csECuecTipoProductoVenta
          .Value = LNGGetText(3537, vbNullString) 'Articulos de Venta
        End With
        With .Add(Nothing)
          .Id = csE_CuentaGrupoTipo.csECuecTipoDebitoAutomatico
          .Value = LNGGetText(3569, vbNullString) 'Debito Automatico
        End With
        With .Add(Nothing)
          .Id = csE_CuentaGrupoTipo.csECuecTipoFondoFijo
          .Value = LNGGetText(3570, vbNullString) 'Fondo Fijo
        End With
      End With
      .Key = K_TIPO
    End With
    
    With .Add(Nothing, cscCueId)
      .PropertyType = cspHelp
      .Table = csCuenta
      .Width = 6000
      .Name = LNGGetText(1126, vbNullString)   'Cuenta por defecto
      .Key = K_CUE_ID
      .Value = m_Cuenta
      .HelpId = m_Cue_id
      .HelpFilter = GetCtaGrupoFilter(m_Tipo)
    End With
    
    With .Add(Nothing, cscCuegDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Height = 880
      .Width = 6000
      .Name = C_strDescrip
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_descrip
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As Recordset

  sqlstmt = "select cueg.*,cue_nombre" & _
            " from CuentaGrupo cueg left join Cuenta cue" & _
                 " on cueg.cue_id = cue.cue_id" & _
            " where cueg_id = " & Id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscCuegId)
    m_Nombre = gDB.ValField(rs.fields, cscCuegNombre)
    m_Codigo = gDB.ValField(rs.fields, cscCuegCodigo)
    m_descrip = gDB.ValField(rs.fields, cscCuegDescrip)
    m_Cue_id = gDB.ValField(rs.fields, cscCueId)
    m_Cuenta = gDB.ValField(rs.fields, cscCueNombre)
    m_Tipo = gDB.ValField(rs.fields, cscCuegTipo)
    m_Activo = gDB.ValField(rs.fields, cscActivo)

  Else
  
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_descrip = vbNullString
    m_Cue_id = csNO_ID
    m_Cuenta = vbNullString
    m_Tipo = csECuecTipoAcreedor
    m_Activo = True

  End If

  Load = True
End Function
' construccion - destruccion

Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
