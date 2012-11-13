VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cEmailMercadoLibre"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Private Const C_Module = "cEmailMercadoLibre"

Private Const c_id_mercadolibre As Long = 1 ' Comunidad MercadoLibre
Private Const c_id_aplicacion   As Long = 1 ' Aplicacion Emial MercadoLibre
Private Const c_id_idioma       As Long = 1 ' Idioma Español

Private Const cscCmirpTexto     As String = "cmirp_texto"
Private Const cscCmirpFrom      As String = "cmirp_from"
Private Const cscCmirpSubject   As String = "cmirp_subject"

' XML Soap commands
Private Const cmdSendMail = _
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


Private Const cmdSetMailSeen = _
    "<?xml version=""1.0"" encoding=""ISO-8859-1""?>" & _
    "<SOAP-ENV:Envelope SOAP-ENV:encodingStyle=""http://schemas.xmlsoap.org/soap/encoding/""" & _
             " xmlns:SOAP-ENV=""http://schemas.xmlsoap.org/soap/envelope/""" & _
             " xmlns:xsd=""http://www.w3.org/2001/XMLSchema""" & _
             " xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance""" & _
             " xmlns:SOAP-ENC=""http://schemas.xmlsoap.org/soap/encoding/""" & _
             " xmlns:tns=""urn:qbcommunitymail"">" & _
        "<SOAP-ENV:Body>" & _
            "<SetMailSeen xmlns=""urn:qbcommunitymail"" xsi:type=""tns:SetMailSeen"">" & _
            "<Host xsi:type=""xsd:string""></Host><User xsi:type=""xsd:string""></User>" & _
            "<Pwd xsi:type=""xsd:string""></Pwd><Msgno xsi:type=""xsd:string""></Msgno>" & _
        "</SetMailSeen></SOAP-ENV:Body></SOAP-ENV:Envelope>"

Private m_Textos As Collection
Private m_bLoad  As Boolean

Private m_mail As cMail

Private Property Get Textos() As Collection
  Set Textos = m_Textos
End Property

Public Function ProcessMail(ByVal db As Object, _
                            ByVal mail As cMail, _
                            ByVal Server As String, _
                            ByVal User As String, _
                            ByVal pwd As String, _
                            ByVal email_server As String, _
                            ByVal email_user As String, _
                            ByVal email_pwd As String) As Boolean

  On Error GoTo ControlError
    
  If Not pHasReply(db, mail.id) Then
  
    'If InStr(1, LCase$(mail.subject), "has vendido") <> 0 Then Stop

    Set m_mail = mail
        
    If Not m_bLoad Then
      If Not pLoadTextos(db) Then Exit Function
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
    
    For Each texto In Textos
    
      For Each textoItem In texto.Items
        DoEvents
        
        If gClose Then Exit Function
      
        pProcess db, texto, textoItem, 1, 0
        
      Next
    Next
    
    If Not pReplyEmail(db, _
                       Server, _
                       User, _
                       pwd, _
                       email_server, _
                       email_user, _
                       email_pwd) Then Exit Function
  
  End If
  
  ProcessMail = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "ProcessMail", C_Module, ""
ExitProc:
  Set m_mail = Nothing
End Function

Private Function pHasReply(ByVal db As cDataSource, ByVal cmie_id As Long) As Boolean
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
                 & c_id_aplicacion & "," _
                 & c_id_idioma
  
  If Not db.OpenRs(rs, sqlstmt) Then Exit Function
  If rs.EOF Then Exit Function
  
  pHasReply = rs.Fields.Item(0).Value <> 0
  
End Function

Private Function pReplyEmail(ByVal db As cDataSource, _
                             ByVal Server As String, _
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
                              
  If Not db.OpenRs(rs, sqlstmt) Then Exit Function
  
  Dim respuestaHtml As String
  Dim respuestaText As String
  Dim bHaveToReply  As Boolean
  Dim texto         As cTexto
  
  While Not rs.EOF
  
    For Each texto In Textos
    
      ' Solo textos que pertencen a la misma cuenta o son genericos
      '
      If texto.cmiea_id = csNo_Id Or texto.cmiea_id = m_mail.cmiea_id Then
    
        If Not pProcessRespuestaPlantilla( _
                            db, _
                            texto, _
                            db.ValField(rs.Fields.Item(cscCmirpTexto)), _
                            respuestaHtml, _
                            bHaveToReply) Then Exit Function
        If bHaveToReply Then
        
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
                              db.ValField(rs.Fields.Item(cscCmirpFrom)), _
                              pGetEmailAddress(texto), _
                              db.ValField(rs.Fields.Item(cscCmirpSubject)), _
                              HTMLEncode(respuestaHtml), _
                              respuestaText) Then
              success = True
              If n > 1 Then
                SaveLog "Re Send tuvo exito !!!!", True
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
            SaveLog "Send Email fallo en todos sus intentos !!!!!", True
            Exit Function
          End If
          
          pSaveReplyInDb db, _
                         db.ValField(rs.Fields.Item(cscCmirpFrom)), _
                         pGetEmailAddress(texto), _
                         db.ValField(rs.Fields.Item(cscCmirpSubject)), _
                         HTMLEncode(respuestaHtml)
          
          pCreatePedidoVenta db
          
        End If
      End If
    Next
    
    rs.MoveNext
  Wend
  
  pReplyEmail = True
End Function

Private Function pCreatePedidoVenta(ByVal db As cDataSource) As Boolean
  Dim sqlstmt As String
  sqlstmt = "sp_srv_cvxi_pedidoVentaSave " _
                       & m_mail.id & "," _
                       & c_id_mercadolibre & "," _
                       & c_id_aplicacion
  If Not db.Execute(sqlstmt, "pCreatePedidoVenta") Then Exit Function
  pCreatePedidoVenta = True
End Function

Private Function pSaveReplyInDb(ByVal db As cDataSource, _
                                ByVal from As String, _
                                ByVal to_email As String, _
                                ByVal subject As String, _
                                ByVal respuesta As String _
                                ) As Boolean
  Dim sqlstmt As String
  sqlstmt = "sp_srv_cvxi_saveEmailRespuesta " & c_id_mercadolibre & "," _
                                              & c_id_aplicacion & "," _
                                              & c_id_idioma & "," _
                                              & m_mail.id & "," _
                                              & db.sqlString(from) & "," _
                                              & db.sqlString(to_email) & "," _
                                              & db.sqlString(subject) & "," _
                                              & db.sqlString(respuesta)
  If Not db.Execute(sqlstmt, "pSaveReplyInDb") Then
    SaveLog "**"
    SaveLog "**"
    SaveLog "Error al guardar la respuesta para el email " & m_mail.id
    SaveLog "Comunidad: MercadoLibre"
    SaveLog "Aplicacion: Emails de MercadoLibre"
    SaveLog "Clase: " & C_Module
    SaveLog "From:" & from
    SaveLog "To:" & to_email
    SaveLog "Subject:" & subject
    SaveLog "Body:" & vbCrLf & vbCrLf & respuesta
    SaveLog "**"
    SaveLog "**"
  Else
    pSaveReplyInDb = True
  End If

End Function

Private Function pProcessRespuestaPlantilla(ByVal db As cDataSource, _
                                            ByVal texto As cTexto, _
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
    
      If Not pGetRespuestaPlantilla(db, _
                                    pGetParam(macro, 1), _
                                    textoPlantilla) Then
        Exit Function
      End If
      If Not pProcessRespuestaPlantilla(db, _
                                        texto, _
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

Private Function pGetValorByMacro(ByVal macro As String, ByVal texto As cTexto) As String
  Dim textoItem As cTextoItem
  For Each textoItem In texto.Items
    If textoItem.codigoMacro = macro Then
      pGetValorByMacro = LTrim$(textoItem.valor)
      Exit Function
    End If
  Next
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

Private Function pGetRespuestaPlantilla(ByRef db As cDataSource, _
                                        ByVal codigo As String, _
                                        ByRef texto As String) As Boolean
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_srv_cvxi_getEmailRespuestaByCodigo " & db.sqlString(codigo)
  If Not db.OpenRs(rs, sqlstmt) Then Exit Function
  
  texto = db.ValField(rs.Fields(cscCmirpTexto))
  
  pGetRespuestaPlantilla = True
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

Private Function pLoadTextos(ByVal db As cDataSource) As Boolean
  
  ClearColl
  
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_srv_cvxi_getTextos " & c_id_mercadolibre & ", " & c_id_aplicacion & ", " & c_id_idioma
  If Not db.OpenRs(rs, sqlstmt) Then Exit Function
  
  Dim texto As cTexto
  
  While Not rs.EOF
  
    Set texto = New cTexto
        
    texto.id = db.ValField(rs.Fields("cmit_id"))
    texto.nombre = db.ValField(rs.Fields("cmit_nombre"))
    texto.codigo = db.ValField(rs.Fields("cmit_codigo"))
    texto.cmia_id = db.ValField(rs.Fields.Item("cmia_id"))
    texto.cmiea_id = db.ValField(rs.Fields.Item("cmiea_id"))
    texto.cmi_id = db.ValField(rs.Fields.Item("cmi_id"))
    texto.idm_id = db.ValField(rs.Fields.Item("idm_id"))
        
    If Not pLoadTextoItems(db, texto) Then Exit Function
        
    Textos.Add texto, "k" & texto.id
  
    rs.MoveNext
  Wend
  
  pLoadTextos = True
End Function

Private Function pLoadTextoItems(ByVal db As cDataSource, ByVal texto As cTexto) As Boolean
    
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_srv_cvxi_getTextoItems " & texto.id
  If Not db.OpenRs(rs, sqlstmt) Then Exit Function
  
  Dim textoItem As cTextoItem
  
  While Not rs.EOF
  
    Set textoItem = New cTextoItem
    
    pLoadTextoFromDb db, textoItem, rs
    
    texto.Items.Add textoItem, "k" & textoItem.id
  
    rs.MoveNext
  Wend
  
  pLoadTextoItems = True
End Function

Private Function pLoadTextoFromDb(ByVal db As cDataSource, ByVal textoItem As cTextoItem, ByVal rs As ADODB.Recordset) As Boolean
  With textoItem
    
    .id = db.ValField(rs.Fields.Item("cmiti_id"))
    .codigo = db.ValField(rs.Fields.Item("cmiti_codigo"))
    .codigoMacro = db.ValField(rs.Fields.Item("cmiti_codigomacro"))
    .delimitador = db.ValField(rs.Fields.Item("cmiti_delimitador"))
    .id_padre = db.ValField(rs.Fields.Item("cmiti_id_padre"))
    .nombre = db.ValField(rs.Fields.Item("cmiti_nombre"))
    .texto = db.ValField(rs.Fields.Item("cmiti_texto"))
    .tieneValor = db.ValField(rs.Fields.Item("cmiti_tienevalor"))
    .esBooleano = db.ValField(rs.Fields.Item("cmiti_booleano"))
  
  End With
End Function

' El parametro startPos me dice a partir de donde debo buscar
' en el cuerpo del mail ya que si el texto tiene un padre
' debo buscar despues de dicho padre
'
Private Function pProcess(ByVal db As cDataSource, _
                          ByVal texto As cTexto, _
                          ByVal textoItem As cTextoItem, _
                          ByRef startPos As Long, _
                          ByVal nCallStack As Long)
  
  'If textoItem.codigoMacro = "@@nombre_vendedor" Then Stop
  
  ' Si tiene padre se resuleve recursivamente
  '
  If textoItem.id_padre Then
    Dim textoItemPadre As cTextoItem
    If Not pGetTexto(db, textoItem.id_padre, texto, textoItemPadre) Then
      SaveLog "No pude obtener el texto item padre para el texto " & texto.nombre & "(" & texto.codigo & ")." & textoItem.nombre & "(" & textoItem.codigo & ")"
      Exit Function
    End If
    If Not pProcess(db, texto, textoItemPadre, startPos, nCallStack + 1) Then
      Exit Function
    End If
  End If
  
  Dim body As String
  Dim bBodyHtml As Boolean
  
  ' Procesamiento del texto
  '
  If LenB(m_mail.body_html) Then
    body = m_mail.body_html
    bBodyHtml = True
  Else
    body = m_mail.body_plain
    bBodyHtml = False
  End If
  
  Dim pos     As Long
  Dim endPos  As Long
  Dim valor   As String
  Dim bFound  As Boolean
  
  ' Busco el texto en el body desde la posicion inicial
  '
  pos = InStr(startPos, body, textoItem.texto)
  If pos <> 0 Then
  
    bFound = True
    startPos = pos + Len(textoItem.texto)
    
    If textoItem.tieneValor Then
      If LenB(textoItem.delimitador) Then
      
        ' Tratamiento del delimitador
        '
        If textoItem.delimitador = "<enter>" Then
          If bBodyHtml Then
            endPos = InStr(startPos, body, "<br>")
            If endPos = 0 Then
              endPos = InStr(startPos, body, "<br />")
              If endPos = 0 Then
                endPos = InStr(startPos, body, "<br/>")
                If endPos = 0 Then
                  endPos = InStr(startPos, body, "<p>")
                  If endPos = 0 Then
                    endPos = InStr(startPos, body, "</p>")
                    If endPos = 0 Then
                      endPos = InStr(startPos, body, "</ p>")
                    End If
                  End If
                End If
              End If
            End If
          Else
            endPos = InStr(startPos, body, vbCrLf)
            If endPos = 0 Then
              endPos = InStr(startPos, body, vbCr)
              If endPos = 0 Then
                endPos = InStr(startPos, body, vbLf)
                If endPos = 0 Then
                  endPos = InStr(startPos, body, pGetNextTextoItem(texto, textoItem).texto) - 1
                End If
              End If
            End If
          End If
        Else
          endPos = InStr(startPos, body, textoItem.delimitador)
        End If
        '
        ' Fin delimitador
        
        If endPos > 0 Then
          valor = Mid$(body, startPos, endPos - startPos)
        End If
      Else
        If textoItem.esBooleano Then
          valor = "1"
        Else
          valor = Mid$(body, startPos)
        End If
      End If

      If LenB(valor) Then
      
        ' Guardamos unicamente en la primer llamada
        '
        If nCallStack = 0 Then
        
          Dim valorHtml As String

          If bBodyHtml Then
            valorHtml = valor
            valor = pExtractHtml(valor)
          End If

          If Not pSaveEmialItem(db, _
                                m_mail.id, _
                                textoItem.texto, _
                                valor, _
                                valorHtml, _
                                textoItem.id, _
                                bBodyHtml _
                                ) Then Exit Function
          
          textoItem.valor = valor
          textoItem.valorHtml = valorHtml
          
        End If
      End If

    End If
  End If
  
  pProcess = bFound
  
End Function

Private Function pSaveEmialItem(ByVal db As cDataSource, _
                                ByVal cmie_id As Long, _
                                ByVal texto As String, _
                                ByVal valor As String, _
                                ByVal valorHtml As String, _
                                ByVal cmiti_id As Long, _
                                ByVal bBodyHtml As Boolean _
                                ) As Boolean
  Dim sqlstmt As String
  
  sqlstmt = "sp_srv_cvxi_savemailitem " & cmie_id & "," _
                                        & db.sqlString(texto) & "," _
                                        & db.sqlString(valor) & "," _
                                        & db.sqlString(valorHtml) & "," _
                                        & cmiti_id

  If Not db.Execute(sqlstmt, "pSaveEmailItem") Then Exit Function

  pSaveEmialItem = True
End Function

Private Function pGetNextTextoItem(ByVal texto As cTexto, ByVal textoItem As cTextoItem) As cTextoItem
  Dim rtn As cTextoItem
  Dim k   As Long
  For k = 1 To texto.Items.Count - 1
    If texto.Items(k) Is textoItem Then
      Set rtn = texto.Items(k + 1)
      Exit For
    End If
  Next
  
  If rtn Is Nothing Then
    Set rtn = New cTextoItem
    rtn.codigo = "QQ@@##$$""%&%&""&'¡?=" ' Para que no encuentre esto
  End If
  
  Set pGetNextTextoItem = rtn
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

Private Function pGetTexto(ByVal db As cDataSource, ByVal id As Long, ByVal texto As cTexto, ByRef textoItem As cTextoItem) As Boolean
  Dim rtn As cTextoItem
  
  On Error Resume Next
  
  Set rtn = texto.Items.Item("k" & id)
  Err.Clear
  
  If rtn Is Nothing Then
  
    Dim sqlstmt As String
    Dim rs As ADODB.Recordset
    
    sqlstmt = "sp_srv_cvxi_getTextoItem " & id
    If Not db.OpenRs(rs, sqlstmt) Then Exit Function
    
    Set rtn = New cTextoItem
    pLoadTextoFromDb db, rtn, rs
    
    texto.Items.Add rtn, "k" & rtn

  End If
  
  Set textoItem = rtn
  
  pGetTexto = Not rtn Is Nothing
End Function

Private Function pSendEmail(ByVal Server As String, _
                            ByVal User As String, _
                            ByVal pwd As String, _
                            ByVal email_server As String, _
                            ByVal email_user As String, _
                            ByVal email_pwd As String, _
                            ByVal from As String, _
                            ByVal to_email As String, _
                            ByVal subject As String, _
                            ByVal respuestaHtml As String, _
                            ByVal respuestaText As String _
                            ) As Boolean
                            
  Dim parser As DOMDocument
  
  ' TODO: remover la direccion de prueba del email
  Dim email_test As String
  email_test = pGetEmailTest()
    
  Dim email_bcc As String
  email_bcc = pGetEmailBcc()
  
  If email_test <> "" Then to_email = email_test
  
'  email_bcc = "contacto@todoencartuchos.com"
'  to_email = "contacto@todoencartuchos.com"
  
  Set parser = New DOMDocument
  
  parser.loadXML cmdSendMail
  
  parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SendMail/Host").Text = email_server
  parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SendMail/User").Text = email_user
  parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SendMail/Pwd").Text = email_pwd
  parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SendMail/From").Text = from
  parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SendMail/To").Text = to_email
  parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SendMail/Bcc").Text = email_bcc
  parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SendMail/Subject").Text = subject
  parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SendMail/BodyHtml").Text = respuestaHtml
  parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SendMail/BodyText").Text = respuestaText
  
  
  gServer.SaveLog "show:sending mail"
  gServer.SaveLog "show:to [" & to_email & "] "
  gServer.SaveLog "show:body: " & respuestaText
  
  Dim oHttReq As XMLHTTP
  Set oHttReq = New XMLHTTP
  
  Dim URL As String
  
  '-------------------------------------------------------------
  '-------------------------------------------------------------
  '
  ' EMAIL
  '
  '-------------------------------------------------------------
  '-------------------------------------------------------------
  
  URL = IIf(Right$(Server, 1) = "/", Server, Server & "/") & "mailservice.php"
  'url = IIf(Right$(Server, 1) = "\", Server, Server & "\") & "mailservice_test.php"
  
  oHttReq.Open "POST", URL, False
  oHttReq.SetRequestHeader "Content-Type", "text/xml; charset=utf-8"
  oHttReq.SetRequestHeader "SOAPAction", URL & "#SendMail"
  oHttReq.Send parser.xml
  
  parser.loadXML oHttReq.ResponseText

  If Dir("c:\test.xml") <> "" Then Kill "c:\test.xml"
  parser.Save "c:\test.xml"
  
  Dim rslt As String
  
  rslt = parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SendMailResponse/Result").Text
  If rslt = "ok" Then
    gServer.SaveLog "show:mail ok"
    pSetSeenFlag Server, User, pwd, email_server, email_user, email_pwd
    pSendEmail = True
  Else
    pSendEmail = False
    SaveLog "Send Email Fallo !!!!!!!!!!", True
    gServer.SaveLog "show:mail failed"
  End If
End Function

Private Function pSetSeenFlag(ByVal Server As String, _
                              ByVal User As String, _
                              ByVal pwd As String, _
                              ByVal email_server As String, _
                              ByVal email_user As String, _
                              ByVal email_pwd As String)
  Dim parser As DOMDocument
  
  Set parser = New DOMDocument

  parser.loadXML cmdSetMailSeen
  
  parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SetMailSeen/Host").Text = email_server
  parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SetMailSeen/User").Text = email_user
  parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SetMailSeen/Pwd").Text = email_pwd
  parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SetMailSeen/Msgno").Text = m_mail.mailid

  Dim oHttReq As XMLHTTP
  Set oHttReq = New XMLHTTP
  
  Dim URL As String
  
  URL = IIf(Right$(Server, 1) = "/", Server, Server & "/") & "mailservice.php"
  'url = IIf(Right$(Server, 1) = "\", Server, Server & "\") & "mailservice_test.php"
  
  oHttReq.Open "POST", URL, False
  oHttReq.SetRequestHeader "Content-Type", "text/xml; charset=utf-8"
  oHttReq.SetRequestHeader "SOAPAction", URL & "#GetMailBody"
  
  oHttReq.Send parser.xml
  
  parser.loadXML oHttReq.ResponseText
  
  Dim rslt As String
  
  rslt = parser.selectSingleNode("/SOAP-ENV:Envelope/SOAP-ENV:Body/SetMailSeenResponse/Result/status").Text
  If rslt = "ok" Then
    pSetSeenFlag = True
  Else
    pSetSeenFlag = False
    SaveLog "Set Email Seen Fallo !!!!!!!!!!", True
  End If

End Function

Private Function pGetEmailTest() As String
  pGetEmailTest = IniGet(c_k_EmailTest, "")
End Function

Private Function pGetEmailBcc() As String
  pGetEmailBcc = IniGet(c_k_EmailBcc, "")
End Function

Private Function pGetEmailAddress(ByVal texto As cTexto) As String
  Dim rtn As String
    
  rtn = pGetValorByMacro(c_email_comprador, texto)
  
  If rtn = "" Then
  
    Err.Raise vbObjectError + 1, C_Module, "La direccion de email del comprador esta vacia en el mail: " & m_mail.id
  
  End If
  
  pGetEmailAddress = rtn
  
End Function

Private Function pBuildTextVersion(ByRef respuesta As String) As String
  pBuildTextVersion = pExtractHtml(respuesta)
End Function

Private Sub ClearColl()

  While Textos.Count
    While Textos.Item(1).Items.Count
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

