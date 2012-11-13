Attribute VB_Name = "mCVXIConstantes"
Option Explicit

'--------------------------------------------------------------------------------
' mLenguajeConstantes
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
Private Const C_Module = "mCVXIConstantes"

Public Const csEstado = 4005

' Respuesta Plantilla
Public Const csTComunidadInternetRespuestaPlantilla     As String = "ComunidadInternetRespuestaPlantilla"
Public Const cscCmirpId                                 As String = "cmirp_id"
Public Const cscCmirpNombre                             As String = "cmirp_nombre"
Public Const cscCmirpCodigo                             As String = "cmirp_codigo"
Public Const cscCmirpTexto                              As String = "cmirp_texto"
Public Const cscCmirpDescrip                            As String = "cmirp_descrip"
Public Const cscCmirpFrom                               As String = "cmirp_from"
Public Const cscCmirpSubject                            As String = "cmirp_subject"

' Comunidad Internet
Public Const csTComunidadInternet                     As String = "ComunidadInternet"
Public Const cscCmiId                                 As String = "cmi_id"
Public Const cscCmiNombre                             As String = "cmi_nombre"
Public Const cscCmiCodigo                             As String = "cmi_codigo"
Public Const cscCmiDescrip                            As String = "cmi_descrip"

' Aplicacion
Public Const csTComunidadInternetAplicacion           As String = "ComunidadInternetAplicacion"
Public Const cscCmiaId                                As String = "cmia_id"
Public Const cscCmiaNombre                            As String = "cmia_nombre"
Public Const cscCmiaCodigo                            As String = "cmia_codigo"
Public Const cscCmiaActivexobject                     As String = "cmia_activexobject"
Public Const cscCmiaDescrip                           As String = "cmia_descrip"

' Idioma
Public Const csTIdioma                                As String = "Idioma"
Public Const cscIdmId                                 As String = "idm_id"
Public Const cscIdmNombre                             As String = "idm_nombre"

' Producto
Public Const csTProducto                              As String = "Producto"
Public Const cscPrId                                  As String = "pr_id"
Public Const cscPrNombreVenta                         As String = "pr_nombreventa"

' Lista Precio
Public Const csTListaPrecio                           As String = "ListaPrecio"
Public Const cscLpId                                  As String = "lp_id"
Public Const cscLpNombre                              As String = "lp_nombre"

' Lista Descuento
Public Const csTListaDescuento                        As String = "ListaDescuento"
Public Const cscLdId                                  As String = "ld_id"
Public Const cscLdNombre                              As String = "ld_nombre"

' Documento
Public Const csTDocumento                             As String = "Documento"
Public Const cscDocId                                 As String = "doc_id"
Public Const cscDocNombre                             As String = "doc_nombre"

' Sucursal
Public Const csTSucursal                              As String = "Sucursal"
Public Const cscSucId                                 As String = "suc_id"
Public Const cscSucNombre                             As String = "suc_nombre"

' Rubro
Public Const csTRubro                                 As String = "Rubro"
Public Const cscRubId                                 As String = "rub_id"
Public Const cscRubNombre                             As String = "rub_nombre"

' Marca
Public Const csTMarca                                 As String = "Marca"
Public Const cscMarcId                                As String = "marc_id"
Public Const cscMarcNombre                            As String = "marc_nombre"

' Comunidad Internet Texto
Public Const csTComunidadInternetTexto                  As String = "ComunidadInternetTexto"
Public Const cscCmitId                                  As String = "cmit_id"
Public Const cscCmitNombre                              As String = "cmit_nombre"
Public Const cscCmitCodigo                              As String = "cmit_codigo"
Public Const cscCmitDescrip                             As String = "cmit_descrip"


' Comunidad Internet Texto Item
Public Const csTComunidadInternetTextoItem              As String = "ComunidadInternetTextoItem"
Public Const cscCmitiId                                 As String = "cmiti_id"
Public Const cscCmitiNombre                             As String = "cmiti_nombre"
Public Const cscCmitiCodigo                             As String = "cmiti_codigo"
Public Const cscCmitiTexto                              As String = "cmiti_texto"
Public Const cscCmitiTienevalor                         As String = "cmiti_tienevalor"
Public Const cscCmitiDelimitador                        As String = "cmiti_delimitador"
Public Const cscCmitiCodigomacro                        As String = "cmiti_codigomacro"
Public Const cscCmitiBooleano                           As String = "cmiti_booleano"
Public Const cscCmitiIdPadre                            As String = "cmiti_id_padre"
Public Const cscCmitiOrden                              As String = "cmiti_orden"

' Cliente
Public Const csTCliente                                As String = "Cliente"
Public Const cscCliId                                  As String = "cli_id"
Public Const cscCliNombre                              As String = "cli_nombre"

' Estado
Public Const csTEstado                                As String = "Estado"
Public Const cscEstId                                 As String = "est_id"
Public Const cscEstNombre                             As String = "est_nombre"

' Comunidad Internet Email Account
Public Const csTComunidadInternetEmailAccount           As String = "ComunidadInternetEmailAccount"
Public Const cscCmieaId                                 As String = "cmiea_id"
Public Const cscCmieaNombre                             As String = "cmiea_nombre"
Public Const cscCmieaEmail_server                       As String = "cmiea_email_server"
Public Const cscCmieaEmail_user                         As String = "cmiea_email_user"
Public Const cscCmieaEmail_pwd                          As String = "cmiea_email_pwd"
Public Const cscCmieaServer                             As String = "cmiea_server"
Public Const cscCmieaUser                               As String = "cmiea_user"
Public Const cscCmieaPwd                                As String = "cmiea_pwd"

' Comunidad Internet Email
Public Const csTComunidadInternetMail                  As String = "ComunidadInternetMail"
Public Const cscCmieId                                 As String = "cmie_id"
Public Const cscCmieAccount                            As String = "cmie_account"
Public Const cscCmieMailid                             As String = "cmie_mailid"
Public Const cscCmieFromname                           As String = "cmie_fromname"
Public Const cscCmieFromaddress                        As String = "cmie_fromaddress"
Public Const cscCmieTo                                 As String = "cmie_to"
Public Const cscCmieSubject                            As String = "cmie_subject"
Public Const cscCmieBody_html                          As String = "cmie_body_html"
Public Const cscCmieBody_plain                         As String = "cmie_body_plain"
Public Const cscCmieBody_mime                          As String = "cmie_body_mime"
Public Const cscCmieSubject_mime                       As String = "cmie_subject_mime"
Public Const cscCmieHeader_mime                        As String = "cmie_header_mime"
Public Const cscCmieBody_updated                       As String = "cmie_body_updated"
Public Const cscCmieDate                               As String = "cmie_date"

' Comunidad Internet Producto
Public Const csTComunidadInternetProducto              As String = "ComunidadInternetProducto"
Public Const cscCmiprId                                As String = "cmipr_id"
Public Const cscCmiprNombre                            As String = "cmipr_nombre"
Public Const cscCmiprCodigo                            As String = "cmipr_codigo"
Public Const cscCmiprVentas                            As String = "cmipr_ventas"
Public Const cscCmiprVisitas                           As String = "cmipr_visitas"
Public Const cscCmiprOfertas                           As String = "cmipr_ofertas"
Public Const cscCmiprDisponible                        As String = "cmipr_disponible"
Public Const cscCmiprFinaliza                          As String = "cmipr_finaliza"
Public Const cscCmiprReposicion                        As String = "cmipr_reposicion"

' Sucursal
Public Const csTDepositoLogico                        As String = "DepositoLogico"
Public Const cscDeplId                                As String = "depl_id"
Public Const cscDeplNombre                            As String = "depl_nombre"

' Comunidad Internet Pregunta
Public Const csTComunidadInternetPregunta              As String = "ComunidadInternetPregunta"
Public Const cscCmipId                                 As String = "cmip_id"
Public Const cscCmipPreguntaid                         As String = "cmip_preguntaid"
Public Const cscCmipNick                               As String = "cmip_nick"
Public Const cscCmipPregunta                           As String = "cmip_pregunta"
Public Const cscCmipRespuesta                          As String = "cmip_respuesta"
Public Const cscCmipFecha                              As String = "cmip_fecha"
Public Const cscCmipFechaRespuesta                     As String = "cmip_fecha_respuesta"
Public Const cscCmipArticuloid                         As String = "cmip_articuloid"
Public Const cscCmipArticulo                           As String = "cmip_articulo"
Public Const cscCmipDescrip                            As String = "cmip_descrip"
Public Const cscUsIdRespondio                          As String = "us_id_respondio"
