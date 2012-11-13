VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cOrdenServicioListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient

'--------------------------------------------------------------------------------
' cOrdenServicioListDoc
' 18-11-2006
'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cOrdenServicioListDoc"

Private Const C_VM_ID = 0
Private Const C_VM_MENU_ID = 1
Private Const C_VM_IS_CONTADO = 2
Private Const C_VM_CUE_ID = 3

Private Const c_FechaIni = "FechaIni"
Private Const c_FechaFin = "FechaFin"

Private Const c_img_task = 1

' ACA VAN LAS K GENERADAS POR EL ASISTENTE.
Private Const K_FECHAINI                       As Integer = 1
Private Const K_FECHAFIN                       As Integer = 2
Private Const K_CLI_ID                         As Integer = 4
Private Const K_EST_ID                         As Integer = 5
Private Const K_CCOS_ID                        As Integer = 6
Private Const K_SUC_ID                         As Integer = 7
Private Const K_DOC_ID                         As Integer = 9
Private Const K_CPG_ID                         As Integer = 10
Private Const K_PRNS_ID                        As Integer = 11
' empid
Private Const K_EMP_ID                         As Integer = 100
' estructuras
' variables privadas
Private m_FechaIni                       As Date
Private m_FechaFin                       As Date
Private m_cli_id                         As String
Private m_Cliente                        As String
Private m_est_id                         As String
Private m_Estado                         As String
Private m_ccos_id                        As String
Private m_CentroCosto                    As String
Private m_suc_id                         As String
Private m_Sucursal                       As String
Private m_doc_id                         As String
Private m_Documento                      As String
Private m_cpg_id                         As String
Private m_CondicionPago                  As String
Private m_prns_id                        As String
Private m_ProductoNumeroSerie            As String
' empid
Private m_emp_id                         As String
Private m_Empresa                        As String
Private m_FechaIniV                      As String
Private m_FechaFinV                      As String

' ACA VAN LAS m_ GENERADAS POR EL ASISTENTE.

'OJO HASTA ACA

Private m_ObjAbm            As cIABMGenericListDoc
Private m_ObjList           As Object
Private m_us_id             As Long
Private m_Properties        As cABMDocProperties

Private m_Title             As String

Private m_MenuShowRemitoAuto  As Long
Private m_MenuShowRemito      As Long

Private m_MenuShowMensajes  As Long
Private m_MenuAddMensaje    As Long
Private m_MenuShowInfoCli   As Long
Private m_MenuShowAplic     As Long
Private m_MenuShowDocAux    As Long
Private m_MenuFirmar        As Long

Private m_vMenuModoPago()   As Long

Private m_ObjApply          As cOrdenServicioAplic

' Properties publicas
Public Property Get EnabledSearchParam() As Boolean
  EnabledSearchParam = True
End Property

Public Property Get SearchParamTable() As csTables
  SearchParamTable = csProductoSerie
End Property

Public Property Get BackgroundColor() As Long
  BackgroundColor = RGB(&HC8, &HF6, &HC1)
End Property

' Properties privadas
' funciones publicas
Public Function SetSearchParam(ByVal Id As Long, ByVal name As String)
  On Error Resume Next
  With m_ObjAbm.Properties.Item(cscPrnsId)
    .Value = name
    .HelpId = Id
    .HelpValueProcess = Id
  End With
  Dim AbmGen As cABMGenericListDoc
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValue m_ObjAbm.Properties.Item(cscPrnsId)
End Function

Public Function ProcessMenu(ByVal Index As Long)
  On Error GoTo ControlError

  Select Case Index
  
    Case m_MenuShowRemitoAuto
      pShowRemito True, False, False, csNO_ID, False
      
    Case m_MenuShowRemito
      pShowRemito False, False, False, csNO_ID, False
      
    Case m_MenuShowInfoCli
      HelpShowInfo csCliente, pGetCliId()
    
    Case m_MenuShowMensajes
      pShowMensajes
      
    Case m_MenuAddMensaje
      pAddMensaje
      
    Case m_MenuShowAplic
      pShowApply
    
    Case m_MenuShowDocAux
      pShowDocAux
      
    Case m_MenuFirmar
      pFirmar
  
    Case Else
      pProcessModoPago Index
  
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
    c.name = LNGGetText(1203, vbNullString) 'Fecha desde
    c.key = K_FECHAINI
    If LenB(m_FechaIniV) Then
      c.Value = m_FechaIniV
    Else
      c.Value = m_FechaIni
    End If
    
    Set c = .Add(Nothing, c_FechaFin)
    c.PropertyType = cspDate
    c.name = LNGGetText(1204, vbNullString) 'Fecha hasta
    c.key = K_FECHAFIN
    If LenB(m_FechaFinV) Then
      c.Value = m_FechaFinV
    Else
      c.Value = m_FechaFin
    End If
    
    Set c = .Add(Nothing, cscCliId)
    c.PropertyType = cspHelp
    c.table = csCliente
    c.name = LNGGetText(1150, vbNullString) 'Cliente
    c.key = K_CLI_ID
    Value = m_Cliente
    If UCase(Left$(m_cli_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csCliente, Val(Mid(m_cli_id, 2)), bExists)
      If Not bExists Then m_cli_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_cli_id)
    c.HelpValueProcess = m_cli_id
    
    Set c = .Add(Nothing, cscEstId)
    c.PropertyType = cspHelp
    c.table = csEstado
    c.name = LNGGetText(1568, vbNullString) 'Estado
    c.key = K_EST_ID
    Value = m_Estado
    If UCase(Left$(m_est_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csEstado, Val(Mid(m_est_id, 2)), bExists)
      If Not bExists Then m_est_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_est_id)
    c.HelpValueProcess = m_est_id
    
    Set c = .Add(Nothing, cscCcosId)
    c.PropertyType = cspHelp
    c.table = csCentroCosto
    c.name = LNGGetText(1057, vbNullString) 'Centro de Costos
    c.key = K_CCOS_ID
    Value = m_CentroCosto
    If UCase(Left$(m_ccos_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csCentroCosto, Val(Mid(m_ccos_id, 2)), bExists)
      If Not bExists Then m_ccos_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_ccos_id)
    c.HelpValueProcess = m_ccos_id
    
    Set c = .Add(Nothing, cscSucId)
    c.PropertyType = cspHelp
    c.table = csSucursal
    c.name = LNGGetText(1281, vbNullString) 'Sucursal
    c.key = K_SUC_ID
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
    c.table = csETablasDocumento.CSDocumento
    c.name = LNGGetText(1611, vbNullString) 'Documentos
    c.key = K_DOC_ID
    Value = m_Documento
    If UCase(Left$(m_doc_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csETablasDocumento.CSDocumento, Val(Mid(m_doc_id, 2)), bExists)
      If Not bExists Then m_doc_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_doc_id)
    c.HelpValueProcess = m_doc_id
    c.HelpFilter = pGetDocFilter
  
    Set c = .Add(Nothing, cscCpgId)
    c.PropertyType = cspHelp
    c.table = csCondicionPago
    c.name = LNGGetText(1395, vbNullString) 'Condicion de pago
    c.key = K_CPG_ID
    Value = m_CondicionPago
    If UCase(Left$(m_cpg_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csCondicionPago, Val(Mid(m_cpg_id, 2)), bExists)
      If Not bExists Then m_cpg_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_cpg_id)
    c.HelpValueProcess = m_cpg_id
    
    Set c = .Add(Nothing, cscPrnsId)
    c.PropertyType = cspHelp
    c.table = csProductoSerie
    c.name = LNGGetText(1820, vbNullString) 'Numero de Serie
    c.key = K_PRNS_ID
    Value = m_ProductoNumeroSerie
    If UCase(Left$(m_prns_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csProductoSerie, Val(Mid(m_prns_id, 2)), bExists)
      If Not bExists Then m_prns_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_prns_id)
    c.HelpValueProcess = m_prns_id
    
    ' empid
    Set c = .Add(Nothing, cscEmpId)
    c.PropertyType = cspHelp
    c.table = csEmpresa
    c.name = LNGGetText(1114, vbNullString) 'Empresa
    c.key = K_EMP_ID
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

Private Function Load(ByVal Us_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select * from ListaDocumentoParametro" & _
            " where us_id = " & Us_id & _
              " and pre_id = " & csPreTickListOrdenServ & _
              " and (emp_id is null or emp_id = " & EmpId & ")" & _
            " order by " & cscLdpOrden

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  ' empid
  m_emp_id = EmpId
  m_Empresa = EmpNombre
  
  If rs.EOF Then
    
    m_FechaIni = Date
    m_FechaFin = Date
    m_cli_id = csNO_ID
    m_Cliente = vbNullString
    m_est_id = csNO_ID
    m_Estado = vbNullString
    m_ccos_id = csNO_ID
    m_CentroCosto = vbNullString
    m_suc_id = csNO_ID
    m_Sucursal = vbNullString
    m_doc_id = csNO_ID
    m_Documento = vbNullString
    m_cpg_id = csNO_ID
    m_CondicionPago = vbNullString
    m_prns_id = csNO_ID
    m_ProductoNumeroSerie = vbNullString
    
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
        
        Case K_CLI_ID
          m_cli_id = gDB.ValField(rs.Fields, cscLdpValor)
        
        Case K_EST_ID
          m_est_id = gDB.ValField(rs.Fields, cscLdpValor)
        
        Case K_CCOS_ID
          m_ccos_id = gDB.ValField(rs.Fields, cscLdpValor)
        
        Case K_SUC_ID
          m_suc_id = gDB.ValField(rs.Fields, cscLdpValor)
      
        Case K_DOC_ID
          m_doc_id = gDB.ValField(rs.Fields, cscLdpValor)
        
        Case K_CPG_ID
          m_cpg_id = gDB.ValField(rs.Fields, cscLdpValor)
        
        Case K_PRNS_ID
          m_prns_id = gDB.ValField(rs.Fields, cscLdpValor)
      
        ' empid
        Case K_EMP_ID
          m_emp_id = gDB.ValField(rs.Fields, cscLdpValor)
      
      End Select

      rs.MoveNext
    Wend

    Dim Data As String
    Dim strLoad As String
    
    strLoad = LNGGetText(2295, vbNullString)
              'Error al cargar los parámetros de navegación de Orden de Servicio
              
    m_FechaIni = IIf(m_FechaIni <> csNoDate, m_FechaIni, Date)
    m_FechaFin = IIf(m_FechaFin <> csNoDate, m_FechaFin, Date)


' OJO: EL ASISTENTE ESTO LO HACE MAL, YA QUE EL CODIGO QUE GENERA NO SOPORTA ARBOLES
'      USEN ESTE CODIGO COMO EJ. OJO!!! CAMBIEN LOS NOMBRES DE LAS TABLAS Y LOS CAMPOS NOMBRES DE DICHAS TABLAS.
    If UCase(Left$(m_cli_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTCliente, cscCliId, Val(m_cli_id), cscCliNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Cliente = Data
    End If
    If UCase(Left$(m_est_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTEstado, cscEstId, Val(m_est_id), cscEstNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Estado = Data
    End If
    If UCase(Left$(m_ccos_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTCentroCosto, cscCcosId, Val(m_ccos_id), cscCcosNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_CentroCosto = Data
    End If
    If UCase(Left$(m_suc_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTSucursal, cscSucId, Val(m_suc_id), cscSucNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Sucursal = Data
    End If
    If UCase(Left$(m_doc_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTDocumento, cscDocId, Val(m_doc_id), cscDocNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Documento = Data
    End If
    If UCase(Left$(m_cpg_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTCondicionPago, cscCpgId, Val(m_cpg_id), cscCpgNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_CondicionPago = Data
    End If
    If UCase(Left$(m_prns_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTProductoNumeroSerie, cscPrnsId, Val(m_prns_id), cscPrnsCodigo, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_ProductoNumeroSerie = Data
    End If
    ' empid
    If UCase(Left$(m_emp_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTEmpresa, cscEmpId, Val(m_emp_id), cscEmpNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Empresa = Data
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
Private Function cIABMListDocClient_PropertyChange(ByVal key As Integer) As Boolean
  Dim iProp     As cIABMProperty
  
  With m_ObjAbm.Properties
    
    Select Case key
  
      Case K_FECHAINI
        
        Set iProp = .Item(c_FechaIni)
    
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
        
        Set iProp = .Item(c_FechaFin)
        
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
      
      Case K_EST_ID
        With .Item(cscEstId)
          m_Estado = .Value
          m_est_id = .HelpValueProcess
        End With
    
      Case K_CLI_ID
        With .Item(cscCliId)
          m_Cliente = .Value
          m_cli_id = .HelpValueProcess
        End With
      
      Case K_CCOS_ID
        With .Item(cscCcosId)
          m_CentroCosto = .Value
          m_ccos_id = .HelpValueProcess
        End With
        
      Case K_SUC_ID
        With .Item(cscSucId)
          m_Sucursal = .Value
          m_suc_id = .HelpValueProcess
        End With
        
      Case K_DOC_ID
        With .Item(cscDocId)
          m_Documento = .Value
          m_doc_id = .HelpValueProcess
        End With
        
      Case K_CPG_ID
        With .Item(cscCpgId)
          m_CondicionPago = .Value
          m_cpg_id = .HelpValueProcess
        End With
      
      Case K_PRNS_ID
        With .Item(cscPrnsId)
          m_ProductoNumeroSerie = .Value
          m_prns_id = .HelpValueProcess
        End With
      
      ' empid
      Case K_EMP_ID
        With .Item(cscEmpId)
          m_Empresa = .Value
          m_emp_id = .HelpValueProcess
        End With
    End Select
  End With
  
  cIABMListDocClient_PropertyChange = True
End Function

Private Function cIABMListDocClient_Refresh() As String
  Dim sqlstmt As String

  sqlstmt = "sp_lsdoc_OrdenesServicio "

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
  sqlstmt = sqlstmt & gDB.sqlString(m_ccos_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_suc_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_doc_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_cpg_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_prns_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_emp_id)

  cIABMListDocClient_Refresh = sqlstmt
End Function

Private Function cIABMListDocClient_Save() As Boolean

  Dim strError As String
  
  strError = LNGGetText(2291, vbNullString)
            'Error al grabar los párametros de navegación de Orden de Servicio

  Dim register As cRegister
  Set register = New cRegister

  Dim sqlstmt As String
  
  sqlstmt = "delete ListaDocumentoParametro" & _
            " where pre_id = " & csPreTickListOrdenServ & _
              " and us_id = " & m_us_id & _
              " and (emp_id is null or emp_id = " & EmpId & ")"

  If Not gDB.Execute(sqlstmt, "cIABMClient_Save", C_Module, strError) Then Exit Function

  register.table = csTListaDocumentoParametro
  register.UtilizaIdentity = True

  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties

    register.Fields.Clear

    With IProperty
      Select Case .key

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

        Case K_CLI_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 40, csInteger
            register.Fields.Add2 cscLdpId, K_CLI_ID, csInteger
        Case K_EST_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 50, csInteger
            register.Fields.Add2 cscLdpId, K_EST_ID, csInteger
        Case K_CCOS_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 60, csInteger
            register.Fields.Add2 cscLdpId, K_CCOS_ID, csInteger
        Case K_SUC_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 70, csInteger
            register.Fields.Add2 cscLdpId, K_SUC_ID, csInteger
        Case K_DOC_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 90, csInteger
            register.Fields.Add2 cscLdpId, K_DOC_ID, csInteger
        Case K_CPG_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 100, csInteger
            register.Fields.Add2 cscLdpId, K_CPG_ID, csInteger
        Case K_PRNS_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 100, csInteger
            register.Fields.Add2 cscLdpId, K_PRNS_ID, csInteger

        ' empid
        Case K_EMP_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 100, csInteger
            register.Fields.Add2 cscLdpId, K_EMP_ID, csInteger
      
      End Select
      
      ' empid
      register.Fields.Add2 cscEmpId, EmpId, csId
      
      register.Fields.Add2 cscUsId, m_us_id, csId
      register.Fields.Add2 cscPreID, csPreTickListOrdenServ, csId

      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
      If Not gDB.Save(register, , "cIABMClient_Save", C_Module, strError) Then Exit Function
    End With
  Next
  
  If Not Load(m_us_id) Then Exit Function

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

Private Function cIEditGenericListDoc_PropertyChange(ByVal key As Integer) As Boolean
End Function

Private Function cIEditGenericListDoc_ShowParams(ByVal Us_id As Long) As Boolean
  On Error GoTo ControlError
  
  If Us_id = csNO_ID Then Exit Function

  m_us_id = Us_id
  
  If Not Load(Us_id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  cIEditGenericListDoc_ShowParams = True
  Exit Function
ControlError:
  MngError Err, "cIEditGenericListDoc_ShowParams", C_Module, vbNullString
End Function

Private Function cIEditGenericListDoc_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Function pGetDocFilter() As String
  pGetDocFilter = "'{emp_id=0}doct_id = " & csEDT_OrdenServicio & _
                  " or doct_id = " & csEDT_DevolucionRemitoCpra & "'"
End Function

Private Sub pCreateMenu()
  On Error Resume Next

  With m_ObjList
    Set .ObjClientMenu = Me
    .ClearMenu
    
    pAddMenuModoPago
    
    m_MenuShowRemitoAuto = .AddMenu(LNGGetText(3953, vbNullString))   'Remitir Automatico
    m_MenuShowRemito = .AddMenu(LNGGetText(1612, vbNullString))   'Remitir
    .AddMenu "-"
    m_MenuFirmar = .AddMenu(LNGGetText(1594, vbNullString))       'Firmar
    .AddMenu "-"
    m_MenuShowInfoCli = .AddMenu(LNGGetText(1614, vbNullString))  'Ver Info del Cliente
    m_MenuAddMensaje = .AddMenu(LNGGetText(1615, vbNullString))   'Agregar Nota
    m_MenuShowMensajes = .AddMenu(LNGGetText(1616, vbNullString)) 'Ver Notas
    .AddMenu "-"
    m_MenuShowAplic = .AddMenu(LNGGetText(1617, vbNullString))    'Ver Aplicaciones
    m_MenuShowDocAux = .AddMenu(LNGGetText(1691, vbNullString))   'Ver Documento Asociado
  End With
End Sub

' Presenta opciones de menu que generan una
' factura automatica desde uno o mas pedidos
' sin preguntar por los medios de pago
' ya que la cuenta esta definida en
' el modo de venta
'
Private Sub pAddMenuModoPago()
  Dim i As Long
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  ReDim Preserve m_vMenuModoPago(3, 0)
  
  sqlstmt = "select * from VentaModo where vm_os <> 0 order by vm_codigo"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  With m_ObjList
    
    .AddMenu "-"
    .AddMenu "-"
    
    While Not rs.EOF
      
      ReDim Preserve m_vMenuModoPago(3, UBound(m_vMenuModoPago, 1) + 1)
      i = i + 1
      m_vMenuModoPago(C_VM_ID, i) = gDB.ValField(rs.Fields, "vm_id")
      m_vMenuModoPago(C_VM_MENU_ID, i) = .AddMenu(gDB.ValField(rs.Fields, "vm_nombre"))
      m_vMenuModoPago(C_VM_IS_CONTADO, i) = gDB.ValField(rs.Fields, "vm_ctacte") <> csE_VentaModoCtaCte.csVM_CtaCteHojaRuta
      m_vMenuModoPago(C_VM_CUE_ID, i) = gDB.ValField(rs.Fields, "cue_id")
    
      .AddMenu "-"
      .AddMenu "-"
    
      rs.MoveNext
    Wend
  End With
End Sub

Private Sub pProcessModoPago(ByVal idMenu As Long)
  Dim i As Long
  For i = 1 To UBound(m_vMenuModoPago, 2)
    If m_vMenuModoPago(C_VM_MENU_ID, i) = idMenu Then
      
      If m_vMenuModoPago(C_VM_IS_CONTADO, i) Then
        pShowRemito True, True, True, m_vMenuModoPago(C_VM_CUE_ID, i), False
      Else
        pShowRemito True, True, False, csNO_ID, True
      End If
    End If
  Next
End Sub

Private Sub pShowMensajes()
  Dim sqlstmt As String
  Dim OsId    As Long
  Dim rs      As ADODB.Recordset
  
  OsId = m_ObjList.Id
  
  sqlstmt = "sp_ParteDiarioGetTitleForDoc " & csEDT_OrdenServicio & "," & OsId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Dim infodoc As String
  Dim DoctId  As Long
  
  DoctId = gDB.ValField(rs.Fields, cscDoctId)
  infodoc = gDB.ValField(rs.Fields, "info_doc")
  
  sqlstmt = "sp_PartesDiarioGetForDoc " & gDB.UserId & "," & EmpId & "," & DoctId & "," & OsId
  ShowNotes LNGGetText(1842, vbNullString, infodoc), sqlstmt
          'Notas sobre Orden de Servicio (1) & infodoc, sqlstmt
End Sub

Private Sub pAddMensaje()
  Dim Parte As Object
  Set Parte = CSKernelClient2.CreateObject("CSEnvio2.cParteDiario")
  
  Parte.AddParteToDoc csEDT_OrdenServicio, m_ObjList.Id, False
End Sub

Private Sub pFirmar()
  
  Dim OsId As Long
  OsId = m_ObjList.Id
  
  If OsId = csNO_ID Then Exit Sub
  
  Dim Firmado As Boolean
  Dim DocId   As Long
  
  If Not gDB.GetData(csTOrdenServicio, cscOsId, OsId, cscOsFirmado, Firmado) Then Exit Sub
  If Not gDB.GetData(csTOrdenServicio, cscOsId, OsId, cscDocId, DocId) Then Exit Sub

  If Firmado Then
    If Not Ask(LNGGetText(1593, vbNullString), vbYes, LNGGetText(1594, vbNullString)) Then
                'El documento ya ha sido firmado desea borrar la firma, vbYes, Firmar
      Exit Sub
    End If
  End If

  Dim Doc     As cDocumento
  Dim Us_id   As Long
  
  Set Doc = New cDocumento
  
  If Not Doc.Firmar(DocId, Us_id) Then Exit Sub
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocOrdenServicioFirmar " & OsId & "," & Us_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  m_ObjList.sqlstmt = "sp_lsdoc_OrdenServicio"
  
  m_ObjList.RefreshLine OsId
  
End Sub

Private Sub pShowDocAux()
  
  Dim OsId As Long
  OsId = m_ObjList.Id
  
  If OsId Then
  
    Dim StId As Long
    If Not gDB.GetData(csTOrdenServicio, cscOsId, OsId, cscStId, StId) Then Exit Sub
    
    If StId = csNO_ID Then
    
      MsgInfo LNGGetText(1693, vbNullString)
            'Este comprobante no tiene un documento de stock asociado.
    Else
    
      ShowDocAux StId, _
                 "CSStock2.cStock", _
                 "CSABMInterface2.cABMGeneric"
    End If
  End If

End Sub

Private Sub pShowApply()

  Dim OsId As Long
  OsId = m_ObjList.Id
  
  If OsId = csNO_ID Then Exit Sub

  Dim Total     As Double
  Dim Cotiz     As Double
  Dim NroDoc    As String
  Dim CliId     As Long
  Dim Cliente   As String
  Dim SucId     As Long
  Dim DocId     As Long
  Dim DoctId    As Long
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select os_total, os_cotizacion, os_nrodoc, os.cli_id, cli_nombre, " & _
            "os.suc_id, os.doc_id, os.doct_id" & _
            " from OrdenServicio os inner join Cliente cli" & _
                           " on os.cli_id = cli.cli_id" & _
            " where os_id = " & OsId
                   
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Total = gDB.ValField(rs.Fields, cscOsTotal)
  Cotiz = gDB.ValField(rs.Fields, cscOsCotizacion)
  NroDoc = gDB.ValField(rs.Fields, cscOsNrodoc)
  CliId = gDB.ValField(rs.Fields, cscCliId)
  Cliente = gDB.ValField(rs.Fields, cscCliNombre)
  SucId = gDB.ValField(rs.Fields, cscSucId)
  DocId = gDB.ValField(rs.Fields, cscDocId)
  DoctId = gDB.ValField(rs.Fields, cscDoctId)

  If Not DocSecurityCanAccess(csPreVtaModifyAplic, _
                              m_doc_id, _
                              csEDocTPreAplicar) Then Exit Sub
  
  If m_ObjApply Is Nothing Then
    Set m_ObjApply = New cOrdenServicioAplic
    
  
  ' Edit Apply
  '
  Else
    If m_ObjApply.Id <> OsId Then
      Set m_ObjApply = New cOrdenServicioAplic
    End If
  End If
  
  If Not m_ObjApply.Show(OsId, _
                         Total * IIf( _
                                 Cotiz <> 0, Cotiz, 1 _
                                        ), _
                         NroDoc, _
                         CliId, _
                         Cliente, _
                         SucId, _
                         DocId) Then
    Set m_ObjApply = Nothing
  End If
                  
End Sub

Private Sub pShowRemito(ByVal bPushVirtualNext As Boolean, _
                        ByVal bAutoFactura As Boolean, _
                        ByVal bAutoPago As Boolean, _
                        ByVal cue_id As Long, _
                        ByVal bModoVentaCtaCte As Boolean)
  On Error GoTo ControlError

  Dim o As Object
  Set o = CSKernelClient2.CreateObject("CSVenta2.cRemitoVenta")
  o.PushVirtualNext = bPushVirtualNext
  
  If bPushVirtualNext Then
    o.AutoFactura = bAutoFactura
    o.AutoPago = bAutoPago
    o.ModoVentaCtaCte = bModoVentaCtaCte
    o.cue_id_autoPago = cue_id
    o.ShowRemitoOrdenAuto pGetCliId(), pGetOsIds(), pGetPrnsIds()
  Else
    o.ShowRemitoOrden pGetCliId(), pGetOsIds()
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "pShowRemito", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetCliId() As Long
  On Error Resume Next
  
  Dim OsId    As Long
  Dim CliId   As Long
  Dim vIds()  As Long
  
  vIds = pGetOsIds()
  
  If UBound(vIds) > 0 Then
  
    OsId = vIds(0)
    
  Else
  
    OsId = m_ObjList.Id
    
  End If
  
  gDB.GetData csTOrdenServicio, cscOsId, OsId, cscCliId, CliId
  
  pGetCliId = CliId
End Function

Private Function pGetOsIds() As Long()
  pGetOsIds = m_ObjList.SelectedItems
End Function

Private Function pGetPrnsIds() As Long()
  pGetPrnsIds = m_ObjList.SelectedItemsLongColumn(cscPrnsId)
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
 
  m_Title = LNGGetText(1830, vbNullString) 'Ordenes de Servicio
 
  Set m_Properties = New cABMDocProperties
  With m_Properties
    'Set .ImageList = fResource.iList
    .HaveDetail = True
    .StartRowText = 4
    
    With .Columns.Add(Nothing, "TypeTask")
      .name = "TypeTask"
      .Caption = " "
      With .Icons.Add(Nothing)
      .FormulaType = csCondTNone
      .IconIndex = c_img_task
      End With
      .Width = 500
      .SortType = csSrtTIcon
    End With
    
    With .Columns.Add(Nothing, "Observaciones")
      .name = "Observaciones"
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
