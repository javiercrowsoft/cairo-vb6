VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSCDTekaPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSCDTekaPrestaciones
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

Public Enum csCDTekaPrestacion
  csPreCDNewCDRom = 5001
  csPreCDEditCDRom = 5002
  csPreCDDeleteCDRom = 5003
  csPreCDListCDRom = 5004
  csPreCDSearchCDRom = 5005
End Enum

Public Enum csCDMenuEnum
  csCDMenuConfig = 5001
  csCDMenuList = 5002
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
  SecurityAdd csPreCDNewCDRom, "Agregar CDRom", "CDRom"
  SecurityAdd csPreCDDeleteCDRom, "Borrar CDRom", "CDRom"
  SecurityAdd csPreCDEditCDRom, "Editar CDRom", "CDRom"
  SecurityAdd csPreCDListCDRom, "Listar CDRom", "CDRom"
  SecurityAdd csPreCDSearchCDRom, "Buscar CDRom", "CDRom"
End Sub

' funciones privadas
' construccion - destruccion





