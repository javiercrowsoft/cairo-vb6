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
Public Enum csETablesTick
  csAlarma = 28001
  csIncidenteApertura = 28002
  csIncidenteTipo = 28003
  csAlarmaItemTipo = 28004
  csEquipoTipoFalla = 28005
  csEquipoDetalle = 28006
  csOrdenServicio = 28008
  csParteReparacion = 28007
  csMail = 28009
End Enum

Public Enum csEAlarmaTiempoTipo
  csE_ATTHora = 1
  csE_ATTDia = 2
End Enum

Public Enum csEAlarmaTiempoDesde
  csE_TDInicio = 1
  csE_TDPasoAnterior = 2
End Enum

Public Enum csEAlarmaTiempoLaboral
  csE_TDHabiles = 1
  csE_TDDiasCorridos = 2
End Enum

Public Enum csEAlarmaDiaTipo
  csE_ADTSemana = 1
  csE_ADTMes = 2
End Enum

Public Enum csEAlaramEstadoTipo
  csE_AETMinuto = 1
  csE_AETHora = 2
  csE_AETDia = 3
End Enum

Public Enum csEParteReparacionTipo
  csE_Presupuesto = 1
  csE_Reparacion = 2
End Enum

Public Enum csEEdItemType
  csEdItemDate = 1
  csEdItemHelp = 2
  csEdItemNumeric = 3
  csEdItemSqlstmt = 4
  csEdItemText = 5
  csEdItemList = 6
  csEdItemCheck = 7
End Enum

Public Enum cscEParteReparacionEstado
  csE_PrpPendiente = 1
  csE_PrpRechazado = 2
  csE_PrpPendienteAprob = 3
  csE_PrpAprobado = 4
  csE_PrpRepuestos = 5
End Enum

Public Enum csEAlarmaItemTipo
  csE_AlitGenerico = 1
  csE_AlitPresupuesto = 2
  csE_AlitAprobacion = 3
  csE_AlitRepuesto = 4
End Enum

Public Enum csEMailTtype
  csE_MailTypeAllHaveToResponse
  csE_MailTypeOneHaveToResponse
End Enum

Public Enum csEMailTimeType
  csE_MTTMinuto = 1
  csE_MTTHora = 2
  csE_MTTDia = 3
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
