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
' 30-05-03

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Public Enum csETablasDocumento
  CSDocumento = 4001
  csDocumentoTipo = 4003
  csFechaControlAcceso = 4002
  csTalonario = 4004
  csEstado = 4005
  csDocumentoGrupo = 4006
End Enum

Public Enum csETTipoTalonario
  csETTPropuesto = 1
  csETTImpresionFiscal = 2
  csETTAutoImpresor = 3
End Enum

Public Enum csETipoFactura
  csETFacDirecta = 0
  csETFacPedido = 1
  csETFacRemito = 2
  csETFacPackingList = 3
  csETFacProyecto = 4
  csETFacOrden = 5
End Enum

Public Enum csETipoPackingList
  csETPackDirecto = 0
  csETPackPedido = 1
  csETPackRemito = 2
  csETPackManifiesto = 3
End Enum

Public Enum csETipoOrdenCpra
  csETOrdenDirecta = 0
  csETOrdenPedido = 1
  csETOrdenPresupuesto = 2
End Enum
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
' funciones privadas
' construccion - destruccion

