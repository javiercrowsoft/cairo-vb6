VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cLegajoListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient
'--------------------------------------------------------------------------------
' cLegajoListDoc
' 25-12-03

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cLegajoListDoc"

Private Const c_FechaIni = "FechaIni"
Private Const c_FechaFin = "FechaFin"
Private Const c_img_task = 1

Private Const K_FECHAINI                       As Integer = 1
Private Const K_FECHAFIN                       As Integer = 2
Private Const K_ESTADO                         As Integer = 3
Private Const K_CLIENTE                        As Integer = 4
Private Const K_TITULO                         As Integer = 5
Private Const K_DESCRIP                        As Integer = 6
Private Const K_CODIGO                         As Integer = 7

' pseudo-constantes
Private c_strTitle As String

' estructuras
' variables privadas
Private m_FechaIniV                      As String
Private m_FechaFinV                      As String
Private m_FechaIni                       As Date
Private m_FechaFin                       As Date
Private m_Estado                         As String
Private m_Cliente                        As String
Private m_est_id                         As String
Private m_cli_id                         As String
Private m_Titulo                         As String
Private m_Descrip                        As String
Private m_Codigo                         As String

'OJO HASTA ACA

Private m_ObjAbm            As cIABMGenericListDoc
Private m_ObjList           As Object
Private m_Us_id             As Long
Private m_Properties         As cABMDocProperties

Private m_MenuLoaded        As Boolean
Private m_Title             As String

Private m_MenuShowMensajes  As Long
Private m_MenuAddMensaje    As Long
Private m_MenuShowInfoCli   As Long

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
  c.Name = LNGGetText(1203, vbNullString)   'Fecha desde
  c.Key = K_FECHAINI
  If LenB(m_FechaIniV) Then
    c.Value = m_FechaIniV
  Else
    c.Value = m_FechaIni
  End If
  

  Set c = m_ObjAbm.Properties.Add(Nothing, c_FechaFin)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1204, vbNullString)   'Fecha hasta
  c.Key = K_FECHAFIN
  If LenB(m_FechaFinV) Then
    c.Value = m_FechaFinV
  Else
    c.Value = m_FechaFin
  End If
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscEstId)
  c.PropertyType = cspHelp
  c.Table = csEstado
  c.Name = LNGGetText(1568, vbNullString)   'Estado
  c.Key = K_ESTADO
  Value = m_Estado
  If UCase(Left$(m_est_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csEstado, Val(Mid(m_est_id, 2)), bExists)
    If Not bExists Then m_est_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_est_id)
  c.HelpValueProcess = m_est_id
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscCliId)
  c.PropertyType = cspHelp
  c.Table = csCliente
  c.Name = LNGGetText(1150, vbNullString)   'Cliente
  c.Key = K_CLIENTE
  Value = m_Cliente
  If UCase(Left$(m_cli_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csCliente, Val(Mid(m_cli_id, 2)), bExists)
    If Not bExists Then m_cli_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_cli_id)
  c.HelpValueProcess = m_cli_id
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscLgjTitulo)
  c.PropertyType = cspText
  c.Name = LNGGetText(1864, vbNullString)   'Titulo
  c.Key = K_TITULO
  c.Value = m_Titulo
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscLgjDescrip)
  c.PropertyType = cspText
  c.Name = C_strDescrip
  c.Key = K_DESCRIP
  c.Value = m_Descrip
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscLgjCodigo)
  c.PropertyType = cspText
  c.Name = C_strCodigo
  c.Key = K_CODIGO
  c.Value = m_Codigo
  
  pCreateMenu
  If Not m_ObjAbm.Show(Me, m_ObjList) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal us_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select * from ListaDocumentoParametro " & _
            " where us_id = " & us_id & _
              " and pre_id = " & csPreEnvListLegajo & _
            " order by " & cscLdpOrden

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If rs.EOF Then

    m_FechaIni = Date
    m_FechaFin = Date
    m_FechaIniV = vbNullString
    m_FechaFinV = vbNullString
    m_Estado = csNO_ID
    m_Estado = vbNullString
    m_Cliente = csNO_ID
    m_Cliente = vbNullString
    m_Titulo = vbNullString
    m_Descrip = vbNullString
    m_Codigo = vbNullString
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
        Case K_ESTADO
          m_est_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_CLIENTE
          m_cli_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_TITULO
          m_Titulo = gDB.ValField(rs.fields, cscLdpValor)
        Case K_DESCRIP
          m_Descrip = gDB.ValField(rs.fields, cscLdpValor)
        Case K_CODIGO
          m_Codigo = gDB.ValField(rs.fields, cscLdpValor)
      End Select

      rs.MoveNext
    Wend

    Dim Data As String
    Dim strLoad As String
    
    strLoad = LNGGetText(2341, vbNullString)  'Error al cargar legajos
    
    m_FechaIni = IIf(m_FechaIni <> csNoDate, m_FechaIni, Date)
    m_FechaFin = IIf(m_FechaFin <> csNoDate, m_FechaFin, Date)

    If UCase(Left$(m_est_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTEstado, cscEstId, Val(m_est_id), cscEstNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Estado = Data
    End If
    If UCase(Left$(m_cli_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTCliente, cscCliId, Val(m_cli_id), cscCliNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Cliente = Data
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
  
    Case K_ESTADO
      With m_ObjAbm.Properties(cscEstId)
        m_Estado = .Value
        m_est_id = .HelpValueProcess
      End With
  
    Case K_CLIENTE
      With m_ObjAbm.Properties(cscCliId)
        m_Cliente = .Value
        m_cli_id = .HelpValueProcess
      End With
  
    Case K_TITULO
      m_Titulo = m_ObjAbm.Properties(cscLgjTitulo).Value
  
    Case K_DESCRIP
      m_Descrip = m_ObjAbm.Properties(cscLgjDescrip).Value
  
    Case K_CODIGO
      m_Codigo = m_ObjAbm.Properties(cscLgjCodigo).Value

  End Select

  cIABMListDocClient_PropertyChange = True
End Function

Private Function cIABMListDocClient_Refresh() As String
  Dim sqlstmt As String

  sqlstmt = "sp_lsdoc_Legajos "

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
  
  sqlstmt = sqlstmt & gDB.sqlString(m_est_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_cli_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Titulo) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Descrip) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Codigo)

  cIABMListDocClient_Refresh = sqlstmt
End Function

Private Function cIABMListDocClient_Save() As Boolean

  Dim strError As String
  
  strError = LNGGetText(2342, vbNullString)
            'Error al grabar los parámetros de navegación de Legajo

  Dim register As cRegister
  Set register = New cRegister

  Dim sqlstmt As String
  
  sqlstmt = "delete ListaDocumentoParametro " & _
            " where pre_id = " & csPreEnvListLegajo & _
              " snd us_id = " & m_Us_id

  If Not gDB.Execute(sqlstmt, "cIABMClient_Save", C_Module, strError) Then Exit Function

  With register
  
    .Table = csTListaDocumentoParametro
    .UtilizaIdentity = True
  
    .fields.HaveLastUpdate = False
    .fields.HaveWhoModify = False
  
    Dim IProperty As cIABMProperty
    For Each IProperty In m_ObjAbm.Properties
  
      With .fields
        
        .Clear

        Select Case IProperty.Key
  
          Case K_FECHAINI
            
            If LenB(IProperty.HelpValueProcess) Then
              .Add2 cscLdpValor, IProperty.HelpValueProcess, csText
            Else
              .Add2 cscLdpValor, IProperty.Value, csText
            End If
            
            .Add2 cscLdpOrden, 10, csInteger
            .Add2 cscLdpId, K_FECHAINI, csInteger
            
          Case K_FECHAFIN
  
            If LenB(IProperty.HelpValueProcess) Then
              .Add2 cscLdpValor, IProperty.HelpValueProcess, csText
            Else
              .Add2 cscLdpValor, IProperty.Value, csText
            End If
  
            .Add2 cscLdpOrden, 20, csInteger
            .Add2 cscLdpId, K_FECHAFIN, csInteger
            
          Case K_ESTADO
            .Add2 cscLdpValor, IProperty.HelpValueProcess, csText
            .Add2 cscLdpOrden, 30, csInteger
            .Add2 cscLdpId, K_ESTADO, csInteger
            
          Case K_CLIENTE
            .Add2 cscLdpValor, IProperty.HelpValueProcess, csText
            .Add2 cscLdpOrden, 40, csInteger
            .Add2 cscLdpId, K_CLIENTE, csInteger
            
          Case K_TITULO
            .Add2 cscLdpValor, IProperty.Value, csText
            .Add2 cscLdpOrden, 50, csInteger
            .Add2 cscLdpId, K_TITULO, csInteger
            
          Case K_DESCRIP
            .Add2 cscLdpValor, IProperty.Value, csText
            .Add2 cscLdpOrden, 60, csInteger
            .Add2 cscLdpId, K_DESCRIP, csInteger
            
          Case K_CODIGO
            .Add2 cscLdpValor, IProperty.Value, csText
            .Add2 cscLdpOrden, 70, csInteger
            .Add2 cscLdpId, K_CODIGO, csInteger
  
        End Select
        
        .Add2 cscUsId, m_Us_id, csId
        .Add2 cscPreID, csPreEnvListLegajo, csId
        
        If Not gDB.Save(register, , "cIABMClient_Save", C_Module, strError) Then Exit Function
      End With
    Next
  End With
  
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

Private Sub Class_Initialize()
  On Error GoTo ControlError
 
  m_Title = LNGGetText(2318, vbNullString)
 
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

Private Sub pCreateMenu()
  On Error Resume Next
  
  If m_MenuLoaded Then Exit Sub
  
  m_MenuLoaded = True
  
  With m_ObjList
    Set .ObjClientMenu = Me
    .ClearMenu
    m_MenuShowInfoCli = .AddMenu(LNGGetText(1614, vbNullString))     'Ver Info del Cliente
    m_MenuAddMensaje = .AddMenu(LNGGetText(1615, vbNullString))      'Agregar Nota
    m_MenuShowMensajes = .AddMenu(LNGGetText(1616, vbNullString))    'Ver Notas
  End With
End Sub

Private Sub pShowMensajes()
  Dim sqlstmt As String
  Dim LgjId    As Long
  Dim rs      As ADODB.Recordset
  
  LgjId = m_ObjList.ID
  
  sqlstmt = "sp_ParteDiarioGetTitleForDoc " & csNO_ID & "," & LgjId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Dim infodoc As String
  Dim DoctId  As Long
  
  DoctId = gDB.ValField(rs.fields, cscDoctId)
  infodoc = gDB.ValField(rs.fields, "info_doc")
  
  sqlstmt = "sp_PartesDiarioGetForDoc " & gDB.UserId & "," & EmpId & "," & DoctId & "," & LgjId
  ShowNotes LNGGetText(2343, vbNullString, infodoc), sqlstmt
            'Notas sobre Legajo & infodoc
End Sub

Private Sub pAddMensaje()
  Dim Parte As Object
  Set Parte = CSKernelClient2.CreateObject("CSEnvio2.cParteDiario")
  
  Parte.AddParteToDoc csNO_ID, m_ObjList.ID, False
End Sub

