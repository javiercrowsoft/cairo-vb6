VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSImportPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSImportPrestaciones
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

Public Enum csImportPrestacion
  csPreImporNewImportacionProceso = 23001
  csPreImporEditImportacionProceso = 23002
  csPreImporDeleteImportacionProceso = 23003
  csPreImporListImportacionProceso = 23004
  
  csPreImporExecImport = 23005
End Enum

Public Enum csMenuEnum
  csMenuImport = 23999
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
  SecurityAdd csPreImporNewImportacionProceso, "Agregar Proceso de Importación", "Importación"
  SecurityAdd csPreImporDeleteImportacionProceso, "Borrar Proceso de Importación", "Importación"
  SecurityAdd csPreImporEditImportacionProceso, "Editar Proceso de Importación", "Importación"
  SecurityAdd csPreImporListImportacionProceso, "Listar Proceso de Importación", "Importación"
  
  SecurityAdd csPreImporExecImport, "Procesar Importación", "Importación"
  
End Sub

' funciones privadas
' construccion - destruccion
