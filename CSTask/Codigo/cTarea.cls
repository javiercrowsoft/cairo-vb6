VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTarea"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cTarea
' 24-03-02

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cTarea"

Private Const c_strTitle_plantilla = "Plantillas de Requerimientos/Tareas"
Private Const C_LNG_TAREA = "CSTarea2.cTarea.menu"
Private Const C_LNG_TAREA_PLANTILLA = "CSTarea2.cTarea.menu.plantilla"
Private Const C_LNG_TAREA_CFG = "CSTarea2.cTarea.menu.config"
Private Const C_LNG_TAREA_TITLE = "CSTarea2.cTarea.title"
Private Const C_LNG_TAREA_TITLE_PLANTILLA = "CSTarea2.cTarea.title.plantilla"
Private Const C_LNG_TAREA_DELETE = "CSTarea2.cTarea.delete"

Private Const K_NOMBRE             As Integer = 2
Private Const K_DESCRIP            As Integer = 3
Private Const K_FECHAINI           As Integer = 4
Private Const K_FECHAFIN           As Integer = 5
Private Const K_ALARMA             As Integer = 6
Private Const K_FINALIZADA         As Integer = 7
Private Const K_CUMPLIDA           As Integer = 8
Private Const K_RECHAZADA          As Integer = 9
Private Const K_US_ID_RESPONSABLE  As Integer = 10
Private Const K_US_ID_ASIGNADOR    As Integer = 11
Private Const K_CONT_ID            As Integer = 12
Private Const K_TAREST_ID          As Integer = 13
Private Const K_PRIO_ID            As Integer = 14
Private Const K_PROY_ID            As Integer = 15
Private Const K_PROYI_ID           As Integer = 16
Private Const K_OBJE_ID            As Integer = 17
Private Const K_CLI_ID             As Integer = 18
Private Const K_ACTIVO             As Integer = 19
Private Const K_DPTO_ID            As Integer = 20
Private Const K_TAR_ID_PADRE       As Integer = 21
Private Const K_NEW_TAREA          As Integer = 22
Private Const K_SUB_TAREAS         As Integer = 23
Private Const K_NUMERO             As Integer = 24
Private Const K_APROBADA           As Integer = 25

Private Const K_RUB_ID             As Integer = 27
Private Const K_OS_ID              As Integer = 28
Private Const K_PRNS_ID            As Integer = 29
Private Const K_PR_ID              As Integer = 30
Private Const K_CLIS_ID            As Integer = 31
Private Const K_HORAINI            As Integer = 32
Private Const K_HORAFIN            As Integer = 33

Private Const KI_TAR_ID            As Integer = 1
Private Const KI_US_ID             As Integer = 2
Private Const KI_PROY_ID           As Integer = 3
Private Const KI_EST_ID            As Integer = 4

' Seudo - Variables
Private c_strTitle           As String
Private c_ErrorSave          As String

' estructuras
' variables privadas
Private m_Id                 As Long
Private m_tar_id_padre       As Long
Private m_Padre              As String
Private m_Numero             As String
Private m_Nombre             As String
Private m_Descrip            As String
Private m_FechaIni           As Date
Private m_FechaFin           As Date
Private m_Alarma             As Date
Private m_Finalizada         As Boolean
Private m_Cumplida           As Boolean
Private m_Rechazada          As Boolean
Private m_Aprobada           As Boolean
Private m_Us_id_responsable  As Long
Private m_Responsable        As String
Private m_Us_id_asignador    As Long

Private m_Departamento       As String
Private m_Dpto_id            As Long

Private m_Asignador          As String
Private m_Cont_id            As Long
Private m_Contacto           As String
Private m_Tarest_id          As Long
Private m_Estado             As String
Private m_Prio_id            As Long
Private m_Prioridad          As String
Private m_Proy_id            As Long
Private m_Proyecto           As String
Private m_Modificado         As Date
Private m_Creado             As Date
Private m_Modifico           As Long
Private m_Activo             As Boolean
Private m_Proyi_id           As Long
Private m_ProyectoItem       As String
Private m_Obje_id            As Long
Private m_Objetivo           As String
Private m_Cli_id             As Long
Private m_Cliente            As String

Private m_plantilla          As Boolean
Private m_rub_id             As Long
Private m_rubro              As String
Private m_numeroserie        As String
Private m_producto           As String
Private m_ordenservicio      As String
Private m_clienteSuc         As String
Private m_fin                As String
Private m_inicio             As String

Private m_Editing       As Boolean

Private m_ObjAbm        As cIABMGeneric
Private m_ObjTree       As Object

Private m_IsNew         As Boolean

Private m_BranchId      As Long
Private m_TreeId        As Long

Private m_Host          As CSMenu.cIMenuHost
Private m_Copy          As Boolean

' propiedades friend
Friend Property Let Plantilla(ByVal rhs As Boolean)
  m_plantilla = rhs
End Property

' propiedades privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscTarNombre)
    .Value = C_CopiaDe & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscTarNombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  cIEditGeneric_Edit csNO_ID
End Function

Private Property Get cIABMClient_Aplication() As String
  cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
  cIABMClient_CanAddDocDigital = m_Id <> csNO_ID
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
  cIABMClient_CanCopy = True
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = True
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
  On Error GoTo ControlError
  
  If m_Id = csNO_ID Then Exit Function
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = csTTarea
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  Dim Filter As String
  
  cIABMClient_PropertyChange = True
  
  Select Case Key
    Case K_FINALIZADA
      If Val(m_ObjAbm.Properties(cscTarFinalizada).Value) <> 0 Then
        m_ObjAbm.Properties(cscTarCumplida).Enabled = True
        m_ObjAbm.Properties(cscTarRechazada).Enabled = True
      Else
        m_ObjAbm.Properties(cscTarCumplida).Enabled = False
        m_ObjAbm.Properties(cscTarRechazada).Enabled = False
      End If
      
    Case K_PROY_ID
      With m_ObjAbm.Properties
        Filter = "proy_id = " & .Item(cscProyId).HelpId
        ValidateHelp cscProyIId, csProyectoItem, .Item(cscProyId).HelpId, Filter
        ValidateHelp cscObjeId, csObjetivo, .Item(cscObjeId).HelpId, Filter
        ValidateHelp cscTarIdPadre, cstblTarea, .Item(cscTarIdPadre).HelpId, "t." & Filter
        ValidateHelp cscTarestId, csTareaEstado, .Item(cscTarestId).HelpId, .Item(cscProyId).HelpId
      End With
      
    Case K_CLI_ID
      With m_ObjAbm.Properties
        Filter = "(cli_id = " & .Item(cscCliId).HelpId & " or proy_publico <> 0)"
        ValidateHelp cscProyId, csProyecto, .Item(cscProyId).HelpId, Filter
        Filter = "proy_id = " & .Item(cscProyId).HelpId
        ValidateHelp cscProyIId, csProyectoItem, .Item(cscProyIId).HelpId, Filter
        ValidateHelp cscObjeId, csObjetivo, .Item(cscObjeId).HelpId, Filter
        ValidateHelp cscTarIdPadre, cstblTarea, .Item(cscTarIdPadre).HelpId, "t." & Filter
        ValidateHelp cscTarestId, csTareaEstado, .Item(cscTarestId).HelpId, .Item(cscProyId).HelpId
      End With
      
    Case K_NEW_TAREA
      pAddSubTarea
      
    Case Else
      cIABMClient_PropertyChange = False
  End Select
End Function

Private Sub ValidateHelp(ByVal Key As String, ByVal Table As Long, ByVal Id As Long, ByVal Filter As String)
  Dim help As CSOAPI2.cHelp
  Dim hr As CSOAPI2.cHelpResult

  Set help = New CSOAPI2.cHelp

  With m_ObjAbm.Properties(Key)
    
    If Table = csProyecto Or Table = cstblTarea Then
      Filter = gDB.sqlString(Filter)
    End If
    
    .HelpFilter = Filter
    
    Set hr = help.ValidateEx(Table, .Value, Id, Filter)
    If hr.Cancel Then
      .Value = vbNullString
      .HelpId = csNO_ID
    End If
  End With
End Sub

Private Function cIABMClient_Save() As Boolean
  Dim proy_id    As Long
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  
  With register
    Set fields = .fields
      
    .fieldId = cscTarId
    .Table = csTTarea
  
    If m_Copy Then
      .Id = csNew
    Else
      .Id = m_Id
    End If
  End With
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          fields.Add2 cscTarNombre, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscTarDescrip, .Value, csText
        Case K_FECHAINI
          fields.Add2 cscTarfechaini, .Value, csDate
        Case K_FECHAFIN
          fields.Add2 cscTarfechafin, .Value, csDate
        Case K_ALARMA
          fields.Add2 cscTarAlarma, .Value, csDate
        Case K_FINALIZADA
          fields.Add2 cscTarFinalizada, .Value, csBoolean
        Case K_CUMPLIDA
          fields.Add2 cscTarCumplida, .Value, csBoolean
        Case K_RECHAZADA
          fields.Add2 cscTarRechazada, .Value, csBoolean
        Case K_US_ID_RESPONSABLE
          fields.Add2 cscUsIdResponsable, .HelpId, csId
        Case K_US_ID_ASIGNADOR
          fields.Add2 cscUsIdAsignador, .HelpId, csId
        Case K_CONT_ID
          fields.Add2 cscContId, .HelpId, csId
        Case K_TAREST_ID
          fields.Add2 cscTarestId, .HelpId, csId
        Case K_PRIO_ID
          fields.Add2 cscPrioId, .HelpId, csId
        Case K_PROY_ID
          proy_id = .HelpId
          fields.Add2 cscProyId, proy_id, csId
        Case K_PROYI_ID
          fields.Add2 cscProyIId, .HelpId, csId
        Case K_OBJE_ID
          fields.Add2 cscObjeId, .HelpId, csId
        Case K_CLI_ID
          fields.Add2 cscCliId, .HelpId, csId
        Case K_DPTO_ID
          fields.Add2 cscDptoId, .HelpId, csId
        Case K_TAR_ID_PADRE
          fields.Add2 cscTarIdPadre, .HelpId, csId
        Case K_APROBADA
          fields.Add2 cscTarAprobada, pGetAprobada(), csBoolean

        Case K_RUB_ID
          fields.Add2 cscRubId, .HelpId, csId
        
        Case K_ACTIVO
          fields.Add2 cscActivo, Val(.Value), csBoolean
      End Select
    End With
  Next
  
  fields.Add2 cscTarPlantilla, CInt(m_plantilla), csBoolean
  
  If m_IsNew Then
    fields.Add2 cscUsIdalta, User.Id, csId
  End If
  
  ' Obtengo el numero de esta tarea
  '
  Dim bUpdateTal As Boolean
  Dim tar_numero As String
  Dim ta_id      As Long
  
  If register.Id = csNew Then
    pSetNumero tar_numero, proy_id, ta_id
    fields.Add2 cscTarNumero, tar_numero, csText
    bUpdateTal = True
    register.BeginTrans gDB
  End If

  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  Dim sqlstmt As String
  sqlstmt = "sp_TareaSave " & register.Id
  If Not gDB.Execute(sqlstmt) Then Exit Function
  
  If bUpdateTal Then
    If pUpdateTalonario(ta_id, tar_numero) Then
      register.CommitTrans
    Else
      register.RollbackTrans
    End If
  End If
  
  m_Copy = False
  cIABMClient_Save = Load(register.Id)
End Function

Private Sub pSetNumero(ByRef tar_numero As String, ByVal proy_id As Long, ByRef ta_id As Long)
  
  If Not gDB.GetData(csTProyecto, cscProyId, proy_id, cscTaId, ta_id) Then Exit Sub
  
  If ta_id = csNO_ID Then Exit Sub
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_talonarioGetNextNumber " & ta_id & ",'',1"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  tar_numero = gDB.ValField(rs.fields, 0)
End Sub

Private Function pUpdateTalonario(ByVal ta_id As Long, _
                                  ByVal tar_numero As String) As Boolean
  Dim sqlstmt As String
  sqlstmt = "sp_TalonarioSet " & ta_id & "," & gDB.sqlString(tar_numero)
  If Not gDB.Execute(sqlstmt) Then Exit Function
  pUpdateTalonario = True
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  m_ObjTree.sqlstmt = "sp_lsdoc_tarea"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = pGetTitle(m_plantilla)
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1855, vbNullString) 'Debe indicar un titulo
            Exit Function
          End If
        Case K_FECHAINI
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(2441, vbNullString) 'Debe indicar un fecha de inicio
            Exit Function
          End If
        Case K_FECHAFIN
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(2674, vbNullString) 'Debe indicar un Fecha de finalización
            Exit Function
          End If
        Case K_PROY_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2643, vbNullString) 'Debe indicar un proyecto
            Exit Function
          End If
        Case K_PROYI_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2644, vbNullString) 'Debe indicar un sub proyecto
            Exit Function
          End If
        Case K_OBJE_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2645, vbNullString) 'Debe indicar un objetivo
            Exit Function
          End If
        Case K_CLI_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1563, vbNullString) 'Debe indicar un cliente
            Exit Function
          End If
      End Select
    End With
  Next

  If Not pValidatePermiso() Then Exit Function

  cIABMClient_Validate = True
End Function

Private Function pValidatePermiso() As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_ProyectoValidatePermiso " _
              & User.Id & "," & IIf(m_IsNew, csNO_ID, m_Id) & "," _
              & m_ObjAbm.Properties.Item(cscProyId).HelpId & "," & IIf(m_IsNew, csTNewTarea, csTEditTarea)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  If Val(gDB.ValField(rs.fields, 0)) = 0 Then
    MsgWarning LNGGetText(2675, vbNullString)
                'Ud. no tiene permiso para agregar o modificar Tareas de este Proyecto.
    Exit Function
  End If
  
  pValidatePermiso = True
End Function

'-------------------------------------------------------------------------------------
' Implementacion de cIABMClientGrid
Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean

End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean

End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean

End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  cIABMClientGrid_IsEmptyRow = True
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  cIABMClientGrid_ValidateRow = True
End Function

'-------------------------------------------------------------------------------------
' Implementacion de cIEditGeneric
Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Property Let cIEditGeneric_TreeId(ByVal rhs As Long)
  m_TreeId = rhs
End Property

Private Property Get cIEditGeneric_TreeId() As Long
  cIEditGeneric_TreeId = m_TreeId
End Property

Private Function cIEditGeneric_GridAdd(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
  If m_plantilla Then
    cIEditGeneric_ShowList = SecurityCanAccess(csPreTareaListTareaPlantilla)
  Else
    cIEditGeneric_ShowList = SecurityCanAccess(csPreTareaListTarea)
  End If
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  If m_plantilla Then
    If Not SecurityCanAccess(csPreTareaDeleteTareaPlantilla) Then Exit Function
  Else
    If Not SecurityCanAccess(csPreTareaDeleteTarea) Then Exit Function
  End If
  
  Dim sqlstmt As String
  
  sqlstmt = "sp_tareaDelete " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If m_plantilla Then
      If Not SecurityCanAccess(csPreTareaNewTareaPlantilla) Then Exit Function
    Else
      If Not SecurityCanAccess(csPreTareaNewTarea) Then Exit Function
    End If
  Else
    m_IsNew = False
    If m_plantilla Then
      If Not SecurityCanAccess(csPreTareaEditTareaPlantilla) Then Exit Function
    Else
      If Not SecurityCanAccess(csPreTareaEditTarea) Then Exit Function
    End If
  End If

  m_ObjAbm.InModalWindow = InModalWindow
  
  If Not Load(Id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  m_Editing = True
  m_Copy = False
  
  ' JMA I
  If InModalWindow Then
    cIEditGeneric_Edit = m_Id <> csNO_ID
  Else
    cIEditGeneric_Edit = True
  End If
' JMA I

  Exit Function
ControlError:
  MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal Id As Long) As Boolean

End Function

Private Property Set cIEditGeneric_ObjTree(rhs As Object)
  Set m_ObjTree = rhs
End Property

Private Function cIEditGeneric_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)
  m_BranchId = rhs
End Property

Private Property Get cIEditGeneric_BranchId() As Long
  cIEditGeneric_BranchId = m_BranchId
End Property

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Function cIEditGeneric_Preview(ByVal Id As Long) As Boolean

End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  Dim iTab As cIABMTabItem
  
  m_ObjAbm.Properties.Clear
  m_ObjAbm.Tabs.Clear
  
  Set iTab = m_ObjAbm.Tabs.Add(iTab)
  iTab.Index = 0
  iTab.Name = C_strGeneral
  Set iTab = Nothing
  
  Set iTab = m_ObjAbm.Tabs.Add(iTab)
  iTab.Index = 1
  iTab.Name = LNGGetText(2676, vbNullString)  'Servicios
  Set iTab = Nothing
  
  Set iTab = m_ObjAbm.Tabs.Add(iTab)
  iTab.Index = 2
  iTab.Name = LNGGetText(2677, vbNullString)  'Sub Tareas
  Set iTab = Nothing

  If m_plantilla Then

    Set iTab = m_ObjAbm.Tabs.Add(iTab)
    iTab.Index = 3
    iTab.Name = LNGGetText(2581, vbNullString)  'Configuración
    Set iTab = Nothing
  End If
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTarNumero)
  c.PropertyType = cspText
  c.Enabled = False
  c.FontBold = True
  c.Name = LNGGetText(1065, vbNullString)  'Número
  c.Top = 140
  c.Left = 8250
  c.Width = 2000
  c.LeftLabel = -800
  c.LeftNotChange = True
  c.TopNotChange = True
  c.Value = m_Numero
  c.Key = K_NUMERO

  Set c = m_ObjAbm.Properties.Add(Nothing, cscCliId)
  c.PropertyType = cspHelp
  c.Table = csCliente
  c.Name = LNGGetText(1150, vbNullString)  'Cliente
  c.Left = 1450
  c.Key = K_CLI_ID
  c.Value = m_Cliente
  c.HelpId = m_Cli_id
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscProyId)
  c.PropertyType = cspHelp
  c.Table = csProyecto
  c.Name = LNGGetText(1658, vbNullString)  'Proyecto
  c.Key = K_PROY_ID
  c.HelpFilter = "'(cli_id = " & m_Cli_id & " or proy_publico <> 0)'"
  c.Value = m_Proyecto
  c.HelpId = m_Proy_id
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscProyIId)
  c.PropertyType = cspHelp
  c.Table = csProyectoItem
  c.Name = LNGGetText(2652, vbNullString)  'Sub Proyecto
  c.HelpFilter = "proy_id = " & m_Proy_id
  c.Key = K_PROYI_ID
  c.Value = m_ProyectoItem
  c.HelpId = m_Proyi_id
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscObjeId)
  c.PropertyType = cspHelp
  c.Table = csObjetivo
  c.Name = LNGGetText(2651, vbNullString)  'Objetivo
  c.HelpFilter = "proy_id = " & m_Proy_id
  c.Key = K_OBJE_ID
  c.Value = m_Objetivo
  c.HelpId = m_Obje_id
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPrioId)
  c.PropertyType = cspHelp
  c.Table = csPrioridad
  c.Name = LNGGetText(1825, vbNullString)  'Prioridad
  c.Key = K_PRIO_ID
  c.Value = m_Prioridad
  c.HelpId = m_Prio_id
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscUsIdAsignador)
  c.PropertyType = cspHelp
  c.TopFromProperty = cscCliId
  c.Left = 4900
  c.LeftLabel = -1100
  c.Table = csUsuario
  c.Name = LNGGetText(1824, vbNullString)  'Asignada por
  c.Key = K_US_ID_ASIGNADOR
  c.Value = m_Asignador
  c.HelpId = m_Us_id_asignador
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscUsIdResponsable)
  c.PropertyType = cspHelp
  c.Table = csUsuario
  c.Name = LNGGetText(1822, vbNullString)  'Responsable
  c.Key = K_US_ID_RESPONSABLE
  c.Value = m_Responsable
  c.HelpId = m_Us_id_responsable
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscDptoId)
  c.PropertyType = cspHelp
  c.Table = csDepartamento
  c.Name = LNGGetText(1278, vbNullString)  'Departamento
  c.Key = K_DPTO_ID
  c.Value = m_Departamento
  c.HelpId = m_Dpto_id
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTarestId)
  c.PropertyType = cspHelp
  c.Table = csTareaEstado
  c.Name = LNGGetText(1568, vbNullString)  'Estado
  c.Key = K_TAREST_ID
  c.Value = m_Estado
  c.HelpId = m_Tarest_id
  c.HelpFilter = m_Proy_id
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTarIdPadre)
  c.PropertyType = cspHelp
  c.Table = cstblTarea
  c.Name = LNGGetText(2678, vbNullString)  'Tarea Principal
  c.Key = K_TAR_ID_PADRE
  c.Width = 6050
  c.Value = m_Padre
  c.HelpId = m_tar_id_padre
  c.HelpFilter = "'t.proy_id = " & m_Proy_id & "'"
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTarfechaini)
  c.PropertyType = cspDate
  c.TopFromProperty = cscCliId
  c.Left = 8400
  c.LeftLabel = -1000
  c.Name = LNGGetText(2361, vbNullString)  'Fecha Inicio
  c.Key = K_FECHAINI
  c.Value = m_FechaIni
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTarfechafin)
  c.PropertyType = cspDate
  c.TopToPrevious = -1
  c.LeftToPrevious = 2750
  c.LeftLabel = -250
  c.Name = LNGGetText(2338, vbNullString)  'Fin
  c.Key = K_FECHAFIN
  c.Value = m_FechaFin
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTarAlarma)
  c.PropertyType = cspDate
  c.Name = LNGGetText(2339, vbNullString)  'Alarma
  c.Key = K_ALARMA
  c.Value = m_Alarma
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscActivo)
  c.PropertyType = cspCheck
  c.TopFromProperty = cscTarAlarma
  c.TopNotChange = True
  c.LeftNotChange = True
  c.LeftFromProperty = cscTarAlarma
  c.LeftToPrevious = 2200
  c.LeftLabel = -700
  c.Width = 600
  c.Name = C_strActivo
  c.Key = K_ACTIVO
  c.Value = CInt(m_Activo)
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTarAprobada)
  c.PropertyType = cspCheck
  c.Name = LNGGetText(2679, vbNullString)  'Aprobada
  c.Key = K_APROBADA
  c.Value = CInt(m_Aprobada)
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTarFinalizada)
  c.PropertyType = cspCheck
  c.Name = LNGGetText(2680, vbNullString)  'Finalizada
  c.Width = 600
  c.Key = K_FINALIZADA
  c.Value = m_Finalizada
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTarCumplida)
  c.PropertyType = cspOption
  c.OptionGroup = 0
  c.Left = 0
  c.TopNotChange = True
  c.Name = LNGGetText(2363, vbNullString)  'Cumplida
  c.Enabled = m_Finalizada
  c.Width = 1000
  c.Key = K_CUMPLIDA
  c.Value = m_Cumplida
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTarRechazada)
  c.PropertyType = cspOption
  c.OptionGroup = 0
  c.LeftFrame = 8700
  c.LeftNotChange = True
  c.TopFromProperty = cscTarCumplida
  c.LeftFromProperty = cscTarCumplida
  c.LeftToPrevious = 1200
  c.TopNotChange = True
  c.TopFrame = 2250
  c.Width = 1200
  c.Name = LNGGetText(2681, vbNullString)  'Rechazada
  c.Enabled = m_Finalizada
  c.Key = K_RECHAZADA
  c.Value = m_Rechazada
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscContId)
  c.PropertyType = cspHelp
  c.Table = csContacto
  c.Name = LNGGetText(1035, vbNullString)  'Contacto
  c.Key = K_CONT_ID
  c.Value = m_Contacto
  c.HelpId = m_Cont_id
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTarNombre)
  c.PropertyType = cspText
  c.TopFromProperty = cscPrioId
  c.TopToPrevious = 440
  c.LeftFromProperty = cscObjeId
  c.Name = LNGGetText(1864, vbNullString)  'Titulo
  c.Width = 9500
  c.Size = 50
  c.Key = K_NOMBRE
  c.Value = m_Nombre
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTarDescrip)
  c.PropertyType = cspText
  c.Width = 9500
  c.Height = 1200
  c.SubType = cspMemo
  c.Name = C_strDescrip
  c.Size = 7000
  c.Key = K_DESCRIP
  c.Value = m_Descrip

  Set c = m_ObjAbm.Properties.Add(Nothing, "subtask")
  c.PropertyType = cspButton
  c.Width = 2800
  c.LeftLabel = -1
  c.Name = "Agregar sub-tarea"
  c.Key = K_NEW_TAREA
  c.Enabled = m_Id <> csNO_ID

  Set c = m_ObjAbm.Properties.Add(Nothing, "tasks")
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  If Not pLoadSubTareas(c) Then Exit Function
  c.Name = "Sub Tareas"
  c.Key = K_SUB_TAREAS
  c.TabIndex = 2
  c.GridAdd = False
  c.GridEdit = False
  c.GridRemove = False

  Set c = m_ObjAbm.Properties.Add(Nothing, cscOsNrodoc)
  c.PropertyType = cspText
  c.Enabled = False
  c.FontBold = True
  c.Left = 2100
  c.LeftLabel = -1800
  c.Name = LNGGetText(2682, vbNullString)  'Orden de Servicio
  c.Value = m_ordenservicio
  c.Key = K_PRNS_ID
  c.TabIndex = 1
  c.Width = 5000
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPrNombreVenta)
  c.PropertyType = cspText
  c.Enabled = False
  c.FontBold = True
  c.LeftLabel = -1800
  c.Name = LNGGetText(2683, vbNullString)  'Producto/Equipo
  c.Value = m_producto
  c.Key = K_PR_ID
  c.TabIndex = 1
  c.Width = 5000
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscClisNombre)
  c.PropertyType = cspText
  c.Enabled = False
  c.FontBold = True
  c.LeftLabel = -1800
  c.Name = LNGGetText(1761, vbNullString)  'Sucursal/Departamento
  c.Value = m_clienteSuc
  c.Key = K_CLIS_ID
  c.TabIndex = 1
  c.Width = 5000
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTarhoraini)
  c.PropertyType = cspText
  c.Enabled = False
  c.FontBold = True
  c.LeftLabel = -1800
  c.Name = LNGGetText(2337, vbNullString)  'Inicio
  c.Value = m_inicio
  c.Key = K_HORAINI
  c.TabIndex = 1
  c.Width = 5000
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTarFechahorafin)
  c.PropertyType = cspText
  c.Enabled = False
  c.FontBold = True
  c.LeftLabel = -1800
  c.Name = LNGGetText(2338, vbNullString)  'Fin
  c.Value = m_fin
  c.Key = K_HORAFIN
  c.TabIndex = 1
  c.Width = 5000
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPrnsCodigo)
  c.PropertyType = cspText
  c.Enabled = False
  c.FontBold = True
  c.LeftLabel = -1800
  c.Name = LNGGetText(2684, vbNullString)  'Nro. Serie/Inventario
  c.Value = m_numeroserie
  c.Key = K_PRNS_ID
  c.TabIndex = 1
  c.Width = 5000

  If m_plantilla Then
  
    Set c = m_ObjAbm.Properties.Add(Nothing, cscRubId)
    c.PropertyType = cspHelp
    c.Table = csRubro
    c.Name = LNGGetText(1299, vbNullString)  'Rubro
    c.Left = 1450
    c.Key = K_RUB_ID
    c.Value = m_rubro
    c.HelpId = m_rub_id
    c.TabIndex = 3
    c.Width = 3500
  
  End If

  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 6600
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function pLoadSubTareas(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_tareaGetSubTarea " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadSubTareas", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Visible = False
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1836, vbNullString)  'Tarea
  o.Key = KI_TAR_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1137, vbNullString)  'Usuario
  o.Key = KI_US_ID
             
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1658, vbNullString)  'Proyecto
  o.Key = KI_PROY_ID

  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1568, vbNullString)  'Estado
  o.Key = KI_EST_ID

  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscTarId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscTarId)
    fv.Key = KI_TAR_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscTarNombre)
    fv.Key = KI_TAR_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscUsNombre)
    fv.Key = KI_US_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscProyNombre)
    fv.Key = KI_PROY_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscTarestNombre)
    fv.Key = KI_EST_ID
    
    rs.MoveNext
  Wend
  
  pLoadSubTareas = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  Dim sqlstmt As String
  Dim Hora    As Integer
  
  sqlstmt = "sp_tareaGet " & Id
  
  Dim rs As ADODB.Recordset
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
  
  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscTarId)
    m_tar_id_padre = gDB.ValField(rs.fields, cscTarIdPadre)
    m_Padre = gDB.ValField(rs.fields, "padre")
    
    m_Numero = gDB.ValField(rs.fields, cscTarNumero)
    m_Nombre = gDB.ValField(rs.fields, cscTarNombre)
    m_Descrip = gDB.ValField(rs.fields, cscTarDescrip)
    m_FechaIni = gDB.ValField(rs.fields, cscTarfechaini)
    m_FechaFin = gDB.ValField(rs.fields, cscTarfechafin)
    m_Alarma = gDB.ValField(rs.fields, cscTarAlarma)
    m_Aprobada = gDB.ValField(rs.fields, cscTarAprobada)
    m_Finalizada = gDB.ValField(rs.fields, cscTarFinalizada)
    m_Cumplida = gDB.ValField(rs.fields, cscTarCumplida)
    m_Rechazada = gDB.ValField(rs.fields, cscTarRechazada)
    m_Us_id_responsable = gDB.ValField(rs.fields, cscUsIdResponsable)
    m_Us_id_asignador = gDB.ValField(rs.fields, cscUsIdAsignador)
    m_Cont_id = gDB.ValField(rs.fields, cscContId)
    m_Tarest_id = gDB.ValField(rs.fields, cscTarestId)
    m_Prio_id = gDB.ValField(rs.fields, cscPrioId)
    m_Proy_id = gDB.ValField(rs.fields, cscProyId)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_Proyi_id = gDB.ValField(rs.fields, cscProyIId)
    m_Obje_id = gDB.ValField(rs.fields, cscObjeId)
    m_Cli_id = gDB.ValField(rs.fields, cscCliId)
    m_Dpto_id = gDB.ValField(rs.fields, cscDptoId)
    
    m_Estado = gDB.ValField(rs.fields, cscTarestNombre)
    m_Responsable = gDB.ValField(rs.fields, "Res")
    m_Asignador = gDB.ValField(rs.fields, "Asig")
    m_Contacto = gDB.ValField(rs.fields, cscContNombre)
    m_Prioridad = gDB.ValField(rs.fields, cscPrioNombre)
    m_Proyecto = gDB.ValField(rs.fields, cscProyNombre)

    m_ProyectoItem = gDB.ValField(rs.fields, cscProyINombre)
    m_Objetivo = gDB.ValField(rs.fields, cscObjeNombre)
    m_Cliente = gDB.ValField(rs.fields, cscCliNombre)
    m_Departamento = gDB.ValField(rs.fields, cscDptoNombre)
    
    m_plantilla = gDB.ValField(rs.fields, cscTarPlantilla)
    m_rub_id = gDB.ValField(rs.fields, cscRubId)
    m_rubro = gDB.ValField(rs.fields, cscRubNombre)
    m_producto = gDB.ValField(rs.fields, cscPrNombreVenta)
    m_clienteSuc = gDB.ValField(rs.fields, cscClisNombre)
    m_ordenservicio = gDB.ValField(rs.fields, cscOsNrodoc)
    m_numeroserie = gDB.ValField(rs.fields, cscPrnsCodigo)
    
    Hora = gDB.ValField(rs.fields, cscTarhoraini)
    m_inicio = Format$(gDB.ValField(rs.fields, cscTarfechaini), "dd/mm/yyyy") & " " & _
               Format$(Hora / 100, "00") & ":" & Format$(Hora Mod 100, "00")
    m_fin = Format$(gDB.ValField(rs.fields, cscTarFechahorafin), "dd/mm/yyyy hh:nn")
    
  Else
    
    m_Id = csNO_ID
    m_Numero = vbNullString
    m_Nombre = vbNullString
    m_Descrip = vbNullString
    m_FechaIni = Date
    m_FechaFin = Date
    m_Alarma = csNoDate
    m_Aprobada = False
    m_Finalizada = False
    m_Cumplida = False
    m_Rechazada = False
    m_Us_id_responsable = csNO_ID
    m_Us_id_asignador = csNO_ID
    m_Cont_id = csNO_ID
    m_Tarest_id = csNO_ID
    m_Prio_id = csNO_ID
    m_Proy_id = csNO_ID
    m_Modificado = csNoDate
    m_Creado = csNoDate
    m_Modifico = 0
    m_Activo = True
    m_Estado = vbNullString
    m_Responsable = vbNullString
    m_Asignador = vbNullString
    m_Contacto = vbNullString
    m_Prioridad = vbNullString
    m_Proyecto = vbNullString

    m_rub_id = csNO_ID
    m_rubro = vbNullString
    m_producto = vbNullString
    m_clienteSuc = vbNullString
    m_ordenservicio = vbNullString
    m_numeroserie = vbNullString

    m_inicio = vbNullString
    m_fin = vbNullString

    m_Proyi_id = csNO_ID
    m_Obje_id = csNO_ID
    m_Cli_id = csNO_ID
    m_Dpto_id = csNO_ID

    m_ProyectoItem = vbNullString
    m_Objetivo = vbNullString
    m_Cliente = vbNullString
    m_Departamento = vbNullString
    
    m_tar_id_padre = csNO_ID
    m_Padre = vbNullString

  End If

  Load = True

End Function

Private Function pAddSubTarea() As Boolean
  Dim c           As cIABMProperty
  Dim tar_id      As Long
  Dim tar_nombre  As String
  
  tar_id = m_Id
  tar_nombre = m_ObjAbm.Properties.Item(cscTarNombre).Value

  If Not Load(csNO_ID) Then Exit Function

  m_tar_id_padre = tar_id
  m_Padre = tar_nombre

  Set c = m_ObjAbm.Properties.Item(cscTarNumero)
  c.Value = m_Numero

  Set c = m_ObjAbm.Properties.Item(cscCliId)
  c.Value = m_Cliente
  c.HelpId = m_Cli_id
  
  Set c = m_ObjAbm.Properties.Item(cscProyId)
  c.HelpFilter = "'cli_id = " & m_Cli_id & "'"
  c.Value = m_Proyecto
  c.HelpId = m_Proy_id
  
  Set c = m_ObjAbm.Properties.Item(cscProyIId)
  c.HelpFilter = "proy_id = " & m_Proy_id
  c.Value = m_ProyectoItem
  c.HelpId = m_Proyi_id
  
  Set c = m_ObjAbm.Properties.Item(cscObjeId)
  c.HelpFilter = "proy_id = " & m_Proy_id
  c.Value = m_Objetivo
  c.HelpId = m_Obje_id
  
  Set c = m_ObjAbm.Properties.Item(cscPrioId)
  c.Value = m_Prioridad
  c.HelpId = m_Prio_id
  
  Set c = m_ObjAbm.Properties.Item(cscUsIdAsignador)
  c.Value = m_Asignador
  c.HelpId = m_Us_id_asignador
  
  Set c = m_ObjAbm.Properties.Item(cscUsIdResponsable)
  c.Value = m_Responsable
  c.HelpId = m_Us_id_responsable
  
  Set c = m_ObjAbm.Properties.Item(cscDptoId)
  c.Value = m_Departamento
  c.HelpId = m_Dpto_id
  
  Set c = m_ObjAbm.Properties.Item(cscTarestId)
  c.Value = m_Estado
  c.HelpId = m_Tarest_id
  c.HelpFilter = m_Proy_id
  
  Set c = m_ObjAbm.Properties.Item(cscTarIdPadre)
  c.Value = m_Padre
  c.HelpId = m_tar_id_padre
  
  Set c = m_ObjAbm.Properties.Item(cscTarfechaini)
  c.Value = m_FechaIni
  
  Set c = m_ObjAbm.Properties.Item(cscTarfechafin)
  c.Value = m_FechaFin
  
  Set c = m_ObjAbm.Properties.Item(cscTarAlarma)
  c.Value = m_Alarma
  
  Set c = m_ObjAbm.Properties.Item(cscActivo)
  c.Value = CInt(m_Activo)
  
  Set c = m_ObjAbm.Properties.Item(cscTarFinalizada)
  c.Value = m_Finalizada
  
  Set c = m_ObjAbm.Properties.Item(cscTarCumplida)
  c.Value = m_Cumplida
  
  Set c = m_ObjAbm.Properties.Item(cscTarRechazada)
  c.Value = m_Rechazada
  
  Set c = m_ObjAbm.Properties.Item(cscContId)
  c.Value = m_Contacto
  c.HelpId = m_Cont_id
  
  Set c = m_ObjAbm.Properties.Item(cscTarNombre)
  c.Value = m_Nombre
  
  Set c = m_ObjAbm.Properties.Item(cscTarDescrip)
  c.Value = m_Descrip

  Set c = m_ObjAbm.Properties.Item("tasks")
  c.Grid.Rows.Clear
  
  Set c = m_ObjAbm.Properties.Item("subtask")
  c.Enabled = False

  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.ShowValues m_ObjAbm.Properties
  
  pAddSubTarea = True
End Function

'/////////////////////////////////////////////////////////////
' Menu
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_1755  As String
  Dim str_2685  As String
  
  str_1755 = LNGGetText(1755, vbNullString)  'Se&rvicios
  str_2685 = LNGGetText(2685, vbNullString)  '&Tareas
  
  #If Not PREPROC_NO_MENU_ICON Then
    Dim lIconIndex As Long
    Set m_Host = Host
    lIconIndex = m_Host.AddIcon(LoadResPicture(101, LoadResConstants.vbResIcon))
    m_Host.Server.AddMenu str_1755, csMenuProyecto, vbNullString, 1, False, False, False, True, False, Nothing
    m_Host.Server.AddMenu str_2685, csPreTareaListTarea, str_1755, 0, True, False, False, False, False, Me, lIconIndex
  
  #Else
    Set m_Host = Host
    m_Host.Server.AddMenu str_1755, csMenuProyecto, vbNullString, 1, False, False, False, True, False, Nothing
    m_Host.Server.AddMenu str_2685, csPreTareaListTarea, str_1755, 0, True, False, False, False, False, Me
    
    If SecurityCanAccessSilent(csPreTareaListTareaPlantilla) Then
      m_Host.Server.AddMenu str_1755, csMenuConfig, LNGGetText(1028, vbNullString), 0, True, False, True, False, True, Nothing
                                                    'Co&nfiguración
      m_Host.Server.AddMenu LNGGetText(2686, vbNullString), csPreTareaListTareaPlantilla, str_1755, 0, True, False, False, False, False, Me
                            '&Plantillas de Tareas
    End If
    
  #End If
  
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  If Id = csPreTareaListTarea Then
    m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", "CSTarea2.cTarea", "CSABMInterface2.CABMGenericListDoc", "CSTarea2.cTareaListDoc", Me, pGetTitle(False), 0
  Else
    m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", "CSTarea2.cTareaPlantilla", "CSABMInterface2.CABMGenericListDoc", "CSTarea2.cTareaPListDoc", Me, pGetTitle(True), 0
  End If
End Function

Private Function pGetAprobada() As Integer
  Dim llevaAprob As Boolean
  
  With m_ObjAbm.Properties
    If Not gDB.GetData(csTProyecto, _
                       cscProyId, _
                       .Item(cscProyId).HelpId, _
                       cscProyLlevaAprobacion, _
                       llevaAprob) Then Exit Function
    If llevaAprob Then
      pGetAprobada = .Item(cscTarAprobada).Value
    Else
      pGetAprobada = 1
    End If
  End With
End Function

Private Function pGetTitle(ByVal Plantilla As Boolean) As String
  If Plantilla Then
    pGetTitle = LENGGetText(C_LNG_TAREA_TITLE_PLANTILLA, c_strTitle_plantilla)
  Else
    pGetTitle = LENGGetText(C_LNG_TAREA_TITLE, c_strTitle)
  End If
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_strTitle = LNGGetText(2687, vbNullString) 'Requerimientos/Tareas
  c_ErrorSave = LNGGetText(1818, vbNullString) 'Error al grabar Tarea
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub
