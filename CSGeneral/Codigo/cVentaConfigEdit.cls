VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cVentaConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cVentaConfigEdit
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
Private Const C_Module = "cVentaConfigEdit"

Private Const K_CUE_ID_DESCUENTO               As Integer = 1
Private Const K_GRABAR_ASIENTO                 As Integer = 2
Private Const K_WEBMAIL_LEYENDA                As Integer = 3
Private Const K_APLIC_CLIENTE_FAMILIA          As Integer = 4
Private Const K_DECIMALES_EN_PRECIOS           As Integer = 5
Private Const K_RESTO_ENTERO                   As Integer = 6
Private Const K_REDONDEO_EN_PRECIOS            As Integer = 7
Private Const K_USAR_LISTAPRECIOPRECIO         As Integer = 8
Private Const K_RAZONSOCIAL                    As Integer = 9
Private Const K_CATFISCAL                      As Integer = 10
Private Const K_CPG_ID                         As Integer = 11
Private Const K_LP_ID                          As Integer = 12
Private Const K_PRO_ID                         As Integer = 13
Private Const K_ZON_ID                         As Integer = 14
Private Const K_PERC_ID                        As Integer = 15
Private Const K_EXIGIR_CAJA                    As Integer = 16
Private Const K_EXIGIR_CENTROCOSTO             As Integer = 17

Private Const K_DOC_ID_SOBRANTE                As Integer = 18
Private Const K_DOC_ID_FALTANTE                As Integer = 19
Private Const K_DOC_ID_TICKETS                 As Integer = 20

Private Const K_CUE_ID_SOBRANTES               As Integer = 21
Private Const K_CUE_ID_TICKETS                 As Integer = 22
Private Const K_PR_ID_FALTANTES                As Integer = 23

Private Const K_COBRANZA_POR_CAJERO            As Integer = 24
Private Const K_VENTAS_POR_HOJADERUTA          As Integer = 25

Private Const KI_PERC_ID                       As Integer = 16

Private Const c_GrupoGeneral = "Ventas-General"
Private Const c_CueIdDescGlobal = "Cuenta Descuento Global"
Private Const c_GrabarAsiento = "Grabar Asiento"
Private Const c_WebUserMailLeyenda = "Leyenda para Usuarios de la Intranet"
Private Const c_AplicClienteFamilia = "Aplicaciones entre Grupos de Clientes"
Private Const c_RedondeoEnPrecios = "Redondear Decimales en Precios"
Private Const c_DecimalesEnPrecios = "Decimales en Precios"
Private Const c_RestoEntero = "Restar a precios enteros"
Private Const c_UsarListaPrecioPrecio = "Utilizar Cache de Precios"
Private Const c_ExigirCaja = "Exigir que la Caja Este Abierta para Facturar"
Private Const c_ExigirCentroCosto = "Exigir Centro Costo"
Private Const c_CobranzaPorCajero = "Concentrar Cobranzas en Cajero"
Private Const c_VentasPorHojadeRuta = "Ventas por Hoja de Ruta"

Private Const c_DocFacturaFaltante = "Factura x Faltante en Hoja Ruta"
Private Const c_DocMovimientoSobrante = "Mov. Fondo Sobrante en Hoja Ruta"
Private Const c_DocMovimientoTicket = "Mov. Fondo Tickets en Hoja Ruta"
Private Const c_CueIdTickets = "Cuenta Comision sobre Tickets"
Private Const c_CueIdSobrante = "Cuenta para Sobrante en Rendicion"
Private Const c_PrIdFaltante = "Articulo para Faltantes en Rendicion"

Private Const c_Percepcion = "Percepcion"
Private Const c_ClientesPV = "ClientesPV"

' estructuras
' Seudo - variables
Private c_ErrorSave               As String

' variables privadas
Private m_cue_id_descGlobal       As Long
Private m_CuentaDescGlobal        As String

Private m_cue_id_sobrantes        As Long
Private m_CuentaSobrantes         As String

Private m_cue_id_tickets          As Long
Private m_CuentaTickets           As String

Private m_pr_id_faltantes         As Long
Private m_ProductoFaltantes       As String

Private m_GrabarAsiento           As Boolean
Private m_AplicClienteFamilia     As Boolean
Private m_RedondoEnPrecios        As Boolean
Private m_UsarListaPrecioPrecio   As Boolean
Private m_DecimalesEnPrecio       As Long
Private m_RestoEntero             As Double
Private m_WebUserMaiLeyenda       As String
Private m_ExigirCaja              As Boolean
Private m_ExigirCentroCosto       As Boolean
Private m_CobranzaPorCajero       As Boolean
Private m_VentasPorHojadeRuta     As Boolean


Private m_Razonsocial                  As String
Private m_CatFiscal                    As Integer
Private m_CondicionPago                As String
Private m_Cpg_id                       As Long
Private m_Lp_id                        As Long
Private m_ListaPrecio                  As String

Private m_Provincia                    As String
Private m_pro_id                       As Long
Private m_zon_id                       As Long
Private m_Zona                         As String

Private m_doc_id_faltante              As Long
Private m_DocFaltante                  As String
Private m_doc_id_sobrante              As Long
Private m_DocSobrante                  As String
Private m_doc_id_tickets               As Long
Private m_DocTickets                   As String


Private m_Editing                 As Boolean
Private m_Host                    As CSMenu.cIMenuHost
Private m_ObjAbm                  As cIABMGeneric
' eventos
' propiedades publicas
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
  cIABMClient_PropertyChange = True
  
  With m_ObjAbm.Properties
  
    Select Case Key
        
      Case K_REDONDEO_EN_PRECIOS
      
        If Val(.Item(c_RedondeoEnPrecios).Value) Then
        
          .Item(c_DecimalesEnPrecios).Enabled = True
          .Item(c_RestoEntero).Enabled = True
        Else
          .Item(c_DecimalesEnPrecios).Enabled = False
          .Item(c_RestoEntero).Enabled = False
        End If
    End Select
  End With
End Function

Private Function cIABMClient_Save() As Boolean
  Dim IProperty As cIABMProperty
  Dim IsNew     As Boolean
  Dim register  As cRegister
  
  Set register = New cRegister
  
  With register
    .Table = csTConfiguracion
    .Fields.HaveLastUpdate = True
    .Fields.HaveWhoModify = True
    .UtilizaIdentity = True
    
    ' Esto es para que el codigo en cDataBase no
    ' interprete que es un registro nuevo
    .ID = -1
  End With
  
  For Each IProperty In m_ObjAbm.Properties
    With register
      Select Case IProperty.Key
        Case K_CUE_ID_DESCUENTO
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_CueIdDescGlobal)
          
          If Not register.Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_CueIdDescGlobal, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_GRABAR_ASIENTO
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_GrabarAsiento)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_GrabarAsiento, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_WEBMAIL_LEYENDA
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_WebUserMailLeyenda)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_WebUserMailLeyenda, csText
            .Add2 cscCfgValor, IProperty.Value, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_EXIGIR_CAJA
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_ExigirCaja)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_ExigirCaja, csText
            .Add2 cscCfgValor, IProperty.Value, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_EXIGIR_CENTROCOSTO
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_ExigirCentroCosto)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_ExigirCentroCosto, csText
            .Add2 cscCfgValor, IProperty.Value, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_APLIC_CLIENTE_FAMILIA
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_AplicClienteFamilia)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_AplicClienteFamilia, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
              
        Case K_REDONDEO_EN_PRECIOS
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_RedondeoEnPrecios)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_RedondeoEnPrecios, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_USAR_LISTAPRECIOPRECIO
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_UsarListaPrecioPrecio)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_UsarListaPrecioPrecio, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_DECIMALES_EN_PRECIOS
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_DecimalesEnPrecios)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_DecimalesEnPrecios, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_RESTO_ENTERO
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_RestoEntero)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_RestoEntero, csText
            .Add2 cscCfgValor, gDB.sqlNumber(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
            
        Case K_RAZONSOCIAL
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_ClientesPV & cscCliRazonsocial)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_ClientesPV & cscCliRazonsocial, csText
            .Add2 cscCfgValor, IProperty.Value, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_CATFISCAL
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_ClientesPV & cscCliCatfiscal)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_ClientesPV & cscCliCatfiscal, csText
            .Add2 cscCfgValor, IProperty.ListItemData, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_CPG_ID
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_ClientesPV & cscCpgId)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_ClientesPV & cscCpgId, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_LP_ID
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_ClientesPV & cscLpId)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_ClientesPV & cscLpId, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_PRO_ID
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_ClientesPV & cscProId)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_ClientesPV & cscProId, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_ZON_ID
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_ClientesPV & cscZonId)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_ClientesPV & cscZonId, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_DOC_ID_FALTANTE
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_DocFacturaFaltante) & _
                    " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_DocFacturaFaltante, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_DOC_ID_SOBRANTE
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_DocMovimientoSobrante) & _
                    " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_DocMovimientoSobrante, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_DOC_ID_TICKETS
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_DocMovimientoTicket) & _
                    " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_DocMovimientoTicket, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_PR_ID_FALTANTES
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_PrIdFaltante) & _
                    " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_PrIdFaltante, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_CUE_ID_SOBRANTES
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_CueIdSobrante) & _
                    " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_CueIdSobrante, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_CUE_ID_TICKETS
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_CueIdTickets) & _
                    " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_CueIdTickets, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_COBRANZA_POR_CAJERO
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_CobranzaPorCajero)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_CobranzaPorCajero, csText
            .Add2 cscCfgValor, IProperty.Value, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_COBRANZA_POR_CAJERO
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_CobranzaPorCajero)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_CobranzaPorCajero, csText
            .Add2 cscCfgValor, IProperty.Value, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_VENTAS_POR_HOJADERUTA
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_VentasPorHojadeRuta)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_VentasPorHojadeRuta, csText
            .Add2 cscCfgValor, IProperty.Value, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
      End Select
    End With
  Next
  
  If Not pSavePercepcion() Then Exit Function
  
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

  Dim IProperty As cIABMProperty

  CSKernelClient2.Title = LNGGetText(2862, vbNullString) 'Configuración General

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_CUE_ID_DESCUENTO
          If .HelpId = csNO_ID Then
            MsgInfo LNGGetText(3204, vbNullString)
                    ' Debe indicar una cuenta para que Cairo pueda _
                    grabar facturas con descuentos globales.;; _
                    Los parámetros se guardarán de todas formas.
          End If
      End Select
    End With
  Next

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
    Case K_PERC_ID
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
    Case K_PERC_ID
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
  Dim str_1033    As String
  
  str_1033 = LNGGetText(1033, vbNullString)   'Ve&ntas
  Set m_Host = Host
  m_Host.Server.AddMenu str_1033, csMenuConfigVentas, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(2431, vbNullString), csPreGModifyConfigVentas, str_1033, 0, True, False, False, False, False, Me
                        'Gen&eral
  m_Host.Server.AddMenu vbNullString, csPreGModifyConfigVentas * -1, str_1033, 0, True, True, False, False, False, Nothing

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

Private Function Load() As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset

  sqlstmt = "select * from configuracion where emp_id is null and cfg_grupo = " & _
                 gDB.sqlString(c_GrupoGeneral)

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  m_cue_id_descGlobal = csNO_ID
  m_CuentaDescGlobal = vbNullString
  m_GrabarAsiento = False
  m_WebUserMaiLeyenda = LNGGetText(3205, vbNullString)
                        'Le notificamos que hemos creado una cuenta de usuario _
                         para que Ud. acceda a nuestra extranet. _
                         Usuario: @@usuario _
                         Contraseña: @@clave
  m_AplicClienteFamilia = False
  m_RedondoEnPrecios = False
  m_UsarListaPrecioPrecio = False
  m_DecimalesEnPrecio = 0
  m_RestoEntero = 0
  m_ExigirCaja = True
  m_ExigirCentroCosto = False
  m_CobranzaPorCajero = False
  m_VentasPorHojadeRuta = False

  m_doc_id_faltante = csNO_ID
  m_doc_id_sobrante = csNO_ID
  m_doc_id_tickets = csNO_ID
  
  m_DocTickets = vbNullString
  m_DocSobrante = vbNullString
  m_DocFaltante = vbNullString
  
  m_pr_id_faltantes = csNO_ID
  m_cue_id_sobrantes = csNO_ID
  m_cue_id_tickets = csNO_ID
  
  m_CuentaTickets = vbNullString
  m_CuentaSobrantes = vbNullString
  m_ProductoFaltantes = vbNullString
  
  While Not rs.EOF
    Select Case gDB.ValField(rs.Fields, cscCfgAspecto)
      Case c_CueIdDescGlobal
        m_cue_id_descGlobal = Val(gDB.ValField(rs.Fields, cscCfgValor))
        If Not gDB.GetData(csTCuenta, cscCueId, m_cue_id_descGlobal, cscCueNombre, m_CuentaDescGlobal) Then Exit Function
      Case c_GrabarAsiento
        m_GrabarAsiento = Val(gDB.ValField(rs.Fields, cscCfgValor))
      Case c_WebUserMailLeyenda
        m_WebUserMaiLeyenda = gDB.ValField(rs.Fields, cscCfgValor)
      Case c_ExigirCaja
        m_ExigirCaja = gDB.ValField(rs.Fields, cscCfgValor)
      Case c_CobranzaPorCajero
        m_CobranzaPorCajero = gDB.ValField(rs.Fields, cscCfgValor)
      Case c_VentasPorHojadeRuta
        m_VentasPorHojadeRuta = gDB.ValField(rs.Fields, cscCfgValor)
      Case c_ExigirCentroCosto
        m_ExigirCentroCosto = gDB.ValField(rs.Fields, cscCfgValor)
      Case c_AplicClienteFamilia
        m_AplicClienteFamilia = Val(gDB.ValField(rs.Fields, cscCfgValor))
      Case c_RedondeoEnPrecios
        m_RedondoEnPrecios = Val(gDB.ValField(rs.Fields, cscCfgValor))
      Case c_UsarListaPrecioPrecio
        m_UsarListaPrecioPrecio = Val(gDB.ValField(rs.Fields, cscCfgValor))
      Case c_DecimalesEnPrecios
        m_DecimalesEnPrecio = Val(gDB.ValField(rs.Fields, cscCfgValor))
      Case c_RestoEntero
      
        ' Yo guarde el campo con un punto como separador ya que use
        ' gDB.sqlNumber() para formatear el valor.
        '
        ' Ahora tengo que reemplazar el . por el separador decimal
        ' correspondiente a la configuracion regional
        '
        Dim sep As String
        Dim Value As String
        
        Value = gDB.ValField(rs.Fields, cscCfgValor)
        sep = CSKernelClient2.GetSepDecimal()
        If sep <> "." Then Value = Replace(Value, ".", sep)
        
        m_RestoEntero = Val(Value)
              
      Case c_ClientesPV & cscCliRazonsocial
        m_Razonsocial = gDB.ValField(rs.Fields, cscCfgValor)
        
      Case c_ClientesPV & cscCliCatfiscal
        m_CatFiscal = Val(gDB.ValField(rs.Fields, cscCfgValor))
        
      Case c_ClientesPV & cscCpgId
        m_Cpg_id = Val(gDB.ValField(rs.Fields, cscCfgValor))
        If Not gDB.GetData(csTCondicionPago, cscCpgId, m_Cpg_id, cscCpgNombre, m_CondicionPago) Then Exit Function
        
      Case c_ClientesPV & cscLpId
        m_Lp_id = Val(gDB.ValField(rs.Fields, cscCfgValor))
        If Not gDB.GetData(csTListaPrecio, cscLpId, m_Lp_id, cscLpNombre, m_ListaPrecio) Then Exit Function
        
      Case c_ClientesPV & cscProId
        m_pro_id = Val(gDB.ValField(rs.Fields, cscCfgValor))
        If Not gDB.GetData(csTProvincia, cscProId, m_pro_id, cscProNombre, m_Provincia) Then Exit Function
        
      Case c_ClientesPV & cscZonId
        m_zon_id = Val(gDB.ValField(rs.Fields, cscCfgValor))
        If Not gDB.GetData(csTZona, cscZonId, m_zon_id, cscZonNombre, m_Zona) Then Exit Function
                
    End Select
    
    rs.MoveNext
  Wend

  sqlstmt = "select * from configuracion where emp_id = " & EmpId & " and cfg_grupo = " & _
                 gDB.sqlString(c_GrupoGeneral)

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  While Not rs.EOF
    Select Case gDB.ValField(rs.Fields, cscCfgAspecto)
                
      Case c_DocFacturaFaltante
        m_doc_id_faltante = Val(gDB.ValField(rs.Fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_faltante, cscDocNombre, m_DocFaltante) Then Exit Function
    
      Case c_DocMovimientoSobrante
        m_doc_id_sobrante = Val(gDB.ValField(rs.Fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_sobrante, cscDocNombre, m_DocSobrante) Then Exit Function
    
      Case c_DocMovimientoTicket
        m_doc_id_tickets = Val(gDB.ValField(rs.Fields, cscCfgValor))
        If Not gDB.GetData(csTDocumento, cscDocId, m_doc_id_tickets, cscDocNombre, m_DocTickets) Then Exit Function
                                
      Case c_PrIdFaltante
        m_pr_id_faltantes = Val(gDB.ValField(rs.Fields, cscCfgValor))
        If Not gDB.GetData(csTProducto, cscPrId, m_pr_id_faltantes, cscPrNombreventa, m_ProductoFaltantes) Then Exit Function
    
      Case c_CueIdSobrante
        m_cue_id_sobrantes = Val(gDB.ValField(rs.Fields, cscCfgValor))
        If Not gDB.GetData(csTCuenta, cscCueId, m_cue_id_sobrantes, cscCueNombre, m_CuentaSobrantes) Then Exit Function
    
      Case c_CueIdTickets
        m_cue_id_tickets = Val(gDB.ValField(rs.Fields, cscCfgValor))
        If Not gDB.GetData(csTCuenta, cscCueId, m_cue_id_tickets, cscCueNombre, m_CuentaTickets) Then Exit Function
                
    End Select
    
    rs.MoveNext
  Wend

  Load = True
End Function

Private Sub pEdit()
  On Error GoTo ControlError
  
  Set m_ObjAbm = New cABMGeneric
  
  If Not SecurityCanAccess(csPreGModifyConfigVentas) Then Exit Sub

  If Not Load() Then Exit Sub
  
  If Not LoadCollection() Then Exit Sub
  
  m_Editing = True
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", C_Module, vbNullString
End Sub

Private Function LoadCollection() As Boolean
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 8500

  Dim c    As cIABMProperty
  
  Const c_tab_general = 0
  Const c_tab_Percepcion = 1
  Const c_tab_ClientesPV = 2
  Const c_tab_HojaRuta = 3
  
  With m_ObjAbm.Tabs
    
    .Clear
    
    With .Add(Nothing)
      .Index = c_tab_general
      .Name = C_strGeneral
    End With
        
    With .Add(Nothing)
      .Index = c_tab_Percepcion
      .Name = LNGGetText(1248, vbNullString)  'Percepciones
    End With
  
    With .Add(Nothing)
      .Index = c_tab_ClientesPV
      .Name = LNGGetText(4501, vbNullString)  'Clientes Punto de Venta
    End With
  
    With .Add(Nothing)
      .Index = c_tab_HojaRuta
      .Name = LNGGetText(4940, vbNullString)  'Hojas de Ruta
    End With
  
  End With

  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, c_CueIdDescGlobal)
      .PropertyType = cspHelp
      .Table = csCuenta
      .Left = 3100
      .Width = 3000
      .LeftLabel = -2800
      .Name = LNGGetText(3094, vbNullString) 'Cuenta de descuento global
      .Key = K_CUE_ID_DESCUENTO
      .HelpId = m_cue_id_descGlobal
      .Value = m_CuentaDescGlobal
    End With
    
    With .Add(Nothing, c_GrabarAsiento)
      .PropertyType = cspCheck
      .Left = 3100
      .Width = 400
      .LeftLabel = -2800
      .Name = LNGGetText(3095, vbNullString) 'Grabar asiento al grabar la factura
      .Key = K_GRABAR_ASIENTO
      .Value = CInt(m_GrabarAsiento)
    End With
    
    With .Add(Nothing, c_AplicClienteFamilia)
      .PropertyType = cspCheck
      .Left = 3100
      .Width = 400
      .LeftLabel = -2800
      .Name = LNGGetText(3477, vbNullString) 'Aplicaciones entre Clientes de un Grupo
      .Key = K_APLIC_CLIENTE_FAMILIA
      .Value = CInt(m_AplicClienteFamilia)
    End With
    
    With .Add(Nothing, c_UsarListaPrecioPrecio)
      .PropertyType = cspCheck
      .Left = 3100
      .Width = 400
      .LeftLabel = -2800
      .Name = LNGGetText(3597, vbNullString) 'Usar Cache de Precios
      .Key = K_USAR_LISTAPRECIOPRECIO
      .Value = CInt(m_UsarListaPrecioPrecio)
    End With
    
    With .Add(Nothing, c_RedondeoEnPrecios)
      .PropertyType = cspCheck
      .Left = 3100
      .Width = 400
      .LeftLabel = -2800
      .Name = LNGGetText(3577, vbNullString) 'Redondear Decimales en Precios
      .Key = K_REDONDEO_EN_PRECIOS
      .Value = CInt(m_RedondoEnPrecios)
    End With
    
    With .Add(Nothing, c_DecimalesEnPrecios)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Left = 3100
      .Width = 800
      .LeftLabel = -2800
      .Name = LNGGetText(3578, vbNullString) 'Decimales en precio
      .Key = K_DECIMALES_EN_PRECIOS
      .Value = m_DecimalesEnPrecio
      .Enabled = m_RedondoEnPrecios
    End With
    
    With .Add(Nothing, c_RestoEntero)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Left = 3100
      .Width = 1000
      .LeftLabel = -2800
      .Name = LNGGetText(3579, vbNullString) 'Restar a precios enteros
      .Key = K_RESTO_ENTERO
      .Value = m_RestoEntero
      .Enabled = m_RedondoEnPrecios
    End With
    
    With .Add(Nothing, c_WebUserMailLeyenda)
      .PropertyType = cspText
      .SubType = cspMemo
      .Left = 3100
      .Width = 6000
      .Height = 1000
      .LeftLabel = -2800
      .Name = LNGGetText(3206, vbNullString) 'Leyenda para Usuarios de la Intranet
      .Key = K_WEBMAIL_LEYENDA
      .Value = m_WebUserMaiLeyenda
    End With
        
    With .Add(Nothing, c_ExigirCaja)
      .PropertyType = cspCheck
      .Name = c_ExigirCaja
      .Value = CInt(m_ExigirCaja)
      .Key = K_EXIGIR_CAJA
      .LeftLabel = -2800
    End With
        
    With .Add(Nothing, c_CobranzaPorCajero)
      .PropertyType = cspCheck
      .Name = c_CobranzaPorCajero
      .Value = CInt(m_CobranzaPorCajero)
      .Key = K_COBRANZA_POR_CAJERO
      .LeftLabel = -2800
    End With
        
    With .Add(Nothing, c_VentasPorHojadeRuta)
      .PropertyType = cspCheck
      .Name = c_VentasPorHojadeRuta
      .Value = CInt(m_VentasPorHojadeRuta)
      .Key = K_VENTAS_POR_HOJADERUTA
      .LeftLabel = -2800
    End With
        
    With .Add(Nothing, c_ExigirCentroCosto)
      .PropertyType = cspCheck
      .Name = c_ExigirCentroCosto
      .Value = CInt(m_ExigirCentroCosto)
      .Key = K_EXIGIR_CENTROCOSTO
      .LeftLabel = -2800
    End With
        
    Set c = .Add(Nothing, c_Percepcion)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadPercepcion(c) Then Exit Function
      .Name = c_Percepcion
      .Key = K_PERC_ID
      .TabIndex = c_tab_Percepcion
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    '//////////////////////////////////////////////////////////////
    '
    ' Solapa Clientes en Punto de Venta
    '
    
    With .Add(Nothing, cscCliRazonsocial)
      .PropertyType = cspText
      .Name = LNGGetText(1178, vbNullString) 'Razon Social
      .Width = 6100
      .Size = 255
      .Key = K_RAZONSOCIAL
      .Value = m_Razonsocial
      .TabIndex = c_tab_ClientesPV
    End With
    
    With .Add(Nothing, cscCliCatfiscal)
      .PropertyType = cspList
      .Name = LNGGetText(1181, vbNullString) 'Categoria Fiscal
      .Key = K_CATFISCAL
      .ListWhoSetItem = csListItemData
      .ListItemData = m_CatFiscal
      .TabIndex = c_tab_ClientesPV
      
      With .List
        
        With .Add(Nothing, csCatFConsumidorFinal)
          .ID = csCatFConsumidorFinal
          .Value = LNGGetText(1182, vbNullString) 'Consumidor final
        End With
        
        With .Add(Nothing, csCatFNoInscripto)
          .ID = csCatFNoInscripto
          .Value = LNGGetText(1183, vbNullString) 'No Inscripto
        End With
        
        With .Add(Nothing, csCatFInscripto)
          .ID = csCatFInscripto
          .Value = LNGGetText(1184, vbNullString) 'Inscripto
        End With
        
        With .Add(Nothing, csCatFExtranjero)
          .ID = csCatFExtranjero
          .Value = LNGGetText(1185, vbNullString) 'Extranjero
        End With
        
        With .Add(Nothing, csCatFExento)
          .ID = csCatFExento
          .Value = LNGGetText(1186, vbNullString) 'Exento
        End With
      
        With .Add(Nothing, csCatFMonoTributo)
          .ID = csCatFMonoTributo
          .Value = LNGGetText(1187, vbNullString) 'Monotributo
        End With
      
        With .Add(Nothing, csCatFExtranjeroIva)
          .ID = csCatFExtranjeroIva
          .Value = LNGGetText(1188, vbNullString) 'Extranjero con Iva
        End With
      
        With .Add(Nothing, csCatFNoCategorizado)
          .ID = csCatFNoCategorizado
          .Value = LNGGetText(1189, vbNullString) 'No categorizado
        End With
      
        With .Add(Nothing, csCatFNoResponsable)
          .ID = csCatFNoResponsable
          .Value = LNGGetText(1190, vbNullString) 'No responsable
        End With
      
        With .Add(Nothing, csCatFNoResponsableExento)
          .ID = csCatFNoResponsableExento
          .Value = LNGGetText(1191, vbNullString) 'No responsable exento
        End With
      
        With .Add(Nothing, csCatFInscriptoM)
          .ID = csCatFInscriptoM
          .Value = LNGGetText(1192, vbNullString) 'Inscripto M
        End With
      
      End With
    End With
    
    Dim filter As String
    
    With .Add(Nothing, cscCpgId)
      .PropertyType = cspHelp
      .Table = csCondicionPago
      .Name = LNGGetText(1395, vbNullString) 'Condición de pago
      .Key = K_CPG_ID
      .Value = m_CondicionPago
      .HelpId = m_Cpg_id
      .TabIndex = c_tab_ClientesPV
    End With
  
    With .Add(Nothing, cscLpId)
      .PropertyType = cspHelp
      .Table = csListaPrecio
      
      filter = "lp_tipo = 1"
      
      .HelpFilter = filter
      .Name = LNGGetText(1397, vbNullString) 'Lista de precios
      .Key = K_LP_ID
      .Value = m_ListaPrecio
      .HelpId = m_Lp_id
      .TabIndex = c_tab_ClientesPV
    End With
  
    With .Add(Nothing, cscProId)
      .PropertyType = cspHelp
      .Table = csProvincia
      .Name = LNGGetText(1080, vbNullString) 'Provincia
      .Key = K_PRO_ID
      .Value = m_Provincia
      .HelpId = m_pro_id
      .TabIndex = c_tab_ClientesPV
    End With
  
    With .Add(Nothing, cscZonId)
      .PropertyType = cspHelp
      .Table = csZona
      .Name = LNGGetText(1402, vbNullString) 'Zona
      .Key = K_ZON_ID
      .Value = m_Zona
      .HelpId = m_zon_id
      .TabIndex = c_tab_ClientesPV
    End With
  
    '---------------------------------------------------
    '
    ' Hojas de Ruta
    '
    
    With .Add(Nothing, c_DocFacturaFaltante)
      .PropertyType = cspHelp
      .Table = csDocumento
      .HelpFilter = "doct_id = 1"
      .Name = LNGGetText(4937, vbNullString) 'Documento de Factura por Faltante
      .Key = K_DOC_ID_FALTANTE
      .Value = m_DocFaltante
      .HelpId = m_doc_id_faltante
      .TabIndex = c_tab_HojaRuta
      .LeftLabel = -3800
      .Left = 4200
    End With
  
    With .Add(Nothing, c_DocMovimientoSobrante)
      .PropertyType = cspHelp
      .Table = csDocumento
      .HelpFilter = "doct_id = 26"
      .Name = LNGGetText(4938, vbNullString) 'Documento de Movimiento de Fondos Sobrantes
      .Key = K_DOC_ID_SOBRANTE
      .Value = m_DocSobrante
      .HelpId = m_doc_id_sobrante
      .TabIndex = c_tab_HojaRuta
      .LeftLabel = -3800
    End With
  
    With .Add(Nothing, c_DocMovimientoTicket)
      .PropertyType = cspHelp
      .Table = csDocumento
      .HelpFilter = "doct_id = 26"
      .Name = LNGGetText(4939, vbNullString) 'Documento de Movimiento de Fondos Tickets
      .Key = K_DOC_ID_TICKETS
      .Value = m_DocTickets
      .HelpId = m_doc_id_tickets
      .TabIndex = c_tab_HojaRuta
      .LeftLabel = -3800
    End With
      
    With .Add(Nothing, c_PrIdFaltante)
      .PropertyType = cspHelp
      .Table = csProductoVenta
      .Name = LNGGetText(4942, vbNullString) 'Articulo para Faltantes en Rendiciones
      .Key = K_PR_ID_FALTANTES
      .Value = m_ProductoFaltantes
      .HelpId = m_pr_id_faltantes
      .TabIndex = c_tab_HojaRuta
      .LeftLabel = -3800
    End With
    
    With .Add(Nothing, c_CueIdSobrante)
      .PropertyType = cspHelp
      .Table = csCuenta
      .Name = LNGGetText(4943, vbNullString) 'Cuenta para Sobrantes en Rendiciones
      .Key = K_CUE_ID_SOBRANTES
      .Value = m_CuentaSobrantes
      .HelpId = m_cue_id_sobrantes
      .TabIndex = c_tab_HojaRuta
      .LeftLabel = -3800
    End With
  
    With .Add(Nothing, c_CueIdTickets)
      .PropertyType = cspHelp
      .Table = csCuenta
      .Name = LNGGetText(4944, vbNullString) 'Cuenta para Tickets en Rendiciones
      .Key = K_CUE_ID_TICKETS
      .Value = m_CuentaTickets
      .HelpId = m_cue_id_tickets
      .TabIndex = c_tab_HojaRuta
      .LeftLabel = -3800
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function pLoadPercepcion(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  Dim Percepcion   As String
  Dim perc_id      As Long
  
  sqlstmt = "select * from configuracion where emp_id = " & EmpId & _
             " and cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
             " and cfg_aspecto = " & gDB.sqlString(c_Percepcion)
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadPercepcion", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
  
    With .Columns
      
      With .Add(Nothing)
        .Visible = False
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(1252, vbNullString)  'Percepcion
        .PropertyType = cspHelp
        .Table = csPercepcion
        .Width = 2200
        .Key = KI_PERC_ID
      End With
      
    End With
    
    With .Rows
      
      While Not rs.EOF
      
        perc_id = Val(gDB.ValField(rs.Fields, cscCfgValor))
        
        If perc_id <> csNO_ID Then
        
          Percepcion = vbNullString
          
          If Not gDB.GetData(csTPercepcion, _
                             cscPercId, _
                             perc_id, _
                             cscPercNombre, _
                             Percepcion) Then Exit Function
        
          If Percepcion <> vbNullString Then
          
            With .Add(Nothing)
            
              .Add Nothing
              
              With .Add(Nothing)
                .Value = Percepcion
                .ID = perc_id
                .Key = KI_PERC_ID
              End With
              
            End With
          End If
        End If
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadPercepcion = True
End Function

Private Function pSavePercepcion() As Boolean
  Dim register  As cRegister
  
  Set register = New cRegister
  
  With register
    
    .Table = csTConfiguracion
    .Fields.HaveLastUpdate = True
    .Fields.HaveWhoModify = True
    .UtilizaIdentity = True
    
    ' Esto es para que el codigo en cDataBase no
    ' interprete que es un registro nuevo
    .ID = -1
        
    If Not .BeginTrans(gDB) Then Exit Function
    
    Dim sqlstmt As String
    
    sqlstmt = "delete configuracion where emp_id = " & EmpId & _
               " and cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
               " and cfg_aspecto = " & gDB.sqlString(c_Percepcion)
               
    If Not gDB.Execute(sqlstmt) Then Exit Function
          
    Dim Row       As cIABMGridRow
    Dim Cell      As cIABMGridCellValue
    
    For Each Row In pGetPercepcion().Rows
    
      .Fields.Clear
      
      With .Fields
        .Add2 cscCfgGrupo, c_GrupoGeneral, csText
        .Add2 cscCfgAspecto, c_Percepcion, csText
        .Add2 cscCfgValor, pCell(Row, KI_PERC_ID).ID, csText
        .Add2 cscEmpId, EmpId, csText
      End With
      
      If Not gDB.Save(register, True, C_ABMClientSave, C_Module, _
             c_ErrorSave) Then Exit Function
    Next
    
    If Not .CommitTrans() Then Exit Function
  End With

  pSavePercepcion = True
End Function

Private Function pGetPercepcion() As cIABMGrid
  Set pGetPercepcion = m_ObjAbm.Properties.Item(c_Percepcion).Grid
End Function

Private Function pIsEmptyRow(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_PERC_ID
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
      Case KI_PERC_ID
        If ValEmpty(Cell.ID, csId) Then
          MsgInfo LNGGetText(1386, vbNullString)  'Debe indicar una Percepcion (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRow = True
End Function

' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(2301, vbNullString)  'Error al grabar la Configuración General

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
