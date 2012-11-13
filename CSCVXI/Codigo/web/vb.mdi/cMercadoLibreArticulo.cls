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
  
  fMainMdi.RefreshIcon 5, "Articulos"
  fMain.tmService.interval = pGetInterval()
  fMain.tmService.Enabled = True
  
  Dim formObj As Object
  Dim body As String
  Dim bUpdated As Boolean
    
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
  
  ShowBlankInfo
  ClearInfo

  SaveLog body

  Do
  
    ' Codigo
  
    i = InStr(i + 1, body, "<A class=cargobonif href=""http://www.mercadolibre.com.ar/jm/item?site=MLA&amp;id=")
    If i = 0 Then Exit Do
    
    i = i + 81
    j = i
    
    Do
      c = Mid$(body, j, 1)
      j = j + 1
    Loop Until c = """"
    
    codigo = Mid$(body, i, j - i - 1)
    
    ' Descrip
    
    ' Para algunos explorer el codigo tiene dos links
    ' para otros solo uno, asi que busco un segundo link
    ' y si lo encuentro me reposiciono y sigo desde ahi
    '
    Dim k As Long
    k = InStr(i + 1, body, "<A class=cargobonif href=""http://www.mercadolibre.com.ar/jm/item?site=MLA&amp;id=" & codigo)
    
    If k > 0 Then
      j = k + Len("<A class=cargobonif href=""http://www.mercadolibre.com.ar/jm/item?site=MLA&amp;id=" & codigo)
    
      Do
        c = Mid$(body, j, 1)
        j = j + 1
      Loop Until c = """"
    End If
    
    Do
      c = Mid$(body, j, 1)
      j = j + 1
    Loop Until c = ">"
    
    i = j
    
    Do
      c = Mid$(body, j, 1)
      j = j + 1
    Loop Until c = "<"
    
    If j - i - 1 <= 0 Then
      codigo = ""
    Else
      descrip = Mid$(body, i, j - i - 1)
    End If
    
    ' Ventas
    
    ventas = ""
    
    k = InStr(i + 1, body, "<A title=""Ver compradores"" href=""http://www.mercadolibre.com.ar/jm/myML?as_section=MIS_VTAS&amp;as_search_where=ITEMID&amp;as_word=")
    If k > 0 Then
    
      i = k
    
      i = i + 131
      j = i
      
      Do
        c = Mid$(body, j, 1)
        j = j + 1
      Loop Until c = ">"
      
      i = j
      
      Do
        c = Mid$(body, j, 1)
        j = j + 1
      Loop Until c = "<"
      
      ventas = Mid$(body, i, j - i - 1)
      
    End If
    
    ' Ofertas
    
    ofertas = ""
    
    k = InStr(i + 1, body, "<A title=""Historial de Ofertas"" href=""http://www.mercadolibre.com.ar/argentina/ml/org_prod_lst.ver?it_s=MLA&amp;it_n=")
    If k > 0 Then
      i = k
    
      i = i + 117
      j = i
      
      Do
        c = Mid$(body, j, 1)
        j = j + 1
      Loop Until c = ">"
      
      i = j
      
      Do
        c = Mid$(body, j, 1)
        j = j + 1
      Loop Until c = "<"
      
      ofertas = Mid$(body, i, j - i - 1)
    
    End If
    
    ' Visitas
    
    i = InStr(i + 1, body, "<TD width=54")
    If i = 0 Then Exit Do
    
    i = i + 12
    j = i
    
    Do
      c = Mid$(body, j, 1)
      j = j + 1
    Loop Until c = ">"
    
    i = j
    
    Do
      c = Mid$(body, j, 1)
      j = j + 1
    Loop Until c = "<"
    
    visitas = Mid$(body, i, j - i - 1)
    
    ' Disponible
    
    i = InStr(i + 1, body, "<A title=""Modificar cantidad"" href='javascript:w=wOpen(""/jm/qEdit?itemID=")
    If i = 0 Then Exit Do
    
    i = i + 73
    j = i
    
    Do
      c = Mid$(body, j, 1)
      j = j + 1
    Loop Until c = ">"
    
    i = j
    
    Do
      c = Mid$(body, j, 1)
      j = j + 1
    Loop Until c = "<"
    
    disponible = Mid$(body, i, j - i - 1)
    
    ' Finaliza

    k = InStr(i + 1, body, "<TD width=60><FONT color=red><B")
    If k = 0 Then
      i = InStr(i + 1, body, "<TD width=60")
      If i = 0 Then Exit Do
      i = i + 12
    Else
      i = k + 31
    End If
    
    j = i
    
    Do
      c = Mid$(body, j, 1)
      j = j + 1
    Loop Until c = ">"
    
    i = j
    
    Do
      c = Mid$(body, j, 1)
      j = j + 1
    Loop Until c = "<"
    
    finaliza = Mid$(body, i, j - i - 1)

    ' Fin
    
    If codigo <> "" Then
      bUpdated = True
      pAddArticulo codigo, descrip, ventas, ofertas, visitas, disponible, finaliza
      If IsNumeric(disponible) Then
        pCheckDisponible codigo, descrip, Val(disponible)
      End If
    End If
        
  Loop While i <> 0
  
  If bUpdated Then
    ShowHtmlInfo "<p>Los articulos han sido actualizados / leidos</p>" + m_html
  
  Else
    ShowHtmlInfo "<p>No se ha podido leer correctamente la pagina</p>" + m_html
  End If
   
  Err.Clear
End Sub

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
  pGetInterval = interval
End Function

