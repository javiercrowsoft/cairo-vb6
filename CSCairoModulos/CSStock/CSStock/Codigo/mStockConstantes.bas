Attribute VB_Name = "mStockConstantes"
Option Explicit

'--------------------------------------------------------------------------------
' mStockConstantes
' 06-01-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mStockConstantes"

Public Const c_GrupoGeneral = "Stock-General"
Public Const c_TipoControlStock = "Tipo Control Stock"

Public Const csLegajo As Long = 15001

' Sucursal
Public Const csTSucursal                              As String = "Sucursal"
Public Const cscSucId                                 As String = "Suc_id"
Public Const cscSucNombre                             As String = "Suc_Nombre"

' Legajo
Public Const csTLegajo                                As String = "Legajo"
Public Const cscLgjId                                 As String = "lgj_id"
Public Const cscLgjCodigo                             As String = "lgj_codigo"

' Documentos
Public Const csTDocumento                             As String = "Documento"
Public Const cscDocId                                 As String = "doc_id"
Public Const cscDocNombre                             As String = "doc_nombre"
Public Const cscDocStConsumo                          As String = "doc_st_consumo"

' Tipos de Documento
Public Const csTDocumentoTipo                          As String = "DocumentoTipo"
Public Const cscDoctId                                 As String = "doct_id"
Public Const cscDoctNombre                             As String = "doct_nombre"

' Rama
Public Const cscRamNombre                            As String = "ram_nombre"

'Producto
Public Const csTProducto                             As String = "Producto"
Public Const cscPrId                                 As String = "pr_id"
Public Const cscPrNombrecompra                       As String = "pr_nombrecompra"
Public Const cscPrLlevaStock                         As String = "pr_llevastock"
Public Const cscPrLlevaNroSerie                      As String = "pr_llevanroserie"
Public Const cscPrLlevaNroLote                       As String = "pr_llevanrolote"
Public Const cscPrEskit                              As String = "pr_eskit"
Public Const cscPrIdKit                              As String = "pr_id_kit"
Public Const cscPrIdItem                             As String = "pr_id_item"
Public Const cscPrKitResumido                        As String = "pr_kitResumido"
Public Const cscPrKitIdentidad                       As String = "pr_kitIdentidad"

Public Const cscKitAlternativas                      As String = "tiene_alternativas"

' Unidad
Public Const cscUnId                            As String = "un_id"
Public Const cscUnNombre                        As String = "un_nombre"

' Talonario
Public Const cscTaId                            As String = "ta_id"

' Stock
Public Const csTStock                                As String = "Stock"
Public Const cscStId                                 As String = "st_id"
Public Const cscStNumero                             As String = "st_numero"
Public Const cscStNrodoc                             As String = "st_nrodoc"
Public Const cscStDescrip                            As String = "st_descrip"
Public Const cscStFecha                              As String = "st_fecha"
Public Const cscStDocCliente                         As String = "st_doc_cliente"
Public Const cscDeplIdOrigen                         As String = "depl_id_origen"
Public Const cscDeplIdDestino                        As String = "depl_id_destino"
Public Const cscIdCliente                            As String = "id_cliente"
Public Const cscDoctIdCliente                        As String = "doct_id_cliente"

' StockTMP
Public Const csTStockTMP                             As String = "StockTMP"
Public Const cscStTMPId                              As String = "stTMP_id"

' StockItem
Public Const csTStockItem                             As String = "StockItem"
Public Const cscStiId                                 As String = "sti_id"
Public Const cscStiOrden                              As String = "sti_orden"
Public Const cscStiIngreso                            As String = "sti_ingreso"
Public Const cscStiSalida                             As String = "sti_salida"
Public Const cscStiDescrip                            As String = "sti_descrip"
Public Const cscStiGrupo                              As String = "sti_grupo"

' StockItemKit
Public Const cscStikOrden                             As String = "stik_orden"
Public Const cscStikCantidad                          As String = "stik_cantidad"

' StockItemTMP
Public Const csTStockItemTMP                          As String = "StockItemTMP"
Public Const cscStiTMPId                              As String = "stiTMP_id"

' Cliente
Public Const csTCliente                                As String = "Cliente"
Public Const cscCliId                                  As String = "cli_id"
Public Const cscCliNombre                              As String = "cli_nombre"
Public Const cscCliCatfiscal                           As String = "cli_catfiscal"

' Deposito Logico
Public Const csTDepositoLogico                           As String = "DepositoLogico"
Public Const cscDeplId                                   As String = "depl_id"
Public Const cscDeplNombre                               As String = "depl_nombre"

' Depositos Fisicos
Public Const cscDepfId                                As String = "depf_id"

' Monedas
Public Const cscMonNombre                             As String = "Moneda"
Public Const cscMonId                                 As String = "mon_id"

' Recuento Stock
Public Const csTRecuentoStock                        As String = "RecuentoStock"
Public Const cscRsId                                 As String = "rs_id"
Public Const cscRsNumero                             As String = "rs_numero"
Public Const cscRsNrodoc                             As String = "rs_nrodoc"
Public Const cscRsDescrip                            As String = "rs_descrip"
Public Const cscRsFecha                              As String = "rs_fecha"

' Recuento Stock Item
Public Const csTRecuentoStockItem                     As String = "RecuentoStockItem"
Public Const cscRsiId                                 As String = "rsi_id"
Public Const cscRsiOrden                              As String = "rsi_orden"
Public Const cscRsiCantidad                           As String = "rsi_cantidad"
Public Const cscRsiDescrip                            As String = "rsi_descrip"

' Recuento Stock TMP
Public Const csTRecuentoStockTMP                      As String = "RecuentoStockTMP"
Public Const cscRsTMPId                               As String = "rsTMP_id"

' Recuento Stock Item TMP
Public Const csTRecuentoStockItemTMP                  As String = "RecuentoStockItemTMP"
Public Const cscRsiTMPId                              As String = "rsiTMP_id"

' Recuento Stock Item Serie
Public Const csTRecuentoStockItemSerieTMP              As String = "RecuentoStockItemSerieTMP"
Public Const cscRsisTMPId                              As String = "rsisTMP_id"
Public Const cscRsisOrden                              As String = "rsis_orden"

' Producto Numero Serie
Public Const csTProductoNumeroSerie                    As String = "ProductoNumeroSerie"
Public Const cscPrnsId                                 As String = "prns_id"
Public Const cscPrnsCodigo                             As String = "prns_codigo"
Public Const cscPrnsDescrip                            As String = "prns_descrip"
Public Const cscPrnsFechavto                           As String = "prns_fechavto"

'////////////////////////////////////////////////////////////////////////////////

' Parte de Produccion
Public Const csTParteProdKit                          As String = "ParteProdKit"
Public Const cscPpkId                                 As String = "ppk_id"
Public Const cscPpkNumero                             As String = "ppk_numero"
Public Const cscPpkNrodoc                             As String = "ppk_nrodoc"
Public Const cscPpkDescrip                            As String = "ppk_descrip"
Public Const cscPpkFecha                              As String = "ppk_fecha"
Public Const cscStId1                                 As String = "st_id1"
Public Const cscStId2                                 As String = "st_id2"

' Parte de Produccion Item
Public Const csTParteProdKitItem                       As String = "ParteProdKitItem"
Public Const cscPpkiId                                 As String = "ppki_id"
Public Const cscPpkiOrden                              As String = "ppki_orden"
Public Const cscPpkiCantidad                           As String = "ppki_cantidad"
Public Const cscPpkiDescrip                            As String = "ppki_descrip"

' Parte de Produccion TMP
Public Const csTParteProdKitTMP                        As String = "ParteProdKitTMP"
Public Const cscPpkTMPId                               As String = "ppkTMP_id"

' Parte de Produccion Item TMP
Public Const csTParteProdKitItemTMP                    As String = "ParteProdKitItemTMP"
Public Const cscPpkiTMPId                              As String = "ppkiTMP_id"

' Parte de Produccion Item Borrado TMP
Public Const csTParteProdKitItemBorradoTMP             As String = "ParteProdKitItemBorradoTMP"
Public Const cscPpkibTMPId                             As String = "ppkibTMP_id"

' Parte de Produccion Item Serie
Public Const csTParteProdKitItemSerieTMP                As String = "ParteProdKitItemSerieTMP"
Public Const cscPpkisTMPId                              As String = "ppkisTMP_id"
Public Const cscPpkisOrden                              As String = "ppkis_orden"

' Orden de Produccion de Kit
Public Const csTOrdenProdKit                          As String = "OrdenProdKit"
Public Const cscOpkId                                 As String = "opk_id"
Public Const cscOpkNumero                             As String = "opk_numero"
Public Const cscOpkNrodoc                             As String = "opk_nrodoc"
Public Const cscOpkDescrip                            As String = "opk_descrip"
Public Const cscOpkFecha                              As String = "opk_fecha"

' Orden de Produccion Item
Public Const csTOrdenProdKitItem                       As String = "OrdenProdKitItem"
Public Const cscOpkiId                                 As String = "Opki_id"
Public Const cscOpkiOrden                              As String = "Opki_orden"
Public Const cscOpkiCantidad                           As String = "Opki_cantidad"
Public Const cscOpkiDescrip                            As String = "Opki_descrip"

' Orden de Produccion Item TMP
Public Const csTOrdenProdKitItemTMP                    As String = "OrdenProdKitItemTMP"
Public Const cscOpkiTMPId                              As String = "opkiTMP_id"

' Orden de Produccion TMP
Public Const csTOrdenProdKitTMP                        As String = "OrdenProdKitTMP"
Public Const cscOpkTMPId                               As String = "opkTMP_id"

' Orden de Produccion Item Borrado TMP
Public Const csTOrdenProdKitItemBorradoTMP             As String = "OrdenProdKitItemBorradoTMP"
Public Const cscOpkibTMPId                             As String = "opkibTMP_id"

' Producto Formula Kit
Public Const cscPrfkId                                  As String = "prfk_id"
Public Const cscPrfkNombre                              As String = "prfk_nombre"

' Producto Kit
Public Const cscPrkId                                   As String = "prk_id"
Public Const cscPrkCantidad                             As String = "prk_cantidad"
Public Const cscPrkVariable                             As String = "prk_variable"

' Parte de Produccion Item Alternativo
Public Const cscPpkiaId                                 As String = "ppkia_id"
Public Const cscPpkiaCantidad                           As String = "ppkia_cantidad"

' Parte de Produccion Item Alternativo TMP
Public Const csTParteProdKitItemATMP                    As String = "ParteProdKitItemATMP"
Public Const cscPpkiaTMPId                              As String = "ppkiaTMP_id"

' Producto Serie Kit TMP
Public Const csTProductoSerieKitTMP                     As String = "ProductoSerieKitTMP"
Public Const cscPrskTMPId                               As String = "prskTMP_id"

' Producto Serie Kit
Public Const cscPrskId                                  As String = "prsk_id"

' Producto Serie Kit Item TMP
Public Const csTProductoSerieKitItemTMP                 As String = "ProductoSerieKitItemTMP"
Public Const cscPrskiTMPId                              As String = "prskiTMP_id"

' Producto Serie Kit Item
Public Const cscPrskiId                                 As String = "prski_id"
Public Const cscPrskiCantidad                           As String = "prski_cantidad"

' Lotes
Public Const cscStlId                                   As String = "stl_id"
Public Const cscStlCodigo                               As String = "stl_codigo"

' Stock Cliente TMP
Public Const csTStockClienteTMP                         As String = "StockClienteTMP"
Public Const cscStCliTMPId                              As String = "stcliTMP_id"

' Stock Cliente
Public Const csTStockCliente                            As String = "StockCliente"
Public Const cscStCliId                                 As String = "stcli_id"
Public Const cscStCliNumero                             As String = "stcli_numero"
Public Const cscStCliNrodoc                             As String = "stcli_nrodoc"
Public Const cscStCliDescrip                            As String = "stcli_descrip"
Public Const cscStCliFecha                              As String = "stcli_fecha"

' Stock Proveedor TMP
Public Const csTStockProveedorTMP                        As String = "StockProveedorTMP"
Public Const cscStProvTMPId                              As String = "stprovTMP_id"

' Stock Proveedor
Public Const csTStockProveedor                           As String = "StockProveedor"
Public Const cscStProvId                                 As String = "stprov_id"
Public Const cscStProvNumero                             As String = "stprov_numero"
Public Const cscStProvNrodoc                             As String = "stprov_nrodoc"
Public Const cscStProvDescrip                            As String = "stprov_descrip"
Public Const cscStProvFecha                              As String = "stprov_fecha"

' Proveedor
Public Const csTProveedor                                As String = "Proveedor"
Public Const cscProvId                                   As String = "prov_id"
Public Const cscProvNombre                               As String = "prov_nombre"
