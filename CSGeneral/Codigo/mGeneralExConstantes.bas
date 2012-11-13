Attribute VB_Name = "mGeneralConstantes"
Option Explicit

'--------------------------------------------------------------------------------
' mGeneralConstantes
' 05-01-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Public Const c_doctId         As Long = -1111
Public Const c_compId         As Long = -1110

Public Const c_MainIniFile = "Cairo.ini"
Public Const c_K_MainIniConfig = "CONFIG"

' Rama
Public Const cscRamNombre                       As String = "ram_nombre"
Public Const cscCliCatfiscal                    As String = "cli_catfiscal"

Public Const cscPrTiIdRiCompra                       As String = "ti_id_ivariCompra"
Public Const cscPrTiIdRniCompra                      As String = "ti_id_ivarniCompra"
Public Const cscPrTiIdRiVenta                        As String = "ti_id_ivariventa"
Public Const cscPrTiIdRniVenta                       As String = "ti_id_ivarniventa"

Public Const cscPrTiIdInternosC                      As String = "ti_id_internosc"
Public Const cscPrTiIdInternosV                      As String = "ti_id_internosv"
Public Const cscPrPorcInternoC                       As String = "pr_porcinternoc"
Public Const cscPrPorcInternoV                       As String = "pr_porcinternov"

' Condicion de Pago
Public Const csTCondicionPago                         As String = "CondicionPago"
Public Const cscCpgId                                 As String = "cpg_id"
Public Const cscCpgNombre                             As String = "cpg_nombre"

' Cuenta Grupo
Public Const csTCuentaGrupo                            As String = "CuentaGrupo"
Public Const cscCuegId                                 As String = "cueg_id"
Public Const cscCuegTipo                               As String = "cueg_tipo"

' Cuenta
Public Const csTCuenta                           As String = "Cuenta"
Public Const cscCueId                            As String = "cue_id"
Public Const cscCueNombre                        As String = "cue_nombre"

' Banco
Public Const cscBcoId                            As String = "bco_id"

' Barco
Public Const cscBarcId                           As String = "barc_id"

' Tipos de documento
Public Const cscDoctId                                As String = "doct_id"

' Documentos
Public Const csTDocumento                             As String = "Documento"
Public Const cscDocId                                 As String = "doc_id"
Public Const cscDocNombre                             As String = "doc_nombre"
Public Const cscPreIdNew                              As String = "pre_id_new"
Public Const cscPreIdEdit                             As String = "pre_id_edit"
Public Const cscPreIdDelete                           As String = "pre_id_delete"
Public Const cscPreIdList                             As String = "pre_id_list"
Public Const cscPreIdAnular                           As String = "pre_id_anular"
Public Const cscPreIdDesAnular                        As String = "pre_id_desanular"
Public Const cscPreIdAplicar                          As String = "pre_id_aplicar"
Public Const cscPreIdPrint                            As String = "pre_id_print"


' Chequera
Public Const cscChqNumerodesde                        As String = "chq_numerodesde"
Public Const cscChqNumerohasta                        As String = "chq_numerohasta"
Public Const cscChqUltimonumero                       As String = "chq_ultimonumero"

'CuentaCategoria
Public Const cscCuecId                           As String = "cuec_id"

' Monedas
Public Const cscMonId                            As String = "mon_id"
Public Const cscMonNombre                        As String = "mon_nombre"

' Moneda Item
Public Const cscMoniPrecio                             As String = "moni_precio"

' Pais
Public Const csTPais                                 As String = "Pais"
Public Const cscPaId                                 As String = "pa_id"
Public Const cscPaNombre                             As String = "pa_Nombre"

'Producto
Public Const csTProducto                             As String = "Producto"
Public Const cscPrId                                 As String = "pr_id"
Public Const cscPrNombreventa                        As String = "pr_nombreventa"
Public Const cscPrNombreCompra                       As String = "pr_nombrecompra"

' Depositos Logicos
Public Const csTDepositoLogico                       As String = "DepositoLogico"
Public Const cscDeplId                               As String = "depl_id"
Public Const cscDepfId                               As String = "depf_id"

' Lista de Precios
Public Const csTListaPrecio                          As String = "ListaPrecio"
Public Const cscLpId                                 As String = "lp_id"
Public Const cscLpNombre                             As String = "lp_nombre"

' Lista de Descuentos
Public Const csTListaDescuento                        As String = "ListaDescuento"
Public Const cscLdId                                  As String = "ld_id"

' Cliente
Public Const csTCliente                                As String = "Cliente"
Public Const cscCliId                                  As String = "cli_id"
Public Const cscCliNombre                              As String = "cli_nombre"
Public Const cscCliRazonsocial                         As String = "cli_razonsocial"
Public Const cscCliCodigo                              As String = "cli_codigo"
Public Const cscCliCalle                               As String = "cli_calle"
Public Const cscCliCuit                                As String = "cli_cuit"
Public Const cscCliCallenumero                         As String = "cli_callenumero"
Public Const cscCliPiso                                As String = "cli_piso"
Public Const cscCliDepto                               As String = "cli_depto"
Public Const cscCliCodpostal                           As String = "cli_codpostal"
Public Const cscCliLocalidad                           As String = "cli_localidad"
Public Const cscCliTel                                 As String = "cli_tel"
Public Const cscCliEmail                               As String = "cli_email"
Public Const cscCliDescrip                             As String = "cli_descrip"
Public Const cscCliEsProspecto                         As String = "cli_esprospecto"
Public Const cscCliContacto                            As String = "cli_contacto"
Public Const cscCliHorarioMdesde                       As String = "cli_horario_m_desde"
Public Const cscCliHorarioMhasta                       As String = "cli_horario_m_hasta"
Public Const cscCliHorarioTdesde                       As String = "cli_horario_t_desde"
Public Const cscCliHorarioThasta                       As String = "cli_horario_t_hasta"

' Proveedor
Public Const csTProveedor                              As String = "Proveedor"
Public Const cscProvId                                 As String = "prov_id"
Public Const cscProvEmail                              As String = "prov_email"

' Sucursal
Public Const cscSucId                                  As String = "suc_id"

' Vendedor
Public Const cscVenId                                  As String = "ven_id"
Public Const cscVenNombre                              As String = "ven_nombre"

' Producto Numero Serie
Public Const csTProductoNumeroSerie                    As String = "ProductoNumeroSerie"
Public Const cscPrnsId                                 As String = "prns_id"
Public Const cscPrnsCodigo                             As String = "prns_codigo"
Public Const cscPrnsCodigo2                            As String = "prns_codigo2"
Public Const cscPrnsCodigo3                            As String = "prns_codigo3"
Public Const cscPrnsDescrip                            As String = "prns_descrip"
Public Const cscPrnsFechaVto                           As String = "prns_fechavto"

' Factura venta
Public Const cscFvNrodoc                        As String = "fv_nrodoc"
Public Const cscFvCai                           As String = "fv_cai"

' Factura compra
Public Const cscFcNrodoc                        As String = "fc_nrodoc"

' Talonario
Public Const cscTaId                            As String = "ta_id"

' Estado
Public Const csTEstado                                As String = "Estado"
Public Const cscEstId                                 As String = "est_id"
Public Const cscEstNombre                             As String = "est_nombre"

' DocumentoTipo
Public Const cscDoctNombre                            As String = "doct_nombre"
Public Const cscDoctObject                            As String = "doct_object"

Public Const c_FechaIni           As String = "FechaIni"
Public Const c_FechaFin           As String = "FechaFin"

Public Enum csEDocSearcFieldEnum
  csEDocFieldNumero = 1
  csEDocFieldComprobante = 2
  csEDocFieldTotal = 4
  csEDocFieldObservaciones = 8
  csEDocFieldCodigo = 16
  csEDocFieldCodigo2 = 32
  csEDocFieldCodigo3 = 64
  csEDocFieldCodigo4 = 128
  csEDocFieldContacto = 256
End Enum

Public Const c_FieldNumero          As String = "Numero"
Public Const c_FieldComprobante     As String = "Comprobante"
Public Const c_FieldTotal           As String = "Total"
Public Const c_FieldObservaciones   As String = "Observaciones"

Public Const c_FieldCodigo          As String = "Codigo"
Public Const c_FieldCodigo2         As String = "Codigo2"
Public Const c_FieldCodigo3         As String = "Codigo3"
Public Const c_FieldCodigo4         As String = "Codigo4"
Public Const c_FieldContacto        As String = "Contacto"

' Claves de configuracion General de stock
Public Const c_GrupoGeneral = "Stock-General"
Public Const c_TipoControlStock = "Tipo Control Stock"
Public Const c_NoControlaStock = "No Controla Stock"
Public Const c_StockLogico = "Stock Por Deposito Logico"
Public Const c_StockFisico = "Stock Por Deposito Fisico"
Public Const c_StockNegativo = "Stock Negativo"
Public Const c_SpStock = "SP Stock"
Public Const c_StockPedidoVta = "Stock en Pedido de Venta"

Public Const c_StockCodBarraSubir = "Código de barra para subir"
Public Const c_StockCodBarraBajar = "Código de barra para bajar"
Public Const c_StockCodBarraTipo = "Tipo de prefijo del código de barra"
Public Const c_StockCodBarraLongitud = "Longitud del prefijo del código de barra"
Public Const c_StockCodBarraCaracter = "Caracter separador del código de barra"

' Retencion
Public Const csTRetencion                        As String = "Retencion"
Public Const cscRetId                            As String = "ret_id"
Public Const cscRetNombre                        As String = "ret_nombre"

' Transporte
Public Const cscTransId                          As String = "trans_id"
Public Const cscTransNombre                      As String = "trans_nombre"

' Provincia
Public Const csTProvincia                        As String = "Provincia"
Public Const cscProId                            As String = "pro_id"
Public Const cscProNombre                        As String = "pro_nombre"

' Zona
Public Const csTZona                            As String = "Zona"
Public Const cscZonId                           As String = "zon_id"
Public Const cscZonNombre                       As String = "zon_nombre"

' StockLote
Public Const csTStockLote                        As String = "StockLote"
Public Const cscStlId                            As String = "stl_id"
Public Const cscStlCodigo                        As String = "stl_codigo"
Public Const cscStlNroLote                       As String = "stl_nroLote"
Public Const cscStlFecha                         As String = "stl_fecha"
Public Const cscStlFechaVto                      As String = "stl_fechaVto"
Public Const cscStlDescrip                       As String = "stl_descrip"
Public Const cscStlIdPadre                       As String = "stl_id_padre"
Public Const cscStlCodigo2                       As String = "stl_codigo2"

' GridView
Public Const csTGridView                               As String = "GridView"
Public Const cscGrdvId                                 As String = "grdv_id"
Public Const cscGrdvNombre                             As String = "grdv_nombre"
Public Const cscGrdvDefault                            As String = "grdv_default"
Public Const cscGrdvPublica                            As String = "grdv_publica"
Public Const cscGrdvAutowidth                          As String = "grdv_autowidth"
Public Const cscGridName                               As String = "grid_name"
Public Const cscRptId                                  As String = "rpt_id"

' Lenguaje
Public Const csTLenguaje                         As String = "Lenguaje"
Public Const cscLengId                           As String = "leng_id"
Public Const cscLengNombre                       As String = "leng_nombre"

' Tabla
Public Const cscTblobjectEdit                         As String = "tbl_objectEdit"
Public Const cscTblobjectABM                          As String = "tbl_objectABM"

' Proyecto
Public Const csTProyecto                         As String = "Proyecto"
Public Const cscProyId                           As String = "proy_id"
Public Const cscProyNombre                       As String = "proy_nombre"

' Empresa Cliente
Public Const csTEmpresaCliente                        As String = "EmpresaCliente"
Public Const cscEmpCliId                              As String = "empcli_id"

' Tabla Item
Public Const csTTablaItem                              As String = "TablaItem"
Public Const cscTbliId                                 As String = "tbli_id"
Public Const cscTbliNombre                             As String = "tbli_nombre"
Public Const cscTbliNombreFisico                       As String = "tbli_nombrefisico"
Public Const cscTbliTipo                               As String = "tbli_tipo"
Public Const cscTbliSubTipo                            As String = "tbli_subtipo"
Public Const cscTbliOrden                              As String = "tbli_orden"
Public Const cscTbliHelpType                           As String = "tbli_helptype"
Public Const cscTbliFiltro                             As String = "tbli_filtro"
Public Const cscTbliDefaultValue                       As String = "tbli_defaultvalue"
Public Const cscTbliMinValue                           As String = "tbli_minvalue"
Public Const cscTbliMaxValue                           As String = "tbli_maxvalue"
Public Const cscTbliTextAlign                          As String = "tbli_textalign"
Public Const cscTbliTextMask                           As String = "tbli_textmask"
Public Const cscTbliFormat                             As String = "tbli_format"
Public Const cscTbliWidth                              As String = "tbli_width"
Public Const cscTbliHeight                             As String = "tbli_height"
Public Const cscTbliTop                                As String = "tbli_top"
Public Const cscTbliLeft                               As String = "tbli_left"
Public Const cscTbliNoShowButton                       As String = "tbli_noshowbutton"
Public Const cscTbliSqlstmt                            As String = "tbli_sqlstmt"
Public Const cscTblIdHelp                              As String = "tbl_id_help"

' Tabla
Public Const csTTabla                                 As String = "Tabla"
Public Const cscTblId                                 As String = "tbl_id"
Public Const cscTblNombre                             As String = "tbl_nombre"
Public Const cscTblNombreFisico                       As String = "tbl_nombrefisico"
Public Const cscTblCampoNombre                        As String = "tbl_camponombre"
Public Const cscTblCampoId                            As String = "tbl_campoid"

' Codigos Postales
Public Const cscCpaId                                   As String = "cpa_id"
Public Const cscCpaCodigo                               As String = "cpa_codigo"

