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
' 24-03-02

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Public Enum csETablesProduccion
  csMaquina = 13001
  csProductoBOM = 13002
  csProductoBOMTipo = 13003
End Enum

Public Enum csEBOMVarTipo
  csEBOMVT_Unit = 1
  csEBOMVT_Percent = 2
End Enum

Public Enum cscEBOMInsumoTipo
  csEBOMIT_Normal = 1
  csEBOMIT_phantoms = 2
  csEBOMIT_pseudos = 3
  csEBOMIT_Options = 4
  csEBOMIT_Reference = 5
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



