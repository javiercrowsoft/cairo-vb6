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
Private Const C_Module = "mGeneralConstantes"

Public Const c_TiFilterVenta = "ti_tipo = 1"
Public Const c_TiFilterCompra = "ti_tipo = 2"

' Provincia
Public Const csTProvincia                       As String = "Provincia"
Public Const cscProId                           As String = "pro_id"
Public Const cscProNombre                       As String = "pro_nombre"
Public Const cscProCodigo                       As String = "pro_codigo"
Public Const cscProDescrip                      As String = "pro_descrip"

' Unidad
Public Const csTUnidad                          As String = "Unidad"
Public Const cscUnId                            As String = "un_id"
Public Const cscUnNombre                        As String = "un_nombre"
Public Const cscUnCodigo                        As String = "un_codigo"

'DepositoFisico
Public Const csTDepositoFisico                  As String = "DepositoFisico"
Public Const cscDepfId                          As String = "depf_id"
Public Const cscDepfNombre                      As String = "depf_nombre"
Public Const cscDepfCodigo                      As String = "depf_codigo"
Public Const cscDepfDescrip                     As String = "depf_descrip"
Public Const cscDepfTel                         As String = "depf_tel"
Public Const cscDepfDir                         As String = "depf_dir"

' DepositoLogico
Public Const csTDepositoLogico                  As String = "DepositoLogico"
Public Const cscDeplId                          As String = "depl_id"
Public Const cscDeplNombre                      As String = "depl_nombre"
Public Const cscDeplCodigo                      As String = "depl_codigo"
Public Const cscDeplDescrip                     As String = "depl_descrip"
Public Const cscDeplEsTemp                      As String = "depl_estemp"

' Zona
Public Const csTZona                            As String = "Zona"
Public Const cscZonId                           As String = "zon_id"
Public Const cscZonNombre                       As String = "zon_nombre"
Public Const cscZonCodigo                       As String = "zon_codigo"
Public Const cscZonDescrip                      As String = "zon_descrip"
Public Const cscZonPrecio                       As String = "zon_precio"

' TasaImpositiva
Public Const csTTasaImpositiva                  As String = "TasaImpositiva"
Public Const cscTiId                            As String = "ti_id"
Public Const cscTiNombre                        As String = "ti_nombre"
Public Const cscTiCodigo                        As String = "ti_codigo"
Public Const cscTiPorcentaje                    As String = "ti_porcentaje"
Public Const cscTiCodigoDGI1                    As String = "ti_codigoDGI1"
Public Const cscTiCodigoDGI2                    As String = "ti_codigoDGI2"
Public Const cscTiTipo                          As String = "ti_tipo"

' SucursalCliente
Public Const csTClienteSucursal                        As String = "ClienteSucursal"
Public Const cscclisId                                 As String = "clis_id"
Public Const cscclisNombre                             As String = "clis_nombre"
Public Const cscclisCodigo                             As String = "clis_codigo"
Public Const cscclisDescrip                            As String = "clis_descrip"
Public Const cscclisLocalidad                          As String = "clis_localidad"
Public Const cscclisCalle                              As String = "clis_calle"
Public Const cscclisCallenumero                        As String = "clis_callenumero"
Public Const cscclisPiso                               As String = "clis_piso"
Public Const cscclisDepto                              As String = "clis_depto"
Public Const cscclisTel                                As String = "clis_tel"
Public Const cscclisFax                                As String = "clis_fax"
Public Const cscclisEmail                              As String = "clis_email"
Public Const cscclisCodPostal                          As String = "clis_codpostal"
Public Const cscclisContacto                           As String = "clis_contacto"

' Banco
Public Const csTBanco                            As String = "Banco"
Public Const cscBcoId                            As String = "bco_id"
Public Const cscBcoNombre                        As String = "bco_nombre"
Public Const cscBcoCodigo                        As String = "bco_codigo"
Public Const cscBcoContacto                      As String = "bco_contacto"
Public Const cscBcoTelefono                      As String = "bco_telefono"
Public Const cscBcoDireccion                     As String = "bco_direccion"
Public Const cscBcoWeb                           As String = "bco_web"
Public Const cscBcoMail                          As String = "bco_mail"

' Vendedor
Public Const csTVendedor                         As String = "Vendedor"
Public Const cscVenId                            As String = "ven_id"
Public Const cscVenNombre                        As String = "ven_nombre"
Public Const cscVenDescrip                       As String = "ven_descrip"
Public Const cscVenCodigo                        As String = "ven_codigo"

' TarjetaCredito
Public Const csTTarjetaCredito                   As String = "TarjetaCredito"
Public Const cscTjcId                            As String = "tjc_id"
Public Const cscTjcNombre                        As String = "tjc_nombre"
Public Const cscTjcCodigo                        As String = "tjc_codigo"
Public Const cscTjcDescrip                       As String = "tjc_descrip"
Public Const cscTjcComision                      As String = "tjc_comision"
Public Const cscCueIdEnCartera                   As String = "cue_id_encartera"
Public Const cscCueIdBanco                       As String = "cue_id_banco"
Public Const cscCueIdPresentado                  As String = "cue_id_presentado"
Public Const cscCueIdRechazo                     As String = "cue_id_rechazo"
Public Const cscCueIdComision                    As String = "cue_id_comision"

' TarjetaCreditoCuota
Public Const csTTarjetaCreditoCuota              As String = "TarjetaCreditoCuota"
Public Const cscTjccuId                          As String = "tjccu_id"
Public Const cscTjccuCantidad                    As String = "tjccu_cantidad"
Public Const cscTjccuComision                    As String = "tjccu_comision"

' Cuenta
Public Const csTCuenta                           As String = "Cuenta"
Public Const cscCueId                            As String = "cue_id"
Public Const cscCueNombre                        As String = "cue_nombre"
Public Const cscCueCodigo                        As String = "cue_codigo"
Public Const cscCueDescrip                       As String = "cue_descrip"
Public Const cscCueLlevaCentroCosto              As String = "cue_llevacentrocosto"
Public Const cscCueIdentificacionExterna         As String = "cue_identificacionexterna"
Public Const cscCueProducto                      As String = "cue_producto"
Public Const cscCueCodigoRPT                     As String = "cue_codigorpt"
Public Const cscCueEsEfectivo                    As String = "cue_esefectivo"
Public Const cscCueEsTicket                      As String = "cue_esticket"

' Cuenta Grupo
Public Const csTCuentaGrupo                            As String = "CuentaGrupo"
Public Const cscCuegId                                 As String = "cueg_id"
Public Const cscCuegNombre                             As String = "cueg_nombre"
Public Const cscCuegCodigo                             As String = "cueg_codigo"
Public Const cscCuegDescrip                            As String = "cueg_descrip"
Public Const cscCuegTipo                               As String = "cueg_tipo"

' Cuenta Grupo Cliente
Public Const csTClienteCuentaGrupo                    As String = "ClienteCuentaGrupo"
Public Const cscCliCuegId                             As String = "clicueg_id"

' Cuenta Grupo Proveedor
Public Const csTProveedorCuentaGrupo                  As String = "ProveedorCuentaGrupo"
Public Const cscProvCuegId                            As String = "provcueg_id"

' Percepcion Cliente
Public Const csTClientePercepcion                     As String = "ClientePercepcion"
Public Const cscCliPercId                             As String = "cliperc_id"
Public Const cscCliPercDesde                          As String = "cliperc_desde"
Public Const cscCliPercHasta                          As String = "cliperc_hasta"

' Retencion Proveedor
Public Const csTProveedorRetencion                    As String = "ProveedorRetencion"
Public Const cscProvRetId                             As String = "provret_id"
Public Const cscProvRetDesde                          As String = "provret_desde"
Public Const cscProvRetHasta                          As String = "provret_hasta"

'CuentaCategoria
Public Const csTCuentaCategoria                  As String = "CuentaCategoria"
Public Const cscCuecId                           As String = "cuec_id"
Public Const cscCuecNombre                       As String = "cuec_nombre"
Public Const cscCuecCodigo                       As String = "cuec_codigo"
Public Const cscCuecDescrip                      As String = "cuec_descrip"
Public Const cscCuecTipo                         As String = "cuec_tipo"

' Leyenda
Public Const csTLeyenda                          As String = "Leyenda"
Public Const cscLeyId                            As String = "ley_id"
Public Const cscLeyNombre                        As String = "ley_nombre"
Public Const cscLeyCodigo                        As String = "ley_codigo"
Public Const cscLeyDescrip                       As String = "ley_descrip"
Public Const cscLeytexto                         As String = "ley_texto"

' CentroCosto
Public Const csTCentroCosto                      As String = "CentroCosto"
Public Const cscCcosId                           As String = "ccos_id"
Public Const cscCcosNombre                       As String = "ccos_nombre"
Public Const cscCcosCodigo                       As String = "ccos_codigo"
Public Const cscCcosDescrip                      As String = "ccos_descrip"
Public Const cscCcosCompra                       As String = "ccos_compra"
Public Const cscCcosVenta                        As String = "ccos_venta"
Public Const cscCcosIdPadre                      As String = "ccos_id_padre"

'Cobrador
Public Const csTCobrador                         As String = "Cobrador"
Public Const cscCobId                            As String = "cob_id"
Public Const cscCobNombre                        As String = "cob_nombre"
Public Const cscCobCodigo                        As String = "cob_codigo"
Public Const cscCobDescrip                       As String = "cob_descrip"
Public Const cscCobComision                      As String = "cob_comision"

'ReglaLiquidacion
Public Const csTReglaLiquidacion                 As String = "ReglaLiquidacion"
Public Const cscRelId                            As String = "rel_id"
Public Const cscRelNombre                        As String = "rel_nombre"
Public Const cscRelCodigo                        As String = "rel_codigo"
Public Const cscRelDescrip                       As String = "rel_descrip"

'Clearing
Public Const csTClearing                         As String = "Clearing"
Public Const cscCleId                            As String = "cle_id"
Public Const cscCleNombre                        As String = "cle_nombre"
Public Const cscCleCodigo                        As String = "cle_codigo"
Public Const cscCleDescrip                       As String = "cle_descrip"
Public Const cscCleDias                          As String = "cle_dias"

'Cliente
Public Const csTCliente                                As String = "Cliente"
Public Const cscCliId                                  As String = "cli_id"
Public Const cscCliNombre                              As String = "cli_nombre"
Public Const cscCliCodigo                              As String = "cli_codigo"
Public Const cscCliDescrip                             As String = "cli_descrip"
Public Const cscCliContacto                            As String = "cli_contacto"
Public Const cscCliRazonsocial                         As String = "cli_razonsocial"
Public Const cscCliCuit                                As String = "cli_cuit"
Public Const cscCliIngresosbrutos                      As String = "cli_ingresosbrutos"
Public Const cscCliCatfiscal                           As String = "cli_catfiscal"
Public Const cscCliChequeorden                         As String = "cli_chequeorden"
Public Const cscCliCodpostal                           As String = "cli_codpostal"
Public Const cscCliLocalidad                           As String = "cli_localidad"
Public Const cscCliCalle                               As String = "cli_calle"
Public Const cscCliCallenumero                         As String = "cli_callenumero"
Public Const cscCliPiso                                As String = "cli_piso"
Public Const cscCliDepto                               As String = "cli_depto"
Public Const cscCliTel                                 As String = "cli_tel"
Public Const cscCliFax                                 As String = "cli_fax"
Public Const cscCliEmail                               As String = "cli_email"
Public Const cscCliWeb                                 As String = "cli_web"
Public Const cscCliYahoo                               As String = "cli_yahoo"
Public Const cscCliMessanger                           As String = "cli_messanger"
Public Const cscCliCreditoctacte                       As String = "cli_creditoctacte"
Public Const cscCliCreditototal                        As String = "cli_creditototal"
Public Const cscCliCreditoactivo                       As String = "cli_creditoactivo"
Public Const cscCliExigeTransporte                     As String = "cli_exigeTransporte"
Public Const cscCliExigeProvincia                      As String = "cli_exigeProvincia"
Public Const cscCliPciaTransporte                      As String = "cli_pciaTransporte"
Public Const cscCliIdPadre                             As String = "cli_id_padre"
Public Const cscCliNombrePadre                         As String = "cli_nombrePadre"
Public Const cscCliEsProspecto                         As String = "cli_esprospecto"
Public Const cscCliIdReferido                          As String = "cli_id_referido"
Public Const cscCliHorarioMdesde                       As String = "cli_horario_m_desde"
Public Const cscCliHorarioMhasta                       As String = "cli_horario_m_hasta"
Public Const cscCliHorarioTdesde                       As String = "cli_horario_t_desde"
Public Const cscCliHorarioThasta                       As String = "cli_horario_t_hasta"

'Proveedor
Public Const csTProveedor                              As String = "Proveedor"
Public Const cscProvId                                 As String = "prov_id"
Public Const cscProvNombre                             As String = "prov_nombre"
Public Const cscProvDescrip                            As String = "prov_descrip"
Public Const cscProvCodigo                             As String = "prov_codigo"
Public Const cscProvContacto                           As String = "prov_contacto"
Public Const cscProvRazonsocial                        As String = "prov_razonsocial"
Public Const cscProvCuit                               As String = "prov_cuit"
Public Const cscProvIngresosbrutos                     As String = "prov_ingresosbrutos"
Public Const cscProvCatfiscal                          As String = "prov_catfiscal"
Public Const cscProvChequeorden                        As String = "prov_chequeorden"
Public Const cscProvCodpostal                          As String = "prov_codpostal"
Public Const cscProvLocalidad                          As String = "prov_localidad"
Public Const cscProvCalle                              As String = "prov_calle"
Public Const cscProvCallenumero                        As String = "prov_callenumero"
Public Const cscProvPiso                               As String = "prov_piso"
Public Const cscProvDepto                              As String = "prov_depto"
Public Const cscProvTel                                As String = "prov_tel"
Public Const cscProvFax                                As String = "prov_fax"
Public Const cscProvEmail                              As String = "prov_email"
Public Const cscProvWeb                                As String = "prov_web"
Public Const cscProvImprimeTicket                      As String = "prov_imprimeticket"
Public Const cscProvCreditoctacte                      As String = "prov_creditoctacte"
Public Const cscProvCreditototal                       As String = "prov_creditototal"
Public Const cscProvCreditoactivo                      As String = "prov_creditoactivo"

Public Const cscProvBanco                              As String = "prov_banco"
Public Const cscProvNroCtaBanco                        As String = "prov_nroctabanco"
Public Const cscProvCBU                                As String = "prov_cbu"
Public Const cscProvNroCliente                         As String = "prov_nrocliente"

Public Const cscProvHorarioMdesde                       As String = "prov_horario_m_desde"
Public Const cscProvHorarioMhasta                       As String = "prov_horario_m_hasta"
Public Const cscProvHorarioTdesde                       As String = "prov_horario_t_desde"
Public Const cscProvHorarioThasta                       As String = "prov_horario_t_hasta"

'Ingresos brutos categoria
Public Const csTIngresosBrutosCategoria               As String = "IngresosBrutosCategoria"
Public Const cscIbcId                                 As String = "ibc_id"
Public Const cscIbcNombre                             As String = "ibc_nombre"
Public Const cscIbcCodigo                             As String = "ibc_codigo"
Public Const cscIbcDescrip                            As String = "ibc_descrip"

'Rubro
Public Const csTRubro                                 As String = "Rubro"
Public Const cscRubId                                 As String = "rub_id"
Public Const cscRubNombre                             As String = "rub_nombre"
Public Const cscRubCodigo                             As String = "rub_codigo"
Public Const cscRubDescrip                            As String = "rub_descrip"
Public Const cscRubEsCriterio                         As String = "rub_escriterio"

Public Const cscRubtid1                               As String = "rubt_id1"
Public Const cscRubtid2                               As String = "rubt_id2"
Public Const cscRubtid3                               As String = "rubt_id3"
Public Const cscRubtid4                               As String = "rubt_id4"
Public Const cscRubtid5                               As String = "rubt_id5"
Public Const cscRubtid6                               As String = "rubt_id6"
Public Const cscRubtid7                               As String = "rubt_id7"
Public Const cscRubtid8                               As String = "rubt_id8"
Public Const cscRubtid9                               As String = "rubt_id9"
Public Const cscRubtid10                              As String = "rubt_id10"

Public Const cscRubtiid1                               As String = "rubti_id1"
Public Const cscRubtiid2                               As String = "rubti_id2"
Public Const cscRubtiid3                               As String = "rubti_id3"
Public Const cscRubtiid4                               As String = "rubti_id4"
Public Const cscRubtiid5                               As String = "rubti_id5"
Public Const cscRubtiid6                               As String = "rubti_id6"
Public Const cscRubtiid7                               As String = "rubti_id7"
Public Const cscRubtiid8                               As String = "rubti_id8"
Public Const cscRubtiid9                               As String = "rubti_id9"
Public Const cscRubtiid10                              As String = "rubti_id10"

' Escala
Public Const csTEscala                                As String = "Escala"
Public Const cscEscId                                 As String = "esc_id"
Public Const cscEscNombre                             As String = "esc_nombre"
Public Const cscEscCodigo                             As String = "esc_codigo"

' Transporte
Public Const csTTransporte                              As String = "Transporte"
Public Const cscTransId                                 As String = "trans_id"
Public Const cscTransNombre                             As String = "trans_nombre"
Public Const cscTransCodigo                             As String = "trans_codigo"
Public Const cscTransDescrip                            As String = "trans_descrip"
Public Const cscTransTelefono                           As String = "trans_telefono"
Public Const cscTransDireccion                          As String = "trans_direccion"
Public Const cscTransMail                               As String = "trans_mail"
Public Const cscTransWeb                                As String = "trans_web"

Public Const cscTransHorarioMdesde                       As String = "trans_horario_m_desde"
Public Const cscTransHorarioMhasta                       As String = "trans_horario_m_hasta"
Public Const cscTransHorarioTdesde                       As String = "trans_horario_t_desde"
Public Const cscTransHorarioThasta                       As String = "trans_horario_t_hasta"

' Lista de Precios
Public Const csTListaPrecio                          As String = "ListaPrecio"
Public Const cscLpId                                 As String = "lp_id"
Public Const cscLpNombre                             As String = "lp_nombre"

'Lista de Precios Items
Public Const csTListaPrecioItem                       As String = "ListaPrecioItem"
Public Const cscLpiId                                 As String = "lpi_id"
Public Const cscLpiPrecio                             As String = "lpi_precio"
Public Const cscLpiPorcentaje                         As String = "lpi_porcentaje"
Public Const cscLpiFecha                              As String = "lpi_fecha"

' Lista de Descuentos
Public Const csTListaDescuento                        As String = "ListaDescuento"
Public Const cscLdId                                  As String = "ld_id"
Public Const cscLdNombre                              As String = "ld_nombre"

' Lista de Precios Clientes
Public Const csTListaPrecioCliente                    As String = "ListaPrecioCliente"
Public Const cscLpCliId                               As String = "lpcli_id"

Public Const csTListaPrecioProveedor                  As String = "ListaPrecioProveedor"
Public Const cscLpProvId                              As String = "lpprov_id"

' Lista de Descuentos Clientes
Public Const csTListaDescuentoCliente                 As String = "ListaDescuentoCliente"
Public Const cscLdCliId                               As String = "ldcli_id"

Public Const csTListaDescuentoProveedor               As String = "ListaDescuentoProveedor"
Public Const cscLdProvId                              As String = "ldprov_id"

' Catalogo Web
Public Const csTCatalogoWeb                          As String = "CatalogoWeb"
Public Const cscCatwId                               As String = "catw_id"
Public Const cscCatwNombre                           As String = "catw_nombre"
Public Const cscCatwCodigo                           As String = "catw_codigo"
Public Const cscCatwDescrip                          As String = "catw_descrip"
Public Const cscCatwUpdateAddress                    As String = "catw_updateaddress"
Public Const cscCatwUpdateUser                       As String = "catw_updateuser"
Public Const cscCatwUpdatePwd                        As String = "catw_updatepwd"
Public Const cscCatwFtpAddress                       As String = "catw_ftpaddress"
Public Const cscCatwFtpUser                          As String = "catw_ftpuser"
Public Const cscCatwFtpPwd                           As String = "catw_ftppwd"
Public Const cscCatwFolderImage                      As String = "catw_folderimage"
Public Const cscCatwCSCART                           As String = "catw_cscart"

' Catalogo Web Item
Public Const csTCatalogoWebItem                      As String = "CatalogoWebItem"
Public Const cscCatwiId                              As String = "catwi_id"
Public Const cscCatwiActivo                          As String = "catwi_activo"

' Catalogo Web Categoria
Public Const csTCatalogoWebCategoria                 As String = "CatalogoWebCategoria"
Public Const cscCatwcId                              As String = "catwc_id"
Public Const cscCatwcNombre                          As String = "catwc_nombre"
Public Const cscCatwcCodigo                          As String = "catwc_codigo"
Public Const cscCatwcDescrip                         As String = "catwc_descrip"

' Catalogo Web Categoria Item
Public Const csTCatalogoWebCategoriaItem             As String = "CatalogoWebCategoriaItem"
Public Const cscCatwciId                             As String = "catwci_id"
Public Const cscCatwciPosicion                       As String = "catwci_posicion"
Public Const cscCatwciActivo                         As String = "catwci_activo"

' Pais
Public Const csTPais                                 As String = "Pais"
Public Const cscPaId                                 As String = "pa_id"
Public Const cscPaNombre                             As String = "pa_nombre"
Public Const cscPaCodigo                             As String = "pa_codigo"
Public Const cscPaDescrip                            As String = "pa_descrip"

' CircuitoContable
Public Const csTCircuitoContable                       As String = "CircuitoContable"
Public Const cscCicoId                                 As String = "cico_id"
Public Const cscCicoNombre                             As String = "cico_nombre"
Public Const cscCicoCodigo                             As String = "cico_codigo"
Public Const cscCicoDescrip                            As String = "cico_descrip"

' Calidad
Public Const csTCalidad                                 As String = "Calidad"
Public Const cscCalidId                                 As String = "calid_id"
Public Const cscCalidNombre                             As String = "calid_nombre"
Public Const cscCalidCodigo                             As String = "calid_codigo"
Public Const cscCalidDescrip                            As String = "calid_descrip"

' ClienteContactoTipo
Public Const csTClienteContactoTipo                     As String = "ClienteContactoTipo"
Public Const cscClictId                                 As String = "clict_id"
Public Const cscClictNombre                             As String = "clict_nombre"
Public Const cscClictCodigo                             As String = "clict_codigo"
Public Const cscClictDescrip                            As String = "clict_descrip"

' Marca
Public Const csTMarca                                  As String = "Marca"
Public Const cscMarcId                                 As String = "marc_id"
Public Const cscMarcNombre                             As String = "marc_nombre"
Public Const cscMarcCodigo                             As String = "marc_codigo"
Public Const cscMarcDescrip                            As String = "marc_descrip"
Public Const cscMarcTextoWeb                           As String = "marc_textoweb"

' Departamento
Public Const csTDepartamento                           As String = "Departamento"
Public Const cscDptoId                                 As String = "dpto_id"
Public Const cscDptoNombre                             As String = "dpto_nombre"
Public Const cscDptoCodigo                             As String = "dpto_codigo"
Public Const cscDptoDescrip                            As String = "dpto_descrip"
Public Const cscDptoIdPadre                            As String = "dpto_id_padre"

' DepartamentoProveedor
Public Const csTDepartamentoProveedor                 As String = "DepartamentoProveedor"
Public Const cscDptoProvId                            As String = "dptoprov_id"

' ProveedorCentroCosto
Public Const csTProveedorCentroCosto                  As String = "ProveedorCentroCosto"
Public Const cscProvCcosId                            As String = "provccos_id"

' DepartamentoCliente
Public Const csTDepartamentoCliente                  As String = "DepartamentoCliente"
Public Const cscDptoCliId                            As String = "dptocli_id"

'Camion
Public Const csTCamion                                As String = "Camion"
Public Const cscCamId                                 As String = "cam_id"
Public Const cscCamCodigo                             As String = "cam_codigo"
Public Const cscCamDescrip                            As String = "cam_descrip"
Public Const cscCamPatente                            As String = "cam_patente"
Public Const cscCamPatentesemi                        As String = "cam_patentesemi"
Public Const cscCamTara                               As String = "cam_tara"
Public Const cscCamEsSemi                             As String = "cam_essemi"

' Chofer
Public Const csTChofer                                 As String = "Chofer"
Public Const cscChofId                                 As String = "chof_id"
Public Const cscChofNombre                             As String = "chof_nombre"
Public Const cscChofCodigo                             As String = "chof_codigo"
Public Const cscChofDescrip                            As String = "chof_descrip"
Public Const cscChofTipodni                            As String = "chof_tipodni"
Public Const cscChofDni                                As String = "chof_dni"
Public Const cscChofFechadenacimiento                  As String = "chof_fechadenacimiento"
Public Const cscChofDireccion                          As String = "chof_direccion"
Public Const cscChofTelefono                           As String = "chof_telefono"

'Ciudad
Public Const csTCiudad                                As String = "Ciudad"
Public Const cscCiuId                                 As String = "ciu_id"
Public Const cscCiuNombre                             As String = "ciu_nombre"
Public Const cscCiuCodigo                             As String = "ciu_codigo"
Public Const cscCiuDescrip                            As String = "ciu_descrip"

' Calle
Public Const csTCalle                                 As String = "Calle"
Public Const cscCalleId                               As String = "calle_id"
Public Const cscCalleNombre                           As String = "calle_nombre"
Public Const cscCalleCodigo                           As String = "calle_codigo"
Public Const cscCalleDescrip                          As String = "calle_descrip"

' Calle Altura
Public Const csTCalleAltura                           As String = "CalleAltura"
Public Const cscCalleaId                              As String = "callea_id"
Public Const cscCalleaDesde                           As String = "callea_desde"
Public Const cscCalleaHasta                           As String = "callea_hasta"

' Proveedores CAI
Public Const csTProveedorCAI                            As String = "ProveedorCAI"
Public Const cscProvcId                                 As String = "provc_id"
Public Const cscProvcNumero                             As String = "provc_numero"
Public Const cscProvcDescrip                            As String = "provc_descrip"
Public Const cscProvcFechavto                           As String = "provc_fechavto"
Public Const cscProvcSucursal                           As String = "provc_sucursal"

' Condicion Pago
Public Const csTCondicionPago                         As String = "CondicionPago"
Public Const cscCpgId                                 As String = "cpg_id"
Public Const cscCpgNombre                             As String = "cpg_nombre"
Public Const cscCpgCodigo                             As String = "cpg_codigo"
Public Const cscCpgDescrip                            As String = "cpg_descrip"
Public Const cscCpgEscontado                          As String = "cpg_escontado"
Public Const cscCpgEsLibre                            As String = "cpg_eslibre"
Public Const cscCpgAsientoXVto                        As String = "cpg_asientoXvto"
Public Const cscCpgTipo                               As String = "cpg_tipo"

' Condicion Pago Item
Public Const csTCondicionPagoItem                      As String = "CondicionPagoItem"
Public Const cscCpgiId                                 As String = "cpgi_id"
Public Const cscCpgiDias                               As String = "cpgi_dias"
Public Const cscCpgiPorcentaje                         As String = "cpgi_porcentaje"

' Sucursal
Public Const csTSucursal                              As String = "Sucursal"
Public Const cscSucId                                 As String = "suc_id"
Public Const cscSucNombre                             As String = "suc_nombre"
Public Const cscSucCodigo                             As String = "suc_codigo"
Public Const cscSucDescrip                            As String = "suc_descrip"
Public Const cscSucNumero                             As String = "suc_numero"

' Contacto
Public Const csTContacto                               As String = "Contacto"
Public Const cscContId                                 As String = "cont_id"
Public Const cscContNombre                             As String = "cont_nombre"
Public Const cscContCodigo                             As String = "cont_codigo"
Public Const cscContDescrip                            As String = "cont_descrip"
Public Const cscContTel                                As String = "cont_tel"
Public Const cscContCelular                            As String = "cont_celular"
Public Const cscContEmail                              As String = "cont_email"
Public Const cscContCargo                              As String = "cont_cargo"
Public Const cscContDireccion                          As String = "cont_direccion"

'Tabla de Rubros
Public Const csTRubroTabla                             As String = "RubroTabla"
Public Const cscRubtid                                 As String = "rubt_id"
Public Const cscRubtNombre                             As String = "rubt_nombre"
Public Const cscRubtCodigo                             As String = "rubt_codigo"
Public Const cscRubtDescrip                            As String = "rubt_descrip"

' Tabla Rubro Item
Public Const csTRubroTablaItem                          As String = "RubroTablaItem"
Public Const cscRubtiId                                 As String = "rubti_id"
Public Const cscRubtiNombre                             As String = "rubti_nombre"
Public Const cscRubtiCodigo                             As String = "rubti_codigo"
Public Const cscRubtiDescrip                            As String = "rubti_descrip"

' Gasto
Public Const csTGasto                                 As String = "Gasto"
Public Const cscGtoId                                 As String = "gto_id"
Public Const cscGtoNombre                             As String = "gto_nombre"
Public Const cscGtoCodigo                             As String = "gto_codigo"
Public Const cscGtoDescrip                            As String = "gto_descrip"
Public Const cscGtoTipo                               As String = "gto_tipo"
Public Const cscGtoFijo                               As String = "gto_fijo"
Public Const cscGtoMinimo                             As String = "gto_minimo"
Public Const cscGtoPorcentaje                         As String = "gto_porcentaje"
Public Const cscGtoImporte                            As String = "gto_importe"

' Documentos
Public Const csTDocumento                             As String = "Documento"
Public Const cscDocId                                 As String = "doc_id"
Public Const cscDocNombre                             As String = "doc_nombre"

' Talonario
Public Const csTalonario = 4004
Public Const cscTaId                                 As String = "ta_id"
Public Const cscTaNombre                             As String = "ta_nombre"

' PercepcionTipo
Public Const csTPercepcionTipo                          As String = "PercepcionTipo"
Public Const cscPerctId                                 As String = "perct_id"
Public Const cscPerctNombre                             As String = "perct_nombre"
Public Const cscPerctCodigo                             As String = "perct_codigo"
Public Const cscPerctDescrip                            As String = "perct_descrip"
Public Const cscPerctGeneraSicore                       As String = "perct_generasicore"
Public Const cscPerctCodigoSicore                       As String = "perct_codigosicore"

' Percepcion
Public Const csTPercepcion                             As String = "Percepcion"
Public Const cscPercId                                 As String = "perc_id"
Public Const cscPercNombre                             As String = "perc_nombre"
Public Const cscPercCodigo                             As String = "perc_codigo"
Public Const cscPercImporteMinimo                      As String = "perc_importeminimo"
Public Const cscPercRegimenSicore                      As String = "perc_regimensicore"
Public Const cscPercDescrip                            As String = "perc_descrip"
Public Const cscPercEsIIBB                             As String = "perc_esiibb"

' PercepcionItem
Public Const csTPercepcionItem                          As String = "PercepcionItem"
Public Const cscPerciId                                 As String = "perci_id"
Public Const cscPerciImporteDesde                       As String = "perci_importedesde"
Public Const cscPerciImporteHasta                       As String = "perci_importehasta"
Public Const cscPerciPorcentaje                         As String = "perci_porcentaje"
Public Const cscPerciImportefijo                        As String = "perci_importefijo"

' RetencionTipo
Public Const csTRetencionTipo                          As String = "RetencionTipo"
Public Const cscRettId                                 As String = "rett_id"
Public Const cscRettNombre                             As String = "rett_nombre"
Public Const cscRettCodigo                             As String = "rett_codigo"
Public Const cscRettDescrip                            As String = "rett_descrip"
Public Const cscRettTipo                               As String = "rett_tipo"
Public Const cscRettGeneraSicore                       As String = "rett_generasicore"
Public Const cscRettCodigoSicore                       As String = "rett_codigosicore"

' Retencion
Public Const csTRetencion                             As String = "Retencion"
Public Const cscRetId                                 As String = "ret_id"
Public Const cscRetNombre                             As String = "ret_nombre"
Public Const cscRetCodigo                             As String = "ret_codigo"
Public Const cscRetImporteMinimo                      As String = "ret_importeminimo"
Public Const cscRetRegimenSicore                      As String = "ret_regimensicore"
Public Const cscRetDescrip                            As String = "ret_descrip"
Public Const cscRetAcumulaPor                         As String = "ret_acumulapor"
Public Const cscRetTipoMinimo                         As String = "ret_tipominimo"
Public Const cscRetEsIIBB                             As String = "ret_esiibb"

' RetencionItem
Public Const csTRetencionItem                          As String = "RetencionItem"
Public Const cscRetiId                                 As String = "reti_id"
Public Const cscRetiImporteDesde                       As String = "reti_importedesde"
Public Const cscRetiImporteHasta                       As String = "reti_importehasta"
Public Const cscRetiPorcentaje                         As String = "reti_porcentaje"
Public Const cscRetiImportefijo                        As String = "reti_importefijo"

' Monedas
Public Const cscMonId                            As String = "mon_id"
Public Const cscMonNombre                        As String = "mon_nombre"

'Producto
Public Const csTProducto                             As String = "Producto"
Public Const cscPrId                                 As String = "pr_id"
Public Const cscPrNombrecompra                       As String = "pr_Nombrecompra"
Public Const cscPrNombreventa                        As String = "pr_Nombreventa"
Public Const cscPrCodigo                             As String = "pr_codigo"
Public Const cscPrDescripventa                       As String = "pr_descripventa"
Public Const cscPrDescripcompra                      As String = "pr_descripcompra"
Public Const cscPrVentaCompra                        As String = "pr_ventacompra"
Public Const cscPrVentaStock                         As String = "pr_ventastock"
Public Const cscPrStockCompra                        As String = "pr_stockcompra"
Public Const cscPrLlevastock                         As String = "pr_llevastock"
Public Const cscPrSecompra                           As String = "pr_secompra"
Public Const cscPrSevende                            As String = "pr_sevende"
Public Const cscPrNoRedondeo                         As String = "pr_noredondeo"
Public Const cscPrEskit                              As String = "pr_eskit"
Public Const cscPrKitStockXItem                      As String = "pr_kitStkItem"
Public Const cscPrKitResumido                        As String = "pr_kitResumido"
Public Const cscPrKitIdentidad                       As String = "pr_kitIdentidad"
Public Const cscPrKitIdentidadXItem                  As String = "pr_kitIdentidadXItem"
Public Const cscPrKitLote                            As String = "pr_kitLote"
Public Const cscPrKitLoteXItem                       As String = "pr_kitLoteXItem"
Public Const cscPrEsLista                            As String = "pr_eslista"
Public Const cscPrPorcinternoc                       As String = "pr_porcinternoc"
Public Const cscPrPorcinternov                       As String = "pr_porcinternov"
Public Const cscPrX                                  As String = "pr_x"
Public Const cscPrY                                  As String = "pr_y"
Public Const cscPrZ                                  As String = "pr_z"
Public Const cscPrTienehijo                          As String = "pr_tienehijo"
Public Const cscPrIdPadre                            As String = "pr_id_padre"
Public Const cscPrEditarPreciohijo                   As String = "pr_editarpreciohijo"
Public Const cscPrPermiteedicion                     As String = "pr_permiteedicion"
Public Const cscPrBorrado                            As String = "pr_borrado"
Public Const cscPrStockminimo                        As String = "pr_stockminimo"
Public Const cscPrStockmaximo                        As String = "pr_stockmaximo"
Public Const cscPrCodigoexterno                      As String = "pr_Codigoexterno"
Public Const cscPrCodigoBarra                        As String = "pr_codigobarra"
Public Const cscPrCodigoBarraNombre                  As String = "pr_codigobarranombre"
Public Const cscPrReposicion                         As String = "pr_reposicion"
Public Const cscPrUnIdVenta                          As String = "un_id_venta"
Public Const cscPrUnIdCompra                         As String = "un_id_compra"
Public Const cscPrUnIdStock                          As String = "un_id_stock"
Public Const cscPrTiIdRiVenta                        As String = "ti_id_ivariventa"
Public Const cscPrTiIdRniVenta                       As String = "ti_id_ivarniventa"
Public Const cscPrTiIdRiCompra                       As String = "ti_id_ivaricompra"
Public Const cscPrTiIdRniCompra                      As String = "ti_id_ivarnicompra"
Public Const cscPrTiIdInternosVenta                  As String = "ti_id_internosv"
Public Const cscPrTiIdInternosCompra                 As String = "ti_id_internosc"
Public Const cscPrCuegIdCompra                       As String = "cueg_id_compra"
Public Const cscPrCuegIdVenta                        As String = "cueg_id_venta"
Public Const cscPrPesoTotal                          As String = "pr_pesototal"
Public Const cscPrPesoNeto                           As String = "pr_pesoneto"
Public Const cscUnIdPeso                             As String = "un_id_peso"
Public Const cscPrCantXCajaExpo                      As String = "pr_cantxcajaexpo"
Public Const cscPrLlevaNroSerie                      As String = "pr_llevanroserie"
Public Const cscPrLlevaNroLote                       As String = "pr_llevanrolote"
Public Const cscPrEsRepuesto                         As String = "pr_esrepuesto"
Public Const cscPrLoteFifo                           As String = "pr_lotefifo"
Public Const cscPrSeProduce                          As String = "pr_seProduce"
Public Const cscPrFleteExpo                          As String = "pr_fleteexpo"
Public Const cscPrDinerario                          As String = "pr_dinerario"
Public Const cscPrNombreWeb                          As String = "pr_nombreweb"
Public Const cscPrNombreFactura                      As String = "pr_nombrefactura"
Public Const cscPrCodigoHtml                         As String = "pr_codigohtml"
Public Const cscPrCodigoHtmlDetalle                  As String = "pr_codigohtmldetalle"
Public Const cscPrAliasWeb                           As String = "pr_aliasweb"
Public Const cscPrActivoWeb                          As String = "pr_activoweb"

Public Const cscPrExpoWeb                            As String = "pr_expoweb"
Public Const cscPrExpoCairo                          As String = "pr_expocairo"
Public Const cscPrVentaWebMaxima                     As String = "pr_ventaWebMaxima"
Public Const cscPrWebImageFolder                     As String = "pr_webimagefolder"
Public Const cscPrWebImageUpdate                     As String = "pr_webimageupdate"
Public Const cscPrIdWebPadre                         As String = "pr_id_webpadre"

Public Const cscPrtExpoWeb                           As String = "prt_expoweb"
Public Const cscPrtExpoCairo                         As String = "prt_expocairo"

Public Const cscPrIdTag                              As String = "pr_id_tag"

Public Const cscTaIdKitSerie                         As String = "ta_id_kitSerie"
Public Const cscTaIdKitLote                          As String = "ta_id_kitLote"

Public Const cscCcosIdCompra                         As String = "ccos_id_compra"
Public Const cscCcosIdVenta                          As String = "ccos_id_venta"

Public Const cscPrEsPlantilla                        As String = "pr_esplantilla"

Public Const cscRptIdNombreVenta                     As String = "rpt_id_nombreventa"
Public Const cscRptIdNombreCompra                    As String = "rpt_id_nombrecompra"
Public Const cscRptIdNombreFactura                   As String = "rpt_id_nombrefactura"
Public Const cscRptIdNombreWeb                       As String = "rpt_id_nombreweb"
Public Const cscRptIdNombreImg                       As String = "rpt_id_nombreimg"
Public Const cscRptIdNombreImgAlt                    As String = "rpt_id_nombreimgalt"

Public Const cscTiIdComexGanancias                   As String = "ti_id_comex_ganancias"
Public Const cscTiIdComexIGB                         As String = "ti_id_comex_igb"
Public Const cscTiIdComexIva                         As String = "ti_id_comex_iva"

' Producto Tag
Public Const csTProductoTag                          As String = "ProductoTag"
Public Const cscPrtId                                As String = "prt_id"
Public Const cscPrtTexto                             As String = "prt_texto"

' Producto Web Image
Public Const csTProductoWebImage                     As String = "ProductoWebImage"
Public Const cscPrwiId                               As String = "prwi_id"
Public Const cscPrwiArchivo                          As String = "prwi_archivo"
Public Const cscPrwiTipo                             As String = "prwi_tipo"
Public Const cscPrwiAlt                              As String = "prwi_alt"
Public Const cscPrwiPosicion                         As String = "prwi_posicion"

' ListaPrecioMarcado
Public Const csTListaPrecioMarcado                    As String = "ListaPrecioMarcado"
Public Const cscLpmId                                 As String = "lpm_id"
Public Const cscLpmNombre                             As String = "lpm_nombre"
Public Const cscLpmCodigo                             As String = "lpm_codigo"
Public Const cscLpmDescrip                            As String = "lpm_descrip"
Public Const cscLpmBase                               As String = "lpm_base"
Public Const cscLpmPorcentaje                         As String = "lpm_porcentaje"
Public Const cscLpmSalto                              As String = "lpm_salto"
Public Const cscLpmDecremento                         As String = "lpm_decremento"
Public Const cscLpmPorcminimo                         As String = "lpm_porcminimo"
Public Const cscLpmPorcmaximo                         As String = "lpm_porcmaximo"
Public Const cscLpmMontominimo                        As String = "lpm_montominimo"

' Producto Kit
Public Const csTProductoKit                           As String = "ProductoKit"
Public Const cscPrkId                                 As String = "prk_id"
Public Const cscPrkCantidad                           As String = "prk_cantidad"
Public Const cscPrkVariable                           As String = "prk_variable"
Public Const cscPrIdItem                              As String = "pr_id_item"

' Producto Proveedor
Public Const csTProductoProveedor                     As String = "ProductoProveedor"
Public Const cscPrProvId                              As String = "prprov_id"
Public Const cscPrProvFabricante                      As String = "prprov_fabricante"
Public Const cscPrProvNombre                          As String = "prprov_nombre"
Public Const cscPrProvCodigo                          As String = "prprov_codigo"
Public Const cscPrProvCodigoBarra                     As String = "prprov_codigoBarra"

' Producto Cliente
Public Const csTProductoCliente                      As String = "ProductoCliente"
Public Const cscPrCliId                              As String = "prcli_id"
Public Const cscPrCliNombre                          As String = "prcli_nombre"
Public Const cscPrCliCodigo                          As String = "prcli_codigo"
Public Const cscPrCliCodigoBarra                     As String = "prcli_codigoBarra"

' Producto BOM
Public Const cscPbmId                                 As String = "pbm_id"
Public Const cscPbmNombre                             As String = "pbm_nombre"
Public Const cscPbmCodigo                             As String = "pbm_codigo"
Public Const cscPbmFecha                              As String = "pbm_fecha"

' Empresa
Public Const cscEmpDescrip                            As String = "emp_descrip"
Public Const cscEmpRazonsocial                        As String = "emp_razonsocial"
Public Const cscEmpCuit                               As String = "emp_cuit"
Public Const cscEmpIngresosbrutos                     As String = "emp_ingresosbrutos"
Public Const cscEmpCatfiscal                          As String = "emp_catfiscal"
Public Const cscEmpChequeorden                        As String = "emp_chequeorden"
Public Const cscEmpCodpostal                          As String = "emp_codpostal"
Public Const cscEmpLocalidad                          As String = "emp_localidad"
Public Const cscEmpCalle                              As String = "emp_calle"
Public Const cscEmpCallenumero                        As String = "emp_callenumero"
Public Const cscEmpPiso                               As String = "emp_piso"
Public Const cscEmpDepto                              As String = "emp_depto"
Public Const cscEmpTel                                As String = "emp_tel"
Public Const cscEmpFax                                As String = "emp_fax"
Public Const cscEmpEmail                              As String = "emp_email"
Public Const cscEmpWeb                                As String = "emp_web"

' UsuarioDepartamento
Public Const csTUsuarioDepartamento                   As String = "UsuarioDepartamento"
Public Const cscUsdptoId                              As String = "usdpto_id"

' Persona
Public Const csTPersona                               As String = "Persona"
Public Const cscPrsId                                 As String = "prs_id"
Public Const cscPrsNombre                             As String = "prs_nombre"
Public Const cscPrsApellido                           As String = "prs_apellido"
Public Const cscPrsCodigo                             As String = "prs_codigo"
Public Const cscPrsDescrip                            As String = "prs_descrip"
Public Const cscPrsInterno                            As String = "prs_interno"
Public Const cscPrsTelTrab                            As String = "prs_telTrab"
Public Const cscPrsTelCasa                            As String = "prs_telCasa"
Public Const cscPrsCelular                            As String = "prs_celular"
Public Const cscPrsEmail                              As String = "prs_email"
Public Const cscPrsCargo                              As String = "prs_cargo"
Public Const cscPrsFechaNac                           As String = "prs_fechaNac"
Public Const cscPrsDocumento                          As String = "prs_documento"
Public Const cscPrsWeb                                As String = "prs_web"
Public Const cscPrsCodpostal                          As String = "prs_codpostal"
Public Const cscPrsLocalidad                          As String = "prs_localidad"
Public Const cscPrsCalle                              As String = "prs_calle"
Public Const cscPrsCallenumero                        As String = "prs_callenumero"
Public Const cscPrsPiso                               As String = "prs_piso"
Public Const cscPrsDepto                              As String = "prs_depto"
Public Const cscPrsEsEmpleado                         As String = "prs_esempleado"

' Empresa Cliente
Public Const csTEmpresaCliente                        As String = "EmpresaCliente"
Public Const cscEmpCliId                              As String = "empcli_id"

' Empresa Proveedor
Public Const csTEmpresaProveedor                      As String = "EmpresaProveedor"
Public Const cscEmpProvId                             As String = "empprov_id"

' Idioma
Public Const csTIdioma                                As String = "Idioma"
Public Const cscIdmId                                 As String = "idm_id"
Public Const cscIdmNombre                             As String = "idm_nombre"
Public Const cscIdmCodigo                             As String = "idm_codigo"

' Tipo Operacion
Public Const csTTipoOperacion                         As String = "TipoOperacion"
Public Const cscToId                                  As String = "to_id"
Public Const cscToNombre                              As String = "to_nombre"
Public Const cscToCodigo                              As String = "to_codigo"
Public Const cscToGeneradeuda                         As String = "to_generadeuda"
Public Const cscToDescrip                             As String = "to_descrip"

' Tipo Operacion Cuenta Grupo
Public Const csTTipoOperacionCuentaGrupo              As String = "TipoOperacionCuentaGrupo"
Public Const cscToCuegId                              As String = "tocueg_id"

' Embalaje
Public Const csTEmbalaje                               As String = "Embalaje"
Public Const cscEmblId                                 As String = "embl_id"
Public Const cscEmblNombre                             As String = "embl_nombre"
Public Const cscEmblCodigo                             As String = "embl_codigo"
Public Const cscEmblDescrip                            As String = "embl_descrip"
Public Const cscEmblCapacidad                          As String = "embl_capacidad"
Public Const cscEmblAlto                               As String = "embl_alto"
Public Const cscEmblAncho                              As String = "embl_ancho"
Public Const cscEmblLargo                              As String = "embl_largo"
Public Const cscEmblTara                               As String = "embl_tara"
Public Const cscPrIdStock                              As String = "pr_id_stock"

' Usuario DepositoLogico
Public Const csTUsuarioDepositoLogico                  As String = "UsuarioDepositoLogico"
Public Const cscUsDeplId                               As String = "usdepl_id"

' Expo Grupo Precio
Public Const cscEgpId                                  As String = "egp_id"
Public Const cscEgpNombre                              As String = "egp_nombre"

' Expo Familia
Public Const cscEfmId                                  As String = "efm_id"
Public Const cscEfmNombre                              As String = "efm_nombre"

' Producto Formula Kit
Public Const csTProductoFormulaKit                     As String = "ProductoFormulaKit"
Public Const cscPrfkId                                 As String = "prfk_id"
Public Const cscPrfkNombre                             As String = "prfk_nombre"
Public Const cscPrfkCodigo                             As String = "prfk_codigo"
Public Const cscPrfkDefault                            As String = "prfk_default"
Public Const cscPrfkDescrip                            As String = "prfk_descrip"

Public Const cscPrIdSerie                              As String = "pr_id_serie"
Public Const cscPrIdLote                               As String = "pr_id_lote"

' Producto Kit Item Alternativo
Public Const csTProductoKitItemA                       As String = "ProductoKitItemA"
Public Const cscPrkaId                                 As String = "prka_id"

' Feriado
Public Const csTFeriado                              As String = "Feriado"
Public Const cscFeId                                 As String = "fe_id"
Public Const cscFeNombre                             As String = "fe_nombre"
Public Const cscFeCodigo                             As String = "fe_codigo"
Public Const cscFeDescrip                            As String = "fe_descrip"
Public Const cscFeDia                                As String = "fe_dia"
Public Const cscFeMes                                As String = "fe_mes"
Public Const cscFeAnio                               As String = "fe_anio"
Public Const cscFeBanco                              As String = "fe_banco"
Public Const cscFeLaboral                            As String = "fe_laboral"
Public Const cscFeLocal                              As String = "fe_local"
Public Const cscFeRecurrente                         As String = "fe_recurrente"

' PercepcionCategoriaFiscal
Public Const csTPercepcionCategoriaFiscal            As String = "PercepcionCategoriaFiscal"
Public Const cscPercCatfId                           As String = "perccatf_id"
Public Const cscPercCatfBase                         As String = "perccatf_base"

' PercepcionProvincia
Public Const csTPercepcionProvincia                  As String = "PercepcionProvincia"
Public Const cscPercProId                            As String = "percpro_id"

' PercepcionEmpresa
Public Const csTPercepcionEmpresa                    As String = "PercepcionEmpresa"
Public Const cscPercEmpId                            As String = "percemp_id"

' CategoriaFiscal
Public Const csTCategoriaFiscal                      As String = "CategoriaFiscal"
Public Const cscCatfId                               As String = "catf_id"
Public Const cscCatfNombre                           As String = "catf_nombre"

' RetencionCategoriaFiscal
Public Const csTRetencionCategoriaFiscal            As String = "RetencionCategoriaFiscal"
Public Const cscRetCatfId                           As String = "retcatf_id"
Public Const cscRetCatfBase                         As String = "retcatf_base"

' RetencionProvincia
Public Const csTRetencionProvincia                  As String = "RetencionProvincia"
Public Const cscRetProId                            As String = "retpro_id"

' ProductoDepositoFisico
Public Const csTProductoDepositoFisico                   As String = "ProductoDepositoFisico"
Public Const cscPrdepfId                                 As String = "prdepf_id"
Public Const cscPrdepfX                                  As String = "prdepf_x"
Public Const cscPrdepfY                                  As String = "prdepf_y"
Public Const cscPrdepfZ                                  As String = "prdepf_z"
Public Const cscPrdepfStockminimo                        As String = "prdepf_stockminimo"
Public Const cscPrdepfStockmaximo                        As String = "prdepf_stockmaximo"
Public Const cscPrdepfReposicion                         As String = "prdepf_reposicion"

' ProductoDepositoLogico
Public Const csTProductoDepositoLogico                   As String = "ProductoDepositoLogico"
Public Const cscPrdeplId                                 As String = "prdepl_id"
Public Const cscPrdeplX                                  As String = "prdepl_x"
Public Const cscPrdeplY                                  As String = "prdepl_y"
Public Const cscPrdeplZ                                  As String = "prdepl_z"
Public Const cscPrdeplStockminimo                        As String = "prdepl_stockminimo"
Public Const cscPrdeplStockmaximo                        As String = "prdepl_stockmaximo"
Public Const cscPrdeplReposicion                         As String = "prdepl_reposicion"

' Caja
Public Const csTCaja                          As String = "Caja"
Public Const cscCjId                          As String = "cj_id"
Public Const cscCjNombre                      As String = "cj_nombre"
Public Const cscCjCodigo                      As String = "cj_codigo"
Public Const cscCjDescrip                     As String = "cj_descrip"
Public Const cscCjHojaRuta                    As String = "cj_hojaruta"

' Caja-Cuenta
Public Const csTCajaCuenta                    As String = "CajaCuenta"
Public Const cscCjcId                         As String = "cjc_id"
Public Const cscCueIdTrabajo                  As String = "cue_id_trabajo"
Public Const cscCueIdFondos                   As String = "cue_id_fondos"

' Caja-Cajero
Public Const csTCajaCajero                    As String = "CajaCajero"
Public Const cscCjcjId                        As String = "cjcj_id"

' AjusteInflacion
Public Const csTAjusteInflacion                       As String = "AjusteInflacion"
Public Const cscAjeId                                 As String = "aje_id"
Public Const cscAjeNombre                             As String = "aje_nombre"
Public Const cscAjeCodigo                             As String = "aje_codigo"
Public Const cscAjeDescrip                            As String = "aje_descrip"
Public Const cscAjeMetodo                             As String = "aje_metodo"
Public Const cscAjeAgrupaccos                         As String = "aje_agrupaccos"
Public Const cscAjeIncluirsinccos                     As String = "aje_incluirsinccos"
Public Const cscCueIdPatrimonial                      As String = "cue_id_patrimonial"
Public Const cscCueIdResultados                       As String = "cue_id_resultados"

' AjusteInflacionItem
Public Const csTAjusteInflacionItem                   As String = "AjusteInflacionItem"
Public Const cscAjiId                                 As String = "aji_id"

' AjusteInflacionItem
Public Const csTAjusteInflacionItemTipo               As String = "AjusteInflacionItemTipo"
Public Const cscAjitId                                As String = "ajit_id"
Public Const cscAjitNombre                            As String = "ajit_nombre"

' AjusteInflacionIndice
Public Const csTAjusteInflacionIndice                 As String = "AjusteInflacionIndice"
Public Const cscAjiiId                                As String = "ajii_id"
Public Const cscAjiiFecha                             As String = "ajii_fecha"
Public Const cscAjiiIndice                            As String = "ajii_indice"

' ProductoHelpConfig
Public Const csTProductoHelpConfig                     As String = "ProductoHelpConfig"
Public Const cscPrhcId                                 As String = "prhc_id"
Public Const cscPrhcNombre                             As String = "prhc_nombre"
Public Const cscPrhcTecla                              As String = "prhc_tecla"
Public Const cscPrhcAtributoIndice                     As String = "prhc_atributo_indice"
Public Const cscPrhcValorCodigo                        As String = "prhc_valor_codigo"
Public Const cscPrhcDescrip                            As String = "prhc_descrip"
Public Const cscPrhcDefault                            As String = "prhc_default"
Public Const cscPrhcDefaultSrv                         As String = "prhc_defaultsrv"
Public Const cscPrhcDefaultPrp                         As String = "prhc_defaultprp"
Public Const cscPrhcDefaultPrns                        As String = "prhc_defaultprns"

' ListaPrecioConfig
Public Const csTListaPrecioConfig                      As String = "ListaPrecioConfig"
Public Const cscLpcId                                  As String = "lpc_id"
Public Const cscLpcOrden                               As String = "lpc_orden"

' Proyecto
Public Const cscProyId                                 As String = "proy_id"
Public Const cscProyNombre                             As String = "proy_nombre"

' PersonaDocumentoTipo
Public Const csTPersonaDocumentoTipo                    As String = "PersonaDocumentoTipo"
Public Const cscPrsdtId                                 As String = "prsdt_id"
Public Const cscPrsdtNombre                             As String = "prsdt_nombre"
Public Const cscPrsdtCodigo                             As String = "prsdt_codigo"
Public Const cscPrsdtDescrip                            As String = "prsdt_descrip"

' Curso
Public Const cscCurId                                   As String = "cur_id"
Public Const cscCurNombre                               As String = "cur_nombre"

' Codigos Postales
Public Const cscCpaId                                   As String = "cpa_id"
Public Const cscCpaCodigo                               As String = "cpa_codigo"

' PosicionArancel
Public Const csTPosicionArancel                        As String = "PosicionArancel"
Public Const cscPoarId                                 As String = "poar_id"
Public Const cscPoarNombre                             As String = "poar_nombre"
Public Const cscPoarCodigo                             As String = "poar_codigo"
Public Const cscPoarDescrip                            As String = "poar_descrip"
Public Const cscTiIdEstadistica                        As String = "ti_id_estadistica"
Public Const cscTiIdDerechos                           As String = "ti_id_derechos"

' Producto Comunidad Internet
Public Const csTProductoComunidadInternet               As String = "ProductoComunidadInternet"
Public Const cscPrcmiId                                 As String = "prcmi_id"
Public Const cscPrcmiCodigo                             As String = "prcmi_codigo"
Public Const cscPrcmiDescrip                            As String = "prcmi_descrip"
Public Const cscPrcmiFechaAlta                          As String = "prcmi_fechaalta"
Public Const cscPrcmiFechaVto                           As String = "prcmi_fechavto"
Public Const cscPrcmiPrecio                             As String = "prcmi_precio"

' Comunidad Internet
Public Const csTComunidadInternet                     As String = "ComunidadInternet"
Public Const cscCmiId                                 As String = "cmi_id"
Public Const cscCmiNombre                             As String = "cmi_nombre"
Public Const cscCmiCodigo                             As String = "cmi_codigo"

' Producto Leyenda
Public Const csTProductoLeyenda                         As String = "ProductoLeyenda"
Public Const cscPrlId                                   As String = "prl_id"
Public Const cscPrlNombre                               As String = "prl_nombre"
Public Const cscPrlTexto                                As String = "prl_texto"
Public Const cscPrlTag                                  As String = "prl_tag"
Public Const cscPrlOrden                                As String = "prl_orden"

' Tarifario
Public Const csTTarifario                               As String = "Tarifario"
Public Const cscTfId                                    As String = "tf_id"
Public Const cscTfNombre                                As String = "tf_nombre"
Public Const cscTfCodigo                                As String = "tf_codigo"
Public Const cscTfDescrip                               As String = "tf_descrip"

' Tarifario Altura
Public Const csTTarifarioAltura                         As String = "TarifarioAltura"
Public Const cscTfaId                                   As String = "tfa_id"
Public Const cscTfaDesde                                As String = "tfa_desde"
Public Const cscTfaHasta                                As String = "tfa_hasta"

' Tarifario Calle
Public Const csTTarifarioCalle                          As String = "TarifarioCalle"
Public Const cscTfCalleId                               As String = "tfcalle_id"

' Tarifario Paralela
Public Const csTTarifarioParalela                       As String = "TarifarioParalela"
Public Const cscTfpId                                   As String = "tfp_id"
Public Const cscTfpAlturaBase                           As String = "tfp_alturabase"
Public Const cscTfpAlturaDesde                          As String = "tfp_alturadesde"

' FormaPago
Public Const csTFormaPago                            As String = "FormaPago"
Public Const cscFpId                                 As String = "fp_id"
Public Const cscFpNombre                             As String = "fp_nombre"
Public Const cscFpCodigo                             As String = "fp_codigo"
Public Const cscFpDescrip                            As String = "fp_descrip"

Public Const cscFpLunes                              As String = "fp_lunes"
Public Const cscFpMartes                             As String = "fp_martes"
Public Const cscFpMiercoles                          As String = "fp_miercoles"
Public Const cscFpJueves                             As String = "fp_jueves"
Public Const cscFpViernes                            As String = "fp_viernes"
Public Const cscFpSabado                             As String = "fp_sabado"
Public Const cscFpDomingo                            As String = "fp_domingo"

' VentaModo
Public Const csTVentaModo                       As String = "VentaModo"
Public Const cscVmId                            As String = "vm_id"
Public Const cscVmNombre                        As String = "vm_nombre"
Public Const cscVmCodigo                        As String = "vm_codigo"
Public Const cscVmDescrip                       As String = "vm_descrip"
Public Const cscVmCtaCte                        As String = "vm_ctacte"
Public Const cscVmOs                            As String = "vm_os"
Public Const cscVmPv                            As String = "vm_pv"
Public Const cscVmCmvxi                         As String = "vm_cmvxi"
Public Const cscVmCobz                          As String = "vm_cobz"
