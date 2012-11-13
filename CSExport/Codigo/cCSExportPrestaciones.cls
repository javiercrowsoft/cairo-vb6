VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSExportPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSExportPrestaciones
' 28-04-2004

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

Public Enum csExportPrestacion
  csPreExpNewAduana = 22001
  csPreExpEditAduana = 22002
  csPreExpDeleteAduana = 22003
  csPreExpListAduana = 22004

  csPreExpNewEmbarque = 22005
  csPreExpEditEmbarque = 22006
  csPreExpDeleteEmbarque = 22007
  csPreExpListEmbarque = 22008

  csPreExpNewPermisoEmbarque = 22009
  csPreExpEditPermisoEmbarque = 22010
  csPreExpDeletePermisoEmbarque = 22011
  csPreExpListPermisoEmbarque = 22012
  csPreExpDesAnularPermisoEmbarque = 22013
  csPreExpAnularPermisoEmbarque = 22014

  csPreExpNewManifiestoCarga = 22015
  csPreExpEditManifiestoCarga = 22016
  csPreExpDeleteManifiestoCarga = 22017
  csPreExpListManifiestoCarga = 22018
  csPreExpDesAnularManifiestoCarga = 22019
  csPreExpAnularManifiestoCarga = 22020

  csPreExpNewPackingList = 22020
  csPreExpEditPackingList = 22021
  csPreExpDeletePackingList = 22022
  csPreExpListPackingList = 22023
  csPreExpDesAnularPackingList = 22024
  csPreExpAnularPackingList = 22025

  csPreExpModifyAplic = 22026

  csPreExpNewGarantia = 22027
  csPreExpEditGarantia = 22028
  csPreExpDeleteGarantia = 22029
  csPreExpListGarantia = 22030

  csPreExpNewImportacionTmp = 22031
  csPreExpEditImportacionTmp = 22032
  csPreExpDeleteImportacionTmp = 22033
  csPreExpListImportacionTmp = 22034
  csPreExpDesAnularImportacionTmp = 22035
  csPreExpAnularImportacionTmp = 22036
  
  csPreGModifyConfigExport = 22037
End Enum

Public Enum csMenuEnum
  csMenuExportacionConfig = 22999
  csMenuExportacion = 22998
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
  SecurityAdd csPreExpNewAduana, "Agregar Aduana", "Exportación"
  SecurityAdd csPreExpDeleteAduana, "Borrar Aduana", "Exportación"
  SecurityAdd csPreExpEditAduana, "Editar Aduana", "Exportación"
  SecurityAdd csPreExpListAduana, "Listar Aduana", "Exportación"

  SecurityAdd csPreExpNewEmbarque, "Agregar Embarque", "Exportación"
  SecurityAdd csPreExpDeleteEmbarque, "Borrar Embarque", "Exportación"
  SecurityAdd csPreExpEditEmbarque, "Editar Embarque", "Exportación"
  SecurityAdd csPreExpListEmbarque, "Listar Embarque", "Exportación"

  SecurityAdd csPreExpNewPermisoEmbarque, "Agregar Permiso de Embarque", "Exportación"
  SecurityAdd csPreExpDeletePermisoEmbarque, "Borrar Permiso de Embarque", "Exportación"
  SecurityAdd csPreExpEditPermisoEmbarque, "Editar Permiso de Embarque", "Exportación"
  SecurityAdd csPreExpListPermisoEmbarque, "Listar Permiso de Embarque", "Exportación"
  SecurityAdd csPreExpAnularPermisoEmbarque, "Anular Permiso de Embarque", "Exportación"
  SecurityAdd csPreExpDesAnularPermisoEmbarque, "Des-anular Permiso de Embarque", "Exportación"

  SecurityAdd csPreExpNewManifiestoCarga, "Agregar Manifiesto de Carga", "Exportación"
  SecurityAdd csPreExpDeleteManifiestoCarga, "Borrar Manifiesto de Carga", "Exportación"
  SecurityAdd csPreExpEditManifiestoCarga, "Editar Manifiesto de Carga", "Exportación"
  SecurityAdd csPreExpListManifiestoCarga, "Listar Manifiesto de Carga", "Exportación"
  SecurityAdd csPreExpAnularManifiestoCarga, "Anular Manifiesto de Carga", "Exportación"
  SecurityAdd csPreExpDesAnularManifiestoCarga, "Des-anular Manifiesto de Carga", "Exportación"

  SecurityAdd csPreExpNewPackingList, "Agregar Packing List", "Exportación"
  SecurityAdd csPreExpDeletePackingList, "Borrar Packing List", "Exportación"
  SecurityAdd csPreExpEditPackingList, "Editar Packing List", "Exportación"
  SecurityAdd csPreExpListPackingList, "Listar Packing List", "Exportación"
  SecurityAdd csPreExpAnularPackingList, "Anular Packing List", "Exportación"
  SecurityAdd csPreExpDesAnularPackingList, "Des-anular Packing List", "Exportación"
  
  SecurityAdd csPreExpModifyAplic, "Modificar aplicacion de exportación", "Exportación"

  SecurityAdd csPreExpNewGarantia, "Agregar Garantía", "Exportación"
  SecurityAdd csPreExpDeleteGarantia, "Borrar Garantía", "Exportación"
  SecurityAdd csPreExpEditGarantia, "Editar Garantía", "Exportación"
  SecurityAdd csPreExpListGarantia, "Listar Garantía", "Exportación"

  SecurityAdd csPreExpNewImportacionTmp, "Agregar Importacion Temporal", "Exportación"
  SecurityAdd csPreExpDeleteImportacionTmp, "Borrar Importacion Temporal", "Exportación"
  SecurityAdd csPreExpEditImportacionTmp, "Editar Importacion Temporal", "Exportación"
  SecurityAdd csPreExpListImportacionTmp, "Listar Importacion Temporal", "Exportación"
  SecurityAdd csPreExpAnularImportacionTmp, "Anular Importacion Temporal", "Exportación"
  SecurityAdd csPreExpDesAnularImportacionTmp, "Des-anular Importacion Temporal", "Exportación"

  SecurityAdd csPreGModifyConfigExport, "Editar configuración general de exportación", "Exportación"
End Sub

' funciones privadas
' construccion - destruccion





