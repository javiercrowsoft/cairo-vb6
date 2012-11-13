VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPackingList"
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
' cPackingList
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
Private Const C_Module = "cPackingList"

Private Const c_Items = "ITEMS"

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
Private Const K_PALLETS                        As Integer = 25
Private Const K_PUE_ID_ORIGEN                  As Integer = 26
Private Const K_PUE_ID_DESTINO                 As Integer = 27
Private Const K_BARC_ID                        As Integer = 28
Private Const K_CANTIDAD                       As Integer = 29
Private Const K_MARCAS                         As Integer = 30

Private Const KI_PKLSTI_ID                      As Integer = 2
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

Private Const KI_PALLETS                        As Integer = 23
Private Const KI_CAJA_DESDE                     As Integer = 24
Private Const KI_CAJA_HASTA                     As Integer = 25
Private Const KI_GRUPO_EXPO                     As Integer = 26
Private Const KI_PESO_NETO                      As Integer = 27
Private Const KI_PESO_TOTAL                     As Integer = 28
Private Const KI_UNIDAD_PESO                    As Integer = 29

' Seudo - Variables
Private c_ErrorSave       As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Numero                       As Long
Private m_Estado                       As String
Private m_est_id                       As Long
Private m_Nrodoc                       As String
Private m_Descrip                      As String
Private m_Marca                        As String
Private m_Fecha                        As Date
Private m_Fechaentrega                 As Date
Private m_Neto                         As Double
Private m_Ivari                        As Double
Private m_Ivarni                       As Double
Private m_Total                        As Double
Private m_Pallets                      As Double
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
Private m_Cantidad                     As Long

Private m_Barc_id                      As Long
Private m_Barco                        As String

Private m_pue_id_origen                As Long
Private m_PuertoOrigen                 As String

Private m_pue_id_destino               As Long
Private m_PuertoDestino                As String

Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_Firmado                      As Boolean

Private m_Editing           As Boolean

Private m_Footer            As cIABMGeneric
Private m_Items             As cIABMGeneric
Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_LastDoc           As Long
Private m_LastCli           As Long
Private m_LastDocName       As String
Private m_LastCliName       As String

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost

Private m_ItemsDeleted      As String

Private m_Copy              As Boolean

Private m_GeneralConfig     As cGeneralConfig
Private m_ExpoConfig        As cExportConfig

Private m_DocEditable       As Boolean
Private m_DocEditMsg        As String

Private m_PvIds()           As Long
Private m_MfcIds()          As Long

Private m_bIva              As Boolean
Private m_bIvaRni           As Boolean

Private m_TaPropuesto       As Boolean
Private m_TaMascara         As String

Private m_ObjApply          As cPackingListAplic

Private m_bPrecio           As Boolean

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

Public Function TerminateWizard(ByVal ID As Long)
  On Error Resume Next
  If ID <> csNO_ID Then
    cIEditGeneric_Edit ID
  End If
End Function

Public Sub ShowPackingManifiesto(ByVal CliId As Long, ByRef vMfcIds() As Long)
  On Error GoTo ControlError

  m_cli_id = CliId
  gDB.GetData csTCliente, cscCliId, CliId, cscCliNombre, m_Cliente
  
  Dim i As Long
  ReDim m_MfcIds(UBound(vMfcIds) + 1)
  For i = 1 To UBound(vMfcIds) + 1
    m_MfcIds(i) = vMfcIds(i - 1)
  Next
  
  If Not pInitMembers Then
    Exit Sub
  End If
  
  pShowStartWizardManifiesto

  GoTo ExitProc
ControlError:
  MngError Err, "ShowPackingManifiesto", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub ShowPackingPedido(ByVal CliId As Long, ByRef vPvIds() As Long)
  On Error GoTo ControlError

  m_cli_id = CliId
  gDB.GetData csTCliente, cscCliId, CliId, cscCliNombre, m_Cliente
  
  Dim i As Long
  ReDim m_PvIds(UBound(vPvIds) + 1)
  For i = 1 To UBound(vPvIds) + 1
    m_PvIds(i) = vPvIds(i - 1)
  Next
  
  If Not pInitMembers Then
    Exit Sub
  End If
  
  pShowStartWizard

  GoTo ExitProc
ControlError:
  MngError Err, "ShowPackingPedido", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pInitMembers() As Boolean
  Set cIEditGeneric_ObjAbm = New cABMGeneric
  Set cIEditGenericDoc_Footer = New cABMGeneric
  Set cIEditGenericDoc_Items = New cABMGeneric
  
  If Not DocSecurityCanAccess(csPreExpNewPackingList, _
                              csNO_ID, _
                              csEDocTPreNew) Then
    Exit Function
  End If
  pInitMembers = True
End Function

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  If Not DocSecurityCanAccessEx(csPreExpNewPackingList, _
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscPklstNrodoc
  pSetEnabled
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True

  If Not m_DocEditable Then
    If LenB(m_DocEditMsg) Then
      MsgWarning m_DocEditMsg
    End If
  End If
  
  If m_ObjAbm.Properties.Item(cscDocId).HelpId = csNO_ID Then
    MsgInfo LNGGetText(1562, vbNullString)  'Debe indicar un documento
  End If
  
  cIEditGeneric_Edit csNO_ID

  ' Obtengo el numero para este comprobante
  '
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscPklstNrodoc
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

  Doc.ClientTable = csTPackingList
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
      pShowTotales m_Items.Properties(c_Items).Grid.Rows
    
    Case MSG_DOC_EDIT_STATE
      ShowEditState m_DocEditMsg, LNGGetText(2516, vbNullString) 'PackingLists de Ventas
      
    Case MSG_DOC_DELETE
      If cIEditGeneric_Delete(m_Id) Then
        cIABMClient_MessageEx = True
        pMove MSG_DOC_NEXT
      End If
    
    Case MSG_DOC_APPLY
      pShowApply
    
    Case MSG_DOC_ANULAR
      DocAnular m_Id, m_est_id, m_Estado, csPreExpAnularPackingList, csPreExpDesAnularPackingList, m_ObjAbm, m_DocEditable, m_DocEditMsg, "sp_DocPackingListAnular", "sp_DocPackingListEditableGet"
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
      DocumentSearch csEDT_PackingList, Me, Not CBool(Info)
  
    Case MSG_DOC_DOC_ACTION
    
      If m_Id Then
        pShowFactura
      Else
        MsgInfo LNGGetText(1556, vbNullString)
                'Esta opción solo sirve para modificar documentos guardados y aplicados
      End If
    
    Case MSG_DOC_HISTORY
    
      If m_Id <> csNO_ID Then
    
        ShowHistory csPackingList, m_Id, m_Documento & " " & m_Nrodoc
      Else
        
        MsgInfo LNGGetText(1552, vbNullString) ' El documento aun no ha sido guardado
      End If
  
    Case MSG_EXPORT_GET_EMAIL
    
      With m_ObjAbm.Properties.Item(cscCliId)
        cIABMClient_MessageEx = GetEmailFromCliente(.HelpId)
      End With
  
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
  
  Select Case Key
    
    Case K_DOC_ID
      
      ' Si cambio de documento
      '
      If DocChange(m_ObjAbm, m_LastDoc, m_LastDocName) Then
        
        ' Si cambie de documento y estaba en un comprobante ya guardado
        ' tengo que mostrar el formulario sin datos, para evitar
        ' que presione guardar y le cambie el doc_id al comprobante por error
        '
        If m_Id <> csNO_ID And m_doc_id <> m_LastDoc Then cIEditGeneric_Edit csDocChanged
        
        ' Obtengo el numero para este comprobante
        '
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscPklstNrodoc
      
      End If

      ' Defino el estado de edicion del comprobante
      '
      pSetEnabled

    Case K_CLI_ID
    
      pSetDatosCliente
      
    Case K_DESCUENTO1, K_DESCUENTO2
      pShowTotales m_Items.Properties(c_Items).Grid.Rows
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  
  ' Save and State
  '
  If Not DocCanEdit(m_DocEditable, m_DocEditMsg) Then
    cIABMClient_Save = True
    Exit Function
  End If
  If Not DocCanSave(m_ObjAbm, cscPklstFecha) Then
    cIABMClient_Save = False
    Exit Function
  End If
  
  If pGetItems().Grid.Rows.Count = 0 Then
    MsgWarning LNGGetText(3903, vbNullString) 'El documento debe contener al menos un item
    cIABMClient_Save = False
    Exit Function
  End If
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  register.fieldId = cscPklstTMPId
  register.Table = csTPackingListTMP
  
  register.ID = csNew
    
  If m_Copy Then
    register.Fields.Add2 cscPklstId, csNew, csLong
  Else
    register.Fields.Add2 cscPklstId, m_Id, csLong
  End If
  
  If register.ID = csNew Then
    m_est_id = CSGeneralEx2.csEEstado.csEEst_Pendiente
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NUMERO
          register.Fields.Add2 cscPklstNumero, .Value, csLong
        Case K_NRODOC
          register.Fields.Add2 cscPklstNrodoc, .Value, csText
        Case K_DESCRIP
          register.Fields.Add2 cscPklstDescrip, .Value, csText
        Case K_MARCAS
          register.Fields.Add2 cscPklstMarca, .Value, csText
        Case K_FECHA
          register.Fields.Add2 cscPklstFecha, .Value, csDate
        Case K_FECHAENTREGA
          register.Fields.Add2 cscPklstFechaEntrega, .Value, csDate
        Case K_CLI_ID
          register.Fields.Add2 cscCliId, .HelpId, csId
        Case K_CCOS_ID
          register.Fields.Add2 cscCcosId, .HelpId, csId
        Case K_SUC_ID
          register.Fields.Add2 cscSucId, .HelpId, csId
        Case K_DESCUENTO1
          register.Fields.Add2 cscPklstDescuento1, .Value, csCurrency
        Case K_DESCUENTO2
          register.Fields.Add2 cscPklstDescuento2, .Value, csCurrency
        Case K_DOC_ID
          register.Fields.Add2 cscDocId, .HelpId, csId
        Case K_LP_ID
          register.Fields.Add2 cscLpId, .HelpId, csId
        Case K_LD_ID
          register.Fields.Add2 cscLdId, .HelpId, csId
        Case K_CPG_ID
          register.Fields.Add2 cscCpgId, .HelpId, csId
        Case K_PUE_ID_ORIGEN
          register.Fields.Add2 cscPueIdOrigen, .HelpId, csId
        Case K_PUE_ID_DESTINO
          register.Fields.Add2 cscPueIdDestino, .HelpId, csId
        Case K_BARC_ID
          register.Fields.Add2 cscBarcId, .HelpId, csId
      End Select
    End With
  Next
  
  For Each IProperty In m_Footer.Properties
    With IProperty
      Select Case .Key
        Case K_TOTAL
          register.Fields.Add2 cscPklstTotal, .Value, csCurrency
        Case K_NETO
          register.Fields.Add2 cscPklstNeto, .Value, csCurrency
        Case K_IVARI
          register.Fields.Add2 cscPklstIvari, .Value, csCurrency
        Case K_IVARNI
          register.Fields.Add2 cscPklstIvarni, .Value, csCurrency
        Case K_SUBTOTAL
          register.Fields.Add2 cscPklstSubtotal, .Value, csCurrency
        Case K_IMPORTEDESC1
          register.Fields.Add2 cscPklstImportedesc1, .Value, csCurrency
        Case K_IMPORTEDESC2
          register.Fields.Add2 cscPklstImportedesc2, .Value, csCurrency
        Case K_PALLETS
          register.Fields.Add2 cscPklstPallets, .Value, csInteger
        Case K_CANTIDAD
          register.Fields.Add2 cscPklstCantidad, .Value, csInteger
      End Select
    End With
  Next
  
  register.Fields.Add2 cscEstId, m_est_id, csId
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If Not pSaveItems(register.ID) Then Exit Function
  If Not register.CommitTrans() Then Exit Function
  
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DocPackingListSave " & register.ID
  
  If Not gDB.OpenRs(sqlstmt, rs, , , , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim ID As Long
  If Not GetDocIDFromRecordset(rs, ID) Then Exit Function
  
  m_Copy = False
  
  cIABMClient_Save = Load(ID)
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  m_ObjTree.sqlstmt = "sp_lsdoc_PackingList"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
  
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(1602, vbNullString) 'packing list
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
      
        Case K_PUE_ID_ORIGEN
          If ValEmpty(.HelpId, csId) And m_ExpoConfig.SourceDestPk Then
            MsgInfo LNGGetText(2500, vbNullString) 'Debe indicar un puerto origen
            Exit Function
          End If
      
        Case K_PUE_ID_DESTINO
          If ValEmpty(.HelpId, csId) And m_ExpoConfig.SourceDestPk Then
            MsgInfo LNGGetText(2501, vbNullString) 'Debe indicar un puerto destino
            Exit Function
          End If
          
        Case K_BARC_ID
          If ValEmpty(.HelpId, csId) And m_ExpoConfig.ShipPk Then
            MsgInfo LNGGetText(2422, vbNullString) 'Debe indicar un barco
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
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

Private Function cIDocumento_LoadForPrint(ByVal ID As Long) As Boolean
  On Error GoTo ControlError

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select doct_id, doc_id from PackingList where PKLST_id = " & ID
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_Id = ID
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreExpListPackingList)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
  m_ObjAbm.IsDocument = True

#If Not PREPROC_SFS Then
  Dim AbmGen      As cABMGenericDocEx

  Set AbmGen = m_ObjAbm
  With AbmGen
    .FactoryObject = "CSABMInterface2.cFactory"
    .ObjForm = "CSABMInterface2.fPackingList"
  End With
#End If
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(ID As Long) As Boolean
  Dim doc_id As Long
  
  If Not m_ObjAbm Is Nothing Then
    doc_id = GetdocIdFromObjAbm(m_ObjAbm)
  Else
    If Not GetDocIdFromId(ID, _
                          csTPackingList, _
                          cscPklstId, _
                          doc_id) Then
      Exit Function
    End If
  End If
  
  If Not DocSecurityCanAccess( _
                  csPreExpDeletePackingList, _
                  doc_id, _
                  csEDocTPreDelete) Then
    Exit Function
  End If

  Dim sqlstmt As String
  
  sqlstmt = "sp_DocPackingListDelete " & ID & "," & EmpId & "," & User.ID
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not DocSecurityCanAccess(csPreExpListPackingList, GetdocIdFromObjAbm(m_ObjAbm), csEDocTPreList) Then Exit Function
                     
                            ' Id = csDocChanged esto significa que se cambio
                            '                   el documento estando en un
                            '                   comprobante ya guardado
                            '
  m_IsNew = ID = csNO_ID Or ID = csDocChanged

  ' Solo muestro asistentes si el nuevo no se esta dando por
  ' un cambio de documento
  '
  If ID <> csDocChanged And m_IsNew And pDocDesdePedido() Then
      
    pShowStartWizard
    
  ElseIf ID <> csDocChanged And m_IsNew And pDocDesdeManifiesto() Then
      
    pShowStartWizardManifiesto
    
  Else
    
    If Not Load(ID) Then Exit Function
    
    If m_ObjAbm.Properties.Count = 0 Then
      If Not LoadCollection() Then Exit Function
    Else
      pRefreshProperties
    End If

  End If
  
  m_Editing = True
  m_Copy = False
  
  cIEditGeneric_Edit = True
  Exit Function
ControlError:
  MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal ID As Long) As Boolean

End Function

Private Property Set cIEditGeneric_ObjTree(rhs As Object)
    Set m_ObjTree = rhs
End Property

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)
    m_BranchId = rhs
End Property

Private Property Get cIEditGeneric_BranchId() As Long
    cIEditGeneric_BranchId = m_BranchId
End Property

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Function cIEditGeneric_Preview(ByVal ID As Long) As Boolean

End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  On Error GoTo ControlError
  
  Select Case Key
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

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
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

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  On Error GoTo ControlError

  Select Case Key
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

Private Function pColumnBeforeEdit(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
  pColumnBeforeEdit = True
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
  
  Select Case IProperty.Grid.Columns(lCol).Key
    Case KI_PR_ID
      Set Row = IProperty.Grid.Rows(lRow)
      pSetDataProducto Row, NewValueID
      pSetPrecios Row, NewValueID
      pSetDescuentos Row, NewValueID, pGetPrecioFromRow(Row)
      pSetTasasImpositivas Row, NewValueID, NewValue
      
    Case KI_PRECIO_USR
      Set Row = IProperty.Grid.Rows(lRow)
      pSetDescuentos Row, pCell(Row, KI_PR_ID).ID, NewValue
      
  End Select
  
  pColumnAfterEdit = True
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
  Dim ID As Long
  
  ID = Val(pCell(Row, KI_PKLSTI_ID).Value)
  
  If ID <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & ID & ","
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
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
    Select Case Cell.Key
      Case KI_CANTIDAD
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_PRECIO
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_PR_ID
        If Not ValEmpty(Cell.ID, csId) Then
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
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CANTIDAD
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(1365, vbNullString, strRow) 'Debe indicar una cantidad (1)
          Exit Function
        End If
      Case KI_PRECIO
        If ValEmpty(Cell.Value, csCurrency) And m_ExpoConfig.EditPricePk Then
          MsgInfo LNGGetText(1631, vbNullString, strRow) 'Debe indicar un precio (1)
          Exit Function
        End If
      Case KI_PR_ID
        If ValEmpty(Cell.ID, csId) Then
          MsgInfo LNGGetText(1565, vbNullString, strRow) 'Debe indicar un producto de venta (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRow = True
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim Filter  As String
  Dim iTab    As cIABMTabItem
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
  m_ObjAbm.Properties.Clear

  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = 0
  iTab.Name = C_strGeneral
  
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = 1
  iTab.Name = LNGGetText(1566, vbNullString) 'Adicionales
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscDocId)
  c.PropertyType = cspHelp
  c.Table = CSDocumento2.CSDocumento
  c.Name = LNGGetText(1567, vbNullString) 'Documento
  c.Key = K_DOC_ID
      
  If m_doc_id <> csNO_ID Then
    c.HelpId = m_doc_id
    c.Value = m_Documento
  Else
    ' Preferencias del usuario
    '
    c.HelpId = m_UserCfg.DocPklstId
    c.Value = m_UserCfg.DocPklstNombre
    
    bValidateDocDefault = c.HelpId <> csNO_ID
  End If
  
  c.HelpFilter = "'doct_id = " & csEDT_PackingList & "'"
  
  Set c = m_ObjAbm.Properties.Add(Nothing, csDocNumberID)
  c.PropertyType = cspNumeric
  c.SubType = cspInteger
  c.Name = LNGGetText(1065, vbNullString) 'Número
  c.Key = K_NUMERO
  c.Value = m_Numero
  c.Enabled = False
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, csDocEstateID)
  c.PropertyType = cspText
  c.Name = LNGGetText(1568, vbNullString) 'Estado
  c.Key = K_EST_ID
  c.Value = m_Estado
  c.Enabled = False
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPklstFecha)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1569, vbNullString) 'Fecha
  c.LeftLabel = -580
  c.Left = 700
  c.Key = K_FECHA
  c.Value = m_Fecha
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPklstFechaEntrega)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1570, vbNullString) 'Entrega
  c.Key = K_FECHAENTREGA
  c.Value = m_Fechaentrega
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCliId)
  c.PropertyType = cspHelp
  c.Table = csCliente
  c.TopFromProperty = cscPklstFecha
  c.Left = 2700
  c.LeftLabel = -580
  c.Name = LNGGetText(1150, vbNullString) 'Cliente
  c.Key = K_CLI_ID
  c.HelpId = m_cli_id
  c.Value = m_Cliente
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPklstNrodoc)
  c.PropertyType = cspText
  c.Name = LNGGetText(1065, vbNullString) 'Numero
  c.Size = 50
  c.Key = K_NRODOC
  c.Value = m_Nrodoc
  c.TextMask = m_TaMascara
  c.TextAlign = vbRightJustify
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCpgId)
  c.PropertyType = cspHelp
  c.Table = csCondicionPago
  c.Name = LNGGetText(1571, vbNullString) 'Cond. pago
  c.TopFromProperty = cscPklstFecha
  c.Left = 5900
  c.LeftLabel = -900
  c.Key = K_CPG_ID
  c.HelpId = m_cpg_id
  c.Value = m_CondicionPago
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPklstDescuento1)
  c.PropertyType = cspNumeric
  c.SubType = cspPercent
  c.LeftLabel = -600
  c.Name = LNGGetText(1573, vbNullString) 'Desc. 1
  c.Key = K_DESCUENTO1
  c.Value = m_Descuento1
  c.Width = 1000
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPklstDescuento2)
  c.PropertyType = cspNumeric
  c.SubType = cspPercent
  c.TopFromProperty = cscPklstDescuento1
  c.Left = 7150
  c.LeftLabel = -150
  c.Name = "2"
  c.Key = K_DESCUENTO2
  c.Value = m_Descuento2
  c.Width = 1000
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscLpId)
  c.PropertyType = cspHelp
  c.Table = csListaPrecio
  c.Name = LNGGetText(1397, vbNullString) 'Lista de Precios
  
  Filter = "exists(select lp_id from listaprecioCliente where cli_id =" & m_cli_id
  Filter = Filter & " and lp_id = listaprecio.lp_id)"
  
  c.HelpFilter = Filter
  c.TopFromProperty = cscPklstFecha
  c.Left = 9400
  c.Key = K_LP_ID
  c.HelpId = m_Lp_id
  c.Value = m_ListaPrecio
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscLdId)
  c.PropertyType = cspHelp
  c.Table = csListaDescuento
  c.Name = LNGGetText(1398, vbNullString) 'Lista de Descuentos
  
  Filter = "exists(select ld_id from listadescuentoCliente where cli_id =" & m_cli_id
  Filter = Filter & " and ld_id = listadescuento.ld_id)"
  
  c.HelpFilter = Filter
  c.Key = K_LD_ID
  c.HelpId = m_Ld_id
  c.Value = m_ListaDescuento
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCcosId)
  c.PropertyType = cspHelp
  c.Table = csCentroCosto
  c.Name = LNGGetText(1057, vbNullString) 'Centro de Costo
  c.Key = K_CCOS_ID
  c.HelpId = m_ccos_id
  c.Value = m_CentroCosto
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscSucId)
  c.PropertyType = cspHelp
  c.Table = csSucursal
  c.Name = LNGGetText(1281, vbNullString) 'Sucursal
  c.Key = K_SUC_ID
  c.HelpId = m_suc_id
  c.Value = m_Sucursal
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscBarcId)
  c.PropertyType = cspHelp
  c.Table = csBarco
  c.Name = LNGGetText(2424, vbNullString) 'Barco
  c.Key = K_BARC_ID
  c.HelpId = m_Barc_id
  c.Value = m_Barco
  c.TabIndex = 1
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPueIdOrigen)
  c.PropertyType = cspHelp
  c.Table = csPuerto
  c.Name = LNGGetText(2400, vbNullString) 'Puerto origen
  c.Key = K_PUE_ID_ORIGEN
  c.HelpId = m_pue_id_origen
  c.Value = m_PuertoOrigen
  c.TabIndex = 1
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPueIdDestino)
  c.PropertyType = cspHelp
  c.Table = csPuerto
  c.Name = LNGGetText(2401, vbNullString) 'Puerto destino
  c.Key = K_PUE_ID_DESTINO
  c.HelpId = m_pue_id_destino
  c.Value = m_PuertoDestino
  c.TabIndex = 1
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPklstDescrip)
  c.PropertyType = cspText
  c.SubType = cspMemo
  c.Name = LNGGetText(1211, vbNullString) 'Observ.
  c.LeftLabel = -600
  c.Size = 5000
  c.Key = K_DESCRIP
  c.Value = m_Descrip
  c.LeftFromProperty = cscPklstFecha
  c.TopFromProperty = cscPklstNrodoc
  c.Width = 3000
  c.Height = 800
  c.TopToPrevious = 440
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPklstMarca)
  c.PropertyType = cspText
  c.SubType = cspMemo
  c.Name = LNGGetText(1310, vbNullString) 'Marca
  c.LeftLabel = -600
  c.Size = 255
  c.Key = K_MARCAS
  c.Value = m_Marca
  c.Left = 4500
  c.TopFromProperty = cscPklstNrodoc
  c.Width = 3000
  c.Height = 800
  c.TopToPrevious = 440
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
      
  m_Items.Tabs.Clear
  
  Set iTab = m_Items.Tabs.Add(Nothing)
  iTab.Index = 0
  iTab.Name = LNGGetText(1371, vbNullString) 'Items
  
  Set AbmGen = m_Items
  AbmGen.ResetLayoutMembers
  m_Items.Properties.Clear
  
  Set c = m_Items.Properties.Add(Nothing, c_Items)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  If Not pLoadItems(c) Then Exit Function
  c.Name = c_Items
  c.Key = K_ITEMS
  c.TabIndex = 0
  c.GridAdd = True
  c.GridEdit = True
  c.GridRemove = True
  
  
  m_ItemsDeleted = vbNullString
  
  If Not m_Items.Show(Me) Then Exit Function
  
  Set AbmGen = m_Footer
  AbmGen.ResetLayoutMembers
  m_Footer.Properties.Clear
  
  Set c = m_Footer.Properties.Add(Nothing, cscPklstPallets)
  c.PropertyType = cspNumeric
  c.SubType = cspInteger
  c.Name = LNGGetText(2510, vbNullString) 'Pallets
  c.Key = K_PALLETS
  c.Value = m_Pallets
  c.Enabled = False
  
  Set c = m_Footer.Properties.Add(Nothing, cscPklstCantidad)
  c.PropertyType = cspNumeric
  c.SubType = cspInteger
  c.Name = LNGGetText(1374, vbNullString) 'Cantidad
  c.Key = K_CANTIDAD
  c.Value = m_Cantidad
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  
  Set c = m_Footer.Properties.Add(Nothing, cscPklstSubtotal)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.Name = LNGGetText(1579, vbNullString) 'Sub Total
  c.Key = K_SUBTOTAL
  c.Value = m_SubTotal
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  
  
  Set c = m_Footer.Properties.Add(Nothing, cscPklstImportedesc1)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.Name = LNGGetText(1573, vbNullString) 'Desc. 1
  c.Key = K_IMPORTEDESC1
  c.Value = m_ImporteDesc1
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  
  
  Set c = m_Footer.Properties.Add(Nothing, cscPklstImportedesc2)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.Name = LNGGetText(1580, vbNullString) 'Desc. 2
  c.Key = K_IMPORTEDESC2
  c.Value = m_ImporteDesc2
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  
  
  Set c = m_Footer.Properties.Add(Nothing, cscPklstNeto)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.Name = LNGGetText(1581, vbNullString) 'Neto
  c.Key = K_NETO
  c.Value = m_Neto
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  
  
  Set c = m_Footer.Properties.Add(Nothing, cscPklstIvari)
  c.PropertyType = cspNumeric
  c.Name = LNGGetText(1582, vbNullString) 'IVA RI
  c.SubType = cspMoney
  c.Key = K_IVARI
  c.Value = m_Ivari
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  
  
  Set c = m_Footer.Properties.Add(Nothing, cscPklstIvarni)
  c.PropertyType = cspNumeric
  c.Name = LNGGetText(1583, vbNullString) 'IVA RNI
  c.SubType = cspMoney
  c.Key = K_IVARNI
  c.Value = m_Ivarni
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  
  
  Set c = m_Footer.Properties.Add(Nothing, cscPklstTotal)
  c.PropertyType = cspNumeric
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Name = LNGGetText(1584, vbNullString) 'Total
  c.SubType = cspMoney
  c.Key = K_TOTAL
  c.Value = m_Total
  c.Enabled = False
  
  
  pSetEnabled
  
  If Not m_Footer.Show(Me) Then Exit Function
  
  ' Preferencias del Usuario
  '
  If bValidateDocDefault Then
    cIABMClient_PropertyChange K_DOC_ID
  End If
  
  LoadCollection = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_DocPackingListGetItems " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  With Propiedad.Grid.Columns
    .Clear
    Propiedad.Grid.Rows.Clear
  
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_PKLSTI_ID
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1367, vbNullString) 'Articulo
    o.PropertyType = cspHelp
    o.Table = csProductoVenta
    o.Width = 1800
    o.Key = KI_PR_ID
    
    Set o = .Add(Nothing)
    o.Name = C_strDescrip
    o.PropertyType = cspText
    o.Width = 1200
    o.Key = KI_DESCRIP
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1374, vbNullString) 'Cantidad
    o.Format = m_GeneralConfig.FormatDecCantidad
    o.PropertyType = cspNumeric
    o.SubType = cspDouble
    o.Width = 1200
    o.Key = KI_CANTIDAD
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1585, vbNullString) 'Descuento
    o.PropertyType = cspNumeric
    o.Format = m_GeneralConfig.FormatDecImporte
    o.SubType = cspMoney
    o.Width = 1200
    o.Key = KI_DESCUENTO
    o.Enabled = False
    o.Visible = m_bPrecio
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1165, vbNullString) 'Unidad
    o.PropertyType = cspText
    o.Width = 1200
    o.Key = KI_UNIDAD
    o.Enabled = False
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1587, vbNullString) 'Precio (LP)
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Format = m_GeneralConfig.FormatDecImporte
    o.Width = 1200
    o.Key = KI_PRECIO_LP
    o.Enabled = False
    o.Visible = m_bPrecio
  
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1586, vbNullString) 'Precio
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Width = 1200
    o.Format = m_GeneralConfig.FormatDecImporte
    o.Key = KI_PRECIO_USR
    o.Visible = m_bPrecio
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1588, vbNullString) 'Precio c/desc.
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Width = 1200
    o.Format = m_GeneralConfig.FormatDecImporte
    o.Key = KI_PRECIO
    o.Enabled = False
    o.Visible = m_bPrecio
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1581, vbNullString) 'Neto
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Format = m_GeneralConfig.FormatDecImporte
    o.Width = 1200
    o.Key = KI_NETO
    o.Enabled = False
    o.Visible = m_bPrecio
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1582, vbNullString) 'IVA RI
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Format = m_GeneralConfig.FormatDecImporte
    o.Width = 1200
    o.Key = KI_IVARI
    o.Enabled = False
    o.Visible = m_bPrecio
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1583, vbNullString) 'IVA RNI
    o.PropertyType = cspNumeric
    o.Format = m_GeneralConfig.FormatDecImporte
    o.SubType = cspMoney
    o.Width = 1200
    o.Key = KI_IVARNI
    o.Enabled = False
    o.Visible = m_bPrecio
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1228, vbNullString) 'Importe
    o.PropertyType = cspNumeric
    o.Format = m_GeneralConfig.FormatDecImporte
    o.SubType = cspMoney
    o.Width = 1200
    o.Key = KI_IMPORTE
    o.Enabled = False
    o.Visible = m_bPrecio
    
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_IVARIPercent
    
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_IVARNIPercent
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(2510, vbNullString) 'Pallets
    o.PropertyType = cspNumeric
    o.SubType = cspInteger
    o.Width = 920
    o.Key = KI_PALLETS
    o.Visible = False ' Por ahora no se usa
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(2517, vbNullString) 'Cj Desde
    o.PropertyType = cspNumeric
    o.SubType = cspInteger
    o.Width = 920
    o.Key = KI_CAJA_DESDE
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(2518, vbNullString) 'Cj Hasta
    o.PropertyType = cspNumeric
    o.SubType = cspInteger
    o.Width = 920
    o.Key = KI_CAJA_HASTA
  
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1404, vbNullString) 'Grupo
    o.PropertyType = cspText
    o.Width = 920
    o.Key = KI_GRUPO_EXPO
  
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1311, vbNullString) 'Peso Neto
    o.PropertyType = cspNumeric
    o.SubType = cspDouble
    o.Width = 920
    o.Key = KI_PESO_NETO
    o.Format = m_GeneralConfig.FormatDecCantidad
  
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1312, vbNullString) 'Peso Total
    o.PropertyType = cspNumeric
    o.SubType = cspDouble
    o.Width = 920
    o.Key = KI_PESO_TOTAL
    o.Format = m_GeneralConfig.FormatDecCantidad
  
    Set o = .Add(Nothing)
    o.Name = LNGGetText(2519, vbNullString) 'Unidad Peso
    o.PropertyType = cspText
    o.Width = 920
    o.Key = KI_UNIDAD_PESO
  
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1057, vbNullString) 'Centro de Costo
    o.PropertyType = cspHelp
    o.Table = csCentroCosto
    o.Width = 1800
    o.Key = KI_CCOS_ID
  End With
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscPklstiId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPklstiId)
    fv.Key = KI_PKLSTI_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPrNombreventa)
    fv.ID = gDB.ValField(rs.Fields, cscPrId)
    fv.Key = KI_PR_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPklstiDescrip)
    fv.Key = KI_DESCRIP
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPklstiCantidad)
    fv.Key = KI_CANTIDAD
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPklstiDescuento)
    fv.Key = KI_DESCUENTO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscUnNombre)
    fv.Key = KI_UNIDAD
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPklstiPrecioLista)
    fv.Key = KI_PRECIO_LP
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPklstiPrecioUsr)
    fv.Key = KI_PRECIO_USR
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPklstiPrecio)
    fv.Key = KI_PRECIO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPklstiNeto)
    fv.Key = KI_NETO

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPklstiIvari)
    fv.Key = KI_IVARI

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPklstiIvarni)
    fv.Key = KI_IVARNI

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPklstiImporte)
    fv.Key = KI_IMPORTE

    Set fv = F.Add(Nothing)
    If m_bIva Then
      fv.Value = gDB.ValField(rs.Fields, "iva_ri_porcentaje")
    Else
      fv.Value = 0
    End If
    fv.Key = KI_IVARIPercent

    Set fv = F.Add(Nothing)
    If m_bIvaRni Then
      fv.Value = gDB.ValField(rs.Fields, "iva_rni_porcentaje")
    Else
      fv.Value = 0
    End If
    fv.Key = KI_IVARNIPercent
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPklstiPallets)
    fv.Key = KI_PALLETS
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPklstiCajaDesde)
    fv.Key = KI_CAJA_DESDE
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPklstiCajaHasta)
    fv.Key = KI_CAJA_HASTA
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPklstiGrupoExpo)
    fv.Key = KI_GRUPO_EXPO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPklstiPesoNeto)
    fv.Key = KI_PESO_NETO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPklstiPesoTotal)
    fv.Key = KI_PESO_TOTAL
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, "unidadPeso")
    fv.Key = KI_UNIDAD_PESO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCcosNombre)
    fv.ID = gDB.ValField(rs.Fields, cscCcosId)
    fv.Key = KI_CCOS_ID
    
    rs.MoveNext
  Wend
  
  pLoadItems = True
End Function

Private Function Load(ByVal ID As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "sp_DocPackingListGet " & EmpId & "," & ID & "," & gDB.UserId
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscPklstId)
    m_Numero = gDB.ValField(rs.Fields, cscPklstNumero)
    m_Nrodoc = gDB.ValField(rs.Fields, cscPklstNrodoc)
    m_Descrip = gDB.ValField(rs.Fields, cscPklstDescrip)
    m_Marca = gDB.ValField(rs.Fields, cscPklstMarca)
    m_Fecha = gDB.ValField(rs.Fields, cscPklstFecha)
    m_Fechaentrega = gDB.ValField(rs.Fields, cscPklstFechaEntrega)
    m_Neto = gDB.ValField(rs.Fields, cscPklstNeto)
    m_Ivari = gDB.ValField(rs.Fields, cscPklstIvari)
    m_Ivarni = gDB.ValField(rs.Fields, cscPklstIvarni)
    m_Total = gDB.ValField(rs.Fields, cscPklstTotal)
    m_Pallets = gDB.ValField(rs.Fields, cscPklstPallets)
    m_Cantidad = gDB.ValField(rs.Fields, cscPklstCantidad)
    m_SubTotal = gDB.ValField(rs.Fields, cscPklstSubtotal)
    m_Descuento1 = gDB.ValField(rs.Fields, cscPklstDescuento1)
    m_Descuento2 = gDB.ValField(rs.Fields, cscPklstDescuento2)
    m_ImporteDesc1 = gDB.ValField(rs.Fields, cscPklstImportedesc1)
    m_ImporteDesc2 = gDB.ValField(rs.Fields, cscPklstImportedesc2)
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
    m_Firmado = gDB.ValField(rs.Fields, cscPklstFirmado)
    m_pue_id_origen = gDB.ValField(rs.Fields, cscPueIdOrigen)
    m_PuertoOrigen = gDB.ValField(rs.Fields, "Puerto Origen")
    m_pue_id_destino = gDB.ValField(rs.Fields, cscPueIdDestino)
    m_PuertoDestino = gDB.ValField(rs.Fields, "Puerto Destino")
    m_Barc_id = gDB.ValField(rs.Fields, cscBarcId)
    m_Barco = gDB.ValField(rs.Fields, cscBarcNombre)

    m_DocEditable = gDB.ValField(rs.Fields, cscDocEditable)
    m_DocEditMsg = gDB.ValField(rs.Fields, cscDoceditMsg)

    m_TaPropuesto = gDB.ValField(rs.Fields, cscTa_Propuesto)
    m_TaMascara = gDB.ValField(rs.Fields, cscTa_Mascara)

    m_LastDoc = m_doc_id
    m_LastCli = m_cli_id
    m_LastDocName = m_Documento
    m_LastCliName = m_Cliente

  Else
    m_Id = csNO_ID
    m_Numero = 0
    m_Nrodoc = vbNullString
    m_Descrip = vbNullString
    m_Marca = vbNullString
    m_Fecha = VDGetDateById(csToday)
    m_Fechaentrega = VDGetDateById(csTomorrow)
    m_Neto = 0
    m_Ivari = 0
    m_Ivarni = 0
    m_Total = 0
    m_Pallets = 0
    m_Cantidad = 0
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
    m_Firmado = False
  
    m_TaPropuesto = False
    m_TaMascara = vbNullString
  
    m_pue_id_origen = csNO_ID
    m_PuertoOrigen = vbNullString
    m_pue_id_destino = csNO_ID
    m_PuertoDestino = vbNullString
    m_Barc_id = csNO_ID
    m_Barco = vbNullString
  
    m_doc_id = m_LastDoc
    m_cli_id = m_LastCli
    m_Cliente = m_LastCliName
    m_Documento = m_LastDocName
  
    DocEditableGet m_doc_id, m_DocEditable, m_DocEditMsg, csPreExpNewPackingList
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
  Dim str_2520 As String
  
  str_2520 = LNGGetText(2520, vbNullString) '&Packing List
  
  #If Not PREPROC_NO_MENU_ICON Then
  
    Dim lIconIndex As Long
    Set m_Host = Host
    lIconIndex = m_Host.AddIcon(LoadResPicture(102, LoadResConstants.vbResIcon))
    m_Host.Server.AddMenu c_MenuMain, csMenuEnum.csMenuExportacion, vbNullString, 1, False, False, False, True, False, Nothing
    m_Host.Server.AddMenu str_2520, csPreExpListPackingList, c_MenuMain, 0, True, False, False, False, False, Me, lIconIndex
  
  #Else
  
    Set m_Host = Host
    m_Host.Server.AddMenu c_MenuMain, csMenuEnum.csMenuExportacion, vbNullString, 1, False, False, False, True, False, Nothing
    m_Host.Server.AddMenu str_2520, csPreExpListPackingList, c_MenuMain, 0, True, False, False, False, False, Me
  
  #End If
  
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
#If PREPROC_SFS Then                                                                                                                                          'Packing List
  m_Host.MenuListDocClick "CSABMInterface2.cABMGeneric", "CSExport2.cPackingList", "CSABMInterface2.CABMGenericListDoc", "CSExport2.cPackingListListDoc", Me, LNGGetText(1602, vbNullString), 0
#Else
  m_Host.MenuListDocClick "CSABMInterface2.cABMGenericDocEx", "CSExport2.cPackingList", "CSABMInterface2.CABMGenericListDoc", "CSExport2.cPackingListListDoc", Me, LNGGetText(1602, vbNullString), 0
#End If
End Function

Private Function pSaveItems(ByVal ID As Long) As Boolean
  Dim register As cRegister
  Dim iOrden As Long
  
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  For Each Row In m_Items.Properties(c_Items).Grid.Rows
  
    Set register = New cRegister
    register.fieldId = cscPklstiTMPId
    register.Table = csTPackingListItemTMP
    register.ID = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KI_PKLSTI_ID
          If m_Copy Then
            register.Fields.Add2 cscPklstiId, csNew, csInteger
          Else
            register.Fields.Add2 cscPklstiId, Val(Cell.Value), csInteger
          End If
        Case KI_CANTIDAD
          register.Fields.Add2 cscPklstiCantidad, Cell.Value, csDouble
        Case KI_DESCRIP
          register.Fields.Add2 cscPklstiDescrip, Cell.Value, csText
        Case KI_PRECIO
          register.Fields.Add2 cscPklstiPrecio, Cell.Value, csCurrency
        Case KI_PRECIO_LP
          register.Fields.Add2 cscPklstiPrecioLista, Cell.Value, csCurrency
        Case KI_PRECIO_USR
          register.Fields.Add2 cscPklstiPrecioUsr, Cell.Value, csCurrency
        Case KI_DESCUENTO
          register.Fields.Add2 cscPklstiDescuento, Cell.Value, csText
        Case KI_IMPORTE
          register.Fields.Add2 cscPklstiImporte, Cell.Value, csCurrency
        Case KI_NETO
          register.Fields.Add2 cscPklstiNeto, Cell.Value, csCurrency
        Case KI_IVARI
          If m_bIva Then
            register.Fields.Add2 cscPklstiIvari, Cell.Value, csCurrency
          End If
        Case KI_IVARNI
          If m_bIvaRni Then
            register.Fields.Add2 cscPklstiIvarni, Cell.Value, csCurrency
          End If
        Case KI_IVARIPercent
          register.Fields.Add2 cscPklstiIvariporc, Cell.Value, csDouble
        Case KI_IVARNIPercent
          register.Fields.Add2 cscPklstiIvarniporc, Cell.Value, csDouble
        Case KI_PR_ID
          register.Fields.Add2 cscPrId, Cell.ID, csId
        Case KI_CCOS_ID
          register.Fields.Add2 cscCcosId, Cell.ID, csId
        Case KI_PALLETS
          register.Fields.Add2 cscPklstiPallets, Cell.Value, csText
        Case KI_GRUPO_EXPO
          register.Fields.Add2 cscPklstiGrupoExpo, Cell.Value, csText
        Case KI_PESO_NETO
          register.Fields.Add2 cscPklstiPesoNeto, Val(Cell.Value), csDouble
        Case KI_PESO_TOTAL
          register.Fields.Add2 cscPklstiPesoTotal, Val(Cell.Value), csDouble
        Case KI_CAJA_DESDE
          register.Fields.Add2 cscPklstiCajaDesde, Val(Cell.Value), csInteger
        Case KI_CAJA_HASTA
          register.Fields.Add2 cscPklstiCajaHasta, Val(Cell.Value), csInteger
      End Select
    Next
    
    iOrden = iOrden + 1
    register.Fields.Add2 cscPklstiOrden, iOrden, csInteger
    register.Fields.Add2 cscPklstTMPId, ID, csId
    
    register.Fields.HaveLastUpdate = False
    register.Fields.HaveWhoModify = False
    
    If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
  Next
  
  Dim sqlstmt As String
  
  If m_ItemsDeleted <> vbNullString And m_Id <> csNO_ID And Not m_Copy Then
  
    Dim vDeletes As Variant
    Dim i As Long
    
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    vDeletes = Split(m_ItemsDeleted, ",")
    
    For i = 0 To UBound(vDeletes)
    
      Set register = New cRegister
      register.fieldId = cscPklstibTMPId
      register.Table = csTPackingListItemBorradoTMP
      register.ID = csNew
      
      register.Fields.Add2 cscPklstiId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscPklstId, m_Id, csId
      register.Fields.Add2 cscPklstTMPId, ID, csId
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveItems = True
End Function

' Reglas del Objeto de Negocios
Private Function pDocDesdePedido() As Boolean
  pDocDesdePedido = pDocAsistTipo = csETPackPedido
End Function

Private Function pDocDesdeManifiesto() As Boolean
  pDocDesdeManifiesto = pDocAsistTipo = csETPackManifiesto
End Function

Private Function pDocAsistTipo() As csETipoPackingList
  Dim Doc     As cDocumento
  Dim rtn     As Boolean
  Dim DocId   As Long
  
  ' Si todavia no se cargo el form no se que
  ' documento es, asi que no puede ser sobre pedido
  If m_ObjAbm.Properties.Item(cscDocId) Is Nothing Then Exit Function
  
  DocId = m_ObjAbm.Properties.Item(cscDocId).HelpId
  
  ' Si no hay un documento activo no se hace nada
  If DocId = csNO_ID Then Exit Function
  
  Set Doc = New cDocumento
  
  pDocAsistTipo = Doc.GetData(DocId, cscDocTipoPackingList, csInteger)
End Function

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
  
  m_Footer.Properties(cscPklstSubtotal).Value = Neto
  
  Desc1 = m_ObjAbm.Properties(cscPklstDescuento1).Value
  Desc2 = m_ObjAbm.Properties(cscPklstDescuento2).Value
  
  Desc1 = Neto * Desc1 / 100
  m_Footer.Properties(cscPklstImportedesc1).Value = Desc1
  
  Neto = Neto - Desc1
  
  Desc2 = Neto * Desc2 / 100
  m_Footer.Properties(cscPklstImportedesc2).Value = Desc2
  
  Neto = Neto - Desc2
  
  m_Footer.Properties(cscPklstNeto).Value = Neto
  m_Footer.Properties(cscPklstIvari).Value = IvaRi
  m_Footer.Properties(cscPklstIvarni).Value = IvaRni
  m_Footer.Properties(cscPklstTotal).Value = Neto + IvaRni + IvaRi
  
  m_Footer.RefreshControls
End Sub

Private Sub pSetTasasImpositivas(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal PR_ID As Long, ByVal pr_nombre As String)
  Dim ti_ri    As Long
  Dim ti_rni   As Long
  
  If PR_ID = 0 Then Exit Sub
  
  If Not GetTasaFromProducto(PR_ID, ti_ri, ti_rni, False) Then Exit Sub
  
  If ti_ri = 0 Then
    MsgWarning LNGGetText(1597, vbNullString, pr_nombre)
              'El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de _
                ventas para el iva responsable inscripto
    Exit Sub
  End If
  
  If ti_rni = 0 Then
    MsgWarning LNGGetText(1598, vbNullString, pr_nombre)
              'El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de _
                ventas para el iva responsable no inscripto
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

Private Sub pSetDataProducto(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal PR_ID As Long)
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select un_nombre from producto, unidad where un_id_venta = un_id and pr_id = " & PR_ID
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
    pCell(Row, KI_UNIDAD).Value = gDB.ValField(rs.Fields, cscUnNombre)
  End If
End Sub

Private Sub pSetPrecios(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal PR_ID As Long)
  Dim LP        As cListaPrecio
  Dim lp_id     As Long
  Dim Precio    As Double
  
  lp_id = m_ObjAbm.Properties(cscLpId).HelpId
    
  If lp_id <> 0 Then
    Set LP = New cListaPrecio
    Precio = LP.GetPrecio(lp_id, PR_ID)
  End If
  
  pCell(Row, KI_PRECIO_LP).Value = Precio
  pCell(Row, KI_PRECIO_USR).Value = Precio
End Sub

Private Sub pSetDescuentos(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal PR_ID As Long, ByVal Precio As Double)
  Dim LD        As cListaDescuento
  Dim ld_id     As Long
  Dim Descuento As String
  
  ld_id = m_ObjAbm.Properties(cscLdId).HelpId
  
  If ld_id <> 0 Then
    Set LD = New cListaDescuento
    Precio = LD.GetPrecio(ld_id, PR_ID, Precio)
    Descuento = LD.GetDescuentoStr(ld_id, PR_ID)
  End If
  
  pCell(Row, KI_PRECIO).Value = Precio
  pCell(Row, KI_DESCUENTO).Value = Descuento
End Sub

Private Sub pSetEnabled()
  Dim bState As Boolean
  
  ' Si se genera desde un pedido y es nuevo
  ' no puede editar, tiene que hacer click en
  ' nuevo y llamar al asistente
  If pDocDesdePedido And m_Id = csNO_ID Then
    bState = False
  ElseIf pDocDesdeManifiesto And m_Id = csNO_ID Then
    bState = False
  ElseIf m_DocEditable Then
    bState = m_ObjAbm.Properties.Item(cscDocId).HelpId <> csNO_ID
  Else
    bState = False
  End If
  
  pSetEnabledAux bState
End Sub

Private Sub pSetEnabledAux(ByVal bState As Boolean)
  Dim Prop   As cIABMProperty
  
  For Each Prop In m_ObjAbm.Properties
    If Prop.Key <> K_DOC_ID And Prop.Key <> K_NUMERO And Prop.Key <> K_EST_ID Then
    
      If bState Then
        If Prop.Key <> K_NRODOC Then
          Prop.Enabled = bState
        Else
          Prop.Enabled = m_TaPropuesto
        End If
      Else
        Prop.Enabled = False
      End If
    End If
  Next
  
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

Private Sub pSetDatosCliente()
  Dim lp_id       As Long
  Dim ld_id       As Long
  Dim cpg_id      As Long
  Dim cpg_nombre  As String
  Dim LP          As cListaPrecio
  Dim LD          As cListaDescuento
  Dim iProp       As cIABMProperty
  Dim Filter      As String
  
  With m_ObjAbm.Properties.Item(cscCliId)
    If m_LastCli = .HelpId Then
      Exit Sub
    End If
    m_LastCli = .HelpId
  End With

  If Not GetClienteData2(m_LastCli, lp_id, ld_id, cpg_id, m_LastDoc) Then Exit Sub
  
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
  
  Filter = "exists(select lp_id from listaprecioCliente where cli_id =" & m_LastCli
  Filter = Filter & " and lp_id = listaprecio.lp_id)"
  
  iProp.HelpFilter = Filter
  
  If lp_id <> csNO_ID Then
    Set LP = New cListaPrecio
    iProp.Value = LP.GetData(lp_id, cscLpNombre, csText)
    iProp.HelpId = lp_id
  End If
  
  m_ObjAbm.ShowValue iProp
  
  ' Lista de descuentos
  Set iProp = m_ObjAbm.Properties.Item(cscLdId)
  
  Filter = "exists(select ld_id from listadescuentoCliente where cli_id =" & m_LastCli
  Filter = Filter & " and ld_id = listadescuento.ld_id)"
  
  iProp.HelpFilter = Filter
  
  If ld_id <> csNO_ID Then
    Set LD = New cListaDescuento
    iProp.Value = LD.GetData(ld_id, cscLdNombre, csText)
    iProp.HelpId = ld_id
  End If
  
  ' Talonario y Categoria fiscal
  pGetIvaFromCliente m_LastCli
  
  m_ObjAbm.ShowValue iProp
End Sub

Private Sub pGetIvaFromCliente(ByVal Cli_id As Long)
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  Dim bIvaChanged As Boolean
  Dim bLastIva    As Boolean
  
  sqlstmt = "sp_clienteGetIva " & Cli_id
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

Private Function pFirmar() As Boolean
  Dim Doc     As cDocumento
  Dim us_id   As Long
  
  Set Doc = New cDocumento
  
  If m_Id = csNO_ID Then
    MsgWarning LNGGetText(1592, vbNullString)
                'Antes de poder firmar el documento debe guardarlo.
    Exit Function
  End If
  
  If m_Firmado Then
    If Not Ask(LNGGetText(1593, vbNullString), vbYes, LNGGetText(1594, vbNullString)) Then
              'El documento ya ha sido firmado desea borrar la firma ,  Firmar
      Exit Function
    End If
  End If
  
  If Not Doc.Firmar(m_doc_id, us_id) Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocPackingListFirmar " & m_Id & "," & us_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_est_id = gDB.ValField(rs.Fields, cscEstId)
  m_Estado = gDB.ValField(rs.Fields, cscEstNombre)
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties(csDocEstateID)
  
  With iProp
    .HelpId = m_est_id
    .Value = m_Estado
  End With
  
  gDB.GetData csTPackingList, cscPklstId, m_Id, cscPklstFirmado, m_Firmado
  
  m_ObjAbm.ShowValue iProp
  
  pFirmar = True
End Function

Private Function pMove(ByVal MoveTo As ABM_MSG) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim doc_id  As Long
  
  doc_id = m_ObjAbm.Properties(cscDocId).HelpId
  
  If doc_id = csNO_ID Then MsgInfo LNGGetText(1595, vbNullString)
                                    'Debe seleccionar un documento
  
  sqlstmt = "sp_DocPackingListMover " & MoveTo & "," & m_Numero & "," & doc_id
  
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
        m_LastCli = csNO_ID
        m_LastCliName = vbNullString
        
        ' Cargo un registro vacio
        '
        Load csNO_ID
        
        ' Refresco el formulario
        '
        pRefreshProperties
    
        ' Obtengo un nuevo numero de comprobante
        '
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscPklstNrodoc
    
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
    
    Set c = .Item(cscPklstFecha)
    c.Value = m_Fecha
    
    Set c = .Item(cscPklstFechaEntrega)
    c.Value = m_Fechaentrega
    
    Set c = .Item(cscCliId)
    c.HelpId = m_cli_id
    c.Value = m_Cliente
    
    Set c = .Item(csDocNumberID)
    c.Value = m_Numero
    
    Set c = .Item(csDocEstateID)
    c.Value = m_Estado
    
    Set c = .Item(cscPklstNrodoc)
    c.Value = m_Nrodoc
    c.TextMask = m_TaMascara
    c.TextAlign = vbRightJustify
    
    Set c = .Item(cscPklstDescuento1)
    c.Value = m_Descuento1
    
    Set c = .Item(cscPklstDescuento2)
    c.Value = m_Descuento2
    
    Set c = .Item(cscCpgId)
    c.HelpId = m_cpg_id
    c.Value = m_CondicionPago
    
    Set c = .Item(cscLpId)
    Filter = "exists(select lp_id from listaprecioCliente where cli_id =" & m_cli_id
    Filter = Filter & " and lp_id = listaprecio.lp_id)"
    c.HelpFilter = Filter
    c.HelpId = m_Lp_id
    c.Value = m_ListaPrecio
    
    Set c = .Item(cscLdId)
    Filter = "exists(select ld_id from listadescuentoCliente where cli_id =" & m_cli_id
    Filter = Filter & " and ld_id = listadescuento.ld_id)"
    c.HelpFilter = Filter
    c.HelpId = m_Ld_id
    c.Value = m_ListaDescuento
    
    Set c = .Item(cscCcosId)
    c.HelpId = m_ccos_id
    c.Value = m_CentroCosto
    
    Set c = .Item(cscSucId)
    c.HelpId = m_suc_id
    c.Value = m_Sucursal
    
    Set c = .Item(cscPklstDescrip)
    c.Value = m_Descrip
    
    Set c = .Item(cscPklstMarca)
    c.Value = m_Marca
  
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
  
    Set c = .Item(cscPklstPallets)
    c.Value = m_Pallets
    
    Set c = .Item(cscPklstSubtotal)
    c.Value = m_SubTotal
    
    Set c = .Item(cscPklstImportedesc1)
    c.Value = m_ImporteDesc1
    
    Set c = .Item(cscPklstImportedesc2)
    c.Value = m_ImporteDesc2
    
    Set c = .Item(cscPklstNeto)
    c.Value = m_Neto
    
    Set c = .Item(cscPklstIvari)
    c.Value = m_Ivari
    
    Set c = .Item(cscPklstIvarni)
    c.Value = m_Ivarni
    
    Set c = .Item(cscPklstTotal)
    c.Value = m_Total
  
  End With
  
  Set AbmGen = m_Footer
  AbmGen.ShowValues m_Footer.Properties
  
  pSetEnabled
End Sub

Private Sub pShowApply()

  If Not DocSecurityCanAccess(csPreExpModifyAplic, m_doc_id, csEDocTPreAplicar) Then Exit Sub

  If m_ObjApply Is Nothing Then
    Set m_ObjApply = New cPackingListAplic
  
  ' Edit Apply
  '
  Else
    If m_ObjApply.ID <> m_Id Then
      Set m_ObjApply.ObjectClient = Nothing
      Set m_ObjApply = New cPackingListAplic
    End If
  End If

  ' Edit Apply
  '
  Set m_ObjApply.ObjectClient = Me
  
  If Not m_ObjApply.Show(m_Id, m_Total, m_Nrodoc, m_cli_id, m_Cliente, m_suc_id, m_doc_id, False) Then
    Set m_ObjApply = Nothing
  End If
End Sub

Private Sub pShowStartWizard()
  On Error GoTo ControlError
  
  Dim oWizard As cPackingListWizard
  Set oWizard = New cPackingListWizard
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  If Not oWizard.Load() Then Exit Sub

  With oWizard
    .Cli_id = m_cli_id
    .Cliente = m_Cliente
    .PvIds = m_PvIds
    .doc_id = m_LastDoc
    .Documento = m_LastDocName
    Set .ObjClient = Me
  End With
  
  'Dim iEditGeneric As cIEditGeneric
  'Set iEditGeneric = oWizard
  'Set iEditGeneric.ObjTree = m_ObjTree
  
  Dim iObjWizard As cIWizardGeneric
  Dim oObjWizard   As cWizardGeneric
  
  Set iObjWizard = CSKernelClient2.CreateObject("CSABMInterface2.cWizardGeneric")
  Set oObjWizard = iObjWizard
  Set oObjWizard.ObjClient = oWizard
  
  iObjWizard.Show "CSVenta2.cPackingListWizard"
  
  oObjWizard.ObjABM.ObjForm.ZOrder
  
  GoTo ExitProc
ControlError:
  MngError Err, "pShowStartWizard", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pShowStartWizardManifiesto()
  On Error GoTo ControlError
  
  Dim oWizard As cPackingListManifiestoWiz
  Set oWizard = New cPackingListManifiestoWiz
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  If Not oWizard.Load() Then Exit Sub

  With oWizard
    .Cli_id = m_cli_id
    .Cliente = m_Cliente
    .MfcIds = m_MfcIds
    .doc_id = m_LastDoc
    .Documento = m_LastDocName
    Set .ObjClient = Me
  End With
  
  'Dim iEditGeneric As cIEditGeneric
  'Set iEditGeneric = oWizard
  'Set iEditGeneric.ObjTree = m_ObjTree
  
  Dim iObjWizard As cIWizardGeneric
  Dim oObjWizard   As cWizardGeneric
  
  Set iObjWizard = CSKernelClient2.CreateObject("CSABMInterface2.cWizardGeneric")
  Set oObjWizard = iObjWizard
  Set oObjWizard.ObjClient = oWizard
  
  iObjWizard.Show "CSVenta2.cPackingListManifiestoWiz"
  
  oObjWizard.ObjABM.ObjForm.ZOrder
  
  GoTo ExitProc
ControlError:
  MngError Err, "pShowStartWizardManifiesto", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' Construccion - Destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2515, vbNullString) 'Error al grabar el Packing List
  
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  Set m_ExpoConfig = New cExportConfig
  m_bPrecio = m_ExpoConfig.EditPricePk
  m_ExpoConfig.Load
  ReDim m_PvIds(0)
  ReDim m_MfcIds(0)

  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load
  m_UserCfg.ValidatePKLST

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_GeneralConfig = Nothing
  Set m_ExpoConfig = Nothing
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
  Set m_Footer = Nothing
  Set m_Items = Nothing
  ReDim m_PvIds(0)
  ReDim m_MfcIds(0)
  
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

Private Sub pShowFactura()
  On Error GoTo ControlError

  Dim o As Object
  Set o = CSKernelClient2.CreateObject("CSVenta2.cFacturaVenta")
  
  o.ShowFacturaPacking pGetCliId(), pGetPklstIds()

  GoTo ExitProc
ControlError:
  MngError Err, "pShowFactura", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetPklstIds() As Long()
  Dim rtn() As Long
  ReDim rtn(1)
  rtn(1) = m_Id
  pGetPklstIds = rtn
End Function

Private Function pGetCliId() As Long
  pGetCliId = m_ObjAbm.Properties(cscCliId).HelpId
End Function

Private Function pGetItems() As cIABMProperty
  Set pGetItems = m_Items.Properties.Item(c_Items)
End Function

