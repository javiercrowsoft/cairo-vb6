VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSocio"
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
' cSocio
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
Private Const C_Module = "cSocio"

Private Const c_contacto = "Contacto"
Private Const c_empresas = "Empresas"

Private Const c_grd_forms = "Forms"
Private Const c_grd_balance = "Balances"
Private Const c_grd_ventaanual = "Ventas"
Private Const c_grd_tarjeta = "Tarjetas"
Private Const c_grd_cliente = "Clientes"
Private Const c_grd_competencia = "Compentencias"
Private Const c_grd_deudabanco = "Deudas"
Private Const c_grd_accionista = "Accionistas"
Private Const c_grd_empresa = "EmpresasV"
Private Const c_grd_inmueble = "Inmuebles"
Private Const c_grd_item = "Socios"
Private Const c_grd_producto = "Productos"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_CONTACTO                       As Integer = 3
Private Const K_DESCRIP                        As Integer = 4
Private Const K_RAZONSOCIAL                    As Integer = 5
Private Const K_CUIT                           As Integer = 6
Private Const K_CATFISCAL                      As Integer = 8
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
Private Const K_YAHOO                          As Integer = 27
Private Const K_MESSANGER                      As Integer = 28
Private Const K_CONTACTOS                      As Integer = 29
Private Const K_EMPRESAS                       As Integer = 36
Private Const K_FORMS                          As Integer = 37

Private Const K_FECHA                          As Integer = 1004
Private Const K_CODA_ID                        As Integer = 1005
Private Const K_ACT_ID                         As Integer = 1006
Private Const K_ACTIVIDAD                      As Integer = 1007
Private Const K_MICAPGBA                       As Integer = 1008
Private Const K_MIINTERIOR                     As Integer = 1009
Private Const K_PA_ID1                         As Integer = 1010
Private Const K_MEPRODUCTO1                    As Integer = 1011
Private Const K_PA_ID2                         As Integer = 1012
Private Const K_MEPRODUCTO2                    As Integer = 1013
Private Const K_PA_ID3                         As Integer = 1014
Private Const K_MEPRODUCTO3                    As Integer = 1015
Private Const K_PA_ID4                         As Integer = 1016
Private Const K_MEPRODUCTO4                    As Integer = 1017
Private Const K_PA_ID5                         As Integer = 1018
Private Const K_MEPRODUCTO5                    As Integer = 1019
Private Const K_CDICZAOPPORCENTAJE             As Integer = 1020
Private Const K_CDICZAOPPLAZO                  As Integer = 1021
Private Const K_CLIENTECF                      As Integer = 1022
Private Const K_CLIENTEATOM                    As Integer = 1023
Private Const K_CLIENTECONC                    As Integer = 1024
Private Const K_CODVTA_CONTADO_DIAS            As Integer = 1025
Private Const K_CODVTA_CONTADO_PORC            As Integer = 1026
Private Const K_CODVTA_CTACTE_DIAS             As Integer = 1027
Private Const K_CODVTA_CTACTE_PORC             As Integer = 1028
Private Const K_CODVTA_DOCUMENTOS_DIAS         As Integer = 1029
Private Const K_CODVTA_DOCUMENTOS_PORC         As Integer = 1030
Private Const K_CODVTA_TARJETA_DIAS            As Integer = 1031
Private Const K_CODVTA_TARJETA_PORC            As Integer = 1032
Private Const K_EMPLEADOCOM                    As Integer = 1033
Private Const K_EMPLEADOADMIN                  As Integer = 1034
Private Const K_EMPLEADOPROD                   As Integer = 1035
Private Const K_COSTOMPMINOMBRE                As Integer = 1036
Private Const K_COSTOMPMIPORC                  As Integer = 1037
Private Const K_COSTOMPMENOMBRE                As Integer = 1038
Private Const K_COSTOMPMEPORC                  As Integer = 1039
Private Const K_COSTOMOMI                      As Integer = 1040
Private Const K_COSTOMOME                      As Integer = 1041
Private Const K_COSTOMIFABRICACION             As Integer = 1042
Private Const K_COSTOMEFABRICACION             As Integer = 1043
Private Const K_CAPACIDADPLENA                 As Integer = 1044
Private Const K_CAPACIDADACTUAL                As Integer = 1045
Private Const K_CAPACIDADUTILIZADA             As Integer = 1046
Private Const K_ESTACOFERTA                    As Integer = 1047
Private Const K_ESTACDEMANDA                   As Integer = 1048
Private Const K_INIACTIVIDADES                 As Integer = 1049
Private Const K_CANTPERSONAL                   As Integer = 1050
Private Const K_LIBRORUBRICADO                 As Integer = 1051
Private Const K_ALTAFIRMANTE                   As Integer = 1052
Private Const K_CARGOFIRMANTE                  As Integer = 1053


'///////////////////////////////////////////////////////////////////////////////////////
'
' GRILLAS
'
'///////////////////////////////////////////////////////////////////////////////////////

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

Private Const KI_EMPCLI_ID                      As Integer = 30
Private Const KI_EMP_ID                         As Integer = 31

Private Const KI_SOCFI_ID                       As Integer = 40
Private Const KI_SOCF_ID                        As Integer = 41

Private Const KI_SOCA_ID                        As Integer = 100
Private Const KI_CUIT                           As Integer = 101
Private Const KI_PARTICIPACION                  As Integer = 102

Private Const KI_SOCB_ID                        As Integer = 150
Private Const KI_FECHA                          As Integer = 151

Private Const KI_SOCCL_ID                       As Integer = 170
Private Const KI_FACTURACION                    As Integer = 171

Private Const KI_SOCC_ID                        As Integer = 190
Private Const KI_MERCADO                        As Integer = 191

Private Const KI_SOCDB_ID                       As Integer = 210
Private Const KI_BCO_ID                         As Integer = 220
Private Const KI_IMPORTE                        As Integer = 230
Private Const KI_TIPOOPERACION                  As Integer = 240
Private Const KI_GARANTIA                       As Integer = 250

Private Const KI_SOCE_ID                        As Integer = 270
Private Const KI_VINCULACION                    As Integer = 271
Private Const KI_TIPO                           As Integer = 272
Private Const KI_EMPRESA                        As Integer = 273

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id               As Long
Private m_nombre           As String
Private m_codigo           As String
Private m_Contacto         As String
Private m_Descrip          As String
Private m_Razonsocial      As String
Private m_Cuit             As String
Private m_CatFiscal        As Integer
Private m_Codpostal        As String
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
Private m_activo           As Boolean
Private m_cpg_id           As Long
Private m_CondicionPago    As String

Private m_Fecha                        As Date
Private m_Coda_id                      As Long
Private m_Actividad                    As String
Private m_Act_id                       As Long
Private m_ActividadAFIP                As String
Private m_ActividadDesc                As String
Private m_Micapgba                     As Double
Private m_Miinterior                   As Double
Private m_Pa_id1                       As Long
Private m_Pais1                        As String
Private m_Meproducto1                  As String
Private m_Pa_id2                       As Long
Private m_Pais2                        As String
Private m_Meproducto2                  As String
Private m_Pa_id3                       As Long
Private m_Pais3                        As String
Private m_Meproducto3                  As String
Private m_Pa_id4                       As Long
Private m_Pais4                        As String
Private m_Meproducto4                  As String
Private m_Pa_id5                       As Long
Private m_Pais5                        As String
Private m_Meproducto5                  As String
Private m_Cdiczaopporcentaje           As Double
Private m_Cdiczaopplazo                As Integer
Private m_Clientecf                    As Boolean
Private m_Clienteatom                  As Boolean
Private m_Clienteconc                  As Boolean
Private m_Codvta_contado_dias          As Integer
Private m_Codvta_contado_porc          As Double
Private m_Codvta_ctacte_dias           As Integer
Private m_Codvta_ctacte_porc           As Double
Private m_Codvta_documentos_dias       As Integer
Private m_Codvta_documentos_porc       As Double
Private m_Codvta_tarjeta_dias          As Integer
Private m_Codvta_tarjeta_porc          As Double
Private m_Empleadocom                  As Integer
Private m_Empleadoadmin                As Integer
Private m_Empleadoprod                 As Integer
Private m_Costompminombre              As String
Private m_Costompmiporc                As Double
Private m_Costompmenombre              As String
Private m_Costompmeporc                As Double
Private m_Costomomi                    As Double
Private m_Costomome                    As Double
Private m_Costomifabricacion           As Double
Private m_Costomefabricacion           As Double
Private m_Capacidadplena               As Long
Private m_Capacidadactual              As Long
Private m_Capacidadutilizada           As Double
Private m_Estacoferta                  As String
Private m_Estacdemanda                 As String
Private m_Iniactividades               As Date
Private m_Cantpersonal                 As Integer
Private m_Librorubricado               As Boolean
Private m_Altafirmante                 As String
Private m_Cargofirmante                As String

Private m_Editing     As Boolean

Private m_ObjAbm      As cIABMGeneric
Private m_ObjTree     As Object

Private m_IsNew       As Boolean

Private m_BranchId    As Long
Private m_TreeId      As Long

Private m_Host        As cIMenuHost
Private m_Copy        As Boolean

Private m_ItemsDeletedContacto              As String

' propiedades publicas

Public Property Get id() As Long
  id = m_Id
End Property

Public Property Get nombre() As String
  nombre = m_nombre
End Property

Public Property Get Codigo() As String
  Codigo = m_codigo
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
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscCliCodigo)
  
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

  Doc.ClientTable = csTSocio
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
                               csPreSGRNewSocio
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
      .id = csNew
    Else
      .id = m_Id
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
        Case K_RAZONSOCIAL
          fields.Add2 cscCliRazonsocial, .Value, csText
        Case K_CUIT
          fields.Add2 cscCliCuit, .Value, csText
        Case K_CATFISCAL
          fields.Add2 cscCliCatfiscal, .ListItemData, csInteger
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
        Case K_CPG_ID
          fields.Add2 cscCpgId, .HelpId, csId
        Case K_DESCRIP
          fields.Add2 cscCliDescrip, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
      
        Case K_FECHA
          fields.Add2 cscSocFecha, .Value, csDate
        Case K_CODA_ID
          fields.Add2 cscCodaId, .HelpId, csId
        Case K_ACT_ID
          fields.Add2 cscActId, .HelpId, csId
        Case K_ACTIVIDAD
          fields.Add2 cscSocActividad, .Value, csText
        Case K_MICAPGBA
          fields.Add2 cscSocMicapgba, .Value, csCurrency
        Case K_MIINTERIOR
          fields.Add2 cscSocMiinterior, .Value, csCurrency
        Case K_PA_ID1
          fields.Add2 cscPaId1, .HelpId, csId
        Case K_MEPRODUCTO1
          fields.Add2 cscSocMeproducto1, .Value, csText
        Case K_PA_ID2
          fields.Add2 cscPaId2, .HelpId, csId
        Case K_MEPRODUCTO2
          fields.Add2 cscSocMeproducto2, .Value, csText
        Case K_PA_ID3
          fields.Add2 cscPaId3, .HelpId, csId
        Case K_MEPRODUCTO3
          fields.Add2 cscSocMeproducto3, .Value, csText
        Case K_PA_ID4
          fields.Add2 cscPaId4, .HelpId, csId
        Case K_MEPRODUCTO4
          fields.Add2 cscSocMeproducto4, .Value, csText
        Case K_PA_ID5
          fields.Add2 cscPaId5, .HelpId, csId
        Case K_MEPRODUCTO5
          fields.Add2 cscSocMeproducto5, .Value, csText
        Case K_CDICZAOPPORCENTAJE
          fields.Add2 cscSocCdiczaopporcentaje, .Value, csCurrency
        Case K_CDICZAOPPLAZO
          fields.Add2 cscSocCdiczaopplazo, .Value, csInteger
        Case K_CLIENTECF
          fields.Add2 cscSocClientecf, .Value, csBoolean
        Case K_CLIENTEATOM
          fields.Add2 cscSocClienteatom, .Value, csBoolean
        Case K_CLIENTECONC
          fields.Add2 cscSocClienteconc, .Value, csBoolean
        Case K_CODVTA_CONTADO_DIAS
          fields.Add2 cscSocCodvtaContadoDias, .Value, csInteger
        Case K_CODVTA_CONTADO_PORC
          fields.Add2 cscSocCodvtaContadoPorc, .Value, csCurrency
        Case K_CODVTA_CTACTE_DIAS
          fields.Add2 cscSocCodvtaCtacteDias, .Value, csInteger
        Case K_CODVTA_CTACTE_PORC
          fields.Add2 cscSocCodvtaCtactePorc, .Value, csCurrency
        Case K_CODVTA_DOCUMENTOS_DIAS
          fields.Add2 cscSocCodvtaDocumentosDias, .Value, csInteger
        Case K_CODVTA_DOCUMENTOS_PORC
          fields.Add2 cscSocCodvtaDocumentosPorc, .Value, csCurrency
        Case K_CODVTA_TARJETA_DIAS
          fields.Add2 cscSocCodvtaTarjetaDias, .Value, csInteger
        Case K_CODVTA_TARJETA_PORC
          fields.Add2 cscSocCodvtaTarjetaPorc, .Value, csCurrency
        Case K_EMPLEADOCOM
          fields.Add2 cscSocEmpleadocom, .Value, csInteger
        Case K_EMPLEADOADMIN
          fields.Add2 cscSocEmpleadoadmin, .Value, csInteger
        Case K_EMPLEADOPROD
          fields.Add2 cscSocEmpleadoprod, .Value, csInteger
        Case K_COSTOMPMINOMBRE
          fields.Add2 cscSocCostompminombre, .Value, csText
        Case K_COSTOMPMIPORC
          fields.Add2 cscSocCostompmiporc, .Value, csCurrency
        Case K_COSTOMPMENOMBRE
          fields.Add2 cscSocCostompmenombre, .Value, csText
        Case K_COSTOMPMEPORC
          fields.Add2 cscSocCostompmeporc, .Value, csCurrency
        Case K_COSTOMOMI
          fields.Add2 cscSocCostomomi, .Value, csCurrency
        Case K_COSTOMOME
          fields.Add2 cscSocCostomome, .Value, csCurrency
        Case K_COSTOMIFABRICACION
          fields.Add2 cscSocCostomifabricacion, .Value, csCurrency
        Case K_COSTOMEFABRICACION
          fields.Add2 cscSocCostomefabricacion, .Value, csCurrency
        Case K_CAPACIDADPLENA
          fields.Add2 cscSocCapacidadplena, .Value, csLong
        Case K_CAPACIDADACTUAL
          fields.Add2 cscSocCapacidadactual, .Value, csLong
        Case K_CAPACIDADUTILIZADA
          fields.Add2 cscSocCapacidadutilizada, .Value, csCurrency
        Case K_ESTACOFERTA
          fields.Add2 cscSocEstacoferta, .Value, csText
        Case K_ESTACDEMANDA
          fields.Add2 cscSocEstacdemanda, .Value, csText
        Case K_INIACTIVIDADES
          fields.Add2 cscSocIniactividades, .Value, csDate
        Case K_CANTPERSONAL
          fields.Add2 cscSocCantpersonal, .Value, csInteger
        Case K_LIBRORUBRICADO
          fields.Add2 cscSocLibrorubricado, .Value, csBoolean
        Case K_ALTAFIRMANTE
          fields.Add2 cscSocAltafirmante, .Value, csText
        Case K_CARGOFIRMANTE
          fields.Add2 cscSocCargofirmante, .Value, csText
      
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
                                                        
  If Not gDB.SaveEx(register, , _
                    cscCliCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.id
   
  If Not pSaveItemsContacto() Then GoTo SaveError
  If Not pSaveItemsEmpresa() Then GoTo SaveError
      
  If Not register.CommitTrans() Then GoTo SaveError
  
  m_Copy = False
    
  cIABMClient_Save = Load(register.id)
  
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
  cIABMClient_Title = LNGGetText(3692, vbNullString)  'Socios
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty     As cIABMProperty

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
        Case K_RAZONSOCIAL
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1172, vbNullString)
                    'Debe indicar una razon social
            Exit Function
          End If
        Case K_CATFISCAL
          If ValEmpty(.ListItemData, csInteger) Then
            MsgInfo LNGGetText(1174, vbNullString)
                    'Debe indicar un categoria fiscal
            Exit Function
          End If
      End Select
    End With
  Next
  
  If Not pValidateCuitCliente(Trim(m_ObjAbm.Properties.Item(cscCliCuit).Value)) Then Exit Function
  
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
    Case K_CONTACTOS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowCont(Row, RowIndex)
    Case K_EMPRESAS
      cIABMClientGrid_IsEmptyRow = False
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreSGRListSocio)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(id As Long) As Boolean
  If Not SecurityCanAccess(csPreSGRDeleteSocio) Then Exit Function

  Dim sqlstmt As String
  Dim bDelContacto As Boolean
  bDelContacto = Ask(LNGGetText(3693, vbNullString), vbYes) '¿Desea borrar los contactos asociados a este socio?
  
  sqlstmt = "sp_socioDelete " & id & "," & IIf(bDelContacto, 1, 0)
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not pValidateAccessNewEdit(id) Then Exit Function

  m_ObjAbm.InModalWindow = InModalWindow

  If Not Load(id) Then Exit Function
  
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

Private Function cIEditGeneric_PrintObj(ByVal id As Long) As Boolean

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

Private Function cIEditGeneric_Preview(ByVal id As Long) As Boolean

End Function

Private Function cIMenuClient_Initialize(f As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Dim str_3690    As String
  
  str_3690 = LNGGetText(3690, vbNullString)  '&Socios
  
  Set m_Host = Host
  
  m_Host.Server.AddMenu str_3690, csMenuEnum.csSocios, C_MenuConfig, 0, True, False, True, False, True, Nothing
                        '&Socio
  m_Host.Server.AddMenu LNGGetText(3694, vbNullString), csPreSGRListSocio, str_3690, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal id As Long) As Variant
                                                  'Socios
  m_Host.MenuABMClick "CSSGR.cSocio", Me, LNGGetText(3692, vbNullString), 0, csETablasSGR.csSocio
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
  Dim id As Long
  
  Select Case Key
    Case K_CONTACTOS
      id = Val(pCell(Row, KI_CONT_ID).Value)
      If id <> csNO_ID Then m_ItemsDeletedContacto = m_ItemsDeletedContacto & id & C_StrColon
    Case K_EMPRESAS
      cIABMClientGrid_DeleteRow = False
      Exit Function
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
    Case K_CONTACTOS
      cIABMClientGrid_ValidateRow = pValidateRowContacto(Row, RowIndex)
    Case K_EMPRESAS
      cIABMClientGrid_ValidateRow = True
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pValidateRowContacto(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
        Case KI_NOMBRE
          If ValEmpty(Cell.Value, csText) Then
            MsgInfo C_DebeIndicarNombre & strRow
            Exit Function
          End If
        Case KI_CODIGO
          If ValEmpty(Cell.Value, csText) Then
            MsgInfo LNGGetText(1526, vbNullString, strRow)
                    'Debe indicar un código (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowContacto = True
End Function

' funciones privadas

Private Function pValidateAccessNewEdit(ByVal id As Long) As Boolean
  If id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreSGRNewSocio) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreSGREditSocio) Then Exit Function
  End If
  pValidateAccessNewEdit = True
End Function

Private Function LoadCollection() As Boolean
  Dim Filter As String
  Dim c      As cIABMProperty
  
  Dim oTab   As cABMTabItem
  Dim iTab   As cIABMTabItem
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 6400
  AbmObj.MinWidth = 12000
  AbmObj.bSendRefresh = True
  
  ' Tabs Principales
  '
  Const c_tab_general = 0
  Const c_tab_direccion = 1
  Const c_tab_contactos = 2
  Const c_tab_empresas = 3
  Const c_tab_datos_sgr = 4
  Const c_tab_form = 5
  Const c_tab_key_datos_comerciales = "kcom"
  Const c_tab_datos_comerciales = 6
  Const c_tab_key_datos_empresa = "kemp"
  Const c_tab_datos_empresa = 7
  
  ' Tabs Internos
  '
  Const c_tab_balance = -1
  Const c_tab_ventaanual = -2
  Const c_tab_tarjeta = -3
  Const c_tab_cliente = -4
  Const c_tab_competencia = -5
  Const c_tab_deudabanco = -6
  
  Const c_tab_accionista = -7
  Const c_tab_empresa = -8
  Const c_tab_inmueble = -9
  Const c_tab_item = -10
  Const c_tab_producto = -11
  
  With m_ObjAbm
  
    With .Tabs
      
      .Clear
    
      With .Add(Nothing)
        .Name = C_strGeneral
      End With
      
      With .Add(Nothing)
        .Index = c_tab_direccion
        .Name = LNGGetText(1037, vbNullString) 'Dirección
      End With
      
      With .Add(Nothing)
        .Index = c_tab_contactos
        .Name = LNGGetText(1035, vbNullString) 'Contacto
      End With
      
      With .Add(Nothing)
        .Index = c_tab_empresas
        .Name = LNGGetText(1171, vbNullString) 'Empresas
      End With
    
      '///////////////////////////////////////////////////////////////
      '
      ' Formularios presentados
      '
      '
      With .Add(Nothing)
        .Name = "SGR"
        .Index = c_tab_datos_sgr
      End With
      
      With .Add(Nothing)
        .Name = "Formularios"
        .Index = c_tab_form
      End With
    
      With .Add(Nothing, c_tab_key_datos_comerciales)
        .Name = "Datos Comerciales"
        .Index = c_tab_datos_comerciales
      End With
      
      With .Add(Nothing, c_tab_key_datos_empresa)
        .Name = "Datos Empresa"
        .Index = c_tab_datos_empresa
      End With
    
      '///////////////////////////////////////////////////////////////
      '
      ' Datos comerciales
      '
      '
    
      Set iTab = .Add(Nothing)
      Set oTab = iTab
      With oTab
        .FatherTab = c_tab_key_datos_comerciales
        .Left = 250
        .Top = 1000
      End With
      With iTab
        .Name = "Balances"
        .Index = c_tab_balance
      End With
    
      Set iTab = .Add(Nothing)
      Set oTab = iTab
      oTab.FatherTab = c_tab_key_datos_comerciales
      With iTab
        .Name = "Venta Anual"
        .Index = c_tab_ventaanual
      End With
    
      Set iTab = .Add(Nothing)
      Set oTab = iTab
      oTab.FatherTab = c_tab_key_datos_comerciales
      With iTab
        .Name = "Tarjetas"
        .Index = c_tab_tarjeta
      End With
        
      Set iTab = .Add(Nothing)
      Set oTab = iTab
      oTab.FatherTab = c_tab_key_datos_comerciales
      With iTab
        .Name = "Clientes"
        .Index = c_tab_cliente
      End With
  
      Set iTab = .Add(Nothing)
      Set oTab = iTab
      oTab.FatherTab = c_tab_key_datos_comerciales
      With iTab
        .Name = "Competencia"
        .Index = c_tab_competencia
      End With
  
      Set iTab = .Add(Nothing)
      Set oTab = iTab
      oTab.FatherTab = c_tab_key_datos_comerciales
      With iTab
        .Name = "Deudas Bancarias"
        .Index = c_tab_deudabanco
      End With
  
      '///////////////////////////////////////////////////////////////
      '
      ' Datos de la empresa
      '
      '
    
      Set iTab = .Add(Nothing)
      Set oTab = iTab
      With oTab
        .FatherTab = c_tab_key_datos_empresa
        .Left = 250
        .Top = 1000
      End With
      With iTab
        .Name = "Accionistas"
        .Index = c_tab_accionista
      End With
      
      Set iTab = .Add(Nothing)
      Set oTab = iTab
      oTab.FatherTab = c_tab_key_datos_empresa
      With iTab
        .Name = "Empresas"
        .Index = c_tab_empresa
      End With
  
      Set iTab = .Add(Nothing)
      Set oTab = iTab
      oTab.FatherTab = c_tab_key_datos_empresa
      With iTab
        .Name = "Inmuebles"
        .Index = c_tab_inmueble
      End With
  
      Set iTab = .Add(Nothing)
      Set oTab = iTab
      oTab.FatherTab = c_tab_key_datos_empresa
      With iTab
        .Name = "Socios/Func."
        .Index = c_tab_item
      End With
  
      Set iTab = .Add(Nothing)
      Set oTab = iTab
      oTab.FatherTab = c_tab_key_datos_empresa
      With iTab
        .Name = "Productos"
        .Index = c_tab_producto
      End With
      
    End With
    
    .Title2 = m_nombre
    
    With .Properties
  
      .Clear

      With .Add(Nothing, cscCliNombre)
        .PropertyType = cspText
        .Name = C_strNombre
        .Size = 255
        .Width = 6100
        .Key = K_NOMBRE
        .Value = m_nombre
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
        .Size = 15
        .Key = K_CODIGO
        .Value = m_codigo
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
        .Value = CInt(m_activo)
      End With
      
      With .Add(Nothing, cscCliCatfiscal)
        .PropertyType = cspList
        .Name = LNGGetText(1181, vbNullString) 'Categoria Fiscal
        .Key = K_CATFISCAL
        .ListWhoSetItem = csListItemData
        .ListItemData = m_CatFiscal
        
        With .List
          
          With .Add(Nothing, csCatFConsumidorFinal)
            .id = csCatFConsumidorFinal
            .Value = LNGGetText(1182, vbNullString) 'Consumidor final
          End With
          
          With .Add(Nothing, csCatFNoInscripto)
            .id = csCatFNoInscripto
            .Value = LNGGetText(1183, vbNullString) 'No Inscripto
          End With
          
          With .Add(Nothing, csCatFInscripto)
            .id = csCatFInscripto
            .Value = LNGGetText(1184, vbNullString) 'Inscripto
          End With
          
          With .Add(Nothing, csCatFExtranjero)
            .id = csCatFExtranjero
            .Value = LNGGetText(1185, vbNullString) 'Extranjero
          End With
          
          With .Add(Nothing, csCatFExento)
            .id = csCatFExento
            .Value = LNGGetText(1186, vbNullString) 'Exento
          End With
        
          With .Add(Nothing, csCatFMonoTributo)
            .id = csCatFMonoTributo
            .Value = LNGGetText(1187, vbNullString) 'Monotributo
          End With
        
          With .Add(Nothing, csCatFExtranjeroIva)
            .id = csCatFExtranjeroIva
            .Value = LNGGetText(1188, vbNullString) 'Extranjero con Iva
          End With
        
          With .Add(Nothing, csCatFNoCategorizado)
            .id = csCatFNoCategorizado
            .Value = LNGGetText(1189, vbNullString) 'No categorizado
          End With
        
          With .Add(Nothing, csCatFNoResponsable)
            .id = csCatFNoResponsable
            .Value = LNGGetText(1190, vbNullString) 'No responsable
          End With
        
          With .Add(Nothing, csCatFNoResponsableExento)
            .id = csCatFNoResponsableExento
            .Value = LNGGetText(1191, vbNullString) 'No responsable exento
          End With
        
          With .Add(Nothing, csCatFInscriptoM)
            .id = csCatFInscriptoM
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
      
      With .Add(Nothing, cscCliContacto)
        .PropertyType = cspText
        .Name = LNGGetText(1035, vbNullString) 'Contacto
        .TopFromProperty = cscCliCatfiscal
        .Left = 5500
        .Size = 100
        .Key = K_CONTACTO
        .Value = m_Contacto
      End With
            
      With .Add(Nothing, cscCpgId)
        .PropertyType = cspHelp
        .Table = csCondicionPago
        .Name = LNGGetText(1395, vbNullString) 'Condición de pago
        .Key = K_CPG_ID
        .Value = m_CondicionPago
        .HelpId = m_cpg_id
      End With
                         
      With .Add(Nothing, cscCliDescrip)
        .PropertyType = cspText
        .SubType = cspMemo
        .Width = 10200
        .Height = 780
        .Name = C_strDescrip
        .Size = 255
        .LeftFromProperty = cscCliNombre
        .TopFromProperty = cscCpgId
        .TopToPrevious = 440
        .Key = K_DESCRIP
        .Value = m_Descrip
      End With
      
      With .Add(Nothing, cscCliCalle)
        .PropertyType = cspText
        .Name = LNGGetText(1194, vbNullString) 'Calle
        .TabIndex = c_tab_direccion
        .Size = 100
        .Key = K_CALLE
        .Value = m_Calle
      End With
      
      With .Add(Nothing, cscCliCallenumero)
        .PropertyType = cspText
        .Name = LNGGetText(1065, vbNullString) 'Numero
        .TabIndex = c_tab_direccion
        .Size = 10
        .Key = K_CALLENUMERO
        .Value = m_Callenumero
      End With
      
      With .Add(Nothing, cscCliPiso)
        .PropertyType = cspText
        .Name = LNGGetText(1196, vbNullString) 'Piso
        .TabIndex = c_tab_direccion
        .Size = 4
        .Key = K_PISO
        .Value = m_Piso
      End With
      
      With .Add(Nothing, cscCliDepto)
        .PropertyType = cspText
        .Name = LNGGetText(1278, vbNullString) 'Departamento
        .TabIndex = c_tab_direccion
        .Size = 4
        .Key = K_DEPTO
        .Value = m_Depto
      End With
      
      With .Add(Nothing, cscCliTel)
        .PropertyType = cspText
        .Name = LNGGetText(1036, vbNullString) 'Teléfono
        .TabIndex = c_tab_direccion
        .Size = 100
        .Key = K_TEL
        .Value = m_Tel
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
        
      With .Add(Nothing, cscCliYahoo)
        .PropertyType = cspText
        .Name = LNGGetText(1514, vbNullString) 'Contacto Yahoo
        .TabIndex = c_tab_direccion
        .Size = 100
        .Key = K_YAHOO
        .Value = m_Yahoo
      End With
      
      With .Add(Nothing, cscCliMessanger)
        .PropertyType = cspText
        .Name = LNGGetText(1515, vbNullString) 'Contactos Messanger
        .TabIndex = c_tab_direccion
        .Size = 100
        .Key = K_MESSANGER
        .Value = m_Messanger
      End With
      
      With .Add(Nothing, cscCliWeb)
        .PropertyType = cspText
        .Name = LNGGetText(1038, vbNullString) 'Web
        .TabIndex = c_tab_direccion
        .Size = 100
        .Key = K_WEB
        .Value = m_Web
      End With
      
      With .Add(Nothing, cscCliCodpostal)
        .PropertyType = cspText
        .Name = LNGGetText(1199, vbNullString) 'Codigo Postal
        .TabIndex = c_tab_direccion
        .Size = 20
        .Key = K_CODPOSTAL
        .Value = m_Codpostal
      End With
      
      With .Add(Nothing, cscCliLocalidad)
        .PropertyType = cspText
        .Name = LNGGetText(1198, vbNullString) 'Localidad
        .TabIndex = c_tab_direccion
        .Size = 100
        .Key = K_LOCALIDAD
        .Value = m_Localidad
      End With
      
      With .Add(Nothing, cscProId)
        .PropertyType = cspHelp
        .Table = csProvincia
        .Name = LNGGetText(1080, vbNullString) 'Provincia
        .TabIndex = c_tab_direccion
        .Key = K_PRO_ID
        .Value = m_provincia
        .HelpId = m_pro_id
      End With
      
      With .Add(Nothing, cscZonId)
        .PropertyType = cspHelp
        .Table = csZona
        .Name = LNGGetText(1402, vbNullString) 'Zona
        .TabIndex = c_tab_direccion
        .Key = K_ZON_ID
        .Value = m_Zona
        .HelpId = m_Zon_id
      End With

'//////////////////////////////////////////////////////////////

      With .Add(Nothing, cscSocFecha)
        .PropertyType = cspDate
        .Name = "fecha"
        .Key = K_FECHA
        .Value = m_Fecha
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscCodaId)
        .PropertyType = cspHelp
        .Table = csAFIPCodigoActividad
        .Name = "Atividad AFIP"
        .Key = K_CODA_ID
        .Value = m_ActividadAFIP
        .HelpId = m_Coda_id
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscActId)
        .PropertyType = cspHelp
        .Table = csActividadComercialTipo
        .Name = "Tipo de Industria"
        .Key = K_ACT_ID
        .Value = m_Actividad
        .HelpId = m_Act_id
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocActividad)
        .PropertyType = cspText
        .Name = "Actividad"
        .Key = K_ACTIVIDAD
        .Value = m_Actividad
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocMicapgba)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = "MI Cap. y GBA"
        .Key = K_MICAPGBA
        .Value = m_Micapgba
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocMiinterior)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = "MI Interior"
        .Key = K_MIINTERIOR
        .Value = m_Miinterior
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscPaId1)
        .PropertyType = cspHelp
        .Table = csPais
        .Name = "Pais 1"
        .Key = K_PA_ID1
        .Value = m_Pais1
        .HelpId = m_Pa_id1
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocMeproducto1)
        .PropertyType = cspText
        .Name = "ME Producto 1"
        .Size = 255
        .Key = K_MEPRODUCTO1
        .Value = m_Meproducto1
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscPaId2)
        .PropertyType = cspHelp
        .Table = csPais
        .Name = "Pais 2"
        .Key = K_PA_ID2
        .Value = m_Pais2
        .HelpId = m_Pa_id2
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocMeproducto2)
        .PropertyType = cspText
        .Name = "ME Producto 2"
        .Size = 255
        .Key = K_MEPRODUCTO2
        .Value = m_Meproducto2
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscPaId3)
        .PropertyType = cspHelp
        .Table = csPais
        .Name = "Pais 3"
        .Key = K_PA_ID3
        .Value = m_Pais3
        .HelpId = m_Pa_id3
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocMeproducto3)
        .PropertyType = cspText
        .Name = "ME Producto 3"
        .Size = 255
        .Key = K_MEPRODUCTO3
        .Value = m_Meproducto3
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscPaId4)
        .PropertyType = cspHelp
        .Table = csPais
        .Name = "Pais 4"
        .Key = K_PA_ID4
        .Value = m_Pais4
        .HelpId = m_Pa_id4
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocMeproducto4)
        .PropertyType = cspText
        .Name = "ME Producto 4"
        .Size = 255
        .Key = K_MEPRODUCTO4
        .Value = m_Meproducto4
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscPaId5)
        .PropertyType = cspHelp
        .Table = csPais
        .Name = "Pais 5"
        .Key = K_PA_ID5
        .Value = m_Pais5
        .HelpId = m_Pa_id5
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocMeproducto5)
        .PropertyType = cspText
        .Name = "ME Producto 5"
        .Size = 255
        .Key = K_MEPRODUCTO5
        .Value = m_Meproducto5
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocCdiczaopporcentaje)
        .PropertyType = cspNumeric
        .SubType = cspPercent
        .Name = "CDI/CZA/OP %"
        .Key = K_CDICZAOPPORCENTAJE
        .Value = m_Cdiczaopporcentaje
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocCdiczaopplazo)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = "CDI/CZA/OP Plazo"
        .Key = K_CDICZAOPPLAZO
        .Value = m_Cdiczaopplazo
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocClientecf)
        .PropertyType = cspCheck
        .Name = "ClienteS Cons. Final"
        .Key = K_CLIENTECF
        .Value = CInt(m_Clientecf)
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocClienteatom)
        .PropertyType = cspCheck
        .Name = "Cliente Atomizados"
        .Key = K_CLIENTEATOM
        .Value = CInt(m_Clienteatom)
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocClienteconc)
        .PropertyType = cspCheck
        .Name = "Cliente Concentrados"
        .Key = K_CLIENTECONC
        .Value = CInt(m_Clienteconc)
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocCodvtaContadoDias)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = "Venta Contado"
        .Key = K_CODVTA_CONTADO_DIAS
        .Value = m_Codvta_contado_dias
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocCodvtaContadoPorc)
        .PropertyType = cspNumeric
        .SubType = cspPercent
        .Name = "Venta Contado %"
        .Key = K_CODVTA_CONTADO_PORC
        .Value = m_Codvta_contado_porc
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocCodvtaCtacteDias)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = "Venta Cta. Cte."
        .Key = K_CODVTA_CTACTE_DIAS
        .Value = m_Codvta_ctacte_dias
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocCodvtaCtactePorc)
        .PropertyType = cspNumeric
        .SubType = cspPercent
        .Name = "Venta Cta. Cte. %"
        .Key = K_CODVTA_CTACTE_PORC
        .Value = m_Codvta_ctacte_porc
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocCodvtaDocumentosDias)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = "Venta Documentos"
        .Key = K_CODVTA_DOCUMENTOS_DIAS
        .Value = m_Codvta_documentos_dias
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocCodvtaDocumentosPorc)
        .PropertyType = cspNumeric
        .SubType = cspPercent
        .Name = "Venta Documentos %"
        .Key = K_CODVTA_DOCUMENTOS_PORC
        .Value = m_Codvta_documentos_porc
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocCodvtaTarjetaDias)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = "Venta Tarjeta"
        .Key = K_CODVTA_TARJETA_DIAS
        .Value = m_Codvta_tarjeta_dias
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocCodvtaTarjetaPorc)
        .PropertyType = cspNumeric
        .SubType = cspPercent
        .Name = "Venta Tarjeta %"
        .Key = K_CODVTA_TARJETA_PORC
        .Value = m_Codvta_tarjeta_porc
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocEmpleadocom)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = "Empleados Comerciales"
        .Key = K_EMPLEADOCOM
        .Value = m_Empleadocom
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocEmpleadoadmin)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = "Empleados Administrativos"
        .Key = K_EMPLEADOADMIN
        .Value = m_Empleadoadmin
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocEmpleadoprod)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = "Empleado Produccion"
        .Key = K_EMPLEADOPROD
        .Value = m_Empleadoprod
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocCostompminombre)
        .PropertyType = cspText
        .Name = "Costo MP MI"
        .Size = 255
        .Key = K_COSTOMPMINOMBRE
        .Value = m_Costompminombre
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocCostompmiporc)
        .PropertyType = cspNumeric
        .SubType = cspPercent
        .Name = "Costo MP MI %"
        .Key = K_COSTOMPMIPORC
        .Value = m_Costompmiporc
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocCostompmenombre)
        .PropertyType = cspText
        .Name = "Costo MP ME"
        .Size = 255
        .Key = K_COSTOMPMENOMBRE
        .Value = m_Costompmenombre
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocCostompmeporc)
        .PropertyType = cspNumeric
        .SubType = cspPercent
        .Name = "Costo MP ME %"
        .Key = K_COSTOMPMEPORC
        .Value = m_Costompmeporc
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocCostomomi)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = "Costo MO MI"
        .Key = K_COSTOMOMI
        .Value = m_Costomomi
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocCostomome)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = "Costo MO ME"
        .Key = K_COSTOMOME
        .Value = m_Costomome
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocCostomifabricacion)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = "Costo MI Fabricación"
        .Key = K_COSTOMIFABRICACION
        .Value = m_Costomifabricacion
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocCostomefabricacion)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = "Costo ME Fabricación"
        .Key = K_COSTOMEFABRICACION
        .Value = m_Costomefabricacion
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocCapacidadplena)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = "Capacidad Plena"
        .Key = K_CAPACIDADPLENA
        .Value = m_Capacidadplena
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocCapacidadactual)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = "Capacidad Actual"
        .Key = K_CAPACIDADACTUAL
        .Value = m_Capacidadactual
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocCapacidadutilizada)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = "Capacidad Utilizada"
        .Key = K_CAPACIDADUTILIZADA
        .Value = m_Capacidadutilizada
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocEstacoferta)
        .PropertyType = cspText
        .Name = "Estacionalidad de la Oferta"
        .Size = 1000
        .Key = K_ESTACOFERTA
        .Value = m_Estacoferta
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocEstacdemanda)
        .PropertyType = cspText
        .Name = "Estacionalidad de la Demanda"
        .Size = 1000
        .Key = K_ESTACDEMANDA
        .Value = m_Estacdemanda
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocIniactividades)
        .PropertyType = cspDate
        .Name = "Inicio de Actividades"
        .Key = K_INIACTIVIDADES
        .Value = m_Iniactividades
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocCantpersonal)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = "Cant Personal"
        .Key = K_CANTPERSONAL
        .Value = m_Cantpersonal
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocLibrorubricado)
        .PropertyType = cspCheck
        .Name = "Libro Rubricado"
        .Key = K_LIBRORUBRICADO
        .Value = CInt(m_Librorubricado)
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocAltafirmante)
        .PropertyType = cspText
        .Name = "Alta Firmante"
        .Size = 255
        .Key = K_ALTAFIRMANTE
        .Value = m_Altafirmante
        .TabIndex = c_tab_datos_sgr
      End With
    
      With .Add(Nothing, cscSocCargofirmante)
        .PropertyType = cspText
        .Name = "Cargo Firmante"
        .Size = 50
        .Key = K_CARGOFIRMANTE
        .Value = m_Cargofirmante
        .TabIndex = c_tab_datos_sgr
      End With
            
'--------------------------------------------------------------
            
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
                
'///////////////////////////////////////////////////////////////////////////

      Set c = .Add(Nothing, c_grd_forms)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadForms(c) Then Exit Function
        .Name = c_grd_forms
        .Key = K_FORMS
        .TabIndex = c_tab_form
        .GridAdd = False
        .GridEdit = True
        .GridRemove = False
      End With

      Set c = .Add(Nothing, c_grd_balance)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        .Left = 200
        .Top = 1500
        If Not pLoadBalances(c) Then Exit Function
        .Name = c_grd_balance
        .Key = K_CONTACTOS
        .TabIndex = c_tab_balance
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedContacto = vbNullString

      Set c = .Add(Nothing, c_grd_ventaanual)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        .Left = 200
        .Top = 1500
        If Not pLoadContactos(c) Then Exit Function
        .Name = c_grd_ventaanual
        .Key = K_CONTACTOS
        .TabIndex = c_tab_ventaanual
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedContacto = vbNullString

      Set c = .Add(Nothing, c_grd_tarjeta)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        .Left = 200
        .Top = 1500
        If Not pLoadContactos(c) Then Exit Function
        .Name = c_grd_tarjeta
        .Key = K_CONTACTOS
        .TabIndex = c_tab_tarjeta
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedContacto = vbNullString

      Set c = .Add(Nothing, c_grd_cliente)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        .Left = 200
        .Top = 1500
        If Not pLoadCliente(c) Then Exit Function
        .Name = c_grd_cliente
        .Key = K_CONTACTOS
        .TabIndex = c_tab_cliente
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedContacto = vbNullString
      
      Set c = .Add(Nothing, c_grd_competencia)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        .Left = 200
        .Top = 1500
        If Not pLoadCompetencia(c) Then Exit Function
        .Name = c_grd_competencia
        .Key = K_CONTACTOS
        .TabIndex = c_tab_competencia
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedContacto = vbNullString

      Set c = .Add(Nothing, c_grd_deudabanco)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        .Left = 200
        .Top = 1500
        If Not pLoadDeudasBanco(c) Then Exit Function
        .Name = c_grd_deudabanco
        .Key = K_CONTACTOS
        .TabIndex = c_tab_deudabanco
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedContacto = vbNullString

      Set c = .Add(Nothing, c_grd_accionista)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        .Left = 200
        .Top = 1500
        If Not pLoadAccionistas(c) Then Exit Function
        .Name = c_grd_accionista
        .Key = K_CONTACTOS
        .TabIndex = c_tab_accionista
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedContacto = vbNullString

      Set c = .Add(Nothing, c_grd_empresa)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        .Left = 200
        .Top = 1500
        If Not pLoadSocioEmpresas(c) Then Exit Function
        .Name = c_grd_empresa
        .Key = K_CONTACTOS
        .TabIndex = c_tab_empresa
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedContacto = vbNullString

      Set c = .Add(Nothing, c_grd_inmueble)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        .Left = 200
        .Top = 1500
        If Not pLoadContactos(c) Then Exit Function
        .Name = c_grd_inmueble
        .Key = K_CONTACTOS
        .TabIndex = c_tab_inmueble
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedContacto = vbNullString

      Set c = .Add(Nothing, c_grd_item)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        .Left = 200
        .Top = 1500
        If Not pLoadContactos(c) Then Exit Function
        .Name = c_grd_item
        .Key = K_CONTACTOS
        .TabIndex = c_tab_item
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedContacto = vbNullString

      Set c = .Add(Nothing, c_grd_producto)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        .Left = 200
        .Top = 1500
        If Not pLoadContactos(c) Then Exit Function
        .Name = c_grd_producto
        .Key = K_CONTACTOS
        .TabIndex = c_tab_producto
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedContacto = vbNullString

    End With
    
    ' Cuando se usan inner tabs como en este abm
    ' hay que llamar a este metodo de abmgeneric
    '
    AbmObj.SetTabCtlIndex
    
    If Not .Show(Me) Then Exit Function
  End With
  
  LoadCollection = True
End Function

Private Function Load(ByVal id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset

  sqlstmt = "sp_clienteGet " & id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then
  
    m_Id = gDB.ValField(rs.fields, cscCliId)
    m_nombre = gDB.ValField(rs.fields, cscCliNombre)
    m_codigo = gDB.ValField(rs.fields, cscCliCodigo)
    m_Contacto = gDB.ValField(rs.fields, cscCliContacto)
    m_Razonsocial = gDB.ValField(rs.fields, cscCliRazonsocial)
    m_Cuit = gDB.ValField(rs.fields, cscCliCuit)
    m_CatFiscal = gDB.ValField(rs.fields, cscCliCatfiscal)
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
    m_pro_id = gDB.ValField(rs.fields, cscProId)
    m_Zon_id = gDB.ValField(rs.fields, cscZonId)
    m_provincia = gDB.ValField(rs.fields, cscProNombre)
    m_Zona = gDB.ValField(rs.fields, cscZonNombre)
    m_cpg_id = gDB.ValField(rs.fields, cscCpgId)
    m_CondicionPago = gDB.ValField(rs.fields, cscCpgNombre)
    m_Descrip = gDB.ValField(rs.fields, cscCliDescrip)
    m_activo = gDB.ValField(rs.fields, cscActivo)
  
  Else
    m_Id = csNO_ID
    m_nombre = vbNullString
    m_codigo = vbNullString
    m_Contacto = vbNullString
    m_Razonsocial = vbNullString
    m_Cuit = vbNullString
    m_Descrip = vbNullString
    m_CatFiscal = csCatFInscripto
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
    m_pro_id = csNO_ID
    m_provincia = vbNullString
    m_Zon_id = csNO_ID
    m_Zona = vbNullString
    m_cpg_id = csNO_ID
    m_CondicionPago = vbNullString
    m_activo = True

  End If

  Load = True
  
End Function

Private Sub pRefreshProperties()
  Dim c      As cIABMProperty
  Dim AbmGen As cABMGeneric
  Dim Filter As String

  With m_ObjAbm
    
    .Title2 = m_nombre
    
    With .Properties
  
      With .Item(cscCliNombre)
        .Value = m_nombre
      End With
      
      With .Item(cscCliRazonsocial)
        .Value = m_Razonsocial
      End With
      
      With .Item(cscCliCodigo)
        .Value = m_codigo
      End With
      
      With .Item(cscActivo)
        .Value = CInt(m_activo)
      End With
      
      With .Item(cscCliCatfiscal)
        .ListItemData = m_CatFiscal
      End With
      
      With .Item(cscCliCuit)
        .Value = m_Cuit
      End With
      
      With .Item(cscCliContacto)
        .Value = m_Contacto
      End With
      
      With .Item(cscCpgId)
        .Value = m_CondicionPago
        .HelpId = m_cpg_id
      End With
                                  
      With .Item(cscCliDescrip)
        .Value = m_Descrip
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
            
      With .Item(cscCliCodpostal)
        .Value = m_Codpostal
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
      
      Set c = .Item(c_contacto)
      If Not pLoadContactos(c) Then Exit Sub
      m_ItemsDeletedContacto = vbNullString
      
      Set c = .Item(c_empresas)
      If Not pLoadEmpresas(c) Then Exit Sub
                      
    End With

  End With
  
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValues m_ObjAbm.Properties
  
End Sub

Private Function pLoadSocioEmpresas(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select * from SocioEmpresa where soc_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadSocioEmpresas", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
            
      With .Add(Nothing)
        .Visible = False
        .Key = KI_SOCE_ID
      End With
  
      With .Add(Nothing)
        .Name = "Empresa"
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_NOMBRE
      End With
      
      With .Add(Nothing)
        .Name = "CUIT"
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_CUIT
      End With
      
      With .Add(Nothing)
        .Name = "Vinculacion"
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_VINCULACION
      End With
      
      With .Add(Nothing)
        .Name = "Participación"
        .PropertyType = cspNumeric
        .SubType = cspPercent
        .Width = 1200
        .Key = KI_PARTICIPACION
      End With
      
      With .Add(Nothing)
        .Name = "Tipo"
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_TIPO
      End With
      
    End With
  
    With .Rows
      
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscSoceId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscSoceId).Value
            .Key = KI_SOCE_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSoceEmpresa)
            .Key = KI_EMPRESA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSoceCuit)
            .Key = KI_CUIT
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSoceVinculacion)
            .Key = KI_VINCULACION
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSoceParticipacion)
            .Key = KI_PARTICIPACION
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSoceTipo)
            .Key = KI_TIPO
          End With
        
        End With
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadSocioEmpresas = True
End Function

Private Function pLoadDeudasBanco(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select s.*, bco_nombre " & _
            "from SocioDeudaBanco s inner join Banco b on s.bco_id = b.bco_id " & _
            "where soc_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadDeudasBanco", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
            
      With .Add(Nothing)
        .Visible = False
        .Key = KI_SOCDB_ID
      End With
  
      With .Add(Nothing)
        .Name = "Banco"
        .PropertyType = cspHelp
        .Table = csBanco
        .Width = 1200
        .Key = KI_BCO_ID
      End With
      
      With .Add(Nothing)
        .Name = "Importe"
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1200
        .Key = KI_IMPORTE
      End With
      
      With .Add(Nothing)
        .Name = "Tipo de Operacion"
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_TIPOOPERACION
      End With
      
      With .Add(Nothing)
        .Name = "Garantia"
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_GARANTIA
      End With
      
    End With
  
    With .Rows
      
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscSocdbId).Value)
                  
          With .Add(Nothing)
            .Value = rs(cscSocdbId).Value
            .Key = KI_SOCDB_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSoccNombre)
            .Key = KI_NOMBRE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscBcoNombre)
            .id = gDB.ValField(rs.fields, cscBcoId)
            .Key = KI_BCO_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSocdbImporte)
            .Key = KI_IMPORTE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSocdbTipooperacion)
            .Key = KI_TIPOOPERACION
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSocdbGarantia)
            .Key = KI_GARANTIA
          End With
        
        End With
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadDeudasBanco = True
End Function

Private Function pLoadCompetencia(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select * from SocioCompetencia where soc_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCompetencia", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
            
      With .Add(Nothing)
        .Visible = False
        .Key = KI_SOCC_ID
      End With
  
      With .Add(Nothing)
        .Name = C_strNombre
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_NOMBRE
      End With
      
      With .Add(Nothing)
        .Name = "% Mercado"
        .PropertyType = cspNumeric
        .SubType = cspPercent
        .Width = 1200
        .Key = KI_MERCADO
      End With
      
      With .Add(Nothing)
        .Name = "Descripción"
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_DESCRIP
      End With
      
    End With
  
    With .Rows
      
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscSoccId).Value)
                  
          With .Add(Nothing)
            .Value = rs(cscSoccId).Value
            .Key = KI_SOCC_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSoccNombre)
            .Key = KI_NOMBRE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSoccMercadoporc)
            .Key = KI_MERCADO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSoccDescrip)
            .Key = KI_DESCRIP
          End With
        
        End With
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadCompetencia = True
End Function

Private Function pLoadCliente(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select * from SocioCliente where soc_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCliente", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
            
      With .Add(Nothing)
        .Visible = False
        .Key = KI_SOCCL_ID
      End With
  
      With .Add(Nothing)
        .Name = C_strNombre
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_NOMBRE
      End With
      
      With .Add(Nothing)
        .Name = "% Facturación"
        .PropertyType = cspNumeric
        .SubType = cspPercent
        .Width = 1200
        .Key = KI_FACTURACION
      End With
      
    End With
  
    With .Rows
      
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscSocclId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscSocclId).Value
            .Key = KI_SOCCL_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSocclNombre)
            .Key = KI_NOMBRE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSocclFactporc)
            .Key = KI_FACTURACION
          End With
        
        End With
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadCliente = True
End Function

Private Function pLoadBalances(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select socb_id, socb_fecha, socb_nombre from SocioBalance where soc_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadBalances", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
            
      With .Add(Nothing)
        .Visible = False
        .Key = KI_SOCB_ID
      End With
      
      With .Add(Nothing)
        .Name = "Fecha"
        .PropertyType = cspDate
        .Width = 1200
        .Key = KI_FECHA
      End With
      
      With .Add(Nothing)
        .Name = C_strNombre
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_NOMBRE
      End With
      
    End With
  
    With .Rows
      
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscSocbId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscSocbId).Value
            .Key = KI_SOCB_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSocbFecha)
            .Key = KI_FECHA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSocbNombre)
            .Key = KI_NOMBRE
          End With
                  
        End With
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadBalances = True
End Function

Private Function pLoadAccionistas(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select * from SocioAccionista where soc_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadAccionistas", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
            
      With .Add(Nothing)
        .Visible = False
        .Key = KI_SOCA_ID
      End With
  
      With .Add(Nothing)
        .Name = C_strNombre
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_NOMBRE
      End With
      
      With .Add(Nothing)
        .Name = "CUIT"
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_CUIT
      End With
      
      With .Add(Nothing)
        .Name = "Participación"
        .PropertyType = cspNumeric
        .SubType = cspPercent
        .Width = 1200
        .Key = KI_PARTICIPACION
      End With
      
    End With
  
    With .Rows
      
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscSocaId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscSocaId).Value
            .Key = KI_SOCA_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSocaNombre)
            .Key = KI_NOMBRE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSocaCuit)
            .Key = KI_CUIT
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSocaParticipacion)
            .Key = KI_PARTICIPACION
          End With
        
        End With
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadAccionistas = True
End Function

Private Function pLoadForms(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select f.socf_id,socf_nombre,socfi_id" & _
            " from SocioForm f left join SocioFormItem fi" & _
                    " on  f.socf_id = fi.socf_id" & _
                    " and fi.soc_id = " & m_Id & _
            " order by f.socf_codigo"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadForms", C_Module) Then Exit Function
  
  With Propiedad.Grid
  
    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
      End With
  
      With .Add(Nothing)
        .Name = "Formulario"
        .PropertyType = cspText
        .Width = 8000
        .Key = KI_SOCF_ID
      End With
      
      With .Add(Nothing)
        .Width = 800
        .PropertyType = cspCheck
        .Key = KI_SOCFI_ID
      End With
      
    End With
    
    Dim bselect As Boolean
    
    If Not rs.EOF Then
      rs.MoveLast
      rs.MoveFirst
      bselect = rs.RecordCount = 1
    End If
    
    With .Rows
    
      .Clear
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscSocfId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscSocfId).Value
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSocfNombre)
            .id = rs(cscSocfId).Value
            .Key = KI_SOCF_ID
          End With
          
          With .Add(Nothing)
            If bselect Then
              .id = 1
            Else
              .id = gDB.ValField(rs.fields, cscSocfiId)
            End If
            .Value = .id
            .Key = KI_SOCFI_ID
          End With
          
        End With
        
        rs.MoveNext
      Wend
    
    End With
  End With
  
  pLoadForms = True

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
    
    Dim bselect As Boolean
    
    If Not rs.EOF Then
      rs.MoveLast
      rs.MoveFirst
      bselect = rs.RecordCount = 1
    End If
    
    With .Rows
    
      .Clear
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscEmpId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscEmpId).Value
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscEmpNombre)
            .id = rs(cscEmpId).Value
            .Key = KI_EMP_ID
          End With
          
          With .Add(Nothing)
            If bselect Then
              .id = 1
            Else
              .id = gDB.ValField(rs.fields, cscEmpCliId)
            End If
            .Value = .id
            .Key = KI_EMPCLI_ID
          End With
          
        End With
        
        rs.MoveNext
      Wend
    
    End With
  End With
  
  pLoadEmpresas = True
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

Private Function pIsEmptyRowCont(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
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

Private Function pSaveItemsEmpresa() As Boolean
  Dim register  As cRegister
  Dim fields    As cFields

  Dim sqlstmt As String
  sqlstmt = "delete EmpresaCliente where cli_id = " & m_Id
  If Not gDB.Execute(sqlstmt, "pSaveItemsEmpresa", C_Module) Then Exit Function

  With m_ObjAbm.Properties.Item(c_empresas)
    Dim Row  As cIABMGridRow
    
    For Each Row In .Grid.Rows
    
      If pCell(Row, KI_EMPCLI_ID).id Then
        
        Set register = New cRegister
        
        With register
          Set fields = .fields
          .fieldId = cscEmpCliId
          .Table = csTEmpresaCliente
          .id = csNew
          
          fields.Add2 cscEmpId, pCell(Row, KI_EMP_ID).id, csId
          
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

Private Function pSaveItemsContacto() As Boolean
  Dim register As cRegister
  Dim fields   As cFields

  With m_ObjAbm.Properties.Item(c_contacto)
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscContId
        .Table = csTContacto
        .id = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_CONT_ID
              If Not m_Copy Then
                .id = Val(Cell.Value)
              End If
            Case KI_NOMBRE
              fields.Add2 cscContNombre, Cell.Value, csText
            Case KI_CODIGO
              fields.Add2 cscContCodigo, Cell.Value, csText
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
              fields.Add2 cscActivo, Cell.id, csBoolean
          End Select
        Next
        
        fields.Add2 cscCliId, m_Id, csId
        
        fields.HaveLastUpdate = True
        fields.HaveWhoModify = True
      
      End With
                                                                  
      If Not gDB.Save(register, , "pSaveItemsContacto", C_Module, c_ErrorSave) Then Exit Function
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
