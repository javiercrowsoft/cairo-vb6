Attribute VB_Name = "mPublic"
Option Explicit

'--------------------------------------------------------------------------------
' mPublic
' 23-03-02

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
' variables publicas

' Base de datos
Public gDB          As cDataBase

' nombre de la Aplication
Public gAppName     As String

' Funciones publicas
Public Function GetValidPath(ByVal Path As String)
  Path = Trim(Path)
  If Right$(Path, 1) <> "\" Then
    Path = Path & "\"
  End If
  GetValidPath = Path
End Function
' funciones privadas
' construccion - destruccion




