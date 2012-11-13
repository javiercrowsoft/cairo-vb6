VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFacturaVtaListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient

'--------------------------------------------------------------------------------
' cFacturaVtaListDoc
' 03-01-04
'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cFacturaVtaListDoc"

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
Private Const K_VEN_ID                         As Integer = 8
Private Const K_DOC_ID                         As Integer = 9
Private Const K_CPG_ID                         As Integer = 10
' empid
Private Const K_EMP_ID                         As Integer = 100
' estructuras
' variables privadas
Private m_FechaIni                       As Date
Private m_FechaFin                       As Date
Private m_cli_id                         As String
Private m_cliente                        As String
Private m_est_id                         As String
Private m_Estado                         As String
Private m_ccos_id                        As String
Private m_CentroCosto                    As String
Private m_suc_id                         As String
Private m_Sucursal                       As String
Private m_ven_id                         As String
Private m_vendedor                       As String
Private m_doc_id                         As String
Private m_Documento                      As String
Private m_cpg_id                         As String
Private m_CondicionPago                  As String
' empid
Private m_emp_id                         As String
Private m_Empresa                        As String
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

Private m_MenuShowCobranza  As Long
Private m_MenuShowMensajes  As Long
Private m_MenuShowInfoCli   As Long
Private m_MenuAddMensaje    As Long
Private m_MenuShowAplic     As Long
Private m_MenuShowAsiento   As Long
Private m_MenuShowDocAux    As Long
Private m_MenuFirmar        As Long
Private m_MenuEditCliente   As Long

Private m_MenuGetCae            As Long
Private m_MenuUpdateTalonarios  As Long
Private m_SendCAEByEmail        As Long

Private m_ObjApply          As cFacturaVentaAplic

' Properties publicas
Public Property Get EnabledSearchParam() As Boolean
  EnabledSearchParam = True
End Property

Public Property Get SearchParamTable() As csTables
  SearchParamTable = csCliente
End Property

Public Property Get BackgroundColor() As Long
  BackgroundColor = RGB(&HC1, &HC1, &HF6)
End Property
' Properties privadas
' funciones publicas
Public Function SetSearchParam(ByVal id As Long, ByVal name As String)
  On Error Resume Next
  With m_ObjAbm.Properties.Item(cscCliId)
    .Value = name
    .HelpId = id
    .HelpValueProcess = id
  End With
  Dim AbmGen As cABMGenericListDoc
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValue m_ObjAbm.Properties.Item(cscCliId)
End Function

Public Function ProcessMenu(ByVal Index As Long)
  On Error GoTo ControlError

  Select Case Index
    Case m_MenuShowCobranza
      pShowCobranza
    
    Case m_MenuShowInfoCli
      HelpShowInfo csCliente, pGetCliId()
    
    Case m_MenuShowMensajes
      pShowMensajes
      
    Case m_MenuAddMensaje
      pAddMensaje
      
    Case m_MenuShowAplic
      pShowApply
    
    Case m_MenuShowAsiento
      pShowAsiento
      
    Case m_MenuShowDocAux
      pShowDocAux
      
    Case m_MenuFirmar
      pFirmar
      
    Case m_MenuEditCliente
      pEditCliente
      
    Case m_MenuGetCae
      pGetCAE
      
    Case m_MenuUpdateTalonarios
      pUpdateTalonariosAFIP
      
    Case m_SendCAEByEmail
      pSendCAEByEmail
      
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
    c.name = LNGGetText(1203, vbNullString)   'Fecha desde
    c.Key = K_FECHAINI
    If m_FechaIniV <> vbNullString Then
      c.Value = m_FechaIniV
    Else
      c.Value = m_FechaIni
    End If
  
    Set c = .Add(Nothing, c_FechaFin)
    c.PropertyType = cspDate
    c.name = LNGGetText(1204, vbNullString)   'Fecha hasta
    c.Key = K_FECHAFIN
    If m_FechaFinV <> vbNullString Then
      c.Value = m_FechaFinV
    Else
      c.Value = m_FechaFin
    End If
    
    Set c = .Add(Nothing, cscCliId)
    c.PropertyType = cspHelp
    c.Table = csCliente
    c.name = LNGGetText(1150, vbNullString)   'Cliente
    c.Key = K_CLI_ID
    Value = m_cliente
    If UCase(left$(m_cli_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csCliente, Val(Mid(m_cli_id, 2)), bExists)
      If Not bExists Then m_cli_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_cli_id)
    c.HelpValueProcess = m_cli_id
    
    Set c = .Add(Nothing, cscEstId)
    c.PropertyType = cspHelp
    c.Table = csEstado
    c.name = LNGGetText(1568, vbNullString)   'Estado
    c.Key = K_EST_ID
    Value = m_Estado
    If UCase(left$(m_est_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csEstado, Val(Mid(m_est_id, 2)), bExists)
      If Not bExists Then m_est_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_est_id)
    c.HelpValueProcess = m_est_id
    
    Set c = .Add(Nothing, cscCcosId)
    c.PropertyType = cspHelp
    c.Table = csCentroCosto
    c.name = LNGGetText(1057, vbNullString)   'Centro de Costos
    c.Key = K_CCOS_ID
    Value = m_CentroCosto
    If UCase(left$(m_ccos_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csCentroCosto, Val(Mid(m_ccos_id, 2)), bExists)
      If Not bExists Then m_ccos_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_ccos_id)
    c.HelpValueProcess = m_ccos_id
    
    Set c = .Add(Nothing, cscSucId)
    c.PropertyType = cspHelp
    c.Table = csSucursal
    c.name = LNGGetText(1281, vbNullString)   'Sucursal
    c.Key = K_SUC_ID
    Value = m_Sucursal
    If UCase(left$(m_suc_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csSucursal, Val(Mid(m_suc_id, 2)), bExists)
      If Not bExists Then m_suc_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_suc_id)
    c.HelpValueProcess = m_suc_id
    
    Set c = .Add(Nothing, cscVenId)
    c.PropertyType = cspHelp
    c.Table = csVendedores
    c.name = LNGGetText(1510, vbNullString)   'Vendedor
    c.Key = K_VEN_ID
    Value = m_vendedor
    If UCase(left$(m_ven_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csVendedores, Val(Mid(m_ven_id, 2)), bExists)
      If Not bExists Then m_ven_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_ven_id)
    c.HelpValueProcess = m_ven_id
    
    Set c = .Add(Nothing, cscDocId)
    c.PropertyType = cspHelp
    c.Table = csETablasDocumento.CSDocumento
    c.name = LNGGetText(1611, vbNullString)   'Documentos
    c.Key = K_DOC_ID
    Value = m_Documento
    If UCase(left$(m_doc_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csETablasDocumento.CSDocumento, Val(Mid(m_doc_id, 2)), bExists)
      If Not bExists Then m_doc_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_doc_id)
    c.HelpValueProcess = m_doc_id
    c.HelpFilter = pGetDocFilter
    
    Set c = .Add(Nothing, cscCpgId)
    c.PropertyType = cspHelp
    c.Table = csCondicionPago
    c.name = LNGGetText(1395, vbNullString)   'Condicion de pago
    c.Key = K_CPG_ID
    Value = m_CondicionPago
    If UCase(left$(m_cpg_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csCondicionPago, Val(Mid(m_cpg_id, 2)), bExists)
      If Not bExists Then m_cpg_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_cpg_id)
    c.HelpValueProcess = m_cpg_id
    
    ' empid
    Set c = .Add(Nothing, cscEmpId)
    c.PropertyType = cspHelp
    c.Table = csEmpresa
    c.name = LNGGetText(1114, vbNullString)   'Empresa
    c.Key = K_EMP_ID
    Value = m_Empresa
    If UCase(left$(m_emp_id, 1)) = KEY_NODO Then
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
  Dim rs      As Recordset
  
  sqlstmt = "select * from ListaDocumentoParametro " & _
            " where us_id = " & us_id & _
            " and pre_id =" & csPreVtaListFactura & _
            " and (emp_id is null or emp_id = " & empId & ")" & _
            " order by " & cscLdpOrden

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  ' empid
  m_emp_id = empId
  m_Empresa = empNombre

  If rs.EOF Then
    
    m_FechaIni = Date
    m_FechaFin = Date
    m_cli_id = csNO_ID
    m_cliente = vbNullString
    m_est_id = csNO_ID
    m_Estado = vbNullString
    m_ccos_id = csNO_ID
    m_CentroCosto = vbNullString
    m_suc_id = csNO_ID
    m_Sucursal = vbNullString
    m_ven_id = csNO_ID
    m_vendedor = vbNullString
    m_doc_id = csNO_ID
    m_Documento = vbNullString
    m_cpg_id = csNO_ID
    m_CondicionPago = vbNullString
    
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
        
        Case K_CCOS_ID
          m_ccos_id = gDB.ValField(rs.fields, cscLdpValor)
        
        Case K_SUC_ID
          m_suc_id = gDB.ValField(rs.fields, cscLdpValor)
        
        Case K_VEN_ID
          m_ven_id = gDB.ValField(rs.fields, cscLdpValor)
        
        Case K_DOC_ID
          m_doc_id = gDB.ValField(rs.fields, cscLdpValor)
        
        Case K_CPG_ID
          m_cpg_id = gDB.ValField(rs.fields, cscLdpValor)
        
        ' empid
        Case K_EMP_ID
          m_emp_id = gDB.ValField(rs.fields, cscLdpValor)
      
      End Select

      rs.MoveNext
    Wend

    Dim Data As String
    Dim strLoad As String
    
    strLoad = LNGGetText(2226, vbNullString)
              'Error al carga los párametros de navegación de Facturas de Venta
    
    m_FechaIni = IIf(m_FechaIni <> csNoDate, m_FechaIni, Date)
    m_FechaFin = IIf(m_FechaFin <> csNoDate, m_FechaFin, Date)


' OJO: EL ASISTENTE ESTO LO HACE MAL, YA QUE EL CODIGO QUE GENERA NO SOPORTA ARBOLES
'      USEN ESTE CODIGO COMO EJ. OJO!!! CAMBIEN LOS NOMBRES DE LAS TABLAS Y LOS CAMPOS NOMBRES DE DICHAS TABLAS.
    If UCase(left$(m_cli_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTCliente, cscCliId, Val(m_cli_id), cscCliNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_cliente = Data
    End If
    If UCase(left$(m_est_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTEstado, cscEstId, Val(m_est_id), cscEstNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Estado = Data
    End If
    If UCase(left$(m_ccos_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTCentroCosto, cscCcosId, Val(m_ccos_id), cscCcosNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_CentroCosto = Data
    End If
    If UCase(left$(m_suc_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTSucursal, cscSucId, Val(m_suc_id), cscSucNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Sucursal = Data
    End If
    If UCase(left$(m_ven_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTVendedor, cscVenId, Val(m_ven_id), cscVenNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_vendedor = Data
    End If
    If UCase(left$(m_doc_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTDocumento, cscDocId, Val(m_doc_id), cscDocNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Documento = Data
    End If
    If UCase(left$(m_cpg_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTCondicionPago, cscCpgId, Val(m_cpg_id), cscCpgNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_CondicionPago = Data
    End If
    ' empid
    If UCase(left$(m_emp_id, 1)) <> KEY_NODO Then
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
        
      Case K_VEN_ID
        With .Item(cscVenId)
          m_vendedor = .Value
          m_ven_id = .HelpValueProcess
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

  sqlstmt = "sp_lsdoc_FacturasVenta "

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
  sqlstmt = sqlstmt & gDB.sqlString(m_ven_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_doc_id) & ","
                                              ' empid
  sqlstmt = sqlstmt & gDB.sqlString(m_cpg_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_emp_id)

  cIABMListDocClient_Refresh = sqlstmt
End Function

Private Function cIABMListDocClient_Save() As Boolean

  Dim strError As String
            
  strError = LNGGetText(2226, vbNullString)
              'Error al grabar los párametros de navegación de Facturas de Venta

  Dim register As cRegister
  Set register = New cRegister

  Dim sqlstmt As String
  
  sqlstmt = "delete ListaDocumentoParametro" & _
            " where pre_id = " & csPreVtaListFactura & _
              " and us_id = " & m_Us_id & _
              " and (emp_id is null or emp_id = " & empId & ")"
  
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
        Case K_CCOS_ID
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.fields.Add2 cscLdpOrden, 60, csInteger
            register.fields.Add2 cscLdpId, K_CCOS_ID, csInteger
        Case K_SUC_ID
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.fields.Add2 cscLdpOrden, 70, csInteger
            register.fields.Add2 cscLdpId, K_SUC_ID, csInteger
        Case K_VEN_ID
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.fields.Add2 cscLdpOrden, 80, csInteger
            register.fields.Add2 cscLdpId, K_VEN_ID, csInteger
        Case K_DOC_ID
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.fields.Add2 cscLdpOrden, 90, csInteger
            register.fields.Add2 cscLdpId, K_DOC_ID, csInteger
        Case K_CPG_ID
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.fields.Add2 cscLdpOrden, 100, csInteger
            register.fields.Add2 cscLdpId, K_CPG_ID, csInteger
            
        ' empid
        Case K_EMP_ID
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.fields.Add2 cscLdpOrden, 100, csInteger
            register.fields.Add2 cscLdpId, K_EMP_ID, csInteger

      End Select
      
      ' empid
      register.fields.Add2 cscEmpId, empId, csId
      
      register.fields.Add2 cscUsId, m_Us_id, csId
      register.fields.Add2 cscPreID, csPreVtaListFactura, csId

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

Private Function pGetDocFilter() As String
  pGetDocFilter = "'{emp_id=0}doct_id = " & csEDT_FacturaVenta & _
                  " or doct_id = " & csEDT_NotaCreditoVenta & _
                  " or doct_id = " & csEDT_NotaDebitoVenta & "'"
End Function

Private Sub pCreateMenu()
  On Error Resume Next
  
  If m_MenuLoaded Then Exit Sub
  
  m_MenuLoaded = True
  
  With m_ObjList
    Set .ObjClientMenu = Me
    .ClearMenu
    m_MenuEditCliente = .AddMenu(LNGGetText(5038, vbNullString)) 'Editar Cliente
    .AddMenu "-"
    m_MenuShowCobranza = .AddMenu(LNGGetText(1690, vbNullString)) 'Cobrar
    .AddMenu "-"
    m_MenuFirmar = .AddMenu(LNGGetText(1594, vbNullString))       'Firmar
    .AddMenu "-"
    m_MenuShowInfoCli = .AddMenu(LNGGetText(1614, vbNullString))  'Ver Info del Cliente
    m_MenuAddMensaje = .AddMenu(LNGGetText(1615, vbNullString))   'Agregar Nota
    m_MenuShowMensajes = .AddMenu(LNGGetText(1616, vbNullString)) 'Ver Notas
    .AddMenu "-"
    m_MenuShowAplic = .AddMenu(LNGGetText(1617, vbNullString))    'Ver Aplicaciones
    m_MenuShowAsiento = .AddMenu(LNGGetText(1692, vbNullString))  'Ver Asiento Contable
    m_MenuShowDocAux = .AddMenu(LNGGetText(1691, vbNullString))   'Ver Documento Asociado
    .AddMenu "-"
    m_MenuGetCae = .AddMenu(LNGGetText(5125, vbNullString))  'Obtener CAE
    m_MenuUpdateTalonarios = .AddMenu(LNGGetText(5130, vbNullString)) 'Actualizar Talonarios AFIP
    m_SendCAEByEmail = .AddMenu(LNGGetText(5131, vbNullString)) 'Enviar Factura Electronica por e-mail
  End With
End Sub

Private Sub pShowMensajes()
  Dim sqlstmt As String
  Dim fvId    As Long
  Dim rs      As ADODB.Recordset
  
  fvId = m_ObjList.id
  
  sqlstmt = "sp_ParteDiarioGetTitleForDoc " & csEDT_FacturaVenta & "," & fvId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Dim infodoc As String
  Dim DoctId  As Long
  
  DoctId = gDB.ValField(rs.fields, cscDoctId)
  infodoc = gDB.ValField(rs.fields, "info_doc")
  
  sqlstmt = "sp_PartesDiarioGetForDoc " & gDB.UserId & "," & empId & "," & DoctId & "," & fvId
  ShowNotes "Notas sobre factura " & infodoc, sqlstmt
End Sub

Private Sub pAddMensaje()
  Dim Parte As Object
  Set Parte = CSKernelClient2.CreateObject("CSEnvio2.cParteDiario")
  
  Parte.AddParteToDoc csEDT_FacturaVenta, m_ObjList.id, False
End Sub

Private Sub pEditCliente()
  Dim cli_id As Long
  cli_id = pGetCliId()
  If cli_id = csNO_ID Then Exit Sub
  Dim AbmObj As cABMGeneric
  Dim o      As cIEditGeneric
  Set AbmObj = New CSABMInterface2.cABMGeneric
  Set o = CSKernelClient2.CreateObject("CSGeneral2.cCliente")
  Set o.ObjAbm = AbmObj
  o.Edit cli_id, True
End Sub

Private Sub pFirmar()
  
  Dim i               As Long
  Dim fvId            As Long
  Dim Firmado         As Boolean
  Dim docId           As Long
  Dim vIds()          As Long
  Dim us_id_firmante  As Long
  Dim bNotShowForm    As Boolean
  Dim sqlstmt         As String
  Dim rs              As Recordset
  Dim Doc             As cDocumento
  Dim us_id           As Long

  vIds = m_ObjList.SelectedItems
  
  For i = 0 To UBound(vIds)
  
    fvId = vIds(i)
  
    If fvId <> csNO_ID Then
  
      If Not gDB.GetData(csTFacturaVenta, cscFvId, fvId, cscFvFirmado, Firmado) Then Exit Sub
      If Not gDB.GetData(csTFacturaVenta, cscFvId, fvId, cscDocId, docId) Then Exit Sub
    
      If Firmado Then
        If Not Ask(LNGGetText(1593, vbNullString), vbYes, LNGGetText(1594, vbNullString)) Then
                  'El documento ya ha sido firmado desea borrar la firma", vbYes, "Firmar
          Exit Sub
        End If
      End If
      
      bNotShowForm = False
      
      If us_id_firmante <> csNO_ID Then
      
        sqlstmt = "select us_id from DocumentoFirma where doc_id = " _
                     & docId & " and us_id = " & us_id_firmante
                    
        If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
        If Not rs.EOF Then
        
          bNotShowForm = True
          us_id = us_id_firmante
          
        End If
      End If
    
      If Not bNotShowForm Then
            
        Set Doc = New cDocumento
        
        If Not Doc.Firmar(docId, us_id) Then Exit Sub
      
      End If
            
      sqlstmt = "sp_DocFacturaVentaFirmar " & fvId & "," & us_id
      If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
      
      m_ObjList.sqlstmt = "sp_lsdoc_FacturaVenta"
      
      m_ObjList.RefreshLine fvId
      
      sqlstmt = "select fv_firmado from FacturaVenta where fv_id = " & fvId
      If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
      If rs.EOF Then Exit Sub
            
      us_id_firmante = gDB.ValField(rs.fields, 0)
        
    End If
    
  Next
    
End Sub

Private Function pGetCAE()
  
  Dim i               As Long
  Dim fvId            As Long
  Dim vIds()          As Long

  vIds = m_ObjList.SelectedItems
  
  For i = 0 To UBound(vIds)
  
    fvId = vIds(i)
  
    If fvId <> csNO_ID Then
  
      facturaVentaGetCAE fvId
      m_ObjList.sqlstmt = "sp_lsdoc_FacturaVenta"
      m_ObjList.RefreshLine fvId
        
    End If
    
  Next
  
  pUpdateTalonariosAFIP

End Function

Private Sub pUpdateTalonariosAFIP()
  
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_FE_UpdateTalonarios"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  If rs.EOF Then Exit Sub
  
  MsgInfo gDB.ValField(rs.fields, "info")
  
End Sub

Private Function pSendCAEByEmail()
  
  Dim i               As Long
  Dim fvId            As Long
  Dim vIds()          As Long

  vIds = m_ObjList.SelectedItems
  
  For i = 0 To UBound(vIds)
  
    fvId = vIds(i)
  
    If fvId <> csNO_ID Then
  
      facturaVentaSendCAEByEmail fvId
        
    End If
    
  Next
  
  MsgInfo LNGGetText(5133, vbNullString) ' "La solicitud de envio de e-mail se genero con éxito

End Function

Private Sub pShowAsiento()
  
  Dim fvId As Long
  fvId = m_ObjList.id
  
  If fvId Then
  
    Dim AsId As Long
    If Not gDB.GetData(csTFacturaVenta, cscFvId, fvId, cscAsId, AsId) Then Exit Sub
    
    ShowDocAux AsId, _
               "CSContabilidad2.cAsiento", _
               "CSABMInterface2.cABMGeneric"
  End If

End Sub

Private Sub pShowDocAux()
  
  Dim fvId As Long
  fvId = m_ObjList.id
  
  If fvId Then
  
    Dim StId As Long
    If Not gDB.GetData(csTFacturaVenta, cscFvId, fvId, cscStId, StId) Then Exit Sub
    
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

  Dim fvId As Long
  fvId = m_ObjList.id
  
  If fvId = csNO_ID Then Exit Sub

  Dim Total     As Double
  Dim Cotiz     As Double
  Dim NroDoc    As String
  Dim CliId     As Long
  Dim Cliente   As String
  Dim SucId     As Long
  Dim docId     As Long
  Dim DoctId    As Long
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select fv_total, fv_cotizacion, fv_nrodoc, fv.cli_id, cli_nombre, " & _
                   "fv.suc_id, fv.doc_id, fv.doct_id " & _
                   "from FacturaVenta fv inner join Cliente cli " & _
                                  " on fv.cli_id = cli.cli_id " & _
                   "where fv_id = " & fvId
                   
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Total = gDB.ValField(rs.fields, cscFvTotal)
  Cotiz = gDB.ValField(rs.fields, cscFvCotizacion)
  NroDoc = gDB.ValField(rs.fields, cscFvNrodoc)
  CliId = gDB.ValField(rs.fields, cscCliId)
  Cliente = gDB.ValField(rs.fields, cscCliNombre)
  SucId = gDB.ValField(rs.fields, cscSucId)
  docId = gDB.ValField(rs.fields, cscDocId)
  DoctId = gDB.ValField(rs.fields, cscDoctId)

  If Not DocSecurityCanAccess(csPreVtaModifyAplic, _
                              m_doc_id, _
                              csEDocTPreAplicar) Then Exit Sub
  
  If m_ObjApply Is Nothing Then
    Set m_ObjApply = New cFacturaVentaAplic
  
  ' Edit Apply
  '
  Else
    If m_ObjApply.id <> fvId Then
      Set m_ObjApply = New cFacturaVentaAplic
    End If
  End If
  
  If Not m_ObjApply.Show(fvId, _
                         Total * IIf( _
                                 Cotiz <> 0, Cotiz, 1 _
                                        ), _
                         NroDoc, _
                         CliId, _
                         Cliente, _
                         SucId, _
                         docId, _
                         DoctId = csEDocumentoTipo.csEDT_NotaCreditoVenta) Then
    Set m_ObjApply = Nothing
  End If
                  
End Sub

Private Sub pShowCobranza()
  On Error GoTo ControlError

  Dim o As Object

  Set o = CSKernelClient2.CreateObject("CSTesoreria2.cCobranza")
  
  o.ShowCobranza pGetCliId(), pGetFvIds()

  GoTo ExitProc
ControlError:
  MngError Err, "pShowCobranza", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetCliId() As Long
  On Error Resume Next
  
  Dim fvId  As Long
  Dim CliId As Long
  
  fvId = m_ObjList.id
  gDB.GetData csTFacturaVenta, cscFvId, fvId, cscCliId, CliId
  
  pGetCliId = CliId
End Function

Private Function pGetFvIds() As Long()
  pGetFvIds = m_ObjList.SelectedItems
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
 
  m_Title = LNGGetText(1624, vbNullString)  'Facturas de Venta
 
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
    
    With .Columns.Add(Nothing, "Descripción")
      .name = "Descripción"
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
