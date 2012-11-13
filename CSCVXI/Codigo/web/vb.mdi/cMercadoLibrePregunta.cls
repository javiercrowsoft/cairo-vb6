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
  Dim R           As Long
  
  i = 0
  
  Do
  
    R = InStr(i + 1, body, "name=as_question>")
    i = InStr(i + 1, body, "http://www.mercadolibre.com.ar/jm/item?site=MLA&amp;id=")
    
    '
    ' Si antes del proximo nick hay otra pregunta la proceso
    '
    If i > R Then i = 0
    
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
    fMainMdi.fSysTray.ShowBalloonTip _
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

  fMainMdi.RefreshIcon 1, "Preguntas"

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
  Dim R           As Long
  
  i = 0
  
  Do
  
    R = InStr(i + 1, body, "name=as_question>")
    i = InStr(i + 1, body, "http://www.mercadolibre.com.ar/jm/item?site=MLA&amp;id=")
    
    '
    ' Si antes del proximo nick hay otra pregunta la proceso
    '
    If i > R Then i = 0
    
    '
    ' Si no hay ni siquiera un nick no hay preguntas
    '
    If i = 0 And Not bFirstNick Then
      Exit Do
    End If
        
' Borrar una vez que ande
'    i = i + 55
'    j = 0
'    Do
'      j = j + 1
'      c = Mid$(body, i + j, 1)
'    Loop Until c = """"
'
'    articuloId = Mid$(body, i, j)
'
'    i = InStr(i + 1, body, "http://www.mercadolibre.com.ar/jm/profile?id=")
'    If i = 0 Then Exit Do
'
'    i = i + 45
'
'    Do
'      c = Mid$(body, i, 1)
'      i = i + 1
'    Loop Until c = ">"
'
'    j = 0
'    Do
'      j = j + 1
'      c = Mid$(body, i + j, 1)
'    Loop Until c = "<"
'
'    nick = Mid$(body, i, j)
'
'    i = InStr(i + 1, body, "Pregunta:")
'    If i = 0 Then Exit Do
'
'    i = i + 9
'
'    For t = 1 To 3
'      Do
'        c = Mid$(body, i, 1)
'        i = i + 1
'      Loop Until c = ">"
'    Next
'
'    j = 0
'    Do
'      j = j + 1
'      c = Mid$(body, i + j, 1)
'    Loop Until c = "<"
'
'    pregunta = Mid$(body, i, j)
'
'    For t = 1 To 3
'      Do
'        c = Mid$(body, i, 1)
'        i = i + 1
'      Loop Until c = ">"
'    Next
'
'    j = 0
'    Do
'      j = j + 1
'      c = Mid$(body, i + j, 1)
'    Loop Until c = "<"
'
'    fecha = pDateValue(Mid$(body, i, j))
'
'    For t = 1 To 10
'      Do
'        c = Mid$(body, i, 1)
'        i = i + 1
'      Loop Until c = ">"
'    Next
'
'    i = i + 14
'    j = 0
'    Do
'      j = j + 1
'      c = Mid$(body, i + j, 1)
'    Loop Until c = " "
'
'    preguntaId = Mid$(body, i, j)
'------------
    
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
    
'    For t = 1 To 10
'      Do
'        c = Mid$(body, i, 1)
'        i = i + 1
'      Loop Until c = ">"
'    Next
'
'    i = i + 14
'    j = 0
'    Do
'      j = j + 1
'      c = Mid$(body, i + j, 1)
'    Loop Until c = " "
'
'    preguntaId = Mid$(body, i, j)
    
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
        
  Loop While i <> 0

  Err.Clear
  
End Sub

Private Function pSavePreguntaInDb(ByVal preguntaId As Long, _
                                   ByVal nick As String, _
                                   ByVal pregunta As String, _
                                   ByVal articuloId As String, _
                                   ByVal fecha As Date) As Boolean
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

Private Function pDateValue(ByVal strDate As String) As Date
  On Error Resume Next
  
  Dim dia As Long
  Dim mes As Long
  Dim anio As Long
  Dim hora As Long
  Dim minuto As Long
  Dim rtn As Date
  
  dia = Val(Mid$(strDate, 1, 2))
  mes = Val(Mid$(strDate, 4, 2))
  anio = Val(Mid$(strDate, 7, 4))
  
  hora = Val(Mid$(strDate, 12, 2))
  minuto = Val(Mid$(strDate, 15, 2))
  
  rtn = DateSerial(anio, mes, dia)
  
  rtn = DateAdd("h", hora, rtn)
  rtn = DateAdd("n", minuto, rtn)
  
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

