VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMercadoLibreMail"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Const C_Module As String = "cMercadoLibreMail"

Private m_Textos  As Collection
Private m_bLoad   As Boolean
Private m_mail    As cMail

Private Const cscCmirpTexto     As String = "cmirp_texto"
Private Const cscCmirpFrom      As String = "cmirp_from"
Private Const cscCmirpSubject   As String = "cmirp_subject"

' XML Soap commands
'Private Const cmdSendMail = _
    "<?xml version=""1.0"" encoding=""ISO-8859-1""?>" & _
    "<SOAP-ENV:Envelope SOAP-ENV:encodingStyle=""http://schemas.xmlsoap.org/soap/encoding/""" & _
             " xmlns:SOAP-ENV=""http://schemas.xmlsoap.org/soap/envelope/""" & _
             " xmlns:xsd=""http://www.w3.org/2001/XMLSchema""" & _
             " xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance""" & _
             " xmlns:SOAP-ENC=""http://schemas.xmlsoap.org/soap/encoding/""" & _
             " xmlns:tns=""urn:qbcommunitymail"">" & _
        "<SOAP-ENV:Body>" & _
            "<SendMail xmlns=""urn:qbcommunitymail"" xsi:type=""tns:SendMail"">" & _
            "<Host xsi:type=""xsd:string""></Host><User xsi:type=""xsd:string""></User>" & _
            "<Pwd xsi:type=""xsd:string""></Pwd><From xsi:type=""xsd:string""></From>" & _
            "<To xsi:type=""xsd:string""></To><Bcc xsi:type=""xsd:string""></Bcc>" & _
            "<Subject xsi:type=""xsd:string""></Subject><BodyHtml xsi:type=""xsd:string""></BodyHtml>" & _
            "<BodyText xsi:type=""xsd:string""></BodyText>" & _
        "</SendMail></SOAP-ENV:Body></SOAP-ENV:Envelope>"


Private Property Get Textos() As Collection
  Set Textos = m_Textos
End Property

'////////////////////////////////////////////////////////////////////////////

Public Function ProcessMail(ByVal mail As cMail, _
                            ByVal Server As String, _
                            ByVal User As String, _
                            ByVal pwd As String, _
                            ByVal email_server As String, _
                            ByVal email_user As String, _
                            ByVal email_pwd As String, _
                            ByVal idCliente As String, _
                            ByVal nombre As String, _
                            ByVal apellido As String, _
                            ByVal nombreArticulo As String, _
                            ByVal idArticulo As String, _
                            ByVal preciostr As String, _
                            ByVal cantidadstr As String, _
                            ByVal email As String, _
                            ByVal telefono As String, _
                            ByVal localidad As String, _
                            ByVal provincia As String, _
                            ByVal fecha As Date) As Boolean

  On Error GoTo ControlError
    
  If Not pHasReply(mail.id) Then
  
    'If InStr(1, LCase$(mail.subject), "has vendido") <> 0 Then Stop

    Set m_mail = mail
        
    If Not m_bLoad Then
      If Not pLoadTextos() Then Exit Function
      m_bLoad = True
    End If
    
    Dim texto     As cTexto
    Dim textoItem As cTextoItem
    
    ' Por cada mail limpio los valores de los textos
    '
    For Each texto In Textos
    
      For Each textoItem In texto.Items
    
        DoEvents
        
        If gClose Then Exit Function
      
        textoItem.valor = vbNullString
        textoItem.valorHtml = vbNullString
      Next
    Next
    
    pFillTextos idCliente, _
                nombre, _
                apellido, _
                nombreArticulo, _
                idArticulo, _
                preciostr, _
                cantidadstr, _
                email, _
                telefono, _
                localidad, _
                provincia, _
                fecha
        
    If Not pReplyEmail(Server, _
                       User, _
                       pwd, _
                       email_server, _
                       email_user, _
                       email_pwd) Then Exit Function
  
  End If
  
  ProcessMail = True
  
  GoTo ExitProc
ControlError:
  
  Dim errorDescription As String
  errorDescription = Err.Description
  
  SaveLog C_Module
  SaveLog "ProcessMail"
  SaveLog "Error: " & errorDescription
  
ExitProc:
  Set m_mail = Nothing
End Function

'////////////////////////////////////////////////////////////////////////////

Private Function pReplyEmail(ByVal Server As String, _
                             ByVal User As String, _
                             ByVal pwd As String, _
                             ByVal email_server As String, _
                             ByVal email_user As String, _
                             ByVal email_pwd As String) As Boolean
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  ' Parametros que recibe el sp
  '
  '   @@cmi_id      Comunidad
  '   @@cmia_id     Aplicacion
  '   @@idm_id      Idioma
  '   @@marc_id     Marca
  '   @@rub_id      Rubro
  '   @@pr_id       Producto
  
  ' TODO: hay que hacer que los parametros marca, rubro y producto
  '       salgan del articulo comprado
  '       para esto hay que terminar el proceso de identificacion de
  '       articulo en funcion del codigo de mercadolibre
  '       y para esto hay que agregar a producto una grilla de
  '       codigos de venta en comunidades de internet
  '       tiene estos campos: pr_id, codigo comunidad, emision, vencimiento, cmi_id (comunidad)

  sqlstmt = "sp_srv_cvxi_getEmailRespuestaPlantilla " & _
                              c_id_mercadolibre & "," & _
                              c_id_mercadolibre & "," & _
                              c_id_idioma & "," & _
                              0 & "," & _
                              0 & "," & _
                              0
                              
  If Not gDb.OpenRs(sqlstmt, rs) Then Exit Function
  
  Dim respuestaHtml As String
  Dim respuestaText As String
  Dim bHaveToReply  As Boolean
  Dim texto         As cTexto
  
  While Not rs.EOF
  
    For Each texto In Textos
    
      ' Solo textos que pertencen a la misma cuenta o son genericos
      '
      If texto.cmiea_id = csNO_ID Or texto.cmiea_id = m_mail.cmiea_id Then
    
        'MsgBox "x.x.z.1"
    
        If Not pProcessRespuestaPlantilla( _
                            texto, _
                            gDb.ValField(rs.fields, cscCmirpTexto), _
                            respuestaHtml, _
                            bHaveToReply) Then Exit Function
        If bHaveToReply Then
        
        
          'MsgBox "x.z.1"
        
          respuestaText = pBuildTextVersion(respuestaHtml)
        
          ' 1er intento
          Dim success As Boolean
          Dim n As Long
          
          n = 0
          success = False
          
          Do While Not success And n < 5
            
            If pSendEmail(Server, _
                          User, _
                          pwd, _
                          email_server, _
                          email_user, _
                          email_pwd, _
                          gDb.ValField(rs.fields, cscCmirpFrom), _
                          pGetEmailAddress(texto), _
                          gDb.ValField(rs.fields, cscCmirpSubject), _
                          HTMLEncode(respuestaHtml), _
                          respuestaText) Then
              success = True
              If n > 1 Then
                SaveLog "Re Send tuvo exito !!!!"
              End If
              Exit Do
            End If
            
            n = n + 1
            DoEvents
            DoEvents
                            
            Sleep 10000 * n
            
            DoEvents
            DoEvents
                            
          Loop
          
          If Not success Then
            SaveLog "Send Email fallo en todos sus intentos !!!!!"
            Exit Function
          End If
          
          pSaveReplyInDb gDb.ValField(rs.fields, cscCmirpFrom), _
                         pGetEmailAddress(texto), _
                         gDb.ValField(rs.fields, cscCmirpSubject), _
                         HTMLEncode(respuestaHtml)
                    
        End If
      End If
    Next
    
    rs.MoveNext
  Wend
  
  pReplyEmail = True
End Function

Private Function pProcessRespuestaPlantilla(ByVal texto As cTexto, _
                                            ByVal textoRespuesta As String, _
                                            ByRef respuesta As String, _
                                            ByRef bHaveToReply As Boolean) As Boolean

  Dim pos                   As Long
  Dim startPos              As Long
  Dim macro                 As String
  Dim respuestaPlantilla    As String
  Dim textoPlantilla        As String
  Dim macroCall             As String

  Dim param   As String
  Dim output  As String
  Dim char    As String

  ' Inicialmente la respuesta es toda la plantilla
  '
  respuesta = textoRespuesta

  ' Antes que nada procesamos las macros booleanas ( @@es_mail_venta, @@nombre_vendedor )
  '
  startPos = 1
  pos = InStr(startPos, respuesta, c_macro_es_mail_venta)
  If pos <> 0 Then
    respuesta = Replace$(respuesta, _
                         c_macro_es_mail_venta, _
                         Val(pGetValorByMacro(c_macro_es_mail_venta, texto)))
  End If

  ' Necesito procesar esta macro de reemplazo antes que @@es_igual_a
  ' por que se usa de parametro para @@es_igual_a
  '
  startPos = 1
  pos = InStr(startPos, respuesta, c_macro_nombre_vendedor)
  If pos <> 0 Then
    respuesta = Replace$(respuesta, _
                         c_macro_nombre_vendedor, _
                         pGetValorByMacro(c_macro_nombre_vendedor, texto))
  End If

  ' Luego procesamos la macro @@es_igual_a
  '
  Dim param1    As String
  Dim param2    As String
  Dim es_igual  As String
  
  startPos = 1
  Do
    pos = InStr(startPos, respuesta, c_macro_es_igual_a)
    If pos <> 0 Then
      
      startPos = pos + 1
      macro = Mid$(respuesta, pos)
      param1 = pGetParam(macro, 1)
      param2 = pGetParam(macro, 2)
      
      ' Si no cumple con @@exije no hay que enviar respuesta
      '
      If param1 <> param2 Then
        es_igual = 0
      Else
        es_igual = 1
      End If
      
      macroCall = pGetMacroCall(macro)
      respuesta = Replace$(respuesta, macroCall, es_igual)
    
    Else
      Exit Do
    End If
  Loop

  ' Luego procesamos la macro @@exije
  '
  startPos = 1
  Do
    pos = InStr(startPos, respuesta, c_macro_exije)
    If pos <> 0 Then
      
      startPos = pos + 1
      macro = Mid$(respuesta, pos)
      param = pGetParam(macro, 1)
      
      ' Si no cumple con @@exije no hay que enviar respuesta
      '
      If Val(param) = 0 Then
      
        bHaveToReply = False
        respuesta = vbNullString
        pProcessRespuestaPlantilla = True
        Exit Function
      End If
      
      macroCall = pGetMacroCall(macro)
      respuesta = Replace$(respuesta, macroCall, vbNullString)
    
    Else
      Exit Do
    End If
  Loop
  

  ' 1 proceso las macros recursivas ( @@plantilla(...) )
  '
  startPos = 1
  Do
    pos = InStr(startPos, respuesta, c_macro_plantilla)
    If pos <> 0 Then
    
      startPos = pos + 1
      macro = Mid$(respuesta, pos)
    
      If Not pGetRespuestaPlantilla(pGetParam(macro, 1), _
                                    textoPlantilla) Then
        Exit Function
      End If
      If Not pProcessRespuestaPlantilla(texto, _
                                        textoPlantilla, _
                                        respuestaPlantilla, _
                                        False) Then
        Exit Function
      End If
      macroCall = pGetMacroCall(macro)
      respuesta = Replace$(respuesta, macroCall, respuestaPlantilla)
    
    Else
      Exit Do
    End If
  Loop ' El bucle se termina por el else del if
  
  ' 2 Ahora proceso macros que solo son de reemplazar
  '
  startPos = 1
  pos = InStr(startPos, respuesta, c_macro_nombre_comprador)
  If pos <> 0 Then
    respuesta = Replace$(respuesta, _
                         c_macro_nombre_comprador, _
                         pGetValorByMacro(c_macro_nombre_comprador, texto))
  End If
  
  pos = InStr(startPos, respuesta, c_macro_apodo)
  If pos <> 0 Then
    respuesta = Replace$(respuesta, _
                         c_macro_apodo, _
                         pGetValorHtmlByMacro(c_macro_apodo, texto))
  End If
  
  pos = InStr(startPos, respuesta, c_macro_nombre_producto)
  If pos <> 0 Then
    respuesta = Replace$(respuesta, _
                         c_macro_nombre_producto, _
                         pGetValorHtmlByMacro(c_macro_nombre_producto, texto))
  End If
  
  pos = InStr(startPos, respuesta, c_macro_cantidad)
  If pos <> 0 Then
    respuesta = Replace$(respuesta, _
                         c_macro_cantidad, _
                         pGetValorHtmlByMacro(c_macro_cantidad, texto))
  End If
  
  pos = InStr(startPos, respuesta, c_macro_precio)
  If pos <> 0 Then
    respuesta = Replace$(respuesta, _
                         c_macro_precio, _
                         pGetValorHtmlByMacro(c_macro_precio, texto))
  End If
  
  pos = InStr(startPos, respuesta, c_macro_codigo_producto)
  If pos <> 0 Then
    respuesta = Replace$(respuesta, _
                         c_macro_codigo_producto, _
                         pGetValorHtmlByMacro(c_macro_codigo_producto, texto))
  End If
    
  pos = InStr(startPos, respuesta, c_macro_apodo2)
  If pos <> 0 Then
    respuesta = Replace$(respuesta, _
                         c_macro_apodo2, _
                         pGetValorHtmlByMacro(c_macro_apodo2, texto))
  End If

  pos = InStr(startPos, respuesta, c_macro_ciudad_comprador)
  If pos <> 0 Then
    respuesta = Replace$(respuesta, _
                         c_macro_ciudad_comprador, _
                         pGetValorHtmlByMacro(c_macro_ciudad_comprador, texto))
  End If

  pos = InStr(startPos, respuesta, c_macro_provincia_comprador)
  If pos <> 0 Then
    respuesta = Replace$(respuesta, _
                         c_macro_provincia_comprador, _
                         pGetValorHtmlByMacro(c_macro_provincia_comprador, texto))
  End If

  pos = InStr(startPos, respuesta, c_macro_telefono_comprador)
  If pos <> 0 Then
    respuesta = Replace$(respuesta, _
                         c_macro_telefono_comprador, _
                         pGetValorHtmlByMacro(c_macro_telefono_comprador, texto))
  End If

  pos = InStr(startPos, respuesta, c_macro_email_comprador)
  If pos <> 0 Then
    respuesta = Replace$(respuesta, _
                         c_macro_email_comprador, _
                         pGetValorHtmlByMacro(c_macro_email_comprador, texto))
  End If
        
  ' 3 Ahora proceso macros que reciben parametros
  '
  startPos = 1
  Do
    pos = InStr(startPos, respuesta, c_macro_capitalizar)
    If pos <> 0 Then
      
      startPos = pos + 1
      macro = Mid$(respuesta, pos)
      param = pGetParam(macro, 1)
      
      Dim bSpace  As Boolean
      Dim i       As Long
      
      bSpace = True
      For i = 1 To Len(param)
      
        If bSpace Then
          If Mid$(param, i, 1) <> " " Then
            char = UCase$(Mid$(param, i, 1))
            bSpace = False
          Else
            char = " "
          End If
        
        ElseIf Mid$(param, i, 1) <> " " Then
          char = LCase$(Mid$(param, i, 1))
        Else
          char = " "
          bSpace = True
        End If
        
        output = output & char
        
      Next
      
      macroCall = pGetMacroCall(macro)
      respuesta = Replace$(respuesta, macroCall, output)
    
    Else
      Exit Do
    End If
  Loop
  
  ' Esta va siempre al final aunque es una de reemplazo
  ' ya que de esta forma no es posible que sea afectada
  ' por ningun cambio al codigo
  '
  pos = InStr(startPos, respuesta, c_macro_texto_mail)
  If pos <> 0 Then
    Dim bodyMail As String
    
    If LenB(m_mail.body_html) Then
      'bodyMail = m_mail.body_html
      bodyMail = pGetValorHtmlByMacro(c_macro_texto_mail, texto)
    Else
      'bodyMail = m_mail.body_plain
      bodyMail = pGetValorByMacro(c_macro_texto_mail, texto)
      If InStr(1, bodyMail, vbCrLf) = 0 Then
        bodyMail = Replace$(bodyMail, vbLf, vbCrLf)
      End If
      If InStr(1, bodyMail, vbCrLf) = 0 Then
        bodyMail = Replace$(bodyMail, "Apodo:", vbCrLf & "Apodo:")
        bodyMail = Replace$(bodyMail, "Cantidad:", vbCrLf & "Cantidad:")
        bodyMail = Replace$(bodyMail, "Precio final:", vbCrLf & "Precio final:")
        bodyMail = Replace$(bodyMail, "E-mail:", vbCrLf & "E-mail:")
        bodyMail = Replace$(bodyMail, "Teléfono:", vbCrLf & "Teléfono:")
        bodyMail = Replace$(bodyMail, "Ciudad:", vbCrLf & "Ciudad:")
        bodyMail = Replace$(bodyMail, "País:", vbCrLf & "País:")
      End If
      bodyMail = "<p>" & Replace$(bodyMail, vbCrLf, "<br>") & "</p>"
    End If
    
    ' Estos enter que pongo son para que al obtener la version
    ' solo texto del mail, el texto respete los renglones
    ' y no este todo en una sola linea
    '
    bodyMail = Replace(bodyMail, "<br>", "<br>" & vbCrLf)
    bodyMail = Replace(bodyMail, "<br />", "<br />" & vbCrLf)
    bodyMail = Replace(bodyMail, "<br/>", "<br/>" & vbCrLf)
    bodyMail = Replace(bodyMail, "</p>", "</p>" & vbCrLf)
    bodyMail = Replace(bodyMail, "</ p>", "</ p>" & vbCrLf)
    
    respuesta = Replace$(respuesta, _
                         c_macro_texto_mail, _
                         bodyMail)
  End If
  
  bHaveToReply = True
  
  pProcessRespuestaPlantilla = True
End Function

Private Function pBuildTextVersion(ByRef respuesta As String) As String
  pBuildTextVersion = pExtractHtml(respuesta)
End Function

Private Function pGetEmailAddress(ByVal texto As cTexto) As String
  Dim rtn As String
    
  rtn = pGetValorByMacro(c_email_comprador, texto)
  
  If rtn = "" Then
  
    Err.Raise vbObjectError + 1, C_Module, "La direccion de email del comprador esta vacia en el mail: " & m_mail.id
  
  End If
  
  pGetEmailAddress = rtn
  
End Function

Private Function pSendEmail(ByVal Server As String, _
                            ByVal User As String, _
                            ByVal pwd As String, _
                            ByVal email_server As String, _
                            ByVal email_user As String, _
                            ByVal email_pwd As String, _
                            ByVal from As String, _
                            ByVal to_email As String, _
                            ByVal Subject As String, _
                            ByVal respuestaHtml As String, _
                            ByVal respuestaText As String _
                            ) As Boolean
  
  ' TODO: remover la direccion de prueba del email
  Dim email_test As String
  email_test = pGetEmailTest()

  Dim email_bcc As String
  email_bcc = pGetEmailBcc()

  If email_test <> "" Then to_email = email_test
  
  'MsgBox "x.1"
  
  Dim cdoemail As cCDOEmail
  Set cdoemail = New cCDOEmail
  If (cdoemail.SendMailByCDO(to_email, _
                              Subject, _
                              respuestaText, _
                              respuestaHtml, _
                              email_bcc, _
                              "", _
                              email_server, _
                              from, _
                              email_user, _
                              email_pwd) = 0) Then
    pSendEmail = True
    
  End If
  
  'MsgBox "x.2"
  
  Dim html As String
  html = "<p>enviando email a : " & to_email & "</p>"
  ShowHtmlInfo2 html
                              
End Function

'Private Function pSendEmail(ByVal Server As String, _
'                            ByVal User As String, _
'                            ByVal pwd As String, _
'                            ByVal email_server As String, _
'                            ByVal email_user As String, _
'                            ByVal email_pwd As String, _
'                            ByVal from As String, _
'                            ByVal to_email As String, _
'                            ByVal Subject As String, _
'                            ByVal respuestaHtml As String, _
'                            ByVal respuestaText As String _
'                            ) As Boolean
'
'  Dim parser As DOMDocument
'
'  ' TODO: remover la direccion de prueba del email
'  Dim email_test As String
'  email_test = pGetEmailTest()
'
'  Dim email_bcc As String
'  email_bcc = pGetEmailBcc()
'
'  If email_test <> "" Then to_email = email_test
'
''  email_bcc = "contacto@todoencartuchos.com"
''  to_email = "contacto@todoencartuchos.com"
'
'  Set parser = New DOMDocument
'
'  parser.loadXML cmdSendMail
'
'  parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SendMail/Host").Text = email_server
'  parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SendMail/User").Text = email_user
'  parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SendMail/Pwd").Text = email_pwd
'  parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SendMail/From").Text = from
'  parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SendMail/To").Text = to_email
'  parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SendMail/Bcc").Text = email_bcc
'  parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SendMail/Subject").Text = Subject
'  parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SendMail/BodyHtml").Text = respuestaHtml
'  parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SendMail/BodyText").Text = respuestaText
'
'  SaveLog "------------------------------------------------"
'  SaveLog "*"
'  SaveLog "*"
'  SaveLog "*"
'  SaveLog "------------------------------------------------"
'  SaveLog "show:sending mail"
'  SaveLog "show:to [" & to_email & "] "
'  SaveLog "show:bcc [" & email_bcc & "] "
'  SaveLog "show:body: " & vbCrLf & respuestaText
'
'  Dim oHttReq As XMLHTTP
'  Set oHttReq = New XMLHTTP
'
'  Dim URL As String
'
'  '-------------------------------------------------------------
'  '-------------------------------------------------------------
'  '
'  ' EMAIL
'  '
'  '-------------------------------------------------------------
'  '-------------------------------------------------------------
'
'  URL = IIf(Right$(Server, 1) = "/", Server, Server & "/") & "mailservice.php"
'
'  oHttReq.Open "POST", URL, False
'  oHttReq.setRequestHeader "Content-Type", "text/xml; charset=utf-8"
'  oHttReq.setRequestHeader "SOAPAction", URL & "#SendMail"
'  oHttReq.send parser.xml
'
'  parser.loadXML oHttReq.responseText
'
'  If Dir("c:\test.xml") <> "" Then Kill "c:\test.xml"
'  parser.Save "c:\test.xml"
'
'  Dim rslt As String
'
'  rslt = parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SendMailResponse/Result").Text
'  If rslt = "ok" Then
'    SaveLog "show:mail ok"
'    pSendEmail = True
'  Else
'    pSendEmail = False
'    SaveLog "Send Email Fallo !!!!!!!!!!"
'    SaveLog "show:mail failed"
'  End If
'End Function

Private Function pSaveReplyInDb(ByVal from As String, _
                                ByVal to_email As String, _
                                ByVal Subject As String, _
                                ByVal respuesta As String _
                                ) As Boolean
  Dim sqlstmt As String
  sqlstmt = "sp_srv_cvxi_saveEmailRespuesta " & c_id_mercadolibre & "," _
                                              & c_id_ml_aplicacion & "," _
                                              & c_id_idioma & "," _
                                              & m_mail.id & "," _
                                              & gDb.sqlString(from) & "," _
                                              & gDb.sqlString(to_email) & "," _
                                              & gDb.sqlString(Subject) & "," _
                                              & gDb.sqlString(respuesta)
  If Not gDb.Execute(sqlstmt, "pSaveReplyInDb") Then
    SaveLog "**"
    SaveLog "**"
    SaveLog "Error al guardar la respuesta para el email " & m_mail.id
    SaveLog "Comunidad: MercadoLibre"
    SaveLog "Aplicacion: Emails de MercadoLibre"
    SaveLog "Clase: " & C_Module
    SaveLog "From:" & from
    SaveLog "To:" & to_email
    SaveLog "Subject:" & Subject
    SaveLog "Body:" & vbCrLf & vbCrLf & respuesta
    SaveLog "**"
    SaveLog "**"
  Else
    pSaveReplyInDb = True
  End If

End Function

Private Function pGetValorByMacro(ByVal macro As String, ByVal texto As cTexto) As String
  Dim textoItem As cTextoItem
  For Each textoItem In texto.Items
    If textoItem.codigoMacro = macro Then
      pGetValorByMacro = LTrim$(textoItem.valor)
      Exit Function
    End If
  Next
End Function

Private Function pGetParam(ByVal macro As String, ByVal param As Long) As String
  Dim n As Long
  Dim i As Long
  Dim startPos As Long
  Dim endPos As Long
  Dim params As Variant
  Dim strParams As String
  Dim macroName As String
  
  i = 1
  n = 0
  Do While i <= Len(macro)
  
    If startPos = 0 Then
      If Mid$(macro, i, 1) = "(" Then
        startPos = i
      End If
    Else
      If Mid$(macro, i, 1) = ")" Then
        If n = 0 Then
          endPos = i - 1
          strParams = Mid$(macro, startPos + 1, endPos - startPos)
          params = Split(strParams, ",")
          If param - 1 > UBound(params) Then
            macroName = Left$(macro, startPos)
            Err.Raise vbObjectError + 1, C_Module, "El parametro solicitado esta fuera del rango de parametros indicados en la macro. Codigo de la macro: " & macro & " parametros " & strParams & vbCrLf & "Email Id: " & m_mail.id
          End If
          
          pGetParam = params(param - 1)
          Exit Do
          
        Else
          n = n - 1
        End If
      Else
        If Mid$(macro, i, 1) = "(" Then
          n = n + 1
        End If
      End If
    End If
    
    i = i + 1
  Loop
End Function

Private Function pGetMacroCall(ByVal macro As String) As String
  Dim n As Long
  Dim i As Long
  Dim startPos  As Long
  Dim endPos    As Long
  Dim macroCall As String
  
  i = 1
  n = 0
  Do While i <= Len(macro)
  
    If startPos = 0 Then
      If Mid$(macro, i, 1) = "(" Then
        startPos = i
      End If
    Else
      If Mid$(macro, i, 1) = ")" Then
        If n = 0 Then
          endPos = i
          macroCall = Left$(macro, endPos)
          pGetMacroCall = macroCall
          Exit Do
          
        Else
          n = n - 1
        End If
      Else
        If Mid$(macro, i, 1) = "(" Then
          n = n + 1
        End If
      End If
    End If
    
    i = i + 1
  Loop
End Function

Private Function pGetRespuestaPlantilla(ByVal codigo As String, _
                                        ByRef texto As String) As Boolean
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_srv_cvxi_getEmailRespuestaByCodigo " & gDb.sqlString(codigo)
  If Not gDb.OpenRs(sqlstmt, rs) Then Exit Function
  
  texto = gDb.ValField(rs.fields, cscCmirpTexto)
  
  pGetRespuestaPlantilla = True
End Function

Private Function pGetValorHtmlByMacro(ByVal macro As String, ByVal texto As cTexto) As String
  Dim textoItem As cTextoItem
  For Each textoItem In texto.Items
    If textoItem.codigoMacro = macro Then
      If LenB(textoItem.valorHtml) Then
        pGetValorHtmlByMacro = textoItem.valorHtml
      Else
        pGetValorHtmlByMacro = textoItem.valor & vbCrLf
      End If
      Exit Function
    End If
  Next
End Function

Private Function pExtractHtml(ByVal htmlcode As String) As String
  pExtractHtml = htmlcode
  
  Dim rgExp   As RegExp
  Dim matches As MatchCollection
  Dim match   As match
  
  Set rgExp = New RegExp
  rgExp.IgnoreCase = True
  rgExp.Global = True
  rgExp.Pattern = "<[\w\""\ '\#\* \=\',\.\\\(\)\/\-\$\{\}\[\]\|\*\?\+\^\&\:\%\;\!]+>"
  
  Set matches = rgExp.Execute(htmlcode)
  For Each match In matches
    htmlcode = Replace$(htmlcode, match.Value, "")
  Next
  
  ' Caso especial mailto
  rgExp.Pattern = "<a href=mailto:.*>"
  
  Set matches = rgExp.Execute(htmlcode)
  For Each match In matches
    htmlcode = Replace$(htmlcode, match.Value, "")
  Next
  
  pExtractHtml = htmlcode

End Function

Private Function pGetEmailTest() As String
  pGetEmailTest = IniGet(c_k_EmailTest, "")
End Function

Private Function pGetEmailBcc() As String
  pGetEmailBcc = IniGet(c_k_EmailBcc, "")
End Function

Private Function pHasReply(ByVal cmie_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  ' TODO:
  ' Ante cualquier error respondemos que no tiene respuesta
  ' por que es mejor responder dos veces ne no que responder
  ' esto queda confirmar por juan
  '
  pHasReply = False
  
  sqlstmt = "sp_srv_cvxi_hasReply " _
                 & cmie_id & "," _
                 & c_id_mercadolibre & "," _
                 & c_id_ml_aplicacion & "," _
                 & c_id_idioma
  
  If Not gDb.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  pHasReply = rs.fields.Item(0).Value <> 0
  
End Function

Private Function pLoadTextos() As Boolean
  
  ClearColl
  
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_srv_cvxi_getTextos " & c_id_mercadolibre & ", " & c_id_ml_aplicacion & ", " & c_id_idioma
  If Not gDb.OpenRs(sqlstmt, rs) Then Exit Function
  
  Dim texto As cTexto
  
  While Not rs.EOF
  
    Set texto = New cTexto
        
    texto.id = gDb.ValField(rs.fields, "cmit_id")
    texto.nombre = gDb.ValField(rs.fields, "cmit_nombre")
    texto.codigo = gDb.ValField(rs.fields, "cmit_codigo")
    texto.cmia_id = gDb.ValField(rs.fields, "cmia_id")
    texto.cmiea_id = gDb.ValField(rs.fields, "cmiea_id")
    texto.cmi_id = gDb.ValField(rs.fields, "cmi_id")
    texto.idm_id = gDb.ValField(rs.fields, "idm_id")
        
    If Not pLoadTextoItems(texto) Then Exit Function
        
    Textos.Add texto, "k" & texto.id
  
    rs.MoveNext
  Wend
  
  pLoadTextos = True
End Function

Private Function pLoadTextoItems(ByVal texto As cTexto) As Boolean
    
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_srv_cvxi_getTextoItems " & texto.id
  If Not gDb.OpenRs(sqlstmt, rs) Then Exit Function
  
  Dim textoItem As cTextoItem
  
  While Not rs.EOF
  
    Set textoItem = New cTextoItem
    
    pLoadTextoFromDb textoItem, rs
    
    texto.Items.Add textoItem, "k" & textoItem.id
  
    rs.MoveNext
  Wend
  
  pLoadTextoItems = True
End Function

Private Function pLoadTextoFromDb(ByVal textoItem As cTextoItem, ByVal rs As ADODB.Recordset) As Boolean
  With textoItem
    
    .id = gDb.ValField(rs.fields, "cmiti_id")
    .codigo = gDb.ValField(rs.fields, "cmiti_codigo")
    .codigoMacro = gDb.ValField(rs.fields, "cmiti_codigomacro")
    .delimitador = gDb.ValField(rs.fields, "cmiti_delimitador")
    .id_padre = gDb.ValField(rs.fields, "cmiti_id_padre")
    .nombre = gDb.ValField(rs.fields, "cmiti_nombre")
    .texto = gDb.ValField(rs.fields, "cmiti_texto")
    .tieneValor = gDb.ValField(rs.fields, "cmiti_tienevalor")
    .esBooleano = gDb.ValField(rs.fields, "cmiti_booleano")
  
  End With
End Function

Private Sub pFillTextos(ByVal idCliente As String, _
                        ByVal nombre As String, _
                        ByVal apellido As String, _
                        ByVal nombreArticulo As String, _
                        ByVal idArticulo As String, _
                        ByVal preciostr As String, _
                        ByVal cantidadstr As String, _
                        ByVal email As String, _
                        ByVal telefono As String, _
                        ByVal localidad As String, _
                        ByVal provincia As String, _
                        ByVal fecha As Date)
  
  pSetTextoItem "@@apodo", idCliente
  pSetTextoItem "@@cantidad", cantidadstr
  pSetTextoItem "@@ciudad_comprador", localidad
  pSetTextoItem "@@nombre_comprador", pCapitalizar(nombre) & " " & pCapitalizar(apellido)
  pSetTextoItem "@@email_comprador", email
  pSetTextoItem "@@pais_comprador", ""
  pSetTextoItem "@@precio", preciostr
  pSetTextoItem "@@provincia_comprador", provincia
  pSetTextoItem "@@nombre_vendedor", gCMIUser
  pSetTextoItem "@@texto_mail", ""
  pSetTextoItem "@@telefono_comprador", telefono
  pSetTextoItem "@@tel_interno_comprador", ""
  pSetTextoItem "@@es_mail_venta", 1
  pSetTextoItem "@@nombre_producto", nombreArticulo
  pSetTextoItem "@@codigo_producto", idArticulo

End Sub

Private Sub pSetTextoItem(ByVal codigo_macro As String, ByVal Value As String)
  Dim texto As cTexto
  Dim Item  As cTextoItem
  
  For Each texto In Textos
    For Each Item In texto.Items
      If Item.codigoMacro = codigo_macro Then
        Item.valor = Value
      End If
    Next
  Next
End Sub

Private Sub ClearColl()

  While Textos.count
    While Textos.Item(1).Items.count
      Textos.Item(1).Items.Remove 1
    Wend
    Textos.Remove 1
  Wend
End Sub

Private Sub Class_Initialize()
  On Error Resume Next
  Set m_Textos = New Collection
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  Set m_Textos = Nothing
End Sub

Private Function pCapitalizar(ByVal Value As String) As String
  Value = Trim(Value)
  Value = UCase$(Mid$(Value, 1, 1)) & LCase$(Mid$(Value, 2, Len(Value) - 1))
  pCapitalizar = Value
End Function

