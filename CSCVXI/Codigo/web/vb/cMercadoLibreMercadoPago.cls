VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMercadoLibreMercadoPago"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Const c_cmi_id = 1 ' Comunidad internet MercadoLibre

Public Sub ReadPage()
  On Error Resume Next
  
  fMain.RefreshIcon 3, "Mercado Pago"
  fMain.tmService.interval = pGetInterval()
  fMain.tmService.Enabled = False

  pReadPage

  fMain.tmService.Enabled = True
  Err.Clear
End Sub

Private Sub pReadPage()
  On Error Resume Next
  
  Dim formObj As Object
  Dim body As String
  Dim bUpdated As Boolean
    
  ClearLog
  ShowHtmlInfo2 ""
    
  DoEvents: DoEvents: DoEvents: DoEvents: DoEvents
  
  Set formObj = fMain.wb.Document.documentElement
   
  body = formObj.innerHTML
  
  Dim i       As Long
  
  Dim fecha          As String
  Dim idCliente      As String
  Dim nombreArticulo As String
  Dim idArticulo     As String
  Dim cobrado        As String
  Dim estado         As String
  Dim idCobro        As String
  Dim linkToArchive  As String
  Dim linkStart      As Long
  Dim linkEnd        As Long
  Dim linkStartTag   As Long
  Dim linkEndTag     As Long
  Dim openLink       As Long

  Dim c       As String
  Dim j       As Long
  
  ShowBlankInfo
  ClearInfo

  'SaveLog body

  Do
  
    linkToArchive = ""
  
    ' Fecha
    
    i = InStr(i + 1, body, "<TD class=ColFecha vAlign=top>")
  
    If i = 0 Then Exit Do
    
    i = i + 30
    j = i
    
    Do
      c = Mid$(body, j, 1)
      j = j + 1
    Loop Until c = "<"
  
    fecha = Mid$(body, i, j - i - 1)
      
    ' Cobro
    
    i = InStr(i + 1, body, "<TD class=ColTipo vAlign=top>")
    If i = 0 Then Exit Do
    
    i = i + 29
    j = i
    
    Do
      c = Mid$(body, j, 1)
      j = j + 1
    Loop Until (c = "&" Or c = "<")
    
    If Mid$(body, i, j - i - 1) = "Cobro" Then
    
      '------------------------------------------------------------
      '
      ' Link para archivar
      '
      
      linkStartTag = InStr(i + 1, body, ">Archivar</A>")
      linkEndTag = InStr(i + 1, body, "<TD class=ColFecha vAlign=top>")
      
      If linkStartTag > 0 Then
      
        If linkEndTag = 0 Or linkStartTag < linkEndTag Then
          linkEndTag = linkStartTag
          linkStart = 0
          linkEnd = 0
          openLink = 0
          
          Dim r As Long
          
          For r = linkEndTag To i Step -1
            If Mid$(body, r, 1) = "'" Then
              openLink = openLink + 1
            End If
            If openLink = 2 Then
              linkStart = r
              Exit For
            ElseIf openLink = 1 And linkEnd = 0 Then
              linkEnd = r
            End If
          Next
          
          linkToArchive = Mid$(body, linkStart + 1, linkEnd - linkStart - 1)
          
        End If
      
      End If
      '
      '------------------------------------------------------------
    
      ' Id del comprador
    
      i = InStr(i + 1, body, "<A href=""http://www.mercadolibre.com.ar/jm/profile?id=")
      If i = 0 Then Exit Do
      
      i = i + 54
      
      i = InStr(i + 1, body, " target=_blank>")
      
      i = i + 15
      
      j = i
      
      Do
        c = Mid$(body, j, 1)
        j = j + 1
      Loop Until c = "<"
      
      idCliente = Mid$(body, i, j - i - 1)
      
      Dim t As Long
      t = InStr(1, idCliente, "(")
      If t > 1 Then
        idCliente = Trim$(Mid$(idCliente, 1, t - 1))
      End If
      
      Do
        c = Mid$(body, j, 1)
        j = j + 1
      Loop Until c = ">"
              
      ' Id del articulo
      
      i = j
      
      i = InStr(i + 1, body, "<TD class=ColConcepto vAlign=top><A title=""")
      If i = 0 Then Exit Do
      
      i = i + 43
      j = i
      
      Do
        c = Mid$(body, j, 1)
        j = j + 1
      Loop Until c = """"
      
      nombreArticulo = Mid$(body, i, j - i - 1)
      
      ' Id del articulo
      
      i = j
      
      i = InStr(i + 1, body, "href=""http://articulo.mercadolibre.com.ar/MLA-")
      If i = 0 Then Exit Do
      
      i = i + 46
      j = i
      
      Do
        c = Mid$(body, j, 1)
        j = j + 1
      Loop Until c = "-"
      
      idArticulo = Mid$(body, i, j - i - 1)
            
      ' Cobrado
      
      i = j
      
      i = InStr(i + 1, body, "$")
      If i = 0 Then Exit Do
      
      i = i + 1
      j = i
      
      Do
        c = Mid$(body, j, 1)
        j = j + 1
      Loop Until c = "<"
      
      If j - i - 1 <= 0 Then
        idCliente = ""
      Else
        cobrado = Mid$(body, i, j - i - 1)
      End If
      
      ' IdCobro
      
      i = j
      
      i = InStr(i + 1, body, "onclick=""javascript:getOpDetail(")
      If i = 0 Then Exit Do
      
      i = i + 32
      j = i
      
      Do
        c = Mid$(body, j, 1)
        j = j + 1
      Loop Until c = ","
      
      If j - i - 1 <= 0 Then
        idCliente = ""
      Else
        idCobro = Mid$(body, i, j - i - 1)
      End If
            
      ' Estado
      
      i = j
      
      i = InStr(i + 1, body, "<TD class=ColEstado vAlign=top><SPAN class=EstadoOp>")
      If i = 0 Then Exit Do
      
      i = i + 52
      j = i
      
      Do
        c = Mid$(body, j, 1)
        j = j + 1
      Loop Until (c = "<" Or c = "&")
            
      If j - i - 1 <= 0 Then
        idCliente = ""
      Else
        estado = Mid$(body, i, j - i - 1)
      End If
            
      ' Fin
      
      Dim cantidad As String
      Dim precio As String
      Dim pago As String
      Dim envio As String
      Dim comentarios As String
      Dim descrip As String
      
      descrip = ""
      cantidad = ""
      precio = ""
      pago = ""
      envio = ""
      comentarios = ""
      
      If idCobro <> "" Then
      
        If pIsNew(idCobro) Then
      
          fInfo.NavigateComplete = False
          fInfo.wb.Navigate2 "https://www.mercadopago.com/mla/opdetail?opId=" & idCobro & "&from=mp"
          Dim start As Date
          start = Now
          Do
            DoEvents
            If fInfo.NavigateComplete Then
              Dim html As String
              
              Dim q As Long
              Dim w As Long
              Dim z As Long
              
              html = ""
              
              z = 0
              While z < 5
                DoEvents
                Sleep 100
                z = z + 1
              Wend
              
              html = fInfo.wb.Document.documentElement.innerHTML
              
              'SaveLog html
              
              q = InStr(1, html, "A href=""http://articulo.mercadolibre.com.ar/MLA-")
              q = InStr(q + 1, html, "</A>(cant. ")
              w = InStr(q + 1, html, "de")
              If q > 0 And w > 0 Then
                cantidad = Trim$(Mid$(html, q + 11, w - q - 11))
              
                q = InStr(q, html, "$")
                w = InStr(q + 1, html, " c/u")
                If q > 0 And w > 0 Then
                  precio = Trim$(Mid$(html, q + 1, w - q - 1))
                End If
                
                q = InStr(1, html, "A href=""http://articulo.mercadolibre.com.ar/MLA-")
                q = InStr(q + 1, html, "$</TD>")
                w = InStr(q + 4, html, "</TD>")
                z = InStr(q + 1, html, "<TD height=25 width=230>Cargo MercadoLibre </TD>")
                If z = 0 Then
                  z = InStr(q + 1, html, "<DIV class=subtit><B>Contraparte</B></DIV>")
                End If
                If q > 0 And w > 0 And z > w Then
                  pago = Trim$(Mid$(html, q + 33, w - q - 33))
                End If
              
              End If
              
              If cantidad = "" Then
              
                q = InStr(1, html, "A href=""http://articulo.mercadolibre.com.ar/MLA-")
                q = InStr(q + 1, html, "$</TD>")
                w = InStr(q + 4, html, "</TD>")
                z = InStr(q + 1, html, "<TD height=25 width=230>Cargo MercadoLibre </TD>")
                If q > 0 And w > 0 And z > w Then
                  pago = Trim$(Mid$(html, q + 33, w - q - 33))
                Else
                  z = InStr(q + 1, html, "<B>Contraparte</B>")
                  If q > 0 And w > 0 And z > w Then
                    pago = Trim$(Mid$(html, q + 33, w - q - 33))
                  End If
                End If
              End If

              q = InStr(1, html, "<TD height=25 width=230>Costo de envío </TD>")
              If q > 0 Then
                q = InStr(q, html, "<TD width=75 align=right>")
                w = InStr(q + 1, html, "</TD>")
                z = InStr(1, html, "<TD height=25 width=230>Cargo MercadoLibre </TD>")
                If q > 0 And w > 0 And z > w Then
                  envio = Trim$(Mid$(html, q + 25, w - q - 25))
                End If
              End If
              
              q = InStr(1, html, "<DIV style=""DISPLAY: none"" id=datoenvio class=datoenvio>")
              If q > 0 Then
                w = InStr(q + 1, html, "<DIV class=accion><A href=""javascript:mostrar('detalle');"">&lt;&lt; Volver al detalle</A> </DIV></DIV></DIV>")
                If q > 0 And w > 0 Then
                  comentarios = pExtractHtml(Trim$(Mid$(html, q + 80, w - q - 80)))
                End If
              End If
              
              If comentarios = "" Then
                
                q = InStr(1, html, "<DIV class=subtit><B>Datos de envío</B></DIV>")
                w = InStr(q + 45, html, "</DIV>")
                If q > 0 And w > 0 Then
                  comentarios = pExtractHtml(Trim$(Mid$(html, q + 47, w - q - 47)))
                End If
              End If
    
              Exit Do
            End If
            Sleep 0.3
            
            If DateDiff("s", start, Now) > C_BROWSING_TIMEOUT Then
              Exit Sub
            End If
            
          Loop
        End If
      End If
        
      If idCliente <> "" Then
        bUpdated = True
        ShowLog "Estado", estado, False
        ShowLog "Id Cobrado", idCobro, False
        ShowLog "Cobrado", cobrado, False
        ShowLog "Articulo", nombreArticulo, False
        ShowLog "Id Articulo", idArticulo, False
        ShowLog "Id Cliente", idCliente, False
        ShowLog "Fecha", fecha, False
        ShowLog "**********", "*************", False
        
        If cantidad <> "" Then
          descrip = "Cant.: " & cantidad & " de " & precio & vbCrLf
        End If
        If pago <> "" Then
          descrip = descrip & _
                    "Pago: " & pago & vbCrLf
        End If
        If envio <> "" Then
          descrip = descrip & _
                    "Adicional: " & envio & vbCrLf
        End If
        If comentarios <> "" Then
          descrip = descrip & _
                    "***************" & vbCrLf & "Comentarios: " & vbCrLf & comentarios
        End If
        
        pSaveCobroInDb idCobro, _
                       idCliente, _
                       nombreArticulo, _
                       idArticulo, _
                       cobrado, _
                       estado, _
                       fecha, _
                       descrip
                       
        pArchivar idCobro, linkToArchive
                       
      End If
    
    End If
    
  Loop While i <> 0
  
  If bUpdated Then
    ShowHtmlInfo "<table width='100%'><tr><td>Los cobros han sido actualizados / leidos </td></tr><tr><td><b>" & Now & "</b></td></tr></table>"
  End If
   
  Err.Clear
End Sub

Private Function pSaveCobroInDb(ByVal idCobro As String, _
                                ByVal idCliente As String, _
                                ByVal nombreArticulo As String, _
                                ByVal idArticulo As String, _
                                ByVal cobrado As String, _
                                ByVal estado As String, _
                                ByVal fechastr As String, _
                                ByVal descrip As String _
                                ) As Boolean
  Dim sqlstmt As String
  Dim fecha As Date
  
  If IsDate(fechastr) Then fecha = fechastr
  
  sqlstmt = "sp_srv_cvxi_cobrosave 1, " & _
                  gDb.sqlString(idCobro) & "," & _
                  gDb.sqlString(idCliente) & "," & _
                  gDb.sqlString(nombreArticulo) & "," & _
                  gDb.sqlString(idArticulo) & "," & _
                  gDb.sqlString(cobrado) & "," & _
                  gDb.sqlString(estado) & "," & _
                  gDb.sqlString(fechastr) & "," & _
                  gDb.sqlDate(fecha) & "," & _
                  gDb.sqlString(descrip)

  pSaveCobroInDb = gDb.Execute(sqlstmt)
End Function

Private Function pIsNew(ByVal cobroId As String) As Boolean
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select 1 from ComunidadInternetCobro where cmic_cobroid = " & gDb.sqlString(cobroId)
  If Not gDb.OpenRs(sqlstmt, rs) Then Exit Function
  pIsNew = rs.EOF
  'pIsNew = True
End Function

Private Function pExtractHtml(ByVal html As String) As String
  Dim s As String
  Dim i As Long
  Dim c As String
  Dim openTag As Boolean
  
  For i = 1 To Len(html)
    c = Mid$(html, i, 1)
    If c = "<" Then
      openTag = True
    ElseIf c = ">" Then
      openTag = False
    ElseIf Not openTag Then
      s = s + c
    End If
  Next
  If Trim$(Replace$(s, vbCrLf, "")) = "" Then
    pExtractHtml = ""
  Else
    pExtractHtml = Trim$(s)
  End If
End Function

Private Function pGetInterval() As Long
  Dim interval As Long
  interval = Val(IniGet(c_k_intervalMp, "30000"))
  If interval = 0 Then interval = 30000
  '
  ' En visual basic 6 interval es un long, pero el valor maximo
  ' que soporta es 65535
  '
  If interval > 65535 Then interval = 65535
  pGetInterval = interval
End Function

Private Function pArchivar(ByVal idCobro As String, ByVal linkToArchive As String) As Boolean
  Dim sqlstmt As String
  Dim start As Date
  Dim rs As ADODB.Recordset
  
  If Trim$(linkToArchive) = "" Then Exit Function
  
  sqlstmt = "sp_srv_cvxi_escobrofinalizado 1, " & _
                  gDb.sqlString(idCobro)
                  
  If Not gDb.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  If gDb.ValField(rs.fields, 0) <> 0 Then
    
    Dim bSubmited As Boolean
    
    fInfo.NavigateComplete = False
    linkToArchive = Replace(linkToArchive, "&amp;", "&")
    fInfo.wb.Navigate2 "https://www.mercadopago.com/mla/" & linkToArchive
    start = Now
    Do
      DoEvents
      If fInfo.NavigateComplete Then
                
        If bSubmited Then
          Exit Do
        Else
          With fInfo.wb.Document.Forms("popup")
            fInfo.NavigateComplete = False
            bSubmited = True
            .submit
          End With
        End If
      End If
      Sleep 0.3
      If DateDiff("s", start, Now) > C_BROWSING_TIMEOUT Then
        Exit Do
      End If
    Loop
  
  Else
    pArchivar = True
  End If
  
End Function

