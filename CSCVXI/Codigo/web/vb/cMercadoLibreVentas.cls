VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMercadoLibreVentas"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Const c_cmi_id = 1 ' Comunidad internet MercadoLibre

Private m_mail As cMercadoLibreMail

Private m_cmiea_id As Long

Private m_cmiea_server As String
Private m_cmiea_pwd As String
Private m_cmiea_user As String

Private m_cmiea_email_server As String
Private m_cmiea_email_pwd As String
Private m_cmiea_email_user As String

Public Sub ReadPage()
  On Error Resume Next
  
  fMain.RefreshIcon 2, "Ventas"
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
  
  Dim clienteIdML    As String
  Dim clienteId      As String
  Dim idVenta        As String
  Dim idArticulo     As String
  Dim nombreArticulo As String
  Dim precio         As String
  Dim cantidad       As String
  Dim fecha          As Date
  Dim linkContacto   As String
  
  Dim c       As String
  Dim j       As Long
  
  Dim html      As String
  Dim nombre    As String
  Dim apellido  As String
  Dim email     As String
  Dim telefono  As String
  Dim provincia As String
  Dim localidad As String
  
  Dim q As Long
  Dim w As Long
  Dim next_i As Long
  Dim dataHasBeenRead As Boolean
    
  ShowBlankInfo
  ClearInfo

  SaveLog body

  Do
  
    clienteIdML = ""
    clienteId = ""
    idVenta = ""
    idArticulo = ""
    nombreArticulo = ""
    precio = ""
    cantidad = ""
    fecha = ""
    linkContacto = ""
    html = ""
    nombre = ""
    apellido = ""
    email = ""
    telefono = ""
    provincia = ""
    localidad = ""
  
    ' Id del comprador
  
    i = InStr(i + 1, body, "<A href=""/jm/profile?id=")
    If i = 0 Then Exit Do
    
    next_i = InStr(i + 1, body, "<A href=""/jm/profile?id=")
    
    i = i + 24
    j = i
    
    Do
      c = Mid$(body, j, 1)
      j = j + 1
    Loop Until c = "&"
    
    clienteIdML = Mid$(body, i, j - i - 1)
    
    Do
      c = Mid$(body, j, 1)
      j = j + 1
    Loop Until c = ">"
    
    i = j
    If next_i < i And next_i > 0 Then Stop
    
    Do
      c = Mid$(body, j, 1)
      j = j + 1
    Loop Until c = "<"
    
    If j - i - 1 <= 0 Then
      clienteIdML = ""
    Else
      clienteId = Mid$(body, i, j - i - 1)
    End If
    
    Dim t As Long
    t = InStr(1, clienteId, "(")
    If t > 1 Then
      clienteId = Trim$(Mid$(clienteId, 1, t - 1))
    End If
    clienteId = Replace$(clienteId, "&amp;", "&")
    
    ' Link a datos de contacto
    
    i = j
    If next_i < i And next_i > 0 Then Stop
    
    i = InStr(i + 1, body, "javascript:wOpen('")
    If i = 0 Then Exit Do
    If next_i < i And next_i > 0 Then Stop
    
    i = i + 18
    j = i
    
    Do
      c = Mid$(body, j, 1)
      j = j + 1
    Loop Until c = "'"

    linkContacto = Replace(Mid$(body, i, j - i - 1), "&amp;", "&")
    
    dataHasBeenRead = False
    
    ' Hay que leer tantos articulos como existan dentro del bloque de este
    ' cliente
    '
    Do
    
      ' Id del articulo
      
      i = j
      If next_i < i And next_i > 0 Then Stop
      
      i = InStr(i + 1, body, "href=""/jm/item?site=MLA&amp;id=")
      If i = 0 Then Exit Do
      If next_i < i And next_i > 0 Then
        ' Si estamos aqui es por que este articulo no pertenece a este
        ' comprador. reasignamos i y seguimos con el proximo comprador.
        '
        i = next_i - 1
        Exit Do
        
      End If
      
      i = i + 31
      j = i
      
      Do
        c = Mid$(body, j, 1)
        j = j + 1
      Loop Until c = """"
      
      idArticulo = Mid$(body, i, j - i - 1)
      
      ' Nombre del articulo
      
      Do
        c = Mid$(body, j, 1)
        j = j + 1
      Loop Until c = ">"
      
      i = j
      If next_i < i And next_i > 0 Then Stop
      
      Do
        c = Mid$(body, j, 1)
        j = j + 1
      Loop Until c = "<"
      
      If j - i - 1 <= 0 Then
        clienteIdML = ""
      Else
        nombreArticulo = Mid$(body, i, j - i - 1)
      End If
      
      ' Precio
      
      i = j
      If next_i < i And next_i > 0 Then Stop
      
      i = InStr(i + 1, body, "$")
      If i = 0 Then Exit Do
      If next_i < i And next_i > 0 Then Stop
      
      i = i + 2
      j = i
      
      Do
        c = Mid$(body, j, 1)
        j = j + 1
      Loop Until c = "<"
      
      If j - i - 1 <= 0 Then
        clienteIdML = ""
      Else
        precio = Mid$(body, i, j - i - 1)
      End If
      
      ' Cantidad
      
      i = j
      If next_i < i And next_i > 0 Then Stop
  
      i = InStr(i + 1, body, ">")
      If i = 0 Then Exit Do
      If next_i < i And next_i > 0 Then Stop
      
      i = InStr(i + 1, body, ">")
      If i = 0 Then Exit Do
      If next_i < i And next_i > 0 Then Stop
      
      i = i + 1
      j = i
      
      Do
        c = Mid$(body, j, 1)
        j = j + 1
      Loop Until c = "<"
  
      If j - i - 1 <= 0 Then
        clienteIdML = ""
      Else
        cantidad = Mid$(body, i, j - i - 1)
      End If
      
      ' Fecha
      
      i = j
      If next_i < i And next_i > 0 Then Stop
  
      i = InStr(i + 1, body, ">")
      If i = 0 Then Exit Do
      If next_i < i And next_i > 0 Then Stop
      
      i = InStr(i + 1, body, ">")
      If i = 0 Then Exit Do
      If next_i < i And next_i > 0 Then Stop
      
      i = i + 1
      j = i
      
      Do
        c = Mid$(body, j, 1)
        j = j + 1
      Loop Until c = "<"
  
      If j - i - 1 <= 0 Then
        clienteIdML = ""
      Else
        fecha = DateAdd("d", Date, -20 + Val(Mid$(body, i, j - i - 1)))
      End If
      
      ' Id de la Venta
      
      i = j
      If next_i < i And next_i > 0 Then Stop
      
      i = InStr(i + 1, body, "<A href=""/jm/calif?act=califnow&amp;subAct=calif&amp;as_choose=")
      If i = 0 Then Exit Do
      If next_i < i And next_i > 0 Then
        ' Si estoy aca es por que ya califique y ya no tengo disponible el id de venta
        ' en este caso, no vuelvo a leer la venta y paso a la siguiente
        '
        i = next_i - 1
        
      Else
      
        i = i + 63
        j = i
        
        Do
          c = Mid$(body, j, 1)
          j = j + 1
        Loop Until c = """"
    
        idVenta = Mid$(body, i, j - i - 1)
        
        If next_i < i And next_i > 0 Then Stop
        
        ' Fin
        
        Dim isNew As Boolean
        isNew = False
            
        If linkContacto <> "" Then
        
          isNew = pIsNew(idVenta)
          
          If isNew And Not dataHasBeenRead Then
        
            fInfo.NavigateComplete = False
            fInfo.wb.Navigate2 "http://www.mercadolibre.com.ar" & linkContacto
            
            Dim start As Date
            start = Now
            Do
              DoEvents
              If fInfo.NavigateComplete Then
                
                html = fInfo.wb.Document.documentElement.innerHTML
                
                q = InStr(1, html, "Nombre:")
                q = InStr(q + 1, html, "<TD class=atxt>")
                w = InStr(q + 1, html, "</TD></TR>")
                nombre = Trim$(Mid$(html, q + 15, w - q - 15))
                
                q = InStr(1, html, "Apellido:")
                q = InStr(q + 1, html, "<TD class=atxt><SPAN class=atxt>")
                w = InStr(q + 1, html, "</SPAN></TD></TR>")
                apellido = Trim$(Mid$(html, q + 32, w - q - 32))
                
                q = InStr(1, html, "Email:")
                q = InStr(q + 1, html, "<TD class=atxt>")
                q = InStr(q + 16, html, ">")
                w = InStr(q + 1, html, "</A></TD></TR>")
                email = Trim$(Mid$(html, q + 1, w - q - 1))
                
                q = InStr(1, html, "Teléfono:")
                q = InStr(q + 1, html, "<TD class=atxt>")
                w = InStr(q + 1, html, "</TD></TR>")
                telefono = Trim$(Mid$(html, q + 15, w - q - 15))
                
                q = InStr(1, html, "Localidad:")
                q = InStr(q + 1, html, "<TD class=atxt>")
                w = InStr(q + 1, html, "</TD></TR>")
                localidad = Trim$(Mid$(html, q + 15, w - q - 15))
      
                q = InStr(1, html, "Provincia:")
                q = InStr(q + 1, html, "<TD class=atxt>")
                w = InStr(q + 1, html, "</TD></TR>")
                provincia = Trim$(Mid$(html, q + 15, w - q - 15))
      
                ShowLog "Provincia", provincia, False
                ShowLog "Localidad", localidad, False
                ShowLog "Telefono", telefono, False
                ShowLog "Email", email, False
                ShowLog "Apellido", apellido, False
                ShowLog "Nombre", nombre, False
      
                dataHasBeenRead = True
      
                Exit Do
              End If
              Sleep 0.3
              
              If DateDiff("s", start, Now) > C_BROWSING_TIMEOUT Then
                Exit Sub
              End If
              
            Loop
          End If
        End If
        
        If clienteIdML <> "" Then
          bUpdated = True
          ShowLog "Cantidad", cantidad, False
          ShowLog "Precio", precio, False
          ShowLog "Articulo", nombreArticulo, False
          ShowLog "Id Articulo", idArticulo, False
          ShowLog "Nombre", clienteId, False
          ShowLog "Id Cliente", clienteIdML, False
          ShowLog "**********", "*************", False
                    
          pSaveVentaInDb idVenta, _
                         isNew, _
                         clienteId, _
                         nombre, _
                         apellido, _
                         nombreArticulo, _
                         idArticulo, _
                         precio, _
                         cantidad, _
                         email, _
                         telefono, _
                         localidad, _
                         provincia, _
                         fecha
        End If
      End If
    
    Loop Until next_i < i And next_i > 0
    
  Loop While i <> 0
  
  If bUpdated Then
    ShowHtmlInfo "<table width='100%'><tr><td>Las ventas han sido actualizadas / leidas </td></tr><tr><td><b>" & Now & "</td></tr></table>"
  End If
   
  Err.Clear
End Sub

Private Function pSaveVentaInDb(ByVal idVenta As String, _
                                ByVal isNew As Boolean, _
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
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  Dim precio    As Double
  Dim cantidad  As Double
  Dim tmp       As String
  
  nombre = Trim(nombre)
  apellido = Trim(apellido)
  email = Trim(email)
  
  ' Si no tengo el nombre ni el email que no se cargue el pedido
  ' seguramente es por una mala lectura. Lo obligamos a que lo
  ' vuelva a leer
  '
  If (nombre = "" And apellido = "") Or email = "" Then Exit Function
  
  If GetSepDecimal = "." Then
    tmp = Replace(preciostr, ",", "#")
    tmp = Replace(tmp, ".", ",")
    tmp = Replace(tmp, "#", ".")
    precio = Val(tmp)
  
    tmp = Replace(cantidadstr, ",", "#")
    tmp = Replace(tmp, ".", ",")
    tmp = Replace(tmp, "#", ".")
    cantidad = Val(tmp)
  Else
    precio = Val(preciostr)
    cantidad = Val(cantidadstr)
  End If
  
  sqlstmt = "sp_srv_cvxi_ventasave " & _
                                c_id_mercadolibre & ", " & _
                                c_id_ml_aplicacion & ", " & _
                                gDb.sqlString(gCMIUser) & "," & _
                                gDb.sqlString(idVenta) & "," & _
                                gDb.sqlString(idCliente) & "," & _
                                gDb.sqlString(nombre) & "," & _
                                gDb.sqlString(apellido) & "," & _
                                gDb.sqlString(nombreArticulo) & "," & _
                                gDb.sqlString(idArticulo) & "," & _
                                gDb.sqlString(preciostr) & "," & _
                                gDb.sqlString(cantidadstr) & "," & _
                                gDb.sqlNumber(precio) & "," & _
                                gDb.sqlNumber(cantidad) & "," & _
                                gDb.sqlString(email) & "," & _
                                gDb.sqlString(telefono) & "," & _
                                gDb.sqlString(localidad) & "," & _
                                gDb.sqlString(provincia) & "," & _
                                gDb.sqlDate(fecha)

  If Not gDb.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  'MsgBox "x.x.y.z.1"
  
  If isNew Then
  
    'MsgBox "x.x.y.z.2"
  
    Dim mail As cMail
    Set mail = New cMail
    mail.id = rs.fields("cmie_id")
    mail.cmi_id = c_cmi_id
    mail.cmiea_id = pGetCmiEAId()
    
    If Not m_mail.ProcessMail(mail, _
                              m_cmiea_server, _
                              m_cmiea_user, _
                              m_cmiea_pwd, _
                              m_cmiea_email_server, _
                              m_cmiea_email_user, _
                              m_cmiea_email_pwd, _
                              idCliente, _
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
                              fecha) Then Exit Function
  End If
  
  pSaveVentaInDb = True
  
End Function

Private Function pGetCmiEAId() As Long
  If m_cmiea_id = csNO_ID Then
    Dim sqlstmt As String
    Dim rs As ADODB.Recordset
    sqlstmt = "select * from ComunidadInternetEmailAccount where cmiea_codigo = " & gDb.sqlString(gCMIUser)
    If Not gDb.OpenRs(sqlstmt, rs) Then Exit Function
    If rs.EOF Then
      m_cmiea_id = 1 ' Cuenta auxiliar
      m_cmiea_server = ""
      m_cmiea_user = ""
      m_cmiea_pwd = ""
      m_cmiea_email_server = ""
      m_cmiea_email_user = ""
      m_cmiea_email_pwd = ""
    Else
      m_cmiea_id = gDb.ValField(rs.fields, "cmiea_id")
      m_cmiea_server = gDb.ValField(rs.fields, "cmiea_server")
      m_cmiea_user = gDb.ValField(rs.fields, "cmiea_user")
      m_cmiea_pwd = gDb.ValField(rs.fields, "cmiea_pwd")
      m_cmiea_email_server = gDb.ValField(rs.fields, "cmiea_email_server")
      m_cmiea_email_user = gDb.ValField(rs.fields, "cmiea_email_user")
      m_cmiea_email_pwd = gDb.ValField(rs.fields, "cmiea_email_pwd")
    End If
  End If
  pGetCmiEAId = m_cmiea_id
End Function

Private Function pIsNew(ByVal ventaId As String) As Boolean
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select 1 from ComunidadInternetVenta where cmiv_ventaid = " & gDb.sqlString(ventaId)
  If Not gDb.OpenRs(sqlstmt, rs) Then Exit Function
  pIsNew = rs.EOF
End Function

Private Sub Class_Initialize()
  On Error Resume Next
  Set m_mail = New cMercadoLibreMail
End Sub

Private Function pGetInterval() As Long
  Dim interval As Long
  interval = Val(IniGet(c_k_intervalVtas, "30000"))
  If interval = 0 Then interval = 30000
  '
  ' En visual basic 6 interval es un long, pero el valor maximo
  ' que soporta es 65535
  '
  If interval > 65535 Then interval = 65535
  pGetInterval = interval
End Function

