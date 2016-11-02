VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDepositoBanco"
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
' cDepositoBanco
' 11-05-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cDepositoBanco"

Private Const c_Efectivo = "Efectivo"
Private Const c_Cheques = "Cheques"
Private Const c_ChequesT = "Cheques En Cartera"

Private Const c_Chequera = "Chequera"

Private Const c_colcheque = "cheque"

Private Const c_Items = "ITEMS"

Private Const K_NUMERO                         As Integer = 1
Private Const K_NRODOC                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHA                          As Integer = 4
Private Const K_TOTAL                          As Integer = 9
Private Const K_BCO_ID                         As Integer = 10
Private Const K_DOC_ID                         As Integer = 11
Private Const K_DOCT_ID                        As Integer = 12

Private Const K_EFECTIVO                       As Integer = 105
Private Const K_CHEQUES                        As Integer = 106
Private Const K_CHEQUEST                       As Integer = 107

Private Const K_EST_ID                         As Integer = 17
Private Const K_SUC_ID                         As Integer = 19
Private Const K_LGJ_ID                         As Integer = 27
Private Const K_COTIZACION                     As Integer = 28
Private Const K_CUE_ID                         As Integer = 29

Private Const KI_DBCOI_ID                       As Integer = 2
Private Const KI_ORDEN                          As Integer = 3
Private Const KI_DESCRIP                        As Integer = 6
Private Const KI_IMPORTE                        As Integer = 8
Private Const KI_IMPORTE_ORIGEN                 As Integer = 9
Private Const KI_CUE_ID                         As Integer = 22
Private Const KI_CHEQ_ID                        As Integer = 23
Private Const KI_BCO_ID                         As Integer = 24
Private Const KI_CHEQ_ID_SAVED                  As Integer = 25

Private Const KI_CUE_ID_HABER                   As Integer = 301

Private Const KICH_IMPORTE               As Integer = 3
Private Const KICH_IMPORTEORIGEN         As Integer = 4
Private Const KICH_CHEQUERA              As Integer = 5
Private Const KICH_CHEQUE                As Integer = 6
Private Const KICH_CHEQ_ID               As Integer = 7
Private Const KICH_MON_ID                As Integer = 8
Private Const KICH_FECHACOBRO            As Integer = 10
Private Const KICH_FECHAVTO              As Integer = 11
Private Const KICH_CLE_ID                As Integer = 12
Private Const KICH_DESCRIP               As Integer = 13

Private Const csLegajo = 15001

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
Private m_Total                        As Double
Private m_lgj_id                       As Long
Private m_Legajo                       As String

Private m_Cotizacion                   As Double
Private m_suc_id                       As Long
Private m_Sucursal                     As String
Private m_bco_id                       As Long
Private m_banco                        As String
Private m_cue_id                       As Long
Private m_cuenta                       As String
Private m_doc_id                       As Long
Private m_Documento                    As String
Private m_Doct_id                      As Long
Private m_mon_id                       As Long
Private m_lastMonIdCotizacion          As Long
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_Firmado                      As Boolean

' Para ver documentos auxiliares
'
Private m_as_id                        As Long

Private m_Editing           As Boolean

Private m_Footer            As cIABMGeneric
Private m_Items             As cIABMGeneric
Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_LastDoc           As Long
Private m_LastBco           As Long
Private m_LastCue           As Long
Private m_LastDocName       As String
Private m_LastBcoName       As String
Private m_LastCueName       As String

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost

Private m_Copy              As Boolean

Private m_GeneralConfig     As cGeneralConfig

Private m_DocEditable       As Boolean
Private m_DocEditMsg        As String

Private m_TaPropuesto       As Boolean
Private m_TaMascara         As String

Private m_MonDefault        As Long

Private m_EfectivoDeleted     As String
Private m_ChequesDeleted      As String
Private m_TChequesDeleted     As String

Private m_iOrden            As Long

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

' propiedades publicas
' propiedades privadas
' funciones publicas
' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean

  If Not DocSecurityCanAccessEx(csPreTsrNewDepositoBanco, _
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
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscDbcoNrodoc
  pSetEnabled
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True

  cIEditGeneric_Edit csNO_ID
  m_LastBco = csNO_ID
  
  If Not m_DocEditable Then
    If LenB(m_DocEditMsg) Then
      MsgWarning m_DocEditMsg
    End If
  End If
  
  If m_ObjAbm.Properties.Item(cscDocId).HelpId = csNO_ID Then
    MsgInfo LNGGetText(1562, vbNullString)  'Debe indicar un documento
  End If
  
  ' Obtengo el numero para este comprobante
  '
  GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscDbcoNrodoc
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

  Doc.ClientTable = csTDepositoBanco
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
    
    Case MSG_GRID_ROW_DELETEDl
      cIABMClient_MessageEx = True
      pShowTotales
    
    Case MSG_DOC_EDIT_STATE
      ShowEditState m_DocEditMsg, LNGGetText(2160, vbNullString)  'Dep�sitos Bancarios
      
    Case MSG_DOC_DELETE
      If cIEditGeneric_Delete(m_Id) Then
        cIABMClient_MessageEx = True
        pMove MSG_DOC_NEXT
      End If
    
    Case MSG_DOC_ANULAR
      DocAnular m_Id, m_est_id, m_Estado, csPreTsrAnularDepositoBanco, csPreTsrDesAnularDepositoBanco, m_ObjAbm, m_DocEditable, m_DocEditMsg, "sp_DocDepositoBancoAnular", "sp_DocDepositoBancoEditableGet"
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
      DocumentSearch csEDT_DepositoBanco, Me, Not CBool(Info)
  
    Case MSG_DOC_DOC_AUX
      
      If m_Id Then
      
        ShowDocAux m_as_id, _
                   "CSContabilidad2.cAsiento", _
                   "CSABMInterface2.cABMGeneric"
      Else
        MsgInfo LNGGetText(1620, vbNullString)  'Debe editar un comprobante guardado para poder ver los documentos auxiliares
      End If
  
    Case MSG_DOC_HISTORY
    
      If m_Id <> csNO_ID Then
    
        ShowHistory csDepositoBanco, m_Id, m_Documento & " " & m_Nrodoc
      Else
        
        MsgInfo LNGGetText(1552, vbNullString) 'El documento aun no ha sido guardado
      End If
  
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
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscDbcoNrodoc
        
      End If
      
      ' Defino el estado de edicion del comprobante
      '
      pSetEnabled
    
    Case K_BCO_ID
    
      Dim iProp As cIABMProperty
      Set iProp = pGetCuenta()
      iProp.HelpFilter = pGetFilterCuenta(pGetBanco().HelpId)
      m_ObjAbm.ShowValue iProp
      Dim AbmObj As cABMGeneric
      Set AbmObj = m_ObjAbm
      AbmObj.ValidateProp iProp, cscCueId
      
    Case K_CUE_ID
      pShowBanco
      pShowCotizacion
  
    Case K_FECHA
      
      ' Cotizacion
      m_lastMonIdCotizacion = csNO_ID
      pShowCotizacion
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register     As cRegister
  Dim Cotizacion   As Double
  Dim TotalOrigen  As Double
  Dim bMonedaLegal As Boolean
  Dim Total        As Double
  
  ' Save and State
  '
  If Not DocCanEdit(m_DocEditable, m_DocEditMsg) Then
    cIABMClient_Save = True
    Exit Function
  End If
  If Not DocCanSave(m_ObjAbm, cscDbcoFecha) Then
    cIABMClient_Save = False
    Exit Function
  End If
  
  ' OJO -tsr
  If pGetCheques().Rows.count = 0 And _
     pGetTCheques().Rows.count = 0 And _
     pGetEfectivo().Rows.count = 0 Then
    MsgWarning LNGGetText(3903, vbNullString) 'El documento debe contener al menos un item
    cIABMClient_Save = False
    Exit Function
  End If
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  register.fieldId = cscDbcoTMPId
  register.Table = csTDepositoBancoTMP
  
  register.Id = csNew
    
  If m_Copy Then
    register.Fields.Add2 cscDbcoId, csNew, csLong
  Else
    register.Fields.Add2 cscDbcoId, m_Id, csLong
  End If
  
  If register.Id = csNew Then
    m_est_id = CSGeneralEx2.csEEstado.csEEst_Pendiente
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NUMERO
          register.Fields.Add2 cscDbcoNumero, .Value, csLong
        Case K_NRODOC
          register.Fields.Add2 cscDbcoNrodoc, .Value, csText
        Case K_DESCRIP
          register.Fields.Add2 cscDbcoDescrip, .Value, csText
        Case K_FECHA
          register.Fields.Add2 cscDbcoFecha, .Value, csDate
        Case K_BCO_ID
          register.Fields.Add2 cscBcoId, .HelpId, csId
        Case K_SUC_ID
          register.Fields.Add2 cscSucId, .HelpId, csId
        Case K_DOC_ID
          register.Fields.Add2 cscDocId, .HelpId, csId
        Case K_CUE_ID
          register.Fields.Add2 cscCueId, .HelpId, csId
        Case K_COTIZACION
          Cotizacion = .Value
          register.Fields.Add2 cscDbcoCotizacion, .Value, csDouble
        Case K_LGJ_ID
          register.Fields.Add2 cscLgjId, .HelpId, csId
      End Select
    End With
  Next
  
  ' Si la cotizacion es 0 es por que la moneda
  ' del documento es la de curso legal y por tanto
  ' no grabo el importe origen
  If Cotizacion = 0 Then
    Cotizacion = 1
    bMonedaLegal = True
  End If
  
  For Each IProperty In m_Footer.Properties
    With IProperty
      Select Case .Key
        Case K_TOTAL
          Total = .Value
      End Select
    End With
  Next
  
  TotalOrigen = Total
  register.Fields.Add2 cscDbcoTotal, TotalOrigen * Cotizacion, csCurrency
  register.Fields.Add2 cscDbcoGrabarasiento, 1, csBoolean
  register.Fields.Add2 cscEstId, m_est_id, csId
  
  If bMonedaLegal Then
    register.Fields.Add2 cscDbcoTotalorigen, 0, csCurrency
  Else
    register.Fields.Add2 cscDbcoTotalorigen, TotalOrigen, csCurrency
  End If
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  m_iOrden = 0
  
  If Not pSaveEfectivo(register.Id, Cotizacion, bMonedaLegal) Then Exit Function
  If Not pSaveCheques(register.Id) Then Exit Function
  If Not pSaveTCheques(register.Id, Cotizacion, bMonedaLegal) Then Exit Function
  
  If Not register.CommitTrans() Then Exit Function
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  sqlstmt = "sp_DocDepositoBancoSave " & register.Id
  
  If Not gDB.OpenRs(sqlstmt, rs, , , , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim Id As Long
  If Not GetDocIDFromRecordset(rs, Id) Then Exit Function
  
  m_Copy = False
  
  cIABMClient_Save = Load(Id)
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  m_ObjTree.sqlstmt = "sp_lsdoc_DepositoBanco"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2160, vbNullString)  'Depositos Bancarios
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IProperty    As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_FECHA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(1558, vbNullString)  'Debe indicar una fecha
            Exit Function
          End If
        Case K_DOC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1562, vbNullString)  'Debe indicar un documento
            Exit Function
          End If
        Case K_CUE_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1261, vbNullString)  'Debe indicar una cuenta
            Exit Function
          End If
        Case K_SUC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1560, vbNullString)  'Debe indicar una sucursal
            Exit Function
          End If
        Case K_COTIZACION
          If ValEmpty(.Value, csDouble) And .Visible Then
            MsgInfo LNGGetText(1626, vbNullString)  'Debe indicar una cotizaci�n
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
    Case K_EFECTIVO
      cIABMClientGrid_IsEmptyRow = pIsEmptyRow(Row, RowIndex)
    Case K_CHEQUES
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowCheques(Row, RowIndex)
    Case K_CHEQUEST
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowTCheques(Row, RowIndex)
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
  
  sqlstmt = "select doct_id, doc_id from DepositoBanco where dbco_id = " & Id
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreTsrListDepositoBanco)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Dim AbmGen      As cABMGeneric
  
  Set m_ObjAbm = rhs
  m_ObjAbm.IsDocument = True
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
                          csTDepositoBanco, _
                          cscDbcoId, _
                          doc_id) Then
      Exit Function
    End If
  End If
  
  If Not DocSecurityCanAccess( _
                  csPreTsrDeleteDepositoBanco, _
                  doc_id, _
                  csEDocTPreDelete) Then
    Exit Function
  End If

  Dim sqlstmt As String
  
  sqlstmt = "sp_DocDepositoBancoDelete " & Id & "," & EmpId & "," & User.Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not DocSecurityCanAccess(csPreTsrListDepositoBanco, GetdocIdFromObjAbm(m_ObjAbm), csEDocTPreList) Then Exit Function
  
                            ' Id = csDocChanged esto significa que se cambio
                            '                   el documento estando en un
                            '                   comprobante ya guardado
                            '
  m_IsNew = Id = csNO_ID Or Id = csDocChanged
                     
  If Not Load(Id) Then Exit Function
  
  If m_ObjAbm.Properties.count = 0 Then
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

Private Function cIEditGeneric_Preview(ByVal Id As Long) As Boolean

End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  On Error GoTo ControlError
  
  Select Case Key
    Case K_EFECTIVO
      pShowTotales
      cIABMClientGrid_ColumnAfterUpdate = True
    Case K_CHEQUES
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateCheque(m_Items.Properties.Item(c_Cheques), lRow, lCol)
    Case K_CHEQUEST
      With m_Items.Properties.Item(c_Items)
        pShowTotales
        cIABMClientGrid_ColumnAfterUpdate = True
      End With
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
    Case K_CHEQUEST
      cIABMClientGrid_ColumnAfterEdit = pColumnAfterEdit(m_Items.Properties.Item(c_ChequesT), lRow, lCol, NewValue, NewValueID)
    Case K_EFECTIVO, K_CHEQUES
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
    Case K_CHEQUEST
      cIABMClientGrid_ColumnBeforeEdit = pColumnBeforeEdit(m_Items.Properties.Item(c_Items), lRow, lCol, iKeyAscii)
    Case K_EFECTIVO, K_CHEQUES
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
  pColumnBeforeEdit = True
End Function

Private Function pColAUpdateCheque(ByRef IProperty As cIABMProperty, _
                                   ByVal lRow As Long, _
                                   ByVal lCol As Long) As Boolean
  Dim Row      As cIABMGridRow
  Dim Value    As Double
  
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      Case KICH_IMPORTEORIGEN
        Set Row = .Rows(lRow)
        With pCell(Row, KICH_MON_ID)
          If .Id <> m_MonDefault Or .Id = 0 Then
            pCell(Row, KICH_IMPORTE).Value = Val(pCell(Row, KICH_IMPORTEORIGEN).Value) * Val(pGetCotizacion().Value)
          Else
            pCell(Row, KICH_IMPORTEORIGEN).Value = 0
          End If
        End With
        
      Case KICH_IMPORTE
      
      Case KI_CUE_ID_HABER
        Dim MonId   As Long
        Dim CueId   As Long
        Dim Moneda  As String
        
        Set Row = .Rows(lRow)
        
        CueId = pCell(Row, KI_CUE_ID_HABER).Id
        GetMonedaFromCuenta MonId, Moneda, CueId
        
        With pCell(Row, KICH_MON_ID)
          .Value = Moneda
          .Id = MonId
        End With
      
        If MonId = m_MonDefault Or MonId = 0 Then
          pCell(Row, KICH_IMPORTEORIGEN).Value = 0
        End If
        
        pCol(IProperty.Grid.Columns, KICH_CHEQUERA).HelpFilter = cscCueId & "=" & CueId

#If PREPROC_SFS Then
        Dim AbmObj As cABMGeneric
#Else
        Dim AbmObj As cABMGenericDocEx
#End If
        Set AbmObj = m_Items
        AbmObj.RefreshColumnProperties IProperty, c_Chequera
        
        pColAUpdateCheque = True
        Exit Function
        
      Case KICH_CHEQUERA
        
        Set Row = .Rows(lRow)
        With pCell(Row, KICH_CHEQUERA)
          If .Id <> csNO_ID Then
            pCell(Row, KICH_CHEQUE).Value = GetChequeNumber(.Id)
          End If
        End With
        
      Case Else
        pColAUpdateCheque = True
        Exit Function
    End Select
  End With
  
  pShowTotales
  pColAUpdateCheque = True
End Function

Private Function pColumnAfterEdit(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long)
  Dim Row     As cIABMGridRow
  
  Select Case IProperty.Grid.Columns(lCol).Key
      Case KI_CHEQ_ID
        Set Row = IProperty.Grid.Rows(lRow)
        pSetChequeData Row, NewValueID
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
  Dim Id As Long
  
  Select Case Key
    Case K_CHEQUES
      Id = Val(pCell(Row, KI_DBCOI_ID).Value)
      If Id <> csNO_ID Then m_ChequesDeleted = m_ChequesDeleted & Id & ","
    Case K_CHEQUEST
      Id = Val(pCell(Row, KI_DBCOI_ID).Value)
      If Id <> csNO_ID Then m_TChequesDeleted = m_TChequesDeleted & Id & ","
    Case K_EFECTIVO
      Id = Val(pCell(Row, KI_DBCOI_ID).Value)
      If Id <> csNO_ID Then m_EfectivoDeleted = m_EfectivoDeleted & Id & ","
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_EFECTIVO
      cIABMClientGrid_ValidateRow = pValidateRow(Row, RowIndex)
    Case K_CHEQUES
      cIABMClientGrid_ValidateRow = pValidateRowCheques(Row, RowIndex)
    Case K_CHEQUEST
      cIABMClientGrid_ValidateRow = pValidateRowTCheques(Row, RowIndex)
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
      Case KI_IMPORTE
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRow = bRowIsEmpty
End Function

Private Function pIsEmptyRowCheques(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                    ByVal RowIndex As Long) As Boolean
                                    
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CUE_ID_HABER, KICH_CHEQUERA, KICH_MON_ID, KICH_CLE_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    
      Case KICH_IMPORTE, KICH_IMPORTEORIGEN
        If Not ValEmpty(Val(Cell.Value), csDouble) Then
          bRowIsEmpty = True
          Exit For
        End If
      
      Case KICH_DESCRIP, KICH_CHEQUE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = True
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowCheques = bRowIsEmpty
End Function

Private Function pIsEmptyRowTCheques(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_IMPORTE
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowTCheques = bRowIsEmpty
End Function

Private Function pValidateRowTCheques(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bCueIdOrCheqe         As Boolean
  
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_IMPORTE
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(1897, vbNullString, strRow) 'Debe indicar un importe (1)
          Exit Function
        End If
      Case KI_CHEQ_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bCueIdOrCheqe = True
        End If
      Case KI_CUE_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bCueIdOrCheqe = True
        End If
    End Select
  Next
  
  If Not bCueIdOrCheqe Then
    MsgInfo LNGGetText(2161, vbNullString)  'Debe indicar una Cuenta � un Cheque (1)
    Exit Function
  End If
  
  pValidateRowTCheques = True
End Function

Private Function pValidateRow(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_IMPORTE
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(1897, vbNullString, strRow) 'Debe indicar un importe (1)
          Exit Function
        End If
      Case KI_CUE_ID_HABER
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2186, vbNullString, strRow) 'Debe indicar una cuenta origen (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRow = True
End Function

Private Function pValidateRowCheques(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                                     ByVal RowIndex As Long) As Boolean
                                     
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bOrigen               As Boolean
  Dim MonId                 As Long
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      
      Case KI_CUE_ID_HABER
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2186, vbNullString, strRow)   'Debe indicar una cuenta origen (1)
          Exit Function
        End If
      Case KICH_MON_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2114, vbNullString, strRow)   'Debe indicar una moneda (1)
          Exit Function
        End If
        MonId = Cell.Id
        
      Case KICH_CLE_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2115, vbNullString, strRow)   'Debe indicar un clearing (1)
          Exit Function
        End If
    
      Case KICH_IMPORTEORIGEN
        bOrigen = Not ValEmpty(Val(Cell.Value), csDouble)
      
      Case KICH_IMPORTE
        If ValEmpty(Val(Cell.Value), csDouble) Then
          MsgInfo LNGGetText(1897, vbNullString, strRow)   'Debe indicar un importe (1)
          Exit Function
        End If
      
      Case KICH_CHEQUERA
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(2193, vbNullString, strRow)   'Debe indicar una Chequera (1)
          Exit Function
        End If
      
      Case KICH_CHEQUE
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(2116, vbNullString, strRow)   'Debe indicar una n�mero de cheque (1)
          Exit Function
        End If
      
      Case KICH_FECHACOBRO
        If ValEmpty(Cell.Value, csDate) Then
          MsgInfo LNGGetText(2117, vbNullString, strRow)   'Debe indicar una fecha para depositar (1)
          Exit Function
        End If
      
      Case KICH_FECHAVTO
        If ValEmpty(Cell.Value, csDate) Then
          MsgInfo LNGGetText(1384, vbNullString, strRow)   'Debe indicar una fecha de vencimiento (1)
          Exit Function
        End If
    End Select
  Next
  
  If Not bOrigen And MonId <> m_MonDefault Then
    MsgInfo LNGGetText(2118, vbNullString, strRow)   'Debe indicar un importe para la moneda extranjera (1)
    Exit Function
  End If
  
  pValidateRowCheques = True
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim Filter      As String
  Dim c           As cIABMProperty
  Dim AbmGen      As cABMGeneric
  Dim Cotizacion  As Double

  ' Preferencias del usuario
  '
  Dim bValidateDocDefault As Boolean
  
  Set AbmGen = m_ObjAbm
  AbmGen.ResetLayoutMembers
  
  AbmGen.NoButtons1 = BUTTON_DOC_APLIC
  AbmGen.NoButtons2 = BUTTON_DOC_ACTION
  AbmGen.InitButtons
  
  With m_ObjAbm.Properties
      
    .Clear
    
    With .Add(Nothing, cscDocId)
      .PropertyType = cspHelp
      .Table = CSDocumento2.CSDocumento
      .Name = LNGGetText(1567, vbNullString)  'Documento
      .Key = K_DOC_ID
      
      If m_doc_id <> csNO_ID Then
        .HelpId = m_doc_id
        .Value = m_Documento
      Else
        ' Preferencias del usuario
        '
        .HelpId = m_UserCfg.DocDbcoId
        .Value = m_UserCfg.DocDbcoNombre
        
        bValidateDocDefault = .HelpId <> csNO_ID
      End If
      
      .HelpFilter = "'doct_id = " & csEDT_DepositoBanco & "'"
    End With
    
    With .Add(Nothing, csDocNumberID)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(1065, vbNullString)  'N�mero
      .Key = K_NUMERO
      .Value = m_Numero
      .Enabled = False
    End With
    
    With .Add(Nothing, csDocEstateID)
      .PropertyType = cspText
      .Name = LNGGetText(1568, vbNullString)  'Estado
      .Key = K_EST_ID
      .Value = m_Estado
      .Enabled = False
    End With
    
    With .Add(Nothing, cscDbcoFecha)
      .PropertyType = cspDate
      .Name = LNGGetText(1569, vbNullString)  'Fecha
      .LeftLabel = -580
      .Left = 700
      .Key = K_FECHA
      .Value = m_Fecha
    End With
    
    With .Add(Nothing, cscDbcoNrodoc)
      .PropertyType = cspText
      .Name = LNGGetText(1065, vbNullString)  'N�mero
      .Size = 50
      .Key = K_NRODOC
      .Value = m_Nrodoc
      .TextMask = m_TaMascara
      .TextAlign = vbRightJustify
    End With
    
    With .Add(Nothing, cscBcoId)
      .PropertyType = cspHelp
      .Table = csBanco
      .TopFromProperty = cscDbcoFecha
      .Left = 3800
      .LeftLabel = -580
      .Name = LNGGetText(1122, vbNullString)  'Banco
      .Key = K_BCO_ID
      .HelpId = m_bco_id
      .Value = m_banco
      AbmGen.NewKeyPropFocus = cscBcoId
      .Width = 4500
    End With
    
    With .Add(Nothing, cscCueId)
      .PropertyType = cspHelp
      .Table = csCuenta
      .HelpFilter = pGetFilterCuenta(m_bco_id)
      .LeftLabel = -580
      .Name = LNGGetText(1267, vbNullString)  'Cuenta
      .Key = K_CUE_ID
      .HelpId = m_cue_id
      .Value = m_cuenta
      .Width = 4500
    End With
    
    With .Add(Nothing, cscLgjId)
      .PropertyType = cspHelp
      .Table = csLegajo
      .TopFromProperty = cscDbcoFecha
      .Left = 9400
      .Name = LNGGetText(1575, vbNullString)  'Legajo
      .Key = K_LGJ_ID
      .HelpId = m_lgj_id
      .Value = m_Legajo
      .LeftLabel = -800
    End With
    
    With .Add(Nothing, cscDbcoCotizacion)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1635, vbNullString)  'Cotizaci�n
      .Format = m_GeneralConfig.FormatDecCotizacion
      .Key = K_COTIZACION
      .Value = m_Cotizacion
      .Width = 1000
      .LeftLabel = -800
      .Visible = m_mon_id <> m_MonDefault
    End With
    
    If m_Cotizacion <> 0 Then
      Cotizacion = m_Cotizacion
    Else
      Cotizacion = 1
    End If
    
    With .Add(Nothing, cscSucId)
      .PropertyType = cspHelp
      .Table = csSucursal
      .Name = LNGGetText(1281, vbNullString)  'Sucursal
      .Key = K_SUC_ID
      .HelpId = m_suc_id
      .Value = m_Sucursal
      .LeftLabel = -800
    End With
    
    With .Add(Nothing, cscDbcoDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = LNGGetText(1211, vbNullString)  'Observ.
      .LeftLabel = -600
      .Size = 5000
      .Key = K_DESCRIP
      .Value = m_Descrip
      .LeftFromProperty = cscDbcoFecha
      .TopFromProperty = cscDbcoNrodoc
      .Width = 5380
      .Height = 800
      .TopToPrevious = 440
    End With
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function

  Const c_TabEfectivo = 0
  Const c_TabCheque = 1
  Const c_TabChequeT = 2

  With m_Items.Tabs
  
    .Clear
    
    With .Add(Nothing)
      .Index = c_TabEfectivo
      .Name = LNGGetText(2100, vbNullString) 'Efectivo
    End With
    
    With .Add(Nothing)
      .Index = c_TabCheque
      .Name = LNGGetText(2099, vbNullString) 'Cheques
    End With
    
    With .Add(Nothing)
      .Index = c_TabChequeT
      .Name = LNGGetText(2188, vbNullString) 'Cheques en Cartera
    End With
    
  End With
  
  Set AbmGen = m_Items
  AbmGen.ResetLayoutMembers
  
  
  With m_Items.Properties
  
    '/////////////////////////////////////////////////////////////////
    ' EFECTIVO
    Set c = .Add(Nothing, c_Efectivo)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadEfectivo(c, Cotizacion) Then Exit Function
      .Name = c_Efectivo
      .Key = K_EFECTIVO
      .TabIndex = 0
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    m_EfectivoDeleted = vbNullString
    
    '/////////////////////////////////////////////////////////////////
    ' CHEQUES
    Set c = .Add(Nothing, c_Cheques)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadCheques(c) Then Exit Function
      .Name = c_Cheques
      .Key = K_CHEQUES
      .TabIndex = c_TabCheque
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_ChequesDeleted = vbNullString
  
    '/////////////////////////////////////////////////////////////////
    ' CHEQUES DE TERCERO
    Set c = .Add(Nothing, c_ChequesT)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadTCheques(c, Cotizacion) Then Exit Function
      .Name = c_ChequesT
      .Key = K_CHEQUEST
      .TabIndex = c_TabChequeT
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_TChequesDeleted = vbNullString
  
  End With
    
  If Not m_Items.Show(Me) Then Exit Function
  
  Set AbmGen = m_Footer
  AbmGen.ResetLayoutMembers
  
  With m_Footer.Properties
    
    .Clear
  
    Set c = .Add(Nothing, cscDbcoTotal)
    With c
      .PropertyType = cspNumeric
      .Format = m_GeneralConfig.FormatDecImporte
      .Name = LNGGetText(1584, vbNullString)  'Total
      .SubType = cspMoney
      .Key = K_TOTAL
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
Private Sub pShowCotizacion()
  Dim MonId         As Long
  Dim dDate         As Variant
  Dim iProp         As cIABMProperty
  Dim bCueChanged   As Boolean
  
  With pGetCuenta()
    
    If Not (m_LastCue = .HelpId And Not m_Copy) Then
      m_LastCue = .HelpId
      m_LastCueName = .Value
      bCueChanged = True
    End If
    
  End With
  
  If Not gDB.GetData(csTCuenta, cscCueId, m_LastCue, cscMonId, MonId) Then Exit Sub
  
  Set iProp = m_ObjAbm.Properties.Item(cscDbcoCotizacion)
  iProp.Visible = MonId <> m_MonDefault And MonId <> csNO_ID
  
  If bCueChanged Then
    
    If m_lastMonIdCotizacion <> MonId Or iProp.Value = 0 Then
      dDate = m_ObjAbm.Properties.Item(cscDbcoFecha).Value
      If Not IsDate(dDate) Then dDate = Date
      iProp.Value = GetCotizacion(MonId, dDate)
      m_lastMonIdCotizacion = MonId
    End If
  End If
  
  m_ObjAbm.ShowValue iProp
End Sub

'Private Function pGetMonedaDefault() As Long
'  Dim sqlstmt As String
'  Dim rs      As Recordset
'
'  sqlstmt = "select mon_id from Moneda where mon_legal <> 0"
'  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
'
'  If rs.EOF Then
'    MsgWarning LNGGetText(2150, vbNullString)  'Debe definir cual es la moneda legal con la que opera el sistema
'    Exit Function
'  End If
'
'  pGetMonedaDefault = gDB.ValField(rs.Fields, cscMonId)
'End Function

Private Function pLoadEfectivo(ByRef Propiedad As cIABMProperty, ByVal Cotizacion As Double) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocDepositoBancoGetItems " & m_Id & "," & csEDepositoBancoItemTipo.csDbcoiTEfectivo
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadEfectivo", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_DBCOI_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2190, vbNullString)   'Cuenta Origen
        .PropertyType = cspHelp
        .Table = csCuenta
        .Width = 1800
        .Key = KI_CUE_ID_HABER
        .HelpFilter = GetHelpFilterCuenta()
      End With
            
      With .Add(Nothing)
        .Name = LNGGetText(1228, vbNullString)   'Importe
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .Key = KI_IMPORTE
      End With
      
      With .Add(Nothing)
        .Name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 4000
        .Key = KI_DESCRIP
      End With
      
    End With
  
    With .Rows
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscDbcoiId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscDbcoiId)
            .Key = KI_DBCOI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCueNombre)
            .Id = gDB.ValField(rs.Fields, cscCueId)
            .Key = KI_CUE_ID_HABER
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscDbcoiImporte) / Cotizacion
            .Key = KI_IMPORTE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscDbcoiDescrip)
            .Key = KI_DESCRIP
          End With
          
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadEfectivo = True
End Function

Private Function pLoadCheques(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocDepositoBancoGetItems " & m_Id & "," & csEDepositoBancoItemTipo.csDbcoiTCheques
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCheques", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_DBCOI_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2190, vbNullString)    'Cuenta Origen
        .PropertyType = cspHelp
        .Table = csCuenta
        
        '.HelpFilter = cscCuecId & "=" & csECuecBancos
        .HelpFilter = GetHelpFilterChequesP()
        
        .Width = 2200
        .Key = KI_CUE_ID_HABER
      End With
            
      With .Add(Nothing, c_Chequera)
        .Name = LNGGetText(2064, vbNullString)    'Chequera
        .PropertyType = cspHelp
        .Table = csChequera
        .Width = 1000
        .Key = KICH_CHEQUERA
      End With
            
      With .Add(Nothing)
        .Name = LNGGetText(2063, vbNullString)    'Mon
        .PropertyType = cspHelp
        .Table = csMoneda
        .Width = 520
        .Key = KICH_MON_ID
        .Enabled = False
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1901, vbNullString)    'Origen
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 920
        .Key = KICH_IMPORTEORIGEN
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1228, vbNullString)    'Importe
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 920
        .Key = KICH_IMPORTE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2059, vbNullString)    'Nr. Cheque
        .PropertyType = cspText
        .Width = 1000
        .Key = KICH_CHEQUE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2058, vbNullString)    'Cheque
        .PropertyType = cspText
        .Width = 1000
        .Enabled = False
        .Key = KICH_CHEQ_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2065, vbNullString)    'Depositar el
        .PropertyType = cspDate
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Value = Date
        .Width = 970
        .Key = KICH_FECHACOBRO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1634, vbNullString)    'Vto.
        .PropertyType = cspDate
        .Width = 970
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Value = DateAdd("m", 1, Date)
        .Key = KICH_FECHAVTO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1083, vbNullString)    'Clering
        .PropertyType = cspHelp
        .Table = csClearing
        .Width = 800
        .Key = KICH_CLE_ID
      End With
      
      With .Add(Nothing)
        .Name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 1600
        .Key = KICH_DESCRIP
      End With
    
    End With
    
    With .Rows
    
      While Not rs.EOF
        
        With .Add(Nothing, rs(cscDbcoiId).Value)
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscDbcoiId)
            .Key = KI_DBCOI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCueNombre)
            .Id = gDB.ValField(rs.Fields, cscCueId)
            .Key = KI_CUE_ID_HABER
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscChqCodigo)
            .Id = gDB.ValField(rs.Fields, cscChqId)
            .Key = KICH_CHEQUERA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscMonNombre)
            .Id = gDB.ValField(rs.Fields, cscMonId)
            .Key = KICH_MON_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscDbcoiImporteorigen)
            .Key = KICH_IMPORTEORIGEN
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscDbcoiImporte)
            .Key = KICH_IMPORTE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCheqNumeroDoc)
            .Key = KICH_CHEQUE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCheqNumero)
            .Id = gDB.ValField(rs.Fields, cscCheqId)
            .Key = KICH_CHEQ_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCheqFechaCobro)
            .Key = KICH_FECHACOBRO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCheqFechaVto)
            .Key = KICH_FECHAVTO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCleNombre)
            .Id = gDB.ValField(rs.Fields, cscCleId)
            .Key = KICH_CLE_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscDbcoiDescrip)
            .Key = KICH_DESCRIP
          End With
        
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadCheques = True
End Function

Private Function pLoadTCheques(ByRef Propiedad As cIABMProperty, ByVal Cotizacion As Double) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_DocDepositoBancoGetItems " & m_Id & "," & csEDepositoBancoItemTipo.csDbcoiTChequesT
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadtCheques", C_Module) Then Exit Function
  
  Dim o               As cIABMGridColumn
  Dim ColCheque       As cIABMGridColumn
  Dim ColCheqFilter   As String
  
  With Propiedad.Grid.Columns
    .Clear
    Propiedad.Grid.Rows.Clear
  
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_DBCOI_ID
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1122, vbNullString)  'Banco
    o.PropertyType = cspText
    o.Width = 1800
    o.Key = KI_BCO_ID
    o.Enabled = False
    
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_CHEQ_ID_SAVED
    
    Set o = .Add(Nothing, c_colcheque)
    o.Name = LNGGetText(2058, vbNullString)  'Cheque
    o.PropertyType = cspHelp
    o.Table = csCheque
    o.Width = 1400
    o.Key = KI_CHEQ_ID
    Set ColCheque = o
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1267, vbNullString)  'Cuenta
    o.PropertyType = cspHelp
    o.Table = csCuenta
    o.HelpFilter = pGetFilterCuentaItem()
    o.Width = 2200
    o.Enabled = False
    o.Key = KI_CUE_ID
    
    Set o = .Add(Nothing)
    o.Name = C_strDescrip
    o.PropertyType = cspText
    o.SubType = cspTextButtonEx
    o.Width = 3000
    o.Key = KI_DESCRIP
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(2162, vbNullString)  'Importe Origen
    o.PropertyType = cspNumeric
    o.Format = m_GeneralConfig.FormatDecImporte
    o.SubType = cspMoney
    o.Width = 1400
    o.Enabled = False
    o.Key = KI_IMPORTE_ORIGEN
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1228, vbNullString)  'Importe
    o.PropertyType = cspNumeric
    o.Format = m_GeneralConfig.FormatDecImporte
    o.SubType = cspMoney
    o.Width = 1200
    o.Key = KI_IMPORTE
  End With
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscDbcoiId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscDbcoiId)
    fv.Key = KI_DBCOI_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscBcoNombre)
    fv.Key = KI_BCO_ID
    
    Set fv = F.Add(Nothing)
    fv.Id = gDB.ValField(rs.Fields, cscCheqId)
    fv.Key = KI_CHEQ_ID_SAVED
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCheqNumeroDoc)
    fv.Id = gDB.ValField(rs.Fields, cscCheqId)
    fv.Key = KI_CHEQ_ID
    
    ColCheqFilter = ColCheqFilter & fv.Id & C_StrColon
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscCueNombre)
    fv.Id = gDB.ValField(rs.Fields, cscCueId)
    fv.Key = KI_CUE_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscDbcoiDescrip)
    fv.Key = KI_DESCRIP
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscDbcoiImporteorigen)
    fv.Key = KI_IMPORTE_ORIGEN
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscDbcoiImporte)
    fv.Key = KI_IMPORTE
    
    rs.MoveNext
  Wend
  
  ColCheque.HelpFilter = pGetFilterCheque(RemoveLastColon(ColCheqFilter))
  
  pLoadTCheques = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  Dim Cotizacion  As Double
  Dim sqlstmt     As String

  sqlstmt = "sp_DocDepositoBancoGet " & EmpId & "," & Id & "," & gDB.UserId
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Cotizacion = gDB.ValField(rs.Fields, cscDbcoCotizacion)
    Cotizacion = IIf(m_Cotizacion <> 0, m_Cotizacion, 1)

    m_Id = gDB.ValField(rs.Fields, cscDbcoId)
    m_Numero = gDB.ValField(rs.Fields, cscDbcoNumero)
    m_Nrodoc = gDB.ValField(rs.Fields, cscDbcoNrodoc)
    m_Descrip = gDB.ValField(rs.Fields, cscDbcoDescrip)
    m_Fecha = gDB.ValField(rs.Fields, cscDbcoFecha)
    m_Total = gDB.ValField(rs.Fields, cscDbcoTotal) / Cotizacion
    m_bco_id = gDB.ValField(rs.Fields, cscBcoId)
    m_banco = gDB.ValField(rs.Fields, cscBcoNombre)
    m_cue_id = gDB.ValField(rs.Fields, cscCueId)
    m_cuenta = gDB.ValField(rs.Fields, cscCueNombre)
    m_suc_id = gDB.ValField(rs.Fields, cscSucId)
    m_Sucursal = gDB.ValField(rs.Fields, cscSucNombre)
    m_doc_id = gDB.ValField(rs.Fields, cscDocId)
    m_Documento = gDB.ValField(rs.Fields, cscDocNombre)
    m_Doct_id = gDB.ValField(rs.Fields, cscDoctId)
    m_lgj_id = gDB.ValField(rs.Fields, cscLgjId)
    m_Legajo = gDB.ValField(rs.Fields, cscLgjCodigo)
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)
    m_est_id = gDB.ValField(rs.Fields, cscEstId)
    m_Estado = gDB.ValField(rs.Fields, cscEstNombre)
    m_Firmado = gDB.ValField(rs.Fields, cscDbcoFirmado)
    m_mon_id = gDB.ValField(rs.Fields, cscMonId)
    m_DocEditable = gDB.ValField(rs.Fields, cscDocEditable)
    m_DocEditMsg = gDB.ValField(rs.Fields, cscDoceditMsg)
    
    ' Para ver documentos auxiliares
    '
    m_as_id = gDB.ValField(rs.Fields, cscAsId)
    
    m_TaPropuesto = gDB.ValField(rs.Fields, cscTa_Propuesto)
    m_TaMascara = gDB.ValField(rs.Fields, cscTa_Mascara)

    m_LastDoc = m_doc_id
    m_LastBco = m_bco_id
    m_LastCue = m_cue_id
    m_LastDocName = m_Documento
    m_LastBcoName = m_banco
    m_LastCueName = m_cuenta
    
    m_lastMonIdCotizacion = m_mon_id
    
  Else
    m_Id = csNO_ID
    m_Numero = 0
    m_Nrodoc = vbNullString
    m_Descrip = vbNullString
    m_Fecha = VDGetDateById(csToday)
    m_Total = 0
    m_bco_id = csNO_ID
    m_banco = vbNullString
    m_cue_id = csNO_ID
    m_cuenta = vbNullString
    m_doc_id = csNO_ID
    m_Documento = vbNullString
    m_Doct_id = csNO_ID
    m_lgj_id = csNO_ID
    m_Legajo = vbNullString
    m_Cotizacion = 0
    m_mon_id = csNO_ID
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_est_id = csNO_ID
    m_Estado = vbNullString
    m_suc_id = User.suc_id
    m_Sucursal = User.Sucursal
    m_Firmado = False
  
    m_doc_id = m_LastDoc
    m_bco_id = m_LastBco
    m_cue_id = m_LastCue
    m_banco = m_LastBcoName
    m_Documento = m_LastDocName
    m_cuenta = m_LastCueName
  
    ' Para ver documentos auxiliares
    '
    m_as_id = csNO_ID
    
    m_TaPropuesto = False
    m_TaMascara = vbNullString
  
    m_lastMonIdCotizacion = csNO_ID
  
    ' Cotizacion
    If m_doc_id <> csNO_ID Then
      m_Cotizacion = DocGetCotizacion(m_doc_id, m_Fecha)
    End If
    
    DocEditableGet m_doc_id, m_DocEditable, m_DocEditMsg, csPreTsrNewDepositoBanco
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
  Dim str_2048    As String
  
  str_2048 = LNGGetText(2048, vbNullString)   'T&esoreria
  
  Set m_Host = Host
  m_Host.Server.AddMenu str_2048, csMenuEnum.csMenuTesoreria, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(2163, vbNullString), csPreTsrListDepositoBanco, str_2048, 0, True, False, False, False, False, Me
                          '&Dep�sitos Bancarios
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.cABMGeneric", "CSTesoreria2.cDepositoBanco", "CSABMInterface2.CABMGenericListDoc", "CSTesoreria2.cDepositoBancoListDoc", Me, LNGGetText(2164, vbNullString), 0
                                                                                                                                                                        'Dep�sito Bancario
End Function

Private Function pSaveEfectivo(ByVal Id As Long, ByVal Cotizacion As Double, ByVal bMonedaLegal As Boolean) As Boolean
  Dim register  As cRegister
  Dim Origen    As Double
        
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  For Each Row In m_Items.Properties(c_Efectivo).Grid.Rows
  
    Set register = New cRegister
    register.fieldId = cscDbcoiTMPId
    register.Table = csTDepositoBancoItemTMP
    register.Id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KI_DBCOI_ID
          If m_Copy Then
            register.Fields.Add2 cscDbcoiId, csNew, csInteger
          Else
            register.Fields.Add2 cscDbcoiId, Val(Cell.Value), csInteger
          End If
        Case KI_DESCRIP
          register.Fields.Add2 cscDbcoiDescrip, Cell.Value, csText
        Case KI_CUE_ID_HABER
          register.Fields.Add2 cscCueId, Cell.Id, csId
        Case KI_IMPORTE
          Origen = Cell.Value
      End Select
    Next
    
    register.Fields.Add2 cscDbcoiImporte, Origen * Cotizacion, csCurrency
    If bMonedaLegal Then
      register.Fields.Add2 cscDbcoiImporteorigen, 0, csCurrency
    Else
      register.Fields.Add2 cscDbcoiImporteorigen, Origen, csCurrency
    End If
    
    m_iOrden = m_iOrden + 1
    register.Fields.Add2 cscDbcoiOrden, m_iOrden, csInteger
    register.Fields.Add2 cscDbcoiTipo, csEDepositoBancoItemTipo.csDbcoiTEfectivo, csInteger
    register.Fields.Add2 cscDbcoTMPId, Id, csId
    
    register.Fields.HaveLastUpdate = False
    register.Fields.HaveWhoModify = False
    
    If Not gDB.Save(register, , "pSaveEfectivo", C_Module, c_ErrorSave) Then Exit Function
  Next
  
  Dim sqlstmt As String
  
  If m_EfectivoDeleted <> vbNullString And m_Id <> csNO_ID And Not m_Copy Then
  
    Dim vDeletes As Variant
    Dim i As Long
    
    m_EfectivoDeleted = RemoveLastColon(m_EfectivoDeleted)
    vDeletes = Split(m_EfectivoDeleted, ",")
    
    For i = 0 To UBound(vDeletes)
    
      Set register = New cRegister
      register.fieldId = cscDbcoibTMPId
      register.Table = csTDepositoBancoItemBorradoTMP
      register.Id = csNew
      
      register.Fields.Add2 cscDbcoiId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscDbcoId, m_Id, csId
      register.Fields.Add2 cscDbcoTMPId, Id, csId
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSaveEfectivo", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveEfectivo = True
End Function

Private Function pSaveCheques(ByVal Id As Long) As Boolean
  Dim register  As cRegister
  Dim IProperty As cIABMProperty

  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue

  For Each Row In pGetCheques().Rows

    Set register = New cRegister
    register.fieldId = cscDbcoiTMPId
    register.Table = csTDepositoBancoItemTMP
    register.Id = csNew

    For Each Cell In Row
      Select Case Cell.Key

        Case KI_DBCOI_ID
          If m_Copy Then
            register.Fields.Add2 cscDbcoiId, csNew, csInteger
          Else
            register.Fields.Add2 cscDbcoiId, Val(Cell.Value), csInteger
          End If
        Case KICH_DESCRIP
          register.Fields.Add2 cscDbcoiDescrip, Cell.Value, csText

        Case KICH_CHEQUERA
          register.Fields.Add2 cscChqId, Cell.Id, csId

        Case KICH_CHEQUE
          register.Fields.Add2 cscDbcoiTMPCheque, Cell.Value, csText
        
        Case KICH_CHEQ_ID
          register.Fields.Add2 cscCheqId, Cell.Id, csId

        Case KICH_CLE_ID
          register.Fields.Add2 cscCleId, Cell.Id, csId

        Case KICH_FECHACOBRO
          register.Fields.Add2 cscDbcoiTMPFechaCobro, Cell.Value, csDate
        
        Case KICH_FECHAVTO
          register.Fields.Add2 cscDbcoiTMPFechaVto, Cell.Value, csDate

        Case KI_CUE_ID_HABER
          register.Fields.Add2 cscCueId, Cell.Id, csId
        
        Case KICH_IMPORTEORIGEN
          register.Fields.Add2 cscDbcoiImporteorigen, Val(Cell.Value), csCurrency
        
        Case KICH_IMPORTE
          register.Fields.Add2 cscDbcoiImporte, Val(Cell.Value), csCurrency
      
      End Select
    Next

    m_iOrden = m_iOrden + 1
    register.Fields.Add2 cscDbcoiOrden, m_iOrden, csInteger
    register.Fields.Add2 cscDbcoiTipo, csEDepositoBancoItemTipo.csDbcoiTCheques, csInteger
    register.Fields.Add2 cscDbcoTMPId, Id, csId

    register.Fields.HaveLastUpdate = False
    register.Fields.HaveWhoModify = False

    If Not gDB.Save(register, , "pSaveCheques", C_Module, c_ErrorSave) Then Exit Function
  Next

  Dim sqlstmt As String

  If m_ChequesDeleted <> vbNullString And m_Id <> csNO_ID And Not m_Copy Then

    Dim vDeletes As Variant
    Dim i As Long

    m_ChequesDeleted = RemoveLastColon(m_ChequesDeleted)
    vDeletes = Split(m_ChequesDeleted, ",")

    For i = 0 To UBound(vDeletes)

      Set register = New cRegister
      register.fieldId = cscDbcoibTMPId
      register.Table = csTDepositoBancoItemBorradoTMP
      register.Id = csNew

      register.Fields.Add2 cscDbcoiId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscDbcoId, m_Id, csId
      register.Fields.Add2 cscDbcoTMPId, Id, csId

      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False

      If Not gDB.Save(register, , "pSaveCheques", C_Module, c_ErrorSave) Then Exit Function
    Next

  End If

  pSaveCheques = True
End Function

Private Function pSaveTCheques(ByVal Id As Long, ByVal Cotizacion As Double, ByVal bMonedaLegal As Boolean) As Boolean
  Dim register  As cRegister
  Dim Origen    As Double
        
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  For Each Row In m_Items.Properties(c_ChequesT).Grid.Rows
  
    Set register = New cRegister
    register.fieldId = cscDbcoiTMPId
    register.Table = csTDepositoBancoItemTMP
    register.Id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KI_DBCOI_ID
          If m_Copy Then
            register.Fields.Add2 cscDbcoiId, csNew, csInteger
          Else
            register.Fields.Add2 cscDbcoiId, Val(Cell.Value), csInteger
          End If
        Case KI_DESCRIP
          register.Fields.Add2 cscDbcoiDescrip, Cell.Value, csText
        Case KI_CUE_ID
          register.Fields.Add2 cscCueId, Cell.Id, csId
        Case KI_CHEQ_ID
          register.Fields.Add2 cscCheqId, Cell.Id, csId
        Case KI_IMPORTE
          Origen = Cell.Value
      End Select
    Next
    
    register.Fields.Add2 cscDbcoiImporte, Origen * Cotizacion, csCurrency
    If bMonedaLegal Then
      register.Fields.Add2 cscDbcoiImporteorigen, 0, csCurrency
    Else
      register.Fields.Add2 cscDbcoiImporteorigen, Origen, csCurrency
    End If
    
    m_iOrden = m_iOrden + 1
    register.Fields.Add2 cscDbcoiOrden, m_iOrden, csInteger
    register.Fields.Add2 cscDbcoiTipo, csEDepositoBancoItemTipo.csDbcoiTChequesT, csInteger
    register.Fields.Add2 cscDbcoTMPId, Id, csId
    
    register.Fields.HaveLastUpdate = False
    register.Fields.HaveWhoModify = False
    
    If Not gDB.Save(register, , "pSaveChequesT", C_Module, c_ErrorSave) Then Exit Function
  Next
  
  Dim sqlstmt As String
  
  If Len(m_TChequesDeleted) And m_Id <> csNO_ID And Not m_Copy Then
  
    Dim vDeletes As Variant
    Dim i As Long
    
    m_TChequesDeleted = RemoveLastColon(m_TChequesDeleted)
    vDeletes = Split(m_TChequesDeleted, ",")
    
    For i = 0 To UBound(vDeletes)
    
      Set register = New cRegister
      register.fieldId = cscDbcoibTMPId
      register.Table = csTDepositoBancoItemBorradoTMP
      register.Id = csNew
      
      register.Fields.Add2 cscDbcoiId, Val(vDeletes(i)), csInteger
      register.Fields.Add2 cscDbcoId, m_Id, csId
      register.Fields.Add2 cscDbcoTMPId, Id, csId
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSaveChequesT", C_Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  pSaveTCheques = True
End Function

' Reglas del Objeto de Negocios
Private Sub pShowTotales()
  Dim Total     As Double
  Dim Row       As CSInterfacesABM.cIABMGridRow
  
  For Each Row In pGetCheques.Rows
    Total = Total + Val(pCell(Row, KICH_IMPORTE).Value)
  Next
  
  For Each Row In pGetTCheques.Rows
    Total = Total + Val(pCell(Row, KI_IMPORTE).Value)
  Next
  
  For Each Row In pGetEfectivo.Rows
    Total = Total + Val(pCell(Row, KI_IMPORTE).Value)
  Next
  
  m_Footer.Properties.Item(cscDbcoTotal).Value = Total
  
  m_Footer.ShowValue m_Footer.Properties.Item(cscDbcoTotal)
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
  
  Dim AbmGen  As cABMGeneric
  
  Set AbmGen = m_Items
  AbmGen.RefreshEnabledState m_Items.Properties

  Set AbmGen = m_ObjAbm
  AbmGen.RefreshEnabledState m_ObjAbm.Properties
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
  
  sqlstmt = "sp_DocDepositoBancoFirmar " & m_Id & "," & Us_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_est_id = gDB.ValField(rs.Fields, cscEstId)
  m_Estado = gDB.ValField(rs.Fields, cscEstNombre)
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties(csDocEstateID)
  
  With iProp
    .HelpId = m_est_id
    .Value = m_Estado
  End With
  
  gDB.GetData csTDepositoBanco, cscDbcoId, m_Id, cscDbcoFirmado, m_Firmado
  
  m_ObjAbm.ShowValue iProp
  
  pFirmar = True
End Function

Private Function pMove(ByVal MoveTo As ABM_MSG) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim doc_id  As Long
  
  doc_id = m_ObjAbm.Properties(cscDocId).HelpId
  
  If doc_id = csNO_ID Then MsgInfo LNGGetText(1595, vbNullString) 'Debe seleccionar un documento
  
  sqlstmt = "sp_DocDepositoBancoMover " & MoveTo & "," & m_Numero & "," & doc_id
  
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
        
        ' Cargo un registro vacio
        '
        Load csNO_ID
        
        ' Refresco el formulario
        '
        pRefreshProperties
    
        ' Obtengo un nuevo numero de comprobante
        '
        GetDocNumber m_LastDoc, m_ObjAbm, m_TaPropuesto, cscDbcoNrodoc
    
    End Select
    
  Else
    If Not Load(gDB.ValField(rs.Fields, 0)) Then Exit Function
    
    pRefreshProperties
  End If
  
  pMove = True
End Function

Private Sub pRefreshProperties()
  Dim c             As cIABMProperty
  Dim AbmGen        As cABMGeneric
  Dim Filter        As String
  Dim Cotizacion    As Double
  
  With m_ObjAbm.Properties
  
    Set c = .Item(cscDocId)
    c.HelpId = m_doc_id
    c.Value = m_Documento
    
    Set c = .Item(cscDbcoFecha)
    c.Value = m_Fecha
    
    Set c = .Item(cscBcoId)
    c.HelpId = m_bco_id
    c.Value = m_banco
    
    Set c = .Item(cscCueId)
    c.HelpId = m_cue_id
    c.Value = m_cuenta
    c.HelpFilter = pGetFilterCuenta(m_ObjAbm.Properties(cscBcoId).HelpId)
    
    Set c = .Item(csDocNumberID)
    c.Value = m_Numero
    
    Set c = .Item(csDocEstateID)
    c.Value = m_Estado
    
    Set c = .Item(cscDbcoNrodoc)
    c.Value = m_Nrodoc
    c.TextMask = m_TaMascara
    c.TextAlign = vbRightJustify
    
    Set c = .Item(cscDbcoCotizacion)
    c.Value = m_Cotizacion
    
    Set c = .Item(cscSucId)
    c.HelpId = m_suc_id
    c.Value = m_Sucursal
    
    Set c = .Item(cscLgjId)
    c.HelpId = m_lgj_id
    c.Value = m_Legajo
    
    Set c = .Item(cscDbcoDescrip)
    c.Value = m_Descrip
  
  End With
  
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValues m_ObjAbm.Properties
  
  AbmGen.ResetChanged
  
  If m_Cotizacion <> 0 Then
    Cotizacion = m_Cotizacion
  Else
    Cotizacion = 1
  End If
  
  Set c = m_Items.Properties.Item(c_Efectivo)
  If Not pLoadEfectivo(c, Cotizacion) Then Exit Sub
  
  m_EfectivoDeleted = vbNullString
  
  Set c = m_Items.Properties.Item(c_Cheques)
  If Not pLoadCheques(c) Then Exit Sub
  
  m_ChequesDeleted = vbNullString
  
  Set c = m_Items.Properties.Item(c_ChequesT)
  If Not pLoadTCheques(c, Cotizacion) Then Exit Sub
  
  m_TChequesDeleted = vbNullString
  
  Set AbmGen = m_Items
  AbmGen.ShowValues m_Items.Properties
  
  AbmGen.RefreshColumnProperties c, c_colcheque
  
  Set c = m_Footer.Properties.Item(cscDbcoTotal)
  c.Value = m_Total
  
  Set AbmGen = m_Footer
  AbmGen.ShowValues m_Footer.Properties
  
  pSetEnabled
End Sub

Private Function pGetFilterCuenta(ByVal bco_id As Long) As String
  Dim Filter As String
  
  Filter = cscCuecId & " = " & csECuentaCategoria.csECuecBancos _
          & " and cuenta.emp_id = " & EmpId
          
  If bco_id Then
    Filter = Filter & " and bco_id = " & bco_id
  End If
                     
  pGetFilterCuenta = Filter
End Function

Private Function pGetFilterCuentaItem() As String
  pGetFilterCuentaItem = cscCuecId & " = " & csECuentaCategoria.csECuecCaja
End Function

Private Function pGetFilterCheque(ByVal CheqIds As String) As String
  Dim rtn As String
  
  rtn = cscCuecId & " = " & csECuentaCategoria.csECuecDocEnCartera _
        & " and cuenta.emp_id = " & EmpId
  If CheqIds <> vbNullString Then
    rtn = "(" & rtn & ") Or (cheq_id in (" & CheqIds & "))"
  End If
  
  pGetFilterCheque = rtn
End Function

Private Sub pSetChequeData(ByRef Row As cIABMGridRow, ByVal cheq_id As Long)
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  If cheq_id = pCell(Row, KI_CHEQ_ID_SAVED).Id Then Exit Sub
  
  sqlstmt = "sp_chequeGetData " & cheq_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
  
    With pCell(Row, KI_CUE_ID)
      .Id = gDB.ValField(rs.Fields, cscCueId)
      .Value = gDB.ValField(rs.Fields, cscCueNombre)
    End With
  
    With pCell(Row, KI_BCO_ID)
      .Value = gDB.ValField(rs.Fields, cscBcoNombre)
    End With
    
    pCell(Row, KI_IMPORTE).Value = gDB.ValField(rs.Fields, cscCheqImporte)
    pCell(Row, KI_IMPORTE_ORIGEN).Value = gDB.ValField(rs.Fields, cscCheqImporteOrigen)
  
  Else
    
    With pCell(Row, KI_CUE_ID)
      .Id = csNO_ID
      .Value = vbNullString
    End With
  
    With pCell(Row, KI_BCO_ID)
      .Value = vbNullString
    End With
    
    pCell(Row, KI_IMPORTE).Value = 0
    pCell(Row, KI_IMPORTE_ORIGEN).Value = 0
  End If
End Sub

Private Function pGetCotizacion() As cIABMProperty
  Set pGetCotizacion = m_ObjAbm.Properties.Item(cscDbcoCotizacion)
End Function

Private Function pGetTCheques() As cIABMGrid
  Set pGetTCheques = m_Items.Properties.Item(c_ChequesT).Grid
End Function

Private Function pGetCheques() As cIABMGrid
  Set pGetCheques = m_Items.Properties.Item(c_Cheques).Grid
End Function

Private Function pGetEfectivo() As cIABMGrid
  Set pGetEfectivo = m_Items.Properties.Item(c_Efectivo).Grid
End Function

' Construccion - Destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2236, vbNullString) 'Error al grabar el deposito bancario
  
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  m_MonDefault = GetMonedaDefault()

  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load
  m_UserCfg.ValidateDBCO
  
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
  Set m_GeneralConfig = Nothing
  Set m_Host = Nothing

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

Private Function pGetCuenta() As cIABMProperty
  Set pGetCuenta = m_ObjAbm.Properties.Item(cscCueId)
End Function

Private Function pGetBanco() As cIABMProperty
  Set pGetBanco = m_ObjAbm.Properties.Item(cscBcoId)
End Function

Private Sub pShowBanco()
  Dim bco_id As Long
  Dim bco_nombre As String
  Dim Cue_id As Long
  
  Cue_id = pGetCuenta().HelpId
  
  If Cue_id Then
  
    gDB.GetData csTCuenta, cscCueId, Cue_id, cscBcoId, bco_id
    gDB.GetData csTBanco, cscBcoId, bco_id, cscBcoNombre, bco_nombre
  
  End If
  
  Dim iProp As cIABMProperty
  Set iProp = pGetBanco()
  iProp.Value = bco_nombre
  iProp.HelpId = bco_id
  m_ObjAbm.ShowValue iProp
  
  Dim ObjAbm As cABMGeneric
  Set ObjAbm = m_ObjAbm
  ObjAbm.ValidateProp iProp, cscBcoId
  
  m_LastBco = bco_id
  m_LastBcoName = bco_nombre
End Sub
