VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCajaListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient

'--------------------------------------------------------------------------------
' cCajaListDoc
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
Private Const C_Module = "cCajaListDoc"

Private Const c_FechaIni = "FechaIni"
Private Const c_FechaFin = "FechaFin"

Private Const c_img_task = 1

Private Const K_FECHAINI                       As Integer = 1
Private Const K_FECHAFIN                       As Integer = 2
Private Const K_NRODOC                         As Integer = 3
Private Const K_CJ_ID                          As Integer = 5
Private Const K_SUC_ID                         As Integer = 6
Private Const K_US_ID_CAJERO                   As Integer = 7

' empid
Private Const K_EMP_ID                         As Integer = 100


' Seudo - Variables
Private c_strTitle    As String '= "Cajas"

' estructuras
' variables privadas
Private m_FechaIniV                      As String
Private m_FechaFinV                      As String

Private m_FechaIni                       As Date
Private m_FechaFin                       As Date

Private m_Nrodoc                         As String
Private m_cj_id                          As String
Private m_Caja                           As String
Private m_suc_id                         As String
Private m_Sucursal                       As String
Private m_us_id_cajero                   As String
Private m_Cajero                         As String

' empid
Private m_emp_id                         As String
Private m_Empresa                        As String

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
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscMcjNrodoc)
  c.PropertyType = cspText
  c.Name = LNGGetText(1065, vbNullString) 'Numero
  c.Size = 255
  c.Key = K_NRODOC
  c.Value = m_Nrodoc
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCjId)
  c.PropertyType = cspHelp
  c.Table = csCaja
  c.Name = LNGGetText(3497, vbNullString) 'Caja
  c.Key = K_CJ_ID
  Value = m_Caja
  If UCase(Left$(m_cj_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csCaja, Val(Mid(m_cj_id, 2)), bExists)
    If Not bExists Then m_cj_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_cj_id)
  c.HelpValueProcess = m_cj_id
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscSucId)
  c.PropertyType = cspHelp
  c.Table = csSucursal
  c.Name = LNGGetText(1281, vbNullString) 'Sucursal
  c.Key = K_SUC_ID
  Value = m_Sucursal
  If UCase(Left$(m_suc_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csSucursal, Val(Mid(m_suc_id, 2)), bExists)
    If Not bExists Then m_suc_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_suc_id)
  c.HelpValueProcess = m_suc_id
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscUsIdCajero)
  c.PropertyType = cspHelp
  c.Table = csUsuario
  c.Name = LNGGetText(4716, vbNullString) 'Cajero
  c.Key = K_US_ID_CAJERO
  Value = m_Cajero
  If UCase(Left$(m_us_id_cajero, 1)) = KEY_NODO Then
    Value = GetNombreRama(csUsuario, Val(Mid(m_us_id_cajero, 2)), bExists)
    If Not bExists Then m_us_id_cajero = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_us_id_cajero)
  c.HelpValueProcess = m_us_id_cajero
  c.HelpFilter = "exists(select * from CajaCajero where us_id = Usuario.us_id)"
  
  ' empid
  Set c = m_ObjAbm.Properties.Add(Nothing, cscEmpId)
  c.PropertyType = cspHelp
  c.Table = csEmpresa
  c.Name = LNGGetText(1114, vbNullString)    'Empresa
  c.Key = K_EMP_ID
  Value = m_Empresa
  If UCase(Left$(m_emp_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csEmpresa, Val(Mid(m_emp_id, 2)), bExists)
    If Not bExists Then m_emp_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_emp_id)
  c.HelpValueProcess = m_emp_id
  
  pCreateMenu
  If Not m_ObjAbm.Show(Me, m_ObjList) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal us_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select * from ListaDocumentoParametro" & _
            " where us_id = " & us_id & _
              " and pre_id = " & csPreVtaListCaja & _
              " and (emp_id is null or emp_id = " & EmpId & ")" & _
            " order by " & cscLdpOrden

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  ' empid
  m_emp_id = EmpId
  m_Empresa = EmpNombre

  If rs.EOF Then
    
    m_FechaIni = Date
    m_FechaFin = Date
    m_FechaIniV = vbNullString
    m_FechaFinV = vbNullString
    m_Nrodoc = vbNullString
    m_cj_id = csNO_ID
    m_Caja = vbNullString
    m_suc_id = csNO_ID
    m_Sucursal = vbNullString
    m_us_id_cajero = csNO_ID
    m_Cajero = vbNullString
    
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
        Case K_NRODOC
          m_Nrodoc = gDB.ValField(rs.fields, cscLdpValor)
        Case K_CJ_ID
          m_cj_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_SUC_ID
          m_suc_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_US_ID_CAJERO
          m_us_id_cajero = gDB.ValField(rs.fields, cscLdpValor)
        
        ' empid
        Case K_EMP_ID
          m_emp_id = gDB.ValField(rs.fields, cscLdpValor)
      End Select

      rs.MoveNext
    Wend

    Dim Data As String
    Dim strLoad As String
    
    strLoad = LNGGetText(4717, vbNullString)
              'Error al cargar los parámetros de navegación de cajas
    
    m_FechaIni = IIf(m_FechaIni <> csNoDate, m_FechaIni, Date)
    m_FechaFin = IIf(m_FechaFin <> csNoDate, m_FechaFin, Date)

    If UCase(Left$(m_cj_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTCaja, cscCjId, Val(m_cj_id), cscCjNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Caja = Data
    End If

    If UCase(Left$(m_suc_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTSucursal, cscSucId, Val(m_suc_id), cscSucNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Sucursal = Data
    End If

    If UCase(Left$(m_cj_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTusuario, cscUsId, Val(m_us_id_cajero), cscUsNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Cajero = Data
    End If

    ' empid
    If UCase(Left$(m_emp_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTEmpresa, cscEmpId, Val(m_emp_id), cscEmpNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Empresa = Data
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
  
    Case K_CJ_ID
      With m_ObjAbm.Properties(cscCjId)
        m_Caja = .Value
        m_cj_id = .HelpValueProcess
      End With

    Case K_SUC_ID
      With m_ObjAbm.Properties(cscSucId)
        m_Sucursal = .Value
        m_suc_id = .HelpValueProcess
      End With

    Case K_US_ID_CAJERO
      With m_ObjAbm.Properties(cscUsIdCajero)
        m_Cajero = .Value
        m_us_id_cajero = .HelpValueProcess
      End With

    Case K_NRODOC
      m_Nrodoc = m_ObjAbm.Properties(cscMcjNrodoc).Value
  
    ' empid
    Case K_EMP_ID
      With m_ObjAbm.Properties(cscEmpId)
        m_Empresa = .Value
        m_emp_id = .HelpValueProcess
      End With
  
  End Select

  cIABMListDocClient_PropertyChange = True
End Function

Private Function cIABMListDocClient_Refresh() As String
  Dim sqlstmt As String

  sqlstmt = "sp_lsdoc_Cajas "

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

  sqlstmt = sqlstmt & gDB.sqlString(m_Nrodoc) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_cj_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_suc_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_us_id_cajero) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_emp_id)

  cIABMListDocClient_Refresh = sqlstmt
End Function

Private Function cIABMListDocClient_Save() As Boolean

  Dim strError As String
  
  strError = LNGGetText(4718, vbNullString)
              'Error al grabar los párametros de navegación de cajas
          
  Dim register As cRegister
  Set register = New cRegister

  Dim sqlstmt As String
  
  sqlstmt = "delete ListaDocumentoParametro " & _
            " where pre_id = " & csPreVtaListCaja & _
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
          
          If LenB(.HelpValueProcess) Then
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          Else
            register.fields.Add2 cscLdpValor, .Value, csText
          End If
          
          register.fields.Add2 cscLdpOrden, 10, csInteger
          register.fields.Add2 cscLdpId, K_FECHAINI, csInteger

        Case K_FECHAFIN

          If LenB(.HelpValueProcess) Then
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          Else
            register.fields.Add2 cscLdpValor, .Value, csText
          End If

          register.fields.Add2 cscLdpOrden, 20, csInteger
          register.fields.Add2 cscLdpId, K_FECHAFIN, csInteger

        Case K_NRODOC
          register.fields.Add2 cscLdpValor, .Value, csText
          register.fields.Add2 cscLdpOrden, 30, csInteger
          register.fields.Add2 cscLdpId, K_NRODOC, csInteger
        
        Case K_CJ_ID
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 40, csInteger
          register.fields.Add2 cscLdpId, K_CJ_ID, csInteger
                
        Case K_SUC_ID
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 50, csInteger
          register.fields.Add2 cscLdpId, K_SUC_ID, csInteger
                
        Case K_US_ID_CAJERO
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 60, csInteger
          register.fields.Add2 cscLdpId, K_US_ID_CAJERO, csInteger
            
        ' empid
        Case K_EMP_ID
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.fields.Add2 cscLdpOrden, 100, csInteger
            register.fields.Add2 cscLdpId, K_EMP_ID, csInteger
            
      End Select
      
      ' empid
      register.fields.Add2 cscEmpId, EmpId, csId
      
      register.fields.Add2 cscUsId, m_Us_id, csId
      register.fields.Add2 cscPreID, csPreVtaListCaja, csId

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
 
  c_strTitle = LNGGetText(4719, vbNullString)   'Cajas
 
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
  Dim McjId   As Long
  Dim rs      As ADODB.Recordset
  
  McjId = m_ObjList.id
  
  sqlstmt = "sp_ParteDiarioGetTitleForDoc " & csNO_ID & "," & McjId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Dim infodoc As String
  Dim DoctId  As Long
  
  DoctId = gDB.ValField(rs.fields, cscDoctId)
  infodoc = gDB.ValField(rs.fields, "info_doc")
  
  sqlstmt = "sp_PartesDiarioGetForDoc " & gDB.UserId & "," & EmpId & "," & DoctId & "," & McjId
  ShowNotes LNGGetText(4720, vbNullString, infodoc), sqlstmt
            'Notas sobre caja & infodoc
End Sub

Private Sub pAddMensaje()
  Dim Parte As Object
  Set Parte = CSKernelClient2.CreateObject("CSEnvio2.cParteDiario")
  
  Parte.AddParteToDoc csNO_ID, m_ObjList.id, False
End Sub
