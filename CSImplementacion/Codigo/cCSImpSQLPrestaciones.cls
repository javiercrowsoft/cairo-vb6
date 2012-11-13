VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSImpSQLPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSImpSQLPrestaciones
' 14-02-2004

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

Public Enum csImpSQLPrestacion
  csPreImpSQLEditScripts = 21005
  csPreImpSQLEditTables = 21006
End Enum

Public Enum csMenuEnum
  csMenuMainImpSQL = 21999
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
  SecurityAdd csPreImpSQLEditScripts, "Editar Scripts SQL", "Implementacion"
  SecurityAdd csPreImpSQLEditTables, "Editar Tablas del Sistema", "Implementacion"
End Sub

' funciones privadas
' construccion - destruccion





