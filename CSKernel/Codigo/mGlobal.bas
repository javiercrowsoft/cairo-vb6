Attribute VB_Name = "mGlobal"
Option Explicit

'--------------------------------------------------------------------------------
' mGlobal
' 10-06-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' Funciones

'--------------------------------------------------------------------------------

' constantes
' estructuras
' variables privadas
' propiedades publicas
Public gWindow            As New cWindow
Public gAppName           As String
Public gAppPath           As String
Public gDefaultHelpFile   As String

Public gErrorDB           As String

' Para enviar el email por errores
'
Public gEmailServer       As String
Public gEmailAddress      As String
Public gEmailPort         As Long
Public gEmailUser         As String
Public gEmailPwd          As String

Public gEmailErrDescrip   As String

Public G_FormResult     As Boolean
Public G_InputValue     As String   ' Usada por fEditar para devolver el resultado.

Public gNoChangeMouseCursor As Boolean

' propiedades privadas
' Funciones publicas

