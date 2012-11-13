VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cOrdenPagoListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient

'--------------------------------------------------------------------------------
' cOrdenPagoListDoc
' 08-03-04
'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cOrdenPagoListDoc"

Private Const c_FechaIni = "FechaIni"
Private Const c_FechaFin = "FechaFin"

Private Const c_img_task = 1

' ACA VAN LAS K GENERADAS POR EL ASISTENTE.
Private Const K_FECHAINI                       As Integer = 1
Private Const K_FECHAFIN                       As Integer = 2
Private Const K_PROV_ID                        As Integer = 4
Private Const K_EST_ID                         As Integer = 5
Private Const K_CCOS_ID                        As Integer = 6
Private Const K_SUC_ID                         As Integer = 7
Private Const K_VEN_ID                         As Integer = 8
Private Const K_DOC_ID                         As Integer = 9
' empid
Private Const K_EMP_ID                         As Integer = 100
' estructuras
' variables privadas
Private m_FechaIni                       As Date
Private m_FechaFin                       As Date
Private m_Prov_id                        As String
Private m_Proveedor                      As String
Private m_est_id                         As String
Private m_Estado                         As String
Private m_ccos_id                        As String
Private m_CentroCosto                    As String
Private m_suc_id                         As String
Private m_Sucursal                       As String
Private m_cob_id                         As String
Private m_Cobrador                       As String
Private m_doc_id                         As String
Private m_Documento                      As String
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

Private m_MenuLoaded        As Boolean

Private m_Title             As String

Private m_MenuShowMensajes  As Long
Private m_MenuShowInfoProv  As Long
Private m_MenuAddMensaje    As Long
Private m_MenuShowAplic     As Long
Private m_MenuShowAsiento   As Long
Private m_MenuFirmar        As Long

Private m_ObjApply          As cOrdenPagoAplic

' Properties publicas
' Properties privadas
' funciones publicas
Public Function ProcessMenu(ByVal Index As Long)
  On Error GoTo ControlError

  Select Case Index
  
    Case m_MenuShowInfoProv
      HelpShowInfo csProveedor, pGetProvId()
    
    Case m_MenuShowMensajes
      pShowMensajes
      
    Case m_MenuAddMensaje
      pAddMensaje
      
    Case m_MenuShowAplic
      pShowApply
    
    Case m_MenuShowAsiento
      pShowAsiento
      
    Case m_MenuFirmar
      pFirmar
  
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
  c.Name = LNGGetText(1203, vbNullString)     'Fecha desde
  c.Key = K_FECHAINI
  If LenB(m_FechaIniV) Then
    c.Value = m_FechaIniV
  Else
    c.Value = m_FechaIni
  End If
  

  Set c = m_ObjAbm.Properties.Add(Nothing, c_FechaFin)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1204, vbNullString)    'Fecha hasta
  c.Key = K_FECHAFIN
  If LenB(m_FechaFinV) Then
    c.Value = m_FechaFinV
  Else
    c.Value = m_FechaFin
  End If
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscProvId)
  c.PropertyType = cspHelp
  c.Table = csProveedor
  c.Name = LNGGetText(1151, vbNullString)    'Proveedor
  c.Key = K_PROV_ID
  Value = m_Proveedor
  If UCase(Left$(m_Prov_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csProveedor, Val(Mid(m_Prov_id, 2)), bExists)
    If Not bExists Then m_Prov_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_Prov_id)
  c.HelpValueProcess = m_Prov_id
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscEstId)
  c.PropertyType = cspHelp
  c.Table = csEstado
  c.Name = LNGGetText(1568, vbNullString)    'Estado
  c.Key = K_EST_ID
  Value = m_Estado
  If UCase(Left$(m_est_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csEstado, Val(Mid(m_est_id, 2)), bExists)
    If Not bExists Then m_est_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_est_id)
  c.HelpValueProcess = m_est_id
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscCcosId)
  c.PropertyType = cspHelp
  c.Table = csCentroCosto
  c.Name = LNGGetText(1057, vbNullString)    'Centro de Costos
  c.Key = K_CCOS_ID
  Value = m_CentroCosto
  If UCase(Left$(m_ccos_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csCentroCosto, Val(Mid(m_ccos_id, 2)), bExists)
    If Not bExists Then m_ccos_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_ccos_id)
  c.HelpValueProcess = m_ccos_id
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscSucId)
  c.PropertyType = cspHelp
  c.Table = csSucursal
  c.Name = LNGGetText(1281, vbNullString)    'Sucursal
  c.Key = K_SUC_ID
  Value = m_Sucursal
  If UCase(Left$(m_suc_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csSucursal, Val(Mid(m_suc_id, 2)), bExists)
    If Not bExists Then m_suc_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_suc_id)
  c.HelpValueProcess = m_suc_id
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscCobId)
  c.PropertyType = cspHelp
  c.Table = csCobrador
  c.Name = LNGGetText(1088, vbNullString)    'Cobrador
  c.Key = K_VEN_ID
  Value = m_Cobrador
  If UCase(Left$(m_cob_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csVendedores, Val(Mid(m_cob_id, 2)), bExists)
    If Not bExists Then m_cob_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_cob_id)
  c.HelpValueProcess = m_cob_id
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscDocId)
  c.PropertyType = cspHelp
  c.Table = csETablasDocumento.CSDocumento
  c.Name = LNGGetText(1611, vbNullString)    'Documentos
  c.Key = K_DOC_ID
  Value = m_Documento
  If UCase(Left$(m_doc_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csETablasDocumento.CSDocumento, Val(Mid(m_doc_id, 2)), bExists)
    If Not bExists Then m_doc_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_doc_id)
  c.HelpValueProcess = m_doc_id
  c.HelpFilter = "'{emp_id=0}doct_id = " & csEDT_OrdenPago & "'"
  
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

Private Function Load(ByVal Us_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select * from ListaDocumentoParametro " & _
            " where us_id = " & Us_id & _
              " and pre_id = " & csPreTsrListOrdenPago & _
              " and (emp_id is null or emp_id = " & EmpId & ")" & _
            " order by " & cscLdpOrden

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  ' empid
  m_emp_id = EmpId
  m_Empresa = EmpNombre
  
  If rs.EOF Then
    
    m_FechaIni = Date
    m_FechaFin = Date
    m_Prov_id = csNO_ID
    m_Proveedor = vbNullString
    m_est_id = csNO_ID
    m_Estado = vbNullString
    m_ccos_id = csNO_ID
    m_CentroCosto = vbNullString
    m_suc_id = csNO_ID
    m_Sucursal = vbNullString
    m_cob_id = csNO_ID
    m_Cobrador = vbNullString
    m_doc_id = csNO_ID
    m_Documento = vbNullString
  
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
        
        Case K_PROV_ID
          m_Prov_id = gDB.ValField(rs.Fields, cscLdpValor)
        
        Case K_EST_ID
          m_est_id = gDB.ValField(rs.Fields, cscLdpValor)
        
        Case K_CCOS_ID
          m_ccos_id = gDB.ValField(rs.Fields, cscLdpValor)
        
        Case K_SUC_ID
          m_suc_id = gDB.ValField(rs.Fields, cscLdpValor)
        
        Case K_VEN_ID
          m_cob_id = gDB.ValField(rs.Fields, cscLdpValor)
        
        Case K_DOC_ID
          m_doc_id = gDB.ValField(rs.Fields, cscLdpValor)
        
        ' empid
        Case K_EMP_ID
          m_emp_id = gDB.ValField(rs.Fields, cscLdpValor)
      
      End Select

      rs.MoveNext
    Wend

    Dim Data As String
    Dim strLoad As String
    
    strLoad = LNGGetText(2246, vbNullString) 'Error al cargar Orden dePago
    
    m_FechaIni = IIf(m_FechaIni <> csNoDate, m_FechaIni, Date)
    m_FechaFin = IIf(m_FechaFin <> csNoDate, m_FechaFin, Date)


' OJO: EL ASISTENTE ESTO LO HACE MAL, YA QUE EL CODIGO QUE GENERA NO SOPORTA ARBOLES
'      USEN ESTE CODIGO COMO EJ. OJO!!! CAMBIEN LOS NOMBRES DE LAS TABLAS Y LOS CAMPOS NOMBRES DE DICHAS TABLAS.
    If UCase(Left$(m_Prov_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTProveedor, cscProvId, Val(m_Prov_id), cscProvNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Proveedor = Data
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
    If UCase(Left$(m_cob_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTCobrador, cscCobId, Val(m_cob_id), cscCobNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Cobrador = Data
    End If
    If UCase(Left$(m_doc_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTDocumento, cscDocId, Val(m_doc_id), cscDocNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Documento = Data
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


' OJO: NUEVAMENTE LA EXISTENCIA DE FECHAS VIRTUALES HACE QUE EL CODIGO GENERADO POR EL ASISTENTE ESTE MAL
'      CORRIJALO UTILIZANDO ESTE CODIGO COMO EJEMPLO.
Private Function cIABMListDocClient_PropertyChange(ByVal Key As Integer) As Boolean
  Dim iProp     As cIABMProperty
  
  Select Case Key

    Case K_FECHAINI
      
      Set iProp = m_ObjAbm.Properties(c_FechaIni)
  
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
      
      Set iProp = m_ObjAbm.Properties(c_FechaFin)
      
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
      With m_ObjAbm.Properties(cscEstId)
        m_Estado = .Value
        m_est_id = .HelpValueProcess
      End With
  
    Case K_PROV_ID
      With m_ObjAbm.Properties(cscProvId)
        m_Proveedor = .Value
        m_Prov_id = .HelpValueProcess
      End With
    
    Case K_CCOS_ID
      With m_ObjAbm.Properties(cscCcosId)
        m_CentroCosto = .Value
        m_ccos_id = .HelpValueProcess
      End With
      
    Case K_SUC_ID
      With m_ObjAbm.Properties(cscSucId)
        m_Sucursal = .Value
        m_suc_id = .HelpValueProcess
      End With
      
    Case K_VEN_ID
      With m_ObjAbm.Properties(cscCobId)
        m_Cobrador = .Value
        m_cob_id = .HelpValueProcess
      End With
    
    Case K_DOC_ID
      With m_ObjAbm.Properties(cscDocId)
        m_Documento = .Value
        m_doc_id = .HelpValueProcess
      End With
      
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

  sqlstmt = "sp_lsdoc_OrdenPagos "

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
  
  sqlstmt = sqlstmt & gDB.sqlString(m_Prov_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_est_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_ccos_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_suc_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_doc_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_emp_id)

  cIABMListDocClient_Refresh = sqlstmt
End Function

Private Function cIABMListDocClient_Save() As Boolean

  Dim strError As String
  
  strError = LNGGetText(2245, vbNullString)
            'Error al grabar los párametros de navegación de Orden de Pago

  Dim register As cRegister
  Set register = New cRegister

  Dim sqlstmt As String
  
  sqlstmt = "delete ListaDocumentoParametro " & _
            " where pre_id = " & csPreTsrListOrdenPago & _
              " and us_id = " & m_Us_id & _
              " and (emp_id is null or emp_id = " & EmpId & ")"

  If Not gDB.Execute(sqlstmt, "cIABMClient_Save", C_Module, strError) Then Exit Function

  register.Table = csTListaDocumentoParametro
  register.UtilizaIdentity = True

  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties

    register.Fields.Clear

    With IProperty
      Select Case .Key

         Case K_FECHAINI
          If .HelpValueProcess <> vbNullString Then
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
          Else
            register.Fields.Add2 cscLdpValor, .Value, csText
          End If
          
          register.Fields.Add2 cscLdpOrden, 10, csInteger
          register.Fields.Add2 cscLdpId, K_FECHAINI, csInteger
        Case K_FECHAFIN

          If .HelpValueProcess <> vbNullString Then
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
          Else
            register.Fields.Add2 cscLdpValor, .Value, csText
          End If

          register.Fields.Add2 cscLdpOrden, 20, csInteger
          register.Fields.Add2 cscLdpId, K_FECHAFIN, csInteger

        Case K_PROV_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 40, csInteger
            register.Fields.Add2 cscLdpId, K_PROV_ID, csInteger
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
        Case K_VEN_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 80, csInteger
            register.Fields.Add2 cscLdpId, K_VEN_ID, csInteger
        Case K_DOC_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 90, csInteger
            register.Fields.Add2 cscLdpId, K_DOC_ID, csInteger

        ' empid
        Case K_EMP_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 100, csInteger
            register.Fields.Add2 cscLdpId, K_EMP_ID, csInteger
      
      End Select
      
      ' empid
      register.Fields.Add2 cscEmpId, EmpId, csId
      
      register.Fields.Add2 cscUsId, m_Us_id, csId
      register.Fields.Add2 cscPreID, csPreTsrListOrdenPago, csId

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

Private Property Set cIEditGenericListDoc_ObjAbm(rhs As CSInterfacesABM.cIABMGenericListDoc)
  Set m_ObjAbm = rhs
End Property

Private Property Set cIEditGenericListDoc_ObjList(rhs As Object)
  Set m_ObjList = rhs
End Property

Private Function cIEditGenericListDoc_PropertyChange(ByVal Key As Integer) As Boolean
End Function

Private Function cIEditGenericListDoc_ShowParams(ByVal Us_id As Long) As Boolean
  On Error GoTo ControlError
  
  If Us_id = csNO_ID Then Exit Function

  m_Us_id = Us_id
  
  If Not Load(Us_id) Then Exit Function
  
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
 
  m_Title = LNGGetText(1922, vbNullString) 'Orden de Pago
 
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
Private Sub pCreateMenu()
  On Error Resume Next
  
  If m_MenuLoaded Then Exit Sub
  
  m_MenuLoaded = True
  
  With m_ObjList
    Set .ObjClientMenu = Me
    .ClearMenu
    m_MenuFirmar = .AddMenu(LNGGetText(1594, vbNullString))       'Firmar
    .AddMenu "-"
    m_MenuAddMensaje = .AddMenu(LNGGetText(1615, vbNullString))   'Agregar Nota
    m_MenuShowMensajes = .AddMenu(LNGGetText(1616, vbNullString)) 'Ver Notas
    .AddMenu "-"
    m_MenuShowAsiento = .AddMenu(LNGGetText(1692, vbNullString))  'Ver Asiento Contable
  End With
End Sub

Private Function pGetProvId() As Long
  On Error Resume Next
  
  Dim OpgId  As Long
  Dim ProvId As Long
  
  OpgId = m_ObjList.id
  gDB.GetData csTOrdenPago, cscOpgId, OpgId, cscProvId, ProvId
  
  pGetProvId = ProvId
End Function

Private Sub pShowMensajes()
  Dim sqlstmt As String
  Dim OpgId    As Long
  Dim rs      As ADODB.Recordset
  
  OpgId = m_ObjList.id
  
  sqlstmt = "sp_ParteDiarioGetTitleForDoc " & csEDT_OrdenPago & "," & OpgId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Dim infodoc As String
  Dim DoctId  As Long
  
  DoctId = gDB.ValField(rs.Fields, cscDoctId)
  infodoc = gDB.ValField(rs.Fields, "info_doc")
  sqlstmt = "sp_PartesDiarioGetForDoc " & gDB.UserId & "," & EmpId & "," & DoctId & "," & OpgId
  ShowNotes LNGGetText(2201, vbNullString, infodoc), sqlstmt
            'Notas sobre Ordenes de Pago & infodoc
End Sub

Private Sub pAddMensaje()
  Dim Parte As Object
  Set Parte = CSKernelClient2.CreateObject("CSEnvio2.cParteDiario")
  
  Parte.AddParteToDoc csEDT_OrdenPago, m_ObjList.id, False
End Sub

Private Sub pFirmar()
  
  Dim OpgId As Long
  OpgId = m_ObjList.id
  
  If OpgId = csNO_ID Then Exit Sub
  
  Dim Firmado As Boolean
  Dim DocId   As Long
  
  If Not gDB.GetData(csTOrdenPago, cscOpgId, OpgId, cscOpgFirmado, Firmado) Then Exit Sub
  If Not gDB.GetData(csTOrdenPago, cscOpgId, OpgId, cscDocId, DocId) Then Exit Sub

  If Firmado Then
    If Not Ask(LNGGetText(1593, vbNullString), vbYes, LNGGetText(1594, vbNullString)) Then
              'El documento ya ha sido firmado desea borrar la firma, Firmar
      Exit Sub
    End If
  End If

  Dim Doc     As cDocumento
  Dim Us_id   As Long
  
  Set Doc = New cDocumento
  
  If Not Doc.Firmar(DocId, Us_id) Then Exit Sub
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocOrdenPagoFirmar " & OpgId & "," & Us_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  m_ObjList.sqlstmt = "sp_lsdoc_OrdenPago"
  
  m_ObjList.RefreshLine OpgId
  
End Sub

Private Sub pShowAsiento()
  
  Dim OpgId As Long
  OpgId = m_ObjList.id
  
  If OpgId Then
  
    Dim AsId As Long
    If Not gDB.GetData(csTOrdenPago, cscOpgId, OpgId, cscAsId, AsId) Then Exit Sub
    
    ShowDocAux AsId, _
               "CSContabilidad2.cAsiento", _
               "CSABMInterface2.cABMGeneric"
  End If

End Sub

Private Sub pShowApply()

  Dim OpgId As Long
  OpgId = m_ObjList.id
  
  If OpgId = csNO_ID Then Exit Sub

  Dim Total       As Double
  Dim Cotiz       As Double
  Dim NroDoc      As String
  Dim Proveedor   As String
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select opg_total, opg_nrodoc, opg.prov_id, prov_nombre," & _
                   "opg.suc_id, opg.doc_id, opg.doct_id " & _
                   "from OrdenPago opg inner join proveedor prov " & _
                                  " on opg.prov_id = prov.prov_id " & _
                   "where opg_id = " & OpgId
                   
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Total = gDB.ValField(rs.Fields, cscOpgTotal)
  NroDoc = gDB.ValField(rs.Fields, cscOpgNrodoc)
  Proveedor = gDB.ValField(rs.Fields, cscProvNombre)

  If Not DocSecurityCanAccess(csPreTsrModifyAplic, _
                              m_doc_id, _
                              csEDocTPreAplicar) Then Exit Sub
  
  If m_ObjApply Is Nothing Then
    Set m_ObjApply = New cOrdenPagoAplic
  
  ' Edit Apply
  '
  Else
    If m_ObjApply.id <> OpgId Then
      Set m_ObjApply = New cOrdenPagoAplic
    End If
  End If
  
  If Not m_ObjApply.Show(OpgId, _
                         Total, _
                         NroDoc, _
                         Proveedor) Then
    Set m_ObjApply = Nothing
  End If
                  
End Sub


