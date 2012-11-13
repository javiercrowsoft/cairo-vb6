VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cHojaRuta"
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
' cHojaRuta
' 15-12-2007

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cHojaRuta"

Private Const c_Todos = "Todos"
Private Const c_TotalRecibido = "TotalRecibido"
Private Const c_cobrado = "Cobrado"
Private Const c_CobradoT = "CobradoT"
Private Const c_CobradoDif = "CobradoDif"
Private Const c_cmd_selectAll = "SelectAll"
Private Const c_FaltanteComp = "FaltanteComp"
Private Const c_TicketComp = "TicketComp"

Private Const c_select_key = "kselect"

Private Const c_Tipo_Orden = 1
Private Const c_Tipo_Remito = 2
Private Const c_Tipo_Factura = 3
Private Const c_Tipo_Parte = 4

Private Const c_persona = "persona2"

Private Const c_key_col_cliente = "col_cli"
Private Const c_key_col_fecha = "col_fecha"

' Totales en la solapa de items
'
Private Const c_t_total_fv = "t_total_fv"
Private Const c_t_total_fv_cobrar = "t_total_fv_cobrar"
Private Const c_t_total_rv = "t_total_rv"
Private Const c_t_total_os = "t_total_os"
Private Const c_total_TODOS = "total_T"

' Totales en la solapa general
Private Const c_t_total_fv2 = "t_total_fv2"
Private Const c_t_total_fv_cobrar2 = "t_total_fv_cobrar2"
Private Const c_t_total_rv2 = "t_total_rv2"
Private Const c_t_total_os2 = "t_total_os2"


Private Const csTareaEstado = 2004

Private Const c_T_FECHA_DESDE                 As String = "c_T_FECHA_DESDE"
Private Const c_T_FECHA_HASTA                 As String = "c_T_FECHA_HASTA"
Private Const c_T_CLI_ID                      As String = "c_T_CLI_ID"
Private Const c_T_ESTADO                      As String = "c_T_ESTADO"
Private Const c_T_CMD_LOAD                    As String = "c_T_CMD_LOAD"

Private Const c_T_CMD_RECIBIR                 As String = "c_T_CMD_RECIBIR"
Private Const c_T_CMD_COBRAR                  As String = "c_T_CMD_COBRAR"
Private Const c_LabelRecibido                 As String = "c_LabelRecibido"

Private Const K_NRODOC                         As Integer = 1
Private Const K_FECHA                          As Integer = 2
Private Const K_NUMERO                         As Integer = 3
Private Const K_DESCRIP                        As Integer = 4
Private Const K_FECHAENTREGA                   As Integer = 5
Private Const K_TOTAL                          As Integer = 9
Private Const K_PRS_ID                         As Integer = 10
Private Const K_PRS_ID2                        As Integer = 1001
Private Const K_SUC_ID                         As Integer = 11
Private Const K_CAM_ID                         As Integer = 12
Private Const K_CHOF_ID                        As Integer = 13
Private Const K_CAM_ID_SEMI                    As Integer = 14

Private Const K_RECIBIDO_EFECTIVO              As Integer = 15
Private Const K_RECIBIDO_CHEQUES               As Integer = 16
Private Const K_CANT_CHEQUES                   As Integer = 18
Private Const K_RECIBIDO_DESCRIP               As Integer = 19
Private Const K_RECIBIDO_TOTAL                 As Integer = 20
Private Const K_COBRADO                        As Integer = 21

Private Const K_COBRADO_TOTAL                 As Integer = 22
Private Const K_COBRADO_DIFERENCIA            As Integer = 23

Private Const K_CUMPLIDA                       As Integer = 24

Private Const K_T_FECHA_DESDE                 As Integer = 700
Private Const K_T_FECHA_HASTA                 As Integer = 701
Private Const K_T_CLI_ID                      As Integer = 702
Private Const K_T_ESTADO                      As Integer = 703
Private Const K_T_CMD_LOAD                    As Integer = 704

Private Const K_TOTAL_OS                        As Integer = 501
Private Const K_TOTAL_FV                        As Integer = 502
Private Const K_TOTAL_FV_COBRAR                 As Integer = 503
Private Const K_TOTAL_RV                        As Integer = 504
Private Const K_TODOS                           As Integer = 17

Private Const K_TOTAL_OS2                        As Integer = 511
Private Const K_TOTAL_FV2                        As Integer = 512
Private Const K_TOTAL_FV_COBRAR2                 As Integer = 513
Private Const K_TOTAL_RV2                        As Integer = 514
Private Const K_CMD_SELECT_ALL                   As Integer = 515

Private Const K_CMD_RECIBIR                    As Integer = 600
Private Const K_CMD_COBRAR                     As Integer = 601

Private Const K_FALTANTE                       As Integer = 610
Private Const K_SOBRANTE                       As Integer = 611
Private Const K_MOV_FALTANTE                   As Integer = 612
Private Const K_CMD_VER_FALTANTE               As Integer = 613

Private Const K_TICKETS                        As Integer = 614
Private Const K_MOV_TICKETS                    As Integer = 615
Private Const K_CMD_VER_TICKETS                As Integer = 616

Private Const KI_HRI_ID                        As Integer = 1
Private Const KI_TIPO                          As Integer = 1001
Private Const KI_ID                            As Integer = 2
Private Const KI_SELECT                        As Integer = 3

' Esto es un desastre ya lo se, pero por ahora es asi
' el valor de esta constante afecta al agrupamiento de columnas
' asi que no se puede cambiar
'
Private Const KI_CLIENTE                       As Integer = 4

' Esto es un desastre ya lo se, pero por ahora es asi
' el valor de esta constante afecta al agrupamiento de columnas
' asi que no se puede cambiar
'
Private Const KI_FECHA                         As Integer = 5

Private Const KI_NRODOC                        As Integer = 6
Private Const KI_IMPORTE                       As Integer = 7
Private Const KI_TITLE                         As Integer = 8
Private Const KI_COBRAR                        As Integer = 306
Private Const KI_PENDIENTE                     As Integer = 307
Private Const KI_ACOBRAR                       As Integer = 308
Private Const KI_COBRADO                       As Integer = 309

Private Const KI_HRI_ANULADO                   As Integer = 500
Private Const KI_HRI_CHEQUES                   As Integer = 501
Private Const KI_HRI_EFECTIVO                  As Integer = 503
Private Const KI_HRI_NOTASCREDITO              As Integer = 504
Private Const KI_HRI_RETENCIONES               As Integer = 505
Private Const KI_HRI_TARJETA                   As Integer = 506
Private Const KI_HRI_TICKETS                   As Integer = 507
Private Const KI_HRI_OTROS                     As Integer = 508

Private Const KI_ORDEN                         As Integer = 1000
Private Const KI_TITULO                        As Integer = 2000
Private Const KI_DESCRIP                       As Integer = 2001
Private Const KI_OTS                           As Integer = 2002
Private Const KI_CUMPLIDO                      As Integer = 2003
Private Const KI_HRCT_ID                       As Integer = 2004

Private Const KI_FV_VTO                        As Integer = 2100

' Seudo - Variables
Private c_ErrorSave                   As String

' estructuras

' variables privadas
Private m_Id                           As Long
Private m_Numero                       As Long
Private m_Nrodoc                       As String
Private m_Descrip                      As String
Private m_Fecha                        As Date
Private m_Fechaentrega                 As Date
Private m_Total                        As Double
Private m_pendiente                    As Double
Private m_Firmado                      As Long

Private m_est_id                       As Long
Private m_Estado                       As String
Private m_suc_id                       As Long
Private m_Sucursal                     As String
Private m_emp_id                       As Long
Private m_Empresa                      As String
Private m_chof_id                      As Long
Private m_Chofer                       As String
Private m_cam_id                       As Long
Private m_Camion                       As String
Private m_cam_id_semi                  As Long
Private m_Semi                         As String
Private m_prs_id                       As Long
Private m_persona                      As String
Private m_cumplida                     As Boolean

Private m_RecibidoDescrip              As String
Private m_RecibidoEfectivo             As Double
Private m_RecibidoCheque               As Double
Private m_RecibidoTotal                As Double
Private m_RecibidoCantCheque           As Long

Private m_Faltante                     As Double
Private m_Sobrante                     As Double
Private m_MovFaltante                  As String
Private m_fv_id_faltante               As Long
Private m_mf_id_sobrante               As Long
Private m_porcTickets                  As Double
Private m_MovTickets                   As String
Private m_mf_id_tickets                As Long

Private m_GeneralConfig     As cGeneralConfig

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

Private m_bSaveByCobrado    As Boolean

Private m_FechaDesde        As Date
Private m_FechaHasta        As Date

Private m_RamaCliente       As String
Private m_RamaEstado        As String
Private m_ram_id_cliente    As String
Private m_ram_id_estado     As String

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig


Private m_binRefresh As Boolean

' Properties publicas
' Properties privadas
' funciones publicas

Public Function Edit(ByVal hr_id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  
  If m_ObjAbm Is Nothing Then
    Set m_ObjAbm = New cABMGeneric
  End If
  
  Edit = cIEditGeneric_Edit(hr_id, InModalWindow)
  
End Function

Public Sub AddFvId(ByVal fv_id As Long)
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_HojaRutaAddFvId " & m_Id & "," & fv_id
  If Not gDB.Execute(sqlstmt) Then Exit Sub
  
  '"Ud. ha realizado cambios que no ha guardado." & vbCrLf & vbCrLf & "¿Desea guardarlos?"
  
  pSaveChanges LNGGetText(4897, vbNullString)
    
  pLoadTodos pGetTodos(), True
  pLoadCobrado pGetCobrado(), True
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  AbmObj.GroupGridEx pGetTodos(), _
                     c_key_col_cliente, _
                     c_key_col_fecha, _
                     4

  AbmObj.GroupGridEx pGetCobrado(), _
                     c_key_col_cliente, _
                     c_key_col_fecha, _
                     4
End Sub

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscHrNrodoc)
    .Value = C_CopiaDe & .Value
  End With
    
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscHrNrodoc)
  
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

  Doc.ClientTable = csTHojaRuta
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
  
  Select Case MessageID
  
    Case MSG_GRID_ROW_DELETED
      cIABMClient_MessageEx = True
    
    Case MSG_ABM_PRINT
      
      If m_Id = csNO_ID Then
        MsgInfo LNGGetText(3748, vbNullString), LNGGetText(1853, vbNullString)
              'Debe grabar la Hoja de Ruta para poder imprimirla, Imprimir
      Else
        Dim AbmObj As cABMGeneric
        Set AbmObj = m_ObjAbm
        AbmObj.PrintABM m_Id, -csHojaRuta ' El menos es para que pase Id y no NODO Id en PrintManager
      End If
      
      cIABMClient_MessageEx = True
    
    Case MSG_ABM_CAN_PRINT
      
      cIABMClient_MessageEx = MSG_ABM_CAN_PRINT
  
    Case MSG_DOC_REFRESH
      pRefreshProperties
  
  End Select

End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  
  Dim AbmObj        As cABMGeneric
  Dim RecibidoTotal As Double
  Dim persona       As String
  Dim ObjEditName   As String
  
  Select Case Key
    
    Case K_T_CMD_LOAD
    
      If Not pSaveChanges() Then Exit Function
      
      pLoadTodos pGetTodos(), True
      pLoadCobrado pGetCobrado(), True
      
      Set AbmObj = m_ObjAbm
      
      AbmObj.GroupGridEx pGetTodos(), _
                         c_key_col_cliente, _
                         c_key_col_fecha, _
                         4
    
      AbmObj.GroupGridEx pGetCobrado(), _
                         c_key_col_cliente, _
                         c_key_col_fecha, _
                         4
    
    Case K_PRS_ID2
    
      If m_binRefresh Then
      
        m_binRefresh = False
      
      Else
      
        m_binRefresh = True

        persona = m_ObjAbm.Properties(c_persona).Value
        With m_ObjAbm.Properties(cscPrsId)
          .HelpId = m_ObjAbm.Properties(c_persona).HelpId
          .Value = m_ObjAbm.Properties(c_persona).Value
          .HelpValueProcess = .HelpId
        End With
      
        m_ObjAbm.ShowValue m_ObjAbm.Properties(cscPrsId)
        m_ObjAbm.Title2 = m_Nrodoc & " - " & persona
        Set AbmObj = m_ObjAbm
        AbmObj.RefreshTitle
        AbmObj.FormCaption = persona & " - "
        AbmObj.RefreshFormCaption
    
    End If
    
    Case K_PRS_ID
    
      If m_binRefresh Then
      
        m_binRefresh = False
      
      Else
      
        m_binRefresh = True
      
        persona = m_ObjAbm.Properties(cscPrsId).Value
        With m_ObjAbm.Properties(c_persona)
          .HelpId = m_ObjAbm.Properties(cscPrsId).HelpId
          .Value = persona
          .HelpValueProcess = .HelpId
        End With
        
        m_ObjAbm.ShowValue m_ObjAbm.Properties(c_persona)
        m_ObjAbm.Title2 = m_Nrodoc & " - " & persona
        
        Set AbmObj = m_ObjAbm
        AbmObj.RefreshTitle
        AbmObj.FormCaption = persona & " - "
        AbmObj.RefreshFormCaption
        
      End If
      
    Case K_RECIBIDO_EFECTIVO, K_RECIBIDO_CHEQUES
    
      RecibidoTotal = Val(pGetRecibidoCheque().Value) + Val(pGetRecibidoEfectivo().Value)
      pGetRecibidoTotal.Value = RecibidoTotal
      
      m_ObjAbm.ShowValue pGetRecibidoTotal()
      
      pShowTotalCobrado
      
    Case K_CMD_RECIBIR
    
      Set AbmObj = m_ObjAbm
      
      If AbmObj.bWasChanged Then
    
        If Not pSaveChanges() Then Exit Function
        
        pLoadTodos pGetTodos(), True
        pLoadCobrado pGetCobrado(), True
        
        Set AbmObj = m_ObjAbm
        AbmObj.GroupGridEx pGetTodos(), _
                           c_key_col_cliente, _
                           c_key_col_fecha, _
                           4
      
        AbmObj.GroupGridEx pGetCobrado(), _
                           c_key_col_cliente, _
                           c_key_col_fecha, _
                           4
        
      End If
    
      pGetCobrado().Enabled = True
      AbmObj.SetEnabled pGetCobrado()
      
      pGetTodos().Enabled = False
      AbmObj.SetEnabled pGetTodos()
      
      m_bSaveByCobrado = True
      
    Case K_CMD_COBRAR
    
      If m_Id = csNO_ID Then
      
        MsgWarning LNGGetText(4941, vbNullString) 'Debe guardar la hoja de ruta para poder recibir la cobranza
      
      Else
    
        Dim MouseWait As cMouseWait
        Set MouseWait = New cMouseWait
    
        ' Solo actulizo el pago
        '
        If Not pSaveItemsCobrado(m_Id) Then Exit Function
      
        If Not pSaveFaltante() Then Exit Function
        If Not pSaveTickets() Then Exit Function
                
        pShowCobranza
      
        Set MouseWait = Nothing
      
      End If
      
    Case K_T_FECHA_DESDE
      m_FechaDesde = m_ObjAbm.Properties.Item(c_T_FECHA_DESDE).Value
    
    Case K_T_FECHA_HASTA
      m_FechaHasta = m_ObjAbm.Properties.Item(c_T_FECHA_HASTA).Value
    
    Case K_T_CLI_ID
      
      With m_ObjAbm.Properties.Item(c_T_CLI_ID)
        m_ram_id_cliente = .HelpValueProcess
        m_RamaCliente = .Value
      End With
    
    Case K_T_ESTADO
    
      With m_ObjAbm.Properties.Item(c_T_ESTADO)
        m_ram_id_estado = .HelpValueProcess
        m_RamaEstado = .Value
      End With
        
    Case K_CMD_SELECT_ALL
      
      If pGetCMDSelectAll.name = c_selectall Then
        pSelectAll True
        pGetCMDSelectAll.name = c_unselectall
      Else
        pSelectAll False
        pGetCMDSelectAll.name = c_selectall
      End If
      
      Set AbmObj = m_ObjAbm
      AbmObj.ShowValue pGetCMDSelectAll
        
    Case K_CMD_VER_FALTANTE
    
      If m_fv_id_faltante Then
    
        ObjEditName = "CSVenta2.cFacturaVenta"
        pShowDocAux m_fv_id_faltante, _
                    ObjEditName, _
                    "CSABMInterface2.cABMGeneric"
      Else
      
        If m_mf_id_sobrante Then
      
          ObjEditName = "CSTesoreria2.cMovimientoFondo"
          ShowDocAux m_mf_id_sobrante, _
                      ObjEditName, _
                      "CSABMInterface2.cABMGeneric"
        End If
        
      End If
    
    Case K_CMD_VER_TICKETS
        
      If m_mf_id_tickets Then
    
        ObjEditName = "CSTesoreria2.cMovimientoFondo"
        ShowDocAux m_mf_id_tickets, _
                    ObjEditName, _
                    "CSABMInterface2.cABMGeneric"
      End If
      
    Case K_FALTANTE
    
      If Val(pGetFaltante().Value) <> 0 Then
        pGetSobrante().Value = 0
        Set AbmObj = m_ObjAbm
        AbmObj.ShowValue pGetSobrante()
      End If
    
    Case K_SOBRANTE
        
      If Val(pGetSobrante().Value) <> 0 Then
        pGetFaltante().Value = 0
        Set AbmObj = m_ObjAbm
        AbmObj.ShowValue pGetFaltante()
      End If
        
  End Select

End Function

Private Function cIABMClient_Save() As Boolean
  
  '--/////////////////////////////////////////////
  
    With m_ObjAbm.Properties
      
      m_FechaDesde = .Item(c_T_FECHA_DESDE).Value
      m_FechaHasta = .Item(c_T_FECHA_HASTA).Value
      
      With .Item(c_T_CLI_ID)
        m_ram_id_cliente = .HelpValueProcess
        m_RamaCliente = .Value
      End With
      
      With .Item(c_T_ESTADO)
        m_ram_id_estado = .HelpValueProcess
        m_RamaEstado = .Value
      End With
      
    End With
  
  '--/////////////////////////////////////////////
  
  Dim register   As cRegister
  Dim fields     As cFields
  Dim Alarma     As Date
  
  Set register = New cRegister
  
  With register
  
    Set fields = .fields
    
    .fieldId = cscHrId
    .Table = csTHojaRuta
  
    If m_Copy Then
      .id = csNew
    Else
      .id = m_Id
    End If
  End With
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key

        Case K_NRODOC
          fields.Add2 cscHrNrodoc, .Value, csText
        Case K_FECHA
          fields.Add2 cscHrFecha, .Value, csDate
        Case K_PRS_ID
          register.fields.Add2 cscPrsId, .HelpId, csId
        Case K_SUC_ID
          register.fields.Add2 cscSucId, .HelpId, csId
        Case K_CAM_ID
          register.fields.Add2 cscCamId, .HelpId, csId
        Case K_CAM_ID_SEMI
          register.fields.Add2 cscCamIdSemi, .HelpId, csId
        Case K_CHOF_ID
          register.fields.Add2 cscChofId, .HelpId, csId
      
        Case K_FECHAENTREGA
          register.fields.Add2 cscHrFechaentrega, .Value, csDate
        Case K_DESCRIP
          register.fields.Add2 cscHrDescrip, .Value, csText
          
        Case K_TOTAL
          register.fields.Add2 cscHrTotal, .Value, csDouble
        
        Case K_RECIBIDO_CHEQUES
          register.fields.Add2 cscHrRecibidoCheque, .Value, csDouble
        Case K_RECIBIDO_EFECTIVO
          register.fields.Add2 cscHrRecibidoEfectivo, .Value, csDouble
        Case K_CANT_CHEQUES
          register.fields.Add2 cscHrRecibidoCantCheque, .Value, csInteger
        Case K_RECIBIDO_DESCRIP
          register.fields.Add2 cscHrRecibidoDescrip, .Value, csText
        
        Case K_SOBRANTE
          register.fields.Add2 cscHrSobrante, .Value, csDouble
        Case K_FALTANTE
          register.fields.Add2 cscHrFaltante, .Value, csDouble
        Case K_TICKETS
          register.fields.Add2 cscHrPorcTickets, .Value, csDouble
        
        Case K_CUMPLIDA
          register.fields.Add2 cscHrCumplida, .Value, csBoolean
      End Select
    End With
  Next
  
  fields.Add2 cscEstId, 1, csId ' pendiente
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , _
                  "cIABMClient_Save", _
                  C_Module, _
                  c_ErrorSave) Then Exit Function

  pSaveNroHojaRuta register.id
  
  
  If m_bSaveByCobrado Then
  
    ' Solo actulizo el pago
    '
    If Not pSaveItemsCobrado(register.id) Then Exit Function
  
  Else
  
    ' Si voy a guardar desde la grilla de documentos
    ' borro todos y los vuelvo a generar
    '
    
    Dim sqlstmt As String
    sqlstmt = "delete HojaRutaItem where hr_id = " & register.id
    
    If Not gDB.Execute(sqlstmt) Then Exit Function
    
    If Not pSaveItemsTodos(register.id) Then Exit Function
  
  End If
  
  If Not register.CommitTrans() Then Exit Function
  
  m_Copy = False
  
  cIABMClient_Save = Load(register.id)

End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  m_ObjTree.sqlstmt = "sp_lsdoc_HojaRuta"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = LNGGetText(3746, vbNullString) 'Hojas de Ruta
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_FECHA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(1558, vbNullString) 'Debe indicar una fecha
            Exit Function
          End If
        Case K_SUC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1560, vbNullString)
                    'Debe indicar una Sucursal
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreVtaListHojaRuta)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(id As Long) As Boolean
    If Not SecurityCanAccess(csPreVtaDeleteHojaRuta) Then Exit Function

    Dim sqlstmt As String
  
    sqlstmt = "sp_HojaRutaDelete " & id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreVtaNewHojaRuta) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreVtaEditHojaRuta) Then Exit Function
  End If
  
  m_ObjAbm.InModalWindow = InModalWindow
  
  m_ram_id_estado = m_UserCfg.est_id_hojaRuta
  m_RamaEstado = m_UserCfg.EstadoHojaRuta
  
  If Not Load(id) Then Exit Function
  
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
  MngError Err, "cIEditGeneric_Edit ", C_Module, vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal id As Long) As Boolean

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

Private Function cIEditGeneric_Preview(ByVal id As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

' Menu Client
Private Function cIMenuClient_Initialize(f As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  
  Dim str_1589 As String
  
  str_1589 = LNGGetText(1589, vbNullString)  '&Ventas
  
  Set m_Host = Host
  m_Host.Server.AddMenu str_1589, csMenuEnum.csMenuVentas, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(3747, vbNullString), csPreVtaListHojaRuta, str_1589, 0, True, False, False, False, False, Me
                        '&Hojas de Ruta
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal id As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", _
                          "CSVenta2.cHojaRuta", _
                          "CSABMInterface2.CABMGenericListDoc", _
                          "CSVenta2.cHojaRutaListDoc", _
                          Me, _
                          LNGGetText(3746, vbNullString), _
                          0
                          'Hojas de Ruta
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c       As cIABMProperty
  Dim AbmObj  As cABMGeneric
  Dim oProp   As cABMProperty
  
  m_bSaveByCobrado = False

  Set AbmObj = m_ObjAbm
  AbmObj.bSendRefresh = True
  AbmObj.MinHeight = 9500
  AbmObj.MinWidth = 10000
  AbmObj.UseHelpValueProcess = True
  
  m_ObjAbm.Title2 = m_Nrodoc & " - " & m_persona

  m_binRefresh = False

  With m_ObjAbm.Tabs
    
    .Clear
    
    With .Add(Nothing)
      .name = LNGGetText(3817, vbNullString)  'Comprobantes
    End With
    
    With .Add(Nothing)
      .Index = 1
      .name = LNGGetText(3957, vbNullString)  'Recibido
    End With
        
    With .Add(Nothing)
      .name = C_strGeneral
      .Index = 2
    End With
  
  End With

  With m_ObjAbm.Properties
    
    .Clear

    With .Add(Nothing, cscHrFecha)
      .PropertyType = cspDate
      .name = LNGGetText(1569, vbNullString) 'Fecha
      .Key = K_FECHA
      .Value = m_Fecha
      .TabIndex = 2
    End With
    
    With .Add(Nothing, cscHrFechaentrega)
      .PropertyType = cspDate
      .name = LNGGetText(3807, vbNullString) 'Fecha de Salida
      .Key = K_FECHAENTREGA
      .Value = m_Fechaentrega
      .TabIndex = 2
    End With
    
    With .Add(Nothing, cscHrNumero)
      .PropertyType = cspText
      .name = LNGGetText(1065, vbNullString) 'Numero
      .Key = K_NUMERO
      .Value = m_Numero
      .Width = 1000
      .Enabled = False
      .TopFromProperty = cscHrFecha
      .Left = 6000
      .TabIndex = 2
    End With
    
    With .Add(Nothing, cscHrNrodoc)
      .PropertyType = cspText
      .name = LNGGetText(1610, vbNullString) 'Comprobante
      .Key = K_NRODOC
      .Value = m_Nrodoc
      .Width = 1000
      .Enabled = False
      .TabIndex = 2
    End With
    
    With .Add(Nothing, cscSucId)
      .PropertyType = cspHelp
      .Table = csSucursal
      .name = LNGGetText(1281, vbNullString) 'Sucursal
      .LeftFromProperty = cscHrFecha
      .Key = K_SUC_ID
      .HelpId = m_suc_id
      .Value = m_Sucursal
      .TabIndex = 2
    End With
    
    With .Add(Nothing, cscPrsId)
      .PropertyType = cspHelp
      .Table = csPersona
      .name = LNGGetText(3808, vbNullString) 'Salida de
      .Key = K_PRS_ID
      .Value = m_persona
      .HelpId = m_prs_id
      .HelpFilter = "prs_esempleado <> 0"
      .TabIndex = 2
    End With
    
    With .Add(Nothing, cscChofId)
      .PropertyType = cspHelp
      .Table = csChofer
      .name = LNGGetText(1051, vbNullString) 'Chofer
      .LeftFromProperty = cscHrNumero
      .TopFromProperty = cscHrNrodoc
      .TopToPrevious = 440
      .Key = K_CHOF_ID
      .Value = m_Chofer
      .HelpId = m_chof_id
      .TabIndex = 2
    End With
    
    With .Add(Nothing, cscCamId)
      .PropertyType = cspHelp
      .Table = csCamion
      .name = LNGGetText(3489, vbNullString) 'Camion
      .Key = K_CAM_ID
      .Value = m_Camion
      .HelpId = m_cam_id
      .TabIndex = 2
    End With
    
    With .Add(Nothing, cscCamIdSemi)
      .PropertyType = cspHelp
      .Table = csCamionSemi
      .name = LNGGetText(3493, vbNullString) 'Semi
      .Key = K_CAM_ID_SEMI
      .Value = m_Semi
      .HelpId = m_cam_id_semi
      .TabIndex = 2
    End With

    With .Add(Nothing, cscHrDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Height = 780
      .Width = 7000
      .name = C_strDescrip      'Descripcion
      .Size = 255
      .LeftFromProperty = cscHrFecha
      .Key = K_DESCRIP
      .Value = m_Descrip
      .TabIndex = 2
    End With
    
    With .Add(Nothing, cscHrTotal)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .name = LNGGetText(1584, vbNullString) ' Total
      .Enabled = False
      .Value = m_Total
      .Key = K_TOTAL
      .LeftFromProperty = cscHrDescrip
      .Width = 1200
      .LeftLabel = -600
      .Format = m_GeneralConfig.FormatDecImporte
      .TabIndex = 2
    End With
                                
    With .Add(Nothing, c_t_total_fv2)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .name = LNGGetText(3823, vbNullString) ' Total Facturas
      .Enabled = False
      .Key = K_TOTAL_FV2
      .TopFromProperty = cscHrTotal
      .Left = 3900
      .Width = 1400
      .LeftLabel = -650
      .Format = m_GeneralConfig.FormatDecImporte
      .TabIndex = 2
    End With
    
    With .Add(Nothing, c_t_total_fv_cobrar2)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .name = LNGGetText(1690, vbNullString) ' Cobrar
      .Enabled = False
      .Key = K_TOTAL_FV_COBRAR2
      .TopFromProperty = cscHrTotal
      .Left = 6000
      .Width = 1400
      .LeftLabel = -550
      .Format = m_GeneralConfig.FormatDecImporte
      .TabIndex = 2
    End With
    
    With .Add(Nothing, c_t_total_rv2)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .name = LNGGetText(3821, vbNullString) ' Total Remitos
      .Enabled = False
      .Key = K_TOTAL_RV2
      .TopFromProperty = cscHrTotal
      .TopToPrevious = 440
      .Left = 3900
      .Width = 1400
      .LeftLabel = -650
      .Format = m_GeneralConfig.FormatDecImporte
      .TabIndex = 2
    End With
    
    With .Add(Nothing, c_t_total_os2)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .name = LNGGetText(3822, vbNullString) ' Total Ordenes
      .Enabled = False
      .Key = K_TOTAL_OS2
      .TopFromProperty = cscHrTotal
      .TopToPrevious = 440
      .Left = 6000
      .Width = 1400
      .LeftLabel = -650
      .Format = m_GeneralConfig.FormatDecImporte
      .TabIndex = 2
    End With
                                
  '/////////////////////////////////////////////////////////////////////
  '
  ' TODOS
  '
  '
  '/////////////////////////////////////////////////////////////////////
  
    Set c = .Add(Nothing, c_T_FECHA_DESDE)
    With c
      .PropertyType = cspDate
      .name = LNGGetText(2532, vbNullString) 'Desde
      .Left = 1000
      .LeftLabel = -550
      .Key = K_T_FECHA_DESDE
      .Value = m_FechaDesde
      .TabIndex = 0
      Set oProp = c
      oProp.IsEditProperty = False
      Set oProp = Nothing
    End With

    Set c = .Add(Nothing, c_T_FECHA_HASTA)
    With c
      .PropertyType = cspDate
      .name = LNGGetText(2533, vbNullString) 'Hasta
      .Key = K_T_FECHA_HASTA
      .Value = m_FechaHasta
      .TabIndex = 0
      .TopFromProperty = c_T_FECHA_DESDE
      .LeftLabel = -550
      .Left = 3100
      Set oProp = c
      oProp.IsEditProperty = False
      Set oProp = Nothing
    End With

    Set c = .Add(Nothing, c_T_CLI_ID)
    With c
      .PropertyType = cspHelp
      .Table = csCliente
      .name = LNGGetText(1150, vbNullString) 'Cliente
      .Key = K_T_CLI_ID
      .TabIndex = 0
      .TopFromProperty = c_T_FECHA_DESDE
      .Left = 5400
      .LeftLabel = -600
      .Width = 2700
    
      .HelpId = Val(m_ram_id_cliente)
      .HelpValueProcess = m_ram_id_cliente
      .Value = m_RamaCliente
    
      Set oProp = c
      oProp.HelpType = csTree
      oProp.IsEditProperty = False
      Set oProp = Nothing
    
    End With

    Set c = .Add(Nothing, c_T_ESTADO)
    With c
      .PropertyType = cspHelp
      .Table = csEstado
      .name = LNGGetText(1568, vbNullString) 'Estado
      .Key = K_T_ESTADO
      .TabIndex = 0
      .TopFromProperty = c_T_FECHA_DESDE
      .Left = 8900
      .LeftLabel = -600
    
      .HelpId = Val(m_ram_id_estado)
      .HelpValueProcess = m_ram_id_estado
      .Value = m_RamaEstado
    
      Set oProp = c
      oProp.HelpType = csTree
      oProp.IsEditProperty = False
      Set oProp = Nothing
    
    End With

    With .Add(Nothing, c_persona)
      .PropertyType = cspHelp
      .Table = csPersona
      .name = LNGGetText(3808, vbNullString) 'Salida de
      .Key = K_PRS_ID2
      .Value = m_persona
      .HelpId = m_prs_id
      .HelpFilter = "prs_esempleado <> 0"
      
      .TopFromProperty = c_T_FECHA_DESDE
      .TopToPrevious = 440
      .LeftFromProperty = c_T_FECHA_DESDE
      .LeftLabel = -700
      .Width = 3700
      .TabIndex = 0
    End With
    
    With .Add(Nothing, c_T_CMD_LOAD)
      .PropertyType = cspButton
      .name = LNGGetText(3820, vbNullString) 'Buscar
      .Key = K_T_CMD_LOAD
      .TabIndex = 0
      .TopFromProperty = c_T_FECHA_DESDE
      .Left = 11480
      .LeftLabel = -1
    End With
    
    With .Add(Nothing, c_cmd_selectAll) ' Seleccionar Todos
      .PropertyType = cspButton
      .name = c_selectall
      .Key = K_CMD_SELECT_ALL
      .TabIndex = 0
      .TopFromProperty = c_T_FECHA_DESDE
      .TopToPrevious = 440
      .Left = 11480
      .LeftLabel = -1
    End With
  
    With .Add(Nothing, cscHrCumplida)
      .PropertyType = cspCheck
      .name = LNGGetText(4796, vbNullString) 'Hoja Cumplida
      .Key = K_CUMPLIDA
      .Value = CInt(m_cumplida)
      .Left = 6700
      .TopFromProperty = c_persona
      '.LeftNotChange = True
      '.TopNotChange = True
      .TabIndex = 0
    End With
  
    '-----------------------------------------------
    
    With .Add(Nothing, c_total_TODOS)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .name = LNGGetText(1584, vbNullString) ' Total
      .Enabled = False
      .Key = K_TOTAL_FV
      .TabIndex = 0
      .TopFromProperty = c_persona
      .TopToPrevious = 440
      .LeftFromProperty = c_persona
      .Width = 1400
      .LeftLabel = -450
      .Format = m_GeneralConfig.FormatDecImporte
    End With
    
    With .Add(Nothing, c_t_total_fv)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .name = LNGGetText(3823, vbNullString) ' Total Facturas
      .Enabled = False
      .Key = K_TOTAL_FV
      .TabIndex = 0
      .TopFromProperty = c_total_TODOS
      .Left = 3300
      .Width = 1400
      .LeftLabel = -650
      .Format = m_GeneralConfig.FormatDecImporte
    End With
    
    With .Add(Nothing, c_t_total_fv_cobrar)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .name = LNGGetText(1690, vbNullString) ' Cobrar
      .Enabled = False
      .Key = K_TOTAL_FV_COBRAR
      .TabIndex = 0
      .TopFromProperty = c_total_TODOS
      .Left = 5500
      .Width = 1400
      .LeftLabel = -550
      .Format = m_GeneralConfig.FormatDecImporte
    End With
    
    With .Add(Nothing, c_t_total_rv)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .name = LNGGetText(3821, vbNullString) ' Total Remitos
      .Enabled = False
      .Key = K_TOTAL_RV
      .TabIndex = 0
      .TopFromProperty = c_total_TODOS
      .Left = 7700
      .Width = 1400
      .LeftLabel = -650
      .Format = m_GeneralConfig.FormatDecImporte
    End With
    
    With .Add(Nothing, c_t_total_os)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .name = LNGGetText(3822, vbNullString) ' Total Ordenes
      .Enabled = False
      .Key = K_TOTAL_OS
      .TabIndex = 0
      .TopFromProperty = c_total_TODOS
      .Left = 10000
      .Width = 1400
      .LeftLabel = -650
      .Format = m_GeneralConfig.FormatDecImporte
    End With
    
    '-----------------------------------------------
  
    Set c = .Add(Nothing, c_Todos)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      .Left = 200
      .Top = 2400
      If Not pLoadTodos(c, False) Then Exit Function
      .name = c_Todos
      .Key = K_TODOS
      .TabIndex = 0
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
    End With
                                
    With .Add(Nothing, c_LabelRecibido)
      .PropertyType = cspLabel
      .FontBold = True
      .Value = "Valores Recibidos"
      .Width = 4000
      .TabIndex = 1
    End With
    
    With .Add(Nothing)
      .PropertyType = cspLabel
      .BackColor = RGB(200, 200, 200)
      .Width = 9000
      .Height = 20
      .TabIndex = 1
      .TopToPrevious = 360
    End With
    
    With .Add(Nothing, c_T_CMD_RECIBIR)
      .PropertyType = cspButton
      .name = "Recibir Valores"
      .Left = 4500
      .LeftNotChange = True
      .LeftLabel = -1
      .TabIndex = 1
      .TopFromProperty = c_LabelRecibido
      .TopToPrevious = -80
      .TopNotChange = True
      .Key = K_CMD_RECIBIR
    End With
    
    With .Add(Nothing, c_T_CMD_COBRAR)
      .PropertyType = cspButton
      .name = "Generar Cobranzas"
      .Left = 7000
      .LeftNotChange = True
      .LeftLabel = -1
      .TabIndex = 1
      .TopFromProperty = c_LabelRecibido
      .TopToPrevious = -80
      .TopNotChange = True
      .Key = K_CMD_COBRAR
    End With
    
    Set c = .Add(Nothing, cscHrRecibidoEfectivo)
    With c
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .name = LNGGetText(3958, vbNullString) 'Recibido en efectivo
      .Key = K_RECIBIDO_EFECTIVO
      .Value = m_RecibidoEfectivo
      .Format = m_GeneralConfig.FormatDecImporte
      .TabIndex = 1
      .LeftLabel = -1800
      .Left = 2500
      .TopToPrevious = 80
    End With
    Set oProp = c
    oProp.NoShowButton = True
  
    Set c = .Add(Nothing, cscHrRecibidoCheque)
    With c
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .name = LNGGetText(3959, vbNullString) 'Recibido en cheques
      .Key = K_RECIBIDO_CHEQUES
      .Value = m_RecibidoCheque
      .Format = m_GeneralConfig.FormatDecImporte
      .LeftLabel = -1800
      .TabIndex = 1
      .TopToPrevious = 360
    End With
    Set oProp = c
    oProp.NoShowButton = True

    Set c = .Add(Nothing, cscHrRecibidoCantCheque)
    With c
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .name = LNGGetText(1374, vbNullString) 'Cantidad
      .Key = K_CANT_CHEQUES
      .Value = m_RecibidoCantCheque
      .TabIndex = 1
      .TopFromProperty = cscHrRecibidoCheque
      .TopNotChange = True
      .Left = 5000
      .LeftLabel = -900
      .LeftNotChange = True
    End With
    Set oProp = c
    oProp.NoShowButton = True

    With .Add(Nothing, c_TotalRecibido)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .name = LNGGetText(3960, vbNullString) 'Total recibidos
      .Key = K_RECIBIDO_TOTAL
      .Value = m_RecibidoTotal
      .Format = m_GeneralConfig.FormatDecImporte
      .TabIndex = 1
      .Enabled = False
      .TopFromProperty = cscHrRecibidoCheque
      .TopToPrevious = 360
    End With

    With .Add(Nothing, c_CobradoT)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .name = LNGGetText(3552, vbNullString) 'Cobrado
      .Key = K_COBRADO_TOTAL
      .Format = m_GeneralConfig.FormatDecImporte
      .TabIndex = 1
      .TopFromProperty = c_TotalRecibido
      .TopNotChange = True
      .Left = 5000
      .LeftLabel = -900
      .LeftNotChange = True
      .Enabled = False
    End With

    With .Add(Nothing, c_CobradoDif)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .name = LNGGetText(3962, vbNullString) 'Diferencia
      .Key = K_COBRADO_DIFERENCIA
      .Format = m_GeneralConfig.FormatDecImporte
      .TabIndex = 1
      .TopFromProperty = c_TotalRecibido
      .TopNotChange = True
      .LeftLabel = -900
      .Left = 7300
      .LeftNotChange = True
      .Enabled = False
    End With

    With .Add(Nothing)
      .PropertyType = cspLabel
      .FontBold = True
      .Value = LNGGetText(1, vbNullString) ' "Faltante / Sobrante"
      .Width = 4000
      .TabIndex = 1
      .LeftFromProperty = c_LabelRecibido
    End With
    
    With .Add(Nothing)
      .PropertyType = cspLabel
      .BackColor = RGB(200, 200, 200)
      .Width = 9000
      .Height = 20
      .TabIndex = 1
      .TopToPrevious = 360
    End With

    With .Add(Nothing, cscHrFaltante)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .name = LNGGetText(4934, vbNullString) 'Faltante
      .Key = K_FALTANTE
      .Value = m_Faltante
      .Format = m_GeneralConfig.FormatDecImporte
      .TabIndex = 1
      .Left = 1500
      .TopToPrevious = 190
      .LeftLabel = -800
    End With

    With .Add(Nothing, cscHrSobrante)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .name = LNGGetText(4935, vbNullString) 'Sobrante
      .Key = K_SOBRANTE
      .Value = m_Sobrante
      .Format = m_GeneralConfig.FormatDecImporte
      .TabIndex = 1
      .TopFromProperty = cscHrFaltante
      .Left = 3900
      .LeftLabel = -800
    End With

    With .Add(Nothing, c_FaltanteComp)
      .PropertyType = cspText
      .name = LNGGetText(1610, vbNullString) 'Comprobante
      .Key = K_MOV_FALTANTE
      .Value = m_MovFaltante
      .TabIndex = 1
      .TopFromProperty = cscHrFaltante
      .Left = 6500
      .Width = 1900
      .LeftLabel = -1080
    End With

    With .Add(Nothing)
      .PropertyType = cspButton
      .name = "..."
      .Key = K_CMD_VER_FALTANTE
      .TabIndex = 1
      .TopFromProperty = cscHrFaltante
      .Width = 300
      .Left = 8500
      .LeftLabel = -1
    End With

'---------------------------------------------------------------------
    
    With .Add(Nothing, cscHrPorcTickets)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .name = LNGGetText(4936, vbNullString) 'Porcentaje sobre tickets
      .Key = K_TICKETS
      .Value = m_porcTickets
      .Format = m_GeneralConfig.FormatDecImporte
      .TabIndex = 1
      .TopFromProperty = cscHrFaltante
      .TopToPrevious = 360
      .Left = 3900
      .LeftLabel = -1900
    End With

    With .Add(Nothing, c_TicketComp)
      .PropertyType = cspText
      .name = LNGGetText(1610, vbNullString) 'Comprobante
      .Key = K_MOV_TICKETS
      .Value = m_MovTickets
      .TabIndex = 1
      .TopFromProperty = cscHrPorcTickets
      .Left = 6500
      .Width = 1900
      .LeftLabel = -1080
    End With

    With .Add(Nothing)
      .PropertyType = cspButton
      .name = "..."
      .Key = K_CMD_VER_TICKETS
      .TabIndex = 1
      .TopFromProperty = cscHrPorcTickets
      .Width = 300
      .Left = 8500
      .LeftLabel = -1
    End With

'---------------------------------------------------------------------

    With .Add(Nothing)
      .PropertyType = cspLabel
      .BackColor = RGB(200, 200, 200)
      .Width = 9000
      .Height = 20
      .TabIndex = 1
      .TopToPrevious = 440
      .LeftFromProperty = c_LabelRecibido
    End With

    With .Add(Nothing, cscHrRecibidoDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Height = 600
      .Width = 7000
      .name = C_strDescrip      'Descripcion
      .Size = 255
      .Key = K_RECIBIDO_DESCRIP
      .Value = m_RecibidoDescrip
      .TabIndex = 1
      .Left = 1700
      .LeftLabel = -1000
      .TopToPrevious = 150
    End With
  
    Set c = .Add(Nothing, c_cobrado)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      .Left = 200
      .Top = 5000
      If Not pLoadCobrado(c, False) Then Exit Function
      .name = c_cobrado
      .Key = K_COBRADO
      .TabIndex = 1
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
      .Enabled = False
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  Set AbmObj = m_ObjAbm
  
  AbmObj.GroupGridEx pGetTodos(), _
                     c_key_col_cliente, _
                     c_key_col_fecha, _
                     4
    
  AbmObj.GroupGridEx pGetCobrado(), _
                     c_key_col_cliente, _
                     c_key_col_fecha, _
                     4
    
  pShowTotal
  pShowTotalCobrado
  
  AbmObj.FormCaption = m_persona & " - "
  AbmObj.RefreshFormCaption
  
  LoadCollection = True
End Function

Private Function Load(ByVal id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As Recordset

  sqlstmt = "sp_HojaRutaGet " & id

  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    C_LoadFunction, _
                    C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscHrId)
    m_Nrodoc = gDB.ValField(rs.fields, cscHrNrodoc)
    m_Numero = gDB.ValField(rs.fields, cscHrNumero)
    m_Fecha = gDB.ValField(rs.fields, cscHrFecha)
    m_Fechaentrega = gDB.ValField(rs.fields, cscHrFechaentrega)
    m_Descrip = gDB.ValField(rs.fields, cscHrDescrip)
    m_Total = gDB.ValField(rs.fields, cscHrTotal)
    m_pendiente = gDB.ValField(rs.fields, cscHrPendiente)
    m_prs_id = gDB.ValField(rs.fields, cscPrsId)
    m_persona = gDB.ValField(rs.fields, cscPrsNombre)
    m_cam_id = gDB.ValField(rs.fields, cscCamId)
    m_Camion = gDB.ValField(rs.fields, cscCamPatente)
    m_cam_id_semi = gDB.ValField(rs.fields, cscCamIdSemi)
    m_Semi = gDB.ValField(rs.fields, cscCamPatentesemi)
    m_chof_id = gDB.ValField(rs.fields, cscChofId)
    m_Chofer = gDB.ValField(rs.fields, cscChofNombre)
    m_suc_id = gDB.ValField(rs.fields, cscSucId)
    m_Sucursal = gDB.ValField(rs.fields, cscSucNombre)
    
    m_cumplida = gDB.ValField(rs.fields, cscHrCumplida)
    
    m_RecibidoCantCheque = gDB.ValField(rs.fields, cscHrRecibidoCantCheque)
    m_RecibidoCheque = gDB.ValField(rs.fields, cscHrRecibidoCheque)
    m_RecibidoDescrip = gDB.ValField(rs.fields, cscHrRecibidoDescrip)
    m_RecibidoEfectivo = gDB.ValField(rs.fields, cscHrRecibidoEfectivo)
    m_RecibidoTotal = m_RecibidoCheque + m_RecibidoEfectivo
    
    m_Faltante = gDB.ValField(rs.fields, cscHrFaltante)
    m_Sobrante = gDB.ValField(rs.fields, cscHrSobrante)
    m_porcTickets = gDB.ValField(rs.fields, cscHrPorcTickets)
    
    m_MovFaltante = gDB.ValField(rs.fields, "mov_faltante")
    m_MovTickets = gDB.ValField(rs.fields, "mov_tickets")
    m_fv_id_faltante = gDB.ValField(rs.fields, cscFvIdFaltante)
    m_mf_id_sobrante = gDB.ValField(rs.fields, cscMfIdSobrante)
    m_mf_id_tickets = gDB.ValField(rs.fields, cscMfIdTickets)

  Else
    
    m_Id = csNO_ID
    m_Nrodoc = vbNullString
    m_Numero = 0
    m_Fecha = Date
    m_Fechaentrega = Date
    m_Descrip = vbNullString
    m_Total = 0
    m_pendiente = 0
    m_prs_id = 0
    m_persona = vbNullString
    m_cam_id = 0
    m_Camion = vbNullString
    m_cam_id_semi = 0
    m_Semi = vbNullString
    m_chof_id = 0
    m_Chofer = vbNullString
    m_suc_id = User.suc_id
    m_Sucursal = User.Sucursal

    m_cumplida = False

    m_RecibidoCantCheque = 0
    m_RecibidoCheque = 0
    m_RecibidoDescrip = vbNullString
    m_RecibidoEfectivo = 0
    m_RecibidoTotal = 0

    m_MovFaltante = vbNullString
    m_MovTickets = vbNullString
    m_fv_id_faltante = csNO_ID
    m_mf_id_sobrante = csNO_ID
    m_mf_id_tickets = csNO_ID

  End If

  If Weekday(Date) = vbMonday Then

    m_FechaDesde = DateAdd("d", -3, Date)
  Else
  
    m_FechaDesde = DateAdd("d", -1, Date)
  End If
  
  m_FechaHasta = Date

  Load = True
  
End Function

Private Function pSaveNroHojaRuta(ByVal hr_id As Long)
  Dim sqlstmt As String
  sqlstmt = "update HojaRuta set hr_nrodoc = right('00000000'+convert(varchar,hr_id),8), hr_numero = hr_id where hr_id = " & hr_id
  pSaveNroHojaRuta = gDB.Execute(sqlstmt)
  m_Nrodoc = Right$("0000000" & hr_id, 8)
End Function

' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(3750, vbNullString) 'Error al grabar la Hoja de Ruta

  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load

  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
  Set m_GeneralConfig = Nothing
  Set m_UserCfg = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

'////////////////////////////////////////////////////////////////////////////////////////////////////////
'
' Implementacion de cIABMClientGrid

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_TODOS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowTodos(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, _
                                                   ByVal lRow As Long, _
                                                   ByVal lCol As Long) As Boolean
  On Error GoTo ControlError
  
  Select Case Key
    Case K_TODOS
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateTodos( _
                                              pGetTodos(), _
                                              lRow, _
                                              lCol)
    Case K_COBRADO
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateCobrado( _
                                              pGetCobrado(), _
                                              lRow, _
                                              lCol)
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnAfterUpdate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pColAUpdateTodos(ByRef IProperty As cIABMProperty, _
                                    ByVal lRow As Long, _
                                    ByVal lCol As Long)
  Dim Row As cIABMGridRow
  
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KI_SELECT
        Set Row = .Rows(lRow)
        If pCell(Row, KI_SELECT).id = 0 Then
          pCell(Row, KI_COBRAR).id = 0
        End If
        pSelectTodo Row, .Columns
        pShowTotal
    
      Case KI_COBRAR
      
        Set Row = .Rows(lRow)
        
        If pCell(Row, KI_TIPO).id = c_Tipo_Factura Then
          If pCell(Row, KI_COBRAR).id Then
            pCell(Row, KI_SELECT).id = -1
          End If
          pSelectTodo Row, .Columns
          pShowTotal
        End If
        
      Case KI_ACOBRAR
      
        Dim ACobrar     As Double
        Dim Pendiente   As Double
      
        Set Row = .Rows(lRow)
      
        ACobrar = Val(pCell(Row, KI_ACOBRAR).Value)
        Pendiente = Val(pCell(Row, KI_PENDIENTE).Value)
      
        If ACobrar < 0 Then ACobrar = 0
        If ACobrar > Pendiente Then ACobrar = Pendiente
        
        pCell(Row, KI_ACOBRAR).Value = ACobrar
        
        pShowTotal
        
    End Select
  End With
  
  pColAUpdateTodos = True
End Function

Private Function pColAUpdateCobrado(ByRef IProperty As cIABMProperty, _
                                    ByVal lRow As Long, _
                                    ByVal lCol As Long)
  Dim Row As cIABMGridRow
  
  With IProperty.Grid
    Select Case .Columns(lCol).Key
    
      Case KI_COBRAR
      
        Set Row = .Rows(lRow)
        
        If pCell(Row, KI_TIPO).id = c_Tipo_Factura Then
          If pCell(Row, KI_COBRAR).id Then
            pCell(Row, KI_SELECT).id = -1
          End If
          pSelectCobrado Row, .Columns
          pShowTotalCobrado
        End If
        
        With pCell(Row, KI_HRCT_ID)
        
          If pCell(Row, KI_COBRAR).id Then
            
            .Value = "Efectivo"
            .id = csHRCT_Efectivo
            
            pCell(Row, KI_HRI_EFECTIVO).Value = pCell(Row, KI_COBRADO).Value
          
          Else
            
            .Value = vbNullString
            .id = csNO_ID
          
            pCell(Row, KI_HRI_ANULADO).Value = 0
            pCell(Row, KI_HRI_CHEQUES).Value = 0
            pCell(Row, KI_HRI_EFECTIVO).Value = 0
            pCell(Row, KI_HRI_NOTASCREDITO).Value = 0
            pCell(Row, KI_HRI_OTROS).Value = 0
            pCell(Row, KI_HRI_RETENCIONES).Value = 0
            pCell(Row, KI_HRI_TARJETA).Value = 0
            pCell(Row, KI_HRI_TICKETS).Value = 0
          End If
        End With
        
      Case KI_COBRADO
      
        Dim Cobrado     As Double
        Dim Pendiente   As Double
      
        Set Row = .Rows(lRow)
      
        Cobrado = Val(pCell(Row, KI_COBRADO).Value)
        Pendiente = Val(pCell(Row, KI_PENDIENTE).Value)
      
        If Cobrado < 0 Then Cobrado = 0
        If Cobrado > Pendiente Then Cobrado = Pendiente
        
        pCell(Row, KI_COBRADO).Value = Cobrado
        
        pShowTotalCobrado
        
      Case KI_HRCT_ID
      
        Set Row = .Rows(lRow)
        
        Cobrado = Val(pCell(Row, KI_COBRADO).Value)
      
        Select Case pCell(Row, KI_HRCT_ID).id
        
          Case csHRCT_Anulada
            pCell(Row, KI_HRI_ANULADO).Value = 0
            pCell(Row, KI_HRI_CHEQUES).Value = 0
            pCell(Row, KI_HRI_EFECTIVO).Value = 0
            pCell(Row, KI_HRI_NOTASCREDITO).Value = Cobrado
            pCell(Row, KI_HRI_OTROS).Value = 0
            pCell(Row, KI_HRI_RETENCIONES).Value = 0
            pCell(Row, KI_HRI_TARJETA).Value = 0
            pCell(Row, KI_HRI_TICKETS).Value = 0
          
          Case csHRCT_AnuladaInterna
            pCell(Row, KI_HRI_ANULADO).Value = Cobrado
            pCell(Row, KI_HRI_CHEQUES).Value = 0
            pCell(Row, KI_HRI_EFECTIVO).Value = 0
            pCell(Row, KI_HRI_NOTASCREDITO).Value = 0
            pCell(Row, KI_HRI_OTROS).Value = 0
            pCell(Row, KI_HRI_RETENCIONES).Value = 0
            pCell(Row, KI_HRI_TARJETA).Value = 0
            pCell(Row, KI_HRI_TICKETS).Value = 0
          
          Case csHRCT_AnuladaParcial
            ' Nada que hacer
          
          Case csHRCT_Cheque
            pCell(Row, KI_HRI_ANULADO).Value = 0
            pCell(Row, KI_HRI_CHEQUES).Value = Cobrado
            pCell(Row, KI_HRI_EFECTIVO).Value = 0
            pCell(Row, KI_HRI_NOTASCREDITO).Value = 0
            pCell(Row, KI_HRI_OTROS).Value = 0
            pCell(Row, KI_HRI_RETENCIONES).Value = 0
            pCell(Row, KI_HRI_TARJETA).Value = 0
            pCell(Row, KI_HRI_TICKETS).Value = 0
            
          Case csHRCT_CuentaCorriente
            pCell(Row, KI_COBRADO).Value = 0
            pCell(Row, KI_HRI_ANULADO).Value = 0
            pCell(Row, KI_HRI_CHEQUES).Value = 0
            pCell(Row, KI_HRI_EFECTIVO).Value = 0
            pCell(Row, KI_HRI_NOTASCREDITO).Value = 0
            pCell(Row, KI_HRI_OTROS).Value = 0
            pCell(Row, KI_HRI_RETENCIONES).Value = 0
            pCell(Row, KI_HRI_TARJETA).Value = 0
            pCell(Row, KI_HRI_TICKETS).Value = 0
          
          Case csHRCT_Efectivo
            pCell(Row, KI_HRI_ANULADO).Value = 0
            pCell(Row, KI_HRI_CHEQUES).Value = 0
            pCell(Row, KI_HRI_EFECTIVO).Value = Cobrado
            pCell(Row, KI_HRI_NOTASCREDITO).Value = 0
            pCell(Row, KI_HRI_OTROS).Value = 0
            pCell(Row, KI_HRI_RETENCIONES).Value = 0
            pCell(Row, KI_HRI_TARJETA).Value = 0
            pCell(Row, KI_HRI_TICKETS).Value = 0

          Case csHRCT_PagoParcial
            ' Nada que hacer
            
          Case csHRCT_PendienteReparto
            pCell(Row, KI_COBRADO).Value = 0
            pCell(Row, KI_HRI_ANULADO).Value = 0
            pCell(Row, KI_HRI_CHEQUES).Value = 0
            pCell(Row, KI_HRI_EFECTIVO).Value = 0
            pCell(Row, KI_HRI_NOTASCREDITO).Value = 0
            pCell(Row, KI_HRI_OTROS).Value = 0
            pCell(Row, KI_HRI_RETENCIONES).Value = 0
            pCell(Row, KI_HRI_TARJETA).Value = 0
            pCell(Row, KI_HRI_TICKETS).Value = 0
          
          Case csHRCT_Tarjeta
            pCell(Row, KI_HRI_ANULADO).Value = 0
            pCell(Row, KI_HRI_CHEQUES).Value = 0
            pCell(Row, KI_HRI_EFECTIVO).Value = 0
            pCell(Row, KI_HRI_NOTASCREDITO).Value = 0
            pCell(Row, KI_HRI_OTROS).Value = 0
            pCell(Row, KI_HRI_RETENCIONES).Value = 0
            pCell(Row, KI_HRI_TARJETA).Value = Cobrado
            pCell(Row, KI_HRI_TICKETS).Value = 0
          
          Case csHRCT_Tickets
            pCell(Row, KI_HRI_ANULADO).Value = 0
            pCell(Row, KI_HRI_CHEQUES).Value = 0
            pCell(Row, KI_HRI_EFECTIVO).Value = 0
            pCell(Row, KI_HRI_NOTASCREDITO).Value = 0
            pCell(Row, KI_HRI_OTROS).Value = 0
            pCell(Row, KI_HRI_RETENCIONES).Value = 0
            pCell(Row, KI_HRI_TARJETA).Value = 0
            pCell(Row, KI_HRI_TICKETS).Value = Cobrado
        
        End Select
      
        pShowTotalCobrado
      
    End Select
  End With
  
  pColAUpdateCobrado = True
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_TODOS
      cIABMClientGrid_ColumnAfterEdit = pColumnAfterEditTodos(m_ObjAbm.Properties(c_Todos), lRow, lCol, NewValue, NewValueID)
  
    Case K_COBRADO
      cIABMClientGrid_ColumnAfterEdit = True
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnAfterEdit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_TODOS
      cIABMClientGrid_ColumnBeforeEdit = pColumnBeforeEditTodos(m_ObjAbm.Properties(c_Todos), lRow, lCol, iKeyAscii)
    Case K_COBRADO
      cIABMClientGrid_ColumnBeforeEdit = pColumnBeforeEditCobrado(m_ObjAbm.Properties(c_cobrado), lRow, lCol, iKeyAscii)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnBeforeEdit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)
  On Error GoTo ControlError
  
  Dim id          As Long
  Dim ObjEditName As String
  Dim tipo        As Long
  Dim iProp       As cIABMProperty
  
  Select Case Key

    Case K_COBRADO
      
      If lCol <> 11 And lCol <> 16 And lCol <> 17 Then
      
        Set iProp = pGetCobrado()
        
        id = Val(pCell(iProp.Grid.Rows.Item(lRow), KI_ID).Value)
        
        If id <> csNO_ID Then
        
          ObjEditName = "CSVenta2.cFacturaVenta"
          pShowDocAux id, _
                      ObjEditName, _
                      "CSABMInterface2.cABMGeneric"
        End If
      
      End If
      
    Case K_TODOS
      
      Set iProp = pGetTodos()
      
      If lCol = 12 Or lCol = 9 Or lCol = 7 Then
      
        With iProp.Grid.Rows
          
          id = Val(pCell(.Item(lRow), KI_ID).Value)
          
          If id <> csNO_ID Then
            
            tipo = pCell(.Item(lRow), KI_TIPO).id
            
            Select Case tipo
            
              Case c_Tipo_Factura
              
                ObjEditName = "CSVenta2.cFacturaVenta"
                
              Case c_Tipo_Orden
              
                ObjEditName = "CSTicket.cOrdenServicio"
              
              Case c_Tipo_Parte
              
                id = id * -1
                ObjEditName = "CSEnvio2.cParteDiario"
                
              Case c_Tipo_Remito
              
                ObjEditName = "CSVenta2.cRemitoVenta"
  
            End Select
  
            If id > 0 Then
              ShowDocAux id, _
                         ObjEditName, _
                         "CSABMInterface2.cABMGeneric"
            
            Else
            
              pEditParteDiario id * -1
            
            End If
          End If
        End With
      End If
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_DblClick", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean

End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_TODOS
      cIABMClientGrid_ValidateRow = pValidateRowTodos(Row, RowIndex)
    Case K_COBRADO
      cIABMClientGrid_ValidateRow = pValidateRowCobrado(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pIsEmptyRowTodos(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  pIsEmptyRowTodos = False
End Function

Private Function pIsEmptyRowFacturas(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  pIsEmptyRowFacturas = False
End Function

Private Function pIsEmptyRowRemitos(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  pIsEmptyRowRemitos = False
End Function

Private Function pIsEmptyRowPartes(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  pIsEmptyRowPartes = False
End Function

Private Function pIsEmptyRowOrdenes(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  pIsEmptyRowOrdenes = False
End Function

Private Function pColumnAfterEditTodos(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  pColumnAfterEditTodos = True
End Function

Private Function pColumnAfterEditOrdenes(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  pColumnAfterEditOrdenes = True
End Function

Private Function pColumnAfterEditRemitos(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  pColumnAfterEditRemitos = True
End Function

Private Function pColumnAfterEditFacturas(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  pColumnAfterEditFacturas = True
End Function

Private Function pColumnAfterEditPartes(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  pColumnAfterEditPartes = True
End Function

Private Function pColumnBeforeEditCobrado(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
  Dim Key As Long
  Dim Row As cIABMGridRow
  
  Key = IProperty.Grid.Columns(lCol).Key
  
  Select Case Key
    
    Case KI_COBRADO, KI_COBRAR, KI_FV_VTO
    
      Set Row = IProperty.Grid.Rows(lRow)

      If pCell(Row, KI_TIPO).id = c_Tipo_Factura Then
      
        If Key = KI_COBRADO Then
      
          pColumnBeforeEditCobrado = pCell(Row, KI_COBRAR).id
        Else
          pColumnBeforeEditCobrado = True
        End If
      End If
      
    Case KI_HRCT_ID, KI_HRI_ANULADO, KI_HRI_CHEQUES, KI_HRI_EFECTIVO, KI_HRI_NOTASCREDITO, KI_HRI_OTROS, KI_HRI_RETENCIONES, KI_HRI_TARJETA, KI_HRI_TICKETS
    
      Set Row = IProperty.Grid.Rows(lRow)
      
      pColumnBeforeEditCobrado = pCell(Row, KI_COBRAR).id
      
  End Select
  
End Function

Private Function pColumnBeforeEditTodos(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
  Dim Key As Long
  Dim Row As cIABMGridRow
  Dim oRow As cABMGridRow
  
  Set Row = IProperty.Grid.Rows(lRow)

  Set oRow = Row
  
  If Not oRow.IsGroup Then
  
    Key = IProperty.Grid.Columns(lCol).Key
    
    Select Case Key
      Case KI_SELECT, KI_ORDEN, KI_DESCRIP
      
        pColumnBeforeEditTodos = True
      
      Case KI_ACOBRAR, KI_COBRAR
  
        If pCell(Row, KI_TIPO).id = c_Tipo_Factura Then
        
          If Key = KI_ACOBRAR Then
        
            pColumnBeforeEditTodos = pCell(Row, KI_COBRAR).id
          Else
            pColumnBeforeEditTodos = True
          End If
        End If
        
      Case KI_CUMPLIDO
              
        pColumnBeforeEditTodos = pCell(Row, KI_TIPO).id = c_Tipo_Parte
        
    End Select
  
  End If
  
End Function

Private Function pValidateRowTodos(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  Dim oRow As cABMGridRow
  Set oRow = Row
  
  If Not oRow.IsGroup Then
  
    If pCell(Row, KI_SELECT).id Then
    
      strRow = " (Fila " & RowIndex & ")"
      
      For Each Cell In Row
        Select Case Cell.Key
          
          Case KI_ACOBRAR
            If Val(Cell.Value) < 0 Then
              
              MsgInfo LNGGetText(3757, vbNullString, strRow)
                      'El importe a cobrar no puede ser menor a cero
              Exit Function
            End If
        
        End Select
      Next
      
    End If
  End If
  
  pValidateRowTodos = True
End Function

Private Function pValidateRowCobrado(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell     As cIABMGridCellValue
  Dim strRow   As String
  Dim hri_id   As csE_HojaRutaCobranzaTipo
  
  Dim oRow As cABMGridRow
  Set oRow = Row
  
  Dim Cobrado     As Double
  Dim SumCobrado  As Double
  
  If Not oRow.IsGroup Then
  
    If pCell(Row, KI_SELECT).id Then
    
      ' En esta grilla el rowindex no me da el indice de fila
      ' por que las filas estan agrupadas
      '
      strRow = " (Fila " & Row.Item(3).Value & ")"
      
      For Each Cell In Row
        Select Case Cell.Key
          
          Case KI_COBRADO
            
            If Val(Cell.Value) < 0 Then
              
              MsgInfo LNGGetText(3757, vbNullString, strRow)
                      'El importe a cobrado no puede ser menor a cero
              Exit Function
            End If
            
            Cobrado = Val(Cell.Value)
            
          Case KI_HRI_ANULADO, KI_HRI_CHEQUES, KI_HRI_EFECTIVO, _
               KI_HRI_NOTASCREDITO, KI_HRI_OTROS, KI_HRI_RETENCIONES, _
               KI_HRI_TARJETA, KI_HRI_TICKETS
        
            If Val(Cell.Value) < 0 Then
              
              MsgInfo LNGGetText(4955, vbNullString, strRow)
                      'El importe indicado en cualquiera de las columnas anulado, cheques, efectivo, notas de credito, retenciones, otros, tarjeta, tickets no puede ser menor a cero
              Exit Function
            End If
            
            SumCobrado = SumCobrado + Val(Cell.Value)
            
          Case KI_HRI_ID
          
            hri_id = Cell.id
        
        End Select
      Next
      
    End If
  End If
  
  If Cobrado <> SumCobrado _
     And hri_id <> csHRCT_CuentaCorriente _
     And hri_id <> csHRCT_PendienteReparto Then
  
    MsgInfo LNGGetText(4956, vbNullString, strRow)
            'El importe indicado en la columna cobrado difiere de la suma de las columnas de detalle (efectivo, cheques, etc.)
    Exit Function
  
  End If
  
  pValidateRowCobrado = True
End Function

Private Function pLoadTodos(ByRef iProp As cIABMProperty, _
                            ByVal bLoadAll As Boolean) As Boolean
  With iProp.Grid
  
    With .Columns
    
      .Clear
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_HRI_ID
      End With
            
      With .Add(Nothing)
        .Visible = False
        .Key = KI_ID
      End With

      With .Add(Nothing, c_key_col_cliente)
        .Visible = False
        .name = cscCliId
        .Key = KI_CLIENTE
      End With
            
      With .Add(Nothing)
        .name = LNGGetText(1223, vbNullString) 'Tipo
        .PropertyType = cspText
        .Visible = True
        .Key = KI_TIPO
      End With
            
      With .Add(Nothing, c_select_key)
        .PropertyType = cspCheck
        .Width = 320
        .Key = KI_SELECT
      End With
            
      With .Add(Nothing, c_key_col_fecha)
        .PropertyType = cspDate
        .name = LNGGetText(1569, vbNullString) 'Fecha
        .Key = KI_FECHA
      End With
            
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .Width = 320
        .name = LNGGetText(1809, vbNullString) 'Orden
        .Key = KI_ORDEN
      End With
      
      With .Add(Nothing)
        .PropertyType = cspCheck
        .Width = 320
        .name = LNGGetText(1690, vbNullString) 'Cobrar
        .Key = KI_COBRAR
      End With
      
      With .Add(Nothing)
        .PropertyType = cspText
        .name = LNGGetText(1065, vbNullString) 'Numero
        .Key = KI_NRODOC
      End With
            
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .name = LNGGetText(1228, vbNullString) 'Importe
        .Key = KI_IMPORTE
        .Format = m_GeneralConfig.FormatDecImporte
      End With
            
      With .Add(Nothing)
        .PropertyType = cspText
        .name = LNGGetText(1864, vbNullString) 'Titulo
        .Key = KI_TITULO
      End With
      
      With .Add(Nothing)
        .Key = KI_PENDIENTE
        .Visible = False
      End With
      
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .name = LNGGetText(1690, vbNullString) 'Cobrar
        .Key = KI_ACOBRAR
        .Format = m_GeneralConfig.FormatDecImporte
      End With
            
      With .Add(Nothing)
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .name = LNGGetText(1861, vbNullString) 'Observaciones
        .Key = KI_DESCRIP
      End With
            
      With .Add(Nothing)
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .name = LNGGetText(3951, vbNullString) 'Ordenes de Trabajo
        .Key = KI_OTS
      End With
            
      With .Add(Nothing)
        .PropertyType = cspCheck
        .name = LNGGetText(2340, vbNullString) 'Cumplido
        .Key = KI_CUMPLIDO
        .Format = m_GeneralConfig.FormatDecImporte
      End With
                  
      ' Solo se usa para tener el importe cobrado
      ' que se registra en la solapa recibido
      '
      With .Add(Nothing)
        .Visible = False
        .Key = KI_COBRADO
      End With
            
    End With
  
    .Rows.Clear
    
  End With

  Dim sqlstmt       As String
  Dim rsOrdenes     As ADODB.Recordset
  Dim rsRemitos     As ADODB.Recordset
  Dim rsFacturas    As ADODB.Recordset
  Dim rsPartes      As ADODB.Recordset
  
  ' Ordenes
  '
  sqlstmt = "sp_HojaRutaGetItems " & m_Id & ",1,0,0,0"
  If Not gDB.OpenRs(sqlstmt, _
                    rsOrdenes, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pLoadTodos", _
                    C_Module) Then Exit Function
  
  ' Remitos
  '
  sqlstmt = "sp_HojaRutaGetItems " & m_Id & ",0,1,0,0"
  If Not gDB.OpenRs(sqlstmt, _
                    rsRemitos, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pLoadTodos", _
                    C_Module) Then Exit Function
  
  ' Facturas
  '
  sqlstmt = "sp_HojaRutaGetItems " & m_Id & ",0,0,1,0"
  If Not gDB.OpenRs(sqlstmt, _
                    rsFacturas, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pLoadTodos", _
                    C_Module) Then Exit Function
  
  ' Partes
  '
  sqlstmt = "sp_HojaRutaGetItems " & m_Id & ",0,0,0,1"
  If Not gDB.OpenRs(sqlstmt, _
                    rsPartes, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pLoadTodos", _
                    C_Module) Then Exit Function
  
  pLoadTodosIngrid rsOrdenes, rsRemitos, rsFacturas, rsPartes, iProp.Grid.Rows, 1
  
  If bLoadAll Then
  
    Dim strFechaDesde As String
    Dim strFechaHasta As String
    Dim strClienteId  As String
    Dim strEstadoId   As String
    
    With m_ObjAbm.Properties
      
      m_FechaDesde = .Item(c_T_FECHA_DESDE).Value
      m_FechaHasta = .Item(c_T_FECHA_HASTA).Value
      
      strFechaDesde = gDB.sqlDate(m_FechaDesde)
      strFechaHasta = gDB.sqlDate(m_FechaHasta)
      
      With .Item(c_T_CLI_ID)
        m_ram_id_cliente = .HelpValueProcess
        m_RamaCliente = .Value
      End With
      
      With .Item(c_T_ESTADO)
        m_ram_id_estado = .HelpValueProcess
        m_RamaEstado = .Value
      End With
      
    End With
    
    strClienteId = gDB.sqlString(m_ram_id_cliente)
    strEstadoId = gDB.sqlString(m_ram_id_estado)
        
    ' Ordenes
    '
    sqlstmt = "sp_HojaRutaGetOrdenes " _
                  & strFechaDesde & "," _
                  & strFechaHasta & "," _
                  & strClienteId & "," _
                  & strEstadoId & "," _
                  & m_Id
    
    If Not gDB.OpenRs(sqlstmt, _
                      rsOrdenes, _
                      csRsStatic, _
                      csLockReadOnly, _
                      csCmdText, _
                      "pLoadTodos", _
                      C_Module) Then Exit Function
    
    ' Remitos
    '
    sqlstmt = "sp_HojaRutaGetRemitos " _
                  & strFechaDesde & "," _
                  & strFechaHasta & "," _
                  & strClienteId & "," _
                  & strEstadoId & "," _
                  & m_Id
    
    If Not gDB.OpenRs(sqlstmt, _
                      rsRemitos, _
                      csRsStatic, _
                      csLockReadOnly, _
                      csCmdText, _
                      "pLoadTodos", _
                      C_Module) Then Exit Function
    
    ' Facturas
    '
    sqlstmt = "sp_HojaRutaGetFacturas " _
                  & strFechaDesde & "," _
                  & strFechaHasta & "," _
                  & strClienteId & "," _
                  & strEstadoId & "," _
                  & m_Id
    
    If Not gDB.OpenRs(sqlstmt, _
                      rsFacturas, _
                      csRsStatic, _
                      csLockReadOnly, _
                      csCmdText, _
                      "pLoadTodos", _
                      C_Module) Then Exit Function
    
    ' Partes
    '
    sqlstmt = "sp_HojaRutaGetPartes " _
                  & strFechaDesde & "," _
                  & strFechaHasta & "," _
                  & strClienteId & "," _
                  & strEstadoId & "," _
                  & m_Id
    
    If Not gDB.OpenRs(sqlstmt, _
                      rsPartes, _
                      csRsStatic, _
                      csLockReadOnly, _
                      csCmdText, _
                      "pLoadTodos", _
                      C_Module) Then Exit Function
    
    ' Carga
    '
    pLoadTodosIngrid rsOrdenes, rsRemitos, rsFacturas, rsPartes, iProp.Grid.Rows, 0

    
  End If

  pLoadTodos = True

End Function

Private Function pLoadCobrado(ByRef iProp As cIABMProperty, _
                              ByVal bLoadAll As Boolean) As Boolean
  With iProp.Grid
  
    With .Columns
    
      .Clear
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_HRI_ID
      End With
            
      With .Add(Nothing)
        .Visible = False
        .Key = KI_ID
      End With

      With .Add(Nothing, c_key_col_cliente)
        .Visible = False
        .name = cscCliId
        .Key = KI_CLIENTE
      End With
            
      With .Add(Nothing)
        .name = LNGGetText(1223, vbNullString) 'Tipo
        .PropertyType = cspText
        .Visible = True
        .Key = KI_TIPO
      End With
            
      With .Add(Nothing)
        .PropertyType = cspCheck
        .Width = 320
        .Key = KI_SELECT
      End With
            
      With .Add(Nothing, c_key_col_fecha)
        .PropertyType = cspDate
        .name = LNGGetText(1569, vbNullString) 'Fecha
        .Key = KI_FECHA
      End With
            
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .Width = 320
        .name = LNGGetText(1809, vbNullString) 'Orden
        .Key = KI_ORDEN
      End With
      
      With .Add(Nothing)
        .PropertyType = cspCheck
        .Width = 320
        .name = LNGGetText(1690, vbNullString) 'Cobrar
        .Key = KI_COBRAR
      End With
      
      With .Add(Nothing)
        .PropertyType = cspText
        .name = LNGGetText(1065, vbNullString) 'Numero
        .Key = KI_NRODOC
      End With
            
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .name = LNGGetText(1228, vbNullString) 'Importe
        .Key = KI_IMPORTE
        .Format = m_GeneralConfig.FormatDecImporte
      End With
            
      With .Add(Nothing)
        .PropertyType = cspDate
        .name = LNGGetText(5058, vbNullString) 'Nuevo Vto.
        .Key = KI_FV_VTO
      End With
            
      With .Add(Nothing)
        .PropertyType = cspText
        .name = LNGGetText(1864, vbNullString) 'Titulo
        .Key = KI_TITULO
        .Visible = False
      End With
      
      With .Add(Nothing)
        .Key = KI_PENDIENTE
        .Visible = False
      End With
      
      With .Add(Nothing)
        .PropertyType = cspHelp
        .Table = csETablesVentas.csHojaRutaCobranzaTipo
        .name = LNGGetText(2060, vbNullString) 'Cobranza
        .Key = KI_HRCT_ID
      End With
      
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .name = LNGGetText(4957, vbNullString) 'Total
        .Key = KI_COBRADO
        .Format = m_GeneralConfig.FormatDecImporte
      End With
                        
      '------------------------------------------------------------
      'KI_HRI_EFECTIVO
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .name = LNGGetText(4949, vbNullString) 'Efectivo
        .Key = KI_HRI_EFECTIVO
        .Format = m_GeneralConfig.FormatDecImporte
      End With
      'KI_HRI_CHEQUES
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .name = LNGGetText(4948, vbNullString) 'Cheques
        .Key = KI_HRI_CHEQUES
        .Format = m_GeneralConfig.FormatDecImporte
      End With
      'KI_HRI_TARJETA
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .name = LNGGetText(4952, vbNullString) 'Tarjeta
        .Key = KI_HRI_TARJETA
        .Format = m_GeneralConfig.FormatDecImporte
      End With
      'KI_HRI_TICKETS
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .name = LNGGetText(4953, vbNullString) 'Tickets
        .Key = KI_HRI_TICKETS
        .Format = m_GeneralConfig.FormatDecImporte
      End With
      'KI_HRI_ANULADO
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .name = LNGGetText(4947, vbNullString) 'Anulado
        .Key = KI_HRI_ANULADO
        .Format = m_GeneralConfig.FormatDecImporte
      End With
      'KI_HRI_NOTASCREDITO
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .name = LNGGetText(4950, vbNullString) 'Notas de Credito
        .Key = KI_HRI_NOTASCREDITO
        .Format = m_GeneralConfig.FormatDecImporte
      End With
      'KI_HRI_RETENCIONES
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .name = LNGGetText(4951, vbNullString) 'Retenciones
        .Key = KI_HRI_RETENCIONES
        .Format = m_GeneralConfig.FormatDecImporte
      End With
      'KI_HRI_OTROS
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .name = LNGGetText(4954, vbNullString) 'Otros
        .Key = KI_HRI_OTROS
        .Format = m_GeneralConfig.FormatDecImporte
      End With
      '------------------------------------------------------------
            
      With .Add(Nothing)
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .name = LNGGetText(1861, vbNullString) 'Observaciones
        .Key = KI_DESCRIP
      End With
            
      With .Add(Nothing)
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .name = LNGGetText(3951, vbNullString) 'Ordenes de Trabajo
        .Key = KI_OTS
      End With
            
    End With
    
    .Rows.Clear
    
  End With

  Dim sqlstmt       As String
  Dim rsFacturas    As ADODB.Recordset
  
  ' Facturas
  '
  sqlstmt = "sp_HojaRutaGetItems " & m_Id & ",0,0,1,0"
  If Not gDB.OpenRs(sqlstmt, _
                    rsFacturas, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pLoadCobrado", _
                    C_Module) Then Exit Function
  
  pLoadCobradoIngrid rsFacturas, iProp.Grid.Rows, 1

  pLoadCobrado = True

End Function

Private Sub pLoadTodosIngrid(ByRef rsOrdenes As ADODB.Recordset, _
                             ByRef rsRemitos As ADODB.Recordset, _
                             ByRef rsFacturas As ADODB.Recordset, _
                             ByRef rsPartes As ADODB.Recordset, _
                             ByRef Rows As cIABMGridRows, _
                             ByVal iSelected As Long)

  pLoadOrdenesTIngrid rsOrdenes, Rows, iSelected
  pLoadRemitosTIngrid rsRemitos, Rows, iSelected
  pLoadFacturasTIngrid rsFacturas, Rows, iSelected
  pLoadPartesTIngrid rsPartes, Rows, iSelected
  
End Sub

Private Sub pLoadPartesTIngrid(ByRef rs As ADODB.Recordset, _
                               ByRef Rows As cIABMGridRows, _
                               ByVal iSelected As Long)
  Dim Row As cIABMGridRow
  
  With Rows
      
    While Not rs.EOF
    
      If iSelected Then
        Set Row = .Add(Nothing, rs(cscHriId).Value)
      Else
        Set Row = .Add(Nothing)
      End If
    
      With Row
      
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscHriId)
          .Key = KI_HRI_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPtdId)
          .Key = KI_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscCliNombre)
          .id = gDB.ValField(rs.fields, cscCliId)
          .Key = KI_CLIENTE
        End With
        
        With .Add(Nothing)
          .Value = "PT"
          .id = c_Tipo_Parte
          .Key = KI_TIPO
        End With
        
        With .Add(Nothing)
          .id = iSelected
          .Key = KI_SELECT
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPtdFechaini)
          .Key = KI_FECHA
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscHriOrden)
          .Key = KI_ORDEN
        End With
        
        .Add(Nothing).Key = KI_COBRAR
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPtdNumero)
          .Key = KI_NRODOC
        End With
        
        .Add(Nothing).Key = KI_IMPORTE
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPtdTitulo)
          .Key = KI_TITULO
        End With

        .Add(Nothing).Key = KI_PENDIENTE
        .Add(Nothing).Key = KI_ACOBRAR

        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscHriDescrip)
          .Key = KI_DESCRIP
        End With
        
        .Add(Nothing).Key = KI_OTS
        
        With .Add(Nothing)
          .id = gDB.ValField(rs.fields, "ptd_cumplido")
          .Key = KI_CUMPLIDO
        End With
        
        .Add(Nothing).Key = KI_COBRADO
        
      End With
      
      rs.MoveNext
    Wend
  End With
End Sub

Private Sub pLoadCobradoIngrid(ByRef rs As ADODB.Recordset, _
                               ByRef Rows As cIABMGridRows, _
                               ByVal iSelected As Long)
  Dim Row     As cIABMGridRow
  Dim Cobrado As Double
  Dim doct_id As Long
  
  With Rows
      
    While Not rs.EOF
    
      doct_id = gDB.ValField(rs.fields, cscDoctId)
      
      If doct_id <> 7 Then
    
        Cobrado = gDB.ValField(rs.fields, cscHriCobrado)
      
        If iSelected Then
          Set Row = .Add(Nothing, rs(cscHriId).Value)
        Else
          Set Row = .Add(Nothing)
        End If
      
        With Row
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscHriId)
            .Key = KI_HRI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFvId)
            .Key = KI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCliNombre)
            .id = gDB.ValField(rs.fields, cscCliId)
            .Key = KI_CLIENTE
          End With
          
          With .Add(Nothing)
            .Value = "FV"
            .id = c_Tipo_Factura
            .Key = KI_TIPO
          End With
          
          With .Add(Nothing)
            .id = iSelected
            .Key = KI_SELECT
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFvFecha)
            .Key = KI_FECHA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscHriOrden)
            .Key = KI_ORDEN
          End With
          
          With .Add(Nothing)
            .id = IIf(Cobrado, 1, 0)
            .Key = KI_COBRAR
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFvNrodoc)
            .Key = KI_NRODOC
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFvTotal)
            .Key = KI_IMPORTE
          End With
          
          With .Add(Nothing)
            If gDB.ValField(rs.fields, cscFvFechaVto) <> csNoDate Then
              .Value = gDB.ValField(rs.fields, cscFvFechaVto)
            End If
            .Key = KI_FV_VTO
          End With
          
          .Add(Nothing).Key = KI_TITULO
  
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFvPendiente)
            .Key = KI_PENDIENTE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscHrctNombre)
            .id = gDB.ValField(rs.fields, cscHrctId)
            .Key = KI_HRCT_ID
          End With
          
          With .Add(Nothing)
            .Value = Cobrado
            .Key = KI_COBRADO
          End With
          
          '------------------------------------------------------------
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscHriEfectivo)
            .Key = KI_HRI_EFECTIVO
          End With
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscHriCheques)
            .Key = KI_HRI_CHEQUES
          End With
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscHriTarjeta)
            .Key = KI_HRI_TARJETA
          End With
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscHriTickets)
            .Key = KI_HRI_TICKETS
          End With
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscHriAnulado)
            .Key = KI_HRI_ANULADO
          End With
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscHriNotascredito)
            .Key = KI_HRI_NOTASCREDITO
          End With
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscHriRetenciones)
            .Key = KI_HRI_RETENCIONES
          End With
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscHriOtros)
            .Key = KI_HRI_OTROS
          End With
          '------------------------------------------------------------
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscHriDescrip)
            .Key = KI_DESCRIP
          End With
          
          .Add(Nothing).Key = KI_OTS
          
        End With
      
      End If
      
      rs.MoveNext
    Wend
  End With
End Sub

Private Sub pLoadFacturasTIngrid(ByRef rs As ADODB.Recordset, _
                                 ByRef Rows As cIABMGridRows, _
                                 ByVal iSelected As Long)
  Dim Row     As cIABMGridRow
  Dim oRow    As cABMGridRow
  Dim doct_id As Long
  
  With Rows
      
    While Not rs.EOF
    
      If iSelected Then
        Set Row = .Add(Nothing, rs(cscHriId).Value)
      Else
        Set Row = .Add(Nothing)
      End If
      
      Set oRow = Row
      
      If gDB.ValField(rs.fields, "iluminar") Then
        oRow.BackColor = RGB(205, 205, 235)
      End If
    
      With Row
      
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscHriId)
          .Key = KI_HRI_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscFvId)
          .Key = KI_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscCliNombre)
          .id = gDB.ValField(rs.fields, cscCliId)
          .Key = KI_CLIENTE
        End With
        
        With .Add(Nothing)
          doct_id = gDB.ValField(rs.fields, cscDoctId)
          If doct_id = 7 Then
            .Value = "NC"
          Else
            .Value = "FV"
          End If
          .id = c_Tipo_Factura
          .Key = KI_TIPO
        End With
        
        With .Add(Nothing)
          .id = iSelected
          .Key = KI_SELECT
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscFvFecha)
          .Key = KI_FECHA
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscHriOrden)
          .Key = KI_ORDEN
        End With
        
        With .Add(Nothing)
          .id = gDB.ValField(rs.fields, "cobrar")
          .Key = KI_COBRAR
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscFvNrodoc)
          .Key = KI_NRODOC
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscFvTotal)
          .Key = KI_IMPORTE
        End With
        
        .Add(Nothing).Key = KI_TITULO

        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscFvPendiente)
          .Key = KI_PENDIENTE
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscHriACobrar)
          .Key = KI_ACOBRAR
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscHriDescrip)
          .Key = KI_DESCRIP
        End With
        
        .Add(Nothing).Key = KI_OTS
        .Add(Nothing).Key = KI_CUMPLIDO
                
        If iSelected Then
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscHriCobrado)
            .Key = KI_COBRADO
          End With
        Else
          .Add(Nothing).Key = KI_COBRADO
        End If
        
      End With
      
      rs.MoveNext
    Wend
  End With
End Sub

Private Sub pLoadRemitosTIngrid(ByRef rs As ADODB.Recordset, _
                                ByRef Rows As cIABMGridRows, _
                                ByVal iSelected As Long)
  Dim Row As cIABMGridRow
  
  With Rows
      
    While Not rs.EOF
    
      If iSelected Then
        Set Row = .Add(Nothing, rs(cscHriId).Value)
      Else
        Set Row = .Add(Nothing)
      End If
    
      With Row
      
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscHriId)
          .Key = KI_HRI_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscRvId)
          .Key = KI_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscCliNombre)
          .id = gDB.ValField(rs.fields, cscCliId)
          .Key = KI_CLIENTE
        End With
        
        With .Add(Nothing)
          .Value = "RV"
          .id = c_Tipo_Remito
          .Key = KI_TIPO
        End With
        
        With .Add(Nothing)
          .id = iSelected
          .Key = KI_SELECT
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscRvFecha)
          .Key = KI_FECHA
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscHriOrden)
          .Key = KI_ORDEN
        End With
        
        .Add(Nothing).Key = KI_COBRAR
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscRvNrodoc)
          .Key = KI_NRODOC
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscRvTotal)
          .Key = KI_IMPORTE
        End With
        
        .Add(Nothing).Key = KI_TITULO
        .Add(Nothing).Key = KI_PENDIENTE
        .Add(Nothing).Key = KI_ACOBRAR
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscHriDescrip)
          .Key = KI_DESCRIP
        End With
        
        .Add(Nothing).Key = KI_OTS
        .Add(Nothing).Key = KI_CUMPLIDO
        .Add(Nothing).Key = KI_COBRADO
        
      End With
      
      rs.MoveNext
    Wend
  End With
End Sub

Private Sub pLoadOrdenesTIngrid(ByRef rs As ADODB.Recordset, _
                                ByRef Rows As cIABMGridRows, _
                                ByVal iSelected As Long)
  Dim Row As cIABMGridRow
  
  With Rows
      
    While Not rs.EOF
    
      If iSelected Then
        Set Row = .Add(Nothing, rs(cscHriId).Value)
      Else
        Set Row = .Add(Nothing)
      End If
    
      With Row
      
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscHriId)
          .Key = KI_HRI_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOsId)
          .Key = KI_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscCliNombre)
          .id = gDB.ValField(rs.fields, cscCliId)
          .Key = KI_CLIENTE
        End With
        
        With .Add(Nothing)
          .Value = "OS"
          .id = c_Tipo_Orden
          .Key = KI_TIPO
        End With
        
        With .Add(Nothing)
          .id = iSelected
          .Key = KI_SELECT
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOsFecha)
          .Key = KI_FECHA
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscHriOrden)
          .Key = KI_ORDEN
        End With
        
        .Add(Nothing).Key = KI_COBRAR
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOsNrodoc)
          .Key = KI_NRODOC
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscOsTotal)
          .Key = KI_IMPORTE
        End With
        
        .Add(Nothing).Key = KI_TITULO
        .Add(Nothing).Key = KI_PENDIENTE
        .Add(Nothing).Key = KI_ACOBRAR
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscHriDescrip)
          .Key = KI_DESCRIP
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, "ots")
          .Key = KI_OTS
        End With
        
        .Add(Nothing).Key = KI_CUMPLIDO
        .Add(Nothing).Key = KI_COBRADO
                
      End With
      
      rs.MoveNext
    Wend
  End With
End Sub

Private Function pSaveItemsCobrado(ByVal id As Long) As Boolean
  Dim register  As cRegister
  Dim fields    As cFields
  Dim CompId    As Long
  Dim oRow      As cABMGridRow
  
  With pGetCobrado()
    
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
    Set oRow = Row
    If Not oRow.IsGroup Then
    
      If pCell(Row, KI_SELECT).id Then
    
        Set register = New cRegister
        
        With register
          
          Set fields = .fields
          .fieldId = cscHriId
          .Table = csTHojaRutaItem
          .id = csNew
          
          For Each Cell In Row
            
            Select Case Cell.Key
                              
              Case KI_HRI_ID
                .id = Val(Cell.Value)
                                
              Case KI_COBRADO
                fields.Add2 cscHriCobrado, Cell.Value, csDouble
                                
              Case KI_HRCT_ID
                If (pCell(Row, KI_COBRADO).Value) <> 0 Then
                  fields.Add2 cscHrctId, Cell.id, csId
                ElseIf Cell.id = 4 Or Cell.id = 7 Then
                  fields.Add2 cscHrctId, Cell.id, csId
                Else
                  fields.Add2 cscHrctId, csNO_ID, csId
                End If
                        
              Case KI_HRI_ANULADO
                fields.Add2 cscHriAnulado, Cell.Value, csDouble
              Case KI_HRI_CHEQUES
                fields.Add2 cscHriCheques, Cell.Value, csDouble
              Case KI_HRI_EFECTIVO
                fields.Add2 cscHriEfectivo, Cell.Value, csDouble
              Case KI_HRI_NOTASCREDITO
                fields.Add2 cscHriNotascredito, Cell.Value, csDouble
              Case KI_HRI_RETENCIONES
                fields.Add2 cscHriRetenciones, Cell.Value, csDouble
              Case KI_HRI_TARJETA
                fields.Add2 cscHriTarjeta, Cell.Value, csDouble
              Case KI_HRI_TICKETS
                fields.Add2 cscHriTickets, Cell.Value, csDouble
              Case KI_HRI_OTROS
                fields.Add2 cscHriOtros, Cell.Value, csDouble
                
              Case KI_FV_VTO
                If IsDate(Cell.Value) Then
                  If Cell.Value <> csNoDate Then
                    pUpdateVto Cell.Value, .id
                  End If
                End If
            
            End Select
          Next
          
          fields.Add2 cscEstId, 1, csId 'pendiente
          fields.Add2 cscHrId, id, csId
          
          fields.HaveLastUpdate = False
          fields.HaveWhoModify = False
        
        End With
                                                                      
        If Not gDB.Save(register, , "pSaveItemsCobrado", C_Module, c_ErrorSave) Then Exit Function
        
      End If
    
    End If
    
    Next
  End With
    
  pSaveItemsCobrado = True

End Function

Private Function pSaveItemsTodos(ByVal id As Long) As Boolean
  Dim register  As cRegister
  Dim fields    As cFields
  Dim CompId    As Long
  Dim bIsParte  As Boolean
  Dim sqlstmt   As String
  
  With pGetTodos()
    
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      If pCell(Row, KI_SELECT).id Then
    
        Set register = New cRegister
        
        With register
          
          Set fields = .fields
          .fieldId = cscHriId
          .Table = csTHojaRutaItem
          .id = csNew
          
          For Each Cell In Row
            
            Select Case Cell.Key
                              
              Case KI_ID
              
                CompId = Val(Cell.Value)
                
              Case KI_TIPO
              
                bIsParte = False
              
                Select Case Cell.id
                  Case c_Tipo_Orden
                    fields.Add2 cscOsId, CompId, csId
                  Case c_Tipo_Remito
                    fields.Add2 cscRvId, CompId, csId
                  Case c_Tipo_Factura
                    fields.Add2 cscFvId, CompId, csId
                  Case c_Tipo_Parte
                    bIsParte = True
                    fields.Add2 cscPtdId, CompId, csId
                End Select
                
              Case KI_ACOBRAR
                fields.Add2 cscHriACobrar, Cell.Value, csDouble
                
              Case KI_COBRADO
                fields.Add2 cscHriCobrado, Cell.Value, csDouble
                
              Case KI_ORDEN
                fields.Add2 cscHriOrden, Cell.Value, csInteger
                
              Case KI_DESCRIP
                fields.Add2 cscHriDescrip, Cell.Value, csText
                
              Case KI_CUMPLIDO
                If bIsParte Then
                  sqlstmt = "update ParteDiario set ptd_cumplida = " & IIf(Cell.id, 3, 1) & " where ptd_id = " & CompId
                  If Not gDB.Execute(sqlstmt) Then Exit Function
                End If
                              
            End Select
          Next
          
          fields.Add2 cscEstId, 1, csId 'pendiente
          fields.Add2 cscHrId, id, csId
          
          fields.HaveLastUpdate = False
          fields.HaveWhoModify = False
        
        End With
                                                                      
        If Not gDB.Save(register, , "pSaveItemsTodos", C_Module, c_ErrorSave) Then Exit Function
        
      End If
    Next
  End With
    
  pSaveItemsTodos = True

End Function

Private Sub pSelectTodo(ByRef Row As cIABMGridRow, _
                        ByRef Columns As cIABMGridColumns)
  
  If pCell(Row, KI_TIPO).id = c_Tipo_Factura Then
    With pCell(Row, KI_ACOBRAR)
      If pCell(Row, KI_SELECT).id And pCell(Row, KI_COBRAR).id Then
        If Val(.Value) = 0 Then
          .Value = pCell(Row, KI_PENDIENTE).Value
        End If
      Else
        .Value = 0
      End If
    End With
  End If
End Sub

Private Sub pSelectCobrado(ByRef Row As cIABMGridRow, _
                           ByRef Columns As cIABMGridColumns)
  
  If pCell(Row, KI_TIPO).id = c_Tipo_Factura Then
    
    With pCell(Row, KI_COBRADO)
      
      If pCell(Row, KI_SELECT).id And pCell(Row, KI_COBRAR).id Then
        If Val(.Value) = 0 Then
          .Value = pCell(Row, KI_PENDIENTE).Value
        End If
      Else
        .Value = 0
      End If
    
    End With
  End If
End Sub

Private Sub pSelectFactura(ByRef Row As cIABMGridRow, _
                           ByRef Columns As cIABMGridColumns)
  
  With pCell(Row, KI_ACOBRAR)
    If pCell(Row, KI_SELECT).id And pCell(Row, KI_COBRAR).id Then
      If Val(.Value) = 0 Then
        .Value = pCell(Row, KI_PENDIENTE).Value
      End If
    Else
      .Value = 0
    End If
  End With
End Sub

Private Sub pShowTotal()
  Dim Row           As cIABMGridRow
  Dim oRow          As cABMGridRow
  Dim TotalFv       As Double
  Dim TotalRv       As Double
  Dim TotalOs       As Double
  Dim Cobrar        As Double
  
  For Each Row In pGetTodos().Grid.Rows

    Set oRow = Row
    If Not oRow.IsGroup Then

      If pCell(Row, KI_SELECT).id Then
      
        Select Case pCell(Row, KI_TIPO).id
      
          Case c_Tipo_Orden
            TotalOs = TotalOs + Val(pCell(Row, KI_IMPORTE).Value)
            
          Case c_Tipo_Remito
            TotalRv = TotalRv + Val(pCell(Row, KI_IMPORTE).Value)
            
          Case c_Tipo_Factura
            TotalFv = TotalFv + Val(pCell(Row, KI_IMPORTE).Value)
            If pCell(Row, KI_COBRAR).id Then
              Cobrar = Cobrar + Val(pCell(Row, KI_ACOBRAR).Value)
            End If
        End Select
      End If
    End If
  Next
  
  pGetTotal().Value = TotalRv + TotalFv + TotalOs
  
  pGetTotalFvT2().Value = TotalFv
  pGetTotalFvCobrarT2().Value = Cobrar
  pGetTotalRvT2().Value = TotalRv
  pGetTotalOsT2().Value = TotalOs
  
  pGetTotalT().Value = TotalRv + TotalFv + TotalOs
  
  pGetTotalFvT().Value = TotalFv
  pGetTotalFvCobrarT().Value = Cobrar
  pGetTotalRvT().Value = TotalRv
  pGetTotalOsT().Value = TotalOs
    
  m_ObjAbm.ShowValue pGetTotal()

  m_ObjAbm.ShowValue pGetTotalOsT()
  m_ObjAbm.ShowValue pGetTotalRvT()
  m_ObjAbm.ShowValue pGetTotalFvT()
  m_ObjAbm.ShowValue pGetTotalFvCobrarT()

  m_ObjAbm.ShowValue pGetTotalOsT2()
  m_ObjAbm.ShowValue pGetTotalRvT2()
  m_ObjAbm.ShowValue pGetTotalFvT2()
  m_ObjAbm.ShowValue pGetTotalFvCobrarT2()
End Sub

Private Sub pShowTotalCobrado()
  Dim Row           As cIABMGridRow
  Dim oRow          As cABMGridRow
  Dim Cobrado       As Double
  
  For Each Row In pGetCobrado().Grid.Rows

    Set oRow = Row
    If Not oRow.IsGroup Then

      If pCell(Row, KI_SELECT).id Then
      
        Select Case pCell(Row, KI_TIPO).id
                  
          Case c_Tipo_Factura
            If pCell(Row, KI_COBRAR).id Then
              Cobrado = Cobrado _
                        + Val(pCell(Row, KI_COBRADO).Value) _
                        - Val(pCell(Row, KI_HRI_ANULADO).Value) _
                        - Val(pCell(Row, KI_HRI_NOTASCREDITO).Value)
            End If
        End Select
      End If
    End If
  Next
  
  Dim TotalValores As Double
  
  TotalValores = Val(pGetRecibidoCheque().Value) + Val(pGetRecibidoEfectivo().Value)
  
  pGetRecibidoCobrado().Value = Cobrado
  pGetRecibidoDif().Value = TotalValores - Cobrado
    
  m_ObjAbm.ShowValue pGetRecibidoCobrado()
  m_ObjAbm.ShowValue pGetRecibidoDif()

End Sub

Private Function pGetTodos() As cIABMProperty
  Set pGetTodos = m_ObjAbm.Properties.Item(c_Todos)
End Function

Private Function pGetCobrado() As cIABMProperty
  Set pGetCobrado = m_ObjAbm.Properties.Item(c_cobrado)
End Function

Private Function pGetTotal() As cIABMProperty
  Set pGetTotal = m_ObjAbm.Properties.Item(cscHrTotal)
End Function

Private Function pGetTotalT() As cIABMProperty
  Set pGetTotalT = m_ObjAbm.Properties.Item(c_total_TODOS)
End Function

Private Function pGetTotalFvT() As cIABMProperty
  Set pGetTotalFvT = m_ObjAbm.Properties.Item(c_t_total_fv)
End Function

Private Function pGetTotalFvCobrarT() As cIABMProperty
  Set pGetTotalFvCobrarT = m_ObjAbm.Properties.Item(c_t_total_fv_cobrar)
End Function

Private Function pGetTotalRvT() As cIABMProperty
  Set pGetTotalRvT = m_ObjAbm.Properties.Item(c_t_total_rv)
End Function

Private Function pGetTotalOsT() As cIABMProperty
  Set pGetTotalOsT = m_ObjAbm.Properties.Item(c_t_total_os)
End Function

Private Function pGetTotalFvT2() As cIABMProperty
  Set pGetTotalFvT2 = m_ObjAbm.Properties.Item(c_t_total_fv2)
End Function

Private Function pGetTotalFvCobrarT2() As cIABMProperty
  Set pGetTotalFvCobrarT2 = m_ObjAbm.Properties.Item(c_t_total_fv_cobrar2)
End Function

Private Function pGetTotalRvT2() As cIABMProperty
  Set pGetTotalRvT2 = m_ObjAbm.Properties.Item(c_t_total_rv2)
End Function

Private Function pGetTotalOsT2() As cIABMProperty
  Set pGetTotalOsT2 = m_ObjAbm.Properties.Item(c_t_total_os2)
End Function

Private Function pGetRecibidoCheque() As cIABMProperty
  Set pGetRecibidoCheque = m_ObjAbm.Properties.Item(cscHrRecibidoCheque)
End Function

Private Function pGetRecibidoCantCheque() As cIABMProperty
  Set pGetRecibidoCantCheque = m_ObjAbm.Properties.Item(cscHrRecibidoCantCheque)
End Function

Private Function pGetRecibidoEfectivo() As cIABMProperty
  Set pGetRecibidoEfectivo = m_ObjAbm.Properties.Item(cscHrRecibidoEfectivo)
End Function

Private Function pGetRecibidoTotal() As cIABMProperty
  Set pGetRecibidoTotal = m_ObjAbm.Properties.Item(c_TotalRecibido)
End Function

Private Function pGetRecibidoCobrado() As cIABMProperty
  Set pGetRecibidoCobrado = m_ObjAbm.Properties.Item(c_CobradoT)
End Function

Private Function pGetRecibidoDif() As cIABMProperty
  Set pGetRecibidoDif = m_ObjAbm.Properties.Item(c_CobradoDif)
End Function

Private Function pSaveChanges(Optional ByVal Msg As String) As Boolean
  Dim rslt As VbMsgBoxResult
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  If AbmObj.bWasChanged Then
  
    If LenB(Msg) = 0 Then
      Msg = LNGGetText(4897, vbNullString) '"Ud. ha realizado cambios que no ha guardado." & vbCrLf & vbCrLf & "¿Desea guardarlos?"
    End If
    
    rslt = MsgBox(Msg, vbQuestion + vbYesNoCancel, "Guardar")
    
    If rslt = vbCancel Then Exit Function
    
    If rslt = vbYes Then
      
      If Not AbmObj.Save() Then
        Exit Function
      End If
    
    Else
      
      AbmObj.ResetChanged
      
    End If
  
  End If
  
  pSaveChanges = True

End Function

'---------------------------------------------------------------
Private Sub pRefreshProperties()
  Dim c      As cIABMProperty
  Dim AbmGen As cABMGeneric
  Dim Filter As String

  m_binRefresh = False

  With m_ObjAbm
    
    .Title2 = m_Nrodoc & " - " & m_persona
    
    With .Properties
  
'-------------------------------------------------------------------
      With .Item(cscHrFecha)
        .Value = m_Fecha
      End With
      
      With .Item(cscHrFechaentrega)
        .Value = m_Fechaentrega
      End With
      
      With .Item(cscHrNumero)
        .Value = m_Numero
      End With
      
      With .Item(cscHrNrodoc)
        .Value = m_Nrodoc
      End With
      
      With .Item(cscSucId)
        .Value = m_Sucursal
        .HelpId = m_suc_id
      End With
      
      With .Item(cscPrsId)
        .Value = m_persona
        .HelpId = m_prs_id
      End With
      
      With .Item(cscChofId)
        .Value = m_Chofer
        .HelpId = m_chof_id
      End With
      
      With .Item(cscCamId)
        .Value = m_Camion
        .HelpId = m_cam_id
      End With
      
      With .Item(cscCamIdSemi)
        .Value = m_Semi
        .HelpId = m_cam_id_semi
      End With
      
      With .Item(cscHrDescrip)
        .Value = m_Descrip
      End With
      
      With .Item(cscHrTotal)
        .Value = m_Total
      End With
                                  
    '/////////////////////////////////////////////////////////////////////
    '
    ' TODOS
    '
    '
    '/////////////////////////////////////////////////////////////////////
    
      With .Item(c_T_FECHA_DESDE)
        .Value = m_FechaDesde
      End With
  
      With .Item(c_T_FECHA_HASTA)
        .Value = m_FechaHasta
      End With
    
      With .Item(c_persona)
        .Value = m_persona
        .HelpId = m_prs_id
      End With
                  
      Set c = .Item(c_Todos)
      pLoadTodos c, False
    
      With .Item(cscHrRecibidoEfectivo)
        .Value = m_RecibidoEfectivo
      End With
    
      With .Item(cscHrRecibidoCheque)
        .Value = m_RecibidoCheque
      End With
  
      With .Item(c_TotalRecibido)
        .Value = m_RecibidoTotal
      End With
  
      With .Item(cscHrRecibidoCantCheque)
        .Value = m_RecibidoCantCheque
      End With
  
      With .Item(cscHrRecibidoDescrip)
        .Value = m_RecibidoDescrip
      End With
    
      With .Item(c_T_CLI_ID)
        .HelpId = Val(m_ram_id_cliente)
        .HelpValueProcess = m_ram_id_cliente
        .Value = m_RamaCliente
      End With
    
      With .Item(c_T_ESTADO)
        .HelpId = Val(m_ram_id_estado)
        .HelpValueProcess = m_ram_id_estado
        .Value = m_RamaEstado
      End With
    
      Set c = .Item(c_cobrado)
      pLoadCobrado c, False

'-------------------------------------------------------------------
    End With
  End With
  
  Set AbmGen = m_ObjAbm
  
  AbmGen.ShowValues m_ObjAbm.Properties
  
  AbmGen.GroupGridEx pGetTodos(), _
                     c_key_col_cliente, _
                     c_key_col_fecha, _
                     4
    
  AbmGen.GroupGridEx pGetCobrado(), _
                     c_key_col_cliente, _
                     c_key_col_fecha, _
                     4
      
  pShowTotal
  pShowTotalCobrado
  
End Sub

Private Sub pShowCobranza()
  On Error GoTo ControlError

  Dim o As Object

  Set o = CSKernelClient2.CreateObject("CSTesoreria2.cCobranza")
  
  Dim CliIds() As Long
  
  CliIds = pGetCliIds()
  
  o.PushVirtualNext = True
  o.CloseWizardAfterSave = True
  
  Dim CobranzaInfo As cCobranzaInfo
  
  If Not pGetFvIds(CliIds, CobranzaInfo) Then
  
    Exit Sub
  End If
  
  o.ShowCobranzaEx2 CliIds, CobranzaInfo
  
  If o.WizardCompleteSuccess Then
  
    MsgInfo LNGGetText(4922, vbNullString) ' Las cobranzas se generaron con éxito
  
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "pShowCobranza", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetCliIds() As Long()
  Dim rtn()   As Long
  Dim i       As Long
  Dim j       As Long
  Dim Rows    As cIABMGridRows
  Dim Row     As cIABMGridRow
  Dim oRow    As cABMGridRow
  
  Dim cli_id  As Long
  
  ReDim rtn(0)
  Set Rows = pGetCobrado.Grid.Rows
  
  For i = 1 To Rows.count
    Set Row = Rows.Item(i)
    Set oRow = Row
    
    If Not oRow.IsGroup Then
    
      If Val(pCell(Row, KI_COBRADO).Value) > 0 And Val(pCell(Row, KI_PENDIENTE).Value) > 0 Then
      
        cli_id = pCell(Row, KI_CLIENTE).id
        
        For j = 1 To UBound(rtn)
          If rtn(j) = cli_id Then
            cli_id = 0
            Exit For
          End If
        Next
      
        If cli_id <> 0 Then
          j = UBound(rtn) + 1
          ReDim Preserve rtn(j)
          rtn(j) = cli_id
        End If
      End If
    End If
  Next
  
  pGetCliIds = rtn
End Function

Private Function pGetFvIds(ByRef vCliIds() As Long, ByRef CobranzaInfo As cCobranzaInfo) As Boolean
  Dim k       As Long
  Dim i       As Long
  Dim j       As Long
  Dim rtn     As cCobranzaInfo
  Dim FvInfo  As cCobranzaInfoFactura
  Dim Rows    As cIABMGridRows
  Dim Row     As cIABMGridRow
  Dim oRow    As cABMGridRow
  Dim Cobrado As Double
  Dim Cuenta  As String
  Dim FormaPago As csE_HojaRutaCobranzaTipo
  
  Set rtn = New cCobranzaInfo
  
  rtn.CueIdEfectivo = GetCueIdEfectivoFromUserHR(User.id, EmpId, Cuenta)
  rtn.CuentaEfectivo = Cuenta
  
  rtn.CueIdTicket = GetCueIdTicketFromUserHR(User.id, EmpId, Cuenta)
  rtn.CuentaTicket = Cuenta
  
  If rtn.CueIdEfectivo = csNO_ID Or rtn.CueIdTicket = csNO_ID Then
    MsgWarning LNGGetText(4921, vbNullString) ' Debe indicar una cuenta para efectivo y una para tickets en la caja asociada al usuario
    Exit Function
  End If
  
  Set Rows = pGetCobrado.Grid.Rows
  
  For k = 1 To UBound(vCliIds)
  
    For i = 1 To Rows.count
      Set Row = Rows.Item(i)
      Set oRow = Row
      
      If Not oRow.IsGroup Then
      
        Cobrado = Val(pCell(Row, KI_COBRADO).Value)
        FormaPago = pCell(Row, KI_HRCT_ID).id
        
        If Cobrado > 0 _
           And Val(pCell(Row, KI_PENDIENTE).Value) > 0 _
           And FormaPago <> csHRCT_Anulada _
           And FormaPago <> csHRCT_AnuladaInterna Then
        
          If pCell(Row, KI_CLIENTE).id = vCliIds(k) Then
          
            Set FvInfo = New cCobranzaInfoFactura
            
            With FvInfo
            
              .CliId = vCliIds(k)
              .FvId = Val(pCell(Row, KI_ID).Value)
              .FormaDePago = FormaPago
              
              Select Case .FormaDePago
                Case csHRCT_Efectivo, csHRCT_PagoParcial
                  .ImporteCobrado = Val(pCell(Row, KI_HRI_EFECTIVO).Value)
                Case csHRCT_Cheque
                  .ImporteCobrado = Val(pCell(Row, KI_HRI_CHEQUES).Value)
                Case csHRCT_Tickets
                  .ImporteCobrado = Val(pCell(Row, KI_HRI_TICKETS).Value)
              End Select
              
            End With
            
            rtn.Facturas.Add FvInfo
                    
          End If
        End If
      End If
    Next
  Next
  
  Set CobranzaInfo = rtn
  
  pGetFvIds = True
End Function

Private Sub pEditParteDiario(ByVal ptd_id As Long)
  Dim Parte   As Object
  Dim iParte  As cIEditGeneric
  
  Set Parte = CSKernelClient2.CreateObject("CSEnvio2.cParteDiario")
  Set iParte = Parte
  
  Set iParte.ObjAbm = CSKernelClient2.CreateObject("CSABMInterface2.cABMGeneric")
  iParte.Edit ptd_id, False

End Sub

Private Function pGetCMDSelectAll() As cIABMProperty
  Set pGetCMDSelectAll = m_ObjAbm.Properties.Item(c_cmd_selectAll)
End Function

Private Sub pSelectAll(ByVal bSelect As Boolean)
  Dim Row   As cIABMGridRow
  Dim oRow  As cABMGridRow
  Dim oCol  As cABMGridColumn
  Dim iRow  As Long
  Dim iCol  As Long
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  Set oCol = pGetTodos().Grid.Columns.Item(c_select_key)
  iCol = oCol.Index + 2
  
  For Each Row In pGetTodos().Grid.Rows
  
    Set oRow = Row
    
    iRow = iRow + 1
    
    If Not oRow.IsGroup Then
  
      pCell(Row, KI_SELECT).id = CInt(bSelect)
  
      AbmObj.ShowCellValue pGetTodos(), _
                           iRow, _
                           iCol
  
    End If
  Next
  
End Sub

Private Sub pShowDocAux(ByVal doc_aux_id As Long, _
                        ByVal ObjEditName As String, _
                        ByVal ObjAbmName As String)
  On Error GoTo ControlError
  
  Dim o   As cIEditGeneric
  Dim fv  As cFacturaVenta
  
  Set o = CSKernelClient2.CreateObject(ObjEditName)
  Set o.ObjTree = Nothing
  
  Dim Editor As cIABMGeneric
  Set Editor = CSKernelClient2.CreateObject(ObjAbmName)
  Set o.ObjAbm = Editor

  Set fv = o
  Set fv.HojaRuta = Me
  
  pSetGenericDoc o, ObjAbmName
  
  o.Edit doc_aux_id

  GoTo ExitProc
ControlError:
  MngError Err, "pShowDocAux", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pSetGenericDoc(ByRef o As Object, _
                           ByVal ObjAbmName As String)
  Dim oDoc As cIEditGenericDoc
  If TypeOf o Is cIEditGenericDoc Then
    Set oDoc = o
    Set oDoc.Footer = CSKernelClient2.CreateObject(ObjAbmName)
    Set oDoc.Items = CSKernelClient2.CreateObject(ObjAbmName)
  End If
End Sub

Private Function pSaveFaltante() As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_HojaRutaSaveFaltante " & _
                   EmpId & "," & _
                   User.id & "," & _
                   m_Id & "," & _
                   gDB.sqlNumber(pGetSobrante().Value) & "," & _
                   gDB.sqlNumber(pGetFaltante().Value)
                   
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  If rs.fields.Item(0).Value = 0 Then
  
    MsgWarning rs.fields.Item(1).Value
  
  Else
  
    m_fv_id_faltante = gDB.ValField(rs.fields, 2)
    m_MovFaltante = gDB.ValField(rs.fields, 3)
  
    m_mf_id_sobrante = gDB.ValField(rs.fields, 4)
    
    If m_fv_id_faltante = csNO_ID Then
      m_MovFaltante = gDB.ValField(rs.fields, 5)
    End If
    
    Dim iProp As cIABMProperty
    Set iProp = pGetMovFaltante()
    iProp.Value = m_MovFaltante
    m_ObjAbm.ShowValue iProp
  
  End If
  
  pSaveFaltante = True
End Function

Private Function pSaveTickets() As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_HojaRutaSaveTickets " & _
                   EmpId & "," & _
                   User.id & "," & _
                   m_Id & "," & _
                   gDB.sqlNumber(pGetTickets().Value)
                   
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  If rs.fields.Item(0).Value = 0 Then
  
    MsgWarning rs.fields.Item(1).Value
    
  Else
  
    m_mf_id_tickets = gDB.ValField(rs.fields, 2)
    m_MovTickets = gDB.ValField(rs.fields, 3)
  
    Dim iProp As cIABMProperty
    Set iProp = pGetMovTickets()
    iProp.Value = m_MovTickets
    m_ObjAbm.ShowValue iProp
  
  End If
  
  pSaveTickets = True
End Function

Private Function pGetSobrante() As cIABMProperty
  Set pGetSobrante = m_ObjAbm.Properties.Item(cscHrSobrante)
End Function

Private Function pGetFaltante() As cIABMProperty
  Set pGetFaltante = m_ObjAbm.Properties.Item(cscHrFaltante)
End Function

Private Function pGetTickets() As cIABMProperty
  Set pGetTickets = m_ObjAbm.Properties.Item(cscHrPorcTickets)
End Function

Private Function pGetMovFaltante() As cIABMProperty
  Set pGetMovFaltante = m_ObjAbm.Properties.Item(c_FaltanteComp)
End Function

Private Function pGetMovTickets() As cIABMProperty
  Set pGetMovTickets = m_ObjAbm.Properties.Item(c_TicketComp)
End Function

Private Sub pUpdateVto(ByVal Vto As Date, ByVal hri_id As Long)
  Dim sqlstmt As String
  sqlstmt = "update FacturaVenta set fv_fechavto = " & gDB.sqlDate(Vto) & _
            " where fv_id in " & _
            "(select fv_id from HojaRutaItem where hri_id =" & _
                hri_id & ")"
  gDB.Execute sqlstmt
End Sub
