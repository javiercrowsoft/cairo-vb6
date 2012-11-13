VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSApiculturaPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSApiculturaPrestaciones
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

Public Enum CSApiculturaPrestacion
  csPreANewAlsa = 11000
  csPreAEditAlsa = 11001
  csPreADeleteAlsa = 11002
  csPreAListAlsa = 11003
  
  csPreANewMedicamento = 11004
  csPreAEditMedicamento = 11005
  csPreADeleteMedicamento = 11006
  csPreAListMedicamento = 11007
  
  csPreANewReina = 11008
  csPreAEditReina = 11009
  csPreADeleteReina = 11010
  csPreAListReina = 11011
  
  csPreANewColmena = 11012
  csPreAEditColmena = 11013
  csPreADeleteColmena = 11014
  csPreAListColmena = 11015
End Enum

Public Enum csMenuEnum
  csMenuConfig = 1000001
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()

    SecurityAdd csPreANewColmena, "Agregar Colmena", "Colmena"
    SecurityAdd csPreADeleteColmena, "Borrar Colmena", "Colmena"
    SecurityAdd csPreAEditColmena, "Editar Colmena", "Colmena"
    SecurityAdd csPreAListColmena, "Listar Colmena", "Colmena"

    SecurityAdd csPreANewAlsa, "Agregar Alsa", "Alsa"
    SecurityAdd csPreADeleteAlsa, "Borrar Alsa", "Alsa"
    SecurityAdd csPreAEditAlsa, "Editar Alsa", "Alsa"
    SecurityAdd csPreAListAlsa, "Listar Alsa", "Alsa"
    
    SecurityAdd csPreANewMedicamento, "Agregar Medicamento", "Medicamento"
    SecurityAdd csPreADeleteMedicamento, "Borrar Medicamento", "Medicamento"
    SecurityAdd csPreAEditMedicamento, "Editar Medicamento", "Medicamento"
    SecurityAdd csPreAListMedicamento, "Listar Medicamento", "Medicamento"
    
    SecurityAdd csPreANewReina, "Agregar Reina", "Reina"
    SecurityAdd csPreADeleteReina, "Borrar Reina", "Reina"
    SecurityAdd csPreAEditReina, "Editar Reina", "Reina"
    SecurityAdd csPreAListReina, "Listar Reina", "Reina"
End Sub

' funciones privadas
' construccion - destruccion





