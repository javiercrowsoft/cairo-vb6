VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSChatClientInit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private Const C_Module = "cCSChatClientInit"

Public Function IsConnected() As Boolean
  If fMain.Client Is Nothing Then Exit Function
  IsConnected = fMain.Client.ConnectStatus = csSocketOpen
End Function

Public Function Connect(ByVal db_id As Long, _
                        ByVal emp_id As Long, _
                        ByVal User As String, _
                        ByVal pwd As String, _
                        ByVal CallerId As Long, _
                        ByVal SessionKey As String, _
                        ByVal TempId As Long, _
                        ByVal Server As String, _
                        ByVal Port As Long) As Boolean
  
  On Error GoTo ControlError
  
  'MsgBox "server " & Server & " port " & Port
  
  ' Si ya estoy conectado verifico
  ' que se trate del mismo usuario
  '
  If Not fMain.Client Is Nothing Then
  
    ' Si no estoy conectado no hago nada
    '
    If fMain.Client.ConnectStatus = csSocketOpen Then
  
      ' Si el usuario no es el mismo
      ' inicio una instancia nueva del cliente
      ' de chat y le informo a Cairo que elimine
      ' la referncia a este objeto, devolviendo false
      '
      ' Este caso NO deberia darce nunca pero como
      ' para debuger lo necesio, y no quise
      ' modificar todo el cliente de chat para
      ' que una misma instancia soporte dos usuario
      ' hago este pequeño truco, que no es elegante
      ' pero no me complica tanto
      '
      If UCase$(fMain.txUser.Text) <> UCase$(User) Then
      
        pLaunchChatClient db_id, emp_id, User, pwd, _
                          Server, Port, _
                          CallerId, SessionKey, TempId
        Connect = False ' Con esto Cairo elimina la referencia
        Exit Function
      End If
  
    Else
      
      If Not pConnect(User, pwd, db_id, emp_id, Server, Port) Then
        Connect = False ' Con esto Cairo elimina la referencia
        Exit Function
      End If
    End If
    
  ' Si no estoy conectado
  ' me conecto
  '
  Else
  
    If Not pConnect(User, pwd, db_id, emp_id, Server, Port) Then
    
      Connect = False ' Con esto Cairo elimina la referencia
      Exit Function
      
    End If
  
  End If
  
  ' Si llegue hasta aca es por
  ' que me pude conectar o ya estaba
  ' conectado y Cairo me avisa que
  ' tengo que habrir una sesion de chat
  '
  If CallerId Then
    AcceptChat CallerId, SessionKey, TempId
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "Connect", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub pLaunchChatClient(ByVal db_id As Long, _
                              ByVal emp_id As Long, _
                              ByVal User As String, _
                              ByVal pwd As String, _
                              ByVal Server As String, _
                              ByVal Port As Long, _
                              ByVal CallerId As Long, _
                              ByVal SessionKey As String, _
                              ByVal TempId As Long)
                              
  ShellExecute "D:\proyectos\DLL - OCX - EXE\CSChatClient.exe " & _
                 c_login & "=1;" & _
                 c_user & "=" & User & ";" & _
                 c_password & "=" & pwd & ";" & _
                 c_db_id & "=" & db_id & ";" & _
                 c_emp_id & "=" & emp_id & ";" & _
                 c_server & "=" & Server & ";" & _
                 c_port & "=" & Port & ";" & _
                 c_callerId & "=" & CallerId & ";" & _
                 c_sessionKey & "=" & SessionKey & ";" & _
                 c_tempId & "=" & TempId & ";", _
               vbNormalFocus
End Sub

Private Function pConnect(ByVal User As String, _
                          ByVal pwd As String, _
                          ByVal db_id As Long, _
                          ByVal emp_id As Long, _
                          ByVal Server As String, _
                          ByVal Port As Long) As Boolean
  
  fMain.txUser.Text = User
  fMain.txPassword.Text = pwd
  
  If Not mLogin.ConnectChat(0, vbNullString, 0, _
                            db_id, emp_id, Server, Port) Then
    Exit Function
  End If

  fMain.ShowContacts

  pConnect = True
End Function
