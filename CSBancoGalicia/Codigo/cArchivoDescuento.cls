VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cArchivoDescuento"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Const c_doc_dni = 1
Const c_doc_le = 2
Const c_doc_lc = 3
Const c_doc_ci = 4
Const c_doc_pasaporte = 5

Const c_ordendebito = 1
Const c_adhesiones = 2

Private Const C_Module = "cArchivoDescuento"

Private m_errorMsg    As String
Private m_file        As String
Private m_fullFile    As String

Private m_collInsc    As Collection
Private m_cobranzas   As Collection
Private m_header      As cHeader

Public Property Get Header() As cHeader
  Set Header = m_header
End Property

Public Property Get Cobranzas() As Collection
  Set Cobranzas = m_cobranzas
End Property

Public Property Get ErrorMsg() As String
  ErrorMsg = m_errorMsg
End Property

Public Property Get FullFile() As String
  FullFile = m_fullFile
End Property

Public Property Get File() As String
  File = m_file
End Property

Private Sub ClearInscripciones()
  Set m_collInsc = New Collection
End Sub

Public Sub AddInscripcion(ByVal insc_id As Long)
  On Error Resume Next
  m_collInsc.Add insc_id, "k" & insc_id
End Sub

Public Function ApplyPagos(ByVal path As String, ByVal name As String, ByVal us_id As Long) As Boolean
  On Error GoTo ControlError
  
  Dim insc_id As Variant
  
  If Not LoadFile(path, name) Then Exit Function

  For Each insc_id In m_collInsc
    pApplyPagos insc_id, us_id
  Next

  ApplyPagos = True
  
  GoTo ExitProc
ControlError:
  MngError err, "ApplyPagos", C_Module, ""
  If err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function LoadFile(ByVal path As String, ByVal name As String) As Boolean
  On Error GoTo ControlError
  
  If Right(path, 1) <> "\" Then path = path & "\"
  
  m_file = name
  m_fullFile = path & name
  
  Dim dbhelper      As Object
  Dim sqlstmt       As String
  Dim rs            As Object
  Dim f             As Long
  Dim strLine       As String
  Dim bgalarch_id   As Long
  Dim cobranza      As cCobranza
  
  Set m_cobranzas = New Collection
  
  f = FreeFile
  
  Open m_fullFile For Input As #f
  
  If EOF(f) Then err.Raise vbObjectError + 1, C_Module, "El archivo esta vacio"
  
  ' Header
  '
  pReadHeader f
  
  While Not EOF(f)
  
    Line Input #f, strLine
    
    If pIsRegistroDetalle(strLine) Then
    
      m_cobranzas.Add pReadCobranza(strLine)
    End If
    
  Wend
  
  Set dbhelper = CreateObject("CSWebDataBase.cDBHelper")
    
  For Each cobranza In m_cobranzas
    
    sqlstmt = "sp_web_CBUGaliciaGetInsc2 " & pGetStringSql(cobranza.IdRegistro)
    Set rs = dbhelper.RunSQLReturnRS(sqlstmt, Empty)
    
    If Not rs.EOF Then
    
      With cobranza.Inscripcion
        .insc_id = ValField(rs.Fields, "insc_id")
        .Apellido = ValField(rs.Fields, "insc_apellido")
        .Cbu = ValField(rs.Fields, "aabainsc_nrocbu")
        .Doctipo = ValField(rs.Fields, "insc_tipodocumento")
        .Importe = ValField(rs.Fields, "insc_importe")
        .Nombre = ValField(rs.Fields, "insc_nombre")
        .Nrodoc = ValField(rs.Fields, "insc_documento")
        .Numero = ValField(rs.Fields, "insc_numero")
        .Socio = ValField(rs.Fields, "insc_socio")
        .SocioLASFAR = ValField(rs.Fields, "insc_socioLASFAR")
        .Fecha = ValField(rs.Fields, "insc_fecha")
      End With
    End If
  Next
  
  LoadFile = True
  
  GoTo ExitProc
ControlError:
  MngError err, "LoadFile", C_Module, ""
  If err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Close f
End Function

Public Function MakeFile(ByVal path As String, ByVal name As String, _
                         ByVal Fecha As Date, ByVal us_id As Long) As Boolean
  On Error GoTo ControlError
  
  If Right(path, 1) <> "\" Then path = path & "\"
  
  m_file = name
  m_fullFile = path & name
  
  Dim dbhelper      As Object
  Dim sqlstmt       As String
  Dim insc_id       As Variant
  Dim rs            As Object
  Dim f             As Long
  Dim str           As String
  Dim bgalarch_id   As Long
  
  f = FreeFile
  
  bgalarch_id = pSaveArchivo(Fecha, c_ordendebito, us_id)
  
  Open m_fullFile For Output As #f
  
  ' Header
  '
  str = "0000"                                        ' Tipo de registro
  '
  ' TODO: validar cons sistemas del galicia que este codigo sea el correcto
  '
  str = str & "0370"                                  ' Nro. prestacion
                                                        ' 0370 orden de debito
  str = str & "D"                                     ' Servicio
                                                        ' D    Debito automatico
  str = str & Format(Date, "yyyymmdd")                ' Fecha de generacion
  str = str & "1"                                     ' Identificacion de archivo
                                                      ' debe ser unico por
                                                        ' fecha + prestacion + servicio
  str = str & "EMPRESA"                               ' Origen
                                                        ' EMPRESA o BANCO
  str = str & pGetTotal()                             ' Importe total
  str = str & pGetFixNumber(m_collInsc.Count, 7, 0)   ' Excluidos header y footer
  str = str & String(304, " ")                        ' Blancos
  
  Print #f, str
  
  Set dbhelper = CreateObject("CSWebDataBase.cDBHelper")
  
  ' Details
  '
  For Each insc_id In m_collInsc
  
    sqlstmt = "sp_web_CBUGaliciaGetInsc " & CLng(insc_id)
    Set rs = dbhelper.RunSQLReturnRS(sqlstmt, Empty)
    
    If Not rs.EOF Then
      str = "0370"                                                ' Tipo de registro
                                                                    ' 0370 orden de debito
      'MsgBox (Len(str))
      str = str & pGetIdentCliente(rs)                            ' Identificacion del cliente
      
      'MsgBox (Len(str))
      '
      ' TODO: verificar que este bien formado
      '
      str = str & pGetCBU(rs)                                     ' CBU
      'MsgBox (Len(str))
      '
      ' TODO: preguntarle a sistemas del galicia como se completa este campo
      '
      str = str & pGetRef(rs)                                     ' Refrencia univoca
      
      'MsgBox (Len(str))
      str = str & pGetVto(rs)                                     ' Fecha 1er vto.
      'MsgBox (Len(str))
      str = str & pGetFixNumber( _
                      ValField(rs.Fields, "insc_importe"), 14, 2) ' Importe 1er vto.
      'MsgBox (Len(str))
      '
      ' TODO: definir con AAARBA si van a usar estos vencimientos
      '       y ver con sistemas del galicia cuales son las reglas
      '
      str = str & pGetVto(rs)                                     ' Fecha 2do vto.
      'MsgBox (Len(str))
      str = str & pGetFixNumber( _
                      ValField(rs.Fields, "insc_importe"), 14, 2) ' Importe 2do vto.
      'MsgBox (Len(str))
      str = str & pGetVto(rs)                                     ' Fecha 3er vto.
      'MsgBox (Len(str))
      str = str & pGetFixNumber( _
                      ValField(rs.Fields, "insc_importe"), 14, 2) ' Importe 3er vto.
      'MsgBox (Len(str))
      
      str = str & "0"                                             ' Moneda 0 pesos 1 dolares
      'MsgBox (Len(str))
      str = str & "   "                                           ' Motivo de rechazo
      'MsgBox (Len(str))
      str = str & pGetGALICIATidoDoc(ValField(rs.Fields, _
                                            "insc_tipodocumento")) ' Tipo de documento
      'MsgBox (Len(str))
      str = str & pGetFixNumber(ValField(rs.Fields, _
                                         "insc_documento"), 11, 0) ' Documento
      'MsgBox (Len(str))
      str = str & String(22, " ")                                  ' Nueva identificacion del cliente
      'MsgBox (Len(str))
      str = str & String(26, "0")                                  ' Nueva CBU
      'MsgBox (Len(str))
      str = str & String(14, "0")                                  ' Importe minimo
      'MsgBox (Len(str))
      str = str & String(8, "0")                                   ' Fecha proximo vencimiento
      'MsgBox (Len(str))
      str = str & String(22, " ")                                  ' Identificacion cliente anterior
      'MsgBox (Len(str))
      
      '
      ' TODO: definir con AAARBA si van a usar estos campos
      '
      str = str & String(40, " ")                                  ' Mensaje ATM
      'MsgBox (Len(str))
      str = str & String(10, " ")                                  ' Concepto factura
      'MsgBox (Len(str))
      str = str & String(8, "0")                                   ' Fecha de cobro
      'MsgBox (Len(str))
      str = str & String(14, "0")                                  ' Importe cobrado
      'MsgBox (Len(str))
      str = str & String(8, "0")                                   ' Fecha de acreditamiento
      'MsgBox (Len(str))
      str = str & String(26, " ")                                  ' Libre
      'MsgBox (Len(str))
      
      Print #f, str
    End If
  Next
  
  ' Footers
  '
  str = "9999"                                        ' Tipo de registro
  '
  ' TODO: validar cons sistemas del galicia que este codigo sea el correcto
  '
  str = str & "0370"                                  ' Nro. prestacion
                                                        ' 0370 orden de debito
  str = str & "D"                                     ' Servicio
                                                        ' D    Debito automatico
  str = str & Format(Date, "yyyymmdd")                ' Fecha de generacion
  str = str & "1"                                     ' Identificacion de archivo
                                                      ' debe ser unico por
                                                        ' fecha + prestacion + servicio
  str = str & "EMPRESA"                               ' Origen
                                                        ' EMPRESA o BANCO
  str = str & pGetTotal()                             ' Importe total
  str = str & pGetFixNumber(m_collInsc.Count, 7, 0)   ' Excluidos header y footer
  str = str & String(304, " ")                        ' Blancos
  
  Print #f, str
  
  
  pSaveArchivoItems bgalarch_id
  
  MakeFile = True
  
  GoTo ExitProc
ControlError:
  MngError err, "MakeFile", C_Module, ""
  If err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Close f
End Function

Public Function MakeFileAdhesiones(ByVal path As String, ByVal name As String, _
                                   ByVal Fecha As Date, ByVal us_id As Long) As Boolean
  On Error GoTo ControlError
  
  If Right(path, 1) <> "\" Then path = path & "\"
  
  m_file = name
  m_fullFile = path & name
  
  Dim dbhelper  As Object
  Dim sqlstmt   As String
  Dim insc_id   As Variant
  Dim rs        As Object
  Dim f         As Long
  Dim str       As String
  Dim bgalarch_id   As Long
  
  f = FreeFile
  
  bgalarch_id = pSaveArchivo(Fecha, c_adhesiones, us_id)
  
  Open m_fullFile For Output As #f
  
  Set dbhelper = CreateObject("CSWebDataBase.cDBHelper")
  
  ' Details
  '
  For Each insc_id In m_collInsc
  
    sqlstmt = "sp_web_CBUGaliciaGetInsc " & CLng(insc_id)
    Set rs = dbhelper.RunSQLReturnRS(sqlstmt, Empty)
    
    If Not rs.EOF Then
      
      str = pGetIdentCliente(rs)                                  ' Identificacion del cliente
      str = str & pGetGALICIATidoDoc(ValField(rs.Fields, _
                                            "insc_tipodocumento")) ' Tipo de documento
      str = str & pGetFixNumber(ValField(rs.Fields, _
                                         "insc_documento"), 11, 0) ' Documento
      str = str & pGetFixString(ValField(rs.Fields, _
                                         "insc_apellido") & " " & _
                                ValField(rs.Fields, _
                                         "insc_nombre"), 50)       ' Documento
      
      '
      ' TODO: verificar que este bien formado
      '
      str = str & pGetCBU(rs)                                     ' CBU
      
      Print #f, str
    End If
  Next
  
  pSaveArchivoItems bgalarch_id
  
  MakeFileAdhesiones = True
  
  GoTo ExitProc
ControlError:
  MngError err, "MakeFileAdhesiones", C_Module, ""
  If err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Close f
End Function

Private Function pGetVto(ByRef rs) As String
  Dim rtn As String
  
  If DateDiff("d", ValField(rs.Fields, "insc_fecha"), Date) < 3 Then
    rtn = Format(Date, "yyyymmdd")
  Else
    rtn = Format(ValField(rs.Fields, "insc_fecha"), "yyyymmdd")
  End If
  
  pGetVto = rtn
End Function

Private Function pGetRef(ByRef rs) As String
  Dim rtn As String
  
  rtn = "C2005*" & ValField(rs.Fields, "insc_numero")
  rtn = rtn & String(15 - Len(rtn), " ")
  
  pGetRef = rtn
End Function

Private Function pGetCBU(ByRef rs) As String
  Dim rtn As String
  
  rtn = ValField(rs.Fields, "AABAinsc_nroCBU")
  
  rtn = Mid(rtn, 1, 4) & "0000" & _
        Mid(rtn, 5, 1) & _
        Mid(rtn, 6, 16) & _
        Mid(rtn, 22, 1)
  
  pGetCBU = rtn
End Function

Private Function pGetIdentCliente(ByRef rs)
  Dim rtn As String
  
  rtn = "C2005*" & Format(ValField(rs.Fields, "insc_numero"), "0000")
  rtn = rtn & String(22 - Len(rtn), " ")
  
  pGetIdentCliente = rtn
End Function

Private Function pGetGALICIATidoDoc(ByVal Tipodoc As Integer) As String

  Select Case Tipodoc
    Case c_doc_dni
      pGetGALICIATidoDoc = "0096"
    Case c_doc_le
      pGetGALICIATidoDoc = "0089"
    Case c_doc_lc
      pGetGALICIATidoDoc = "0090"
    Case c_doc_ci
      pGetGALICIATidoDoc = "0000"
    Case c_doc_pasaporte
      pGetGALICIATidoDoc = "0094"
  End Select
End Function

Private Function pGetTidoDoc(ByVal Tipodoc As Integer) As String

  Select Case Tipodoc
    Case c_doc_dni
      pGetTidoDoc = "dni"
    Case c_doc_le
      pGetTidoDoc = "le"
    Case c_doc_lc
      pGetTidoDoc = "lc"
    Case c_doc_ci
      pGetTidoDoc = "ci"
    Case c_doc_pasaporte
      pGetTidoDoc = "pas"
  End Select
End Function

Private Function pGetTotal() As String
  Dim dbhelper  As Object
  Dim sqlstmt   As String
  Dim insc_id   As Variant
  Dim rs        As Object
  Dim Total     As Double
  
  Set dbhelper = CreateObject("CSWebDataBase.cDBHelper")
  
  For Each insc_id In m_collInsc
    sqlstmt = "sp_web_CBUGaliciaGetImporte " & CLng(insc_id)
    Set rs = dbhelper.RunSQLReturnRS(sqlstmt, Empty)
    If Not rs.EOF Then
      Total = Total + ValField(rs.Fields, "insc_importe")
    End If
  Next
  
  pGetTotal = pGetFixNumber(Total, 14, 2)
End Function

Private Function pGetFixString(ByVal value As String, ByVal length As Integer) As String
  Dim rtn As String
  rtn = Mid(value, 1, 50)
  If length - Len(rtn) > 0 Then rtn = rtn & String(length - Len(rtn), " ")
  pGetFixString = rtn
End Function

Private Function pGetFixNumber(ByVal value As Double, ByVal length As Integer, ByVal precision As Integer) As String
  Dim strvalue    As String
  Dim strFormat   As String
  
  strFormat = String(length - precision, "0") & "." & String(precision, "0")
  
  strvalue = Format(value, strFormat)
  strvalue = Replace(strvalue, ".", "")
  strvalue = Replace(strvalue, ".", "")
  
  pGetFixNumber = strvalue
End Function


Private Sub MngError(ByVal err As Object, ByVal functionName As String, ByVal Module As String, ByVal infoAdd As String)
  m_errorMsg = Replace("Funcion: " & Module & "." & functionName & ";;" & err.Description & ";;Info Adicional:" & infoAdd, ";", vbCrLf)
End Sub

Private Sub Class_Initialize()
  Set m_collInsc = New Collection
End Sub

Private Sub Class_Terminate()
  Set m_collInsc = Nothing
  Set m_header = Nothing
  Set m_cobranzas = Nothing
End Sub

Private Function ValField(Fields, Field)
  On Error Resume Next
  err.Clear
  If IsNull(Fields.Item(Field).value) Then
    ValField = ""
  Else
    ValField = Fields.Item(Field).value
  End If
  If err.Number Then
    Dim errDescrip
    Dim errNumber
    errDescrip = err.Description
    errNumber = err.Number
    On Error GoTo 0
    err.Raise errNumber, "", "Error al acceder a un campo de un conjunto de registros. Campo: " & Field & " (" & errDescrip & ")"
  End If
End Function

Private Function CreateObject(ByVal Class As String)
  On Error Resume Next
  Set CreateObject = VBA.CreateObject(Class)
  If err.Number = 0 Then Exit Function
  Dim errNumber, errSource, errDescription
  errNumber = err.Number
  errSource = err.Source
  errDescription = err.Description
  Resume RaiseError
RaiseError:
  On Error GoTo 0
  err.Raise errNumber, errSource, "No se pudo crear un objeto de tipo " & Class & errDescription
End Function

Private Function pSaveArchivo(ByVal Fecha As Date, ByVal tipo As Integer, ByVal us_id As Long) As Long
  Dim dbhelper  As Object
  Dim sqlstmt   As String
  Dim rs        As Object
  
  Set dbhelper = CreateObject("CSWebDataBase.cDBHelper")
  
  sqlstmt = "sp_web_CBUGaliciaInsertFile " & pGetStringSql(m_file) & "," & pGetDateSql(Fecha) & "," & tipo & "," & us_id
  Set rs = dbhelper.RunSQLReturnRS(sqlstmt, Empty)

  pSaveArchivo = rs.Fields(0).value
End Function

Private Sub pSaveArchivoItems(ByVal bgalarch_id As Long)
  Dim dbhelper  As Object
  Dim sqlstmt   As String
  Dim rs        As Object
  Dim insc_id   As Variant
  
  Set dbhelper = CreateObject("CSWebDataBase.cDBHelper")
  
  For Each insc_id In m_collInsc
    sqlstmt = "sp_web_CBUGaliciaInsertFileItem " & bgalarch_id & "," & insc_id
    dbhelper.RunSQL sqlstmt, Empty
  Next
End Sub

Private Function pGetStringSql(ByVal value)
  pGetStringSql = "'" & Replace(value, "'", "''") & "'"
End Function

Private Function pGetDateSql(ByVal value)
  value = Replace(value, "'", "''")
  pGetDateSql = "'" & Format(value, "yyyymmdd") & "'"
End Function

'--------------------------------------------------------------------
Private Function pReadHeader(ByVal f As Long) As String
  Dim strLine As String
  
  Set m_header = New cHeader

  Line Input #f, strLine

  ' Header
  '
  ' Tipo de registro
  '
  m_header.RegistroTipo = Mid(strLine, 1, 4)
  
  ' TODO: validar cons sistemas del galicia que este codigo sea el correcto
  '
  
  ' Nro. prestacion
    ' 0370 orden de debito
  m_header.NroPrestacion = Mid(strLine, 5, 4)
  
  ' Servicio
    ' D    Debito automatico
  m_header.Servicio = Mid(strLine, 9, 1)
    
  ' Fecha de generacion
  m_header.FechaGeneracion = pGetDateFromString(Mid(strLine, 10, 8))
  
  ' Identificacion de archivo
  ' debe ser unico por
    ' fecha + prestacion + servicio
  m_header.IdArchivo = Mid(strLine, 18, 1)
  
  ' Origen
    ' EMPRESA o BANCO
  m_header.Origen = Mid(strLine, 19, 7)
  
  ' Importe total
  m_header.Total = pGetDoubleFromString(Mid(strLine, 26, 14))
  
  ' Excluidos header y footer
  m_header.CantReg = pGetLongFromString(Mid(strLine, 40, 7))
  
End Function

Private Function pGetDateFromString(ByVal strDate As String) As Date
  On Error Resume Next
  Dim rtn As Date
  rtn = DateSerial(Mid(strDate, 1, 4), Mid(strDate, 5, 2), Mid(strDate, 7, 2))
  pGetDateFromString = Date
End Function

Private Function pGetDoubleFromString(ByVal strDouble As String) As Double
  On Error Resume Next
  Dim rtn As Double
  rtn = CLng(Mid(strDouble, 1, 12)) + CInt(Mid(strDouble, 13, 2)) / 100
  pGetDoubleFromString = rtn
End Function

Private Function pGetLongFromString(ByVal strDouble As String) As Long
  On Error Resume Next
  Dim rtn As Long
  rtn = CLng(strDouble)
  pGetLongFromString = rtn
End Function

Private Function pIsRegistroDetalle(ByVal strRecord As String) As Boolean

  If Mid(strRecord, 1, 4) = "0000" Or Mid(strRecord, 1, 4) = "9999" Then Exit Function

  pIsRegistroDetalle = True
End Function

Private Function pReadCobranza(ByVal strRecord As String) As cCobranza
  Dim rtn As cCobranza
  
  Set rtn = New cCobranza
  ' Tipo de registro
    ' 0370 orden de debito
  rtn.RegistroTipo = Mid(strRecord, 1, 4)
                                                                
  ' Identificacion del cliente
  rtn.IdCliente = Mid(strRecord, 5, 22)
  
  ' CBU
  rtn.Cbu = Mid(strRecord, 27, 26)
  
  ' Refrencia univoca
  rtn.IdRegistro = Mid(strRecord, 53, 15)
  
  ' Fecha 1er vto.
  rtn.Fecha1erVto = pGetDateFromString(Mid(strRecord, 68, 8))
  
  ' Importe 1er vto.
  rtn.Importe1erVto = pGetDoubleFromString(Mid(strRecord, 76, 14))
  
  ' Fecha 2do vto.
  rtn.Fecha2doVto = pGetDateFromString(Mid(strRecord, 90, 8))
  
  ' Importe 2do vto.
  rtn.Importe2doVto = pGetDoubleFromString(Mid(strRecord, 98, 14))
  
  ' Fecha 3er vto.
  rtn.Fecha3erVto = pGetDateFromString(Mid(strRecord, 112, 8))
  
  ' Importe 3er vto.
  rtn.Importe3erVto = pGetDoubleFromString(Mid(strRecord, 120, 14))
  
  ' Moneda 0 pesos 1 dolares
  rtn.Moneda = pGetLongFromString(Mid(strRecord, 134, 1))
  
  ' Motivo de rechazo
  rtn.Rechazo = Mid(strRecord, 135, 3)
  
  ' Tipo de documento
  rtn.Tipodoc = pGetLongFromString(Mid(strRecord, 138, 4))
  
  ' Documento
  rtn.Nrodoc = pGetLongFromString(Mid(strRecord, 142, 11))
  
  ' Nueva identificacion del cliente
  rtn.NewIdCliente = Mid(strRecord, 153, 22)
  
  ' Nueva CBU
  rtn.NewCbu = Mid(strRecord, 175, 26)
  
  ' Importe minimo
  rtn.ImporteMinimo = pGetDoubleFromString(Mid(strRecord, 201, 14))
  
  ' Fecha proximo vencimiento
  rtn.FechaProximoVto = pGetDateFromString(Mid(strRecord, 215, 8))
  
  ' Mensaje ATM
  rtn.MensajeATM = Mid(strRecord, 245, 40)
  
  ' Concepto factura
  rtn.Concepto = Mid(strRecord, 285, 10)
  
  ' Fecha de cobro
  rtn.FechaCobro = pGetDateFromString(Mid(strRecord, 295, 8))
  
  ' Importe cobrado
  rtn.ImporteCobrado = pGetDoubleFromString(Mid(strRecord, 303, 14))
  
  ' Fecha de acreditamiento
  rtn.FechaAcreditacion = pGetDateFromString(Mid(strRecord, 317, 8))

  Set pReadCobranza = rtn
End Function

Private Sub pApplyPagos(ByVal insc_id As Long, ByVal us_id As Long)
  Dim cobranza As cCobranza
  Dim dbhelper      As Object
  Dim sqlstmt       As String
  
  Set cobranza = pGetCobranzaForInscId(insc_id)
  
  If cobranza Is Nothing Then err.Raise vbObjectError + 1, C_Module, "No se encontro una cobranza en la coleccion de cobranzas para el insc_id [" & insc_id & "]"
  
  Set dbhelper = CreateObject("CSWebDataBase.cDBHelper")
  sqlstmt = "sp_web_CBUGaliciaApplyPago " & insc_id & "," & pGetStringSql(cobranza.IdRegistro) & "," & pGetDecimalSql(cobranza.ImporteCobrado) & "," & us_id
  
  dbhelper.RunSQL sqlstmt, Empty
End Sub

Private Function pGetCobranzaForInscId(insc_id) As cCobranza
  Dim rtn As cCobranza
  
  For Each rtn In m_cobranzas
    If rtn.Inscripcion.insc_id = insc_id Then Exit For
  Next
  
  Set pGetCobranzaForInscId = rtn
End Function

Private Function pGetDecimalSql(value)
  value = pValEx(value, 0)
  pGetDecimalSql = Replace(Trim(value), ",", ".")
End Function

Private Function pValEx(value, iDefault)
  If Not IsNumeric(value) Then
    value = iDefault
  Else
    value = CDbl(value)
  End If
  pValEx = value
End Function

