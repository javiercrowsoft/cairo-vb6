VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cEmbarqueListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient

'--------------------------------------------------------------------------------
' cEmbarqueListDoc
' 28-04-04

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cEmbarqueListDoc"

Private Const cscEmbFechaIni      As String = "emb_fechaini"
Private Const cscEmbFechaFin      As String = "emb_fechafin"

Private Const K_FECHAINI             As Integer = 4
Private Const K_FECHAFIN             As Integer = 5
Private Const K_PUE_ID_ORIGEN        As Integer = 10
Private Const K_PUE_ID_DESTINO       As Integer = 11
Private Const K_BARC_ID              As Integer = 12
Private Const K_ACTIVO               As Integer = 18

' Seudo - Variables
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_ObjAbm        As cIABMGenericListDoc
Private m_ObjList       As Object

Private m_Us_id       As Long

Private m_FechaIniV           As String
Private m_FechaFinV           As String

Private m_FechaIni           As Date
Private m_FechaFin           As Date
Private m_pue_id_origen      As Long
Private m_PuertoOrigen       As String
Private m_pue_id_destino     As Long
Private m_PuertoDestino      As String
Private m_Barc_id            As Long
Private m_Barco              As String
Private m_Activo             As Integer
Private m_Properties         As cABMDocProperties

Private m_MenuLoaded        As Boolean

Private m_MenuShowMensajes  As Long
Private m_MenuAddMensaje    As Long
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Function ProcessMenu(ByVal Index As Long)
  On Error GoTo ControlError

  Select Case Index
  
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

'-------------------------------------------------------------------------------------
' Interfaz cliente de List de documentos

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
    Set iProp = m_ObjAbm.Properties(cscEmbFechaIni)

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
    Set iProp = m_ObjAbm.Properties(cscEmbFechaFin)
    
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
    
  Case K_PUE_ID_ORIGEN
    m_pue_id_origen = m_ObjAbm.Properties(cscPueIdOrigen).HelpId
  Case K_PUE_ID_DESTINO
    m_pue_id_destino = m_ObjAbm.Properties(cscPueIdDestino).HelpId
  Case K_BARC_ID
    m_Barc_id = m_ObjAbm.Properties(cscBarcId).HelpId
  Case K_ACTIVO
    m_Activo = m_ObjAbm.Properties(cscActivo).ListItemData
  End Select
  
  cIABMListDocClient_PropertyChange = True
End Function

Private Function cIABMListDocClient_Refresh() As String
  Dim sqlstmt As String
  
  sqlstmt = "sp_lsdoc_Embarques "
  
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
  
  sqlstmt = sqlstmt & m_pue_id_origen & ","
  sqlstmt = sqlstmt & m_pue_id_destino & ","
  sqlstmt = sqlstmt & m_Barc_id & ","
  sqlstmt = sqlstmt & m_Activo
  
  cIABMListDocClient_Refresh = sqlstmt
End Function

Private Function cIABMListDocClient_Save() As Boolean
  Dim register As cRegister
  Set register = New cRegister
  
  Dim sqlstmt As String
  sqlstmt = "delete ListaDocumentoParametro " & _
            " where pre_id = " & csPreExpListEmbarque & _
              " and us_id = " & m_Us_id

  If Not gDB.Execute(sqlstmt, "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  register.Table = csTListaDocumentoParametro
  register.UtilizaIdentity = True
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    
    register.Fields.Clear
    
    With IProperty
      Select Case .Key
        Case K_FECHAINI
        
          If LenB(.HelpValueProcess) Then
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
          Else
            register.Fields.Add2 cscLdpValor, .Value, csText
          End If
          register.Fields.Add2 cscLdpOrden, 10, csInteger
          register.Fields.Add2 cscLdpId, K_FECHAINI, csInteger
          
        Case K_FECHAFIN
          
          If LenB(.HelpValueProcess) Then
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
          Else
            register.Fields.Add2 cscLdpValor, .Value, csText
          End If
          register.Fields.Add2 cscLdpOrden, 20, csInteger
          register.Fields.Add2 cscLdpId, K_FECHAFIN, csInteger
          
        Case K_PUE_ID_ORIGEN
          register.Fields.Add2 cscLdpValor, .HelpId, csText
          register.Fields.Add2 cscLdpOrden, 60, csInteger
          register.Fields.Add2 cscLdpId, K_PUE_ID_ORIGEN, csInteger
          
        Case K_PUE_ID_DESTINO
          register.Fields.Add2 cscLdpValor, .HelpId, csText
          register.Fields.Add2 cscLdpOrden, 70, csInteger
          register.Fields.Add2 cscLdpId, K_PUE_ID_DESTINO, csInteger
          
        Case K_BARC_ID
          register.Fields.Add2 cscLdpValor, .HelpId, csText
          register.Fields.Add2 cscLdpOrden, 80, csInteger
          register.Fields.Add2 cscLdpId, K_BARC_ID, csInteger
          
        Case K_ACTIVO
          register.Fields.Add2 cscLdpValor, .ListItemData, csText
          register.Fields.Add2 cscLdpOrden, 110, csInteger
          register.Fields.Add2 cscLdpId, K_ACTIVO, csInteger
          
      End Select
  
      register.Fields.Add2 cscUsId, m_Us_id, csId
      register.Fields.Add2 cscPreID, csPreExpListEmbarque, csId
  
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
      If Not gDB.Save(register, , "cIABMListDocClient_Save", C_Module, c_ErrorSave) Then Exit Function
    
    End With
  Next
  If Not Load(m_Us_id) Then Exit Function
  
  cIABMListDocClient_Save = True
End Function

Private Function cIABMListDocClient_Terminate() As Boolean
  cIABMListDocClient_Terminate = True
End Function

Private Property Get cIABMListDocClient_Title() As String
  cIABMListDocClient_Title = LNGGetText(2421, vbNullString) 'Embarques
End Property

Private Function cIABMListDocClient_Validate() As Boolean
  cIABMListDocClient_Validate = True
End Function

'-------------------------------------------------------------------------------------
' Implementacion de cIEditGeneric
Private Function cIEditGenericListDoc_GridAdd(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_GridEdit(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_GridRemove(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Property Set cIEditGenericListDoc_ObjABM(rhs As CSInterfacesABM.cIABMGenericListDoc)
  Set m_ObjAbm = rhs
End Property

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

Private Property Set cIEditGenericListDoc_ObjList(rhs As Object)
  Set m_ObjList = rhs
End Property

Private Function cIEditGenericListDoc_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_TabClick(ByVal Index As Integer) As Boolean

End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  m_ObjAbm.Properties.Clear
  
  Dim c As cIABMProperty
  Dim o As cIABMListItem
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscEmbFechaIni)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1203, vbNullString) 'Fecha desde
  c.Key = K_FECHAINI
  If LenB(m_FechaIniV) Then
    c.Value = m_FechaIniV
  Else
    c.Value = m_FechaIni
  End If
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscEmbFechaFin)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1204, vbNullString) 'Fecha hasta
  c.Key = K_FECHAFIN
  If LenB(m_FechaFinV) Then
    c.Value = m_FechaFinV
  Else
    c.Value = m_FechaFin
  End If
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPueIdOrigen)
  c.PropertyType = cspHelp
  c.Table = csPuerto
  c.Name = LNGGetText(2400, vbNullString) 'Puerto origen
  c.Key = K_PUE_ID_ORIGEN
  c.Value = m_PuertoOrigen
  c.HelpId = m_pue_id_origen
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPueIdDestino)
  c.PropertyType = cspHelp
  c.Table = csPuerto
  c.Name = LNGGetText(2401, vbNullString) 'Puerto detino
  c.Key = K_PUE_ID_DESTINO
  c.Value = m_PuertoDestino
  c.HelpId = m_pue_id_destino
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscBarcId)
  c.PropertyType = cspHelp
  c.Table = csBarco
  c.Name = LNGGetText(1035, vbNullString) 'Contacto
  c.Key = K_BARC_ID
  c.Value = m_Barco
  c.HelpId = m_Barc_id
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscActivo)
  c.PropertyType = cspList
  c.Name = C_strActivo
  c.Key = K_ACTIVO
  c.ListWhoSetItem = csListItemData
  c.ListItemData = m_Activo
    
    Set o = New CSABMInterface2.cABMListItem
    o.ID = csTriLogicState.csTLBoth
    o.Value = LNGGetText(2426, vbNullString) 'Ambas
    c.List.Add o, csTriLogicState.csTLBoth
    
    Set o = New CSABMInterface2.cABMListItem
    o.ID = csTriLogicState.csTLNo
    o.Value = LNGGetText(2427, vbNullString) 'Inactivas
    c.List.Add o, csTriLogicState.csTLNo
    
    Set o = New CSABMInterface2.cABMListItem
    o.ID = csTriLogicState.csTLYes
    o.Value = LNGGetText(2428, vbNullString) 'Activas
    c.List.Add o, csTriLogicState.csTLYes
  
  pCreateMenu
  If Not m_ObjAbm.Show(Me, m_ObjList) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal us_id As Long) As Boolean
  Dim sqlstmt  As String
  Dim rs       As ADODB.Recordset
  
  sqlstmt = "select * from ListaDocumentoParametro" & _
            " where us_id = " & us_id & _
              " and pre_id = " & csPreExpListEmbarque & _
            " order by " & cscLdpOrden
    
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
  
  If rs.EOF Then
    
    m_FechaIni = Date
    m_FechaFin = Date
    m_FechaIniV = vbNullString
    m_FechaFinV = vbNullString
    m_pue_id_origen = csNO_ID
    m_pue_id_destino = csNO_ID
    m_Barc_id = csNO_ID
    m_Activo = csTriLogicState.csTLBoth
    m_PuertoOrigen = vbNullString
    m_PuertoDestino = vbNullString
    m_Barco = vbNullString

  Else
  
    rs.MoveLast
    rs.MoveFirst
    
    Dim i As Integer
    
    While Not rs.EOF
      Select Case gDB.ValField(rs.Fields, cscLdpId)
        Case K_FECHAINI
          m_FechaIniV = gDB.ValField(rs.Fields, cscLdpValor)
          m_FechaIni = IIf(IsDate(gDB.ValField(rs.Fields, cscLdpValor)), gDB.ValField(rs.Fields, cscLdpValor), Date)
        Case K_FECHAFIN
          m_FechaFinV = gDB.ValField(rs.Fields, cscLdpValor)
          m_FechaFin = IIf(IsDate(gDB.ValField(rs.Fields, cscLdpValor)), gDB.ValField(rs.Fields, cscLdpValor), Date)
        Case K_PUE_ID_ORIGEN
          m_pue_id_origen = Val(gDB.ValField(rs.Fields, cscLdpValor))
        Case K_PUE_ID_DESTINO
          m_pue_id_destino = Val(gDB.ValField(rs.Fields, cscLdpValor))
        Case K_BARC_ID
          m_Barc_id = Val(gDB.ValField(rs.Fields, cscLdpValor))
        Case K_ACTIVO
          m_Activo = Val(gDB.ValField(rs.Fields, cscLdpValor))
      End Select
      
      rs.MoveNext
    Wend
    
    Dim Data As String
    Dim str_Load As String
    
    str_Load = LNGGetText(2429, vbNullString)
              'Error al cargar los parámetros de navegación de Embarque
              
    m_FechaFin = IIf(m_FechaFin <> csNoDate, m_FechaFin, Date)
    m_FechaIni = IIf(m_FechaIni <> csNoDate, m_FechaIni, Date)
    
    If Not gDB.GetData(csTPuerto, cscPueId, m_pue_id_origen, cscPueNombre, Data, C_LoadFunction, C_Module, str_Load) Then Exit Function
    m_PuertoOrigen = Data
    If Not gDB.GetData(csTPuerto, cscPueId, m_pue_id_destino, cscPueNombre, Data, C_LoadFunction, C_Module, str_Load) Then Exit Function
    m_PuertoDestino = Data
    If Not gDB.GetData(csTBarco, cscBarcId, m_Barc_id, cscBarcNombre, Data, C_LoadFunction, C_Module, str_Load) Then Exit Function
    m_Barco = Data
  End If

  Load = True

End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2430, vbNullString)
                'Error al grabar los parámetros de navegación de Embarque
  Set m_Properties = New cABMDocProperties
  With m_Properties
    'Set .ImageList = fResource.ilList
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
    m_MenuAddMensaje = .AddMenu(LNGGetText(1615, vbNullString))        'Agregar Nota
    m_MenuShowMensajes = .AddMenu(LNGGetText(1616, vbNullString))      'Ver Notas
  End With
End Sub

Private Sub pShowMensajes()
  Dim sqlstmt As String
  Dim EmbId    As Long
  Dim rs      As ADODB.Recordset
  
  EmbId = m_ObjList.ID
  
  sqlstmt = "sp_ParteDiarioGetTitleForDoc " & csNO_ID & "," & EmbId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Dim infodoc As String
  Dim DoctId  As Long
  
  DoctId = gDB.ValField(rs.Fields, cscDoctId)
  infodoc = gDB.ValField(rs.Fields, "info_doc")
  
  sqlstmt = "sp_PartesDiarioGetForDoc " & gDB.UserId & "," & EmpId & "," & DoctId & "," & EmbId
  ShowNotes LNGGetText(2425, vbNullString, infodoc), sqlstmt
            'Notas sobre Embarque & infodoc
End Sub

Private Sub pAddMensaje()
  Dim Parte As Object
  Set Parte = CSKernelClient2.CreateObject("CSEnvio2.cParteDiario")
  
  Parte.AddParteToDoc csNO_ID, m_ObjList.ID, False
End Sub

