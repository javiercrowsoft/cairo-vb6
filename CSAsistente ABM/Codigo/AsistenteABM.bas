Attribute VB_Name = "AsistenteABM"
Option Explicit
Private Const tInt = 4
Private Const tTinyint = -6
Private Const tVarchar = 12
Private Const tDateTime = 11
Private Const tSmallInt = 5
Private Const tMoney = 3
Private Const tReal = 7

Private m_NextClave       As Integer
Private m_Clave           As String
Private m_Miembro         As String
Private m_Property        As String
Private m_Save            As String
Private m_HeaderSave      As String
Private m_FooterSave      As String

Private m_CargarCol       As String
Private m_HeaderCargarCol As String
Private m_FooterCargarCol As String

Private m_HeaderCargar      As String
Private m_MediumCargar      As String
Private m_FooterCargar      As String
Private m_CargarIf          As String
Private m_CargarElse        As String

Private m_Constantes      As String
    
Private m_HeaderValidate As String
Private m_FooterValidate As String

Private cxn As Connection

Private Type T_Nombres
  Nombre As String
  NuevoNombre As String
End Type

Private m_vNombres() As T_Nombres

Public Sub Main()
    Set cxn = New ADODB.Connection
    frmAsistente.Show
End Sub

Public Function Conectar() As Boolean
    On Error GoTo ControlError
    
    Dim sConnect As String
    
    If frmAsistente.txtServidor.Text = "" Then
        MsgBox "Debe ingresar el nombre del servidor", vbInformation
        Exit Function
    End If
    If frmAsistente.txtBaseDatos.Text = "" Then
        MsgBox "Debe ingresar el nombre de la base", vbInformation
        Exit Function
    End If
    If frmAsistente.txtUsuario.Text = "" Then
        MsgBox "Debe ingresar un nombre de usuario", vbInformation
        Exit Function
    End If
    
    If cxn.State = adStateOpen Then cxn.Close
    
    sConnect = "PROVIDER=MSDASQL;driver={SQL Server};server=" + frmAsistente.txtServidor.Text
    sConnect = sConnect + ";uid=" + frmAsistente.txtUsuario.Text + ";pwd=" + frmAsistente.txtClave.Text + ";database=" + frmAsistente.txtBaseDatos.Text + ";"
    cxn.Open sConnect
    Conectar = CargarCombo
    Exit Function
ControlError:
    MngError "Conectar"
End Function

Public Sub MngError(ByVal Funcion As String)
    MsgBox Err.Description, vbCritical, "Error en Funcion " & Funcion
End Sub

Public Function CargarCombo() As Boolean
    On Error GoTo ControlError
    
    Dim rcst As Recordset
    Set rcst = New Recordset
    rcst.CursorLocation = adUseClient
    rcst.Open "sp_tables", cxn, adOpenStatic, adLockReadOnly
    
    frmAsistente.cbTablas.Clear
    While Not rcst.EOF
        If rcst.Fields("TABLE_TYPE") = "TABLE" Then
            frmAsistente.cbTablas.AddItem rcst.Fields("TABLE_NAME")
        End If
        rcst.MoveNext
    Wend
    
    CargarCombo = True
    Exit Function
ControlError:
    MngError "CargarCombo"
End Function

Public Function Generar() As Boolean
    On Error GoTo ControlError
         
    If frmAsistente.txtPreTabla.Text = "" Then
      MsgBox "Debe ingresar el prefijo de la tabla", vbInformation
      Exit Function
    End If
    If frmAsistente.txtPreConstante.Text = "" Then
      MsgBox "Debe ingresar el prefijo para las constantes", vbInformation
      Exit Function
    End If
    If frmAsistente.cbTablas.ListIndex = -1 Then
      MsgBox "Debe seleccionar una tabla", vbInformation
      Exit Function
    End If
    
    ReDim m_vNombres(0)
    
    Dim rcst As Recordset
    Set rcst = New Recordset
    rcst.CursorLocation = adUseClient
    rcst.Open "sp_columns '" & frmAsistente.cbTablas.Text & "'", cxn, adOpenStatic, adLockReadOnly
    
    GetClave
    InitSave
    InitCargarColeccion
    InitCargar
    InitValidate
        
    While Not rcst.EOF
        GenerarClave rcst.Fields("COLUMN_NAME").Value, rcst.Fields("DATA_TYPE").Value
        GenerarMiembros rcst.Fields("COLUMN_NAME").Value, rcst.Fields("DATA_TYPE").Value
        GenerarProperty rcst.Fields("COLUMN_NAME").Value, rcst.Fields("DATA_TYPE").Value
        GenerarSave rcst.Fields("COLUMN_NAME").Value, rcst.Fields("DATA_TYPE").Value
        GenerarConstantes rcst.Fields("COLUMN_NAME").Value, rcst.Fields("DATA_TYPE").Value
        GenerarCargarColeccion rcst.Fields("COLUMN_NAME").Value, rcst.Fields("DATA_TYPE").Value, rcst.Fields("LENGTH").Value
        GenerarCargar rcst.Fields("COLUMN_NAME").Value, rcst.Fields("DATA_TYPE").Value
        GenerarValidate rcst.Fields("COLUMN_NAME").Value, rcst.Fields("DATA_TYPE").Value
        rcst.MoveNext
    Wend
    
    frmAsistente.txtResultado.Text = GetConstantes & vbCrLf & GetConstantesSeguridad & vbCrLf & GetClave & vbCrLf & GetMiembro & vbCrLf & GetProperty & vbCrLf & GetSave & vbCrLf & GetCargarColeccion & vbCrLf & GetCargar & vbCrLf & GetValidate
    
    
    Generar = True
    Exit Function
ControlError:
    MngError "Generar"
End Function

Private Sub GenerarClave(ByVal CN As String, ByVal DT As Integer)
    Dim Nombre As String
    Nombre = UCase(GetNombre(CN))
    
    Select Case LCase(Nombre)
      Case "creado", "modificado", "modifico", "id"
      Case Else
        m_Clave = m_Clave & "Private Const K_" & Nombre & String(30 - Len(Nombre), " ") & " As Integer =" & m_NextClave & vbCrLf
        m_NextClave = m_NextClave + 1
    End Select
End Sub

Private Function GetClave() As String
    GetClave = m_Clave
    m_Clave = ""
    m_NextClave = 1
End Function

Private Sub GenerarMiembros(ByVal CN As String, ByVal DT As Integer)
    Dim Nombre As String
    Nombre = GetNombre(CN)
    Nombre = "m_" & UCase(Left(Nombre, 1)) & Mid(Nombre, 2)
    m_Miembro = m_Miembro & "Private " & Nombre & String(30 - Len(Nombre), " ") & " As " & GetDataType(DT) & vbCrLf
    
    If UCase(Left(CN, Len(frmAsistente.txtPreTabla))) <> UCase(frmAsistente.txtPreTabla) _
        And LCase(CN) <> "modifico" _
        And LCase(CN) <> "modificado" _
        And LCase(CN) <> "creado" _
        And LCase(CN) <> "activo" Then
        
        Nombre = GetNombreForFK(Nombre)

        m_Miembro = m_Miembro & "Private " & Nombre & String(30 - Len(Nombre), " ") & " As String" & vbCrLf
    End If
End Sub

Private Function GetMiembro() As String
    GetMiembro = m_Miembro
    m_Miembro = ""
End Function

Private Function GetDataType(ByVal DT As Integer) As String
    Select Case DT
        Case tInt
            GetDataType = "Long"
        Case tTinyint
            GetDataType = "Boolean"
        Case tVarchar
            GetDataType = "String"
        Case tDateTime
            GetDataType = "Date"
        Case tSmallInt
            GetDataType = "Integer"
        Case tMoney
            GetDataType = "Double"
        Case tReal
            GetDataType = "Double"
        Case Else
            GetDataType = "tipo desconocido " & DT
    End Select
End Function

Private Sub GenerarProperty(ByVal CN As String, ByVal DT As Integer)
    Dim Nombre As String
    Nombre = GetNombre(CN)
    Nombre = UCase(Left(Nombre, 1)) & Mid(Nombre, 2)
    
    m_Property = m_Property & "Public Property Get " & Nombre & "()As " & GetDataType(DT) & vbCrLf
    m_Property = m_Property & "  " & Nombre & " = m_" & Nombre & vbCrLf
    m_Property = m_Property & "End Property " & vbCrLf & vbCrLf
    
    m_Property = m_Property & "Public Property Let " & Nombre & "(byval rhs as " & GetDataType(DT) & ")" & vbCrLf
    m_Property = m_Property & "  m_" & Nombre & "= rhs " & vbCrLf
    m_Property = m_Property & "End Property " & vbCrLf & vbCrLf
    
    If UCase(Left(CN, Len(frmAsistente.txtPreTabla))) <> UCase(frmAsistente.txtPreTabla) _
        And LCase(CN) <> "modifico" _
        And LCase(CN) <> "modificado" _
        And LCase(CN) <> "creado" _
        And LCase(CN) <> "activo" Then
        
        m_Property = m_Property & "Public Property Get " & GetNombreForFKFromVector(Nombre) & "()As String" & vbCrLf
        m_Property = m_Property & "  " & GetNombreForFKFromVector(Nombre) & " = m_" & GetNombreForFKFromVector(Nombre) & vbCrLf
        m_Property = m_Property & "End Property " & vbCrLf & vbCrLf
        
        m_Property = m_Property & "Public Property Let " & GetNombreForFKFromVector(Nombre) & "(byval rhs as String)" & vbCrLf
        m_Property = m_Property & "  m_" & GetNombreForFKFromVector(Nombre) & "= rhs " & vbCrLf
        m_Property = m_Property & "End Property " & vbCrLf & vbCrLf
    End If
End Sub

Private Function GetProperty() As String
    GetProperty = m_Property
    m_Property = ""
End Function

Private Function GetNombre(ByVal Nombre As String) As String
    If 1 = InStr(1, Nombre, frmAsistente.txtPreTabla.Text, vbTextCompare) Then
        Nombre = Mid(Nombre, Len(frmAsistente.txtPreTabla.Text) + 1)
    End If
    GetNombre = Nombre
End Function

Private Sub GenerarSave(ByVal CN As String, ByVal DT As Integer)
    Dim Nombre As String
    Nombre = GetNombre(CN)
    Nombre = UCase(Nombre)
    
    Select Case LCase(Nombre)
      Case "creado", "modificado", "modifico", "id"
      Case Else
        m_Save = m_Save & "        Case K_" & Nombre & vbCrLf
        'If GetCSPType(CN, DT) = "c.PropertyType = cspHelp" Then
        If InStr(1, Trim(GetCSPType(CN, DT)), "c.PropertyType = cspHelp") Then
          m_Save = m_Save & "          register.Fields.Add2 csc" & Replace(CN, "_", "") & ", .HelpId, " & GetCSType(CN, DT) & vbCrLf
        Else
          m_Save = m_Save & "          register.Fields.Add2 csc" & Replace(CN, "_", "") & ", .value, " & GetCSType(CN, DT) & vbCrLf
        End If
    End Select
End Sub

Private Function GetCSType(ByVal CN As String, ByVal DT As Integer) As String
    If InStr(1, CN, "_id", vbTextCompare) Or LCase(CN) = "modifico" Then
        GetCSType = " csId"
    Else
        Select Case DT
            Case tInt
                GetCSType = " csLong"
            Case tTinyint
                GetCSType = " csBoolean"
            Case tVarchar
                GetCSType = " csText"
            Case tDateTime
                GetCSType = " csDate"
            Case tSmallInt
                GetCSType = " csInteger"
            Case tMoney
                GetCSType = " csCurrency"
            Case tReal
                GetCSType = " csDouble"
            Case Else
                GetCSType = "tipo desconocido " & DT
        End Select
    
    End If
End Function

Private Function GetSave() As String
    GetSave = m_HeaderSave & vbCrLf & m_Save & m_FooterSave & vbCrLf
    m_Save = ""
End Function

Private Sub InitSave()
    m_HeaderSave = ""
    m_FooterSave = ""
    
    m_HeaderSave = m_HeaderSave & vbCrLf & "Private Function cIABMClient_Save() As Boolean"
    m_HeaderSave = m_HeaderSave & vbCrLf & "  Dim register As cRegister"
    m_HeaderSave = m_HeaderSave & vbCrLf & "  Set register = New cRegister"
        
    m_HeaderSave = m_HeaderSave & vbCrLf & "  register.fieldId = csc" & frmAsistente.txtPreConstante.Text & "Id"
    m_HeaderSave = m_HeaderSave & vbCrLf & "  register.table = csT" & frmAsistente.cbTablas.Text

        
        
    m_HeaderSave = m_HeaderSave & vbCrLf & "  If m_Copy Then"
    m_HeaderSave = m_HeaderSave & vbCrLf & "    register.ID = csNew"
    m_HeaderSave = m_HeaderSave & vbCrLf & "  Else"
    m_HeaderSave = m_HeaderSave & vbCrLf & "    register.ID = m_Id"
    m_HeaderSave = m_HeaderSave & vbCrLf & "  End If"
        
        
    m_HeaderSave = m_HeaderSave & vbCrLf & "  Dim IProperty As cIABMProperty"
    m_HeaderSave = m_HeaderSave & vbCrLf & "  For Each IProperty In m_ObjAbm.Properties"
    m_HeaderSave = m_HeaderSave & vbCrLf & "    With IProperty"
    m_HeaderSave = m_HeaderSave & vbCrLf & "      Select Case .Key"
    

    m_FooterSave = m_FooterSave & vbCrLf & "      End Select"
    m_FooterSave = m_FooterSave & vbCrLf & "    End With"
    m_FooterSave = m_FooterSave & vbCrLf & "  Next"
    m_FooterSave = m_FooterSave & vbCrLf & "  "
    m_FooterSave = m_FooterSave & vbCrLf & "  register.Fields.HaveLastUpdate = True"
    m_FooterSave = m_FooterSave & vbCrLf & "  register.Fields.HaveWhoModify = True"
    m_FooterSave = m_FooterSave & vbCrLf & "  "
    m_FooterSave = m_FooterSave & vbCrLf & "  If Not gDB.Save(register, , ""cIABMClient_Save"", ""c" & frmAsistente.cbTablas.Text & """, ""Error al grabar " & frmAsistente.cbTablas.Text & """) Then Exit Function"
    m_FooterSave = m_FooterSave & vbCrLf & "  "
    m_FooterSave = m_FooterSave & vbCrLf & "  m_Copy = False"
    m_FooterSave = m_FooterSave & vbCrLf & "  cIABMClient_Save = Load(register.Id)"
    m_FooterSave = m_FooterSave & vbCrLf & "End Function"
End Sub

Private Sub GenerarConstantes(ByVal CN As String, ByVal DT As Integer)
    Dim Nombre As String
    Dim Prefijo As String
    
    Nombre = GetNombre(CN)
    Nombre = UCase(Left(Nombre, 1)) & Mid(Nombre, 2)
    If InStr(1, CN, frmAsistente.txtPreTabla.Text, vbTextCompare) Then
      Prefijo = UCase(Mid(frmAsistente.txtPreConstante, 1, 1)) & Mid(frmAsistente.txtPreConstante, 2)
      m_Constantes = m_Constantes & "Public Const csc" & Prefijo & Nombre & String(35 - Len(Nombre), " ") & "As String = """ & CN & """" & vbCrLf
    End If
End Sub

Private Function GetConstantes() As String
    With frmAsistente.cbTablas
        GetConstantes = "Public Const csT" & .Text & String(38 - Len(.Text), " ") & "As String = """ & .Text & """" & vbCrLf & m_Constantes
    End With
    m_Constantes = ""
End Function

Private Function GetConstantesSeguridad() As String
    Dim s As String
    Dim t As String
    
    t = UCase(Mid(frmAsistente.cbTablas.Text, 1, 1)) & Mid(frmAsistente.cbTablas.Text, 2)
    s = s + "csPreGNew" & t & " = " & vbCrLf
    s = s + "csPreGEdit" & t & " = " & vbCrLf
    s = s + "csPreGDelete" & t & " = " & vbCrLf
    s = s + "csPreGList" & t & " = " & vbCrLf
    
'    s = s + vbCrLf + "Private Function cIEditGenerico_MostrarLista() As Boolean"
'    s = s + vbCrLf + "  cIEditGenerico_MostrarLista = SeguridadAccede(csPreGLista" & t & ")"
'    s = s + vbCrLf + "End Function"
'
'    s = s + vbCrLf
'
'    s = s + vbCrLf + "Private Function cIEditGenerico_Borrar(Id As Long) As Boolean"
'    s = s + vbCrLf + "  If Not SeguridadAccede(csPreGBorrar" & t & ") Then Exit Function"
'    s = s + vbCrLf + "  "
'    s = s + vbCrLf + "  Dim sqlstmt As String"
'    s = s + vbCrLf + "  "
'    s = s + vbCrLf + "  sqlstmt = ""Delete "" & csT" & t & " & "" where "" & cscProId & "" = "" & Id"
'    s = s + vbCrLf + "  "
'    s = s + vbCrLf + "  cIEditGenerico_Borrar = gDB.Execute(sqlstmt, ""cIEditGenerico_Borrar"", ""c" & t & """)"
'    s = s + vbCrLf + "End Function"
'
'    s = s + vbCrLf
'
'    s = s + vbCrLf + "Private Function cIEditGenerico_Editar(Id As Long) As Boolean"
'    s = s + vbCrLf + "  On Error GoTo ControlError"
'    s = s + vbCrLf + "  "
'    s = s + vbCrLf + "  If Id = csNO_ID Then"
'    s = s + vbCrLf + "    m_Nuevo = True"
'    s = s + vbCrLf + "    If Not SeguridadAccede(csPreGAlta" & t & ") Then Exit Function"
'    s = s + vbCrLf + "  Else"
'    s = s + vbCrLf + "    m_Nuevo = False"
'    s = s + vbCrLf + "    If Not SeguridadAccede(csPreGEditar" & t & ") Then Exit Function"
'    s = s + vbCrLf + "  End If"
'    s = s + vbCrLf + "  "
'    s = s + vbCrLf + "  If Not Cargar(Id) Then Exit Function"
'    s = s + vbCrLf + "  "
'    s = s + vbCrLf + "  If Not CargarColeccion() Then Exit Function"
'    s = s + vbCrLf + "  "
'    s = s + vbCrLf + "  m_Editando = True"
'    s = s + vbCrLf + "  cIEditGenerico_Editar = True"
'    s = s + vbCrLf + "  Exit Function"
'    s = s + vbCrLf + "ControlError:"
'    s = s + vbCrLf + "  MngError ""cIEditGenerico_Editar"", ""c" & t & """, """
'    s = s + vbCrLf + "End Function"
    
    GetConstantesSeguridad = vbCrLf & s
End Function

Public Sub GenerarCargarColeccion(ByVal CN As String, ByVal DT As Integer, ByVal Tamano As String)
    Dim s As String
    Dim Nombre As String

    Nombre = GetNombre(CN)
    
    Select Case LCase(Nombre)
      Case "creado", "modificado", "modifico", "id"
      Case Else
      
        If InStr(1, Nombre, "_") > 0 Then
          s = s + vbCrLf + "  Set c = m_ObjAbm.Properties.Add(c, csc" & Replace(Nombre, "_", "") & ")"
        ElseIf LCase(Nombre) = LCase("activo") Then
          s = s + vbCrLf + "  Set c = m_ObjAbm.Properties.Add(c, csc" & Nombre & ")"
        Else
          s = s + vbCrLf + "  Set c = m_ObjAbm.Properties.Add(c, csc" & frmAsistente.txtPreConstante & Nombre & ")"
        End If
        s = s + vbCrLf + "  " & GetCSPType(CN, DT)
        s = s + vbCrLf + "  c.name = """ & Nombre & """"
        If GetCSPType(CN, DT) = "c.PropertyType = cspText" Then s = s + vbCrLf + "  c.size = " & Tamano
        s = s + vbCrLf + "  c.Key = K_" & Nombre
        
        'If GetCSPType(CN, DT) = "c.PropertyType = cspHelp" Then
        If InStr(1, Trim(GetCSPType(CN, DT)), "c.PropertyType = cspHelp") Then
          s = s + vbCrLf + "  c.Value = m_" & GetNombreForFKFromVector(Nombre)
          s = s + vbCrLf + "  c.HelpId = m_" & Nombre
        Else
          If DT = tTinyint Then
            s = s + vbCrLf + "  c.value = cint(m_" & Nombre & ")"
          Else
            s = s + vbCrLf + "  c.value = " & Nombre
          End If
        End If
        
        s = s + vbCrLf + "  Set c = Nothing"
    
        m_CargarCol = m_CargarCol & s & vbCrLf
    End Select
End Sub

Private Function GetCSPType(ByVal CN As String, ByVal DT As Integer) As String
    If InStr(1, CN, "_id", vbTextCompare) Or LCase(CN) = "modifico" Then
        GetCSPType = "c.PropertyType = cspHelp" & vbCrLf & "  c.Table = "
        
    Else
        Select Case DT
            Case tInt, tSmallInt, tMoney
                GetCSPType = "c.PropertyType = cspNumeric"
            Case tTinyint
                GetCSPType = "c.PropertyType = cspCheck"
            Case tVarchar
                GetCSPType = "c.PropertyType = cspText"
            Case tDateTime
                GetCSPType = "c.PropertyType = cspDate"
            Case tReal
                GetCSPType = "c.PropertyType = cspDouble"
            Case Else
                GetCSPType = "c.PropertyType = tipo desconocido " & DT
        End Select
    
    End If
End Function

Public Sub InitCargarColeccion()
    m_HeaderCargarCol = ""
    m_FooterCargarCol = ""
    m_HeaderCargarCol = m_HeaderCargarCol + vbCrLf + "Private Function LoadCollection() As Boolean"
    m_HeaderCargarCol = m_HeaderCargarCol + vbCrLf + "  m_ObjAbm.Properties.Clear"
    m_HeaderCargarCol = m_HeaderCargarCol + vbCrLf + "  "
    m_HeaderCargarCol = m_HeaderCargarCol + vbCrLf + "  Dim c As cIABMProperty"
    m_HeaderCargarCol = m_HeaderCargarCol + vbCrLf + "  "
    
    m_FooterCargarCol = m_FooterCargarCol + vbCrLf + "  "
    m_FooterCargarCol = m_FooterCargarCol + vbCrLf + "  If Not m_ObjAbm.Show(Me) Then Exit Function"
    m_FooterCargarCol = m_FooterCargarCol + vbCrLf + "  "
    m_FooterCargarCol = m_FooterCargarCol + vbCrLf + "  LoadCollection = True"
    m_FooterCargarCol = m_FooterCargarCol + vbCrLf + "End Function"
End Sub

Private Function GetCargarColeccion() As String
    GetCargarColeccion = m_HeaderCargarCol & vbCrLf & m_CargarCol & m_FooterCargarCol & vbCrLf
    m_CargarCol = ""
End Function

Public Sub InitCargar()
    m_HeaderCargar = ""
    m_FooterCargar = ""
    m_HeaderCargar = m_HeaderCargar + vbCrLf + "Private Function Load(ByVal Id As Long) As Boolean"
    m_HeaderCargar = m_HeaderCargar + vbCrLf
    m_HeaderCargar = m_HeaderCargar + vbCrLf + "  Dim sqlstmt As String"
    m_HeaderCargar = m_HeaderCargar + vbCrLf
    
    m_HeaderCargar = m_HeaderCargar + vbCrLf + "  sqlstmt = sqlstmt & ""SELECT * FROM "" & <<NombreTabla>> & "" WHERE "" & <<NOMBRE_CAMPO_ID>> & ""="" & Id"
    
    m_HeaderCargar = m_HeaderCargar + vbCrLf
    m_HeaderCargar = m_HeaderCargar + vbCrLf + "  Dim rs As recordset"
    
    m_HeaderCargar = m_HeaderCargar + vbCrLf
    m_HeaderCargar = m_HeaderCargar + vbCrLf + "  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, ""Load"", ""c" & frmAsistente.cbTablas & """) Then Exit Function"
    m_HeaderCargar = m_HeaderCargar + vbCrLf
    m_HeaderCargar = m_HeaderCargar + vbCrLf + "  If Not rs.EOF Then"
    m_HeaderCargar = m_HeaderCargar + vbCrLf
    m_MediumCargar = m_MediumCargar + vbCrLf + "  Else"
    m_MediumCargar = m_MediumCargar + vbCrLf
    m_FooterCargar = m_FooterCargar + vbCrLf + "  End If"
    m_FooterCargar = m_FooterCargar + vbCrLf
    m_FooterCargar = m_FooterCargar + vbCrLf + "  Load = True"
    m_FooterCargar = m_FooterCargar + vbCrLf + "End Function"
End Sub

Private Function GetCargar() As String
    GetCargar = m_HeaderCargar & vbCrLf & m_CargarIf & m_MediumCargar & m_CargarElse & m_FooterCargar & vbCrLf
    m_CargarIf = ""
    m_CargarElse = ""
    m_HeaderCargar = ""
    m_MediumCargar = ""
    m_FooterCargar = ""
End Function

Public Sub GenerarCargar(ByVal CN As String, ByVal DT As Integer)
    Dim s As String
    Dim Nombre As String
    Dim Nombre2 As String

    Nombre = GetNombre(CN)
    Nombre2 = Nombre
    If InStr(1, CN, frmAsistente.txtPreTabla.Text, vbTextCompare) Then
        Nombre2 = Trim(frmAsistente.txtPreConstante) + Nombre
    End If
    
    Select Case DT
        Case tInt, tSmallInt, tMoney
            s = "m_" + Nombre + " = 0"
        Case tTinyint
            If Nombre = "activo" Then
              s = "m_" + Nombre + " = true"
            Else
              s = "m_" + Nombre + " = False"
            End If
        Case tVarchar
            s = "m_" + Nombre + " = """""
        Case tDateTime
            s = "m_" + Nombre + " = csNoDate"
        Case Else
            s = "m_" + Nombre + " = 0"
    End Select
    
    If InStr(1, CN, "_id", vbTextCompare) <> 0 Then s = "m_" + Nombre + " = csNO_ID"
    
    s = "    " + s + vbCrLf
    
    m_CargarElse = m_CargarElse & s
    
    s = "m_" + Nombre + " = gDB.ValField(rs.fields,csc" + Nombre2 + ")"
    
    m_CargarIf = m_CargarIf & "    " & s + vbCrLf
End Sub

Public Sub InitValidate()
    m_HeaderValidate = ""
    m_FooterValidate = ""
    m_HeaderValidate = m_HeaderValidate + vbCrLf + "Private Function cIABMClient_Validate() As Boolean"
    m_HeaderValidate = m_HeaderValidate + vbCrLf
    m_HeaderValidate = m_HeaderValidate + vbCrLf + "  Dim IProperty As cIABMProperty"
    m_HeaderValidate = m_HeaderValidate + vbCrLf
    m_HeaderValidate = m_HeaderValidate + vbCrLf + "  For Each IProperty In m_ObjAbm.Properties"
    m_HeaderValidate = m_HeaderValidate + vbCrLf + "    With IProperty"
    m_HeaderValidate = m_HeaderValidate + vbCrLf + "      Select Case .Key"
    
        
    m_FooterValidate = m_FooterValidate + vbCrLf + "      End Select"
    m_FooterValidate = m_FooterValidate + vbCrLf + "    End With"
    m_FooterValidate = m_FooterValidate + vbCrLf + "  Next"
    m_FooterValidate = m_FooterValidate + vbCrLf
    m_FooterValidate = m_FooterValidate + vbCrLf + "  cIABMClient_Validate = True"
    m_FooterValidate = m_FooterValidate + vbCrLf + "End Function"
End Sub

Public Sub GenerarValidate(ByVal CN As String, ByVal DT As Integer)
    Dim Nombre As String
    Nombre = LCase(GetNombre(CN))
    If Nombre = "modificado" Or Nombre = "modifico" Or Nombre = "creado" Or Nombre = "activo" Or Nombre = "id" Then Exit Sub
    m_HeaderValidate = m_HeaderValidate + vbCrLf + "        Case K_" & Nombre
    
    If InStr(1, Trim(GetCSPType(CN, DT)), "c.PropertyType = cspHelp") Then
      m_HeaderValidate = m_HeaderValidate + vbCrLf + "          If ValEmpty(.HelpId, " & GetCSType(CN, DT) & ") Then"
    Else
      m_HeaderValidate = m_HeaderValidate + vbCrLf + "          If ValEmpty(.value, " & GetCSType(CN, DT) & ") Then"
    End If
    
    m_HeaderValidate = m_HeaderValidate + vbCrLf + "            MsgInfo  ""Debe indicar un " & Nombre & """"
    m_HeaderValidate = m_HeaderValidate + vbCrLf + "            Exit Function"
    m_HeaderValidate = m_HeaderValidate + vbCrLf + "          End If"

End Sub

Private Function GetValidate() As String
    GetValidate = m_HeaderValidate & vbCrLf & m_FooterValidate & vbCrLf
    m_HeaderValidate = ""
    m_FooterValidate = ""
End Function

Private Function GetNombreForFK(ByVal Nombre As String) As String
  Dim NuevoNombre As String
  Dim rtn As Integer
  Do
    NuevoNombre = InputBox("Ingrese el nombre para " & Nombre, , Nombre & "22")
    If NuevoNombre = "" Then
      rtn = MsgBox("¿Confirma el uso de " & Nombre & "?", vbQuestion + vbYesNoCancel)
      If vbYes = rtn Then
        NuevoNombre = Nombre & "22"
        Exit Do
      ElseIf rtn = vbCancel Then
        Err.Raise 1
      End If
    End If
  Loop Until NuevoNombre <> ""
  
  ReDim Preserve m_vNombres(UBound(m_vNombres()) + 1)
  With m_vNombres(UBound(m_vNombres))
    .Nombre = Nombre
    .NuevoNombre = NuevoNombre
  End With
  
  GetNombreForFK = "m_" & NuevoNombre
End Function

Private Function GetNombreForFKFromVector(ByVal Nombre As String) As String
  Dim i As Integer
  
  For i = 1 To UBound(m_vNombres)
    If LCase(m_vNombres(i).Nombre) = LCase("m_" & Nombre) Then
      GetNombreForFKFromVector = m_vNombres(i).NuevoNombre
      Exit Function
    End If
  Next
End Function
