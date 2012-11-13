Attribute VB_Name = "mMain"
Option Explicit

Private Const C_Module = "mMain"

Public gLogFile As String

' 1 Obtener parametros
' 2 Conectarce con la base
' 3 Ejecutar el archivo

Public Sub Main()
  On Error GoTo ControlError
  
  Dim Server      As String
  Dim DataBase    As String
  Dim User        As String
  Dim Password    As String
  Dim File        As String
  Dim LogFile     As String
  Dim bEncryptAll As Boolean
  
  If Not pGetParams(Server, DataBase, User, Password, File, LogFile, bEncryptAll) Then
    LogError "Los parametros no son validos", "Main", C_Module, ""
    Exit Sub
  End If
  
  gLogFile = LogFile
  
  SaveLog "/////////////////////////////////////////////////////////////"
  SaveLog "Iniciando ejecucion de scripts"
  SaveLog "Parametros recibidos: "
  SaveLog "Server: " & Server
  SaveLog "Usuario: " & User
  SaveLog "Base: " & DataBase
  SaveLog "Archivo sql: " & File
  SaveLog "Archivo de log: " & LogFile
  
  Dim work As cWork
  Set work = New cWork
  
  work.Run Server, DataBase, User, Password, File, LogFile, bEncryptAll
  
  SaveLog "Ejecucion de scripts finalizada"
  SaveLog "/////////////////////////////////////////////////////////////"
  
  Exit Sub
ControlError:
  MngError Err, "Main", C_Module, ""
End Sub

Public Sub LogError(ByVal Msg As String, ByVal functionName As String, ByVal Module As String, ByVal infoAdd As String)

  If Err.Number Or gLastError Then

    If Err.Number Then
      gLastErrorDescrip = Err.Description
      gLastError = Err.Number
    End If
    MsgBox "Function: " + functionName + vbCrLf + "Modulo: " + Module + vbCrLf + vbCrLf + pGetErr(gLastErrorDescrip) + vbCrLf + infoAdd, vbCritical
    
    SaveLog "Error -----------------------------------"
    SaveLog Msg
    SaveLog gLastError & gLastErrorDescrip
    SaveLog "Fin Error -------------------------------"
  
    gLastErrorDescrip = ""
    gLastError = 0
  
  End If
End Sub

Private Function pGetParams(ByRef Server As String, _
                            ByRef DataBase As String, _
                            ByRef User As String, _
                            ByRef Password As String, _
                            ByRef File As String, _
                            ByRef LogFile As String, _
                            ByRef bEncryptAll As Boolean) As Boolean
  Dim params    As String
  Dim vParams() As String
  
  params = Command$()
  vParams = Split(params, " ")
                        
  Server = pGetParam(vParams, "-S")
  User = pGetParam(vParams, "-U")
  Password = pGetParam(vParams, "-P")
  DataBase = pGetParam(vParams, "-d")
  File = pGetParam(vParams, "-i")
  LogFile = pGetParam(vParams, "-o")
  
  ' Encriptar todos los sp
  '
  Dim i As Integer
  bEncryptAll = False
  
  ' Si el parametro es mencionado
  ' se encriptan todos los sp
  ' la sintaxis no es -all ? sino -all
  '
  For i = 0 To UBound(vParams)
    If LCase(vParams(i)) = "-all" Then
      bEncryptAll = True
      Exit For
    End If
  Next
  
  ' Si desean usar la sintaxis -all ? descomentar
  ' Ojo: Es case sensitive
  ' debe ser -all no -All o -ALL o -aLL
  '
  ' bEncryptAll = Val(LCase(pGetParams(vParams, "-all")) = "s")
                        
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

Public Sub sbMsg(ByVal Msg As String)
  SaveLog Msg
End Sub

Public Sub ShowProgress(ByVal Percent As Double)

End Sub

Public Sub MngError(ByRef Err As Object, ByVal functionName As String, ByVal Module As String, ByVal infoAdd As String)
  
  If Err.Number = 0 Then Exit Sub
  gLastError = Err.Number
  MsgBox "Function: " + functionName + vbCrLf + "Modulo: " + Module + vbCrLf + vbCrLf + pGetErr(Err.Description) + vbCrLf + infoAdd, vbCritical
  
  SaveLog Module & "." & functionName & "- info: " & infoAdd & " - " & Err.Description
End Sub

Public Sub MsgWarning(ByVal Msg As String)
  SaveLog Msg
End Sub

Public Sub MsgInfo(ByVal Msg As String)
  SaveLog Msg
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

Private Function pGetErr(ByVal Descript As String) As String
  Descript = Replace(Descript, "[Microsoft]", "")
  Descript = Replace(Descript, "[ODBC SQL Server Driver]", "")
  Descript = Replace(Descript, "[Shared Memory]", "")
  Descript = Replace(Descript, "[DBNETLIB]", "")
  
  pGetErr = Descript
End Function

