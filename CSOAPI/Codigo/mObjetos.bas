Attribute VB_Name = "mObjects"
Option Explicit

'--------------------------------------------------------------------------------
' mObjects
' 27-12-99

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

' La clase login crea el objeto cUsuario referenciado por esta variable
Public gUser        As cUsuario

' La clase login crea el objeto cDataBase referenciado por esta variable
Public gDB          As cDataBase

' Nombre de la aplicacion
Public gAppName     As String

' Manejador global de seguridad
Public gSecurity    As cSecurity_

' Para comunicarce con el server
Public gTCPClient   As cTCPIPClient

' Id de la instancia TCP
Public gClientProcessId   As Long

' Empresa
Public gEmpId       As Long
Public gEmpNombre   As String

' Base de datos en cairo_dominio
Public gBdId        As Long

' Version de la base de datos
Public gBdVersion   As String

' Preferencias del Usuario
Public gAutoSizeCols    As Boolean

' Flag para saber que estamos en el proceso
' de creacion de menus

Public gStarting        As Boolean

' funciones privadas
' construccion - destruccion
