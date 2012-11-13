Attribute VB_Name = "mConstantes"
Option Explicit

' CONSTANTES PUBLICAS
Public Const csstrNew         As String = "(New)"

Public Const csNoDate          As Date = #1/1/1900#
Public Const csMaxDate         As Date = #12/31/9999#

Public Const csTEMP_BRANCH     As Long = -1000

Public Const KEY_NODO = "N"

Public Const cspSqlstmt = 127

Public Const c_foto_persona_chica = "foto_persona_chica_"

Public Const C_LoadFunction = "Load"
Public Const C_MenuClientInit = "cIMenuClient_Initialize"
Public Const C_ABMClientSave = "cIABMClient_Save"
Public Const C_CopiaDe = "C-"
Public Const C_C = "C-"
Public Const C_ShowDocDigital = "cIABMClient_ShowDocDigital"
Public Const C_pSaveItemsFunc = "pSaveItems"
Public Const C_StrColon = ","
Public Const C_ValidateRow = "cIABMClientGrid_ValidateRow"
Public Const C_EditGenericEdit = "cIEditGeneric_Edit"
Public Const C_IsEmptyRow = "cIABMClientGrid_IsEmptyRow"
Public Const C_EditGenericDelete = "cIEditGeneric_Delete"

Public Const c_HideCols = "HideCols"
Public Const c_filter_is_for_servicios = "@@IS_FOR_SERVICIOS@@"
Public Const c_filter_is_for_parte_rep = "@@IS_FOR_PARTE_REP@@"
Public Const c_filter_is_for_producto_serie = "@@IS_FOR_PRODUCTOSERIE@@"

Public Const C_TO_ComercialId As Long = 1

Public Const csDocChanged = -2
'///////////////////////////////////////////////////////////////
' Constantes de error y estructuras

Public Enum csTriLogicState
  csTLBoth = 2
  csTLYes = 1
  csTLNo = 0
End Enum

'///////////////////////////////////////////////////////////////
' Tipos de datos

'---------------------------------------------------------------
' Textos por Lenguaje
'

  ' Menus
  Public C_MenuStock            As String  ' "&Stock"
  Public C_MenuConfig           As String  ' "Co&nfiguración"
  Public C_MenuTesoreria        As String  ' "&Tesoreria"
  Public C_MenuGeneral          As String  ' "&General"
  Public C_MenuArticulos        As String  ' "&Articulos"
  Public C_MenuContabilidad     As String  ' "&Contabilidad"
  Public C_MenuVentas           As String  ' "Ve&ntas"
  Public C_MenuManejoPersonal   As String  ' "&Manejo de Personal"
  Public C_MenuSueldos          As String  ' "&Sueldos"
  Public C_MenuEdu              As String  ' "&Institutos Educativos"

  ' Textos genericos
  Public C_DebeIndicarNombre  As String  ' "Debe indicar un nombre"
  Public C_DebeIndicarCodigo  As String  ' "Debe indicar un código"
  Public C_strCodigo          As String  ' "Código"
  Public C_strNombre          As String  ' "Nombre"
  Public C_strActivo          As String  ' "Activo"
  Public C_strDescrip         As String  ' "Descripción"
  Public C_strGeneral         As String  ' "General"
  Public C_ErrorInSave        As String  ' "Error al grabar "
  Public C_TO_Comercial       As String  ' "Comercial"
  
'---------------------------------------------------------------

' Claves especiales para el Wizard
Public Const KW_CANCEL = -10

'MASCARAS
Public Const csMaskCuit         As String = "##-########-#"

'FORMATOS
Public Const csSqlDateString    As String = "\'yyyymmdd HH:nn:ss\'"
Public Const C_PSqlDateTime     As String = "\'yyyymmdd HH:nn:ss\'"
Public Const C_PSqlDate         As String = "\'yyyymmdd\'"

' Trees
Public Const cTreePrincipal         As Long = 1

' Clave genericas
Public Const c_FechaDesde = "FD"
Public Const c_FechaHasta = "FH"

' Logos
Public Const c_LogoChicoNombre = "LOGO CHICO"
Public Const c_LogoGrandeNombre = "LOGO GRANDE"
Public Const c_LogoChicoCodigo = "LOGOCHICO##"
Public Const c_LogoGrandeCodigo = "LOGOGRANDE##"

Public Const c_LogoTable = "LOGIC_TBL_LOGO"
Public Const c_LogoChicoTableID = 1
Public Const c_LogoGrandeTableID = 2

' Para codigos autogenerados
Public Const c_get_codigo_from_id = "(@@get_codigo_from_id@@)"

'---------------------------------------------------
' Wizard
Public Const c_Wiz_Key_Title = "T"
Public Const c_Wiz_Key_Descrip = "D"
Public Const c_Wiz_Key_ReadyToStart = "RDTS"

  ' Textos por Lenguaje
  '
  Public c_WizStr_Finish        As String  '"&Finalizar"
  Public c_WizStr_Next          As String  '"&Siguiente"
  Public c_WizStr_Back          As String  '"&Atras"
  Public c_WizStr_Cancel        As String  '"&Cancelar"
  Public c_WizStr_PrintDoc      As String  '"&Imprimir el documento [%1]"
  Public c_WizStr_NewDoc        As String  '"Crear un &nuevo documento"
  Public c_WizStr_CloseWizard   As String  '"&Cerrar el asistente"
  Public c_WizStr_NewDocDescrip As String  '"El documento ya se ha guardado, si desea puede crear uno nuevo, o cerrar el asistente."
  Public c_selectall            As String  '"Marcar Todas"
  Public c_unselectall          As String  '"Desmarcar Todas"
  
  Public c_selectall2           As String  '"Marcar Todos"
  Public c_unselectall2         As String  '"Desmarcar Todos"
  
  Public c_aplicarprecio        As String  '"Aplicar precio a todos"
  Public c_aplicarpreciocero    As String  '"Aplicar precio a cero"
  
'---------------------------------------------------

Public Const c_Wiz_Key_PrintDoc = "WIZ_PRINTDOC"
Public Const c_Wiz_Key_CloseWizard = "WIZ_CLOSE"
Public Const c_Wiz_Key_NewDoc = "WIZ_NEWDOC"
Public Const c_Wiz_Key_NewItems = "WIZ_NEWITEMS"
Public Const c_Wiz_Key_TotalNewItems = "TotalNewItems"
Public Const c_Wiz_Key_InternosNewItems = "InternosNewItems"
Public Const c_Wiz_Key_NetoNewItems = "NetoNewItems"
Public Const c_Wiz_Key_IvaNewItems = "IvaNewItems"
Public Const c_Wiz_Key_ActionButton = "WIZ_BUTTON_ACTION"
Public Const c_Wiz_Key_ActionButtonAuto = "WIZ_BUTTON_ACTION_AUTO"
Public Const c_Wiz_Key_ActionCancelAuto = "WIZ_BUTTON_CANCEL_AUTO"

Public Const KW_PRINT_DOC = -20
Public Const KW_NEW_DOC = -21
Public Const KW_CLOSE_WIZARD = -22
Public Const KW_ACTION_BUTTON_DOC = -23
Public Const KW_ACTION_BUTTON_DOC_AUTO = -24
Public Const KW_ACTION_BUTTON_DOC_CANCEL_AUTO = -25

Public Const c_Wiz_Key_MainTitle = "WIZ_MAIN_TITLE"

'///////////////////////////////////////////////////////////////
' Campos de las Tablas

' Generics
Public Const cscModificado                      As String = "modificado"
Public Const cscCreado                          As String = "creado"
Public Const cscActivo                          As String = "activo"
Public Const cscModifico                        As String = "modifico"

' Id
Public Const csTId                              As String = "Id"
Public Const cscIdTabla                         As String = "Id_Tabla"
Public Const cscIdNextId                        As String = "Id_NextId"
Public Const cscIdCampoId                       As String = "Id_campodId"

' Usuario
Public Const csTusuario                         As String = "Usuario"
Public Const cscUsId                            As String = "us_id"
Public Const cscUsNombre                        As String = "us_nombre"
Public Const cscUsClave                         As String = "us_clave"
Public Const cscUsDescrip                       As String = "us_descrip"
Public Const cscUsExterno                       As String = "us_externo"
Public Const cscUsEmpXDpto                      As String = "us_empxdpto"
Public Const cscUsEmpresaEx                     As String = "us_empresaex"

' Configuracion
Public Const csTConfiguracion                         As String = "Configuracion"
Public Const cscCfgGrupo                              As String = "cfg_grupo"
Public Const cscCfgAspecto                            As String = "cfg_aspecto"
Public Const cscCfgValor                              As String = "cfg_valor"

' Rol
Public Const csTRol                             As String = "Rol"
Public Const cscRolId                           As String = "rol_id"
Public Const cscRolNombre                       As String = "rol_nombre"
Public Const cscRolDescrip                      As String = "rol_descrip"

' usuarioRol
Public Const csTusuarioRol                      As String = "usuarioRol"

' Prestacion
Public Const csTPrestacion                      As String = "Prestacion"
Public Const cscPreID                           As String = "pre_id"
Public Const cscPreNombre                       As String = "pre_nombre"
Public Const cscPreGrupo                        As String = "pre_grupo"

' ListaDocumentoParametro
Public Const csTListaDocumentoParametro                As String = "ListaDocumentoParametro"
Public Const cscLdpId                                  As String = "ldp_id"
Public Const cscLdpValor                               As String = "ldp_valor"
Public Const cscLdpOrden                               As String = "ldp_orden"

' Edicion de documentos
Public Const cscDocEditable                            As String = "Editable"
Public Const cscDoceditMsg                             As String = "editMsg"
Public Const cscTa_Propuesto                           As String = "TaPropuesto"
Public Const cscTa_Mascara                             As String = "TaMascara"

' Empresa
Public Const csTEmpresa                               As String = "Empresa"
Public Const cscEmpId                                 As String = "emp_id"
Public Const cscEmpNombre                             As String = "emp_nombre"
Public Const cscEmpCodigo                             As String = "emp_codigo"
Public Const cscEmpCodigoBarra                        As String = "emp_codigobarra"
Public Const cscEmpEsSucursal                         As String = "emp_essucursal"

#If PREPROC_CSOAPI Then

' Arbol
Public Const csTArbol                           As String = "Arbol"
Public Const cscArbId                           As String = "arb_Id"
Public Const cscArbNombre                       As String = "arb_nombre"

' Rama
Public Const csTRama                            As String = "Rama"
Public Const cscRamId                           As String = "ram_id"
Public Const cscRamNombre                       As String = "ram_nombre"
Public Const cscRamPadre                        As String = "ram_id_padre"
Public Const cscRamOrden                        As String = "ram_orden"

' RamaConfig
Public Const csTramaConfig                      As String = "RamaConfig"
Public Const cscRamcAspecto                     As String = "ramc_aspecto"
Public Const cscRamcValor                       As String = "ramc_valor"

' Aspectos de la Tabla ramaConfig
Public Const csAspecto_FieldsInView             As String = "Fields"
Public Const csAspecto_TablesInView             As String = "Tables"
Public Const csAspecto_PrefixInView             As String = "Prefix"

' Hoja
Public Const csTHoja                            As String = "Hoja"
Public Const cscHojaId                          As String = "hoja_Id"
Public Const cscId                              As String = "id"

' permiso
Public Const csTPermiso                         As String = "Permiso"
Public Const cscPerId                           As String = "per_id"
Public Const cscPerIdPadre                      As String = "per_id_padre"

#End If

#If PREPROC_AUX Then


' Estado
Public Const csTEstado                                As String = "Estado"
Public Const cscEstId                                 As String = "est_id"
Public Const cscEstNombre                             As String = "est_nombre"
Public Const cscEstCodigo                             As String = "est_codigo"
Public Const cscEstDescrip                            As String = "est_descrip"

#End If

#If PREPROC_FORMULARIOS Then
  
  ' ReporteFormulario
  Public Const csTReporteFormulario                      As String = "ReporteFormulario"
  Public Const cscrptfId                                 As String = "rptf_id"
  Public Const cscrptfNombre                             As String = "rptf_nombre"
  Public Const cscrptfCsrfile                            As String = "rptf_csrfile"
  Public Const cscrptfTipo                               As String = "rptf_tipo"
  Public Const cscrptfSugerido                           As String = "rptf_sugerido"
  Public Const cscrptfSugeridoEmail                      As String = "rptf_sugeridoemail"
  Public Const cscrptfCopias                             As String = "rptf_copias"
  Public Const cscrptfDocImprimirEnAlta                  As String = "rptf_docImprimirEnAlta"
  Public Const cscrptfObject                             As String = "rptf_object"

#End If

Public Function Val(ByVal Value As String) As Double
  Dim SepDecimal As String
  SepDecimal = GetSepDecimal()
  
  ' Despues de 10 años de programar en VB me encuentro
  ' que val si le pasas un % da un type mismatch
  ' quien diria ???
  ' por ende se lo saco y a otra cosa
  Value = Replace(Value, "%", vbNullString)
  
  Value = Replace(Value, SepDecimal, ".")
  Val = VBA.Val(Value)
End Function

' Round en visual asume 0.5 a 0 y format asume 0.5 a 1 asi que
' implemento round como format y listo
Public Function Round(ByVal Number As Variant, ByVal NumberDigitsAfterDecimal As Long) As Double
  Dim strdecimals As String
  If Not IsNumeric(Number) Then
    Round = 0
  Else
    strdecimals = "0." & String$(NumberDigitsAfterDecimal, "0")
    Round = Val(Format(Number, strdecimals))
  End If
End Function

Public Sub LNGLoadLenguaje()

  ' Menus
  C_MenuStock = LNGGetText(1052, vbNullString)             ' "&Stock"
  C_MenuConfig = LNGGetText(1028, vbNullString)            ' "Co&nfiguración"
  C_MenuTesoreria = LNGGetText(1029, vbNullString)         ' "&Tesoreria"
  C_MenuGeneral = LNGGetText(1030, vbNullString)           ' "&General"
  C_MenuArticulos = LNGGetText(1031, vbNullString)         ' "&Articulos"
  C_MenuContabilidad = LNGGetText(1032, vbNullString)      ' "&Contabilidad"
  C_MenuVentas = LNGGetText(1033, vbNullString)            ' "Ve&ntas"
  C_MenuManejoPersonal = LNGGetText(3972, vbNullString)    ' "&Manejo de Personal"
  C_MenuSueldos = LNGGetText(3973, vbNullString)           ' "&Sueldos"
  C_MenuEdu = LNGGetText(4667, vbNullString)               ' "&Institutos Educativos

  ' Textos Genericos
  C_DebeIndicarNombre = LNGGetText(1007, vbNullString)     ' "Debe indicar un nombre"
  C_DebeIndicarCodigo = LNGGetText(1008, vbNullString)     ' "Debe indicar un código"
  C_strCodigo = LNGGetText(1009, vbNullString)             ' "Código"
  C_strNombre = LNGGetText(1010, vbNullString)             ' "Nombre"
  C_strActivo = LNGGetText(1011, vbNullString)             ' "Activo"
  C_strDescrip = LNGGetText(1012, vbNullString)            ' "Descripción"
  C_strGeneral = LNGGetText(1027, vbNullString)            ' "General"
  C_ErrorInSave = LNGGetText(1013, vbNullString)           ' "Error al grabar "
  C_TO_Comercial = LNGGetText(1014, vbNullString)          ' "Comercial"
  
  ' Wizard
  c_WizStr_Finish = LNGGetText(1015, vbNullString)         ' "&Finalizar"
  c_WizStr_Next = LNGGetText(1016, vbNullString)           ' "&Siguiente"
  c_WizStr_Back = LNGGetText(1017, vbNullString)           ' "&Atras"
  c_WizStr_Cancel = LNGGetText(1018, vbNullString)         ' "&Cancelar"
  c_WizStr_PrintDoc = LNGGetText(1019, vbNullString)       ' "&Imprimir el documento [%1]"
  c_WizStr_NewDoc = LNGGetText(1020, vbNullString)         ' "Crear un &nuevo documento"
  c_WizStr_CloseWizard = LNGGetText(1021, vbNullString)    ' "&Cerrar el asistente"
  c_WizStr_NewDocDescrip = LNGGetText(1022, vbNullString)  ' "El documento ya se ha guardado, si desea puede crear uno nuevo, o cerrar el asistente."
  c_selectall = LNGGetText(1023, vbNullString)             ' "Marcar Todas"
  c_unselectall = LNGGetText(1024, vbNullString)           ' "Desmarcar Todas"
  
  c_selectall2 = LNGGetText(4870, vbNullString)            ' "Marcar Todos"
  c_unselectall2 = LNGGetText(4886, vbNullString)          ' "Desmarcar Todos"
  
  c_aplicarprecio = LNGGetText(1025, vbNullString)         ' "Aplicar precio a todos"
  c_aplicarpreciocero = LNGGetText(1026, vbNullString)     ' "Aplicar precio a cero"
  
End Sub
