VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSTareaPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSTareaPrestaciones
' 23-03-02

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
Public Enum csTareaPrestacion
  csPreTareaNewTarea = 2000
  csPreTareaEditTarea = 2001
  csPreTareaDeleteTarea = 2002
  csPreTareaListTarea = 2003

  csPreTareaNewPrioridad = 2004
  csPreTareaEditPrioridad = 2005
  csPreTareaDeletePrioridad = 2006
  csPreTareaListPrioridad = 2007

  csPreTareaNewTareaEstado = 2008
  csPreTareaEditTareaEstado = 2009
  csPreTareaDeleteTareaEstado = 2010
  csPreTareaListTareaEstado = 2011

  csPreTareaNewContacto = 2012
  csPreTareaEditContacto = 2013
  csPreTareaDeleteContacto = 2014
  csPreTareaListContacto = 2015

  csPreTareaNewProyecto = 2016
  csPreTareaEditProyecto = 2017
  csPreTareaDeleteProyecto = 2018
  csPreTareaListProyecto = 2019

  csPreTareaNewHora = 2020
  csPreTareaEditHora = 2021
  csPreTareaDeleteHora = 2022
  csPreTareaListHora = 2023
  
  csPreTareaPublicContacto = 2024
  
  csPreTareaEditAgenda = 2025
  csPreTareaDeleteAgenda = 2026
  csPreTareaListAgenda = 2027
  csPreTareaNewAgenda = 2028

  csPreTareaNewTareaPlantilla = 2029
  csPreTareaEditTareaPlantilla = 2030
  csPreTareaDeleteTareaPlantilla = 2031
  csPreTareaListTareaPlantilla = 2032

End Enum

Public Enum csMenuEnum
  csMenuConfig = 2999
  csMenuProyecto = 2998
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
  
  SecurityAdd csPreTareaNewTarea, "Agregar Tareas", "Tareas"
  SecurityAdd csPreTareaDeleteTarea, "Borrar Tareas", "Tareas"
  SecurityAdd csPreTareaEditTarea, "Editar Tareas", "Tareas"
  SecurityAdd csPreTareaListTarea, "Listar Tareas", "Tareas"

  SecurityAdd csPreTareaNewContacto, "Agregar Contactos", "Contactos"
  SecurityAdd csPreTareaDeleteContacto, "Borrar Contactos", "Contactos"
  SecurityAdd csPreTareaEditContacto, "Editar Contactos", "Contactos"
  SecurityAdd csPreTareaListContacto, "Listar Contactos", "Contactos"

  SecurityAdd csPreTareaNewPrioridad, "Agregar Prioridades", "Prioridades"
  SecurityAdd csPreTareaDeletePrioridad, "Borrar Prioridades", "Prioridades"
  SecurityAdd csPreTareaEditPrioridad, "Editar Prioridades", "Prioridades"
  SecurityAdd csPreTareaListPrioridad, "Listar Prioridades", "Prioridades"

  SecurityAdd csPreTareaNewTareaEstado, "Agregar Estados de tareas", "Estados de tareas"
  SecurityAdd csPreTareaDeleteTareaEstado, "Borrar Estados de tareas", "Estados de tareas"
  SecurityAdd csPreTareaEditTareaEstado, "Editar Estados de tareas", "Estados de tareas"
  SecurityAdd csPreTareaListTareaEstado, "Listar Estados de tareas", "Estados de tareas"

  SecurityAdd csPreTareaNewProyecto, "Agregar Proyectos", "Proyectos"
  SecurityAdd csPreTareaDeleteProyecto, "Borrar Proyectos", "Proyectos"
  SecurityAdd csPreTareaEditProyecto, "Editar Proyectos", "Proyectos"
  SecurityAdd csPreTareaListProyecto, "Listar Proyectos", "Proyectos"

  SecurityAdd csPreTareaNewHora, "Agregar Horas", "Horas"
  SecurityAdd csPreTareaDeleteHora, "Borrar Horas", "Horas"
  SecurityAdd csPreTareaEditHora, "Editar Horas", "Horas"
  SecurityAdd csPreTareaListHora, "Listar Horas", "Horas"

  SecurityAdd csPreTareaNewAgenda, "Agregar Agenda", "Agenda"
  SecurityAdd csPreTareaDeleteAgenda, "Borrar Agenda", "Agenda"
  SecurityAdd csPreTareaEditAgenda, "Editar Agenda", "Agenda"
  SecurityAdd csPreTareaListAgenda, "Listar Agenda", "Agenda"

  SecurityAdd csPreTareaNewTareaPlantilla, "Agregar Plantilas de Tareas", "Proyectos"
  SecurityAdd csPreTareaDeleteTareaPlantilla, "Borrar Plantilas de Tareas", "Proyectos"
  SecurityAdd csPreTareaEditTareaPlantilla, "Editar Plantilas de Tareas", "Proyectos"
  SecurityAdd csPreTareaListTareaPlantilla, "Listar Plantilas de Tareas", "Proyectos"

End Sub

' funciones privadas
' construccion - destruccion



