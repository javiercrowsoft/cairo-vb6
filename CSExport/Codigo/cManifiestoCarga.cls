VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cManifiestoCarga"
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
' cManifiestoCarga
' 09-05-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cManifiestoCarga"

Private Const c_Items = "ITEMS"

Private Const K_NUMERO                         As Integer = 1
Private Const K_NRODOC                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHA                          As Integer = 4
Private Const K_FECHADOC                       As Integer = 5
Private Const K_CANTIDAD                       As Integer = 9
Private Const K_CLI_ID                         As Integer = 10
Private Const K_DOC_ID                         As Integer = 11
Private Const K_ITEMS                          As Integer = 15
Private Const K_EST_ID                         As Integer = 17
Private Const K_CCOS_ID                        As Integer = 18
Private Const K_SUC_ID                         As Integer = 19

Private Const K_CMARC_ID                       As Integer = 20
Private Const K_PUE_ID_ORIGEN                  As Integer = 21
Private Const K_PUE_ID_DESTINO                 As Integer = 22
Private Const K_CHOF_ID                        As Integer = 23
Private Const K_TRANS_ID                       As Integer = 24
Private Const K_DEPL_ID_ORIGEN                 As Integer = 25
Private Const K_DEPL_ID_DESTINO                As Integer = 26
Private Const K_BARC_ID                        As Integer = 27
Private Const K_HORA_PARTIDA                   As Integer = 28

Private Const KI_MFC_ID                         As Integer = 1
Private Const KI_MFCI_ID                        As Integer = 2
Private Const KI_ORDEN                          As Integer = 3
Private Const KI_CANTIDAD                       As Integer = 4
Private Const KI_PALLET                         As Integer = 5
Private Const KI_PALLETNRO                      As Integer = 6
Private Const KI_DESCRIP                        As Integer = 7
Private Const KI_PR_ID                          As Integer = 13
Private Const KI_UNIDAD                         As Integer = 19
Private Const KI_CCOS_ID                        As Integer = 22

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
Private m_FechaDoc                     As Date
Private m_HoraPartida                  As Date
Private m_Cantidad                     As Double
Private m_Chasis                       As String
Private m_Acoplado                     As String
Private m_chof_id                      As Long
Private m_Chofer                       As String
Private m_trans_id                     As Long
Private m_Transporte                   As String
Private m_pue_id_origen                As Long
Private m_PuertoOrigen                 As String
Private m_pue_id_destino               As Long
Private m_PuertoDestino                As String
Private m_depl_id_Origen               As Long
Private m_DepositoLogicoOrigen         As String
Private m_depl_id_Destino              As Long
Private m_DepositoLogicoDestino        As String
Private m_Barc_id                      As Long
Private m_Barco                        As String
Private m_cmarc_id                     As Long
Private m_ContraMarca                  As String
Private m_ccos_id                      As Long
Private m_CentroCosto                  As String
Private m_suc_id                       As Long
Private m_Sucursal                     As String
Private m_cli_id                       As Long
Private m_Cliente                      As String
Private m_doc_id                       As Long
Private m_Documento                    As String
Private m_Doct_id                      As Long
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

Private m_TaPropuesto       As Boolean
Private m_TaMascara         As String

Private m_DocEditable       As Boolean
Private m_DocEditMsg        As String

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

' propiedades publicas
' propiedades privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  If Not DocSecurityCanAccessEx(csPreExpNewManifiestoCarga, _
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscMfcNrodoc
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscMfcNrodoc
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

  Doc.ClientTable = csTManifiestoCarga
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
      ShowEditState m_DocEditMsg, LNGGetText(2497, vbNullString) 'Manifiestos de Carga
      
    Case MSG_DOC_DELETE
      If cIEditGeneric_Delete(m_Id) Then
        cIABMClient_MessageEx = True
        pMove MSG_DOC_NEXT
      End If
    Case MSG_DOC_ANULAR
      DocAnular m_Id, m_est_id, m_Estado, csPreExpAnularManifiestoCarga, csPreExpDesAnularManifiestoCarga, m_ObjAbm, m_DocEditable, m_DocEditMsg, "sp_DocManifiestoCargaAnular", "sp_DocManifiestoCargaEditableGet"
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
      DocumentSearch csEDT_ManifiestoCarga, Me, Not CBool(Info)
  
    Case MSG_DOC_DOC_ACTION
    
      If m_Id Then
        pShowPacking
      Else
        MsgInfo LNGGetText(1556, vbNullString)
                'Esta opción solo sirve para modificar documentos guardados y aplicados
      End If
    
    Case MSG_DOC_HISTORY
    
      If m_Id <> csNO_ID Then
    
        ShowHistory csManifiestoCarga, m_Id, m_Documento & " " & m_Nrodoc
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscMfcNrodoc
      
      End If

      ' Defino el estado de edicion del comprobante
      '
      pSetEnabled
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
  If Not DocCanSave(m_ObjAbm, cscMfcFecha) Then
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
  register.fieldId = cscMfcTMPId
  register.Table = csTManifiestoCargaTMP
  
  register.ID = csNew
    
  If m_Copy Then
    register.Fields.Add2 cscMfcId, csNew, csLong
  Else
    register.Fields.Add2 cscMfcId, m_Id, csLong
  End If
  
  If register.ID = csNew Then
    m_est_id = CSGeneralEx2.csEEstado.csEEst_Pendiente
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NUMERO
          register.Fields.Add2 cscMfcNumero, .Value, csLong
        Case K_NRODOC
          register.Fields.Add2 cscMfcNrodoc, .Value, csText
        Case K_DESCRIP
          register.Fields.Add2 cscMfcDescrip, .Value, csText
        Case K_FECHA
          register.Fields.Add2 cscMfcFecha, .Value, csDate
        Case K_HORA_PARTIDA
          register.Fields.Add2 cscMfcHoraPartida, .Value, csDate
        Case K_CLI_ID
          register.Fields.Add2 cscCliId, .HelpId, csId
        Case K_CCOS_ID
          register.Fields.Add2 cscCcosId, .HelpId, csId
        Case K_SUC_ID
          register.Fields.Add2 cscSucId, .HelpId, csId
        Case K_DOC_ID
          register.Fields.Add2 cscDocId, .HelpId, csId
        Case K_CMARC_ID
          register.Fields.Add2 cscCMarcId, .HelpId, csId
        Case K_PUE_ID_ORIGEN
          register.Fields.Add2 cscPueIdOrigen, .HelpId, csId
        Case K_PUE_ID_DESTINO
          register.Fields.Add2 cscPueIdDestino, .HelpId, csId
        Case K_CHOF_ID
          register.Fields.Add2 cscChofId, .HelpId, csId
        Case K_TRANS_ID
          register.Fields.Add2 cscTransId, .HelpId, csId
        Case K_DEPL_ID_ORIGEN
          register.Fields.Add2 cscDeplIdOrigen, .HelpId, csId
        Case K_DEPL_ID_DESTINO
          register.Fields.Add2 cscDeplIdDestino, .HelpId, csId
        Case K_BARC_ID
          register.Fields.Add2 cscBarcId, .HelpId, csId
      End Select
    End With
  Next
  
  For Each IProperty In m_Footer.Properties
    With IProperty
      Select Case .Key
        Case K_CANTIDAD
          register.Fields.Add2 cscMfcCantidad, .Value, csCurrency
      End Select
    End With
  Next
  
  register.Fields.Add2 cscEstId, m_est_id, csId
  register.Fields.Add2 cscDoctId, csEDT_ManifiestoCarga, csId
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If Not pSaveItems(register.ID) Then Exit Function
  If Not register.CommitTrans() Then Exit Function
  
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DocManifiestoCargaSave " & register.ID
  
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
  
  m_ObjTree.sqlstmt = "sp_lsdoc_ManifiestoCarga"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2497, vbNullString) 'Manifiestos de Carga
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
        Case K_HORA_PARTIDA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(2499, vbNullString) 'Debe indicar una hora de partida
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
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2500, vbNullString) 'Debe indicar un Puerto Origen
            Exit Function
          End If
        Case K_PUE_ID_DESTINO
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2501, vbNullString) 'Debe indicar un Puerto Destino
            Exit Function
          End If
        Case K_TRANS_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2502, vbNullString) 'Debe indicar un Transporte
            Exit Function
          End If
        Case K_DEPL_ID_ORIGEN
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2503, vbNullString) 'Debe indicar un Depósito de Origen
            Exit Function
          End If
        Case K_DEPL_ID_DESTINO
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2504, vbNullString) 'Debe indicar un Depósito de Destino
            Exit Function
          End If
        Case K_BARC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2422, vbNullString) 'Debe indicar una barco
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
  
  sqlstmt = "select doct_id, doc_id from ManifiestoCarga where mfc_id = " & ID
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreExpListManifiestoCarga)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
  m_ObjAbm.IsDocument = True

#If Not PREPROC_SFS Then
  Dim AbmGen      As cABMGenericDocEx
  
  Set AbmGen = m_ObjAbm
  With AbmGen
    .FactoryObject = "CSABMInterface2.cFactory"
    .ObjForm = "CSABMInterface2.fManifiestoCarga"
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
                          csTManifiestoCarga, _
                          cscMfcId, _
                          doc_id) Then
      Exit Function
    End If
  End If
  
  If Not DocSecurityCanAccess( _
                  csPreExpDeleteManifiestoCarga, _
                  doc_id, _
                  csEDocTPreDelete) Then
    Exit Function
  End If

  Dim sqlstmt As String
  
  sqlstmt = "sp_DocManifiestoCargaDelete " & ID & "," & EmpId & "," & User.ID
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not DocSecurityCanAccess(csPreExpListManifiestoCarga, GetdocIdFromObjAbm(m_ObjAbm), csEDocTPreList) Then Exit Function
  
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
      pShowTotales m_Items.Properties(c_Items).Grid.Rows
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

Private Function pColumnAfterEdit(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long)
  Dim Row     As cIABMGridRow
  
  Select Case IProperty.Grid.Columns(lCol).Key
    Case KI_PR_ID
      Set Row = IProperty.Grid.Rows(lRow)
      pSetDataProducto Row, NewValueID
      
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
  
  ID = Val(pCell(Row, KI_MFCI_ID).Value)
  
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
      Case KI_PR_ID
        If ValEmpty(Cell.ID, csId) Then
          MsgInfo LNGGetText(1565, vbNullString, strRow) 'Debe indicar un producto de venta (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRow = True
End Function

Private Function pGetCellFromKey(ByRef Row As cIABMGridRow, ByVal Key As Long) As cIABMGridCellValue
  Dim Cell    As cIABMGridCellValue
  For Each Cell In Row
    If Cell.Key = Key Then
      Set pGetCellFromKey = Cell
    End If
  Next
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
  m_ObjAbm.Tabs.Clear

  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = 0
  iTab.Name = C_strGeneral
  

  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = 1
  iTab.Name = LNGGetText(1371, vbNullString) 'Items
  

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
    c.HelpId = m_UserCfg.DocMfcId
    c.Value = m_UserCfg.DocMfcNombre
    
    bValidateDocDefault = c.HelpId <> csNO_ID
  End If
  
  c.HelpFilter = "'doct_id = " & csEDT_ManifiestoCarga & "'"
  
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
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscMfcFecha)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1569, vbNullString) 'Fecha
  c.LeftLabel = -580
  c.Left = 700
  c.Key = K_FECHA
  c.Value = m_Fecha
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscMfcFechaDoc)
  c.PropertyType = cspDate
  c.Name = LNGGetText(2505, vbNullString) 'Fecha Doc.
  c.LeftLabel = -580
  c.Left = 700
  c.Key = K_FECHADOC
  c.Value = m_FechaDoc
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCliId)
  c.PropertyType = cspHelp
  c.Table = csCliente
  c.TopFromProperty = cscMfcFecha
  c.Left = 2700
  c.LeftLabel = -580
  c.Name = LNGGetText(1150, vbNullString) 'Cliente
  c.Key = K_CLI_ID
  c.HelpId = m_cli_id
  c.Value = m_Cliente
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscMfcNrodoc)
  c.PropertyType = cspText
  c.Name = LNGGetText(1065, vbNullString) 'Numero
  c.Size = 50
  c.Key = K_NRODOC
  c.Value = m_Nrodoc
  c.TextMask = m_TaMascara
  c.TextAlign = vbRightJustify
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscDeplIdOrigen)
  c.PropertyType = cspHelp
  c.Table = csDepositoLogico
  c.Name = LNGGetText(2506, vbNullString) 'Deposito Lógico Origen
  c.Key = K_DEPL_ID_ORIGEN
  c.HelpId = m_depl_id_Origen
  c.Value = m_DepositoLogicoOrigen
  c.TopFromProperty = cscMfcFecha
  c.Left = 6500
  
        
  Set c = m_ObjAbm.Properties.Add(Nothing, cscDeplIdDestino)
  c.PropertyType = cspHelp
  c.Table = csDepositoLogico
  c.Name = LNGGetText(2507, vbNullString) 'Depósito Lógico Destino
  c.Key = K_DEPL_ID_DESTINO
  c.HelpId = m_depl_id_Destino
  c.Value = m_DepositoLogicoDestino
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCcosId)
  c.PropertyType = cspHelp
  c.TopFromProperty = cscMfcFecha
  c.Left = 10200
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
  
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPueIdOrigen)
  c.PropertyType = cspHelp
  c.Table = csPuerto
  c.Name = LNGGetText(2400, vbNullString) 'Puerto Origen
  c.Key = K_PUE_ID_ORIGEN
  c.HelpId = m_pue_id_origen
  c.Value = m_PuertoOrigen
  c.TabIndex = 1
  
        
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPueIdDestino)
  c.PropertyType = cspHelp
  c.Table = csPuerto
  c.Name = LNGGetText(2401, vbNullString) 'Puerto Destino
  c.Key = K_PUE_ID_DESTINO
  c.HelpId = m_pue_id_destino
  c.Value = m_PuertoDestino
  c.TabIndex = 1
  
        
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCMarcId)
  c.PropertyType = cspHelp
  c.Table = csContraMarca
  c.Name = LNGGetText(2508, vbNullString) 'Contra Marca
  c.Key = K_CMARC_ID
  c.HelpId = m_cmarc_id
  c.Value = m_ContraMarca
  c.TabIndex = 1
  
        
  Set c = m_ObjAbm.Properties.Add(Nothing, cscChofId)
  c.PropertyType = cspHelp
  c.Table = csChofer
  c.Name = LNGGetText(1051, vbNullString) 'Chofer
  c.Key = K_CHOF_ID
  c.HelpId = m_chof_id
  c.Value = m_Chofer
  c.TabIndex = 1
  
        
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTransId)
  c.PropertyType = cspHelp
  c.Table = csTransporte
  c.Name = LNGGetText(1050, vbNullString) 'Transporte
  c.Key = K_TRANS_ID
  c.HelpId = m_trans_id
  c.Value = m_Transporte
  c.TabIndex = 1
  
        
  Set c = m_ObjAbm.Properties.Add(Nothing, cscBarcId)
  c.PropertyType = cspHelp
  c.Table = csBarco
  c.Name = LNGGetText(2424, vbNullString) 'Barco
  c.Key = K_BARC_ID
  c.HelpId = m_Barc_id
  c.Value = m_Barco
  c.TabIndex = 1
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscMfcHoraPartida)
  c.PropertyType = cspTime
  c.Name = LNGGetText(2509, vbNullString) 'Hora Partida
  c.Key = K_HORA_PARTIDA
  c.Value = m_HoraPartida
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscMfcDescrip)
  c.PropertyType = cspText
  c.SubType = cspMemo
  c.Name = LNGGetText(1211, vbNullString) 'Observ.
  c.LeftLabel = -600
  c.Size = 5000
  c.Key = K_DESCRIP
  c.Value = m_Descrip
  c.LeftFromProperty = cscMfcFecha
  c.TopFromProperty = cscMfcNrodoc
  c.Width = 8070
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
  
  Set c = m_Footer.Properties.Add(Nothing, cscMfcCantidad)
  c.PropertyType = cspNumeric
  c.Format = m_GeneralConfig.FormatDecImporte
  c.Name = LNGGetText(1584, vbNullString) 'Total
  c.SubType = cspMoney
  c.Key = K_CANTIDAD
  c.Value = m_Cantidad
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
  
  sqlstmt = "sp_DocManifiestoCargaGetItems " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  With Propiedad.Grid.Columns
    .Clear
    Propiedad.Grid.Rows.Clear
  
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_MFCI_ID
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1367, vbNullString) 'Articulo
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
    o.Name = LNGGetText(1374, vbNullString) 'Cantidad
    o.Format = m_GeneralConfig.FormatDecCantidad
    o.PropertyType = cspNumeric
    o.SubType = cspDouble
    o.Width = 1200
    o.Key = KI_CANTIDAD
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(2510, vbNullString) 'Pallets"
    o.PropertyType = cspNumeric
    o.SubType = cspInteger
    o.Width = 1200
    o.Key = KI_PALLET
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(2511, vbNullString) 'Nro Pallet
    o.PropertyType = cspText
    o.Width = 1200
    o.Key = KI_PALLETNRO
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1165, vbNullString) 'Unidad
    o.PropertyType = cspText
    o.Width = 1200
    o.Key = KI_UNIDAD
    o.Enabled = False
    
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
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscMfciId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscMfciId)
    fv.Key = KI_MFCI_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPrNombreventa)
    fv.ID = gDB.ValField(rs.Fields, cscPrId)
    fv.Key = KI_PR_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscMfciDescrip)
    fv.Key = KI_DESCRIP
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscMfciCantidad)
    fv.Key = KI_CANTIDAD
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscMfciPallets)
    fv.Key = KI_PALLET
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscMfciNropallet)
    fv.Key = KI_PALLETNRO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscUnNombre)
    fv.Key = KI_UNIDAD

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

  sqlstmt = "sp_DocManifiestoCargaGet " & EmpId & "," & ID & "," & gDB.UserId
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscMfcId)
    m_Numero = gDB.ValField(rs.Fields, cscMfcNumero)
    m_Nrodoc = gDB.ValField(rs.Fields, cscMfcNrodoc)
    m_Descrip = gDB.ValField(rs.Fields, cscMfcDescrip)
    m_Fecha = gDB.ValField(rs.Fields, cscMfcFecha)
    m_HoraPartida = gDB.ValField(rs.Fields, cscMfcHoraPartida)
    m_Cantidad = gDB.ValField(rs.Fields, cscMfcCantidad)
    m_cli_id = gDB.ValField(rs.Fields, cscCliId)
    m_Cliente = gDB.ValField(rs.Fields, cscCliNombre)
    m_ccos_id = gDB.ValField(rs.Fields, cscCcosId)
    m_CentroCosto = gDB.ValField(rs.Fields, cscCcosNombre)
    m_suc_id = gDB.ValField(rs.Fields, cscSucId)
    m_Sucursal = gDB.ValField(rs.Fields, cscSucNombre)
    m_doc_id = gDB.ValField(rs.Fields, cscDocId)
    m_Documento = gDB.ValField(rs.Fields, cscDocNombre)
    m_Doct_id = gDB.ValField(rs.Fields, cscDoctId)
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)
    m_est_id = gDB.ValField(rs.Fields, cscEstId)
    m_Estado = gDB.ValField(rs.Fields, cscEstNombre)
    m_Firmado = gDB.ValField(rs.Fields, cscMfcFirmado)
    
    m_cmarc_id = gDB.ValField(rs.Fields, cscCMarcId)
    m_ContraMarca = gDB.ValField(rs.Fields, cscCMarcNombre)
    m_pue_id_origen = gDB.ValField(rs.Fields, cscPueIdOrigen)
    m_PuertoOrigen = gDB.ValField(rs.Fields, "Puerto Origen")
    m_pue_id_destino = gDB.ValField(rs.Fields, cscPueIdDestino)
    m_PuertoDestino = gDB.ValField(rs.Fields, "Puerto Destino")
    m_depl_id_Origen = gDB.ValField(rs.Fields, cscDeplIdOrigen)
    m_DepositoLogicoOrigen = gDB.ValField(rs.Fields, "Deposito Origen")
    m_depl_id_Destino = gDB.ValField(rs.Fields, cscDeplIdDestino)
    m_DepositoLogicoDestino = gDB.ValField(rs.Fields, "Deposito Destino")
    m_chof_id = gDB.ValField(rs.Fields, cscChofId)
    m_Chofer = gDB.ValField(rs.Fields, cscChofNombre)
    m_trans_id = gDB.ValField(rs.Fields, cscTransId)
    m_Transporte = gDB.ValField(rs.Fields, cscTransNombre)
    m_Barc_id = gDB.ValField(rs.Fields, cscBarcId)
    m_Barco = gDB.ValField(rs.Fields, cscBarcNombre)

    m_TaPropuesto = gDB.ValField(rs.Fields, cscTa_Propuesto)
    m_TaMascara = gDB.ValField(rs.Fields, cscTa_Mascara)
    
    m_DocEditable = gDB.ValField(rs.Fields, cscDocEditable)
    m_DocEditMsg = gDB.ValField(rs.Fields, cscDoceditMsg)

    m_LastDoc = m_doc_id
    m_LastCli = m_cli_id
    m_LastDocName = m_Documento
    m_LastCliName = m_Cliente

  Else
    m_Id = csNO_ID
    m_Numero = 0
    m_Nrodoc = vbNullString
    m_Descrip = vbNullString
    m_Fecha = VDGetDateById(csToday)
    m_HoraPartida = #12:00:00 AM#
    m_Cantidad = 0
    m_cli_id = csNO_ID
    m_Cliente = vbNullString
    m_ccos_id = csNO_ID
    m_CentroCosto = vbNullString
    m_doc_id = csNO_ID
    m_Documento = vbNullString
    m_Doct_id = csNO_ID
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_est_id = csNO_ID
    m_Estado = vbNullString
    m_suc_id = User.suc_id
    m_Sucursal = User.Sucursal
    m_Firmado = False
  
    m_cmarc_id = csNO_ID
    m_ContraMarca = vbNullString
    m_pue_id_origen = csNO_ID
    m_PuertoOrigen = vbNullString
    m_pue_id_destino = csNO_ID
    m_PuertoDestino = vbNullString
    m_depl_id_Origen = csNO_ID
    m_DepositoLogicoOrigen = vbNullString
    m_depl_id_Destino = csNO_ID
    m_DepositoLogicoDestino = vbNullString
    m_chof_id = csNO_ID
    m_Chofer = vbNullString
    m_trans_id = csNO_ID
    m_Transporte = vbNullString
    m_Barc_id = csNO_ID
    m_Barco = vbNullString
  
    m_doc_id = m_LastDoc
    m_cli_id = m_LastCli
    m_Cliente = m_LastCliName
    m_Documento = m_LastDocName
    
    m_TaPropuesto = False
    m_TaMascara = vbNullString
  
    DocEditableGet m_doc_id, m_DocEditable, m_DocEditMsg, csPreExpNewManifiestoCarga
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
  m_Host.Server.AddMenu LNGGetText(2512, vbNullString), csPreExpListManifiestoCarga, c_MenuMain, 0, True, False, False, False, False, Me
                        '&Manifiestos de Carga
  
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
#If PREPROC_SFS Then
  m_Host.MenuListDocClick "CSABMInterface2.cABMGeneric", "CSExport2.cManifiestoCarga", "CSABMInterface2.CABMGenericListDoc", "CSExport2.cManifiestoCargaListDoc", Me, LNGGetText(2497, vbNullString), 0
#Else                                                                                                                                                                  'Manifiestos de Carga
  m_Host.MenuListDocClick "CSABMInterface2.cABMGenericDocEx", "CSExport2.cManifiestoCarga", "CSABMInterface2.CABMGenericListDoc", "CSExport2.cManifiestoCargaListDoc", Me, LNGGetText(2497, vbNullString), 0
#End If
End Function

Private Function pSaveItems(ByVal ID As Long) As Boolean
  Dim register As cRegister
  Dim IProperty As cIABMProperty
  Dim iOrden As Long
  
  For Each IProperty In m_Items.Properties
    With IProperty
      Select Case .Key
        Case K_ITEMS
        
          Dim Row  As cIABMGridRow
          Dim Cell As cIABMGridCellValue
          
          For Each Row In IProperty.Grid.Rows
          
            Set register = New cRegister
            register.fieldId = cscMfcITMPId
            register.Table = csTManifiestoCargaItemTMP
            register.ID = csNew
            
            For Each Cell In Row
              Select Case Cell.Key
                
                Case KI_MFCI_ID
                  If m_Copy Then
                    register.Fields.Add2 cscMfciId, csNew, csInteger
                  Else
                    register.Fields.Add2 cscMfciId, Val(Cell.Value), csInteger
                  End If
                Case KI_CANTIDAD
                  register.Fields.Add2 cscMfciCantidad, Cell.Value, csDouble
                Case KI_PALLET
                  register.Fields.Add2 cscMfciPallets, Cell.Value, csInteger
                Case KI_PALLETNRO
                  register.Fields.Add2 cscMfciNropallet, Cell.Value, csText
                Case KI_DESCRIP
                  register.Fields.Add2 cscMfciDescrip, Cell.Value, csText
                Case KI_PR_ID
                  register.Fields.Add2 cscPrId, Cell.ID, csId
                Case KI_CCOS_ID
                  register.Fields.Add2 cscCcosId, Cell.ID, csId
              End Select
            Next
            
            iOrden = iOrden + 1
            register.Fields.Add2 cscMfciOrden, iOrden, csInteger
            register.Fields.Add2 cscMfcTMPId, ID, csId
            
            register.Fields.HaveLastUpdate = False
            register.Fields.HaveWhoModify = False
            
            If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
          Next
      End Select
    End With
  Next
  
  Dim sqlstmt As String
  
  If m_ItemsDeleted <> vbNullString And m_Id <> csNO_ID And Not m_Copy Then
  
    Dim vDeletes As Variant
    Dim i As Long
    
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    vDeletes = Split(m_ItemsDeleted, ",")
    
    For i = 0 To UBound(vDeletes)
    
      Set register = New cRegister
      register.fieldId = cscMfcIbTMPId
      register.Table = csTManifiestoCargaItemBorradoTMP
      register.ID = csNew
      
      register.Fields.Add2 cscMfciId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscMfcId, m_Id, csId
      register.Fields.Add2 cscMfcTMPId, ID, csId
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveItems = True
End Function

' Reglas del Objeto de Negocios
Private Sub pShowTotales(ByRef Rows As CSInterfacesABM.cIABMGridRows)
  Dim Cantidad  As Long
  
  Dim Row       As CSInterfacesABM.cIABMGridRow
  
  For Each Row In Rows
    Cantidad = Cantidad + Val(pGetCellFromKey(Row, KI_CANTIDAD).Value)
  Next
  
  m_Footer.Properties(cscMfcCantidad).Value = Cantidad
  m_Footer.RefreshControls
End Sub

Private Sub pSetDataProducto(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal PR_ID As Long)
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select un_nombre from producto, unidad where un_id_venta = un_id and pr_id = " & PR_ID
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
    pGetCellFromKey(Row, KI_UNIDAD).Value = gDB.ValField(rs.Fields, cscUnNombre)
  End If
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
  
  sqlstmt = "sp_DocManifiestoCargaFirmar " & m_Id & "," & us_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_est_id = gDB.ValField(rs.Fields, cscEstId)
  m_Estado = gDB.ValField(rs.Fields, cscEstNombre)
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties(csDocEstateID)
  
  With iProp
    .HelpId = m_est_id
    .Value = m_Estado
  End With
  
  gDB.GetData csTManifiestoCarga, cscMfcId, m_Id, cscMfcFirmado, m_Firmado
  
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
  
  sqlstmt = "sp_DocManifiestoCargaMover " & MoveTo & "," & m_Numero & "," & doc_id
  
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscMfcNrodoc
    
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
    
    Set c = .Item(cscMfcFecha)
    c.Value = m_Fecha
    
    Set c = .Item(cscMfcHoraPartida)
    c.Value = m_HoraPartida
    
    Set c = .Item(cscCliId)
    c.HelpId = m_cli_id
    c.Value = m_Cliente
    
    Set c = .Item(csDocNumberID)
    c.Value = m_Numero
    
    Set c = .Item(csDocEstateID)
    c.Value = m_Estado
    
    Set c = .Item(cscMfcNrodoc)
    c.Value = m_Nrodoc
    c.TextMask = m_TaMascara
    c.TextAlign = vbRightJustify
    
    Set c = .Item(cscCcosId)
    c.HelpId = m_ccos_id
    c.Value = m_CentroCosto
    
    Set c = .Item(cscSucId)
    c.HelpId = m_suc_id
    c.Value = m_Sucursal
    
    Set c = .Item(cscCMarcId)
    c.HelpId = m_cmarc_id
    c.Value = m_ContraMarca
    
    Set c = .Item(cscPueIdOrigen)
    c.HelpId = m_pue_id_origen
    c.Value = m_PuertoOrigen
    
    Set c = .Item(cscPueIdDestino)
    c.HelpId = m_pue_id_destino
    c.Value = m_PuertoDestino
    
    Set c = .Item(cscDeplIdOrigen)
    c.HelpId = m_depl_id_Origen
    c.Value = m_DepositoLogicoOrigen
    
    Set c = .Item(cscDeplIdDestino)
    c.HelpId = m_depl_id_Destino
    c.Value = m_DepositoLogicoDestino
    
    Set c = .Item(cscChofId)
    c.HelpId = m_chof_id
    c.Value = m_Chofer
    
    Set c = .Item(cscTransId)
    c.HelpId = m_trans_id
    c.Value = m_Transporte
    
    Set c = .Item(cscBarcId)
    c.HelpId = m_Barc_id
    c.Value = m_Barco
  
    Set c = .Item(cscMfcDescrip)
    c.Value = m_Descrip
  
  End With
  
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValues m_ObjAbm.Properties
  
  AbmGen.ResetChanged
  
  Set c = m_Items.Properties.Item(c_Items)
  If Not pLoadItems(c) Then Exit Sub
  
  m_ItemsDeleted = vbNullString
  
  Set AbmGen = m_Items
  AbmGen.ShowValues m_Items.Properties
  
  Set c = m_Footer.Properties.Item(cscMfcCantidad)
  c.Value = m_Cantidad
  
  Set AbmGen = m_Footer
  AbmGen.ShowValues m_Footer.Properties
  
  pSetEnabled
End Sub

' Construccion - Destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2498, vbNullString) 'Error al grabar el Manifiesto de Carga
  
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load
  m_UserCfg.ValidateMFC
  
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

Private Sub pShowPacking()
  On Error GoTo ControlError

  Dim o As CSExport2.cPackingList
  Set o = New CSExport2.cPackingList
  
  o.ShowPackingManifiesto pGetCliId(), pGetMfcIds()

  GoTo ExitProc
ControlError:
  MngError Err, "pShowPacking", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetMfcIds() As Long()
  Dim rtn() As Long
  ReDim rtn(1)
  rtn(1) = m_Id
  pGetMfcIds = rtn
End Function

Private Function pGetCliId() As Long
  pGetCliId = m_ObjAbm.Properties(cscCliId).HelpId
End Function

Private Function pGetItems() As cIABMProperty
  Set pGetItems = m_Items.Properties.Item(c_Items)
End Function

