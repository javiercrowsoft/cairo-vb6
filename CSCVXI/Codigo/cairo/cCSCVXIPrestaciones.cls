VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSCVXIPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCVXIPrestaciones
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

Public Enum csCVXIPrestacion
  csPreCVXINewRespuestaPlantilla = 39001
  csPreCVXIEditRespuestaPlantilla = 39002
  csPreCVXIDeleteRespuestaPlantilla = 39003
  csPreCVXIListRespuestaPlantilla = 39004
  
  csPreCVXINewTexto = 39005
  csPreCVXIEditTexto = 39006
  csPreCVXIDeleteTexto = 39007
  csPreCVXIListTexto = 39008

  csPreCVXIListEmail = 39009

  csPreCVXINewComunidad = 39010
  csPreCVXIEditComunidad = 39011
  csPreCVXIDeleteComunidad = 39012
  csPreCVXIListComunidad = 39013
  
  csPreCVXIBrowser = 39014
  
  csPreCVXIEditProducto = 39015

  csPreCVXIEditPregunta = 39016
  csPreCVXIListPregunta = 39017

End Enum

Public Enum csMenuEnum
  csMenuConfig = 39000
  csMenuComunidad = 39001
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
  SecurityAdd csPreCVXINewRespuestaPlantilla, "Agregar Plantilla de Respuesta", "Comunidad Internet"
  SecurityAdd csPreCVXIDeleteRespuestaPlantilla, "Borrar Plantilla de Respuesta", "Comunidad Internet"
  SecurityAdd csPreCVXIEditRespuestaPlantilla, "Editar Plantilla de Respuesta", "Comunidad Internet"
  SecurityAdd csPreCVXIListRespuestaPlantilla, "Listar Plantilla de Respuesta", "Comunidad Internet"

  SecurityAdd csPreCVXINewTexto, "Agregar Texto", "Comunidad Internet"
  SecurityAdd csPreCVXIDeleteTexto, "Borrar Texto", "Comunidad Internet"
  SecurityAdd csPreCVXIEditTexto, "Editar Texto", "Comunidad Internet"
  SecurityAdd csPreCVXIListTexto, "Listar Texto", "Comunidad Internet"

  SecurityAdd csPreCVXIListEmail, "Listar E-Mail", "Comunidad Internet"

  SecurityAdd csPreCVXINewComunidad, "Agregar Comunidad", "Comunidad Internet"
  SecurityAdd csPreCVXIDeleteComunidad, "Borrar Comunidad", "Comunidad Internet"
  SecurityAdd csPreCVXIEditComunidad, "Editar Comunidad", "Comunidad Internet"
  SecurityAdd csPreCVXIListComunidad, "Listar Comunidad", "Comunidad Internet"
  
  SecurityAdd csPreCVXIBrowser, "Navegar Pagina Comunidad Internet", "Comunidad Internet"
  SecurityAdd csPreCVXIEditProducto, "Editar Articulos Comunidad Internet", "Comunidad Internet"

  SecurityAdd csPreCVXIEditPregunta, "Editar Pregunta", "Comunidad Internet"
  SecurityAdd csPreCVXIListPregunta, "Listar Pregunta", "Comunidad Internet"
End Sub

' funciones privadas
' construccion - destruccion
