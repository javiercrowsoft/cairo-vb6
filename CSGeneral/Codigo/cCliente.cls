VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCliente"
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
' cCliente
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
Private Const C_Module = "cCliente"

Private Const c_GrupoGeneral = "Ventas-General"
Private Const c_WebUserMailLeyenda = "Leyenda para Usuarios de la Intranet"

Private Const csTblProyecto = 2005
Private Const csTblInforme = 7001

Private Const csTPermiso          As String = "Permiso"
Private Const cscPerId            As String = "per_id"
Private Const cscInfId            As String = "inf_id"
Private Const cscInfNombre        As String = "inf_nombre"
Private Const cscInfCodigo        As String = "inf_codigo"

Private Const c_percepcion = "Percepcion"
Private Const c_empresas = "Empresas"
Private Const c_cuentagrupo = "CuentaGrupo"
Private Const c_sucursales = "Sucursales"
Private Const c_contacto = "Contacto"
Private Const c_dpto = "Departamentos"
Private Const c_informes = "Informes"
Private Const c_web = "web"
Private Const c_web_mail = "webmail"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_CONTACTO                       As Integer = 3
Private Const K_DESCRIP                        As Integer = 4
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
Private Const K_LP_ID                          As Integer = 24
Private Const K_LD_ID                          As Integer = 25
Private Const K_SUCURSALES                     As Integer = 26
Private Const K_YAHOO                          As Integer = 27
Private Const K_MESSANGER                      As Integer = 28
Private Const K_CONTACTOS                      As Integer = 29
Private Const K_VEN_ID                         As Integer = 30
Private Const K_CREDITOCTACTE                  As Integer = 31
Private Const K_CREDITOTOTAL                   As Integer = 32
Private Const K_CREDITOACTIVO                  As Integer = 33
Private Const K_CUENTAGRUPO                    As Integer = 34
Private Const K_PERCEPCION                     As Integer = 35
Private Const K_EMPRESAS                       As Integer = 36
Private Const K_DEPARTAMENTOS                  As Integer = 37
Private Const K_TRANS_ID                       As Integer = 38
Private Const K_EXIGETRANS                     As Integer = 39
Private Const K_CLI_ID_PADRE                   As Integer = 40
Private Const K_PCIATRANSPORTE                 As Integer = 41
Private Const K_EXIGEPROVINCIA                 As Integer = 42

Private Const K_US_NOMBRE                      As Integer = 43
Private Const K_INFORMES                       As Integer = 44
Private Const K_US_WEB                         As Integer = 45
Private Const K_WEB_MAIL                       As Integer = 46

Private Const K_ESPROSPECTO                    As Integer = 47
Private Const K_TIPO_CONTACTO                  As Integer = 48
Private Const K_REFERIDO                       As Integer = 49
Private Const K_PROY_ID                        As Integer = 50
Private Const K_CPA_ID                         As Integer = 51

Private Const K_HORARIO_M_DESDE                As Integer = 52
Private Const K_HORARIO_M_HASTA                As Integer = 53
Private Const K_HORARIO_T_DESDE                As Integer = 54
Private Const K_HORARIO_T_HASTA                As Integer = 55

Private Const K_FP_ID                          As Integer = 56

Private Const KI_S_CLIS_ID                        As Integer = 1
Private Const KI_S_NOMBRE                         As Integer = 2
Private Const KI_S_CODIGO                         As Integer = 3
Private Const KI_S_DESCRIP                        As Integer = 5
Private Const KI_S_LOCALIDAD                      As Integer = 6
Private Const KI_S_CALLE                          As Integer = 7
Private Const KI_S_CALLENUMERO                    As Integer = 8
Private Const KI_S_PISO                           As Integer = 9
Private Const KI_S_DEPTO                          As Integer = 10
Private Const KI_S_TEL                            As Integer = 11
Private Const KI_S_FAX                            As Integer = 12
Private Const KI_S_EMAIL                          As Integer = 13
Private Const KI_S_ZON_ID                         As Integer = 14
Private Const KI_S_CP                             As Integer = 16
Private Const KI_S_PRO_ID                         As Integer = 15
Private Const KI_S_PA_ID                          As Integer = 17
Private Const KI_S_CONTACTO                       As Integer = 18

Private Const KI_CONT_ID                        As Integer = 1
Private Const KI_NOMBRE                         As Integer = 2
Private Const KI_CODIGO                         As Integer = 3
Private Const KI_DESCRIP                        As Integer = 4
Private Const KI_TEL                            As Integer = 5
Private Const KI_CELULAR                        As Integer = 6
Private Const KI_EMAIL                          As Integer = 7
Private Const KI_CARGO                          As Integer = 8
Private Const KI_DIRECCION                      As Integer = 9
Private Const KI_ACTIVO                         As Integer = 12

Private Const KI_CUEG_ID                        As Integer = 2
Private Const KI_CLICUEG_ID                     As Integer = 3
Private Const KI_CUE_ID                         As Integer = 4

Private Const KI_CLIPERC_ID                     As Integer = 1
Private Const KI_PERCT_ID                       As Integer = 2
Private Const KI_PERC_ID                        As Integer = 3
Private Const KI_PERC_DESDE                     As Integer = 4
Private Const KI_PERC_HASTA                     As Integer = 5

Private Const KI_EMPCLI_ID                      As Integer = 1
Private Const KI_EMP_ID                         As Integer = 2

Private Const KI_DPTOCLI_ID                     As Integer = 1
Private Const KI_DPTO_ID                        As Integer = 2

Private Const KI_PER_ID                         As Integer = 1
Private Const KI_INF_ID                         As Integer = 2
Private Const KI_INF_CODIGO                     As Integer = 3
Private Const KI_PRE_ID                         As Integer = 4

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id               As Long
Private m_Nombre           As String
Private m_Codigo           As String
Private m_Contacto         As String
Private m_descrip          As String
Private m_Razonsocial      As String
Private m_Cuit             As String
Private m_Ingresosbrutos   As String
Private m_CatFiscal        As Integer
Private m_Chequeorden      As String
Private m_Codpostal        As String
Private m_CpaNombre        As String
Private m_horario_m_desde  As Date
Private m_horario_m_hasta  As Date
Private m_horario_t_desde  As Date
Private m_horario_t_hasta  As Date
Private m_cpa_id           As Long
Private m_Localidad        As String
Private m_Calle            As String
Private m_Callenumero      As String
Private m_Piso             As String
Private m_Depto            As String
Private m_Tel              As String
Private m_Fax              As String
Private m_Email            As String
Private m_Yahoo            As String
Private m_Messanger        As String
Private m_Web              As String
Private m_pro_id           As Long
Private m_Zon_id           As Long
Private m_provincia        As String
Private m_Zona             As String
Private m_Activo           As Boolean
Private m_EsProspecto      As Boolean
Private m_Cpg_id           As Long
Private m_CondicionPago    As String
Private m_Lp_id            As Long
Private m_ListaPrecio      As String
Private m_Ld_id            As Long
Private m_ListaDescuento   As String
Private m_ven_id           As Long
Private m_Vendedor         As String
Private m_trans_id         As Long
Private m_Transporte       As String
Private m_ExigeTrans       As Boolean
Private m_ExigeProvincia   As Boolean
Private m_PciaTransporte   As Boolean
Private m_Creditoctacte    As Double
Private m_Creditototal     As Double
Private m_Creditoactivo    As Boolean
Private m_ClientePadre     As String
Private m_cli_id_padre     As Long
Private m_clict_id         As Long
Private m_ContactoTipo     As String

Private m_cli_id_referido  As Long
Private m_Referido         As String
Private m_proy_id          As Long
Private m_Proyecto         As String

Private m_formapago        As String
Private m_fp_id            As Long

Private m_Us_id       As Long
Private m_us_activo   As Boolean
Private m_us_nombre   As String

Private m_Editing     As Boolean

Private m_ObjAbm      As cIABMGeneric
Private m_ObjTree     As Object

Private m_IsNew       As Boolean

Private m_BranchId    As Long
Private m_TreeId      As Long

Private m_Host        As cIMenuHost
Private m_Copy        As Boolean

Private m_ItemsDeletedSucursales            As String
Private m_ItemsDeletedContacto              As String
Private m_ItemsDeletedCuentaGrupo           As String
Private m_ItemsDeletedPercepciones          As String
Private m_ItemsDeletedDptos                 As String
Private m_ItemsDeletedInf                   As String

Private m_GenericEdit       As cGenericEdit

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
  
  With m_ObjAbm.Properties(cscCliCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscCliNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscCliCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscCliNombre)
  
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

  Doc.ClientTable = csTCliente
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
                               csPreGNewCliente
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

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  Select Case Key
    Case K_US_WEB
      Dim bWeb    As Boolean
      Dim AbmObj  As cABMGeneric
      
      Set AbmObj = m_ObjAbm
      
      With m_ObjAbm.Properties
        bWeb = Val(.Item(c_web).Value)
        .Item(cscUsId).Enabled = bWeb
        If LenB(.Item(cscUsId).Value) = 0 Then
          .Item(cscUsId).Value = .Item(cscCliCodigo).Value
        End If
        
        AbmObj.ShowValue .Item(cscUsId)
        .Item(c_informes).Enabled = bWeb
        AbmObj.ShowValue .Item(c_informes), True
      End With
    
    Case K_WEB_MAIL
    
      pSendMailToClient True, False
    
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  Dim LastId   As Long
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscCliId
    .Table = csTCliente
  
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
          fields.Add2 cscCliNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscCliCodigo, .Value, csText
        Case K_CONTACTO
          fields.Add2 cscCliContacto, .Value, csText
        Case K_TIPO_CONTACTO
          fields.Add2 cscClictId, .HelpId, csId
        Case K_RAZONSOCIAL
          fields.Add2 cscCliRazonsocial, .Value, csText
        Case K_CUIT
          fields.Add2 cscCliCuit, .Value, csText
        Case K_INGRESOSBRUTOS
          fields.Add2 cscCliIngresosbrutos, .Value, csText
        Case K_CATFISCAL
          fields.Add2 cscCliCatfiscal, .ListItemData, csInteger
        Case K_CHEQUEORDEN
          fields.Add2 cscCliChequeorden, .Value, csText
        Case K_CODPOSTAL
          fields.Add2 cscCliCodpostal, .Value, csText
        Case K_LOCALIDAD
          fields.Add2 cscCliLocalidad, .Value, csText
        Case K_CALLE
          fields.Add2 cscCliCalle, .Value, csText
        Case K_CALLENUMERO
          fields.Add2 cscCliCallenumero, .Value, csText
        Case K_PISO
          fields.Add2 cscCliPiso, .Value, csText
        Case K_DEPTO
          fields.Add2 cscCliDepto, .Value, csText
        Case K_TEL
          fields.Add2 cscCliTel, .Value, csText
        Case K_FAX
          fields.Add2 cscCliFax, .Value, csText
        Case K_EMAIL
          fields.Add2 cscCliEmail, .Value, csText
        Case K_YAHOO
          fields.Add2 cscCliYahoo, .Value, csText
        Case K_MESSANGER
          fields.Add2 cscCliMessanger, .Value, csText
        Case K_WEB
          fields.Add2 cscCliWeb, .Value, csText
        Case K_PRO_ID
          fields.Add2 cscProId, .HelpId, csId
        Case K_ZON_ID
          fields.Add2 cscZonId, .HelpId, csId
        Case K_VEN_ID
          fields.Add2 cscVenId, .HelpId, csId
        Case K_TRANS_ID
          fields.Add2 cscTransId, .HelpId, csId
        Case K_CLI_ID_PADRE
          fields.Add2 cscCliIdPadre, .HelpId, csId
        Case K_EXIGETRANS
          fields.Add2 cscCliExigeTransporte, .Value, csBoolean
        Case K_EXIGEPROVINCIA
          fields.Add2 cscCliExigeProvincia, .Value, csBoolean
        Case K_PCIATRANSPORTE
          fields.Add2 cscCliPciaTransporte, .Value, csBoolean
        Case K_CPG_ID
          fields.Add2 cscCpgId, .HelpId, csId
        Case K_DESCRIP
          fields.Add2 cscCliDescrip, .Value, csText
        Case K_LP_ID
          fields.Add2 cscLpId, .HelpId, csId
        Case K_LD_ID
          fields.Add2 cscLdId, .HelpId, csId
        Case K_CREDITOCTACTE
          fields.Add2 cscCliCreditoctacte, .Value, csCurrency
        Case K_CREDITOTOTAL
          fields.Add2 cscCliCreditototal, .Value, csCurrency
        Case K_CREDITOACTIVO
          fields.Add2 cscCliCreditoactivo, .Value, csBoolean
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
        Case K_ESPROSPECTO
          fields.Add2 cscCliEsProspecto, .Value, csBoolean
        Case K_REFERIDO
          fields.Add2 cscCliIdReferido, .HelpId, csId
        Case K_PROY_ID
          fields.Add2 cscProyId, .HelpId, csId
        Case K_CPA_ID
          fields.Add2 cscCpaId, .HelpId, csId
          
        Case K_FP_ID
          fields.Add2 cscFpId, .HelpId, csId
          
        Case K_HORARIO_M_DESDE
          fields.Add2 cscCliHorarioMdesde, .Value, csDate
        Case K_HORARIO_M_HASTA
          fields.Add2 cscCliHorarioMhasta, .Value, csDate
        Case K_HORARIO_T_DESDE
          fields.Add2 cscCliHorarioTdesde, .Value, csDate
        Case K_HORARIO_T_HASTA
          fields.Add2 cscCliHorarioThasta, .Value, csDate
      End Select
    End With
  Next
  
  If Not m_GenericEdit.Save(m_ObjAbm, register) Then Exit Function

  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
                                                        
  If Not gDB.SaveEx(register, , _
                    cscCliCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.Id
   
  If Not pSaveItemsSucursales() Then GoTo SaveError
  If Not pSaveItemsContacto() Then GoTo SaveError
  If Not pSaveItemsCuentaGrupo() Then GoTo SaveError
  If Not pSaveItemsPercepcion() Then GoTo SaveError
  If Not pSaveItemsEmpresa() Then GoTo SaveError
  If Not pSaveItemsDpto() Then GoTo SaveError
  If Not pSaveItemsInformes() Then GoTo SaveError
  
  If m_Copy Then
    If Not pCopyListaPrecio(LastId, m_Id) Then GoTo SaveError
  End If
    
  If Not register.CommitTrans() Then GoTo SaveError
  
  m_Copy = False
  
  Dim bNewUser As Boolean
  bNewUser = m_Us_id = csNO_ID
  
  cIABMClient_Save = Load(register.Id)
  
  pSendMailToClient bNewUser, True
  
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
  cIABMClient_Title = LNGGetText(1303, vbNullString)  'Clientes
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
                    'Debe indicar un categoria fiscal
            Exit Function
          End If
        Case K_CREDITOCTACTE
          CreditoCC = Val(.Value)
        Case K_CREDITOTOTAL
          CreditoTotal = Val(.Value)
      End Select
    End With
  Next

  If CreditoCC > CreditoTotal Then
    MsgInfo LNGGetText(1380, vbNullString)
            'El credito en cuenta corriente no puede ser mayor que el credito total
    Exit Function
  End If
  
  If Not pValidateCuitCliente(Trim(m_ObjAbm.Properties.Item(cscCliCuit).Value)) Then Exit Function
  
  If Not m_GenericEdit.Validate(m_ObjAbm) Then Exit Function

  cIABMClient_Validate = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_SUCURSALES
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowSuc(row, RowIndex)
    Case K_CONTACTOS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowCont(row, RowIndex)
    Case K_CUENTAGRUPO
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowCuentaGrupo(row, RowIndex)
    Case K_EMPRESAS
      cIABMClientGrid_IsEmptyRow = False
    Case K_DEPARTAMENTOS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowDpto(row, RowIndex)
    Case K_PERCEPCION
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowPercepcion(row, RowIndex)
    Case K_INFORMES
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowInforme(row, RowIndex)
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreGListCliente)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  If Not SecurityCanAccess(csPreGDeleteCliente) Then Exit Function

  Dim sqlstmt As String
  Dim bDelContacto As Boolean
  bDelContacto = Ask(LNGGetText(3496, vbNullString), vbYes) '¿Desea borrar los contactos asociados a este cliente?
  
  sqlstmt = "sp_clienteDelete " & Id & "," & IIf(bDelContacto, 1, 0)
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not pValidateAccessNewEdit(Id) Then Exit Function

  m_ObjAbm.InModalWindow = InModalWindow

  Set m_GenericEdit = New cGenericEdit
  If Not m_GenericEdit.Init(csCliente) Then Exit Function

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
                        '&Cliente
  m_Host.Server.AddMenu LNGGetText(1536, vbNullString), csPreGListCliente, C_MenuVentas, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                  'Clientes
  m_Host.MenuABMClick "CSGeneral2.cCliente", Me, LNGGetText(1303, vbNullString), 0, csETablasGeneral.csCliente
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  Select Case Key
    Case K_INFORMES
      With m_ObjAbm.Properties.Item(c_informes).Grid.Rows

        Dim pre_id      As Long
        Dim inf_codigo  As String

        If Not gDB.GetData("Informe", _
                           cscInfId, NewValueID, _
                           cscPreID, _
                           pre_id) Then Exit Function

        If Not gDB.GetData("Informe", _
                           cscInfId, NewValueID, _
                           cscInfCodigo, _
                           inf_codigo) Then Exit Function

        pCell(.Item(lRow), KI_PRE_ID).Id = pre_id
        pCell(.Item(lRow), KI_INF_CODIGO).Value = inf_codigo
      End With
  End Select
  cIABMClientGrid_ColumnAfterEdit = True
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

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Select Case Key
    Case K_SUCURSALES
      Id = Val(pCell(row, KI_S_CLIS_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedSucursales = m_ItemsDeletedSucursales & Id & C_StrColon
    Case K_CONTACTOS
      Id = Val(pCell(row, KI_CONT_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedContacto = m_ItemsDeletedContacto & Id & C_StrColon
    Case K_CUENTAGRUPO
      Id = Val(pCell(row, KI_CLICUEG_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedCuentaGrupo = m_ItemsDeletedCuentaGrupo & Id & C_StrColon
    Case K_EMPRESAS
      cIABMClientGrid_DeleteRow = False
      Exit Function
    Case K_DEPARTAMENTOS
      Id = Val(pCell(row, KI_DPTOCLI_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedDptos = m_ItemsDeletedDptos & Id & C_StrColon
    Case K_INFORMES
      Id = Val(pCell(row, KI_PER_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedInf = m_ItemsDeletedInf & Id & C_StrColon
    Case K_PERCEPCION
      Id = Val(pCell(row, KI_CLIPERC_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedPercepciones = m_ItemsDeletedPercepciones & Id & C_StrColon
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_SUCURSALES
      cIABMClientGrid_ValidateRow = pValidateRowSucursales(row, RowIndex)
    Case K_CONTACTOS
      cIABMClientGrid_ValidateRow = pValidateRowContacto(row, RowIndex)
    Case K_CUENTAGRUPO
      cIABMClientGrid_ValidateRow = pValidateRowCuentaGrupo(row, RowIndex)
    Case K_EMPRESAS
      cIABMClientGrid_ValidateRow = True
    Case K_DEPARTAMENTOS
      cIABMClientGrid_ValidateRow = pValidateRowDpto(row, RowIndex)
    Case K_PERCEPCION
      cIABMClientGrid_ValidateRow = pValidateRowPercepcion(row, RowIndex)
    Case K_INFORMES
      cIABMClientGrid_ValidateRow = pValidateRowInformes(row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pValidateRowContacto(row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In row
    Select Case Cell.Key
        Case KI_NOMBRE
          If ValEmpty(Cell.Value, csText) Then
            MsgInfo C_DebeIndicarNombre & strRow
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowContacto = True
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
                  'Debe indicar un departamento (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowDpto = True
End Function

Private Function pValidateRowPercepcion(row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In row
    Select Case Cell.Key
        Case KI_PERC_ID
          If ValEmpty(Cell.Id, csId) Then
            MsgInfo LNGGetText(1535, vbNullString, strRow)
                    'Debe indicar una percepción (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowPercepcion = True
End Function

Private Function pValidateRowInformes(row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In row
    Select Case Cell.Key
        Case KI_PRE_ID
          If ValEmpty(Cell.Id, csId) Then
            MsgInfo LNGGetText(1532, vbNullString, strRow)
                    'Este informe no posee una prestación y por tanto no puede asociarse al cliente (1)
            Exit Function
          End If
        Case KI_INF_ID
          If ValEmpty(Cell.Id, csId) Then
            MsgInfo LNGGetText(1533, vbNullString, strRow)
                    'Debe indicar un informe (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowInformes = True
End Function

Private Function pValidateRowCuentaGrupo(row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In row
    Select Case Cell.Key
        Case KI_CUEG_ID
          If ValEmpty(Cell.Id, csId) Then
            MsgInfo LNGGetText(1534, vbNullString, strRow)
                    'Debe indicar un grupo de cuentas (1)
            Exit Function
          End If
        Case KI_CUE_ID
          If ValEmpty(Cell.Id, csId) Then
            MsgInfo LNGGetText(1261, vbNullString, strRow)
                    'Debe indicar una cuenta (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowCuentaGrupo = True
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
  
  If Not gDB.GetData(csTCliente, cscCliId, Id, strField, Data, "GetData", C_Module) Then
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

' funciones privadas

Private Function pValidateAccessNewEdit(ByVal Id As Long) As Boolean
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewCliente) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditCliente) Then Exit Function
  End If
  pValidateAccessNewEdit = True
End Function

Private Function pSaveItemsSucursales() As Boolean
  Dim register As cRegister
  Dim fields   As cFields
  
  With m_ObjAbm.Properties.Item(c_sucursales)
    Dim row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscclisId
        .Table = csTClienteSucursal
        .Id = csNew
        
        For Each Cell In row
          Select Case Cell.Key
            
            Case KI_S_CLIS_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_S_NOMBRE
              fields.Add2 cscclisNombre, Cell.Value, csText
            Case KI_S_CODIGO
              fields.Add2 cscclisCodigo, IIf(LenB(Cell.Value), Cell.Value, c_get_codigo_from_id), csText
            Case KI_S_DESCRIP
              fields.Add2 cscclisDescrip, Cell.Value, csText
            Case KI_S_LOCALIDAD
              fields.Add2 cscclisLocalidad, Cell.Value, csText
            Case KI_S_CALLE
              fields.Add2 cscclisCalle, Cell.Value, csText
            Case KI_S_CALLENUMERO
              fields.Add2 cscclisCallenumero, Cell.Value, csText
            Case KI_S_PISO
              fields.Add2 cscclisPiso, Cell.Value, csText
            Case KI_S_DEPTO
              fields.Add2 cscclisDepto, Cell.Value, csText
            Case KI_S_TEL
              fields.Add2 cscclisTel, Cell.Value, csText
            Case KI_S_FAX
              fields.Add2 cscclisFax, Cell.Value, csText
            Case KI_S_EMAIL
              fields.Add2 cscclisEmail, Cell.Value, csText
            Case KI_S_ZON_ID
              fields.Add2 cscZonId, Cell.Id, csId
            Case KI_S_PRO_ID
              fields.Add2 cscProId, Cell.Id, csId
            Case KI_S_PA_ID
              fields.Add2 cscPaId, Cell.Id, csId
            Case KI_S_CP
              fields.Add2 cscclisCodPostal, Cell.Value, csText
            Case KI_S_CONTACTO
              fields.Add2 cscclisContacto, Cell.Value, csText
              
          End Select
        Next
        
        fields.Add2 cscCliId, m_Id, csId
        
        fields.HaveLastUpdate = True
        fields.HaveWhoModify = True
      End With
                                                                    
      If Not gDB.SaveEx(register, , cscclisCodigo, "pSaveItemsSucursales", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedSucursales) And Not m_Copy Then
    m_ItemsDeletedSucursales = RemoveLastColon(m_ItemsDeletedSucursales)
    sqlstmt = "delete ClienteSucursal where clis_id in (" & m_ItemsDeletedSucursales & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsSucursales", C_Module) Then Exit Function
  End If
  
  pSaveItemsSucursales = True
End Function

Private Function LoadCollection() As Boolean
  Dim filter As String
  Dim c      As cIABMProperty
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 6400
  AbmObj.MinWidth = 12500
  AbmObj.bSendRefresh = True
  
  Const c_tab_general = 0
  Const c_tab_direccion = 1
  Const c_tab_sucursales = 2
  Const c_tab_contactos = 3
  Const c_tab_credito = 4
  Const c_tab_cuentagrupo = 5
  Const c_tab_percepcion = 6
  Const c_tab_empresas = 7
  'Const c_tab_dpto = 8
  Const c_tab_web = 8
  Const c_tab_crm = 9
  
  With m_ObjAbm
  
    With .Tabs
      
      .Clear
    
      With .Add(Nothing)
        .Name = C_strGeneral
      End With
      
      With .Add(Nothing)
        .Index = c_tab_direccion
        .Name = LNGGetText(4791, vbNullString) 'Dir.
      End With
      
      With .Add(Nothing)
        .Index = c_tab_sucursales
        .Name = LNGGetText(4789, vbNullString) 'Suc.
      End With
      
      With .Add(Nothing)
        .Index = c_tab_contactos
        .Name = LNGGetText(1035, vbNullString) 'Contacto
      End With
      
      With .Add(Nothing)
        .Index = c_tab_credito
        .Name = LNGGetText(1392, vbNullString) 'Crédito
      End With
      
      With .Add(Nothing)
        .Index = c_tab_cuentagrupo
        .Name = LNGGetText(1507, vbNullString) 'Ctas.
      End With
      
      With .Add(Nothing)
        .Index = c_tab_percepcion
        .Name = LNGGetText(4790, vbNullString) 'Percep.
      End With
      
      With .Add(Nothing)
        .Index = c_tab_empresas
        .Name = LNGGetText(1171, vbNullString) 'Empresas
      End With
      
      'With .Add(Nothing)
      '  .Index = c_tab_dpto
      '  .Name = LNGGetText(1508, vbNullString) 'Deptos.
      'End With
      
      With .Add(Nothing)
        .Index = c_tab_web
        .Name = LNGGetText(1038, vbNullString) 'Web
      End With
    
      With .Add(Nothing)
        .Index = c_tab_crm
        .Name = LNGGetText(4660, vbNullString) 'CRM
      End With
    
    End With
    
    .Title2 = m_Nombre
    
    With .Properties
  
      .Clear

      With .Add(Nothing, cscCliNombre)
        .PropertyType = cspText
        .Name = C_strNombre
        .Size = 255
        .Width = 6100
        .Key = K_NOMBRE
        .Value = m_Nombre
      End With
      
      With .Add(Nothing, cscCliRazonsocial)
        .PropertyType = cspText
        .Name = LNGGetText(1178, vbNullString) 'Razon Social
        .Width = 6100
        .Size = 255
        .Key = K_RAZONSOCIAL
        .Value = m_Razonsocial
      End With
      
      With .Add(Nothing, cscCliCodigo)
        .PropertyType = cspText
        .Name = C_strCodigo
        .Size = 255
        .Key = K_CODIGO
        .Value = m_Codigo
      End With
      
      With .Add(Nothing, cscActivo)
        .PropertyType = cspCheck
        .Name = C_strActivo
        .Key = K_ACTIVO
        .TopFromProperty = cscCliCodigo
        .Left = 4600
        .LeftLabel = -600
        .TopNotChange = True
        .LeftNotChange = True
        .Value = CInt(m_Activo)
      End With
      
      With .Add(Nothing, cscCliEsProspecto)
        .PropertyType = cspCheck
        .Name = LNGGetText(3952, vbNullString) ' Es un prospecto
        .Key = K_ESPROSPECTO
        .TopFromProperty = cscCliCodigo
        .Left = 6400
        .LeftLabel = -1300
        .TopNotChange = True
        .LeftNotChange = True
        .Value = CInt(m_EsProspecto)
      End With
      
      With .Add(Nothing, cscCliCatfiscal)
        .PropertyType = cspList
        .Name = LNGGetText(1181, vbNullString) 'Categoria Fiscal
        .Key = K_CATFISCAL
        .ListWhoSetItem = csListItemData
        .ListItemData = m_CatFiscal
        
        With .List
          
          With .Add(Nothing, csCatFConsumidorFinal)
            .Id = csCatFConsumidorFinal
            .Value = LNGGetText(1182, vbNullString) 'Consumidor final
          End With
          
          With .Add(Nothing, csCatFNoInscripto)
            .Id = csCatFNoInscripto
            .Value = LNGGetText(1183, vbNullString) 'No Inscripto
          End With
          
          With .Add(Nothing, csCatFInscripto)
            .Id = csCatFInscripto
            .Value = LNGGetText(1184, vbNullString) 'Inscripto
          End With
          
          With .Add(Nothing, csCatFExtranjero)
            .Id = csCatFExtranjero
            .Value = LNGGetText(1185, vbNullString) 'Extranjero
          End With
          
          With .Add(Nothing, csCatFExento)
            .Id = csCatFExento
            .Value = LNGGetText(1186, vbNullString) 'Exento
          End With
        
          With .Add(Nothing, csCatFMonoTributo)
            .Id = csCatFMonoTributo
            .Value = LNGGetText(1187, vbNullString) 'Monotributo
          End With
        
          With .Add(Nothing, csCatFExtranjeroIva)
            .Id = csCatFExtranjeroIva
            .Value = LNGGetText(1188, vbNullString) 'Extranjero con Iva
          End With
        
          With .Add(Nothing, csCatFNoCategorizado)
            .Id = csCatFNoCategorizado
            .Value = LNGGetText(1189, vbNullString) 'No categorizado
          End With
        
          With .Add(Nothing, csCatFNoResponsable)
            .Id = csCatFNoResponsable
            .Value = LNGGetText(1190, vbNullString) 'No responsable
          End With
        
          With .Add(Nothing, csCatFNoResponsableExento)
            .Id = csCatFNoResponsableExento
            .Value = LNGGetText(1191, vbNullString) 'No responsable exento
          End With
        
          With .Add(Nothing, csCatFInscriptoM)
            .Id = csCatFInscriptoM
            .Value = LNGGetText(1192, vbNullString) 'Inscripto M
          End With
        
        End With
      End With
      
      With .Add(Nothing, cscCliCuit)
        .PropertyType = cspText
        .Name = LNGGetText(1179, vbNullString) 'Cuit
        .Size = 13
        .Key = K_CUIT
        .Value = m_Cuit
      End With
      
      With .Add(Nothing, cscCliIngresosbrutos)
        .PropertyType = cspText
        .Name = LNGGetText(1180, vbNullString) 'Ingresos Brutos
        .Size = 20
        .Key = K_INGRESOSBRUTOS
        .Value = m_Ingresosbrutos
      End With
      
      With .Add(Nothing, cscCliIdPadre)
        .PropertyType = cspHelp
        .Table = csCliente
        .Name = LNGGetText(1509, vbNullString) 'Cliente Padre
        .Key = K_CLI_ID_PADRE
        .Value = m_ClientePadre
        .HelpId = m_cli_id_padre
        .HelpFilter = "'cli_id <> " & m_Id & "'"
      End With
      
      With .Add(Nothing, cscCliContacto)
        .PropertyType = cspText
        .Name = LNGGetText(1035, vbNullString) 'Contacto
        .TopFromProperty = cscCliCatfiscal
        .Left = 5500
        .Size = 100
        .Key = K_CONTACTO
        .Value = m_Contacto
      End With
      
      With .Add(Nothing, cscCliChequeorden)
        .PropertyType = cspText
        .Name = LNGGetText(1396, vbNullString) 'Cheque a la orden
        .Size = 100
        .Key = K_CHEQUEORDEN
        .Value = m_Chequeorden
      End With
      
      With .Add(Nothing, cscCpgId)
        .PropertyType = cspHelp
        .Table = csCondicionPago
        .Name = LNGGetText(1395, vbNullString) 'Condición de pago
        .Key = K_CPG_ID
        .Value = m_CondicionPago
        .HelpId = m_Cpg_id
      End With
      
      With .Add(Nothing, cscFpId)
        .PropertyType = cspHelp
        .Table = csFormaPago
        .Name = LNGGetText(3773, vbNullString) 'Forma de pago
        .Key = K_FP_ID
        .Value = m_formapago
        .HelpId = m_fp_id
      End With
      
      With .Add(Nothing, cscLpId)
        .PropertyType = cspHelp
        .TopFromProperty = cscCliNombre
        .Left = 9500
        .Table = csListaPrecio
        
        filter = "exists(select lp_id from listapreciocliente where cli_id =" & m_Id
        filter = filter & " and lp_id = listaprecio.lp_id)"
        
        .HelpFilter = filter
        .Name = LNGGetText(1397, vbNullString) 'Lista de precios
        .Key = K_LP_ID
        .Value = m_ListaPrecio
        .HelpId = m_Lp_id
      End With
    
      With .Add(Nothing, cscLdId)
        .PropertyType = cspHelp
        .Table = csListaDescuento
        .Name = LNGGetText(1398, vbNullString) 'Lista de descuentos
        .Key = K_LD_ID
        
        filter = "exists(select ld_id from listadescuentocliente where cli_id =" & m_Id
        filter = filter & " and ld_id = listadescuento.ld_id)"
        
        .HelpFilter = filter
        .Value = m_ListaDescuento
        .HelpId = m_Ld_id
      End With
      
      With .Add(Nothing, cscVenId)
        .PropertyType = cspHelp
        .Table = csVendedores
        .Name = LNGGetText(1510, vbNullString) 'Vendedor
        .Key = K_VEN_ID
        .Value = m_Vendedor
        .HelpId = m_ven_id
      End With
       
      With .Add(Nothing, cscTransId)
        .PropertyType = cspHelp
        .Table = csTransporte
        .Name = LNGGetText(1050, vbNullString) 'Transporte
        .Key = K_TRANS_ID
        .Value = m_Transporte
        .HelpId = m_trans_id
      End With
      
      With .Add(Nothing, cscCliExigeTransporte)
        .PropertyType = cspCheck
        .Name = LNGGetText(1511, vbNullString) 'Exige Transporte
        .LeftToPrevious = 2500
        .LeftLabel = -1500
        .Key = K_EXIGETRANS
        .Value = CInt(m_ExigeTrans)
      End With
      
      With .Add(Nothing, cscCliExigeProvincia)
        .PropertyType = cspCheck
        .Name = LNGGetText(1512, vbNullString) 'Exige Provincia
        .LeftToPrevious = 2500
        .LeftLabel = -1500
        .Key = K_EXIGEPROVINCIA
        .Value = CInt(m_ExigeProvincia)
      End With
      
      With .Add(Nothing, cscCliPciaTransporte)
        .PropertyType = cspCheck
        .Name = LNGGetText(1513, vbNullString) 'Tomar Pcia. desde Transporte
        .LeftToPrevious = 2500
        .LeftLabel = -2500
        .Key = K_PCIATRANSPORTE
        .Value = CInt(m_PciaTransporte)
      End With
      
      With .Add(Nothing, cscCliCreditoctacte)
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Name = LNGGetText(1399, vbNullString) 'Crédito en cta.cte.
        .TabIndex = c_tab_credito
        .Key = K_CREDITOCTACTE
        .Value = m_Creditoctacte
      End With
    
      With .Add(Nothing, cscCliCreditototal)
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Name = LNGGetText(1400, vbNullString) 'Crédito Total
        .TabIndex = c_tab_credito
        .Key = K_CREDITOTOTAL
        .Value = m_Creditototal
      End With
    
      With .Add(Nothing, cscCliCreditoactivo)
        .PropertyType = cspCheck
        .Name = LNGGetText(1401, vbNullString) 'Crédito Activo
        .TabIndex = c_tab_credito
        .Key = K_CREDITOACTIVO
        .Value = CInt(m_Creditoactivo)
      End With
      
      With .Add(Nothing, cscCliDescrip)
        .PropertyType = cspText
        .SubType = cspMemo
        .Width = 10200
        .Height = 780
        .Name = C_strDescrip
        .Size = 255
        .LeftFromProperty = cscCliNombre
        .TopFromProperty = cscCliPciaTransporte
        .TopToPrevious = 440
        .Key = K_DESCRIP
        .Value = m_descrip
      End With
      
      With .Add(Nothing, cscCliCalle)
        .PropertyType = cspText
        .Name = LNGGetText(1194, vbNullString) 'Calle
        .TabIndex = c_tab_direccion
        .Key = K_CALLE
        .Value = m_Calle
        .Width = 9000
      End With
      
      With .Add(Nothing, cscCliCallenumero)
        .PropertyType = cspText
        .Name = LNGGetText(1065, vbNullString) 'Numero
        .TabIndex = c_tab_direccion
        .Size = 10
        .Key = K_CALLENUMERO
        .Value = m_Callenumero
        .Width = 1200
      End With
      
      With .Add(Nothing, cscCliPiso)
        .PropertyType = cspText
        .Name = LNGGetText(1196, vbNullString) 'Piso
        .TabIndex = c_tab_direccion
        .Size = 4
        .Key = K_PISO
        .Value = m_Piso
        .Width = 1200
      End With
      
      With .Add(Nothing, cscCliDepto)
        .PropertyType = cspText
        .Name = LNGGetText(1278, vbNullString) 'Departamento
        .TabIndex = c_tab_direccion
        .Size = 4
        .Key = K_DEPTO
        .Value = m_Depto
        .Width = 1200
      End With
      
      With .Add(Nothing, cscCliCodpostal)
        .PropertyType = cspText
        .Name = LNGGetText(1199, vbNullString) 'Codigo Postal
        .TabIndex = c_tab_direccion
        .Size = 20
        .Key = K_CODPOSTAL
        .Value = m_Codpostal
        .Width = 1200
      End With
      
      With .Add(Nothing, cscCpaId)
        .PropertyType = cspHelp
        .Table = csCodigoPostal
        .Name = LNGGetText(4964, vbNullString) 'CPA
        .TabIndex = c_tab_direccion
        .Key = K_CPA_ID
        .Value = m_CpaNombre
        .HelpId = m_cpa_id
        .Width = 1200
      End With
      
      With .Add(Nothing, cscCliHorarioMdesde)
        .PropertyType = cspTime
        .Name = LNGGetText(4965, vbNullString) ' Horario desde
        .TabIndex = c_tab_direccion
        .Value = m_horario_m_desde
        .Key = K_HORARIO_M_DESDE
        .TopFromProperty = cscCpaId
        .Left = 4500
        .LeftLabel = -1100
        .LeftNotChange = True
      End With
      
      With .Add(Nothing, cscCliHorarioMhasta)
        .PropertyType = cspTime
        .Name = LNGGetText(4966, vbNullString) ' Hasta
        .TabIndex = c_tab_direccion
        .Value = m_horario_m_hasta
        .Key = K_HORARIO_M_HASTA
        .TopFromProperty = cscCpaId
        .Left = 6100
        .LeftLabel = -500
        .LeftNotChange = True
        .TopNotChange = True
      End With
      
      With .Add(Nothing, cscCliHorarioTdesde)
        .PropertyType = cspTime
        .Name = LNGGetText(4967, vbNullString) ' Desde
        .TabIndex = c_tab_direccion
        .Value = m_horario_t_desde
        .Key = K_HORARIO_T_DESDE
        .TopFromProperty = cscCpaId
        .Left = 7700
        .LeftLabel = -500
        .LeftNotChange = True
        .TopNotChange = True
      End With
      
      With .Add(Nothing, cscCliHorarioThasta)
        .PropertyType = cspTime
        .Name = LNGGetText(4966, vbNullString) ' Hasta
        .TabIndex = c_tab_direccion
        .Value = m_horario_t_hasta
        .Key = K_HORARIO_T_HASTA
        .TopFromProperty = cscCpaId
        .Left = 9200
        .LeftLabel = -500
        .LeftNotChange = True
        .TopNotChange = True
      End With
      
      With .Add(Nothing, cscCliLocalidad)
        .PropertyType = cspText
        .Name = LNGGetText(1198, vbNullString) 'Localidad
        .TabIndex = c_tab_direccion
        .Size = 100
        .Key = K_LOCALIDAD
        .Value = m_Localidad
        .Width = 5000
      End With
      
      With .Add(Nothing, cscProId)
        .PropertyType = cspHelp
        .Table = csProvincia
        .Name = LNGGetText(1080, vbNullString) 'Provincia
        .TabIndex = c_tab_direccion
        .Key = K_PRO_ID
        .Value = m_provincia
        .HelpId = m_pro_id
        .Width = 5000
      End With
      
      With .Add(Nothing, cscZonId)
        .PropertyType = cspHelp
        .Table = csZona
        .Name = LNGGetText(1402, vbNullString) 'Zona
        .TabIndex = c_tab_direccion
        .Key = K_ZON_ID
        .Value = m_Zona
        .HelpId = m_Zon_id
        .Width = 5000
      End With
      
      With .Add(Nothing, cscCliTel)
        .PropertyType = cspText
        .Name = LNGGetText(1036, vbNullString) 'Teléfono
        .TabIndex = c_tab_direccion
        .Size = 100
        .Key = K_TEL
        .Value = m_Tel
        .Width = 6000
        .TopFromProperty = cscCliCallenumero
        .Left = 4200
        .LeftLabel = -900
      End With
      
      With .Add(Nothing, cscCliFax)
        .PropertyType = cspText
        .Name = LNGGetText(1200, vbNullString) 'Fax
        .TabIndex = c_tab_direccion
        .Size = 50
        .Key = K_FAX
        .Value = m_Fax
      End With
      
      With .Add(Nothing, cscCliEmail)
        .PropertyType = cspText
        .Name = LNGGetText(1034, vbNullString) 'E-Mail
        .TabIndex = c_tab_direccion
        .Size = 100
        .Key = K_EMAIL
        .Value = m_Email
      End With
        
      With .Add(Nothing, cscCliWeb)
        .PropertyType = cspText
        .Name = LNGGetText(1038, vbNullString) 'Web
        .TabIndex = c_tab_direccion
        .Size = 100
        .Key = K_WEB
        .Value = m_Web
        .Width = 6000
      End With
      
      With .Add(Nothing, cscCliMessanger)
        .PropertyType = cspText
        .Name = LNGGetText(1515, vbNullString) 'Contactos Messanger
        .TabIndex = c_tab_direccion
        .Size = 100
        .Key = K_MESSANGER
        .Value = m_Messanger
        .TopFromProperty = cscCliFax
        .Left = 7900
        .LeftLabel = -800
      End With
      
      With .Add(Nothing, cscCliYahoo)
        .PropertyType = cspText
        .Name = LNGGetText(1514, vbNullString) 'Contacto Yahoo
        .TabIndex = c_tab_direccion
        .Size = 100
        .Key = K_YAHOO
        .Value = m_Yahoo
      End With
      
      Set c = .Add(Nothing, c_sucursales)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadSucursales(c) Then Exit Function
        .Name = c_sucursales
        .Key = K_SUCURSALES
        .TabIndex = c_tab_sucursales
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedSucursales = vbNullString
      
      Set c = .Add(Nothing, c_contacto)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadContactos(c) Then Exit Function
        .Name = c_contacto
        .Key = K_CONTACTOS
        .TabIndex = c_tab_contactos
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedContacto = vbNullString
      
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
      
      Set c = .Add(Nothing, c_percepcion)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadPercepcion(c) Then Exit Function
        .Name = c_percepcion
        .Key = K_PERCEPCION
        .TabIndex = c_tab_percepcion
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedPercepciones = vbNullString
      
      Set c = .Add(Nothing, c_empresas)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadEmpresas(c) Then Exit Function
        .Name = c_empresas
        .Key = K_EMPRESAS
        .Height = 2500
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
        .TabIndex = c_tab_empresas
        .Top = 4000
        .LeftFromProperty = c_empresas
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      m_ItemsDeletedDptos = vbNullString
      
      With .Add(Nothing, c_web)
        .PropertyType = cspCheck
        .Name = LNGGetText(1517, vbNullString) 'Habilitar el acceso via extranet
        .Key = K_US_WEB
        .Left = 2850
        .LeftNotChange = True
        .LeftLabel = -2500
        .Value = m_Us_id <> csNO_ID And m_us_activo
        .TabIndex = c_tab_web
      End With
      
      With .Add(Nothing, c_web_mail)
        .PropertyType = cspButton
        .Name = LNGGetText(1519, vbNullString) 'Enviar Email
        .Key = K_WEB_MAIL
        .TopFromProperty = c_web
        .Left = 3850
        .LeftNotChange = True
        .LeftLabel = -1
        .Visible = m_Us_id <> csNO_ID And m_us_activo
        .Enabled = m_Us_id <> csNO_ID And m_us_activo
        .TabIndex = c_tab_web
      End With
      
      With .Add(Nothing, cscUsId)
        .PropertyType = cspText
        .Name = LNGGetText(1518, vbNullString) 'Usuario Web
        .Size = 50
        .Key = K_US_NOMBRE
        .Value = m_us_nombre
        .TabIndex = c_tab_web
        .Enabled = m_Us_id <> csNO_ID And m_us_activo
      End With
      
      Set c = .Add(Nothing, c_informes)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadInformes(c) Then Exit Function
        .Name = c_informes
        .Key = K_INFORMES
        .TopFromProperty = cscUsId
        .TopToPrevious = 440
        .Left = 200
        .TabIndex = c_tab_web
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
        .Enabled = m_Us_id <> csNO_ID And m_us_activo
      End With
      m_ItemsDeletedInf = vbNullString
    
      ' CRM
    
      With .Add(Nothing, cscClictId)
        .PropertyType = cspHelp
        .Table = csClienteContactoTipo
        .Name = LNGGetText(4661, vbNullString) 'Tipo de Contacto
        .Key = K_TIPO_CONTACTO
        .Value = m_ContactoTipo
        .HelpId = m_clict_id
        .TabIndex = c_tab_crm
        .Width = 3000
        .LeftLabel = -1500
        .Left = 1800
      End With
    
      With .Add(Nothing, cscCliIdReferido)
        .PropertyType = cspHelp
        .Table = csCliente
        .Name = LNGGetText(4662, vbNullString) 'Referido por
        .Key = K_REFERIDO
        .Value = m_Referido
        .HelpId = m_cli_id_referido
        .HelpFilter = "cli_id <> " & m_Id
        .TabIndex = c_tab_crm
        .Width = 3000
      End With
    
      With .Add(Nothing, cscProyId)
        .PropertyType = cspHelp
        .Table = csTblProyecto
        .Name = LNGGetText(4663, vbNullString) 'Campaña de Marketing
        .Key = K_PROY_ID
        .Value = m_Proyecto
        .HelpId = m_proy_id
        .TabIndex = c_tab_crm
        .Width = 3000
      End With
    
    End With
    
    If Not m_GenericEdit.LoadCollection(m_ObjAbm) Then Exit Function
    
    If Not .Show(Me) Then Exit Function
  End With
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset

  sqlstmt = "sp_clienteGet " & Id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then
  
    m_Id = gDB.ValField(rs.fields, cscCliId)
    m_Nombre = gDB.ValField(rs.fields, cscCliNombre)
    m_Codigo = gDB.ValField(rs.fields, cscCliCodigo)
    m_Contacto = gDB.ValField(rs.fields, cscCliContacto)
    m_Razonsocial = gDB.ValField(rs.fields, cscCliRazonsocial)
    m_Cuit = gDB.ValField(rs.fields, cscCliCuit)
    m_Ingresosbrutos = gDB.ValField(rs.fields, cscCliIngresosbrutos)
    m_CatFiscal = gDB.ValField(rs.fields, cscCliCatfiscal)
    m_Chequeorden = gDB.ValField(rs.fields, cscCliChequeorden)
    m_Codpostal = gDB.ValField(rs.fields, cscCliCodpostal)
    m_Localidad = gDB.ValField(rs.fields, cscCliLocalidad)
    m_Calle = gDB.ValField(rs.fields, cscCliCalle)
    m_Callenumero = gDB.ValField(rs.fields, cscCliCallenumero)
    m_Piso = gDB.ValField(rs.fields, cscCliPiso)
    m_Depto = gDB.ValField(rs.fields, cscCliDepto)
    m_Tel = gDB.ValField(rs.fields, cscCliTel)
    m_Fax = gDB.ValField(rs.fields, cscCliFax)
    m_Email = gDB.ValField(rs.fields, cscCliEmail)
    m_Yahoo = gDB.ValField(rs.fields, cscCliYahoo)
    m_Messanger = gDB.ValField(rs.fields, cscCliMessanger)
    m_Web = gDB.ValField(rs.fields, cscCliWeb)
    m_Creditoctacte = gDB.ValField(rs.fields, cscCliCreditoctacte)
    m_Creditototal = gDB.ValField(rs.fields, cscCliCreditototal)
    m_Creditoactivo = gDB.ValField(rs.fields, cscCliCreditoactivo)
    m_pro_id = gDB.ValField(rs.fields, cscProId)
    m_Zon_id = gDB.ValField(rs.fields, cscZonId)
    m_ven_id = gDB.ValField(rs.fields, cscVenId)
    m_Vendedor = gDB.ValField(rs.fields, cscVenNombre)
    m_trans_id = gDB.ValField(rs.fields, cscTransId)
    m_Transporte = gDB.ValField(rs.fields, cscTransNombre)
    m_ExigeTrans = gDB.ValField(rs.fields, cscCliExigeTransporte)
    m_ExigeProvincia = gDB.ValField(rs.fields, cscCliExigeProvincia)
    m_PciaTransporte = gDB.ValField(rs.fields, cscCliPciaTransporte)
    m_cli_id_padre = gDB.ValField(rs.fields, cscCliIdPadre)
    m_ClientePadre = gDB.ValField(rs.fields, cscCliNombrePadre)
    m_provincia = gDB.ValField(rs.fields, cscProNombre)
    m_Zona = gDB.ValField(rs.fields, cscZonNombre)
    m_Cpg_id = gDB.ValField(rs.fields, cscCpgId)
    m_CondicionPago = gDB.ValField(rs.fields, cscCpgNombre)
    m_descrip = gDB.ValField(rs.fields, cscCliDescrip)
    m_Lp_id = gDB.ValField(rs.fields, cscLpId)
    m_ListaPrecio = gDB.ValField(rs.fields, cscLpNombre)
    m_Ld_id = gDB.ValField(rs.fields, cscLdId)
    m_ListaDescuento = gDB.ValField(rs.fields, cscLdNombre)
    
    m_clict_id = gDB.ValField(rs.fields, cscClictId)
    m_ContactoTipo = gDB.ValField(rs.fields, cscClictNombre)
    
    m_cli_id_referido = gDB.ValField(rs.fields, cscCliIdReferido)
    m_Referido = gDB.ValField(rs.fields, "Referido")
    m_proy_id = gDB.ValField(rs.fields, cscProyId)
    m_Proyecto = gDB.ValField(rs.fields, cscProyNombre)
    
    m_Us_id = gDB.ValField(rs.fields, cscUsId)
    m_us_nombre = gDB.ValField(rs.fields, cscUsNombre)
    m_us_activo = gDB.ValField(rs.fields, "us_activo")
    
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_EsProspecto = gDB.ValField(rs.fields, cscCliEsProspecto)
  
    m_CpaNombre = gDB.ValField(rs.fields, cscCpaCodigo)
    m_cpa_id = gDB.ValField(rs.fields, cscCpaId)
    
    m_horario_m_desde = gDB.ValField(rs.fields, cscCliHorarioMdesde)
    m_horario_m_hasta = gDB.ValField(rs.fields, cscCliHorarioMhasta)
    m_horario_t_desde = gDB.ValField(rs.fields, cscCliHorarioTdesde)
    m_horario_t_hasta = gDB.ValField(rs.fields, cscCliHorarioThasta)
    
    m_formapago = gDB.ValField(rs.fields, cscFpNombre)
    m_fp_id = gDB.ValField(rs.fields, cscFpId)
  
  Else
    
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Contacto = vbNullString
    m_Razonsocial = vbNullString
    m_Cuit = vbNullString
    m_descrip = vbNullString
    m_Ingresosbrutos = vbNullString
    m_CatFiscal = csCatFInscripto
    m_Chequeorden = vbNullString
    m_Codpostal = vbNullString
    m_Localidad = vbNullString
    m_Calle = vbNullString
    m_Callenumero = vbNullString
    m_Piso = vbNullString
    m_Depto = vbNullString
    m_Tel = vbNullString
    m_Fax = vbNullString
    m_Email = vbNullString
    m_Yahoo = vbNullString
    m_Messanger = vbNullString
    m_Web = vbNullString
    m_Creditoctacte = 0
    m_Creditototal = 0
    m_Creditoactivo = True
    m_pro_id = csNO_ID
    m_provincia = vbNullString
    m_Zon_id = csNO_ID
    m_Zona = vbNullString
    m_ven_id = csNO_ID
    m_Vendedor = vbNullString
    m_trans_id = csNO_ID
    m_Transporte = vbNullString
    m_cli_id_padre = csNO_ID
    m_ClientePadre = vbNullString
    m_ExigeTrans = False
    m_ExigeProvincia = False
    m_PciaTransporte = False
    m_Lp_id = csNO_ID
    m_ListaPrecio = vbNullString
    m_Ld_id = csNO_ID
    m_ListaDescuento = vbNullString
    m_Cpg_id = csNO_ID
    m_CondicionPago = vbNullString
    
    m_clict_id = csNO_ID
    m_ContactoTipo = vbNullString
    
    m_cli_id_referido = csNO_ID
    m_Referido = vbNullString
    m_proy_id = csNO_ID
    m_Proyecto = vbNullString
    
    m_CpaNombre = vbNullString
    m_cpa_id = csNO_ID
    
    m_Us_id = csNO_ID
    m_us_activo = False
    m_us_nombre = vbNullString
    
    m_horario_m_desde = csNoDate
    m_horario_m_hasta = csNoDate
    m_horario_t_desde = csNoDate
    m_horario_t_hasta = csNoDate
    
    m_formapago = vbNullString
    m_fp_id = csNO_ID
    
    m_Activo = True
    m_EsProspecto = False

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
  
      With .Item(cscCliNombre)
        .Value = m_Nombre
      End With
      
      With .Item(cscCliRazonsocial)
        .Value = m_Razonsocial
      End With
      
      With .Item(cscCliCodigo)
        .Value = m_Codigo
      End With
      
      With .Item(cscActivo)
        .Value = CInt(m_Activo)
      End With
      
      With .Item(cscCliEsProspecto)
        .Value = CInt(m_EsProspecto)
      End With
      
      With .Item(cscCliCatfiscal)
        .ListItemData = m_CatFiscal
      End With
      
      With .Item(cscCliCuit)
        .Value = m_Cuit
      End With
      
      With .Item(cscCliIngresosbrutos)
        .Value = m_Ingresosbrutos
      End With
      
      With .Item(cscCliIdPadre)
        .Value = m_ClientePadre
        .HelpId = m_cli_id_padre
        .HelpFilter = "'cli_id <> " & m_Id & "'"
      End With
      
      With .Item(cscCliContacto)
        .Value = m_Contacto
      End With
      
      With .Item(cscCliChequeorden)
        .Value = m_Chequeorden
      End With
      
      With .Item(cscCpgId)
        .Value = m_CondicionPago
        .HelpId = m_Cpg_id
      End With
      
      With .Item(cscClictId)
        .Value = m_ContactoTipo
        .HelpId = m_clict_id
      End With
      
      With .Item(cscProyId)
        .Value = m_Proyecto
        .HelpId = m_proy_id
      End With
      
      With .Item(cscCliIdReferido)
        .Value = m_Referido
        .HelpId = m_cli_id_referido
      End With
      
      With .Item(cscLpId)
        filter = "exists(select lp_id from listapreciocliente where cli_id =" & m_Id
        filter = filter & " and lp_id = listaprecio.lp_id)"
        .HelpFilter = filter
        .Value = m_ListaPrecio
        .HelpId = m_Lp_id
      End With
    
      With .Item(cscLdId)
        filter = "exists(select ld_id from listadescuentocliente where cli_id =" & m_Id
        filter = filter & " and ld_id = listadescuento.ld_id)"
        .HelpFilter = filter
        .Value = m_ListaDescuento
        .HelpId = m_Ld_id
      End With
      
      With .Item(cscVenId)
        .Value = m_Vendedor
        .HelpId = m_ven_id
      End With
       
      With .Item(cscTransId)
        .Value = m_Transporte
        .HelpId = m_trans_id
      End With
      
      With .Item(cscCliExigeTransporte)
        .Value = CInt(m_ExigeTrans)
      End With
      
      With .Item(cscCliExigeProvincia)
        .Value = CInt(m_ExigeProvincia)
      End With
      
      With .Item(cscCliPciaTransporte)
        .Value = CInt(m_PciaTransporte)
      End With
      
      With .Item(cscCliCreditoctacte)
        .Value = m_Creditoctacte
      End With
    
      With .Item(cscCliCreditototal)
        .Value = m_Creditototal
      End With
    
      With .Item(cscCliCreditoactivo)
        .Value = CInt(m_Creditoactivo)
      End With
      
      With .Item(cscCliDescrip)
        .Value = m_descrip
      End With
      
      With .Item(cscCliCalle)
        .Value = m_Calle
      End With
      
      With .Item(cscCliCallenumero)
        .Value = m_Callenumero
      End With
      
      With .Item(cscCliPiso)
        .Value = m_Piso
      End With
      
      With .Item(cscCliDepto)
        .Value = m_Depto
      End With
      
      With .Item(cscCliTel)
        .Value = m_Tel
      End With
      
      With .Item(cscCliFax)
        .Value = m_Fax
      End With
      
      With .Item(cscCliEmail)
        .Value = m_Email
      End With
        
      With .Item(cscCliYahoo)
        .Value = m_Yahoo
      End With
      
      With .Item(cscCliMessanger)
        .Value = m_Messanger
      End With
      
      With .Item(cscCliWeb)
        .Value = m_Web
      End With
      
      With .Item(c_web_mail)
        .Visible = m_Us_id <> csNO_ID And m_us_activo
        .Enabled = m_Us_id <> csNO_ID And m_us_activo
      End With
      
      With .Item(cscCliCodpostal)
        .Value = m_Codpostal
      End With
      
      With .Item(cscCpaId)
        .Value = m_CpaNombre
        .HelpId = m_cpa_id
      End With
      
      With .Item(cscCliHorarioMdesde)
        .Value = m_horario_m_desde
      End With
      
      With .Item(cscCliHorarioMhasta)
        .Value = m_horario_m_hasta
      End With
      
      With .Item(cscCliHorarioTdesde)
        .Value = m_horario_t_desde
      End With
      
      With .Item(cscCliHorarioThasta)
        .Value = m_horario_t_hasta
      End With
      
      With .Item(cscCliLocalidad)
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
      
      Set c = .Item(c_sucursales)
      If Not pLoadSucursales(c) Then Exit Sub
      m_ItemsDeletedSucursales = vbNullString
      
      Set c = .Item(c_contacto)
      If Not pLoadContactos(c) Then Exit Sub
      m_ItemsDeletedContacto = vbNullString
      
      Set c = .Item(c_cuentagrupo)
      If Not pLoadCuentaGrupo(c) Then Exit Sub
      m_ItemsDeletedCuentaGrupo = vbNullString
      
      Set c = .Item(c_percepcion)
      If Not pLoadPercepcion(c) Then Exit Sub
      m_ItemsDeletedPercepciones = vbNullString
      
      Set c = .Item(c_empresas)
      If Not pLoadEmpresas(c) Then Exit Sub
      
      Set c = .Item(c_dpto)
      If Not pLoadDpto(c) Then Exit Sub
      m_ItemsDeletedDptos = vbNullString
      
      With .Item(c_web)
        .Value = m_Us_id <> csNO_ID And m_us_activo
      End With
      
      With .Item(cscUsId)
        .Value = m_us_nombre
        .Enabled = m_Us_id <> csNO_ID And m_us_activo
      End With
      
      Set c = .Item(c_informes)
      If Not pLoadInformes(c) Then Exit Sub
      m_ItemsDeletedInf = vbNullString
    
    End With

  End With
  
  m_GenericEdit.RefreshProperties m_ObjAbm

  Set AbmGen = m_ObjAbm
  AbmGen.ShowValues m_ObjAbm.Properties
  
End Sub

Private Function pLoadPercepcion(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select clip.*,perc_nombre,pt.perct_id,perct_nombre" & _
            " from clientepercepcion clip inner join percepcion p on clip.perc_id = p.perc_id" & _
                                        " inner join percepcionTipo pt on p.perct_id = pt.perct_id" & _
                                                                   " and clip.cli_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadPercepcion", C_Module) Then Exit Function
  
  With Propiedad.Grid
  
    With .Columns
    
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_CLIPERC_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1223, vbNullString)  'Tipo
        .PropertyType = cspHelp
        .Table = csPercepcionTipo
        .Width = 3500
        .Key = KI_PERCT_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1252, vbNullString)  'Percepción
        .PropertyType = cspHelp
        .Table = csPercepcion
        .Width = 3500
        .Key = KI_PERC_ID
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(2532, vbNullString)  'Desde
        .PropertyType = cspDate
        .Width = 3500
        .Key = KI_PERC_DESDE
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(2533, vbNullString)  'Hasta
        .PropertyType = cspDate
        .Width = 3500
        .Key = KI_PERC_HASTA
      End With
    
    End With
    
    With .Rows
      
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscCliPercId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscCliPercId).Value
            .Key = KI_CLIPERC_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPerctNombre)
            .Id = gDB.ValField(rs.fields, cscPerctId)
            .Key = KI_PERCT_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPercNombre)
            .Id = gDB.ValField(rs.fields, cscPercId)
            .Key = KI_PERC_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCliPercDesde)
            .Key = KI_PERC_DESDE
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCliPercHasta)
            .Key = KI_PERC_HASTA
          End With
        
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadPercepcion = True
End Function

Private Function pLoadDpto(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select d.dpto_id,dpto_nombre,dptocli_id" & _
            " from Departamento d left join DepartamentoCliente dc on d.dpto_id = dc.dpto_id" & _
            " where dc.cli_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadDpto", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_DPTOCLI_ID
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
      
        With .Add(Nothing, rs(cscDptoCliId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscDptoCliId)
            .Key = KI_DPTOCLI_ID
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

Private Function pLoadInformes(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_clienteGetInformes " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadInformes", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PER_ID
      End With
      
      With .Add(Nothing)
        .Name = C_strCodigo
        .PropertyType = cspText
        .Enabled = False
        .Width = 1200
        .Key = KI_INF_CODIGO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1521, vbNullString)  'Informe
        .PropertyType = cspHelp
        .Table = csTblInforme
        .Width = 6000
        .HelpFilter = User.Id
        .Key = KI_INF_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PRE_ID
      End With
    
    End With
  
    With .Rows
    
      .Clear
    
      While Not rs.EOF
    
        With .Add(Nothing, rs(cscPerId).Value)
      
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPerId)
            .Key = KI_PER_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscInfCodigo)
            .Key = KI_INF_CODIGO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscInfNombre)
            .Id = rs(cscInfId).Value
            .Key = KI_INF_ID
          End With
        
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, cscPreID)
            .Key = KI_PRE_ID
          End With
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadInformes = True
End Function

Private Function pLoadEmpresas(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select e.emp_id,emp_nombre,empcli_id" & _
            " from empresa e left join empresacliente ec" & _
                    " on  e.emp_id = ec.emp_id" & _
                    " and ec.cli_id = " & m_Id
  
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
        .Key = KI_EMPCLI_ID
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
              .Id = gDB.ValField(rs.fields, cscEmpCliId)
            End If
            .Value = .Id
            .Key = KI_EMPCLI_ID
          End With
          
        End With
        
        rs.MoveNext
      Wend
    
    End With
  End With
  
  pLoadEmpresas = True
End Function

Private Function pLoadCuentaGrupo(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select ccg.*,cue_nombre,cueg_nombre" & _
            " from clientecuentagrupo ccg inner join cuenta c on ccg.cue_id = c.cue_id" & _
            "                            inner join cuentagrupo cg on ccg.cueg_id = cg.cueg_id" & _
            " and ccg.cli_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCuentaGrupo", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_CLICUEG_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1404, vbNullString)  'Grupo
        .PropertyType = cspHelp
        .Table = csCuentaGrupo
        .Width = 3500
        .Key = KI_CUEG_ID
        .HelpFilter = "cueg_tipo in (1,4)"
      End With
      
      With .Add(Nothing, cscCueId)
        .Name = LNGGetText(1267, vbNullString)  'Cuenta
        .PropertyType = cspHelp
        .Table = csCuenta
        .Width = 3500
        .Key = KI_CUE_ID
      End With
    
    End With
    
    With .Rows
      
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscCliCuegId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscCliCuegId).Value
            .Key = KI_CLICUEG_ID
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

Private Function pLoadContactos(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select * from Contacto where cli_id = " & m_Id

  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadContactos", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_CONT_ID
      End With
  
      With .Add(Nothing, cscContNombre)
        .Name = C_strNombre
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_NOMBRE
      End With
      
      With .Add(Nothing, cscContCodigo)
        .Name = C_strCodigo
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_CODIGO
      End With
      
      With .Add(Nothing, cscContDescrip)
        .Name = C_strDescrip
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_DESCRIP
      End With
      
      With .Add(Nothing, cscContTel)
        .Name = LNGGetText(1036, vbNullString)   'Telefono
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_TEL
      End With
      
      With .Add(Nothing, cscContCelular)
        .Name = LNGGetText(1276, vbNullString)    'Celular
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_CELULAR
      End With
      
      With .Add(Nothing, cscContEmail)
        .Name = LNGGetText(1034, vbNullString)    'Email
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_EMAIL
      End With
      
      With .Add(Nothing, cscContCargo)
        .Name = LNGGetText(1279, vbNullString)    'Cargo
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_CARGO
      End With
      
      With .Add(Nothing, cscContDireccion)
        .Name = LNGGetText(1037, vbNullString)    'Dirección
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_DIRECCION
      End With
    End With
  
    With .Rows
      
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscContId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscContId).Value
            .Key = KI_CONT_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscContNombre)
            .Key = KI_NOMBRE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscContCodigo)
            .Key = KI_CODIGO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscContDescrip)
            .Key = KI_DESCRIP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscContTel)
            .Key = KI_TEL
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscContCelular)
            .Key = KI_CELULAR
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscContEmail)
            .Key = KI_EMAIL
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscContCargo)
            .Key = KI_CARGO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscContDireccion)
            .Key = KI_DIRECCION
          End With
          
        End With
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadContactos = True
End Function

Private Function pLoadSucursales(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_clienteGetSucursales " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadSucursales", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
    
      .Clear
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_S_CLIS_ID
      End With
      
      With .Add(Nothing)
        .Name = C_strNombre
        .PropertyType = cspText
        .Width = 2500
        .Key = KI_S_NOMBRE
      End With
      
      With .Add(Nothing)
        .Name = C_strCodigo
        .PropertyType = cspText
        .Width = 2000
        .Key = KI_S_CODIGO
      End With
      
      With .Add(Nothing)
        .Name = C_strDescrip
        .PropertyType = cspText
        .Width = 2000
        .Key = KI_S_DESCRIP
      End With
           
      With .Add(Nothing)
        .Name = LNGGetText(1194, vbNullString)    'Calle
        .PropertyType = cspText
        .Width = 2000
        .Key = KI_S_CALLE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1065, vbNullString)    'Numero
        .PropertyType = cspText
        .Width = 2000
        .Key = KI_S_CALLENUMERO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1196, vbNullString)    'Piso
        .PropertyType = cspText
        .Width = 2000
        .Key = KI_S_PISO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1522, vbNullString)    'Dpto.
        .PropertyType = cspText
        .Width = 2000
        .Key = KI_S_DEPTO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1198, vbNullString)    'Localidad
        .PropertyType = cspText
        .Width = 2000
        .Key = KI_S_LOCALIDAD
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1523, vbNullString)    'Cod. Postal
        .PropertyType = cspText
        .Width = 1000
        .Key = KI_S_CP
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1080, vbNullString)    'Provincia
        .PropertyType = cspHelp
        .Table = csProvincia
        .Width = 2000
        .Key = KI_S_PRO_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1212, vbNullString)    'Pais
        .PropertyType = cspHelp
        .Table = csPais
        .Width = 2000
        .Key = KI_S_PA_ID
      End With
           
      With .Add(Nothing)
        .Name = LNGGetText(1036, vbNullString)    'Telefono
        .PropertyType = cspText
        .Width = 2000
        .Key = KI_S_TEL
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1200, vbNullString)    'Fax
        .PropertyType = cspText
        .Width = 2000
        .Key = KI_S_FAX
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1034, vbNullString)    'E-Mail
        .PropertyType = cspText
        .Width = 2000
        .Key = KI_S_EMAIL
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1035, vbNullString)    'Contacto
        .PropertyType = cspText
        .Width = 2000
        .Key = KI_S_CONTACTO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1402, vbNullString)    'Zona
        .PropertyType = cspHelp
        .Table = csZona
        .Width = 2000
        .Key = KI_S_ZON_ID
      End With
    
    End With
    
    With .Rows
      
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscclisId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscclisId).Value
            .Key = KI_S_CLIS_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscclisNombre)
            .Key = KI_S_NOMBRE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscclisCodigo)
            .Key = KI_S_CODIGO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscclisDescrip)
            .Key = KI_S_DESCRIP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscclisCalle)
            .Key = KI_S_CALLE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscclisCallenumero)
            .Key = KI_S_CALLENUMERO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscclisPiso)
            .Key = KI_S_PISO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscclisDepto)
            .Key = KI_S_DEPTO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscclisLocalidad)
            .Key = KI_S_LOCALIDAD
          End With
                    
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscclisCodPostal)
            .Key = KI_S_CP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscProNombre)
            .Id = gDB.ValField(rs.fields, cscProId)
            .Key = KI_S_PRO_ID
          End With
                    
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPaNombre)
            .Id = gDB.ValField(rs.fields, cscPaId)
            .Key = KI_S_PA_ID
          End With
                    
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscclisTel)
            .Key = KI_S_TEL
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscclisFax)
            .Key = KI_S_FAX
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscclisEmail)
            .Key = KI_S_EMAIL
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscclisContacto)
            .Key = KI_S_CONTACTO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscZonNombre)
            .Id = gDB.ValField(rs.fields, cscZonId)
            .Key = KI_S_ZON_ID
          End With
          
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadSucursales = True
End Function

Private Function pIsEmptyRowSuc(ByRef row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In row
    Select Case Cell.Key
      Case KI_S_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_S_CODIGO
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_S_CALLE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowSuc = bRowIsEmpty
End Function

Private Function pIsEmptyRowCont(ByRef row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In row
    Select Case Cell.Key
      Case KI_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_CODIGO
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowCont = bRowIsEmpty
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

Private Function pIsEmptyRowPercepcion(ByRef row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In row
    Select Case Cell.Key
      Case KI_PERC_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowPercepcion = bRowIsEmpty
End Function

Private Function pIsEmptyRowInforme(ByRef row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In row
    Select Case Cell.Key
      Case KI_INF_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowInforme = bRowIsEmpty
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

Private Function pSaveItemsPercepcion() As Boolean
  Dim register As cRegister
  Dim fields   As cFields

  With m_ObjAbm.Properties.Item(c_percepcion)
    Dim row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscCliPercId
        .Table = csTClientePercepcion
        .Id = csNew
        
        For Each Cell In row
          Select Case Cell.Key
            
            Case KI_CLIPERC_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_PERC_ID
              fields.Add2 cscPercId, Cell.Id, csId
            
            Case KI_PERC_DESDE
              fields.Add2 cscCliPercDesde, Cell.Value, csDate
          
            Case KI_PERC_HASTA
              fields.Add2 cscCliPercHasta, Cell.Value, csDate
          End Select
        Next
        
        fields.Add2 cscCliId, m_Id, csId
        
        fields.HaveLastUpdate = True
        fields.HaveWhoModify = True
      End With
                                                                    
      If Not gDB.Save(register, , "pSaveItemsPercepcion", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedPercepciones) And Not m_Copy Then
    m_ItemsDeletedPercepciones = RemoveLastColon(m_ItemsDeletedPercepciones)
    sqlstmt = "delete ClientePercepcion where cliperc_id in (" & m_ItemsDeletedPercepciones & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsPercepcion", C_Module) Then Exit Function
  End If
  
  pSaveItemsPercepcion = True
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
        .fieldId = cscDptoCliId
        .Table = csTDepartamentoCliente
        .Id = csNew
        
        For Each Cell In row
          Select Case Cell.Key
            
            Case KI_DPTOCLI_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_DPTO_ID
              fields.Add2 cscDptoId, Cell.Id, csId
          End Select
        Next
        
        fields.Add2 cscCliId, m_Id, csId
        
        fields.HaveLastUpdate = False
        fields.HaveWhoModify = False
      
      End With
                                                              
      If Not gDB.Save(register, , "pSaveItemsDpto", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedDptos) And Not m_Copy Then
    m_ItemsDeletedDptos = RemoveLastColon(m_ItemsDeletedDptos)
    sqlstmt = "delete DepartamentoCliente where dptocli_id in (" & m_ItemsDeletedDptos & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsDpto", C_Module) Then Exit Function
  End If
  
  pSaveItemsDpto = True
End Function

Private Function pSaveItemsInformes() As Boolean

  Dim sqlstmt As String

  With m_ObjAbm.Properties
    sqlstmt = "sp_clienteUsuarioWebSave " & _
                      m_Id & ", " & _
                      gDB.sqlString( _
                          .Item(cscUsId).Value) & ", " & _
                      "'', " & Val(.Item(c_web).Value) & ", " & _
                      User.Id
  End With

  If Not gDB.Execute(sqlstmt, "pSaveItemsInformes", C_Module) Then Exit Function

  With m_ObjAbm.Properties.Item(c_informes)
    Dim row  As cIABMGridRow
    For Each row In .Grid.Rows
    
      sqlstmt = "sp_clienteInformeSave " & m_Id & ", " & _
                                           pCell(row, KI_PRE_ID).Id & ", " & _
                                           User.Id
      
      If Not gDB.Execute(sqlstmt, "pSaveItemsInformes", C_Module) Then Exit Function
      
    Next
  End With
  
  If LenB(m_ItemsDeletedInf) And Not m_Copy Then
    m_ItemsDeletedInf = RemoveLastColon(m_ItemsDeletedInf)
    sqlstmt = "delete Permiso where per_id in (" & m_ItemsDeletedInf & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsInformes", C_Module) Then Exit Function
  End If
  
  pSaveItemsInformes = True
End Function

Private Function pSaveItemsEmpresa() As Boolean
  Dim register  As cRegister
  Dim fields    As cFields

  Dim sqlstmt As String
  sqlstmt = "delete EmpresaCliente where cli_id = " & m_Id
  If Not gDB.Execute(sqlstmt, "pSaveItemsEmpresa", C_Module) Then Exit Function

  With m_ObjAbm.Properties.Item(c_empresas)
    Dim row  As cIABMGridRow
    
    For Each row In .Grid.Rows
    
      If pCell(row, KI_EMPCLI_ID).Id Then
        
        Set register = New cRegister
        
        With register
          Set fields = .fields
          .fieldId = cscEmpCliId
          .Table = csTEmpresaCliente
          .Id = csNew
          
          fields.Add2 cscEmpId, pCell(row, KI_EMP_ID).Id, csId
          
          fields.Add2 cscCliId, m_Id, csId
          
          fields.HaveLastUpdate = True
          fields.HaveWhoModify = True
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
        .fieldId = cscCliCuegId
        .Table = csTClienteCuentaGrupo
        .Id = csNew
        
        For Each Cell In row
          Select Case Cell.Key
            
            Case KI_CLICUEG_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_CUEG_ID
              fields.Add2 cscCuegId, Cell.Id, csId
            Case KI_CUE_ID
              fields.Add2 cscCueId, Cell.Id, csId
          End Select
        Next
        
        fields.Add2 cscCliId, m_Id, csId
        
        fields.HaveLastUpdate = True
        fields.HaveWhoModify = True
            
      End With
                                                                    
      If Not gDB.Save(register, , "pSaveItemsCuentaGrupo", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedCuentaGrupo) And Not m_Copy Then
    m_ItemsDeletedCuentaGrupo = RemoveLastColon(m_ItemsDeletedCuentaGrupo)
    sqlstmt = "delete ClienteCuentaGrupo where clicueg_id in (" & m_ItemsDeletedCuentaGrupo & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsCuentaGrupo", C_Module) Then Exit Function
  End If
  
  pSaveItemsCuentaGrupo = True
End Function

Private Function pSaveItemsContacto() As Boolean
  Dim register As cRegister
  Dim fields   As cFields

  With m_ObjAbm.Properties.Item(c_contacto)
    Dim row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscContId
        .Table = csTContacto
        .Id = csNew
        
        For Each Cell In row
          Select Case Cell.Key
            
            Case KI_CONT_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KI_NOMBRE
              fields.Add2 cscContNombre, Cell.Value, csText
            Case KI_CODIGO
              fields.Add2 cscContCodigo, IIf(LenB(Cell.Value), Cell.Value, c_get_codigo_from_id), csText
            Case KI_DESCRIP
              fields.Add2 cscContDescrip, Cell.Value, csText
            Case KI_TEL
              fields.Add2 cscContTel, Cell.Value, csText
            Case KI_CELULAR
              fields.Add2 cscContCelular, Cell.Value, csText
            Case KI_EMAIL
              fields.Add2 cscContEmail, Cell.Value, csText
            Case KI_CARGO
              fields.Add2 cscContCargo, Cell.Value, csText
            Case KI_DIRECCION
              fields.Add2 cscContDireccion, Cell.Value, csText
            Case KI_ACTIVO
              fields.Add2 cscActivo, Cell.Id, csBoolean
          End Select
        Next
        
        fields.Add2 cscCliId, m_Id, csId
        
        fields.HaveLastUpdate = True
        fields.HaveWhoModify = True
      
      End With
                                                                  
      If Not gDB.SaveEx(register, , cscContCodigo, "pSaveItemsContacto", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedContacto) And Not m_Copy Then
    m_ItemsDeletedContacto = RemoveLastColon(m_ItemsDeletedContacto)
    sqlstmt = "delete Contacto where cont_id in (" & m_ItemsDeletedContacto & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsContacto", C_Module) Then Exit Function
  End If
  
  pSaveItemsContacto = True
End Function

Private Function pValidateRowSucursales(row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In row
    Select Case Cell.Key
      Case KI_S_NOMBRE
        If ValEmpty(Cell.Value, csText) Then
          Cell.Value = LNGGetText(1281, vbNullString) & " " & RowIndex
        End If
    End Select
  Next
  
  pValidateRowSucursales = True
End Function

' Esta funcion esta practicamente copiada en cClientePV
' si detectan un bug, por favor vean dicha funcion
'
Private Function pValidateCuitCliente(ByVal Cuit As String) As Boolean
  On Error GoTo ControlError

  Dim sqlstmt  As String
  Dim rs       As Recordset
  
  If LenB(Cuit) Then
  
    If Not ValidateNroCuit(Cuit, False) Then Exit Function
  
    sqlstmt = "sp_ClienteValidateCuit " & gDB.sqlString(Cuit)
  
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    
    If Not rs.EOF Then
    
      Dim cli_id As Long
      
      If Not m_Copy Then
        cli_id = m_Id
      End If
    
      If cli_id <> gDB.ValField(rs.fields, cscCliId) Then
       ' If Not Ask("El CUIT ya esta usado por el cliente " & _
                  gDB.ValField(rs.fields, cscCliRazonsocial) & _
                  ";;¿Confirma que desea grabar este cliente con el mismo CUIT?", vbNo) Then
        If Not Ask(LNGGetText(1527, vbNullString, _
                              gDB.ValField(rs.fields, cscCliRazonsocial)), _
                   vbNo) Then
          Exit Function
        End If
      End If
    End If
  Else
    
    Dim bAsk As Boolean
    Dim msg  As String
    
    Select Case m_ObjAbm.Properties.Item(cscCliCatfiscal).ListItemData
      Case csCatFConsumidorFinal
        bAsk = False
      Case csCatFInscripto, csCatFExento, csCatFExtranjero, csCatFMonoTributo, _
           csCatFExtranjeroIva, csCatFNoResponsable, csCatFNoResponsableExento, _
           csCatFNoCategorizado, csCatFInscriptoM
        bAsk = True
      Case Else
        bAsk = True
    End Select
    
    If bAsk Then
      'msg = "Para poder guardar un cliente con esta categoría fiscal " & _
            "deben indicar un número de CUIT. Si guarda sin el CUIT el " & _
            "cliente quedará inactivo."
      msg = LNGGetText(1528, vbNullString)
      
      'If Not Ask(msg & vbCrLf & vbCrLf & "¿Desea guardar los cambios de todas formas?", vbYes) Then
      If Not Ask(msg & vbCrLf & vbCrLf & LNGGetText(1529, vbNullString), vbYes) Then
      
        Exit Function
      Else
        With m_ObjAbm.Properties
          .Item(cscActivo).Value = 0
          m_ObjAbm.ShowValue .Item(cscActivo)
        End With
      End If
    End If
    
  End If
     
  pValidateCuitCliente = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pValidateCuitCliente", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub pSendMailToClient(ByVal bNewUser As Boolean, _
                              Optional ByVal bAsk As Boolean)
  
  Dim us_clave  As String
  Dim us_nombre As String
  Dim bSend     As Boolean
  
  If bNewUser And _
     m_Us_id <> csNO_ID And _
     m_us_activo Then
    
    
    Dim User As CSOAPI2.cUsuario
    Set User = New CSOAPI2.cUsuario
    
    User.GetUser m_Us_id
    
    Dim Pwd  As Object
    Set Pwd = CSKernelClient2.CreateObject("CSMail.cUtil")
    
    us_clave = UCase$(Pwd.GeneratePassword(False))
    
    If Not User.ChangePassword(us_clave) Then Exit Sub
    
    us_nombre = User.Name
  
    If LenB(m_Email) Then
    
      If bAsk Then
    
        'bSend = Ask("Desea enviar un e-mail al cliente notificandole " & _
                    "el alta de su usuario en la extranet?", vbYes)
        bSend = Ask(LNGGetText(1530, vbNullString), vbYes)
                    
      Else
        bSend = True
      End If
      
      If bSend Then
        Dim Mail As Object
        
        Set Mail = CSKernelClient2.CreateObject("CSMail.cMail")
        
        Dim Config As cGeneralConfig
        Set Config = New cGeneralConfig
        
        Dim subject As String
        Dim body   As String
        
        subject = LNGGetText(1539, vbNullString)
                  'Notificación de alta de Usuario
        
        Dim msg As String
        
        msg = pWebMailGetMessage()
        
        If LenB(msg) = 0 Then
          
          'msg = "Le notificamos que hemos creado una cuenta de usuario" & _
                " para que Ud. acceda a nuestra extranet" & vbCrLf & vbCrLf & _
                "Usuario: " & us_nombre & vbCrLf & _
                "Contraseña: " & us_clave
          msg = LNGGetText(1538, vbNullString, us_nombre, us_clave)
          
        Else
          If InStr(1, msg, "@@usuario") Then
            msg = Replace(msg, "@@usuario", us_nombre)
          Else
            msg = msg & vbCrLf & vbCrLf & LNGGetText(1540, vbNullString, us_nombre) ' Usuario:(1)
          End If
          If InStr(1, msg, "@@clave") Then
            msg = Replace(msg, "@@clave", us_clave)
          Else
            msg = msg & vbCrLf & LNGGetText(1540, vbNullString, us_clave) 'Contraseña:(1)
          End If
        End If
        
        body = msg
        
        If Not Config.Load() Then Exit Sub
        
        If Mail.SendEmail(m_Email, _
                          Config.EmailAddress, _
                          Config.EmailAddress, _
                          Config.EmailServer, _
                          Config.EmailPort, _
                          Config.EmailUser, _
                          Config.EmailPwd, subject, body) Then
          MsgInfo LNGGetText(1531, vbNullString)
                'El mail se envio con éxito
        Else
          MsgWarning LNGGetText(1542, vbNullString, Mail.errNumber, Mail.ErrDescrip)
                    'El mail falló " & Mail.errNumber & " - " & Mail.ErrDescrip
        End If
      End If
    
    End If
  
  End If

End Sub

Private Function pWebMailGetMessage() As String
  Dim msg     As String
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset

  sqlstmt = "select * from configuracion where cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
            " And cfg_aspecto = " & gDB.sqlString(c_WebUserMailLeyenda)

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
  
  If Not rs.EOF Then
    msg = gDB.ValField(rs.fields, cscCfgValor)
  End If
  
  pWebMailGetMessage = msg
End Function

Private Function pCopyListaPrecio(ByVal FromId As Long, ByVal ToId As Long)
  Dim sqlstmt As String
  sqlstmt = "sp_clienteCopyListaPrecio " & FromId & "," & ToId & "," & User.Id
  pCopyListaPrecio = gDB.Execute(sqlstmt)
End Function

Private Function pGetCtaGrupo() As cIABMProperty
  Set pGetCtaGrupo = m_ObjAbm.Properties.Item(c_cuentagrupo)
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error Resume Next
  c_ErrorSave = LNGGetText(1537, vbNullString) ' Error al grabar el cliente
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub
