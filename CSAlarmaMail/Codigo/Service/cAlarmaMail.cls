VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAlarmaMail"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cAlarmaMail
' 01-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' Interfaces
Implements cIService

' constantes
Private Const C_Module = "cAlarmaMail"

' Configuracion
Private Const csTConfiguracion                         As String = "Configuracion"
Private Const cscCfgGrupo                              As String = "cfg_grupo"
Private Const cscCfgAspecto                            As String = "cfg_aspecto"
Private Const cscCfgValor                              As String = "cfg_valor"

' estructuras
' variables privadas
Private m_ServiceID           As Long
Private m_Server              As cIServer
Private m_db                  As cDataSource

Private m_logFile             As String
Private m_bInProcess          As Boolean
Private WithEvents m_Timer    As cTimer
Attribute m_Timer.VB_VarHelpID = -1

' eventos
' propiedadades publicas
Private Property Let cIService_ServiceID(ByVal rhs As Long)
  m_ServiceID = rhs
End Property

Private Property Get cIService_ServiceID() As Long
  cIService_ServiceID = m_ServiceID
End Property

Private Property Set cIService_Server(rhs As CSIService.cIServer)
  Set m_Server = rhs
End Property

Private Property Get cIService_Server() As CSIService.cIServer
  Set cIService_Server = m_Server
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub cIService_ClientShutDown(ByVal ClientId As Long)
  
End Sub

Private Sub cIService_WndProc(ByVal ClientId As Long, Message() As Byte, Response() As Byte)
  On Error GoTo ControlError

  Dim sMessage          As String
  Dim ErrDescription    As String
  
  m_Server.ByteArrayToString sMessage, Message
  
  Select Case TCPGetTypeMessage(sMessage)
    
    Case Else
            
      ' No esta implementado
  
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIService_WndProc", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
  m_Server.StringToByteArray c_ErrorCode & gErrorInfo, Response
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetDataBaseInfo( _
                                ByVal bd_id As Long, _
                                ByRef Database As String, _
                                ByRef SqlLogin As String, _
                                ByRef SqlPassw As String, _
                                ByRef Server As String, _
                                ByRef UseNTSecurity As Integer _
                                ) As Boolean
                                
  Dim Encrypt As cEncrypt
  Set Encrypt = New cEncrypt
                                
  If Not pGetDBData(bd_id, "bd_login", SqlLogin) Then Exit Function
  If Not pGetDBData(bd_id, "bd_pwd", SqlPassw) Then Exit Function
  If Not pGetDBData(bd_id, "bd_server", Server) Then Exit Function
  If Not pGetDBData(bd_id, "bd_nombre", Database) Then Exit Function
  If Not pGetDBData(bd_id, "bd_securitytype", UseNTSecurity) Then Exit Function

  SqlLogin = Encrypt.Decript(SqlLogin, c_LoginSignature)
  SqlPassw = Encrypt.Decript(SqlPassw, c_LoginSignature)
  Server = Encrypt.Decript(Server, c_LoginSignature)
  Database = Encrypt.Decript(Database, c_LoginSignature)

  pGetDataBaseInfo = True

End Function

Private Function pGetDataBases(ByRef rs As ADODB.Recordset) As Boolean
  On Error GoTo ControlError

  Dim sqlstmt As String
  
  sqlstmt = "select * from basedatos"
  
  If Not m_db.OpenRs(rs, sqlstmt) Then
    GoTo ExitProc
  End If

  pGetDataBases = True

  GoTo ExitProc
ControlError:
  MngError Err, "pGetDataBases", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pGetDBData(ByVal bd_id As Long, ByVal Field As String, ByRef rtn As Variant) As Boolean
  pGetDBData = m_db.GetData("BaseDatos", "bd_id", bd_id, Field, rtn)
End Function

Private Function pRemoveLastSep(ByVal sMessage As String) As String
  If Right$(sMessage, 1) = c_TCPSep2 Then sMessage = Left$(sMessage, Len(sMessage) - 1)
  pRemoveLastSep = sMessage
End Function

Private Sub pOpenDB()
  On Error GoTo ControlError

  Dim Server    As String
  Dim Database  As String
  Dim User      As String
  Dim Password  As String
  Dim TrustedConnection As Boolean
  
  Server = IniGet(c_k_Server, "(Local)")
  Database = IniGet(c_k_DataBase, "Master")
  User = IniGet(c_k_User, "sa")
  Password = IniGet(c_k_Password, "")
  TrustedConnection = IniGet(c_k_TrustedConnection, "0")
  
  m_db.OpenConnection Server, Database, User, Password, TrustedConnection

  GoTo ExitProc
ControlError:
  MngError Err, "pOpenDB", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pProcess()
  
  Dim rs As ADODB.Recordset
  
  pSaveLog "Cargando Bases ..."
    
  If Not pGetDataBases(rs) Then
    pSaveLog "La carga de las bases fallo"
    Exit Sub
  End If
  
  pSaveLog "Creando Objeto de Encriptación"
  
  Dim Encrypt As cEncrypt
  Set Encrypt = New cEncrypt
  
  pSaveLog "Recorriendo las bases"
  
  Dim Server          As String
  Dim Database        As String
  Dim User            As String
  Dim Pwd             As String
  Dim UseNTSecurity   As Boolean
  
  While Not rs.EOF
    
    Server = Encrypt.Decript(m_db.ValField(rs.Fields.Item("bd_server")), c_LoginSignature)
    Database = Encrypt.Decript(m_db.ValField(rs.Fields.Item("bd_nombre")), c_LoginSignature)
    User = Encrypt.Decript(m_db.ValField(rs.Fields.Item("bd_login")), c_LoginSignature)
    Pwd = Encrypt.Decript(m_db.ValField(rs.Fields.Item("bd_pwd")), c_LoginSignature)
    UseNTSecurity = Val(Encrypt.Decript(m_db.ValField(rs.Fields.Item("bd_securitytype")), c_LoginSignature))
    
    pSaveLog "Configurando Email para: [" & Server & "] - [" & Database & "]"
    
    If Not pSetEmail(Server, _
                     Database, _
                     User, _
                     Pwd, _
                     UseNTSecurity) Then
      
      pSaveLog "La configuracion del Email fallo"
    
    Else
  
      pSaveLog "Procesando Alarmas para: [" & Server & "] - [" & Database & "]"
  
      pSendEmails Server, Database, User, Pwd, UseNTSecurity
    
    End If
    
    rs.MoveNext
    
  Wend
  
End Sub

Private Function pSendEmails(ByVal Server As String, ByVal Database As String, _
                             ByVal User As String, ByVal Password As String, _
                             ByVal UseNTSecurity As Boolean) As Boolean
  Dim sqlstmt As String
  Dim db      As cDataSource
  Dim rs      As ADODB.Recordset
  Dim alm_id  As Long

  pSaveLog "Cargando alaramas para " & Server & " - " & _
                                       Database & " - " & _
                                       User & _
                                       " - NT " & _
                                       IIf(UseNTSecurity, "Si", "No")
  
  Set db = New cDataSource
  If Not db.OpenConnection(Server, _
                           Database, _
                           User, _
                           Password, _
                           UseNTSecurity, _
                           vbNullString) Then Exit Function
  
  sqlstmt = "select * from AlarmaMail where activo <> 0 and alm_mails <> '' and alm_nextrun <= getdate()"

  If Not db.OpenRs(rs, sqlstmt) Then
    pSaveLog "Obtener Alarmas Fallo"
    Exit Function
  End If
  
  pSaveLog "Alarmas cargadas con éxito"
  
  If rs.EOF Then
    pSaveLog "No hay alarmas definidas"
  End If
  
  While Not rs.EOF
  
    pSaveLog "Procesando Alarma: " & db.ValField(rs.Fields.Item("alm_nombre"))
  
    pProcessAlarma db, _
                   db.ValField(rs.Fields.Item("alm_scriptmails")), _
                   db.ValField(rs.Fields.Item("alm_scriptresult")), _
                   db.ValField(rs.Fields.Item("alm_object")), _
                   db.ValField(rs.Fields.Item("alm_mails"))
                   
    pSaveLog "Actualizando NextRun: " & db.ValField(rs.Fields.Item("alm_nombre"))
                   
    alm_id = db.ValField(rs.Fields.Item("alm_id"))
    sqlstmt = "update AlarmaMail set alm_nextrun = dateadd(n,alm_frecuencia,getdate()) where alm_id = " & alm_id
    db.Execute sqlstmt, vbNullString
    
    rs.MoveNext
  Wend
  
  pSendEmails = True
  
End Function

Private Function pProcessAlarma(ByRef db As cDataSource, _
                                ByVal scriptmails As String, _
                                ByVal scriptresult As String, _
                                ByVal strObject As String, _
                                ByVal mails_aux As String) As Boolean
  Dim Obj       As Object
  Dim subject   As String
  Dim mails     As String
  Dim rs        As ADODB.Recordset
  Dim sqlstmt   As String

  Const subject_aux = "CrowSoft Cairo - Alarma Automatica"
  
  If LenB(strObject) Then
    
    pSaveLog "Creando Objeto: " & strObject
    
    Set Obj = CreateObject(strObject)
    
    If Not Obj.GetMails(rs) Then
      pSaveLog "El metodo GetMails del objeto " & strObject & " Fallo"
      Exit Function
    End If
  
  ElseIf LenB(scriptmails) Then
    
    pSaveLog "Ejecutando Script: " & scriptmails
    
    sqlstmt = scriptmails
  
    If Not db.OpenRs(rs, sqlstmt) Then
      pSaveLog "El Script " & scriptmails & " Fallo"
      Exit Function
    End If
    
    While Not rs.EOF
    
      mails = pSetEmailToFromSP(rs, mails_aux)
      subject = pSetEmailSubjectFromSP(rs, subject_aux)
    
      pSaveLog "Enviando el email"
      
      If pSendEmail(mails, _
                    subject, _
                    db.ValField(rs.Fields.Item("msg"))) Then
      
        If LenB(strObject) Then
        
          Obj.DoResult db.ValField(rs.Fields.Item("almr_id_mail")), _
                       db.ValField(rs.Fields.Item("mail_id")), _
                       db.ValField(rs.Fields.Item("maili_id"))
        
        Else
      
          pSaveLog "Actualizando con script: " & scriptresult
          sqlstmt = scriptresult & " " & db.ValField(rs.Fields.Item("almr_id_mail")) & "," _
                                       & db.ValField(rs.Fields.Item("mail_id")) & "," _
                                       & db.ValField(rs.Fields.Item("maili_id"))
          
          db.Execute sqlstmt, vbNullString
        
        End If
        
      Else
        
        pSaveLog "El email fallo"
        
      End If
    
      rs.MoveNext
    Wend
    
  End If
  
  pProcessAlarma = True
End Function

Private Function pSetEmailSubjectFromSP(ByRef rs As ADODB.Recordset, _
                                        ByVal default As String) As String
  
  Const c_email = "almr_subject"
  
  Dim fld As ADODB.Field
  
  pSetEmailSubjectFromSP = default
  
  For Each fld In rs.Fields
    If LCase$(fld.Name) = c_email Then
      If Not IsNull(fld.Value) Then
        If LenB(fld.Value) Then
          pSetEmailSubjectFromSP = fld.Value
        End If
        Exit For
      End If
    End If
  Next
End Function

Private Function pSetEmailToFromSP(ByRef rs As ADODB.Recordset, _
                                   ByVal default As String) As String
  
  Const c_email = "almr_emailto"
  
  Dim fld As ADODB.Field
  
  pSetEmailToFromSP = default
  
  For Each fld In rs.Fields
    If LCase$(fld.Name) = c_email Then
      If Not IsNull(fld.Value) Then
        If LenB(fld.Value) Then
          pSetEmailToFromSP = fld.Value
        End If
        Exit For
      End If
    End If
  Next
End Function

Private Function pSendEmail(ByVal addressTo As String, _
                            ByVal subject As String, _
                            ByVal Message As String) As Boolean

  pSaveLog "Creando Objeto de Email"
  
  Dim Mail As Object
  Set Mail = CreateObject("CSMail.cMail")
  
  Dim body   As String
  
  body = Message
  
  Dim vAddressTo As Variant
  Dim i          As Long
  
  addressTo = Replace(addressTo, ";", ",")
  vAddressTo = Split(addressTo, ",")
  
  For i = 0 To UBound(vAddressTo)
  
    If Mail.SendEmail(vAddressTo(i), _
                      gEmailAddress, _
                      gEmailAddress, _
                      gEmailServer, _
                      gEmailPort, _
                      gEmailUser, _
                      gEmailPwd, subject, body) Then
      pSaveLog "El mail se envio con éxito"
    Else
      pSaveLog "El mail fallo " & Mail.errNumber & " - " & Mail.ErrDescrip
      Exit Function
    End If
    
  Next
  
  pSendEmail = True
End Function

Private Sub m_Timer_ThatTime()
  On Error GoTo ControlError
  
  If m_bInProcess Then Exit Sub
  
  m_bInProcess = True
  
  pSaveLog "Procesando Timer ..."
  
  pProcess

  GoTo ExitProc
ControlError:
  MngError Err, "m_Timer_ThatTime", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  m_bInProcess = False
  pSaveLog "Fin Procesando Timer ..."
End Sub

Private Function pSetEmail(ByVal Server As String, ByVal Database As String, _
                           ByVal User As String, ByVal Password As String, _
                           ByVal UseNTSecurity As Boolean) As Boolean
  On Error GoTo ControlError
  
  Const c_GrupoGeneral = "General"
  Const c_EmailServer = "Email Server"
  Const c_EmailPort = "Email Port"
  Const c_EmailUser = "Email User"
  Const c_EmailPwd = "Email Pwd"
  Const c_EmailAddress = "Email Address"
  
  Dim sqlstmt As String
  Dim db      As cDataSource
  Dim rs      As ADODB.Recordset

  Set db = New cDataSource
  If Not db.OpenConnection(Server, _
                           Database, _
                           User, _
                           Password, _
                           UseNTSecurity, _
                           vbNullString) Then Exit Function
  
  sqlstmt = "select * from configuracion where cfg_grupo = " & db.sqlString(c_GrupoGeneral)
  If Not db.OpenRs(rs, sqlstmt) Then Exit Function
  
  Dim EmailServer          As String
  Dim EmailPort            As Long
  Dim EmailUser            As String
  Dim EmailPwd             As String
  Dim EmailAddress         As String

  EmailServer = ""
  EmailPort = 25
  EmailUser = ""
  EmailPwd = ""
  EmailAddress = ""

  While Not rs.EOF
    Select Case db.ValField(rs.Fields(cscCfgAspecto))
      Case c_EmailServer
        EmailServer = db.ValField(rs.Fields.Item(cscCfgValor))
      Case c_EmailPort
        EmailPort = Val(db.ValField(rs.Fields.Item(cscCfgValor)))
      Case c_EmailUser
        EmailUser = db.ValField(rs.Fields.Item(cscCfgValor))
      Case c_EmailPwd
        EmailPwd = db.ValField(rs.Fields.Item(cscCfgValor))
      Case c_EmailAddress
        EmailAddress = db.ValField(rs.Fields.Item(cscCfgValor))
    End Select
    
    rs.MoveNext
  Wend
  
  gEmailAddress = EmailAddress
  gEmailPort = EmailPort
  gEmailPwd = EmailPwd
  gEmailServer = EmailServer
  gEmailUser = EmailUser
  
  pSaveLog "Email-Address: " & gEmailAddress
  pSaveLog "Email-Server : " & gEmailServer
  pSaveLog "Email-Port   : " & gEmailPort
  pSaveLog "Email-User   : " & gEmailUser
  'pSaveLog "Email-PWD    : " & gEmailPwd
  
  pSaveLog "LenB   : " & LenB(gEmailAddress) * _
              LenB(gEmailServer) * _
              LenB(gEmailUser) * _
              LenB(gEmailPwd)
  
  If (LenB(gEmailUser) * _
      LenB(gEmailPwd)) = 0 Then
    pSaveLog "Advertencia: El usuario y la clave de email estan en blanco"
  End If
  
  pSetEmail = LenB(gEmailAddress) * _
              LenB(gEmailServer)
  
  GoTo ExitProc
ControlError:
  MngError Err, "pSetEmail", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  m_ServiceID = SRV_ID_ALARMAMAIL

  m_logFile = IniGet(c_k_Log, pGetPath(App.Path) & "Log\CSAlarmaMail.log")

  pSaveLog "Server AlarmaMail Start"

  Set m_Timer = New cTimer
  m_Timer.Interval = Val(IniGet(c_k_interval, 3000))
  
  pSaveLog "Interval: " & m_Timer.Interval
  
  Set m_Server = gServer
  gServiceCreated = True
  
  Set m_db = New cDataSource
  pOpenDB

  pSaveLog "Initialize Complete Successfully"

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  pSaveLog "Server AlarmaMail Stop"
  
  Set m_Server = Nothing
  gServiceCreated = False
  
  Set m_db = Nothing
  Set m_Timer = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pSaveLog(ByVal msg As String)
  On Error Resume Next
  Dim f As Integer
  f = FreeFile
  Open m_logFile For Append As f
  Print #f, Format(Now, "dd/mm/yy hh:nn:ss   ") & msg
  Close f
End Sub

Private Function pGetPath(ByVal Path As String) As String
  If Right(Path, 1) <> "\" Then Path = Path & "\"
  pGetPath = Path
End Function

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
