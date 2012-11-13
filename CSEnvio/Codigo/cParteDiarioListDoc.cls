VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cParteDiarioListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient

'--------------------------------------------------------------------------------
' cParteDiarioListDoc
' 26-12-03

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cParteDiarioListDoc"

Private Const c_FechaIni = "FechaIni"
Private Const c_FechaFin = "FechaFin"

Private Const c_img_task = 2

Private Const K_FECHAINI                       As Integer = 1
Private Const K_FECHAFIN                       As Integer = 2
Private Const K_CUMPLIDA                       As Integer = 5
Private Const K_US_ID_RESPONSABLE              As Integer = 7
Private Const K_US_ID_ASIGNADOR                As Integer = 8
Private Const K_CONT_ID                        As Integer = 9
Private Const K_LGJ_ID                         As Integer = 10
Private Const K_CLI_ID                         As Integer = 11
Private Const K_TAREST_ID                      As Integer = 12
Private Const K_PRIO_ID                        As Integer = 13
Private Const K_TITULO                         As Integer = 14
Private Const K_DESCRIP                        As Integer = 15

' estructuras
' variables privadas
Private m_FechaIniV                      As String
Private m_FechaFinV                      As String

' ACA VAN LAS m_ GENERADAS POR EL ASISTENTE.
Private m_FechaIni                       As Date
Private m_FechaFin                       As Date
Private m_Cumplida                       As Long
Private m_Us_id_responsable              As String
Private m_Us_id_asignador                As String
Private m_Cont_id                        As String
Private m_lgj_id                         As String
Private m_cli_id                         As String
Private m_Tarest_id                      As String
Private m_Prio_id                        As String

Private m_Responsable                    As String
Private m_Asignador                      As String
Private m_Contacto                       As String
Private m_Legajo                         As String
Private m_Cliente                        As String
Private m_Estado                         As String
Private m_Prioridad                      As String
Private m_Titulo                         As String
Private m_Descrip                        As String


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
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscPtdCumplida)
  c.PropertyType = cspList
  c.Name = LNGGetText(2340, vbNullString)  'Cumplido
  c.Key = K_CUMPLIDA
  c.ListWhoSetItem = csListItemData
  c.ListItemData = m_Cumplida

    Set o = New CSABMInterface2.cABMListItem
    o.ID = 0
    o.Value = LNGGetText(2372, vbNullString)  'Todos
    c.List.Add o, 0

    Set o = New CSABMInterface2.cABMListItem
    o.ID = csECumplida_Pendiente
    o.Value = LNGGetText(2373, vbNullString)  'Pendientes
    c.List.Add o, csECumplida_Pendiente

    Set o = New CSABMInterface2.cABMListItem
    o.ID = csECumplida_Cumplida
    o.Value = LNGGetText(2374, vbNullString)  'Cumplidos
    c.List.Add o, csECumplida_Cumplida
  
    Set o = New CSABMInterface2.cABMListItem
    o.ID = csECumplida_Rechazada
    o.Value = LNGGetText(1477, vbNullString)  'Rechazados
    c.List.Add o, csECumplida_Rechazada
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscusidResponsable)
  c.PropertyType = cspHelp
  c.Table = csUsuario
  c.Name = LNGGetText(1822, vbNullString)  'Responsable
  c.Key = K_US_ID_RESPONSABLE
  
  Value = m_Responsable
  If UCase(Left$(m_Us_id_responsable, 1)) = KEY_NODO Then
    Value = GetNombreRama(csUsuario, Val(Mid(m_Us_id_responsable, 2)), bExists)
    If Not bExists Then m_Us_id_responsable = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_Us_id_responsable)
  c.HelpValueProcess = m_Us_id_responsable
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscusidAsignador)
  c.PropertyType = cspHelp
  c.Table = csUsuario
  c.Name = LNGGetText(1960, vbNullString)  'Generado por
  c.Key = K_US_ID_ASIGNADOR
  Value = m_Asignador
  If UCase(Left$(m_Us_id_asignador, 1)) = KEY_NODO Then
    Value = GetNombreRama(csUsuario, Val(Mid(m_Us_id_asignador, 2)), bExists)
    If Not bExists Then m_Us_id_asignador = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_Us_id_asignador)
  c.HelpValueProcess = m_Us_id_asignador
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscContId)
  c.PropertyType = cspHelp
  c.Table = csContacto
  c.Name = LNGGetText(1035, vbNullString)  'Contacto
  c.Key = K_CONT_ID
  Value = m_Contacto
  If UCase(Left$(m_Cont_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csContacto, Val(Mid(m_Cont_id, 2)), bExists)
    If Not bExists Then m_Cont_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_Cont_id)
  c.HelpValueProcess = m_Cont_id
  
 
  Set c = m_ObjAbm.Properties.Add(Nothing, cscLgjId)
  c.PropertyType = cspHelp
  c.Table = csLegajo
  c.Name = LNGGetText(1575, vbNullString)  'Legajo
  c.Key = K_LGJ_ID
  Value = m_Legajo
  If UCase(Left$(m_lgj_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csLegajo, Val(Mid(m_lgj_id, 2)), bExists)
    If Not bExists Then m_lgj_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_lgj_id)
  c.HelpValueProcess = m_lgj_id
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCliId)
  c.PropertyType = cspHelp
  c.Table = csCliente
  c.Name = LNGGetText(1150, vbNullString)  'Cliente
  c.Key = K_CLI_ID
  Value = m_Cliente
  If UCase(Left$(m_cli_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csCliente, Val(Mid(m_cli_id, 2)), bExists)
    If Not bExists Then m_cli_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_cli_id)
  c.HelpValueProcess = m_cli_id
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTarestId)
  c.PropertyType = cspHelp
  c.Table = csTareaEstado
  c.Name = LNGGetText(1568, vbNullString)  'Estado
  c.Key = K_TAREST_ID
  Value = m_Estado
  If UCase(Left$(m_Tarest_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csTareaEstado, Val(Mid(m_Tarest_id, 2)), bExists)
    If Not bExists Then m_Tarest_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_Tarest_id)
  c.HelpValueProcess = m_Tarest_id
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscPrioId)
  c.PropertyType = cspHelp
  c.Table = csPrioridad
  c.Name = LNGGetText(1825, vbNullString)  'Prioridad
  c.Key = K_PRIO_ID
  Value = m_Prioridad
  If UCase(Left$(m_Prio_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csPrioridad, Val(Mid(m_Prio_id, 2)), bExists)
    If Not bExists Then m_Prio_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_Prio_id)
  c.HelpValueProcess = m_Prio_id
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscPtdTitulo)
  c.PropertyType = cspText
  c.Name = LNGGetText(1864, vbNullString)  'Título
  c.Key = K_TITULO
  c.Value = m_Titulo
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscPtdDescrip)
  c.PropertyType = cspText
  c.Name = C_strDescrip
  c.Key = K_DESCRIP
  c.Value = m_Descrip
  
  If Not m_ObjAbm.Show(Me, m_ObjList) Then Exit Function

  LoadCollection = True

End Function

Private Function Load(ByVal us_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
    
  sqlstmt = "select * from ListaDocumentoParametro " & _
            " where us_id = " & us_id & _
              " and pre_id = " & csPreEnvListParteDiario & _
            " order by " & cscLdpOrden

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If rs.EOF Then
    
    m_FechaIniV = vbNullString
    m_FechaFinV = vbNullString
    m_FechaIni = Date
    m_FechaFin = Date
    m_Cumplida = -2
    m_Us_id_responsable = csNO_ID
    m_Responsable = vbNullString
    m_Us_id_asignador = csNO_ID
    m_Asignador = vbNullString
    m_Cont_id = csNO_ID
    m_Contacto = vbNullString
    m_lgj_id = csNO_ID
    m_Legajo = vbNullString
    m_cli_id = csNO_ID
    m_Cliente = vbNullString
    m_Tarest_id = csNO_ID
    m_Estado = vbNullString
    m_Prio_id = csNO_ID
    m_Prioridad = vbNullString
    m_Titulo = vbNullString
    m_Descrip = vbNullString
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
        Case K_CUMPLIDA
          m_Cumplida = Val(gDB.ValField(rs.fields, cscLdpValor))
        Case K_US_ID_RESPONSABLE
          m_Us_id_responsable = gDB.ValField(rs.fields, cscLdpValor)
        Case K_US_ID_ASIGNADOR
          m_Us_id_asignador = gDB.ValField(rs.fields, cscLdpValor)
        Case K_CONT_ID
          m_Cont_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_LGJ_ID
          m_lgj_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_CLI_ID
          m_cli_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_TAREST_ID
          m_Tarest_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_PRIO_ID
          m_Prio_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_TITULO
          m_Titulo = gDB.ValField(rs.fields, cscLdpValor)
        Case K_DESCRIP
          m_Descrip = gDB.ValField(rs.fields, cscLdpValor)
        
      End Select

      rs.MoveNext
    Wend

    Dim Data As String
    Dim strLoad As String
    
    strLoad = LNGGetText(2370, vbNullString)  'Error al cargar Parte Diario
    
    m_FechaIni = IIf(m_FechaIni <> csNoDate, m_FechaIni, Date)
    m_FechaFin = IIf(m_FechaFin <> csNoDate, m_FechaFin, Date)
    
    If UCase(Left$(m_Us_id_responsable, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTusuario, cscUsId, Val(m_Us_id_responsable), cscUsNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Responsable = Data
    End If
    
    If UCase(Left$(m_Us_id_asignador, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTusuario, cscUsId, Val(m_Us_id_asignador), cscUsNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Asignador = Data
    End If

    If UCase(Left$(m_Cont_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTContacto, cscContId, Val(m_Cont_id), cscContNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Contacto = Data
    End If

    If UCase(Left$(m_lgj_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTLegajo, cscLgjId, Val(m_lgj_id), cscLgjCodigo, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Legajo = Data
    End If

    If UCase(Left$(m_cli_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTCliente, cscCliId, Val(m_cli_id), cscCliNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Cliente = Data
    End If

    If UCase(Left$(m_Tarest_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTTareaEstado, cscTarestId, Val(m_Tarest_id), cscTarestNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Estado = Data
    End If

    If UCase(Left$(m_Prio_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTPrioridad, cscPrioId, Val(m_Prio_id), cscPrioNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Prioridad = Data
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

    Case K_CUMPLIDA
      m_Cumplida = m_ObjAbm.Properties(cscPtdCumplida).ListItemData

    Case K_US_ID_RESPONSABLE
      With m_ObjAbm.Properties(cscusidResponsable)
        m_Responsable = .Value
        m_Us_id_responsable = .HelpValueProcess
      End With
    
    Case K_US_ID_ASIGNADOR
      With m_ObjAbm.Properties(cscusidAsignador)
        m_Asignador = .Value
        m_Us_id_asignador = .HelpValueProcess
      End With
    
    Case K_CONT_ID
      With m_ObjAbm.Properties(cscContId)
        m_Contacto = .Value
        m_Cont_id = .HelpValueProcess
      End With
    
    Case K_TAREST_ID
      With m_ObjAbm.Properties(cscTarestId)
        m_Estado = .Value
        m_Tarest_id = .HelpValueProcess
      End With

    Case K_LGJ_ID
      With m_ObjAbm.Properties(cscLgjId)
        m_Legajo = .Value
        m_lgj_id = .HelpValueProcess
      End With

    Case K_CLI_ID
      With m_ObjAbm.Properties(cscCliId)
        m_Cliente = .Value
        m_cli_id = .HelpValueProcess
      End With
    
    Case K_PRIO_ID
      With m_ObjAbm.Properties(cscPrioId)
        m_Prioridad = .Value
        m_Prio_id = .HelpValueProcess
      End With

    Case K_TITULO
      m_Titulo = m_ObjAbm.Properties(cscPtdTitulo).Value
  
    Case K_DESCRIP
      m_Descrip = m_ObjAbm.Properties(cscPtdDescrip).Value
      
  End Select

  cIABMListDocClient_PropertyChange = True
End Function
  
Private Function cIABMListDocClient_Refresh() As String
  Dim sqlstmt As String

  sqlstmt = "sp_lsdoc_ParteDiarios "
 
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
  
  sqlstmt = sqlstmt & m_Cumplida & ","
  
  sqlstmt = sqlstmt & gDB.sqlString(m_Us_id_responsable) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Us_id_asignador) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Cont_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_lgj_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_cli_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Tarest_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Prio_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Titulo) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Descrip)
  
  cIABMListDocClient_Refresh = sqlstmt
End Function

Private Function cIABMListDocClient_Save() As Boolean

  Dim strError As String
  
  strError = LNGGetText(2371, vbNullString)
            'Error al grabar los párametros de navegación de Parte Diario

  Dim register As cRegister
  Dim fields   As cFields
  Set register = New cRegister

  Dim sqlstmt As String
  
  sqlstmt = "delete ListaDocumentoParametro " & _
            " where pre_id = " & csPreEnvListParteDiario & _
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

        Case K_CUMPLIDA
          fields.Add2 cscLdpValor, .ListItemData, csText
          fields.Add2 cscLdpOrden, 50, csInteger
          fields.Add2 cscLdpId, K_CUMPLIDA, csInteger
        
        Case K_US_ID_RESPONSABLE
          fields.Add2 cscLdpValor, .HelpValueProcess, csText
          fields.Add2 cscLdpOrden, 70, csInteger
          fields.Add2 cscLdpId, K_US_ID_RESPONSABLE, csInteger
          
        Case K_US_ID_ASIGNADOR
          fields.Add2 cscLdpValor, .HelpValueProcess, csText
          fields.Add2 cscLdpOrden, 80, csInteger
          fields.Add2 cscLdpId, K_US_ID_ASIGNADOR, csInteger
          
        Case K_CONT_ID
          fields.Add2 cscLdpValor, .HelpValueProcess, csText
          fields.Add2 cscLdpOrden, 90, csInteger
          fields.Add2 cscLdpId, K_CONT_ID, csInteger
          
        Case K_LGJ_ID
          fields.Add2 cscLdpValor, .HelpValueProcess, csText
          fields.Add2 cscLdpOrden, 100, csInteger
          fields.Add2 cscLdpId, K_LGJ_ID, csInteger
          
        Case K_CLI_ID
          fields.Add2 cscLdpValor, .HelpValueProcess, csText
          fields.Add2 cscLdpOrden, 110, csInteger
          fields.Add2 cscLdpId, K_CLI_ID, csInteger
          
        Case K_TAREST_ID
          fields.Add2 cscLdpValor, .HelpValueProcess, csText
          fields.Add2 cscLdpOrden, 120, csInteger
          fields.Add2 cscLdpId, K_TAREST_ID, csInteger
          
        Case K_PRIO_ID
          fields.Add2 cscLdpValor, .HelpValueProcess, csText
          fields.Add2 cscLdpOrden, 130, csInteger
          fields.Add2 cscLdpId, K_PRIO_ID, csInteger
          
        Case K_TITULO
          fields.Add2 cscLdpValor, .Value, csText
          fields.Add2 cscLdpOrden, 140, csInteger
          fields.Add2 cscLdpId, K_TITULO, csInteger
          
        Case K_DESCRIP
          fields.Add2 cscLdpValor, .Value, csText
          fields.Add2 cscLdpOrden, 150, csInteger
          fields.Add2 cscLdpId, K_DESCRIP, csInteger
      
      End Select
      
      fields.Add2 cscUsId, m_Us_id, csId
      fields.Add2 cscPreID, csPreEnvListParteDiario, csId

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
  cIABMListDocClient_Title = LNGGetText(2348, vbNullString) 'Partes Diarios
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
    .StartRowText = 4
    
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
