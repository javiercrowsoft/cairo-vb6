Attribute VB_Name = "mMain"
Option Explicit

Private Const C_Module = "mMain"

Public gLogFile As String

' 1 Obtener parametros
' 2 Conectarce con la base
' 3 Ejecutar el archivo

Public Sub Main()
  On Error GoTo ControlError
  
  Dim server      As String
  Dim database    As String
  Dim user        As String
  Dim password    As String
  Dim File        As String
  Dim logFile     As String
  
  If Not pGetParams(server, database, user, password, File, logFile) Then
    LogError "Los parametros no son validos"
    Exit Sub
  End If
  
  gLogFile = logFile
  
  SaveLog "/////////////////////////////////////////////////////////////"
  SaveLog "Iniciando ejecucion de scripts"
  SaveLog "Parametros recibidos: "
  SaveLog "Server: " & server
  SaveLog "Usuario: " & user
  SaveLog "Base: " & database
  SaveLog "Archivo sql: " & File
  SaveLog "Archivo de log: " & logFile
  
  Dim work As cWork
  Set work = New cWork
  
  work.Run server, database, user, password, File, logFile
  
  Exit Sub
ControlError:
  MngError err, "Main", C_Module, ""
End Sub

Public Sub LogError(ByVal msg As String)

End Sub

Private Function pGetParams(ByRef server As String, _
                            ByRef database As String, _
                            ByRef user As String, _
                            ByRef password As String, _
                            ByRef File As String, _
                            ByRef logFile As String) As Boolean
  Dim params    As String
  Dim vParams() As String
  
  params = Command$()
  vParams = Split(params, " ")
                        
  server = pGetParam(vParams, "-S")
  user = pGetParam(vParams, "-U")
  password = pGetParam(vParams, "-P")
  database = pGetParam(vParams, "-d")
  File = pGetParam(vParams, "-i")
  logFile = pGetParam(vParams, "-o")
  
                        
  pGetParams = True
End Function

Private Function pGetParam(ByRef vParams() As String, ByVal paramName As String) As String
  Dim rtn As String
  Dim i   As Integer
  
  For i = 0 To UBound(vParams)
    If vParams(i) = paramName Then
    
      If Not isParam(vParams(i + 1)) Then
        rtn = vParams(i + 1)
      End If
      Exit For
    End If
  Next
  pGetParam = rtn
End Function

Private Function isParam(ByVal value As String) As Boolean
  isParam = InStr(1, "-d -S -U -P -i -o", value)
End Function

Public Sub sbMsg(ByVal msg As String)
  SaveLog msg
End Sub

Public Sub ShowProgress(ByVal percent As Double)

End Sub

Public Sub MngError(ByRef err As Object, ByVal functionName As String, ByVal Module As String, ByVal infoAdd As String)
  SaveLog Module & "." & functionName & "- info: " & infoAdd & " - " & err.Description
End Sub

Public Sub MsgWarning(ByVal msg As String)
  SaveLog msg
End Sub

Public Sub MsgInfo(ByVal msg As String)
  SaveLog msg
End Sub

Public Sub SaveLog(ByVal Message As String)
  On Error Resume Next
  Dim f As Integer
  f = FreeFile
  Open gLogFile For Append Access Write Shared As #f
  Message = Format(Now, "dd/mm/yy hh:nn:ss   ") & Message
  Print #f, Message
  Close f
End Sub

