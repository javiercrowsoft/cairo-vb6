VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cLiquidacionListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient
'--------------------------------------------------------------------------------
' cLiquidacionListDoc
' 03-10-2008

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cLiquidacionListDoc"

Private Const c_FechaIni = "FechaIni"
Private Const c_FechaFin = "FechaFin"

Private Const c_img_task = 1

Private Const K_FECHADESDE                      As Integer = 1
Private Const K_FECHAHASTA                      As Integer = 2
Private Const K_CCOS_ID                         As Integer = 4
Private Const K_EM_ID                           As Integer = 5
Private Const K_EST_ID                          As Integer = 6
Private Const K_SUC_ID                          As Integer = 7
Private Const K_DOC_ID                          As Integer = 9
' empid
Private Const K_EMP_ID                          As Integer = 100

' Seudo - Variables
Private c_strLoad                         As String
Private c_ErrorSave                       As String

' estructuras
' variables privadas

Private m_FechaDesdeV                     As String
Private m_FechaHastaV                     As String

Private m_fechaDesde                      As Date
Private m_fechaHasta                      As Date

Private m_ccos_id                         As String
Private m_CentroCosto                     As String
Private m_em_id                           As String
Private m_Empleado                        As String
Private m_est_id                          As String
Private m_Estado                          As String
Private m_suc_id                          As String
Private m_Sucursal                        As String
Private m_doc_id                          As String
Private m_Documento                       As String
' empid
Private m_emp_id                          As String
Private m_Empresa                         As String

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
        m_fechaDesde = VDGetDateByName(m_FechaDesdeV)
      ElseIf IsDate(iProp.Value) Then
        m_FechaDesdeV = vbNullString
        m_fechaDesde = iProp.Value
      Else
        m_FechaDesdeV = vbNullString
        iProp.Value = m_fechaDesde
      End If

    Case K_FECHAHASTA
      
      Set iProp = m_ObjAbm.Properties(c_FechaFin)
      
      If LenB(iProp.HelpValueProcess) Then
        m_FechaHastaV = iProp.HelpValueProcess
        m_fechaHasta = VDGetDateByName(m_FechaHastaV)
      ElseIf IsDate(iProp.Value) Then
        m_FechaHastaV = vbNullString
        m_fechaHasta = iProp.Value
      Else
        m_FechaHastaV = vbNullString
        iProp.Value = m_fechaHasta
      End If
      
  End Select

  cIABMListDocClient_PropertyChange = True
End Function

Private Function cIABMListDocClient_Refresh() As String
  Dim sqlstmt As String

  pValidateFilters

  sqlstmt = "sp_lsdoc_Liquidaciones "

  sqlstmt = sqlstmt & gDB.UserId & ","
    
  If Not DateNames(m_FechaDesdeV) Is Nothing Then
    sqlstmt = sqlstmt & gDB.sqlDate(VDGetDateByName(m_FechaDesdeV)) & ","
  Else
    sqlstmt = sqlstmt & gDB.sqlDate(m_fechaDesde) & ","
  End If
  
  If Not DateNames(m_FechaHastaV) Is Nothing Then
    sqlstmt = sqlstmt & gDB.sqlDate(VDGetDateByName(m_FechaHastaV)) & ","
  Else
    sqlstmt = sqlstmt & gDB.sqlDate(m_fechaHasta) & ","
  End If
    
  sqlstmt = sqlstmt & gDB.sqlString(m_ccos_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_em_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_est_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_suc_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_doc_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_emp_id)
  
  cIABMListDocClient_Refresh = sqlstmt
End Function

Private Sub pValidateFilters()
  
  If LenB(m_ccos_id) And m_ccos_id <> "0" Then Exit Sub
  If LenB(m_em_id) And m_em_id <> "0" Then Exit Sub
  
  Dim fdesde As Date
  Dim fhasta As Date
  
  If Not DateNames(m_FechaDesdeV) Is Nothing Then
    fdesde = VDGetDateByName(m_FechaDesdeV)
  Else
    fdesde = m_fechaDesde
  End If
  
  If Not DateNames(m_FechaHastaV) Is Nothing Then
    fhasta = VDGetDateByName(m_FechaHastaV)
  Else
    fhasta = m_fechaHasta
  End If
  
  If DateDiff("m", fdesde, fhasta) <= 6 Then Exit Sub
  
  If Not Ask(LNGGetText(3664, vbNullString), vbNo) Then
    m_ccos_id = -1
  End If

End Sub

Private Function cIABMListDocClient_Save() As Boolean
  Dim register As cRegister
  Set register = New cRegister

  Dim sqlstmt As String
  sqlstmt = "delete ListaDocumentoParametro " & _
            " where pre_id = " & csPrepListLiquidacion & _
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
                            
        Case K_CCOS_ID
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 40, csInteger
          register.fields.Add2 cscLdpId, K_CCOS_ID, csInteger
                    
        Case K_EM_ID
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 50, csInteger
          register.fields.Add2 cscLdpId, K_EM_ID, csInteger
                    
        Case K_EST_ID
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 60, csInteger
          register.fields.Add2 cscLdpId, K_EST_ID, csInteger
                    
        Case K_SUC_ID
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 70, csInteger
          register.fields.Add2 cscLdpId, K_SUC_ID, csInteger
                    
        Case K_DOC_ID
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 80, csInteger
          register.fields.Add2 cscLdpId, K_DOC_ID, csInteger
                    
        Case K_EMP_ID
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 90, csInteger
          register.fields.Add2 cscLdpId, K_EMP_ID, csInteger
                    
      End Select
      
      register.fields.Add2 cscUsId, m_Us_id, csId
      register.fields.Add2 cscPreID, csPrepListLiquidacion, csId

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
  cIABMListDocClient_Title = LNGGetText(4604, vbNullString) 'Liquidaciones de Haberes
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

  With m_ObjAbm.Properties
    
    .Clear
    
    Set c = .Add(Nothing, c_FechaIni)
    c.PropertyType = cspDate
    c.Name = LNGGetText(1203, vbNullString) 'Fecha Desde
    c.Key = K_FECHADESDE
    If LenB(m_FechaDesdeV) Then
      c.Value = m_FechaDesdeV
    Else
      c.Value = m_fechaDesde
    End If
    
  
    Set c = .Add(Nothing, c_FechaFin)
    c.PropertyType = cspDate
    c.Name = LNGGetText(1204, vbNullString) 'Fecha Hasta
    c.Key = K_FECHAHASTA
    If LenB(m_FechaHastaV) Then
      c.Value = m_FechaHastaV
    Else
      c.Value = m_fechaHasta
    End If
      
    Set c = .Add(Nothing, cscCcosId)
    c.PropertyType = cspHelp
    c.Table = csCentroCosto
    c.Name = LNGGetText(1057, vbNullString) 'Centro de Costo
    c.Key = K_CCOS_ID
    Value = m_CentroCosto
    If UCase(Left$(m_ccos_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csCentroCosto, Val(Mid(m_ccos_id, 2)), bExists)
      If Not bExists Then m_ccos_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_ccos_id)
    c.HelpValueProcess = m_ccos_id
  
    Set c = .Add(Nothing, cscEmId)
    c.PropertyType = cspHelp
    c.Table = csEmpleado
    c.Name = LNGGetText(4555, vbNullString) 'Empleado
    c.Key = K_EM_ID
    Value = m_Empleado
    If UCase(Left$(m_em_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csEmpleado, Val(Mid(m_em_id, 2)), bExists)
      If Not bExists Then m_em_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_em_id)
    c.HelpValueProcess = m_em_id

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
        
    Set c = .Add(Nothing, cscSucId)
    c.PropertyType = cspHelp
    c.Table = csSucursal
    c.Name = LNGGetText(1281, vbNullString)   'Sucursal
    c.Key = K_SUC_ID
    Value = m_Sucursal
    If UCase(Left$(m_suc_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csSucursal, Val(Mid(m_suc_id, 2)), bExists)
      If Not bExists Then m_suc_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_suc_id)
    c.HelpValueProcess = m_suc_id
        
    Set c = .Add(Nothing, cscDocId)
    c.PropertyType = cspHelp
    c.Table = csETablasDocumento.CSDocumento
    c.Name = LNGGetText(1611, vbNullString)   'Documentos
    c.Key = K_DOC_ID
    Value = m_Documento
    If UCase(Left$(m_doc_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csETablasDocumento.CSDocumento, Val(Mid(m_doc_id, 2)), bExists)
      If Not bExists Then m_doc_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_doc_id)
    c.HelpValueProcess = m_doc_id
    c.HelpFilter = pGetDocFilter
        
    ' empid
    Set c = .Add(Nothing, cscEmpId)
    c.PropertyType = cspHelp
    c.Table = csEmpresa
    c.Name = LNGGetText(1114, vbNullString)   'Empresa
    c.Key = K_EMP_ID
    Value = m_Empresa
    If UCase(Left$(m_emp_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csEmpresa, Val(Mid(m_emp_id, 2)), bExists)
      If Not bExists Then m_emp_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_emp_id)
    c.HelpValueProcess = m_emp_id
  
  End With

  pCreateMenu
  If Not m_ObjAbm.Show(Me, m_ObjList) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal us_id As Long) As Boolean
  Dim sqlstmt As String

  sqlstmt = "select * from ListaDocumentoParametro " & _
            " where us_id = " & us_id & _
              " and pre_id = " & csPrepListLiquidacion & _
            " order by " & cscLdpOrden

  Dim rs As ADODB.Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If rs.EOF Then
    
    m_fechaDesde = Date
    m_fechaHasta = Date
    m_FechaDesdeV = vbNullString
    m_FechaHastaV = vbNullString
    m_ccos_id = vbNullString
    m_CentroCosto = vbNullString
    m_em_id = vbNullString
    m_Empleado = vbNullString
  
  Else

    rs.MoveLast
    rs.MoveFirst
    
    Dim i As Integer
    While Not rs.EOF

      Select Case gDB.ValField(rs.fields, cscLdpId)

        Case K_FECHADESDE
          m_FechaDesdeV = gDB.ValField(rs.fields, cscLdpValor)
          m_fechaDesde = IIf(IsDate(gDB.ValField(rs.fields, cscLdpValor)), gDB.ValField(rs.fields, cscLdpValor), Date)
        Case K_FECHAHASTA
          m_FechaHastaV = gDB.ValField(rs.fields, cscLdpValor)
          m_fechaHasta = IIf(IsDate(gDB.ValField(rs.fields, cscLdpValor)), gDB.ValField(rs.fields, cscLdpValor), Date)
        Case K_CCOS_ID
          m_ccos_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_EM_ID
          m_em_id = gDB.ValField(rs.fields, cscLdpValor)

      End Select

      rs.MoveNext
    Wend

    Dim Data As String

    If UCase(Left$(m_ccos_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTCentroCosto, cscCcosId, Val(m_ccos_id), cscCcosNombre, Data, C_LoadFunction, C_Module, c_strLoad) Then Exit Function
      m_CentroCosto = Data
    End If

    If UCase(Left$(m_em_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTEmpleado, cscEmId, Val(m_em_id), cscEmApellido, Data, C_LoadFunction, C_Module, c_strLoad) Then Exit Function
      m_Empleado = Data
      If Not gDB.GetData(csTEmpleado, cscEmId, Val(m_em_id), cscEmNombre, Data, C_LoadFunction, C_Module, c_strLoad) Then Exit Function
      m_Empleado = m_Empleado & ", " & Data
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
  Dim FvId    As Long
  Dim rs      As ADODB.Recordset
  
  FvId = m_ObjList.ID
  
  sqlstmt = "sp_ParteDiarioGetTitleForDoc " & csEDT_Liquidacion & "," & FvId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Dim infodoc As String
  Dim DoctId  As Long
  
  DoctId = gDB.ValField(rs.fields, cscDoctId)
  infodoc = gDB.ValField(rs.fields, "info_doc")
  
  sqlstmt = "sp_PartesDiarioGetForDoc " & gDB.UserId & "," & EmpId & "," & DoctId & "," & FvId
  ShowNotes "Notas sobre factura " & infodoc, sqlstmt
End Sub

Private Sub pAddMensaje()
  Dim Parte As Object
  Set Parte = CSKernelClient2.CreateObject("CSEnvio2.cParteDiario")
  
  Parte.AddParteToDoc csEDT_Liquidacion, m_ObjList.ID, False
End Sub

Private Function pGetEmpeIds() As Long()
  pGetEmpeIds = m_ObjList.SelectedItems
End Function

Private Function pGetDocFilter() As String
  pGetDocFilter = "'{emp_id=0}doct_id = " & csEDT_Liquidacion & _
                  " or doct_id = " & csEDT_NotaCreditoVenta & _
                  " or doct_id = " & csEDT_NotaDebitoVenta & "'"
End Function

' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_strLoad = LNGGetText(4605, vbNullString)
              'Error al cargar los parámetros de navegación de liquidaciones de haberes
  c_ErrorSave = LNGGetText(4606, vbNullString)
              'Error al grabar los párametros de navegación de liquidaciones de haberes
  
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


