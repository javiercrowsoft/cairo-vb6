VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMercadoLibreCalificacion"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Const c_cmi_id = 1 ' Comunidad internet MercadoLibre

Private m_collCalif     As Collection
Private m_collMessages  As Collection

Public Sub ReadPage()
  If fMain.txAddress.Text = "http://www.mercadolibre.com.ar/jm/myML?as_section=MIS_VTAS" Then
    pReadPageVentas
  ElseIf Left$(fMain.txAddress.Text, 75) = "http://www.mercadolibre.com.ar/jm/calif?act=califnow&subAct=calif&as_choose" Then
    pReadPageCalif
  ElseIf Left$(fMain.txAddress.Text, 52) = "http://www.mercadolibre.com.ar/jm/calif?act=califnow" Then
    pReadPageCalif
  End If
End Sub

Private Sub pReadPageVentas()
  On Error Resume Next
  
  Dim formObj As Object
  Dim body As String
    
  DoEvents: DoEvents: DoEvents: DoEvents: DoEvents
  
  Set formObj = fMain.wb.Document.documentElement
   
  body = formObj.innerHTML
  
  Dim i     As Long
  Dim nick  As String
  Dim c     As String
  Dim j     As Long
  
  ShowBlankInfo
  ClearInfo

  Do
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
    ShowLog "Nick", nick '--lng
  Loop While i <> 0
     
  Err.Clear

End Sub

Private Sub pReadPageCalif()
  On Error Resume Next
    
  fMain.RefreshIcon 4, "Calificaciones"
  
  ' Si estoy a punto de calificar no leo la pagina
  '
  If fMain.txAddress.Text = "http://www.mercadolibre.com.ar/jm/calif" Then Exit Sub
    
  ShowHtmlInfo "<table width='100%'><tr><td>Analizando pagina</td></tr><tr><td>" & Format(Now, "dd-mm-yy HH:nn:ss") & "</td></tr></table>"

  Dim formObj As Object
  Dim body As String
    
  DoEvents: DoEvents: DoEvents: DoEvents: DoEvents
  
  Set m_collCalif = New Collection
  Set m_collMessages = New Collection
  
  Set formObj = fMain.wb.Document.documentElement
   
  body = formObj.innerHTML
  
  'SaveLog body
  
  Dim i         As Long
  Dim info      As String
  Dim articulo  As String
  Dim vInfo     As Variant
  Dim nick      As String
  Dim c         As String
  Dim j         As Long
  
  Dim k         As Long
  Dim q         As Long
  Dim html      As String
  
  Dim aCalificar  As Long
  Dim contretadas As Long
  
  ClearInfo
  
  Dim checkbox As Object
  
  Set formObj = fMain.wb.Document.Forms("masiv_calif")
  
  Do
    i = InStr(i + 1, body, "name=as_choose")
    If i = 0 Then Exit Do
    
    j = 0
    Do
      j = j + 1
      c = Mid$(body, i - j, 1)
    Loop Until c = """"
    
    i = i - j
        
    j = 0
    Do
      j = j + 1
      c = Mid$(body, i - j, 1)
    Loop Until c = """"
    
    info = Mid$(body, i - j + 1, j - 1)
    vInfo = Split(info, "|")
    articulo = vInfo(0)
    ShowLog "Articulo", articulo '--lng
    
    
    '-------------------------------------------------
    
    
    i = InStr(i + 1, body, """/jm/profile?id=")
    If i = 0 Then Exit Do
    
    i = i + 16
        
    Do
      i = i + 1
      c = Mid$(body, i, 1)
    Loop Until c = ">"
    
    j = 0
    Do
      j = j + 1
      c = Mid$(body, i + j, 1)
    Loop Until c = "("
    
    nick = Mid$(body, i + 1, j - 1)
    ShowLog "Nick", nick '--lng
    
    m_collCalif.Add nick, "k" & vInfo(2)
    
    k = k + 1
    
    aCalificar = aCalificar + 1
    
    If pIsFacturado(nick, articulo) Then
    
      q = 0
      For Each checkbox In formObj.All
        If LCase$(checkbox.tagName) = "input" Then
          If checkbox.Name = "as_choose" Then
            q = q + 1
            If q = k Then
              checkbox.Checked = 1
              contretadas = contretadas + 1
            End If
          End If
        End If
      Next
    Else
      pGetComprasForNick nick, articulo
    End If

  Loop While i <> 0
  
  html = "<table width='100%'><tr><td>Pagina analizada </td></tr><tr><td>" & Format(Now, "dd-mm-yy HH:nn:ss") & "</td></tr>"
  html = html & "<tr><td><table border='0' class='tableInternal' id='tableInternal'><tr><td>A calificar:</td><td>" & aCalificar
  html = html & "</td></tr><tr><td>Concretadas:</td><td>" & contretadas & "</td></tr></table></td></tr></table>"
  
  Dim msg As Variant
  Dim vMsg() As String
  
  If m_collMessages.count Then
    Dim t As Long
    ReDim vMsg(m_collMessages.count - 1)
    For Each msg In m_collMessages
      vMsg(t) = msg
      t = t + 1
    Next
    html = html & "<table width='100%'><tr><td>Compras de esta pagina</td></tr><tr><td>" & Join(vMsg, "<p>") & "</td></tr></table>"
    
  End If
  
  ShowHtmlInfo html
     
  Err.Clear

End Sub

Public Sub BeforeNavigate()
  On Error Resume Next
  
  If m_collCalif Is Nothing Then Exit Sub
  
  If fMain.txAddress.Text = "http://www.mercadolibre.com.ar/jm/calif" Then
  
    ShowHtmlInfo "<table width='100%'><tr><td>Guardando calificaciones</td></tr><tr><td>" & Format(Now, "dd-mm-yy HH:nn:ss") & "</td></tr></table>"
  
    Dim formObj As Object
    Dim body As String
      
    DoEvents: DoEvents: DoEvents: DoEvents: DoEvents
    
    Set formObj = fMain.wb.Document.documentElement
       
    Dim articulo  As String
    Dim vInfo     As Variant
    Dim nick      As String
       
    Dim k         As Long
    Dim q         As Long
    
    ClearInfo
    
    Dim checkbox As Object
    
    Set formObj = fMain.wb.Document.Forms("fsendCalif")
    
    For Each checkbox In formObj.All
      If LCase$(checkbox.tagName) = "input" Then
        If checkbox.Name = "as_choose" Then
          If checkbox.Type = "hidden" Then
          
            On Error Resume Next
          
            Err.Clear
            vInfo = Split(checkbox.Value, "|")
            nick = m_collCalif.Item("k" & vInfo(2))
            articulo = vInfo(0)
            
            If Err.Number = 0 Then
              pSaveFacturado nick, articulo
            End If
          End If
        End If
      End If
    Next
    
    ShowHtmlInfo "<table width='100%'><tr><td>Calificaciones guardadas</td></tr><tr><td>" & Format(Now, "dd-mm-yy HH:nn:ss") & "</td></tr></table>"
     
    Set m_collCalif = Nothing
     
  End If
     
  Err.Clear
End Sub

Private Sub pGetComprasForNick(ByVal nick As String, ByVal articulo As String)
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_srv_cvxi_getComprasByNick " _
                   & c_cmi_id & "," _
                   & gDb.sqlString(nick) & "," _
                   & gDb.sqlString(articulo)
                   
  If Not gDb.OpenRs(sqlstmt, rs) Then Exit Sub
  If rs.EOF Then Exit Sub

  Dim msg As String
  
  msg = gDb.ValField(rs.fields, 0)

  If msg <> "" Then
    m_collMessages.Add msg
  End If

End Sub

Private Function pIsFacturado(ByVal nick As String, ByVal articulo As String) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_srv_cvxi_getProductoFacturado " _
                   & c_cmi_id & "," _
                   & gDb.sqlString(nick) & "," _
                   & gDb.sqlString(articulo)
                   
  If Not gDb.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  pIsFacturado = rs.fields.Item(0).Value
End Function

Private Function pSaveFacturado(ByVal nick As String, ByVal articulo As String) As Boolean
  Dim sqlstmt As String
  
  sqlstmt = "sp_srv_cvxi_saveProductoFacturado " _
                   & c_cmi_id & "," _
                   & gDb.sqlString(nick) & "," _
                   & gDb.sqlString(articulo)
                   
  If Not gDb.Execute(sqlstmt) Then Exit Function
  
  pSaveFacturado = True
End Function

