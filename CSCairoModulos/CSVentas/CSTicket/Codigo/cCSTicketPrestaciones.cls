VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSTicketPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' ccsPreTicketPrestaciones
' 17-11-2006

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
Public Enum csPreTicketPrestacion
  csPreTickNewOrdenServ = 28000
  csPreTickEditOrdenServ = 28001
  csPreTickDeleteOrdenServ = 28002
  csPreTickListOrdenServ = 28003
  csPreTickDesAnularOrdenServ = 28004
  csPreTickAnularOrdenServ = 28005
  csPreTickEditPriceOrdenServ = 28006

  csPreTickNewAlarma = 28007
  csPreTickEditAlarma = 28008
  csPreTickDeleteAlarma = 28009
  csPreTickListAlarma = 28010

  csPreTickListEquipos = 28011

  csPreTickNewParteReparacion = 28012
  csPreTickEditParteReparacion = 28013
  csPreTickDeleteParteReparacion = 28014
  csPreTickListParteReparacion = 28015
  csPreTickAnularParteReparacion = 28016
  
  csPreTickEditPrecioParte = 28017

  csPreTickNewAlarmaItemTipo = 28018
  csPreTickEditAlarmaItemTipo = 28019
  csPreTickDeleteAlarmaItemTipo = 28020
  csPreTickListAlarmaItemTipo = 28021

  csPreTickNewEquipoTipoFalla = 28022
  csPreTickEditEquipoTipoFalla = 28023
  csPreTickDeleteEquipoTipoFalla = 28024
  csPreTickListEquipoTipoFalla = 28025

  csPreTickNewEquipoDetalle = 28026
  csPreTickEditEquipoDetalle = 28027
  csPreTickDeleteEquipoDetalle = 28028
  csPreTickListEquipoDetalle = 28029

  csPreTickNewMail = 28030
  csPreTickEditMail = 28031
  csPreTickDeleteMail = 28032
  csPreTickListMail = 28033
  
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
    
  SecurityAdd csPreTickNewOrdenServ, "Agregar Orden de Servicio", "Servicios"
  SecurityAdd csPreTickDeleteOrdenServ, "Borrar Orden de Servicio", "Servicios"
  SecurityAdd csPreTickEditOrdenServ, "Editar Orden de Servicio", "Servicios"
  SecurityAdd csPreTickListOrdenServ, "Listar Orden de Servicio", "Servicios"
  SecurityAdd csPreTickDesAnularOrdenServ, "Des anular Orden de Servicio", "Servicios"
  SecurityAdd csPreTickAnularOrdenServ, "Anular Orden de Servicio", "Servicios"
  SecurityAdd csPreTickEditPriceOrdenServ, "Editar Precios en Orden de Servicio", "Servicios"
  
  SecurityAdd csPreTickNewAlarma, "Agregar Alarmas", "Servicios"
  SecurityAdd csPreTickEditAlarma, "Borrar Alarmas", "Servicios"
  SecurityAdd csPreTickDeleteAlarma, "Editar Alarmas", "Servicios"
  SecurityAdd csPreTickListAlarma, "Listar Alarmas", "Servicios"
  
  SecurityAdd csPreTickListEquipos, "Listar Equipos", "Servicios"

  SecurityAdd csPreTickNewParteReparacion, "Agregar Parte de Reparación", "Servicios"
  SecurityAdd csPreTickDeleteParteReparacion, "Borrar Parte de Reparación", "Servicios"
  SecurityAdd csPreTickEditParteReparacion, "Editar Parte de Reparación", "Servicios"
  SecurityAdd csPreTickListParteReparacion, "Listar Parte de Reparación", "Servicios"
  SecurityAdd csPreTickAnularParteReparacion, "Anular Parte de Reparación", "Servicios"
  
  SecurityAdd csPreTickEditPrecioParte, "Editar Precios en Parte de Reparación", "Servicios"

  SecurityAdd csPreTickNewAlarmaItemTipo, "Agregar Tipos de Alarmas", "Servicios"
  SecurityAdd csPreTickEditAlarmaItemTipo, "Borrar Tipos de Alarmas", "Servicios"
  SecurityAdd csPreTickDeleteAlarmaItemTipo, "Editar Tipos de Alarmas", "Servicios"
  SecurityAdd csPreTickListAlarmaItemTipo, "Listar Tipos de Alarmas", "Servicios"

  SecurityAdd csPreTickNewEquipoTipoFalla, "Agregar Tipos de Fallas", "Servicios"
  SecurityAdd csPreTickEditEquipoTipoFalla, "Borrar Tipos de Fallas", "Servicios"
  SecurityAdd csPreTickDeleteEquipoTipoFalla, "Editar Tipos de Fallas", "Servicios"
  SecurityAdd csPreTickListEquipoTipoFalla, "Listar Tipos de Fallas", "Servicios"
              
  SecurityAdd csPreTickNewEquipoDetalle, "Agregar Detalle de Equipos", "Servicios"
  SecurityAdd csPreTickEditEquipoDetalle, "Borrar Detalle de Equipos", "Servicios"
  SecurityAdd csPreTickDeleteEquipoDetalle, "Editar Detalle de Equipos", "Servicios"
  SecurityAdd csPreTickListEquipoDetalle, "Listar Detalle de Equipos", "Servicios"

  SecurityAdd csPreTickNewMail, "Agregar Mails", "Servicios"
  SecurityAdd csPreTickEditMail, "Borrar Mails", "Servicios"
  SecurityAdd csPreTickDeleteMail, "Editar Mails", "Servicios"
  SecurityAdd csPreTickListMail, "Listar Mails", "Servicios"

End Sub

' funciones privadas
' construccion - destruccion
