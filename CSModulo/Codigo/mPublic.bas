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

' nombre de la aplicacion
Public gAppName     As String
' funciones publicas
Public Function CreateObject(ByVal Class As String, Optional ByVal ServerName As String) As Object
  On Error GoTo ControlError
  
  If ServerName <> "" Then
    Set CreateObject = Interaction.CreateObject(Class, ServerName)
  Else
    Set CreateObject = Interaction.CreateObject(Class)
  End If
  
  Exit Function
ControlError:
  Dim Description As String
  Dim Number As Integer
  Dim Source As String
  Dim HelpFile As String
  Dim HelpContext As Long
  
  Number = Err.Number
  Source = Err.Source
  Description = "Error: no se pudo crear el objeto " & Class & " - " & ServerName & " - " & Err.Description
  HelpFile = Err.HelpFile
  HelpContext = Err.HelpContext
  
  If Err.Number <> 0 Then Resume RaiseError
RaiseError:
  
  On Error GoTo 0
  
  Err.Raise Number, Source, Description, HelpFile, HelpContext
End Function

' funciones privadas
' construccion - destruccion



