VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSStockPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSStockPrestaciones
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

Public Enum csStockPrestacion
  csPreStNewStock = 20001
  csPreStEditStock = 20002
  csPreStDeleteStock = 20003
  csPreStListStock = 20004

  csPreStNewRecuentoStock = 20007
  csPreStEditRecuentoStock = 20008
  csPreStDeleteRecuentoStock = 20009
  csPreStListRecuentoStock = 20010

  csPreStNewParteProdKit = 20011
  csPreStEditParteProdKit = 20012
  csPreStDeleteParteProdKit = 20013
  csPreStListParteProdKit = 20014

  csPreStNewStockProveedor = 20015
  csPreStEditStockProveedor = 20016
  csPreStDeleteStockProveedor = 20017
  csPreStListStockProveedor = 20018

  csPreStNewStockCliente = 20019
  csPreStEditStockCliente = 20020
  csPreStDeleteStockCliente = 20021
  csPreStListStockCliente = 20022
  
  csPreStNewOrdenProdKit = 20023
  csPreStEditOrdenProdKit = 20024
  csPreStDeleteOrdenProdKit = 20025
  csPreStListOrdenProdKit = 20026
End Enum

Public Enum csMenuEnum
  csMenuStock = 20001
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
  SecurityAdd csPreStNewStock, "Agregar Movimiento de Stock", "Stock"
  SecurityAdd csPreStDeleteStock, "Borrar Movimiento de Stock", "Stock"
  SecurityAdd csPreStEditStock, "Editar Movimiento de Stock", "Stock"
  SecurityAdd csPreStListStock, "Listar Movimiento de Stock", "Stock"

  SecurityAdd csPreStNewRecuentoStock, "Agregar Recuento de Stock", "RecuentoStock"
  SecurityAdd csPreStDeleteRecuentoStock, "Borrar Recuento de Stock", "RecuentoStock"
  SecurityAdd csPreStEditRecuentoStock, "Editar Recuento de Stock", "RecuentoStock"
  SecurityAdd csPreStListRecuentoStock, "Listar Recuento de Stock", "RecuentoStock"

  SecurityAdd csPreStNewParteProdKit, "Agregar Parte de Produccion Kit", "ParteProdKit"
  SecurityAdd csPreStDeleteParteProdKit, "Borrar Parte de Produccion Kit", "ParteProdKit"
  SecurityAdd csPreStEditParteProdKit, "Editar Parte de Produccion Kit", "ParteProdKit"
  SecurityAdd csPreStListParteProdKit, "Listar Parte de Produccion Kit", "ParteProdKit"

  SecurityAdd csPreStNewStockProveedor, "Agregar Transferencia de Stock a Proveedor", "StockProveedor"
  SecurityAdd csPreStDeleteStockProveedor, "Borrar Transferencia de Stock a Proveedor", "StockProveedor"
  SecurityAdd csPreStEditStockProveedor, "Editar Transferencia de Stock a Proveedor", "StockProveedor"
  SecurityAdd csPreStListStockProveedor, "Listar Transferencia de Stock a Proveedor", "StockProveedor"

  SecurityAdd csPreStNewStockCliente, "Agregar Transferencia de Stock a Cliente", "StockCliente"
  SecurityAdd csPreStDeleteStockCliente, "Borrar Transferencia de Stock a Cliente", "StockCliente"
  SecurityAdd csPreStEditStockCliente, "Editar Transferencia de Stock a Cliente", "StockCliente"
  SecurityAdd csPreStListStockCliente, "Listar Transferencia de Stock a Cliente", "StockCliente"
  
  SecurityAdd csPreStNewOrdenProdKit, "Agregar Orden de Produccion Kit", "OrdenProdKit"
  SecurityAdd csPreStDeleteOrdenProdKit, "Borrar Orden de Produccion Kit", "OrdenProdKit"
  SecurityAdd csPreStEditOrdenProdKit, "Editar Orden de Produccion Kit", "OrdenProdKit"
  SecurityAdd csPreStListOrdenProdKit, "Listar Orden de Produccion Kit", "OrdenProdKit"
  
End Sub

' funciones privadas
' construccion - destruccion
