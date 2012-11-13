VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cManifiestoCargaListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient

'--------------------------------------------------------------------------------
' cManifiestoCargaListDoc
' 30-04-04
'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cManifiestoCargaListDoc"

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
Private Const K_BARC_ID                        As Integer = 8
Private Const K_DOC_ID                         As Integer = 9
Private Const K_TRANS_ID                       As Integer = 10
Private Const K_CHOF_ID                        As Integer = 11
Private Const K_PUE_ID_ORIGEN                  As Integer = 12
Private Const K_PUE_ID_DESTINO                 As Integer = 13
Private Const K_CMARC_ID                       As Integer = 14
Private Const K_DEPL_ID_ORIGEN                 As Integer = 25
Private Const K_DEPL_ID_DESTINO                As Integer = 26
' empid
Private Const K_EMP_ID                         As Integer = 100

' Seudo - Variables
Private c_strTitle             As String
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
Private m_Barc_id                        As String
Private m_Barco                          As String
Private m_doc_id                         As String
Private m_Documento                      As String
Private m_trans_id                       As String
Private m_Transporte                     As String
Private m_chof_id                        As String
Private m_Chofer                         As String
Private m_PueIdOrigen                    As String
Private m_PuertoOrigen                   As String
Private m_PueIdDestino                   As String
Private m_PuertoDestino                  As String
Private m_DeplIdOrigen                   As String
Private m_DepositoLogicoOrigen           As String
Private m_DeplIdDestino                  As String
Private m_DepositoLogicoDestino          As String
Private m_cmarc_id                       As String
Private m_ContraMarca                    As String
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

Private m_MenuShowMensajes  As Long
Private m_MenuAddMensaje    As Long
Private m_MenuShowInfoCli   As Long
Private m_MenuFirmar        As Long

Private m_MenuShowPacking  As Long


' Properties publicas
' Properties privadas
' funciones publicas
Public Function ProcessMenu(ByVal Index As Long)
  On Error GoTo ControlError

  Select Case Index
  
    Case m_MenuShowPacking
      pShowPacking
    
    Case m_MenuShowInfoCli
      HelpShowInfo csCliente, pGetCliId()
    
    Case m_MenuShowMensajes
      pShowMensajes
      
    Case m_MenuAddMensaje
      pAddMensaje
    
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
  c.Name = LNGGetText(1203, vbNullString) 'Fecha desde
  c.Key = K_FECHAINI
  If LenB(m_FechaIniV) Then
    c.Value = m_FechaIniV
  Else
    c.Value = m_FechaIni
  End If
  

  Set c = m_ObjAbm.Properties.Add(Nothing, c_FechaFin)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1203, vbNullString) 'Fecha hasta
  c.Key = K_FECHAFIN
  If LenB(m_FechaFinV) Then
    c.Value = m_FechaFinV
  Else
    c.Value = m_FechaFin
  End If
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscCliId)
  c.PropertyType = cspHelp
  c.Table = csCliente
  c.Name = LNGGetText(1150, vbNullString) 'Cliente
  c.Key = K_CLI_ID
  Value = m_Cliente
  If UCase(Left$(m_cli_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csCliente, Val(Mid(m_cli_id, 2)), bExists)
    If Not bExists Then m_cli_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_cli_id)
  c.HelpValueProcess = m_cli_id
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscEstId)
  c.PropertyType = cspHelp
  c.Table = csEstado
  c.Name = LNGGetText(1568, vbNullString) 'Estado
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
  c.Name = LNGGetText(1057, vbNullString) 'Centro de Costos
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
  c.Name = LNGGetText(1281, vbNullString) 'Sucursal
  c.Key = K_SUC_ID
  Value = m_Sucursal
  If UCase(Left$(m_ccos_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csSucursal, Val(Mid(m_suc_id, 2)), bExists)
    If Not bExists Then m_suc_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_suc_id)
  c.HelpValueProcess = m_suc_id
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscBarcId)
  c.PropertyType = cspHelp
  c.Table = csBarco
  c.Name = LNGGetText(2424, vbNullString) 'Barco
  c.Key = K_BARC_ID
  Value = m_Barco
  If UCase(Left$(m_Barc_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csBarco, Val(Mid(m_Barc_id, 2)), bExists)
    If Not bExists Then m_Barc_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_Barc_id)
  c.HelpValueProcess = m_Barc_id
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscDocId)
  c.PropertyType = cspHelp
  c.Table = csETablasDocumento.CSDocumento
  c.Name = LNGGetText(1611, vbNullString) 'Documentos
  c.Key = K_DOC_ID
  Value = m_Documento
  If UCase(Left$(m_doc_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csETablasDocumento.CSDocumento, Val(Mid(m_doc_id, 2)), bExists)
    If Not bExists Then m_doc_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_doc_id)
  c.HelpValueProcess = m_doc_id
  c.HelpFilter = "'{emp_id=0}doct_id = " & csEDT_ManifiestoCarga & "'"

  Set c = m_ObjAbm.Properties.Add(Nothing, cscTransId)
  c.PropertyType = cspHelp
  c.Table = csTransporte
  c.Name = LNGGetText(1050, vbNullString) 'Transporte
  c.Key = K_TRANS_ID
  Value = m_Transporte
  If UCase(Left$(m_trans_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csTransporte, Val(Mid(m_trans_id, 2)), bExists)
    If Not bExists Then m_trans_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_trans_id)
  c.HelpValueProcess = m_trans_id
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscChofId)
  c.PropertyType = cspHelp
  c.Table = csChofer
  c.Name = LNGGetText(1051, vbNullString) 'Chofer
  c.Key = K_CHOF_ID
  Value = m_Chofer
  If UCase(Left$(m_chof_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csChofer, Val(Mid(m_chof_id, 2)), bExists)
    If Not bExists Then m_chof_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_chof_id)
  c.HelpValueProcess = m_chof_id
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscPueIdOrigen)
  c.PropertyType = cspHelp
  c.Table = csPuerto
  c.Name = LNGGetText(2400, vbNullString) 'Puerto Origen
  c.Key = K_PUE_ID_ORIGEN
  Value = m_PuertoOrigen
  If UCase(Left$(m_PueIdOrigen, 1)) = KEY_NODO Then
    Value = GetNombreRama(csPuerto, Val(Mid(m_PueIdOrigen, 2)), bExists)
    If Not bExists Then m_PueIdOrigen = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_PueIdOrigen)
  c.HelpValueProcess = m_PueIdOrigen
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscPueIdDestino)
  c.PropertyType = cspHelp
  c.Table = csPuerto
  c.Name = LNGGetText(2401, vbNullString) 'Puerto Destino
  c.Key = K_PUE_ID_DESTINO
  Value = m_PuertoDestino
  If UCase(Left$(m_PueIdDestino, 1)) = KEY_NODO Then
    Value = GetNombreRama(csPuerto, Val(Mid(m_PueIdDestino, 2)), bExists)
    If Not bExists Then m_PueIdDestino = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_PueIdDestino)
  c.HelpValueProcess = m_PueIdDestino
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscDeplIdOrigen)
  c.PropertyType = cspHelp
  c.Table = csDepositoLogico
  c.Name = LNGGetText(2014, vbNullString) 'Deposito Origen
  c.Key = K_DEPL_ID_ORIGEN
  Value = m_DepositoLogicoOrigen
  If UCase(Left$(m_DeplIdOrigen, 1)) = KEY_NODO Then
    Value = GetNombreRama(csDepositoLogico, Val(Mid(m_DeplIdOrigen, 2)), bExists)
    If Not bExists Then m_DeplIdOrigen = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_DeplIdOrigen)
  c.HelpValueProcess = m_DeplIdOrigen
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscDeplIdDestino)
  c.PropertyType = cspHelp
  c.Table = csDepositoLogico
  c.Name = LNGGetText(2015, vbNullString) 'Deposito Destino
  c.Key = K_DEPL_ID_DESTINO
  Value = m_DepositoLogicoDestino
  If UCase(Left$(m_DeplIdDestino, 1)) = KEY_NODO Then
    Value = GetNombreRama(csDepositoLogico, Val(Mid(m_DeplIdDestino, 2)), bExists)
    If Not bExists Then m_DeplIdDestino = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_DeplIdDestino)
  c.HelpValueProcess = m_DeplIdDestino
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscCMarcId)
  c.PropertyType = cspHelp
  c.Table = csContraMarca
  c.Name = LNGGetText(2508, vbNullString) 'Contra Marca
  c.Key = K_CMARC_ID
  Value = m_ContraMarca
  If UCase(Left$(m_cmarc_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csContraMarca, Val(Mid(m_cmarc_id, 2)), bExists)
    If Not bExists Then m_cmarc_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_cmarc_id)
  c.HelpValueProcess = m_cmarc_id
  
  ' empid
  Set c = m_ObjAbm.Properties.Add(Nothing, cscEmpId)
  c.PropertyType = cspHelp
  c.Table = csEmpresa
  c.Name = LNGGetText(1114, vbNullString) 'Empresa
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
  
  sqlstmt = "select * from ListaDocumentoParametro " & _
            " where us_id = " & us_id & _
              " and pre_id = " & csPreExpListManifiestoCarga & _
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
    m_Barc_id = csNO_ID
    m_Barco = vbNullString
    m_doc_id = csNO_ID
    m_Documento = vbNullString
    m_trans_id = csNO_ID
    m_Transporte = vbNullString
    m_cmarc_id = csNO_ID
    m_ContraMarca = vbNullString
    m_PueIdDestino = csNO_ID
    m_PuertoDestino = vbNullString
    m_PueIdOrigen = csNO_ID
    m_PuertoOrigen = vbNullString
    m_DeplIdDestino = csNO_ID
    m_DepositoLogicoDestino = vbNullString
    m_DeplIdOrigen = csNO_ID
    m_DepositoLogicoOrigen = vbNullString
    m_chof_id = csNO_ID
    m_Chofer = vbNullString
    
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
        
        Case K_BARC_ID
          m_Barc_id = gDB.ValField(rs.Fields, cscLdpValor)
        
        Case K_DOC_ID
          m_doc_id = gDB.ValField(rs.Fields, cscLdpValor)
        
        Case K_TRANS_ID
          m_trans_id = gDB.ValField(rs.Fields, cscLdpValor)
      
        Case K_CHOF_ID
          m_chof_id = gDB.ValField(rs.Fields, cscLdpValor)
      
        Case K_PUE_ID_DESTINO
          m_PueIdDestino = gDB.ValField(rs.Fields, cscLdpValor)
      
        Case K_PUE_ID_ORIGEN
          m_PueIdOrigen = gDB.ValField(rs.Fields, cscLdpValor)
      
        Case K_DEPL_ID_DESTINO
          m_DeplIdDestino = gDB.ValField(rs.Fields, cscLdpValor)
      
        Case K_DEPL_ID_ORIGEN
          m_DeplIdOrigen = gDB.ValField(rs.Fields, cscLdpValor)
      
        Case K_CMARC_ID
          m_cmarc_id = gDB.ValField(rs.Fields, cscLdpValor)
      
        ' empid
        Case K_EMP_ID
          m_emp_id = gDB.ValField(rs.Fields, cscLdpValor)
      
      End Select

      rs.MoveNext
    Wend

    Dim Data As String
    Dim strLoad As String
    
    strLoad = LNGGetText(2513, vbNullString)
              'Error al cargar los parámetros de navegación de Manifiesto de Carga
              
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
    If UCase(Left$(m_Barc_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTBarco, cscBarcId, Val(m_Barc_id), cscBarcNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Barco = Data
    End If
    If UCase(Left$(m_doc_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTDocumento, cscDocId, Val(m_doc_id), cscDocNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Documento = Data
    End If
    If UCase(Left$(m_trans_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTTransporte, cscTransId, Val(m_trans_id), cscTransNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Transporte = Data
    End If
    If UCase(Left$(m_chof_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTChofer, cscChofId, Val(m_chof_id), cscChofNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Chofer = Data
    End If
    If UCase(Left$(m_PueIdOrigen, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTPuerto, cscPueId, Val(m_PueIdOrigen), cscPueNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_PuertoOrigen = Data
    End If
    If UCase(Left$(m_PueIdDestino, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTPuerto, cscPueId, Val(m_PueIdDestino), cscPueNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_PuertoDestino = Data
    End If
    If UCase(Left$(m_DeplIdOrigen, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTDepositoLogico, cscDeplId, Val(m_DeplIdOrigen), cscDeplNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_DepositoLogicoOrigen = Data
    End If
    If UCase(Left$(m_DeplIdDestino, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTDepositoLogico, cscDeplId, Val(m_DeplIdDestino), cscDeplNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_DepositoLogicoDestino = Data
    End If
    If UCase(Left$(m_cmarc_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTContraMarca, cscCMarcId, Val(m_cmarc_id), cscCMarcNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_ContraMarca = Data
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
    
    Case K_EST_ID
      With m_ObjAbm.Properties(cscEstId)
        m_Estado = .Value
        m_est_id = .HelpValueProcess
      End With
  
    Case K_CLI_ID
      With m_ObjAbm.Properties(cscCliId)
        m_Cliente = .Value
        m_cli_id = .HelpValueProcess
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
      
    Case K_BARC_ID
      With m_ObjAbm.Properties(cscBarcId)
        m_Barco = .Value
        m_Barc_id = .HelpValueProcess
      End With
    
    Case K_DOC_ID
      With m_ObjAbm.Properties(cscDocId)
        m_Documento = .Value
        m_doc_id = .HelpValueProcess
      End With
      
    Case K_TRANS_ID
      With m_ObjAbm.Properties(cscTransId)
        m_Transporte = .Value
        m_trans_id = .HelpValueProcess
      End With
  
    Case K_CHOF_ID
      With m_ObjAbm.Properties(cscChofId)
        m_Chofer = .Value
        m_chof_id = .HelpValueProcess
      End With
  
    Case K_PUE_ID_ORIGEN
      With m_ObjAbm.Properties(cscPueIdOrigen)
        m_PuertoOrigen = .Value
        m_PueIdOrigen = .HelpValueProcess
      End With
  
    Case K_PUE_ID_DESTINO
      With m_ObjAbm.Properties(cscPueIdDestino)
        m_PuertoDestino = .Value
        m_PueIdDestino = .HelpValueProcess
      End With
  
    Case K_DEPL_ID_DESTINO
      With m_ObjAbm.Properties(cscDeplIdDestino)
        m_DepositoLogicoDestino = .Value
        m_DeplIdDestino = .HelpValueProcess
      End With
  
    Case K_DEPL_ID_ORIGEN
      With m_ObjAbm.Properties(cscDeplIdOrigen)
        m_DepositoLogicoOrigen = .Value
        m_DeplIdOrigen = .HelpValueProcess
      End With
  
    Case K_CMARC_ID
      With m_ObjAbm.Properties(cscCMarcId)
        m_ContraMarca = .Value
        m_cmarc_id = .HelpValueProcess
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

  sqlstmt = "sp_lsdoc_ManifiestosCarga "

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
  sqlstmt = sqlstmt & gDB.sqlString(m_Barc_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_doc_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_trans_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_chof_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_PueIdOrigen) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_PueIdDestino) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_DeplIdOrigen) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_DeplIdDestino) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_cmarc_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_emp_id)
          
  cIABMListDocClient_Refresh = sqlstmt
End Function

Private Function cIABMListDocClient_Save() As Boolean

  Dim strError As String
  
  strError = LNGGetText(2514, vbNullString)
            'Error al grabar los párametros de navegación de Manifiesto de Carga
            
  Dim register As cRegister
  Set register = New cRegister

  Dim sqlstmt As String
  
  sqlstmt = "delete ListaDocumentoParametro " & _
            " where pre_id " & csPreExpListManifiestoCarga & _
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
        Case K_BARC_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 80, csInteger
            register.Fields.Add2 cscLdpId, K_BARC_ID, csInteger
        Case K_DOC_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 90, csInteger
            register.Fields.Add2 cscLdpId, K_DOC_ID, csInteger
        Case K_TRANS_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 110, csInteger
            register.Fields.Add2 cscLdpId, K_TRANS_ID, csInteger
        Case K_CHOF_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 120, csInteger
            register.Fields.Add2 cscLdpId, K_CHOF_ID, csInteger
        Case K_PUE_ID_ORIGEN
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 130, csInteger
            register.Fields.Add2 cscLdpId, K_PUE_ID_ORIGEN, csInteger
        Case K_PUE_ID_DESTINO
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 140, csInteger
            register.Fields.Add2 cscLdpId, K_PUE_ID_DESTINO, csInteger
        Case K_DEPL_ID_ORIGEN
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 150, csInteger
            register.Fields.Add2 cscLdpId, K_DEPL_ID_ORIGEN, csInteger
        Case K_DEPL_ID_DESTINO
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 160, csInteger
            register.Fields.Add2 cscLdpId, K_DEPL_ID_DESTINO, csInteger
        Case K_CMARC_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 170, csInteger
            register.Fields.Add2 cscLdpId, K_CMARC_ID, csInteger
        
        ' empid
        Case K_EMP_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 100, csInteger
            register.Fields.Add2 cscLdpId, K_EMP_ID, csInteger
      
      End Select
      
      ' empid
      register.Fields.Add2 cscEmpId, EmpId, csId
      
      register.Fields.Add2 cscUsId, m_Us_id, csId
      register.Fields.Add2 cscPreID, csPreExpListManifiestoCarga, csId

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

Private Sub pCreateMenu()
  On Error Resume Next
  
  With m_ObjList
    Set .ObjClientMenu = Me
    .ClearMenu
    m_MenuShowPacking = .AddMenu("Generar Packing")
    .AddMenu "-"
    m_MenuFirmar = .AddMenu("Firmar")
    .AddMenu "-"
    m_MenuShowInfoCli = .AddMenu("Ver Info del Cliente")
    m_MenuAddMensaje = .AddMenu("Agregar Nota")
    m_MenuShowMensajes = .AddMenu("Ver Notas")
  End With
End Sub

Private Sub pShowMensajes()
  Dim sqlstmt As String
  Dim MfcId   As Long
  Dim rs      As ADODB.Recordset
  
  MfcId = m_ObjList.ID
  
  sqlstmt = "sp_ParteDiarioGetTitleForDoc " & csEDT_ManifiestoCarga & "," & MfcId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Dim infodoc As String
  Dim DoctId  As Long
  
  DoctId = gDB.ValField(rs.Fields, cscDoctId)
  infodoc = gDB.ValField(rs.Fields, "info_doc")
  
  sqlstmt = "sp_PartesDiarioGetForDoc " & gDB.UserId & "," & EmpId & "," & DoctId & "," & MfcId
  ShowNotes "Notas sobre Manifiesto de Carga " & infodoc, sqlstmt
End Sub

Private Sub pAddMensaje()
  Dim Parte As Object
  Set Parte = CSKernelClient2.CreateObject("CSEnvio2.cParteDiario")
  
  Parte.AddParteToDoc csEDT_ManifiestoCarga, m_ObjList.ID, False
End Sub

Private Sub pFirmar()
  
  Dim MfcId As Long
  MfcId = m_ObjList.ID
  
  If MfcId = csNO_ID Then Exit Sub
  
  Dim Firmado As Boolean
  Dim DocId   As Long
  
  If Not gDB.GetData(csTManifiestoCarga, cscMfcId, MfcId, cscMfcFirmado, Firmado) Then Exit Sub
  If Not gDB.GetData(csTManifiestoCarga, cscMfcId, MfcId, cscDocId, DocId) Then Exit Sub

  If Firmado Then
    If Not Ask("El documento ya ha sido firmado desea borrar la firma", vbYes, "Firmar") Then
      Exit Sub
    End If
  End If

  Dim Doc     As cDocumento
  Dim us_id   As Long
  
  Set Doc = New cDocumento
  
  If Not Doc.Firmar(DocId, us_id) Then Exit Sub
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocManifiestoCargaFirmar " & MfcId & "," & us_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  m_ObjList.sqlstmt = "sp_lsdoc_ManifiestoCarga"
  
  m_ObjList.RefreshLine MfcId
  
End Sub

Private Sub pShowFactura()
  On Error GoTo ControlError

  Dim o As Object
  Set o = CSKernelClient2.CreateObject("CSVenta2.cFacturaVenta")
  
  o.ShowFacturaPedido pGetCliId(), pGetMfcIds()

  GoTo ExitProc
ControlError:
  MngError Err, "pShowFactura", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pShowPacking()
  On Error GoTo ControlError

  Dim o As CSExport2.cPackingList
  Set o = New CSExport2.cPackingList
  
  o.ShowPackingManifiesto pGetCliId(), pGetMfcIds()

  GoTo ExitProc
ControlError:
  MngError Err, "pShowPacking", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetCliId() As Long
  On Error Resume Next
  
  Dim MfcId  As Long
  Dim CliId As Long
  
  MfcId = m_ObjList.ID
  gDB.GetData csTManifiestoCarga, cscMfcId, MfcId, cscCliId, CliId
  
  pGetCliId = CliId
End Function

Private Function pGetMfcIds() As Long()
  pGetMfcIds = m_ObjList.SelectedItems
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
 
  c_strTitle = LNGGetText(2497, vbNullString)   'Manifiestos de Carga
 
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
