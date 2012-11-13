Attribute VB_Name = "mServiceLocal"
Option Explicit

'--------------------------------------------------------------------------------
' mServiceLocal
' 09-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mServiceLocal"

Public Const LOG_NAME = "\Log\CSCVXI.log"
Public Const LOG_NAME2 = "\Log\CSCVXI"

' estructuras
' variables privadas
' eventos
' propiedadades publicas
Public gLogTrafic As Boolean

Public gEmailServer       As String
Public gEmailAddress      As String
Public gEmailPort         As Long
Public gEmailUser         As String
Public gEmailPwd          As String

Public gClose             As Boolean

' propiedadades friend
' propiedades privadas
' funciones publicas

' Encode an string so that it can be displayed correctly
' inside the browser.
'
' Same effect as the Server.HTMLEncode method in ASP
Public Function HTMLEncode(ByVal Text As String) As String
    Dim i As Integer
    Dim acode As Integer
    Dim repl As String

    HTMLEncode = Text

    For i = Len(HTMLEncode) To 1 Step -1
        acode = Asc(Mid$(HTMLEncode, i, 1))
        Select Case acode
            ' No modifico el espacio pues no
            ' quiero que toque los espacios
            ' que estan dentro de html tags
            ' por ejemplo <a href=...
            ' quedaria como <a&nbsp;href=
            ' y esto falla en hotmail
            '
            'Case 32
            '    repl = "&nbsp;"
            Case 34
                repl = "&quot;"
            Case 38
                repl = "&amp;"
            Case 60
                repl = "&lt;"
            Case 62
                repl = "&gt;"
            Case 32 To 127
                ' don't touch alphanumeric chars
            Case Else
                repl = "&#" & CStr(acode) & ";"
        End Select
        If Len(repl) Then
            HTMLEncode = Left$(HTMLEncode, i - 1) & repl & Mid$(HTMLEncode, _
                i + 1)
            repl = ""
        End If
    Next
End Function

Public Function CreateObject(ByVal Class As String) As Object
  On Error GoTo ControlError
  Set CreateObject = Interaction.CreateObject(Class)
  Exit Function
ControlError:
  Err.Raise Err.Number, Err.Source, "No se pudo crear el objeto " & Class & ".\nError Original: " & Err.Description, Err.HelpFile, Err.HelpContext
End Function
' funciones friend
' funciones privadas
' construccion - destruccion

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next



