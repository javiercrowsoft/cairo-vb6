VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProveedor"
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
' cProveedor
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
Private Const C_Module = "cProveedor"

Private Const c_retencion = "retencion"
Private Const c_cuentagrupo = "CuentaGrupo"
Private Const c_cais = "CAIS"
Private Const c_empresas = "Empresas"
Private Const c_dpto = "Departamentos"
Private Const c_ccos = "Centros de Costo"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_CONTACTO                       As Integer = 4
Private Const K_RAZONSOCIAL                    As Integer = 5
Private Const K_CUIT                           As Integer = 6
Private Const K_INGRESOSBRUTOS                 As Integer = 7
Private Const K_CATFISCAL                      As Integer = 8
Private Const K_CHEQUEORDEN                    As Integer = 9
Private Const K_CODPOSTAL                      As Integer = 10
Private Const K_LOCALIDAD                      As Integer = 11
Private Const K_CALLE                          As Integer = 12
Private Const K_CALLENUMERO                    As Integer = 13
Private Const K_PISO                           As Integer = 14
Private Const K_DEPTO                          As Integer = 15
Private Const K_TEL                            As Integer = 16
Private Const K_FAX                            As Integer = 17
Private Const K_EMAIL                          As Integer = 18
Private Const K_WEB                            As Integer = 19
Private Const K_PRO_ID                         As Integer = 20
Private Const K_ZON_ID                         As Integer = 21
Private Const K_CPG_ID                         As Integer = 22
Private Const K_ACTIVO                         As Integer = 23
Private Const K_IMPRIMETICKET                  As Integer = 24
Private Const K_CAIS                           As Integer = 26
Private Const K_LP_ID                          As Integer = 27
Private Const K_LD_ID                          As Integer = 28
Private Const K_CUENTAGRUPO                    As Integer = 34
Private Const K_RETENCION                      As Integer = 35
Private Const K_EMPRESAS                       As Integer = 36
Private Const K_DEPARTAMENTOS                  As Integer = 37
Private Const K_CENTROS_DE_COSTO               As Integer = 56

Private Const K_CREDITOCTACTE                  As Integer = 38
Private Const K_CREDITOTOTAL                   As Integer = 39
Private Const K_CREDITOACTIVO                  As Integer = 40

Private Const K_BANCO                          As Integer = 41
Private Const K_NROCTA                         As Integer = 42
Private Const K_CBU                            As Integer = 43
Private Const K_NROCLIENTE                     As Integer = 44

Private Const K_HORARIO_M_DESDE                As Integer = 52
Private Const K_HORARIO_M_HASTA                As Integer = 53
Private Const K_HORARIO_T_DESDE                As Integer = 54
Private Const K_HORARIO_T_HASTA                As Integer = 55

Private Const KI_PROVC_ID                       As Integer = 1
Private Const KI_NUMERO                         As Integer = 2
Private Const KI_DESCRIP                        As Integer = 3
Private Const KI_FECHAVTO                       As Integer = 4
Private Const KI_ACTIVO                         As Integer = 6
Private Const KI_SUCURSAL                       As Integer = 7

Private Const KI_CUEG_ID                        As Integer = 2
Private Const KI_PROVCUEG_ID                    As Integer = 3
Private Const KI_CUE_ID                         As Integer = 4

Private Const KI_PROVRET_ID                     As Integer = 1
Private Const KI_RETT_ID                        As Integer = 2
Private Const KI_RET_ID                         As Integer = 3
Private Const KI_RET_DESDE                      As Integer = 4
Private Const KI_RET_HASTA                      As Integer = 5

Private Const KI_EMPPROV_ID                     As Integer = 1
Private Const KI_EMP_ID                         As Integer = 2

Private Const KI_DPTOPROV_ID                    As Integer = 1
Private Const KI_DPTO_ID                        As Integer = 2

Private Const KI_PROVCCOS_ID                    As Integer = 1
Private Const KI_CCOS_ID                        As Integer = 2
Private Const KI_PR_ID                          As Integer = 3

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_Contacto                     As String
Private m_descrip                      As String
Private m_Razonsocial                  As String
Private m_Cuit                         As String
Private m_Ingresosbrutos               As String
Private m_CatFiscal                    As Integer
Private m_Chequeorden                  As String
Private m_Codpostal                    As String
Private m_Localidad                    As String
Private m_Calle                        As String
Private m_Callenumero                  As String
Private m_Piso                         As String
Private m_Depto                        As String
Private m_Tel                          As String
Private m_Fax                          As String
Private m_Email                        As String
Private m_Web                          As String
Private m_pro_id                       As Long
Private m_Zon_id                       As Long
Private m_Cpg_id                       As Long
Private m_CondicionPago                As String
Private m_provincia                    As String
Private m_Zona                         As String
Private m_Activo                       As Boolean
Private m_ImprimeTicket                As Boolean
Private m_Lp_id                        As Long
Private m_ListaPrecio                  As String
Private m_Ld_id                        As Long
Private m_ListaDescuento               As String

Private m_nroctabanco                  As String
Private m_Banco                        As String
Private m_cbu                          As String
Private m_nrocliente                   As String

Private m_horario_m_desde  As Date
Private m_horario_m_hasta  As Date
Private m_horario_t_desde  As Date
Private m_horario_t_hasta  As Date

Private m_Creditoctacte    As Double
Private m_Creditototal     As Double
Private m_Creditoactivo    As Boolean

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

Private m_ItemsDeletedCAIS            As String
Private m_ItemsDeletedCuentaGrupo     As String
Private m_ItemsDeletedRetenciones     As String
Private m_ItemsDeletedDptos           As String
Private m_ItemsDeletedCcos            As String

Private m_GenericEdit       As cGenericEdit

' propiedades publicas
Public Property Get Id() As Long
  Id = m_Id
End Property
'
Public Property Let Id(ByVal rhs As Long)
  m_Id = rhs
End Property
'
Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Let Nombre(ByVal rhs As String)
  m_Nombre = rhs
End Property
'
Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property

Public Property Let Codigo(ByVal rhs As String)
  m_Codigo = rhs
End Property

Public Property Let Razonsocial(ByVal rhs As String)
  m_Razonsocial = rhs
End Property

Public Property Get Cuit() As String
  Cuit = m_Cuit
End Property

Public Property Let Cuit(ByVal rhs As String)
  m_Cuit = rhs
End Property

Public Property Let Catfiscal(ByVal rhs As Integer)
  m_CatFiscal = rhs
End Property

Public Property Let Activo(ByVal rhs As Boolean)
  m_Activo = rhs
End Property

' propiedades privadas
' funciones publicas
Public Function Save(Optional ByVal ReLoad As Boolean) As Boolean
  Dim register As cRegister
  Set register = New cRegister
  
  With register
    .fieldId = cscProvId
    .Table = csTProveedor
    
    If m_Copy Then
      .Id = csNew
    Else
      .Id = m_Id
    End If
    
    With .fields
      .Add2 cscProvNombre, m_Nombre, csText
      .Add2 cscProvCodigo, m_Codigo, csText
      .Add2 cscProvContacto, m_Contacto, csText
      .Add2 cscProvRazonsocial, m_Razonsocial, csText
      .Add2 cscProvCuit, m_Cuit, csText
      .Add2 cscProvIngresosbrutos, m_Ingresosbrutos, csText
      .Add2 cscProvCatfiscal, m_CatFiscal, csInteger
      .Add2 cscProvChequeorden, m_Chequeorden, csText
      .Add2 cscProvCodpostal, m_Codpostal, csText
      .Add2 cscProvLocalidad, m_Localidad, csText
      .Add2 cscProvCalle, m_Calle, csText
      .Add2 cscProvCallenumero, m_Callenumero, csText
      .Add2 cscProvPiso, m_Piso, csText
      .Add2 cscProvDepto, m_Depto, csText
      .Add2 cscProvTel, m_Tel, csText
      .Add2 cscProvFax, m_Fax, csText
      .Add2 cscProvEmail, m_Email, csText
      .Add2 cscProvWeb, m_Web, csText
      .Add2 cscProId, m_pro_id, csId
      .Add2 cscZonId, m_Zon_id, csId
      .Add2 cscActivo, m_Activo, csBoolean
      
      .HaveLastUpdate = True
      .HaveWhoModify = True
    End With
  End With
                                                'Error al grabar Proveedor
  If Not gDB.SaveEx(register, , _
                    cscProvCodigo, _
                    "Save", _
                    C_Module, _
                    LNGGetText(1377, vbNullString)) Then Exit Function
  
  m_Id = register.Id
  
  If ReLoad Then
    Save = Load(m_Id)
  Else
    Save = True
  End If
End Function

Public Function UpdateCAI(ByRef Properties As cIABMProperties) As Boolean
  Dim register As cRegister
  Dim fields   As cFields
  Dim IProperty As cIABMProperty
  
  Set register = New cRegister
  With register
    Set fields = .fields
    .fieldId = cscProvcId
    .Table = csTProveedorCAI
    .Id = csNew
    
    For Each IProperty In Properties
      With IProperty
        Select Case .Key
          Case KI_PROVC_ID
            register.Id = Val(.Value)
          Case KI_NUMERO
            fields.Add2 cscProvcNumero, .Value, csText
          Case KI_DESCRIP
            fields.Add2 cscProvcDescrip, .Value, csText
          Case KI_FECHAVTO
            fields.Add2 cscProvcFechavto, .Value, csDate
          Case KI_ACTIVO
            fields.Add2 cscActivo, .Value, csBoolean
          Case KI_SUCURSAL
            fields.Add2 cscProvcSucursal, .Value, csText
        End Select
      End With
    Next
    
    fields.Add2 cscProvId, m_Id, csId
    
    fields.HaveLastUpdate = True
    fields.HaveWhoModify = True
  End With
                                                          'Error al grabar CAI
  If Not gDB.Save(register, , "pSaveItemsCAIS", C_Module, LNGGetText(1377, vbNullString)) Then Exit Function
  
  Dim sqlstmt As String
  
  UpdateCAI = True
End Function

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscProvCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscProvNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscProvCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscProvNombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  If Not pValidateAccessNewEdit(csNO_ID) Then Exit Function
  
  Load csNO_ID
  pRefreshProperties
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

  Doc.ClientTable = csTProveedor
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
                               csPreGNewProveedor
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    
    Case MSG_DOC_REFRESH
      pRefreshProperties
    
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
  Dim register   As cRegister
  Dim fields     As cFields
  Dim LastId     As Long
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscProvId
    .Table = csTProveedor
  
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
          fields.Add2 cscProvNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscProvCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscProvDescrip, .Value, csText
        Case K_CPG_ID
          fields.Add2 cscCpgId, .HelpId, csId
        Case K_CONTACTO
          fields.Add2 cscProvContacto, .Value, csText
        Case K_RAZONSOCIAL
          fields.Add2 cscProvRazonsocial, .Value, csText
        Case K_CUIT
          fields.Add2 cscProvCuit, .Value, csText
        Case K_INGRESOSBRUTOS
          fields.Add2 cscProvIngresosbrutos, .Value, csText
        Case K_CATFISCAL
          fields.Add2 cscProvCatfiscal, .ListItemData, csInteger
        Case K_CHEQUEORDEN
          fields.Add2 cscProvChequeorden, .Value, csText
        Case K_CODPOSTAL
          fields.Add2 cscProvCodpostal, .Value, csText
        Case K_LOCALIDAD
          fields.Add2 cscProvLocalidad, .Value, csText
        Case K_CALLE
          fields.Add2 cscProvCalle, .Value, csText
        Case K_CALLENUMERO
          fields.Add2 cscProvCallenumero, .Value, csText
        Case K_PISO
          fields.Add2 cscProvPiso, .Value, csText
        Case K_DEPTO
          fields.Add2 cscProvDepto, .Value, csText
        Case K_TEL
          fields.Add2 cscProvTel, .Value, csText
        Case K_FAX
          fields.Add2 cscProvFax, .Value, csText
        Case K_EMAIL
          fields.Add2 cscProvEmail, .Value, csText
        Case K_WEB
          fields.Add2 cscProvWeb, .Value, csText
        Case K_PRO_ID
          fields.Add2 cscProId, .HelpId, csId
        Case K_ZON_ID
          fields.Add2 cscZonId, .HelpId, csId
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
        Case K_IMPRIMETICKET
          fields.Add2 cscProvImprimeTicket, .Value, csBoolean
        Case K_LP_ID
          fields.Add2 cscLpId, .HelpId, csId
        Case K_LD_ID
          fields.Add2 cscLdId, .HelpId, csId
        Case K_CREDITOCTACTE
          fields.Add2 cscProvCreditoctacte, .Value, csCurrency
        Case K_CREDITOTOTAL
          fields.Add2 cscProvCreditototal, .Value, csCurrency
        Case K_CREDITOACTIVO
          fields.Add2 cscProvCreditoactivo, .Value, csBoolean
        Case K_BANCO
          fields.Add2 cscProvBanco, .Value, csText
        Case K_NROCTA
          fields.Add2 cscProvNroCtaBanco, .Value, csText
        Case K_CBU
          fields.Add2 cscProvCBU, .Value, csText
        Case K_NROCLIENTE
          fields.Add2 cscProvNroCliente, .Value, csText
      
        Case K_HORARIO_M_DESDE
          fields.Add2 cscProvHorarioMdesde, .Value, csDate
        Case K_HORARIO_M_HASTA
          fields.Add2 cscProvHorarioMhasta, .Value, csDate
        Case K_HORARIO_T_DESDE
          fields.Add2 cscProvHorarioTdesde, .Value, csDate
        Case K_HORARIO_T_HASTA
          fields.Add2 cscProvHorarioThasta, .Value, csDate
      
      End Select
    End With
  Next
  
  If Not m_GenericEdit.Save(m_ObjAbm, register) Then Exit Function
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function

  If Not gDB.SaveEx(register, , _
                    cscProvCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.Id
  
  If Not pSaveItemsCAIS() Then GoTo SaveError
  If Not pSaveItemsCuentaGrupo() Then GoTo SaveError
  If Not pSaveItemsRetencion() Then GoTo SaveError
  If Not pSaveItemsEmpresa() Then GoTo SaveError
  If Not pSaveItemsDpto() Then GoTo SaveError
  If Not pSaveItemsCcos() Then GoTo SaveError
  
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
  On Error Resume Next
  
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  If m_IsNew Then
    m_ObjTree.AddLeave m_Id, m_BranchId, m_TreeId
  Else
    m_ObjTree.AddEditedId m_Id
    m_ObjTree.RefreshActiveBranch
  End If
  
  m_ObjTree.sqlstmt = "sp_lsdoc_CAIS"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(1302, vbNullString)  'Proveedores
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty     As cIABMProperty
  Dim CreditoCC     As Double
  Dim CreditoTotal  As Double
  Dim Nombre        As String

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo C_DebeIndicarNombre
            Exit Function
          Else
            Nombre = .Value
          End If
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            .Value = c_get_codigo_from_id
          End If
        Case K_RAZONSOCIAL
          If ValEmpty(.Value, csText) Then
            .Value = Nombre
          End If
        Case K_CATFISCAL
          If ValEmpty(.ListItemData, csInteger) Then
            MsgInfo LNGGetText(1174, vbNullString)
                    'Debe indicar un categoría fiscal
            Exit Function
          End If
        Case K_CREDITOCTACTE
          CreditoCC = Val(.Value)
        Case K_CREDITOTOTAL
          CreditoTotal = Val(.Value)
          
        Case K_CBU
          If Len(.Value) Then
            If Not pValidarCBU(.Value) Then
              If Not Ask(LNGGetText(4714, vbNullString), vbYes) Then ' Desea guardar el proveedor de todas formas?
                Exit Function
              End If
            End If
          End If
      End Select
    End With
  Next
  
  If CreditoCC > CreditoTotal Then
    MsgInfo LNGGetText(1380, vbNullString)
              'El crédito en cuenta corriente no puede ser mayor que el crédito total
    Exit Function
  End If
  
  If Not pValidateCuitProveedor(Trim(m_ObjAbm.Properties.Item(cscProvCuit).Value)) Then Exit Function

  If Not m_GenericEdit.Validate(m_ObjAbm) Then Exit Function
  
  cIABMClient_Validate = True
End Function

' Implementacion de ciABMClientGrid

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  On Error GoTo ControlError
  
  Select Case Key
    Case K_CUENTAGRUPO
      cIABMClientGrid_ColumnBeforeEdit = ColAUpdateCtaGrupo(pGetCtaGrupo(), _
                                                             lRow, _
                                                             lCol, _
                                                             m_ObjAbm, _
                                                             KI_CUEG_ID, _
                                                             KI_CUE_ID)
    Case Else
      cIABMClientGrid_ColumnBeforeEdit = True
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnBeforeEdit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
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
    Case K_CAIS
      Id = Val(pCell(row, KI_PROVC_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedCAIS = m_ItemsDeletedCAIS & Id & C_StrColon
    Case K_CUENTAGRUPO
      Id = Val(pCell(row, KI_PROVCUEG_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedCuentaGrupo = m_ItemsDeletedCuentaGrupo & Id & C_StrColon
    Case K_EMPRESAS
      cIABMClientGrid_DeleteRow = False
      Exit Function
    Case K_DEPARTAMENTOS
      Id = Val(pCell(row, KI_DPTOPROV_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedDptos = m_ItemsDeletedDptos & Id & C_StrColon
    Case K_CENTROS_DE_COSTO
      Id = Val(pCell(row, KI_PROVCCOS_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedCcos = m_ItemsDeletedCcos & Id & C_StrColon
    Case K_RETENCION
      Id = Val(pCell(row, KI_PROVRET_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedRetenciones = m_ItemsDeletedRetenciones & Id & C_StrColon
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_CAIS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRow(row, RowIndex)
    Case K_CUENTAGRUPO
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowCuentaGrupo(row, RowIndex)
    Case K_EMPRESAS
      cIABMClientGrid_IsEmptyRow = False
    Case K_DEPARTAMENTOS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowDpto(row, RowIndex)
    Case K_CENTROS_DE_COSTO
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowCcos(row, RowIndex)
    Case K_RETENCION
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowRetencion(row, RowIndex)
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
    Case K_CAIS
      cIABMClientGrid_ValidateRow = pValidateRowCAIs(row, RowIndex)
    Case K_CUENTAGRUPO
      cIABMClientGrid_ValidateRow = pValidateRowCuentaGrupo(row, RowIndex)
    Case K_EMPRESAS
      cIABMClientGrid_ValidateRow = True
    Case K_DEPARTAMENTOS
      cIABMClientGrid_ValidateRow = pValidateRowDpto(row, RowIndex)
    Case K_CENTROS_DE_COSTO
      cIABMClientGrid_ValidateRow = pValidateRowCcos(row, RowIndex)
    Case K_RETENCION
      cIABMClientGrid_ValidateRow = pValidateRowRetencion(row, RowIndex)
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreGListProveedor)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  If Not SecurityCanAccess(csPreGDeleteProveedor) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "sp_proveedorDelete " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not pValidateAccessNewEdit(csNO_ID) Then Exit Function

  m_ObjAbm.InModalWindow = InModalWindow

  Set m_GenericEdit = New cGenericEdit
  If Not m_GenericEdit.Init(csProveedor) Then Exit Function

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
  
  Dim str_1381 As String '&Compras
                        
  str_1381 = LNGGetText(1381, vbNullString)
  
  Set m_Host = Host
  
  m_Host.Server.AddMenu str_1381, csMenuConfigCompras, C_MenuConfig, 0, True, False, False, False, True, Nothing
                          '&Proveedores
  m_Host.Server.AddMenu LNGGetText(1382, vbNullString), csPreGListProveedor, str_1381, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                    'Proveedores
  m_Host.MenuABMClick "CSGeneral2.cProveedor", Me, LNGGetText(1302, vbNullString), 0, csETablasGeneral.csProveedor
End Function

' funciones privadas

Private Function pValidateAccessNewEdit(ByVal Id As Long) As Boolean
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewProveedor) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditProveedor) Then Exit Function
  End If
  pValidateAccessNewEdit = True
End Function

Private Function pValidateRowDpto(row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In row
    Select Case Cell.Key
        Case KI_DPTO_ID
          If ValEmpty(Cell.Id, csId) Then
            MsgInfo LNGGetText(1385, vbNullString, strRow)
                    'Debe indicar un departamento
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowDpto = True
End Function

Private Function pValidateRowCcos(row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In row
    Select Case Cell.Key
        Case KI_CCOS_ID
          If ValEmpty(Cell.Id, csId) Then
            MsgInfo LNGGetText(4603, vbNullString, strRow)
                    'Debe indicar un centro de costo
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowCcos = True
End Function

Private Function pValidateRowRetencion(row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In row
    Select Case Cell.Key
        Case KI_RET_ID
          If ValEmpty(Cell.Id, csId) Then
            MsgInfo LNGGetText(1386, vbNullString, strRow)
                  'Debe indicar una retención (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowRetencion = True
End Function

Private Function pValidateRowCuentaGrupo(row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In row
    Select Case Cell.Key
        Case KI_CUEG_ID
          If ValEmpty(Cell.Id, csId) Then
            MsgInfo LNGGetText(1387, vbNullString, strRow)
                    'Debe indicar un Grupo de Cuenta (1)
            Exit Function
          End If
        Case KI_CUE_ID
          If ValEmpty(Cell.Id, csId) Then
            MsgInfo LNGGetText(1388, vbNullString, strRow)
                    'Debe indicar una Cuenta (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowCuentaGrupo = True
End Function

Private Function pValidateRowCAIs(row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell          As cIABMGridCellValue
  Dim strRow        As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In row
    Select Case Cell.Key
      Case KI_NUMERO
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(1383, vbNullString, strRow)
                    'Debe indicar un número de CAI (1)
          Exit Function
        End If
      Case KI_FECHAVTO
        If ValEmpty(Cell.Value, csDate) Or LenB(Cell.Value) = 0 Then
          MsgInfo LNGGetText(1384, vbNullString, strRow)
                  'Debe indicar una fecha de vencimiento (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowCAIs = True
End Function

Private Function pSaveItemsCAIS() As Boolean
  Dim register As cRegister
  Dim fields   As cFields
  
  With m_ObjAbm.Properties.Item(c_cais)
    Dim row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscProvcId
        .Table = csTProveedorCAI
        .Id = csNew
        
        For Each Cell In row
          Select Case Cell.Key
          
            Case KI_PROVC_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_NUMERO
              fields.Add2 cscProvcNumero, Cell.Value, csText
            Case KI_DESCRIP
              fields.Add2 cscProvcDescrip, Cell.Value, csText
            Case KI_FECHAVTO
              fields.Add2 cscProvcFechavto, Cell.Value, csDate
            Case KI_ACTIVO
              fields.Add2 cscActivo, Cell.Id, csBoolean
            Case KI_SUCURSAL
              fields.Add2 cscProvcSucursal, Cell.Value, csText
          End Select
        Next
        
        fields.Add2 cscProvId, m_Id, csId
        
        fields.HaveLastUpdate = True
        fields.HaveWhoModify = True
      
      End With

      If Not gDB.Save(register, , "pSaveItemsCAIS", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedCAIS) And Not m_Copy Then
    m_ItemsDeletedCAIS = RemoveLastColon(m_ItemsDeletedCAIS)
    sqlstmt = "delete ProveedorCAI where provc_id in (" & m_ItemsDeletedCAIS & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsCAIS", C_Module) Then Exit Function
  End If
  
  pSaveItemsCAIS = True
End Function

Private Function LoadCollection() As Boolean
  Dim filter As String
  Dim c      As cIABMProperty

  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 6400
  AbmObj.MinWidth = 12000
  AbmObj.bSendRefresh = True

  Const c_tab_general = 0
  Const c_tab_direccion = 1
  Const c_tab_cais = 2
  Const c_tab_cuentagrupo = 3
  Const c_tab_credito = 4
  Const c_tab_retencion = 5
  Const c_tab_empresas = 6
  Const c_tab_dpto = 7
  Const c_tab_ccos = 8
  
  With m_ObjAbm
  
    With .Tabs
      
      .Clear
      
      With .Add(Nothing)
        .Name = C_strGeneral
      End With
      
      With .Add(Nothing)
        .Index = c_tab_direccion
        .Name = LNGGetText(1037, vbNullString)  'Dirección
      End With
      
      With .Add(Nothing)
        .Index = c_tab_cais
        .Name = LNGGetText(1390, vbNullString)  'CAIS
      End With
    
      With .Add(Nothing)
        .Index = c_tab_cuentagrupo
        .Name = LNGGetText(1391, vbNullString)  'Grupos de Ctas.
      End With
    
      With .Add(Nothing)
        .Index = c_tab_credito
        .Name = LNGGetText(1392, vbNullString)  'Crédito
      End With
      
      With .Add(Nothing)
        .Index = c_tab_retencion
        .Name = LNGGetText(1393, vbNullString)  'Retenciones
      End With
      
      With .Add(Nothing)
        .Index = c_tab_empresas
        .Name = LNGGetText(1171, vbNullString)  'Empresas
      End With
      
      With .Add(Nothing)
        .Index = c_tab_dpto
        .Name = LNGGetText(1508, vbNullString) 'Deptos.
      End With
      
      With .Add(Nothing)
        .Index = c_tab_ccos
        .Name = LNGGetText(4602, vbNullString) 'Centros de Costo
      End With
      
    End With
    
    .Title2 = m_Nombre
  
    With .Properties
      
      .Clear
  
      With .Add(Nothing, cscProvNombre)
        .PropertyType = cspText
        .Name = C_strNombre
        .Size = 255
        .Width = 6100
        .Key = K_NOMBRE
        .Value = m_Nombre
      End With
      
      With .Add(Nothing, cscProvRazonsocial)
        .PropertyType = cspText
        .Name = LNGGetText(1178, vbNullString)  'Razon Social
        .Size = 255
        .Width = 6100
        .Key = K_RAZONSOCIAL
        .Value = m_Razonsocial
      End With
      
      With .Add(Nothing, cscProvCodigo)
        .PropertyType = cspText
        .Name = C_strCodigo
        .Size = 20
        .Key = K_CODIGO
        .Value = m_Codigo
      End With
      
      With .Add(Nothing, cscActivo)
        .PropertyType = cspCheck
        .Name = C_strActivo
        .Key = K_ACTIVO
        .Value = CInt(m_Activo)
      End With
      
      With .Add(Nothing, cscProvImprimeTicket)
        .PropertyType = cspCheck
        .Name = LNGGetText(1394, vbNullString)  'Imprime Ticket
        .LeftToPrevious = 3000
        .LeftNotChange = True
        .TopFromProperty = cscActivo
        .Key = K_IMPRIMETICKET
        .Value = CInt(m_ImprimeTicket)
      End With
      
      With .Add(Nothing, cscProvContacto)
        .PropertyType = cspText
        .Name = LNGGetText(1035, vbNullString)  'Contacto
        .Size = 30
        .Key = K_CONTACTO
        .Value = m_Contacto
      End With
      
      With .Add(Nothing, cscLpId)
        .PropertyType = cspHelp
        .Table = csListaPrecio
      
        filter = "exists(select lp_id from listaprecioproveedor where prov_id =" & m_Id
        filter = filter & " and lp_id = listaprecio.lp_id)"
      
        .HelpFilter = filter
        .Name = LNGGetText(1397, vbNullString)  'Lista de precios
        .Key = K_LP_ID
        .Value = m_ListaPrecio
        .HelpId = m_Lp_id
      End With
            
      With .Add(Nothing, cscProvCatfiscal)
        .PropertyType = cspList
        .Name = LNGGetText(1181, vbNullString)  'Categoria Fiscal
        .TopFromProperty = cscProvCodigo
        .Left = 5500
        .Key = K_CATFISCAL
        .ListWhoSetItem = csListItemData
        .ListItemData = m_CatFiscal
        
        With .List.Add(Nothing, csCatFNoInscripto)
          .Id = csCatFNoInscripto
          .Value = LNGGetText(1183, vbNullString)  'No Inscripto
        End With
        
        With .List.Add(Nothing, csCatFInscripto)
          .Id = csCatFInscripto
          .Value = LNGGetText(1184, vbNullString)  'Inscripto
        End With
        
        With .List.Add(Nothing, csCatFExtranjero)
          .Id = csCatFExtranjero
          .Value = LNGGetText(1185, vbNullString)  'Extranjero
        End With
        
        With .List.Add(Nothing, csCatFExento)
          .Id = csCatFExento
          .Value = LNGGetText(1186, vbNullString)  'Exento
        End With
        
        With .List.Add(Nothing, csCatFMonoTributo)
          .Id = csCatFMonoTributo
          .Value = LNGGetText(1187, vbNullString)  'Monotributo
        End With
        
        With .List.Add(Nothing, csCatFExtranjeroIva)
          .Id = csCatFExtranjeroIva
          .Value = LNGGetText(1188, vbNullString)  'Extranjero con Iva
        End With
        
        With .List.Add(Nothing, csCatFNoCategorizado)
          .Id = csCatFNoCategorizado
          .Value = LNGGetText(1189, vbNullString)  'No categorizado
        End With
        
        With .List.Add(Nothing, csCatFNoResponsable)
          .Id = csCatFNoResponsable
          .Value = LNGGetText(1190, vbNullString)  'No responsable
        End With
        
        With .List.Add(Nothing, csCatFNoResponsableExento)
          .Id = csCatFNoResponsableExento
          .Value = LNGGetText(1191, vbNullString)  'No responsable exento
        End With
        
        With .List.Add(Nothing, csCatFInscriptoM)
          .Id = csCatFInscriptoM
          .Value = LNGGetText(1192, vbNullString)  'Inscripto M
        End With
        
      End With
      
      With .Add(Nothing, cscProvCuit)
        .PropertyType = cspText
        .Name = LNGGetText(1179, vbNullString)  'Cuit
        .Size = 13
        .Key = K_CUIT
        .Value = m_Cuit
      End With
      
      With .Add(Nothing, cscProvIngresosbrutos)
        .PropertyType = cspText
        .Name = LNGGetText(1180, vbNullString)  'Ingresos Brutos
        .Size = 20
        .Key = K_INGRESOSBRUTOS
        .Value = m_Ingresosbrutos
      End With
      
      With .Add(Nothing, cscLdId)
        .PropertyType = cspHelp
        .Table = csListaDescuento
        .Name = LNGGetText(1398, vbNullString)  'Lista de descuentos
        .Key = K_LD_ID
      
        filter = "exists(select ld_id from listadescuentoproveedor where prov_id =" & m_Id
        filter = filter & " and ld_id = listadescuento.ld_id)"
      
        .HelpFilter = filter
        .Value = m_ListaDescuento
        .HelpId = m_Ld_id
      End With
      
      With .Add(Nothing, cscCpgId)
        .PropertyType = cspHelp
        .Table = csCondicionPago
        .Name = LNGGetText(1395, vbNullString)  'Condición de pago
        .TopFromProperty = cscProvNombre
        .Left = 9500
        .Key = K_CPG_ID
        .Value = m_CondicionPago
        .HelpId = m_Cpg_id
      End With
      
      With .Add(Nothing, cscProvChequeorden)
        .PropertyType = cspText
        .Name = LNGGetText(1396, vbNullString)  'Cheque a la orden
        .Size = 100
        .Key = K_CHEQUEORDEN
        .Value = m_Chequeorden
      End With
      
      With .Add(Nothing, cscProvBanco)
        .PropertyType = cspText
        .Name = LNGGetText(1122, vbNullString)  'Banco
        .Size = 100
        .Key = K_BANCO
        .Value = m_Banco
      End With
      
      With .Add(Nothing, cscProvNroCtaBanco)
        .PropertyType = cspText
        .Name = LNGGetText(4710, vbNullString)  'Cuenta Bancaria
        .Size = 255
        .Key = K_NROCTA
        .Value = m_nroctabanco
      End With
      
      With .Add(Nothing, cscProvCBU)
        .PropertyType = cspText
        .Name = LNGGetText(4711, vbNullString)  'CBU
        .Size = 100
        .Key = K_CBU
        .Value = m_cbu
      End With
      
      With .Add(Nothing, cscProvNroCliente)
        .PropertyType = cspText
        .Name = LNGGetText(4715, vbNullString)  'Nro. de Cliente
        .Size = 100
        .Key = K_NROCLIENTE
        .Value = m_nrocliente
      End With
      
      With .Add(Nothing, cscProvCreditoctacte)
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Name = LNGGetText(1399, vbNullString)  'Crédito en Cta.Cte.
        .TabIndex = c_tab_credito
        .Key = K_CREDITOCTACTE
        .Value = m_Creditoctacte
      End With
      
      With .Add(Nothing, cscProvCreditototal)
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Name = LNGGetText(1400, vbNullString)  'Crédito Total
        .TabIndex = c_tab_credito
        .Key = K_CREDITOTOTAL
        .Value = m_Creditototal
      End With
      
      With .Add(Nothing, cscProvCreditoactivo)
        .PropertyType = cspCheck
        .Name = LNGGetText(1401, vbNullString)  'Crédito Activo
        .TabIndex = c_tab_credito
        .Key = K_CREDITOACTIVO
        .Value = CInt(m_Creditoactivo)
      End With
      
      With .Add(Nothing, cscProvDescrip)
        .PropertyType = cspText
        .SubType = cspMemo
        .Width = 10150
        .Height = 780
        .Name = C_strDescrip
        .Size = 255
      
        .TopFromProperty = cscProvContacto
        .TopToPrevious = 1040
        .LeftFromProperty = cscProvNombre
        .Key = K_DESCRIP
        .Value = m_descrip
      End With
      
      With .Add(Nothing, cscProvCalle)
        .PropertyType = cspText
        .Name = LNGGetText(1194, vbNullString)  'Calle
        .TabIndex = c_tab_direccion
        .Key = K_CALLE
        .Value = m_Calle
        .Width = 9000
      End With
      
      With .Add(Nothing, cscProvCallenumero)
        .PropertyType = cspText
        .Name = LNGGetText(1065, vbNullString)  'Número
        .TabIndex = c_tab_direccion
        .Size = 10
        .Key = K_CALLENUMERO
        .Value = m_Callenumero
        .Width = 1200
      End With
      
      With .Add(Nothing, cscProvPiso)
        .PropertyType = cspText
        .Name = LNGGetText(1196, vbNullString)  'Piso
        .TabIndex = c_tab_direccion
        .Size = 4
        .Key = K_PISO
        .Value = m_Piso
        .Width = 1200
      End With
      
      With .Add(Nothing, cscProvDepto)
        .PropertyType = cspText
        .Name = LNGGetText(1278, vbNullString)  'Departamento
        .TabIndex = c_tab_direccion
        .Size = 4
        .Key = K_DEPTO
        .Value = m_Depto
        .Width = 1200
      End With
      
      With .Add(Nothing, cscProvCodpostal)
        .PropertyType = cspText
        .Name = LNGGetText(1199, vbNullString)  'Codigo Postal
        .TabIndex = c_tab_direccion
        .Size = 20
        .Key = K_CODPOSTAL
        .Value = m_Codpostal
        .Width = 1200
      End With
            
      With .Add(Nothing, cscProvLocalidad)
        .PropertyType = cspText
        .Name = LNGGetText(1198, vbNullString)  'Localidad
        .TabIndex = c_tab_direccion
        .Size = 100
        .Key = K_LOCALIDAD
        .Value = m_Localidad
        .Width = 6500
      End With
      
      With .Add(Nothing, cscProId)
        .PropertyType = cspHelp
        .Table = csProvincia
        .Name = LNGGetText(1080, vbNullString)  'Provincia
        .TabIndex = c_tab_direccion
        .Key = K_PRO_ID
        .Value = m_provincia
        .HelpId = m_pro_id
        .Width = 6500
      End With
      
      With .Add(Nothing, cscZonId)
        .PropertyType = cspHelp
        .Table = csZona
        .Name = LNGGetText(1402, vbNullString)  'Zona
        .TabIndex = c_tab_direccion
        .Key = K_ZON_ID
        .Value = m_Zona
        .HelpId = m_Zon_id
        .Width = 6500
      End With
      
      With .Add(Nothing, cscProvHorarioMdesde)
        .PropertyType = cspTime
        .Name = LNGGetText(4965, vbNullString) ' Horario desde
        .TabIndex = c_tab_direccion
        .Value = m_horario_m_desde
        .Key = K_HORARIO_M_DESDE
        .LeftNotChange = True
      End With
      
      With .Add(Nothing, cscProvHorarioMhasta)
        .PropertyType = cspTime
        .Name = LNGGetText(4966, vbNullString) ' Hasta
        .TabIndex = c_tab_direccion
        .Value = m_horario_m_hasta
        .Key = K_HORARIO_M_HASTA
        .TopFromProperty = cscProvHorarioMdesde
        .Left = 3200
        .LeftLabel = -500
        .LeftNotChange = True
        .TopNotChange = True
      End With
      
      With .Add(Nothing, cscProvHorarioTdesde)
        .PropertyType = cspTime
        .Name = LNGGetText(4967, vbNullString) ' Desde
        .TabIndex = c_tab_direccion
        .Value = m_horario_t_desde
        .Key = K_HORARIO_T_DESDE
        .TopFromProperty = cscProvHorarioMdesde
        .Left = 4900
        .LeftLabel = -500
        .LeftNotChange = True
        .TopNotChange = True
      End With
      
      With .Add(Nothing, cscProvHorarioThasta)
        .PropertyType = cspTime
        .Name = LNGGetText(4966, vbNullString) ' Hasta
        .TabIndex = c_tab_direccion
        .Value = m_horario_t_hasta
        .Key = K_HORARIO_T_HASTA
        .TopFromProperty = cscProvHorarioMdesde
        .Left = 6700
        .LeftLabel = -500
        .LeftNotChange = True
        .TopNotChange = True
      End With
      
      With .Add(Nothing, cscProvTel)
        .PropertyType = cspText
        .Name = LNGGetText(1036, vbNullString)  'Teléfono
        .TabIndex = c_tab_direccion
        .Size = 100
        .Key = K_TEL
        .Value = m_Tel
        .Width = 6000
        .TopFromProperty = cscProvCallenumero
        .Left = 4200
        .LeftLabel = -900
      End With
    
      With .Add(Nothing, cscProvFax)
        .PropertyType = cspText
        .Name = LNGGetText(1200, vbNullString)  'Fax
        .TabIndex = c_tab_direccion
        .Size = 50
        .Key = K_FAX
        .Value = m_Fax
      End With
      
      With .Add(Nothing, cscProvEmail)
        .PropertyType = cspText
        .Name = LNGGetText(1034, vbNullString)  'E-Mail
        .TabIndex = c_tab_direccion
        .Size = 100
        .Key = K_EMAIL
        .Value = m_Email
        .Width = 4000
      End With
      
      With .Add(Nothing, cscProvWeb)
        .PropertyType = cspText
        .Name = LNGGetText(1038, vbNullString)  'Web
        .TabIndex = c_tab_direccion
        .Size = 100
        .Key = K_WEB
        .Value = m_Web
        .Width = 6000
      End With
      
      Set c = .Add(Nothing, c_cais)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadCAIs(c) Then Exit Function
        .Name = c_cais
        .Key = K_CAIS
        .TabIndex = c_tab_cais
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedCAIS = vbNullString
      
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
      
      Set c = .Add(Nothing, c_retencion)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadRetencion(c) Then Exit Function
        .Name = c_retencion
        .Key = K_RETENCION
        .TabIndex = c_tab_retencion
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedRetenciones = vbNullString
      
      Set c = .Add(Nothing, c_empresas)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadEmpresas(c) Then Exit Function
        .Name = c_empresas
        .Key = K_EMPRESAS
        .TabIndex = c_tab_empresas
        .GridAdd = False
        .GridEdit = True
        .GridRemove = False
      End With
      
      Set c = .Add(Nothing, c_dpto)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadDpto(c) Then Exit Function
        .Name = c_dpto
        .Key = K_DEPARTAMENTOS
        .TabIndex = c_tab_dpto
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedDptos = vbNullString
    
      Set c = .Add(Nothing, c_ccos)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadCcos(c) Then Exit Function
        .Name = c_ccos
        .Key = K_CENTROS_DE_COSTO
        .TabIndex = c_tab_ccos
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedCcos = vbNullString
    
    End With
    
    If Not m_GenericEdit.LoadCollection(m_ObjAbm) Then Exit Function

    If Not .Show(Me) Then Exit Function
    
  End With
  
  LoadCollection = True
End Function

Public Function GetData(ByVal Id As Long, ByVal strField As String, ByVal TypeValue As csTypes) As Variant
  Dim Data As Variant
  
  Select Case TypeValue
    Case csTypes.csBoolean
      Data = False
    Case csTypes.csCuit, csTypes.csText
      Data = vbNullString
    Case csTypes.csDate, csTypes.csDateOrNull
      Data = csNoDate
    Case csTypes.csCurrency, csTypes.csDouble, _
         csTypes.csInteger, csTypes.csLong, _
         csTypes.csSingle, csTypes.csId
      Data = 0
    Case csTypes.csVariant
      Data = Empty
  End Select
  
  If Not gDB.GetData(csTProveedor, cscProvId, Id, strField, Data, "GetData", C_Module) Then
    Select Case TypeValue
      Case csTypes.csBoolean
        Data = False
      Case csTypes.csCuit, csTypes.csText
        Data = vbNullString
      Case csTypes.csDate, csTypes.csDateOrNull
        Data = csNoDate
      Case csTypes.csCurrency, csTypes.csDouble, _
           csTypes.csInteger, csTypes.csLong, _
           csTypes.csSingle, csTypes.csId
        Data = 0
      Case csTypes.csVariant
        Data = Empty
    End Select
  End If
  
  GetData = Data
End Function


Public Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset

  sqlstmt = "sp_proveedorGet " & Id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then
  
    m_Id = gDB.ValField(rs.fields, cscProvId)
    m_Nombre = gDB.ValField(rs.fields, cscProvNombre)
    m_Codigo = gDB.ValField(rs.fields, cscProvCodigo)
    m_Contacto = gDB.ValField(rs.fields, cscProvContacto)
    m_descrip = gDB.ValField(rs.fields, cscProvDescrip)
    m_Cpg_id = gDB.ValField(rs.fields, cscCpgId)
    m_CondicionPago = gDB.ValField(rs.fields, cscCpgNombre)
    m_Razonsocial = gDB.ValField(rs.fields, cscProvRazonsocial)
    m_Cuit = gDB.ValField(rs.fields, cscProvCuit)
    m_Ingresosbrutos = gDB.ValField(rs.fields, cscProvIngresosbrutos)
    m_CatFiscal = gDB.ValField(rs.fields, cscProvCatfiscal)
    m_Chequeorden = gDB.ValField(rs.fields, cscProvChequeorden)
    m_Codpostal = gDB.ValField(rs.fields, cscProvCodpostal)
    m_Localidad = gDB.ValField(rs.fields, cscProvLocalidad)
    m_Calle = gDB.ValField(rs.fields, cscProvCalle)
    m_Callenumero = gDB.ValField(rs.fields, cscProvCallenumero)
    m_Piso = gDB.ValField(rs.fields, cscProvPiso)
    m_Depto = gDB.ValField(rs.fields, cscProvDepto)
    m_Tel = gDB.ValField(rs.fields, cscProvTel)
    m_Fax = gDB.ValField(rs.fields, cscProvFax)
    m_Email = gDB.ValField(rs.fields, cscProvEmail)
    m_Web = gDB.ValField(rs.fields, cscProvWeb)
    m_pro_id = gDB.ValField(rs.fields, cscProId)
    m_Zon_id = gDB.ValField(rs.fields, cscZonId)
    m_provincia = gDB.ValField(rs.fields, cscProNombre)
    m_Zona = gDB.ValField(rs.fields, cscZonNombre)
    m_Creditoctacte = gDB.ValField(rs.fields, cscProvCreditoctacte)
    m_Creditototal = gDB.ValField(rs.fields, cscProvCreditototal)
    m_Creditoactivo = gDB.ValField(rs.fields, cscProvCreditoactivo)
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_ImprimeTicket = gDB.ValField(rs.fields, cscProvImprimeTicket)
    m_Lp_id = gDB.ValField(rs.fields, cscLpId)
    m_ListaPrecio = gDB.ValField(rs.fields, cscLpNombre)
    m_Ld_id = gDB.ValField(rs.fields, cscLdId)
    m_ListaDescuento = gDB.ValField(rs.fields, cscLdNombre)
    
    m_nroctabanco = gDB.ValField(rs.fields, cscProvNroCtaBanco)
    m_Banco = gDB.ValField(rs.fields, cscProvBanco)
    m_cbu = gDB.ValField(rs.fields, cscProvCBU)
    m_nrocliente = gDB.ValField(rs.fields, cscProvNroCliente)
  
    m_horario_m_desde = gDB.ValField(rs.fields, cscProvHorarioMdesde)
    m_horario_m_hasta = gDB.ValField(rs.fields, cscProvHorarioMhasta)
    m_horario_t_desde = gDB.ValField(rs.fields, cscProvHorarioTdesde)
    m_horario_t_hasta = gDB.ValField(rs.fields, cscProvHorarioThasta)
  
  Else
    
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Contacto = vbNullString
    m_Razonsocial = vbNullString
    m_Cuit = vbNullString
    m_Ingresosbrutos = vbNullString
    m_CatFiscal = csCatFInscripto
    m_Chequeorden = vbNullString
    m_Codpostal = vbNullString
    m_descrip = vbNullString
    m_Localidad = vbNullString
    m_Calle = vbNullString
    m_Callenumero = vbNullString
    m_Piso = vbNullString
    m_Depto = vbNullString
    m_Tel = vbNullString
    m_Fax = vbNullString
    m_Email = vbNullString
    m_Web = vbNullString
    m_Cpg_id = csNO_ID
    m_CondicionPago = vbNullString
    m_pro_id = csNO_ID
    m_Zon_id = csNO_ID
    m_Lp_id = csNO_ID
    m_ListaPrecio = vbNullString
    m_Ld_id = csNO_ID
    m_ListaDescuento = vbNullString
    m_provincia = vbNullString
    m_Zona = vbNullString
    m_Creditoctacte = 0
    m_Creditototal = 0
    m_Creditoactivo = True
    m_Activo = True
    m_ImprimeTicket = False
    
    m_horario_m_desde = csNoDate
    m_horario_m_hasta = csNoDate
    m_horario_t_desde = csNoDate
    m_horario_t_hasta = csNoDate
  
    m_nroctabanco = vbNullString
    m_Banco = vbNullString
    m_cbu = vbNullString
    m_nrocliente = vbNullString
    
  End If

  If Not m_GenericEdit.Load(m_Id) Then Exit Function

  Load = True
End Function

Private Sub pRefreshProperties()
  Dim c      As cIABMProperty
  Dim AbmGen As cABMGeneric
  Dim filter As String

  With m_ObjAbm
    
    .Title2 = m_Nombre
    
    With .Properties
    
      With .Item(cscProvNombre)
        .Value = m_Nombre
      End With
      
      With .Item(cscProvRazonsocial)
        .Value = m_Razonsocial
      End With
      
      With .Item(cscProvCodigo)
        .Value = m_Codigo
      End With
      
      With .Item(cscActivo)
        .Value = CInt(m_Activo)
      End With
      
      With .Item(cscProvImprimeTicket)
        .Value = CInt(m_ImprimeTicket)
      End With
      
      With .Item(cscProvContacto)
        .Value = m_Contacto
      End With
      
      With .Item(cscProvCatfiscal)
        .ListItemData = m_CatFiscal
      End With
      
      With .Item(cscProvCuit)
        .Value = m_Cuit
      End With
      
      With .Item(cscProvIngresosbrutos)
        .Value = m_Ingresosbrutos
      End With
      
      With .Item(cscCpgId)
        .Value = m_CondicionPago
        .HelpId = m_Cpg_id
      End With
      
      With .Item(cscProvChequeorden)
        .Value = m_Chequeorden
      End With
      
      With .Item(cscLpId)
        filter = "exists(select lp_id from listaprecioproveedor where prov_id =" & m_Id
        filter = filter & " and lp_id = listaprecio.lp_id)"
        .HelpFilter = filter
        .Value = m_ListaPrecio
        .HelpId = m_Lp_id
      End With
      
      With .Item(cscLdId)
        filter = "exists(select ld_id from listadescuentoproveedor where prov_id =" & m_Id
        filter = filter & " and ld_id = listadescuento.ld_id)"
        .HelpFilter = filter
        .Value = m_ListaDescuento
        .HelpId = m_Ld_id
      End With
      
      With .Item(cscProvCreditoctacte)
        .Value = m_Creditoctacte
      End With
      
      With .Item(cscProvCreditototal)
        .Value = m_Creditototal
      End With
      
      With .Item(cscProvCreditoactivo)
        .Value = CInt(m_Creditoactivo)
      End With
      
      With .Item(cscProvDescrip)
        .Value = m_descrip
      End With
      
      With .Item(cscProvCalle)
        .Value = m_Calle
      End With
      
      With .Item(cscProvCallenumero)
        .Value = m_Callenumero
      End With
      
      With .Item(cscProvPiso)
        .Value = m_Piso
      End With
      
      With .Item(cscProvDepto)
        .Value = m_Depto
      End With
      
      With .Item(cscProvTel)
        .Value = m_Tel
      End With
    
      With .Item(cscProvFax)
        .Value = m_Fax
      End With
      
      With .Item(cscProvEmail)
        .Value = m_Email
      End With
      
      With .Item(cscProvWeb)
        .Value = m_Web
      End With
    
      With .Item(cscProvCodpostal)
        .Value = m_Codpostal
      End With
      
      With .Item(cscProvHorarioMdesde)
        .Value = m_horario_m_desde
      End With
      
      With .Item(cscProvHorarioMhasta)
        .Value = m_horario_m_hasta
      End With
      
      With .Item(cscProvHorarioTdesde)
        .Value = m_horario_t_desde
      End With
      
      With .Item(cscProvHorarioThasta)
        .Value = m_horario_t_hasta
      End With
      
      With .Item(cscProvLocalidad)
        .Value = m_Localidad
      End With
      
      With .Item(cscProId)
        .Value = m_provincia
        .HelpId = m_pro_id
      End With
      
      With .Item(cscZonId)
        .Value = m_Zona
        .HelpId = m_Zon_id
      End With
      
      Set c = .Item(c_cais)
      If Not pLoadCAIs(c) Then Exit Sub
      m_ItemsDeletedCAIS = vbNullString
      
      Set c = .Item(c_cuentagrupo)
      If Not pLoadCuentaGrupo(c) Then Exit Sub
      m_ItemsDeletedCuentaGrupo = vbNullString
      
      Set c = .Item(c_retencion)
      If Not pLoadRetencion(c) Then Exit Sub
      m_ItemsDeletedRetenciones = vbNullString
      
      Set c = .Item(c_empresas)
      If Not pLoadEmpresas(c) Then Exit Sub

      Set c = .Item(c_dpto)
      If Not pLoadDpto(c) Then Exit Sub
      m_ItemsDeletedDptos = vbNullString
    
      Set c = .Item(c_ccos)
      If Not pLoadCcos(c) Then Exit Sub
      m_ItemsDeletedCcos = vbNullString
    
    End With
  End With

  m_GenericEdit.RefreshProperties m_ObjAbm
  
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValues m_ObjAbm.Properties

End Sub

Private Function pLoadDpto(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select d.dpto_id,dpto_nombre,dptoprov_id" & _
            " from Departamento d left join DepartamentoProveedor dp" & _
                   " on d.dpto_id = dp.dpto_id" & _
            " where dp.prov_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadDpto", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_DPTOPROV_ID
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1278, vbNullString)  'Departamento
        .PropertyType = cspHelp
        .Table = csDepartamento
        .Width = 3500
        .Key = KI_DPTO_ID
      End With
    End With
  
    With .Rows
    
      .Clear
    
      While Not rs.EOF
            
        With .Add(Nothing, rs(cscDptoProvId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscDptoProvId)
            .Key = KI_DPTOPROV_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscDptoNombre)
            .Id = rs(cscDptoId).Value
            .Key = KI_DPTO_ID
          End With
          
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadDpto = True
End Function

Private Function pLoadCcos(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select provccos_id, c.pr_id, c.ccos_id, pr_nombrecompra, ccos_nombre" & _
            " from ProveedorCentroCosto c left join CentroCosto ccos" & _
                   " on c.ccos_id = ccos.ccos_id" & _
                   " left join Producto pr" & _
                   " on c.pr_id = pr.pr_id" & _
            " where c.prov_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadDpto", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PROVCCOS_ID
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1057, vbNullString)  'Centro de Costo
        .PropertyType = cspHelp
        .Table = csCentroCosto
        .Width = 3500
        .Key = KI_CCOS_ID
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1367, vbNullString)  'Articulo
        .PropertyType = cspHelp
        .Table = csProductoCompra
        .Width = 3500
        .Key = KI_PR_ID
      End With
    End With
  
    With .Rows
    
      .Clear
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscProvCcosId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscProvCcosId)
            .Key = KI_PROVCCOS_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCcosNombre)
            .Id = rs(cscCcosId).Value
            .Key = KI_CCOS_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrNombrecompra)
            .Id = gDB.ValField(rs.fields, cscPrId)
            .Key = KI_PR_ID
          End With
          
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadCcos = True
End Function

Private Function pLoadEmpresas(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select e.emp_id,emp_nombre,empprov_id" & _
            " from empresa e left join empresaproveedor ep" & _
                      " on    e.emp_id = ep.emp_id" & _
                        " and ep.prov_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadEmpresas", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1114, vbNullString)  'Empresa
        .PropertyType = cspText
        .Width = 3500
        .Key = KI_EMP_ID
      End With
      
      With .Add(Nothing)
        .Width = 800
        .PropertyType = cspCheck
        .Key = KI_EMPPROV_ID
      End With
      
    End With
    
    Dim bSelect As Boolean
    
    If Not rs.EOF Then
      rs.MoveLast
      rs.MoveFirst
      bSelect = rs.RecordCount = 1
    End If
    
    With .Rows
  
      .Clear
  
      While Not rs.EOF
      
        With .Add(Nothing)
        
          With .Add(Nothing)
            .Value = rs(cscEmpId).Value
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscEmpNombre)
            .Id = rs(cscEmpId).Value
            .Key = KI_EMP_ID
          End With
          
          With .Add(Nothing)
            If bSelect Then
              .Id = 1
            Else
              .Id = gDB.ValField(rs.fields, cscEmpProvId)
            End If
            .Value = .Id
            .Key = KI_EMPPROV_ID
          End With
        
        End With
        
        rs.MoveNext
      
      Wend
    
    End With
  End With
  
  pLoadEmpresas = True
End Function

Private Function pLoadRetencion(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select provr.*,ret_nombre,pt.rett_id,rett_nombre" & _
            " from ProveedorRetencion provr " & _
                    " inner join retencion p" & _
                             " on provr.ret_id = p.ret_id" & _
                    " inner join retencionTipo pt " & _
                             " on p.rett_id = pt.rett_id" & _
            " where provr.prov_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCuentaGrupo", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PROVRET_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1223, vbNullString)    'Tipo
        .PropertyType = cspHelp
        .Table = csRetencionTipo
        .Width = 3500
        .Key = KI_RETT_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1403, vbNullString)    'Retención
        .PropertyType = cspHelp
        .Table = csRetencion
        .Width = 3500
        .Key = KI_RET_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2532, vbNullString)  'Desde
        .PropertyType = cspDate
        .Width = 3500
        .Key = KI_RET_DESDE
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(2533, vbNullString)  'Hasta
        .PropertyType = cspDate
        .Width = 3500
        .Key = KI_RET_HASTA
      End With
    
    End With
    
    With .Rows
    
      .Clear
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscProvRetId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscProvRetId).Value
            .Key = KI_PROVRET_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRettNombre)
            .Id = gDB.ValField(rs.fields, cscRettId)
            .Key = KI_RETT_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscRetNombre)
            .Id = gDB.ValField(rs.fields, cscRetId)
            .Key = KI_RET_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscProvRetDesde)
            .Key = KI_RET_DESDE
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscProvRetHasta)
            .Key = KI_RET_HASTA
          End With
        
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadRetencion = True
End Function

Private Function pLoadCuentaGrupo(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select pcg.*,cue_nombre,cueg_nombre" & _
            " from proveedorcuentagrupo pcg" & _
                  " inner join cuenta c" & _
                      " on pcg.cue_id = c.cue_id" & _
                  " inner join cuentagrupo cg" & _
                      " on pcg.cueg_id = cg.cueg_id" & _
            " where pcg.prov_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCuentaGrupo", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
    
      .Clear
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PROVCUEG_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1404, vbNullString)    'Grupo
        .PropertyType = cspHelp
        .Table = csCuentaGrupo
        .Width = 3500
        .Key = KI_CUEG_ID
        .HelpFilter = "cueg_tipo in (2,3)"
      End With
      
      With .Add(Nothing, cscCueId)
        .Name = LNGGetText(1267, vbNullString)    'Cuenta
        .PropertyType = cspHelp
        .Table = csCuenta
        .HelpFilter = "(" & cscCuecId & "=" & csECuecAcreedores & _
                       " Or " & cscCuecId & "=" & csECuecDepositoCupones & _
                       " Or " & cscCuecId & "=" & csECuecBancos & _
                       " Or " & cscCuecId & "=" & csECuecBienesDeCambio & _
                       " Or " & cscCueProducto & " <> 0)"

        .Width = 3500
        .Key = KI_CUE_ID
      End With
      
    End With
    
    With .Rows
  
      .Clear
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscProvCuegId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscProvCuegId).Value
            .Key = KI_PROVCUEG_ID
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

Private Function pLoadCAIs(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select * from ProveedorCAI where prov_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCAIs", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
  
      .Clear
  
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PROVC_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1406, vbNullString)    'N° CAI
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_NUMERO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1281, vbNullString)    'sucursal
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_SUCURSAL
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1405, vbNullString)    'Vencimiento
        .PropertyType = cspDate
        .Width = 1200
        .Key = KI_FECHAVTO
      End With
      
      With .Add(Nothing)
        .Name = C_strDescrip
        .PropertyType = cspText
        .Width = 3500
        .Key = KI_DESCRIP
      End With
    End With
    
    With .Rows
  
      .Clear
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscProvcId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscProvcId).Value
            .Key = KI_PROVC_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscProvcNumero)
            .Key = KI_NUMERO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscProvcSucursal)
            .Key = KI_SUCURSAL
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscProvcFechavto)
            .Key = KI_FECHAVTO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscProvcDescrip)
            .Key = KI_DESCRIP
          End With
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadCAIs = True
End Function

Private Function pIsEmptyRowDpto(ByRef row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In row
    Select Case Cell.Key
      Case KI_DPTO_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowDpto = bRowIsEmpty
End Function

Private Function pIsEmptyRowCcos(ByRef row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In row
    Select Case Cell.Key
      Case KI_PR_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_CCOS_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowCcos = bRowIsEmpty
End Function

Private Function pIsEmptyRowRetencion(ByRef row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In row
    Select Case Cell.Key
      Case KI_RET_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowRetencion = bRowIsEmpty
End Function

Private Function pIsEmptyRowCuentaGrupo(ByRef row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In row
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

Private Function pIsEmptyRow(ByRef row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In row
    Select Case Cell.Key
      Case KI_NUMERO
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_FECHAVTO
        If Not ValEmpty(Cell.Value, csDate) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRow = bRowIsEmpty
End Function

Private Function pSaveItemsRetencion() As Boolean
  Dim register As cRegister
  Dim fields   As cFields

  With m_ObjAbm.Properties.Item(c_retencion)
    Dim row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscProvRetId
        .Table = csTProveedorRetencion
        .Id = csNew
        
        For Each Cell In row
          Select Case Cell.Key
            
            Case KI_PROVRET_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_RET_ID
              fields.Add2 cscRetId, Cell.Id, csId
          
            Case KI_RET_DESDE
              fields.Add2 cscProvRetDesde, Cell.Value, csDate
          
            Case KI_RET_HASTA
              fields.Add2 cscProvRetHasta, Cell.Value, csDate
          End Select
        Next
        
        fields.Add2 cscProvId, m_Id, csId
        
        fields.HaveLastUpdate = True
        fields.HaveWhoModify = True
        
      End With
      
      If Not gDB.Save(register, , "pSaveItemsRetencion", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedRetenciones) And Not m_Copy Then
    m_ItemsDeletedRetenciones = RemoveLastColon(m_ItemsDeletedRetenciones)
    sqlstmt = "delete ProveedorRetencion where provret_id in (" & m_ItemsDeletedRetenciones & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsRetencion", C_Module) Then Exit Function
  End If
  
  pSaveItemsRetencion = True
End Function

Private Function pSaveItemsDpto() As Boolean
  Dim register As cRegister
  Dim fields   As cFields
  
  With m_ObjAbm.Properties.Item(c_dpto)
    Dim row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscDptoProvId
        .Table = csTDepartamentoProveedor
        .Id = csNew
        
        For Each Cell In row
          Select Case Cell.Key
            
            Case KI_DPTOPROV_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_DPTO_ID
              fields.Add2 cscDptoId, Cell.Id, csId
          End Select
        Next
        
        fields.Add2 cscProvId, m_Id, csId
        
        fields.HaveLastUpdate = False
        fields.HaveWhoModify = False
      
      End With
                                                              
      If Not gDB.Save(register, , "pSaveItemsDpto", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedDptos) And Not m_Copy Then
    m_ItemsDeletedDptos = RemoveLastColon(m_ItemsDeletedDptos)
    sqlstmt = "delete DepartamentoProveedor where Dptoprov_id in (" & m_ItemsDeletedDptos & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsDpto", C_Module) Then Exit Function
  End If
  
  pSaveItemsDpto = True
End Function

Private Function pSaveItemsCcos() As Boolean
  Dim register As cRegister
  Dim fields   As cFields
  
  With m_ObjAbm.Properties.Item(c_ccos)
    Dim row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscProvCcosId
        .Table = csTProveedorCentroCosto
        .Id = csNew
        
        For Each Cell In row
          Select Case Cell.Key
            
            Case KI_PROVCCOS_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_CCOS_ID
              fields.Add2 cscCcosId, Cell.Id, csId
            Case KI_PR_ID
              fields.Add2 cscPrId, Cell.Id, csId
          End Select
        Next
        
        fields.Add2 cscProvId, m_Id, csId
        
        fields.HaveLastUpdate = False
        fields.HaveWhoModify = False
      
      End With
                                                              
      If Not gDB.Save(register, , "pSaveItemsCcos", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedCcos) And Not m_Copy Then
    m_ItemsDeletedCcos = RemoveLastColon(m_ItemsDeletedCcos)
    sqlstmt = "delete ProveedorCentroCosto where provccos_id in (" & m_ItemsDeletedCcos & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsCcos", C_Module) Then Exit Function
  End If
  
  pSaveItemsCcos = True
End Function

Private Function pSaveItemsEmpresa() As Boolean
  Dim register  As cRegister

  Dim sqlstmt As String
  sqlstmt = "delete EmpresaProveedor where prov_id = " & m_Id
  If Not gDB.Execute(sqlstmt, "pSaveItemsEmpresa", C_Module) Then Exit Function

  With m_ObjAbm.Properties.Item(c_empresas)
    Dim row  As cIABMGridRow
    
    For Each row In .Grid.Rows
    
      If pCell(row, KI_EMPPROV_ID).Id Then
        Set register = New cRegister
        
        With register
          .fieldId = cscEmpProvId
          .Table = csTEmpresaProveedor
          .Id = csNew
          
          .fields.Add2 cscEmpId, pCell(row, KI_EMP_ID).Id, csId
          
          .fields.Add2 cscProvId, m_Id, csId
          
          .fields.HaveLastUpdate = True
          .fields.HaveWhoModify = True
        End With

        If Not gDB.Save(register, , "pSaveItemsEmpresa", C_Module, c_ErrorSave) Then Exit Function
      End If
    Next
  End With
  
  pSaveItemsEmpresa = True
End Function

Private Function pSaveItemsCuentaGrupo() As Boolean
  Dim register As cRegister
  Dim fields   As cFields
  
  With m_ObjAbm.Properties.Item(c_cuentagrupo)
          
    Dim row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscProvCuegId
        .Table = csTProveedorCuentaGrupo
        .Id = csNew
        
        For Each Cell In row
          Select Case Cell.Key
            
            Case KI_PROVCUEG_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_CUEG_ID
              .fields.Add2 cscCuegId, Cell.Id, csId
            Case KI_CUE_ID
              fields.Add2 cscCueId, Cell.Id, csId
          End Select
        Next
        
        fields.Add2 cscProvId, m_Id, csId
        
        fields.HaveLastUpdate = True
        fields.HaveWhoModify = True
        
      End With

      If Not gDB.Save(register, , "pSaveItemsCuentaGrupo", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedCuentaGrupo) And Not m_Copy Then
    m_ItemsDeletedCuentaGrupo = RemoveLastColon(m_ItemsDeletedCuentaGrupo)
    sqlstmt = "delete ProveedorCuentaGrupo where provcueg_id in (" & m_ItemsDeletedCuentaGrupo & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsCuentaGrupo", C_Module) Then Exit Function
  End If
  
  pSaveItemsCuentaGrupo = True
End Function

Private Function pValidateCuitProveedor(ByVal Cuit As String) As Boolean
  On Error GoTo ControlError

  Dim sqlstmt  As String
  Dim rs       As Recordset
  
  If LenB(Cuit) Then
    
    If Not ValidateNroCuit(Cuit, False) Then Exit Function
    
    sqlstmt = "sp_ProveedorValidateCuit " & gDB.sqlString(Cuit)
  
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    
    If Not rs.EOF Then
  
      If m_Id <> gDB.ValField(rs.fields, cscProvId) Then
        MsgWarning LNGGetText(1452, vbNullString, _
                               gDB.ValField(rs.fields, cscProvRazonsocial)), _
                   LNGGetText(1453, vbNullString)
                   'El CUIT ya esta usado por el proveedor (1)
                   'C.U.I.T. Proveedor
        Exit Function
      End If
    End If
  End If
     
  pValidateCuitProveedor = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pValidateCuitProveedor", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pGetCtaGrupo() As cIABMProperty
  Set pGetCtaGrupo = m_ObjAbm.Properties.Item(c_cuentagrupo)
End Function

Private Sub Class_Initialize()
  On Error Resume Next
  c_ErrorSave = LNGGetText(1377, vbNullString) ' Error al grabar el proveedor
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub


'---------------------------------------------------------------------------
' Validar CBU
'
Public Function ChrTran(ByVal source As String, _
                        ByVal toSearch As String, _
                        ByVal Value As String) As String
  Dim i     As Integer
  Dim rtn   As String
  Dim c     As String
  
  For i = 1 To Len(source)
    c = Mid$(source, i, 1)
    If InStr(1, toSearch, c) Then
      c = Value
    End If
    rtn = rtn & c
  Next
  
  ChrTran = rtn
End Function

Private Function pValidarCBU(tcCBU) As Boolean

  Dim lcCBU     As String
  Dim lcBloque1 As String
  Dim lcBloque2 As String
  
  lcCBU = ChrTran(tcCBU, ChrTran(tcCBU, "1234567890", ""), "")
  
  If Len(lcCBU) = 22 Then
    
    lcBloque1 = Mid$(lcCBU, 1, 8)
    lcBloque2 = Mid$(lcCBU, 9, 14)
    
    If Not (pValidarDigito(lcBloque1) And pValidarDigito(lcBloque2)) Then
    
      MsgWarning LNGGetText(4712, vbNullString) ' El CBU ingresado no es valido
      Exit Function
    End If
  
  Else
  
    MsgWarning LNGGetText(4713, vbNullString) 'Largo de CBU incorrecto
    Exit Function
  
  End If
  
  pValidarCBU = True
  
End Function

Private Function pValidarDigito(ByVal tcBloque As String)
  
  Const Pond = "9713"
  
  Dim lnSuma    As Long
  Dim lnLargo   As Long
  Dim ln        As Long
  Dim lcDigito  As String
  Dim lcBloque  As String
  
  lnSuma = 0
  lnLargo = Len(tcBloque)
  lcDigito = Mid$(tcBloque, lnLargo, 1)
  lcBloque = Mid$(tcBloque, 1, lnLargo - 1)
  For ln = 1 To lnLargo - 1
    lnSuma = lnSuma _
             + Val(Mid$(lcBloque, lnLargo - ln, 1)) _
             * Val(Mid$(Pond, 4 - ln Mod 4 + 1, 1))
  Next
  
  pValidarDigito = lcDigito = Right(Str(10 - lnSuma Mod 10), 1)
End Function

