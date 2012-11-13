VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGarantiaListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient

'--------------------------------------------------------------------------------
' cGarantiaListDoc
' 28-06-04

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cGarantiaListDoc"

Private Const c_FechaIni = "FechaIni"
Private Const c_FechaFin = "FechaFin"
Private Const c_FechaVto = "FechaVto"

Private Const c_img_task = 1

' ACA VAN LAS K GENERADAS POR EL ASISTENTE.
Private Const K_FECHAINI                       As Integer = 1
Private Const K_FECHAFIN                       As Integer = 2
Private Const K_FECHAVTO                       As Integer = 3
Private Const K_PROV_ID                        As Integer = 4
Private Const K_MON_ID                         As Integer = 5
Private Const K_CODIGO                         As Integer = 6
Private Const K_NROPOLIZA                      As Integer = 7
Private Const K_CODIGOADUANA                   As Integer = 8

' Seudo - Variables
Private c_strTitle    As String '= "Garantias"

' estructuras
' variables privadas
Private m_FechaIniV                      As String
Private m_FechaFinV                      As String
Private m_FechaVtoV                      As String

' ACA VAN LAS m_ GENERADAS POR EL ASISTENTE.
Private m_FechaIni                       As Date
Private m_FechaFin                       As Date
Private m_Fechavto                       As Date
Private m_prov_id                        As String
Private m_Proveedor                      As String
Private m_Mon_id                         As String
Private m_Moneda                         As String
Private m_Codigo                         As String
Private m_Nropoliza                      As String
Private m_Codigoaduana                   As String

'OJO HASTA ACA

Private m_ObjAbm            As cIABMGenericListDoc
Private m_ObjList           As Object
Private m_Us_id             As Long
Private m_Properties        As cABMDocProperties

Private m_MenuLoaded        As Boolean

Private m_MenuShowMensajes  As Long
Private m_MenuAddMensaje    As Long
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

' funciones privadas

Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  Dim o As cIABMListItem
  Dim Value As String
  Dim bExists As Boolean

  m_ObjAbm.Properties.Clear

  Set c = m_ObjAbm.Properties.Add(Nothing, c_FechaIni)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1203, vbNullString) 'Fecha desde
  c.Key = K_FECHAINI
  If LenB(m_FechaIniV) Then
    c.Value = m_FechaIniV
  Else
    c.Value = m_FechaIni
  End If
  

  Set c = m_ObjAbm.Properties.Add(Nothing, c_FechaFin)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1204, vbNullString) 'Fecha hasta
  c.Key = K_FECHAFIN
  If LenB(m_FechaFinV) Then
    c.Value = m_FechaFinV
  Else
    c.Value = m_FechaFin
  End If
  

  Set c = m_ObjAbm.Properties.Add(Nothing, c_FechaVto)
  c.PropertyType = cspDate
  c.Name = LNGGetText(2473, vbNullString) 'Vence antes del
  c.Key = K_FECHAVTO
  If LenB(m_FechaFinV) Then
    c.Value = m_FechaVtoV
  Else
    c.Value = m_Fechavto
  End If
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscProvId)
  c.PropertyType = cspHelp
  c.Table = csProveedor
  c.Name = LNGGetText(2474, vbNullString) 'Aseguradora
  c.Key = K_PROV_ID
  Value = m_Proveedor
  If UCase(Left$(m_prov_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csProveedor, Val(Mid(m_prov_id, 2)), bExists)
    If Not bExists Then m_prov_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_prov_id)
  c.HelpValueProcess = m_prov_id
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscMonId)
  c.PropertyType = cspHelp
  c.Table = csMoneda
  c.Name = LNGGetText(1113, vbNullString) 'Moneda
  c.Key = K_MON_ID
  Value = m_Moneda
  If UCase(Left$(m_Mon_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csMoneda, Val(Mid(m_Mon_id, 2)), bExists)
    If Not bExists Then m_Mon_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_Mon_id)
  c.HelpValueProcess = m_Mon_id
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscGarCodigo)
  c.PropertyType = cspText
  c.Name = C_strCodigo
  c.Size = 15
  c.Key = K_CODIGO
  c.Value = m_Codigo
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscGarNropoliza)
  c.PropertyType = cspText
  c.Name = LNGGetText(2475, vbNullString) 'Poliza
  c.Size = 50
  c.Key = K_NROPOLIZA
  c.Value = m_Nropoliza
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscGarCodigoaduana)
  c.PropertyType = cspText
  c.Name = LNGGetText(2455, vbNullString) 'Codigo Aduana
  c.Size = 50
  c.Key = K_CODIGOADUANA
  c.Value = m_Codigoaduana
  
  pCreateMenu
  If Not m_ObjAbm.Show(Me, m_ObjList) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal us_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select * from ListaDocumentoParametro" & _
            " where us_id = " & us_id & _
              " and pre_id = " & csPreExpListGarantia & _
            " order by " & cscLdpOrden

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If rs.EOF Then
    
    m_FechaIni = Date
    m_FechaFin = Date
    m_Fechavto = Date
    m_FechaIniV = vbNullString
    m_FechaFinV = vbNullString
    m_FechaVtoV = vbNullString
    m_prov_id = csNO_ID
    m_Proveedor = vbNullString
    m_Mon_id = csNO_ID
    m_Moneda = vbNullString
    m_Codigo = vbNullString
    m_Nropoliza = vbNullString
    m_Codigoaduana = vbNullString
    
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
        Case K_FECHAVTO
          m_FechaVtoV = gDB.ValField(rs.Fields, cscLdpValor)
          m_Fechavto = IIf(IsDate(gDB.ValField(rs.Fields, cscLdpValor)), gDB.ValField(rs.Fields, cscLdpValor), Date)
        Case K_PROV_ID
          m_prov_id = gDB.ValField(rs.Fields, cscLdpValor)
        Case K_MON_ID
          m_Mon_id = gDB.ValField(rs.Fields, cscLdpValor)
        Case K_CODIGO
          m_Codigo = gDB.ValField(rs.Fields, cscLdpValor)
        Case K_NROPOLIZA
          m_Nropoliza = gDB.ValField(rs.Fields, cscLdpValor)
        Case K_CODIGOADUANA
          m_Codigoaduana = gDB.ValField(rs.Fields, cscLdpValor)
      End Select

      rs.MoveNext
    Wend

    Dim Data As String
    Dim strLoad As String
    
    strLoad = LNGGetText(2459, vbNullString)
              'Error al cargar los parámetros de navegación de Garantía
    
    m_FechaIni = IIf(m_FechaIni <> csNoDate, m_FechaIni, Date)
    m_FechaFin = IIf(m_FechaFin <> csNoDate, m_FechaFin, Date)
    m_Fechavto = IIf(m_Fechavto <> csNoDate, m_Fechavto, Date)

    If UCase(Left$(m_prov_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTProveedor, cscProvId, Val(m_prov_id), cscProvNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Proveedor = Data
    End If
    If UCase(Left$(m_Mon_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTMoneda, cscMonId, Val(m_Mon_id), cscMonNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Moneda = Data
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
        m_FechaIniV = vbNullString
        m_FechaIni = iProp.Value
      Else
        m_FechaIniV = vbNullString
        iProp.Value = m_FechaIni
      End If
  
    Case K_FECHAFIN
      
      Set iProp = m_ObjAbm.Properties(c_FechaFin)
      
      If LenB(iProp.HelpValueProcess) Then
        m_FechaFinV = iProp.HelpValueProcess
        m_FechaFin = VDGetDateByName(m_FechaFinV)
      ElseIf IsDate(iProp.Value) Then
        m_FechaFinV = vbNullString
        m_FechaFin = iProp.Value
      Else
        m_FechaFinV = vbNullString
        iProp.Value = m_FechaFin
      End If

    Case K_FECHAVTO
      
      Set iProp = m_ObjAbm.Properties(c_FechaVto)
      
      If LenB(iProp.HelpValueProcess) Then
        m_FechaVtoV = iProp.HelpValueProcess
        m_Fechavto = VDGetDateByName(m_FechaVtoV)
      ElseIf IsDate(iProp.Value) Then
        m_FechaVtoV = vbNullString
        m_Fechavto = iProp.Value
      Else
        m_FechaVtoV = vbNullString
        iProp.Value = m_Fechavto
      End If
  
    Case K_PROV_ID
      With m_ObjAbm.Properties(cscProvId)
        m_Proveedor = .Value
        m_prov_id = .HelpValueProcess
      End With

    Case K_MON_ID
      With m_ObjAbm.Properties(cscMonId)
        m_Moneda = .Value
        m_Mon_id = .HelpValueProcess
      End With

    Case K_CODIGO
      m_Codigo = m_ObjAbm.Properties(cscGarCodigo).Value

    Case K_NROPOLIZA
      m_Nropoliza = m_ObjAbm.Properties(cscGarNropoliza).Value

    Case K_CODIGOADUANA
      m_Codigoaduana = m_ObjAbm.Properties(cscGarCodigoaduana).Value

  End Select

  cIABMListDocClient_PropertyChange = True
End Function

Private Function cIABMListDocClient_Refresh() As String
  Dim sqlstmt As String

  sqlstmt = "sp_lsdoc_Garantias "

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

  If Not DateNames(m_FechaVtoV) Is Nothing Then
    sqlstmt = sqlstmt & gDB.sqlDate(VDGetDateByName(m_FechaVtoV)) & ","
  Else
    sqlstmt = sqlstmt & gDB.sqlDate(m_Fechavto) & ","
  End If

  sqlstmt = sqlstmt & gDB.sqlString(m_prov_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Mon_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Codigo) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Nropoliza) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Codigoaduana)

  cIABMListDocClient_Refresh = sqlstmt
End Function

Private Function cIABMListDocClient_Save() As Boolean

  Dim strError As String
  
  strError = LNGGetText(2460, vbNullString)
          'Error al grabar los párametros de navegación de Garantía
          
  Dim register As cRegister
  Set register = New cRegister

  Dim sqlstmt As String
  
  sqlstmt = "delete ListaDocumentoParametro " & _
            " where pre_id = " & csPreExpListGarantia & _
              " and us_id = " & m_Us_id

  If Not gDB.Execute(sqlstmt, "cIABMClient_Save", C_Module, strError) Then Exit Function

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

        Case K_FECHAVTO

          If LenB(.HelpValueProcess) Then
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
          Else
            register.Fields.Add2 cscLdpValor, .Value, csText
          End If

          register.Fields.Add2 cscLdpOrden, 30, csInteger
          register.Fields.Add2 cscLdpId, K_FECHAVTO, csInteger

        Case K_PROV_ID
          register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.Fields.Add2 cscLdpOrden, 40, csInteger
          register.Fields.Add2 cscLdpId, K_PROV_ID, csInteger
        
        Case K_MON_ID
          register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.Fields.Add2 cscLdpOrden, 50, csInteger
          register.Fields.Add2 cscLdpId, K_MON_ID, csInteger
        
        Case K_CODIGO
          register.Fields.Add2 cscLdpValor, .Value, csText
          register.Fields.Add2 cscLdpOrden, 60, csInteger
          register.Fields.Add2 cscLdpId, K_CODIGO, csInteger
        
        Case K_NROPOLIZA
          register.Fields.Add2 cscLdpValor, .Value, csText
          register.Fields.Add2 cscLdpOrden, 70, csInteger
          register.Fields.Add2 cscLdpId, K_NROPOLIZA, csInteger
        
        Case K_CODIGOADUANA
          register.Fields.Add2 cscLdpValor, .Value, csText
          register.Fields.Add2 cscLdpOrden, 80, csInteger
          register.Fields.Add2 cscLdpId, K_CODIGOADUANA, csInteger

      End Select
      
      register.Fields.Add2 cscUsId, m_Us_id, csId
      register.Fields.Add2 cscPreID, csPreExpListGarantia, csId

      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
      
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
  cIABMListDocClient_Title = c_strTitle
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
 
  c_strTitle = LNGGetText(2438, vbNullString)   'Garantías
 
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
    m_MenuAddMensaje = .AddMenu(LNGGetText(1615, vbNullString))       'Agregar Nota
    m_MenuShowMensajes = .AddMenu(LNGGetText(1616, vbNullString))     'Ver Notas
  End With
End Sub

Private Sub pShowMensajes()
  Dim sqlstmt As String
  Dim GarId    As Long
  Dim rs      As ADODB.Recordset
  
  GarId = m_ObjList.ID
  
  sqlstmt = "sp_ParteDiarioGetTitleForDoc " & csNO_ID & "," & GarId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Dim infodoc As String
  Dim DoctId  As Long
  
  DoctId = gDB.ValField(rs.Fields, cscDoctId)
  infodoc = gDB.ValField(rs.Fields, "info_doc")
  
  sqlstmt = "sp_PartesDiarioGetForDoc " & gDB.UserId & "," & EmpId & "," & DoctId & "," & GarId
  ShowNotes LNGGetText(2476, vbNullString, infodoc), sqlstmt
            'Notas sobre Garantía & infodoc
End Sub

Private Sub pAddMensaje()
  Dim Parte As Object
  Set Parte = CSKernelClient2.CreateObject("CSEnvio2.cParteDiario")
  
  Parte.AddParteToDoc csNO_ID, m_ObjList.ID, False
End Sub
