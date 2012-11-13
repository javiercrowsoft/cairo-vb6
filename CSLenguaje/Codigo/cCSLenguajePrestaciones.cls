VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSLenguajePrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSLenguajePrestaciones
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

Public Enum csLenguajePrestacion
  csPreLengNewLenguaje = 14001
  csPreLengEditLenguaje = 14002
  csPreLengDeleteLenguaje = 14003
  csPreLengListLenguaje = 14004
End Enum

Public Enum csMenuEnum
  csMenuConfig = 14000
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
  SecurityAdd csPreLengNewLenguaje, "Agregar Lenguaje", "Lenguaje"
  SecurityAdd csPreLengDeleteLenguaje, "Borrar Lenguaje", "Lenguaje"
  SecurityAdd csPreLengEditLenguaje, "Editar Lenguaje", "Lenguaje"
  SecurityAdd csPreLengListLenguaje, "Listar Lenguaje", "Lenguaje"
End Sub

' funciones privadas
' construccion - destruccion





