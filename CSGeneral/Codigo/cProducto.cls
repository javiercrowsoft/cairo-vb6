VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProducto"
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
' cProducto
' 24-06-01

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cProducto"

Private Const c_productoKit = "PRODKIT"
Private Const c_proveedor = "PROV"
Private Const c_cliente = "CLI"
Private Const c_cmi = "CMI"
Private Const c_BOM = "BOM"
Private Const c_TAGS = "TAGS"
Private Const c_WEB_IMAGES = "WEB_IMAGES"
Private Const c_leyendas = "LEYENDAS"

Private Const c_WEB_catalogs = "WEB_catalogs"
Private Const c_WEB_categories = "WEB_categories"

Private Const csExpoGrupoPrecio = 22502
Private Const csExpoFamilia = 22501
Private Const csComunidadInternet = 39001

Private Const csCurso = 37005
Private Const csReporte = -7002

Private Const K_NOMBRECOMPRA                   As Integer = 2
Private Const K_NOMBREVENTA                    As Integer = 3
Private Const K_NOMBREFACTURA                  As Integer = 179
Private Const K_CODIGO                         As Integer = 4
Private Const K_CODIGO_BARRA                   As Integer = 200
Private Const K_CODIGO_BARRA_NOMBRE            As Integer = 201
Private Const K_ACTIVO                         As Integer = 5
Private Const K_DESCRIPVENTA                   As Integer = 6
Private Const K_DESCRIPCOMPRA                  As Integer = 7
Private Const K_UN_ID_COMPRA                   As Integer = 8
Private Const K_UN_ID_VENTA                    As Integer = 9
Private Const K_UN_ID_STOCK                    As Integer = 10
Private Const K_COMPRAVENTA                    As Integer = 11
Private Const K_VENTASTOCK                     As Integer = 12
Private Const K_COMPRASTOCK                    As Integer = 13
Private Const K_LLEVASTOCK                     As Integer = 14
Private Const K_SECOMPRA                       As Integer = 15
Private Const K_SEVENDE                        As Integer = 16
Private Const K_NO_REDONDEO                    As Integer = 520
Private Const K_DINERARIO                      As Integer = 510
Private Const K_ESKIT                          As Integer = 17
Private Const K_ESLISTA                        As Integer = 18
Private Const K_TI_ID_IVARICOMPRA              As Integer = 19
'Private Const K_TI_ID_IVARNICOMPRA             As Integer = 20
Private Const K_TI_ID_IVARIVENTA               As Integer = 21
'Private Const K_TI_ID_IVARNIVENTA              As Integer = 22
Private Const K_TI_ID_INTERNOSV                As Integer = 23
Private Const K_TI_ID_INTERNOSC                As Integer = 24
Private Const K_PORCINTERNOC                   As Integer = 25
Private Const K_PORCINTERNOV                   As Integer = 26
Private Const K_IBC_ID                         As Integer = 27
Private Const K_CUEG_ID_COMPRA                 As Integer = 28
Private Const K_CUEG_ID_VENTA                  As Integer = 29
Private Const K_X                              As Integer = 30
Private Const K_Y                              As Integer = 31
Private Const K_Z                              As Integer = 32
Private Const K_TIENEHIJO                      As Integer = 33
Private Const K_ID_PADRE                       As Integer = 34
Private Const K_EDITAPRECIOHIJO                As Integer = 35
Private Const K_PERMITEEDICION                 As Integer = 36
Private Const K_BORRADO                        As Integer = 37
Private Const K_STOCKMINIMO                    As Integer = 38
Private Const K_STOCKMAXIMO                    As Integer = 39
Private Const K_CODIGOEXTERNO                  As Integer = 40
Private Const K_REPOSICION                     As Integer = 41
Private Const K_RUB_ID                         As Integer = 42

Private Const K_RUBTI_ID1                      As Integer = 43
Private Const K_RUBTI_ID2                      As Integer = 44
Private Const K_RUBTI_ID3                      As Integer = 45
Private Const K_RUBTI_ID4                      As Integer = 46
Private Const K_RUBTI_ID5                      As Integer = 47
Private Const K_RUBTI_ID6                      As Integer = 48
Private Const K_RUBTI_ID7                      As Integer = 49
Private Const K_RUBTI_ID8                      As Integer = 50
Private Const K_RUBTI_ID9                      As Integer = 51
Private Const K_RUBTI_ID10                     As Integer = 52

Private Const K_MARC_ID                        As Integer = 53

Private Const K_PESO_NETO                      As Integer = 54
Private Const K_PESO_TOTAL                     As Integer = 55
Private Const K_UN_ID_PESO                     As Integer = 56
Private Const K_EGP_ID                         As Integer = 57
Private Const K_EFM_ID                         As Integer = 69
Private Const K_CANTIDAD_X_CAJA_EXPO           As Integer = 58
Private Const K_LLEVANROSERIE                  As Integer = 59
Private Const K_LLEVANROLOTE                   As Integer = 60
Private Const K_ESREPUESTO                     As Integer = 600
Private Const K_LOTEFIFO                       As Integer = 61
Private Const K_FLETEEXPO                      As Integer = 68

Private Const K_PRODUCTO_KIT                   As Integer = 162

Private Const K_KIT_STK_X_ITEM                 As Integer = 163

Private Const K_EMBL_ID                        As Integer = 164

Private Const K_PROVEEDOR                      As Integer = 165

Private Const K_CLIENTE                        As Integer = 175

Private Const K_SEPRODUCE                      As Integer = 166
Private Const K_BOM                            As Integer = 167
Private Const K_TAGS                           As Integer = 176
Private Const K_NOMBREWEB                      As Integer = 178
Private Const K_ALIASWEB                       As Integer = 180
Private Const K_CODIGOHTML                     As Integer = 181
Private Const K_CODIGOHTMLDETALLE              As Integer = 182
Private Const K_ACTIVOWEB                      As Integer = 183
Private Const K_EXPOCAIRO                      As Integer = 184
Private Const K_EXPOWEB                        As Integer = 185
Private Const K_LEY_ID                         As Integer = 186
Private Const K_VENTA_WEB_MAXIMA               As Integer = 187
Private Const K_WEB_IMAGES                     As Integer = 188
Private Const K_WEB_CATALOGOS                  As Integer = 191
Private Const K_WEB_CATEGORIAS                 As Integer = 192

Private Const K_KIT_RESUMIDO                   As Integer = 168
Private Const K_KIT_IDENTIDAD                  As Integer = 169
Private Const K_KIT_IDENTIDADXITEM             As Integer = 170
Private Const K_TA_ID_KITSERIE                 As Integer = 171

Private Const K_KIT_LOTE                       As Integer = 172
Private Const K_KIT_LOTEXITEM                  As Integer = 173
Private Const K_TA_ID_KITLOTE                  As Integer = 174

Private Const K_WEB_IMAGE_FOLDER               As Integer = 189
Private Const K_WEB_IMAGE_UPDATE               As Integer = 190

Private Const K_CCOS_ID_COMPRA                 As Integer = 193
Private Const K_CCOS_ID_VENTA                  As Integer = 194

Private Const K_ESPLANTILLA                    As Integer = 195
Private Const K_CUR_ID                         As Integer = 196

Private Const K_RPT_ID_NOMBREVENTA             As Integer = 550
Private Const K_RPT_ID_NOMBRECOMPRA            As Integer = 551
Private Const K_RPT_ID_NOMBREFACTURA           As Integer = 552
Private Const K_RPT_ID_NOMBREWEB               As Integer = 553
Private Const K_RPT_ID_NOMBREIMG               As Integer = 554
Private Const K_RPT_ID_NOMBREIMGALT            As Integer = 555

Private Const K_TI_COMEX_GANANCIAS             As Integer = 556
Private Const K_TI_COMEX_IGB                   As Integer = 557
Private Const K_TI_COMEX_IVA                   As Integer = 558

Private Const K_POAR_ID                        As Integer = 559

Private Const K_CMI                            As Integer = 560
Private Const K_LEYENDAS                       As Integer = 561

Private Const K_PR_ID_WEB_PADRE                As Integer = 570

Private Const KIK_PRFK_ID                      As Integer = 1
Private Const KIK_PRFK_DEFAULT                 As Integer = 2

Private Const KIK_PRPROV_ID                    As Integer = 1
Private Const KIK_PROV_ID                      As Integer = 2
Private Const KIK_PROV_FABRICANTE              As Integer = 3
Private Const KIK_PROV_NOMBRE                  As Integer = 4
Private Const KIK_PROV_CODIGO                  As Integer = 5
Private Const KIK_PROV_CODBARRA                As Integer = 6
Private Const KIK_PA_ID                        As Integer = 7
Private Const KIK_PROV_LPI_ID                  As Integer = 8
Private Const KIK_PROV_PRECIO                  As Integer = 9
Private Const KIK_PROV_PRECIO_FECHA            As Integer = 10
Private Const KIK_PROV_PRECIO_DEFAULT          As Integer = 11
Private Const KIK_PROV_PRECIO2                 As Integer = 12

Private Const KIK_PRCLI_ID                    As Integer = 1
Private Const KIK_CLI_ID                      As Integer = 2
Private Const KIK_CLI_NOMBRE                  As Integer = 4
Private Const KIK_CLI_CODIGO                  As Integer = 5
Private Const KIK_CLI_CODBARRA                As Integer = 6

Private Const KIT_PRT_ID                      As Integer = 1
Private Const KIT_PR_ID_TAG                   As Integer = 2
Private Const KIT_TEXTO                       As Integer = 3
Private Const KIT_EXPOWEB                     As Integer = 4
Private Const KIT_EXPOCAIRO                   As Integer = 5

Private Const KIK_PBM_ID                      As Integer = 1

Private Const KIWI_PRWI_ID                    As Integer = 1
Private Const KIWI_IMAGE                      As Integer = 2
Private Const KIWI_IMAGE_TYPE                 As Integer = 3
Private Const KIWI_ALT                        As Integer = 4
Private Const KIWI_POSICION                   As Integer = 5

Private Const KICWI_ID                        As Integer = 1
Private Const KICW_ID                         As Integer = 2
Private Const KICW_SELECT                     As Integer = 3

Private Const KICWCI_ID                       As Integer = 1
Private Const KICWC_ID                        As Integer = 2
Private Const KICWC_SELECT                    As Integer = 3
Private Const KICWCI_POSICION                 As Integer = 4

Private Const KICMI_ID                        As Integer = 1
Private Const KICMI_CMI_ID                    As Integer = 2
Private Const KICMI_CODIGO                    As Integer = 3
Private Const KICMI_DESCRIP                   As Integer = 4
Private Const KICMI_PRECIO                    As Integer = 5
Private Const KICMI_FECHAALTA                 As Integer = 6
Private Const KICMI_FECHAVTO                  As Integer = 7

Private Const KIPRL_ID                        As Integer = 1
Private Const KIPRL_NOMBRE                    As Integer = 2
Private Const KIPRL_TEXTO                     As Integer = 3
Private Const KIPRL_TAG                       As Integer = 4
Private Const KIPRL_ORDEN                     As Integer = 5

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombrecompra                 As String
Private m_Nombreventa                  As String
Private m_NombreFactura                As String
Private m_NombreWeb                    As String
Private m_AliasWeb                     As String
Private m_ActivoWeb                    As Boolean
Private m_CodigoHtml                   As String
Private m_CodigoHtmlDetalle            As String
Private m_Codigo                       As String
Private m_Activo                       As Boolean
Private m_Descripventa                 As String
Private m_Descripcompra                As String
Private m_Un_id_compra                 As Long
Private m_UnidadCompra                 As String
Private m_Un_id_venta                  As Long
Private m_UnidadVenta                  As String
Private m_Un_id_stock                  As Long
Private m_UnidadStock                  As String
Private m_Compraventa                  As Double
Private m_Ventastock                   As Double
Private m_Comprastock                  As Double
Private m_Llevastock                   As Integer
Private m_SeCompra                     As Integer
Private m_SeVende                      As Integer
Private m_Dinerario                    As Boolean
Private m_NoRedondeo                   As Boolean
Private m_Eskit                        As Boolean
Private m_KitStkXItem                  As Boolean
Private m_Eslista                      As Boolean
Private m_Ti_id_ivaricompra            As Long
Private m_TiIvaRiCompra                As String
Private m_Ti_id_ivarnicompra           As Long
Private m_TiIvaRniCompra               As String
Private m_Ti_id_ivariventa             As Long
Private m_TiIvaRiVenta                 As String
Private m_Ti_id_ivarniventa            As Long
Private m_TiIvaRniVenta                As String
Private m_Ti_id_internosv              As Long
Private m_TiInternosv                  As String
Private m_Ti_id_internosc              As Long
Private m_TiInternosc                  As String
Private m_Porcinternoc                 As Double
Private m_Porcinternov                 As Double
Private m_Ibc_id                       As Long
Private m_Ingresosbrutos               As String
Private m_Cueg_id_compra               As Long
Private m_CuentaGCompra                As String
Private m_marc_id                      As Long
Private m_marca                        As String
Private m_Cueg_id_venta                As Long
Private m_CuentaGVenta                 As String
Private m_X                            As Integer
Private m_Y                            As Integer
Private m_Z                            As Integer
Private m_Tienehijo                    As Boolean
Private m_Id_Padre                     As Long
Private m_EditarPrecioHijo             As Boolean
Private m_PermiteEdicion               As Boolean
Private m_Borrado                      As Boolean
Private m_Stockminimo                  As Double
Private m_Stockmaximo                  As Double
Private m_Codigoexterno                As String
Private m_CodigoBarra                  As String
Private m_CodigoBarraNombre            As String
Private m_Reposicion                   As Double
Private m_LlevaNroSerie                As Boolean
Private m_LlevaNroLote                 As Boolean
Private m_LoteFifo                     As Boolean
Private m_seProduce                    As Boolean
Private m_esRepuesto                   As Boolean
Private m_Rub_id                       As Long
Private m_Rubro                        As String

Private m_Rubti_id1                    As Long
Private m_TablaItem1                   As String
Private m_Rubti_id2                    As Long
Private m_TablaItem2                   As String
Private m_Rubti_id3                    As Long
Private m_TablaItem3                   As String
Private m_Rubti_id4                    As Long
Private m_TablaItem4                   As String
Private m_Rubti_id5                    As Long
Private m_TablaItem5                   As String
Private m_Rubti_id6                    As Long
Private m_TablaItem6                   As String
Private m_Rubti_id7                    As Long
Private m_TablaItem7                   As String
Private m_Rubti_id8                    As Long
Private m_TablaItem8                   As String
Private m_Rubti_id9                    As Long
Private m_TablaItem9                   As String
Private m_Rubti_id10                   As Long
Private m_TablaItem10                  As String

Private m_PesoNeto                     As Double
Private m_PesoTotal                    As Double
Private m_un_id_peso                   As Long
Private m_UnidadPeso                   As String
Private m_egp_id                       As Long
Private m_GrupoExpo                    As String
Private m_efm_id                       As Long
Private m_FamiliaExpo                  As String
Private m_CantXCajaExpo                As Long
Private m_FleteExpo                    As Boolean

Private m_KitResumido                  As Boolean
Private m_KitIdentidad                 As Boolean
Private m_KitIdentidadXItem            As Boolean
Private m_KitLote                      As Boolean
Private m_KitLoteXItem                 As Boolean

Private m_ta_id_kitSerie               As Long
Private m_TalonarioKitSerie            As String

Private m_ta_id_kitLote                As Long
Private m_TalonarioKitLote             As String

Private m_ccos_id_compra               As Long
Private m_CentroCostoCompra            As String

Private m_ccos_id_venta                As Long
Private m_CentroCostoVenta             As String

Private m_embl_id                      As Long
Private m_Embalaje                     As String

Private m_expoCairo                    As Integer
Private m_expoWeb                      As Integer
Private m_ventaWebMaxima               As Double
Private m_ley_id                       As Long
Private m_leyenda                      As String
Private m_webImageFolder               As String
Private m_productowebpadre             As String
Private m_pr_id_webpadre               As Long
Private m_webImageUpdate               As Boolean
Private m_esplantilla                  As Boolean
Private m_cur_id                       As Long
Private m_curso                        As String

Private m_rpt_id_nombreventa           As Long
Private m_rpt_nombreventa              As String

Private m_rpt_id_nombrecompra          As Long
Private m_rpt_nombrecompra             As String

Private m_rpt_id_nombrefactura         As Long
Private m_rpt_nombrefactura            As String

Private m_rpt_id_nombreweb             As Long
Private m_rpt_nombreweb                As String

Private m_rpt_id_nombreimg             As Long
Private m_rpt_nombreimg                As String

Private m_rpt_id_nombreimgalt          As Long
Private m_rpt_nombreimgalt             As String

Private m_ti_id_comex_igb              As Long
Private m_ti_comex_igb                 As String

Private m_ti_id_comex_ganancias        As Long
Private m_ti_comex_ganancias           As String

Private m_ti_id_comex_iva              As Long
Private m_ti_comex_iva                 As String

Private m_poar_id                      As Long
Private m_PosicionArancel              As String

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

Private m_ItemsDeletedProveedor   As String
Private m_ItemsDeletedCliente     As String
Private m_ItemsDeletedTag         As String
Private m_ItemsDeletedWebImages   As String
Private m_ItemsDeletedCMI         As String
Private m_ItemsDeletedLeyendas    As String

Private m_LastRubId         As Long
Private m_bRubroChanged     As Boolean

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

Private m_GenericEdit       As cGenericEdit

' propiedades publicas

Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombrecompra
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property

' propiedades privadas

' funciones publicas
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
  
  If Not gDB.GetData(csTProducto, cscPrId, Id, strField, Data, "GetData", C_Module) Then
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

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  If m_esplantilla Then
    m_esplantilla = False
    pRefreshProperties
  End If
  
  cIABMClient_Terminate
  m_IsNew = True
    
  With m_ObjAbm.Properties(cscPrCodigo)
    .Value = C_C & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscPrCodigo)
  
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

  Doc.ClientTable = csTProducto
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
                               csPreGNewProducto
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    
    Case MSG_DOC_REFRESH
      pRefreshProperties
    
    Case MSG_GRID_VIRTUAL_ROW

      cIABMClient_MessageEx = pProcessMultiRow(Info)
    
    Case Else
      cIABMClient_MessageEx = True
  End Select
End Function

Private Function pProcessMultiRow(ByVal Info As Variant) As Boolean
  
  Info.bAddRows = False
  
  Select Case Info.Key
    Case K_TAGS
      With pGetTags()
        
        Dim row As cIABMGridRow
        Set row = .Grid.Rows(Info.lRow)

        If row.Item(Info.lCol).Key = KIT_PR_ID_TAG Then
          
          Dim oCell As cABMGridRowValue
          
          Set oCell = pCell(row, KIT_PR_ID_TAG)
          
          If LenB(oCell.HelpValueProcess) Then
            If InStr(1, oCell.HelpValueProcess, ",") Then
              pAddMultiRows oCell.HelpValueProcess, Info
              pProcessMultiRow = True
            End If
          End If
        End If
      End With
  End Select
  
End Function

Private Sub pAddMultiRows(ByVal Ids As String, _
                          ByRef Info As Variant)
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
    
  sqlstmt = "select pr_nombrecompra, pr_id from Producto where pr_id in (" & Ids & ")"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  If rs.EOF Then Exit Sub
  
  Dim i As Long
  Dim j As Long
  Dim k As Long
  Dim Pr_id As Long
  Dim vIds  As Variant
  Dim vIds2 As Variant
  Dim bFound As Boolean
  
  vIds2 = Split(Ids, ",")
  
  ReDim vIds(UBound(vIds2))
  
  For i = 0 To UBound(vIds2)
    bFound = False
    For j = 0 To UBound(vIds)
    
      If vIds2(i) = vIds(j) Then
        bFound = True
        Exit For
      End If
      
    Next
    If Not bFound Then
      vIds(k) = vIds2(i)
      k = k + 1
    End If
  Next
  
  ReDim Preserve vIds(k - 1)
  
  ' Ahora respeto el orden de seleccion
  '
  For i = 0 To UBound(vIds)
  
    rs.MoveFirst
    
    Do While Not rs.EOF
  
      Pr_id = gDB.ValField(rs.fields, cscPrId)
      
      If Val(vIds(i)) = Pr_id Then
        Info.NewId.Add Pr_id
        Info.NewValue.Add gDB.ValField(rs.fields, cscPrNombrecompra)
        Exit Do
      End If
      
      rs.MoveNext
    Loop
    
  Next
  
  ' No lo toquen, es mas 1 :( o explota todooo :P
  ' ups al final no era jeje
  '
  Info.iAddRows = Info.NewId.Count '+ 1
  
  Info.bAddRows = Info.iAddRows
  
End Sub

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(Lista As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Sub SetEnabledCompra(ByVal Status As Boolean)
  
  With m_ObjAbm.Properties
    .Item(cscPrUnIdCompra).Enabled = Status
    .Item(cscPrCuegIdCompra).Enabled = Status
    .Item(cscPrTiIdRiCompra).Enabled = Status
    '.Item(cscPrTiIdRniCompra).Enabled = Status
    .Item(cscPrTiIdInternosCompra).Enabled = Status
    .Item(cscPrPorcinternoc).Enabled = Status
    .Item(c_proveedor).Enabled = Status
  End With
  
  m_ObjAbm.RefreshControls
  
  m_SeCompra = Status
End Sub

Private Sub SetEnabledVenta(ByVal Status As Boolean)
  
  With m_ObjAbm.Properties
    .Item(cscPrUnIdVenta).Enabled = Status
    .Item(cscPrCuegIdVenta).Enabled = Status
    .Item(cscPrTiIdRiVenta).Enabled = Status
    '.Item(cscPrTiIdRniVenta).Enabled = Status
    .Item(cscPrNombreFactura).Enabled = Status
    .Item(cscPrTiIdInternosVenta).Enabled = Status
    .Item(cscPrPorcinternov).Enabled = Status
    .Item(cscPrNombreventa).Enabled = Status
    .Item(cscPrDescripventa).Enabled = Status
    .Item(cscPrVentaCompra).Enabled = Status
    .Item(cscPrVentaStock).Enabled = Status
    '.Item(cscPrEskit).Enabled = Status
    .Item(cscPrEsLista).Enabled = Status
    .Item(c_cliente).Enabled = Status
  End With
  
  m_ObjAbm.RefreshControls
  
  m_SeVende = Status
End Sub

Private Sub SetEnabledStock(ByVal Status As Boolean)
  
  With m_ObjAbm.Properties
    .Item(cscPrUnIdStock).Enabled = Status
    .Item(cscPrStockCompra).Enabled = Status
    .Item(cscPrX).Enabled = Status
    .Item(cscPrY).Enabled = Status
    .Item(cscPrZ).Enabled = Status
    .Item(cscPrStockminimo).Enabled = Status
    .Item(cscPrStockmaximo).Enabled = Status
    .Item(cscPrReposicion).Enabled = Status
    .Item(cscPrLlevaNroLote).Enabled = Status
    .Item(cscPrLlevaNroSerie).Enabled = Status
    .Item(cscPrLoteFifo).Enabled = Status
    .Item(cscPrSeProduce).Enabled = Status
    .Item(cscPrEsRepuesto).Enabled = Status
  End With
  
  m_ObjAbm.RefreshControls
  
  m_Llevastock = Status
End Sub

Private Sub SetEnabledPlantilla()
  Dim iProp As cIABMProperty
  Dim Status As Boolean
  
  Status = m_esplantilla = False

  For Each iProp In m_ObjAbm.Properties
    iProp.Enabled = Status
  Next

  If Not m_esplantilla Then
  
    SetEnabledCompra m_SeCompra
    SetEnabledStock m_Llevastock
    SetEnabledVenta m_SeVende

  End If

  m_ObjAbm.Properties.Item(cscPrEsPlantilla).Enabled = True
  pGetTags().Enabled = m_pr_id_webpadre = csNO_ID

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  
  Dim bEnabled As Boolean
  Dim iProp    As cIABMProperty
  Dim bSeVende As Boolean

  cIABMClient_PropertyChange = True
  
  Select Case Key
    Case K_SECOMPRA
      SetEnabledCompra Val(m_ObjAbm.Properties(cscPrSecompra).Value) <> 0
    
    Case K_SEVENDE
      
      bSeVende = Val(m_ObjAbm.Properties(cscPrSevende).Value) <> 0
      SetEnabledVenta bSeVende
      
      Set iProp = m_ObjAbm.Properties.Item(cscPrNombreventa)
      
      If bSeVende Then
      
        If Len(iProp.Value) = 0 Then
          iProp.Value = m_ObjAbm.Properties.Item(cscPrNombrecompra).Value
        End If
      
      Else
        
        If iProp.Value = m_ObjAbm.Properties.Item(cscPrNombrecompra).Value Then
          iProp.Value = vbNullString
        End If
        
      End If
    
    Case K_LLEVASTOCK
      SetEnabledStock Val(m_ObjAbm.Properties(cscPrLlevastock).Value) <> 0
    
    Case K_RUB_ID
      Dim RubId As Long
      RubId = pGetRubId()
      If m_LastRubId <> RubId Then
        pSetRubro RubId, True
        m_LastRubId = RubId
      End If
    
    Case K_NOMBRECOMPRA
    
      With m_ObjAbm.Properties
        
        Dim Nombre        As String
        Dim Nombreventa   As String
        
        Nombre = .Item(cscPrNombrecompra).Value
        Nombreventa = .Item(cscPrNombreventa).Value
        bSeVende = Val(.Item(cscPrSevende).Value)
        
        If m_Nombrecompra <> Nombre _
           And Nombre <> Nombreventa _
           And bSeVende Then
                  'Ha modificado el nombre de compras, desea aplicar el mismo nombre a ventas
          If Ask(LNGGetText(1282, vbNullString), vbYes) Then
        
            .Item(cscPrNombreventa).Value = Nombre
          End If
        End If
      End With
    
    Case K_ESKIT
      
      With m_ObjAbm.Properties
        
        bEnabled = Val(.Item(cscPrEskit).Value)
        
        Set iProp = .Item(cscPrKitStockXItem)
        iProp.Enabled = bEnabled
        m_ObjAbm.ShowValue iProp
      
        Set iProp = .Item(cscPrKitResumido)
        iProp.Enabled = bEnabled
        m_ObjAbm.ShowValue iProp
      End With
    
      pSetKitEnabled
      
    Case K_KIT_RESUMIDO
      pSetKitEnabled
      
    Case K_KIT_IDENTIDAD, K_KIT_IDENTIDADXITEM
      
      bEnabled = Val(m_ObjAbm.Properties.Item(cscPrKitResumido).Value)
      pSetKitSerieEnabled bEnabled
      pSetKitLoteEnabled bEnabled
      
    Case K_KIT_LOTE, K_KIT_LOTEXITEM
      
      pSetKitLoteEnabled Val(m_ObjAbm.Properties.Item(cscPrKitResumido).Value)
      
    Case K_PR_ID_WEB_PADRE
    
      Dim c As cIABMProperty
      Set c = pGetTags()
      
      c.Enabled = m_ObjAbm.Properties.Item(cscPrIdWebPadre).HelpId = csNO_ID
      
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      AbmGen.ShowValue c, True
      
    Case Else
      cIABMClient_PropertyChange = False
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  
  Dim bEsKit              As Boolean
  Dim bKitStockXItem      As Boolean
  Dim bKitResumido        As Boolean
  Dim bKitIdentidad       As Boolean
  Dim bKitIdentidadXItem  As Boolean
  Dim TaIdKitSerie        As Long
  Dim bKitLote            As Boolean
  Dim bKitLoteXItem       As Boolean
  Dim TaIdKitLote         As Long
  
  Dim LastId     As Long
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscPrId
    .Table = csTProducto
    
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
        Case K_NOMBRECOMPRA
          fields.Add2 cscPrNombrecompra, .Value, csText
        Case K_NOMBREVENTA
          fields.Add2 cscPrNombreventa, .Value, csText
        Case K_NOMBREFACTURA
          fields.Add2 cscPrNombreFactura, .Value, csText
        Case K_NOMBREWEB
          fields.Add2 cscPrNombreWeb, .Value, csText
        Case K_ALIASWEB
          fields.Add2 cscPrAliasWeb, .Value, csText
        Case K_PR_ID_WEB_PADRE
          fields.Add2 cscPrIdWebPadre, .HelpId, csId
        Case K_ACTIVOWEB
          fields.Add2 cscPrActivoWeb, .Value, csBoolean
        Case K_LEY_ID
          fields.Add2 cscLeyId, .HelpId, csId
        Case K_CODIGOHTML
          fields.Add2 cscPrCodigoHtml, .Value, csText
        Case K_CODIGOHTMLDETALLE
          fields.Add2 cscPrCodigoHtmlDetalle, .Value, csText
        Case K_CODIGO
          fields.Add2 cscPrCodigo, .Value, csText
        Case K_CODIGO_BARRA
          fields.Add2 cscPrCodigoBarra, .Value, csText
        Case K_CODIGO_BARRA_NOMBRE
          fields.Add2 cscPrCodigoBarraNombre, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
        Case K_DESCRIPVENTA
          fields.Add2 cscPrDescripventa, .Value, csText
        Case K_DESCRIPCOMPRA
          fields.Add2 cscPrDescripcompra, .Value, csText
        Case K_UN_ID_COMPRA
          fields.Add2 cscPrUnIdCompra, .HelpId, csId
        Case K_UN_ID_VENTA
          fields.Add2 cscPrUnIdVenta, .HelpId, csId
        Case K_UN_ID_STOCK
          fields.Add2 cscPrUnIdStock, .HelpId, csId
        Case K_COMPRAVENTA
          fields.Add2 cscPrVentaCompra, .Value, csDouble
        Case K_VENTASTOCK
          fields.Add2 cscPrVentaStock, .Value, csDouble
        Case K_COMPRASTOCK
          fields.Add2 cscPrStockCompra, .Value, csDouble
        Case K_LLEVASTOCK
          fields.Add2 cscPrLlevastock, .Value, csInteger
        Case K_SECOMPRA
          fields.Add2 cscPrSecompra, .Value, csInteger
        Case K_SEVENDE
          fields.Add2 cscPrSevende, .Value, csInteger
        Case K_NO_REDONDEO
          fields.Add2 cscPrNoRedondeo, .Value, csBoolean
        Case K_DINERARIO
          fields.Add2 cscPrDinerario, .Value, csBoolean
        Case K_ESLISTA
          fields.Add2 cscPrEsLista, .Value, csBoolean
        Case K_TI_ID_IVARICOMPRA
          fields.Add2 cscPrTiIdRiCompra, .HelpId, csId
        Case K_TI_ID_IVARIVENTA
          fields.Add2 cscPrTiIdRiVenta, .HelpId, csId
        Case K_TI_ID_INTERNOSV
          fields.Add2 cscPrTiIdInternosVenta, .HelpId, csId
        Case K_TI_ID_INTERNOSC
          fields.Add2 cscPrTiIdInternosCompra, .HelpId, csId
        Case K_PORCINTERNOC
          fields.Add2 cscPrPorcinternoc, .Value, csDouble
        Case K_PORCINTERNOV
          fields.Add2 cscPrPorcinternov, .Value, csDouble
        Case K_IBC_ID
          fields.Add2 cscIbcId, .HelpId, csId
        Case K_CUEG_ID_COMPRA
          fields.Add2 cscPrCuegIdCompra, .HelpId, csId
        Case K_CUEG_ID_VENTA
          fields.Add2 cscPrCuegIdVenta, .HelpId, csId
        Case K_X
          fields.Add2 cscPrX, .Value, csInteger
        Case K_Y
          fields.Add2 cscPrY, .Value, csInteger
        Case K_Z
          fields.Add2 cscPrZ, .Value, csInteger
        Case K_TIENEHIJO
          fields.Add2 cscPrTienehijo, .Value, csBoolean
        Case K_STOCKMINIMO
          fields.Add2 cscPrStockminimo, .Value, csDouble
        Case K_STOCKMAXIMO
          fields.Add2 cscPrStockmaximo, .Value, csDouble
        Case K_LLEVANROSERIE
          fields.Add2 cscPrLlevaNroSerie, .Value, csBoolean
        Case K_LLEVANROLOTE
          fields.Add2 cscPrLlevaNroLote, .Value, csBoolean
        Case K_ESREPUESTO
          fields.Add2 cscPrEsRepuesto, .Value, csBoolean
        Case K_LOTEFIFO
          fields.Add2 cscPrLoteFifo, .Value, csBoolean
        Case K_FLETEEXPO
          fields.Add2 cscPrFleteExpo, .Value, csBoolean
        Case K_SEPRODUCE
          fields.Add2 cscPrSeProduce, .Value, csBoolean
        Case K_CODIGOEXTERNO
          fields.Add2 cscPrCodigoexterno, .Value, csText
        Case K_MARC_ID
          fields.Add2 cscMarcId, .HelpId, csId
        Case K_PESO_NETO
          fields.Add2 cscPrPesoNeto, .Value, csDouble
        Case K_PESO_TOTAL
          fields.Add2 cscPrPesoTotal, .Value, csDouble
        Case K_EGP_ID
          fields.Add2 cscEgpId, .HelpId, csId
        Case K_EFM_ID
          fields.Add2 cscEfmId, .HelpId, csId
        Case K_EMBL_ID
          fields.Add2 cscEmblId, .HelpId, csId
        Case K_TI_COMEX_GANANCIAS
          fields.Add2 cscTiIdComexGanancias, .HelpId, csId
        Case K_TI_COMEX_IGB
          fields.Add2 cscTiIdComexIGB, .HelpId, csId
        Case K_TI_COMEX_IVA
          fields.Add2 cscTiIdComexIva, .HelpId, csId
        Case K_POAR_ID
          fields.Add2 cscPoarId, .HelpId, csId
        Case K_UN_ID_PESO
          fields.Add2 cscUnIdPeso, .HelpId, csId
        Case K_CANTIDAD_X_CAJA_EXPO
          fields.Add2 cscPrCantXCajaExpo, .Value, csInteger
        Case K_REPOSICION
          fields.Add2 cscPrReposicion, .Value, csDouble
        Case K_RUB_ID
          fields.Add2 cscRubId, .HelpId, csId
        Case K_RUBTI_ID1
          fields.Add2 cscRubtiid1, .HelpId, csId
        Case K_RUBTI_ID2
          fields.Add2 cscRubtiid2, .HelpId, csId
        Case K_RUBTI_ID3
          fields.Add2 cscRubtiid3, .HelpId, csId
        Case K_RUBTI_ID4
          fields.Add2 cscRubtiid4, .HelpId, csId
        Case K_RUBTI_ID5
          fields.Add2 cscRubtiid5, .HelpId, csId
        Case K_RUBTI_ID6
          fields.Add2 cscRubtiid6, .HelpId, csId
        Case K_RUBTI_ID7
          fields.Add2 cscRubtiid7, .HelpId, csId
        Case K_RUBTI_ID8
          fields.Add2 cscRubtiid8, .HelpId, csId
        Case K_RUBTI_ID9
          fields.Add2 cscRubtiid9, .HelpId, csId
        Case K_RUBTI_ID10
          fields.Add2 cscRubtiid10, .HelpId, csId
      
        Case K_EXPOWEB
          fields.Add2 cscPrExpoWeb, .Value, csInteger
        Case K_EXPOCAIRO
          fields.Add2 cscPrExpoCairo, .Value, csInteger
          
        Case K_VENTA_WEB_MAXIMA
          fields.Add2 cscPrVentaWebMaxima, .Value, csDouble
        Case K_WEB_IMAGE_UPDATE
          fields.Add2 cscPrWebImageUpdate, .Value, csBoolean
        Case K_WEB_IMAGE_FOLDER
          fields.Add2 cscPrWebImageFolder, .Value, csText
          
        '-----------------------------------------------------
        ' Kit
        '
        Case K_ESKIT
          bEsKit = Val(.Value)
          fields.Add2 cscPrEskit, .Value, csBoolean
          
        Case K_KIT_STK_X_ITEM
          bKitStockXItem = Val(.Value)
          
        Case K_KIT_RESUMIDO
          bKitResumido = Val(.Value)
          
        Case K_KIT_IDENTIDAD
          bKitIdentidad = Val(.Value)
          
        Case K_KIT_IDENTIDADXITEM
          bKitIdentidadXItem = Val(.Value)
          
        Case K_TA_ID_KITSERIE
          TaIdKitSerie = .HelpId
          
        Case K_KIT_LOTE
          bKitLote = Val(.Value)
          
        Case K_KIT_LOTEXITEM
          bKitLoteXItem = Val(.Value)
          
        Case K_TA_ID_KITLOTE
          TaIdKitLote = .HelpId
          
        Case K_CCOS_ID_COMPRA
          fields.Add2 cscCcosIdCompra, .HelpId, csId
          
        Case K_CCOS_ID_VENTA
          fields.Add2 cscCcosIdVenta, .HelpId, csId
          
        Case K_ESPLANTILLA
          fields.Add2 cscPrEsPlantilla, .Value, csBoolean
          
        Case K_CUR_ID
          fields.Add2 cscCurId, .HelpId, csId
          
        Case K_RPT_ID_NOMBRECOMPRA
          fields.Add2 cscRptIdNombreCompra, .HelpId, csId
        
        Case K_RPT_ID_NOMBREVENTA
          fields.Add2 cscRptIdNombreVenta, .HelpId, csId
        
        Case K_RPT_ID_NOMBREFACTURA
          fields.Add2 cscRptIdNombreFactura, .HelpId, csId
        
        Case K_RPT_ID_NOMBREWEB
          fields.Add2 cscRptIdNombreWeb, .HelpId, csId
        
        Case K_RPT_ID_NOMBREIMG
          fields.Add2 cscRptIdNombreImg, .HelpId, csId
          
        Case K_RPT_ID_NOMBREIMGALT
          fields.Add2 cscRptIdNombreImgAlt, .HelpId, csId
          
      End Select
    End With
  Next
  
  ' IVA RNI
  '
  fields.Add2 cscPrTiIdRniVenta, -1, csId
  fields.Add2 cscPrTiIdRniCompra, -2, csId
  
  With fields
  
    '--------------------------
    ' Kit
    '
    pSetKitConfig bEsKit, _
                  bKitStockXItem, _
                  bKitResumido, _
                  bKitIdentidad, _
                  bKitIdentidadXItem, _
                  TaIdKitSerie, _
                  bKitLote, _
                  bKitLoteXItem, _
                  TaIdKitLote
    
    .Add2 cscPrKitStockXItem, CInt(bKitStockXItem), csBoolean
    .Add2 cscPrKitResumido, CInt(bKitResumido), csBoolean
    .Add2 cscPrKitIdentidad, CInt(bKitIdentidad), csBoolean
    .Add2 cscPrKitIdentidadXItem, CInt(bKitIdentidadXItem), csBoolean
    .Add2 cscTaIdKitSerie, TaIdKitSerie, csId
    .Add2 cscPrKitLote, CInt(bKitLote), csBoolean
    .Add2 cscPrKitLoteXItem, CInt(bKitLoteXItem), csBoolean
    .Add2 cscTaIdKitLote, TaIdKitLote, csId
  
  
    .HaveLastUpdate = True
    .HaveWhoModify = True
  
  End With
  
  If Not m_GenericEdit.Save(m_ObjAbm, register) Then Exit Function
  
  If Not register.BeginTrans(gDB) Then Exit Function
                                                            
  If Not gDB.SaveEx(register, , _
                    cscPrCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.Id
  
  If Not pSaveItemsProveedor() Then GoTo SaveError
  
  ' TODO: Actualizar ListaPrecioItem y el cache de precios si corresponde
  '
  
  If Not pSaveItemsCliente() Then GoTo SaveError
  If Not pSaveItemsCMI() Then GoTo SaveError
  If Not pSaveItemsLeyendas() Then GoTo SaveError
  If Not pSaveItemsTags() Then GoTo SaveError
  If Not pSaveItemsWebImages() Then GoTo SaveError
  
  If Not pSaveItemsWebCatalogos() Then GoTo SaveError
  If Not pSaveItemsWebCategorias() Then GoTo SaveError
  
  Dim sqlstmt As String
  sqlstmt = "sp_ProductoSaveKit " & m_Id
  If Not gDB.Execute(sqlstmt) Then GoTo SaveError
  
  Dim rs As ADODB.Recordset
  sqlstmt = "sp_ProductoValidate " & m_Id
  If Not gDB.OpenRs(sqlstmt, rs) Then GoTo SaveError
  
  If rs.EOF Then GoTo SaveError
  
  If ValField(rs.fields, 0) = 0 Then
    MsgWarning ValField(rs.fields, 1)
    GoTo SaveError
  End If
  
  If Not pSaveNombres(m_Id) Then GoTo SaveError
  
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
  cIABMClient_Title = LNGGetText(1283, vbNullString)  'Artículos
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty               As cIABMProperty
  Dim bIsResumido             As Boolean
  Dim bValidateIdentidad      As Boolean
  Dim bValidateLote           As Boolean
  Dim bNeedTalIdentidad       As Boolean
  Dim bNeedTalLote            As Boolean
  Dim bHaveTalIdentidad       As Boolean
  Dim bHaveTalLote            As Boolean
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRECOMPRA
          If ValEmpty(.Value, csText) Then
          
            If Not pCreateFromRubro() Then
          
              MsgInfo C_DebeIndicarNombre
              Exit Function
            End If
          End If
        Case K_NOMBREVENTA
          If ValEmpty(.Value, csText) And m_SeVende Then
            MsgInfo LNGGetText(1293, vbNullString)
                              'Debe indicar un nombre de venta
            Exit Function
          End If
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            .Value = c_get_codigo_from_id
          End If
        Case K_UN_ID_COMPRA
          If ValEmpty(.HelpId, csId) And m_SeCompra Then
            MsgInfo LNGGetText(1284, vbNullString)
                              'Debe indicar una unidad de compra
            Exit Function
          End If
        Case K_UN_ID_VENTA
          If ValEmpty(.HelpId, csId) And m_SeVende Then
            MsgInfo LNGGetText(1285, vbNullString)
                              'Debe indicar una unidad de venta
            Exit Function
          End If
        Case K_UN_ID_STOCK
          If ValEmpty(.HelpId, csId) And m_Llevastock Then
            MsgInfo LNGGetText(1286, vbNullString)
                              'Debe indicar una unidad de stock
            Exit Function
          End If
        Case K_COMPRAVENTA
          If ValEmpty(.Value, csDouble) And m_SeVende And m_SeCompra Then
            MsgInfo LNGGetText(1287, vbNullString)
                              'Debe indicar una relación entre la unidad de compra y la unidad de venta
            Exit Function
          End If
        Case K_VENTASTOCK
          If ValEmpty(.Value, csDouble) And m_SeVende And m_Llevastock Then
            MsgInfo LNGGetText(1288, vbNullString)
                              'Debe indicar una relación entre la unidad de venta y la unidad de stock
            Exit Function
          End If
        Case K_COMPRASTOCK
          If ValEmpty(.Value, csDouble) And m_Llevastock And m_SeCompra Then
            MsgInfo LNGGetText(1294, vbNullString)
                              'Debe indicar una relación entre la unidad de compra y la unidad de stock
            Exit Function
          End If
        Case K_TI_ID_IVARICOMPRA
          If ValEmpty(.HelpId, csId) And m_SeCompra Then
            MsgInfo LNGGetText(1289, vbNullString)
                              'Debe indicar una tasa impositiva de compras para Responsables Inscriptos
            Exit Function
          End If
'        Case K_TI_ID_IVARNICOMPRA
'          If ValEmpty(.HelpId, csId) And m_SeCompra Then
'            MsgInfo LNGGetText(1290, vbNullString)
'                              'Debe indicar una tasa impositiva de compras para Responsables No Inscriptos
'            Exit Function
'          End If
        Case K_TI_ID_IVARIVENTA
          If ValEmpty(.HelpId, csId) And m_SeVende Then
            MsgInfo LNGGetText(1291, vbNullString)
                              'Debe indicar una tasa impositiva de ventas para Responsables Inscriptos
            Exit Function
          End If
'        Case K_TI_ID_IVARNIVENTA
'          If ValEmpty(.HelpId, csId) And m_SeVende Then
'            MsgInfo LNGGetText(1292, vbNullString)
'                              'Debe indicar una tasa impositiva de ventas para Responsables No Inscriptos
'            Exit Function
'          End If
        Case K_CUEG_ID_COMPRA
          If ValEmpty(.HelpId, csId) And m_SeCompra Then
            MsgInfo LNGGetText(1295, vbNullString)
                              'Debe indicar un grupo de cuentas para compras
            Exit Function
          End If
        Case K_CUEG_ID_VENTA
          If ValEmpty(.HelpId, csId) And m_SeVende Then
            MsgInfo LNGGetText(1296, vbNullString)
                              'Debe indicar un grupo de cuentas para ventas
            Exit Function
          End If
        
        Case K_KIT_RESUMIDO
          bIsResumido = Val(.Value)
        Case K_KIT_IDENTIDAD
          bValidateIdentidad = Val(.Value)
        Case K_KIT_LOTE
          bValidateLote = Val(.Value)
        Case K_KIT_IDENTIDADXITEM
          bNeedTalIdentidad = Val(.Value) = 0
        Case K_KIT_LOTEXITEM
          bNeedTalLote = Val(.Value) = 0
        Case K_TA_ID_KITSERIE
          bHaveTalIdentidad = .HelpId <> csNO_ID
        Case K_TA_ID_KITLOTE
          bHaveTalLote = .HelpId <> csNO_ID
      End Select
    End With
  Next
  
  If bIsResumido Then
    
    If bValidateIdentidad And _
       bNeedTalIdentidad And _
       Not bHaveTalIdentidad Then
      MsgInfo LNGGetText(1297, vbNullString)
          'Debe indicar un talonario para la identidad del Kit
      Exit Function
    End If
  
    If bValidateLote And _
       bNeedTalLote And _
       Not bHaveTalLote Then
      MsgInfo LNGGetText(1353, vbNullString)
              'Debe indicar un talonario para el lote del Kit
      Exit Function
    End If
  
  End If

  If Not m_GenericEdit.Validate(m_ObjAbm) Then Exit Function

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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreGListProducto)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  If Not SecurityCanAccess(csPreGDeleteProducto) Then Exit Function

  If Not pDeletePlantilla(Id) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "sp_ProductoDelete " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function pDeletePlantilla(ByVal Pr_id As Long) As Boolean
  Dim EsPlantilla As Boolean
  If Not gDB.GetData(csTProducto, cscPrId, Pr_id, cscPrEsPlantilla, EsPlantilla) Then Exit Function
  If EsPlantilla Then
    pDeletePlantilla = Ask(LNGGetText(4830, vbNullString), vbNo)
                        ' Esta realmente seguro de borrar la plantilla
  Else
    pDeletePlantilla = True
  End If
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not pValidateAccessNewEdit(Id) Then Exit Function

  m_ObjAbm.InModalWindow = InModalWindow
  
  Set m_GenericEdit = New cGenericEdit
  If Not m_GenericEdit.Init(csProducto) Then Exit Function
  
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
  
  m_Host.Server.AddMenu C_MenuArticulos, csMenuConfigArticulos, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu C_MenuArticulos, csPreGListProducto, C_MenuArticulos, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                   'Artículos
  m_Host.MenuABMClick "CSGeneral2.cProducto", Me, LNGGetText(1283, vbNullString), 0, csETablasGeneral.csProducto
End Function


' funciones privadas

Private Function pValidateAccessNewEdit(ByVal Id As Long) As Boolean
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewProducto) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditProducto) Then Exit Function
  End If
  pValidateAccessNewEdit = True
End Function

Private Function LoadCollection() As Boolean
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.bSendRefresh = True
  AbmObj.MinHeight = 8600
  AbmObj.MinWidth = 12000
  
  Dim c As cIABMProperty
  Dim o As cABMGrid
  
  Const tab_general = 0
  Const tab_compra = 1
  Const tab_stock = 2
  Const tab_venta = 3
  Const tab_rubro = 4
  Const tab_comex = 5
  Const tab_kit = 6
  Const tab_proveedor = 7
  'Const tab_cliente = 8
  'Const tab_BOM = 9
  Const tab_Web = 8
  Const tab_web2 = 9
  
  With m_ObjAbm
    
    With .Tabs
    
      .Clear
    
      With .Add(Nothing)
        .Name = C_strGeneral
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1489, vbNullString) 'Compras
        .Index = tab_compra
      End With
      
      With .Add(Nothing)
        .Index = tab_stock
        .Name = LNGGetText(1298, vbNullString) 'Stock
      End With
      
      With .Add(Nothing)
        .Index = tab_venta
        .Name = LNGGetText(1059, vbNullString) 'Venta
      End With
      
      With .Add(Nothing)
        .Index = tab_rubro
        .Name = LNGGetText(1299, vbNullString) 'Rubro
      End With
      
      With .Add(Nothing)
        .Index = tab_comex
        .Name = LNGGetText(3523, vbNullString) 'COMEX
      End With
      
      With .Add(Nothing)
        .Index = tab_kit
        .Name = LNGGetText(1301, vbNullString) 'Kit
      End With
      
      With .Add(Nothing)
        .Index = tab_proveedor
        .Name = LNGGetText(4595, vbNullString) 'Terceros
      End With
      
      'With .Add(Nothing)
      '  .Index = tab_cliente
      '  .Name = LNGGetText(1303, vbNullString) 'Clientes
      'End With
      
      'With .Add(Nothing)
      '  .Index = tab_BOM
      '  .Name = LNGGetText(1304, vbNullString) 'B.O.M.
      'End With
      
      With .Add(Nothing)
        .Index = tab_Web
        .Name = LNGGetText(1038, vbNullString) 'Web
      End With
      
      With .Add(Nothing)
        .Index = tab_web2
        .Name = LNGGetText(4792, vbNullString) 'Cat. Web
      End With
      
    End With
    
    .Title2 = m_Nombrecompra
    
    With .Properties

      .Clear

      '////////////////////////////////////////////////////////////
      ' General
      '
      With .Add(Nothing, cscPrNombrecompra)
        .PropertyType = cspText
        .Name = C_strNombre
        .Width = 8000
        .Key = K_NOMBRECOMPRA
        .Value = m_Nombrecompra
      End With
      
      With .Add(Nothing, cscActivo)
        .PropertyType = cspCheck
        .TopFromProperty = cscPrNombrecompra
        .LeftFromProperty = cscPrNombrecompra
        .LeftToPrevious = 8900
        .LeftLabel = -500
        .Width = 800
        .LeftNotChange = True
        .TopNotChange = True
        .Name = C_strActivo
        .Key = K_ACTIVO
        .Value = CInt(m_Activo)
      End With
      
      With .Add(Nothing, cscPrCodigo)
        .PropertyType = cspText
        .Name = C_strCodigo
        .LeftFromProperty = cscPrNombrecompra
        .TopFromProperty = cscPrNombrecompra
        .TopToPrevious = 440
        .Size = 90
        .Key = K_CODIGO
        .Value = m_Codigo
      End With
      
      With .Add(Nothing, cscPrCodigoexterno)
        .PropertyType = cspText
        .Name = LNGGetText(1305, vbNullString) 'Código Externo
        .Size = 30
        .Key = K_CODIGOEXTERNO
        .Value = m_Codigoexterno
      End With
      
      With .Add(Nothing, cscPrCodigoBarra)
        .PropertyType = cspText
        .Name = LNGGetText(1177, vbNullString) 'Código de Barras
        .Size = 255
        .Key = K_CODIGO_BARRA
        .Value = m_CodigoBarra
      End With
      
      With .Add(Nothing, cscPrCodigoBarraNombre)
        .PropertyType = cspText
        .Name = LNGGetText(1307, vbNullString) 'Nombre Código de Barras
        .Size = 255
        .Key = K_CODIGO_BARRA_NOMBRE
        .Value = m_CodigoBarraNombre
      End With
      
      With .Add(Nothing, cscIbcId)
        .PropertyType = cspHelp
        .Table = csIngresosBrutosCategoria
        .Name = LNGGetText(1308, vbNullString) 'Categoría Ingresos Brutos
        .Key = K_IBC_ID
        .HelpId = m_Ibc_id
        .Value = m_Ingresosbrutos
        .TopFromProperty = cscPrCodigo
        .Left = 5500
      End With
      
      With .Add(Nothing, cscMarcId)
        .PropertyType = cspHelp
        .Table = csMarca
        .Name = LNGGetText(1310, vbNullString) 'Marca
        .Key = K_MARC_ID
        .Value = m_marca
        .HelpId = m_marc_id
        .Width = 4050
      End With
      
      With .Add(Nothing, cscPrExpoCairo)
        .PropertyType = cspNumeric
        .SubType = cspInteger
        .Name = LNGGetText(3898, vbNullString) ' Expo cairo
        .Key = K_EXPOCAIRO
        .Value = m_expoCairo
        .Width = 1000
      End With
      
      With .Add(Nothing, cscPrEsPlantilla)
        .PropertyType = cspCheck
        .Name = LNGGetText(4829, vbNullString) 'Es Plantilla
        .Key = K_ESPLANTILLA
        .Value = CInt(m_esplantilla)
        .TopFromProperty = cscPrExpoCairo
        .Left = 8500
        .LeftNotChange = True
      End With
      
      With .Add(Nothing, cscCurId)
        .PropertyType = cspHelp
        .Table = csCurso
        .Name = LNGGetText(4828, vbNullString) 'Curso
        .Key = K_CUR_ID
        .Value = m_curso
        .HelpId = m_cur_id
        .Width = 4050
      End With
      
      With .Add(Nothing, cscPrDescripcompra)
        .PropertyType = cspText
        .Name = C_strDescrip
        .Height = 660
        .Width = 8000
        .SubType = cspMemo
        .Size = 2000
        .Key = K_DESCRIPCOMPRA
        .Value = m_Descripcompra
        .LeftFromProperty = cscPrCodigo
        .TopToPrevious = 440
      End With
      
'-------------------------------------------------------------------------

      With .Add(Nothing)
        .PropertyType = cspLabel
        .Width = 10500
        .Height = 10
        .BackColor = &HCCCCCC
        .Left = 300
        .TopToPrevious = 840
      End With
  
      With .Add(Nothing)
        .PropertyType = cspLabel
        .FontBold = True
        .Value = LNGGetText(4854, vbNullString) 'Generación Automática de Nombres
        .Left = 300
        .Width = 5000
        .TopToPrevious = 140
        .Height = 285
      End With

      With .Add(Nothing, cscRptIdNombreCompra)
        .PropertyType = cspHelp
        .Table = csReporte
        .Name = LNGGetText(4848, vbNullString) 'Proceso Nombre Compra
        .Key = K_RPT_ID_NOMBRECOMPRA
        .Value = m_rpt_nombrecompra
        .HelpId = m_rpt_id_nombrecompra
        .Left = 4000
        .Width = 6050
        .LeftLabel = -3000
        .TopToPrevious = 300
        .LeftNotChange = True
      End With
      
      With .Add(Nothing, cscRptIdNombreVenta)
        .PropertyType = cspHelp
        .Table = csReporte
        .Name = LNGGetText(4849, vbNullString) 'Proceso Nombre Venta
        .Key = K_RPT_ID_NOMBREVENTA
        .Value = m_rpt_nombreventa
        .HelpId = m_rpt_id_nombreventa
        .Width = 6050
        .LeftLabel = -3000
        .TopToPrevious = 380
        .Left = 4000
        .LeftNotChange = True
      End With
      
      With .Add(Nothing, cscRptIdNombreFactura)
        .PropertyType = cspHelp
        .Table = csReporte
        .Name = LNGGetText(4850, vbNullString) 'Proceso Nombre Factura
        .Key = K_RPT_ID_NOMBREFACTURA
        .Value = m_rpt_nombrefactura
        .HelpId = m_rpt_id_nombrefactura
        .Width = 6050
        .LeftLabel = -3000
        .TopToPrevious = 380
        .Left = 4000
        .LeftNotChange = True
      End With
      
      With .Add(Nothing, cscRptIdNombreWeb)
        .PropertyType = cspHelp
        .Table = csReporte
        .Name = LNGGetText(4851, vbNullString) 'Proceso Nombre Web
        .Key = K_RPT_ID_NOMBREWEB
        .Value = m_rpt_nombreweb
        .HelpId = m_rpt_id_nombreweb
        .Width = 6050
        .LeftLabel = -3000
        .TopToPrevious = 380
        .Left = 4000
        .LeftNotChange = True
      End With
      
      With .Add(Nothing, cscRptIdNombreImg)
        .PropertyType = cspHelp
        .Table = csReporte
        .Name = LNGGetText(4852, vbNullString) 'Proceso Nombre Imagen
        .Key = K_RPT_ID_NOMBREIMG
        .Value = m_rpt_nombreimg
        .HelpId = m_rpt_id_nombreimg
        .Width = 6050
        .LeftLabel = -3000
        .TopToPrevious = 380
        .Left = 4000
        .LeftNotChange = True
      End With
      
      With .Add(Nothing, cscRptIdNombreImgAlt)
        .PropertyType = cspHelp
        .Table = csReporte
        .Name = LNGGetText(4853, vbNullString) 'Proceso Nombre Imagen Alternativa
        .Key = K_RPT_ID_NOMBREIMGALT
        .Value = m_rpt_nombreimgalt
        .HelpId = m_rpt_id_nombreimgalt
        .Width = 6050
        .LeftLabel = -3000
        .TopToPrevious = 380
        .Left = 4000
        .LeftNotChange = True
      End With
'-------------------------------------------------------------------------
      
      With .Add(Nothing, cscPrSecompra)
        .PropertyType = cspCheck
        .TabIndex = tab_compra
        .TopFromProperty = cscPrNombrecompra
        .Name = LNGGetText(1309, vbNullString) 'Se Compra
        .Key = K_SECOMPRA
        .Value = CInt(m_SeCompra)
      End With
      
      With .Add(Nothing, cscPrUnIdCompra)
        .PropertyType = cspHelp
        .Table = csUnidad
        .Name = LNGGetText(1165, vbNullString) 'Unidad
        .TabIndex = tab_compra
        .Key = K_UN_ID_COMPRA
        .HelpId = m_Un_id_compra
        .Value = m_UnidadCompra
      End With
      
      With .Add(Nothing, cscPrCuegIdCompra)
        .PropertyType = cspHelp
        .Table = csCuentaGrupo
        .TabIndex = tab_compra
        .Name = LNGGetText(1516, vbNullString) 'Grupo de Cuenta
        .Key = K_CUEG_ID_COMPRA
        .HelpId = m_Cueg_id_compra
        .Value = m_CuentaGCompra
        .HelpFilter = "cueg_tipo = " & csE_CuentaGrupoTipo.csECuecTipoProductoCompra
      End With
      
      With .Add(Nothing, cscPrTiIdRiCompra)
        .PropertyType = cspHelp
        .TopFromProperty = cscPrUnIdCompra
        .Left = 6000
        .Table = csTasaImpositiva
        .Name = LNGGetText(1317, vbNullString) 'IVA Resp. Ins.
        .TabIndex = tab_compra
        .Key = K_TI_ID_IVARICOMPRA
        .HelpId = m_Ti_id_ivaricompra
        .Value = m_TiIvaRiCompra
        .HelpFilter = c_TiFilterCompra
      End With
      
'      With .Add(Nothing, cscPrTiIdRniCompra)
'        .PropertyType = cspHelp
'        .LeftFromProperty = cscPrTiIdRiCompra
'        .Table = csTasaImpositiva
'        .TabIndex = tab_compra
'        .Name = LNGGetText(1318, vbNullString) 'IVA Resp. No Ins.
'        .Key = K_TI_ID_IVARNICOMPRA
'        .HelpId = m_Ti_id_ivarnicompra
'        .Value = m_TiIvaRniCompra
'        .HelpFilter = c_TiFilterCompra
'      End With
      
      With .Add(Nothing, cscPrTiIdInternosCompra)
        .PropertyType = cspHelp
        .Table = csTasaImpositiva
        .LeftFromProperty = cscPrTiIdRiCompra
        .TabIndex = tab_compra
        .Name = LNGGetText(1319, vbNullString) 'Tasa Internos
        .Key = K_TI_ID_INTERNOSC
        .HelpId = m_Ti_id_internosc
        .Value = m_TiInternosc
        .HelpFilter = c_TiFilterCompra
      End With
      
      With .Add(Nothing, cscPrPorcinternoc)
        .PropertyType = cspNumeric
        .TabIndex = tab_compra
        .Name = LNGGetText(1320, vbNullString) 'Porcentaje Internos
        .SubType = cspPercent
        .Key = K_PORCINTERNOC
        .Value = m_Porcinternoc
      End With
      
      With .Add(Nothing, cscCcosIdCompra)
        .PropertyType = cspHelp
        .Table = csCentroCosto
        .TabIndex = tab_compra
        .Name = LNGGetText(1057, vbNullString) 'Centro de Costo
        .Key = K_CCOS_ID_COMPRA
        .Value = m_CentroCostoCompra
        .HelpId = m_ccos_id_compra
      End With
      
      '////////////////////////////////////////////////////////////
      ' Stock
      '
      With .Add(Nothing, cscPrLlevastock)
        .PropertyType = cspCheck
        .Name = LNGGetText(1321, vbNullString) 'Se tiene en Stock
        .TabIndex = tab_stock
        .Key = K_LLEVASTOCK
        .Value = CInt(m_Llevastock)
      End With
      
      With .Add(Nothing, cscPrUnIdStock)
        .PropertyType = cspHelp
        .Table = csUnidad
        .TabIndex = tab_stock
        .Name = LNGGetText(1165, vbNullString) 'Unidad
        .Key = K_UN_ID_STOCK
        .HelpId = m_Un_id_stock
        .Value = m_UnidadStock
      End With
      
      With .Add(Nothing, cscPrStockCompra)
        .PropertyType = cspNumeric
        .Name = LNGGetText(1322, vbNullString) 'Relación Stock-Compra
        .TabIndex = tab_stock
        .Key = K_COMPRASTOCK
        .Value = m_Comprastock
        .SubType = cspDouble
        .Format = "0.000000"
      End With
      
      With .Add(Nothing, cscPrX)
        .PropertyType = cspNumeric
        .TabIndex = tab_stock
        .Name = LNGGetText(1323, vbNullString) 'Posición x
        .Key = K_X
        .Value = m_X
        .SubType = cspInteger
      End With
      
      With .Add(Nothing, cscPrY)
        .PropertyType = cspNumeric
        .TabIndex = tab_stock
        .Name = LNGGetText(1324, vbNullString) 'Posición y
        .Key = K_Y
        .Value = m_Y
        .SubType = cspInteger
      End With
      
      With .Add(Nothing, cscPrZ)
        .PropertyType = cspNumeric
        .TabIndex = tab_stock
        .Name = LNGGetText(1325, vbNullString) 'Posición z
        .Key = K_Z
        .Value = m_Z
        .SubType = cspInteger
      End With
      
      With .Add(Nothing, cscPrStockminimo)
        .PropertyType = cspNumeric
        .TabIndex = tab_stock
        .Name = LNGGetText(1326, vbNullString) 'Stock Mínimo
        .Key = K_STOCKMINIMO
        .Value = m_Stockminimo
        .SubType = cspDouble
        .Format = gFormatDecCantidad
        .TopFromProperty = cscPrUnIdStock
        .Left = 5700
      End With
      
      With .Add(Nothing, cscPrReposicion)
        .PropertyType = cspNumeric
        .TabIndex = tab_stock
        .Name = LNGGetText(1328, vbNullString) 'Punto de Reposición
        .Key = K_REPOSICION
        .Value = m_Reposicion
        .SubType = cspDouble
        .Format = gFormatDecCantidad
      End With
      
      With .Add(Nothing, cscPrStockmaximo)
        .PropertyType = cspNumeric
        .TabIndex = tab_stock
        .Name = LNGGetText(1327, vbNullString) 'Stock Máximo
        .Key = K_STOCKMAXIMO
        .Value = m_Stockmaximo
        .SubType = cspDouble
        .Format = gFormatDecCantidad
      End With
      
      With .Add(Nothing, cscPrLlevaNroSerie)
        .PropertyType = cspCheck
        .TabIndex = tab_stock
        .Name = LNGGetText(1329, vbNullString) 'Lleva Nro Serie
        .Key = K_LLEVANROSERIE
        .Value = CInt(m_LlevaNroSerie)
        .TopFromProperty = cscPrUnIdStock
        .Left = 10000
      End With
      
      With .Add(Nothing, cscPrLlevaNroLote)
        .PropertyType = cspCheck
        .TabIndex = tab_stock
        .Name = LNGGetText(1330, vbNullString) 'Lleva Nro. Lote
        .Key = K_LLEVANROLOTE
        .Value = CInt(m_LlevaNroLote)
      End With
    
      With .Add(Nothing, cscPrLoteFifo)
        .PropertyType = cspCheck
        .TabIndex = tab_stock
        .Name = LNGGetText(1331, vbNullString) 'Consume Lotes X FIFO
        .Key = K_LOTEFIFO
        .Value = CInt(m_LoteFifo)
      End With
    
      With .Add(Nothing, cscPrSeProduce)
        .PropertyType = cspCheck
        .TabIndex = tab_stock
        .Name = LNGGetText(1332, vbNullString) 'Se Produce
        .Key = K_SEPRODUCE
        .Value = CInt(m_seProduce)
      End With
      
      With .Add(Nothing, cscPrEsRepuesto)
        .PropertyType = cspCheck
        .TabIndex = tab_stock
        .Name = LNGGetText(1333, vbNullString) 'Es un Repuesto
        .Key = K_ESREPUESTO
        .Value = CInt(m_esRepuesto)
      End With
      
      '////////////////////////////////////////////////////////////
      ' Ventas
      '
      With .Add(Nothing, cscPrSevende)
        .PropertyType = cspCheck
        .TabIndex = tab_venta
        .Name = LNGGetText(1334, vbNullString) 'Se Vende
        .Key = K_SEVENDE
        .Value = CInt(m_SeVende)
      End With
    
      With .Add(Nothing, cscPrNombreventa)
        .PropertyType = cspText
        .TabIndex = tab_venta
        .TopFromProperty = cscPrSevende
        .LeftNotChange = True
        .TopNotChange = True
        .Left = 2800
        .Width = 4950
        .LeftLabel = -700
        .Name = C_strNombre
        .Size = 255
        .Key = K_NOMBREVENTA
        .Value = m_Nombreventa
      End With
      
      With .Add(Nothing, cscPrNombreFactura)
        .PropertyType = cspText
        .TabIndex = tab_venta
        .Width = 4950
        .Name = LNGGetText(3521, vbNullString) 'Nombre Factura
        .Size = 255
        .Key = K_NOMBREFACTURA
        .Value = m_NombreFactura
      End With
      
      With .Add(Nothing, cscPrUnIdVenta)
        .PropertyType = cspHelp
        .Table = csUnidad
        .TabIndex = tab_venta
        .Name = LNGGetText(1165, vbNullString) 'Unidad
        .Key = K_UN_ID_VENTA
        .HelpId = m_Un_id_venta
        .Value = m_UnidadVenta
      End With
      
      With .Add(Nothing, cscPrVentaCompra)
        .PropertyType = cspNumeric
        .TabIndex = tab_venta
        .Name = LNGGetText(1335, vbNullString) 'Relación Venta-Compra
        .Key = K_COMPRAVENTA
        .Value = m_Compraventa
        .SubType = cspDouble
        .Format = "0.000000"
      End With
      
      With .Add(Nothing, cscPrVentaStock)
        .PropertyType = cspNumeric
        .TabIndex = tab_venta
        .Name = LNGGetText(1336, vbNullString) 'Relación Venta-Stock
        .Key = K_VENTASTOCK
        .Value = m_Ventastock
        .SubType = cspDouble
        .Format = "0.000000"
      End With
      
      With .Add(Nothing, cscPrCuegIdVenta)
        .PropertyType = cspHelp
        .Table = csCuentaGrupo
        .Name = LNGGetText(1516, vbNullString) 'Grupo de Cuenta
        .Key = K_CUEG_ID_VENTA
        .TopFromProperty = cscPrUnIdVenta
        .Left = 5500
        .TabIndex = tab_venta
        .HelpId = m_Cueg_id_venta
        .Value = m_CuentaGVenta
        .HelpFilter = "cueg_tipo = " & csE_CuentaGrupoTipo.csECuecTipoProductoVenta
      End With
      
      With .Add(Nothing, cscPrEsLista)
        .PropertyType = cspCheck
        .TabIndex = tab_venta
        .Name = LNGGetText(1337, vbNullString) 'Es una Lista
        .Key = K_ESLISTA
        .Value = CInt(m_Eslista)
      End With
      
      With .Add(Nothing, cscPrDinerario)
        .PropertyType = cspCheck
        .TabIndex = tab_venta
        .Name = LNGGetText(2552, vbNullString) 'Concepto Dinerario
        .Key = K_DINERARIO
        .Value = CInt(m_Dinerario)
      End With
      
      With .Add(Nothing, cscPrNoRedondeo)
        .PropertyType = cspCheck
        .TabIndex = tab_venta
        .Name = LNGGetText(3651, vbNullString) 'No Redondear
        .Key = K_NO_REDONDEO
        .Value = CInt(m_NoRedondeo)
        .TopNotChange = True
        .LeftNotChange = True
        .TopFromProperty = cscPrDinerario
        .LeftFromProperty = cscPrDinerario
        .LeftToPrevious = 2000
      End With
      
      With .Add(Nothing, cscPrTiIdRiVenta)
        .PropertyType = cspHelp
        .TopFromProperty = cscPrNombreventa
        .LeftFromProperty = cscPrCuegIdVenta
        .LeftToPrevious = 3900
        .Table = csTasaImpositiva
        .Name = LNGGetText(1317, vbNullString) 'IVA Resp. Ins.
        .TabIndex = tab_venta
        .Key = K_TI_ID_IVARIVENTA
        .HelpId = m_Ti_id_ivariventa
        .Value = m_TiIvaRiVenta
        .HelpFilter = c_TiFilterVenta
      End With
      
'      With .Add(Nothing, cscPrTiIdRniVenta)
'        .PropertyType = cspHelp
'        .LeftFromProperty = cscPrTiIdRiVenta
'        .Table = csTasaImpositiva
'        .Name = LNGGetText(1318, vbNullString) 'IVA Resp. No Ins.
'        .TabIndex = tab_venta
'        .Key = K_TI_ID_IVARNIVENTA
'        .HelpId = m_Ti_id_ivarniventa
'        .Value = m_TiIvaRniVenta
'        .HelpFilter = c_TiFilterVenta
'      End With
      
      With .Add(Nothing, cscPrTiIdInternosVenta)
        .PropertyType = cspHelp
        .Table = csTasaImpositiva
        .LeftFromProperty = cscPrTiIdRiVenta
        .Name = LNGGetText(1319, vbNullString) 'Tasa Internos
        .Key = K_TI_ID_INTERNOSV
        .TabIndex = tab_venta
        .HelpId = m_Ti_id_internosv
        .Value = m_TiInternosv
        .HelpFilter = c_TiFilterVenta
      End With
      
      With .Add(Nothing, cscPrPorcinternov)
        .PropertyType = cspNumeric
        .Name = LNGGetText(1320, vbNullString) 'Porcentaje Internos
        .SubType = cspPercent
        .Key = K_PORCINTERNOV
        .TabIndex = tab_venta
        .Value = m_Porcinternov
      End With
            
      With .Add(Nothing, cscCcosIdVenta)
        .PropertyType = cspHelp
        .Table = csCentroCosto
        .TabIndex = tab_venta
        .Name = LNGGetText(1057, vbNullString) 'Centro de Costo
        .Key = K_CCOS_ID_VENTA
        .Value = m_CentroCostoVenta
        .HelpId = m_ccos_id_venta
      End With
            
      With .Add(Nothing, cscPrDescripventa)
        .PropertyType = cspText
        .TabIndex = tab_venta
        .Name = C_strDescrip
        .LeftFromProperty = cscPrSevende
        .TopFromProperty = cscPrVentaStock
        .TopToPrevious = 440
        .Height = 880
        .Width = 10000
        .SubType = cspMemo
        .Size = 2000
        .Key = K_DESCRIPVENTA
        .Value = m_Descripventa
      End With
      
      With .Add(Nothing, cscRubId)
        .PropertyType = cspHelp
        .Table = csRubro
        .TabIndex = tab_rubro
        .Name = LNGGetText(1299, vbNullString) 'Rubro
        .Key = K_RUB_ID
        .Value = m_Rubro
        .HelpId = m_Rub_id
      End With
      
      pSetRubro m_Rub_id, False
    
      '////////////////////////////////////////////////////////////
      ' COMEX
      '
      With .Add(Nothing, cscUnIdPeso)
        .PropertyType = cspHelp
        .Table = csUnidad
        .Name = LNGGetText(1165, vbNullString) 'Unidad
        .Key = K_UN_ID_PESO
        .Value = m_UnidadPeso
        .HelpId = m_un_id_peso
        .TabIndex = tab_comex
      End With
      
      With .Add(Nothing, cscPrPesoNeto)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Format = gFormatDecCantidad
        .Name = LNGGetText(1311, vbNullString) 'Peso Neto
        .Key = K_PESO_NETO
        .Value = m_PesoNeto
        .TabIndex = tab_comex
        .Width = 1000
      End With
      
      With .Add(Nothing, cscPrPesoTotal)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Format = gFormatDecCantidad
        .Name = LNGGetText(1312, vbNullString) 'Peso Total
        .Key = K_PESO_TOTAL
        .Value = m_PesoTotal
        .TabIndex = tab_comex
        .Width = 1000
      End With
      
      With .Add(Nothing, cscPrCantXCajaExpo)
        .PropertyType = cspNumeric
        .SubType = cspInteger
        .Name = LNGGetText(1316, vbNullString) 'Cantidad x Caja
        .Key = K_CANTIDAD_X_CAJA_EXPO
        .Value = m_CantXCajaExpo
        .TabIndex = tab_comex
        .Width = 1000
      End With
      
      With .Add(Nothing, cscEmblId)
        .PropertyType = cspHelp
        .Table = csEmbalaje
        .Name = LNGGetText(1163, vbNullString) 'Embalaje
        .Key = K_EMBL_ID
        .Value = m_Embalaje
        .HelpId = m_embl_id
        .TabIndex = tab_comex
      End With
      
      With .Add(Nothing, cscPrFleteExpo)
        .PropertyType = cspCheck
        .Name = LNGGetText(1315, vbNullString) 'Flete Expo
        .Key = K_FLETEEXPO
        .Value = CInt(m_FleteExpo)
        .TabIndex = tab_comex
      End With
      
      With .Add(Nothing, cscEgpId)
        .PropertyType = cspHelp
        .Table = csExpoGrupoPrecio
        .Name = LNGGetText(1313, vbNullString) 'Grupo Exportación
        .Key = K_EGP_ID
        .Value = m_GrupoExpo
        .HelpId = m_egp_id
        .TabIndex = tab_comex
        .Left = 7000
        .LeftLabel = -2500
        .TopFromProperty = cscUnIdPeso
        .Width = 3500
      End With
      
      With .Add(Nothing, cscEfmId)
        .PropertyType = cspHelp
        .Table = csExpoFamilia
        .Name = LNGGetText(1314, vbNullString) 'Familia de Exportación
        .Key = K_EFM_ID
        .Value = m_FamiliaExpo
        .HelpId = m_efm_id
        .TabIndex = tab_comex
        .LeftLabel = -2500
        .Width = 3500
      End With
                  
      With .Add(Nothing, cscPoarId)
        .PropertyType = cspHelp
        .Table = csPosicionArancel
        .Name = LNGGetText(3275, vbNullString) ' Posición Arancelaria
        .HelpId = m_poar_id
        .Value = m_PosicionArancel
        .Key = K_POAR_ID
        .TabIndex = tab_comex
        .LeftLabel = -2500
        .Width = 3500
      End With
      
      With .Add(Nothing, cscTiIdComexGanancias)
        .PropertyType = cspHelp
        .Table = csTasaImpositiva
        .Name = LNGGetText(4974, vbNullString) ' Tasa Ganacias 3543/92
        .HelpId = m_ti_id_comex_ganancias
        .Value = m_ti_comex_ganancias
        .Key = K_TI_COMEX_GANANCIAS
        .TabIndex = tab_comex
        .HelpFilter = c_TiFilterCompra
        .LeftLabel = -2500
        .Width = 3500
      End With
      
      With .Add(Nothing, cscTiIdComexIGB)
        .PropertyType = cspHelp
        .Table = csTasaImpositiva
        .Name = LNGGetText(4975, vbNullString) ' Ingresos Brutos Importaciones
        .HelpId = m_ti_id_comex_igb
        .Value = m_ti_comex_igb
        .Key = K_TI_COMEX_IGB
        .TabIndex = tab_comex
        .HelpFilter = c_TiFilterCompra
        .LeftLabel = -2500
        .Width = 3500
      End With
      
      With .Add(Nothing, cscTiIdComexIva)
        .PropertyType = cspHelp
        .Table = csTasaImpositiva
        .Name = LNGGetText(4976, vbNullString) ' Tasa IVA 3431/91
        .HelpId = m_ti_id_comex_iva
        .Value = m_ti_comex_iva
        .Key = K_TI_COMEX_IVA
        .TabIndex = tab_comex
        .HelpFilter = c_TiFilterCompra
        .LeftLabel = -2500
        .Width = 3500
      End With
    
      '////////////////////////////////////////////////////////////
      ' Kit
      '
      With .Add(Nothing, cscPrEskit)
        .PropertyType = cspCheck
        .Left = 1800
        .LeftLabel = -1500
        .TabIndex = tab_kit
        .Name = LNGGetText(1338, vbNullString) 'Es un Kit
        .Key = K_ESKIT
        .Value = CInt(m_Eskit)
      End With
      
      With .Add(Nothing, cscPrKitStockXItem)
        .PropertyType = cspCheck
        .TabIndex = tab_kit
        .Name = LNGGetText(1339, vbNullString) 'Kit Stock x Item
        .Key = K_KIT_STK_X_ITEM
        .Value = CInt(m_KitStkXItem)
        .TopFromProperty = cscPrEskit
        .TopNotChange = True
        .Left = 3500
        .LeftNotChange = True
      End With
      
      With .Add(Nothing, cscPrKitResumido)
        .PropertyType = cspCheck
        .TabIndex = tab_kit
        .Name = LNGGetText(1340, vbNullString) 'Producción Resumida
        .Key = K_KIT_RESUMIDO
        .Value = CInt(m_KitResumido)
        .TopToPrevious = 100
      End With
      
      With .Add(Nothing, cscPrKitIdentidad)
        .PropertyType = cspCheck
        .TabIndex = tab_kit
        .Name = LNGGetText(1341, vbNullString) 'Posee Identidad
        .Key = K_KIT_IDENTIDAD
        .Value = CInt(m_KitIdentidad)
        .Enabled = CInt(m_KitResumido)
      End With
      
      With .Add(Nothing, cscPrKitIdentidadXItem)
        .PropertyType = cspCheck
        .TabIndex = tab_kit
        .Name = LNGGetText(1342, vbNullString) 'Identidad por Item
        .LeftLabel = -1400
        .Key = K_KIT_IDENTIDADXITEM
        .Value = CInt(m_KitIdentidadXItem)
        .Enabled = CInt(m_KitIdentidad)
        
        .TopFromProperty = cscPrKitIdentidad
        .TopNotChange = True
        .Left = 4000
        .LeftNotChange = True
      End With
      
      With .Add(Nothing, cscTaIdKitSerie)
        .PropertyType = cspHelp
        .Table = csTalonario
        .TabIndex = tab_kit
        .Name = LNGGetText(1343, vbNullString) 'Talonario Serie
        .Key = K_TA_ID_KITSERIE
        .Value = m_TalonarioKitSerie
        .HelpId = m_ta_id_kitSerie
        .Enabled = m_KitIdentidad And Not m_KitIdentidadXItem
        .Width = 3000
      End With
      
      With .Add(Nothing, cscPrKitLote)
        .PropertyType = cspCheck
        .TabIndex = tab_kit
        .Name = LNGGetText(1344, vbNullString) 'Posee Lote
        .Key = K_KIT_LOTE
        .Value = CInt(m_KitLote)
        .Enabled = CInt(m_KitResumido)
      End With
      
      With .Add(Nothing, cscPrKitLoteXItem)
        .PropertyType = cspCheck
        .TabIndex = tab_kit
        .Name = LNGGetText(1345, vbNullString) 'Lote por Item
        .Key = K_KIT_LOTEXITEM
        .Value = CInt(m_KitLoteXItem)
        .Enabled = CInt(m_KitLote)
        
        .TopFromProperty = cscPrKitLote
        .TopNotChange = True
        .Left = 4000
        .LeftNotChange = True
      End With
      
      With .Add(Nothing, cscTaIdKitLote)
        .PropertyType = cspHelp
        .Table = csTalonario
        .TabIndex = tab_kit
        .Name = LNGGetText(1346, vbNullString) 'Talonario Lote
        .Key = K_TA_ID_KITLOTE
        .Value = m_TalonarioKitLote
        .HelpId = m_ta_id_kitLote
        .Enabled = m_KitLote And Not m_KitLoteXItem
        .Width = 3000
      End With
      
      With .Add(Nothing)
        .TopFromProperty = cscPrEskit
        .Left = 5000
        .LeftLabel = -1
        .Width = 3000
        .PropertyType = cspLabel
        .Value = LNGGetText(1347, vbNullString) 'Fórmulas de Producción
        .TabIndex = tab_kit
      End With
      
      Set c = .Add(Nothing, c_productoKit)
      With c
        .Top = 1500
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadKit(c) Then Exit Function
        .Name = c_productoKit
        .Key = K_PRODUCTO_KIT
        .TabIndex = tab_kit
        .Height = 1000
        .Width = 5000
        .GridAdd = False
        .GridEdit = False
        .GridRemove = False
        
        Set o = c.Grid
        o.DontResize = True
      End With
      
      '////////////////////////////////////////////////////////////
      ' Proveedores
      '
      Set c = .Add(Nothing, c_proveedor)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadProveedor(c) Then Exit Function
        .Name = c_proveedor
        .Key = K_PROVEEDOR
        .TabIndex = tab_proveedor
      
        .Top = 1000
        .Left = 200
        .Height = 1950
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      
        Set o = c.Grid
        o.DontResizeHeight = True
      End With
      
      m_ItemsDeletedProveedor = vbNullString
    
      '////////////////////////////////////////////////////////////
      ' Clientes
      '
      Set c = .Add(Nothing, c_cliente)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadCliente(c) Then Exit Function
        .Name = c_cliente
        .Key = K_CLIENTE
        .Top = 3000
        .Left = 200
        .Height = 950
        .TabIndex = tab_proveedor
        
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      
        Set o = c.Grid
        o.DontResizeHeight = True
      End With
      
      m_ItemsDeletedCliente = vbNullString
      
      '////////////////////////////////////////////////////////////
      ' BOMs
      '
      Set c = .Add(Nothing, c_BOM)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadBOM(c) Then Exit Function
        .Name = c_BOM
        .Key = K_BOM
        
        .Top = 4000
        .Left = 200
        .Height = 950
        .TabIndex = tab_proveedor
        
        .GridAdd = False
        .GridEdit = False
        .GridRemove = False
      
        Set o = c.Grid
        o.DontResizeHeight = True
      End With
    
      '////////////////////////////////////////////////////////////
      ' Comunidad de Internet
      '
      Set c = .Add(Nothing, c_cmi)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadCMI(c) Then Exit Function
        .Name = c_cmi
        .Key = K_CMI
        .Top = 5000
        .Left = 200
        .Height = 1050
        .TabIndex = tab_proveedor
        
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      
        Set o = c.Grid
        o.DontResizeHeight = True
      End With
      
      m_ItemsDeletedCMI = vbNullString
    
      Set c = .Add(Nothing, c_leyendas)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadLeyendas(c) Then Exit Function
        .Name = c_leyendas
        .Key = K_LEYENDAS
        .Top = 6100
        .Left = 200
        .Height = 1050
        .TabIndex = tab_proveedor
        
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      
        Set o = c.Grid
        o.DontResizeHeight = True
      End With
      
      m_ItemsDeletedLeyendas = vbNullString
    
      '////////////////////////////////////////////////////////////
      ' Web
      '
      With .Add(Nothing, cscPrNombreWeb)
        .PropertyType = cspText
        .Width = 4950
        .LeftFromProperty = cscPrNombrecompra
        .Name = LNGGetText(3522, vbNullString) ' Nombre Web
        .Size = 255
        .Key = K_NOMBREWEB
        .TabIndex = tab_Web
        .Value = m_NombreWeb
      End With
      
      With .Add(Nothing, cscPrAliasWeb)
        .PropertyType = cspText
        .Width = 1550
        .Name = LNGGetText(3539, vbNullString) ' Alias Web
        .Size = 255
        .Key = K_ALIASWEB
        .TabIndex = tab_Web
        .Value = m_AliasWeb
      End With
      
      With .Add(Nothing, cscPrIdWebPadre)
        .PropertyType = cspHelp
        .Table = csProducto
        .Name = LNGGetText(5047, vbNullString) ' Producto Padre Web
        .Key = K_PR_ID_WEB_PADRE
        .TabIndex = tab_Web
        .Value = m_productowebpadre
        .HelpId = m_pr_id_webpadre
        .Left = 4600
        .Width = 1900
        .TopFromProperty = cscPrAliasWeb
        .LeftNotChange = True
      End With
      
      With .Add(Nothing, cscPrActivoWeb)
        .PropertyType = cspCheck
        .Name = LNGGetText(3557, vbNullString) ' Activo Web
        .Key = K_ACTIVOWEB
        .TabIndex = tab_Web
        .Value = CInt(m_ActivoWeb)
        .TopFromProperty = cscPrNombreWeb
        .Left = 7800
        .LeftLabel = -1100
        .LeftNotChange = True
        .TopNotChange = True
      End With
      
      With .Add(Nothing, cscPrWebImageUpdate)
        .PropertyType = cspCheck
        .Name = LNGGetText(4576, vbNullString) ' Actualizar Imagenes
        .Key = K_WEB_IMAGE_UPDATE
        .TabIndex = tab_Web
        .Value = CInt(m_webImageUpdate)
        .TopFromProperty = cscPrNombreWeb
        .Left = 10500
        .LeftLabel = -1700
        .LeftNotChange = True
        .TopNotChange = True
      End With
      
      With .Add(Nothing, cscPrCodigoHtml)
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 4950
        .Name = LNGGetText(3538, vbNullString) ' Codigo Html Detalle
        .Size = 255
        .Key = K_CODIGOHTML
        .TabIndex = tab_Web
        .Value = m_CodigoHtml
      End With
      
      With .Add(Nothing, cscPrCodigoHtmlDetalle)
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 4950
        .Name = LNGGetText(3900, vbNullString) ' Codigo Html Detalle
        .Size = 255
        .Key = K_CODIGOHTMLDETALLE
        .TabIndex = tab_Web
        .Value = m_CodigoHtmlDetalle
      End With
      
      With .Add(Nothing, cscPrExpoWeb)
        .PropertyType = cspNumeric
        .SubType = cspInteger
        .Name = LNGGetText(3897, vbNullString) ' Expo Web
        .Key = K_EXPOWEB
        .TabIndex = tab_Web
        .Value = m_expoWeb
        .TopFromProperty = cscPrAliasWeb
        .Left = 8000
        .Width = 1000
      End With
      
      With .Add(Nothing, cscPrVentaWebMaxima)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = LNGGetText(3899, vbNullString) ' Venta Máxima
        .Key = K_VENTA_WEB_MAXIMA
        .TabIndex = tab_Web
        .Value = m_ventaWebMaxima
        .TopFromProperty = cscPrAliasWeb
        .Left = 10500
        .Width = 1000
      End With
      
      With .Add(Nothing, cscLeyId)
        .PropertyType = cspHelp
        .Table = csLeyenda
        .Name = LNGGetText(1240, vbNullString) ' Leyenda
        .Key = K_LEY_ID
        .TabIndex = tab_Web
        .HelpId = m_ley_id
        .Value = m_leyenda
        .TopFromProperty = cscPrCodigoHtml
        .Left = 8000
        .Width = 3500
      End With
      
      With .Add(Nothing, cscPrWebImageFolder)
        .PropertyType = cspFolder
        .Name = LNGGetText(3587, vbNullString) ' Carpeta de Imagenes
        .Key = K_WEB_IMAGE_FOLDER
        .TabIndex = tab_Web
        .Value = m_webImageFolder
        .Left = 8000
        .Width = 3500
      End With
            
      Set c = .Add(Nothing, c_WEB_IMAGES)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadWebImages(c) Then Exit Function
        .Name = c_WEB_IMAGES
        .Key = K_WEB_IMAGES
        .TabIndex = tab_Web
        .Top = 2900
        .Left = 200
        .Height = 1950
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      
        Set o = c.Grid
        o.DontResizeHeight = True
      End With
      
      m_ItemsDeletedWebImages = vbNullString
      
      Set c = .Add(Nothing, c_TAGS)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadTags(c) Then Exit Function
        .Name = c_TAGS
        .Key = K_TAGS
        .TabIndex = tab_Web
        .Top = 5300
        .Left = 200
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedTag = vbNullString
    
      '---------------------------------------------
      Set c = .Add(Nothing, c_WEB_catalogs)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadCatalogosWeb(c) Then Exit Function
        .Name = c_WEB_catalogs
        .Key = K_WEB_CATALOGOS
        .TabIndex = tab_web2
        .Top = 1000
        .Left = 200
        .Height = 1950
        .GridAdd = False
        .GridEdit = True
        .GridRemove = False
      
        Set o = c.Grid
        o.DontResizeHeight = True
      End With
      
      Set c = .Add(Nothing, c_WEB_categories)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadCategoriasWeb(c) Then Exit Function
        .Name = c_WEB_categories
        .Key = K_WEB_CATEGORIAS
        .TabIndex = tab_web2
        .Top = 3000
        .Left = 200
        .GridAdd = False
        .GridEdit = True
        .GridRemove = False
      End With
    
    End With
    
  End With

  SetEnabledCompra m_SeCompra
  SetEnabledStock m_Llevastock
  SetEnabledVenta m_SeVende
  SetEnabledPlantilla
  
  If Not m_GenericEdit.LoadCollection(m_ObjAbm) Then Exit Function

  ' Uso ShowEx por que SetEnabledCompra fuerza
  ' un show interno en abminterface que se encarga
  ' de cargar los controles y para este momento
  ' todas las propiedades ya tienen su ControlLoaded = True
  ' y por tanto LoadControl no se ejecuta y todo queda OK
  '
  If Not AbmObj.ShowEx(Me, tab_general, True) Then Exit Function
  
  LoadCollection = True
End Function

Private Sub pSetRubro(ByVal Rub_ID As Long, _
                      ByVal ShowProperties As Boolean, _
                      Optional ByVal tab_rubro As Long = 4)
                      
  Dim c      As cIABMProperty
  Dim Rubro  As cRubro
  Dim AbmGen As cABMGeneric
  
  Set Rubro = New cRubro
  Rubro.Load Rub_ID
  
  Set AbmGen = m_ObjAbm
  
  With m_ObjAbm.Properties
  
    If Not .Item(cscRubtiid1) Is Nothing Then
      AbmGen.UnloadControl .Item(cscRubtiid1)
      .Remove cscRubtiid1
    End If
    If Not .Item(cscRubtiid2) Is Nothing Then
      AbmGen.UnloadControl .Item(cscRubtiid2)
      .Remove cscRubtiid2
    End If
    If Not .Item(cscRubtiid3) Is Nothing Then
      AbmGen.UnloadControl .Item(cscRubtiid3)
      .Remove cscRubtiid3
    End If
    If Not .Item(cscRubtiid4) Is Nothing Then
      AbmGen.UnloadControl .Item(cscRubtiid4)
      .Remove cscRubtiid4
    End If
    If Not .Item(cscRubtiid5) Is Nothing Then
      AbmGen.UnloadControl .Item(cscRubtiid5)
      .Remove cscRubtiid5
    End If
    If Not .Item(cscRubtiid6) Is Nothing Then
      AbmGen.UnloadControl .Item(cscRubtiid6)
      .Remove cscRubtiid6
    End If
    If Not .Item(cscRubtiid7) Is Nothing Then
      AbmGen.UnloadControl .Item(cscRubtiid7)
      .Remove cscRubtiid7
    End If
    If Not .Item(cscRubtiid8) Is Nothing Then
      AbmGen.UnloadControl .Item(cscRubtiid8)
      .Remove cscRubtiid8
    End If
    If Not .Item(cscRubtiid9) Is Nothing Then
      AbmGen.UnloadControl .Item(cscRubtiid9)
      .Remove cscRubtiid9
    End If
    If Not .Item(cscRubtiid10) Is Nothing Then
      AbmGen.UnloadControl .Item(cscRubtiid10)
      .Remove cscRubtiid10
    End If
    
    If Rubro.Rubt_id1 <> csNO_ID Then
      With .Add(Nothing, cscRubtiid1)
        .PropertyType = cspHelp
        .Table = csRubroTablaItem
        .HelpFilter = cscRubtid & " = " & Rubro.Rubt_id1
        .TabIndex = tab_rubro
        .Name = Rubro.Tabla1
        .Key = K_RUBTI_ID1
      
        .Top = 1800
        .Left = 2500
        .LeftLabel = -1800
      
        If Rubro.Rubti_id1 <> csNO_ID Then
          .Value = Rubro.TablaItem1
          .HelpId = Rubro.Rubti_id1
          .Enabled = False
        Else
          .Value = m_TablaItem1
          .HelpId = m_Rubti_id1
        End If
      End With
      
    End If
    
    If Rubro.Rubt_id2 <> csNO_ID Then
      With .Add(Nothing, cscRubtiid2)
        .PropertyType = cspHelp
        .Table = csRubroTablaItem
        .HelpFilter = cscRubtid & " = " & Rubro.Rubt_id2
        .TabIndex = tab_rubro
        .Name = Rubro.Tabla2
        .Key = K_RUBTI_ID2
      
        .LeftLabel = -1800
      
        If Rubro.Rubti_id2 <> csNO_ID Then
          .Value = Rubro.TablaItem2
          .HelpId = Rubro.Rubti_id2
          .Enabled = False
        Else
          .Value = m_TablaItem2
          .HelpId = m_Rubti_id2
        End If
      End With
      
    End If
    
    If Rubro.Rubt_id3 <> csNO_ID Then
      With .Add(Nothing, cscRubtiid3)
        .PropertyType = cspHelp
        .Table = csRubroTablaItem
        .HelpFilter = cscRubtid & " = " & Rubro.Rubt_id3
        .TabIndex = tab_rubro
        .Name = Rubro.Tabla3
        .Key = K_RUBTI_ID3
      
        .LeftLabel = -1800
      
        If Rubro.Rubti_id3 <> csNO_ID Then
          .Value = Rubro.TablaItem3
          .HelpId = Rubro.Rubti_id3
          .Enabled = False
        Else
          .Value = m_TablaItem3
          .HelpId = m_Rubti_id3
        End If
      End With
      
    End If
    
    If Rubro.Rubt_id4 <> csNO_ID Then
      With .Add(Nothing, cscRubtiid4)
        .PropertyType = cspHelp
        .Table = csRubroTablaItem
        .HelpFilter = cscRubtid & " = " & Rubro.Rubt_id4
        .TabIndex = tab_rubro
        .Name = Rubro.Tabla4
        .Key = K_RUBTI_ID4
      
        .LeftLabel = -1800
      
        If Rubro.Rubti_id4 <> csNO_ID Then
          .Value = Rubro.TablaItem4
          .HelpId = Rubro.Rubti_id4
          .Enabled = False
        Else
          .Value = m_TablaItem4
          .HelpId = m_Rubti_id4
        End If
      End With
    End If
    
    If Rubro.Rubt_id5 <> csNO_ID Then
      With .Add(Nothing, cscRubtiid5)
        .PropertyType = cspHelp
        .Table = csRubroTablaItem
        .HelpFilter = cscRubtid & " = " & Rubro.Rubt_id5
        .TabIndex = tab_rubro
        .Name = Rubro.Tabla5
        .Key = K_RUBTI_ID5
      
        .LeftLabel = -1800
      
        If Rubro.Rubti_id5 <> csNO_ID Then
          .Value = Rubro.TablaItem5
          .HelpId = Rubro.Rubti_id5
          .Enabled = False
        Else
          .Value = m_TablaItem5
          .HelpId = m_Rubti_id5
        End If
      End With
      
    End If
    
    If Rubro.Rubt_id6 <> csNO_ID Then
      With .Add(Nothing, cscRubtiid6)
        .PropertyType = cspHelp
        .Table = csRubroTablaItem
        .HelpFilter = cscRubtid & " = " & Rubro.Rubt_id6
        .TabIndex = tab_rubro
        .Name = Rubro.Tabla6
        .Key = K_RUBTI_ID6
      
        .Top = 1800
        .Left = 7200
        .LeftLabel = -1800
      
        If Rubro.Rubti_id6 <> csNO_ID Then
          .Value = Rubro.TablaItem6
          .HelpId = Rubro.Rubti_id6
          .Enabled = False
        Else
          .Value = m_TablaItem6
          .HelpId = m_Rubti_id6
        End If
      End With
    End If
    
    If Rubro.Rubt_id7 <> csNO_ID Then
      With .Add(Nothing, cscRubtiid7)
        .PropertyType = cspHelp
        .Table = csRubroTablaItem
        .HelpFilter = cscRubtid & " = " & Rubro.Rubt_id7
        .TabIndex = tab_rubro
        .Name = Rubro.Tabla7
        .Key = K_RUBTI_ID7
      
        .LeftLabel = -1800
      
        If Rubro.Rubti_id7 <> csNO_ID Then
          .Value = Rubro.TablaItem7
          .HelpId = Rubro.Rubti_id7
          .Enabled = False
        Else
          .Value = m_TablaItem7
          .HelpId = m_Rubti_id7
        End If
      End With
      
    End If
    
    If Rubro.Rubt_id8 <> csNO_ID Then
      With .Add(Nothing, cscRubtiid8)
        .PropertyType = cspHelp
        .Table = csRubroTablaItem
        .HelpFilter = cscRubtid & " = " & Rubro.Rubt_id8
        .TabIndex = tab_rubro
        .Name = Rubro.Tabla8
        .Key = K_RUBTI_ID8
      
        .LeftLabel = -1800
      
        If Rubro.Rubti_id8 <> csNO_ID Then
          .Value = Rubro.TablaItem8
          .HelpId = Rubro.Rubti_id8
          .Enabled = False
        Else
          .Value = m_TablaItem8
          .HelpId = m_Rubti_id8
        End If
      End With
      
    End If
    
    If Rubro.Rubt_id9 <> csNO_ID Then
      With .Add(Nothing, cscRubtiid9)
        .PropertyType = cspHelp
        .Table = csRubroTablaItem
        .HelpFilter = cscRubtid & " = " & Rubro.Rubt_id9
        .TabIndex = tab_rubro
        .Name = Rubro.Tabla9
        .Key = K_RUBTI_ID9
      
        .LeftLabel = -1800
      
        If Rubro.Rubti_id9 <> csNO_ID Then
          .Value = Rubro.TablaItem9
          .HelpId = Rubro.Rubti_id9
          .Enabled = False
        Else
          .Value = m_TablaItem9
          .HelpId = m_Rubti_id9
        End If
      End With
      
    End If
    
    If Rubro.Rubt_id10 <> csNO_ID Then
      With .Add(Nothing, cscRubtiid10)
        .PropertyType = cspHelp
        .Table = csRubroTablaItem
        .HelpFilter = cscRubtid & " = " & Rubro.Rubt_id10
        .TabIndex = tab_rubro
        .Name = Rubro.Tabla10
        .Key = K_RUBTI_ID10
      
        .LeftLabel = -1800
      
        If Rubro.Rubti_id10 <> csNO_ID Then
          .Value = Rubro.TablaItem10
          .HelpId = Rubro.Rubti_id10
          .Enabled = False
        Else
          .Value = m_TablaItem10
          .HelpId = m_Rubti_id10
        End If
      End With
      
    End If
  
  End With

  If Not ShowProperties Then Exit Sub

  If Not AbmGen.ShowEx(Me, tab_rubro, True) Then Exit Sub
  
  m_bRubroChanged = False
  
End Sub

Private Function Load(ByVal Id As Long) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset

  sqlstmt = "sp_productoGet " & Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscPrId)
    m_Nombrecompra = gDB.ValField(rs.fields, cscPrNombrecompra)
    m_Nombreventa = gDB.ValField(rs.fields, cscPrNombreventa)
    m_NombreFactura = gDB.ValField(rs.fields, cscPrNombreFactura)
    m_NombreWeb = gDB.ValField(rs.fields, cscPrNombreWeb)
    m_AliasWeb = gDB.ValField(rs.fields, cscPrAliasWeb)
    m_ActivoWeb = gDB.ValField(rs.fields, cscPrActivoWeb)
    m_CodigoHtml = gDB.ValField(rs.fields, cscPrCodigoHtml)
    m_CodigoHtmlDetalle = gDB.ValField(rs.fields, cscPrCodigoHtmlDetalle)
    m_Codigo = gDB.ValField(rs.fields, cscPrCodigo)
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_Descripventa = gDB.ValField(rs.fields, cscPrDescripventa)
    m_Descripcompra = gDB.ValField(rs.fields, cscPrDescripcompra)
    m_Compraventa = gDB.ValField(rs.fields, cscPrVentaCompra)
    m_Ventastock = gDB.ValField(rs.fields, cscPrVentaStock)
    m_Comprastock = gDB.ValField(rs.fields, cscPrStockCompra)
    m_Llevastock = gDB.ValField(rs.fields, cscPrLlevastock)
    m_SeCompra = gDB.ValField(rs.fields, cscPrSecompra)
    m_SeVende = gDB.ValField(rs.fields, cscPrSevende)
    m_Dinerario = gDB.ValField(rs.fields, cscPrDinerario)
    m_NoRedondeo = gDB.ValField(rs.fields, cscPrNoRedondeo)
    m_Eskit = gDB.ValField(rs.fields, cscPrEskit)
    
    m_KitResumido = gDB.ValField(rs.fields, cscPrKitResumido)
    m_KitIdentidad = gDB.ValField(rs.fields, cscPrKitIdentidad)
    m_KitIdentidadXItem = gDB.ValField(rs.fields, cscPrKitIdentidadXItem)
    m_KitLote = gDB.ValField(rs.fields, cscPrKitLote)
    m_KitLoteXItem = gDB.ValField(rs.fields, cscPrKitLoteXItem)
    m_TalonarioKitSerie = gDB.ValField(rs.fields, "TalonarioSerie")
    m_TalonarioKitLote = gDB.ValField(rs.fields, "TalonarioLote")
    m_ta_id_kitSerie = gDB.ValField(rs.fields, cscTaIdKitSerie)
    m_ta_id_kitLote = gDB.ValField(rs.fields, cscTaIdKitLote)
    
    m_KitStkXItem = gDB.ValField(rs.fields, cscPrKitStockXItem)
    m_Eslista = gDB.ValField(rs.fields, cscPrEsLista)
    
    m_Un_id_compra = gDB.ValField(rs.fields, cscPrUnIdCompra)
    m_Un_id_venta = gDB.ValField(rs.fields, cscPrUnIdVenta)
    m_Un_id_stock = gDB.ValField(rs.fields, cscPrUnIdStock)
    m_Ti_id_ivaricompra = gDB.ValField(rs.fields, cscPrTiIdRiCompra)
    m_Ti_id_ivarnicompra = gDB.ValField(rs.fields, cscPrTiIdRniCompra)
    m_Ti_id_ivariventa = gDB.ValField(rs.fields, cscPrTiIdRiVenta)
    m_Ti_id_ivarniventa = gDB.ValField(rs.fields, cscPrTiIdRniVenta)
    m_Ti_id_internosv = gDB.ValField(rs.fields, cscPrTiIdInternosVenta)
    m_Ti_id_internosc = gDB.ValField(rs.fields, cscPrTiIdInternosCompra)
    m_Ibc_id = gDB.ValField(rs.fields, cscIbcId)
    m_Cueg_id_compra = gDB.ValField(rs.fields, cscPrCuegIdCompra)
    m_Cueg_id_venta = gDB.ValField(rs.fields, cscPrCuegIdVenta)
    m_Porcinternoc = gDB.ValField(rs.fields, cscPrPorcinternoc)
    m_Porcinternov = gDB.ValField(rs.fields, cscPrPorcinternov)
    m_marca = gDB.ValField(rs.fields, cscMarcNombre)
    m_marc_id = gDB.ValField(rs.fields, cscMarcId)
    
    m_TiIvaRiCompra = gDB.ValField(rs.fields, "ric")
    m_TiIvaRniCompra = gDB.ValField(rs.fields, "rnic")
    m_TiIvaRiVenta = gDB.ValField(rs.fields, "riv")
    m_TiIvaRniVenta = gDB.ValField(rs.fields, "rniv")
    m_TiInternosv = gDB.ValField(rs.fields, "iv")
    m_TiInternosc = gDB.ValField(rs.fields, "ic")
    m_Ingresosbrutos = gDB.ValField(rs.fields, cscIbcNombre)
    m_CuentaGCompra = gDB.ValField(rs.fields, "cc")
    m_CuentaGVenta = gDB.ValField(rs.fields, "cv")
    m_UnidadCompra = gDB.ValField(rs.fields, "uc")
    m_UnidadVenta = gDB.ValField(rs.fields, "uv")
    m_UnidadStock = gDB.ValField(rs.fields, "us")
    
    m_X = gDB.ValField(rs.fields, cscPrX)
    m_Y = gDB.ValField(rs.fields, cscPrY)
    m_Z = gDB.ValField(rs.fields, cscPrZ)
    m_Tienehijo = gDB.ValField(rs.fields, cscPrTienehijo)
    m_Id_Padre = gDB.ValField(rs.fields, cscPrIdPadre)
    m_EditarPrecioHijo = gDB.ValField(rs.fields, cscPrEditarPreciohijo)
    m_PermiteEdicion = gDB.ValField(rs.fields, cscPrPermiteedicion)
    m_Borrado = gDB.ValField(rs.fields, cscPrBorrado)
    m_Stockminimo = gDB.ValField(rs.fields, cscPrStockminimo)
    m_Stockmaximo = gDB.ValField(rs.fields, cscPrStockmaximo)
    m_Codigoexterno = gDB.ValField(rs.fields, cscPrCodigoexterno)
    m_CodigoBarra = gDB.ValField(rs.fields, cscPrCodigoBarra)
    m_CodigoBarraNombre = gDB.ValField(rs.fields, cscPrCodigoBarraNombre)
    m_Reposicion = gDB.ValField(rs.fields, cscPrReposicion)
    m_LlevaNroLote = gDB.ValField(rs.fields, cscPrLlevaNroLote)
    m_LoteFifo = gDB.ValField(rs.fields, cscPrLoteFifo)
    m_esRepuesto = gDB.ValField(rs.fields, cscPrEsRepuesto)
    m_LlevaNroSerie = gDB.ValField(rs.fields, cscPrLlevaNroSerie)
    m_seProduce = gDB.ValField(rs.fields, cscPrSeProduce)
    m_Rub_id = gDB.ValField(rs.fields, cscRubId)
    m_Rubro = gDB.ValField(rs.fields, cscRubNombre)
        
    m_Rubti_id1 = gDB.ValField(rs.fields, cscRubtiid1)
    m_Rubti_id2 = gDB.ValField(rs.fields, cscRubtiid2)
    m_Rubti_id3 = gDB.ValField(rs.fields, cscRubtiid3)
    m_Rubti_id4 = gDB.ValField(rs.fields, cscRubtiid4)
    m_Rubti_id5 = gDB.ValField(rs.fields, cscRubtiid5)
    m_Rubti_id6 = gDB.ValField(rs.fields, cscRubtiid6)
    m_Rubti_id7 = gDB.ValField(rs.fields, cscRubtiid7)
    m_Rubti_id8 = gDB.ValField(rs.fields, cscRubtiid8)
    m_Rubti_id9 = gDB.ValField(rs.fields, cscRubtiid9)
    m_Rubti_id10 = gDB.ValField(rs.fields, cscRubtiid10)
  
    m_TablaItem1 = gDB.ValField(rs.fields, "rubroi1")
    m_TablaItem2 = gDB.ValField(rs.fields, "rubroi2")
    m_TablaItem3 = gDB.ValField(rs.fields, "rubroi3")
    m_TablaItem4 = gDB.ValField(rs.fields, "rubroi4")
    m_TablaItem5 = gDB.ValField(rs.fields, "rubroi5")
    m_TablaItem6 = gDB.ValField(rs.fields, "rubroi6")
    m_TablaItem7 = gDB.ValField(rs.fields, "rubroi7")
    m_TablaItem8 = gDB.ValField(rs.fields, "rubroi8")
    m_TablaItem9 = gDB.ValField(rs.fields, "rubroi9")
    m_TablaItem10 = gDB.ValField(rs.fields, "rubroi10")
    
    m_PesoNeto = gDB.ValField(rs.fields, cscPrPesoNeto)
    m_PesoTotal = gDB.ValField(rs.fields, cscPrPesoTotal)
    
    m_FleteExpo = gDB.ValField(rs.fields, cscPrFleteExpo)
    
    m_egp_id = gDB.ValField(rs.fields, cscEgpId)
    m_GrupoExpo = gDB.ValField(rs.fields, cscEgpNombre)
    
    m_efm_id = gDB.ValField(rs.fields, cscEfmId)
    m_FamiliaExpo = gDB.ValField(rs.fields, cscEfmNombre)
    
    m_CantXCajaExpo = gDB.ValField(rs.fields, cscPrCantXCajaExpo)
    m_un_id_peso = gDB.ValField(rs.fields, cscUnIdPeso)
    m_UnidadPeso = gDB.ValField(rs.fields, "up")
    
    m_embl_id = gDB.ValField(rs.fields, cscEmblId)
    m_Embalaje = gDB.ValField(rs.fields, cscEmblNombre)
        
    m_expoCairo = gDB.ValField(rs.fields, cscPrExpoCairo)
    m_expoWeb = gDB.ValField(rs.fields, cscPrExpoWeb)
    m_ventaWebMaxima = gDB.ValField(rs.fields, cscPrVentaWebMaxima)
    m_ley_id = gDB.ValField(rs.fields, cscLeyId)
    m_leyenda = gDB.ValField(rs.fields, cscLeyNombre)
    m_webImageFolder = gDB.ValField(rs.fields, cscPrWebImageFolder)
    m_webImageUpdate = gDB.ValField(rs.fields, cscPrWebImageUpdate)
        
    m_CentroCostoCompra = gDB.ValField(rs.fields, "centro_costo_compra")
    m_ccos_id_compra = gDB.ValField(rs.fields, cscCcosIdCompra)
        
    m_CentroCostoVenta = gDB.ValField(rs.fields, "centro_costo_venta")
    m_ccos_id_venta = gDB.ValField(rs.fields, cscCcosIdVenta)
        
    m_esplantilla = gDB.ValField(rs.fields, cscPrEsPlantilla)
    m_cur_id = gDB.ValField(rs.fields, cscCurId)
    m_curso = gDB.ValField(rs.fields, cscCurNombre)
    
    m_rpt_id_nombrecompra = gDB.ValField(rs.fields, cscRptIdNombreCompra)
    m_rpt_nombrecompra = gDB.ValField(rs.fields, "rpt_nombrecompra")
    
    m_rpt_id_nombreventa = gDB.ValField(rs.fields, cscRptIdNombreVenta)
    m_rpt_nombreventa = gDB.ValField(rs.fields, "rpt_nombreventa")
    
    m_rpt_id_nombrefactura = gDB.ValField(rs.fields, cscRptIdNombreFactura)
    m_rpt_nombrefactura = gDB.ValField(rs.fields, "rpt_nombrefactura")
    
    m_rpt_id_nombreweb = gDB.ValField(rs.fields, cscRptIdNombreWeb)
    m_rpt_nombreweb = gDB.ValField(rs.fields, "rpt_nombreweb")
    
    m_rpt_id_nombreimg = gDB.ValField(rs.fields, cscRptIdNombreImg)
    m_rpt_nombreimg = gDB.ValField(rs.fields, "rpt_nombreimg")
    
    m_rpt_id_nombreimgalt = gDB.ValField(rs.fields, cscRptIdNombreImgAlt)
    m_rpt_nombreimgalt = gDB.ValField(rs.fields, "rpt_nombreimgalt")
    
    m_ti_id_comex_ganancias = gDB.ValField(rs.fields, cscTiIdComexGanancias)
    m_ti_comex_ganancias = gDB.ValField(rs.fields, "tiComexGanancias")
        
    m_ti_id_comex_igb = gDB.ValField(rs.fields, cscTiIdComexIGB)
    m_ti_comex_igb = gDB.ValField(rs.fields, "tiComexIGB")
        
    m_ti_id_comex_iva = gDB.ValField(rs.fields, cscTiIdComexIva)
    m_ti_comex_iva = gDB.ValField(rs.fields, "tiComexIVA")
    
    m_poar_id = gDB.ValField(rs.fields, cscPoarId)
    m_PosicionArancel = gDB.ValField(rs.fields, cscPoarNombre)
        
    m_productowebpadre = gDB.ValField(rs.fields, "webpadre")
    m_pr_id_webpadre = gDB.ValField(rs.fields, cscPrIdWebPadre)
        
  Else
    
    m_Id = csNO_ID
    m_Nombrecompra = vbNullString
    m_Nombreventa = vbNullString
    m_NombreFactura = vbNullString
    m_NombreWeb = vbNullString
    m_Codigo = vbNullString
    m_AliasWeb = vbNullString
    m_ActivoWeb = False
    m_CodigoHtml = vbNullString
    m_CodigoHtmlDetalle = vbNullString
    m_Activo = True
    m_Descripventa = vbNullString
    m_Descripcompra = vbNullString
    m_Un_id_compra = csNO_ID
    m_Un_id_venta = csNO_ID
    m_Un_id_stock = csNO_ID
    m_Compraventa = 0
    m_Ventastock = 0
    m_Comprastock = 0
    m_Llevastock = 0
    m_SeCompra = 0
    m_SeVende = 0
    m_Dinerario = False
    m_NoRedondeo = False
    m_Eskit = False
    
    m_KitResumido = False
    m_KitIdentidad = False
    m_KitIdentidadXItem = False
    m_KitLote = False
    m_KitLoteXItem = False
    m_TalonarioKitSerie = vbNullString
    m_TalonarioKitLote = vbNullString
    m_ta_id_kitSerie = csNO_ID
    m_ta_id_kitLote = csNO_ID
    
    m_KitStkXItem = False
    m_Eslista = False
    m_Ti_id_ivaricompra = csNO_ID
    m_Ti_id_ivarnicompra = csNO_ID
    m_Ti_id_ivariventa = csNO_ID
    m_Ti_id_ivarniventa = csNO_ID
    m_Ti_id_internosv = csNO_ID
    m_Ti_id_internosc = csNO_ID
    m_Porcinternoc = 0
    m_Porcinternov = 0
    m_Ibc_id = csNO_ID
    m_Cueg_id_compra = csNO_ID
    m_Cueg_id_venta = csNO_ID
    m_X = 0
    m_Y = 0
    m_Z = 0
    m_Tienehijo = False
    m_Id_Padre = csNO_ID
    m_EditarPrecioHijo = False
    m_PermiteEdicion = False
    m_Borrado = False
    m_Stockminimo = 0
    m_Stockmaximo = 0
    m_Codigoexterno = vbNullString
    m_CodigoBarra = vbNullString
    m_CodigoBarraNombre = vbNullString
    m_Reposicion = 0
    m_LlevaNroLote = 0
    m_LoteFifo = 0
    m_LlevaNroSerie = 0
    m_seProduce = 0
    m_esRepuesto = 0
    
    m_marca = vbNullString
    m_marc_id = csNO_ID

    m_TiIvaRiCompra = vbNullString
    m_TiIvaRniCompra = vbNullString
    m_TiIvaRiVenta = vbNullString
    m_TiIvaRniVenta = vbNullString
    m_TiInternosv = vbNullString
    m_TiInternosc = vbNullString
    m_Ingresosbrutos = vbNullString
    m_CuentaGCompra = vbNullString
    m_CuentaGVenta = vbNullString
    m_UnidadCompra = vbNullString
    m_UnidadVenta = vbNullString
    m_UnidadStock = vbNullString
  
    m_Rub_id = csNO_ID
    m_Rubro = vbNullString
  
    m_Rubti_id1 = csNO_ID
    m_Rubti_id2 = csNO_ID
    m_Rubti_id3 = csNO_ID
    m_Rubti_id4 = csNO_ID
    m_Rubti_id5 = csNO_ID
    m_Rubti_id6 = csNO_ID
    m_Rubti_id7 = csNO_ID
    m_Rubti_id8 = csNO_ID
    m_Rubti_id9 = csNO_ID
    m_Rubti_id10 = csNO_ID
  
    m_TablaItem1 = vbNullString
    m_TablaItem2 = vbNullString
    m_TablaItem3 = vbNullString
    m_TablaItem4 = vbNullString
    m_TablaItem5 = vbNullString
    m_TablaItem6 = vbNullString
    m_TablaItem7 = vbNullString
    m_TablaItem8 = vbNullString
    m_TablaItem9 = vbNullString
    m_TablaItem10 = vbNullString
  
    m_PesoNeto = 0
    m_PesoTotal = 0
    m_FleteExpo = False
    m_egp_id = csNO_ID
    m_GrupoExpo = vbNullString
    m_efm_id = csNO_ID
    m_FamiliaExpo = vbNullString
    m_CantXCajaExpo = 0
    m_un_id_peso = csNO_ID
    m_UnidadPeso = vbNullString
  
    m_embl_id = csNO_ID
    m_Embalaje = vbNullString
  
    m_expoCairo = 50
    m_expoWeb = 50
    m_ventaWebMaxima = 99999
    m_ley_id = csNO_ID
    m_leyenda = vbNullString
  
    m_webImageFolder = vbNullString
    m_webImageUpdate = True
  
    m_CentroCostoCompra = vbNullString
    m_ccos_id_compra = csNO_ID
        
    m_CentroCostoVenta = vbNullString
    m_ccos_id_venta = csNO_ID
  
    m_esplantilla = 0
    m_cur_id = csNO_ID
    m_curso = vbNullString
  
    m_rpt_id_nombrecompra = csNO_ID
    m_rpt_nombrecompra = vbNullString
    
    m_rpt_id_nombreventa = csNO_ID
    m_rpt_nombreventa = vbNullString
    
    m_rpt_id_nombrefactura = csNO_ID
    m_rpt_nombrefactura = vbNullString
    
    m_rpt_id_nombreweb = csNO_ID
    m_rpt_nombreweb = vbNullString
    
    m_rpt_id_nombreimg = csNO_ID
    m_rpt_nombreimg = vbNullString
    
    m_rpt_id_nombreimgalt = csNO_ID
    m_rpt_nombreimgalt = vbNullString
  
    m_ti_id_comex_ganancias = csNO_ID
    m_ti_comex_ganancias = vbNullString
        
    m_ti_id_comex_igb = csNO_ID
    m_ti_comex_igb = vbNullString
        
    m_ti_id_comex_iva = csNO_ID
    m_ti_comex_iva = vbNullString
  
    m_poar_id = csNO_ID
    m_PosicionArancel = vbNullString
  
    m_productowebpadre = vbNullString
    m_pr_id_webpadre = csNO_ID
  
  End If
  
  m_bRubroChanged = m_LastRubId <> m_Rub_id
  m_LastRubId = m_Rub_id

  If Not m_GenericEdit.Load(m_Id) Then Exit Function

  Load = True
End Function

Private Sub pRefreshProperties()
  Dim c      As cIABMProperty
  Dim AbmGen As cABMGeneric
  Dim filter As String

  SetEnabledPlantilla

  With m_ObjAbm
    
    .Title2 = m_Nombrecompra
    
    With .Properties
  
      '////////////////////////////////////////////////////////////
      ' Compras
      '
      With .Item(cscPrNombrecompra)
        .Value = m_Nombrecompra
      End With
      
      With .Item(cscActivo)
        .Value = CInt(m_Activo)
      End With
      
      With .Item(cscPrCodigo)
        .Value = m_Codigo
      End With
      
      With .Item(cscPrCodigoexterno)
        .Value = m_Codigoexterno
      End With
      
      With .Item(cscPrCodigoBarra)
        .Value = m_CodigoBarra
      End With
      
      With .Item(cscPrCodigoBarraNombre)
        .Value = m_CodigoBarraNombre
      End With
      
      With .Item(cscIbcId)
        .HelpId = m_Ibc_id
        .Value = m_Ingresosbrutos
      End With
      
      With .Item(cscPrEsPlantilla)
        .Value = m_esplantilla
      End With
      
      With .Item(cscCurId)
        .Value = m_curso
        .HelpId = m_cur_id
      End With
      
      With .Item(cscPrDescripcompra)
        .Value = m_Descripcompra
      End With
      
      With .Item(cscRptIdNombreCompra)
        .Value = m_rpt_nombrecompra
        .HelpId = m_rpt_id_nombrecompra
      End With
      
      With .Item(cscRptIdNombreVenta)
        .Value = m_rpt_nombreventa
        .HelpId = m_rpt_id_nombreventa
      End With
      
      With .Item(cscRptIdNombreFactura)
        .Value = m_rpt_nombrefactura
        .HelpId = m_rpt_id_nombrefactura
      End With
      
      With .Item(cscRptIdNombreWeb)
        .Value = m_rpt_nombreweb
        .HelpId = m_rpt_id_nombreweb
      End With
      
      With .Item(cscRptIdNombreImg)
        .Value = m_rpt_nombreimg
        .HelpId = m_rpt_id_nombreimg
      End With
      
      With .Item(cscRptIdNombreImgAlt)
        .Value = m_rpt_nombreimgalt
        .HelpId = m_rpt_id_nombreimgalt
      End With
      
      With .Item(cscPrSecompra)
        .Value = CInt(m_SeCompra)
      End With
      
      With .Item(cscPrUnIdCompra)
        .HelpId = m_Un_id_compra
        .Value = m_UnidadCompra
      End With
      
      With .Item(cscPrCuegIdCompra)
        .HelpId = m_Cueg_id_compra
        .Value = m_CuentaGCompra
      End With
      
      With .Item(cscCcosIdCompra)
        .HelpId = m_ccos_id_compra
        .Value = m_CentroCostoCompra
      End With
      
      With .Item(cscMarcId)
        .Value = m_marca
        .HelpId = m_marc_id
      End With
      
      With .Item(cscUnIdPeso)
        .Value = m_UnidadPeso
        .HelpId = m_un_id_peso
      End With
      
      With .Item(cscPrPesoNeto)
        .Value = m_PesoNeto
      End With
      
      With .Item(cscPrPesoTotal)
        .Value = m_PesoTotal
      End With
      
      With .Item(cscEgpId)
        .Value = m_GrupoExpo
        .HelpId = m_egp_id
      End With
      
      With .Item(cscEfmId)
        .Value = m_FamiliaExpo
        .HelpId = m_efm_id
      End With
      
      With .Item(cscPrFleteExpo)
        .Value = CInt(m_FleteExpo)
      End With
      
      With .Item(cscPrCantXCajaExpo)
        .Value = m_CantXCajaExpo
      End With
      
      With .Item(cscEmblId)
        .Value = m_Embalaje
        .HelpId = m_embl_id
      End With
      
      With .Item(cscTiIdComexGanancias)
        .HelpId = m_ti_id_comex_ganancias
        .Value = m_ti_comex_ganancias
      End With
      
      With .Item(cscTiIdComexIGB)
        .HelpId = m_ti_id_comex_igb
        .Value = m_ti_comex_igb
      End With
      
      With .Item(cscTiIdComexIva)
        .HelpId = m_ti_id_comex_iva
        .Value = m_ti_comex_iva
      End With
      
      With .Item(cscPoarId)
        .HelpId = m_poar_id
        .Value = m_PosicionArancel
      End With
      
      With .Item(cscPrExpoWeb)
        .Value = m_expoWeb
      End With
      
      With .Item(cscPrExpoCairo)
        .Value = m_expoCairo
      End With
      
      With .Item(cscPrVentaWebMaxima)
        .Value = m_ventaWebMaxima
      End With
      
      With .Item(cscLeyId)
        .Value = m_leyenda
        .HelpId = m_ley_id
      End With
      
      With .Item(cscPrWebImageFolder)
        .Value = m_webImageFolder
      End With
      
      With .Item(cscPrWebImageUpdate)
        .Value = CInt(m_webImageUpdate)
      End With
      
      With .Item(cscPrTiIdRiCompra)
        .Value = m_TiIvaRiCompra
        .HelpId = m_Ti_id_ivaricompra
      End With
      
'      With .Item(cscPrTiIdRniCompra)
'        .Value = m_TiIvaRniCompra
'        .HelpId = m_Ti_id_ivarnicompra
'      End With
      
      With .Item(cscPrTiIdInternosCompra)
        .Value = m_TiInternosc
        .HelpId = m_Ti_id_internosc
      End With
      
      With .Item(cscPrPorcinternoc)
        .Value = m_Porcinternoc
      End With
      
      '////////////////////////////////////////////////////////////
      ' Stock
      '
      With .Item(cscPrLlevastock)
        .Value = CInt(m_Llevastock)
      End With
      
      With .Item(cscPrUnIdStock)
        .Value = m_UnidadStock
        .HelpId = m_Un_id_stock
      End With
      
      With .Item(cscPrStockCompra)
        .Value = m_Comprastock
      End With
      
      With .Item(cscPrX)
        .Value = m_X
      End With
      
      With .Item(cscPrY)
        .Value = m_Y
      End With
      
      With .Item(cscPrZ)
        .Value = m_Z
      End With
      
      With .Item(cscPrStockminimo)
        .Value = m_Stockminimo
      End With
      
      With .Item(cscPrStockmaximo)
        .Value = m_Stockmaximo
      End With
      
      With .Item(cscPrReposicion)
        .Value = m_Reposicion
      End With
      
      With .Item(cscPrLlevaNroSerie)
        .Value = CInt(m_LlevaNroSerie)
      End With
      
      With .Item(cscPrLlevaNroLote)
        .Value = CInt(m_LlevaNroLote)
      End With
    
      With .Item(cscPrLoteFifo)
        .Value = CInt(m_LoteFifo)
      End With
    
      With .Item(cscPrSeProduce)
        .Value = CInt(m_seProduce)
      End With
      
      With .Item(cscPrEsRepuesto)
        .Value = CInt(m_esRepuesto)
      End With
      
      '////////////////////////////////////////////////////////////
      ' Ventas
      '
      With .Item(cscPrSevende)
        .Value = CInt(m_SeVende)
      End With
      
      With .Item(cscPrNombreventa)
        .Value = m_Nombreventa
      End With
      
      With .Item(cscPrNombreFactura)
        .Value = m_NombreFactura
      End With
      
      With .Item(cscPrUnIdVenta)
        .Value = m_UnidadVenta
        .HelpId = m_Un_id_venta
      End With
      
      With .Item(cscPrVentaCompra)
        .Value = m_Compraventa
      End With
      
      With .Item(cscPrVentaStock)
        .Value = m_Ventastock
      End With
      
      With .Item(cscPrCuegIdVenta)
        .HelpId = m_Cueg_id_venta
        .Value = m_CuentaGVenta
      End With
      
      With .Item(cscPrEsLista)
        .Value = CInt(m_Eslista)
      End With
      
      With .Item(cscPrTiIdRiVenta)
        .Value = m_TiIvaRiVenta
        .HelpId = m_Ti_id_ivariventa
      End With
      
'      With .Item(cscPrTiIdRniVenta)
'        .Value = m_TiIvaRniVenta
'        .HelpId = m_Ti_id_ivarniventa
'      End With
      
      With .Item(cscPrTiIdInternosVenta)
        .Value = m_TiInternosv
        .HelpId = m_Ti_id_internosv
      End With
      
      With .Item(cscPrPorcinternov)
        .Value = m_Porcinternov
      End With
      
      With .Item(cscPrDinerario)
        .Value = CInt(m_Dinerario)
      End With
      
      With .Item(cscPrNoRedondeo)
        .Value = CInt(m_NoRedondeo)
      End With
      
      With .Item(cscCcosIdVenta)
        .HelpId = m_ccos_id_venta
        .Value = m_CentroCostoVenta
      End With
      
      With .Item(cscPrDescripventa)
        .Value = m_Descripventa
      End With
      
      With .Item(cscRubId)
        .Value = m_Rubro
        .HelpId = m_Rub_id
      End With
    
      '////////////////////////////////////////////////////////////
      ' Kit
      '
      With .Item(cscPrEskit)
        .Value = CInt(m_Eskit)
      End With
      
      With .Item(cscPrKitStockXItem)
        .Value = CInt(m_KitStkXItem)
      End With
      
      With .Item(cscPrKitResumido)
        .Value = CInt(m_KitResumido)
      End With
      
      With .Item(cscPrKitIdentidad)
        .Value = CInt(m_KitIdentidad)
      End With
      
      With .Item(cscPrKitIdentidadXItem)
        .Value = CInt(m_KitIdentidadXItem)
      End With
      
      With .Item(cscTaIdKitSerie)
        .Value = m_TalonarioKitSerie
        .HelpId = m_ta_id_kitSerie
      End With
      
      With .Item(cscPrKitLote)
        .Value = CInt(m_KitLote)
      End With
      
      With .Item(cscPrKitLoteXItem)
        .Value = CInt(m_KitLoteXItem)
      End With
      
      With .Item(cscTaIdKitLote)
        .Value = m_TalonarioKitLote
        .HelpId = m_ta_id_kitLote
      End With
      
      Set c = .Item(c_productoKit)
      If Not pLoadKit(c) Then Exit Sub
      
      '////////////////////////////////////////////////////////////
      ' Proveedores
      '
      Set c = .Item(c_proveedor)
      If Not pLoadProveedor(c) Then Exit Sub
      m_ItemsDeletedProveedor = vbNullString
          
      '////////////////////////////////////////////////////////////
      ' Clientes
      '
      Set c = .Item(c_cliente)
      If Not pLoadCliente(c) Then Exit Sub
      m_ItemsDeletedCliente = vbNullString
      
      '////////////////////////////////////////////////////////////
      ' BOMs
      '
      Set c = .Item(c_BOM)
      If Not pLoadBOM(c) Then Exit Sub
        
      '////////////////////////////////////////////////////////////
      ' CMI
      '
      Set c = .Item(c_cmi)
      If Not pLoadCMI(c) Then Exit Sub
      m_ItemsDeletedCMI = vbNullString
        
      '////////////////////////////////////////////////////////////
      ' Leyendas
      '
      Set c = .Item(c_leyendas)
      If Not pLoadLeyendas(c) Then Exit Sub
      m_ItemsDeletedLeyendas = vbNullString
        
      '////////////////////////////////////////////////////////////
      ' Tags
      '
      With .Item(cscPrNombreWeb)
        .Value = m_NombreWeb
      End With
      
      With .Item(cscPrAliasWeb)
        .Value = m_AliasWeb
      End With
      
      With .Item(cscPrIdWebPadre)
        .Value = m_productowebpadre
        .HelpId = m_pr_id_webpadre
      End With
      
      With .Item(cscPrActivoWeb)
        .Value = CInt(m_ActivoWeb)
      End With
      
      With .Item(cscPrCodigoHtml)
        .Value = m_CodigoHtml
      End With
      
      With .Item(cscPrCodigoHtmlDetalle)
        .Value = m_CodigoHtmlDetalle
      End With
      
      Set c = .Item(c_WEB_IMAGES)
      If Not pLoadWebImages(c) Then Exit Sub
      m_ItemsDeletedWebImages = vbNullString
      
      Set c = .Item(c_TAGS)
      If Not pLoadTags(c) Then Exit Sub
      m_ItemsDeletedTag = vbNullString
    
      '////////////////////////////////////////////////////////////
      ' Catalogos
      '
      Set c = .Item(c_WEB_catalogs)
      If Not pLoadCatalogosWeb(c) Then Exit Sub
    
      '////////////////////////////////////////////////////////////
      ' Categorias
      '
      Set c = .Item(c_WEB_categories)
      If Not pLoadCategoriasWeb(c) Then Exit Sub
    
    End With
  End With
  
  m_GenericEdit.RefreshProperties m_ObjAbm
  
  ' Si cambio el rubro, me veo
  ' obligado a llamar a RefreshRubro
  ' para que actualice los controles
  ' y como esta rutina obliga un loadcontrol
  ' de toda la ventana, no me gasto llamando
  ' a ShowValues
  '
  If m_bRubroChanged Then
  
    pSetRubro m_Rub_id, True
    
  Else
    pRefreshRubro m_Rub_id
      
    Set AbmGen = m_ObjAbm
    AbmGen.ShowValues m_ObjAbm.Properties
  
  End If
  
End Sub

Private Sub pRefreshRubro(ByVal Rub_ID As Long)
  Dim Rubro  As cRubro
  Set Rubro = New cRubro
  Rubro.Load Rub_ID
  
  With m_ObjAbm.Properties
  
    If Rubro.Rubt_id1 <> csNO_ID Then
      With .Item(cscRubtiid1)
        .Value = m_TablaItem1
        .HelpId = m_Rubti_id1
      End With
    End If
    
    If Rubro.Rubt_id2 <> csNO_ID Then
      With .Item(cscRubtiid2)
        .Value = m_TablaItem2
        .HelpId = m_Rubti_id2
      End With
    End If
    
    If Rubro.Rubt_id3 <> csNO_ID Then
      With .Item(cscRubtiid3)
        .Value = m_TablaItem3
        .HelpId = m_Rubti_id3
      End With
    End If
    
    If Rubro.Rubt_id4 <> csNO_ID Then
      With .Item(cscRubtiid4)
        .Value = m_TablaItem4
        .HelpId = m_Rubti_id4
      End With
    End If
    
    If Rubro.Rubt_id5 <> csNO_ID Then
      With .Item(cscRubtiid5)
        .Value = m_TablaItem5
        .HelpId = m_Rubti_id5
      End With
    End If
    
    If Rubro.Rubt_id6 <> csNO_ID Then
      With .Item(cscRubtiid6)
        .Value = m_TablaItem6
        .HelpId = m_Rubti_id6
      End With
    End If
    
    If Rubro.Rubt_id7 <> csNO_ID Then
      With .Item(cscRubtiid7)
        .Value = m_TablaItem7
        .HelpId = m_Rubti_id7
      End With
    End If
    
    If Rubro.Rubt_id8 <> csNO_ID Then
      With .Item(cscRubtiid8)
        .Value = m_TablaItem8
        .HelpId = m_Rubti_id8
      End With
    End If
    
    If Rubro.Rubt_id9 <> csNO_ID Then
      With .Item(cscRubtiid9)
        .Value = m_TablaItem9
        .HelpId = m_Rubti_id9
      End With
    End If
    
    If Rubro.Rubt_id10 <> csNO_ID Then
      With .Item(cscRubtiid10)
        .Value = m_TablaItem10
        .HelpId = m_Rubti_id10
      End With
    End If
    
  End With
End Sub

Private Sub Class_Initialize()
  On Error Resume Next
  c_ErrorSave = LNGGetText(1352, vbNullString) 'Error al grabar el Artículo

  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load

End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing

  ' Preferencias del Usuario
  '
  Set m_UserCfg = Nothing
End Sub

'///////////////////////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////////////////////////////////////////////////////
Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  Select Case Key
    Case K_WEB_CATALOGOS, K_WEB_CATEGORIAS
      cIABMClientGrid_ColumnBeforeEdit = lCol = 4 Or lCol = 5
    Case Else
      cIABMClientGrid_ColumnBeforeEdit = True
  End Select
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Select Case Key
    
    Case K_PROVEEDOR
      Id = Val(pCell(row, KIK_PRPROV_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedProveedor = m_ItemsDeletedProveedor & Id & C_StrColon
    
    Case K_CLIENTE
      Id = Val(pCell(row, KIK_PRCLI_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedCliente = m_ItemsDeletedCliente & Id & C_StrColon
      
    Case K_TAGS
      Id = Val(pCell(row, KIT_PRT_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedTag = m_ItemsDeletedTag & Id & C_StrColon
      
    Case K_WEB_IMAGES
      Id = Val(pCell(row, KIWI_PRWI_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedWebImages = m_ItemsDeletedWebImages & Id & C_StrColon
      
    Case K_CMI
      Id = Val(pCell(row, KICMI_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedCMI = m_ItemsDeletedCMI & Id & C_StrColon
      
    Case K_LEYENDAS
      Id = Val(pCell(row, KIPRL_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedLeyendas = m_ItemsDeletedLeyendas & Id & C_StrColon
      
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
    Case K_PRODUCTO_KIT
      cIABMClientGrid_ValidateRow = True
    Case K_PROVEEDOR
      cIABMClientGrid_ValidateRow = pValidateRowProveedor(row, RowIndex)
    Case K_CLIENTE
      cIABMClientGrid_ValidateRow = pValidateRowCliente(row, RowIndex)
    Case K_TAGS
      cIABMClientGrid_ValidateRow = True
    Case K_BOM
      cIABMClientGrid_ValidateRow = True
    Case K_WEB_IMAGES
      cIABMClientGrid_ValidateRow = pValidateRowWebImage(row, RowIndex)
    Case K_CMI
      cIABMClientGrid_ValidateRow = pValidateRowCMI(row, RowIndex)
    Case K_LEYENDAS
      cIABMClientGrid_ValidateRow = pValidateRowLeyendas(row, RowIndex)
    Case K_WEB_CATALOGOS, K_WEB_CATEGORIAS
      cIABMClientGrid_ValidateRow = True
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)
  Select Case Key
    Case K_PROVEEDOR
      With m_ObjAbm.Properties.Item(c_proveedor)
        pEditLP pCell(.Grid.Rows.Item(lRow), KIK_PROV_LPI_ID).Id
      End With
  End Select
End Sub

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_PROVEEDOR
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowProveedor(row, RowIndex)
    Case K_CLIENTE
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowCliente(row, RowIndex)
    Case K_TAGS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowTags(row, RowIndex)
    Case K_WEB_IMAGES
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowWebImages(row, RowIndex)
    Case K_CMI
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowCMI(row, RowIndex)
    Case K_LEYENDAS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowLeyendas(row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' funciones privadas
Private Function pSaveItemsWebCatalogos() As Boolean
  Dim register  As cRegister
  Dim fields    As cFields
  
  Dim sqlstmt As String
  sqlstmt = "delete CatalogoWebItem where pr_id = " & m_Id
  If Not gDB.Execute(sqlstmt) Then Exit Function
  
  With m_ObjAbm.Properties.Item(c_WEB_catalogs)
    Dim row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each row In .Grid.Rows
    
      If pCell(row, KICW_SELECT).Id Then
    
        Set register = New cRegister
        
        With register
          Set fields = .fields
          .fieldId = cscCatwiId
          .Table = csTCatalogoWebItem
          .Id = csNew
          
          For Each Cell In row
            Select Case Cell.Key
              
              Case KICW_ID
                fields.Add2 cscCatwId, Cell.Id, csId
                
            End Select
          Next
          
          fields.Add2 cscCatwiActivo, 1, csBoolean
          fields.Add2 cscPrId, m_Id, csId
          
          fields.HaveLastUpdate = True
          fields.HaveWhoModify = True
          
        End With
                                                                        
        If Not gDB.Save(register, , "pSaveItemsWebCatalogos", C_Module, c_ErrorSave) Then Exit Function
      
      End If
    
    Next
  End With
    
  pSaveItemsWebCatalogos = True
End Function

Private Function pSaveItemsWebCategorias() As Boolean
  Dim register  As cRegister
  Dim fields    As cFields
  
  Dim sqlstmt As String
  sqlstmt = "delete CatalogoWebCategoriaItem where pr_id = " & m_Id
  If Not gDB.Execute(sqlstmt) Then Exit Function
  
  With m_ObjAbm.Properties.Item(c_WEB_categories)
    Dim row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each row In .Grid.Rows
    
      If pCell(row, KICWC_SELECT).Id Then
    
        Set register = New cRegister
        
        With register
          Set fields = .fields
          .fieldId = cscCatwciId
          .Table = csTCatalogoWebCategoriaItem
          .Id = csNew
          
          For Each Cell In row
            Select Case Cell.Key
              
              Case KICWC_ID
                fields.Add2 cscCatwcId, Cell.Id, csId
              
              Case KICWCI_POSICION
                fields.Add2 cscCatwciPosicion, Cell.Value, csInteger
                
            End Select
          Next
          
          fields.Add2 cscCatwciActivo, 1, csBoolean
          fields.Add2 cscPrId, m_Id, csId
          
          fields.HaveLastUpdate = True
          fields.HaveWhoModify = True
          
        End With
                                                                        
        If Not gDB.Save(register, , "pSaveItemsWebCategorias", C_Module, c_ErrorSave) Then Exit Function
      
      End If
    
    Next
  End With
    
  pSaveItemsWebCategorias = True
End Function

Private Function pSaveItemsProveedor() As Boolean
  Dim register  As cRegister
  Dim fields    As cFields
  Dim sqlstmt   As String
  
  With m_ObjAbm.Properties.Item(c_proveedor)
    Dim row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each row In .Grid.Rows
    
      If pIsRowProveedorFromUser(row) Then
    
        Set register = New cRegister
        
        With register
          Set fields = .fields
          .fieldId = cscPrProvId
          .Table = csTProductoProveedor
          .Id = csNew
          
          For Each Cell In row
            Select Case Cell.Key
              
              Case KIK_PRPROV_ID
                If Not m_Copy Then
                  .Id = IIf(Val(Cell.Value) > 0, Val(Cell.Value), csNew)
                End If
              Case KIK_PROV_ID
                fields.Add2 cscProvId, Cell.Id, csId
              Case KIK_PROV_FABRICANTE
                fields.Add2 cscPrProvFabricante, Cell.Id, csBoolean
              Case KIK_PROV_NOMBRE
                fields.Add2 cscPrProvNombre, Cell.Value, csText
              Case KIK_PROV_CODIGO
                fields.Add2 cscPrProvCodigo, Cell.Value, csText
              Case KIK_PROV_CODBARRA
                fields.Add2 cscPrProvCodigoBarra, Cell.Value, csText
              Case KIK_PA_ID
                fields.Add2 cscPaId, Cell.Id, csId
            End Select
          Next
          
          fields.Add2 cscPrId, m_Id, csId
          
          fields.HaveLastUpdate = True
          fields.HaveWhoModify = True
          
        End With
                                                                    
        If Not gDB.Save(register, , "pSaveItemsProveedor", C_Module, c_ErrorSave) Then Exit Function
      
      End If
      
      If pCell(row, KIK_PROV_PRECIO).Value <> pCell(row, KIK_PROV_PRECIO2).Value And pCell(row, KIK_PROV_LPI_ID).Id <> csNO_ID Then
        
        sqlstmt = "sp_ProductoSavePrecio " _
                         & m_Id & "," _
                         & pCell(row, KIK_PROV_LPI_ID).Id & "," _
                         & gDB.sqlNumber(pCell(row, KIK_PROV_PRECIO).Value) & "," _
                         & gDB.sqlDate(pCell(row, KIK_PROV_PRECIO_FECHA).Value)
        
        If Not gDB.Execute(sqlstmt) Then Exit Function
        
      End If

    Next
  End With
  
  If m_ItemsDeletedProveedor <> vbNullString And Not m_Copy Then
    m_ItemsDeletedProveedor = RemoveLastColon(m_ItemsDeletedProveedor)
    sqlstmt = "delete ProductoProveedor where prprov_id in (" & m_ItemsDeletedProveedor & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsProveedor", C_Module) Then Exit Function
  End If
  
  pSaveItemsProveedor = True
End Function

Private Function pSaveItemsCMI() As Boolean
  Dim register  As cRegister
  Dim fields    As cFields
  
  With m_ObjAbm.Properties.Item(c_cmi)
    Dim row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscPrcmiId
        .Table = csTProductoComunidadInternet
        .Id = csNew
        
        For Each Cell In row
          Select Case Cell.Key
            
            Case KICMI_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            
            Case KICMI_CMI_ID
              fields.Add2 cscCmiId, Cell.Id, csId
            
            Case KICMI_CODIGO
              fields.Add2 cscPrcmiCodigo, Cell.Value, csText
            
            Case KICMI_DESCRIP
              fields.Add2 cscPrcmiDescrip, Cell.Value, csText
              
            Case KICMI_PRECIO
              fields.Add2 cscPrcmiPrecio, Cell.Value, csDouble
              
            Case KICMI_FECHAALTA
              fields.Add2 cscPrcmiFechaAlta, Cell.Value, csDate
              
            Case KICMI_FECHAVTO
              fields.Add2 cscPrcmiFechaVto, Cell.Value, csDate
              
          End Select
        Next
        
        fields.Add2 cscPrId, m_Id, csId
        
        fields.HaveLastUpdate = True
        fields.HaveWhoModify = True
        
      End With
                                                                      
      If Not gDB.Save(register, , "pSaveItemsCMI", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If m_ItemsDeletedCMI <> vbNullString And Not m_Copy Then
    m_ItemsDeletedCMI = RemoveLastColon(m_ItemsDeletedCMI)
    sqlstmt = "delete ProductoComunidadInternet where prcmi_id in (" & m_ItemsDeletedCMI & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsCMI", C_Module) Then Exit Function
  End If
  
  pSaveItemsCMI = True
End Function

Private Function pSaveItemsLeyendas() As Boolean
  Dim register  As cRegister
  Dim fields    As cFields
  
  With m_ObjAbm.Properties.Item(c_leyendas)
    Dim row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscPrlId
        .Table = csTProductoLeyenda
        .Id = csNew
        
        For Each Cell In row
          Select Case Cell.Key
            
            Case KICMI_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            
            Case KIPRL_NOMBRE
              fields.Add2 cscPrlNombre, Cell.Value, csText
            
            Case KIPRL_TEXTO
              fields.Add2 cscPrlTexto, Cell.Value, csText
            
            Case KIPRL_TAG
              fields.Add2 cscPrlTag, Cell.Value, csText
              
            Case KIPRL_ORDEN
              fields.Add2 cscPrlOrden, Cell.Value, csText
              
          End Select
        Next
        
        fields.Add2 cscPrId, m_Id, csId
        
        fields.HaveLastUpdate = True
        fields.HaveWhoModify = True
        
      End With
                                                                      
      If Not gDB.Save(register, , "pSaveItemsLeyendas", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If m_ItemsDeletedLeyendas <> vbNullString And Not m_Copy Then
    m_ItemsDeletedLeyendas = RemoveLastColon(m_ItemsDeletedLeyendas)
    sqlstmt = "delete ProductoLeyenda where prl_id in (" & m_ItemsDeletedLeyendas & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsLeyendas", C_Module) Then Exit Function
  End If
  
  pSaveItemsLeyendas = True
End Function

Private Function pSaveItemsWebImages() As Boolean
  Dim register  As cRegister
  Dim fields    As cFields
  
  With m_ObjAbm.Properties.Item(c_WEB_IMAGES)
    Dim row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscPrwiId
        .Table = csTProductoWebImage
        .Id = csNew
        
        For Each Cell In row
          Select Case Cell.Key
            
            Case KIWI_PRWI_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            
            Case KIWI_IMAGE
              fields.Add2 cscPrwiArchivo, Cell.Value, csText
              
            Case KIWI_ALT
              fields.Add2 cscPrwiAlt, Cell.Value, csText
              
            Case KIWI_IMAGE_TYPE
              fields.Add2 cscPrwiTipo, Cell.Id, csInteger
            
            Case KIWI_POSICION
              fields.Add2 cscPrwiPosicion, Cell.Value, csDouble
          End Select
        Next
        
        fields.Add2 cscPrId, m_Id, csId
        
        fields.HaveLastUpdate = False
        fields.HaveWhoModify = False
        
      End With
                                                                      
      If Not gDB.Save(register, , "pSaveItemsWebImages", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If m_ItemsDeletedWebImages <> vbNullString And Not m_Copy Then
    m_ItemsDeletedWebImages = RemoveLastColon(m_ItemsDeletedWebImages)
    sqlstmt = "delete ProductoWebImage where prwi_id in (" & m_ItemsDeletedWebImages & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsWebImages", C_Module) Then Exit Function
  End If
  
  pSaveItemsWebImages = True
End Function

Private Function pSaveItemsCliente() As Boolean
  Dim register  As cRegister
  Dim fields    As cFields
  
  With m_ObjAbm.Properties.Item(c_cliente)
    Dim row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscPrCliId
        .Table = csTProductoCliente
        .Id = csNew
        
        For Each Cell In row
          Select Case Cell.Key
            
            Case KIK_PRCLI_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            Case KIK_CLI_ID
              fields.Add2 cscCliId, Cell.Id, csId
            Case KIK_CLI_NOMBRE
              fields.Add2 cscPrCliNombre, Cell.Value, csText
            Case KIK_CLI_CODIGO
              fields.Add2 cscPrCliCodigo, Cell.Value, csText
            Case KIK_CLI_CODBARRA
              fields.Add2 cscPrCliCodigoBarra, Cell.Value, csText
          End Select
        Next
        
        fields.Add2 cscPrId, m_Id, csId
        
        fields.HaveLastUpdate = True
        fields.HaveWhoModify = True
        
      End With
                                                                      
      If Not gDB.Save(register, , "pSaveItemsCliente", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If m_ItemsDeletedCliente <> vbNullString And Not m_Copy Then
    m_ItemsDeletedCliente = RemoveLastColon(m_ItemsDeletedCliente)
    sqlstmt = "delete ProductoCliente where prcli_id in (" & m_ItemsDeletedCliente & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsCliente", C_Module) Then Exit Function
  End If
  
  pSaveItemsCliente = True
End Function

Private Function pSaveItemsTags() As Boolean
  Dim register  As cRegister
  Dim fields    As cFields
  Dim bPrIdTag  As Boolean
  
  With m_ObjAbm.Properties.Item(c_TAGS)
    Dim row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscPrtId
        .Table = csTProductoTag
        .Id = csNew
        
        For Each Cell In row
          Select Case Cell.Key
            
            Case KIT_PRT_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            
            Case KIT_PR_ID_TAG
              bPrIdTag = Cell.Id <> csNO_ID
              fields.Add2 cscPrIdTag, Cell.Id, csId
            
            Case KIT_TEXTO
              
              If bPrIdTag Then
                fields.Add2 cscPrtTexto, vbNullString, csText
              Else
                fields.Add2 cscPrtTexto, Cell.Value, csText
              End If
              
            Case KIT_EXPOCAIRO
              fields.Add2 cscPrtExpoCairo, Cell.Value, csInteger
              
            Case KIT_EXPOWEB
              fields.Add2 cscPrtExpoWeb, Cell.Value, csInteger
            
          End Select
        Next
        
        fields.Add2 cscPrId, m_Id, csId
        
        fields.HaveLastUpdate = False
        fields.HaveWhoModify = False
        
      End With
                                                                      
      If Not gDB.Save(register, , "pSaveItemsTags", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If m_ItemsDeletedTag <> vbNullString And Not m_Copy Then
    m_ItemsDeletedTag = RemoveLastColon(m_ItemsDeletedTag)
    sqlstmt = "delete ProductoTag where prt_id in (" & m_ItemsDeletedTag & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsTag", C_Module) Then Exit Function
  End If
  
  pSaveItemsTags = True
End Function

Private Function pValidateRowProveedor(row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In row
    Select Case Cell.Key
      Case KIK_PROV_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(1349, vbNullString, strRow)
                  'Debe indicar un proveedor
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowProveedor = True
End Function

Private Function pValidateRowLeyendas(row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In row
    Select Case Cell.Key
      Case KIPRL_NOMBRE
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo C_DebeIndicarNombre
          Exit Function
        End If
      Case KIPRL_TEXTO
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(5037, vbNullString, strRow)
                    'Debe indicar una texto
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowLeyendas = True
  
End Function

Private Function pValidateRowCMI(row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In row
    Select Case Cell.Key
      Case KICMI_CMI_ID
        If ValEmpty(Cell.Id, csInteger) Then
          MsgInfo LNGGetText(5028, vbNullString, strRow)
                    'Debe indicar una comunidad
          Exit Function
        End If
      Case KICMI_CODIGO
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo C_DebeIndicarCodigo
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowCMI = True
End Function

Private Function pValidateRowWebImage(row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In row
    Select Case Cell.Key
      Case KIWI_IMAGE
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(4574, vbNullString, strRow)
                    'Debe indicar el nombre de un archivo de imagen
          Exit Function
        End If
      Case KIWI_IMAGE_TYPE
        If ValEmpty(Cell.Id, csInteger) Then
          MsgInfo LNGGetText(4575, vbNullString, strRow)
                    'Debe indicar el tipo de imagen
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowWebImage = True
End Function

Private Function pValidateRowCliente(row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In row
    Select Case Cell.Key
      Case KIK_CLI_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(1351, vbNullString, strRow)
                    'Debe indicar un cliente
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowCliente = True
End Function

Private Function pIsEmptyRowProveedor(ByRef row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In row
    Select Case Cell.Key
      Case KIK_PROV_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KIK_PROV_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KIK_PROV_CODIGO
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KIK_PROV_CODBARRA
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KIK_PA_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
        
    End Select
  Next
  
  pIsEmptyRowProveedor = bRowIsEmpty
End Function

Private Function pIsEmptyRowCliente(ByRef row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In row
    Select Case Cell.Key
      Case KIK_CLI_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KIK_CLI_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KIK_CLI_CODIGO
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KIK_CLI_CODBARRA
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowCliente = bRowIsEmpty
End Function

Private Function pIsEmptyRowLeyendas(ByRef row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In row
    Select Case Cell.Key
      Case KIPRL_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KIPRL_TEXTO
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowLeyendas = bRowIsEmpty
End Function

Private Function pIsEmptyRowCMI(ByRef row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In row
    Select Case Cell.Key
      Case KICMI_CMI_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KICMI_CODIGO
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowCMI = bRowIsEmpty
End Function

Private Function pIsEmptyRowWebImages(ByRef row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In row
    Select Case Cell.Key
      Case KIWI_IMAGE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KIWI_ALT
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowWebImages = bRowIsEmpty
End Function

Private Function pIsEmptyRowTags(ByRef row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In row
    Select Case Cell.Key
      Case KIT_TEXTO
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KIT_EXPOWEB, KIT_EXPOCAIRO
        If Not ValEmpty(Cell.Value, csInteger) Then
          If Val(Cell.Value) <> 50 Then
            bRowIsEmpty = False
            Exit For
          End If
        End If
      Case KIT_PR_ID_TAG
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowTags = bRowIsEmpty
End Function

Private Function pLoadProveedor(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim fecha   As Date
  Dim Precio  As Double
  
  sqlstmt = "sp_productoGetProveedores " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadProveedor", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
    
      .Clear
    
      With .Add(Nothing)
        .Visible = False
        .Key = KIK_PRPROV_ID
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1151, vbNullString) 'Proveedor
        .PropertyType = cspHelp
        .Table = csProveedor
        .Width = 2500
        .Key = KIK_PROV_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1356, vbNullString) 'Fabricante
        .PropertyType = cspCheck
        .Width = 100
        .Key = KIK_PROV_FABRICANTE
      End With
      
      With .Add(Nothing)
        .Name = C_strNombre
        .PropertyType = cspText
        .Width = 1000
        .Key = KIK_PROV_NOMBRE
      End With
      
      With .Add(Nothing)
        .Name = C_strCodigo
        .PropertyType = cspText
        .Width = 1000
        .Key = KIK_PROV_CODIGO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1306, vbNullString) 'Cód. Barra
        .PropertyType = cspText
        .Width = 1000
        .Key = KIK_PROV_CODBARRA
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1212, vbNullString) 'País
        .PropertyType = cspHelp
        .Table = csPais
        .Width = 2000
        .Key = KIK_PA_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2273, vbNullString) 'Lista de Precios
        .Width = 2000
        .Key = KIK_PROV_LPI_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1586, vbNullString) 'Precio
        .PropertyType = cspNumeric
        .Format = "0.000"
        .Width = 2000
        .Key = KIK_PROV_PRECIO
      End With
      
      With .Add(Nothing)
        .Key = KIK_PROV_PRECIO2
        .Visible = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1569, vbNullString) 'Fecha
        .PropertyType = cspDate
        .Width = 2000
        .Key = KIK_PROV_PRECIO_FECHA
      End With
      
      With .Add(Nothing)
        .Name = ""
        .PropertyType = cspCheck
        .Width = 500
        .Key = KIK_PROV_PRECIO_DEFAULT
      End With
      
    End With
    
    With .Rows
  
      .Clear
  
      While Not rs.EOF
      
        With .Add(Nothing)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrProvId)
            .Key = KIK_PRPROV_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscProvNombre)
            .Id = gDB.ValField(rs.fields, cscProvId)
            .Key = KIK_PROV_ID
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, cscPrProvFabricante)
            .Key = KIK_PROV_FABRICANTE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrProvNombre)
            .Key = KIK_PROV_NOMBRE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrProvCodigo)
            .Key = KIK_PROV_CODIGO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrProvCodigoBarra)
            .Key = KIK_PROV_CODBARRA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPaNombre)
            .Id = gDB.ValField(rs.fields, cscPaId)
            .Key = KIK_PA_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscLpNombre)
            .Id = gDB.ValField(rs.fields, cscLpiId)
            .Key = KIK_PROV_LPI_ID
          End With
          
          Precio = gDB.ValField(rs.fields, cscLpiPrecio)
          
          With .Add(Nothing)
            If Precio <> 0 Then
              .Value = Precio
            End If
            .Key = KIK_PROV_PRECIO
          End With
          
          With .Add(Nothing)
            If Precio <> 0 Then
              .Value = Precio
            End If
            .Key = KIK_PROV_PRECIO2
          End With
          
          fecha = gDB.ValField(rs.fields, cscLpiFecha)
          
          With .Add(Nothing)
            If fecha <> csNoDate Then
              .Value = fecha
            End If
            .Key = KIK_PROV_PRECIO_FECHA
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, "lpi_top")
            .Key = KIK_PROV_PRECIO_DEFAULT
          End With
          
        End With
        
        rs.MoveNext
        
      Wend
      
    End With
  End With
  
  pLoadProveedor = True
End Function

Private Function pLoadCliente(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_productoGetClientes " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCliente", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
    
      .Clear
    
      With .Add(Nothing)
        .Visible = False
        .Key = KIK_PRCLI_ID
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1150, vbNullString) 'Cliente
        .PropertyType = cspHelp
        .Table = csCliente
        .Width = 2500
        .Key = KIK_CLI_ID
      End With
      
      With .Add(Nothing)
        .Name = C_strNombre
        .PropertyType = cspText
        .Width = 1000
        .Key = KIK_CLI_NOMBRE
      End With
      
      With .Add(Nothing)
        .Name = C_strCodigo
        .PropertyType = cspText
        .Width = 1000
        .Key = KIK_CLI_CODIGO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1306, vbNullString)  'Cód. Barra
        .PropertyType = cspText
        .Width = 1000
        .Key = KIK_CLI_CODBARRA
      End With
            
    End With
    
    With .Rows
    
      .Clear
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscPrCliId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscPrCliId).Value
            .Key = KIK_PRCLI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCliNombre)
            .Id = gDB.ValField(rs.fields, cscCliId)
            .Key = KIK_CLI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrCliNombre)
            .Key = KIK_CLI_NOMBRE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrCliCodigo)
            .Key = KIK_CLI_CODIGO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrCliCodigoBarra)
            .Key = KIK_CLI_CODBARRA
          End With
          
        End With
        
        rs.MoveNext
        
      Wend
      
    End With
  End With
  
  pLoadCliente = True
End Function

Private Function pLoadCMI(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_ProductoGetCMI " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadBOM", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
    
      .Clear
      
      With .Add(Nothing)
        .Key = KICMI_ID
        .Visible = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(5017, vbNullString)    'Comunidad
        .PropertyType = cspHelp
        .Table = csComunidadInternet
        .Width = 2500
        .Key = KICMI_CMI_ID
      End With
      
      With .Add(Nothing)
        .Name = C_strCodigo
        .PropertyType = cspText
        .Width = 2000
        .Key = KICMI_CODIGO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1586, vbNullString) 'Precio
        .PropertyType = cspNumeric
        .Format = "0.00"
        .Width = 2000
        .Key = KICMI_PRECIO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(5026, vbNullString) 'Publicado el
        .PropertyType = cspDate
        .Width = 2000
        .Key = KICMI_FECHAALTA
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(5027, vbNullString) 'Vence el
        .PropertyType = cspDate
        .Width = 2000
        .Key = KICMI_FECHAVTO
      End With
      
      With .Add(Nothing)
        .Name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 2000
        .Key = KICMI_DESCRIP
      End With
      
    End With
    
    With .Rows
    
      .Clear
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscPrcmiId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscPrcmiId).Value
            .Key = KICMI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCmiNombre)
            .Id = gDB.ValField(rs.fields, cscCmiId)
            .Key = KICMI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrcmiCodigo)
            .Key = KICMI_CODIGO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrcmiPrecio)
            .Key = KICMI_PRECIO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrcmiFechaAlta)
            .Key = KICMI_FECHAALTA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrcmiFechaVto)
            .Key = KICMI_FECHAVTO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrcmiDescrip)
            .Key = KICMI_DESCRIP
          End With
          
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadCMI = True
End Function

Private Function pLoadLeyendas(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_ProductoGetLeyendas " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "sp_ProductoGetLeyendas", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
    
      .Clear
      
      With .Add(Nothing)
        .Key = KIPRL_ID
        .Visible = False
      End With
      
      With .Add(Nothing)
        .Name = C_strNombre
        .PropertyType = cspText
        .Width = 2500
        .Key = KIPRL_NOMBRE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(5003, vbNullString) 'Texto
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 2000
        .Key = KIPRL_TEXTO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(5036, vbNullString) 'Tag
        .PropertyType = cspText
        .Width = 2000
        .Key = KIPRL_TAG
      End With
            
      With .Add(Nothing)
        .Name = LNGGetText(5016, vbNullString) 'Orden
        .PropertyType = cspText
        .Width = 2000
        .Key = KIPRL_ORDEN
      End With
      
    End With
    
    With .Rows
    
      .Clear
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscPrlId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscPrlId).Value
            .Key = KICMI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrlNombre)
            .Key = KIPRL_NOMBRE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrlTexto)
            .Key = KIPRL_TEXTO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrlTag)
            .Key = KIPRL_TAG
          End With
                    
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrlOrden)
            .Key = KIPRL_ORDEN
          End With
                    
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadLeyendas = True
End Function

Private Function pLoadBOM(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_ProductoGetBOMs " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadBOM", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
    
      .Clear
      
      With .Add(Nothing)
        .Name = LNGGetText(1304, vbNullString)    'B.O.M.
        .Width = 2500
        .Key = KIK_PBM_ID
      End With
      
    End With
    
    With .Rows
    
      .Clear
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscPbmId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPbmNombre)
            .Id = gDB.ValField(rs.fields, cscPbmId)
            .Key = KIK_PBM_ID
          End With
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadBOM = True
End Function

Private Function pLoadTags(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim oCol    As cABMGridColumn
  Dim iCol    As cIABMGridColumn
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_ProductoGetTag " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadTags", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
    
      .Clear
    
      With .Add(Nothing)
        .Visible = False
        .Key = KIT_PRT_ID
      End With
      
      Set iCol = .Add(Nothing)
      Set oCol = iCol
      With iCol
        .Name = LNGGetText(1619, vbNullString) ' Producto
        .PropertyType = cspHelp
        .Table = csProducto
        .Width = 1000
        .Key = KIT_PR_ID_TAG
      End With
      If m_UserCfg.MultiSelect Then
        oCol.HelpType = csMultiSelect
      End If
      Set iCol = Nothing
      Set oCol = Nothing
                  
      With .Add(Nothing)
        .Name = LNGGetText(5016, vbNullString) ' Orden
        .PropertyType = cspText
        .Enabled = False
      End With
                  
      With .Add(Nothing)
        .Name = LNGGetText(3968, vbNullString) ' Texto
        .PropertyType = cspText
        .Width = 1000
        .Key = KIT_TEXTO
      End With
                  
      With .Add(Nothing)
        .Name = LNGGetText(3897, vbNullString) ' Expo Web
        .PropertyType = cspText
        .Width = 1000
        .Key = KIT_EXPOWEB
        .Format = "0"
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Value = 50
      End With
                  
      With .Add(Nothing)
        .Name = LNGGetText(3898, vbNullString) ' Expo Cairo
        .PropertyType = cspText
        .Width = 1000
        .Key = KIT_EXPOCAIRO
        .Format = "0"
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Value = 50
      End With
                        
    End With
    
    With .Rows
    
      .Clear
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscPrtId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscPrtId).Value
            .Key = KIT_PRT_ID
          End With
                   
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrNombrecompra)
            .Id = gDB.ValField(rs.fields, cscPrIdTag)
            .Key = KIT_PR_ID_TAG
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, "orden")
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrtTexto)
            .Key = KIT_TEXTO
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrtExpoWeb)
            .Key = KIT_EXPOWEB
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrtExpoCairo)
            .Key = KIT_EXPOCAIRO
          End With
                
        End With
        
        rs.MoveNext
        
      Wend
      
    End With
  End With
  
  pLoadTags = True
End Function

Private Function pLoadCategoriasWeb(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim oCol    As cABMGridColumn
  Dim iCol    As cIABMGridColumn
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_ProductoGetCatalogoCategoriasWeb " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCategoriasWeb", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
    
      .Clear
    
      With .Add(Nothing)
        .Visible = False
        .Key = KICWCI_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(4597, vbNullString) ' Categoria de Catalogo Web
        .PropertyType = cspText
        .Width = 4000
        .Key = KICWC_ID
      End With
                  
      With .Add(Nothing)
        .Name = vbNullString
        .PropertyType = cspCheck
        .Width = 600
        .Key = KICWC_SELECT
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(3268, vbNullString) 'Posición
        .PropertyType = cspNumeric
        .SubType = cspInteger
        .Key = KICWCI_POSICION
      End With
                  
    End With
    
    With .Rows
    
      .Clear
  
      While Not rs.EOF
      
        With .Add(Nothing)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCatwciId)
            .Key = KICWCI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCatwcNombre)
            .Id = gDB.ValField(rs.fields, cscCatwcId)
            .Key = KICWC_ID
          End With
        
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, cscCatwciId)
            .Key = KICWC_SELECT
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCatwciPosicion)
            .Key = KICWCI_POSICION
          End With
        
        End With
        
        rs.MoveNext
        
      Wend
      
    End With
  End With
  
  pLoadCategoriasWeb = True
End Function

Private Function pLoadCatalogosWeb(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim oCol    As cABMGridColumn
  Dim iCol    As cIABMGridColumn
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_ProductoGetCatalogosWeb " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCatalogosWeb", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
    
      .Clear
    
      With .Add(Nothing)
        .Visible = False
        .Key = KICWI_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(4598, vbNullString) ' Catalogo Web
        .PropertyType = cspText
        .Width = 2000
        .Key = KICW_ID
      End With
                  
      With .Add(Nothing)
        .Name = vbNullString
        .PropertyType = cspCheck
        .Width = 600
        .Key = KICW_SELECT
      End With
                  
    End With
    
    With .Rows
    
      .Clear
  
      While Not rs.EOF
      
        With .Add(Nothing)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCatwiId)
            .Key = KICWI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCatwNombre)
            .Id = gDB.ValField(rs.fields, cscCatwId)
            .Key = KICW_ID
          End With
        
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, cscCatwiId)
            .Key = KICW_SELECT
          End With
        
        End With
        
        rs.MoveNext
        
      Wend
      
    End With
  End With
  
  pLoadCatalogosWeb = True
End Function

Private Function pLoadWebImages(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim oCol    As cABMGridColumn
  Dim iCol    As cIABMGridColumn
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select * from ProductoWebImage where pr_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadWebImages", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
    
      .Clear
    
      With .Add(Nothing)
        .Visible = False
        .Key = KIWI_PRWI_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(4573, vbNullString) ' Imagen
        .PropertyType = cspText
        .Width = 2000
        .Key = KIWI_IMAGE
      End With
                  
      With .Add(Nothing)
        .Name = LNGGetText(1223, vbNullString) ' Tipo
        .PropertyType = cspList
        .Width = 3000
        .Key = KIWI_IMAGE_TYPE
        
        With .List
        
          With .Add(Nothing)
            .Id = csE_PrWebImageThumbnail
            .Value = LNGGetText(4572, vbNullString) ' Pequeña Principal
          End With
          
          With .Add(Nothing)
            .Id = csE_PrWebImageMedium
            .Value = LNGGetText(4571, vbNullString) ' Pequeña
          End With
          
          With .Add(Nothing)
            .Id = csE_PrWebImageBig
            .Value = LNGGetText(4570, vbNullString) ' Grande
          End With
        
        End With
        
      End With
                  
      With .Add(Nothing)
        .Name = LNGGetText(4569, vbNullString) ' Texto Alternativo
        .PropertyType = cspText
        .Width = 3000
        .Key = KIWI_ALT
      End With
                  
      With .Add(Nothing)
        .Name = LNGGetText(3268, vbNullString) ' Posición
        .PropertyType = cspNumeric
        .SubType = cspInteger
        .Width = 800
        .Key = KIWI_POSICION
      End With
                  
    End With
    
    With .Rows
    
      .Clear
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscPrwiId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscPrwiId).Value
            .Key = KIWI_PRWI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrwiArchivo)
            .Key = KIWI_IMAGE
          End With
        
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, cscPrwiTipo)
            .Key = KIWI_IMAGE_TYPE
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrwiAlt)
            .Key = KIWI_ALT
          End With
                
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrwiPosicion)
            .Key = KIWI_POSICION
          End With
                
        End With
        
        rs.MoveNext
        
      Wend
      
    End With
  End With
  
  pLoadWebImages = True
End Function

Private Function pLoadKit(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_ProductoGetKits " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadBOM", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
    
      .Clear
      
      With .Add(Nothing)
        .Name = LNGGetText(1354, vbNullString)    'Fórmula
        .Width = 2500
        .Key = KIK_PRFK_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1355, vbNullString)    'x Defecto
        .Width = 2500
        .PropertyType = cspCheck
        .Key = KIK_PRFK_DEFAULT
      End With
    
    End With
  
    With .Rows
    
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscPrfkId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrfkNombre)
            .Id = gDB.ValField(rs.fields, cscPrfkId)
            .Key = KIK_PRFK_ID
          End With
        
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, cscPrfkDefault)
            .Key = KIK_PRFK_ID
          End With
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadKit = True
End Function

Private Sub pSetKitEnabled()
  Dim bEnabled As Boolean
  Dim iProp    As cIABMProperty
  
  With m_ObjAbm.Properties
    
    bEnabled = Val(.Item(cscPrEskit).Value)
    
    If bEnabled Then
      bEnabled = .Item(cscPrKitResumido).Value
    End If
    
    Set iProp = .Item(cscPrKitIdentidad)
    iProp.Enabled = bEnabled
    m_ObjAbm.ShowValue iProp
    
  End With
  
  pSetKitSerieEnabled bEnabled

End Sub

Private Sub pSetKitSerieEnabled(ByVal bEnabled As Boolean)
  Dim iProp       As cIABMProperty
  Dim bEnabledTa  As Boolean

  With m_ObjAbm.Properties

    If bEnabled Then
    
      If Val(.Item(cscPrKitIdentidad).Value) Then
    
        Set iProp = .Item(cscPrKitIdentidadXItem)
        iProp.Enabled = True
        m_ObjAbm.ShowValue iProp
      
        bEnabledTa = Val(iProp.Value) = 0
      
        Set iProp = .Item(cscTaIdKitSerie)
        iProp.Enabled = bEnabledTa
        m_ObjAbm.ShowValue iProp
      
        Set iProp = .Item(cscPrKitLote)
        iProp.Enabled = bEnabled
        m_ObjAbm.ShowValue iProp
      
      Else
      
        Set iProp = .Item(cscPrKitIdentidadXItem)
        iProp.Enabled = False
        m_ObjAbm.ShowValue iProp
      
        Set iProp = .Item(cscTaIdKitSerie)
        iProp.Enabled = False
        m_ObjAbm.ShowValue iProp
        
        Set iProp = .Item(cscPrKitLote)
        iProp.Enabled = False
        m_ObjAbm.ShowValue iProp
        
      End If
      
    Else
    
      Set iProp = .Item(cscPrKitIdentidadXItem)
      iProp.Enabled = bEnabled
      m_ObjAbm.ShowValue iProp
      
      Set iProp = .Item(cscPrKitLoteXItem)
      iProp.Enabled = bEnabled
      m_ObjAbm.ShowValue iProp
    
      Set iProp = .Item(cscPrKitLote)
      iProp.Enabled = bEnabled
      m_ObjAbm.ShowValue iProp
    
    End If
  
  End With
  
  pSetKitLoteEnabled bEnabled

End Sub

Private Sub pSetKitLoteEnabled(ByVal bEnabled As Boolean)
  Dim iProp    As cIABMProperty
  
  With m_ObjAbm.Properties
    
    ' En esta version y de acuerdo a la documentacion
    ' vamos a soportar lote solo en aquellos kits que
    ' tienen identidad.
    '
    ' En el futuro agregaremos soporte a los kits
    ' para que incluyan lote sin tener identidad
    '
    If bEnabled Then
    
      bEnabled = Val(.Item(cscPrKitIdentidad).Value)
    
    End If
    
    If bEnabled Then
    
      If Val(.Item(cscPrKitLote).Value) Then
      
        Set iProp = .Item(cscPrKitLoteXItem)
        iProp.Enabled = True
        m_ObjAbm.ShowValue iProp
      
        bEnabled = Val(iProp.Value) = 0
        
        Set iProp = .Item(cscTaIdKitLote)
        iProp.Enabled = bEnabled
        m_ObjAbm.ShowValue iProp
        
      Else
      
        Set iProp = .Item(cscPrKitLoteXItem)
        iProp.Enabled = False
        m_ObjAbm.ShowValue iProp
        
        Set iProp = .Item(cscTaIdKitLote)
        iProp.Enabled = False
        m_ObjAbm.ShowValue iProp
      
      End If
      
    Else
    
      Set iProp = .Item(cscTaIdKitSerie)
      iProp.Enabled = bEnabled
      m_ObjAbm.ShowValue iProp
      
      Set iProp = .Item(cscTaIdKitLote)
      iProp.Enabled = bEnabled
      m_ObjAbm.ShowValue iProp
    End If
  
  End With

End Sub

Private Sub pSetKitConfig(ByVal bEsKit As Boolean, _
                          ByRef bKitStockXItem As Boolean, _
                          ByRef bKitResumido As Boolean, _
                          ByRef bKitIdentidad As Boolean, _
                          ByRef bKitIdentidadXItem As Boolean, _
                          ByRef TaIdKitSerie As Long, _
                          ByRef bKitLote As Boolean, _
                          ByRef bKitLoteXItem As Boolean, _
                          ByRef TaIdKitLote As Long)
  If bEsKit Then
  
    If bKitResumido Then
    
      If bKitIdentidad Then
      
        If bKitIdentidadXItem Then
          TaIdKitSerie = csNO_ID
        End If
        
        If bKitLote Then
          If bKitLoteXItem Then
            TaIdKitLote = csNO_ID
          End If

        Else
          bKitLoteXItem = False
          TaIdKitLote = csNO_ID
        End If
      Else
        bKitIdentidadXItem = False
        bKitLote = False
        bKitLoteXItem = False
        TaIdKitSerie = csNO_ID
        TaIdKitLote = csNO_ID
      End If
    Else
      bKitIdentidad = False
      bKitIdentidadXItem = False
      bKitLote = False
      bKitLoteXItem = False
      TaIdKitSerie = csNO_ID
      TaIdKitLote = csNO_ID
    End If
  
  Else
    
    bKitStockXItem = False
    bKitResumido = False
    bKitIdentidad = False
    bKitIdentidadXItem = False
    bKitLote = False
    bKitLoteXItem = False
    TaIdKitSerie = csNO_ID
    TaIdKitLote = csNO_ID
  End If

End Sub

Private Function pCreateFromRubro() As Boolean
  
  If pGetRubId() = csNO_ID Then Exit Function

  If Not Ask(LNGGetText(2539, vbNullString), vbYes) Then
    Exit Function
  End If
  
  Dim Nombre As String
  
  Nombre = pGetRubro().Value & RTrim$(" " & pGetMarca().Value)
  
  With m_ObjAbm.Properties
  
    If Not .Item(cscRubtiid1) Is Nothing Then
      If LCase$(pGetRubro().Value) <> LCase$(.Item(cscRubtiid1).Value) Then
        Nombre = Nombre & RTrim$(" " & .Item(cscRubtiid1).Value)
      End If
    End If
    If Not .Item(cscRubtiid2) Is Nothing Then
      Nombre = Nombre & RTrim$(" " & .Item(cscRubtiid2).Value)
    End If
    If Not .Item(cscRubtiid3) Is Nothing Then
      Nombre = Nombre & RTrim$(" " & .Item(cscRubtiid3).Value)
    End If
    If Not .Item(cscRubtiid4) Is Nothing Then
      Nombre = Nombre & RTrim$(" " & .Item(cscRubtiid4).Value)
    End If
    If Not .Item(cscRubtiid5) Is Nothing Then
      Nombre = Nombre & RTrim$(" " & .Item(cscRubtiid5).Value)
    End If
    If Not .Item(cscRubtiid6) Is Nothing Then
      Nombre = Nombre & RTrim$(" " & .Item(cscRubtiid6).Value)
    End If
    If Not .Item(cscRubtiid7) Is Nothing Then
      Nombre = Nombre & RTrim$(" " & .Item(cscRubtiid7).Value)
    End If
    If Not .Item(cscRubtiid8) Is Nothing Then
      Nombre = Nombre & RTrim$(" " & .Item(cscRubtiid8).Value)
    End If
    If Not .Item(cscRubtiid9) Is Nothing Then
      Nombre = Nombre & RTrim$(" " & .Item(cscRubtiid9).Value)
    End If
    If Not .Item(cscRubtiid10) Is Nothing Then
      Nombre = Nombre & RTrim$(" " & .Item(cscRubtiid10).Value)
    End If
  
    .Item(cscPrNombrecompra).Value = Nombre
    m_ObjAbm.ShowValue .Item(cscPrNombrecompra)
  
    If LenB(.Item(cscPrNombreventa).Value) = 0 Then
      .Item(cscPrNombreventa).Value = Nombre
      m_ObjAbm.ShowValue .Item(cscPrNombreventa)
    End If
  
  End With
  
  pCreateFromRubro = True
End Function

Private Function pGetRubId() As Long
  pGetRubId = pGetRubro().HelpId
End Function

Private Function pGetRubro() As cIABMProperty
  Set pGetRubro = m_ObjAbm.Properties(cscRubId)
End Function

Private Function pGetMarca() As cIABMProperty
  Set pGetMarca = m_ObjAbm.Properties(cscMarcId)
End Function

Private Function pGetTags() As cIABMProperty
  Set pGetTags = m_ObjAbm.Properties(c_TAGS)
End Function

Private Function pSaveNombres(ByVal Pr_id As Long) As Boolean
  Dim sqlstmt As String
  sqlstmt = "sp_ProductoSaveNombres " & gDB.UserId & "," & Pr_id
  pSaveNombres = gDB.Execute(sqlstmt)
End Function

Private Sub pEditLP(ByVal lpi_id As Long)
  On Error GoTo ControlError
  
  Dim lp_id As Long
  
  If Not gDB.GetData(csTListaPrecioItem, cscLpiId, lpi_id, cscLpId, lp_id) Then Exit Sub
  
  Dim Obj As cIEditGeneric
  Set Obj = CSKernelClient2.CreateObject("CSArticulo.cListaPrecio")
  Set Obj.ObjAbm = New cABMGeneric
  
  Obj.Edit lp_id
  
  GoTo ExitProc
ControlError:
  MngError Err, "pEditLP", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

'-------------------------------------------
' Si la fila tiene datos en alguna columna
' es del usuario
' Sino es del sistema y no se guarda
'
Private Function pIsRowProveedorFromUser(ByRef row As cIABMGridRow) As Boolean

  pIsRowProveedorFromUser = True

  If Val(pCell(row, KIK_PRPROV_ID).Value) >= 0 Then Exit Function
  If LenB(pCell(row, KIK_PROV_FABRICANTE).Value) Then Exit Function
  If LenB(pCell(row, KIK_PROV_NOMBRE).Value) Then Exit Function
  If LenB(pCell(row, KIK_PROV_CODIGO).Value) Then Exit Function
  If LenB(pCell(row, KIK_PROV_CODBARRA).Value) Then Exit Function
  If pCell(row, KIK_PA_ID).Id Then Exit Function

  pIsRowProveedorFromUser = False

End Function
