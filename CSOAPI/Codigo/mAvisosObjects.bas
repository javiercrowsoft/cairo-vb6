Attribute VB_Name = "mAvisosObjects"
Option Explicit

'--------------------------------------------------------------------------------
' mAvisosObjects
' 27-11-04

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
' variables privadas

' La clase login crea el objeto cDataBase referenciado por esta variable
Public gDB          As cDataBase

' Para comunicarce con el server
Public gTCPClient   As cTCPIPClient

' Id de la instancia TCP
Public gClientProcessId   As Long

' Para manejar avisos
Public gMngAvisos   As cMngAvisos_

' Nombre de la aplicacion
Public gAppName     As String

' funciones privadas
' construccion - destruccion


