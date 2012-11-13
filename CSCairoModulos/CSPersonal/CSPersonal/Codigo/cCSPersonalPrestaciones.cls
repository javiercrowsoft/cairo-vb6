VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSPersonalPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' ccsPrePersonalPrestaciones
' 18-08-2008

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
Public Enum csPrePersonalPrestacion

  csPrePNewSindicato = 35001
  csPrePEditSindicato = 35002
  csPrePDeleteSindicato = 35003
  csPrePListSindicato = 35004
  
  csPrePNewSindicatoConvenio = 35005
  csPrePEditSindicatoConvenio = 35006
  csPrePDeleteSindicatoConvenio = 35007
  csPrePListSindicatoConvenio = 35008
  
  csPrePNewEmpleadoEspecialidad = 35009
  csPrePEditEmpleadoEspecialidad = 35010
  csPrePDeleteEmpleadoEspecialidad = 35011
  csPrePListEmpleadoEspecialidad = 35012
  
  csPrePNewEmpleado = 35013
  csPrePEditEmpleado = 35014
  csPrePDeleteEmpleado = 35015
  csPrePListEmpleado = 35016
  
  csPrePNewEmpleadoART = 35017
  csPrePEditEmpleadoART = 35018
  csPrePDeleteEmpleadoART = 35019
  csPrePListEmpleadoART = 35020
  
  csPrePNewLiquidacionPlantilla = 35021
  csPrePEditLiquidacionPlantilla = 35022
  csPrePDeleteLiquidacionPlantilla = 35023
  csPrePListLiquidacionPlantilla = 35024
  
  csPrePNewLiquidacionFormula = 35025
  csPrePEditLiquidacionFormula = 35026
  csPrePDeleteLiquidacionFormula = 35027
  csPrePListLiquidacionFormula = 35028
  
  csPrePNewEmpleadoPeriodo = 35029
  csPrePEditEmpleadoPeriodo = 35030
  csPrePDeleteEmpleadoPeriodo = 35031
  csPrePListEmpleadoPeriodo = 35032
  
  csPrepNewEmpleadoAsistenciaTipo = 35033
  csPrepEditEmpleadoAsistenciaTipo = 35034
  csPrepDeleteEmpleadoAsistenciaTipo = 35035
  csPrepListEmpleadoAsistenciaTipo = 35036
  
  csPrepNewLiquidacion = 35037
  csPrepEditLiquidacion = 35038
  csPrepDeleteLiquidacion = 35039
  csPrepListLiquidacion = 35040
  csPrepDesAnularLiquidacion = 35041
  csPrepAnularLiquidacion = 35042
  
  csPrepNewLiquidacionCodigoTipo = 35043
  csPrepEditLiquidacionCodigoTipo = 35044
  csPrepDeleteLiquidacionCodigoTipo = 35045
  csPrepListLiquidacionCodigoTipo = 35046
  
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
  
  SecurityAdd csPrePNewSindicato, "Agregar Sindicato", "Sindicato"
  SecurityAdd csPrePDeleteSindicato, "Borrar Sindicato", "Sindicato"
  SecurityAdd csPrePEditSindicato, "Editar Sindicato", "Sindicato"
  SecurityAdd csPrePListSindicato, "Listar Sindicato", "Sindicato"

  SecurityAdd csPrePNewSindicatoConvenio, "Agregar Convenio Sindical", "Convenio Sindical"
  SecurityAdd csPrePDeleteSindicatoConvenio, "Borrar Convenio Sindical", "Convenio Sindical"
  SecurityAdd csPrePEditSindicatoConvenio, "Editar Convenio Sindical", "Convenio Sindical"
  SecurityAdd csPrePListSindicatoConvenio, "Listar Convenio Sindical", "Convenio Sindical"

  SecurityAdd csPrePNewEmpleadoEspecialidad, "Agregar Especialidad", "Personal"
  SecurityAdd csPrePDeleteEmpleadoEspecialidad, "Borrar Especialidad", "Personal"
  SecurityAdd csPrePEditEmpleadoEspecialidad, "Editar Especialidad", "Personal"
  SecurityAdd csPrePListEmpleadoEspecialidad, "Listar Especialidad", "Personal"

  SecurityAdd csPrePNewEmpleado, "Agregar Empleado", "Personal"
  SecurityAdd csPrePDeleteEmpleado, "Borrar Empleado", "Personal"
  SecurityAdd csPrePEditEmpleado, "Editar Empleado", "Personal"
  SecurityAdd csPrePListEmpleado, "Listar Empleado", "Personal"

  SecurityAdd csPrePNewEmpleadoART, "Agregar Aseguradora (ART)", "Personal"
  SecurityAdd csPrePDeleteEmpleadoART, "Borrar Aseguradora (ART)", "Personal"
  SecurityAdd csPrePEditEmpleadoART, "Editar Aseguradora (ART)", "Personal"
  SecurityAdd csPrePListEmpleadoART, "Listar Aseguradora (ART)", "Personal"

  SecurityAdd csPrePNewLiquidacionPlantilla, "Agregar Plantillas de Liquidación", "Personal"
  SecurityAdd csPrePDeleteLiquidacionPlantilla, "Borrar Plantillas de Liquidación", "Personal"
  SecurityAdd csPrePEditLiquidacionPlantilla, "Editar Plantillas de Liquidación", "Personal"
  SecurityAdd csPrePListLiquidacionPlantilla, "Listar Plantillas de Liquidación", "Personal"

  SecurityAdd csPrePNewLiquidacionFormula, "Agregar Formulas de Liquidación", "Personal"
  SecurityAdd csPrePDeleteLiquidacionFormula, "Borrar Formulas de Liquidación", "Personal"
  SecurityAdd csPrePEditLiquidacionFormula, "Editar Formulas de Liquidación", "Personal"
  SecurityAdd csPrePListLiquidacionFormula, "Listar Formulas de Liquidación", "Personal"

  SecurityAdd csPrePNewEmpleadoPeriodo, "Agregar Presentismo y Asistencia", "Personal"
  SecurityAdd csPrePDeleteEmpleadoPeriodo, "Borrar Presentismo y Asistencia", "Personal"
  SecurityAdd csPrePEditEmpleadoPeriodo, "Editar Presentismo y Asistencia", "Personal"
  SecurityAdd csPrePListEmpleadoPeriodo, "Listar Presentismo y Asistencia", "Personal"

  SecurityAdd csPrepNewEmpleadoAsistenciaTipo, "Agregar Tipo de Asistencia", "Personal"
  SecurityAdd csPrepDeleteEmpleadoAsistenciaTipo, "Borrar Tipo de Asistencia", "Personal"
  SecurityAdd csPrepEditEmpleadoAsistenciaTipo, "Editar Tipo de Asistencia", "Personal"
  SecurityAdd csPrepListEmpleadoAsistenciaTipo, "Listar Tipo de Asistencia", "Personal"

  SecurityAdd csPrepNewLiquidacion, "Agregar Liquidación de Haberes", "Personal"
  SecurityAdd csPrepEditLiquidacion, "Editar Liquidación de Haberes", "Personal"
  SecurityAdd csPrepDeleteLiquidacion, "Borrar Liquidación de Haberes", "Personal"
  SecurityAdd csPrepListLiquidacion, "Listar Liquidación de Haberes", "Personal"
  SecurityAdd csPrepDesAnularLiquidacion, "Des-anular Liquidación de Haberes", "Personal"
  SecurityAdd csPrepAnularLiquidacion, "Anular Liquidación de Haberes", "Personal"

  SecurityAdd csPrepNewLiquidacionCodigoTipo, "Agregar Tipo de Codigo de Liquidacion", "Personal"
  SecurityAdd csPrepDeleteLiquidacionCodigoTipo, "Borrar Tipo de Codigo de Liquidacion", "Personal"
  SecurityAdd csPrepEditLiquidacionCodigoTipo, "Editar Tipo de Codigo de Liquidacion", "Personal"
  SecurityAdd csPrepListLiquidacionCodigoTipo, "Listar Tipo de Codigo de Liquidacion", "Personal"

End Sub

' funciones privadas
' construccion - destruccion
