VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cParteReparacion"
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
' cParteReparacion
' 24-01-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cParteReparacion"

Private Const c_Items = "Items"

' HIDECOLS
Private Const c_HideColsPrp = "HideColsPrp"

Private Const K_NUMERO                         As Integer = 1
Private Const K_NRODOC                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHA                          As Integer = 4
Private Const K_FECHAENTREGA                   As Integer = 5
Private Const K_NETO                           As Integer = 6
Private Const K_IVARI                          As Integer = 7
Private Const K_IVARNI                         As Integer = 8
Private Const K_TOTAL                          As Integer = 9
Private Const K_CLI_ID                         As Integer = 10
Private Const K_DOC_ID                         As Integer = 11
Private Const K_DOCT_ID                        As Integer = 12
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
Private Const K_US_ID                          As Integer = 26
Private Const K_LGJ_ID                         As Integer = 27
Private Const K_PRNS_ID                        As Integer = 29
Private Const K_TIPO                           As Integer = 30
Private Const K_APROBADO                       As Integer = 31
Private Const K_CLIS_ID                        As Integer = 33

Private Const K_COTIZACION                     As Integer = 28

Private Const K_CONT_ID                        As Integer = 34
Private Const K_PRODUCTOSERIE                  As Integer = 35

' HIDECOLS
Private Const K_HIDECOLS                       As Integer = 41

Private Const KI_PRP_ID                         As Integer = 1
Private Const KI_PRPI_ID                        As Integer = 2
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
Private Const KI_ES_KIT                         As Integer = 24
Private Const KI_NROSERIE                       As Integer = 25
Private Const KI_GRUPO                          As Integer = 26

' Lote
'
Private Const KI_STL_ID                         As Integer = 27
Private Const KI_PR_LLEVALOTE                   As Integer = 28

' Lote Fifo
'
Private Const KI_PR_LOTEFIFO                    As Integer = 32

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

Private m_us_id                        As Long
Private m_usuario                      As String
Private m_lgj_id                       As Long
Private m_Legajo                       As String

Private m_clis_id                      As Long
Private m_ClienteSucursal              As String

Private m_cont_id                      As Long
Private m_contacto                     As String

Private m_prns_id                      As Long
Private m_serie                        As String
Private m_ProductoSerie                As String

Private m_Tipo                         As Long
Private m_prp_estado                   As Long

Private m_Editing                      As Boolean

Private m_bShowStockData               As Boolean
Private m_depl_id                      As Long
Private m_deposito                     As String

Private m_Cotizacion                   As Double
Private m_mon_id                       As Long
Private m_lastFecha                    As Date
Private m_lastMonIdCotizacion          As Long

' Lote
'
Private m_depf_id                      As Long

' Para ver documentos auxiliares
'
Private m_st_id                        As Long

Private m_Footer            As cIABMGeneric
Private m_Items             As cIABMGeneric
Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_LastDoc           As Long
Private m_LastDoctId        As Long ' nrs devolucion
Private m_Lastcli           As Long
Private m_LastSerie         As Long
Private m_LastDocName       As String
Private m_LastcliName       As String

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost

Private m_ItemsDeleted      As String

Private m_Copy              As Boolean

Private m_GeneralConfig     As cGeneralConfig
Private m_StockConfig       As cStockConfig
Private m_TicketConfig      As cTicketConfig

Private m_DocEditable       As Boolean
Private m_DocEditMsg        As String

Private m_PrnsIds()         As Long

Private m_bIva              As Boolean
Private m_bIvaRni           As Boolean

Private m_TaPropuesto       As Boolean
Private m_TaMascara         As String

Private m_NrosSerie         As Collection
Private m_CollKitInfo       As Collection

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

' propiedades publicas
' propiedades privadas
' funciones publicas

' Edit Apply
'
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

Public Sub ShowParteReparacion(ByVal CliId As Long, ByRef vPrnsIds() As Long)
  On Error GoTo ControlError

  m_cli_id = CliId
  gDB.GetData csTCliente, cscCliId, CliId, cscCliNombre, m_Cliente
  
  Dim i As Long
  ReDim m_PrnsIds(UBound(vPrnsIds) + 1)
  For i = 1 To UBound(vPrnsIds) + 1
    m_PrnsIds(i) = vPrnsIds(i - 1)
  Next
  
  If Not pInitMembers Then
    Exit Sub
  End If
  
  ' Si se usa el numero de OT para identificar el parte
  ' de reparacion asumimos que se trata de un parte por
  ' numero de serie y por ende buscamos si ya existe un
  ' parte de reparacion para este numero de serie
  '
  Dim prp_id As Long
  
  If m_TicketConfig.CopiarPrns2EnPrpNroDoc And _
     UBound(m_PrnsIds) > 0 Then
     
    Dim prns_codigo As String
    
    gDB.GetData csTProductoNumeroSerie, _
                cscPrnsId, _
                m_PrnsIds(1), _
                cscPrnsCodigo, _
                prns_codigo
                
    prp_id = pGetPrpIdFromPrnsId(m_PrnsIds(1))

    cIEditGeneric_Edit prp_id
    
    If prp_id = csNO_ID Then
    
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      
      AbmGen.RaiseNewDocEven
      
      With pGetPrnsId()
        .Value = prns_codigo
        .HelpId = m_PrnsIds(1)
      End With
    
      AbmGen.ShowValue pGetPrnsId()
      
      pSetDatosSerie
            
      Set AbmGen = m_Items
      AbmGen.SetFocusInGridForDocs
      
    End If

  End If

  GoTo ExitProc
ControlError:
  MngError Err, "ShowParteReparacion", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pInitMembers() As Boolean
  Set cIEditGeneric_ObjAbm = New cABMGeneric
  Set cIEditGenericDoc_Footer = New cABMGeneric
  Set cIEditGenericDoc_Items = New cABMGeneric
  
  If Not DocSecurityCanAccess(csPreTickNewParteReparacion, _
                              csNO_ID, _
                              csEDocTPreNew) Then
    Exit Function
  End If
  pInitMembers = True
End Function

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  If Not DocSecurityCanAccessEx(csPreTickNewParteReparacion, _
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscPrpNrodoc
  pSetEnabled
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True

  cIEditGeneric_Edit csNO_ID
  m_Lastcli = csNO_ID
  m_LastSerie = csNO_ID
  
  If Not m_DocEditable Then
    If LenB(m_DocEditMsg) Then
      MsgWarning m_DocEditMsg
    End If
  End If
  
  If m_ObjAbm.Properties.Item(cscDocId).HelpId = csNO_ID Then
    MsgInfo LNGGetText(1562, vbNullString)  'Debe indicar un documento
  End If
  
  ' Obtengo los datos por defecto del cliente
  '
  pSetDatoscliente
  
  ' Obtengo el numero para este comprobante
  '
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscPrpNrodoc
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

  Doc.ClientTable = csTParteReparacion
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
    
    Case MSG_GRID_ROW_DELETED
      cIABMClient_MessageEx = True
      pShowTotales m_Items.Properties(c_Items).Grid.Rows
    
    Case MSG_DOC_EDIT_STATE
      ShowEditState m_DocEditMsg, LNGGetText(1843, vbNullString) 'Parte de Reparación"
      
    Case MSG_DOC_DELETE
      If cIEditGeneric_Delete(m_Id) Then
        cIABMClient_MessageEx = True
        pMove MSG_DOC_NEXT
      End If
    
    Case MSG_DOC_APPLY
    
    Case MSG_DOC_ANULAR
      DocAnular m_Id, m_est_id, m_Estado, csPreTickAnularParteReparacion, csNO_ID, m_ObjAbm, m_DocEditable, m_DocEditMsg, "sp_DocParteReparacionAnular", "sp_DocParteReparacionEditableGet"
      pSetEnabled
    
    Case MSG_DOC_REFRESH
      Load m_Id
      pRefreshProperties
  
    Case MSG_DOC_NEW_WITH_WIZARD
      cIABMClient_MessageEx = True
    
    Case MSG_DOC_EX_GET_ITEMS
      Set cIABMClient_MessageEx = m_Items
    
    Case MSG_DOC_EX_GET_FOOTERS
      Set cIABMClient_MessageEx = m_Footer
  
    Case MSG_DOC_SEARCH                     ' En info cABMInteface nos
                                            ' indica si hay cambios sin
                                            ' guardar
      DocumentSearch csEDT_ParteReparacion, Me, Not CBool(Info)
    
    Case MSG_DOC_DOC_AUX
      
      If m_bShowStockData Then
        If m_Id Then
        
          Dim AbmObj As cABMGeneric
          Set AbmObj = m_ObjAbm
          
          cIABMClient_MessageEx MSG_MENU_AUX, 1
          
        Else
          MsgInfo LNGGetText(1620, vbNullString)
                'Debe editar un comprobante guardado para poder ver los documentos auxiliares
        End If
      Else
        If m_ObjAbm.Properties.Item(cscPrpTipo).ListItemData = csE_Presupuesto Then
          MsgInfo LNGGetText(1844, vbNullString)
                'Los Partes de Reparación de tipo Presupuesto no mueven stock
        Else
          MsgInfo LNGGetText(1845, vbNullString)
                'Este documento no tiene asociado ningún documento auxiliar
        End If
      End If
    
    Case MSG_DOC_DOC_EDIT
      
      If m_Id Then
      
        If m_DocEditable Then
        
          MsgInfo LNGGetText(1555, vbNullString)
                  'Este documento puede editarse normalmente
        Else
          
          If DocCanSave(m_ObjAbm, cscPrpFecha) Then
            
            Dim EditDoc As cEditDocEx
            Set EditDoc = New cEditDocEx
            
            Set EditDoc.ObjectClient = Me
            EditDoc.Edit m_Id, _
                         m_Doct_id, _
                         csTParteReparacion, _
                         cscPrpId, _
                         csTParteReparacionItem, _
                         cscPrpiId, _
                         csPreTickNewParteReparacion, _
                         csPreTickEditParteReparacion, _
                         m_cli_id, csNO_ID, _
                         True
          End If
          
        End If
      
      Else
        MsgInfo LNGGetText(1556, vbNullString)
              'Esta opción solo sirve para modificar documentos guardados y aplicados
      End If
      
    Case MSG_MENU_AUX
      
        ShowDocAux m_st_id, _
                   "CSStock2.cStock", _
                   "CSABMInterface2.cABMGeneric"
  
    Case MSG_DOC_HISTORY
    
      If m_Id <> csNO_ID Then
    
        ShowHistory csParteReparacion, m_Id, m_Documento & " " & m_Nrodoc
      Else
        
        MsgInfo LNGGetText(1552, vbNullString) ' El documento aun no ha sido guardado
      End If
  
    Case MSG_EXPORT_GET_EMAIL
    
      With m_ObjAbm.Properties.Item(cscCliId)
        cIABMClient_MessageEx = GetEmailFromCliente(.HelpId)
      End With
  
    Case MSG_GRID_VIRTUAL_ROW

      cIABMClient_MessageEx = pProcessMultiRow(Info)
  
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscPrpNrodoc

        ' Si corresponde muestro la cotizacion de la moneda del documento
        '
        pShowCotizacion
        
        ' Si corresponde muestro el deposito
        '
        pSetShowStockData
      End If
      
      ' Defino el estado de edicion del comprobante
      '
      pSetEnabled
    
    Case K_TIPO
    
      pUpdateAprobado
    
      ' Si corresponde muestro el deposito
      '
      pSetShowStockData
      
      ' Defino el estado de edicion del comprobante
      '
      pSetEnabled
    
    Case K_CLI_ID
      
      ' Obtengo los datos del cliente
      '
      pSetDatoscliente
      
    Case K_PRNS_ID
    
      ' Obtengo los datos del equipo
      '
      pSetDatosSerie
    
    Case K_DESCUENTO1, K_DESCUENTO2
      pShowTotales m_Items.Properties(c_Items).Grid.Rows
      
    ' Lote
    '
    Case K_DEPL_ID
    
      pSetStock

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
  Dim register As cRegister
  Dim bIsNew   As Boolean
  
  ' Save and State
  '
  If Not DocCanEdit(m_DocEditable, m_DocEditMsg) Then
    cIABMClient_Save = True
    Exit Function
  End If
  If Not DocCanSave(m_ObjAbm, cscPrpFecha) Then
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
  register.fieldId = cscPrpTMPId
  register.table = csTParteReparacionTMP
  
  register.Id = csNew
    
  If m_Copy Then
    register.Fields.Add2 cscPrpId, csNew, csLong
    bIsNew = True
  Else
    register.Fields.Add2 cscPrpId, m_Id, csLong
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
          register.Fields.Add2 cscPrpNumero, .Value, csLong
        Case K_NRODOC
          register.Fields.Add2 cscPrpNrodoc, .Value, csText
        Case K_DESCRIP
          register.Fields.Add2 cscPrpDescrip, .Value, csText
        Case K_FECHA
          register.Fields.Add2 cscPrpFecha, .Value, csDate
        Case K_FECHAENTREGA
          register.Fields.Add2 cscPrpFechaentrega, .Value, csDate
        Case K_CLI_ID
          register.Fields.Add2 cscCliId, .HelpId, csId
        Case K_COTIZACION
          register.Fields.Add2 cscPrpCotizacion, .Value, csDouble
        Case K_CCOS_ID
          register.Fields.Add2 cscCcosId, .HelpId, csId
        Case K_SUC_ID
          register.Fields.Add2 cscSucId, .HelpId, csId
        Case K_DESCUENTO1
          register.Fields.Add2 cscPrpDescuento1, .Value, csCurrency
        Case K_DESCUENTO2
          register.Fields.Add2 cscPrpDescuento2, .Value, csCurrency
        Case K_DOC_ID
          register.Fields.Add2 cscDocId, .HelpId, csId
        Case K_LP_ID
          register.Fields.Add2 cscLpId, .HelpId, csId
        Case K_LD_ID
          register.Fields.Add2 cscLdId, .HelpId, csId
        Case K_CPG_ID
          register.Fields.Add2 cscCpgId, .HelpId, csId
        Case K_US_ID
          register.Fields.Add2 cscUsId, .HelpId, csId
        Case K_LGJ_ID
          register.Fields.Add2 cscLgjId, .HelpId, csId
        Case K_PRNS_ID
          register.Fields.Add2 cscPrnsId, .HelpId, csId
        Case K_TIPO
          register.Fields.Add2 cscPrpTipo, .ListItemData, csId
        Case K_APROBADO
          register.Fields.Add2 cscPrpEstado, .ListItemData, csId
        Case K_CLIS_ID
          register.Fields.Add2 cscClisId, .HelpId, csId
        Case K_CONT_ID
          register.Fields.Add2 cscContId, .HelpId, csId
        Case K_DEPL_ID
          register.Fields.Add2 cscDeplId, .HelpId, csId
      End Select
    End With
  Next
  
  For Each IProperty In m_Footer.Properties
    With IProperty
      Select Case .key
        Case K_TOTAL
          register.Fields.Add2 cscPrpTotal, .Value, csCurrency
        Case K_NETO
          register.Fields.Add2 cscPrpNeto, .Value, csCurrency
        Case K_IVARI
          register.Fields.Add2 cscPrpIvari, .Value, csCurrency
        Case K_IVARNI
          register.Fields.Add2 cscPrpIvarni, .Value, csCurrency
        Case K_SUBTOTAL
          register.Fields.Add2 cscPrpSubtotal, .Value, csCurrency
        Case K_IMPORTEDESC1
          register.Fields.Add2 cscPrpImportedesc1, .Value, csCurrency
        Case K_IMPORTEDESC2
          register.Fields.Add2 cscPrpImportedesc2, .Value, csCurrency
      End Select
    End With
  Next
  
  register.Fields.Add2 cscEstId, m_est_id, csId
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If Not pSaveItems(register.Id) Then Exit Function
  If Not register.CommitTrans() Then Exit Function
  
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DocParteReparacionSave " & register.Id
  
  If Not gDB.OpenRs(sqlstmt, rs, , , , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim Id As Long
  If Not GetDocIDFromRecordset(rs, Id) Then Exit Function
  
  m_Copy = False
  
  If Load(Id) Then

    Dim AbmGen As cABMGeneric
    Set AbmGen = m_ObjAbm
    
    If bIsNew Then
    
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
  CSKernelClient2.SetRegistry csInterface, c_HideColsPrp, Val(m_ObjAbm.Properties.Item(c_HideCols).Value)
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  m_ObjTree.sqlstmt = "sp_lsdoc_ParteReparacion"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
  
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(1843, vbNullString)   'Parte de Reparación
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
            MsgInfo LNGGetText(1563, vbNullString) 'Debe indicar un Cliente
            Exit Function
          End If
        Case K_DOC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1562, vbNullString) 'Debe indicar un documento
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

  cIABMClient_Validate = True
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
  
  sqlstmt = "select doct_id, doc_id from ParteReparacion where prp_id = " & Id
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreTickListParteReparacion)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
  m_ObjAbm.IsDocument = True

#If Not PREPROC_SFS Then
  Dim AbmGen      As cABMGenericDocEx
  
  Set AbmGen = m_ObjAbm
  With AbmGen
    .FactoryObject = "CSABMInterface2.cFactory"
    .ObjForm = "CSABMInterface2.fParteReparacion"
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
                          csTParteReparacion, _
                          cscPrpId, _
                          doc_id) Then
      Exit Function
    End If
  End If
  
  If Not DocSecurityCanAccess( _
                  csPreTickDeleteParteReparacion, _
                  doc_id, _
                  csEDocTPreDelete) Then
    Exit Function
  End If
  
  Dim sqlstmt As String
  
  sqlstmt = "sp_DocParteReparacionDelete " & Id & "," & EmpId & "," & User.Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not DocSecurityCanAccess(csPreTickListParteReparacion, GetdocIdFromObjAbm(m_ObjAbm), csEDocTPreList) Then Exit Function
                     
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
      With m_Items.Properties(c_Items)
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

Private Function pProcessMultiRow(ByVal Info As Variant) As Boolean
  
  Info.bAddRows = False
  
  Select Case Info.key
    Case K_ITEMS
      With pGetItems()
        
        Dim Row As cIABMGridRow
        Set Row = .Grid.Rows(Info.lRow)

        If Row.Item(Info.lCol).key = KI_PR_ID Then
          
          Dim oCell As cABMGridRowValue
          
          Set oCell = pCell(Row, KI_PR_ID)
          
          If LenB(oCell.HelpValueProcess) Then
            If InStr(1, oCell.HelpValueProcess, ",") Then
              pAddMultiRows oCell.HelpValueProcess, Info
              pProcessMultiRow = True
            End If
          End If
        End If
      End With
  End Select
  
End Function

Private Sub pAddMultiRows(ByVal Ids As String, _
                          ByRef Info As Variant)
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
    
  sqlstmt = "select pr_nombreventa, pr_id from Producto where pr_id in (" & Ids & ")"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  If rs.EOF Then Exit Sub
  
  Dim i As Long
  Dim j As Long
  Dim k As Long
  Dim pr_id As Long
  Dim vIds  As Variant
  Dim vIds2 As Variant
  Dim bFound As Boolean
  
  vIds2 = Split(Ids, ",")
  
  ReDim vIds(UBound(vIds2))
  
  For i = 0 To UBound(vIds2)
    bFound = False
    For j = 0 To UBound(vIds)
    
      If vIds2(i) = vIds(j) Then
        bFound = True
        Exit For
      End If
      
    Next
    If Not bFound Then
      vIds(k) = vIds2(i)
      k = k + 1
    End If
  Next
  
  ReDim Preserve vIds(k - 1)
  
  ' Ahora respeto el orden de seleccion
  '
  For i = 0 To UBound(vIds)
  
    rs.MoveFirst
    
    Do While Not rs.EOF
  
      pr_id = gDB.ValField(rs.Fields, cscPrId)
      
      If Val(vIds(i)) = pr_id Then
        Info.NewId.Add pr_id
        Info.NewValue.Add gDB.ValField(rs.Fields, cscPrNombreventa)
        Exit Do
      End If
      
      rs.MoveNext
    Loop
    
  Next
  
  ' No lo toquen, es mas 1 :( o explota todooo :P
  ' ups al final no era jeje
  '
  Info.iAddRows = Info.NewId.Count '+ 1
  
  Info.bAddRows = Info.iAddRows
  
End Sub

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  On Error GoTo ControlError

  Select Case key
    Case K_ITEMS
      cIABMClientGrid_ColumnAfterEdit = pColumnAfterEdit(m_Items.Properties(c_Items), lRow, lCol, NewValue, NewValueID)
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
      cIABMClientGrid_ColumnBeforeEdit = pColumnBeforeEdit(m_Items.Properties(c_Items), lRow, lCol, iKeyAscii)
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
    Case KI_STL_ID
      Set Row = IProperty.Grid.Rows(lRow)
      
      If Not Row Is Nothing Then
      
        If pCell(Row, KI_PR_LLEVALOTE).Id And _
           pCell(Row, KI_PR_LLEVANROSERIE).Id = 0 Then
           
          Dim pr_id_kit As Long
          If pCell(Row, KI_ES_KIT).Id Then
            pr_id_kit = pCell(Row, KI_PR_ID).Id
          End If
           
          With IProperty.Grid.Columns.Item(cscStlId)
            .HelpFilter = "'pr_id = " & _
                                  pCell(Row, KI_PR_ID).Id & _
                          " and " & GetStockLoteFilterEx( _
                                              pGetDeplId(), _
                                              m_StockConfig.StockXFisico, _
                                              pr_id_kit, _
                                              m_depf_id, _
                                              pGetCliId(), _
                                              csNO_ID) & "'"
          End With
          
          Dim AbmObj As cABMGeneric
          Set AbmObj = m_ObjAbm
          
          AbmObj.RefreshColumnProperties IProperty, cscStlId
          
          pColumnBeforeEdit = True
        End If
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

Private Function pColumnAfterEdit(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long)
  Dim Row     As cIABMGridRow
  
  Select Case IProperty.Grid.Columns(lCol).key
    Case KI_PR_ID
      Set Row = IProperty.Grid.Rows(lRow)
      pSetDataProducto Row, NewValueID
      SetPrecio Row, NewValueID, m_ObjAbm.Properties(cscLpId), KI_PRECIO_LP, KI_PRECIO_USR
      SetDescuento Row, NewValueID, pGetPrecioFromRow(Row), m_ObjAbm.Properties(cscLdId), KI_PRECIO, KI_DESCUENTO
      pSetTasasImpositivas Row, NewValueID, NewValue
      
    Case KI_PRECIO_USR
      Set Row = IProperty.Grid.Rows(lRow)
      SetDescuento Row, pCell(Row, KI_PR_ID).Id, NewValue, m_ObjAbm.Properties(cscLdId), KI_PRECIO, KI_DESCUENTO
  
  End Select
  
  pColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  Dim Row As cIABMGridRow
  
  Select Case key
    Case K_ITEMS
      With m_Items.Properties.Item(c_Items).Grid
        Select Case .Columns(lCol).key
          Case KI_NROSERIE
            Set Row = .Rows(lRow)
            If pCell(Row, KI_PR_LLEVANROSERIE).Id Then
              
              Dim PrId As Long
              
              PrId = pCell(Row, KI_PR_ID).Id
              
              ' nrs devolucion
              cIABMClientGrid_ColumnButtonClick = EditNroSerie(pCell(Row, KI_GRUPO).Id, _
                                                               Val(pCell(Row, KI_CANTIDAD).Value), _
                                                               Row, _
                                                               m_NrosSerie, _
                                                               KI_GRUPO, _
                                                               KI_NROSERIE, _
                                                               lRow, _
                                                               PrId, _
                                                               pGetDeplId, _
                                                               False, _
                                                               pCell(Row, KI_ES_KIT).Id, _
                                                               GetKitInfo(PrId, m_CollKitInfo), _
                                                               csNO_ID, pGetCliId)
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
  
  Id = Val(pCell(Row, KI_PRPI_ID).Value)
  
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
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.key
      Case KI_CANTIDAD
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(1365, vbNullString, strRow) 'Debe indicar una cantidad (1)
          Exit Function
        End If

' Por ahora no lo exijo
'
'      Case KI_PRECIO
'        If ValEmpty(Cell.Value, csCurrency) Then
'          MsgInfo "Debe indicar un precio" & strRow
'          Exit Function
'        End If
      
      Case KI_PR_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(1565, vbNullString, strRow) 'Debe indicar un producto de venta (1)
          Exit Function
        End If
      
      Case KI_NROSERIE
        bLlevaNroSerie = pCell(Row, KI_PR_LLEVANROSERIE).Id
        If ValEmpty(Cell.Value, csText) _
           And bLlevaNroSerie _
           And m_bShowStockData Then
          MsgInfo LNGGetText(1630, vbNullString, strRow) 'Debe indicar un numero de serie (1)
          Exit Function
        End If
      
      ' Lote
      '
      ' Lote Fifo
      '
      Case KI_STL_ID
        If ValEmpty(Cell.Id, csId) And _
           pCell(Row, KI_PR_LLEVALOTE).Id And _
           pCell(Row, KI_PR_LLEVANROSERIE).Id = 0 And _
           pCell(Row, KI_PR_LOTEFIFO).Id = 0 Then
      
          MsgInfo LNGGetText(1632, vbNullString, strRow) 'Debe indicar un lote (1)
          Exit Function
        End If
    End Select
  Next
  
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
  
  AbmGen.NoButtons1 = BUTTON_DOC_APLIC
  AbmGen.NoButtons2 = BUTTON_DOC_ACTION
  AbmGen.InitButtons
  AbmGen.SetFocusFirstCtrlInNew = True
  
  m_ObjAbm.Properties.Clear
  
  With m_ObjAbm.Tabs
      
    .Clear
    
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
    
    With .Add(Nothing)
      .Index = 1
      .Name = LNGGetText(1566, vbNullString) 'Adicionales
    End With
  
  End With
  
  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, cscDocId)
      .PropertyType = cspHelp
      .table = CSDocumento2.CSDocumento
      .Name = LNGGetText(1567, vbNullString) 'Documento
      .key = K_DOC_ID
      
      If m_doc_id <> csNO_ID Then
        .HelpId = m_doc_id
        .Value = m_Documento
      Else
        ' Preferencias del usuario
        '
        .HelpId = m_UserCfg.DocPrpId
        .Value = m_UserCfg.DocPrpNombre
        
        bValidateDocDefault = .HelpId <> csNO_ID
      End If
      
      .HelpFilter = "'doct_id = " & csEDT_ParteReparacion & "'"
    End With
    
    With .Add(Nothing, csDocNumberID)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(1065, vbNullString) 'Número
      .key = K_NUMERO
      .Value = m_Numero
      .Enabled = False
    End With
    
    With .Add(Nothing, csDocEstateID)
      .PropertyType = cspText
      .Name = LNGGetText(1568, vbNullString) 'Estado
      .key = K_EST_ID
      .Value = m_Estado
      .Enabled = False
    End With
    
    With .Add(Nothing, cscPrpFecha)
      .PropertyType = cspDate
      .Name = LNGGetText(1569, vbNullString) 'Fecha
      .LeftLabel = -580
      .Left = 700
      .key = K_FECHA
      .Value = m_Fecha
    End With
    
    With .Add(Nothing, cscPrpFechaentrega)
      .PropertyType = cspDate
      .Name = LNGGetText(1570, vbNullString) 'Entrega
      .key = K_FECHAENTREGA
      .Value = m_Fechaentrega
    End With
    
    With .Add(Nothing, cscPrnsId)
      .PropertyType = cspHelp
      .table = csProductoSerie
      .Name = LNGGetText(1801, vbNullString) 'Equipo
      .key = K_PRNS_ID
      .HelpId = m_prns_id
      .Value = m_serie
      
                    ' Esto filtra numeros de serie
                    ' que ya tienen un Parte de reparacion
                    ' para la orden de servicio activa
                    '
      .HelpFilter = "(doct_id_ingreso = 42 " & _
                    "and not exists (select * " & _
                                     "from ProductoNumeroSerieServicio " & _
                                     "where prnss_id = prns.prns_id " & _
                                       "and prp_id is not null " & _
                                       "and prp_id <> " & m_Id & "))"
      AbmGen.NewKeyPropFocus = cscPrnsId
      .TopFromProperty = cscPrpFecha
      .Left = 2700
      .LeftLabel = -580
    End With
    
    With .Add(Nothing, cscPrpNrodoc)
      .PropertyType = cspText
      .Name = LNGGetText(1065, vbNullString) 'Número
      .Size = 50
      .key = K_NRODOC
      .Value = m_Nrodoc
      .TextMask = m_TaMascara
      .TextAlign = vbRightJustify
    End With
    
    With .Add(Nothing, cscCliId)
      .PropertyType = cspHelp
      .table = csCliente
      .Name = LNGGetText(1150, vbNullString) 'Cliente
      .key = K_CLI_ID
      .HelpId = m_cli_id
      .Value = m_Cliente
      .TopFromProperty = cscPrpFecha
      .Left = 5750
      .LeftLabel = -600
      .Width = 2500
    End With
    
    With .Add(Nothing, cscUsId)
      .PropertyType = cspHelp
      .table = csUsuario
      .Name = LNGGetText(1846, vbNullString) 'Técnico
      .key = K_US_ID
      .HelpId = m_us_id
      .Value = m_usuario
      .LeftLabel = -700
      .Width = 2500
    End With
    
    With .Add(Nothing, cscPrpTipo)
      .PropertyType = cspList
      With .List
        With .Add(Nothing)
          .Id = csEParteReparacionTipo.csE_Presupuesto
          .Value = LNGGetText(1847, vbNullString) 'Presupuesto
        End With
        With .Add(Nothing)
          .Id = csEParteReparacionTipo.csE_Reparacion
          .Value = LNGGetText(1848, vbNullString) 'Reparación
        End With
      End With
      .Name = LNGGetText(1223, vbNullString) 'Tipo
      .key = K_TIPO
      .ListWhoSetItem = csListItemData
      .ListItemData = m_Tipo
      .LeftLabel = -420
      .Width = 1250
      .Left = 5180
      .TopToPrevious = 880
    End With
    
    With .Add(Nothing, cscPrpEstado)
      .PropertyType = cspList
      .Name = LNGGetText(1568, vbNullString) 'Estado
      .key = K_APROBADO
      
      With .List
        With .Add(Nothing)
          .Id = csE_PrpPendiente
          .Value = "1 -" & LNGGetText(1609, vbNullString) 'Pendiente
        End With
        With .Add(Nothing)
          .Id = csE_PrpRechazado
          .Value = "2 -" & LNGGetText(2055, vbNullString) 'Rechazado
        End With
        With .Add(Nothing)
          .Id = csE_PrpPendienteAprob
          .Value = "3 -" & LNGGetText(2391, vbNullString) 'En Aprobación
        End With
        With .Add(Nothing)
          .Id = csE_PrpAprobado
          .Value = "4 -" & LNGGetText(1849, vbNullString) 'Aprobado
        End With
        With .Add(Nothing)
          .Id = csE_PrpRepuestos
          .Value = "5 -" & LNGGetText(2392, vbNullString) 'En espera de Repuesto
        End With
      End With
      .Width = 2210
      .ListWhoSetItem = csListItemData
      .ListItemData = m_prp_estado
      .Enabled = m_Tipo = csEParteReparacionTipo.csE_Presupuesto
      .LeftLabel = -1
      .TopFromProperty = cscPrpTipo
      .LeftToPrevious = 1700
    End With
    
    With .Add(Nothing, cscCpgId)
      .PropertyType = cspHelp
      .table = csCondicionPago
      .Name = LNGGetText(1571, vbNullString) 'Cond. pago
      .TopFromProperty = cscPrpFecha
      .Left = 9400
      .LeftLabel = -900
      .key = K_CPG_ID
      .HelpId = m_cpg_id
      .Value = m_CondicionPago
    End With
    
    With .Add(Nothing, cscPrpCotizacion)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .LeftLabel = -500
      .Name = LNGGetText(1650, vbNullString) 'Cotiz.
      .Format = m_GeneralConfig.FormatDecCotizacion
      .key = K_COTIZACION
      .Value = m_Cotizacion
      .Width = 1000
    End With
    
    With .Add(Nothing, cscPrpDescuento1)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .LeftLabel = -650
      .Name = LNGGetText(1573, vbNullString) 'Desc. 1
      .key = K_DESCUENTO1
      .Value = m_Descuento1
      .Width = 1000
    End With
    
    With .Add(Nothing, cscPrpDescuento2)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .TopFromProperty = cscPrpDescuento1
      .Left = 10650
      .LeftLabel = -150
      .Name = "2"
      .key = K_DESCUENTO2
      .Value = m_Descuento2
      .Width = 1000
    End With
    
    With .Add(Nothing, cscDeplIdOrigen)
      .PropertyType = cspHelp
      .Left = 9400
      .LeftLabel = -700
      .table = csDepositoLogico
      .Name = LNGGetText(1574, vbNullString) 'Deposito
      .key = K_DEPL_ID
      
      If m_depl_id <> csNO_ID Or Not m_bShowStockData Then
        .HelpId = m_depl_id
        .Value = m_deposito
      Else
        ' Preferencias del usuario
        '
        .HelpId = m_UserCfg.DeplId
        .Value = m_UserCfg.DeplNombre
      End If
      
      .Enabled = m_bShowStockData
    End With
    
    With .Add(Nothing, cscPrId)
      .PropertyType = cspText
      .Width = 7970
      .Height = 285
      .Value = m_ProductoSerie
      .LeftFromProperty = cscPrpFecha
      .TopFromProperty = cscPrpNrodoc
      .TopToPrevious = 400
      .Enabled = False
      .key = K_PRODUCTOSERIE
    End With
    
    With .Add(Nothing, cscPrpDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = LNGGetText(1211, vbNullString) 'Observ.
      .LeftLabel = -600
      .Size = 5000
      .key = K_DESCRIP
      .Value = m_Descrip
      .LeftFromProperty = cscPrpFecha
      .TopFromProperty = cscPrpNrodoc
      .Width = 4000
      .Height = 520
      .TopToPrevious = 800
    End With
    
    With .Add(Nothing, cscLpId)
      .PropertyType = cspHelp
      .table = csListaPrecio
      .Name = LNGGetText(1397, vbNullString) 'Lista de Precios
      .HelpFilter = GetListaPrecioGetXCliente(m_doc_id, m_cli_id)
      .key = K_LP_ID
      .HelpId = m_Lp_id
      .Value = m_ListaPrecio
      .Left = 1500
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscLdId)
      .PropertyType = cspHelp
      .table = csListaDescuento
      .Name = LNGGetText(1398, vbNullString) 'Lista de Descuentos
      .HelpFilter = GetListaDescGetXCliente(m_doc_id, m_cli_id)
      .key = K_LD_ID
      .HelpId = m_Ld_id
      .Value = m_ListaDescuento
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscSucId)
      .PropertyType = cspHelp
      .table = csSucursal
      .Name = LNGGetText(1281, vbNullString) 'Sucursal
      .key = K_SUC_ID
      .HelpId = m_suc_id
      .Value = m_Sucursal
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscCcosId)
      .PropertyType = cspHelp
      .table = csCentroCosto
      .Name = LNGGetText(1057, vbNullString) 'Centro de Costo
      .key = K_CCOS_ID
      .HelpId = m_ccos_id
      .Value = m_CentroCosto
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscLgjId)
      .PropertyType = cspHelp
      .table = csLegajo
      .Name = LNGGetText(1575, vbNullString) 'Legajo
      .key = K_LGJ_ID
      .HelpId = m_lgj_id
      .Value = m_Legajo
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscClisId)
      .PropertyType = cspHelp
      .table = csSucursalCliente
      .Name = LNGGetText(1576, vbNullString) 'Sucursal del Cliente
      .key = K_CLIS_ID
      .Value = m_ClienteSucursal
      .HelpId = m_clis_id
      .HelpFilter = GetHelpFilterCliSuc(m_cli_id)
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscContId)
      .PropertyType = cspHelp
      .table = csContacto
      .Name = LNGGetText(1035, vbNullString) 'Contacto
      .key = K_CONT_ID
      .Value = m_contacto
      .HelpId = m_cont_id
      .TabIndex = 1
    End With
  
    ' HIDECOLS
    '
    With .Add(Nothing)
      .PropertyType = cspLabel
      .BackColor = vbButtonShadow
      .Width = 2540
      .TopNotChange = True
      .LeftNotChange = True
      .Top = 3460
      .Left = 9210
      .Height = 330
    End With
    
    With .Add(Nothing)
      .PropertyType = cspLabel
      .BackColor = vbWindowBackground
      .Width = 2500
      .TopNotChange = True
      .LeftNotChange = True
      .Top = 3480
      .Left = 9220
      .Height = 300
    End With
  
    Dim iProp As cIABMProperty
    Dim oProp As cABMProperty
    Set iProp = .Add(Nothing, c_HideCols)
    Set oProp = iProp
    With iProp
      .PropertyType = cspCheck
      .Name = LNGGetText(3901, vbNullString)  'Ocultar Columnas
      .key = K_HIDECOLS
      .Value = CInt(CSKernelClient2.GetRegistry(csInterface, c_HideColsPrp, 1))
      .TopNotChange = True
      .LeftNotChange = True
      .Top = 3500
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
      .Name = "Items"
    End With
    
  End With
    
  Set AbmGen = m_Items
  AbmGen.ResetLayoutMembers
  
  With m_Items.Properties
  
    .Clear
  
    Set c = .Add(Nothing, c_Items)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItems(c) Then Exit Function
      .Name = c_Items
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
  
    With .Add(Nothing, cscPrpSubtotal)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1579, vbNullString) 'Sub Total
      .key = K_SUBTOTAL
      .Value = m_SubTotal
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscPrpImportedesc1)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1573, vbNullString) 'Desc. 1
      .key = K_IMPORTEDESC1
      .Value = m_ImporteDesc1
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscPrpImportedesc2)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1580, vbNullString) 'Desc. 2
      .key = K_IMPORTEDESC2
      .Value = m_ImporteDesc2
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscPrpNeto)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1581, vbNullString) 'Neto
      .key = K_NETO
      .Value = m_Neto
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscPrpIvari)
      .PropertyType = cspNumeric
      .Name = LNGGetText(1582, vbNullString) 'IVA RI
      .SubType = cspMoney
      .key = K_IVARI
      .Value = m_Ivari
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscPrpIvarni)
      .PropertyType = cspNumeric
      .Name = LNGGetText(1583, vbNullString) 'IVA RNI
      .SubType = cspMoney
      .key = K_IVARNI
      .Value = m_Ivarni
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
    
    With .Add(Nothing, cscPrpTotal)
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .Name = LNGGetText(1584, vbNullString) 'Total
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

  LoadCollection = True
End Function

' Cotizacion
Private Function pGetCotizacion() As cIABMProperty
  Set pGetCotizacion = m_ObjAbm.Properties.Item(cscPrpCotizacion)
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
  Dim PrId    As Long
  Dim rs      As ADODB.Recordset
  Dim oCol    As cABMGridColumn
  Dim iCol    As cIABMGridColumn
  
  ' HIDECOLS
  '
  Dim bColVisible As Boolean
  bColVisible = Val(m_ObjAbm.Properties.Item(c_HideCols).Value) = 0
  
  sqlstmt = "sp_DocParteReparacionGetItems " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
    
      With .Add(Nothing)
        .Visible = False
        .key = KI_PRPI_ID
      End With
        
      Set iCol = .Add(Nothing)
      Set oCol = iCol
      With iCol
        .Name = LNGGetText(1367, vbNullString)  'Articulo
        .PropertyType = cspHelp
        .table = csProductoVenta
        .Width = 1800
        .key = KI_PR_ID
        .HelpFilter = c_filter_is_for_parte_rep
      End With
      If m_UserCfg.MultiSelect Then
        oCol.HelpType = csMultiSelect
      End If
      Set iCol = Nothing
      Set oCol = Nothing
        
      With .Add(Nothing)
        .Name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 1200
        .key = KI_DESCRIP
      End With
        
      With .Add(Nothing)
        .Name = LNGGetText(1374, vbNullString) 'Cantidad
        .Format = m_GeneralConfig.FormatDecCantidad
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .key = KI_CANTIDAD
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Value = 1
      End With
        
      With .Add(Nothing)
        .Name = LNGGetText(1639, vbNullString) 'Nr. Serie
        .PropertyType = cspText
        .SubType = cspTextButton
        .Width = 3000
        .key = KI_NROSERIE
      End With
      
      ' Lote
      '
      With .Add(Nothing, cscStlId)
        .Name = LNGGetText(1640, vbNullString) 'Lote
        .PropertyType = cspHelp
        .table = csStockLote
        .Width = 2000
        .key = KI_STL_ID
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1585, vbNullString) 'Descuento
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .key = KI_DESCUENTO
        .Enabled = False
        .Visible = bColVisible ' HIDECOLS
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1165, vbNullString) 'Unidad
        .PropertyType = cspText
        .Width = 1200
        .key = KI_UNIDAD
        .Enabled = False
        .Visible = bColVisible ' HIDECOLS
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1587, vbNullString) 'Precio (LP)
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .key = KI_PRECIO_LP
        .Enabled = False
        .Visible = bColVisible ' HIDECOLS
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1586, vbNullString) 'Precio
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1200
        .Format = m_GeneralConfig.FormatDecImporte
        .key = KI_PRECIO_USR
        .Enabled = SecurityCanAccessSilent(csPreTickEditPrecioParte)
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1588, vbNullString) 'Precio c/desc.
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Width = 1200
        .Format = m_GeneralConfig.FormatDecImporte
        .key = KI_PRECIO
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1581, vbNullString) 'Neto
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .key = KI_NETO
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1582, vbNullString) 'IVA RI
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .key = KI_IVARI
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1583, vbNullString) 'IVA RNI
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .key = KI_IVARNI
        .Enabled = False
        .Visible = bColVisible ' HIDECOLS
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1228, vbNullString) 'Importe
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
        .Name = LNGGetText(1057, vbNullString) 'Centro de Costo
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
      
      ' Lote Fifo
      '
      With .Add(Nothing)
        .Visible = False
        .key = KI_PR_LOTEFIFO
      End With
      
      With .Add(Nothing)
        .Visible = False
        .key = KI_PR_LLEVANROSERIE
      End With
      
      With .Add(Nothing)
        .Visible = False
        .key = KI_ES_KIT
      End With
      
      With .Add(Nothing)
        .Visible = False
        .key = KI_GRUPO
      End With
    End With
  
    With .Rows
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscPrpiId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPrpiId)
            .key = KI_PRPI_ID
          End With
            
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPrNombreCompra)
            .Id = gDB.ValField(rs.Fields, cscPrId)
            .key = KI_PR_ID
          End With
            
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPrpiDescrip)
            .key = KI_DESCRIP
          End With
            
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPrpiCantidad)
            .key = KI_CANTIDAD
          End With
            
          With .Add(Nothing)
            .Value = vbNullString
            .key = KI_NROSERIE
          End With
            
          ' Lote
          '
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscStlCodigo)
            .Id = gDB.ValField(rs.Fields, cscStlId)
            .key = KI_STL_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPrpiDescuento)
            .key = KI_DESCUENTO
          End With
            
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscUnNombre)
            .key = KI_UNIDAD
          End With
            
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPrpiPrecioLista)
            .key = KI_PRECIO_LP
          End With
            
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPrpiPrecioUsr)
            .key = KI_PRECIO_USR
          End With
            
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPrpiPrecio)
            .key = KI_PRECIO
          End With
            
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPrpiNeto)
            .key = KI_NETO
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPrpiIvari)
            .key = KI_IVARI
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPrpiIvarni)
            .key = KI_IVARNI
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscPrpiImporte)
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
          
          ' Lote Fifo
          '
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscPrLoteFifo)
            .key = KI_PR_LOTEFIFO
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscPrLlevaNroSerie)
            .key = KI_PR_LLEVANROSERIE
          End With
        
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscPrEskit)
            .key = KI_ES_KIT
          End With
            
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscPrpiId)
            .key = KI_GRUPO
          End With
        
        End With
        
        rs.MoveNext
      Wend
    End With
  End With

  '//////////////////////////////////////////////////
  ' Numeros de Serie
  '//////////////////////////////////////////////////
  
  Dim NroSerie  As cProductoSerieType
  Dim CurGroup  As Long
  Dim coll      As Collection
  Dim NrosSerie As String
    
  CollClear m_NrosSerie
  
  Set rs = rs.NextRecordset
  
  While Not rs.EOF
    
    ' Si cambie de grupo
    If CurGroup <> gDB.ValField(rs.Fields, cscPrpiId) Then
    
      pSetNrosSerieInRow CurGroup, NrosSerie
      NrosSerie = vbNullString
    
      CurGroup = gDB.ValField(rs.Fields, cscPrpiId)
      Set coll = New Collection
      m_NrosSerie.Add coll, GetKey(CurGroup)
    End If
    
    ' Guardo el numero de serie
    Set NroSerie = New cProductoSerieType
    With NroSerie
      .Codigo = gDB.ValField(rs.Fields, cscPrnsCodigo)
      .descrip = gDB.ValField(rs.Fields, cscPrnsDescrip)
      .FechaVto = gDB.ValField(rs.Fields, cscPrnsFechavto)
      .prns_id = gDB.ValField(rs.Fields, cscPrnsId)
      .pr_id_item = gDB.ValField(rs.Fields, cscPrId)
      .KitItem = gDB.ValField(rs.Fields, cscPrNombreCompra)
    
      NrosSerie = NrosSerie & .Codigo & ","
    End With
    
    ' Lo agrego a la bolsa
    coll.Add NroSerie, GetKey(NroSerie.prns_id)
    
    rs.MoveNext
  Wend
  
  pSetNrosSerieInRow CurGroup, NrosSerie
  NrosSerie = vbNullString
  
  '//////////////////////////////////////////////////
  ' Kit
  '//////////////////////////////////////////////////
  CollClear m_CollKitInfo
  
  Set rs = rs.NextRecordset
  
  While Not rs.EOF
    
    PrId = gDB.ValField(rs.Fields, cscPrId)
    Set coll = GetCollKitInfoXPrId(PrId, m_CollKitInfo)
    
    PrId = gDB.ValField(rs.Fields, cscPrIdItem)
    
    With GetKitInfoItem(coll, PrId)
      .pr_id = PrId
      .Nombre = gDB.ValField(rs.Fields, cscPrNombreCompra)
      .Cantidad = gDB.ValField(rs.Fields, "cantidad")
      .LlevaNroSerie = gDB.ValField(rs.Fields, cscPrLlevaNroSerie)
    End With
    rs.MoveNext
  Wend
  
  pLoadItems = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "sp_DocParteReparacionGet " & EmpId & "," & Id & "," & gDB.UserId
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscPrpId)
    m_Numero = gDB.ValField(rs.Fields, cscPrpNumero)
    m_Nrodoc = gDB.ValField(rs.Fields, cscPrpNrodoc)
    m_Descrip = gDB.ValField(rs.Fields, cscPrpDescrip)
    m_Fecha = gDB.ValField(rs.Fields, cscPrpFecha)
    m_Fechaentrega = gDB.ValField(rs.Fields, cscPrpFechaentrega)
    m_Neto = gDB.ValField(rs.Fields, cscPrpNeto)
    m_Ivari = gDB.ValField(rs.Fields, cscPrpIvari)
    m_Ivarni = gDB.ValField(rs.Fields, cscPrpIvarni)
    m_Total = gDB.ValField(rs.Fields, cscPrpTotal)
    m_SubTotal = gDB.ValField(rs.Fields, cscPrpSubtotal)
    m_Descuento1 = gDB.ValField(rs.Fields, cscPrpDescuento1)
    m_Descuento2 = gDB.ValField(rs.Fields, cscPrpDescuento2)
    m_ImporteDesc1 = gDB.ValField(rs.Fields, cscPrpImportedesc1)
    m_ImporteDesc2 = gDB.ValField(rs.Fields, cscPrpImportedesc2)
    m_cli_id = gDB.ValField(rs.Fields, cscCliId)
    m_Cliente = gDB.ValField(rs.Fields, cscCliNombre)
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
    m_Cotizacion = gDB.ValField(rs.Fields, cscPrpCotizacion)

    m_us_id = gDB.ValField(rs.Fields, cscUsId)
    m_usuario = gDB.ValField(rs.Fields, cscUsNombre)
    m_lgj_id = gDB.ValField(rs.Fields, cscLgjId)
    m_Legajo = gDB.ValField(rs.Fields, cscLgjCodigo)
    m_prns_id = gDB.ValField(rs.Fields, cscPrnsId)
    m_serie = gDB.ValField(rs.Fields, cscPrnsCodigo)
    m_ProductoSerie = gDB.ValField(rs.Fields, "serie_descrip")
    m_Tipo = gDB.ValField(rs.Fields, cscPrpTipo)
    m_prp_estado = gDB.ValField(rs.Fields, cscPrpEstado)

    m_clis_id = gDB.ValField(rs.Fields, cscClisId)
    m_ClienteSucursal = gDB.ValField(rs.Fields, cscClisNombre)
    
    m_cont_id = gDB.ValField(rs.Fields, cscContId)
    m_contacto = gDB.ValField(rs.Fields, cscContNombre)

    m_DocEditable = gDB.ValField(rs.Fields, cscDocEditable)
    m_DocEditMsg = gDB.ValField(rs.Fields, cscDoceditMsg)

    ' Lote
    '
    m_depf_id = gDB.ValField(rs.Fields, cscDepfId)
    m_depl_id = gDB.ValField(rs.Fields, cscDeplId)
    m_deposito = gDB.ValField(rs.Fields, cscDeplNombre)

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
    m_LastSerie = m_prns_id
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
    m_suc_id = User.suc_id
    m_Sucursal = User.Sucursal
    m_Cotizacion = 0
  
    m_clis_id = csNO_ID
    m_ClienteSucursal = vbNullString
    
    m_cont_id = csNO_ID
    m_contacto = vbNullString
    
    m_us_id = gDB.UserId
    m_usuario = gDB.UserName
    
    m_lgj_id = csNO_ID
    m_Legajo = vbNullString
    m_prns_id = csNO_ID
    m_serie = vbNullString
    m_ProductoSerie = vbNullString
    
    If m_UserCfg.PrpEstadoDef Then
        
      m_Tipo = csE_Reparacion
      m_prp_estado = csE_PrpAprobado

    Else
      
      m_Tipo = csE_Presupuesto
      m_prp_estado = csE_PrpPendiente
    
    End If
    
    ' Lote
    '
    m_depf_id = csNO_ID
    m_depl_id = csNO_ID
    m_deposito = vbNullString
    
    ' Para ver documentos auxiliares
    '
    m_st_id = csNO_ID
    
    m_TaPropuesto = False
    m_TaMascara = vbNullString
  
    m_doc_id = m_LastDoc
    m_Doct_id = m_LastDoctId ' nrs devolucion
    m_Documento = m_LastDocName
  
    m_Lastcli = csNO_ID
    m_LastSerie = csNO_ID
    m_LastcliName = vbNullString
  
    m_bIvaRni = False
    m_bIva = False
    
    m_mon_id = csNO_ID
    m_lastMonIdCotizacion = csNO_ID
    m_lastFecha = csNoDate
    
    ' Cotizacion
    If m_doc_id <> csNO_ID Then
      m_Cotizacion = DocGetCotizacion(m_doc_id, m_Fecha)
    End If
    
    DocEditableGet m_doc_id, m_DocEditable, m_DocEditMsg, csPreTickNewParteReparacion
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
  Dim str_1755     As String
  
  str_1755 = LNGGetText(1755, vbNullString)   'S&ervicios
  
  Set m_Host = Host
  
  m_Host.Server.AddMenu str_1755, csMenuProyecto, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(1850, vbNullString), csPreTickListParteReparacion, str_1755, 0, True, False, False, False, False, Me
                        '&Parte de Reparación
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
#If PREPROC_SFS Then
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", "CSTicket.cParteReparacion", "CSABMInterface2.CABMGenericListDoc", "CSTicket.cParteReparacionListDoc", Me, LNGGetText(1843, vbNullString), 0
#Else
  m_Host.MenuListDocClick "CSABMInterface2.CABMGenericDocEx", "CSTicket.cParteReparacion", "CSABMInterface2.CABMGenericListDoc", "CSTicket.cParteReparacionListDoc", Me, LNGGetText(1843, vbNullString), 0
                                                                                                                                                                          'Parte de Reparación
#End If
End Function

Private Function pSaveItems(ByVal Id As Long) As Boolean
  
  ' Generales
  '
  Dim register As cRegister
  Dim iOrden As Long
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  ' Para numeros de serie
  '
  Dim iOrden2     As Long
  Dim Grupo       As Long
  Dim PrId        As Long
  
  For Each Row In m_Items.Properties(c_Items).Grid.Rows
  
    Set register = New cRegister
    register.fieldId = cscPrpiTMPId
    register.table = csTParteReparacionItemTMP
    register.Id = csNew
    
    For Each Cell In Row
      Select Case Cell.key
        
        Case KI_PRPI_ID
          If m_Copy Then
            register.Fields.Add2 cscPrpiId, csNew, csInteger
          Else
            register.Fields.Add2 cscPrpiId, Val(Cell.Value), csInteger
          End If
        Case KI_CANTIDAD
          register.Fields.Add2 cscPrpiCantidad, Cell.Value, csDouble
        Case KI_DESCRIP
          register.Fields.Add2 cscPrpiDescrip, Cell.Value, csText
        Case KI_PRECIO
          register.Fields.Add2 cscPrpiPrecio, Cell.Value, csCurrency
        Case KI_PRECIO_LP
          register.Fields.Add2 cscPrpiPrecioLista, Cell.Value, csCurrency
        Case KI_PRECIO_USR
          register.Fields.Add2 cscPrpiPrecioUsr, Cell.Value, csCurrency
        Case KI_DESCUENTO
          register.Fields.Add2 cscPrpiDescuento, Cell.Value, csText
        Case KI_IMPORTE
          register.Fields.Add2 cscPrpiImporte, Cell.Value, csCurrency
        Case KI_NETO
          register.Fields.Add2 cscPrpiNeto, Cell.Value, csCurrency
        Case KI_IVARI
          If m_bIva Then
            register.Fields.Add2 cscPrpiIvari, Cell.Value, csCurrency
          End If
        Case KI_IVARNI
          If m_bIvaRni Then
            register.Fields.Add2 cscPrpiIvarni, Cell.Value, csCurrency
          End If
        Case KI_IVARIPercent
          register.Fields.Add2 cscPrpiIvariporc, Cell.Value, csDouble
        Case KI_IVARNIPercent
          register.Fields.Add2 cscPrpiIvarniporc, Cell.Value, csDouble
        Case KI_PR_ID
          PrId = Cell.Id
          register.Fields.Add2 cscPrId, PrId, csId
        Case KI_CCOS_ID
          register.Fields.Add2 cscCcosId, Cell.Id, csId
        Case KI_GRUPO
          Grupo = Cell.Id
      
        ' Lote
        '
        Case KI_STL_ID
          register.Fields.Add2 cscStlId, Cell.Id, csId
      End Select
    Next
    
    iOrden = iOrden + 1
    register.Fields.Add2 cscPrpiOrden, iOrden, csInteger
    register.Fields.Add2 cscPrpTMPId, Id, csId
    
    register.Fields.HaveLastUpdate = False
    register.Fields.HaveWhoModify = False
    
    If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
  
    ' Si es nuevo se usa el orden
    If Grupo = 0 Then Grupo = iOrden * -1
    If Not pSaveItemNroSerie(Row, iOrden2, PrId, Id, register.Id, Grupo) Then Exit Function
  Next
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeleted) And m_Id <> csNO_ID And Not m_Copy Then
  
    Dim vDeletes As Variant
    Dim i As Long
    
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    vDeletes = Split(m_ItemsDeleted, ",")
    
    For i = 0 To UBound(vDeletes)
    
      Set register = New cRegister
      register.fieldId = cscPrpibTMPId
      register.table = csTParteReparacionItemBorradoTMP
      register.Id = csNew
      
      register.Fields.Add2 cscPrpiId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscPrpId, m_Id, csId
      register.Fields.Add2 cscPrpTMPId, Id, csId
      
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
    .Item(cscPrpSubtotal).Value = Neto
    
    Desc1 = m_ObjAbm.Properties(cscPrpDescuento1).Value
    Desc2 = m_ObjAbm.Properties(cscPrpDescuento2).Value
    
    IvaRi = IvaRi - (IvaRi * Desc1 / 100)
    IvaRni = IvaRni - (IvaRni * Desc1 / 100)
    
    IvaRi = IvaRi - (IvaRi * Desc2 / 100)
    IvaRni = IvaRni - (IvaRni * Desc2 / 100)
    
    Desc1 = Neto * Desc1 / 100
    .Item(cscPrpImportedesc1).Value = Desc1
    
    Neto = Neto - Desc1
    
    Desc2 = Neto * Desc2 / 100
    .Item(cscPrpImportedesc2).Value = Desc2
    
    Neto = Neto - Desc2
    
    .Item(cscPrpNeto).Value = Neto
    .Item(cscPrpIvari).Value = IvaRi
    .Item(cscPrpIvarni).Value = IvaRni
    .Item(cscPrpTotal).Value = Neto + IvaRni + IvaRi
  End With
  
  m_Footer.RefreshControls
End Sub

Private Sub pSetTasasImpositivas(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal pr_id As Long, ByVal pr_nombre As String)
  Dim ti_ri    As Long
  Dim ti_rni   As Long
  Dim ti_ri2   As Long
  Dim ti_rni2  As Long
  
  If pr_id = 0 Then Exit Sub
  
  If Not GetTasaFromProducto(pr_id, ti_ri, ti_rni, False) Then Exit Sub
  
  If ti_ri = 0 Or ti_rni = 0 Then
    If Not GetTasaFromProducto(pr_id, ti_ri2, ti_rni2, True) Then Exit Sub
    
    If ti_ri = 0 Then ti_ri = ti_ri2
    If ti_rni = 0 Then ti_rni = ti_rni2
  End If
  
  If ti_ri = 0 Then
    MsgWarning LNGGetText(1597, vbNullString, pr_nombre)
    'El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de ventas para el iva responsable inscripto
    Exit Sub
  End If
  
  If ti_rni = 0 Then
    MsgWarning LNGGetText(1598, vbNullString, pr_nombre)
    'El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de ventas para el iva responsable no inscripto"
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

' Reglas del Objeto de Negocios
Private Sub pSetDataProducto(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                             ByVal pr_id As Long)
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim bEsKit  As Boolean
  
  Dim bChanged As Boolean
  
  bChanged = pr_id <> pCell(Row, KI_PR_ID).Id
  
  sqlstmt = "sp_StockProductoGetData " & pr_id & "," & pGetCliId() & ",Null"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
    bEsKit = gDB.ValField(rs.Fields, cscPrEskit)
    
    pCell(Row, KI_UNIDAD).Value = gDB.ValField(rs.Fields, "unidadVenta")
    
    ' Si el documento no mueve stock no se exigen los numeros de serie
    '
    If m_bShowStockData Then
      pCell(Row, KI_PR_LLEVANROSERIE).Id = gDB.ValField(rs.Fields, cscPrLlevaNroSerie)
      
      ' Lote
      '
      pCell(Row, KI_PR_LLEVALOTE).Id = gDB.ValField(rs.Fields, cscPrLlevaNroLote)
      
      ' Lote Fifo
      '
      pCell(Row, KI_PR_LOTEFIFO).Id = gDB.ValField(rs.Fields, cscPrLoteFifo)
    
    Else
      pCell(Row, KI_PR_LLEVANROSERIE).Id = False
      
      ' Lote
      '
      pCell(Row, KI_PR_LLEVALOTE).Id = False
    
      ' Lote Fifo
      '
      pCell(Row, KI_PR_LOTEFIFO).Id = False
    End If
    
    pCell(Row, KI_ES_KIT).Id = bEsKit
  
    If bEsKit Then
    
      Dim coll    As Collection
    
      sqlstmt = "sp_StockProductoGetKitInfo " & pr_id
      If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
      
      Set coll = GetCollKitInfoXPrId(pr_id, m_CollKitInfo)
      
      While Not rs.EOF
        pr_id = gDB.ValField(rs.Fields, cscPrId)
        With GetKitInfoItem(coll, pr_id)
          .pr_id = pr_id
          .Nombre = gDB.ValField(rs.Fields, cscPrNombreCompra)
          .Cantidad = gDB.ValField(rs.Fields, "cantidad")
          .LlevaNroSerie = gDB.ValField(rs.Fields, cscPrLlevaNroSerie)
        End With
        rs.MoveNext
      Wend
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
    If Prop.key <> K_DOC_ID _
       And Prop.key <> K_NUMERO _
       And Prop.key <> K_EST_ID _
       And Prop.key <> K_PRODUCTOSERIE _
       And Prop.key <> K_HIDECOLS Then ' HIDECOLS
       
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
  
#If PREPROC_SFS Then
  Dim AbmGen  As cABMGeneric
#Else
  Dim AbmGen  As cABMGenericDocEx
#End If
  
  If bState Then
    
    With m_ObjAbm.Properties.Item(cscDeplIdOrigen)
      
      .Enabled = m_bShowStockData
      
      If m_bShowStockData Then
      
        If .HelpId = csNO_ID Then
          ' Preferencias del usuario
          '
          .HelpId = m_UserCfg.DeplId
          .Value = m_UserCfg.DeplNombre
            
           Set AbmGen = m_ObjAbm
           AbmGen.ShowValue m_ObjAbm.Properties.Item(cscDeplIdOrigen)
        End If
      End If
    End With
    
    With m_ObjAbm.Properties
      .Item(cscPrpEstado).Enabled = .Item(cscPrpTipo).ListItemData = csE_Presupuesto
    End With
  End If
  
  For Each Prop In m_Items.Properties
    Prop.Enabled = bState
  Next
  
  Set AbmGen = m_Items
  AbmGen.RefreshEnabledState m_Items.Properties

  Set AbmGen = m_ObjAbm
  AbmGen.RefreshEnabledState m_ObjAbm.Properties
End Sub

Private Sub pSetDatosSerie()
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  With m_ObjAbm.Properties.Item(cscPrnsId)
    If m_LastSerie = .HelpId Then
      Exit Sub
    End If
    m_LastSerie = .HelpId
  End With
  
  sqlstmt = "sp_productoNumeroSerieGetData " & m_LastSerie
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  Dim cli_id        As Long
  Dim cont_id       As Long
  Dim Us_id         As Long
  Dim Cliente       As String
  Dim Contacto      As String
  Dim Usuario       As String
  Dim serie_descrip As String
  Dim serie2        As String
  
  Dim iProp         As cIABMProperty
  
  If Not rs.EOF Then
    cli_id = gDB.ValField(rs.Fields, cscCliId)
    cont_id = gDB.ValField(rs.Fields, cscContId)
    Us_id = gDB.ValField(rs.Fields, cscUsId)
    
    Cliente = gDB.ValField(rs.Fields, cscCliNombre)
    Contacto = gDB.ValField(rs.Fields, cscContNombre)
    Usuario = gDB.ValField(rs.Fields, cscUsNombre)
    serie2 = gDB.ValField(rs.Fields, cscPrnsCodigo2)
    serie_descrip = gDB.ValField(rs.Fields, "serie_descrip")
  End If
  
  With m_ObjAbm.Properties
    
    Set iProp = .Item(cscCliId)
    With iProp
      .HelpId = cli_id
      .Value = Cliente
    End With
    m_ObjAbm.ShowValue iProp
    
    Set iProp = .Item(cscContId)
    With iProp
      .HelpId = cont_id
      .Value = Contacto
    End With
    m_ObjAbm.ShowValue iProp
    
    Set iProp = .Item(cscUsId)
    With iProp
      .HelpId = Us_id
      .Value = Usuario
    End With
    m_ObjAbm.ShowValue iProp
    
    Set iProp = .Item(cscPrId)
    With iProp
      .Value = serie_descrip
    End With
    m_ObjAbm.ShowValue iProp
    
    If m_TicketConfig.CopiarPrns2EnPrpNroDoc Then
    
      Set iProp = .Item(cscPrpNrodoc)
      With iProp
        .Value = serie2
      End With
      m_ObjAbm.ShowValue iProp
    End If
    
  End With
  
  pSetDatoscliente
  
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
  
  With m_ObjAbm.Properties.Item(cscCliId)
    If m_Lastcli = .HelpId Then
      Exit Sub
    End If
    m_Lastcli = .HelpId
  End With

  If Not GetClienteDataEx2(m_Lastcli, _
                          lp_id, _
                          ld_id, _
                          cpg_id, _
                          csNO_ID, csNO_ID, csNO_ID, _
                          vbNullString, vbNullString, vbNullString, _
                          m_LastDoc) Then Exit Sub

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
  
'////////////////////////////////////////////////////////////
  Set iProp = m_ObjAbm.Properties.Item(cscClisId)
  With iProp
    .HelpFilter = GetHelpFilterCliSuc(m_Lastcli)
  End With
  
  m_ObjAbm.ShowValue iProp
'////////////////////////////////////////////////////////////
  
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
    pShowTotales m_Items.Properties(c_Items).Grid.Rows
  End If
End Sub

Private Function pMove(ByVal MoveTo As ABM_MSG) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim doc_id  As Long
  
  doc_id = m_ObjAbm.Properties(cscDocId).HelpId
  
  If doc_id = csNO_ID Then MsgInfo LNGGetText(1595, vbNullString)  'Debe seleccionar un documento
  
  sqlstmt = "sp_DocParteReparacionMover " & MoveTo & "," & m_Numero & "," & doc_id
  
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
        
        m_LastSerie = csNO_ID
        
        ' Cargo un registro vacio
        '
        Load csNO_ID
        
        ' Refresco el formulario
        '
        pRefreshProperties
        
        ' Obtengo un nuevo numero de comprobante
        '
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscPrpNrodoc
    
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
    
    Set c = .Item(cscPrpFecha)
    c.Value = m_Fecha
    
    Set c = .Item(cscPrpFechaentrega)
    c.Value = m_Fechaentrega
    
    Set c = .Item(cscCliId)
    c.HelpId = m_cli_id
    c.Value = m_Cliente
    
    Set c = .Item(csDocNumberID)
    c.Value = m_Numero
    
    Set c = .Item(csDocEstateID)
    c.Value = m_Estado
    
    Set c = .Item(cscPrpNrodoc)
    c.Value = m_Nrodoc
    c.TextMask = m_TaMascara
    c.TextAlign = vbRightJustify
    
    Set c = .Item(cscPrpDescuento1)
    c.Value = m_Descuento1
    
    Set c = .Item(cscPrpDescuento2)
    c.Value = m_Descuento2
    
    Set c = .Item(cscDeplIdOrigen)
    If m_depl_id <> csNO_ID Or Not m_bShowStockData Then
      c.HelpId = m_depl_id
      c.Value = m_deposito
    Else
      ' Preferencias del usuario
      '
      c.HelpId = m_UserCfg.DeplId
      c.Value = m_UserCfg.DeplNombre
      pSetStock
    End If
    
    Set c = .Item(cscCpgId)
    c.HelpId = m_cpg_id
    c.Value = m_CondicionPago
    
    Set c = .Item(cscPrpCotizacion)
    c.Value = m_Cotizacion
    
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
    
    Set c = .Item(cscUsId)
    c.HelpId = m_us_id
    c.Value = m_usuario
    
    Set c = .Item(cscPrpDescrip)
    c.Value = m_Descrip
  
    Set c = .Item(cscLgjId)
    c.HelpId = m_lgj_id
    c.Value = m_Legajo
    
    Set c = .Item(cscPrnsId)
    c.HelpId = m_prns_id
    c.Value = m_serie
    
    Set c = .Item(cscPrId)
    c.Value = m_ProductoSerie
    
    Set c = .Item(cscPrpTipo)
    c.ListItemData = m_Tipo
    
    Set c = .Item(cscPrpEstado)
    c.ListItemData = m_prp_estado
    
    Set c = .Item(cscClisId)
    c.HelpId = m_clis_id
    c.Value = m_ClienteSucursal
    
    Set c = .Item(cscContId)
    c.HelpId = m_cont_id
    c.Value = m_contacto
    
  End With
  
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValues m_ObjAbm.Properties
  
  AbmGen.ResetChanged
  
  Set c = m_Items.Properties.Item(c_Items)
  If Not pLoadItems(c) Then Exit Sub
  
  m_ItemsDeleted = vbNullString
  
  Set AbmGen = m_Items
  AbmGen.ShowValues m_Items.Properties
  
  With m_Footer.Properties
  
    Set c = .Item(cscPrpSubtotal)
    c.Value = m_SubTotal
    
    Set c = .Item(cscPrpImportedesc1)
    c.Value = m_ImporteDesc1
    
    Set c = .Item(cscPrpImportedesc2)
    c.Value = m_ImporteDesc2
    
    Set c = .Item(cscPrpNeto)
    c.Value = m_Neto
    
    Set c = .Item(cscPrpIvari)
    c.Value = m_Ivari
    
    Set c = .Item(cscPrpIvarni)
    c.Value = m_Ivarni
    
    Set c = .Item(cscPrpTotal)
    c.Value = m_Total
  End With
  
  Set AbmGen = m_Footer
  AbmGen.ShowValues m_Footer.Properties
  
  pSetEnabled

  pShowCotizacion

End Sub

' Construccion - Destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2293, vbNullString)  'Error al grabar el Parte de Reparación
  
  Set m_NrosSerie = New Collection
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  ' Lote
  '
  Set m_StockConfig = New cStockConfig
  m_StockConfig.Load
  
  ' Servicios
  Set m_TicketConfig = New cTicketConfig
  m_TicketConfig.Load
  
  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load
  m_UserCfg.ValidatePRP
  
  ReDim m_PrnsIds(0)

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
  ReDim m_PrnsIds(0)
  CollClear m_NrosSerie
  Set m_NrosSerie = Nothing
  Set m_GeneralConfig = Nothing
  
  ' Lote
  '
  Set m_StockConfig = Nothing
  
  ' Servicios
  '
  Set m_TicketConfig = Nothing
  
  ' Preferencias del Usuario
  '
  Set m_UserCfg = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pUpdateAprobado()
  Dim iProp As cIABMProperty
  With m_ObjAbm.Properties
  
    If .Item(cscPrpTipo).ListItemData = csE_Reparacion Then
      Set iProp = .Item(cscPrpEstado)
      iProp.ListItemData = csE_PrpAprobado
      m_ObjAbm.ShowValue iProp
    End If
  End With
End Sub

Private Sub pSetShowStockData()
  With m_ObjAbm.Properties
    If .Item(cscPrpTipo).ListItemData = csE_Reparacion Then
      m_bShowStockData = .Item(cscPrpEstado).ListItemData = csE_PrpAprobado
    Else
      m_bShowStockData = False
    End If
  End With
End Sub

Private Sub pSetNrosSerieInRow(ByVal CurrGroup As Long, ByVal NroSerie As String)
  Dim Row As cIABMGridRow
  
  If CurrGroup = 0 Then Exit Sub
  
  For Each Row In m_Items.Properties(c_Items).Grid.Rows
    If pCell(Row, KI_GRUPO).Id = CurrGroup Then
      pCell(Row, KI_NROSERIE).Value = RemoveLastColon(NroSerie)
      Exit Sub
    End If
  Next
End Sub

'///////////////////////////////////////////////////////////////////////////////////////////////////////////
Private Function pSaveItemNroSerie(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                   ByRef iOrden As Long, _
                                   ByVal PrId As Long, _
                                   ByVal PrpTMPId As Long, _
                                   ByVal PrpiTMPId As Long, _
                                   ByVal Grupo As Long) As Boolean
                                   
  Dim pt        As cProductoSerieType
  Dim register  As cRegister
  
  ' Si lleva numero de serie
  '
  If pCell(Row, KI_PR_LLEVANROSERIE).Id And m_bShowStockData Then
  
    ' Obtengo los numeros de serie y guardo un Item por cada uno
    '
    For Each pt In m_NrosSerie.Item(GetKey(Grupo))
      
      Set register = New cRegister
      register.fieldId = cscPrpisTMPId
      register.table = csTParteReparacionItemSerieTMP
      register.Id = csNew
      
      register.Fields.Add2 cscPrId, PrId, csId
      
      If m_Copy Then
        register.Fields.Add2 cscPrnsId, csNew, csInteger
      Else
        register.Fields.Add2 cscPrnsId, pt.prns_id, csId
      End If
      
      register.Fields.Add2 cscPrnsCodigo, pt.Codigo, csText
      register.Fields.Add2 cscPrnsDescrip, pt.descrip, csText
      register.Fields.Add2 cscPrnsFechavto, pt.FechaVto, csDate
      register.Fields.Add2 cscPrIdItem, pt.pr_id_item, csId
      
      register.Fields.Add2 cscPrpTMPId, PrpTMPId, csId
      register.Fields.Add2 cscPrpiTMPId, PrpiTMPId, csId
      
      iOrden = iOrden + 1
      register.Fields.Add2 cscPrpisOrden, iOrden, csInteger
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSaveItemNroSerie", C_Module, c_ErrorSave) Then Exit Function
    Next
  End If
  
  pSaveItemNroSerie = True
End Function

'////////////////////////////////////////////////////////////////////////////////////////////////
' nrs devolucion
Private Function pGetDeplId() As Long
  pGetDeplId = m_ObjAbm.Properties(cscDeplIdOrigen).HelpId
End Function

Private Function pGetCliId() As Long
  pGetCliId = m_ObjAbm.Properties(cscCliId).HelpId
End Function

Private Function pGetFecha() As Date
  pGetFecha = m_ObjAbm.Properties.Item(cscPrpFecha).Value
End Function

Private Sub pSetStock()

  If m_StockConfig.StockXFisico Or m_StockConfig.NoControlaStock Then
    
    m_depf_id = csNO_ID
    
    If Not gDB.GetData(csTDepositoLogico, _
                       cscDeplId, _
                       pGetDeplId(), _
                       cscDepfId, _
                       m_depf_id) Then
    End If
  End If

End Sub

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

Private Function pGetPrpIdFromPrnsId(ByVal PrnsId As Long) As Long

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_ParteReparacionGetFromPrnsId " & PrnsId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  pGetPrpIdFromPrnsId = gDB.ValField(rs.Fields, 0)
  
End Function

Private Function pGetPrnsId() As cIABMProperty
  Set pGetPrnsId = m_ObjAbm.Properties.Item(cscPrnsId)
End Function
