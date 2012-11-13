VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSPedVtaPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSPedVtaPrestaciones
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
Public Enum csPedidoVtaPrestacion
  csPrePVNewPedidoVta = 3000
  csPrePVEditPedidoVta = 3001
  csPrePVDeletePedidoVta = 3002
  csPrePVListPedidoVta = 3003
  csPrePVDesAnular = 3004
  csPrePVAnular = 3005
  csPrePVEditPrice = 3006
End Enum

Public Enum csMenuEnum
  csMenuConfig = 3999
  csMenuVentas = 3998
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
    
    SecurityAdd csPrePVNewPedidoVta, "Agregar Pedidos de Venta", "Pedidos de Venta"
    SecurityAdd csPrePVDeletePedidoVta, "Borrar Pedidos de Venta", "Pedidos de Venta"
    SecurityAdd csPrePVEditPedidoVta, "Editar Pedidos de Venta", "Pedidos de Venta"
    SecurityAdd csPrePVListPedidoVta, "Listar Pedidos de Venta", "Pedidos de Venta"
    SecurityAdd csPrePVDesAnular, "Des anular", "Pedidos de Venta"
    SecurityAdd csPrePVAnular, "Anular", "Pedidos de Venta"
    SecurityAdd csPrePVEditPrice, "Editar precios en pedido de venta", "Pedidos de Venta"
End Sub

' funciones privadas
' construccion - destruccion




