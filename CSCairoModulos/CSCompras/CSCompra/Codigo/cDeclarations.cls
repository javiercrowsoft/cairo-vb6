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
' 24-03-02

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Public Enum csETablesCompras
  csFacturaCompra = 17001
  csDespachoImpCalculo = 17002
  csRemitoCompra = 17003
  csOrdenCompra = 17004
  csPedidoCompra = 17005
End Enum

Public Enum csEDIC_Tipo
  csEDIC_Provisorio = 1
  csEDIC_Definitivo = 2
End Enum

Public Enum csETipoComprobante
  csETC_Original = 1
  csETC_Fax = 2
  csETC_FotoCopia = 3
  csETC_Duplicado = 4
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
