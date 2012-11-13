VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDeclarations"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cDeclarations
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
Public Enum csETablesPersonal
  
  csSindicato = 35001
  csSindicatoConvenio = 35002
  csSindicatoCategoria = 35003
  csEmpleadoEspecialidad = 35004
  csEmpleado = 35005
  csEmpleadoART = 35006
  csEstadoCivil = 35007
  csLiquidacionPlantilla = 35008
  csLiquidacionFormula = 35009
  csEmpleadoPeriodo = 35010
  csEmpleadoAsistenciaTipo = 35011
  csLiquidacion = 35012
  csLiquidacionFormulaItem = 35013
  csEmpleadoFamiliaTipo = 35014
  csLiquidacionCodigoTipo = 35015
  
End Enum

Public Enum csETipoLiquidacion
  csETL_Jornalizado = 1
  csETL_Mensualizado = 2
End Enum

Public Enum csETipoPeriodo
  csETP_Jornalizado = 1
  csETP_Mensualizado = 2
End Enum

' Grupos de Categorias de cuentas
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
' funciones privadas
' construccion - destruccion
