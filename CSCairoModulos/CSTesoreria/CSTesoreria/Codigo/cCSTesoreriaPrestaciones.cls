VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSTesoreriaPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSTesoreriaPrestaciones
' 31-01-04

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
' estructuras
' enumeraciones

Public Enum csTesoreriaPrestacion

  csPreTsrNewCobranza = 18007
  csPreTsrEditCobranza = 18008
  csPreTsrDeleteCobranza = 18009
  csPreTsrListCobranza = 18010
  csPreTsrDesAnularCobranza = 18011
  csPreTsrAnularCobranza = 18012
  
  csPreTsrModifyAplic = 18013
  
  csPreTsrNewOrdenPago = 18014
  csPreTsrEditOrdenPago = 18015
  csPreTsrDeleteOrdenPago = 18016
  csPreTsrListOrdenPago = 18017
  csPreTsrDesAnularOrdenPago = 18018
  csPreTsrAnularOrdenPago = 18019

  csPreTsrNewMovimientoFondo = 18020
  csPreTsrEditMovimientoFondo = 18021
  csPreTsrDeleteMovimientoFondo = 18022
  csPreTsrListMovimientoFondo = 18023
  csPreTsrDesAnularMovimientoFondo = 18024
  csPreTsrAnularMovimientoFondo = 18025

  csPreTsrNewDepositoBanco = 18032
  csPreTsrEditDepositoBanco = 18033
  csPreTsrDeleteDepositoBanco = 18034
  csPreTsrListDepositoBanco = 18035
  csPreTsrDesAnularDepositoBanco = 18036
  csPreTsrAnularDepositoBanco = 18037

  csPreTsrNewDepositoCupon = 18038
  csPreTsrEditDepositoCupon = 18039
  csPreTsrDeleteDepositoCupon = 18040
  csPreTsrListDepositoCupon = 18041
  csPreTsrDesAnularDepositoCupon = 18042
  csPreTsrAnularDepositoCupon = 18043

  csPreTsrNewResolucionCupon = 18044
  csPreTsrEditResolucionCupon = 18045
  csPreTsrDeleteResolucionCupon = 18046
  csPreTsrListResolucionCupon = 18047
  csPreTsrDesAnularResolucionCupon = 18048
  csPreTsrAnularResolucionCupon = 18049
  
  csPreTsrEditRechazoCheque = 18050
  
  csPreTsrEditConciliacionBco = 18051
  csPreTsrListConciliacionBco = 18053
  csPreTsrDeleteConciliacionBco = 18054
  csPreTsrNewConciliacionBco = 18055
  
  csPreTsrEditCashFlow = 18052
  
End Enum

Public Enum csMenuEnum
  csMenuTesoreria = 18999
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()

  SecurityAdd csPreTsrNewCobranza, "Agregar Cobranza", "Tesoreria"
  SecurityAdd csPreTsrDeleteCobranza, "Borrar Cobranza", "Tesoreria"
  SecurityAdd csPreTsrEditCobranza, "Editar Cobranza", "Tesoreria"
  SecurityAdd csPreTsrListCobranza, "Listar Cobranza", "Tesoreria"
  SecurityAdd csPreTsrDesAnularCobranza, "Des anular Cobranza", "Tesoreria"
  SecurityAdd csPreTsrAnularCobranza, "Anular Cobranza", "Tesoreria"

  SecurityAdd csPreTsrModifyAplic, "Modificar Aplicaciones", "Tesoreria"

  SecurityAdd csPreTsrNewOrdenPago, "Agregar Orden de Pago", "Tesoreria"
  SecurityAdd csPreTsrDeleteOrdenPago, "Borrar Orden de Pago", "Tesoreria"
  SecurityAdd csPreTsrEditOrdenPago, "Editar Orden de Pago", "Tesoreria"
  SecurityAdd csPreTsrListOrdenPago, "Listar Orden de Pago", "Tesoreria"
  SecurityAdd csPreTsrDesAnularOrdenPago, "Des anular Orden de Pago", "Tesoreria"
  SecurityAdd csPreTsrAnularOrdenPago, "Anular Orden de Pago", "Tesoreria"

  SecurityAdd csPreTsrNewMovimientoFondo, "Agregar Movimiento de Fondo", "Tesoreria"
  SecurityAdd csPreTsrDeleteMovimientoFondo, "Borrar Movimiento de Fondo", "Tesoreria"
  SecurityAdd csPreTsrEditMovimientoFondo, "Editar Movimiento de Fondo", "Tesoreria"
  SecurityAdd csPreTsrListMovimientoFondo, "Listar Movimiento de Fondo", "Tesoreria"
  SecurityAdd csPreTsrDesAnularMovimientoFondo, "Des anular Movimiento de Fondo", "Tesoreria"
  SecurityAdd csPreTsrAnularMovimientoFondo, "Anular Movimiento de Fondo", "Tesoreria"

  SecurityAdd csPreTsrNewDepositoBanco, "Agregar Deposito Bancario", "Tesoreria"
  SecurityAdd csPreTsrDeleteDepositoBanco, "Borrar Deposito Bancario", "Tesoreria"
  SecurityAdd csPreTsrEditDepositoBanco, "Editar Deposito Bancario", "Tesoreria"
  SecurityAdd csPreTsrListDepositoBanco, "Listar Deposito Bancario", "Tesoreria"
  SecurityAdd csPreTsrDesAnularDepositoBanco, "Des anular Deposito Bancario", "Tesoreria"
  SecurityAdd csPreTsrAnularDepositoBanco, "Anular Deposito Bancario", "Tesoreria"

  SecurityAdd csPreTsrNewDepositoCupon, "Agregar Presentación de Cupones", "Tesoreria"
  SecurityAdd csPreTsrDeleteDepositoCupon, "Borrar Presentación de Cupones", "Tesoreria"
  SecurityAdd csPreTsrEditDepositoCupon, "Editar Presentación de Cupones", "Tesoreria"
  SecurityAdd csPreTsrListDepositoCupon, "Listar Presentación de Cupones", "Tesoreria"
  SecurityAdd csPreTsrDesAnularDepositoCupon, "Des anular Presentación de Cupones", "Tesoreria"
  SecurityAdd csPreTsrAnularDepositoCupon, "Anular Presentación de Cupones", "Tesoreria"

  SecurityAdd csPreTsrNewResolucionCupon, "Agregar Resolución de Cupones", "Tesoreria"
  SecurityAdd csPreTsrDeleteResolucionCupon, "Borrar Resolución de Cupones", "Tesoreria"
  SecurityAdd csPreTsrEditResolucionCupon, "Editar Resolución de Cupones", "Tesoreria"
  SecurityAdd csPreTsrListResolucionCupon, "Listar Resolución de Cupones", "Tesoreria"
  SecurityAdd csPreTsrDesAnularResolucionCupon, "Des anular Resolución de Cupones", "Tesoreria"
  SecurityAdd csPreTsrAnularResolucionCupon, "Anular Resolución de Cupones", "Tesoreria"
  
  SecurityAdd csPreTsrEditRechazoCheque, "Editar Rechazo de Cheques", "Tesoreria"
  
  SecurityAdd csPreTsrEditConciliacionBco, "Editar Conciliación Bancaria", "Tesoreria"
  SecurityAdd csPreTsrListConciliacionBco, "Listar Conciliación Bancaria", "Tesoreria"
  SecurityAdd csPreTsrDeleteConciliacionBco, "Borrar Conciliación Bancaria", "Tesoreria"
  SecurityAdd csPreTsrNewConciliacionBco, "Agregar Conciliación Bancaria", "Tesoreria"
        
  SecurityAdd csPreTsrEditCashFlow, "Editar Flujo de Fondos", "Tesoreria"
End Sub

' funciones privadas
' construccion - destruccion
