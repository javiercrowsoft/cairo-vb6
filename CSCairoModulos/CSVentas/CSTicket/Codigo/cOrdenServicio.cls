VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cOrdenServicio"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericDoc
Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
Implements CSMenu.cIMenuClient
Implements CSIDocumento.cIDocumento
'--------------------------------------------------------------------------------
' cOrdenServicio
' 26-01-2004

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cOrdenServicio"

Private Const c_Items = "Items"

' HIDECOLS
Private Const c_HideColsOs = "HideColsOs"

Private Const K_NUMERO                         As Integer = 1
Private Const K_NRODOC                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHA                          As Integer = 4
Private Const K_HORA                           As Integer = 100
Private Const K_FECHAENTREGA                   As Integer = 5
Private Const K_NETO                           As Integer = 6
Private Const K_IVARI                          As Integer = 7
Private Const K_IVARNI                         As Integer = 8
Private Const K_TOTAL                          As Integer = 9
Private Const K_CLI_ID                         As Integer = 10
Private Const K_DOC_ID                         As Integer = 11
Private Const K_LP_ID                          As Integer = 13
Private Const K_LD_ID                          As Integer = 14
Private Const K_ITEMS                          As Integer = 15
Private Const K_CPG_ID                         As Integer = 16
Private Const K_EST_ID                         As Integer = 17
Private Const K_CCOS_ID                        As Integer = 18
Private Const K_SUC_ID                         As Integer = 19
Private Const K_DESCUENTO1                     As Integer = 20
Private Const K_DESCUENTO2                     As Integer = 21
Private Const K_IMPORTEDESC1                   As Integer = 22
Private Const K_IMPORTEDESC2                   As Integer = 23
Private Const K_SUBTOTAL                       As Integer = 24
Private Const K_DEPL_ID                        As Integer = 25
Private Const K_LGJ_ID                         As Integer = 27
Private Const K_COTIZACION                     As Integer = 28

Private Const K_CLIS_ID                        As Integer = 29
Private Const K_PROY_ID                        As Integer = 30
Private Const K_PRIO_ID                        As Integer = 31
Private Const K_INCT_ID                        As Integer = 32
Private Const K_INCA_ID                        As Integer = 33
Private Const K_CONT_ID                        As Integer = 34
Private Const K_ZON_ID                         As Integer = 35

Private Const K_US_ID_TECNICO                  As Integer = 36

' HIDECOLS
Private Const K_HIDECOLS                       As Integer = 41

Private Const KI_OS_ID                          As Integer = 1
Private Const KI_OSI_ID                         As Integer = 2
Private Const KI_ORDEN                          As Integer = 3
Private Const KI_CANTIDAD                       As Integer = 4
Private Const KI_DESCRIP                        As Integer = 6
Private Const KI_PRECIO                         As Integer = 7
Private Const KI_IMPORTE                        As Integer = 8
Private Const KI_NETO                           As Integer = 9
Private Const KI_IVARI                          As Integer = 10
Private Const KI_IVARNI                         As Integer = 11
Private Const KI_PR_ID                          As Integer = 13
Private Const KI_LPI_ID                         As Integer = 14
Private Const KI_LDI_ID                         As Integer = 15
Private Const KI_IVARIPercent                   As Integer = 16
Private Const KI_IVARNIPercent                  As Integer = 17
Private Const KI_DESCUENTO                      As Integer = 18
Private Const KI_UNIDAD                         As Integer = 19
Private Const KI_PRECIO_LP                      As Integer = 20
Private Const KI_PRECIO_USR                     As Integer = 21
Private Const KI_CCOS_ID                        As Integer = 22

Private Const KI_PR_LLEVANROSERIE               As Integer = 23
Private Const KI_NROSERIE                       As Integer = 24
Private Const KI_GRUPO                          As Integer = 25

' Lote
'
Private Const KI_STL_ID                         As Integer = 26
Private Const KI_STL_CODIGO                     As Integer = 29
Private Const KI_PR_LLEVALOTE                   As Integer = 27

Private Const KI_TAR_ID                         As Integer = 30
Private Const KI_CONT_ID                        As Integer = 31
Private Const KI_RUB_ID                         As Integer = 32

Private Const KI_ETF_ID                         As Integer = 33


' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Numero                       As Long
Private m_Estado                       As String
Private m_est_id                       As Long
Private m_Nrodoc                       As String
Private m_Descrip                      As String
Private m_Fecha                        As Date
Private m_Hora                         As Integer
Private m_Fechaentrega                 As Date
Private m_Neto                         As Double
Private m_Ivari                        As Double
Private m_Ivarni                       As Double
Private m_Total                        As Double
Private m_SubTotal                     As Double
Private m_Descuento1                   As Double
Private m_Descuento2                   As Double
Private m_ImporteDesc1                 As Double
Private m_ImporteDesc2                 As Double
Private m_cpg_id                       As Long
Private m_CondicionPago                As String
Private m_ccos_id                      As Long
Private m_CentroCosto                  As String
Private m_suc_id                       As Long
Private m_Sucursal                     As String
Private m_cli_id                       As Long
Private m_Cliente                      As String
Private m_cont_id                      As Long
Private m_contacto                     As String
Private m_zon_id                       As Long
Private m_zona                         As String

Private m_us_id_tecnico                As Long
Private m_tecnico                      As String

Private m_doc_id                       As Long
Private m_Documento                    As String
Private m_Doct_id                      As Long
Private m_Lp_id                        As Long
Private m_ListaPrecio                  As String
Private m_Ld_id                        As Long
Private m_ListaDescuento               As String
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_Firmado                      As Boolean
Private m_lgj_id                       As Long
Private m_Legajo                       As String

Private m_clis_id                      As Long
Private m_clienteSuc                   As String

Private m_Proy_id                      As Long
Private m_Proyecto                     As String

Private m_Prio_id                      As Long
Private m_Prioridad                    As String

Private m_inct_id                      As Long
Private m_IncidenteTipo                As String

Private m_inca_id                      As Long
Private m_IncidenteApertura            As String

Private m_Cotizacion                   As Double
Private m_mon_id                       As Long
Private m_lastFecha                    As Date
Private m_lastMonIdCotizacion          As Long

' Para ver documentos auxiliares
'
Private m_st_id                        As Long

Private m_Editing                      As Boolean

Private m_bShowStockData               As Boolean
Private m_depl_id                      As Long
Private m_deposito                     As String

Private m_Footer            As cIABMGeneric
Private m_Items             As cIABMGeneric
Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_LastDoc           As Long
Private m_LastDoctId        As Long ' nrs devolucion
Private m_Lastcli           As Long
Private m_LastDocName       As String
Private m_LastcliName       As String

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost

Private m_ItemsDeleted      As String

Private m_Copy              As Boolean

Private m_GeneralConfig     As cGeneralConfig
Private m_TicketConfig      As cTicketConfig

Private m_DocEditable       As Boolean
Private m_DocEditMsg        As String

Private m_bIva              As Boolean
Private m_bIvaRni           As Boolean

Private m_TaPropuesto       As Boolean
Private m_TaMascara         As String

Private m_ObjApply          As cOrdenServicioAplic

Private m_NrosSerie         As Collection

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

' Para distinguir entre las distintas llamadas
' a Validate
'
Private m_bHaveToValidate   As Boolean

' Detalles del equipo
'
Private m_CollEquipoDetalle As Collection

Private m_object_edit       As String
Private m_ObjEdit           As Object

' propiedades publicas
' propiedades privadas
' funciones publicas

' Edit Apply
'

Public Function Save() As Boolean
  Dim AbmGen  As cABMGeneric
  Set AbmGen = m_ObjAbm
  Save = AbmGen.Save()
End Function

Public Sub NewDoc()
  Dim AbmGen  As cABMGeneric
  Set AbmGen = m_ObjAbm
  AbmGen.RaiseNewDocEven
End Sub

Public Function SetCliente(ByVal cli_id As Long) As Boolean
  Dim AbmGen  As cABMGeneric
  Dim iProp   As cIABMProperty
  
  Set iProp = pGetCliente()
  
  iProp.Value = pGetCliNombre(cli_id)
  iProp.HelpId = cli_id
  
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValue iProp
  
  SetCliente = True
End Function

Private Function pGetCliente() As cIABMProperty
  Set pGetCliente = m_ObjAbm.Properties.Item(cscCliId)
End Function

Public Function AddItem(ByVal pr_id As Long, _
                        ByVal NroSerie As String, _
                        ByVal descrip As String) As Boolean
                        
  Dim Grupo As Long
  Dim Row   As cIABMGridRow
  Dim Rows  As cIABMGridRows
  Dim pr_nombre As String
  
  pr_nombre = pGetPrNombre(pr_id)
  
  Set Rows = pGetItems().Grid.Rows
  
  Grupo = (Rows.Count + 1) * -1
  
  Set Row = Rows.Add(Nothing)
  With Row
    
    With .Add(Nothing)
      .Value = csNO_ID
      .key = KI_OSI_ID
    End With
    
    With .Add(Nothing)
      .Value = pr_nombre
      .Id = csNO_ID ' El pr_id se lo asignamos despues de llamar a pSetDataProducto
      .key = KI_PR_ID
    End With
    
    With .Add(Nothing)
      .Value = descrip
      .key = KI_DESCRIP
    End With
    
    With .Add(Nothing)
      .Value = 1
      .key = KI_CANTIDAD
    End With
    
    With .Add(Nothing)
      .Value = NroSerie
      .key = KI_NROSERIE
    End With
    
    With .Add(Nothing)
      .Value = csNO_ID
      .key = KI_RUB_ID
    End With
    
    With .Add(Nothing)
      .Value = vbNullString
      .Id = csNO_ID
      .key = KI_TAR_ID
    End With
    
    With .Add(Nothing)
      .Value = vbNullString
      .Id = csNO_ID
      .key = KI_CONT_ID
    End With
    
    With .Add(Nothing)
      .Value = vbNullString
      .Id = csNO_ID
      .key = KI_ETF_ID
    End With
    
    ' Lote
    '
    With .Add(Nothing)
      .Value = vbNullString
      .key = KI_STL_CODIGO
    End With
    With .Add(Nothing)
      .Id = csNO_ID
      .key = KI_STL_ID
    End With
    
    With .Add(Nothing)
      .Value = 0
      .key = KI_DESCUENTO
    End With
    
    With .Add(Nothing)
      .Value = vbNullString
      .key = KI_UNIDAD
    End With
    
    With .Add(Nothing)
      .Value = 0
      .key = KI_PRECIO_LP
    End With
    
    With .Add(Nothing)
      .Value = 0
      .key = KI_PRECIO_USR
    End With
    
    With .Add(Nothing)
      .Value = 0
      .key = KI_PRECIO
    End With
    
    With .Add(Nothing)
      .Value = 0
      .key = KI_NETO
    End With

    With .Add(Nothing)
      .Value = 0
      .key = KI_IVARI
    End With

    With .Add(Nothing)
      .Value = 0
      .key = KI_IVARNI
    End With

    With .Add(Nothing)
      .Value = 0
      .key = KI_IMPORTE
    End With

    With .Add(Nothing)
      .Value = 0
      .key = KI_IVARIPercent
    End With

    With .Add(Nothing)
      .Value = 0
      .key = KI_IVARNIPercent
    End With
    
    With .Add(Nothing)
      .Value = vbNullString
      .Id = csNO_ID
      .key = KI_CCOS_ID
    End With
    
    ' Lote
    '
    With .Add(Nothing)
      .Id = 0
      .key = KI_PR_LLEVALOTE
    End With
    
    With .Add(Nothing)
      .Id = 1
      .key = KI_PR_LLEVANROSERIE
    End With

    With .Add(Nothing)
      .Id = Grupo
      .key = KI_GRUPO
    End With

  End With

  pSetDataProducto Row, pr_id
  
  pAddItemNroSerie Grupo, NroSerie, pr_id
  
  pSetPrecios Row, pr_id
  pSetDescuentos Row, pr_id, pGetPrecioFromRow(Row)
  pSetTasasImpositivas Row, pr_id, pr_nombre
  
  pCell(Row, KI_PR_ID).Id = pr_id

  pShowImporteAndIva Row
  pShowTotales Rows

  Dim AbmGen  As cABMGeneric

  Set AbmGen = m_Items
  AbmGen.ShowValues m_Items.Properties

  AddItem = True

End Function

Private Function pAddItemNroSerie(ByVal Grupo As Long, ByVal sNroSerie As String, ByVal pr_id As Long)

  Dim NroSerie  As cProductoSerieType
  Dim coll      As Collection
    
  ' Guardo el numero de serie
  Set NroSerie = New cProductoSerieType
  With NroSerie
    .Codigo = sNroSerie
    .prns_id = -1
    .pr_id = pr_id
    
  End With
    
  Set coll = New Collection
    
  ' Lo agrego a la bolsa
  coll.Add NroSerie, GetKey(NroSerie.prns_id)
    
  m_NrosSerie.Add coll, GetKey(Grupo)
  
  pSetNrosSerieInRow Grupo, sNroSerie

End Function

Private Function pGetPrNombre(ByVal pr_id As Long)
  Dim pr_nombre As String
  If Not gDB.GetData(csTProducto, cscPrId, pr_id, cscPrNombreventa, pr_nombre) Then Exit Function
  pGetPrNombre = pr_nombre
End Function

Private Function pGetCliNombre(ByVal cli_id As Long)
  Dim cli_nombre As String
  If Not gDB.GetData(csTCliente, cscCliId, cli_id, cscCliNombre, cli_nombre) Then Exit Function
  pGetCliNombre = cli_nombre
End Function

Public Sub Refresh()
  Load m_Id
  pRefreshProperties
End Sub

Public Function TerminateWizard(ByVal Id As Long)
  On Error Resume Next
  If Id <> csNO_ID Then
    cIEditGeneric_Edit Id
  End If
End Function

Private Function pInitMembers() As Boolean
  Set cIEditGeneric_ObjAbm = New cABMGeneric
  Set cIEditGenericDoc_Footer = New cABMGeneric
  Set cIEditGenericDoc_Items = New cABMGeneric
  
  If Not DocSecurityCanAccess(csPreTickNewOrdenServ, _
                              csNO_ID, _
                              csEDocTPreNew) Then
    Exit Function
  End If
  pInitMembers = True
End Function

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  If Not DocSecurityCanAccessEx(csPreTickNewOrdenServ, _
                                m_doc_id, _
                                csEDocTPreNew, _
                                True) Then Exit Function
  
  cIABMClient_Terminate
  m_IsNew = True
  m_Copy = True
  m_DocEditable = True
  m_DocEditMsg = vbNullString
  
  ' Obtengo el numero para este comprobante
  '
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscOsNrodoc
  pSetEnabled
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True

  cIEditGeneric_Edit csNO_ID
  m_Lastcli = csNO_ID
  
  If Not m_DocEditable Then
    If LenB(m_DocEditMsg) Then
      MsgWarning m_DocEditMsg
    End If
  End If
  
  If m_ObjAbm.Properties.Item(cscDocId).HelpId = csNO_ID Then
    MsgInfo LNGGetText(1562, vbNullString)  'Debe indicar un documento
  End If
  
  If m_UserCfg.CliIdxDefecto Then
    Dim iProp As cIABMProperty
    Set iProp = pGetCliente()
    With iProp
      .HelpId = m_UserCfg.CliIdxDefecto
      .Value = m_UserCfg.ClienteXDefecto
    End With
    m_ObjAbm.ShowValue iProp
  End If
  
  ' Obtengo los datos por defecto del cliente
  '
  pSetDatoscliente
  
  ' Obtengo el numero para este comprobante
  '
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscOsNrodoc
  
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

  Doc.ClientTable = csTOrdenServicio
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
    Case MSG_DOC_FIRST, MSG_DOC_PREVIOUS, MSG_DOC_NEXT, MSG_DOC_LAST
      cIABMClient_MessageEx = pMove(MessageID)
    Case MSG_DOC_SIGNATURE
      cIABMClient_MessageEx = pFirmar()
    Case MSG_GRID_ROW_DELETED
      cIABMClient_MessageEx = True
      pShowTotales GetItems(m_Items, c_Items).Grid.Rows
    
    Case MSG_DOC_EDIT_STATE
      ShowEditState m_DocEditMsg, LNGGetText(1830, vbNullString)  'Ordenes de Servicio
      
    Case MSG_DOC_DELETE
      If cIEditGeneric_Delete(m_Id) Then
        cIABMClient_MessageEx = True
        pMove MSG_DOC_NEXT
      End If
      
    Case MSG_DOC_APPLY
      pShowApply
      
    Case MSG_DOC_ANULAR
      DocAnular m_Id, _
                m_est_id, _
                m_Estado, _
                csPreTickAnularOrdenServ, _
                csPreTickDesAnularOrdenServ, _
                m_ObjAbm, _
                m_DocEditable, _
                m_DocEditMsg, _
                "sp_DocOrdenServicioAnular", _
                "sp_DocOrdenServicioEditableGet"
      pSetEnabled
    
    Case MSG_DOC_REFRESH
      Load m_Id
      pRefreshProperties
  
    Case MSG_DOC_NEW_WITH_WIZARD
      cIABMClient_MessageEx = True
    
    Case MSG_DOC_EX_PRE_VALIDATE
      m_bHaveToValidate = True
    
    Case MSG_DOC_EX_GET_ITEMS
      Set cIABMClient_MessageEx = m_Items
    
    Case MSG_DOC_EX_GET_FOOTERS
      Set cIABMClient_MessageEx = m_Footer
  
    Case MSG_DOC_SEARCH                     ' En info cABMInteface nos
                                            ' indica si hay cambios sin
                                            ' guardar
      DocumentSearch csEDT_OrdenServicio, Me, Not CBool(Info)
  
    Case MSG_DOC_DOC_AUX
      
      If m_bShowStockData Then
        
        If m_Id Then
        
          ShowDocAux m_st_id, _
                     "CSStock2.cStock", _
                     "CSABMInterface2.cABMGeneric"
        Else
          MsgInfo LNGGetText(1620, vbNullString)
                  'Debe editar un comprobante guardado para poder ver los documentos auxiliares
        End If
      End If
      
    Case MSG_DOC_DOC_EDIT
      
      If m_Id Then
      
        If m_DocEditable Then
        
          MsgInfo LNGGetText(1555, vbNullString)
                  'Este documento puede editarse normalmente
        Else
          
          If DocCanSave(m_ObjAbm, cscOsFecha) Then
            
            Dim EditDoc As cEditDocEx
            Set EditDoc = New cEditDocEx
            
            Set EditDoc.ObjectClient = Me
            EditDoc.Edit m_Id, _
                         m_Doct_id, _
                         csTOrdenServicio, _
                         cscOsId, _
                         csTOrdenServicioItem, _
                         cscOsiId, _
                         csPreTickNewOrdenServ, _
                         csPreTickEditOrdenServ, _
                         csNO_ID, m_cli_id, _
                         True
          End If
          
        End If
      
      Else
        MsgInfo LNGGetText(1556, vbNullString)
                'Esta opción solo sirve para modificar documentos guardados y aplicados
      End If
      
    Case MSG_DOC_DOC_ACTION
    
      If m_Id Then
        pShowRemito
      Else
        MsgInfo LNGGetText(3955, vbNullString)
                'Esta opción solo sirve para modificar documentos guardados y aplicados
      End If
    
    Case MSG_DOC_HISTORY
    
      If m_Id <> csNO_ID Then
    
        ShowHistory csOrdenServicio, m_Id, m_Documento & " " & m_Nrodoc
      Else
        
        MsgInfo LNGGetText(1552, vbNullString) ' El documento aun no ha sido guardado
      End If
  
    Case MSG_EXPORT_GET_EMAIL
    
      With pGetCliente()
        cIABMClient_MessageEx = GetEmailFromCliente(.HelpId)
      End With
  
    Case MSG_DOC_NEW_EVENT_COMPLETE
        
        pEditFromObjectAux

  End Select
  
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal key As Integer) As Boolean
  Dim bDocChanged As Boolean
  
  Select Case key
    Case K_DOC_ID
      ' Si cambio de documento
      '
      If DocChange(m_ObjAbm, m_LastDoc, m_LastDocName) Then
        
        ' Obtengo el tipo de documento
        If Not gDB.GetData(csTDocumento, cscDocId, m_LastDoc, cscDoctId, m_LastDoctId) Then Exit Function ' nrs devolucion
        
        ' Si cambie de documento y estaba en un comprobante ya guardado
        ' tengo que mostrar el formulario sin datos, para evitar
        ' que presione guardar y le cambie el doc_id al comprobante por error
        '
        If m_Id <> csNO_ID And m_doc_id <> m_LastDoc Then cIEditGeneric_Edit csDocChanged
        
        ' Obtengo el numero para este comprobante
        '
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscOsNrodoc
        
        ' Si corresponde muestro la cotizacion de la moneda del documento
        '
        pShowCotizacion
        
        ' Si corresponde muestro el deposito
        '
        pSetShowStockData
      
        m_object_edit = vbNullString
        
        ' Obtengo el tipo de documento
        If Not gDB.GetData(csTDocumento, cscDocId, m_LastDoc, cscDocObjectEdit, m_object_edit) Then Exit Function ' nrs devolucion
      
      End If

      ' Defino el estado de edicion del comprobante
      '
      pSetEnabled
      
    Case K_CLI_ID
      
      ' Obtengo los datos del cliente
      '
      pSetDatoscliente
      
      With m_ObjAbm.Properties
        
        Dim Filter As String
        Filter = "cli_id = " & .Item(cscCliId).HelpId
        
        ValidateHelp cscClisId, csSucursalCliente, .Item(cscClisId).HelpId, Filter
        m_ObjAbm.ShowValue .Item(cscClisId)
        
        ValidateHelp cscProyId, csProyecto, .Item(cscProyId).HelpId, Filter
        m_ObjAbm.ShowValue .Item(cscProyId)
        
        ValidateHelp cscContId, csContacto, .Item(cscContId).HelpId, Filter
        m_ObjAbm.ShowValue .Item(cscContId)
      
      End With
      
      With m_Items.Properties
        With .Item(c_Items).Grid.Columns.Item(cscContId)
          .HelpFilter = Filter
        End With
        
        Dim AbmObj As cABMGeneric
        Set AbmObj = m_ObjAbm
        
        AbmObj.RefreshColumnProperties .Item(c_Items), cscContId
      
      End With
    
      ' DATADD
      ShowDataAddCliente m_UserCfg.ShowDataAddInVentas, _
                         m_ObjAbm
    
    Case K_DESCUENTO1, K_DESCUENTO2
      pShowTotales GetItems(m_Items, c_Items).Grid.Rows
  
    Case K_FECHA
      
      ' Cotizacion
      If m_lastFecha <> pGetFecha() Then
        m_lastFecha = pGetFecha()
        m_lastMonIdCotizacion = csNO_ID
        pShowCotizacion
      End If
  
    ' HIDECOLS
    '
    Case K_HIDECOLS
    
      pShowHideCols False
  
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register      As cRegister
  Dim Hora          As Integer
  Dim NroDoc        As String
  Dim bIsNew        As Boolean
  
  ' Save and State
  '
  If Not DocCanEdit(m_DocEditable, m_DocEditMsg) Then
    cIABMClient_Save = True
    Exit Function
  End If
  If Not DocCanSave(m_ObjAbm, cscOsFecha) Then
    cIABMClient_Save = False
    Exit Function
  End If
  
  If pGetItems().Grid.Rows.Count = 0 Then
    MsgWarning LNGGetText(3903, vbNullString) 'El documento debe contener al menos un item
    cIABMClient_Save = False
    Exit Function
  End If
  
  Dim mouse As cMouseWait
  Set mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  register.fieldId = cscOsTMPId
  register.table = csTOrdenServicioTMP
  
  register.Id = csNew
    
  If m_Copy Then
    register.Fields.Add2 cscOsId, csNew, csLong
    bIsNew = True
  Else
    register.Fields.Add2 cscOsId, m_Id, csLong
    bIsNew = m_Id = csNO_ID
  End If
  
  If register.Id = csNew Then
    m_est_id = CSGeneralEx2.csEEstado.csEEst_Pendiente
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .key
        Case K_NUMERO
          register.Fields.Add2 cscOsNumero, .Value, csLong
        Case K_NRODOC
          NroDoc = .Value
          register.Fields.Add2 cscOsNrodoc, NroDoc, csText
        Case K_DESCRIP
          register.Fields.Add2 cscOsDescrip, .Value, csText
        Case K_FECHA
          register.Fields.Add2 cscOsFecha, .Value, csDate
        Case K_HORA
          If IsDate(.Value) Then
            Hora = Hour(.Value) * 100 + Minute(.Value)
          End If
          register.Fields.Add2 cscOsHora, Hora, csInteger
        Case K_FECHAENTREGA
          register.Fields.Add2 cscOsFechaentrega, .Value, csDate
        Case K_CLI_ID
          register.Fields.Add2 cscCliId, .HelpId, csId
        Case K_CONT_ID
          register.Fields.Add2 cscContId, .HelpId, csId
        Case K_ZON_ID
          register.Fields.Add2 cscZonId, .HelpId, csId
        Case K_US_ID_TECNICO
          register.Fields.Add2 cscUsIdTecnico, .HelpId, csId
        Case K_COTIZACION
          register.Fields.Add2 cscOsCotizacion, .Value, csDouble
        Case K_CCOS_ID
          register.Fields.Add2 cscCcosId, .HelpId, csId
        Case K_SUC_ID
          register.Fields.Add2 cscSucId, .HelpId, csId
        Case K_DESCUENTO1
          register.Fields.Add2 cscOsDescuento1, .Value, csCurrency
        Case K_DESCUENTO2
          register.Fields.Add2 cscOsDescuento2, .Value, csCurrency
        Case K_DOC_ID
          register.Fields.Add2 cscDocId, .HelpId, csId
        Case K_LP_ID
          register.Fields.Add2 cscLpId, .HelpId, csId
        Case K_LD_ID
          register.Fields.Add2 cscLdId, .HelpId, csId
        Case K_CPG_ID
          register.Fields.Add2 cscCpgId, .HelpId, csId
        Case K_DEPL_ID
          register.Fields.Add2 cscDeplId, .HelpId, csId
        Case K_LGJ_ID
          register.Fields.Add2 cscLgjId, .HelpId, csId
      
        Case K_CLIS_ID
          register.Fields.Add2 cscClisId, .HelpId, csId
        Case K_PROY_ID
          register.Fields.Add2 cscProyId, .HelpId, csId
        Case K_PRIO_ID
          register.Fields.Add2 cscPrioId, .HelpId, csId
        Case K_INCT_ID
          register.Fields.Add2 cscInctId, .HelpId, csId
        Case K_INCA_ID
          register.Fields.Add2 cscIncaId, .HelpId, csId
      
      End Select
    End With
  Next
  
  For Each IProperty In m_Footer.Properties
    With IProperty
      Select Case .key
        Case K_TOTAL
          register.Fields.Add2 cscOsTotal, .Value, csCurrency
        Case K_NETO
          register.Fields.Add2 cscOsNeto, .Value, csCurrency
        Case K_IVARI
          If m_bIva Then
            register.Fields.Add2 cscOsIvari, .Value, csCurrency
          End If
        Case K_IVARNI
          If m_bIvaRni Then
            register.Fields.Add2 cscOsIvarni, .Value, csCurrency
          End If
        Case K_SUBTOTAL
          register.Fields.Add2 cscOsSubtotal, .Value, csCurrency
        Case K_IMPORTEDESC1
          register.Fields.Add2 cscOsImportedesc1, .Value, csCurrency
        Case K_IMPORTEDESC2
          register.Fields.Add2 cscOsImportedesc2, .Value, csCurrency
      End Select
    End With
  Next
  
  register.Fields.Add2 cscEstId, m_est_id, csId
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
    
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If Not pSaveItems(register.Id, NroDoc) Then Exit Function
  If Not register.CommitTrans() Then Exit Function
  
  If Not pSaveEquipoDetalle(IIf(m_Copy, csNO_ID, m_Id), _
                            register.Id) Then Exit Function
  
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DocOrdenServicioSave " & register.Id
  
  If Not gDB.OpenRs(sqlstmt, rs, , , , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim Id As Long
  If Not GetDocIDFromRecordset(rs, Id) Then Exit Function
  
  m_Copy = False
  
  cIABMClient_Save = Load(Id)

  If Load(Id) Then

    Dim AbmGen As cABMGeneric
    Set AbmGen = m_ObjAbm
    
    If bIsNew Then
    
      If m_UserCfg.NuevoAlGrabar Then
        AbmGen.PrintDocumento
      End If
      
      AbmGen.SendNewDoc = m_UserCfg.NuevoAlGrabar
    
    End If
  
    
    cIABMClient_Save = True
    
  Else
  
    cIABMClient_Save = False
    
  End If
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  ' HIDECOLS
  '
  CSKernelClient2.SetRegistry csInterface, c_HideColsOs, Val(m_ObjAbm.Properties.Item(c_HideCols).Value)
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  m_ObjTree.sqlstmt = "sp_lsdoc_OrdenServicio"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(1830, vbNullString) 'Ordenes de Servicio
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .key
        Case K_FECHA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(1558, vbNullString) 'Debe indicar una fecha
            Exit Function
          End If
        Case K_FECHAENTREGA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(1564, vbNullString) 'Debe indicar una fecha de entrega
            Exit Function
          End If
        Case K_CLI_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1563, vbNullString) 'Debe indicar un cliente
            Exit Function
          End If
        Case K_DOC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1562, vbNullString) 'Debe indicar un documento
            Exit Function
          End If
        Case K_CPG_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1561, vbNullString) 'Debe indicar una condición de pago
            Exit Function
          End If
        Case K_SUC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1560, vbNullString) 'Debe indicar una sucursal
            Exit Function
          End If
        Case K_COTIZACION
          If ValEmpty(.Value, csDouble) And .Visible Then
            MsgInfo LNGGetText(1626, vbNullString) 'Debe indicar una cotización
            Exit Function
          End If
        Case K_DEPL_ID
          If ValEmpty(.HelpId, csId) And m_bShowStockData Then
            MsgInfo LNGGetText(1559, vbNullString) 'Debe indicar un deposito
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = pValidateSeries()
End Function

Private Function pValidateSeries() As Boolean
  Dim sqlstmt As String
  Dim pt      As cProductoSerieType
  Dim rs      As ADODB.Recordset
  Dim Items   As Object
  Dim depl_id As Long
  Dim msg     As String
  Dim pr_id   As Long
  
  ' Solo valido una vez por cada intento
  ' de grabacion, ya que CSABMInterface
  ' me llama tres veces: una por m_ObjAbm otra
  ' por m_Items y otra por m_Footers
  '
  If m_bHaveToValidate Then
  
    For Each Items In m_NrosSerie
    
      ' Obtengo los numeros de serie y guardo un Item por cada uno
      '
      For Each pt In Items
      
        pr_id = pt.pr_id
        
        If pr_id = csNO_ID Then Exit Function
        
        If Not (pt.Deleted Or (pt.prns_id <> csNO_ID And pt.prns_id <> -1)) Then
        
          sqlstmt = "sp_DocOrdenServicioCheckReingreso " & pr_id & "," & _
                          gDB.sqlString(pt.Codigo) & "," & _
                          gDB.sqlString(pt.Codigo2) & "," & _
                          gDB.sqlString(pt.Codigo3)
        
          If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
          
          If Not rs.EOF Then
            depl_id = gDB.ValField(rs.Fields, cscDeplId)
            If depl_id <> -3 And depl_id <> -2 Then
              msg = LNGGetText(1840, vbNullString, gDB.ValField(rs.Fields, cscPrNombreCompra), _
                                                   gDB.ValField(rs.Fields, cscPrnsCodigo), _
                                                   gDB.ValField(rs.Fields, cscPrnsCodigo2), _
                                                   gDB.ValField(rs.Fields, cscPrnsCodigo3), _
                                                   gDB.ValField(rs.Fields, cscDeplNombre))
              
              
              'msg = "Este equipo:;;" _
                                 & gDB.ValField(rs.Fields, cscPrNombreCompra) _
                                 & " ;-Ns:  " & gDB.ValField(rs.Fields, cscPrnsCodigo) _
                                 & " ;-Ns2: " & gDB.ValField(rs.Fields, cscPrnsCodigo2) _
                                 & " ;-Ns3: " & gDB.ValField(rs.Fields, cscPrnsCodigo3) _
                                 & ";;" _
                    & "Ya se encuentra en la empresa en el deposito:;;" _
                    & gDB.ValField(rs.Fields, cscDeplNombre)
                    
              MsgWarning msg
              Exit Function
            
            Else
              msg = LNGGetText(1841, vbNullString, gDB.ValField(rs.Fields, cscPrNombreCompra), _
                                                   gDB.ValField(rs.Fields, cscPrnsCodigo), _
                                                   gDB.ValField(rs.Fields, cscPrnsCodigo2), _
                                                   gDB.ValField(rs.Fields, cscPrnsCodigo3), _
                                                   gDB.ValField(rs.Fields, cscOsNrodoc), _
                                                   gDB.ValField(rs.Fields, cscOsFecha))
              
              'msg = "Este equipo:;;" _
                                 & gDB.ValField(rs.Fields, cscPrNombreCompra) _
                                 & " ;-Ns:  " & gDB.ValField(rs.Fields, cscPrnsCodigo) _
                                 & " ;-Ns2: " & gDB.ValField(rs.Fields, cscPrnsCodigo2) _
                                 & " ;-Ns3: " & gDB.ValField(rs.Fields, cscPrnsCodigo3) _
                                 & ";;" _
                    & " Es un reingreso y esta mencionado en la Orden de Servicio " _
                    & gDB.ValField(rs.Fields, cscOsNrodoc) _
                    & " del " & gDB.ValField(rs.Fields, cscOsFecha) _
                    & ";;¿Confirma el reingreso del equipo?"
              If Not Ask(msg, vbYes) Then
                Exit Function
              End If
            End If
          End If
        End If
      Next
    Next
    
    m_bHaveToValidate = False
  End If
  
  pValidateSeries = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case key
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRow(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

'-------------------------------------------------------------------------------------
' Documento
Private Property Get cIDocumento_DocId() As Long
  cIDocumento_DocId = m_doc_id
End Property

Private Property Get cIDocumento_DocTId() As Long
  cIDocumento_DocTId = m_Doct_id
End Property

Private Property Get cIDocumento_Id() As Long
  cIDocumento_Id = m_Id
End Property

Private Function cIDocumento_LoadForPrint(ByVal Id As Long) As Boolean
  On Error GoTo ControlError

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select doct_id, doc_id from OrdenServicio where os_id = " & Id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_Id = Id
  m_doc_id = gDB.ValField(rs.Fields, cscDocId)
  m_Doct_id = gDB.ValField(rs.Fields, cscDoctId)
  
  cIDocumento_LoadForPrint = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIDocumento_LoadForPrint", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
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

Private Function cIEditGeneric_GridAdd(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
  cIEditGeneric_ShowList = SecurityCanAccess(csPreTickListOrdenServ)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
  m_ObjAbm.IsDocument = True

#If Not PREPROC_SFS Then
  Dim AbmGen As cABMGenericDocEx

  Set AbmGen = m_ObjAbm
  With AbmGen
    .FactoryObject = "CSABMInterface2.cFactory"
    .ObjForm = "CSABMInterface2.fOrdenServicio"
  End With
#End If
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  Dim doc_id As Long
  
  If Not m_ObjAbm Is Nothing Then
    doc_id = GetdocIdFromObjAbm(m_ObjAbm)
  Else
    If Not GetDocIdFromId(Id, _
                          csTOrdenServicio, _
                          cscOsId, _
                          doc_id) Then
      Exit Function
    End If
  End If
  
  If Not DocSecurityCanAccess( _
                  csPreTickDeleteOrdenServ, _
                  doc_id, _
                  csEDocTPreDelete) Then
    Exit Function
  End If

  Dim sqlstmt As String
  
  sqlstmt = "sp_DocOrdenServicioDelete " & Id & "," & EmpId & "," & User.Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not DocSecurityCanAccess(csPreTickListOrdenServ, GetdocIdFromObjAbm(m_ObjAbm), csEDocTPreList) Then Exit Function
                            
                            ' Id = csDocChanged esto significa que se cambio
                            '                   el documento estando en un
                            '                   comprobante ya guardado
                            '
  m_IsNew = Id = csNO_ID Or Id = csDocChanged

  If Not Load(Id) Then Exit Function
  
  If m_ObjAbm.Properties.Count = 0 Then
    If Not LoadCollection() Then Exit Function
  Else
    pRefreshProperties
  End If
  
  Dim AbmGen As cABMGeneric
  Set AbmGen = m_ObjAbm
  AbmGen.NewKeyPropFocus = cscCliId
  
  m_Editing = True
  m_Copy = False
  
  cIEditGeneric_Edit = True
  Exit Function
ControlError:
  MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal Id As Long) As Boolean

End Function

Private Property Set cIEditGeneric_ObjTree(rhs As Object)
    Set m_ObjTree = rhs
End Property

Private Function cIEditGeneric_PropertyChange(ByVal key As Integer) As Boolean

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

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  On Error GoTo ControlError
  
  Select Case key
    Case K_ITEMS
      With GetItems(m_Items, c_Items)
        pShowImporteAndIva .Grid.Rows(lRow)
        pShowTotales .Grid.Rows
      End With
      cIABMClientGrid_ColumnAfterUpdate = True
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnAfterUpdate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  On Error GoTo ControlError

  Select Case key
    Case K_ITEMS
      cIABMClientGrid_ColumnAfterEdit = pColumnAfterEdit( _
                                           GetItems(m_Items, c_Items), _
                                           lRow, _
                                           lCol, _
                                           NewValue, _
                                           NewValueID)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnAfterEdit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  On Error GoTo ControlError

  Select Case key
    Case K_ITEMS
      cIABMClientGrid_ColumnBeforeEdit = pColumnBeforeEdit( _
                                           GetItems(m_Items, c_Items), _
                                           lRow, _
                                           lCol, _
                                           iKeyAscii)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnBeforeEdit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pColumnBeforeEdit(ByRef IProperty As cIABMProperty, _
                                   ByVal lRow As Long, _
                                   ByVal lCol As Long, _
                                   ByVal iKeyAscii As Integer) As Boolean
  Dim Row As cIABMGridRow
  
  Select Case IProperty.Grid.Columns(lCol).key
    Case KI_NROSERIE
      Set Row = IProperty.Grid.Rows(lRow)
      If Not Row Is Nothing Then
        pColumnBeforeEdit = pCell(Row, KI_PR_LLEVANROSERIE).Id
      End If
    
    ' Lote
    '
    Case KI_STL_CODIGO
      Set Row = IProperty.Grid.Rows(lRow)
      If Not Row Is Nothing Then
        pColumnBeforeEdit = pCell(Row, KI_PR_LLEVALOTE).Id
      End If
    
    Case KI_TAR_ID
      Set Row = IProperty.Grid.Rows(lRow)
      
      If Not Row Is Nothing Then
      
        With IProperty.Grid.Columns.Item(cscTarId)
          .HelpFilter = gDB.sqlString("rub_id = " & Val(pCell(Row, KI_RUB_ID).Value) & _
                                      " and tar_plantilla <> 0")
        End With
        
        Dim AbmObj As cABMGeneric
        Set AbmObj = m_ObjAbm
        
        AbmObj.RefreshColumnProperties IProperty, cscTarId
        
        pColumnBeforeEdit = True
      End If
    
    Case Else
      pColumnBeforeEdit = True
  End Select
End Function

Private Function pGetPrecioFromRow(ByVal Row As cIABMGridRow) As Double
  Dim Precio  As Double
  
  With pCell(Row, KI_PRECIO_USR)
    If IsNumeric(.Value) Then
      Precio = CDbl(.Value)
    Else
      Precio = 0
    End If
  End With
  
  pGetPrecioFromRow = Precio
End Function

Private Function pColumnAfterEdit(ByRef IProperty As cIABMProperty, _
                                  ByVal lRow As Long, _
                                  ByVal lCol As Long, _
                                  ByVal NewValue As Variant, _
                                  ByVal NewValueID As Long) As Boolean
  Dim Row     As cIABMGridRow
  
  Select Case IProperty.Grid.Columns(lCol).key
    Case KI_PR_ID
      Set Row = IProperty.Grid.Rows(lRow)
      pSetDataProducto Row, NewValueID
      pSetPrecios Row, NewValueID
      pSetDescuentos Row, NewValueID, pGetPrecioFromRow(Row)
      pSetTasasImpositivas Row, NewValueID, NewValue
      
    Case KI_PRECIO_USR
      Set Row = IProperty.Grid.Rows(lRow)
      pSetDescuentos Row, pCell(Row, KI_PR_ID).Id, NewValue
      
    Case KI_CANTIDAD
      
      Set Row = IProperty.Grid.Rows(lRow)
      
      If pCell(Row, KI_PR_LLEVANROSERIE).Id Then
      
        Dim PrId As Long
        
        PrId = pCell(Row, KI_PR_ID).Id
      
        If m_TicketConfig.UseAutoNumber Then
          pSetAutoNumber PrId, _
                         Row, _
                         lRow, _
                         Val(NewValue)
        End If
      
        If Not NroSerieCantidadChanged(Row, _
                                       lRow, _
                                       KI_CANTIDAD, _
                                       NewValue, _
                                       KI_GRUPO, _
                                       m_NrosSerie, _
                                       KI_PR_ID, _
                                       KI_NROSERIE, _
                                       PrId, _
                                       pGetDeplId(), _
                                       pGetIsInput(), _
                                       pGetCliId()) Then Exit Function
      End If
      
  End Select
  
  pColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  Dim Row As cIABMGridRow
  
  Select Case key
    Case K_ITEMS
      With GetItems(m_Items, c_Items).Grid
        Select Case .Columns(lCol).key
          Case KI_NROSERIE
            Set Row = .Rows(lRow)
            If pCell(Row, KI_PR_LLEVANROSERIE).Id Then
            
              Dim PrId      As Long
              Dim Cantidad  As Long
              
              PrId = pCell(Row, KI_PR_ID).Id
              Cantidad = Val(pCell(Row, KI_CANTIDAD).Value)
              
              If m_TicketConfig.UseAutoNumber Then
                pSetAutoNumber PrId, _
                               Row, _
                               lRow, _
                               Cantidad
              End If
            
              ' nrs devolucion
              cIABMClientGrid_ColumnButtonClick = EditNroSerieINPUT(pCell(Row, KI_GRUPO).Id, _
                                                                    Cantidad, _
                                                                    Row, _
                                                                    m_NrosSerie, _
                                                                    KI_GRUPO, _
                                                                    KI_NROSERIE, _
                                                                    lRow, _
                                                                    PrId, _
                                                                    pGetDeplId(), _
                                                                    pGetIsInput(), _
                                                                    False, Nothing, _
                                                                    pGetCliId, csNO_ID)
            End If
        End Select
      End With
  End Select
End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Id = Val(pCell(Row, KI_OSI_ID).Value)
  
  If Id <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & Id & ","
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case key
    Case K_ITEMS
      cIABMClientGrid_ValidateRow = pValidateRow(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pIsEmptyRow(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.key
      Case KI_CANTIDAD
        If Not ValEmpty(Cell.Value, csDouble) Then
          If Val(Cell.Value) <> 1 Then
            bRowIsEmpty = False
            Exit For
          End If
        End If
      Case KI_PRECIO
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_PR_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRow = bRowIsEmpty
End Function

Private Function pValidateRow(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bLlevaNroSerie        As Boolean
  Dim Cantidad              As Double
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.key
      Case KI_CANTIDAD
        Cantidad = Val(Cell.Value)
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(1365, vbNullString, strRow) 'Debe indicar una cantidad (1)
          Exit Function
        End If

      Case KI_PR_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(1565, vbNullString, strRow) 'Debe indicar un producto de venta (1)
          Exit Function
        End If
      
      Case KI_NROSERIE
        bLlevaNroSerie = pCell(Row, KI_PR_LLEVANROSERIE).Id
        'If ValEmpty(Cell.Value, csText) And bLlevaNroSerie Then
        '  MsgInfo "Debe indicar un numero de serie" & strRow
        '  Exit Function
        'End If
      
      ' Lote
      '
      Case KI_STL_CODIGO
        If m_bShowStockData Then
          If ValEmpty(Cell.Value, csText) And _
             pCell(Row, KI_PR_LLEVALOTE).Id Then
            MsgInfo LNGGetText(1632, vbNullString, strRow) 'Debe indicar un lote (1)
            Exit Function
          End If
        End If
    End Select
  Next
  
  ' Si lleva numero de serie valido que
  ' la cantidad indicada sea la misma
  ' que en la coleccion de numeros de serie
  '
  If bLlevaNroSerie Then
  
    Dim PrId As Long
    
    PrId = pCell(Row, KI_PR_ID).Id
  
    If Not NroSerieValidateCount3Ex(Row, _
                                    KI_GRUPO, _
                                    RowIndex, _
                                    m_NrosSerie, _
                                    Cantidad, _
                                    strRow, _
                                    KI_PR_ID, _
                                    KI_CANTIDAD, _
                                    KI_NROSERIE, _
                                    PrId, _
                                    pGetDeplId(), _
                                    pGetIsInput(), False, True) Then
      Exit Function
    End If
  End If
  
  pValidateRow = True
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim Filter  As String
  Dim c       As cIABMProperty
#If PREPROC_SFS Then
  Dim AbmGen  As cABMGeneric
#Else
  Dim AbmGen  As cABMGenericDocEx
#End If
  
  ' Preferencias del usuario
  '
  Dim bValidateDocDefault As Boolean
  
  Set AbmGen = m_ObjAbm
  AbmGen.ResetLayoutMembers
  AbmGen.SendNewDoc = m_UserCfg.NuevoAlGrabar

  ' DATADD
  If m_UserCfg.ShowDataAddInVentas Then
    AbmGen.SetHeightToDocWithDescrip
  End If

  With m_ObjAbm.Tabs
    .Clear
    With .Add(Nothing)
      .name = C_strGeneral
      .Index = 0
    End With
    With .Add(Nothing)
      .name = LNGGetText(1566, vbNullString)  'Adicionales
      .Index = 1
    End With
  End With

  With m_ObjAbm.Properties
  
    .Clear
  
    With .Add(Nothing, cscDocId)
      .PropertyType = cspHelp
      .table = CSDocumento2.CSDocumento
      .name = LNGGetText(1567, vbNullString)  'Documento
      .key = K_DOC_ID
      
      If m_doc_id <> csNO_ID Then
        .HelpId = m_doc_id
        .Value = m_Documento
      Else
        ' Preferencias del usuario
        '
        .HelpId = m_UserCfg.DocOsId
        .Value = m_UserCfg.DocOsNombre
        
        bValidateDocDefault = .HelpId <> csNO_ID
      End If
      
      .HelpFilter = pGetDocFilter
    End With
    
    With .Add(Nothing, csDocNumberID)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .name = LNGGetText(1065, vbNullString)  'Número
      .key = K_NUMERO
      .Value = m_Numero
      .Enabled = False
    End With
    
    With .Add(Nothing, csDocEstateID)
      .PropertyType = cspText
      .name = LNGGetText(1568, vbNullString)  'Estado
      .key = K_EST_ID
      .Value = m_Estado
      .Enabled = False
    End With
    
    With .Add(Nothing, cscOsFecha)
      .PropertyType = cspDate
      .name = LNGGetText(1569, vbNullString)  'Fecha
      .LeftLabel = -580
      .Left = 700
      .key = K_FECHA
      .Value = m_Fecha
    End With
    
    With .Add(Nothing, cscOsHora)
      .PropertyType = cspTime
      .name = LNGGetText(1832, vbNullString)  'Hora
      .key = K_HORA
      .Value = Format$(m_Hora / 100, "00") & ":" & Format$(m_Hora Mod 100, "00")
    End With
    
    With .Add(Nothing, cscCliId)
      .PropertyType = cspHelp
      .table = csCliente
      .TopFromProperty = cscOsFecha
      .Left = 2900
      .LeftLabel = -600
      .name = LNGGetText(1150, vbNullString)  'Cliente
      .key = K_CLI_ID
      .HelpId = m_cli_id
      .Value = m_Cliente
      AbmGen.NewKeyPropFocus = cscCliId
    
      ' CLI-WIDTH
      .Width = 5620
    End With
    
    With .Add(Nothing, cscOsNrodoc)
      .PropertyType = cspText
      .name = LNGGetText(1065, vbNullString)  'Número
      .Size = 50
      .key = K_NRODOC
      .Value = m_Nrodoc
      .TextMask = m_TaMascara
      .TextAlign = vbRightJustify
    End With
    
    With .Add(Nothing, cscContId)
      .PropertyType = cspHelp
      .table = csContacto
      .LeftLabel = -950
      .name = LNGGetText(1035, vbNullString)  'Contacto
      .key = K_CONT_ID
      .HelpId = m_cont_id
      .Value = m_contacto
      .TopFromProperty = cscOsFecha
      .TopToPrevious = 440
      .HelpFilter = "cli_id = " & m_cli_id
      .Left = 6250
    End With
    
    With .Add(Nothing, cscClisId)
      .PropertyType = cspHelp
      .table = csSucursalCliente
      .name = LNGGetText(1833, vbNullString)  'Suc./Depto.
      .LeftLabel = -950
      .key = K_CLIS_ID
      .Value = m_clienteSuc
      .HelpId = m_clis_id
      .HelpFilter = "cli_id = " & m_cli_id
    End With
    
    With .Add(Nothing, cscDeplIdOrigen)
      .PropertyType = cspHelp
      .table = csDepositoLogico
      .LeftLabel = -950
      .name = LNGGetText(1574, vbNullString)  'Deposito
      .key = K_DEPL_ID
      
      If m_depl_id <> csNO_ID Or Not m_bShowStockData Then
        .HelpId = m_depl_id
        .Value = m_deposito
      Else
        ' Preferencias del usuario
        '
        .HelpId = IIf(m_UserCfg.DeplIdSrv, m_UserCfg.DeplIdSrv, m_UserCfg.DeplId)
        .Value = IIf(m_UserCfg.DeplIdSrv, m_UserCfg.DeplNombreSrv, m_UserCfg.DeplNombre)
      End If
      
      .Enabled = m_bShowStockData
    End With
    
    With .Add(Nothing, cscProyId)
      .PropertyType = cspHelp
      .table = csProyecto
      .name = LNGGetText(1834, vbNullString)  'Proyecto/ & vbCrLf & Contrato
      .LeftLabel = -750
      .key = K_PROY_ID
      .Value = m_Proyecto
      .HelpId = m_Proy_id
      .HelpFilter = "'cli_id = " & m_cli_id & "'"
      .TopFromProperty = cscOsFecha
      .Left = 9500
    End With
    
    With .Add(Nothing, cscPrioId)
      .PropertyType = cspHelp
      .table = csPrioridad
      .name = LNGGetText(1825, vbNullString)  'Prioridad
      .LeftLabel = -750
      .key = K_PRIO_ID
      .Value = m_Prioridad
      .HelpId = m_Prio_id
    End With
    
    With .Add(Nothing, cscIncaId)
      .PropertyType = cspHelp
      .table = csIncidenteApertura
      .name = LNGGetText(1744, vbNullString)  'Apertura
      .LeftLabel = -750
      .key = K_INCA_ID
      .Value = m_IncidenteApertura
      .HelpId = m_inca_id
    End With
    
    With .Add(Nothing, cscInctId)
      .PropertyType = cspHelp
      .table = csIncidenteTipo
      .name = LNGGetText(1223, vbNullString)  'Tipo
      .LeftLabel = -750
      .key = K_INCT_ID
      .Value = m_IncidenteTipo
      .HelpId = m_inct_id
    End With
    
    With .Add(Nothing, cscOsFechaentrega)
      .PropertyType = cspDate
      .name = LNGGetText(1570, vbNullString)  'Entrega
      .key = K_FECHAENTREGA
      .Value = m_Fechaentrega
      .LeftLabel = -650
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscCpgId)
      .PropertyType = cspHelp
      .table = csCondicionPago
      .name = LNGGetText(1835, vbNullString)  'C. pago
      .LeftLabel = -650
      .key = K_CPG_ID
      .HelpId = m_cpg_id
      .Value = m_CondicionPago
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscOsCotizacion)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .LeftLabel = -600
      .name = LNGGetText(1650, vbNullString)  'Cotiz.
      .Format = m_GeneralConfig.FormatDecCotizacion
      .key = K_COTIZACION
      .Value = m_Cotizacion
      .Width = 1000
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscOsDescuento1)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .LeftLabel = -650
      .name = LNGGetText(1573, vbNullString)  'Desc. 1
      .key = K_DESCUENTO1
      .Value = m_Descuento1
      .Width = 1000
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscOsDescuento2)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .TopFromProperty = cscOsDescuento1
      .Left = 2250
      .LeftLabel = -150
      .name = "2"
      .key = K_DESCUENTO2
      .Value = m_Descuento2
      .Width = 1000
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscLpId)
      .PropertyType = cspHelp
      .table = csListaPrecio
      .name = LNGGetText(1397, vbNullString)  'Lista de Precios
      .HelpFilter = GetListaPrecioGetXCliente(m_doc_id, m_cli_id)
      .TopFromProperty = cscOsFecha
      .Left = 4800
      .key = K_LP_ID
      .HelpId = m_Lp_id
      .Value = m_ListaPrecio
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscLdId)
      .PropertyType = cspHelp
      .table = csListaDescuento
      .name = LNGGetText(1398, vbNullString)  'Lista de Descuentos
      .HelpFilter = GetListaDescGetXCliente(m_doc_id, m_cli_id)
      .key = K_LD_ID
      .HelpId = m_Ld_id
      .Value = m_ListaDescuento
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscCcosId)
      .PropertyType = cspHelp
      .table = csCentroCosto
      .name = LNGGetText(1057, vbNullString)  'Centro de Costo
      .key = K_CCOS_ID
      .HelpId = m_ccos_id
      .Value = m_CentroCosto
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscSucId)
      .PropertyType = cspHelp
      .table = csSucursal
      .name = LNGGetText(1281, vbNullString)  'Sucursal
      .key = K_SUC_ID
      .HelpId = m_suc_id
      .Value = m_Sucursal
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscOsDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .name = LNGGetText(1211, vbNullString)  'Observ.
      .LeftLabel = -600
      .Size = 5000
      .key = K_DESCRIP
      .Value = m_Descrip
      .LeftFromProperty = cscOsFecha
      .TopFromProperty = cscOsNrodoc
      .Width = 4450
      .Height = 800
      .TopToPrevious = 440
    End With
  
    With .Add(Nothing, cscLgjId)
      .PropertyType = cspHelp
      .table = csLegajo
      .name = LNGGetText(1575, vbNullString)  'Legajo
      .key = K_LGJ_ID
      .HelpId = m_lgj_id
      .Value = m_Legajo
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscZonId)
      .PropertyType = cspHelp
      .table = csZona
      .name = LNGGetText(1402, vbNullString)  'Zona
      .key = K_ZON_ID
      .HelpId = m_zon_id
      .Value = m_zona
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscUsIdTecnico)
      .PropertyType = cspHelp
      .table = csUsuario
      .name = LNGGetText(1846, vbNullString)  'Tecnico
      .key = K_US_ID_TECNICO
      .HelpId = m_us_id_tecnico
      .Value = m_tecnico
      .TabIndex = 1
    End With
  
    ' DATADD
    If m_UserCfg.ShowDataAddInVentas Then
    
      With .Add(Nothing, c_ClienteDataAdd)
        .PropertyType = cspText
        .SubType = cspMemo
        .Width = 10970
        .TopFromProperty = cscOsDescrip
        .TopToPrevious = 860
        .LeftFromProperty = cscOsDescrip
        .Height = 600
      End With
    
    End If
  
    ' HIDECOLS
    '
    With .Add(Nothing)
      .PropertyType = cspLabel
      .BackColor = vbButtonShadow
      .Width = 2540
      .TopNotChange = True
      .LeftNotChange = True

      ' DATADD
      ' Aca van las preferencias del usuario
      '
      If m_UserCfg.ShowDataAddInVentas Then
        .Top = 4000
      Else
        .Top = 3460
      End If

      .Left = 9210
      .Height = 330
    End With
    
    With .Add(Nothing)
      .PropertyType = cspLabel
      .BackColor = vbWindowBackground
      .Width = 2500
      .TopNotChange = True
      .LeftNotChange = True

      ' DATADD
      ' Aca van las preferencias del usuario
      '
      If m_UserCfg.ShowDataAddInVentas Then
        .Top = 4020
      Else
        .Top = 3480
      End If

      .Left = 9220
      .Height = 300
    End With
  
    Dim iProp As cIABMProperty
    Dim oProp As cABMProperty
    Set iProp = .Add(Nothing, c_HideCols)
    Set oProp = iProp
    With iProp
      .PropertyType = cspCheck
      .name = LNGGetText(3901, vbNullString)  'Ocultar Columnas
      .key = K_HIDECOLS
      .Value = CInt(CSKernelClient2.GetRegistry(csInterface, c_HideColsOs, 1))
      .TopNotChange = True
      .LeftNotChange = True

      ' DATADD
      ' Aca van las preferencias del usuario
      '
      If m_UserCfg.ShowDataAddInVentas Then
        .Top = 4040
      Else
        .Top = 3500
      End If

      .Left = 11120
      .LeftLabel = -1500
    End With
    oProp.IsEditProperty = False
    '
    ' HIDECOLS - fin
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  pSetShowStockData
  
  With m_Items.Tabs
  
    .Clear
    
    With .Add(Nothing)
      .Index = 0
      .name = LNGGetText(1371, vbNullString)  'Items
    End With
  
  End With
  
  Set AbmGen = m_Items
  AbmGen.ResetLayoutMembers
  
  ' DATADD
  If m_UserCfg.ShowDataAddInVentas Then
    AbmGen.SetHeightToDocWithDescrip
  End If
  
  With m_Items.Properties
  
    .Clear
  
    Set c = .Add(Nothing, c_Items)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItems(c) Then Exit Function
      .name = c_Items
      .key = K_ITEMS
      .TabIndex = 0
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
  End With
  
  m_ItemsDeleted = vbNullString
  
  If Not m_Items.Show(Me) Then Exit Function
  
  Set AbmGen = m_Footer
  AbmGen.ResetLayoutMembers
  
  With m_Footer.Properties
  
    .Clear
    
    With .Add(Nothing, cscOsSubtotal)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .name = LNGGetText(1579, vbNullString)  'Sub Total
      .key = K_SUBTOTAL
      .Value = m_SubTotal
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscOsImportedesc1)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .name = LNGGetText(1573, vbNullString)  'Desc. 1
      .key = K_IMPORTEDESC1
      .Value = m_ImporteDesc1
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscOsImportedesc2)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .name = LNGGetText(1580, vbNullString)  'Desc. 2
      .key = K_IMPORTEDESC2
      .Value = m_ImporteDesc2
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscOsNeto)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .name = LNGGetText(1581, vbNullString)  'Neto
      .key = K_NETO
      .Value = m_Neto
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscOsIvari)
      .PropertyType = cspNumeric
      .name = LNGGetText(1582, vbNullString)  'IVA RI
      .SubType = cspMoney
      .key = K_IVARI
      .Value = m_Ivari
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscOsIvarni)
      .PropertyType = cspNumeric
      .name = LNGGetText(1583, vbNullString)  'IVA RNI
      .SubType = cspMoney
      .key = K_IVARNI
      .Value = m_Ivarni
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscOsTotal)
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .name = LNGGetText(1584, vbNullString)  'Total
      .SubType = cspMoney
      .key = K_TOTAL
      .Value = m_Total
      .Enabled = False
    End With
  
  End With
  
  pSetEnabled
  
  If Not m_Footer.Show(Me) Then Exit Function
  
  ' Preferencias del Usuario
  '
  If bValidateDocDefault Then
    cIABMClient_PropertyChange K_DOC_ID
  End If
  
  pShowCotizacion

  ' DATADD
  ShowDataAddCliente m_UserCfg.ShowDataAddInVentas, _
                     m_ObjAbm

  AbmGen.SetIconFormDoc 4

  'c8f6c1
  If m_UserCfg.UsarColoresEnDocumentos Then
    AbmGen.SetBakcColorTagMain RGB(&HC8, &HF6, &HC1)
  End If

  LoadCollection = True
End Function

Private Function pGetDocFilter() As String
  pGetDocFilter = "'doct_id = " & csEDT_OrdenServicio & _
                  " or doct_id = " & csEDT_DevolucionOrdenCpra & "'"
End Function

' Cotizacion
Private Function pGetCotizacion() As cIABMProperty
  Set pGetCotizacion = m_ObjAbm.Properties.Item(cscOsCotizacion)
End Function

Private Sub pShowCotizacion()
  Dim MonId   As Long
  Dim dDate   As Variant
  Dim iProp   As cIABMProperty
  
  If m_Id = csNO_ID Then
    If m_LastDoc = csNO_ID Then Exit Sub
    If Not gDB.GetData(csTDocumento, cscDocId, m_LastDoc, cscMonId, MonId) Then Exit Sub
  Else
    MonId = m_mon_id
  End If
  
  Set iProp = pGetCotizacion()
  iProp.Visible = MonId <> GetMonedaDefault
  
  If m_lastMonIdCotizacion <> MonId Or iProp.Value = 0 Then
    dDate = pGetFecha()
    If Not IsDate(dDate) Then dDate = Date
    iProp.Value = GetCotizacion(MonId, dDate)
    m_lastFecha = dDate
    m_lastMonIdCotizacion = MonId
  End If
  
  m_ObjAbm.ShowValue iProp
End Sub

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  ' HIDECOLS
  '
  Dim bColVisible As Boolean
  bColVisible = Val(m_ObjAbm.Properties.Item(c_HideCols).Value) = 0
  
  sqlstmt = "sp_DocOrdenServicioGetItems " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
    
      With .Add(Nothing)
        .Visible = False
        .key = KI_OSI_ID
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1367, vbNullString)  'Articulo
        .PropertyType = cspHelp
        .table = csProductoVenta
        .Width = 1800
        .key = KI_PR_ID
        .HelpFilter = "pr_llevanroserie <> 0" & c_filter_is_for_servicios
      End With
      
      With .Add(Nothing)
        .name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 1200
        .key = KI_DESCRIP
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1374, vbNullString)  'Cantidad
        .Format = m_GeneralConfig.FormatDecCantidad
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .key = KI_CANTIDAD
      
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Value = 1
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1639, vbNullString)  'Nro. Serie
        .PropertyType = cspText
        .SubType = cspTextButton
        .Width = 3000
        .key = KI_NROSERIE
      End With
      
      With .Add(Nothing, cscRubId)
        .Visible = False
        .key = KI_RUB_ID
      End With
      
      With .Add(Nothing, cscTarId)
        .name = LNGGetText(1836, vbNullString)  'Tarea
        .PropertyType = cspHelp
        .table = cstblTarea
        .Width = 3000
        .key = KI_TAR_ID
      End With
      
      With .Add(Nothing, cscContId)
        .name = LNGGetText(1035, vbNullString)  'Contacto
        .PropertyType = cspHelp
        .table = csContacto
        .HelpFilter = "cli_id = " & m_cli_id
        .Width = 3000
        .key = KI_CONT_ID
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1837, vbNullString)  'Falla
        .PropertyType = cspHelp
        .table = csEquipoTipoFalla
        .Width = 3000
        .key = KI_ETF_ID
      End With
      
      ' Lote
      '
      With .Add(Nothing)
        .name = LNGGetText(1640, vbNullString)  'Lote
        .PropertyType = cspText
        .Width = 2000
        .key = KI_STL_CODIGO
      End With
      
      With .Add(Nothing)
        .Visible = False
        .key = KI_STL_ID
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1585, vbNullString)  'Descuento
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .key = KI_DESCUENTO
        .Enabled = False
        .Visible = bColVisible ' HIDECOLS
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1165, vbNullString)  'Unidad
        .PropertyType = cspText
        .Width = 1200
        .key = KI_UNIDAD
        .Enabled = False
        .Visible = bColVisible ' HIDECOLS
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1587, vbNullString)  'Precio (LP)
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .key = KI_PRECIO_LP
        .Enabled = False
        .Visible = bColVisible ' HIDECOLS
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1586, vbNullString)  'Precio
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1200
        .Format = m_GeneralConfig.FormatDecImporte
        .key = KI_PRECIO_USR
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1588, vbNullString)  'Precio c/desc.
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1200
        .Format = m_GeneralConfig.FormatDecImporte
        .key = KI_PRECIO
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1581, vbNullString)  'Neto
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .key = KI_NETO
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1582, vbNullString)  'IVA RI
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .key = KI_IVARI
        .Enabled = False
      End With
  
      With .Add(Nothing)
        .name = LNGGetText(1583, vbNullString)  'IVA RNI
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .key = KI_IVARNI
        .Enabled = False
        .Visible = bColVisible ' HIDECOLS
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1228, vbNullString)  'Importe
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .key = KI_IMPORTE
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Visible = False
        .key = KI_IVARIPercent
      End With
      
      With .Add(Nothing)
        .Visible = False
        .key = KI_IVARNIPercent
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1057, vbNullString)  'Centro de Costo
        .PropertyType = cspHelp
        .table = csCentroCosto
        .Width = 1800
        .key = KI_CCOS_ID
        .Visible = bColVisible ' HIDECOLS
      End With
      
      ' Lote
      '
      With .Add(Nothing)
        .Visible = False
        .key = KI_PR_LLEVALOTE
      End With
      
      With .Add(Nothing)
        .Visible = False
        .key = KI_PR_LLEVANROSERIE
      End With
      
      With .Add(Nothing)
        .Visible = False
        .key = KI_GRUPO
      End With
    End With
  
    With .Rows
    
      .Clear
    
      While Not rs.EOF
    
        With .Add(Nothing, rs(cscOsiId).Value)
      
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscOsiId)
            .key = KI_OSI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPrNombreventa)
            .Id = gDB.ValField(rs.Fields, cscPrId)
            .key = KI_PR_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscOsiDescrip)
            .key = KI_DESCRIP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscOsiCantidad)
            .key = KI_CANTIDAD
          End With
          
          With .Add(Nothing)
            .Value = vbNullString
            .key = KI_NROSERIE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscRubId)
            .key = KI_RUB_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscTarNombre)
            .Id = gDB.ValField(rs.Fields, cscTarId)
            .key = KI_TAR_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscContNombre)
            .Id = gDB.ValField(rs.Fields, cscContId)
            .key = KI_CONT_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscEtfNombre)
            .Id = gDB.ValField(rs.Fields, cscEtfId)
            .key = KI_ETF_ID
          End With
          
          ' Lote
          '
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscStlCodigo)
            .key = KI_STL_CODIGO
          End With
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscStlId)
            .key = KI_STL_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscOsiDescuento)
            .key = KI_DESCUENTO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscUnNombre)
            .key = KI_UNIDAD
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscOsiPrecioLista)
            .key = KI_PRECIO_LP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscOsiPrecioUsr)
            .key = KI_PRECIO_USR
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscOsiPrecio)
            .key = KI_PRECIO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscOsiNeto)
            .key = KI_NETO
          End With
      
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscOsiIvari)
            .key = KI_IVARI
          End With
      
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscOsiIvarni)
            .key = KI_IVARNI
          End With
      
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscOsiImporte)
            .key = KI_IMPORTE
          End With
      
          With .Add(Nothing)
            If m_bIva Then
              .Value = gDB.ValField(rs.Fields, "iva_ri_porcentaje")
            Else
              .Value = 0
            End If
            .key = KI_IVARIPercent
          End With
      
          With .Add(Nothing)
            If m_bIvaRni Then
              .Value = gDB.ValField(rs.Fields, "iva_rni_porcentaje")
            Else
              .Value = 0
            End If
            .key = KI_IVARNIPercent
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCcosNombre)
            .Id = gDB.ValField(rs.Fields, cscCcosId)
            .key = KI_CCOS_ID
          End With
          
          ' Lote
          '
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscPrLlevaNroLote)
            .key = KI_PR_LLEVALOTE
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscPrLlevaNroSerie)
            .key = KI_PR_LLEVANROSERIE
          End With
      
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscOsiId)
            .key = KI_GRUPO
          End With
        
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With

  CollClear m_CollEquipoDetalle
  
  Dim NroSerie  As cProductoSerieType
  Dim CurGroup  As Long
  Dim coll      As Collection
  Dim NrosSerie As String
  
  CollClear m_NrosSerie
  
  Set rs = rs.NextRecordset
  
  While Not rs.EOF
    
    ' Si cambie de grupo
    If CurGroup <> gDB.ValField(rs.Fields, cscOsiId) Then
    
      pSetNrosSerieInRow CurGroup, NrosSerie
      NrosSerie = vbNullString
    
      CurGroup = gDB.ValField(rs.Fields, cscOsiId)
      Set coll = New Collection
      m_NrosSerie.Add coll, GetKey(CurGroup)
    End If
    
    ' Guardo el numero de serie
    Set NroSerie = New cProductoSerieType
    With NroSerie
      .Codigo = gDB.ValField(rs.Fields, cscPrnsCodigo)
      .Codigo2 = gDB.ValField(rs.Fields, cscPrnsCodigo2)
      .Codigo3 = gDB.ValField(rs.Fields, cscPrnsCodigo3)
      .descrip = gDB.ValField(rs.Fields, cscPrnsDescrip)
      .FechaVto = gDB.ValField(rs.Fields, cscPrnsFechavto)
      .prns_id = gDB.ValField(rs.Fields, cscPrnsId)
      .pr_id = gDB.ValField(rs.Fields, cscPrId)
      
      'NrosSerie = NrosSerie & .Codigo & _
                         IIf(LenB(.Codigo2), _
                             " | " & .Codigo2, _
                             vbNullString) & ","
      NrosSerie = NrosSerie & .Codigo & ", "
    End With
    
    ' Lo agrego a la bolsa
    coll.Add NroSerie, GetKey(NroSerie.prns_id)
    
    rs.MoveNext
  Wend
  
  pSetNrosSerieInRow CurGroup, NrosSerie
  
  pLoadItems = True
End Function

Private Sub pSetNrosSerieInRow(ByVal CurrGroup As Long, ByVal NroSerie As String)
  Dim Row As cIABMGridRow
  
  If CurrGroup = 0 Then Exit Sub
  
  For Each Row In GetItems(m_Items, c_Items).Grid.Rows
    If pCell(Row, KI_GRUPO).Id = CurrGroup Then
      pCell(Row, KI_NROSERIE).Value = RemoveLastColon(NroSerie)
      Exit Sub
    End If
  Next
End Sub

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "sp_DocOrdenServicioGet " & EmpId & "," & Id & "," & gDB.UserId
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscOsId)
    m_Numero = gDB.ValField(rs.Fields, cscOsNumero)
    m_Nrodoc = gDB.ValField(rs.Fields, cscOsNrodoc)
    m_Descrip = gDB.ValField(rs.Fields, cscOsDescrip)
    m_Fecha = gDB.ValField(rs.Fields, cscOsFecha)
    m_Hora = gDB.ValField(rs.Fields, cscOsHora)
    m_Fechaentrega = gDB.ValField(rs.Fields, cscOsFechaentrega)
    m_Neto = gDB.ValField(rs.Fields, cscOsNeto)
    m_Ivari = gDB.ValField(rs.Fields, cscOsIvari)
    m_Ivarni = gDB.ValField(rs.Fields, cscOsIvarni)
    m_Total = gDB.ValField(rs.Fields, cscOsTotal)
    m_SubTotal = gDB.ValField(rs.Fields, cscOsSubtotal)
    m_Descuento1 = gDB.ValField(rs.Fields, cscOsDescuento1)
    m_Descuento2 = gDB.ValField(rs.Fields, cscOsDescuento2)
    m_ImporteDesc1 = gDB.ValField(rs.Fields, cscOsImportedesc1)
    m_ImporteDesc2 = gDB.ValField(rs.Fields, cscOsImportedesc2)
    
    m_cli_id = gDB.ValField(rs.Fields, cscCliId)
    m_Cliente = gDB.ValField(rs.Fields, cscCliNombre)
    
    m_cont_id = gDB.ValField(rs.Fields, cscContId)
    m_contacto = gDB.ValField(rs.Fields, cscContNombre)
    
    m_zon_id = gDB.ValField(rs.Fields, cscZonId)
    m_zona = gDB.ValField(rs.Fields, cscZonNombre)
    
    m_us_id_tecnico = gDB.ValField(rs.Fields, cscUsIdTecnico)
    m_tecnico = gDB.ValField(rs.Fields, cscUsNombre)
    
    m_ccos_id = gDB.ValField(rs.Fields, cscCcosId)
    m_CentroCosto = gDB.ValField(rs.Fields, cscCcosNombre)
    m_suc_id = gDB.ValField(rs.Fields, cscSucId)
    m_Sucursal = gDB.ValField(rs.Fields, cscSucNombre)
    m_doc_id = gDB.ValField(rs.Fields, cscDocId)
    m_Documento = gDB.ValField(rs.Fields, cscDocNombre)
    m_Doct_id = gDB.ValField(rs.Fields, cscDoctId)
    m_Lp_id = gDB.ValField(rs.Fields, cscLpId)
    m_ListaPrecio = gDB.ValField(rs.Fields, cscLpNombre)
    m_cpg_id = gDB.ValField(rs.Fields, cscCpgId)
    m_CondicionPago = gDB.ValField(rs.Fields, cscCpgNombre)
    m_Ld_id = gDB.ValField(rs.Fields, cscLdId)
    m_ListaDescuento = gDB.ValField(rs.Fields, cscLdNombre)
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)
    m_est_id = gDB.ValField(rs.Fields, cscEstId)
    m_Estado = gDB.ValField(rs.Fields, cscEstNombre)
    m_Firmado = gDB.ValField(rs.Fields, cscOsFirmado)
    m_Cotizacion = gDB.ValField(rs.Fields, cscOsCotizacion)
    
    m_lgj_id = gDB.ValField(rs.Fields, cscLgjId)
    m_Legajo = gDB.ValField(rs.Fields, cscLgjCodigo)

    m_DocEditable = gDB.ValField(rs.Fields, cscDocEditable)
    m_DocEditMsg = gDB.ValField(rs.Fields, cscDoceditMsg)

    m_depl_id = gDB.ValField(rs.Fields, cscDeplId)
    m_deposito = gDB.ValField(rs.Fields, cscDeplNombre)
    
    m_clis_id = gDB.ValField(rs.Fields, cscClisId)
    m_clienteSuc = gDB.ValField(rs.Fields, cscClisNombre)
    
    m_Proy_id = gDB.ValField(rs.Fields, cscProyId)
    m_Proyecto = gDB.ValField(rs.Fields, cscProyNombre)
    
    m_Prio_id = gDB.ValField(rs.Fields, cscPrioId)
    m_Prioridad = gDB.ValField(rs.Fields, cscPrioNombre)
    
    m_inct_id = gDB.ValField(rs.Fields, cscInctId)
    m_IncidenteTipo = gDB.ValField(rs.Fields, cscInctNombre)
    
    m_inca_id = gDB.ValField(rs.Fields, cscIncaId)
    m_IncidenteApertura = gDB.ValField(rs.Fields, cscIncaNombre)
    
    ' Para ver documentos auxiliares
    '
    m_st_id = gDB.ValField(rs.Fields, cscStId)
    
    m_TaPropuesto = gDB.ValField(rs.Fields, cscTa_Propuesto)
    m_TaMascara = gDB.ValField(rs.Fields, cscTa_Mascara)
    
    m_bIva = gDB.ValField(rs.Fields, cscbIvaRi)
    m_bIvaRni = gDB.ValField(rs.Fields, cscbIvaRni)
    
    m_LastDoc = m_doc_id
    m_LastDoctId = m_Doct_id ' nrs devolucion
    m_Lastcli = m_cli_id
    m_LastDocName = m_Documento
    m_LastcliName = m_Cliente

    m_mon_id = gDB.ValField(rs.Fields, cscMonId)
    m_lastMonIdCotizacion = m_mon_id
    m_lastFecha = m_Fecha

  Else
    m_Id = csNO_ID
    m_Numero = 0
    m_Nrodoc = vbNullString
    m_Descrip = vbNullString
    m_Fecha = VDGetDateById(csToday)
    m_Hora = Hour(Now) * 100 + Minute(Now)
    m_Fechaentrega = VDGetDateById(csTomorrow)
    m_Neto = 0
    m_Ivari = 0
    m_Ivarni = 0
    m_Total = 0
    m_SubTotal = 0
    m_Descuento1 = 0
    m_Descuento2 = 0
    m_ImporteDesc1 = 0
    m_ImporteDesc2 = 0
    m_cli_id = csNO_ID
    m_Cliente = vbNullString
    
    m_cont_id = csNO_ID
    m_contacto = vbNullString
    
    m_zon_id = csNO_ID
    m_zona = vbNullString
    
    m_us_id_tecnico = User.Id
    m_tecnico = User.name
    
    m_ccos_id = csNO_ID
    m_CentroCosto = vbNullString
    m_doc_id = csNO_ID
    m_Documento = vbNullString
    m_Doct_id = csNO_ID
    m_Lp_id = csNO_ID
    m_Ld_id = csNO_ID
    m_cpg_id = csNO_ID
    m_CondicionPago = vbNullString
    m_ListaPrecio = vbNullString
    m_ListaDescuento = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_est_id = csNO_ID
    m_Estado = vbNullString
    m_lgj_id = csNO_ID
    m_Legajo = vbNullString
    m_suc_id = User.suc_id
    m_Sucursal = User.Sucursal
    m_Firmado = False
    m_Cotizacion = 0
  
    m_clis_id = csNO_ID
    m_clienteSuc = vbNullString
    
    m_Proy_id = m_TicketConfig.Proy_id
    m_Proyecto = m_TicketConfig.Proyecto
    
    m_Prio_id = 3
    gDB.GetData csTPrioridad, _
                cscPrioId, _
                m_Prio_id, _
                cscPrioNombre, _
                m_Prioridad
    
    m_inct_id = 2
    gDB.GetData csTIncidenteTipo, _
                cscInctId, _
                m_inct_id, _
                cscInctNombre, _
                m_IncidenteTipo
    
    m_inca_id = 3
    gDB.GetData csTIncidenteApertura, _
                cscIncaId, _
                m_inca_id, _
                cscIncaNombre, _
                m_IncidenteApertura
  
    ' Para ver documentos auxiliares
    '
    m_st_id = csNO_ID
    
    m_TaMascara = vbNullString
    m_TaPropuesto = False

    m_depl_id = csNO_ID
    m_deposito = vbNullString
    
    m_doc_id = m_LastDoc
    m_Doct_id = m_LastDoctId ' nrs devolucion
    m_cli_id = m_Lastcli
    m_Cliente = m_LastcliName
    m_Documento = m_LastDocName
  
    m_bIvaRni = False
    m_bIva = False
  
    m_mon_id = csNO_ID
    m_lastMonIdCotizacion = csNO_ID
    m_lastFecha = csNoDate
    
    ' Cotizacion
    If m_doc_id <> csNO_ID Then
      m_Cotizacion = DocGetCotizacion(m_doc_id, m_Fecha)
    End If
    
    DocEditableGet m_doc_id, m_DocEditable, m_DocEditMsg, csPreTickNewOrdenServ
  
  End If

  Load = True
End Function
' construccion - destruccion

Private Property Set cIEditGenericDoc_Footer(ByVal rhs As CSInterfacesABM.cIABMGeneric)
  Set m_Footer = rhs
  
  If rhs Is Nothing Then Exit Property
  
  m_Footer.IsDocument = True
  m_Footer.IsFooter = True
  Set m_Footer.ObjForm = m_ObjAbm.ObjForm
End Property

Private Property Set cIEditGenericDoc_Items(ByVal rhs As CSInterfacesABM.cIABMGeneric)
  Set m_Items = rhs
  
  If rhs Is Nothing Then Exit Property
  
  m_Items.IsDocument = True
  m_Items.IsItems = True
  Set m_Items.ObjForm = m_ObjAbm.ObjForm
End Property

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  
  Dim str_1755    As String
  
  str_1755 = LNGGetText(1755, vbNullString)   'Se&rvicios
  
  Set m_Host = Host
  
  m_Host.Server.AddMenu str_1755, csMenuProyecto, vbNullString, 1, False, False, False, True, False, Nothing
                        '&Ordenes de Servicio
  m_Host.Server.AddMenu LNGGetText(1838, vbNullString), csPreTickListOrdenServ, str_1755, 0, True, False, False, False, False, Me
  
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
#If PREPROC_SFS Then
  m_Host.MenuListDocClick "CSABMInterface2.cABMGeneric", "CSTicket.cOrdenServicio", "CSABMInterface2.cABMGenericListDoc", "CSTicket.cOrdenServicioListDoc", Me, LNGGetText(1830, vbNullString), 0
#Else
  m_Host.MenuListDocClick "CSABMInterface2.cABMGenericDocEx", "CSTicket.cOrdenServicio", "CSABMInterface2.cABMGenericListDoc", "CSTicket.cOrdenServicioListDoc", Me, LNGGetText(1830, vbNullString), 0
#End If                                                                                                                                                               ' Ordenes de Servicio
End Function

Private Function pSaveItems(ByVal Id As Long, _
                            ByVal NroDoc As String) As Boolean
  
  ' Generales
  '
  Dim register    As cRegister
  Dim iOrden      As Long
  Dim Row         As cIABMGridRow
  Dim Cell        As cIABMGridCellValue
  
  ' Para numeros de serie
  '
  Dim iOrden2     As Long
  Dim Grupo       As Long
  Dim PrId        As Long
  
  ' Para lotes
  '
  Dim LoteDespacho As String
  LoteDespacho = pGetDocNroDoc()
  
  For Each Row In GetItems(m_Items, c_Items).Grid.Rows
          
    Set register = New cRegister
    register.fieldId = cscOsiTMPId
    register.table = csTOrdenServicioItemTMP
    register.Id = csNew
    
    For Each Cell In Row
      Select Case Cell.key
        
        Case KI_OSI_ID
          If m_Copy Then
            register.Fields.Add2 cscOsiId, csNew, csInteger
          Else
            register.Fields.Add2 cscOsiId, Val(Cell.Value), csInteger
          End If
        Case KI_CANTIDAD
          register.Fields.Add2 cscOsiCantidad, Cell.Value, csDouble
        Case KI_DESCRIP
          register.Fields.Add2 cscOsiDescrip, Cell.Value, csText
        Case KI_PRECIO
          register.Fields.Add2 cscOsiPrecio, Cell.Value, csCurrency
        Case KI_PRECIO_LP
          register.Fields.Add2 cscOsiPrecioLista, Cell.Value, csCurrency
        Case KI_PRECIO_USR
          register.Fields.Add2 cscOsiPrecioUsr, Cell.Value, csCurrency
        Case KI_IMPORTE
          register.Fields.Add2 cscOsiImporte, Cell.Value, csCurrency
        Case KI_NETO
          register.Fields.Add2 cscOsiNeto, Cell.Value, csCurrency
        Case KI_IVARI
          register.Fields.Add2 cscOsiIvari, Cell.Value, csCurrency
        Case KI_IVARNI
          register.Fields.Add2 cscOsiIvarni, Cell.Value, csCurrency
        Case KI_IVARIPercent
          register.Fields.Add2 cscOsiIvariporc, Cell.Value, csDouble
        Case KI_IVARNIPercent
          register.Fields.Add2 cscOsiIvarniporc, Cell.Value, csDouble
        Case KI_PR_ID
          PrId = Cell.Id
          register.Fields.Add2 cscPrId, PrId, csId
        Case KI_CCOS_ID
          register.Fields.Add2 cscCcosId, Cell.Id, csId
        Case KI_GRUPO
          Grupo = Cell.Id
        
        ' Lote
        '
        Case KI_STL_CODIGO
          register.Fields.Add2 cscStlCodigo, Cell.Value, csText
        
        Case KI_STL_ID
          register.Fields.Add2 cscStlId, Cell.Id, csId
        
        Case KI_TAR_ID
          register.Fields.Add2 cscTarId, Cell.Id, csId
        Case KI_CONT_ID
          register.Fields.Add2 cscContId, Cell.Id, csId
          
        Case KI_ETF_ID
          register.Fields.Add2 cscEtfId, Cell.Id, csId
        
      End Select
    Next
    
    iOrden = iOrden + 1
    register.Fields.Add2 cscOsiOrden, iOrden, csInteger
    register.Fields.Add2 cscOsTMPId, Id, csId
    
    register.Fields.HaveLastUpdate = False
    register.Fields.HaveWhoModify = False
                                                        
    If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
    
    ' Si es nuevo se usa el orden
    If Grupo = 0 Then Grupo = iOrden * -1
    If Not pSaveItemNroSerie(Row, _
                             iOrden2, _
                             PrId, _
                             Id, _
                             register.Id, _
                             Grupo, _
                             NroDoc) Then Exit Function
  Next
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeleted) And m_Id <> csNO_ID And Not m_Copy Then
  
    Dim vDeletes As Variant
    Dim i As Long
    
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    vDeletes = Split(m_ItemsDeleted, ",")
    
    For i = 0 To UBound(vDeletes)
    
      Set register = New cRegister
      register.fieldId = cscOsibTMPId
      register.table = csTOrdenServicioItemBorradoTMP
      register.Id = csNew
      
      register.Fields.Add2 cscOsiId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscOsId, m_Id, csId
      register.Fields.Add2 cscOsTMPId, Id, csId
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
                                                        
      If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveItems = True
End Function

' Reglas del Objeto de Negocios

Private Sub pShowImporteAndIva(ByRef Row As CSInterfacesABM.cIABMGridRow)
  Dim Importe As Double
  Dim Neto    As Double
  Dim IvaRi   As Double
  Dim IvaRni  As Double
  
  Neto = Val(pCell(Row, KI_CANTIDAD).Value) * Val(pCell(Row, KI_PRECIO).Value)
  If m_bIva Then
    IvaRi = (Neto * Val(pCell(Row, KI_IVARIPercent).Value)) / 100
  End If
  If m_bIvaRni Then
    IvaRni = (Neto * Val(pCell(Row, KI_IVARNIPercent).Value)) / 100
  End If
  Importe = Neto + IvaRi + IvaRni
  
  pCell(Row, KI_NETO).Value = Neto
  pCell(Row, KI_IVARI).Value = IvaRi
  pCell(Row, KI_IVARNI).Value = IvaRni
  pCell(Row, KI_IMPORTE).Value = Importe
End Sub
  
Private Sub pShowTotales(ByRef Rows As CSInterfacesABM.cIABMGridRows)
  Dim Neto      As Double
  Dim IvaRi     As Double
  Dim IvaRni    As Double
  Dim Desc1     As Double
  Dim Desc2     As Double
  
  Dim Row       As CSInterfacesABM.cIABMGridRow
  
  For Each Row In Rows
    Neto = Neto + Val(pCell(Row, KI_NETO).Value)
    IvaRi = IvaRi + Val(pCell(Row, KI_IVARI).Value)
    IvaRni = IvaRni + Val(pCell(Row, KI_IVARNI).Value)
  Next
  
  With m_Footer.Properties
    .Item(cscOsSubtotal).Value = Neto
  
    Desc1 = m_ObjAbm.Properties(cscOsDescuento1).Value
    Desc2 = m_ObjAbm.Properties(cscOsDescuento2).Value
    
    IvaRi = IvaRi - (IvaRi * Desc1 / 100)
    IvaRni = IvaRni - (IvaRni * Desc1 / 100)
    
    IvaRi = IvaRi - (IvaRi * Desc2 / 100)
    IvaRni = IvaRni - (IvaRni * Desc2 / 100)
    
    Desc1 = Neto * Desc1 / 100
    .Item(cscOsImportedesc1).Value = Desc1
    
    Neto = Neto - Desc1
    
    Desc2 = Neto * Desc2 / 100
    .Item(cscOsImportedesc2).Value = Desc2
    
    Neto = Neto - Desc2
    
    .Item(cscOsNeto).Value = Neto
    .Item(cscOsIvari).Value = IvaRi
    .Item(cscOsIvarni).Value = IvaRni
    .Item(cscOsTotal).Value = Neto + IvaRni + IvaRi
  End With
  
  m_Footer.RefreshControls
End Sub

Private Sub pSetTasasImpositivas(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal pr_id As Long, ByVal pr_nombre As String)
  Dim ti_ri    As Long
  Dim ti_rni   As Long
  
  If pr_id = 0 Then Exit Sub
  
  If Not GetTasaFromProducto(pr_id, ti_ri, ti_rni, False) Then Exit Sub
  
  If ti_ri = 0 Then
    MsgWarning LNGGetText(1597, vbNullString, pr_nombre)
    'El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de ventas para el iva responsable inscripto
    Exit Sub
  End If
  
  If ti_rni = 0 Then
    MsgWarning LNGGetText(1598, vbNullString, pr_nombre)
    'El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de ventas para el iva responsable no inscripto
    Exit Sub
  End If
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  If m_bIva Then
    sqlstmt = "select ti_porcentaje,cue_id from tasaimpositiva where ti_id = " & ti_ri
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
    
    If Not rs.EOF Then
      pCell(Row, KI_IVARIPercent).Value = gDB.ValField(rs.Fields, cscTiPorcentaje)
    End If
  Else
    pCell(Row, KI_IVARIPercent).Value = 0
  End If
  
  If m_bIvaRni Then
    sqlstmt = "select ti_porcentaje,cue_id from tasaimpositiva where ti_id = " & ti_rni
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
    
    If Not rs.EOF Then
      pCell(Row, KI_IVARNIPercent).Value = gDB.ValField(rs.Fields, cscTiPorcentaje)
    End If
  Else
    pCell(Row, KI_IVARNIPercent).Value = 0
  End If
End Sub

Private Sub pSetDataProducto(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal pr_id As Long)
  Dim sqlstmt  As String
  Dim rs       As Recordset
  
  Dim bChanged As Boolean
  
  bChanged = pr_id <> pCell(Row, KI_PR_ID).Id
  
  sqlstmt = "sp_StockProductoGetData " & pr_id & ",Null," & pGetCliId()
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
    pCell(Row, KI_UNIDAD).Value = gDB.ValField(rs.Fields, "unidadVenta")
  
    pCell(Row, KI_RUB_ID).Value = gDB.ValField(rs.Fields, cscRubId)
  
    ' Si el documento no mueve stock no se exigen los numeros de serie
    '
    If m_bShowStockData Then
      pCell(Row, KI_PR_LLEVANROSERIE).Id = gDB.ValField(rs.Fields, cscPrLlevaNroSerie)
      ' Lote
      '
      pCell(Row, KI_PR_LLEVALOTE).Id = gDB.ValField(rs.Fields, cscPrLlevaNroLote)
    Else
      pCell(Row, KI_PR_LLEVANROSERIE).Id = False
      pCell(Row, KI_PR_LLEVALOTE).Id = False
    End If
  End If

  ' Si cambio el producto borro los numeros de serie
  '
  If bChanged Or pCell(Row, KI_PR_LLEVANROSERIE).Id = 0 Then
      
      pCell(Row, KI_NROSERIE).Value = vbNullString
      If ExistsObjectInColl(m_NrosSerie, GetKey(pCell(Row, KI_GRUPO).Id)) Then
      
        m_NrosSerie.Remove GetKey(pCell(Row, KI_GRUPO).Id)
      End If
  End If
  
  If bChanged Then
  
    ' Busco una tarea para este rubro
    '
    sqlstmt = "select tar_id,tar_nombre from Tarea where rub_id = " & Val(pCell(Row, KI_RUB_ID).Value) & _
                                      " and tar_plantilla <> 0"
                                      
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
    
    If Not rs.EOF Then
      With pCell(Row, KI_TAR_ID)
        .Value = gDB.ValField(rs.Fields, "tar_nombre")
        .Id = gDB.ValField(rs.Fields, "tar_id")
      End With
    End If
  End If
  
End Sub

Private Sub pSetPrecios(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal pr_id As Long)
  Dim LP        As cListaPrecio
  Dim lp_id     As Long
  Dim Precio    As Double
  
  lp_id = m_ObjAbm.Properties(cscLpId).HelpId
    
  If lp_id <> 0 Then
    Set LP = New cListaPrecio
    Precio = LP.GetPrecio(lp_id, pr_id)
  End If
  
  pCell(Row, KI_PRECIO_LP).Value = Precio
  pCell(Row, KI_PRECIO_USR).Value = Precio
End Sub

Private Sub pSetDescuentos(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal pr_id As Long, ByVal Precio As Double)
  Dim LD        As cListaDescuento
  Dim ld_id     As Long
  Dim Descuento As String
  
  ld_id = m_ObjAbm.Properties(cscLdId).HelpId
  
  If ld_id <> 0 Then
    Set LD = New cListaDescuento
    Precio = LD.GetPrecio(ld_id, pr_id, Precio)
    Descuento = LD.GetDescuentoStr(ld_id, pr_id)
  End If
  
  pCell(Row, KI_PRECIO).Value = Precio
  pCell(Row, KI_DESCUENTO).Value = Descuento
End Sub

Private Sub pSetEnabled()
  Dim bState As Boolean
  
  If m_DocEditable Then
    bState = m_ObjAbm.Properties.Item(cscDocId).HelpId <> csNO_ID
  Else
    bState = False
  End If
  
  pSetEnabledAux bState
End Sub

Private Sub pSetEnabledAux(ByVal bState As Boolean)
  Dim Prop   As cIABMProperty
  
  For Each Prop In m_ObjAbm.Properties
                                                                              ' HIDECOLS
    If Prop.key <> K_DOC_ID And Prop.key <> K_NUMERO And Prop.key <> K_EST_ID And Prop.key <> K_HIDECOLS Then
    
      If bState Then
        If Prop.key <> K_NRODOC Then
          Prop.Enabled = bState
        Else
          Prop.Enabled = m_TaPropuesto
        End If
      Else
        Prop.Enabled = False
      End If
    End If
  Next
  
  If bState Then
    With m_ObjAbm.Properties
      .Item(cscDeplIdOrigen).Enabled = m_bShowStockData
    End With
  End If
  
  For Each Prop In m_Items.Properties
    Prop.Enabled = bState
  Next
  
#If PREPROC_SFS Then
  Dim AbmGen  As cABMGeneric
#Else
  Dim AbmGen  As cABMGenericDocEx
#End If

  Set AbmGen = m_Items
  AbmGen.RefreshEnabledState m_Items.Properties

  Set AbmGen = m_ObjAbm
  AbmGen.RefreshEnabledState m_ObjAbm.Properties

End Sub

Private Sub pSetDatoscliente()
  Dim lp_id       As Long
  Dim ld_id       As Long
  Dim cpg_id      As Long
  Dim cpg_nombre  As String
  Dim LP          As cListaPrecio
  Dim LD          As cListaDescuento
  Dim iProp       As cIABMProperty
  Dim Filter      As String
  
  With pGetCliente()
    If m_Lastcli = .HelpId Then
      Exit Sub
    End If
    m_Lastcli = .HelpId
  End With

  If Not GetClienteDataEx2(m_Lastcli, lp_id, ld_id, cpg_id, _
                           0, 0, 0, _
                           vbNullString, vbNullString, vbNullString, m_LastDoc) Then Exit Sub

  ' Condicion de pago
  If cpg_id <> csNO_ID Then
    
    If Not gDB.GetData(csTCondicionPago, cscCpgId, cpg_id, cscCpgNombre, cpg_nombre) Then Exit Sub
    
    Set iProp = m_ObjAbm.Properties.Item(cscCpgId)
    iProp.Value = cpg_nombre
    iProp.HelpId = cpg_id
    m_ObjAbm.ShowValue iProp
  End If
  
  ' Lista de precios
  Set iProp = m_ObjAbm.Properties.Item(cscLpId)
  iProp.HelpFilter = GetListaPrecioGetXCliente(m_LastDoc, m_Lastcli)
  
  If lp_id <> csNO_ID Then
    Set LP = New cListaPrecio
    iProp.Value = LP.GetData(lp_id, cscLpNombre, csText)
    iProp.HelpId = lp_id
  End If
  
  m_ObjAbm.ShowValue iProp
  
  ' Lista de descuentos
  Set iProp = m_ObjAbm.Properties.Item(cscLdId)
  iProp.HelpFilter = GetListaDescGetXCliente(m_LastDoc, m_Lastcli)
  
  If ld_id <> csNO_ID Then
    Set LD = New cListaDescuento
    iProp.Value = LD.GetData(ld_id, cscLdNombre, csText)
    iProp.HelpId = ld_id
  End If
  
  ' Talonario y Categoria fiscal
  pGetIvaFromcliente m_Lastcli
  
  m_ObjAbm.ShowValue iProp
End Sub

Private Sub pGetIvaFromcliente(ByVal cli_id As Long)
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  Dim bIvaChanged As Boolean
  Dim bLastIva    As Boolean
  
  sqlstmt = "sp_clienteGetIva " & cli_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  bLastIva = m_bIva
  m_bIva = gDB.ValField(rs.Fields, "bIva")
  If bLastIva <> m_bIva Then bIvaChanged = True
  
  bLastIva = m_bIvaRni
  m_bIvaRni = gDB.ValField(rs.Fields, "bIvaRni")
  If bLastIva <> m_bIvaRni Then bIvaChanged = True
  
  If bIvaChanged Then
    pShowTotales GetItems(m_Items, c_Items).Grid.Rows
  End If
End Sub

Private Function pFirmar() As Boolean
  Dim Doc     As cDocumento
  Dim Us_id   As Long
  
  Set Doc = New cDocumento
  
  If m_Id = csNO_ID Then
    MsgWarning LNGGetText(1592, vbNullString) 'Antes de poder firmar el documento debe guardarlo.
    Exit Function
  End If
  
  If m_Firmado Then
    If Not Ask(LNGGetText(1593, vbNullString), vbYes, LNGGetText(1594, vbNullString)) Then
                'El documento ya ha sido firmado desea borrar la firma, Firmar
      Exit Function
    End If
  End If
  
  If Not Doc.Firmar(m_doc_id, Us_id) Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocOrdenServicioFirmar " & m_Id & "," & Us_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_est_id = gDB.ValField(rs.Fields, cscEstId)
  m_Estado = gDB.ValField(rs.Fields, cscEstNombre)
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties(csDocEstateID)
  
  With iProp
    .HelpId = m_est_id
    .Value = m_Estado
  End With
  
  gDB.GetData csTOrdenServicio, cscOsId, m_Id, cscOsFirmado, m_Firmado
  
  m_ObjAbm.ShowValue iProp
  
  pFirmar = True
End Function

Private Function pMove(ByVal MoveTo As ABM_MSG) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim doc_id  As Long
  
  doc_id = m_ObjAbm.Properties(cscDocId).HelpId
  
  If doc_id = csNO_ID Then MsgInfo LNGGetText(1595, vbNullString) 'Debe seleccionar un documento
  
  sqlstmt = "sp_DocOrdenServicioMover " & MoveTo & "," & m_Numero & "," & doc_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  ' Si no obtuve ningun id al moverme
  '
  If rs.EOF Then
    
    Select Case MoveTo
      
      ' Si era siguiente ahora busco el ultimo
      '
      Case MSG_DOC_NEXT
        pMove MSG_DOC_LAST
      
      ' Si era anterior ahora busco el primero
      '
      Case MSG_DOC_PREVIOUS
        pMove MSG_DOC_FIRST
      
      ' Si no encontre ni ultimo ni primero
      ' es por que no hay ningun comprobante para
      ' este documento
      '
      Case MSG_DOC_FIRST, MSG_DOC_LAST
        
        ' Limpio incluso el ultimo cliente
        '
        m_Lastcli = csNO_ID
        m_LastcliName = vbNullString
        
        ' Cargo un registro vacio
        '
        Load csNO_ID
        
        ' Refresco el formulario
        '
        pRefreshProperties
    
        ' Obtengo un nuevo numero de comprobante
        '
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscOsNrodoc
    
    End Select
    
  Else
    If Not Load(gDB.ValField(rs.Fields, 0)) Then Exit Function
    
    pRefreshProperties
  End If
  
  pMove = True
End Function

Private Sub pRefreshProperties()
  Dim c       As cIABMProperty
#If PREPROC_SFS Then
  Dim AbmGen  As cABMGeneric
#Else
  Dim AbmGen  As cABMGenericDocEx
#End If
  Dim Filter  As String
  
  With m_ObjAbm.Properties
    
    Set c = .Item(cscDocId)
    c.HelpId = m_doc_id
    c.Value = m_Documento
    
    Set c = .Item(cscOsFecha)
    c.Value = m_Fecha
    
    Set c = .Item(cscOsHora)
    c.Value = Format$(m_Hora / 100, "00") & ":" & Format$(m_Hora Mod 100, "00")
    
    Set c = .Item(cscOsFechaentrega)
    c.Value = m_Fechaentrega
    
    Set c = .Item(cscCliId)
    c.HelpId = m_cli_id
    c.Value = m_Cliente
    
    Set c = .Item(cscContId)
    c.HelpId = m_cont_id
    c.Value = m_contacto
    c.HelpFilter = "cli_id = " & m_cli_id
    
    Set c = .Item(csDocNumberID)
    c.Value = m_Numero
    
    Set c = .Item(csDocEstateID)
    c.Value = m_Estado
    
    Set c = .Item(cscOsNrodoc)
    c.Value = m_Nrodoc
    c.TextAlign = vbRightJustify
    
    Set c = .Item(cscOsDescuento1)
    c.Value = m_Descuento1
    
    Set c = .Item(cscOsDescuento2)
    c.Value = m_Descuento2
    
    Set c = .Item(cscCpgId)
    c.HelpId = m_cpg_id
    c.Value = m_CondicionPago
    
    Set c = .Item(cscOsCotizacion)
    c.Value = m_Cotizacion
    
    Set c = .Item(cscDeplIdOrigen)
    If m_depl_id <> csNO_ID Or Not m_bShowStockData Then
      c.HelpId = m_depl_id
      c.Value = m_deposito
    Else
      ' Preferencias del usuario
      '
      c.HelpId = IIf(m_UserCfg.DeplIdSrv, m_UserCfg.DeplIdSrv, m_UserCfg.DeplId)
      c.Value = IIf(m_UserCfg.DeplIdSrv, m_UserCfg.DeplNombreSrv, m_UserCfg.DeplNombre)
    End If
    
    Set c = .Item(cscClisId)
    c.HelpId = m_clis_id
    c.Value = m_clienteSuc
    c.HelpFilter = "cli_id = " & m_cli_id
    
    Set c = .Item(cscProyId)
    c.HelpId = m_Proy_id
    c.Value = m_Proyecto
    c.HelpFilter = "'cli_id = " & m_cli_id & "'"
    
    Set c = .Item(cscPrioId)
    c.HelpId = m_Prio_id
    c.Value = m_Prioridad
    
    Set c = .Item(cscInctId)
    c.HelpId = m_inct_id
    c.Value = m_IncidenteTipo
    
    Set c = .Item(cscIncaId)
    c.HelpId = m_inca_id
    c.Value = m_IncidenteApertura
    
    Set c = .Item(cscLpId)
    c.HelpFilter = GetListaPrecioGetXCliente(m_doc_id, m_cli_id)
    c.HelpId = m_Lp_id
    c.Value = m_ListaPrecio
    
    Set c = .Item(cscLdId)
    c.HelpFilter = GetListaDescGetXCliente(m_doc_id, m_cli_id)
    c.HelpId = m_Ld_id
    c.Value = m_ListaDescuento
    
    Set c = .Item(cscCcosId)
    c.HelpId = m_ccos_id
    c.Value = m_CentroCosto
    
    Set c = .Item(cscSucId)
    c.HelpId = m_suc_id
    c.Value = m_Sucursal
    
    Set c = .Item(cscLgjId)
    c.HelpId = m_lgj_id
    c.Value = m_Legajo
    
    Set c = .Item(cscZonId)
    c.HelpId = m_zon_id
    c.Value = m_zona
    
    Set c = .Item(cscUsIdTecnico)
    c.HelpId = m_us_id_tecnico
    c.Value = m_tecnico
    
    Set c = .Item(cscOsDescrip)
    c.Value = m_Descrip
    
  End With
  
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValues m_ObjAbm.Properties
  AbmGen.ResetChanged
  
  Set c = GetItems(m_Items, c_Items)
  If Not pLoadItems(c) Then Exit Sub
  
  m_ItemsDeleted = vbNullString
  
  Set AbmGen = m_Items
  AbmGen.ShowValues m_Items.Properties
  
  With m_Footer.Properties
  
    Set c = .Item(cscOsSubtotal)
    c.Value = m_SubTotal
    
    Set c = .Item(cscOsImportedesc1)
    c.Value = m_ImporteDesc1
    
    Set c = .Item(cscOsImportedesc2)
    c.Value = m_ImporteDesc2
    
    Set c = .Item(cscOsNeto)
    c.Value = m_Neto
    
    Set c = .Item(cscOsIvari)
    c.Value = m_Ivari
    
    Set c = .Item(cscOsIvarni)
    c.Value = m_Ivarni
    
    Set c = .Item(cscOsTotal)
    c.Value = m_Total
  
  End With
  
  Set AbmGen = m_Footer
  AbmGen.ShowValues m_Footer.Properties
  
  pSetEnabled

  pShowCotizacion

  ' DATADD
  ShowDataAddCliente m_UserCfg.ShowDataAddInVentas, _
                     m_ObjAbm

End Sub

Private Sub pShowApply()
  
  If Not DocSecurityCanAccess(csPreVtaModifyAplic, m_doc_id, csEDocTPreAplicar) Then Exit Sub
  
  If m_ObjApply Is Nothing Then
    Set m_ObjApply = New cOrdenServicioAplic
  
  ' Edit Apply
  '
  Else
    If m_ObjApply.Id <> m_Id Then
      Set m_ObjApply.ObjectClient = Nothing
      Set m_ObjApply = New cOrdenServicioAplic
    End If
  End If

  ' Edit Apply
  '
  Set m_ObjApply.ObjectClient = Me
  
  If Not m_ObjApply.Show(m_Id, _
                         m_Total, _
                         m_Nrodoc, _
                         m_cli_id, _
                         m_Cliente, _
                         m_suc_id, _
                         m_doc_id) Then
    Set m_ObjApply = Nothing
  End If
End Sub

' Construccion - Destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
    
  c_ErrorSave = LNGGetText(1839, vbNullString)  'Error al grabar la Orden de Servicio
    
  Set m_NrosSerie = New Collection
  Set m_CollEquipoDetalle = New Collection
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  ReDim m_OcIds(0)
  
  ' Servicios
  Set m_TicketConfig = New cTicketConfig
  m_TicketConfig.Load
  
  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load
  m_UserCfg.ValidateOS
  
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
  Set m_Footer = Nothing
  Set m_Items = Nothing
  ReDim m_OcIds(0)
  CollClear m_CollEquipoDetalle
  Set m_CollEquipoDetalle = Nothing
  CollClear m_NrosSerie
  Set m_NrosSerie = Nothing
  
  ' Servicios
  '
  Set m_TicketConfig = Nothing
  
  ' Preferencias del Usuario
  '
  Set m_UserCfg = Nothing
  
  If Not m_ObjEdit Is Nothing Then
    m_ObjEdit.Terminate
    Set m_ObjEdit = Nothing
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pSetShowStockData()
  Dim DocId     As Long
  Dim DocIdRto  As Long
  Dim Doc       As cDocumento
  
  Set Doc = New cDocumento
  
  m_bShowStockData = False
  
  DocId = m_ObjAbm.Properties.Item(cscDocId).HelpId
  
  ' Si la orden mueve stock
  '
  If CBool(Doc.GetData(DocId, cscDocMueveStock, csBoolean)) Then
    m_bShowStockData = True
  End If
End Sub

'///////////////////////////////////////////////////////////////////////////////////////////////////////////
Private Function pSaveItemNroSerie(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                   ByRef iOrden As Long, _
                                   ByVal PrId As Long, _
                                   ByVal OsTMPId As Long, _
                                   ByVal osiTMPId As Long, _
                                   ByVal Grupo As Long, _
                                   ByVal NroDoc As String) As Boolean
                                   
  Dim pt        As cProductoSerieType
  Dim register  As cRegister
  
  ' Si lleva numero de serie
  '
  If pCell(Row, KI_PR_LLEVANROSERIE).Id Then
  
    ' Obtengo los numeros de serie y guardo un Item por cada uno
    '
    For Each pt In m_NrosSerie.Item(GetKey(Grupo))
      
      ' Actualizo el pr_id de este numero de serie
      ' ya que lo necesito para saber cual es la
      ' plantilla de detalle en caso de que prns_id sea < 0
      ' que es el caso de todos los prns_id :) ya que
      ' se cargan por numero y como en remitos de compra
      '
      ' Esto lo hago por que el IC esta algo alto ya que
      ' se trata de cosas nuevas. La verdad es cPublicDoc
      ' ya lo resuelve
      '
      pt.pr_id = PrId
      
      If pt.Deleted Then
      
        If Not m_Copy And pt.prns_id Then
          
          Set register = New cRegister
          register.fieldId = cscOsisbTMPId
          register.table = csTOrdenServicioItemSerieBTMP
          register.Id = csNew
        
          register.Fields.Add2 cscOsTMPId, OsTMPId, csId
          register.Fields.Add2 cscPrnsId, pt.prns_id, csId
        
          register.Fields.HaveLastUpdate = False
          register.Fields.HaveWhoModify = False
          
          If Not gDB.Save(register, , _
                          "pSaveItemNroSerie", _
                          C_Module, _
                          LNGGetText(1839, vbNullString)) Then Exit Function
        
        End If
      
      Else
      
        Set register = New cRegister
        register.fieldId = cscOsisTMPId
        register.table = csTOrdenServicioItemSerieTMP
        register.Id = csNew
        
        register.Fields.Add2 cscPrId, PrId, csId
        
        If m_Copy Then
          register.Fields.Add2 cscPrnsId, csNew, csInteger
        Else
          register.Fields.Add2 cscPrnsId, pt.prns_id, csId
        End If
        
        register.Fields.Add2 cscPrnsCodigo, pt.Codigo, csText
        
        If LenB(pt.Codigo2) = 0 And m_TicketConfig.CopiarOsNroDocEnSerie2 Then
        
          pt.Codigo2 = NroDoc
        End If
        
        register.Fields.Add2 cscPrnsCodigo2, pt.Codigo2, csText
        register.Fields.Add2 cscPrnsCodigo3, pt.Codigo3, csText
        
        register.Fields.Add2 cscPrnsDescrip, pt.descrip, csText
        register.Fields.Add2 cscPrnsFechavto, pt.FechaVto, csDate
        
        register.Fields.Add2 cscOsTMPId, OsTMPId, csId
        register.Fields.Add2 cscOsiTMPId, osiTMPId, csId
        
        iOrden = iOrden + 1
        register.Fields.Add2 cscOsisOrden, iOrden, csInteger
        
        register.Fields.HaveLastUpdate = False
        register.Fields.HaveWhoModify = False
        
        If Not gDB.Save(register, , _
                        "pSaveItemNroSerie", _
                        C_Module, _
                        c_ErrorSave) Then Exit Function
        
      End If
    Next
  End If
  
  pSaveItemNroSerie = True
End Function

Private Function pGetPrId(ByVal PrId As Long) As Long
  If Not pGetIsInput() Then
    pGetPrId = PrId
  End If
End Function

Private Function pGetIsInput() As Boolean
  pGetIsInput = m_LastDoctId <> csEDocumentoTipo.csEDT_DevolucionOrdenCpra
End Function

'////////////////////////////////////////////////////////////////////////////////////////////////
' nrs devolucion
Private Function pGetDeplId() As Long
  If m_LastDoctId <> csEDocumentoTipo.csEDT_DevolucionOrdenCpra Then
    pGetDeplId = csE_DepositosInternos.csEDeplIdTercero
  Else
    pGetDeplId = m_ObjAbm.Properties(cscDeplIdOrigen).HelpId
  End If
End Function

Private Function pGetCliId() As Long
  pGetCliId = m_ObjAbm.Properties(cscCliId).HelpId
End Function

Private Function pGetFecha() As Date
  pGetFecha = m_ObjAbm.Properties.Item(cscOsFecha).Value
End Function

Private Function pGetDocNroDoc() As String
  pGetDocNroDoc = m_ObjAbm.Properties.Item(cscOsNrodoc).Value
End Function

Private Sub pUpdateNroLoteInGrid()
  Dim Row         As cIABMGridRow
  Dim IProperty   As cIABMProperty
  
  Set IProperty = GetItems(m_Items, c_Items)
  
  For Each Row In IProperty.Grid.Rows
    If pCell(Row, KI_STL_CODIGO).Value = m_Nrodoc Then
      pCell(Row, KI_STL_CODIGO).Value = pGetDocNroDoc
    End If
  Next
  
  Dim AbmGen As cABMGeneric
  Set AbmGen = m_Items
  AbmGen.ShowValue IProperty, True
  
End Sub

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

Private Function pSaveEquipoDetalle(ByVal OsId As Long, _
                                    ByVal OsTMPId As Long) As Boolean
  Dim Items   As Object
  Dim pt      As cProductoSerieType
  
  Dim EquipoDetalleEdit As cEquipoDetalleEdit
  
  For Each Items In m_NrosSerie
  
    ' Obtengo los numeros de serie y guardo un Item por cada uno
    '
    For Each pt In Items
      
      If Not pt.Deleted Or pt.prns_id <> csNO_ID Then
      
        If ExistsObjectInColl(m_CollEquipoDetalle, GetKey(pt.prns_id)) Then
          Set EquipoDetalleEdit = m_CollEquipoDetalle.Item(GetKey(pt.prns_id))
        Else
          Set EquipoDetalleEdit = New cEquipoDetalleEdit
          m_CollEquipoDetalle.Add EquipoDetalleEdit, GetKey(pt.prns_id)
        End If
        
        With EquipoDetalleEdit
          .InTemp = True
          .OsId = OsId
          .OsTMPId = OsTMPId
          .PrId = pt.pr_id
          .ProductoSerie = pt.Codigo
        End With
        
        If Not EquipoDetalleEdit.ShowParams(pt.prns_id) Then
          Exit Function
        End If
      End If
    Next
  Next
  
  pSaveEquipoDetalle = True
End Function

Private Sub pShowRemito()
  On Error GoTo ControlError

  Dim o As Object
  Set o = CSKernelClient2.CreateObject("CSVenta2.cRemitoVenta")
  
  o.ShowRemitoOrden pGetCliId(), pGetOsIds()

  GoTo ExitProc
ControlError:
  MngError Err, "pShowRemito", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pSetAutoNumber(ByVal PrId As Long, _
                           ByRef Row As cIABMGridRow, _
                           ByVal RowIndex As Long, _
                           ByVal Cantidad As Long)
  
    If Not NroSerieValidateCount2Ex(Row, _
                                    KI_GRUPO, _
                                    RowIndex, _
                                    m_NrosSerie, _
                                    Cantidad, _
                                    vbNullString, _
                                    KI_PR_ID, _
                                    KI_CANTIDAD, _
                                    KI_NROSERIE, _
                                    PrId, _
                                    pGetDeplId(), _
                                    pGetIsInput(), _
                                    True) Then
      Exit Sub
    End If

End Sub

Private Function pGetOsIds() As Long()
  Dim rtn() As Long
  ReDim rtn(1)
  rtn(1) = m_Id
  pGetOsIds = rtn
End Function

Private Function pGetItems() As cIABMProperty
  Set pGetItems = m_Items.Properties.Item(c_Items)
End Function

' HIDECOLS
'
Private Sub pShowHideCols(ByVal bOnlyStock As Boolean)
  Dim Columns   As cIABMGridColumns
  Dim bVisible  As Boolean
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  If AbmObj.InSave Then Exit Sub
  
  bVisible = Val(m_ObjAbm.Properties.Item(c_HideCols).Value) = 0
  
  Dim iProp As cIABMProperty
  Set iProp = pGetItems()
    
  AbmObj.DrawGrid iProp, False
  
  Dim i As Integer
  
  Set Columns = iProp.Grid.Columns
  For i = 1 To Columns.Count
    Select Case Columns(i).key
      
      Case KI_DESCUENTO, KI_UNIDAD, KI_PRECIO_LP, KI_IVARNI, KI_CCOS_ID
        
        ' Solo si la llamada fue para todas las columnas
        ' y no unicamente para las columnas de stock
        '
        If Not bOnlyStock Then
          Columns(i).Visible = bVisible
          AbmObj.RefreshColumnPropertiesByIndex iProp, i
        End If
        
      Case KI_NROSERIE, KI_STL_ID
      
        ' Si mueve stock se ven siempre
        '
        Columns(i).Visible = m_bShowStockData
        AbmObj.RefreshColumnPropertiesByIndex iProp, i
    
    End Select
  Next
  
  AbmObj.DrawGrid iProp, True
End Sub
'
' HIDECOLS - fin

Private Sub pEditFromObjectAux()
  
  If m_ObjEdit Is Nothing Then
  
    If LenB(m_object_edit) Then
    
      Set m_ObjEdit = CSKernelClient2.CreateObject(m_object_edit)
    
      m_ObjEdit.Initialize Me
    Else
      Exit Sub
    End If
    
  End If
  
  m_ObjEdit.EditNew
  
End Sub
