VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSAlmPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSAlarmaMailPrestaciones
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

Public Enum CSAlarmaMailPrestacion
  
  csPreANewAlarmaMail = 30001
  csPreAEditAlarmaMail = 30002
  csPreADeleteAlarmaMail = 30003
  csPreAListAlarmaMail = 30004
  
End Enum

Public Enum csMenuEnum
  csMenuConfig = 1000001
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
    
  SecurityAdd csPreANewAlarmaMail, "Agregar Alarma por Mail", "Alarma por Mail"
  SecurityAdd csPreADeleteAlarmaMail, "Borrar Alarma por Mail", "Alarma por Mail"
  SecurityAdd csPreAEditAlarmaMail, "Editar Alarma por Mail", "Alarma por Mail"
  SecurityAdd csPreAListAlarmaMail, "Listar Alarma por Mail", "Alarma por Mail"

End Sub

' funciones privadas
' construccion - destruccion





