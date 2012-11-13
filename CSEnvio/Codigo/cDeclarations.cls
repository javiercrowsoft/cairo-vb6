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
Public Enum csETablesEnvio
  csLegajo = 15001
  csParteDiario = 15002
  csTipoTransporte = 15003
  csTarifa = 15004
  csLegajoTipo = 15005
  csVuelo = 15006
  csTarifaItem = 15007
  csPresupuestoEnvio = 15009
End Enum

Public Enum csECumplida
  csECumplida_Pendiente = 1
  csECumplida_Rechazada = 2
  csECumplida_Cumplida = 3
End Enum

Public Enum csERecurrente
  csERecur_Week = 1
  csERecur_Day = 2
  csERecur_Year = 3
  csERecur_Month = 4
  csERecur_TwoMonth = 6
  csERecur_TreeMonth = 7
  csERecur_FourMonth = 8
  csERecur_SixMonth = 9
  csERecur_Once = 10
End Enum

Public Enum csE_VencimientoCumplido
  csEPtdVtoPendiente = 1
  csEPtdVtoCumplido = 2
  csEPtdVtoRechazado = 3
End Enum

Public Enum csETablesDoc
  csFacturaVenta = 16001
  csFacturaCompra = 17001
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



