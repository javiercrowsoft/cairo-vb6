VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cImportacionTemporal"
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
' cImportacionTemp
' 26-01-2004

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cImportacionTemp"

Private Const c_Items = "I"
Private Const c_Garantias = "G"

Private Const K_NUMERO                         As Integer = 1
Private Const K_NRODOC                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHA                          As Integer = 4
Private Const K_FECHAENTREGA                   As Integer = 5
Private Const K_NETO                           As Integer = 6
Private Const K_IVARI                          As Integer = 7
Private Const K_IVARNI                         As Integer = 8
Private Const K_TOTAL                          As Integer = 9
Private Const K_PROV_ID                        As Integer = 10
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
Private Const K_DESPACHONRO                    As Integer = 26
Private Const K_FECHAOFICIAL                   As Integer = 27
Private Const K_SEGURO                         As Integer = 29
Private Const K_FLETE                          As Integer = 30

Private Const K_GARANTIAS                      As Integer = 31


Private Const KI_RCI_ID                         As Integer = 2
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

Private Const KI_SEGURO                         As Integer = 26
Private Const KI_FLETE                          As Integer = 27


Private Const KI_IMPTG_ID                       As Integer = 1
Private Const KI_IMPTG_ORDEN                    As Integer = 2
Private Const KI_GAR_ID                         As Integer = 3

' Seudo - Variables
Private c_ErrorSave     As String

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
Private m_FechaOficial                 As Date
Private m_DespachoNro                  As String
Private m_Neto                         As Double
Private m_Ivari                        As Double
Private m_Ivarni                       As Double
Private m_Total                        As Double
Private m_SubTotal                     As Double
Private m_Descuento1                   As Double
Private m_Descuento2                   As Double
Private m_ImporteDesc1                 As Double
Private m_ImporteDesc2                 As Double
Private m_Seguro                       As Double
Private m_Flete                        As Double
Private m_cpg_id                       As Long
Private m_CondicionPago                As String
Private m_ccos_id                      As Long
Private m_CentroCosto                  As String
Private m_suc_id                       As Long
Private m_Sucursal                     As String
Private m_prov_id                      As Long
Private m_Proveedor                    As String
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

' Para ver documentos auxiliares
'
Private m_st_id                        As Long

Private m_Editing                      As Boolean

Private m_bShowStockData               As Boolean
Private m_depl_id                      As Long
Private m_Deposito                     As String

Private m_Footer            As cIABMGeneric
Private m_Items             As cIABMGeneric
Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_LastDoc           As Long
Private m_LastProv          As Long
Private m_LastDocName       As String
Private m_LastProvName      As String

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost

Private m_ItemsDeleted      As String

Private m_Copy              As Boolean

Private m_GeneralConfig     As cGeneralConfig

Private m_DocEditable       As Boolean
Private m_DocEditMsg        As String

Private m_PcIds()           As Long

Private m_bIva              As Boolean
Private m_bIvaRni           As Boolean

Private m_TaPropuesto       As Boolean
Private m_TaMascara         As String

Private m_NrosSerie         As Collection

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

' propiedades publicas
' propiedades privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  If Not DocSecurityCanAccessEx(csPreExpNewImportacionTmp, _
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscImptNrodoc
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscImptNrodoc
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

  Doc.ClientTable = csTImportacionTemp
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
      Select Case Info
        Case c_Items
          pShowTotales m_Items.Properties(c_Items).Grid.Rows
      End Select
      cIABMClient_MessageEx = True
    Case MSG_DOC_EDIT_STATE
      ShowEditState m_DocEditMsg, LNGGetText(2485, vbNullString) 'Importación Temporal
      
    Case MSG_DOC_DELETE
      If cIEditGeneric_Delete(m_Id) Then
        cIABMClient_MessageEx = True
        pMove MSG_DOC_NEXT
      End If
    Case MSG_DOC_ANULAR
      DocAnular m_Id, m_est_id, m_Estado, csPreExpAnularImportacionTmp, csPreExpDesAnularImportacionTmp, m_ObjAbm, m_DocEditable, m_DocEditMsg, "sp_DocImportacionTempAnular", "sp_DocImportacionTempEditableGet"
      pSetEnabled
  
    Case MSG_DOC_REFRESH
      Load m_Id
      pRefreshProperties
  
    Case MSG_DOC_EX_GET_ITEMS
      Set cIABMClient_MessageEx = m_Items
    
    Case MSG_DOC_EX_GET_FOOTERS
      Set cIABMClient_MessageEx = m_Footer
  
    Case MSG_DOC_SEARCH                     ' En info cABMInteface nos
                                            ' indica si hay cambios sin
                                            ' guardar
      DocumentSearch csEDT_ImportacionTemp, Me, Not CBool(Info)
  
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
  
    Case MSG_DOC_HISTORY
    
      If m_Id <> csNO_ID Then
    
        ShowHistory csImportacionTemp, m_Id, m_Documento & " " & m_Nrodoc
      Else
        
        MsgInfo LNGGetText(1552, vbNullString) ' El documento aun no ha sido guardado
      End If
  
    Case MSG_EXPORT_GET_EMAIL
    
      With m_ObjAbm.Properties.Item(cscProvId)
        cIABMClient_MessageEx = GetEmailFromProveedor(.HelpId)
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscImptNrodoc
      
        pSetShowStockData
      End If

      ' Defino el estado de edicion del comprobante
      '
      pSetEnabled
      
    Case K_PROV_ID
      
      ' Obtengo los datos del proveedor
      '
      pSetDatosProveedor
    
    Case K_DESCUENTO1, K_DESCUENTO2
      pShowTotales m_Items.Properties(c_Items).Grid.Rows
    Case K_FLETE
      pProrratear cscImptFlete, KI_FLETE
    Case K_SEGURO
      pProrratear cscImptSeguro, KI_SEGURO
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
  If Not DocCanSave(m_ObjAbm, cscImptFecha) Then
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
  register.fieldId = cscImptTMPId
  register.Table = csTImportacionTempTMP
  
  register.ID = csNew
    
  If m_Copy Then
    register.Fields.Add2 cscImptId, csNew, csLong
  Else
    register.Fields.Add2 cscImptId, m_Id, csLong
  End If
  
  If register.ID = csNew Then
    m_est_id = CSGeneralEx2.csEEstado.csEEst_Pendiente
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NUMERO
          register.Fields.Add2 cscImptNumero, .Value, csLong
        Case K_NRODOC
          register.Fields.Add2 cscImptNrodoc, .Value, csText
        Case K_DESCRIP
          register.Fields.Add2 cscImptDescrip, .Value, csText
        Case K_FECHA
          register.Fields.Add2 cscImptFecha, .Value, csDate
        Case K_FECHAENTREGA
          register.Fields.Add2 cscImptFechaentrega, .Value, csDate
        Case K_PROV_ID
          register.Fields.Add2 cscProvId, .HelpId, csId
        Case K_CCOS_ID
          register.Fields.Add2 cscCcosId, .HelpId, csId
        Case K_SUC_ID
          register.Fields.Add2 cscSucId, .HelpId, csId
        Case K_DESCUENTO1
          register.Fields.Add2 cscImptDescuento1, .Value, csCurrency
        Case K_DESCUENTO2
          register.Fields.Add2 cscImptDescuento2, .Value, csCurrency
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
        Case K_DESPACHONRO
          register.Fields.Add2 cscImptDespachonro, .Value, csText
        Case K_FECHAOFICIAL
          register.Fields.Add2 cscImptFechaoficial, .Value, csDate
        Case K_SEGURO
          register.Fields.Add2 cscImptSeguro, .Value, csDouble
        Case K_FLETE
          register.Fields.Add2 cscImptFlete, .Value, csDouble
      End Select
    End With
  Next
  
  For Each IProperty In m_Footer.Properties
    With IProperty
      Select Case .Key
        Case K_TOTAL
          register.Fields.Add2 cscImptTotal, .Value, csCurrency
        Case K_NETO
          register.Fields.Add2 cscImptNeto, .Value, csCurrency
        Case K_IVARI
          If m_bIva Then
            register.Fields.Add2 cscImptIvari, .Value, csCurrency
          End If
        Case K_IVARNI
          If m_bIvaRni Then
            register.Fields.Add2 cscImptIvarni, .Value, csCurrency
          End If
        Case K_SUBTOTAL
          register.Fields.Add2 cscImptSubtotal, .Value, csCurrency
        Case K_IMPORTEDESC1
          register.Fields.Add2 cscImptImportedesc1, .Value, csCurrency
        Case K_IMPORTEDESC2
          register.Fields.Add2 cscImptImportedesc2, .Value, csCurrency
      End Select
    End With
  Next
  
  register.Fields.Add2 cscEstId, m_est_id, csId
  register.Fields.Add2 cscDoctId, csEDT_ImportacionTemp, csId
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If Not pSaveItems(register.ID) Then Exit Function
  If Not pSaveGarantias(register.ID) Then Exit Function
  
  If Not register.CommitTrans() Then Exit Function
  
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DocImportacionTempSave " & register.ID
  
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
  
  m_ObjTree.sqlstmt = "sp_lsdoc_ImportacionTemp"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2482, vbNullString) 'Importaciones Temporales
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
        Case K_PROV_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1860, vbNullString) 'Debe indicar un proveedor
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
        Case K_DEPL_ID
          If ValEmpty(.HelpId, csId) And m_bShowStockData Then
            MsgInfo LNGGetText(1559, vbNullString) 'Debe indicar un deposito
            Exit Function
          End If
        Case K_DESPACHONRO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(2487, vbNullString) 'Debe indicar le número del Despacho de Importación
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
    Case K_GARANTIAS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowGarantia(Row, RowIndex)
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
  
  sqlstmt = "select doct_id, doc_id from ImportacionTemp where rc_id = " & ID
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreExpListImportacionTmp)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Dim AbmGen      As cABMGeneric
  
  Set m_ObjAbm = rhs
  m_ObjAbm.IsDocument = True

'  Set AbmGen = m_ObjAbm
'  With AbmGen
'    .FactoryObject = "CSABMInterface2.cFactory"
'    .ObjForm = "CSABMInterface2.fImportacionTemp"
'  End With
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
                          csTImportacionTemp, _
                          cscImptId, _
                          doc_id) Then
      Exit Function
    End If
  End If
  
  If Not DocSecurityCanAccess( _
                  csPreExpDeleteImportacionTmp, _
                  doc_id, _
                  csEDocTPreDelete) Then
    Exit Function
  End If

  Dim sqlstmt As String
  
  sqlstmt = "sp_DocImportacionTempDelete " & ID & "," & EmpId & "," & User.ID
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not DocSecurityCanAccess(csPreExpListImportacionTmp, GetdocIdFromObjAbm(m_ObjAbm), csEDocTPreList) Then Exit Function
  
                            ' Id = csDocChanged esto significa que se cambio
                            '                   el documento estando en un
                            '                   comprobante ya guardado
                            '
  m_IsNew = ID = csNO_ID Or ID = csDocChanged

  If Not Load(ID) Then Exit Function
  
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
    Case K_GARANTIAS
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
    Case K_GARANTIAS
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
    Case K_ITEMS
      cIABMClientGrid_ColumnBeforeEdit = pColumnBeforeEdit(m_Items.Properties(c_Items), lRow, lCol, iKeyAscii)
    Case K_GARANTIAS
      cIABMClientGrid_ColumnBeforeEdit = True
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnBeforeEdit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pColumnBeforeEdit(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
  Dim Row As cIABMGridRow
  
  Select Case IProperty.Grid.Columns(lCol).Key
    Case KI_NROSERIE
      Set Row = IProperty.Grid.Rows(lRow)
      If Not Row Is Nothing Then
        pColumnBeforeEdit = pCell(Row, KI_PR_LLEVANROSERIE).ID
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
  Dim Row As cIABMGridRow
  
  Select Case Key
    Case K_ITEMS
      With m_Items.Properties.Item(c_Items).Grid
        Select Case .Columns(lCol).Key
          Case KI_NROSERIE
            Set Row = .Rows(lRow)
            If pCell(Row, KI_PR_LLEVANROSERIE).ID Then
              cIABMClientGrid_ColumnButtonClick = EditNroSerie(pCell(Row, KI_GRUPO).ID, _
                                                               Val(pCell(Row, KI_CANTIDAD).Value), _
                                                               Row, _
                                                               m_NrosSerie, _
                                                               KI_GRUPO, _
                                                               KI_NROSERIE, _
                                                               lRow, _
                                                               csNO_ID, csNO_ID, True, False, Nothing, _
                                                               csNO_ID, csNO_ID)
            End If
        End Select
      End With
  End Select
End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim ID As Long
  
  ID = Val(pCell(Row, KI_RCI_ID).Value)
  
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
    Case K_GARANTIAS
      cIABMClientGrid_ValidateRow = pValidateRowGarantia(Row, RowIndex)
    
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
      Case KI_SEGURO
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_FLETE
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

Private Function pIsEmptyRowGarantia(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_GAR_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowGarantia = bRowIsEmpty
End Function

Private Function pValidateRowGarantia(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bLlevaNroSerie        As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_GAR_ID
        If ValEmpty(Cell.ID, csId) Then
          MsgInfo LNGGetText(2488, vbNullString, strRow) 'Debe indicar una Póliza de Seguro (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowGarantia = True
End Function

Private Function pValidateRow(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bLlevaNroSerie        As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CANTIDAD
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(1365, vbNullString, strRow) 'Debe indicar una cantidad (1)
          Exit Function
        End If
      Case KI_PRECIO
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(1631, vbNullString, strRow) 'Debe indicar un precio (1)
          Exit Function
        End If
      Case KI_SEGURO
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(2489, vbNullString, strRow) 'Debe indicar un Seguro (1)
          Exit Function
        End If
      Case KI_FLETE
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(2490, vbNullString, strRow) 'Debe indicar un Flete (1)
          Exit Function
        End If
      Case KI_PR_ID
        If ValEmpty(Cell.ID, csId) Then
          MsgInfo LNGGetText(1899, vbNullString, strRow) 'Debe indicar un producto de compra (1)
          Exit Function
        End If
      Case KI_NROSERIE
        bLlevaNroSerie = pCell(Row, KI_PR_LLEVANROSERIE).ID
        If ValEmpty(Cell.Value, csText) And bLlevaNroSerie Then
          MsgInfo LNGGetText(1630, vbNullString, strRow) 'Debe indicar un numero de serie (1)
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
  Dim AbmGen  As cABMGeneric
  
  ' Preferencias del usuario
  '
  Dim bValidateDocDefault As Boolean
  
  Set AbmGen = m_ObjAbm
  AbmGen.ResetLayoutMembers
  
  AbmGen.NoButtons1 = BUTTON_DOC_APLIC
  AbmGen.NoButtons2 = BUTTON_DOC_ACTION
  AbmGen.InitButtons
  
  m_ObjAbm.Properties.Clear
  m_ObjAbm.Tabs.Clear

  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = 0
  iTab.Name = C_strGeneral
  
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = 1
  iTab.Name = LNGGetText(2491, vbNullString)  'DIT
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscDocId)
  c.PropertyType = cspHelp
  c.Table = CSDocumento2.CSDocumento
  c.Name = LNGGetText(1567, vbNullString)  'Documento
  c.Key = K_DOC_ID
      
  If m_doc_id <> csNO_ID Then
    c.HelpId = m_doc_id
    c.Value = m_Documento
  Else
    ' Preferencias del usuario
    '
    c.HelpId = m_UserCfg.DocImptId
    c.Value = m_UserCfg.DocImptNombre
    
    bValidateDocDefault = c.HelpId <> csNO_ID
  End If
      
  c.HelpFilter = "'doct_id = " & csEDT_ImportacionTemp & "'"
  
  Set c = m_ObjAbm.Properties.Add(Nothing, csDocNumberID)
  c.PropertyType = cspNumeric
  c.SubType = cspInteger
  c.Name = LNGGetText(1065, vbNullString)  'Número
  c.Key = K_NUMERO
  c.Value = m_Numero
  c.Enabled = False
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, csDocEstateID)
  c.PropertyType = cspText
  c.Name = LNGGetText(1568, vbNullString)  'Estado
  c.Key = K_EST_ID
  c.Value = m_Estado
  c.Enabled = False
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscImptFecha)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1569, vbNullString)  'Fecha
  c.LeftLabel = -580
  c.Left = 700
  c.Key = K_FECHA
  c.Value = m_Fecha
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscImptFechaentrega)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1570, vbNullString)  'Entrega
  c.Key = K_FECHAENTREGA
  c.Value = m_Fechaentrega
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscProvId)
  c.PropertyType = cspHelp
  c.Table = csProveedor
  c.TopFromProperty = cscImptFecha
  c.Left = 2920
  c.LeftLabel = -800
  c.Name = LNGGetText(1151, vbNullString)  'Proveedor
  c.Key = K_PROV_ID
  c.HelpId = m_prov_id
  c.Value = m_Proveedor
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscImptNrodoc)
  c.PropertyType = cspText
  c.Name = LNGGetText(1065, vbNullString)  'Numero
  c.Size = 50
  c.Key = K_NRODOC
  c.Value = m_Nrodoc
  c.TextMask = m_TaMascara
  c.TextAlign = vbRightJustify
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCpgId)
  c.PropertyType = cspHelp
  c.Table = csCondicionPago
  c.Name = LNGGetText(1571, vbNullString)  'Cond. pago
  c.TopFromProperty = cscImptFecha
  c.Left = 5900
  c.LeftLabel = -600
  c.Key = K_CPG_ID
  c.HelpId = m_cpg_id
  c.Value = m_CondicionPago
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscImptDescuento1)
  c.PropertyType = cspNumeric
  c.SubType = cspPercent
  c.LeftLabel = -600
  c.Name = LNGGetText(1573, vbNullString)  'Desc. 1
  c.Key = K_DESCUENTO1
  c.Value = m_Descuento1
  c.Width = 1000
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscImptDescuento2)
  c.PropertyType = cspNumeric
  c.SubType = cspPercent
  c.TopFromProperty = cscImptDescuento1
  c.Left = 7150
  c.LeftLabel = -150
  c.Name = "2"
  c.Key = K_DESCUENTO2
  c.Value = m_Descuento2
  c.Width = 1000
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscDeplIdOrigen)
  c.PropertyType = cspHelp
  c.LeftFromProperty = cscCpgId
  c.Table = csDepositoLogico
  c.Name = LNGGetText(1574, vbNullString)  'Deposito
  c.LeftLabel = -680
  c.Key = K_DEPL_ID
      
  If m_depl_id <> csNO_ID Or Not m_bShowStockData Then
    c.HelpId = m_depl_id
    c.Value = m_Deposito
  Else
    ' Preferencias del usuario
    '
    c.HelpId = m_UserCfg.DeplId
    c.Value = m_UserCfg.DeplNombre
  End If
  
  c.Enabled = m_bShowStockData
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscLpId)
  c.PropertyType = cspHelp
  c.Table = csListaPrecio
  c.Name = LNGGetText(1397, vbNullString)  'Lista de Precios
  
  Filter = "exists(select lp_id from listaprecioProveedor where prov_id =" & m_prov_id
  Filter = Filter & " and lp_id = listaprecio.lp_id)"
  
  c.HelpFilter = Filter
  c.TopFromProperty = cscImptFecha
  c.Left = 9400
  c.Key = K_LP_ID
  c.HelpId = m_Lp_id
  c.Value = m_ListaPrecio
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscLdId)
  c.PropertyType = cspHelp
  c.Table = csListaDescuento
  c.Name = LNGGetText(1398, vbNullString)  'Lista de Descuentos
  
  Filter = "exists(select ld_id from listadescuentoProveedor where prov_id =" & m_prov_id
  Filter = Filter & " and ld_id = listadescuento.ld_id)"
  
  c.HelpFilter = Filter
  c.Key = K_LD_ID
  c.HelpId = m_Ld_id
  c.Value = m_ListaDescuento
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCcosId)
  c.PropertyType = cspHelp
  c.Table = csCentroCosto
  c.Name = LNGGetText(1057, vbNullString)  'Centro de Costo
  c.Key = K_CCOS_ID
  c.HelpId = m_ccos_id
  c.Value = m_CentroCosto
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscSucId)
  c.PropertyType = cspHelp
  c.Table = csSucursal
  c.Name = LNGGetText(1281, vbNullString)  'Sucursal
  c.Key = K_SUC_ID
  c.HelpId = m_suc_id
  c.Value = m_Sucursal
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscImptDescrip)
  c.PropertyType = cspText
  c.SubType = cspMemo
  c.Name = LNGGetText(1211, vbNullString)  'Observ.
  c.LeftLabel = -600
  c.Size = 5000
  c.Key = K_DESCRIP
  c.Value = m_Descrip
  c.LeftFromProperty = cscImptFecha
  c.TopFromProperty = cscImptNrodoc
  c.Width = 4490
  c.Height = 800
  c.TopToPrevious = 440
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscImptDespachonro)
  c.PropertyType = cspText
  c.Name = LNGGetText(2492, vbNullString)  'Despacho Nro
  c.Left = 1500
  c.Key = K_DESPACHONRO
  c.Value = m_DespachoNro
  c.TabIndex = 1
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscImptFechaoficial)
  c.PropertyType = cspDate
  c.Name = LNGGetText(2493, vbNullString)  'Fecha Oficializado
  c.Key = K_FECHAOFICIAL
  c.Value = m_FechaOficial
  c.TabIndex = 1
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscImptSeguro)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.Name = LNGGetText(2494, vbNullString)  'Seguro
  c.Key = K_SEGURO
  c.Value = m_Seguro
  c.TabIndex = 1
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscImptFlete)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.Name = LNGGetText(2333, vbNullString)  'Flete
  c.Key = K_FLETE
  c.Value = m_Flete
  c.TabIndex = 1
  
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  pSetShowStockData
  
  m_Items.Tabs.Clear
  
  Set iTab = m_Items.Tabs.Add(Nothing)
  iTab.Index = 0
  iTab.Name = LNGGetText(1371, vbNullString)  'Items
  
  Set iTab = m_Items.Tabs.Add(Nothing)
  iTab.Index = 1
  iTab.Name = LNGGetText(2495, vbNullString)  'Pólizas de Seguro
  
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
  
  Set c = m_Items.Properties.Add(Nothing, c_Garantias)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  If Not pLoadGarantias(c) Then Exit Function
  c.Name = c_Garantias
  c.Key = K_GARANTIAS
  c.TabIndex = 1
  c.GridAdd = True
  c.GridEdit = True
  c.GridRemove = True
  
  If Not m_Items.Show(Me) Then Exit Function
  
  Set AbmGen = m_Footer
  AbmGen.ResetLayoutMembers
  m_Footer.Properties.Clear
  
  Set c = m_Footer.Properties.Add(Nothing, cscImptSubtotal)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.Name = LNGGetText(1579, vbNullString)  'Sub Total
  c.Key = K_SUBTOTAL
  c.Value = m_SubTotal
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  
  
  Set c = m_Footer.Properties.Add(Nothing, cscImptImportedesc1)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.Name = LNGGetText(1573, vbNullString)  'Desc. 1
  c.Key = K_IMPORTEDESC1
  c.Value = m_ImporteDesc1
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  
  
  Set c = m_Footer.Properties.Add(Nothing, cscImptImportedesc2)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.Name = LNGGetText(1580, vbNullString)  'Desc. 2
  c.Key = K_IMPORTEDESC2
  c.Value = m_ImporteDesc2
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  
  
  Set c = m_Footer.Properties.Add(Nothing, cscImptNeto)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.Name = LNGGetText(1581, vbNullString)  'Neto
  c.Key = K_NETO
  c.Value = m_Neto
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  
  
  Set c = m_Footer.Properties.Add(Nothing, cscImptIvari)
  c.PropertyType = cspNumeric
  c.Name = LNGGetText(1582, vbNullString)  'IVA RI
  c.SubType = cspMoney
  c.Key = K_IVARI
  c.Value = m_Ivari
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  
  
  Set c = m_Footer.Properties.Add(Nothing, cscImptIvarni)
  c.PropertyType = cspNumeric
  c.Name = LNGGetText(1583, vbNullString)  'IVA RNI
  c.SubType = cspMoney
  c.Key = K_IVARNI
  c.Value = m_Ivarni
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Enabled = False
  
  
  Set c = m_Footer.Properties.Add(Nothing, cscImptTotal)
  c.PropertyType = cspNumeric
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Name = LNGGetText(1584, vbNullString)  'Total
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

Private Function pLoadGarantias(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_DocImportacionTempGetGarantias " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadGarantias", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  With Propiedad.Grid.Columns
    .Clear
    Propiedad.Grid.Rows.Clear
  
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_IMPTG_ID
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(2448, vbNullString)  'Garantia
    o.PropertyType = cspHelp
    o.Table = csGarantia
    o.Width = 1800
    o.Key = KI_GAR_ID
  End With
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscImptgId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscImptgId)
    fv.Key = KI_IMPTG_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscGarNropoliza)
    fv.ID = gDB.ValField(rs.Fields, cscGarId)
    fv.Key = KI_GAR_ID
    
    rs.MoveNext
  Wend
  
  pLoadGarantias = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_DocImportacionTempGetItems " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  With Propiedad.Grid.Columns
    .Clear
    Propiedad.Grid.Rows.Clear
  
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_RCI_ID
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1367, vbNullString)  'Articulo
    o.PropertyType = cspHelp
    o.Table = csProducto
    o.Width = 1800
    o.Key = KI_PR_ID
    
    Set o = .Add(Nothing)
    o.Name = C_strDescrip
    o.PropertyType = cspText
    o.Width = 1200
    o.Key = KI_DESCRIP
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1374, vbNullString)  'Cantidad
    o.Format = m_GeneralConfig.FormatDecCantidad
    o.PropertyType = cspNumeric
    o.SubType = cspDouble
    o.Width = 1200
    o.Key = KI_CANTIDAD
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1639, vbNullString)  'Nro. Serie
    o.PropertyType = cspText
    o.SubType = cspTextButton
    o.Width = 3000
    o.Key = KI_NROSERIE
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1585, vbNullString)  'Descuento
    o.PropertyType = cspNumeric
    o.Format = m_GeneralConfig.FormatDecImporte
    o.SubType = cspMoney
    o.Width = 1200
    o.Key = KI_DESCUENTO
    o.Enabled = False
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1165, vbNullString)  'Unidad
    o.PropertyType = cspText
    o.Width = 1200
    o.Key = KI_UNIDAD
    o.Enabled = False
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1587, vbNullString)  'Precio (LP)
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Format = m_GeneralConfig.FormatDecImporte
    o.Width = 1200
    o.Key = KI_PRECIO_LP
    o.Enabled = False
  
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1586, vbNullString)  'Precio
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Width = 1200
    o.Format = m_GeneralConfig.FormatDecImporte
    o.Key = KI_PRECIO_USR
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1588, vbNullString)  'Precio c/desc.
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Width = 1200
    o.Format = m_GeneralConfig.FormatDecImporte
    o.Key = KI_PRECIO
    o.Enabled = False
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1581, vbNullString)  'Neto
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Format = m_GeneralConfig.FormatDecImporte
    o.Width = 1200
    o.Key = KI_NETO
    o.Enabled = False
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1582, vbNullString)  'IVA RI
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Format = m_GeneralConfig.FormatDecImporte
    o.Width = 1200
    o.Key = KI_IVARI
    o.Enabled = False
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1583, vbNullString)  'IVA RNI
    o.PropertyType = cspNumeric
    o.Format = m_GeneralConfig.FormatDecImporte
    o.SubType = cspMoney
    o.Width = 1200
    o.Key = KI_IVARNI
    o.Enabled = False
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1228, vbNullString)  'Importe
    o.PropertyType = cspNumeric
    o.Format = m_GeneralConfig.FormatDecImporte
    o.SubType = cspMoney
    o.Width = 1200
    o.Key = KI_IMPORTE
    o.Enabled = False
    
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_IVARIPercent
    
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_IVARNIPercent
      
    Set o = .Add(Nothing)
    o.Name = LNGGetText(2494, vbNullString)  'Seguro
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Width = 1200
    o.Format = m_GeneralConfig.FormatDecImporte
    o.Key = KI_SEGURO
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(2333, vbNullString)  'Flete
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Width = 1200
    o.Format = m_GeneralConfig.FormatDecImporte
    o.Key = KI_FLETE
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1057, vbNullString)  'Centro de Costo
    o.PropertyType = cspHelp
    o.Table = csCentroCosto
    o.Width = 1800
    o.Key = KI_CCOS_ID
    
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_PR_LLEVANROSERIE
    
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_GRUPO
  End With
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscImptiId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscImptiId)
    fv.Key = KI_RCI_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPrNombrecompra)
    fv.ID = gDB.ValField(rs.Fields, cscPrId)
    fv.Key = KI_PR_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscImptiDescrip)
    fv.Key = KI_DESCRIP
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscImptiCantidad)
    fv.Key = KI_CANTIDAD
    
    Set fv = F.Add(Nothing)
    fv.Value = vbNullString
    fv.Key = KI_NROSERIE
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscImptiDescuento)
    fv.Key = KI_DESCUENTO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscUnNombre)
    fv.Key = KI_UNIDAD
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscImptiPrecioLista)
    fv.Key = KI_PRECIO_LP
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscImptiPrecioUsr)
    fv.Key = KI_PRECIO_USR
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscImptiPrecio)
    fv.Key = KI_PRECIO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscImptiNeto)
    fv.Key = KI_NETO

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscImptiIvari)
    fv.Key = KI_IVARI

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscImptiIvarni)
    fv.Key = KI_IVARNI

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscImptiImporte)
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
    fv.Value = gDB.ValField(rs.Fields, cscImptiSeguro)
    fv.Key = KI_SEGURO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscImptiFlete)
    fv.Key = KI_FLETE
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCcosNombre)
    fv.ID = gDB.ValField(rs.Fields, cscCcosId)
    fv.Key = KI_CCOS_ID
    
    Set fv = F.Add(Nothing)
    fv.ID = gDB.ValField(rs.Fields, cscPrLlevaNroSerie)
    fv.Key = KI_PR_LLEVANROSERIE

    Set fv = F.Add(Nothing)
    fv.ID = gDB.ValField(rs.Fields, cscImptiId)
    fv.Key = KI_GRUPO
    
    rs.MoveNext
  Wend
  
  Dim NroSerie  As cProductoSerieType
  Dim CurGroup  As Long
  Dim coll      As Collection
  Dim NrosSerie As String
  
  CollClear m_NrosSerie
  Set rs = rs.NextRecordset
  
  While Not rs.EOF
    
    ' Si cambie de grupo
    If CurGroup <> gDB.ValField(rs.Fields, cscImptiId) Then
    
      pSetNrosSerieInRow CurGroup, NrosSerie
      NrosSerie = vbNullString
    
      CurGroup = gDB.ValField(rs.Fields, cscImptiId)
      Set coll = New Collection
      m_NrosSerie.Add coll, GetKey(CurGroup)
    End If
    
    ' Guardo el numero de serie
    Set NroSerie = New cProductoSerieType
    With NroSerie
      .Codigo = gDB.ValField(rs.Fields, cscPrnsCodigo)
      .Descrip = gDB.ValField(rs.Fields, cscPrnsDescrip)
      .FechaVto = gDB.ValField(rs.Fields, cscPrnsFechavto)
      .prns_id = gDB.ValField(rs.Fields, cscPrnsId)
      
      NrosSerie = NrosSerie & .Codigo & ","
    End With
    
    ' Lo agrego a la bolsa
    coll.Add NroSerie, GetKey(NroSerie.prns_id)
    
    rs.MoveNext
  Wend
  
  pSetNrosSerieInRow CurGroup, NrosSerie
  NrosSerie = vbNullString
  
  pLoadItems = True
End Function

Private Sub pSetNrosSerieInRow(ByVal CurrGroup As Long, ByVal NroSerie As String)
  Dim Row As cIABMGridRow
  
  If CurrGroup = 0 Then Exit Sub
  
  For Each Row In m_Items.Properties(c_Items).Grid.Rows
    If pCell(Row, KI_GRUPO).ID = CurrGroup Then
      pCell(Row, KI_NROSERIE).Value = RemoveLastColon(NroSerie)
      Exit Sub
    End If
  Next
End Sub

Private Function Load(ByVal ID As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "sp_DocImportacionTempGet " & EmpId & "," & ID & "," & gDB.UserId
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscImptId)
    m_Numero = gDB.ValField(rs.Fields, cscImptNumero)
    m_Nrodoc = gDB.ValField(rs.Fields, cscImptNrodoc)
    m_Descrip = gDB.ValField(rs.Fields, cscImptDescrip)
    m_Fecha = gDB.ValField(rs.Fields, cscImptFecha)
    m_Fechaentrega = gDB.ValField(rs.Fields, cscImptFechaentrega)
    m_FechaOficial = gDB.ValField(rs.Fields, cscImptFechaoficial)
    m_DespachoNro = gDB.ValField(rs.Fields, cscImptDespachonro)
    m_Neto = gDB.ValField(rs.Fields, cscImptNeto)
    m_Ivari = gDB.ValField(rs.Fields, cscImptIvari)
    m_Ivarni = gDB.ValField(rs.Fields, cscImptIvarni)
    m_Total = gDB.ValField(rs.Fields, cscImptTotal)
    m_SubTotal = gDB.ValField(rs.Fields, cscImptSubtotal)
    m_Descuento1 = gDB.ValField(rs.Fields, cscImptDescuento1)
    m_Descuento2 = gDB.ValField(rs.Fields, cscImptDescuento2)
    m_ImporteDesc1 = gDB.ValField(rs.Fields, cscImptImportedesc1)
    m_ImporteDesc2 = gDB.ValField(rs.Fields, cscImptImportedesc2)
    m_prov_id = gDB.ValField(rs.Fields, cscProvId)
    m_Proveedor = gDB.ValField(rs.Fields, cscProvNombre)
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
    m_Firmado = gDB.ValField(rs.Fields, cscImptFirmado)
    
    m_Flete = gDB.ValField(rs.Fields, cscImptFlete)
    m_Seguro = gDB.ValField(rs.Fields, cscImptSeguro)

    m_DocEditable = gDB.ValField(rs.Fields, cscDocEditable)
    m_DocEditMsg = gDB.ValField(rs.Fields, cscDoceditMsg)

    m_depl_id = gDB.ValField(rs.Fields, cscDeplId)
    m_Deposito = gDB.ValField(rs.Fields, cscDeplNombre)
    
    ' Para ver documentos auxiliares
    '
    m_st_id = gDB.ValField(rs.Fields, cscStId)
    
    m_TaPropuesto = gDB.ValField(rs.Fields, cscTa_Propuesto)
    m_TaMascara = gDB.ValField(rs.Fields, cscTa_Mascara)
    
    m_LastDoc = m_doc_id
    m_LastProv = m_prov_id
    m_LastDocName = m_Documento
    m_LastProvName = m_Proveedor

  Else
    m_Id = csNO_ID
    m_Numero = 0
    m_Nrodoc = vbNullString
    m_Descrip = vbNullString
    m_Fecha = VDGetDateById(csToday)
    m_Fechaentrega = VDGetDateById(csTomorrow)
    m_FechaOficial = VDGetDateById(csTomorrow)
    m_DespachoNro = vbNullString
    m_Neto = 0
    m_Ivari = 0
    m_Ivarni = 0
    m_Total = 0
    m_SubTotal = 0
    m_Descuento1 = 0
    m_Descuento2 = 0
    m_ImporteDesc1 = 0
    m_ImporteDesc2 = 0
    m_prov_id = csNO_ID
    m_Proveedor = vbNullString
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
    
    m_Seguro = 0
    m_Flete = 0
  
    ' Para ver documentos auxiliares
    '
    m_st_id = csNO_ID
    
    m_TaPropuesto = False
    m_TaMascara = vbNullString
  
    m_depl_id = csNO_ID
    m_Deposito = vbNullString
    
    m_doc_id = m_LastDoc
    m_prov_id = m_LastProv
    m_Proveedor = m_LastProvName
    m_Documento = m_LastDocName
  
    DocEditableGet m_doc_id, m_DocEditable, m_DocEditMsg, csPreExpNewImportacionTmp
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

  Set m_Host = Host
  m_Host.Server.AddMenu c_MenuMain, csMenuEnum.csMenuExportacion, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(2496, vbNullString), csPreExpListImportacionTmp, c_MenuMain, 0, True, False, False, False, False, Me
                        '&Importaciones Temporales
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.cABMGeneric", "CSExport2.cImportacionTemporal", "CSABMInterface2.cABMGenericListDoc", "CSExport2.cImportacionTempListDoc", Me, LNGGetText(2482, vbNullString), 0
                                                                                                                                                                          'Importaciones Temporales
End Function

Private Function pSaveGarantias(ByVal ID As Long) As Boolean
  Dim register    As cRegister
  Dim iOrden      As Long
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  For Each Row In m_Items.Properties(c_Garantias).Grid.Rows
          
    Set register = New cRegister
    register.fieldId = cscImptgTMPId
    register.Table = csTImportacionTempGarantiaTMP
    register.ID = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        Case KI_GAR_ID
          register.Fields.Add2 cscGarId, Cell.ID, csId
      End Select
    Next
    
    iOrden = iOrden + 1
    register.Fields.Add2 cscImptgId, csNew, csInteger
    register.Fields.Add2 cscImptgOrden, iOrden, csInteger
    register.Fields.Add2 cscImptTMPId, ID, csId
    
    register.Fields.HaveLastUpdate = False
    register.Fields.HaveWhoModify = False
    
    If Not gDB.Save(register, , "pSaveGarantias", C_Module, c_ErrorSave) Then Exit Function
  Next
  
  pSaveGarantias = True
End Function

Private Function pSaveItems(ByVal ID As Long) As Boolean
  
  ' Generales
  '
  Dim register    As cRegister
  Dim iOrden      As Long
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  ' Para numeros de serie
  '
  Dim iOrden2     As Long
  Dim Grupo       As Long
  Dim PrId        As Long
  
  For Each Row In m_Items.Properties(c_Items).Grid.Rows
          
    Set register = New cRegister
    register.fieldId = cscImptiTMPId
    register.Table = csTImportacionTempItemTMP
    register.ID = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KI_RCI_ID
          If m_Copy Then
            register.Fields.Add2 cscImptiId, csNew, csInteger
          Else
            register.Fields.Add2 cscImptiId, Val(Cell.Value), csInteger
          End If
        Case KI_CANTIDAD
          register.Fields.Add2 cscImptiCantidad, Cell.Value, csDouble
        Case KI_DESCRIP
          register.Fields.Add2 cscImptiDescrip, Cell.Value, csText
        Case KI_PRECIO
          register.Fields.Add2 cscImptiPrecio, Cell.Value, csCurrency
        Case KI_PRECIO_LP
          register.Fields.Add2 cscImptiPrecioLista, Cell.Value, csCurrency
        Case KI_PRECIO_USR
          register.Fields.Add2 cscImptiPrecioUsr, Cell.Value, csCurrency
        Case KI_IMPORTE
          register.Fields.Add2 cscImptiImporte, Cell.Value, csCurrency
        Case KI_NETO
          register.Fields.Add2 cscImptiNeto, Cell.Value, csCurrency
        Case KI_IVARI
          register.Fields.Add2 cscImptiIvari, Cell.Value, csCurrency
        Case KI_IVARNI
          register.Fields.Add2 cscImptiIvarni, Cell.Value, csCurrency
        Case KI_IVARIPercent
          register.Fields.Add2 cscImptiIvariporc, Cell.Value, csDouble
        Case KI_IVARNIPercent
          register.Fields.Add2 cscImptiIvarniporc, Cell.Value, csDouble
        Case KI_PR_ID
          PrId = Cell.ID
          register.Fields.Add2 cscPrId, PrId, csId
        Case KI_SEGURO
          register.Fields.Add2 cscImptiSeguro, Cell.Value, csCurrency
        Case KI_FLETE
          register.Fields.Add2 cscImptiFlete, Cell.Value, csCurrency
        Case KI_CCOS_ID
          register.Fields.Add2 cscCcosId, Cell.ID, csId
        Case KI_GRUPO
          Grupo = Cell.ID
      End Select
    Next
    
    iOrden = iOrden + 1
    register.Fields.Add2 cscImptiOrden, iOrden, csInteger
    register.Fields.Add2 cscImptTMPId, ID, csId
    
    register.Fields.HaveLastUpdate = False
    register.Fields.HaveWhoModify = False
    
    If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
    
    ' Si es nuevo se usa el orden
    If Grupo = 0 Then Grupo = iOrden * -1
    If Not pSaveItemNroSerie(Row, iOrden2, PrId, ID, register.ID, Grupo) Then Exit Function
  Next
  
  Dim sqlstmt As String
  
  If m_ItemsDeleted <> vbNullString And m_Id <> csNO_ID And Not m_Copy Then
  
    Dim vDeletes As Variant
    Dim i As Long
    
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    vDeletes = Split(m_ItemsDeleted, ",")
    
    For i = 0 To UBound(vDeletes)
    
      Set register = New cRegister
      register.fieldId = cscImptibTMPId
      register.Table = csTImportacionTempItemBorradoTMP
      register.ID = csNew
      
      register.Fields.Add2 cscImptiId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscImptId, m_Id, csId
      register.Fields.Add2 cscImptTMPId, ID, csId
      
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
  
  m_Footer.Properties(cscImptSubtotal).Value = Neto
  
  Desc1 = m_ObjAbm.Properties(cscImptDescuento1).Value
  Desc2 = m_ObjAbm.Properties(cscImptDescuento2).Value
  
  Desc1 = Neto * Desc1 / 100
  m_Footer.Properties(cscImptImportedesc1).Value = Desc1
  
  Neto = Neto - Desc1
  
  Desc2 = Neto * Desc2 / 100
  m_Footer.Properties(cscImptImportedesc2).Value = Desc2
  
  Neto = Neto - Desc2
  
  m_Footer.Properties(cscImptNeto).Value = Neto
  m_Footer.Properties(cscImptIvari).Value = IvaRi
  m_Footer.Properties(cscImptIvarni).Value = IvaRni
  m_Footer.Properties(cscImptTotal).Value = Neto + IvaRni + IvaRi
  
  m_Footer.RefreshControls
End Sub

Private Sub pSetTasasImpositivas(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal PR_ID As Long, ByVal pr_nombre As String)
  Dim ti_ri    As Long
  Dim ti_rni   As Long
  
  If PR_ID = 0 Then Exit Sub
  
  If Not GetTasaFromProducto(PR_ID, ti_ri, ti_rni, True) Then Exit Sub
  
  If ti_ri = 0 Then
    MsgWarning LNGGetText(1597, vbNullString)
        'El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de compras & _
          para el iva responsable inscripto
    Exit Sub
  End If
  
  If ti_rni = 0 Then
    MsgWarning LNGGetText(1598, vbNullString)
          'El producto [" & pr_nombre & "] no tiene definida su tasa impositiva de compras & _
            para el iva responsable no inscripto
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
  
  sqlstmt = "select un_nombre, pr_llevanroserie from producto, unidad where un_id_compra = un_id and pr_id = " & PR_ID
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
    pCell(Row, KI_UNIDAD).Value = gDB.ValField(rs.Fields, cscUnNombre)
    pCell(Row, KI_PR_LLEVANROSERIE).ID = gDB.ValField(rs.Fields, cscPrLlevaNroSerie)
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
  Dim Prop   As cIABMProperty
  
  If m_DocEditable Then
    bState = m_ObjAbm.Properties.Item(cscDocId).HelpId <> csNO_ID
  Else
    bState = False
  End If
  
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
  
  If bState Then
    With m_ObjAbm.Properties
      .Item(cscDeplIdOrigen).Enabled = m_bShowStockData
    End With
  End If
  
  For Each Prop In m_Items.Properties
    Prop.Enabled = bState
  Next
  
  Dim AbmGen  As cABMGeneric
  
  Set AbmGen = m_Items
  AbmGen.RefreshEnabledState m_Items.Properties

  Set AbmGen = m_ObjAbm
  AbmGen.RefreshEnabledState m_ObjAbm.Properties

End Sub

Private Sub pSetDatosProveedor()
  Dim lp_id       As Long
  Dim ld_id       As Long
  Dim cpg_id      As Long
  Dim cpg_nombre  As String
  Dim LP          As cListaPrecio
  Dim LD          As cListaDescuento
  Dim iProp       As cIABMProperty
  Dim Filter      As String
  
  With m_ObjAbm.Properties.Item(cscProvId)
    If m_LastProv = .HelpId Then
      Exit Sub
    End If
    m_LastProv = .HelpId
  End With

  If Not GetProveedorData(m_LastProv, lp_id, ld_id, cpg_id) Then Exit Sub

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
  
  Filter = "exists(select lp_id from listaprecioProveedor where prov_id =" & m_LastProv
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
  
  Filter = "exists(select ld_id from listadescuentoProveedor where prov_id =" & m_LastProv
  Filter = Filter & " and ld_id = listadescuento.ld_id)"
  
  iProp.HelpFilter = Filter
  
  If ld_id <> csNO_ID Then
    Set LD = New cListaDescuento
    iProp.Value = LD.GetData(ld_id, cscLdNombre, csText)
    iProp.HelpId = ld_id
  End If
  
  ' Talonario y Categoria fiscal
  pGetIvaFromProveedor m_LastProv
  
  m_ObjAbm.ShowValue iProp
End Sub

Private Sub pGetIvaFromProveedor(ByVal prov_id As Long)
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  Dim bIvaChanged As Boolean
  Dim bLastIva    As Boolean
  
  sqlstmt = "sp_proveedorGetIva " & prov_id
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
               'El documento ya ha sido firmado desea borrar la firma, Firmar
      Exit Function
    End If
  End If
  
  If Not Doc.Firmar(m_doc_id, us_id) Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_DocImportacionTempFirmar " & m_Id & "," & us_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_est_id = gDB.ValField(rs.Fields, cscEstId)
  m_Estado = gDB.ValField(rs.Fields, cscEstNombre)
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties(csDocEstateID)
  
  With iProp
    .HelpId = m_est_id
    .Value = m_Estado
  End With
  
  gDB.GetData csTImportacionTemp, cscImptId, m_Id, cscImptFirmado, m_Firmado
  
  m_ObjAbm.ShowValue iProp
  
  pFirmar = True
End Function

Private Function pMove(ByVal MoveTo As ABM_MSG) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim doc_id  As Long
  
  doc_id = m_ObjAbm.Properties(cscDocId).HelpId
  
  If doc_id = csNO_ID Then MsgInfo "Debe seleccionar un documento"
  
  sqlstmt = "sp_DocImportacionTempMover " & MoveTo & "," & m_Numero & "," & doc_id
  
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
        m_LastProv = csNO_ID
        m_LastProvName = vbNullString
        
        ' Cargo un registro vacio
        '
        Load csNO_ID
        
        ' Refresco el formulario
        '
        pRefreshProperties
    
        ' Obtengo un nuevo numero de comprobante
        '
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscImptNrodoc
    
    End Select
    
  Else
    If Not Load(gDB.ValField(rs.Fields, 0)) Then Exit Function
    
    pRefreshProperties
  End If
  
  pMove = True
End Function

Private Sub pRefreshProperties()
  Dim c       As cIABMProperty
  Dim AbmGen  As cABMGeneric
  Dim Filter  As String
  
  With m_ObjAbm.Properties
    
    Set c = .Item(cscDocId)
    c.HelpId = m_doc_id
    c.Value = m_Documento
    
    Set c = .Item(cscImptFecha)
    c.Value = m_Fecha
    
    Set c = .Item(cscImptFechaentrega)
    c.Value = m_Fechaentrega
    
    Set c = .Item(cscProvId)
    c.HelpId = m_prov_id
    c.Value = m_Proveedor
    
    Set c = .Item(csDocNumberID)
    c.Value = m_Numero
    
    Set c = .Item(csDocEstateID)
    c.Value = m_Estado
    
    Set c = .Item(cscImptNrodoc)
    c.Value = m_Nrodoc
    c.TextMask = m_TaMascara
    c.TextAlign = vbRightJustify
    
    Set c = .Item(cscImptDescuento1)
    c.Value = m_Descuento1
    
    Set c = .Item(cscImptDescuento2)
    c.Value = m_Descuento2
    
    Set c = .Item(cscCpgId)
    c.HelpId = m_cpg_id
    c.Value = m_CondicionPago
    
    Set c = .Item(cscDeplIdOrigen)
    If m_depl_id <> csNO_ID Or Not m_bShowStockData Then
      c.HelpId = m_depl_id
      c.Value = m_Deposito
    Else
      ' Preferencias del usuario
      '
      c.HelpId = m_UserCfg.DeplId
      c.Value = m_UserCfg.DeplNombre
    End If
    
    Set c = .Item(cscLpId)
    Filter = "exists(select lp_id from listaprecioProveedor where prov_id =" & m_prov_id
    Filter = Filter & " and lp_id = listaprecio.lp_id)"
    c.HelpFilter = Filter
    c.HelpId = m_Lp_id
    c.Value = m_ListaPrecio
    
    Set c = .Item(cscLdId)
    Filter = "exists(select ld_id from listadescuentoProveedor where prov_id =" & m_prov_id
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
    
    Set c = .Item(cscImptDescrip)
    c.Value = m_Descrip
    
    Set c = .Item(cscImptDespachonro)
    c.Value = m_DespachoNro
    
    Set c = .Item(cscImptFechaoficial)
    c.Value = m_FechaOficial
    
    Set c = .Item(cscImptFlete)
    c.Value = m_Flete
    
    Set c = .Item(cscImptSeguro)
    c.Value = m_Seguro
    
  End With
  
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValues m_ObjAbm.Properties
  
  AbmGen.ResetChanged
  
  Set c = m_Items.Properties.Item(c_Items)
  If Not pLoadItems(c) Then Exit Sub
  
  m_ItemsDeleted = vbNullString
  
  Set c = m_Items.Properties.Item(c_Garantias)
  If Not pLoadGarantias(c) Then Exit Sub
  
  Set AbmGen = m_Items
  AbmGen.ShowValues m_Items.Properties
  
  With m_Footer.Properties
  
    Set c = .Item(cscImptSubtotal)
    c.Value = m_SubTotal
    
    Set c = .Item(cscImptImportedesc1)
    c.Value = m_ImporteDesc1
    
    Set c = .Item(cscImptImportedesc2)
    c.Value = m_ImporteDesc2
    
    Set c = .Item(cscImptNeto)
    c.Value = m_Neto
    
    Set c = .Item(cscImptIvari)
    c.Value = m_Ivari
    
    Set c = .Item(cscImptIvarni)
    c.Value = m_Ivarni
    
    Set c = .Item(cscImptTotal)
    c.Value = m_Total
  
  End With
  
  Set AbmGen = m_Footer
  AbmGen.ShowValues m_Footer.Properties
  
  pSetEnabled
End Sub

' Construccion - Destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2486, vbNullString)  'Error al grabar la Importación Temporal
              
  Set m_NrosSerie = New Collection
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  ReDim m_PcIds(0)
  
  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load
  m_UserCfg.ValidateIMPT
  
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
  ReDim m_PcIds(0)
  CollClear m_NrosSerie
  Set m_NrosSerie = Nothing
  
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

Private Sub pSetShowStockData()
  Dim DocId     As Long
  Dim DocIdRto  As Long
  Dim Doc       As cDocumento
  
  Set Doc = New cDocumento
  
  m_bShowStockData = False
  
  DocId = m_ObjAbm.Properties.Item(cscDocId).HelpId
  
  ' Si el remito mueve stock
  '
  If CBool(Doc.GetData(DocId, cscDocMueveStock, csBoolean)) Then
    m_bShowStockData = True
  End If
End Sub

Private Sub pProrratear(ByVal K As String, ByVal KI As String)
  Dim Row     As cIABMGridRow
  Dim Total   As Double
  Dim Monto   As Double
  Dim iProp   As cIABMProperty
  
  Set iProp = m_Items.Properties.Item(c_Items)
  
  Monto = Val(m_ObjAbm.Properties.Item(K).Value)
  
  For Each Row In m_Items.Properties(c_Items).Grid.Rows
    Total = Total + Val(pCell(Row, KI_CANTIDAD).Value)
  Next
  
  For Each Row In iProp.Grid.Rows
    pCell(Row, KI).Value = Monto * (Val(pCell(Row, KI_CANTIDAD).Value) / Total)
  Next
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_Items
  AbmObj.ShowValue iProp, True
  
End Sub

'///////////////////////////////////////////////////////////////////////////////////////////////////////////
Private Function pSaveItemNroSerie(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                   ByRef iOrden As Long, _
                                   ByVal PrId As Long, _
                                   ByVal RcTMPId As Long, _
                                   ByVal RciTMPId As Long, _
                                   ByVal Grupo As Long) As Boolean
                                   
  Dim pt        As cProductoSerieType
  Dim register  As cRegister
  
  ' Si lleva numero de serie
  '
  If pCell(Row, KI_PR_LLEVANROSERIE).ID Then
  
    ' Obtengo los numeros de serie y guardo un Item por cada uno
    '
    For Each pt In m_NrosSerie.Item(GetKey(Grupo))
      
      Set register = New cRegister
      register.fieldId = cscImptisTMPId
      register.Table = csTImportacionTempItemSerieTMP
      register.ID = csNew
      
      register.Fields.Add2 cscPrId, PrId, csId
      
      If m_Copy Then
        register.Fields.Add2 cscPrnsId, csNew, csInteger
      Else
        register.Fields.Add2 cscPrnsId, pt.prns_id, csId
      End If
      
      register.Fields.Add2 cscPrnsCodigo, pt.Codigo, csText
      register.Fields.Add2 cscPrnsDescrip, pt.Descrip, csText
      register.Fields.Add2 cscPrnsFechavto, pt.FechaVto, csDate
      
      register.Fields.Add2 cscImptTMPId, RcTMPId, csId
      register.Fields.Add2 cscImptiTMPId, RciTMPId, csId
      
      iOrden = iOrden + 1
      register.Fields.Add2 cscImptisOrden, iOrden, csInteger
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSaveItemNroSerie", C_Module, c_ErrorSave) Then Exit Function
      
    Next
  End If
  
  pSaveItemNroSerie = True
End Function

Private Function pGetItems() As cIABMProperty
  Set pGetItems = m_Items.Properties.Item(c_Items)
End Function

