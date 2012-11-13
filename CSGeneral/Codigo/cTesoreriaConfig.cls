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

'--------------------------------------------------------------------------------
' cTesoreriaConfig
' 16-10-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cTesoreriaConfig"

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

Public Enum csEModoDifCambio
  csEDifCambioCuenta = 1
  csEDifCambioNCND = 2
End Enum

Public Enum csEModoIvaDifCambio
  csEDifIvaImponible = 1
  csEDifIvaNoImponible = 2
End Enum

Public Enum csEAplicacionDifCambio
  csEDifAplicacionND = 1
  csEDifAplicacionFV = 2
End Enum

' estructuras
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
Private m_CueAnticipoCobz             As String
Private m_CueAnticipoOpg              As String

Private m_cue_id_ant_cobz             As Long
Private m_cue_id_ant_opg              As Long

Private m_GrabarAsientoCobranza               As Boolean
Private m_GrabarAsientoDepositoBanco          As Boolean
Private m_GrabarAsientoOrdenPago              As Boolean
Private m_GrabarAsientoMovimientoFondo        As Boolean
Private m_GrabarAsientoDepositoCupon          As Boolean
Private m_GrabarAsientoResolucionCupon        As Boolean
Private m_GrabarAsientoAgrupado               As Boolean

Private m_CalcularRetenciones         As Boolean

Private m_ExigirCentroCosto           As Boolean
Private m_CobranzasXHojaRuta          As Boolean

Private m_ret_id                      As Long
Private m_Retencion                   As String
' eventos
' propiedades publicas
Public Property Get CueIdDifCambio() As Long
  CueIdDifCambio = m_cue_id_difCambio
End Property

Public Property Get CuentaDifCambio() As String
  CuentaDifCambio = m_CuentaDifCambio
End Property

Public Property Get CueAnticipoCobz() As String
  CueAnticipoCobz = m_CueAnticipoCobz
End Property

Public Property Get cue_id_ant_cobz() As Long
  cue_id_ant_cobz = m_cue_id_ant_cobz
End Property

Public Property Get CueAnticipoOpg() As String
  CueAnticipoOpg = m_CueAnticipoOpg
End Property

Public Property Get cue_id_ant_opg() As Long
  cue_id_ant_opg = m_cue_id_ant_opg
End Property

Public Property Get DocIdNCDifCambio() As Long
  DocIdNCDifCambio = m_doc_id_NCdifCambio
End Property

Public Property Get DocNCDifCambio() As String
  DocNCDifCambio = m_DocNCDifCambio
End Property

Public Property Get DocIdNDDifCambio() As Long
  DocIdNDDifCambio = m_doc_id_NDdifCambio
End Property

Public Property Get DocNDDifCambio() As String
  DocNDDifCambio = m_DocNDDifCambio
End Property

Public Property Get PrIdDifCambio() As Long
  PrIdDifCambio = m_pr_id_difCambio
End Property

Public Property Get ProductoDifCambio() As String
  ProductoDifCambio = m_ProductoDifCambio
End Property

Public Property Get DefaultDifCambio() As csEModoDifCambio
  DefaultDifCambio = m_DefaultDifCambio
End Property

Public Property Get ModoIvaDifCambio() As csEModoIvaDifCambio
  ModoIvaDifCambio = m_ModoIvaDifCambio
End Property

Public Property Get AplicacionDifCambio() As csEAplicacionDifCambio
  AplicacionDifCambio = m_AplicacionDifCambio
End Property

Public Property Get DocIdCobranza() As Long
  DocIdCobranza = m_doc_id_Cobranza
End Property

Public Property Get DocCobranza() As String
  DocCobranza = m_DocCobranza
End Property

Public Property Get DocIdOrdenPago() As Long
  DocIdOrdenPago = m_doc_id_OrdenPago
End Property

Public Property Get DocOrdenPago() As String
  DocOrdenPago = m_DocOrdenPago
End Property

Public Property Get GrabarAsientoCobranza() As Long
  GrabarAsientoCobranza = m_GrabarAsientoCobranza
End Property

Public Property Get GrabarAsientoDepositoBanco() As Long
  GrabarAsientoDepositoBanco = m_GrabarAsientoDepositoBanco
End Property

Public Property Get GrabarAsientoOrdenPago() As Long
  GrabarAsientoOrdenPago = m_GrabarAsientoOrdenPago
End Property

Public Property Get GrabarAsientoMovimientoFondo() As Long
  GrabarAsientoMovimientoFondo = m_GrabarAsientoMovimientoFondo
End Property

Public Property Get ExigirCentroCosto() As Boolean
  ExigirCentroCosto = m_ExigirCentroCosto
End Property

Public Property Get CobranzasXHojaRuta() As Boolean
  CobranzasXHojaRuta = m_CobranzasXHojaRuta
End Property

' Para no romper la compatibilidad binaria
'
Public Property Get GrabarAsientoRendicion() As Long
End Property

Public Property Get GrabarAsientoResolucionCupon() As Long
  GrabarAsientoResolucionCupon = m_GrabarAsientoResolucionCupon
End Property

Public Property Get GrabarAsientoDepositoCupon() As Long
  GrabarAsientoDepositoCupon = m_GrabarAsientoDepositoCupon
End Property

Public Property Get GrabarAsientoAgrupado() As Long
  GrabarAsientoAgrupado = m_GrabarAsientoAgrupado
End Property

Public Property Get CalcularRetenciones() As Boolean
  CalcularRetenciones = m_CalcularRetenciones
End Property

Public Property Get ret_id() As Long
  ret_id = m_ret_id
End Property

Public Property Get Retencion() As String
  Retencion = m_Retencion
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Load() As Boolean
  Dim sqlstmt As String
  Dim rs As Recordset

  sqlstmt = "select * from configuracion where emp_id is null and cfg_grupo = " & gDB.sqlString(c_GrupoGeneral)

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  m_cue_id_difCambio = csNO_ID
  m_CuentaDifCambio = vbNullString
  
  m_doc_id_NCdifCambio = csNO_ID
  m_DocNCDifCambio = vbNullString
  
  m_doc_id_NDdifCambio = csNO_ID
  m_DocNDDifCambio = vbNullString
  
  m_pr_id_difCambio = csNO_ID
  m_ProductoDifCambio = vbNullString
  
  m_DefaultDifCambio = csEDifCambioNCND
  m_ModoIvaDifCambio = csEDifIvaImponible
  m_AplicacionDifCambio = csEDifAplicacionND
  
  m_cue_id_ant_cobz = csNO_ID
  m_CueAnticipoCobz = vbNullString
  
  m_cue_id_ant_opg = csNO_ID
  m_CueAnticipoOpg = vbNullString
  
  m_GrabarAsientoDepositoBanco = False
  m_GrabarAsientoCobranza = False
  m_GrabarAsientoOrdenPago = False
  m_GrabarAsientoMovimientoFondo = False
  m_GrabarAsientoDepositoCupon = False
  m_GrabarAsientoResolucionCupon = False
  m_GrabarAsientoAgrupado = False
  
  m_CalcularRetenciones = False
  m_ret_id = csNO_ID
  m_Retencion = vbNullString
  
  m_ExigirCentroCosto = False
  m_CobranzasXHojaRuta = False
  
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
      Case c_GrabarAsientoResolucionCupon
        m_GrabarAsientoResolucionCupon = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case c_GrabarAsientoDepositoCupon
        m_GrabarAsientoDepositoCupon = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case c_GrabarAsientoAgrupado
        m_GrabarAsientoAgrupado = Val(gDB.ValField(rs.fields, cscCfgValor))
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
      Case c_Retencion
        m_ret_id = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTRetencion, cscRetId, m_ret_id, cscRetNombre, m_Retencion) Then Exit Function
      
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
' funciones friend
' funciones privadas
' construccion - destruccion

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
