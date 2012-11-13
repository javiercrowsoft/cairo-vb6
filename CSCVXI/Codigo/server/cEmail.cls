VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cEmail"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cEmail
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
Private Const C_Module = "cEmail"

' Configuracion
Private Const csTConfiguracion                         As String = "Configuracion"
Private Const cscCfgGrupo                              As String = "cfg_grupo"
Private Const cscCfgAspecto                            As String = "cfg_aspecto"
Private Const cscCfgValor                              As String = "cfg_valor"

' XML Soap commands
Private Const cmdGetMails = _
    "<?xml version=""1.0"" encoding=""ISO-8859-1""?>" & _
    "<SOAP-ENV:Envelope SOAP-ENV:encodingStyle=""http://schemas.xmlsoap.org/soap/encoding/""" & _
             " xmlns:SOAP-ENV=""http://schemas.xmlsoap.org/soap/envelope/""" & _
             " xmlns:xsd=""http://www.w3.org/2001/XMLSchema""" & _
             " xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance""" & _
             " xmlns:SOAP-ENC=""http://schemas.xmlsoap.org/soap/encoding/""" & _
             " xmlns:tns=""urn:qbcommunitymail"">" & _
        "<SOAP-ENV:Body>" & _
            "<GetMails xmlns=""urn:qbcommunitymail"" xsi:type=""tns:GetMails"">" & _
            "<Host xsi:type=""xsd:string""></Host><User xsi:type=""xsd:string""></User>" & _
            "<Pwd xsi:type=""xsd:string""></Pwd><Idx xsi:type=""xsd:int""></Idx>" & _
        "</GetMails></SOAP-ENV:Body></SOAP-ENV:Envelope>"

Private Const cmdGetMailBody = _
    "<?xml version=""1.0"" encoding=""ISO-8859-1""?>" & _
    "<SOAP-ENV:Envelope SOAP-ENV:encodingStyle=""http://schemas.xmlsoap.org/soap/encoding/""" & _
             " xmlns:SOAP-ENV=""http://schemas.xmlsoap.org/soap/envelope/""" & _
             " xmlns:xsd=""http://www.w3.org/2001/XMLSchema""" & _
             " xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance""" & _
             " xmlns:SOAP-ENC=""http://schemas.xmlsoap.org/soap/encoding/""" & _
             " xmlns:tns=""urn:qbcommunitymail"">" & _
        "<SOAP-ENV:Body>" & _
            "<GetMailBody xmlns=""urn:qbcommunitymail"" xsi:type=""tns:GetMailBody"">" & _
            "<Host xsi:type=""xsd:string""></Host><User xsi:type=""xsd:string""></User>" & _
            "<Pwd xsi:type=""xsd:string""></Pwd><Msgno xsi:type=""xsd:string""></Msgno>" & _
        "</GetMailBody></SOAP-ENV:Body></SOAP-ENV:Envelope>"

' estructuras
' variables privadas
Private m_ServiceID           As Long
Private m_Server              As cIServer
Private m_db                  As cDataSource

Private m_logFile             As String
Private m_bInProcess          As Boolean
Private WithEvents m_Timer    As cTimer
Attribute m_Timer.VB_VarHelpID = -1

Private m_Applications        As Collection
Private m_ApplicationsObj     As Collection

Private m_mailErrors As Collection

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
Private Property Get Applications() As Collection
  If m_Applications Is Nothing Then Set m_Applications = New Collection
  Set Applications = m_Applications
End Property

Private Property Get ApplicationsObj() As Collection
  If m_ApplicationsObj Is Nothing Then Set m_ApplicationsObj = New Collection
  Set ApplicationsObj = m_ApplicationsObj
End Property
' funciones publicas
' funciones friend
' funciones privadas
Private Sub cIService_ClientShutDown(ByVal ClientId As Long)
  Const c_ServiceShutDown = -1000
  If ClientId = c_ServiceShutDown Then
    gClose = True
  End If
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
    pSaveLog "La carga de las bases fallo", True
    Exit Sub
  End If
  
  pSaveLog "Creando Objeto de Encriptación"
  
  Dim Encrypt As cEncrypt
  Set Encrypt = New cEncrypt
  
  pSaveLog "Recorriendo las bases"
  
  Dim Server          As String
  Dim Database        As String
  Dim User            As String
  Dim pwd             As String
  Dim UseNTSecurity   As Boolean
  
  Do While Not rs.EOF
    
    Server = Encrypt.Decript(m_db.ValField(rs.Fields.Item("bd_server")), c_LoginSignature)
    Database = Encrypt.Decript(m_db.ValField(rs.Fields.Item("bd_nombre")), c_LoginSignature)
    User = Encrypt.Decript(m_db.ValField(rs.Fields.Item("bd_login")), c_LoginSignature)
    pwd = Encrypt.Decript(m_db.ValField(rs.Fields.Item("bd_pwd")), c_LoginSignature)
    UseNTSecurity = Val(Encrypt.Decript(m_db.ValField(rs.Fields.Item("bd_securitytype")), c_LoginSignature))
    
    pSaveLog "Configurando Email para: [" & Server & "] - [" & Database & "]"
    
    If Not pSetEmail(Server, _
                     Database, _
                     User, _
                     pwd, _
                     UseNTSecurity) Then
      
      pSaveLog "La configuracion del Email fallo", True
    
    Else
  
      pSaveLog "Procesando CVXI Mail para: [" & Server & "] - [" & Database & "]"
  
      pUpdateEmails Server, Database, User, pwd, UseNTSecurity
    
    End If
    
    If gClose Then Exit Do
    
    rs.MoveNext
    
  Loop
  
End Sub

Private Function pUpdateEmails(ByVal Server As String, ByVal Database As String, _
                               ByVal User As String, ByVal Password As String, _
                               ByVal UseNTSecurity As Boolean) As Boolean
                                 
'  On Error GoTo ControlError
'
'  Dim sqlstmt As String
'  Dim db      As cDataSource
'  Dim rs      As ADODB.Recordset
'  Dim alm_id  As Long
'
'  pSaveLog "Actualizando catalogos para " & Server & " - " & _
'                                            Database & " - " & _
'                                            User & _
'                                            " - NT " & _
'                                            IIf(UseNTSecurity, "Si", "No")
'
'  Set db = New cDataSource
'  If Not db.OpenConnection(Server, _
'                           Database, _
'                           User, _
'                           Password, _
'                           UseNTSecurity, _
'                           vbNullString) Then Exit Function
'
'
'  If Not pLoadApplications(db) Then
'    pSaveLog "Obtener Aplicaciones Falló", True
'    Exit Function
'  End If
'
'  pSaveLog "Aplicaciones de Comunidad Internet cargadas con éxito"
'
'  '--------------------------------------------
'  '
'  ' Emails
'  '
'  sqlstmt = "sp_srv_cvxi_getemailaccounts"
'  If Not db.OpenRs(rs, sqlstmt) Then
'    pSaveLog "Obtener Email Accounts Falló", True
'    Exit Function
'  End If
'
'  pSaveLog "Email Accounts cargadas con éxito"
'
'  If rs.EOF Then
'    pSaveLog "No hay Email Accounts"
'  End If
'
'  Do While Not rs.EOF
'
'    pGetEmails db, _
'               rs.Fields.Item("cmiea_id").Value, _
'               rs.Fields.Item("cmiea_server").Value, _
'               rs.Fields.Item("cmiea_user").Value, _
'               rs.Fields.Item("cmiea_pwd").Value, _
'               rs.Fields.Item("cmiea_email_server").Value, _
'               rs.Fields.Item("cmiea_email_user").Value, _
'               rs.Fields.Item("cmiea_email_pwd").Value
'
'    If gClose Then Exit Do
'
'    rs.MoveNext
'  Loop
'
'  pUpdateEmails = True
  
100   On Error GoTo ControlError
110
120   Dim sqlstmt As String
130   Dim db      As cDataSource
140   Dim rs      As ADODB.Recordset
150   Dim alm_id  As Long
160
170   pSaveLog "Actualizando catalogos para " & Server & " - " & _
                                                Database & " - " & _
                                                User & _
                                                " - NT " & _
                                                IIf(UseNTSecurity, "Si", "No")
   
      Set db = New cDataSource
240   If Not db.OpenConnection(Server, _
                               Database, _
                               User, _
                               Password, _
                               UseNTSecurity, _
                               vbNullString) Then Exit Function
300
310
320   If Not pLoadApplications(db) Then
330     pSaveLog "Obtener Aplicaciones Falló", True
340     Exit Function
350   End If
360
370   pSaveLog "Aplicaciones de Comunidad Internet cargadas con éxito"
380
390   '--------------------------------------------
400   '
410   ' Emails
420   '
430   sqlstmt = "sp_srv_cvxi_getemailaccounts"
440   If Not db.OpenRs(rs, sqlstmt) Then
450     pSaveLog "Obtener Email Accounts Falló", True
460     Exit Function
470   End If
480
490   pSaveLog "Email Accounts cargadas con éxito"
500
510   If rs.EOF Then
520     pSaveLog "No hay Email Accounts"
530   End If
540
550   Do While Not rs.EOF
560
570     pGetEmails db, _
                   rs.Fields.Item("cmiea_id").Value, _
                   rs.Fields.Item("cmiea_server").Value, _
                   rs.Fields.Item("cmiea_user").Value, _
                   rs.Fields.Item("cmiea_pwd").Value, _
                   rs.Fields.Item("cmiea_email_server").Value, _
                   rs.Fields.Item("cmiea_email_user").Value, _
                   rs.Fields.Item("cmiea_email_pwd").Value
650
660     If gClose Then Exit Do
670
680     rs.MoveNext
690   Loop
700
710   pUpdateEmails = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pUpdateEmails", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pGetEmails(ByRef db As cDataSource, _
                            ByVal cmiea_id As Long, _
                            ByVal Server As String, _
                            ByVal User As String, _
                            ByVal pwd As String, _
                            ByVal email_server As String, _
                            ByVal email_user As String, _
                            ByVal email_pwd As String) As Boolean
      
  
  Dim parser    As DOMDocument
  Dim indexMail As Long
  
  indexMail = 1
  
  Do
  
    Set parser = New DOMDocument
    
    parser.loadXML cmdGetMails
      
    parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/GetMails/Host").Text = email_server
    parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/GetMails/User").Text = email_user
    parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/GetMails/Pwd").Text = email_pwd
    parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/GetMails/Idx").Text = indexMail
  
    Dim oHttReq As XMLHTTP
    Set oHttReq = New XMLHTTP
    
    Dim URL As String
    
    '-------------------------------------------------------------
    '-------------------------------------------------------------
    '
    ' EMAILs
    '
    '-------------------------------------------------------------
    '-------------------------------------------------------------
    
    URL = IIf(Right$(Server, 1) = "/", Server, Server & "/") & "mailservice.php"
    'url = IIf(Right$(Server, 1) = "\", Server, Server & "\") & "mailservice_test.php"
    
    gServer.SaveLog "show:"
    gServer.SaveLog "show:"
    gServer.SaveLog "show:soap-server: " & URL
    gServer.SaveLog "show:email-server: " & email_server
    
    oHttReq.Open "POST", URL, False
    oHttReq.SetRequestHeader "Content-Type", "text/xml; charset=utf-8"
    oHttReq.SetRequestHeader "SOAPAction", URL & "#GetMails"
    oHttReq.Send parser.xml
    
    parser.loadXML oHttReq.ResponseText
    
    If Dir("c:\test.xml") <> "" Then Kill "c:\test.xml"
    parser.Save "c:\test.xml"
    
    Dim mails         As IXMLDOMNode
    Dim mail          As IXMLDOMNode
      
    Set mails = parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/GetMailsResponse/Emails/mails")
    
    gServer.SaveLog "show:emails: " & mails.childNodes.length
        
    For Each mail In mails.childNodes
    
      DoEvents
      If gClose Then Exit Function
    
      pProcessMail db, cmiea_id, Server, User, pwd, email_server, email_user, email_pwd, mail
      
    Next
    
    indexMail = indexMail + 1000
        
  Loop Until mails.childNodes.length = 0
    
End Function

Private Function pIsInErroColl(ByVal mail_id As String, ByVal User As String, ByVal Server As String)
  On Error Resume Next
  
  Dim dummy As String
  Dim errorMail As String
  
  Err.Clear
  
  errorMail = Server & "_" & User & "_" & mail_id
  dummy = m_mailErrors.Item(errorMail)
  
  pIsInErroColl = Err.Number = 0
  
  Err.Clear
End Function

Private Sub pProcessMail(ByVal db As cDataSource, _
                         ByVal cmiea_id As Long, _
                         ByVal Server As String, _
                         ByVal User As String, _
                         ByVal pwd As String, _
                         ByVal email_server As String, _
                         ByVal email_user As String, _
                         ByVal email_pwd As String, _
                         ByVal mail As IXMLDOMNode)
  On Error GoTo ControlError
    
  Dim f As Integer
    
  Dim cmie_id As Long
  Dim mailobj As cMail

  Dim fromname      As String
  Dim fromaddress   As String
  Dim subject       As String
  Dim froms         As IXMLDOMNode
  Dim from          As IXMLDOMNode
  
  Dim mail_id       As String
  Dim email_to      As String
  Dim email_date    As String
    
  Dim parserBody As DOMDocument
  Set parserBody = New DOMDocument
      
  Dim oHttReq As XMLHTTP
  Set oHttReq = New XMLHTTP
      
  Dim URL As String
  
  '
  ' La identificacion de un email es la fecha y su id
  ' esto es por que el id de un email se puede repetir
  '
  mail_id = mail.selectSingleNode("mail_id").Text
  email_date = mail.selectSingleNode("date").Text
  
  ' Esta funcion me devuelve true incluso si el header ya existe
  ' pues lo que importa es si ya baje el body
  '
  If Not pIsInErroColl(mail_id, email_user, email_server) Then
    
    ' Esta funcion me devuelve true incluso si el header ya existe
    ' pues lo que importa es si ya baje el body
    '
    If pIsNewEmail(db, cmiea_id, mail_id, email_date, cmie_id) Then
    
      '-------------------------------------------------------
      
      fromname = vbNullString
      fromaddress = vbNullString
      
      Set froms = mail.selectSingleNode("froms")
      For Each from In froms.childNodes
        fromname = fromname & from.selectSingleNode("fromname").Text & "|"
        fromaddress = fromaddress & from.selectSingleNode("fromaddress").Text & "|"
      Next
      
      If Right$(fromname, 1) = "|" Then fromname = Left$(fromname, Len(fromname) - 1)
      If Right$(fromaddress, 1) = "|" Then fromaddress = Left$(fromaddress, Len(fromaddress) - 1)
      
      subject = mail.selectSingleNode("subject").Text
      email_to = mail.selectSingleNode("to").Text
      
      SaveLog mail_id & " # " & subject, True
    
      '-------------------------------------------------------
    
      ' Esta funcion solo inserta el header si no fue insertado antes
      '
      If pSaveEmail(db, cmiea_id, mail_id, fromname, fromaddress, subject, email_user, email_to, email_date, cmie_id) Then
      
        '
        ' Si pude guardar el header voy por el body
        ' si no logro bajar el body se reintenta la proxima ves
        '
      
        '-------------------------------------------------------------
        '-------------------------------------------------------------
        '
        ' BODY EMAIL
        '
        '-------------------------------------------------------------
        '-------------------------------------------------------------
      
        parserBody.loadXML cmdGetMailBody
        
        parserBody.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/GetMailBody/Host").Text = email_server
        parserBody.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/GetMailBody/User").Text = email_user
        parserBody.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/GetMailBody/Pwd").Text = email_pwd
        parserBody.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/GetMailBody/Msgno").Text = mail_id
      
        URL = IIf(Right$(Server, 1) = "/", Server, Server & "/") & "mailservice.php"
        'url = IIf(Right$(Server, 1) = "\", Server, Server & "\") & "mailservice_test.php"
        
        oHttReq.Open "POST", URL, False
        oHttReq.SetRequestHeader "Content-Type", "text/xml; charset=utf-8"
        oHttReq.SetRequestHeader "SOAPAction", URL & "#GetMailBody"
        
        oHttReq.Send parserBody.xml
        
        parserBody.loadXML oHttReq.ResponseText
        
        If Dir("c:\test.xml") <> "" Then Kill "c:\test.xml"
        parserBody.Save "c:\test.xml"
      
        Dim mail_body     As IXMLDOMNode
        Dim htmlmsg       As IXMLDOMNode
        Dim plainmsg      As IXMLDOMNode
        Dim charset       As IXMLDOMNode
        Dim attachments   As IXMLDOMNode
        
        Dim body_html         As String
        Dim body_plain        As String
        Dim body_charset      As String
        Dim body_attachments  As String
        
        Set mail_body = parserBody.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/GetMailBodyResponse/Email/mail")
      
        body_html = mail_body.selectSingleNode("htmlmsg").Text
        body_plain = mail_body.selectSingleNode("plainmsg").Text
        body_charset = mail_body.selectSingleNode("charset").Text
        body_attachments = mail_body.selectSingleNode("attachments").Text
                
        If pSaveEmailBody(db, cmiea_id, mail_id, body_html, body_plain) Then
                
          If Not pGetMail(db, cmie_id, mailobj) Then Exit Sub
        
          '/////////////////////////////////////////////////////////
          ' Debug
          '
          If Dir("c:\test.html") <> "" Then Kill "c:\test.html"
          f = FreeFile
          Open "c:\test.html" For Append As f
          If LenB(mailobj.body_html) Then
            Print #f, mailobj.body_html
          Else
            Print #f, mailobj.body_plain
          End If
          Close f
          '
          '//////////////////////////////////////////////////////////
        
          If mail.selectSingleNode("seen").Text <> "1" Then
        
            pProcessApplications db, mailobj, _
                                     Server, _
                                     User, _
                                     pwd, _
                                     email_server, _
                                     email_user, _
                                     email_pwd
          End If
          
        End If
      
      End If
    Else
    
      ' Por performance solo analizo mails de no mas de 2 dias
      Dim dateVal As Date
      If pIsDate(email_date, dateVal) Then
      
        If Not (dateVal < DateAdd("d", -2, Date)) Then
                    
          ' Verifico que ya este respondido
          '
          If Not pGetMail(db, cmie_id, mailobj) Then Exit Sub
        
          '/////////////////////////////////////////////////////////
          ' Debug
          '
          If Dir("c:\test.html") <> "" Then Kill "c:\test.html"
          f = FreeFile
          Open "c:\test.html" For Append As f
          If LenB(mailobj.body_html) Then
            Print #f, mailobj.body_html
          Else
            Print #f, mailobj.body_plain
          End If
          Close f
          
          'If InStr(mailobj.subject, "Felicitaciones") Then Stop
          '
          '//////////////////////////////////////////////////////////
        
          If mail.selectSingleNode("seen").Text <> "1" Then
          
            pProcessApplications db, mailobj, _
                                     Server, _
                                     User, _
                                     pwd, _
                                     email_server, _
                                     email_user, _
                                     email_pwd
          End If
        End If
      End If
    End If
  End If

  GoTo ExitProc
ControlError:

  Dim errorMail As String
  errorMail = email_server & "_" & email_user & "_" & mail_id

  m_mailErrors.Add errorMail, errorMail

  MngError Err, "pProcessMail", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pIsDate(ByVal dateValue As Variant, ByRef dateVal As Date) As Boolean
  If IsDate(dateValue) Then
    dateVal = dateValue
    pIsDate = True
    Exit Function
  End If
  
  Dim year As Long
  Dim month As Long
  Dim day As Long
  
  On Error Resume Next
  Err.Clear
  
  If VarType(dateValue) = vbString Then
    
    year = Left$(dateValue, 4)
    If Err.Number Then Exit Function
    
    month = Mid$(dateValue, 5, 2)
    If Err.Number Then Exit Function
    
    day = Mid$(dateValue, 7, 2)
    If Err.Number Then Exit Function
    
    dateVal = DateSerial(year, month, day)
    If Err.Number Then Exit Function
    pIsDate = True
  End If
End Function


Private Function pGetMail(ByVal db As cDataSource, ByVal cmie_id As Long, ByRef mail As cMail) As Boolean
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_srv_cvxi_getemail " & cmie_id
  If Not db.OpenRs(rs, sqlstmt) Then Exit Function
  If rs.EOF Then Exit Function
  
  Set mail = New cMail
  
  With mail
    .account = db.ValField(rs.Fields.Item("cmie_account"))
    .body_html = db.ValField(rs.Fields.Item("cmie_body_html"))
    .body_mime = db.ValField(rs.Fields.Item("cmie_body_mime"))
    .body_plain = db.ValField(rs.Fields.Item("cmie_body_plain"))
    .body_updated = db.ValField(rs.Fields.Item("cmie_body_updated"))
    .cmi_id = db.ValField(rs.Fields.Item("cmi_id"))
    .cmiea_id = db.ValField(rs.Fields.Item("cmiea_id"))
    .creado = db.ValField(rs.Fields.Item("creado"))
    .fromaddress = db.ValField(rs.Fields.Item("cmie_fromaddress"))
    .fromname = db.ValField(rs.Fields.Item("cmie_fromname"))
    .header_mime = db.ValField(rs.Fields.Item("cmie_header_mime"))
    .id = db.ValField(rs.Fields.Item("cmie_id"))
    .mailid = db.ValField(rs.Fields.Item("cmie_mailid"))
    .mailto = db.ValField(rs.Fields.Item("cmie_to"))
    .subject = db.ValField(rs.Fields.Item("cmie_subject"))
    .subject_mime = db.ValField(rs.Fields.Item("cmie_subject_mime"))
  End With
  
  pGetMail = True
  
End Function

Private Function pClearApplications()
  While Applications.Count
    Applications.Remove 1
  Wend
  While ApplicationsObj.Count
    ApplicationsObj.Remove 1
  Wend
End Function

Private Function pLoadApplications(ByRef db As cDataSource) As Boolean
  
  pClearApplications
    
  Dim rs As ADODB.Recordset
  Dim sqlstmt As String
  
  sqlstmt = "sp_srv_cvxi_aplicacionesget"
  
  If Not db.OpenRs(rs, sqlstmt) Then Exit Function
  
  While Not rs.EOF
  
    Dim Application As cApplication
    Set Application = New cApplication
    
    Application.ActivexObject = db.ValField(rs.Fields("cmia_activexobject"))
    Application.nombre = db.ValField(rs.Fields("cmia_nombre"))
    
    Applications.Add Application
    
    If Not pAddObjectApplication(Application.ActivexObject) Then
      pSaveLog "No se pudo crear el objeto para la aplicacion " & Application.nombre & " - Activex: " & Application.ActivexObject
    End If
    
    rs.MoveNext
  Wend

  pLoadApplications = True
  
End Function

Private Function pAddObjectApplication(ByVal ClassId As String) As Boolean
  On Error Resume Next
  
  Dim obj As Object
  Err.Clear
  Set obj = VBA.CreateObject(ClassId)
  If Not obj Is Nothing Then
    ApplicationsObj.Add obj
    pAddObjectApplication = True
  End If
  Err.Clear
End Function

Private Function pProcessApplications(ByRef db As cDataSource, _
                                      ByVal mail As cMail, _
                                      ByVal Server As String, _
                                      ByVal User As String, _
                                      ByVal pwd As String, _
                                      ByVal email_server As String, _
                                      ByVal email_user As String, _
                                      ByVal email_pwd As String)
  Dim obj As Object
  
  For Each obj In ApplicationsObj
  
    obj.ProcessMail db, mail, _
                        Server, _
                        User, _
                        pwd, _
                        email_server, _
                        email_user, _
                        email_pwd
  Next
End Function

Private Function pSaveEmail(ByRef db As cDataSource, _
                            ByVal cmiea_id As Long, _
                            ByVal mail_id As String, _
                            ByVal fromname As String, _
                            ByVal fromaddress As String, _
                            ByVal subject As String, _
                            ByVal account As String, _
                            ByVal email_to As String, _
                            ByVal email_date As String, _
                            ByRef cmie_id As Long) As Boolean

  If Len(mail_id) > 255 Then
  
    SaveLog "Se recibio un mail_id mayor a 255 caracteres"
    Exit Function
  
  Else
  
    Dim rs As ADODB.Recordset
    Dim sqlstmt As String
    
    sqlstmt = "sp_srv_cvxi_emailsave " & _
                      cmiea_id & _
                      "," & db.sqlString(mail_id) & _
                      "," & db.sqlString(Left$(fromname, 1000)) & _
                      "," & db.sqlString(Left$(fromaddress, 1000)) & _
                      "," & db.sqlString(Left$(subject, 2000)) & _
                      "," & db.sqlString(Left$(account, 255)) & _
                      "," & db.sqlString(Left$(email_to, 255)) & _
                      "," & "'" & email_date & "'"
    
    If Not db.OpenRs(rs, sqlstmt) Then
      SaveLog "Error al procesar el email: " & sqlstmt
      Exit Function
    End If
    
    If rs.EOF Then
      SaveLog "Error al procesar el email: " & sqlstmt
      Exit Function
    End If
    
    cmie_id = rs.Fields.Item(0).Value
    
  End If
  
  pSaveEmail = True
  
End Function

Private Function pIsNewEmail(ByRef db As cDataSource, _
                             ByVal cmiea_id As Long, _
                             ByVal mail_id As String, _
                             ByVal email_date As String, _
                             ByRef cmie_id As Long) As Boolean

  Dim dateVal As Date
  If pIsDate(email_date, dateVal) Then
    If dateVal < DateAdd("d", -2, Date) Then
      Exit Function
    End If
  End If

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_srv_cvxi_isnewemail " & _
                      cmiea_id & _
                      "," & db.sqlString(mail_id) & _
                      "," & db.sqlString(email_date)
    
  If Not db.OpenRs(rs, sqlstmt) Then
    SaveLog "Error al procesar el email: " & sqlstmt
    Exit Function
  End If
  
  If rs.EOF Then
    SaveLog "Error al procesar el email: " & sqlstmt
    Exit Function
  End If
    
  cmie_id = rs.Fields.Item(1).Value
  pIsNewEmail = rs.Fields.Item(0).Value
  
End Function

Private Function pSaveEmailBody(ByRef db As cDataSource, _
                                ByVal cmie_id As Long, _
                                ByVal mail_id As String, _
                                ByVal body_html As String, _
                                ByVal body_plain As String) As Boolean

  Dim sqlstmt As String
  
  If Len(mail_id) > 255 Then
  
    SaveLog "Se recibio un mail_id mayor a 255 caracteres"
  
  Else
  
    sqlstmt = "sp_srv_cvxi_emailbodysave " & _
                      cmie_id & _
                      "," & db.sqlString(mail_id) & _
                      "," & db.sqlString(body_html) & _
                      "," & db.sqlString(body_plain)
                      
    If Not db.Execute(sqlstmt, "pSaveEmailBody") Then
      SaveLog "Error al procesar el email: " & sqlstmt
      Exit Function
    End If
  End If
  
  pSaveEmailBody = True
  
End Function

Private Function pSendEmail(ByVal addressTo As String, _
                            ByVal subject As String, _
                            ByVal Message As String) As Boolean

  pSaveLog "Creando Objeto de Email"
  
  Dim mail As Object
  Set mail = CreateObject("CSMail.cMail")
  
  Dim body   As String
  
  body = Message
  
  Dim vAddressTo As Variant
  Dim i          As Long
  
  addressTo = Replace(addressTo, ";", ",")
  vAddressTo = Split(addressTo, ",")
  
  For i = 0 To UBound(vAddressTo)
  
    If mail.SendEmail(vAddressTo(i), _
                      gEmailAddress, _
                      gEmailAddress, _
                      gEmailServer, _
                      gEmailPort, _
                      gEmailUser, _
                      gEmailPwd, subject, body) Then
      pSaveLog "El mail se envio con éxito"
    Else
      pSaveLog "El mail fallo " & mail.ErrNumber & " - " & mail.ErrDescrip, True
      Exit Function
    End If
    
  Next
  
  pSendEmail = True
End Function

Private Sub m_Timer_ThatTime()
  On Error GoTo ControlError
  
  If gClose Then
    m_Timer.Interval = 0
    Exit Sub
  End If
  
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
    pSaveLog "Advertencia: El usuario y la clave de email estan en blanco", True
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

  Set m_mailErrors = New Collection

  m_ServiceID = SRV_ID_CATALOG

  m_logFile = IniGet(c_k_Log, pGetPath(App.Path) & "Log\CSCVXI.log")

  pSaveLog "Server Catalog Start", True

  Set m_Timer = New cTimer
  m_Timer.Interval = Val(IniGet(c_k_interval, 3000))
  
  pSaveLog "Interval: " & m_Timer.Interval, True
  
  Set m_Server = gServer
  gServiceCreated = True
  
  Set m_db = New cDataSource
  pOpenDB

  pSaveLog "Initialize Complete Successfully", True

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  pSaveLog "Server Catalog Stop", True
  
  Set m_Server = Nothing
  Set m_Applications = Nothing
  Set m_ApplicationsObj = Nothing
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

Private Sub pSaveLog(ByVal msg As String, _
                     Optional ByVal bLog As Boolean, _
                     Optional ByVal iLevel As Long)
  On Error Resume Next
  
  If (gLogFull Or bLog Or iLevel >= giLevel) And LenB(msg) <> 0 Then
  
    Dim f As Integer
    f = FreeFile
    Open m_logFile For Append As f
    Print #f, Format(Now, "dd/mm/yy hh:nn:ss   ") & msg
    Close f
    
  End If
End Sub

Private Function pGetPath(ByVal Path As String) As String
  If Right(Path, 1) <> "\" Then Path = Path & "\"
  pGetPath = Path
End Function

'Private Function pGetHtmlPage() As String
'  'pGetHtmlPage = "http://localhost:8080/catalogo/tools.php"
'  pGetHtmlPage = IniGet(c_k_update_page, "http://localhost/catalogo/tools.php")
'End Function

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


