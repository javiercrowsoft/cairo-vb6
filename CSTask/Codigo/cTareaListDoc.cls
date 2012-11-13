VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTareaListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient

'--------------------------------------------------------------------------------
' cTareaListDoc
' 25-03-02

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cTareaListDoc"

Private Const K_FECHAINI             As Integer = 4
Private Const K_FECHAFIN             As Integer = 5
Private Const K_FINALIZADA           As Integer = 7
Private Const K_CUMPLIDA             As Integer = 8
Private Const K_RECHAZADA            As Integer = 9
Private Const K_US_ID_RESPONSABLE    As Integer = 10
Private Const K_US_ID_ASIGNADOR      As Integer = 11
Private Const K_CONT_ID              As Integer = 12
Private Const K_TAREST_ID            As Integer = 13
Private Const K_PRIO_ID              As Integer = 14
Private Const K_ACTIVO               As Integer = 18
Private Const K_PROY_ID              As Integer = 19

' Seudo - Variables
Private c_strLoad             As String
Private c_ErrorSave           As String

' estructuras
' variables privadas
Private m_ObjAbm              As cIABMGenericListDoc
Private m_ObjList             As Object

Private m_Us_id               As Long

Private m_FechaIniV           As String
Private m_FechaFinV           As String

Private m_FechaIni           As Date
Private m_FechaFin           As Date
Private m_Finalizada         As Integer
Private m_Cumplida           As Integer
Private m_Rechazada          As Integer

Private m_Us_id_responsable  As String
Private m_Responsable        As String
Private m_Us_id_asignador    As String
Private m_Asignador          As String
Private m_Cont_id            As String
Private m_Contacto           As String
Private m_Tarest_id          As String
Private m_Estado             As String
Private m_Prio_id            As String
Private m_Prioridad          As String
Private m_Proy_id            As String
Private m_Proyecto           As String
Private m_Activo             As Integer
Private m_Properties         As cABMDocProperties

Private m_bPlantillas        As Boolean

Private m_MenuLoaded        As Boolean

Private m_MenuShowMensajes  As Long
Private m_MenuShowInfoCli   As Long
Private m_MenuAddMensaje    As Long

' propiedades publicas
Public Property Let Plantillas(ByVal rhs As Boolean)
  m_bPlantillas = rhs
End Property
' propiedades privadas
' funciones publicas
Public Function ProcessMenu(ByVal Index As Long)
  On Error GoTo ControlError

  Select Case Index
  
    Case m_MenuShowInfoCli
      HelpShowInfo csCliente, pGetCliId()
    
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
    Set iProp = m_ObjAbm.Properties(cscTarfechaini)

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
    Set iProp = m_ObjAbm.Properties(cscTarfechafin)
    
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
    
  Case K_FINALIZADA
    m_Finalizada = m_ObjAbm.Properties(cscTarFinalizada).ListItemData
  Case K_CUMPLIDA
    m_Cumplida = m_ObjAbm.Properties(cscTarCumplida).ListItemData
  Case K_RECHAZADA
    m_Rechazada = m_ObjAbm.Properties(cscTarRechazada).ListItemData
  Case K_US_ID_RESPONSABLE
    m_Us_id_responsable = m_ObjAbm.Properties(cscUsIdResponsable).HelpValueProcess
  Case K_US_ID_ASIGNADOR
    m_Us_id_asignador = m_ObjAbm.Properties(cscUsIdAsignador).HelpValueProcess
  Case K_CONT_ID
    m_Cont_id = m_ObjAbm.Properties(cscContId).HelpValueProcess
  Case K_TAREST_ID
    m_Tarest_id = m_ObjAbm.Properties(cscTarestId).HelpValueProcess
  Case K_PRIO_ID
    m_Prio_id = m_ObjAbm.Properties(cscPrioId).HelpValueProcess
  Case K_ACTIVO
    m_Activo = m_ObjAbm.Properties(cscActivo).ListItemData
  Case K_PROY_ID
    m_Proy_id = m_ObjAbm.Properties(cscProyId).HelpValueProcess
  End Select
  
  cIABMListDocClient_PropertyChange = True
End Function

Private Function cIABMListDocClient_Refresh() As String
  Dim sqlstmt As String
  
  sqlstmt = "sp_lsdoc_tareas "
  
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
  
  sqlstmt = sqlstmt & m_Finalizada & ","
  sqlstmt = sqlstmt & m_Cumplida & ","
  sqlstmt = sqlstmt & m_Rechazada & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Us_id_responsable) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Us_id_asignador) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Cont_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Tarest_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Prio_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Proy_id) & ","
  sqlstmt = sqlstmt & m_Activo & ","
  sqlstmt = sqlstmt & IIf(m_bPlantillas, 1, 0)
  
  cIABMListDocClient_Refresh = sqlstmt
End Function

Private Function cIABMListDocClient_Save() As Boolean
  Dim register As cRegister
  Set register = New cRegister
  
  Dim sqlstmt As String
  sqlstmt = "delete ListaDocumentoParametro " & _
            " where pre_id = " & csPreTareaListTarea & _
              " and us_id = " & m_Us_id

  If Not gDB.Execute(sqlstmt, "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
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
          
        Case K_FINALIZADA
          register.fields.Add2 cscLdpValor, .ListItemData, csText
          register.fields.Add2 cscLdpOrden, 30, csInteger
          register.fields.Add2 cscLdpId, K_FINALIZADA, csInteger
          
        Case K_CUMPLIDA
          register.fields.Add2 cscLdpValor, .ListItemData, csText
          register.fields.Add2 cscLdpOrden, 40, csInteger
          register.fields.Add2 cscLdpId, K_CUMPLIDA, csInteger
          
        Case K_RECHAZADA
          register.fields.Add2 cscLdpValor, .ListItemData, csText
          register.fields.Add2 cscLdpOrden, 50, csInteger
          register.fields.Add2 cscLdpId, K_RECHAZADA, csInteger
          
        Case K_US_ID_RESPONSABLE
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 60, csInteger
          register.fields.Add2 cscLdpId, K_US_ID_RESPONSABLE, csInteger
          
        Case K_US_ID_ASIGNADOR
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 70, csInteger
          register.fields.Add2 cscLdpId, K_US_ID_ASIGNADOR, csInteger
          
        Case K_CONT_ID
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 80, csInteger
          register.fields.Add2 cscLdpId, K_CONT_ID, csInteger
          
        Case K_TAREST_ID
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 90, csInteger
          register.fields.Add2 cscLdpId, K_TAREST_ID, csInteger
          
        Case K_PRIO_ID
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 100, csInteger
          register.fields.Add2 cscLdpId, K_PRIO_ID, csInteger
          
        Case K_ACTIVO
          register.fields.Add2 cscLdpValor, .ListItemData, csText
          register.fields.Add2 cscLdpOrden, 110, csInteger
          register.fields.Add2 cscLdpId, K_ACTIVO, csInteger
          
        Case K_PROY_ID
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 110, csInteger
          register.fields.Add2 cscLdpId, K_PROY_ID, csInteger
          
      End Select
      
  
      register.fields.Add2 cscUsId, m_Us_id, csId
      register.fields.Add2 cscPreID, csPreTareaListTarea, csId
  
      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False
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
  If m_bPlantillas Then
    cIABMListDocClient_Title = "Plantillas de Tareas"
  Else
    cIABMListDocClient_Title = "Tareas"
  End If
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

Private Property Set cIEditGenericListDoc_ObjAbm(rhs As CSInterfacesABM.cIABMGenericListDoc)
  Set m_ObjAbm = rhs
End Property

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

Private Property Set cIEditGenericListDoc_ObjList(rhs As Object)
  Set m_ObjList = rhs
End Property

Private Function cIEditGenericListDoc_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_TabClick(ByVal Index As Integer) As Boolean

End Function

' funciones privadas
Public Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  Dim o As cIABMListItem
  Dim Value As String
  Dim bExists As Boolean
  
  m_ObjAbm.Properties.Clear
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTarfechaini)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1203, vbNullString) 'Fecha desde
  c.Key = K_FECHAINI
  If LenB(m_FechaIniV) Then
    c.Value = m_FechaIniV
  Else
    c.Value = m_FechaIni
  End If
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTarfechafin)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1203, vbNullString) 'Fecha hasta
  c.Key = K_FECHAFIN
  If LenB(m_FechaFinV) Then
    c.Value = m_FechaFinV
  Else
    c.Value = m_FechaFin
  End If
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTarFinalizada)
  c.PropertyType = cspList
  c.Name = LNGGetText(2680, vbNullString) 'Finalizada
  c.Key = K_FINALIZADA
  c.ListWhoSetItem = csListItemData
  c.ListItemData = m_Finalizada
    
    Set o = New CSABMInterface2.cABMListItem
    o.Id = csTriLogicState.csTLBoth
    o.Value = LNGGetText(2426, vbNullString) 'Ambas
    c.List.Add o, csTriLogicState.csTLBoth
    
    Set o = New CSABMInterface2.cABMListItem
    o.Id = csTriLogicState.csTLNo
    o.Value = LNGGetText(2373, vbNullString) 'Pendientes
    c.List.Add o, csTriLogicState.csTLNo
    
    Set o = New CSABMInterface2.cABMListItem
    o.Id = csTriLogicState.csTLYes
    o.Value = LNGGetText(2692, vbNullString) 'Finalizadas
    c.List.Add o, csTriLogicState.csTLYes
  
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTarCumplida)
  c.PropertyType = cspList
  c.Name = LNGGetText(2363, vbNullString) 'Cumplida
  c.Key = K_CUMPLIDA
  c.ListWhoSetItem = csListItemData
  c.ListItemData = m_Cumplida
    
    Set o = New CSABMInterface2.cABMListItem
    o.Id = csTriLogicState.csTLBoth
    o.Value = LNGGetText(2426, vbNullString) 'Ambas
    c.List.Add o, csTriLogicState.csTLBoth
    
    Set o = New CSABMInterface2.cABMListItem
    o.Id = csTriLogicState.csTLNo
    o.Value = LNGGetText(2373, vbNullString) 'Pendientes
    c.List.Add o, csTriLogicState.csTLNo
    
    Set o = New CSABMInterface2.cABMListItem
    o.Id = csTriLogicState.csTLYes
    o.Value = LNGGetText(2694, vbNullString) 'Cumplidas
    c.List.Add o, csTriLogicState.csTLYes
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTarRechazada)
  c.PropertyType = cspList
  c.Name = LNGGetText(2681, vbNullString) 'Rechazada
  c.Key = K_RECHAZADA
  c.ListWhoSetItem = csListItemData
  c.ListItemData = m_Rechazada
    
    Set o = New CSABMInterface2.cABMListItem
    o.Id = csTriLogicState.csTLBoth
    o.Value = LNGGetText(2426, vbNullString) 'Ambas
    c.List.Add o, csTriLogicState.csTLBoth
    
    Set o = New CSABMInterface2.cABMListItem
    o.Id = csTriLogicState.csTLNo
    o.Value = LNGGetText(2373, vbNullString) 'Pendientes
    c.List.Add o, csTriLogicState.csTLNo
    
    Set o = New CSABMInterface2.cABMListItem
    o.Id = csTriLogicState.csTLYes
    o.Value = LNGGetText(2693, vbNullString) 'Rechazadas
    c.List.Add o, csTriLogicState.csTLYes
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscProyId)
  c.PropertyType = cspHelp
  c.Table = csProyecto
  c.Name = LNGGetText(1658, vbNullString) 'Proyecto
  c.Key = K_PROY_ID
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
  c.Table = csUsuario
  c.Name = LNGGetText(1822, vbNullString) 'Responsable
  c.Key = K_US_ID_RESPONSABLE
  Value = m_Responsable
  If UCase(Left$(m_Us_id_responsable, 1)) = KEY_NODO Then
    Value = GetNombreRama(csUsuario, Val(Mid(m_Us_id_responsable, 2)), bExists)
    If Not bExists Then m_Us_id_responsable = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_Us_id_responsable)
  c.HelpValueProcess = m_Us_id_responsable
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscUsIdAsignador)
  c.PropertyType = cspHelp
  c.Table = csUsuario
  c.Name = LNGGetText(1824, vbNullString) 'Asignada por
  c.Key = K_US_ID_ASIGNADOR
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
  c.Table = csContacto
  c.Name = LNGGetText(1035, vbNullString) 'Contacto
  c.Key = K_CONT_ID
  Value = m_Contacto
  If UCase(Left$(m_Cont_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csContacto, Val(Mid(m_Cont_id, 2)), bExists)
    If Not bExists Then m_Cont_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_Cont_id)
  c.HelpValueProcess = m_Cont_id
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTarestId)
  c.PropertyType = cspHelp
  c.Table = csTareaEstado
  c.Name = LNGGetText(1568, vbNullString) 'Estado
  c.Key = K_TAREST_ID
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
  c.Table = csPrioridad
  c.Name = LNGGetText(1825, vbNullString) 'Prioridad
  c.Key = K_PRIO_ID
  
  Value = m_Prioridad
  If UCase(Left$(m_Prio_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csPrioridad, Val(Mid(m_Prio_id, 2)), bExists)
    If Not bExists Then m_Prio_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_Prio_id)
  c.HelpValueProcess = m_Prio_id
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscActivo)
  c.PropertyType = cspList
  c.Name = C_strActivo
  c.Key = K_ACTIVO
  c.ListWhoSetItem = csListItemData
  c.ListItemData = m_Activo
    
    Set o = New CSABMInterface2.cABMListItem
    o.Id = csTriLogicState.csTLBoth
    o.Value = LNGGetText(2426, vbNullString) 'Ambas
    c.List.Add o, csTriLogicState.csTLBoth
    
    Set o = New CSABMInterface2.cABMListItem
    o.Id = csTriLogicState.csTLNo
    o.Value = LNGGetText(2427, vbNullString) 'Inactivas
    c.List.Add o, csTriLogicState.csTLNo
    
    Set o = New CSABMInterface2.cABMListItem
    o.Id = csTriLogicState.csTLYes
    o.Value = LNGGetText(2428, vbNullString) 'Activas
    c.List.Add o, csTriLogicState.csTLYes
  
  pCreateMenu
  If Not m_ObjAbm.Show(Me, m_ObjList) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Us_id As Long) As Boolean
  Dim sqlstmt As String
  
  sqlstmt = "select * from ListaDocumentoParametro " & _
            " where us_id = " & Us_id & _
              " and pre_id = " & csPreTareaListTarea & _
            " order by " & cscLdpOrden
  
  Dim rs As ADODB.Recordset
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
  
  If rs.EOF Then
    
    m_FechaIni = Date
    m_FechaFin = Date
    m_FechaIniV = vbNullString
    m_FechaFinV = vbNullString
    m_Finalizada = csTriLogicState.csTLBoth
    m_Cumplida = csTriLogicState.csTLBoth
    m_Rechazada = csTriLogicState.csTLBoth
    m_Us_id_responsable = csNO_ID
    m_Us_id_asignador = csNO_ID
    m_Cont_id = csNO_ID
    m_Tarest_id = csNO_ID
    m_Prio_id = csNO_ID
    m_Proy_id = csNO_ID
    m_Activo = csTriLogicState.csTLBoth
    m_Estado = vbNullString
    m_Responsable = vbNullString
    m_Asignador = vbNullString
    m_Contacto = vbNullString
    m_Prioridad = vbNullString
    m_Proyecto = vbNullString

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
        Case K_FINALIZADA
          m_Finalizada = Val(gDB.ValField(rs.fields, cscLdpValor))
        Case K_CUMPLIDA
          m_Cumplida = Val(gDB.ValField(rs.fields, cscLdpValor))
        Case K_RECHAZADA
          m_Rechazada = Val(gDB.ValField(rs.fields, cscLdpValor))
        Case K_US_ID_RESPONSABLE
          m_Us_id_responsable = gDB.ValField(rs.fields, cscLdpValor)
        Case K_US_ID_ASIGNADOR
          m_Us_id_asignador = gDB.ValField(rs.fields, cscLdpValor)
        Case K_CONT_ID
          m_Cont_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_TAREST_ID
          m_Tarest_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_PRIO_ID
          m_Prio_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_ACTIVO
          m_Activo = Val(gDB.ValField(rs.fields, cscLdpValor))
        Case K_PROY_ID
          m_Proy_id = gDB.ValField(rs.fields, cscLdpValor)
      
      End Select
      
      rs.MoveNext
    Wend
    
    Dim Data As String
    
    m_FechaFin = IIf(m_FechaFin <> csNoDate, m_FechaFin, Date)
    m_FechaIni = IIf(m_FechaIni <> csNoDate, m_FechaIni, Date)
    
    If UCase(Left$(m_Tarest_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTTareaEstado, cscTarestId, Val(m_Tarest_id), cscTarestNombre, Data, C_LoadFunction, C_Module, c_strLoad) Then Exit Function
      m_Estado = Data
    End If
    
    If UCase(Left$(m_Us_id_responsable, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTusuario, cscUsId, Val(m_Us_id_responsable), cscUsNombre, Data, C_LoadFunction, C_Module, c_strLoad) Then Exit Function
      m_Responsable = Data
    End If
    
    If UCase(Left$(m_Us_id_asignador, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTusuario, cscUsId, Val(m_Us_id_asignador), cscUsNombre, Data, C_LoadFunction, C_Module, c_strLoad) Then Exit Function
      m_Asignador = Data
    End If
    
    If UCase(Left$(m_Cont_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTContacto, cscContId, Val(m_Cont_id), cscContNombre, Data, C_LoadFunction, C_Module, c_strLoad) Then Exit Function
      m_Contacto = Data
    End If
    
    If UCase(Left$(m_Prio_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTPrioridad, cscPrioId, Val(m_Prio_id), cscPrioNombre, Data, C_LoadFunction, C_Module, c_strLoad) Then Exit Function
      m_Prioridad = Data
    End If
    
    If UCase(Left$(m_Proy_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTProyecto, cscProyId, Val(m_Proy_id), cscProyNombre, Data, C_LoadFunction, C_Module, c_strLoad) Then Exit Function
      m_Proyecto = Data
    End If
  End If

  Load = True

End Function
' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError
 
  c_strLoad = LNGGetText(2695, vbNullString)
              'Error al cargar los parámetros de navegación de Tarea
  c_ErrorSave = LNGGetText(2696, vbNullString)
              'Error al grabar los parámetros de navegación de Tarea
 
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
    m_MenuShowInfoCli = .AddMenu(LNGGetText(1614, vbNullString))     'Ver Info del Cliente
    m_MenuAddMensaje = .AddMenu(LNGGetText(1615, vbNullString))      'Agregar Nota
    m_MenuShowMensajes = .AddMenu(LNGGetText(1616, vbNullString))    'Ver Notas
  End With
End Sub

Private Sub pShowMensajes()
  Dim sqlstmt As String
  Dim TarId    As Long
  Dim rs      As ADODB.Recordset
  
  TarId = m_ObjList.Id
  
  sqlstmt = "sp_ParteDiarioGetTitleForDoc " & cstblTarea & "," & TarId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Dim infodoc As String
  Dim DoctId  As Long
  
  DoctId = cstblTarea
  infodoc = gDB.ValField(rs.fields, "info_doc")
  
  sqlstmt = "sp_PartesDiarioGetForDoc " & gDB.UserId & "," & EmpId & "," & DoctId & "," & TarId
  ShowNotes LNGGetText(2088, vbNullString, infodoc), sqlstmt
            'Notas sobre Tareas  & infodoc
End Sub

Private Sub pAddMensaje()
  Dim Parte As Object
  Set Parte = CSKernelClient2.CreateObject("CSEnvio2.cParteDiario")
  
  Parte.AddParteToDoc cstblTarea, m_ObjList.Id, False
End Sub

Private Function pGetCliId() As Long
  On Error Resume Next
  
  Dim HoraId  As Long
  Dim CliId As Long
  
  HoraId = m_ObjList.Id
  gDB.GetData csTHora, cscHoraId, HoraId, cscCliId, CliId
  
  pGetCliId = CliId
End Function

