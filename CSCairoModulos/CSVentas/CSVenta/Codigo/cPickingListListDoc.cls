VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPickingListListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient
'--------------------------------------------------------------------------------
' cPickingListListDoc
' 15-12-2007

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cPickingListListDoc"

Private Const c_FechaIni = "FechaIni"
Private Const c_FechaFin = "FechaFin"

Private Const c_img_task = 1

Private Const K_FECHADESDE                      As Integer = 1
Private Const K_FECHAHASTA                      As Integer = 2
Private Const K_NRODOC                          As Integer = 3
Private Const K_CLI_ID                          As Integer = 4
Private Const K_VEN_ID                          As Integer = 5
Private Const K_ZON_ID                          As Integer = 6

' Seudo - Variables
Private c_strLoad                         As String
Private c_ErrorSave                       As String

' estructuras
' variables privadas

Private m_FechaDesdeV                     As String
Private m_FechaHastaV                     As String

Private m_FechaDesde                      As Date
Private m_FechaHasta                      As Date

Private m_Nrodoc            As String
Private m_cli_id            As String
Private m_cliente           As String
Private m_ven_id            As String
Private m_vendedor          As String
Private m_zon_id            As String
Private m_zona              As String

Private m_MenuLoaded        As Boolean

Private m_MenuShowMensajes  As Long
Private m_MenuAddMensaje    As Long

'OJO HASTA ACA
Private m_ObjAbm        As cIABMGenericListDoc
Private m_ObjList       As Object

Private m_Us_id         As Long

Private m_Properties    As cABMDocProperties
' Properties publicas
' Properties privadas
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

' Implementacion de cIABMClient

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

    Case K_FECHADESDE
      Set iProp = m_ObjAbm.Properties(c_FechaIni)

      If LenB(iProp.HelpValueProcess) Then
        m_FechaDesdeV = iProp.HelpValueProcess
        m_FechaDesde = VDGetDateByName(m_FechaDesdeV)
      ElseIf IsDate(iProp.Value) Then
        m_FechaDesdeV = vbNullString
        m_FechaDesde = iProp.Value
      Else
        m_FechaDesdeV = vbNullString
        iProp.Value = m_FechaDesde
      End If

    Case K_FECHAHASTA
      
      Set iProp = m_ObjAbm.Properties(c_FechaFin)
      
      If LenB(iProp.HelpValueProcess) Then
        m_FechaHastaV = iProp.HelpValueProcess
        m_FechaHasta = VDGetDateByName(m_FechaHastaV)
      ElseIf IsDate(iProp.Value) Then
        m_FechaHastaV = vbNullString
        m_FechaHasta = iProp.Value
      Else
        m_FechaHastaV = vbNullString
        iProp.Value = m_FechaHasta
      End If
    
    Case K_NRODOC
      m_Nrodoc = m_ObjAbm.Properties(cscPklNrodoc).Value
  
  End Select

  cIABMListDocClient_PropertyChange = True
End Function

Private Function cIABMListDocClient_Refresh() As String
  Dim sqlstmt As String

  pValidateFilters

  sqlstmt = "sp_lsdoc_PickingLists "

  sqlstmt = sqlstmt & gDB.UserId & ","
    
  If Not DateNames(m_FechaDesdeV) Is Nothing Then
    sqlstmt = sqlstmt & gDB.sqlDate(VDGetDateByName(m_FechaDesdeV)) & ","
  Else
    sqlstmt = sqlstmt & gDB.sqlDate(m_FechaDesde) & ","
  End If
  
  If Not DateNames(m_FechaHastaV) Is Nothing Then
    sqlstmt = sqlstmt & gDB.sqlDate(VDGetDateByName(m_FechaHastaV)) & ","
  Else
    sqlstmt = sqlstmt & gDB.sqlDate(m_FechaHasta) & ","
  End If
    
  sqlstmt = sqlstmt & gDB.sqlString(m_Nrodoc) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_cli_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_ven_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_zon_id)
  
  cIABMListDocClient_Refresh = sqlstmt
End Function

Private Sub pValidateFilters()
  If LenB(m_Nrodoc) Then Exit Sub
  If LenB(m_cli_id) And m_cli_id <> "0" Then Exit Sub
  If LenB(m_ven_id) And m_ven_id <> "0" Then Exit Sub
  If LenB(m_zon_id) And m_zon_id <> "0" Then Exit Sub
  
  Dim fdesde As Date
  Dim fhasta As Date
  
  If Not DateNames(m_FechaDesdeV) Is Nothing Then
    fdesde = VDGetDateByName(m_FechaDesdeV)
  Else
    fdesde = m_FechaDesde
  End If
  
  If Not DateNames(m_FechaHastaV) Is Nothing Then
    fhasta = VDGetDateByName(m_FechaHastaV)
  Else
    fhasta = m_FechaHasta
  End If
  
  If DateDiff("m", fdesde, fhasta) <= 6 Then Exit Sub
  
  If Not Ask(LNGGetText(3664, vbNullString), vbNo) Then
    m_cli_id = -1
  End If

End Sub

Private Function cIABMListDocClient_Save() As Boolean
  Dim register As cRegister
  Set register = New cRegister

  Dim sqlstmt As String
  sqlstmt = "delete ListaDocumentoParametro " & _
            " where pre_id = " & csPreVtaListPickingList & _
              " and us_id = " & m_Us_id

  If Not gDB.Execute(sqlstmt, "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function

  register.Table = csTListaDocumentoParametro
  register.UtilizaIdentity = True

  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties

    register.fields.Clear

    With IProperty
      Select Case .Key

        Case K_FECHADESDE
          If LenB(.HelpValueProcess) Then
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          Else
            register.fields.Add2 cscLdpValor, .Value, csText
          End If
          register.fields.Add2 cscLdpOrden, 10, csInteger
          register.fields.Add2 cscLdpId, K_FECHADESDE, csInteger
        Case K_FECHAHASTA
          If LenB(.HelpValueProcess) Then
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          Else
            register.fields.Add2 cscLdpValor, .Value, csText
          End If
          register.fields.Add2 cscLdpOrden, 20, csInteger
          register.fields.Add2 cscLdpId, K_FECHAHASTA, csInteger
        
        Case K_NRODOC
          register.fields.Add2 cscLdpValor, .Value, csText
          register.fields.Add2 cscLdpOrden, 30, csInteger
          register.fields.Add2 cscLdpId, K_NRODOC, csInteger
                    
        Case K_CLI_ID
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 40, csInteger
          register.fields.Add2 cscLdpId, K_CLI_ID, csInteger
                    
        Case K_VEN_ID
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 50, csInteger
          register.fields.Add2 cscLdpId, K_VEN_ID, csInteger
                    
        Case K_ZON_ID
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 50, csInteger
          register.fields.Add2 cscLdpId, K_ZON_ID, csInteger
                    
      End Select
      
      register.fields.Add2 cscUsId, m_Us_id, csId
      register.fields.Add2 cscPreID, csPreVtaListPickingList, csId

      register.fields.HaveLastUpdate = False
      register.fields.HaveLastUpdate = False
      If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
    End With
  Next
  If Not Load(m_Us_id) Then Exit Function

  cIABMListDocClient_Save = True
End Function

Private Function cIABMListDocClient_Terminate() As Boolean
  cIABMListDocClient_Terminate = True
End Function

Private Property Get cIABMListDocClient_Title() As String
  cIABMListDocClient_Title = LNGGetText(4855, vbNullString) 'Listas de Despacho
End Property

Private Function cIABMListDocClient_Validate() As Boolean
  cIABMListDocClient_Validate = True
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  Dim o As cIABMListItem
  Dim Value As String
  Dim bExists As Boolean

  m_ObjAbm.Properties.Clear

  Set c = m_ObjAbm.Properties.Add(Nothing, c_FechaIni)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1203, vbNullString) 'Fecha Desde
  c.Key = K_FECHADESDE
  If LenB(m_FechaDesdeV) Then
    c.Value = m_FechaDesdeV
  Else
    c.Value = m_FechaDesde
  End If
  

  Set c = m_ObjAbm.Properties.Add(Nothing, c_FechaFin)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1204, vbNullString) 'Fecha Hasta
  c.Key = K_FECHAHASTA
  If LenB(m_FechaHastaV) Then
    c.Value = m_FechaHastaV
  Else
    c.Value = m_FechaHasta
  End If
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPklNrodoc)
  c.PropertyType = cspText
  c.Name = LNGGetText(1065, vbNullString) 'Numero
  c.Size = 255
  c.Key = K_NRODOC
  c.Value = m_Nrodoc

  Set c = m_ObjAbm.Properties.Add(Nothing, cscCliId)
  c.PropertyType = cspHelp
  c.Table = csCliente
  c.Name = LNGGetText(1150, vbNullString) 'Cliente
  c.Key = K_CLI_ID
  Value = m_cliente
  If UCase(Left$(m_cli_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csCliente, Val(Mid(m_cli_id, 2)), bExists)
    If Not bExists Then m_cli_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_cli_id)
  c.HelpValueProcess = m_cli_id

  Set c = m_ObjAbm.Properties.Add(Nothing, cscVenId)
  c.PropertyType = cspHelp
  c.Table = csVendedores
  c.Name = LNGGetText(1510, vbNullString) 'Vendedor
  c.Key = K_VEN_ID
  Value = m_vendedor
  If UCase(Left$(m_ven_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csVendedores, Val(Mid(m_ven_id, 2)), bExists)
    If Not bExists Then m_ven_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_ven_id)
  c.HelpValueProcess = m_ven_id

  Set c = m_ObjAbm.Properties.Add(Nothing, cscZonId)
  c.PropertyType = cspHelp
  c.Table = csZona
  c.Name = LNGGetText(1402, vbNullString) 'Zona
  c.Key = K_ZON_ID
  Value = m_zona
  If UCase(Left$(m_zon_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csZona, Val(Mid(m_zon_id, 2)), bExists)
    If Not bExists Then m_zon_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_zon_id)
  c.HelpValueProcess = m_zon_id

  pCreateMenu
  If Not m_ObjAbm.Show(Me, m_ObjList) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal us_id As Long) As Boolean
  Dim sqlstmt As String

  sqlstmt = "select * from ListaDocumentoParametro " & _
            " where us_id = " & us_id & _
              " and pre_id = " & csPreVtaListPickingList & _
            " order by " & cscLdpOrden

  Dim rs As ADODB.Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If rs.EOF Then
    
    m_FechaDesde = Date
    m_FechaHasta = Date
    m_FechaDesdeV = vbNullString
    m_FechaHastaV = vbNullString
    m_Nrodoc = vbNullString
    m_cli_id = vbNullString
    m_cliente = vbNullString
    m_ven_id = vbNullString
    m_vendedor = vbNullString
    m_zon_id = vbNullString
    m_zona = vbNullString
  
  Else

    rs.MoveLast
    rs.MoveFirst
    
    Dim i As Integer
    While Not rs.EOF

      Select Case gDB.ValField(rs.fields, cscLdpId)

        Case K_FECHADESDE
          m_FechaDesdeV = gDB.ValField(rs.fields, cscLdpValor)
          m_FechaDesde = IIf(IsDate(gDB.ValField(rs.fields, cscLdpValor)), gDB.ValField(rs.fields, cscLdpValor), Date)
        Case K_FECHAHASTA
          m_FechaHastaV = gDB.ValField(rs.fields, cscLdpValor)
          m_FechaHasta = IIf(IsDate(gDB.ValField(rs.fields, cscLdpValor)), gDB.ValField(rs.fields, cscLdpValor), Date)
        Case K_NRODOC
          m_Nrodoc = gDB.ValField(rs.fields, cscLdpValor)
        Case K_CLI_ID
          m_cli_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_VEN_ID
          m_ven_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_ZON_ID
          m_zon_id = gDB.ValField(rs.fields, cscLdpValor)

      End Select

      rs.MoveNext
    Wend

    Dim Data As String

    If UCase(Left$(m_cli_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTCliente, cscCliId, Val(m_cli_id), cscCliNombre, Data, C_LoadFunction, C_Module, c_strLoad) Then Exit Function
      m_cliente = Data
    End If

    If UCase(Left$(m_ven_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTVendedor, cscVenId, Val(m_ven_id), cscVenNombre, Data, C_LoadFunction, C_Module, c_strLoad) Then Exit Function
      m_vendedor = Data
    End If

    If UCase(Left$(m_zon_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTZona, cscZonId, Val(m_zon_id), cscZonNombre, Data, C_LoadFunction, C_Module, c_strLoad) Then Exit Function
      m_zona = Data
    End If

  End If

  Load = True

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

Private Sub pCreateMenu()
  On Error Resume Next
  
  If m_MenuLoaded Then Exit Sub
  
  m_MenuLoaded = True
  
  With m_ObjList
    Set .ObjClientMenu = Me
    .ClearMenu
    m_MenuAddMensaje = .AddMenu(LNGGetText(1615, vbNullString))    'Agregar Nota
    m_MenuShowMensajes = .AddMenu(LNGGetText(1616, vbNullString))  'Ver Notas
  End With
End Sub

Private Sub pShowMensajes()
  Dim sqlstmt As String
  Dim LqdId   As Long
  Dim rs      As ADODB.Recordset
  
  LqdId = m_ObjList.id
  
  sqlstmt = "sp_ParteDiarioGetTitleForDoc " & csPickingList & "," & LqdId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Dim infodoc As String
  Dim DoctId  As Long
  
  DoctId = csPickingList
  infodoc = gDB.ValField(rs.fields, "info_doc")
  
  sqlstmt = "sp_PartesDiarioGetForDoc " & gDB.UserId & "," & EmpId & "," & DoctId & "," & LqdId
  ShowNotes LNGGetText(4856, vbNullString, infodoc), sqlstmt
            'Notas sobre Listas de Despacho & infodoc
End Sub

Private Sub pAddMensaje()
  Dim Parte As Object
  Set Parte = CSKernelClient2.CreateObject("CSEnvio2.cParteDiario")
  
  Parte.AddParteToDoc csPickingList, m_ObjList.id, False
End Sub

Private Function pGetLqdIds() As Long()
  pGetLqdIds = m_ObjList.SelectedItems
End Function

' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_strLoad = LNGGetText(4857, vbNullString)
              'Error al cargar los parámetros de navegación de listas de despacho
  c_ErrorSave = LNGGetText(4858, vbNullString)
              'Error al grabar los párametros de navegación de listas de despacho
  
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


