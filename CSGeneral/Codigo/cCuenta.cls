VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCuenta"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cCuenta
' 02-02-01

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cCuenta"

Private Const K_NOMBRE                    As Integer = 1
Private Const K_CODIGO                    As Integer = 2
Private Const K_ACTIVO                    As Integer = 3
Private Const K_DESCRIPCION               As Integer = 5
Private Const K_LLEVA_CENTRO_COSTO        As Integer = 6
Private Const K_IDENTIFICACIONEXTERNA     As Integer = 8
Private Const K_CATEGORIA                 As Integer = 9
Private Const K_PATRIMONIAL               As Integer = 11
Private Const K_RESULTADO                 As Integer = 12
Private Const K_OTRO                      As Integer = 13
Private Const K_MON_ID                    As Integer = 14
Private Const K_BCO_ID                    As Integer = 15
Private Const K_PRODUCTO                  As Integer = 16
Private Const K_EMP_ID                    As Integer = 18
Private Const K_CODIGO_RPT                As Integer = 19
Private Const K_ES_EFECTIVO               As Integer = 20
Private Const K_ES_TICKET                 As Integer = 21

' estructuras
' variables privadas
Private m_Id                    As Long
Private m_Nombre                As String
Private m_Codigo                As String
Private m_Activo                As Boolean
Private m_CategoriaId           As Long
Private m_Categoria             As String
Private m_Descripcion           As String
Private m_CostoTipo             As Integer
Private m_ValidaPago            As Integer
Private m_SaldoCashFlow         As Currency
Private m_CashFlow              As Integer
Private m_LlevaCentroCosto      As Boolean
Private m_Producto              As Boolean
Private m_IdentificacionExterna As String
Private m_mon_id                As Long
Private m_Moneda                As String
Private m_bco_id                As Long
Private m_Banco                 As String
Private m_emp_id                As Long
Private m_Empresa               As String
Private m_CodigoRPT             As String
Private m_EsEfectivo            As Boolean
Private m_EsTicket              As Boolean

Private m_CategoriaTipo     As csECuentaCategoriaTipo

Private m_Editing     As Boolean

Private m_ObjAbm      As cIABMGeneric
Private m_ObjTree     As Object

Private m_IsNew       As Boolean

Private m_BranchId    As Long
Private m_TreeId      As Long

Private m_Host        As CSMenu.cIMenuHost
Private m_Copy        As Boolean

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
  
  With m_ObjAbm.Properties(cscCueCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscCueNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscCueCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscCueNombre)
  
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

  Doc.ClientTable = csTCuenta
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
                               csPreGNewCuenta
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
  cIABMClient_PropertyChange = True
  
  With m_ObjAbm.Properties
  
    Select Case Key
        
      Case K_OTRO
      
        If Val(.Item("OTROS").Value) Then
        
          .Item(cscCuecId).HelpFilter = "cuec_tipo = " & csETCuecOtro
          
          Select Case .Item(cscCuecId).HelpId
            Case csECuecOtros
              ' Todo bien
            Case Else
              LimpiarCategorias
          End Select
        End If
        
      Case K_PATRIMONIAL
      
        If Val(.Item("PATRIMONIAL").Value) Then
          
          .Item(cscCuecId).HelpFilter = "cuec_tipo = " & csETCuecPatrimonial
          
          Select Case .Item(cscCuecId).HelpId
            Case csECuecDocEnCartera, csECuecBancos, csECuecPatrimoniales, csECuecDeudPorVentas, csECuecBienesDeUso, csECuecBienesDeCambio, csECuecCuentasFiscales, csECuecAcreedores, csECuecCaja, csECuecDepositoCupones
              ' Todo bien
            Case Else
              LimpiarCategorias
          End Select
        End If
      
      Case K_RESULTADO
        
        If Val(.Item("RESULTADO").Value) Then
          
          .Item(cscCuecId).HelpFilter = "cuec_tipo = " & csETCuecResultado
          
          Select Case .Item(cscCuecId).HelpId
            Case csECuecCostoMercVend, csECuecEgresos, csECuecIngresos
              ' Todo bien
            Case Else
              LimpiarCategorias
          End Select
        End If
    End Select
    
    .Item(cscBcoId).Enabled = .Item(cscCuecId).HelpId = csECuecBancos
  End With
  
End Function

Private Sub LimpiarCategorias()
  
  With m_ObjAbm.Properties
    .Item(cscCuecId).HelpId = csNO_ID
    .Item(cscCuecId).HelpValueProcess = vbNullString
    .Item(cscCuecId).Value = vbNullString
  End With
  
  m_ObjAbm.RefreshControls
End Sub

Private Function cIABMClient_Save() As Boolean
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscCueId
    .Table = csTCuenta
  
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
          fields.Add2 cscCueNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscCueCodigo, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, Val(.Value), csBoolean
        Case K_DESCRIPCION
          fields.Add2 cscCueDescrip, .Value, csText
        Case K_MON_ID
          fields.Add2 cscMonId, .HelpId, csId
        Case K_EMP_ID
          fields.Add2 cscEmpId, .HelpId, csId
        Case K_BCO_ID
          fields.Add2 cscBcoId, .HelpId, csId
        Case K_PRODUCTO
          fields.Add2 cscCueProducto, Val(.Value), csBoolean
        Case K_LLEVA_CENTRO_COSTO
          fields.Add2 cscCueLlevaCentroCosto, Val(.Value), csBoolean
        Case K_IDENTIFICACIONEXTERNA
          fields.Add2 cscCueIdentificacionExterna, .Value, csText
        Case K_CATEGORIA
          fields.Add2 cscCuecId, Val(.HelpId), csId
        Case K_CODIGO_RPT
          fields.Add2 cscCueCodigoRPT, .Value, csText
        Case K_ES_EFECTIVO
          fields.Add2 cscCueEsEfectivo, .Value, csBoolean
        Case K_ES_TICKET
          fields.Add2 cscCueEsTicket, .Value, csBoolean
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not gDB.SaveEx(register, , _
                    cscCueCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    LNGGetText(1106, vbNullString)) Then Exit Function
  
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
  cIABMClient_Title = LNGGetText(1107, vbNullString)  'Cuentas
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IProperty As cIABMProperty
  Dim bBcoEmpty As Boolean
  Dim bHaveBco  As Boolean
  
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
        Case K_MON_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1108, vbNullString)  'Debe indicar una moneda
            Exit Function
          End If
        Case K_BCO_ID
          If ValEmpty(.HelpId, csId) Then
            bBcoEmpty = True
          End If
        Case K_CATEGORIA
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1109, vbNullString)  'Debe indicar una categoría
            Exit Function
          End If
          bHaveBco = .HelpId = csECuecBancos
      End Select
    End With
  Next
  
  If bBcoEmpty And bHaveBco Then
    MsgInfo LNGGetText(1110, vbNullString)  'Debe indicar un banco
    Exit Function
  End If
  
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreGListCuenta)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  If Not SecurityCanAccess(csPreGDeleteCuenta) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "delete Cuenta where cue_id = " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewCuenta) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditCuenta) Then Exit Function
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
  
  m_Host.Server.AddMenu C_MenuContabilidad, csMenuConfigContabilidad, C_MenuConfig, 0, True, False, True, False, True, Nothing
                          '&Cuentas
  m_Host.Server.AddMenu LNGGetText(1111, vbNullString), csPreGListCuenta, C_MenuContabilidad, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                 'Cuentas
  m_Host.MenuABMClick "CSGeneral2.cCuenta", Me, LNGGetText(1107, vbNullString), 0, csETablasGeneral.csCuenta
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  m_ObjAbm.Title2 = m_Nombre
  
  With m_ObjAbm.Properties
    
    .Clear
  
    With .Add(Nothing, cscCueNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Width = 5000
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
    End With
      
    With .Add(Nothing, cscCueCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 15
      .Value = m_Codigo
      .Key = K_CODIGO
    End With
    
    With .Add(Nothing, cscCueIdentificacionExterna)
      .PropertyType = cspText
      .TopNotChange = True
      .Name = LNGGetText(1112, vbNullString) 'Identificación Externa
      .Key = K_IDENTIFICACIONEXTERNA
      .Value = m_IdentificacionExterna
    End With
    
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .TopFromProperty = cscCueNombre
      .LeftFromProperty = cscCueNombre
      .LeftToPrevious = 5900
      .LeftLabel = -700
      .LeftNotChange = True
      .TopNotChange = True
      .Width = 400
      .LeftNotChange = True
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
      
    With .Add(Nothing, cscMonId)
      .PropertyType = cspHelp
      .TopFromProperty = cscCueCodigo
      .LeftFromProperty = cscCueCodigo
      .LeftToPrevious = 4230
      .Table = csMoneda
      .Name = LNGGetText(1113, vbNullString) 'Moneda
      .Key = K_MON_ID
      .HelpId = m_mon_id
      .Value = m_Moneda
    End With
      
    With .Add(Nothing, cscEmpId)
      .PropertyType = cspHelp
      .TopToPrevious = 880
      .Table = csEmpresa
      .Name = LNGGetText(1114, vbNullString) 'Empresa
      .Key = K_EMP_ID
      .HelpId = m_emp_id
      .Value = m_Empresa
    End With
    
    With .Add(Nothing, cscCueLlevaCentroCosto)
      .PropertyType = cspCheck
      .TopFromProperty = cscCueCodigo
      .TopToPrevious = 440
      .LeftFromProperty = cscCueCodigo
      .LeftToPrevious = 6300
      .LeftLabel = -1750
      .LeftNotChange = True
      .TopNotChange = True
      .Name = LNGGetText(1115, vbNullString) 'Exije centro de costo
      .Key = K_LLEVA_CENTRO_COSTO
      .Value = CInt(m_LlevaCentroCosto)
    End With
    
    With .Add(Nothing, cscCueProducto)
      .PropertyType = cspCheck
      .TopFromProperty = cscCueLlevaCentroCosto
      .TopToPrevious = 440
      .LeftFromProperty = cscCueCodigo
      .LeftToPrevious = 6300
      .LeftLabel = -1750
      .LeftNotChange = True
      .TopNotChange = True
      .Name = LNGGetText(1116, vbNullString) 'Elegible para producto
      .Key = K_PRODUCTO
      .Value = CInt(m_Producto)
    End With
    
    With .Add(Nothing, cscCueEsEfectivo)
      .PropertyType = cspCheck
      .Name = LNGGetText(4918, vbNullString) 'Es Efectivo
      .Size = 15
      .Value = CInt(m_EsEfectivo)
      .Key = K_ES_EFECTIVO
    
      .TopFromProperty = cscCueProducto
      .TopToPrevious = 440
      .LeftFromProperty = cscCueCodigo
      .LeftToPrevious = 6300
      .LeftLabel = -1750
      .LeftNotChange = True
      .TopNotChange = True
    End With
    
    With .Add(Nothing, cscCueEsTicket)
      .PropertyType = cspCheck
      .Name = LNGGetText(4919, vbNullString) 'Es Ticket
      .Size = 15
      .Value = CInt(m_EsTicket)
      .Key = K_ES_TICKET
    
      .TopFromProperty = cscCueEsEfectivo
      .TopToPrevious = 440
      .LeftFromProperty = cscCueCodigo
      .LeftToPrevious = 6300
      .LeftLabel = -1750
      .LeftNotChange = True
      .TopNotChange = True
    End With
    
    With .Add(Nothing, "PATRIMONIAL")
      .PropertyType = cspOption
      .OptionGroup = 0
      .Name = LNGGetText(1117, vbNullString) 'Patrimonial
      .Key = K_PATRIMONIAL
      .Value = 0
    End With
    
    With .Add(Nothing, "RESULTADO")
      .PropertyType = cspOption
      .TopToPrevious = 300
      .OptionGroup = 0
      .Name = LNGGetText(1118, vbNullString) 'Resultado
      .Key = K_RESULTADO
      .Value = 0
    End With
    
    With .Add(Nothing, "OTROS")
      .PropertyType = cspOption
      .TopToPrevious = 300
      .OptionGroup = 0
      .Name = LNGGetText(1119, vbNullString) 'Otros
      .Key = K_OTRO
      .Value = 0
      .TopFrame = 2800
    End With
  
    With .Add(Nothing, cscCuecId)
      .PropertyType = cspHelp
      .LeftFromProperty = cscCueIdentificacionExterna
      .TopFromProperty = cscCueIdentificacionExterna
      .TopToPrevious = 900
      .LeftToPrevious = 2000
      .Table = csCuentaCategoria
      .Name = LNGGetText(1120, vbNullString) 'Categoría
      .Key = K_CATEGORIA
      .Value = m_Categoria
      .HelpId = m_CategoriaId
    End With
      
    Select Case m_CategoriaTipo
      
      Case csETCuecOtro
        .Item("OTROS").Value = 1
        .Item(cscCuecId).HelpFilter = "cuec_tipo = " & csETCuecOtro
      
      Case csETCuecPatrimonial
        .Item("PATRIMONIAL").Value = 1
        .Item(cscCuecId).HelpFilter = "cuec_tipo = " & csETCuecPatrimonial
      
      Case csETCuecResultado
        .Item("RESULTADO").Value = 1
        .Item(cscCuecId).HelpFilter = "cuec_tipo = " & csETCuecResultado
        
      Case Else
        .Item("PATRIMONIAL").Value = 1
        .Item(cscCuecId).HelpFilter = "cuec_tipo = " & csETCuecPatrimonial
    
    End Select
          
    With .Add(Nothing, cscBcoId)
      .PropertyType = cspHelp
      .Table = csBanco
      .LeftFromProperty = cscCuecId
      .Name = LNGGetText(1122, vbNullString) 'Banco
      .Key = K_BCO_ID
      .HelpId = m_bco_id
      .Value = m_Banco
      .Enabled = m_CategoriaId = csECuecBancos
    End With
    
    With .Add(Nothing, cscCueCodigoRPT)
      .PropertyType = cspText
      .Name = LNGGetText(4839, vbNullString) 'Codigo RPT
      .Size = 15
      .Value = m_CodigoRPT
      .Key = K_CODIGO_RPT
    End With
        
    With .Add(Nothing, cscCuecDescrip)
      .PropertyType = cspText
      .LeftFromProperty = cscCueNombre
      .TopFromProperty = cscCueCodigo
      .TopToPrevious = 2600
      .Height = 640
      .Width = 6100
      .SubType = cspMemo
      .Name = C_strDescrip
      .Key = K_DESCRIPCION
      .Value = m_Descripcion
    End With
  
  End With
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  AbmObj.MinHeight = 6000
  
  If Not m_ObjAbm.Show(Me) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_cuentaGet " & Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
  
  If rs.EOF Then
    m_Activo = True
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Id = csNO_ID
    m_Descripcion = vbNullString
    m_IdentificacionExterna = vbNullString
    m_Categoria = vbNullString
    m_CategoriaId = csNO_ID
    m_mon_id = csNO_ID
    m_Moneda = vbNullString
    m_bco_id = csNO_ID
    m_Banco = vbNullString
    m_emp_id = csNO_ID
    m_Empresa = vbNullString
    m_CategoriaTipo = csETCuecPatrimonial
    m_LlevaCentroCosto = False
    m_Producto = False
    m_CodigoRPT = vbNullString
    m_EsEfectivo = False
    m_EsTicket = False
  
  Else
  
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_Nombre = gDB.ValField(rs.fields, cscCueNombre)
    m_Codigo = gDB.ValField(rs.fields, cscCueCodigo)
    m_Id = gDB.ValField(rs.fields, cscCueId)
    m_Descripcion = gDB.ValField(rs.fields, cscCueDescrip)
    m_IdentificacionExterna = gDB.ValField(rs.fields, cscCueIdentificacionExterna)
    m_Categoria = gDB.ValField(rs.fields, cscCuecNombre)
    m_CategoriaId = gDB.ValField(rs.fields, cscCuecId)
    m_mon_id = gDB.ValField(rs.fields, cscMonId)
    m_Moneda = gDB.ValField(rs.fields, cscMonNombre)
    m_bco_id = gDB.ValField(rs.fields, cscBcoId)
    m_Banco = gDB.ValField(rs.fields, cscBcoNombre)
    m_CategoriaTipo = gDB.ValField(rs.fields, cscCuecTipo)
    m_LlevaCentroCosto = gDB.ValField(rs.fields, cscCueLlevaCentroCosto)
    m_Producto = gDB.ValField(rs.fields, cscCueProducto)
    m_emp_id = gDB.ValField(rs.fields, cscEmpId)
    m_Empresa = gDB.ValField(rs.fields, cscEmpNombre)
    m_CodigoRPT = gDB.ValField(rs.fields, cscCueCodigoRPT)
    m_EsEfectivo = gDB.ValField(rs.fields, cscCueEsEfectivo)
    m_EsTicket = gDB.ValField(rs.fields, cscCueEsTicket)
  End If
  
  Load = True
End Function

Private Function BancoEnabled() As Boolean
  BancoEnabled = csECuecDocEnCartera = m_CategoriaId Or csECuecDepositoCupones = m_CategoriaId
End Function
Private Function LibroIvaEnabled() As Boolean
  LibroIvaEnabled = (csECuecBienesDeCambio = m_CategoriaId) Or (csECuecBienesDeUso = m_CategoriaId) Or (csECuecIngresos = m_CategoriaId) Or (csECuecEgresos = m_CategoriaId)
End Function
Private Function ProveedorEnabled() As Boolean
  ProveedorEnabled = csECuecBancos = m_CategoriaId
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub

