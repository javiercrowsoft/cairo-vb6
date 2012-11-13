VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSInformePrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSInformePrestaciones
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

Public Enum csInformePrestacion
  csPreINewInforme = 7001
  csPreIEditInforme = 7002
  csPreIDeleteInforme = 7003
  csPreIListInforme = 7004

  csPreINewReporte = 7005
  csPreIEditReporte = 7006
  csPreIDeleteReporte = 7007
  csPreIListReporte = 7008

  csPreINewReporteParametro = 7009
  csPreIEditReporteParametro = 7010
  csPreIDeleteReporteParametro = 7011
  csPreIListReporteParametro = 7012

  csPreIModifyConfig = 7013
End Enum

Public Enum csMenuEnum
  csMenuConfigInformes = 7001
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()

    SecurityAdd csPreINewInforme, "Agregar Informe", "Informe"
    SecurityAdd csPreIDeleteInforme, "Borrar Informe", "Informe"
    SecurityAdd csPreIEditInforme, "Editar Informe", "Informe"
    SecurityAdd csPreIListInforme, "Listar Informe", "Informe"

    SecurityAdd csPreINewReporte, "Agregar Reporte", "Reporte"
    SecurityAdd csPreIDeleteReporte, "Borrar Reporte", "Reporte"
    SecurityAdd csPreIEditReporte, "Editar Reporte", "Reporte"
    SecurityAdd csPreIListReporte, "Listar Reporte", "Reporte"

    SecurityAdd csPreINewReporteParametro, "Agregar Parametro", "Parametro"
    SecurityAdd csPreIDeleteReporteParametro, "Borrar Parametro", "Parametro"
    SecurityAdd csPreIEditReporteParametro, "Editar Parametro", "Parametro"
    SecurityAdd csPreIListReporteParametro, "Listar Parametro", "Parametro"

    SecurityAdd csPreIModifyConfig, "Modificar Configuracion de Informes", "Configuracion de Informes"
End Sub

' funciones privadas
' construccion - destruccion
