VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSDocumentoPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSDocumentoPrestaciones
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
' estructuras
' enumeraciones
Public Enum csDocumentoPrestacion
    
    csPreDNewDocumento = 4000
    csPreDEditDocumento = 4001
    csPreDDeleteDocumento = 4002
    csPreDListDocumento = 4003
    
    csPreDNewFechaControlAcceso = 4004
    csPreDEditFechaControlAcceso = 4005
    csPreDDeleteFechaControlAcceso = 4006
    csPreDListFechaControlAcceso = 4007
    
    csPreDNewTalonario = 4008
    csPreDEditTalonario = 4009
    csPreDDeleteTalonario = 4010
    csPreDListTalonario = 4011
    
    csPreDLoadDocuments = 4012
    
    csPreDEditDocumentoImpresora = 4013
    
    csPreDNewDocumentoGrupo = 4014
    csPreDEditDocumentoGrupo = 4015
    csPreDDeleteDocumentoGrupo = 4016
    csPreDListDocumentoGrupo = 4017
    
End Enum

Public Enum csMenuEnum
  csMenuConfigDocumentos = 4001
End Enum
' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
    
    SecurityAdd csPreDNewDocumento, "Agregar Documentos", "Documentos"
    SecurityAdd csPreDDeleteDocumento, "Borrar Documentos", "Documentos"
    SecurityAdd csPreDEditDocumento, "Editar Documentos", "Documentos"
    SecurityAdd csPreDListDocumento, "Listar Documentos", "Documentos"

    SecurityAdd csPreDNewFechaControlAcceso, "Agregar Fechas de Control de Acceso", "Documentos"
    SecurityAdd csPreDDeleteFechaControlAcceso, "Borrar Fechas de Control de Acceso", "Documentos"
    SecurityAdd csPreDEditFechaControlAcceso, "Editar Fechas de Control de Acceso", "Documentos"
    SecurityAdd csPreDListFechaControlAcceso, "Listar Fechas de Control de Acceso", "Documentos"

    SecurityAdd csPreDNewTalonario, "Agregar Talonario", "Talonario"
    SecurityAdd csPreDDeleteTalonario, "Borrar Talonario", "Talonario"
    SecurityAdd csPreDEditTalonario, "Editar Talonario", "Talonario"
    SecurityAdd csPreDListTalonario, "Listar Talonario", "Talonario"
    
    SecurityAdd csPreDLoadDocuments, "Cargar Modulo de Documentos", "Documentos"
    
    SecurityAdd csPreDEditDocumentoImpresora, "Editar Configuración de Impresoras", "Documentos"
    
    SecurityAdd csPreDNewDocumentoGrupo, "Agregar Documento Grupo", "Documento"
    SecurityAdd csPreDDeleteDocumentoGrupo, "Borrar Documento Grupo", "Documento"
    SecurityAdd csPreDEditDocumentoGrupo, "Editar Documento Grupo", "Documento"
    SecurityAdd csPreDListDocumentoGrupo, "Listar Documento Grupo", "Documento"
    
End Sub

' funciones privadas
' construccion - destruccion



