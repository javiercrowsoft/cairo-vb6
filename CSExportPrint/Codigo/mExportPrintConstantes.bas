Attribute VB_Name = "mExportPritnConstantes"
Option Explicit

Public Const c_ErrorSaveFactura = "Error al grabar la factura de venta"
Public Const c_ErrorSavePacking = "Error al grabar el packing list"

Public Const cscObligatorio = "obligatorio"

' ExpoFamilia
Public Const csTExpoFamilia                           As String = "ExpoFamilia"
Public Const cscEfmId                                 As String = "efm_id"
Public Const cscEfmNombre                             As String = "efm_nombre"
Public Const cscEfmCodigo                             As String = "efm_codigo"

' ExpoGrupoPrecio
Public Const csTExpoGrupoPrecio                       As String = "ExpoGrupoPrecio"
Public Const cscEgpId                                 As String = "egp_id"
Public Const cscEgpNombre                             As String = "egp_nombre"
Public Const cscEgpCodigo                             As String = "egp_codigo"
Public Const cscEgpPosArancel                         As String = "egp_posarancel"

' ExpoGrupoPrecioIdioma
Public Const csTExpoGrupoPrecioIdioma                 As String = "ExpoGrupoPrecioIdioma"
Public Const cscEgpidmId                              As String = "egpidm_id"
Public Const cscEgpidmTexto                           As String = "egpidm_texto"

' ExpoGrupoPrecioPosAran
Public Const csTExpoGrupoPrecioPosAran                As String = "ExpoGrupoPrecioPosAran"
Public Const cscEgppaId                               As String = "egppa_id"
Public Const cscEgppaPosicion                         As String = "egppa_posicion"

' Idioma
Public Const cscIdmId                                   As String = "idm_id"
Public Const cscIdmNombre                               As String = "idm_nombre"

' Factura de Venta
Public Const csTFacturaVenta                            As String = "FacturaVenta"
Public Const cscFvId                                    As String = "fv_id"
Public Const cscFvNroDoc                                As String = "fv_nrodoc"

' Factura de Venta Expo
Public Const csTExpoFacturaVenta                      As String = "ExpoFacturaVenta"
Public Const cscEfvId                                 As String = "efv_id"
Public Const cscEfvTexto                              As String = "efv_texto"
Public Const cscEfvCodigo                             As String = "efv_codigo"
Public Const cscEfvUnidad                             As String = "efv_unidad"
Public Const cscEfvPosArancel                         As String = "efv_posarancel"
Public Const cscEfvTitulo                             As String = "efv_titulo"

' Leyenda
Public Const csTLeyenda                                 As String = "Leyenda"
Public Const cscLeyId                                   As String = "ley_id"
Public Const cscLeyTexto                                As String = "ley_texto"

'Cliente
Public Const cscCliId                                  As String = "cli_id"
Public Const cscCliNombre                              As String = "cli_nombre"

' Provincia
Public Const cscProId                           As String = "pro_id"
Public Const cscProNombre                       As String = "pro_nombre"

' Zona
Public Const cscZonId                           As String = "zon_id"
Public Const cscZonNombre                       As String = "zon_nombre"

' Pais
Public Const cscPaId                                 As String = "pa_id"
Public Const cscPaNombre                             As String = "pa_nombre"

' Packing List Expo
Public Const csTExpoPackingList                          As String = "ExpoPackingList"
Public Const cscEpklstId                                 As String = "epklst_id"
Public Const cscEpklstTexto                              As String = "epklst_texto"
Public Const cscEpklstCodigo                             As String = "epklst_codigo"
Public Const cscEpklstUnidad                             As String = "epklst_unidad"
Public Const cscEpklstPosArancel                         As String = "epklst_posarancel"
Public Const cscEpklstTitulo                             As String = "epklst_titulo"

' Packing List
Public Const csTPackingList                                As String = "PackingList"
Public Const cscPklstId                                    As String = "pklst_id"
Public Const cscPklstNroDoc                                As String = "pklst_nroDoc"

' Producto
Public Const cscPrId                                    As String = "pr_id"
Public Const cscPrNombreVenta                           As String = "pr_nombreventa"
