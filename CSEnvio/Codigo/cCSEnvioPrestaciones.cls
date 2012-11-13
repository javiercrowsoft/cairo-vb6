VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSEnvioPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSEnvioPrestaciones
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

Public Enum csEnvioPrestacion
  csPreEnvNewLegajo = 15001
  csPreEnvEditLegajo = 15002
  csPreEnvDeleteLegajo = 15003
  csPreEnvListLegajo = 15004
  
  csPreEnvNewParteDiario = 15005
  csPreEnvEditParteDiario = 15006
  csPreEnvDeleteParteDiario = 15007
  csPreEnvListParteDiario = 15008
  
  csPreEnvModifyConfig = 15009
  
  csPreEnvNewTipoTransporte = 15010
  csPreEnvEditTipoTransporte = 15011
  csPreEnvDeleteTipoTransporte = 15012
  csPreEnvListTipoTransporte = 15013
  
  csPreEnvNewTarifa = 15014
  csPreEnvEditTarifa = 15015
  csPreEnvDeleteTarifa = 15016
  csPreEnvListTarifa = 15017
  
  csPreEnvNewLegajoTipo = 15018
  csPreEnvEditLegajoTipo = 15019
  csPreEnvDeleteLegajoTipo = 15020
  csPreEnvListLegajoTipo = 15021

  csPreEnvNewVuelo = 15022
  csPreEnvEditVuelo = 15023
  csPreEnvDeleteVuelo = 15024
  csPreEnvListVuelo = 15025
  
  csPreEnvNewPresupuesto = 15026
  csPreEnvEditPresupuesto = 15027
  csPreEnvDeletePresupuesto = 15028
  csPreEnvListPresupuesto = 15029
  csPreEnvDesAnular = 15030
  csPreEnvAnular = 15031
End Enum

Public Enum csMenuEnum
  csMenuEnvio = 15001
  csMenuConfig = 15002
  csMenuAgenda = 15003
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
  SecurityAdd csPreEnvNewLegajo, "Agregar Legajo", "Envios"
  SecurityAdd csPreEnvDeleteLegajo, "Borrar Legajo", "Envios"
  SecurityAdd csPreEnvEditLegajo, "Editar Legajo", "Envios"
  SecurityAdd csPreEnvListLegajo, "Listar Legajo", "Envios"
  
  SecurityAdd csPreEnvNewParteDiario, "Agregar Parte Diario", "Envios"
  SecurityAdd csPreEnvDeleteParteDiario, "Borrar Parte Diario", "Envios"
  SecurityAdd csPreEnvEditParteDiario, "Editar Parte Diario", "Envios"
  SecurityAdd csPreEnvListParteDiario, "Listar Parte Diario", "Envios"
  
  SecurityAdd csPreEnvModifyConfig, "Modificar configuración general", "Envios"
  
  SecurityAdd csPreEnvNewTipoTransporte, "Agregar TipoTransporte", "Envios"
  SecurityAdd csPreEnvDeleteTipoTransporte, "Borrar TipoTransporte", "Envios"
  SecurityAdd csPreEnvEditTipoTransporte, "Editar TipoTransporte", "Envios"
  SecurityAdd csPreEnvListTipoTransporte, "Listar TipoTransporte", "Envios"
  
  SecurityAdd csPreEnvNewTarifa, "Agregar Tarifa", "Envios"
  SecurityAdd csPreEnvDeleteTarifa, "Borrar Tarifa", "Envios"
  SecurityAdd csPreEnvEditTarifa, "Editar Tarifa", "Envios"
  SecurityAdd csPreEnvListTarifa, "Listar Tarifa", "Envios"
  
  SecurityAdd csPreEnvNewLegajoTipo, "Agregar Tipo de Legajo", "Envios"
  SecurityAdd csPreEnvDeleteLegajoTipo, "Borrar Tipo de Legajo", "Envios"
  SecurityAdd csPreEnvEditLegajoTipo, "Editar Tipo de Legajo", "Envios"
  SecurityAdd csPreEnvListLegajoTipo, "Listar Tipo de Legajo", "Envios"

  SecurityAdd csPreEnvNewVuelo, "Agregar Vuelo", "Envios"
  SecurityAdd csPreEnvDeleteVuelo, "Borrar Vuelo", "Envios"
  SecurityAdd csPreEnvEditVuelo, "Editar Vuelo", "Envios"
  SecurityAdd csPreEnvListVuelo, "Listar Vuelos", "Envios"

  SecurityAdd csPreEnvNewPresupuesto, "Agregar Presupuesto", "Envios"
  SecurityAdd csPreEnvDeletePresupuesto, "Borrar Presupuesto", "Envios"
  SecurityAdd csPreEnvEditPresupuesto, "Editar Presupuesto", "Envios"
  SecurityAdd csPreEnvListPresupuesto, "Listar Presupuestos", "Envios"

  SecurityAdd csPreEnvAnular, "Anular Presupuesto", "Envios"
  SecurityAdd csPreEnvDesAnular, "Desanular Presupuestos", "Envios"
End Sub

' funciones privadas
' construccion - destruccion





