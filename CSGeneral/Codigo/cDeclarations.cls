VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDeclarations"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cDeclarations
' 11-02-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Public Enum csETablasGeneral
  csRubro = 5
  csProvincia = 6
  csUnidad = 7
  csZona = 8
  csTasaImpositiva = 9
  csDepositoFisico = 10
  csDepositoLogico = 11
  csMoneda = 12
  csBanco = 13
  csSucursalCliente = 14
  csVendedores = 15
  csTarjetaCredito = 16
  csCuenta = 17
  csCuentaGrupo = 18
  csCuentaCategoria = 19
  csLeyenda = 20
  csCentroCosto = 21
  csChequera = 22
  csClearing = 23
  csReglaLiquidacion = 24
  csCobrador = 25
  csIngresosBrutosCategoria = 26
  csListaPrecio = 27
  csCliente = 28
  csProveedor = 29
  csProducto = 30
  csProductoVenta = 31
  csProductoCompra = 32
  csEscala = 33
  csTransporte = 34
  csPais = 39
  csCiudad = 40
  csProductoStock = 44
  csChofer = 1001
  csMarca = 1002
  csCalidad = 1003
  csCamion = 1004
  csCondicionPago = 1005
  csListaDescuento = 1006
  csSucursal = 1007
  csRubroTabla = 1008
  csRubroTablaItem = 1009
  csGasto = 1010
  csPercepcionTipo = 1011
  csPercepcion = 1012
  csRetencionTipo = 1013
  csRetencion = 1014
  csDepartamento = 1015
  csCircuitoContable = 1016
  csProductoSerie = 1017
  csEmpresa = 1018
  csPersona = 1019
  csIdioma = 1020
  csTipoOperacion = 1021
  csTarjetaCreditoCuota = 1022
  csEmbalaje = 1023
  csTblCatFiscal = 1024
  csTipoDocumento = 1025
  csStockLote = 1026
  csProductoFormulaKit = 1027
  csEncuesta = 1029
  csFeriado = 1030
  csCategoriaFiscal = 1031
  csCamionSemi = 1032
  csCaja = 1033
  csListaPrecioMarcado = 1034
  csCatalogoWeb = 1035
  csAjusteInflacion = 1036
  csAjusteInflacionItemTipo = 1037
  csProductoHelpConfig = 1038
  csCalle = 1039
  csCatalogoWebCategoria = 1040
  csClienteContactoTipo = 1041
  csPersonaDocumentoTipo = 1042
  csCodigoPostal = 1043
  csPosicionArancel = 1044
  csTarifario = 1045
  csFormaPago = 1046
  csVentaModo = 1047
End Enum

' Categorias Fiscal
Public Enum csCatFiscal
  csCatFInscripto = 1
  csCatFExento = 2
  csCatFNoInscripto = 3
  csCatFConsumidorFinal = 4
  csCatFExtranjero = 5
  csCatFMonoTributo = 6
  csCatFExtranjeroIva = 7
  csCatFNoResponsable = 8
  csCatFNoResponsableExento = 9
  csCatFNoCategorizado = 10
  csCatFInscriptoM = 11
End Enum

Public Enum csClaveFiscalType
  csEClaveFiscalCuit = 1
  csEClaveFiscalRut = 2
End Enum

' Tipos de listas de precio y descuento
Public Enum csEListaPrecioTipo
  csELPT_Venta = 1
  csELPT_Compra = 2
  csELPT_Costo = 3
End Enum

Public Enum csEListaDescuentoTipo
  csELDT_Venta = 1
  csELDT_Compra = 2
End Enum

Public Enum csECpgTipo
  csECpgT_FechaDocumento = -2
  csEcpgT_General = 1
  csEcpgT_DebitoAuto = 2
  csEcpgT_FondoFijo = 3
End Enum

Public Enum csE_GastoTipo
  csEGtoTAereo = 1
  csEGtoTMaritimo = 2
  csEGtoTGeneral = 3
End Enum

Public Enum csE_DepositosInternos
  csEDeplIdInterno = -2
  csEDeplIdTercero = -3
End Enum

Public Enum csEEstado
  csEEst_Pendiente = 1
  csEEst_PendienteDespacho = 2
  csEEst_PendienteCredito = 3
  csEEst_PendienteFirma = 4
  csEEst_Finalizado = 5
  csEEst_Rechazado = 6
  csEEst_Anulado = 7
  csEEst_PendienteStock = 8
  csEEst_Vencido = 9
End Enum

Public Enum csESearchType
  csESearchInString = 1
  csESearchBeginWith = 2
  csESearchEqual = 3
End Enum

Public Enum csE_PercepcionBase
  csEPB_Neto = 1
  csEPB_NetoGravado = 2
  csEPB_Total = 3
End Enum

Public Enum csE_RetencionBase
  csERB_Neto = 1
  csERB_NetoGravado = 2
  csERB_Total = 3
End Enum

Public Enum csE_RetencionTipoAcumulado
  csERAC_NoAcumula = 1
  csERAC_Mensual = 2
End Enum

Public Enum csE_RetencionTipoMinimo
  csERM_NoImponible = 1
  csERM_Imponible = 2
End Enum

Public Enum csE_DepartamentoTipo
  csEDPTOT_Generico = 1
  csEDPTOT_Administracion = 2
  csEDPTOT_Laboratorio = 3
  csEDPTOT_CallCenter = 4
  csEDPTOT_Deposito = 5
  csEDPTOT_Ventas = 6
  csEDPTOT_Compras = 7
  csEDPTOT_Legales = 8
  csEDPTOT_Gerencia = 9
  csEDPTOT_RecursosHumanos = 10
  csEDPTOT_Marketing = 11
  csEDPTOT_Sistemas = 12
  
  csEDPTOT_Todos = 0
End Enum

Public Enum csE_CuentaGrupoTipo
  csECuecTipoProductoVenta = 1
  csECuecTipoProductoCompra = 2
  csECuecTipoAcreedor = 3
  csECuecTipoDeudor = 4
  csECuecTipoDebitoAutomatico = 5
  csECuecTipoFondoFijo = 6
End Enum

Public Enum csE_ProductoWebImageType
  csE_PrWebImageThumbnail = 1
  csE_PrWebImageMedium = 2
  csE_PrWebImageBig = 3
End Enum

Public Enum csE_Sexo
  csSexoSinDefinir = 0
  csSexoFemenino = 1
  csSexoMasculino = 2
End Enum

Public Enum csE_HojaRutaCobranzaTipo
  csHRCT_AnuladaInterna = 1       'ai   Anulada Interna
  csHRCT_Anulada = 2              'a    Anulada
  csHRCT_PagoParcial = 3          'p    Pago Parcial
  csHRCT_CuentaCorriente = 4      'c    Cuenta Corriente
  csHRCT_Cheque = 5               'h    Cheque
  csHRCT_AnuladaParcial = 6       'ap   Anulada Parcial
  csHRCT_PendienteReparto = 7     'r    Pendiente a Repartir
  csHRCT_Efectivo = 8             'e    Efectivo
  csHRCT_Tickets = 9              'i    Tickets
  csHRCT_Tarjeta = 10             't    Tarjeta
End Enum

Public Enum csE_VentaModoCtaCte
  csVM_CtaCteHojaRuta = 1
  csVM_CtaCteMostrador = 2
  csVM_CtaCteMostradoFactura = 3
End Enum

' Grupos de Categorias de cuentas
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
' funciones privadas
' construccion - destruccion
