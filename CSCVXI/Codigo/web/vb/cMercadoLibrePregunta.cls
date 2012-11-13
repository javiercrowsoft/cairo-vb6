VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMercadoLibrePregunta"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Const c_cmi_id = 1 ' Comunidad internet MercadoLibre

Public Sub ReadPage()
  On Error Resume Next
  
  Dim formObj As Object
  Dim body As String
  
  DoEvents: DoEvents: DoEvents: DoEvents: DoEvents
  
  Set formObj = fMain.wb.Document.Forms("pend_ques")
   
  body = formObj.innerHTML
  
  ClearInfo
  
  Dim i           As Long
  Dim nick        As String
  Dim pregunta    As String
  Dim preguntaId  As String
  Dim articuloId  As String
  Dim fecha       As Date
  Dim c           As String
  Dim j           As Long
  Dim q           As Long
  Dim bFound      As Boolean
  Dim k           As Long
  Dim t           As Long
  Dim bFirstNick  As Boolean
  Dim lastI       As Long
  Dim r           As Long
  
  i = 0
  
  Do
  
    r = InStr(i + 1, body, "name=as_question>")
    i = InStr(i + 1, body, "http://www.mercadolibre.com.ar/jm/item?site=MLA&amp;id=")
    
    '
    ' Si antes del proximo nick hay otra pregunta la proceso
    '
    If i > r Then i = 0
    
    '
    ' Si no hay ni siquiera un nick no hay preguntas
    '
    If i = 0 And Not bFirstNick Then
      Exit Do
    End If
    
    If i <> 0 Then
    
      ' Al menos encontre un nick
      '
      bFirstNick = True
      
      i = i + 55
      j = 0
      Do
        j = j + 1
        c = Mid$(body, i + j, 1)
      Loop Until c = """"
      
      articuloId = Mid$(body, i, j)
    
      i = InStr(i + 1, body, "http://www.mercadolibre.com.ar/jm/profile?id=")
      If i = 0 Then Exit Do

      i = i + 45
    
      Do
        c = Mid$(body, i, 1)
        i = i + 1
      Loop Until c = ">"
      
      j = 0
      Do
        j = j + 1
        c = Mid$(body, i + j, 1)
      Loop Until c = "<"
      
      nick = Mid$(body, i, j)
      
      q = Len(nick)
      Do
      
        If Mid$(nick, q, 1) = "(" Then
        
          nick = Trim$(Mid$(nick, 1, q - 1))
        End If
                
        q = q - 1
      Loop Until q = 0
    
    Else
        
      '
      ' Si no encontre otro nick o articulo, busco mas preguntas del mismo nick
      ' ya que MercadoLibre las agrupa cuando son del mismo nick y articulo
      '
      i = lastI
      
      '
      ' Compruebo que exista una pregunta mas para leer
      '
      If InStr(i + 1, body, "name=as_question>") = 0 Then Exit Do
      
      Do
        c = Mid$(body, i, 1)
        i = i + 1
      Loop Until c = ">"
      
      j = 0
      Do
        j = j + 1
        c = Mid$(body, i + j, 1)
      Loop Until c = "<"
      
    End If
      
    i = InStr(i + 1, body, "Pregunta:")
    If i = 0 Then Exit Do
    
    i = i + 9
    
    For t = 1 To 3
      Do
        c = Mid$(body, i, 1)
        i = i + 1
      Loop Until c = ">"
    Next
    
    j = 0
    Do
      j = j + 1
      c = Mid$(body, i + j, 1)
    Loop Until c = "<"
    
    pregunta = Mid$(body, i, j)
    
    For t = 1 To 3
      Do
        c = Mid$(body, i, 1)
        i = i + 1
      Loop Until c = ">"
    Next
    
    j = 0
    Do
      j = j + 1
      c = Mid$(body, i + j, 1)
    Loop Until c = "<"
    
    fecha = pDateValue(Mid$(body, i, j))
    
    '
    ' Metodo 1 de buscar el id de pregunta
    '
    Dim h As Long
    Dim w As Long
    
    preguntaId = ""
    
    h = InStr(i + 1, body, "name=as_question")
    
    If h > 0 Then
      h = InStr(i + 1, body, "value=")
      If h > 0 Then
        h = h + 6
        w = 0
        Do
          c = Mid$(body, h + w, 1)
          w = w + 1
        Loop Until c = """" Or c = " "
        
        preguntaId = Mid$(body, h, w - 1)
        
      End If
    End If
        
    '
    ' Metodo 2 de buscar el id de pregunta
    '
    If preguntaId = "" Then
    
      For t = 1 To 10
        Do
          c = Mid$(body, i, 1)
          i = i + 1
        Loop Until c = ">"
      Next
      
      i = i + 14
      j = 0
      Do
        j = j + 1
        c = Mid$(body, i + j, 1)
      Loop Until c = " "
      
      preguntaId = Mid$(body, i, j)
        
    Else
    
      i = h + w + 29
      
    End If
        
    ShowLog "Pregunta", pregunta '--lng
    ShowLog "Nick", nick '--lng
    ShowLog "Fecha", fecha '--lng
    ShowLog "Articulo Id", articuloId '--lng
    ShowLog "Pregunta Id", preguntaId '--lng
    ShowLog "Pagina", "Pagina de preguntas" '--lng
    
    ShowInfo nick, pregunta, preguntaId, articuloId, c_cmi_id
    
    pSavePreguntaInDb preguntaId, _
                      nick, _
                      pregunta, _
                      articuloId, _
                      fecha
    
    bFound = True
    k = k + 1
    lastI = i
    
  Loop While i <> 0
   
  If bFound Then
    '--lng
    fMain.fSysTray.ShowBalloonTip _
       "Tiene " & k & " pregunta(s) por contestar.", "Hay preguntas pendientes", _
       NIIF_INFO
       
    pShowInfoPregunta
  End If
  
  If fMain.Visible = False Then
  
    fMain.tmRefresh.interval = 30000 ' 30 segundos
    fMain.tmRefresh.Enabled = True
    
  End If

  Err.Clear

End Sub

Public Sub ReadPageV2()
  On Error Resume Next
  
  Dim formObj As Object
  Dim body As String
  
  DoEvents: DoEvents: DoEvents: DoEvents: DoEvents
  
  Set formObj = fMain.wb.Document.body
   
  body = formObj.innerHTML
  
  ClearInfo
  
  Dim i           As Long
  Dim nick        As String
  Dim pregunta    As String
  Dim preguntaId  As String
  Dim articuloId  As String
  Dim fecha       As Date
  Dim c           As String
  Dim j           As Long
  Dim q           As Long
  Dim bFound      As Boolean
  Dim k           As Long
  Dim t           As Long
  Dim bFirstNick  As Boolean
  Dim lastI       As Long
  Dim r           As Long
  
  Dim endValueFound As Boolean
  
  i = 0
  
  Do
  
    i = InStr(i + 1, body, "<DT class=""ico quest"">Pregunta:")
    If i = 0 Then Exit Sub
              
    For t = 1 To 3
      Do
        c = Mid$(body, i, 1)
        i = i + 1
      Loop Until c = ">"
    Next
    
    j = 0
    Do
      j = j + 1
      c = Mid$(body, i + j, 1)
    Loop Until c = "<"
    
    pregunta = Trim$(Mid$(body, i, j))
    
    i = i + j
    
    For t = 1 To 2
      Do
        c = Mid$(body, i, 1)
        i = i + 1
      Loop Until c = ">"
    Next
    
    j = 0
    Do
      j = j + 1
      c = Mid$(body, i + j, 1)
    Loop Until c = "<"
    
    nick = Trim$(Mid$(body, i, j))
    
    i = i + j
    
    For t = 1 To 1
      Do
        c = Mid$(body, i, 1)
        i = i + 1
      Loop Until c = ">"
    Next
    
    j = 0
    Do
      j = j + 1
      c = Mid$(body, i + j, 1)
    Loop Until c = "<"
        
    fecha = pDateValue(Mid$(body, i, j))
    
    '
    ' articuloId
    '
    articuloId = ""
    i = i + j
    i = InStr(i, body, "name=itemId>")
    
    If i = 0 Then Exit Sub
    
    '
    ' vamos hacia atras buscando la apertura del tag
    '
    For j = i To 1 Step -1
      If Mid$(body, j, 1) = "<" Then
        Exit For
      End If
      '
      ' por control
      '
      If i - j > 1000 Then Exit Sub
    Next
    
    j = InStr(j, body, "value=")
    
    '
    ' control que j no sea 0 (no se encontro)
    ' ni que lo que se encontro este despues de i
    ' (el final del tag)
    '
    If j = 0 Then Exit Sub
    If j > i Then Exit Sub
    
    i = j + 6
    
    endValueFound = False
    
    For j = 1 To 1000
      c = Mid$(body, i + j, 1)
      If c = """" Or c = " " Then
        endValueFound = True
        Exit For
      End If
    Next
    
    '
    ' si no tengo el articulo id
    '
    If Not endValueFound Then Exit Sub
    
    articuloId = Mid$(body, i, j)
    
    i = i + j
    
    If Mid$(articuloId, 1, 3) = "MLA" Then
      articuloId = Mid$(articuloId, 4)
    End If
    
    '
    ' preguntaId
    '
    preguntaId = ""
    i = i + j
    i = InStr(i, body, "name=qId>")
    
    If i = 0 Then Exit Sub
    
    '
    ' vamos hacia atras buscando la apertura del tag
    '
    For j = i To 1 Step -1
      If Mid$(body, j, 1) = "<" Then
        Exit For
      End If
      '
      ' por control
      '
      If i - j > 1000 Then Exit Sub
    Next
    
    j = InStr(j, body, "value=")
    
    '
    ' control que j no sea 0 (no se encontro)
    ' ni que lo que se encontro este despues de i
    ' (el final del tag)
    '
    If j = 0 Then Exit Sub
    If j > i Then Exit Sub
    
    i = j + 6
    
    endValueFound = False
    
    For j = 1 To 1000
      c = Mid$(body, i + j, 1)
      If c = """" Or c = " " Then
        endValueFound = True
        Exit For
      End If
    Next
    
    '
    ' si no tengo el articulo id
    '
    If Not endValueFound Then Exit Sub
    
    preguntaId = Mid$(body, i, j)
        
    ShowLog "Pregunta", pregunta '--lng
    ShowLog "Nick", nick '--lng
    ShowLog "Fecha", fecha '--lng
    ShowLog "Articulo Id", articuloId '--lng
    ShowLog "Pregunta Id", preguntaId '--lng
    ShowLog "Pagina", "Pagina de preguntas" '--lng
    
    '
    ' debug
    '
    'MsgBox "Pregunta " & pregunta _
             & vbCrLf & "Nick " & nick _
             & vbCrLf & "Fecha " & fecha _
             & vbCrLf & "Articulo Id " & articuloId _
             & vbCrLf & "Pregunta Id " & preguntaId
    
    ShowInfo nick, pregunta, preguntaId, articuloId, c_cmi_id
    
    pSavePreguntaInDb preguntaId, _
                      nick, _
                      pregunta, _
                      articuloId, _
                      fecha
    
    bFound = True
    k = k + 1
    lastI = i
    
  Loop While i <> 0
   
  If bFound Then
    '--lng
    fMain.fSysTray.ShowBalloonTip _
       "Tiene " & k & " pregunta(s) por contestar.", "Hay preguntas pendientes", _
       NIIF_INFO
       
    pShowInfoPregunta
  End If
  
  If fMain.Visible = False Then
  
    fMain.tmRefresh.interval = 30000 ' 30 segundos
    fMain.tmRefresh.Enabled = True
    
  End If

  Err.Clear

End Sub

Public Sub BeforeNavigate()
  On Error Resume Next

  fMain.RefreshIcon 1, "Preguntas"

  Dim formObj As Object
  Dim body As String
  
  DoEvents: DoEvents: DoEvents: DoEvents: DoEvents
  
  Set formObj = fMain.wb.Document.Forms("pend_ques")
   
  body = formObj.innerHTML
  
  Dim i           As Long
  Dim nick        As String
  Dim pregunta    As String
  Dim preguntaId  As String
  Dim articuloId  As String
  Dim respuesta   As String
  Dim fecha       As Date
  Dim c           As String
  Dim j           As Long
  Dim q           As Long
  Dim bFound      As Boolean
  Dim k           As Long
  Dim t           As Long
  Dim bFirstNick  As Boolean
  Dim lastI       As Long
  Dim r           As Long
  Dim startResp   As Long
  Dim endResp     As Long
  
  i = 0
  
  Do
  
    '
    ' Cuando busco un articuloId tengo que saltear toda la respuesta
    ' por que cuando en la respuesta se pone el link a otro
    ' articulo, al buscar el link http://www.mercadolibre.com.ar/...
    ' encuentro lo que el usuario puso en la respuesta en lugar
    ' del link a la proxima pregunta y se rompe todo !!!
    '
  
    ' Obtengo donde empieza la respuesta
    '
    r = InStr(i + 1, body, "name=as_question>")
    startResp = InStr(r + 1, body, "<TEXTAREA")
    If startResp > 0 Then
      endResp = InStr(r + 1, body, "</TEXTAREA>")
    End If
    
    '
    ' Busco el link al articuloId
    '
    i = InStr(i + 1, body, "http://www.mercadolibre.com.ar/jm/item?site=MLA&amp;id=")
    
    '
    ' Si el link que encontre esta dentro de la respuesta, busco nuevamente
    '
    If i > startResp And i < endResp Then
      i = InStr(endResp + 1, body, "http://www.mercadolibre.com.ar/jm/item?site=MLA&amp;id=")
    End If
    
    '
    ' Si no hay ni siquiera un nick no hay preguntas
    '
    If i = 0 And Not bFirstNick Then
      Exit Do
    End If
            
    If i <> 0 Then
    
      ' Al menos encontre un nick
      '
      bFirstNick = True
      
      i = i + 55
      j = 0
      Do
        j = j + 1
        c = Mid$(body, i + j, 1)
      Loop Until c = """"
      
      articuloId = Mid$(body, i, j)
        
      i = InStr(i + 1, body, "http://www.mercadolibre.com.ar/jm/profile?id=")
      If i = 0 Then Exit Do

      i = i + 45
    
      Do
        c = Mid$(body, i, 1)
        i = i + 1
      Loop Until c = ">"
      
      j = 0
      Do
        j = j + 1
        c = Mid$(body, i + j, 1)
      Loop Until c = "<"
      
      nick = Mid$(body, i, j)
      
      q = Len(nick)
      Do
      
        If Mid$(nick, q, 1) = "(" Then
        
          nick = Trim$(Mid$(nick, 1, q - 1))
        End If
                
        q = q - 1
      Loop Until q = 0
    
    Else
        
      '
      ' Si no encontre otro nick o articulo, busco mas preguntas del mismo nick
      ' ya que MercadoLibre las agrupa cuando son del mismo nick y articulo
      '
      i = lastI
      
      '
      ' Compruebo que exista una pregunta mas para leer
      '
      If InStr(i + 1, body, "name=as_question>") = 0 Then Exit Do
      
      Do
        c = Mid$(body, i, 1)
        i = i + 1
      Loop Until c = ">"
      
      j = 0
      Do
        j = j + 1
        c = Mid$(body, i + j, 1)
      Loop Until c = "<"
      
    End If
      
    i = InStr(i + 1, body, "Pregunta:")
    If i = 0 Then Exit Do
    
    i = i + 9
    
    For t = 1 To 3
      Do
        c = Mid$(body, i, 1)
        i = i + 1
      Loop Until c = ">"
    Next
    
    j = 0
    Do
      j = j + 1
      c = Mid$(body, i + j, 1)
    Loop Until c = "<"
    
    pregunta = Mid$(body, i, j)
    
    For t = 1 To 3
      Do
        c = Mid$(body, i, 1)
        i = i + 1
      Loop Until c = ">"
    Next
    
    j = 0
    Do
      j = j + 1
      c = Mid$(body, i + j, 1)
    Loop Until c = "<"
    
    fecha = pDateValue(Mid$(body, i, j))
        
    '
    ' Metodo 1 de buscar el id de pregunta
    '
    Dim h As Long
    Dim w As Long
    
    preguntaId = ""
    
    h = InStr(i + 1, body, "name=as_question")
    
    If h > 0 Then
      h = InStr(i + 1, body, "value=")
      If h > 0 Then
        h = h + 6
        w = 0
        Do
          c = Mid$(body, h + w, 1)
          w = w + 1
        Loop Until c = """" Or c = " "
        
        preguntaId = Mid$(body, h, w - 1)
        
      End If
    End If
        
    '
    ' Metodo 2 de buscar el id de pregunta
    '
    If preguntaId = "" Then
    
      For t = 1 To 10
        Do
          c = Mid$(body, i, 1)
          i = i + 1
        Loop Until c = ">"
      Next
      
      i = i + 14
      j = 0
      Do
        j = j + 1
        c = Mid$(body, i + j, 1)
      Loop Until c = " "
      
      preguntaId = Mid$(body, i, j)
        
    Else
    
      i = h + w + 29
      
    End If
    
    For t = 1 To 1
      Do
        c = Mid$(body, i, 1)
        i = i + 1
      Loop Until c = ">"
    Next
    
    j = 0
    Do
      j = j + 1
      c = Mid$(body, i + j, 1)
    Loop Until c = "<"
    
    respuesta = Mid$(body, i, j)
    
    ShowLog "Respuesta", respuesta '--lng
    ShowLog "Pregunta", pregunta '--lng
    ShowLog "Nick", nick '--lng
    ShowLog "Fecha", fecha '--lng
    ShowLog "Articulo Id", articuloId '--lng
    ShowLog "Pregunta Id", preguntaId '--lng
    ShowLog "Pagina", "Pagina de preguntas" '--lng
        
    pSaveRespuestaInDb preguntaId, _
                       nick, _
                       pregunta, _
                       respuesta, _
                       articuloId, _
                       fecha
    
    bFound = True
    k = k + 1
    lastI = i
    
    ' Si tengo el final de la respuesta, y i es menor me paso hasta el final
    '
    If endResp > 0 And endResp > i Then
      i = endResp + 1
    End If
        
  Loop While i <> 0

  Err.Clear
  
End Sub

Public Sub BeforeNavigate2()
  On Error Resume Next
  
  Dim formObjects As Object
  Dim formObj As Object
  
  DoEvents: DoEvents: DoEvents: DoEvents: DoEvents
  
  Set formObjects = fMain.wb.Document.Forms
  
'  Dim i           As Long
'  Dim nick        As String
'  Dim pregunta    As String
  Dim preguntaId  As String
  Dim articuloId  As String
  Dim respuesta   As String
'  Dim fecha       As Date
'  Dim c           As String
'  Dim j           As Long
'  Dim q           As Long
'  Dim bFound      As Boolean
'  Dim k           As Long
'  Dim t           As Long
'  Dim bFirstNick  As Boolean
'  Dim lastI       As Long
'  Dim r           As Long
'  Dim startResp   As Long
'  Dim endResp     As Long
  
  For Each formObj In formObjects
  
    respuesta = ""
    preguntaId = ""
    articuloId = ""
    preguntaId = formObj.All("questionId").Value
    articuloId = formObj.All("itemId").Value
    respuesta = formObj.All("areatext").Value
    
    If respuesta <> "Escribe tu respuesta..." And respuesta <> "" Then
    
      If Mid$(articuloId, 1, 3) = "MLA" Then
        articuloId = Mid$(articuloId, 4)
      End If
      
      ShowLog "Respuesta", respuesta '--lng
      ShowLog "Articulo Id", articuloId '--lng
      ShowLog "Pregunta Id", preguntaId '--lng
      ShowLog "Pagina", "Pagina de preguntas" '--lng
          
      pSaveRespuestaInDb2 preguntaId, _
                         respuesta, _
                         articuloId
    End If
  Next

  Err.Clear
  
End Sub

Private Function pSavePreguntaInDb(ByVal preguntaId As Long, _
                                   ByVal nick As String, _
                                   ByVal pregunta As String, _
                                   ByVal articuloId As String, _
                                   ByVal fecha As Date) As Boolean
  
  If Len(articuloId) > 9 Then
    MsgBox "A ocurrido un error avisarle a Javier !!!!"
    SaveLog fMain.wb.Document.Forms("pend_ques").innerHTML
    SaveLog "***********************************************"
  End If
  
  Dim i As Long
  articuloId = Trim$(articuloId)
  i = InStr(articuloId, " ")
  If i > 0 Then articuloId = Trim$(Mid$(articuloId, 1, i))
  
  Dim sqlstmt As String
  sqlstmt = "sp_srv_cvxi_preguntasave 1, " & _
                  us_id & "," & _
                  gDb.sqlString(preguntaId) & "," & _
                  gDb.sqlString(nick) & "," & _
                  gDb.sqlString(pregunta) & "," & _
                  gDb.sqlString(articuloId) & "," & _
                  "''," & _
                  gDb.sqlDate(fecha) & "," & _
                  "'19000101'"

  pSavePreguntaInDb = gDb.Execute(sqlstmt)
End Function

Private Function pSaveRespuestaInDb(ByVal preguntaId As Long, _
                                    ByVal nick As String, _
                                    ByVal pregunta As String, _
                                    ByVal respuesta As String, _
                                    ByVal articuloId As String, _
                                    ByVal fecha As Date) As Boolean
  
  If Len(articuloId) > 9 Then
    MsgBox "A ocurrido un error avisarle a Javier !!!!"
    SaveLog fMain.wb.Document.Forms("pend_ques").innerHTML
    SaveLog "***********************************************"
  End If
  
  Dim i As Long
  articuloId = Trim$(articuloId)
  i = InStr(articuloId, " ")
  If i > 0 Then articuloId = Trim$(Mid$(articuloId, 1, i))
  
  Dim sqlstmt As String
  sqlstmt = "sp_srv_cvxi_preguntasave 1, " & _
                  us_id & "," & _
                  gDb.sqlString(preguntaId) & "," & _
                  gDb.sqlString(nick) & "," & _
                  gDb.sqlString(pregunta) & "," & _
                  gDb.sqlString(articuloId) & "," & _
                  gDb.sqlString(respuesta) & "," & _
                  gDb.sqlDate(fecha) & "," & _
                  gDb.sqlDate(Now)

  pSaveRespuestaInDb = gDb.Execute(sqlstmt)
End Function

Private Function pSaveRespuestaInDb2(ByVal preguntaId As Long, _
                                     ByVal respuesta As String, _
                                     ByVal articuloId As String) As Boolean
  
  If Len(articuloId) > 9 Then
    MsgBox "A ocurrido un error avisarle a Javier !!!!"
    SaveLog fMain.wb.Document.Forms("pend_ques").innerHTML
    SaveLog "***********************************************"
  End If
  
  Dim i As Long
  articuloId = Trim$(articuloId)
  i = InStr(articuloId, " ")
  If i > 0 Then articuloId = Trim$(Mid$(articuloId, 1, i))
  
  Dim sqlstmt As String
  sqlstmt = "sp_srv_cvxi_preguntasave 1, " & _
                  us_id & "," & _
                  gDb.sqlString(preguntaId) & "," & _
                  "''," & _
                  "''," & _
                  gDb.sqlString(articuloId) & "," & _
                  gDb.sqlString(respuesta) & "," & _
                  "'19000102'," & _
                  gDb.sqlDate(Now)

  pSaveRespuestaInDb2 = gDb.Execute(sqlstmt)
End Function

Private Function pDateValue(ByVal strDate As String) As Date
  On Error Resume Next
  
  Dim horas As Long
  Dim minutos As Long
  Dim rtn As Date
  
  strDate = Trim$(Replace(strDate, "Hace", ""))
  
  If InStr(strDate, "hora") Then
    horas = Val(Mid$(strDate, 1, InStr(strDate, " ")))
    strDate = Mid$(strDate, InStr(strDate, "hora") + 5)
  End If
  
  minutos = Val(Mid$(strDate, 1, InStr(strDate, " ")))
    
  rtn = Now
  
  rtn = DateAdd("h", -horas, rtn)
  rtn = DateAdd("n", -minutos, rtn)
  
  pDateValue = rtn
  
  Err.Clear
End Function

Private Sub pShowInfoPregunta()
  On Error Resume Next
  
  ShowInfoPregunta fMain.lvInfo.SelectedItem.Text, _
                   fMain.lvInfo.SelectedItem.SubItems(2), _
                   fMain.lvInfo.SelectedItem.SubItems(3), _
                   Val(fMain.lvInfo.SelectedItem.SubItems(4))
  Err.Clear
End Sub

