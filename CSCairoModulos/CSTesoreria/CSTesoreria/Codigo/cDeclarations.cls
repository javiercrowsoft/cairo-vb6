VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDeclarations"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cDeclarations
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
Public Enum csETablesTesoreria
  csCheque = 18001  ' Lista solo cheques en cartera
  csCheque2 = 18003 ' Lista todos los cheques
  csCheque3 = 18010 ' Lista todos los cheques entregados a tercero o depositados
  
  csTarjetaCreditoCupon = 18002
  csCashFlow = 18004
  
  csCobranza = 18004
  csOrdenPago = 18005
  csMovimientoFondo = 18006
  csDepositoBanco = 18007
  csDepositoCupon = 18008
  csResolucionCupon = 18009
  
  csBancoConciliacion = 18011
End Enum

Public Enum csECobranzaItemTipo
  csECobziTCheques = 1
  csECobziTEfectivo = 2
  csECobziTTarjeta = 3
  csECobziTOtros = 4
  csECobziTCtaCte = 5
End Enum

Public Enum csEItemOtroTipo
  csEOtroDebe = 1
  csEOtroHaber = 2
End Enum

Public Enum csECuponTipo
  csECuponPosnet = 1
  csECuponManual = 2
End Enum

Public Enum csEChequeTipo
  csECheqPropio = 1
  csECheqTercero = 2
End Enum

Public Enum csEOrdenPagoItemTipo
  csEOpgiTCheques = 1
  csEOpgiTEfectivo = 2
  csEOpgiTOtros = 4
  csEOpgiTCtaCte = 5
  csEOpgiTChequesT = 6
End Enum

Public Enum csEMovimientoFondoItemTipo
  csEMfiTCheques = 1
  csEMfiTEfectivo = 2
  csEMfiTChequesT = 6
  csEMfiTChequesI = 7
End Enum

Public Enum csEDepositoBancoItemTipo
  csDbcoiTCheques = 1
  csDbcoiTEfectivo = 2
  csDbcoiTChequesT = 6
End Enum

Public Enum csEBcoConciliacionTipo
  csEBCPendiente = 1
  csEBCConciliado = 2
  csEBCRechazado = 3
End Enum

' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
' funciones privadas
' construccion - destruccion



