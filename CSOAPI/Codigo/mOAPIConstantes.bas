Attribute VB_Name = "mOAPIConstantes"
Option Explicit

'--------------------------------------------------------------------------------
' mOAPIConstantes
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
Public Const c_BAR_AVISO = "BAR_AVISO"

Public Const c_HelpFilterBeginLike = 1
Public Const c_HelpFilterHaveTo = 2
Public Const c_HelpFilterWildcard = 3
Public Const c_HelpFilterEndLike = 4
Public Const c_HelpFilterIsLike = 5

' Sucursal
Public Const cscSucId                           As String = "suc_id"
Public Const cscSucNombre                       As String = "suc_nombre"

' Tabla
Public Const csTTabla                                 As String = "Tabla"
Public Const cscTblId                                 As String = "tbl_id"
Public Const cscTblNombre                             As String = "tbl_nombre"
Public Const cscTblNombreFisico                       As String = "tbl_nombrefisico"
Public Const cscTblCampoId                            As String = "tbl_campoid"
Public Const cscTblCampoCodigo                        As String = "tbl_campocodigo"
Public Const cscTblSqlHelp                            As String = "tbl_sqlHelp"
Public Const cscTblSqlHelpCliente                     As String = "tbl_sqlHelpCliente"
Public Const cscTblSqlSearch                          As String = "tbl_sqlSearch"
Public Const cscTblSqlHelpWeb                         As String = "tbl_sqlHelpWeb"
Public Const cscTblTieneArbol                         As String = "tbl_tienearbol"
Public Const cscTblTieneActivo                        As String = "tbl_tieneActivo"
Public Const cscTblCampoNombre                        As String = "tbl_camponombre"
Public Const cscTblCamposInView                       As String = "tbl_camposinview"
Public Const cscTblCamposInViewCliente                As String = "tbl_camposInViewCliente"
Public Const cscTblWhere                              As String = "tbl_where"
Public Const cscTblHelpTop                            As String = "tbl_helpTop"
Public Const cscTblobjectEdit                         As String = "tbl_objectEdit"
Public Const cscTblobjectABM                          As String = "tbl_objectABM"
Public Const cscTblSPInfo                             As String = "tbl_spinfo"

' SysModuloTCP
Public Const csTsysModuloTCP                           As String = "sysModuloTCP"
Public Const cscSystObjetoinicializacion               As String = "syst_objetoinicializacion"
Public Const cscSystObjetoedicion                      As String = "syst_objetoedicion"
Public Const cscSystId                                 As String = "syst_id"
Public Const cscSystOrden                              As String = "syst_orden"

' Sysmodulo
Public Const cscsysmId                                 As String = "sysm_id"

' GridView
Public Const csTGridView                               As String = "GridView"
Public Const cscGrdvId                                 As String = "grdv_id"
Public Const cscGrdvNombre                             As String = "grdv_nombre"
Public Const cscGrdvDefault                            As String = "grdv_default"
Public Const cscGrdvPublica                            As String = "grdv_publica"
Public Const cscGrdvAutowidth                          As String = "grdv_autowidth"
Public Const cscGridName                               As String = "grid_name"
Public Const cscRptId                                  As String = "rpt_id"

' GridViewColumn
Public Const cscGrdvcId                                 As String = "grdvc_id"
Public Const cscGrdvcNombre                             As String = "grdvc_nombre"
Public Const cscGrdvcVisible                            As String = "grdvc_visible"
Public Const cscGrdvcWidth                              As String = "grdvc_width"
Public Const cscGrdvcIndex                              As String = "grdvc_index"

' GridViewGrupo
Public Const cscGrdvgId                                 As String = "grdvg_id"
Public Const cscGrdvgColumna                            As String = "grdvg_columna"
Public Const cscGrdvgIndice                             As String = "grdvg_indice"
Public Const cscGrdvgOrden                              As String = "grdvg_orden"

' GridViewFormula
Public Const cscGrdvfId                                 As String = "grdvf_id"
Public Const cscGrdvfColumna                            As String = "grdvf_columna"
Public Const cscGrdvfFormula                            As String = "grdvf_formula"

' GridViewFormato
Public Const cscGrdvfcId                                 As String = "grdvfc_id"
Public Const cscGrdvfcColumna                            As String = "grdvfc_columna"
Public Const cscGrdvfcColumna2                           As String = "grdvfc_columna2"
Public Const cscGrdvfcOperador                           As String = "grdvfc_operador"
Public Const cscGrdvfcValor                              As String = "grdvfc_valor"
Public Const cscGrdvfcBgColor                            As String = "grdvfc_bgColor"
Public Const cscGrdvfcFColor                             As String = "grdvfc_fColor"
Public Const cscGrdvfcFontName                           As String = "grdvfc_fontName"
Public Const cscGrdvfcFontSize                           As String = "grdvfc_fontSize"
Public Const cscGrdvfcFontStyle                          As String = "grdvfc_fontStyle"

' GridViewFiltro
Public Const cscGrdvfiId                                 As String = "grdvfi_id"
Public Const cscGrdvfiColumna                            As String = "grdvfi_columna"
Public Const cscGrdvfiColumna2                           As String = "grdvfi_columna2"
Public Const cscGrdvfiOperador                           As String = "grdvfi_operador"
Public Const cscGrdvfiValor                              As String = "grdvfi_valor"

' DocumentoTipo
Public Const cscDoctNombre                            As String = "doct_nombre"
Public Const cscDoctObject                            As String = "doct_object"

' Producto Help Config
Public Const cscPrhcNombre                            As String = "prhc_nombre"
Public Const cscPrhcTecla                             As String = "prhc_tecla"
Public Const cscPrhcId                                As String = "prhc_id"
Public Const cscPrhcDefault                           As String = "prhc_default"
Public Const cscPrhcDefaultSrv                        As String = "prhc_defaultsrv"
Public Const cscPrhcDefaultPrp                        As String = "prhc_defaultprp"
Public Const cscPrhcDefaultPrns                       As String = "prhc_defaultprns"

' Producto
Public Const cscPrId                                  As String = "pr_id"
