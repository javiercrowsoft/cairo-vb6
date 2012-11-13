VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSSGRPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSSGRPrestaciones
' 27-01-01

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
Public Enum CSSGRPrestacion

  csPreSGRNewSocio = 33001
  csPreSGREditSocio = 33002
  csPreSGRDeleteSocio = 33003
  csPreSGRListSocio = 33004
  
  csPreSGRNewSocioForm = 33005
  csPreSGREditSocioForm = 33006
  csPreSGRDeleteSocioForm = 33007
  csPreSGRListSocioForm = 33008
  
  csPreSGRNewFactura = 33009
  csPreSGREditFactura = 33010
  csPreSGRDeleteFactura = 33011
  csPreSGRListFactura = 33012
  csPreSGRDesAnularFactura = 33013
  csPreSGRAnularFactura = 33014
  
  csPreSGRListFacturaAccionParticipe = 33015
  csPreSGRListFacturaAvalCredito = 33016
  csPreSGRListFacturaAvalCheque = 33017
  csPreSGRListFacturaAvalOrdenCompra = 33018
  csPreSGRListFacturaAccionProtector = 33019
  
End Enum

Public Enum csMenuEnum
  csSocios = 33999
  csAvales = 33998
  csAcciones = 33997
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
  
  SecurityAdd csPreSGRNewSocio, "Agregar Socio Participe", "Socios"
  SecurityAdd csPreSGRDeleteSocio, "Borrar Socio Participe", "Socios"
  SecurityAdd csPreSGREditSocio, "Editar Socio Participe", "Socios"
  SecurityAdd csPreSGRListSocio, "Listar Socio Participe", "Socios"

  SecurityAdd csPreSGRNewSocioForm, "Agregar Formulario Inscripcion Socio", "Socios"
  SecurityAdd csPreSGRDeleteSocioForm, "Borrar Formulario Inscripcion Socio", "Socios"
  SecurityAdd csPreSGREditSocioForm, "Editar Formulario Inscripcion Socio", "Socios"
  SecurityAdd csPreSGRListSocioForm, "Listar Formulario Inscripcion Socio", "Socios"

  SecurityAdd csPreSGRNewFactura, "Agregar Factura SGR", "Avales"
  SecurityAdd csPreSGRDeleteFactura, "Borrar Factura SGR", "Avales"
  SecurityAdd csPreSGREditFactura, "Editar Factura SGR", "Avales"
  SecurityAdd csPreSGRListFactura, "Listar Factura SGR", "Avales"
  SecurityAdd csPreSGRAnularFactura, "Anular Factura SGR", "Avales"
  SecurityAdd csPreSGRDesAnularFactura, "Des-anular Factura SGR", "Avales"

  SecurityAdd csPreSGRListFacturaAccionParticipe, "Listar Ventas de Acciones a Socios Participes", "Avales"
  SecurityAdd csPreSGRListFacturaAccionProtector, "Listar Ventas de Acciones a Socios Protectores", "Avales"
  SecurityAdd csPreSGRListFacturaAvalCheque, "Listar Ventas de Cheques en la Bolsa de Comercio", "Avales"
  SecurityAdd csPreSGRListFacturaAvalCredito, "Listar Ventas de Avales sobre Creditos Bancarios", "Avales"
  SecurityAdd csPreSGRListFacturaAvalOrdenCompra, "Listar Ventas de Avales sobre Ordenes de Compra", "Avales"

End Sub

' funciones privadas
' construccion - destruccion
