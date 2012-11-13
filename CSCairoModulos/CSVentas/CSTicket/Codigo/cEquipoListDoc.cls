VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cEquipoListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient

'--------------------------------------------------------------------------------
' cEquipoListDoc
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
Private Const C_Module = "cEquipoListDoc"

Private Const c_FechaIni = "FechaIni"
Private Const c_FechaFin = "FechaFin"

Private Const c_FiltrarFechas = "FiltrarFechas"
Private Const c_SinAsignar = "SinAsignar"
Private Const c_SoloEnEmpresa = "SoloEnEmpresa"

Private Const c_img_task = 1

' ACA VAN LAS K GENERADAS POR EL ASISTENTE.
Private Const K_FECHAINI                       As Integer = 1
Private Const K_FECHAFIN                       As Integer = 2

Private Const K_PRNS_ID                        As Integer = 200
Private Const K_RUB_ID                         As Integer = 3
Private Const K_PR_ID                          As Integer = 4
Private Const K_US_ID_ASIGNADOR                As Integer = 5
Private Const K_US_ID_RESPONSABLE              As Integer = 6
Private Const K_SIN_ASIGNAR                    As Integer = 7
Private Const K_TAREST_ID                      As Integer = 8
Private Const K_DEPL_ID                        As Integer = 9
Private Const K_FILTRAR_FECHAS                 As Integer = 10
Private Const K_CLI_ID                         As Integer = 11
Private Const K_CONT_ID                        As Integer = 12
Private Const K_SUC_ID                         As Integer = 13
Private Const K_PRIO_ID                        As Integer = 14
Private Const K_PROY_ID                        As Integer = 15
Private Const K_SOLO_EN_EMPRESA                As Integer = 16

' empid
Private Const K_EMP_ID                         As Integer = 100

' estructuras
' variables privadas

Private m_bFiltrarFechas                 As Boolean
Private m_bSinAsignar                    As Boolean
Private m_bSoloEnEmpresa                 As Boolean

Private m_FechaIni                       As Date
Private m_FechaFin                       As Date

Private m_prns_id            As String
Private m_Series             As String

Private m_Rub_id                         As String
Private m_Rubro                          As String

Private m_pr_id                          As String
Private m_producto                       As String

Private m_depl_id                        As String
Private m_deposito                       As String

Private m_Us_id_responsable  As String
Private m_Responsable        As String
Private m_Us_id_asignador    As String
Private m_Asignador          As String
Private m_cont_id            As String
Private m_contacto           As String
Private m_Tarest_id          As String
Private m_Estado             As String
Private m_Prio_id            As String
Private m_Prioridad          As String
Private m_Proy_id            As String
Private m_Proyecto           As String

Private m_cli_id                         As String
Private m_Cliente                        As String
Private m_suc_id                         As String
Private m_Sucursal                       As String


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

Private m_MenuLoaded        As Boolean

Private m_MenuShowFactura   As Long

Private m_MenuShowMensajes  As Long
Private m_MenuAddMensaje    As Long
Private m_MenuChangePr      As Long
Private m_MenuUpdateSerie   As Long
Private m_MenuEditSerieH    As Long
Private m_MenuParteRep      As Long

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
      
    Case m_MenuChangePr
      pChangePr pGetPrnsIds
  
    Case m_MenuUpdateSerie
      pUpdateSerie pGetPrnsIds
      
    Case m_MenuEditSerieH
      pEditSerieH pGetPrnsIds
      
    Case m_MenuParteRep
      pShowParteReparacion
      
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

    Set c = .Add(Nothing, c_FiltrarFechas)
    c.PropertyType = cspCheck
    c.Name = LNGGetText(1819, vbNullString)   'Filtrar por Fechas
    c.key = K_FILTRAR_FECHAS
    c.Value = CInt(m_bFiltrarFechas)

    Set c = .Add(Nothing, c_FechaIni)
    c.PropertyType = cspDate
    c.Name = LNGGetText(1203, vbNullString)   'Fecha desde
    c.key = K_FECHAINI
    If LenB(m_FechaIniV) Then
      c.Value = m_FechaIniV
    Else
      c.Value = m_FechaIni
    End If
    
    Set c = .Add(Nothing, c_FechaFin)
    c.PropertyType = cspDate
    c.Name = LNGGetText(1204, vbNullString)   'Fecha hasta
    c.key = K_FECHAFIN
    If LenB(m_FechaFinV) Then
      c.Value = m_FechaFinV
    Else
      c.Value = m_FechaFin
    End If
    
    Set c = .Add(Nothing, cscPrnsId)
    c.PropertyType = cspHelp
    c.table = csProductoSerie
    c.Name = LNGGetText(1820, vbNullString)   'Número de Serie
    c.key = K_PRNS_ID
    Value = m_Series
    If UCase(Left$(m_prns_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csProductoSerie, Val(Mid(m_prns_id, 2)), bExists)
      If Not bExists Then m_prns_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_prns_id)
    c.HelpValueProcess = m_prns_id
    
    Set c = .Add(Nothing, cscRubId)
    c.PropertyType = cspHelp
    c.table = csRubro
    c.Name = LNGGetText(1299, vbNullString)   'Rubro
    c.key = K_RUB_ID
    Value = m_Rubro
    If UCase(Left$(m_Rub_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csRubro, Val(Mid(m_Rub_id, 2)), bExists)
      If Not bExists Then m_Rub_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_Rub_id)
    c.HelpValueProcess = m_Rub_id
    
    Set c = .Add(Nothing, cscPrId)
    c.PropertyType = cspHelp
    c.table = csProducto
    c.Name = LNGGetText(1801, vbNullString)   'Equipo
    c.key = K_PR_ID
    Value = m_producto
    If UCase(Left$(m_pr_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csProducto, Val(Mid(m_pr_id, 2)), bExists)
      If Not bExists Then m_pr_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_pr_id)
    c.HelpValueProcess = m_pr_id
    
    Set c = .Add(Nothing, cscDeplId)
    c.PropertyType = cspHelp
    c.table = csDepositoLogico
    c.Name = LNGGetText(1574, vbNullString)   'Deposito
    c.key = K_DEPL_ID
    Value = m_deposito
    If UCase(Left$(m_depl_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csDepositoLogico, Val(Mid(m_depl_id, 2)), bExists)
      If Not bExists Then m_depl_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_depl_id)
    c.HelpValueProcess = m_depl_id
    
    Set c = .Add(Nothing, c_SoloEnEmpresa)
    c.PropertyType = cspCheck
    c.Name = LNGGetText(1821, vbNullString)   'Solo en la Empresa
    c.key = K_SOLO_EN_EMPRESA
    c.Value = CInt(m_bSoloEnEmpresa)
    
    Set c = m_ObjAbm.Properties.Add(Nothing, cscProyId)
    c.PropertyType = cspHelp
    c.table = csProyecto
    c.Name = LNGGetText(1658, vbNullString)   'Proyecto
    c.key = K_PROY_ID
    Value = m_Proyecto
    If UCase(Left$(m_Proy_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csProyecto, Val(Mid(m_Proy_id, 2)), bExists)
      If Not bExists Then m_Proy_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_Proy_id)
    c.HelpValueProcess = m_Proy_id
    
    
    Set c = m_ObjAbm.Properties.Add(Nothing, cscUsIdResponsable)
    c.PropertyType = cspHelp
    c.table = csUsuario
    c.Name = LNGGetText(1822, vbNullString)   'Responsable
    c.key = K_US_ID_RESPONSABLE
    Value = m_Responsable
    If UCase(Left$(m_Us_id_responsable, 1)) = KEY_NODO Then
      Value = GetNombreRama(csUsuario, Val(Mid(m_Us_id_responsable, 2)), bExists)
      If Not bExists Then m_Us_id_responsable = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_Us_id_responsable)
    c.HelpValueProcess = m_Us_id_responsable
    
    Set c = .Add(Nothing, c_SinAsignar)
    c.PropertyType = cspCheck
    c.Name = LNGGetText(1823, vbNullString)   'Sin Asignar
    c.key = K_SIN_ASIGNAR
    c.Value = CInt(m_bSinAsignar)
    
    Set c = m_ObjAbm.Properties.Add(Nothing, cscUsIdAsignador)
    c.PropertyType = cspHelp
    c.table = csUsuario
    c.Name = LNGGetText(1824, vbNullString)   'Asignada por
    c.key = K_US_ID_ASIGNADOR
    Value = m_Asignador
    If UCase(Left$(m_Us_id_asignador, 1)) = KEY_NODO Then
      Value = GetNombreRama(csUsuario, Val(Mid(m_Us_id_asignador, 2)), bExists)
      If Not bExists Then m_Us_id_asignador = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_Us_id_asignador)
    c.HelpValueProcess = m_Us_id_asignador
    
    
    Set c = m_ObjAbm.Properties.Add(Nothing, cscContId)
    c.PropertyType = cspHelp
    c.table = csContacto
    c.Name = LNGGetText(1035, vbNullString)   'Contacto
    c.key = K_CONT_ID
    Value = m_contacto
    If UCase(Left$(m_cont_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csContacto, Val(Mid(m_cont_id, 2)), bExists)
      If Not bExists Then m_cont_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_cont_id)
    c.HelpValueProcess = m_cont_id
    
    
    Set c = m_ObjAbm.Properties.Add(Nothing, cscTarestId)
    c.PropertyType = cspHelp
    c.table = csTareaEstado
    c.Name = LNGGetText(1568, vbNullString)   'Estado
    c.key = K_TAREST_ID
    Value = m_Estado
    If UCase(Left$(m_Tarest_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csTareaEstado, Val(Mid(m_Tarest_id, 2)), bExists)
      If Not bExists Then m_Tarest_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_Tarest_id)
    c.HelpValueProcess = m_Tarest_id
    
    
    Set c = m_ObjAbm.Properties.Add(Nothing, cscPrioId)
    c.PropertyType = cspHelp
    c.table = csPrioridad
    c.Name = LNGGetText(1825, vbNullString)   'Prioridad
    c.key = K_PRIO_ID
    
    Value = m_Prioridad
    If UCase(Left$(m_Prio_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csPrioridad, Val(Mid(m_Prio_id, 2)), bExists)
      If Not bExists Then m_Prio_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_Prio_id)
    c.HelpValueProcess = m_Prio_id
    
    Set c = .Add(Nothing, cscCliId)
    c.PropertyType = cspHelp
    c.table = csCliente
    c.Name = LNGGetText(1150, vbNullString)   'Cliente
    c.key = K_CLI_ID
    Value = m_Cliente
    If UCase(Left$(m_cli_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csCliente, Val(Mid(m_cli_id, 2)), bExists)
      If Not bExists Then m_cli_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_cli_id)
    c.HelpValueProcess = m_cli_id
    
    Set c = .Add(Nothing, cscSucId)
    c.PropertyType = cspHelp
    c.table = csSucursal
    c.Name = LNGGetText(1281, vbNullString)   'Sucursal
    c.key = K_SUC_ID
    Value = m_Sucursal
    If UCase(Left$(m_suc_id, 1)) = KEY_NODO Then
      Value = GetNombreRama(csSucursal, Val(Mid(m_suc_id, 2)), bExists)
      If Not bExists Then m_suc_id = "0"
    End If
    c.Value = Value
    c.HelpId = Val(m_suc_id)
    c.HelpValueProcess = m_suc_id
    
    ' empid
    Set c = .Add(Nothing, cscEmpId)
    c.PropertyType = cspHelp
    c.table = csEmpresa
    c.Name = LNGGetText(1114, vbNullString)   'Empresa
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
    
    m_bFiltrarFechas = False
    m_bSinAsignar = True
    m_bSoloEnEmpresa = True
    m_prns_id = csNO_ID
    m_Rub_id = csNO_ID
    m_pr_id = csNO_ID
    m_depl_id = csNO_ID
    m_Series = vbNullString
    m_Rubro = vbNullString
    m_producto = vbNullString
    m_deposito = vbNullString
    m_FechaIni = Date
    m_FechaFin = Date
    m_cli_id = csNO_ID
    m_Cliente = vbNullString
    m_suc_id = csNO_ID
    m_Sucursal = vbNullString
    m_Us_id_responsable = csNO_ID
    m_Us_id_asignador = csNO_ID
    m_cont_id = csNO_ID
    m_Tarest_id = csNO_ID
    m_Prio_id = csNO_ID
    m_Proy_id = csNO_ID
    m_Estado = vbNullString
    m_Responsable = vbNullString
    m_Asignador = vbNullString
    m_contacto = vbNullString
    m_Prioridad = vbNullString
    m_Proyecto = vbNullString
    
  Else

    rs.MoveLast
    rs.MoveFirst

    Dim i As Integer
    While Not rs.EOF

      Select Case gDB.ValField(rs.Fields, cscLdpId)
        
        Case K_FILTRAR_FECHAS
          m_bFiltrarFechas = Val(gDB.ValField(rs.Fields, cscLdpValor))
        
        Case K_SIN_ASIGNAR
          m_bSinAsignar = Val(gDB.ValField(rs.Fields, cscLdpValor))
        
        Case K_SOLO_EN_EMPRESA
          m_bSoloEnEmpresa = Val(gDB.ValField(rs.Fields, cscLdpValor))
        
        Case K_FECHAINI
          m_FechaIniV = gDB.ValField(rs.Fields, cscLdpValor)
          m_FechaIni = IIf(IsDate(gDB.ValField(rs.Fields, cscLdpValor)), gDB.ValField(rs.Fields, cscLdpValor), Date)
        
        Case K_FECHAFIN
          m_FechaFinV = gDB.ValField(rs.Fields, cscLdpValor)
          m_FechaFin = IIf(IsDate(gDB.ValField(rs.Fields, cscLdpValor)), gDB.ValField(rs.Fields, cscLdpValor), Date)
        
        Case K_PRNS_ID
          m_prns_id = gDB.ValField(rs.Fields, cscLdpValor)
          
        Case K_RUB_ID
          m_Rub_id = gDB.ValField(rs.Fields, cscLdpValor)
        
        Case K_PR_ID
          m_pr_id = gDB.ValField(rs.Fields, cscLdpValor)
          
        Case K_DEPL_ID
          m_depl_id = gDB.ValField(rs.Fields, cscLdpValor)
        
        Case K_CLI_ID
          m_cli_id = gDB.ValField(rs.Fields, cscLdpValor)
        
        Case K_SUC_ID
          m_suc_id = gDB.ValField(rs.Fields, cscLdpValor)
      
        Case K_US_ID_RESPONSABLE
          m_Us_id_responsable = gDB.ValField(rs.Fields, cscLdpValor)
        
        Case K_US_ID_ASIGNADOR
          m_Us_id_asignador = gDB.ValField(rs.Fields, cscLdpValor)
        
        Case K_CONT_ID
          m_cont_id = gDB.ValField(rs.Fields, cscLdpValor)
        
        Case K_TAREST_ID
          m_Tarest_id = gDB.ValField(rs.Fields, cscLdpValor)
        
        Case K_PRIO_ID
          m_Prio_id = gDB.ValField(rs.Fields, cscLdpValor)
        
        Case K_PROY_ID
          m_Proy_id = gDB.ValField(rs.Fields, cscLdpValor)
          
        ' empid
        Case K_EMP_ID
          m_emp_id = gDB.ValField(rs.Fields, cscLdpValor)
      
      End Select

      rs.MoveNext
    Wend

    Dim Data As String
    Dim strLoad As String
    
    strLoad = LNGGetText(2280, vbNullString)
              'Error al cargar los párametros de navegación de Detalle de Equipo
    
    m_FechaIni = IIf(m_FechaIni <> csNoDate, m_FechaIni, Date)
    m_FechaFin = IIf(m_FechaFin <> csNoDate, m_FechaFin, Date)


    If UCase(Left$(m_prns_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTProductoNumeroSerie, cscPrnsId, Val(m_prns_id), cscPrnsCodigo, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Series = Data
    End If
    If UCase(Left$(m_Rub_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTRubro, cscRubId, Val(m_Rub_id), cscRubNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Rubro = Data
    End If
    If UCase(Left$(m_pr_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTProducto, cscPrId, Val(m_pr_id), cscPrNombreventa, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_producto = Data
    End If
    If UCase(Left$(m_depl_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTDepositoLogico, cscDeplId, Val(m_depl_id), cscDeplNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_deposito = Data
    End If

    If UCase(Left$(m_cli_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTCliente, cscCliId, Val(m_cli_id), cscCliNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Cliente = Data
    End If
    If UCase(Left$(m_suc_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTSucursal, cscSucId, Val(m_suc_id), cscSucNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Sucursal = Data
    End If
    
    If UCase(Left$(m_Tarest_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTTareaEstado, cscTarestId, Val(m_Tarest_id), cscTarestNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Estado = Data
    End If
    
    If UCase(Left$(m_Us_id_responsable, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTusuario, cscUsId, Val(m_Us_id_responsable), cscUsNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Responsable = Data
    End If
    
    If UCase(Left$(m_Us_id_asignador, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTusuario, cscUsId, Val(m_Us_id_asignador), cscUsNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Asignador = Data
    End If
    
    If UCase(Left$(m_cont_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTContacto, cscContId, Val(m_cont_id), cscContNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_contacto = Data
    End If
    
    If UCase(Left$(m_Prio_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTPrioridad, cscPrioId, Val(m_Prio_id), cscPrioNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Prioridad = Data
    End If
    
    If UCase(Left$(m_Proy_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTProyecto, cscProyId, Val(m_Proy_id), cscProyNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Proyecto = Data
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
  
      Case K_FILTRAR_FECHAS
        m_bFiltrarFechas = Val(.Item(c_FiltrarFechas).Value)
      
      Case K_SIN_ASIGNAR
        m_bSinAsignar = Val(.Item(c_SinAsignar).Value)
  
      Case K_SOLO_EN_EMPRESA
        m_bSoloEnEmpresa = Val(.Item(c_SoloEnEmpresa).Value)
  
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
    
      Case K_PRNS_ID
        With .Item(cscPrnsId)
          m_Series = .Value
          m_prns_id = .HelpValueProcess
        End With
      
      Case K_RUB_ID
        With .Item(cscRubId)
          m_Rubro = .Value
          m_Rub_id = .HelpValueProcess
        End With
      
      Case K_PR_ID
        With .Item(cscPrId)
          m_producto = .Value
          m_pr_id = .HelpValueProcess
        End With
    
      Case K_DEPL_ID
        With .Item(cscDeplId)
          m_deposito = .Value
          m_depl_id = .HelpValueProcess
        End With
    
      Case K_CLI_ID
        With .Item(cscCliId)
          m_Cliente = .Value
          m_cli_id = .HelpValueProcess
        End With
        
      Case K_SUC_ID
        With .Item(cscSucId)
          m_Sucursal = .Value
          m_suc_id = .HelpValueProcess
        End With
      
      Case K_US_ID_RESPONSABLE
        With .Item(cscUsIdResponsable)
          m_Responsable = .Value
          m_Us_id_responsable = .HelpValueProcess
        End With
        
      Case K_US_ID_ASIGNADOR
        With .Item(cscUsIdAsignador)
          m_Asignador = .Value
          m_Us_id_asignador = .HelpValueProcess
        End With
        
      Case K_CONT_ID
        With .Item(cscContId)
          m_contacto = .Value
          m_cont_id = .HelpValueProcess
        End With
        
      Case K_TAREST_ID
        With .Item(cscTarestId)
          m_Estado = .Value
          m_Tarest_id = .HelpValueProcess
        End With
        
      Case K_PRIO_ID
        With .Item(cscPrioId)
          m_Prioridad = .Value
          m_Prio_id = .HelpValueProcess
        End With
        
      Case K_PROY_ID
        With .Item(cscProyId)
          m_Proyecto = .Value
          m_Proy_id = .HelpValueProcess
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

  sqlstmt = "sp_lsdoc_productoseries "

  sqlstmt = sqlstmt & gDB.UserId & ","

  sqlstmt = sqlstmt & CInt(m_bFiltrarFechas) & ","
  sqlstmt = sqlstmt & CInt(m_bSinAsignar) & ","

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
  
  sqlstmt = sqlstmt & gDB.sqlString(m_prns_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Rub_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_pr_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_depl_id) & ","
  
  sqlstmt = sqlstmt & gDB.sqlString(m_cli_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_suc_id) & ","
  
  sqlstmt = sqlstmt & gDB.sqlString(m_Us_id_responsable) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Us_id_asignador) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_cont_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Tarest_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Prio_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Proy_id) & ","
  
  sqlstmt = sqlstmt & CInt(m_bSoloEnEmpresa) & ","
  
  sqlstmt = sqlstmt & gDB.sqlString(m_emp_id)

  cIABMListDocClient_Refresh = sqlstmt
End Function

Private Function cIABMListDocClient_Save() As Boolean

  Dim strError As String
  
  strError = LNGGetText(2279, vbNullString)
            'Error al grabar los párametros de navegación de Listado de Equipos

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

         Case K_FILTRAR_FECHAS
          register.Fields.Add2 cscLdpValor, Val(.Value), csText
          register.Fields.Add2 cscLdpOrden, 10, csInteger
          register.Fields.Add2 cscLdpId, K_FILTRAR_FECHAS, csInteger

         Case K_SIN_ASIGNAR
          register.Fields.Add2 cscLdpValor, Val(.Value), csText
          register.Fields.Add2 cscLdpOrden, 10, csInteger
          register.Fields.Add2 cscLdpId, K_SIN_ASIGNAR, csInteger

         Case K_SOLO_EN_EMPRESA
          register.Fields.Add2 cscLdpValor, Val(.Value), csText
          register.Fields.Add2 cscLdpOrden, 10, csInteger
          register.Fields.Add2 cscLdpId, K_SOLO_EN_EMPRESA, csInteger

         Case K_FECHAINI
          If .HelpValueProcess <> vbNullString Then
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

        Case K_PRNS_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 40, csInteger
            register.Fields.Add2 cscLdpId, K_PRNS_ID, csInteger
        
        Case K_RUB_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 40, csInteger
            register.Fields.Add2 cscLdpId, K_RUB_ID, csInteger
        
        Case K_PR_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 40, csInteger
            register.Fields.Add2 cscLdpId, K_PR_ID, csInteger
        
        Case K_DEPL_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 40, csInteger
            register.Fields.Add2 cscLdpId, K_DEPL_ID, csInteger
        
        Case K_CLI_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 40, csInteger
            register.Fields.Add2 cscLdpId, K_CLI_ID, csInteger
            
        Case K_SUC_ID
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
            register.Fields.Add2 cscLdpOrden, 70, csInteger
            register.Fields.Add2 cscLdpId, K_SUC_ID, csInteger

        Case K_US_ID_RESPONSABLE
          register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.Fields.Add2 cscLdpOrden, 60, csInteger
          register.Fields.Add2 cscLdpId, K_US_ID_RESPONSABLE, csInteger
          
        Case K_US_ID_ASIGNADOR
          register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.Fields.Add2 cscLdpOrden, 70, csInteger
          register.Fields.Add2 cscLdpId, K_US_ID_ASIGNADOR, csInteger
          
        Case K_CONT_ID
          register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.Fields.Add2 cscLdpOrden, 80, csInteger
          register.Fields.Add2 cscLdpId, K_CONT_ID, csInteger
          
        Case K_TAREST_ID
          register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.Fields.Add2 cscLdpOrden, 90, csInteger
          register.Fields.Add2 cscLdpId, K_TAREST_ID, csInteger
          
        Case K_PRIO_ID
          register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.Fields.Add2 cscLdpOrden, 100, csInteger
          register.Fields.Add2 cscLdpId, K_PRIO_ID, csInteger
          
        Case K_PROY_ID
          register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.Fields.Add2 cscLdpOrden, 110, csInteger
          register.Fields.Add2 cscLdpId, K_PROY_ID, csInteger
        
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
      .Name = "TypeTask"
      .Caption = " "
      With .Icons.Add(Nothing)
      .FormulaType = csCondTNone
      .IconIndex = c_img_task
      End With
      .Width = 500
      .SortType = csSrtTIcon
    End With
    
    With .Columns.Add(Nothing, "Observaciones")
      .Name = "Observaciones"
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
'  MngError err, "", C_Module, ""
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
    m_MenuChangePr = .AddMenu(LNGGetText(3916, vbNullString)) 'Cambiar el Articulo Asociado al Nro. de Serie
    m_MenuEditSerieH = .AddMenu(LNGGetText(3949, vbNullString)) 'Editar el número de serie anterior
    m_MenuUpdateSerie = .AddMenu(LNGGetText(3933, vbNullString)) 'Modificar el número de serie
    m_MenuParteRep = .AddMenu(LNGGetText(3963, vbNullString)) 'Editar parte de reparación
    .AddMenu "-"
    m_MenuAddMensaje = .AddMenu(LNGGetText(1615, vbNullString))    'Agregar Nota
    m_MenuShowMensajes = .AddMenu(LNGGetText(1616, vbNullString))  'Ver Notas
  End With
End Sub

Private Sub pShowMensajes()
  Dim sqlstmt As String
  Dim PrnsId    As Long
  Dim rs      As ADODB.Recordset
  
  PrnsId = m_ObjList.Id
  
  sqlstmt = "sp_ParteDiarioGetTitleForDoc " & csProductoSerie & "," & PrnsId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Dim infodoc As String
  Dim DoctId  As Long
  
  DoctId = csProductoSerie
  infodoc = gDB.ValField(rs.Fields, "info_doc")
  
  sqlstmt = "sp_PartesDiarioGetForDoc " & gDB.UserId & "," & EmpId & "," & DoctId & "," & PrnsId
  ShowNotes LNGGetText(1615, vbNullString, infodoc), sqlstmt
            'Notas sobre Equipos (1)
End Sub

Private Sub pChangePr(ByRef vIds() As Long)
  Dim prns_id As Long
  Dim i       As Long
  
  Dim mouse As cMouse
  Set mouse = New cMouse
  mouse.MouseDefault
  
  If UBound(vIds) < 0 Then
    MsgWarning LNGGetText(3917, vbNullString) ' Debe seleccionar al menos un equipo
    Exit Sub
  End If
  
  Dim help As CSOAPI2.cHelp
  Dim hr As cHelpResult
  
  Set help = New CSOAPI2.cHelp
  
  help.IsSearch = True
  
  Set hr = help.Show(Nothing, 31, "", "", "", , "pr_llevanroserie <> 0" & c_filter_is_for_producto_serie, , , False)
  
  If hr.Cancel Then Exit Sub
  
  Dim sqlstmt As String
  
  m_ObjList.sqlstmt = "sp_lsdoc_ProductoSerie"

  For i = 0 To UBound(vIds)
    
    sqlstmt = "sp_ProductoNumeroSerieChangeProducto " _
                    & vIds(i) & "," _
                    & hr.Id & ",1" ' Indica que se deben cambiar los precios
                    
    If Not gDB.Execute(sqlstmt) Then Exit Sub
    
    m_ObjList.RefreshLine vIds(i)

  Next

End Sub

Private Sub pUpdateSerie(ByRef vIds() As Long)
  Dim prns_id As Long
  Dim i       As Long
  
  Dim mouse As cMouse
  Set mouse = New cMouse
  mouse.MouseDefault
  
  If UBound(vIds) < 0 Then
    MsgWarning LNGGetText(3917, vbNullString) ' Debe seleccionar al menos un equipo
    Exit Sub
  End If
  
  Dim help As CSOAPI2.cHelp
  Dim hr As cHelpResult
  
  Set help = New CSOAPI2.cHelp
  
  help.IsSearch = True
  
  Set hr = help.Show(Nothing, 31, "", "", "", , "pr_llevanroserie <> 0" & c_filter_is_for_producto_serie, , , False)
  
  If hr.Cancel Then Exit Sub
  
  Dim sqlstmt As String
  
  m_ObjList.sqlstmt = "sp_lsdoc_ProductoSerie"

  For i = 0 To UBound(vIds)
    

  Next

End Sub

Private Sub pEditSerieH(ByRef vIds() As Long)
  Dim prns_id As Long
  Dim i       As Long
  
  Dim mouse As cMouse
  Set mouse = New cMouse
  mouse.MouseDefault
  
  If UBound(vIds) < 0 Then
    MsgWarning LNGGetText(3917, vbNullString) ' Debe seleccionar al menos un equipo
    Exit Sub
  End If
    
  m_ObjList.sqlstmt = "sp_lsdoc_ProductoSerie"

  Dim F As fEditSerieH
  
  Set F = New fEditSerieH
  
  For i = 0 To UBound(vIds)
    
    F.ShowForm pGetPrnsCodigo(vIds(i))
    
    If F.Cancel Then Exit For
    
    ' Sino eligio omitir modificamos
    '
    If F.Ok Then
    
      pUpdateNroSerie Val(F.cHelpSerie.Id)
    
    End If

    pUnload F

  Next

End Sub

Private Sub pUnload(ByRef F As Form)
  On Error Resume Next
  Unload F
End Sub

Private Function pGetPrnsCodigo(ByVal prns_id As Long) As String
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  Set rs = New ADODB.Recordset
  sqlstmt = "select prns_codigo from ProductoNumeroSerie where prns_id = " & prns_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  pGetPrnsCodigo = gDB.ValField(rs.Fields, cscPrnsCodigo)
End Function

Private Function pGetPrnsIds() As Long()
  pGetPrnsIds = m_ObjList.SelectedItems
End Function

Private Sub pAddMensaje()
  Dim Parte As Object
  Set Parte = CSKernelClient2.CreateObject("CSEnvio2.cParteDiario")
  
  Parte.AddParteToDoc csProductoSerie, m_ObjList.Id, False
End Sub

Private Sub pUpdateNroSerie(ByVal PrnsId As Long)
  Dim sqlstmt As String
  sqlstmt = "update ProductoNumeroSerie set prns_id_historia = " & PrnsId & " where prns_id = " & PrnsId
  gDB.Execute sqlstmt
End Sub

Private Sub pShowParteReparacion()
  Dim PrnsId As Long
  
  Dim ObjEdit As cParteReparacion
  Set ObjEdit = New cParteReparacion
  
  Dim vIds(0) As Long
  
  PrnsId = m_ObjList.Id
  vIds(0) = PrnsId
  
  ObjEdit.ShowParteReparacion pGetClidFromPrnsId(PrnsId), vIds()
End Sub

Private Function pGetClidFromPrnsId(ByVal PrnsId As Long)
  Dim sqlstmt As String
  sqlstmt = "select cli_id from ProductoNumeroSerie"
End Function
