VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPreguntaListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient

'--------------------------------------------------------------------------------
' cPreguntaListDoc
' 18-11-2010

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cPreguntaListDoc"

Private Const c_FechaIni = "FechaIni"
Private Const c_FechaFin = "FechaFin"

Private Const c_observadas = "observadas"

Private Const c_img_task = 2

Private Const K_FECHAINI                       As Integer = 1
Private Const K_FECHAFIN                       As Integer = 2
Private Const K_RESPONDIO                      As Integer = 3
Private Const K_CLI_ID                         As Integer = 4
Private Const K_PREGUNTA                       As Integer = 5
Private Const K_NICK                           As Integer = 6
Private Const K_OBSERVADAS                     As Integer = 7

' estructuras
' variables privadas
Private m_FechaIniV                      As String
Private m_FechaFinV                      As String

' ACA VAN LAS m_ GENERADAS POR EL ASISTENTE.
Private m_FechaIni                       As Date
Private m_FechaFin                       As Date
Private m_us_id_respondio                As String
Private m_cli_id                         As String

Private m_modifico                       As String
Private m_Contacto                       As String
Private m_cliente                        As String
Private m_pregunta                       As String
Private m_nick                           As String
Private m_observadas                     As Boolean

Private m_ObjAbm            As cIABMGenericListDoc
Private m_ObjList           As Object
Private m_Us_id             As Long
Private m_Properties        As cABMDocProperties

' Properties publicas
' Properties privadas
' funciones publicas


' Implementacion de cIABMClient

' funciones privadas

Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  Dim o As cIABMListItem
  Dim Value As String
  Dim bExists As Boolean

  m_ObjAbm.Properties.Clear

  Set c = m_ObjAbm.Properties.Add(Nothing, c_FechaIni)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1203, vbNullString)  'Fecha desde
  c.Key = K_FECHAINI
  If LenB(m_FechaIniV) Then
    c.Value = m_FechaIniV
  Else
    c.Value = m_FechaIni
  End If


  Set c = m_ObjAbm.Properties.Add(Nothing, c_FechaFin)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1204, vbNullString)  'Fecha hasta
  c.Key = K_FECHAFIN
  If LenB(m_FechaFinV) Then
    c.Value = m_FechaFinV
  Else
    c.Value = m_FechaFin
  End If
   
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscModifico)
  c.PropertyType = cspHelp
  c.Table = csUsuario
  c.Name = LNGGetText(5098, vbNullString)  'Respondido por
  c.Key = K_RESPONDIO
  Value = m_modifico
  If UCase(Left$(m_us_id_respondio, 1)) = KEY_NODO Then
    Value = GetNombreRama(csUsuario, Val(Mid(m_us_id_respondio, 2)), bExists)
    If Not bExists Then m_us_id_respondio = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_us_id_respondio)
  c.HelpValueProcess = m_us_id_respondio
   
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCliId)
  c.PropertyType = cspHelp
  c.Table = csCliente
  c.Name = LNGGetText(1150, vbNullString)  'Cliente
  c.Key = K_CLI_ID
  Value = m_cliente
  If UCase(Left$(m_cli_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csCliente, Val(Mid(m_cli_id, 2)), bExists)
    If Not bExists Then m_cli_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_cli_id)
  c.HelpValueProcess = m_cli_id

  Set c = m_ObjAbm.Properties.Add(Nothing, cscCmipNick)
  c.PropertyType = cspText
  c.Name = LNGGetText(5099, vbNullString)  'Nick
  c.Key = K_NICK
  c.Value = m_nick

  Set c = m_ObjAbm.Properties.Add(Nothing, cscCmipPregunta)
  c.PropertyType = cspText
  c.Name = LNGGetText(5093, vbNullString)  'Pregunta
  c.Key = K_PREGUNTA
  c.Value = m_pregunta

  Set c = m_ObjAbm.Properties.Add(Nothing, c_observadas)
  c.PropertyType = cspCheck
  c.Name = LNGGetText(5102, vbNullString)  'Observadas
  c.Key = K_OBSERVADAS
  c.Value = CInt(m_observadas)

  
  If Not m_ObjAbm.Show(Me, m_ObjList) Then Exit Function

  LoadCollection = True

End Function

Private Function Load(ByVal us_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
    
  sqlstmt = "select * from ListaDocumentoParametro " & _
            " where us_id = " & us_id & _
              " and pre_id = " & csPreCVXIListPregunta & _
            " order by " & cscLdpOrden

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If rs.EOF Then
    
    m_FechaIniV = vbNullString
    m_FechaFinV = vbNullString
    m_FechaIni = Date
    m_FechaFin = Date
    m_us_id_respondio = csNO_ID
    m_modifico = vbNullString
    m_cli_id = csNO_ID
    m_cliente = vbNullString
    m_pregunta = vbNullString
    m_nick = vbNullString
    m_observadas = False
  
  Else

    rs.MoveLast
    rs.MoveFirst

    Dim i As Integer
    While Not rs.EOF

      Select Case gDB.ValField(rs.fields, cscLdpId)

' OJO: EL ASISTENTE GENERA MAL LAS FECHAS Y LOS TEXTOS (A LOS TEXTOS LES PONE VAL)
'      CORREGIR ESTOS ERRORES Y EL COD. DE ABAJO LES SIRVE DE EJ.
        Case K_FECHAINI
          m_FechaIniV = gDB.ValField(rs.fields, cscLdpValor)
          m_FechaIni = IIf(IsDate(gDB.ValField(rs.fields, cscLdpValor)), gDB.ValField(rs.fields, cscLdpValor), Date)
        Case K_FECHAFIN
          m_FechaFinV = gDB.ValField(rs.fields, cscLdpValor)
          m_FechaFin = IIf(IsDate(gDB.ValField(rs.fields, cscLdpValor)), gDB.ValField(rs.fields, cscLdpValor), Date)
        Case K_RESPONDIO
          m_us_id_respondio = gDB.ValField(rs.fields, cscLdpValor)
        Case K_CLI_ID
          m_cli_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_PREGUNTA
          m_pregunta = gDB.ValField(rs.fields, cscLdpValor)
        Case K_NICK
          m_nick = gDB.ValField(rs.fields, cscLdpValor)
        Case K_OBSERVADAS
          m_observadas = gDB.ValField(rs.fields, cscLdpValor)
        
      End Select

      rs.MoveNext
    Wend

    Dim Data As String
    Dim strLoad As String
    
    strLoad = LNGGetText(5100, vbNullString)  'Error al cargar preguntas
    
    m_FechaIni = IIf(m_FechaIni <> csNoDate, m_FechaIni, Date)
    m_FechaFin = IIf(m_FechaFin <> csNoDate, m_FechaFin, Date)
        
    If UCase(Left$(m_us_id_respondio, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTusuario, cscUsId, Val(m_us_id_respondio), cscUsNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_modifico = Data
    End If

    If UCase(Left$(m_cli_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTCliente, cscCliId, Val(m_cli_id), cscCliNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_cliente = Data
    End If

  End If

  Load = True
End Function
' construccion - destruccion

Private Property Get cIABMListDocClient_Aplication() As String
  cIABMListDocClient_Aplication = gAppName
End Property

Private Sub cIABMListDocClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMListDocClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMListDocClient_Load()

End Sub

Private Property Get cIABMListDocClient_Properties() As Object
  Set cIABMListDocClient_Properties = m_Properties
End Property

Private Function cIABMListDocClient_PropertyChange(ByVal Key As Integer) As Boolean
  Dim iProp     As cIABMProperty
    Select Case Key

    Case K_FECHAINI
      
      Set iProp = m_ObjAbm.Properties(c_FechaIni)
  
      If LenB(iProp.HelpValueProcess) Then
        m_FechaIniV = iProp.HelpValueProcess
        m_FechaIni = VDGetDateByName(m_FechaIniV)
      ElseIf IsDate(iProp.Value) Then
        m_FechaIniV = ""
        m_FechaIni = iProp.Value
      Else
        m_FechaIniV = ""
        iProp.Value = m_FechaIni
      End If
  
    Case K_FECHAFIN
      
      Set iProp = m_ObjAbm.Properties(c_FechaFin)
      
      If LenB(iProp.HelpValueProcess) Then
        m_FechaFinV = iProp.HelpValueProcess
        m_FechaFin = VDGetDateByName(m_FechaFinV)
      ElseIf IsDate(iProp.Value) Then
        m_FechaFinV = ""
        m_FechaFin = iProp.Value
      Else
        m_FechaFinV = ""
        iProp.Value = m_FechaFin
      End If
    
    Case K_RESPONDIO
      With m_ObjAbm.Properties(cscModifico)
        m_modifico = .Value
        m_us_id_respondio = .HelpValueProcess
      End With
    
    Case K_CLI_ID
      With m_ObjAbm.Properties(cscCliId)
        m_cliente = .Value
        m_cli_id = .HelpValueProcess
      End With
    
    Case K_NICK
      m_nick = m_ObjAbm.Properties(cscCmipNick).Value
    
    Case K_PREGUNTA
      m_pregunta = m_ObjAbm.Properties(cscCmipPregunta).Value
        
    Case K_OBSERVADAS
      m_observadas = m_ObjAbm.Properties(c_observadas).Value
        
  End Select

  cIABMListDocClient_PropertyChange = True
End Function
  
Private Function cIABMListDocClient_Refresh() As String
  Dim sqlstmt As String

  sqlstmt = "sp_lsdoc_Preguntas "
 
  sqlstmt = sqlstmt & gDB.UserId & ","
  
  
  If Not DateNames(m_FechaIniV) Is Nothing Then
    sqlstmt = sqlstmt & gDB.sqlDate(VDGetDateByName(m_FechaIniV)) & ","
  Else
    sqlstmt = sqlstmt & gDB.sqlDate(m_FechaIni) & ","
  End If
  
  If Not DateNames(m_FechaFinV) Is Nothing Then
    sqlstmt = sqlstmt & gDB.sqlDate(VDGetDateByName(m_FechaFinV)) & ","
  Else
    sqlstmt = sqlstmt & gDB.sqlDate(m_FechaFin) & ","
  End If
  
  sqlstmt = sqlstmt & gDB.sqlString(m_us_id_respondio) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_cli_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_nick) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_pregunta) & ","
  sqlstmt = sqlstmt & IIf(m_observadas, 1, 0)
  
  cIABMListDocClient_Refresh = sqlstmt
End Function

Private Function cIABMListDocClient_Save() As Boolean

  Dim strError As String
  
  strError = LNGGetText(5101, vbNullString)
            'Error al grabar los párametros de navegación de preguntas

  Dim register As cRegister
  Dim fields   As cFields
  Set register = New cRegister

  Dim sqlstmt As String
  
  sqlstmt = "delete ListaDocumentoParametro " & _
            " where pre_id = " & csPreCVXIListPregunta & _
              " and us_id = " & m_Us_id

  If Not gDB.Execute(sqlstmt, "cIABMClient_Save", C_Module, strError) Then Exit Function

  With register
    Set fields = .fields
    .Table = csTListaDocumentoParametro
    .UtilizaIdentity = True
  End With

  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties

    fields.Clear

    With IProperty
      Select Case .Key

         Case K_FECHAINI
          
          If LenB(.HelpValueProcess) Then
            fields.Add2 cscLdpValor, .HelpValueProcess, csText
          Else
            fields.Add2 cscLdpValor, .Value, csText
          End If
          
          fields.Add2 cscLdpOrden, 10, csInteger
          fields.Add2 cscLdpId, K_FECHAINI, csInteger
          
        Case K_FECHAFIN

          If LenB(.HelpValueProcess) Then
            fields.Add2 cscLdpValor, .HelpValueProcess, csText
          Else
            fields.Add2 cscLdpValor, .Value, csText
          End If

          fields.Add2 cscLdpOrden, 20, csInteger
          fields.Add2 cscLdpId, K_FECHAFIN, csInteger

        Case K_RESPONDIO
          fields.Add2 cscLdpValor, .HelpValueProcess, csText
          fields.Add2 cscLdpOrden, 80, csInteger
          fields.Add2 cscLdpId, K_RESPONDIO, csInteger
          
        Case K_CLI_ID
          fields.Add2 cscLdpValor, .HelpValueProcess, csText
          fields.Add2 cscLdpOrden, 110, csInteger
          fields.Add2 cscLdpId, K_CLI_ID, csInteger
          
        Case K_NICK
          fields.Add2 cscLdpValor, .Value, csText
          fields.Add2 cscLdpOrden, 130, csInteger
          fields.Add2 cscLdpId, K_NICK, csInteger
        
        Case K_PREGUNTA
          fields.Add2 cscLdpValor, .Value, csText
          fields.Add2 cscLdpOrden, 140, csInteger
          fields.Add2 cscLdpId, K_PREGUNTA, csInteger
                
        Case K_OBSERVADAS
          fields.Add2 cscLdpValor, .Value, csText
          fields.Add2 cscLdpOrden, 150, csInteger
          fields.Add2 cscLdpId, K_OBSERVADAS, csInteger
                
      End Select
      
      fields.Add2 cscUsId, m_Us_id, csId
      fields.Add2 cscPreID, csPreCVXIListPregunta, csId

      fields.HaveLastUpdate = False
      fields.HaveWhoModify = False
      If Not gDB.Save(register, , "cIABMClient_Save", C_Module, strError) Then Exit Function
    End With
  Next
  
  If Not Load(m_Us_id) Then Exit Function

  cIABMListDocClient_Save = True
End Function

Private Function cIABMListDocClient_Terminate() As Boolean
  cIABMListDocClient_Terminate = True
End Function

Private Property Get cIABMListDocClient_Title() As String
  cIABMListDocClient_Title = LNGGetText(5090, vbNullString) 'Preguntas
End Property

Private Function cIABMListDocClient_Validate() As Boolean
  cIABMListDocClient_Validate = True
End Function

Private Function cIEditGenericListDoc_GridAdd(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_GridEdit(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_GridRemove(ByVal KeyProperty As Integer) As Boolean

End Function

Private Property Set cIEditGenericListDoc_ObjABM(rhs As CSInterfacesABM.cIABMGenericListDoc)
  Set m_ObjAbm = rhs
End Property

Private Property Set cIEditGenericListDoc_ObjList(rhs As Object)
  Set m_ObjList = rhs
End Property

Private Function cIEditGenericListDoc_PropertyChange(ByVal Key As Integer) As Boolean
End Function

Private Function cIEditGenericListDoc_ShowParams(ByVal us_id As Long) As Boolean
  On Error GoTo ControlError
  
  If us_id = csNO_ID Then Exit Function

  m_Us_id = us_id
  
  If Not Load(us_id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  cIEditGenericListDoc_ShowParams = True
  Exit Function
ControlError:
  MngError Err, "cIEditGenericListDoc_ShowParams", C_Module, vbNullString
End Function

Private Function cIEditGenericListDoc_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError
 
  Set m_Properties = New cABMDocProperties
  With m_Properties
    'Set .ImageList = fIcons.ilList
    .HaveDetail = True
    .StartRowText = 2
    
    With .Columns.Add(Nothing, "TypeTask")
      .Name = "TypeTask"
      .Caption = " "
      With .Icons.Add(Nothing)
      .FormulaType = csCondTNone
      .IconIndex = c_img_task
      End With
      .Width = 500
      .SortType = csSrtTIcon
    End With
    
    With .Columns.Add(Nothing, "Descripción")
      .Name = "Descripción"
      .FontName = "Tahoma"
      .FontSize = 8
      .ForeColor = vbBlue
    End With
  End With
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_ObjAbm = Nothing
  Set m_ObjList = Nothing
  Set m_Properties = Nothing

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


