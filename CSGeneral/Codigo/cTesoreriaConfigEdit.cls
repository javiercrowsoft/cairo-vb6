VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTesoreriaConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cTesoreriaConfigEdit
' 04-12-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cTesoreriaConfigEdit"

Private Const K_CUE_ID_DIFCAMBIO = 1
Private Const K_DOC_ID_NC_DIFCAMBIO = 2
Private Const K_DOC_ID_ND_DIFCAMBIO = 3
Private Const K_DEFAULT_DIFCAMBIO = 4
Private Const K_MODO_IVA_DIFCAMBIO = 5
Private Const K_APLICACION_DIFCAMBIO = 101
Private Const K_PR_ID_DIFCAMBIO = 6

Private Const K_DOC_ID_COBRANZA = 7
Private Const K_DOC_ID_ORDENPAGO = 8

Private Const K_GRABAR_ASIENTO_COBRANZA = 9
Private Const K_GRABAR_ASIENTO_ORDENPAGO = 10
Private Const K_GRABAR_ASIENTO_MOVIMIENTOFONDO = 11
Private Const K_GRABAR_ASIENTO_RENDICION = 12
Private Const K_GRABAR_ASIENTO_DEPOSITOBANCO = 13
Private Const K_GRABAR_ASIENTO_DEPOSITOCUPON = 14
Private Const K_GRABAR_ASIENTO_RESOLUCIONCUPON = 15

Private Const K_CALCULAR_RETENCIONES = 16
Private Const K_RET_ID = 17
Private Const KI_RET_ID = 1

Private Const K_CUE_ID_ANT_COBZ = 18
Private Const K_CUE_ID_ANT_OPG = 19

Private Const K_GRABAR_ASIENTO_AGRUPADO = 20

Private Const K_EXIGIR_CENTROCOSTO = 21
Private Const K_COBRANZAS_XHOJARUTA = 22

Private Const csTblDocumento = 4001

Private Const c_GrupoGeneral = "Tesoreria-General"
Private Const c_CueIdDifCambio = "Cuenta contable"
Private Const c_NCDifCambio = "Nota de credito"
Private Const c_NDDifCambio = "Nota de debito"
Private Const c_DefaultDifCambio = "Utilizar"
Private Const c_ModoIvaDifCambio = "Tratamiento del Iva"
Private Const c_AplicacionDifCambio = "Aplicación Dif. Cambio"
Private Const c_PrIdDifCambio = "Articulo"

Private Const c_GrabarAsientoCobranza = "Cobranza-Grabar Asiento"
Private Const c_GrabarAsientoOrdenPago = "OrdenPago-Grabar Asiento"
Private Const c_GrabarAsientoMovimientoFondo = "MovimientoFondo-Grabar Asiento"
Private Const c_GrabarAsientoRendicion = "Rendicion-Grabar Asiento"
Private Const c_GrabarAsientoDepositoBanco = "DepositoBanco-Grabar Asiento"
Private Const c_GrabarAsientoDepositoCupon = "DepositoCupon-Grabar Asiento"
Private Const c_GrabarAsientoResolucionCupon = "ResolucionCupon-Grabar Asiento"
Private Const c_GrabarAsientoAgrupado = "Asiento Agrupado"

Private Const c_CalcularRetenciones = "Calcular Retenciones"
Private Const c_Retencion = "Retencion"

Private Const c_DocIdCobranza = "Cobranza"
Private Const c_DocIdOrdenPago = "Orden Pago"

Private Const c_CuentaAnticipoCobranza = "Cuenta Anticipo Cobranzas"
Private Const c_CuentaAnticipoPagos = "Cuenta Anticipo Ordenes de Pago"

Private Const c_ExigirCentroCosto = "Exigir Centro Costo"
Private Const c_CobranzasXHojaRuta = "Cobranzas por Hoja de Ruta"

' estructuras
' Seudo - Variables
Private c_ErrorSave                   As String
' variables privadas
Private m_cue_id_difCambio            As Long
Private m_CuentaDifCambio             As String

Private m_doc_id_NCdifCambio          As Long
Private m_DocNCDifCambio              As String

Private m_doc_id_NDdifCambio          As Long
Private m_DocNDDifCambio              As String

Private m_pr_id_difCambio             As Long
Private m_ProductoDifCambio           As String

Private m_doc_id_Cobranza             As Long
Private m_DocCobranza                 As String

Private m_doc_id_OrdenPago            As Long
Private m_DocOrdenPago                As String

Private m_DefaultDifCambio            As csEModoDifCambio
Private m_ModoIvaDifCambio            As csEModoIvaDifCambio
Private m_AplicacionDifCambio         As csEAplicacionDifCambio

Private m_GrabarAsientoCobranza               As Boolean
Private m_GrabarAsientoDepositoBanco          As Boolean
Private m_GrabarAsientoOrdenPago              As Boolean
Private m_GrabarAsientoMovimientoFondo        As Boolean
Private m_GrabarAsientoRendicion              As Boolean
Private m_GrabarAsientoDepositoCupon          As Boolean
Private m_GrabarAsientoResolucionCupon        As Boolean
Private m_GrabarAsientoAgrupado               As Boolean

Private m_CalcularRetenciones         As Boolean

Private m_CueAnticipoCobz             As String
Private m_CueAnticipoOpg              As String

Private m_cue_id_ant_cobz             As Long
Private m_cue_id_ant_opg              As Long

Private m_ExigirCentroCosto           As Boolean
Private m_CobranzasXHojaRuta          As Boolean

Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas

' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////

' cIABMClient

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
  Dim fields    As cFields
  
  Set register = New cRegister
  
  With register
    Set fields = .fields
    .Table = csTConfiguracion
    .fields.HaveLastUpdate = True
    .fields.HaveWhoModify = True
    .UtilizaIdentity = True
    
    ' Esto es para que el codigo en cDataBase no
    ' interprete que es un registro nuevo
    .ID = -1
  End With
  
  For Each IProperty In m_ObjAbm.Properties
    With register
      Select Case IProperty.Key
        Case K_CUE_ID_DIFCAMBIO
          .fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_CueIdDifCambio)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_CueIdDifCambio, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_DOC_ID_COBRANZA
          .fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_DocIdCobranza) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_DocIdCobranza, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_DOC_ID_ORDENPAGO
          .fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_DocIdOrdenPago) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_DocIdOrdenPago, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_DOC_ID_NC_DIFCAMBIO
          .fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_NCDifCambio) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_NCDifCambio, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_DOC_ID_ND_DIFCAMBIO
          .fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_NDDifCambio) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_NDDifCambio, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_DEFAULT_DIFCAMBIO
          .fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_DefaultDifCambio)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_DefaultDifCambio, csText
            .Add2 cscCfgValor, IProperty.ListItemData, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_MODO_IVA_DIFCAMBIO
          .fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_ModoIvaDifCambio)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_ModoIvaDifCambio, csText
            .Add2 cscCfgValor, IProperty.ListItemData, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_APLICACION_DIFCAMBIO
          .fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_AplicacionDifCambio)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_AplicacionDifCambio, csText
            .Add2 cscCfgValor, IProperty.ListItemData, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function

        Case K_PR_ID_DIFCAMBIO
          .fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_PrIdDifCambio)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_PrIdDifCambio, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_GRABAR_ASIENTO_COBRANZA
          .fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_GrabarAsientoCobranza)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_GrabarAsientoCobranza, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_GRABAR_ASIENTO_ORDENPAGO
          .fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_GrabarAsientoOrdenPago)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_GrabarAsientoOrdenPago, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_GRABAR_ASIENTO_MOVIMIENTOFONDO
          .fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_GrabarAsientoMovimientoFondo)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_GrabarAsientoMovimientoFondo, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_GRABAR_ASIENTO_RENDICION
          .fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_GrabarAsientoRendicion)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_GrabarAsientoRendicion, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_GRABAR_ASIENTO_DEPOSITOBANCO
          .fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_GrabarAsientoDepositoBanco)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_GrabarAsientoDepositoBanco, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_GRABAR_ASIENTO_DEPOSITOCUPON
          .fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_GrabarAsientoDepositoCupon)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_GrabarAsientoDepositoCupon, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_GRABAR_ASIENTO_AGRUPADO
          .fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_GrabarAsientoAgrupado)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_GrabarAsientoAgrupado, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
                
        Case K_GRABAR_ASIENTO_RESOLUCIONCUPON
          .fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_GrabarAsientoResolucionCupon)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_GrabarAsientoResolucionCupon, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_CALCULAR_RETENCIONES
          .fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_CalcularRetenciones) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_CalcularRetenciones, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
            .Add2 cscEmpId, EmpId, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_CUE_ID_ANT_COBZ
          .fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_CuentaAnticipoCobranza) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_CuentaAnticipoCobranza, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_CUE_ID_ANT_OPG
          .fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_CuentaAnticipoPagos) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_CuentaAnticipoPagos, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_EXIGIR_CENTROCOSTO
          .fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_ExigirCentroCosto)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_ExigirCentroCosto, csText
            .Add2 cscCfgValor, IProperty.Value, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_COBRANZAS_XHOJARUTA
          .fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_CobranzasXHojaRuta)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_CobranzasXHojaRuta, csText
            .Add2 cscCfgValor, IProperty.Value, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
      End Select
    End With
  Next
  
  If Not pSaveRetencion() Then Exit Function
  
  cIABMClient_Save = Load()
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2862, vbNullString) 'Configuración General
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

' cIABMClientGrid

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_RET_ID
      cIABMClientGrid_IsEmptyRow = pIsEmptyRow(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  cIABMClientGrid_ColumnAfterUpdate = True
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

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_RET_ID
      cIABMClientGrid_ValidateRow = pValidateRow(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
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
  
  m_Host.Server.AddMenu C_MenuTesoreria, csMenuConfigTesoreria, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(2431, vbNullString), csPreGModifyConfigTesoreria, C_MenuTesoreria, 0, True, False, False, False, False, Me
                          'Gen&eral
  m_Host.Server.AddMenu vbNullString, csPreGModifyConfigTesoreria * -1, C_MenuTesoreria, 0, True, True, False, False, False, Nothing

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  pEdit
End Function

' funciones friend
' funciones privadas
Private Function Load() As Boolean
  Dim sqlstmt As String
  Dim rs As Recordset

  sqlstmt = "select * from configuracion where emp_id is null and cfg_grupo = " & gDB.sqlString(c_GrupoGeneral)

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  m_cue_id_difCambio = csNO_ID
  m_CuentaDifCambio = vbNullString
  
  m_doc_id_NCdifCambio = csNO_ID
  m_DocNCDifCambio = ""
  
  m_doc_id_NDdifCambio = csNO_ID
  m_DocNDDifCambio = ""
  
  m_pr_id_difCambio = csNO_ID
  m_ProductoDifCambio = ""
  
  m_DefaultDifCambio = csEDifCambioNCND
  m_ModoIvaDifCambio = csEDifIvaImponible
  m_AplicacionDifCambio = csEDifAplicacionND
  
  m_GrabarAsientoDepositoBanco = False
  m_GrabarAsientoCobranza = False
  m_GrabarAsientoOrdenPago = False
  m_GrabarAsientoMovimientoFondo = False
  m_GrabarAsientoRendicion = False
  m_GrabarAsientoDepositoCupon = False
  m_GrabarAsientoResolucionCupon = False
  m_GrabarAsientoAgrupado = False
  m_CobranzasXHojaRuta = False
  
  m_CalcularRetenciones = False
  
  m_cue_id_ant_cobz = csNO_ID
  m_CueAnticipoCobz = ""
  
  m_cue_id_ant_opg = csNO_ID
  m_CueAnticipoOpg = ""
  
  m_ExigirCentroCosto = False
  
  While Not rs.EOF
    Select Case gDB.ValField(rs.fields, cscCfgAspecto)
      Case c_CueIdDifCambio
        m_cue_id_difCambio = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTCuenta, cscCueId, m_cue_id_difCambio, cscCueNombre, m_CuentaDifCambio) Then Exit Function
      Case c_PrIdDifCambio
        m_pr_id_difCambio = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTProducto, cscPrId, m_pr_id_difCambio, cscPrNombreventa, m_ProductoDifCambio) Then Exit Function
      Case c_ModoIvaDifCambio
        m_ModoIvaDifCambio = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case c_AplicacionDifCambio
        m_AplicacionDifCambio = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case c_DefaultDifCambio
        m_DefaultDifCambio = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case c_GrabarAsientoCobranza
        m_GrabarAsientoCobranza = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case c_GrabarAsientoDepositoBanco
        m_GrabarAsientoDepositoBanco = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case c_GrabarAsientoOrdenPago
        m_GrabarAsientoOrdenPago = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case c_GrabarAsientoMovimientoFondo
        m_GrabarAsientoMovimientoFondo = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case c_GrabarAsientoRendicion
        m_GrabarAsientoRendicion = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case c_GrabarAsientoResolucionCupon
        m_GrabarAsientoResolucionCupon = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case c_GrabarAsientoAgrupado
        m_GrabarAsientoAgrupado = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case c_GrabarAsientoDepositoCupon
        m_GrabarAsientoDepositoCupon = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case c_ExigirCentroCosto
        m_ExigirCentroCosto = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case c_CobranzasXHojaRuta
        m_CobranzasXHojaRuta = Val(gDB.ValField(rs.fields, cscCfgValor))
      End Select
    rs.MoveNext
  Wend

  sqlstmt = "select * from configuracion where emp_id = " & EmpId & " and cfg_grupo = " & gDB.sqlString(c_GrupoGeneral)

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  While Not rs.EOF
    Select Case gDB.ValField(rs.fields, cscCfgAspecto)
      Case c_NCDifCambio
        m_doc_id_NCdifCambio = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_NCdifCambio, cscDocNombre, m_DocNCDifCambio) Then Exit Function
      Case c_NDDifCambio
        m_doc_id_NDdifCambio = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_NDdifCambio, cscDocNombre, m_DocNDDifCambio) Then Exit Function
      Case c_DocIdCobranza
        m_doc_id_Cobranza = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_Cobranza, cscDocNombre, m_DocCobranza) Then Exit Function
      Case c_DocIdOrdenPago
        m_doc_id_OrdenPago = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_OrdenPago, cscDocNombre, m_DocOrdenPago) Then Exit Function
      Case c_CalcularRetenciones
        m_CalcularRetenciones = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case c_CuentaAnticipoCobranza
        m_cue_id_ant_cobz = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTCuenta, cscCueId, m_cue_id_ant_cobz, cscCueNombre, m_CueAnticipoCobz) Then Exit Function
      Case c_CuentaAnticipoPagos
        m_cue_id_ant_opg = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTCuenta, cscCueId, m_cue_id_ant_opg, cscCueNombre, m_CueAnticipoOpg) Then Exit Function
    End Select
    rs.MoveNext
  Wend

  Load = True
End Function

Private Sub pEdit()
  On Error GoTo ControlError
  
  Set m_ObjAbm = New cABMGeneric
  
  If Not SecurityCanAccess(csPreGModifyConfigTesoreria) Then Exit Sub

  If Not Load() Then Exit Sub
  
  If Not LoadCollection() Then Exit Sub
  
  m_Editing = True
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", C_Module, ""
End Sub

Private Function LoadCollection() As Boolean
  Dim c    As cIABMProperty
  
  Const c_tab_general = 0
  Const c_tab_contabilidad = 1
  Const c_tab_difCambio = 2
  Const c_tab_retencion = 3
  
  With m_ObjAbm.Tabs
    
    .Clear
    
    With .Add(Nothing)
      .Index = c_tab_general
      .Name = C_strGeneral
    End With
    
    With .Add(Nothing)
      .Index = c_tab_contabilidad
      .Name = LNGGetText(3124, vbNullString)  'Contabilidad
    End With
      
    With .Add(Nothing)
      .Index = c_tab_difCambio
      .Name = LNGGetText(3125, vbNullString)  'Diferencia cambio
    End With
    
    With .Add(Nothing)
      .Index = c_tab_retencion
      .Name = LNGGetText(1393, vbNullString)  'Retenciones
    End With
  
  End With
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  AbmObj.MinHeight = 6500

  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, c_DefaultDifCambio)
      .PropertyType = cspList
      .Left = 2000
      .Width = 3000
      .LeftLabel = -1500
      .Name = c_DefaultDifCambio
      .Key = K_DEFAULT_DIFCAMBIO
      .ListWhoSetItem = csListItemData
      .ListItemData = m_DefaultDifCambio
      With .List.Add(Nothing)
        .ID = csEModoDifCambio.csEDifCambioCuenta
        .Value = LNGGetText(2142, vbNullString)  'Una cuenta contable
      End With
      With .List.Add(Nothing)
        .ID = csEModoDifCambio.csEDifCambioNCND
        .Value = LNGGetText(2143, vbNullString)  'Una nota de debito o credito
      End With
      .TabIndex = c_tab_difCambio
    End With
      
    With .Add(Nothing, c_CueIdDifCambio)
      .PropertyType = cspHelp
      .Table = csCuenta
      .Left = 2000
      .Width = 3000
      .LeftLabel = -1500
      .Name = c_CueIdDifCambio
      .Key = K_CUE_ID_DIFCAMBIO
      .HelpId = m_cue_id_difCambio
      .Value = m_CuentaDifCambio
      .TabIndex = c_tab_difCambio
    End With
    
    With .Add(Nothing, c_NCDifCambio)
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Left = 2000
      .Width = 3000
      .LeftLabel = -1500
      .Name = c_NCDifCambio
      .Key = K_DOC_ID_NC_DIFCAMBIO
      .HelpId = m_doc_id_NCdifCambio
      .HelpFilter = "'doct_id = 7'"
      .Value = m_DocNCDifCambio
      .TabIndex = c_tab_difCambio
    End With
    
    With .Add(Nothing, c_NDDifCambio)
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Left = 2000
      .Width = 3000
      .LeftLabel = -1500
      .Name = c_NDDifCambio
      .Key = K_DOC_ID_ND_DIFCAMBIO
      .HelpId = m_doc_id_NDdifCambio
      .HelpFilter = "'doct_id = 9'"
      .Value = m_DocNDDifCambio
      .TabIndex = c_tab_difCambio
    End With
    
    With .Add(Nothing, c_PrIdDifCambio)
      .PropertyType = cspHelp
      .Table = csProductoVenta
      .Left = 2000
      .Width = 3000
      .LeftLabel = -1500
      .Name = c_PrIdDifCambio
      .Key = K_PR_ID_DIFCAMBIO
      .HelpId = m_pr_id_difCambio
      .Value = m_ProductoDifCambio
      .TabIndex = c_tab_difCambio
    End With
    
    With .Add(Nothing, c_ModoIvaDifCambio)
      .PropertyType = cspList
      .Left = 2000
      .Width = 5000
      .LeftLabel = -1500
      .Name = c_ModoIvaDifCambio
      .Key = K_MODO_IVA_DIFCAMBIO
      .ListWhoSetItem = csListItemData
      .ListItemData = m_ModoIvaDifCambio
      With .List.Add(Nothing)
        .ID = csEModoIvaDifCambio.csEDifIvaImponible
        .Value = LNGGetText(2144, vbNullString)  'Tomar la diferencia de cambio como base imponible para el IVA
      End With
      With .List.Add(Nothing)
        .ID = csEModoIvaDifCambio.csEDifIvaNoImponible
        .Value = LNGGetText(2145, vbNullString)  'IVA incluido en la diferencia de cambio
      End With
      .TabIndex = c_tab_difCambio
    End With
    
    With .Add(Nothing, c_AplicacionDifCambio)
      .PropertyType = cspList
      .Left = 2000
      .Width = 5000
      .LeftLabel = -1500
      .Name = c_AplicacionDifCambio
      .Key = K_APLICACION_DIFCAMBIO
      .ListWhoSetItem = csListItemData
      .ListItemData = m_AplicacionDifCambio
      With .List.Add(Nothing)
        .ID = csEAplicacionDifCambio.csEDifAplicacionND
        .Value = LNGGetText(2480, vbNullString)   'Cobrar la Nota de Débito y aplicar el resto a las Facturas
      End With
      With .List.Add(Nothing)
        .ID = csEAplicacionDifCambio.csEDifAplicacionFV
        .Value = LNGGetText(2481, vbNullString)   'Cobrar las Facturas y aplicar el resto a la Note de Débito
      End With
      .TabIndex = c_tab_difCambio
    End With
  
    With .Add(Nothing, c_DocIdCobranza)
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Left = 2000
      .Width = 3000
      .LeftLabel = -1500
      .Name = c_DocIdCobranza
      .Key = K_DOC_ID_COBRANZA
      .HelpId = m_doc_id_Cobranza
      .HelpFilter = "'doct_id = 13'"
      .Value = m_DocCobranza
    End With
    
    With .Add(Nothing, c_DocIdOrdenPago)
      .PropertyType = cspHelp
      .Table = csTblDocumento
      .Left = 2000
      .Width = 3000
      .LeftLabel = -1500
      .Name = c_DocIdOrdenPago
      .Key = K_DOC_ID_ORDENPAGO
      .HelpId = m_doc_id_OrdenPago
      .HelpFilter = "'doct_id = 16'"
      .Value = m_DocOrdenPago
    End With
        
    With .Add(Nothing, c_CuentaAnticipoCobranza)
      .PropertyType = cspHelp
      .Table = csCuenta
      .Left = 2000
      .Width = 3000
      .LeftLabel = -1500
      .Name = c_CuentaAnticipoCobranza
      .Key = K_CUE_ID_ANT_COBZ
      .Value = m_CueAnticipoCobz
      .HelpId = m_cue_id_ant_cobz
      .HelpFilter = "(" & cscCuecId & " = " & csECuecDeudPorVentas & _
                   " or " & cscCuecId & " = " & csECuecDepositoCupones & _
                   ")and " & GetHelpFilterCuenta()
    End With
    
    With .Add(Nothing, c_CuentaAnticipoPagos)
      .PropertyType = cspHelp
      .Table = csCuenta
      .Left = 2000
      .Width = 3000
      .LeftLabel = -1500
      .Name = c_CuentaAnticipoPagos
      .Key = K_CUE_ID_ANT_OPG
      .Value = m_CueAnticipoOpg
      .HelpId = m_cue_id_ant_opg
      .HelpFilter = cscCuecId & " = " & csECuecAcreedores
    End With
    
    With .Add(Nothing, c_CalcularRetenciones)
      .PropertyType = cspCheck
      .Left = 3500
      .LeftLabel = -3000
      .Width = 3000
      .TopToPrevious = 600
      .Name = c_CalcularRetenciones
      .Key = K_CALCULAR_RETENCIONES
      .Value = CInt(m_CalcularRetenciones)
    End With
    
    With .Add(Nothing, c_CobranzasXHojaRuta)
      .PropertyType = cspCheck
      .Left = 3500
      .LeftLabel = -3000
      .Name = LNGGetText(5122, vbNullString)  'Cobranzas por Hoja de Ruta
      .Key = K_COBRANZAS_XHOJARUTA
      .Value = m_CobranzasXHojaRuta
    End With
    
    With .Add(Nothing, c_GrabarAsientoCobranza)
      .PropertyType = cspCheck
      .Left = 4500
      .LeftLabel = -4000
      .Name = LNGGetText(3126, vbNullString)  'Grabar asiento al grabar la Cobranza
      .Key = K_GRABAR_ASIENTO_COBRANZA
      .Value = m_GrabarAsientoCobranza
      .TabIndex = c_tab_contabilidad
    End With
    
    With .Add(Nothing, c_GrabarAsientoOrdenPago)
      .PropertyType = cspCheck
      .Left = 4500
      .LeftLabel = -4000
      .Name = LNGGetText(3127, vbNullString)  'Grabar asiento al grabar la Orden de Pago
      .Key = K_GRABAR_ASIENTO_ORDENPAGO
      .Value = m_GrabarAsientoOrdenPago
      .TabIndex = c_tab_contabilidad
    End With
    
    With .Add(Nothing, c_GrabarAsientoMovimientoFondo)
      .PropertyType = cspCheck
      .Left = 4500
      .LeftLabel = -4000
      .Name = LNGGetText(3128, vbNullString)  'Grabar asiento al grabar el Movimiento de Fondos
      .Key = K_GRABAR_ASIENTO_MOVIMIENTOFONDO
      .Value = m_GrabarAsientoMovimientoFondo
      .TabIndex = c_tab_contabilidad
    End With
    
    With .Add(Nothing, c_GrabarAsientoRendicion)
      .PropertyType = cspCheck
      .Left = 4500
      .LeftLabel = -4000
      .Name = LNGGetText(3129, vbNullString)  'Grabar asiento al grabar la Rendición
      .Key = K_GRABAR_ASIENTO_RENDICION
      .Value = m_GrabarAsientoRendicion
      .TabIndex = c_tab_contabilidad
    End With
    
    With .Add(Nothing, c_GrabarAsientoDepositoBanco)
      .PropertyType = cspCheck
      .Left = 4500
      .LeftLabel = -4000
      .Name = LNGGetText(3130, vbNullString)  'Grabar asiento al grabar el Depósito Bancario
      .Key = K_GRABAR_ASIENTO_DEPOSITOBANCO
      .Value = m_GrabarAsientoDepositoBanco
      .TabIndex = c_tab_contabilidad
    End With
    
    With .Add(Nothing, c_GrabarAsientoDepositoCupon)
      .PropertyType = cspCheck
      .Left = 4500
      .LeftLabel = -4000
      .Name = LNGGetText(3131, vbNullString)  'Grabar asiento al grabar la presentación de Cupones
      .Key = K_GRABAR_ASIENTO_DEPOSITOCUPON
      .Value = m_GrabarAsientoDepositoCupon
      .TabIndex = c_tab_contabilidad
    End With
    
    With .Add(Nothing, c_GrabarAsientoResolucionCupon)
      .PropertyType = cspCheck
      .Left = 4500
      .LeftLabel = -4000
      .Name = LNGGetText(3132, vbNullString)  'Grabar asiento al grabar la Resolución de Cupones
      .Key = K_GRABAR_ASIENTO_RESOLUCIONCUPON
      .Value = m_GrabarAsientoResolucionCupon
      .TabIndex = c_tab_contabilidad
    End With
  
    With .Add(Nothing, c_GrabarAsientoAgrupado)
      .PropertyType = cspCheck
      .Left = 4500
      .LeftLabel = -4000
      .Name = LNGGetText(4820, vbNullString)  'Grabar el asiento agrupado por cuentas
      .Key = K_GRABAR_ASIENTO_AGRUPADO
      .Value = m_GrabarAsientoAgrupado
      .TabIndex = c_tab_contabilidad
    End With
    
    With .Add(Nothing, c_ExigirCentroCosto)
      .PropertyType = cspCheck
      .Left = 4500
      .LeftLabel = -4000
      .Name = c_ExigirCentroCosto
      .Value = CInt(m_ExigirCentroCosto)
      .Key = K_EXIGIR_CENTROCOSTO
      .TabIndex = c_tab_contabilidad
    End With
    
    Set c = .Add(Nothing, c_Retencion)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadRetencion(c) Then Exit Function
      .Name = c_Retencion
      .Key = K_RET_ID
      .TabIndex = c_tab_retencion
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function pLoadRetencion(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  Dim Retencion   As String
  Dim ret_id      As Long
  
  sqlstmt = "select * from configuracion where emp_id = " & EmpId & _
             " and cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
             " and cfg_aspecto = " & gDB.sqlString(c_Retencion)
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadRetencion", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
  
    With .Columns
      
      With .Add(Nothing)
        .Visible = False
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1403, vbNullString)  'Retencion
        .PropertyType = cspHelp
        .Table = csRetencion
        .Width = 2200
        .Key = KI_RET_ID
      End With
      
    End With
    
    With .Rows
      
      While Not rs.EOF
      
        ret_id = Val(gDB.ValField(rs.fields, cscCfgValor))
        
        If ret_id <> csNO_ID Then
        
          Retencion = vbNullString
          
          If Not gDB.GetData(csTRetencion, _
                             cscRetId, _
                             ret_id, _
                             cscRetNombre, _
                             Retencion) Then Exit Function
        
          If Retencion <> vbNullString Then
          
            With .Add(Nothing)
            
              .Add Nothing
              
              With .Add(Nothing)
                .Value = Retencion
                .ID = ret_id
                .Key = KI_RET_ID
              End With
              
            End With
          End If
        End If
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadRetencion = True
End Function

Private Function pSaveRetencion() As Boolean
  Dim register  As cRegister
  
  Set register = New cRegister
  
  With register
    
    .Table = csTConfiguracion
    .fields.HaveLastUpdate = True
    .fields.HaveWhoModify = True
    .UtilizaIdentity = True
    
    ' Esto es para que el codigo en cDataBase no
    ' interprete que es un registro nuevo
    .ID = -1
        
    If Not .BeginTrans(gDB) Then Exit Function
    
    Dim sqlstmt As String
    
    sqlstmt = "delete configuracion where emp_id = " & EmpId & _
               " and cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
               " and cfg_aspecto = " & gDB.sqlString(c_Retencion)
               
    If Not gDB.Execute(sqlstmt) Then Exit Function
          
    Dim Row       As cIABMGridRow
    Dim Cell      As cIABMGridCellValue
    
    For Each Row In pGetRetencion().Rows
    
      .fields.Clear
      
      With .fields
        .Add2 cscCfgGrupo, c_GrupoGeneral, csText
        .Add2 cscCfgAspecto, c_Retencion, csText
        .Add2 cscCfgValor, pCell(Row, KI_RET_ID).ID, csText
        .Add2 cscEmpId, EmpId, csText
      End With
      
      If Not gDB.Save(register, True, C_ABMClientSave, C_Module, _
             c_ErrorSave) Then Exit Function
    Next
    
    If Not .CommitTrans() Then Exit Function
  End With

  pSaveRetencion = True
End Function

Private Function pGetRetencion() As cIABMGrid
  Set pGetRetencion = m_ObjAbm.Properties.Item(c_Retencion).Grid
End Function

Private Function pIsEmptyRow(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_RET_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRow = bRowIsEmpty
End Function

Private Function pValidateRow(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_RET_ID
        If ValEmpty(Cell.ID, csId) Then
          MsgInfo LNGGetText(1386, vbNullString)  'Debe indicar una Retencion (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRow = True
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(2301, vbNullString) 'Error al grabar la Configuración General

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
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

