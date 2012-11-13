VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSCompraPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSCompraPrestaciones
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

Public Enum csComprasPrestacion
  
  csPreCpraNewFactura = 17002
  csPreCpraEditFactura = 17003
  csPreCpraDeleteFactura = 17004
  csPreCpraListFactura = 17005
  csPreCpraDesAnularFactura = 17010
  csPreCpraAnularFactura = 17011

  csPreCpraNewRemito = 17006
  csPreCpraEditRemito = 17007
  csPreCpraDeleteRemito = 17008
  csPreCpraListRemito = 17009
  csPreCpraDesAnularRemito = 17012
  csPreCpraAnularRemito = 17013
  
  csPreCpraNewPedido = 17014
  csPreCpraEditPedido = 17015
  csPreCpraDeletePedido = 17016
  csPreCpraListPedido = 17017
  csPreCpraDesAnularPedido = 17018
  csPreCpraAnularPedido = 17019
  
  csPreCpraModifyAplic = 17020

  csPreCpraNewOrden = 17021
  csPreCpraEditOrden = 17022
  csPreCpraDeleteOrden = 17023
  csPreCpraListOrden = 17024
  csPreCpraDesAnularOrden = 17025
  csPreCpraAnularOrden = 17026

  csPreCpraNewCotizacion = 17027
  csPreCpraEditCotizacion = 17028
  csPreCpraDeleteCotizacion = 17029
  csPreCpraListCotizacion = 17030
  csPreCpraDesAnularCotizacion = 17031
  csPreCpraAnularCotizacion = 17032

  csPreCpraNewPresupuesto = 17033
  csPreCpraEditPresupuesto = 17034
  csPreCpraDeletePresupuesto = 17035
  csPreCpraListPresupuesto = 17036
  csPreCpraDesAnularPresupuesto = 17037
  csPreCpraAnularPresupuesto = 17038

  csPreCpraEditPricePed = 17041
  csPreCpraEditPriceOrd = 17042
  csPreCpraEditPriceRem = 17039
  csPreCpraEditPriceFac = 17040
  
  csPreCpraNewDespImpoCalc = 17043
  csPreCpraEditDespImpoCalc = 17044
  csPreCpraDeleteDespImpoCalc = 17045
  csPreCpraListDespImpoCalc = 17046

End Enum

Public Enum csMenuEnum
 csMenuCompras = 17002
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
  SecurityAdd csPreCpraNewFactura, "Agregar Factura de Compras", "Compras"
  SecurityAdd csPreCpraDeleteFactura, "Borrar Factura de Compras", "Compras"
  SecurityAdd csPreCpraEditFactura, "Editar Factura de Compras", "Compras"
  SecurityAdd csPreCpraListFactura, "Listar Factura de Compras", "Compras"
  SecurityAdd csPreCpraDesAnularFactura, "Des-anular Factura de Compras", "Compras"
  SecurityAdd csPreCpraAnularFactura, "Anular Factura de Compras", "Compras"

  SecurityAdd csPreCpraNewRemito, "Agregar Remito de Compra", "Compras"
  SecurityAdd csPreCpraDeleteRemito, "Borrar Remito de Compra", "Compras"
  SecurityAdd csPreCpraEditRemito, "Editar Remito de Compra", "Compras"
  SecurityAdd csPreCpraListRemito, "Listar Remito de Compra", "Compras"
  SecurityAdd csPreCpraDesAnularRemito, "Des-anular Remito de Compra", "Compras"
  SecurityAdd csPreCpraAnularRemito, "Anular Remito de Compra", "Compras"

  SecurityAdd csPreCpraNewPedido, "Agregar Pedido de Compra", "Compras"
  SecurityAdd csPreCpraDeletePedido, "Borrar Pedido de Compra", "Compras"
  SecurityAdd csPreCpraEditPedido, "Editar Pedido de Compra", "Compras"
  SecurityAdd csPreCpraListPedido, "Listar Pedido de Compra", "Compras"
  SecurityAdd csPreCpraDesAnularPedido, "Des-anular Pedido de Compra", "Compras"
  SecurityAdd csPreCpraAnularPedido, "Anular Pedido de Compra", "Compras"

  SecurityAdd csPreCpraModifyAplic, "Modificar aplicacion de compras", "Compras"

  SecurityAdd csPreCpraNewOrden, "Agregar Orden de Compra", "Compras"
  SecurityAdd csPreCpraDeleteOrden, "Borrar Orden de Compra", "Compras"
  SecurityAdd csPreCpraEditOrden, "Editar Orden de Compra", "Compras"
  SecurityAdd csPreCpraListOrden, "Listar Orden de Compra", "Compras"
  SecurityAdd csPreCpraDesAnularOrden, "Des-anular Orden de Compra", "Compras"
  SecurityAdd csPreCpraAnularOrden, "Anular Orden de Compra", "Compras"

  SecurityAdd csPreCpraNewCotizacion, "Agregar Cotización de Compra", "Compras"
  SecurityAdd csPreCpraDeleteCotizacion, "Borrar Cotización de Compra", "Compras"
  SecurityAdd csPreCpraEditCotizacion, "Editar Cotización de Compra", "Compras"
  SecurityAdd csPreCpraListCotizacion, "Listar Cotización de Compra", "Compras"
  SecurityAdd csPreCpraDesAnularCotizacion, "Des-anular Cotización de Compra", "Compras"
  SecurityAdd csPreCpraAnularCotizacion, "Anular Cotización de Compra", "Compras"

  SecurityAdd csPreCpraNewPresupuesto, "Agregar Presupuesto de Compra", "Compras"
  SecurityAdd csPreCpraDeletePresupuesto, "Borrar Presupuesto de Compra", "Compras"
  SecurityAdd csPreCpraEditPresupuesto, "Editar Presupuesto de Compra", "Compras"
  SecurityAdd csPreCpraListPresupuesto, "Listar Presupuesto de Compra", "Compras"
  SecurityAdd csPreCpraDesAnularPresupuesto, "Des-anular Presupuesto de Compra", "Compras"
  SecurityAdd csPreCpraAnularPresupuesto, "Anular Presupuesto de Compra", "Compras"

  SecurityAdd csPreCpraEditPricePed, "Editar Precios en Pedido de Compra", "Compras"
  SecurityAdd csPreCpraEditPriceOrd, "Editar Precios en Orden de Compra", "Compras"
  SecurityAdd csPreCpraEditPriceRem, "Editar Precios en Remito de Compra", "Compras"
  SecurityAdd csPreCpraEditPriceFac, "Editar Precios en Factura de Compra", "Compras"

  SecurityAdd csPreCpraNewDespImpoCalc, "Agregar Cálculo Coeficiente de Costos de Importación", "Compras"
  SecurityAdd csPreCpraDeleteDespImpoCalc, "Borrar Cálculo Coeficiente de Costos de Importación", "Compras"
  SecurityAdd csPreCpraEditDespImpoCalc, "Editar Cálculo Coeficiente de Costos de Importación", "Compras"
  SecurityAdd csPreCpraListDespImpoCalc, "Listar Cálculo Coeficiente de Costos de Importación", "Compras"

End Sub

' funciones privadas
' construccion - destruccion
