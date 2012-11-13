Attribute VB_Name = "mInfo"
Option Explicit

'style = "<STYLE>.title {font-size: 14px; font-family: arial; background-color: #bbbbff;} p {font-size: 12px; font-family: arial;} table {font-size: 14px; font-family: arial; border-style: solid; border-width: 1px; border-color: #aaaaff;} .pregunta {background-color: #bbbbff;} </STYLE>"
'style = "<STYLE>.title {font-size: 14px; font-family: arial; background-color: #bbbbff;} p {font-size: 12px; font-family: arial;} table {font-size: 14px; font-family: arial; border-style: solid; border-width: 1px; border-color: #aaaaff;} .pregunta {background-color: #bbbbff;} </STYLE>"
'"<STYLE>h1 {font-size: 14px; font-family: arial; background-color: #bbbbff;} p {font-size: 12px; font-family: arial;} table {font-size: 14px; font-family: arial; border-style: solid; border-width: 1px; border-color: #aaaaff;} .pregunta {background-color: #bbbbff;} </STYLE>
'"<STYLE>h1 {font-size: 14px; font-family: arial; background-color: #bbbbff;} p {font-size: 12px; font-family: arial;} table {font-size: 14px; font-family: arial; border-style: solid; border-width: 1px; border-color: #aaaaff;} .pregunta {background-color: #bbbbff;} </STYLE>
'"<STYLE>h1 {font-size: 14px; font-family: arial; background-color: #bbbbff;} p {font-size: 12px; font-family: arial;} table {font-size: 14px; font-family: arial; border-style: solid; border-width: 1px; border-color: #aaaaff;} .pregunta {background-color: #bbbbff;} </STYLE>
'"<STYLE>h1 {font-size: 14px; font-family: arial; background-color: #bbbbff;} p {font-size: 12px; font-family: arial;} table {font-size: 14px; font-family: arial; border-style: solid; border-width: 1px; border-color: #aaaaff;} .pregunta {background-color: #bbbbff;} </STYLE>

Private Const C_STYLE = "<STYLE>" & _
                        "h1 {font-size: 14px; font-family: arial; background-color: #bbbbff;} " & _
                        "p {font-size: 12px; font-family: arial;} " & _
                        "table {font-size: 12px; font-family: arial; border-style: solid; border-width: 1px; border-color: #aaaaff;} " & _
                        ".pregunta {background-color: #ceeeee;} " & _
                        ".title {font-size: 14px; font-family: arial; background-color: #eeeeee;}" & _
                        "</STYLE>"

Public Sub ClearInfo()
  fMain.lvInfo.ListItems.Clear
End Sub

Public Sub ShowInfo( _
  ByVal nick As String, _
  ByVal pregunta As String, _
  ByVal preguntaId As String, _
  ByVal articuloId As String, _
  ByVal cmi_id As Long)
  
  With fMain.lvInfo.ListItems.Add(, , nick)
    .SubItems(1) = pregunta
    .SubItems(2) = preguntaId
    .SubItems(3) = articuloId
    .SubItems(4) = cmi_id
  End With
  
End Sub

Public Sub ShowHtmlInfo(ByVal html As String)
  fInfo.wb.Navigate2 pSaveHTMLToTempFile(C_STYLE & html)
  fInfo.Show , fMainMdi
End Sub

Public Sub ShowHtmlInfo2(ByVal html As String)
  fInfo.wb.Navigate2 pSaveHTMLToTempFile(C_STYLE & html)
End Sub

Public Sub ShowBlankInfo()
  fInfo.wb.Navigate2 pSaveHTMLToTempFile("")
  fInfo.Show , fMainMdi
End Sub

Public Sub ShowInfoPregunta(ByVal nick As String, _
                            ByVal preguntaId As String, _
                            ByVal articuloId As String, _
                            ByVal cmi_id As Long)
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  Dim pr_nombre   As String
  Dim pr_descrip  As String
  Dim pr_codigo   As String
  Dim pr_aliasweb As String
  Dim preguntas1  As String
  Dim preguntas2  As String
  
  Dim cli_nombre As String
  Dim cli_tel    As String
  Dim cli_email  As String
  Dim cli_dir    As String
  
  sqlstmt = "sp_srv_cvxi_getProductoByCodigoComunidad " _
                      & cmi_id & "," _
                      & gDb.sqlString(articuloId)
  If Not gDb.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then
    pr_nombre = "No se encontro un articulo con codigo " & articuloId
  Else
  
    pr_nombre = gDb.ValField(rs.fields, "nombre")
    pr_codigo = gDb.ValField(rs.fields, "codigo")
    pr_descrip = gDb.ValField(rs.fields, "descrip")
    pr_aliasweb = gDb.ValField(rs.fields, "alias")

  End If
  
  sqlstmt = "sp_srv_cvxi_getClienteByNick " _
                      & cmi_id & "," _
                      & gDb.sqlString(nick)
  If Not gDb.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then
    cli_nombre = "El nick " & nick & " aun no esta registrado como cliente "
  Else
  
    cli_nombre = gDb.ValField(rs.fields, "nombre")
    cli_tel = gDb.ValField(rs.fields, "telefono")
    cli_email = gDb.ValField(rs.fields, "email")
    cli_dir = gDb.ValField(rs.fields, "direccion")

  End If
  
  sqlstmt = "sp_srv_cvxi_getPreguntasByCodigoYNick " _
                      & cmi_id & "," _
                      & gDb.sqlString(nick) & "," _
                      & gDb.sqlString(articuloId)
  If Not gDb.OpenRs(sqlstmt, rs) Then Exit Sub
  
  While Not rs.EOF
    
    preguntas1 = preguntas1 & _
                   "<tr class=""pregunta""><td>" & gDb.ValField(rs.fields, "pregunta") & _
                   "<tr><td>" & gDb.ValField(rs.fields, "respuesta") & _
                   ""
    rs.MoveNext
  Wend

  sqlstmt = "sp_srv_cvxi_getPreguntasByNick " _
                      & cmi_id & "," _
                      & gDb.sqlString(nick) & "," _
                      & gDb.sqlString(articuloId)
  If Not gDb.OpenRs(sqlstmt, rs) Then Exit Sub

  While Not rs.EOF
    
    preguntas2 = preguntas2 & _
                   "<tr class=""pregunta""><td>" & gDb.ValField(rs.fields, "pregunta") & _
                   "<tr><td>" & gDb.ValField(rs.fields, "respuesta") & _
                   ""
    rs.MoveNext
  Wend

  sqlstmt = "sp_srv_cvxi_getLeyendas " _
                      & cmi_id & "," _
                      & gDb.sqlString(articuloId)
  If Not gDb.OpenRs(sqlstmt, rs) Then Exit Sub

  Dim respuestas As String
  Dim iRespuestas As Long
  
  While Not rs.EOF
    
    iRespuestas = iRespuestas + 1
    respuestas = respuestas & vbCrLf & _
                   "<tr class='pregunta'>" & _
                   "<td><a href='#respuesta:" & gDb.ValField(rs.fields, "texto") & "'>" & gDb.ValField(rs.fields, "nombre") & "</a>" & _
                   "<td><span onclick=""setVisibleState('tr_" & iRespuestas & "',true)"">[+]</span></td>" & _
                   "<td><span onclick=""setVisibleState('tr_" & iRespuestas & "',false)"">[-]</span></td>" & _
                   "<tr id='tr_" & iRespuestas & "'><td colspan='3'>" & gDb.ValField(rs.fields, "texto") & _
                   ""
    rs.MoveNext
  Wend

  Dim html As String
  
  Dim head As String
  
  head = "<head>" & pGetJavaCode() & vbCrLf & C_STYLE & vbCrLf & "</head><body onload='javascript:hideRespuestas();'>"
  
  html = head & _
         "<table width='100%'><tr><td colspan='5' class='title'>" & pr_nombre & _
         "<tr><td>Codigo: " & pr_codigo & _
         "<tr><td>Alias: <b>" & pr_aliasweb & "</b>" & _
         "<tr><td>Descripcion: " & pr_descrip & _
         "</table><br/><table width='100%'><tr><td colspan='5' class='title'>Preguntas sobre este articulo de nick: " & nick & _
         preguntas1 & "</table>" & _
         "<br/><table width='100%'><tr><td colspan='5' class='title'>Otras preguntas de este nick" & _
         preguntas2 & "</table>" & _
         "<br/><table width='100%'><tr><td colspan='5' class='title'>" & cli_nombre & _
         "<tr><td>Tel: " & cli_tel & _
         "<tr><td>Email: " & cli_email & _
         "<tr><td>Dir.: " & cli_dir & _
         "</table><br/><table width='100%'><tr><td colspan='5' class='title'>Respuestas Automaticas" & _
         "<form name='fRespuestas'>" & _
         "<input type='hidden' name='nRespuestas' value='" & iRespuestas & "'>" & _
         respuestas & "</table><p><p></form>"

  fInfo.wb.Navigate2 pSaveHTMLToTempFile(html)
  fInfo.Show , fMainMdi
End Sub

Private Function pSaveHTMLToTempFile(html) As String
  On Error Resume Next
  
  Dim f As Integer
  Dim File As String
  
  File = GetValidPath(Environ$("TEMP")) & "tmp-" & Timer & ".html"
  f = FreeFile
  Open File For Append As f
  Print #f, html
  Close f
  
  Err.Clear
  
  pSaveHTMLToTempFile = File
End Function

Private Function pGetJavaCode() As String
  Dim java_code As String
  
  java_code = "<SCRIPT LANGUAGE=JAVASCRIPT>" & vbCrLf
  java_code = java_code & "<!--" & vbCrLf
  java_code = java_code & "function hideRespuestas()" & vbCrLf
  java_code = java_code & "{" & vbCrLf
  java_code = java_code & "   for (var i=1; i<=document.fRespuestas.nRespuestas.value; ++i) " & vbCrLf
  java_code = java_code & "   {" & vbCrLf
  java_code = java_code & "     setVisibleState('tr_' + i, false);" & vbCrLf
  java_code = java_code & "   }" & vbCrLf
  java_code = java_code & "}" & vbCrLf
  java_code = java_code & "function setVisibleState(id, visible) " & vbCrLf
  java_code = java_code & "{" & vbCrLf
  java_code = java_code & "   dis = visible ? '' : 'none';" & vbCrLf
  java_code = java_code & "   document.getElementById(id).style.display=dis;" & vbCrLf
  java_code = java_code & "}" & vbCrLf
  java_code = java_code & "//-->" & vbCrLf
  java_code = java_code & "</SCRIPT>" & vbCrLf
  
  pGetJavaCode = java_code
End Function
