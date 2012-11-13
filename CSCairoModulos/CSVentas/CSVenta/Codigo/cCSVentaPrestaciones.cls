VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSVentaPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSVentasPrestaciones
' 09-05-2003

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

Public Enum csVentasPrestacion
  csPreVtaNewFactura = 16002
  csPreVtaEditFactura = 16003
  csPreVtaDeleteFactura = 16004
  csPreVtaListFactura = 16005
  csPreVtaDesAnularFactura = 16010
  csPreVtaAnularFactura = 16011
  
  csPreVtaNewRemito = 16006
  csPreVtaEditRemito = 16007
  csPreVtaDeleteRemito = 16008
  csPreVtaListRemito = 16009
  csPreVtaDesAnularRemito = 16012
  csPreVtaAnularRemito = 16013
  
  csPreVtaModifyAplic = 16014
  
  csPreVtaEditPriceRem = 16015
  csPreVtaEditPriceFac = 16016
  csPreVtaEditPricePresu = 16023

  csPreVtaNewPresupuesto = 16017
  csPreVtaEditPresupuesto = 16018
  csPreVtaDeletePresupuesto = 16019
  csPreVtaListPresupuesto = 16020
  csPreVtaDesAnularPresupuesto = 16021
  csPreVtaAnularPresupuesto = 16022
  
  csPreVtaCobranzaContado = 16024
  
  csPreVtaNewHojaRuta = 16025
  csPreVtaEditHojaRuta = 16026
  csPreVtaDeleteHojaRuta = 16027
  csPreVtaListHojaRuta = 16028
  
  csPreVtaNewCaja = 16029
  csPreVtaEditCaja = 16030
  csPreVtaDeleteCaja = 16031
  csPreVtaListCaja = 16032
  csPreVtaAceptarCierre = 16033
  csPreVtaAbrirCaja = 16034
  
  csPreVtaNewPickingList = 16035
  csPreVtaEditPickingList = 16036
  csPreVtaDeletePickingList = 16037
  csPreVtaListPickingList = 16038
  
  csPreVtaModificarArticulo = 16039
  
  csPreVtaCobranzasCajero = 16040
End Enum

Public Enum csMenuEnum
  csMenuVentas = 3998
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
  SecurityAdd csPreVtaNewFactura, "Agregar Factura de ventas", "Ventas"
  SecurityAdd csPreVtaDeleteFactura, "Borrar Factura de ventas", "Ventas"
  SecurityAdd csPreVtaEditFactura, "Editar Factura de ventas", "Ventas"
  SecurityAdd csPreVtaListFactura, "Listar Factura de ventas", "Ventas"
  SecurityAdd csPreVtaAnularFactura, "Anular Factura de ventas", "Ventas"
  SecurityAdd csPreVtaDesAnularFactura, "Des-anular Factura de ventas", "Ventas"
  
  SecurityAdd csPreVtaNewRemito, "Agregar Remito de ventas", "Ventas"
  SecurityAdd csPreVtaDeleteRemito, "Borrar Remito de ventas", "Ventas"
  SecurityAdd csPreVtaEditRemito, "Editar Remito de ventas", "Ventas"
  SecurityAdd csPreVtaListRemito, "Listar Remito de ventas", "Ventas"
  SecurityAdd csPreVtaAnularRemito, "Anular Remito de ventas", "Ventas"
  SecurityAdd csPreVtaDesAnularRemito, "Des-anular Remito de ventas", "Ventas"
  
  SecurityAdd csPreVtaModifyAplic, "Modificar aplicacion de ventas", "Ventas"
  
  SecurityAdd csPreVtaEditPriceRem, "Editar Precios en Remito de Venta", "Ventas"
  SecurityAdd csPreVtaEditPriceFac, "Editar Precios en Factura de Venta", "Ventas"
  SecurityAdd csPreVtaEditPricePresu, "Editar Precios en Presupuesto de Venta", "Ventas"

  SecurityAdd csPreVtaNewPresupuesto, "Agregar Presupuesto de ventas", "Ventas"
  SecurityAdd csPreVtaDeletePresupuesto, "Borrar Presupuesto de ventas", "Ventas"
  SecurityAdd csPreVtaEditPresupuesto, "Editar Presupuesto de ventas", "Ventas"
  SecurityAdd csPreVtaListPresupuesto, "Listar Presupuesto de ventas", "Ventas"
  SecurityAdd csPreVtaAnularPresupuesto, "Anular Presupuesto de ventas", "Ventas"
  SecurityAdd csPreVtaDesAnularPresupuesto, "Des-anular Presupuesto de ventas", "Ventas"
  
  SecurityAdd csPreVtaCobranzaContado, "Cobranza Contado", "Ventas"
  
  SecurityAdd csPreVtaNewHojaRuta, "Agregar Hoja de Ruta", "Ventas"
  SecurityAdd csPreVtaDeleteHojaRuta, "Borrar Hoja de Ruta", "Ventas"
  SecurityAdd csPreVtaEditHojaRuta, "Editar Hoja de Ruta", "Ventas"
  SecurityAdd csPreVtaListHojaRuta, "Listar Hoja de Ruta", "Ventas"
  
  SecurityAdd csPreVtaNewCaja, "Agregar Apertura/Cierre de Caja", "Ventas"
  SecurityAdd csPreVtaDeleteCaja, "Borrar Apertura/Cierre de Caja", "Ventas"
  SecurityAdd csPreVtaEditCaja, "Editar Apertura/Cierre de Caja", "Ventas"
  SecurityAdd csPreVtaListCaja, "Listar Apertura/Cierre de Caja", "Ventas"
  SecurityAdd csPreVtaAceptarCierre, "Aceptar Cierre de Caja", "Ventas"
  
  SecurityAdd csPreVtaAbrirCaja, "Abrir Caja", "Ventas"
  
  SecurityAdd csPreVtaNewPickingList, "Agregar Lista de Despacho", "Ventas"
  SecurityAdd csPreVtaDeletePickingList, "Borrar Lista de Despacho", "Ventas"
  SecurityAdd csPreVtaEditPickingList, "Editar Lista de Despacho", "Ventas"
  SecurityAdd csPreVtaListPickingList, "Listar Lista de Despacho", "Ventas"
  
  SecurityAdd csPreVtaModificarArticulo, "Modificar Articulos en Pedidos de Venta desde Picking List", "Ventas"
  
  SecurityAdd csPreVtaCobranzasCajero, "Cobranzas por Mostrador", "Ventas"
  
End Sub

' funciones privadas
' construccion - destruccion
