VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSContPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSContabilidadPrestaciones
' 28-01-2004

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

Public Enum csContabilidadPrestacion
  csPreConNewAsiento = 19001
  csPreConEditAsiento = 19002
  csPreConDeleteAsiento = 19003
  csPreConListAsiento = 19004

  csPreConNewEjercicio = 19005
  csPreConEditEjercicio = 19006
  csPreConDeleteEjercicio = 19007
  csPreConListEjercicio = 19008

  csPreConRenumerarAsientos = 19009
End Enum

Public Enum csMenuEnum
  csMenuContabilidad = 19999
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
  SecurityAdd csPreConNewAsiento, "Agregar Asiento", "Asiento"
  SecurityAdd csPreConDeleteAsiento, "Borrar Asiento", "Asiento"
  SecurityAdd csPreConEditAsiento, "Editar Asiento", "Asiento"
  SecurityAdd csPreConListAsiento, "Listar Asiento", "Asiento"

  SecurityAdd csPreConNewEjercicio, "Agregar Ejercicio Contable", "Ejercicio Contable"
  SecurityAdd csPreConDeleteEjercicio, "Borrar Ejercicio Contable", "Ejercicio Contable"
  SecurityAdd csPreConEditEjercicio, "Editar Ejercicio Contable", "Ejercicio Contable"
  SecurityAdd csPreConListEjercicio, "Listar Ejercicio Contable", "Ejercicio Contable"
  
  SecurityAdd csPreConRenumerarAsientos, "Renumerar Asientos", "Asientos"
End Sub

' funciones privadas
' construccion - destruccion
