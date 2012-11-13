VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cEmailListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient

'--------------------------------------------------------------------------------
' cEmailListDoc
' 22-11-2009
'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cEmailListDoc"

Private Const c_FechaIni = "FechaIni"
Private Const c_FechaFin = "FechaFin"

Private Const c_img_task = 1

' ACA VAN LAS K GENERADAS POR EL ASISTENTE.
Private Const K_FECHAINI                       As Integer = 1
Private Const K_FECHAFIN                       As Integer = 2
Private Const K_CLI_ID                         As Integer = 4
Private Const K_EST_ID                         As Integer = 5
Private Const K_CMI_ID                         As Integer = 6
Private Const K_CMIA_ID                        As Integer = 7
Private Const K_CMIEA_ID                         As Integer = 8
' estructuras
' variables privadas
Private m_FechaIni                       As Date
Private m_FechaFin                       As Date
Private m_cli_id                         As String
Private m_cliente                        As String
Private m_est_id                         As String
Private m_Estado                         As String
Private m_cmi_id                         As String
Private m_Comunidad                      As String
Private m_cmia_id                        As String
Private m_Aplicacion                     As String
Private m_cmiea_id                       As String
Private m_Account                        As String

Private m_FechaIniV                      As String
Private m_FechaFinV                      As String

' ACA VAN LAS m_ GENERADAS POR EL ASISTENTE.

'OJO HASTA ACA

Private m_ObjAbm            As cIABMGenericListDoc
Private m_ObjList           As Object
Private m_Us_id             As Long
Private m_Properties        As cABMDocProperties

Private m_Title             As String

Private m_MenuLoaded        As Boolean

Private m_MenuShowMensajes  As Long
Private m_MenuShowInfoCli   As Long
Private m_MenuAddMensaje    As Long

' Properties publicas
' Properties privadas
' funciones publicas
Public Function ProcessMenu(ByVal Index As Long)
  On Error GoTo ControlError

  Select Case Index
    Case m_MenuShowInfoCli
      HelpShowInfo csCliente, pGetCliId()
    
    Case m_MenuShowMensajes
      pShowMensajes
      
    Case m_MenuAddMensaje
      pAddMensaje
      
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "ProcessMenu", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' Implementacion de cIABMClient

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  Dim o As cIABMListItem
  Dim Value As String
  Dim bExists As Boolean

  With m_ObjAbm.Properties
    .Clear

    Set c = .Add(Nothing, c_FechaIni)
    c.PropertyType = cspDate
    c.Name = LNGGetText(1203, vbNullString)   'Fecha desde
    c.Key = K_FECHAINI
    If m_FechaIniV <> vbNullString Then
      c.Value = m_FechaIniV
    Else
      c.Value = m_FechaIni
    End If
  
    Set c = .Add(Nothing, c_FechaFin)
    c.PropertyType = cspDate
    c.Name = LNGGetText(1204, vbNullString)   'Fecha hasta
    c.Key = K_FECHAFIN
    If m_FechaFinV <> vbNullString Then
      c.Value = m_FechaFinV
    Else
      c.Value = m_FechaFin
    End If
    
    Set c = .Add(Nothing, cscCliId)
    c.PropertyType = cspHelp
    c.Table = csCliente
    c.Name = LNGGetText(1150, vbNullString)   'Cliente
    c.Key = K_CLI_ID
    Value = m_cliente
    If UCase(Left$(m_cli_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csCliente, Val(Mid(m_cli_id, 2)), bExists)
      If Not bExists Then m_cli_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_cli_id)
    c.HelpValueProcess = m_cli_id
    
    Set c = .Add(Nothing, cscEstId)
    c.PropertyType = cspHelp
    c.Table = csEstado
    c.Name = LNGGetText(1568, vbNullString)   'Estado
    c.Key = K_EST_ID
    Value = m_Estado
    If UCase(Left$(m_est_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csEstado, Val(Mid(m_est_id, 2)), bExists)
      If Not bExists Then m_est_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_est_id)
    c.HelpValueProcess = m_est_id
    
    Set c = .Add(Nothing, cscCmiId)
    c.PropertyType = cspHelp
    c.Table = csComunidadInternet
    c.Name = LNGGetText(5017, vbNullString)   'Comunidad
    c.Key = K_CMI_ID
    Value = m_Comunidad
    If UCase(Left$(m_cmi_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csComunidadInternet, Val(Mid(m_cmi_id, 2)), bExists)
      If Not bExists Then m_cmi_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_cmi_id)
    c.HelpValueProcess = m_cmi_id
    
    Set c = .Add(Nothing, cscCmiaId)
    c.PropertyType = cspHelp
    c.Table = csComunidadInternetAplicacion
    c.Name = LNGGetText(5018, vbNullString)   'Aplicacion
    c.Key = K_CMIA_ID
    Value = m_Aplicacion
    If UCase(Left$(m_cmia_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csComunidadInternetAplicacion, Val(Mid(m_cmia_id, 2)), bExists)
      If Not bExists Then m_cmia_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_cmia_id)
    c.HelpValueProcess = m_cmia_id
    
    Set c = .Add(Nothing, cscCmieaId)
    c.PropertyType = cspHelp
    c.Table = csComunidadInternetEmailAccount
    c.Name = LNGGetText(5019, vbNullString)   'Cuenta de Correo
    c.Key = K_CMIEA_ID
    Value = m_Account
    If UCase(Left$(m_cmiea_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csComunidadInternetEmailAccount, Val(Mid(m_cmiea_id, 2)), bExists)
      If Not bExists Then m_cmiea_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_cmiea_id)
    c.HelpValueProcess = m_cmiea_id
    
  End With
  
  pCreateMenu
  If Not m_ObjAbm.Show(Me, m_ObjList) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal us_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select * from ListaDocumentoParametro " & _
            " where us_id = " & us_id & _
            " and pre_id =" & csPreCVXIListEmail & _
            " and (emp_id is null or emp_id = " & EmpId & ")" & _
            " order by " & cscLdpOrden

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If rs.EOF Then
    
    m_FechaIni = Date
    m_FechaFin = Date
    m_cli_id = csNO_ID
    m_cliente = vbNullString
    m_est_id = csNO_ID
    m_Estado = vbNullString
    m_cmi_id = csNO_ID
    m_Comunidad = vbNullString
    m_cmia_id = csNO_ID
    m_Aplicacion = vbNullString
    m_cmiea_id = csNO_ID
    m_Account = vbNullString
    
  Else

    rs.MoveLast
    rs.MoveFirst

    Dim i As Integer
    While Not rs.EOF

      Select Case gDB.ValField(rs.fields, cscLdpId)
        
        Case K_FECHAINI
          m_FechaIniV = gDB.ValField(rs.fields, cscLdpValor)
          m_FechaIni = IIf(IsDate(gDB.ValField(rs.fields, cscLdpValor)), gDB.ValField(rs.fields, cscLdpValor), Date)
        
        Case K_FECHAFIN
          m_FechaFinV = gDB.ValField(rs.fields, cscLdpValor)
          m_FechaFin = IIf(IsDate(gDB.ValField(rs.fields, cscLdpValor)), gDB.ValField(rs.fields, cscLdpValor), Date)
        
        Case K_CLI_ID
          m_cli_id = gDB.ValField(rs.fields, cscLdpValor)
        
        Case K_EST_ID
          m_est_id = gDB.ValField(rs.fields, cscLdpValor)
        
        Case K_CMI_ID
          m_cmi_id = gDB.ValField(rs.fields, cscLdpValor)
        
        Case K_CMIA_ID
          m_cmia_id = gDB.ValField(rs.fields, cscLdpValor)
        
        Case K_CMIEA_ID
          m_cmiea_id = gDB.ValField(rs.fields, cscLdpValor)
        
      End Select

      rs.MoveNext
    Wend

    Dim Data As String
    Dim strLoad As String
    
    strLoad = LNGGetText(5020, vbNullString)
              'Error al carga los párametros de navegación de e-mails
    
    m_FechaIni = IIf(m_FechaIni <> csNoDate, m_FechaIni, Date)
    m_FechaFin = IIf(m_FechaFin <> csNoDate, m_FechaFin, Date)


' OJO: EL ASISTENTE ESTO LO HACE MAL, YA QUE EL CODIGO QUE GENERA NO SOPORTA ARBOLES
'      USEN ESTE CODIGO COMO EJ. OJO!!! CAMBIEN LOS NOMBRES DE LAS TABLAS Y LOS CAMPOS NOMBRES DE DICHAS TABLAS.
    If UCase(Left$(m_cli_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTCliente, cscCliId, Val(m_cli_id), cscCliNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_cliente = Data
    End If
    If UCase(Left$(m_est_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTEstado, cscEstId, Val(m_est_id), cscEstNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Estado = Data
    End If
    If UCase(Left$(m_cmi_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTComunidadInternet, cscCmiId, Val(m_cmi_id), cscCmiNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Comunidad = Data
    End If
    If UCase(Left$(m_cmia_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTComunidadInternetAplicacion, cscCmiaId, Val(m_cmia_id), cscCmiaNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Aplicacion = Data
    End If
    If UCase(Left$(m_cmiea_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTComunidadInternetEmailAccount, cscCmieaId, Val(m_cmiea_id), cscCmieaNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Account = Data
    End If

  End If

  Load = True
End Function

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


' OJO: NUEVAMENTE LA EXISTENCIA DE FECHAS VIRTUALES HACE QUE EL CODIGO GENERADO POR EL ASISTENTE ESTE MAL
'      CORRIJALO UTILIZANDO ESTE CODIGO COMO EJEMPLO.
Private Function cIABMListDocClient_PropertyChange(ByVal Key As Integer) As Boolean
  Dim iProp     As cIABMProperty
  
  With m_ObjAbm.Properties
    Select Case Key
  
      Case K_FECHAINI
        
        Set iProp = .Item(c_FechaIni)
    
        If iProp.HelpValueProcess <> vbNullString Then
          m_FechaIniV = iProp.HelpValueProcess
          m_FechaIni = VDGetDateByName(m_FechaIniV)
        ElseIf IsDate(iProp.Value) Then
          m_FechaIniV = vbNullString
          m_FechaIni = iProp.Value
        Else
          m_FechaIniV = vbNullString
          iProp.Value = m_FechaIni
        End If
    
      Case K_FECHAFIN
        
        Set iProp = .Item(c_FechaFin)
        
        If iProp.HelpValueProcess <> vbNullString Then
          m_FechaFinV = iProp.HelpValueProcess
          m_FechaFin = VDGetDateByName(m_FechaFinV)
        ElseIf IsDate(iProp.Value) Then
          m_FechaFinV = vbNullString
          m_FechaFin = iProp.Value
        Else
          m_FechaFinV = vbNullString
          iProp.Value = m_FechaFin
        End If
      
      Case K_EST_ID
        With .Item(cscEstId)
          m_Estado = .Value
          m_est_id = .HelpValueProcess
        End With
    
      Case K_CLI_ID
        With .Item(cscCliId)
          m_cliente = .Value
          m_cli_id = .HelpValueProcess
        End With
      
      Case K_CMI_ID
        With .Item(cscCmiId)
          m_Comunidad = .Value
          m_cmi_id = .HelpValueProcess
        End With
        
      Case K_CMIA_ID
        With .Item(cscCmiaId)
          m_Aplicacion = .Value
          m_cmia_id = .HelpValueProcess
        End With
        
      Case K_CMIEA_ID
        With .Item(cscCmieaId)
          m_Account = .Value
          m_cmiea_id = .HelpValueProcess
        End With
          
    End Select
  End With
  
  cIABMListDocClient_PropertyChange = True
End Function

Private Function cIABMListDocClient_Refresh() As String
  Dim sqlstmt As String

  sqlstmt = "sp_lsdoc_Emails "

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
  
  sqlstmt = sqlstmt & gDB.sqlString(m_cli_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_est_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_cmi_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_cmia_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_cmiea_id)

  cIABMListDocClient_Refresh = sqlstmt
End Function

Private Function cIABMListDocClient_Save() As Boolean

  Dim strError As String
            
  strError = LNGGetText(5021, vbNullString)
              'Error al grabar los párametros de navegación de e-mails

  Dim register As cRegister
  Set register = New cRegister

  Dim sqlstmt As String
  
  sqlstmt = "delete ListaDocumentoParametro" & _
            " where pre_id = " & csPreCVXIListEmail & _
              " and us_id = " & m_Us_id & _
              " and (emp_id is null or emp_id = " & EmpId & ")"
  
  If Not gDB.Execute(sqlstmt, "cIABMClient_Save", C_Module, strError) Then Exit Function

  register.Table = csTListaDocumentoParametro
  register.UtilizaIdentity = True

  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties

    register.fields.Clear

    With IProperty
      Select Case .Key

         Case K_FECHAINI
          If .HelpValueProcess <> vbNullString Then
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          Else
            register.fields.Add2 cscLdpValor, .Value, csText
          End If
          
          register.fields.Add2 cscLdpOrden, 10, csInteger
          register.fields.Add2 cscLdpId, K_FECHAINI, csInteger
          
        Case K_FECHAFIN

          If .HelpValueProcess <> vbNullString Then
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          Else
            register.fields.Add2 cscLdpValor, .Value, csText
          End If

          register.fields.Add2 cscLdpOrden, 20, csInteger
          register.fields.Add2 cscLdpId, K_FECHAFIN, csInteger

        Case K_CLI_ID
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.fields.Add2 cscLdpOrden, 40, csInteger
            register.fields.Add2 cscLdpId, K_CLI_ID, csInteger
        Case K_EST_ID
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.fields.Add2 cscLdpOrden, 50, csInteger
            register.fields.Add2 cscLdpId, K_EST_ID, csInteger
        Case K_CMI_ID
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.fields.Add2 cscLdpOrden, 60, csInteger
            register.fields.Add2 cscLdpId, K_CMI_ID, csInteger
        Case K_CMIA_ID
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.fields.Add2 cscLdpOrden, 70, csInteger
            register.fields.Add2 cscLdpId, K_CMIA_ID, csInteger
        Case K_CMIEA_ID
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.fields.Add2 cscLdpOrden, 80, csInteger
            register.fields.Add2 cscLdpId, K_CMIEA_ID, csInteger
            
      End Select
      
      ' empid
      register.fields.Add2 cscEmpId, EmpId, csId
      
      register.fields.Add2 cscUsId, m_Us_id, csId
      register.fields.Add2 cscPreID, csPreCVXIListEmail, csId

      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False
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
  cIABMListDocClient_Title = m_Title
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

Private Sub pCreateMenu()
  On Error Resume Next
  
  If m_MenuLoaded Then Exit Sub
  
  m_MenuLoaded = True
  
  With m_ObjList
    Set .ObjClientMenu = Me
    .ClearMenu
    m_MenuShowInfoCli = .AddMenu(LNGGetText(1614, vbNullString))  'Ver Info del Cliente
    m_MenuAddMensaje = .AddMenu(LNGGetText(1615, vbNullString))   'Agregar Nota
    m_MenuShowMensajes = .AddMenu(LNGGetText(1616, vbNullString)) 'Ver Notas
  End With
End Sub

Private Sub pShowMensajes()
  Dim sqlstmt As String
  Dim CmieId  As Long
  Dim rs      As ADODB.Recordset
  
  CmieId = m_ObjList.id
  
  sqlstmt = "sp_ParteDiarioGetTitleForDoc " & csComunidadInternetEmail & "," & CmieId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Dim infodoc As String
  Dim DoctId  As Long
  
  DoctId = csComunidadInternetEmail
  infodoc = gDB.ValField(rs.fields, "info_doc")
  
  sqlstmt = "sp_PartesDiarioGetForDoc " & gDB.UserId & "," & EmpId & "," & DoctId & "," & CmieId
  ShowNotes LNGGetText(5022, vbNullString, infodoc), sqlstmt
            'Notas sobre e-mails & infodoc
End Sub

Private Sub pAddMensaje()
  Dim Parte As Object
  Set Parte = CSKernelClient2.CreateObject("CSEnvio2.cParteDiario")
  
  Parte.AddParteToDoc csComunidadInternetEmail, m_ObjList.id, False
End Sub

Private Function pGetCliId() As Long
  On Error Resume Next
  
  Dim CmieId  As Long
  Dim CliId As Long
  
  CmieId = m_ObjList.id
  gDB.GetData csTComunidadInternetMail, cscCmieId, CmieId, cscCliId, CliId
  
  pGetCliId = CliId
End Function

Private Function pGetCmieIds() As Long()
  pGetCmieIds = m_ObjList.SelectedItems
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
 
  m_Title = LNGGetText(5023, vbNullString)  'E-Mails
 
  Set m_Properties = New cABMDocProperties
  With m_Properties
    'Set .ImageList = fResource.iList
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

