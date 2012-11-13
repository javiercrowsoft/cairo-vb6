VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSEXPPrintPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSEXPPrintPrestaciones
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

Public Enum csExportPrintPrestacion
  csPreExpNewExpoFamilia = 22501
  csPreExpEditExpoFamilia = 22502
  csPreExpDeleteExpoFamilia = 22503
  csPreExpListExpoFamilia = 22504

  csPreExpNewExpoGrupoPrecio = 22505
  csPreExpEditExpoGrupoPrecio = 22506
  csPreExpDeleteExpoGrupoPrecio = 22507
  csPreExpListExpoGrupoPrecio = 22508

End Enum

Public Enum csMenuEnum
  csMenuExpConfigExportPrint = 22501
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
  SecurityAdd csPreExpNewExpoFamilia, "Agregar Familia de Exportación", "ExportPrint"
  SecurityAdd csPreExpDeleteExpoFamilia, "Borrar Familia de Exportación", "ExportPrint"
  SecurityAdd csPreExpEditExpoFamilia, "Editar Familia de Exportación", "ExportPrint"
  SecurityAdd csPreExpListExpoFamilia, "Listar Familia de Exportación", "ExportPrint"

  SecurityAdd csPreExpNewExpoGrupoPrecio, "Agregar Grupo de Precio de Exportación", "ExportPrint"
  SecurityAdd csPreExpDeleteExpoGrupoPrecio, "Borrar Grupo de Precio de Exportación", "ExportPrint"
  SecurityAdd csPreExpEditExpoGrupoPrecio, "Editar Grupo de Precio de Exportación", "ExportPrint"
  SecurityAdd csPreExpListExpoGrupoPrecio, "Listar Grupo de Precio de Exportación", "ExportPrint"
End Sub

' funciones privadas
' construccion - destruccion





