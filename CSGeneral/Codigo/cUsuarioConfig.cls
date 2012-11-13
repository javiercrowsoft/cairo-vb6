VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cUsuarioConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cUsuarioConfig
' 07-06-2006

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cUsuarioConfig"

Private Const csEstado = 4005
Private Const csTblLenguaje = 14000
Private Const csTblDocumento = 4001
Private Const cscDeplNombre = "depl_nombre"

Private Const K_INFORMAR_ANTICIPOS = 1
Private Const K_DOC_ID_PREV = 2
Private Const K_DOC_ID_PV = 3
Private Const K_DOC_ID_RV = 4
Private Const K_DOC_ID_RV_C = 104
Private Const K_DOC_ID_FV = 5
Private Const K_DOC_ID_COBZ = 106
Private Const K_DOC_ID_OS = 100
Private Const K_DOC_ID_PRP = 101
Private Const K_PTD_FECHAINI = 102
Private Const K_USE_PRINTER_SIZE = 103

Private Const K_DOC_ID_PC = 6
Private Const K_DOC_ID_PREC = 7
Private Const K_DOC_ID_COT = 8
Private Const K_DOC_ID_OC = 9
Private Const K_DOC_ID_RC = 10
Private Const K_DOC_ID_FC = 11

Private Const K_DOC_ID_MF = 20
Private Const K_DOC_ID_DBCO = 21

Private Const K_DOC_ID_LIQ = 22

Private Const K_DEPL_ID = 12
Private Const K_DEPL_ID_SRV = 14

Private Const K_DESKTOP = 13
Private Const K_LENGUAJE = 200
Private Const K_AUTOSIZECOLS = 202
Private Const K_MULTISELECT = 203
Private Const K_SHOWSAVEAS = 204
Private Const K_SHOW_ALL_IN_WIZARD = 205
Private Const K_FOLDER_TO_EXPORT_PDF = 206

Private Const K_CLIENTEXDEFECTO = 305
Private Const K_CUENTAFVOXDEFECTO = 306
Private Const K_NUEVOALGRABAR = 307
Private Const K_NUEVOPTDALGRABAR = 311

Private Const K_PRINT_IN_NEW_FV = 312
Private Const K_PRINT_IN_NEW_COBZ_CDO = 313

Private Const K_CLOSE_WIZARD = 24
Private Const K_NO_ASK_IN_PRINT = 25

Private Const K_SHOWBARCODEINPUTCTRLS = 201

Private Const K_SHOWDATAADIC_IN_VENTAS = 308
Private Const K_SHOWDATAADIC_IN_COMPRAS = 309

Private Const K_PARTE_REPARACION_ESTADO_DEFAULT = 310

Private Const K_VIEW_NAMES_IN_TOOLBAR = 320

Private Const K_ESTADO_EN_HOJA_RUTA = 330
Private Const K_ESTADO_EN_PICKING_LIST = 331

Private Const K_DEBE_HABER_MF = 350

Private Const K_USAR_COLORES_EN_DOCUMENTOS = 351

Private Const K_PICKINLIST_DOC_ID_FACTURA      As Integer = 360
Private Const K_PICKINLIST_DOC_ID_INTERNO      As Integer = 361

' Color en Empresa
'
Private Const K_COLOR_BACKGROUND               As Integer = 370

Private Enum csUCModule
  csUCCompras = 1
  csUCStock = 2
  csUCVentas = 3
  csUCGeneral = 4
  csUCTesoreria = 5
  csUCServicios = 6
  csUCPersonal = 7
End Enum

' Ventas
Private Const c_GrupoUsuarioConfig = "Usuario-Config"
Private Const c_InformarAnticipos = "Informar Anticipos"

Private Const c_ClienteXDefecto = "Cliente por Defecto"
Private Const c_CuentaFvoXDefecto = "Cuenta Efvo x Defecto"
Private Const c_NuevoAlGrabar = "Nuevo al Grabar"
Private Const c_ShowDataAddInVentas = "Mostrar Data en Ventas"
Private Const c_ShowDataAddInCompras = "Mostrar Data en Compras"

Private Const c_NuevoPTDAlGrabar = "Nuevo PTD al Grabar"
Private Const c_PrintInNewFV = "Imprimir en Nueva Factura"
Private Const c_PrintInNewCobzCdo = "Imprimir en Cobranza Cdo"

Private Const c_EstadoHojaRuta = "Estado en Hoja de Ruta"
Private Const c_EstadoPickingList = "Estado en Picking List"

Private Const c_CloseWizard = "Cerrar el Asistente al Finalizar"
Private Const c_NoAskInPrint = "No Pedir Confirmar al Imprimir"

' Documentos de Venta
Private Const c_DocPREV = "Documento de Presupuesto"
Private Const c_DocPV = "Documento de Pedido"
Private Const c_DocRV = "Documento de Remito"
Private Const c_DocFV = "Documento de Factura"
Private Const c_DocCobz = "Documento de Cobranza Contado"

Private Const c_DocRV_C = "Documento Cancelacion de Remito"

' Documentos de Compras
Private Const c_DocPC = "Documento de Pedido"
Private Const c_DocPREC = "Documento de Presupuesto"
Private Const c_DocOC = "Documento de Orden de Compra"
Private Const c_DocCOT = "Documento de Cotizacion"
Private Const c_DocRC = "Documento de Remito"
Private Const c_DocFC = "Documento de Factura"

' Documentos de Tesoreria
Private Const c_DocMF = "Documento de Movimiento de Fondos"
Private Const c_DocDBCO = "Documento de Deposito Bancario"
Private Const c_DebeHaberMF = "Usar Debe Haber en Movimiento de Fondos"

' Documentos de Servicios
Private Const c_DocOS = "Documento de Orden de Servicios"
Private Const c_DocPRP = "Documento de Parte de Reparacion"
Private Const c_PrpEstadoDef = "Usar Rep. y Aprob. x Defecto en P.Rep."

' Documentos de Tesoreria
Private Const c_DocLIQ = "Documento de Liquidacion"

' Picking List
Private Const c_PklDocFactura = "Documento Factura Despachos"
Private Const c_PklDocInterno = "Documento Interno Despachos"

' Fechas en Parte Diario
Private Const c_PtdFecha = "Cambiar Fecha Fin en Partes Diarios"

' Usar el tamaño de papel que reporta la impresora
Private Const c_UsePrinterSize = "Usar el Tamaño de Papel que Reporta la Impresora"

' Stock
Private Const c_Depl = "Deposito"
Private Const c_DeplSrv = "Deposito Servicios"

' Lenguaje
Private Const c_Lenguaje = "Lenguaje"

' Escritorio
Private Const c_Desktop = "Escritorio"

' AutoSizeCols
Private Const c_AutoSizeCols = "Autoajustar Columnas"

' Multi select
Private Const c_MultiSelect = "Usar Multiple Seleccion"

' Lectora de Codigo de Barras
Private Const c_showBarcodeInputCtrls = "Mostar Controles para Codigos de Barras"

Private Const c_ViewNamesInToolbar = "Ver Nombre en Toolbar"

' SaveAs
Private Const c_ShowSaveAs = "Mostrar Guardar Como"

' Show all in wizard
Private Const c_ShowAllInWizard = "Mostrar todos los comprobantes en asistentes"

' Folder to export
Private Const c_FolderToExportPDF = "Carpeta destino de exportación PDF"

' Colors in Doc Windows
Private Const c_UsarColoresEnDoc = "Usar colores en doc"

' Colores en Empresas
Private Const c_ColorEnEmpresa = "Color Empresa"

' estructuras
' Seudo - Variables
Private c_ErrorSave                   As String

' variables privadas
Private m_InformarAnticipos           As Boolean

Private m_doc_id_pc                   As Long
Private m_DocPCNombre                 As String
Private m_doc_id_prec                 As Long
Private m_DocPRECNombre               As String
Private m_doc_id_cot                  As Long
Private m_DocCOTNombre                As String
Private m_doc_id_oc                   As Long
Private m_DocOCNombre                 As String
Private m_doc_id_rc                   As Long
Private m_DocRCNombre                 As String
Private m_doc_id_fc                   As Long
Private m_DocFCNombre                 As String

Private m_leng_id                     As Long
Private m_LengNombre                  As String
Private m_AutoSizeCols                As Boolean
Private m_MultiSelect                 As Boolean
Private m_UsePrinterSize              As Boolean
Private m_ShowSaveAs                  As Boolean
Private m_ShowAllInWizard             As Boolean
Private m_FolderToExportPDF           As String

Private m_depl_id                     As Long
Private m_DeplNombre                  As String
Private m_deplRam_id                  As String

Private m_depl_id_srv                 As Long
Private m_DeplNombreSrv               As String
Private m_deplRam_id_srv              As String

Private m_doc_id_prev                 As Long
Private m_DocPREVNombre               As String
Private m_doc_id_pv                   As Long
Private m_DocPVNombre                 As String
Private m_doc_id_rv                   As Long
Private m_DocRVNombre                 As String
Private m_doc_id_rv_C                 As Long
Private m_DocRVNombre_C               As String
Private m_doc_id_fv                   As Long
Private m_DocFVNombre                 As String
Private m_doc_id_cobz                 As Long
Private m_DocCobzNombre               As String

Private m_doc_id_os                   As Long
Private m_DocOSNombre                 As String
Private m_doc_id_prp                  As Long
Private m_DocPRPNombre                As String

Private m_doc_id_liq                  As Long
Private m_DocLIQNombre                As String

Private m_pkl_doc_id_factura          As Long
Private m_PklDocFactura               As String

Private m_pkl_doc_id_interno          As Long
Private m_PklDocInterno               As String

Private m_ptdFecha                    As Boolean

Private m_PrpEstadoDef  As Boolean

Private m_doc_id_mf                   As Long
Private m_DocMFNombre                 As String
Private m_doc_id_dbco                 As Long
Private m_DocDBCONombre               As String
Private m_debe_haber_mf               As Boolean

Private m_Desktop                     As String

Private m_showBarcodeInputCtrls       As Boolean

Private m_cli_id_xdefecto         As Long
Private m_ClienteXDefecto         As String

Private m_cue_id_FvoxDefecto      As Long
Private m_CuentaFvoxDefecto       As String

Private m_NuevoAlGrabar           As Boolean
Private m_PrintInNewFV            As Boolean
Private m_PrintInNewCobzCdo       As Boolean
Private m_CloseWizard             As Boolean
Private m_NoAskInPrint            As Boolean

Private m_ShowDataAddInVentas     As Boolean
Private m_ShowDataAddInCompras    As Boolean

Private m_NuevoPTDAlGrabar        As Boolean

Private m_ViewNamesInToolbar      As Boolean
Private m_UsarColoresEnDocumentos As Boolean

Private m_est_id_hojaRuta         As String
Private m_estadoHojaRuta          As String

Private m_est_id_pickinglist      As String
Private m_estadoPickingList       As String

Private m_ColorEnEmpresa          As Long

Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric

' eventos
' propiedades publicas
Public Property Get ShowBarcodeInputCtrls() As Boolean
  ShowBarcodeInputCtrls = m_showBarcodeInputCtrls
End Property

Public Property Get InformarAnticipos() As Boolean
   InformarAnticipos = m_InformarAnticipos
End Property

Public Property Get DocPreeId() As Long

End Property

Public Property Get DocAsId() As Long

End Property

Public Property Get DocStId() As Long

End Property

Public Property Get DocRsId() As Long

End Property

Public Property Get DocPpkId() As Long

End Property

Public Property Get DocOpkId() As Long

End Property

Public Property Get DocPembId() As Long

End Property

Public Property Get DocMfcId() As Long
  
End Property

Public Property Get DocImptId() As Long

End Property

Public Property Get DocPklstId() As Long

End Property

Public Property Get DocDbcoId() As Long
  DocDbcoId = m_doc_id_dbco
End Property

Public Property Get DocDcupId() As Long

End Property

Public Property Get DocMfId() As Long
  DocMfId = m_doc_id_mf
End Property

Public Property Get DocPcId() As Long
  DocPcId = m_doc_id_pc
End Property

Public Property Get DocPrecId() As Long
  DocPrecId = m_doc_id_prec
End Property

Public Property Get DocCotId() As Long
  DocCotId = m_doc_id_cot
End Property

Public Property Get DocOcId() As Long
  DocOcId = m_doc_id_oc
End Property

Public Property Get DocRcId() As Long
  DocRcId = m_doc_id_rc
End Property

Public Property Get DocFcId() As Long
  DocFcId = m_doc_id_fc
End Property

Public Property Get DocPrevId() As Long
  DocPrevId = m_doc_id_prev
End Property

Public Property Get DocPvId() As Long
  DocPvId = m_doc_id_pv
End Property

Public Property Get DocRvId() As Long
  DocRvId = m_doc_id_rv
End Property

Public Property Get DocRvId_C() As Long
  DocRvId_C = m_doc_id_rv_C
End Property

Public Property Get DocFvId() As Long
  DocFvId = m_doc_id_fv
End Property

Public Property Get PklDocIdFactura() As Long
  PklDocIdFactura = m_pkl_doc_id_factura
End Property

Public Property Get PklDocIdInerno() As Long
  PklDocIdInerno = m_pkl_doc_id_interno
End Property

Public Property Get DocCobzId() As Long
  DocCobzId = m_doc_id_cobz
End Property

Public Property Get DocOsId() As Long
  DocOsId = m_doc_id_os
End Property

Public Property Get DocPrpId() As Long
  DocPrpId = m_doc_id_prp
End Property

Public Property Get DocLIQId() As Long
  DocLIQId = m_doc_id_liq
End Property

Public Property Get PtdFecha() As Boolean
  PtdFecha = m_ptdFecha
End Property

Public Property Get PrpEstadoDef() As Boolean
  PrpEstadoDef = m_PrpEstadoDef
End Property

Public Property Get DeplId() As Long
  DeplId = m_depl_id
End Property

Public Property Get DeplIdSrv() As Long
  DeplIdSrv = m_depl_id_srv
End Property

Public Property Get LengId() As Long
  LengId = m_leng_id
End Property

Public Property Get AutoSizeCols() As Boolean
  AutoSizeCols = m_AutoSizeCols
End Property

Public Property Get MultiSelect() As Boolean
  MultiSelect = m_MultiSelect
End Property

Public Property Get UsePrinterSize() As Boolean
  UsePrinterSize = m_UsePrinterSize
End Property

Public Property Get ShowSaveAs() As Boolean
  ShowSaveAs = m_ShowSaveAs
End Property

Public Property Get ShowAllInWizard() As Boolean
  ShowAllInWizard = m_ShowAllInWizard
End Property

Public Property Get DeplRamId() As String
  DeplRamId = m_deplRam_id
End Property

Public Property Get DeplRamIdSrv() As String
  DeplRamIdSrv = m_deplRam_id_srv
End Property

Public Property Get DocPreeNombre() As String

End Property

Public Property Get DocAsNombre() As String

End Property

Public Property Get DocStNombre() As String

End Property

Public Property Get DocRsNombre() As String

End Property

Public Property Get DocPpkNombre() As String

End Property

Public Property Get DocOpkNombre() As String

End Property

Public Property Get DocPembNombre() As String

End Property

Public Property Get DocMfcNombre() As String

End Property

Public Property Get DocImptNombre() As String

End Property

Public Property Get DocPklstNombre() As String

End Property

Public Property Get DocDbcoNombre() As String
  DocDbcoNombre = m_DocDBCONombre
End Property

Public Property Get DocDcupNombre() As String

End Property

Public Property Get DocMfNombre() As String
  DocMfNombre = m_DocMFNombre
End Property

Public Property Get DocPcNombre() As String
  DocPcNombre = m_DocPCNombre
End Property

Public Property Get DocPrecNombre() As String
  DocPrecNombre = m_DocPRECNombre
End Property

Public Property Get DocCotNombre() As String
  DocCotNombre = m_DocCOTNombre
End Property

Public Property Get DocOcNombre() As String
  DocOcNombre = m_DocOCNombre
End Property

Public Property Get DocRcNombre() As String
  DocRcNombre = m_DocRCNombre
End Property

Public Property Get DocFcNombre() As String
  DocFcNombre = m_DocFCNombre
End Property

Public Property Get DocPrevNombre() As String
  DocPrevNombre = m_DocPREVNombre
End Property

Public Property Get DocPvNombre() As String
  DocPvNombre = m_DocPVNombre
End Property

Public Property Get DocRvNombre() As String
  DocRvNombre = m_DocRVNombre
End Property

Public Property Get DocRvNombre_C() As String
  DocRvNombre_C = m_DocRVNombre_C
End Property

Public Property Get DocFvNombre() As String
  DocFvNombre = m_DocFVNombre
End Property

Public Property Get PklDocFactura() As String
  PklDocFactura = m_PklDocFactura
End Property

Public Property Get PklDocInterno() As String
  PklDocInterno = m_PklDocInterno
End Property

Public Property Get DocCobzNombre() As String
  DocCobzNombre = m_DocCobzNombre
End Property

Public Property Get DocOsNombre() As String
  DocOsNombre = m_DocOSNombre
End Property

Public Property Get DocPrpNombre() As String
  DocPrpNombre = m_DocPRPNombre
End Property

Public Property Get DocLIQNombre() As String
  DocLIQNombre = m_DocLIQNombre
End Property

Public Property Get DeplNombre() As String
  DeplNombre = m_DeplNombre
End Property

Public Property Get DeplNombreSrv() As String
  DeplNombreSrv = m_DeplNombreSrv
End Property

Public Property Get Desktop() As String
  Desktop = m_Desktop
End Property

Public Property Get FolderToExportPDF() As String
  FolderToExportPDF = m_FolderToExportPDF
End Property

Public Property Get ViewNamesInToolbar() As Boolean
  ViewNamesInToolbar = m_ViewNamesInToolbar
End Property

Public Property Get UsarColoresEnDocumentos() As Boolean
  UsarColoresEnDocumentos = m_UsarColoresEnDocumentos
End Property

Public Property Get ColorEnEmpresa() As Long
  ColorEnEmpresa = m_ColorEnEmpresa
End Property

Public Property Get CueIdFvoxDefecto() As Long
  CueIdFvoxDefecto = m_cue_id_FvoxDefecto
End Property

Public Property Get CuentaFvoxDefecto() As String
  CuentaFvoxDefecto = m_CuentaFvoxDefecto
End Property

Public Property Get CliIdxDefecto() As Long
  CliIdxDefecto = m_cli_id_xdefecto
End Property

Public Property Get ClienteXDefecto() As String
  ClienteXDefecto = m_ClienteXDefecto
End Property

Public Property Get NuevoAlGrabar() As Boolean
  NuevoAlGrabar = m_NuevoAlGrabar
End Property

Public Property Get PrintInNewFv() As Boolean
  PrintInNewFv = m_PrintInNewFV
End Property

Public Property Get PrintInNewCobzCdo() As Boolean
  PrintInNewCobzCdo = m_PrintInNewCobzCdo
End Property

Public Property Get NuevoPTDAlGrabar() As Boolean
  NuevoPTDAlGrabar = m_NuevoPTDAlGrabar
End Property

Public Property Get ShowDataAddInVentas() As Boolean
  ShowDataAddInVentas = m_ShowDataAddInVentas
End Property

Public Property Get ShowDataAddInCompras() As Boolean
  ShowDataAddInCompras = m_ShowDataAddInCompras
End Property

Public Property Get est_id_hojaRuta() As String
  est_id_hojaRuta = m_est_id_hojaRuta
End Property

Public Property Get EstadoHojaRuta() As String
  EstadoHojaRuta = m_estadoHojaRuta
End Property

Public Property Get est_id_pickinglist() As String
  est_id_pickinglist = m_est_id_pickinglist
End Property

Public Property Get EstadoPickingList() As String
  EstadoPickingList = m_estadoPickingList
End Property

Public Property Get DebeHaberMf() As Boolean
  DebeHaberMf = m_debe_haber_mf
End Property

Public Property Get CloseWizard() As Boolean
  CloseWizard = m_CloseWizard
End Property

Public Property Get NoAskInPrint() As Boolean
  NoAskInPrint = m_NoAskInPrint
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Private Function cIABMClient_Copy() As Boolean
End Function

Private Function cIABMClient_EditNew() As Boolean
End Function

Private Property Get cIABMClient_Aplication() As String
    cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
  cIABMClient_CanAddDocDigital = False
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
  cIABMClient_CanCopy = False
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = False
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
  cIABMClient_ShowDocDigital = False
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean
End Function

Private Sub cIABMClient_Load()
End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
End Function

Private Function cIABMClient_Save() As Boolean
  Dim IProperty As cIABMProperty
  Dim IsNew     As Boolean
  Dim register  As cRegister
  Dim bAutoSize As Long
  
  Set register = New cRegister
  
  With register
    .Table = csTConfiguracion
    .fields.HaveLastUpdate = True
    .fields.HaveWhoModify = True
    .UtilizaIdentity = True
  End With
  
  ' Esto es para que el codigo en cDataBase no
  ' interprete que es un registro nuevo
  register.Id = -1
  
  For Each IProperty In m_ObjAbm.Properties
    With register
      Select Case IProperty.Key
      
        ' Compras
        
        Case K_DOC_ID_PC
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_DocPC, csUCCompras)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_DocPC, csUCCompras), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_DOC_ID_PREC
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_DocPREC, csUCCompras)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_DocPREC, csUCCompras), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_DOC_ID_COT
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_DocCOT, csUCCompras)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_DocCOT, csUCCompras), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_DOC_ID_OC
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_DocOC, csUCCompras)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_DocOC, csUCCompras), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_DOC_ID_RC
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_DocRC, csUCCompras)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_DocRC, csUCCompras), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_DOC_ID_FC
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_DocFC, csUCCompras)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_DocFC, csUCCompras), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_SHOWDATAADIC_IN_COMPRAS
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_ShowDataAddInCompras, csUCCompras))

          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_ShowDataAddInCompras, csUCCompras), csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        ' Stock
      
        Case K_DEPL_ID
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_Depl, csUCStock)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_Depl, csUCStock), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_DEPL_ID_SRV
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_DeplSrv, csUCStock)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_DeplSrv, csUCStock), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        ' Ventas
      
        Case K_INFORMAR_ANTICIPOS
        
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                    " and cfg_aspecto = " & gDB.sqlString( _
                                               pGetCfgClave(c_InformarAnticipos, csUCVentas))
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_InformarAnticipos, csUCVentas), csText
            .Add2 cscCfgValor, IIf(Val(IProperty.Value), 1, 0), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_DOC_ID_PREV
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_DocPREV, csUCVentas)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_DocPREV, csUCVentas), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_DOC_ID_PV
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_DocPV, csUCVentas)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_DocPV, csUCVentas), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_DOC_ID_RV
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_DocRV, csUCVentas)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_DocRV, csUCVentas), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_DOC_ID_RV_C
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_DocRV_C, csUCVentas)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_DocRV_C, csUCVentas), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_DOC_ID_FV
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_DocFV, csUCVentas)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_DocFV, csUCVentas), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_DOC_ID_COBZ
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_DocCobz, csUCVentas)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_DocCobz, csUCVentas), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_VIEW_NAMES_IN_TOOLBAR
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_ViewNamesInToolbar, csUCGeneral))
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_ViewNamesInToolbar, csUCGeneral), csText
            .Add2 cscCfgValor, IProperty.Value, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_PARTE_REPARACION_ESTADO_DEFAULT
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_PrpEstadoDef, csUCServicios)) & _
                            " and emp_id = " & EmpId

          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_PrpEstadoDef, csUCServicios), csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_SHOWDATAADIC_IN_VENTAS
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_ShowDataAddInVentas, csUCVentas))

          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_ShowDataAddInVentas, csUCVentas), csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_SHOWBARCODEINPUTCTRLS
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(c_showBarcodeInputCtrls) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, c_showBarcodeInputCtrls, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_ESTADO_EN_HOJA_RUTA
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_EstadoHojaRuta, csUCVentas)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_EstadoHojaRuta, csUCVentas), csText
            .Add2 cscCfgValor, IProperty.HelpValueProcess, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        ' Picking List
        
        Case K_PICKINLIST_DOC_ID_FACTURA
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_PklDocFactura, csUCVentas)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_PklDocFactura, csUCVentas), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_PICKINLIST_DOC_ID_INTERNO
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_PklDocInterno, csUCVentas)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_PklDocInterno, csUCVentas), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_ESTADO_EN_PICKING_LIST
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_EstadoPickingList, csUCVentas)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_EstadoPickingList, csUCVentas), csText
            .Add2 cscCfgValor, IProperty.HelpValueProcess, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        ' General
        
        Case K_DESKTOP
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_Desktop, csUCGeneral)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_Desktop, csUCGeneral), csText
            .Add2 cscCfgValor, IProperty.Value, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_USAR_COLORES_EN_DOCUMENTOS
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_UsarColoresEnDoc, csUCGeneral))
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_UsarColoresEnDoc, csUCGeneral), csText
            .Add2 cscCfgValor, IProperty.Value, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_COLOR_BACKGROUND
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_ColorEnEmpresa, csUCGeneral)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_ColorEnEmpresa, csUCGeneral), csText
            .Add2 cscCfgValor, IProperty.Value, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_FOLDER_TO_EXPORT_PDF
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_FolderToExportPDF, csUCGeneral)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_FolderToExportPDF, csUCGeneral), csText
            .Add2 cscCfgValor, IProperty.Value, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_LENGUAJE
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_Lenguaje, csUCGeneral)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_Lenguaje, csUCGeneral), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_AUTOSIZECOLS
        
          bAutoSize = Val(IProperty.Value)
        
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_AutoSizeCols, csUCGeneral)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_AutoSizeCols, csUCGeneral), csText
            .Add2 cscCfgValor, bAutoSize, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_MULTISELECT
        
          bAutoSize = Val(IProperty.Value)
        
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_MultiSelect, csUCGeneral)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_MultiSelect, csUCGeneral), csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_SHOWSAVEAS
                
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_ShowSaveAs, csUCGeneral)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_ShowSaveAs, csUCGeneral), csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_SHOW_ALL_IN_WIZARD
                
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_ShowAllInWizard, csUCGeneral)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_ShowAllInWizard, csUCGeneral), csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        ' Tesoreria
      
        Case K_DOC_ID_MF
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_DocMF, csUCTesoreria)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_DocMF, csUCTesoreria), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_DOC_ID_DBCO
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_DocDBCO, csUCTesoreria)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_DocDBCO, csUCTesoreria), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_DEBE_HABER_MF
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_DebeHaberMF, csUCTesoreria)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_DebeHaberMF, csUCTesoreria), csText
            .Add2 cscCfgValor, IProperty.Value, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        ' Servicios
      
        Case K_DOC_ID_OS
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_DocOS, csUCServicios)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_DocOS, csUCServicios), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_DOC_ID_PRP
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_DocPRP, csUCServicios)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_DocPRP, csUCServicios), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        ' Personal
      
        Case K_DOC_ID_LIQ
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_DocLIQ, csUCPersonal)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_DocLIQ, csUCPersonal), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_USE_PRINTER_SIZE
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_UsePrinterSize, csUCGeneral))
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_UsePrinterSize, csUCGeneral), csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_PTD_FECHAINI
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_PtdFecha, csUCServicios)) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_PtdFecha, csUCServicios), csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_NUEVOALGRABAR
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                    " and cfg_aspecto = " & gDB.sqlString(pGetCfgClave(c_NuevoAlGrabar, csUCVentas))
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_NuevoAlGrabar, csUCVentas), csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_NUEVOPTDALGRABAR
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                    " and cfg_aspecto = " & gDB.sqlString(pGetCfgClave(c_NuevoPTDAlGrabar, csUCVentas))
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_NuevoPTDAlGrabar, csUCVentas), csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_PRINT_IN_NEW_FV
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                    " and cfg_aspecto = " & gDB.sqlString(pGetCfgClave(c_PrintInNewFV, csUCVentas))
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_PrintInNewFV, csUCVentas), csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_PRINT_IN_NEW_COBZ_CDO
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                    " and cfg_aspecto = " & gDB.sqlString(pGetCfgClave(c_PrintInNewCobzCdo, csUCVentas))
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_PrintInNewCobzCdo, csUCVentas), csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_CLIENTEXDEFECTO
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(pGetCfgClave(c_ClienteXDefecto, csUCVentas)) & _
                            " and emp_id = " & EmpId
          
          If Not register.Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_ClienteXDefecto, csUCVentas), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_CUENTAFVOXDEFECTO
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                            " and cfg_aspecto = " & _
                                  gDB.sqlString(pGetCfgClave(c_CuentaFvoXDefecto, csUCVentas)) & _
                            " and emp_id = " & EmpId
          
          If Not register.Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_CuentaFvoXDefecto, csUCVentas), csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_CLOSE_WIZARD
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                    " and cfg_aspecto = " & gDB.sqlString(pGetCfgClave(c_CloseWizard, csUCVentas))
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_CloseWizard, csUCVentas), csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_NO_ASK_IN_PRINT
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoUsuarioConfig) & _
                    " and cfg_aspecto = " & gDB.sqlString(pGetCfgClave(c_NoAskInPrint, csUCVentas))
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoUsuarioConfig, csText
            .Add2 cscCfgAspecto, pGetCfgClave(c_NoAskInPrint, csUCVentas), csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
      End Select
    End With
  Next
  
  ' Para que CSOAPI se entere del cambio de preferencias
  '
  CSOAPI2.User.AutoSizeCols = bAutoSize
  
  cIABMClient_Save = Load()
  
  pSetColorEmpresa
  
End Function

Private Sub pSetColorEmpresa()
  Dim AbmGen As cABMGeneric
  
  Set AbmGen = m_ObjAbm
  
  If m_ColorEnEmpresa Then
    AbmGen.SetBakcColorTagMainEx m_ColorEnEmpresa
  Else
    AbmGen.SetBakcColorTagMainEx vbWhite
  End If
End Sub

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2933, vbNullString)  'Configuración del Usuario
End Property

Private Function cIABMClient_Validate() As Boolean
  cIABMClient_Validate = True
End Function

' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////

' Menu
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
  
  m_Host.Server.AddMenu C_MenuGeneral, csMenuConfigGeneral, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(2934, vbNullString), csPreGModifyConfigUsuario, C_MenuGeneral, 0, True, False, True, False, False, Me
                        'Preferencias
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  pEdit
End Function

Public Sub ValidatePREE()

End Sub

Public Sub ValidateIMPT()

End Sub

Public Sub ValidateMFC()

End Sub

Public Sub ValidatePKLST()

End Sub

Public Sub ValidatePEMB()

End Sub

Public Sub ValidateDCUP()

End Sub

Public Sub ValidateMF()
  pValidate m_doc_id_mf, m_DocMFNombre
End Sub

Public Sub ValidateDBCO()
  pValidate m_doc_id_dbco, m_DocDBCONombre
End Sub

Public Sub ValidatePPK()
  ValidateDepl
End Sub

Public Sub ValidateOPK()
  ValidateDepl
End Sub

Public Sub ValidateRS()

End Sub

Public Sub ValidateST()

End Sub

Public Sub ValidateAS()

End Sub

Public Sub ValidatePC()
  pValidate m_doc_id_pc, m_DocPCNombre
End Sub

Public Sub ValidateOC()
  pValidate m_doc_id_oc, m_DocOCNombre
End Sub

Public Sub ValidateRC()
  pValidate m_doc_id_rc, m_DocRCNombre
  ValidateDepl
End Sub

Public Sub ValidateFC()
  pValidate m_doc_id_fc, m_DocFCNombre
  ValidateDepl
End Sub

Public Sub ValidatePV()
  pValidate m_doc_id_pv, m_DocPVNombre
  ValidateDepl
End Sub

Public Sub ValidateRV()
  pValidate m_doc_id_rv, m_DocRVNombre
  ValidateDepl
End Sub

Public Sub ValidateRV_C()
  pValidate m_doc_id_rv_C, m_DocRVNombre_C
  ValidateDepl
End Sub

Public Sub ValidateOS()
  pValidate m_doc_id_os, m_DocOSNombre
  ValidateDepl
End Sub

Public Sub ValidatePRP()
  pValidate m_doc_id_prp, m_DocPRPNombre
  ValidateDepl
End Sub

Public Sub ValidateFV()
  pValidate m_doc_id_fv, m_DocFVNombre
  ValidateDepl
End Sub

Public Sub ValidatePklFactura()
  pValidate m_pkl_doc_id_factura, m_PklDocFactura
End Sub

Public Sub ValidatePklInterno()
  pValidate m_pkl_doc_id_interno, m_PklDocInterno
End Sub

Public Sub ValidateLIQ()
  pValidate m_doc_id_liq, m_DocLIQNombre
End Sub

Public Sub ValidateDepl()
  Dim Help As CSOAPI2.cHelp
  Set Help = New CSOAPI2.cHelp
  
  With Help.ValidateEx(csDepositoLogico, m_DeplNombre, m_depl_id)
    m_DeplNombre = .Value
    m_depl_id = Val(.Id)
  End With
End Sub

Private Sub pValidate(ByRef Id As Long, _
                      ByRef Nombre As String)
  Dim Help As CSOAPI2.cHelp
  Set Help = New CSOAPI2.cHelp
  
  With Help.ValidateEx(csTblDocumento, Nombre, Id)
    Nombre = .Value
    Id = Val(.Id)
  End With
End Sub

Public Function Load() As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset

  sqlstmt = "select * from configuracion where emp_id is null and cfg_grupo = " & _
                 gDB.sqlString(c_GrupoUsuarioConfig)

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  m_InformarAnticipos = False

  Dim claveInfAnticipos       As String
  Dim claveNuevoAlGrabar      As String
  Dim clavePrintInNewFv       As String
  Dim clavePrintInNewCobzCdo  As String
  Dim claveNuevoPTDAlGrabar   As String
  Dim claveUsePrinterSize     As String
  Dim claveCloseWizard        As String
  Dim claveNoAskInPrint       As String
  
  Dim claveShowDataAddInVentas  As String
  Dim claveShowDataAddInCompras As String
  Dim claveViewNamesInTb        As String
  Dim claveUsarColoresEnDoc     As String
  
  claveInfAnticipos = pGetCfgClave(c_InformarAnticipos, csUCVentas)
  claveNuevoAlGrabar = pGetCfgClave(c_NuevoAlGrabar, csUCVentas)
  clavePrintInNewFv = pGetCfgClave(c_PrintInNewFV, csUCVentas)
  clavePrintInNewCobzCdo = pGetCfgClave(c_PrintInNewCobzCdo, csUCVentas)
  claveNuevoPTDAlGrabar = pGetCfgClave(c_NuevoPTDAlGrabar, csUCVentas)
  claveUsePrinterSize = pGetCfgClave(c_UsePrinterSize, csUCGeneral)
  
  claveShowDataAddInVentas = pGetCfgClave(c_ShowDataAddInVentas, csUCVentas)
  claveShowDataAddInCompras = pGetCfgClave(c_ShowDataAddInCompras, csUCCompras)
  
  claveViewNamesInTb = pGetCfgClave(c_ViewNamesInToolbar, csUCGeneral)
  claveUsarColoresEnDoc = pGetCfgClave(c_UsarColoresEnDoc, csUCGeneral)
  
  claveCloseWizard = pGetCfgClave(c_CloseWizard, csUCVentas)
  claveNoAskInPrint = pGetCfgClave(c_NoAskInPrint, csUCVentas)
  
  While Not rs.EOF
    Select Case gDB.ValField(rs.fields, cscCfgAspecto)
      Case claveInfAnticipos
        m_InformarAnticipos = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case claveNuevoAlGrabar
        m_NuevoAlGrabar = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case claveNuevoPTDAlGrabar
        m_NuevoPTDAlGrabar = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case clavePrintInNewFv
        m_PrintInNewFV = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case clavePrintInNewCobzCdo
        m_PrintInNewCobzCdo = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case claveUsePrinterSize
        m_UsePrinterSize = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case claveShowDataAddInVentas
        m_ShowDataAddInVentas = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case claveShowDataAddInCompras
        m_ShowDataAddInCompras = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case claveViewNamesInTb
        m_ViewNamesInToolbar = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case claveUsarColoresEnDoc
        m_UsarColoresEnDocumentos = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case claveCloseWizard
        m_CloseWizard = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case claveNoAskInPrint
        m_NoAskInPrint = Val(gDB.ValField(rs.fields, cscCfgValor))
    End Select
    
    rs.MoveNext
  Wend

  sqlstmt = "select * from configuracion " & _
            "where emp_id = " & EmpId & _
             " and cfg_grupo = " & _
                 gDB.sqlString(c_GrupoUsuarioConfig)

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
  
  m_showBarcodeInputCtrls = False
  
  m_doc_id_pv = csNO_ID
  m_DocPVNombre = vbNullString

  Dim claveDocPc        As String
  Dim claveDocPrec      As String
  Dim claveDocCot       As String
  Dim claveDocOc        As String
  Dim claveDocRc        As String
  Dim claveDocFc        As String
  
  Dim claveDepl         As String
  Dim claveDeplSrv      As String
  
  Dim claveDocPv        As String
  Dim claveDocPrev      As String
  Dim claveDocRv        As String
  Dim claveDocRv_C      As String
  Dim claveDocFv        As String
  
  Dim clavePklDocFac    As String
  Dim clavePklDocInt    As String
  
  Dim claveDocOs        As String
  Dim claveDocPrp       As String
  Dim clavePtdFecha     As String
  Dim clavePrpEstadoDef As String

  Dim claveDocMF        As String
  Dim claveDocDBCO      As String
  Dim claveDebeHaberMf  As String
  
  Dim claveDocLIQ       As String
  
  Dim claveDesktop            As String
  Dim claveLenguaje           As String
  Dim claveAutoSizeCols       As String
  Dim claveMultiSelect        As String
  Dim claveShowSaveAs         As String
  Dim claveShowAllInWizard    As String
  Dim claveFolderToExportPDF  As String
  
  Dim claveCuentaFvo    As String
  Dim claveCliente      As String
  Dim claveDocCobz      As String
  
  Dim claveEstadoHojaRuta     As String
  Dim claveEstadoPickingList  As String
  
  Dim claveColorEmpresa       As String
  
  Dim bExists                 As Boolean
  
  claveDocPc = pGetCfgClave(c_DocPC, csUCCompras)
  claveDocPrec = pGetCfgClave(c_DocPREC, csUCCompras)
  claveDocCot = pGetCfgClave(c_DocCOT, csUCCompras)
  claveDocOc = pGetCfgClave(c_DocOC, csUCCompras)
  claveDocRc = pGetCfgClave(c_DocRC, csUCCompras)
  claveDocFc = pGetCfgClave(c_DocFC, csUCCompras)
  
  claveDocPv = pGetCfgClave(c_DocPV, csUCVentas)
  claveDocPrev = pGetCfgClave(c_DocPREV, csUCVentas)
  claveDocRv = pGetCfgClave(c_DocRV, csUCVentas)
  claveDocRv_C = pGetCfgClave(c_DocRV_C, csUCVentas)
  claveDocFv = pGetCfgClave(c_DocFV, csUCVentas)
  claveDocCobz = pGetCfgClave(c_DocCobz, csUCVentas)
  
  clavePklDocFac = pGetCfgClave(c_PklDocFactura, csUCVentas)
  clavePklDocInt = pGetCfgClave(c_PklDocInterno, csUCVentas)
  
  claveDocOs = pGetCfgClave(c_DocOS, csUCServicios)
  claveDocPrp = pGetCfgClave(c_DocPRP, csUCServicios)
  clavePtdFecha = pGetCfgClave(c_PtdFecha, csUCServicios)
  clavePrpEstadoDef = pGetCfgClave(c_PrpEstadoDef, csUCServicios)
  
  claveDocMF = pGetCfgClave(c_DocMF, csUCTesoreria)
  claveDocDBCO = pGetCfgClave(c_DocDBCO, csUCTesoreria)
  claveDebeHaberMf = pGetCfgClave(c_DebeHaberMF, csUCTesoreria)
  
  claveDocLIQ = pGetCfgClave(c_DocLIQ, csUCPersonal)
  
  claveDepl = pGetCfgClave(c_Depl, csUCStock)
  claveDeplSrv = pGetCfgClave(c_DeplSrv, csUCStock)

  claveDesktop = pGetCfgClave(c_Desktop, csUCGeneral)
  claveLenguaje = pGetCfgClave(c_Lenguaje, csUCGeneral)
  claveAutoSizeCols = pGetCfgClave(c_AutoSizeCols, csUCGeneral)
  claveMultiSelect = pGetCfgClave(c_MultiSelect, csUCGeneral)
  claveShowSaveAs = pGetCfgClave(c_ShowSaveAs, csUCGeneral)
  claveShowAllInWizard = pGetCfgClave(c_ShowAllInWizard, csUCGeneral)
  claveFolderToExportPDF = pGetCfgClave(c_FolderToExportPDF, csUCGeneral)

  claveCuentaFvo = pGetCfgClave(c_CuentaFvoXDefecto, csUCVentas)
  claveCliente = pGetCfgClave(c_ClienteXDefecto, csUCVentas)
  
  claveEstadoHojaRuta = pGetCfgClave(c_EstadoHojaRuta, csUCVentas)
  claveEstadoPickingList = pGetCfgClave(c_EstadoPickingList, csUCVentas)
  
  claveColorEmpresa = pGetCfgClave(c_ColorEnEmpresa, csUCGeneral)

  While Not rs.EOF
    Select Case gDB.ValField(rs.fields, cscCfgAspecto)
      
      Case claveDocPc
        m_doc_id_pc = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_pc, cscDocNombre, m_DocPCNombre) Then Exit Function
      Case claveDocPrev
        m_doc_id_prev = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_prev, cscDocNombre, m_DocPREVNombre) Then Exit Function
      Case claveDocCot
        m_doc_id_cot = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_cot, cscDocNombre, m_DocCOTNombre) Then Exit Function
      Case claveDocOc
        m_doc_id_oc = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_oc, cscDocNombre, m_DocOCNombre) Then Exit Function
      Case claveDocRc
        m_doc_id_rc = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_rc, cscDocNombre, m_DocRCNombre) Then Exit Function
      Case claveDocFc
        m_doc_id_fc = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_fc, cscDocNombre, m_DocFCNombre) Then Exit Function
      
      
      Case claveDocPv
        m_doc_id_pv = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_pv, cscDocNombre, m_DocPVNombre) Then Exit Function
      Case claveDocPrev
        m_doc_id_prev = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_prev, cscDocNombre, m_DocPREVNombre) Then Exit Function
      Case claveDocRv
        m_doc_id_rv = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_rv, cscDocNombre, m_DocRVNombre) Then Exit Function
      Case claveDocRv_C
        m_doc_id_rv_C = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_rv_C, cscDocNombre, m_DocRVNombre_C) Then Exit Function
      Case claveDocFv
        m_doc_id_fv = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_fv, cscDocNombre, m_DocFVNombre) Then Exit Function
      
      Case clavePklDocFac
        m_pkl_doc_id_factura = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_pkl_doc_id_factura, cscDocNombre, m_PklDocFactura) Then Exit Function
      Case clavePklDocInt
        m_pkl_doc_id_interno = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_pkl_doc_id_interno, cscDocNombre, m_PklDocInterno) Then Exit Function
      
      Case claveDocCobz
        m_doc_id_cobz = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_cobz, cscDocNombre, m_DocCobzNombre) Then Exit Function
      Case c_showBarcodeInputCtrls
        m_showBarcodeInputCtrls = Val(gDB.ValField(rs.fields, cscCfgValor))
      
      Case claveDocOs
        m_doc_id_os = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_os, cscDocNombre, m_DocOSNombre) Then Exit Function
      Case claveDocPrp
        m_doc_id_prp = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_prp, cscDocNombre, m_DocPRPNombre) Then Exit Function
      
      Case clavePtdFecha
        m_ptdFecha = Val(gDB.ValField(rs.fields, cscCfgValor))
      
      Case clavePrpEstadoDef
        m_PrpEstadoDef = Val(gDB.ValField(rs.fields, cscCfgValor))
      
      Case claveDocMF
        m_doc_id_mf = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_mf, cscDocNombre, m_DocMFNombre) Then Exit Function
      Case claveDocDBCO
        m_doc_id_dbco = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_dbco, cscDocNombre, m_DocDBCONombre) Then Exit Function
      Case claveDebeHaberMf
        m_debe_haber_mf = Val(gDB.ValField(rs.fields, cscCfgValor))
        
      Case claveDocLIQ
        m_doc_id_liq = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_liq, cscDocNombre, m_DocLIQNombre) Then Exit Function
    
      Case claveDepl
        m_depl_id = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDepositoLogico, cscDeplId, m_depl_id, cscDeplNombre, m_DeplNombre) Then Exit Function
      Case claveDeplSrv
        m_depl_id_srv = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDepositoLogico, cscDeplId, m_depl_id_srv, cscDeplNombre, m_DeplNombreSrv) Then Exit Function
        
      Case claveDesktop
        m_Desktop = gDB.ValField(rs.fields, cscCfgValor)
      
      Case claveFolderToExportPDF
        m_FolderToExportPDF = gDB.ValField(rs.fields, cscCfgValor)
      
      Case claveLenguaje
        m_leng_id = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTLenguaje, cscLengId, m_leng_id, cscLengNombre, m_LengNombre) Then Exit Function
        
      Case claveAutoSizeCols
        m_AutoSizeCols = Val(gDB.ValField(rs.fields, cscCfgValor))
        
      Case claveMultiSelect
        m_MultiSelect = Val(gDB.ValField(rs.fields, cscCfgValor))
                
      Case claveShowSaveAs
        m_ShowSaveAs = Val(gDB.ValField(rs.fields, cscCfgValor))
                
      Case claveShowAllInWizard
        m_ShowAllInWizard = Val(gDB.ValField(rs.fields, cscCfgValor))
                
      Case claveCliente
        m_cli_id_xdefecto = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTCliente, cscCliId, m_cli_id_xdefecto, cscCliNombre, m_ClienteXDefecto) Then Exit Function
      
      Case claveCuentaFvo
        m_cue_id_FvoxDefecto = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTCuenta, cscCueId, m_cue_id_FvoxDefecto, cscCueNombre, m_CuentaFvoxDefecto) Then Exit Function
        
      Case claveEstadoHojaRuta
        m_est_id_hojaRuta = gDB.ValField(rs.fields, cscCfgValor)
      
        If UCase(Left$(m_est_id_hojaRuta, 1)) = KEY_NODO Then
          m_estadoHojaRuta = pGetNombreRama(csEstado, Val(Mid(m_est_id_hojaRuta, 2)), bExists)
          If Not bExists Then m_est_id_hojaRuta = "0"
        Else
          If Not gDB.GetData(csTEstado, cscEstId, m_est_id_hojaRuta, cscEstNombre, m_estadoHojaRuta) Then Exit Function
        End If
        
      Case claveEstadoPickingList
        m_est_id_pickinglist = gDB.ValField(rs.fields, cscCfgValor)
      
        If UCase(Left$(m_est_id_pickinglist, 1)) = KEY_NODO Then
          m_estadoPickingList = pGetNombreRama(csEstado, Val(Mid(m_est_id_pickinglist, 2)), bExists)
          If Not bExists Then m_est_id_pickinglist = "0"
        Else
          If Not gDB.GetData(csTEstado, cscEstId, m_est_id_pickinglist, cscEstNombre, m_estadoPickingList) Then Exit Function
        End If
        
      Case claveColorEmpresa
        m_ColorEnEmpresa = Val(gDB.ValField(rs.fields, cscCfgValor))
        
    End Select
    
    rs.MoveNext
  Wend

  Load = True
End Function

Private Sub pEdit()
  On Error GoTo ControlError
  
  Set m_ObjAbm = New cABMGeneric
  
  If Not SecurityCanAccess(csPreGModifyConfigUsuario) Then Exit Sub

  If Not Load() Then Exit Sub
  
  If Not LoadCollection() Then Exit Sub
  
  m_Editing = True
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", C_Module, vbNullString
End Sub

Private Function LoadCollection() As Boolean

  Dim c       As cIABMProperty
  Dim oProp   As cABMProperty
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  AbmObj.MinHeight = 8400
  AbmObj.MinWidth = 11000
  AbmObj.UseHelpValueProcess = True

  Const c_tab_General = 0
  Const c_tab_Compras = 1
  Const c_tab_Stock = 2
  Const c_tab_Ventas = 3
  Const c_tab_Tesoreria = 4
  Const c_tab_Servicios = 5
  Const c_tab_Personal = 6
  Const c_tab_Despachos = 7
  Const c_tab_Cancelacion = 8
  
  With m_ObjAbm.Tabs
    .Clear
    
    With .Add(Nothing)
      .Index = c_tab_General
      .name = C_strGeneral
    End With
    
    With .Add(Nothing)
      .Index = c_tab_Compras
      .name = LNGGetText(1489, vbNullString) 'Compras
    End With
    
    With .Add(Nothing)
      .Index = c_tab_Stock
      .name = LNGGetText(1298, vbNullString) 'Stock
    End With
  
    With .Add(Nothing)
      .Index = c_tab_Ventas
      .name = LNGGetText(1488, vbNullString) 'Ventas
    End With
  
    With .Add(Nothing)
      .Index = c_tab_Tesoreria
      .name = LNGGetText(2935, vbNullString) 'Tesoreria
    End With
  
    With .Add(Nothing)
      .Index = c_tab_Servicios
      .name = LNGGetText(2676, vbNullString) 'Servicios
    End With
  
    With .Add(Nothing)
      .Index = c_tab_Personal
      .name = LNGGetText(3880, vbNullString) 'Personal
    End With
  
    With .Add(Nothing)
      .Index = c_tab_Despachos
      .name = LNGGetText(4885, vbNullString) 'Depachos
    End With
  
    With .Add(Nothing)
      .Index = c_tab_Cancelacion
      .name = LNGGetText(4959, vbNullString) 'Cancelacion
    End With
  End With

  With m_ObjAbm.Properties
    
    .Clear
    
    ' General
    With .Add(Nothing, c_Desktop)
      .PropertyType = cspFile
      .HelpFilter = LNGGetText(2936, vbNullString) 'Archivos de Escritorio|*.csd
      .Width = 6700
      .name = c_Desktop
      .Key = K_DESKTOP
      .Value = m_Desktop
      .TabIndex = c_tab_General
    End With
    
    With .Add(Nothing, c_Lenguaje)
      .PropertyType = cspHelp
      .Table = csTblLenguaje
      .Width = 4000
      .name = c_Lenguaje
      .Key = K_LENGUAJE
      .HelpId = m_leng_id
      .Value = m_LengNombre
      .TabIndex = c_tab_General
    End With
    
    With .Add(Nothing, c_AutoSizeCols)
      .PropertyType = cspCheck
      .Width = 4000
      .name = c_AutoSizeCols
      .Key = K_AUTOSIZECOLS
      .Value = CInt(m_AutoSizeCols)
      .TabIndex = c_tab_General
      .Left = 2360
      .LeftLabel = -2000
    End With
    
    With .Add(Nothing, c_MultiSelect)
      .PropertyType = cspCheck
      .Width = 4000
      .name = c_MultiSelect
      .Key = K_MULTISELECT
      .Value = CInt(m_MultiSelect)
      .TabIndex = c_tab_General
      .Left = 2360
      .LeftLabel = -2000
    End With
    
    With .Add(Nothing, c_UsePrinterSize)
      .PropertyType = cspCheck
      .Left = 4150
      .LeftLabel = -3800
      .name = c_UsePrinterSize
      .Key = K_USE_PRINTER_SIZE
      .Value = CInt(m_UsePrinterSize)
      .TabIndex = c_tab_General
    End With
    
    With .Add(Nothing, c_ViewNamesInToolbar)
      .PropertyType = cspCheck
      .name = "Ver el nombre de los bótones en las barras de herramientas"
      .Key = K_VIEW_NAMES_IN_TOOLBAR
      .Value = CInt(m_ViewNamesInToolbar)
      .Left = 4660
      .LeftLabel = -4300
      .TabIndex = c_tab_General
    End With
    
    With .Add(Nothing, c_ShowSaveAs)
      .PropertyType = cspCheck
      .Width = 4000
      .name = c_ShowSaveAs
      .Key = K_SHOWSAVEAS
      .Value = CInt(m_ShowSaveAs)
      .TabIndex = c_tab_General
      .Left = 2360
      .LeftLabel = -2000
    End With
    
    With .Add(Nothing, c_ShowAllInWizard)
      .PropertyType = cspCheck
      .Width = 4000
      .name = c_ShowAllInWizard
      .Key = K_SHOW_ALL_IN_WIZARD
      .Value = CInt(m_ShowAllInWizard)
      .TabIndex = c_tab_General
      .Left = 3860
      .LeftLabel = -3500
    End With
    
    With .Add(Nothing, c_FolderToExportPDF)
      .PropertyType = cspFolder
      .Width = 6000
      '.LeftFromProperty = c_Desktop
      .name = c_FolderToExportPDF
      .Key = K_FOLDER_TO_EXPORT_PDF
      .Value = m_FolderToExportPDF
      .TabIndex = c_tab_General
      .Left = 3200
      .LeftLabel = -2830
      .Width = 5000
    End With
    
    With .Add(Nothing, c_UsarColoresEnDoc)
      .PropertyType = cspCheck
      .Width = 6000
      .name = LNGGetText(4821, vbNullString) 'Usar colores en documentos
      .Key = K_USAR_COLORES_EN_DOCUMENTOS
      .Value = m_UsarColoresEnDocumentos
      .TabIndex = c_tab_General
      .Left = 3200
      .LeftLabel = -2830
    End With
    
    With .Add(Nothing, c_ColorEnEmpresa)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Width = 6000
      .name = LNGGetText(4915, vbNullString) 'Color en Empresa
      .Key = K_COLOR_BACKGROUND
      .Value = m_ColorEnEmpresa
      .TabIndex = c_tab_General
      .Left = 3200
      .LeftLabel = -2830
      .Width = 1500
    End With
    
    ' Compras
    
    With .Add(Nothing, c_DocPC)
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Left = 2800
      .Width = 4000
      .LeftLabel = -2500
      .name = c_DocPC
      .Key = K_DOC_ID_PC
      .HelpId = m_doc_id_pc
      .HelpFilter = "'doct_id = 6'"
      .Value = m_DocPCNombre
      .TabIndex = c_tab_Compras
    End With
    
    With .Add(Nothing, c_DocPREC)
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Left = 2800
      .Width = 4000
      .LeftLabel = -2500
      .name = c_DocPREC
      .Key = K_DOC_ID_PREC
      .HelpId = m_doc_id_prec
      .HelpFilter = "'doct_id = 12'"
      .Value = m_DocPRECNombre
      .TabIndex = c_tab_Compras
    End With
    
    With .Add(Nothing, c_DocCOT)
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Left = 2800
      .Width = 4000
      .LeftLabel = -2500
      .name = c_DocCOT
      .Key = K_DOC_ID_COT
      .HelpId = m_doc_id_cot
      .HelpFilter = "'doct_id = 37'"
      .Value = m_DocCOTNombre
      .TabIndex = c_tab_Compras
    End With
    
    With .Add(Nothing, c_DocOC)
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Left = 2800
      .Width = 4000
      .LeftLabel = -2500
      .name = c_DocOC
      .Key = K_DOC_ID_OC
      .HelpId = m_doc_id_oc
      .HelpFilter = "'doct_id = 35'"
      .Value = m_DocOCNombre
      .TabIndex = c_tab_Compras
    End With
    
    With .Add(Nothing, c_DocRC)
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Left = 2800
      .Width = 4000
      .LeftLabel = -2500
      .name = c_DocRC
      .Key = K_DOC_ID_RC
      .HelpId = m_doc_id_rc
      .HelpFilter = "'doct_id = 4'"
      .Value = m_DocRCNombre
      .TabIndex = c_tab_Compras
    End With
    
    With .Add(Nothing, c_DocFC)
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Left = 2800
      .Width = 4000
      .LeftLabel = -2500
      .name = c_DocFC
      .Key = K_DOC_ID_FC
      .HelpId = m_doc_id_fc
      .HelpFilter = "'doct_id = 2'"
      .Value = m_DocFCNombre
      .TabIndex = c_tab_Compras
    End With
    
    With .Add(Nothing, c_ShowDataAddInCompras)
      .PropertyType = cspCheck
      .Left = 2800
      .Width = 400
      .LeftLabel = -2500
      .name = LNGGetText(3914, vbNullString) 'Ver datos del proveedor
      .Key = K_SHOWDATAADIC_IN_COMPRAS
      .Value = CInt(m_ShowDataAddInCompras)
      .TabIndex = c_tab_Compras
    End With
    
    ' Stock
    
    With .Add(Nothing, c_Depl)
      .PropertyType = cspHelp
      .Table = csDepositoLogico
      .Left = 1100
      .Width = 4000
      .LeftLabel = -800
      .name = c_Depl
      .Key = K_DEPL_ID
      .HelpId = m_depl_id
      .Value = m_DeplNombre
      .TabIndex = c_tab_Stock
    End With
    
    With .Add(Nothing, c_DeplSrv)
      .PropertyType = cspHelp
      .Table = csDepositoLogico
      .Left = 1100
      .Width = 4000
      .LeftLabel = -800
      .name = c_DeplSrv
      .Key = K_DEPL_ID_SRV
      .HelpId = m_depl_id_srv
      .Value = m_DeplNombreSrv
      .TabIndex = c_tab_Stock
    End With
    
    ' Ventas
    
    With .Add(Nothing, c_InformarAnticipos)
      .PropertyType = cspCheck
      .name = LNGGetText(2937, vbNullString)
              'Mostrar un mensaje al grabar las Facturas de venta informando si el & _
              cliente tiene anticipos
      .LeftLabel = -6450
      .Left = 6750
      .Key = K_INFORMAR_ANTICIPOS
      .Value = CInt(m_InformarAnticipos)
      .TabIndex = c_tab_Ventas
    End With
  
    With .Add(Nothing, c_DocPREV & "v")
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Left = 2800
      .Width = 4000
      .LeftLabel = -2500
      .name = c_DocPREV
      .Key = K_DOC_ID_PREV
      .HelpId = m_doc_id_prev
      .HelpFilter = "'doct_id = 11'"
      .Value = m_DocPREVNombre
      .TabIndex = c_tab_Ventas
      .TopToPrevious = 400
    End With
    
    With .Add(Nothing, c_DocPV & "v")
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Left = 2800
      .Width = 4000
      .LeftLabel = -2500
      .name = c_DocPV
      .Key = K_DOC_ID_PV
      .HelpId = m_doc_id_pv
      .HelpFilter = "'doct_id = 5'"
      .Value = m_DocPVNombre
      .TabIndex = c_tab_Ventas
      .TopToPrevious = 400
    End With
  
    With .Add(Nothing, c_DocRV & "v")
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Left = 2800
      .Width = 4000
      .LeftLabel = -2500
      .name = c_DocRV
      .Key = K_DOC_ID_RV
      .HelpId = m_doc_id_rv
      .HelpFilter = "'doct_id = 3'"
      .Value = m_DocRVNombre
      .TabIndex = c_tab_Ventas
      .TopToPrevious = 400
    End With
  
    With .Add(Nothing, c_DocFV & "v")
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Left = 2800
      .Width = 4000
      .LeftLabel = -2500
      .name = c_DocFV
      .Key = K_DOC_ID_FV
      .HelpId = m_doc_id_fv
      .HelpFilter = "'doct_id = 1'"
      .Value = m_DocFVNombre
      .TabIndex = c_tab_Ventas
      .TopToPrevious = 400
    End With
  
    With .Add(Nothing, c_DocCobz)
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Left = 2800
      .Width = 4000
      .LeftLabel = -2500
      .name = c_DocCobz
      .Key = K_DOC_ID_COBZ
      .HelpId = m_doc_id_cobz
      .HelpFilter = "'doct_id = 13'"
      .Value = m_DocCobzNombre
      .TabIndex = c_tab_Ventas
      .TopToPrevious = 400
    End With
  
    With .Add(Nothing, c_showBarcodeInputCtrls)
      .PropertyType = cspCheck
      .Left = 3300
      .LeftLabel = -3000
      .name = c_showBarcodeInputCtrls
      .Key = K_SHOWBARCODEINPUTCTRLS
      .Value = CInt(m_showBarcodeInputCtrls)
      .TabIndex = c_tab_Ventas
      .TopToPrevious = 400
    End With
  
    With .Add(Nothing, c_CuentaFvoXDefecto)
      .PropertyType = cspHelp
      .Table = csCuenta
      .Left = 3100
      .Width = 3000
      .LeftLabel = -2800
      .name = LNGGetText(3554, vbNullString) 'Cuenta efectivo de cobranza contado
      .Key = K_CUENTAFVOXDEFECTO
      .HelpId = m_cue_id_FvoxDefecto
      .Value = m_CuentaFvoxDefecto
      .TabIndex = c_tab_Ventas
      .TopToPrevious = 400
    End With
  
    With .Add(Nothing, c_ClienteXDefecto)
      .PropertyType = cspHelp
      .Table = csCliente
      .Left = 3100
      .Width = 3000
      .LeftLabel = -2800
      .name = LNGGetText(3556, vbNullString) 'Cliente por defecto
      .Key = K_CLIENTEXDEFECTO
      .HelpId = m_cli_id_xdefecto
      .Value = m_ClienteXDefecto
      .TabIndex = c_tab_Ventas
      .TopToPrevious = 400
    End With
    
    With .Add(Nothing, c_NuevoAlGrabar)
      .PropertyType = cspCheck
      .Left = 4050
      .Width = 400
      .LeftLabel = -3750
      .name = LNGGetText(3555, vbNullString) 'Presentar un nuevo documento despues de grabar
      .Key = K_NUEVOALGRABAR
      .Value = CInt(m_NuevoAlGrabar)
      .TabIndex = c_tab_Ventas
      .TopToPrevious = 360
    End With
  
    With .Add(Nothing, c_PrintInNewFV)
      .PropertyType = cspCheck
      .Left = 4050
      .Width = 400
      .LeftLabel = -3750
      .name = LNGGetText(4837, vbNullString) 'Imprimir al grabar una nueva factura
      .Key = K_PRINT_IN_NEW_FV
      .Value = CInt(m_PrintInNewFV)
      .TabIndex = c_tab_Ventas
      .TopToPrevious = 360
    End With
  
    With .Add(Nothing, c_PrintInNewCobzCdo)
      .PropertyType = cspCheck
      .Left = 4050
      .Width = 400
      .LeftLabel = -3750
      .name = LNGGetText(4838, vbNullString) 'Imprimir recibo en cobranza contado
      .Key = K_PRINT_IN_NEW_COBZ_CDO
      .Value = CInt(m_PrintInNewCobzCdo)
      .TabIndex = c_tab_Ventas
      .TopToPrevious = 360
    End With
  
    With .Add(Nothing, c_NuevoPTDAlGrabar)
      .PropertyType = cspCheck
      .Left = 4050
      .Width = 400
      .LeftLabel = -3750
      .name = LNGGetText(4836, vbNullString) 'Presentar un nuevo parte despues de grabar
      .Key = K_NUEVOPTDALGRABAR
      .Value = CInt(m_NuevoPTDAlGrabar)
      .TabIndex = c_tab_Ventas
      .TopToPrevious = 360
    End With
  
    With .Add(Nothing, c_ShowDataAddInVentas)
      .PropertyType = cspCheck
      .Width = 400
      .LeftLabel = -2750
      .name = LNGGetText(3913, vbNullString) 'Ver datos del cliente
      .Key = K_SHOWDATAADIC_IN_VENTAS
      .Value = CInt(m_ShowDataAddInVentas)
      .TabIndex = c_tab_Ventas
      .TopFromProperty = c_NuevoAlGrabar
      .Left = 8000
    End With
  
    With .Add(Nothing, c_CloseWizard)
      .PropertyType = cspCheck
      .Width = 400
      .LeftLabel = -2750
      .name = LNGGetText(5079, vbNullString) 'Cerrar Asistente al Finalizar
      .Key = K_CLOSE_WIZARD
      .Value = CInt(m_CloseWizard)
      .TabIndex = c_tab_Ventas
      .TopToPrevious = 360
      .Left = 8000
    End With
  
    With .Add(Nothing, c_NoAskInPrint)
      .PropertyType = cspCheck
      .Width = 400
      .LeftLabel = -2750
      .name = LNGGetText(5080, vbNullString) 'No Pedir Confirmar al Imprimir
      .Key = K_NO_ASK_IN_PRINT
      .Value = CInt(m_NoAskInPrint)
      .TabIndex = c_tab_Ventas
      .TopToPrevious = 360
      .Left = 8000
    End With
  
    Set c = .Add(Nothing, c_EstadoHojaRuta)
    With c
      .PropertyType = cspHelp
      .Table = csEstado
      .LeftFromProperty = c_DocCobz
      .LeftLabel = -2500
      .name = LNGGetText(4549, vbNullString) 'Estado en hojas de ruta
      .Key = K_ESTADO_EN_HOJA_RUTA
      .HelpId = Val(m_est_id_hojaRuta)
      .HelpValueProcess = m_est_id_hojaRuta
      .Value = m_estadoHojaRuta
      .TabIndex = c_tab_Ventas
      .TopToPrevious = 720
      
      Set oProp = c
      oProp.HelpType = csTree
      oProp.IsEditProperty = False
      Set oProp = Nothing
    
    End With
  
    ' Tesoreria
    
    With .Add(Nothing, c_DocMF)
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Left = 2800
      .Width = 4000
      .LeftLabel = -2500
      .name = c_DocMF
      .Key = K_DOC_ID_MF
      .HelpId = m_doc_id_mf
      .HelpFilter = "'doct_id = 26'"
      .Value = m_DocMFNombre
      .TabIndex = c_tab_Tesoreria
    End With
    
    With .Add(Nothing, c_DocDBCO)
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Left = 2800
      .Width = 4000
      .LeftLabel = -2500
      .name = c_DocDBCO
      .Key = K_DOC_ID_DBCO
      .HelpId = m_doc_id_dbco
      .HelpFilter = "'doct_id = 17'"
      .Value = m_DocDBCONombre
      .TabIndex = c_tab_Tesoreria
    End With
    
    With .Add(Nothing, c_DebeHaberMF)
      .PropertyType = cspCheck
      .Left = 2800
      .LeftLabel = -2500
      .name = c_DebeHaberMF
      .Key = K_DEBE_HABER_MF
      .Value = m_debe_haber_mf
      .TabIndex = c_tab_Tesoreria
    End With
    
    ' Servicios
  
    With .Add(Nothing, c_DocOS)
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Left = 2800
      .Width = 4000
      .LeftLabel = -2650
      .name = c_DocOS
      .Key = K_DOC_ID_OS
      .HelpId = m_doc_id_os
      .HelpFilter = "'doct_id = 42'"
      .Value = m_DocOSNombre
      .TabIndex = c_tab_Servicios
    End With
  
    With .Add(Nothing, c_DocPRP)
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Left = 2800
      .Width = 4000
      .LeftLabel = -2650
      .name = c_DocPRP
      .Key = K_DOC_ID_PRP
      .HelpId = m_doc_id_prp
      .HelpFilter = "'doct_id = 43'"
      .Value = m_DocPRPNombre
      .TabIndex = c_tab_Servicios
    End With
  
    With .Add(Nothing, c_PtdFecha)
      .PropertyType = cspCheck
      .Left = 2800
      .Width = 4000
      .LeftLabel = -2650
      .name = c_PtdFecha
      .Key = K_PTD_FECHAINI
      .Value = CInt(m_ptdFecha)
      .TabIndex = c_tab_Servicios
    End With
  
    With .Add(Nothing, c_PrpEstadoDef)
      .PropertyType = cspCheck
      .Left = 5500
      .Width = 400
      .LeftLabel = -5350
      .name = LNGGetText(3918, vbNullString) 'Estado Default en Parte Reparacion
      .Key = K_PARTE_REPARACION_ESTADO_DEFAULT
      .Value = CInt(m_PrpEstadoDef)
      .TabIndex = c_tab_Servicios
    End With
  
    ' Personal
    
    With .Add(Nothing, c_DocLIQ)
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Left = 2800
      .Width = 4000
      .LeftLabel = -2500
      .name = c_DocLIQ
      .Key = K_DOC_ID_LIQ
      .HelpId = m_doc_id_liq
      .HelpFilter = "'doct_id = 47'"
      .Value = m_DocLIQNombre
      .TabIndex = c_tab_Personal
    End With
  
    ' Despachos
    
    With .Add(Nothing, c_PklDocFactura)
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Left = 2800
      .Width = 4000
      .LeftLabel = -2500
      .name = c_PklDocFactura
      .Key = K_PICKINLIST_DOC_ID_FACTURA
      .HelpId = m_pkl_doc_id_factura
      .HelpFilter = "'doct_id = 1'"
      .Value = m_PklDocFactura
      .TabIndex = c_tab_Despachos
    End With
  
    With .Add(Nothing, c_PklDocInterno)
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Left = 2800
      .Width = 4000
      .LeftLabel = -2500
      .name = c_PklDocInterno
      .Key = K_PICKINLIST_DOC_ID_INTERNO
      .HelpId = m_pkl_doc_id_interno
      .HelpFilter = "'doct_id = 1'"
      .Value = m_PklDocInterno
      .TabIndex = c_tab_Despachos
    End With
  
    Set c = .Add(Nothing, c_EstadoPickingList)
    With c
      .PropertyType = cspHelp
      .Table = csEstado
      .LeftLabel = -2500
      .name = LNGGetText(4861, vbNullString) 'Estado en picking list
      .Key = K_ESTADO_EN_PICKING_LIST
      .HelpId = Val(m_est_id_pickinglist)
      .HelpValueProcess = m_est_id_pickinglist
      .Value = m_estadoPickingList
      .TabIndex = c_tab_Despachos
      
      Set oProp = c
      oProp.HelpType = csTree
      oProp.IsEditProperty = False
      Set oProp = Nothing
    
    End With
  
    With .Add(Nothing, c_DocRV_C & "v")
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Left = 3300
      .Width = 4000
      .LeftLabel = -3000
      .name = c_DocRV_C
      .Key = K_DOC_ID_RV_C
      .HelpId = m_doc_id_rv_C
      .HelpFilter = "'doct_id = 24'"
      .Value = m_DocRVNombre_C
      .TabIndex = c_tab_Cancelacion
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function
' funciones friend
' funciones privadas
Private Function pGetCfgClave(ByVal clave As String, _
                              ByVal iModule As csUCModule) As String
  Select Case iModule
    Case csUCCompras
      clave = clave & " Cpra_" & User.Id
    Case csUCStock
      clave = clave & "_" & User.Id
    Case csUCVentas
      clave = clave & " Vta_" & User.Id
    Case csUCGeneral
      clave = clave & " Gral_" & User.Id
    Case csUCTesoreria
      clave = clave & " Tsr_" & User.Id
    Case csUCServicios
      clave = clave & " Srv_" & User.Id
  End Select
  pGetCfgClave = clave
End Function

Private Function pGetNombreRama(ByVal tbl_id As Long, ByVal Ram_ID As Long, ByRef bExists As Boolean) As String
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select ram_nombre from rama,arbol " & _
              " where rama.arb_id = arbol.arb_id " & _
                " and ram_id = " & Ram_ID & _
                " and tbl_id = " & tbl_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  bExists = True
  
  pGetNombreRama = gDB.ValField(rs.fields, cscRamNombre)
End Function

' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2938, vbNullString) 'Error al grabar la Configuración del Usuario
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

