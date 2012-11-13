VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMercadoLibreArticulo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Const c_cmi_id = 1 ' Comunidad internet MercadoLibre

Private m_html As String

Public Sub ReadPage()
  On Error Resume Next
  
  fMain.RefreshIcon 5, "Articulos"
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
  Dim olCodigo As String
    
  ShowHtmlInfo2 "Leyendo la pagina"
  m_html = ""
    
  DoEvents: DoEvents: DoEvents: DoEvents: DoEvents
  
  Set formObj = fMain.wb.Document.documentElement
   
  body = formObj.innerHTML
  
  Dim i           As Long
  Dim codigo      As String
  Dim descrip     As String
  Dim disponible  As String
  Dim ventas      As String
  Dim ofertas     As String
  Dim visitas     As String
  Dim finaliza    As String
  Dim c           As String
  Dim j           As Long
  Dim count       As Long
  Dim ii          As Long
  Dim iend        As Long
  Dim articulos   As String
  
  ShowBlankInfo
  ClearInfo

  SaveLog body
  
  'fDebug.txDebug.Text = body
  'fDebug.Show vbModal

  Do
  
    ' Codigo
    '
    ' dos veces por que hay un linnk en image y otro en texto
    '
    i = InStr(ii + 1, body, "href=""http://articulo.mercadolibre.com.ar/")
    If i = 0 Then Exit Do ' stop for debug
    i = InStr(i + 1, body, "href=""http://articulo.mercadolibre.com.ar/")
    If i = 0 Then Exit Do ' stop for debug
    ii = i
    iend = InStr(ii + 1, body, "href=""http://articulo.mercadolibre.com.ar/")
    
    ' el ultimo no tiene un link a otro articulo al final por que es el ultimo :)
    '
    If iend = 0 Then
        iend = InStr(ii + 1, body, "<P>Modificar costos de envío</P>")
    End If
  
    If iend = 0 Then Exit Do ' stop for debug
    If iend < i Then Exit Do ' stop for debug
  
    Dim htmlarticulo As String
    htmlarticulo = Mid$(body, i, iend - i)
  
    ' Descrip
    
    i = InStr(1, htmlarticulo, ">")
    If i = 0 Then Exit Do ' stop for debug
    If i > iend Then Exit Do ' stop for debug
  
    j = InStr(i + 1, htmlarticulo, "<")
    If j = 0 Then Exit Do ' stop for debug
    If j > iend Then Exit Do ' stop for debug
    
    descrip = Mid$(htmlarticulo, i + 1, j - i - 1)
    descrip = Trim$(descrip)
    If descrip = "" Then Exit Do ' stop for debug
  
    ' Codigo
    
    i = InStr(1, htmlarticulo, "<SPAN class=itemId>")
    If i = 0 Then Exit Do ' stop for debug
    If i > iend Then Exit Do ' stop for debug
    
    i = i + 19
    
    j = InStr(i + 1, htmlarticulo, "</SPAN>")
    If j = 0 Then Exit Do ' stop for debug
    If j > iend Then Exit Do ' stop for debug
    
    codigo = Mid$(htmlarticulo, i, 1)
    If codigo <> "#" Then Exit Do ' stop for debug
    codigo = Mid$(htmlarticulo, i + 1, j - i - 1)
    codigo = Trim$(codigo)
    If codigo = "" Then Exit Do ' stop for debug
    
    olCodigo = codigo
    
    ' Ventas
    
    i = InStr(1, htmlarticulo, "<A href=""http://www.mercadolibre.com.ar/jm/myML?as_section=MIS_VTAS&amp;as_search_where=ITEMID&amp;as_word=")
    
    ' cuando no hay ventas no hay link
    '
    If i = 0 Then
      ventas = "0"
    Else
    
      If i > iend Then Exit Do ' stop for debug
      
      i = InStr(i + 107, htmlarticulo, ">")
      If i = 0 Then Exit Do ' stop for debug
      If i > iend Then Exit Do ' stop for debug
      
      j = InStr(i + 1, htmlarticulo, "<")
      If j = 0 Then Exit Do ' stop for debug
      If j > iend Then Exit Do ' stop for debug
      
      ventas = Mid$(htmlarticulo, i + 1, j - i - 1)
      If InStr(1, ventas, "venta") = 0 Then Exit Do ' stop for debug
      ventas = Trim$(Replace(ventas, "ventas", ""))
      ventas = Trim$(Replace(ventas, "venta", ""))
      If ventas = "" Then Exit Do ' stop for debug
    
    End If
        
    ' Ofertas (mercadolibre volo esta opcion en el ultimo update)
    
    ofertas = ""
    
    ' Visitas
    
    j = InStr(1, htmlarticulo, "visita")
    If j = 0 Then Exit Do ' stop for debug
    If j > iend Then Exit Do ' stop for debug
    
    Dim k As Long
    k = j
    Do
      k = k - 1
      If k < 1 Then Exit Do ' stop for debug
      c = Mid$(htmlarticulo, k, 1)
    Loop Until c = ">"
    
    visitas = Trim$(Mid$(htmlarticulo, k + 1, j - k - 1))
    If visitas = "" Then Exit Do ' stop for debug
    
    ' Disponible
    
    j = InStr(1, htmlarticulo, "disponible")
    If j = 0 Then Exit Do ' stop for debug
    If j > iend Then Exit Do ' stop for debug
    
    k = j
    Do
      k = k - 1
      If k < 1 Then Exit Do ' stop for debug
      c = Mid$(htmlarticulo, k, 1)
    Loop Until c = "x"
    
    disponible = Trim$(Mid$(htmlarticulo, k + 1, j - k - 1))
    If disponible = "" Then Exit Do ' stop for debug
    
    ' Finaliza
    
    j = InStr(1, htmlarticulo, "día")
    If j = 0 Then Exit Do ' stop for debug
    If j > iend Then Exit Do ' stop for debug
    
    k = j
    Do
      k = k - 1
      If k < 1 Then Exit Do ' stop for debug
      c = Mid$(htmlarticulo, k, 1)
    Loop Until c = "n"
    
    finaliza = Trim$(Mid$(htmlarticulo, k + 1, j - k - 1))
    If finaliza = "" Then Exit Do ' stop for debug

    ' Fin
    
    If codigo <> "" Then
      bUpdated = True
      count = count + 1
      pAddArticulo codigo, descrip, ventas, ofertas, visitas, disponible, finaliza
      If IsNumeric(disponible) Then
        pCheckDisponible codigo, descrip, Val(disponible)
      End If
      
      articulos = articulos + "<tr><td>" + codigo + "</td><td>" + descrip + "</td></tr>"
      
    End If
        
  Loop While iend <> 0
  
  If bUpdated Then
    ShowHtmlInfo "<table width='100%'><tr><td>Los articulos han sido actualizados / leidos</td></tr>" _
                 & "<tr><td>Se leyeron <b>" & count & "</b></td></tr><tr><table>" + articulos + "</table></tr></table>" _
                 & m_html
  
  Else
    ShowHtmlInfo "<table width='100%'><tr><td>No se ha podido leer correctamente la pagina</td></tr><tr><td>" _
                  & m_html & "</td></tr></table>"
  End If
   
  Err.Clear
End Sub

'
' Old Version Delete on 6/7/2012
'
'
'Private Sub pReadPage()
'  On Error Resume Next
'
'  Dim formObj As Object
'  Dim body As String
'  Dim bUpdated As Boolean
'  Dim olCodigo As String
'
'  ShowHtmlInfo2 "Leyendo la pagina"
'  m_html = ""
'
'  DoEvents: DoEvents: DoEvents: DoEvents: DoEvents
'
'  Set formObj = fMain.wb.Document.documentElement
'
'  body = formObj.innerHTML
'
'  Dim i           As Long
'  Dim codigo      As String
'  Dim descrip     As String
'  Dim disponible  As String
'  Dim ventas      As String
'  Dim ofertas     As String
'  Dim visitas     As String
'  Dim finaliza    As String
'  Dim c           As String
'  Dim j           As Long
'  Dim count       As Long
'  Dim ii          As Long
'  Dim articulos   As String
'
'  ShowBlankInfo
'  ClearInfo
'
'  SaveLog body
'
'  'fDebug.txDebug.Text = body
'  'fDebug.Show vbModal
'
'  Do
'
'    ' Codigo
'
'    Do
'
'      i = InStr(ii + 1, body, "<A class=cargobonif href=""/jm/item?site=MLA&amp;id=")
'      If i = 0 Then exit do ' stop for debug
'
'      ii = i
'
'      i = i + 51
'      j = i
'
'      Do
'        c = Mid$(body, j, 1)
'        j = j + 1
'      Loop Until c = """"
'
'      codigo = Mid$(body, i, j - i - 1)
'
'    Loop While olCodigo = codigo
'
'    If i = 0 Then exit do ' stop for debug
'
'    olCodigo = codigo
'
'    ' Descrip
'
'    ' Para algunos explorer el codigo tiene dos links
'    ' para otros solo uno, asi que busco un segundo link
'    ' y si lo encuentro me reposiciono y sigo desde ahi
'    '
'    Dim k As Long
'    k = InStr(i + 1, body, "<A class=cargobonif href=""/jm/item?site=MLA&amp;id=" & codigo)
'
'    If k > 0 Then
'      j = k + Len("<A class=cargobonif href=""/jm/item?site=MLA&amp;id=" & codigo)
'
'      Do
'        c = Mid$(body, j, 1)
'        j = j + 1
'      Loop Until c = """"
'    End If
'
'    Do
'      c = Mid$(body, j, 1)
'      j = j + 1
'    Loop Until c = ">"
'
'    i = j
'
'    Do
'      c = Mid$(body, j, 1)
'      j = j + 1
'    Loop Until c = "<"
'
'    If j - i - 1 <= 0 Then
'      codigo = ""
'    Else
'      descrip = Mid$(body, i, j - i - 1)
'    End If
'
'    ' Ventas
'
'    ventas = ""
'
'    k = InStr(i + 1, body, "<A title=""Ver compradores"" href=""/jm/myML?as_section=MIS_VTAS&amp;as_search_where=ITEMID&amp;as_word=")
'    If k > 0 Then
'
'      i = k
'
'      i = i + 101
'      j = i
'
'      Do
'        c = Mid$(body, j, 1)
'        j = j + 1
'      Loop Until c = ">"
'
'      i = j
'
'      Do
'        c = Mid$(body, j, 1)
'        j = j + 1
'      Loop Until c = "<"
'
'      ventas = Mid$(body, i, j - i - 1)
'
'    End If
'
'    ' Ofertas
'
'    ofertas = ""
'
'    k = InStr(i + 1, body, "<A title=""Historial de Ofertas"" href=""/argentina/ml/org_prod_lst.ver?it_s=MLA&amp;it_n=")
'    If k > 0 Then
'      i = k
'
'      i = i + 87
'      j = i
'
'      Do
'        c = Mid$(body, j, 1)
'        j = j + 1
'      Loop Until c = ">"
'
'      i = j
'
'      Do
'        c = Mid$(body, j, 1)
'        j = j + 1
'      Loop Until c = "<"
'
'      ofertas = Mid$(body, i, j - i - 1)
'
'    End If
'
'    ' Visitas
'
'    i = InStr(i + 1, body, "<TD width=54")
'    If i = 0 Then exit do ' stop for debug
'
'    i = i + 12
'    j = i
'
'    Do
'      c = Mid$(body, j, 1)
'      j = j + 1
'    Loop Until c = ">"
'
'    i = j
'
'    Do
'      c = Mid$(body, j, 1)
'      j = j + 1
'    Loop Until c = "<"
'
'    visitas = Mid$(body, i, j - i - 1)
'
'    ' Disponible
'
'    i = InStr(i + 1, body, "<A title=""Modificar cantidad"" href='javascript:w=wOpen(""/jm/qEdit?itemID=")
'    If i = 0 Then exit do ' stop for debug
'
'    i = i + 73
'    j = i
'
'    Do
'      c = Mid$(body, j, 1)
'      j = j + 1
'    Loop Until c = ">"
'
'    i = j
'
'    Do
'      c = Mid$(body, j, 1)
'      j = j + 1
'    Loop Until c = "<"
'
'    disponible = Mid$(body, i, j - i - 1)
'
'    ' Finaliza
'
'    k = InStr(i + 1, body, "<TD width=60><FONT color=red><B")
'    If k = 0 Then
'      i = InStr(i + 1, body, "<TD width=60")
'      If i = 0 Then exit do ' stop for debug
'      i = i + 12
'    Else
'      i = k + 31
'    End If
'
'    j = i
'
'    Do
'      c = Mid$(body, j, 1)
'      j = j + 1
'    Loop Until c = ">"
'
'    i = j
'
'    Do
'      c = Mid$(body, j, 1)
'      j = j + 1
'    Loop Until c = "<"
'
'    finaliza = Mid$(body, i, j - i - 1)
'
'    ' Fin
'
'    If codigo <> "" Then
'      bUpdated = True
'      count = count + 1
'      pAddArticulo codigo, descrip, ventas, ofertas, visitas, disponible, finaliza
'      If IsNumeric(disponible) Then
'        pCheckDisponible codigo, descrip, Val(disponible)
'      End If
'
'      articulos = articulos + "<tr><td>" + codigo + "</td><td>" + descrip + "</td></tr>"
'
'    End If
'
'  Loop While i <> 0
'
'  If bUpdated Then
'    ShowHtmlInfo "<table width='100%'><tr><td>Los articulos han sido actualizados / leidos</td></tr>" _
'                 & "<tr><td>Se leyeron <b>" & count & "</b></td></tr><tr><table>" + articulos + "</table></tr></table>" _
'                 & m_html
'
'  Else
'    ShowHtmlInfo "<table width='100%'><tr><td>No se ha podido leer correctamente la pagina</td></tr><tr><td>" _
'                  & m_html & "</td></tr></table>"
'  End If
'
'  Err.Clear
'End Sub

Private Sub pAddArticulo(ByVal codigo As String, _
                         ByVal descrip As String, _
                         ByVal ventas As String, _
                         ByVal ofertas As String, _
                         ByVal visitas As String, _
                         ByVal disponible As String, _
                         ByVal finaliza As String)
  Dim sqlstmt As String
  
  sqlstmt = "sp_srv_cvxi_articulosave " _
                    & c_cmi_id & "," _
                    & gDb.sqlString(codigo) & "," _
                    & gDb.sqlString(descrip) & "," _
                    & gDb.sqlString(ventas) & "," _
                    & gDb.sqlString(ofertas) & "," _
                    & gDb.sqlString(visitas) & "," _
                    & gDb.sqlString(disponible) & "," _
                    & gDb.sqlString(finaliza)
                    
  gDb.Execute sqlstmt
End Sub

Private Sub pCheckDisponible(ByVal codigo As String, _
                             ByVal descrip As String, _
                             ByVal disponible As Double)
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_srv_cvxi_articulocheckstock " _
                    & c_cmi_id & "," _
                    & gDb.sqlString(codigo) & "," _
                    & gDb.sqlString(descrip) & "," _
                    & gDb.sqlNumber(disponible)
  
  If Not gDb.OpenRs(sqlstmt, rs) Then Exit Sub
  If rs.EOF Then Exit Sub
  Dim msg As String
  msg = gDb.ValField(rs.fields, "msg")
  If msg <> "" Then
    m_html = m_html + msg
  End If
End Sub

Private Function pGetInterval() As Long
  Dim interval As Long
  interval = Val(IniGet(c_k_intervalArticulos, "30000"))
  If interval = 0 Then interval = 30000
  '
  ' En visual basic 6 interval es un long, pero el valor maximo
  ' que soporta es 65535
  '
  If interval > 65535 Then interval = 65535
  pGetInterval = interval
End Function

