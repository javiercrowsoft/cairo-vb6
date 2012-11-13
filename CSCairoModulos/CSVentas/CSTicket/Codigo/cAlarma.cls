VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAlarma"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cAlarma
' 03-07-2003

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cAlarma"

Private Const c_fechas = "fechas"
Private Const c_semanal = "semanal"
Private Const c_mensual = "mensual"
Private Const c_Items = "Items"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_DIATIPO                        As Integer = 8

Private Const K_HORASXDIAS                     As Integer = 120

Private Const K_CLI_ID                         As Integer = 9
Private Const K_CLIS_ID                        As Integer = 10
Private Const K_PROY_ID                        As Integer = 11
Private Const K_RUB_ID                         As Integer = 12
Private Const K_ACTIVO                         As Integer = 13

Private Const K_FECHAS                         As Integer = 14
Private Const K_SEMANAS                        As Integer = 15
Private Const K_MESES                          As Integer = 16

Private Const KI_ALF_ID                        As Integer = 1
Private Const KI_ID                            As Integer = 1
Private Const KI_DIA                           As Integer = 2 ' Tienen el mismo ki adrede
Private Const KI_FECHA                         As Integer = 2
Private Const KI_HORADESDE                     As Integer = 3
Private Const KI_HORAHASTA                     As Integer = 4
Private Const KI_ACTIVO                        As Integer = 5

Private Const K_ITEMS                           As Integer = 17

Private Const KI_ALI_ID                         As Integer = 2
Private Const KI_NOMBRE                         As Integer = 3
Private Const KI_TIEMPO                         As Integer = 4
Private Const KI_TIEMPOTIPO                     As Integer = 5
Private Const KI_TIEMPODESDE                    As Integer = 6
Private Const KI_OBLIGATORIOREMITO              As Integer = 7
Private Const KI_OBLIGATORIOFACTURA             As Integer = 8
Private Const KI_ALARMA1                        As Integer = 9
Private Const KI_ALARMATIPO1                    As Integer = 10
Private Const KI_ALARMA2                        As Integer = 11
Private Const KI_ALARMATIPO2                    As Integer = 12
Private Const KI_ALIT_ID                        As Integer = 13
Private Const KI_DPTO_ID                        As Integer = 14
Private Const KI_SECUENCIA                      As Integer = 15
Private Const KI_LABORAL                        As Integer = 16

Private Const KI_MAIL_ID_INICIO                 As Integer = 17
Private Const KI_MAIL_ID_ALARMA1                As Integer = 18
Private Const KI_MAIL_ID_ALARMA2                As Integer = 19
Private Const KI_MAIL_ID_FINALIZADO             As Integer = 20
Private Const KI_MAIL_ID_VENCIDO                As Integer = 21

Private Const KI_TIPO                           As Integer = 22

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_Descrip                      As String
Private m_Diatipo                      As Integer
Private m_horasxdia                    As Integer

Private m_cli_id                       As Long
Private m_Cliente                      As String
Private m_clis_id                      As Long
Private m_Sucursal                     As String
Private m_Proy_id                      As Long
Private m_Proyecto                     As String
Private m_Rub_id                       As Long
Private m_Rubro                        As String
Private m_Activo                       As Boolean

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

Private m_ItemsDeletedFechas     As String
Private m_ItemsDeleted           As String
  
' Properties publicas
' Properties privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscAlNombre)
    .Value = C_CopiaDe & .Value
  End With
    
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscAlNombre)
  
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

  Doc.ClientTable = csAlarma
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

Private Function cIABMClient_PropertyChange(ByVal key As Integer) As Boolean
  Dim Filter As String
  
  cIABMClient_PropertyChange = True
  
  Select Case key
    Case K_CLI_ID
      With m_ObjAbm.Properties
        Filter = "cli_id = " & .Item(cscCliId).HelpId
        ValidateHelp cscProyId, csProyecto, .Item(cscProyId).HelpId, Filter
        ValidateHelp cscClisId, csSucursalCliente, .Item(cscClisId).HelpId, Filter
      End With
    
    Case K_DIATIPO
      Dim bSemanal As Boolean
      
      With m_ObjAbm.Properties
        bSemanal = .Item(cscAlDiatipo).ListItemData = csE_ADTSemana
        .Item(c_semanal).Enabled = bSemanal
        .Item(c_mensual).Enabled = Not bSemanal
        Dim AbmObj As cABMGeneric
        Set AbmObj = m_ObjAbm
        AbmObj.ShowValue .Item(c_semanal), True
        AbmObj.ShowValue .Item(c_mensual), True
      End With
    
      cIABMClient_PropertyChange = False
    
    Case Else
      cIABMClient_PropertyChange = False
  End Select
End Function

Private Sub ValidateHelp(ByVal key As String, ByVal table As Long, ByVal Id As Long, ByVal Filter As String)
  Dim help As CSOAPI2.cHelp
  Dim hr As CSOAPI2.cHelpResult

  Set help = New CSOAPI2.cHelp

  With m_ObjAbm.Properties(key)
    
    If table = csProyecto Or table = cstblTarea Then
      Filter = gDB.sqlString(Filter)
    End If
      
    .HelpFilter = Filter
    
    Set hr = help.ValidateEx(table, .Value, Id, Filter)
    If hr.Cancel Then
      .Value = vbNullString
      .HelpId = csNO_ID
    End If
  End With
End Sub

Private Function cIABMClient_Save() As Boolean
  Dim register   As cRegister
  Dim Fields     As cFields
  Dim bSemanal   As Boolean
  Dim sqlstmt    As String
  
  Set register = New cRegister
  
  With register
  
    Set Fields = .Fields
    
    .fieldId = cscAlId
    .table = csTAlarma
  
    If m_Copy Then
      .Id = csNew
    Else
      .Id = m_Id
    End If
  End With
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .key
        Case K_NOMBRE
          Fields.Add2 cscAlNombre, .Value, csText
        Case K_CODIGO
          Fields.Add2 cscAlCodigo, .Value, csText
        Case K_DESCRIP
          Fields.Add2 cscAlDescrip, .Value, csText
        Case K_CLI_ID
          Fields.Add2 cscCliId, .HelpId, csId
        Case K_PROY_ID
          Fields.Add2 cscProyId, .HelpId, csId
        Case K_HORASXDIAS
          Fields.Add2 cscAlHorasxDia, .Value, csDouble
        Case K_DIATIPO
          bSemanal = .ListItemData = csE_ADTSemana
          Fields.Add2 cscAlDiatipo, .ListItemData, csInteger
        Case K_CLIS_ID
          Fields.Add2 cscClisId, .HelpId, csId
        Case K_RUB_ID
          Fields.Add2 cscRubId, .HelpId, csId
        Case K_ACTIVO
          Fields.Add2 cscActivo, .Value, csBoolean
      End Select
    End With
  Next
  
  Fields.HaveLastUpdate = True
  Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
                                                            
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If Not pSaveItems(register.Id) Then Exit Function
  
  If Not pSaveItemsFechas(register.Id) Then Exit Function
  
  If bSemanal Then
  
    If Not pSaveDiasMeses(register.Id, _
                          m_ObjAbm.Properties.Item(c_semanal), _
                          csTAlarmaDiaSemana, _
                          cscAldsId, _
                          cscAldsDia, _
                          cscAldsActivo, _
                          cscAldsDesdehora, _
                          cscAldsDesdeminuto, _
                          cscAldsHastahora, _
                          cscAldsHastaminuto) Then Exit Function
  
    sqlstmt = "Delete AlarmaDiaMes where al_id = " & register.Id
    If Not gDB.Execute(sqlstmt) Then Exit Function
  
  Else
    
    If Not pSaveDiasMeses(register.Id, _
                          m_ObjAbm.Properties.Item(c_mensual), _
                          csTAlarmaDiaMes, _
                          cscAldmId, _
                          cscAldmDia, _
                          cscAldmActivo, _
                          cscAldmDesdehora, _
                          cscAldmDesdeminuto, _
                          cscAldmHastahora, _
                          cscAldmHastaminuto) Then Exit Function
  
    sqlstmt = "Delete AlarmaDiaSemana where al_id = " & register.Id
    If Not gDB.Execute(sqlstmt) Then Exit Function
  
  End If
  
  register.CommitTrans
  
  m_Copy = False
  cIABMClient_Save = Load(register.Id)
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  m_ObjTree.sqlstmt = "sp_lsdoc_alarma"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = LNGGetText(1751, vbNullString)  'Alarmas
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IPropiedad    As cIABMProperty
  
  CSKernelClient2.title = LNGGetText(1751, vbNullString) 'Alarmas
  
  For Each IPropiedad In m_ObjAbm.Properties
    With IPropiedad
      Select Case .key
        
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo C_DebeIndicarNombre  'Debe indicar un nombre
            Exit Function
          End If
        
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            MsgInfo C_DebeIndicarCodigo  'Debe indicar un código
            Exit Function
          End If
        
        Case K_HORASXDIAS
          If Val(.Value) <= 0 Then
            MsgInfo LNGGetText(1752, vbNullString)
                    'No ingrese cuanto rinden sus horas. Ingrese cuantas horas trabaja por día :)
            Exit Function
          ElseIf Val(.Value) > 24 Then
            MsgInfo LNGGetText(1753, vbNullString)
                    'Por mas que intente no va a poder conseguir que su gente trabaje tanto, al menos no en el planeta tierra :).
            Exit Function
          End If
        
      End Select
    End With
  Next
  
  cIABMClient_Validate = True
End Function

' Implementacion de cIEditGeneric
Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreTickListAlarma)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreTickDeleteAlarma) Then Exit Function

    Dim sqlstmt As String
  
    sqlstmt = "sp_AlarmaDelete " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreTickNewAlarma) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreTickEditAlarma) Then Exit Function
  End If
  
  m_ObjAbm.InModalWindow = InModalWindow
  
  If Not Load(Id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  m_Editing = True
  m_Copy = False

  If InModalWindow Then
    cIEditGeneric_Edit = m_Id <> csNO_ID
  Else
    cIEditGeneric_Edit = True
  End If

  Exit Function
ControlError:
  MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal Id As Long) As Boolean

End Function

Private Property Set cIEditGeneric_ObjTree(rhs As Object)
    Set m_ObjTree = rhs
End Property

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)
    m_BranchId = rhs
End Property

Private Property Get cIEditGeneric_BranchId() As Long
    cIEditGeneric_BranchId = m_BranchId
End Property

Private Function cIEditGeneric_Preview(ByVal Id As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal key As Integer) As Boolean

End Function

' Menu Client
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_1028  As String
  Dim str_1851  As String
  Dim str_1754  As String
  
  str_1028 = LNGGetText(1028, vbNullString)   'Co&nfiguración
  str_1851 = LNGGetText(1851, vbNullString)   '&Servicios
  str_1754 = LNGGetText(1754, vbNullString)   '&Alarmas
  
  Set m_Host = Host
  
  #If Not PREPROC_NO_MENU_ICON Then
    Dim lIconIndex As Long
    lIconIndex = m_Host.AddIcon(LoadResPicture(102, LoadResConstants.vbResIcon))
    m_Host.Server.AddMenu str_1851, csMenuConfig, str_1028, 0, True, False, True, False, True, Nothing
    m_Host.Server.AddMenu str_1754, csPreTickListAlarma, str_1851, 0, True, False, False, False, False, Me, lIconIndex
  
  #Else
    m_Host.Server.AddMenu str_1851, csMenuConfig, str_1028, 0, True, False, True, False, True, Nothing
    m_Host.Server.AddMenu str_1754, csPreTickListAlarma, str_1851, 0, True, False, False, False, False, Me
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
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", "CSTicket.cAlarma", "CSABMInterface2.CABMGenericListDoc", "CSTicket.cAlarmaListDoc", Me, LNGGetText(1751, vbNullString), 0
                                                                                                                                                    'Alarmas
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c       As cIABMProperty
  Dim AbmObj  As cABMGeneric
  
  m_ObjAbm.Properties.Clear
  
  Const c_tab_items = 1
  Const c_tab_semanal = 2
  Const c_tab_mensual = 3
  Const c_tab_fechas = 4
  
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 8000

  With m_ObjAbm.Tabs
    
    .Clear
    
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1371, vbNullString)  'Items
      .Index = c_tab_items
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1756, vbNullString)  'Semanal
      .Index = c_tab_semanal
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1757, vbNullString)  'Mensual
      .Index = c_tab_mensual
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1758, vbNullString)  'Fechas Especiales
      .Index = c_tab_fechas
    End With
  
  End With

  With m_ObjAbm.Properties

    With .Add(Nothing, cscAlNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Width = 5000
      .Size = 255
      .key = K_NOMBRE
      .Value = m_Nombre
      .LeftLabel = -1800
      .Left = 2000
    End With
    
    With .Add(Nothing, cscAlCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Width = 2500
      .Size = 255
      .key = K_CODIGO
      .Value = m_Codigo
      .LeftLabel = -1800
    End With
    
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .TopFromProperty = cscAlCodigo
      .LeftNotChange = True
      .Left = 5200
      .LeftLabel = -600
      .Name = C_strActivo
      .key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
    
    With .Add(Nothing, cscAlHorasxDia)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Name = LNGGetText(1760, vbNullString)  'Horas x Día (minutos base 60 ej: 09:30 = 9.3)
      .key = K_HORASXDIAS
      .Value = m_horasxdia
      .LeftLabel = -1800
      .Width = 800
      .LeftNotChange = True
    End With
    
    With .Add(Nothing, cscAlDiatipo)
      .PropertyType = cspList
      .Name = LNGGetText(1759, vbNullString)  'Tipo de Franja Horaria
      With .List
        With .Add(Nothing)
          .Id = csEAlarmaDiaTipo.csE_ADTSemana
          .Value = LNGGetText(1756, vbNullString)  'Semanal
        End With
        With .Add(Nothing)
          .Id = csEAlarmaDiaTipo.csE_ADTMes
          .Value = LNGGetText(1757, vbNullString)  'Mensual
        End With
      End With
      .key = K_DIATIPO
      .ListItemData = m_Diatipo
      .ListWhoSetItem = csListItemData
      .LeftLabel = -1800
    End With
    
    With .Add(Nothing, cscCliId)
      .PropertyType = cspHelp
      .table = csCliente
      .Width = 5000
      .Name = LNGGetText(1150, vbNullString)  'Cliente
      .key = K_CLI_ID
      .Value = m_Cliente
      .HelpId = m_cli_id
      .LeftLabel = -1800
    End With
    
    With .Add(Nothing, cscClisId)
      .PropertyType = cspHelp
      .table = csSucursalCliente
      .Name = LNGGetText(1761, vbNullString)  'Sucursal/Departamento
      .key = K_CLIS_ID
      .Value = m_Sucursal
      .HelpId = m_clis_id
      .HelpFilter = "cli_id = " & m_cli_id
      .LeftLabel = -1800
    End With
    
    With .Add(Nothing, cscProyId)
      .PropertyType = cspHelp
      .table = csProyecto
      .Name = LNGGetText(1762, vbNullString)  'Proyecto/Contrato
      .Width = 5000
      .HelpFilter = "'cli_id = " & m_cli_id & "'"
      .key = K_PROY_ID
      .Value = m_Proyecto
      .HelpId = m_Proy_id
      .LeftLabel = -1800
    End With
    
    With .Add(Nothing, cscRubId)
      .PropertyType = cspHelp
      .table = csRubro
      .Name = LNGGetText(1299, vbNullString)  'Rubro
      .key = K_RUB_ID
      .Value = m_Rubro
      .HelpId = m_Rub_id
      .LeftLabel = -1800
    End With
    
    With .Add(Nothing, cscAlDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = C_strDescrip
      .Width = 5000
      .Size = 255
      .Height = 725
      .key = K_DESCRIP
      .Value = m_Descrip
      .LeftLabel = -1800
    End With
    
    Dim msg As String
    msg = LNGGetText(1763, vbNullString)
    'msg = "Todas las alarmas pasan por cinco estados identificados " & _
          "por los colores verde, amarillo, naranja, rojo y gris a medida que " & _
          "se acercan a su fecha/hora de término." & vbCrLf & vbCrLf & _
          "El verde es el estado inicial, el amarillo y el naranja ocurren cuando " & _
          "falta equis minutos/horas/días para terminar la tarea." & vbCrLf & _
          "El rojo se da cuando la tarea esta vencida y no se ha finalizado." & vbCrLf & _
          "El gris es para las tareas que se han finalizado."
    
    '////////////////////////////////////////////////////////////
    ' Items
    '
    Set c = .Add(Nothing, c_Items)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItems(c) Then Exit Function
      .Name = c_Items
      .key = K_ITEMS
      .TabIndex = c_tab_items
      .Top = 2500
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
  
    With .Add(Nothing)
      .PropertyType = cspLabel
      .Value = msg
      .Width = 7000
      .Height = 1800
      .FontBold = True
      .TabIndex = c_tab_items
      .LeftNotChange = True
      .Left = 500
      .Top = 1000
    End With
    
    '////////////////////////////////////////////////////////////
    ' Semanas
    '
    Set c = .Add(Nothing, c_semanal)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadSemana(c) Then Exit Function
      .Name = c_semanal
      .key = K_SEMANAS
      .TabIndex = c_tab_semanal
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
      .Top = 1000
      .Enabled = m_Diatipo = csE_ADTSemana
    End With
  
    '////////////////////////////////////////////////////////////
    ' Meses
    '
    Set c = .Add(Nothing, c_mensual)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadMes(c) Then Exit Function
      .Name = c_mensual
      .key = K_MESES
      .TabIndex = c_tab_mensual
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
      .Top = 1000
      .Enabled = m_Diatipo = csE_ADTMes
    End With
  
    '////////////////////////////////////////////////////////////
    ' Fechas
    '
    Set c = .Add(Nothing, c_fechas)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadFechas(c) Then Exit Function
      .Name = c_fechas
      .key = K_FECHAS
      .TabIndex = c_tab_fechas
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
      .Top = 1000
    End With
  
    m_ItemsDeletedFechas = vbNullString
    
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "sp_alarmaGet " & Id

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscAlId)
    m_Nombre = gDB.ValField(rs.Fields, cscAlNombre)
    m_Codigo = gDB.ValField(rs.Fields, cscAlCodigo)
    m_Descrip = gDB.ValField(rs.Fields, cscAlDescrip)
    m_Diatipo = gDB.ValField(rs.Fields, cscAlDiatipo)
    m_horasxdia = gDB.ValField(rs.Fields, cscAlHorasxDia)
    
    m_cli_id = gDB.ValField(rs.Fields, cscCliId)
    m_Proy_id = gDB.ValField(rs.Fields, cscProyId)
    m_clis_id = gDB.ValField(rs.Fields, cscClisId)
    m_Rub_id = gDB.ValField(rs.Fields, cscRubId)
    m_Activo = gDB.ValField(rs.Fields, cscActivo)
    
    m_Cliente = gDB.ValField(rs.Fields, cscCliNombre)
    m_Proyecto = gDB.ValField(rs.Fields, cscProyNombre)
    m_Sucursal = gDB.ValField(rs.Fields, cscClisNombre)
    m_Rubro = gDB.ValField(rs.Fields, cscRubNombre)

  Else
  
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Nombre = vbNullString
    m_Descrip = vbNullString
    m_Diatipo = csE_ADTSemana
    m_horasxdia = 9
    
    m_cli_id = csNO_ID
    m_Proy_id = csNO_ID
    m_clis_id = csNO_ID
    m_Rub_id = csNO_ID
    m_Activo = True
    
    m_Cliente = vbNullString
    m_Proyecto = vbNullString
    m_Sucursal = vbNullString
    m_Rubro = vbNullString

  End If

  Load = True
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(1750, vbNullString) 'Error al grabar la Alarma

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

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal key As Integer)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Select Case key
    
    Case K_FECHAS
      Id = Val(pCell(Row, KI_ALF_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedFechas = m_ItemsDeletedFechas & Id & C_StrColon
      
    Case K_ITEMS
      Id = Val(pCell(Row, KI_ALI_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & Id & C_StrColon
      
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case key
    Case K_SEMANAS, K_MESES
      cIABMClientGrid_ValidateRow = True
    Case K_FECHAS
      cIABMClientGrid_ValidateRow = pValidateRowFechas(Row, RowIndex)
    Case K_ITEMS
      cIABMClientGrid_ValidateRow = pValidateRowItems(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Sub cIABMClientGrid_ColumnClick(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_IsEmptyRow(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case key
    Case K_SEMANAS, K_MESES
      cIABMClientGrid_IsEmptyRow = False
    Case K_FECHAS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowFechas(Row, RowIndex)
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowItems(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pSaveItems(ByVal al_id As Long) As Boolean
  Dim register As cRegister
  Dim IProperty As cIABMProperty
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .key
        Case K_ITEMS
        
          Dim Row  As cIABMGridRow
          Dim Cell As cIABMGridCellValue
          
          For Each Row In IProperty.Grid.Rows
          
            Set register = New cRegister
            register.fieldId = cscAliId
            register.table = csTAlarmaItem
            register.Id = csNew
            
            With register.Fields
            
              For Each Cell In Row
                Select Case Cell.key
                  Case KI_ALI_ID
                    If Not m_Copy Then
                      register.Id = Val(Cell.Value)
                    End If
                  Case KI_NOMBRE
                    .Add2 cscAliNombre, Cell.Value, csText
                  Case KI_TIEMPO
                    .Add2 cscAliTiempo, Val(Cell.Value), csInteger
                  Case KI_TIEMPOTIPO
                    .Add2 cscAliTiempotipo, Cell.Id, csInteger
                  Case KI_TIEMPODESDE
                    .Add2 cscAliTiempodesde, Cell.Id, csInteger
                  Case KI_SECUENCIA
                    .Add2 cscAliSecuencia, Val(Cell.Value), csInteger
                  Case KI_LABORAL
                    .Add2 cscAliLaboral, Cell.Id, csInteger
                  Case KI_OBLIGATORIOREMITO
                    .Add2 cscAliObligatorioremito, Cell.Id, csBoolean
                  Case KI_OBLIGATORIOFACTURA
                    .Add2 cscAliObligatoriofactura, Cell.Id, csBoolean
                  Case KI_ALARMA1
                    .Add2 cscAliAlarma1, Val(Cell.Value), csInteger
                  Case KI_ALARMATIPO1
                    .Add2 cscAliAlarmatipo1, Cell.Id, csInteger
                  Case KI_ALARMA2
                    .Add2 cscAliAlarma2, Val(Cell.Value), csInteger
                  Case KI_ALARMATIPO2
                    .Add2 cscAliAlarmatipo2, Cell.Id, csInteger
                  Case KI_MAIL_ID_INICIO
                    .Add2 cscMailIdInicio, Cell.Id, csId
                  Case KI_MAIL_ID_ALARMA1
                    .Add2 cscMailIdAlarma1, Cell.Id, csId
                  Case KI_MAIL_ID_ALARMA2
                    .Add2 cscMailIdAlarma2, Cell.Id, csId
                  Case KI_MAIL_ID_FINALIZADO
                    .Add2 cscMailIdFinalizado, Cell.Id, csId
                  Case KI_MAIL_ID_VENCIDO
                    .Add2 cscMailIdVencido, Cell.Id, csId
                  Case KI_TIPO
                    .Add2 cscAliTipo, Cell.Id, csId
                  Case KI_ALIT_ID
                    .Add2 cscAlitId, Cell.Id, csId
                  Case KI_DPTO_ID
                    .Add2 cscDptoId, Cell.Id, csId
                  
                End Select
              Next
              
              .Add2 cscAlId, al_id, csId
              
              .HaveLastUpdate = False
              .HaveWhoModify = False
              
            End With
                                                                 
            If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
          Next
      End Select
    End With
  Next
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeleted) And Not m_Copy Then
  
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    sqlstmt = "delete AlarmaItem where ali_id in (" & m_ItemsDeleted & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItems", C_Module) Then Exit Function
  End If
  
  pSaveItems = True
End Function

Private Function pSaveItemsFechas(ByVal al_id As Long) As Boolean
  Dim register  As cRegister
  Dim Fields    As cFields
  
  With m_ObjAbm.Properties.Item(c_fechas)
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set Fields = .Fields
        .fieldId = cscAlfId
        .table = csTAlarmaFecha
        .Id = csNew
        
        For Each Cell In Row
          Select Case Cell.key
            
            Case KI_ALF_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
              
            Case KI_FECHA
              Fields.Add2 cscAlfFecha, Cell.Value, csDate
              
            Case KI_HORADESDE
              Fields.Add2 cscAlfDesdehora, Hour(Cell.Value), csInteger
              Fields.Add2 cscAlfDesdeminuto, Minute(Cell.Value), csInteger
              
            Case KI_HORAHASTA
              Fields.Add2 cscAlfHastahora, Hour(Cell.Value), csInteger
              Fields.Add2 cscAlfHastaminuto, Minute(Cell.Value), csInteger

          End Select
        Next
        
        Fields.Add2 cscAlId, al_id, csId
        
      End With
                                                                
      If Not gDB.Save(register, , "pSaveItemsFechas", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedFechas) And Not m_Copy Then
    m_ItemsDeletedFechas = RemoveLastColon(m_ItemsDeletedFechas)
    sqlstmt = "delete alarmafecha where alf_id in (" & m_ItemsDeletedFechas & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsFechas", C_Module) Then Exit Function
  End If
  
  pSaveItemsFechas = True
End Function

Private Function pSaveDiasMeses(ByVal al_id As Long, _
                                ByVal iProp As cIABMProperty, _
                                ByVal table As String, _
                                ByVal fieldId As String, _
                                ByVal fieldDia As String, _
                                ByVal fieldActivo As String, _
                                ByVal fieldDesdeHora As String, _
                                ByVal fieldDesdeMinuto As String, _
                                ByVal fieldHastaHora As String, _
                                ByVal fieldHastaMinuto As String) As Boolean
  Dim register  As cRegister
  Dim Fields    As cFields
  
  With iProp
  
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
      
        Set Fields = .Fields
        .fieldId = fieldId
        .table = table
        .Id = csNew
        
        For Each Cell In Row
          Select Case Cell.key
            
            Case KI_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
              
            Case KI_DIA
              Fields.Add2 fieldDia, Cell.Value, csInteger
              
            Case KI_ACTIVO
              Fields.Add2 fieldActivo, Cell.Id, csBoolean
              
            Case KI_HORADESDE
              Fields.Add2 fieldDesdeHora, Hour(Cell.Value), csInteger
              Fields.Add2 fieldDesdeMinuto, Minute(Cell.Value), csInteger
              
            Case KI_HORAHASTA
              Fields.Add2 fieldHastaHora, Hour(Cell.Value), csInteger
              Fields.Add2 fieldHastaMinuto, Minute(Cell.Value), csInteger

          End Select
        Next
        
        Fields.Add2 cscAlId, al_id, csId
        
      End With
                                                              
      If Not gDB.Save(register, , "pSaveDiasMeses", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  pSaveDiasMeses = True
End Function

Private Function pLoadFechas(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select * from AlarmaFecha where al_id = " & m_Id & " order by alf_fecha"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadFechas", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
      With .Add(Nothing)
        .Visible = False
        .key = KI_ALF_ID
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1569, vbNullString)  'Fecha
        .PropertyType = cspDate
        .Width = 1000
        .key = KI_FECHA
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1767, vbNullString)  'Hora Desde
        .PropertyType = cspTime
        .Width = 1000
        .key = KI_HORADESDE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1768, vbNullString)  'Hora Hasta
        .PropertyType = cspTime
        .Width = 1000
        .key = KI_HORAHASTA
      End With
      
    End With
    
    With .Rows
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscAlfId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscAlfId).Value
            .key = KI_ALF_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscAlfFecha)
            .key = KI_FECHA
          End With
          
          With .Add(Nothing)
            .Value = pGetHora(gDB.ValField(rs.Fields, cscAlfDesdehora), _
                              gDB.ValField(rs.Fields, cscAlfDesdeminuto))
            .key = KI_HORADESDE
          End With
          
          With .Add(Nothing)
            .Value = pGetHora(gDB.ValField(rs.Fields, cscAlfHastahora), _
                              gDB.ValField(rs.Fields, cscAlfHastaminuto))
            .key = KI_HORAHASTA
          End With
        End With
        
        rs.MoveNext
        
      Wend
      
    End With
  End With
  
  pLoadFechas = True
End Function

Private Function pLoadSemana(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim i       As Long
  
  sqlstmt = "select * from AlarmaDiaSemana where al_id = " & m_Id & " order by alds_dia"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadSemana", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    .Rows.Clear
    
    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .key = KI_ID
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1214, vbNullString)  'Día
        .Width = 400
        .key = KI_DIA
      End With
      
      With .Add(Nothing)
        '.Name = vbNullString
        .PropertyType = cspCheck
        .Width = 200
        .key = KI_ACTIVO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1767, vbNullString)  'Hora Desde
        .PropertyType = cspTime
        .Width = 1000
        .key = KI_HORADESDE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1768, vbNullString)  'Hora Hasta
        .PropertyType = cspTime
        .Width = 1000
        .key = KI_HORAHASTA
      End With
      
    End With
    
    With .Rows
  
      If rs.EOF Then
      
        For i = 1 To 7
        
          With .Add(Nothing)
          
            With .Add(Nothing)
              .Value = csNO_ID
              .key = KI_ID
            End With
            
            With .Add(Nothing)
              .Value = i
              .key = KI_DIA
            End With
            
            With .Add(Nothing)
              .key = KI_ACTIVO
            End With
            
            With .Add(Nothing)
              .Value = "09:00"
              .key = KI_HORADESDE
            End With
            
            With .Add(Nothing)
              .Value = "18:00"
              .key = KI_HORAHASTA
            End With
          End With
        Next
      
      Else
  
        While Not rs.EOF
  
          With .Add(Nothing, rs(cscAldsId).Value)
          
            With .Add(Nothing)
              .Value = rs(cscAldsId).Value
              .key = KI_ID
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscAldsDia)
              .key = KI_DIA
            End With
            
            With .Add(Nothing)
              .Id = gDB.ValField(rs.Fields, cscAldsActivo)
              .key = KI_ACTIVO
            End With
            
            With .Add(Nothing)
              .Value = pGetHora(gDB.ValField(rs.Fields, cscAldsDesdehora), _
                                gDB.ValField(rs.Fields, cscAldsDesdeminuto))
              .key = KI_HORADESDE
            End With
            
            With .Add(Nothing)
              .Value = pGetHora(gDB.ValField(rs.Fields, cscAldsHastahora), _
                                gDB.ValField(rs.Fields, cscAldsHastaminuto))
              .key = KI_HORAHASTA
            End With
          End With
          
          rs.MoveNext
          
        Wend
      End If
      
    End With
  End With
  
  pLoadSemana = True
End Function

Private Function pLoadMes(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim i       As Long
  
  sqlstmt = "select * from AlarmaDiaMes where al_id = " & m_Id & " order by aldm_dia"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadMes", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
      With .Add(Nothing)
        .Visible = False
        .key = KI_ID
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1214, vbNullString)  'Día
        .Width = 400
        .key = KI_DIA
      End With
      
      With .Add(Nothing)
        '.Name = vbNullString
        .PropertyType = cspCheck
        .Width = 200
        .key = KI_ACTIVO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1767, vbNullString)  'Hora Desde
        .PropertyType = cspTime
        .Width = 1000
        .key = KI_HORADESDE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1768, vbNullString)  'Hora Hasta
        .PropertyType = cspTime
        .Width = 1000
        .key = KI_HORAHASTA
      End With
      
    End With
    
    With .Rows
  
      If rs.EOF Then
      
        For i = 1 To 31
        
          With .Add(Nothing)
          
            With .Add(Nothing)
              .Value = csNO_ID
              .key = KI_ID
            End With
            
            With .Add(Nothing)
              .Value = i
              .key = KI_DIA
            End With
            
            With .Add(Nothing)
              .key = KI_ACTIVO
            End With
            
            With .Add(Nothing)
              .Value = "09:00"
              .key = KI_HORADESDE
            End With
            
            With .Add(Nothing)
              .Value = "18:00"
              .key = KI_HORAHASTA
            End With
          End With
        Next
      
      Else
  
        While Not rs.EOF
        
          With .Add(Nothing, rs(cscAldmId).Value)
          
            With .Add(Nothing)
              .Value = rs(cscAldmId).Value
              .key = KI_ID
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscAldmDia)
              .key = KI_DIA
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.Fields, cscAldmActivo)
              .key = KI_ACTIVO
            End With
            
            With .Add(Nothing)
              .Value = pGetHora(gDB.ValField(rs.Fields, cscAldmDesdehora), _
                                gDB.ValField(rs.Fields, cscAldmDesdeminuto))
              .key = KI_HORADESDE
            End With
            
            With .Add(Nothing)
              .Value = pGetHora(gDB.ValField(rs.Fields, cscAldmHastahora), _
                                gDB.ValField(rs.Fields, cscAldmHastaminuto))
              .key = KI_HORAHASTA
            End With
          End With
          
          rs.MoveNext
          
        Wend
      
      End If
      
    End With
  End With
  
  pLoadMes = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_AlarmaGetItems " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  With Propiedad.Grid
  
    With .Columns
    
      .Clear
  
      With .Add(Nothing)
        .Visible = False
        .key = KI_ALI_ID
      End With
  
      With .Add(Nothing)
        .PropertyType = cspText
        .Name = C_strNombre
        .key = KI_NOMBRE
      End With
      
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspInteger
        .Name = LNGGetText(1769, vbNullString)  'Tiempo
        .key = KI_TIEMPO
      End With
      
      With .Add(Nothing)
        
        .PropertyType = cspList
        
        With .List
          With .Add(Nothing)
            .Id = csEAlarmaTiempoTipo.csE_ATTHora
            .Value = LNGGetText(1660, vbNullString)  'Horas
          End With
          With .Add(Nothing)
            .Id = csEAlarmaTiempoTipo.csE_ATTDia
            .Value = LNGGetText(1085, vbNullString)  'Dias
          End With
        End With
        
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Id = csEAlarmaTiempoTipo.csE_ATTHora
        .Name = LNGGetText(1223, vbNullString)  'Tipo
        .key = KI_TIEMPOTIPO
      End With
      
      With .Add(Nothing)
        
        .PropertyType = cspList
        
        With .List
          With .Add(Nothing)
            .Id = csEAlarmaTiempoDesde.csE_TDInicio
            .Value = LNGGetText(1770, vbNullString)  'Desde el Inicio
          End With
          With .Add(Nothing)
            .Id = csEAlarmaTiempoDesde.csE_TDPasoAnterior
            .Value = LNGGetText(1771, vbNullString)  'Desde el paso anterior
          End With
        End With
        
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Id = csEAlarmaTiempoDesde.csE_TDInicio
        .Name = LNGGetText(1772, vbNullString)  'Tiempo Desde
        .key = KI_TIEMPODESDE
      End With
      
      With .Add(Nothing)
        .PropertyType = cspList
        
        With .List
          With .Add(Nothing)
            .Id = csEAlarmaTiempoLaboral.csE_TDHabiles
            .Value = LNGGetText(1773, vbNullString)   'Días habiles
          End With
          With .Add(Nothing)
            .Id = csEAlarmaTiempoLaboral.csE_TDDiasCorridos
            .Value = LNGGetText(1774, vbNullString)   'Días corridos
          End With
        End With
        
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Id = csEAlarmaTiempoLaboral.csE_TDHabiles
        .Name = LNGGetText(1775, vbNullString)   'Laboral
        .key = KI_LABORAL
      End With
      
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspInteger
        .Name = LNGGetText(1776, vbNullString)   'Secuencia
        .key = KI_SECUENCIA
      End With
      
      With .Add(Nothing)
        .PropertyType = cspCheck
        .Name = LNGGetText(1777, vbNullString)   'Obligatorio Remito
        .key = KI_OBLIGATORIOREMITO
      End With
      
      With .Add(Nothing)
        .PropertyType = cspCheck
        .Name = LNGGetText(1778, vbNullString)   'Obligatorio Factura
        .key = KI_OBLIGATORIOFACTURA
      End With
      
      With .Add(Nothing)
        .PropertyType = cspList
        
        'TODO: Lenguaje
        With .List
          With .Add(Nothing)
            .Id = csEAlarmaItemTipo.csE_AlitGenerico
            .Value = LNGGetText(3283, vbNullString)   'Generico
          End With
          With .Add(Nothing)
            .Id = csEAlarmaItemTipo.csE_AlitPresupuesto
            .Value = LNGGetText(1847, vbNullString)   'Presupuesto
          End With
          With .Add(Nothing)
            .Id = csEAlarmaItemTipo.csE_AlitAprobacion
            .Value = LNGGetText(3284, vbNullString)   'Aprobacion
          End With
          With .Add(Nothing)
            .Id = csEAlarmaItemTipo.csE_AlitRepuesto
            .Value = LNGGetText(3285, vbNullString)   'Repuesto
          End With
        End With
        
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Id = csEAlarmaItemTipo.csE_AlitGenerico
        .Name = LNGGetText(1223, vbNullString)   'Tipo
        .key = KI_TIPO
      End With
            
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspInteger
        .Name = LNGGetText(1779, vbNullString)   'Alarma 1
        .key = KI_ALARMA1
      End With
      
      With .Add(Nothing)
        .PropertyType = cspList
        
        With .List
          With .Add(Nothing)
            .Value = LNGGetText(1780, vbNullString)   'Minutos
            .Id = csE_AETMinuto
          End With
          With .Add(Nothing)
            .Value = LNGGetText(1660, vbNullString)   'Horas
            .Id = csE_AETHora
          End With
          With .Add(Nothing)
            .Value = LNGGetText(1085, vbNullString)   'Días
            .Id = csE_AETDia
          End With
        End With
        
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Id = csE_AETHora
        .Name = LNGGetText(1223, vbNullString)   'Tipo
        .key = KI_ALARMATIPO1
      End With
      
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspInteger
        .Name = LNGGetText(1781, vbNullString)   'Alarma 2
        .key = KI_ALARMA2
      End With
      
      With .Add(Nothing)
        .PropertyType = cspList
        
        With .List
          With .Add(Nothing)
            .Value = LNGGetText(1780, vbNullString)   'Minutos
            .Id = csE_AETMinuto
          End With
          With .Add(Nothing)
            .Value = LNGGetText(1660, vbNullString)   'Horas
            .Id = csE_AETHora
          End With
          With .Add(Nothing)
            .Value = LNGGetText(1085, vbNullString)   'Días
            .Id = csE_AETDia
          End With
        End With
        
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Id = csE_AETMinuto
        .Name = LNGGetText(1223, vbNullString)   'Tipo
        .key = KI_ALARMATIPO2
      End With
      
      With .Add(Nothing)
        .PropertyType = cspHelp
        .table = csMail
        .Name = LNGGetText(1782, vbNullString)   'Email Inicio
        .key = KI_MAIL_ID_INICIO
      End With
      
      With .Add(Nothing)
        .PropertyType = cspHelp
        .table = csMail
        .Name = LNGGetText(1783, vbNullString)   'Email Alarma 1
        .key = KI_MAIL_ID_ALARMA1
      End With
      
      With .Add(Nothing)
        .PropertyType = cspHelp
        .table = csMail
        .Name = LNGGetText(1784, vbNullString)   'Email Alarma 2
        .key = KI_MAIL_ID_ALARMA2
      End With
      
      With .Add(Nothing)
        .PropertyType = cspHelp
        .table = csMail ' TODO: Lenguaje
        .Name = LNGGetText(3286, vbNullString)   'Email Finalizado
        .key = KI_MAIL_ID_FINALIZADO
      End With
      
      With .Add(Nothing)
        .PropertyType = cspHelp
        .table = csMail
        .Name = LNGGetText(1785, vbNullString)   'Email Vencido
        .key = KI_MAIL_ID_VENCIDO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1786, vbNullString)   'Tipo de Alarma
        .PropertyType = cspHelp
        .table = csAlarmaItemTipo
        .Width = 3500
        .key = KI_ALIT_ID
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1278, vbNullString)   'Departamento
        .PropertyType = cspHelp
        .table = csDepartamento
        .Width = 3500
        .key = KI_DPTO_ID
      End With
    
    End With
    
    With .Rows
    
      .Clear
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscAliId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscAliId).Value
            .key = KI_ALI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscAliNombre)
            .key = KI_NOMBRE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscAliTiempo)
            .key = KI_TIEMPO
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscAliTiempotipo)
            .key = KI_TIEMPOTIPO
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscAliTiempodesde)
            .key = KI_TIEMPODESDE
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscAliLaboral)
            .key = KI_LABORAL
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscAliSecuencia)
            .key = KI_SECUENCIA
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscAliObligatorioremito)
            .key = KI_OBLIGATORIOREMITO
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscAliObligatoriofactura)
            .key = KI_OBLIGATORIOFACTURA
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscAliTipo)
            .key = KI_TIPO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscAliAlarma1)
            .key = KI_ALARMA1
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscAliAlarmatipo1)
            .key = KI_ALARMATIPO1
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscAliAlarma2)
            .key = KI_ALARMA2
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscAliAlarmatipo2)
            .key = KI_ALARMATIPO2
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "mail_inicio")
            .Id = gDB.ValField(rs.Fields, cscMailIdInicio)
            .key = KI_MAIL_ID_INICIO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "mail_alarma1")
            .Id = gDB.ValField(rs.Fields, cscMailIdAlarma1)
            .key = KI_MAIL_ID_ALARMA1
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "mail_alarma2")
            .Id = gDB.ValField(rs.Fields, cscMailIdAlarma2)
            .key = KI_MAIL_ID_ALARMA2
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "mail_finalizado")
            .Id = gDB.ValField(rs.Fields, cscMailIdFinalizado)
            .key = KI_MAIL_ID_FINALIZADO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "mail_vencido")
            .Id = gDB.ValField(rs.Fields, cscMailIdVencido)
            .key = KI_MAIL_ID_VENCIDO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscAlitNombre)
            .Id = gDB.ValField(rs.Fields, cscAlitId)
            .key = KI_ALIT_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscDptoNombre)
            .Id = gDB.ValField(rs.Fields, cscDptoId)
            .key = KI_DPTO_ID
          End With
          
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadItems = True
End Function

Private Function pValidateRowFechas(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.key
      Case KI_FECHA
        If ValEmpty(Cell.Value, csDate) Then
          MsgInfo LNGGetText(1787, vbNullString, strRow)
                  'Debe indicar una fecha (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowFechas = True
End Function

Private Function pValidateRowItems(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.key
      Case KI_NOMBRE
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(1788, vbNullString, strRow)
                  'Debe indicar una nombre para el item (1)
          Exit Function
        End If
    
      Case KI_TIEMPO
        If ValEmpty(Cell.Value, csInteger) Then
          MsgInfo LNGGetText(1788, vbNullString, strRow)
                  'Debe indicar una nombre para el item (1)
          Exit Function
        End If
      
      Case KI_SECUENCIA
        If ValEmpty(Cell.Value, csInteger) Then
          MsgInfo LNGGetText(1789, vbNullString, strRow)
                  'Debe indicar un orden para el item (1)
          Exit Function
        End If
      
      Case KI_ALIT_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(1790, vbNullString, strRow)
                  'Debe indicar un tipo de alarma para el item (1)
          Exit Function
        End If
    
    End Select
  Next
  
  pValidateRowItems = True
End Function

Private Function pIsEmptyRowFechas(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.key
      Case KI_FECHA
        If Not ValEmpty(Cell.Value, csDate) Then
          bRowIsEmpty = False
          Exit For
        End If
        
    End Select
  Next
  
  pIsEmptyRowFechas = bRowIsEmpty
End Function

Private Function pIsEmptyRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.key
      Case KI_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
        
    End Select
  Next
  
  pIsEmptyRowItems = bRowIsEmpty
End Function

Private Function pGetHora(ByVal Hora As Integer, ByVal Minuto As Integer) As String
  pGetHora = Format$(Hora, "00") & ":" & Format$(Minuto, "00")
End Function
