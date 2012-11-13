VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cEquipo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cEquipo
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
Private Const C_Module = "cEquipo"

Private Const c_callcenterPtd = "c_callcenterPtd"
Private Const c_adminPtd = "c_adminPtd"

Private Const K_CODIGO          As Integer = 2
Private Const K_FECHAVTO        As Integer = 5
Private Const K_DESCRIP         As Integer = 6
Private Const K_CODIGO2         As Integer = 10
Private Const K_CODIGO3         As Integer = 11

Private Const K_SEARCH          As Integer = 500

Private Const K_VIEW_OS                As Integer = 1000
Private Const K_VIEW_PRP               As Integer = 1001
Private Const K_VIEW_PTD_LABORATORIO   As Integer = 1002
Private Const K_VIEW_PTD_CALLCENTER    As Integer = 1003
Private Const K_VIEW_PTD_ADMIN         As Integer = 1004
Private Const K_VIEW_PTD_ALL           As Integer = 1005

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Codigo                       As String   '"Serie:"
Private m_Codigo2                      As String
Private m_Codigo3                      As String   '"| F11:"
Private m_Descrip                      As String
Private m_FechaVto                     As Date

Private m_producto                     As String

Private m_OsNroDoc                     As String   '"Orden de Servicio:"
Private m_os_id                        As Long
Private m_contacto                     As String   '"| Cliente:"
Private m_ContTel                      As String   '"| Tel:"
Private m_ContCel                      As String   '"| Cel:"
Private m_ContCiudad                   As String   '"| Ciudad:"
Private m_Falla                        As String   '"Falla:"
Private m_Ingreso                      As Date     '"| Fecha Ingreso:"
Private m_Codigo4                      As String   '"Serie Bateria:"
Private m_Proveedor                    As String   '"| Tercero:"
Private m_StProvNroDoc                 As String   '"OT:"
Private m_PartesDiariosLB              As String   '"Trabajos Realizados:"
Private m_PrpDescrip                   As String   '"Proceso a Seguir:"
Private m_prp_id                       As Long
Private m_TarNombre                    As String   '"Estado:"
Private m_DeplNombre                   As String   '"| Deposito:"
Private m_UsNombre                     As String   '"| Técnico:"
Private m_PrpEstado                    As String   '"| Presupuesto:"
Private m_RvRetiro                     As String   '"Retirado Por:"
Private m_Transporte                   As String   '"| Transporte:"
Private m_RvGuia                       As String   '"| Guia:"
Private m_PartesDiariosCC              As String   '"Comentarios:"
Private m_PartesDiariosADM             As String   '"Comentarios:"

Private m_Editing                      As Boolean

Private m_ObjAbm                       As cIABMGeneric
Private m_ObjTree                      As Object

Private m_BranchId                     As Long
Private m_TreeId                       As Long

Private m_TicketConfig      As cTicketConfig

Private m_Host              As CSMenu.cIMenuHost

' Properties publicas

Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Codigo
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property

' Properties privadas
' funciones publicas
' Implementacion de cIABMClient
Private Property Get cIABMClient_Aplication() As String
    cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
  cIABMClient_CanAddDocDigital = m_Id <> csNO_ID
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
  cIABMClient_CanCopy = False
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = False
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
  On Error GoTo ControlError
  
  If m_Id = csNO_ID Then Exit Function
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = csTProductoNumeroSerie
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, C_ShowDocDigital, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
    
  Select Case MessageID
    
    Case MSG_DOC_SEARCH                     ' En info cABMInteface nos
                                            ' indica si hay cambios sin
                                            ' guardar
      DocumentSearch csProductoSerie * -1, Me, Not CBool(Info)
      
    Case Else
    
      cIABMClient_MessageEx = True

  End Select
End Function

Private Function cIABMClient_Copy() As Boolean
  cIABMClient_Copy = False
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_EditNew() As Boolean
  cIABMClient_EditNew = False
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal key As Integer) As Boolean
  
  Select Case key
    
    Case K_VIEW_OS
      
      If m_os_id Then
        pEditDoc "CSTicket.cOrdenServicio", m_os_id
      Else
        MsgInfo LNGGetText(3063, vbNullString) '"Este equipo no tiene asociada una orden de servicio"
        Exit Function
      End If
    
    Case K_VIEW_PRP
      
      If m_prp_id Then
        pEditDoc "CSTicket.cParteReparacion", m_prp_id
      Else
        MsgInfo LNGGetText(3064, vbNullString) '"Este equipo no tiene asociado un parte de reparación"
        Exit Function
      End If
    
    Case K_VIEW_PTD_ADMIN
      pShowPartes csE_DepartamentoTipo.csEDPTOT_Administracion
    Case K_VIEW_PTD_CALLCENTER
      pShowPartes csE_DepartamentoTipo.csEDPTOT_CallCenter
    Case K_VIEW_PTD_LABORATORIO
      pShowPartes csE_DepartamentoTipo.csEDPTOT_Laboratorio
    Case K_VIEW_PTD_ALL
      pShowPartes csE_DepartamentoTipo.csEDPTOT_Todos
      
    Case K_SEARCH
    
      cIABMClient_MessageEx MSG_DOC_SEARCH, False
  End Select

End Function

Private Sub pEditDoc(ByVal ObjEditName As String, _
                     ByVal Id As Long)

  ShowDocAux Id, _
             ObjEditName, _
             "CSABMInterface2.cABMGeneric"
End Sub

Private Sub pShowPartes(ByVal What As csE_DepartamentoTipo)

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_ParteDiarioGetTitleForDoc " & csProductoSerie & "," & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Dim infodoc As String
  Dim DoctId  As Long
  
  DoctId = csProductoSerie
  infodoc = gDB.ValField(rs.Fields, "info_doc")
  
  sqlstmt = "sp_PartesDiarioGetForDoc " & gDB.UserId & "," & EmpId & "," & _
                      DoctId & "," & _
                      m_Id & "," & _
                      What
                      
  ShowNotes LNGGetText(1615, vbNullString, infodoc), sqlstmt
            'Notas sobre Equipos (1)

End Sub

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    MsgWarning LNGGetText(1797, vbNullString)
          'Los equipos se deben ingresar al sistema a travez de Ordenes de Servicio ó Remitos de Compra.
    Exit Function
  Else
    If Not SecurityCanAccess(csPreGEditProductoNroSerie) Then Exit Function
  End If

  m_ObjAbm.InModalWindow = InModalWindow

  If Not Load(Id) Then Exit Function
  
  If m_ObjAbm.Properties.Count = 0 Then
    If Not LoadCollection() Then Exit Function
  Else
    pRefreshProperties
  End If
  
  m_Editing = True

  If InModalWindow Then
    cIEditGeneric_Edit = m_Id <> csNO_ID
  Else
    cIEditGeneric_Edit = True
  End If

  Exit Function
ControlError:
  MngError Err, C_EditGenericEdit, C_Module, vbNullString
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Dim Fields   As cFields
  
  Dim bMergeSeries    As Boolean
  Dim prns_id_merge   As Long
  
  If m_TicketConfig.UseAutoNumber Then
    If Not pValidateCodigo(bMergeSeries, prns_id_merge) Then
      Exit Function
    End If
  End If
  
  Set register = New cRegister
  
  With register
    Set Fields = .Fields
    .fieldId = cscPrnsId
    .table = csTProductoNumeroSerie
    .Id = m_Id
  End With
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .key
        Case K_CODIGO
          '
          ' Si voy a unir los numeros de serie, no modifico
          ' el codigo justamente para que no me de un error
          '
          If Not bMergeSeries Then
            Fields.Add2 cscPrnsCodigo, .Value, csText
          End If
        Case K_CODIGO2
          Fields.Add2 cscPrnsCodigo2, .Value, csText
        Case K_CODIGO3
          Fields.Add2 cscPrnsCodigo3, .Value, csText
        Case K_DESCRIP
          Fields.Add2 cscPrnsDescrip, .Value, csText
        Case K_FECHAVTO
          Fields.Add2 cscPrnsFechavto, .Value, csDate
      End Select
    End With
  Next
  
  Fields.HaveLastUpdate = True
  Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
                                                                                                                    
  If Not gDB.Save(register, , C_ABMClientSave, C_Module, c_ErrorSave) Then Exit Function
  
  If bMergeSeries Then
  
    ' Al unir los codigos, se elimina el prns_id indicado en m_id
    ' y se pasan todos los movimientos al prns_id indicado en prns_id_merge
    '
    Dim sqlstmt As String
    Dim rs      As ADODB.Recordset
    
    sqlstmt = "sp_ProductoNumeroSerieMerge " & m_Id & "," & prns_id_merge
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    
    register.Id = gDB.ValField(rs.Fields, cscPrnsId)
  End If
  
  If Not register.CommitTrans() Then Exit Function
  
  cIABMClient_Save = Load(register.Id)
End Function

Private Function pValidateCodigo(ByRef bMergeSeries As Boolean, _
                                 ByRef prns_id_merge As Long) As Boolean
  
  prns_id_merge = csNO_ID
  bMergeSeries = False
  
  Dim Codigo As String
  Codigo = m_ObjAbm.Properties.Item(cscPrnsCodigo & "aux").Value
  
  Dim PrId As Long
  If Not gDB.GetData(csTProductoNumeroSerie, cscPrnsId, m_Id, cscPrId, PrId) Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select prns_id from ProductoNumeroSerie where prns_codigo = " & gDB.sqlString(Codigo) & " and pr_id = " & PrId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then
  
    pValidateCodigo = True
  Else
  
    Dim prns_id As Long
    prns_id = gDB.ValField(rs.Fields, cscPrnsId)
    
    If prns_id <> m_Id Then
    
      sqlstmt = "sp_productoNumeroSerieGetDetalle " & prns_id
      If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    
      Dim Datos As String
      
      Datos = gDB.ValField(rs.Fields, "detalle")
    
      ' Este código de número de serie ya esta utilizado por otro número de serie
      ' cuyos datos son  %1
      ' ¿Desea unificar estos números de serie?
      '
      ' Si contesta SI, el sistema actualizara todos los movimientos
      ' para que apunten a al mismo número de serie.
      '
      ' Si contesta NO, debera modificar el codigo de este número de serie.
      '
      If Ask(LNGGetText(3595, vbNullString, Datos), vbNo) Then
        pValidateCodigo = True
        prns_id_merge = prns_id
        bMergeSeries = True
      End If
    End If
  End If
End Function

Private Function cIABMClient_Terminate() As Boolean
    m_Editing = False
    cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = LNGGetText(1801, vbNullString)    'Equipo
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .key
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            MsgInfo C_DebeIndicarCodigo
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

' Implementacion de cIEditGeneric

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal rhs As Long)
    m_TreeId = rhs
End Property

Private Property Get cIEditGeneric_TreeId() As Long
    cIEditGeneric_TreeId = m_TreeId
End Property

Private Function cIEditGeneric_GridAdd(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
  cIEditGeneric_ShowList = SecurityCanAccess(csPreTickListEquipos)
End Function

Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    cIEditGeneric_Delete = False
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

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
  
  Dim str_1755    As String
  Dim str_1800    As String
  
  str_1755 = LNGGetText(1755, vbNullString)   'Se&rvicios
  str_1800 = LNGGetText(1800, vbNullString)   '&Equipos
  
  Set m_Host = Host
  
  #If Not PREPROC_NO_MENU_ICON Then
    Dim lIconIndex As Long
    lIconIndex = m_Host.AddIcon(LoadResPicture(102, LoadResConstants.vbResIcon))
    m_Host.Server.AddMenu str_1755, csMenuProyecto, vbNullString, 1, False, False, False, True, False, Nothing
    m_Host.Server.AddMenu str_1800, csPreTickListEquipos, str_1755, 0, True, False, False, False, False, Me, lIconIndex
  
  #Else
    m_Host.Server.AddMenu str_1755, csMenuProyecto, vbNullString, 1, False, False, False, True, False, Nothing
    m_Host.Server.AddMenu str_1800, csPreTickListEquipos, str_1755, 0, True, False, False, False, False, Me
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
  m_Host.MenuListDocClick "CSABMInterface2.cABMGeneric", "CSTicket.cEquipo", "CSABMInterface2.cABMGenericListDoc", "CSTicket.cEquipoListDoc", Me, LNGGetText(1801, vbNullString), 0
                                                                                                                                                    'Equipo
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  Const tab_equipo = 0
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 9500
  AbmObj.MinWidth = 13500
  
  With m_ObjAbm
  
    .Title2 = m_producto & " - NS:" & m_Codigo
    
    With .Tabs

      .Clear

      With .Add(Nothing)
        .Name = C_strGeneral
      End With

      With .Add(Nothing)
        .Index = 1
        .Name = LNGGetText(1801, vbNullString) 'Equipo
      End With

    End With
    
    With .Properties
      
      .Clear
      
    '----------------------------------------------------
    ' Datos del Cliente
    '
      pAddTitle .Add(Nothing), _
                .Add(Nothing), _
                LNGGetText(2830, vbNullString) '"Datos del Cliente"
                
      pAddField .Add(Nothing, cscOsId), _
                .Add(Nothing, cscOsNrodoc), _
                vbNullString, _
                cscOsId, _
                LNGGetText(2831, vbNullString), _
                m_OsNroDoc, _
                1500, 1050, 0, 2550
                '"Orden de Servicio:"
      
      pAddField .Add(Nothing, cscContId), _
                .Add(Nothing, cscContNombre), _
                cscOsId, _
                cscContId, _
                LNGGetText(2832, vbNullString), _
                m_contacto, _
                900, 2500, 2800, 1900
                '"| Cliente:"
                
      Const c_cont_tel = "c_cont_tel"
      
      pAddField .Add(Nothing, c_cont_tel), _
                .Add(Nothing, cscContTel), _
                cscOsId, _
                c_cont_tel, _
                LNGGetText(2833, vbNullString), _
                m_ContTel, _
                600, 1500, 6000, 1600
                '"| Tel:"
                
      Const c_cont_cel = "c_cont_cel"
      
      pAddField .Add(Nothing, c_cont_cel), _
                .Add(Nothing, cscContCelular), _
                cscOsId, _
                c_cont_cel, _
                LNGGetText(2834, vbNullString), _
                m_ContCel, _
                600, 1500, 7900, 1600
                '"| Cel:"
                
      pAddField .Add(Nothing, cscCiuId), _
                .Add(Nothing, cscCiuNombre), _
                cscOsId, _
                cscCiuId, _
                LNGGetText(2835, vbNullString), _
                m_ContCiudad, _
                1000, 2200, 9600, 1900
                '"| Ciudad:"
      
      pAddField .Add(Nothing, cscEtfId), _
                .Add(Nothing, cscEtfNombre), _
                vbNullString, _
                cscEtfId, _
                LNGGetText(2836, vbNullString), _
                m_Falla, _
                1500, 9000, 280, 1650
                '"Falla:"
    
      Const c_os_fecha = "c_os_fecha"
      
      pAddField .Add(Nothing, c_os_fecha), _
                .Add(Nothing, cscOsFecha), _
                cscEtfId, _
                c_os_fecha, _
                LNGGetText(2837, vbNullString), _
                m_Ingreso, _
                2000, 2200, 9600, 2400
                '"| Fecha Ingreso:"
    
    '----------------------------------------------------
    ' Detalle del Equipo
    '
      pAddTitle .Add(Nothing), _
                .Add(Nothing), _
                LNGGetText(2838, vbNullString) '"Detalle del Equipo"
      
      pAddField .Add(Nothing, cscPrnsId), _
                .Add(Nothing, cscPrnsCodigo), _
                vbNullString, _
                cscPrnsId, _
                LNGGetText(2839, vbNullString), _
                m_Codigo, _
                600, 2500, 280, 1700
                '"Serie:"
      
      Const c_serie5 = "c_serie5"
      
      pAddField .Add(Nothing, c_serie5), _
                .Add(Nothing, cscPrnsCodigo5), _
                cscPrnsId, _
                c_serie5, _
                LNGGetText(2840, vbNullString), _
                m_Codigo4, _
                1200, 1500, 3000, 2200
                '"Serie Bateria:"
      
      Const c_serie3 = "c_serie3"
      
      pAddField .Add(Nothing, c_serie3), _
                .Add(Nothing, cscPrnsCodigo3), _
                cscPrnsId, _
                c_serie3, _
                LNGGetText(2841, vbNullString), _
                m_Codigo3, _
                600, 1500, 5300, 1600
                '"| F11:"
      
      pAddField .Add(Nothing, cscProvId), _
                .Add(Nothing, cscProvNombre), _
                cscPrnsId, _
                cscProvId, _
                LNGGetText(2842, vbNullString), _
                m_Proveedor, _
                1000, 1500, 7500, 1950
                '"| Tercero:"
      
      Const c_serie4 = "c_serie4"
      
      pAddField .Add(Nothing, c_serie4), _
                .Add(Nothing, cscPrnsCodigo4), _
                cscPrnsId, _
                c_serie4, _
                LNGGetText(2843, vbNullString), _
                m_StProvNroDoc, _
                500, 2200, 9900, 1550
                '"OT:"
    
    '----------------------------------------------------
    ' Parte del Laboratorio
    '
      pAddTitle .Add(Nothing), _
                .Add(Nothing), _
                LNGGetText(2844, vbNullString) '"Parte del Laboratorio"
      
      Const c_descrip = "c_descrip"
      
      pAddField .Add(Nothing, c_descrip), _
                .Add(Nothing, cscPrnsDescrip), _
                vbNullString, _
                c_descrip, _
                LNGGetText(2845, vbNullString), _
                m_PartesDiariosLB, _
                2100, 10420, 0, 2800, 700, cspText, cspMemo, True
                '"Trabajos Realizados:"
      
      Const c_trabajo = "c_trabajo"
      
      pAddField .Add(Nothing, c_trabajo), _
                .Add(Nothing, cscPrpDescrip), _
                vbNullString, _
                c_trabajo, _
                LNGGetText(2846, vbNullString), _
                m_PrpDescrip, _
                2100, 10420, 0, 2800, 500, cspText, cspMemo, True
                '"Proceso a Seguir:"
     
     .Item(c_trabajo).TopToPrevious = 750
     
    '----------------------------------------------------
    ' Estado y Ubicación del Equipo
    '
      pAddTitle .Add(Nothing), _
                .Add(Nothing), _
                LNGGetText(2847, vbNullString) '"Estado y Ubicacion del Equipo"
      
      pAddField .Add(Nothing, cscTarestId), _
                .Add(Nothing, cscTarestNombre), _
                vbNullString, _
                cscTarestId, _
                LNGGetText(2848, vbNullString), _
                m_TarNombre, _
                1000, 3000, 0, 1850
                '"Estado:"
      
      pAddField .Add(Nothing, cscDeplId), _
                .Add(Nothing, cscDeplNombre), _
                cscTarestId, _
                cscDeplId, _
                LNGGetText(2849, vbNullString), _
                m_DeplNombre, _
                900, 2500, 3400, 2050
                '"| Deposito:"
      
      pAddField .Add(Nothing, cscUsId), _
                .Add(Nothing, cscUsNombre), _
                cscTarestId, _
                cscUsId, _
                LNGGetText(2850, vbNullString), _
                m_UsNombre, _
                1100, 1500, 7000, 2000
                '"| Técnico:"
      
      Const c_presupuesto = "c_presupuesto"
      
      pAddField .Add(Nothing, c_presupuesto), _
                .Add(Nothing, cscPrpEstado), _
                cscTarestId, _
                c_presupuesto, _
                LNGGetText(2851, vbNullString), _
                m_PrpEstado, _
                1200, 1500, 9500, 2300
                '"| Presupuesto:"
      
      Const c_retiro = "c_retiro"
      
      pAddField .Add(Nothing, c_retiro), _
                .Add(Nothing, cscRvRetiro), _
                vbNullString, _
                c_retiro, _
                LNGGetText(2852, vbNullString), _
                m_RvRetiro, _
                1200, 2200, 280, 2200
                '"Retirado Por:"
    
      pAddField .Add(Nothing, cscTransId), _
                .Add(Nothing, cscTransNombre), _
                c_retiro, _
                cscTransId, _
                LNGGetText(2853, vbNullString), _
                m_Transporte, _
                2000, 2200, 3400, 2150
                '"| Transporte:"
    
      pAddField .Add(Nothing, cscRvId), _
                .Add(Nothing, cscRvGuia), _
                c_retiro, _
                cscRvId, _
                LNGGetText(2854, vbNullString), _
                m_RvGuia, _
                1500, 1500, 7000, 1650
                '"| Guia:"
    
    '----------------------------------------------------
    ' Parte del Call Center
    '
      pAddTitle .Add(Nothing), _
                .Add(Nothing), _
                LNGGetText(2855, vbNullString) '"Parte del Call Center"
      
      Const c_callcenter = "c_callcenter"
      
      pAddField .Add(Nothing, c_callcenter), _
                .Add(Nothing, c_callcenterPtd), _
                vbNullString, _
                c_callcenter, _
                LNGGetText(2856, vbNullString), _
                m_PartesDiariosCC, _
                2100, 10420, 0, 2800, 500, cspText, cspMemo, True
                '"Comentarios:"
    
    '----------------------------------------------------
    ' Parte de Administración
    '
      pAddTitle .Add(Nothing), _
                .Add(Nothing), _
                LNGGetText(2857, vbNullString) '"Parte de Administración"
      
      Const c_admin = "c_admin"
      
      pAddField .Add(Nothing, c_admin), _
                .Add(Nothing, c_adminPtd), _
                vbNullString, _
                c_admin, _
                LNGGetText(2856, vbNullString), _
                m_PartesDiariosADM, _
                2100, 10420, 0, 2800, 500, cspText, cspMemo, True
                '"Comentarios:"
    
    '----------------------------------------------------
    ' Repuestos
    '
      'pAddTitle .Add(Nothing), _
                .Add(Nothing), _
                "Repuestos"
      
    '----------------------------------------------------
    ' Detalle del Equipo - AUX
    '
      ' Esta aca para no modificar el TOP
      ' por que por algun motivo TopNoChange no Funca
      '
      With .Add(Nothing)
        .PropertyType = cspButton
        .Name = LNGGetText(2820, vbNullString) 'Buscar
        .Width = 2200
        .LeftLabel = -1
        .TopFromProperty = cscOsId
        .TopToPrevious = -480
        .Left = 11000
        .key = K_SEARCH
        .TabIndex = 1
      End With
      
      With .Add(Nothing)
        .PropertyType = cspButton
        .Name = LNGGetText(2858, vbNullString) 'Ver Detalle del Ingreso
        .Width = 2200
        .LeftLabel = -1
        .TopFromProperty = cscPrnsId
        .TopToPrevious = -60
        .Left = 11000
        .key = K_VIEW_OS
        .TabIndex = 1
      End With
      
      With .Add(Nothing)
        .PropertyType = cspButton
        .Name = LNGGetText(3065, vbNullString) '"Ver todos los partes"
        .Width = 2200
        .LeftLabel = -1
        .TopFromProperty = c_descrip
        .TopToPrevious = -480
        .Left = 11000
        .key = K_VIEW_PTD_ALL
        .TabIndex = 1
      End With
      
      With .Add(Nothing)
        .PropertyType = cspButton
        .Name = LNGGetText(2615, vbNullString) 'Editar
        .Width = 800
        .LeftLabel = -1
        .TopFromProperty = c_descrip
        .Left = 12380
        .key = K_VIEW_PTD_LABORATORIO
        .TabIndex = 1
      End With
      
      With .Add(Nothing)
        .PropertyType = cspButton
        .Name = LNGGetText(2615, vbNullString) 'Editar
        .Width = 800
        .LeftLabel = -1
        .TopFromProperty = c_trabajo
        .Left = 12380
        .key = K_VIEW_PRP
        .TabIndex = 1
      End With
      
      With .Add(Nothing)
        .PropertyType = cspButton
        .Name = LNGGetText(2615, vbNullString) 'Editar
        .Width = 800
        .LeftLabel = -1
        .TopFromProperty = c_callcenter
        .Left = 12380
        .key = K_VIEW_PTD_CALLCENTER
        .TabIndex = 1
      End With
      
      With .Add(Nothing)
        .PropertyType = cspButton
        .Name = LNGGetText(2615, vbNullString) 'Editar
        .Width = 800
        .LeftLabel = -1
        .TopFromProperty = c_admin
        .Left = 12380
        .key = K_VIEW_PTD_ADMIN
        .TabIndex = 1
      End With
            
      With .Add(Nothing, cscPrnsCodigo & "aux")
        .PropertyType = cspText
        .Left = 2000
        .Name = LNGGetText(1639, vbNullString) '"Nro. Serie"
        .Size = 100
        .key = K_CODIGO
        .Value = m_Codigo
        .TabIndex = tab_equipo
      End With

      With .Add(Nothing, cscPrnsCodigo2 & "aux")
        .PropertyType = cspText
        .Name = LNGGetText(2859, vbNullString) '"Nro. Serie 2"
        .Size = 100
        .key = K_CODIGO2
        .Value = m_Codigo2
        .TabIndex = tab_equipo
      End With

      With .Add(Nothing, cscPrnsCodigo3 & "aux")
        .PropertyType = cspText
        .Name = LNGGetText(2860, vbNullString) '"Nro. Serie 3"
        .Size = 100
        .key = K_CODIGO3
        .Value = m_Codigo3
        .TabIndex = tab_equipo
      End With

      With .Add(Nothing, cscPrnsFechavto & "aux")
        .PropertyType = cspDate
        .Name = LNGGetText(1802, vbNullString) 'Fecha de Vto.
        .Value = m_FechaVto
        .key = K_FECHAVTO
        .TabIndex = tab_equipo
      End With

      With .Add(Nothing, cscPrnsDescrip & "aux")
        .PropertyType = cspText
        .Name = C_strDescrip
        .Size = 255
        .Width = 6500
        .Height = 660
        .SubType = cspMemo
        .key = K_DESCRIP
        .Value = m_Descrip
        .TabIndex = tab_equipo
      End With
    
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Sub pAddField(ByRef iPropCaption As cIABMProperty, _
                      ByRef iPropValue As cIABMProperty, _
                      ByVal keyTop As String, _
                      ByVal keyCaption As String, _
                      ByVal Caption As String, _
                      ByVal Value As String, _
                      ByVal width1 As Long, _
                      ByVal width2 As Long, _
                      ByVal Left1 As Long, _
                      ByVal Left2 As Long, _
                      Optional ByVal Height As Long, _
                      Optional ByVal TypeABMProperty As csTypeABMProperty = cspLabel, _
                      Optional ByVal SubTypeABMProperty As csSubTypeABMProperty, _
                      Optional ByVal InputDisabled As Boolean)

      With iPropCaption
        .PropertyType = cspLabel
        .ForeColor = vbWindowText
        .Value = Caption
        .Width = width1
        .TopFromProperty = keyTop
        If LenB(keyTop) = 0 Then
          .TopToPrevious = 300
        End If
        If Left1 Then .Left = Left1
        .TabIndex = 1
      End With
      
      With iPropValue
        .PropertyType = TypeABMProperty
        If SubTypeABMProperty Then
          .SubType = SubTypeABMProperty
        End If
        .ForeColor = vbWindowText
        .Value = Value
        If TypeABMProperty = cspLabel Then
          .FontBold = True
        End If
        .TopFromProperty = keyCaption
        .LeftToPrevious = Left2
        .Width = width2
        If Height Then
          .Height = Height
        End If
        '.BackColor = RGB(128, 128, 128)
        If TypeABMProperty = cspText Then
          Dim oProp As cABMProperty
          Set oProp = iPropValue
          oProp.InputDisabled = InputDisabled
        End If
        .TabIndex = 1
      End With
  
End Sub

Private Sub pAddTitle(ByRef iPropTitle As cIABMProperty, _
                      ByRef iPropLine As cIABMProperty, _
                      ByVal title As String)
                        
  With iPropTitle
    .PropertyType = cspLabel
    .FontBold = True
    .ForeColor = vbGrayText
    .Value = title
    .Left = 280
    .Width = 13000
    .TabIndex = 1
  End With
  
  With iPropLine
    .PropertyType = cspLabel
    .FontBold = True
    .Value = String(200, "_")
    .TopToPrevious = 120
    .TabIndex = 1
  End With

End Sub

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "sp_EquipoGet " & Id

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscPrnsId)
    m_Codigo = gDB.ValField(rs.Fields, cscPrnsCodigo)
    m_Codigo2 = gDB.ValField(rs.Fields, cscPrnsCodigo2)
    m_Codigo3 = gDB.ValField(rs.Fields, cscPrnsCodigo3)
    m_Descrip = gDB.ValField(rs.Fields, cscPrnsDescrip)
    m_FechaVto = gDB.ValField(rs.Fields, cscPrnsFechavto)

    m_producto = gDB.ValField(rs.Fields, cscPrNombreCompra)
    m_OsNroDoc = gDB.ValField(rs.Fields, cscOsNrodoc)
    m_os_id = gDB.ValField(rs.Fields, cscOsId)
    m_contacto = gDB.ValField(rs.Fields, cscContNombre)
    m_ContTel = gDB.ValField(rs.Fields, cscContTel)
    m_ContCel = gDB.ValField(rs.Fields, cscContCelular)
    m_ContCiudad = gDB.ValField(rs.Fields, cscContCiudad)
    m_Falla = gDB.ValField(rs.Fields, cscEtfNombre)
    m_Ingreso = gDB.ValField(rs.Fields, cscOsFecha)
    m_Codigo4 = gDB.ValField(rs.Fields, cscPrnsCodigo4)
    m_Proveedor = gDB.ValField(rs.Fields, cscProvNombre)
    m_StProvNroDoc = gDB.ValField(rs.Fields, cscStProvNrodoc)
    
    m_PrpDescrip = gDB.ValField(rs.Fields, cscPrpDescrip)
    m_prp_id = gDB.ValField(rs.Fields, cscPrpId)
    m_TarNombre = gDB.ValField(rs.Fields, cscTarNombre)
    m_DeplNombre = gDB.ValField(rs.Fields, cscDeplNombre)
    m_UsNombre = gDB.ValField(rs.Fields, cscUsNombre)
    m_PrpEstado = gDB.ValField(rs.Fields, cscPrpEstado)
    m_RvRetiro = gDB.ValField(rs.Fields, cscRvRetiro)
    m_Transporte = gDB.ValField(rs.Fields, cscTransNombre)
    m_RvGuia = gDB.ValField(rs.Fields, cscRvGuia)
    
    pLoadPartes rs, m_PartesDiariosLB
    pLoadPartes rs, m_PartesDiariosCC
    pLoadPartes rs, m_PartesDiariosADM

  Else
    m_Id = csNO_ID
    m_Codigo = vbNullString
    m_Codigo2 = vbNullString
    m_Codigo3 = vbNullString
    m_Descrip = vbNullString
    m_FechaVto = csNoDate
    
    m_producto = vbNullString
    m_OsNroDoc = vbNullString
    m_os_id = csNO_ID
    m_contacto = vbNullString
    m_ContTel = vbNullString
    m_ContCel = vbNullString
    m_ContCiudad = vbNullString
    m_Falla = vbNullString
    m_Ingreso = vbNullString
    m_Codigo4 = vbNullString
    m_Proveedor = vbNullString
    m_StProvNroDoc = vbNullString
    
    m_PrpDescrip = vbNullString
    m_prp_id = csNO_ID
    m_TarNombre = vbNullString
    m_DeplNombre = vbNullString
    m_UsNombre = vbNullString
    m_PrpEstado = vbNullString
    m_RvRetiro = vbNullString
    m_Transporte = vbNullString
    m_RvGuia = vbNullString
            
    m_PartesDiariosLB = vbNullString
    m_PartesDiariosCC = vbNullString
    m_PartesDiariosADM = vbNullString
  
  End If

  Load = True
End Function

Private Sub pLoadPartes(ByRef rs As ADODB.Recordset, _
                        ByRef text As String)
  Dim titulo   As String
  Dim descrip  As String
  
  Set rs = rs.NextRecordset
  
  While Not rs.EOF
    
    titulo = gDB.ValField(rs.Fields, cscPtdTitulo)
    descrip = gDB.ValField(rs.Fields, cscPtdDescrip)
    
    If LenB(titulo) Then
      text = text & titulo & vbCrLf
    End If
    If LenB(descrip) Then
      text = text & descrip & vbCrLf
    End If
    
    rs.MoveNext
  Wend
                        
End Sub

Private Sub pRefreshProperties()
  Dim c       As cIABMProperty
  Dim AbmGen  As cABMGeneric
  Dim Filter  As String
  
  m_ObjAbm.Title2 = m_producto & " - NS:" & m_Codigo

  With m_ObjAbm.Properties
    
    .Item(cscOsNrodoc).Value = m_OsNroDoc
    .Item(cscContNombre).Value = m_contacto
    .Item(cscContTel).Value = m_ContTel
    .Item(cscContCelular).Value = m_ContCel
    .Item(cscCiuNombre).Value = m_ContCiudad
    .Item(cscEtfNombre).Value = m_Falla
    .Item(cscOsFecha).Value = m_Ingreso
    .Item(cscPrnsCodigo).Value = m_Codigo
    .Item(cscPrnsCodigo5).Value = m_Codigo4
    .Item(cscPrnsCodigo3).Value = m_Codigo3
    .Item(cscProvNombre).Value = m_Proveedor
    .Item(cscPrnsCodigo4).Value = m_StProvNroDoc
    .Item(cscPrnsDescrip).Value = m_PartesDiariosLB
    .Item(cscPrpDescrip).Value = m_PrpDescrip
    .Item(cscTarestNombre).Value = m_TarNombre
    .Item(cscDeplNombre).Value = m_DeplNombre
    .Item(cscUsNombre).Value = m_UsNombre
    .Item(cscPrpEstado).Value = m_PrpEstado
    .Item(cscRvRetiro).Value = m_RvRetiro
    .Item(cscTransNombre).Value = m_Transporte
    .Item(cscRvGuia).Value = m_RvGuia
    .Item(c_callcenterPtd).Value = m_PartesDiariosCC
    .Item(c_adminPtd).Value = m_PartesDiariosADM

    .Item(cscPrnsCodigo & "aux").Value = m_Codigo
    .Item(cscPrnsCodigo2 & "aux").Value = m_Codigo2
    .Item(cscPrnsCodigo3 & "aux").Value = m_Codigo3
    .Item(cscPrnsFechavto & "aux").Value = m_FechaVto
    .Item(cscPrnsDescrip & "aux").Value = m_Descrip

  End With
  
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValues m_ObjAbm.Properties
  AbmGen.RefreshTitle
  AbmGen.ResetChanged
  
End Sub

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2304, vbNullString)  'Error al grabar el Equipo
  
  ' Servicios
  Set m_TicketConfig = New cTicketConfig
  m_TicketConfig.Load
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing

  ' Servicios
  '
  Set m_TicketConfig = Nothing
End Sub
