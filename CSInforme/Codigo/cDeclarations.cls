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
Public Enum csETablesInforme
  csTblInforme = 7001
End Enum

Public Enum csEInfParamType
  csInfParamDate = 1
  csInfParamHelp = 2
  csInfParamNumeric = 3
  csInfParamSqlstmt = 4
  csInfParamText = 5
  csInfParamList = 6
  csInfParamCheck = 7
End Enum

Public Enum csEInfShowDef
 csInfShowDefReport = 1
 csInfShowDefGrid = 2
 csInfShowDefChart = 3
 csInfShowDefHtml = 4
 csInfShowDefExcel = 5
 csInfShowDefWord = 6
 csInfShowDefTxt = 7
End Enum

Public Enum csEInfType
 csInfTypeReport = 1
 csInfTypeProcess = 2
End Enum

Public Enum csEInfOwner
  csInfOwnerCairoDevelop = 1
  csInfOwnerCairoImplement = 2
  csInfOwnerOthersDevelop = 3
  csInfOwnerOthersImplement = 4
  csInfOwnerCustomers = 5
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



