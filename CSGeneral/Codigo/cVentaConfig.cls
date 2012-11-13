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

'--------------------------------------------------------------------------------
' cVentaConfig
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
Private Const C_Module = "cVentaConfig"

Private Const c_GrupoGeneral = "Ventas-General"
Private Const c_CueIdDescGlobal = "Cuenta Descuento Global"
Private Const c_GrabarAsiento = "Grabar Asiento"
Private Const c_UsarListaPrecioPrecio = "Utilizar Cache de Precios"
Private Const c_ExigirCaja = "Exigir que la Caja Este Abierta para Facturar"
Private Const c_ExigirCentroCosto = "Exigir Centro Costo"

Private Const c_ClientesPV = "ClientesPV"

' estructuras
' variables privadas
Private m_cue_id_descGlobal           As Long
Private m_CuentaDescGlobal            As String
Private m_GrabarAsiento               As Boolean
Private m_UsarListaPrecioPrecio       As Boolean
Private m_ExigirCaja                  As Boolean
Private m_ExigirCentroCosto           As Boolean

Private m_Razonsocial                  As String
Private m_CatFiscal                    As Integer
Private m_CondicionPago                As String
Private m_Cpg_id                       As Long
Private m_lp_id                        As Long
Private m_ListaPrecio                  As String
Private m_Provincia                    As String
Private m_pro_id                       As Long
Private m_zon_id                       As Long
Private m_Zona                         As String

' eventos
' propiedades publicas
Public Property Get CueIdDescGlobal() As Long
  CueIdDescGlobal = m_cue_id_descGlobal
End Property

Public Property Get CuentaDescGlobal() As Long
  CuentaDescGlobal = m_CuentaDescGlobal
End Property

Public Property Get GrabarAsiento() As Long
  GrabarAsiento = m_GrabarAsiento
End Property

Public Property Get UsarListaPrecioPrecio() As Boolean
  UsarListaPrecioPrecio = m_UsarListaPrecioPrecio
End Property

Public Property Get ExigirCaja() As Boolean
  ExigirCaja = m_ExigirCaja
End Property

Public Property Get ExigirCentroCosto() As Boolean
  ExigirCentroCosto = m_ExigirCentroCosto
End Property

'---------------------------------------------------------
Public Property Get LpIdClientePV() As Long
  LpIdClientePV = m_lp_id
End Property

Public Property Get ListaPrecioClientePV() As String
  ListaPrecioClientePV = m_ListaPrecio
End Property

Public Property Get CpgIdClientePV() As Long
  CpgIdClientePV = m_Cpg_id
End Property

Public Property Get CondicionPagoClientePV() As String
  CondicionPagoClientePV = m_CondicionPago
End Property

Public Property Get RazonSocialClientePV() As String
  RazonSocialClientePV = m_Razonsocial
End Property

Public Property Get CatFiscalClientePV() As String
  CatFiscalClientePV = m_CatFiscal
End Property

Public Property Get ProIdClientePV() As Long
  ProIdClientePV = m_pro_id
End Property

Public Property Get ProvinciaClientePV() As String
  ProvinciaClientePV = m_Provincia
End Property

Public Property Get ZonIdClientePV() As Long
  ZonIdClientePV = m_zon_id
End Property

Public Property Get ZonaClientePV() As String
  ZonaClientePV = m_Zona
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Load() As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset

  sqlstmt = "select * from configuracion where emp_id is null and cfg_grupo = " & _
                 gDB.sqlString(c_GrupoGeneral)

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  m_cue_id_descGlobal = csNO_ID
  m_CuentaDescGlobal = vbNullString
  m_GrabarAsiento = False
  m_UsarListaPrecioPrecio = False
  m_ExigirCaja = False
  m_ExigirCentroCosto = False
  
  While Not rs.EOF
    Select Case gDB.ValField(rs.fields, cscCfgAspecto)
      Case c_CueIdDescGlobal
        m_cue_id_descGlobal = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTCuenta, cscCueId, m_cue_id_descGlobal, cscCueNombre, m_CuentaDescGlobal) Then Exit Function
      Case c_GrabarAsiento
        m_GrabarAsiento = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case c_UsarListaPrecioPrecio
        m_UsarListaPrecioPrecio = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case c_ExigirCaja
        m_ExigirCaja = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case c_ExigirCentroCosto
        m_ExigirCentroCosto = Val(gDB.ValField(rs.fields, cscCfgValor))
    
      Case c_ClientesPV & cscCliRazonsocial
        m_Razonsocial = gDB.ValField(rs.fields, cscCfgValor)
        
      Case c_ClientesPV & cscCliCatfiscal
        m_CatFiscal = Val(gDB.ValField(rs.fields, cscCfgValor))
        
      Case c_ClientesPV & cscCpgId
        m_Cpg_id = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTCondicionPago, cscCpgId, m_Cpg_id, cscCpgNombre, m_CondicionPago) Then Exit Function
        
      Case c_ClientesPV & cscLpId
        m_lp_id = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTListaPrecio, cscLpId, m_lp_id, cscLpNombre, m_ListaPrecio) Then Exit Function
    
      Case c_ClientesPV & cscProId
        m_pro_id = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTProvincia, cscProId, m_pro_id, cscProNombre, m_Provincia) Then Exit Function
        
      Case c_ClientesPV & cscZonId
        m_zon_id = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTZona, cscZonId, m_zon_id, cscZonNombre, m_Zona) Then Exit Function
        
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
